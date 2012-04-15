
obj/user/faultalloc:     file format elf32-i386


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
  80002c:	e8 c7 00 00 00       	call   8000f8 <libmain>
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
  80003a:	c7 04 24 70 00 80 00 	movl   $0x800070,(%esp)
  800041:	e8 ba 11 00 00       	call   801200 <set_pgfault_handler>
	cprintf("%s\n", (char*)0xDeadBeef);
  800046:	c7 44 24 04 ef be ad 	movl   $0xdeadbeef,0x4(%esp)
  80004d:	de 
  80004e:	c7 04 24 60 29 80 00 	movl   $0x802960,(%esp)
  800055:	e8 cf 01 00 00       	call   800229 <cprintf>
	cprintf("%s\n", (char*)0xCafeBffe);
  80005a:	c7 44 24 04 fe bf fe 	movl   $0xcafebffe,0x4(%esp)
  800061:	ca 
  800062:	c7 04 24 60 29 80 00 	movl   $0x802960,(%esp)
  800069:	e8 bb 01 00 00       	call   800229 <cprintf>
}
  80006e:	c9                   	leave  
  80006f:	c3                   	ret    

00800070 <handler>:

#include <inc/lib.h>

void
handler(struct UTrapframe *utf)
{
  800070:	55                   	push   %ebp
  800071:	89 e5                	mov    %esp,%ebp
  800073:	53                   	push   %ebx
  800074:	83 ec 24             	sub    $0x24,%esp
	int r;
	void *addr = (void*)utf->utf_fault_va;
  800077:	8b 45 08             	mov    0x8(%ebp),%eax
  80007a:	8b 18                	mov    (%eax),%ebx

	cprintf("fault %x\n", addr);
  80007c:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  800080:	c7 04 24 64 29 80 00 	movl   $0x802964,(%esp)
  800087:	e8 9d 01 00 00       	call   800229 <cprintf>
	if ((r = sys_page_alloc(0, ROUNDDOWN(addr, PGSIZE),
  80008c:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  800093:	00 
  800094:	89 d8                	mov    %ebx,%eax
  800096:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80009b:	89 44 24 04          	mov    %eax,0x4(%esp)
  80009f:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8000a6:	e8 30 10 00 00       	call   8010db <sys_page_alloc>
  8000ab:	85 c0                	test   %eax,%eax
  8000ad:	79 24                	jns    8000d3 <handler+0x63>
				PTE_P|PTE_U|PTE_W)) < 0)
		panic("allocating at %x in page fault handler: %e", addr, r);
  8000af:	89 44 24 10          	mov    %eax,0x10(%esp)
  8000b3:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  8000b7:	c7 44 24 08 80 29 80 	movl   $0x802980,0x8(%esp)
  8000be:	00 
  8000bf:	c7 44 24 04 0e 00 00 	movl   $0xe,0x4(%esp)
  8000c6:	00 
  8000c7:	c7 04 24 6e 29 80 00 	movl   $0x80296e,(%esp)
  8000ce:	e8 91 00 00 00       	call   800164 <_panic>
	snprintf((char*) addr, 100, "this string was faulted in at %x", addr);
  8000d3:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  8000d7:	c7 44 24 08 ac 29 80 	movl   $0x8029ac,0x8(%esp)
  8000de:	00 
  8000df:	c7 44 24 04 64 00 00 	movl   $0x64,0x4(%esp)
  8000e6:	00 
  8000e7:	89 1c 24             	mov    %ebx,(%esp)
  8000ea:	e8 5d 07 00 00       	call   80084c <snprintf>
}
  8000ef:	83 c4 24             	add    $0x24,%esp
  8000f2:	5b                   	pop    %ebx
  8000f3:	5d                   	pop    %ebp
  8000f4:	c3                   	ret    
  8000f5:	00 00                	add    %al,(%eax)
	...

008000f8 <libmain>:
volatile struct Env *env;
char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  8000f8:	55                   	push   %ebp
  8000f9:	89 e5                	mov    %esp,%ebp
  8000fb:	83 ec 18             	sub    $0x18,%esp
  8000fe:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  800101:	89 75 fc             	mov    %esi,-0x4(%ebp)
  800104:	8b 75 08             	mov    0x8(%ebp),%esi
  800107:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	// set env to point at our env structure in envs[].
	// LAB 3b: Your code here.
	// Code added by Swastika / Sandeep	
	envid_t envid = sys_getenvid();
  80010a:	e8 5f 10 00 00       	call   80116e <sys_getenvid>
	env = &envs[ENVX(envid)];
  80010f:	25 ff 03 00 00       	and    $0x3ff,%eax
  800114:	6b c0 7c             	imul   $0x7c,%eax,%eax
  800117:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  80011c:	a3 74 60 80 00       	mov    %eax,0x806074

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800121:	85 f6                	test   %esi,%esi
  800123:	7e 07                	jle    80012c <libmain+0x34>
		binaryname = argv[0];
  800125:	8b 03                	mov    (%ebx),%eax
  800127:	a3 00 60 80 00       	mov    %eax,0x806000

	// call user main routine
	umain(argc, argv);
  80012c:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  800130:	89 34 24             	mov    %esi,(%esp)
  800133:	e8 fc fe ff ff       	call   800034 <umain>

	// exit gracefully
	exit();
  800138:	e8 0b 00 00 00       	call   800148 <exit>
}
  80013d:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  800140:	8b 75 fc             	mov    -0x4(%ebp),%esi
  800143:	89 ec                	mov    %ebp,%esp
  800145:	5d                   	pop    %ebp
  800146:	c3                   	ret    
	...

00800148 <exit>:
#include <inc/lib.h>

void
exit(void)
{
  800148:	55                   	push   %ebp
  800149:	89 e5                	mov    %esp,%ebp
  80014b:	83 ec 18             	sub    $0x18,%esp
	close_all();
  80014e:	e8 48 16 00 00       	call   80179b <close_all>
	sys_env_destroy(0);
  800153:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80015a:	e8 43 10 00 00       	call   8011a2 <sys_env_destroy>
}
  80015f:	c9                   	leave  
  800160:	c3                   	ret    
  800161:	00 00                	add    %al,(%eax)
	...

00800164 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  800164:	55                   	push   %ebp
  800165:	89 e5                	mov    %esp,%ebp
  800167:	53                   	push   %ebx
  800168:	83 ec 14             	sub    $0x14,%esp
 * Panic is called on unresolvable fatal errors.
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
  80016b:	8d 5d 14             	lea    0x14(%ebp),%ebx
	va_list ap;

	va_start(ap, fmt);

	// Print the panic message
	if (argv0)
  80016e:	a1 78 60 80 00       	mov    0x806078,%eax
  800173:	85 c0                	test   %eax,%eax
  800175:	74 10                	je     800187 <_panic+0x23>
		cprintf("%s: ", argv0);
  800177:	89 44 24 04          	mov    %eax,0x4(%esp)
  80017b:	c7 04 24 e4 29 80 00 	movl   $0x8029e4,(%esp)
  800182:	e8 a2 00 00 00       	call   800229 <cprintf>
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  800187:	8b 45 0c             	mov    0xc(%ebp),%eax
  80018a:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80018e:	8b 45 08             	mov    0x8(%ebp),%eax
  800191:	89 44 24 08          	mov    %eax,0x8(%esp)
  800195:	a1 00 60 80 00       	mov    0x806000,%eax
  80019a:	89 44 24 04          	mov    %eax,0x4(%esp)
  80019e:	c7 04 24 e9 29 80 00 	movl   $0x8029e9,(%esp)
  8001a5:	e8 7f 00 00 00       	call   800229 <cprintf>
	vcprintf(fmt, ap);
  8001aa:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8001ae:	8b 45 10             	mov    0x10(%ebp),%eax
  8001b1:	89 04 24             	mov    %eax,(%esp)
  8001b4:	e8 0f 00 00 00       	call   8001c8 <vcprintf>
	cprintf("\n");
  8001b9:	c7 04 24 7a 2e 80 00 	movl   $0x802e7a,(%esp)
  8001c0:	e8 64 00 00 00       	call   800229 <cprintf>

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  8001c5:	cc                   	int3   
  8001c6:	eb fd                	jmp    8001c5 <_panic+0x61>

008001c8 <vcprintf>:
	b->cnt++;
}

int
vcprintf(const char *fmt, va_list ap)
{
  8001c8:	55                   	push   %ebp
  8001c9:	89 e5                	mov    %esp,%ebp
  8001cb:	81 ec 28 01 00 00    	sub    $0x128,%esp
	struct printbuf b;

	b.idx = 0;
  8001d1:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8001d8:	00 00 00 
	b.cnt = 0;
  8001db:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8001e2:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  8001e5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8001e8:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8001ec:	8b 45 08             	mov    0x8(%ebp),%eax
  8001ef:	89 44 24 08          	mov    %eax,0x8(%esp)
  8001f3:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8001f9:	89 44 24 04          	mov    %eax,0x4(%esp)
  8001fd:	c7 04 24 43 02 80 00 	movl   $0x800243,(%esp)
  800204:	e8 d4 01 00 00       	call   8003dd <vprintfmt>
	sys_cputs(b.buf, b.idx);
  800209:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
  80020f:	89 44 24 04          	mov    %eax,0x4(%esp)
  800213:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  800219:	89 04 24             	mov    %eax,(%esp)
  80021c:	e8 bf 0a 00 00       	call   800ce0 <sys_cputs>

	return b.cnt;
}
  800221:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  800227:	c9                   	leave  
  800228:	c3                   	ret    

00800229 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  800229:	55                   	push   %ebp
  80022a:	89 e5                	mov    %esp,%ebp
  80022c:	83 ec 18             	sub    $0x18,%esp

	return b.cnt;
}

int
cprintf(const char *fmt, ...)
  80022f:	8d 45 0c             	lea    0xc(%ebp),%eax
{
	va_list ap;
	int cnt;

	va_start(ap, fmt);
	cnt = vcprintf(fmt, ap);
  800232:	89 44 24 04          	mov    %eax,0x4(%esp)
  800236:	8b 45 08             	mov    0x8(%ebp),%eax
  800239:	89 04 24             	mov    %eax,(%esp)
  80023c:	e8 87 ff ff ff       	call   8001c8 <vcprintf>
	va_end(ap);

	return cnt;
}
  800241:	c9                   	leave  
  800242:	c3                   	ret    

00800243 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  800243:	55                   	push   %ebp
  800244:	89 e5                	mov    %esp,%ebp
  800246:	53                   	push   %ebx
  800247:	83 ec 14             	sub    $0x14,%esp
  80024a:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  80024d:	8b 03                	mov    (%ebx),%eax
  80024f:	8b 55 08             	mov    0x8(%ebp),%edx
  800252:	88 54 03 08          	mov    %dl,0x8(%ebx,%eax,1)
  800256:	83 c0 01             	add    $0x1,%eax
  800259:	89 03                	mov    %eax,(%ebx)
	if (b->idx == 256-1) {
  80025b:	3d ff 00 00 00       	cmp    $0xff,%eax
  800260:	75 19                	jne    80027b <putch+0x38>
		sys_cputs(b->buf, b->idx);
  800262:	c7 44 24 04 ff 00 00 	movl   $0xff,0x4(%esp)
  800269:	00 
  80026a:	8d 43 08             	lea    0x8(%ebx),%eax
  80026d:	89 04 24             	mov    %eax,(%esp)
  800270:	e8 6b 0a 00 00       	call   800ce0 <sys_cputs>
		b->idx = 0;
  800275:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
	}
	b->cnt++;
  80027b:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  80027f:	83 c4 14             	add    $0x14,%esp
  800282:	5b                   	pop    %ebx
  800283:	5d                   	pop    %ebp
  800284:	c3                   	ret    
	...

00800290 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800290:	55                   	push   %ebp
  800291:	89 e5                	mov    %esp,%ebp
  800293:	57                   	push   %edi
  800294:	56                   	push   %esi
  800295:	53                   	push   %ebx
  800296:	83 ec 4c             	sub    $0x4c,%esp
  800299:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80029c:	89 d6                	mov    %edx,%esi
  80029e:	8b 45 08             	mov    0x8(%ebp),%eax
  8002a1:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8002a4:	8b 55 0c             	mov    0xc(%ebp),%edx
  8002a7:	89 55 e0             	mov    %edx,-0x20(%ebp)
  8002aa:	8b 45 10             	mov    0x10(%ebp),%eax
  8002ad:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8002b0:	8b 7d 18             	mov    0x18(%ebp),%edi
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8002b3:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8002b6:	b9 00 00 00 00       	mov    $0x0,%ecx
  8002bb:	39 d1                	cmp    %edx,%ecx
  8002bd:	72 15                	jb     8002d4 <printnum+0x44>
  8002bf:	77 07                	ja     8002c8 <printnum+0x38>
  8002c1:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8002c4:	39 d0                	cmp    %edx,%eax
  8002c6:	76 0c                	jbe    8002d4 <printnum+0x44>
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8002c8:	83 eb 01             	sub    $0x1,%ebx
  8002cb:	85 db                	test   %ebx,%ebx
  8002cd:	8d 76 00             	lea    0x0(%esi),%esi
  8002d0:	7f 61                	jg     800333 <printnum+0xa3>
  8002d2:	eb 70                	jmp    800344 <printnum+0xb4>
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8002d4:	89 7c 24 10          	mov    %edi,0x10(%esp)
  8002d8:	83 eb 01             	sub    $0x1,%ebx
  8002db:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  8002df:	89 44 24 08          	mov    %eax,0x8(%esp)
  8002e3:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  8002e7:	8b 5c 24 0c          	mov    0xc(%esp),%ebx
  8002eb:	89 4d d0             	mov    %ecx,-0x30(%ebp)
  8002ee:	89 5d d4             	mov    %ebx,-0x2c(%ebp)
  8002f1:	8b 5d dc             	mov    -0x24(%ebp),%ebx
  8002f4:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8002f8:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  8002ff:	00 
  800300:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800303:	89 04 24             	mov    %eax,(%esp)
  800306:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800309:	89 54 24 04          	mov    %edx,0x4(%esp)
  80030d:	e8 ce 23 00 00       	call   8026e0 <__udivdi3>
  800312:	8b 4d d0             	mov    -0x30(%ebp),%ecx
  800315:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
  800318:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  80031c:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  800320:	89 04 24             	mov    %eax,(%esp)
  800323:	89 54 24 04          	mov    %edx,0x4(%esp)
  800327:	89 f2                	mov    %esi,%edx
  800329:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80032c:	e8 5f ff ff ff       	call   800290 <printnum>
  800331:	eb 11                	jmp    800344 <printnum+0xb4>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800333:	89 74 24 04          	mov    %esi,0x4(%esp)
  800337:	89 3c 24             	mov    %edi,(%esp)
  80033a:	ff 55 e4             	call   *-0x1c(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  80033d:	83 eb 01             	sub    $0x1,%ebx
  800340:	85 db                	test   %ebx,%ebx
  800342:	7f ef                	jg     800333 <printnum+0xa3>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800344:	89 74 24 04          	mov    %esi,0x4(%esp)
  800348:	8b 74 24 04          	mov    0x4(%esp),%esi
  80034c:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80034f:	89 44 24 08          	mov    %eax,0x8(%esp)
  800353:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  80035a:	00 
  80035b:	8b 55 d8             	mov    -0x28(%ebp),%edx
  80035e:	89 14 24             	mov    %edx,(%esp)
  800361:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  800364:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  800368:	e8 a3 24 00 00       	call   802810 <__umoddi3>
  80036d:	89 74 24 04          	mov    %esi,0x4(%esp)
  800371:	0f be 80 05 2a 80 00 	movsbl 0x802a05(%eax),%eax
  800378:	89 04 24             	mov    %eax,(%esp)
  80037b:	ff 55 e4             	call   *-0x1c(%ebp)
}
  80037e:	83 c4 4c             	add    $0x4c,%esp
  800381:	5b                   	pop    %ebx
  800382:	5e                   	pop    %esi
  800383:	5f                   	pop    %edi
  800384:	5d                   	pop    %ebp
  800385:	c3                   	ret    

00800386 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800386:	55                   	push   %ebp
  800387:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800389:	83 fa 01             	cmp    $0x1,%edx
  80038c:	7e 0e                	jle    80039c <getuint+0x16>
		return va_arg(*ap, unsigned long long);
  80038e:	8b 10                	mov    (%eax),%edx
  800390:	8d 4a 08             	lea    0x8(%edx),%ecx
  800393:	89 08                	mov    %ecx,(%eax)
  800395:	8b 02                	mov    (%edx),%eax
  800397:	8b 52 04             	mov    0x4(%edx),%edx
  80039a:	eb 22                	jmp    8003be <getuint+0x38>
	else if (lflag)
  80039c:	85 d2                	test   %edx,%edx
  80039e:	74 10                	je     8003b0 <getuint+0x2a>
		return va_arg(*ap, unsigned long);
  8003a0:	8b 10                	mov    (%eax),%edx
  8003a2:	8d 4a 04             	lea    0x4(%edx),%ecx
  8003a5:	89 08                	mov    %ecx,(%eax)
  8003a7:	8b 02                	mov    (%edx),%eax
  8003a9:	ba 00 00 00 00       	mov    $0x0,%edx
  8003ae:	eb 0e                	jmp    8003be <getuint+0x38>
	else
		return va_arg(*ap, unsigned int);
  8003b0:	8b 10                	mov    (%eax),%edx
  8003b2:	8d 4a 04             	lea    0x4(%edx),%ecx
  8003b5:	89 08                	mov    %ecx,(%eax)
  8003b7:	8b 02                	mov    (%edx),%eax
  8003b9:	ba 00 00 00 00       	mov    $0x0,%edx
}
  8003be:	5d                   	pop    %ebp
  8003bf:	c3                   	ret    

008003c0 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8003c0:	55                   	push   %ebp
  8003c1:	89 e5                	mov    %esp,%ebp
  8003c3:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  8003c6:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  8003ca:	8b 10                	mov    (%eax),%edx
  8003cc:	3b 50 04             	cmp    0x4(%eax),%edx
  8003cf:	73 0a                	jae    8003db <sprintputch+0x1b>
		*b->buf++ = ch;
  8003d1:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8003d4:	88 0a                	mov    %cl,(%edx)
  8003d6:	83 c2 01             	add    $0x1,%edx
  8003d9:	89 10                	mov    %edx,(%eax)
}
  8003db:	5d                   	pop    %ebp
  8003dc:	c3                   	ret    

008003dd <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  8003dd:	55                   	push   %ebp
  8003de:	89 e5                	mov    %esp,%ebp
  8003e0:	57                   	push   %edi
  8003e1:	56                   	push   %esi
  8003e2:	53                   	push   %ebx
  8003e3:	83 ec 5c             	sub    $0x5c,%esp
  8003e6:	8b 7d 08             	mov    0x8(%ebp),%edi
  8003e9:	8b 75 0c             	mov    0xc(%ebp),%esi
  8003ec:	8b 5d 10             	mov    0x10(%ebp),%ebx
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  8003ef:	c7 45 c8 ff ff ff ff 	movl   $0xffffffff,-0x38(%ebp)
  8003f6:	eb 11                	jmp    800409 <vprintfmt+0x2c>
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
  8003f8:	85 c0                	test   %eax,%eax
  8003fa:	0f 84 ec 03 00 00    	je     8007ec <vprintfmt+0x40f>
				return;
			putch(ch, putdat);
  800400:	89 74 24 04          	mov    %esi,0x4(%esp)
  800404:	89 04 24             	mov    %eax,(%esp)
  800407:	ff d7                	call   *%edi
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800409:	0f b6 03             	movzbl (%ebx),%eax
  80040c:	83 c3 01             	add    $0x1,%ebx
  80040f:	83 f8 25             	cmp    $0x25,%eax
  800412:	75 e4                	jne    8003f8 <vprintfmt+0x1b>
  800414:	c6 45 d4 20          	movb   $0x20,-0x2c(%ebp)
  800418:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
  80041f:	c7 45 d0 ff ff ff ff 	movl   $0xffffffff,-0x30(%ebp)
  800426:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
  80042d:	b9 00 00 00 00       	mov    $0x0,%ecx
  800432:	eb 06                	jmp    80043a <vprintfmt+0x5d>
  800434:	c6 45 d4 2d          	movb   $0x2d,-0x2c(%ebp)
  800438:	89 c3                	mov    %eax,%ebx
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80043a:	0f b6 13             	movzbl (%ebx),%edx
  80043d:	0f b6 c2             	movzbl %dl,%eax
  800440:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800443:	8d 43 01             	lea    0x1(%ebx),%eax
  800446:	83 ea 23             	sub    $0x23,%edx
  800449:	80 fa 55             	cmp    $0x55,%dl
  80044c:	0f 87 7d 03 00 00    	ja     8007cf <vprintfmt+0x3f2>
  800452:	0f b6 d2             	movzbl %dl,%edx
  800455:	ff 24 95 40 2b 80 00 	jmp    *0x802b40(,%edx,4)
  80045c:	c6 45 d4 30          	movb   $0x30,-0x2c(%ebp)
  800460:	eb d6                	jmp    800438 <vprintfmt+0x5b>
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
				precision = precision * 10 + ch - '0';
  800462:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800465:	83 ea 30             	sub    $0x30,%edx
  800468:	89 55 d0             	mov    %edx,-0x30(%ebp)
				ch = *fmt;
  80046b:	0f be 10             	movsbl (%eax),%edx
				if (ch < '0' || ch > '9')
  80046e:	8d 5a d0             	lea    -0x30(%edx),%ebx
  800471:	83 fb 09             	cmp    $0x9,%ebx
  800474:	77 4c                	ja     8004c2 <vprintfmt+0xe5>
  800476:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  800479:	8b 4d d0             	mov    -0x30(%ebp),%ecx
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  80047c:	83 c0 01             	add    $0x1,%eax
				precision = precision * 10 + ch - '0';
  80047f:	8d 0c 89             	lea    (%ecx,%ecx,4),%ecx
  800482:	8d 4c 4a d0          	lea    -0x30(%edx,%ecx,2),%ecx
				ch = *fmt;
  800486:	0f be 10             	movsbl (%eax),%edx
				if (ch < '0' || ch > '9')
  800489:	8d 5a d0             	lea    -0x30(%edx),%ebx
  80048c:	83 fb 09             	cmp    $0x9,%ebx
  80048f:	76 eb                	jbe    80047c <vprintfmt+0x9f>
  800491:	89 4d d0             	mov    %ecx,-0x30(%ebp)
  800494:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  800497:	eb 29                	jmp    8004c2 <vprintfmt+0xe5>
					break;
			}
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800499:	8b 55 14             	mov    0x14(%ebp),%edx
  80049c:	8d 5a 04             	lea    0x4(%edx),%ebx
  80049f:	89 5d 14             	mov    %ebx,0x14(%ebp)
  8004a2:	8b 12                	mov    (%edx),%edx
  8004a4:	89 55 d0             	mov    %edx,-0x30(%ebp)
			goto process_precision;
  8004a7:	eb 19                	jmp    8004c2 <vprintfmt+0xe5>

		case '.':
			if (width < 0)
  8004a9:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8004ac:	c1 fa 1f             	sar    $0x1f,%edx
  8004af:	f7 d2                	not    %edx
  8004b1:	21 55 e4             	and    %edx,-0x1c(%ebp)
  8004b4:	eb 82                	jmp    800438 <vprintfmt+0x5b>
  8004b6:	c7 45 d8 01 00 00 00 	movl   $0x1,-0x28(%ebp)
				width = 0;
			goto reswitch;

		case '#':
			altflag = 1;
			goto reswitch;
  8004bd:	e9 76 ff ff ff       	jmp    800438 <vprintfmt+0x5b>

		process_precision:
			if (width < 0)
  8004c2:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8004c6:	0f 89 6c ff ff ff    	jns    800438 <vprintfmt+0x5b>
  8004cc:	8b 55 d0             	mov    -0x30(%ebp),%edx
  8004cf:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  8004d2:	8b 55 c8             	mov    -0x38(%ebp),%edx
  8004d5:	89 55 d0             	mov    %edx,-0x30(%ebp)
  8004d8:	e9 5b ff ff ff       	jmp    800438 <vprintfmt+0x5b>
				width = precision, precision = -1;
			goto reswitch;

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  8004dd:	83 c1 01             	add    $0x1,%ecx
			goto reswitch;
  8004e0:	e9 53 ff ff ff       	jmp    800438 <vprintfmt+0x5b>
  8004e5:	89 45 cc             	mov    %eax,-0x34(%ebp)

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  8004e8:	8b 45 14             	mov    0x14(%ebp),%eax
  8004eb:	8d 50 04             	lea    0x4(%eax),%edx
  8004ee:	89 55 14             	mov    %edx,0x14(%ebp)
  8004f1:	89 74 24 04          	mov    %esi,0x4(%esp)
  8004f5:	8b 00                	mov    (%eax),%eax
  8004f7:	89 04 24             	mov    %eax,(%esp)
  8004fa:	ff d7                	call   *%edi
  8004fc:	8b 5d cc             	mov    -0x34(%ebp),%ebx
			break;
  8004ff:	e9 05 ff ff ff       	jmp    800409 <vprintfmt+0x2c>
  800504:	89 45 cc             	mov    %eax,-0x34(%ebp)

		// error message
		case 'e':
			err = va_arg(ap, int);
  800507:	8b 45 14             	mov    0x14(%ebp),%eax
  80050a:	8d 50 04             	lea    0x4(%eax),%edx
  80050d:	89 55 14             	mov    %edx,0x14(%ebp)
  800510:	8b 00                	mov    (%eax),%eax
  800512:	89 c2                	mov    %eax,%edx
  800514:	c1 fa 1f             	sar    $0x1f,%edx
  800517:	31 d0                	xor    %edx,%eax
  800519:	29 d0                	sub    %edx,%eax
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  80051b:	83 f8 0f             	cmp    $0xf,%eax
  80051e:	7f 0b                	jg     80052b <vprintfmt+0x14e>
  800520:	8b 14 85 a0 2c 80 00 	mov    0x802ca0(,%eax,4),%edx
  800527:	85 d2                	test   %edx,%edx
  800529:	75 20                	jne    80054b <vprintfmt+0x16e>
				printfmt(putch, putdat, "error %d", err);
  80052b:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80052f:	c7 44 24 08 16 2a 80 	movl   $0x802a16,0x8(%esp)
  800536:	00 
  800537:	89 74 24 04          	mov    %esi,0x4(%esp)
  80053b:	89 3c 24             	mov    %edi,(%esp)
  80053e:	e8 31 03 00 00       	call   800874 <printfmt>
  800543:	8b 5d cc             	mov    -0x34(%ebp),%ebx
		// error message
		case 'e':
			err = va_arg(ap, int);
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800546:	e9 be fe ff ff       	jmp    800409 <vprintfmt+0x2c>
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  80054b:	89 54 24 0c          	mov    %edx,0xc(%esp)
  80054f:	c7 44 24 08 3e 2e 80 	movl   $0x802e3e,0x8(%esp)
  800556:	00 
  800557:	89 74 24 04          	mov    %esi,0x4(%esp)
  80055b:	89 3c 24             	mov    %edi,(%esp)
  80055e:	e8 11 03 00 00       	call   800874 <printfmt>
  800563:	8b 5d cc             	mov    -0x34(%ebp),%ebx
  800566:	e9 9e fe ff ff       	jmp    800409 <vprintfmt+0x2c>
  80056b:	89 45 cc             	mov    %eax,-0x34(%ebp)
  80056e:	89 c3                	mov    %eax,%ebx
  800570:	8b 4d d0             	mov    -0x30(%ebp),%ecx
  800573:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800576:	89 45 c4             	mov    %eax,-0x3c(%ebp)
			break;

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800579:	8b 45 14             	mov    0x14(%ebp),%eax
  80057c:	8d 50 04             	lea    0x4(%eax),%edx
  80057f:	89 55 14             	mov    %edx,0x14(%ebp)
  800582:	8b 00                	mov    (%eax),%eax
  800584:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800587:	85 c0                	test   %eax,%eax
  800589:	75 07                	jne    800592 <vprintfmt+0x1b5>
  80058b:	c7 45 e0 1f 2a 80 00 	movl   $0x802a1f,-0x20(%ebp)
				p = "(null)";
			if (width > 0 && padc != '-')
  800592:	83 7d c4 00          	cmpl   $0x0,-0x3c(%ebp)
  800596:	7e 06                	jle    80059e <vprintfmt+0x1c1>
  800598:	80 7d d4 2d          	cmpb   $0x2d,-0x2c(%ebp)
  80059c:	75 13                	jne    8005b1 <vprintfmt+0x1d4>
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  80059e:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8005a1:	0f be 02             	movsbl (%edx),%eax
  8005a4:	85 c0                	test   %eax,%eax
  8005a6:	0f 85 99 00 00 00    	jne    800645 <vprintfmt+0x268>
  8005ac:	e9 86 00 00 00       	jmp    800637 <vprintfmt+0x25a>
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  8005b1:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8005b5:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  8005b8:	89 0c 24             	mov    %ecx,(%esp)
  8005bb:	e8 fb 02 00 00       	call   8008bb <strnlen>
  8005c0:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  8005c3:	29 c2                	sub    %eax,%edx
  8005c5:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  8005c8:	85 d2                	test   %edx,%edx
  8005ca:	7e d2                	jle    80059e <vprintfmt+0x1c1>
					putch(padc, putdat);
  8005cc:	0f be 4d d4          	movsbl -0x2c(%ebp),%ecx
  8005d0:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  8005d3:	89 5d c4             	mov    %ebx,-0x3c(%ebp)
  8005d6:	89 d3                	mov    %edx,%ebx
  8005d8:	89 74 24 04          	mov    %esi,0x4(%esp)
  8005dc:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8005df:	89 04 24             	mov    %eax,(%esp)
  8005e2:	ff d7                	call   *%edi
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  8005e4:	83 eb 01             	sub    $0x1,%ebx
  8005e7:	85 db                	test   %ebx,%ebx
  8005e9:	7f ed                	jg     8005d8 <vprintfmt+0x1fb>
  8005eb:	8b 5d c4             	mov    -0x3c(%ebp),%ebx
  8005ee:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  8005f5:	eb a7                	jmp    80059e <vprintfmt+0x1c1>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
  8005f7:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  8005fb:	74 18                	je     800615 <vprintfmt+0x238>
  8005fd:	8d 50 e0             	lea    -0x20(%eax),%edx
  800600:	83 fa 5e             	cmp    $0x5e,%edx
  800603:	76 10                	jbe    800615 <vprintfmt+0x238>
					putch('?', putdat);
  800605:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800609:	c7 04 24 3f 00 00 00 	movl   $0x3f,(%esp)
  800610:	ff 55 e0             	call   *-0x20(%ebp)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
  800613:	eb 0a                	jmp    80061f <vprintfmt+0x242>
					putch('?', putdat);
				else
					putch(ch, putdat);
  800615:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800619:	89 04 24             	mov    %eax,(%esp)
  80061c:	ff 55 e0             	call   *-0x20(%ebp)
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  80061f:	83 6d e4 01          	subl   $0x1,-0x1c(%ebp)
  800623:	0f be 03             	movsbl (%ebx),%eax
  800626:	85 c0                	test   %eax,%eax
  800628:	74 05                	je     80062f <vprintfmt+0x252>
  80062a:	83 c3 01             	add    $0x1,%ebx
  80062d:	eb 29                	jmp    800658 <vprintfmt+0x27b>
  80062f:	89 fe                	mov    %edi,%esi
  800631:	8b 7d e0             	mov    -0x20(%ebp),%edi
  800634:	8b 5d d0             	mov    -0x30(%ebp),%ebx
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800637:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80063b:	7f 2e                	jg     80066b <vprintfmt+0x28e>
  80063d:	8b 5d cc             	mov    -0x34(%ebp),%ebx
  800640:	e9 c4 fd ff ff       	jmp    800409 <vprintfmt+0x2c>
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800645:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800648:	83 c2 01             	add    $0x1,%edx
  80064b:	89 7d e0             	mov    %edi,-0x20(%ebp)
  80064e:	89 f7                	mov    %esi,%edi
  800650:	8b 75 d0             	mov    -0x30(%ebp),%esi
  800653:	89 5d d0             	mov    %ebx,-0x30(%ebp)
  800656:	89 d3                	mov    %edx,%ebx
  800658:	85 f6                	test   %esi,%esi
  80065a:	78 9b                	js     8005f7 <vprintfmt+0x21a>
  80065c:	83 ee 01             	sub    $0x1,%esi
  80065f:	79 96                	jns    8005f7 <vprintfmt+0x21a>
  800661:	89 fe                	mov    %edi,%esi
  800663:	8b 7d e0             	mov    -0x20(%ebp),%edi
  800666:	8b 5d d0             	mov    -0x30(%ebp),%ebx
  800669:	eb cc                	jmp    800637 <vprintfmt+0x25a>
  80066b:	89 5d d8             	mov    %ebx,-0x28(%ebp)
  80066e:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
				putch(' ', putdat);
  800671:	89 74 24 04          	mov    %esi,0x4(%esp)
  800675:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  80067c:	ff d7                	call   *%edi
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  80067e:	83 eb 01             	sub    $0x1,%ebx
  800681:	85 db                	test   %ebx,%ebx
  800683:	7f ec                	jg     800671 <vprintfmt+0x294>
  800685:	8b 5d d8             	mov    -0x28(%ebp),%ebx
  800688:	e9 7c fd ff ff       	jmp    800409 <vprintfmt+0x2c>
  80068d:	89 45 cc             	mov    %eax,-0x34(%ebp)
// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
	if (lflag >= 2)
  800690:	83 f9 01             	cmp    $0x1,%ecx
  800693:	7e 16                	jle    8006ab <vprintfmt+0x2ce>
		return va_arg(*ap, long long);
  800695:	8b 45 14             	mov    0x14(%ebp),%eax
  800698:	8d 50 08             	lea    0x8(%eax),%edx
  80069b:	89 55 14             	mov    %edx,0x14(%ebp)
  80069e:	8b 10                	mov    (%eax),%edx
  8006a0:	8b 48 04             	mov    0x4(%eax),%ecx
  8006a3:	89 55 d8             	mov    %edx,-0x28(%ebp)
  8006a6:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  8006a9:	eb 32                	jmp    8006dd <vprintfmt+0x300>
	else if (lflag)
  8006ab:	85 c9                	test   %ecx,%ecx
  8006ad:	74 18                	je     8006c7 <vprintfmt+0x2ea>
		return va_arg(*ap, long);
  8006af:	8b 45 14             	mov    0x14(%ebp),%eax
  8006b2:	8d 50 04             	lea    0x4(%eax),%edx
  8006b5:	89 55 14             	mov    %edx,0x14(%ebp)
  8006b8:	8b 00                	mov    (%eax),%eax
  8006ba:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8006bd:	89 c1                	mov    %eax,%ecx
  8006bf:	c1 f9 1f             	sar    $0x1f,%ecx
  8006c2:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  8006c5:	eb 16                	jmp    8006dd <vprintfmt+0x300>
	else
		return va_arg(*ap, int);
  8006c7:	8b 45 14             	mov    0x14(%ebp),%eax
  8006ca:	8d 50 04             	lea    0x4(%eax),%edx
  8006cd:	89 55 14             	mov    %edx,0x14(%ebp)
  8006d0:	8b 00                	mov    (%eax),%eax
  8006d2:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8006d5:	89 c2                	mov    %eax,%edx
  8006d7:	c1 fa 1f             	sar    $0x1f,%edx
  8006da:	89 55 dc             	mov    %edx,-0x24(%ebp)
				putch(' ', putdat);
			break;

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  8006dd:	8b 4d d8             	mov    -0x28(%ebp),%ecx
  8006e0:	8b 5d dc             	mov    -0x24(%ebp),%ebx
  8006e3:	b8 0a 00 00 00       	mov    $0xa,%eax
			if ((long long) num < 0) {
  8006e8:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8006ec:	0f 89 9b 00 00 00    	jns    80078d <vprintfmt+0x3b0>
				putch('-', putdat);
  8006f2:	89 74 24 04          	mov    %esi,0x4(%esp)
  8006f6:	c7 04 24 2d 00 00 00 	movl   $0x2d,(%esp)
  8006fd:	ff d7                	call   *%edi
				num = -(long long) num;
  8006ff:	8b 4d d8             	mov    -0x28(%ebp),%ecx
  800702:	8b 5d dc             	mov    -0x24(%ebp),%ebx
  800705:	f7 d9                	neg    %ecx
  800707:	83 d3 00             	adc    $0x0,%ebx
  80070a:	f7 db                	neg    %ebx
  80070c:	b8 0a 00 00 00       	mov    $0xa,%eax
  800711:	eb 7a                	jmp    80078d <vprintfmt+0x3b0>
  800713:	89 45 cc             	mov    %eax,-0x34(%ebp)
			base = 10;
			goto number;

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800716:	89 ca                	mov    %ecx,%edx
  800718:	8d 45 14             	lea    0x14(%ebp),%eax
  80071b:	e8 66 fc ff ff       	call   800386 <getuint>
  800720:	89 c1                	mov    %eax,%ecx
  800722:	89 d3                	mov    %edx,%ebx
  800724:	b8 0a 00 00 00       	mov    $0xa,%eax
			base = 10;
			goto number;
  800729:	eb 62                	jmp    80078d <vprintfmt+0x3b0>
  80072b:	89 45 cc             	mov    %eax,-0x34(%ebp)
		case 'o':
			// Replace this with your code.
			// putch('X', putdat);
			// putch('X', putdat);
			// putch('X', putdat);
			num = getuint(&ap, lflag);
  80072e:	89 ca                	mov    %ecx,%edx
  800730:	8d 45 14             	lea    0x14(%ebp),%eax
  800733:	e8 4e fc ff ff       	call   800386 <getuint>
  800738:	89 c1                	mov    %eax,%ecx
  80073a:	89 d3                	mov    %edx,%ebx
  80073c:	b8 08 00 00 00       	mov    $0x8,%eax
			base = 8;
			goto number;
  800741:	eb 4a                	jmp    80078d <vprintfmt+0x3b0>
  800743:	89 45 cc             	mov    %eax,-0x34(%ebp)
			break;

		// pointer
		case 'p':
			putch('0', putdat);
  800746:	89 74 24 04          	mov    %esi,0x4(%esp)
  80074a:	c7 04 24 30 00 00 00 	movl   $0x30,(%esp)
  800751:	ff d7                	call   *%edi
			putch('x', putdat);
  800753:	89 74 24 04          	mov    %esi,0x4(%esp)
  800757:	c7 04 24 78 00 00 00 	movl   $0x78,(%esp)
  80075e:	ff d7                	call   *%edi
			num = (unsigned long long)
  800760:	8b 45 14             	mov    0x14(%ebp),%eax
  800763:	8d 50 04             	lea    0x4(%eax),%edx
  800766:	89 55 14             	mov    %edx,0x14(%ebp)
  800769:	8b 08                	mov    (%eax),%ecx
  80076b:	bb 00 00 00 00       	mov    $0x0,%ebx
  800770:	b8 10 00 00 00       	mov    $0x10,%eax
				(uintptr_t) va_arg(ap, void *);
			base = 16;
			goto number;
  800775:	eb 16                	jmp    80078d <vprintfmt+0x3b0>
  800777:	89 45 cc             	mov    %eax,-0x34(%ebp)

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  80077a:	89 ca                	mov    %ecx,%edx
  80077c:	8d 45 14             	lea    0x14(%ebp),%eax
  80077f:	e8 02 fc ff ff       	call   800386 <getuint>
  800784:	89 c1                	mov    %eax,%ecx
  800786:	89 d3                	mov    %edx,%ebx
  800788:	b8 10 00 00 00       	mov    $0x10,%eax
			base = 16;
		number:
			printnum(putch, putdat, num, base, width, padc);
  80078d:	0f be 55 d4          	movsbl -0x2c(%ebp),%edx
  800791:	89 54 24 10          	mov    %edx,0x10(%esp)
  800795:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  800798:	89 54 24 0c          	mov    %edx,0xc(%esp)
  80079c:	89 44 24 08          	mov    %eax,0x8(%esp)
  8007a0:	89 0c 24             	mov    %ecx,(%esp)
  8007a3:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8007a7:	89 f2                	mov    %esi,%edx
  8007a9:	89 f8                	mov    %edi,%eax
  8007ab:	e8 e0 fa ff ff       	call   800290 <printnum>
  8007b0:	8b 5d cc             	mov    -0x34(%ebp),%ebx
			break;
  8007b3:	e9 51 fc ff ff       	jmp    800409 <vprintfmt+0x2c>
  8007b8:	89 45 cc             	mov    %eax,-0x34(%ebp)
  8007bb:	8b 55 e0             	mov    -0x20(%ebp),%edx

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  8007be:	89 74 24 04          	mov    %esi,0x4(%esp)
  8007c2:	89 14 24             	mov    %edx,(%esp)
  8007c5:	ff d7                	call   *%edi
  8007c7:	8b 5d cc             	mov    -0x34(%ebp),%ebx
			break;
  8007ca:	e9 3a fc ff ff       	jmp    800409 <vprintfmt+0x2c>
			
		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  8007cf:	89 74 24 04          	mov    %esi,0x4(%esp)
  8007d3:	c7 04 24 25 00 00 00 	movl   $0x25,(%esp)
  8007da:	ff d7                	call   *%edi
			for (fmt--; fmt[-1] != '%'; fmt--)
  8007dc:	8d 43 ff             	lea    -0x1(%ebx),%eax
  8007df:	80 38 25             	cmpb   $0x25,(%eax)
  8007e2:	0f 84 21 fc ff ff    	je     800409 <vprintfmt+0x2c>
  8007e8:	89 c3                	mov    %eax,%ebx
  8007ea:	eb f0                	jmp    8007dc <vprintfmt+0x3ff>
				/* do nothing */;
			break;
		}
	}
}
  8007ec:	83 c4 5c             	add    $0x5c,%esp
  8007ef:	5b                   	pop    %ebx
  8007f0:	5e                   	pop    %esi
  8007f1:	5f                   	pop    %edi
  8007f2:	5d                   	pop    %ebp
  8007f3:	c3                   	ret    

008007f4 <vsnprintf>:
		*b->buf++ = ch;
}

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  8007f4:	55                   	push   %ebp
  8007f5:	89 e5                	mov    %esp,%ebp
  8007f7:	83 ec 28             	sub    $0x28,%esp
  8007fa:	8b 45 08             	mov    0x8(%ebp),%eax
  8007fd:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};

	if (buf == NULL || n < 1)
  800800:	85 c0                	test   %eax,%eax
  800802:	74 04                	je     800808 <vsnprintf+0x14>
  800804:	85 d2                	test   %edx,%edx
  800806:	7f 07                	jg     80080f <vsnprintf+0x1b>
  800808:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80080d:	eb 3b                	jmp    80084a <vsnprintf+0x56>
}

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
	struct sprintbuf b = {buf, buf+n-1, 0};
  80080f:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800812:	8d 44 10 ff          	lea    -0x1(%eax,%edx,1),%eax
  800816:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800819:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800820:	8b 45 14             	mov    0x14(%ebp),%eax
  800823:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800827:	8b 45 10             	mov    0x10(%ebp),%eax
  80082a:	89 44 24 08          	mov    %eax,0x8(%esp)
  80082e:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800831:	89 44 24 04          	mov    %eax,0x4(%esp)
  800835:	c7 04 24 c0 03 80 00 	movl   $0x8003c0,(%esp)
  80083c:	e8 9c fb ff ff       	call   8003dd <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  800841:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800844:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800847:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  80084a:	c9                   	leave  
  80084b:	c3                   	ret    

0080084c <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  80084c:	55                   	push   %ebp
  80084d:	89 e5                	mov    %esp,%ebp
  80084f:	83 ec 18             	sub    $0x18,%esp

	return b.cnt;
}

int
snprintf(char *buf, int n, const char *fmt, ...)
  800852:	8d 45 14             	lea    0x14(%ebp),%eax
{
	va_list ap;
	int rc;

	va_start(ap, fmt);
	rc = vsnprintf(buf, n, fmt, ap);
  800855:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800859:	8b 45 10             	mov    0x10(%ebp),%eax
  80085c:	89 44 24 08          	mov    %eax,0x8(%esp)
  800860:	8b 45 0c             	mov    0xc(%ebp),%eax
  800863:	89 44 24 04          	mov    %eax,0x4(%esp)
  800867:	8b 45 08             	mov    0x8(%ebp),%eax
  80086a:	89 04 24             	mov    %eax,(%esp)
  80086d:	e8 82 ff ff ff       	call   8007f4 <vsnprintf>
	va_end(ap);

	return rc;
}
  800872:	c9                   	leave  
  800873:	c3                   	ret    

00800874 <printfmt>:
	}
}

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800874:	55                   	push   %ebp
  800875:	89 e5                	mov    %esp,%ebp
  800877:	83 ec 18             	sub    $0x18,%esp
		}
	}
}

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
  80087a:	8d 45 14             	lea    0x14(%ebp),%eax
{
	va_list ap;

	va_start(ap, fmt);
	vprintfmt(putch, putdat, fmt, ap);
  80087d:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800881:	8b 45 10             	mov    0x10(%ebp),%eax
  800884:	89 44 24 08          	mov    %eax,0x8(%esp)
  800888:	8b 45 0c             	mov    0xc(%ebp),%eax
  80088b:	89 44 24 04          	mov    %eax,0x4(%esp)
  80088f:	8b 45 08             	mov    0x8(%ebp),%eax
  800892:	89 04 24             	mov    %eax,(%esp)
  800895:	e8 43 fb ff ff       	call   8003dd <vprintfmt>
	va_end(ap);
}
  80089a:	c9                   	leave  
  80089b:	c3                   	ret    
  80089c:	00 00                	add    %al,(%eax)
	...

008008a0 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  8008a0:	55                   	push   %ebp
  8008a1:	89 e5                	mov    %esp,%ebp
  8008a3:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  8008a6:	b8 00 00 00 00       	mov    $0x0,%eax
  8008ab:	80 3a 00             	cmpb   $0x0,(%edx)
  8008ae:	74 09                	je     8008b9 <strlen+0x19>
		n++;
  8008b0:	83 c0 01             	add    $0x1,%eax
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  8008b3:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  8008b7:	75 f7                	jne    8008b0 <strlen+0x10>
		n++;
	return n;
}
  8008b9:	5d                   	pop    %ebp
  8008ba:	c3                   	ret    

008008bb <strnlen>:

int
strnlen(const char *s, size_t size)
{
  8008bb:	55                   	push   %ebp
  8008bc:	89 e5                	mov    %esp,%ebp
  8008be:	53                   	push   %ebx
  8008bf:	8b 5d 08             	mov    0x8(%ebp),%ebx
  8008c2:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8008c5:	85 c9                	test   %ecx,%ecx
  8008c7:	74 19                	je     8008e2 <strnlen+0x27>
  8008c9:	80 3b 00             	cmpb   $0x0,(%ebx)
  8008cc:	74 14                	je     8008e2 <strnlen+0x27>
  8008ce:	b8 00 00 00 00       	mov    $0x0,%eax
		n++;
  8008d3:	83 c0 01             	add    $0x1,%eax
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8008d6:	39 c8                	cmp    %ecx,%eax
  8008d8:	74 0d                	je     8008e7 <strnlen+0x2c>
  8008da:	80 3c 03 00          	cmpb   $0x0,(%ebx,%eax,1)
  8008de:	75 f3                	jne    8008d3 <strnlen+0x18>
  8008e0:	eb 05                	jmp    8008e7 <strnlen+0x2c>
  8008e2:	b8 00 00 00 00       	mov    $0x0,%eax
		n++;
	return n;
}
  8008e7:	5b                   	pop    %ebx
  8008e8:	5d                   	pop    %ebp
  8008e9:	c3                   	ret    

008008ea <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  8008ea:	55                   	push   %ebp
  8008eb:	89 e5                	mov    %esp,%ebp
  8008ed:	53                   	push   %ebx
  8008ee:	8b 45 08             	mov    0x8(%ebp),%eax
  8008f1:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  8008f4:	ba 00 00 00 00       	mov    $0x0,%edx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  8008f9:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
  8008fd:	88 0c 10             	mov    %cl,(%eax,%edx,1)
  800900:	83 c2 01             	add    $0x1,%edx
  800903:	84 c9                	test   %cl,%cl
  800905:	75 f2                	jne    8008f9 <strcpy+0xf>
		/* do nothing */;
	return ret;
}
  800907:	5b                   	pop    %ebx
  800908:	5d                   	pop    %ebp
  800909:	c3                   	ret    

0080090a <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  80090a:	55                   	push   %ebp
  80090b:	89 e5                	mov    %esp,%ebp
  80090d:	56                   	push   %esi
  80090e:	53                   	push   %ebx
  80090f:	8b 45 08             	mov    0x8(%ebp),%eax
  800912:	8b 55 0c             	mov    0xc(%ebp),%edx
  800915:	8b 75 10             	mov    0x10(%ebp),%esi
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800918:	85 f6                	test   %esi,%esi
  80091a:	74 18                	je     800934 <strncpy+0x2a>
  80091c:	b9 00 00 00 00       	mov    $0x0,%ecx
		*dst++ = *src;
  800921:	0f b6 1a             	movzbl (%edx),%ebx
  800924:	88 1c 08             	mov    %bl,(%eax,%ecx,1)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  800927:	80 3a 01             	cmpb   $0x1,(%edx)
  80092a:	83 da ff             	sbb    $0xffffffff,%edx
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  80092d:	83 c1 01             	add    $0x1,%ecx
  800930:	39 ce                	cmp    %ecx,%esi
  800932:	77 ed                	ja     800921 <strncpy+0x17>
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
}
  800934:	5b                   	pop    %ebx
  800935:	5e                   	pop    %esi
  800936:	5d                   	pop    %ebp
  800937:	c3                   	ret    

00800938 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800938:	55                   	push   %ebp
  800939:	89 e5                	mov    %esp,%ebp
  80093b:	56                   	push   %esi
  80093c:	53                   	push   %ebx
  80093d:	8b 75 08             	mov    0x8(%ebp),%esi
  800940:	8b 55 0c             	mov    0xc(%ebp),%edx
  800943:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  800946:	89 f0                	mov    %esi,%eax
  800948:	85 c9                	test   %ecx,%ecx
  80094a:	74 27                	je     800973 <strlcpy+0x3b>
		while (--size > 0 && *src != '\0')
  80094c:	83 e9 01             	sub    $0x1,%ecx
  80094f:	74 1d                	je     80096e <strlcpy+0x36>
  800951:	0f b6 1a             	movzbl (%edx),%ebx
  800954:	84 db                	test   %bl,%bl
  800956:	74 16                	je     80096e <strlcpy+0x36>
			*dst++ = *src++;
  800958:	88 18                	mov    %bl,(%eax)
  80095a:	83 c0 01             	add    $0x1,%eax
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  80095d:	83 e9 01             	sub    $0x1,%ecx
  800960:	74 0e                	je     800970 <strlcpy+0x38>
			*dst++ = *src++;
  800962:	83 c2 01             	add    $0x1,%edx
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800965:	0f b6 1a             	movzbl (%edx),%ebx
  800968:	84 db                	test   %bl,%bl
  80096a:	75 ec                	jne    800958 <strlcpy+0x20>
  80096c:	eb 02                	jmp    800970 <strlcpy+0x38>
  80096e:	89 f0                	mov    %esi,%eax
			*dst++ = *src++;
		*dst = '\0';
  800970:	c6 00 00             	movb   $0x0,(%eax)
  800973:	29 f0                	sub    %esi,%eax
	}
	return dst - dst_in;
}
  800975:	5b                   	pop    %ebx
  800976:	5e                   	pop    %esi
  800977:	5d                   	pop    %ebp
  800978:	c3                   	ret    

00800979 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800979:	55                   	push   %ebp
  80097a:	89 e5                	mov    %esp,%ebp
  80097c:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80097f:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  800982:	0f b6 01             	movzbl (%ecx),%eax
  800985:	84 c0                	test   %al,%al
  800987:	74 15                	je     80099e <strcmp+0x25>
  800989:	3a 02                	cmp    (%edx),%al
  80098b:	75 11                	jne    80099e <strcmp+0x25>
		p++, q++;
  80098d:	83 c1 01             	add    $0x1,%ecx
  800990:	83 c2 01             	add    $0x1,%edx
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800993:	0f b6 01             	movzbl (%ecx),%eax
  800996:	84 c0                	test   %al,%al
  800998:	74 04                	je     80099e <strcmp+0x25>
  80099a:	3a 02                	cmp    (%edx),%al
  80099c:	74 ef                	je     80098d <strcmp+0x14>
  80099e:	0f b6 c0             	movzbl %al,%eax
  8009a1:	0f b6 12             	movzbl (%edx),%edx
  8009a4:	29 d0                	sub    %edx,%eax
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
}
  8009a6:	5d                   	pop    %ebp
  8009a7:	c3                   	ret    

008009a8 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  8009a8:	55                   	push   %ebp
  8009a9:	89 e5                	mov    %esp,%ebp
  8009ab:	53                   	push   %ebx
  8009ac:	8b 55 08             	mov    0x8(%ebp),%edx
  8009af:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8009b2:	8b 45 10             	mov    0x10(%ebp),%eax
	while (n > 0 && *p && *p == *q)
  8009b5:	85 c0                	test   %eax,%eax
  8009b7:	74 23                	je     8009dc <strncmp+0x34>
  8009b9:	0f b6 1a             	movzbl (%edx),%ebx
  8009bc:	84 db                	test   %bl,%bl
  8009be:	74 24                	je     8009e4 <strncmp+0x3c>
  8009c0:	3a 19                	cmp    (%ecx),%bl
  8009c2:	75 20                	jne    8009e4 <strncmp+0x3c>
  8009c4:	83 e8 01             	sub    $0x1,%eax
  8009c7:	74 13                	je     8009dc <strncmp+0x34>
		n--, p++, q++;
  8009c9:	83 c2 01             	add    $0x1,%edx
  8009cc:	83 c1 01             	add    $0x1,%ecx
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  8009cf:	0f b6 1a             	movzbl (%edx),%ebx
  8009d2:	84 db                	test   %bl,%bl
  8009d4:	74 0e                	je     8009e4 <strncmp+0x3c>
  8009d6:	3a 19                	cmp    (%ecx),%bl
  8009d8:	74 ea                	je     8009c4 <strncmp+0x1c>
  8009da:	eb 08                	jmp    8009e4 <strncmp+0x3c>
  8009dc:	b8 00 00 00 00       	mov    $0x0,%eax
		n--, p++, q++;
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
}
  8009e1:	5b                   	pop    %ebx
  8009e2:	5d                   	pop    %ebp
  8009e3:	c3                   	ret    
	while (n > 0 && *p && *p == *q)
		n--, p++, q++;
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  8009e4:	0f b6 02             	movzbl (%edx),%eax
  8009e7:	0f b6 11             	movzbl (%ecx),%edx
  8009ea:	29 d0                	sub    %edx,%eax
  8009ec:	eb f3                	jmp    8009e1 <strncmp+0x39>

008009ee <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  8009ee:	55                   	push   %ebp
  8009ef:	89 e5                	mov    %esp,%ebp
  8009f1:	8b 45 08             	mov    0x8(%ebp),%eax
  8009f4:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  8009f8:	0f b6 10             	movzbl (%eax),%edx
  8009fb:	84 d2                	test   %dl,%dl
  8009fd:	74 15                	je     800a14 <strchr+0x26>
		if (*s == c)
  8009ff:	38 ca                	cmp    %cl,%dl
  800a01:	75 07                	jne    800a0a <strchr+0x1c>
  800a03:	eb 14                	jmp    800a19 <strchr+0x2b>
  800a05:	38 ca                	cmp    %cl,%dl
  800a07:	90                   	nop
  800a08:	74 0f                	je     800a19 <strchr+0x2b>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800a0a:	83 c0 01             	add    $0x1,%eax
  800a0d:	0f b6 10             	movzbl (%eax),%edx
  800a10:	84 d2                	test   %dl,%dl
  800a12:	75 f1                	jne    800a05 <strchr+0x17>
  800a14:	b8 00 00 00 00       	mov    $0x0,%eax
		if (*s == c)
			return (char *) s;
	return 0;
}
  800a19:	5d                   	pop    %ebp
  800a1a:	c3                   	ret    

00800a1b <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800a1b:	55                   	push   %ebp
  800a1c:	89 e5                	mov    %esp,%ebp
  800a1e:	8b 45 08             	mov    0x8(%ebp),%eax
  800a21:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800a25:	0f b6 10             	movzbl (%eax),%edx
  800a28:	84 d2                	test   %dl,%dl
  800a2a:	74 18                	je     800a44 <strfind+0x29>
		if (*s == c)
  800a2c:	38 ca                	cmp    %cl,%dl
  800a2e:	75 0a                	jne    800a3a <strfind+0x1f>
  800a30:	eb 12                	jmp    800a44 <strfind+0x29>
  800a32:	38 ca                	cmp    %cl,%dl
  800a34:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  800a38:	74 0a                	je     800a44 <strfind+0x29>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800a3a:	83 c0 01             	add    $0x1,%eax
  800a3d:	0f b6 10             	movzbl (%eax),%edx
  800a40:	84 d2                	test   %dl,%dl
  800a42:	75 ee                	jne    800a32 <strfind+0x17>
		if (*s == c)
			break;
	return (char *) s;
}
  800a44:	5d                   	pop    %ebp
  800a45:	c3                   	ret    

