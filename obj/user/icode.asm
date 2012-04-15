
obj/user/icode:     file format elf32-i386


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
  80002c:	e8 2b 01 00 00       	call   80015c <libmain>
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
  800037:	56                   	push   %esi
  800038:	53                   	push   %ebx
  800039:	81 ec 30 02 00 00    	sub    $0x230,%esp
	int fd, n, r;
	char buf[512+1];

	binaryname = "icode";
  80003f:	c7 05 00 70 80 00 40 	movl   $0x802f40,0x807000
  800046:	2f 80 00 

	cprintf("icode startup\n");
  800049:	c7 04 24 46 2f 80 00 	movl   $0x802f46,(%esp)
  800050:	e8 38 02 00 00       	call   80028d <cprintf>

	cprintf("icode: open /motd\n");
  800055:	c7 04 24 55 2f 80 00 	movl   $0x802f55,(%esp)
  80005c:	e8 2c 02 00 00       	call   80028d <cprintf>
	if ((fd = open("/motd", O_RDONLY)) < 0)
  800061:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  800068:	00 
  800069:	c7 04 24 68 2f 80 00 	movl   $0x802f68,(%esp)
  800070:	e8 ee 19 00 00       	call   801a63 <open>
  800075:	89 c6                	mov    %eax,%esi
  800077:	85 c0                	test   %eax,%eax
  800079:	79 20                	jns    80009b <umain+0x67>
		panic("icode: open /motd: %e", fd);
  80007b:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80007f:	c7 44 24 08 6e 2f 80 	movl   $0x802f6e,0x8(%esp)
  800086:	00 
  800087:	c7 44 24 04 0f 00 00 	movl   $0xf,0x4(%esp)
  80008e:	00 
  80008f:	c7 04 24 84 2f 80 00 	movl   $0x802f84,(%esp)
  800096:	e8 2d 01 00 00       	call   8001c8 <_panic>

	cprintf("icode: read /motd\n");
  80009b:	c7 04 24 91 2f 80 00 	movl   $0x802f91,(%esp)
  8000a2:	e8 e6 01 00 00       	call   80028d <cprintf>
	while ((n = read(fd, buf, sizeof buf-1)) > 0)
  8000a7:	8d 9d f7 fd ff ff    	lea    -0x209(%ebp),%ebx
  8000ad:	eb 0c                	jmp    8000bb <umain+0x87>
		sys_cputs(buf, n);
  8000af:	89 44 24 04          	mov    %eax,0x4(%esp)
  8000b3:	89 1c 24             	mov    %ebx,(%esp)
  8000b6:	e8 85 0c 00 00       	call   800d40 <sys_cputs>
	cprintf("icode: open /motd\n");
	if ((fd = open("/motd", O_RDONLY)) < 0)
		panic("icode: open /motd: %e", fd);

	cprintf("icode: read /motd\n");
	while ((n = read(fd, buf, sizeof buf-1)) > 0)
  8000bb:	c7 44 24 08 00 02 00 	movl   $0x200,0x8(%esp)
  8000c2:	00 
  8000c3:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8000c7:	89 34 24             	mov    %esi,(%esp)
  8000ca:	e8 8f 14 00 00       	call   80155e <read>
  8000cf:	85 c0                	test   %eax,%eax
  8000d1:	7f dc                	jg     8000af <umain+0x7b>
		sys_cputs(buf, n);

	cprintf("icode: close /motd\n");
  8000d3:	c7 04 24 a4 2f 80 00 	movl   $0x802fa4,(%esp)
  8000da:	e8 ae 01 00 00       	call   80028d <cprintf>
	close(fd);
  8000df:	89 34 24             	mov    %esi,(%esp)
  8000e2:	e8 d7 15 00 00       	call   8016be <close>

	cprintf("icode: spawn /init\n");
  8000e7:	c7 04 24 b8 2f 80 00 	movl   $0x802fb8,(%esp)
  8000ee:	e8 9a 01 00 00       	call   80028d <cprintf>
	if ((r = spawnl("/init", "init", "initarg1", "initarg2", (char*)0)) < 0)
  8000f3:	c7 44 24 10 00 00 00 	movl   $0x0,0x10(%esp)
  8000fa:	00 
  8000fb:	c7 44 24 0c cc 2f 80 	movl   $0x802fcc,0xc(%esp)
  800102:	00 
  800103:	c7 44 24 08 d5 2f 80 	movl   $0x802fd5,0x8(%esp)
  80010a:	00 
  80010b:	c7 44 24 04 df 2f 80 	movl   $0x802fdf,0x4(%esp)
  800112:	00 
  800113:	c7 04 24 de 2f 80 00 	movl   $0x802fde,(%esp)
  80011a:	e8 f0 1f 00 00       	call   80210f <spawnl>
  80011f:	85 c0                	test   %eax,%eax
  800121:	79 20                	jns    800143 <umain+0x10f>
		panic("icode: spawn /init: %e", r);
  800123:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800127:	c7 44 24 08 e4 2f 80 	movl   $0x802fe4,0x8(%esp)
  80012e:	00 
  80012f:	c7 44 24 04 1a 00 00 	movl   $0x1a,0x4(%esp)
  800136:	00 
  800137:	c7 04 24 84 2f 80 00 	movl   $0x802f84,(%esp)
  80013e:	e8 85 00 00 00       	call   8001c8 <_panic>

	cprintf("icode: exiting\n");
  800143:	c7 04 24 fb 2f 80 00 	movl   $0x802ffb,(%esp)
  80014a:	e8 3e 01 00 00       	call   80028d <cprintf>
}
  80014f:	81 c4 30 02 00 00    	add    $0x230,%esp
  800155:	5b                   	pop    %ebx
  800156:	5e                   	pop    %esi
  800157:	5d                   	pop    %ebp
  800158:	c3                   	ret    
  800159:	00 00                	add    %al,(%eax)
	...

0080015c <libmain>:
volatile struct Env *env;
char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  80015c:	55                   	push   %ebp
  80015d:	89 e5                	mov    %esp,%ebp
  80015f:	83 ec 18             	sub    $0x18,%esp
  800162:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  800165:	89 75 fc             	mov    %esi,-0x4(%ebp)
  800168:	8b 75 08             	mov    0x8(%ebp),%esi
  80016b:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	// set env to point at our env structure in envs[].
	// LAB 3b: Your code here.
	// Code added by Swastika / Sandeep	
	envid_t envid = sys_getenvid();
  80016e:	e8 5b 10 00 00       	call   8011ce <sys_getenvid>
	env = &envs[ENVX(envid)];
  800173:	25 ff 03 00 00       	and    $0x3ff,%eax
  800178:	6b c0 7c             	imul   $0x7c,%eax,%eax
  80017b:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800180:	a3 74 70 80 00       	mov    %eax,0x807074

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800185:	85 f6                	test   %esi,%esi
  800187:	7e 07                	jle    800190 <libmain+0x34>
		binaryname = argv[0];
  800189:	8b 03                	mov    (%ebx),%eax
  80018b:	a3 00 70 80 00       	mov    %eax,0x807000

	// call user main routine
	umain(argc, argv);
  800190:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  800194:	89 34 24             	mov    %esi,(%esp)
  800197:	e8 98 fe ff ff       	call   800034 <umain>

	// exit gracefully
	exit();
  80019c:	e8 0b 00 00 00       	call   8001ac <exit>
}
  8001a1:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  8001a4:	8b 75 fc             	mov    -0x4(%ebp),%esi
  8001a7:	89 ec                	mov    %ebp,%esp
  8001a9:	5d                   	pop    %ebp
  8001aa:	c3                   	ret    
	...

008001ac <exit>:
#include <inc/lib.h>

void
exit(void)
{
  8001ac:	55                   	push   %ebp
  8001ad:	89 e5                	mov    %esp,%ebp
  8001af:	83 ec 18             	sub    $0x18,%esp
	close_all();
  8001b2:	e8 84 15 00 00       	call   80173b <close_all>
	sys_env_destroy(0);
  8001b7:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8001be:	e8 3f 10 00 00       	call   801202 <sys_env_destroy>
}
  8001c3:	c9                   	leave  
  8001c4:	c3                   	ret    
  8001c5:	00 00                	add    %al,(%eax)
	...

008001c8 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  8001c8:	55                   	push   %ebp
  8001c9:	89 e5                	mov    %esp,%ebp
  8001cb:	53                   	push   %ebx
  8001cc:	83 ec 14             	sub    $0x14,%esp
 * Panic is called on unresolvable fatal errors.
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
  8001cf:	8d 5d 14             	lea    0x14(%ebp),%ebx
	va_list ap;

	va_start(ap, fmt);

	// Print the panic message
	if (argv0)
  8001d2:	a1 78 70 80 00       	mov    0x807078,%eax
  8001d7:	85 c0                	test   %eax,%eax
  8001d9:	74 10                	je     8001eb <_panic+0x23>
		cprintf("%s: ", argv0);
  8001db:	89 44 24 04          	mov    %eax,0x4(%esp)
  8001df:	c7 04 24 22 30 80 00 	movl   $0x803022,(%esp)
  8001e6:	e8 a2 00 00 00       	call   80028d <cprintf>
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  8001eb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8001ee:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8001f2:	8b 45 08             	mov    0x8(%ebp),%eax
  8001f5:	89 44 24 08          	mov    %eax,0x8(%esp)
  8001f9:	a1 00 70 80 00       	mov    0x807000,%eax
  8001fe:	89 44 24 04          	mov    %eax,0x4(%esp)
  800202:	c7 04 24 27 30 80 00 	movl   $0x803027,(%esp)
  800209:	e8 7f 00 00 00       	call   80028d <cprintf>
	vcprintf(fmt, ap);
  80020e:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  800212:	8b 45 10             	mov    0x10(%ebp),%eax
  800215:	89 04 24             	mov    %eax,(%esp)
  800218:	e8 0f 00 00 00       	call   80022c <vcprintf>
	cprintf("\n");
  80021d:	c7 04 24 13 35 80 00 	movl   $0x803513,(%esp)
  800224:	e8 64 00 00 00       	call   80028d <cprintf>

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  800229:	cc                   	int3   
  80022a:	eb fd                	jmp    800229 <_panic+0x61>

0080022c <vcprintf>:
	b->cnt++;
}

int
vcprintf(const char *fmt, va_list ap)
{
  80022c:	55                   	push   %ebp
  80022d:	89 e5                	mov    %esp,%ebp
  80022f:	81 ec 28 01 00 00    	sub    $0x128,%esp
	struct printbuf b;

	b.idx = 0;
  800235:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  80023c:	00 00 00 
	b.cnt = 0;
  80023f:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800246:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  800249:	8b 45 0c             	mov    0xc(%ebp),%eax
  80024c:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800250:	8b 45 08             	mov    0x8(%ebp),%eax
  800253:	89 44 24 08          	mov    %eax,0x8(%esp)
  800257:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80025d:	89 44 24 04          	mov    %eax,0x4(%esp)
  800261:	c7 04 24 a7 02 80 00 	movl   $0x8002a7,(%esp)
  800268:	e8 d0 01 00 00       	call   80043d <vprintfmt>
	sys_cputs(b.buf, b.idx);
  80026d:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
  800273:	89 44 24 04          	mov    %eax,0x4(%esp)
  800277:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  80027d:	89 04 24             	mov    %eax,(%esp)
  800280:	e8 bb 0a 00 00       	call   800d40 <sys_cputs>

	return b.cnt;
}
  800285:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  80028b:	c9                   	leave  
  80028c:	c3                   	ret    

0080028d <cprintf>:

int
cprintf(const char *fmt, ...)
{
  80028d:	55                   	push   %ebp
  80028e:	89 e5                	mov    %esp,%ebp
  800290:	83 ec 18             	sub    $0x18,%esp

	return b.cnt;
}

int
cprintf(const char *fmt, ...)
  800293:	8d 45 0c             	lea    0xc(%ebp),%eax
{
	va_list ap;
	int cnt;

	va_start(ap, fmt);
	cnt = vcprintf(fmt, ap);
  800296:	89 44 24 04          	mov    %eax,0x4(%esp)
  80029a:	8b 45 08             	mov    0x8(%ebp),%eax
  80029d:	89 04 24             	mov    %eax,(%esp)
  8002a0:	e8 87 ff ff ff       	call   80022c <vcprintf>
	va_end(ap);

	return cnt;
}
  8002a5:	c9                   	leave  
  8002a6:	c3                   	ret    

008002a7 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  8002a7:	55                   	push   %ebp
  8002a8:	89 e5                	mov    %esp,%ebp
  8002aa:	53                   	push   %ebx
  8002ab:	83 ec 14             	sub    $0x14,%esp
  8002ae:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  8002b1:	8b 03                	mov    (%ebx),%eax
  8002b3:	8b 55 08             	mov    0x8(%ebp),%edx
  8002b6:	88 54 03 08          	mov    %dl,0x8(%ebx,%eax,1)
  8002ba:	83 c0 01             	add    $0x1,%eax
  8002bd:	89 03                	mov    %eax,(%ebx)
	if (b->idx == 256-1) {
  8002bf:	3d ff 00 00 00       	cmp    $0xff,%eax
  8002c4:	75 19                	jne    8002df <putch+0x38>
		sys_cputs(b->buf, b->idx);
  8002c6:	c7 44 24 04 ff 00 00 	movl   $0xff,0x4(%esp)
  8002cd:	00 
  8002ce:	8d 43 08             	lea    0x8(%ebx),%eax
  8002d1:	89 04 24             	mov    %eax,(%esp)
  8002d4:	e8 67 0a 00 00       	call   800d40 <sys_cputs>
		b->idx = 0;
  8002d9:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
	}
	b->cnt++;
  8002df:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  8002e3:	83 c4 14             	add    $0x14,%esp
  8002e6:	5b                   	pop    %ebx
  8002e7:	5d                   	pop    %ebp
  8002e8:	c3                   	ret    
  8002e9:	00 00                	add    %al,(%eax)
  8002eb:	00 00                	add    %al,(%eax)
  8002ed:	00 00                	add    %al,(%eax)
	...

008002f0 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8002f0:	55                   	push   %ebp
  8002f1:	89 e5                	mov    %esp,%ebp
  8002f3:	57                   	push   %edi
  8002f4:	56                   	push   %esi
  8002f5:	53                   	push   %ebx
  8002f6:	83 ec 4c             	sub    $0x4c,%esp
  8002f9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8002fc:	89 d6                	mov    %edx,%esi
  8002fe:	8b 45 08             	mov    0x8(%ebp),%eax
  800301:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800304:	8b 55 0c             	mov    0xc(%ebp),%edx
  800307:	89 55 e0             	mov    %edx,-0x20(%ebp)
  80030a:	8b 45 10             	mov    0x10(%ebp),%eax
  80030d:	8b 5d 14             	mov    0x14(%ebp),%ebx
  800310:	8b 7d 18             	mov    0x18(%ebp),%edi
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800313:	89 45 dc             	mov    %eax,-0x24(%ebp)
  800316:	b9 00 00 00 00       	mov    $0x0,%ecx
  80031b:	39 d1                	cmp    %edx,%ecx
  80031d:	72 15                	jb     800334 <printnum+0x44>
  80031f:	77 07                	ja     800328 <printnum+0x38>
  800321:	8b 55 d8             	mov    -0x28(%ebp),%edx
  800324:	39 d0                	cmp    %edx,%eax
  800326:	76 0c                	jbe    800334 <printnum+0x44>
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800328:	83 eb 01             	sub    $0x1,%ebx
  80032b:	85 db                	test   %ebx,%ebx
  80032d:	8d 76 00             	lea    0x0(%esi),%esi
  800330:	7f 61                	jg     800393 <printnum+0xa3>
  800332:	eb 70                	jmp    8003a4 <printnum+0xb4>
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800334:	89 7c 24 10          	mov    %edi,0x10(%esp)
  800338:	83 eb 01             	sub    $0x1,%ebx
  80033b:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  80033f:	89 44 24 08          	mov    %eax,0x8(%esp)
  800343:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  800347:	8b 5c 24 0c          	mov    0xc(%esp),%ebx
  80034b:	89 4d d0             	mov    %ecx,-0x30(%ebp)
  80034e:	89 5d d4             	mov    %ebx,-0x2c(%ebp)
  800351:	8b 5d dc             	mov    -0x24(%ebp),%ebx
  800354:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  800358:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  80035f:	00 
  800360:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800363:	89 04 24             	mov    %eax,(%esp)
  800366:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800369:	89 54 24 04          	mov    %edx,0x4(%esp)
  80036d:	e8 4e 29 00 00       	call   802cc0 <__udivdi3>
  800372:	8b 4d d0             	mov    -0x30(%ebp),%ecx
  800375:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
  800378:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  80037c:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  800380:	89 04 24             	mov    %eax,(%esp)
  800383:	89 54 24 04          	mov    %edx,0x4(%esp)
  800387:	89 f2                	mov    %esi,%edx
  800389:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80038c:	e8 5f ff ff ff       	call   8002f0 <printnum>
  800391:	eb 11                	jmp    8003a4 <printnum+0xb4>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800393:	89 74 24 04          	mov    %esi,0x4(%esp)
  800397:	89 3c 24             	mov    %edi,(%esp)
  80039a:	ff 55 e4             	call   *-0x1c(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  80039d:	83 eb 01             	sub    $0x1,%ebx
  8003a0:	85 db                	test   %ebx,%ebx
  8003a2:	7f ef                	jg     800393 <printnum+0xa3>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8003a4:	89 74 24 04          	mov    %esi,0x4(%esp)
  8003a8:	8b 74 24 04          	mov    0x4(%esp),%esi
  8003ac:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8003af:	89 44 24 08          	mov    %eax,0x8(%esp)
  8003b3:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  8003ba:	00 
  8003bb:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8003be:	89 14 24             	mov    %edx,(%esp)
  8003c1:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  8003c4:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8003c8:	e8 23 2a 00 00       	call   802df0 <__umoddi3>
  8003cd:	89 74 24 04          	mov    %esi,0x4(%esp)
  8003d1:	0f be 80 43 30 80 00 	movsbl 0x803043(%eax),%eax
  8003d8:	89 04 24             	mov    %eax,(%esp)
  8003db:	ff 55 e4             	call   *-0x1c(%ebp)
}
  8003de:	83 c4 4c             	add    $0x4c,%esp
  8003e1:	5b                   	pop    %ebx
  8003e2:	5e                   	pop    %esi
  8003e3:	5f                   	pop    %edi
  8003e4:	5d                   	pop    %ebp
  8003e5:	c3                   	ret    

008003e6 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  8003e6:	55                   	push   %ebp
  8003e7:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8003e9:	83 fa 01             	cmp    $0x1,%edx
  8003ec:	7e 0e                	jle    8003fc <getuint+0x16>
		return va_arg(*ap, unsigned long long);
  8003ee:	8b 10                	mov    (%eax),%edx
  8003f0:	8d 4a 08             	lea    0x8(%edx),%ecx
  8003f3:	89 08                	mov    %ecx,(%eax)
  8003f5:	8b 02                	mov    (%edx),%eax
  8003f7:	8b 52 04             	mov    0x4(%edx),%edx
  8003fa:	eb 22                	jmp    80041e <getuint+0x38>
	else if (lflag)
  8003fc:	85 d2                	test   %edx,%edx
  8003fe:	74 10                	je     800410 <getuint+0x2a>
		return va_arg(*ap, unsigned long);
  800400:	8b 10                	mov    (%eax),%edx
  800402:	8d 4a 04             	lea    0x4(%edx),%ecx
  800405:	89 08                	mov    %ecx,(%eax)
  800407:	8b 02                	mov    (%edx),%eax
  800409:	ba 00 00 00 00       	mov    $0x0,%edx
  80040e:	eb 0e                	jmp    80041e <getuint+0x38>
	else
		return va_arg(*ap, unsigned int);
  800410:	8b 10                	mov    (%eax),%edx
  800412:	8d 4a 04             	lea    0x4(%edx),%ecx
  800415:	89 08                	mov    %ecx,(%eax)
  800417:	8b 02                	mov    (%edx),%eax
  800419:	ba 00 00 00 00       	mov    $0x0,%edx
}
  80041e:	5d                   	pop    %ebp
  80041f:	c3                   	ret    

00800420 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800420:	55                   	push   %ebp
  800421:	89 e5                	mov    %esp,%ebp
  800423:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  800426:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  80042a:	8b 10                	mov    (%eax),%edx
  80042c:	3b 50 04             	cmp    0x4(%eax),%edx
  80042f:	73 0a                	jae    80043b <sprintputch+0x1b>
		*b->buf++ = ch;
  800431:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800434:	88 0a                	mov    %cl,(%edx)
  800436:	83 c2 01             	add    $0x1,%edx
  800439:	89 10                	mov    %edx,(%eax)
}
  80043b:	5d                   	pop    %ebp
  80043c:	c3                   	ret    

0080043d <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  80043d:	55                   	push   %ebp
  80043e:	89 e5                	mov    %esp,%ebp
  800440:	57                   	push   %edi
  800441:	56                   	push   %esi
  800442:	53                   	push   %ebx
  800443:	83 ec 5c             	sub    $0x5c,%esp
  800446:	8b 7d 08             	mov    0x8(%ebp),%edi
  800449:	8b 75 0c             	mov    0xc(%ebp),%esi
  80044c:	8b 5d 10             	mov    0x10(%ebp),%ebx
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  80044f:	c7 45 c8 ff ff ff ff 	movl   $0xffffffff,-0x38(%ebp)
  800456:	eb 11                	jmp    800469 <vprintfmt+0x2c>
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
  800458:	85 c0                	test   %eax,%eax
  80045a:	0f 84 ec 03 00 00    	je     80084c <vprintfmt+0x40f>
				return;
			putch(ch, putdat);
  800460:	89 74 24 04          	mov    %esi,0x4(%esp)
  800464:	89 04 24             	mov    %eax,(%esp)
  800467:	ff d7                	call   *%edi
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800469:	0f b6 03             	movzbl (%ebx),%eax
  80046c:	83 c3 01             	add    $0x1,%ebx
  80046f:	83 f8 25             	cmp    $0x25,%eax
  800472:	75 e4                	jne    800458 <vprintfmt+0x1b>
  800474:	c6 45 d4 20          	movb   $0x20,-0x2c(%ebp)
  800478:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
  80047f:	c7 45 d0 ff ff ff ff 	movl   $0xffffffff,-0x30(%ebp)
  800486:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
  80048d:	b9 00 00 00 00       	mov    $0x0,%ecx
  800492:	eb 06                	jmp    80049a <vprintfmt+0x5d>
  800494:	c6 45 d4 2d          	movb   $0x2d,-0x2c(%ebp)
  800498:	89 c3                	mov    %eax,%ebx
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80049a:	0f b6 13             	movzbl (%ebx),%edx
  80049d:	0f b6 c2             	movzbl %dl,%eax
  8004a0:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8004a3:	8d 43 01             	lea    0x1(%ebx),%eax
  8004a6:	83 ea 23             	sub    $0x23,%edx
  8004a9:	80 fa 55             	cmp    $0x55,%dl
  8004ac:	0f 87 7d 03 00 00    	ja     80082f <vprintfmt+0x3f2>
  8004b2:	0f b6 d2             	movzbl %dl,%edx
  8004b5:	ff 24 95 80 31 80 00 	jmp    *0x803180(,%edx,4)
  8004bc:	c6 45 d4 30          	movb   $0x30,-0x2c(%ebp)
  8004c0:	eb d6                	jmp    800498 <vprintfmt+0x5b>
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
				precision = precision * 10 + ch - '0';
  8004c2:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8004c5:	83 ea 30             	sub    $0x30,%edx
  8004c8:	89 55 d0             	mov    %edx,-0x30(%ebp)
				ch = *fmt;
  8004cb:	0f be 10             	movsbl (%eax),%edx
				if (ch < '0' || ch > '9')
  8004ce:	8d 5a d0             	lea    -0x30(%edx),%ebx
  8004d1:	83 fb 09             	cmp    $0x9,%ebx
  8004d4:	77 4c                	ja     800522 <vprintfmt+0xe5>
  8004d6:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  8004d9:	8b 4d d0             	mov    -0x30(%ebp),%ecx
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8004dc:	83 c0 01             	add    $0x1,%eax
				precision = precision * 10 + ch - '0';
  8004df:	8d 0c 89             	lea    (%ecx,%ecx,4),%ecx
  8004e2:	8d 4c 4a d0          	lea    -0x30(%edx,%ecx,2),%ecx
				ch = *fmt;
  8004e6:	0f be 10             	movsbl (%eax),%edx
				if (ch < '0' || ch > '9')
  8004e9:	8d 5a d0             	lea    -0x30(%edx),%ebx
  8004ec:	83 fb 09             	cmp    $0x9,%ebx
  8004ef:	76 eb                	jbe    8004dc <vprintfmt+0x9f>
  8004f1:	89 4d d0             	mov    %ecx,-0x30(%ebp)
  8004f4:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  8004f7:	eb 29                	jmp    800522 <vprintfmt+0xe5>
					break;
			}
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  8004f9:	8b 55 14             	mov    0x14(%ebp),%edx
  8004fc:	8d 5a 04             	lea    0x4(%edx),%ebx
  8004ff:	89 5d 14             	mov    %ebx,0x14(%ebp)
  800502:	8b 12                	mov    (%edx),%edx
  800504:	89 55 d0             	mov    %edx,-0x30(%ebp)
			goto process_precision;
  800507:	eb 19                	jmp    800522 <vprintfmt+0xe5>

		case '.':
			if (width < 0)
  800509:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80050c:	c1 fa 1f             	sar    $0x1f,%edx
  80050f:	f7 d2                	not    %edx
  800511:	21 55 e4             	and    %edx,-0x1c(%ebp)
  800514:	eb 82                	jmp    800498 <vprintfmt+0x5b>
  800516:	c7 45 d8 01 00 00 00 	movl   $0x1,-0x28(%ebp)
				width = 0;
			goto reswitch;

		case '#':
			altflag = 1;
			goto reswitch;
  80051d:	e9 76 ff ff ff       	jmp    800498 <vprintfmt+0x5b>

		process_precision:
			if (width < 0)
  800522:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800526:	0f 89 6c ff ff ff    	jns    800498 <vprintfmt+0x5b>
  80052c:	8b 55 d0             	mov    -0x30(%ebp),%edx
  80052f:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  800532:	8b 55 c8             	mov    -0x38(%ebp),%edx
  800535:	89 55 d0             	mov    %edx,-0x30(%ebp)
  800538:	e9 5b ff ff ff       	jmp    800498 <vprintfmt+0x5b>
				width = precision, precision = -1;
			goto reswitch;

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  80053d:	83 c1 01             	add    $0x1,%ecx
			goto reswitch;
  800540:	e9 53 ff ff ff       	jmp    800498 <vprintfmt+0x5b>
  800545:	89 45 cc             	mov    %eax,-0x34(%ebp)

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800548:	8b 45 14             	mov    0x14(%ebp),%eax
  80054b:	8d 50 04             	lea    0x4(%eax),%edx
  80054e:	89 55 14             	mov    %edx,0x14(%ebp)
  800551:	89 74 24 04          	mov    %esi,0x4(%esp)
  800555:	8b 00                	mov    (%eax),%eax
  800557:	89 04 24             	mov    %eax,(%esp)
  80055a:	ff d7                	call   *%edi
  80055c:	8b 5d cc             	mov    -0x34(%ebp),%ebx
			break;
  80055f:	e9 05 ff ff ff       	jmp    800469 <vprintfmt+0x2c>
  800564:	89 45 cc             	mov    %eax,-0x34(%ebp)

		// error message
		case 'e':
			err = va_arg(ap, int);
  800567:	8b 45 14             	mov    0x14(%ebp),%eax
  80056a:	8d 50 04             	lea    0x4(%eax),%edx
  80056d:	89 55 14             	mov    %edx,0x14(%ebp)
  800570:	8b 00                	mov    (%eax),%eax
  800572:	89 c2                	mov    %eax,%edx
  800574:	c1 fa 1f             	sar    $0x1f,%edx
  800577:	31 d0                	xor    %edx,%eax
  800579:	29 d0                	sub    %edx,%eax
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  80057b:	83 f8 0f             	cmp    $0xf,%eax
  80057e:	7f 0b                	jg     80058b <vprintfmt+0x14e>
  800580:	8b 14 85 e0 32 80 00 	mov    0x8032e0(,%eax,4),%edx
  800587:	85 d2                	test   %edx,%edx
  800589:	75 20                	jne    8005ab <vprintfmt+0x16e>
				printfmt(putch, putdat, "error %d", err);
  80058b:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80058f:	c7 44 24 08 54 30 80 	movl   $0x803054,0x8(%esp)
  800596:	00 
  800597:	89 74 24 04          	mov    %esi,0x4(%esp)
  80059b:	89 3c 24             	mov    %edi,(%esp)
  80059e:	e8 31 03 00 00       	call   8008d4 <printfmt>
  8005a3:	8b 5d cc             	mov    -0x34(%ebp),%ebx
		// error message
		case 'e':
			err = va_arg(ap, int);
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  8005a6:	e9 be fe ff ff       	jmp    800469 <vprintfmt+0x2c>
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  8005ab:	89 54 24 0c          	mov    %edx,0xc(%esp)
  8005af:	c7 44 24 08 28 34 80 	movl   $0x803428,0x8(%esp)
  8005b6:	00 
  8005b7:	89 74 24 04          	mov    %esi,0x4(%esp)
  8005bb:	89 3c 24             	mov    %edi,(%esp)
  8005be:	e8 11 03 00 00       	call   8008d4 <printfmt>
  8005c3:	8b 5d cc             	mov    -0x34(%ebp),%ebx
  8005c6:	e9 9e fe ff ff       	jmp    800469 <vprintfmt+0x2c>
  8005cb:	89 45 cc             	mov    %eax,-0x34(%ebp)
  8005ce:	89 c3                	mov    %eax,%ebx
  8005d0:	8b 4d d0             	mov    -0x30(%ebp),%ecx
  8005d3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8005d6:	89 45 c4             	mov    %eax,-0x3c(%ebp)
			break;

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  8005d9:	8b 45 14             	mov    0x14(%ebp),%eax
  8005dc:	8d 50 04             	lea    0x4(%eax),%edx
  8005df:	89 55 14             	mov    %edx,0x14(%ebp)
  8005e2:	8b 00                	mov    (%eax),%eax
  8005e4:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8005e7:	85 c0                	test   %eax,%eax
  8005e9:	75 07                	jne    8005f2 <vprintfmt+0x1b5>
  8005eb:	c7 45 e0 5d 30 80 00 	movl   $0x80305d,-0x20(%ebp)
				p = "(null)";
			if (width > 0 && padc != '-')
  8005f2:	83 7d c4 00          	cmpl   $0x0,-0x3c(%ebp)
  8005f6:	7e 06                	jle    8005fe <vprintfmt+0x1c1>
  8005f8:	80 7d d4 2d          	cmpb   $0x2d,-0x2c(%ebp)
  8005fc:	75 13                	jne    800611 <vprintfmt+0x1d4>
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8005fe:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800601:	0f be 02             	movsbl (%edx),%eax
  800604:	85 c0                	test   %eax,%eax
  800606:	0f 85 99 00 00 00    	jne    8006a5 <vprintfmt+0x268>
  80060c:	e9 86 00 00 00       	jmp    800697 <vprintfmt+0x25a>
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800611:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  800615:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  800618:	89 0c 24             	mov    %ecx,(%esp)
  80061b:	e8 fb 02 00 00       	call   80091b <strnlen>
  800620:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  800623:	29 c2                	sub    %eax,%edx
  800625:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  800628:	85 d2                	test   %edx,%edx
  80062a:	7e d2                	jle    8005fe <vprintfmt+0x1c1>
					putch(padc, putdat);
  80062c:	0f be 4d d4          	movsbl -0x2c(%ebp),%ecx
  800630:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  800633:	89 5d c4             	mov    %ebx,-0x3c(%ebp)
  800636:	89 d3                	mov    %edx,%ebx
  800638:	89 74 24 04          	mov    %esi,0x4(%esp)
  80063c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80063f:	89 04 24             	mov    %eax,(%esp)
  800642:	ff d7                	call   *%edi
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800644:	83 eb 01             	sub    $0x1,%ebx
  800647:	85 db                	test   %ebx,%ebx
  800649:	7f ed                	jg     800638 <vprintfmt+0x1fb>
  80064b:	8b 5d c4             	mov    -0x3c(%ebp),%ebx
  80064e:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  800655:	eb a7                	jmp    8005fe <vprintfmt+0x1c1>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
  800657:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  80065b:	74 18                	je     800675 <vprintfmt+0x238>
  80065d:	8d 50 e0             	lea    -0x20(%eax),%edx
  800660:	83 fa 5e             	cmp    $0x5e,%edx
  800663:	76 10                	jbe    800675 <vprintfmt+0x238>
					putch('?', putdat);
  800665:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800669:	c7 04 24 3f 00 00 00 	movl   $0x3f,(%esp)
  800670:	ff 55 e0             	call   *-0x20(%ebp)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
  800673:	eb 0a                	jmp    80067f <vprintfmt+0x242>
					putch('?', putdat);
				else
					putch(ch, putdat);
  800675:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800679:	89 04 24             	mov    %eax,(%esp)
  80067c:	ff 55 e0             	call   *-0x20(%ebp)
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  80067f:	83 6d e4 01          	subl   $0x1,-0x1c(%ebp)
  800683:	0f be 03             	movsbl (%ebx),%eax
  800686:	85 c0                	test   %eax,%eax
  800688:	74 05                	je     80068f <vprintfmt+0x252>
  80068a:	83 c3 01             	add    $0x1,%ebx
  80068d:	eb 29                	jmp    8006b8 <vprintfmt+0x27b>
  80068f:	89 fe                	mov    %edi,%esi
  800691:	8b 7d e0             	mov    -0x20(%ebp),%edi
  800694:	8b 5d d0             	mov    -0x30(%ebp),%ebx
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800697:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80069b:	7f 2e                	jg     8006cb <vprintfmt+0x28e>
  80069d:	8b 5d cc             	mov    -0x34(%ebp),%ebx
  8006a0:	e9 c4 fd ff ff       	jmp    800469 <vprintfmt+0x2c>
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8006a5:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8006a8:	83 c2 01             	add    $0x1,%edx
  8006ab:	89 7d e0             	mov    %edi,-0x20(%ebp)
  8006ae:	89 f7                	mov    %esi,%edi
  8006b0:	8b 75 d0             	mov    -0x30(%ebp),%esi
  8006b3:	89 5d d0             	mov    %ebx,-0x30(%ebp)
  8006b6:	89 d3                	mov    %edx,%ebx
  8006b8:	85 f6                	test   %esi,%esi
  8006ba:	78 9b                	js     800657 <vprintfmt+0x21a>
  8006bc:	83 ee 01             	sub    $0x1,%esi
  8006bf:	79 96                	jns    800657 <vprintfmt+0x21a>
  8006c1:	89 fe                	mov    %edi,%esi
  8006c3:	8b 7d e0             	mov    -0x20(%ebp),%edi
  8006c6:	8b 5d d0             	mov    -0x30(%ebp),%ebx
  8006c9:	eb cc                	jmp    800697 <vprintfmt+0x25a>
  8006cb:	89 5d d8             	mov    %ebx,-0x28(%ebp)
  8006ce:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
				putch(' ', putdat);
  8006d1:	89 74 24 04          	mov    %esi,0x4(%esp)
  8006d5:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  8006dc:	ff d7                	call   *%edi
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  8006de:	83 eb 01             	sub    $0x1,%ebx
  8006e1:	85 db                	test   %ebx,%ebx
  8006e3:	7f ec                	jg     8006d1 <vprintfmt+0x294>
  8006e5:	8b 5d d8             	mov    -0x28(%ebp),%ebx
  8006e8:	e9 7c fd ff ff       	jmp    800469 <vprintfmt+0x2c>
  8006ed:	89 45 cc             	mov    %eax,-0x34(%ebp)
// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
	if (lflag >= 2)
  8006f0:	83 f9 01             	cmp    $0x1,%ecx
  8006f3:	7e 16                	jle    80070b <vprintfmt+0x2ce>
		return va_arg(*ap, long long);
  8006f5:	8b 45 14             	mov    0x14(%ebp),%eax
  8006f8:	8d 50 08             	lea    0x8(%eax),%edx
  8006fb:	89 55 14             	mov    %edx,0x14(%ebp)
  8006fe:	8b 10                	mov    (%eax),%edx
  800700:	8b 48 04             	mov    0x4(%eax),%ecx
  800703:	89 55 d8             	mov    %edx,-0x28(%ebp)
  800706:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  800709:	eb 32                	jmp    80073d <vprintfmt+0x300>
	else if (lflag)
  80070b:	85 c9                	test   %ecx,%ecx
  80070d:	74 18                	je     800727 <vprintfmt+0x2ea>
		return va_arg(*ap, long);
  80070f:	8b 45 14             	mov    0x14(%ebp),%eax
  800712:	8d 50 04             	lea    0x4(%eax),%edx
  800715:	89 55 14             	mov    %edx,0x14(%ebp)
  800718:	8b 00                	mov    (%eax),%eax
  80071a:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80071d:	89 c1                	mov    %eax,%ecx
  80071f:	c1 f9 1f             	sar    $0x1f,%ecx
  800722:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  800725:	eb 16                	jmp    80073d <vprintfmt+0x300>
	else
		return va_arg(*ap, int);
  800727:	8b 45 14             	mov    0x14(%ebp),%eax
  80072a:	8d 50 04             	lea    0x4(%eax),%edx
  80072d:	89 55 14             	mov    %edx,0x14(%ebp)
  800730:	8b 00                	mov    (%eax),%eax
  800732:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800735:	89 c2                	mov    %eax,%edx
  800737:	c1 fa 1f             	sar    $0x1f,%edx
  80073a:	89 55 dc             	mov    %edx,-0x24(%ebp)
				putch(' ', putdat);
			break;

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  80073d:	8b 4d d8             	mov    -0x28(%ebp),%ecx
  800740:	8b 5d dc             	mov    -0x24(%ebp),%ebx
  800743:	b8 0a 00 00 00       	mov    $0xa,%eax
			if ((long long) num < 0) {
  800748:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  80074c:	0f 89 9b 00 00 00    	jns    8007ed <vprintfmt+0x3b0>
				putch('-', putdat);
  800752:	89 74 24 04          	mov    %esi,0x4(%esp)
  800756:	c7 04 24 2d 00 00 00 	movl   $0x2d,(%esp)
  80075d:	ff d7                	call   *%edi
				num = -(long long) num;
  80075f:	8b 4d d8             	mov    -0x28(%ebp),%ecx
  800762:	8b 5d dc             	mov    -0x24(%ebp),%ebx
  800765:	f7 d9                	neg    %ecx
  800767:	83 d3 00             	adc    $0x0,%ebx
  80076a:	f7 db                	neg    %ebx
  80076c:	b8 0a 00 00 00       	mov    $0xa,%eax
  800771:	eb 7a                	jmp    8007ed <vprintfmt+0x3b0>
  800773:	89 45 cc             	mov    %eax,-0x34(%ebp)
			base = 10;
			goto number;

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800776:	89 ca                	mov    %ecx,%edx
  800778:	8d 45 14             	lea    0x14(%ebp),%eax
  80077b:	e8 66 fc ff ff       	call   8003e6 <getuint>
  800780:	89 c1                	mov    %eax,%ecx
  800782:	89 d3                	mov    %edx,%ebx
  800784:	b8 0a 00 00 00       	mov    $0xa,%eax
			base = 10;
			goto number;
  800789:	eb 62                	jmp    8007ed <vprintfmt+0x3b0>
  80078b:	89 45 cc             	mov    %eax,-0x34(%ebp)
		case 'o':
			// Replace this with your code.
			// putch('X', putdat);
			// putch('X', putdat);
			// putch('X', putdat);
			num = getuint(&ap, lflag);
  80078e:	89 ca                	mov    %ecx,%edx
  800790:	8d 45 14             	lea    0x14(%ebp),%eax
  800793:	e8 4e fc ff ff       	call   8003e6 <getuint>
  800798:	89 c1                	mov    %eax,%ecx
  80079a:	89 d3                	mov    %edx,%ebx
  80079c:	b8 08 00 00 00       	mov    $0x8,%eax
			base = 8;
			goto number;
  8007a1:	eb 4a                	jmp    8007ed <vprintfmt+0x3b0>
  8007a3:	89 45 cc             	mov    %eax,-0x34(%ebp)
			break;

		// pointer
		case 'p':
			putch('0', putdat);
  8007a6:	89 74 24 04          	mov    %esi,0x4(%esp)
  8007aa:	c7 04 24 30 00 00 00 	movl   $0x30,(%esp)
  8007b1:	ff d7                	call   *%edi
			putch('x', putdat);
  8007b3:	89 74 24 04          	mov    %esi,0x4(%esp)
  8007b7:	c7 04 24 78 00 00 00 	movl   $0x78,(%esp)
  8007be:	ff d7                	call   *%edi
			num = (unsigned long long)
  8007c0:	8b 45 14             	mov    0x14(%ebp),%eax
  8007c3:	8d 50 04             	lea    0x4(%eax),%edx
  8007c6:	89 55 14             	mov    %edx,0x14(%ebp)
  8007c9:	8b 08                	mov    (%eax),%ecx
  8007cb:	bb 00 00 00 00       	mov    $0x0,%ebx
  8007d0:	b8 10 00 00 00       	mov    $0x10,%eax
				(uintptr_t) va_arg(ap, void *);
			base = 16;
			goto number;
  8007d5:	eb 16                	jmp    8007ed <vprintfmt+0x3b0>
  8007d7:	89 45 cc             	mov    %eax,-0x34(%ebp)

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  8007da:	89 ca                	mov    %ecx,%edx
  8007dc:	8d 45 14             	lea    0x14(%ebp),%eax
  8007df:	e8 02 fc ff ff       	call   8003e6 <getuint>
  8007e4:	89 c1                	mov    %eax,%ecx
  8007e6:	89 d3                	mov    %edx,%ebx
  8007e8:	b8 10 00 00 00       	mov    $0x10,%eax
			base = 16;
		number:
			printnum(putch, putdat, num, base, width, padc);
  8007ed:	0f be 55 d4          	movsbl -0x2c(%ebp),%edx
  8007f1:	89 54 24 10          	mov    %edx,0x10(%esp)
  8007f5:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8007f8:	89 54 24 0c          	mov    %edx,0xc(%esp)
  8007fc:	89 44 24 08          	mov    %eax,0x8(%esp)
  800800:	89 0c 24             	mov    %ecx,(%esp)
  800803:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  800807:	89 f2                	mov    %esi,%edx
  800809:	89 f8                	mov    %edi,%eax
  80080b:	e8 e0 fa ff ff       	call   8002f0 <printnum>
  800810:	8b 5d cc             	mov    -0x34(%ebp),%ebx
			break;
  800813:	e9 51 fc ff ff       	jmp    800469 <vprintfmt+0x2c>
  800818:	89 45 cc             	mov    %eax,-0x34(%ebp)
  80081b:	8b 55 e0             	mov    -0x20(%ebp),%edx

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  80081e:	89 74 24 04          	mov    %esi,0x4(%esp)
  800822:	89 14 24             	mov    %edx,(%esp)
  800825:	ff d7                	call   *%edi
  800827:	8b 5d cc             	mov    -0x34(%ebp),%ebx
			break;
  80082a:	e9 3a fc ff ff       	jmp    800469 <vprintfmt+0x2c>
			
		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  80082f:	89 74 24 04          	mov    %esi,0x4(%esp)
  800833:	c7 04 24 25 00 00 00 	movl   $0x25,(%esp)
  80083a:	ff d7                	call   *%edi
			for (fmt--; fmt[-1] != '%'; fmt--)
  80083c:	8d 43 ff             	lea    -0x1(%ebx),%eax
  80083f:	80 38 25             	cmpb   $0x25,(%eax)
  800842:	0f 84 21 fc ff ff    	je     800469 <vprintfmt+0x2c>
  800848:	89 c3                	mov    %eax,%ebx
  80084a:	eb f0                	jmp    80083c <vprintfmt+0x3ff>
				/* do nothing */;
			break;
		}
	}
}
  80084c:	83 c4 5c             	add    $0x5c,%esp
  80084f:	5b                   	pop    %ebx
  800850:	5e                   	pop    %esi
  800851:	5f                   	pop    %edi
  800852:	5d                   	pop    %ebp
  800853:	c3                   	ret    

00800854 <vsnprintf>:
		*b->buf++ = ch;
}

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800854:	55                   	push   %ebp
  800855:	89 e5                	mov    %esp,%ebp
  800857:	83 ec 28             	sub    $0x28,%esp
  80085a:	8b 45 08             	mov    0x8(%ebp),%eax
  80085d:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};

	if (buf == NULL || n < 1)
  800860:	85 c0                	test   %eax,%eax
  800862:	74 04                	je     800868 <vsnprintf+0x14>
  800864:	85 d2                	test   %edx,%edx
  800866:	7f 07                	jg     80086f <vsnprintf+0x1b>
  800868:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80086d:	eb 3b                	jmp    8008aa <vsnprintf+0x56>
}

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
	struct sprintbuf b = {buf, buf+n-1, 0};
  80086f:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800872:	8d 44 10 ff          	lea    -0x1(%eax,%edx,1),%eax
  800876:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800879:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800880:	8b 45 14             	mov    0x14(%ebp),%eax
  800883:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800887:	8b 45 10             	mov    0x10(%ebp),%eax
  80088a:	89 44 24 08          	mov    %eax,0x8(%esp)
  80088e:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800891:	89 44 24 04          	mov    %eax,0x4(%esp)
  800895:	c7 04 24 20 04 80 00 	movl   $0x800420,(%esp)
  80089c:	e8 9c fb ff ff       	call   80043d <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  8008a1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8008a4:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  8008a7:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  8008aa:	c9                   	leave  
  8008ab:	c3                   	ret    

008008ac <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  8008ac:	55                   	push   %ebp
  8008ad:	89 e5                	mov    %esp,%ebp
  8008af:	83 ec 18             	sub    $0x18,%esp

	return b.cnt;
}

int
snprintf(char *buf, int n, const char *fmt, ...)
  8008b2:	8d 45 14             	lea    0x14(%ebp),%eax
{
	va_list ap;
	int rc;

	va_start(ap, fmt);
	rc = vsnprintf(buf, n, fmt, ap);
  8008b5:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8008b9:	8b 45 10             	mov    0x10(%ebp),%eax
  8008bc:	89 44 24 08          	mov    %eax,0x8(%esp)
  8008c0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8008c3:	89 44 24 04          	mov    %eax,0x4(%esp)
  8008c7:	8b 45 08             	mov    0x8(%ebp),%eax
  8008ca:	89 04 24             	mov    %eax,(%esp)
  8008cd:	e8 82 ff ff ff       	call   800854 <vsnprintf>
	va_end(ap);

	return rc;
}
  8008d2:	c9                   	leave  
  8008d3:	c3                   	ret    

008008d4 <printfmt>:
	}
}

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  8008d4:	55                   	push   %ebp
  8008d5:	89 e5                	mov    %esp,%ebp
  8008d7:	83 ec 18             	sub    $0x18,%esp
		}
	}
}

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
  8008da:	8d 45 14             	lea    0x14(%ebp),%eax
{
	va_list ap;

	va_start(ap, fmt);
	vprintfmt(putch, putdat, fmt, ap);
  8008dd:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8008e1:	8b 45 10             	mov    0x10(%ebp),%eax
  8008e4:	89 44 24 08          	mov    %eax,0x8(%esp)
  8008e8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8008eb:	89 44 24 04          	mov    %eax,0x4(%esp)
  8008ef:	8b 45 08             	mov    0x8(%ebp),%eax
  8008f2:	89 04 24             	mov    %eax,(%esp)
  8008f5:	e8 43 fb ff ff       	call   80043d <vprintfmt>
	va_end(ap);
}
  8008fa:	c9                   	leave  
  8008fb:	c3                   	ret    
  8008fc:	00 00                	add    %al,(%eax)
	...

00800900 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800900:	55                   	push   %ebp
  800901:	89 e5                	mov    %esp,%ebp
  800903:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  800906:	b8 00 00 00 00       	mov    $0x0,%eax
  80090b:	80 3a 00             	cmpb   $0x0,(%edx)
  80090e:	74 09                	je     800919 <strlen+0x19>
		n++;
  800910:	83 c0 01             	add    $0x1,%eax
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800913:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  800917:	75 f7                	jne    800910 <strlen+0x10>
		n++;
	return n;
}
  800919:	5d                   	pop    %ebp
  80091a:	c3                   	ret    

0080091b <strnlen>:

int
strnlen(const char *s, size_t size)
{
  80091b:	55                   	push   %ebp
  80091c:	89 e5                	mov    %esp,%ebp
  80091e:	53                   	push   %ebx
  80091f:	8b 5d 08             	mov    0x8(%ebp),%ebx
  800922:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800925:	85 c9                	test   %ecx,%ecx
  800927:	74 19                	je     800942 <strnlen+0x27>
  800929:	80 3b 00             	cmpb   $0x0,(%ebx)
  80092c:	74 14                	je     800942 <strnlen+0x27>
  80092e:	b8 00 00 00 00       	mov    $0x0,%eax
		n++;
  800933:	83 c0 01             	add    $0x1,%eax
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800936:	39 c8                	cmp    %ecx,%eax
  800938:	74 0d                	je     800947 <strnlen+0x2c>
  80093a:	80 3c 03 00          	cmpb   $0x0,(%ebx,%eax,1)
  80093e:	75 f3                	jne    800933 <strnlen+0x18>
  800940:	eb 05                	jmp    800947 <strnlen+0x2c>
  800942:	b8 00 00 00 00       	mov    $0x0,%eax
		n++;
	return n;
}
  800947:	5b                   	pop    %ebx
  800948:	5d                   	pop    %ebp
  800949:	c3                   	ret    

0080094a <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  80094a:	55                   	push   %ebp
  80094b:	89 e5                	mov    %esp,%ebp
  80094d:	53                   	push   %ebx
  80094e:	8b 45 08             	mov    0x8(%ebp),%eax
  800951:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800954:	ba 00 00 00 00       	mov    $0x0,%edx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  800959:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
  80095d:	88 0c 10             	mov    %cl,(%eax,%edx,1)
  800960:	83 c2 01             	add    $0x1,%edx
  800963:	84 c9                	test   %cl,%cl
  800965:	75 f2                	jne    800959 <strcpy+0xf>
		/* do nothing */;
	return ret;
}
  800967:	5b                   	pop    %ebx
  800968:	5d                   	pop    %ebp
  800969:	c3                   	ret    

0080096a <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  80096a:	55                   	push   %ebp
  80096b:	89 e5                	mov    %esp,%ebp
  80096d:	56                   	push   %esi
  80096e:	53                   	push   %ebx
  80096f:	8b 45 08             	mov    0x8(%ebp),%eax
  800972:	8b 55 0c             	mov    0xc(%ebp),%edx
  800975:	8b 75 10             	mov    0x10(%ebp),%esi
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800978:	85 f6                	test   %esi,%esi
  80097a:	74 18                	je     800994 <strncpy+0x2a>
  80097c:	b9 00 00 00 00       	mov    $0x0,%ecx
		*dst++ = *src;
  800981:	0f b6 1a             	movzbl (%edx),%ebx
  800984:	88 1c 08             	mov    %bl,(%eax,%ecx,1)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  800987:	80 3a 01             	cmpb   $0x1,(%edx)
  80098a:	83 da ff             	sbb    $0xffffffff,%edx
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  80098d:	83 c1 01             	add    $0x1,%ecx
  800990:	39 ce                	cmp    %ecx,%esi
  800992:	77 ed                	ja     800981 <strncpy+0x17>
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
}
  800994:	5b                   	pop    %ebx
  800995:	5e                   	pop    %esi
  800996:	5d                   	pop    %ebp
  800997:	c3                   	ret    

00800998 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800998:	55                   	push   %ebp
  800999:	89 e5                	mov    %esp,%ebp
  80099b:	56                   	push   %esi
  80099c:	53                   	push   %ebx
  80099d:	8b 75 08             	mov    0x8(%ebp),%esi
  8009a0:	8b 55 0c             	mov    0xc(%ebp),%edx
  8009a3:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  8009a6:	89 f0                	mov    %esi,%eax
  8009a8:	85 c9                	test   %ecx,%ecx
  8009aa:	74 27                	je     8009d3 <strlcpy+0x3b>
		while (--size > 0 && *src != '\0')
  8009ac:	83 e9 01             	sub    $0x1,%ecx
  8009af:	74 1d                	je     8009ce <strlcpy+0x36>
  8009b1:	0f b6 1a             	movzbl (%edx),%ebx
  8009b4:	84 db                	test   %bl,%bl
  8009b6:	74 16                	je     8009ce <strlcpy+0x36>
			*dst++ = *src++;
  8009b8:	88 18                	mov    %bl,(%eax)
  8009ba:	83 c0 01             	add    $0x1,%eax
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  8009bd:	83 e9 01             	sub    $0x1,%ecx
  8009c0:	74 0e                	je     8009d0 <strlcpy+0x38>
			*dst++ = *src++;
  8009c2:	83 c2 01             	add    $0x1,%edx
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  8009c5:	0f b6 1a             	movzbl (%edx),%ebx
  8009c8:	84 db                	test   %bl,%bl
  8009ca:	75 ec                	jne    8009b8 <strlcpy+0x20>
  8009cc:	eb 02                	jmp    8009d0 <strlcpy+0x38>
  8009ce:	89 f0                	mov    %esi,%eax
			*dst++ = *src++;
		*dst = '\0';
  8009d0:	c6 00 00             	movb   $0x0,(%eax)
  8009d3:	29 f0                	sub    %esi,%eax
	}
	return dst - dst_in;
}
  8009d5:	5b                   	pop    %ebx
  8009d6:	5e                   	pop    %esi
  8009d7:	5d                   	pop    %ebp
  8009d8:	c3                   	ret    

008009d9 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  8009d9:	55                   	push   %ebp
  8009da:	89 e5                	mov    %esp,%ebp
  8009dc:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8009df:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  8009e2:	0f b6 01             	movzbl (%ecx),%eax
  8009e5:	84 c0                	test   %al,%al
  8009e7:	74 15                	je     8009fe <strcmp+0x25>
  8009e9:	3a 02                	cmp    (%edx),%al
  8009eb:	75 11                	jne    8009fe <strcmp+0x25>
		p++, q++;
  8009ed:	83 c1 01             	add    $0x1,%ecx
  8009f0:	83 c2 01             	add    $0x1,%edx
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  8009f3:	0f b6 01             	movzbl (%ecx),%eax
  8009f6:	84 c0                	test   %al,%al
  8009f8:	74 04                	je     8009fe <strcmp+0x25>
  8009fa:	3a 02                	cmp    (%edx),%al
  8009fc:	74 ef                	je     8009ed <strcmp+0x14>
  8009fe:	0f b6 c0             	movzbl %al,%eax
  800a01:	0f b6 12             	movzbl (%edx),%edx
  800a04:	29 d0                	sub    %edx,%eax
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
}
  800a06:	5d                   	pop    %ebp
  800a07:	c3                   	ret    

00800a08 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800a08:	55                   	push   %ebp
  800a09:	89 e5                	mov    %esp,%ebp
  800a0b:	53                   	push   %ebx
  800a0c:	8b 55 08             	mov    0x8(%ebp),%edx
  800a0f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800a12:	8b 45 10             	mov    0x10(%ebp),%eax
	while (n > 0 && *p && *p == *q)
  800a15:	85 c0                	test   %eax,%eax
  800a17:	74 23                	je     800a3c <strncmp+0x34>
  800a19:	0f b6 1a             	movzbl (%edx),%ebx
  800a1c:	84 db                	test   %bl,%bl
  800a1e:	74 24                	je     800a44 <strncmp+0x3c>
  800a20:	3a 19                	cmp    (%ecx),%bl
  800a22:	75 20                	jne    800a44 <strncmp+0x3c>
  800a24:	83 e8 01             	sub    $0x1,%eax
  800a27:	74 13                	je     800a3c <strncmp+0x34>
		n--, p++, q++;
  800a29:	83 c2 01             	add    $0x1,%edx
  800a2c:	83 c1 01             	add    $0x1,%ecx
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  800a2f:	0f b6 1a             	movzbl (%edx),%ebx
  800a32:	84 db                	test   %bl,%bl
  800a34:	74 0e                	je     800a44 <strncmp+0x3c>
  800a36:	3a 19                	cmp    (%ecx),%bl
  800a38:	74 ea                	je     800a24 <strncmp+0x1c>
  800a3a:	eb 08                	jmp    800a44 <strncmp+0x3c>
  800a3c:	b8 00 00 00 00       	mov    $0x0,%eax
		n--, p++, q++;
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
}
  800a41:	5b                   	pop    %ebx
  800a42:	5d                   	pop    %ebp
  800a43:	c3                   	ret    
	while (n > 0 && *p && *p == *q)
		n--, p++, q++;
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800a44:	0f b6 02             	movzbl (%edx),%eax
  800a47:	0f b6 11             	movzbl (%ecx),%edx
  800a4a:	29 d0                	sub    %edx,%eax
  800a4c:	eb f3                	jmp    800a41 <strncmp+0x39>

00800a4e <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800a4e:	55                   	push   %ebp
  800a4f:	89 e5                	mov    %esp,%ebp
  800a51:	8b 45 08             	mov    0x8(%ebp),%eax
  800a54:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800a58:	0f b6 10             	movzbl (%eax),%edx
  800a5b:	84 d2                	test   %dl,%dl
  800a5d:	74 15                	je     800a74 <strchr+0x26>
		if (*s == c)
  800a5f:	38 ca                	cmp    %cl,%dl
  800a61:	75 07                	jne    800a6a <strchr+0x1c>
  800a63:	eb 14                	jmp    800a79 <strchr+0x2b>
  800a65:	38 ca                	cmp    %cl,%dl
  800a67:	90                   	nop
  800a68:	74 0f                	je     800a79 <strchr+0x2b>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800a6a:	83 c0 01             	add    $0x1,%eax
  800a6d:	0f b6 10             	movzbl (%eax),%edx
  800a70:	84 d2                	test   %dl,%dl
  800a72:	75 f1                	jne    800a65 <strchr+0x17>
  800a74:	b8 00 00 00 00       	mov    $0x0,%eax
		if (*s == c)
			return (char *) s;
	return 0;
}
  800a79:	5d                   	pop    %ebp
  800a7a:	c3                   	ret    

00800a7b <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800a7b:	55                   	push   %ebp
  800a7c:	89 e5                	mov    %esp,%ebp
  800a7e:	8b 45 08             	mov    0x8(%ebp),%eax
  800a81:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800a85:	0f b6 10             	movzbl (%eax),%edx
  800a88:	84 d2                	test   %dl,%dl
  800a8a:	74 18                	je     800aa4 <strfind+0x29>
		if (*s == c)
  800a8c:	38 ca                	cmp    %cl,%dl
  800a8e:	75 0a                	jne    800a9a <strfind+0x1f>
  800a90:	eb 12                	jmp    800aa4 <strfind+0x29>
  800a92:	38 ca                	cmp    %cl,%dl
  800a94:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  800a98:	74 0a                	je     800aa4 <strfind+0x29>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800a9a:	83 c0 01             	add    $0x1,%eax
  800a9d:	0f b6 10             	movzbl (%eax),%edx
  800aa0:	84 d2                	test   %dl,%dl
  800aa2:	75 ee                	jne    800a92 <strfind+0x17>
		if (*s == c)
			break;
	return (char *) s;
}
  800aa4:	5d                   	pop    %ebp
  800aa5:	c3                   	ret    

