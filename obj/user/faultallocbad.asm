
obj/user/faultallocbad:     file format elf32-i386


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
  80002c:	e8 b3 00 00 00       	call   8000e4 <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>
	...

00800034 <umain>:
	snprintf((char*) addr, 100, "this string was faulted in at %x", addr);
}

void
umain(void)
{
  800034:	55                   	push   %ebp
  800035:	89 e5                	mov    %esp,%ebp
  800037:	83 ec 18             	sub    $0x18,%esp
	set_pgfault_handler(handler);
  80003a:	c7 04 24 5c 00 80 00 	movl   $0x80005c,(%esp)
  800041:	e8 aa 11 00 00       	call   8011f0 <set_pgfault_handler>
	sys_cputs((char*)0xDEADBEEF, 4);
  800046:	c7 44 24 04 04 00 00 	movl   $0x4,0x4(%esp)
  80004d:	00 
  80004e:	c7 04 24 ef be ad de 	movl   $0xdeadbeef,(%esp)
  800055:	e8 76 0c 00 00       	call   800cd0 <sys_cputs>
}
  80005a:	c9                   	leave  
  80005b:	c3                   	ret    

0080005c <handler>:

#include <inc/lib.h>

void
handler(struct UTrapframe *utf)
{
  80005c:	55                   	push   %ebp
  80005d:	89 e5                	mov    %esp,%ebp
  80005f:	53                   	push   %ebx
  800060:	83 ec 24             	sub    $0x24,%esp
	int r;
	void *addr = (void*)utf->utf_fault_va;
  800063:	8b 45 08             	mov    0x8(%ebp),%eax
  800066:	8b 18                	mov    (%eax),%ebx

	cprintf("fault %x\n", addr);
  800068:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  80006c:	c7 04 24 40 29 80 00 	movl   $0x802940,(%esp)
  800073:	e8 9d 01 00 00       	call   800215 <cprintf>
	if ((r = sys_page_alloc(0, ROUNDDOWN(addr, PGSIZE),
  800078:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  80007f:	00 
  800080:	89 d8                	mov    %ebx,%eax
  800082:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800087:	89 44 24 04          	mov    %eax,0x4(%esp)
  80008b:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  800092:	e8 34 10 00 00       	call   8010cb <sys_page_alloc>
  800097:	85 c0                	test   %eax,%eax
  800099:	79 24                	jns    8000bf <handler+0x63>
				PTE_P|PTE_U|PTE_W)) < 0)
		panic("allocating at %x in page fault handler: %e", addr, r);
  80009b:	89 44 24 10          	mov    %eax,0x10(%esp)
  80009f:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  8000a3:	c7 44 24 08 60 29 80 	movl   $0x802960,0x8(%esp)
  8000aa:	00 
  8000ab:	c7 44 24 04 0f 00 00 	movl   $0xf,0x4(%esp)
  8000b2:	00 
  8000b3:	c7 04 24 4a 29 80 00 	movl   $0x80294a,(%esp)
  8000ba:	e8 91 00 00 00       	call   800150 <_panic>
	snprintf((char*) addr, 100, "this string was faulted in at %x", addr);
  8000bf:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  8000c3:	c7 44 24 08 8c 29 80 	movl   $0x80298c,0x8(%esp)
  8000ca:	00 
  8000cb:	c7 44 24 04 64 00 00 	movl   $0x64,0x4(%esp)
  8000d2:	00 
  8000d3:	89 1c 24             	mov    %ebx,(%esp)
  8000d6:	e8 61 07 00 00       	call   80083c <snprintf>
}
  8000db:	83 c4 24             	add    $0x24,%esp
  8000de:	5b                   	pop    %ebx
  8000df:	5d                   	pop    %ebp
  8000e0:	c3                   	ret    
  8000e1:	00 00                	add    %al,(%eax)
	...

008000e4 <libmain>:
volatile struct Env *env;
char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  8000e4:	55                   	push   %ebp
  8000e5:	89 e5                	mov    %esp,%ebp
  8000e7:	83 ec 18             	sub    $0x18,%esp
  8000ea:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  8000ed:	89 75 fc             	mov    %esi,-0x4(%ebp)
  8000f0:	8b 75 08             	mov    0x8(%ebp),%esi
  8000f3:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	// set env to point at our env structure in envs[].
	// LAB 3b: Your code here.
	// Code added by Swastika / Sandeep	
	envid_t envid = sys_getenvid();
  8000f6:	e8 63 10 00 00       	call   80115e <sys_getenvid>
	env = &envs[ENVX(envid)];
  8000fb:	25 ff 03 00 00       	and    $0x3ff,%eax
  800100:	6b c0 7c             	imul   $0x7c,%eax,%eax
  800103:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800108:	a3 74 60 80 00       	mov    %eax,0x806074

	// save the name of the program so that panic() can use it
	if (argc > 0)
  80010d:	85 f6                	test   %esi,%esi
  80010f:	7e 07                	jle    800118 <libmain+0x34>
		binaryname = argv[0];
  800111:	8b 03                	mov    (%ebx),%eax
  800113:	a3 00 60 80 00       	mov    %eax,0x806000

	// call user main routine
	umain(argc, argv);
  800118:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  80011c:	89 34 24             	mov    %esi,(%esp)
  80011f:	e8 10 ff ff ff       	call   800034 <umain>

	// exit gracefully
	exit();
  800124:	e8 0b 00 00 00       	call   800134 <exit>
}
  800129:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  80012c:	8b 75 fc             	mov    -0x4(%ebp),%esi
  80012f:	89 ec                	mov    %ebp,%esp
  800131:	5d                   	pop    %ebp
  800132:	c3                   	ret    
	...

00800134 <exit>:
#include <inc/lib.h>

void
exit(void)
{
  800134:	55                   	push   %ebp
  800135:	89 e5                	mov    %esp,%ebp
  800137:	83 ec 18             	sub    $0x18,%esp
	close_all();
  80013a:	e8 4c 16 00 00       	call   80178b <close_all>
	sys_env_destroy(0);
  80013f:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  800146:	e8 47 10 00 00       	call   801192 <sys_env_destroy>
}
  80014b:	c9                   	leave  
  80014c:	c3                   	ret    
  80014d:	00 00                	add    %al,(%eax)
	...

00800150 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  800150:	55                   	push   %ebp
  800151:	89 e5                	mov    %esp,%ebp
  800153:	53                   	push   %ebx
  800154:	83 ec 14             	sub    $0x14,%esp
 * Panic is called on unresolvable fatal errors.
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
  800157:	8d 5d 14             	lea    0x14(%ebp),%ebx
	va_list ap;

	va_start(ap, fmt);

	// Print the panic message
	if (argv0)
  80015a:	a1 78 60 80 00       	mov    0x806078,%eax
  80015f:	85 c0                	test   %eax,%eax
  800161:	74 10                	je     800173 <_panic+0x23>
		cprintf("%s: ", argv0);
  800163:	89 44 24 04          	mov    %eax,0x4(%esp)
  800167:	c7 04 24 c4 29 80 00 	movl   $0x8029c4,(%esp)
  80016e:	e8 a2 00 00 00       	call   800215 <cprintf>
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  800173:	8b 45 0c             	mov    0xc(%ebp),%eax
  800176:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80017a:	8b 45 08             	mov    0x8(%ebp),%eax
  80017d:	89 44 24 08          	mov    %eax,0x8(%esp)
  800181:	a1 00 60 80 00       	mov    0x806000,%eax
  800186:	89 44 24 04          	mov    %eax,0x4(%esp)
  80018a:	c7 04 24 c9 29 80 00 	movl   $0x8029c9,(%esp)
  800191:	e8 7f 00 00 00       	call   800215 <cprintf>
	vcprintf(fmt, ap);
  800196:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  80019a:	8b 45 10             	mov    0x10(%ebp),%eax
  80019d:	89 04 24             	mov    %eax,(%esp)
  8001a0:	e8 0f 00 00 00       	call   8001b4 <vcprintf>
	cprintf("\n");
  8001a5:	c7 04 24 5a 2e 80 00 	movl   $0x802e5a,(%esp)
  8001ac:	e8 64 00 00 00       	call   800215 <cprintf>

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  8001b1:	cc                   	int3   
  8001b2:	eb fd                	jmp    8001b1 <_panic+0x61>

008001b4 <vcprintf>:
	b->cnt++;
}

int
vcprintf(const char *fmt, va_list ap)
{
  8001b4:	55                   	push   %ebp
  8001b5:	89 e5                	mov    %esp,%ebp
  8001b7:	81 ec 28 01 00 00    	sub    $0x128,%esp
	struct printbuf b;

	b.idx = 0;
  8001bd:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8001c4:	00 00 00 
	b.cnt = 0;
  8001c7:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8001ce:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  8001d1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8001d4:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8001d8:	8b 45 08             	mov    0x8(%ebp),%eax
  8001db:	89 44 24 08          	mov    %eax,0x8(%esp)
  8001df:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8001e5:	89 44 24 04          	mov    %eax,0x4(%esp)
  8001e9:	c7 04 24 2f 02 80 00 	movl   $0x80022f,(%esp)
  8001f0:	e8 d8 01 00 00       	call   8003cd <vprintfmt>
	sys_cputs(b.buf, b.idx);
  8001f5:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
  8001fb:	89 44 24 04          	mov    %eax,0x4(%esp)
  8001ff:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  800205:	89 04 24             	mov    %eax,(%esp)
  800208:	e8 c3 0a 00 00       	call   800cd0 <sys_cputs>

	return b.cnt;
}
  80020d:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  800213:	c9                   	leave  
  800214:	c3                   	ret    

00800215 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  800215:	55                   	push   %ebp
  800216:	89 e5                	mov    %esp,%ebp
  800218:	83 ec 18             	sub    $0x18,%esp

	return b.cnt;
}

int
cprintf(const char *fmt, ...)
  80021b:	8d 45 0c             	lea    0xc(%ebp),%eax
{
	va_list ap;
	int cnt;

	va_start(ap, fmt);
	cnt = vcprintf(fmt, ap);
  80021e:	89 44 24 04          	mov    %eax,0x4(%esp)
  800222:	8b 45 08             	mov    0x8(%ebp),%eax
  800225:	89 04 24             	mov    %eax,(%esp)
  800228:	e8 87 ff ff ff       	call   8001b4 <vcprintf>
	va_end(ap);

	return cnt;
}
  80022d:	c9                   	leave  
  80022e:	c3                   	ret    

0080022f <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  80022f:	55                   	push   %ebp
  800230:	89 e5                	mov    %esp,%ebp
  800232:	53                   	push   %ebx
  800233:	83 ec 14             	sub    $0x14,%esp
  800236:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  800239:	8b 03                	mov    (%ebx),%eax
  80023b:	8b 55 08             	mov    0x8(%ebp),%edx
  80023e:	88 54 03 08          	mov    %dl,0x8(%ebx,%eax,1)
  800242:	83 c0 01             	add    $0x1,%eax
  800245:	89 03                	mov    %eax,(%ebx)
	if (b->idx == 256-1) {
  800247:	3d ff 00 00 00       	cmp    $0xff,%eax
  80024c:	75 19                	jne    800267 <putch+0x38>
		sys_cputs(b->buf, b->idx);
  80024e:	c7 44 24 04 ff 00 00 	movl   $0xff,0x4(%esp)
  800255:	00 
  800256:	8d 43 08             	lea    0x8(%ebx),%eax
  800259:	89 04 24             	mov    %eax,(%esp)
  80025c:	e8 6f 0a 00 00       	call   800cd0 <sys_cputs>
		b->idx = 0;
  800261:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
	}
	b->cnt++;
  800267:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  80026b:	83 c4 14             	add    $0x14,%esp
  80026e:	5b                   	pop    %ebx
  80026f:	5d                   	pop    %ebp
  800270:	c3                   	ret    
	...

00800280 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800280:	55                   	push   %ebp
  800281:	89 e5                	mov    %esp,%ebp
  800283:	57                   	push   %edi
  800284:	56                   	push   %esi
  800285:	53                   	push   %ebx
  800286:	83 ec 4c             	sub    $0x4c,%esp
  800289:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80028c:	89 d6                	mov    %edx,%esi
  80028e:	8b 45 08             	mov    0x8(%ebp),%eax
  800291:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800294:	8b 55 0c             	mov    0xc(%ebp),%edx
  800297:	89 55 e0             	mov    %edx,-0x20(%ebp)
  80029a:	8b 45 10             	mov    0x10(%ebp),%eax
  80029d:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8002a0:	8b 7d 18             	mov    0x18(%ebp),%edi
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8002a3:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8002a6:	b9 00 00 00 00       	mov    $0x0,%ecx
  8002ab:	39 d1                	cmp    %edx,%ecx
  8002ad:	72 15                	jb     8002c4 <printnum+0x44>
  8002af:	77 07                	ja     8002b8 <printnum+0x38>
  8002b1:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8002b4:	39 d0                	cmp    %edx,%eax
  8002b6:	76 0c                	jbe    8002c4 <printnum+0x44>
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8002b8:	83 eb 01             	sub    $0x1,%ebx
  8002bb:	85 db                	test   %ebx,%ebx
  8002bd:	8d 76 00             	lea    0x0(%esi),%esi
  8002c0:	7f 61                	jg     800323 <printnum+0xa3>
  8002c2:	eb 70                	jmp    800334 <printnum+0xb4>
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8002c4:	89 7c 24 10          	mov    %edi,0x10(%esp)
  8002c8:	83 eb 01             	sub    $0x1,%ebx
  8002cb:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  8002cf:	89 44 24 08          	mov    %eax,0x8(%esp)
  8002d3:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  8002d7:	8b 5c 24 0c          	mov    0xc(%esp),%ebx
  8002db:	89 4d d0             	mov    %ecx,-0x30(%ebp)
  8002de:	89 5d d4             	mov    %ebx,-0x2c(%ebp)
  8002e1:	8b 5d dc             	mov    -0x24(%ebp),%ebx
  8002e4:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8002e8:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  8002ef:	00 
  8002f0:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8002f3:	89 04 24             	mov    %eax,(%esp)
  8002f6:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8002f9:	89 54 24 04          	mov    %edx,0x4(%esp)
  8002fd:	e8 ce 23 00 00       	call   8026d0 <__udivdi3>
  800302:	8b 4d d0             	mov    -0x30(%ebp),%ecx
  800305:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
  800308:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  80030c:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  800310:	89 04 24             	mov    %eax,(%esp)
  800313:	89 54 24 04          	mov    %edx,0x4(%esp)
  800317:	89 f2                	mov    %esi,%edx
  800319:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80031c:	e8 5f ff ff ff       	call   800280 <printnum>
  800321:	eb 11                	jmp    800334 <printnum+0xb4>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800323:	89 74 24 04          	mov    %esi,0x4(%esp)
  800327:	89 3c 24             	mov    %edi,(%esp)
  80032a:	ff 55 e4             	call   *-0x1c(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  80032d:	83 eb 01             	sub    $0x1,%ebx
  800330:	85 db                	test   %ebx,%ebx
  800332:	7f ef                	jg     800323 <printnum+0xa3>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800334:	89 74 24 04          	mov    %esi,0x4(%esp)
  800338:	8b 74 24 04          	mov    0x4(%esp),%esi
  80033c:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80033f:	89 44 24 08          	mov    %eax,0x8(%esp)
  800343:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  80034a:	00 
  80034b:	8b 55 d8             	mov    -0x28(%ebp),%edx
  80034e:	89 14 24             	mov    %edx,(%esp)
  800351:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  800354:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  800358:	e8 a3 24 00 00       	call   802800 <__umoddi3>
  80035d:	89 74 24 04          	mov    %esi,0x4(%esp)
  800361:	0f be 80 e5 29 80 00 	movsbl 0x8029e5(%eax),%eax
  800368:	89 04 24             	mov    %eax,(%esp)
  80036b:	ff 55 e4             	call   *-0x1c(%ebp)
}
  80036e:	83 c4 4c             	add    $0x4c,%esp
  800371:	5b                   	pop    %ebx
  800372:	5e                   	pop    %esi
  800373:	5f                   	pop    %edi
  800374:	5d                   	pop    %ebp
  800375:	c3                   	ret    

00800376 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800376:	55                   	push   %ebp
  800377:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800379:	83 fa 01             	cmp    $0x1,%edx
  80037c:	7e 0e                	jle    80038c <getuint+0x16>
		return va_arg(*ap, unsigned long long);
  80037e:	8b 10                	mov    (%eax),%edx
  800380:	8d 4a 08             	lea    0x8(%edx),%ecx
  800383:	89 08                	mov    %ecx,(%eax)
  800385:	8b 02                	mov    (%edx),%eax
  800387:	8b 52 04             	mov    0x4(%edx),%edx
  80038a:	eb 22                	jmp    8003ae <getuint+0x38>
	else if (lflag)
  80038c:	85 d2                	test   %edx,%edx
  80038e:	74 10                	je     8003a0 <getuint+0x2a>
		return va_arg(*ap, unsigned long);
  800390:	8b 10                	mov    (%eax),%edx
  800392:	8d 4a 04             	lea    0x4(%edx),%ecx
  800395:	89 08                	mov    %ecx,(%eax)
  800397:	8b 02                	mov    (%edx),%eax
  800399:	ba 00 00 00 00       	mov    $0x0,%edx
  80039e:	eb 0e                	jmp    8003ae <getuint+0x38>
	else
		return va_arg(*ap, unsigned int);
  8003a0:	8b 10                	mov    (%eax),%edx
  8003a2:	8d 4a 04             	lea    0x4(%edx),%ecx
  8003a5:	89 08                	mov    %ecx,(%eax)
  8003a7:	8b 02                	mov    (%edx),%eax
  8003a9:	ba 00 00 00 00       	mov    $0x0,%edx
}
  8003ae:	5d                   	pop    %ebp
  8003af:	c3                   	ret    

008003b0 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8003b0:	55                   	push   %ebp
  8003b1:	89 e5                	mov    %esp,%ebp
  8003b3:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  8003b6:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  8003ba:	8b 10                	mov    (%eax),%edx
  8003bc:	3b 50 04             	cmp    0x4(%eax),%edx
  8003bf:	73 0a                	jae    8003cb <sprintputch+0x1b>
		*b->buf++ = ch;
  8003c1:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8003c4:	88 0a                	mov    %cl,(%edx)
  8003c6:	83 c2 01             	add    $0x1,%edx
  8003c9:	89 10                	mov    %edx,(%eax)
}
  8003cb:	5d                   	pop    %ebp
  8003cc:	c3                   	ret    

008003cd <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  8003cd:	55                   	push   %ebp
  8003ce:	89 e5                	mov    %esp,%ebp
  8003d0:	57                   	push   %edi
  8003d1:	56                   	push   %esi
  8003d2:	53                   	push   %ebx
  8003d3:	83 ec 5c             	sub    $0x5c,%esp
  8003d6:	8b 7d 08             	mov    0x8(%ebp),%edi
  8003d9:	8b 75 0c             	mov    0xc(%ebp),%esi
  8003dc:	8b 5d 10             	mov    0x10(%ebp),%ebx
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  8003df:	c7 45 c8 ff ff ff ff 	movl   $0xffffffff,-0x38(%ebp)
  8003e6:	eb 11                	jmp    8003f9 <vprintfmt+0x2c>
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
  8003e8:	85 c0                	test   %eax,%eax
  8003ea:	0f 84 ec 03 00 00    	je     8007dc <vprintfmt+0x40f>
				return;
			putch(ch, putdat);
  8003f0:	89 74 24 04          	mov    %esi,0x4(%esp)
  8003f4:	89 04 24             	mov    %eax,(%esp)
  8003f7:	ff d7                	call   *%edi
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8003f9:	0f b6 03             	movzbl (%ebx),%eax
  8003fc:	83 c3 01             	add    $0x1,%ebx
  8003ff:	83 f8 25             	cmp    $0x25,%eax
  800402:	75 e4                	jne    8003e8 <vprintfmt+0x1b>
  800404:	c6 45 d4 20          	movb   $0x20,-0x2c(%ebp)
  800408:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
  80040f:	c7 45 d0 ff ff ff ff 	movl   $0xffffffff,-0x30(%ebp)
  800416:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
  80041d:	b9 00 00 00 00       	mov    $0x0,%ecx
  800422:	eb 06                	jmp    80042a <vprintfmt+0x5d>
  800424:	c6 45 d4 2d          	movb   $0x2d,-0x2c(%ebp)
  800428:	89 c3                	mov    %eax,%ebx
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80042a:	0f b6 13             	movzbl (%ebx),%edx
  80042d:	0f b6 c2             	movzbl %dl,%eax
  800430:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800433:	8d 43 01             	lea    0x1(%ebx),%eax
  800436:	83 ea 23             	sub    $0x23,%edx
  800439:	80 fa 55             	cmp    $0x55,%dl
  80043c:	0f 87 7d 03 00 00    	ja     8007bf <vprintfmt+0x3f2>
  800442:	0f b6 d2             	movzbl %dl,%edx
  800445:	ff 24 95 20 2b 80 00 	jmp    *0x802b20(,%edx,4)
  80044c:	c6 45 d4 30          	movb   $0x30,-0x2c(%ebp)
  800450:	eb d6                	jmp    800428 <vprintfmt+0x5b>
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
				precision = precision * 10 + ch - '0';
  800452:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800455:	83 ea 30             	sub    $0x30,%edx
  800458:	89 55 d0             	mov    %edx,-0x30(%ebp)
				ch = *fmt;
  80045b:	0f be 10             	movsbl (%eax),%edx
				if (ch < '0' || ch > '9')
  80045e:	8d 5a d0             	lea    -0x30(%edx),%ebx
  800461:	83 fb 09             	cmp    $0x9,%ebx
  800464:	77 4c                	ja     8004b2 <vprintfmt+0xe5>
  800466:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  800469:	8b 4d d0             	mov    -0x30(%ebp),%ecx
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  80046c:	83 c0 01             	add    $0x1,%eax
				precision = precision * 10 + ch - '0';
  80046f:	8d 0c 89             	lea    (%ecx,%ecx,4),%ecx
  800472:	8d 4c 4a d0          	lea    -0x30(%edx,%ecx,2),%ecx
				ch = *fmt;
  800476:	0f be 10             	movsbl (%eax),%edx
				if (ch < '0' || ch > '9')
  800479:	8d 5a d0             	lea    -0x30(%edx),%ebx
  80047c:	83 fb 09             	cmp    $0x9,%ebx
  80047f:	76 eb                	jbe    80046c <vprintfmt+0x9f>
  800481:	89 4d d0             	mov    %ecx,-0x30(%ebp)
  800484:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  800487:	eb 29                	jmp    8004b2 <vprintfmt+0xe5>
					break;
			}
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800489:	8b 55 14             	mov    0x14(%ebp),%edx
  80048c:	8d 5a 04             	lea    0x4(%edx),%ebx
  80048f:	89 5d 14             	mov    %ebx,0x14(%ebp)
  800492:	8b 12                	mov    (%edx),%edx
  800494:	89 55 d0             	mov    %edx,-0x30(%ebp)
			goto process_precision;
  800497:	eb 19                	jmp    8004b2 <vprintfmt+0xe5>

		case '.':
			if (width < 0)
  800499:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80049c:	c1 fa 1f             	sar    $0x1f,%edx
  80049f:	f7 d2                	not    %edx
  8004a1:	21 55 e4             	and    %edx,-0x1c(%ebp)
  8004a4:	eb 82                	jmp    800428 <vprintfmt+0x5b>
  8004a6:	c7 45 d8 01 00 00 00 	movl   $0x1,-0x28(%ebp)
				width = 0;
			goto reswitch;

		case '#':
			altflag = 1;
			goto reswitch;
  8004ad:	e9 76 ff ff ff       	jmp    800428 <vprintfmt+0x5b>

		process_precision:
			if (width < 0)
  8004b2:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8004b6:	0f 89 6c ff ff ff    	jns    800428 <vprintfmt+0x5b>
  8004bc:	8b 55 d0             	mov    -0x30(%ebp),%edx
  8004bf:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  8004c2:	8b 55 c8             	mov    -0x38(%ebp),%edx
  8004c5:	89 55 d0             	mov    %edx,-0x30(%ebp)
  8004c8:	e9 5b ff ff ff       	jmp    800428 <vprintfmt+0x5b>
				width = precision, precision = -1;
			goto reswitch;

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  8004cd:	83 c1 01             	add    $0x1,%ecx
			goto reswitch;
  8004d0:	e9 53 ff ff ff       	jmp    800428 <vprintfmt+0x5b>
  8004d5:	89 45 cc             	mov    %eax,-0x34(%ebp)

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  8004d8:	8b 45 14             	mov    0x14(%ebp),%eax
  8004db:	8d 50 04             	lea    0x4(%eax),%edx
  8004de:	89 55 14             	mov    %edx,0x14(%ebp)
  8004e1:	89 74 24 04          	mov    %esi,0x4(%esp)
  8004e5:	8b 00                	mov    (%eax),%eax
  8004e7:	89 04 24             	mov    %eax,(%esp)
  8004ea:	ff d7                	call   *%edi
  8004ec:	8b 5d cc             	mov    -0x34(%ebp),%ebx
			break;
  8004ef:	e9 05 ff ff ff       	jmp    8003f9 <vprintfmt+0x2c>
  8004f4:	89 45 cc             	mov    %eax,-0x34(%ebp)

		// error message
		case 'e':
			err = va_arg(ap, int);
  8004f7:	8b 45 14             	mov    0x14(%ebp),%eax
  8004fa:	8d 50 04             	lea    0x4(%eax),%edx
  8004fd:	89 55 14             	mov    %edx,0x14(%ebp)
  800500:	8b 00                	mov    (%eax),%eax
  800502:	89 c2                	mov    %eax,%edx
  800504:	c1 fa 1f             	sar    $0x1f,%edx
  800507:	31 d0                	xor    %edx,%eax
  800509:	29 d0                	sub    %edx,%eax
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  80050b:	83 f8 0f             	cmp    $0xf,%eax
  80050e:	7f 0b                	jg     80051b <vprintfmt+0x14e>
  800510:	8b 14 85 80 2c 80 00 	mov    0x802c80(,%eax,4),%edx
  800517:	85 d2                	test   %edx,%edx
  800519:	75 20                	jne    80053b <vprintfmt+0x16e>
				printfmt(putch, putdat, "error %d", err);
  80051b:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80051f:	c7 44 24 08 f6 29 80 	movl   $0x8029f6,0x8(%esp)
  800526:	00 
  800527:	89 74 24 04          	mov    %esi,0x4(%esp)
  80052b:	89 3c 24             	mov    %edi,(%esp)
  80052e:	e8 31 03 00 00       	call   800864 <printfmt>
  800533:	8b 5d cc             	mov    -0x34(%ebp),%ebx
		// error message
		case 'e':
			err = va_arg(ap, int);
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800536:	e9 be fe ff ff       	jmp    8003f9 <vprintfmt+0x2c>
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  80053b:	89 54 24 0c          	mov    %edx,0xc(%esp)
  80053f:	c7 44 24 08 1e 2e 80 	movl   $0x802e1e,0x8(%esp)
  800546:	00 
  800547:	89 74 24 04          	mov    %esi,0x4(%esp)
  80054b:	89 3c 24             	mov    %edi,(%esp)
  80054e:	e8 11 03 00 00       	call   800864 <printfmt>
  800553:	8b 5d cc             	mov    -0x34(%ebp),%ebx
  800556:	e9 9e fe ff ff       	jmp    8003f9 <vprintfmt+0x2c>
  80055b:	89 45 cc             	mov    %eax,-0x34(%ebp)
  80055e:	89 c3                	mov    %eax,%ebx
  800560:	8b 4d d0             	mov    -0x30(%ebp),%ecx
  800563:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800566:	89 45 c4             	mov    %eax,-0x3c(%ebp)
			break;

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800569:	8b 45 14             	mov    0x14(%ebp),%eax
  80056c:	8d 50 04             	lea    0x4(%eax),%edx
  80056f:	89 55 14             	mov    %edx,0x14(%ebp)
  800572:	8b 00                	mov    (%eax),%eax
  800574:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800577:	85 c0                	test   %eax,%eax
  800579:	75 07                	jne    800582 <vprintfmt+0x1b5>
  80057b:	c7 45 e0 ff 29 80 00 	movl   $0x8029ff,-0x20(%ebp)
				p = "(null)";
			if (width > 0 && padc != '-')
  800582:	83 7d c4 00          	cmpl   $0x0,-0x3c(%ebp)
  800586:	7e 06                	jle    80058e <vprintfmt+0x1c1>
  800588:	80 7d d4 2d          	cmpb   $0x2d,-0x2c(%ebp)
  80058c:	75 13                	jne    8005a1 <vprintfmt+0x1d4>
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  80058e:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800591:	0f be 02             	movsbl (%edx),%eax
  800594:	85 c0                	test   %eax,%eax
  800596:	0f 85 99 00 00 00    	jne    800635 <vprintfmt+0x268>
  80059c:	e9 86 00 00 00       	jmp    800627 <vprintfmt+0x25a>
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  8005a1:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8005a5:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  8005a8:	89 0c 24             	mov    %ecx,(%esp)
  8005ab:	e8 fb 02 00 00       	call   8008ab <strnlen>
  8005b0:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  8005b3:	29 c2                	sub    %eax,%edx
  8005b5:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  8005b8:	85 d2                	test   %edx,%edx
  8005ba:	7e d2                	jle    80058e <vprintfmt+0x1c1>
					putch(padc, putdat);
  8005bc:	0f be 4d d4          	movsbl -0x2c(%ebp),%ecx
  8005c0:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  8005c3:	89 5d c4             	mov    %ebx,-0x3c(%ebp)
  8005c6:	89 d3                	mov    %edx,%ebx
  8005c8:	89 74 24 04          	mov    %esi,0x4(%esp)
  8005cc:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8005cf:	89 04 24             	mov    %eax,(%esp)
  8005d2:	ff d7                	call   *%edi
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  8005d4:	83 eb 01             	sub    $0x1,%ebx
  8005d7:	85 db                	test   %ebx,%ebx
  8005d9:	7f ed                	jg     8005c8 <vprintfmt+0x1fb>
  8005db:	8b 5d c4             	mov    -0x3c(%ebp),%ebx
  8005de:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  8005e5:	eb a7                	jmp    80058e <vprintfmt+0x1c1>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
  8005e7:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  8005eb:	74 18                	je     800605 <vprintfmt+0x238>
  8005ed:	8d 50 e0             	lea    -0x20(%eax),%edx
  8005f0:	83 fa 5e             	cmp    $0x5e,%edx
  8005f3:	76 10                	jbe    800605 <vprintfmt+0x238>
					putch('?', putdat);
  8005f5:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8005f9:	c7 04 24 3f 00 00 00 	movl   $0x3f,(%esp)
  800600:	ff 55 e0             	call   *-0x20(%ebp)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
  800603:	eb 0a                	jmp    80060f <vprintfmt+0x242>
					putch('?', putdat);
				else
					putch(ch, putdat);
  800605:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800609:	89 04 24             	mov    %eax,(%esp)
  80060c:	ff 55 e0             	call   *-0x20(%ebp)
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  80060f:	83 6d e4 01          	subl   $0x1,-0x1c(%ebp)
  800613:	0f be 03             	movsbl (%ebx),%eax
  800616:	85 c0                	test   %eax,%eax
  800618:	74 05                	je     80061f <vprintfmt+0x252>
  80061a:	83 c3 01             	add    $0x1,%ebx
  80061d:	eb 29                	jmp    800648 <vprintfmt+0x27b>
  80061f:	89 fe                	mov    %edi,%esi
  800621:	8b 7d e0             	mov    -0x20(%ebp),%edi
  800624:	8b 5d d0             	mov    -0x30(%ebp),%ebx
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800627:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80062b:	7f 2e                	jg     80065b <vprintfmt+0x28e>
  80062d:	8b 5d cc             	mov    -0x34(%ebp),%ebx
  800630:	e9 c4 fd ff ff       	jmp    8003f9 <vprintfmt+0x2c>
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800635:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800638:	83 c2 01             	add    $0x1,%edx
  80063b:	89 7d e0             	mov    %edi,-0x20(%ebp)
  80063e:	89 f7                	mov    %esi,%edi
  800640:	8b 75 d0             	mov    -0x30(%ebp),%esi
  800643:	89 5d d0             	mov    %ebx,-0x30(%ebp)
  800646:	89 d3                	mov    %edx,%ebx
  800648:	85 f6                	test   %esi,%esi
  80064a:	78 9b                	js     8005e7 <vprintfmt+0x21a>
  80064c:	83 ee 01             	sub    $0x1,%esi
  80064f:	79 96                	jns    8005e7 <vprintfmt+0x21a>
  800651:	89 fe                	mov    %edi,%esi
  800653:	8b 7d e0             	mov    -0x20(%ebp),%edi
  800656:	8b 5d d0             	mov    -0x30(%ebp),%ebx
  800659:	eb cc                	jmp    800627 <vprintfmt+0x25a>
  80065b:	89 5d d8             	mov    %ebx,-0x28(%ebp)
  80065e:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
				putch(' ', putdat);
  800661:	89 74 24 04          	mov    %esi,0x4(%esp)
  800665:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  80066c:	ff d7                	call   *%edi
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  80066e:	83 eb 01             	sub    $0x1,%ebx
  800671:	85 db                	test   %ebx,%ebx
  800673:	7f ec                	jg     800661 <vprintfmt+0x294>
  800675:	8b 5d d8             	mov    -0x28(%ebp),%ebx
  800678:	e9 7c fd ff ff       	jmp    8003f9 <vprintfmt+0x2c>
  80067d:	89 45 cc             	mov    %eax,-0x34(%ebp)
// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
	if (lflag >= 2)
  800680:	83 f9 01             	cmp    $0x1,%ecx
  800683:	7e 16                	jle    80069b <vprintfmt+0x2ce>
		return va_arg(*ap, long long);
  800685:	8b 45 14             	mov    0x14(%ebp),%eax
  800688:	8d 50 08             	lea    0x8(%eax),%edx
  80068b:	89 55 14             	mov    %edx,0x14(%ebp)
  80068e:	8b 10                	mov    (%eax),%edx
  800690:	8b 48 04             	mov    0x4(%eax),%ecx
  800693:	89 55 d8             	mov    %edx,-0x28(%ebp)
  800696:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  800699:	eb 32                	jmp    8006cd <vprintfmt+0x300>
	else if (lflag)
  80069b:	85 c9                	test   %ecx,%ecx
  80069d:	74 18                	je     8006b7 <vprintfmt+0x2ea>
		return va_arg(*ap, long);
  80069f:	8b 45 14             	mov    0x14(%ebp),%eax
  8006a2:	8d 50 04             	lea    0x4(%eax),%edx
  8006a5:	89 55 14             	mov    %edx,0x14(%ebp)
  8006a8:	8b 00                	mov    (%eax),%eax
  8006aa:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8006ad:	89 c1                	mov    %eax,%ecx
  8006af:	c1 f9 1f             	sar    $0x1f,%ecx
  8006b2:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  8006b5:	eb 16                	jmp    8006cd <vprintfmt+0x300>
	else
		return va_arg(*ap, int);
  8006b7:	8b 45 14             	mov    0x14(%ebp),%eax
  8006ba:	8d 50 04             	lea    0x4(%eax),%edx
  8006bd:	89 55 14             	mov    %edx,0x14(%ebp)
  8006c0:	8b 00                	mov    (%eax),%eax
  8006c2:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8006c5:	89 c2                	mov    %eax,%edx
  8006c7:	c1 fa 1f             	sar    $0x1f,%edx
  8006ca:	89 55 dc             	mov    %edx,-0x24(%ebp)
				putch(' ', putdat);
			break;

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  8006cd:	8b 4d d8             	mov    -0x28(%ebp),%ecx
  8006d0:	8b 5d dc             	mov    -0x24(%ebp),%ebx
  8006d3:	b8 0a 00 00 00       	mov    $0xa,%eax
			if ((long long) num < 0) {
  8006d8:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8006dc:	0f 89 9b 00 00 00    	jns    80077d <vprintfmt+0x3b0>
				putch('-', putdat);
  8006e2:	89 74 24 04          	mov    %esi,0x4(%esp)
  8006e6:	c7 04 24 2d 00 00 00 	movl   $0x2d,(%esp)
  8006ed:	ff d7                	call   *%edi
				num = -(long long) num;
  8006ef:	8b 4d d8             	mov    -0x28(%ebp),%ecx
  8006f2:	8b 5d dc             	mov    -0x24(%ebp),%ebx
  8006f5:	f7 d9                	neg    %ecx
  8006f7:	83 d3 00             	adc    $0x0,%ebx
  8006fa:	f7 db                	neg    %ebx
  8006fc:	b8 0a 00 00 00       	mov    $0xa,%eax
  800701:	eb 7a                	jmp    80077d <vprintfmt+0x3b0>
  800703:	89 45 cc             	mov    %eax,-0x34(%ebp)
			base = 10;
			goto number;

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800706:	89 ca                	mov    %ecx,%edx
  800708:	8d 45 14             	lea    0x14(%ebp),%eax
  80070b:	e8 66 fc ff ff       	call   800376 <getuint>
  800710:	89 c1                	mov    %eax,%ecx
  800712:	89 d3                	mov    %edx,%ebx
  800714:	b8 0a 00 00 00       	mov    $0xa,%eax
			base = 10;
			goto number;
  800719:	eb 62                	jmp    80077d <vprintfmt+0x3b0>
  80071b:	89 45 cc             	mov    %eax,-0x34(%ebp)
		case 'o':
			// Replace this with your code.
			// putch('X', putdat);
			// putch('X', putdat);
			// putch('X', putdat);
			num = getuint(&ap, lflag);
  80071e:	89 ca                	mov    %ecx,%edx
  800720:	8d 45 14             	lea    0x14(%ebp),%eax
  800723:	e8 4e fc ff ff       	call   800376 <getuint>
  800728:	89 c1                	mov    %eax,%ecx
  80072a:	89 d3                	mov    %edx,%ebx
  80072c:	b8 08 00 00 00       	mov    $0x8,%eax
			base = 8;
			goto number;
  800731:	eb 4a                	jmp    80077d <vprintfmt+0x3b0>
  800733:	89 45 cc             	mov    %eax,-0x34(%ebp)
			break;

		// pointer
		case 'p':
			putch('0', putdat);
  800736:	89 74 24 04          	mov    %esi,0x4(%esp)
  80073a:	c7 04 24 30 00 00 00 	movl   $0x30,(%esp)
  800741:	ff d7                	call   *%edi
			putch('x', putdat);
  800743:	89 74 24 04          	mov    %esi,0x4(%esp)
  800747:	c7 04 24 78 00 00 00 	movl   $0x78,(%esp)
  80074e:	ff d7                	call   *%edi
			num = (unsigned long long)
  800750:	8b 45 14             	mov    0x14(%ebp),%eax
  800753:	8d 50 04             	lea    0x4(%eax),%edx
  800756:	89 55 14             	mov    %edx,0x14(%ebp)
  800759:	8b 08                	mov    (%eax),%ecx
  80075b:	bb 00 00 00 00       	mov    $0x0,%ebx
  800760:	b8 10 00 00 00       	mov    $0x10,%eax
				(uintptr_t) va_arg(ap, void *);
			base = 16;
			goto number;
  800765:	eb 16                	jmp    80077d <vprintfmt+0x3b0>
  800767:	89 45 cc             	mov    %eax,-0x34(%ebp)

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  80076a:	89 ca                	mov    %ecx,%edx
  80076c:	8d 45 14             	lea    0x14(%ebp),%eax
  80076f:	e8 02 fc ff ff       	call   800376 <getuint>
  800774:	89 c1                	mov    %eax,%ecx
  800776:	89 d3                	mov    %edx,%ebx
  800778:	b8 10 00 00 00       	mov    $0x10,%eax
			base = 16;
		number:
			printnum(putch, putdat, num, base, width, padc);
  80077d:	0f be 55 d4          	movsbl -0x2c(%ebp),%edx
  800781:	89 54 24 10          	mov    %edx,0x10(%esp)
  800785:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  800788:	89 54 24 0c          	mov    %edx,0xc(%esp)
  80078c:	89 44 24 08          	mov    %eax,0x8(%esp)
  800790:	89 0c 24             	mov    %ecx,(%esp)
  800793:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  800797:	89 f2                	mov    %esi,%edx
  800799:	89 f8                	mov    %edi,%eax
  80079b:	e8 e0 fa ff ff       	call   800280 <printnum>
  8007a0:	8b 5d cc             	mov    -0x34(%ebp),%ebx
			break;
  8007a3:	e9 51 fc ff ff       	jmp    8003f9 <vprintfmt+0x2c>
  8007a8:	89 45 cc             	mov    %eax,-0x34(%ebp)
  8007ab:	8b 55 e0             	mov    -0x20(%ebp),%edx

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  8007ae:	89 74 24 04          	mov    %esi,0x4(%esp)
  8007b2:	89 14 24             	mov    %edx,(%esp)
  8007b5:	ff d7                	call   *%edi
  8007b7:	8b 5d cc             	mov    -0x34(%ebp),%ebx
			break;
  8007ba:	e9 3a fc ff ff       	jmp    8003f9 <vprintfmt+0x2c>
			
		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  8007bf:	89 74 24 04          	mov    %esi,0x4(%esp)
  8007c3:	c7 04 24 25 00 00 00 	movl   $0x25,(%esp)
  8007ca:	ff d7                	call   *%edi
			for (fmt--; fmt[-1] != '%'; fmt--)
  8007cc:	8d 43 ff             	lea    -0x1(%ebx),%eax
  8007cf:	80 38 25             	cmpb   $0x25,(%eax)
  8007d2:	0f 84 21 fc ff ff    	je     8003f9 <vprintfmt+0x2c>
  8007d8:	89 c3                	mov    %eax,%ebx
  8007da:	eb f0                	jmp    8007cc <vprintfmt+0x3ff>
				/* do nothing */;
			break;
		}
	}
}
  8007dc:	83 c4 5c             	add    $0x5c,%esp
  8007df:	5b                   	pop    %ebx
  8007e0:	5e                   	pop    %esi
  8007e1:	5f                   	pop    %edi
  8007e2:	5d                   	pop    %ebp
  8007e3:	c3                   	ret    

008007e4 <vsnprintf>:
		*b->buf++ = ch;
}

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  8007e4:	55                   	push   %ebp
  8007e5:	89 e5                	mov    %esp,%ebp
  8007e7:	83 ec 28             	sub    $0x28,%esp
  8007ea:	8b 45 08             	mov    0x8(%ebp),%eax
  8007ed:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};

	if (buf == NULL || n < 1)
  8007f0:	85 c0                	test   %eax,%eax
  8007f2:	74 04                	je     8007f8 <vsnprintf+0x14>
  8007f4:	85 d2                	test   %edx,%edx
  8007f6:	7f 07                	jg     8007ff <vsnprintf+0x1b>
  8007f8:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8007fd:	eb 3b                	jmp    80083a <vsnprintf+0x56>
}

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
	struct sprintbuf b = {buf, buf+n-1, 0};
  8007ff:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800802:	8d 44 10 ff          	lea    -0x1(%eax,%edx,1),%eax
  800806:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800809:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800810:	8b 45 14             	mov    0x14(%ebp),%eax
  800813:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800817:	8b 45 10             	mov    0x10(%ebp),%eax
  80081a:	89 44 24 08          	mov    %eax,0x8(%esp)
  80081e:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800821:	89 44 24 04          	mov    %eax,0x4(%esp)
  800825:	c7 04 24 b0 03 80 00 	movl   $0x8003b0,(%esp)
  80082c:	e8 9c fb ff ff       	call   8003cd <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  800831:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800834:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800837:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  80083a:	c9                   	leave  
  80083b:	c3                   	ret    

0080083c <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  80083c:	55                   	push   %ebp
  80083d:	89 e5                	mov    %esp,%ebp
  80083f:	83 ec 18             	sub    $0x18,%esp

	return b.cnt;
}

int
snprintf(char *buf, int n, const char *fmt, ...)
  800842:	8d 45 14             	lea    0x14(%ebp),%eax
{
	va_list ap;
	int rc;

	va_start(ap, fmt);
	rc = vsnprintf(buf, n, fmt, ap);
  800845:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800849:	8b 45 10             	mov    0x10(%ebp),%eax
  80084c:	89 44 24 08          	mov    %eax,0x8(%esp)
  800850:	8b 45 0c             	mov    0xc(%ebp),%eax
  800853:	89 44 24 04          	mov    %eax,0x4(%esp)
  800857:	8b 45 08             	mov    0x8(%ebp),%eax
  80085a:	89 04 24             	mov    %eax,(%esp)
  80085d:	e8 82 ff ff ff       	call   8007e4 <vsnprintf>
	va_end(ap);

	return rc;
}
  800862:	c9                   	leave  
  800863:	c3                   	ret    

00800864 <printfmt>:
	}
}

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800864:	55                   	push   %ebp
  800865:	89 e5                	mov    %esp,%ebp
  800867:	83 ec 18             	sub    $0x18,%esp
		}
	}
}

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
  80086a:	8d 45 14             	lea    0x14(%ebp),%eax
{
	va_list ap;

	va_start(ap, fmt);
	vprintfmt(putch, putdat, fmt, ap);
  80086d:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800871:	8b 45 10             	mov    0x10(%ebp),%eax
  800874:	89 44 24 08          	mov    %eax,0x8(%esp)
  800878:	8b 45 0c             	mov    0xc(%ebp),%eax
  80087b:	89 44 24 04          	mov    %eax,0x4(%esp)
  80087f:	8b 45 08             	mov    0x8(%ebp),%eax
  800882:	89 04 24             	mov    %eax,(%esp)
  800885:	e8 43 fb ff ff       	call   8003cd <vprintfmt>
	va_end(ap);
}
  80088a:	c9                   	leave  
  80088b:	c3                   	ret    
  80088c:	00 00                	add    %al,(%eax)
	...

00800890 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800890:	55                   	push   %ebp
  800891:	89 e5                	mov    %esp,%ebp
  800893:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  800896:	b8 00 00 00 00       	mov    $0x0,%eax
  80089b:	80 3a 00             	cmpb   $0x0,(%edx)
  80089e:	74 09                	je     8008a9 <strlen+0x19>
		n++;
  8008a0:	83 c0 01             	add    $0x1,%eax
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  8008a3:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  8008a7:	75 f7                	jne    8008a0 <strlen+0x10>
		n++;
	return n;
}
  8008a9:	5d                   	pop    %ebp
  8008aa:	c3                   	ret    

008008ab <strnlen>:

int
strnlen(const char *s, size_t size)
{
  8008ab:	55                   	push   %ebp
  8008ac:	89 e5                	mov    %esp,%ebp
  8008ae:	53                   	push   %ebx
  8008af:	8b 5d 08             	mov    0x8(%ebp),%ebx
  8008b2:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8008b5:	85 c9                	test   %ecx,%ecx
  8008b7:	74 19                	je     8008d2 <strnlen+0x27>
  8008b9:	80 3b 00             	cmpb   $0x0,(%ebx)
  8008bc:	74 14                	je     8008d2 <strnlen+0x27>
  8008be:	b8 00 00 00 00       	mov    $0x0,%eax
		n++;
  8008c3:	83 c0 01             	add    $0x1,%eax
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8008c6:	39 c8                	cmp    %ecx,%eax
  8008c8:	74 0d                	je     8008d7 <strnlen+0x2c>
  8008ca:	80 3c 03 00          	cmpb   $0x0,(%ebx,%eax,1)
  8008ce:	75 f3                	jne    8008c3 <strnlen+0x18>
  8008d0:	eb 05                	jmp    8008d7 <strnlen+0x2c>
  8008d2:	b8 00 00 00 00       	mov    $0x0,%eax
		n++;
	return n;
}
  8008d7:	5b                   	pop    %ebx
  8008d8:	5d                   	pop    %ebp
  8008d9:	c3                   	ret    

008008da <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  8008da:	55                   	push   %ebp
  8008db:	89 e5                	mov    %esp,%ebp
  8008dd:	53                   	push   %ebx
  8008de:	8b 45 08             	mov    0x8(%ebp),%eax
  8008e1:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  8008e4:	ba 00 00 00 00       	mov    $0x0,%edx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  8008e9:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
  8008ed:	88 0c 10             	mov    %cl,(%eax,%edx,1)
  8008f0:	83 c2 01             	add    $0x1,%edx
  8008f3:	84 c9                	test   %cl,%cl
  8008f5:	75 f2                	jne    8008e9 <strcpy+0xf>
		/* do nothing */;
	return ret;
}
  8008f7:	5b                   	pop    %ebx
  8008f8:	5d                   	pop    %ebp
  8008f9:	c3                   	ret    

008008fa <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  8008fa:	55                   	push   %ebp
  8008fb:	89 e5                	mov    %esp,%ebp
  8008fd:	56                   	push   %esi
  8008fe:	53                   	push   %ebx
  8008ff:	8b 45 08             	mov    0x8(%ebp),%eax
  800902:	8b 55 0c             	mov    0xc(%ebp),%edx
  800905:	8b 75 10             	mov    0x10(%ebp),%esi
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800908:	85 f6                	test   %esi,%esi
  80090a:	74 18                	je     800924 <strncpy+0x2a>
  80090c:	b9 00 00 00 00       	mov    $0x0,%ecx
		*dst++ = *src;
  800911:	0f b6 1a             	movzbl (%edx),%ebx
  800914:	88 1c 08             	mov    %bl,(%eax,%ecx,1)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  800917:	80 3a 01             	cmpb   $0x1,(%edx)
  80091a:	83 da ff             	sbb    $0xffffffff,%edx
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  80091d:	83 c1 01             	add    $0x1,%ecx
  800920:	39 ce                	cmp    %ecx,%esi
  800922:	77 ed                	ja     800911 <strncpy+0x17>
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
}
  800924:	5b                   	pop    %ebx
  800925:	5e                   	pop    %esi
  800926:	5d                   	pop    %ebp
  800927:	c3                   	ret    

00800928 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800928:	55                   	push   %ebp
  800929:	89 e5                	mov    %esp,%ebp
  80092b:	56                   	push   %esi
  80092c:	53                   	push   %ebx
  80092d:	8b 75 08             	mov    0x8(%ebp),%esi
  800930:	8b 55 0c             	mov    0xc(%ebp),%edx
  800933:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  800936:	89 f0                	mov    %esi,%eax
  800938:	85 c9                	test   %ecx,%ecx
  80093a:	74 27                	je     800963 <strlcpy+0x3b>
		while (--size > 0 && *src != '\0')
  80093c:	83 e9 01             	sub    $0x1,%ecx
  80093f:	74 1d                	je     80095e <strlcpy+0x36>
  800941:	0f b6 1a             	movzbl (%edx),%ebx
  800944:	84 db                	test   %bl,%bl
  800946:	74 16                	je     80095e <strlcpy+0x36>
			*dst++ = *src++;
  800948:	88 18                	mov    %bl,(%eax)
  80094a:	83 c0 01             	add    $0x1,%eax
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  80094d:	83 e9 01             	sub    $0x1,%ecx
  800950:	74 0e                	je     800960 <strlcpy+0x38>
			*dst++ = *src++;
  800952:	83 c2 01             	add    $0x1,%edx
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800955:	0f b6 1a             	movzbl (%edx),%ebx
  800958:	84 db                	test   %bl,%bl
  80095a:	75 ec                	jne    800948 <strlcpy+0x20>
  80095c:	eb 02                	jmp    800960 <strlcpy+0x38>
  80095e:	89 f0                	mov    %esi,%eax
			*dst++ = *src++;
		*dst = '\0';
  800960:	c6 00 00             	movb   $0x0,(%eax)
  800963:	29 f0                	sub    %esi,%eax
	}
	return dst - dst_in;
}
  800965:	5b                   	pop    %ebx
  800966:	5e                   	pop    %esi
  800967:	5d                   	pop    %ebp
  800968:	c3                   	ret    

00800969 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800969:	55                   	push   %ebp
  80096a:	89 e5                	mov    %esp,%ebp
  80096c:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80096f:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  800972:	0f b6 01             	movzbl (%ecx),%eax
  800975:	84 c0                	test   %al,%al
  800977:	74 15                	je     80098e <strcmp+0x25>
  800979:	3a 02                	cmp    (%edx),%al
  80097b:	75 11                	jne    80098e <strcmp+0x25>
		p++, q++;
  80097d:	83 c1 01             	add    $0x1,%ecx
  800980:	83 c2 01             	add    $0x1,%edx
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800983:	0f b6 01             	movzbl (%ecx),%eax
  800986:	84 c0                	test   %al,%al
  800988:	74 04                	je     80098e <strcmp+0x25>
  80098a:	3a 02                	cmp    (%edx),%al
  80098c:	74 ef                	je     80097d <strcmp+0x14>
  80098e:	0f b6 c0             	movzbl %al,%eax
  800991:	0f b6 12             	movzbl (%edx),%edx
  800994:	29 d0                	sub    %edx,%eax
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
}
  800996:	5d                   	pop    %ebp
  800997:	c3                   	ret    

00800998 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800998:	55                   	push   %ebp
  800999:	89 e5                	mov    %esp,%ebp
  80099b:	53                   	push   %ebx
  80099c:	8b 55 08             	mov    0x8(%ebp),%edx
  80099f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8009a2:	8b 45 10             	mov    0x10(%ebp),%eax
	while (n > 0 && *p && *p == *q)
  8009a5:	85 c0                	test   %eax,%eax
  8009a7:	74 23                	je     8009cc <strncmp+0x34>
  8009a9:	0f b6 1a             	movzbl (%edx),%ebx
  8009ac:	84 db                	test   %bl,%bl
  8009ae:	74 24                	je     8009d4 <strncmp+0x3c>
  8009b0:	3a 19                	cmp    (%ecx),%bl
  8009b2:	75 20                	jne    8009d4 <strncmp+0x3c>
  8009b4:	83 e8 01             	sub    $0x1,%eax
  8009b7:	74 13                	je     8009cc <strncmp+0x34>
		n--, p++, q++;
  8009b9:	83 c2 01             	add    $0x1,%edx
  8009bc:	83 c1 01             	add    $0x1,%ecx
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  8009bf:	0f b6 1a             	movzbl (%edx),%ebx
  8009c2:	84 db                	test   %bl,%bl
  8009c4:	74 0e                	je     8009d4 <strncmp+0x3c>
  8009c6:	3a 19                	cmp    (%ecx),%bl
  8009c8:	74 ea                	je     8009b4 <strncmp+0x1c>
  8009ca:	eb 08                	jmp    8009d4 <strncmp+0x3c>
  8009cc:	b8 00 00 00 00       	mov    $0x0,%eax
		n--, p++, q++;
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
}
  8009d1:	5b                   	pop    %ebx
  8009d2:	5d                   	pop    %ebp
  8009d3:	c3                   	ret    
	while (n > 0 && *p && *p == *q)
		n--, p++, q++;
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  8009d4:	0f b6 02             	movzbl (%edx),%eax
  8009d7:	0f b6 11             	movzbl (%ecx),%edx
  8009da:	29 d0                	sub    %edx,%eax
  8009dc:	eb f3                	jmp    8009d1 <strncmp+0x39>

008009de <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  8009de:	55                   	push   %ebp
  8009df:	89 e5                	mov    %esp,%ebp
  8009e1:	8b 45 08             	mov    0x8(%ebp),%eax
  8009e4:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  8009e8:	0f b6 10             	movzbl (%eax),%edx
  8009eb:	84 d2                	test   %dl,%dl
  8009ed:	74 15                	je     800a04 <strchr+0x26>
		if (*s == c)
  8009ef:	38 ca                	cmp    %cl,%dl
  8009f1:	75 07                	jne    8009fa <strchr+0x1c>
  8009f3:	eb 14                	jmp    800a09 <strchr+0x2b>
  8009f5:	38 ca                	cmp    %cl,%dl
  8009f7:	90                   	nop
  8009f8:	74 0f                	je     800a09 <strchr+0x2b>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  8009fa:	83 c0 01             	add    $0x1,%eax
  8009fd:	0f b6 10             	movzbl (%eax),%edx
  800a00:	84 d2                	test   %dl,%dl
  800a02:	75 f1                	jne    8009f5 <strchr+0x17>
  800a04:	b8 00 00 00 00       	mov    $0x0,%eax
		if (*s == c)
			return (char *) s;
	return 0;
}
  800a09:	5d                   	pop    %ebp
  800a0a:	c3                   	ret    

00800a0b <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800a0b:	55                   	push   %ebp
  800a0c:	89 e5                	mov    %esp,%ebp
  800a0e:	8b 45 08             	mov    0x8(%ebp),%eax
  800a11:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800a15:	0f b6 10             	movzbl (%eax),%edx
  800a18:	84 d2                	test   %dl,%dl
  800a1a:	74 18                	je     800a34 <strfind+0x29>
		if (*s == c)
  800a1c:	38 ca                	cmp    %cl,%dl
  800a1e:	75 0a                	jne    800a2a <strfind+0x1f>
  800a20:	eb 12                	jmp    800a34 <strfind+0x29>
  800a22:	38 ca                	cmp    %cl,%dl
  800a24:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  800a28:	74 0a                	je     800a34 <strfind+0x29>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800a2a:	83 c0 01             	add    $0x1,%eax
  800a2d:	0f b6 10             	movzbl (%eax),%edx
  800a30:	84 d2                	test   %dl,%dl
  800a32:	75 ee                	jne    800a22 <strfind+0x17>
		if (*s == c)
			break;
	return (char *) s;
}
  800a34:	5d                   	pop    %ebp
  800a35:	c3                   	ret    