00800a46 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800a46:	55                   	push   %ebp
  800a47:	89 e5                	mov    %esp,%ebp
  800a49:	83 ec 0c             	sub    $0xc,%esp
  800a4c:	89 1c 24             	mov    %ebx,(%esp)
  800a4f:	89 74 24 04          	mov    %esi,0x4(%esp)
  800a53:	89 7c 24 08          	mov    %edi,0x8(%esp)
  800a57:	8b 7d 08             	mov    0x8(%ebp),%edi
  800a5a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a5d:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800a60:	85 c9                	test   %ecx,%ecx
  800a62:	74 30                	je     800a94 <memset+0x4e>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800a64:	f7 c7 03 00 00 00    	test   $0x3,%edi
  800a6a:	75 25                	jne    800a91 <memset+0x4b>
  800a6c:	f6 c1 03             	test   $0x3,%cl
  800a6f:	75 20                	jne    800a91 <memset+0x4b>
		c &= 0xFF;
  800a71:	0f b6 d0             	movzbl %al,%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800a74:	89 d3                	mov    %edx,%ebx
  800a76:	c1 e3 08             	shl    $0x8,%ebx
  800a79:	89 d6                	mov    %edx,%esi
  800a7b:	c1 e6 18             	shl    $0x18,%esi
  800a7e:	89 d0                	mov    %edx,%eax
  800a80:	c1 e0 10             	shl    $0x10,%eax
  800a83:	09 f0                	or     %esi,%eax
  800a85:	09 d0                	or     %edx,%eax
		asm volatile("cld; rep stosl\n"
  800a87:	09 d8                	or     %ebx,%eax
  800a89:	c1 e9 02             	shr    $0x2,%ecx
  800a8c:	fc                   	cld    
  800a8d:	f3 ab                	rep stos %eax,%es:(%edi)
{
	char *p;

	if (n == 0)
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800a8f:	eb 03                	jmp    800a94 <memset+0x4e>
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800a91:	fc                   	cld    
  800a92:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800a94:	89 f8                	mov    %edi,%eax
  800a96:	8b 1c 24             	mov    (%esp),%ebx
  800a99:	8b 74 24 04          	mov    0x4(%esp),%esi
  800a9d:	8b 7c 24 08          	mov    0x8(%esp),%edi
  800aa1:	89 ec                	mov    %ebp,%esp
  800aa3:	5d                   	pop    %ebp
  800aa4:	c3                   	ret    

00800aa5 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800aa5:	55                   	push   %ebp
  800aa6:	89 e5                	mov    %esp,%ebp
  800aa8:	83 ec 08             	sub    $0x8,%esp
  800aab:	89 34 24             	mov    %esi,(%esp)
  800aae:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800ab2:	8b 45 08             	mov    0x8(%ebp),%eax
  800ab5:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;
	
	s = src;
  800ab8:	8b 75 0c             	mov    0xc(%ebp),%esi
	d = dst;
  800abb:	89 c7                	mov    %eax,%edi
	if (s < d && s + n > d) {
  800abd:	39 c6                	cmp    %eax,%esi
  800abf:	73 35                	jae    800af6 <memmove+0x51>
  800ac1:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800ac4:	39 d0                	cmp    %edx,%eax
  800ac6:	73 2e                	jae    800af6 <memmove+0x51>
		s += n;
		d += n;
  800ac8:	01 cf                	add    %ecx,%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800aca:	f6 c2 03             	test   $0x3,%dl
  800acd:	75 1b                	jne    800aea <memmove+0x45>
  800acf:	f7 c7 03 00 00 00    	test   $0x3,%edi
  800ad5:	75 13                	jne    800aea <memmove+0x45>
  800ad7:	f6 c1 03             	test   $0x3,%cl
  800ada:	75 0e                	jne    800aea <memmove+0x45>
			asm volatile("std; rep movsl\n"
  800adc:	83 ef 04             	sub    $0x4,%edi
  800adf:	8d 72 fc             	lea    -0x4(%edx),%esi
  800ae2:	c1 e9 02             	shr    $0x2,%ecx
  800ae5:	fd                   	std    
  800ae6:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800ae8:	eb 09                	jmp    800af3 <memmove+0x4e>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  800aea:	83 ef 01             	sub    $0x1,%edi
  800aed:	8d 72 ff             	lea    -0x1(%edx),%esi
  800af0:	fd                   	std    
  800af1:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800af3:	fc                   	cld    
	const char *s;
	char *d;
	
	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800af4:	eb 20                	jmp    800b16 <memmove+0x71>
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800af6:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800afc:	75 15                	jne    800b13 <memmove+0x6e>
  800afe:	f7 c7 03 00 00 00    	test   $0x3,%edi
  800b04:	75 0d                	jne    800b13 <memmove+0x6e>
  800b06:	f6 c1 03             	test   $0x3,%cl
  800b09:	75 08                	jne    800b13 <memmove+0x6e>
			asm volatile("cld; rep movsl\n"
  800b0b:	c1 e9 02             	shr    $0x2,%ecx
  800b0e:	fc                   	cld    
  800b0f:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800b11:	eb 03                	jmp    800b16 <memmove+0x71>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  800b13:	fc                   	cld    
  800b14:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800b16:	8b 34 24             	mov    (%esp),%esi
  800b19:	8b 7c 24 04          	mov    0x4(%esp),%edi
  800b1d:	89 ec                	mov    %ebp,%esp
  800b1f:	5d                   	pop    %ebp
  800b20:	c3                   	ret    

00800b21 <memcpy>:

/* sigh - gcc emits references to this for structure assignments! */
/* it is *not* prototyped in inc/string.h - do not use directly. */
void *
memcpy(void *dst, void *src, size_t n)
{
  800b21:	55                   	push   %ebp
  800b22:	89 e5                	mov    %esp,%ebp
  800b24:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  800b27:	8b 45 10             	mov    0x10(%ebp),%eax
  800b2a:	89 44 24 08          	mov    %eax,0x8(%esp)
  800b2e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b31:	89 44 24 04          	mov    %eax,0x4(%esp)
  800b35:	8b 45 08             	mov    0x8(%ebp),%eax
  800b38:	89 04 24             	mov    %eax,(%esp)
  800b3b:	e8 65 ff ff ff       	call   800aa5 <memmove>
}
  800b40:	c9                   	leave  
  800b41:	c3                   	ret    

00800b42 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800b42:	55                   	push   %ebp
  800b43:	89 e5                	mov    %esp,%ebp
  800b45:	57                   	push   %edi
  800b46:	56                   	push   %esi
  800b47:	53                   	push   %ebx
  800b48:	8b 75 08             	mov    0x8(%ebp),%esi
  800b4b:	8b 7d 0c             	mov    0xc(%ebp),%edi
  800b4e:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800b51:	85 c9                	test   %ecx,%ecx
  800b53:	74 36                	je     800b8b <memcmp+0x49>
		if (*s1 != *s2)
  800b55:	0f b6 06             	movzbl (%esi),%eax
  800b58:	0f b6 1f             	movzbl (%edi),%ebx
  800b5b:	38 d8                	cmp    %bl,%al
  800b5d:	74 20                	je     800b7f <memcmp+0x3d>
  800b5f:	eb 14                	jmp    800b75 <memcmp+0x33>
  800b61:	0f b6 44 16 01       	movzbl 0x1(%esi,%edx,1),%eax
  800b66:	0f b6 5c 17 01       	movzbl 0x1(%edi,%edx,1),%ebx
  800b6b:	83 c2 01             	add    $0x1,%edx
  800b6e:	83 e9 01             	sub    $0x1,%ecx
  800b71:	38 d8                	cmp    %bl,%al
  800b73:	74 12                	je     800b87 <memcmp+0x45>
			return (int) *s1 - (int) *s2;
  800b75:	0f b6 c0             	movzbl %al,%eax
  800b78:	0f b6 db             	movzbl %bl,%ebx
  800b7b:	29 d8                	sub    %ebx,%eax
  800b7d:	eb 11                	jmp    800b90 <memcmp+0x4e>
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800b7f:	83 e9 01             	sub    $0x1,%ecx
  800b82:	ba 00 00 00 00       	mov    $0x0,%edx
  800b87:	85 c9                	test   %ecx,%ecx
  800b89:	75 d6                	jne    800b61 <memcmp+0x1f>
  800b8b:	b8 00 00 00 00       	mov    $0x0,%eax
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
}
  800b90:	5b                   	pop    %ebx
  800b91:	5e                   	pop    %esi
  800b92:	5f                   	pop    %edi
  800b93:	5d                   	pop    %ebp
  800b94:	c3                   	ret    

00800b95 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800b95:	55                   	push   %ebp
  800b96:	89 e5                	mov    %esp,%ebp
  800b98:	8b 45 08             	mov    0x8(%ebp),%eax
	const void *ends = (const char *) s + n;
  800b9b:	89 c2                	mov    %eax,%edx
  800b9d:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800ba0:	39 d0                	cmp    %edx,%eax
  800ba2:	73 15                	jae    800bb9 <memfind+0x24>
		if (*(const unsigned char *) s == (unsigned char) c)
  800ba4:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
  800ba8:	38 08                	cmp    %cl,(%eax)
  800baa:	75 06                	jne    800bb2 <memfind+0x1d>
  800bac:	eb 0b                	jmp    800bb9 <memfind+0x24>
  800bae:	38 08                	cmp    %cl,(%eax)
  800bb0:	74 07                	je     800bb9 <memfind+0x24>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800bb2:	83 c0 01             	add    $0x1,%eax
  800bb5:	39 c2                	cmp    %eax,%edx
  800bb7:	77 f5                	ja     800bae <memfind+0x19>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
	return (void *) s;
}
  800bb9:	5d                   	pop    %ebp
  800bba:	c3                   	ret    

00800bbb <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800bbb:	55                   	push   %ebp
  800bbc:	89 e5                	mov    %esp,%ebp
  800bbe:	57                   	push   %edi
  800bbf:	56                   	push   %esi
  800bc0:	53                   	push   %ebx
  800bc1:	83 ec 04             	sub    $0x4,%esp
  800bc4:	8b 55 08             	mov    0x8(%ebp),%edx
  800bc7:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800bca:	0f b6 02             	movzbl (%edx),%eax
  800bcd:	3c 20                	cmp    $0x20,%al
  800bcf:	74 04                	je     800bd5 <strtol+0x1a>
  800bd1:	3c 09                	cmp    $0x9,%al
  800bd3:	75 0e                	jne    800be3 <strtol+0x28>
		s++;
  800bd5:	83 c2 01             	add    $0x1,%edx
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800bd8:	0f b6 02             	movzbl (%edx),%eax
  800bdb:	3c 20                	cmp    $0x20,%al
  800bdd:	74 f6                	je     800bd5 <strtol+0x1a>
  800bdf:	3c 09                	cmp    $0x9,%al
  800be1:	74 f2                	je     800bd5 <strtol+0x1a>
		s++;

	// plus/minus sign
	if (*s == '+')
  800be3:	3c 2b                	cmp    $0x2b,%al
  800be5:	75 0c                	jne    800bf3 <strtol+0x38>
		s++;
  800be7:	83 c2 01             	add    $0x1,%edx
  800bea:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800bf1:	eb 15                	jmp    800c08 <strtol+0x4d>
	else if (*s == '-')
  800bf3:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800bfa:	3c 2d                	cmp    $0x2d,%al
  800bfc:	75 0a                	jne    800c08 <strtol+0x4d>
		s++, neg = 1;
  800bfe:	83 c2 01             	add    $0x1,%edx
  800c01:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800c08:	85 db                	test   %ebx,%ebx
  800c0a:	0f 94 c0             	sete   %al
  800c0d:	74 05                	je     800c14 <strtol+0x59>
  800c0f:	83 fb 10             	cmp    $0x10,%ebx
  800c12:	75 18                	jne    800c2c <strtol+0x71>
  800c14:	80 3a 30             	cmpb   $0x30,(%edx)
  800c17:	75 13                	jne    800c2c <strtol+0x71>
  800c19:	80 7a 01 78          	cmpb   $0x78,0x1(%edx)
  800c1d:	8d 76 00             	lea    0x0(%esi),%esi
  800c20:	75 0a                	jne    800c2c <strtol+0x71>
		s += 2, base = 16;
  800c22:	83 c2 02             	add    $0x2,%edx
  800c25:	bb 10 00 00 00       	mov    $0x10,%ebx
		s++;
	else if (*s == '-')
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800c2a:	eb 15                	jmp    800c41 <strtol+0x86>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  800c2c:	84 c0                	test   %al,%al
  800c2e:	66 90                	xchg   %ax,%ax
  800c30:	74 0f                	je     800c41 <strtol+0x86>
  800c32:	bb 0a 00 00 00       	mov    $0xa,%ebx
  800c37:	80 3a 30             	cmpb   $0x30,(%edx)
  800c3a:	75 05                	jne    800c41 <strtol+0x86>
		s++, base = 8;
  800c3c:	83 c2 01             	add    $0x1,%edx
  800c3f:	b3 08                	mov    $0x8,%bl
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  800c41:	b8 00 00 00 00       	mov    $0x0,%eax
  800c46:	89 de                	mov    %ebx,%esi

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  800c48:	0f b6 0a             	movzbl (%edx),%ecx
  800c4b:	89 cf                	mov    %ecx,%edi
  800c4d:	8d 59 d0             	lea    -0x30(%ecx),%ebx
  800c50:	80 fb 09             	cmp    $0x9,%bl
  800c53:	77 08                	ja     800c5d <strtol+0xa2>
			dig = *s - '0';
  800c55:	0f be c9             	movsbl %cl,%ecx
  800c58:	83 e9 30             	sub    $0x30,%ecx
  800c5b:	eb 1e                	jmp    800c7b <strtol+0xc0>
		else if (*s >= 'a' && *s <= 'z')
  800c5d:	8d 5f 9f             	lea    -0x61(%edi),%ebx
  800c60:	80 fb 19             	cmp    $0x19,%bl
  800c63:	77 08                	ja     800c6d <strtol+0xb2>
			dig = *s - 'a' + 10;
  800c65:	0f be c9             	movsbl %cl,%ecx
  800c68:	83 e9 57             	sub    $0x57,%ecx
  800c6b:	eb 0e                	jmp    800c7b <strtol+0xc0>
		else if (*s >= 'A' && *s <= 'Z')
  800c6d:	8d 5f bf             	lea    -0x41(%edi),%ebx
  800c70:	80 fb 19             	cmp    $0x19,%bl
  800c73:	77 15                	ja     800c8a <strtol+0xcf>
			dig = *s - 'A' + 10;
  800c75:	0f be c9             	movsbl %cl,%ecx
  800c78:	83 e9 37             	sub    $0x37,%ecx
		else
			break;
		if (dig >= base)
  800c7b:	39 f1                	cmp    %esi,%ecx
  800c7d:	7d 0b                	jge    800c8a <strtol+0xcf>
			break;
		s++, val = (val * base) + dig;
  800c7f:	83 c2 01             	add    $0x1,%edx
  800c82:	0f af c6             	imul   %esi,%eax
  800c85:	8d 04 01             	lea    (%ecx,%eax,1),%eax
		// we don't properly detect overflow!
	}
  800c88:	eb be                	jmp    800c48 <strtol+0x8d>
  800c8a:	89 c1                	mov    %eax,%ecx

	if (endptr)
  800c8c:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800c90:	74 05                	je     800c97 <strtol+0xdc>
		*endptr = (char *) s;
  800c92:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800c95:	89 13                	mov    %edx,(%ebx)
	return (neg ? -val : val);
  800c97:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  800c9b:	74 04                	je     800ca1 <strtol+0xe6>
  800c9d:	89 c8                	mov    %ecx,%eax
  800c9f:	f7 d8                	neg    %eax
}
  800ca1:	83 c4 04             	add    $0x4,%esp
  800ca4:	5b                   	pop    %ebx
  800ca5:	5e                   	pop    %esi
  800ca6:	5f                   	pop    %edi
  800ca7:	5d                   	pop    %ebp
  800ca8:	c3                   	ret    
  800ca9:	00 00                	add    %al,(%eax)
	...

00800cac <sys_cgetc>:
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}