00800aa6 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800aa6:	55                   	push   %ebp
  800aa7:	89 e5                	mov    %esp,%ebp
  800aa9:	83 ec 0c             	sub    $0xc,%esp
  800aac:	89 1c 24             	mov    %ebx,(%esp)
  800aaf:	89 74 24 04          	mov    %esi,0x4(%esp)
  800ab3:	89 7c 24 08          	mov    %edi,0x8(%esp)
  800ab7:	8b 7d 08             	mov    0x8(%ebp),%edi
  800aba:	8b 45 0c             	mov    0xc(%ebp),%eax
  800abd:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800ac0:	85 c9                	test   %ecx,%ecx
  800ac2:	74 30                	je     800af4 <memset+0x4e>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800ac4:	f7 c7 03 00 00 00    	test   $0x3,%edi
  800aca:	75 25                	jne    800af1 <memset+0x4b>
  800acc:	f6 c1 03             	test   $0x3,%cl
  800acf:	75 20                	jne    800af1 <memset+0x4b>
		c &= 0xFF;
  800ad1:	0f b6 d0             	movzbl %al,%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800ad4:	89 d3                	mov    %edx,%ebx
  800ad6:	c1 e3 08             	shl    $0x8,%ebx
  800ad9:	89 d6                	mov    %edx,%esi
  800adb:	c1 e6 18             	shl    $0x18,%esi
  800ade:	89 d0                	mov    %edx,%eax
  800ae0:	c1 e0 10             	shl    $0x10,%eax
  800ae3:	09 f0                	or     %esi,%eax
  800ae5:	09 d0                	or     %edx,%eax
		asm volatile("cld; rep stosl\n"
  800ae7:	09 d8                	or     %ebx,%eax
  800ae9:	c1 e9 02             	shr    $0x2,%ecx
  800aec:	fc                   	cld    
  800aed:	f3 ab                	rep stos %eax,%es:(%edi)
{
	char *p;

	if (n == 0)
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800aef:	eb 03                	jmp    800af4 <memset+0x4e>
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800af1:	fc                   	cld    
  800af2:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800af4:	89 f8                	mov    %edi,%eax
  800af6:	8b 1c 24             	mov    (%esp),%ebx
  800af9:	8b 74 24 04          	mov    0x4(%esp),%esi
  800afd:	8b 7c 24 08          	mov    0x8(%esp),%edi
  800b01:	89 ec                	mov    %ebp,%esp
  800b03:	5d                   	pop    %ebp
  800b04:	c3                   	ret    

00800b05 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800b05:	55                   	push   %ebp
  800b06:	89 e5                	mov    %esp,%ebp
  800b08:	83 ec 08             	sub    $0x8,%esp
  800b0b:	89 34 24             	mov    %esi,(%esp)
  800b0e:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800b12:	8b 45 08             	mov    0x8(%ebp),%eax
  800b15:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;
	
	s = src;
  800b18:	8b 75 0c             	mov    0xc(%ebp),%esi
	d = dst;
  800b1b:	89 c7                	mov    %eax,%edi
	if (s < d && s + n > d) {
  800b1d:	39 c6                	cmp    %eax,%esi
  800b1f:	73 35                	jae    800b56 <memmove+0x51>
  800b21:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800b24:	39 d0                	cmp    %edx,%eax
  800b26:	73 2e                	jae    800b56 <memmove+0x51>
		s += n;
		d += n;
  800b28:	01 cf                	add    %ecx,%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800b2a:	f6 c2 03             	test   $0x3,%dl
  800b2d:	75 1b                	jne    800b4a <memmove+0x45>
  800b2f:	f7 c7 03 00 00 00    	test   $0x3,%edi
  800b35:	75 13                	jne    800b4a <memmove+0x45>
  800b37:	f6 c1 03             	test   $0x3,%cl
  800b3a:	75 0e                	jne    800b4a <memmove+0x45>
			asm volatile("std; rep movsl\n"
  800b3c:	83 ef 04             	sub    $0x4,%edi
  800b3f:	8d 72 fc             	lea    -0x4(%edx),%esi
  800b42:	c1 e9 02             	shr    $0x2,%ecx
  800b45:	fd                   	std    
  800b46:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800b48:	eb 09                	jmp    800b53 <memmove+0x4e>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  800b4a:	83 ef 01             	sub    $0x1,%edi
  800b4d:	8d 72 ff             	lea    -0x1(%edx),%esi
  800b50:	fd                   	std    
  800b51:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800b53:	fc                   	cld    
	const char *s;
	char *d;
	
	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800b54:	eb 20                	jmp    800b76 <memmove+0x71>
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800b56:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800b5c:	75 15                	jne    800b73 <memmove+0x6e>
  800b5e:	f7 c7 03 00 00 00    	test   $0x3,%edi
  800b64:	75 0d                	jne    800b73 <memmove+0x6e>
  800b66:	f6 c1 03             	test   $0x3,%cl
  800b69:	75 08                	jne    800b73 <memmove+0x6e>
			asm volatile("cld; rep movsl\n"
  800b6b:	c1 e9 02             	shr    $0x2,%ecx
  800b6e:	fc                   	cld    
  800b6f:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800b71:	eb 03                	jmp    800b76 <memmove+0x71>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  800b73:	fc                   	cld    
  800b74:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800b76:	8b 34 24             	mov    (%esp),%esi
  800b79:	8b 7c 24 04          	mov    0x4(%esp),%edi
  800b7d:	89 ec                	mov    %ebp,%esp
  800b7f:	5d                   	pop    %ebp
  800b80:	c3                   	ret    

00800b81 <memcpy>:

/* sigh - gcc emits references to this for structure assignments! */
/* it is *not* prototyped in inc/string.h - do not use directly. */
void *
memcpy(void *dst, void *src, size_t n)
{
  800b81:	55                   	push   %ebp
  800b82:	89 e5                	mov    %esp,%ebp
  800b84:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  800b87:	8b 45 10             	mov    0x10(%ebp),%eax
  800b8a:	89 44 24 08          	mov    %eax,0x8(%esp)
  800b8e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b91:	89 44 24 04          	mov    %eax,0x4(%esp)
  800b95:	8b 45 08             	mov    0x8(%ebp),%eax
  800b98:	89 04 24             	mov    %eax,(%esp)
  800b9b:	e8 65 ff ff ff       	call   800b05 <memmove>
}
  800ba0:	c9                   	leave  
  800ba1:	c3                   	ret    

00800ba2 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800ba2:	55                   	push   %ebp
  800ba3:	89 e5                	mov    %esp,%ebp
  800ba5:	57                   	push   %edi
  800ba6:	56                   	push   %esi
  800ba7:	53                   	push   %ebx
  800ba8:	8b 75 08             	mov    0x8(%ebp),%esi
  800bab:	8b 7d 0c             	mov    0xc(%ebp),%edi
  800bae:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800bb1:	85 c9                	test   %ecx,%ecx
  800bb3:	74 36                	je     800beb <memcmp+0x49>
		if (*s1 != *s2)
  800bb5:	0f b6 06             	movzbl (%esi),%eax
  800bb8:	0f b6 1f             	movzbl (%edi),%ebx
  800bbb:	38 d8                	cmp    %bl,%al
  800bbd:	74 20                	je     800bdf <memcmp+0x3d>
  800bbf:	eb 14                	jmp    800bd5 <memcmp+0x33>
  800bc1:	0f b6 44 16 01       	movzbl 0x1(%esi,%edx,1),%eax
  800bc6:	0f b6 5c 17 01       	movzbl 0x1(%edi,%edx,1),%ebx
  800bcb:	83 c2 01             	add    $0x1,%edx
  800bce:	83 e9 01             	sub    $0x1,%ecx
  800bd1:	38 d8                	cmp    %bl,%al
  800bd3:	74 12                	je     800be7 <memcmp+0x45>
			return (int) *s1 - (int) *s2;
  800bd5:	0f b6 c0             	movzbl %al,%eax
  800bd8:	0f b6 db             	movzbl %bl,%ebx
  800bdb:	29 d8                	sub    %ebx,%eax
  800bdd:	eb 11                	jmp    800bf0 <memcmp+0x4e>
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800bdf:	83 e9 01             	sub    $0x1,%ecx
  800be2:	ba 00 00 00 00       	mov    $0x0,%edx
  800be7:	85 c9                	test   %ecx,%ecx
  800be9:	75 d6                	jne    800bc1 <memcmp+0x1f>
  800beb:	b8 00 00 00 00       	mov    $0x0,%eax
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
}
  800bf0:	5b                   	pop    %ebx
  800bf1:	5e                   	pop    %esi
  800bf2:	5f                   	pop    %edi
  800bf3:	5d                   	pop    %ebp
  800bf4:	c3                   	ret    

00800bf5 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800bf5:	55                   	push   %ebp
  800bf6:	89 e5                	mov    %esp,%ebp
  800bf8:	8b 45 08             	mov    0x8(%ebp),%eax
	const void *ends = (const char *) s + n;
  800bfb:	89 c2                	mov    %eax,%edx
  800bfd:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800c00:	39 d0                	cmp    %edx,%eax
  800c02:	73 15                	jae    800c19 <memfind+0x24>
		if (*(const unsigned char *) s == (unsigned char) c)
  800c04:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
  800c08:	38 08                	cmp    %cl,(%eax)
  800c0a:	75 06                	jne    800c12 <memfind+0x1d>
  800c0c:	eb 0b                	jmp    800c19 <memfind+0x24>
  800c0e:	38 08                	cmp    %cl,(%eax)
  800c10:	74 07                	je     800c19 <memfind+0x24>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800c12:	83 c0 01             	add    $0x1,%eax
  800c15:	39 c2                	cmp    %eax,%edx
  800c17:	77 f5                	ja     800c0e <memfind+0x19>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
	return (void *) s;
}
  800c19:	5d                   	pop    %ebp
  800c1a:	c3                   	ret    

00800c1b <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800c1b:	55                   	push   %ebp
  800c1c:	89 e5                	mov    %esp,%ebp
  800c1e:	57                   	push   %edi
  800c1f:	56                   	push   %esi
  800c20:	53                   	push   %ebx
  800c21:	83 ec 04             	sub    $0x4,%esp
  800c24:	8b 55 08             	mov    0x8(%ebp),%edx
  800c27:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800c2a:	0f b6 02             	movzbl (%edx),%eax
  800c2d:	3c 20                	cmp    $0x20,%al
  800c2f:	74 04                	je     800c35 <strtol+0x1a>
  800c31:	3c 09                	cmp    $0x9,%al
  800c33:	75 0e                	jne    800c43 <strtol+0x28>
		s++;
  800c35:	83 c2 01             	add    $0x1,%edx
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800c38:	0f b6 02             	movzbl (%edx),%eax
  800c3b:	3c 20                	cmp    $0x20,%al
  800c3d:	74 f6                	je     800c35 <strtol+0x1a>
  800c3f:	3c 09                	cmp    $0x9,%al
  800c41:	74 f2                	je     800c35 <strtol+0x1a>
		s++;

	// plus/minus sign
	if (*s == '+')
  800c43:	3c 2b                	cmp    $0x2b,%al
  800c45:	75 0c                	jne    800c53 <strtol+0x38>
		s++;
  800c47:	83 c2 01             	add    $0x1,%edx
  800c4a:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800c51:	eb 15                	jmp    800c68 <strtol+0x4d>
	else if (*s == '-')
  800c53:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800c5a:	3c 2d                	cmp    $0x2d,%al
  800c5c:	75 0a                	jne    800c68 <strtol+0x4d>
		s++, neg = 1;
  800c5e:	83 c2 01             	add    $0x1,%edx
  800c61:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800c68:	85 db                	test   %ebx,%ebx
  800c6a:	0f 94 c0             	sete   %al
  800c6d:	74 05                	je     800c74 <strtol+0x59>
  800c6f:	83 fb 10             	cmp    $0x10,%ebx
  800c72:	75 18                	jne    800c8c <strtol+0x71>
  800c74:	80 3a 30             	cmpb   $0x30,(%edx)
  800c77:	75 13                	jne    800c8c <strtol+0x71>
  800c79:	80 7a 01 78          	cmpb   $0x78,0x1(%edx)
  800c7d:	8d 76 00             	lea    0x0(%esi),%esi
  800c80:	75 0a                	jne    800c8c <strtol+0x71>
		s += 2, base = 16;
  800c82:	83 c2 02             	add    $0x2,%edx
  800c85:	bb 10 00 00 00       	mov    $0x10,%ebx
		s++;
	else if (*s == '-')
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800c8a:	eb 15                	jmp    800ca1 <strtol+0x86>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  800c8c:	84 c0                	test   %al,%al
  800c8e:	66 90                	xchg   %ax,%ax
  800c90:	74 0f                	je     800ca1 <strtol+0x86>
  800c92:	bb 0a 00 00 00       	mov    $0xa,%ebx
  800c97:	80 3a 30             	cmpb   $0x30,(%edx)
  800c9a:	75 05                	jne    800ca1 <strtol+0x86>
		s++, base = 8;
  800c9c:	83 c2 01             	add    $0x1,%edx
  800c9f:	b3 08                	mov    $0x8,%bl
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  800ca1:	b8 00 00 00 00       	mov    $0x0,%eax
  800ca6:	89 de                	mov    %ebx,%esi

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  800ca8:	0f b6 0a             	movzbl (%edx),%ecx
  800cab:	89 cf                	mov    %ecx,%edi
  800cad:	8d 59 d0             	lea    -0x30(%ecx),%ebx
  800cb0:	80 fb 09             	cmp    $0x9,%bl
  800cb3:	77 08                	ja     800cbd <strtol+0xa2>
			dig = *s - '0';
  800cb5:	0f be c9             	movsbl %cl,%ecx
  800cb8:	83 e9 30             	sub    $0x30,%ecx
  800cbb:	eb 1e                	jmp    800cdb <strtol+0xc0>
		else if (*s >= 'a' && *s <= 'z')
  800cbd:	8d 5f 9f             	lea    -0x61(%edi),%ebx
  800cc0:	80 fb 19             	cmp    $0x19,%bl
  800cc3:	77 08                	ja     800ccd <strtol+0xb2>
			dig = *s - 'a' + 10;
  800cc5:	0f be c9             	movsbl %cl,%ecx
  800cc8:	83 e9 57             	sub    $0x57,%ecx
  800ccb:	eb 0e                	jmp    800cdb <strtol+0xc0>
		else if (*s >= 'A' && *s <= 'Z')
  800ccd:	8d 5f bf             	lea    -0x41(%edi),%ebx
  800cd0:	80 fb 19             	cmp    $0x19,%bl
  800cd3:	77 15                	ja     800cea <strtol+0xcf>
			dig = *s - 'A' + 10;
  800cd5:	0f be c9             	movsbl %cl,%ecx
  800cd8:	83 e9 37             	sub    $0x37,%ecx
		else
			break;
		if (dig >= base)
  800cdb:	39 f1                	cmp    %esi,%ecx
  800cdd:	7d 0b                	jge    800cea <strtol+0xcf>
			break;
		s++, val = (val * base) + dig;
  800cdf:	83 c2 01             	add    $0x1,%edx
  800ce2:	0f af c6             	imul   %esi,%eax
  800ce5:	8d 04 01             	lea    (%ecx,%eax,1),%eax
		// we don't properly detect overflow!
	}
  800ce8:	eb be                	jmp    800ca8 <strtol+0x8d>
  800cea:	89 c1                	mov    %eax,%ecx

	if (endptr)
  800cec:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800cf0:	74 05                	je     800cf7 <strtol+0xdc>
		*endptr = (char *) s;
  800cf2:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800cf5:	89 13                	mov    %edx,(%ebx)
	return (neg ? -val : val);
  800cf7:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  800cfb:	74 04                	je     800d01 <strtol+0xe6>
  800cfd:	89 c8                	mov    %ecx,%eax
  800cff:	f7 d8                	neg    %eax
}
  800d01:	83 c4 04             	add    $0x4,%esp
  800d04:	5b                   	pop    %ebx
  800d05:	5e                   	pop    %esi
  800d06:	5f                   	pop    %edi
  800d07:	5d                   	pop    %ebp
  800d08:	c3                   	ret    
  800d09:	00 00                	add    %al,(%eax)
	...

00800d0c <sys_cgetc>:
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}