00800a36 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800a36:	55                   	push   %ebp
  800a37:	89 e5                	mov    %esp,%ebp
  800a39:	83 ec 0c             	sub    $0xc,%esp
  800a3c:	89 1c 24             	mov    %ebx,(%esp)
  800a3f:	89 74 24 04          	mov    %esi,0x4(%esp)
  800a43:	89 7c 24 08          	mov    %edi,0x8(%esp)
  800a47:	8b 7d 08             	mov    0x8(%ebp),%edi
  800a4a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a4d:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800a50:	85 c9                	test   %ecx,%ecx
  800a52:	74 30                	je     800a84 <memset+0x4e>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800a54:	f7 c7 03 00 00 00    	test   $0x3,%edi
  800a5a:	75 25                	jne    800a81 <memset+0x4b>
  800a5c:	f6 c1 03             	test   $0x3,%cl
  800a5f:	75 20                	jne    800a81 <memset+0x4b>
		c &= 0xFF;
  800a61:	0f b6 d0             	movzbl %al,%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800a64:	89 d3                	mov    %edx,%ebx
  800a66:	c1 e3 08             	shl    $0x8,%ebx
  800a69:	89 d6                	mov    %edx,%esi
  800a6b:	c1 e6 18             	shl    $0x18,%esi
  800a6e:	89 d0                	mov    %edx,%eax
  800a70:	c1 e0 10             	shl    $0x10,%eax
  800a73:	09 f0                	or     %esi,%eax
  800a75:	09 d0                	or     %edx,%eax
		asm volatile("cld; rep stosl\n"
  800a77:	09 d8                	or     %ebx,%eax
  800a79:	c1 e9 02             	shr    $0x2,%ecx
  800a7c:	fc                   	cld    
  800a7d:	f3 ab                	rep stos %eax,%es:(%edi)
{
	char *p;

	if (n == 0)
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800a7f:	eb 03                	jmp    800a84 <memset+0x4e>
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800a81:	fc                   	cld    
  800a82:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800a84:	89 f8                	mov    %edi,%eax
  800a86:	8b 1c 24             	mov    (%esp),%ebx
  800a89:	8b 74 24 04          	mov    0x4(%esp),%esi
  800a8d:	8b 7c 24 08          	mov    0x8(%esp),%edi
  800a91:	89 ec                	mov    %ebp,%esp
  800a93:	5d                   	pop    %ebp
  800a94:	c3                   	ret    

00800a95 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800a95:	55                   	push   %ebp
  800a96:	89 e5                	mov    %esp,%ebp
  800a98:	83 ec 08             	sub    $0x8,%esp
  800a9b:	89 34 24             	mov    %esi,(%esp)
  800a9e:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800aa2:	8b 45 08             	mov    0x8(%ebp),%eax
  800aa5:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;
	
	s = src;
  800aa8:	8b 75 0c             	mov    0xc(%ebp),%esi
	d = dst;
  800aab:	89 c7                	mov    %eax,%edi
	if (s < d && s + n > d) {
  800aad:	39 c6                	cmp    %eax,%esi
  800aaf:	73 35                	jae    800ae6 <memmove+0x51>
  800ab1:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800ab4:	39 d0                	cmp    %edx,%eax
  800ab6:	73 2e                	jae    800ae6 <memmove+0x51>
		s += n;
		d += n;
  800ab8:	01 cf                	add    %ecx,%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800aba:	f6 c2 03             	test   $0x3,%dl
  800abd:	75 1b                	jne    800ada <memmove+0x45>
  800abf:	f7 c7 03 00 00 00    	test   $0x3,%edi
  800ac5:	75 13                	jne    800ada <memmove+0x45>
  800ac7:	f6 c1 03             	test   $0x3,%cl
  800aca:	75 0e                	jne    800ada <memmove+0x45>
			asm volatile("std; rep movsl\n"
  800acc:	83 ef 04             	sub    $0x4,%edi
  800acf:	8d 72 fc             	lea    -0x4(%edx),%esi
  800ad2:	c1 e9 02             	shr    $0x2,%ecx
  800ad5:	fd                   	std    
  800ad6:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800ad8:	eb 09                	jmp    800ae3 <memmove+0x4e>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  800ada:	83 ef 01             	sub    $0x1,%edi
  800add:	8d 72 ff             	lea    -0x1(%edx),%esi
  800ae0:	fd                   	std    
  800ae1:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800ae3:	fc                   	cld    
	const char *s;
	char *d;
	
	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800ae4:	eb 20                	jmp    800b06 <memmove+0x71>
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800ae6:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800aec:	75 15                	jne    800b03 <memmove+0x6e>
  800aee:	f7 c7 03 00 00 00    	test   $0x3,%edi
  800af4:	75 0d                	jne    800b03 <memmove+0x6e>
  800af6:	f6 c1 03             	test   $0x3,%cl
  800af9:	75 08                	jne    800b03 <memmove+0x6e>
			asm volatile("cld; rep movsl\n"
  800afb:	c1 e9 02             	shr    $0x2,%ecx
  800afe:	fc                   	cld    
  800aff:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800b01:	eb 03                	jmp    800b06 <memmove+0x71>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  800b03:	fc                   	cld    
  800b04:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800b06:	8b 34 24             	mov    (%esp),%esi
  800b09:	8b 7c 24 04          	mov    0x4(%esp),%edi
  800b0d:	89 ec                	mov    %ebp,%esp
  800b0f:	5d                   	pop    %ebp
  800b10:	c3                   	ret    

00800b11 <memcpy>:

/* sigh - gcc emits references to this for structure assignments! */
/* it is *not* prototyped in inc/string.h - do not use directly. */
void *
memcpy(void *dst, void *src, size_t n)
{
  800b11:	55                   	push   %ebp
  800b12:	89 e5                	mov    %esp,%ebp
  800b14:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  800b17:	8b 45 10             	mov    0x10(%ebp),%eax
  800b1a:	89 44 24 08          	mov    %eax,0x8(%esp)
  800b1e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b21:	89 44 24 04          	mov    %eax,0x4(%esp)
  800b25:	8b 45 08             	mov    0x8(%ebp),%eax
  800b28:	89 04 24             	mov    %eax,(%esp)
  800b2b:	e8 65 ff ff ff       	call   800a95 <memmove>
}
  800b30:	c9                   	leave  
  800b31:	c3                   	ret    

00800b32 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800b32:	55                   	push   %ebp
  800b33:	89 e5                	mov    %esp,%ebp
  800b35:	57                   	push   %edi
  800b36:	56                   	push   %esi
  800b37:	53                   	push   %ebx
  800b38:	8b 75 08             	mov    0x8(%ebp),%esi
  800b3b:	8b 7d 0c             	mov    0xc(%ebp),%edi
  800b3e:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800b41:	85 c9                	test   %ecx,%ecx
  800b43:	74 36                	je     800b7b <memcmp+0x49>
		if (*s1 != *s2)
  800b45:	0f b6 06             	movzbl (%esi),%eax
  800b48:	0f b6 1f             	movzbl (%edi),%ebx
  800b4b:	38 d8                	cmp    %bl,%al
  800b4d:	74 20                	je     800b6f <memcmp+0x3d>
  800b4f:	eb 14                	jmp    800b65 <memcmp+0x33>
  800b51:	0f b6 44 16 01       	movzbl 0x1(%esi,%edx,1),%eax
  800b56:	0f b6 5c 17 01       	movzbl 0x1(%edi,%edx,1),%ebx
  800b5b:	83 c2 01             	add    $0x1,%edx
  800b5e:	83 e9 01             	sub    $0x1,%ecx
  800b61:	38 d8                	cmp    %bl,%al
  800b63:	74 12                	je     800b77 <memcmp+0x45>
			return (int) *s1 - (int) *s2;
  800b65:	0f b6 c0             	movzbl %al,%eax
  800b68:	0f b6 db             	movzbl %bl,%ebx
  800b6b:	29 d8                	sub    %ebx,%eax
  800b6d:	eb 11                	jmp    800b80 <memcmp+0x4e>
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800b6f:	83 e9 01             	sub    $0x1,%ecx
  800b72:	ba 00 00 00 00       	mov    $0x0,%edx
  800b77:	85 c9                	test   %ecx,%ecx
  800b79:	75 d6                	jne    800b51 <memcmp+0x1f>
  800b7b:	b8 00 00 00 00       	mov    $0x0,%eax
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
}
  800b80:	5b                   	pop    %ebx
  800b81:	5e                   	pop    %esi
  800b82:	5f                   	pop    %edi
  800b83:	5d                   	pop    %ebp
  800b84:	c3                   	ret    

00800b85 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800b85:	55                   	push   %ebp
  800b86:	89 e5                	mov    %esp,%ebp
  800b88:	8b 45 08             	mov    0x8(%ebp),%eax
	const void *ends = (const char *) s + n;
  800b8b:	89 c2                	mov    %eax,%edx
  800b8d:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800b90:	39 d0                	cmp    %edx,%eax
  800b92:	73 15                	jae    800ba9 <memfind+0x24>
		if (*(const unsigned char *) s == (unsigned char) c)
  800b94:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
  800b98:	38 08                	cmp    %cl,(%eax)
  800b9a:	75 06                	jne    800ba2 <memfind+0x1d>
  800b9c:	eb 0b                	jmp    800ba9 <memfind+0x24>
  800b9e:	38 08                	cmp    %cl,(%eax)
  800ba0:	74 07                	je     800ba9 <memfind+0x24>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800ba2:	83 c0 01             	add    $0x1,%eax
  800ba5:	39 c2                	cmp    %eax,%edx
  800ba7:	77 f5                	ja     800b9e <memfind+0x19>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
	return (void *) s;
}
  800ba9:	5d                   	pop    %ebp
  800baa:	c3                   	ret    

00800bab <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800bab:	55                   	push   %ebp
  800bac:	89 e5                	mov    %esp,%ebp
  800bae:	57                   	push   %edi
  800baf:	56                   	push   %esi
  800bb0:	53                   	push   %ebx
  800bb1:	83 ec 04             	sub    $0x4,%esp
  800bb4:	8b 55 08             	mov    0x8(%ebp),%edx
  800bb7:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800bba:	0f b6 02             	movzbl (%edx),%eax
  800bbd:	3c 20                	cmp    $0x20,%al
  800bbf:	74 04                	je     800bc5 <strtol+0x1a>
  800bc1:	3c 09                	cmp    $0x9,%al
  800bc3:	75 0e                	jne    800bd3 <strtol+0x28>
		s++;
  800bc5:	83 c2 01             	add    $0x1,%edx
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800bc8:	0f b6 02             	movzbl (%edx),%eax
  800bcb:	3c 20                	cmp    $0x20,%al
  800bcd:	74 f6                	je     800bc5 <strtol+0x1a>
  800bcf:	3c 09                	cmp    $0x9,%al
  800bd1:	74 f2                	je     800bc5 <strtol+0x1a>
		s++;

	// plus/minus sign
	if (*s == '+')
  800bd3:	3c 2b                	cmp    $0x2b,%al
  800bd5:	75 0c                	jne    800be3 <strtol+0x38>
		s++;
  800bd7:	83 c2 01             	add    $0x1,%edx
  800bda:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800be1:	eb 15                	jmp    800bf8 <strtol+0x4d>
	else if (*s == '-')
  800be3:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800bea:	3c 2d                	cmp    $0x2d,%al
  800bec:	75 0a                	jne    800bf8 <strtol+0x4d>
		s++, neg = 1;
  800bee:	83 c2 01             	add    $0x1,%edx
  800bf1:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800bf8:	85 db                	test   %ebx,%ebx
  800bfa:	0f 94 c0             	sete   %al
  800bfd:	74 05                	je     800c04 <strtol+0x59>
  800bff:	83 fb 10             	cmp    $0x10,%ebx
  800c02:	75 18                	jne    800c1c <strtol+0x71>
  800c04:	80 3a 30             	cmpb   $0x30,(%edx)
  800c07:	75 13                	jne    800c1c <strtol+0x71>
  800c09:	80 7a 01 78          	cmpb   $0x78,0x1(%edx)
  800c0d:	8d 76 00             	lea    0x0(%esi),%esi
  800c10:	75 0a                	jne    800c1c <strtol+0x71>
		s += 2, base = 16;
  800c12:	83 c2 02             	add    $0x2,%edx
  800c15:	bb 10 00 00 00       	mov    $0x10,%ebx
		s++;
	else if (*s == '-')
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800c1a:	eb 15                	jmp    800c31 <strtol+0x86>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  800c1c:	84 c0                	test   %al,%al
  800c1e:	66 90                	xchg   %ax,%ax
  800c20:	74 0f                	je     800c31 <strtol+0x86>
  800c22:	bb 0a 00 00 00       	mov    $0xa,%ebx
  800c27:	80 3a 30             	cmpb   $0x30,(%edx)
  800c2a:	75 05                	jne    800c31 <strtol+0x86>
		s++, base = 8;
  800c2c:	83 c2 01             	add    $0x1,%edx
  800c2f:	b3 08                	mov    $0x8,%bl
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  800c31:	b8 00 00 00 00       	mov    $0x0,%eax
  800c36:	89 de                	mov    %ebx,%esi

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  800c38:	0f b6 0a             	movzbl (%edx),%ecx
  800c3b:	89 cf                	mov    %ecx,%edi
  800c3d:	8d 59 d0             	lea    -0x30(%ecx),%ebx
  800c40:	80 fb 09             	cmp    $0x9,%bl
  800c43:	77 08                	ja     800c4d <strtol+0xa2>
			dig = *s - '0';
  800c45:	0f be c9             	movsbl %cl,%ecx
  800c48:	83 e9 30             	sub    $0x30,%ecx
  800c4b:	eb 1e                	jmp    800c6b <strtol+0xc0>
		else if (*s >= 'a' && *s <= 'z')
  800c4d:	8d 5f 9f             	lea    -0x61(%edi),%ebx
  800c50:	80 fb 19             	cmp    $0x19,%bl
  800c53:	77 08                	ja     800c5d <strtol+0xb2>
			dig = *s - 'a' + 10;
  800c55:	0f be c9             	movsbl %cl,%ecx
  800c58:	83 e9 57             	sub    $0x57,%ecx
  800c5b:	eb 0e                	jmp    800c6b <strtol+0xc0>
		else if (*s >= 'A' && *s <= 'Z')
  800c5d:	8d 5f bf             	lea    -0x41(%edi),%ebx
  800c60:	80 fb 19             	cmp    $0x19,%bl
  800c63:	77 15                	ja     800c7a <strtol+0xcf>
			dig = *s - 'A' + 10;
  800c65:	0f be c9             	movsbl %cl,%ecx
  800c68:	83 e9 37             	sub    $0x37,%ecx
		else
			break;
		if (dig >= base)
  800c6b:	39 f1                	cmp    %esi,%ecx
  800c6d:	7d 0b                	jge    800c7a <strtol+0xcf>
			break;
		s++, val = (val * base) + dig;
  800c6f:	83 c2 01             	add    $0x1,%edx
  800c72:	0f af c6             	imul   %esi,%eax
  800c75:	8d 04 01             	lea    (%ecx,%eax,1),%eax
		// we don't properly detect overflow!
	}
  800c78:	eb be                	jmp    800c38 <strtol+0x8d>
  800c7a:	89 c1                	mov    %eax,%ecx

	if (endptr)
  800c7c:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800c80:	74 05                	je     800c87 <strtol+0xdc>
		*endptr = (char *) s;
  800c82:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800c85:	89 13                	mov    %edx,(%ebx)
	return (neg ? -val : val);
  800c87:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  800c8b:	74 04                	je     800c91 <strtol+0xe6>
  800c8d:	89 c8                	mov    %ecx,%eax
  800c8f:	f7 d8                	neg    %eax
}
  800c91:	83 c4 04             	add    $0x4,%esp
  800c94:	5b                   	pop    %ebx
  800c95:	5e                   	pop    %esi
  800c96:	5f                   	pop    %edi
  800c97:	5d                   	pop    %ebp
  800c98:	c3                   	ret    
  800c99:	00 00                	add    %al,(%eax)
	...

00800c9c <sys_cgetc>:
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}