int
sys_cgetc(void)
{
  800cac:	55                   	push   %ebp
  800cad:	89 e5                	mov    %esp,%ebp
  800caf:	83 ec 0c             	sub    $0xc,%esp
  800cb2:	89 1c 24             	mov    %ebx,(%esp)
  800cb5:	89 74 24 04          	mov    %esi,0x4(%esp)
  800cb9:	89 7c 24 08          	mov    %edi,0x8(%esp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800cbd:	ba 00 00 00 00       	mov    $0x0,%edx
  800cc2:	b8 01 00 00 00       	mov    $0x1,%eax
  800cc7:	89 d1                	mov    %edx,%ecx
  800cc9:	89 d3                	mov    %edx,%ebx
  800ccb:	89 d7                	mov    %edx,%edi
  800ccd:	89 d6                	mov    %edx,%esi
  800ccf:	cd 30                	int    $0x30

int
sys_cgetc(void)
{
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800cd1:	8b 1c 24             	mov    (%esp),%ebx
  800cd4:	8b 74 24 04          	mov    0x4(%esp),%esi
  800cd8:	8b 7c 24 08          	mov    0x8(%esp),%edi
  800cdc:	89 ec                	mov    %ebp,%esp
  800cde:	5d                   	pop    %ebp
  800cdf:	c3                   	ret    

00800ce0 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800ce0:	55                   	push   %ebp
  800ce1:	89 e5                	mov    %esp,%ebp
  800ce3:	83 ec 0c             	sub    $0xc,%esp
  800ce6:	89 1c 24             	mov    %ebx,(%esp)
  800ce9:	89 74 24 04          	mov    %esi,0x4(%esp)
  800ced:	89 7c 24 08          	mov    %edi,0x8(%esp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800cf1:	b8 00 00 00 00       	mov    $0x0,%eax
  800cf6:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800cf9:	8b 55 08             	mov    0x8(%ebp),%edx
  800cfc:	89 c3                	mov    %eax,%ebx
  800cfe:	89 c7                	mov    %eax,%edi
  800d00:	89 c6                	mov    %eax,%esi
  800d02:	cd 30                	int    $0x30

void
sys_cputs(const char *s, size_t len)
{
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800d04:	8b 1c 24             	mov    (%esp),%ebx
  800d07:	8b 74 24 04          	mov    0x4(%esp),%esi
  800d0b:	8b 7c 24 08          	mov    0x8(%esp),%edi
  800d0f:	89 ec                	mov    %ebp,%esp
  800d11:	5d                   	pop    %ebp
  800d12:	c3                   	ret    

00800d13 <sys_page_insert>:
{
	return syscall(SYS_page_waste, 0, (uint32_t)p, (uint32_t)n, 0, 0,0);
}
int
sys_page_insert(envid_t envid, void *va, struct Page *p, int perm)
{
  800d13:	55                   	push   %ebp
  800d14:	89 e5                	mov    %esp,%ebp
  800d16:	83 ec 38             	sub    $0x38,%esp
  800d19:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800d1c:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800d1f:	89 7d fc             	mov    %edi,-0x4(%ebp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800d22:	be 00 00 00 00       	mov    $0x0,%esi
  800d27:	b8 12 00 00 00       	mov    $0x12,%eax
  800d2c:	8b 7d 14             	mov    0x14(%ebp),%edi
  800d2f:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800d32:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d35:	8b 55 08             	mov    0x8(%ebp),%edx
  800d38:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
	
	if(check && ret > 0)
  800d3a:	85 c0                	test   %eax,%eax
  800d3c:	7e 28                	jle    800d66 <sys_page_insert+0x53>
		panic("syscall %d returned %d (> 0)", num, ret);
  800d3e:	89 44 24 10          	mov    %eax,0x10(%esp)
  800d42:	c7 44 24 0c 12 00 00 	movl   $0x12,0xc(%esp)
  800d49:	00 
  800d4a:	c7 44 24 08 ff 2c 80 	movl   $0x802cff,0x8(%esp)
  800d51:	00 
  800d52:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800d59:	00 
  800d5a:	c7 04 24 1c 2d 80 00 	movl   $0x802d1c,(%esp)
  800d61:	e8 fe f3 ff ff       	call   800164 <_panic>
}
int
sys_page_insert(envid_t envid, void *va, struct Page *p, int perm)
{
	return syscall(SYS_page_insert, 1, envid, (uint32_t) va, (uint32_t)p, perm, 0);
}
  800d66:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800d69:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800d6c:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800d6f:	89 ec                	mov    %ebp,%esp
  800d71:	5d                   	pop    %ebp
  800d72:	c3                   	ret    

00800d73 <sys_page_waste>:
{
	return (int)syscall(SYS_receive_packet, 0, (uint32_t)buffer, 0,0,0,0);
}

int sys_page_waste(struct Page **p, int n)
{
  800d73:	55                   	push   %ebp
  800d74:	89 e5                	mov    %esp,%ebp
  800d76:	83 ec 0c             	sub    $0xc,%esp
  800d79:	89 1c 24             	mov    %ebx,(%esp)
  800d7c:	89 74 24 04          	mov    %esi,0x4(%esp)
  800d80:	89 7c 24 08          	mov    %edi,0x8(%esp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800d84:	bb 00 00 00 00       	mov    $0x0,%ebx
  800d89:	b8 11 00 00 00       	mov    $0x11,%eax
  800d8e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d91:	8b 55 08             	mov    0x8(%ebp),%edx
  800d94:	89 df                	mov    %ebx,%edi
  800d96:	89 de                	mov    %ebx,%esi
  800d98:	cd 30                	int    $0x30
}

int sys_page_waste(struct Page **p, int n)
{
	return syscall(SYS_page_waste, 0, (uint32_t)p, (uint32_t)n, 0, 0,0);
}
  800d9a:	8b 1c 24             	mov    (%esp),%ebx
  800d9d:	8b 74 24 04          	mov    0x4(%esp),%esi
  800da1:	8b 7c 24 08          	mov    0x8(%esp),%edi
  800da5:	89 ec                	mov    %ebp,%esp
  800da7:	5d                   	pop    %ebp
  800da8:	c3                   	ret    

00800da9 <sys_receive_packet>:
{
	return (int)syscall(SYS_transmit_packet, 1, (uint32_t)data, len, 0,0,0);
}

int sys_receive_packet(void* buffer)
{
  800da9:	55                   	push   %ebp
  800daa:	89 e5                	mov    %esp,%ebp
  800dac:	83 ec 0c             	sub    $0xc,%esp
  800daf:	89 1c 24             	mov    %ebx,(%esp)
  800db2:	89 74 24 04          	mov    %esi,0x4(%esp)
  800db6:	89 7c 24 08          	mov    %edi,0x8(%esp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800dba:	b9 00 00 00 00       	mov    $0x0,%ecx
  800dbf:	b8 10 00 00 00       	mov    $0x10,%eax
  800dc4:	8b 55 08             	mov    0x8(%ebp),%edx
  800dc7:	89 cb                	mov    %ecx,%ebx
  800dc9:	89 cf                	mov    %ecx,%edi
  800dcb:	89 ce                	mov    %ecx,%esi
  800dcd:	cd 30                	int    $0x30
}

int sys_receive_packet(void* buffer)
{
	return (int)syscall(SYS_receive_packet, 0, (uint32_t)buffer, 0,0,0,0);
}
  800dcf:	8b 1c 24             	mov    (%esp),%ebx
  800dd2:	8b 74 24 04          	mov    0x4(%esp),%esi
  800dd6:	8b 7c 24 08          	mov    0x8(%esp),%edi
  800dda:	89 ec                	mov    %ebp,%esp
  800ddc:	5d                   	pop    %ebp
  800ddd:	c3                   	ret    

00800dde <sys_transmit_packet>:
{
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0,0);
}

int sys_transmit_packet(void* data, uint32_t len)
{
  800dde:	55                   	push   %ebp
  800ddf:	89 e5                	mov    %esp,%ebp
  800de1:	83 ec 38             	sub    $0x38,%esp
  800de4:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800de7:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800dea:	89 7d fc             	mov    %edi,-0x4(%ebp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800ded:	bb 00 00 00 00       	mov    $0x0,%ebx
  800df2:	b8 0f 00 00 00       	mov    $0xf,%eax
  800df7:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800dfa:	8b 55 08             	mov    0x8(%ebp),%edx
  800dfd:	89 df                	mov    %ebx,%edi
  800dff:	89 de                	mov    %ebx,%esi
  800e01:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
	
	if(check && ret > 0)
  800e03:	85 c0                	test   %eax,%eax
  800e05:	7e 28                	jle    800e2f <sys_transmit_packet+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  800e07:	89 44 24 10          	mov    %eax,0x10(%esp)
  800e0b:	c7 44 24 0c 0f 00 00 	movl   $0xf,0xc(%esp)
  800e12:	00 
  800e13:	c7 44 24 08 ff 2c 80 	movl   $0x802cff,0x8(%esp)
  800e1a:	00 
  800e1b:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800e22:	00 
  800e23:	c7 04 24 1c 2d 80 00 	movl   $0x802d1c,(%esp)
  800e2a:	e8 35 f3 ff ff       	call   800164 <_panic>
}

int sys_transmit_packet(void* data, uint32_t len)
{
	return (int)syscall(SYS_transmit_packet, 1, (uint32_t)data, len, 0,0,0);
}
  800e2f:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800e32:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800e35:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800e38:	89 ec                	mov    %ebp,%esp
  800e3a:	5d                   	pop    %ebp
  800e3b:	c3                   	ret    

00800e3c <sys_time_msec>:
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}

unsigned int
sys_time_msec(void)
{
  800e3c:	55                   	push   %ebp
  800e3d:	89 e5                	mov    %esp,%ebp
  800e3f:	83 ec 0c             	sub    $0xc,%esp
  800e42:	89 1c 24             	mov    %ebx,(%esp)
  800e45:	89 74 24 04          	mov    %esi,0x4(%esp)
  800e49:	89 7c 24 08          	mov    %edi,0x8(%esp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800e4d:	ba 00 00 00 00       	mov    $0x0,%edx
  800e52:	b8 0e 00 00 00       	mov    $0xe,%eax
  800e57:	89 d1                	mov    %edx,%ecx
  800e59:	89 d3                	mov    %edx,%ebx
  800e5b:	89 d7                	mov    %edx,%edi
  800e5d:	89 d6                	mov    %edx,%esi
  800e5f:	cd 30                	int    $0x30

unsigned int
sys_time_msec(void)
{
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0,0);
}
  800e61:	8b 1c 24             	mov    (%esp),%ebx
  800e64:	8b 74 24 04          	mov    0x4(%esp),%esi
  800e68:	8b 7c 24 08          	mov    0x8(%esp),%edi
  800e6c:	89 ec                	mov    %ebp,%esp
  800e6e:	5d                   	pop    %ebp
  800e6f:	c3                   	ret    

00800e70 <sys_ipc_recv>:
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}

int
sys_ipc_recv(void *dstva)
{
  800e70:	55                   	push   %ebp
  800e71:	89 e5                	mov    %esp,%ebp
  800e73:	83 ec 38             	sub    $0x38,%esp
  800e76:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800e79:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800e7c:	89 7d fc             	mov    %edi,-0x4(%ebp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800e7f:	b9 00 00 00 00       	mov    $0x0,%ecx
  800e84:	b8 0d 00 00 00       	mov    $0xd,%eax
  800e89:	8b 55 08             	mov    0x8(%ebp),%edx
  800e8c:	89 cb                	mov    %ecx,%ebx
  800e8e:	89 cf                	mov    %ecx,%edi
  800e90:	89 ce                	mov    %ecx,%esi
  800e92:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
	
	if(check && ret > 0)
  800e94:	85 c0                	test   %eax,%eax
  800e96:	7e 28                	jle    800ec0 <sys_ipc_recv+0x50>
		panic("syscall %d returned %d (> 0)", num, ret);
  800e98:	89 44 24 10          	mov    %eax,0x10(%esp)
  800e9c:	c7 44 24 0c 0d 00 00 	movl   $0xd,0xc(%esp)
  800ea3:	00 
  800ea4:	c7 44 24 08 ff 2c 80 	movl   $0x802cff,0x8(%esp)
  800eab:	00 
  800eac:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800eb3:	00 
  800eb4:	c7 04 24 1c 2d 80 00 	movl   $0x802d1c,(%esp)
  800ebb:	e8 a4 f2 ff ff       	call   800164 <_panic>

int
sys_ipc_recv(void *dstva)
{
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  800ec0:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800ec3:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800ec6:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800ec9:	89 ec                	mov    %ebp,%esp
  800ecb:	5d                   	pop    %ebp
  800ecc:	c3                   	ret    

00800ecd <sys_ipc_try_send>:
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800ecd:	55                   	push   %ebp
  800ece:	89 e5                	mov    %esp,%ebp
  800ed0:	83 ec 0c             	sub    $0xc,%esp
  800ed3:	89 1c 24             	mov    %ebx,(%esp)
  800ed6:	89 74 24 04          	mov    %esi,0x4(%esp)
  800eda:	89 7c 24 08          	mov    %edi,0x8(%esp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800ede:	be 00 00 00 00       	mov    $0x0,%esi
  800ee3:	b8 0c 00 00 00       	mov    $0xc,%eax
  800ee8:	8b 7d 14             	mov    0x14(%ebp),%edi
  800eeb:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800eee:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ef1:	8b 55 08             	mov    0x8(%ebp),%edx
  800ef4:	cd 30                	int    $0x30

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  800ef6:	8b 1c 24             	mov    (%esp),%ebx
  800ef9:	8b 74 24 04          	mov    0x4(%esp),%esi
  800efd:	8b 7c 24 08          	mov    0x8(%esp),%edi
  800f01:	89 ec                	mov    %ebp,%esp
  800f03:	5d                   	pop    %ebp
  800f04:	c3                   	ret    

00800f05 <sys_env_set_pgfault_upcall>:
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800f05:	55                   	push   %ebp
  800f06:	89 e5                	mov    %esp,%ebp
  800f08:	83 ec 38             	sub    $0x38,%esp
  800f0b:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800f0e:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800f11:	89 7d fc             	mov    %edi,-0x4(%ebp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800f14:	bb 00 00 00 00       	mov    $0x0,%ebx
  800f19:	b8 0a 00 00 00       	mov    $0xa,%eax
  800f1e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f21:	8b 55 08             	mov    0x8(%ebp),%edx
  800f24:	89 df                	mov    %ebx,%edi
  800f26:	89 de                	mov    %ebx,%esi
  800f28:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
	
	if(check && ret > 0)
  800f2a:	85 c0                	test   %eax,%eax
  800f2c:	7e 28                	jle    800f56 <sys_env_set_pgfault_upcall+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  800f2e:	89 44 24 10          	mov    %eax,0x10(%esp)
  800f32:	c7 44 24 0c 0a 00 00 	movl   $0xa,0xc(%esp)
  800f39:	00 
  800f3a:	c7 44 24 08 ff 2c 80 	movl   $0x802cff,0x8(%esp)
  800f41:	00 
  800f42:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800f49:	00 
  800f4a:	c7 04 24 1c 2d 80 00 	movl   $0x802d1c,(%esp)
  800f51:	e8 0e f2 ff ff       	call   800164 <_panic>

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  800f56:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800f59:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800f5c:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800f5f:	89 ec                	mov    %ebp,%esp
  800f61:	5d                   	pop    %ebp
  800f62:	c3                   	ret    

00800f63 <sys_env_set_trapframe>:
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800f63:	55                   	push   %ebp
  800f64:	89 e5                	mov    %esp,%ebp
  800f66:	83 ec 38             	sub    $0x38,%esp
  800f69:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800f6c:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800f6f:	89 7d fc             	mov    %edi,-0x4(%ebp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800f72:	bb 00 00 00 00       	mov    $0x0,%ebx
  800f77:	b8 09 00 00 00       	mov    $0x9,%eax
  800f7c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f7f:	8b 55 08             	mov    0x8(%ebp),%edx
  800f82:	89 df                	mov    %ebx,%edi
  800f84:	89 de                	mov    %ebx,%esi
  800f86:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
	
	if(check && ret > 0)
  800f88:	85 c0                	test   %eax,%eax
  800f8a:	7e 28                	jle    800fb4 <sys_env_set_trapframe+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  800f8c:	89 44 24 10          	mov    %eax,0x10(%esp)
  800f90:	c7 44 24 0c 09 00 00 	movl   $0x9,0xc(%esp)
  800f97:	00 
  800f98:	c7 44 24 08 ff 2c 80 	movl   $0x802cff,0x8(%esp)
  800f9f:	00 
  800fa0:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800fa7:	00 
  800fa8:	c7 04 24 1c 2d 80 00 	movl   $0x802d1c,(%esp)
  800faf:	e8 b0 f1 ff ff       	call   800164 <_panic>

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  800fb4:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800fb7:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800fba:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800fbd:	89 ec                	mov    %ebp,%esp
  800fbf:	5d                   	pop    %ebp
  800fc0:	c3                   	ret    

00800fc1 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800fc1:	55                   	push   %ebp
  800fc2:	89 e5                	mov    %esp,%ebp
  800fc4:	83 ec 38             	sub    $0x38,%esp
  800fc7:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800fca:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800fcd:	89 7d fc             	mov    %edi,-0x4(%ebp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800fd0:	bb 00 00 00 00       	mov    $0x0,%ebx
  800fd5:	b8 08 00 00 00       	mov    $0x8,%eax
  800fda:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800fdd:	8b 55 08             	mov    0x8(%ebp),%edx
  800fe0:	89 df                	mov    %ebx,%edi
  800fe2:	89 de                	mov    %ebx,%esi
  800fe4:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
	
	if(check && ret > 0)
  800fe6:	85 c0                	test   %eax,%eax
  800fe8:	7e 28                	jle    801012 <sys_env_set_status+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  800fea:	89 44 24 10          	mov    %eax,0x10(%esp)
  800fee:	c7 44 24 0c 08 00 00 	movl   $0x8,0xc(%esp)
  800ff5:	00 
  800ff6:	c7 44 24 08 ff 2c 80 	movl   $0x802cff,0x8(%esp)
  800ffd:	00 
  800ffe:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  801005:	00 
  801006:	c7 04 24 1c 2d 80 00 	movl   $0x802d1c,(%esp)
  80100d:	e8 52 f1 ff ff       	call   800164 <_panic>

int
sys_env_set_status(envid_t envid, int status)
{
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  801012:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  801015:	8b 75 f8             	mov    -0x8(%ebp),%esi
  801018:	8b 7d fc             	mov    -0x4(%ebp),%edi
  80101b:	89 ec                	mov    %ebp,%esp
  80101d:	5d                   	pop    %ebp
  80101e:	c3                   	ret    

0080101f <sys_page_unmap>:
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}

int
sys_page_unmap(envid_t envid, void *va)
{
  80101f:	55                   	push   %ebp
  801020:	89 e5                	mov    %esp,%ebp
  801022:	83 ec 38             	sub    $0x38,%esp
  801025:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  801028:	89 75 f8             	mov    %esi,-0x8(%ebp)
  80102b:	89 7d fc             	mov    %edi,-0x4(%ebp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80102e:	bb 00 00 00 00       	mov    $0x0,%ebx
  801033:	b8 06 00 00 00       	mov    $0x6,%eax
  801038:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80103b:	8b 55 08             	mov    0x8(%ebp),%edx
  80103e:	89 df                	mov    %ebx,%edi
  801040:	89 de                	mov    %ebx,%esi
  801042:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
	
	if(check && ret > 0)
  801044:	85 c0                	test   %eax,%eax
  801046:	7e 28                	jle    801070 <sys_page_unmap+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  801048:	89 44 24 10          	mov    %eax,0x10(%esp)
  80104c:	c7 44 24 0c 06 00 00 	movl   $0x6,0xc(%esp)
  801053:	00 
  801054:	c7 44 24 08 ff 2c 80 	movl   $0x802cff,0x8(%esp)
  80105b:	00 
  80105c:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  801063:	00 
  801064:	c7 04 24 1c 2d 80 00 	movl   $0x802d1c,(%esp)
  80106b:	e8 f4 f0 ff ff       	call   800164 <_panic>

int
sys_page_unmap(envid_t envid, void *va)
{
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  801070:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  801073:	8b 75 f8             	mov    -0x8(%ebp),%esi
  801076:	8b 7d fc             	mov    -0x4(%ebp),%edi
  801079:	89 ec                	mov    %ebp,%esp
  80107b:	5d                   	pop    %ebp
  80107c:	c3                   	ret    

0080107d <sys_page_map>:
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  80107d:	55                   	push   %ebp
  80107e:	89 e5                	mov    %esp,%ebp
  801080:	83 ec 38             	sub    $0x38,%esp
  801083:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  801086:	89 75 f8             	mov    %esi,-0x8(%ebp)
  801089:	89 7d fc             	mov    %edi,-0x4(%ebp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80108c:	b8 05 00 00 00       	mov    $0x5,%eax
  801091:	8b 75 18             	mov    0x18(%ebp),%esi
  801094:	8b 7d 14             	mov    0x14(%ebp),%edi
  801097:	8b 5d 10             	mov    0x10(%ebp),%ebx
  80109a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80109d:	8b 55 08             	mov    0x8(%ebp),%edx
  8010a0:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
	
	if(check && ret > 0)
  8010a2:	85 c0                	test   %eax,%eax
  8010a4:	7e 28                	jle    8010ce <sys_page_map+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  8010a6:	89 44 24 10          	mov    %eax,0x10(%esp)
  8010aa:	c7 44 24 0c 05 00 00 	movl   $0x5,0xc(%esp)
  8010b1:	00 
  8010b2:	c7 44 24 08 ff 2c 80 	movl   $0x802cff,0x8(%esp)
  8010b9:	00 
  8010ba:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  8010c1:	00 
  8010c2:	c7 04 24 1c 2d 80 00 	movl   $0x802d1c,(%esp)
  8010c9:	e8 96 f0 ff ff       	call   800164 <_panic>

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  8010ce:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  8010d1:	8b 75 f8             	mov    -0x8(%ebp),%esi
  8010d4:	8b 7d fc             	mov    -0x4(%ebp),%edi
  8010d7:	89 ec                	mov    %ebp,%esp
  8010d9:	5d                   	pop    %ebp
  8010da:	c3                   	ret    

008010db <sys_page_alloc>:
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  8010db:	55                   	push   %ebp
  8010dc:	89 e5                	mov    %esp,%ebp
  8010de:	83 ec 38             	sub    $0x38,%esp
  8010e1:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  8010e4:	89 75 f8             	mov    %esi,-0x8(%ebp)
  8010e7:	89 7d fc             	mov    %edi,-0x4(%ebp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8010ea:	be 00 00 00 00       	mov    $0x0,%esi
  8010ef:	b8 04 00 00 00       	mov    $0x4,%eax
  8010f4:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8010f7:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8010fa:	8b 55 08             	mov    0x8(%ebp),%edx
  8010fd:	89 f7                	mov    %esi,%edi
  8010ff:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
	
	if(check && ret > 0)
  801101:	85 c0                	test   %eax,%eax
  801103:	7e 28                	jle    80112d <sys_page_alloc+0x52>
		panic("syscall %d returned %d (> 0)", num, ret);
  801105:	89 44 24 10          	mov    %eax,0x10(%esp)
  801109:	c7 44 24 0c 04 00 00 	movl   $0x4,0xc(%esp)
  801110:	00 
  801111:	c7 44 24 08 ff 2c 80 	movl   $0x802cff,0x8(%esp)
  801118:	00 
  801119:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  801120:	00 
  801121:	c7 04 24 1c 2d 80 00 	movl   $0x802d1c,(%esp)
  801128:	e8 37 f0 ff ff       	call   800164 <_panic>

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  80112d:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  801130:	8b 75 f8             	mov    -0x8(%ebp),%esi
  801133:	8b 7d fc             	mov    -0x4(%ebp),%edi
  801136:	89 ec                	mov    %ebp,%esp
  801138:	5d                   	pop    %ebp
  801139:	c3                   	ret    

0080113a <sys_yield>:
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}

void
sys_yield(void)
{
  80113a:	55                   	push   %ebp
  80113b:	89 e5                	mov    %esp,%ebp
  80113d:	83 ec 0c             	sub    $0xc,%esp
  801140:	89 1c 24             	mov    %ebx,(%esp)
  801143:	89 74 24 04          	mov    %esi,0x4(%esp)
  801147:	89 7c 24 08          	mov    %edi,0x8(%esp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80114b:	ba 00 00 00 00       	mov    $0x0,%edx
  801150:	b8 0b 00 00 00       	mov    $0xb,%eax
  801155:	89 d1                	mov    %edx,%ecx
  801157:	89 d3                	mov    %edx,%ebx
  801159:	89 d7                	mov    %edx,%edi
  80115b:	89 d6                	mov    %edx,%esi
  80115d:	cd 30                	int    $0x30

void
sys_yield(void)
{
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  80115f:	8b 1c 24             	mov    (%esp),%ebx
  801162:	8b 74 24 04          	mov    0x4(%esp),%esi
  801166:	8b 7c 24 08          	mov    0x8(%esp),%edi
  80116a:	89 ec                	mov    %ebp,%esp
  80116c:	5d                   	pop    %ebp
  80116d:	c3                   	ret    

0080116e <sys_getenvid>:
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}

envid_t
sys_getenvid(void)
{
  80116e:	55                   	push   %ebp
  80116f:	89 e5                	mov    %esp,%ebp
  801171:	83 ec 0c             	sub    $0xc,%esp
  801174:	89 1c 24             	mov    %ebx,(%esp)
  801177:	89 74 24 04          	mov    %esi,0x4(%esp)
  80117b:	89 7c 24 08          	mov    %edi,0x8(%esp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80117f:	ba 00 00 00 00       	mov    $0x0,%edx
  801184:	b8 02 00 00 00       	mov    $0x2,%eax
  801189:	89 d1                	mov    %edx,%ecx
  80118b:	89 d3                	mov    %edx,%ebx
  80118d:	89 d7                	mov    %edx,%edi
  80118f:	89 d6                	mov    %edx,%esi
  801191:	cd 30                	int    $0x30

envid_t
sys_getenvid(void)
{
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  801193:	8b 1c 24             	mov    (%esp),%ebx
  801196:	8b 74 24 04          	mov    0x4(%esp),%esi
  80119a:	8b 7c 24 08          	mov    0x8(%esp),%edi
  80119e:	89 ec                	mov    %ebp,%esp
  8011a0:	5d                   	pop    %ebp
  8011a1:	c3                   	ret    

008011a2 <sys_env_destroy>:
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}

int
sys_env_destroy(envid_t envid)
{
  8011a2:	55                   	push   %ebp
  8011a3:	89 e5                	mov    %esp,%ebp
  8011a5:	83 ec 38             	sub    $0x38,%esp
  8011a8:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  8011ab:	89 75 f8             	mov    %esi,-0x8(%ebp)
  8011ae:	89 7d fc             	mov    %edi,-0x4(%ebp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8011b1:	b9 00 00 00 00       	mov    $0x0,%ecx
  8011b6:	b8 03 00 00 00       	mov    $0x3,%eax
  8011bb:	8b 55 08             	mov    0x8(%ebp),%edx
  8011be:	89 cb                	mov    %ecx,%ebx
  8011c0:	89 cf                	mov    %ecx,%edi
  8011c2:	89 ce                	mov    %ecx,%esi
  8011c4:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
	
	if(check && ret > 0)
  8011c6:	85 c0                	test   %eax,%eax
  8011c8:	7e 28                	jle    8011f2 <sys_env_destroy+0x50>
		panic("syscall %d returned %d (> 0)", num, ret);
  8011ca:	89 44 24 10          	mov    %eax,0x10(%esp)
  8011ce:	c7 44 24 0c 03 00 00 	movl   $0x3,0xc(%esp)
  8011d5:	00 
  8011d6:	c7 44 24 08 ff 2c 80 	movl   $0x802cff,0x8(%esp)
  8011dd:	00 
  8011de:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  8011e5:	00 
  8011e6:	c7 04 24 1c 2d 80 00 	movl   $0x802d1c,(%esp)
  8011ed:	e8 72 ef ff ff       	call   800164 <_panic>

int
sys_env_destroy(envid_t envid)
{
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  8011f2:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  8011f5:	8b 75 f8             	mov    -0x8(%ebp),%esi
  8011f8:	8b 7d fc             	mov    -0x4(%ebp),%edi
  8011fb:	89 ec                	mov    %ebp,%esp
  8011fd:	5d                   	pop    %ebp
  8011fe:	c3                   	ret    
	...

00801200 <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  801200:	55                   	push   %ebp
  801201:	89 e5                	mov    %esp,%ebp
  801203:	83 ec 18             	sub    $0x18,%esp
	int r;

	if (_pgfault_handler == 0) {
  801206:	83 3d 7c 60 80 00 00 	cmpl   $0x0,0x80607c
  80120d:	75 78                	jne    801287 <set_pgfault_handler+0x87>
		// First time through!
		// LAB 4: Your code here.
		// panic("set_pgfault_handler not implemented");
		int ret;	
		if ((ret = sys_page_alloc(0, (void*)(UXSTACKTOP - PGSIZE), PTE_U | PTE_P | PTE_W)) < 0)
  80120f:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  801216:	00 
  801217:	c7 44 24 04 00 f0 bf 	movl   $0xeebff000,0x4(%esp)
  80121e:	ee 
  80121f:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801226:	e8 b0 fe ff ff       	call   8010db <sys_page_alloc>
  80122b:	85 c0                	test   %eax,%eax
  80122d:	79 20                	jns    80124f <set_pgfault_handler+0x4f>
			panic (" error in sys_page_alloc: %e\n", ret);
  80122f:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801233:	c7 44 24 08 2a 2d 80 	movl   $0x802d2a,0x8(%esp)
  80123a:	00 
  80123b:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  801242:	00 
  801243:	c7 04 24 48 2d 80 00 	movl   $0x802d48,(%esp)
  80124a:	e8 15 ef ff ff       	call   800164 <_panic>
		if ((ret = sys_env_set_pgfault_upcall(0, _pgfault_upcall)) < 0)
  80124f:	c7 44 24 04 94 12 80 	movl   $0x801294,0x4(%esp)
  801256:	00 
  801257:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80125e:	e8 a2 fc ff ff       	call   800f05 <sys_env_set_pgfault_upcall>
  801263:	85 c0                	test   %eax,%eax
  801265:	79 20                	jns    801287 <set_pgfault_handler+0x87>
			panic (" error in sys_env_set_pgfault_upcall: %e\n", ret);
  801267:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80126b:	c7 44 24 08 58 2d 80 	movl   $0x802d58,0x8(%esp)
  801272:	00 
  801273:	c7 44 24 04 25 00 00 	movl   $0x25,0x4(%esp)
  80127a:	00 
  80127b:	c7 04 24 48 2d 80 00 	movl   $0x802d48,(%esp)
  801282:	e8 dd ee ff ff       	call   800164 <_panic>
	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  801287:	8b 45 08             	mov    0x8(%ebp),%eax
  80128a:	a3 7c 60 80 00       	mov    %eax,0x80607c
	
}
  80128f:	c9                   	leave  
  801290:	c3                   	ret    
  801291:	00 00                	add    %al,(%eax)
	...

00801294 <_pgfault_upcall>:

.text
.globl _pgfault_upcall
_pgfault_upcall:
	// Call the C page fault handler.
	pushl %esp			// function argument: pointer to UTF
  801294:	54                   	push   %esp
	movl _pgfault_handler, %eax
  801295:	a1 7c 60 80 00       	mov    0x80607c,%eax
	call *%eax
  80129a:	ff d0                	call   *%eax
	addl $4, %esp			// pop function argument
  80129c:	83 c4 04             	add    $0x4,%esp
	// may find that you have to rearrange your code in non-obvious
	// ways as registers become unavailable as scratch space.
	//
	// LAB 4: Your code here.
	
	movl %esp, %ecx			// back up esp to ecx
  80129f:	89 e1                	mov    %esp,%ecx
	movl 0x28(%esp), %ebx		// store trap-time eip into ebx
  8012a1:	8b 5c 24 28          	mov    0x28(%esp),%ebx
	movl 0x30(%esp), %edx		// store trap-time esp into edx
  8012a5:	8b 54 24 30          	mov    0x30(%esp),%edx
	movl %edx, %esp			// switch to trap-time stack
  8012a9:	89 d4                	mov    %edx,%esp
	pushl %ebx			// push trap-time eip here
  8012ab:	53                   	push   %ebx
	movl %ecx, %esp			// come back to user exception stack
  8012ac:	89 cc                	mov    %ecx,%esp
	
	// for the push made above, update the trap-time esp value in this user exception stack
	// this enables popl %esp to cause esp point to the adjusted trap-time stack 
	subl $0x4, %edx			
  8012ae:	83 ea 04             	sub    $0x4,%edx
	movl %edx, 0x30(%esp)
  8012b1:	89 54 24 30          	mov    %edx,0x30(%esp)
	

	// Restore the trap-time registers.  After you do this, you
	// can no longer modify any general-purpose registers.
	// LAB 4: Your code here.
	addl $0x8, %esp
  8012b5:	83 c4 08             	add    $0x8,%esp
	popal
  8012b8:	61                   	popa   
	// Restore eflags from the stack.  After you do this, you can
	// no longer use arithmetic operations or anything else that
	// modifies eflags.
	// LAB 4: Your code here.
	
	addl $0x4, %esp
  8012b9:	83 c4 04             	add    $0x4,%esp
	popfl
  8012bc:	9d                   	popf   

	// Switch back to the adjusted trap-time stack.
	// LAB 4: Your code here.

	popl %esp
  8012bd:	5c                   	pop    %esp

	// Return to re-execute the instruction that faulted.
	// LAB 4: Your code here.
	
	ret
  8012be:	c3                   	ret    
	...

008012c0 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  8012c0:	55                   	push   %ebp
  8012c1:	89 e5                	mov    %esp,%ebp
  8012c3:	8b 45 08             	mov    0x8(%ebp),%eax
  8012c6:	05 00 00 00 30       	add    $0x30000000,%eax
  8012cb:	c1 e8 0c             	shr    $0xc,%eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
}
  8012ce:	5d                   	pop    %ebp
  8012cf:	c3                   	ret    

008012d0 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  8012d0:	55                   	push   %ebp
  8012d1:	89 e5                	mov    %esp,%ebp
  8012d3:	83 ec 04             	sub    $0x4,%esp
	return INDEX2DATA(fd2num(fd));
  8012d6:	8b 45 08             	mov    0x8(%ebp),%eax
  8012d9:	89 04 24             	mov    %eax,(%esp)
  8012dc:	e8 df ff ff ff       	call   8012c0 <fd2num>
  8012e1:	05 20 00 0d 00       	add    $0xd0020,%eax
  8012e6:	c1 e0 0c             	shl    $0xc,%eax
}
  8012e9:	c9                   	leave  
  8012ea:	c3                   	ret    

008012eb <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  8012eb:	55                   	push   %ebp
  8012ec:	89 e5                	mov    %esp,%ebp
  8012ee:	57                   	push   %edi
  8012ef:	56                   	push   %esi
  8012f0:	53                   	push   %ebx
  8012f1:	8b 7d 08             	mov    0x8(%ebp),%edi
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((vpd[PDX(fd)] & PTE_P) == 0 || (vpt[VPN(fd)] & PTE_P) == 0) {
  8012f4:	a1 00 dd 7b ef       	mov    0xef7bdd00,%eax
  8012f9:	a8 01                	test   $0x1,%al
  8012fb:	74 36                	je     801333 <fd_alloc+0x48>
  8012fd:	a1 00 00 74 ef       	mov    0xef740000,%eax
  801302:	a8 01                	test   $0x1,%al
  801304:	74 2d                	je     801333 <fd_alloc+0x48>
  801306:	b8 00 10 00 d0       	mov    $0xd0001000,%eax
  80130b:	b9 00 d0 7b ef       	mov    $0xef7bd000,%ecx
  801310:	be 00 00 40 ef       	mov    $0xef400000,%esi
  801315:	89 c3                	mov    %eax,%ebx
  801317:	89 c2                	mov    %eax,%edx
  801319:	c1 ea 16             	shr    $0x16,%edx
  80131c:	8b 14 91             	mov    (%ecx,%edx,4),%edx
  80131f:	f6 c2 01             	test   $0x1,%dl
  801322:	74 14                	je     801338 <fd_alloc+0x4d>
  801324:	89 c2                	mov    %eax,%edx
  801326:	c1 ea 0c             	shr    $0xc,%edx
  801329:	8b 14 96             	mov    (%esi,%edx,4),%edx
  80132c:	f6 c2 01             	test   $0x1,%dl
  80132f:	75 10                	jne    801341 <fd_alloc+0x56>
  801331:	eb 05                	jmp    801338 <fd_alloc+0x4d>
  801333:	bb 00 00 00 d0       	mov    $0xd0000000,%ebx
			*fd_store = fd;
  801338:	89 1f                	mov    %ebx,(%edi)
  80133a:	b8 00 00 00 00       	mov    $0x0,%eax
			return 0;
  80133f:	eb 17                	jmp    801358 <fd_alloc+0x6d>
  801341:	05 00 10 00 00       	add    $0x1000,%eax
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  801346:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  80134b:	75 c8                	jne    801315 <fd_alloc+0x2a>
		if ((vpd[PDX(fd)] & PTE_P) == 0 || (vpt[VPN(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  80134d:	c7 07 00 00 00 00    	movl   $0x0,(%edi)
  801353:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
	return -E_MAX_OPEN;
}
  801358:	5b                   	pop    %ebx
  801359:	5e                   	pop    %esi
  80135a:	5f                   	pop    %edi
  80135b:	5d                   	pop    %ebp
  80135c:	c3                   	ret    

0080135d <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  80135d:	55                   	push   %ebp
  80135e:	89 e5                	mov    %esp,%ebp
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  801360:	8b 45 08             	mov    0x8(%ebp),%eax
  801363:	83 f8 1f             	cmp    $0x1f,%eax
  801366:	77 36                	ja     80139e <fd_lookup+0x41>
		if (debug)
			cprintf("[%08x] bad fd %d\n", env->env_id, fd);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  801368:	05 00 00 0d 00       	add    $0xd0000,%eax
  80136d:	c1 e0 0c             	shl    $0xc,%eax
	if (!(vpd[PDX(fd)] & PTE_P) || !(vpt[VPN(fd)] & PTE_P)) {
  801370:	89 c2                	mov    %eax,%edx
  801372:	c1 ea 16             	shr    $0x16,%edx
  801375:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  80137c:	f6 c2 01             	test   $0x1,%dl
  80137f:	74 1d                	je     80139e <fd_lookup+0x41>
  801381:	89 c2                	mov    %eax,%edx
  801383:	c1 ea 0c             	shr    $0xc,%edx
  801386:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  80138d:	f6 c2 01             	test   $0x1,%dl
  801390:	74 0c                	je     80139e <fd_lookup+0x41>
		if (debug)
			cprintf("[%08x] closed fd %d\n", env->env_id, fd);
		return -E_INVAL;
	}
	*fd_store = fd;
  801392:	8b 55 0c             	mov    0xc(%ebp),%edx
  801395:	89 02                	mov    %eax,(%edx)
  801397:	b8 00 00 00 00       	mov    $0x0,%eax
	return 0;
  80139c:	eb 05                	jmp    8013a3 <fd_lookup+0x46>
  80139e:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  8013a3:	5d                   	pop    %ebp
  8013a4:	c3                   	ret    

008013a5 <seek>:
	return (*dev->dev_write)(fd, buf, n);
}

int
seek(int fdnum, off_t offset)
{
  8013a5:	55                   	push   %ebp
  8013a6:	89 e5                	mov    %esp,%ebp
  8013a8:	83 ec 18             	sub    $0x18,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8013ab:	8d 45 fc             	lea    -0x4(%ebp),%eax
  8013ae:	89 44 24 04          	mov    %eax,0x4(%esp)
  8013b2:	8b 45 08             	mov    0x8(%ebp),%eax
  8013b5:	89 04 24             	mov    %eax,(%esp)
  8013b8:	e8 a0 ff ff ff       	call   80135d <fd_lookup>
  8013bd:	85 c0                	test   %eax,%eax
  8013bf:	78 0e                	js     8013cf <seek+0x2a>
		return r;
	fd->fd_offset = offset;
  8013c1:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8013c4:	8b 55 0c             	mov    0xc(%ebp),%edx
  8013c7:	89 50 04             	mov    %edx,0x4(%eax)
  8013ca:	b8 00 00 00 00       	mov    $0x0,%eax
	return 0;
}
  8013cf:	c9                   	leave  
  8013d0:	c3                   	ret    

008013d1 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  8013d1:	55                   	push   %ebp
  8013d2:	89 e5                	mov    %esp,%ebp
  8013d4:	56                   	push   %esi
  8013d5:	53                   	push   %ebx
  8013d6:	83 ec 10             	sub    $0x10,%esp
  8013d9:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8013dc:	8b 5d 0c             	mov    0xc(%ebp),%ebx
// File functions
// --------------------------------------------------------------

static struct Dev *devtab[] =
{
	&devfile,
  8013df:	b8 04 60 80 00       	mov    $0x806004,%eax
{
	int i;
	for (i = 0; devtab[i]; i++)
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
  8013e4:	ba 00 00 00 00       	mov    $0x0,%edx

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  8013e9:	be 00 2e 80 00       	mov    $0x802e00,%esi
		if (devtab[i]->dev_id == dev_id) {
  8013ee:	39 08                	cmp    %ecx,(%eax)
  8013f0:	75 10                	jne    801402 <dev_lookup+0x31>
  8013f2:	eb 04                	jmp    8013f8 <dev_lookup+0x27>
  8013f4:	39 08                	cmp    %ecx,(%eax)
  8013f6:	75 0a                	jne    801402 <dev_lookup+0x31>
			*dev = devtab[i];
  8013f8:	89 03                	mov    %eax,(%ebx)
  8013fa:	b8 00 00 00 00       	mov    $0x0,%eax
			return 0;
  8013ff:	90                   	nop
  801400:	eb 31                	jmp    801433 <dev_lookup+0x62>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  801402:	83 c2 01             	add    $0x1,%edx
  801405:	8b 04 96             	mov    (%esi,%edx,4),%eax
  801408:	85 c0                	test   %eax,%eax
  80140a:	75 e8                	jne    8013f4 <dev_lookup+0x23>
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", env->env_id, dev_id);
  80140c:	a1 74 60 80 00       	mov    0x806074,%eax
  801411:	8b 40 4c             	mov    0x4c(%eax),%eax
  801414:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801418:	89 44 24 04          	mov    %eax,0x4(%esp)
  80141c:	c7 04 24 84 2d 80 00 	movl   $0x802d84,(%esp)
  801423:	e8 01 ee ff ff       	call   800229 <cprintf>
	*dev = 0;
  801428:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  80142e:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
	return -E_INVAL;
}
  801433:	83 c4 10             	add    $0x10,%esp
  801436:	5b                   	pop    %ebx
  801437:	5e                   	pop    %esi
  801438:	5d                   	pop    %ebp
  801439:	c3                   	ret    

0080143a <fstat>:
	return (*dev->dev_trunc)(fd, newsize);
}

int
fstat(int fdnum, struct Stat *stat)
{
  80143a:	55                   	push   %ebp
  80143b:	89 e5                	mov    %esp,%ebp
  80143d:	53                   	push   %ebx
  80143e:	83 ec 24             	sub    $0x24,%esp
  801441:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801444:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801447:	89 44 24 04          	mov    %eax,0x4(%esp)
  80144b:	8b 45 08             	mov    0x8(%ebp),%eax
  80144e:	89 04 24             	mov    %eax,(%esp)
  801451:	e8 07 ff ff ff       	call   80135d <fd_lookup>
  801456:	85 c0                	test   %eax,%eax
  801458:	78 53                	js     8014ad <fstat+0x73>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80145a:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80145d:	89 44 24 04          	mov    %eax,0x4(%esp)
  801461:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801464:	8b 00                	mov    (%eax),%eax
  801466:	89 04 24             	mov    %eax,(%esp)
  801469:	e8 63 ff ff ff       	call   8013d1 <dev_lookup>
{
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80146e:	85 c0                	test   %eax,%eax
  801470:	78 3b                	js     8014ad <fstat+0x73>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if (!dev->dev_stat)
  801472:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801477:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80147a:	83 7a 14 00          	cmpl   $0x0,0x14(%edx)
  80147e:	74 2d                	je     8014ad <fstat+0x73>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  801480:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  801483:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  80148a:	00 00 00 
	stat->st_isdir = 0;
  80148d:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801494:	00 00 00 
	stat->st_dev = dev;
  801497:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80149a:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  8014a0:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8014a4:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8014a7:	89 14 24             	mov    %edx,(%esp)
  8014aa:	ff 50 14             	call   *0x14(%eax)
}
  8014ad:	83 c4 24             	add    $0x24,%esp
  8014b0:	5b                   	pop    %ebx
  8014b1:	5d                   	pop    %ebp
  8014b2:	c3                   	ret    

008014b3 <ftruncate>:
	return 0;
}

int
ftruncate(int fdnum, off_t newsize)
{
  8014b3:	55                   	push   %ebp
  8014b4:	89 e5                	mov    %esp,%ebp
  8014b6:	53                   	push   %ebx
  8014b7:	83 ec 24             	sub    $0x24,%esp
  8014ba:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  8014bd:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8014c0:	89 44 24 04          	mov    %eax,0x4(%esp)
  8014c4:	89 1c 24             	mov    %ebx,(%esp)
  8014c7:	e8 91 fe ff ff       	call   80135d <fd_lookup>
  8014cc:	85 c0                	test   %eax,%eax
  8014ce:	78 5f                	js     80152f <ftruncate+0x7c>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8014d0:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8014d3:	89 44 24 04          	mov    %eax,0x4(%esp)
  8014d7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8014da:	8b 00                	mov    (%eax),%eax
  8014dc:	89 04 24             	mov    %eax,(%esp)
  8014df:	e8 ed fe ff ff       	call   8013d1 <dev_lookup>
ftruncate(int fdnum, off_t newsize)
{
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  8014e4:	85 c0                	test   %eax,%eax
  8014e6:	78 47                	js     80152f <ftruncate+0x7c>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8014e8:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8014eb:	f6 42 08 03          	testb  $0x3,0x8(%edx)
  8014ef:	75 23                	jne    801514 <ftruncate+0x61>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			env->env_id, fdnum); 
  8014f1:	a1 74 60 80 00       	mov    0x806074,%eax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  8014f6:	8b 40 4c             	mov    0x4c(%eax),%eax
  8014f9:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8014fd:	89 44 24 04          	mov    %eax,0x4(%esp)
  801501:	c7 04 24 a4 2d 80 00 	movl   $0x802da4,(%esp)
  801508:	e8 1c ed ff ff       	call   800229 <cprintf>
  80150d:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
			env->env_id, fdnum); 
		return -E_INVAL;
  801512:	eb 1b                	jmp    80152f <ftruncate+0x7c>
	}
	if (!dev->dev_trunc)
  801514:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801517:	8b 48 18             	mov    0x18(%eax),%ecx
  80151a:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  80151f:	85 c9                	test   %ecx,%ecx
  801521:	74 0c                	je     80152f <ftruncate+0x7c>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  801523:	8b 45 0c             	mov    0xc(%ebp),%eax
  801526:	89 44 24 04          	mov    %eax,0x4(%esp)
  80152a:	89 14 24             	mov    %edx,(%esp)
  80152d:	ff d1                	call   *%ecx
}
  80152f:	83 c4 24             	add    $0x24,%esp
  801532:	5b                   	pop    %ebx
  801533:	5d                   	pop    %ebp
  801534:	c3                   	ret    

00801535 <write>:
	return tot;
}

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  801535:	55                   	push   %ebp
  801536:	89 e5                	mov    %esp,%ebp
  801538:	53                   	push   %ebx
  801539:	83 ec 24             	sub    $0x24,%esp
  80153c:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80153f:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801542:	89 44 24 04          	mov    %eax,0x4(%esp)
  801546:	89 1c 24             	mov    %ebx,(%esp)
  801549:	e8 0f fe ff ff       	call   80135d <fd_lookup>
  80154e:	85 c0                	test   %eax,%eax
  801550:	78 66                	js     8015b8 <write+0x83>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801552:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801555:	89 44 24 04          	mov    %eax,0x4(%esp)
  801559:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80155c:	8b 00                	mov    (%eax),%eax
  80155e:	89 04 24             	mov    %eax,(%esp)
  801561:	e8 6b fe ff ff       	call   8013d1 <dev_lookup>
{
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801566:	85 c0                	test   %eax,%eax
  801568:	78 4e                	js     8015b8 <write+0x83>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  80156a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80156d:	f6 42 08 03          	testb  $0x3,0x8(%edx)
  801571:	75 23                	jne    801596 <write+0x61>
		cprintf("[%08x] write %d -- bad mode\n", env->env_id, fdnum);
  801573:	a1 74 60 80 00       	mov    0x806074,%eax
  801578:	8b 40 4c             	mov    0x4c(%eax),%eax
  80157b:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80157f:	89 44 24 04          	mov    %eax,0x4(%esp)
  801583:	c7 04 24 c5 2d 80 00 	movl   $0x802dc5,(%esp)
  80158a:	e8 9a ec ff ff       	call   800229 <cprintf>
  80158f:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
		return -E_INVAL;
  801594:	eb 22                	jmp    8015b8 <write+0x83>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  801596:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801599:	8b 48 0c             	mov    0xc(%eax),%ecx
  80159c:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8015a1:	85 c9                	test   %ecx,%ecx
  8015a3:	74 13                	je     8015b8 <write+0x83>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  8015a5:	8b 45 10             	mov    0x10(%ebp),%eax
  8015a8:	89 44 24 08          	mov    %eax,0x8(%esp)
  8015ac:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015af:	89 44 24 04          	mov    %eax,0x4(%esp)
  8015b3:	89 14 24             	mov    %edx,(%esp)
  8015b6:	ff d1                	call   *%ecx
}
  8015b8:	83 c4 24             	add    $0x24,%esp
  8015bb:	5b                   	pop    %ebx
  8015bc:	5d                   	pop    %ebp
  8015bd:	c3                   	ret    

008015be <read>:
	return r;
}

ssize_t
read(int fdnum, void *buf, size_t n)
{
  8015be:	55                   	push   %ebp
  8015bf:	89 e5                	mov    %esp,%ebp
  8015c1:	53                   	push   %ebx
  8015c2:	83 ec 24             	sub    $0x24,%esp
  8015c5:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8015c8:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8015cb:	89 44 24 04          	mov    %eax,0x4(%esp)
  8015cf:	89 1c 24             	mov    %ebx,(%esp)
  8015d2:	e8 86 fd ff ff       	call   80135d <fd_lookup>
  8015d7:	85 c0                	test   %eax,%eax
  8015d9:	78 6b                	js     801646 <read+0x88>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8015db:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8015de:	89 44 24 04          	mov    %eax,0x4(%esp)
  8015e2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8015e5:	8b 00                	mov    (%eax),%eax
  8015e7:	89 04 24             	mov    %eax,(%esp)
  8015ea:	e8 e2 fd ff ff       	call   8013d1 <dev_lookup>
{
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8015ef:	85 c0                	test   %eax,%eax
  8015f1:	78 53                	js     801646 <read+0x88>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  8015f3:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8015f6:	8b 42 08             	mov    0x8(%edx),%eax
  8015f9:	83 e0 03             	and    $0x3,%eax
  8015fc:	83 f8 01             	cmp    $0x1,%eax
  8015ff:	75 23                	jne    801624 <read+0x66>
		cprintf("[%08x] read %d -- bad mode\n", env->env_id, fdnum); 
  801601:	a1 74 60 80 00       	mov    0x806074,%eax
  801606:	8b 40 4c             	mov    0x4c(%eax),%eax
  801609:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80160d:	89 44 24 04          	mov    %eax,0x4(%esp)
  801611:	c7 04 24 e2 2d 80 00 	movl   $0x802de2,(%esp)
  801618:	e8 0c ec ff ff       	call   800229 <cprintf>
  80161d:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
		return -E_INVAL;
  801622:	eb 22                	jmp    801646 <read+0x88>
	}
	if (!dev->dev_read)
  801624:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801627:	8b 48 08             	mov    0x8(%eax),%ecx
  80162a:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  80162f:	85 c9                	test   %ecx,%ecx
  801631:	74 13                	je     801646 <read+0x88>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  801633:	8b 45 10             	mov    0x10(%ebp),%eax
  801636:	89 44 24 08          	mov    %eax,0x8(%esp)
  80163a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80163d:	89 44 24 04          	mov    %eax,0x4(%esp)
  801641:	89 14 24             	mov    %edx,(%esp)
  801644:	ff d1                	call   *%ecx
}
  801646:	83 c4 24             	add    $0x24,%esp
  801649:	5b                   	pop    %ebx
  80164a:	5d                   	pop    %ebp
  80164b:	c3                   	ret    

0080164c <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  80164c:	55                   	push   %ebp
  80164d:	89 e5                	mov    %esp,%ebp
  80164f:	57                   	push   %edi
  801650:	56                   	push   %esi
  801651:	53                   	push   %ebx
  801652:	83 ec 1c             	sub    $0x1c,%esp
  801655:	8b 7d 08             	mov    0x8(%ebp),%edi
  801658:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  80165b:	ba 00 00 00 00       	mov    $0x0,%edx
  801660:	bb 00 00 00 00       	mov    $0x0,%ebx
  801665:	b8 00 00 00 00       	mov    $0x0,%eax
  80166a:	85 f6                	test   %esi,%esi
  80166c:	74 29                	je     801697 <readn+0x4b>
		m = read(fdnum, (char*)buf + tot, n - tot);
  80166e:	89 f0                	mov    %esi,%eax
  801670:	29 d0                	sub    %edx,%eax
  801672:	89 44 24 08          	mov    %eax,0x8(%esp)
  801676:	03 55 0c             	add    0xc(%ebp),%edx
  801679:	89 54 24 04          	mov    %edx,0x4(%esp)
  80167d:	89 3c 24             	mov    %edi,(%esp)
  801680:	e8 39 ff ff ff       	call   8015be <read>
		if (m < 0)
  801685:	85 c0                	test   %eax,%eax
  801687:	78 0e                	js     801697 <readn+0x4b>
			return m;
		if (m == 0)
  801689:	85 c0                	test   %eax,%eax
  80168b:	74 08                	je     801695 <readn+0x49>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  80168d:	01 c3                	add    %eax,%ebx
  80168f:	89 da                	mov    %ebx,%edx
  801691:	39 f3                	cmp    %esi,%ebx
  801693:	72 d9                	jb     80166e <readn+0x22>
  801695:	89 d8                	mov    %ebx,%eax
			return m;
		if (m == 0)
			break;
	}
	return tot;
}
  801697:	83 c4 1c             	add    $0x1c,%esp
  80169a:	5b                   	pop    %ebx
  80169b:	5e                   	pop    %esi
  80169c:	5f                   	pop    %edi
  80169d:	5d                   	pop    %ebp
  80169e:	c3                   	ret    

0080169f <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  80169f:	55                   	push   %ebp
  8016a0:	89 e5                	mov    %esp,%ebp
  8016a2:	56                   	push   %esi
  8016a3:	53                   	push   %ebx
  8016a4:	83 ec 20             	sub    $0x20,%esp
  8016a7:	8b 75 08             	mov    0x8(%ebp),%esi
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8016aa:	89 34 24             	mov    %esi,(%esp)
  8016ad:	e8 0e fc ff ff       	call   8012c0 <fd2num>
  8016b2:	8d 55 f4             	lea    -0xc(%ebp),%edx
  8016b5:	89 54 24 04          	mov    %edx,0x4(%esp)
  8016b9:	89 04 24             	mov    %eax,(%esp)
  8016bc:	e8 9c fc ff ff       	call   80135d <fd_lookup>
  8016c1:	89 c3                	mov    %eax,%ebx
  8016c3:	85 c0                	test   %eax,%eax
  8016c5:	78 05                	js     8016cc <fd_close+0x2d>
  8016c7:	3b 75 f4             	cmp    -0xc(%ebp),%esi
  8016ca:	74 0c                	je     8016d8 <fd_close+0x39>
	    || fd != fd2)
		return (must_exist ? r : 0);
  8016cc:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8016d0:	19 c0                	sbb    %eax,%eax
  8016d2:	f7 d0                	not    %eax
  8016d4:	21 c3                	and    %eax,%ebx
  8016d6:	eb 3d                	jmp    801715 <fd_close+0x76>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  8016d8:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8016db:	89 44 24 04          	mov    %eax,0x4(%esp)
  8016df:	8b 06                	mov    (%esi),%eax
  8016e1:	89 04 24             	mov    %eax,(%esp)
  8016e4:	e8 e8 fc ff ff       	call   8013d1 <dev_lookup>
  8016e9:	89 c3                	mov    %eax,%ebx
  8016eb:	85 c0                	test   %eax,%eax
  8016ed:	78 16                	js     801705 <fd_close+0x66>
		if (dev->dev_close)
  8016ef:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8016f2:	8b 40 10             	mov    0x10(%eax),%eax
  8016f5:	bb 00 00 00 00       	mov    $0x0,%ebx
  8016fa:	85 c0                	test   %eax,%eax
  8016fc:	74 07                	je     801705 <fd_close+0x66>
			r = (*dev->dev_close)(fd);
  8016fe:	89 34 24             	mov    %esi,(%esp)
  801701:	ff d0                	call   *%eax
  801703:	89 c3                	mov    %eax,%ebx
		else
			r = 0;
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  801705:	89 74 24 04          	mov    %esi,0x4(%esp)
  801709:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801710:	e8 0a f9 ff ff       	call   80101f <sys_page_unmap>
	return r;
}
  801715:	89 d8                	mov    %ebx,%eax
  801717:	83 c4 20             	add    $0x20,%esp
  80171a:	5b                   	pop    %ebx
  80171b:	5e                   	pop    %esi
  80171c:	5d                   	pop    %ebp
  80171d:	c3                   	ret    

0080171e <close>:
	return -E_INVAL;
}

int
close(int fdnum)
{
  80171e:	55                   	push   %ebp
  80171f:	89 e5                	mov    %esp,%ebp
  801721:	83 ec 28             	sub    $0x28,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801724:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801727:	89 44 24 04          	mov    %eax,0x4(%esp)
  80172b:	8b 45 08             	mov    0x8(%ebp),%eax
  80172e:	89 04 24             	mov    %eax,(%esp)
  801731:	e8 27 fc ff ff       	call   80135d <fd_lookup>
  801736:	85 c0                	test   %eax,%eax
  801738:	78 13                	js     80174d <close+0x2f>
		return r;
	else
		return fd_close(fd, 1);
  80173a:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  801741:	00 
  801742:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801745:	89 04 24             	mov    %eax,(%esp)
  801748:	e8 52 ff ff ff       	call   80169f <fd_close>
}
  80174d:	c9                   	leave  
  80174e:	c3                   	ret    

0080174f <stat>:
	return (*dev->dev_stat)(fd, stat);
}

int
stat(const char *path, struct Stat *stat)
{
  80174f:	55                   	push   %ebp
  801750:	89 e5                	mov    %esp,%ebp
  801752:	83 ec 18             	sub    $0x18,%esp
  801755:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  801758:	89 75 fc             	mov    %esi,-0x4(%ebp)
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  80175b:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  801762:	00 
  801763:	8b 45 08             	mov    0x8(%ebp),%eax
  801766:	89 04 24             	mov    %eax,(%esp)
  801769:	e8 55 03 00 00       	call   801ac3 <open>
  80176e:	89 c3                	mov    %eax,%ebx
  801770:	85 c0                	test   %eax,%eax
  801772:	78 1b                	js     80178f <stat+0x40>
		return fd;
	r = fstat(fd, stat);
  801774:	8b 45 0c             	mov    0xc(%ebp),%eax
  801777:	89 44 24 04          	mov    %eax,0x4(%esp)
  80177b:	89 1c 24             	mov    %ebx,(%esp)
  80177e:	e8 b7 fc ff ff       	call   80143a <fstat>
  801783:	89 c6                	mov    %eax,%esi
	close(fd);
  801785:	89 1c 24             	mov    %ebx,(%esp)
  801788:	e8 91 ff ff ff       	call   80171e <close>
  80178d:	89 f3                	mov    %esi,%ebx
	return r;
}
  80178f:	89 d8                	mov    %ebx,%eax
  801791:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  801794:	8b 75 fc             	mov    -0x4(%ebp),%esi
  801797:	89 ec                	mov    %ebp,%esp
  801799:	5d                   	pop    %ebp
  80179a:	c3                   	ret    

0080179b <close_all>:
		return fd_close(fd, 1);
}

void
close_all(void)
{
  80179b:	55                   	push   %ebp
  80179c:	89 e5                	mov    %esp,%ebp
  80179e:	53                   	push   %ebx
  80179f:	83 ec 14             	sub    $0x14,%esp
  8017a2:	bb 00 00 00 00       	mov    $0x0,%ebx
	int i;
	for (i = 0; i < MAXFD; i++)
		close(i);
  8017a7:	89 1c 24             	mov    %ebx,(%esp)
  8017aa:	e8 6f ff ff ff       	call   80171e <close>

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  8017af:	83 c3 01             	add    $0x1,%ebx
  8017b2:	83 fb 20             	cmp    $0x20,%ebx
  8017b5:	75 f0                	jne    8017a7 <close_all+0xc>
		close(i);
}
  8017b7:	83 c4 14             	add    $0x14,%esp
  8017ba:	5b                   	pop    %ebx
  8017bb:	5d                   	pop    %ebp
  8017bc:	c3                   	ret    

008017bd <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  8017bd:	55                   	push   %ebp
  8017be:	89 e5                	mov    %esp,%ebp
  8017c0:	83 ec 58             	sub    $0x58,%esp
  8017c3:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  8017c6:	89 75 f8             	mov    %esi,-0x8(%ebp)
  8017c9:	89 7d fc             	mov    %edi,-0x4(%ebp)
  8017cc:	8b 7d 0c             	mov    0xc(%ebp),%edi
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  8017cf:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  8017d2:	89 44 24 04          	mov    %eax,0x4(%esp)
  8017d6:	8b 45 08             	mov    0x8(%ebp),%eax
  8017d9:	89 04 24             	mov    %eax,(%esp)
  8017dc:	e8 7c fb ff ff       	call   80135d <fd_lookup>
  8017e1:	89 c3                	mov    %eax,%ebx
  8017e3:	85 c0                	test   %eax,%eax
  8017e5:	0f 88 e0 00 00 00    	js     8018cb <dup+0x10e>
		return r;
	close(newfdnum);
  8017eb:	89 3c 24             	mov    %edi,(%esp)
  8017ee:	e8 2b ff ff ff       	call   80171e <close>

	newfd = INDEX2FD(newfdnum);
  8017f3:	8d b7 00 00 0d 00    	lea    0xd0000(%edi),%esi
  8017f9:	c1 e6 0c             	shl    $0xc,%esi
	ova = fd2data(oldfd);
  8017fc:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8017ff:	89 04 24             	mov    %eax,(%esp)
  801802:	e8 c9 fa ff ff       	call   8012d0 <fd2data>
  801807:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  801809:	89 34 24             	mov    %esi,(%esp)
  80180c:	e8 bf fa ff ff       	call   8012d0 <fd2data>
  801811:	89 45 d4             	mov    %eax,-0x2c(%ebp)

	if ((vpd[PDX(ova)] & PTE_P) && (vpt[VPN(ova)] & PTE_P))
  801814:	89 da                	mov    %ebx,%edx
  801816:	89 d8                	mov    %ebx,%eax
  801818:	c1 e8 16             	shr    $0x16,%eax
  80181b:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801822:	a8 01                	test   $0x1,%al
  801824:	74 43                	je     801869 <dup+0xac>
  801826:	c1 ea 0c             	shr    $0xc,%edx
  801829:	8b 04 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%eax
  801830:	a8 01                	test   $0x1,%al
  801832:	74 35                	je     801869 <dup+0xac>
		if ((r = sys_page_map(0, ova, 0, nva, vpt[VPN(ova)] & PTE_USER)) < 0)
  801834:	8b 04 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%eax
  80183b:	25 07 0e 00 00       	and    $0xe07,%eax
  801840:	89 44 24 10          	mov    %eax,0x10(%esp)
  801844:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801847:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80184b:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801852:	00 
  801853:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801857:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80185e:	e8 1a f8 ff ff       	call   80107d <sys_page_map>
  801863:	89 c3                	mov    %eax,%ebx
  801865:	85 c0                	test   %eax,%eax
  801867:	78 3f                	js     8018a8 <dup+0xeb>
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, vpt[VPN(oldfd)] & PTE_USER)) < 0)
  801869:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80186c:	89 c2                	mov    %eax,%edx
  80186e:	c1 ea 0c             	shr    $0xc,%edx
  801871:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801878:	81 e2 07 0e 00 00    	and    $0xe07,%edx
  80187e:	89 54 24 10          	mov    %edx,0x10(%esp)
  801882:	89 74 24 0c          	mov    %esi,0xc(%esp)
  801886:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  80188d:	00 
  80188e:	89 44 24 04          	mov    %eax,0x4(%esp)
  801892:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801899:	e8 df f7 ff ff       	call   80107d <sys_page_map>
  80189e:	89 c3                	mov    %eax,%ebx
  8018a0:	85 c0                	test   %eax,%eax
  8018a2:	78 04                	js     8018a8 <dup+0xeb>
  8018a4:	89 fb                	mov    %edi,%ebx
  8018a6:	eb 23                	jmp    8018cb <dup+0x10e>
		goto err;

	return newfdnum;

err:
	sys_page_unmap(0, newfd);
  8018a8:	89 74 24 04          	mov    %esi,0x4(%esp)
  8018ac:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8018b3:	e8 67 f7 ff ff       	call   80101f <sys_page_unmap>
	sys_page_unmap(0, nva);
  8018b8:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8018bb:	89 44 24 04          	mov    %eax,0x4(%esp)
  8018bf:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8018c6:	e8 54 f7 ff ff       	call   80101f <sys_page_unmap>
	return r;
}
  8018cb:	89 d8                	mov    %ebx,%eax
  8018cd:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  8018d0:	8b 75 f8             	mov    -0x8(%ebp),%esi
  8018d3:	8b 7d fc             	mov    -0x4(%ebp),%edi
  8018d6:	89 ec                	mov    %ebp,%esp
  8018d8:	5d                   	pop    %ebp
  8018d9:	c3                   	ret    
	...

008018dc <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  8018dc:	55                   	push   %ebp
  8018dd:	89 e5                	mov    %esp,%ebp
  8018df:	53                   	push   %ebx
  8018e0:	83 ec 14             	sub    $0x14,%esp
  8018e3:	89 d3                	mov    %edx,%ebx
	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", env->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(envs[1].env_id, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  8018e5:	8b 15 c8 00 c0 ee    	mov    0xeec000c8,%edx
  8018eb:	c7 44 24 0c 07 00 00 	movl   $0x7,0xc(%esp)
  8018f2:	00 
  8018f3:	c7 44 24 08 00 30 80 	movl   $0x803000,0x8(%esp)
  8018fa:	00 
  8018fb:	89 44 24 04          	mov    %eax,0x4(%esp)
  8018ff:	89 14 24             	mov    %edx,(%esp)
  801902:	e8 b9 0c 00 00       	call   8025c0 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  801907:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  80190e:	00 
  80190f:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801913:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80191a:	e8 07 0d 00 00       	call   802626 <ipc_recv>
}
  80191f:	83 c4 14             	add    $0x14,%esp
  801922:	5b                   	pop    %ebx
  801923:	5d                   	pop    %ebp
  801924:	c3                   	ret    

00801925 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  801925:	55                   	push   %ebp
  801926:	89 e5                	mov    %esp,%ebp
  801928:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  80192b:	8b 45 08             	mov    0x8(%ebp),%eax
  80192e:	8b 40 0c             	mov    0xc(%eax),%eax
  801931:	a3 00 30 80 00       	mov    %eax,0x803000
	fsipcbuf.set_size.req_size = newsize;
  801936:	8b 45 0c             	mov    0xc(%ebp),%eax
  801939:	a3 04 30 80 00       	mov    %eax,0x803004
	return fsipc(FSREQ_SET_SIZE, NULL);
  80193e:	ba 00 00 00 00       	mov    $0x0,%edx
  801943:	b8 02 00 00 00       	mov    $0x2,%eax
  801948:	e8 8f ff ff ff       	call   8018dc <fsipc>
}
  80194d:	c9                   	leave  
  80194e:	c3                   	ret    

0080194f <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  80194f:	55                   	push   %ebp
  801950:	89 e5                	mov    %esp,%ebp
  801952:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  801955:	8b 45 08             	mov    0x8(%ebp),%eax
  801958:	8b 40 0c             	mov    0xc(%eax),%eax
  80195b:	a3 00 30 80 00       	mov    %eax,0x803000
	return fsipc(FSREQ_FLUSH, NULL);
  801960:	ba 00 00 00 00       	mov    $0x0,%edx
  801965:	b8 06 00 00 00       	mov    $0x6,%eax
  80196a:	e8 6d ff ff ff       	call   8018dc <fsipc>
}
  80196f:	c9                   	leave  
  801970:	c3                   	ret    

00801971 <sync>:
}

// Synchronize disk with buffer cache
int
sync(void)
{
  801971:	55                   	push   %ebp
  801972:	89 e5                	mov    %esp,%ebp
  801974:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  801977:	ba 00 00 00 00       	mov    $0x0,%edx
  80197c:	b8 08 00 00 00       	mov    $0x8,%eax
  801981:	e8 56 ff ff ff       	call   8018dc <fsipc>
}
  801986:	c9                   	leave  
  801987:	c3                   	ret    

00801988 <devfile_stat>:
	return fsipc(FSREQ_WRITE, NULL);	
}

static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  801988:	55                   	push   %ebp
  801989:	89 e5                	mov    %esp,%ebp
  80198b:	53                   	push   %ebx
  80198c:	83 ec 14             	sub    $0x14,%esp
  80198f:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  801992:	8b 45 08             	mov    0x8(%ebp),%eax
  801995:	8b 40 0c             	mov    0xc(%eax),%eax
  801998:	a3 00 30 80 00       	mov    %eax,0x803000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  80199d:	ba 00 00 00 00       	mov    $0x0,%edx
  8019a2:	b8 05 00 00 00       	mov    $0x5,%eax
  8019a7:	e8 30 ff ff ff       	call   8018dc <fsipc>
  8019ac:	85 c0                	test   %eax,%eax
  8019ae:	78 2b                	js     8019db <devfile_stat+0x53>
		return r;
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  8019b0:	c7 44 24 04 00 30 80 	movl   $0x803000,0x4(%esp)
  8019b7:	00 
  8019b8:	89 1c 24             	mov    %ebx,(%esp)
  8019bb:	e8 2a ef ff ff       	call   8008ea <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  8019c0:	a1 80 30 80 00       	mov    0x803080,%eax
  8019c5:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  8019cb:	a1 84 30 80 00       	mov    0x803084,%eax
  8019d0:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
  8019d6:	b8 00 00 00 00       	mov    $0x0,%eax
	return 0;
}
  8019db:	83 c4 14             	add    $0x14,%esp
  8019de:	5b                   	pop    %ebx
  8019df:	5d                   	pop    %ebp
  8019e0:	c3                   	ret    

008019e1 <devfile_write>:
// Returns:
//	 The number of bytes successfully written.
//	 < 0 on error.
static ssize_t
devfile_write(struct Fd *fd, const void *buf, size_t n)
{
  8019e1:	55                   	push   %ebp
  8019e2:	89 e5                	mov    %esp,%ebp
  8019e4:	83 ec 18             	sub    $0x18,%esp
  8019e7:	8b 45 10             	mov    0x10(%ebp),%eax
  8019ea:	3d f8 0f 00 00       	cmp    $0xff8,%eax
  8019ef:	76 05                	jbe    8019f6 <devfile_write+0x15>
  8019f1:	b8 f8 0f 00 00       	mov    $0xff8,%eax
	// LAB 5: Your code here
	//panic("devfile_write not implemented");
	
	if (n > (PGSIZE - (sizeof(int) + sizeof(size_t))))
		n = PGSIZE - (sizeof(int) + sizeof(size_t));
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  8019f6:	8b 55 08             	mov    0x8(%ebp),%edx
  8019f9:	8b 52 0c             	mov    0xc(%edx),%edx
  8019fc:	89 15 00 30 80 00    	mov    %edx,0x803000
	fsipcbuf.write.req_n = n;
  801a02:	a3 04 30 80 00       	mov    %eax,0x803004
	memmove (fsipcbuf.write.req_buf, (char*)buf, n);	
  801a07:	89 44 24 08          	mov    %eax,0x8(%esp)
  801a0b:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a0e:	89 44 24 04          	mov    %eax,0x4(%esp)
  801a12:	c7 04 24 08 30 80 00 	movl   $0x803008,(%esp)
  801a19:	e8 87 f0 ff ff       	call   800aa5 <memmove>
	return fsipc(FSREQ_WRITE, NULL);	
  801a1e:	ba 00 00 00 00       	mov    $0x0,%edx
  801a23:	b8 04 00 00 00       	mov    $0x4,%eax
  801a28:	e8 af fe ff ff       	call   8018dc <fsipc>
}
  801a2d:	c9                   	leave  
  801a2e:	c3                   	ret    

00801a2f <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  801a2f:	55                   	push   %ebp
  801a30:	89 e5                	mov    %esp,%ebp
  801a32:	53                   	push   %ebx
  801a33:	83 ec 14             	sub    $0x14,%esp
	// system server.
	// LAB 5: Your code here
	
	//panic("devfile_read not implemented");
	int r;
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  801a36:	8b 45 08             	mov    0x8(%ebp),%eax
  801a39:	8b 40 0c             	mov    0xc(%eax),%eax
  801a3c:	a3 00 30 80 00       	mov    %eax,0x803000
	fsipcbuf.read.req_n = n;
  801a41:	8b 45 10             	mov    0x10(%ebp),%eax
  801a44:	a3 04 30 80 00       	mov    %eax,0x803004
	if ((r = fsipc(FSREQ_READ, (void*)&fsipcbuf)) < 0)
  801a49:	ba 00 30 80 00       	mov    $0x803000,%edx
  801a4e:	b8 03 00 00 00       	mov    $0x3,%eax
  801a53:	e8 84 fe ff ff       	call   8018dc <fsipc>
  801a58:	89 c3                	mov    %eax,%ebx
  801a5a:	85 c0                	test   %eax,%eax
  801a5c:	78 17                	js     801a75 <devfile_read+0x46>
		return r;
	memmove((void*)buf, (void*)fsipcbuf.readRet.ret_buf, r);
  801a5e:	89 44 24 08          	mov    %eax,0x8(%esp)
  801a62:	c7 44 24 04 00 30 80 	movl   $0x803000,0x4(%esp)
  801a69:	00 
  801a6a:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a6d:	89 04 24             	mov    %eax,(%esp)
  801a70:	e8 30 f0 ff ff       	call   800aa5 <memmove>
	return r;
}
  801a75:	89 d8                	mov    %ebx,%eax
  801a77:	83 c4 14             	add    $0x14,%esp
  801a7a:	5b                   	pop    %ebx
  801a7b:	5d                   	pop    %ebp
  801a7c:	c3                   	ret    

00801a7d <remove>:
}

// Delete a file
int
remove(const char *path)
{
  801a7d:	55                   	push   %ebp
  801a7e:	89 e5                	mov    %esp,%ebp
  801a80:	53                   	push   %ebx
  801a81:	83 ec 14             	sub    $0x14,%esp
  801a84:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (strlen(path) >= MAXPATHLEN)
  801a87:	89 1c 24             	mov    %ebx,(%esp)
  801a8a:	e8 11 ee ff ff       	call   8008a0 <strlen>
  801a8f:	89 c2                	mov    %eax,%edx
  801a91:	b8 f4 ff ff ff       	mov    $0xfffffff4,%eax
  801a96:	81 fa ff 03 00 00    	cmp    $0x3ff,%edx
  801a9c:	7f 1f                	jg     801abd <remove+0x40>
		return -E_BAD_PATH;
	strcpy(fsipcbuf.remove.req_path, path);
  801a9e:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801aa2:	c7 04 24 00 30 80 00 	movl   $0x803000,(%esp)
  801aa9:	e8 3c ee ff ff       	call   8008ea <strcpy>
	return fsipc(FSREQ_REMOVE, NULL);
  801aae:	ba 00 00 00 00       	mov    $0x0,%edx
  801ab3:	b8 07 00 00 00       	mov    $0x7,%eax
  801ab8:	e8 1f fe ff ff       	call   8018dc <fsipc>
}
  801abd:	83 c4 14             	add    $0x14,%esp
  801ac0:	5b                   	pop    %ebx
  801ac1:	5d                   	pop    %ebp
  801ac2:	c3                   	ret    

00801ac3 <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  801ac3:	55                   	push   %ebp
  801ac4:	89 e5                	mov    %esp,%ebp
  801ac6:	83 ec 28             	sub    $0x28,%esp
  801ac9:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  801acc:	89 75 fc             	mov    %esi,-0x4(%ebp)
  801acf:	8b 75 08             	mov    0x8(%ebp),%esi
	// file descriptor.

	// LAB 5: Your code here.
	// Code added by Swastika / Sandeep
	
	if (strlen(path) >= MAXPATHLEN)
  801ad2:	89 34 24             	mov    %esi,(%esp)
  801ad5:	e8 c6 ed ff ff       	call   8008a0 <strlen>
  801ada:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  801adf:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  801ae4:	7f 5e                	jg     801b44 <open+0x81>
		return -E_BAD_PATH;
	struct Fd * fd;
	int  r;
	if ((r = fd_alloc(&fd)) < 0)
  801ae6:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801ae9:	89 04 24             	mov    %eax,(%esp)
  801aec:	e8 fa f7 ff ff       	call   8012eb <fd_alloc>
  801af1:	89 c3                	mov    %eax,%ebx
  801af3:	85 c0                	test   %eax,%eax
  801af5:	78 4d                	js     801b44 <open+0x81>
		return r;
	strcpy (fsipcbuf.open.req_path, path);
  801af7:	89 74 24 04          	mov    %esi,0x4(%esp)
  801afb:	c7 04 24 00 30 80 00 	movl   $0x803000,(%esp)
  801b02:	e8 e3 ed ff ff       	call   8008ea <strcpy>
	fsipcbuf.open.req_omode = mode;	
  801b07:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b0a:	a3 00 34 80 00       	mov    %eax,0x803400
	if ((r = fsipc(FSREQ_OPEN,(void*)fd)) < 0)
  801b0f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801b12:	b8 01 00 00 00       	mov    $0x1,%eax
  801b17:	e8 c0 fd ff ff       	call   8018dc <fsipc>
  801b1c:	89 c3                	mov    %eax,%ebx
  801b1e:	85 c0                	test   %eax,%eax
  801b20:	79 15                	jns    801b37 <open+0x74>
	{
		fd_close(fd,0);
  801b22:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  801b29:	00 
  801b2a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801b2d:	89 04 24             	mov    %eax,(%esp)
  801b30:	e8 6a fb ff ff       	call   80169f <fd_close>
		return r; 
  801b35:	eb 0d                	jmp    801b44 <open+0x81>
	}
	return fd2num(fd);
  801b37:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801b3a:	89 04 24             	mov    %eax,(%esp)
  801b3d:	e8 7e f7 ff ff       	call   8012c0 <fd2num>
  801b42:	89 c3                	mov    %eax,%ebx
	//panic("open not implemented");
}
  801b44:	89 d8                	mov    %ebx,%eax
  801b46:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  801b49:	8b 75 fc             	mov    -0x4(%ebp),%esi
  801b4c:	89 ec                	mov    %ebp,%esp
  801b4e:	5d                   	pop    %ebp
  801b4f:	c3                   	ret    

00801b50 <devsock_stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  801b50:	55                   	push   %ebp
  801b51:	89 e5                	mov    %esp,%ebp
  801b53:	83 ec 18             	sub    $0x18,%esp
	strcpy(stat->st_name, "<sock>");
  801b56:	c7 44 24 04 14 2e 80 	movl   $0x802e14,0x4(%esp)
  801b5d:	00 
  801b5e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b61:	89 04 24             	mov    %eax,(%esp)
  801b64:	e8 81 ed ff ff       	call   8008ea <strcpy>
	return 0;
}
  801b69:	b8 00 00 00 00       	mov    $0x0,%eax
  801b6e:	c9                   	leave  
  801b6f:	c3                   	ret    

00801b70 <devsock_close>:
	return nsipc_shutdown(r, how);
}

static int
devsock_close(struct Fd *fd)
{
  801b70:	55                   	push   %ebp
  801b71:	89 e5                	mov    %esp,%ebp
  801b73:	83 ec 18             	sub    $0x18,%esp
	return nsipc_close(fd->fd_sock.sockid);
  801b76:	8b 45 08             	mov    0x8(%ebp),%eax
  801b79:	8b 40 0c             	mov    0xc(%eax),%eax
  801b7c:	89 04 24             	mov    %eax,(%esp)
  801b7f:	e8 9e 02 00 00       	call   801e22 <nsipc_close>
}
  801b84:	c9                   	leave  
  801b85:	c3                   	ret    

00801b86 <devsock_write>:
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
}