int
sys_cgetc(void)
{
  800d0c:	55                   	push   %ebp
  800d0d:	89 e5                	mov    %esp,%ebp
  800d0f:	83 ec 0c             	sub    $0xc,%esp
  800d12:	89 1c 24             	mov    %ebx,(%esp)
  800d15:	89 74 24 04          	mov    %esi,0x4(%esp)
  800d19:	89 7c 24 08          	mov    %edi,0x8(%esp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800d1d:	ba 00 00 00 00       	mov    $0x0,%edx
  800d22:	b8 01 00 00 00       	mov    $0x1,%eax
  800d27:	89 d1                	mov    %edx,%ecx
  800d29:	89 d3                	mov    %edx,%ebx
  800d2b:	89 d7                	mov    %edx,%edi
  800d2d:	89 d6                	mov    %edx,%esi
  800d2f:	cd 30                	int    $0x30

int
sys_cgetc(void)
{
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800d31:	8b 1c 24             	mov    (%esp),%ebx
  800d34:	8b 74 24 04          	mov    0x4(%esp),%esi
  800d38:	8b 7c 24 08          	mov    0x8(%esp),%edi
  800d3c:	89 ec                	mov    %ebp,%esp
  800d3e:	5d                   	pop    %ebp
  800d3f:	c3                   	ret    

00800d40 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800d40:	55                   	push   %ebp
  800d41:	89 e5                	mov    %esp,%ebp
  800d43:	83 ec 0c             	sub    $0xc,%esp
  800d46:	89 1c 24             	mov    %ebx,(%esp)
  800d49:	89 74 24 04          	mov    %esi,0x4(%esp)
  800d4d:	89 7c 24 08          	mov    %edi,0x8(%esp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800d51:	b8 00 00 00 00       	mov    $0x0,%eax
  800d56:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d59:	8b 55 08             	mov    0x8(%ebp),%edx
  800d5c:	89 c3                	mov    %eax,%ebx
  800d5e:	89 c7                	mov    %eax,%edi
  800d60:	89 c6                	mov    %eax,%esi
  800d62:	cd 30                	int    $0x30

void
sys_cputs(const char *s, size_t len)
{
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800d64:	8b 1c 24             	mov    (%esp),%ebx
  800d67:	8b 74 24 04          	mov    0x4(%esp),%esi
  800d6b:	8b 7c 24 08          	mov    0x8(%esp),%edi
  800d6f:	89 ec                	mov    %ebp,%esp
  800d71:	5d                   	pop    %ebp
  800d72:	c3                   	ret    

00800d73 <sys_page_insert>:
{
	return syscall(SYS_page_waste, 0, (uint32_t)p, (uint32_t)n, 0, 0,0);
}
int
sys_page_insert(envid_t envid, void *va, struct Page *p, int perm)
{
  800d73:	55                   	push   %ebp
  800d74:	89 e5                	mov    %esp,%ebp
  800d76:	83 ec 38             	sub    $0x38,%esp
  800d79:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800d7c:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800d7f:	89 7d fc             	mov    %edi,-0x4(%ebp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800d82:	be 00 00 00 00       	mov    $0x0,%esi
  800d87:	b8 12 00 00 00       	mov    $0x12,%eax
  800d8c:	8b 7d 14             	mov    0x14(%ebp),%edi
  800d8f:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800d92:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d95:	8b 55 08             	mov    0x8(%ebp),%edx
  800d98:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
	
	if(check && ret > 0)
  800d9a:	85 c0                	test   %eax,%eax
  800d9c:	7e 28                	jle    800dc6 <sys_page_insert+0x53>
		panic("syscall %d returned %d (> 0)", num, ret);
  800d9e:	89 44 24 10          	mov    %eax,0x10(%esp)
  800da2:	c7 44 24 0c 12 00 00 	movl   $0x12,0xc(%esp)
  800da9:	00 
  800daa:	c7 44 24 08 3f 33 80 	movl   $0x80333f,0x8(%esp)
  800db1:	00 
  800db2:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800db9:	00 
  800dba:	c7 04 24 5c 33 80 00 	movl   $0x80335c,(%esp)
  800dc1:	e8 02 f4 ff ff       	call   8001c8 <_panic>
}
int
sys_page_insert(envid_t envid, void *va, struct Page *p, int perm)
{
	return syscall(SYS_page_insert, 1, envid, (uint32_t) va, (uint32_t)p, perm, 0);
}
  800dc6:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800dc9:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800dcc:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800dcf:	89 ec                	mov    %ebp,%esp
  800dd1:	5d                   	pop    %ebp
  800dd2:	c3                   	ret    

00800dd3 <sys_page_waste>:
{
	return (int)syscall(SYS_receive_packet, 0, (uint32_t)buffer, 0,0,0,0);
}

int sys_page_waste(struct Page **p, int n)
{
  800dd3:	55                   	push   %ebp
  800dd4:	89 e5                	mov    %esp,%ebp
  800dd6:	83 ec 0c             	sub    $0xc,%esp
  800dd9:	89 1c 24             	mov    %ebx,(%esp)
  800ddc:	89 74 24 04          	mov    %esi,0x4(%esp)
  800de0:	89 7c 24 08          	mov    %edi,0x8(%esp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800de4:	bb 00 00 00 00       	mov    $0x0,%ebx
  800de9:	b8 11 00 00 00       	mov    $0x11,%eax
  800dee:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800df1:	8b 55 08             	mov    0x8(%ebp),%edx
  800df4:	89 df                	mov    %ebx,%edi
  800df6:	89 de                	mov    %ebx,%esi
  800df8:	cd 30                	int    $0x30
}

int sys_page_waste(struct Page **p, int n)
{
	return syscall(SYS_page_waste, 0, (uint32_t)p, (uint32_t)n, 0, 0,0);
}
  800dfa:	8b 1c 24             	mov    (%esp),%ebx
  800dfd:	8b 74 24 04          	mov    0x4(%esp),%esi
  800e01:	8b 7c 24 08          	mov    0x8(%esp),%edi
  800e05:	89 ec                	mov    %ebp,%esp
  800e07:	5d                   	pop    %ebp
  800e08:	c3                   	ret    

00800e09 <sys_receive_packet>:
{
	return (int)syscall(SYS_transmit_packet, 1, (uint32_t)data, len, 0,0,0);
}

int sys_receive_packet(void* buffer)
{
  800e09:	55                   	push   %ebp
  800e0a:	89 e5                	mov    %esp,%ebp
  800e0c:	83 ec 0c             	sub    $0xc,%esp
  800e0f:	89 1c 24             	mov    %ebx,(%esp)
  800e12:	89 74 24 04          	mov    %esi,0x4(%esp)
  800e16:	89 7c 24 08          	mov    %edi,0x8(%esp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800e1a:	b9 00 00 00 00       	mov    $0x0,%ecx
  800e1f:	b8 10 00 00 00       	mov    $0x10,%eax
  800e24:	8b 55 08             	mov    0x8(%ebp),%edx
  800e27:	89 cb                	mov    %ecx,%ebx
  800e29:	89 cf                	mov    %ecx,%edi
  800e2b:	89 ce                	mov    %ecx,%esi
  800e2d:	cd 30                	int    $0x30
}

int sys_receive_packet(void* buffer)
{
	return (int)syscall(SYS_receive_packet, 0, (uint32_t)buffer, 0,0,0,0);
}
  800e2f:	8b 1c 24             	mov    (%esp),%ebx
  800e32:	8b 74 24 04          	mov    0x4(%esp),%esi
  800e36:	8b 7c 24 08          	mov    0x8(%esp),%edi
  800e3a:	89 ec                	mov    %ebp,%esp
  800e3c:	5d                   	pop    %ebp
  800e3d:	c3                   	ret    

00800e3e <sys_transmit_packet>:
{
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0,0);
}

int sys_transmit_packet(void* data, uint32_t len)
{
  800e3e:	55                   	push   %ebp
  800e3f:	89 e5                	mov    %esp,%ebp
  800e41:	83 ec 38             	sub    $0x38,%esp
  800e44:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800e47:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800e4a:	89 7d fc             	mov    %edi,-0x4(%ebp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800e4d:	bb 00 00 00 00       	mov    $0x0,%ebx
  800e52:	b8 0f 00 00 00       	mov    $0xf,%eax
  800e57:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e5a:	8b 55 08             	mov    0x8(%ebp),%edx
  800e5d:	89 df                	mov    %ebx,%edi
  800e5f:	89 de                	mov    %ebx,%esi
  800e61:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
	
	if(check && ret > 0)
  800e63:	85 c0                	test   %eax,%eax
  800e65:	7e 28                	jle    800e8f <sys_transmit_packet+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  800e67:	89 44 24 10          	mov    %eax,0x10(%esp)
  800e6b:	c7 44 24 0c 0f 00 00 	movl   $0xf,0xc(%esp)
  800e72:	00 
  800e73:	c7 44 24 08 3f 33 80 	movl   $0x80333f,0x8(%esp)
  800e7a:	00 
  800e7b:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800e82:	00 
  800e83:	c7 04 24 5c 33 80 00 	movl   $0x80335c,(%esp)
  800e8a:	e8 39 f3 ff ff       	call   8001c8 <_panic>
}

int sys_transmit_packet(void* data, uint32_t len)
{
	return (int)syscall(SYS_transmit_packet, 1, (uint32_t)data, len, 0,0,0);
}
  800e8f:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800e92:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800e95:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800e98:	89 ec                	mov    %ebp,%esp
  800e9a:	5d                   	pop    %ebp
  800e9b:	c3                   	ret    

00800e9c <sys_time_msec>:
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}

unsigned int
sys_time_msec(void)
{
  800e9c:	55                   	push   %ebp
  800e9d:	89 e5                	mov    %esp,%ebp
  800e9f:	83 ec 0c             	sub    $0xc,%esp
  800ea2:	89 1c 24             	mov    %ebx,(%esp)
  800ea5:	89 74 24 04          	mov    %esi,0x4(%esp)
  800ea9:	89 7c 24 08          	mov    %edi,0x8(%esp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800ead:	ba 00 00 00 00       	mov    $0x0,%edx
  800eb2:	b8 0e 00 00 00       	mov    $0xe,%eax
  800eb7:	89 d1                	mov    %edx,%ecx
  800eb9:	89 d3                	mov    %edx,%ebx
  800ebb:	89 d7                	mov    %edx,%edi
  800ebd:	89 d6                	mov    %edx,%esi
  800ebf:	cd 30                	int    $0x30

unsigned int
sys_time_msec(void)
{
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0,0);
}
  800ec1:	8b 1c 24             	mov    (%esp),%ebx
  800ec4:	8b 74 24 04          	mov    0x4(%esp),%esi
  800ec8:	8b 7c 24 08          	mov    0x8(%esp),%edi
  800ecc:	89 ec                	mov    %ebp,%esp
  800ece:	5d                   	pop    %ebp
  800ecf:	c3                   	ret    

00800ed0 <sys_ipc_recv>:
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}

int
sys_ipc_recv(void *dstva)
{
  800ed0:	55                   	push   %ebp
  800ed1:	89 e5                	mov    %esp,%ebp
  800ed3:	83 ec 38             	sub    $0x38,%esp
  800ed6:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800ed9:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800edc:	89 7d fc             	mov    %edi,-0x4(%ebp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800edf:	b9 00 00 00 00       	mov    $0x0,%ecx
  800ee4:	b8 0d 00 00 00       	mov    $0xd,%eax
  800ee9:	8b 55 08             	mov    0x8(%ebp),%edx
  800eec:	89 cb                	mov    %ecx,%ebx
  800eee:	89 cf                	mov    %ecx,%edi
  800ef0:	89 ce                	mov    %ecx,%esi
  800ef2:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
	
	if(check && ret > 0)
  800ef4:	85 c0                	test   %eax,%eax
  800ef6:	7e 28                	jle    800f20 <sys_ipc_recv+0x50>
		panic("syscall %d returned %d (> 0)", num, ret);
  800ef8:	89 44 24 10          	mov    %eax,0x10(%esp)
  800efc:	c7 44 24 0c 0d 00 00 	movl   $0xd,0xc(%esp)
  800f03:	00 
  800f04:	c7 44 24 08 3f 33 80 	movl   $0x80333f,0x8(%esp)
  800f0b:	00 
  800f0c:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800f13:	00 
  800f14:	c7 04 24 5c 33 80 00 	movl   $0x80335c,(%esp)
  800f1b:	e8 a8 f2 ff ff       	call   8001c8 <_panic>

int
sys_ipc_recv(void *dstva)
{
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  800f20:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800f23:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800f26:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800f29:	89 ec                	mov    %ebp,%esp
  800f2b:	5d                   	pop    %ebp
  800f2c:	c3                   	ret    

00800f2d <sys_ipc_try_send>:
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800f2d:	55                   	push   %ebp
  800f2e:	89 e5                	mov    %esp,%ebp
  800f30:	83 ec 0c             	sub    $0xc,%esp
  800f33:	89 1c 24             	mov    %ebx,(%esp)
  800f36:	89 74 24 04          	mov    %esi,0x4(%esp)
  800f3a:	89 7c 24 08          	mov    %edi,0x8(%esp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800f3e:	be 00 00 00 00       	mov    $0x0,%esi
  800f43:	b8 0c 00 00 00       	mov    $0xc,%eax
  800f48:	8b 7d 14             	mov    0x14(%ebp),%edi
  800f4b:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800f4e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f51:	8b 55 08             	mov    0x8(%ebp),%edx
  800f54:	cd 30                	int    $0x30

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  800f56:	8b 1c 24             	mov    (%esp),%ebx
  800f59:	8b 74 24 04          	mov    0x4(%esp),%esi
  800f5d:	8b 7c 24 08          	mov    0x8(%esp),%edi
  800f61:	89 ec                	mov    %ebp,%esp
  800f63:	5d                   	pop    %ebp
  800f64:	c3                   	ret    

00800f65 <sys_env_set_pgfault_upcall>:
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800f65:	55                   	push   %ebp
  800f66:	89 e5                	mov    %esp,%ebp
  800f68:	83 ec 38             	sub    $0x38,%esp
  800f6b:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800f6e:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800f71:	89 7d fc             	mov    %edi,-0x4(%ebp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800f74:	bb 00 00 00 00       	mov    $0x0,%ebx
  800f79:	b8 0a 00 00 00       	mov    $0xa,%eax
  800f7e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f81:	8b 55 08             	mov    0x8(%ebp),%edx
  800f84:	89 df                	mov    %ebx,%edi
  800f86:	89 de                	mov    %ebx,%esi
  800f88:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
	
	if(check && ret > 0)
  800f8a:	85 c0                	test   %eax,%eax
  800f8c:	7e 28                	jle    800fb6 <sys_env_set_pgfault_upcall+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  800f8e:	89 44 24 10          	mov    %eax,0x10(%esp)
  800f92:	c7 44 24 0c 0a 00 00 	movl   $0xa,0xc(%esp)
  800f99:	00 
  800f9a:	c7 44 24 08 3f 33 80 	movl   $0x80333f,0x8(%esp)
  800fa1:	00 
  800fa2:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800fa9:	00 
  800faa:	c7 04 24 5c 33 80 00 	movl   $0x80335c,(%esp)
  800fb1:	e8 12 f2 ff ff       	call   8001c8 <_panic>

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  800fb6:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800fb9:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800fbc:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800fbf:	89 ec                	mov    %ebp,%esp
  800fc1:	5d                   	pop    %ebp
  800fc2:	c3                   	ret    

00800fc3 <sys_env_set_trapframe>:
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800fc3:	55                   	push   %ebp
  800fc4:	89 e5                	mov    %esp,%ebp
  800fc6:	83 ec 38             	sub    $0x38,%esp
  800fc9:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800fcc:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800fcf:	89 7d fc             	mov    %edi,-0x4(%ebp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800fd2:	bb 00 00 00 00       	mov    $0x0,%ebx
  800fd7:	b8 09 00 00 00       	mov    $0x9,%eax
  800fdc:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800fdf:	8b 55 08             	mov    0x8(%ebp),%edx
  800fe2:	89 df                	mov    %ebx,%edi
  800fe4:	89 de                	mov    %ebx,%esi
  800fe6:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
	
	if(check && ret > 0)
  800fe8:	85 c0                	test   %eax,%eax
  800fea:	7e 28                	jle    801014 <sys_env_set_trapframe+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  800fec:	89 44 24 10          	mov    %eax,0x10(%esp)
  800ff0:	c7 44 24 0c 09 00 00 	movl   $0x9,0xc(%esp)
  800ff7:	00 
  800ff8:	c7 44 24 08 3f 33 80 	movl   $0x80333f,0x8(%esp)
  800fff:	00 
  801000:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  801007:	00 
  801008:	c7 04 24 5c 33 80 00 	movl   $0x80335c,(%esp)
  80100f:	e8 b4 f1 ff ff       	call   8001c8 <_panic>

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  801014:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  801017:	8b 75 f8             	mov    -0x8(%ebp),%esi
  80101a:	8b 7d fc             	mov    -0x4(%ebp),%edi
  80101d:	89 ec                	mov    %ebp,%esp
  80101f:	5d                   	pop    %ebp
  801020:	c3                   	ret    

00801021 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  801021:	55                   	push   %ebp
  801022:	89 e5                	mov    %esp,%ebp
  801024:	83 ec 38             	sub    $0x38,%esp
  801027:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  80102a:	89 75 f8             	mov    %esi,-0x8(%ebp)
  80102d:	89 7d fc             	mov    %edi,-0x4(%ebp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801030:	bb 00 00 00 00       	mov    $0x0,%ebx
  801035:	b8 08 00 00 00       	mov    $0x8,%eax
  80103a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80103d:	8b 55 08             	mov    0x8(%ebp),%edx
  801040:	89 df                	mov    %ebx,%edi
  801042:	89 de                	mov    %ebx,%esi
  801044:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
	
	if(check && ret > 0)
  801046:	85 c0                	test   %eax,%eax
  801048:	7e 28                	jle    801072 <sys_env_set_status+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  80104a:	89 44 24 10          	mov    %eax,0x10(%esp)
  80104e:	c7 44 24 0c 08 00 00 	movl   $0x8,0xc(%esp)
  801055:	00 
  801056:	c7 44 24 08 3f 33 80 	movl   $0x80333f,0x8(%esp)
  80105d:	00 
  80105e:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  801065:	00 
  801066:	c7 04 24 5c 33 80 00 	movl   $0x80335c,(%esp)
  80106d:	e8 56 f1 ff ff       	call   8001c8 <_panic>

int
sys_env_set_status(envid_t envid, int status)
{
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  801072:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  801075:	8b 75 f8             	mov    -0x8(%ebp),%esi
  801078:	8b 7d fc             	mov    -0x4(%ebp),%edi
  80107b:	89 ec                	mov    %ebp,%esp
  80107d:	5d                   	pop    %ebp
  80107e:	c3                   	ret    

0080107f <sys_page_unmap>:
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}

int
sys_page_unmap(envid_t envid, void *va)
{
  80107f:	55                   	push   %ebp
  801080:	89 e5                	mov    %esp,%ebp
  801082:	83 ec 38             	sub    $0x38,%esp
  801085:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  801088:	89 75 f8             	mov    %esi,-0x8(%ebp)
  80108b:	89 7d fc             	mov    %edi,-0x4(%ebp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80108e:	bb 00 00 00 00       	mov    $0x0,%ebx
  801093:	b8 06 00 00 00       	mov    $0x6,%eax
  801098:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80109b:	8b 55 08             	mov    0x8(%ebp),%edx
  80109e:	89 df                	mov    %ebx,%edi
  8010a0:	89 de                	mov    %ebx,%esi
  8010a2:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
	
	if(check && ret > 0)
  8010a4:	85 c0                	test   %eax,%eax
  8010a6:	7e 28                	jle    8010d0 <sys_page_unmap+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  8010a8:	89 44 24 10          	mov    %eax,0x10(%esp)
  8010ac:	c7 44 24 0c 06 00 00 	movl   $0x6,0xc(%esp)
  8010b3:	00 
  8010b4:	c7 44 24 08 3f 33 80 	movl   $0x80333f,0x8(%esp)
  8010bb:	00 
  8010bc:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  8010c3:	00 
  8010c4:	c7 04 24 5c 33 80 00 	movl   $0x80335c,(%esp)
  8010cb:	e8 f8 f0 ff ff       	call   8001c8 <_panic>

int
sys_page_unmap(envid_t envid, void *va)
{
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  8010d0:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  8010d3:	8b 75 f8             	mov    -0x8(%ebp),%esi
  8010d6:	8b 7d fc             	mov    -0x4(%ebp),%edi
  8010d9:	89 ec                	mov    %ebp,%esp
  8010db:	5d                   	pop    %ebp
  8010dc:	c3                   	ret    

008010dd <sys_page_map>:
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  8010dd:	55                   	push   %ebp
  8010de:	89 e5                	mov    %esp,%ebp
  8010e0:	83 ec 38             	sub    $0x38,%esp
  8010e3:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  8010e6:	89 75 f8             	mov    %esi,-0x8(%ebp)
  8010e9:	89 7d fc             	mov    %edi,-0x4(%ebp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8010ec:	b8 05 00 00 00       	mov    $0x5,%eax
  8010f1:	8b 75 18             	mov    0x18(%ebp),%esi
  8010f4:	8b 7d 14             	mov    0x14(%ebp),%edi
  8010f7:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8010fa:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8010fd:	8b 55 08             	mov    0x8(%ebp),%edx
  801100:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
	
	if(check && ret > 0)
  801102:	85 c0                	test   %eax,%eax
  801104:	7e 28                	jle    80112e <sys_page_map+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  801106:	89 44 24 10          	mov    %eax,0x10(%esp)
  80110a:	c7 44 24 0c 05 00 00 	movl   $0x5,0xc(%esp)
  801111:	00 
  801112:	c7 44 24 08 3f 33 80 	movl   $0x80333f,0x8(%esp)
  801119:	00 
  80111a:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  801121:	00 
  801122:	c7 04 24 5c 33 80 00 	movl   $0x80335c,(%esp)
  801129:	e8 9a f0 ff ff       	call   8001c8 <_panic>

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  80112e:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  801131:	8b 75 f8             	mov    -0x8(%ebp),%esi
  801134:	8b 7d fc             	mov    -0x4(%ebp),%edi
  801137:	89 ec                	mov    %ebp,%esp
  801139:	5d                   	pop    %ebp
  80113a:	c3                   	ret    

0080113b <sys_page_alloc>:
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  80113b:	55                   	push   %ebp
  80113c:	89 e5                	mov    %esp,%ebp
  80113e:	83 ec 38             	sub    $0x38,%esp
  801141:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  801144:	89 75 f8             	mov    %esi,-0x8(%ebp)
  801147:	89 7d fc             	mov    %edi,-0x4(%ebp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80114a:	be 00 00 00 00       	mov    $0x0,%esi
  80114f:	b8 04 00 00 00       	mov    $0x4,%eax
  801154:	8b 5d 10             	mov    0x10(%ebp),%ebx
  801157:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80115a:	8b 55 08             	mov    0x8(%ebp),%edx
  80115d:	89 f7                	mov    %esi,%edi
  80115f:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
	
	if(check && ret > 0)
  801161:	85 c0                	test   %eax,%eax
  801163:	7e 28                	jle    80118d <sys_page_alloc+0x52>
		panic("syscall %d returned %d (> 0)", num, ret);
  801165:	89 44 24 10          	mov    %eax,0x10(%esp)
  801169:	c7 44 24 0c 04 00 00 	movl   $0x4,0xc(%esp)
  801170:	00 
  801171:	c7 44 24 08 3f 33 80 	movl   $0x80333f,0x8(%esp)
  801178:	00 
  801179:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  801180:	00 
  801181:	c7 04 24 5c 33 80 00 	movl   $0x80335c,(%esp)
  801188:	e8 3b f0 ff ff       	call   8001c8 <_panic>

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  80118d:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  801190:	8b 75 f8             	mov    -0x8(%ebp),%esi
  801193:	8b 7d fc             	mov    -0x4(%ebp),%edi
  801196:	89 ec                	mov    %ebp,%esp
  801198:	5d                   	pop    %ebp
  801199:	c3                   	ret    

0080119a <sys_yield>:
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}

void
sys_yield(void)
{
  80119a:	55                   	push   %ebp
  80119b:	89 e5                	mov    %esp,%ebp
  80119d:	83 ec 0c             	sub    $0xc,%esp
  8011a0:	89 1c 24             	mov    %ebx,(%esp)
  8011a3:	89 74 24 04          	mov    %esi,0x4(%esp)
  8011a7:	89 7c 24 08          	mov    %edi,0x8(%esp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8011ab:	ba 00 00 00 00       	mov    $0x0,%edx
  8011b0:	b8 0b 00 00 00       	mov    $0xb,%eax
  8011b5:	89 d1                	mov    %edx,%ecx
  8011b7:	89 d3                	mov    %edx,%ebx
  8011b9:	89 d7                	mov    %edx,%edi
  8011bb:	89 d6                	mov    %edx,%esi
  8011bd:	cd 30                	int    $0x30

void
sys_yield(void)
{
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  8011bf:	8b 1c 24             	mov    (%esp),%ebx
  8011c2:	8b 74 24 04          	mov    0x4(%esp),%esi
  8011c6:	8b 7c 24 08          	mov    0x8(%esp),%edi
  8011ca:	89 ec                	mov    %ebp,%esp
  8011cc:	5d                   	pop    %ebp
  8011cd:	c3                   	ret    

008011ce <sys_getenvid>:
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}

envid_t
sys_getenvid(void)
{
  8011ce:	55                   	push   %ebp
  8011cf:	89 e5                	mov    %esp,%ebp
  8011d1:	83 ec 0c             	sub    $0xc,%esp
  8011d4:	89 1c 24             	mov    %ebx,(%esp)
  8011d7:	89 74 24 04          	mov    %esi,0x4(%esp)
  8011db:	89 7c 24 08          	mov    %edi,0x8(%esp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8011df:	ba 00 00 00 00       	mov    $0x0,%edx
  8011e4:	b8 02 00 00 00       	mov    $0x2,%eax
  8011e9:	89 d1                	mov    %edx,%ecx
  8011eb:	89 d3                	mov    %edx,%ebx
  8011ed:	89 d7                	mov    %edx,%edi
  8011ef:	89 d6                	mov    %edx,%esi
  8011f1:	cd 30                	int    $0x30

envid_t
sys_getenvid(void)
{
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  8011f3:	8b 1c 24             	mov    (%esp),%ebx
  8011f6:	8b 74 24 04          	mov    0x4(%esp),%esi
  8011fa:	8b 7c 24 08          	mov    0x8(%esp),%edi
  8011fe:	89 ec                	mov    %ebp,%esp
  801200:	5d                   	pop    %ebp
  801201:	c3                   	ret    

00801202 <sys_env_destroy>:
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}

int
sys_env_destroy(envid_t envid)
{
  801202:	55                   	push   %ebp
  801203:	89 e5                	mov    %esp,%ebp
  801205:	83 ec 38             	sub    $0x38,%esp
  801208:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  80120b:	89 75 f8             	mov    %esi,-0x8(%ebp)
  80120e:	89 7d fc             	mov    %edi,-0x4(%ebp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801211:	b9 00 00 00 00       	mov    $0x0,%ecx
  801216:	b8 03 00 00 00       	mov    $0x3,%eax
  80121b:	8b 55 08             	mov    0x8(%ebp),%edx
  80121e:	89 cb                	mov    %ecx,%ebx
  801220:	89 cf                	mov    %ecx,%edi
  801222:	89 ce                	mov    %ecx,%esi
  801224:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
	
	if(check && ret > 0)
  801226:	85 c0                	test   %eax,%eax
  801228:	7e 28                	jle    801252 <sys_env_destroy+0x50>
		panic("syscall %d returned %d (> 0)", num, ret);
  80122a:	89 44 24 10          	mov    %eax,0x10(%esp)
  80122e:	c7 44 24 0c 03 00 00 	movl   $0x3,0xc(%esp)
  801235:	00 
  801236:	c7 44 24 08 3f 33 80 	movl   $0x80333f,0x8(%esp)
  80123d:	00 
  80123e:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  801245:	00 
  801246:	c7 04 24 5c 33 80 00 	movl   $0x80335c,(%esp)
  80124d:	e8 76 ef ff ff       	call   8001c8 <_panic>

int
sys_env_destroy(envid_t envid)
{
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  801252:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  801255:	8b 75 f8             	mov    -0x8(%ebp),%esi
  801258:	8b 7d fc             	mov    -0x4(%ebp),%edi
  80125b:	89 ec                	mov    %ebp,%esp
  80125d:	5d                   	pop    %ebp
  80125e:	c3                   	ret    
	...

00801260 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  801260:	55                   	push   %ebp
  801261:	89 e5                	mov    %esp,%ebp
  801263:	8b 45 08             	mov    0x8(%ebp),%eax
  801266:	05 00 00 00 30       	add    $0x30000000,%eax
  80126b:	c1 e8 0c             	shr    $0xc,%eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
}
  80126e:	5d                   	pop    %ebp
  80126f:	c3                   	ret    

00801270 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  801270:	55                   	push   %ebp
  801271:	89 e5                	mov    %esp,%ebp
  801273:	83 ec 04             	sub    $0x4,%esp
	return INDEX2DATA(fd2num(fd));
  801276:	8b 45 08             	mov    0x8(%ebp),%eax
  801279:	89 04 24             	mov    %eax,(%esp)
  80127c:	e8 df ff ff ff       	call   801260 <fd2num>
  801281:	05 20 00 0d 00       	add    $0xd0020,%eax
  801286:	c1 e0 0c             	shl    $0xc,%eax
}
  801289:	c9                   	leave  
  80128a:	c3                   	ret    

0080128b <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  80128b:	55                   	push   %ebp
  80128c:	89 e5                	mov    %esp,%ebp
  80128e:	57                   	push   %edi
  80128f:	56                   	push   %esi
  801290:	53                   	push   %ebx
  801291:	8b 7d 08             	mov    0x8(%ebp),%edi
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((vpd[PDX(fd)] & PTE_P) == 0 || (vpt[VPN(fd)] & PTE_P) == 0) {
  801294:	a1 00 dd 7b ef       	mov    0xef7bdd00,%eax
  801299:	a8 01                	test   $0x1,%al
  80129b:	74 36                	je     8012d3 <fd_alloc+0x48>
  80129d:	a1 00 00 74 ef       	mov    0xef740000,%eax
  8012a2:	a8 01                	test   $0x1,%al
  8012a4:	74 2d                	je     8012d3 <fd_alloc+0x48>
  8012a6:	b8 00 10 00 d0       	mov    $0xd0001000,%eax
  8012ab:	b9 00 d0 7b ef       	mov    $0xef7bd000,%ecx
  8012b0:	be 00 00 40 ef       	mov    $0xef400000,%esi
  8012b5:	89 c3                	mov    %eax,%ebx
  8012b7:	89 c2                	mov    %eax,%edx
  8012b9:	c1 ea 16             	shr    $0x16,%edx
  8012bc:	8b 14 91             	mov    (%ecx,%edx,4),%edx
  8012bf:	f6 c2 01             	test   $0x1,%dl
  8012c2:	74 14                	je     8012d8 <fd_alloc+0x4d>
  8012c4:	89 c2                	mov    %eax,%edx
  8012c6:	c1 ea 0c             	shr    $0xc,%edx
  8012c9:	8b 14 96             	mov    (%esi,%edx,4),%edx
  8012cc:	f6 c2 01             	test   $0x1,%dl
  8012cf:	75 10                	jne    8012e1 <fd_alloc+0x56>
  8012d1:	eb 05                	jmp    8012d8 <fd_alloc+0x4d>
  8012d3:	bb 00 00 00 d0       	mov    $0xd0000000,%ebx
			*fd_store = fd;
  8012d8:	89 1f                	mov    %ebx,(%edi)
  8012da:	b8 00 00 00 00       	mov    $0x0,%eax
			return 0;
  8012df:	eb 17                	jmp    8012f8 <fd_alloc+0x6d>
  8012e1:	05 00 10 00 00       	add    $0x1000,%eax
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  8012e6:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  8012eb:	75 c8                	jne    8012b5 <fd_alloc+0x2a>
		if ((vpd[PDX(fd)] & PTE_P) == 0 || (vpt[VPN(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  8012ed:	c7 07 00 00 00 00    	movl   $0x0,(%edi)
  8012f3:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
	return -E_MAX_OPEN;
}
  8012f8:	5b                   	pop    %ebx
  8012f9:	5e                   	pop    %esi
  8012fa:	5f                   	pop    %edi
  8012fb:	5d                   	pop    %ebp
  8012fc:	c3                   	ret    

008012fd <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  8012fd:	55                   	push   %ebp
  8012fe:	89 e5                	mov    %esp,%ebp
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  801300:	8b 45 08             	mov    0x8(%ebp),%eax
  801303:	83 f8 1f             	cmp    $0x1f,%eax
  801306:	77 36                	ja     80133e <fd_lookup+0x41>
		if (debug)
			cprintf("[%08x] bad fd %d\n", env->env_id, fd);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  801308:	05 00 00 0d 00       	add    $0xd0000,%eax
  80130d:	c1 e0 0c             	shl    $0xc,%eax
	if (!(vpd[PDX(fd)] & PTE_P) || !(vpt[VPN(fd)] & PTE_P)) {
  801310:	89 c2                	mov    %eax,%edx
  801312:	c1 ea 16             	shr    $0x16,%edx
  801315:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  80131c:	f6 c2 01             	test   $0x1,%dl
  80131f:	74 1d                	je     80133e <fd_lookup+0x41>
  801321:	89 c2                	mov    %eax,%edx
  801323:	c1 ea 0c             	shr    $0xc,%edx
  801326:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  80132d:	f6 c2 01             	test   $0x1,%dl
  801330:	74 0c                	je     80133e <fd_lookup+0x41>
		if (debug)
			cprintf("[%08x] closed fd %d\n", env->env_id, fd);
		return -E_INVAL;
	}
	*fd_store = fd;
  801332:	8b 55 0c             	mov    0xc(%ebp),%edx
  801335:	89 02                	mov    %eax,(%edx)
  801337:	b8 00 00 00 00       	mov    $0x0,%eax
	return 0;
  80133c:	eb 05                	jmp    801343 <fd_lookup+0x46>
  80133e:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  801343:	5d                   	pop    %ebp
  801344:	c3                   	ret    

00801345 <seek>:
	return (*dev->dev_write)(fd, buf, n);
}

int
seek(int fdnum, off_t offset)
{
  801345:	55                   	push   %ebp
  801346:	89 e5                	mov    %esp,%ebp
  801348:	83 ec 18             	sub    $0x18,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80134b:	8d 45 fc             	lea    -0x4(%ebp),%eax
  80134e:	89 44 24 04          	mov    %eax,0x4(%esp)
  801352:	8b 45 08             	mov    0x8(%ebp),%eax
  801355:	89 04 24             	mov    %eax,(%esp)
  801358:	e8 a0 ff ff ff       	call   8012fd <fd_lookup>
  80135d:	85 c0                	test   %eax,%eax
  80135f:	78 0e                	js     80136f <seek+0x2a>
		return r;
	fd->fd_offset = offset;
  801361:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801364:	8b 55 0c             	mov    0xc(%ebp),%edx
  801367:	89 50 04             	mov    %edx,0x4(%eax)
  80136a:	b8 00 00 00 00       	mov    $0x0,%eax
	return 0;
}
  80136f:	c9                   	leave  
  801370:	c3                   	ret    

00801371 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  801371:	55                   	push   %ebp
  801372:	89 e5                	mov    %esp,%ebp
  801374:	56                   	push   %esi
  801375:	53                   	push   %ebx
  801376:	83 ec 10             	sub    $0x10,%esp
  801379:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80137c:	8b 5d 0c             	mov    0xc(%ebp),%ebx
// File functions
// --------------------------------------------------------------

static struct Dev *devtab[] =
{
	&devfile,
  80137f:	b8 04 70 80 00       	mov    $0x807004,%eax
{
	int i;
	for (i = 0; devtab[i]; i++)
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
  801384:	ba 00 00 00 00       	mov    $0x0,%edx

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  801389:	be e8 33 80 00       	mov    $0x8033e8,%esi
		if (devtab[i]->dev_id == dev_id) {
  80138e:	39 08                	cmp    %ecx,(%eax)
  801390:	75 10                	jne    8013a2 <dev_lookup+0x31>
  801392:	eb 04                	jmp    801398 <dev_lookup+0x27>
  801394:	39 08                	cmp    %ecx,(%eax)
  801396:	75 0a                	jne    8013a2 <dev_lookup+0x31>
			*dev = devtab[i];
  801398:	89 03                	mov    %eax,(%ebx)
  80139a:	b8 00 00 00 00       	mov    $0x0,%eax
			return 0;
  80139f:	90                   	nop
  8013a0:	eb 31                	jmp    8013d3 <dev_lookup+0x62>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  8013a2:	83 c2 01             	add    $0x1,%edx
  8013a5:	8b 04 96             	mov    (%esi,%edx,4),%eax
  8013a8:	85 c0                	test   %eax,%eax
  8013aa:	75 e8                	jne    801394 <dev_lookup+0x23>
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", env->env_id, dev_id);
  8013ac:	a1 74 70 80 00       	mov    0x807074,%eax
  8013b1:	8b 40 4c             	mov    0x4c(%eax),%eax
  8013b4:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8013b8:	89 44 24 04          	mov    %eax,0x4(%esp)
  8013bc:	c7 04 24 6c 33 80 00 	movl   $0x80336c,(%esp)
  8013c3:	e8 c5 ee ff ff       	call   80028d <cprintf>
	*dev = 0;
  8013c8:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  8013ce:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
	return -E_INVAL;
}
  8013d3:	83 c4 10             	add    $0x10,%esp
  8013d6:	5b                   	pop    %ebx
  8013d7:	5e                   	pop    %esi
  8013d8:	5d                   	pop    %ebp
  8013d9:	c3                   	ret    

008013da <fstat>:
	return (*dev->dev_trunc)(fd, newsize);
}

int
fstat(int fdnum, struct Stat *stat)
{
  8013da:	55                   	push   %ebp
  8013db:	89 e5                	mov    %esp,%ebp
  8013dd:	53                   	push   %ebx
  8013de:	83 ec 24             	sub    $0x24,%esp
  8013e1:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8013e4:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8013e7:	89 44 24 04          	mov    %eax,0x4(%esp)
  8013eb:	8b 45 08             	mov    0x8(%ebp),%eax
  8013ee:	89 04 24             	mov    %eax,(%esp)
  8013f1:	e8 07 ff ff ff       	call   8012fd <fd_lookup>
  8013f6:	85 c0                	test   %eax,%eax
  8013f8:	78 53                	js     80144d <fstat+0x73>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8013fa:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8013fd:	89 44 24 04          	mov    %eax,0x4(%esp)
  801401:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801404:	8b 00                	mov    (%eax),%eax
  801406:	89 04 24             	mov    %eax,(%esp)
  801409:	e8 63 ff ff ff       	call   801371 <dev_lookup>
{
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80140e:	85 c0                	test   %eax,%eax
  801410:	78 3b                	js     80144d <fstat+0x73>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if (!dev->dev_stat)
  801412:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801417:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80141a:	83 7a 14 00          	cmpl   $0x0,0x14(%edx)
  80141e:	74 2d                	je     80144d <fstat+0x73>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  801420:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  801423:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  80142a:	00 00 00 
	stat->st_isdir = 0;
  80142d:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801434:	00 00 00 
	stat->st_dev = dev;
  801437:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80143a:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  801440:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801444:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801447:	89 14 24             	mov    %edx,(%esp)
  80144a:	ff 50 14             	call   *0x14(%eax)
}
  80144d:	83 c4 24             	add    $0x24,%esp
  801450:	5b                   	pop    %ebx
  801451:	5d                   	pop    %ebp
  801452:	c3                   	ret    

00801453 <ftruncate>:
	return 0;
}

int
ftruncate(int fdnum, off_t newsize)
{
  801453:	55                   	push   %ebp
  801454:	89 e5                	mov    %esp,%ebp
  801456:	53                   	push   %ebx
  801457:	83 ec 24             	sub    $0x24,%esp
  80145a:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  80145d:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801460:	89 44 24 04          	mov    %eax,0x4(%esp)
  801464:	89 1c 24             	mov    %ebx,(%esp)
  801467:	e8 91 fe ff ff       	call   8012fd <fd_lookup>
  80146c:	85 c0                	test   %eax,%eax
  80146e:	78 5f                	js     8014cf <ftruncate+0x7c>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801470:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801473:	89 44 24 04          	mov    %eax,0x4(%esp)
  801477:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80147a:	8b 00                	mov    (%eax),%eax
  80147c:	89 04 24             	mov    %eax,(%esp)
  80147f:	e8 ed fe ff ff       	call   801371 <dev_lookup>
ftruncate(int fdnum, off_t newsize)
{
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  801484:	85 c0                	test   %eax,%eax
  801486:	78 47                	js     8014cf <ftruncate+0x7c>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801488:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80148b:	f6 42 08 03          	testb  $0x3,0x8(%edx)
  80148f:	75 23                	jne    8014b4 <ftruncate+0x61>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			env->env_id, fdnum); 
  801491:	a1 74 70 80 00       	mov    0x807074,%eax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  801496:	8b 40 4c             	mov    0x4c(%eax),%eax
  801499:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80149d:	89 44 24 04          	mov    %eax,0x4(%esp)
  8014a1:	c7 04 24 8c 33 80 00 	movl   $0x80338c,(%esp)
  8014a8:	e8 e0 ed ff ff       	call   80028d <cprintf>
  8014ad:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
			env->env_id, fdnum); 
		return -E_INVAL;
  8014b2:	eb 1b                	jmp    8014cf <ftruncate+0x7c>
	}
	if (!dev->dev_trunc)
  8014b4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8014b7:	8b 48 18             	mov    0x18(%eax),%ecx
  8014ba:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8014bf:	85 c9                	test   %ecx,%ecx
  8014c1:	74 0c                	je     8014cf <ftruncate+0x7c>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  8014c3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014c6:	89 44 24 04          	mov    %eax,0x4(%esp)
  8014ca:	89 14 24             	mov    %edx,(%esp)
  8014cd:	ff d1                	call   *%ecx
}
  8014cf:	83 c4 24             	add    $0x24,%esp
  8014d2:	5b                   	pop    %ebx
  8014d3:	5d                   	pop    %ebp
  8014d4:	c3                   	ret    

008014d5 <write>:
	return tot;
}

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  8014d5:	55                   	push   %ebp
  8014d6:	89 e5                	mov    %esp,%ebp
  8014d8:	53                   	push   %ebx
  8014d9:	83 ec 24             	sub    $0x24,%esp
  8014dc:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8014df:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8014e2:	89 44 24 04          	mov    %eax,0x4(%esp)
  8014e6:	89 1c 24             	mov    %ebx,(%esp)
  8014e9:	e8 0f fe ff ff       	call   8012fd <fd_lookup>
  8014ee:	85 c0                	test   %eax,%eax
  8014f0:	78 66                	js     801558 <write+0x83>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8014f2:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8014f5:	89 44 24 04          	mov    %eax,0x4(%esp)
  8014f9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8014fc:	8b 00                	mov    (%eax),%eax
  8014fe:	89 04 24             	mov    %eax,(%esp)
  801501:	e8 6b fe ff ff       	call   801371 <dev_lookup>
{
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801506:	85 c0                	test   %eax,%eax
  801508:	78 4e                	js     801558 <write+0x83>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  80150a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80150d:	f6 42 08 03          	testb  $0x3,0x8(%edx)
  801511:	75 23                	jne    801536 <write+0x61>
		cprintf("[%08x] write %d -- bad mode\n", env->env_id, fdnum);
  801513:	a1 74 70 80 00       	mov    0x807074,%eax
  801518:	8b 40 4c             	mov    0x4c(%eax),%eax
  80151b:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80151f:	89 44 24 04          	mov    %eax,0x4(%esp)
  801523:	c7 04 24 ad 33 80 00 	movl   $0x8033ad,(%esp)
  80152a:	e8 5e ed ff ff       	call   80028d <cprintf>
  80152f:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
		return -E_INVAL;
  801534:	eb 22                	jmp    801558 <write+0x83>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  801536:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801539:	8b 48 0c             	mov    0xc(%eax),%ecx
  80153c:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801541:	85 c9                	test   %ecx,%ecx
  801543:	74 13                	je     801558 <write+0x83>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  801545:	8b 45 10             	mov    0x10(%ebp),%eax
  801548:	89 44 24 08          	mov    %eax,0x8(%esp)
  80154c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80154f:	89 44 24 04          	mov    %eax,0x4(%esp)
  801553:	89 14 24             	mov    %edx,(%esp)
  801556:	ff d1                	call   *%ecx
}
  801558:	83 c4 24             	add    $0x24,%esp
  80155b:	5b                   	pop    %ebx
  80155c:	5d                   	pop    %ebp
  80155d:	c3                   	ret    

0080155e <read>:
	return r;
}

ssize_t
read(int fdnum, void *buf, size_t n)
{
  80155e:	55                   	push   %ebp
  80155f:	89 e5                	mov    %esp,%ebp
  801561:	53                   	push   %ebx
  801562:	83 ec 24             	sub    $0x24,%esp
  801565:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801568:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80156b:	89 44 24 04          	mov    %eax,0x4(%esp)
  80156f:	89 1c 24             	mov    %ebx,(%esp)
  801572:	e8 86 fd ff ff       	call   8012fd <fd_lookup>
  801577:	85 c0                	test   %eax,%eax
  801579:	78 6b                	js     8015e6 <read+0x88>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80157b:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80157e:	89 44 24 04          	mov    %eax,0x4(%esp)
  801582:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801585:	8b 00                	mov    (%eax),%eax
  801587:	89 04 24             	mov    %eax,(%esp)
  80158a:	e8 e2 fd ff ff       	call   801371 <dev_lookup>
{
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80158f:	85 c0                	test   %eax,%eax
  801591:	78 53                	js     8015e6 <read+0x88>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  801593:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801596:	8b 42 08             	mov    0x8(%edx),%eax
  801599:	83 e0 03             	and    $0x3,%eax
  80159c:	83 f8 01             	cmp    $0x1,%eax
  80159f:	75 23                	jne    8015c4 <read+0x66>
		cprintf("[%08x] read %d -- bad mode\n", env->env_id, fdnum); 
  8015a1:	a1 74 70 80 00       	mov    0x807074,%eax
  8015a6:	8b 40 4c             	mov    0x4c(%eax),%eax
  8015a9:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8015ad:	89 44 24 04          	mov    %eax,0x4(%esp)
  8015b1:	c7 04 24 ca 33 80 00 	movl   $0x8033ca,(%esp)
  8015b8:	e8 d0 ec ff ff       	call   80028d <cprintf>
  8015bd:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
		return -E_INVAL;
  8015c2:	eb 22                	jmp    8015e6 <read+0x88>
	}
	if (!dev->dev_read)
  8015c4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8015c7:	8b 48 08             	mov    0x8(%eax),%ecx
  8015ca:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8015cf:	85 c9                	test   %ecx,%ecx
  8015d1:	74 13                	je     8015e6 <read+0x88>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  8015d3:	8b 45 10             	mov    0x10(%ebp),%eax
  8015d6:	89 44 24 08          	mov    %eax,0x8(%esp)
  8015da:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015dd:	89 44 24 04          	mov    %eax,0x4(%esp)
  8015e1:	89 14 24             	mov    %edx,(%esp)
  8015e4:	ff d1                	call   *%ecx
}
  8015e6:	83 c4 24             	add    $0x24,%esp
  8015e9:	5b                   	pop    %ebx
  8015ea:	5d                   	pop    %ebp
  8015eb:	c3                   	ret    

008015ec <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  8015ec:	55                   	push   %ebp
  8015ed:	89 e5                	mov    %esp,%ebp
  8015ef:	57                   	push   %edi
  8015f0:	56                   	push   %esi
  8015f1:	53                   	push   %ebx
  8015f2:	83 ec 1c             	sub    $0x1c,%esp
  8015f5:	8b 7d 08             	mov    0x8(%ebp),%edi
  8015f8:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  8015fb:	ba 00 00 00 00       	mov    $0x0,%edx
  801600:	bb 00 00 00 00       	mov    $0x0,%ebx
  801605:	b8 00 00 00 00       	mov    $0x0,%eax
  80160a:	85 f6                	test   %esi,%esi
  80160c:	74 29                	je     801637 <readn+0x4b>
		m = read(fdnum, (char*)buf + tot, n - tot);
  80160e:	89 f0                	mov    %esi,%eax
  801610:	29 d0                	sub    %edx,%eax
  801612:	89 44 24 08          	mov    %eax,0x8(%esp)
  801616:	03 55 0c             	add    0xc(%ebp),%edx
  801619:	89 54 24 04          	mov    %edx,0x4(%esp)
  80161d:	89 3c 24             	mov    %edi,(%esp)
  801620:	e8 39 ff ff ff       	call   80155e <read>
		if (m < 0)
  801625:	85 c0                	test   %eax,%eax
  801627:	78 0e                	js     801637 <readn+0x4b>
			return m;
		if (m == 0)
  801629:	85 c0                	test   %eax,%eax
  80162b:	74 08                	je     801635 <readn+0x49>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  80162d:	01 c3                	add    %eax,%ebx
  80162f:	89 da                	mov    %ebx,%edx
  801631:	39 f3                	cmp    %esi,%ebx
  801633:	72 d9                	jb     80160e <readn+0x22>
  801635:	89 d8                	mov    %ebx,%eax
			return m;
		if (m == 0)
			break;
	}
	return tot;
}
  801637:	83 c4 1c             	add    $0x1c,%esp
  80163a:	5b                   	pop    %ebx
  80163b:	5e                   	pop    %esi
  80163c:	5f                   	pop    %edi
  80163d:	5d                   	pop    %ebp
  80163e:	c3                   	ret    

0080163f <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  80163f:	55                   	push   %ebp
  801640:	89 e5                	mov    %esp,%ebp
  801642:	56                   	push   %esi
  801643:	53                   	push   %ebx
  801644:	83 ec 20             	sub    $0x20,%esp
  801647:	8b 75 08             	mov    0x8(%ebp),%esi
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  80164a:	89 34 24             	mov    %esi,(%esp)
  80164d:	e8 0e fc ff ff       	call   801260 <fd2num>
  801652:	8d 55 f4             	lea    -0xc(%ebp),%edx
  801655:	89 54 24 04          	mov    %edx,0x4(%esp)
  801659:	89 04 24             	mov    %eax,(%esp)
  80165c:	e8 9c fc ff ff       	call   8012fd <fd_lookup>
  801661:	89 c3                	mov    %eax,%ebx
  801663:	85 c0                	test   %eax,%eax
  801665:	78 05                	js     80166c <fd_close+0x2d>
  801667:	3b 75 f4             	cmp    -0xc(%ebp),%esi
  80166a:	74 0c                	je     801678 <fd_close+0x39>
	    || fd != fd2)
		return (must_exist ? r : 0);
  80166c:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  801670:	19 c0                	sbb    %eax,%eax
  801672:	f7 d0                	not    %eax
  801674:	21 c3                	and    %eax,%ebx
  801676:	eb 3d                	jmp    8016b5 <fd_close+0x76>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  801678:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80167b:	89 44 24 04          	mov    %eax,0x4(%esp)
  80167f:	8b 06                	mov    (%esi),%eax
  801681:	89 04 24             	mov    %eax,(%esp)
  801684:	e8 e8 fc ff ff       	call   801371 <dev_lookup>
  801689:	89 c3                	mov    %eax,%ebx
  80168b:	85 c0                	test   %eax,%eax
  80168d:	78 16                	js     8016a5 <fd_close+0x66>
		if (dev->dev_close)
  80168f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801692:	8b 40 10             	mov    0x10(%eax),%eax
  801695:	bb 00 00 00 00       	mov    $0x0,%ebx
  80169a:	85 c0                	test   %eax,%eax
  80169c:	74 07                	je     8016a5 <fd_close+0x66>
			r = (*dev->dev_close)(fd);
  80169e:	89 34 24             	mov    %esi,(%esp)
  8016a1:	ff d0                	call   *%eax
  8016a3:	89 c3                	mov    %eax,%ebx
		else
			r = 0;
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  8016a5:	89 74 24 04          	mov    %esi,0x4(%esp)
  8016a9:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8016b0:	e8 ca f9 ff ff       	call   80107f <sys_page_unmap>
	return r;
}
  8016b5:	89 d8                	mov    %ebx,%eax
  8016b7:	83 c4 20             	add    $0x20,%esp
  8016ba:	5b                   	pop    %ebx
  8016bb:	5e                   	pop    %esi
  8016bc:	5d                   	pop    %ebp
  8016bd:	c3                   	ret    

008016be <close>:
	return -E_INVAL;
}

int
close(int fdnum)
{
  8016be:	55                   	push   %ebp
  8016bf:	89 e5                	mov    %esp,%ebp
  8016c1:	83 ec 28             	sub    $0x28,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8016c4:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8016c7:	89 44 24 04          	mov    %eax,0x4(%esp)
  8016cb:	8b 45 08             	mov    0x8(%ebp),%eax
  8016ce:	89 04 24             	mov    %eax,(%esp)
  8016d1:	e8 27 fc ff ff       	call   8012fd <fd_lookup>
  8016d6:	85 c0                	test   %eax,%eax
  8016d8:	78 13                	js     8016ed <close+0x2f>
		return r;
	else
		return fd_close(fd, 1);
  8016da:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  8016e1:	00 
  8016e2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8016e5:	89 04 24             	mov    %eax,(%esp)
  8016e8:	e8 52 ff ff ff       	call   80163f <fd_close>
}
  8016ed:	c9                   	leave  
  8016ee:	c3                   	ret    

008016ef <stat>:
	return (*dev->dev_stat)(fd, stat);
}

int
stat(const char *path, struct Stat *stat)
{
  8016ef:	55                   	push   %ebp
  8016f0:	89 e5                	mov    %esp,%ebp
  8016f2:	83 ec 18             	sub    $0x18,%esp
  8016f5:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  8016f8:	89 75 fc             	mov    %esi,-0x4(%ebp)
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  8016fb:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  801702:	00 
  801703:	8b 45 08             	mov    0x8(%ebp),%eax
  801706:	89 04 24             	mov    %eax,(%esp)
  801709:	e8 55 03 00 00       	call   801a63 <open>
  80170e:	89 c3                	mov    %eax,%ebx
  801710:	85 c0                	test   %eax,%eax
  801712:	78 1b                	js     80172f <stat+0x40>
		return fd;
	r = fstat(fd, stat);
  801714:	8b 45 0c             	mov    0xc(%ebp),%eax
  801717:	89 44 24 04          	mov    %eax,0x4(%esp)
  80171b:	89 1c 24             	mov    %ebx,(%esp)
  80171e:	e8 b7 fc ff ff       	call   8013da <fstat>
  801723:	89 c6                	mov    %eax,%esi
	close(fd);
  801725:	89 1c 24             	mov    %ebx,(%esp)
  801728:	e8 91 ff ff ff       	call   8016be <close>
  80172d:	89 f3                	mov    %esi,%ebx
	return r;
}
  80172f:	89 d8                	mov    %ebx,%eax
  801731:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  801734:	8b 75 fc             	mov    -0x4(%ebp),%esi
  801737:	89 ec                	mov    %ebp,%esp
  801739:	5d                   	pop    %ebp
  80173a:	c3                   	ret    

0080173b <close_all>:
		return fd_close(fd, 1);
}

void
close_all(void)
{
  80173b:	55                   	push   %ebp
  80173c:	89 e5                	mov    %esp,%ebp
  80173e:	53                   	push   %ebx
  80173f:	83 ec 14             	sub    $0x14,%esp
  801742:	bb 00 00 00 00       	mov    $0x0,%ebx
	int i;
	for (i = 0; i < MAXFD; i++)
		close(i);
  801747:	89 1c 24             	mov    %ebx,(%esp)
  80174a:	e8 6f ff ff ff       	call   8016be <close>

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  80174f:	83 c3 01             	add    $0x1,%ebx
  801752:	83 fb 20             	cmp    $0x20,%ebx
  801755:	75 f0                	jne    801747 <close_all+0xc>
		close(i);
}
  801757:	83 c4 14             	add    $0x14,%esp
  80175a:	5b                   	pop    %ebx
  80175b:	5d                   	pop    %ebp
  80175c:	c3                   	ret    

0080175d <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  80175d:	55                   	push   %ebp
  80175e:	89 e5                	mov    %esp,%ebp
  801760:	83 ec 58             	sub    $0x58,%esp
  801763:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  801766:	89 75 f8             	mov    %esi,-0x8(%ebp)
  801769:	89 7d fc             	mov    %edi,-0x4(%ebp)
  80176c:	8b 7d 0c             	mov    0xc(%ebp),%edi
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  80176f:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  801772:	89 44 24 04          	mov    %eax,0x4(%esp)
  801776:	8b 45 08             	mov    0x8(%ebp),%eax
  801779:	89 04 24             	mov    %eax,(%esp)
  80177c:	e8 7c fb ff ff       	call   8012fd <fd_lookup>
  801781:	89 c3                	mov    %eax,%ebx
  801783:	85 c0                	test   %eax,%eax
  801785:	0f 88 e0 00 00 00    	js     80186b <dup+0x10e>
		return r;
	close(newfdnum);
  80178b:	89 3c 24             	mov    %edi,(%esp)
  80178e:	e8 2b ff ff ff       	call   8016be <close>

	newfd = INDEX2FD(newfdnum);
  801793:	8d b7 00 00 0d 00    	lea    0xd0000(%edi),%esi
  801799:	c1 e6 0c             	shl    $0xc,%esi
	ova = fd2data(oldfd);
  80179c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80179f:	89 04 24             	mov    %eax,(%esp)
  8017a2:	e8 c9 fa ff ff       	call   801270 <fd2data>
  8017a7:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  8017a9:	89 34 24             	mov    %esi,(%esp)
  8017ac:	e8 bf fa ff ff       	call   801270 <fd2data>
  8017b1:	89 45 d4             	mov    %eax,-0x2c(%ebp)

	if ((vpd[PDX(ova)] & PTE_P) && (vpt[VPN(ova)] & PTE_P))
  8017b4:	89 da                	mov    %ebx,%edx
  8017b6:	89 d8                	mov    %ebx,%eax
  8017b8:	c1 e8 16             	shr    $0x16,%eax
  8017bb:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  8017c2:	a8 01                	test   $0x1,%al
  8017c4:	74 43                	je     801809 <dup+0xac>
  8017c6:	c1 ea 0c             	shr    $0xc,%edx
  8017c9:	8b 04 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%eax
  8017d0:	a8 01                	test   $0x1,%al
  8017d2:	74 35                	je     801809 <dup+0xac>
		if ((r = sys_page_map(0, ova, 0, nva, vpt[VPN(ova)] & PTE_USER)) < 0)
  8017d4:	8b 04 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%eax
  8017db:	25 07 0e 00 00       	and    $0xe07,%eax
  8017e0:	89 44 24 10          	mov    %eax,0x10(%esp)
  8017e4:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8017e7:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8017eb:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  8017f2:	00 
  8017f3:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8017f7:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8017fe:	e8 da f8 ff ff       	call   8010dd <sys_page_map>
  801803:	89 c3                	mov    %eax,%ebx
  801805:	85 c0                	test   %eax,%eax
  801807:	78 3f                	js     801848 <dup+0xeb>
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, vpt[VPN(oldfd)] & PTE_USER)) < 0)
  801809:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80180c:	89 c2                	mov    %eax,%edx
  80180e:	c1 ea 0c             	shr    $0xc,%edx
  801811:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801818:	81 e2 07 0e 00 00    	and    $0xe07,%edx
  80181e:	89 54 24 10          	mov    %edx,0x10(%esp)
  801822:	89 74 24 0c          	mov    %esi,0xc(%esp)
  801826:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  80182d:	00 
  80182e:	89 44 24 04          	mov    %eax,0x4(%esp)
  801832:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801839:	e8 9f f8 ff ff       	call   8010dd <sys_page_map>
  80183e:	89 c3                	mov    %eax,%ebx
  801840:	85 c0                	test   %eax,%eax
  801842:	78 04                	js     801848 <dup+0xeb>
  801844:	89 fb                	mov    %edi,%ebx
  801846:	eb 23                	jmp    80186b <dup+0x10e>
		goto err;

	return newfdnum;

err:
	sys_page_unmap(0, newfd);
  801848:	89 74 24 04          	mov    %esi,0x4(%esp)
  80184c:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801853:	e8 27 f8 ff ff       	call   80107f <sys_page_unmap>
	sys_page_unmap(0, nva);
  801858:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80185b:	89 44 24 04          	mov    %eax,0x4(%esp)
  80185f:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801866:	e8 14 f8 ff ff       	call   80107f <sys_page_unmap>
	return r;
}
  80186b:	89 d8                	mov    %ebx,%eax
  80186d:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  801870:	8b 75 f8             	mov    -0x8(%ebp),%esi
  801873:	8b 7d fc             	mov    -0x4(%ebp),%edi
  801876:	89 ec                	mov    %ebp,%esp
  801878:	5d                   	pop    %ebp
  801879:	c3                   	ret    
	...

0080187c <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  80187c:	55                   	push   %ebp
  80187d:	89 e5                	mov    %esp,%ebp
  80187f:	53                   	push   %ebx
  801880:	83 ec 14             	sub    $0x14,%esp
  801883:	89 d3                	mov    %edx,%ebx
	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", env->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(envs[1].env_id, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  801885:	8b 15 c8 00 c0 ee    	mov    0xeec000c8,%edx
  80188b:	c7 44 24 0c 07 00 00 	movl   $0x7,0xc(%esp)
  801892:	00 
  801893:	c7 44 24 08 00 40 80 	movl   $0x804000,0x8(%esp)
  80189a:	00 
  80189b:	89 44 24 04          	mov    %eax,0x4(%esp)
  80189f:	89 14 24             	mov    %edx,(%esp)
  8018a2:	e8 f9 12 00 00       	call   802ba0 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  8018a7:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  8018ae:	00 
  8018af:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8018b3:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8018ba:	e8 47 13 00 00       	call   802c06 <ipc_recv>
}
  8018bf:	83 c4 14             	add    $0x14,%esp
  8018c2:	5b                   	pop    %ebx
  8018c3:	5d                   	pop    %ebp
  8018c4:	c3                   	ret    

008018c5 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  8018c5:	55                   	push   %ebp
  8018c6:	89 e5                	mov    %esp,%ebp
  8018c8:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  8018cb:	8b 45 08             	mov    0x8(%ebp),%eax
  8018ce:	8b 40 0c             	mov    0xc(%eax),%eax
  8018d1:	a3 00 40 80 00       	mov    %eax,0x804000
	fsipcbuf.set_size.req_size = newsize;
  8018d6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8018d9:	a3 04 40 80 00       	mov    %eax,0x804004
	return fsipc(FSREQ_SET_SIZE, NULL);
  8018de:	ba 00 00 00 00       	mov    $0x0,%edx
  8018e3:	b8 02 00 00 00       	mov    $0x2,%eax
  8018e8:	e8 8f ff ff ff       	call   80187c <fsipc>
}
  8018ed:	c9                   	leave  
  8018ee:	c3                   	ret    

008018ef <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  8018ef:	55                   	push   %ebp
  8018f0:	89 e5                	mov    %esp,%ebp
  8018f2:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  8018f5:	8b 45 08             	mov    0x8(%ebp),%eax
  8018f8:	8b 40 0c             	mov    0xc(%eax),%eax
  8018fb:	a3 00 40 80 00       	mov    %eax,0x804000
	return fsipc(FSREQ_FLUSH, NULL);
  801900:	ba 00 00 00 00       	mov    $0x0,%edx
  801905:	b8 06 00 00 00       	mov    $0x6,%eax
  80190a:	e8 6d ff ff ff       	call   80187c <fsipc>
}
  80190f:	c9                   	leave  
  801910:	c3                   	ret    

00801911 <sync>:
}

// Synchronize disk with buffer cache
int
sync(void)
{
  801911:	55                   	push   %ebp
  801912:	89 e5                	mov    %esp,%ebp
  801914:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  801917:	ba 00 00 00 00       	mov    $0x0,%edx
  80191c:	b8 08 00 00 00       	mov    $0x8,%eax
  801921:	e8 56 ff ff ff       	call   80187c <fsipc>
}
  801926:	c9                   	leave  
  801927:	c3                   	ret    

00801928 <devfile_stat>:
	return fsipc(FSREQ_WRITE, NULL);	
}

static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  801928:	55                   	push   %ebp
  801929:	89 e5                	mov    %esp,%ebp
  80192b:	53                   	push   %ebx
  80192c:	83 ec 14             	sub    $0x14,%esp
  80192f:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  801932:	8b 45 08             	mov    0x8(%ebp),%eax
  801935:	8b 40 0c             	mov    0xc(%eax),%eax
  801938:	a3 00 40 80 00       	mov    %eax,0x804000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  80193d:	ba 00 00 00 00       	mov    $0x0,%edx
  801942:	b8 05 00 00 00       	mov    $0x5,%eax
  801947:	e8 30 ff ff ff       	call   80187c <fsipc>
  80194c:	85 c0                	test   %eax,%eax
  80194e:	78 2b                	js     80197b <devfile_stat+0x53>
		return r;
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  801950:	c7 44 24 04 00 40 80 	movl   $0x804000,0x4(%esp)
  801957:	00 
  801958:	89 1c 24             	mov    %ebx,(%esp)
  80195b:	e8 ea ef ff ff       	call   80094a <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  801960:	a1 80 40 80 00       	mov    0x804080,%eax
  801965:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  80196b:	a1 84 40 80 00       	mov    0x804084,%eax
  801970:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
  801976:	b8 00 00 00 00       	mov    $0x0,%eax
	return 0;
}
  80197b:	83 c4 14             	add    $0x14,%esp
  80197e:	5b                   	pop    %ebx
  80197f:	5d                   	pop    %ebp
  801980:	c3                   	ret    

00801981 <devfile_write>:
// Returns:
//	 The number of bytes successfully written.
//	 < 0 on error.
static ssize_t
devfile_write(struct Fd *fd, const void *buf, size_t n)
{
  801981:	55                   	push   %ebp
  801982:	89 e5                	mov    %esp,%ebp
  801984:	83 ec 18             	sub    $0x18,%esp
  801987:	8b 45 10             	mov    0x10(%ebp),%eax
  80198a:	3d f8 0f 00 00       	cmp    $0xff8,%eax
  80198f:	76 05                	jbe    801996 <devfile_write+0x15>
  801991:	b8 f8 0f 00 00       	mov    $0xff8,%eax
	// LAB 5: Your code here
	//panic("devfile_write not implemented");
	
	if (n > (PGSIZE - (sizeof(int) + sizeof(size_t))))
		n = PGSIZE - (sizeof(int) + sizeof(size_t));
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  801996:	8b 55 08             	mov    0x8(%ebp),%edx
  801999:	8b 52 0c             	mov    0xc(%edx),%edx
  80199c:	89 15 00 40 80 00    	mov    %edx,0x804000
	fsipcbuf.write.req_n = n;
  8019a2:	a3 04 40 80 00       	mov    %eax,0x804004
	memmove (fsipcbuf.write.req_buf, (char*)buf, n);	
  8019a7:	89 44 24 08          	mov    %eax,0x8(%esp)
  8019ab:	8b 45 0c             	mov    0xc(%ebp),%eax
  8019ae:	89 44 24 04          	mov    %eax,0x4(%esp)
  8019b2:	c7 04 24 08 40 80 00 	movl   $0x804008,(%esp)
  8019b9:	e8 47 f1 ff ff       	call   800b05 <memmove>
	return fsipc(FSREQ_WRITE, NULL);	
  8019be:	ba 00 00 00 00       	mov    $0x0,%edx
  8019c3:	b8 04 00 00 00       	mov    $0x4,%eax
  8019c8:	e8 af fe ff ff       	call   80187c <fsipc>
}
  8019cd:	c9                   	leave  
  8019ce:	c3                   	ret    

008019cf <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  8019cf:	55                   	push   %ebp
  8019d0:	89 e5                	mov    %esp,%ebp
  8019d2:	53                   	push   %ebx
  8019d3:	83 ec 14             	sub    $0x14,%esp
	// system server.
	// LAB 5: Your code here
	
	//panic("devfile_read not implemented");
	int r;
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  8019d6:	8b 45 08             	mov    0x8(%ebp),%eax
  8019d9:	8b 40 0c             	mov    0xc(%eax),%eax
  8019dc:	a3 00 40 80 00       	mov    %eax,0x804000
	fsipcbuf.read.req_n = n;
  8019e1:	8b 45 10             	mov    0x10(%ebp),%eax
  8019e4:	a3 04 40 80 00       	mov    %eax,0x804004
	if ((r = fsipc(FSREQ_READ, (void*)&fsipcbuf)) < 0)
  8019e9:	ba 00 40 80 00       	mov    $0x804000,%edx
  8019ee:	b8 03 00 00 00       	mov    $0x3,%eax
  8019f3:	e8 84 fe ff ff       	call   80187c <fsipc>
  8019f8:	89 c3                	mov    %eax,%ebx
  8019fa:	85 c0                	test   %eax,%eax
  8019fc:	78 17                	js     801a15 <devfile_read+0x46>
		return r;
	memmove((void*)buf, (void*)fsipcbuf.readRet.ret_buf, r);
  8019fe:	89 44 24 08          	mov    %eax,0x8(%esp)
  801a02:	c7 44 24 04 00 40 80 	movl   $0x804000,0x4(%esp)
  801a09:	00 
  801a0a:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a0d:	89 04 24             	mov    %eax,(%esp)
  801a10:	e8 f0 f0 ff ff       	call   800b05 <memmove>
	return r;
}
  801a15:	89 d8                	mov    %ebx,%eax
  801a17:	83 c4 14             	add    $0x14,%esp
  801a1a:	5b                   	pop    %ebx
  801a1b:	5d                   	pop    %ebp
  801a1c:	c3                   	ret    

00801a1d <remove>:
}

// Delete a file
int
remove(const char *path)
{
  801a1d:	55                   	push   %ebp
  801a1e:	89 e5                	mov    %esp,%ebp
  801a20:	53                   	push   %ebx
  801a21:	83 ec 14             	sub    $0x14,%esp
  801a24:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (strlen(path) >= MAXPATHLEN)
  801a27:	89 1c 24             	mov    %ebx,(%esp)
  801a2a:	e8 d1 ee ff ff       	call   800900 <strlen>
  801a2f:	89 c2                	mov    %eax,%edx
  801a31:	b8 f4 ff ff ff       	mov    $0xfffffff4,%eax
  801a36:	81 fa ff 03 00 00    	cmp    $0x3ff,%edx
  801a3c:	7f 1f                	jg     801a5d <remove+0x40>
		return -E_BAD_PATH;
	strcpy(fsipcbuf.remove.req_path, path);
  801a3e:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801a42:	c7 04 24 00 40 80 00 	movl   $0x804000,(%esp)
  801a49:	e8 fc ee ff ff       	call   80094a <strcpy>
	return fsipc(FSREQ_REMOVE, NULL);
  801a4e:	ba 00 00 00 00       	mov    $0x0,%edx
  801a53:	b8 07 00 00 00       	mov    $0x7,%eax
  801a58:	e8 1f fe ff ff       	call   80187c <fsipc>
}
  801a5d:	83 c4 14             	add    $0x14,%esp
  801a60:	5b                   	pop    %ebx
  801a61:	5d                   	pop    %ebp
  801a62:	c3                   	ret    

00801a63 <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  801a63:	55                   	push   %ebp
  801a64:	89 e5                	mov    %esp,%ebp
  801a66:	83 ec 28             	sub    $0x28,%esp
  801a69:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  801a6c:	89 75 fc             	mov    %esi,-0x4(%ebp)
  801a6f:	8b 75 08             	mov    0x8(%ebp),%esi
	// file descriptor.

	// LAB 5: Your code here.
	// Code added by Swastika / Sandeep
	
	if (strlen(path) >= MAXPATHLEN)
  801a72:	89 34 24             	mov    %esi,(%esp)
  801a75:	e8 86 ee ff ff       	call   800900 <strlen>
  801a7a:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  801a7f:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  801a84:	7f 5e                	jg     801ae4 <open+0x81>
		return -E_BAD_PATH;
	struct Fd * fd;
	int  r;
	if ((r = fd_alloc(&fd)) < 0)
  801a86:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801a89:	89 04 24             	mov    %eax,(%esp)
  801a8c:	e8 fa f7 ff ff       	call   80128b <fd_alloc>
  801a91:	89 c3                	mov    %eax,%ebx
  801a93:	85 c0                	test   %eax,%eax
  801a95:	78 4d                	js     801ae4 <open+0x81>
		return r;
	strcpy (fsipcbuf.open.req_path, path);
  801a97:	89 74 24 04          	mov    %esi,0x4(%esp)
  801a9b:	c7 04 24 00 40 80 00 	movl   $0x804000,(%esp)
  801aa2:	e8 a3 ee ff ff       	call   80094a <strcpy>
	fsipcbuf.open.req_omode = mode;	
  801aa7:	8b 45 0c             	mov    0xc(%ebp),%eax
  801aaa:	a3 00 44 80 00       	mov    %eax,0x804400
	if ((r = fsipc(FSREQ_OPEN,(void*)fd)) < 0)
  801aaf:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801ab2:	b8 01 00 00 00       	mov    $0x1,%eax
  801ab7:	e8 c0 fd ff ff       	call   80187c <fsipc>
  801abc:	89 c3                	mov    %eax,%ebx
  801abe:	85 c0                	test   %eax,%eax
  801ac0:	79 15                	jns    801ad7 <open+0x74>
	{
		fd_close(fd,0);
  801ac2:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  801ac9:	00 
  801aca:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801acd:	89 04 24             	mov    %eax,(%esp)
  801ad0:	e8 6a fb ff ff       	call   80163f <fd_close>
		return r; 
  801ad5:	eb 0d                	jmp    801ae4 <open+0x81>
	}
	return fd2num(fd);
  801ad7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ada:	89 04 24             	mov    %eax,(%esp)
  801add:	e8 7e f7 ff ff       	call   801260 <fd2num>
  801ae2:	89 c3                	mov    %eax,%ebx
	//panic("open not implemented");
}
  801ae4:	89 d8                	mov    %ebx,%eax
  801ae6:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  801ae9:	8b 75 fc             	mov    -0x4(%ebp),%esi
  801aec:	89 ec                	mov    %ebp,%esp
  801aee:	5d                   	pop    %ebp
  801aef:	c3                   	ret    

00801af0 <spawn>:
// argv: pointer to null-terminated array of pointers to strings,
// 	 which will be passed to the child as its command-line arguments.
// Returns child envid on success, < 0 on failure.
int
spawn(const char *prog, const char **argv)
{
  801af0:	55                   	push   %ebp
  801af1:	89 e5                	mov    %esp,%ebp
  801af3:	57                   	push   %edi
  801af4:	56                   	push   %esi
  801af5:	53                   	push   %ebx
  801af6:	81 ec 9c 02 00 00    	sub    $0x29c,%esp
	//   - Call sys_env_set_trapframe(child, &child_tf) to set up the
	//     correct initial eip and esp values in the child.
	//
	//   - Start the child process running with sys_env_set_status().

	if ((r = open(prog, O_RDONLY)) < 0)
  801afc:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  801b03:	00 
  801b04:	8b 45 08             	mov    0x8(%ebp),%eax
  801b07:	89 04 24             	mov    %eax,(%esp)
  801b0a:	e8 54 ff ff ff       	call   801a63 <open>
  801b0f:	89 85 84 fd ff ff    	mov    %eax,-0x27c(%ebp)
  801b15:	89 c3                	mov    %eax,%ebx
  801b17:	85 c0                	test   %eax,%eax
  801b19:	0f 88 be 05 00 00    	js     8020dd <spawn+0x5ed>
	fd = r;

	// Read elf header
	elf = (struct Elf*) elf_buf;
	if (read(fd, elf_buf, sizeof(elf_buf)) != sizeof(elf_buf)
	    || elf->e_magic != ELF_MAGIC) {
  801b1f:	c7 44 24 08 00 02 00 	movl   $0x200,0x8(%esp)
  801b26:	00 
  801b27:	8d 85 e8 fd ff ff    	lea    -0x218(%ebp),%eax
  801b2d:	89 44 24 04          	mov    %eax,0x4(%esp)
  801b31:	89 1c 24             	mov    %ebx,(%esp)
  801b34:	e8 25 fa ff ff       	call   80155e <read>
		return r;
	fd = r;

	// Read elf header
	elf = (struct Elf*) elf_buf;
	if (read(fd, elf_buf, sizeof(elf_buf)) != sizeof(elf_buf)
  801b39:	3d 00 02 00 00       	cmp    $0x200,%eax
  801b3e:	75 0c                	jne    801b4c <spawn+0x5c>
	    || elf->e_magic != ELF_MAGIC) {
  801b40:	81 bd e8 fd ff ff 7f 	cmpl   $0x464c457f,-0x218(%ebp)
  801b47:	45 4c 46 
  801b4a:	74 36                	je     801b82 <spawn+0x92>
		close(fd);
  801b4c:	8b 85 84 fd ff ff    	mov    -0x27c(%ebp),%eax
  801b52:	89 04 24             	mov    %eax,(%esp)
  801b55:	e8 64 fb ff ff       	call   8016be <close>
		cprintf("elf magic %08x want %08x\n", elf->e_magic, ELF_MAGIC);
  801b5a:	c7 44 24 08 7f 45 4c 	movl   $0x464c457f,0x8(%esp)
  801b61:	46 
  801b62:	8b 85 e8 fd ff ff    	mov    -0x218(%ebp),%eax
  801b68:	89 44 24 04          	mov    %eax,0x4(%esp)
  801b6c:	c7 04 24 fc 33 80 00 	movl   $0x8033fc,(%esp)
  801b73:	e8 15 e7 ff ff       	call   80028d <cprintf>
  801b78:	bb f2 ff ff ff       	mov    $0xfffffff2,%ebx
		return -E_NOT_EXEC;
  801b7d:	e9 5b 05 00 00       	jmp    8020dd <spawn+0x5ed>
static __inline envid_t sys_exofork(void) __attribute__((always_inline));
static __inline envid_t
sys_exofork(void)
{
	envid_t ret;
	__asm __volatile("int %2"
  801b82:	ba 07 00 00 00       	mov    $0x7,%edx
  801b87:	89 d0                	mov    %edx,%eax
  801b89:	cd 30                	int    $0x30
  801b8b:	89 85 8c fd ff ff    	mov    %eax,-0x274(%ebp)
	}

	// Create new child environment
	if ((r = sys_exofork()) < 0)
  801b91:	85 c0                	test   %eax,%eax
  801b93:	0f 88 3e 05 00 00    	js     8020d7 <spawn+0x5e7>
		return r;
	child = r;

	// Set up trap frame, including initial stack.
	child_tf = envs[ENVX(child)].env_tf;
  801b99:	89 c6                	mov    %eax,%esi
  801b9b:	81 e6 ff 03 00 00    	and    $0x3ff,%esi
  801ba1:	6b f6 7c             	imul   $0x7c,%esi,%esi
  801ba4:	8d bd a4 fd ff ff    	lea    -0x25c(%ebp),%edi
  801baa:	81 c6 00 00 c0 ee    	add    $0xeec00000,%esi
  801bb0:	b9 11 00 00 00       	mov    $0x11,%ecx
  801bb5:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
	child_tf.tf_eip = elf->e_entry;
  801bb7:	8b 85 00 fe ff ff    	mov    -0x200(%ebp),%eax
  801bbd:	89 85 d4 fd ff ff    	mov    %eax,-0x22c(%ebp)
	uintptr_t *argv_store;

	// Count the number of arguments (argc)
	// and the total amount of space needed for strings (string_size).
	string_size = 0;
	for (argc = 0; argv[argc] != 0; argc++)
  801bc3:	8b 55 0c             	mov    0xc(%ebp),%edx
  801bc6:	8b 02                	mov    (%edx),%eax
  801bc8:	bb 00 00 00 00       	mov    $0x0,%ebx
  801bcd:	be 00 00 00 00       	mov    $0x0,%esi
  801bd2:	85 c0                	test   %eax,%eax
  801bd4:	75 16                	jne    801bec <spawn+0xfc>
  801bd6:	c7 85 7c fd ff ff 00 	movl   $0x0,-0x284(%ebp)
  801bdd:	00 00 00 
  801be0:	c7 85 78 fd ff ff 00 	movl   $0x0,-0x288(%ebp)
  801be7:	00 00 00 
  801bea:	eb 2c                	jmp    801c18 <spawn+0x128>
  801bec:	8b 7d 0c             	mov    0xc(%ebp),%edi
		string_size += strlen(argv[argc]) + 1;
  801bef:	89 04 24             	mov    %eax,(%esp)
  801bf2:	e8 09 ed ff ff       	call   800900 <strlen>
  801bf7:	8d 5c 18 01          	lea    0x1(%eax,%ebx,1),%ebx
	uintptr_t *argv_store;

	// Count the number of arguments (argc)
	// and the total amount of space needed for strings (string_size).
	string_size = 0;
	for (argc = 0; argv[argc] != 0; argc++)
  801bfb:	83 c6 01             	add    $0x1,%esi
  801bfe:	8d 14 b5 00 00 00 00 	lea    0x0(,%esi,4),%edx
  801c05:	8b 04 b7             	mov    (%edi,%esi,4),%eax
  801c08:	85 c0                	test   %eax,%eax
  801c0a:	75 e3                	jne    801bef <spawn+0xff>
  801c0c:	89 95 7c fd ff ff    	mov    %edx,-0x284(%ebp)
  801c12:	89 b5 78 fd ff ff    	mov    %esi,-0x288(%ebp)
	// Determine where to place the strings and the argv array.
	// Set up pointers into the temporary page 'UTEMP'; we'll map a page
	// there later, then remap that page into the child environment
	// at (USTACKTOP - PGSIZE).
	// strings is the topmost thing on the stack.
	string_store = (char*) UTEMP + PGSIZE - string_size;
  801c18:	f7 db                	neg    %ebx
  801c1a:	8d bb 00 10 40 00    	lea    0x401000(%ebx),%edi
	// argv is below that.  There's one argument pointer per argument, plus
	// a null pointer.
	argv_store = (uintptr_t*) (ROUNDDOWN(string_store, 4) - 4 * (argc + 1));
  801c20:	89 fa                	mov    %edi,%edx
  801c22:	83 e2 fc             	and    $0xfffffffc,%edx
  801c25:	89 f0                	mov    %esi,%eax
  801c27:	f7 d0                	not    %eax
  801c29:	8d 04 82             	lea    (%edx,%eax,4),%eax
  801c2c:	89 85 94 fd ff ff    	mov    %eax,-0x26c(%ebp)
	
	// Make sure that argv, strings, and the 2 words that hold 'argc'
	// and 'argv' themselves will all fit in a single stack page.
	if ((void*) (argv_store - 2) < (void*) UTEMP)
  801c32:	83 e8 08             	sub    $0x8,%eax
  801c35:	89 85 80 fd ff ff    	mov    %eax,-0x280(%ebp)
	return child;

error:
	sys_env_destroy(child);
	close(fd);
	return r;
  801c3b:	bb fc ff ff ff       	mov    $0xfffffffc,%ebx
	// a null pointer.
	argv_store = (uintptr_t*) (ROUNDDOWN(string_store, 4) - 4 * (argc + 1));
	
	// Make sure that argv, strings, and the 2 words that hold 'argc'
	// and 'argv' themselves will all fit in a single stack page.
	if ((void*) (argv_store - 2) < (void*) UTEMP)
  801c40:	3d ff ff 3f 00       	cmp    $0x3fffff,%eax
  801c45:	0f 86 92 04 00 00    	jbe    8020dd <spawn+0x5ed>
		return -E_NO_MEM;

	// Allocate the single stack page at UTEMP.
	if ((r = sys_page_alloc(0, (void*) UTEMP, PTE_P|PTE_U|PTE_W)) < 0)
  801c4b:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  801c52:	00 
  801c53:	c7 44 24 04 00 00 40 	movl   $0x400000,0x4(%esp)
  801c5a:	00 
  801c5b:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801c62:	e8 d4 f4 ff ff       	call   80113b <sys_page_alloc>
  801c67:	89 c3                	mov    %eax,%ebx
  801c69:	85 c0                	test   %eax,%eax
  801c6b:	0f 88 6c 04 00 00    	js     8020dd <spawn+0x5ed>
	//	  (Again, argv should use an address valid in the child's
	//	  environment.)
	//
	//	* Set *init_esp to the initial stack pointer for the child,
	//	  (Again, use an address valid in the child's environment.)
	for (i = 0; i < argc; i++) {
  801c71:	85 f6                	test   %esi,%esi
  801c73:	7e 46                	jle    801cbb <spawn+0x1cb>
  801c75:	bb 00 00 00 00       	mov    $0x0,%ebx
  801c7a:	89 b5 88 fd ff ff    	mov    %esi,-0x278(%ebp)
  801c80:	8b 75 0c             	mov    0xc(%ebp),%esi
		argv_store[i] = UTEMP2USTACK(string_store);
  801c83:	8d 87 00 d0 7f ee    	lea    -0x11803000(%edi),%eax
  801c89:	8b 95 94 fd ff ff    	mov    -0x26c(%ebp),%edx
  801c8f:	89 04 9a             	mov    %eax,(%edx,%ebx,4)
		strcpy(string_store, argv[i]);
  801c92:	8b 04 9e             	mov    (%esi,%ebx,4),%eax
  801c95:	89 44 24 04          	mov    %eax,0x4(%esp)
  801c99:	89 3c 24             	mov    %edi,(%esp)
  801c9c:	e8 a9 ec ff ff       	call   80094a <strcpy>
		string_store += strlen(argv[i]) + 1;
  801ca1:	8b 04 9e             	mov    (%esi,%ebx,4),%eax
  801ca4:	89 04 24             	mov    %eax,(%esp)
  801ca7:	e8 54 ec ff ff       	call   800900 <strlen>
  801cac:	8d 7c 07 01          	lea    0x1(%edi,%eax,1),%edi
	//	  (Again, argv should use an address valid in the child's
	//	  environment.)
	//
	//	* Set *init_esp to the initial stack pointer for the child,
	//	  (Again, use an address valid in the child's environment.)
	for (i = 0; i < argc; i++) {
  801cb0:	83 c3 01             	add    $0x1,%ebx
  801cb3:	3b 9d 88 fd ff ff    	cmp    -0x278(%ebp),%ebx
  801cb9:	7c c8                	jl     801c83 <spawn+0x193>
		argv_store[i] = UTEMP2USTACK(string_store);
		strcpy(string_store, argv[i]);
		string_store += strlen(argv[i]) + 1;
	}
	argv_store[argc] = 0;
  801cbb:	8b 95 94 fd ff ff    	mov    -0x26c(%ebp),%edx
  801cc1:	8b 85 7c fd ff ff    	mov    -0x284(%ebp),%eax
  801cc7:	c7 04 02 00 00 00 00 	movl   $0x0,(%edx,%eax,1)
	assert(string_store == (char*)UTEMP + PGSIZE);
  801cce:	81 ff 00 10 40 00    	cmp    $0x401000,%edi
  801cd4:	74 24                	je     801cfa <spawn+0x20a>
  801cd6:	c7 44 24 0c 9c 34 80 	movl   $0x80349c,0xc(%esp)
  801cdd:	00 
  801cde:	c7 44 24 08 16 34 80 	movl   $0x803416,0x8(%esp)
  801ce5:	00 
  801ce6:	c7 44 24 04 d9 00 00 	movl   $0xd9,0x4(%esp)
  801ced:	00 
  801cee:	c7 04 24 2b 34 80 00 	movl   $0x80342b,(%esp)
  801cf5:	e8 ce e4 ff ff       	call   8001c8 <_panic>

	argv_store[-1] = UTEMP2USTACK(argv_store);
  801cfa:	8b 85 94 fd ff ff    	mov    -0x26c(%ebp),%eax
  801d00:	2d 00 30 80 11       	sub    $0x11803000,%eax
  801d05:	8b 95 94 fd ff ff    	mov    -0x26c(%ebp),%edx
  801d0b:	89 42 fc             	mov    %eax,-0x4(%edx)
	argv_store[-2] = argc;
  801d0e:	8b 95 78 fd ff ff    	mov    -0x288(%ebp),%edx
  801d14:	8b 85 80 fd ff ff    	mov    -0x280(%ebp),%eax
  801d1a:	89 10                	mov    %edx,(%eax)

	*init_esp = UTEMP2USTACK(&argv_store[-2]);
  801d1c:	8b 85 94 fd ff ff    	mov    -0x26c(%ebp),%eax
  801d22:	2d 08 30 80 11       	sub    $0x11803008,%eax
  801d27:	89 85 e0 fd ff ff    	mov    %eax,-0x220(%ebp)

	// After completing the stack, map it into the child's address space
	// and unmap it from ours!
	if ((r = sys_page_map(0, UTEMP, child, (void*) (USTACKTOP - PGSIZE), PTE_P | PTE_U | PTE_W)) < 0)
  801d2d:	c7 44 24 10 07 00 00 	movl   $0x7,0x10(%esp)
  801d34:	00 
  801d35:	c7 44 24 0c 00 d0 bf 	movl   $0xeebfd000,0xc(%esp)
  801d3c:	ee 
  801d3d:	8b 85 8c fd ff ff    	mov    -0x274(%ebp),%eax
  801d43:	89 44 24 08          	mov    %eax,0x8(%esp)
  801d47:	c7 44 24 04 00 00 40 	movl   $0x400000,0x4(%esp)
  801d4e:	00 
  801d4f:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801d56:	e8 82 f3 ff ff       	call   8010dd <sys_page_map>
  801d5b:	89 c3                	mov    %eax,%ebx
  801d5d:	85 c0                	test   %eax,%eax
  801d5f:	78 1a                	js     801d7b <spawn+0x28b>
		goto error;
	if ((r = sys_page_unmap(0, UTEMP)) < 0)
  801d61:	c7 44 24 04 00 00 40 	movl   $0x400000,0x4(%esp)
  801d68:	00 
  801d69:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801d70:	e8 0a f3 ff ff       	call   80107f <sys_page_unmap>
  801d75:	89 c3                	mov    %eax,%ebx
  801d77:	85 c0                	test   %eax,%eax
  801d79:	79 19                	jns    801d94 <spawn+0x2a4>
		goto error;

	return 0;

error:
	sys_page_unmap(0, UTEMP);
  801d7b:	c7 44 24 04 00 00 40 	movl   $0x400000,0x4(%esp)
  801d82:	00 
  801d83:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801d8a:	e8 f0 f2 ff ff       	call   80107f <sys_page_unmap>
  801d8f:	e9 49 03 00 00       	jmp    8020dd <spawn+0x5ed>

	if ((r = init_stack(child, argv, &child_tf.tf_esp)) < 0)
		return r;

	// Set up program segments as defined in ELF header.
	ph = (struct Proghdr*) (elf_buf + elf->e_phoff);
  801d94:	8b 85 04 fe ff ff    	mov    -0x1fc(%ebp),%eax
	for (i = 0; i < elf->e_phnum; i++, ph++) {
  801d9a:	66 83 bd 14 fe ff ff 	cmpw   $0x0,-0x1ec(%ebp)
  801da1:	00 
  801da2:	0f 84 e3 01 00 00    	je     801f8b <spawn+0x49b>

	if ((r = init_stack(child, argv, &child_tf.tf_esp)) < 0)
		return r;

	// Set up program segments as defined in ELF header.
	ph = (struct Proghdr*) (elf_buf + elf->e_phoff);
  801da8:	8d 84 05 e8 fd ff ff 	lea    -0x218(%ebp,%eax,1),%eax
  801daf:	89 85 80 fd ff ff    	mov    %eax,-0x280(%ebp)
  801db5:	c7 85 7c fd ff ff 00 	movl   $0x0,-0x284(%ebp)
  801dbc:	00 00 00 
	for (i = 0; i < elf->e_phnum; i++, ph++) {
		if (ph->p_type != ELF_PROG_LOAD)
  801dbf:	8b 95 80 fd ff ff    	mov    -0x280(%ebp),%edx
  801dc5:	83 3a 01             	cmpl   $0x1,(%edx)
  801dc8:	0f 85 9b 01 00 00    	jne    801f69 <spawn+0x479>
			continue;
		perm = PTE_P | PTE_U;
		if (ph->p_flags & ELF_PROG_FLAG_WRITE)
  801dce:	8b 42 18             	mov    0x18(%edx),%eax
  801dd1:	83 e0 02             	and    $0x2,%eax
  801dd4:	83 f8 01             	cmp    $0x1,%eax
  801dd7:	19 c0                	sbb    %eax,%eax
  801dd9:	83 e0 fe             	and    $0xfffffffe,%eax
  801ddc:	83 c0 07             	add    $0x7,%eax
  801ddf:	89 85 94 fd ff ff    	mov    %eax,-0x26c(%ebp)
			perm |= PTE_W;
		if ((r = map_segment(child, ph->p_va, ph->p_memsz, 
  801de5:	8b 52 04             	mov    0x4(%edx),%edx
  801de8:	89 95 78 fd ff ff    	mov    %edx,-0x288(%ebp)
  801dee:	8b 85 80 fd ff ff    	mov    -0x280(%ebp),%eax
  801df4:	8b 58 10             	mov    0x10(%eax),%ebx
  801df7:	8b 50 14             	mov    0x14(%eax),%edx
  801dfa:	89 95 88 fd ff ff    	mov    %edx,-0x278(%ebp)
  801e00:	8b 40 08             	mov    0x8(%eax),%eax
  801e03:	89 85 90 fd ff ff    	mov    %eax,-0x270(%ebp)
	int i, r;
	void *blk;

	//cprintf("map_segment %x+%x\n", va, memsz);

	if ((i = PGOFF(va))) {
  801e09:	25 ff 0f 00 00       	and    $0xfff,%eax
  801e0e:	74 16                	je     801e26 <spawn+0x336>
		va -= i;
  801e10:	29 85 90 fd ff ff    	sub    %eax,-0x270(%ebp)
		memsz += i;
  801e16:	01 c2                	add    %eax,%edx
  801e18:	89 95 88 fd ff ff    	mov    %edx,-0x278(%ebp)
		filesz += i;
  801e1e:	01 c3                	add    %eax,%ebx
		fileoffset -= i;
  801e20:	29 85 78 fd ff ff    	sub    %eax,-0x288(%ebp)
	}

	for (i = 0; i < memsz; i += PGSIZE) {
  801e26:	83 bd 88 fd ff ff 00 	cmpl   $0x0,-0x278(%ebp)
  801e2d:	0f 84 36 01 00 00    	je     801f69 <spawn+0x479>
  801e33:	bf 00 00 00 00       	mov    $0x0,%edi
  801e38:	be 00 00 00 00       	mov    $0x0,%esi
		if (i >= filesz) {
  801e3d:	39 fb                	cmp    %edi,%ebx
  801e3f:	77 31                	ja     801e72 <spawn+0x382>
			// allocate a blank page
			if ((r = sys_page_alloc(child, (void*) (va + i), perm)) < 0)
  801e41:	8b 95 94 fd ff ff    	mov    -0x26c(%ebp),%edx
  801e47:	89 54 24 08          	mov    %edx,0x8(%esp)
  801e4b:	03 bd 90 fd ff ff    	add    -0x270(%ebp),%edi
  801e51:	89 7c 24 04          	mov    %edi,0x4(%esp)
  801e55:	8b 85 8c fd ff ff    	mov    -0x274(%ebp),%eax
  801e5b:	89 04 24             	mov    %eax,(%esp)
  801e5e:	e8 d8 f2 ff ff       	call   80113b <sys_page_alloc>
  801e63:	85 c0                	test   %eax,%eax
  801e65:	0f 89 ea 00 00 00    	jns    801f55 <spawn+0x465>
  801e6b:	89 c3                	mov    %eax,%ebx
  801e6d:	e9 47 02 00 00       	jmp    8020b9 <spawn+0x5c9>
				return r;
		} else {
			// from file
			if ((r = sys_page_alloc(0, UTEMP, PTE_P|PTE_U|PTE_W)) < 0)
  801e72:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  801e79:	00 
  801e7a:	c7 44 24 04 00 00 40 	movl   $0x400000,0x4(%esp)
  801e81:	00 
  801e82:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801e89:	e8 ad f2 ff ff       	call   80113b <sys_page_alloc>
  801e8e:	85 c0                	test   %eax,%eax
  801e90:	0f 88 19 02 00 00    	js     8020af <spawn+0x5bf>
				return r;
			if ((r = seek(fd, fileoffset + i)) < 0)
  801e96:	8b 95 78 fd ff ff    	mov    -0x288(%ebp),%edx
  801e9c:	8d 04 16             	lea    (%esi,%edx,1),%eax
  801e9f:	89 44 24 04          	mov    %eax,0x4(%esp)
  801ea3:	8b 85 84 fd ff ff    	mov    -0x27c(%ebp),%eax
  801ea9:	89 04 24             	mov    %eax,(%esp)
  801eac:	e8 94 f4 ff ff       	call   801345 <seek>
  801eb1:	85 c0                	test   %eax,%eax
  801eb3:	0f 88 fa 01 00 00    	js     8020b3 <spawn+0x5c3>
				return r;
			if ((r = read(fd, UTEMP, MIN(PGSIZE, filesz-i))) < 0)
  801eb9:	89 d8                	mov    %ebx,%eax
  801ebb:	29 f8                	sub    %edi,%eax
  801ebd:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801ec2:	76 05                	jbe    801ec9 <spawn+0x3d9>
  801ec4:	b8 00 10 00 00       	mov    $0x1000,%eax
  801ec9:	89 44 24 08          	mov    %eax,0x8(%esp)
  801ecd:	c7 44 24 04 00 00 40 	movl   $0x400000,0x4(%esp)
  801ed4:	00 
  801ed5:	8b 95 84 fd ff ff    	mov    -0x27c(%ebp),%edx
  801edb:	89 14 24             	mov    %edx,(%esp)
  801ede:	e8 7b f6 ff ff       	call   80155e <read>
  801ee3:	85 c0                	test   %eax,%eax
  801ee5:	0f 88 cc 01 00 00    	js     8020b7 <spawn+0x5c7>
				return r;
			if ((r = sys_page_map(0, UTEMP, child, (void*) (va + i), perm)) < 0)
  801eeb:	8b 85 94 fd ff ff    	mov    -0x26c(%ebp),%eax
  801ef1:	89 44 24 10          	mov    %eax,0x10(%esp)
  801ef5:	03 bd 90 fd ff ff    	add    -0x270(%ebp),%edi
  801efb:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  801eff:	8b 95 8c fd ff ff    	mov    -0x274(%ebp),%edx
  801f05:	89 54 24 08          	mov    %edx,0x8(%esp)
  801f09:	c7 44 24 04 00 00 40 	movl   $0x400000,0x4(%esp)
  801f10:	00 
  801f11:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801f18:	e8 c0 f1 ff ff       	call   8010dd <sys_page_map>
  801f1d:	85 c0                	test   %eax,%eax
  801f1f:	79 20                	jns    801f41 <spawn+0x451>
				panic("spawn: sys_page_map data: %e", r);
  801f21:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801f25:	c7 44 24 08 37 34 80 	movl   $0x803437,0x8(%esp)
  801f2c:	00 
  801f2d:	c7 44 24 04 0c 01 00 	movl   $0x10c,0x4(%esp)
  801f34:	00 
  801f35:	c7 04 24 2b 34 80 00 	movl   $0x80342b,(%esp)
  801f3c:	e8 87 e2 ff ff       	call   8001c8 <_panic>
			sys_page_unmap(0, UTEMP);
  801f41:	c7 44 24 04 00 00 40 	movl   $0x400000,0x4(%esp)
  801f48:	00 
  801f49:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801f50:	e8 2a f1 ff ff       	call   80107f <sys_page_unmap>
		memsz += i;
		filesz += i;
		fileoffset -= i;
	}

	for (i = 0; i < memsz; i += PGSIZE) {
  801f55:	81 c6 00 10 00 00    	add    $0x1000,%esi
  801f5b:	89 f7                	mov    %esi,%edi
  801f5d:	39 b5 88 fd ff ff    	cmp    %esi,-0x278(%ebp)
  801f63:	0f 87 d4 fe ff ff    	ja     801e3d <spawn+0x34d>
	if ((r = init_stack(child, argv, &child_tf.tf_esp)) < 0)
		return r;

	// Set up program segments as defined in ELF header.
	ph = (struct Proghdr*) (elf_buf + elf->e_phoff);
	for (i = 0; i < elf->e_phnum; i++, ph++) {
  801f69:	83 85 7c fd ff ff 01 	addl   $0x1,-0x284(%ebp)
  801f70:	0f b7 85 14 fe ff ff 	movzwl -0x1ec(%ebp),%eax
  801f77:	3b 85 7c fd ff ff    	cmp    -0x284(%ebp),%eax
  801f7d:	7e 0c                	jle    801f8b <spawn+0x49b>
  801f7f:	83 85 80 fd ff ff 20 	addl   $0x20,-0x280(%ebp)
  801f86:	e9 34 fe ff ff       	jmp    801dbf <spawn+0x2cf>
			perm |= PTE_W;
		if ((r = map_segment(child, ph->p_va, ph->p_memsz, 
				     fd, ph->p_filesz, ph->p_offset, perm)) < 0)
			goto error;
	}
	close(fd);
  801f8b:	8b 85 84 fd ff ff    	mov    -0x27c(%ebp),%eax
  801f91:	89 04 24             	mov    %eax,(%esp)
  801f94:	e8 25 f7 ff ff       	call   8016be <close>
  801f99:	c7 85 94 fd ff ff 00 	movl   $0x0,-0x26c(%ebp)
  801fa0:	00 00 00 
	void * va;
	int r;
	
	for (pde_x = VPD(0); pde_x < VPD(UTOP); pde_x++)
	{
		if ((vpd[pde_x] & PTE_P) == PTE_P)
  801fa3:	8b 95 94 fd ff ff    	mov    -0x26c(%ebp),%edx
  801fa9:	8b 04 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%eax
  801fb0:	a8 01                	test   $0x1,%al
  801fb2:	74 65                	je     802019 <spawn+0x529>
		{
			for (pte_x = 0; pte_x < NPTENTRIES; pte_x++)
			{
				vpn = (pde_x << (PDXSHIFT - PTXSHIFT)) + pte_x;
  801fb4:	89 d7                	mov    %edx,%edi
  801fb6:	c1 e7 0a             	shl    $0xa,%edi
  801fb9:	89 d6                	mov    %edx,%esi
  801fbb:	c1 e6 16             	shl    $0x16,%esi
  801fbe:	bb 00 00 00 00       	mov    $0x0,%ebx
  801fc3:	8d 04 3b             	lea    (%ebx,%edi,1),%eax
				pte = vpt[vpn];
  801fc6:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
				if ((pte & PTE_P) && (pte & PTE_SHARE))
  801fcd:	89 c2                	mov    %eax,%edx
  801fcf:	81 e2 01 04 00 00    	and    $0x401,%edx
  801fd5:	81 fa 01 04 00 00    	cmp    $0x401,%edx
  801fdb:	75 2b                	jne    802008 <spawn+0x518>
				{
					va = (void*)(vpn * PGSIZE);
					r = sys_page_map(0, va, child, va, pte & PTE_USER);
  801fdd:	25 07 0e 00 00       	and    $0xe07,%eax
  801fe2:	89 44 24 10          	mov    %eax,0x10(%esp)
  801fe6:	89 74 24 0c          	mov    %esi,0xc(%esp)
  801fea:	8b 85 8c fd ff ff    	mov    -0x274(%ebp),%eax
  801ff0:	89 44 24 08          	mov    %eax,0x8(%esp)
  801ff4:	89 74 24 04          	mov    %esi,0x4(%esp)
  801ff8:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801fff:	e8 d9 f0 ff ff       	call   8010dd <sys_page_map>
					if (r < 0)
  802004:	85 c0                	test   %eax,%eax
  802006:	78 2d                	js     802035 <spawn+0x545>
	
	for (pde_x = VPD(0); pde_x < VPD(UTOP); pde_x++)
	{
		if ((vpd[pde_x] & PTE_P) == PTE_P)
		{
			for (pte_x = 0; pte_x < NPTENTRIES; pte_x++)
  802008:	83 c3 01             	add    $0x1,%ebx
  80200b:	81 c6 00 10 00 00    	add    $0x1000,%esi
  802011:	81 fb 00 04 00 00    	cmp    $0x400,%ebx
  802017:	75 aa                	jne    801fc3 <spawn+0x4d3>
	uint32_t pde_x, pte_x, vpn;
	pte_t pte;
	void * va;
	int r;
	
	for (pde_x = VPD(0); pde_x < VPD(UTOP); pde_x++)
  802019:	83 85 94 fd ff ff 01 	addl   $0x1,-0x26c(%ebp)
  802020:	81 bd 94 fd ff ff bb 	cmpl   $0x3bb,-0x26c(%ebp)
  802027:	03 00 00 
  80202a:	0f 85 73 ff ff ff    	jne    801fa3 <spawn+0x4b3>
  802030:	e9 b5 00 00 00       	jmp    8020ea <spawn+0x5fa>
	close(fd);
	fd = -1;

	// Copy shared library state.
	if ((r = copy_shared_pages(child)) < 0)
		panic("copy_shared_pages: %e", r);
  802035:	89 44 24 0c          	mov    %eax,0xc(%esp)
  802039:	c7 44 24 08 54 34 80 	movl   $0x803454,0x8(%esp)
  802040:	00 
  802041:	c7 44 24 04 82 00 00 	movl   $0x82,0x4(%esp)
  802048:	00 
  802049:	c7 04 24 2b 34 80 00 	movl   $0x80342b,(%esp)
  802050:	e8 73 e1 ff ff       	call   8001c8 <_panic>

	if ((r = sys_env_set_trapframe(child, &child_tf)) < 0)
		panic("sys_env_set_trapframe: %e", r);
  802055:	89 44 24 0c          	mov    %eax,0xc(%esp)
  802059:	c7 44 24 08 6a 34 80 	movl   $0x80346a,0x8(%esp)
  802060:	00 
  802061:	c7 44 24 04 85 00 00 	movl   $0x85,0x4(%esp)
  802068:	00 
  802069:	c7 04 24 2b 34 80 00 	movl   $0x80342b,(%esp)
  802070:	e8 53 e1 ff ff       	call   8001c8 <_panic>

	if ((r = sys_env_set_status(child, ENV_RUNNABLE)) < 0)
  802075:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  80207c:	00 
  80207d:	8b 95 8c fd ff ff    	mov    -0x274(%ebp),%edx
  802083:	89 14 24             	mov    %edx,(%esp)
  802086:	e8 96 ef ff ff       	call   801021 <sys_env_set_status>
  80208b:	85 c0                	test   %eax,%eax
  80208d:	79 48                	jns    8020d7 <spawn+0x5e7>
		panic("sys_env_set_status: %e", r);
  80208f:	89 44 24 0c          	mov    %eax,0xc(%esp)
  802093:	c7 44 24 08 84 34 80 	movl   $0x803484,0x8(%esp)
  80209a:	00 
  80209b:	c7 44 24 04 88 00 00 	movl   $0x88,0x4(%esp)
  8020a2:	00 
  8020a3:	c7 04 24 2b 34 80 00 	movl   $0x80342b,(%esp)
  8020aa:	e8 19 e1 ff ff       	call   8001c8 <_panic>
  8020af:	89 c3                	mov    %eax,%ebx
  8020b1:	eb 06                	jmp    8020b9 <spawn+0x5c9>
  8020b3:	89 c3                	mov    %eax,%ebx
  8020b5:	eb 02                	jmp    8020b9 <spawn+0x5c9>
  8020b7:	89 c3                	mov    %eax,%ebx

	return child;

error:
	sys_env_destroy(child);
  8020b9:	8b 85 8c fd ff ff    	mov    -0x274(%ebp),%eax
  8020bf:	89 04 24             	mov    %eax,(%esp)
  8020c2:	e8 3b f1 ff ff       	call   801202 <sys_env_destroy>
	close(fd);
  8020c7:	8b 95 84 fd ff ff    	mov    -0x27c(%ebp),%edx
  8020cd:	89 14 24             	mov    %edx,(%esp)
  8020d0:	e8 e9 f5 ff ff       	call   8016be <close>
	return r;
  8020d5:	eb 06                	jmp    8020dd <spawn+0x5ed>
  8020d7:	8b 9d 8c fd ff ff    	mov    -0x274(%ebp),%ebx
}
  8020dd:	89 d8                	mov    %ebx,%eax
  8020df:	81 c4 9c 02 00 00    	add    $0x29c,%esp
  8020e5:	5b                   	pop    %ebx
  8020e6:	5e                   	pop    %esi
  8020e7:	5f                   	pop    %edi
  8020e8:	5d                   	pop    %ebp
  8020e9:	c3                   	ret    

	// Copy shared library state.
	if ((r = copy_shared_pages(child)) < 0)
		panic("copy_shared_pages: %e", r);

	if ((r = sys_env_set_trapframe(child, &child_tf)) < 0)
  8020ea:	8d 85 a4 fd ff ff    	lea    -0x25c(%ebp),%eax
  8020f0:	89 44 24 04          	mov    %eax,0x4(%esp)
  8020f4:	8b 85 8c fd ff ff    	mov    -0x274(%ebp),%eax
  8020fa:	89 04 24             	mov    %eax,(%esp)
  8020fd:	e8 c1 ee ff ff       	call   800fc3 <sys_env_set_trapframe>
  802102:	85 c0                	test   %eax,%eax
  802104:	0f 89 6b ff ff ff    	jns    802075 <spawn+0x585>
  80210a:	e9 46 ff ff ff       	jmp    802055 <spawn+0x565>

0080210f <spawnl>:
}

// Spawn, taking command-line arguments array directly on the stack.
int
spawnl(const char *prog, const char *arg0, ...)
{
  80210f:	55                   	push   %ebp
  802110:	89 e5                	mov    %esp,%ebp
  802112:	83 ec 18             	sub    $0x18,%esp
	return spawn(prog, &arg0);
  802115:	8d 45 0c             	lea    0xc(%ebp),%eax
  802118:	89 44 24 04          	mov    %eax,0x4(%esp)
  80211c:	8b 45 08             	mov    0x8(%ebp),%eax
  80211f:	89 04 24             	mov    %eax,(%esp)
  802122:	e8 c9 f9 ff ff       	call   801af0 <spawn>
}
  802127:	c9                   	leave  
  802128:	c3                   	ret    
  802129:	00 00                	add    %al,(%eax)
  80212b:	00 00                	add    %al,(%eax)
  80212d:	00 00                	add    %al,(%eax)
	...

00802130 <devsock_stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  802130:	55                   	push   %ebp
  802131:	89 e5                	mov    %esp,%ebp
  802133:	83 ec 18             	sub    $0x18,%esp
	strcpy(stat->st_name, "<sock>");
  802136:	c7 44 24 04 c2 34 80 	movl   $0x8034c2,0x4(%esp)
  80213d:	00 
  80213e:	8b 45 0c             	mov    0xc(%ebp),%eax
  802141:	89 04 24             	mov    %eax,(%esp)
  802144:	e8 01 e8 ff ff       	call   80094a <strcpy>
	return 0;
}
  802149:	b8 00 00 00 00       	mov    $0x0,%eax
  80214e:	c9                   	leave  
  80214f:	c3                   	ret    

00802150 <devsock_close>:
	return nsipc_shutdown(r, how);
}

static int
devsock_close(struct Fd *fd)
{
  802150:	55                   	push   %ebp
  802151:	89 e5                	mov    %esp,%ebp
  802153:	83 ec 18             	sub    $0x18,%esp
	return nsipc_close(fd->fd_sock.sockid);
  802156:	8b 45 08             	mov    0x8(%ebp),%eax
  802159:	8b 40 0c             	mov    0xc(%eax),%eax
  80215c:	89 04 24             	mov    %eax,(%esp)
  80215f:	e8 9e 02 00 00       	call   802402 <nsipc_close>
}
  802164:	c9                   	leave  
  802165:	c3                   	ret    

00802166 <devsock_write>:
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
}

static ssize_t
devsock_write(struct Fd *fd, const void *buf, size_t n)
{
  802166:	55                   	push   %ebp
  802167:	89 e5                	mov    %esp,%ebp
  802169:	83 ec 18             	sub    $0x18,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  80216c:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  802173:	00 
  802174:	8b 45 10             	mov    0x10(%ebp),%eax
  802177:	89 44 24 08          	mov    %eax,0x8(%esp)
  80217b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80217e:	89 44 24 04          	mov    %eax,0x4(%esp)
  802182:	8b 45 08             	mov    0x8(%ebp),%eax
  802185:	8b 40 0c             	mov    0xc(%eax),%eax
  802188:	89 04 24             	mov    %eax,(%esp)
  80218b:	e8 ae 02 00 00       	call   80243e <nsipc_send>
}
  802190:	c9                   	leave  
  802191:	c3                   	ret    

00802192 <devsock_read>:
	return nsipc_listen(r, backlog);
}

static ssize_t
devsock_read(struct Fd *fd, void *buf, size_t n)
{
  802192:	55                   	push   %ebp
  802193:	89 e5                	mov    %esp,%ebp
  802195:	83 ec 18             	sub    $0x18,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  802198:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  80219f:	00 
  8021a0:	8b 45 10             	mov    0x10(%ebp),%eax
  8021a3:	89 44 24 08          	mov    %eax,0x8(%esp)
  8021a7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8021aa:	89 44 24 04          	mov    %eax,0x4(%esp)
  8021ae:	8b 45 08             	mov    0x8(%ebp),%eax
  8021b1:	8b 40 0c             	mov    0xc(%eax),%eax
  8021b4:	89 04 24             	mov    %eax,(%esp)
  8021b7:	e8 f5 02 00 00       	call   8024b1 <nsipc_recv>
}
  8021bc:	c9                   	leave  
  8021bd:	c3                   	ret    

008021be <alloc_sockfd>:
	return sfd->fd_sock.sockid;
}

static int
alloc_sockfd(int sockid)
{
  8021be:	55                   	push   %ebp
  8021bf:	89 e5                	mov    %esp,%ebp
  8021c1:	56                   	push   %esi
  8021c2:	53                   	push   %ebx
  8021c3:	83 ec 20             	sub    $0x20,%esp
  8021c6:	89 c6                	mov    %eax,%esi
	struct Fd *sfd;
	int r;

	if ((r = fd_alloc(&sfd)) < 0
  8021c8:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8021cb:	89 04 24             	mov    %eax,(%esp)
  8021ce:	e8 b8 f0 ff ff       	call   80128b <fd_alloc>
  8021d3:	89 c3                	mov    %eax,%ebx
  8021d5:	85 c0                	test   %eax,%eax
  8021d7:	78 21                	js     8021fa <alloc_sockfd+0x3c>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U)) < 0) {
  8021d9:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  8021e0:	00 
  8021e1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021e4:	89 44 24 04          	mov    %eax,0x4(%esp)
  8021e8:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8021ef:	e8 47 ef ff ff       	call   80113b <sys_page_alloc>
  8021f4:	89 c3                	mov    %eax,%ebx
alloc_sockfd(int sockid)
{
	struct Fd *sfd;
	int r;

	if ((r = fd_alloc(&sfd)) < 0
  8021f6:	85 c0                	test   %eax,%eax
  8021f8:	79 0a                	jns    802204 <alloc_sockfd+0x46>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U)) < 0) {
		nsipc_close(sockid);
  8021fa:	89 34 24             	mov    %esi,(%esp)
  8021fd:	e8 00 02 00 00       	call   802402 <nsipc_close>
		return r;
  802202:	eb 28                	jmp    80222c <alloc_sockfd+0x6e>
	}

	sfd->fd_dev_id = devsock.dev_id;
  802204:	8b 15 20 70 80 00    	mov    0x807020,%edx
  80220a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80220d:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  80220f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802212:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	sfd->fd_sock.sockid = sockid;
  802219:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80221c:	89 70 0c             	mov    %esi,0xc(%eax)
	return fd2num(sfd);
  80221f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802222:	89 04 24             	mov    %eax,(%esp)
  802225:	e8 36 f0 ff ff       	call   801260 <fd2num>
  80222a:	89 c3                	mov    %eax,%ebx
}
  80222c:	89 d8                	mov    %ebx,%eax
  80222e:	83 c4 20             	add    $0x20,%esp
  802231:	5b                   	pop    %ebx
  802232:	5e                   	pop    %esi
  802233:	5d                   	pop    %ebp
  802234:	c3                   	ret    

00802235 <socket>:
	return 0;
}

int
socket(int domain, int type, int protocol)
{
  802235:	55                   	push   %ebp
  802236:	89 e5                	mov    %esp,%ebp
  802238:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  80223b:	8b 45 10             	mov    0x10(%ebp),%eax
  80223e:	89 44 24 08          	mov    %eax,0x8(%esp)
  802242:	8b 45 0c             	mov    0xc(%ebp),%eax
  802245:	89 44 24 04          	mov    %eax,0x4(%esp)
  802249:	8b 45 08             	mov    0x8(%ebp),%eax
  80224c:	89 04 24             	mov    %eax,(%esp)
  80224f:	e8 62 01 00 00       	call   8023b6 <nsipc_socket>
  802254:	85 c0                	test   %eax,%eax
  802256:	78 05                	js     80225d <socket+0x28>
		return r;
	return alloc_sockfd(r);
  802258:	e8 61 ff ff ff       	call   8021be <alloc_sockfd>
}
  80225d:	c9                   	leave  
  80225e:	66 90                	xchg   %ax,%ax
  802260:	c3                   	ret    

00802261 <fd2sockid>:
	.dev_stat =	devsock_stat,
};

static int
fd2sockid(int fd)
{
  802261:	55                   	push   %ebp
  802262:	89 e5                	mov    %esp,%ebp
  802264:	83 ec 28             	sub    $0x28,%esp
	struct Fd *sfd;
	int r;

	if ((r = fd_lookup(fd, &sfd)) < 0)
  802267:	8d 55 f4             	lea    -0xc(%ebp),%edx
  80226a:	89 54 24 04          	mov    %edx,0x4(%esp)
  80226e:	89 04 24             	mov    %eax,(%esp)
  802271:	e8 87 f0 ff ff       	call   8012fd <fd_lookup>
  802276:	85 c0                	test   %eax,%eax
  802278:	78 15                	js     80228f <fd2sockid+0x2e>
		return r;
	if (sfd->fd_dev_id != devsock.dev_id)
  80227a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80227d:	8b 0a                	mov    (%edx),%ecx
  80227f:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  802284:	3b 0d 20 70 80 00    	cmp    0x807020,%ecx
  80228a:	75 03                	jne    80228f <fd2sockid+0x2e>
		return -E_NOT_SUPP;
	return sfd->fd_sock.sockid;
  80228c:	8b 42 0c             	mov    0xc(%edx),%eax
}
  80228f:	c9                   	leave  
  802290:	c3                   	ret    

00802291 <listen>:
	return nsipc_connect(r, name, namelen);
}

int
listen(int s, int backlog)
{
  802291:	55                   	push   %ebp
  802292:	89 e5                	mov    %esp,%ebp
  802294:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  802297:	8b 45 08             	mov    0x8(%ebp),%eax
  80229a:	e8 c2 ff ff ff       	call   802261 <fd2sockid>
  80229f:	85 c0                	test   %eax,%eax
  8022a1:	78 0f                	js     8022b2 <listen+0x21>
		return r;
	return nsipc_listen(r, backlog);
  8022a3:	8b 55 0c             	mov    0xc(%ebp),%edx
  8022a6:	89 54 24 04          	mov    %edx,0x4(%esp)
  8022aa:	89 04 24             	mov    %eax,(%esp)
  8022ad:	e8 2e 01 00 00       	call   8023e0 <nsipc_listen>
}
  8022b2:	c9                   	leave  
  8022b3:	c3                   	ret    

008022b4 <connect>:
	return nsipc_close(fd->fd_sock.sockid);
}

int
connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  8022b4:	55                   	push   %ebp
  8022b5:	89 e5                	mov    %esp,%ebp
  8022b7:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  8022ba:	8b 45 08             	mov    0x8(%ebp),%eax
  8022bd:	e8 9f ff ff ff       	call   802261 <fd2sockid>
  8022c2:	85 c0                	test   %eax,%eax
  8022c4:	78 16                	js     8022dc <connect+0x28>
		return r;
	return nsipc_connect(r, name, namelen);
  8022c6:	8b 55 10             	mov    0x10(%ebp),%edx
  8022c9:	89 54 24 08          	mov    %edx,0x8(%esp)
  8022cd:	8b 55 0c             	mov    0xc(%ebp),%edx
  8022d0:	89 54 24 04          	mov    %edx,0x4(%esp)
  8022d4:	89 04 24             	mov    %eax,(%esp)
  8022d7:	e8 55 02 00 00       	call   802531 <nsipc_connect>
}
  8022dc:	c9                   	leave  
  8022dd:	c3                   	ret    

008022de <shutdown>:
	return nsipc_bind(r, name, namelen);
}

int
shutdown(int s, int how)
{
  8022de:	55                   	push   %ebp
  8022df:	89 e5                	mov    %esp,%ebp
  8022e1:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  8022e4:	8b 45 08             	mov    0x8(%ebp),%eax
  8022e7:	e8 75 ff ff ff       	call   802261 <fd2sockid>
  8022ec:	85 c0                	test   %eax,%eax
  8022ee:	78 0f                	js     8022ff <shutdown+0x21>
		return r;
	return nsipc_shutdown(r, how);
  8022f0:	8b 55 0c             	mov    0xc(%ebp),%edx
  8022f3:	89 54 24 04          	mov    %edx,0x4(%esp)
  8022f7:	89 04 24             	mov    %eax,(%esp)
  8022fa:	e8 1d 01 00 00       	call   80241c <nsipc_shutdown>
}
  8022ff:	c9                   	leave  
  802300:	c3                   	ret    

00802301 <bind>:
	return alloc_sockfd(r);
}

int
bind(int s, struct sockaddr *name, socklen_t namelen)
{
  802301:	55                   	push   %ebp
  802302:	89 e5                	mov    %esp,%ebp
  802304:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  802307:	8b 45 08             	mov    0x8(%ebp),%eax
  80230a:	e8 52 ff ff ff       	call   802261 <fd2sockid>
  80230f:	85 c0                	test   %eax,%eax
  802311:	78 16                	js     802329 <bind+0x28>
		return r;
	return nsipc_bind(r, name, namelen);
  802313:	8b 55 10             	mov    0x10(%ebp),%edx
  802316:	89 54 24 08          	mov    %edx,0x8(%esp)
  80231a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80231d:	89 54 24 04          	mov    %edx,0x4(%esp)
  802321:	89 04 24             	mov    %eax,(%esp)
  802324:	e8 47 02 00 00       	call   802570 <nsipc_bind>
}
  802329:	c9                   	leave  
  80232a:	c3                   	ret    

0080232b <accept>:
	return fd2num(sfd);
}

int
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  80232b:	55                   	push   %ebp
  80232c:	89 e5                	mov    %esp,%ebp
  80232e:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  802331:	8b 45 08             	mov    0x8(%ebp),%eax
  802334:	e8 28 ff ff ff       	call   802261 <fd2sockid>
  802339:	85 c0                	test   %eax,%eax
  80233b:	78 1f                	js     80235c <accept+0x31>
		return r;
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  80233d:	8b 55 10             	mov    0x10(%ebp),%edx
  802340:	89 54 24 08          	mov    %edx,0x8(%esp)
  802344:	8b 55 0c             	mov    0xc(%ebp),%edx
  802347:	89 54 24 04          	mov    %edx,0x4(%esp)
  80234b:	89 04 24             	mov    %eax,(%esp)
  80234e:	e8 5c 02 00 00       	call   8025af <nsipc_accept>
  802353:	85 c0                	test   %eax,%eax
  802355:	78 05                	js     80235c <accept+0x31>
		return r;
	return alloc_sockfd(r);
  802357:	e8 62 fe ff ff       	call   8021be <alloc_sockfd>
}
  80235c:	c9                   	leave  
  80235d:	8d 76 00             	lea    0x0(%esi),%esi
  802360:	c3                   	ret    
	...

00802370 <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  802370:	55                   	push   %ebp
  802371:	89 e5                	mov    %esp,%ebp
  802373:	83 ec 18             	sub    $0x18,%esp
	if (debug)
		cprintf("[%08x] nsipc %d\n", env->env_id, type);

	ipc_send(envs[2].env_id, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  802376:	8b 15 44 01 c0 ee    	mov    0xeec00144,%edx
  80237c:	c7 44 24 0c 07 00 00 	movl   $0x7,0xc(%esp)
  802383:	00 
  802384:	c7 44 24 08 00 60 80 	movl   $0x806000,0x8(%esp)
  80238b:	00 
  80238c:	89 44 24 04          	mov    %eax,0x4(%esp)
  802390:	89 14 24             	mov    %edx,(%esp)
  802393:	e8 08 08 00 00       	call   802ba0 <ipc_send>
	return ipc_recv(NULL, NULL, NULL);
  802398:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  80239f:	00 
  8023a0:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  8023a7:	00 
  8023a8:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8023af:	e8 52 08 00 00       	call   802c06 <ipc_recv>
}
  8023b4:	c9                   	leave  
  8023b5:	c3                   	ret    

008023b6 <nsipc_socket>:
	return nsipc(NSREQ_SEND);
}

int
nsipc_socket(int domain, int type, int protocol)
{
  8023b6:	55                   	push   %ebp
  8023b7:	89 e5                	mov    %esp,%ebp
  8023b9:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  8023bc:	8b 45 08             	mov    0x8(%ebp),%eax
  8023bf:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.socket.req_type = type;
  8023c4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8023c7:	a3 04 60 80 00       	mov    %eax,0x806004
	nsipcbuf.socket.req_protocol = protocol;
  8023cc:	8b 45 10             	mov    0x10(%ebp),%eax
  8023cf:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SOCKET);
  8023d4:	b8 09 00 00 00       	mov    $0x9,%eax
  8023d9:	e8 92 ff ff ff       	call   802370 <nsipc>
}
  8023de:	c9                   	leave  
  8023df:	c3                   	ret    

008023e0 <nsipc_listen>:
	return nsipc(NSREQ_CONNECT);
}