int
sys_cgetc(void)
{
  800c9c:	55                   	push   %ebp
  800c9d:	89 e5                	mov    %esp,%ebp
  800c9f:	83 ec 0c             	sub    $0xc,%esp
  800ca2:	89 1c 24             	mov    %ebx,(%esp)
  800ca5:	89 74 24 04          	mov    %esi,0x4(%esp)
  800ca9:	89 7c 24 08          	mov    %edi,0x8(%esp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800cad:	ba 00 00 00 00       	mov    $0x0,%edx
  800cb2:	b8 01 00 00 00       	mov    $0x1,%eax
  800cb7:	89 d1                	mov    %edx,%ecx
  800cb9:	89 d3                	mov    %edx,%ebx
  800cbb:	89 d7                	mov    %edx,%edi
  800cbd:	89 d6                	mov    %edx,%esi
  800cbf:	cd 30                	int    $0x30

int
sys_cgetc(void)
{
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800cc1:	8b 1c 24             	mov    (%esp),%ebx
  800cc4:	8b 74 24 04          	mov    0x4(%esp),%esi
  800cc8:	8b 7c 24 08          	mov    0x8(%esp),%edi
  800ccc:	89 ec                	mov    %ebp,%esp
  800cce:	5d                   	pop    %ebp
  800ccf:	c3                   	ret    

00800cd0 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800cd0:	55                   	push   %ebp
  800cd1:	89 e5                	mov    %esp,%ebp
  800cd3:	83 ec 0c             	sub    $0xc,%esp
  800cd6:	89 1c 24             	mov    %ebx,(%esp)
  800cd9:	89 74 24 04          	mov    %esi,0x4(%esp)
  800cdd:	89 7c 24 08          	mov    %edi,0x8(%esp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800ce1:	b8 00 00 00 00       	mov    $0x0,%eax
  800ce6:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ce9:	8b 55 08             	mov    0x8(%ebp),%edx
  800cec:	89 c3                	mov    %eax,%ebx
  800cee:	89 c7                	mov    %eax,%edi
  800cf0:	89 c6                	mov    %eax,%esi
  800cf2:	cd 30                	int    $0x30

void
sys_cputs(const char *s, size_t len)
{
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800cf4:	8b 1c 24             	mov    (%esp),%ebx
  800cf7:	8b 74 24 04          	mov    0x4(%esp),%esi
  800cfb:	8b 7c 24 08          	mov    0x8(%esp),%edi
  800cff:	89 ec                	mov    %ebp,%esp
  800d01:	5d                   	pop    %ebp
  800d02:	c3                   	ret    

00800d03 <sys_page_insert>:
{
	return syscall(SYS_page_waste, 0, (uint32_t)p, (uint32_t)n, 0, 0,0);
}
int
sys_page_insert(envid_t envid, void *va, struct Page *p, int perm)
{
  800d03:	55                   	push   %ebp
  800d04:	89 e5                	mov    %esp,%ebp
  800d06:	83 ec 38             	sub    $0x38,%esp
  800d09:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800d0c:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800d0f:	89 7d fc             	mov    %edi,-0x4(%ebp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800d12:	be 00 00 00 00       	mov    $0x0,%esi
  800d17:	b8 12 00 00 00       	mov    $0x12,%eax
  800d1c:	8b 7d 14             	mov    0x14(%ebp),%edi
  800d1f:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800d22:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d25:	8b 55 08             	mov    0x8(%ebp),%edx
  800d28:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
	
	if(check && ret > 0)
  800d2a:	85 c0                	test   %eax,%eax
  800d2c:	7e 28                	jle    800d56 <sys_page_insert+0x53>
		panic("syscall %d returned %d (> 0)", num, ret);
  800d2e:	89 44 24 10          	mov    %eax,0x10(%esp)
  800d32:	c7 44 24 0c 12 00 00 	movl   $0x12,0xc(%esp)
  800d39:	00 
  800d3a:	c7 44 24 08 df 2c 80 	movl   $0x802cdf,0x8(%esp)
  800d41:	00 
  800d42:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800d49:	00 
  800d4a:	c7 04 24 fc 2c 80 00 	movl   $0x802cfc,(%esp)
  800d51:	e8 fa f3 ff ff       	call   800150 <_panic>
}
int
sys_page_insert(envid_t envid, void *va, struct Page *p, int perm)
{
	return syscall(SYS_page_insert, 1, envid, (uint32_t) va, (uint32_t)p, perm, 0);
}
  800d56:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800d59:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800d5c:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800d5f:	89 ec                	mov    %ebp,%esp
  800d61:	5d                   	pop    %ebp
  800d62:	c3                   	ret    

00800d63 <sys_page_waste>:
{
	return (int)syscall(SYS_receive_packet, 0, (uint32_t)buffer, 0,0,0,0);
}

int sys_page_waste(struct Page **p, int n)
{
  800d63:	55                   	push   %ebp
  800d64:	89 e5                	mov    %esp,%ebp
  800d66:	83 ec 0c             	sub    $0xc,%esp
  800d69:	89 1c 24             	mov    %ebx,(%esp)
  800d6c:	89 74 24 04          	mov    %esi,0x4(%esp)
  800d70:	89 7c 24 08          	mov    %edi,0x8(%esp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800d74:	bb 00 00 00 00       	mov    $0x0,%ebx
  800d79:	b8 11 00 00 00       	mov    $0x11,%eax
  800d7e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d81:	8b 55 08             	mov    0x8(%ebp),%edx
  800d84:	89 df                	mov    %ebx,%edi
  800d86:	89 de                	mov    %ebx,%esi
  800d88:	cd 30                	int    $0x30
}

int sys_page_waste(struct Page **p, int n)
{
	return syscall(SYS_page_waste, 0, (uint32_t)p, (uint32_t)n, 0, 0,0);
}
  800d8a:	8b 1c 24             	mov    (%esp),%ebx
  800d8d:	8b 74 24 04          	mov    0x4(%esp),%esi
  800d91:	8b 7c 24 08          	mov    0x8(%esp),%edi
  800d95:	89 ec                	mov    %ebp,%esp
  800d97:	5d                   	pop    %ebp
  800d98:	c3                   	ret    

00800d99 <sys_receive_packet>:
{
	return (int)syscall(SYS_transmit_packet, 1, (uint32_t)data, len, 0,0,0);
}

int sys_receive_packet(void* buffer)
{
  800d99:	55                   	push   %ebp
  800d9a:	89 e5                	mov    %esp,%ebp
  800d9c:	83 ec 0c             	sub    $0xc,%esp
  800d9f:	89 1c 24             	mov    %ebx,(%esp)
  800da2:	89 74 24 04          	mov    %esi,0x4(%esp)
  800da6:	89 7c 24 08          	mov    %edi,0x8(%esp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800daa:	b9 00 00 00 00       	mov    $0x0,%ecx
  800daf:	b8 10 00 00 00       	mov    $0x10,%eax
  800db4:	8b 55 08             	mov    0x8(%ebp),%edx
  800db7:	89 cb                	mov    %ecx,%ebx
  800db9:	89 cf                	mov    %ecx,%edi
  800dbb:	89 ce                	mov    %ecx,%esi
  800dbd:	cd 30                	int    $0x30
}

int sys_receive_packet(void* buffer)
{
	return (int)syscall(SYS_receive_packet, 0, (uint32_t)buffer, 0,0,0,0);
}
  800dbf:	8b 1c 24             	mov    (%esp),%ebx
  800dc2:	8b 74 24 04          	mov    0x4(%esp),%esi
  800dc6:	8b 7c 24 08          	mov    0x8(%esp),%edi
  800dca:	89 ec                	mov    %ebp,%esp
  800dcc:	5d                   	pop    %ebp
  800dcd:	c3                   	ret    

00800dce <sys_transmit_packet>:
{
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0,0);
}

int sys_transmit_packet(void* data, uint32_t len)
{
  800dce:	55                   	push   %ebp
  800dcf:	89 e5                	mov    %esp,%ebp
  800dd1:	83 ec 38             	sub    $0x38,%esp
  800dd4:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800dd7:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800dda:	89 7d fc             	mov    %edi,-0x4(%ebp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800ddd:	bb 00 00 00 00       	mov    $0x0,%ebx
  800de2:	b8 0f 00 00 00       	mov    $0xf,%eax
  800de7:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800dea:	8b 55 08             	mov    0x8(%ebp),%edx
  800ded:	89 df                	mov    %ebx,%edi
  800def:	89 de                	mov    %ebx,%esi
  800df1:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
	
	if(check && ret > 0)
  800df3:	85 c0                	test   %eax,%eax
  800df5:	7e 28                	jle    800e1f <sys_transmit_packet+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  800df7:	89 44 24 10          	mov    %eax,0x10(%esp)
  800dfb:	c7 44 24 0c 0f 00 00 	movl   $0xf,0xc(%esp)
  800e02:	00 
  800e03:	c7 44 24 08 df 2c 80 	movl   $0x802cdf,0x8(%esp)
  800e0a:	00 
  800e0b:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800e12:	00 
  800e13:	c7 04 24 fc 2c 80 00 	movl   $0x802cfc,(%esp)
  800e1a:	e8 31 f3 ff ff       	call   800150 <_panic>
}

int sys_transmit_packet(void* data, uint32_t len)
{
	return (int)syscall(SYS_transmit_packet, 1, (uint32_t)data, len, 0,0,0);
}
  800e1f:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800e22:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800e25:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800e28:	89 ec                	mov    %ebp,%esp
  800e2a:	5d                   	pop    %ebp
  800e2b:	c3                   	ret    

00800e2c <sys_time_msec>:
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}

unsigned int
sys_time_msec(void)
{
  800e2c:	55                   	push   %ebp
  800e2d:	89 e5                	mov    %esp,%ebp
  800e2f:	83 ec 0c             	sub    $0xc,%esp
  800e32:	89 1c 24             	mov    %ebx,(%esp)
  800e35:	89 74 24 04          	mov    %esi,0x4(%esp)
  800e39:	89 7c 24 08          	mov    %edi,0x8(%esp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800e3d:	ba 00 00 00 00       	mov    $0x0,%edx
  800e42:	b8 0e 00 00 00       	mov    $0xe,%eax
  800e47:	89 d1                	mov    %edx,%ecx
  800e49:	89 d3                	mov    %edx,%ebx
  800e4b:	89 d7                	mov    %edx,%edi
  800e4d:	89 d6                	mov    %edx,%esi
  800e4f:	cd 30                	int    $0x30

unsigned int
sys_time_msec(void)
{
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0,0);
}
  800e51:	8b 1c 24             	mov    (%esp),%ebx
  800e54:	8b 74 24 04          	mov    0x4(%esp),%esi
  800e58:	8b 7c 24 08          	mov    0x8(%esp),%edi
  800e5c:	89 ec                	mov    %ebp,%esp
  800e5e:	5d                   	pop    %ebp
  800e5f:	c3                   	ret    

00800e60 <sys_ipc_recv>:
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}

int
sys_ipc_recv(void *dstva)
{
  800e60:	55                   	push   %ebp
  800e61:	89 e5                	mov    %esp,%ebp
  800e63:	83 ec 38             	sub    $0x38,%esp
  800e66:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800e69:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800e6c:	89 7d fc             	mov    %edi,-0x4(%ebp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800e6f:	b9 00 00 00 00       	mov    $0x0,%ecx
  800e74:	b8 0d 00 00 00       	mov    $0xd,%eax
  800e79:	8b 55 08             	mov    0x8(%ebp),%edx
  800e7c:	89 cb                	mov    %ecx,%ebx
  800e7e:	89 cf                	mov    %ecx,%edi
  800e80:	89 ce                	mov    %ecx,%esi
  800e82:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
	
	if(check && ret > 0)
  800e84:	85 c0                	test   %eax,%eax
  800e86:	7e 28                	jle    800eb0 <sys_ipc_recv+0x50>
		panic("syscall %d returned %d (> 0)", num, ret);
  800e88:	89 44 24 10          	mov    %eax,0x10(%esp)
  800e8c:	c7 44 24 0c 0d 00 00 	movl   $0xd,0xc(%esp)
  800e93:	00 
  800e94:	c7 44 24 08 df 2c 80 	movl   $0x802cdf,0x8(%esp)
  800e9b:	00 
  800e9c:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800ea3:	00 
  800ea4:	c7 04 24 fc 2c 80 00 	movl   $0x802cfc,(%esp)
  800eab:	e8 a0 f2 ff ff       	call   800150 <_panic>

int
sys_ipc_recv(void *dstva)
{
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  800eb0:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800eb3:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800eb6:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800eb9:	89 ec                	mov    %ebp,%esp
  800ebb:	5d                   	pop    %ebp
  800ebc:	c3                   	ret    

00800ebd <sys_ipc_try_send>:
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800ebd:	55                   	push   %ebp
  800ebe:	89 e5                	mov    %esp,%ebp
  800ec0:	83 ec 0c             	sub    $0xc,%esp
  800ec3:	89 1c 24             	mov    %ebx,(%esp)
  800ec6:	89 74 24 04          	mov    %esi,0x4(%esp)
  800eca:	89 7c 24 08          	mov    %edi,0x8(%esp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800ece:	be 00 00 00 00       	mov    $0x0,%esi
  800ed3:	b8 0c 00 00 00       	mov    $0xc,%eax
  800ed8:	8b 7d 14             	mov    0x14(%ebp),%edi
  800edb:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800ede:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ee1:	8b 55 08             	mov    0x8(%ebp),%edx
  800ee4:	cd 30                	int    $0x30

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  800ee6:	8b 1c 24             	mov    (%esp),%ebx
  800ee9:	8b 74 24 04          	mov    0x4(%esp),%esi
  800eed:	8b 7c 24 08          	mov    0x8(%esp),%edi
  800ef1:	89 ec                	mov    %ebp,%esp
  800ef3:	5d                   	pop    %ebp
  800ef4:	c3                   	ret    

00800ef5 <sys_env_set_pgfault_upcall>:
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800ef5:	55                   	push   %ebp
  800ef6:	89 e5                	mov    %esp,%ebp
  800ef8:	83 ec 38             	sub    $0x38,%esp
  800efb:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800efe:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800f01:	89 7d fc             	mov    %edi,-0x4(%ebp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800f04:	bb 00 00 00 00       	mov    $0x0,%ebx
  800f09:	b8 0a 00 00 00       	mov    $0xa,%eax
  800f0e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f11:	8b 55 08             	mov    0x8(%ebp),%edx
  800f14:	89 df                	mov    %ebx,%edi
  800f16:	89 de                	mov    %ebx,%esi
  800f18:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
	
	if(check && ret > 0)
  800f1a:	85 c0                	test   %eax,%eax
  800f1c:	7e 28                	jle    800f46 <sys_env_set_pgfault_upcall+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  800f1e:	89 44 24 10          	mov    %eax,0x10(%esp)
  800f22:	c7 44 24 0c 0a 00 00 	movl   $0xa,0xc(%esp)
  800f29:	00 
  800f2a:	c7 44 24 08 df 2c 80 	movl   $0x802cdf,0x8(%esp)
  800f31:	00 
  800f32:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800f39:	00 
  800f3a:	c7 04 24 fc 2c 80 00 	movl   $0x802cfc,(%esp)
  800f41:	e8 0a f2 ff ff       	call   800150 <_panic>

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  800f46:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800f49:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800f4c:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800f4f:	89 ec                	mov    %ebp,%esp
  800f51:	5d                   	pop    %ebp
  800f52:	c3                   	ret    

00800f53 <sys_env_set_trapframe>:
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800f53:	55                   	push   %ebp
  800f54:	89 e5                	mov    %esp,%ebp
  800f56:	83 ec 38             	sub    $0x38,%esp
  800f59:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800f5c:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800f5f:	89 7d fc             	mov    %edi,-0x4(%ebp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800f62:	bb 00 00 00 00       	mov    $0x0,%ebx
  800f67:	b8 09 00 00 00       	mov    $0x9,%eax
  800f6c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f6f:	8b 55 08             	mov    0x8(%ebp),%edx
  800f72:	89 df                	mov    %ebx,%edi
  800f74:	89 de                	mov    %ebx,%esi
  800f76:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
	
	if(check && ret > 0)
  800f78:	85 c0                	test   %eax,%eax
  800f7a:	7e 28                	jle    800fa4 <sys_env_set_trapframe+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  800f7c:	89 44 24 10          	mov    %eax,0x10(%esp)
  800f80:	c7 44 24 0c 09 00 00 	movl   $0x9,0xc(%esp)
  800f87:	00 
  800f88:	c7 44 24 08 df 2c 80 	movl   $0x802cdf,0x8(%esp)
  800f8f:	00 
  800f90:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800f97:	00 
  800f98:	c7 04 24 fc 2c 80 00 	movl   $0x802cfc,(%esp)
  800f9f:	e8 ac f1 ff ff       	call   800150 <_panic>

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  800fa4:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800fa7:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800faa:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800fad:	89 ec                	mov    %ebp,%esp
  800faf:	5d                   	pop    %ebp
  800fb0:	c3                   	ret    

00800fb1 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800fb1:	55                   	push   %ebp
  800fb2:	89 e5                	mov    %esp,%ebp
  800fb4:	83 ec 38             	sub    $0x38,%esp
  800fb7:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800fba:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800fbd:	89 7d fc             	mov    %edi,-0x4(%ebp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800fc0:	bb 00 00 00 00       	mov    $0x0,%ebx
  800fc5:	b8 08 00 00 00       	mov    $0x8,%eax
  800fca:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800fcd:	8b 55 08             	mov    0x8(%ebp),%edx
  800fd0:	89 df                	mov    %ebx,%edi
  800fd2:	89 de                	mov    %ebx,%esi
  800fd4:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
	
	if(check && ret > 0)
  800fd6:	85 c0                	test   %eax,%eax
  800fd8:	7e 28                	jle    801002 <sys_env_set_status+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  800fda:	89 44 24 10          	mov    %eax,0x10(%esp)
  800fde:	c7 44 24 0c 08 00 00 	movl   $0x8,0xc(%esp)
  800fe5:	00 
  800fe6:	c7 44 24 08 df 2c 80 	movl   $0x802cdf,0x8(%esp)
  800fed:	00 
  800fee:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800ff5:	00 
  800ff6:	c7 04 24 fc 2c 80 00 	movl   $0x802cfc,(%esp)
  800ffd:	e8 4e f1 ff ff       	call   800150 <_panic>

int
sys_env_set_status(envid_t envid, int status)
{
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  801002:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  801005:	8b 75 f8             	mov    -0x8(%ebp),%esi
  801008:	8b 7d fc             	mov    -0x4(%ebp),%edi
  80100b:	89 ec                	mov    %ebp,%esp
  80100d:	5d                   	pop    %ebp
  80100e:	c3                   	ret    

0080100f <sys_page_unmap>:
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}

int
sys_page_unmap(envid_t envid, void *va)
{
  80100f:	55                   	push   %ebp
  801010:	89 e5                	mov    %esp,%ebp
  801012:	83 ec 38             	sub    $0x38,%esp
  801015:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  801018:	89 75 f8             	mov    %esi,-0x8(%ebp)
  80101b:	89 7d fc             	mov    %edi,-0x4(%ebp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80101e:	bb 00 00 00 00       	mov    $0x0,%ebx
  801023:	b8 06 00 00 00       	mov    $0x6,%eax
  801028:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80102b:	8b 55 08             	mov    0x8(%ebp),%edx
  80102e:	89 df                	mov    %ebx,%edi
  801030:	89 de                	mov    %ebx,%esi
  801032:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
	
	if(check && ret > 0)
  801034:	85 c0                	test   %eax,%eax
  801036:	7e 28                	jle    801060 <sys_page_unmap+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  801038:	89 44 24 10          	mov    %eax,0x10(%esp)
  80103c:	c7 44 24 0c 06 00 00 	movl   $0x6,0xc(%esp)
  801043:	00 
  801044:	c7 44 24 08 df 2c 80 	movl   $0x802cdf,0x8(%esp)
  80104b:	00 
  80104c:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  801053:	00 
  801054:	c7 04 24 fc 2c 80 00 	movl   $0x802cfc,(%esp)
  80105b:	e8 f0 f0 ff ff       	call   800150 <_panic>

int
sys_page_unmap(envid_t envid, void *va)
{
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  801060:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  801063:	8b 75 f8             	mov    -0x8(%ebp),%esi
  801066:	8b 7d fc             	mov    -0x4(%ebp),%edi
  801069:	89 ec                	mov    %ebp,%esp
  80106b:	5d                   	pop    %ebp
  80106c:	c3                   	ret    

0080106d <sys_page_map>:
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  80106d:	55                   	push   %ebp
  80106e:	89 e5                	mov    %esp,%ebp
  801070:	83 ec 38             	sub    $0x38,%esp
  801073:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  801076:	89 75 f8             	mov    %esi,-0x8(%ebp)
  801079:	89 7d fc             	mov    %edi,-0x4(%ebp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80107c:	b8 05 00 00 00       	mov    $0x5,%eax
  801081:	8b 75 18             	mov    0x18(%ebp),%esi
  801084:	8b 7d 14             	mov    0x14(%ebp),%edi
  801087:	8b 5d 10             	mov    0x10(%ebp),%ebx
  80108a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80108d:	8b 55 08             	mov    0x8(%ebp),%edx
  801090:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
	
	if(check && ret > 0)
  801092:	85 c0                	test   %eax,%eax
  801094:	7e 28                	jle    8010be <sys_page_map+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  801096:	89 44 24 10          	mov    %eax,0x10(%esp)
  80109a:	c7 44 24 0c 05 00 00 	movl   $0x5,0xc(%esp)
  8010a1:	00 
  8010a2:	c7 44 24 08 df 2c 80 	movl   $0x802cdf,0x8(%esp)
  8010a9:	00 
  8010aa:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  8010b1:	00 
  8010b2:	c7 04 24 fc 2c 80 00 	movl   $0x802cfc,(%esp)
  8010b9:	e8 92 f0 ff ff       	call   800150 <_panic>

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  8010be:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  8010c1:	8b 75 f8             	mov    -0x8(%ebp),%esi
  8010c4:	8b 7d fc             	mov    -0x4(%ebp),%edi
  8010c7:	89 ec                	mov    %ebp,%esp
  8010c9:	5d                   	pop    %ebp
  8010ca:	c3                   	ret    

008010cb <sys_page_alloc>:
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  8010cb:	55                   	push   %ebp
  8010cc:	89 e5                	mov    %esp,%ebp
  8010ce:	83 ec 38             	sub    $0x38,%esp
  8010d1:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  8010d4:	89 75 f8             	mov    %esi,-0x8(%ebp)
  8010d7:	89 7d fc             	mov    %edi,-0x4(%ebp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8010da:	be 00 00 00 00       	mov    $0x0,%esi
  8010df:	b8 04 00 00 00       	mov    $0x4,%eax
  8010e4:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8010e7:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8010ea:	8b 55 08             	mov    0x8(%ebp),%edx
  8010ed:	89 f7                	mov    %esi,%edi
  8010ef:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
	
	if(check && ret > 0)
  8010f1:	85 c0                	test   %eax,%eax
  8010f3:	7e 28                	jle    80111d <sys_page_alloc+0x52>
		panic("syscall %d returned %d (> 0)", num, ret);
  8010f5:	89 44 24 10          	mov    %eax,0x10(%esp)
  8010f9:	c7 44 24 0c 04 00 00 	movl   $0x4,0xc(%esp)
  801100:	00 
  801101:	c7 44 24 08 df 2c 80 	movl   $0x802cdf,0x8(%esp)
  801108:	00 
  801109:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  801110:	00 
  801111:	c7 04 24 fc 2c 80 00 	movl   $0x802cfc,(%esp)
  801118:	e8 33 f0 ff ff       	call   800150 <_panic>

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  80111d:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  801120:	8b 75 f8             	mov    -0x8(%ebp),%esi
  801123:	8b 7d fc             	mov    -0x4(%ebp),%edi
  801126:	89 ec                	mov    %ebp,%esp
  801128:	5d                   	pop    %ebp
  801129:	c3                   	ret    

0080112a <sys_yield>:
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}

void
sys_yield(void)
{
  80112a:	55                   	push   %ebp
  80112b:	89 e5                	mov    %esp,%ebp
  80112d:	83 ec 0c             	sub    $0xc,%esp
  801130:	89 1c 24             	mov    %ebx,(%esp)
  801133:	89 74 24 04          	mov    %esi,0x4(%esp)
  801137:	89 7c 24 08          	mov    %edi,0x8(%esp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80113b:	ba 00 00 00 00       	mov    $0x0,%edx
  801140:	b8 0b 00 00 00       	mov    $0xb,%eax
  801145:	89 d1                	mov    %edx,%ecx
  801147:	89 d3                	mov    %edx,%ebx
  801149:	89 d7                	mov    %edx,%edi
  80114b:	89 d6                	mov    %edx,%esi
  80114d:	cd 30                	int    $0x30

void
sys_yield(void)
{
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  80114f:	8b 1c 24             	mov    (%esp),%ebx
  801152:	8b 74 24 04          	mov    0x4(%esp),%esi
  801156:	8b 7c 24 08          	mov    0x8(%esp),%edi
  80115a:	89 ec                	mov    %ebp,%esp
  80115c:	5d                   	pop    %ebp
  80115d:	c3                   	ret    

0080115e <sys_getenvid>:
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}

envid_t
sys_getenvid(void)
{
  80115e:	55                   	push   %ebp
  80115f:	89 e5                	mov    %esp,%ebp
  801161:	83 ec 0c             	sub    $0xc,%esp
  801164:	89 1c 24             	mov    %ebx,(%esp)
  801167:	89 74 24 04          	mov    %esi,0x4(%esp)
  80116b:	89 7c 24 08          	mov    %edi,0x8(%esp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80116f:	ba 00 00 00 00       	mov    $0x0,%edx
  801174:	b8 02 00 00 00       	mov    $0x2,%eax
  801179:	89 d1                	mov    %edx,%ecx
  80117b:	89 d3                	mov    %edx,%ebx
  80117d:	89 d7                	mov    %edx,%edi
  80117f:	89 d6                	mov    %edx,%esi
  801181:	cd 30                	int    $0x30

envid_t
sys_getenvid(void)
{
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  801183:	8b 1c 24             	mov    (%esp),%ebx
  801186:	8b 74 24 04          	mov    0x4(%esp),%esi
  80118a:	8b 7c 24 08          	mov    0x8(%esp),%edi
  80118e:	89 ec                	mov    %ebp,%esp
  801190:	5d                   	pop    %ebp
  801191:	c3                   	ret    

00801192 <sys_env_destroy>:
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}

int
sys_env_destroy(envid_t envid)
{
  801192:	55                   	push   %ebp
  801193:	89 e5                	mov    %esp,%ebp
  801195:	83 ec 38             	sub    $0x38,%esp
  801198:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  80119b:	89 75 f8             	mov    %esi,-0x8(%ebp)
  80119e:	89 7d fc             	mov    %edi,-0x4(%ebp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8011a1:	b9 00 00 00 00       	mov    $0x0,%ecx
  8011a6:	b8 03 00 00 00       	mov    $0x3,%eax
  8011ab:	8b 55 08             	mov    0x8(%ebp),%edx
  8011ae:	89 cb                	mov    %ecx,%ebx
  8011b0:	89 cf                	mov    %ecx,%edi
  8011b2:	89 ce                	mov    %ecx,%esi
  8011b4:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
	
	if(check && ret > 0)
  8011b6:	85 c0                	test   %eax,%eax
  8011b8:	7e 28                	jle    8011e2 <sys_env_destroy+0x50>
		panic("syscall %d returned %d (> 0)", num, ret);
  8011ba:	89 44 24 10          	mov    %eax,0x10(%esp)
  8011be:	c7 44 24 0c 03 00 00 	movl   $0x3,0xc(%esp)
  8011c5:	00 
  8011c6:	c7 44 24 08 df 2c 80 	movl   $0x802cdf,0x8(%esp)
  8011cd:	00 
  8011ce:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  8011d5:	00 
  8011d6:	c7 04 24 fc 2c 80 00 	movl   $0x802cfc,(%esp)
  8011dd:	e8 6e ef ff ff       	call   800150 <_panic>

int
sys_env_destroy(envid_t envid)
{
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  8011e2:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  8011e5:	8b 75 f8             	mov    -0x8(%ebp),%esi
  8011e8:	8b 7d fc             	mov    -0x4(%ebp),%edi
  8011eb:	89 ec                	mov    %ebp,%esp
  8011ed:	5d                   	pop    %ebp
  8011ee:	c3                   	ret    
	...

008011f0 <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  8011f0:	55                   	push   %ebp
  8011f1:	89 e5                	mov    %esp,%ebp
  8011f3:	83 ec 18             	sub    $0x18,%esp
	int r;

	if (_pgfault_handler == 0) {
  8011f6:	83 3d 7c 60 80 00 00 	cmpl   $0x0,0x80607c
  8011fd:	75 78                	jne    801277 <set_pgfault_handler+0x87>
		// First time through!
		// LAB 4: Your code here.
		// panic("set_pgfault_handler not implemented");
		int ret;	
		if ((ret = sys_page_alloc(0, (void*)(UXSTACKTOP - PGSIZE), PTE_U | PTE_P | PTE_W)) < 0)
  8011ff:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  801206:	00 
  801207:	c7 44 24 04 00 f0 bf 	movl   $0xeebff000,0x4(%esp)
  80120e:	ee 
  80120f:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801216:	e8 b0 fe ff ff       	call   8010cb <sys_page_alloc>
  80121b:	85 c0                	test   %eax,%eax
  80121d:	79 20                	jns    80123f <set_pgfault_handler+0x4f>
			panic (" error in sys_page_alloc: %e\n", ret);
  80121f:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801223:	c7 44 24 08 0a 2d 80 	movl   $0x802d0a,0x8(%esp)
  80122a:	00 
  80122b:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  801232:	00 
  801233:	c7 04 24 28 2d 80 00 	movl   $0x802d28,(%esp)
  80123a:	e8 11 ef ff ff       	call   800150 <_panic>
		if ((ret = sys_env_set_pgfault_upcall(0, _pgfault_upcall)) < 0)
  80123f:	c7 44 24 04 84 12 80 	movl   $0x801284,0x4(%esp)
  801246:	00 
  801247:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80124e:	e8 a2 fc ff ff       	call   800ef5 <sys_env_set_pgfault_upcall>
  801253:	85 c0                	test   %eax,%eax
  801255:	79 20                	jns    801277 <set_pgfault_handler+0x87>
			panic (" error in sys_env_set_pgfault_upcall: %e\n", ret);
  801257:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80125b:	c7 44 24 08 38 2d 80 	movl   $0x802d38,0x8(%esp)
  801262:	00 
  801263:	c7 44 24 04 25 00 00 	movl   $0x25,0x4(%esp)
  80126a:	00 
  80126b:	c7 04 24 28 2d 80 00 	movl   $0x802d28,(%esp)
  801272:	e8 d9 ee ff ff       	call   800150 <_panic>
	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  801277:	8b 45 08             	mov    0x8(%ebp),%eax
  80127a:	a3 7c 60 80 00       	mov    %eax,0x80607c
	
}
  80127f:	c9                   	leave  
  801280:	c3                   	ret    
  801281:	00 00                	add    %al,(%eax)
	...

00801284 <_pgfault_upcall>:

.text
.globl _pgfault_upcall
_pgfault_upcall:
	// Call the C page fault handler.
	pushl %esp			// function argument: pointer to UTF
  801284:	54                   	push   %esp
	movl _pgfault_handler, %eax
  801285:	a1 7c 60 80 00       	mov    0x80607c,%eax
	call *%eax
  80128a:	ff d0                	call   *%eax
	addl $4, %esp			// pop function argument
  80128c:	83 c4 04             	add    $0x4,%esp
	// may find that you have to rearrange your code in non-obvious
	// ways as registers become unavailable as scratch space.
	//
	// LAB 4: Your code here.
	
	movl %esp, %ecx			// back up esp to ecx
  80128f:	89 e1                	mov    %esp,%ecx
	movl 0x28(%esp), %ebx		// store trap-time eip into ebx
  801291:	8b 5c 24 28          	mov    0x28(%esp),%ebx
	movl 0x30(%esp), %edx		// store trap-time esp into edx
  801295:	8b 54 24 30          	mov    0x30(%esp),%edx
	movl %edx, %esp			// switch to trap-time stack
  801299:	89 d4                	mov    %edx,%esp
	pushl %ebx			// push trap-time eip here
  80129b:	53                   	push   %ebx
	movl %ecx, %esp			// come back to user exception stack
  80129c:	89 cc                	mov    %ecx,%esp
	
	// for the push made above, update the trap-time esp value in this user exception stack
	// this enables popl %esp to cause esp point to the adjusted trap-time stack 
	subl $0x4, %edx			
  80129e:	83 ea 04             	sub    $0x4,%edx
	movl %edx, 0x30(%esp)
  8012a1:	89 54 24 30          	mov    %edx,0x30(%esp)
	

	// Restore the trap-time registers.  After you do this, you
	// can no longer modify any general-purpose registers.
	// LAB 4: Your code here.
	addl $0x8, %esp
  8012a5:	83 c4 08             	add    $0x8,%esp
	popal
  8012a8:	61                   	popa   
	// Restore eflags from the stack.  After you do this, you can
	// no longer use arithmetic operations or anything else that
	// modifies eflags.
	// LAB 4: Your code here.
	
	addl $0x4, %esp
  8012a9:	83 c4 04             	add    $0x4,%esp
	popfl
  8012ac:	9d                   	popf   

	// Switch back to the adjusted trap-time stack.
	// LAB 4: Your code here.

	popl %esp
  8012ad:	5c                   	pop    %esp

	// Return to re-execute the instruction that faulted.
	// LAB 4: Your code here.
	
	ret
  8012ae:	c3                   	ret    
	...

008012b0 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  8012b0:	55                   	push   %ebp
  8012b1:	89 e5                	mov    %esp,%ebp
  8012b3:	8b 45 08             	mov    0x8(%ebp),%eax
  8012b6:	05 00 00 00 30       	add    $0x30000000,%eax
  8012bb:	c1 e8 0c             	shr    $0xc,%eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
}
  8012be:	5d                   	pop    %ebp
  8012bf:	c3                   	ret    

008012c0 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  8012c0:	55                   	push   %ebp
  8012c1:	89 e5                	mov    %esp,%ebp
  8012c3:	83 ec 04             	sub    $0x4,%esp
	return INDEX2DATA(fd2num(fd));
  8012c6:	8b 45 08             	mov    0x8(%ebp),%eax
  8012c9:	89 04 24             	mov    %eax,(%esp)
  8012cc:	e8 df ff ff ff       	call   8012b0 <fd2num>
  8012d1:	05 20 00 0d 00       	add    $0xd0020,%eax
  8012d6:	c1 e0 0c             	shl    $0xc,%eax
}
  8012d9:	c9                   	leave  
  8012da:	c3                   	ret    

008012db <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  8012db:	55                   	push   %ebp
  8012dc:	89 e5                	mov    %esp,%ebp
  8012de:	57                   	push   %edi
  8012df:	56                   	push   %esi
  8012e0:	53                   	push   %ebx
  8012e1:	8b 7d 08             	mov    0x8(%ebp),%edi
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((vpd[PDX(fd)] & PTE_P) == 0 || (vpt[VPN(fd)] & PTE_P) == 0) {
  8012e4:	a1 00 dd 7b ef       	mov    0xef7bdd00,%eax
  8012e9:	a8 01                	test   $0x1,%al
  8012eb:	74 36                	je     801323 <fd_alloc+0x48>
  8012ed:	a1 00 00 74 ef       	mov    0xef740000,%eax
  8012f2:	a8 01                	test   $0x1,%al
  8012f4:	74 2d                	je     801323 <fd_alloc+0x48>
  8012f6:	b8 00 10 00 d0       	mov    $0xd0001000,%eax
  8012fb:	b9 00 d0 7b ef       	mov    $0xef7bd000,%ecx
  801300:	be 00 00 40 ef       	mov    $0xef400000,%esi
  801305:	89 c3                	mov    %eax,%ebx
  801307:	89 c2                	mov    %eax,%edx
  801309:	c1 ea 16             	shr    $0x16,%edx
  80130c:	8b 14 91             	mov    (%ecx,%edx,4),%edx
  80130f:	f6 c2 01             	test   $0x1,%dl
  801312:	74 14                	je     801328 <fd_alloc+0x4d>
  801314:	89 c2                	mov    %eax,%edx
  801316:	c1 ea 0c             	shr    $0xc,%edx
  801319:	8b 14 96             	mov    (%esi,%edx,4),%edx
  80131c:	f6 c2 01             	test   $0x1,%dl
  80131f:	75 10                	jne    801331 <fd_alloc+0x56>
  801321:	eb 05                	jmp    801328 <fd_alloc+0x4d>
  801323:	bb 00 00 00 d0       	mov    $0xd0000000,%ebx
			*fd_store = fd;
  801328:	89 1f                	mov    %ebx,(%edi)
  80132a:	b8 00 00 00 00       	mov    $0x0,%eax
			return 0;
  80132f:	eb 17                	jmp    801348 <fd_alloc+0x6d>
  801331:	05 00 10 00 00       	add    $0x1000,%eax
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  801336:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  80133b:	75 c8                	jne    801305 <fd_alloc+0x2a>
		if ((vpd[PDX(fd)] & PTE_P) == 0 || (vpt[VPN(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  80133d:	c7 07 00 00 00 00    	movl   $0x0,(%edi)
  801343:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
	return -E_MAX_OPEN;
}
  801348:	5b                   	pop    %ebx
  801349:	5e                   	pop    %esi
  80134a:	5f                   	pop    %edi
  80134b:	5d                   	pop    %ebp
  80134c:	c3                   	ret    

0080134d <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  80134d:	55                   	push   %ebp
  80134e:	89 e5                	mov    %esp,%ebp
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  801350:	8b 45 08             	mov    0x8(%ebp),%eax
  801353:	83 f8 1f             	cmp    $0x1f,%eax
  801356:	77 36                	ja     80138e <fd_lookup+0x41>
		if (debug)
			cprintf("[%08x] bad fd %d\n", env->env_id, fd);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  801358:	05 00 00 0d 00       	add    $0xd0000,%eax
  80135d:	c1 e0 0c             	shl    $0xc,%eax
	if (!(vpd[PDX(fd)] & PTE_P) || !(vpt[VPN(fd)] & PTE_P)) {
  801360:	89 c2                	mov    %eax,%edx
  801362:	c1 ea 16             	shr    $0x16,%edx
  801365:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  80136c:	f6 c2 01             	test   $0x1,%dl
  80136f:	74 1d                	je     80138e <fd_lookup+0x41>
  801371:	89 c2                	mov    %eax,%edx
  801373:	c1 ea 0c             	shr    $0xc,%edx
  801376:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  80137d:	f6 c2 01             	test   $0x1,%dl
  801380:	74 0c                	je     80138e <fd_lookup+0x41>
		if (debug)
			cprintf("[%08x] closed fd %d\n", env->env_id, fd);
		return -E_INVAL;
	}
	*fd_store = fd;
  801382:	8b 55 0c             	mov    0xc(%ebp),%edx
  801385:	89 02                	mov    %eax,(%edx)
  801387:	b8 00 00 00 00       	mov    $0x0,%eax
	return 0;
  80138c:	eb 05                	jmp    801393 <fd_lookup+0x46>
  80138e:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  801393:	5d                   	pop    %ebp
  801394:	c3                   	ret    

00801395 <seek>:
	return (*dev->dev_write)(fd, buf, n);
}

int
seek(int fdnum, off_t offset)
{
  801395:	55                   	push   %ebp
  801396:	89 e5                	mov    %esp,%ebp
  801398:	83 ec 18             	sub    $0x18,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80139b:	8d 45 fc             	lea    -0x4(%ebp),%eax
  80139e:	89 44 24 04          	mov    %eax,0x4(%esp)
  8013a2:	8b 45 08             	mov    0x8(%ebp),%eax
  8013a5:	89 04 24             	mov    %eax,(%esp)
  8013a8:	e8 a0 ff ff ff       	call   80134d <fd_lookup>
  8013ad:	85 c0                	test   %eax,%eax
  8013af:	78 0e                	js     8013bf <seek+0x2a>
		return r;
	fd->fd_offset = offset;
  8013b1:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8013b4:	8b 55 0c             	mov    0xc(%ebp),%edx
  8013b7:	89 50 04             	mov    %edx,0x4(%eax)
  8013ba:	b8 00 00 00 00       	mov    $0x0,%eax
	return 0;
}
  8013bf:	c9                   	leave  
  8013c0:	c3                   	ret    

008013c1 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  8013c1:	55                   	push   %ebp
  8013c2:	89 e5                	mov    %esp,%ebp
  8013c4:	56                   	push   %esi
  8013c5:	53                   	push   %ebx
  8013c6:	83 ec 10             	sub    $0x10,%esp
  8013c9:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8013cc:	8b 5d 0c             	mov    0xc(%ebp),%ebx
// File functions
// --------------------------------------------------------------

static struct Dev *devtab[] =
{
	&devfile,
  8013cf:	b8 04 60 80 00       	mov    $0x806004,%eax
{
	int i;
	for (i = 0; devtab[i]; i++)
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
  8013d4:	ba 00 00 00 00       	mov    $0x0,%edx

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  8013d9:	be e0 2d 80 00       	mov    $0x802de0,%esi
		if (devtab[i]->dev_id == dev_id) {
  8013de:	39 08                	cmp    %ecx,(%eax)
  8013e0:	75 10                	jne    8013f2 <dev_lookup+0x31>
  8013e2:	eb 04                	jmp    8013e8 <dev_lookup+0x27>
  8013e4:	39 08                	cmp    %ecx,(%eax)
  8013e6:	75 0a                	jne    8013f2 <dev_lookup+0x31>
			*dev = devtab[i];
  8013e8:	89 03                	mov    %eax,(%ebx)
  8013ea:	b8 00 00 00 00       	mov    $0x0,%eax
			return 0;
  8013ef:	90                   	nop
  8013f0:	eb 31                	jmp    801423 <dev_lookup+0x62>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  8013f2:	83 c2 01             	add    $0x1,%edx
  8013f5:	8b 04 96             	mov    (%esi,%edx,4),%eax
  8013f8:	85 c0                	test   %eax,%eax
  8013fa:	75 e8                	jne    8013e4 <dev_lookup+0x23>
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", env->env_id, dev_id);
  8013fc:	a1 74 60 80 00       	mov    0x806074,%eax
  801401:	8b 40 4c             	mov    0x4c(%eax),%eax
  801404:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801408:	89 44 24 04          	mov    %eax,0x4(%esp)
  80140c:	c7 04 24 64 2d 80 00 	movl   $0x802d64,(%esp)
  801413:	e8 fd ed ff ff       	call   800215 <cprintf>
	*dev = 0;
  801418:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  80141e:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
	return -E_INVAL;
}
  801423:	83 c4 10             	add    $0x10,%esp
  801426:	5b                   	pop    %ebx
  801427:	5e                   	pop    %esi
  801428:	5d                   	pop    %ebp
  801429:	c3                   	ret    

0080142a <fstat>:
	return (*dev->dev_trunc)(fd, newsize);
}

int
fstat(int fdnum, struct Stat *stat)
{
  80142a:	55                   	push   %ebp
  80142b:	89 e5                	mov    %esp,%ebp
  80142d:	53                   	push   %ebx
  80142e:	83 ec 24             	sub    $0x24,%esp
  801431:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801434:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801437:	89 44 24 04          	mov    %eax,0x4(%esp)
  80143b:	8b 45 08             	mov    0x8(%ebp),%eax
  80143e:	89 04 24             	mov    %eax,(%esp)
  801441:	e8 07 ff ff ff       	call   80134d <fd_lookup>
  801446:	85 c0                	test   %eax,%eax
  801448:	78 53                	js     80149d <fstat+0x73>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80144a:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80144d:	89 44 24 04          	mov    %eax,0x4(%esp)
  801451:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801454:	8b 00                	mov    (%eax),%eax
  801456:	89 04 24             	mov    %eax,(%esp)
  801459:	e8 63 ff ff ff       	call   8013c1 <dev_lookup>
{
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80145e:	85 c0                	test   %eax,%eax
  801460:	78 3b                	js     80149d <fstat+0x73>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if (!dev->dev_stat)
  801462:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801467:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80146a:	83 7a 14 00          	cmpl   $0x0,0x14(%edx)
  80146e:	74 2d                	je     80149d <fstat+0x73>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  801470:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  801473:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  80147a:	00 00 00 
	stat->st_isdir = 0;
  80147d:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801484:	00 00 00 
	stat->st_dev = dev;
  801487:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80148a:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  801490:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801494:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801497:	89 14 24             	mov    %edx,(%esp)
  80149a:	ff 50 14             	call   *0x14(%eax)
}
  80149d:	83 c4 24             	add    $0x24,%esp
  8014a0:	5b                   	pop    %ebx
  8014a1:	5d                   	pop    %ebp
  8014a2:	c3                   	ret    

008014a3 <ftruncate>:
	return 0;
}

int
ftruncate(int fdnum, off_t newsize)
{
  8014a3:	55                   	push   %ebp
  8014a4:	89 e5                	mov    %esp,%ebp
  8014a6:	53                   	push   %ebx
  8014a7:	83 ec 24             	sub    $0x24,%esp
  8014aa:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  8014ad:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8014b0:	89 44 24 04          	mov    %eax,0x4(%esp)
  8014b4:	89 1c 24             	mov    %ebx,(%esp)
  8014b7:	e8 91 fe ff ff       	call   80134d <fd_lookup>
  8014bc:	85 c0                	test   %eax,%eax
  8014be:	78 5f                	js     80151f <ftruncate+0x7c>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8014c0:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8014c3:	89 44 24 04          	mov    %eax,0x4(%esp)
  8014c7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8014ca:	8b 00                	mov    (%eax),%eax
  8014cc:	89 04 24             	mov    %eax,(%esp)
  8014cf:	e8 ed fe ff ff       	call   8013c1 <dev_lookup>
ftruncate(int fdnum, off_t newsize)
{
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  8014d4:	85 c0                	test   %eax,%eax
  8014d6:	78 47                	js     80151f <ftruncate+0x7c>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8014d8:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8014db:	f6 42 08 03          	testb  $0x3,0x8(%edx)
  8014df:	75 23                	jne    801504 <ftruncate+0x61>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			env->env_id, fdnum); 
  8014e1:	a1 74 60 80 00       	mov    0x806074,%eax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  8014e6:	8b 40 4c             	mov    0x4c(%eax),%eax
  8014e9:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8014ed:	89 44 24 04          	mov    %eax,0x4(%esp)
  8014f1:	c7 04 24 84 2d 80 00 	movl   $0x802d84,(%esp)
  8014f8:	e8 18 ed ff ff       	call   800215 <cprintf>
  8014fd:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
			env->env_id, fdnum); 
		return -E_INVAL;
  801502:	eb 1b                	jmp    80151f <ftruncate+0x7c>
	}
	if (!dev->dev_trunc)
  801504:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801507:	8b 48 18             	mov    0x18(%eax),%ecx
  80150a:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  80150f:	85 c9                	test   %ecx,%ecx
  801511:	74 0c                	je     80151f <ftruncate+0x7c>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  801513:	8b 45 0c             	mov    0xc(%ebp),%eax
  801516:	89 44 24 04          	mov    %eax,0x4(%esp)
  80151a:	89 14 24             	mov    %edx,(%esp)
  80151d:	ff d1                	call   *%ecx
}
  80151f:	83 c4 24             	add    $0x24,%esp
  801522:	5b                   	pop    %ebx
  801523:	5d                   	pop    %ebp
  801524:	c3                   	ret    

00801525 <write>:
	return tot;
}

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  801525:	55                   	push   %ebp
  801526:	89 e5                	mov    %esp,%ebp
  801528:	53                   	push   %ebx
  801529:	83 ec 24             	sub    $0x24,%esp
  80152c:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80152f:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801532:	89 44 24 04          	mov    %eax,0x4(%esp)
  801536:	89 1c 24             	mov    %ebx,(%esp)
  801539:	e8 0f fe ff ff       	call   80134d <fd_lookup>
  80153e:	85 c0                	test   %eax,%eax
  801540:	78 66                	js     8015a8 <write+0x83>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801542:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801545:	89 44 24 04          	mov    %eax,0x4(%esp)
  801549:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80154c:	8b 00                	mov    (%eax),%eax
  80154e:	89 04 24             	mov    %eax,(%esp)
  801551:	e8 6b fe ff ff       	call   8013c1 <dev_lookup>
{
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801556:	85 c0                	test   %eax,%eax
  801558:	78 4e                	js     8015a8 <write+0x83>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  80155a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80155d:	f6 42 08 03          	testb  $0x3,0x8(%edx)
  801561:	75 23                	jne    801586 <write+0x61>
		cprintf("[%08x] write %d -- bad mode\n", env->env_id, fdnum);
  801563:	a1 74 60 80 00       	mov    0x806074,%eax
  801568:	8b 40 4c             	mov    0x4c(%eax),%eax
  80156b:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80156f:	89 44 24 04          	mov    %eax,0x4(%esp)
  801573:	c7 04 24 a5 2d 80 00 	movl   $0x802da5,(%esp)
  80157a:	e8 96 ec ff ff       	call   800215 <cprintf>
  80157f:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
		return -E_INVAL;
  801584:	eb 22                	jmp    8015a8 <write+0x83>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  801586:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801589:	8b 48 0c             	mov    0xc(%eax),%ecx
  80158c:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801591:	85 c9                	test   %ecx,%ecx
  801593:	74 13                	je     8015a8 <write+0x83>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  801595:	8b 45 10             	mov    0x10(%ebp),%eax
  801598:	89 44 24 08          	mov    %eax,0x8(%esp)
  80159c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80159f:	89 44 24 04          	mov    %eax,0x4(%esp)
  8015a3:	89 14 24             	mov    %edx,(%esp)
  8015a6:	ff d1                	call   *%ecx
}
  8015a8:	83 c4 24             	add    $0x24,%esp
  8015ab:	5b                   	pop    %ebx
  8015ac:	5d                   	pop    %ebp
  8015ad:	c3                   	ret    

008015ae <read>:
	return r;
}

ssize_t
read(int fdnum, void *buf, size_t n)
{
  8015ae:	55                   	push   %ebp
  8015af:	89 e5                	mov    %esp,%ebp
  8015b1:	53                   	push   %ebx
  8015b2:	83 ec 24             	sub    $0x24,%esp
  8015b5:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8015b8:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8015bb:	89 44 24 04          	mov    %eax,0x4(%esp)
  8015bf:	89 1c 24             	mov    %ebx,(%esp)
  8015c2:	e8 86 fd ff ff       	call   80134d <fd_lookup>
  8015c7:	85 c0                	test   %eax,%eax
  8015c9:	78 6b                	js     801636 <read+0x88>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8015cb:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8015ce:	89 44 24 04          	mov    %eax,0x4(%esp)
  8015d2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8015d5:	8b 00                	mov    (%eax),%eax
  8015d7:	89 04 24             	mov    %eax,(%esp)
  8015da:	e8 e2 fd ff ff       	call   8013c1 <dev_lookup>
{
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8015df:	85 c0                	test   %eax,%eax
  8015e1:	78 53                	js     801636 <read+0x88>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  8015e3:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8015e6:	8b 42 08             	mov    0x8(%edx),%eax
  8015e9:	83 e0 03             	and    $0x3,%eax
  8015ec:	83 f8 01             	cmp    $0x1,%eax
  8015ef:	75 23                	jne    801614 <read+0x66>
		cprintf("[%08x] read %d -- bad mode\n", env->env_id, fdnum); 
  8015f1:	a1 74 60 80 00       	mov    0x806074,%eax
  8015f6:	8b 40 4c             	mov    0x4c(%eax),%eax
  8015f9:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8015fd:	89 44 24 04          	mov    %eax,0x4(%esp)
  801601:	c7 04 24 c2 2d 80 00 	movl   $0x802dc2,(%esp)
  801608:	e8 08 ec ff ff       	call   800215 <cprintf>
  80160d:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
		return -E_INVAL;
  801612:	eb 22                	jmp    801636 <read+0x88>
	}
	if (!dev->dev_read)
  801614:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801617:	8b 48 08             	mov    0x8(%eax),%ecx
  80161a:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  80161f:	85 c9                	test   %ecx,%ecx
  801621:	74 13                	je     801636 <read+0x88>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  801623:	8b 45 10             	mov    0x10(%ebp),%eax
  801626:	89 44 24 08          	mov    %eax,0x8(%esp)
  80162a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80162d:	89 44 24 04          	mov    %eax,0x4(%esp)
  801631:	89 14 24             	mov    %edx,(%esp)
  801634:	ff d1                	call   *%ecx
}
  801636:	83 c4 24             	add    $0x24,%esp
  801639:	5b                   	pop    %ebx
  80163a:	5d                   	pop    %ebp
  80163b:	c3                   	ret    

0080163c <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  80163c:	55                   	push   %ebp
  80163d:	89 e5                	mov    %esp,%ebp
  80163f:	57                   	push   %edi
  801640:	56                   	push   %esi
  801641:	53                   	push   %ebx
  801642:	83 ec 1c             	sub    $0x1c,%esp
  801645:	8b 7d 08             	mov    0x8(%ebp),%edi
  801648:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  80164b:	ba 00 00 00 00       	mov    $0x0,%edx
  801650:	bb 00 00 00 00       	mov    $0x0,%ebx
  801655:	b8 00 00 00 00       	mov    $0x0,%eax
  80165a:	85 f6                	test   %esi,%esi
  80165c:	74 29                	je     801687 <readn+0x4b>
		m = read(fdnum, (char*)buf + tot, n - tot);
  80165e:	89 f0                	mov    %esi,%eax
  801660:	29 d0                	sub    %edx,%eax
  801662:	89 44 24 08          	mov    %eax,0x8(%esp)
  801666:	03 55 0c             	add    0xc(%ebp),%edx
  801669:	89 54 24 04          	mov    %edx,0x4(%esp)
  80166d:	89 3c 24             	mov    %edi,(%esp)
  801670:	e8 39 ff ff ff       	call   8015ae <read>
		if (m < 0)
  801675:	85 c0                	test   %eax,%eax
  801677:	78 0e                	js     801687 <readn+0x4b>
			return m;
		if (m == 0)
  801679:	85 c0                	test   %eax,%eax
  80167b:	74 08                	je     801685 <readn+0x49>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  80167d:	01 c3                	add    %eax,%ebx
  80167f:	89 da                	mov    %ebx,%edx
  801681:	39 f3                	cmp    %esi,%ebx
  801683:	72 d9                	jb     80165e <readn+0x22>
  801685:	89 d8                	mov    %ebx,%eax
			return m;
		if (m == 0)
			break;
	}
	return tot;
}
  801687:	83 c4 1c             	add    $0x1c,%esp
  80168a:	5b                   	pop    %ebx
  80168b:	5e                   	pop    %esi
  80168c:	5f                   	pop    %edi
  80168d:	5d                   	pop    %ebp
  80168e:	c3                   	ret    

0080168f <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  80168f:	55                   	push   %ebp
  801690:	89 e5                	mov    %esp,%ebp
  801692:	56                   	push   %esi
  801693:	53                   	push   %ebx
  801694:	83 ec 20             	sub    $0x20,%esp
  801697:	8b 75 08             	mov    0x8(%ebp),%esi
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  80169a:	89 34 24             	mov    %esi,(%esp)
  80169d:	e8 0e fc ff ff       	call   8012b0 <fd2num>
  8016a2:	8d 55 f4             	lea    -0xc(%ebp),%edx
  8016a5:	89 54 24 04          	mov    %edx,0x4(%esp)
  8016a9:	89 04 24             	mov    %eax,(%esp)
  8016ac:	e8 9c fc ff ff       	call   80134d <fd_lookup>
  8016b1:	89 c3                	mov    %eax,%ebx
  8016b3:	85 c0                	test   %eax,%eax
  8016b5:	78 05                	js     8016bc <fd_close+0x2d>
  8016b7:	3b 75 f4             	cmp    -0xc(%ebp),%esi
  8016ba:	74 0c                	je     8016c8 <fd_close+0x39>
	    || fd != fd2)
		return (must_exist ? r : 0);
  8016bc:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8016c0:	19 c0                	sbb    %eax,%eax
  8016c2:	f7 d0                	not    %eax
  8016c4:	21 c3                	and    %eax,%ebx
  8016c6:	eb 3d                	jmp    801705 <fd_close+0x76>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  8016c8:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8016cb:	89 44 24 04          	mov    %eax,0x4(%esp)
  8016cf:	8b 06                	mov    (%esi),%eax
  8016d1:	89 04 24             	mov    %eax,(%esp)
  8016d4:	e8 e8 fc ff ff       	call   8013c1 <dev_lookup>
  8016d9:	89 c3                	mov    %eax,%ebx
  8016db:	85 c0                	test   %eax,%eax
  8016dd:	78 16                	js     8016f5 <fd_close+0x66>
		if (dev->dev_close)
  8016df:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8016e2:	8b 40 10             	mov    0x10(%eax),%eax
  8016e5:	bb 00 00 00 00       	mov    $0x0,%ebx
  8016ea:	85 c0                	test   %eax,%eax
  8016ec:	74 07                	je     8016f5 <fd_close+0x66>
			r = (*dev->dev_close)(fd);
  8016ee:	89 34 24             	mov    %esi,(%esp)
  8016f1:	ff d0                	call   *%eax
  8016f3:	89 c3                	mov    %eax,%ebx
		else
			r = 0;
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  8016f5:	89 74 24 04          	mov    %esi,0x4(%esp)
  8016f9:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801700:	e8 0a f9 ff ff       	call   80100f <sys_page_unmap>
	return r;
}
  801705:	89 d8                	mov    %ebx,%eax
  801707:	83 c4 20             	add    $0x20,%esp
  80170a:	5b                   	pop    %ebx
  80170b:	5e                   	pop    %esi
  80170c:	5d                   	pop    %ebp
  80170d:	c3                   	ret    

0080170e <close>:
	return -E_INVAL;
}

int
close(int fdnum)
{
  80170e:	55                   	push   %ebp
  80170f:	89 e5                	mov    %esp,%ebp
  801711:	83 ec 28             	sub    $0x28,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801714:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801717:	89 44 24 04          	mov    %eax,0x4(%esp)
  80171b:	8b 45 08             	mov    0x8(%ebp),%eax
  80171e:	89 04 24             	mov    %eax,(%esp)
  801721:	e8 27 fc ff ff       	call   80134d <fd_lookup>
  801726:	85 c0                	test   %eax,%eax
  801728:	78 13                	js     80173d <close+0x2f>
		return r;
	else
		return fd_close(fd, 1);
  80172a:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  801731:	00 
  801732:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801735:	89 04 24             	mov    %eax,(%esp)
  801738:	e8 52 ff ff ff       	call   80168f <fd_close>
}
  80173d:	c9                   	leave  
  80173e:	c3                   	ret    

0080173f <stat>:
	return (*dev->dev_stat)(fd, stat);
}

int
stat(const char *path, struct Stat *stat)
{
  80173f:	55                   	push   %ebp
  801740:	89 e5                	mov    %esp,%ebp
  801742:	83 ec 18             	sub    $0x18,%esp
  801745:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  801748:	89 75 fc             	mov    %esi,-0x4(%ebp)
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  80174b:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  801752:	00 
  801753:	8b 45 08             	mov    0x8(%ebp),%eax
  801756:	89 04 24             	mov    %eax,(%esp)
  801759:	e8 55 03 00 00       	call   801ab3 <open>
  80175e:	89 c3                	mov    %eax,%ebx
  801760:	85 c0                	test   %eax,%eax
  801762:	78 1b                	js     80177f <stat+0x40>
		return fd;
	r = fstat(fd, stat);
  801764:	8b 45 0c             	mov    0xc(%ebp),%eax
  801767:	89 44 24 04          	mov    %eax,0x4(%esp)
  80176b:	89 1c 24             	mov    %ebx,(%esp)
  80176e:	e8 b7 fc ff ff       	call   80142a <fstat>
  801773:	89 c6                	mov    %eax,%esi
	close(fd);
  801775:	89 1c 24             	mov    %ebx,(%esp)
  801778:	e8 91 ff ff ff       	call   80170e <close>
  80177d:	89 f3                	mov    %esi,%ebx
	return r;
}
  80177f:	89 d8                	mov    %ebx,%eax
  801781:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  801784:	8b 75 fc             	mov    -0x4(%ebp),%esi
  801787:	89 ec                	mov    %ebp,%esp
  801789:	5d                   	pop    %ebp
  80178a:	c3                   	ret    

0080178b <close_all>:
		return fd_close(fd, 1);
}

void
close_all(void)
{
  80178b:	55                   	push   %ebp
  80178c:	89 e5                	mov    %esp,%ebp
  80178e:	53                   	push   %ebx
  80178f:	83 ec 14             	sub    $0x14,%esp
  801792:	bb 00 00 00 00       	mov    $0x0,%ebx
	int i;
	for (i = 0; i < MAXFD; i++)
		close(i);
  801797:	89 1c 24             	mov    %ebx,(%esp)
  80179a:	e8 6f ff ff ff       	call   80170e <close>

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  80179f:	83 c3 01             	add    $0x1,%ebx
  8017a2:	83 fb 20             	cmp    $0x20,%ebx
  8017a5:	75 f0                	jne    801797 <close_all+0xc>
		close(i);
}
  8017a7:	83 c4 14             	add    $0x14,%esp
  8017aa:	5b                   	pop    %ebx
  8017ab:	5d                   	pop    %ebp
  8017ac:	c3                   	ret    

008017ad <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  8017ad:	55                   	push   %ebp
  8017ae:	89 e5                	mov    %esp,%ebp
  8017b0:	83 ec 58             	sub    $0x58,%esp
  8017b3:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  8017b6:	89 75 f8             	mov    %esi,-0x8(%ebp)
  8017b9:	89 7d fc             	mov    %edi,-0x4(%ebp)
  8017bc:	8b 7d 0c             	mov    0xc(%ebp),%edi
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  8017bf:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  8017c2:	89 44 24 04          	mov    %eax,0x4(%esp)
  8017c6:	8b 45 08             	mov    0x8(%ebp),%eax
  8017c9:	89 04 24             	mov    %eax,(%esp)
  8017cc:	e8 7c fb ff ff       	call   80134d <fd_lookup>
  8017d1:	89 c3                	mov    %eax,%ebx
  8017d3:	85 c0                	test   %eax,%eax
  8017d5:	0f 88 e0 00 00 00    	js     8018bb <dup+0x10e>
		return r;
	close(newfdnum);
  8017db:	89 3c 24             	mov    %edi,(%esp)
  8017de:	e8 2b ff ff ff       	call   80170e <close>

	newfd = INDEX2FD(newfdnum);
  8017e3:	8d b7 00 00 0d 00    	lea    0xd0000(%edi),%esi
  8017e9:	c1 e6 0c             	shl    $0xc,%esi
	ova = fd2data(oldfd);
  8017ec:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8017ef:	89 04 24             	mov    %eax,(%esp)
  8017f2:	e8 c9 fa ff ff       	call   8012c0 <fd2data>
  8017f7:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  8017f9:	89 34 24             	mov    %esi,(%esp)
  8017fc:	e8 bf fa ff ff       	call   8012c0 <fd2data>
  801801:	89 45 d4             	mov    %eax,-0x2c(%ebp)

	if ((vpd[PDX(ova)] & PTE_P) && (vpt[VPN(ova)] & PTE_P))
  801804:	89 da                	mov    %ebx,%edx
  801806:	89 d8                	mov    %ebx,%eax
  801808:	c1 e8 16             	shr    $0x16,%eax
  80180b:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801812:	a8 01                	test   $0x1,%al
  801814:	74 43                	je     801859 <dup+0xac>
  801816:	c1 ea 0c             	shr    $0xc,%edx
  801819:	8b 04 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%eax
  801820:	a8 01                	test   $0x1,%al
  801822:	74 35                	je     801859 <dup+0xac>
		if ((r = sys_page_map(0, ova, 0, nva, vpt[VPN(ova)] & PTE_USER)) < 0)
  801824:	8b 04 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%eax
  80182b:	25 07 0e 00 00       	and    $0xe07,%eax
  801830:	89 44 24 10          	mov    %eax,0x10(%esp)
  801834:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801837:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80183b:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801842:	00 
  801843:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801847:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80184e:	e8 1a f8 ff ff       	call   80106d <sys_page_map>
  801853:	89 c3                	mov    %eax,%ebx
  801855:	85 c0                	test   %eax,%eax
  801857:	78 3f                	js     801898 <dup+0xeb>
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, vpt[VPN(oldfd)] & PTE_USER)) < 0)
  801859:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80185c:	89 c2                	mov    %eax,%edx
  80185e:	c1 ea 0c             	shr    $0xc,%edx
  801861:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801868:	81 e2 07 0e 00 00    	and    $0xe07,%edx
  80186e:	89 54 24 10          	mov    %edx,0x10(%esp)
  801872:	89 74 24 0c          	mov    %esi,0xc(%esp)
  801876:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  80187d:	00 
  80187e:	89 44 24 04          	mov    %eax,0x4(%esp)
  801882:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801889:	e8 df f7 ff ff       	call   80106d <sys_page_map>
  80188e:	89 c3                	mov    %eax,%ebx
  801890:	85 c0                	test   %eax,%eax
  801892:	78 04                	js     801898 <dup+0xeb>
  801894:	89 fb                	mov    %edi,%ebx
  801896:	eb 23                	jmp    8018bb <dup+0x10e>
		goto err;

	return newfdnum;

err:
	sys_page_unmap(0, newfd);
  801898:	89 74 24 04          	mov    %esi,0x4(%esp)
  80189c:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8018a3:	e8 67 f7 ff ff       	call   80100f <sys_page_unmap>
	sys_page_unmap(0, nva);
  8018a8:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8018ab:	89 44 24 04          	mov    %eax,0x4(%esp)
  8018af:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8018b6:	e8 54 f7 ff ff       	call   80100f <sys_page_unmap>
	return r;
}
  8018bb:	89 d8                	mov    %ebx,%eax
  8018bd:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  8018c0:	8b 75 f8             	mov    -0x8(%ebp),%esi
  8018c3:	8b 7d fc             	mov    -0x4(%ebp),%edi
  8018c6:	89 ec                	mov    %ebp,%esp
  8018c8:	5d                   	pop    %ebp
  8018c9:	c3                   	ret    
	...

008018cc <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  8018cc:	55                   	push   %ebp
  8018cd:	89 e5                	mov    %esp,%ebp
  8018cf:	53                   	push   %ebx
  8018d0:	83 ec 14             	sub    $0x14,%esp
  8018d3:	89 d3                	mov    %edx,%ebx
	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", env->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(envs[1].env_id, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  8018d5:	8b 15 c8 00 c0 ee    	mov    0xeec000c8,%edx
  8018db:	c7 44 24 0c 07 00 00 	movl   $0x7,0xc(%esp)
  8018e2:	00 
  8018e3:	c7 44 24 08 00 30 80 	movl   $0x803000,0x8(%esp)
  8018ea:	00 
  8018eb:	89 44 24 04          	mov    %eax,0x4(%esp)
  8018ef:	89 14 24             	mov    %edx,(%esp)
  8018f2:	e8 b9 0c 00 00       	call   8025b0 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  8018f7:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  8018fe:	00 
  8018ff:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801903:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80190a:	e8 07 0d 00 00       	call   802616 <ipc_recv>
}
  80190f:	83 c4 14             	add    $0x14,%esp
  801912:	5b                   	pop    %ebx
  801913:	5d                   	pop    %ebp
  801914:	c3                   	ret    

00801915 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  801915:	55                   	push   %ebp
  801916:	89 e5                	mov    %esp,%ebp
  801918:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  80191b:	8b 45 08             	mov    0x8(%ebp),%eax
  80191e:	8b 40 0c             	mov    0xc(%eax),%eax
  801921:	a3 00 30 80 00       	mov    %eax,0x803000
	fsipcbuf.set_size.req_size = newsize;
  801926:	8b 45 0c             	mov    0xc(%ebp),%eax
  801929:	a3 04 30 80 00       	mov    %eax,0x803004
	return fsipc(FSREQ_SET_SIZE, NULL);
  80192e:	ba 00 00 00 00       	mov    $0x0,%edx
  801933:	b8 02 00 00 00       	mov    $0x2,%eax
  801938:	e8 8f ff ff ff       	call   8018cc <fsipc>
}
  80193d:	c9                   	leave  
  80193e:	c3                   	ret    

0080193f <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  80193f:	55                   	push   %ebp
  801940:	89 e5                	mov    %esp,%ebp
  801942:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  801945:	8b 45 08             	mov    0x8(%ebp),%eax
  801948:	8b 40 0c             	mov    0xc(%eax),%eax
  80194b:	a3 00 30 80 00       	mov    %eax,0x803000
	return fsipc(FSREQ_FLUSH, NULL);
  801950:	ba 00 00 00 00       	mov    $0x0,%edx
  801955:	b8 06 00 00 00       	mov    $0x6,%eax
  80195a:	e8 6d ff ff ff       	call   8018cc <fsipc>
}
  80195f:	c9                   	leave  
  801960:	c3                   	ret    

00801961 <sync>:
}

// Synchronize disk with buffer cache
int
sync(void)
{
  801961:	55                   	push   %ebp
  801962:	89 e5                	mov    %esp,%ebp
  801964:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  801967:	ba 00 00 00 00       	mov    $0x0,%edx
  80196c:	b8 08 00 00 00       	mov    $0x8,%eax
  801971:	e8 56 ff ff ff       	call   8018cc <fsipc>
}
  801976:	c9                   	leave  
  801977:	c3                   	ret    

00801978 <devfile_stat>:
	return fsipc(FSREQ_WRITE, NULL);	
}

static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  801978:	55                   	push   %ebp
  801979:	89 e5                	mov    %esp,%ebp
  80197b:	53                   	push   %ebx
  80197c:	83 ec 14             	sub    $0x14,%esp
  80197f:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  801982:	8b 45 08             	mov    0x8(%ebp),%eax
  801985:	8b 40 0c             	mov    0xc(%eax),%eax
  801988:	a3 00 30 80 00       	mov    %eax,0x803000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  80198d:	ba 00 00 00 00       	mov    $0x0,%edx
  801992:	b8 05 00 00 00       	mov    $0x5,%eax
  801997:	e8 30 ff ff ff       	call   8018cc <fsipc>
  80199c:	85 c0                	test   %eax,%eax
  80199e:	78 2b                	js     8019cb <devfile_stat+0x53>
		return r;
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  8019a0:	c7 44 24 04 00 30 80 	movl   $0x803000,0x4(%esp)
  8019a7:	00 
  8019a8:	89 1c 24             	mov    %ebx,(%esp)
  8019ab:	e8 2a ef ff ff       	call   8008da <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  8019b0:	a1 80 30 80 00       	mov    0x803080,%eax
  8019b5:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  8019bb:	a1 84 30 80 00       	mov    0x803084,%eax
  8019c0:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
  8019c6:	b8 00 00 00 00       	mov    $0x0,%eax
	return 0;
}
  8019cb:	83 c4 14             	add    $0x14,%esp
  8019ce:	5b                   	pop    %ebx
  8019cf:	5d                   	pop    %ebp
  8019d0:	c3                   	ret    

008019d1 <devfile_write>:
// Returns:
//	 The number of bytes successfully written.
//	 < 0 on error.
static ssize_t
devfile_write(struct Fd *fd, const void *buf, size_t n)
{
  8019d1:	55                   	push   %ebp
  8019d2:	89 e5                	mov    %esp,%ebp
  8019d4:	83 ec 18             	sub    $0x18,%esp
  8019d7:	8b 45 10             	mov    0x10(%ebp),%eax
  8019da:	3d f8 0f 00 00       	cmp    $0xff8,%eax
  8019df:	76 05                	jbe    8019e6 <devfile_write+0x15>
  8019e1:	b8 f8 0f 00 00       	mov    $0xff8,%eax
	// LAB 5: Your code here
	//panic("devfile_write not implemented");
	
	if (n > (PGSIZE - (sizeof(int) + sizeof(size_t))))
		n = PGSIZE - (sizeof(int) + sizeof(size_t));
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  8019e6:	8b 55 08             	mov    0x8(%ebp),%edx
  8019e9:	8b 52 0c             	mov    0xc(%edx),%edx
  8019ec:	89 15 00 30 80 00    	mov    %edx,0x803000
	fsipcbuf.write.req_n = n;
  8019f2:	a3 04 30 80 00       	mov    %eax,0x803004
	memmove (fsipcbuf.write.req_buf, (char*)buf, n);	
  8019f7:	89 44 24 08          	mov    %eax,0x8(%esp)
  8019fb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8019fe:	89 44 24 04          	mov    %eax,0x4(%esp)
  801a02:	c7 04 24 08 30 80 00 	movl   $0x803008,(%esp)
  801a09:	e8 87 f0 ff ff       	call   800a95 <memmove>
	return fsipc(FSREQ_WRITE, NULL);	
  801a0e:	ba 00 00 00 00       	mov    $0x0,%edx
  801a13:	b8 04 00 00 00       	mov    $0x4,%eax
  801a18:	e8 af fe ff ff       	call   8018cc <fsipc>
}
  801a1d:	c9                   	leave  
  801a1e:	c3                   	ret    

00801a1f <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  801a1f:	55                   	push   %ebp
  801a20:	89 e5                	mov    %esp,%ebp
  801a22:	53                   	push   %ebx
  801a23:	83 ec 14             	sub    $0x14,%esp
	// system server.
	// LAB 5: Your code here
	
	//panic("devfile_read not implemented");
	int r;
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  801a26:	8b 45 08             	mov    0x8(%ebp),%eax
  801a29:	8b 40 0c             	mov    0xc(%eax),%eax
  801a2c:	a3 00 30 80 00       	mov    %eax,0x803000
	fsipcbuf.read.req_n = n;
  801a31:	8b 45 10             	mov    0x10(%ebp),%eax
  801a34:	a3 04 30 80 00       	mov    %eax,0x803004
	if ((r = fsipc(FSREQ_READ, (void*)&fsipcbuf)) < 0)
  801a39:	ba 00 30 80 00       	mov    $0x803000,%edx
  801a3e:	b8 03 00 00 00       	mov    $0x3,%eax
  801a43:	e8 84 fe ff ff       	call   8018cc <fsipc>
  801a48:	89 c3                	mov    %eax,%ebx
  801a4a:	85 c0                	test   %eax,%eax
  801a4c:	78 17                	js     801a65 <devfile_read+0x46>
		return r;
	memmove((void*)buf, (void*)fsipcbuf.readRet.ret_buf, r);
  801a4e:	89 44 24 08          	mov    %eax,0x8(%esp)
  801a52:	c7 44 24 04 00 30 80 	movl   $0x803000,0x4(%esp)
  801a59:	00 
  801a5a:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a5d:	89 04 24             	mov    %eax,(%esp)
  801a60:	e8 30 f0 ff ff       	call   800a95 <memmove>
	return r;
}
  801a65:	89 d8                	mov    %ebx,%eax
  801a67:	83 c4 14             	add    $0x14,%esp
  801a6a:	5b                   	pop    %ebx
  801a6b:	5d                   	pop    %ebp
  801a6c:	c3                   	ret    

00801a6d <remove>:
}

// Delete a file
int
remove(const char *path)
{
  801a6d:	55                   	push   %ebp
  801a6e:	89 e5                	mov    %esp,%ebp
  801a70:	53                   	push   %ebx
  801a71:	83 ec 14             	sub    $0x14,%esp
  801a74:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (strlen(path) >= MAXPATHLEN)
  801a77:	89 1c 24             	mov    %ebx,(%esp)
  801a7a:	e8 11 ee ff ff       	call   800890 <strlen>
  801a7f:	89 c2                	mov    %eax,%edx
  801a81:	b8 f4 ff ff ff       	mov    $0xfffffff4,%eax
  801a86:	81 fa ff 03 00 00    	cmp    $0x3ff,%edx
  801a8c:	7f 1f                	jg     801aad <remove+0x40>
		return -E_BAD_PATH;
	strcpy(fsipcbuf.remove.req_path, path);
  801a8e:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801a92:	c7 04 24 00 30 80 00 	movl   $0x803000,(%esp)
  801a99:	e8 3c ee ff ff       	call   8008da <strcpy>
	return fsipc(FSREQ_REMOVE, NULL);
  801a9e:	ba 00 00 00 00       	mov    $0x0,%edx
  801aa3:	b8 07 00 00 00       	mov    $0x7,%eax
  801aa8:	e8 1f fe ff ff       	call   8018cc <fsipc>
}
  801aad:	83 c4 14             	add    $0x14,%esp
  801ab0:	5b                   	pop    %ebx
  801ab1:	5d                   	pop    %ebp
  801ab2:	c3                   	ret    

00801ab3 <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  801ab3:	55                   	push   %ebp
  801ab4:	89 e5                	mov    %esp,%ebp
  801ab6:	83 ec 28             	sub    $0x28,%esp
  801ab9:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  801abc:	89 75 fc             	mov    %esi,-0x4(%ebp)
  801abf:	8b 75 08             	mov    0x8(%ebp),%esi
	// file descriptor.

	// LAB 5: Your code here.
	// Code added by Swastika / Sandeep
	
	if (strlen(path) >= MAXPATHLEN)
  801ac2:	89 34 24             	mov    %esi,(%esp)
  801ac5:	e8 c6 ed ff ff       	call   800890 <strlen>
  801aca:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  801acf:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  801ad4:	7f 5e                	jg     801b34 <open+0x81>
		return -E_BAD_PATH;
	struct Fd * fd;
	int  r;
	if ((r = fd_alloc(&fd)) < 0)
  801ad6:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801ad9:	89 04 24             	mov    %eax,(%esp)
  801adc:	e8 fa f7 ff ff       	call   8012db <fd_alloc>
  801ae1:	89 c3                	mov    %eax,%ebx
  801ae3:	85 c0                	test   %eax,%eax
  801ae5:	78 4d                	js     801b34 <open+0x81>
		return r;
	strcpy (fsipcbuf.open.req_path, path);
  801ae7:	89 74 24 04          	mov    %esi,0x4(%esp)
  801aeb:	c7 04 24 00 30 80 00 	movl   $0x803000,(%esp)
  801af2:	e8 e3 ed ff ff       	call   8008da <strcpy>
	fsipcbuf.open.req_omode = mode;	
  801af7:	8b 45 0c             	mov    0xc(%ebp),%eax
  801afa:	a3 00 34 80 00       	mov    %eax,0x803400
	if ((r = fsipc(FSREQ_OPEN,(void*)fd)) < 0)
  801aff:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801b02:	b8 01 00 00 00       	mov    $0x1,%eax
  801b07:	e8 c0 fd ff ff       	call   8018cc <fsipc>
  801b0c:	89 c3                	mov    %eax,%ebx
  801b0e:	85 c0                	test   %eax,%eax
  801b10:	79 15                	jns    801b27 <open+0x74>
	{
		fd_close(fd,0);
  801b12:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  801b19:	00 
  801b1a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801b1d:	89 04 24             	mov    %eax,(%esp)
  801b20:	e8 6a fb ff ff       	call   80168f <fd_close>
		return r; 
  801b25:	eb 0d                	jmp    801b34 <open+0x81>
	}
	return fd2num(fd);
  801b27:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801b2a:	89 04 24             	mov    %eax,(%esp)
  801b2d:	e8 7e f7 ff ff       	call   8012b0 <fd2num>
  801b32:	89 c3                	mov    %eax,%ebx
	//panic("open not implemented");
}
  801b34:	89 d8                	mov    %ebx,%eax
  801b36:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  801b39:	8b 75 fc             	mov    -0x4(%ebp),%esi
  801b3c:	89 ec                	mov    %ebp,%esp
  801b3e:	5d                   	pop    %ebp
  801b3f:	c3                   	ret    

00801b40 <devsock_stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  801b40:	55                   	push   %ebp
  801b41:	89 e5                	mov    %esp,%ebp
  801b43:	83 ec 18             	sub    $0x18,%esp
	strcpy(stat->st_name, "<sock>");
  801b46:	c7 44 24 04 f4 2d 80 	movl   $0x802df4,0x4(%esp)
  801b4d:	00 
  801b4e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b51:	89 04 24             	mov    %eax,(%esp)
  801b54:	e8 81 ed ff ff       	call   8008da <strcpy>
	return 0;
}
  801b59:	b8 00 00 00 00       	mov    $0x0,%eax
  801b5e:	c9                   	leave  
  801b5f:	c3                   	ret    

00801b60 <devsock_close>:
	return nsipc_shutdown(r, how);
}

static int
devsock_close(struct Fd *fd)
{
  801b60:	55                   	push   %ebp
  801b61:	89 e5                	mov    %esp,%ebp
  801b63:	83 ec 18             	sub    $0x18,%esp
	return nsipc_close(fd->fd_sock.sockid);
  801b66:	8b 45 08             	mov    0x8(%ebp),%eax
  801b69:	8b 40 0c             	mov    0xc(%eax),%eax
  801b6c:	89 04 24             	mov    %eax,(%esp)
  801b6f:	e8 9e 02 00 00       	call   801e12 <nsipc_close>
}
  801b74:	c9                   	leave  
  801b75:	c3                   	ret    

00801b76 <devsock_write>:
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
}