static ssize_t
devsock_write(struct Fd *fd, const void *buf, size_t n)
{
  801b86:	55                   	push   %ebp
  801b87:	89 e5                	mov    %esp,%ebp
  801b89:	83 ec 18             	sub    $0x18,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  801b8c:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  801b93:	00 
  801b94:	8b 45 10             	mov    0x10(%ebp),%eax
  801b97:	89 44 24 08          	mov    %eax,0x8(%esp)
  801b9b:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b9e:	89 44 24 04          	mov    %eax,0x4(%esp)
  801ba2:	8b 45 08             	mov    0x8(%ebp),%eax
  801ba5:	8b 40 0c             	mov    0xc(%eax),%eax
  801ba8:	89 04 24             	mov    %eax,(%esp)
  801bab:	e8 ae 02 00 00       	call   801e5e <nsipc_send>
}
  801bb0:	c9                   	leave  
  801bb1:	c3                   	ret    

00801bb2 <devsock_read>:
	return nsipc_listen(r, backlog);
}

static ssize_t
devsock_read(struct Fd *fd, void *buf, size_t n)
{
  801bb2:	55                   	push   %ebp
  801bb3:	89 e5                	mov    %esp,%ebp
  801bb5:	83 ec 18             	sub    $0x18,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  801bb8:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  801bbf:	00 
  801bc0:	8b 45 10             	mov    0x10(%ebp),%eax
  801bc3:	89 44 24 08          	mov    %eax,0x8(%esp)
  801bc7:	8b 45 0c             	mov    0xc(%ebp),%eax
  801bca:	89 44 24 04          	mov    %eax,0x4(%esp)
  801bce:	8b 45 08             	mov    0x8(%ebp),%eax
  801bd1:	8b 40 0c             	mov    0xc(%eax),%eax
  801bd4:	89 04 24             	mov    %eax,(%esp)
  801bd7:	e8 f5 02 00 00       	call   801ed1 <nsipc_recv>
}
  801bdc:	c9                   	leave  
  801bdd:	c3                   	ret    

