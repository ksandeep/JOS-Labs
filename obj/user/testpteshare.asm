
obj/user/testpteshare:     file format elf32-i386


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
  80002c:	e8 87 01 00 00       	call   8001b8 <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>
	...

00800034 <childofspawn>:
	breakpoint();
}

void
childofspawn(void)
{
  800034:	55                   	push   %ebp
  800035:	89 e5                	mov    %esp,%ebp
  800037:	83 ec 18             	sub    $0x18,%esp
	strcpy(VA, msg2);
  80003a:	a1 04 70 80 00       	mov    0x807004,%eax
  80003f:	89 44 24 04          	mov    %eax,0x4(%esp)
  800043:	c7 04 24 00 00 00 a0 	movl   $0xa0000000,(%esp)
  80004a:	e8 5b 09 00 00       	call   8009aa <strcpy>
	exit();
  80004f:	e8 b4 01 00 00       	call   800208 <exit>
}
  800054:	c9                   	leave  
  800055:	c3                   	ret    

00800056 <umain>:

void childofspawn(void);

void
umain(int argc, char **argv)
{
  800056:	55                   	push   %ebp
  800057:	89 e5                	mov    %esp,%ebp
  800059:	53                   	push   %ebx
  80005a:	83 ec 14             	sub    $0x14,%esp
	int r;

	if (argc != 0)
  80005d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800061:	74 05                	je     800068 <umain+0x12>
		childofspawn();
  800063:	e8 cc ff ff ff       	call   800034 <childofspawn>

	if ((r = sys_page_alloc(0, VA, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  800068:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  80006f:	00 
  800070:	c7 44 24 04 00 00 00 	movl   $0xa0000000,0x4(%esp)
  800077:	a0 
  800078:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80007f:	e8 17 11 00 00       	call   80119b <sys_page_alloc>
  800084:	85 c0                	test   %eax,%eax
  800086:	79 20                	jns    8000a8 <umain+0x52>
		panic("sys_page_alloc: %e", r);
  800088:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80008c:	c7 44 24 08 80 34 80 	movl   $0x803480,0x8(%esp)
  800093:	00 
  800094:	c7 44 24 04 13 00 00 	movl   $0x13,0x4(%esp)
  80009b:	00 
  80009c:	c7 04 24 93 34 80 00 	movl   $0x803493,(%esp)
  8000a3:	e8 7c 01 00 00       	call   800224 <_panic>

	// check fork
	if ((r = fork()) < 0)
  8000a8:	e8 78 13 00 00       	call   801425 <fork>
  8000ad:	89 c3                	mov    %eax,%ebx
  8000af:	85 c0                	test   %eax,%eax
  8000b1:	79 20                	jns    8000d3 <umain+0x7d>
		panic("fork: %e", r);
  8000b3:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8000b7:	c7 44 24 08 a7 34 80 	movl   $0x8034a7,0x8(%esp)
  8000be:	00 
  8000bf:	c7 44 24 04 17 00 00 	movl   $0x17,0x4(%esp)
  8000c6:	00 
  8000c7:	c7 04 24 93 34 80 00 	movl   $0x803493,(%esp)
  8000ce:	e8 51 01 00 00       	call   800224 <_panic>
	if (r == 0) {
  8000d3:	85 c0                	test   %eax,%eax
  8000d5:	75 1a                	jne    8000f1 <umain+0x9b>
		strcpy(VA, msg);
  8000d7:	a1 00 70 80 00       	mov    0x807000,%eax
  8000dc:	89 44 24 04          	mov    %eax,0x4(%esp)
  8000e0:	c7 04 24 00 00 00 a0 	movl   $0xa0000000,(%esp)
  8000e7:	e8 be 08 00 00       	call   8009aa <strcpy>
		exit();
  8000ec:	e8 17 01 00 00       	call   800208 <exit>
	}
	wait(r);
  8000f1:	89 1c 24             	mov    %ebx,(%esp)
  8000f4:	e8 0b 2d 00 00       	call   802e04 <wait>
	cprintf("fork handles PTE_SHARE %s\n", strcmp(VA, msg) == 0 ? "right" : "wrong");
  8000f9:	a1 00 70 80 00       	mov    0x807000,%eax
  8000fe:	89 44 24 04          	mov    %eax,0x4(%esp)
  800102:	c7 04 24 00 00 00 a0 	movl   $0xa0000000,(%esp)
  800109:	e8 2b 09 00 00       	call   800a39 <strcmp>
  80010e:	ba b6 34 80 00       	mov    $0x8034b6,%edx
  800113:	85 c0                	test   %eax,%eax
  800115:	74 05                	je     80011c <umain+0xc6>
  800117:	ba b0 34 80 00       	mov    $0x8034b0,%edx
  80011c:	89 54 24 04          	mov    %edx,0x4(%esp)
  800120:	c7 04 24 bc 34 80 00 	movl   $0x8034bc,(%esp)
  800127:	e8 bd 01 00 00       	call   8002e9 <cprintf>

	// check spawn
	if ((r = spawnl("/testpteshare", "testpteshare", "arg", 0)) < 0)
  80012c:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  800133:	00 
  800134:	c7 44 24 08 d7 34 80 	movl   $0x8034d7,0x8(%esp)
  80013b:	00 
  80013c:	c7 44 24 04 dc 34 80 	movl   $0x8034dc,0x4(%esp)
  800143:	00 
  800144:	c7 04 24 db 34 80 00 	movl   $0x8034db,(%esp)
  80014b:	e8 df 23 00 00       	call   80252f <spawnl>
  800150:	85 c0                	test   %eax,%eax
  800152:	79 20                	jns    800174 <umain+0x11e>
		panic("spawn: %e", r);
  800154:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800158:	c7 44 24 08 e9 34 80 	movl   $0x8034e9,0x8(%esp)
  80015f:	00 
  800160:	c7 44 24 04 21 00 00 	movl   $0x21,0x4(%esp)
  800167:	00 
  800168:	c7 04 24 93 34 80 00 	movl   $0x803493,(%esp)
  80016f:	e8 b0 00 00 00       	call   800224 <_panic>
	wait(r);
  800174:	89 04 24             	mov    %eax,(%esp)
  800177:	e8 88 2c 00 00       	call   802e04 <wait>
	cprintf("spawn handles PTE_SHARE %s\n", strcmp(VA, msg2) == 0 ? "right" : "wrong");
  80017c:	a1 04 70 80 00       	mov    0x807004,%eax
  800181:	89 44 24 04          	mov    %eax,0x4(%esp)
  800185:	c7 04 24 00 00 00 a0 	movl   $0xa0000000,(%esp)
  80018c:	e8 a8 08 00 00       	call   800a39 <strcmp>
  800191:	ba b6 34 80 00       	mov    $0x8034b6,%edx
  800196:	85 c0                	test   %eax,%eax
  800198:	74 05                	je     80019f <umain+0x149>
  80019a:	ba b0 34 80 00       	mov    $0x8034b0,%edx
  80019f:	89 54 24 04          	mov    %edx,0x4(%esp)
  8001a3:	c7 04 24 f3 34 80 00 	movl   $0x8034f3,(%esp)
  8001aa:	e8 3a 01 00 00       	call   8002e9 <cprintf>
static __inline uint64_t read_tsc(void) __attribute__((always_inline));

static __inline void
breakpoint(void)
{
	__asm __volatile("int3");
  8001af:	cc                   	int3   

	breakpoint();
}
  8001b0:	83 c4 14             	add    $0x14,%esp
  8001b3:	5b                   	pop    %ebx
  8001b4:	5d                   	pop    %ebp
  8001b5:	c3                   	ret    
	...

008001b8 <libmain>:
volatile struct Env *env;
char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  8001b8:	55                   	push   %ebp
  8001b9:	89 e5                	mov    %esp,%ebp
  8001bb:	83 ec 18             	sub    $0x18,%esp
  8001be:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  8001c1:	89 75 fc             	mov    %esi,-0x4(%ebp)
  8001c4:	8b 75 08             	mov    0x8(%ebp),%esi
  8001c7:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	// set env to point at our env structure in envs[].
	// LAB 3b: Your code here.
	// Code added by Swastika / Sandeep	
	envid_t envid = sys_getenvid();
  8001ca:	e8 5f 10 00 00       	call   80122e <sys_getenvid>
	env = &envs[ENVX(envid)];
  8001cf:	25 ff 03 00 00       	and    $0x3ff,%eax
  8001d4:	6b c0 7c             	imul   $0x7c,%eax,%eax
  8001d7:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8001dc:	a3 7c 70 80 00       	mov    %eax,0x80707c

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8001e1:	85 f6                	test   %esi,%esi
  8001e3:	7e 07                	jle    8001ec <libmain+0x34>
		binaryname = argv[0];
  8001e5:	8b 03                	mov    (%ebx),%eax
  8001e7:	a3 08 70 80 00       	mov    %eax,0x807008

	// call user main routine
	umain(argc, argv);
  8001ec:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8001f0:	89 34 24             	mov    %esi,(%esp)
  8001f3:	e8 5e fe ff ff       	call   800056 <umain>

	// exit gracefully
	exit();
  8001f8:	e8 0b 00 00 00       	call   800208 <exit>
}
  8001fd:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  800200:	8b 75 fc             	mov    -0x4(%ebp),%esi
  800203:	89 ec                	mov    %ebp,%esp
  800205:	5d                   	pop    %ebp
  800206:	c3                   	ret    
	...

00800208 <exit>:
#include <inc/lib.h>

void
exit(void)
{
  800208:	55                   	push   %ebp
  800209:	89 e5                	mov    %esp,%ebp
  80020b:	83 ec 18             	sub    $0x18,%esp
	close_all();
  80020e:	e8 48 19 00 00       	call   801b5b <close_all>
	sys_env_destroy(0);
  800213:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80021a:	e8 43 10 00 00       	call   801262 <sys_env_destroy>
}
  80021f:	c9                   	leave  
  800220:	c3                   	ret    
  800221:	00 00                	add    %al,(%eax)
	...

00800224 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  800224:	55                   	push   %ebp
  800225:	89 e5                	mov    %esp,%ebp
  800227:	53                   	push   %ebx
  800228:	83 ec 14             	sub    $0x14,%esp
 * Panic is called on unresolvable fatal errors.
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
  80022b:	8d 5d 14             	lea    0x14(%ebp),%ebx
	va_list ap;

	va_start(ap, fmt);

	// Print the panic message
	if (argv0)
  80022e:	a1 80 70 80 00       	mov    0x807080,%eax
  800233:	85 c0                	test   %eax,%eax
  800235:	74 10                	je     800247 <_panic+0x23>
		cprintf("%s: ", argv0);
  800237:	89 44 24 04          	mov    %eax,0x4(%esp)
  80023b:	c7 04 24 44 35 80 00 	movl   $0x803544,(%esp)
  800242:	e8 a2 00 00 00       	call   8002e9 <cprintf>
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  800247:	8b 45 0c             	mov    0xc(%ebp),%eax
  80024a:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80024e:	8b 45 08             	mov    0x8(%ebp),%eax
  800251:	89 44 24 08          	mov    %eax,0x8(%esp)
  800255:	a1 08 70 80 00       	mov    0x807008,%eax
  80025a:	89 44 24 04          	mov    %eax,0x4(%esp)
  80025e:	c7 04 24 49 35 80 00 	movl   $0x803549,(%esp)
  800265:	e8 7f 00 00 00       	call   8002e9 <cprintf>
	vcprintf(fmt, ap);
  80026a:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  80026e:	8b 45 10             	mov    0x10(%ebp),%eax
  800271:	89 04 24             	mov    %eax,(%esp)
  800274:	e8 0f 00 00 00       	call   800288 <vcprintf>
	cprintf("\n");
  800279:	c7 04 24 23 3c 80 00 	movl   $0x803c23,(%esp)
  800280:	e8 64 00 00 00       	call   8002e9 <cprintf>

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  800285:	cc                   	int3   
  800286:	eb fd                	jmp    800285 <_panic+0x61>

00800288 <vcprintf>:
	b->cnt++;
}

int
vcprintf(const char *fmt, va_list ap)
{
  800288:	55                   	push   %ebp
  800289:	89 e5                	mov    %esp,%ebp
  80028b:	81 ec 28 01 00 00    	sub    $0x128,%esp
	struct printbuf b;

	b.idx = 0;
  800291:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800298:	00 00 00 
	b.cnt = 0;
  80029b:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8002a2:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  8002a5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8002a8:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8002ac:	8b 45 08             	mov    0x8(%ebp),%eax
  8002af:	89 44 24 08          	mov    %eax,0x8(%esp)
  8002b3:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8002b9:	89 44 24 04          	mov    %eax,0x4(%esp)
  8002bd:	c7 04 24 03 03 80 00 	movl   $0x800303,(%esp)
  8002c4:	e8 d4 01 00 00       	call   80049d <vprintfmt>
	sys_cputs(b.buf, b.idx);
  8002c9:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
  8002cf:	89 44 24 04          	mov    %eax,0x4(%esp)
  8002d3:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  8002d9:	89 04 24             	mov    %eax,(%esp)
  8002dc:	e8 bf 0a 00 00       	call   800da0 <sys_cputs>

	return b.cnt;
}
  8002e1:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  8002e7:	c9                   	leave  
  8002e8:	c3                   	ret    

008002e9 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  8002e9:	55                   	push   %ebp
  8002ea:	89 e5                	mov    %esp,%ebp
  8002ec:	83 ec 18             	sub    $0x18,%esp

	return b.cnt;
}

int
cprintf(const char *fmt, ...)
  8002ef:	8d 45 0c             	lea    0xc(%ebp),%eax
{
	va_list ap;
	int cnt;

	va_start(ap, fmt);
	cnt = vcprintf(fmt, ap);
  8002f2:	89 44 24 04          	mov    %eax,0x4(%esp)
  8002f6:	8b 45 08             	mov    0x8(%ebp),%eax
  8002f9:	89 04 24             	mov    %eax,(%esp)
  8002fc:	e8 87 ff ff ff       	call   800288 <vcprintf>
	va_end(ap);

	return cnt;
}
  800301:	c9                   	leave  
  800302:	c3                   	ret    

00800303 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  800303:	55                   	push   %ebp
  800304:	89 e5                	mov    %esp,%ebp
  800306:	53                   	push   %ebx
  800307:	83 ec 14             	sub    $0x14,%esp
  80030a:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  80030d:	8b 03                	mov    (%ebx),%eax
  80030f:	8b 55 08             	mov    0x8(%ebp),%edx
  800312:	88 54 03 08          	mov    %dl,0x8(%ebx,%eax,1)
  800316:	83 c0 01             	add    $0x1,%eax
  800319:	89 03                	mov    %eax,(%ebx)
	if (b->idx == 256-1) {
  80031b:	3d ff 00 00 00       	cmp    $0xff,%eax
  800320:	75 19                	jne    80033b <putch+0x38>
		sys_cputs(b->buf, b->idx);
  800322:	c7 44 24 04 ff 00 00 	movl   $0xff,0x4(%esp)
  800329:	00 
  80032a:	8d 43 08             	lea    0x8(%ebx),%eax
  80032d:	89 04 24             	mov    %eax,(%esp)
  800330:	e8 6b 0a 00 00       	call   800da0 <sys_cputs>
		b->idx = 0;
  800335:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
	}
	b->cnt++;
  80033b:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  80033f:	83 c4 14             	add    $0x14,%esp
  800342:	5b                   	pop    %ebx
  800343:	5d                   	pop    %ebp
  800344:	c3                   	ret    
	...

00800350 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800350:	55                   	push   %ebp
  800351:	89 e5                	mov    %esp,%ebp
  800353:	57                   	push   %edi
  800354:	56                   	push   %esi
  800355:	53                   	push   %ebx
  800356:	83 ec 4c             	sub    $0x4c,%esp
  800359:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80035c:	89 d6                	mov    %edx,%esi
  80035e:	8b 45 08             	mov    0x8(%ebp),%eax
  800361:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800364:	8b 55 0c             	mov    0xc(%ebp),%edx
  800367:	89 55 e0             	mov    %edx,-0x20(%ebp)
  80036a:	8b 45 10             	mov    0x10(%ebp),%eax
  80036d:	8b 5d 14             	mov    0x14(%ebp),%ebx
  800370:	8b 7d 18             	mov    0x18(%ebp),%edi
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800373:	89 45 dc             	mov    %eax,-0x24(%ebp)
  800376:	b9 00 00 00 00       	mov    $0x0,%ecx
  80037b:	39 d1                	cmp    %edx,%ecx
  80037d:	72 15                	jb     800394 <printnum+0x44>
  80037f:	77 07                	ja     800388 <printnum+0x38>
  800381:	8b 55 d8             	mov    -0x28(%ebp),%edx
  800384:	39 d0                	cmp    %edx,%eax
  800386:	76 0c                	jbe    800394 <printnum+0x44>
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800388:	83 eb 01             	sub    $0x1,%ebx
  80038b:	85 db                	test   %ebx,%ebx
  80038d:	8d 76 00             	lea    0x0(%esi),%esi
  800390:	7f 61                	jg     8003f3 <printnum+0xa3>
  800392:	eb 70                	jmp    800404 <printnum+0xb4>
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800394:	89 7c 24 10          	mov    %edi,0x10(%esp)
  800398:	83 eb 01             	sub    $0x1,%ebx
  80039b:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  80039f:	89 44 24 08          	mov    %eax,0x8(%esp)
  8003a3:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  8003a7:	8b 5c 24 0c          	mov    0xc(%esp),%ebx
  8003ab:	89 4d d0             	mov    %ecx,-0x30(%ebp)
  8003ae:	89 5d d4             	mov    %ebx,-0x2c(%ebp)
  8003b1:	8b 5d dc             	mov    -0x24(%ebp),%ebx
  8003b4:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8003b8:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  8003bf:	00 
  8003c0:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8003c3:	89 04 24             	mov    %eax,(%esp)
  8003c6:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8003c9:	89 54 24 04          	mov    %edx,0x4(%esp)
  8003cd:	e8 2e 2e 00 00       	call   803200 <__udivdi3>
  8003d2:	8b 4d d0             	mov    -0x30(%ebp),%ecx
  8003d5:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
  8003d8:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8003dc:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  8003e0:	89 04 24             	mov    %eax,(%esp)
  8003e3:	89 54 24 04          	mov    %edx,0x4(%esp)
  8003e7:	89 f2                	mov    %esi,%edx
  8003e9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8003ec:	e8 5f ff ff ff       	call   800350 <printnum>
  8003f1:	eb 11                	jmp    800404 <printnum+0xb4>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  8003f3:	89 74 24 04          	mov    %esi,0x4(%esp)
  8003f7:	89 3c 24             	mov    %edi,(%esp)
  8003fa:	ff 55 e4             	call   *-0x1c(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8003fd:	83 eb 01             	sub    $0x1,%ebx
  800400:	85 db                	test   %ebx,%ebx
  800402:	7f ef                	jg     8003f3 <printnum+0xa3>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800404:	89 74 24 04          	mov    %esi,0x4(%esp)
  800408:	8b 74 24 04          	mov    0x4(%esp),%esi
  80040c:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80040f:	89 44 24 08          	mov    %eax,0x8(%esp)
  800413:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  80041a:	00 
  80041b:	8b 55 d8             	mov    -0x28(%ebp),%edx
  80041e:	89 14 24             	mov    %edx,(%esp)
  800421:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  800424:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  800428:	e8 03 2f 00 00       	call   803330 <__umoddi3>
  80042d:	89 74 24 04          	mov    %esi,0x4(%esp)
  800431:	0f be 80 65 35 80 00 	movsbl 0x803565(%eax),%eax
  800438:	89 04 24             	mov    %eax,(%esp)
  80043b:	ff 55 e4             	call   *-0x1c(%ebp)
}
  80043e:	83 c4 4c             	add    $0x4c,%esp
  800441:	5b                   	pop    %ebx
  800442:	5e                   	pop    %esi
  800443:	5f                   	pop    %edi
  800444:	5d                   	pop    %ebp
  800445:	c3                   	ret    

00800446 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800446:	55                   	push   %ebp
  800447:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800449:	83 fa 01             	cmp    $0x1,%edx
  80044c:	7e 0e                	jle    80045c <getuint+0x16>
		return va_arg(*ap, unsigned long long);
  80044e:	8b 10                	mov    (%eax),%edx
  800450:	8d 4a 08             	lea    0x8(%edx),%ecx
  800453:	89 08                	mov    %ecx,(%eax)
  800455:	8b 02                	mov    (%edx),%eax
  800457:	8b 52 04             	mov    0x4(%edx),%edx
  80045a:	eb 22                	jmp    80047e <getuint+0x38>
	else if (lflag)
  80045c:	85 d2                	test   %edx,%edx
  80045e:	74 10                	je     800470 <getuint+0x2a>
		return va_arg(*ap, unsigned long);
  800460:	8b 10                	mov    (%eax),%edx
  800462:	8d 4a 04             	lea    0x4(%edx),%ecx
  800465:	89 08                	mov    %ecx,(%eax)
  800467:	8b 02                	mov    (%edx),%eax
  800469:	ba 00 00 00 00       	mov    $0x0,%edx
  80046e:	eb 0e                	jmp    80047e <getuint+0x38>
	else
		return va_arg(*ap, unsigned int);
  800470:	8b 10                	mov    (%eax),%edx
  800472:	8d 4a 04             	lea    0x4(%edx),%ecx
  800475:	89 08                	mov    %ecx,(%eax)
  800477:	8b 02                	mov    (%edx),%eax
  800479:	ba 00 00 00 00       	mov    $0x0,%edx
}
  80047e:	5d                   	pop    %ebp
  80047f:	c3                   	ret    

00800480 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800480:	55                   	push   %ebp
  800481:	89 e5                	mov    %esp,%ebp
  800483:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  800486:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  80048a:	8b 10                	mov    (%eax),%edx
  80048c:	3b 50 04             	cmp    0x4(%eax),%edx
  80048f:	73 0a                	jae    80049b <sprintputch+0x1b>
		*b->buf++ = ch;
  800491:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800494:	88 0a                	mov    %cl,(%edx)
  800496:	83 c2 01             	add    $0x1,%edx
  800499:	89 10                	mov    %edx,(%eax)
}
  80049b:	5d                   	pop    %ebp
  80049c:	c3                   	ret    

0080049d <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  80049d:	55                   	push   %ebp
  80049e:	89 e5                	mov    %esp,%ebp
  8004a0:	57                   	push   %edi
  8004a1:	56                   	push   %esi
  8004a2:	53                   	push   %ebx
  8004a3:	83 ec 5c             	sub    $0x5c,%esp
  8004a6:	8b 7d 08             	mov    0x8(%ebp),%edi
  8004a9:	8b 75 0c             	mov    0xc(%ebp),%esi
  8004ac:	8b 5d 10             	mov    0x10(%ebp),%ebx
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  8004af:	c7 45 c8 ff ff ff ff 	movl   $0xffffffff,-0x38(%ebp)
  8004b6:	eb 11                	jmp    8004c9 <vprintfmt+0x2c>
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
  8004b8:	85 c0                	test   %eax,%eax
  8004ba:	0f 84 ec 03 00 00    	je     8008ac <vprintfmt+0x40f>
				return;
			putch(ch, putdat);
  8004c0:	89 74 24 04          	mov    %esi,0x4(%esp)
  8004c4:	89 04 24             	mov    %eax,(%esp)
  8004c7:	ff d7                	call   *%edi
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8004c9:	0f b6 03             	movzbl (%ebx),%eax
  8004cc:	83 c3 01             	add    $0x1,%ebx
  8004cf:	83 f8 25             	cmp    $0x25,%eax
  8004d2:	75 e4                	jne    8004b8 <vprintfmt+0x1b>
  8004d4:	c6 45 d4 20          	movb   $0x20,-0x2c(%ebp)
  8004d8:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
  8004df:	c7 45 d0 ff ff ff ff 	movl   $0xffffffff,-0x30(%ebp)
  8004e6:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
  8004ed:	b9 00 00 00 00       	mov    $0x0,%ecx
  8004f2:	eb 06                	jmp    8004fa <vprintfmt+0x5d>
  8004f4:	c6 45 d4 2d          	movb   $0x2d,-0x2c(%ebp)
  8004f8:	89 c3                	mov    %eax,%ebx
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8004fa:	0f b6 13             	movzbl (%ebx),%edx
  8004fd:	0f b6 c2             	movzbl %dl,%eax
  800500:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800503:	8d 43 01             	lea    0x1(%ebx),%eax
  800506:	83 ea 23             	sub    $0x23,%edx
  800509:	80 fa 55             	cmp    $0x55,%dl
  80050c:	0f 87 7d 03 00 00    	ja     80088f <vprintfmt+0x3f2>
  800512:	0f b6 d2             	movzbl %dl,%edx
  800515:	ff 24 95 a0 36 80 00 	jmp    *0x8036a0(,%edx,4)
  80051c:	c6 45 d4 30          	movb   $0x30,-0x2c(%ebp)
  800520:	eb d6                	jmp    8004f8 <vprintfmt+0x5b>
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
				precision = precision * 10 + ch - '0';
  800522:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800525:	83 ea 30             	sub    $0x30,%edx
  800528:	89 55 d0             	mov    %edx,-0x30(%ebp)
				ch = *fmt;
  80052b:	0f be 10             	movsbl (%eax),%edx
				if (ch < '0' || ch > '9')
  80052e:	8d 5a d0             	lea    -0x30(%edx),%ebx
  800531:	83 fb 09             	cmp    $0x9,%ebx
  800534:	77 4c                	ja     800582 <vprintfmt+0xe5>
  800536:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  800539:	8b 4d d0             	mov    -0x30(%ebp),%ecx
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  80053c:	83 c0 01             	add    $0x1,%eax
				precision = precision * 10 + ch - '0';
  80053f:	8d 0c 89             	lea    (%ecx,%ecx,4),%ecx
  800542:	8d 4c 4a d0          	lea    -0x30(%edx,%ecx,2),%ecx
				ch = *fmt;
  800546:	0f be 10             	movsbl (%eax),%edx
				if (ch < '0' || ch > '9')
  800549:	8d 5a d0             	lea    -0x30(%edx),%ebx
  80054c:	83 fb 09             	cmp    $0x9,%ebx
  80054f:	76 eb                	jbe    80053c <vprintfmt+0x9f>
  800551:	89 4d d0             	mov    %ecx,-0x30(%ebp)
  800554:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  800557:	eb 29                	jmp    800582 <vprintfmt+0xe5>
					break;
			}
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800559:	8b 55 14             	mov    0x14(%ebp),%edx
  80055c:	8d 5a 04             	lea    0x4(%edx),%ebx
  80055f:	89 5d 14             	mov    %ebx,0x14(%ebp)
  800562:	8b 12                	mov    (%edx),%edx
  800564:	89 55 d0             	mov    %edx,-0x30(%ebp)
			goto process_precision;
  800567:	eb 19                	jmp    800582 <vprintfmt+0xe5>

		case '.':
			if (width < 0)
  800569:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80056c:	c1 fa 1f             	sar    $0x1f,%edx
  80056f:	f7 d2                	not    %edx
  800571:	21 55 e4             	and    %edx,-0x1c(%ebp)
  800574:	eb 82                	jmp    8004f8 <vprintfmt+0x5b>
  800576:	c7 45 d8 01 00 00 00 	movl   $0x1,-0x28(%ebp)
				width = 0;
			goto reswitch;

		case '#':
			altflag = 1;
			goto reswitch;
  80057d:	e9 76 ff ff ff       	jmp    8004f8 <vprintfmt+0x5b>

		process_precision:
			if (width < 0)
  800582:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800586:	0f 89 6c ff ff ff    	jns    8004f8 <vprintfmt+0x5b>
  80058c:	8b 55 d0             	mov    -0x30(%ebp),%edx
  80058f:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  800592:	8b 55 c8             	mov    -0x38(%ebp),%edx
  800595:	89 55 d0             	mov    %edx,-0x30(%ebp)
  800598:	e9 5b ff ff ff       	jmp    8004f8 <vprintfmt+0x5b>
				width = precision, precision = -1;
			goto reswitch;

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  80059d:	83 c1 01             	add    $0x1,%ecx
			goto reswitch;
  8005a0:	e9 53 ff ff ff       	jmp    8004f8 <vprintfmt+0x5b>
  8005a5:	89 45 cc             	mov    %eax,-0x34(%ebp)

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  8005a8:	8b 45 14             	mov    0x14(%ebp),%eax
  8005ab:	8d 50 04             	lea    0x4(%eax),%edx
  8005ae:	89 55 14             	mov    %edx,0x14(%ebp)
  8005b1:	89 74 24 04          	mov    %esi,0x4(%esp)
  8005b5:	8b 00                	mov    (%eax),%eax
  8005b7:	89 04 24             	mov    %eax,(%esp)
  8005ba:	ff d7                	call   *%edi
  8005bc:	8b 5d cc             	mov    -0x34(%ebp),%ebx
			break;
  8005bf:	e9 05 ff ff ff       	jmp    8004c9 <vprintfmt+0x2c>
  8005c4:	89 45 cc             	mov    %eax,-0x34(%ebp)

		// error message
		case 'e':
			err = va_arg(ap, int);
  8005c7:	8b 45 14             	mov    0x14(%ebp),%eax
  8005ca:	8d 50 04             	lea    0x4(%eax),%edx
  8005cd:	89 55 14             	mov    %edx,0x14(%ebp)
  8005d0:	8b 00                	mov    (%eax),%eax
  8005d2:	89 c2                	mov    %eax,%edx
  8005d4:	c1 fa 1f             	sar    $0x1f,%edx
  8005d7:	31 d0                	xor    %edx,%eax
  8005d9:	29 d0                	sub    %edx,%eax
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  8005db:	83 f8 0f             	cmp    $0xf,%eax
  8005de:	7f 0b                	jg     8005eb <vprintfmt+0x14e>
  8005e0:	8b 14 85 00 38 80 00 	mov    0x803800(,%eax,4),%edx
  8005e7:	85 d2                	test   %edx,%edx
  8005e9:	75 20                	jne    80060b <vprintfmt+0x16e>
				printfmt(putch, putdat, "error %d", err);
  8005eb:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8005ef:	c7 44 24 08 76 35 80 	movl   $0x803576,0x8(%esp)
  8005f6:	00 
  8005f7:	89 74 24 04          	mov    %esi,0x4(%esp)
  8005fb:	89 3c 24             	mov    %edi,(%esp)
  8005fe:	e8 31 03 00 00       	call   800934 <printfmt>
  800603:	8b 5d cc             	mov    -0x34(%ebp),%ebx
		// error message
		case 'e':
			err = va_arg(ap, int);
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800606:	e9 be fe ff ff       	jmp    8004c9 <vprintfmt+0x2c>
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  80060b:	89 54 24 0c          	mov    %edx,0xc(%esp)
  80060f:	c7 44 24 08 38 3b 80 	movl   $0x803b38,0x8(%esp)
  800616:	00 
  800617:	89 74 24 04          	mov    %esi,0x4(%esp)
  80061b:	89 3c 24             	mov    %edi,(%esp)
  80061e:	e8 11 03 00 00       	call   800934 <printfmt>
  800623:	8b 5d cc             	mov    -0x34(%ebp),%ebx
  800626:	e9 9e fe ff ff       	jmp    8004c9 <vprintfmt+0x2c>
  80062b:	89 45 cc             	mov    %eax,-0x34(%ebp)
  80062e:	89 c3                	mov    %eax,%ebx
  800630:	8b 4d d0             	mov    -0x30(%ebp),%ecx
  800633:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800636:	89 45 c4             	mov    %eax,-0x3c(%ebp)
			break;

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800639:	8b 45 14             	mov    0x14(%ebp),%eax
  80063c:	8d 50 04             	lea    0x4(%eax),%edx
  80063f:	89 55 14             	mov    %edx,0x14(%ebp)
  800642:	8b 00                	mov    (%eax),%eax
  800644:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800647:	85 c0                	test   %eax,%eax
  800649:	75 07                	jne    800652 <vprintfmt+0x1b5>
  80064b:	c7 45 e0 7f 35 80 00 	movl   $0x80357f,-0x20(%ebp)
				p = "(null)";
			if (width > 0 && padc != '-')
  800652:	83 7d c4 00          	cmpl   $0x0,-0x3c(%ebp)
  800656:	7e 06                	jle    80065e <vprintfmt+0x1c1>
  800658:	80 7d d4 2d          	cmpb   $0x2d,-0x2c(%ebp)
  80065c:	75 13                	jne    800671 <vprintfmt+0x1d4>
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  80065e:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800661:	0f be 02             	movsbl (%edx),%eax
  800664:	85 c0                	test   %eax,%eax
  800666:	0f 85 99 00 00 00    	jne    800705 <vprintfmt+0x268>
  80066c:	e9 86 00 00 00       	jmp    8006f7 <vprintfmt+0x25a>
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800671:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  800675:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  800678:	89 0c 24             	mov    %ecx,(%esp)
  80067b:	e8 fb 02 00 00       	call   80097b <strnlen>
  800680:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  800683:	29 c2                	sub    %eax,%edx
  800685:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  800688:	85 d2                	test   %edx,%edx
  80068a:	7e d2                	jle    80065e <vprintfmt+0x1c1>
					putch(padc, putdat);
  80068c:	0f be 4d d4          	movsbl -0x2c(%ebp),%ecx
  800690:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  800693:	89 5d c4             	mov    %ebx,-0x3c(%ebp)
  800696:	89 d3                	mov    %edx,%ebx
  800698:	89 74 24 04          	mov    %esi,0x4(%esp)
  80069c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80069f:	89 04 24             	mov    %eax,(%esp)
  8006a2:	ff d7                	call   *%edi
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  8006a4:	83 eb 01             	sub    $0x1,%ebx
  8006a7:	85 db                	test   %ebx,%ebx
  8006a9:	7f ed                	jg     800698 <vprintfmt+0x1fb>
  8006ab:	8b 5d c4             	mov    -0x3c(%ebp),%ebx
  8006ae:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  8006b5:	eb a7                	jmp    80065e <vprintfmt+0x1c1>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
  8006b7:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  8006bb:	74 18                	je     8006d5 <vprintfmt+0x238>
  8006bd:	8d 50 e0             	lea    -0x20(%eax),%edx
  8006c0:	83 fa 5e             	cmp    $0x5e,%edx
  8006c3:	76 10                	jbe    8006d5 <vprintfmt+0x238>
					putch('?', putdat);
  8006c5:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8006c9:	c7 04 24 3f 00 00 00 	movl   $0x3f,(%esp)
  8006d0:	ff 55 e0             	call   *-0x20(%ebp)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
  8006d3:	eb 0a                	jmp    8006df <vprintfmt+0x242>
					putch('?', putdat);
				else
					putch(ch, putdat);
  8006d5:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8006d9:	89 04 24             	mov    %eax,(%esp)
  8006dc:	ff 55 e0             	call   *-0x20(%ebp)
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8006df:	83 6d e4 01          	subl   $0x1,-0x1c(%ebp)
  8006e3:	0f be 03             	movsbl (%ebx),%eax
  8006e6:	85 c0                	test   %eax,%eax
  8006e8:	74 05                	je     8006ef <vprintfmt+0x252>
  8006ea:	83 c3 01             	add    $0x1,%ebx
  8006ed:	eb 29                	jmp    800718 <vprintfmt+0x27b>
  8006ef:	89 fe                	mov    %edi,%esi
  8006f1:	8b 7d e0             	mov    -0x20(%ebp),%edi
  8006f4:	8b 5d d0             	mov    -0x30(%ebp),%ebx
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  8006f7:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8006fb:	7f 2e                	jg     80072b <vprintfmt+0x28e>
  8006fd:	8b 5d cc             	mov    -0x34(%ebp),%ebx
  800700:	e9 c4 fd ff ff       	jmp    8004c9 <vprintfmt+0x2c>
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800705:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800708:	83 c2 01             	add    $0x1,%edx
  80070b:	89 7d e0             	mov    %edi,-0x20(%ebp)
  80070e:	89 f7                	mov    %esi,%edi
  800710:	8b 75 d0             	mov    -0x30(%ebp),%esi
  800713:	89 5d d0             	mov    %ebx,-0x30(%ebp)
  800716:	89 d3                	mov    %edx,%ebx
  800718:	85 f6                	test   %esi,%esi
  80071a:	78 9b                	js     8006b7 <vprintfmt+0x21a>
  80071c:	83 ee 01             	sub    $0x1,%esi
  80071f:	79 96                	jns    8006b7 <vprintfmt+0x21a>
  800721:	89 fe                	mov    %edi,%esi
  800723:	8b 7d e0             	mov    -0x20(%ebp),%edi
  800726:	8b 5d d0             	mov    -0x30(%ebp),%ebx
  800729:	eb cc                	jmp    8006f7 <vprintfmt+0x25a>
  80072b:	89 5d d8             	mov    %ebx,-0x28(%ebp)
  80072e:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
				putch(' ', putdat);
  800731:	89 74 24 04          	mov    %esi,0x4(%esp)
  800735:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  80073c:	ff d7                	call   *%edi
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  80073e:	83 eb 01             	sub    $0x1,%ebx
  800741:	85 db                	test   %ebx,%ebx
  800743:	7f ec                	jg     800731 <vprintfmt+0x294>
  800745:	8b 5d d8             	mov    -0x28(%ebp),%ebx
  800748:	e9 7c fd ff ff       	jmp    8004c9 <vprintfmt+0x2c>
  80074d:	89 45 cc             	mov    %eax,-0x34(%ebp)
// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
	if (lflag >= 2)
  800750:	83 f9 01             	cmp    $0x1,%ecx
  800753:	7e 16                	jle    80076b <vprintfmt+0x2ce>
		return va_arg(*ap, long long);
  800755:	8b 45 14             	mov    0x14(%ebp),%eax
  800758:	8d 50 08             	lea    0x8(%eax),%edx
  80075b:	89 55 14             	mov    %edx,0x14(%ebp)
  80075e:	8b 10                	mov    (%eax),%edx
  800760:	8b 48 04             	mov    0x4(%eax),%ecx
  800763:	89 55 d8             	mov    %edx,-0x28(%ebp)
  800766:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  800769:	eb 32                	jmp    80079d <vprintfmt+0x300>
	else if (lflag)
  80076b:	85 c9                	test   %ecx,%ecx
  80076d:	74 18                	je     800787 <vprintfmt+0x2ea>
		return va_arg(*ap, long);
  80076f:	8b 45 14             	mov    0x14(%ebp),%eax
  800772:	8d 50 04             	lea    0x4(%eax),%edx
  800775:	89 55 14             	mov    %edx,0x14(%ebp)
  800778:	8b 00                	mov    (%eax),%eax
  80077a:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80077d:	89 c1                	mov    %eax,%ecx
  80077f:	c1 f9 1f             	sar    $0x1f,%ecx
  800782:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  800785:	eb 16                	jmp    80079d <vprintfmt+0x300>
	else
		return va_arg(*ap, int);
  800787:	8b 45 14             	mov    0x14(%ebp),%eax
  80078a:	8d 50 04             	lea    0x4(%eax),%edx
  80078d:	89 55 14             	mov    %edx,0x14(%ebp)
  800790:	8b 00                	mov    (%eax),%eax
  800792:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800795:	89 c2                	mov    %eax,%edx
  800797:	c1 fa 1f             	sar    $0x1f,%edx
  80079a:	89 55 dc             	mov    %edx,-0x24(%ebp)
				putch(' ', putdat);
			break;

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  80079d:	8b 4d d8             	mov    -0x28(%ebp),%ecx
  8007a0:	8b 5d dc             	mov    -0x24(%ebp),%ebx
  8007a3:	b8 0a 00 00 00       	mov    $0xa,%eax
			if ((long long) num < 0) {
  8007a8:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8007ac:	0f 89 9b 00 00 00    	jns    80084d <vprintfmt+0x3b0>
				putch('-', putdat);
  8007b2:	89 74 24 04          	mov    %esi,0x4(%esp)
  8007b6:	c7 04 24 2d 00 00 00 	movl   $0x2d,(%esp)
  8007bd:	ff d7                	call   *%edi
				num = -(long long) num;
  8007bf:	8b 4d d8             	mov    -0x28(%ebp),%ecx
  8007c2:	8b 5d dc             	mov    -0x24(%ebp),%ebx
  8007c5:	f7 d9                	neg    %ecx
  8007c7:	83 d3 00             	adc    $0x0,%ebx
  8007ca:	f7 db                	neg    %ebx
  8007cc:	b8 0a 00 00 00       	mov    $0xa,%eax
  8007d1:	eb 7a                	jmp    80084d <vprintfmt+0x3b0>
  8007d3:	89 45 cc             	mov    %eax,-0x34(%ebp)
			base = 10;
			goto number;

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  8007d6:	89 ca                	mov    %ecx,%edx
  8007d8:	8d 45 14             	lea    0x14(%ebp),%eax
  8007db:	e8 66 fc ff ff       	call   800446 <getuint>
  8007e0:	89 c1                	mov    %eax,%ecx
  8007e2:	89 d3                	mov    %edx,%ebx
  8007e4:	b8 0a 00 00 00       	mov    $0xa,%eax
			base = 10;
			goto number;
  8007e9:	eb 62                	jmp    80084d <vprintfmt+0x3b0>
  8007eb:	89 45 cc             	mov    %eax,-0x34(%ebp)
		case 'o':
			// Replace this with your code.
			// putch('X', putdat);
			// putch('X', putdat);
			// putch('X', putdat);
			num = getuint(&ap, lflag);
  8007ee:	89 ca                	mov    %ecx,%edx
  8007f0:	8d 45 14             	lea    0x14(%ebp),%eax
  8007f3:	e8 4e fc ff ff       	call   800446 <getuint>
  8007f8:	89 c1                	mov    %eax,%ecx
  8007fa:	89 d3                	mov    %edx,%ebx
  8007fc:	b8 08 00 00 00       	mov    $0x8,%eax
			base = 8;
			goto number;
  800801:	eb 4a                	jmp    80084d <vprintfmt+0x3b0>
  800803:	89 45 cc             	mov    %eax,-0x34(%ebp)
			break;

		// pointer
		case 'p':
			putch('0', putdat);
  800806:	89 74 24 04          	mov    %esi,0x4(%esp)
  80080a:	c7 04 24 30 00 00 00 	movl   $0x30,(%esp)
  800811:	ff d7                	call   *%edi
			putch('x', putdat);
  800813:	89 74 24 04          	mov    %esi,0x4(%esp)
  800817:	c7 04 24 78 00 00 00 	movl   $0x78,(%esp)
  80081e:	ff d7                	call   *%edi
			num = (unsigned long long)
  800820:	8b 45 14             	mov    0x14(%ebp),%eax
  800823:	8d 50 04             	lea    0x4(%eax),%edx
  800826:	89 55 14             	mov    %edx,0x14(%ebp)
  800829:	8b 08                	mov    (%eax),%ecx
  80082b:	bb 00 00 00 00       	mov    $0x0,%ebx
  800830:	b8 10 00 00 00       	mov    $0x10,%eax
				(uintptr_t) va_arg(ap, void *);
			base = 16;
			goto number;
  800835:	eb 16                	jmp    80084d <vprintfmt+0x3b0>
  800837:	89 45 cc             	mov    %eax,-0x34(%ebp)

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  80083a:	89 ca                	mov    %ecx,%edx
  80083c:	8d 45 14             	lea    0x14(%ebp),%eax
  80083f:	e8 02 fc ff ff       	call   800446 <getuint>
  800844:	89 c1                	mov    %eax,%ecx
  800846:	89 d3                	mov    %edx,%ebx
  800848:	b8 10 00 00 00       	mov    $0x10,%eax
			base = 16;
		number:
			printnum(putch, putdat, num, base, width, padc);
  80084d:	0f be 55 d4          	movsbl -0x2c(%ebp),%edx
  800851:	89 54 24 10          	mov    %edx,0x10(%esp)
  800855:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  800858:	89 54 24 0c          	mov    %edx,0xc(%esp)
  80085c:	89 44 24 08          	mov    %eax,0x8(%esp)
  800860:	89 0c 24             	mov    %ecx,(%esp)
  800863:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  800867:	89 f2                	mov    %esi,%edx
  800869:	89 f8                	mov    %edi,%eax
  80086b:	e8 e0 fa ff ff       	call   800350 <printnum>
  800870:	8b 5d cc             	mov    -0x34(%ebp),%ebx
			break;
  800873:	e9 51 fc ff ff       	jmp    8004c9 <vprintfmt+0x2c>
  800878:	89 45 cc             	mov    %eax,-0x34(%ebp)
  80087b:	8b 55 e0             	mov    -0x20(%ebp),%edx

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  80087e:	89 74 24 04          	mov    %esi,0x4(%esp)
  800882:	89 14 24             	mov    %edx,(%esp)
  800885:	ff d7                	call   *%edi
  800887:	8b 5d cc             	mov    -0x34(%ebp),%ebx
			break;
  80088a:	e9 3a fc ff ff       	jmp    8004c9 <vprintfmt+0x2c>
			
		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  80088f:	89 74 24 04          	mov    %esi,0x4(%esp)
  800893:	c7 04 24 25 00 00 00 	movl   $0x25,(%esp)
  80089a:	ff d7                	call   *%edi
			for (fmt--; fmt[-1] != '%'; fmt--)
  80089c:	8d 43 ff             	lea    -0x1(%ebx),%eax
  80089f:	80 38 25             	cmpb   $0x25,(%eax)
  8008a2:	0f 84 21 fc ff ff    	je     8004c9 <vprintfmt+0x2c>
  8008a8:	89 c3                	mov    %eax,%ebx
  8008aa:	eb f0                	jmp    80089c <vprintfmt+0x3ff>
				/* do nothing */;
			break;
		}
	}
}
  8008ac:	83 c4 5c             	add    $0x5c,%esp
  8008af:	5b                   	pop    %ebx
  8008b0:	5e                   	pop    %esi
  8008b1:	5f                   	pop    %edi
  8008b2:	5d                   	pop    %ebp
  8008b3:	c3                   	ret    

008008b4 <vsnprintf>:
		*b->buf++ = ch;
}

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  8008b4:	55                   	push   %ebp
  8008b5:	89 e5                	mov    %esp,%ebp
  8008b7:	83 ec 28             	sub    $0x28,%esp
  8008ba:	8b 45 08             	mov    0x8(%ebp),%eax
  8008bd:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};

	if (buf == NULL || n < 1)
  8008c0:	85 c0                	test   %eax,%eax
  8008c2:	74 04                	je     8008c8 <vsnprintf+0x14>
  8008c4:	85 d2                	test   %edx,%edx
  8008c6:	7f 07                	jg     8008cf <vsnprintf+0x1b>
  8008c8:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8008cd:	eb 3b                	jmp    80090a <vsnprintf+0x56>
}

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
	struct sprintbuf b = {buf, buf+n-1, 0};
  8008cf:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8008d2:	8d 44 10 ff          	lea    -0x1(%eax,%edx,1),%eax
  8008d6:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8008d9:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  8008e0:	8b 45 14             	mov    0x14(%ebp),%eax
  8008e3:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8008e7:	8b 45 10             	mov    0x10(%ebp),%eax
  8008ea:	89 44 24 08          	mov    %eax,0x8(%esp)
  8008ee:	8d 45 ec             	lea    -0x14(%ebp),%eax
  8008f1:	89 44 24 04          	mov    %eax,0x4(%esp)
  8008f5:	c7 04 24 80 04 80 00 	movl   $0x800480,(%esp)
  8008fc:	e8 9c fb ff ff       	call   80049d <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  800901:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800904:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800907:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  80090a:	c9                   	leave  
  80090b:	c3                   	ret    

0080090c <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  80090c:	55                   	push   %ebp
  80090d:	89 e5                	mov    %esp,%ebp
  80090f:	83 ec 18             	sub    $0x18,%esp

	return b.cnt;
}

int
snprintf(char *buf, int n, const char *fmt, ...)
  800912:	8d 45 14             	lea    0x14(%ebp),%eax
{
	va_list ap;
	int rc;

	va_start(ap, fmt);
	rc = vsnprintf(buf, n, fmt, ap);
  800915:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800919:	8b 45 10             	mov    0x10(%ebp),%eax
  80091c:	89 44 24 08          	mov    %eax,0x8(%esp)
  800920:	8b 45 0c             	mov    0xc(%ebp),%eax
  800923:	89 44 24 04          	mov    %eax,0x4(%esp)
  800927:	8b 45 08             	mov    0x8(%ebp),%eax
  80092a:	89 04 24             	mov    %eax,(%esp)
  80092d:	e8 82 ff ff ff       	call   8008b4 <vsnprintf>
	va_end(ap);

	return rc;
}
  800932:	c9                   	leave  
  800933:	c3                   	ret    

00800934 <printfmt>:
	}
}

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800934:	55                   	push   %ebp
  800935:	89 e5                	mov    %esp,%ebp
  800937:	83 ec 18             	sub    $0x18,%esp
		}
	}
}

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
  80093a:	8d 45 14             	lea    0x14(%ebp),%eax
{
	va_list ap;

	va_start(ap, fmt);
	vprintfmt(putch, putdat, fmt, ap);
  80093d:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800941:	8b 45 10             	mov    0x10(%ebp),%eax
  800944:	89 44 24 08          	mov    %eax,0x8(%esp)
  800948:	8b 45 0c             	mov    0xc(%ebp),%eax
  80094b:	89 44 24 04          	mov    %eax,0x4(%esp)
  80094f:	8b 45 08             	mov    0x8(%ebp),%eax
  800952:	89 04 24             	mov    %eax,(%esp)
  800955:	e8 43 fb ff ff       	call   80049d <vprintfmt>
	va_end(ap);
}
  80095a:	c9                   	leave  
  80095b:	c3                   	ret    
  80095c:	00 00                	add    %al,(%eax)
	...

00800960 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800960:	55                   	push   %ebp
  800961:	89 e5                	mov    %esp,%ebp
  800963:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  800966:	b8 00 00 00 00       	mov    $0x0,%eax
  80096b:	80 3a 00             	cmpb   $0x0,(%edx)
  80096e:	74 09                	je     800979 <strlen+0x19>
		n++;
  800970:	83 c0 01             	add    $0x1,%eax
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800973:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  800977:	75 f7                	jne    800970 <strlen+0x10>
		n++;
	return n;
}
  800979:	5d                   	pop    %ebp
  80097a:	c3                   	ret    

0080097b <strnlen>:

int
strnlen(const char *s, size_t size)
{
  80097b:	55                   	push   %ebp
  80097c:	89 e5                	mov    %esp,%ebp
  80097e:	53                   	push   %ebx
  80097f:	8b 5d 08             	mov    0x8(%ebp),%ebx
  800982:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800985:	85 c9                	test   %ecx,%ecx
  800987:	74 19                	je     8009a2 <strnlen+0x27>
  800989:	80 3b 00             	cmpb   $0x0,(%ebx)
  80098c:	74 14                	je     8009a2 <strnlen+0x27>
  80098e:	b8 00 00 00 00       	mov    $0x0,%eax
		n++;
  800993:	83 c0 01             	add    $0x1,%eax
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800996:	39 c8                	cmp    %ecx,%eax
  800998:	74 0d                	je     8009a7 <strnlen+0x2c>
  80099a:	80 3c 03 00          	cmpb   $0x0,(%ebx,%eax,1)
  80099e:	75 f3                	jne    800993 <strnlen+0x18>
  8009a0:	eb 05                	jmp    8009a7 <strnlen+0x2c>
  8009a2:	b8 00 00 00 00       	mov    $0x0,%eax
		n++;
	return n;
}
  8009a7:	5b                   	pop    %ebx
  8009a8:	5d                   	pop    %ebp
  8009a9:	c3                   	ret    

008009aa <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  8009aa:	55                   	push   %ebp
  8009ab:	89 e5                	mov    %esp,%ebp
  8009ad:	53                   	push   %ebx
  8009ae:	8b 45 08             	mov    0x8(%ebp),%eax
  8009b1:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  8009b4:	ba 00 00 00 00       	mov    $0x0,%edx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  8009b9:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
  8009bd:	88 0c 10             	mov    %cl,(%eax,%edx,1)
  8009c0:	83 c2 01             	add    $0x1,%edx
  8009c3:	84 c9                	test   %cl,%cl
  8009c5:	75 f2                	jne    8009b9 <strcpy+0xf>
		/* do nothing */;
	return ret;
}
  8009c7:	5b                   	pop    %ebx
  8009c8:	5d                   	pop    %ebp
  8009c9:	c3                   	ret    

008009ca <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  8009ca:	55                   	push   %ebp
  8009cb:	89 e5                	mov    %esp,%ebp
  8009cd:	56                   	push   %esi
  8009ce:	53                   	push   %ebx
  8009cf:	8b 45 08             	mov    0x8(%ebp),%eax
  8009d2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8009d5:	8b 75 10             	mov    0x10(%ebp),%esi
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  8009d8:	85 f6                	test   %esi,%esi
  8009da:	74 18                	je     8009f4 <strncpy+0x2a>
  8009dc:	b9 00 00 00 00       	mov    $0x0,%ecx
		*dst++ = *src;
  8009e1:	0f b6 1a             	movzbl (%edx),%ebx
  8009e4:	88 1c 08             	mov    %bl,(%eax,%ecx,1)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  8009e7:	80 3a 01             	cmpb   $0x1,(%edx)
  8009ea:	83 da ff             	sbb    $0xffffffff,%edx
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  8009ed:	83 c1 01             	add    $0x1,%ecx
  8009f0:	39 ce                	cmp    %ecx,%esi
  8009f2:	77 ed                	ja     8009e1 <strncpy+0x17>
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
}
  8009f4:	5b                   	pop    %ebx
  8009f5:	5e                   	pop    %esi
  8009f6:	5d                   	pop    %ebp
  8009f7:	c3                   	ret    

008009f8 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  8009f8:	55                   	push   %ebp
  8009f9:	89 e5                	mov    %esp,%ebp
  8009fb:	56                   	push   %esi
  8009fc:	53                   	push   %ebx
  8009fd:	8b 75 08             	mov    0x8(%ebp),%esi
  800a00:	8b 55 0c             	mov    0xc(%ebp),%edx
  800a03:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  800a06:	89 f0                	mov    %esi,%eax
  800a08:	85 c9                	test   %ecx,%ecx
  800a0a:	74 27                	je     800a33 <strlcpy+0x3b>
		while (--size > 0 && *src != '\0')
  800a0c:	83 e9 01             	sub    $0x1,%ecx
  800a0f:	74 1d                	je     800a2e <strlcpy+0x36>
  800a11:	0f b6 1a             	movzbl (%edx),%ebx
  800a14:	84 db                	test   %bl,%bl
  800a16:	74 16                	je     800a2e <strlcpy+0x36>
			*dst++ = *src++;
  800a18:	88 18                	mov    %bl,(%eax)
  800a1a:	83 c0 01             	add    $0x1,%eax
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800a1d:	83 e9 01             	sub    $0x1,%ecx
  800a20:	74 0e                	je     800a30 <strlcpy+0x38>
			*dst++ = *src++;
  800a22:	83 c2 01             	add    $0x1,%edx
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800a25:	0f b6 1a             	movzbl (%edx),%ebx
  800a28:	84 db                	test   %bl,%bl
  800a2a:	75 ec                	jne    800a18 <strlcpy+0x20>
  800a2c:	eb 02                	jmp    800a30 <strlcpy+0x38>
  800a2e:	89 f0                	mov    %esi,%eax
			*dst++ = *src++;
		*dst = '\0';
  800a30:	c6 00 00             	movb   $0x0,(%eax)
  800a33:	29 f0                	sub    %esi,%eax
	}
	return dst - dst_in;
}
  800a35:	5b                   	pop    %ebx
  800a36:	5e                   	pop    %esi
  800a37:	5d                   	pop    %ebp
  800a38:	c3                   	ret    

00800a39 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800a39:	55                   	push   %ebp
  800a3a:	89 e5                	mov    %esp,%ebp
  800a3c:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800a3f:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  800a42:	0f b6 01             	movzbl (%ecx),%eax
  800a45:	84 c0                	test   %al,%al
  800a47:	74 15                	je     800a5e <strcmp+0x25>
  800a49:	3a 02                	cmp    (%edx),%al
  800a4b:	75 11                	jne    800a5e <strcmp+0x25>
		p++, q++;
  800a4d:	83 c1 01             	add    $0x1,%ecx
  800a50:	83 c2 01             	add    $0x1,%edx
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800a53:	0f b6 01             	movzbl (%ecx),%eax
  800a56:	84 c0                	test   %al,%al
  800a58:	74 04                	je     800a5e <strcmp+0x25>
  800a5a:	3a 02                	cmp    (%edx),%al
  800a5c:	74 ef                	je     800a4d <strcmp+0x14>
  800a5e:	0f b6 c0             	movzbl %al,%eax
  800a61:	0f b6 12             	movzbl (%edx),%edx
  800a64:	29 d0                	sub    %edx,%eax
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
}
  800a66:	5d                   	pop    %ebp
  800a67:	c3                   	ret    

00800a68 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800a68:	55                   	push   %ebp
  800a69:	89 e5                	mov    %esp,%ebp
  800a6b:	53                   	push   %ebx
  800a6c:	8b 55 08             	mov    0x8(%ebp),%edx
  800a6f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800a72:	8b 45 10             	mov    0x10(%ebp),%eax
	while (n > 0 && *p && *p == *q)
  800a75:	85 c0                	test   %eax,%eax
  800a77:	74 23                	je     800a9c <strncmp+0x34>
  800a79:	0f b6 1a             	movzbl (%edx),%ebx
  800a7c:	84 db                	test   %bl,%bl
  800a7e:	74 24                	je     800aa4 <strncmp+0x3c>
  800a80:	3a 19                	cmp    (%ecx),%bl
  800a82:	75 20                	jne    800aa4 <strncmp+0x3c>
  800a84:	83 e8 01             	sub    $0x1,%eax
  800a87:	74 13                	je     800a9c <strncmp+0x34>
		n--, p++, q++;
  800a89:	83 c2 01             	add    $0x1,%edx
  800a8c:	83 c1 01             	add    $0x1,%ecx
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  800a8f:	0f b6 1a             	movzbl (%edx),%ebx
  800a92:	84 db                	test   %bl,%bl
  800a94:	74 0e                	je     800aa4 <strncmp+0x3c>
  800a96:	3a 19                	cmp    (%ecx),%bl
  800a98:	74 ea                	je     800a84 <strncmp+0x1c>
  800a9a:	eb 08                	jmp    800aa4 <strncmp+0x3c>
  800a9c:	b8 00 00 00 00       	mov    $0x0,%eax
		n--, p++, q++;
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
}
  800aa1:	5b                   	pop    %ebx
  800aa2:	5d                   	pop    %ebp
  800aa3:	c3                   	ret    
	while (n > 0 && *p && *p == *q)
		n--, p++, q++;
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800aa4:	0f b6 02             	movzbl (%edx),%eax
  800aa7:	0f b6 11             	movzbl (%ecx),%edx
  800aaa:	29 d0                	sub    %edx,%eax
  800aac:	eb f3                	jmp    800aa1 <strncmp+0x39>

00800aae <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800aae:	55                   	push   %ebp
  800aaf:	89 e5                	mov    %esp,%ebp
  800ab1:	8b 45 08             	mov    0x8(%ebp),%eax
  800ab4:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800ab8:	0f b6 10             	movzbl (%eax),%edx
  800abb:	84 d2                	test   %dl,%dl
  800abd:	74 15                	je     800ad4 <strchr+0x26>
		if (*s == c)
  800abf:	38 ca                	cmp    %cl,%dl
  800ac1:	75 07                	jne    800aca <strchr+0x1c>
  800ac3:	eb 14                	jmp    800ad9 <strchr+0x2b>
  800ac5:	38 ca                	cmp    %cl,%dl
  800ac7:	90                   	nop
  800ac8:	74 0f                	je     800ad9 <strchr+0x2b>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800aca:	83 c0 01             	add    $0x1,%eax
  800acd:	0f b6 10             	movzbl (%eax),%edx
  800ad0:	84 d2                	test   %dl,%dl
  800ad2:	75 f1                	jne    800ac5 <strchr+0x17>
  800ad4:	b8 00 00 00 00       	mov    $0x0,%eax
		if (*s == c)
			return (char *) s;
	return 0;
}
  800ad9:	5d                   	pop    %ebp
  800ada:	c3                   	ret    

00800adb <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800adb:	55                   	push   %ebp
  800adc:	89 e5                	mov    %esp,%ebp
  800ade:	8b 45 08             	mov    0x8(%ebp),%eax
  800ae1:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800ae5:	0f b6 10             	movzbl (%eax),%edx
  800ae8:	84 d2                	test   %dl,%dl
  800aea:	74 18                	je     800b04 <strfind+0x29>
		if (*s == c)
  800aec:	38 ca                	cmp    %cl,%dl
  800aee:	75 0a                	jne    800afa <strfind+0x1f>
  800af0:	eb 12                	jmp    800b04 <strfind+0x29>
  800af2:	38 ca                	cmp    %cl,%dl
  800af4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  800af8:	74 0a                	je     800b04 <strfind+0x29>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800afa:	83 c0 01             	add    $0x1,%eax
  800afd:	0f b6 10             	movzbl (%eax),%edx
  800b00:	84 d2                	test   %dl,%dl
  800b02:	75 ee                	jne    800af2 <strfind+0x17>
		if (*s == c)
			break;
	return (char *) s;
}
  800b04:	5d                   	pop    %ebp
  800b05:	c3                   	ret    

00800b06 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800b06:	55                   	push   %ebp
  800b07:	89 e5                	mov    %esp,%ebp
  800b09:	83 ec 0c             	sub    $0xc,%esp
  800b0c:	89 1c 24             	mov    %ebx,(%esp)
  800b0f:	89 74 24 04          	mov    %esi,0x4(%esp)
  800b13:	89 7c 24 08          	mov    %edi,0x8(%esp)
  800b17:	8b 7d 08             	mov    0x8(%ebp),%edi
  800b1a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b1d:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800b20:	85 c9                	test   %ecx,%ecx
  800b22:	74 30                	je     800b54 <memset+0x4e>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800b24:	f7 c7 03 00 00 00    	test   $0x3,%edi
  800b2a:	75 25                	jne    800b51 <memset+0x4b>
  800b2c:	f6 c1 03             	test   $0x3,%cl
  800b2f:	75 20                	jne    800b51 <memset+0x4b>
		c &= 0xFF;
  800b31:	0f b6 d0             	movzbl %al,%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800b34:	89 d3                	mov    %edx,%ebx
  800b36:	c1 e3 08             	shl    $0x8,%ebx
  800b39:	89 d6                	mov    %edx,%esi
  800b3b:	c1 e6 18             	shl    $0x18,%esi
  800b3e:	89 d0                	mov    %edx,%eax
  800b40:	c1 e0 10             	shl    $0x10,%eax
  800b43:	09 f0                	or     %esi,%eax
  800b45:	09 d0                	or     %edx,%eax
		asm volatile("cld; rep stosl\n"
  800b47:	09 d8                	or     %ebx,%eax
  800b49:	c1 e9 02             	shr    $0x2,%ecx
  800b4c:	fc                   	cld    
  800b4d:	f3 ab                	rep stos %eax,%es:(%edi)
{
	char *p;

	if (n == 0)
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800b4f:	eb 03                	jmp    800b54 <memset+0x4e>
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800b51:	fc                   	cld    
  800b52:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800b54:	89 f8                	mov    %edi,%eax
  800b56:	8b 1c 24             	mov    (%esp),%ebx
  800b59:	8b 74 24 04          	mov    0x4(%esp),%esi
  800b5d:	8b 7c 24 08          	mov    0x8(%esp),%edi
  800b61:	89 ec                	mov    %ebp,%esp
  800b63:	5d                   	pop    %ebp
  800b64:	c3                   	ret    

00800b65 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800b65:	55                   	push   %ebp
  800b66:	89 e5                	mov    %esp,%ebp
  800b68:	83 ec 08             	sub    $0x8,%esp
  800b6b:	89 34 24             	mov    %esi,(%esp)
  800b6e:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800b72:	8b 45 08             	mov    0x8(%ebp),%eax
  800b75:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;
	
	s = src;
  800b78:	8b 75 0c             	mov    0xc(%ebp),%esi
	d = dst;
  800b7b:	89 c7                	mov    %eax,%edi
	if (s < d && s + n > d) {
  800b7d:	39 c6                	cmp    %eax,%esi
  800b7f:	73 35                	jae    800bb6 <memmove+0x51>
  800b81:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800b84:	39 d0                	cmp    %edx,%eax
  800b86:	73 2e                	jae    800bb6 <memmove+0x51>
		s += n;
		d += n;
  800b88:	01 cf                	add    %ecx,%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800b8a:	f6 c2 03             	test   $0x3,%dl
  800b8d:	75 1b                	jne    800baa <memmove+0x45>
  800b8f:	f7 c7 03 00 00 00    	test   $0x3,%edi
  800b95:	75 13                	jne    800baa <memmove+0x45>
  800b97:	f6 c1 03             	test   $0x3,%cl
  800b9a:	75 0e                	jne    800baa <memmove+0x45>
			asm volatile("std; rep movsl\n"
  800b9c:	83 ef 04             	sub    $0x4,%edi
  800b9f:	8d 72 fc             	lea    -0x4(%edx),%esi
  800ba2:	c1 e9 02             	shr    $0x2,%ecx
  800ba5:	fd                   	std    
  800ba6:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800ba8:	eb 09                	jmp    800bb3 <memmove+0x4e>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  800baa:	83 ef 01             	sub    $0x1,%edi
  800bad:	8d 72 ff             	lea    -0x1(%edx),%esi
  800bb0:	fd                   	std    
  800bb1:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800bb3:	fc                   	cld    
	const char *s;
	char *d;
	
	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800bb4:	eb 20                	jmp    800bd6 <memmove+0x71>
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800bb6:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800bbc:	75 15                	jne    800bd3 <memmove+0x6e>
  800bbe:	f7 c7 03 00 00 00    	test   $0x3,%edi
  800bc4:	75 0d                	jne    800bd3 <memmove+0x6e>
  800bc6:	f6 c1 03             	test   $0x3,%cl
  800bc9:	75 08                	jne    800bd3 <memmove+0x6e>
			asm volatile("cld; rep movsl\n"
  800bcb:	c1 e9 02             	shr    $0x2,%ecx
  800bce:	fc                   	cld    
  800bcf:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800bd1:	eb 03                	jmp    800bd6 <memmove+0x71>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  800bd3:	fc                   	cld    
  800bd4:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800bd6:	8b 34 24             	mov    (%esp),%esi
  800bd9:	8b 7c 24 04          	mov    0x4(%esp),%edi
  800bdd:	89 ec                	mov    %ebp,%esp
  800bdf:	5d                   	pop    %ebp
  800be0:	c3                   	ret    

00800be1 <memcpy>:

/* sigh - gcc emits references to this for structure assignments! */
/* it is *not* prototyped in inc/string.h - do not use directly. */
void *
memcpy(void *dst, void *src, size_t n)
{
  800be1:	55                   	push   %ebp
  800be2:	89 e5                	mov    %esp,%ebp
  800be4:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  800be7:	8b 45 10             	mov    0x10(%ebp),%eax
  800bea:	89 44 24 08          	mov    %eax,0x8(%esp)
  800bee:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bf1:	89 44 24 04          	mov    %eax,0x4(%esp)
  800bf5:	8b 45 08             	mov    0x8(%ebp),%eax
  800bf8:	89 04 24             	mov    %eax,(%esp)
  800bfb:	e8 65 ff ff ff       	call   800b65 <memmove>
}
  800c00:	c9                   	leave  
  800c01:	c3                   	ret    

00800c02 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800c02:	55                   	push   %ebp
  800c03:	89 e5                	mov    %esp,%ebp
  800c05:	57                   	push   %edi
  800c06:	56                   	push   %esi
  800c07:	53                   	push   %ebx
  800c08:	8b 75 08             	mov    0x8(%ebp),%esi
  800c0b:	8b 7d 0c             	mov    0xc(%ebp),%edi
  800c0e:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800c11:	85 c9                	test   %ecx,%ecx
  800c13:	74 36                	je     800c4b <memcmp+0x49>
		if (*s1 != *s2)
  800c15:	0f b6 06             	movzbl (%esi),%eax
  800c18:	0f b6 1f             	movzbl (%edi),%ebx
  800c1b:	38 d8                	cmp    %bl,%al
  800c1d:	74 20                	je     800c3f <memcmp+0x3d>
  800c1f:	eb 14                	jmp    800c35 <memcmp+0x33>
  800c21:	0f b6 44 16 01       	movzbl 0x1(%esi,%edx,1),%eax
  800c26:	0f b6 5c 17 01       	movzbl 0x1(%edi,%edx,1),%ebx
  800c2b:	83 c2 01             	add    $0x1,%edx
  800c2e:	83 e9 01             	sub    $0x1,%ecx
  800c31:	38 d8                	cmp    %bl,%al
  800c33:	74 12                	je     800c47 <memcmp+0x45>
			return (int) *s1 - (int) *s2;
  800c35:	0f b6 c0             	movzbl %al,%eax
  800c38:	0f b6 db             	movzbl %bl,%ebx
  800c3b:	29 d8                	sub    %ebx,%eax
  800c3d:	eb 11                	jmp    800c50 <memcmp+0x4e>
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800c3f:	83 e9 01             	sub    $0x1,%ecx
  800c42:	ba 00 00 00 00       	mov    $0x0,%edx
  800c47:	85 c9                	test   %ecx,%ecx
  800c49:	75 d6                	jne    800c21 <memcmp+0x1f>
  800c4b:	b8 00 00 00 00       	mov    $0x0,%eax
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
}
  800c50:	5b                   	pop    %ebx
  800c51:	5e                   	pop    %esi
  800c52:	5f                   	pop    %edi
  800c53:	5d                   	pop    %ebp
  800c54:	c3                   	ret    

00800c55 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800c55:	55                   	push   %ebp
  800c56:	89 e5                	mov    %esp,%ebp
  800c58:	8b 45 08             	mov    0x8(%ebp),%eax
	const void *ends = (const char *) s + n;
  800c5b:	89 c2                	mov    %eax,%edx
  800c5d:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800c60:	39 d0                	cmp    %edx,%eax
  800c62:	73 15                	jae    800c79 <memfind+0x24>
		if (*(const unsigned char *) s == (unsigned char) c)
  800c64:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
  800c68:	38 08                	cmp    %cl,(%eax)
  800c6a:	75 06                	jne    800c72 <memfind+0x1d>
  800c6c:	eb 0b                	jmp    800c79 <memfind+0x24>
  800c6e:	38 08                	cmp    %cl,(%eax)
  800c70:	74 07                	je     800c79 <memfind+0x24>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800c72:	83 c0 01             	add    $0x1,%eax
  800c75:	39 c2                	cmp    %eax,%edx
  800c77:	77 f5                	ja     800c6e <memfind+0x19>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
	return (void *) s;
}
  800c79:	5d                   	pop    %ebp
  800c7a:	c3                   	ret    

00800c7b <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800c7b:	55                   	push   %ebp
  800c7c:	89 e5                	mov    %esp,%ebp
  800c7e:	57                   	push   %edi
  800c7f:	56                   	push   %esi
  800c80:	53                   	push   %ebx
  800c81:	83 ec 04             	sub    $0x4,%esp
  800c84:	8b 55 08             	mov    0x8(%ebp),%edx
  800c87:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800c8a:	0f b6 02             	movzbl (%edx),%eax
  800c8d:	3c 20                	cmp    $0x20,%al
  800c8f:	74 04                	je     800c95 <strtol+0x1a>
  800c91:	3c 09                	cmp    $0x9,%al
  800c93:	75 0e                	jne    800ca3 <strtol+0x28>
		s++;
  800c95:	83 c2 01             	add    $0x1,%edx
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800c98:	0f b6 02             	movzbl (%edx),%eax
  800c9b:	3c 20                	cmp    $0x20,%al
  800c9d:	74 f6                	je     800c95 <strtol+0x1a>
  800c9f:	3c 09                	cmp    $0x9,%al
  800ca1:	74 f2                	je     800c95 <strtol+0x1a>
		s++;

	// plus/minus sign
	if (*s == '+')
  800ca3:	3c 2b                	cmp    $0x2b,%al
  800ca5:	75 0c                	jne    800cb3 <strtol+0x38>
		s++;
  800ca7:	83 c2 01             	add    $0x1,%edx
  800caa:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800cb1:	eb 15                	jmp    800cc8 <strtol+0x4d>
	else if (*s == '-')
  800cb3:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800cba:	3c 2d                	cmp    $0x2d,%al
  800cbc:	75 0a                	jne    800cc8 <strtol+0x4d>
		s++, neg = 1;
  800cbe:	83 c2 01             	add    $0x1,%edx
  800cc1:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800cc8:	85 db                	test   %ebx,%ebx
  800cca:	0f 94 c0             	sete   %al
  800ccd:	74 05                	je     800cd4 <strtol+0x59>
  800ccf:	83 fb 10             	cmp    $0x10,%ebx
  800cd2:	75 18                	jne    800cec <strtol+0x71>
  800cd4:	80 3a 30             	cmpb   $0x30,(%edx)
  800cd7:	75 13                	jne    800cec <strtol+0x71>
  800cd9:	80 7a 01 78          	cmpb   $0x78,0x1(%edx)
  800cdd:	8d 76 00             	lea    0x0(%esi),%esi
  800ce0:	75 0a                	jne    800cec <strtol+0x71>
		s += 2, base = 16;
  800ce2:	83 c2 02             	add    $0x2,%edx
  800ce5:	bb 10 00 00 00       	mov    $0x10,%ebx
		s++;
	else if (*s == '-')
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800cea:	eb 15                	jmp    800d01 <strtol+0x86>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  800cec:	84 c0                	test   %al,%al
  800cee:	66 90                	xchg   %ax,%ax
  800cf0:	74 0f                	je     800d01 <strtol+0x86>
  800cf2:	bb 0a 00 00 00       	mov    $0xa,%ebx
  800cf7:	80 3a 30             	cmpb   $0x30,(%edx)
  800cfa:	75 05                	jne    800d01 <strtol+0x86>
		s++, base = 8;
  800cfc:	83 c2 01             	add    $0x1,%edx
  800cff:	b3 08                	mov    $0x8,%bl
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  800d01:	b8 00 00 00 00       	mov    $0x0,%eax
  800d06:	89 de                	mov    %ebx,%esi

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  800d08:	0f b6 0a             	movzbl (%edx),%ecx
  800d0b:	89 cf                	mov    %ecx,%edi
  800d0d:	8d 59 d0             	lea    -0x30(%ecx),%ebx
  800d10:	80 fb 09             	cmp    $0x9,%bl
  800d13:	77 08                	ja     800d1d <strtol+0xa2>
			dig = *s - '0';
  800d15:	0f be c9             	movsbl %cl,%ecx
  800d18:	83 e9 30             	sub    $0x30,%ecx
  800d1b:	eb 1e                	jmp    800d3b <strtol+0xc0>
		else if (*s >= 'a' && *s <= 'z')
  800d1d:	8d 5f 9f             	lea    -0x61(%edi),%ebx
  800d20:	80 fb 19             	cmp    $0x19,%bl
  800d23:	77 08                	ja     800d2d <strtol+0xb2>
			dig = *s - 'a' + 10;
  800d25:	0f be c9             	movsbl %cl,%ecx
  800d28:	83 e9 57             	sub    $0x57,%ecx
  800d2b:	eb 0e                	jmp    800d3b <strtol+0xc0>
		else if (*s >= 'A' && *s <= 'Z')
  800d2d:	8d 5f bf             	lea    -0x41(%edi),%ebx
  800d30:	80 fb 19             	cmp    $0x19,%bl
  800d33:	77 15                	ja     800d4a <strtol+0xcf>
			dig = *s - 'A' + 10;
  800d35:	0f be c9             	movsbl %cl,%ecx
  800d38:	83 e9 37             	sub    $0x37,%ecx
		else
			break;
		if (dig >= base)
  800d3b:	39 f1                	cmp    %esi,%ecx
  800d3d:	7d 0b                	jge    800d4a <strtol+0xcf>
			break;
		s++, val = (val * base) + dig;
  800d3f:	83 c2 01             	add    $0x1,%edx
  800d42:	0f af c6             	imul   %esi,%eax
  800d45:	8d 04 01             	lea    (%ecx,%eax,1),%eax
		// we don't properly detect overflow!
	}
  800d48:	eb be                	jmp    800d08 <strtol+0x8d>
  800d4a:	89 c1                	mov    %eax,%ecx

	if (endptr)
  800d4c:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800d50:	74 05                	je     800d57 <strtol+0xdc>
		*endptr = (char *) s;
  800d52:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800d55:	89 13                	mov    %edx,(%ebx)
	return (neg ? -val : val);
  800d57:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  800d5b:	74 04                	je     800d61 <strtol+0xe6>
  800d5d:	89 c8                	mov    %ecx,%eax
  800d5f:	f7 d8                	neg    %eax
}
  800d61:	83 c4 04             	add    $0x4,%esp
  800d64:	5b                   	pop    %ebx
  800d65:	5e                   	pop    %esi
  800d66:	5f                   	pop    %edi
  800d67:	5d                   	pop    %ebp
  800d68:	c3                   	ret    
  800d69:	00 00                	add    %al,(%eax)
	...

00800d6c <sys_cgetc>:
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}