static ssize_t
devsock_write(struct Fd *fd, const void *buf, size_t n)
{
  801b76:	55                   	push   %ebp
  801b77:	89 e5                	mov    %esp,%ebp
  801b79:	83 ec 18             	sub    $0x18,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  801b7c:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  801b83:	00 
  801b84:	8b 45 10             	mov    0x10(%ebp),%eax
  801b87:	89 44 24 08          	mov    %eax,0x8(%esp)
  801b8b:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b8e:	89 44 24 04          	mov    %eax,0x4(%esp)
  801b92:	8b 45 08             	mov    0x8(%ebp),%eax
  801b95:	8b 40 0c             	mov    0xc(%eax),%eax
  801b98:	89 04 24             	mov    %eax,(%esp)
  801b9b:	e8 ae 02 00 00       	call   801e4e <nsipc_send>
}
  801ba0:	c9                   	leave  
  801ba1:	c3                   	ret    

00801ba2 <devsock_read>:
	return nsipc_listen(r, backlog);
}

static ssize_t
devsock_read(struct Fd *fd, void *buf, size_t n)
{
  801ba2:	55                   	push   %ebp
  801ba3:	89 e5                	mov    %esp,%ebp
  801ba5:	83 ec 18             	sub    $0x18,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  801ba8:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  801baf:	00 
  801bb0:	8b 45 10             	mov    0x10(%ebp),%eax
  801bb3:	89 44 24 08          	mov    %eax,0x8(%esp)
  801bb7:	8b 45 0c             	mov    0xc(%ebp),%eax
  801bba:	89 44 24 04          	mov    %eax,0x4(%esp)
  801bbe:	8b 45 08             	mov    0x8(%ebp),%eax
  801bc1:	8b 40 0c             	mov    0xc(%eax),%eax
  801bc4:	89 04 24             	mov    %eax,(%esp)
  801bc7:	e8 f5 02 00 00       	call   801ec1 <nsipc_recv>
}
  801bcc:	c9                   	leave  
  801bcd:	c3                   	ret    