00801bde <alloc_sockfd>:
	return sfd->fd_sock.sockid;
}

static int
alloc_sockfd(int sockid)
{
  801bde:	55                   	push   %ebp
  801bdf:	89 e5                	mov    %esp,%ebp
  801be1:	56                   	push   %esi
  801be2:	53                   	push   %ebx
  801be3:	83 ec 20             	sub    $0x20,%esp
  801be6:	89 c6                	mov    %eax,%esi
	struct Fd *sfd;
	int r;

	if ((r = fd_alloc(&sfd)) < 0
  801be8:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801beb:	89 04 24             	mov    %eax,(%esp)
  801bee:	e8 f8 f6 ff ff       	call   8012eb <fd_alloc>
  801bf3:	89 c3                	mov    %eax,%ebx
  801bf5:	85 c0                	test   %eax,%eax
  801bf7:	78 21                	js     801c1a <alloc_sockfd+0x3c>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U)) < 0) {
  801bf9:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  801c00:	00 
  801c01:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c04:	89 44 24 04          	mov    %eax,0x4(%esp)
  801c08:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801c0f:	e8 c7 f4 ff ff       	call   8010db <sys_page_alloc>
  801c14:	89 c3                	mov    %eax,%ebx
alloc_sockfd(int sockid)
{
	struct Fd *sfd;
	int r;

	if ((r = fd_alloc(&sfd)) < 0
  801c16:	85 c0                	test   %eax,%eax
  801c18:	79 0a                	jns    801c24 <alloc_sockfd+0x46>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U)) < 0) {
		nsipc_close(sockid);
  801c1a:	89 34 24             	mov    %esi,(%esp)
  801c1d:	e8 00 02 00 00       	call   801e22 <nsipc_close>
		return r;
  801c22:	eb 28                	jmp    801c4c <alloc_sockfd+0x6e>
	}

	sfd->fd_dev_id = devsock.dev_id;
  801c24:	8b 15 20 60 80 00    	mov    0x806020,%edx
  801c2a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c2d:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  801c2f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c32:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	sfd->fd_sock.sockid = sockid;
  801c39:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c3c:	89 70 0c             	mov    %esi,0xc(%eax)
	return fd2num(sfd);
  801c3f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c42:	89 04 24             	mov    %eax,(%esp)
  801c45:	e8 76 f6 ff ff       	call   8012c0 <fd2num>
  801c4a:	89 c3                	mov    %eax,%ebx
}
  801c4c:	89 d8                	mov    %ebx,%eax
  801c4e:	83 c4 20             	add    $0x20,%esp
  801c51:	5b                   	pop    %ebx
  801c52:	5e                   	pop    %esi
  801c53:	5d                   	pop    %ebp
  801c54:	c3                   	ret    

00801c55 <socket>:
	return 0;
}

int
socket(int domain, int type, int protocol)
{
  801c55:	55                   	push   %ebp
  801c56:	89 e5                	mov    %esp,%ebp
  801c58:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  801c5b:	8b 45 10             	mov    0x10(%ebp),%eax
  801c5e:	89 44 24 08          	mov    %eax,0x8(%esp)
  801c62:	8b 45 0c             	mov    0xc(%ebp),%eax
  801c65:	89 44 24 04          	mov    %eax,0x4(%esp)
  801c69:	8b 45 08             	mov    0x8(%ebp),%eax
  801c6c:	89 04 24             	mov    %eax,(%esp)
  801c6f:	e8 62 01 00 00       	call   801dd6 <nsipc_socket>
  801c74:	85 c0                	test   %eax,%eax
  801c76:	78 05                	js     801c7d <socket+0x28>
		return r;
	return alloc_sockfd(r);
  801c78:	e8 61 ff ff ff       	call   801bde <alloc_sockfd>
}
  801c7d:	c9                   	leave  
  801c7e:	66 90                	xchg   %ax,%ax
  801c80:	c3                   	ret    

00801c81 <fd2sockid>:
	.dev_stat =	devsock_stat,
};

static int
fd2sockid(int fd)
{
  801c81:	55                   	push   %ebp
  801c82:	89 e5                	mov    %esp,%ebp
  801c84:	83 ec 28             	sub    $0x28,%esp
	struct Fd *sfd;
	int r;

	if ((r = fd_lookup(fd, &sfd)) < 0)
  801c87:	8d 55 f4             	lea    -0xc(%ebp),%edx
  801c8a:	89 54 24 04          	mov    %edx,0x4(%esp)
  801c8e:	89 04 24             	mov    %eax,(%esp)
  801c91:	e8 c7 f6 ff ff       	call   80135d <fd_lookup>
  801c96:	85 c0                	test   %eax,%eax
  801c98:	78 15                	js     801caf <fd2sockid+0x2e>
		return r;
	if (sfd->fd_dev_id != devsock.dev_id)
  801c9a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801c9d:	8b 0a                	mov    (%edx),%ecx
  801c9f:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801ca4:	3b 0d 20 60 80 00    	cmp    0x806020,%ecx
  801caa:	75 03                	jne    801caf <fd2sockid+0x2e>
		return -E_NOT_SUPP;
	return sfd->fd_sock.sockid;
  801cac:	8b 42 0c             	mov    0xc(%edx),%eax
}
  801caf:	c9                   	leave  
  801cb0:	c3                   	ret    

00801cb1 <listen>:
	return nsipc_connect(r, name, namelen);
}

int
listen(int s, int backlog)
{
  801cb1:	55                   	push   %ebp
  801cb2:	89 e5                	mov    %esp,%ebp
  801cb4:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  801cb7:	8b 45 08             	mov    0x8(%ebp),%eax
  801cba:	e8 c2 ff ff ff       	call   801c81 <fd2sockid>
  801cbf:	85 c0                	test   %eax,%eax
  801cc1:	78 0f                	js     801cd2 <listen+0x21>
		return r;
	return nsipc_listen(r, backlog);
  801cc3:	8b 55 0c             	mov    0xc(%ebp),%edx
  801cc6:	89 54 24 04          	mov    %edx,0x4(%esp)
  801cca:	89 04 24             	mov    %eax,(%esp)
  801ccd:	e8 2e 01 00 00       	call   801e00 <nsipc_listen>
}
  801cd2:	c9                   	leave  
  801cd3:	c3                   	ret    

00801cd4 <connect>:
	return nsipc_close(fd->fd_sock.sockid);
}

int
connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  801cd4:	55                   	push   %ebp
  801cd5:	89 e5                	mov    %esp,%ebp
  801cd7:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  801cda:	8b 45 08             	mov    0x8(%ebp),%eax
  801cdd:	e8 9f ff ff ff       	call   801c81 <fd2sockid>
  801ce2:	85 c0                	test   %eax,%eax
  801ce4:	78 16                	js     801cfc <connect+0x28>
		return r;
	return nsipc_connect(r, name, namelen);
  801ce6:	8b 55 10             	mov    0x10(%ebp),%edx
  801ce9:	89 54 24 08          	mov    %edx,0x8(%esp)
  801ced:	8b 55 0c             	mov    0xc(%ebp),%edx
  801cf0:	89 54 24 04          	mov    %edx,0x4(%esp)
  801cf4:	89 04 24             	mov    %eax,(%esp)
  801cf7:	e8 55 02 00 00       	call   801f51 <nsipc_connect>
}
  801cfc:	c9                   	leave  
  801cfd:	c3                   	ret    

00801cfe <shutdown>:
	return nsipc_bind(r, name, namelen);
}

int
shutdown(int s, int how)
{
  801cfe:	55                   	push   %ebp
  801cff:	89 e5                	mov    %esp,%ebp
  801d01:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  801d04:	8b 45 08             	mov    0x8(%ebp),%eax
  801d07:	e8 75 ff ff ff       	call   801c81 <fd2sockid>
  801d0c:	85 c0                	test   %eax,%eax
  801d0e:	78 0f                	js     801d1f <shutdown+0x21>
		return r;
	return nsipc_shutdown(r, how);
  801d10:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d13:	89 54 24 04          	mov    %edx,0x4(%esp)
  801d17:	89 04 24             	mov    %eax,(%esp)
  801d1a:	e8 1d 01 00 00       	call   801e3c <nsipc_shutdown>
}
  801d1f:	c9                   	leave  
  801d20:	c3                   	ret    

00801d21 <bind>:
	return alloc_sockfd(r);
}

int
bind(int s, struct sockaddr *name, socklen_t namelen)
{
  801d21:	55                   	push   %ebp
  801d22:	89 e5                	mov    %esp,%ebp
  801d24:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  801d27:	8b 45 08             	mov    0x8(%ebp),%eax
  801d2a:	e8 52 ff ff ff       	call   801c81 <fd2sockid>
  801d2f:	85 c0                	test   %eax,%eax
  801d31:	78 16                	js     801d49 <bind+0x28>
		return r;
	return nsipc_bind(r, name, namelen);
  801d33:	8b 55 10             	mov    0x10(%ebp),%edx
  801d36:	89 54 24 08          	mov    %edx,0x8(%esp)
  801d3a:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d3d:	89 54 24 04          	mov    %edx,0x4(%esp)
  801d41:	89 04 24             	mov    %eax,(%esp)
  801d44:	e8 47 02 00 00       	call   801f90 <nsipc_bind>
}
  801d49:	c9                   	leave  
  801d4a:	c3                   	ret    

00801d4b <accept>:
	return fd2num(sfd);
}

int
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  801d4b:	55                   	push   %ebp
  801d4c:	89 e5                	mov    %esp,%ebp
  801d4e:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  801d51:	8b 45 08             	mov    0x8(%ebp),%eax
  801d54:	e8 28 ff ff ff       	call   801c81 <fd2sockid>
  801d59:	85 c0                	test   %eax,%eax
  801d5b:	78 1f                	js     801d7c <accept+0x31>
		return r;
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  801d5d:	8b 55 10             	mov    0x10(%ebp),%edx
  801d60:	89 54 24 08          	mov    %edx,0x8(%esp)
  801d64:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d67:	89 54 24 04          	mov    %edx,0x4(%esp)
  801d6b:	89 04 24             	mov    %eax,(%esp)
  801d6e:	e8 5c 02 00 00       	call   801fcf <nsipc_accept>
  801d73:	85 c0                	test   %eax,%eax
  801d75:	78 05                	js     801d7c <accept+0x31>
		return r;
	return alloc_sockfd(r);
  801d77:	e8 62 fe ff ff       	call   801bde <alloc_sockfd>
}
  801d7c:	c9                   	leave  
  801d7d:	8d 76 00             	lea    0x0(%esi),%esi
  801d80:	c3                   	ret    
	...

00801d90 <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  801d90:	55                   	push   %ebp
  801d91:	89 e5                	mov    %esp,%ebp
  801d93:	83 ec 18             	sub    $0x18,%esp
	if (debug)
		cprintf("[%08x] nsipc %d\n", env->env_id, type);

	ipc_send(envs[2].env_id, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  801d96:	8b 15 44 01 c0 ee    	mov    0xeec00144,%edx
  801d9c:	c7 44 24 0c 07 00 00 	movl   $0x7,0xc(%esp)
  801da3:	00 
  801da4:	c7 44 24 08 00 50 80 	movl   $0x805000,0x8(%esp)
  801dab:	00 
  801dac:	89 44 24 04          	mov    %eax,0x4(%esp)
  801db0:	89 14 24             	mov    %edx,(%esp)
  801db3:	e8 08 08 00 00       	call   8025c0 <ipc_send>
	return ipc_recv(NULL, NULL, NULL);
  801db8:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801dbf:	00 
  801dc0:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  801dc7:	00 
  801dc8:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801dcf:	e8 52 08 00 00       	call   802626 <ipc_recv>
}
  801dd4:	c9                   	leave  
  801dd5:	c3                   	ret    

00801dd6 <nsipc_socket>:
	return nsipc(NSREQ_SEND);
}

int
nsipc_socket(int domain, int type, int protocol)
{
  801dd6:	55                   	push   %ebp
  801dd7:	89 e5                	mov    %esp,%ebp
  801dd9:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  801ddc:	8b 45 08             	mov    0x8(%ebp),%eax
  801ddf:	a3 00 50 80 00       	mov    %eax,0x805000
	nsipcbuf.socket.req_type = type;
  801de4:	8b 45 0c             	mov    0xc(%ebp),%eax
  801de7:	a3 04 50 80 00       	mov    %eax,0x805004
	nsipcbuf.socket.req_protocol = protocol;
  801dec:	8b 45 10             	mov    0x10(%ebp),%eax
  801def:	a3 08 50 80 00       	mov    %eax,0x805008
	return nsipc(NSREQ_SOCKET);
  801df4:	b8 09 00 00 00       	mov    $0x9,%eax
  801df9:	e8 92 ff ff ff       	call   801d90 <nsipc>
}
  801dfe:	c9                   	leave  
  801dff:	c3                   	ret    

00801e00 <nsipc_listen>:
	return nsipc(NSREQ_CONNECT);
}

int
nsipc_listen(int s, int backlog)
{
  801e00:	55                   	push   %ebp
  801e01:	89 e5                	mov    %esp,%ebp
  801e03:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  801e06:	8b 45 08             	mov    0x8(%ebp),%eax
  801e09:	a3 00 50 80 00       	mov    %eax,0x805000
	nsipcbuf.listen.req_backlog = backlog;
  801e0e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e11:	a3 04 50 80 00       	mov    %eax,0x805004
	return nsipc(NSREQ_LISTEN);
  801e16:	b8 06 00 00 00       	mov    $0x6,%eax
  801e1b:	e8 70 ff ff ff       	call   801d90 <nsipc>
}
  801e20:	c9                   	leave  
  801e21:	c3                   	ret    

00801e22 <nsipc_close>:
	return nsipc(NSREQ_SHUTDOWN);
}

int
nsipc_close(int s)
{
  801e22:	55                   	push   %ebp
  801e23:	89 e5                	mov    %esp,%ebp
  801e25:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  801e28:	8b 45 08             	mov    0x8(%ebp),%eax
  801e2b:	a3 00 50 80 00       	mov    %eax,0x805000
	return nsipc(NSREQ_CLOSE);
  801e30:	b8 04 00 00 00       	mov    $0x4,%eax
  801e35:	e8 56 ff ff ff       	call   801d90 <nsipc>
}
  801e3a:	c9                   	leave  
  801e3b:	c3                   	ret    

00801e3c <nsipc_shutdown>:
	return nsipc(NSREQ_BIND);
}

int
nsipc_shutdown(int s, int how)
{
  801e3c:	55                   	push   %ebp
  801e3d:	89 e5                	mov    %esp,%ebp
  801e3f:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  801e42:	8b 45 08             	mov    0x8(%ebp),%eax
  801e45:	a3 00 50 80 00       	mov    %eax,0x805000
	nsipcbuf.shutdown.req_how = how;
  801e4a:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e4d:	a3 04 50 80 00       	mov    %eax,0x805004
	return nsipc(NSREQ_SHUTDOWN);
  801e52:	b8 03 00 00 00       	mov    $0x3,%eax
  801e57:	e8 34 ff ff ff       	call   801d90 <nsipc>
}
  801e5c:	c9                   	leave  
  801e5d:	c3                   	ret    

00801e5e <nsipc_send>:
	return r;
}

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  801e5e:	55                   	push   %ebp
  801e5f:	89 e5                	mov    %esp,%ebp
  801e61:	53                   	push   %ebx
  801e62:	83 ec 14             	sub    $0x14,%esp
  801e65:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  801e68:	8b 45 08             	mov    0x8(%ebp),%eax
  801e6b:	a3 00 50 80 00       	mov    %eax,0x805000
	assert(size < 1600);
  801e70:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  801e76:	7e 24                	jle    801e9c <nsipc_send+0x3e>
  801e78:	c7 44 24 0c 20 2e 80 	movl   $0x802e20,0xc(%esp)
  801e7f:	00 
  801e80:	c7 44 24 08 2c 2e 80 	movl   $0x802e2c,0x8(%esp)
  801e87:	00 
  801e88:	c7 44 24 04 66 00 00 	movl   $0x66,0x4(%esp)
  801e8f:	00 
  801e90:	c7 04 24 41 2e 80 00 	movl   $0x802e41,(%esp)
  801e97:	e8 c8 e2 ff ff       	call   800164 <_panic>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  801e9c:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801ea0:	8b 45 0c             	mov    0xc(%ebp),%eax
  801ea3:	89 44 24 04          	mov    %eax,0x4(%esp)
  801ea7:	c7 04 24 0c 50 80 00 	movl   $0x80500c,(%esp)
  801eae:	e8 f2 eb ff ff       	call   800aa5 <memmove>
	nsipcbuf.send.req_size = size;
  801eb3:	89 1d 04 50 80 00    	mov    %ebx,0x805004
	nsipcbuf.send.req_flags = flags;
  801eb9:	8b 45 14             	mov    0x14(%ebp),%eax
  801ebc:	a3 08 50 80 00       	mov    %eax,0x805008
	return nsipc(NSREQ_SEND);
  801ec1:	b8 08 00 00 00       	mov    $0x8,%eax
  801ec6:	e8 c5 fe ff ff       	call   801d90 <nsipc>
}
  801ecb:	83 c4 14             	add    $0x14,%esp
  801ece:	5b                   	pop    %ebx
  801ecf:	5d                   	pop    %ebp
  801ed0:	c3                   	ret    