int
sys_cgetc(void)
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
  800d82:	b8 01 00 00 00       	mov    $0x1,%eax
  800d87:	89 d1                	mov    %edx,%ecx
  800d89:	89 d3                	mov    %edx,%ebx
  800d8b:	89 d7                	mov    %edx,%edi
  800d8d:	89 d6                	mov    %edx,%esi
  800d8f:	cd 30                	int    $0x30

int
sys_cgetc(void)
{
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800d91:	8b 1c 24             	mov    (%esp),%ebx
  800d94:	8b 74 24 04          	mov    0x4(%esp),%esi
  800d98:	8b 7c 24 08          	mov    0x8(%esp),%edi
  800d9c:	89 ec                	mov    %ebp,%esp
  800d9e:	5d                   	pop    %ebp
  800d9f:	c3                   	ret    

00800da0 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800da0:	55                   	push   %ebp
  800da1:	89 e5                	mov    %esp,%ebp
  800da3:	83 ec 0c             	sub    $0xc,%esp
  800da6:	89 1c 24             	mov    %ebx,(%esp)
  800da9:	89 74 24 04          	mov    %esi,0x4(%esp)
  800dad:	89 7c 24 08          	mov    %edi,0x8(%esp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800db1:	b8 00 00 00 00       	mov    $0x0,%eax
  800db6:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800db9:	8b 55 08             	mov    0x8(%ebp),%edx
  800dbc:	89 c3                	mov    %eax,%ebx
  800dbe:	89 c7                	mov    %eax,%edi
  800dc0:	89 c6                	mov    %eax,%esi
  800dc2:	cd 30                	int    $0x30

void
sys_cputs(const char *s, size_t len)
{
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800dc4:	8b 1c 24             	mov    (%esp),%ebx
  800dc7:	8b 74 24 04          	mov    0x4(%esp),%esi
  800dcb:	8b 7c 24 08          	mov    0x8(%esp),%edi
  800dcf:	89 ec                	mov    %ebp,%esp
  800dd1:	5d                   	pop    %ebp
  800dd2:	c3                   	ret    

00800dd3 <sys_page_insert>:
{
	return syscall(SYS_page_waste, 0, (uint32_t)p, (uint32_t)n, 0, 0,0);
}
int
sys_page_insert(envid_t envid, void *va, struct Page *p, int perm)
{
  800dd3:	55                   	push   %ebp
  800dd4:	89 e5                	mov    %esp,%ebp
  800dd6:	83 ec 38             	sub    $0x38,%esp
  800dd9:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800ddc:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800ddf:	89 7d fc             	mov    %edi,-0x4(%ebp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800de2:	be 00 00 00 00       	mov    $0x0,%esi
  800de7:	b8 12 00 00 00       	mov    $0x12,%eax
  800dec:	8b 7d 14             	mov    0x14(%ebp),%edi
  800def:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800df2:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800df5:	8b 55 08             	mov    0x8(%ebp),%edx
  800df8:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
	
	if(check && ret > 0)
  800dfa:	85 c0                	test   %eax,%eax
  800dfc:	7e 28                	jle    800e26 <sys_page_insert+0x53>
		panic("syscall %d returned %d (> 0)", num, ret);
  800dfe:	89 44 24 10          	mov    %eax,0x10(%esp)
  800e02:	c7 44 24 0c 12 00 00 	movl   $0x12,0xc(%esp)
  800e09:	00 
  800e0a:	c7 44 24 08 5f 38 80 	movl   $0x80385f,0x8(%esp)
  800e11:	00 
  800e12:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800e19:	00 
  800e1a:	c7 04 24 7c 38 80 00 	movl   $0x80387c,(%esp)
  800e21:	e8 fe f3 ff ff       	call   800224 <_panic>
}
int
sys_page_insert(envid_t envid, void *va, struct Page *p, int perm)
{
	return syscall(SYS_page_insert, 1, envid, (uint32_t) va, (uint32_t)p, perm, 0);
}
  800e26:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800e29:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800e2c:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800e2f:	89 ec                	mov    %ebp,%esp
  800e31:	5d                   	pop    %ebp
  800e32:	c3                   	ret    

00800e33 <sys_page_waste>:
{
	return (int)syscall(SYS_receive_packet, 0, (uint32_t)buffer, 0,0,0,0);
}

int sys_page_waste(struct Page **p, int n)
{
  800e33:	55                   	push   %ebp
  800e34:	89 e5                	mov    %esp,%ebp
  800e36:	83 ec 0c             	sub    $0xc,%esp
  800e39:	89 1c 24             	mov    %ebx,(%esp)
  800e3c:	89 74 24 04          	mov    %esi,0x4(%esp)
  800e40:	89 7c 24 08          	mov    %edi,0x8(%esp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800e44:	bb 00 00 00 00       	mov    $0x0,%ebx
  800e49:	b8 11 00 00 00       	mov    $0x11,%eax
  800e4e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e51:	8b 55 08             	mov    0x8(%ebp),%edx
  800e54:	89 df                	mov    %ebx,%edi
  800e56:	89 de                	mov    %ebx,%esi
  800e58:	cd 30                	int    $0x30
}

int sys_page_waste(struct Page **p, int n)
{
	return syscall(SYS_page_waste, 0, (uint32_t)p, (uint32_t)n, 0, 0,0);
}
  800e5a:	8b 1c 24             	mov    (%esp),%ebx
  800e5d:	8b 74 24 04          	mov    0x4(%esp),%esi
  800e61:	8b 7c 24 08          	mov    0x8(%esp),%edi
  800e65:	89 ec                	mov    %ebp,%esp
  800e67:	5d                   	pop    %ebp
  800e68:	c3                   	ret    

00800e69 <sys_receive_packet>:
{
	return (int)syscall(SYS_transmit_packet, 1, (uint32_t)data, len, 0,0,0);
}

int sys_receive_packet(void* buffer)
{
  800e69:	55                   	push   %ebp
  800e6a:	89 e5                	mov    %esp,%ebp
  800e6c:	83 ec 0c             	sub    $0xc,%esp
  800e6f:	89 1c 24             	mov    %ebx,(%esp)
  800e72:	89 74 24 04          	mov    %esi,0x4(%esp)
  800e76:	89 7c 24 08          	mov    %edi,0x8(%esp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800e7a:	b9 00 00 00 00       	mov    $0x0,%ecx
  800e7f:	b8 10 00 00 00       	mov    $0x10,%eax
  800e84:	8b 55 08             	mov    0x8(%ebp),%edx
  800e87:	89 cb                	mov    %ecx,%ebx
  800e89:	89 cf                	mov    %ecx,%edi
  800e8b:	89 ce                	mov    %ecx,%esi
  800e8d:	cd 30                	int    $0x30
}

int sys_receive_packet(void* buffer)
{
	return (int)syscall(SYS_receive_packet, 0, (uint32_t)buffer, 0,0,0,0);
}
  800e8f:	8b 1c 24             	mov    (%esp),%ebx
  800e92:	8b 74 24 04          	mov    0x4(%esp),%esi
  800e96:	8b 7c 24 08          	mov    0x8(%esp),%edi
  800e9a:	89 ec                	mov    %ebp,%esp
  800e9c:	5d                   	pop    %ebp
  800e9d:	c3                   	ret    

00800e9e <sys_transmit_packet>:
{
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0,0);
}

int sys_transmit_packet(void* data, uint32_t len)
{
  800e9e:	55                   	push   %ebp
  800e9f:	89 e5                	mov    %esp,%ebp
  800ea1:	83 ec 38             	sub    $0x38,%esp
  800ea4:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800ea7:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800eaa:	89 7d fc             	mov    %edi,-0x4(%ebp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800ead:	bb 00 00 00 00       	mov    $0x0,%ebx
  800eb2:	b8 0f 00 00 00       	mov    $0xf,%eax
  800eb7:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800eba:	8b 55 08             	mov    0x8(%ebp),%edx
  800ebd:	89 df                	mov    %ebx,%edi
  800ebf:	89 de                	mov    %ebx,%esi
  800ec1:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
	
	if(check && ret > 0)
  800ec3:	85 c0                	test   %eax,%eax
  800ec5:	7e 28                	jle    800eef <sys_transmit_packet+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  800ec7:	89 44 24 10          	mov    %eax,0x10(%esp)
  800ecb:	c7 44 24 0c 0f 00 00 	movl   $0xf,0xc(%esp)
  800ed2:	00 
  800ed3:	c7 44 24 08 5f 38 80 	movl   $0x80385f,0x8(%esp)
  800eda:	00 
  800edb:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800ee2:	00 
  800ee3:	c7 04 24 7c 38 80 00 	movl   $0x80387c,(%esp)
  800eea:	e8 35 f3 ff ff       	call   800224 <_panic>
}

int sys_transmit_packet(void* data, uint32_t len)
{
	return (int)syscall(SYS_transmit_packet, 1, (uint32_t)data, len, 0,0,0);
}
  800eef:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800ef2:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800ef5:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800ef8:	89 ec                	mov    %ebp,%esp
  800efa:	5d                   	pop    %ebp
  800efb:	c3                   	ret    

00800efc <sys_time_msec>:
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}

unsigned int
sys_time_msec(void)
{
  800efc:	55                   	push   %ebp
  800efd:	89 e5                	mov    %esp,%ebp
  800eff:	83 ec 0c             	sub    $0xc,%esp
  800f02:	89 1c 24             	mov    %ebx,(%esp)
  800f05:	89 74 24 04          	mov    %esi,0x4(%esp)
  800f09:	89 7c 24 08          	mov    %edi,0x8(%esp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800f0d:	ba 00 00 00 00       	mov    $0x0,%edx
  800f12:	b8 0e 00 00 00       	mov    $0xe,%eax
  800f17:	89 d1                	mov    %edx,%ecx
  800f19:	89 d3                	mov    %edx,%ebx
  800f1b:	89 d7                	mov    %edx,%edi
  800f1d:	89 d6                	mov    %edx,%esi
  800f1f:	cd 30                	int    $0x30

unsigned int
sys_time_msec(void)
{
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0,0);
}
  800f21:	8b 1c 24             	mov    (%esp),%ebx
  800f24:	8b 74 24 04          	mov    0x4(%esp),%esi
  800f28:	8b 7c 24 08          	mov    0x8(%esp),%edi
  800f2c:	89 ec                	mov    %ebp,%esp
  800f2e:	5d                   	pop    %ebp
  800f2f:	c3                   	ret    

00800f30 <sys_ipc_recv>:
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}

int
sys_ipc_recv(void *dstva)
{
  800f30:	55                   	push   %ebp
  800f31:	89 e5                	mov    %esp,%ebp
  800f33:	83 ec 38             	sub    $0x38,%esp
  800f36:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800f39:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800f3c:	89 7d fc             	mov    %edi,-0x4(%ebp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800f3f:	b9 00 00 00 00       	mov    $0x0,%ecx
  800f44:	b8 0d 00 00 00       	mov    $0xd,%eax
  800f49:	8b 55 08             	mov    0x8(%ebp),%edx
  800f4c:	89 cb                	mov    %ecx,%ebx
  800f4e:	89 cf                	mov    %ecx,%edi
  800f50:	89 ce                	mov    %ecx,%esi
  800f52:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
	
	if(check && ret > 0)
  800f54:	85 c0                	test   %eax,%eax
  800f56:	7e 28                	jle    800f80 <sys_ipc_recv+0x50>
		panic("syscall %d returned %d (> 0)", num, ret);
  800f58:	89 44 24 10          	mov    %eax,0x10(%esp)
  800f5c:	c7 44 24 0c 0d 00 00 	movl   $0xd,0xc(%esp)
  800f63:	00 
  800f64:	c7 44 24 08 5f 38 80 	movl   $0x80385f,0x8(%esp)
  800f6b:	00 
  800f6c:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800f73:	00 
  800f74:	c7 04 24 7c 38 80 00 	movl   $0x80387c,(%esp)
  800f7b:	e8 a4 f2 ff ff       	call   800224 <_panic>

int
sys_ipc_recv(void *dstva)
{
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  800f80:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800f83:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800f86:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800f89:	89 ec                	mov    %ebp,%esp
  800f8b:	5d                   	pop    %ebp
  800f8c:	c3                   	ret    

00800f8d <sys_ipc_try_send>:
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800f8d:	55                   	push   %ebp
  800f8e:	89 e5                	mov    %esp,%ebp
  800f90:	83 ec 0c             	sub    $0xc,%esp
  800f93:	89 1c 24             	mov    %ebx,(%esp)
  800f96:	89 74 24 04          	mov    %esi,0x4(%esp)
  800f9a:	89 7c 24 08          	mov    %edi,0x8(%esp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800f9e:	be 00 00 00 00       	mov    $0x0,%esi
  800fa3:	b8 0c 00 00 00       	mov    $0xc,%eax
  800fa8:	8b 7d 14             	mov    0x14(%ebp),%edi
  800fab:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800fae:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800fb1:	8b 55 08             	mov    0x8(%ebp),%edx
  800fb4:	cd 30                	int    $0x30

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  800fb6:	8b 1c 24             	mov    (%esp),%ebx
  800fb9:	8b 74 24 04          	mov    0x4(%esp),%esi
  800fbd:	8b 7c 24 08          	mov    0x8(%esp),%edi
  800fc1:	89 ec                	mov    %ebp,%esp
  800fc3:	5d                   	pop    %ebp
  800fc4:	c3                   	ret    

00800fc5 <sys_env_set_pgfault_upcall>:
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800fc5:	55                   	push   %ebp
  800fc6:	89 e5                	mov    %esp,%ebp
  800fc8:	83 ec 38             	sub    $0x38,%esp
  800fcb:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800fce:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800fd1:	89 7d fc             	mov    %edi,-0x4(%ebp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800fd4:	bb 00 00 00 00       	mov    $0x0,%ebx
  800fd9:	b8 0a 00 00 00       	mov    $0xa,%eax
  800fde:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800fe1:	8b 55 08             	mov    0x8(%ebp),%edx
  800fe4:	89 df                	mov    %ebx,%edi
  800fe6:	89 de                	mov    %ebx,%esi
  800fe8:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
	
	if(check && ret > 0)
  800fea:	85 c0                	test   %eax,%eax
  800fec:	7e 28                	jle    801016 <sys_env_set_pgfault_upcall+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  800fee:	89 44 24 10          	mov    %eax,0x10(%esp)
  800ff2:	c7 44 24 0c 0a 00 00 	movl   $0xa,0xc(%esp)
  800ff9:	00 
  800ffa:	c7 44 24 08 5f 38 80 	movl   $0x80385f,0x8(%esp)
  801001:	00 
  801002:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  801009:	00 
  80100a:	c7 04 24 7c 38 80 00 	movl   $0x80387c,(%esp)
  801011:	e8 0e f2 ff ff       	call   800224 <_panic>

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  801016:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  801019:	8b 75 f8             	mov    -0x8(%ebp),%esi
  80101c:	8b 7d fc             	mov    -0x4(%ebp),%edi
  80101f:	89 ec                	mov    %ebp,%esp
  801021:	5d                   	pop    %ebp
  801022:	c3                   	ret    

00801023 <sys_env_set_trapframe>:
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  801023:	55                   	push   %ebp
  801024:	89 e5                	mov    %esp,%ebp
  801026:	83 ec 38             	sub    $0x38,%esp
  801029:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  80102c:	89 75 f8             	mov    %esi,-0x8(%ebp)
  80102f:	89 7d fc             	mov    %edi,-0x4(%ebp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801032:	bb 00 00 00 00       	mov    $0x0,%ebx
  801037:	b8 09 00 00 00       	mov    $0x9,%eax
  80103c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80103f:	8b 55 08             	mov    0x8(%ebp),%edx
  801042:	89 df                	mov    %ebx,%edi
  801044:	89 de                	mov    %ebx,%esi
  801046:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
	
	if(check && ret > 0)
  801048:	85 c0                	test   %eax,%eax
  80104a:	7e 28                	jle    801074 <sys_env_set_trapframe+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  80104c:	89 44 24 10          	mov    %eax,0x10(%esp)
  801050:	c7 44 24 0c 09 00 00 	movl   $0x9,0xc(%esp)
  801057:	00 
  801058:	c7 44 24 08 5f 38 80 	movl   $0x80385f,0x8(%esp)
  80105f:	00 
  801060:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  801067:	00 
  801068:	c7 04 24 7c 38 80 00 	movl   $0x80387c,(%esp)
  80106f:	e8 b0 f1 ff ff       	call   800224 <_panic>

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  801074:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  801077:	8b 75 f8             	mov    -0x8(%ebp),%esi
  80107a:	8b 7d fc             	mov    -0x4(%ebp),%edi
  80107d:	89 ec                	mov    %ebp,%esp
  80107f:	5d                   	pop    %ebp
  801080:	c3                   	ret    

00801081 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  801081:	55                   	push   %ebp
  801082:	89 e5                	mov    %esp,%ebp
  801084:	83 ec 38             	sub    $0x38,%esp
  801087:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  80108a:	89 75 f8             	mov    %esi,-0x8(%ebp)
  80108d:	89 7d fc             	mov    %edi,-0x4(%ebp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801090:	bb 00 00 00 00       	mov    $0x0,%ebx
  801095:	b8 08 00 00 00       	mov    $0x8,%eax
  80109a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80109d:	8b 55 08             	mov    0x8(%ebp),%edx
  8010a0:	89 df                	mov    %ebx,%edi
  8010a2:	89 de                	mov    %ebx,%esi
  8010a4:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
	
	if(check && ret > 0)
  8010a6:	85 c0                	test   %eax,%eax
  8010a8:	7e 28                	jle    8010d2 <sys_env_set_status+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  8010aa:	89 44 24 10          	mov    %eax,0x10(%esp)
  8010ae:	c7 44 24 0c 08 00 00 	movl   $0x8,0xc(%esp)
  8010b5:	00 
  8010b6:	c7 44 24 08 5f 38 80 	movl   $0x80385f,0x8(%esp)
  8010bd:	00 
  8010be:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  8010c5:	00 
  8010c6:	c7 04 24 7c 38 80 00 	movl   $0x80387c,(%esp)
  8010cd:	e8 52 f1 ff ff       	call   800224 <_panic>

int
sys_env_set_status(envid_t envid, int status)
{
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  8010d2:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  8010d5:	8b 75 f8             	mov    -0x8(%ebp),%esi
  8010d8:	8b 7d fc             	mov    -0x4(%ebp),%edi
  8010db:	89 ec                	mov    %ebp,%esp
  8010dd:	5d                   	pop    %ebp
  8010de:	c3                   	ret    

008010df <sys_page_unmap>:
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}

int
sys_page_unmap(envid_t envid, void *va)
{
  8010df:	55                   	push   %ebp
  8010e0:	89 e5                	mov    %esp,%ebp
  8010e2:	83 ec 38             	sub    $0x38,%esp
  8010e5:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  8010e8:	89 75 f8             	mov    %esi,-0x8(%ebp)
  8010eb:	89 7d fc             	mov    %edi,-0x4(%ebp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8010ee:	bb 00 00 00 00       	mov    $0x0,%ebx
  8010f3:	b8 06 00 00 00       	mov    $0x6,%eax
  8010f8:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8010fb:	8b 55 08             	mov    0x8(%ebp),%edx
  8010fe:	89 df                	mov    %ebx,%edi
  801100:	89 de                	mov    %ebx,%esi
  801102:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
	
	if(check && ret > 0)
  801104:	85 c0                	test   %eax,%eax
  801106:	7e 28                	jle    801130 <sys_page_unmap+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  801108:	89 44 24 10          	mov    %eax,0x10(%esp)
  80110c:	c7 44 24 0c 06 00 00 	movl   $0x6,0xc(%esp)
  801113:	00 
  801114:	c7 44 24 08 5f 38 80 	movl   $0x80385f,0x8(%esp)
  80111b:	00 
  80111c:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  801123:	00 
  801124:	c7 04 24 7c 38 80 00 	movl   $0x80387c,(%esp)
  80112b:	e8 f4 f0 ff ff       	call   800224 <_panic>

int
sys_page_unmap(envid_t envid, void *va)
{
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  801130:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  801133:	8b 75 f8             	mov    -0x8(%ebp),%esi
  801136:	8b 7d fc             	mov    -0x4(%ebp),%edi
  801139:	89 ec                	mov    %ebp,%esp
  80113b:	5d                   	pop    %ebp
  80113c:	c3                   	ret    

0080113d <sys_page_map>:
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  80113d:	55                   	push   %ebp
  80113e:	89 e5                	mov    %esp,%ebp
  801140:	83 ec 38             	sub    $0x38,%esp
  801143:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  801146:	89 75 f8             	mov    %esi,-0x8(%ebp)
  801149:	89 7d fc             	mov    %edi,-0x4(%ebp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80114c:	b8 05 00 00 00       	mov    $0x5,%eax
  801151:	8b 75 18             	mov    0x18(%ebp),%esi
  801154:	8b 7d 14             	mov    0x14(%ebp),%edi
  801157:	8b 5d 10             	mov    0x10(%ebp),%ebx
  80115a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80115d:	8b 55 08             	mov    0x8(%ebp),%edx
  801160:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
	
	if(check && ret > 0)
  801162:	85 c0                	test   %eax,%eax
  801164:	7e 28                	jle    80118e <sys_page_map+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  801166:	89 44 24 10          	mov    %eax,0x10(%esp)
  80116a:	c7 44 24 0c 05 00 00 	movl   $0x5,0xc(%esp)
  801171:	00 
  801172:	c7 44 24 08 5f 38 80 	movl   $0x80385f,0x8(%esp)
  801179:	00 
  80117a:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  801181:	00 
  801182:	c7 04 24 7c 38 80 00 	movl   $0x80387c,(%esp)
  801189:	e8 96 f0 ff ff       	call   800224 <_panic>

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  80118e:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  801191:	8b 75 f8             	mov    -0x8(%ebp),%esi
  801194:	8b 7d fc             	mov    -0x4(%ebp),%edi
  801197:	89 ec                	mov    %ebp,%esp
  801199:	5d                   	pop    %ebp
  80119a:	c3                   	ret    

0080119b <sys_page_alloc>:
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  80119b:	55                   	push   %ebp
  80119c:	89 e5                	mov    %esp,%ebp
  80119e:	83 ec 38             	sub    $0x38,%esp
  8011a1:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  8011a4:	89 75 f8             	mov    %esi,-0x8(%ebp)
  8011a7:	89 7d fc             	mov    %edi,-0x4(%ebp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8011aa:	be 00 00 00 00       	mov    $0x0,%esi
  8011af:	b8 04 00 00 00       	mov    $0x4,%eax
  8011b4:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8011b7:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8011ba:	8b 55 08             	mov    0x8(%ebp),%edx
  8011bd:	89 f7                	mov    %esi,%edi
  8011bf:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
	
	if(check && ret > 0)
  8011c1:	85 c0                	test   %eax,%eax
  8011c3:	7e 28                	jle    8011ed <sys_page_alloc+0x52>
		panic("syscall %d returned %d (> 0)", num, ret);
  8011c5:	89 44 24 10          	mov    %eax,0x10(%esp)
  8011c9:	c7 44 24 0c 04 00 00 	movl   $0x4,0xc(%esp)
  8011d0:	00 
  8011d1:	c7 44 24 08 5f 38 80 	movl   $0x80385f,0x8(%esp)
  8011d8:	00 
  8011d9:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  8011e0:	00 
  8011e1:	c7 04 24 7c 38 80 00 	movl   $0x80387c,(%esp)
  8011e8:	e8 37 f0 ff ff       	call   800224 <_panic>

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  8011ed:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  8011f0:	8b 75 f8             	mov    -0x8(%ebp),%esi
  8011f3:	8b 7d fc             	mov    -0x4(%ebp),%edi
  8011f6:	89 ec                	mov    %ebp,%esp
  8011f8:	5d                   	pop    %ebp
  8011f9:	c3                   	ret    

008011fa <sys_yield>:
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}

void
sys_yield(void)
{
  8011fa:	55                   	push   %ebp
  8011fb:	89 e5                	mov    %esp,%ebp
  8011fd:	83 ec 0c             	sub    $0xc,%esp
  801200:	89 1c 24             	mov    %ebx,(%esp)
  801203:	89 74 24 04          	mov    %esi,0x4(%esp)
  801207:	89 7c 24 08          	mov    %edi,0x8(%esp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80120b:	ba 00 00 00 00       	mov    $0x0,%edx
  801210:	b8 0b 00 00 00       	mov    $0xb,%eax
  801215:	89 d1                	mov    %edx,%ecx
  801217:	89 d3                	mov    %edx,%ebx
  801219:	89 d7                	mov    %edx,%edi
  80121b:	89 d6                	mov    %edx,%esi
  80121d:	cd 30                	int    $0x30

void
sys_yield(void)
{
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  80121f:	8b 1c 24             	mov    (%esp),%ebx
  801222:	8b 74 24 04          	mov    0x4(%esp),%esi
  801226:	8b 7c 24 08          	mov    0x8(%esp),%edi
  80122a:	89 ec                	mov    %ebp,%esp
  80122c:	5d                   	pop    %ebp
  80122d:	c3                   	ret    

0080122e <sys_getenvid>:
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}

envid_t
sys_getenvid(void)
{
  80122e:	55                   	push   %ebp
  80122f:	89 e5                	mov    %esp,%ebp
  801231:	83 ec 0c             	sub    $0xc,%esp
  801234:	89 1c 24             	mov    %ebx,(%esp)
  801237:	89 74 24 04          	mov    %esi,0x4(%esp)
  80123b:	89 7c 24 08          	mov    %edi,0x8(%esp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80123f:	ba 00 00 00 00       	mov    $0x0,%edx
  801244:	b8 02 00 00 00       	mov    $0x2,%eax
  801249:	89 d1                	mov    %edx,%ecx
  80124b:	89 d3                	mov    %edx,%ebx
  80124d:	89 d7                	mov    %edx,%edi
  80124f:	89 d6                	mov    %edx,%esi
  801251:	cd 30                	int    $0x30

envid_t
sys_getenvid(void)
{
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  801253:	8b 1c 24             	mov    (%esp),%ebx
  801256:	8b 74 24 04          	mov    0x4(%esp),%esi
  80125a:	8b 7c 24 08          	mov    0x8(%esp),%edi
  80125e:	89 ec                	mov    %ebp,%esp
  801260:	5d                   	pop    %ebp
  801261:	c3                   	ret    

00801262 <sys_env_destroy>:
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}

int
sys_env_destroy(envid_t envid)
{
  801262:	55                   	push   %ebp
  801263:	89 e5                	mov    %esp,%ebp
  801265:	83 ec 38             	sub    $0x38,%esp
  801268:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  80126b:	89 75 f8             	mov    %esi,-0x8(%ebp)
  80126e:	89 7d fc             	mov    %edi,-0x4(%ebp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801271:	b9 00 00 00 00       	mov    $0x0,%ecx
  801276:	b8 03 00 00 00       	mov    $0x3,%eax
  80127b:	8b 55 08             	mov    0x8(%ebp),%edx
  80127e:	89 cb                	mov    %ecx,%ebx
  801280:	89 cf                	mov    %ecx,%edi
  801282:	89 ce                	mov    %ecx,%esi
  801284:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
	
	if(check && ret > 0)
  801286:	85 c0                	test   %eax,%eax
  801288:	7e 28                	jle    8012b2 <sys_env_destroy+0x50>
		panic("syscall %d returned %d (> 0)", num, ret);
  80128a:	89 44 24 10          	mov    %eax,0x10(%esp)
  80128e:	c7 44 24 0c 03 00 00 	movl   $0x3,0xc(%esp)
  801295:	00 
  801296:	c7 44 24 08 5f 38 80 	movl   $0x80385f,0x8(%esp)
  80129d:	00 
  80129e:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  8012a5:	00 
  8012a6:	c7 04 24 7c 38 80 00 	movl   $0x80387c,(%esp)
  8012ad:	e8 72 ef ff ff       	call   800224 <_panic>

int
sys_env_destroy(envid_t envid)
{
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  8012b2:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  8012b5:	8b 75 f8             	mov    -0x8(%ebp),%esi
  8012b8:	8b 7d fc             	mov    -0x4(%ebp),%edi
  8012bb:	89 ec                	mov    %ebp,%esp
  8012bd:	5d                   	pop    %ebp
  8012be:	c3                   	ret    
	...

008012c0 <sfork>:
}

// Challenge!
int
sfork(void)
{
  8012c0:	55                   	push   %ebp
  8012c1:	89 e5                	mov    %esp,%ebp
  8012c3:	83 ec 18             	sub    $0x18,%esp
	panic("sfork not implemented");
  8012c6:	c7 44 24 08 8a 38 80 	movl   $0x80388a,0x8(%esp)
  8012cd:	00 
  8012ce:	c7 44 24 04 f2 00 00 	movl   $0xf2,0x4(%esp)
  8012d5:	00 
  8012d6:	c7 04 24 a0 38 80 00 	movl   $0x8038a0,(%esp)
  8012dd:	e8 42 ef ff ff       	call   800224 <_panic>

008012e2 <pgfault>:
// Custom page fault handler - if faulting page is copy-on-write,
// map in our own private writable copy.
//
static void
pgfault(struct UTrapframe *utf)
{
  8012e2:	55                   	push   %ebp
  8012e3:	89 e5                	mov    %esp,%ebp
  8012e5:	53                   	push   %ebx
  8012e6:	83 ec 24             	sub    $0x24,%esp
  8012e9:	8b 45 08             	mov    0x8(%ebp),%eax
	void *addr = (void *) utf->utf_fault_va;
  8012ec:	8b 18                	mov    (%eax),%ebx
	uint32_t err = utf->utf_err;
  8012ee:	f6 40 04 02          	testb  $0x2,0x4(%eax)
  8012f2:	75 1c                	jne    801310 <pgfault+0x2e>
	// LAB 4: Your code here.
	if ((err & FEC_WR) != FEC_WR)
	{
		if (debug)
			cprintf("Error caught = %x\n", err);
		panic ("user panic in lib/fork.c - pgfault(): faulting access is not write\n");
  8012f4:	c7 44 24 08 ac 38 80 	movl   $0x8038ac,0x8(%esp)
  8012fb:	00 
  8012fc:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  801303:	00 
  801304:	c7 04 24 a0 38 80 00 	movl   $0x8038a0,(%esp)
  80130b:	e8 14 ef ff ff       	call   800224 <_panic>
	}
	pte = vpt[VPN(addr)];
  801310:	89 d8                	mov    %ebx,%eax
  801312:	c1 e8 0c             	shr    $0xc,%eax
  801315:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
	if ((pte & PTE_COW) != PTE_COW)
  80131c:	f6 c4 08             	test   $0x8,%ah
  80131f:	75 1c                	jne    80133d <pgfault+0x5b>
		panic ("user panic in lib/fork.c - pgfault(): faulting access is not to a COW page\n");
  801321:	c7 44 24 08 f0 38 80 	movl   $0x8038f0,0x8(%esp)
  801328:	00 
  801329:	c7 44 24 04 27 00 00 	movl   $0x27,0x4(%esp)
  801330:	00 
  801331:	c7 04 24 a0 38 80 00 	movl   $0x8038a0,(%esp)
  801338:	e8 e7 ee ff ff       	call   800224 <_panic>
	// Hint:
	//   You should make three system calls.
	//   No need to explicitly delete the old page's mapping.

	// LAB 4: Your code here.
	if ((r = sys_page_alloc(0, (void*)PFTEMP, PTE_P | PTE_U | PTE_W)) < 0)
  80133d:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  801344:	00 
  801345:	c7 44 24 04 00 f0 7f 	movl   $0x7ff000,0x4(%esp)
  80134c:	00 
  80134d:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801354:	e8 42 fe ff ff       	call   80119b <sys_page_alloc>
  801359:	85 c0                	test   %eax,%eax
  80135b:	79 20                	jns    80137d <pgfault+0x9b>
		panic ("user panic in lib/fork.c - pgfault(): sys_page_alloc: %e", r);
  80135d:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801361:	c7 44 24 08 3c 39 80 	movl   $0x80393c,0x8(%esp)
  801368:	00 
  801369:	c7 44 24 04 32 00 00 	movl   $0x32,0x4(%esp)
  801370:	00 
  801371:	c7 04 24 a0 38 80 00 	movl   $0x8038a0,(%esp)
  801378:	e8 a7 ee ff ff       	call   800224 <_panic>
	
	memmove((void*)PFTEMP, (void*)ROUNDDOWN(addr,PGSIZE), PGSIZE);
  80137d:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  801383:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
  80138a:	00 
  80138b:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  80138f:	c7 04 24 00 f0 7f 00 	movl   $0x7ff000,(%esp)
  801396:	e8 ca f7 ff ff       	call   800b65 <memmove>
		
	if ((r = sys_page_map(0, (void*)PFTEMP, 0, (void*)ROUNDDOWN(addr,PGSIZE), PTE_P | PTE_U | PTE_W)) < 0)	
  80139b:	c7 44 24 10 07 00 00 	movl   $0x7,0x10(%esp)
  8013a2:	00 
  8013a3:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  8013a7:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  8013ae:	00 
  8013af:	c7 44 24 04 00 f0 7f 	movl   $0x7ff000,0x4(%esp)
  8013b6:	00 
  8013b7:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8013be:	e8 7a fd ff ff       	call   80113d <sys_page_map>
  8013c3:	85 c0                	test   %eax,%eax
  8013c5:	79 20                	jns    8013e7 <pgfault+0x105>
		panic ("user panic in lib/fork.c - pgfault(): sys_page_map: %e", r);
  8013c7:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8013cb:	c7 44 24 08 78 39 80 	movl   $0x803978,0x8(%esp)
  8013d2:	00 
  8013d3:	c7 44 24 04 37 00 00 	movl   $0x37,0x4(%esp)
  8013da:	00 
  8013db:	c7 04 24 a0 38 80 00 	movl   $0x8038a0,(%esp)
  8013e2:	e8 3d ee ff ff       	call   800224 <_panic>
	if ((r = sys_page_unmap(0, (void*)PFTEMP)) < 0)
  8013e7:	c7 44 24 04 00 f0 7f 	movl   $0x7ff000,0x4(%esp)
  8013ee:	00 
  8013ef:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8013f6:	e8 e4 fc ff ff       	call   8010df <sys_page_unmap>
  8013fb:	85 c0                	test   %eax,%eax
  8013fd:	79 20                	jns    80141f <pgfault+0x13d>
		panic ("user panic in lib/fork.c - pgfault(): sys_page_unmap: %e", r);
  8013ff:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801403:	c7 44 24 08 b0 39 80 	movl   $0x8039b0,0x8(%esp)
  80140a:	00 
  80140b:	c7 44 24 04 39 00 00 	movl   $0x39,0x4(%esp)
  801412:	00 
  801413:	c7 04 24 a0 38 80 00 	movl   $0x8038a0,(%esp)
  80141a:	e8 05 ee ff ff       	call   800224 <_panic>
	// panic("pgfault not implemented");
}
  80141f:	83 c4 24             	add    $0x24,%esp
  801422:	5b                   	pop    %ebx
  801423:	5d                   	pop    %ebp
  801424:	c3                   	ret    

00801425 <fork>:
//   Neither user exception stack should ever be marked copy-on-write,
//   so you must allocate a new page for the child's user exception stack.
//
envid_t
fork(void)
{
  801425:	55                   	push   %ebp
  801426:	89 e5                	mov    %esp,%ebp
  801428:	57                   	push   %edi
  801429:	56                   	push   %esi
  80142a:	53                   	push   %ebx
  80142b:	83 ec 3c             	sub    $0x3c,%esp
	int r;
	uint32_t pde_x, pte_x, vpn;	// page directory index, page table index and page number
	

	// Set up our page fault handler appropriately.
	set_pgfault_handler(pgfault);
  80142e:	c7 04 24 e2 12 80 00 	movl   $0x8012e2,(%esp)
  801435:	e8 e2 1b 00 00       	call   80301c <set_pgfault_handler>
static __inline envid_t sys_exofork(void) __attribute__((always_inline));
static __inline envid_t
sys_exofork(void)
{
	envid_t ret;
	__asm __volatile("int %2"
  80143a:	ba 07 00 00 00       	mov    $0x7,%edx
  80143f:	89 d0                	mov    %edx,%eax
  801441:	cd 30                	int    $0x30
  801443:	89 45 e0             	mov    %eax,-0x20(%ebp)
		cprintf("\n After set_pgfaulthandler()\n");
	// Create a child.
	child_envid = sys_exofork();
	if (debug)
		cprintf("\n After exofork()\n");
	if (child_envid < 0)
  801446:	85 c0                	test   %eax,%eax
  801448:	0f 88 21 02 00 00    	js     80166f <fork+0x24a>
	if (child_envid == 0)
	{
		if (debug)
			cprintf("\n After child_envid == 0\n");
		env = &envs[ENVX(sys_getenvid())];
		return 0;
  80144e:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
		return child_envid;
	if (debug)
		cprintf("\n After child_envid >= 0\n");
		// panic(" panic in lib/fork.c - fork():sys_exofork: %e", child_env);
	// fix "env" in the child process
	if (child_envid == 0)
  801455:	85 c0                	test   %eax,%eax
  801457:	75 1c                	jne    801475 <fork+0x50>
	{
		if (debug)
			cprintf("\n After child_envid == 0\n");
		env = &envs[ENVX(sys_getenvid())];
  801459:	e8 d0 fd ff ff       	call   80122e <sys_getenvid>
  80145e:	25 ff 03 00 00       	and    $0x3ff,%eax
  801463:	6b c0 7c             	imul   $0x7c,%eax,%eax
  801466:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  80146b:	a3 7c 70 80 00       	mov    %eax,0x80707c
		return 0;
  801470:	e9 fa 01 00 00       	jmp    80166f <fork+0x24a>
	// Map the address space except the user exception stack
	if (debug)
		cprintf("\n After child_envid > 0\n");
	for (pde_x = VPD(0); pde_x < VPD(UTOP); pde_x++)
	{
		if ((vpd[pde_x] & PTE_P) == PTE_P)
  801475:	8b 55 dc             	mov    -0x24(%ebp),%edx
  801478:	8b 04 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%eax
  80147f:	a8 01                	test   $0x1,%al
  801481:	0f 84 16 01 00 00    	je     80159d <fork+0x178>
		{
			for (pte_x = 0; pte_x < NPTENTRIES; pte_x++)
			{
				vpn = (pde_x << (PDXSHIFT - PTXSHIFT)) + pte_x;		//removed hardcoding
  801487:	89 d3                	mov    %edx,%ebx
  801489:	c1 e3 0a             	shl    $0xa,%ebx
  80148c:	89 d7                	mov    %edx,%edi
  80148e:	c1 e7 16             	shl    $0x16,%edi
  801491:	be 00 00 00 00       	mov    $0x0,%esi
				if(((vpt[vpn] & PTE_P) == PTE_P) && (vpn < VPN(UXSTACKTOP - PGSIZE)))
  801496:	8b 04 9d 00 00 40 ef 	mov    -0x10c00000(,%ebx,4),%eax
  80149d:	a8 01                	test   $0x1,%al
  80149f:	0f 84 e0 00 00 00    	je     801585 <fork+0x160>
  8014a5:	81 fb fe eb 0e 00    	cmp    $0xeebfe,%ebx
  8014ab:	0f 87 d4 00 00 00    	ja     801585 <fork+0x160>
	
	// LAB 4: Your code here.
	if (debug)
		cprintf("\n duppage: 1\n");	

	pte_t pte = vpt[pn];
  8014b1:	8b 14 9d 00 00 40 ef 	mov    -0x10c00000(,%ebx,4),%edx
	int perm = pte & PTE_USER;
  8014b8:	89 d0                	mov    %edx,%eax
  8014ba:	25 07 0e 00 00       	and    $0xe07,%eax
	void *va = (void*) (pn*PGSIZE);	
	if (debug)
		cprintf("\n duppage: 2\n");	
	
	if ((perm & PTE_P) != PTE_P)
  8014bf:	f6 c2 01             	test   $0x1,%dl
  8014c2:	75 1c                	jne    8014e0 <fork+0xbb>
		panic ("user panic: lib\fork.c: duppage(): page to be duplicated is not PTE_P\n");
  8014c4:	c7 44 24 08 ec 39 80 	movl   $0x8039ec,0x8(%esp)
  8014cb:	00 
  8014cc:	c7 44 24 04 58 00 00 	movl   $0x58,0x4(%esp)
  8014d3:	00 
  8014d4:	c7 04 24 a0 38 80 00 	movl   $0x8038a0,(%esp)
  8014db:	e8 44 ed ff ff       	call   800224 <_panic>
	if ((perm & PTE_U) != PTE_U)
  8014e0:	a8 04                	test   $0x4,%al
  8014e2:	75 1c                	jne    801500 <fork+0xdb>
		panic ("user panic: lib\fork.c: duppage(): page to be duplicated is not PTE_U\n");
  8014e4:	c7 44 24 08 34 3a 80 	movl   $0x803a34,0x8(%esp)
  8014eb:	00 
  8014ec:	c7 44 24 04 5a 00 00 	movl   $0x5a,0x4(%esp)
  8014f3:	00 
  8014f4:	c7 04 24 a0 38 80 00 	movl   $0x8038a0,(%esp)
  8014fb:	e8 24 ed ff ff       	call   800224 <_panic>
  801500:	89 7d e4             	mov    %edi,-0x1c(%ebp)
	if (debug)
		cprintf("\n duppage: 3\n");	

	// LAB 7: Include PTE_SHARE convention
	if ( !(perm & PTE_SHARE) && (((perm & PTE_W) == PTE_W) || ((perm & PTE_COW) == PTE_COW)))
  801503:	f6 c4 04             	test   $0x4,%ah
  801506:	75 5b                	jne    801563 <fork+0x13e>
  801508:	a9 02 08 00 00       	test   $0x802,%eax
  80150d:	74 54                	je     801563 <fork+0x13e>
	{
		if (debug)
			cprintf("\n duppage: 4\n");	
		// perm = PTE_P | PTE_U | PTE_COW;	// buggy permissions, removed in LAB 7
		perm &= ~PTE_W;				// remove write from perm
  80150f:	83 e0 fd             	and    $0xfffffffd,%eax
		perm |= PTE_COW;			// add copy-on-write
  801512:	80 cc 08             	or     $0x8,%ah
  801515:	89 45 d8             	mov    %eax,-0x28(%ebp)
		if (debug)
			cprintf("\n duppage: 10\n");	
		if ((r = sys_page_map(0, va, envid, va, perm)) < 0)
  801518:	89 44 24 10          	mov    %eax,0x10(%esp)
  80151c:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  801520:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801523:	89 54 24 08          	mov    %edx,0x8(%esp)
  801527:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80152b:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801532:	e8 06 fc ff ff       	call   80113d <sys_page_map>
  801537:	85 c0                	test   %eax,%eax
  801539:	78 4a                	js     801585 <fork+0x160>
			return r;
		if (debug)
			cprintf("\n duppage: 11\n");	
		if ((r = sys_page_map(0, va, 0, va, perm)) < 0)
  80153b:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80153e:	89 44 24 10          	mov    %eax,0x10(%esp)
  801542:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801545:	89 54 24 0c          	mov    %edx,0xc(%esp)
  801549:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801550:	00 
  801551:	89 54 24 04          	mov    %edx,0x4(%esp)
  801555:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80155c:	e8 dc fb ff ff       	call   80113d <sys_page_map>
  801561:	eb 22                	jmp    801585 <fork+0x160>
	// LAB 7: Include PTE_SHARE convention
	else
	{
		if (debug)
			cprintf("\n duppage: 6\n");	
		if ((r = sys_page_map(0, va, envid, va, perm)) < 0)
  801563:	89 44 24 10          	mov    %eax,0x10(%esp)
  801567:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80156a:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80156e:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801571:	89 54 24 08          	mov    %edx,0x8(%esp)
  801575:	89 44 24 04          	mov    %eax,0x4(%esp)
  801579:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801580:	e8 b8 fb ff ff       	call   80113d <sys_page_map>
		cprintf("\n After child_envid > 0\n");
	for (pde_x = VPD(0); pde_x < VPD(UTOP); pde_x++)
	{
		if ((vpd[pde_x] & PTE_P) == PTE_P)
		{
			for (pte_x = 0; pte_x < NPTENTRIES; pte_x++)
  801585:	83 c6 01             	add    $0x1,%esi
  801588:	83 c3 01             	add    $0x1,%ebx
  80158b:	81 c7 00 10 00 00    	add    $0x1000,%edi
  801591:	81 fe 00 04 00 00    	cmp    $0x400,%esi
  801597:	0f 85 f9 fe ff ff    	jne    801496 <fork+0x71>
	}
	// reached here... we're the parent process
	// Map the address space except the user exception stack
	if (debug)
		cprintf("\n After child_envid > 0\n");
	for (pde_x = VPD(0); pde_x < VPD(UTOP); pde_x++)
  80159d:	83 45 dc 01          	addl   $0x1,-0x24(%ebp)
  8015a1:	81 7d dc bb 03 00 00 	cmpl   $0x3bb,-0x24(%ebp)
  8015a8:	0f 85 c7 fe ff ff    	jne    801475 <fork+0x50>
	}	
	if (debug)
		cprintf("\n After duppaging()\n");
	// Allocate and copy the use exception stack for the child environment
	// Allocate a page for the stack in the child
	if ((r = sys_page_alloc(child_envid, (void*)(UXSTACKTOP - PGSIZE), PTE_P | PTE_U | PTE_W)) < 0)
  8015ae:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  8015b5:	00 
  8015b6:	c7 44 24 04 00 f0 bf 	movl   $0xeebff000,0x4(%esp)
  8015bd:	ee 
  8015be:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8015c1:	89 04 24             	mov    %eax,(%esp)
  8015c4:	e8 d2 fb ff ff       	call   80119b <sys_page_alloc>
  8015c9:	85 c0                	test   %eax,%eax
  8015cb:	79 08                	jns    8015d5 <fork+0x1b0>
  8015cd:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8015d0:	e9 9a 00 00 00       	jmp    80166f <fork+0x24a>
		return r;
	if (debug)
		cprintf("\n After set_pgfaulthandler()\n");
	// Map this page to a free virtual address space in parent
	if ((r = sys_page_map(child_envid, (void*)(UXSTACKTOP - PGSIZE), 0, (void*)UTEMP, PTE_P | PTE_U | PTE_W)) < 0)
  8015d5:	c7 44 24 10 07 00 00 	movl   $0x7,0x10(%esp)
  8015dc:	00 
  8015dd:	c7 44 24 0c 00 00 40 	movl   $0x400000,0xc(%esp)
  8015e4:	00 
  8015e5:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  8015ec:	00 
  8015ed:	c7 44 24 04 00 f0 bf 	movl   $0xeebff000,0x4(%esp)
  8015f4:	ee 
  8015f5:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8015f8:	89 14 24             	mov    %edx,(%esp)
  8015fb:	e8 3d fb ff ff       	call   80113d <sys_page_map>
  801600:	85 c0                	test   %eax,%eax
  801602:	79 05                	jns    801609 <fork+0x1e4>
  801604:	89 45 e0             	mov    %eax,-0x20(%ebp)
  801607:	eb 66                	jmp    80166f <fork+0x24a>
		return r;
	if (debug)
		cprintf("\n After sys_page_map()\n");
	// Copy the parent exception stack to the above, i.e. page from child mapped to parent's address space
	memmove((void*)UTEMP, (void*)(UXSTACKTOP - PGSIZE), PGSIZE);
  801609:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
  801610:	00 
  801611:	c7 44 24 04 00 f0 bf 	movl   $0xeebff000,0x4(%esp)
  801618:	ee 
  801619:	c7 04 24 00 00 40 00 	movl   $0x400000,(%esp)
  801620:	e8 40 f5 ff ff       	call   800b65 <memmove>
	if (debug)
		cprintf("\n After memmove()\n");
	// Unmap this page from the parent
	sys_page_unmap(0, (void*)UTEMP);
  801625:	c7 44 24 04 00 00 40 	movl   $0x400000,0x4(%esp)
  80162c:	00 
  80162d:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801634:	e8 a6 fa ff ff       	call   8010df <sys_page_unmap>
	if (debug)
		cprintf("\n After sys_page_unmap()\n");

	// Set up the page fault handler
	if ((r = sys_env_set_pgfault_upcall(child_envid, _pgfault_upcall)) < 0)
  801639:	c7 44 24 04 b0 30 80 	movl   $0x8030b0,0x4(%esp)
  801640:	00 
  801641:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801644:	89 04 24             	mov    %eax,(%esp)
  801647:	e8 79 f9 ff ff       	call   800fc5 <sys_env_set_pgfault_upcall>
  80164c:	85 c0                	test   %eax,%eax
  80164e:	79 05                	jns    801655 <fork+0x230>
  801650:	89 45 e0             	mov    %eax,-0x20(%ebp)
  801653:	eb 1a                	jmp    80166f <fork+0x24a>
		// panic(" panic in lib/fork.c - fork():sys_env_set_pgfault_upcall: %e", child_env);
	if (debug)
		cprintf("\n After set_upcall()\n");

	// Mark the child runnable
	if ((r = sys_env_set_status(child_envid, ENV_RUNNABLE)) < 0)
  801655:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  80165c:	00 
  80165d:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801660:	89 14 24             	mov    %edx,(%esp)
  801663:	e8 19 fa ff ff       	call   801081 <sys_env_set_status>
  801668:	85 c0                	test   %eax,%eax
  80166a:	79 03                	jns    80166f <fork+0x24a>
  80166c:	89 45 e0             	mov    %eax,-0x20(%ebp)
	if (debug)
		cprintf("\n After set_status()\n");
	
	return child_envid;
	
}
  80166f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801672:	83 c4 3c             	add    $0x3c,%esp
  801675:	5b                   	pop    %ebx
  801676:	5e                   	pop    %esi
  801677:	5f                   	pop    %edi
  801678:	5d                   	pop    %ebp
  801679:	c3                   	ret    
  80167a:	00 00                	add    %al,(%eax)
  80167c:	00 00                	add    %al,(%eax)
	...

00801680 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  801680:	55                   	push   %ebp
  801681:	89 e5                	mov    %esp,%ebp
  801683:	8b 45 08             	mov    0x8(%ebp),%eax
  801686:	05 00 00 00 30       	add    $0x30000000,%eax
  80168b:	c1 e8 0c             	shr    $0xc,%eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
}
  80168e:	5d                   	pop    %ebp
  80168f:	c3                   	ret    

00801690 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  801690:	55                   	push   %ebp
  801691:	89 e5                	mov    %esp,%ebp
  801693:	83 ec 04             	sub    $0x4,%esp
	return INDEX2DATA(fd2num(fd));
  801696:	8b 45 08             	mov    0x8(%ebp),%eax
  801699:	89 04 24             	mov    %eax,(%esp)
  80169c:	e8 df ff ff ff       	call   801680 <fd2num>
  8016a1:	05 20 00 0d 00       	add    $0xd0020,%eax
  8016a6:	c1 e0 0c             	shl    $0xc,%eax
}
  8016a9:	c9                   	leave  
  8016aa:	c3                   	ret    

008016ab <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  8016ab:	55                   	push   %ebp
  8016ac:	89 e5                	mov    %esp,%ebp
  8016ae:	57                   	push   %edi
  8016af:	56                   	push   %esi
  8016b0:	53                   	push   %ebx
  8016b1:	8b 7d 08             	mov    0x8(%ebp),%edi
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((vpd[PDX(fd)] & PTE_P) == 0 || (vpt[VPN(fd)] & PTE_P) == 0) {
  8016b4:	a1 00 dd 7b ef       	mov    0xef7bdd00,%eax
  8016b9:	a8 01                	test   $0x1,%al
  8016bb:	74 36                	je     8016f3 <fd_alloc+0x48>
  8016bd:	a1 00 00 74 ef       	mov    0xef740000,%eax
  8016c2:	a8 01                	test   $0x1,%al
  8016c4:	74 2d                	je     8016f3 <fd_alloc+0x48>
  8016c6:	b8 00 10 00 d0       	mov    $0xd0001000,%eax
  8016cb:	b9 00 d0 7b ef       	mov    $0xef7bd000,%ecx
  8016d0:	be 00 00 40 ef       	mov    $0xef400000,%esi
  8016d5:	89 c3                	mov    %eax,%ebx
  8016d7:	89 c2                	mov    %eax,%edx
  8016d9:	c1 ea 16             	shr    $0x16,%edx
  8016dc:	8b 14 91             	mov    (%ecx,%edx,4),%edx
  8016df:	f6 c2 01             	test   $0x1,%dl
  8016e2:	74 14                	je     8016f8 <fd_alloc+0x4d>
  8016e4:	89 c2                	mov    %eax,%edx
  8016e6:	c1 ea 0c             	shr    $0xc,%edx
  8016e9:	8b 14 96             	mov    (%esi,%edx,4),%edx
  8016ec:	f6 c2 01             	test   $0x1,%dl
  8016ef:	75 10                	jne    801701 <fd_alloc+0x56>
  8016f1:	eb 05                	jmp    8016f8 <fd_alloc+0x4d>
  8016f3:	bb 00 00 00 d0       	mov    $0xd0000000,%ebx
			*fd_store = fd;
  8016f8:	89 1f                	mov    %ebx,(%edi)
  8016fa:	b8 00 00 00 00       	mov    $0x0,%eax
			return 0;
  8016ff:	eb 17                	jmp    801718 <fd_alloc+0x6d>
  801701:	05 00 10 00 00       	add    $0x1000,%eax
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  801706:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  80170b:	75 c8                	jne    8016d5 <fd_alloc+0x2a>
		if ((vpd[PDX(fd)] & PTE_P) == 0 || (vpt[VPN(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  80170d:	c7 07 00 00 00 00    	movl   $0x0,(%edi)
  801713:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
	return -E_MAX_OPEN;
}
  801718:	5b                   	pop    %ebx
  801719:	5e                   	pop    %esi
  80171a:	5f                   	pop    %edi
  80171b:	5d                   	pop    %ebp
  80171c:	c3                   	ret    

0080171d <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  80171d:	55                   	push   %ebp
  80171e:	89 e5                	mov    %esp,%ebp
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  801720:	8b 45 08             	mov    0x8(%ebp),%eax
  801723:	83 f8 1f             	cmp    $0x1f,%eax
  801726:	77 36                	ja     80175e <fd_lookup+0x41>
		if (debug)
			cprintf("[%08x] bad fd %d\n", env->env_id, fd);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  801728:	05 00 00 0d 00       	add    $0xd0000,%eax
  80172d:	c1 e0 0c             	shl    $0xc,%eax
	if (!(vpd[PDX(fd)] & PTE_P) || !(vpt[VPN(fd)] & PTE_P)) {
  801730:	89 c2                	mov    %eax,%edx
  801732:	c1 ea 16             	shr    $0x16,%edx
  801735:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  80173c:	f6 c2 01             	test   $0x1,%dl
  80173f:	74 1d                	je     80175e <fd_lookup+0x41>
  801741:	89 c2                	mov    %eax,%edx
  801743:	c1 ea 0c             	shr    $0xc,%edx
  801746:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  80174d:	f6 c2 01             	test   $0x1,%dl
  801750:	74 0c                	je     80175e <fd_lookup+0x41>
		if (debug)
			cprintf("[%08x] closed fd %d\n", env->env_id, fd);
		return -E_INVAL;
	}
	*fd_store = fd;
  801752:	8b 55 0c             	mov    0xc(%ebp),%edx
  801755:	89 02                	mov    %eax,(%edx)
  801757:	b8 00 00 00 00       	mov    $0x0,%eax
	return 0;
  80175c:	eb 05                	jmp    801763 <fd_lookup+0x46>
  80175e:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  801763:	5d                   	pop    %ebp
  801764:	c3                   	ret    

00801765 <seek>:
	return (*dev->dev_write)(fd, buf, n);
}

int
seek(int fdnum, off_t offset)
{
  801765:	55                   	push   %ebp
  801766:	89 e5                	mov    %esp,%ebp
  801768:	83 ec 18             	sub    $0x18,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80176b:	8d 45 fc             	lea    -0x4(%ebp),%eax
  80176e:	89 44 24 04          	mov    %eax,0x4(%esp)
  801772:	8b 45 08             	mov    0x8(%ebp),%eax
  801775:	89 04 24             	mov    %eax,(%esp)
  801778:	e8 a0 ff ff ff       	call   80171d <fd_lookup>
  80177d:	85 c0                	test   %eax,%eax
  80177f:	78 0e                	js     80178f <seek+0x2a>
		return r;
	fd->fd_offset = offset;
  801781:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801784:	8b 55 0c             	mov    0xc(%ebp),%edx
  801787:	89 50 04             	mov    %edx,0x4(%eax)
  80178a:	b8 00 00 00 00       	mov    $0x0,%eax
	return 0;
}
  80178f:	c9                   	leave  
  801790:	c3                   	ret    

00801791 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  801791:	55                   	push   %ebp
  801792:	89 e5                	mov    %esp,%ebp
  801794:	56                   	push   %esi
  801795:	53                   	push   %ebx
  801796:	83 ec 10             	sub    $0x10,%esp
  801799:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80179c:	8b 5d 0c             	mov    0xc(%ebp),%ebx
// File functions
// --------------------------------------------------------------

static struct Dev *devtab[] =
{
	&devfile,
  80179f:	b8 0c 70 80 00       	mov    $0x80700c,%eax
{
	int i;
	for (i = 0; devtab[i]; i++)
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
  8017a4:	ba 00 00 00 00       	mov    $0x0,%edx

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  8017a9:	be f8 3a 80 00       	mov    $0x803af8,%esi
		if (devtab[i]->dev_id == dev_id) {
  8017ae:	39 08                	cmp    %ecx,(%eax)
  8017b0:	75 10                	jne    8017c2 <dev_lookup+0x31>
  8017b2:	eb 04                	jmp    8017b8 <dev_lookup+0x27>
  8017b4:	39 08                	cmp    %ecx,(%eax)
  8017b6:	75 0a                	jne    8017c2 <dev_lookup+0x31>
			*dev = devtab[i];
  8017b8:	89 03                	mov    %eax,(%ebx)
  8017ba:	b8 00 00 00 00       	mov    $0x0,%eax
			return 0;
  8017bf:	90                   	nop
  8017c0:	eb 31                	jmp    8017f3 <dev_lookup+0x62>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  8017c2:	83 c2 01             	add    $0x1,%edx
  8017c5:	8b 04 96             	mov    (%esi,%edx,4),%eax
  8017c8:	85 c0                	test   %eax,%eax
  8017ca:	75 e8                	jne    8017b4 <dev_lookup+0x23>
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", env->env_id, dev_id);
  8017cc:	a1 7c 70 80 00       	mov    0x80707c,%eax
  8017d1:	8b 40 4c             	mov    0x4c(%eax),%eax
  8017d4:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8017d8:	89 44 24 04          	mov    %eax,0x4(%esp)
  8017dc:	c7 04 24 7c 3a 80 00 	movl   $0x803a7c,(%esp)
  8017e3:	e8 01 eb ff ff       	call   8002e9 <cprintf>
	*dev = 0;
  8017e8:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  8017ee:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
	return -E_INVAL;
}
  8017f3:	83 c4 10             	add    $0x10,%esp
  8017f6:	5b                   	pop    %ebx
  8017f7:	5e                   	pop    %esi
  8017f8:	5d                   	pop    %ebp
  8017f9:	c3                   	ret    

008017fa <fstat>:
	return (*dev->dev_trunc)(fd, newsize);
}

int
fstat(int fdnum, struct Stat *stat)
{
  8017fa:	55                   	push   %ebp
  8017fb:	89 e5                	mov    %esp,%ebp
  8017fd:	53                   	push   %ebx
  8017fe:	83 ec 24             	sub    $0x24,%esp
  801801:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801804:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801807:	89 44 24 04          	mov    %eax,0x4(%esp)
  80180b:	8b 45 08             	mov    0x8(%ebp),%eax
  80180e:	89 04 24             	mov    %eax,(%esp)
  801811:	e8 07 ff ff ff       	call   80171d <fd_lookup>
  801816:	85 c0                	test   %eax,%eax
  801818:	78 53                	js     80186d <fstat+0x73>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80181a:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80181d:	89 44 24 04          	mov    %eax,0x4(%esp)
  801821:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801824:	8b 00                	mov    (%eax),%eax
  801826:	89 04 24             	mov    %eax,(%esp)
  801829:	e8 63 ff ff ff       	call   801791 <dev_lookup>
{
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80182e:	85 c0                	test   %eax,%eax
  801830:	78 3b                	js     80186d <fstat+0x73>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if (!dev->dev_stat)
  801832:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801837:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80183a:	83 7a 14 00          	cmpl   $0x0,0x14(%edx)
  80183e:	74 2d                	je     80186d <fstat+0x73>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  801840:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  801843:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  80184a:	00 00 00 
	stat->st_isdir = 0;
  80184d:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801854:	00 00 00 
	stat->st_dev = dev;
  801857:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80185a:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  801860:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801864:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801867:	89 14 24             	mov    %edx,(%esp)
  80186a:	ff 50 14             	call   *0x14(%eax)
}
  80186d:	83 c4 24             	add    $0x24,%esp
  801870:	5b                   	pop    %ebx
  801871:	5d                   	pop    %ebp
  801872:	c3                   	ret    

00801873 <ftruncate>:
	return 0;
}

int
ftruncate(int fdnum, off_t newsize)
{
  801873:	55                   	push   %ebp
  801874:	89 e5                	mov    %esp,%ebp
  801876:	53                   	push   %ebx
  801877:	83 ec 24             	sub    $0x24,%esp
  80187a:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  80187d:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801880:	89 44 24 04          	mov    %eax,0x4(%esp)
  801884:	89 1c 24             	mov    %ebx,(%esp)
  801887:	e8 91 fe ff ff       	call   80171d <fd_lookup>
  80188c:	85 c0                	test   %eax,%eax
  80188e:	78 5f                	js     8018ef <ftruncate+0x7c>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801890:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801893:	89 44 24 04          	mov    %eax,0x4(%esp)
  801897:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80189a:	8b 00                	mov    (%eax),%eax
  80189c:	89 04 24             	mov    %eax,(%esp)
  80189f:	e8 ed fe ff ff       	call   801791 <dev_lookup>
ftruncate(int fdnum, off_t newsize)
{
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  8018a4:	85 c0                	test   %eax,%eax
  8018a6:	78 47                	js     8018ef <ftruncate+0x7c>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8018a8:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8018ab:	f6 42 08 03          	testb  $0x3,0x8(%edx)
  8018af:	75 23                	jne    8018d4 <ftruncate+0x61>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			env->env_id, fdnum); 
  8018b1:	a1 7c 70 80 00       	mov    0x80707c,%eax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  8018b6:	8b 40 4c             	mov    0x4c(%eax),%eax
  8018b9:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8018bd:	89 44 24 04          	mov    %eax,0x4(%esp)
  8018c1:	c7 04 24 9c 3a 80 00 	movl   $0x803a9c,(%esp)
  8018c8:	e8 1c ea ff ff       	call   8002e9 <cprintf>
  8018cd:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
			env->env_id, fdnum); 
		return -E_INVAL;
  8018d2:	eb 1b                	jmp    8018ef <ftruncate+0x7c>
	}
	if (!dev->dev_trunc)
  8018d4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8018d7:	8b 48 18             	mov    0x18(%eax),%ecx
  8018da:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8018df:	85 c9                	test   %ecx,%ecx
  8018e1:	74 0c                	je     8018ef <ftruncate+0x7c>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  8018e3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8018e6:	89 44 24 04          	mov    %eax,0x4(%esp)
  8018ea:	89 14 24             	mov    %edx,(%esp)
  8018ed:	ff d1                	call   *%ecx
}
  8018ef:	83 c4 24             	add    $0x24,%esp
  8018f2:	5b                   	pop    %ebx
  8018f3:	5d                   	pop    %ebp
  8018f4:	c3                   	ret    

008018f5 <write>:
	return tot;
}

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  8018f5:	55                   	push   %ebp
  8018f6:	89 e5                	mov    %esp,%ebp
  8018f8:	53                   	push   %ebx
  8018f9:	83 ec 24             	sub    $0x24,%esp
  8018fc:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8018ff:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801902:	89 44 24 04          	mov    %eax,0x4(%esp)
  801906:	89 1c 24             	mov    %ebx,(%esp)
  801909:	e8 0f fe ff ff       	call   80171d <fd_lookup>
  80190e:	85 c0                	test   %eax,%eax
  801910:	78 66                	js     801978 <write+0x83>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801912:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801915:	89 44 24 04          	mov    %eax,0x4(%esp)
  801919:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80191c:	8b 00                	mov    (%eax),%eax
  80191e:	89 04 24             	mov    %eax,(%esp)
  801921:	e8 6b fe ff ff       	call   801791 <dev_lookup>
{
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801926:	85 c0                	test   %eax,%eax
  801928:	78 4e                	js     801978 <write+0x83>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  80192a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80192d:	f6 42 08 03          	testb  $0x3,0x8(%edx)
  801931:	75 23                	jne    801956 <write+0x61>
		cprintf("[%08x] write %d -- bad mode\n", env->env_id, fdnum);
  801933:	a1 7c 70 80 00       	mov    0x80707c,%eax
  801938:	8b 40 4c             	mov    0x4c(%eax),%eax
  80193b:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80193f:	89 44 24 04          	mov    %eax,0x4(%esp)
  801943:	c7 04 24 bd 3a 80 00 	movl   $0x803abd,(%esp)
  80194a:	e8 9a e9 ff ff       	call   8002e9 <cprintf>
  80194f:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
		return -E_INVAL;
  801954:	eb 22                	jmp    801978 <write+0x83>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  801956:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801959:	8b 48 0c             	mov    0xc(%eax),%ecx
  80195c:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801961:	85 c9                	test   %ecx,%ecx
  801963:	74 13                	je     801978 <write+0x83>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  801965:	8b 45 10             	mov    0x10(%ebp),%eax
  801968:	89 44 24 08          	mov    %eax,0x8(%esp)
  80196c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80196f:	89 44 24 04          	mov    %eax,0x4(%esp)
  801973:	89 14 24             	mov    %edx,(%esp)
  801976:	ff d1                	call   *%ecx
}
  801978:	83 c4 24             	add    $0x24,%esp
  80197b:	5b                   	pop    %ebx
  80197c:	5d                   	pop    %ebp
  80197d:	c3                   	ret    

0080197e <read>:
	return r;
}

ssize_t
read(int fdnum, void *buf, size_t n)
{
  80197e:	55                   	push   %ebp
  80197f:	89 e5                	mov    %esp,%ebp
  801981:	53                   	push   %ebx
  801982:	83 ec 24             	sub    $0x24,%esp
  801985:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801988:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80198b:	89 44 24 04          	mov    %eax,0x4(%esp)
  80198f:	89 1c 24             	mov    %ebx,(%esp)
  801992:	e8 86 fd ff ff       	call   80171d <fd_lookup>
  801997:	85 c0                	test   %eax,%eax
  801999:	78 6b                	js     801a06 <read+0x88>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80199b:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80199e:	89 44 24 04          	mov    %eax,0x4(%esp)
  8019a2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8019a5:	8b 00                	mov    (%eax),%eax
  8019a7:	89 04 24             	mov    %eax,(%esp)
  8019aa:	e8 e2 fd ff ff       	call   801791 <dev_lookup>
{
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8019af:	85 c0                	test   %eax,%eax
  8019b1:	78 53                	js     801a06 <read+0x88>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  8019b3:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8019b6:	8b 42 08             	mov    0x8(%edx),%eax
  8019b9:	83 e0 03             	and    $0x3,%eax
  8019bc:	83 f8 01             	cmp    $0x1,%eax
  8019bf:	75 23                	jne    8019e4 <read+0x66>
		cprintf("[%08x] read %d -- bad mode\n", env->env_id, fdnum); 
  8019c1:	a1 7c 70 80 00       	mov    0x80707c,%eax
  8019c6:	8b 40 4c             	mov    0x4c(%eax),%eax
  8019c9:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8019cd:	89 44 24 04          	mov    %eax,0x4(%esp)
  8019d1:	c7 04 24 da 3a 80 00 	movl   $0x803ada,(%esp)
  8019d8:	e8 0c e9 ff ff       	call   8002e9 <cprintf>
  8019dd:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
		return -E_INVAL;
  8019e2:	eb 22                	jmp    801a06 <read+0x88>
	}
	if (!dev->dev_read)
  8019e4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8019e7:	8b 48 08             	mov    0x8(%eax),%ecx
  8019ea:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8019ef:	85 c9                	test   %ecx,%ecx
  8019f1:	74 13                	je     801a06 <read+0x88>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  8019f3:	8b 45 10             	mov    0x10(%ebp),%eax
  8019f6:	89 44 24 08          	mov    %eax,0x8(%esp)
  8019fa:	8b 45 0c             	mov    0xc(%ebp),%eax
  8019fd:	89 44 24 04          	mov    %eax,0x4(%esp)
  801a01:	89 14 24             	mov    %edx,(%esp)
  801a04:	ff d1                	call   *%ecx
}
  801a06:	83 c4 24             	add    $0x24,%esp
  801a09:	5b                   	pop    %ebx
  801a0a:	5d                   	pop    %ebp
  801a0b:	c3                   	ret    

00801a0c <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  801a0c:	55                   	push   %ebp
  801a0d:	89 e5                	mov    %esp,%ebp
  801a0f:	57                   	push   %edi
  801a10:	56                   	push   %esi
  801a11:	53                   	push   %ebx
  801a12:	83 ec 1c             	sub    $0x1c,%esp
  801a15:	8b 7d 08             	mov    0x8(%ebp),%edi
  801a18:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  801a1b:	ba 00 00 00 00       	mov    $0x0,%edx
  801a20:	bb 00 00 00 00       	mov    $0x0,%ebx
  801a25:	b8 00 00 00 00       	mov    $0x0,%eax
  801a2a:	85 f6                	test   %esi,%esi
  801a2c:	74 29                	je     801a57 <readn+0x4b>
		m = read(fdnum, (char*)buf + tot, n - tot);
  801a2e:	89 f0                	mov    %esi,%eax
  801a30:	29 d0                	sub    %edx,%eax
  801a32:	89 44 24 08          	mov    %eax,0x8(%esp)
  801a36:	03 55 0c             	add    0xc(%ebp),%edx
  801a39:	89 54 24 04          	mov    %edx,0x4(%esp)
  801a3d:	89 3c 24             	mov    %edi,(%esp)
  801a40:	e8 39 ff ff ff       	call   80197e <read>
		if (m < 0)
  801a45:	85 c0                	test   %eax,%eax
  801a47:	78 0e                	js     801a57 <readn+0x4b>
			return m;
		if (m == 0)
  801a49:	85 c0                	test   %eax,%eax
  801a4b:	74 08                	je     801a55 <readn+0x49>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  801a4d:	01 c3                	add    %eax,%ebx
  801a4f:	89 da                	mov    %ebx,%edx
  801a51:	39 f3                	cmp    %esi,%ebx
  801a53:	72 d9                	jb     801a2e <readn+0x22>
  801a55:	89 d8                	mov    %ebx,%eax
			return m;
		if (m == 0)
			break;
	}
	return tot;
}
  801a57:	83 c4 1c             	add    $0x1c,%esp
  801a5a:	5b                   	pop    %ebx
  801a5b:	5e                   	pop    %esi
  801a5c:	5f                   	pop    %edi
  801a5d:	5d                   	pop    %ebp
  801a5e:	c3                   	ret    

00801a5f <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  801a5f:	55                   	push   %ebp
  801a60:	89 e5                	mov    %esp,%ebp
  801a62:	56                   	push   %esi
  801a63:	53                   	push   %ebx
  801a64:	83 ec 20             	sub    $0x20,%esp
  801a67:	8b 75 08             	mov    0x8(%ebp),%esi
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801a6a:	89 34 24             	mov    %esi,(%esp)
  801a6d:	e8 0e fc ff ff       	call   801680 <fd2num>
  801a72:	8d 55 f4             	lea    -0xc(%ebp),%edx
  801a75:	89 54 24 04          	mov    %edx,0x4(%esp)
  801a79:	89 04 24             	mov    %eax,(%esp)
  801a7c:	e8 9c fc ff ff       	call   80171d <fd_lookup>
  801a81:	89 c3                	mov    %eax,%ebx
  801a83:	85 c0                	test   %eax,%eax
  801a85:	78 05                	js     801a8c <fd_close+0x2d>
  801a87:	3b 75 f4             	cmp    -0xc(%ebp),%esi
  801a8a:	74 0c                	je     801a98 <fd_close+0x39>
	    || fd != fd2)
		return (must_exist ? r : 0);
  801a8c:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  801a90:	19 c0                	sbb    %eax,%eax
  801a92:	f7 d0                	not    %eax
  801a94:	21 c3                	and    %eax,%ebx
  801a96:	eb 3d                	jmp    801ad5 <fd_close+0x76>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  801a98:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801a9b:	89 44 24 04          	mov    %eax,0x4(%esp)
  801a9f:	8b 06                	mov    (%esi),%eax
  801aa1:	89 04 24             	mov    %eax,(%esp)
  801aa4:	e8 e8 fc ff ff       	call   801791 <dev_lookup>
  801aa9:	89 c3                	mov    %eax,%ebx
  801aab:	85 c0                	test   %eax,%eax
  801aad:	78 16                	js     801ac5 <fd_close+0x66>
		if (dev->dev_close)
  801aaf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801ab2:	8b 40 10             	mov    0x10(%eax),%eax
  801ab5:	bb 00 00 00 00       	mov    $0x0,%ebx
  801aba:	85 c0                	test   %eax,%eax
  801abc:	74 07                	je     801ac5 <fd_close+0x66>
			r = (*dev->dev_close)(fd);
  801abe:	89 34 24             	mov    %esi,(%esp)
  801ac1:	ff d0                	call   *%eax
  801ac3:	89 c3                	mov    %eax,%ebx
		else
			r = 0;
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  801ac5:	89 74 24 04          	mov    %esi,0x4(%esp)
  801ac9:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801ad0:	e8 0a f6 ff ff       	call   8010df <sys_page_unmap>
	return r;
}
  801ad5:	89 d8                	mov    %ebx,%eax
  801ad7:	83 c4 20             	add    $0x20,%esp
  801ada:	5b                   	pop    %ebx
  801adb:	5e                   	pop    %esi
  801adc:	5d                   	pop    %ebp
  801add:	c3                   	ret    

00801ade <close>:
	return -E_INVAL;
}

int
close(int fdnum)
{
  801ade:	55                   	push   %ebp
  801adf:	89 e5                	mov    %esp,%ebp
  801ae1:	83 ec 28             	sub    $0x28,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801ae4:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801ae7:	89 44 24 04          	mov    %eax,0x4(%esp)
  801aeb:	8b 45 08             	mov    0x8(%ebp),%eax
  801aee:	89 04 24             	mov    %eax,(%esp)
  801af1:	e8 27 fc ff ff       	call   80171d <fd_lookup>
  801af6:	85 c0                	test   %eax,%eax
  801af8:	78 13                	js     801b0d <close+0x2f>
		return r;
	else
		return fd_close(fd, 1);
  801afa:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  801b01:	00 
  801b02:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801b05:	89 04 24             	mov    %eax,(%esp)
  801b08:	e8 52 ff ff ff       	call   801a5f <fd_close>
}
  801b0d:	c9                   	leave  
  801b0e:	c3                   	ret    

00801b0f <stat>:
	return (*dev->dev_stat)(fd, stat);
}

int
stat(const char *path, struct Stat *stat)
{
  801b0f:	55                   	push   %ebp
  801b10:	89 e5                	mov    %esp,%ebp
  801b12:	83 ec 18             	sub    $0x18,%esp
  801b15:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  801b18:	89 75 fc             	mov    %esi,-0x4(%ebp)
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  801b1b:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  801b22:	00 
  801b23:	8b 45 08             	mov    0x8(%ebp),%eax
  801b26:	89 04 24             	mov    %eax,(%esp)
  801b29:	e8 55 03 00 00       	call   801e83 <open>
  801b2e:	89 c3                	mov    %eax,%ebx
  801b30:	85 c0                	test   %eax,%eax
  801b32:	78 1b                	js     801b4f <stat+0x40>
		return fd;
	r = fstat(fd, stat);
  801b34:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b37:	89 44 24 04          	mov    %eax,0x4(%esp)
  801b3b:	89 1c 24             	mov    %ebx,(%esp)
  801b3e:	e8 b7 fc ff ff       	call   8017fa <fstat>
  801b43:	89 c6                	mov    %eax,%esi
	close(fd);
  801b45:	89 1c 24             	mov    %ebx,(%esp)
  801b48:	e8 91 ff ff ff       	call   801ade <close>
  801b4d:	89 f3                	mov    %esi,%ebx
	return r;
}
  801b4f:	89 d8                	mov    %ebx,%eax
  801b51:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  801b54:	8b 75 fc             	mov    -0x4(%ebp),%esi
  801b57:	89 ec                	mov    %ebp,%esp
  801b59:	5d                   	pop    %ebp
  801b5a:	c3                   	ret    

00801b5b <close_all>:
		return fd_close(fd, 1);
}

void
close_all(void)
{
  801b5b:	55                   	push   %ebp
  801b5c:	89 e5                	mov    %esp,%ebp
  801b5e:	53                   	push   %ebx
  801b5f:	83 ec 14             	sub    $0x14,%esp
  801b62:	bb 00 00 00 00       	mov    $0x0,%ebx
	int i;
	for (i = 0; i < MAXFD; i++)
		close(i);
  801b67:	89 1c 24             	mov    %ebx,(%esp)
  801b6a:	e8 6f ff ff ff       	call   801ade <close>

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  801b6f:	83 c3 01             	add    $0x1,%ebx
  801b72:	83 fb 20             	cmp    $0x20,%ebx
  801b75:	75 f0                	jne    801b67 <close_all+0xc>
		close(i);
}
  801b77:	83 c4 14             	add    $0x14,%esp
  801b7a:	5b                   	pop    %ebx
  801b7b:	5d                   	pop    %ebp
  801b7c:	c3                   	ret    

00801b7d <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  801b7d:	55                   	push   %ebp
  801b7e:	89 e5                	mov    %esp,%ebp
  801b80:	83 ec 58             	sub    $0x58,%esp
  801b83:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  801b86:	89 75 f8             	mov    %esi,-0x8(%ebp)
  801b89:	89 7d fc             	mov    %edi,-0x4(%ebp)
  801b8c:	8b 7d 0c             	mov    0xc(%ebp),%edi
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  801b8f:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  801b92:	89 44 24 04          	mov    %eax,0x4(%esp)
  801b96:	8b 45 08             	mov    0x8(%ebp),%eax
  801b99:	89 04 24             	mov    %eax,(%esp)
  801b9c:	e8 7c fb ff ff       	call   80171d <fd_lookup>
  801ba1:	89 c3                	mov    %eax,%ebx
  801ba3:	85 c0                	test   %eax,%eax
  801ba5:	0f 88 e0 00 00 00    	js     801c8b <dup+0x10e>
		return r;
	close(newfdnum);
  801bab:	89 3c 24             	mov    %edi,(%esp)
  801bae:	e8 2b ff ff ff       	call   801ade <close>

	newfd = INDEX2FD(newfdnum);
  801bb3:	8d b7 00 00 0d 00    	lea    0xd0000(%edi),%esi
  801bb9:	c1 e6 0c             	shl    $0xc,%esi
	ova = fd2data(oldfd);
  801bbc:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801bbf:	89 04 24             	mov    %eax,(%esp)
  801bc2:	e8 c9 fa ff ff       	call   801690 <fd2data>
  801bc7:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  801bc9:	89 34 24             	mov    %esi,(%esp)
  801bcc:	e8 bf fa ff ff       	call   801690 <fd2data>
  801bd1:	89 45 d4             	mov    %eax,-0x2c(%ebp)

	if ((vpd[PDX(ova)] & PTE_P) && (vpt[VPN(ova)] & PTE_P))
  801bd4:	89 da                	mov    %ebx,%edx
  801bd6:	89 d8                	mov    %ebx,%eax
  801bd8:	c1 e8 16             	shr    $0x16,%eax
  801bdb:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801be2:	a8 01                	test   $0x1,%al
  801be4:	74 43                	je     801c29 <dup+0xac>
  801be6:	c1 ea 0c             	shr    $0xc,%edx
  801be9:	8b 04 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%eax
  801bf0:	a8 01                	test   $0x1,%al
  801bf2:	74 35                	je     801c29 <dup+0xac>
		if ((r = sys_page_map(0, ova, 0, nva, vpt[VPN(ova)] & PTE_USER)) < 0)
  801bf4:	8b 04 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%eax
  801bfb:	25 07 0e 00 00       	and    $0xe07,%eax
  801c00:	89 44 24 10          	mov    %eax,0x10(%esp)
  801c04:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801c07:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801c0b:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801c12:	00 
  801c13:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801c17:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801c1e:	e8 1a f5 ff ff       	call   80113d <sys_page_map>
  801c23:	89 c3                	mov    %eax,%ebx
  801c25:	85 c0                	test   %eax,%eax
  801c27:	78 3f                	js     801c68 <dup+0xeb>
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, vpt[VPN(oldfd)] & PTE_USER)) < 0)
  801c29:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801c2c:	89 c2                	mov    %eax,%edx
  801c2e:	c1 ea 0c             	shr    $0xc,%edx
  801c31:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801c38:	81 e2 07 0e 00 00    	and    $0xe07,%edx
  801c3e:	89 54 24 10          	mov    %edx,0x10(%esp)
  801c42:	89 74 24 0c          	mov    %esi,0xc(%esp)
  801c46:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801c4d:	00 
  801c4e:	89 44 24 04          	mov    %eax,0x4(%esp)
  801c52:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801c59:	e8 df f4 ff ff       	call   80113d <sys_page_map>
  801c5e:	89 c3                	mov    %eax,%ebx
  801c60:	85 c0                	test   %eax,%eax
  801c62:	78 04                	js     801c68 <dup+0xeb>
  801c64:	89 fb                	mov    %edi,%ebx
  801c66:	eb 23                	jmp    801c8b <dup+0x10e>
		goto err;

	return newfdnum;

err:
	sys_page_unmap(0, newfd);
  801c68:	89 74 24 04          	mov    %esi,0x4(%esp)
  801c6c:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801c73:	e8 67 f4 ff ff       	call   8010df <sys_page_unmap>
	sys_page_unmap(0, nva);
  801c78:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801c7b:	89 44 24 04          	mov    %eax,0x4(%esp)
  801c7f:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801c86:	e8 54 f4 ff ff       	call   8010df <sys_page_unmap>
	return r;
}
  801c8b:	89 d8                	mov    %ebx,%eax
  801c8d:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  801c90:	8b 75 f8             	mov    -0x8(%ebp),%esi
  801c93:	8b 7d fc             	mov    -0x4(%ebp),%edi
  801c96:	89 ec                	mov    %ebp,%esp
  801c98:	5d                   	pop    %ebp
  801c99:	c3                   	ret    
	...

00801c9c <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  801c9c:	55                   	push   %ebp
  801c9d:	89 e5                	mov    %esp,%ebp
  801c9f:	53                   	push   %ebx
  801ca0:	83 ec 14             	sub    $0x14,%esp
  801ca3:	89 d3                	mov    %edx,%ebx
	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", env->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(envs[1].env_id, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  801ca5:	8b 15 c8 00 c0 ee    	mov    0xeec000c8,%edx
  801cab:	c7 44 24 0c 07 00 00 	movl   $0x7,0xc(%esp)
  801cb2:	00 
  801cb3:	c7 44 24 08 00 40 80 	movl   $0x804000,0x8(%esp)
  801cba:	00 
  801cbb:	89 44 24 04          	mov    %eax,0x4(%esp)
  801cbf:	89 14 24             	mov    %edx,(%esp)
  801cc2:	e8 19 14 00 00       	call   8030e0 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  801cc7:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801cce:	00 
  801ccf:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801cd3:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801cda:	e8 67 14 00 00       	call   803146 <ipc_recv>
}
  801cdf:	83 c4 14             	add    $0x14,%esp
  801ce2:	5b                   	pop    %ebx
  801ce3:	5d                   	pop    %ebp
  801ce4:	c3                   	ret    

00801ce5 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  801ce5:	55                   	push   %ebp
  801ce6:	89 e5                	mov    %esp,%ebp
  801ce8:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  801ceb:	8b 45 08             	mov    0x8(%ebp),%eax
  801cee:	8b 40 0c             	mov    0xc(%eax),%eax
  801cf1:	a3 00 40 80 00       	mov    %eax,0x804000
	fsipcbuf.set_size.req_size = newsize;
  801cf6:	8b 45 0c             	mov    0xc(%ebp),%eax
  801cf9:	a3 04 40 80 00       	mov    %eax,0x804004
	return fsipc(FSREQ_SET_SIZE, NULL);
  801cfe:	ba 00 00 00 00       	mov    $0x0,%edx
  801d03:	b8 02 00 00 00       	mov    $0x2,%eax
  801d08:	e8 8f ff ff ff       	call   801c9c <fsipc>
}
  801d0d:	c9                   	leave  
  801d0e:	c3                   	ret    

00801d0f <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  801d0f:	55                   	push   %ebp
  801d10:	89 e5                	mov    %esp,%ebp
  801d12:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  801d15:	8b 45 08             	mov    0x8(%ebp),%eax
  801d18:	8b 40 0c             	mov    0xc(%eax),%eax
  801d1b:	a3 00 40 80 00       	mov    %eax,0x804000
	return fsipc(FSREQ_FLUSH, NULL);
  801d20:	ba 00 00 00 00       	mov    $0x0,%edx
  801d25:	b8 06 00 00 00       	mov    $0x6,%eax
  801d2a:	e8 6d ff ff ff       	call   801c9c <fsipc>
}
  801d2f:	c9                   	leave  
  801d30:	c3                   	ret    

00801d31 <sync>:
}

// Synchronize disk with buffer cache
int
sync(void)
{
  801d31:	55                   	push   %ebp
  801d32:	89 e5                	mov    %esp,%ebp
  801d34:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  801d37:	ba 00 00 00 00       	mov    $0x0,%edx
  801d3c:	b8 08 00 00 00       	mov    $0x8,%eax
  801d41:	e8 56 ff ff ff       	call   801c9c <fsipc>
}
  801d46:	c9                   	leave  
  801d47:	c3                   	ret    

00801d48 <devfile_stat>:
	return fsipc(FSREQ_WRITE, NULL);	
}

static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  801d48:	55                   	push   %ebp
  801d49:	89 e5                	mov    %esp,%ebp
  801d4b:	53                   	push   %ebx
  801d4c:	83 ec 14             	sub    $0x14,%esp
  801d4f:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  801d52:	8b 45 08             	mov    0x8(%ebp),%eax
  801d55:	8b 40 0c             	mov    0xc(%eax),%eax
  801d58:	a3 00 40 80 00       	mov    %eax,0x804000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  801d5d:	ba 00 00 00 00       	mov    $0x0,%edx
  801d62:	b8 05 00 00 00       	mov    $0x5,%eax
  801d67:	e8 30 ff ff ff       	call   801c9c <fsipc>
  801d6c:	85 c0                	test   %eax,%eax
  801d6e:	78 2b                	js     801d9b <devfile_stat+0x53>
		return r;
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  801d70:	c7 44 24 04 00 40 80 	movl   $0x804000,0x4(%esp)
  801d77:	00 
  801d78:	89 1c 24             	mov    %ebx,(%esp)
  801d7b:	e8 2a ec ff ff       	call   8009aa <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  801d80:	a1 80 40 80 00       	mov    0x804080,%eax
  801d85:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  801d8b:	a1 84 40 80 00       	mov    0x804084,%eax
  801d90:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
  801d96:	b8 00 00 00 00       	mov    $0x0,%eax
	return 0;
}
  801d9b:	83 c4 14             	add    $0x14,%esp
  801d9e:	5b                   	pop    %ebx
  801d9f:	5d                   	pop    %ebp
  801da0:	c3                   	ret    

00801da1 <devfile_write>:
// Returns:
//	 The number of bytes successfully written.
//	 < 0 on error.
static ssize_t
devfile_write(struct Fd *fd, const void *buf, size_t n)
{
  801da1:	55                   	push   %ebp
  801da2:	89 e5                	mov    %esp,%ebp
  801da4:	83 ec 18             	sub    $0x18,%esp
  801da7:	8b 45 10             	mov    0x10(%ebp),%eax
  801daa:	3d f8 0f 00 00       	cmp    $0xff8,%eax
  801daf:	76 05                	jbe    801db6 <devfile_write+0x15>
  801db1:	b8 f8 0f 00 00       	mov    $0xff8,%eax
	// LAB 5: Your code here
	//panic("devfile_write not implemented");
	
	if (n > (PGSIZE - (sizeof(int) + sizeof(size_t))))
		n = PGSIZE - (sizeof(int) + sizeof(size_t));
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  801db6:	8b 55 08             	mov    0x8(%ebp),%edx
  801db9:	8b 52 0c             	mov    0xc(%edx),%edx
  801dbc:	89 15 00 40 80 00    	mov    %edx,0x804000
	fsipcbuf.write.req_n = n;
  801dc2:	a3 04 40 80 00       	mov    %eax,0x804004
	memmove (fsipcbuf.write.req_buf, (char*)buf, n);	
  801dc7:	89 44 24 08          	mov    %eax,0x8(%esp)
  801dcb:	8b 45 0c             	mov    0xc(%ebp),%eax
  801dce:	89 44 24 04          	mov    %eax,0x4(%esp)
  801dd2:	c7 04 24 08 40 80 00 	movl   $0x804008,(%esp)
  801dd9:	e8 87 ed ff ff       	call   800b65 <memmove>
	return fsipc(FSREQ_WRITE, NULL);	
  801dde:	ba 00 00 00 00       	mov    $0x0,%edx
  801de3:	b8 04 00 00 00       	mov    $0x4,%eax
  801de8:	e8 af fe ff ff       	call   801c9c <fsipc>
}
  801ded:	c9                   	leave  
  801dee:	c3                   	ret    

00801def <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  801def:	55                   	push   %ebp
  801df0:	89 e5                	mov    %esp,%ebp
  801df2:	53                   	push   %ebx
  801df3:	83 ec 14             	sub    $0x14,%esp
	// system server.
	// LAB 5: Your code here
	
	//panic("devfile_read not implemented");
	int r;
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  801df6:	8b 45 08             	mov    0x8(%ebp),%eax
  801df9:	8b 40 0c             	mov    0xc(%eax),%eax
  801dfc:	a3 00 40 80 00       	mov    %eax,0x804000
	fsipcbuf.read.req_n = n;
  801e01:	8b 45 10             	mov    0x10(%ebp),%eax
  801e04:	a3 04 40 80 00       	mov    %eax,0x804004
	if ((r = fsipc(FSREQ_READ, (void*)&fsipcbuf)) < 0)
  801e09:	ba 00 40 80 00       	mov    $0x804000,%edx
  801e0e:	b8 03 00 00 00       	mov    $0x3,%eax
  801e13:	e8 84 fe ff ff       	call   801c9c <fsipc>
  801e18:	89 c3                	mov    %eax,%ebx
  801e1a:	85 c0                	test   %eax,%eax
  801e1c:	78 17                	js     801e35 <devfile_read+0x46>
		return r;
	memmove((void*)buf, (void*)fsipcbuf.readRet.ret_buf, r);
  801e1e:	89 44 24 08          	mov    %eax,0x8(%esp)
  801e22:	c7 44 24 04 00 40 80 	movl   $0x804000,0x4(%esp)
  801e29:	00 
  801e2a:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e2d:	89 04 24             	mov    %eax,(%esp)
  801e30:	e8 30 ed ff ff       	call   800b65 <memmove>
	return r;
}
  801e35:	89 d8                	mov    %ebx,%eax
  801e37:	83 c4 14             	add    $0x14,%esp
  801e3a:	5b                   	pop    %ebx
  801e3b:	5d                   	pop    %ebp
  801e3c:	c3                   	ret    

00801e3d <remove>:
}

// Delete a file
int
remove(const char *path)
{
  801e3d:	55                   	push   %ebp
  801e3e:	89 e5                	mov    %esp,%ebp
  801e40:	53                   	push   %ebx
  801e41:	83 ec 14             	sub    $0x14,%esp
  801e44:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (strlen(path) >= MAXPATHLEN)
  801e47:	89 1c 24             	mov    %ebx,(%esp)
  801e4a:	e8 11 eb ff ff       	call   800960 <strlen>
  801e4f:	89 c2                	mov    %eax,%edx
  801e51:	b8 f4 ff ff ff       	mov    $0xfffffff4,%eax
  801e56:	81 fa ff 03 00 00    	cmp    $0x3ff,%edx
  801e5c:	7f 1f                	jg     801e7d <remove+0x40>
		return -E_BAD_PATH;
	strcpy(fsipcbuf.remove.req_path, path);
  801e5e:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801e62:	c7 04 24 00 40 80 00 	movl   $0x804000,(%esp)
  801e69:	e8 3c eb ff ff       	call   8009aa <strcpy>
	return fsipc(FSREQ_REMOVE, NULL);
  801e6e:	ba 00 00 00 00       	mov    $0x0,%edx
  801e73:	b8 07 00 00 00       	mov    $0x7,%eax
  801e78:	e8 1f fe ff ff       	call   801c9c <fsipc>
}
  801e7d:	83 c4 14             	add    $0x14,%esp
  801e80:	5b                   	pop    %ebx
  801e81:	5d                   	pop    %ebp
  801e82:	c3                   	ret    

00801e83 <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  801e83:	55                   	push   %ebp
  801e84:	89 e5                	mov    %esp,%ebp
  801e86:	83 ec 28             	sub    $0x28,%esp
  801e89:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  801e8c:	89 75 fc             	mov    %esi,-0x4(%ebp)
  801e8f:	8b 75 08             	mov    0x8(%ebp),%esi
	// file descriptor.

	// LAB 5: Your code here.
	// Code added by Swastika / Sandeep
	
	if (strlen(path) >= MAXPATHLEN)
  801e92:	89 34 24             	mov    %esi,(%esp)
  801e95:	e8 c6 ea ff ff       	call   800960 <strlen>
  801e9a:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  801e9f:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  801ea4:	7f 5e                	jg     801f04 <open+0x81>
		return -E_BAD_PATH;
	struct Fd * fd;
	int  r;
	if ((r = fd_alloc(&fd)) < 0)
  801ea6:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801ea9:	89 04 24             	mov    %eax,(%esp)
  801eac:	e8 fa f7 ff ff       	call   8016ab <fd_alloc>
  801eb1:	89 c3                	mov    %eax,%ebx
  801eb3:	85 c0                	test   %eax,%eax
  801eb5:	78 4d                	js     801f04 <open+0x81>
		return r;
	strcpy (fsipcbuf.open.req_path, path);
  801eb7:	89 74 24 04          	mov    %esi,0x4(%esp)
  801ebb:	c7 04 24 00 40 80 00 	movl   $0x804000,(%esp)
  801ec2:	e8 e3 ea ff ff       	call   8009aa <strcpy>
	fsipcbuf.open.req_omode = mode;	
  801ec7:	8b 45 0c             	mov    0xc(%ebp),%eax
  801eca:	a3 00 44 80 00       	mov    %eax,0x804400
	if ((r = fsipc(FSREQ_OPEN,(void*)fd)) < 0)
  801ecf:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801ed2:	b8 01 00 00 00       	mov    $0x1,%eax
  801ed7:	e8 c0 fd ff ff       	call   801c9c <fsipc>
  801edc:	89 c3                	mov    %eax,%ebx
  801ede:	85 c0                	test   %eax,%eax
  801ee0:	79 15                	jns    801ef7 <open+0x74>
	{
		fd_close(fd,0);
  801ee2:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  801ee9:	00 
  801eea:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801eed:	89 04 24             	mov    %eax,(%esp)
  801ef0:	e8 6a fb ff ff       	call   801a5f <fd_close>
		return r; 
  801ef5:	eb 0d                	jmp    801f04 <open+0x81>
	}
	return fd2num(fd);
  801ef7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801efa:	89 04 24             	mov    %eax,(%esp)
  801efd:	e8 7e f7 ff ff       	call   801680 <fd2num>
  801f02:	89 c3                	mov    %eax,%ebx
	//panic("open not implemented");
}
  801f04:	89 d8                	mov    %ebx,%eax
  801f06:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  801f09:	8b 75 fc             	mov    -0x4(%ebp),%esi
  801f0c:	89 ec                	mov    %ebp,%esp
  801f0e:	5d                   	pop    %ebp
  801f0f:	c3                   	ret    

00801f10 <spawn>:
// argv: pointer to null-terminated array of pointers to strings,
// 	 which will be passed to the child as its command-line arguments.
// Returns child envid on success, < 0 on failure.
int
spawn(const char *prog, const char **argv)
{
  801f10:	55                   	push   %ebp
  801f11:	89 e5                	mov    %esp,%ebp
  801f13:	57                   	push   %edi
  801f14:	56                   	push   %esi
  801f15:	53                   	push   %ebx
  801f16:	81 ec 9c 02 00 00    	sub    $0x29c,%esp
	//   - Call sys_env_set_trapframe(child, &child_tf) to set up the
	//     correct initial eip and esp values in the child.
	//
	//   - Start the child process running with sys_env_set_status().

	if ((r = open(prog, O_RDONLY)) < 0)
  801f1c:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  801f23:	00 
  801f24:	8b 45 08             	mov    0x8(%ebp),%eax
  801f27:	89 04 24             	mov    %eax,(%esp)
  801f2a:	e8 54 ff ff ff       	call   801e83 <open>
  801f2f:	89 85 84 fd ff ff    	mov    %eax,-0x27c(%ebp)
  801f35:	89 c3                	mov    %eax,%ebx
  801f37:	85 c0                	test   %eax,%eax
  801f39:	0f 88 be 05 00 00    	js     8024fd <spawn+0x5ed>
	fd = r;

	// Read elf header
	elf = (struct Elf*) elf_buf;
	if (read(fd, elf_buf, sizeof(elf_buf)) != sizeof(elf_buf)
	    || elf->e_magic != ELF_MAGIC) {
  801f3f:	c7 44 24 08 00 02 00 	movl   $0x200,0x8(%esp)
  801f46:	00 
  801f47:	8d 85 e8 fd ff ff    	lea    -0x218(%ebp),%eax
  801f4d:	89 44 24 04          	mov    %eax,0x4(%esp)
  801f51:	89 1c 24             	mov    %ebx,(%esp)
  801f54:	e8 25 fa ff ff       	call   80197e <read>
		return r;
	fd = r;

	// Read elf header
	elf = (struct Elf*) elf_buf;
	if (read(fd, elf_buf, sizeof(elf_buf)) != sizeof(elf_buf)
  801f59:	3d 00 02 00 00       	cmp    $0x200,%eax
  801f5e:	75 0c                	jne    801f6c <spawn+0x5c>
	    || elf->e_magic != ELF_MAGIC) {
  801f60:	81 bd e8 fd ff ff 7f 	cmpl   $0x464c457f,-0x218(%ebp)
  801f67:	45 4c 46 
  801f6a:	74 36                	je     801fa2 <spawn+0x92>
		close(fd);
  801f6c:	8b 85 84 fd ff ff    	mov    -0x27c(%ebp),%eax
  801f72:	89 04 24             	mov    %eax,(%esp)
  801f75:	e8 64 fb ff ff       	call   801ade <close>
		cprintf("elf magic %08x want %08x\n", elf->e_magic, ELF_MAGIC);
  801f7a:	c7 44 24 08 7f 45 4c 	movl   $0x464c457f,0x8(%esp)
  801f81:	46 
  801f82:	8b 85 e8 fd ff ff    	mov    -0x218(%ebp),%eax
  801f88:	89 44 24 04          	mov    %eax,0x4(%esp)
  801f8c:	c7 04 24 0c 3b 80 00 	movl   $0x803b0c,(%esp)
  801f93:	e8 51 e3 ff ff       	call   8002e9 <cprintf>
  801f98:	bb f2 ff ff ff       	mov    $0xfffffff2,%ebx
		return -E_NOT_EXEC;
  801f9d:	e9 5b 05 00 00       	jmp    8024fd <spawn+0x5ed>
  801fa2:	ba 07 00 00 00       	mov    $0x7,%edx
  801fa7:	89 d0                	mov    %edx,%eax
  801fa9:	cd 30                	int    $0x30
  801fab:	89 85 8c fd ff ff    	mov    %eax,-0x274(%ebp)
	}

	// Create new child environment
	if ((r = sys_exofork()) < 0)
  801fb1:	85 c0                	test   %eax,%eax
  801fb3:	0f 88 3e 05 00 00    	js     8024f7 <spawn+0x5e7>
		return r;
	child = r;

	// Set up trap frame, including initial stack.
	child_tf = envs[ENVX(child)].env_tf;
  801fb9:	89 c6                	mov    %eax,%esi
  801fbb:	81 e6 ff 03 00 00    	and    $0x3ff,%esi
  801fc1:	6b f6 7c             	imul   $0x7c,%esi,%esi
  801fc4:	8d bd a4 fd ff ff    	lea    -0x25c(%ebp),%edi
  801fca:	81 c6 00 00 c0 ee    	add    $0xeec00000,%esi
  801fd0:	b9 11 00 00 00       	mov    $0x11,%ecx
  801fd5:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
	child_tf.tf_eip = elf->e_entry;
  801fd7:	8b 85 00 fe ff ff    	mov    -0x200(%ebp),%eax
  801fdd:	89 85 d4 fd ff ff    	mov    %eax,-0x22c(%ebp)
	uintptr_t *argv_store;

	// Count the number of arguments (argc)
	// and the total amount of space needed for strings (string_size).
	string_size = 0;
	for (argc = 0; argv[argc] != 0; argc++)
  801fe3:	8b 55 0c             	mov    0xc(%ebp),%edx
  801fe6:	8b 02                	mov    (%edx),%eax
  801fe8:	bb 00 00 00 00       	mov    $0x0,%ebx
  801fed:	be 00 00 00 00       	mov    $0x0,%esi
  801ff2:	85 c0                	test   %eax,%eax
  801ff4:	75 16                	jne    80200c <spawn+0xfc>
  801ff6:	c7 85 7c fd ff ff 00 	movl   $0x0,-0x284(%ebp)
  801ffd:	00 00 00 
  802000:	c7 85 78 fd ff ff 00 	movl   $0x0,-0x288(%ebp)
  802007:	00 00 00 
  80200a:	eb 2c                	jmp    802038 <spawn+0x128>
  80200c:	8b 7d 0c             	mov    0xc(%ebp),%edi
		string_size += strlen(argv[argc]) + 1;
  80200f:	89 04 24             	mov    %eax,(%esp)
  802012:	e8 49 e9 ff ff       	call   800960 <strlen>
  802017:	8d 5c 18 01          	lea    0x1(%eax,%ebx,1),%ebx
	uintptr_t *argv_store;

	// Count the number of arguments (argc)
	// and the total amount of space needed for strings (string_size).
	string_size = 0;
	for (argc = 0; argv[argc] != 0; argc++)
  80201b:	83 c6 01             	add    $0x1,%esi
  80201e:	8d 14 b5 00 00 00 00 	lea    0x0(,%esi,4),%edx
  802025:	8b 04 b7             	mov    (%edi,%esi,4),%eax
  802028:	85 c0                	test   %eax,%eax
  80202a:	75 e3                	jne    80200f <spawn+0xff>
  80202c:	89 95 7c fd ff ff    	mov    %edx,-0x284(%ebp)
  802032:	89 b5 78 fd ff ff    	mov    %esi,-0x288(%ebp)
	// Determine where to place the strings and the argv array.
	// Set up pointers into the temporary page 'UTEMP'; we'll map a page
	// there later, then remap that page into the child environment
	// at (USTACKTOP - PGSIZE).
	// strings is the topmost thing on the stack.
	string_store = (char*) UTEMP + PGSIZE - string_size;
  802038:	f7 db                	neg    %ebx
  80203a:	8d bb 00 10 40 00    	lea    0x401000(%ebx),%edi
	// argv is below that.  There's one argument pointer per argument, plus
	// a null pointer.
	argv_store = (uintptr_t*) (ROUNDDOWN(string_store, 4) - 4 * (argc + 1));
  802040:	89 fa                	mov    %edi,%edx
  802042:	83 e2 fc             	and    $0xfffffffc,%edx
  802045:	89 f0                	mov    %esi,%eax
  802047:	f7 d0                	not    %eax
  802049:	8d 04 82             	lea    (%edx,%eax,4),%eax
  80204c:	89 85 94 fd ff ff    	mov    %eax,-0x26c(%ebp)
	
	// Make sure that argv, strings, and the 2 words that hold 'argc'
	// and 'argv' themselves will all fit in a single stack page.
	if ((void*) (argv_store - 2) < (void*) UTEMP)
  802052:	83 e8 08             	sub    $0x8,%eax
  802055:	89 85 80 fd ff ff    	mov    %eax,-0x280(%ebp)
	return child;

error:
	sys_env_destroy(child);
	close(fd);
	return r;
  80205b:	bb fc ff ff ff       	mov    $0xfffffffc,%ebx
	// a null pointer.
	argv_store = (uintptr_t*) (ROUNDDOWN(string_store, 4) - 4 * (argc + 1));
	
	// Make sure that argv, strings, and the 2 words that hold 'argc'
	// and 'argv' themselves will all fit in a single stack page.
	if ((void*) (argv_store - 2) < (void*) UTEMP)
  802060:	3d ff ff 3f 00       	cmp    $0x3fffff,%eax
  802065:	0f 86 92 04 00 00    	jbe    8024fd <spawn+0x5ed>
		return -E_NO_MEM;

	// Allocate the single stack page at UTEMP.
	if ((r = sys_page_alloc(0, (void*) UTEMP, PTE_P|PTE_U|PTE_W)) < 0)
  80206b:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  802072:	00 
  802073:	c7 44 24 04 00 00 40 	movl   $0x400000,0x4(%esp)
  80207a:	00 
  80207b:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802082:	e8 14 f1 ff ff       	call   80119b <sys_page_alloc>
  802087:	89 c3                	mov    %eax,%ebx
  802089:	85 c0                	test   %eax,%eax
  80208b:	0f 88 6c 04 00 00    	js     8024fd <spawn+0x5ed>
	//	  (Again, argv should use an address valid in the child's
	//	  environment.)
	//
	//	* Set *init_esp to the initial stack pointer for the child,
	//	  (Again, use an address valid in the child's environment.)
	for (i = 0; i < argc; i++) {
  802091:	85 f6                	test   %esi,%esi
  802093:	7e 46                	jle    8020db <spawn+0x1cb>
  802095:	bb 00 00 00 00       	mov    $0x0,%ebx
  80209a:	89 b5 88 fd ff ff    	mov    %esi,-0x278(%ebp)
  8020a0:	8b 75 0c             	mov    0xc(%ebp),%esi
		argv_store[i] = UTEMP2USTACK(string_store);
  8020a3:	8d 87 00 d0 7f ee    	lea    -0x11803000(%edi),%eax
  8020a9:	8b 95 94 fd ff ff    	mov    -0x26c(%ebp),%edx
  8020af:	89 04 9a             	mov    %eax,(%edx,%ebx,4)
		strcpy(string_store, argv[i]);
  8020b2:	8b 04 9e             	mov    (%esi,%ebx,4),%eax
  8020b5:	89 44 24 04          	mov    %eax,0x4(%esp)
  8020b9:	89 3c 24             	mov    %edi,(%esp)
  8020bc:	e8 e9 e8 ff ff       	call   8009aa <strcpy>
		string_store += strlen(argv[i]) + 1;
  8020c1:	8b 04 9e             	mov    (%esi,%ebx,4),%eax
  8020c4:	89 04 24             	mov    %eax,(%esp)
  8020c7:	e8 94 e8 ff ff       	call   800960 <strlen>
  8020cc:	8d 7c 07 01          	lea    0x1(%edi,%eax,1),%edi
	//	  (Again, argv should use an address valid in the child's
	//	  environment.)
	//
	//	* Set *init_esp to the initial stack pointer for the child,
	//	  (Again, use an address valid in the child's environment.)
	for (i = 0; i < argc; i++) {
  8020d0:	83 c3 01             	add    $0x1,%ebx
  8020d3:	3b 9d 88 fd ff ff    	cmp    -0x278(%ebp),%ebx
  8020d9:	7c c8                	jl     8020a3 <spawn+0x193>
		argv_store[i] = UTEMP2USTACK(string_store);
		strcpy(string_store, argv[i]);
		string_store += strlen(argv[i]) + 1;
	}
	argv_store[argc] = 0;
  8020db:	8b 95 94 fd ff ff    	mov    -0x26c(%ebp),%edx
  8020e1:	8b 85 7c fd ff ff    	mov    -0x284(%ebp),%eax
  8020e7:	c7 04 02 00 00 00 00 	movl   $0x0,(%edx,%eax,1)
	assert(string_store == (char*)UTEMP + PGSIZE);
  8020ee:	81 ff 00 10 40 00    	cmp    $0x401000,%edi
  8020f4:	74 24                	je     80211a <spawn+0x20a>
  8020f6:	c7 44 24 0c ac 3b 80 	movl   $0x803bac,0xc(%esp)
  8020fd:	00 
  8020fe:	c7 44 24 08 26 3b 80 	movl   $0x803b26,0x8(%esp)
  802105:	00 
  802106:	c7 44 24 04 d9 00 00 	movl   $0xd9,0x4(%esp)
  80210d:	00 
  80210e:	c7 04 24 3b 3b 80 00 	movl   $0x803b3b,(%esp)
  802115:	e8 0a e1 ff ff       	call   800224 <_panic>

	argv_store[-1] = UTEMP2USTACK(argv_store);
  80211a:	8b 85 94 fd ff ff    	mov    -0x26c(%ebp),%eax
  802120:	2d 00 30 80 11       	sub    $0x11803000,%eax
  802125:	8b 95 94 fd ff ff    	mov    -0x26c(%ebp),%edx
  80212b:	89 42 fc             	mov    %eax,-0x4(%edx)
	argv_store[-2] = argc;
  80212e:	8b 95 78 fd ff ff    	mov    -0x288(%ebp),%edx
  802134:	8b 85 80 fd ff ff    	mov    -0x280(%ebp),%eax
  80213a:	89 10                	mov    %edx,(%eax)

	*init_esp = UTEMP2USTACK(&argv_store[-2]);
  80213c:	8b 85 94 fd ff ff    	mov    -0x26c(%ebp),%eax
  802142:	2d 08 30 80 11       	sub    $0x11803008,%eax
  802147:	89 85 e0 fd ff ff    	mov    %eax,-0x220(%ebp)

	// After completing the stack, map it into the child's address space
	// and unmap it from ours!
	if ((r = sys_page_map(0, UTEMP, child, (void*) (USTACKTOP - PGSIZE), PTE_P | PTE_U | PTE_W)) < 0)
  80214d:	c7 44 24 10 07 00 00 	movl   $0x7,0x10(%esp)
  802154:	00 
  802155:	c7 44 24 0c 00 d0 bf 	movl   $0xeebfd000,0xc(%esp)
  80215c:	ee 
  80215d:	8b 85 8c fd ff ff    	mov    -0x274(%ebp),%eax
  802163:	89 44 24 08          	mov    %eax,0x8(%esp)
  802167:	c7 44 24 04 00 00 40 	movl   $0x400000,0x4(%esp)
  80216e:	00 
  80216f:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802176:	e8 c2 ef ff ff       	call   80113d <sys_page_map>
  80217b:	89 c3                	mov    %eax,%ebx
  80217d:	85 c0                	test   %eax,%eax
  80217f:	78 1a                	js     80219b <spawn+0x28b>
		goto error;
	if ((r = sys_page_unmap(0, UTEMP)) < 0)
  802181:	c7 44 24 04 00 00 40 	movl   $0x400000,0x4(%esp)
  802188:	00 
  802189:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802190:	e8 4a ef ff ff       	call   8010df <sys_page_unmap>
  802195:	89 c3                	mov    %eax,%ebx
  802197:	85 c0                	test   %eax,%eax
  802199:	79 19                	jns    8021b4 <spawn+0x2a4>
		goto error;

	return 0;

error:
	sys_page_unmap(0, UTEMP);
  80219b:	c7 44 24 04 00 00 40 	movl   $0x400000,0x4(%esp)
  8021a2:	00 
  8021a3:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8021aa:	e8 30 ef ff ff       	call   8010df <sys_page_unmap>
  8021af:	e9 49 03 00 00       	jmp    8024fd <spawn+0x5ed>

	if ((r = init_stack(child, argv, &child_tf.tf_esp)) < 0)
		return r;

	// Set up program segments as defined in ELF header.
	ph = (struct Proghdr*) (elf_buf + elf->e_phoff);
  8021b4:	8b 85 04 fe ff ff    	mov    -0x1fc(%ebp),%eax
	for (i = 0; i < elf->e_phnum; i++, ph++) {
  8021ba:	66 83 bd 14 fe ff ff 	cmpw   $0x0,-0x1ec(%ebp)
  8021c1:	00 
  8021c2:	0f 84 e3 01 00 00    	je     8023ab <spawn+0x49b>

	if ((r = init_stack(child, argv, &child_tf.tf_esp)) < 0)
		return r;

	// Set up program segments as defined in ELF header.
	ph = (struct Proghdr*) (elf_buf + elf->e_phoff);
  8021c8:	8d 84 05 e8 fd ff ff 	lea    -0x218(%ebp,%eax,1),%eax
  8021cf:	89 85 80 fd ff ff    	mov    %eax,-0x280(%ebp)
  8021d5:	c7 85 7c fd ff ff 00 	movl   $0x0,-0x284(%ebp)
  8021dc:	00 00 00 
	for (i = 0; i < elf->e_phnum; i++, ph++) {
		if (ph->p_type != ELF_PROG_LOAD)
  8021df:	8b 95 80 fd ff ff    	mov    -0x280(%ebp),%edx
  8021e5:	83 3a 01             	cmpl   $0x1,(%edx)
  8021e8:	0f 85 9b 01 00 00    	jne    802389 <spawn+0x479>
			continue;
		perm = PTE_P | PTE_U;
		if (ph->p_flags & ELF_PROG_FLAG_WRITE)
  8021ee:	8b 42 18             	mov    0x18(%edx),%eax
  8021f1:	83 e0 02             	and    $0x2,%eax
  8021f4:	83 f8 01             	cmp    $0x1,%eax
  8021f7:	19 c0                	sbb    %eax,%eax
  8021f9:	83 e0 fe             	and    $0xfffffffe,%eax
  8021fc:	83 c0 07             	add    $0x7,%eax
  8021ff:	89 85 94 fd ff ff    	mov    %eax,-0x26c(%ebp)
			perm |= PTE_W;
		if ((r = map_segment(child, ph->p_va, ph->p_memsz, 
  802205:	8b 52 04             	mov    0x4(%edx),%edx
  802208:	89 95 78 fd ff ff    	mov    %edx,-0x288(%ebp)
  80220e:	8b 85 80 fd ff ff    	mov    -0x280(%ebp),%eax
  802214:	8b 58 10             	mov    0x10(%eax),%ebx
  802217:	8b 50 14             	mov    0x14(%eax),%edx
  80221a:	89 95 88 fd ff ff    	mov    %edx,-0x278(%ebp)
  802220:	8b 40 08             	mov    0x8(%eax),%eax
  802223:	89 85 90 fd ff ff    	mov    %eax,-0x270(%ebp)
	int i, r;
	void *blk;

	//cprintf("map_segment %x+%x\n", va, memsz);

	if ((i = PGOFF(va))) {
  802229:	25 ff 0f 00 00       	and    $0xfff,%eax
  80222e:	74 16                	je     802246 <spawn+0x336>
		va -= i;
  802230:	29 85 90 fd ff ff    	sub    %eax,-0x270(%ebp)
		memsz += i;
  802236:	01 c2                	add    %eax,%edx
  802238:	89 95 88 fd ff ff    	mov    %edx,-0x278(%ebp)
		filesz += i;
  80223e:	01 c3                	add    %eax,%ebx
		fileoffset -= i;
  802240:	29 85 78 fd ff ff    	sub    %eax,-0x288(%ebp)
	}

	for (i = 0; i < memsz; i += PGSIZE) {
  802246:	83 bd 88 fd ff ff 00 	cmpl   $0x0,-0x278(%ebp)
  80224d:	0f 84 36 01 00 00    	je     802389 <spawn+0x479>
  802253:	bf 00 00 00 00       	mov    $0x0,%edi
  802258:	be 00 00 00 00       	mov    $0x0,%esi
		if (i >= filesz) {
  80225d:	39 fb                	cmp    %edi,%ebx
  80225f:	77 31                	ja     802292 <spawn+0x382>
			// allocate a blank page
			if ((r = sys_page_alloc(child, (void*) (va + i), perm)) < 0)
  802261:	8b 95 94 fd ff ff    	mov    -0x26c(%ebp),%edx
  802267:	89 54 24 08          	mov    %edx,0x8(%esp)
  80226b:	03 bd 90 fd ff ff    	add    -0x270(%ebp),%edi
  802271:	89 7c 24 04          	mov    %edi,0x4(%esp)
  802275:	8b 85 8c fd ff ff    	mov    -0x274(%ebp),%eax
  80227b:	89 04 24             	mov    %eax,(%esp)
  80227e:	e8 18 ef ff ff       	call   80119b <sys_page_alloc>
  802283:	85 c0                	test   %eax,%eax
  802285:	0f 89 ea 00 00 00    	jns    802375 <spawn+0x465>
  80228b:	89 c3                	mov    %eax,%ebx
  80228d:	e9 47 02 00 00       	jmp    8024d9 <spawn+0x5c9>
				return r;
		} else {
			// from file
			if ((r = sys_page_alloc(0, UTEMP, PTE_P|PTE_U|PTE_W)) < 0)
  802292:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  802299:	00 
  80229a:	c7 44 24 04 00 00 40 	movl   $0x400000,0x4(%esp)
  8022a1:	00 
  8022a2:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8022a9:	e8 ed ee ff ff       	call   80119b <sys_page_alloc>
  8022ae:	85 c0                	test   %eax,%eax
  8022b0:	0f 88 19 02 00 00    	js     8024cf <spawn+0x5bf>
				return r;
			if ((r = seek(fd, fileoffset + i)) < 0)
  8022b6:	8b 95 78 fd ff ff    	mov    -0x288(%ebp),%edx
  8022bc:	8d 04 16             	lea    (%esi,%edx,1),%eax
  8022bf:	89 44 24 04          	mov    %eax,0x4(%esp)
  8022c3:	8b 85 84 fd ff ff    	mov    -0x27c(%ebp),%eax
  8022c9:	89 04 24             	mov    %eax,(%esp)
  8022cc:	e8 94 f4 ff ff       	call   801765 <seek>
  8022d1:	85 c0                	test   %eax,%eax
  8022d3:	0f 88 fa 01 00 00    	js     8024d3 <spawn+0x5c3>
				return r;
			if ((r = read(fd, UTEMP, MIN(PGSIZE, filesz-i))) < 0)
  8022d9:	89 d8                	mov    %ebx,%eax
  8022db:	29 f8                	sub    %edi,%eax
  8022dd:	3d 00 10 00 00       	cmp    $0x1000,%eax
  8022e2:	76 05                	jbe    8022e9 <spawn+0x3d9>
  8022e4:	b8 00 10 00 00       	mov    $0x1000,%eax
  8022e9:	89 44 24 08          	mov    %eax,0x8(%esp)
  8022ed:	c7 44 24 04 00 00 40 	movl   $0x400000,0x4(%esp)
  8022f4:	00 
  8022f5:	8b 95 84 fd ff ff    	mov    -0x27c(%ebp),%edx
  8022fb:	89 14 24             	mov    %edx,(%esp)
  8022fe:	e8 7b f6 ff ff       	call   80197e <read>
  802303:	85 c0                	test   %eax,%eax
  802305:	0f 88 cc 01 00 00    	js     8024d7 <spawn+0x5c7>
				return r;
			if ((r = sys_page_map(0, UTEMP, child, (void*) (va + i), perm)) < 0)
  80230b:	8b 85 94 fd ff ff    	mov    -0x26c(%ebp),%eax
  802311:	89 44 24 10          	mov    %eax,0x10(%esp)
  802315:	03 bd 90 fd ff ff    	add    -0x270(%ebp),%edi
  80231b:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  80231f:	8b 95 8c fd ff ff    	mov    -0x274(%ebp),%edx
  802325:	89 54 24 08          	mov    %edx,0x8(%esp)
  802329:	c7 44 24 04 00 00 40 	movl   $0x400000,0x4(%esp)
  802330:	00 
  802331:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802338:	e8 00 ee ff ff       	call   80113d <sys_page_map>
  80233d:	85 c0                	test   %eax,%eax
  80233f:	79 20                	jns    802361 <spawn+0x451>
				panic("spawn: sys_page_map data: %e", r);
  802341:	89 44 24 0c          	mov    %eax,0xc(%esp)
  802345:	c7 44 24 08 47 3b 80 	movl   $0x803b47,0x8(%esp)
  80234c:	00 
  80234d:	c7 44 24 04 0c 01 00 	movl   $0x10c,0x4(%esp)
  802354:	00 
  802355:	c7 04 24 3b 3b 80 00 	movl   $0x803b3b,(%esp)
  80235c:	e8 c3 de ff ff       	call   800224 <_panic>
			sys_page_unmap(0, UTEMP);
  802361:	c7 44 24 04 00 00 40 	movl   $0x400000,0x4(%esp)
  802368:	00 
  802369:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802370:	e8 6a ed ff ff       	call   8010df <sys_page_unmap>
		memsz += i;
		filesz += i;
		fileoffset -= i;
	}

	for (i = 0; i < memsz; i += PGSIZE) {
  802375:	81 c6 00 10 00 00    	add    $0x1000,%esi
  80237b:	89 f7                	mov    %esi,%edi
  80237d:	39 b5 88 fd ff ff    	cmp    %esi,-0x278(%ebp)
  802383:	0f 87 d4 fe ff ff    	ja     80225d <spawn+0x34d>
	if ((r = init_stack(child, argv, &child_tf.tf_esp)) < 0)
		return r;

	// Set up program segments as defined in ELF header.
	ph = (struct Proghdr*) (elf_buf + elf->e_phoff);
	for (i = 0; i < elf->e_phnum; i++, ph++) {
  802389:	83 85 7c fd ff ff 01 	addl   $0x1,-0x284(%ebp)
  802390:	0f b7 85 14 fe ff ff 	movzwl -0x1ec(%ebp),%eax
  802397:	3b 85 7c fd ff ff    	cmp    -0x284(%ebp),%eax
  80239d:	7e 0c                	jle    8023ab <spawn+0x49b>
  80239f:	83 85 80 fd ff ff 20 	addl   $0x20,-0x280(%ebp)
  8023a6:	e9 34 fe ff ff       	jmp    8021df <spawn+0x2cf>
			perm |= PTE_W;
		if ((r = map_segment(child, ph->p_va, ph->p_memsz, 
				     fd, ph->p_filesz, ph->p_offset, perm)) < 0)
			goto error;
	}
	close(fd);
  8023ab:	8b 85 84 fd ff ff    	mov    -0x27c(%ebp),%eax
  8023b1:	89 04 24             	mov    %eax,(%esp)
  8023b4:	e8 25 f7 ff ff       	call   801ade <close>
  8023b9:	c7 85 94 fd ff ff 00 	movl   $0x0,-0x26c(%ebp)
  8023c0:	00 00 00 
	void * va;
	int r;
	
	for (pde_x = VPD(0); pde_x < VPD(UTOP); pde_x++)
	{
		if ((vpd[pde_x] & PTE_P) == PTE_P)
  8023c3:	8b 95 94 fd ff ff    	mov    -0x26c(%ebp),%edx
  8023c9:	8b 04 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%eax
  8023d0:	a8 01                	test   $0x1,%al
  8023d2:	74 65                	je     802439 <spawn+0x529>
		{
			for (pte_x = 0; pte_x < NPTENTRIES; pte_x++)
			{
				vpn = (pde_x << (PDXSHIFT - PTXSHIFT)) + pte_x;
  8023d4:	89 d7                	mov    %edx,%edi
  8023d6:	c1 e7 0a             	shl    $0xa,%edi
  8023d9:	89 d6                	mov    %edx,%esi
  8023db:	c1 e6 16             	shl    $0x16,%esi
  8023de:	bb 00 00 00 00       	mov    $0x0,%ebx
  8023e3:	8d 04 3b             	lea    (%ebx,%edi,1),%eax
				pte = vpt[vpn];
  8023e6:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
				if ((pte & PTE_P) && (pte & PTE_SHARE))
  8023ed:	89 c2                	mov    %eax,%edx
  8023ef:	81 e2 01 04 00 00    	and    $0x401,%edx
  8023f5:	81 fa 01 04 00 00    	cmp    $0x401,%edx
  8023fb:	75 2b                	jne    802428 <spawn+0x518>
				{
					va = (void*)(vpn * PGSIZE);
					r = sys_page_map(0, va, child, va, pte & PTE_USER);
  8023fd:	25 07 0e 00 00       	and    $0xe07,%eax
  802402:	89 44 24 10          	mov    %eax,0x10(%esp)
  802406:	89 74 24 0c          	mov    %esi,0xc(%esp)
  80240a:	8b 85 8c fd ff ff    	mov    -0x274(%ebp),%eax
  802410:	89 44 24 08          	mov    %eax,0x8(%esp)
  802414:	89 74 24 04          	mov    %esi,0x4(%esp)
  802418:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80241f:	e8 19 ed ff ff       	call   80113d <sys_page_map>
					if (r < 0)
  802424:	85 c0                	test   %eax,%eax
  802426:	78 2d                	js     802455 <spawn+0x545>
	
	for (pde_x = VPD(0); pde_x < VPD(UTOP); pde_x++)
	{
		if ((vpd[pde_x] & PTE_P) == PTE_P)
		{
			for (pte_x = 0; pte_x < NPTENTRIES; pte_x++)
  802428:	83 c3 01             	add    $0x1,%ebx
  80242b:	81 c6 00 10 00 00    	add    $0x1000,%esi
  802431:	81 fb 00 04 00 00    	cmp    $0x400,%ebx
  802437:	75 aa                	jne    8023e3 <spawn+0x4d3>
	uint32_t pde_x, pte_x, vpn;
	pte_t pte;
	void * va;
	int r;
	
	for (pde_x = VPD(0); pde_x < VPD(UTOP); pde_x++)
  802439:	83 85 94 fd ff ff 01 	addl   $0x1,-0x26c(%ebp)
  802440:	81 bd 94 fd ff ff bb 	cmpl   $0x3bb,-0x26c(%ebp)
  802447:	03 00 00 
  80244a:	0f 85 73 ff ff ff    	jne    8023c3 <spawn+0x4b3>
  802450:	e9 b5 00 00 00       	jmp    80250a <spawn+0x5fa>
	close(fd);
	fd = -1;

	// Copy shared library state.
	if ((r = copy_shared_pages(child)) < 0)
		panic("copy_shared_pages: %e", r);
  802455:	89 44 24 0c          	mov    %eax,0xc(%esp)
  802459:	c7 44 24 08 64 3b 80 	movl   $0x803b64,0x8(%esp)
  802460:	00 
  802461:	c7 44 24 04 82 00 00 	movl   $0x82,0x4(%esp)
  802468:	00 
  802469:	c7 04 24 3b 3b 80 00 	movl   $0x803b3b,(%esp)
  802470:	e8 af dd ff ff       	call   800224 <_panic>

	if ((r = sys_env_set_trapframe(child, &child_tf)) < 0)
		panic("sys_env_set_trapframe: %e", r);
  802475:	89 44 24 0c          	mov    %eax,0xc(%esp)
  802479:	c7 44 24 08 7a 3b 80 	movl   $0x803b7a,0x8(%esp)
  802480:	00 
  802481:	c7 44 24 04 85 00 00 	movl   $0x85,0x4(%esp)
  802488:	00 
  802489:	c7 04 24 3b 3b 80 00 	movl   $0x803b3b,(%esp)
  802490:	e8 8f dd ff ff       	call   800224 <_panic>

	if ((r = sys_env_set_status(child, ENV_RUNNABLE)) < 0)
  802495:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  80249c:	00 
  80249d:	8b 95 8c fd ff ff    	mov    -0x274(%ebp),%edx
  8024a3:	89 14 24             	mov    %edx,(%esp)
  8024a6:	e8 d6 eb ff ff       	call   801081 <sys_env_set_status>
  8024ab:	85 c0                	test   %eax,%eax
  8024ad:	79 48                	jns    8024f7 <spawn+0x5e7>
		panic("sys_env_set_status: %e", r);
  8024af:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8024b3:	c7 44 24 08 94 3b 80 	movl   $0x803b94,0x8(%esp)
  8024ba:	00 
  8024bb:	c7 44 24 04 88 00 00 	movl   $0x88,0x4(%esp)
  8024c2:	00 
  8024c3:	c7 04 24 3b 3b 80 00 	movl   $0x803b3b,(%esp)
  8024ca:	e8 55 dd ff ff       	call   800224 <_panic>
  8024cf:	89 c3                	mov    %eax,%ebx
  8024d1:	eb 06                	jmp    8024d9 <spawn+0x5c9>
  8024d3:	89 c3                	mov    %eax,%ebx
  8024d5:	eb 02                	jmp    8024d9 <spawn+0x5c9>
  8024d7:	89 c3                	mov    %eax,%ebx

	return child;

error:
	sys_env_destroy(child);
  8024d9:	8b 85 8c fd ff ff    	mov    -0x274(%ebp),%eax
  8024df:	89 04 24             	mov    %eax,(%esp)
  8024e2:	e8 7b ed ff ff       	call   801262 <sys_env_destroy>
	close(fd);
  8024e7:	8b 95 84 fd ff ff    	mov    -0x27c(%ebp),%edx
  8024ed:	89 14 24             	mov    %edx,(%esp)
  8024f0:	e8 e9 f5 ff ff       	call   801ade <close>
	return r;
  8024f5:	eb 06                	jmp    8024fd <spawn+0x5ed>
  8024f7:	8b 9d 8c fd ff ff    	mov    -0x274(%ebp),%ebx
}
  8024fd:	89 d8                	mov    %ebx,%eax
  8024ff:	81 c4 9c 02 00 00    	add    $0x29c,%esp
  802505:	5b                   	pop    %ebx
  802506:	5e                   	pop    %esi
  802507:	5f                   	pop    %edi
  802508:	5d                   	pop    %ebp
  802509:	c3                   	ret    

	// Copy shared library state.
	if ((r = copy_shared_pages(child)) < 0)
		panic("copy_shared_pages: %e", r);

	if ((r = sys_env_set_trapframe(child, &child_tf)) < 0)
  80250a:	8d 85 a4 fd ff ff    	lea    -0x25c(%ebp),%eax
  802510:	89 44 24 04          	mov    %eax,0x4(%esp)
  802514:	8b 85 8c fd ff ff    	mov    -0x274(%ebp),%eax
  80251a:	89 04 24             	mov    %eax,(%esp)
  80251d:	e8 01 eb ff ff       	call   801023 <sys_env_set_trapframe>
  802522:	85 c0                	test   %eax,%eax
  802524:	0f 89 6b ff ff ff    	jns    802495 <spawn+0x585>
  80252a:	e9 46 ff ff ff       	jmp    802475 <spawn+0x565>

0080252f <spawnl>:
}

// Spawn, taking command-line arguments array directly on the stack.
int
spawnl(const char *prog, const char *arg0, ...)
{
  80252f:	55                   	push   %ebp
  802530:	89 e5                	mov    %esp,%ebp
  802532:	83 ec 18             	sub    $0x18,%esp
	return spawn(prog, &arg0);
  802535:	8d 45 0c             	lea    0xc(%ebp),%eax
  802538:	89 44 24 04          	mov    %eax,0x4(%esp)
  80253c:	8b 45 08             	mov    0x8(%ebp),%eax
  80253f:	89 04 24             	mov    %eax,(%esp)
  802542:	e8 c9 f9 ff ff       	call   801f10 <spawn>
}
  802547:	c9                   	leave  
  802548:	c3                   	ret    
  802549:	00 00                	add    %al,(%eax)
  80254b:	00 00                	add    %al,(%eax)
  80254d:	00 00                	add    %al,(%eax)
	...

00802550 <devsock_stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  802550:	55                   	push   %ebp
  802551:	89 e5                	mov    %esp,%ebp
  802553:	83 ec 18             	sub    $0x18,%esp
	strcpy(stat->st_name, "<sock>");
  802556:	c7 44 24 04 d2 3b 80 	movl   $0x803bd2,0x4(%esp)
  80255d:	00 
  80255e:	8b 45 0c             	mov    0xc(%ebp),%eax
  802561:	89 04 24             	mov    %eax,(%esp)
  802564:	e8 41 e4 ff ff       	call   8009aa <strcpy>
	return 0;
}
  802569:	b8 00 00 00 00       	mov    $0x0,%eax
  80256e:	c9                   	leave  
  80256f:	c3                   	ret    

00802570 <devsock_close>:
	return nsipc_shutdown(r, how);
}

static int
devsock_close(struct Fd *fd)
{
  802570:	55                   	push   %ebp
  802571:	89 e5                	mov    %esp,%ebp
  802573:	83 ec 18             	sub    $0x18,%esp
	return nsipc_close(fd->fd_sock.sockid);
  802576:	8b 45 08             	mov    0x8(%ebp),%eax
  802579:	8b 40 0c             	mov    0xc(%eax),%eax
  80257c:	89 04 24             	mov    %eax,(%esp)
  80257f:	e8 9e 02 00 00       	call   802822 <nsipc_close>
}
  802584:	c9                   	leave  
  802585:	c3                   	ret    

00802586 <devsock_write>:
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
}

static ssize_t
devsock_write(struct Fd *fd, const void *buf, size_t n)
{
  802586:	55                   	push   %ebp
  802587:	89 e5                	mov    %esp,%ebp
  802589:	83 ec 18             	sub    $0x18,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  80258c:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  802593:	00 
  802594:	8b 45 10             	mov    0x10(%ebp),%eax
  802597:	89 44 24 08          	mov    %eax,0x8(%esp)
  80259b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80259e:	89 44 24 04          	mov    %eax,0x4(%esp)
  8025a2:	8b 45 08             	mov    0x8(%ebp),%eax
  8025a5:	8b 40 0c             	mov    0xc(%eax),%eax
  8025a8:	89 04 24             	mov    %eax,(%esp)
  8025ab:	e8 ae 02 00 00       	call   80285e <nsipc_send>
}
  8025b0:	c9                   	leave  
  8025b1:	c3                   	ret    

008025b2 <devsock_read>:
	return nsipc_listen(r, backlog);
}

static ssize_t
devsock_read(struct Fd *fd, void *buf, size_t n)
{
  8025b2:	55                   	push   %ebp
  8025b3:	89 e5                	mov    %esp,%ebp
  8025b5:	83 ec 18             	sub    $0x18,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  8025b8:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  8025bf:	00 
  8025c0:	8b 45 10             	mov    0x10(%ebp),%eax
  8025c3:	89 44 24 08          	mov    %eax,0x8(%esp)
  8025c7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8025ca:	89 44 24 04          	mov    %eax,0x4(%esp)
  8025ce:	8b 45 08             	mov    0x8(%ebp),%eax
  8025d1:	8b 40 0c             	mov    0xc(%eax),%eax
  8025d4:	89 04 24             	mov    %eax,(%esp)
  8025d7:	e8 f5 02 00 00       	call   8028d1 <nsipc_recv>
}
  8025dc:	c9                   	leave  
  8025dd:	c3                   	ret    

008025de <alloc_sockfd>:
	return sfd->fd_sock.sockid;
}

static int
alloc_sockfd(int sockid)
{
  8025de:	55                   	push   %ebp
  8025df:	89 e5                	mov    %esp,%ebp
  8025e1:	56                   	push   %esi
  8025e2:	53                   	push   %ebx
  8025e3:	83 ec 20             	sub    $0x20,%esp
  8025e6:	89 c6                	mov    %eax,%esi
	struct Fd *sfd;
	int r;

	if ((r = fd_alloc(&sfd)) < 0
  8025e8:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8025eb:	89 04 24             	mov    %eax,(%esp)
  8025ee:	e8 b8 f0 ff ff       	call   8016ab <fd_alloc>
  8025f3:	89 c3                	mov    %eax,%ebx
  8025f5:	85 c0                	test   %eax,%eax
  8025f7:	78 21                	js     80261a <alloc_sockfd+0x3c>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U)) < 0) {
  8025f9:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  802600:	00 
  802601:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802604:	89 44 24 04          	mov    %eax,0x4(%esp)
  802608:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80260f:	e8 87 eb ff ff       	call   80119b <sys_page_alloc>
  802614:	89 c3                	mov    %eax,%ebx
alloc_sockfd(int sockid)
{
	struct Fd *sfd;
	int r;

	if ((r = fd_alloc(&sfd)) < 0
  802616:	85 c0                	test   %eax,%eax
  802618:	79 0a                	jns    802624 <alloc_sockfd+0x46>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U)) < 0) {
		nsipc_close(sockid);
  80261a:	89 34 24             	mov    %esi,(%esp)
  80261d:	e8 00 02 00 00       	call   802822 <nsipc_close>
		return r;
  802622:	eb 28                	jmp    80264c <alloc_sockfd+0x6e>
	}

	sfd->fd_dev_id = devsock.dev_id;
  802624:	8b 15 28 70 80 00    	mov    0x807028,%edx
  80262a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80262d:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  80262f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802632:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	sfd->fd_sock.sockid = sockid;
  802639:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80263c:	89 70 0c             	mov    %esi,0xc(%eax)
	return fd2num(sfd);
  80263f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802642:	89 04 24             	mov    %eax,(%esp)
  802645:	e8 36 f0 ff ff       	call   801680 <fd2num>
  80264a:	89 c3                	mov    %eax,%ebx
}
  80264c:	89 d8                	mov    %ebx,%eax
  80264e:	83 c4 20             	add    $0x20,%esp
  802651:	5b                   	pop    %ebx
  802652:	5e                   	pop    %esi
  802653:	5d                   	pop    %ebp
  802654:	c3                   	ret    

00802655 <socket>:
	return 0;
}

int
socket(int domain, int type, int protocol)
{
  802655:	55                   	push   %ebp
  802656:	89 e5                	mov    %esp,%ebp
  802658:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  80265b:	8b 45 10             	mov    0x10(%ebp),%eax
  80265e:	89 44 24 08          	mov    %eax,0x8(%esp)
  802662:	8b 45 0c             	mov    0xc(%ebp),%eax
  802665:	89 44 24 04          	mov    %eax,0x4(%esp)
  802669:	8b 45 08             	mov    0x8(%ebp),%eax
  80266c:	89 04 24             	mov    %eax,(%esp)
  80266f:	e8 62 01 00 00       	call   8027d6 <nsipc_socket>
  802674:	85 c0                	test   %eax,%eax
  802676:	78 05                	js     80267d <socket+0x28>
		return r;
	return alloc_sockfd(r);
  802678:	e8 61 ff ff ff       	call   8025de <alloc_sockfd>
}
  80267d:	c9                   	leave  
  80267e:	66 90                	xchg   %ax,%ax
  802680:	c3                   	ret    

00802681 <fd2sockid>:
	.dev_stat =	devsock_stat,
};

static int
fd2sockid(int fd)
{
  802681:	55                   	push   %ebp
  802682:	89 e5                	mov    %esp,%ebp
  802684:	83 ec 28             	sub    $0x28,%esp
	struct Fd *sfd;
	int r;

	if ((r = fd_lookup(fd, &sfd)) < 0)
  802687:	8d 55 f4             	lea    -0xc(%ebp),%edx
  80268a:	89 54 24 04          	mov    %edx,0x4(%esp)
  80268e:	89 04 24             	mov    %eax,(%esp)
  802691:	e8 87 f0 ff ff       	call   80171d <fd_lookup>
  802696:	85 c0                	test   %eax,%eax
  802698:	78 15                	js     8026af <fd2sockid+0x2e>
		return r;
	if (sfd->fd_dev_id != devsock.dev_id)
  80269a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80269d:	8b 0a                	mov    (%edx),%ecx
  80269f:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8026a4:	3b 0d 28 70 80 00    	cmp    0x807028,%ecx
  8026aa:	75 03                	jne    8026af <fd2sockid+0x2e>
		return -E_NOT_SUPP;
	return sfd->fd_sock.sockid;
  8026ac:	8b 42 0c             	mov    0xc(%edx),%eax
}
  8026af:	c9                   	leave  
  8026b0:	c3                   	ret    

008026b1 <listen>:
	return nsipc_connect(r, name, namelen);
}

int
listen(int s, int backlog)
{
  8026b1:	55                   	push   %ebp
  8026b2:	89 e5                	mov    %esp,%ebp
  8026b4:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  8026b7:	8b 45 08             	mov    0x8(%ebp),%eax
  8026ba:	e8 c2 ff ff ff       	call   802681 <fd2sockid>
  8026bf:	85 c0                	test   %eax,%eax
  8026c1:	78 0f                	js     8026d2 <listen+0x21>
		return r;
	return nsipc_listen(r, backlog);
  8026c3:	8b 55 0c             	mov    0xc(%ebp),%edx
  8026c6:	89 54 24 04          	mov    %edx,0x4(%esp)
  8026ca:	89 04 24             	mov    %eax,(%esp)
  8026cd:	e8 2e 01 00 00       	call   802800 <nsipc_listen>
}
  8026d2:	c9                   	leave  
  8026d3:	c3                   	ret    

008026d4 <connect>:
	return nsipc_close(fd->fd_sock.sockid);
}

int
connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  8026d4:	55                   	push   %ebp
  8026d5:	89 e5                	mov    %esp,%ebp
  8026d7:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  8026da:	8b 45 08             	mov    0x8(%ebp),%eax
  8026dd:	e8 9f ff ff ff       	call   802681 <fd2sockid>
  8026e2:	85 c0                	test   %eax,%eax
  8026e4:	78 16                	js     8026fc <connect+0x28>
		return r;
	return nsipc_connect(r, name, namelen);
  8026e6:	8b 55 10             	mov    0x10(%ebp),%edx
  8026e9:	89 54 24 08          	mov    %edx,0x8(%esp)
  8026ed:	8b 55 0c             	mov    0xc(%ebp),%edx
  8026f0:	89 54 24 04          	mov    %edx,0x4(%esp)
  8026f4:	89 04 24             	mov    %eax,(%esp)
  8026f7:	e8 55 02 00 00       	call   802951 <nsipc_connect>
}
  8026fc:	c9                   	leave  
  8026fd:	c3                   	ret    

008026fe <shutdown>:
	return nsipc_bind(r, name, namelen);
}

int
shutdown(int s, int how)
{
  8026fe:	55                   	push   %ebp
  8026ff:	89 e5                	mov    %esp,%ebp
  802701:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  802704:	8b 45 08             	mov    0x8(%ebp),%eax
  802707:	e8 75 ff ff ff       	call   802681 <fd2sockid>
  80270c:	85 c0                	test   %eax,%eax
  80270e:	78 0f                	js     80271f <shutdown+0x21>
		return r;
	return nsipc_shutdown(r, how);
  802710:	8b 55 0c             	mov    0xc(%ebp),%edx
  802713:	89 54 24 04          	mov    %edx,0x4(%esp)
  802717:	89 04 24             	mov    %eax,(%esp)
  80271a:	e8 1d 01 00 00       	call   80283c <nsipc_shutdown>
}
  80271f:	c9                   	leave  
  802720:	c3                   	ret    

00802721 <bind>:
	return alloc_sockfd(r);
}

int
bind(int s, struct sockaddr *name, socklen_t namelen)
{
  802721:	55                   	push   %ebp
  802722:	89 e5                	mov    %esp,%ebp
  802724:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  802727:	8b 45 08             	mov    0x8(%ebp),%eax
  80272a:	e8 52 ff ff ff       	call   802681 <fd2sockid>
  80272f:	85 c0                	test   %eax,%eax
  802731:	78 16                	js     802749 <bind+0x28>
		return r;
	return nsipc_bind(r, name, namelen);
  802733:	8b 55 10             	mov    0x10(%ebp),%edx
  802736:	89 54 24 08          	mov    %edx,0x8(%esp)
  80273a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80273d:	89 54 24 04          	mov    %edx,0x4(%esp)
  802741:	89 04 24             	mov    %eax,(%esp)
  802744:	e8 47 02 00 00       	call   802990 <nsipc_bind>
}
  802749:	c9                   	leave  
  80274a:	c3                   	ret    

0080274b <accept>:
	return fd2num(sfd);
}

int
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  80274b:	55                   	push   %ebp
  80274c:	89 e5                	mov    %esp,%ebp
  80274e:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  802751:	8b 45 08             	mov    0x8(%ebp),%eax
  802754:	e8 28 ff ff ff       	call   802681 <fd2sockid>
  802759:	85 c0                	test   %eax,%eax
  80275b:	78 1f                	js     80277c <accept+0x31>
		return r;
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  80275d:	8b 55 10             	mov    0x10(%ebp),%edx
  802760:	89 54 24 08          	mov    %edx,0x8(%esp)
  802764:	8b 55 0c             	mov    0xc(%ebp),%edx
  802767:	89 54 24 04          	mov    %edx,0x4(%esp)
  80276b:	89 04 24             	mov    %eax,(%esp)
  80276e:	e8 5c 02 00 00       	call   8029cf <nsipc_accept>
  802773:	85 c0                	test   %eax,%eax
  802775:	78 05                	js     80277c <accept+0x31>
		return r;
	return alloc_sockfd(r);
  802777:	e8 62 fe ff ff       	call   8025de <alloc_sockfd>
}
  80277c:	c9                   	leave  
  80277d:	8d 76 00             	lea    0x0(%esi),%esi
  802780:	c3                   	ret    
	...

00802790 <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  802790:	55                   	push   %ebp
  802791:	89 e5                	mov    %esp,%ebp
  802793:	83 ec 18             	sub    $0x18,%esp
	if (debug)
		cprintf("[%08x] nsipc %d\n", env->env_id, type);

	ipc_send(envs[2].env_id, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  802796:	8b 15 44 01 c0 ee    	mov    0xeec00144,%edx
  80279c:	c7 44 24 0c 07 00 00 	movl   $0x7,0xc(%esp)
  8027a3:	00 
  8027a4:	c7 44 24 08 00 60 80 	movl   $0x806000,0x8(%esp)
  8027ab:	00 
  8027ac:	89 44 24 04          	mov    %eax,0x4(%esp)
  8027b0:	89 14 24             	mov    %edx,(%esp)
  8027b3:	e8 28 09 00 00       	call   8030e0 <ipc_send>
	return ipc_recv(NULL, NULL, NULL);
  8027b8:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  8027bf:	00 
  8027c0:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  8027c7:	00 
  8027c8:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8027cf:	e8 72 09 00 00       	call   803146 <ipc_recv>
}
  8027d4:	c9                   	leave  
  8027d5:	c3                   	ret    

008027d6 <nsipc_socket>:
	return nsipc(NSREQ_SEND);
}

int
nsipc_socket(int domain, int type, int protocol)
{
  8027d6:	55                   	push   %ebp
  8027d7:	89 e5                	mov    %esp,%ebp
  8027d9:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  8027dc:	8b 45 08             	mov    0x8(%ebp),%eax
  8027df:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.socket.req_type = type;
  8027e4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8027e7:	a3 04 60 80 00       	mov    %eax,0x806004
	nsipcbuf.socket.req_protocol = protocol;
  8027ec:	8b 45 10             	mov    0x10(%ebp),%eax
  8027ef:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SOCKET);
  8027f4:	b8 09 00 00 00       	mov    $0x9,%eax
  8027f9:	e8 92 ff ff ff       	call   802790 <nsipc>
}
  8027fe:	c9                   	leave  
  8027ff:	c3                   	ret    

00802800 <nsipc_listen>:
	return nsipc(NSREQ_CONNECT);
}

int
nsipc_listen(int s, int backlog)
{
  802800:	55                   	push   %ebp
  802801:	89 e5                	mov    %esp,%ebp
  802803:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  802806:	8b 45 08             	mov    0x8(%ebp),%eax
  802809:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.listen.req_backlog = backlog;
  80280e:	8b 45 0c             	mov    0xc(%ebp),%eax
  802811:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_LISTEN);
  802816:	b8 06 00 00 00       	mov    $0x6,%eax
  80281b:	e8 70 ff ff ff       	call   802790 <nsipc>
}
  802820:	c9                   	leave  
  802821:	c3                   	ret    

00802822 <nsipc_close>:
	return nsipc(NSREQ_SHUTDOWN);
}

int
nsipc_close(int s)
{
  802822:	55                   	push   %ebp
  802823:	89 e5                	mov    %esp,%ebp
  802825:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  802828:	8b 45 08             	mov    0x8(%ebp),%eax
  80282b:	a3 00 60 80 00       	mov    %eax,0x806000
	return nsipc(NSREQ_CLOSE);
  802830:	b8 04 00 00 00       	mov    $0x4,%eax
  802835:	e8 56 ff ff ff       	call   802790 <nsipc>
}
  80283a:	c9                   	leave  
  80283b:	c3                   	ret    

0080283c <nsipc_shutdown>:
	return nsipc(NSREQ_BIND);
}

int
nsipc_shutdown(int s, int how)
{
  80283c:	55                   	push   %ebp
  80283d:	89 e5                	mov    %esp,%ebp
  80283f:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  802842:	8b 45 08             	mov    0x8(%ebp),%eax
  802845:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.shutdown.req_how = how;
  80284a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80284d:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_SHUTDOWN);
  802852:	b8 03 00 00 00       	mov    $0x3,%eax
  802857:	e8 34 ff ff ff       	call   802790 <nsipc>
}
  80285c:	c9                   	leave  
  80285d:	c3                   	ret    

0080285e <nsipc_send>:
	return r;
}

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  80285e:	55                   	push   %ebp
  80285f:	89 e5                	mov    %esp,%ebp
  802861:	53                   	push   %ebx
  802862:	83 ec 14             	sub    $0x14,%esp
  802865:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  802868:	8b 45 08             	mov    0x8(%ebp),%eax
  80286b:	a3 00 60 80 00       	mov    %eax,0x806000
	assert(size < 1600);
  802870:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  802876:	7e 24                	jle    80289c <nsipc_send+0x3e>
  802878:	c7 44 24 0c de 3b 80 	movl   $0x803bde,0xc(%esp)
  80287f:	00 
  802880:	c7 44 24 08 26 3b 80 	movl   $0x803b26,0x8(%esp)
  802887:	00 
  802888:	c7 44 24 04 66 00 00 	movl   $0x66,0x4(%esp)
  80288f:	00 
  802890:	c7 04 24 ea 3b 80 00 	movl   $0x803bea,(%esp)
  802897:	e8 88 d9 ff ff       	call   800224 <_panic>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  80289c:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8028a0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8028a3:	89 44 24 04          	mov    %eax,0x4(%esp)
  8028a7:	c7 04 24 0c 60 80 00 	movl   $0x80600c,(%esp)
  8028ae:	e8 b2 e2 ff ff       	call   800b65 <memmove>
	nsipcbuf.send.req_size = size;
  8028b3:	89 1d 04 60 80 00    	mov    %ebx,0x806004
	nsipcbuf.send.req_flags = flags;
  8028b9:	8b 45 14             	mov    0x14(%ebp),%eax
  8028bc:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SEND);
  8028c1:	b8 08 00 00 00       	mov    $0x8,%eax
  8028c6:	e8 c5 fe ff ff       	call   802790 <nsipc>
}
  8028cb:	83 c4 14             	add    $0x14,%esp
  8028ce:	5b                   	pop    %ebx
  8028cf:	5d                   	pop    %ebp
  8028d0:	c3                   	ret    