int
nsipc_listen(int s, int backlog)
{
  8023e0:	55                   	push   %ebp
  8023e1:	89 e5                	mov    %esp,%ebp
  8023e3:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  8023e6:	8b 45 08             	mov    0x8(%ebp),%eax
  8023e9:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.listen.req_backlog = backlog;
  8023ee:	8b 45 0c             	mov    0xc(%ebp),%eax
  8023f1:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_LISTEN);
  8023f6:	b8 06 00 00 00       	mov    $0x6,%eax
  8023fb:	e8 70 ff ff ff       	call   802370 <nsipc>
}
  802400:	c9                   	leave  
  802401:	c3                   	ret    

00802402 <nsipc_close>:
	return nsipc(NSREQ_SHUTDOWN);
}

int
nsipc_close(int s)
{
  802402:	55                   	push   %ebp
  802403:	89 e5                	mov    %esp,%ebp
  802405:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  802408:	8b 45 08             	mov    0x8(%ebp),%eax
  80240b:	a3 00 60 80 00       	mov    %eax,0x806000
	return nsipc(NSREQ_CLOSE);
  802410:	b8 04 00 00 00       	mov    $0x4,%eax
  802415:	e8 56 ff ff ff       	call   802370 <nsipc>
}
  80241a:	c9                   	leave  
  80241b:	c3                   	ret    