00801ed1 <nsipc_recv>:
	return nsipc(NSREQ_LISTEN);
}

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  801ed1:	55                   	push   %ebp
  801ed2:	89 e5                	mov    %esp,%ebp
  801ed4:	56                   	push   %esi
  801ed5:	53                   	push   %ebx
  801ed6:	83 ec 10             	sub    $0x10,%esp
  801ed9:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  801edc:	8b 45 08             	mov    0x8(%ebp),%eax
  801edf:	a3 00 50 80 00       	mov    %eax,0x805000
	nsipcbuf.recv.req_len = len;
  801ee4:	89 35 04 50 80 00    	mov    %esi,0x805004
	nsipcbuf.recv.req_flags = flags;
  801eea:	8b 45 14             	mov    0x14(%ebp),%eax
  801eed:	a3 08 50 80 00       	mov    %eax,0x805008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  801ef2:	b8 07 00 00 00       	mov    $0x7,%eax
  801ef7:	e8 94 fe ff ff       	call   801d90 <nsipc>
  801efc:	89 c3                	mov    %eax,%ebx
  801efe:	85 c0                	test   %eax,%eax
  801f00:	78 46                	js     801f48 <nsipc_recv+0x77>
		assert(r < 1600 && r <= len);
  801f02:	3d 3f 06 00 00       	cmp    $0x63f,%eax
  801f07:	7f 04                	jg     801f0d <nsipc_recv+0x3c>
  801f09:	39 c6                	cmp    %eax,%esi
  801f0b:	7d 24                	jge    801f31 <nsipc_recv+0x60>
  801f0d:	c7 44 24 0c 4d 2e 80 	movl   $0x802e4d,0xc(%esp)
  801f14:	00 
  801f15:	c7 44 24 08 2c 2e 80 	movl   $0x802e2c,0x8(%esp)
  801f1c:	00 
  801f1d:	c7 44 24 04 5b 00 00 	movl   $0x5b,0x4(%esp)
  801f24:	00 
  801f25:	c7 04 24 41 2e 80 00 	movl   $0x802e41,(%esp)
  801f2c:	e8 33 e2 ff ff       	call   800164 <_panic>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  801f31:	89 44 24 08          	mov    %eax,0x8(%esp)
  801f35:	c7 44 24 04 00 50 80 	movl   $0x805000,0x4(%esp)
  801f3c:	00 
  801f3d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801f40:	89 04 24             	mov    %eax,(%esp)
  801f43:	e8 5d eb ff ff       	call   800aa5 <memmove>
	}

	return r;
}
  801f48:	89 d8                	mov    %ebx,%eax
  801f4a:	83 c4 10             	add    $0x10,%esp
  801f4d:	5b                   	pop    %ebx
  801f4e:	5e                   	pop    %esi
  801f4f:	5d                   	pop    %ebp
  801f50:	c3                   	ret    

00801f51 <nsipc_connect>:
	return nsipc(NSREQ_CLOSE);
}

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  801f51:	55                   	push   %ebp
  801f52:	89 e5                	mov    %esp,%ebp
  801f54:	53                   	push   %ebx
  801f55:	83 ec 14             	sub    $0x14,%esp
  801f58:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  801f5b:	8b 45 08             	mov    0x8(%ebp),%eax
  801f5e:	a3 00 50 80 00       	mov    %eax,0x805000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  801f63:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801f67:	8b 45 0c             	mov    0xc(%ebp),%eax
  801f6a:	89 44 24 04          	mov    %eax,0x4(%esp)
  801f6e:	c7 04 24 04 50 80 00 	movl   $0x805004,(%esp)
  801f75:	e8 2b eb ff ff       	call   800aa5 <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  801f7a:	89 1d 14 50 80 00    	mov    %ebx,0x805014
	return nsipc(NSREQ_CONNECT);
  801f80:	b8 05 00 00 00       	mov    $0x5,%eax
  801f85:	e8 06 fe ff ff       	call   801d90 <nsipc>
}
  801f8a:	83 c4 14             	add    $0x14,%esp
  801f8d:	5b                   	pop    %ebx
  801f8e:	5d                   	pop    %ebp
  801f8f:	c3                   	ret    

00801f90 <nsipc_bind>:
	return r;
}

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  801f90:	55                   	push   %ebp
  801f91:	89 e5                	mov    %esp,%ebp
  801f93:	53                   	push   %ebx
  801f94:	83 ec 14             	sub    $0x14,%esp
  801f97:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  801f9a:	8b 45 08             	mov    0x8(%ebp),%eax
  801f9d:	a3 00 50 80 00       	mov    %eax,0x805000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  801fa2:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801fa6:	8b 45 0c             	mov    0xc(%ebp),%eax
  801fa9:	89 44 24 04          	mov    %eax,0x4(%esp)
  801fad:	c7 04 24 04 50 80 00 	movl   $0x805004,(%esp)
  801fb4:	e8 ec ea ff ff       	call   800aa5 <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  801fb9:	89 1d 14 50 80 00    	mov    %ebx,0x805014
	return nsipc(NSREQ_BIND);
  801fbf:	b8 02 00 00 00       	mov    $0x2,%eax
  801fc4:	e8 c7 fd ff ff       	call   801d90 <nsipc>
}
  801fc9:	83 c4 14             	add    $0x14,%esp
  801fcc:	5b                   	pop    %ebx
  801fcd:	5d                   	pop    %ebp
  801fce:	c3                   	ret    

00801fcf <nsipc_accept>:
	return ipc_recv(NULL, NULL, NULL);
}

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  801fcf:	55                   	push   %ebp
  801fd0:	89 e5                	mov    %esp,%ebp
  801fd2:	83 ec 18             	sub    $0x18,%esp
  801fd5:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  801fd8:	89 75 fc             	mov    %esi,-0x4(%ebp)
	int r;
	
	nsipcbuf.accept.req_s = s;
  801fdb:	8b 45 08             	mov    0x8(%ebp),%eax
  801fde:	a3 00 50 80 00       	mov    %eax,0x805000
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  801fe3:	b8 01 00 00 00       	mov    $0x1,%eax
  801fe8:	e8 a3 fd ff ff       	call   801d90 <nsipc>
  801fed:	89 c3                	mov    %eax,%ebx
  801fef:	85 c0                	test   %eax,%eax
  801ff1:	78 25                	js     802018 <nsipc_accept+0x49>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  801ff3:	be 10 50 80 00       	mov    $0x805010,%esi
  801ff8:	8b 06                	mov    (%esi),%eax
  801ffa:	89 44 24 08          	mov    %eax,0x8(%esp)
  801ffe:	c7 44 24 04 00 50 80 	movl   $0x805000,0x4(%esp)
  802005:	00 
  802006:	8b 45 0c             	mov    0xc(%ebp),%eax
  802009:	89 04 24             	mov    %eax,(%esp)
  80200c:	e8 94 ea ff ff       	call   800aa5 <memmove>
		*addrlen = ret->ret_addrlen;
  802011:	8b 16                	mov    (%esi),%edx
  802013:	8b 45 10             	mov    0x10(%ebp),%eax
  802016:	89 10                	mov    %edx,(%eax)
	}
	return r;
}
  802018:	89 d8                	mov    %ebx,%eax
  80201a:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  80201d:	8b 75 fc             	mov    -0x4(%ebp),%esi
  802020:	89 ec                	mov    %ebp,%esp
  802022:	5d                   	pop    %ebp
  802023:	c3                   	ret    
	...

00802030 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  802030:	55                   	push   %ebp
  802031:	89 e5                	mov    %esp,%ebp
  802033:	83 ec 18             	sub    $0x18,%esp
  802036:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  802039:	89 75 fc             	mov    %esi,-0x4(%ebp)
  80203c:	8b 75 0c             	mov    0xc(%ebp),%esi
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  80203f:	8b 45 08             	mov    0x8(%ebp),%eax
  802042:	89 04 24             	mov    %eax,(%esp)
  802045:	e8 86 f2 ff ff       	call   8012d0 <fd2data>
  80204a:	89 c3                	mov    %eax,%ebx
	strcpy(stat->st_name, "<pipe>");
  80204c:	c7 44 24 04 62 2e 80 	movl   $0x802e62,0x4(%esp)
  802053:	00 
  802054:	89 34 24             	mov    %esi,(%esp)
  802057:	e8 8e e8 ff ff       	call   8008ea <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  80205c:	8b 43 04             	mov    0x4(%ebx),%eax
  80205f:	2b 03                	sub    (%ebx),%eax
  802061:	89 86 80 00 00 00    	mov    %eax,0x80(%esi)
	stat->st_isdir = 0;
  802067:	c7 86 84 00 00 00 00 	movl   $0x0,0x84(%esi)
  80206e:	00 00 00 
	stat->st_dev = &devpipe;
  802071:	c7 86 88 00 00 00 3c 	movl   $0x80603c,0x88(%esi)
  802078:	60 80 00 
	return 0;
}
  80207b:	b8 00 00 00 00       	mov    $0x0,%eax
  802080:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  802083:	8b 75 fc             	mov    -0x4(%ebp),%esi
  802086:	89 ec                	mov    %ebp,%esp
  802088:	5d                   	pop    %ebp
  802089:	c3                   	ret    

0080208a <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  80208a:	55                   	push   %ebp
  80208b:	89 e5                	mov    %esp,%ebp
  80208d:	53                   	push   %ebx
  80208e:	83 ec 14             	sub    $0x14,%esp
  802091:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  802094:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  802098:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80209f:	e8 7b ef ff ff       	call   80101f <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  8020a4:	89 1c 24             	mov    %ebx,(%esp)
  8020a7:	e8 24 f2 ff ff       	call   8012d0 <fd2data>
  8020ac:	89 44 24 04          	mov    %eax,0x4(%esp)
  8020b0:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8020b7:	e8 63 ef ff ff       	call   80101f <sys_page_unmap>
}
  8020bc:	83 c4 14             	add    $0x14,%esp
  8020bf:	5b                   	pop    %ebx
  8020c0:	5d                   	pop    %ebp
  8020c1:	c3                   	ret    

008020c2 <_pipeisclosed>:
	return r;
}

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  8020c2:	55                   	push   %ebp
  8020c3:	89 e5                	mov    %esp,%ebp
  8020c5:	57                   	push   %edi
  8020c6:	56                   	push   %esi
  8020c7:	53                   	push   %ebx
  8020c8:	83 ec 2c             	sub    $0x2c,%esp
  8020cb:	89 c7                	mov    %eax,%edi
  8020cd:	89 55 e4             	mov    %edx,-0x1c(%ebp)
	int n, nn, ret;

	while (1) {
		n = env->env_runs;
  8020d0:	a1 74 60 80 00       	mov    0x806074,%eax
  8020d5:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  8020d8:	89 3c 24             	mov    %edi,(%esp)
  8020db:	e8 b0 05 00 00       	call   802690 <pageref>
  8020e0:	89 c6                	mov    %eax,%esi
  8020e2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8020e5:	89 04 24             	mov    %eax,(%esp)
  8020e8:	e8 a3 05 00 00       	call   802690 <pageref>
  8020ed:	39 c6                	cmp    %eax,%esi
  8020ef:	0f 94 c0             	sete   %al
  8020f2:	0f b6 c0             	movzbl %al,%eax
		nn = env->env_runs;
  8020f5:	8b 15 74 60 80 00    	mov    0x806074,%edx
  8020fb:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  8020fe:	39 cb                	cmp    %ecx,%ebx
  802100:	75 08                	jne    80210a <_pipeisclosed+0x48>
			return ret;
		if (n != nn && ret == 1)
			cprintf("pipe race avoided\n", n, env->env_runs, ret);
	}
}
  802102:	83 c4 2c             	add    $0x2c,%esp
  802105:	5b                   	pop    %ebx
  802106:	5e                   	pop    %esi
  802107:	5f                   	pop    %edi
  802108:	5d                   	pop    %ebp
  802109:	c3                   	ret    
		n = env->env_runs;
		ret = pageref(fd) == pageref(p);
		nn = env->env_runs;
		if (n == nn)
			return ret;
		if (n != nn && ret == 1)
  80210a:	83 f8 01             	cmp    $0x1,%eax
  80210d:	75 c1                	jne    8020d0 <_pipeisclosed+0xe>
			cprintf("pipe race avoided\n", n, env->env_runs, ret);
  80210f:	8b 52 58             	mov    0x58(%edx),%edx
  802112:	89 44 24 0c          	mov    %eax,0xc(%esp)
  802116:	89 54 24 08          	mov    %edx,0x8(%esp)
  80211a:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  80211e:	c7 04 24 69 2e 80 00 	movl   $0x802e69,(%esp)
  802125:	e8 ff e0 ff ff       	call   800229 <cprintf>
  80212a:	eb a4                	jmp    8020d0 <_pipeisclosed+0xe>

0080212c <devpipe_write>:
	return i;
}

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  80212c:	55                   	push   %ebp
  80212d:	89 e5                	mov    %esp,%ebp
  80212f:	57                   	push   %edi
  802130:	56                   	push   %esi
  802131:	53                   	push   %ebx
  802132:	83 ec 1c             	sub    $0x1c,%esp
  802135:	8b 75 08             	mov    0x8(%ebp),%esi
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  802138:	89 34 24             	mov    %esi,(%esp)
  80213b:	e8 90 f1 ff ff       	call   8012d0 <fd2data>
  802140:	89 c3                	mov    %eax,%ebx
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			env->env_id, vpt[VPN(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  802142:	bf 00 00 00 00       	mov    $0x0,%edi
  802147:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80214b:	75 54                	jne    8021a1 <devpipe_write+0x75>
  80214d:	eb 60                	jmp    8021af <devpipe_write+0x83>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  80214f:	89 da                	mov    %ebx,%edx
  802151:	89 f0                	mov    %esi,%eax
  802153:	e8 6a ff ff ff       	call   8020c2 <_pipeisclosed>
  802158:	85 c0                	test   %eax,%eax
  80215a:	74 07                	je     802163 <devpipe_write+0x37>
  80215c:	b8 00 00 00 00       	mov    $0x0,%eax
  802161:	eb 53                	jmp    8021b6 <devpipe_write+0x8a>
				return 0;
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  802163:	90                   	nop
  802164:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802168:	e8 cd ef ff ff       	call   80113a <sys_yield>
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			env->env_id, vpt[VPN(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  80216d:	8b 43 04             	mov    0x4(%ebx),%eax
  802170:	8b 13                	mov    (%ebx),%edx
  802172:	83 c2 20             	add    $0x20,%edx
  802175:	39 d0                	cmp    %edx,%eax
  802177:	73 d6                	jae    80214f <devpipe_write+0x23>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  802179:	89 c2                	mov    %eax,%edx
  80217b:	c1 fa 1f             	sar    $0x1f,%edx
  80217e:	c1 ea 1b             	shr    $0x1b,%edx
  802181:	01 d0                	add    %edx,%eax
  802183:	83 e0 1f             	and    $0x1f,%eax
  802186:	29 d0                	sub    %edx,%eax
  802188:	89 c2                	mov    %eax,%edx
  80218a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80218d:	0f b6 04 39          	movzbl (%ecx,%edi,1),%eax
  802191:	88 44 13 08          	mov    %al,0x8(%ebx,%edx,1)
		p->p_wpos++;
  802195:	83 43 04 01          	addl   $0x1,0x4(%ebx)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			env->env_id, vpt[VPN(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  802199:	83 c7 01             	add    $0x1,%edi
  80219c:	39 7d 10             	cmp    %edi,0x10(%ebp)
  80219f:	76 13                	jbe    8021b4 <devpipe_write+0x88>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  8021a1:	8b 43 04             	mov    0x4(%ebx),%eax
  8021a4:	8b 13                	mov    (%ebx),%edx
  8021a6:	83 c2 20             	add    $0x20,%edx
  8021a9:	39 d0                	cmp    %edx,%eax
  8021ab:	73 a2                	jae    80214f <devpipe_write+0x23>
  8021ad:	eb ca                	jmp    802179 <devpipe_write+0x4d>
  8021af:	bf 00 00 00 00       	mov    $0x0,%edi
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}
	
	return i;
  8021b4:	89 f8                	mov    %edi,%eax
}
  8021b6:	83 c4 1c             	add    $0x1c,%esp
  8021b9:	5b                   	pop    %ebx
  8021ba:	5e                   	pop    %esi
  8021bb:	5f                   	pop    %edi
  8021bc:	5d                   	pop    %ebp
  8021bd:	c3                   	ret    

008021be <devpipe_read>:
	return _pipeisclosed(fd, p);
}

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  8021be:	55                   	push   %ebp
  8021bf:	89 e5                	mov    %esp,%ebp
  8021c1:	83 ec 28             	sub    $0x28,%esp
  8021c4:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  8021c7:	89 75 f8             	mov    %esi,-0x8(%ebp)
  8021ca:	89 7d fc             	mov    %edi,-0x4(%ebp)
  8021cd:	8b 7d 08             	mov    0x8(%ebp),%edi
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  8021d0:	89 3c 24             	mov    %edi,(%esp)
  8021d3:	e8 f8 f0 ff ff       	call   8012d0 <fd2data>
  8021d8:	89 c3                	mov    %eax,%ebx
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			env->env_id, vpt[VPN(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  8021da:	be 00 00 00 00       	mov    $0x0,%esi
  8021df:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8021e3:	75 4c                	jne    802231 <devpipe_read+0x73>
  8021e5:	eb 5b                	jmp    802242 <devpipe_read+0x84>
		while (p->p_rpos == p->p_wpos) {
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
				return i;
  8021e7:	89 f0                	mov    %esi,%eax
  8021e9:	eb 5e                	jmp    802249 <devpipe_read+0x8b>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  8021eb:	89 da                	mov    %ebx,%edx
  8021ed:	89 f8                	mov    %edi,%eax
  8021ef:	90                   	nop
  8021f0:	e8 cd fe ff ff       	call   8020c2 <_pipeisclosed>
  8021f5:	85 c0                	test   %eax,%eax
  8021f7:	74 07                	je     802200 <devpipe_read+0x42>
  8021f9:	b8 00 00 00 00       	mov    $0x0,%eax
  8021fe:	eb 49                	jmp    802249 <devpipe_read+0x8b>
				return 0;
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  802200:	e8 35 ef ff ff       	call   80113a <sys_yield>
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			env->env_id, vpt[VPN(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  802205:	8b 03                	mov    (%ebx),%eax
  802207:	3b 43 04             	cmp    0x4(%ebx),%eax
  80220a:	74 df                	je     8021eb <devpipe_read+0x2d>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  80220c:	89 c2                	mov    %eax,%edx
  80220e:	c1 fa 1f             	sar    $0x1f,%edx
  802211:	c1 ea 1b             	shr    $0x1b,%edx
  802214:	01 d0                	add    %edx,%eax
  802216:	83 e0 1f             	and    $0x1f,%eax
  802219:	29 d0                	sub    %edx,%eax
  80221b:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  802220:	8b 55 0c             	mov    0xc(%ebp),%edx
  802223:	88 04 32             	mov    %al,(%edx,%esi,1)
		p->p_rpos++;
  802226:	83 03 01             	addl   $0x1,(%ebx)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			env->env_id, vpt[VPN(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  802229:	83 c6 01             	add    $0x1,%esi
  80222c:	39 75 10             	cmp    %esi,0x10(%ebp)
  80222f:	76 16                	jbe    802247 <devpipe_read+0x89>
		while (p->p_rpos == p->p_wpos) {
  802231:	8b 03                	mov    (%ebx),%eax
  802233:	3b 43 04             	cmp    0x4(%ebx),%eax
  802236:	75 d4                	jne    80220c <devpipe_read+0x4e>
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  802238:	85 f6                	test   %esi,%esi
  80223a:	75 ab                	jne    8021e7 <devpipe_read+0x29>
  80223c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802240:	eb a9                	jmp    8021eb <devpipe_read+0x2d>
  802242:	be 00 00 00 00       	mov    $0x0,%esi
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  802247:	89 f0                	mov    %esi,%eax
}
  802249:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  80224c:	8b 75 f8             	mov    -0x8(%ebp),%esi
  80224f:	8b 7d fc             	mov    -0x4(%ebp),%edi
  802252:	89 ec                	mov    %ebp,%esp
  802254:	5d                   	pop    %ebp
  802255:	c3                   	ret    

00802256 <pipeisclosed>:
	}
}

int
pipeisclosed(int fdnum)
{
  802256:	55                   	push   %ebp
  802257:	89 e5                	mov    %esp,%ebp
  802259:	83 ec 28             	sub    $0x28,%esp
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80225c:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80225f:	89 44 24 04          	mov    %eax,0x4(%esp)
  802263:	8b 45 08             	mov    0x8(%ebp),%eax
  802266:	89 04 24             	mov    %eax,(%esp)
  802269:	e8 ef f0 ff ff       	call   80135d <fd_lookup>
  80226e:	85 c0                	test   %eax,%eax
  802270:	78 15                	js     802287 <pipeisclosed+0x31>
		return r;
	p = (struct Pipe*) fd2data(fd);
  802272:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802275:	89 04 24             	mov    %eax,(%esp)
  802278:	e8 53 f0 ff ff       	call   8012d0 <fd2data>
	return _pipeisclosed(fd, p);
  80227d:	89 c2                	mov    %eax,%edx
  80227f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802282:	e8 3b fe ff ff       	call   8020c2 <_pipeisclosed>
}
  802287:	c9                   	leave  
  802288:	c3                   	ret    

00802289 <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  802289:	55                   	push   %ebp
  80228a:	89 e5                	mov    %esp,%ebp
  80228c:	83 ec 48             	sub    $0x48,%esp
  80228f:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  802292:	89 75 f8             	mov    %esi,-0x8(%ebp)
  802295:	89 7d fc             	mov    %edi,-0x4(%ebp)
  802298:	8b 7d 08             	mov    0x8(%ebp),%edi
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  80229b:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  80229e:	89 04 24             	mov    %eax,(%esp)
  8022a1:	e8 45 f0 ff ff       	call   8012eb <fd_alloc>
  8022a6:	89 c3                	mov    %eax,%ebx
  8022a8:	85 c0                	test   %eax,%eax
  8022aa:	0f 88 42 01 00 00    	js     8023f2 <pipe+0x169>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8022b0:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  8022b7:	00 
  8022b8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8022bb:	89 44 24 04          	mov    %eax,0x4(%esp)
  8022bf:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8022c6:	e8 10 ee ff ff       	call   8010db <sys_page_alloc>
  8022cb:	89 c3                	mov    %eax,%ebx
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  8022cd:	85 c0                	test   %eax,%eax
  8022cf:	0f 88 1d 01 00 00    	js     8023f2 <pipe+0x169>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  8022d5:	8d 45 e0             	lea    -0x20(%ebp),%eax
  8022d8:	89 04 24             	mov    %eax,(%esp)
  8022db:	e8 0b f0 ff ff       	call   8012eb <fd_alloc>
  8022e0:	89 c3                	mov    %eax,%ebx
  8022e2:	85 c0                	test   %eax,%eax
  8022e4:	0f 88 f5 00 00 00    	js     8023df <pipe+0x156>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8022ea:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  8022f1:	00 
  8022f2:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8022f5:	89 44 24 04          	mov    %eax,0x4(%esp)
  8022f9:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802300:	e8 d6 ed ff ff       	call   8010db <sys_page_alloc>
  802305:	89 c3                	mov    %eax,%ebx
	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  802307:	85 c0                	test   %eax,%eax
  802309:	0f 88 d0 00 00 00    	js     8023df <pipe+0x156>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  80230f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802312:	89 04 24             	mov    %eax,(%esp)
  802315:	e8 b6 ef ff ff       	call   8012d0 <fd2data>
  80231a:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80231c:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  802323:	00 
  802324:	89 44 24 04          	mov    %eax,0x4(%esp)
  802328:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80232f:	e8 a7 ed ff ff       	call   8010db <sys_page_alloc>
  802334:	89 c3                	mov    %eax,%ebx
  802336:	85 c0                	test   %eax,%eax
  802338:	0f 88 8e 00 00 00    	js     8023cc <pipe+0x143>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80233e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802341:	89 04 24             	mov    %eax,(%esp)
  802344:	e8 87 ef ff ff       	call   8012d0 <fd2data>
  802349:	c7 44 24 10 07 04 00 	movl   $0x407,0x10(%esp)
  802350:	00 
  802351:	89 44 24 0c          	mov    %eax,0xc(%esp)
  802355:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  80235c:	00 
  80235d:	89 74 24 04          	mov    %esi,0x4(%esp)
  802361:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802368:	e8 10 ed ff ff       	call   80107d <sys_page_map>
  80236d:	89 c3                	mov    %eax,%ebx
  80236f:	85 c0                	test   %eax,%eax
  802371:	78 49                	js     8023bc <pipe+0x133>
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  802373:	b8 3c 60 80 00       	mov    $0x80603c,%eax
  802378:	8b 08                	mov    (%eax),%ecx
  80237a:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80237d:	89 0a                	mov    %ecx,(%edx)
	fd0->fd_omode = O_RDONLY;
  80237f:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802382:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%edx)

	fd1->fd_dev_id = devpipe.dev_id;
  802389:	8b 10                	mov    (%eax),%edx
  80238b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80238e:	89 10                	mov    %edx,(%eax)
	fd1->fd_omode = O_WRONLY;
  802390:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802393:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", env->env_id, vpt[VPN(va)]);

	pfd[0] = fd2num(fd0);
  80239a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80239d:	89 04 24             	mov    %eax,(%esp)
  8023a0:	e8 1b ef ff ff       	call   8012c0 <fd2num>
  8023a5:	89 07                	mov    %eax,(%edi)
	pfd[1] = fd2num(fd1);
  8023a7:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8023aa:	89 04 24             	mov    %eax,(%esp)
  8023ad:	e8 0e ef ff ff       	call   8012c0 <fd2num>
  8023b2:	89 47 04             	mov    %eax,0x4(%edi)
  8023b5:	bb 00 00 00 00       	mov    $0x0,%ebx
	return 0;
  8023ba:	eb 36                	jmp    8023f2 <pipe+0x169>

    err3:
	sys_page_unmap(0, va);
  8023bc:	89 74 24 04          	mov    %esi,0x4(%esp)
  8023c0:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8023c7:	e8 53 ec ff ff       	call   80101f <sys_page_unmap>
    err2:
	sys_page_unmap(0, fd1);
  8023cc:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8023cf:	89 44 24 04          	mov    %eax,0x4(%esp)
  8023d3:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8023da:	e8 40 ec ff ff       	call   80101f <sys_page_unmap>
    err1:
	sys_page_unmap(0, fd0);
  8023df:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8023e2:	89 44 24 04          	mov    %eax,0x4(%esp)
  8023e6:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8023ed:	e8 2d ec ff ff       	call   80101f <sys_page_unmap>
    err:
	return r;
}
  8023f2:	89 d8                	mov    %ebx,%eax
  8023f4:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  8023f7:	8b 75 f8             	mov    -0x8(%ebp),%esi
  8023fa:	8b 7d fc             	mov    -0x4(%ebp),%edi
  8023fd:	89 ec                	mov    %ebp,%esp
  8023ff:	5d                   	pop    %ebp
  802400:	c3                   	ret    
	...

00802410 <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  802410:	55                   	push   %ebp
  802411:	89 e5                	mov    %esp,%ebp
	USED(fd);

	return 0;
}
  802413:	b8 00 00 00 00       	mov    $0x0,%eax
  802418:	5d                   	pop    %ebp
  802419:	c3                   	ret    

0080241a <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  80241a:	55                   	push   %ebp
  80241b:	89 e5                	mov    %esp,%ebp
  80241d:	83 ec 18             	sub    $0x18,%esp
	strcpy(stat->st_name, "<cons>");
  802420:	c7 44 24 04 81 2e 80 	movl   $0x802e81,0x4(%esp)
  802427:	00 
  802428:	8b 45 0c             	mov    0xc(%ebp),%eax
  80242b:	89 04 24             	mov    %eax,(%esp)
  80242e:	e8 b7 e4 ff ff       	call   8008ea <strcpy>
	return 0;
}
  802433:	b8 00 00 00 00       	mov    $0x0,%eax
  802438:	c9                   	leave  
  802439:	c3                   	ret    

0080243a <devcons_write>:
	return 1;
}

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  80243a:	55                   	push   %ebp
  80243b:	89 e5                	mov    %esp,%ebp
  80243d:	57                   	push   %edi
  80243e:	56                   	push   %esi
  80243f:	53                   	push   %ebx
  802440:	81 ec 9c 00 00 00    	sub    $0x9c,%esp
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs, 
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  802446:	b8 00 00 00 00       	mov    $0x0,%eax
  80244b:	be 00 00 00 00       	mov    $0x0,%esi
  802450:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  802454:	74 3f                	je     802495 <devcons_write+0x5b>
		m = n - tot;
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  802456:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs, 
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
		m = n - tot;
  80245c:	8b 55 10             	mov    0x10(%ebp),%edx
  80245f:	29 c2                	sub    %eax,%edx
  802461:	89 d3                	mov    %edx,%ebx
		if (m > sizeof(buf) - 1)
  802463:	83 fa 7f             	cmp    $0x7f,%edx
  802466:	76 05                	jbe    80246d <devcons_write+0x33>
  802468:	bb 7f 00 00 00       	mov    $0x7f,%ebx
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  80246d:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  802471:	03 45 0c             	add    0xc(%ebp),%eax
  802474:	89 44 24 04          	mov    %eax,0x4(%esp)
  802478:	89 3c 24             	mov    %edi,(%esp)
  80247b:	e8 25 e6 ff ff       	call   800aa5 <memmove>
		sys_cputs(buf, m);
  802480:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  802484:	89 3c 24             	mov    %edi,(%esp)
  802487:	e8 54 e8 ff ff       	call   800ce0 <sys_cputs>
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs, 
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  80248c:	01 de                	add    %ebx,%esi
  80248e:	89 f0                	mov    %esi,%eax
  802490:	3b 75 10             	cmp    0x10(%ebp),%esi
  802493:	72 c7                	jb     80245c <devcons_write+0x22>
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
}
  802495:	89 f0                	mov    %esi,%eax
  802497:	81 c4 9c 00 00 00    	add    $0x9c,%esp
  80249d:	5b                   	pop    %ebx
  80249e:	5e                   	pop    %esi
  80249f:	5f                   	pop    %edi
  8024a0:	5d                   	pop    %ebp
  8024a1:	c3                   	ret    

008024a2 <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  8024a2:	55                   	push   %ebp
  8024a3:	89 e5                	mov    %esp,%ebp
  8024a5:	83 ec 28             	sub    $0x28,%esp
	char c = ch;
  8024a8:	8b 45 08             	mov    0x8(%ebp),%eax
  8024ab:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  8024ae:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  8024b5:	00 
  8024b6:	8d 45 f7             	lea    -0x9(%ebp),%eax
  8024b9:	89 04 24             	mov    %eax,(%esp)
  8024bc:	e8 1f e8 ff ff       	call   800ce0 <sys_cputs>
}
  8024c1:	c9                   	leave  
  8024c2:	c3                   	ret    

008024c3 <devcons_read>:
	return fd2num(fd);
}

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  8024c3:	55                   	push   %ebp
  8024c4:	89 e5                	mov    %esp,%ebp
  8024c6:	83 ec 08             	sub    $0x8,%esp
	int c;

	if (n == 0)
  8024c9:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8024cd:	75 07                	jne    8024d6 <devcons_read+0x13>
  8024cf:	eb 28                	jmp    8024f9 <devcons_read+0x36>
		return 0;

	while ((c = sys_cgetc()) == 0)
		sys_yield();
  8024d1:	e8 64 ec ff ff       	call   80113a <sys_yield>
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  8024d6:	66 90                	xchg   %ax,%ax
  8024d8:	e8 cf e7 ff ff       	call   800cac <sys_cgetc>
  8024dd:	85 c0                	test   %eax,%eax
  8024df:	90                   	nop
  8024e0:	74 ef                	je     8024d1 <devcons_read+0xe>
  8024e2:	89 c2                	mov    %eax,%edx
		sys_yield();
	if (c < 0)
  8024e4:	85 c0                	test   %eax,%eax
  8024e6:	78 16                	js     8024fe <devcons_read+0x3b>
		return c;
	if (c == 0x04)	// ctl-d is eof
  8024e8:	83 f8 04             	cmp    $0x4,%eax
  8024eb:	74 0c                	je     8024f9 <devcons_read+0x36>
		return 0;
	*(char*)vbuf = c;
  8024ed:	8b 45 0c             	mov    0xc(%ebp),%eax
  8024f0:	88 10                	mov    %dl,(%eax)
  8024f2:	b8 01 00 00 00       	mov    $0x1,%eax
	return 1;
  8024f7:	eb 05                	jmp    8024fe <devcons_read+0x3b>
  8024f9:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8024fe:	c9                   	leave  
  8024ff:	c3                   	ret    