00801bce <alloc_sockfd>:
	return sfd->fd_sock.sockid;
}

static int
alloc_sockfd(int sockid)
{
  801bce:	55                   	push   %ebp
  801bcf:	89 e5                	mov    %esp,%ebp
  801bd1:	56                   	push   %esi
  801bd2:	53                   	push   %ebx
  801bd3:	83 ec 20             	sub    $0x20,%esp
  801bd6:	89 c6                	mov    %eax,%esi
	struct Fd *sfd;
	int r;

	if ((r = fd_alloc(&sfd)) < 0
  801bd8:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801bdb:	89 04 24             	mov    %eax,(%esp)
  801bde:	e8 f8 f6 ff ff       	call   8012db <fd_alloc>
  801be3:	89 c3                	mov    %eax,%ebx
  801be5:	85 c0                	test   %eax,%eax
  801be7:	78 21                	js     801c0a <alloc_sockfd+0x3c>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U)) < 0) {
  801be9:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  801bf0:	00 
  801bf1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801bf4:	89 44 24 04          	mov    %eax,0x4(%esp)
  801bf8:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801bff:	e8 c7 f4 ff ff       	call   8010cb <sys_page_alloc>
  801c04:	89 c3                	mov    %eax,%ebx
alloc_sockfd(int sockid)
{
	struct Fd *sfd;
	int r;

	if ((r = fd_alloc(&sfd)) < 0
  801c06:	85 c0                	test   %eax,%eax
  801c08:	79 0a                	jns    801c14 <alloc_sockfd+0x46>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U)) < 0) {
		nsipc_close(sockid);
  801c0a:	89 34 24             	mov    %esi,(%esp)
  801c0d:	e8 00 02 00 00       	call   801e12 <nsipc_close>
		return r;
  801c12:	eb 28                	jmp    801c3c <alloc_sockfd+0x6e>
	}

	sfd->fd_dev_id = devsock.dev_id;
  801c14:	8b 15 20 60 80 00    	mov    0x806020,%edx
  801c1a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c1d:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  801c1f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c22:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	sfd->fd_sock.sockid = sockid;
  801c29:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c2c:	89 70 0c             	mov    %esi,0xc(%eax)
	return fd2num(sfd);
  801c2f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c32:	89 04 24             	mov    %eax,(%esp)
  801c35:	e8 76 f6 ff ff       	call   8012b0 <fd2num>
  801c3a:	89 c3                	mov    %eax,%ebx
}
  801c3c:	89 d8                	mov    %ebx,%eax
  801c3e:	83 c4 20             	add    $0x20,%esp
  801c41:	5b                   	pop    %ebx
  801c42:	5e                   	pop    %esi
  801c43:	5d                   	pop    %ebp
  801c44:	c3                   	ret    

00801c45 <socket>:
	return 0;
}

int
socket(int domain, int type, int protocol)
{
  801c45:	55                   	push   %ebp
  801c46:	89 e5                	mov    %esp,%ebp
  801c48:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  801c4b:	8b 45 10             	mov    0x10(%ebp),%eax
  801c4e:	89 44 24 08          	mov    %eax,0x8(%esp)
  801c52:	8b 45 0c             	mov    0xc(%ebp),%eax
  801c55:	89 44 24 04          	mov    %eax,0x4(%esp)
  801c59:	8b 45 08             	mov    0x8(%ebp),%eax
  801c5c:	89 04 24             	mov    %eax,(%esp)
  801c5f:	e8 62 01 00 00       	call   801dc6 <nsipc_socket>
  801c64:	85 c0                	test   %eax,%eax
  801c66:	78 05                	js     801c6d <socket+0x28>
		return r;
	return alloc_sockfd(r);
  801c68:	e8 61 ff ff ff       	call   801bce <alloc_sockfd>
}
  801c6d:	c9                   	leave  
  801c6e:	66 90                	xchg   %ax,%ax
  801c70:	c3                   	ret    

00801c71 <fd2sockid>:
	.dev_stat =	devsock_stat,
};

static int
fd2sockid(int fd)
{
  801c71:	55                   	push   %ebp
  801c72:	89 e5                	mov    %esp,%ebp
  801c74:	83 ec 28             	sub    $0x28,%esp
	struct Fd *sfd;
	int r;

	if ((r = fd_lookup(fd, &sfd)) < 0)
  801c77:	8d 55 f4             	lea    -0xc(%ebp),%edx
  801c7a:	89 54 24 04          	mov    %edx,0x4(%esp)
  801c7e:	89 04 24             	mov    %eax,(%esp)
  801c81:	e8 c7 f6 ff ff       	call   80134d <fd_lookup>
  801c86:	85 c0                	test   %eax,%eax
  801c88:	78 15                	js     801c9f <fd2sockid+0x2e>
		return r;
	if (sfd->fd_dev_id != devsock.dev_id)
  801c8a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801c8d:	8b 0a                	mov    (%edx),%ecx
  801c8f:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801c94:	3b 0d 20 60 80 00    	cmp    0x806020,%ecx
  801c9a:	75 03                	jne    801c9f <fd2sockid+0x2e>
		return -E_NOT_SUPP;
	return sfd->fd_sock.sockid;
  801c9c:	8b 42 0c             	mov    0xc(%edx),%eax
}
  801c9f:	c9                   	leave  
  801ca0:	c3                   	ret    

00801ca1 <listen>:
	return nsipc_connect(r, name, namelen);
}

int
listen(int s, int backlog)
{
  801ca1:	55                   	push   %ebp
  801ca2:	89 e5                	mov    %esp,%ebp
  801ca4:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  801ca7:	8b 45 08             	mov    0x8(%ebp),%eax
  801caa:	e8 c2 ff ff ff       	call   801c71 <fd2sockid>
  801caf:	85 c0                	test   %eax,%eax
  801cb1:	78 0f                	js     801cc2 <listen+0x21>
		return r;
	return nsipc_listen(r, backlog);
  801cb3:	8b 55 0c             	mov    0xc(%ebp),%edx
  801cb6:	89 54 24 04          	mov    %edx,0x4(%esp)
  801cba:	89 04 24             	mov    %eax,(%esp)
  801cbd:	e8 2e 01 00 00       	call   801df0 <nsipc_listen>
}
  801cc2:	c9                   	leave  
  801cc3:	c3                   	ret    

00801cc4 <connect>:
	return nsipc_close(fd->fd_sock.sockid);
}

int
connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  801cc4:	55                   	push   %ebp
  801cc5:	89 e5                	mov    %esp,%ebp
  801cc7:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  801cca:	8b 45 08             	mov    0x8(%ebp),%eax
  801ccd:	e8 9f ff ff ff       	call   801c71 <fd2sockid>
  801cd2:	85 c0                	test   %eax,%eax
  801cd4:	78 16                	js     801cec <connect+0x28>
		return r;
	return nsipc_connect(r, name, namelen);
  801cd6:	8b 55 10             	mov    0x10(%ebp),%edx
  801cd9:	89 54 24 08          	mov    %edx,0x8(%esp)
  801cdd:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ce0:	89 54 24 04          	mov    %edx,0x4(%esp)
  801ce4:	89 04 24             	mov    %eax,(%esp)
  801ce7:	e8 55 02 00 00       	call   801f41 <nsipc_connect>
}
  801cec:	c9                   	leave  
  801ced:	c3                   	ret    

00801cee <shutdown>:
	return nsipc_bind(r, name, namelen);
}

int
shutdown(int s, int how)
{
  801cee:	55                   	push   %ebp
  801cef:	89 e5                	mov    %esp,%ebp
  801cf1:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  801cf4:	8b 45 08             	mov    0x8(%ebp),%eax
  801cf7:	e8 75 ff ff ff       	call   801c71 <fd2sockid>
  801cfc:	85 c0                	test   %eax,%eax
  801cfe:	78 0f                	js     801d0f <shutdown+0x21>
		return r;
	return nsipc_shutdown(r, how);
  801d00:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d03:	89 54 24 04          	mov    %edx,0x4(%esp)
  801d07:	89 04 24             	mov    %eax,(%esp)
  801d0a:	e8 1d 01 00 00       	call   801e2c <nsipc_shutdown>
}
  801d0f:	c9                   	leave  
  801d10:	c3                   	ret    

00801d11 <bind>:
	return alloc_sockfd(r);
}

int
bind(int s, struct sockaddr *name, socklen_t namelen)
{
  801d11:	55                   	push   %ebp
  801d12:	89 e5                	mov    %esp,%ebp
  801d14:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  801d17:	8b 45 08             	mov    0x8(%ebp),%eax
  801d1a:	e8 52 ff ff ff       	call   801c71 <fd2sockid>
  801d1f:	85 c0                	test   %eax,%eax
  801d21:	78 16                	js     801d39 <bind+0x28>
		return r;
	return nsipc_bind(r, name, namelen);
  801d23:	8b 55 10             	mov    0x10(%ebp),%edx
  801d26:	89 54 24 08          	mov    %edx,0x8(%esp)
  801d2a:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d2d:	89 54 24 04          	mov    %edx,0x4(%esp)
  801d31:	89 04 24             	mov    %eax,(%esp)
  801d34:	e8 47 02 00 00       	call   801f80 <nsipc_bind>
}
  801d39:	c9                   	leave  
  801d3a:	c3                   	ret    

00801d3b <accept>:
	return fd2num(sfd);
}

int
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  801d3b:	55                   	push   %ebp
  801d3c:	89 e5                	mov    %esp,%ebp
  801d3e:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  801d41:	8b 45 08             	mov    0x8(%ebp),%eax
  801d44:	e8 28 ff ff ff       	call   801c71 <fd2sockid>
  801d49:	85 c0                	test   %eax,%eax
  801d4b:	78 1f                	js     801d6c <accept+0x31>
		return r;
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  801d4d:	8b 55 10             	mov    0x10(%ebp),%edx
  801d50:	89 54 24 08          	mov    %edx,0x8(%esp)
  801d54:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d57:	89 54 24 04          	mov    %edx,0x4(%esp)
  801d5b:	89 04 24             	mov    %eax,(%esp)
  801d5e:	e8 5c 02 00 00       	call   801fbf <nsipc_accept>
  801d63:	85 c0                	test   %eax,%eax
  801d65:	78 05                	js     801d6c <accept+0x31>
		return r;
	return alloc_sockfd(r);
  801d67:	e8 62 fe ff ff       	call   801bce <alloc_sockfd>
}
  801d6c:	c9                   	leave  
  801d6d:	8d 76 00             	lea    0x0(%esi),%esi
  801d70:	c3                   	ret    
	...

00801d80 <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  801d80:	55                   	push   %ebp
  801d81:	89 e5                	mov    %esp,%ebp
  801d83:	83 ec 18             	sub    $0x18,%esp
	if (debug)
		cprintf("[%08x] nsipc %d\n", env->env_id, type);

	ipc_send(envs[2].env_id, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  801d86:	8b 15 44 01 c0 ee    	mov    0xeec00144,%edx
  801d8c:	c7 44 24 0c 07 00 00 	movl   $0x7,0xc(%esp)
  801d93:	00 
  801d94:	c7 44 24 08 00 50 80 	movl   $0x805000,0x8(%esp)
  801d9b:	00 
  801d9c:	89 44 24 04          	mov    %eax,0x4(%esp)
  801da0:	89 14 24             	mov    %edx,(%esp)
  801da3:	e8 08 08 00 00       	call   8025b0 <ipc_send>
	return ipc_recv(NULL, NULL, NULL);
  801da8:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801daf:	00 
  801db0:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  801db7:	00 
  801db8:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801dbf:	e8 52 08 00 00       	call   802616 <ipc_recv>
}
  801dc4:	c9                   	leave  
  801dc5:	c3                   	ret    

00801dc6 <nsipc_socket>:
	return nsipc(NSREQ_SEND);
}

int
nsipc_socket(int domain, int type, int protocol)
{
  801dc6:	55                   	push   %ebp
  801dc7:	89 e5                	mov    %esp,%ebp
  801dc9:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  801dcc:	8b 45 08             	mov    0x8(%ebp),%eax
  801dcf:	a3 00 50 80 00       	mov    %eax,0x805000
	nsipcbuf.socket.req_type = type;
  801dd4:	8b 45 0c             	mov    0xc(%ebp),%eax
  801dd7:	a3 04 50 80 00       	mov    %eax,0x805004
	nsipcbuf.socket.req_protocol = protocol;
  801ddc:	8b 45 10             	mov    0x10(%ebp),%eax
  801ddf:	a3 08 50 80 00       	mov    %eax,0x805008
	return nsipc(NSREQ_SOCKET);
  801de4:	b8 09 00 00 00       	mov    $0x9,%eax
  801de9:	e8 92 ff ff ff       	call   801d80 <nsipc>
}
  801dee:	c9                   	leave  
  801def:	c3                   	ret    

00801df0 <nsipc_listen>:
	return nsipc(NSREQ_CONNECT);
}

int
nsipc_listen(int s, int backlog)
{
  801df0:	55                   	push   %ebp
  801df1:	89 e5                	mov    %esp,%ebp
  801df3:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  801df6:	8b 45 08             	mov    0x8(%ebp),%eax
  801df9:	a3 00 50 80 00       	mov    %eax,0x805000
	nsipcbuf.listen.req_backlog = backlog;
  801dfe:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e01:	a3 04 50 80 00       	mov    %eax,0x805004
	return nsipc(NSREQ_LISTEN);
  801e06:	b8 06 00 00 00       	mov    $0x6,%eax
  801e0b:	e8 70 ff ff ff       	call   801d80 <nsipc>
}
  801e10:	c9                   	leave  
  801e11:	c3                   	ret    

00801e12 <nsipc_close>:
	return nsipc(NSREQ_SHUTDOWN);
}

int
nsipc_close(int s)
{
  801e12:	55                   	push   %ebp
  801e13:	89 e5                	mov    %esp,%ebp
  801e15:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  801e18:	8b 45 08             	mov    0x8(%ebp),%eax
  801e1b:	a3 00 50 80 00       	mov    %eax,0x805000
	return nsipc(NSREQ_CLOSE);
  801e20:	b8 04 00 00 00       	mov    $0x4,%eax
  801e25:	e8 56 ff ff ff       	call   801d80 <nsipc>
}
  801e2a:	c9                   	leave  
  801e2b:	c3                   	ret    

00801e2c <nsipc_shutdown>:
	return nsipc(NSREQ_BIND);
}

int
nsipc_shutdown(int s, int how)
{
  801e2c:	55                   	push   %ebp
  801e2d:	89 e5                	mov    %esp,%ebp
  801e2f:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  801e32:	8b 45 08             	mov    0x8(%ebp),%eax
  801e35:	a3 00 50 80 00       	mov    %eax,0x805000
	nsipcbuf.shutdown.req_how = how;
  801e3a:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e3d:	a3 04 50 80 00       	mov    %eax,0x805004
	return nsipc(NSREQ_SHUTDOWN);
  801e42:	b8 03 00 00 00       	mov    $0x3,%eax
  801e47:	e8 34 ff ff ff       	call   801d80 <nsipc>
}
  801e4c:	c9                   	leave  
  801e4d:	c3                   	ret    

00801e4e <nsipc_send>:
	return r;
}

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  801e4e:	55                   	push   %ebp
  801e4f:	89 e5                	mov    %esp,%ebp
  801e51:	53                   	push   %ebx
  801e52:	83 ec 14             	sub    $0x14,%esp
  801e55:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  801e58:	8b 45 08             	mov    0x8(%ebp),%eax
  801e5b:	a3 00 50 80 00       	mov    %eax,0x805000
	assert(size < 1600);
  801e60:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  801e66:	7e 24                	jle    801e8c <nsipc_send+0x3e>
  801e68:	c7 44 24 0c 00 2e 80 	movl   $0x802e00,0xc(%esp)
  801e6f:	00 
  801e70:	c7 44 24 08 0c 2e 80 	movl   $0x802e0c,0x8(%esp)
  801e77:	00 
  801e78:	c7 44 24 04 66 00 00 	movl   $0x66,0x4(%esp)
  801e7f:	00 
  801e80:	c7 04 24 21 2e 80 00 	movl   $0x802e21,(%esp)
  801e87:	e8 c4 e2 ff ff       	call   800150 <_panic>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  801e8c:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801e90:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e93:	89 44 24 04          	mov    %eax,0x4(%esp)
  801e97:	c7 04 24 0c 50 80 00 	movl   $0x80500c,(%esp)
  801e9e:	e8 f2 eb ff ff       	call   800a95 <memmove>
	nsipcbuf.send.req_size = size;
  801ea3:	89 1d 04 50 80 00    	mov    %ebx,0x805004
	nsipcbuf.send.req_flags = flags;
  801ea9:	8b 45 14             	mov    0x14(%ebp),%eax
  801eac:	a3 08 50 80 00       	mov    %eax,0x805008
	return nsipc(NSREQ_SEND);
  801eb1:	b8 08 00 00 00       	mov    $0x8,%eax
  801eb6:	e8 c5 fe ff ff       	call   801d80 <nsipc>
}
  801ebb:	83 c4 14             	add    $0x14,%esp
  801ebe:	5b                   	pop    %ebx
  801ebf:	5d                   	pop    %ebp
  801ec0:	c3                   	ret    