0080241c <nsipc_shutdown>:
	return nsipc(NSREQ_BIND);
}

int
nsipc_shutdown(int s, int how)
{
  80241c:	55                   	push   %ebp
  80241d:	89 e5                	mov    %esp,%ebp
  80241f:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  802422:	8b 45 08             	mov    0x8(%ebp),%eax
  802425:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.shutdown.req_how = how;
  80242a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80242d:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_SHUTDOWN);
  802432:	b8 03 00 00 00       	mov    $0x3,%eax
  802437:	e8 34 ff ff ff       	call   802370 <nsipc>
}
  80243c:	c9                   	leave  
  80243d:	c3                   	ret    

0080243e <nsipc_send>:
	return r;
}

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  80243e:	55                   	push   %ebp
  80243f:	89 e5                	mov    %esp,%ebp
  802441:	53                   	push   %ebx
  802442:	83 ec 14             	sub    $0x14,%esp
  802445:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  802448:	8b 45 08             	mov    0x8(%ebp),%eax
  80244b:	a3 00 60 80 00       	mov    %eax,0x806000
	assert(size < 1600);
  802450:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  802456:	7e 24                	jle    80247c <nsipc_send+0x3e>
  802458:	c7 44 24 0c ce 34 80 	movl   $0x8034ce,0xc(%esp)
  80245f:	00 
  802460:	c7 44 24 08 16 34 80 	movl   $0x803416,0x8(%esp)
  802467:	00 
  802468:	c7 44 24 04 66 00 00 	movl   $0x66,0x4(%esp)
  80246f:	00 
  802470:	c7 04 24 da 34 80 00 	movl   $0x8034da,(%esp)
  802477:	e8 4c dd ff ff       	call   8001c8 <_panic>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  80247c:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  802480:	8b 45 0c             	mov    0xc(%ebp),%eax
  802483:	89 44 24 04          	mov    %eax,0x4(%esp)
  802487:	c7 04 24 0c 60 80 00 	movl   $0x80600c,(%esp)
  80248e:	e8 72 e6 ff ff       	call   800b05 <memmove>
	nsipcbuf.send.req_size = size;
  802493:	89 1d 04 60 80 00    	mov    %ebx,0x806004
	nsipcbuf.send.req_flags = flags;
  802499:	8b 45 14             	mov    0x14(%ebp),%eax
  80249c:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SEND);
  8024a1:	b8 08 00 00 00       	mov    $0x8,%eax
  8024a6:	e8 c5 fe ff ff       	call   802370 <nsipc>
}
  8024ab:	83 c4 14             	add    $0x14,%esp
  8024ae:	5b                   	pop    %ebx
  8024af:	5d                   	pop    %ebp
  8024b0:	c3                   	ret    