008028d1 <nsipc_recv>:
	return nsipc(NSREQ_LISTEN);
}

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  8028d1:	55                   	push   %ebp
  8028d2:	89 e5                	mov    %esp,%ebp
  8028d4:	56                   	push   %esi
  8028d5:	53                   	push   %ebx
  8028d6:	83 ec 10             	sub    $0x10,%esp
  8028d9:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  8028dc:	8b 45 08             	mov    0x8(%ebp),%eax
  8028df:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.recv.req_len = len;
  8028e4:	89 35 04 60 80 00    	mov    %esi,0x806004
	nsipcbuf.recv.req_flags = flags;
  8028ea:	8b 45 14             	mov    0x14(%ebp),%eax
  8028ed:	a3 08 60 80 00       	mov    %eax,0x806008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  8028f2:	b8 07 00 00 00       	mov    $0x7,%eax
  8028f7:	e8 94 fe ff ff       	call   802790 <nsipc>
  8028fc:	89 c3                	mov    %eax,%ebx
  8028fe:	85 c0                	test   %eax,%eax
  802900:	78 46                	js     802948 <nsipc_recv+0x77>
		assert(r < 1600 && r <= len);
  802902:	3d 3f 06 00 00       	cmp    $0x63f,%eax
  802907:	7f 04                	jg     80290d <nsipc_recv+0x3c>
  802909:	39 c6                	cmp    %eax,%esi
  80290b:	7d 24                	jge    802931 <nsipc_recv+0x60>
  80290d:	c7 44 24 0c f6 3b 80 	movl   $0x803bf6,0xc(%esp)
  802914:	00 
  802915:	c7 44 24 08 26 3b 80 	movl   $0x803b26,0x8(%esp)
  80291c:	00 
  80291d:	c7 44 24 04 5b 00 00 	movl   $0x5b,0x4(%esp)
  802924:	00 
  802925:	c7 04 24 ea 3b 80 00 	movl   $0x803bea,(%esp)
  80292c:	e8 f3 d8 ff ff       	call   800224 <_panic>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  802931:	89 44 24 08          	mov    %eax,0x8(%esp)
  802935:	c7 44 24 04 00 60 80 	movl   $0x806000,0x4(%esp)
  80293c:	00 
  80293d:	8b 45 0c             	mov    0xc(%ebp),%eax
  802940:	89 04 24             	mov    %eax,(%esp)
  802943:	e8 1d e2 ff ff       	call   800b65 <memmove>
	}

	return r;
}
  802948:	89 d8                	mov    %ebx,%eax
  80294a:	83 c4 10             	add    $0x10,%esp
  80294d:	5b                   	pop    %ebx
  80294e:	5e                   	pop    %esi
  80294f:	5d                   	pop    %ebp
  802950:	c3                   	ret    