00801ec1 <nsipc_recv>:
	return nsipc(NSREQ_LISTEN);
}

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  801ec1:	55                   	push   %ebp
  801ec2:	89 e5                	mov    %esp,%ebp
  801ec4:	56                   	push   %esi
  801ec5:	53                   	push   %ebx
  801ec6:	83 ec 10             	sub    $0x10,%esp
  801ec9:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  801ecc:	8b 45 08             	mov    0x8(%ebp),%eax
  801ecf:	a3 00 50 80 00       	mov    %eax,0x805000
	nsipcbuf.recv.req_len = len;
  801ed4:	89 35 04 50 80 00    	mov    %esi,0x805004
	nsipcbuf.recv.req_flags = flags;
  801eda:	8b 45 14             	mov    0x14(%ebp),%eax
  801edd:	a3 08 50 80 00       	mov    %eax,0x805008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  801ee2:	b8 07 00 00 00       	mov    $0x7,%eax
  801ee7:	e8 94 fe ff ff       	call   801d80 <nsipc>
  801eec:	89 c3                	mov    %eax,%ebx
  801eee:	85 c0                	test   %eax,%eax
  801ef0:	78 46                	js     801f38 <nsipc_recv+0x77>
		assert(r < 1600 && r <= len);
  801ef2:	3d 3f 06 00 00       	cmp    $0x63f,%eax
  801ef7:	7f 04                	jg     801efd <nsipc_recv+0x3c>
  801ef9:	39 c6                	cmp    %eax,%esi
  801efb:	7d 24                	jge    801f21 <nsipc_recv+0x60>
  801efd:	c7 44 24 0c 2d 2e 80 	movl   $0x802e2d,0xc(%esp)
  801f04:	00 
  801f05:	c7 44 24 08 0c 2e 80 	movl   $0x802e0c,0x8(%esp)
  801f0c:	00 
  801f0d:	c7 44 24 04 5b 00 00 	movl   $0x5b,0x4(%esp)
  801f14:	00 
  801f15:	c7 04 24 21 2e 80 00 	movl   $0x802e21,(%esp)
  801f1c:	e8 2f e2 ff ff       	call   800150 <_panic>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  801f21:	89 44 24 08          	mov    %eax,0x8(%esp)
  801f25:	c7 44 24 04 00 50 80 	movl   $0x805000,0x4(%esp)
  801f2c:	00 
  801f2d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801f30:	89 04 24             	mov    %eax,(%esp)
  801f33:	e8 5d eb ff ff       	call   800a95 <memmove>
	}

	return r;
}
  801f38:	89 d8                	mov    %ebx,%eax
  801f3a:	83 c4 10             	add    $0x10,%esp
  801f3d:	5b                   	pop    %ebx
  801f3e:	5e                   	pop    %esi
  801f3f:	5d                   	pop    %ebp
  801f40:	c3                   	ret    

00801f41 <nsipc_connect>:
	return nsipc(NSREQ_CLOSE);
}

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  801f41:	55                   	push   %ebp
  801f42:	89 e5                	mov    %esp,%ebp
  801f44:	53                   	push   %ebx
  801f45:	83 ec 14             	sub    $0x14,%esp
  801f48:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  801f4b:	8b 45 08             	mov    0x8(%ebp),%eax
  801f4e:	a3 00 50 80 00       	mov    %eax,0x805000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  801f53:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801f57:	8b 45 0c             	mov    0xc(%ebp),%eax
  801f5a:	89 44 24 04          	mov    %eax,0x4(%esp)
  801f5e:	c7 04 24 04 50 80 00 	movl   $0x805004,(%esp)
  801f65:	e8 2b eb ff ff       	call   800a95 <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  801f6a:	89 1d 14 50 80 00    	mov    %ebx,0x805014
	return nsipc(NSREQ_CONNECT);
  801f70:	b8 05 00 00 00       	mov    $0x5,%eax
  801f75:	e8 06 fe ff ff       	call   801d80 <nsipc>
}
  801f7a:	83 c4 14             	add    $0x14,%esp
  801f7d:	5b                   	pop    %ebx
  801f7e:	5d                   	pop    %ebp
  801f7f:	c3                   	ret    

00801f80 <nsipc_bind>:
	return r;
}

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  801f80:	55                   	push   %ebp
  801f81:	89 e5                	mov    %esp,%ebp
  801f83:	53                   	push   %ebx
  801f84:	83 ec 14             	sub    $0x14,%esp
  801f87:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  801f8a:	8b 45 08             	mov    0x8(%ebp),%eax
  801f8d:	a3 00 50 80 00       	mov    %eax,0x805000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  801f92:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801f96:	8b 45 0c             	mov    0xc(%ebp),%eax
  801f99:	89 44 24 04          	mov    %eax,0x4(%esp)
  801f9d:	c7 04 24 04 50 80 00 	movl   $0x805004,(%esp)
  801fa4:	e8 ec ea ff ff       	call   800a95 <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  801fa9:	89 1d 14 50 80 00    	mov    %ebx,0x805014
	return nsipc(NSREQ_BIND);
  801faf:	b8 02 00 00 00       	mov    $0x2,%eax
  801fb4:	e8 c7 fd ff ff       	call   801d80 <nsipc>
}
  801fb9:	83 c4 14             	add    $0x14,%esp
  801fbc:	5b                   	pop    %ebx
  801fbd:	5d                   	pop    %ebp
  801fbe:	c3                   	ret    

00801fbf <nsipc_accept>:
	return ipc_recv(NULL, NULL, NULL);
}

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  801fbf:	55                   	push   %ebp
  801fc0:	89 e5                	mov    %esp,%ebp
  801fc2:	83 ec 18             	sub    $0x18,%esp
  801fc5:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  801fc8:	89 75 fc             	mov    %esi,-0x4(%ebp)
	int r;
	
	nsipcbuf.accept.req_s = s;
  801fcb:	8b 45 08             	mov    0x8(%ebp),%eax
  801fce:	a3 00 50 80 00       	mov    %eax,0x805000
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  801fd3:	b8 01 00 00 00       	mov    $0x1,%eax
  801fd8:	e8 a3 fd ff ff       	call   801d80 <nsipc>
  801fdd:	89 c3                	mov    %eax,%ebx
  801fdf:	85 c0                	test   %eax,%eax
  801fe1:	78 25                	js     802008 <nsipc_accept+0x49>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  801fe3:	be 10 50 80 00       	mov    $0x805010,%esi
  801fe8:	8b 06                	mov    (%esi),%eax
  801fea:	89 44 24 08          	mov    %eax,0x8(%esp)
  801fee:	c7 44 24 04 00 50 80 	movl   $0x805000,0x4(%esp)
  801ff5:	00 
  801ff6:	8b 45 0c             	mov    0xc(%ebp),%eax
  801ff9:	89 04 24             	mov    %eax,(%esp)
  801ffc:	e8 94 ea ff ff       	call   800a95 <memmove>
		*addrlen = ret->ret_addrlen;
  802001:	8b 16                	mov    (%esi),%edx
  802003:	8b 45 10             	mov    0x10(%ebp),%eax
  802006:	89 10                	mov    %edx,(%eax)
	}
	return r;
}
  802008:	89 d8                	mov    %ebx,%eax
  80200a:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  80200d:	8b 75 fc             	mov    -0x4(%ebp),%esi
  802010:	89 ec                	mov    %ebp,%esp
  802012:	5d                   	pop    %ebp
  802013:	c3                   	ret    
	...

00802020 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  802020:	55                   	push   %ebp
  802021:	89 e5                	mov    %esp,%ebp
  802023:	83 ec 18             	sub    $0x18,%esp
  802026:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  802029:	89 75 fc             	mov    %esi,-0x4(%ebp)
  80202c:	8b 75 0c             	mov    0xc(%ebp),%esi
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  80202f:	8b 45 08             	mov    0x8(%ebp),%eax
  802032:	89 04 24             	mov    %eax,(%esp)
  802035:	e8 86 f2 ff ff       	call   8012c0 <fd2data>
  80203a:	89 c3                	mov    %eax,%ebx
	strcpy(stat->st_name, "<pipe>");
  80203c:	c7 44 24 04 42 2e 80 	movl   $0x802e42,0x4(%esp)
  802043:	00 
  802044:	89 34 24             	mov    %esi,(%esp)
  802047:	e8 8e e8 ff ff       	call   8008da <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  80204c:	8b 43 04             	mov    0x4(%ebx),%eax
  80204f:	2b 03                	sub    (%ebx),%eax
  802051:	89 86 80 00 00 00    	mov    %eax,0x80(%esi)
	stat->st_isdir = 0;
  802057:	c7 86 84 00 00 00 00 	movl   $0x0,0x84(%esi)
  80205e:	00 00 00 
	stat->st_dev = &devpipe;
  802061:	c7 86 88 00 00 00 3c 	movl   $0x80603c,0x88(%esi)
  802068:	60 80 00 
	return 0;
}
  80206b:	b8 00 00 00 00       	mov    $0x0,%eax
  802070:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  802073:	8b 75 fc             	mov    -0x4(%ebp),%esi
  802076:	89 ec                	mov    %ebp,%esp
  802078:	5d                   	pop    %ebp
  802079:	c3                   	ret    

0080207a <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  80207a:	55                   	push   %ebp
  80207b:	89 e5                	mov    %esp,%ebp
  80207d:	53                   	push   %ebx
  80207e:	83 ec 14             	sub    $0x14,%esp
  802081:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  802084:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  802088:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80208f:	e8 7b ef ff ff       	call   80100f <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  802094:	89 1c 24             	mov    %ebx,(%esp)
  802097:	e8 24 f2 ff ff       	call   8012c0 <fd2data>
  80209c:	89 44 24 04          	mov    %eax,0x4(%esp)
  8020a0:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8020a7:	e8 63 ef ff ff       	call   80100f <sys_page_unmap>
}
  8020ac:	83 c4 14             	add    $0x14,%esp
  8020af:	5b                   	pop    %ebx
  8020b0:	5d                   	pop    %ebp
  8020b1:	c3                   	ret    

008020b2 <_pipeisclosed>:
	return r;
}

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  8020b2:	55                   	push   %ebp
  8020b3:	89 e5                	mov    %esp,%ebp
  8020b5:	57                   	push   %edi
  8020b6:	56                   	push   %esi
  8020b7:	53                   	push   %ebx
  8020b8:	83 ec 2c             	sub    $0x2c,%esp
  8020bb:	89 c7                	mov    %eax,%edi
  8020bd:	89 55 e4             	mov    %edx,-0x1c(%ebp)
	int n, nn, ret;

	while (1) {
		n = env->env_runs;
  8020c0:	a1 74 60 80 00       	mov    0x806074,%eax
  8020c5:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  8020c8:	89 3c 24             	mov    %edi,(%esp)
  8020cb:	e8 b0 05 00 00       	call   802680 <pageref>
  8020d0:	89 c6                	mov    %eax,%esi
  8020d2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8020d5:	89 04 24             	mov    %eax,(%esp)
  8020d8:	e8 a3 05 00 00       	call   802680 <pageref>
  8020dd:	39 c6                	cmp    %eax,%esi
  8020df:	0f 94 c0             	sete   %al
  8020e2:	0f b6 c0             	movzbl %al,%eax
		nn = env->env_runs;
  8020e5:	8b 15 74 60 80 00    	mov    0x806074,%edx
  8020eb:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  8020ee:	39 cb                	cmp    %ecx,%ebx
  8020f0:	75 08                	jne    8020fa <_pipeisclosed+0x48>
			return ret;
		if (n != nn && ret == 1)
			cprintf("pipe race avoided\n", n, env->env_runs, ret);
	}
}
  8020f2:	83 c4 2c             	add    $0x2c,%esp
  8020f5:	5b                   	pop    %ebx
  8020f6:	5e                   	pop    %esi
  8020f7:	5f                   	pop    %edi
  8020f8:	5d                   	pop    %ebp
  8020f9:	c3                   	ret    
		n = env->env_runs;
		ret = pageref(fd) == pageref(p);
		nn = env->env_runs;
		if (n == nn)
			return ret;
		if (n != nn && ret == 1)
  8020fa:	83 f8 01             	cmp    $0x1,%eax
  8020fd:	75 c1                	jne    8020c0 <_pipeisclosed+0xe>
			cprintf("pipe race avoided\n", n, env->env_runs, ret);
  8020ff:	8b 52 58             	mov    0x58(%edx),%edx
  802102:	89 44 24 0c          	mov    %eax,0xc(%esp)
  802106:	89 54 24 08          	mov    %edx,0x8(%esp)
  80210a:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  80210e:	c7 04 24 49 2e 80 00 	movl   $0x802e49,(%esp)
  802115:	e8 fb e0 ff ff       	call   800215 <cprintf>
  80211a:	eb a4                	jmp    8020c0 <_pipeisclosed+0xe>

0080211c <devpipe_write>:
	return i;
}

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  80211c:	55                   	push   %ebp
  80211d:	89 e5                	mov    %esp,%ebp
  80211f:	57                   	push   %edi
  802120:	56                   	push   %esi
  802121:	53                   	push   %ebx
  802122:	83 ec 1c             	sub    $0x1c,%esp
  802125:	8b 75 08             	mov    0x8(%ebp),%esi
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  802128:	89 34 24             	mov    %esi,(%esp)
  80212b:	e8 90 f1 ff ff       	call   8012c0 <fd2data>
  802130:	89 c3                	mov    %eax,%ebx
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			env->env_id, vpt[VPN(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  802132:	bf 00 00 00 00       	mov    $0x0,%edi
  802137:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80213b:	75 54                	jne    802191 <devpipe_write+0x75>
  80213d:	eb 60                	jmp    80219f <devpipe_write+0x83>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  80213f:	89 da                	mov    %ebx,%edx
  802141:	89 f0                	mov    %esi,%eax
  802143:	e8 6a ff ff ff       	call   8020b2 <_pipeisclosed>
  802148:	85 c0                	test   %eax,%eax
  80214a:	74 07                	je     802153 <devpipe_write+0x37>
  80214c:	b8 00 00 00 00       	mov    $0x0,%eax
  802151:	eb 53                	jmp    8021a6 <devpipe_write+0x8a>
				return 0;
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  802153:	90                   	nop
  802154:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802158:	e8 cd ef ff ff       	call   80112a <sys_yield>
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			env->env_id, vpt[VPN(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  80215d:	8b 43 04             	mov    0x4(%ebx),%eax
  802160:	8b 13                	mov    (%ebx),%edx
  802162:	83 c2 20             	add    $0x20,%edx
  802165:	39 d0                	cmp    %edx,%eax
  802167:	73 d6                	jae    80213f <devpipe_write+0x23>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  802169:	89 c2                	mov    %eax,%edx
  80216b:	c1 fa 1f             	sar    $0x1f,%edx
  80216e:	c1 ea 1b             	shr    $0x1b,%edx
  802171:	01 d0                	add    %edx,%eax
  802173:	83 e0 1f             	and    $0x1f,%eax
  802176:	29 d0                	sub    %edx,%eax
  802178:	89 c2                	mov    %eax,%edx
  80217a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80217d:	0f b6 04 39          	movzbl (%ecx,%edi,1),%eax
  802181:	88 44 13 08          	mov    %al,0x8(%ebx,%edx,1)
		p->p_wpos++;
  802185:	83 43 04 01          	addl   $0x1,0x4(%ebx)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			env->env_id, vpt[VPN(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  802189:	83 c7 01             	add    $0x1,%edi
  80218c:	39 7d 10             	cmp    %edi,0x10(%ebp)
  80218f:	76 13                	jbe    8021a4 <devpipe_write+0x88>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  802191:	8b 43 04             	mov    0x4(%ebx),%eax
  802194:	8b 13                	mov    (%ebx),%edx
  802196:	83 c2 20             	add    $0x20,%edx
  802199:	39 d0                	cmp    %edx,%eax
  80219b:	73 a2                	jae    80213f <devpipe_write+0x23>
  80219d:	eb ca                	jmp    802169 <devpipe_write+0x4d>
  80219f:	bf 00 00 00 00       	mov    $0x0,%edi
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}
	
	return i;
  8021a4:	89 f8                	mov    %edi,%eax
}
  8021a6:	83 c4 1c             	add    $0x1c,%esp
  8021a9:	5b                   	pop    %ebx
  8021aa:	5e                   	pop    %esi
  8021ab:	5f                   	pop    %edi
  8021ac:	5d                   	pop    %ebp
  8021ad:	c3                   	ret    

008021ae <devpipe_read>:
	return _pipeisclosed(fd, p);
}

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  8021ae:	55                   	push   %ebp
  8021af:	89 e5                	mov    %esp,%ebp
  8021b1:	83 ec 28             	sub    $0x28,%esp
  8021b4:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  8021b7:	89 75 f8             	mov    %esi,-0x8(%ebp)
  8021ba:	89 7d fc             	mov    %edi,-0x4(%ebp)
  8021bd:	8b 7d 08             	mov    0x8(%ebp),%edi
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  8021c0:	89 3c 24             	mov    %edi,(%esp)
  8021c3:	e8 f8 f0 ff ff       	call   8012c0 <fd2data>
  8021c8:	89 c3                	mov    %eax,%ebx
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			env->env_id, vpt[VPN(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  8021ca:	be 00 00 00 00       	mov    $0x0,%esi
  8021cf:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8021d3:	75 4c                	jne    802221 <devpipe_read+0x73>
  8021d5:	eb 5b                	jmp    802232 <devpipe_read+0x84>
		while (p->p_rpos == p->p_wpos) {
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
				return i;
  8021d7:	89 f0                	mov    %esi,%eax
  8021d9:	eb 5e                	jmp    802239 <devpipe_read+0x8b>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  8021db:	89 da                	mov    %ebx,%edx
  8021dd:	89 f8                	mov    %edi,%eax
  8021df:	90                   	nop
  8021e0:	e8 cd fe ff ff       	call   8020b2 <_pipeisclosed>
  8021e5:	85 c0                	test   %eax,%eax
  8021e7:	74 07                	je     8021f0 <devpipe_read+0x42>
  8021e9:	b8 00 00 00 00       	mov    $0x0,%eax
  8021ee:	eb 49                	jmp    802239 <devpipe_read+0x8b>
				return 0;
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  8021f0:	e8 35 ef ff ff       	call   80112a <sys_yield>
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			env->env_id, vpt[VPN(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  8021f5:	8b 03                	mov    (%ebx),%eax
  8021f7:	3b 43 04             	cmp    0x4(%ebx),%eax
  8021fa:	74 df                	je     8021db <devpipe_read+0x2d>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  8021fc:	89 c2                	mov    %eax,%edx
  8021fe:	c1 fa 1f             	sar    $0x1f,%edx
  802201:	c1 ea 1b             	shr    $0x1b,%edx
  802204:	01 d0                	add    %edx,%eax
  802206:	83 e0 1f             	and    $0x1f,%eax
  802209:	29 d0                	sub    %edx,%eax
  80220b:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  802210:	8b 55 0c             	mov    0xc(%ebp),%edx
  802213:	88 04 32             	mov    %al,(%edx,%esi,1)
		p->p_rpos++;
  802216:	83 03 01             	addl   $0x1,(%ebx)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			env->env_id, vpt[VPN(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  802219:	83 c6 01             	add    $0x1,%esi
  80221c:	39 75 10             	cmp    %esi,0x10(%ebp)
  80221f:	76 16                	jbe    802237 <devpipe_read+0x89>
		while (p->p_rpos == p->p_wpos) {
  802221:	8b 03                	mov    (%ebx),%eax
  802223:	3b 43 04             	cmp    0x4(%ebx),%eax
  802226:	75 d4                	jne    8021fc <devpipe_read+0x4e>
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  802228:	85 f6                	test   %esi,%esi
  80222a:	75 ab                	jne    8021d7 <devpipe_read+0x29>
  80222c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802230:	eb a9                	jmp    8021db <devpipe_read+0x2d>
  802232:	be 00 00 00 00       	mov    $0x0,%esi
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  802237:	89 f0                	mov    %esi,%eax
}
  802239:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  80223c:	8b 75 f8             	mov    -0x8(%ebp),%esi
  80223f:	8b 7d fc             	mov    -0x4(%ebp),%edi
  802242:	89 ec                	mov    %ebp,%esp
  802244:	5d                   	pop    %ebp
  802245:	c3                   	ret    

00802246 <pipeisclosed>:
	}
}

int
pipeisclosed(int fdnum)
{
  802246:	55                   	push   %ebp
  802247:	89 e5                	mov    %esp,%ebp
  802249:	83 ec 28             	sub    $0x28,%esp
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80224c:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80224f:	89 44 24 04          	mov    %eax,0x4(%esp)
  802253:	8b 45 08             	mov    0x8(%ebp),%eax
  802256:	89 04 24             	mov    %eax,(%esp)
  802259:	e8 ef f0 ff ff       	call   80134d <fd_lookup>
  80225e:	85 c0                	test   %eax,%eax
  802260:	78 15                	js     802277 <pipeisclosed+0x31>
		return r;
	p = (struct Pipe*) fd2data(fd);
  802262:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802265:	89 04 24             	mov    %eax,(%esp)
  802268:	e8 53 f0 ff ff       	call   8012c0 <fd2data>
	return _pipeisclosed(fd, p);
  80226d:	89 c2                	mov    %eax,%edx
  80226f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802272:	e8 3b fe ff ff       	call   8020b2 <_pipeisclosed>
}
  802277:	c9                   	leave  
  802278:	c3                   	ret    

00802279 <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  802279:	55                   	push   %ebp
  80227a:	89 e5                	mov    %esp,%ebp
  80227c:	83 ec 48             	sub    $0x48,%esp
  80227f:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  802282:	89 75 f8             	mov    %esi,-0x8(%ebp)
  802285:	89 7d fc             	mov    %edi,-0x4(%ebp)
  802288:	8b 7d 08             	mov    0x8(%ebp),%edi
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  80228b:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  80228e:	89 04 24             	mov    %eax,(%esp)
  802291:	e8 45 f0 ff ff       	call   8012db <fd_alloc>
  802296:	89 c3                	mov    %eax,%ebx
  802298:	85 c0                	test   %eax,%eax
  80229a:	0f 88 42 01 00 00    	js     8023e2 <pipe+0x169>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8022a0:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  8022a7:	00 
  8022a8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8022ab:	89 44 24 04          	mov    %eax,0x4(%esp)
  8022af:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8022b6:	e8 10 ee ff ff       	call   8010cb <sys_page_alloc>
  8022bb:	89 c3                	mov    %eax,%ebx
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  8022bd:	85 c0                	test   %eax,%eax
  8022bf:	0f 88 1d 01 00 00    	js     8023e2 <pipe+0x169>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  8022c5:	8d 45 e0             	lea    -0x20(%ebp),%eax
  8022c8:	89 04 24             	mov    %eax,(%esp)
  8022cb:	e8 0b f0 ff ff       	call   8012db <fd_alloc>
  8022d0:	89 c3                	mov    %eax,%ebx
  8022d2:	85 c0                	test   %eax,%eax
  8022d4:	0f 88 f5 00 00 00    	js     8023cf <pipe+0x156>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8022da:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  8022e1:	00 
  8022e2:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8022e5:	89 44 24 04          	mov    %eax,0x4(%esp)
  8022e9:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8022f0:	e8 d6 ed ff ff       	call   8010cb <sys_page_alloc>
  8022f5:	89 c3                	mov    %eax,%ebx
	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  8022f7:	85 c0                	test   %eax,%eax
  8022f9:	0f 88 d0 00 00 00    	js     8023cf <pipe+0x156>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  8022ff:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802302:	89 04 24             	mov    %eax,(%esp)
  802305:	e8 b6 ef ff ff       	call   8012c0 <fd2data>
  80230a:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80230c:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  802313:	00 
  802314:	89 44 24 04          	mov    %eax,0x4(%esp)
  802318:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80231f:	e8 a7 ed ff ff       	call   8010cb <sys_page_alloc>
  802324:	89 c3                	mov    %eax,%ebx
  802326:	85 c0                	test   %eax,%eax
  802328:	0f 88 8e 00 00 00    	js     8023bc <pipe+0x143>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80232e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802331:	89 04 24             	mov    %eax,(%esp)
  802334:	e8 87 ef ff ff       	call   8012c0 <fd2data>
  802339:	c7 44 24 10 07 04 00 	movl   $0x407,0x10(%esp)
  802340:	00 
  802341:	89 44 24 0c          	mov    %eax,0xc(%esp)
  802345:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  80234c:	00 
  80234d:	89 74 24 04          	mov    %esi,0x4(%esp)
  802351:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802358:	e8 10 ed ff ff       	call   80106d <sys_page_map>
  80235d:	89 c3                	mov    %eax,%ebx
  80235f:	85 c0                	test   %eax,%eax
  802361:	78 49                	js     8023ac <pipe+0x133>
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  802363:	b8 3c 60 80 00       	mov    $0x80603c,%eax
  802368:	8b 08                	mov    (%eax),%ecx
  80236a:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80236d:	89 0a                	mov    %ecx,(%edx)
	fd0->fd_omode = O_RDONLY;
  80236f:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802372:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%edx)

	fd1->fd_dev_id = devpipe.dev_id;
  802379:	8b 10                	mov    (%eax),%edx
  80237b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80237e:	89 10                	mov    %edx,(%eax)
	fd1->fd_omode = O_WRONLY;
  802380:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802383:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", env->env_id, vpt[VPN(va)]);

	pfd[0] = fd2num(fd0);
  80238a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80238d:	89 04 24             	mov    %eax,(%esp)
  802390:	e8 1b ef ff ff       	call   8012b0 <fd2num>
  802395:	89 07                	mov    %eax,(%edi)
	pfd[1] = fd2num(fd1);
  802397:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80239a:	89 04 24             	mov    %eax,(%esp)
  80239d:	e8 0e ef ff ff       	call   8012b0 <fd2num>
  8023a2:	89 47 04             	mov    %eax,0x4(%edi)
  8023a5:	bb 00 00 00 00       	mov    $0x0,%ebx
	return 0;
  8023aa:	eb 36                	jmp    8023e2 <pipe+0x169>

    err3:
	sys_page_unmap(0, va);
  8023ac:	89 74 24 04          	mov    %esi,0x4(%esp)
  8023b0:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8023b7:	e8 53 ec ff ff       	call   80100f <sys_page_unmap>
    err2:
	sys_page_unmap(0, fd1);
  8023bc:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8023bf:	89 44 24 04          	mov    %eax,0x4(%esp)
  8023c3:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8023ca:	e8 40 ec ff ff       	call   80100f <sys_page_unmap>
    err1:
	sys_page_unmap(0, fd0);
  8023cf:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8023d2:	89 44 24 04          	mov    %eax,0x4(%esp)
  8023d6:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8023dd:	e8 2d ec ff ff       	call   80100f <sys_page_unmap>
    err:
	return r;
}
  8023e2:	89 d8                	mov    %ebx,%eax
  8023e4:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  8023e7:	8b 75 f8             	mov    -0x8(%ebp),%esi
  8023ea:	8b 7d fc             	mov    -0x4(%ebp),%edi
  8023ed:	89 ec                	mov    %ebp,%esp
  8023ef:	5d                   	pop    %ebp
  8023f0:	c3                   	ret    
	...

00802400 <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  802400:	55                   	push   %ebp
  802401:	89 e5                	mov    %esp,%ebp
	USED(fd);

	return 0;
}
  802403:	b8 00 00 00 00       	mov    $0x0,%eax
  802408:	5d                   	pop    %ebp
  802409:	c3                   	ret    

0080240a <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  80240a:	55                   	push   %ebp
  80240b:	89 e5                	mov    %esp,%ebp
  80240d:	83 ec 18             	sub    $0x18,%esp
	strcpy(stat->st_name, "<cons>");
  802410:	c7 44 24 04 61 2e 80 	movl   $0x802e61,0x4(%esp)
  802417:	00 
  802418:	8b 45 0c             	mov    0xc(%ebp),%eax
  80241b:	89 04 24             	mov    %eax,(%esp)
  80241e:	e8 b7 e4 ff ff       	call   8008da <strcpy>
	return 0;
}
  802423:	b8 00 00 00 00       	mov    $0x0,%eax
  802428:	c9                   	leave  
  802429:	c3                   	ret    

0080242a <devcons_write>:
	return 1;
}

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  80242a:	55                   	push   %ebp
  80242b:	89 e5                	mov    %esp,%ebp
  80242d:	57                   	push   %edi
  80242e:	56                   	push   %esi
  80242f:	53                   	push   %ebx
  802430:	81 ec 9c 00 00 00    	sub    $0x9c,%esp
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs, 
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  802436:	b8 00 00 00 00       	mov    $0x0,%eax
  80243b:	be 00 00 00 00       	mov    $0x0,%esi
  802440:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  802444:	74 3f                	je     802485 <devcons_write+0x5b>
		m = n - tot;
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  802446:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs, 
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
		m = n - tot;
  80244c:	8b 55 10             	mov    0x10(%ebp),%edx
  80244f:	29 c2                	sub    %eax,%edx
  802451:	89 d3                	mov    %edx,%ebx
		if (m > sizeof(buf) - 1)
  802453:	83 fa 7f             	cmp    $0x7f,%edx
  802456:	76 05                	jbe    80245d <devcons_write+0x33>
  802458:	bb 7f 00 00 00       	mov    $0x7f,%ebx
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  80245d:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  802461:	03 45 0c             	add    0xc(%ebp),%eax
  802464:	89 44 24 04          	mov    %eax,0x4(%esp)
  802468:	89 3c 24             	mov    %edi,(%esp)
  80246b:	e8 25 e6 ff ff       	call   800a95 <memmove>
		sys_cputs(buf, m);
  802470:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  802474:	89 3c 24             	mov    %edi,(%esp)
  802477:	e8 54 e8 ff ff       	call   800cd0 <sys_cputs>
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs, 
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  80247c:	01 de                	add    %ebx,%esi
  80247e:	89 f0                	mov    %esi,%eax
  802480:	3b 75 10             	cmp    0x10(%ebp),%esi
  802483:	72 c7                	jb     80244c <devcons_write+0x22>
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
}
  802485:	89 f0                	mov    %esi,%eax
  802487:	81 c4 9c 00 00 00    	add    $0x9c,%esp
  80248d:	5b                   	pop    %ebx
  80248e:	5e                   	pop    %esi
  80248f:	5f                   	pop    %edi
  802490:	5d                   	pop    %ebp
  802491:	c3                   	ret    

00802492 <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  802492:	55                   	push   %ebp
  802493:	89 e5                	mov    %esp,%ebp
  802495:	83 ec 28             	sub    $0x28,%esp
	char c = ch;
  802498:	8b 45 08             	mov    0x8(%ebp),%eax
  80249b:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  80249e:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  8024a5:	00 
  8024a6:	8d 45 f7             	lea    -0x9(%ebp),%eax
  8024a9:	89 04 24             	mov    %eax,(%esp)
  8024ac:	e8 1f e8 ff ff       	call   800cd0 <sys_cputs>
}
  8024b1:	c9                   	leave  
  8024b2:	c3                   	ret    

008024b3 <devcons_read>:
	return fd2num(fd);
}

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  8024b3:	55                   	push   %ebp
  8024b4:	89 e5                	mov    %esp,%ebp
  8024b6:	83 ec 08             	sub    $0x8,%esp
	int c;

	if (n == 0)
  8024b9:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8024bd:	75 07                	jne    8024c6 <devcons_read+0x13>
  8024bf:	eb 28                	jmp    8024e9 <devcons_read+0x36>
		return 0;

	while ((c = sys_cgetc()) == 0)
		sys_yield();
  8024c1:	e8 64 ec ff ff       	call   80112a <sys_yield>
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  8024c6:	66 90                	xchg   %ax,%ax
  8024c8:	e8 cf e7 ff ff       	call   800c9c <sys_cgetc>
  8024cd:	85 c0                	test   %eax,%eax
  8024cf:	90                   	nop
  8024d0:	74 ef                	je     8024c1 <devcons_read+0xe>
  8024d2:	89 c2                	mov    %eax,%edx
		sys_yield();
	if (c < 0)
  8024d4:	85 c0                	test   %eax,%eax
  8024d6:	78 16                	js     8024ee <devcons_read+0x3b>
		return c;
	if (c == 0x04)	// ctl-d is eof
  8024d8:	83 f8 04             	cmp    $0x4,%eax
  8024db:	74 0c                	je     8024e9 <devcons_read+0x36>
		return 0;
	*(char*)vbuf = c;
  8024dd:	8b 45 0c             	mov    0xc(%ebp),%eax
  8024e0:	88 10                	mov    %dl,(%eax)
  8024e2:	b8 01 00 00 00       	mov    $0x1,%eax
	return 1;
  8024e7:	eb 05                	jmp    8024ee <devcons_read+0x3b>
  8024e9:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8024ee:	c9                   	leave  
  8024ef:	c3                   	ret    