008024b1 <nsipc_recv>:
	return nsipc(NSREQ_LISTEN);
}

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  8024b1:	55                   	push   %ebp
  8024b2:	89 e5                	mov    %esp,%ebp
  8024b4:	56                   	push   %esi
  8024b5:	53                   	push   %ebx
  8024b6:	83 ec 10             	sub    $0x10,%esp
  8024b9:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  8024bc:	8b 45 08             	mov    0x8(%ebp),%eax
  8024bf:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.recv.req_len = len;
  8024c4:	89 35 04 60 80 00    	mov    %esi,0x806004
	nsipcbuf.recv.req_flags = flags;
  8024ca:	8b 45 14             	mov    0x14(%ebp),%eax
  8024cd:	a3 08 60 80 00       	mov    %eax,0x806008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  8024d2:	b8 07 00 00 00       	mov    $0x7,%eax
  8024d7:	e8 94 fe ff ff       	call   802370 <nsipc>
  8024dc:	89 c3                	mov    %eax,%ebx
  8024de:	85 c0                	test   %eax,%eax
  8024e0:	78 46                	js     802528 <nsipc_recv+0x77>
		assert(r < 1600 && r <= len);
  8024e2:	3d 3f 06 00 00       	cmp    $0x63f,%eax
  8024e7:	7f 04                	jg     8024ed <nsipc_recv+0x3c>
  8024e9:	39 c6                	cmp    %eax,%esi
  8024eb:	7d 24                	jge    802511 <nsipc_recv+0x60>
  8024ed:	c7 44 24 0c e6 34 80 	movl   $0x8034e6,0xc(%esp)
  8024f4:	00 
  8024f5:	c7 44 24 08 16 34 80 	movl   $0x803416,0x8(%esp)
  8024fc:	00 
  8024fd:	c7 44 24 04 5b 00 00 	movl   $0x5b,0x4(%esp)
  802504:	00 
  802505:	c7 04 24 da 34 80 00 	movl   $0x8034da,(%esp)
  80250c:	e8 b7 dc ff ff       	call   8001c8 <_panic>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  802511:	89 44 24 08          	mov    %eax,0x8(%esp)
  802515:	c7 44 24 04 00 60 80 	movl   $0x806000,0x4(%esp)
  80251c:	00 
  80251d:	8b 45 0c             	mov    0xc(%ebp),%eax
  802520:	89 04 24             	mov    %eax,(%esp)
  802523:	e8 dd e5 ff ff       	call   800b05 <memmove>
	}

	return r;
}
  802528:	89 d8                	mov    %ebx,%eax
  80252a:	83 c4 10             	add    $0x10,%esp
  80252d:	5b                   	pop    %ebx
  80252e:	5e                   	pop    %esi
  80252f:	5d                   	pop    %ebp
  802530:	c3                   	ret    

00802531 <nsipc_connect>:
	return nsipc(NSREQ_CLOSE);
}

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  802531:	55                   	push   %ebp
  802532:	89 e5                	mov    %esp,%ebp
  802534:	53                   	push   %ebx
  802535:	83 ec 14             	sub    $0x14,%esp
  802538:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  80253b:	8b 45 08             	mov    0x8(%ebp),%eax
  80253e:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  802543:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  802547:	8b 45 0c             	mov    0xc(%ebp),%eax
  80254a:	89 44 24 04          	mov    %eax,0x4(%esp)
  80254e:	c7 04 24 04 60 80 00 	movl   $0x806004,(%esp)
  802555:	e8 ab e5 ff ff       	call   800b05 <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  80255a:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_CONNECT);
  802560:	b8 05 00 00 00       	mov    $0x5,%eax
  802565:	e8 06 fe ff ff       	call   802370 <nsipc>
}
  80256a:	83 c4 14             	add    $0x14,%esp
  80256d:	5b                   	pop    %ebx
  80256e:	5d                   	pop    %ebp
  80256f:	c3                   	ret    

00802570 <nsipc_bind>:
	return r;
}

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  802570:	55                   	push   %ebp
  802571:	89 e5                	mov    %esp,%ebp
  802573:	53                   	push   %ebx
  802574:	83 ec 14             	sub    $0x14,%esp
  802577:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  80257a:	8b 45 08             	mov    0x8(%ebp),%eax
  80257d:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  802582:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  802586:	8b 45 0c             	mov    0xc(%ebp),%eax
  802589:	89 44 24 04          	mov    %eax,0x4(%esp)
  80258d:	c7 04 24 04 60 80 00 	movl   $0x806004,(%esp)
  802594:	e8 6c e5 ff ff       	call   800b05 <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  802599:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_BIND);
  80259f:	b8 02 00 00 00       	mov    $0x2,%eax
  8025a4:	e8 c7 fd ff ff       	call   802370 <nsipc>
}
  8025a9:	83 c4 14             	add    $0x14,%esp
  8025ac:	5b                   	pop    %ebx
  8025ad:	5d                   	pop    %ebp
  8025ae:	c3                   	ret    

008025af <nsipc_accept>:
	return ipc_recv(NULL, NULL, NULL);
}

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  8025af:	55                   	push   %ebp
  8025b0:	89 e5                	mov    %esp,%ebp
  8025b2:	83 ec 18             	sub    $0x18,%esp
  8025b5:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  8025b8:	89 75 fc             	mov    %esi,-0x4(%ebp)
	int r;
	
	nsipcbuf.accept.req_s = s;
  8025bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8025be:	a3 00 60 80 00       	mov    %eax,0x806000
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  8025c3:	b8 01 00 00 00       	mov    $0x1,%eax
  8025c8:	e8 a3 fd ff ff       	call   802370 <nsipc>
  8025cd:	89 c3                	mov    %eax,%ebx
  8025cf:	85 c0                	test   %eax,%eax
  8025d1:	78 25                	js     8025f8 <nsipc_accept+0x49>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  8025d3:	be 10 60 80 00       	mov    $0x806010,%esi
  8025d8:	8b 06                	mov    (%esi),%eax
  8025da:	89 44 24 08          	mov    %eax,0x8(%esp)
  8025de:	c7 44 24 04 00 60 80 	movl   $0x806000,0x4(%esp)
  8025e5:	00 
  8025e6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8025e9:	89 04 24             	mov    %eax,(%esp)
  8025ec:	e8 14 e5 ff ff       	call   800b05 <memmove>
		*addrlen = ret->ret_addrlen;
  8025f1:	8b 16                	mov    (%esi),%edx
  8025f3:	8b 45 10             	mov    0x10(%ebp),%eax
  8025f6:	89 10                	mov    %edx,(%eax)
	}
	return r;
}
  8025f8:	89 d8                	mov    %ebx,%eax
  8025fa:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  8025fd:	8b 75 fc             	mov    -0x4(%ebp),%esi
  802600:	89 ec                	mov    %ebp,%esp
  802602:	5d                   	pop    %ebp
  802603:	c3                   	ret    
	...

00802610 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  802610:	55                   	push   %ebp
  802611:	89 e5                	mov    %esp,%ebp
  802613:	83 ec 18             	sub    $0x18,%esp
  802616:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  802619:	89 75 fc             	mov    %esi,-0x4(%ebp)
  80261c:	8b 75 0c             	mov    0xc(%ebp),%esi
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  80261f:	8b 45 08             	mov    0x8(%ebp),%eax
  802622:	89 04 24             	mov    %eax,(%esp)
  802625:	e8 46 ec ff ff       	call   801270 <fd2data>
  80262a:	89 c3                	mov    %eax,%ebx
	strcpy(stat->st_name, "<pipe>");
  80262c:	c7 44 24 04 fb 34 80 	movl   $0x8034fb,0x4(%esp)
  802633:	00 
  802634:	89 34 24             	mov    %esi,(%esp)
  802637:	e8 0e e3 ff ff       	call   80094a <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  80263c:	8b 43 04             	mov    0x4(%ebx),%eax
  80263f:	2b 03                	sub    (%ebx),%eax
  802641:	89 86 80 00 00 00    	mov    %eax,0x80(%esi)
	stat->st_isdir = 0;
  802647:	c7 86 84 00 00 00 00 	movl   $0x0,0x84(%esi)
  80264e:	00 00 00 
	stat->st_dev = &devpipe;
  802651:	c7 86 88 00 00 00 3c 	movl   $0x80703c,0x88(%esi)
  802658:	70 80 00 
	return 0;
}
  80265b:	b8 00 00 00 00       	mov    $0x0,%eax
  802660:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  802663:	8b 75 fc             	mov    -0x4(%ebp),%esi
  802666:	89 ec                	mov    %ebp,%esp
  802668:	5d                   	pop    %ebp
  802669:	c3                   	ret    

0080266a <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  80266a:	55                   	push   %ebp
  80266b:	89 e5                	mov    %esp,%ebp
  80266d:	53                   	push   %ebx
  80266e:	83 ec 14             	sub    $0x14,%esp
  802671:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  802674:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  802678:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80267f:	e8 fb e9 ff ff       	call   80107f <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  802684:	89 1c 24             	mov    %ebx,(%esp)
  802687:	e8 e4 eb ff ff       	call   801270 <fd2data>
  80268c:	89 44 24 04          	mov    %eax,0x4(%esp)
  802690:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802697:	e8 e3 e9 ff ff       	call   80107f <sys_page_unmap>
}
  80269c:	83 c4 14             	add    $0x14,%esp
  80269f:	5b                   	pop    %ebx
  8026a0:	5d                   	pop    %ebp
  8026a1:	c3                   	ret    

008026a2 <_pipeisclosed>:
	return r;
}

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  8026a2:	55                   	push   %ebp
  8026a3:	89 e5                	mov    %esp,%ebp
  8026a5:	57                   	push   %edi
  8026a6:	56                   	push   %esi
  8026a7:	53                   	push   %ebx
  8026a8:	83 ec 2c             	sub    $0x2c,%esp
  8026ab:	89 c7                	mov    %eax,%edi
  8026ad:	89 55 e4             	mov    %edx,-0x1c(%ebp)
	int n, nn, ret;

	while (1) {
		n = env->env_runs;
  8026b0:	a1 74 70 80 00       	mov    0x807074,%eax
  8026b5:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  8026b8:	89 3c 24             	mov    %edi,(%esp)
  8026bb:	e8 b0 05 00 00       	call   802c70 <pageref>
  8026c0:	89 c6                	mov    %eax,%esi
  8026c2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8026c5:	89 04 24             	mov    %eax,(%esp)
  8026c8:	e8 a3 05 00 00       	call   802c70 <pageref>
  8026cd:	39 c6                	cmp    %eax,%esi
  8026cf:	0f 94 c0             	sete   %al
  8026d2:	0f b6 c0             	movzbl %al,%eax
		nn = env->env_runs;
  8026d5:	8b 15 74 70 80 00    	mov    0x807074,%edx
  8026db:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  8026de:	39 cb                	cmp    %ecx,%ebx
  8026e0:	75 08                	jne    8026ea <_pipeisclosed+0x48>
			return ret;
		if (n != nn && ret == 1)
			cprintf("pipe race avoided\n", n, env->env_runs, ret);
	}
}
  8026e2:	83 c4 2c             	add    $0x2c,%esp
  8026e5:	5b                   	pop    %ebx
  8026e6:	5e                   	pop    %esi
  8026e7:	5f                   	pop    %edi
  8026e8:	5d                   	pop    %ebp
  8026e9:	c3                   	ret    
		n = env->env_runs;
		ret = pageref(fd) == pageref(p);
		nn = env->env_runs;
		if (n == nn)
			return ret;
		if (n != nn && ret == 1)
  8026ea:	83 f8 01             	cmp    $0x1,%eax
  8026ed:	75 c1                	jne    8026b0 <_pipeisclosed+0xe>
			cprintf("pipe race avoided\n", n, env->env_runs, ret);
  8026ef:	8b 52 58             	mov    0x58(%edx),%edx
  8026f2:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8026f6:	89 54 24 08          	mov    %edx,0x8(%esp)
  8026fa:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8026fe:	c7 04 24 02 35 80 00 	movl   $0x803502,(%esp)
  802705:	e8 83 db ff ff       	call   80028d <cprintf>
  80270a:	eb a4                	jmp    8026b0 <_pipeisclosed+0xe>

0080270c <devpipe_write>:
	return i;
}

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  80270c:	55                   	push   %ebp
  80270d:	89 e5                	mov    %esp,%ebp
  80270f:	57                   	push   %edi
  802710:	56                   	push   %esi
  802711:	53                   	push   %ebx
  802712:	83 ec 1c             	sub    $0x1c,%esp
  802715:	8b 75 08             	mov    0x8(%ebp),%esi
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  802718:	89 34 24             	mov    %esi,(%esp)
  80271b:	e8 50 eb ff ff       	call   801270 <fd2data>
  802720:	89 c3                	mov    %eax,%ebx
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			env->env_id, vpt[VPN(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  802722:	bf 00 00 00 00       	mov    $0x0,%edi
  802727:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80272b:	75 54                	jne    802781 <devpipe_write+0x75>
  80272d:	eb 60                	jmp    80278f <devpipe_write+0x83>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  80272f:	89 da                	mov    %ebx,%edx
  802731:	89 f0                	mov    %esi,%eax
  802733:	e8 6a ff ff ff       	call   8026a2 <_pipeisclosed>
  802738:	85 c0                	test   %eax,%eax
  80273a:	74 07                	je     802743 <devpipe_write+0x37>
  80273c:	b8 00 00 00 00       	mov    $0x0,%eax
  802741:	eb 53                	jmp    802796 <devpipe_write+0x8a>
				return 0;
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  802743:	90                   	nop
  802744:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802748:	e8 4d ea ff ff       	call   80119a <sys_yield>
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			env->env_id, vpt[VPN(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  80274d:	8b 43 04             	mov    0x4(%ebx),%eax
  802750:	8b 13                	mov    (%ebx),%edx
  802752:	83 c2 20             	add    $0x20,%edx
  802755:	39 d0                	cmp    %edx,%eax
  802757:	73 d6                	jae    80272f <devpipe_write+0x23>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  802759:	89 c2                	mov    %eax,%edx
  80275b:	c1 fa 1f             	sar    $0x1f,%edx
  80275e:	c1 ea 1b             	shr    $0x1b,%edx
  802761:	01 d0                	add    %edx,%eax
  802763:	83 e0 1f             	and    $0x1f,%eax
  802766:	29 d0                	sub    %edx,%eax
  802768:	89 c2                	mov    %eax,%edx
  80276a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80276d:	0f b6 04 39          	movzbl (%ecx,%edi,1),%eax
  802771:	88 44 13 08          	mov    %al,0x8(%ebx,%edx,1)
		p->p_wpos++;
  802775:	83 43 04 01          	addl   $0x1,0x4(%ebx)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			env->env_id, vpt[VPN(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  802779:	83 c7 01             	add    $0x1,%edi
  80277c:	39 7d 10             	cmp    %edi,0x10(%ebp)
  80277f:	76 13                	jbe    802794 <devpipe_write+0x88>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  802781:	8b 43 04             	mov    0x4(%ebx),%eax
  802784:	8b 13                	mov    (%ebx),%edx
  802786:	83 c2 20             	add    $0x20,%edx
  802789:	39 d0                	cmp    %edx,%eax
  80278b:	73 a2                	jae    80272f <devpipe_write+0x23>
  80278d:	eb ca                	jmp    802759 <devpipe_write+0x4d>
  80278f:	bf 00 00 00 00       	mov    $0x0,%edi
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}
	
	return i;
  802794:	89 f8                	mov    %edi,%eax
}
  802796:	83 c4 1c             	add    $0x1c,%esp
  802799:	5b                   	pop    %ebx
  80279a:	5e                   	pop    %esi
  80279b:	5f                   	pop    %edi
  80279c:	5d                   	pop    %ebp
  80279d:	c3                   	ret    

0080279e <devpipe_read>:
	return _pipeisclosed(fd, p);
}

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  80279e:	55                   	push   %ebp
  80279f:	89 e5                	mov    %esp,%ebp
  8027a1:	83 ec 28             	sub    $0x28,%esp
  8027a4:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  8027a7:	89 75 f8             	mov    %esi,-0x8(%ebp)
  8027aa:	89 7d fc             	mov    %edi,-0x4(%ebp)
  8027ad:	8b 7d 08             	mov    0x8(%ebp),%edi
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  8027b0:	89 3c 24             	mov    %edi,(%esp)
  8027b3:	e8 b8 ea ff ff       	call   801270 <fd2data>
  8027b8:	89 c3                	mov    %eax,%ebx
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			env->env_id, vpt[VPN(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  8027ba:	be 00 00 00 00       	mov    $0x0,%esi
  8027bf:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8027c3:	75 4c                	jne    802811 <devpipe_read+0x73>
  8027c5:	eb 5b                	jmp    802822 <devpipe_read+0x84>
		while (p->p_rpos == p->p_wpos) {
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
				return i;
  8027c7:	89 f0                	mov    %esi,%eax
  8027c9:	eb 5e                	jmp    802829 <devpipe_read+0x8b>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  8027cb:	89 da                	mov    %ebx,%edx
  8027cd:	89 f8                	mov    %edi,%eax
  8027cf:	90                   	nop
  8027d0:	e8 cd fe ff ff       	call   8026a2 <_pipeisclosed>
  8027d5:	85 c0                	test   %eax,%eax
  8027d7:	74 07                	je     8027e0 <devpipe_read+0x42>
  8027d9:	b8 00 00 00 00       	mov    $0x0,%eax
  8027de:	eb 49                	jmp    802829 <devpipe_read+0x8b>
				return 0;
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  8027e0:	e8 b5 e9 ff ff       	call   80119a <sys_yield>
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			env->env_id, vpt[VPN(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  8027e5:	8b 03                	mov    (%ebx),%eax
  8027e7:	3b 43 04             	cmp    0x4(%ebx),%eax
  8027ea:	74 df                	je     8027cb <devpipe_read+0x2d>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  8027ec:	89 c2                	mov    %eax,%edx
  8027ee:	c1 fa 1f             	sar    $0x1f,%edx
  8027f1:	c1 ea 1b             	shr    $0x1b,%edx
  8027f4:	01 d0                	add    %edx,%eax
  8027f6:	83 e0 1f             	and    $0x1f,%eax
  8027f9:	29 d0                	sub    %edx,%eax
  8027fb:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  802800:	8b 55 0c             	mov    0xc(%ebp),%edx
  802803:	88 04 32             	mov    %al,(%edx,%esi,1)
		p->p_rpos++;
  802806:	83 03 01             	addl   $0x1,(%ebx)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			env->env_id, vpt[VPN(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  802809:	83 c6 01             	add    $0x1,%esi
  80280c:	39 75 10             	cmp    %esi,0x10(%ebp)
  80280f:	76 16                	jbe    802827 <devpipe_read+0x89>
		while (p->p_rpos == p->p_wpos) {
  802811:	8b 03                	mov    (%ebx),%eax
  802813:	3b 43 04             	cmp    0x4(%ebx),%eax
  802816:	75 d4                	jne    8027ec <devpipe_read+0x4e>
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  802818:	85 f6                	test   %esi,%esi
  80281a:	75 ab                	jne    8027c7 <devpipe_read+0x29>
  80281c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802820:	eb a9                	jmp    8027cb <devpipe_read+0x2d>
  802822:	be 00 00 00 00       	mov    $0x0,%esi
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  802827:	89 f0                	mov    %esi,%eax
}
  802829:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  80282c:	8b 75 f8             	mov    -0x8(%ebp),%esi
  80282f:	8b 7d fc             	mov    -0x4(%ebp),%edi
  802832:	89 ec                	mov    %ebp,%esp
  802834:	5d                   	pop    %ebp
  802835:	c3                   	ret    

00802836 <pipeisclosed>:
	}
}

int
pipeisclosed(int fdnum)
{
  802836:	55                   	push   %ebp
  802837:	89 e5                	mov    %esp,%ebp
  802839:	83 ec 28             	sub    $0x28,%esp
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80283c:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80283f:	89 44 24 04          	mov    %eax,0x4(%esp)
  802843:	8b 45 08             	mov    0x8(%ebp),%eax
  802846:	89 04 24             	mov    %eax,(%esp)
  802849:	e8 af ea ff ff       	call   8012fd <fd_lookup>
  80284e:	85 c0                	test   %eax,%eax
  802850:	78 15                	js     802867 <pipeisclosed+0x31>
		return r;
	p = (struct Pipe*) fd2data(fd);
  802852:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802855:	89 04 24             	mov    %eax,(%esp)
  802858:	e8 13 ea ff ff       	call   801270 <fd2data>
	return _pipeisclosed(fd, p);
  80285d:	89 c2                	mov    %eax,%edx
  80285f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802862:	e8 3b fe ff ff       	call   8026a2 <_pipeisclosed>
}
  802867:	c9                   	leave  
  802868:	c3                   	ret    

00802869 <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  802869:	55                   	push   %ebp
  80286a:	89 e5                	mov    %esp,%ebp
  80286c:	83 ec 48             	sub    $0x48,%esp
  80286f:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  802872:	89 75 f8             	mov    %esi,-0x8(%ebp)
  802875:	89 7d fc             	mov    %edi,-0x4(%ebp)
  802878:	8b 7d 08             	mov    0x8(%ebp),%edi
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  80287b:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  80287e:	89 04 24             	mov    %eax,(%esp)
  802881:	e8 05 ea ff ff       	call   80128b <fd_alloc>
  802886:	89 c3                	mov    %eax,%ebx
  802888:	85 c0                	test   %eax,%eax
  80288a:	0f 88 42 01 00 00    	js     8029d2 <pipe+0x169>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802890:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  802897:	00 
  802898:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80289b:	89 44 24 04          	mov    %eax,0x4(%esp)
  80289f:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8028a6:	e8 90 e8 ff ff       	call   80113b <sys_page_alloc>
  8028ab:	89 c3                	mov    %eax,%ebx
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  8028ad:	85 c0                	test   %eax,%eax
  8028af:	0f 88 1d 01 00 00    	js     8029d2 <pipe+0x169>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  8028b5:	8d 45 e0             	lea    -0x20(%ebp),%eax
  8028b8:	89 04 24             	mov    %eax,(%esp)
  8028bb:	e8 cb e9 ff ff       	call   80128b <fd_alloc>
  8028c0:	89 c3                	mov    %eax,%ebx
  8028c2:	85 c0                	test   %eax,%eax
  8028c4:	0f 88 f5 00 00 00    	js     8029bf <pipe+0x156>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8028ca:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  8028d1:	00 
  8028d2:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8028d5:	89 44 24 04          	mov    %eax,0x4(%esp)
  8028d9:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8028e0:	e8 56 e8 ff ff       	call   80113b <sys_page_alloc>
  8028e5:	89 c3                	mov    %eax,%ebx
	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  8028e7:	85 c0                	test   %eax,%eax
  8028e9:	0f 88 d0 00 00 00    	js     8029bf <pipe+0x156>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  8028ef:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8028f2:	89 04 24             	mov    %eax,(%esp)
  8028f5:	e8 76 e9 ff ff       	call   801270 <fd2data>
  8028fa:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8028fc:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  802903:	00 
  802904:	89 44 24 04          	mov    %eax,0x4(%esp)
  802908:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80290f:	e8 27 e8 ff ff       	call   80113b <sys_page_alloc>
  802914:	89 c3                	mov    %eax,%ebx
  802916:	85 c0                	test   %eax,%eax
  802918:	0f 88 8e 00 00 00    	js     8029ac <pipe+0x143>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80291e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802921:	89 04 24             	mov    %eax,(%esp)
  802924:	e8 47 e9 ff ff       	call   801270 <fd2data>
  802929:	c7 44 24 10 07 04 00 	movl   $0x407,0x10(%esp)
  802930:	00 
  802931:	89 44 24 0c          	mov    %eax,0xc(%esp)
  802935:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  80293c:	00 
  80293d:	89 74 24 04          	mov    %esi,0x4(%esp)
  802941:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802948:	e8 90 e7 ff ff       	call   8010dd <sys_page_map>
  80294d:	89 c3                	mov    %eax,%ebx
  80294f:	85 c0                	test   %eax,%eax
  802951:	78 49                	js     80299c <pipe+0x133>
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  802953:	b8 3c 70 80 00       	mov    $0x80703c,%eax
  802958:	8b 08                	mov    (%eax),%ecx
  80295a:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80295d:	89 0a                	mov    %ecx,(%edx)
	fd0->fd_omode = O_RDONLY;
  80295f:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802962:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%edx)

	fd1->fd_dev_id = devpipe.dev_id;
  802969:	8b 10                	mov    (%eax),%edx
  80296b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80296e:	89 10                	mov    %edx,(%eax)
	fd1->fd_omode = O_WRONLY;
  802970:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802973:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", env->env_id, vpt[VPN(va)]);

	pfd[0] = fd2num(fd0);
  80297a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80297d:	89 04 24             	mov    %eax,(%esp)
  802980:	e8 db e8 ff ff       	call   801260 <fd2num>
  802985:	89 07                	mov    %eax,(%edi)
	pfd[1] = fd2num(fd1);
  802987:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80298a:	89 04 24             	mov    %eax,(%esp)
  80298d:	e8 ce e8 ff ff       	call   801260 <fd2num>
  802992:	89 47 04             	mov    %eax,0x4(%edi)
  802995:	bb 00 00 00 00       	mov    $0x0,%ebx
	return 0;
  80299a:	eb 36                	jmp    8029d2 <pipe+0x169>

    err3:
	sys_page_unmap(0, va);
  80299c:	89 74 24 04          	mov    %esi,0x4(%esp)
  8029a0:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8029a7:	e8 d3 e6 ff ff       	call   80107f <sys_page_unmap>
    err2:
	sys_page_unmap(0, fd1);
  8029ac:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8029af:	89 44 24 04          	mov    %eax,0x4(%esp)
  8029b3:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8029ba:	e8 c0 e6 ff ff       	call   80107f <sys_page_unmap>
    err1:
	sys_page_unmap(0, fd0);
  8029bf:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8029c2:	89 44 24 04          	mov    %eax,0x4(%esp)
  8029c6:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8029cd:	e8 ad e6 ff ff       	call   80107f <sys_page_unmap>
    err:
	return r;
}
  8029d2:	89 d8                	mov    %ebx,%eax
  8029d4:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  8029d7:	8b 75 f8             	mov    -0x8(%ebp),%esi
  8029da:	8b 7d fc             	mov    -0x4(%ebp),%edi
  8029dd:	89 ec                	mov    %ebp,%esp
  8029df:	5d                   	pop    %ebp
  8029e0:	c3                   	ret    
	...

008029f0 <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  8029f0:	55                   	push   %ebp
  8029f1:	89 e5                	mov    %esp,%ebp
	USED(fd);

	return 0;
}
  8029f3:	b8 00 00 00 00       	mov    $0x0,%eax
  8029f8:	5d                   	pop    %ebp
  8029f9:	c3                   	ret    

008029fa <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  8029fa:	55                   	push   %ebp
  8029fb:	89 e5                	mov    %esp,%ebp
  8029fd:	83 ec 18             	sub    $0x18,%esp
	strcpy(stat->st_name, "<cons>");
  802a00:	c7 44 24 04 1a 35 80 	movl   $0x80351a,0x4(%esp)
  802a07:	00 
  802a08:	8b 45 0c             	mov    0xc(%ebp),%eax
  802a0b:	89 04 24             	mov    %eax,(%esp)
  802a0e:	e8 37 df ff ff       	call   80094a <strcpy>
	return 0;
}
  802a13:	b8 00 00 00 00       	mov    $0x0,%eax
  802a18:	c9                   	leave  
  802a19:	c3                   	ret    

00802a1a <devcons_write>:
	return 1;
}

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  802a1a:	55                   	push   %ebp
  802a1b:	89 e5                	mov    %esp,%ebp
  802a1d:	57                   	push   %edi
  802a1e:	56                   	push   %esi
  802a1f:	53                   	push   %ebx
  802a20:	81 ec 9c 00 00 00    	sub    $0x9c,%esp
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs, 
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  802a26:	b8 00 00 00 00       	mov    $0x0,%eax
  802a2b:	be 00 00 00 00       	mov    $0x0,%esi
  802a30:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  802a34:	74 3f                	je     802a75 <devcons_write+0x5b>
		m = n - tot;
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  802a36:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs, 
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
		m = n - tot;
  802a3c:	8b 55 10             	mov    0x10(%ebp),%edx
  802a3f:	29 c2                	sub    %eax,%edx
  802a41:	89 d3                	mov    %edx,%ebx
		if (m > sizeof(buf) - 1)
  802a43:	83 fa 7f             	cmp    $0x7f,%edx
  802a46:	76 05                	jbe    802a4d <devcons_write+0x33>
  802a48:	bb 7f 00 00 00       	mov    $0x7f,%ebx
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  802a4d:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  802a51:	03 45 0c             	add    0xc(%ebp),%eax
  802a54:	89 44 24 04          	mov    %eax,0x4(%esp)
  802a58:	89 3c 24             	mov    %edi,(%esp)
  802a5b:	e8 a5 e0 ff ff       	call   800b05 <memmove>
		sys_cputs(buf, m);
  802a60:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  802a64:	89 3c 24             	mov    %edi,(%esp)
  802a67:	e8 d4 e2 ff ff       	call   800d40 <sys_cputs>
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs, 
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  802a6c:	01 de                	add    %ebx,%esi
  802a6e:	89 f0                	mov    %esi,%eax
  802a70:	3b 75 10             	cmp    0x10(%ebp),%esi
  802a73:	72 c7                	jb     802a3c <devcons_write+0x22>
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
}
  802a75:	89 f0                	mov    %esi,%eax
  802a77:	81 c4 9c 00 00 00    	add    $0x9c,%esp
  802a7d:	5b                   	pop    %ebx
  802a7e:	5e                   	pop    %esi
  802a7f:	5f                   	pop    %edi
  802a80:	5d                   	pop    %ebp
  802a81:	c3                   	ret    

00802a82 <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  802a82:	55                   	push   %ebp
  802a83:	89 e5                	mov    %esp,%ebp
  802a85:	83 ec 28             	sub    $0x28,%esp
	char c = ch;
  802a88:	8b 45 08             	mov    0x8(%ebp),%eax
  802a8b:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  802a8e:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  802a95:	00 
  802a96:	8d 45 f7             	lea    -0x9(%ebp),%eax
  802a99:	89 04 24             	mov    %eax,(%esp)
  802a9c:	e8 9f e2 ff ff       	call   800d40 <sys_cputs>
}
  802aa1:	c9                   	leave  
  802aa2:	c3                   	ret    

00802aa3 <devcons_read>:
	return fd2num(fd);
}

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  802aa3:	55                   	push   %ebp
  802aa4:	89 e5                	mov    %esp,%ebp
  802aa6:	83 ec 08             	sub    $0x8,%esp
	int c;

	if (n == 0)
  802aa9:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  802aad:	75 07                	jne    802ab6 <devcons_read+0x13>
  802aaf:	eb 28                	jmp    802ad9 <devcons_read+0x36>
		return 0;

	while ((c = sys_cgetc()) == 0)
		sys_yield();
  802ab1:	e8 e4 e6 ff ff       	call   80119a <sys_yield>
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  802ab6:	66 90                	xchg   %ax,%ax
  802ab8:	e8 4f e2 ff ff       	call   800d0c <sys_cgetc>
  802abd:	85 c0                	test   %eax,%eax
  802abf:	90                   	nop
  802ac0:	74 ef                	je     802ab1 <devcons_read+0xe>
  802ac2:	89 c2                	mov    %eax,%edx
		sys_yield();
	if (c < 0)
  802ac4:	85 c0                	test   %eax,%eax
  802ac6:	78 16                	js     802ade <devcons_read+0x3b>
		return c;
	if (c == 0x04)	// ctl-d is eof
  802ac8:	83 f8 04             	cmp    $0x4,%eax
  802acb:	74 0c                	je     802ad9 <devcons_read+0x36>
		return 0;
	*(char*)vbuf = c;
  802acd:	8b 45 0c             	mov    0xc(%ebp),%eax
  802ad0:	88 10                	mov    %dl,(%eax)
  802ad2:	b8 01 00 00 00       	mov    $0x1,%eax
	return 1;
  802ad7:	eb 05                	jmp    802ade <devcons_read+0x3b>
  802ad9:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802ade:	c9                   	leave  
  802adf:	c3                   	ret    