00802951 <nsipc_connect>:
	return nsipc(NSREQ_CLOSE);
}

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  802951:	55                   	push   %ebp
  802952:	89 e5                	mov    %esp,%ebp
  802954:	53                   	push   %ebx
  802955:	83 ec 14             	sub    $0x14,%esp
  802958:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  80295b:	8b 45 08             	mov    0x8(%ebp),%eax
  80295e:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  802963:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  802967:	8b 45 0c             	mov    0xc(%ebp),%eax
  80296a:	89 44 24 04          	mov    %eax,0x4(%esp)
  80296e:	c7 04 24 04 60 80 00 	movl   $0x806004,(%esp)
  802975:	e8 eb e1 ff ff       	call   800b65 <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  80297a:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_CONNECT);
  802980:	b8 05 00 00 00       	mov    $0x5,%eax
  802985:	e8 06 fe ff ff       	call   802790 <nsipc>
}
  80298a:	83 c4 14             	add    $0x14,%esp
  80298d:	5b                   	pop    %ebx
  80298e:	5d                   	pop    %ebp
  80298f:	c3                   	ret    

00802990 <nsipc_bind>:
	return r;
}

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  802990:	55                   	push   %ebp
  802991:	89 e5                	mov    %esp,%ebp
  802993:	53                   	push   %ebx
  802994:	83 ec 14             	sub    $0x14,%esp
  802997:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  80299a:	8b 45 08             	mov    0x8(%ebp),%eax
  80299d:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  8029a2:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8029a6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8029a9:	89 44 24 04          	mov    %eax,0x4(%esp)
  8029ad:	c7 04 24 04 60 80 00 	movl   $0x806004,(%esp)
  8029b4:	e8 ac e1 ff ff       	call   800b65 <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  8029b9:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_BIND);
  8029bf:	b8 02 00 00 00       	mov    $0x2,%eax
  8029c4:	e8 c7 fd ff ff       	call   802790 <nsipc>
}
  8029c9:	83 c4 14             	add    $0x14,%esp
  8029cc:	5b                   	pop    %ebx
  8029cd:	5d                   	pop    %ebp
  8029ce:	c3                   	ret    