00802500 <opencons>:
	return fd->fd_dev_id == devcons.dev_id;
}

int
opencons(void)
{
  802500:	55                   	push   %ebp
  802501:	89 e5                	mov    %esp,%ebp
  802503:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  802506:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802509:	89 04 24             	mov    %eax,(%esp)
  80250c:	e8 da ed ff ff       	call   8012eb <fd_alloc>
  802511:	85 c0                	test   %eax,%eax
  802513:	78 3f                	js     802554 <opencons+0x54>
		return r;
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  802515:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  80251c:	00 
  80251d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802520:	89 44 24 04          	mov    %eax,0x4(%esp)
  802524:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80252b:	e8 ab eb ff ff       	call   8010db <sys_page_alloc>
  802530:	85 c0                	test   %eax,%eax
  802532:	78 20                	js     802554 <opencons+0x54>
		return r;
	fd->fd_dev_id = devcons.dev_id;
  802534:	8b 15 58 60 80 00    	mov    0x806058,%edx
  80253a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80253d:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  80253f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802542:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  802549:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80254c:	89 04 24             	mov    %eax,(%esp)
  80254f:	e8 6c ed ff ff       	call   8012c0 <fd2num>
}
  802554:	c9                   	leave  
  802555:	c3                   	ret    

00802556 <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  802556:	55                   	push   %ebp
  802557:	89 e5                	mov    %esp,%ebp
  802559:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80255c:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80255f:	89 44 24 04          	mov    %eax,0x4(%esp)
  802563:	8b 45 08             	mov    0x8(%ebp),%eax
  802566:	89 04 24             	mov    %eax,(%esp)
  802569:	e8 ef ed ff ff       	call   80135d <fd_lookup>
  80256e:	85 c0                	test   %eax,%eax
  802570:	78 11                	js     802583 <iscons+0x2d>
		return r;
	return fd->fd_dev_id == devcons.dev_id;
  802572:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802575:	8b 00                	mov    (%eax),%eax
  802577:	3b 05 58 60 80 00    	cmp    0x806058,%eax
  80257d:	0f 94 c0             	sete   %al
  802580:	0f b6 c0             	movzbl %al,%eax
}
  802583:	c9                   	leave  
  802584:	c3                   	ret    

00802585 <getchar>:
	sys_cputs(&c, 1);
}

int
getchar(void)
{
  802585:	55                   	push   %ebp
  802586:	89 e5                	mov    %esp,%ebp
  802588:	83 ec 28             	sub    $0x28,%esp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  80258b:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  802592:	00 
  802593:	8d 45 f7             	lea    -0x9(%ebp),%eax
  802596:	89 44 24 04          	mov    %eax,0x4(%esp)
  80259a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8025a1:	e8 18 f0 ff ff       	call   8015be <read>
	if (r < 0)
  8025a6:	85 c0                	test   %eax,%eax
  8025a8:	78 0f                	js     8025b9 <getchar+0x34>
		return r;
	if (r < 1)
  8025aa:	85 c0                	test   %eax,%eax
  8025ac:	7f 07                	jg     8025b5 <getchar+0x30>
  8025ae:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  8025b3:	eb 04                	jmp    8025b9 <getchar+0x34>
		return -E_EOF;
	return c;
  8025b5:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  8025b9:	c9                   	leave  
  8025ba:	c3                   	ret    
  8025bb:	00 00                	add    %al,(%eax)
  8025bd:	00 00                	add    %al,(%eax)
	...

008025c0 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  8025c0:	55                   	push   %ebp
  8025c1:	89 e5                	mov    %esp,%ebp
  8025c3:	57                   	push   %edi
  8025c4:	56                   	push   %esi
  8025c5:	53                   	push   %ebx
  8025c6:	83 ec 1c             	sub    $0x1c,%esp
  8025c9:	8b 7d 0c             	mov    0xc(%ebp),%edi
  8025cc:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8025cf:	8b 75 14             	mov    0x14(%ebp),%esi
	// LAB 4: Your code here.
	int r;
	if (pg == NULL)
  8025d2:	85 db                	test   %ebx,%ebx
  8025d4:	75 2d                	jne    802603 <ipc_send+0x43>
  8025d6:	bb 00 00 c0 ee       	mov    $0xeec00000,%ebx
  8025db:	eb 26                	jmp    802603 <ipc_send+0x43>
		pg = (void*)UTOP;
	while ((r = sys_ipc_try_send(to_env, val, pg, perm)) < 0)
	{
		if(r != -E_IPC_NOT_RECV)
  8025dd:	83 f8 f9             	cmp    $0xfffffff9,%eax
  8025e0:	74 1c                	je     8025fe <ipc_send+0x3e>
			panic("Panic in lib ipc.c : ipc_send() \n");
  8025e2:	c7 44 24 08 90 2e 80 	movl   $0x802e90,0x8(%esp)
  8025e9:	00 
  8025ea:	c7 44 24 04 44 00 00 	movl   $0x44,0x4(%esp)
  8025f1:	00 
  8025f2:	c7 04 24 b4 2e 80 00 	movl   $0x802eb4,(%esp)
  8025f9:	e8 66 db ff ff       	call   800164 <_panic>
		sys_yield();
  8025fe:	e8 37 eb ff ff       	call   80113a <sys_yield>
{
	// LAB 4: Your code here.
	int r;
	if (pg == NULL)
		pg = (void*)UTOP;
	while ((r = sys_ipc_try_send(to_env, val, pg, perm)) < 0)
  802603:	89 74 24 0c          	mov    %esi,0xc(%esp)
  802607:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80260b:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80260f:	8b 45 08             	mov    0x8(%ebp),%eax
  802612:	89 04 24             	mov    %eax,(%esp)
  802615:	e8 b3 e8 ff ff       	call   800ecd <sys_ipc_try_send>
  80261a:	85 c0                	test   %eax,%eax
  80261c:	78 bf                	js     8025dd <ipc_send+0x1d>
		if(r != -E_IPC_NOT_RECV)
			panic("Panic in lib ipc.c : ipc_send() \n");
		sys_yield();
	}
	//panic("ipc_send not implemented");
}
  80261e:	83 c4 1c             	add    $0x1c,%esp
  802621:	5b                   	pop    %ebx
  802622:	5e                   	pop    %esi
  802623:	5f                   	pop    %edi
  802624:	5d                   	pop    %ebp
  802625:	c3                   	ret    

00802626 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  802626:	55                   	push   %ebp
  802627:	89 e5                	mov    %esp,%ebp
  802629:	56                   	push   %esi
  80262a:	53                   	push   %ebx
  80262b:	83 ec 10             	sub    $0x10,%esp
  80262e:	8b 5d 08             	mov    0x8(%ebp),%ebx
  802631:	8b 45 0c             	mov    0xc(%ebp),%eax
  802634:	8b 75 10             	mov    0x10(%ebp),%esi
	// LAB 4: Your code here.
	int r;

	if (pg == NULL)
  802637:	85 c0                	test   %eax,%eax
  802639:	75 05                	jne    802640 <ipc_recv+0x1a>
  80263b:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
		pg = (void*)UTOP;
	if ((r = sys_ipc_recv(pg)) < 0)
  802640:	89 04 24             	mov    %eax,(%esp)
  802643:	e8 28 e8 ff ff       	call   800e70 <sys_ipc_recv>
  802648:	85 c0                	test   %eax,%eax
  80264a:	79 16                	jns    802662 <ipc_recv+0x3c>
	{
		if (from_env_store != NULL)
  80264c:	85 db                	test   %ebx,%ebx
  80264e:	74 06                	je     802656 <ipc_recv+0x30>
			*from_env_store = 0;
  802650:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
		if(perm_store != NULL)
  802656:	85 f6                	test   %esi,%esi
  802658:	74 2c                	je     802686 <ipc_recv+0x60>
			*perm_store = 0;
  80265a:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
  802660:	eb 24                	jmp    802686 <ipc_recv+0x60>
		return r;
	}
	else
	{	
		if (from_env_store != NULL)
  802662:	85 db                	test   %ebx,%ebx
  802664:	74 0a                	je     802670 <ipc_recv+0x4a>
			*from_env_store = env->env_ipc_from;
  802666:	a1 74 60 80 00       	mov    0x806074,%eax
  80266b:	8b 40 74             	mov    0x74(%eax),%eax
  80266e:	89 03                	mov    %eax,(%ebx)
		if(perm_store != NULL)
  802670:	85 f6                	test   %esi,%esi
  802672:	74 0a                	je     80267e <ipc_recv+0x58>
			*perm_store = env->env_ipc_perm;
  802674:	a1 74 60 80 00       	mov    0x806074,%eax
  802679:	8b 40 78             	mov    0x78(%eax),%eax
  80267c:	89 06                	mov    %eax,(%esi)
		return env->env_ipc_value;
  80267e:	a1 74 60 80 00       	mov    0x806074,%eax
  802683:	8b 40 70             	mov    0x70(%eax),%eax
	}		
	//panic("ipc_recv not implemented");
	//return 0;
}
  802686:	83 c4 10             	add    $0x10,%esp
  802689:	5b                   	pop    %ebx
  80268a:	5e                   	pop    %esi
  80268b:	5d                   	pop    %ebp
  80268c:	c3                   	ret    
  80268d:	00 00                	add    %al,(%eax)
	...

00802690 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  802690:	55                   	push   %ebp
  802691:	89 e5                	mov    %esp,%ebp
	pte_t pte;

	if (!(vpd[PDX(v)] & PTE_P))
  802693:	8b 45 08             	mov    0x8(%ebp),%eax
  802696:	89 c2                	mov    %eax,%edx
  802698:	c1 ea 16             	shr    $0x16,%edx
  80269b:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  8026a2:	f6 c2 01             	test   $0x1,%dl
  8026a5:	74 26                	je     8026cd <pageref+0x3d>
		return 0;
	pte = vpt[VPN(v)];
  8026a7:	c1 e8 0c             	shr    $0xc,%eax
  8026aa:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
	if (!(pte & PTE_P))
  8026b1:	a8 01                	test   $0x1,%al
  8026b3:	74 18                	je     8026cd <pageref+0x3d>
		return 0;
	return pages[PPN(pte)].pp_ref;
  8026b5:	c1 e8 0c             	shr    $0xc,%eax
  8026b8:	8d 14 40             	lea    (%eax,%eax,2),%edx
  8026bb:	c1 e2 02             	shl    $0x2,%edx
  8026be:	b8 00 00 00 ef       	mov    $0xef000000,%eax
  8026c3:	0f b7 44 02 08       	movzwl 0x8(%edx,%eax,1),%eax
  8026c8:	0f b7 c0             	movzwl %ax,%eax
  8026cb:	eb 05                	jmp    8026d2 <pageref+0x42>
  8026cd:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8026d2:	5d                   	pop    %ebp
  8026d3:	c3                   	ret    
	...

008026e0 <__udivdi3>:
  8026e0:	55                   	push   %ebp
  8026e1:	89 e5                	mov    %esp,%ebp
  8026e3:	57                   	push   %edi
  8026e4:	56                   	push   %esi
  8026e5:	83 ec 10             	sub    $0x10,%esp
  8026e8:	8b 45 14             	mov    0x14(%ebp),%eax
  8026eb:	8b 55 08             	mov    0x8(%ebp),%edx
  8026ee:	8b 75 10             	mov    0x10(%ebp),%esi
  8026f1:	8b 7d 0c             	mov    0xc(%ebp),%edi
  8026f4:	85 c0                	test   %eax,%eax
  8026f6:	89 55 f0             	mov    %edx,-0x10(%ebp)
  8026f9:	75 35                	jne    802730 <__udivdi3+0x50>
  8026fb:	39 fe                	cmp    %edi,%esi
  8026fd:	77 61                	ja     802760 <__udivdi3+0x80>
  8026ff:	85 f6                	test   %esi,%esi
  802701:	75 0b                	jne    80270e <__udivdi3+0x2e>
  802703:	b8 01 00 00 00       	mov    $0x1,%eax
  802708:	31 d2                	xor    %edx,%edx
  80270a:	f7 f6                	div    %esi
  80270c:	89 c6                	mov    %eax,%esi
  80270e:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  802711:	31 d2                	xor    %edx,%edx
  802713:	89 f8                	mov    %edi,%eax
  802715:	f7 f6                	div    %esi
  802717:	89 c7                	mov    %eax,%edi
  802719:	89 c8                	mov    %ecx,%eax
  80271b:	f7 f6                	div    %esi
  80271d:	89 c1                	mov    %eax,%ecx
  80271f:	89 fa                	mov    %edi,%edx
  802721:	89 c8                	mov    %ecx,%eax
  802723:	83 c4 10             	add    $0x10,%esp
  802726:	5e                   	pop    %esi
  802727:	5f                   	pop    %edi
  802728:	5d                   	pop    %ebp
  802729:	c3                   	ret    
  80272a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  802730:	39 f8                	cmp    %edi,%eax
  802732:	77 1c                	ja     802750 <__udivdi3+0x70>
  802734:	0f bd d0             	bsr    %eax,%edx
  802737:	83 f2 1f             	xor    $0x1f,%edx
  80273a:	89 55 f4             	mov    %edx,-0xc(%ebp)
  80273d:	75 39                	jne    802778 <__udivdi3+0x98>
  80273f:	3b 75 f0             	cmp    -0x10(%ebp),%esi
  802742:	0f 86 a0 00 00 00    	jbe    8027e8 <__udivdi3+0x108>
  802748:	39 f8                	cmp    %edi,%eax
  80274a:	0f 82 98 00 00 00    	jb     8027e8 <__udivdi3+0x108>
  802750:	31 ff                	xor    %edi,%edi
  802752:	31 c9                	xor    %ecx,%ecx
  802754:	89 c8                	mov    %ecx,%eax
  802756:	89 fa                	mov    %edi,%edx
  802758:	83 c4 10             	add    $0x10,%esp
  80275b:	5e                   	pop    %esi
  80275c:	5f                   	pop    %edi
  80275d:	5d                   	pop    %ebp
  80275e:	c3                   	ret    
  80275f:	90                   	nop
  802760:	89 d1                	mov    %edx,%ecx
  802762:	89 fa                	mov    %edi,%edx
  802764:	89 c8                	mov    %ecx,%eax
  802766:	31 ff                	xor    %edi,%edi
  802768:	f7 f6                	div    %esi
  80276a:	89 c1                	mov    %eax,%ecx
  80276c:	89 fa                	mov    %edi,%edx
  80276e:	89 c8                	mov    %ecx,%eax
  802770:	83 c4 10             	add    $0x10,%esp
  802773:	5e                   	pop    %esi
  802774:	5f                   	pop    %edi
  802775:	5d                   	pop    %ebp
  802776:	c3                   	ret    
  802777:	90                   	nop
  802778:	0f b6 4d f4          	movzbl -0xc(%ebp),%ecx
  80277c:	89 f2                	mov    %esi,%edx
  80277e:	d3 e0                	shl    %cl,%eax
  802780:	89 45 ec             	mov    %eax,-0x14(%ebp)
  802783:	b8 20 00 00 00       	mov    $0x20,%eax
  802788:	2b 45 f4             	sub    -0xc(%ebp),%eax
  80278b:	89 c1                	mov    %eax,%ecx
  80278d:	d3 ea                	shr    %cl,%edx
  80278f:	0f b6 4d f4          	movzbl -0xc(%ebp),%ecx
  802793:	0b 55 ec             	or     -0x14(%ebp),%edx
  802796:	d3 e6                	shl    %cl,%esi
  802798:	89 c1                	mov    %eax,%ecx
  80279a:	89 75 e8             	mov    %esi,-0x18(%ebp)
  80279d:	89 fe                	mov    %edi,%esi
  80279f:	d3 ee                	shr    %cl,%esi
  8027a1:	0f b6 4d f4          	movzbl -0xc(%ebp),%ecx
  8027a5:	89 55 ec             	mov    %edx,-0x14(%ebp)
  8027a8:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8027ab:	d3 e7                	shl    %cl,%edi
  8027ad:	89 c1                	mov    %eax,%ecx
  8027af:	d3 ea                	shr    %cl,%edx
  8027b1:	09 d7                	or     %edx,%edi
  8027b3:	89 f2                	mov    %esi,%edx
  8027b5:	89 f8                	mov    %edi,%eax
  8027b7:	f7 75 ec             	divl   -0x14(%ebp)
  8027ba:	89 d6                	mov    %edx,%esi
  8027bc:	89 c7                	mov    %eax,%edi
  8027be:	f7 65 e8             	mull   -0x18(%ebp)
  8027c1:	39 d6                	cmp    %edx,%esi
  8027c3:	89 55 ec             	mov    %edx,-0x14(%ebp)
  8027c6:	72 30                	jb     8027f8 <__udivdi3+0x118>
  8027c8:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8027cb:	0f b6 4d f4          	movzbl -0xc(%ebp),%ecx
  8027cf:	d3 e2                	shl    %cl,%edx
  8027d1:	39 c2                	cmp    %eax,%edx
  8027d3:	73 05                	jae    8027da <__udivdi3+0xfa>
  8027d5:	3b 75 ec             	cmp    -0x14(%ebp),%esi
  8027d8:	74 1e                	je     8027f8 <__udivdi3+0x118>
  8027da:	89 f9                	mov    %edi,%ecx
  8027dc:	31 ff                	xor    %edi,%edi
  8027de:	e9 71 ff ff ff       	jmp    802754 <__udivdi3+0x74>
  8027e3:	90                   	nop
  8027e4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  8027e8:	31 ff                	xor    %edi,%edi
  8027ea:	b9 01 00 00 00       	mov    $0x1,%ecx
  8027ef:	e9 60 ff ff ff       	jmp    802754 <__udivdi3+0x74>
  8027f4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  8027f8:	8d 4f ff             	lea    -0x1(%edi),%ecx
  8027fb:	31 ff                	xor    %edi,%edi
  8027fd:	89 c8                	mov    %ecx,%eax
  8027ff:	89 fa                	mov    %edi,%edx
  802801:	83 c4 10             	add    $0x10,%esp
  802804:	5e                   	pop    %esi
  802805:	5f                   	pop    %edi
  802806:	5d                   	pop    %ebp
  802807:	c3                   	ret    
	...

00802810 <__umoddi3>:
  802810:	55                   	push   %ebp
  802811:	89 e5                	mov    %esp,%ebp
  802813:	57                   	push   %edi
  802814:	56                   	push   %esi
  802815:	83 ec 20             	sub    $0x20,%esp
  802818:	8b 55 14             	mov    0x14(%ebp),%edx
  80281b:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80281e:	8b 7d 10             	mov    0x10(%ebp),%edi
  802821:	8b 75 0c             	mov    0xc(%ebp),%esi
  802824:	85 d2                	test   %edx,%edx
  802826:	89 c8                	mov    %ecx,%eax
  802828:	89 4d f4             	mov    %ecx,-0xc(%ebp)
  80282b:	75 13                	jne    802840 <__umoddi3+0x30>
  80282d:	39 f7                	cmp    %esi,%edi
  80282f:	76 3f                	jbe    802870 <__umoddi3+0x60>
  802831:	89 f2                	mov    %esi,%edx
  802833:	f7 f7                	div    %edi
  802835:	89 d0                	mov    %edx,%eax
  802837:	31 d2                	xor    %edx,%edx
  802839:	83 c4 20             	add    $0x20,%esp
  80283c:	5e                   	pop    %esi
  80283d:	5f                   	pop    %edi
  80283e:	5d                   	pop    %ebp
  80283f:	c3                   	ret    
  802840:	39 f2                	cmp    %esi,%edx
  802842:	77 4c                	ja     802890 <__umoddi3+0x80>
  802844:	0f bd ca             	bsr    %edx,%ecx
  802847:	83 f1 1f             	xor    $0x1f,%ecx
  80284a:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  80284d:	75 51                	jne    8028a0 <__umoddi3+0x90>
  80284f:	3b 7d f4             	cmp    -0xc(%ebp),%edi
  802852:	0f 87 e0 00 00 00    	ja     802938 <__umoddi3+0x128>
  802858:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80285b:	29 f8                	sub    %edi,%eax
  80285d:	19 d6                	sbb    %edx,%esi
  80285f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802862:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802865:	89 f2                	mov    %esi,%edx
  802867:	83 c4 20             	add    $0x20,%esp
  80286a:	5e                   	pop    %esi
  80286b:	5f                   	pop    %edi
  80286c:	5d                   	pop    %ebp
  80286d:	c3                   	ret    
  80286e:	66 90                	xchg   %ax,%ax
  802870:	85 ff                	test   %edi,%edi
  802872:	75 0b                	jne    80287f <__umoddi3+0x6f>
  802874:	b8 01 00 00 00       	mov    $0x1,%eax
  802879:	31 d2                	xor    %edx,%edx
  80287b:	f7 f7                	div    %edi
  80287d:	89 c7                	mov    %eax,%edi
  80287f:	89 f0                	mov    %esi,%eax
  802881:	31 d2                	xor    %edx,%edx
  802883:	f7 f7                	div    %edi
  802885:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802888:	f7 f7                	div    %edi
  80288a:	eb a9                	jmp    802835 <__umoddi3+0x25>
  80288c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802890:	89 c8                	mov    %ecx,%eax
  802892:	89 f2                	mov    %esi,%edx
  802894:	83 c4 20             	add    $0x20,%esp
  802897:	5e                   	pop    %esi
  802898:	5f                   	pop    %edi
  802899:	5d                   	pop    %ebp
  80289a:	c3                   	ret    
  80289b:	90                   	nop
  80289c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  8028a0:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
  8028a4:	d3 e2                	shl    %cl,%edx
  8028a6:	89 55 f4             	mov    %edx,-0xc(%ebp)
  8028a9:	ba 20 00 00 00       	mov    $0x20,%edx
  8028ae:	2b 55 f0             	sub    -0x10(%ebp),%edx
  8028b1:	89 55 ec             	mov    %edx,-0x14(%ebp)
  8028b4:	0f b6 4d ec          	movzbl -0x14(%ebp),%ecx
  8028b8:	89 fa                	mov    %edi,%edx
  8028ba:	d3 ea                	shr    %cl,%edx
  8028bc:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
  8028c0:	0b 55 f4             	or     -0xc(%ebp),%edx
  8028c3:	d3 e7                	shl    %cl,%edi
  8028c5:	0f b6 4d ec          	movzbl -0x14(%ebp),%ecx
  8028c9:	89 55 f4             	mov    %edx,-0xc(%ebp)
  8028cc:	89 f2                	mov    %esi,%edx
  8028ce:	89 7d e8             	mov    %edi,-0x18(%ebp)
  8028d1:	89 c7                	mov    %eax,%edi
  8028d3:	d3 ea                	shr    %cl,%edx
  8028d5:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
  8028d9:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  8028dc:	89 c2                	mov    %eax,%edx
  8028de:	d3 e6                	shl    %cl,%esi
  8028e0:	0f b6 4d ec          	movzbl -0x14(%ebp),%ecx
  8028e4:	d3 ea                	shr    %cl,%edx
  8028e6:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
  8028ea:	09 d6                	or     %edx,%esi
  8028ec:	89 f0                	mov    %esi,%eax
  8028ee:	8b 75 e4             	mov    -0x1c(%ebp),%esi
  8028f1:	d3 e7                	shl    %cl,%edi
  8028f3:	89 f2                	mov    %esi,%edx
  8028f5:	f7 75 f4             	divl   -0xc(%ebp)
  8028f8:	89 d6                	mov    %edx,%esi
  8028fa:	f7 65 e8             	mull   -0x18(%ebp)
  8028fd:	39 d6                	cmp    %edx,%esi
  8028ff:	72 2b                	jb     80292c <__umoddi3+0x11c>
  802901:	39 c7                	cmp    %eax,%edi
  802903:	72 23                	jb     802928 <__umoddi3+0x118>
  802905:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
  802909:	29 c7                	sub    %eax,%edi
  80290b:	19 d6                	sbb    %edx,%esi
  80290d:	89 f0                	mov    %esi,%eax
  80290f:	89 f2                	mov    %esi,%edx
  802911:	d3 ef                	shr    %cl,%edi
  802913:	0f b6 4d ec          	movzbl -0x14(%ebp),%ecx
  802917:	d3 e0                	shl    %cl,%eax
  802919:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
  80291d:	09 f8                	or     %edi,%eax
  80291f:	d3 ea                	shr    %cl,%edx
  802921:	83 c4 20             	add    $0x20,%esp
  802924:	5e                   	pop    %esi
  802925:	5f                   	pop    %edi
  802926:	5d                   	pop    %ebp
  802927:	c3                   	ret    
  802928:	39 d6                	cmp    %edx,%esi
  80292a:	75 d9                	jne    802905 <__umoddi3+0xf5>
  80292c:	2b 45 e8             	sub    -0x18(%ebp),%eax
  80292f:	1b 55 f4             	sbb    -0xc(%ebp),%edx
  802932:	eb d1                	jmp    802905 <__umoddi3+0xf5>
  802934:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802938:	39 f2                	cmp    %esi,%edx
  80293a:	0f 82 18 ff ff ff    	jb     802858 <__umoddi3+0x48>
  802940:	e9 1d ff ff ff       	jmp    802862 <__umoddi3+0x52>