00802ae0 <opencons>:
	return fd->fd_dev_id == devcons.dev_id;
}

int
opencons(void)
{
  802ae0:	55                   	push   %ebp
  802ae1:	89 e5                	mov    %esp,%ebp
  802ae3:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  802ae6:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802ae9:	89 04 24             	mov    %eax,(%esp)
  802aec:	e8 9a e7 ff ff       	call   80128b <fd_alloc>
  802af1:	85 c0                	test   %eax,%eax
  802af3:	78 3f                	js     802b34 <opencons+0x54>
		return r;
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  802af5:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  802afc:	00 
  802afd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b00:	89 44 24 04          	mov    %eax,0x4(%esp)
  802b04:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802b0b:	e8 2b e6 ff ff       	call   80113b <sys_page_alloc>
  802b10:	85 c0                	test   %eax,%eax
  802b12:	78 20                	js     802b34 <opencons+0x54>
		return r;
	fd->fd_dev_id = devcons.dev_id;
  802b14:	8b 15 58 70 80 00    	mov    0x807058,%edx
  802b1a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b1d:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  802b1f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b22:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  802b29:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b2c:	89 04 24             	mov    %eax,(%esp)
  802b2f:	e8 2c e7 ff ff       	call   801260 <fd2num>
}
  802b34:	c9                   	leave  
  802b35:	c3                   	ret    

00802b36 <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  802b36:	55                   	push   %ebp
  802b37:	89 e5                	mov    %esp,%ebp
  802b39:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802b3c:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802b3f:	89 44 24 04          	mov    %eax,0x4(%esp)
  802b43:	8b 45 08             	mov    0x8(%ebp),%eax
  802b46:	89 04 24             	mov    %eax,(%esp)
  802b49:	e8 af e7 ff ff       	call   8012fd <fd_lookup>
  802b4e:	85 c0                	test   %eax,%eax
  802b50:	78 11                	js     802b63 <iscons+0x2d>
		return r;
	return fd->fd_dev_id == devcons.dev_id;
  802b52:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b55:	8b 00                	mov    (%eax),%eax
  802b57:	3b 05 58 70 80 00    	cmp    0x807058,%eax
  802b5d:	0f 94 c0             	sete   %al
  802b60:	0f b6 c0             	movzbl %al,%eax
}
  802b63:	c9                   	leave  
  802b64:	c3                   	ret    

00802b65 <getchar>:
	sys_cputs(&c, 1);
}

int
getchar(void)
{
  802b65:	55                   	push   %ebp
  802b66:	89 e5                	mov    %esp,%ebp
  802b68:	83 ec 28             	sub    $0x28,%esp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  802b6b:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  802b72:	00 
  802b73:	8d 45 f7             	lea    -0x9(%ebp),%eax
  802b76:	89 44 24 04          	mov    %eax,0x4(%esp)
  802b7a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802b81:	e8 d8 e9 ff ff       	call   80155e <read>
	if (r < 0)
  802b86:	85 c0                	test   %eax,%eax
  802b88:	78 0f                	js     802b99 <getchar+0x34>
		return r;
	if (r < 1)
  802b8a:	85 c0                	test   %eax,%eax
  802b8c:	7f 07                	jg     802b95 <getchar+0x30>
  802b8e:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  802b93:	eb 04                	jmp    802b99 <getchar+0x34>
		return -E_EOF;
	return c;
  802b95:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  802b99:	c9                   	leave  
  802b9a:	c3                   	ret    
  802b9b:	00 00                	add    %al,(%eax)
  802b9d:	00 00                	add    %al,(%eax)
	...

00802ba0 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  802ba0:	55                   	push   %ebp
  802ba1:	89 e5                	mov    %esp,%ebp
  802ba3:	57                   	push   %edi
  802ba4:	56                   	push   %esi
  802ba5:	53                   	push   %ebx
  802ba6:	83 ec 1c             	sub    $0x1c,%esp
  802ba9:	8b 7d 0c             	mov    0xc(%ebp),%edi
  802bac:	8b 5d 10             	mov    0x10(%ebp),%ebx
  802baf:	8b 75 14             	mov    0x14(%ebp),%esi
	// LAB 4: Your code here.
	int r;
	if (pg == NULL)
  802bb2:	85 db                	test   %ebx,%ebx
  802bb4:	75 2d                	jne    802be3 <ipc_send+0x43>
  802bb6:	bb 00 00 c0 ee       	mov    $0xeec00000,%ebx
  802bbb:	eb 26                	jmp    802be3 <ipc_send+0x43>
		pg = (void*)UTOP;
	while ((r = sys_ipc_try_send(to_env, val, pg, perm)) < 0)
	{
		if(r != -E_IPC_NOT_RECV)
  802bbd:	83 f8 f9             	cmp    $0xfffffff9,%eax
  802bc0:	74 1c                	je     802bde <ipc_send+0x3e>
			panic("Panic in lib ipc.c : ipc_send() \n");
  802bc2:	c7 44 24 08 28 35 80 	movl   $0x803528,0x8(%esp)
  802bc9:	00 
  802bca:	c7 44 24 04 44 00 00 	movl   $0x44,0x4(%esp)
  802bd1:	00 
  802bd2:	c7 04 24 4c 35 80 00 	movl   $0x80354c,(%esp)
  802bd9:	e8 ea d5 ff ff       	call   8001c8 <_panic>
		sys_yield();
  802bde:	e8 b7 e5 ff ff       	call   80119a <sys_yield>
{
	// LAB 4: Your code here.
	int r;
	if (pg == NULL)
		pg = (void*)UTOP;
	while ((r = sys_ipc_try_send(to_env, val, pg, perm)) < 0)
  802be3:	89 74 24 0c          	mov    %esi,0xc(%esp)
  802be7:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  802beb:	89 7c 24 04          	mov    %edi,0x4(%esp)
  802bef:	8b 45 08             	mov    0x8(%ebp),%eax
  802bf2:	89 04 24             	mov    %eax,(%esp)
  802bf5:	e8 33 e3 ff ff       	call   800f2d <sys_ipc_try_send>
  802bfa:	85 c0                	test   %eax,%eax
  802bfc:	78 bf                	js     802bbd <ipc_send+0x1d>
		if(r != -E_IPC_NOT_RECV)
			panic("Panic in lib ipc.c : ipc_send() \n");
		sys_yield();
	}
	//panic("ipc_send not implemented");
}
  802bfe:	83 c4 1c             	add    $0x1c,%esp
  802c01:	5b                   	pop    %ebx
  802c02:	5e                   	pop    %esi
  802c03:	5f                   	pop    %edi
  802c04:	5d                   	pop    %ebp
  802c05:	c3                   	ret    

00802c06 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  802c06:	55                   	push   %ebp
  802c07:	89 e5                	mov    %esp,%ebp
  802c09:	56                   	push   %esi
  802c0a:	53                   	push   %ebx
  802c0b:	83 ec 10             	sub    $0x10,%esp
  802c0e:	8b 5d 08             	mov    0x8(%ebp),%ebx
  802c11:	8b 45 0c             	mov    0xc(%ebp),%eax
  802c14:	8b 75 10             	mov    0x10(%ebp),%esi
	// LAB 4: Your code here.
	int r;

	if (pg == NULL)
  802c17:	85 c0                	test   %eax,%eax
  802c19:	75 05                	jne    802c20 <ipc_recv+0x1a>
  802c1b:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
		pg = (void*)UTOP;
	if ((r = sys_ipc_recv(pg)) < 0)
  802c20:	89 04 24             	mov    %eax,(%esp)
  802c23:	e8 a8 e2 ff ff       	call   800ed0 <sys_ipc_recv>
  802c28:	85 c0                	test   %eax,%eax
  802c2a:	79 16                	jns    802c42 <ipc_recv+0x3c>
	{
		if (from_env_store != NULL)
  802c2c:	85 db                	test   %ebx,%ebx
  802c2e:	74 06                	je     802c36 <ipc_recv+0x30>
			*from_env_store = 0;
  802c30:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
		if(perm_store != NULL)
  802c36:	85 f6                	test   %esi,%esi
  802c38:	74 2c                	je     802c66 <ipc_recv+0x60>
			*perm_store = 0;
  802c3a:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
  802c40:	eb 24                	jmp    802c66 <ipc_recv+0x60>
		return r;
	}
	else
	{	
		if (from_env_store != NULL)
  802c42:	85 db                	test   %ebx,%ebx
  802c44:	74 0a                	je     802c50 <ipc_recv+0x4a>
			*from_env_store = env->env_ipc_from;
  802c46:	a1 74 70 80 00       	mov    0x807074,%eax
  802c4b:	8b 40 74             	mov    0x74(%eax),%eax
  802c4e:	89 03                	mov    %eax,(%ebx)
		if(perm_store != NULL)
  802c50:	85 f6                	test   %esi,%esi
  802c52:	74 0a                	je     802c5e <ipc_recv+0x58>
			*perm_store = env->env_ipc_perm;
  802c54:	a1 74 70 80 00       	mov    0x807074,%eax
  802c59:	8b 40 78             	mov    0x78(%eax),%eax
  802c5c:	89 06                	mov    %eax,(%esi)
		return env->env_ipc_value;
  802c5e:	a1 74 70 80 00       	mov    0x807074,%eax
  802c63:	8b 40 70             	mov    0x70(%eax),%eax
	}		
	//panic("ipc_recv not implemented");
	//return 0;
}
  802c66:	83 c4 10             	add    $0x10,%esp
  802c69:	5b                   	pop    %ebx
  802c6a:	5e                   	pop    %esi
  802c6b:	5d                   	pop    %ebp
  802c6c:	c3                   	ret    
  802c6d:	00 00                	add    %al,(%eax)
	...

00802c70 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  802c70:	55                   	push   %ebp
  802c71:	89 e5                	mov    %esp,%ebp
	pte_t pte;

	if (!(vpd[PDX(v)] & PTE_P))
  802c73:	8b 45 08             	mov    0x8(%ebp),%eax
  802c76:	89 c2                	mov    %eax,%edx
  802c78:	c1 ea 16             	shr    $0x16,%edx
  802c7b:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  802c82:	f6 c2 01             	test   $0x1,%dl
  802c85:	74 26                	je     802cad <pageref+0x3d>
		return 0;
	pte = vpt[VPN(v)];
  802c87:	c1 e8 0c             	shr    $0xc,%eax
  802c8a:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
	if (!(pte & PTE_P))
  802c91:	a8 01                	test   $0x1,%al
  802c93:	74 18                	je     802cad <pageref+0x3d>
		return 0;
	return pages[PPN(pte)].pp_ref;
  802c95:	c1 e8 0c             	shr    $0xc,%eax
  802c98:	8d 14 40             	lea    (%eax,%eax,2),%edx
  802c9b:	c1 e2 02             	shl    $0x2,%edx
  802c9e:	b8 00 00 00 ef       	mov    $0xef000000,%eax
  802ca3:	0f b7 44 02 08       	movzwl 0x8(%edx,%eax,1),%eax
  802ca8:	0f b7 c0             	movzwl %ax,%eax
  802cab:	eb 05                	jmp    802cb2 <pageref+0x42>
  802cad:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802cb2:	5d                   	pop    %ebp
  802cb3:	c3                   	ret    
	...

00802cc0 <__udivdi3>:
  802cc0:	55                   	push   %ebp
  802cc1:	89 e5                	mov    %esp,%ebp
  802cc3:	57                   	push   %edi
  802cc4:	56                   	push   %esi
  802cc5:	83 ec 10             	sub    $0x10,%esp
  802cc8:	8b 45 14             	mov    0x14(%ebp),%eax
  802ccb:	8b 55 08             	mov    0x8(%ebp),%edx
  802cce:	8b 75 10             	mov    0x10(%ebp),%esi
  802cd1:	8b 7d 0c             	mov    0xc(%ebp),%edi
  802cd4:	85 c0                	test   %eax,%eax
  802cd6:	89 55 f0             	mov    %edx,-0x10(%ebp)
  802cd9:	75 35                	jne    802d10 <__udivdi3+0x50>
  802cdb:	39 fe                	cmp    %edi,%esi
  802cdd:	77 61                	ja     802d40 <__udivdi3+0x80>
  802cdf:	85 f6                	test   %esi,%esi
  802ce1:	75 0b                	jne    802cee <__udivdi3+0x2e>
  802ce3:	b8 01 00 00 00       	mov    $0x1,%eax
  802ce8:	31 d2                	xor    %edx,%edx
  802cea:	f7 f6                	div    %esi
  802cec:	89 c6                	mov    %eax,%esi
  802cee:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  802cf1:	31 d2                	xor    %edx,%edx
  802cf3:	89 f8                	mov    %edi,%eax
  802cf5:	f7 f6                	div    %esi
  802cf7:	89 c7                	mov    %eax,%edi
  802cf9:	89 c8                	mov    %ecx,%eax
  802cfb:	f7 f6                	div    %esi
  802cfd:	89 c1                	mov    %eax,%ecx
  802cff:	89 fa                	mov    %edi,%edx
  802d01:	89 c8                	mov    %ecx,%eax
  802d03:	83 c4 10             	add    $0x10,%esp
  802d06:	5e                   	pop    %esi
  802d07:	5f                   	pop    %edi
  802d08:	5d                   	pop    %ebp
  802d09:	c3                   	ret    
  802d0a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  802d10:	39 f8                	cmp    %edi,%eax
  802d12:	77 1c                	ja     802d30 <__udivdi3+0x70>
  802d14:	0f bd d0             	bsr    %eax,%edx
  802d17:	83 f2 1f             	xor    $0x1f,%edx
  802d1a:	89 55 f4             	mov    %edx,-0xc(%ebp)
  802d1d:	75 39                	jne    802d58 <__udivdi3+0x98>
  802d1f:	3b 75 f0             	cmp    -0x10(%ebp),%esi
  802d22:	0f 86 a0 00 00 00    	jbe    802dc8 <__udivdi3+0x108>
  802d28:	39 f8                	cmp    %edi,%eax
  802d2a:	0f 82 98 00 00 00    	jb     802dc8 <__udivdi3+0x108>
  802d30:	31 ff                	xor    %edi,%edi
  802d32:	31 c9                	xor    %ecx,%ecx
  802d34:	89 c8                	mov    %ecx,%eax
  802d36:	89 fa                	mov    %edi,%edx
  802d38:	83 c4 10             	add    $0x10,%esp
  802d3b:	5e                   	pop    %esi
  802d3c:	5f                   	pop    %edi
  802d3d:	5d                   	pop    %ebp
  802d3e:	c3                   	ret    
  802d3f:	90                   	nop
  802d40:	89 d1                	mov    %edx,%ecx
  802d42:	89 fa                	mov    %edi,%edx
  802d44:	89 c8                	mov    %ecx,%eax
  802d46:	31 ff                	xor    %edi,%edi
  802d48:	f7 f6                	div    %esi
  802d4a:	89 c1                	mov    %eax,%ecx
  802d4c:	89 fa                	mov    %edi,%edx
  802d4e:	89 c8                	mov    %ecx,%eax
  802d50:	83 c4 10             	add    $0x10,%esp
  802d53:	5e                   	pop    %esi
  802d54:	5f                   	pop    %edi
  802d55:	5d                   	pop    %ebp
  802d56:	c3                   	ret    
  802d57:	90                   	nop
  802d58:	0f b6 4d f4          	movzbl -0xc(%ebp),%ecx
  802d5c:	89 f2                	mov    %esi,%edx
  802d5e:	d3 e0                	shl    %cl,%eax
  802d60:	89 45 ec             	mov    %eax,-0x14(%ebp)
  802d63:	b8 20 00 00 00       	mov    $0x20,%eax
  802d68:	2b 45 f4             	sub    -0xc(%ebp),%eax
  802d6b:	89 c1                	mov    %eax,%ecx
  802d6d:	d3 ea                	shr    %cl,%edx
  802d6f:	0f b6 4d f4          	movzbl -0xc(%ebp),%ecx
  802d73:	0b 55 ec             	or     -0x14(%ebp),%edx
  802d76:	d3 e6                	shl    %cl,%esi
  802d78:	89 c1                	mov    %eax,%ecx
  802d7a:	89 75 e8             	mov    %esi,-0x18(%ebp)
  802d7d:	89 fe                	mov    %edi,%esi
  802d7f:	d3 ee                	shr    %cl,%esi
  802d81:	0f b6 4d f4          	movzbl -0xc(%ebp),%ecx
  802d85:	89 55 ec             	mov    %edx,-0x14(%ebp)
  802d88:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802d8b:	d3 e7                	shl    %cl,%edi
  802d8d:	89 c1                	mov    %eax,%ecx
  802d8f:	d3 ea                	shr    %cl,%edx
  802d91:	09 d7                	or     %edx,%edi
  802d93:	89 f2                	mov    %esi,%edx
  802d95:	89 f8                	mov    %edi,%eax
  802d97:	f7 75 ec             	divl   -0x14(%ebp)
  802d9a:	89 d6                	mov    %edx,%esi
  802d9c:	89 c7                	mov    %eax,%edi
  802d9e:	f7 65 e8             	mull   -0x18(%ebp)
  802da1:	39 d6                	cmp    %edx,%esi
  802da3:	89 55 ec             	mov    %edx,-0x14(%ebp)
  802da6:	72 30                	jb     802dd8 <__udivdi3+0x118>
  802da8:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802dab:	0f b6 4d f4          	movzbl -0xc(%ebp),%ecx
  802daf:	d3 e2                	shl    %cl,%edx
  802db1:	39 c2                	cmp    %eax,%edx
  802db3:	73 05                	jae    802dba <__udivdi3+0xfa>
  802db5:	3b 75 ec             	cmp    -0x14(%ebp),%esi
  802db8:	74 1e                	je     802dd8 <__udivdi3+0x118>
  802dba:	89 f9                	mov    %edi,%ecx
  802dbc:	31 ff                	xor    %edi,%edi
  802dbe:	e9 71 ff ff ff       	jmp    802d34 <__udivdi3+0x74>
  802dc3:	90                   	nop
  802dc4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802dc8:	31 ff                	xor    %edi,%edi
  802dca:	b9 01 00 00 00       	mov    $0x1,%ecx
  802dcf:	e9 60 ff ff ff       	jmp    802d34 <__udivdi3+0x74>
  802dd4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802dd8:	8d 4f ff             	lea    -0x1(%edi),%ecx
  802ddb:	31 ff                	xor    %edi,%edi
  802ddd:	89 c8                	mov    %ecx,%eax
  802ddf:	89 fa                	mov    %edi,%edx
  802de1:	83 c4 10             	add    $0x10,%esp
  802de4:	5e                   	pop    %esi
  802de5:	5f                   	pop    %edi
  802de6:	5d                   	pop    %ebp
  802de7:	c3                   	ret    
	...

00802df0 <__umoddi3>:
  802df0:	55                   	push   %ebp
  802df1:	89 e5                	mov    %esp,%ebp
  802df3:	57                   	push   %edi
  802df4:	56                   	push   %esi
  802df5:	83 ec 20             	sub    $0x20,%esp
  802df8:	8b 55 14             	mov    0x14(%ebp),%edx
  802dfb:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802dfe:	8b 7d 10             	mov    0x10(%ebp),%edi
  802e01:	8b 75 0c             	mov    0xc(%ebp),%esi
  802e04:	85 d2                	test   %edx,%edx
  802e06:	89 c8                	mov    %ecx,%eax
  802e08:	89 4d f4             	mov    %ecx,-0xc(%ebp)
  802e0b:	75 13                	jne    802e20 <__umoddi3+0x30>
  802e0d:	39 f7                	cmp    %esi,%edi
  802e0f:	76 3f                	jbe    802e50 <__umoddi3+0x60>
  802e11:	89 f2                	mov    %esi,%edx
  802e13:	f7 f7                	div    %edi
  802e15:	89 d0                	mov    %edx,%eax
  802e17:	31 d2                	xor    %edx,%edx
  802e19:	83 c4 20             	add    $0x20,%esp
  802e1c:	5e                   	pop    %esi
  802e1d:	5f                   	pop    %edi
  802e1e:	5d                   	pop    %ebp
  802e1f:	c3                   	ret    
  802e20:	39 f2                	cmp    %esi,%edx
  802e22:	77 4c                	ja     802e70 <__umoddi3+0x80>
  802e24:	0f bd ca             	bsr    %edx,%ecx
  802e27:	83 f1 1f             	xor    $0x1f,%ecx
  802e2a:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  802e2d:	75 51                	jne    802e80 <__umoddi3+0x90>
  802e2f:	3b 7d f4             	cmp    -0xc(%ebp),%edi
  802e32:	0f 87 e0 00 00 00    	ja     802f18 <__umoddi3+0x128>
  802e38:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e3b:	29 f8                	sub    %edi,%eax
  802e3d:	19 d6                	sbb    %edx,%esi
  802e3f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802e42:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e45:	89 f2                	mov    %esi,%edx
  802e47:	83 c4 20             	add    $0x20,%esp
  802e4a:	5e                   	pop    %esi
  802e4b:	5f                   	pop    %edi
  802e4c:	5d                   	pop    %ebp
  802e4d:	c3                   	ret    
  802e4e:	66 90                	xchg   %ax,%ax
  802e50:	85 ff                	test   %edi,%edi
  802e52:	75 0b                	jne    802e5f <__umoddi3+0x6f>
  802e54:	b8 01 00 00 00       	mov    $0x1,%eax
  802e59:	31 d2                	xor    %edx,%edx
  802e5b:	f7 f7                	div    %edi
  802e5d:	89 c7                	mov    %eax,%edi
  802e5f:	89 f0                	mov    %esi,%eax
  802e61:	31 d2                	xor    %edx,%edx
  802e63:	f7 f7                	div    %edi
  802e65:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e68:	f7 f7                	div    %edi
  802e6a:	eb a9                	jmp    802e15 <__umoddi3+0x25>
  802e6c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802e70:	89 c8                	mov    %ecx,%eax
  802e72:	89 f2                	mov    %esi,%edx
  802e74:	83 c4 20             	add    $0x20,%esp
  802e77:	5e                   	pop    %esi
  802e78:	5f                   	pop    %edi
  802e79:	5d                   	pop    %ebp
  802e7a:	c3                   	ret    
  802e7b:	90                   	nop
  802e7c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802e80:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
  802e84:	d3 e2                	shl    %cl,%edx
  802e86:	89 55 f4             	mov    %edx,-0xc(%ebp)
  802e89:	ba 20 00 00 00       	mov    $0x20,%edx
  802e8e:	2b 55 f0             	sub    -0x10(%ebp),%edx
  802e91:	89 55 ec             	mov    %edx,-0x14(%ebp)
  802e94:	0f b6 4d ec          	movzbl -0x14(%ebp),%ecx
  802e98:	89 fa                	mov    %edi,%edx
  802e9a:	d3 ea                	shr    %cl,%edx
  802e9c:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
  802ea0:	0b 55 f4             	or     -0xc(%ebp),%edx
  802ea3:	d3 e7                	shl    %cl,%edi
  802ea5:	0f b6 4d ec          	movzbl -0x14(%ebp),%ecx
  802ea9:	89 55 f4             	mov    %edx,-0xc(%ebp)
  802eac:	89 f2                	mov    %esi,%edx
  802eae:	89 7d e8             	mov    %edi,-0x18(%ebp)
  802eb1:	89 c7                	mov    %eax,%edi
  802eb3:	d3 ea                	shr    %cl,%edx
  802eb5:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
  802eb9:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  802ebc:	89 c2                	mov    %eax,%edx
  802ebe:	d3 e6                	shl    %cl,%esi
  802ec0:	0f b6 4d ec          	movzbl -0x14(%ebp),%ecx
  802ec4:	d3 ea                	shr    %cl,%edx
  802ec6:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
  802eca:	09 d6                	or     %edx,%esi
  802ecc:	89 f0                	mov    %esi,%eax
  802ece:	8b 75 e4             	mov    -0x1c(%ebp),%esi
  802ed1:	d3 e7                	shl    %cl,%edi
  802ed3:	89 f2                	mov    %esi,%edx
  802ed5:	f7 75 f4             	divl   -0xc(%ebp)
  802ed8:	89 d6                	mov    %edx,%esi
  802eda:	f7 65 e8             	mull   -0x18(%ebp)
  802edd:	39 d6                	cmp    %edx,%esi
  802edf:	72 2b                	jb     802f0c <__umoddi3+0x11c>
  802ee1:	39 c7                	cmp    %eax,%edi
  802ee3:	72 23                	jb     802f08 <__umoddi3+0x118>
  802ee5:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
  802ee9:	29 c7                	sub    %eax,%edi
  802eeb:	19 d6                	sbb    %edx,%esi
  802eed:	89 f0                	mov    %esi,%eax
  802eef:	89 f2                	mov    %esi,%edx
  802ef1:	d3 ef                	shr    %cl,%edi
  802ef3:	0f b6 4d ec          	movzbl -0x14(%ebp),%ecx
  802ef7:	d3 e0                	shl    %cl,%eax
  802ef9:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
  802efd:	09 f8                	or     %edi,%eax
  802eff:	d3 ea                	shr    %cl,%edx
  802f01:	83 c4 20             	add    $0x20,%esp
  802f04:	5e                   	pop    %esi
  802f05:	5f                   	pop    %edi
  802f06:	5d                   	pop    %ebp
  802f07:	c3                   	ret    
  802f08:	39 d6                	cmp    %edx,%esi
  802f0a:	75 d9                	jne    802ee5 <__umoddi3+0xf5>
  802f0c:	2b 45 e8             	sub    -0x18(%ebp),%eax
  802f0f:	1b 55 f4             	sbb    -0xc(%ebp),%edx
  802f12:	eb d1                	jmp    802ee5 <__umoddi3+0xf5>
  802f14:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802f18:	39 f2                	cmp    %esi,%edx
  802f1a:	0f 82 18 ff ff ff    	jb     802e38 <__umoddi3+0x48>
  802f20:	e9 1d ff ff ff       	jmp    802e42 <__umoddi3+0x52>