008029cf <nsipc_accept>:
	return ipc_recv(NULL, NULL, NULL);
}

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  8029cf:	55                   	push   %ebp
  8029d0:	89 e5                	mov    %esp,%ebp
  8029d2:	83 ec 18             	sub    $0x18,%esp
  8029d5:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  8029d8:	89 75 fc             	mov    %esi,-0x4(%ebp)
	int r;
	
	nsipcbuf.accept.req_s = s;
  8029db:	8b 45 08             	mov    0x8(%ebp),%eax
  8029de:	a3 00 60 80 00       	mov    %eax,0x806000
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  8029e3:	b8 01 00 00 00       	mov    $0x1,%eax
  8029e8:	e8 a3 fd ff ff       	call   802790 <nsipc>
  8029ed:	89 c3                	mov    %eax,%ebx
  8029ef:	85 c0                	test   %eax,%eax
  8029f1:	78 25                	js     802a18 <nsipc_accept+0x49>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  8029f3:	be 10 60 80 00       	mov    $0x806010,%esi
  8029f8:	8b 06                	mov    (%esi),%eax
  8029fa:	89 44 24 08          	mov    %eax,0x8(%esp)
  8029fe:	c7 44 24 04 00 60 80 	movl   $0x806000,0x4(%esp)
  802a05:	00 
  802a06:	8b 45 0c             	mov    0xc(%ebp),%eax
  802a09:	89 04 24             	mov    %eax,(%esp)
  802a0c:	e8 54 e1 ff ff       	call   800b65 <memmove>
		*addrlen = ret->ret_addrlen;
  802a11:	8b 16                	mov    (%esi),%edx
  802a13:	8b 45 10             	mov    0x10(%ebp),%eax
  802a16:	89 10                	mov    %edx,(%eax)
	}
	return r;
}
  802a18:	89 d8                	mov    %ebx,%eax
  802a1a:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  802a1d:	8b 75 fc             	mov    -0x4(%ebp),%esi
  802a20:	89 ec                	mov    %ebp,%esp
  802a22:	5d                   	pop    %ebp
  802a23:	c3                   	ret    
	...