008024f0 <opencons>:
	return fd->fd_dev_id == devcons.dev_id;
}

int
opencons(void)
{
  8024f0:	55                   	push   %ebp
  8024f1:	89 e5                	mov    %esp,%ebp
  8024f3:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  8024f6:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8024f9:	89 04 24             	mov    %eax,(%esp)
  8024fc:	e8 da ed ff ff       	call   8012db <fd_alloc>
  802501:	85 c0                	test   %eax,%eax
  802503:	78 3f                	js     802544 <opencons+0x54>
		return r;
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  802505:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  80250c:	00 
  80250d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802510:	89 44 24 04          	mov    %eax,0x4(%esp)
  802514:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80251b:	e8 ab eb ff ff       	call   8010cb <sys_page_alloc>
  802520:	85 c0                	test   %eax,%eax
  802522:	78 20                	js     802544 <opencons+0x54>
		return r;
	fd->fd_dev_id = devcons.dev_id;
  802524:	8b 15 58 60 80 00    	mov    0x806058,%edx
  80252a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80252d:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  80252f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802532:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  802539:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80253c:	89 04 24             	mov    %eax,(%esp)
  80253f:	e8 6c ed ff ff       	call   8012b0 <fd2num>
}
  802544:	c9                   	leave  
  802545:	c3                   	ret    

00802546 <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  802546:	55                   	push   %ebp
  802547:	89 e5                	mov    %esp,%ebp
  802549:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80254c:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80254f:	89 44 24 04          	mov    %eax,0x4(%esp)
  802553:	8b 45 08             	mov    0x8(%ebp),%eax
  802556:	89 04 24             	mov    %eax,(%esp)
  802559:	e8 ef ed ff ff       	call   80134d <fd_lookup>
  80255e:	85 c0                	test   %eax,%eax
  802560:	78 11                	js     802573 <iscons+0x2d>
		return r;
	return fd->fd_dev_id == devcons.dev_id;
  802562:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802565:	8b 00                	mov    (%eax),%eax
  802567:	3b 05 58 60 80 00    	cmp    0x806058,%eax
  80256d:	0f 94 c0             	sete   %al
  802570:	0f b6 c0             	movzbl %al,%eax
}
  802573:	c9                   	leave  
  802574:	c3                   	ret    

00802575 <getchar>:
	sys_cputs(&c, 1);
}

int
getchar(void)
{
  802575:	55                   	push   %ebp
  802576:	89 e5                	mov    %esp,%ebp
  802578:	83 ec 28             	sub    $0x28,%esp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  80257b:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  802582:	00 
  802583:	8d 45 f7             	lea    -0x9(%ebp),%eax
  802586:	89 44 24 04          	mov    %eax,0x4(%esp)
  80258a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802591:	e8 18 f0 ff ff       	call   8015ae <read>
	if (r < 0)
  802596:	85 c0                	test   %eax,%eax
  802598:	78 0f                	js     8025a9 <getchar+0x34>
		return r;
	if (r < 1)
  80259a:	85 c0                	test   %eax,%eax
  80259c:	7f 07                	jg     8025a5 <getchar+0x30>
  80259e:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  8025a3:	eb 04                	jmp    8025a9 <getchar+0x34>
		return -E_EOF;
	return c;
  8025a5:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  8025a9:	c9                   	leave  
  8025aa:	c3                   	ret    
  8025ab:	00 00                	add    %al,(%eax)
  8025ad:	00 00                	add    %al,(%eax)
	...

008025b0 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  8025b0:	55                   	push   %ebp
  8025b1:	89 e5                	mov    %esp,%ebp
  8025b3:	57                   	push   %edi
  8025b4:	56                   	push   %esi
  8025b5:	53                   	push   %ebx
  8025b6:	83 ec 1c             	sub    $0x1c,%esp
  8025b9:	8b 7d 0c             	mov    0xc(%ebp),%edi
  8025bc:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8025bf:	8b 75 14             	mov    0x14(%ebp),%esi
	// LAB 4: Your code here.
	int r;
	if (pg == NULL)
  8025c2:	85 db                	test   %ebx,%ebx
  8025c4:	75 2d                	jne    8025f3 <ipc_send+0x43>
  8025c6:	bb 00 00 c0 ee       	mov    $0xeec00000,%ebx
  8025cb:	eb 26                	jmp    8025f3 <ipc_send+0x43>
		pg = (void*)UTOP;
	while ((r = sys_ipc_try_send(to_env, val, pg, perm)) < 0)
	{
		if(r != -E_IPC_NOT_RECV)
  8025cd:	83 f8 f9             	cmp    $0xfffffff9,%eax
  8025d0:	74 1c                	je     8025ee <ipc_send+0x3e>
			panic("Panic in lib ipc.c : ipc_send() \n");
  8025d2:	c7 44 24 08 70 2e 80 	movl   $0x802e70,0x8(%esp)
  8025d9:	00 
  8025da:	c7 44 24 04 44 00 00 	movl   $0x44,0x4(%esp)
  8025e1:	00 
  8025e2:	c7 04 24 94 2e 80 00 	movl   $0x802e94,(%esp)
  8025e9:	e8 62 db ff ff       	call   800150 <_panic>
		sys_yield();
  8025ee:	e8 37 eb ff ff       	call   80112a <sys_yield>
{
	// LAB 4: Your code here.
	int r;
	if (pg == NULL)
		pg = (void*)UTOP;
	while ((r = sys_ipc_try_send(to_env, val, pg, perm)) < 0)
  8025f3:	89 74 24 0c          	mov    %esi,0xc(%esp)
  8025f7:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8025fb:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8025ff:	8b 45 08             	mov    0x8(%ebp),%eax
  802602:	89 04 24             	mov    %eax,(%esp)
  802605:	e8 b3 e8 ff ff       	call   800ebd <sys_ipc_try_send>
  80260a:	85 c0                	test   %eax,%eax
  80260c:	78 bf                	js     8025cd <ipc_send+0x1d>
		if(r != -E_IPC_NOT_RECV)
			panic("Panic in lib ipc.c : ipc_send() \n");
		sys_yield();
	}
	//panic("ipc_send not implemented");
}
  80260e:	83 c4 1c             	add    $0x1c,%esp
  802611:	5b                   	pop    %ebx
  802612:	5e                   	pop    %esi
  802613:	5f                   	pop    %edi
  802614:	5d                   	pop    %ebp
  802615:	c3                   	ret    

00802616 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  802616:	55                   	push   %ebp
  802617:	89 e5                	mov    %esp,%ebp
  802619:	56                   	push   %esi
  80261a:	53                   	push   %ebx
  80261b:	83 ec 10             	sub    $0x10,%esp
  80261e:	8b 5d 08             	mov    0x8(%ebp),%ebx
  802621:	8b 45 0c             	mov    0xc(%ebp),%eax
  802624:	8b 75 10             	mov    0x10(%ebp),%esi
	// LAB 4: Your code here.
	int r;

	if (pg == NULL)
  802627:	85 c0                	test   %eax,%eax
  802629:	75 05                	jne    802630 <ipc_recv+0x1a>
  80262b:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
		pg = (void*)UTOP;
	if ((r = sys_ipc_recv(pg)) < 0)
  802630:	89 04 24             	mov    %eax,(%esp)
  802633:	e8 28 e8 ff ff       	call   800e60 <sys_ipc_recv>
  802638:	85 c0                	test   %eax,%eax
  80263a:	79 16                	jns    802652 <ipc_recv+0x3c>
	{
		if (from_env_store != NULL)
  80263c:	85 db                	test   %ebx,%ebx
  80263e:	74 06                	je     802646 <ipc_recv+0x30>
			*from_env_store = 0;
  802640:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
		if(perm_store != NULL)
  802646:	85 f6                	test   %esi,%esi
  802648:	74 2c                	je     802676 <ipc_recv+0x60>
			*perm_store = 0;
  80264a:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
  802650:	eb 24                	jmp    802676 <ipc_recv+0x60>
		return r;
	}
	else
	{	
		if (from_env_store != NULL)
  802652:	85 db                	test   %ebx,%ebx
  802654:	74 0a                	je     802660 <ipc_recv+0x4a>
			*from_env_store = env->env_ipc_from;
  802656:	a1 74 60 80 00       	mov    0x806074,%eax
  80265b:	8b 40 74             	mov    0x74(%eax),%eax
  80265e:	89 03                	mov    %eax,(%ebx)
		if(perm_store != NULL)
  802660:	85 f6                	test   %esi,%esi
  802662:	74 0a                	je     80266e <ipc_recv+0x58>
			*perm_store = env->env_ipc_perm;
  802664:	a1 74 60 80 00       	mov    0x806074,%eax
  802669:	8b 40 78             	mov    0x78(%eax),%eax
  80266c:	89 06                	mov    %eax,(%esi)
		return env->env_ipc_value;
  80266e:	a1 74 60 80 00       	mov    0x806074,%eax
  802673:	8b 40 70             	mov    0x70(%eax),%eax
	}		
	//panic("ipc_recv not implemented");
	//return 0;
}
  802676:	83 c4 10             	add    $0x10,%esp
  802679:	5b                   	pop    %ebx
  80267a:	5e                   	pop    %esi
  80267b:	5d                   	pop    %ebp
  80267c:	c3                   	ret    
  80267d:	00 00                	add    %al,(%eax)
	...

00802680 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  802680:	55                   	push   %ebp
  802681:	89 e5                	mov    %esp,%ebp
	pte_t pte;

	if (!(vpd[PDX(v)] & PTE_P))
  802683:	8b 45 08             	mov    0x8(%ebp),%eax
  802686:	89 c2                	mov    %eax,%edx
  802688:	c1 ea 16             	shr    $0x16,%edx
  80268b:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  802692:	f6 c2 01             	test   $0x1,%dl
  802695:	74 26                	je     8026bd <pageref+0x3d>
		return 0;
	pte = vpt[VPN(v)];
  802697:	c1 e8 0c             	shr    $0xc,%eax
  80269a:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
	if (!(pte & PTE_P))
  8026a1:	a8 01                	test   $0x1,%al
  8026a3:	74 18                	je     8026bd <pageref+0x3d>
		return 0;
	return pages[PPN(pte)].pp_ref;
  8026a5:	c1 e8 0c             	shr    $0xc,%eax
  8026a8:	8d 14 40             	lea    (%eax,%eax,2),%edx
  8026ab:	c1 e2 02             	shl    $0x2,%edx
  8026ae:	b8 00 00 00 ef       	mov    $0xef000000,%eax
  8026b3:	0f b7 44 02 08       	movzwl 0x8(%edx,%eax,1),%eax
  8026b8:	0f b7 c0             	movzwl %ax,%eax
  8026bb:	eb 05                	jmp    8026c2 <pageref+0x42>
  8026bd:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8026c2:	5d                   	pop    %ebp
  8026c3:	c3                   	ret    
	...

008026d0 <__udivdi3>:
  8026d0:	55                   	push   %ebp
  8026d1:	89 e5                	mov    %esp,%ebp
  8026d3:	57                   	push   %edi
  8026d4:	56                   	push   %esi
  8026d5:	83 ec 10             	sub    $0x10,%esp
  8026d8:	8b 45 14             	mov    0x14(%ebp),%eax
  8026db:	8b 55 08             	mov    0x8(%ebp),%edx
  8026de:	8b 75 10             	mov    0x10(%ebp),%esi
  8026e1:	8b 7d 0c             	mov    0xc(%ebp),%edi
  8026e4:	85 c0                	test   %eax,%eax
  8026e6:	89 55 f0             	mov    %edx,-0x10(%ebp)
  8026e9:	75 35                	jne    802720 <__udivdi3+0x50>
  8026eb:	39 fe                	cmp    %edi,%esi
  8026ed:	77 61                	ja     802750 <__udivdi3+0x80>
  8026ef:	85 f6                	test   %esi,%esi
  8026f1:	75 0b                	jne    8026fe <__udivdi3+0x2e>
  8026f3:	b8 01 00 00 00       	mov    $0x1,%eax
  8026f8:	31 d2                	xor    %edx,%edx
  8026fa:	f7 f6                	div    %esi
  8026fc:	89 c6                	mov    %eax,%esi
  8026fe:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  802701:	31 d2                	xor    %edx,%edx
  802703:	89 f8                	mov    %edi,%eax
  802705:	f7 f6                	div    %esi
  802707:	89 c7                	mov    %eax,%edi
  802709:	89 c8                	mov    %ecx,%eax
  80270b:	f7 f6                	div    %esi
  80270d:	89 c1                	mov    %eax,%ecx
  80270f:	89 fa                	mov    %edi,%edx
  802711:	89 c8                	mov    %ecx,%eax
  802713:	83 c4 10             	add    $0x10,%esp
  802716:	5e                   	pop    %esi
  802717:	5f                   	pop    %edi
  802718:	5d                   	pop    %ebp
  802719:	c3                   	ret    
  80271a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  802720:	39 f8                	cmp    %edi,%eax
  802722:	77 1c                	ja     802740 <__udivdi3+0x70>
  802724:	0f bd d0             	bsr    %eax,%edx
  802727:	83 f2 1f             	xor    $0x1f,%edx
  80272a:	89 55 f4             	mov    %edx,-0xc(%ebp)
  80272d:	75 39                	jne    802768 <__udivdi3+0x98>
  80272f:	3b 75 f0             	cmp    -0x10(%ebp),%esi
  802732:	0f 86 a0 00 00 00    	jbe    8027d8 <__udivdi3+0x108>
  802738:	39 f8                	cmp    %edi,%eax
  80273a:	0f 82 98 00 00 00    	jb     8027d8 <__udivdi3+0x108>
  802740:	31 ff                	xor    %edi,%edi
  802742:	31 c9                	xor    %ecx,%ecx
  802744:	89 c8                	mov    %ecx,%eax
  802746:	89 fa                	mov    %edi,%edx
  802748:	83 c4 10             	add    $0x10,%esp
  80274b:	5e                   	pop    %esi
  80274c:	5f                   	pop    %edi
  80274d:	5d                   	pop    %ebp
  80274e:	c3                   	ret    
  80274f:	90                   	nop
  802750:	89 d1                	mov    %edx,%ecx
  802752:	89 fa                	mov    %edi,%edx
  802754:	89 c8                	mov    %ecx,%eax
  802756:	31 ff                	xor    %edi,%edi
  802758:	f7 f6                	div    %esi
  80275a:	89 c1                	mov    %eax,%ecx
  80275c:	89 fa                	mov    %edi,%edx
  80275e:	89 c8                	mov    %ecx,%eax
  802760:	83 c4 10             	add    $0x10,%esp
  802763:	5e                   	pop    %esi
  802764:	5f                   	pop    %edi
  802765:	5d                   	pop    %ebp
  802766:	c3                   	ret    
  802767:	90                   	nop
  802768:	0f b6 4d f4          	movzbl -0xc(%ebp),%ecx
  80276c:	89 f2                	mov    %esi,%edx
  80276e:	d3 e0                	shl    %cl,%eax
  802770:	89 45 ec             	mov    %eax,-0x14(%ebp)
  802773:	b8 20 00 00 00       	mov    $0x20,%eax
  802778:	2b 45 f4             	sub    -0xc(%ebp),%eax
  80277b:	89 c1                	mov    %eax,%ecx
  80277d:	d3 ea                	shr    %cl,%edx
  80277f:	0f b6 4d f4          	movzbl -0xc(%ebp),%ecx
  802783:	0b 55 ec             	or     -0x14(%ebp),%edx
  802786:	d3 e6                	shl    %cl,%esi
  802788:	89 c1                	mov    %eax,%ecx
  80278a:	89 75 e8             	mov    %esi,-0x18(%ebp)
  80278d:	89 fe                	mov    %edi,%esi
  80278f:	d3 ee                	shr    %cl,%esi
  802791:	0f b6 4d f4          	movzbl -0xc(%ebp),%ecx
  802795:	89 55 ec             	mov    %edx,-0x14(%ebp)
  802798:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80279b:	d3 e7                	shl    %cl,%edi
  80279d:	89 c1                	mov    %eax,%ecx
  80279f:	d3 ea                	shr    %cl,%edx
  8027a1:	09 d7                	or     %edx,%edi
  8027a3:	89 f2                	mov    %esi,%edx
  8027a5:	89 f8                	mov    %edi,%eax
  8027a7:	f7 75 ec             	divl   -0x14(%ebp)
  8027aa:	89 d6                	mov    %edx,%esi
  8027ac:	89 c7                	mov    %eax,%edi
  8027ae:	f7 65 e8             	mull   -0x18(%ebp)
  8027b1:	39 d6                	cmp    %edx,%esi
  8027b3:	89 55 ec             	mov    %edx,-0x14(%ebp)
  8027b6:	72 30                	jb     8027e8 <__udivdi3+0x118>
  8027b8:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8027bb:	0f b6 4d f4          	movzbl -0xc(%ebp),%ecx
  8027bf:	d3 e2                	shl    %cl,%edx
  8027c1:	39 c2                	cmp    %eax,%edx
  8027c3:	73 05                	jae    8027ca <__udivdi3+0xfa>
  8027c5:	3b 75 ec             	cmp    -0x14(%ebp),%esi
  8027c8:	74 1e                	je     8027e8 <__udivdi3+0x118>
  8027ca:	89 f9                	mov    %edi,%ecx
  8027cc:	31 ff                	xor    %edi,%edi
  8027ce:	e9 71 ff ff ff       	jmp    802744 <__udivdi3+0x74>
  8027d3:	90                   	nop
  8027d4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  8027d8:	31 ff                	xor    %edi,%edi
  8027da:	b9 01 00 00 00       	mov    $0x1,%ecx
  8027df:	e9 60 ff ff ff       	jmp    802744 <__udivdi3+0x74>
  8027e4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  8027e8:	8d 4f ff             	lea    -0x1(%edi),%ecx
  8027eb:	31 ff                	xor    %edi,%edi
  8027ed:	89 c8                	mov    %ecx,%eax
  8027ef:	89 fa                	mov    %edi,%edx
  8027f1:	83 c4 10             	add    $0x10,%esp
  8027f4:	5e                   	pop    %esi
  8027f5:	5f                   	pop    %edi
  8027f6:	5d                   	pop    %ebp
  8027f7:	c3                   	ret    
	...

00802800 <__umoddi3>:
  802800:	55                   	push   %ebp
  802801:	89 e5                	mov    %esp,%ebp
  802803:	57                   	push   %edi
  802804:	56                   	push   %esi
  802805:	83 ec 20             	sub    $0x20,%esp
  802808:	8b 55 14             	mov    0x14(%ebp),%edx
  80280b:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80280e:	8b 7d 10             	mov    0x10(%ebp),%edi
  802811:	8b 75 0c             	mov    0xc(%ebp),%esi
  802814:	85 d2                	test   %edx,%edx
  802816:	89 c8                	mov    %ecx,%eax
  802818:	89 4d f4             	mov    %ecx,-0xc(%ebp)
  80281b:	75 13                	jne    802830 <__umoddi3+0x30>
  80281d:	39 f7                	cmp    %esi,%edi
  80281f:	76 3f                	jbe    802860 <__umoddi3+0x60>
  802821:	89 f2                	mov    %esi,%edx
  802823:	f7 f7                	div    %edi
  802825:	89 d0                	mov    %edx,%eax
  802827:	31 d2                	xor    %edx,%edx
  802829:	83 c4 20             	add    $0x20,%esp
  80282c:	5e                   	pop    %esi
  80282d:	5f                   	pop    %edi
  80282e:	5d                   	pop    %ebp
  80282f:	c3                   	ret    
  802830:	39 f2                	cmp    %esi,%edx
  802832:	77 4c                	ja     802880 <__umoddi3+0x80>
  802834:	0f bd ca             	bsr    %edx,%ecx
  802837:	83 f1 1f             	xor    $0x1f,%ecx
  80283a:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  80283d:	75 51                	jne    802890 <__umoddi3+0x90>
  80283f:	3b 7d f4             	cmp    -0xc(%ebp),%edi
  802842:	0f 87 e0 00 00 00    	ja     802928 <__umoddi3+0x128>
  802848:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80284b:	29 f8                	sub    %edi,%eax
  80284d:	19 d6                	sbb    %edx,%esi
  80284f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802852:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802855:	89 f2                	mov    %esi,%edx
  802857:	83 c4 20             	add    $0x20,%esp
  80285a:	5e                   	pop    %esi
  80285b:	5f                   	pop    %edi
  80285c:	5d                   	pop    %ebp
  80285d:	c3                   	ret    
  80285e:	66 90                	xchg   %ax,%ax
  802860:	85 ff                	test   %edi,%edi
  802862:	75 0b                	jne    80286f <__umoddi3+0x6f>
  802864:	b8 01 00 00 00       	mov    $0x1,%eax
  802869:	31 d2                	xor    %edx,%edx
  80286b:	f7 f7                	div    %edi
  80286d:	89 c7                	mov    %eax,%edi
  80286f:	89 f0                	mov    %esi,%eax
  802871:	31 d2                	xor    %edx,%edx
  802873:	f7 f7                	div    %edi
  802875:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802878:	f7 f7                	div    %edi
  80287a:	eb a9                	jmp    802825 <__umoddi3+0x25>
  80287c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802880:	89 c8                	mov    %ecx,%eax
  802882:	89 f2                	mov    %esi,%edx
  802884:	83 c4 20             	add    $0x20,%esp
  802887:	5e                   	pop    %esi
  802888:	5f                   	pop    %edi
  802889:	5d                   	pop    %ebp
  80288a:	c3                   	ret    
  80288b:	90                   	nop
  80288c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802890:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
  802894:	d3 e2                	shl    %cl,%edx
  802896:	89 55 f4             	mov    %edx,-0xc(%ebp)
  802899:	ba 20 00 00 00       	mov    $0x20,%edx
  80289e:	2b 55 f0             	sub    -0x10(%ebp),%edx
  8028a1:	89 55 ec             	mov    %edx,-0x14(%ebp)
  8028a4:	0f b6 4d ec          	movzbl -0x14(%ebp),%ecx
  8028a8:	89 fa                	mov    %edi,%edx
  8028aa:	d3 ea                	shr    %cl,%edx
  8028ac:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
  8028b0:	0b 55 f4             	or     -0xc(%ebp),%edx
  8028b3:	d3 e7                	shl    %cl,%edi
  8028b5:	0f b6 4d ec          	movzbl -0x14(%ebp),%ecx
  8028b9:	89 55 f4             	mov    %edx,-0xc(%ebp)
  8028bc:	89 f2                	mov    %esi,%edx
  8028be:	89 7d e8             	mov    %edi,-0x18(%ebp)
  8028c1:	89 c7                	mov    %eax,%edi
  8028c3:	d3 ea                	shr    %cl,%edx
  8028c5:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
  8028c9:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  8028cc:	89 c2                	mov    %eax,%edx
  8028ce:	d3 e6                	shl    %cl,%esi
  8028d0:	0f b6 4d ec          	movzbl -0x14(%ebp),%ecx
  8028d4:	d3 ea                	shr    %cl,%edx
  8028d6:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
  8028da:	09 d6                	or     %edx,%esi
  8028dc:	89 f0                	mov    %esi,%eax
  8028de:	8b 75 e4             	mov    -0x1c(%ebp),%esi
  8028e1:	d3 e7                	shl    %cl,%edi
  8028e3:	89 f2                	mov    %esi,%edx
  8028e5:	f7 75 f4             	divl   -0xc(%ebp)
  8028e8:	89 d6                	mov    %edx,%esi
  8028ea:	f7 65 e8             	mull   -0x18(%ebp)
  8028ed:	39 d6                	cmp    %edx,%esi
  8028ef:	72 2b                	jb     80291c <__umoddi3+0x11c>
  8028f1:	39 c7                	cmp    %eax,%edi
  8028f3:	72 23                	jb     802918 <__umoddi3+0x118>
  8028f5:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
  8028f9:	29 c7                	sub    %eax,%edi
  8028fb:	19 d6                	sbb    %edx,%esi
  8028fd:	89 f0                	mov    %esi,%eax
  8028ff:	89 f2                	mov    %esi,%edx
  802901:	d3 ef                	shr    %cl,%edi
  802903:	0f b6 4d ec          	movzbl -0x14(%ebp),%ecx
  802907:	d3 e0                	shl    %cl,%eax
  802909:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
  80290d:	09 f8                	or     %edi,%eax
  80290f:	d3 ea                	shr    %cl,%edx
  802911:	83 c4 20             	add    $0x20,%esp
  802914:	5e                   	pop    %esi
  802915:	5f                   	pop    %edi
  802916:	5d                   	pop    %ebp
  802917:	c3                   	ret    
  802918:	39 d6                	cmp    %edx,%esi
  80291a:	75 d9                	jne    8028f5 <__umoddi3+0xf5>
  80291c:	2b 45 e8             	sub    -0x18(%ebp),%eax
  80291f:	1b 55 f4             	sbb    -0xc(%ebp),%edx
  802922:	eb d1                	jmp    8028f5 <__umoddi3+0xf5>
  802924:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802928:	39 f2                	cmp    %esi,%edx
  80292a:	0f 82 18 ff ff ff    	jb     802848 <__umoddi3+0x48>
  802930:	e9 1d ff ff ff       	jmp    802852 <__umoddi3+0x52>