00802a30 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  802a30:	55                   	push   %ebp
  802a31:	89 e5                	mov    %esp,%ebp
  802a33:	83 ec 18             	sub    $0x18,%esp
  802a36:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  802a39:	89 75 fc             	mov    %esi,-0x4(%ebp)
  802a3c:	8b 75 0c             	mov    0xc(%ebp),%esi
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  802a3f:	8b 45 08             	mov    0x8(%ebp),%eax
  802a42:	89 04 24             	mov    %eax,(%esp)
  802a45:	e8 46 ec ff ff       	call   801690 <fd2data>
  802a4a:	89 c3                	mov    %eax,%ebx
	strcpy(stat->st_name, "<pipe>");
  802a4c:	c7 44 24 04 0b 3c 80 	movl   $0x803c0b,0x4(%esp)
  802a53:	00 
  802a54:	89 34 24             	mov    %esi,(%esp)
  802a57:	e8 4e df ff ff       	call   8009aa <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  802a5c:	8b 43 04             	mov    0x4(%ebx),%eax
  802a5f:	2b 03                	sub    (%ebx),%eax
  802a61:	89 86 80 00 00 00    	mov    %eax,0x80(%esi)
	stat->st_isdir = 0;
  802a67:	c7 86 84 00 00 00 00 	movl   $0x0,0x84(%esi)
  802a6e:	00 00 00 
	stat->st_dev = &devpipe;
  802a71:	c7 86 88 00 00 00 44 	movl   $0x807044,0x88(%esi)
  802a78:	70 80 00 
	return 0;
}
  802a7b:	b8 00 00 00 00       	mov    $0x0,%eax
  802a80:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  802a83:	8b 75 fc             	mov    -0x4(%ebp),%esi
  802a86:	89 ec                	mov    %ebp,%esp
  802a88:	5d                   	pop    %ebp
  802a89:	c3                   	ret    

00802a8a <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  802a8a:	55                   	push   %ebp
  802a8b:	89 e5                	mov    %esp,%ebp
  802a8d:	53                   	push   %ebx
  802a8e:	83 ec 14             	sub    $0x14,%esp
  802a91:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  802a94:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  802a98:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802a9f:	e8 3b e6 ff ff       	call   8010df <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  802aa4:	89 1c 24             	mov    %ebx,(%esp)
  802aa7:	e8 e4 eb ff ff       	call   801690 <fd2data>
  802aac:	89 44 24 04          	mov    %eax,0x4(%esp)
  802ab0:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802ab7:	e8 23 e6 ff ff       	call   8010df <sys_page_unmap>
}
  802abc:	83 c4 14             	add    $0x14,%esp
  802abf:	5b                   	pop    %ebx
  802ac0:	5d                   	pop    %ebp
  802ac1:	c3                   	ret    

00802ac2 <_pipeisclosed>:
	return r;
}

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  802ac2:	55                   	push   %ebp
  802ac3:	89 e5                	mov    %esp,%ebp
  802ac5:	57                   	push   %edi
  802ac6:	56                   	push   %esi
  802ac7:	53                   	push   %ebx
  802ac8:	83 ec 2c             	sub    $0x2c,%esp
  802acb:	89 c7                	mov    %eax,%edi
  802acd:	89 55 e4             	mov    %edx,-0x1c(%ebp)
	int n, nn, ret;

	while (1) {
		n = env->env_runs;
  802ad0:	a1 7c 70 80 00       	mov    0x80707c,%eax
  802ad5:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  802ad8:	89 3c 24             	mov    %edi,(%esp)
  802adb:	e8 d0 06 00 00       	call   8031b0 <pageref>
  802ae0:	89 c6                	mov    %eax,%esi
  802ae2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802ae5:	89 04 24             	mov    %eax,(%esp)
  802ae8:	e8 c3 06 00 00       	call   8031b0 <pageref>
  802aed:	39 c6                	cmp    %eax,%esi
  802aef:	0f 94 c0             	sete   %al
  802af2:	0f b6 c0             	movzbl %al,%eax
		nn = env->env_runs;
  802af5:	8b 15 7c 70 80 00    	mov    0x80707c,%edx
  802afb:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  802afe:	39 cb                	cmp    %ecx,%ebx
  802b00:	75 08                	jne    802b0a <_pipeisclosed+0x48>
			return ret;
		if (n != nn && ret == 1)
			cprintf("pipe race avoided\n", n, env->env_runs, ret);
	}
}
  802b02:	83 c4 2c             	add    $0x2c,%esp
  802b05:	5b                   	pop    %ebx
  802b06:	5e                   	pop    %esi
  802b07:	5f                   	pop    %edi
  802b08:	5d                   	pop    %ebp
  802b09:	c3                   	ret    
		n = env->env_runs;
		ret = pageref(fd) == pageref(p);
		nn = env->env_runs;
		if (n == nn)
			return ret;
		if (n != nn && ret == 1)
  802b0a:	83 f8 01             	cmp    $0x1,%eax
  802b0d:	75 c1                	jne    802ad0 <_pipeisclosed+0xe>
			cprintf("pipe race avoided\n", n, env->env_runs, ret);
  802b0f:	8b 52 58             	mov    0x58(%edx),%edx
  802b12:	89 44 24 0c          	mov    %eax,0xc(%esp)
  802b16:	89 54 24 08          	mov    %edx,0x8(%esp)
  802b1a:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  802b1e:	c7 04 24 12 3c 80 00 	movl   $0x803c12,(%esp)
  802b25:	e8 bf d7 ff ff       	call   8002e9 <cprintf>
  802b2a:	eb a4                	jmp    802ad0 <_pipeisclosed+0xe>

00802b2c <devpipe_write>:
	return i;
}

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  802b2c:	55                   	push   %ebp
  802b2d:	89 e5                	mov    %esp,%ebp
  802b2f:	57                   	push   %edi
  802b30:	56                   	push   %esi
  802b31:	53                   	push   %ebx
  802b32:	83 ec 1c             	sub    $0x1c,%esp
  802b35:	8b 75 08             	mov    0x8(%ebp),%esi
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  802b38:	89 34 24             	mov    %esi,(%esp)
  802b3b:	e8 50 eb ff ff       	call   801690 <fd2data>
  802b40:	89 c3                	mov    %eax,%ebx
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			env->env_id, vpt[VPN(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  802b42:	bf 00 00 00 00       	mov    $0x0,%edi
  802b47:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  802b4b:	75 54                	jne    802ba1 <devpipe_write+0x75>
  802b4d:	eb 60                	jmp    802baf <devpipe_write+0x83>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  802b4f:	89 da                	mov    %ebx,%edx
  802b51:	89 f0                	mov    %esi,%eax
  802b53:	e8 6a ff ff ff       	call   802ac2 <_pipeisclosed>
  802b58:	85 c0                	test   %eax,%eax
  802b5a:	74 07                	je     802b63 <devpipe_write+0x37>
  802b5c:	b8 00 00 00 00       	mov    $0x0,%eax
  802b61:	eb 53                	jmp    802bb6 <devpipe_write+0x8a>
				return 0;
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  802b63:	90                   	nop
  802b64:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802b68:	e8 8d e6 ff ff       	call   8011fa <sys_yield>
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			env->env_id, vpt[VPN(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  802b6d:	8b 43 04             	mov    0x4(%ebx),%eax
  802b70:	8b 13                	mov    (%ebx),%edx
  802b72:	83 c2 20             	add    $0x20,%edx
  802b75:	39 d0                	cmp    %edx,%eax
  802b77:	73 d6                	jae    802b4f <devpipe_write+0x23>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  802b79:	89 c2                	mov    %eax,%edx
  802b7b:	c1 fa 1f             	sar    $0x1f,%edx
  802b7e:	c1 ea 1b             	shr    $0x1b,%edx
  802b81:	01 d0                	add    %edx,%eax
  802b83:	83 e0 1f             	and    $0x1f,%eax
  802b86:	29 d0                	sub    %edx,%eax
  802b88:	89 c2                	mov    %eax,%edx
  802b8a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  802b8d:	0f b6 04 39          	movzbl (%ecx,%edi,1),%eax
  802b91:	88 44 13 08          	mov    %al,0x8(%ebx,%edx,1)
		p->p_wpos++;
  802b95:	83 43 04 01          	addl   $0x1,0x4(%ebx)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			env->env_id, vpt[VPN(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  802b99:	83 c7 01             	add    $0x1,%edi
  802b9c:	39 7d 10             	cmp    %edi,0x10(%ebp)
  802b9f:	76 13                	jbe    802bb4 <devpipe_write+0x88>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  802ba1:	8b 43 04             	mov    0x4(%ebx),%eax
  802ba4:	8b 13                	mov    (%ebx),%edx
  802ba6:	83 c2 20             	add    $0x20,%edx
  802ba9:	39 d0                	cmp    %edx,%eax
  802bab:	73 a2                	jae    802b4f <devpipe_write+0x23>
  802bad:	eb ca                	jmp    802b79 <devpipe_write+0x4d>
  802baf:	bf 00 00 00 00       	mov    $0x0,%edi
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}
	
	return i;
  802bb4:	89 f8                	mov    %edi,%eax
}
  802bb6:	83 c4 1c             	add    $0x1c,%esp
  802bb9:	5b                   	pop    %ebx
  802bba:	5e                   	pop    %esi
  802bbb:	5f                   	pop    %edi
  802bbc:	5d                   	pop    %ebp
  802bbd:	c3                   	ret    

00802bbe <devpipe_read>:
	return _pipeisclosed(fd, p);
}

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  802bbe:	55                   	push   %ebp
  802bbf:	89 e5                	mov    %esp,%ebp
  802bc1:	83 ec 28             	sub    $0x28,%esp
  802bc4:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  802bc7:	89 75 f8             	mov    %esi,-0x8(%ebp)
  802bca:	89 7d fc             	mov    %edi,-0x4(%ebp)
  802bcd:	8b 7d 08             	mov    0x8(%ebp),%edi
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  802bd0:	89 3c 24             	mov    %edi,(%esp)
  802bd3:	e8 b8 ea ff ff       	call   801690 <fd2data>
  802bd8:	89 c3                	mov    %eax,%ebx
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			env->env_id, vpt[VPN(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  802bda:	be 00 00 00 00       	mov    $0x0,%esi
  802bdf:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  802be3:	75 4c                	jne    802c31 <devpipe_read+0x73>
  802be5:	eb 5b                	jmp    802c42 <devpipe_read+0x84>
		while (p->p_rpos == p->p_wpos) {
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
				return i;
  802be7:	89 f0                	mov    %esi,%eax
  802be9:	eb 5e                	jmp    802c49 <devpipe_read+0x8b>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  802beb:	89 da                	mov    %ebx,%edx
  802bed:	89 f8                	mov    %edi,%eax
  802bef:	90                   	nop
  802bf0:	e8 cd fe ff ff       	call   802ac2 <_pipeisclosed>
  802bf5:	85 c0                	test   %eax,%eax
  802bf7:	74 07                	je     802c00 <devpipe_read+0x42>
  802bf9:	b8 00 00 00 00       	mov    $0x0,%eax
  802bfe:	eb 49                	jmp    802c49 <devpipe_read+0x8b>
				return 0;
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  802c00:	e8 f5 e5 ff ff       	call   8011fa <sys_yield>
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			env->env_id, vpt[VPN(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  802c05:	8b 03                	mov    (%ebx),%eax
  802c07:	3b 43 04             	cmp    0x4(%ebx),%eax
  802c0a:	74 df                	je     802beb <devpipe_read+0x2d>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  802c0c:	89 c2                	mov    %eax,%edx
  802c0e:	c1 fa 1f             	sar    $0x1f,%edx
  802c11:	c1 ea 1b             	shr    $0x1b,%edx
  802c14:	01 d0                	add    %edx,%eax
  802c16:	83 e0 1f             	and    $0x1f,%eax
  802c19:	29 d0                	sub    %edx,%eax
  802c1b:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  802c20:	8b 55 0c             	mov    0xc(%ebp),%edx
  802c23:	88 04 32             	mov    %al,(%edx,%esi,1)
		p->p_rpos++;
  802c26:	83 03 01             	addl   $0x1,(%ebx)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			env->env_id, vpt[VPN(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  802c29:	83 c6 01             	add    $0x1,%esi
  802c2c:	39 75 10             	cmp    %esi,0x10(%ebp)
  802c2f:	76 16                	jbe    802c47 <devpipe_read+0x89>
		while (p->p_rpos == p->p_wpos) {
  802c31:	8b 03                	mov    (%ebx),%eax
  802c33:	3b 43 04             	cmp    0x4(%ebx),%eax
  802c36:	75 d4                	jne    802c0c <devpipe_read+0x4e>
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  802c38:	85 f6                	test   %esi,%esi
  802c3a:	75 ab                	jne    802be7 <devpipe_read+0x29>
  802c3c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802c40:	eb a9                	jmp    802beb <devpipe_read+0x2d>
  802c42:	be 00 00 00 00       	mov    $0x0,%esi
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  802c47:	89 f0                	mov    %esi,%eax
}
  802c49:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  802c4c:	8b 75 f8             	mov    -0x8(%ebp),%esi
  802c4f:	8b 7d fc             	mov    -0x4(%ebp),%edi
  802c52:	89 ec                	mov    %ebp,%esp
  802c54:	5d                   	pop    %ebp
  802c55:	c3                   	ret    

00802c56 <pipeisclosed>:
	}
}

int
pipeisclosed(int fdnum)
{
  802c56:	55                   	push   %ebp
  802c57:	89 e5                	mov    %esp,%ebp
  802c59:	83 ec 28             	sub    $0x28,%esp
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802c5c:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802c5f:	89 44 24 04          	mov    %eax,0x4(%esp)
  802c63:	8b 45 08             	mov    0x8(%ebp),%eax
  802c66:	89 04 24             	mov    %eax,(%esp)
  802c69:	e8 af ea ff ff       	call   80171d <fd_lookup>
  802c6e:	85 c0                	test   %eax,%eax
  802c70:	78 15                	js     802c87 <pipeisclosed+0x31>
		return r;
	p = (struct Pipe*) fd2data(fd);
  802c72:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c75:	89 04 24             	mov    %eax,(%esp)
  802c78:	e8 13 ea ff ff       	call   801690 <fd2data>
	return _pipeisclosed(fd, p);
  802c7d:	89 c2                	mov    %eax,%edx
  802c7f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c82:	e8 3b fe ff ff       	call   802ac2 <_pipeisclosed>
}
  802c87:	c9                   	leave  
  802c88:	c3                   	ret    

00802c89 <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  802c89:	55                   	push   %ebp
  802c8a:	89 e5                	mov    %esp,%ebp
  802c8c:	83 ec 48             	sub    $0x48,%esp
  802c8f:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  802c92:	89 75 f8             	mov    %esi,-0x8(%ebp)
  802c95:	89 7d fc             	mov    %edi,-0x4(%ebp)
  802c98:	8b 7d 08             	mov    0x8(%ebp),%edi
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  802c9b:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  802c9e:	89 04 24             	mov    %eax,(%esp)
  802ca1:	e8 05 ea ff ff       	call   8016ab <fd_alloc>
  802ca6:	89 c3                	mov    %eax,%ebx
  802ca8:	85 c0                	test   %eax,%eax
  802caa:	0f 88 42 01 00 00    	js     802df2 <pipe+0x169>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802cb0:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  802cb7:	00 
  802cb8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802cbb:	89 44 24 04          	mov    %eax,0x4(%esp)
  802cbf:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802cc6:	e8 d0 e4 ff ff       	call   80119b <sys_page_alloc>
  802ccb:	89 c3                	mov    %eax,%ebx
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  802ccd:	85 c0                	test   %eax,%eax
  802ccf:	0f 88 1d 01 00 00    	js     802df2 <pipe+0x169>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  802cd5:	8d 45 e0             	lea    -0x20(%ebp),%eax
  802cd8:	89 04 24             	mov    %eax,(%esp)
  802cdb:	e8 cb e9 ff ff       	call   8016ab <fd_alloc>
  802ce0:	89 c3                	mov    %eax,%ebx
  802ce2:	85 c0                	test   %eax,%eax
  802ce4:	0f 88 f5 00 00 00    	js     802ddf <pipe+0x156>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802cea:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  802cf1:	00 
  802cf2:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802cf5:	89 44 24 04          	mov    %eax,0x4(%esp)
  802cf9:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802d00:	e8 96 e4 ff ff       	call   80119b <sys_page_alloc>
  802d05:	89 c3                	mov    %eax,%ebx
	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  802d07:	85 c0                	test   %eax,%eax
  802d09:	0f 88 d0 00 00 00    	js     802ddf <pipe+0x156>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  802d0f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802d12:	89 04 24             	mov    %eax,(%esp)
  802d15:	e8 76 e9 ff ff       	call   801690 <fd2data>
  802d1a:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802d1c:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  802d23:	00 
  802d24:	89 44 24 04          	mov    %eax,0x4(%esp)
  802d28:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802d2f:	e8 67 e4 ff ff       	call   80119b <sys_page_alloc>
  802d34:	89 c3                	mov    %eax,%ebx
  802d36:	85 c0                	test   %eax,%eax
  802d38:	0f 88 8e 00 00 00    	js     802dcc <pipe+0x143>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802d3e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802d41:	89 04 24             	mov    %eax,(%esp)
  802d44:	e8 47 e9 ff ff       	call   801690 <fd2data>
  802d49:	c7 44 24 10 07 04 00 	movl   $0x407,0x10(%esp)
  802d50:	00 
  802d51:	89 44 24 0c          	mov    %eax,0xc(%esp)
  802d55:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  802d5c:	00 
  802d5d:	89 74 24 04          	mov    %esi,0x4(%esp)
  802d61:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802d68:	e8 d0 e3 ff ff       	call   80113d <sys_page_map>
  802d6d:	89 c3                	mov    %eax,%ebx
  802d6f:	85 c0                	test   %eax,%eax
  802d71:	78 49                	js     802dbc <pipe+0x133>
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  802d73:	b8 44 70 80 00       	mov    $0x807044,%eax
  802d78:	8b 08                	mov    (%eax),%ecx
  802d7a:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802d7d:	89 0a                	mov    %ecx,(%edx)
	fd0->fd_omode = O_RDONLY;
  802d7f:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802d82:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%edx)

	fd1->fd_dev_id = devpipe.dev_id;
  802d89:	8b 10                	mov    (%eax),%edx
  802d8b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802d8e:	89 10                	mov    %edx,(%eax)
	fd1->fd_omode = O_WRONLY;
  802d90:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802d93:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", env->env_id, vpt[VPN(va)]);

	pfd[0] = fd2num(fd0);
  802d9a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802d9d:	89 04 24             	mov    %eax,(%esp)
  802da0:	e8 db e8 ff ff       	call   801680 <fd2num>
  802da5:	89 07                	mov    %eax,(%edi)
	pfd[1] = fd2num(fd1);
  802da7:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802daa:	89 04 24             	mov    %eax,(%esp)
  802dad:	e8 ce e8 ff ff       	call   801680 <fd2num>
  802db2:	89 47 04             	mov    %eax,0x4(%edi)
  802db5:	bb 00 00 00 00       	mov    $0x0,%ebx
	return 0;
  802dba:	eb 36                	jmp    802df2 <pipe+0x169>

    err3:
	sys_page_unmap(0, va);
  802dbc:	89 74 24 04          	mov    %esi,0x4(%esp)
  802dc0:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802dc7:	e8 13 e3 ff ff       	call   8010df <sys_page_unmap>
    err2:
	sys_page_unmap(0, fd1);
  802dcc:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802dcf:	89 44 24 04          	mov    %eax,0x4(%esp)
  802dd3:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802dda:	e8 00 e3 ff ff       	call   8010df <sys_page_unmap>
    err1:
	sys_page_unmap(0, fd0);
  802ddf:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802de2:	89 44 24 04          	mov    %eax,0x4(%esp)
  802de6:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802ded:	e8 ed e2 ff ff       	call   8010df <sys_page_unmap>
    err:
	return r;
}
  802df2:	89 d8                	mov    %ebx,%eax
  802df4:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  802df7:	8b 75 f8             	mov    -0x8(%ebp),%esi
  802dfa:	8b 7d fc             	mov    -0x4(%ebp),%edi
  802dfd:	89 ec                	mov    %ebp,%esp
  802dff:	5d                   	pop    %ebp
  802e00:	c3                   	ret    
  802e01:	00 00                	add    %al,(%eax)
	...

00802e04 <wait>:
#include <inc/lib.h>

// Waits until 'envid' exits.
void
wait(envid_t envid)
{
  802e04:	55                   	push   %ebp
  802e05:	89 e5                	mov    %esp,%ebp
  802e07:	56                   	push   %esi
  802e08:	53                   	push   %ebx
  802e09:	83 ec 10             	sub    $0x10,%esp
  802e0c:	8b 45 08             	mov    0x8(%ebp),%eax
	volatile struct Env *e;

	assert(envid != 0);
  802e0f:	85 c0                	test   %eax,%eax
  802e11:	75 24                	jne    802e37 <wait+0x33>
  802e13:	c7 44 24 0c 2a 3c 80 	movl   $0x803c2a,0xc(%esp)
  802e1a:	00 
  802e1b:	c7 44 24 08 26 3b 80 	movl   $0x803b26,0x8(%esp)
  802e22:	00 
  802e23:	c7 44 24 04 09 00 00 	movl   $0x9,0x4(%esp)
  802e2a:	00 
  802e2b:	c7 04 24 35 3c 80 00 	movl   $0x803c35,(%esp)
  802e32:	e8 ed d3 ff ff       	call   800224 <_panic>
	e = &envs[ENVX(envid)];
  802e37:	89 c3                	mov    %eax,%ebx
  802e39:	81 e3 ff 03 00 00    	and    $0x3ff,%ebx
  802e3f:	6b db 7c             	imul   $0x7c,%ebx,%ebx
  802e42:	81 c3 00 00 c0 ee    	add    $0xeec00000,%ebx
	while (e->env_id == envid && e->env_status != ENV_FREE)
  802e48:	8b 73 4c             	mov    0x4c(%ebx),%esi
  802e4b:	39 c6                	cmp    %eax,%esi
  802e4d:	75 1a                	jne    802e69 <wait+0x65>
  802e4f:	8b 43 54             	mov    0x54(%ebx),%eax
  802e52:	85 c0                	test   %eax,%eax
  802e54:	74 13                	je     802e69 <wait+0x65>
		sys_yield();
  802e56:	e8 9f e3 ff ff       	call   8011fa <sys_yield>
{
	volatile struct Env *e;

	assert(envid != 0);
	e = &envs[ENVX(envid)];
	while (e->env_id == envid && e->env_status != ENV_FREE)
  802e5b:	8b 43 4c             	mov    0x4c(%ebx),%eax
  802e5e:	39 f0                	cmp    %esi,%eax
  802e60:	75 07                	jne    802e69 <wait+0x65>
  802e62:	8b 43 54             	mov    0x54(%ebx),%eax
  802e65:	85 c0                	test   %eax,%eax
  802e67:	75 ed                	jne    802e56 <wait+0x52>
		sys_yield();
}
  802e69:	83 c4 10             	add    $0x10,%esp
  802e6c:	5b                   	pop    %ebx
  802e6d:	5e                   	pop    %esi
  802e6e:	5d                   	pop    %ebp
  802e6f:	c3                   	ret    

00802e70 <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  802e70:	55                   	push   %ebp
  802e71:	89 e5                	mov    %esp,%ebp
	USED(fd);

	return 0;
}
  802e73:	b8 00 00 00 00       	mov    $0x0,%eax
  802e78:	5d                   	pop    %ebp
  802e79:	c3                   	ret    

00802e7a <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  802e7a:	55                   	push   %ebp
  802e7b:	89 e5                	mov    %esp,%ebp
  802e7d:	83 ec 18             	sub    $0x18,%esp
	strcpy(stat->st_name, "<cons>");
  802e80:	c7 44 24 04 40 3c 80 	movl   $0x803c40,0x4(%esp)
  802e87:	00 
  802e88:	8b 45 0c             	mov    0xc(%ebp),%eax
  802e8b:	89 04 24             	mov    %eax,(%esp)
  802e8e:	e8 17 db ff ff       	call   8009aa <strcpy>
	return 0;
}
  802e93:	b8 00 00 00 00       	mov    $0x0,%eax
  802e98:	c9                   	leave  
  802e99:	c3                   	ret    

00802e9a <devcons_write>:
	return 1;
}

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  802e9a:	55                   	push   %ebp
  802e9b:	89 e5                	mov    %esp,%ebp
  802e9d:	57                   	push   %edi
  802e9e:	56                   	push   %esi
  802e9f:	53                   	push   %ebx
  802ea0:	81 ec 9c 00 00 00    	sub    $0x9c,%esp
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs, 
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  802ea6:	b8 00 00 00 00       	mov    $0x0,%eax
  802eab:	be 00 00 00 00       	mov    $0x0,%esi
  802eb0:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  802eb4:	74 3f                	je     802ef5 <devcons_write+0x5b>
		m = n - tot;
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  802eb6:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs, 
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
		m = n - tot;
  802ebc:	8b 55 10             	mov    0x10(%ebp),%edx
  802ebf:	29 c2                	sub    %eax,%edx
  802ec1:	89 d3                	mov    %edx,%ebx
		if (m > sizeof(buf) - 1)
  802ec3:	83 fa 7f             	cmp    $0x7f,%edx
  802ec6:	76 05                	jbe    802ecd <devcons_write+0x33>
  802ec8:	bb 7f 00 00 00       	mov    $0x7f,%ebx
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  802ecd:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  802ed1:	03 45 0c             	add    0xc(%ebp),%eax
  802ed4:	89 44 24 04          	mov    %eax,0x4(%esp)
  802ed8:	89 3c 24             	mov    %edi,(%esp)
  802edb:	e8 85 dc ff ff       	call   800b65 <memmove>
		sys_cputs(buf, m);
  802ee0:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  802ee4:	89 3c 24             	mov    %edi,(%esp)
  802ee7:	e8 b4 de ff ff       	call   800da0 <sys_cputs>
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs, 
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  802eec:	01 de                	add    %ebx,%esi
  802eee:	89 f0                	mov    %esi,%eax
  802ef0:	3b 75 10             	cmp    0x10(%ebp),%esi
  802ef3:	72 c7                	jb     802ebc <devcons_write+0x22>
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
}
  802ef5:	89 f0                	mov    %esi,%eax
  802ef7:	81 c4 9c 00 00 00    	add    $0x9c,%esp
  802efd:	5b                   	pop    %ebx
  802efe:	5e                   	pop    %esi
  802eff:	5f                   	pop    %edi
  802f00:	5d                   	pop    %ebp
  802f01:	c3                   	ret    

00802f02 <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  802f02:	55                   	push   %ebp
  802f03:	89 e5                	mov    %esp,%ebp
  802f05:	83 ec 28             	sub    $0x28,%esp
	char c = ch;
  802f08:	8b 45 08             	mov    0x8(%ebp),%eax
  802f0b:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  802f0e:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  802f15:	00 
  802f16:	8d 45 f7             	lea    -0x9(%ebp),%eax
  802f19:	89 04 24             	mov    %eax,(%esp)
  802f1c:	e8 7f de ff ff       	call   800da0 <sys_cputs>
}
  802f21:	c9                   	leave  
  802f22:	c3                   	ret    

00802f23 <devcons_read>:
	return fd2num(fd);
}

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  802f23:	55                   	push   %ebp
  802f24:	89 e5                	mov    %esp,%ebp
  802f26:	83 ec 08             	sub    $0x8,%esp
	int c;

	if (n == 0)
  802f29:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  802f2d:	75 07                	jne    802f36 <devcons_read+0x13>
  802f2f:	eb 28                	jmp    802f59 <devcons_read+0x36>
		return 0;

	while ((c = sys_cgetc()) == 0)
		sys_yield();
  802f31:	e8 c4 e2 ff ff       	call   8011fa <sys_yield>
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  802f36:	66 90                	xchg   %ax,%ax
  802f38:	e8 2f de ff ff       	call   800d6c <sys_cgetc>
  802f3d:	85 c0                	test   %eax,%eax
  802f3f:	90                   	nop
  802f40:	74 ef                	je     802f31 <devcons_read+0xe>
  802f42:	89 c2                	mov    %eax,%edx
		sys_yield();
	if (c < 0)
  802f44:	85 c0                	test   %eax,%eax
  802f46:	78 16                	js     802f5e <devcons_read+0x3b>
		return c;
	if (c == 0x04)	// ctl-d is eof
  802f48:	83 f8 04             	cmp    $0x4,%eax
  802f4b:	74 0c                	je     802f59 <devcons_read+0x36>
		return 0;
	*(char*)vbuf = c;
  802f4d:	8b 45 0c             	mov    0xc(%ebp),%eax
  802f50:	88 10                	mov    %dl,(%eax)
  802f52:	b8 01 00 00 00       	mov    $0x1,%eax
	return 1;
  802f57:	eb 05                	jmp    802f5e <devcons_read+0x3b>
  802f59:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802f5e:	c9                   	leave  
  802f5f:	c3                   	ret    

00802f60 <opencons>:
	return fd->fd_dev_id == devcons.dev_id;
}

int
opencons(void)
{
  802f60:	55                   	push   %ebp
  802f61:	89 e5                	mov    %esp,%ebp
  802f63:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  802f66:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802f69:	89 04 24             	mov    %eax,(%esp)
  802f6c:	e8 3a e7 ff ff       	call   8016ab <fd_alloc>
  802f71:	85 c0                	test   %eax,%eax
  802f73:	78 3f                	js     802fb4 <opencons+0x54>
		return r;
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  802f75:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  802f7c:	00 
  802f7d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f80:	89 44 24 04          	mov    %eax,0x4(%esp)
  802f84:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802f8b:	e8 0b e2 ff ff       	call   80119b <sys_page_alloc>
  802f90:	85 c0                	test   %eax,%eax
  802f92:	78 20                	js     802fb4 <opencons+0x54>
		return r;
	fd->fd_dev_id = devcons.dev_id;
  802f94:	8b 15 60 70 80 00    	mov    0x807060,%edx
  802f9a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f9d:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  802f9f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fa2:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  802fa9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fac:	89 04 24             	mov    %eax,(%esp)
  802faf:	e8 cc e6 ff ff       	call   801680 <fd2num>
}
  802fb4:	c9                   	leave  
  802fb5:	c3                   	ret    

00802fb6 <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  802fb6:	55                   	push   %ebp
  802fb7:	89 e5                	mov    %esp,%ebp
  802fb9:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802fbc:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802fbf:	89 44 24 04          	mov    %eax,0x4(%esp)
  802fc3:	8b 45 08             	mov    0x8(%ebp),%eax
  802fc6:	89 04 24             	mov    %eax,(%esp)
  802fc9:	e8 4f e7 ff ff       	call   80171d <fd_lookup>
  802fce:	85 c0                	test   %eax,%eax
  802fd0:	78 11                	js     802fe3 <iscons+0x2d>
		return r;
	return fd->fd_dev_id == devcons.dev_id;
  802fd2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fd5:	8b 00                	mov    (%eax),%eax
  802fd7:	3b 05 60 70 80 00    	cmp    0x807060,%eax
  802fdd:	0f 94 c0             	sete   %al
  802fe0:	0f b6 c0             	movzbl %al,%eax
}
  802fe3:	c9                   	leave  
  802fe4:	c3                   	ret    

00802fe5 <getchar>:
	sys_cputs(&c, 1);
}

int
getchar(void)
{
  802fe5:	55                   	push   %ebp
  802fe6:	89 e5                	mov    %esp,%ebp
  802fe8:	83 ec 28             	sub    $0x28,%esp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  802feb:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  802ff2:	00 
  802ff3:	8d 45 f7             	lea    -0x9(%ebp),%eax
  802ff6:	89 44 24 04          	mov    %eax,0x4(%esp)
  802ffa:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  803001:	e8 78 e9 ff ff       	call   80197e <read>
	if (r < 0)
  803006:	85 c0                	test   %eax,%eax
  803008:	78 0f                	js     803019 <getchar+0x34>
		return r;
	if (r < 1)
  80300a:	85 c0                	test   %eax,%eax
  80300c:	7f 07                	jg     803015 <getchar+0x30>
  80300e:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  803013:	eb 04                	jmp    803019 <getchar+0x34>
		return -E_EOF;
	return c;
  803015:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  803019:	c9                   	leave  
  80301a:	c3                   	ret    
	...

0080301c <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  80301c:	55                   	push   %ebp
  80301d:	89 e5                	mov    %esp,%ebp
  80301f:	83 ec 18             	sub    $0x18,%esp
	int r;

	if (_pgfault_handler == 0) {
  803022:	83 3d 84 70 80 00 00 	cmpl   $0x0,0x807084
  803029:	75 78                	jne    8030a3 <set_pgfault_handler+0x87>
		// First time through!
		// LAB 4: Your code here.
		// panic("set_pgfault_handler not implemented");
		int ret;	
		if ((ret = sys_page_alloc(0, (void*)(UXSTACKTOP - PGSIZE), PTE_U | PTE_P | PTE_W)) < 0)
  80302b:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  803032:	00 
  803033:	c7 44 24 04 00 f0 bf 	movl   $0xeebff000,0x4(%esp)
  80303a:	ee 
  80303b:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  803042:	e8 54 e1 ff ff       	call   80119b <sys_page_alloc>
  803047:	85 c0                	test   %eax,%eax
  803049:	79 20                	jns    80306b <set_pgfault_handler+0x4f>
			panic (" error in sys_page_alloc: %e\n", ret);
  80304b:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80304f:	c7 44 24 08 4c 3c 80 	movl   $0x803c4c,0x8(%esp)
  803056:	00 
  803057:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  80305e:	00 
  80305f:	c7 04 24 6a 3c 80 00 	movl   $0x803c6a,(%esp)
  803066:	e8 b9 d1 ff ff       	call   800224 <_panic>
		if ((ret = sys_env_set_pgfault_upcall(0, _pgfault_upcall)) < 0)
  80306b:	c7 44 24 04 b0 30 80 	movl   $0x8030b0,0x4(%esp)
  803072:	00 
  803073:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80307a:	e8 46 df ff ff       	call   800fc5 <sys_env_set_pgfault_upcall>
  80307f:	85 c0                	test   %eax,%eax
  803081:	79 20                	jns    8030a3 <set_pgfault_handler+0x87>
			panic (" error in sys_env_set_pgfault_upcall: %e\n", ret);
  803083:	89 44 24 0c          	mov    %eax,0xc(%esp)
  803087:	c7 44 24 08 78 3c 80 	movl   $0x803c78,0x8(%esp)
  80308e:	00 
  80308f:	c7 44 24 04 25 00 00 	movl   $0x25,0x4(%esp)
  803096:	00 
  803097:	c7 04 24 6a 3c 80 00 	movl   $0x803c6a,(%esp)
  80309e:	e8 81 d1 ff ff       	call   800224 <_panic>
	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  8030a3:	8b 45 08             	mov    0x8(%ebp),%eax
  8030a6:	a3 84 70 80 00       	mov    %eax,0x807084
	
}
  8030ab:	c9                   	leave  
  8030ac:	c3                   	ret    
  8030ad:	00 00                	add    %al,(%eax)
	...

008030b0 <_pgfault_upcall>:

.text
.globl _pgfault_upcall
_pgfault_upcall:
	// Call the C page fault handler.
	pushl %esp			// function argument: pointer to UTF
  8030b0:	54                   	push   %esp
	movl _pgfault_handler, %eax
  8030b1:	a1 84 70 80 00       	mov    0x807084,%eax
	call *%eax
  8030b6:	ff d0                	call   *%eax
	addl $4, %esp			// pop function argument
  8030b8:	83 c4 04             	add    $0x4,%esp
	// may find that you have to rearrange your code in non-obvious
	// ways as registers become unavailable as scratch space.
	//
	// LAB 4: Your code here.
	
	movl %esp, %ecx			// back up esp to ecx
  8030bb:	89 e1                	mov    %esp,%ecx
	movl 0x28(%esp), %ebx		// store trap-time eip into ebx
  8030bd:	8b 5c 24 28          	mov    0x28(%esp),%ebx
	movl 0x30(%esp), %edx		// store trap-time esp into edx
  8030c1:	8b 54 24 30          	mov    0x30(%esp),%edx
	movl %edx, %esp			// switch to trap-time stack
  8030c5:	89 d4                	mov    %edx,%esp
	pushl %ebx			// push trap-time eip here
  8030c7:	53                   	push   %ebx
	movl %ecx, %esp			// come back to user exception stack
  8030c8:	89 cc                	mov    %ecx,%esp
	
	// for the push made above, update the trap-time esp value in this user exception stack
	// this enables popl %esp to cause esp point to the adjusted trap-time stack 
	subl $0x4, %edx			
  8030ca:	83 ea 04             	sub    $0x4,%edx
	movl %edx, 0x30(%esp)
  8030cd:	89 54 24 30          	mov    %edx,0x30(%esp)
	

	// Restore the trap-time registers.  After you do this, you
	// can no longer modify any general-purpose registers.
	// LAB 4: Your code here.
	addl $0x8, %esp
  8030d1:	83 c4 08             	add    $0x8,%esp
	popal
  8030d4:	61                   	popa   
	// Restore eflags from the stack.  After you do this, you can
	// no longer use arithmetic operations or anything else that
	// modifies eflags.
	// LAB 4: Your code here.
	
	addl $0x4, %esp
  8030d5:	83 c4 04             	add    $0x4,%esp
	popfl
  8030d8:	9d                   	popf   

	// Switch back to the adjusted trap-time stack.
	// LAB 4: Your code here.

	popl %esp
  8030d9:	5c                   	pop    %esp

	// Return to re-execute the instruction that faulted.
	// LAB 4: Your code here.
	
	ret
  8030da:	c3                   	ret    
  8030db:	00 00                	add    %al,(%eax)
  8030dd:	00 00                	add    %al,(%eax)
	...

008030e0 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  8030e0:	55                   	push   %ebp
  8030e1:	89 e5                	mov    %esp,%ebp
  8030e3:	57                   	push   %edi
  8030e4:	56                   	push   %esi
  8030e5:	53                   	push   %ebx
  8030e6:	83 ec 1c             	sub    $0x1c,%esp
  8030e9:	8b 7d 0c             	mov    0xc(%ebp),%edi
  8030ec:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8030ef:	8b 75 14             	mov    0x14(%ebp),%esi
	// LAB 4: Your code here.
	int r;
	if (pg == NULL)
  8030f2:	85 db                	test   %ebx,%ebx
  8030f4:	75 2d                	jne    803123 <ipc_send+0x43>
  8030f6:	bb 00 00 c0 ee       	mov    $0xeec00000,%ebx
  8030fb:	eb 26                	jmp    803123 <ipc_send+0x43>
		pg = (void*)UTOP;
	while ((r = sys_ipc_try_send(to_env, val, pg, perm)) < 0)
	{
		if(r != -E_IPC_NOT_RECV)
  8030fd:	83 f8 f9             	cmp    $0xfffffff9,%eax
  803100:	74 1c                	je     80311e <ipc_send+0x3e>
			panic("Panic in lib ipc.c : ipc_send() \n");
  803102:	c7 44 24 08 a4 3c 80 	movl   $0x803ca4,0x8(%esp)
  803109:	00 
  80310a:	c7 44 24 04 44 00 00 	movl   $0x44,0x4(%esp)
  803111:	00 
  803112:	c7 04 24 c8 3c 80 00 	movl   $0x803cc8,(%esp)
  803119:	e8 06 d1 ff ff       	call   800224 <_panic>
		sys_yield();
  80311e:	e8 d7 e0 ff ff       	call   8011fa <sys_yield>
{
	// LAB 4: Your code here.
	int r;
	if (pg == NULL)
		pg = (void*)UTOP;
	while ((r = sys_ipc_try_send(to_env, val, pg, perm)) < 0)
  803123:	89 74 24 0c          	mov    %esi,0xc(%esp)
  803127:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80312b:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80312f:	8b 45 08             	mov    0x8(%ebp),%eax
  803132:	89 04 24             	mov    %eax,(%esp)
  803135:	e8 53 de ff ff       	call   800f8d <sys_ipc_try_send>
  80313a:	85 c0                	test   %eax,%eax
  80313c:	78 bf                	js     8030fd <ipc_send+0x1d>
		if(r != -E_IPC_NOT_RECV)
			panic("Panic in lib ipc.c : ipc_send() \n");
		sys_yield();
	}
	//panic("ipc_send not implemented");
}
  80313e:	83 c4 1c             	add    $0x1c,%esp
  803141:	5b                   	pop    %ebx
  803142:	5e                   	pop    %esi
  803143:	5f                   	pop    %edi
  803144:	5d                   	pop    %ebp
  803145:	c3                   	ret    

00803146 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  803146:	55                   	push   %ebp
  803147:	89 e5                	mov    %esp,%ebp
  803149:	56                   	push   %esi
  80314a:	53                   	push   %ebx
  80314b:	83 ec 10             	sub    $0x10,%esp
  80314e:	8b 5d 08             	mov    0x8(%ebp),%ebx
  803151:	8b 45 0c             	mov    0xc(%ebp),%eax
  803154:	8b 75 10             	mov    0x10(%ebp),%esi
	// LAB 4: Your code here.
	int r;

	if (pg == NULL)
  803157:	85 c0                	test   %eax,%eax
  803159:	75 05                	jne    803160 <ipc_recv+0x1a>
  80315b:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
		pg = (void*)UTOP;
	if ((r = sys_ipc_recv(pg)) < 0)
  803160:	89 04 24             	mov    %eax,(%esp)
  803163:	e8 c8 dd ff ff       	call   800f30 <sys_ipc_recv>
  803168:	85 c0                	test   %eax,%eax
  80316a:	79 16                	jns    803182 <ipc_recv+0x3c>
	{
		if (from_env_store != NULL)
  80316c:	85 db                	test   %ebx,%ebx
  80316e:	74 06                	je     803176 <ipc_recv+0x30>
			*from_env_store = 0;
  803170:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
		if(perm_store != NULL)
  803176:	85 f6                	test   %esi,%esi
  803178:	74 2c                	je     8031a6 <ipc_recv+0x60>
			*perm_store = 0;
  80317a:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
  803180:	eb 24                	jmp    8031a6 <ipc_recv+0x60>
		return r;
	}
	else
	{	
		if (from_env_store != NULL)
  803182:	85 db                	test   %ebx,%ebx
  803184:	74 0a                	je     803190 <ipc_recv+0x4a>
			*from_env_store = env->env_ipc_from;
  803186:	a1 7c 70 80 00       	mov    0x80707c,%eax
  80318b:	8b 40 74             	mov    0x74(%eax),%eax
  80318e:	89 03                	mov    %eax,(%ebx)
		if(perm_store != NULL)
  803190:	85 f6                	test   %esi,%esi
  803192:	74 0a                	je     80319e <ipc_recv+0x58>
			*perm_store = env->env_ipc_perm;
  803194:	a1 7c 70 80 00       	mov    0x80707c,%eax
  803199:	8b 40 78             	mov    0x78(%eax),%eax
  80319c:	89 06                	mov    %eax,(%esi)
		return env->env_ipc_value;
  80319e:	a1 7c 70 80 00       	mov    0x80707c,%eax
  8031a3:	8b 40 70             	mov    0x70(%eax),%eax
	}		
	//panic("ipc_recv not implemented");
	//return 0;
}
  8031a6:	83 c4 10             	add    $0x10,%esp
  8031a9:	5b                   	pop    %ebx
  8031aa:	5e                   	pop    %esi
  8031ab:	5d                   	pop    %ebp
  8031ac:	c3                   	ret    
  8031ad:	00 00                	add    %al,(%eax)
	...

008031b0 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  8031b0:	55                   	push   %ebp
  8031b1:	89 e5                	mov    %esp,%ebp
	pte_t pte;

	if (!(vpd[PDX(v)] & PTE_P))
  8031b3:	8b 45 08             	mov    0x8(%ebp),%eax
  8031b6:	89 c2                	mov    %eax,%edx
  8031b8:	c1 ea 16             	shr    $0x16,%edx
  8031bb:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  8031c2:	f6 c2 01             	test   $0x1,%dl
  8031c5:	74 26                	je     8031ed <pageref+0x3d>
		return 0;
	pte = vpt[VPN(v)];
  8031c7:	c1 e8 0c             	shr    $0xc,%eax
  8031ca:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
	if (!(pte & PTE_P))
  8031d1:	a8 01                	test   $0x1,%al
  8031d3:	74 18                	je     8031ed <pageref+0x3d>
		return 0;
	return pages[PPN(pte)].pp_ref;
  8031d5:	c1 e8 0c             	shr    $0xc,%eax
  8031d8:	8d 14 40             	lea    (%eax,%eax,2),%edx
  8031db:	c1 e2 02             	shl    $0x2,%edx
  8031de:	b8 00 00 00 ef       	mov    $0xef000000,%eax
  8031e3:	0f b7 44 02 08       	movzwl 0x8(%edx,%eax,1),%eax
  8031e8:	0f b7 c0             	movzwl %ax,%eax
  8031eb:	eb 05                	jmp    8031f2 <pageref+0x42>
  8031ed:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8031f2:	5d                   	pop    %ebp
  8031f3:	c3                   	ret    
	...

00803200 <__udivdi3>:
  803200:	55                   	push   %ebp
  803201:	89 e5                	mov    %esp,%ebp
  803203:	57                   	push   %edi
  803204:	56                   	push   %esi
  803205:	83 ec 10             	sub    $0x10,%esp
  803208:	8b 45 14             	mov    0x14(%ebp),%eax
  80320b:	8b 55 08             	mov    0x8(%ebp),%edx
  80320e:	8b 75 10             	mov    0x10(%ebp),%esi
  803211:	8b 7d 0c             	mov    0xc(%ebp),%edi
  803214:	85 c0                	test   %eax,%eax
  803216:	89 55 f0             	mov    %edx,-0x10(%ebp)
  803219:	75 35                	jne    803250 <__udivdi3+0x50>
  80321b:	39 fe                	cmp    %edi,%esi
  80321d:	77 61                	ja     803280 <__udivdi3+0x80>
  80321f:	85 f6                	test   %esi,%esi
  803221:	75 0b                	jne    80322e <__udivdi3+0x2e>
  803223:	b8 01 00 00 00       	mov    $0x1,%eax
  803228:	31 d2                	xor    %edx,%edx
  80322a:	f7 f6                	div    %esi
  80322c:	89 c6                	mov    %eax,%esi
  80322e:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  803231:	31 d2                	xor    %edx,%edx
  803233:	89 f8                	mov    %edi,%eax
  803235:	f7 f6                	div    %esi
  803237:	89 c7                	mov    %eax,%edi
  803239:	89 c8                	mov    %ecx,%eax
  80323b:	f7 f6                	div    %esi
  80323d:	89 c1                	mov    %eax,%ecx
  80323f:	89 fa                	mov    %edi,%edx
  803241:	89 c8                	mov    %ecx,%eax
  803243:	83 c4 10             	add    $0x10,%esp
  803246:	5e                   	pop    %esi
  803247:	5f                   	pop    %edi
  803248:	5d                   	pop    %ebp
  803249:	c3                   	ret    
  80324a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  803250:	39 f8                	cmp    %edi,%eax
  803252:	77 1c                	ja     803270 <__udivdi3+0x70>
  803254:	0f bd d0             	bsr    %eax,%edx
  803257:	83 f2 1f             	xor    $0x1f,%edx
  80325a:	89 55 f4             	mov    %edx,-0xc(%ebp)
  80325d:	75 39                	jne    803298 <__udivdi3+0x98>
  80325f:	3b 75 f0             	cmp    -0x10(%ebp),%esi
  803262:	0f 86 a0 00 00 00    	jbe    803308 <__udivdi3+0x108>
  803268:	39 f8                	cmp    %edi,%eax
  80326a:	0f 82 98 00 00 00    	jb     803308 <__udivdi3+0x108>
  803270:	31 ff                	xor    %edi,%edi
  803272:	31 c9                	xor    %ecx,%ecx
  803274:	89 c8                	mov    %ecx,%eax
  803276:	89 fa                	mov    %edi,%edx
  803278:	83 c4 10             	add    $0x10,%esp
  80327b:	5e                   	pop    %esi
  80327c:	5f                   	pop    %edi
  80327d:	5d                   	pop    %ebp
  80327e:	c3                   	ret    
  80327f:	90                   	nop
  803280:	89 d1                	mov    %edx,%ecx
  803282:	89 fa                	mov    %edi,%edx
  803284:	89 c8                	mov    %ecx,%eax
  803286:	31 ff                	xor    %edi,%edi
  803288:	f7 f6                	div    %esi
  80328a:	89 c1                	mov    %eax,%ecx
  80328c:	89 fa                	mov    %edi,%edx
  80328e:	89 c8                	mov    %ecx,%eax
  803290:	83 c4 10             	add    $0x10,%esp
  803293:	5e                   	pop    %esi
  803294:	5f                   	pop    %edi
  803295:	5d                   	pop    %ebp
  803296:	c3                   	ret    
  803297:	90                   	nop
  803298:	0f b6 4d f4          	movzbl -0xc(%ebp),%ecx
  80329c:	89 f2                	mov    %esi,%edx
  80329e:	d3 e0                	shl    %cl,%eax
  8032a0:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8032a3:	b8 20 00 00 00       	mov    $0x20,%eax
  8032a8:	2b 45 f4             	sub    -0xc(%ebp),%eax
  8032ab:	89 c1                	mov    %eax,%ecx
  8032ad:	d3 ea                	shr    %cl,%edx
  8032af:	0f b6 4d f4          	movzbl -0xc(%ebp),%ecx
  8032b3:	0b 55 ec             	or     -0x14(%ebp),%edx
  8032b6:	d3 e6                	shl    %cl,%esi
  8032b8:	89 c1                	mov    %eax,%ecx
  8032ba:	89 75 e8             	mov    %esi,-0x18(%ebp)
  8032bd:	89 fe                	mov    %edi,%esi
  8032bf:	d3 ee                	shr    %cl,%esi
  8032c1:	0f b6 4d f4          	movzbl -0xc(%ebp),%ecx
  8032c5:	89 55 ec             	mov    %edx,-0x14(%ebp)
  8032c8:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8032cb:	d3 e7                	shl    %cl,%edi
  8032cd:	89 c1                	mov    %eax,%ecx
  8032cf:	d3 ea                	shr    %cl,%edx
  8032d1:	09 d7                	or     %edx,%edi
  8032d3:	89 f2                	mov    %esi,%edx
  8032d5:	89 f8                	mov    %edi,%eax
  8032d7:	f7 75 ec             	divl   -0x14(%ebp)
  8032da:	89 d6                	mov    %edx,%esi
  8032dc:	89 c7                	mov    %eax,%edi
  8032de:	f7 65 e8             	mull   -0x18(%ebp)
  8032e1:	39 d6                	cmp    %edx,%esi
  8032e3:	89 55 ec             	mov    %edx,-0x14(%ebp)
  8032e6:	72 30                	jb     803318 <__udivdi3+0x118>
  8032e8:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8032eb:	0f b6 4d f4          	movzbl -0xc(%ebp),%ecx
  8032ef:	d3 e2                	shl    %cl,%edx
  8032f1:	39 c2                	cmp    %eax,%edx
  8032f3:	73 05                	jae    8032fa <__udivdi3+0xfa>
  8032f5:	3b 75 ec             	cmp    -0x14(%ebp),%esi
  8032f8:	74 1e                	je     803318 <__udivdi3+0x118>
  8032fa:	89 f9                	mov    %edi,%ecx
  8032fc:	31 ff                	xor    %edi,%edi
  8032fe:	e9 71 ff ff ff       	jmp    803274 <__udivdi3+0x74>
  803303:	90                   	nop
  803304:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  803308:	31 ff                	xor    %edi,%edi
  80330a:	b9 01 00 00 00       	mov    $0x1,%ecx
  80330f:	e9 60 ff ff ff       	jmp    803274 <__udivdi3+0x74>
  803314:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  803318:	8d 4f ff             	lea    -0x1(%edi),%ecx
  80331b:	31 ff                	xor    %edi,%edi
  80331d:	89 c8                	mov    %ecx,%eax
  80331f:	89 fa                	mov    %edi,%edx
  803321:	83 c4 10             	add    $0x10,%esp
  803324:	5e                   	pop    %esi
  803325:	5f                   	pop    %edi
  803326:	5d                   	pop    %ebp
  803327:	c3                   	ret    
	...

00803330 <__umoddi3>:
  803330:	55                   	push   %ebp
  803331:	89 e5                	mov    %esp,%ebp
  803333:	57                   	push   %edi
  803334:	56                   	push   %esi
  803335:	83 ec 20             	sub    $0x20,%esp
  803338:	8b 55 14             	mov    0x14(%ebp),%edx
  80333b:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80333e:	8b 7d 10             	mov    0x10(%ebp),%edi
  803341:	8b 75 0c             	mov    0xc(%ebp),%esi
  803344:	85 d2                	test   %edx,%edx
  803346:	89 c8                	mov    %ecx,%eax
  803348:	89 4d f4             	mov    %ecx,-0xc(%ebp)
  80334b:	75 13                	jne    803360 <__umoddi3+0x30>
  80334d:	39 f7                	cmp    %esi,%edi
  80334f:	76 3f                	jbe    803390 <__umoddi3+0x60>
  803351:	89 f2                	mov    %esi,%edx
  803353:	f7 f7                	div    %edi
  803355:	89 d0                	mov    %edx,%eax
  803357:	31 d2                	xor    %edx,%edx
  803359:	83 c4 20             	add    $0x20,%esp
  80335c:	5e                   	pop    %esi
  80335d:	5f                   	pop    %edi
  80335e:	5d                   	pop    %ebp
  80335f:	c3                   	ret    
  803360:	39 f2                	cmp    %esi,%edx
  803362:	77 4c                	ja     8033b0 <__umoddi3+0x80>
  803364:	0f bd ca             	bsr    %edx,%ecx
  803367:	83 f1 1f             	xor    $0x1f,%ecx
  80336a:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  80336d:	75 51                	jne    8033c0 <__umoddi3+0x90>
  80336f:	3b 7d f4             	cmp    -0xc(%ebp),%edi
  803372:	0f 87 e0 00 00 00    	ja     803458 <__umoddi3+0x128>
  803378:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80337b:	29 f8                	sub    %edi,%eax
  80337d:	19 d6                	sbb    %edx,%esi
  80337f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803382:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803385:	89 f2                	mov    %esi,%edx
  803387:	83 c4 20             	add    $0x20,%esp
  80338a:	5e                   	pop    %esi
  80338b:	5f                   	pop    %edi
  80338c:	5d                   	pop    %ebp
  80338d:	c3                   	ret    
  80338e:	66 90                	xchg   %ax,%ax
  803390:	85 ff                	test   %edi,%edi
  803392:	75 0b                	jne    80339f <__umoddi3+0x6f>
  803394:	b8 01 00 00 00       	mov    $0x1,%eax
  803399:	31 d2                	xor    %edx,%edx
  80339b:	f7 f7                	div    %edi
  80339d:	89 c7                	mov    %eax,%edi
  80339f:	89 f0                	mov    %esi,%eax
  8033a1:	31 d2                	xor    %edx,%edx
  8033a3:	f7 f7                	div    %edi
  8033a5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033a8:	f7 f7                	div    %edi
  8033aa:	eb a9                	jmp    803355 <__umoddi3+0x25>
  8033ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  8033b0:	89 c8                	mov    %ecx,%eax
  8033b2:	89 f2                	mov    %esi,%edx
  8033b4:	83 c4 20             	add    $0x20,%esp
  8033b7:	5e                   	pop    %esi
  8033b8:	5f                   	pop    %edi
  8033b9:	5d                   	pop    %ebp
  8033ba:	c3                   	ret    
  8033bb:	90                   	nop
  8033bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  8033c0:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
  8033c4:	d3 e2                	shl    %cl,%edx
  8033c6:	89 55 f4             	mov    %edx,-0xc(%ebp)
  8033c9:	ba 20 00 00 00       	mov    $0x20,%edx
  8033ce:	2b 55 f0             	sub    -0x10(%ebp),%edx
  8033d1:	89 55 ec             	mov    %edx,-0x14(%ebp)
  8033d4:	0f b6 4d ec          	movzbl -0x14(%ebp),%ecx
  8033d8:	89 fa                	mov    %edi,%edx
  8033da:	d3 ea                	shr    %cl,%edx
  8033dc:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
  8033e0:	0b 55 f4             	or     -0xc(%ebp),%edx
  8033e3:	d3 e7                	shl    %cl,%edi
  8033e5:	0f b6 4d ec          	movzbl -0x14(%ebp),%ecx
  8033e9:	89 55 f4             	mov    %edx,-0xc(%ebp)
  8033ec:	89 f2                	mov    %esi,%edx
  8033ee:	89 7d e8             	mov    %edi,-0x18(%ebp)
  8033f1:	89 c7                	mov    %eax,%edi
  8033f3:	d3 ea                	shr    %cl,%edx
  8033f5:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
  8033f9:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  8033fc:	89 c2                	mov    %eax,%edx
  8033fe:	d3 e6                	shl    %cl,%esi
  803400:	0f b6 4d ec          	movzbl -0x14(%ebp),%ecx
  803404:	d3 ea                	shr    %cl,%edx
  803406:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
  80340a:	09 d6                	or     %edx,%esi
  80340c:	89 f0                	mov    %esi,%eax
  80340e:	8b 75 e4             	mov    -0x1c(%ebp),%esi
  803411:	d3 e7                	shl    %cl,%edi
  803413:	89 f2                	mov    %esi,%edx
  803415:	f7 75 f4             	divl   -0xc(%ebp)
  803418:	89 d6                	mov    %edx,%esi
  80341a:	f7 65 e8             	mull   -0x18(%ebp)
  80341d:	39 d6                	cmp    %edx,%esi
  80341f:	72 2b                	jb     80344c <__umoddi3+0x11c>
  803421:	39 c7                	cmp    %eax,%edi
  803423:	72 23                	jb     803448 <__umoddi3+0x118>
  803425:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
  803429:	29 c7                	sub    %eax,%edi
  80342b:	19 d6                	sbb    %edx,%esi
  80342d:	89 f0                	mov    %esi,%eax
  80342f:	89 f2                	mov    %esi,%edx
  803431:	d3 ef                	shr    %cl,%edi
  803433:	0f b6 4d ec          	movzbl -0x14(%ebp),%ecx
  803437:	d3 e0                	shl    %cl,%eax
  803439:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
  80343d:	09 f8                	or     %edi,%eax
  80343f:	d3 ea                	shr    %cl,%edx
  803441:	83 c4 20             	add    $0x20,%esp
  803444:	5e                   	pop    %esi
  803445:	5f                   	pop    %edi
  803446:	5d                   	pop    %ebp
  803447:	c3                   	ret    
  803448:	39 d6                	cmp    %edx,%esi
  80344a:	75 d9                	jne    803425 <__umoddi3+0xf5>
  80344c:	2b 45 e8             	sub    -0x18(%ebp),%eax
  80344f:	1b 55 f4             	sbb    -0xc(%ebp),%edx
  803452:	eb d1                	jmp    803425 <__umoddi3+0xf5>
  803454:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  803458:	39 f2                	cmp    %esi,%edx
  80345a:	0f 82 18 ff ff ff    	jb     803378 <__umoddi3+0x48>
  803460:	e9 1d ff ff ff       	jmp    803382 <__umoddi3+0x52>
