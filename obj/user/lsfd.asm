
obj/user/lsfd:     file format elf32-i386


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
  80002c:	e8 67 01 00 00       	call   800198 <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>
	...

00800040 <usage>:
#include <inc/lib.h>

void
usage(void)
{
  800040:	55                   	push   %ebp
  800041:	89 e5                	mov    %esp,%ebp
  800043:	83 ec 18             	sub    $0x18,%esp
	cprintf("usage: lsfd [-1]\n");
  800046:	c7 04 24 80 2a 80 00 	movl   $0x802a80,(%esp)
  80004d:	e8 77 02 00 00       	call   8002c9 <cprintf>
	exit();
  800052:	e8 91 01 00 00       	call   8001e8 <exit>
}
  800057:	c9                   	leave  
  800058:	c3                   	ret    

00800059 <umain>:

void
umain(int argc, char **argv)
{
  800059:	55                   	push   %ebp
  80005a:	89 e5                	mov    %esp,%ebp
  80005c:	57                   	push   %edi
  80005d:	56                   	push   %esi
  80005e:	53                   	push   %ebx
  80005f:	81 ec cc 00 00 00    	sub    $0xcc,%esp
  800065:	8b 45 0c             	mov    0xc(%ebp),%eax
	int i, usefprint = 0;
	struct Stat st;

	ARGBEGIN{
  800068:	85 c0                	test   %eax,%eax
  80006a:	75 03                	jne    80006f <umain+0x16>
  80006c:	8d 45 08             	lea    0x8(%ebp),%eax
  80006f:	83 3d 78 60 80 00 00 	cmpl   $0x0,0x806078
  800076:	75 08                	jne    800080 <umain+0x27>
  800078:	8b 10                	mov    (%eax),%edx
  80007a:	89 15 78 60 80 00    	mov    %edx,0x806078
  800080:	83 c0 04             	add    $0x4,%eax
  800083:	89 85 54 ff ff ff    	mov    %eax,-0xac(%ebp)
  800089:	83 6d 08 01          	subl   $0x1,0x8(%ebp)
  80008d:	8b 18                	mov    (%eax),%ebx
  80008f:	85 db                	test   %ebx,%ebx
  800091:	74 29                	je     8000bc <umain+0x63>
  800093:	80 3b 2d             	cmpb   $0x2d,(%ebx)
  800096:	75 24                	jne    8000bc <umain+0x63>
  800098:	83 c3 01             	add    $0x1,%ebx
  80009b:	0f b6 03             	movzbl (%ebx),%eax
  80009e:	84 c0                	test   %al,%al
  8000a0:	74 1a                	je     8000bc <umain+0x63>
  8000a2:	be 00 00 00 00       	mov    $0x0,%esi
  8000a7:	bf 01 00 00 00       	mov    $0x1,%edi
  8000ac:	3c 2d                	cmp    $0x2d,%al
  8000ae:	75 28                	jne    8000d8 <umain+0x7f>
  8000b0:	80 7b 01 00          	cmpb   $0x0,0x1(%ebx)
  8000b4:	75 22                	jne    8000d8 <umain+0x7f>
  8000b6:	83 6d 08 01          	subl   $0x1,0x8(%ebp)
  8000ba:	eb 05                	jmp    8000c1 <umain+0x68>
  8000bc:	be 00 00 00 00       	mov    $0x0,%esi
  8000c1:	bb 00 00 00 00       	mov    $0x0,%ebx
		usefprint = 1;
		break;
	}ARGEND

	for (i = 0; i < 32; i++)
		if (fstat(i, &st) >= 0) {
  8000c6:	8d bd 5c ff ff ff    	lea    -0xa4(%ebp),%edi
  8000cc:	eb 3f                	jmp    80010d <umain+0xb4>
	int i, usefprint = 0;
	struct Stat st;

	ARGBEGIN{
	default:
		usage();
  8000ce:	e8 6d ff ff ff       	call   800040 <usage>
umain(int argc, char **argv)
{
	int i, usefprint = 0;
	struct Stat st;

	ARGBEGIN{
  8000d3:	83 c3 01             	add    $0x1,%ebx
  8000d6:	89 fe                	mov    %edi,%esi
  8000d8:	0f b6 03             	movzbl (%ebx),%eax
  8000db:	84 c0                	test   %al,%al
  8000dd:	74 06                	je     8000e5 <umain+0x8c>
  8000df:	3c 31                	cmp    $0x31,%al
  8000e1:	75 eb                	jne    8000ce <umain+0x75>
  8000e3:	eb ee                	jmp    8000d3 <umain+0x7a>
  8000e5:	83 6d 08 01          	subl   $0x1,0x8(%ebp)
  8000e9:	83 85 54 ff ff ff 04 	addl   $0x4,-0xac(%ebp)
  8000f0:	8b 85 54 ff ff ff    	mov    -0xac(%ebp),%eax
  8000f6:	8b 18                	mov    (%eax),%ebx
  8000f8:	85 db                	test   %ebx,%ebx
  8000fa:	74 c5                	je     8000c1 <umain+0x68>
  8000fc:	80 3b 2d             	cmpb   $0x2d,(%ebx)
  8000ff:	75 c0                	jne    8000c1 <umain+0x68>
  800101:	83 c3 01             	add    $0x1,%ebx
  800104:	0f b6 03             	movzbl (%ebx),%eax
  800107:	84 c0                	test   %al,%al
  800109:	75 a1                	jne    8000ac <umain+0x53>
  80010b:	eb b4                	jmp    8000c1 <umain+0x68>
		usefprint = 1;
		break;
	}ARGEND

	for (i = 0; i < 32; i++)
		if (fstat(i, &st) >= 0) {
  80010d:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800111:	89 1c 24             	mov    %ebx,(%esp)
  800114:	e8 01 13 00 00       	call   80141a <fstat>
  800119:	85 c0                	test   %eax,%eax
  80011b:	78 66                	js     800183 <umain+0x12a>
			if (usefprint)
  80011d:	85 f6                	test   %esi,%esi
  80011f:	74 36                	je     800157 <umain+0xfe>
				fprintf(1, "fd %d: name %s isdir %d size %d dev %s\n",
  800121:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800124:	8b 40 04             	mov    0x4(%eax),%eax
  800127:	89 44 24 18          	mov    %eax,0x18(%esp)
  80012b:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80012e:	89 44 24 14          	mov    %eax,0x14(%esp)
  800132:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800135:	89 44 24 10          	mov    %eax,0x10(%esp)
  800139:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  80013d:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  800141:	c7 44 24 04 94 2a 80 	movl   $0x802a94,0x4(%esp)
  800148:	00 
  800149:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  800150:	e8 c0 1a 00 00       	call   801c15 <fprintf>
  800155:	eb 2c                	jmp    800183 <umain+0x12a>
					i, st.st_name, st.st_isdir,
					st.st_size, st.st_dev->dev_name);	
			else
				cprintf("fd %d: name %s isdir %d size %d dev %s\n",
  800157:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80015a:	8b 40 04             	mov    0x4(%eax),%eax
  80015d:	89 44 24 14          	mov    %eax,0x14(%esp)
  800161:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800164:	89 44 24 10          	mov    %eax,0x10(%esp)
  800168:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80016b:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80016f:	89 7c 24 08          	mov    %edi,0x8(%esp)
  800173:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  800177:	c7 04 24 94 2a 80 00 	movl   $0x802a94,(%esp)
  80017e:	e8 46 01 00 00       	call   8002c9 <cprintf>
	case '1':
		usefprint = 1;
		break;
	}ARGEND

	for (i = 0; i < 32; i++)
  800183:	83 c3 01             	add    $0x1,%ebx
  800186:	83 fb 20             	cmp    $0x20,%ebx
  800189:	75 82                	jne    80010d <umain+0xb4>
			else
				cprintf("fd %d: name %s isdir %d size %d dev %s\n",
					i, st.st_name, st.st_isdir,
					st.st_size, st.st_dev->dev_name);
		}
}
  80018b:	81 c4 cc 00 00 00    	add    $0xcc,%esp
  800191:	5b                   	pop    %ebx
  800192:	5e                   	pop    %esi
  800193:	5f                   	pop    %edi
  800194:	5d                   	pop    %ebp
  800195:	c3                   	ret    
	...

00800198 <libmain>:
volatile struct Env *env;
char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  800198:	55                   	push   %ebp
  800199:	89 e5                	mov    %esp,%ebp
  80019b:	83 ec 18             	sub    $0x18,%esp
  80019e:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  8001a1:	89 75 fc             	mov    %esi,-0x4(%ebp)
  8001a4:	8b 75 08             	mov    0x8(%ebp),%esi
  8001a7:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	// set env to point at our env structure in envs[].
	// LAB 3b: Your code here.
	// Code added by Swastika / Sandeep	
	envid_t envid = sys_getenvid();
  8001aa:	e8 5f 10 00 00       	call   80120e <sys_getenvid>
	env = &envs[ENVX(envid)];
  8001af:	25 ff 03 00 00       	and    $0x3ff,%eax
  8001b4:	6b c0 7c             	imul   $0x7c,%eax,%eax
  8001b7:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8001bc:	a3 74 60 80 00       	mov    %eax,0x806074

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8001c1:	85 f6                	test   %esi,%esi
  8001c3:	7e 07                	jle    8001cc <libmain+0x34>
		binaryname = argv[0];
  8001c5:	8b 03                	mov    (%ebx),%eax
  8001c7:	a3 00 60 80 00       	mov    %eax,0x806000

	// call user main routine
	umain(argc, argv);
  8001cc:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8001d0:	89 34 24             	mov    %esi,(%esp)
  8001d3:	e8 81 fe ff ff       	call   800059 <umain>

	// exit gracefully
	exit();
  8001d8:	e8 0b 00 00 00       	call   8001e8 <exit>
}
  8001dd:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  8001e0:	8b 75 fc             	mov    -0x4(%ebp),%esi
  8001e3:	89 ec                	mov    %ebp,%esp
  8001e5:	5d                   	pop    %ebp
  8001e6:	c3                   	ret    
	...

008001e8 <exit>:
#include <inc/lib.h>

void
exit(void)
{
  8001e8:	55                   	push   %ebp
  8001e9:	89 e5                	mov    %esp,%ebp
  8001eb:	83 ec 18             	sub    $0x18,%esp
	close_all();
  8001ee:	e8 88 15 00 00       	call   80177b <close_all>
	sys_env_destroy(0);
  8001f3:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8001fa:	e8 43 10 00 00       	call   801242 <sys_env_destroy>
}
  8001ff:	c9                   	leave  
  800200:	c3                   	ret    
  800201:	00 00                	add    %al,(%eax)
	...

00800204 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  800204:	55                   	push   %ebp
  800205:	89 e5                	mov    %esp,%ebp
  800207:	53                   	push   %ebx
  800208:	83 ec 14             	sub    $0x14,%esp
 * Panic is called on unresolvable fatal errors.
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
  80020b:	8d 5d 14             	lea    0x14(%ebp),%ebx
	va_list ap;

	va_start(ap, fmt);

	// Print the panic message
	if (argv0)
  80020e:	a1 78 60 80 00       	mov    0x806078,%eax
  800213:	85 c0                	test   %eax,%eax
  800215:	74 10                	je     800227 <_panic+0x23>
		cprintf("%s: ", argv0);
  800217:	89 44 24 04          	mov    %eax,0x4(%esp)
  80021b:	c7 04 24 d3 2a 80 00 	movl   $0x802ad3,(%esp)
  800222:	e8 a2 00 00 00       	call   8002c9 <cprintf>
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  800227:	8b 45 0c             	mov    0xc(%ebp),%eax
  80022a:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80022e:	8b 45 08             	mov    0x8(%ebp),%eax
  800231:	89 44 24 08          	mov    %eax,0x8(%esp)
  800235:	a1 00 60 80 00       	mov    0x806000,%eax
  80023a:	89 44 24 04          	mov    %eax,0x4(%esp)
  80023e:	c7 04 24 d8 2a 80 00 	movl   $0x802ad8,(%esp)
  800245:	e8 7f 00 00 00       	call   8002c9 <cprintf>
	vcprintf(fmt, ap);
  80024a:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  80024e:	8b 45 10             	mov    0x10(%ebp),%eax
  800251:	89 04 24             	mov    %eax,(%esp)
  800254:	e8 0f 00 00 00       	call   800268 <vcprintf>
	cprintf("\n");
  800259:	c7 04 24 90 2a 80 00 	movl   $0x802a90,(%esp)
  800260:	e8 64 00 00 00       	call   8002c9 <cprintf>

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  800265:	cc                   	int3   
  800266:	eb fd                	jmp    800265 <_panic+0x61>

00800268 <vcprintf>:
	b->cnt++;
}

int
vcprintf(const char *fmt, va_list ap)
{
  800268:	55                   	push   %ebp
  800269:	89 e5                	mov    %esp,%ebp
  80026b:	81 ec 28 01 00 00    	sub    $0x128,%esp
	struct printbuf b;

	b.idx = 0;
  800271:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800278:	00 00 00 
	b.cnt = 0;
  80027b:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800282:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  800285:	8b 45 0c             	mov    0xc(%ebp),%eax
  800288:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80028c:	8b 45 08             	mov    0x8(%ebp),%eax
  80028f:	89 44 24 08          	mov    %eax,0x8(%esp)
  800293:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800299:	89 44 24 04          	mov    %eax,0x4(%esp)
  80029d:	c7 04 24 e3 02 80 00 	movl   $0x8002e3,(%esp)
  8002a4:	e8 d4 01 00 00       	call   80047d <vprintfmt>
	sys_cputs(b.buf, b.idx);
  8002a9:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
  8002af:	89 44 24 04          	mov    %eax,0x4(%esp)
  8002b3:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  8002b9:	89 04 24             	mov    %eax,(%esp)
  8002bc:	e8 bf 0a 00 00       	call   800d80 <sys_cputs>

	return b.cnt;
}
  8002c1:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  8002c7:	c9                   	leave  
  8002c8:	c3                   	ret    

008002c9 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  8002c9:	55                   	push   %ebp
  8002ca:	89 e5                	mov    %esp,%ebp
  8002cc:	83 ec 18             	sub    $0x18,%esp

	return b.cnt;
}

int
cprintf(const char *fmt, ...)
  8002cf:	8d 45 0c             	lea    0xc(%ebp),%eax
{
	va_list ap;
	int cnt;

	va_start(ap, fmt);
	cnt = vcprintf(fmt, ap);
  8002d2:	89 44 24 04          	mov    %eax,0x4(%esp)
  8002d6:	8b 45 08             	mov    0x8(%ebp),%eax
  8002d9:	89 04 24             	mov    %eax,(%esp)
  8002dc:	e8 87 ff ff ff       	call   800268 <vcprintf>
	va_end(ap);

	return cnt;
}
  8002e1:	c9                   	leave  
  8002e2:	c3                   	ret    

008002e3 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  8002e3:	55                   	push   %ebp
  8002e4:	89 e5                	mov    %esp,%ebp
  8002e6:	53                   	push   %ebx
  8002e7:	83 ec 14             	sub    $0x14,%esp
  8002ea:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  8002ed:	8b 03                	mov    (%ebx),%eax
  8002ef:	8b 55 08             	mov    0x8(%ebp),%edx
  8002f2:	88 54 03 08          	mov    %dl,0x8(%ebx,%eax,1)
  8002f6:	83 c0 01             	add    $0x1,%eax
  8002f9:	89 03                	mov    %eax,(%ebx)
	if (b->idx == 256-1) {
  8002fb:	3d ff 00 00 00       	cmp    $0xff,%eax
  800300:	75 19                	jne    80031b <putch+0x38>
		sys_cputs(b->buf, b->idx);
  800302:	c7 44 24 04 ff 00 00 	movl   $0xff,0x4(%esp)
  800309:	00 
  80030a:	8d 43 08             	lea    0x8(%ebx),%eax
  80030d:	89 04 24             	mov    %eax,(%esp)
  800310:	e8 6b 0a 00 00       	call   800d80 <sys_cputs>
		b->idx = 0;
  800315:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
	}
	b->cnt++;
  80031b:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  80031f:	83 c4 14             	add    $0x14,%esp
  800322:	5b                   	pop    %ebx
  800323:	5d                   	pop    %ebp
  800324:	c3                   	ret    
	...

00800330 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800330:	55                   	push   %ebp
  800331:	89 e5                	mov    %esp,%ebp
  800333:	57                   	push   %edi
  800334:	56                   	push   %esi
  800335:	53                   	push   %ebx
  800336:	83 ec 4c             	sub    $0x4c,%esp
  800339:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80033c:	89 d6                	mov    %edx,%esi
  80033e:	8b 45 08             	mov    0x8(%ebp),%eax
  800341:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800344:	8b 55 0c             	mov    0xc(%ebp),%edx
  800347:	89 55 e0             	mov    %edx,-0x20(%ebp)
  80034a:	8b 45 10             	mov    0x10(%ebp),%eax
  80034d:	8b 5d 14             	mov    0x14(%ebp),%ebx
  800350:	8b 7d 18             	mov    0x18(%ebp),%edi
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800353:	89 45 dc             	mov    %eax,-0x24(%ebp)
  800356:	b9 00 00 00 00       	mov    $0x0,%ecx
  80035b:	39 d1                	cmp    %edx,%ecx
  80035d:	72 15                	jb     800374 <printnum+0x44>
  80035f:	77 07                	ja     800368 <printnum+0x38>
  800361:	8b 55 d8             	mov    -0x28(%ebp),%edx
  800364:	39 d0                	cmp    %edx,%eax
  800366:	76 0c                	jbe    800374 <printnum+0x44>
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800368:	83 eb 01             	sub    $0x1,%ebx
  80036b:	85 db                	test   %ebx,%ebx
  80036d:	8d 76 00             	lea    0x0(%esi),%esi
  800370:	7f 61                	jg     8003d3 <printnum+0xa3>
  800372:	eb 70                	jmp    8003e4 <printnum+0xb4>
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800374:	89 7c 24 10          	mov    %edi,0x10(%esp)
  800378:	83 eb 01             	sub    $0x1,%ebx
  80037b:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  80037f:	89 44 24 08          	mov    %eax,0x8(%esp)
  800383:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  800387:	8b 5c 24 0c          	mov    0xc(%esp),%ebx
  80038b:	89 4d d0             	mov    %ecx,-0x30(%ebp)
  80038e:	89 5d d4             	mov    %ebx,-0x2c(%ebp)
  800391:	8b 5d dc             	mov    -0x24(%ebp),%ebx
  800394:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  800398:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  80039f:	00 
  8003a0:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8003a3:	89 04 24             	mov    %eax,(%esp)
  8003a6:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8003a9:	89 54 24 04          	mov    %edx,0x4(%esp)
  8003ad:	e8 4e 24 00 00       	call   802800 <__udivdi3>
  8003b2:	8b 4d d0             	mov    -0x30(%ebp),%ecx
  8003b5:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
  8003b8:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8003bc:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  8003c0:	89 04 24             	mov    %eax,(%esp)
  8003c3:	89 54 24 04          	mov    %edx,0x4(%esp)
  8003c7:	89 f2                	mov    %esi,%edx
  8003c9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8003cc:	e8 5f ff ff ff       	call   800330 <printnum>
  8003d1:	eb 11                	jmp    8003e4 <printnum+0xb4>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  8003d3:	89 74 24 04          	mov    %esi,0x4(%esp)
  8003d7:	89 3c 24             	mov    %edi,(%esp)
  8003da:	ff 55 e4             	call   *-0x1c(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8003dd:	83 eb 01             	sub    $0x1,%ebx
  8003e0:	85 db                	test   %ebx,%ebx
  8003e2:	7f ef                	jg     8003d3 <printnum+0xa3>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8003e4:	89 74 24 04          	mov    %esi,0x4(%esp)
  8003e8:	8b 74 24 04          	mov    0x4(%esp),%esi
  8003ec:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8003ef:	89 44 24 08          	mov    %eax,0x8(%esp)
  8003f3:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  8003fa:	00 
  8003fb:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8003fe:	89 14 24             	mov    %edx,(%esp)
  800401:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  800404:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  800408:	e8 23 25 00 00       	call   802930 <__umoddi3>
  80040d:	89 74 24 04          	mov    %esi,0x4(%esp)
  800411:	0f be 80 f4 2a 80 00 	movsbl 0x802af4(%eax),%eax
  800418:	89 04 24             	mov    %eax,(%esp)
  80041b:	ff 55 e4             	call   *-0x1c(%ebp)
}
  80041e:	83 c4 4c             	add    $0x4c,%esp
  800421:	5b                   	pop    %ebx
  800422:	5e                   	pop    %esi
  800423:	5f                   	pop    %edi
  800424:	5d                   	pop    %ebp
  800425:	c3                   	ret    

00800426 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800426:	55                   	push   %ebp
  800427:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800429:	83 fa 01             	cmp    $0x1,%edx
  80042c:	7e 0e                	jle    80043c <getuint+0x16>
		return va_arg(*ap, unsigned long long);
  80042e:	8b 10                	mov    (%eax),%edx
  800430:	8d 4a 08             	lea    0x8(%edx),%ecx
  800433:	89 08                	mov    %ecx,(%eax)
  800435:	8b 02                	mov    (%edx),%eax
  800437:	8b 52 04             	mov    0x4(%edx),%edx
  80043a:	eb 22                	jmp    80045e <getuint+0x38>
	else if (lflag)
  80043c:	85 d2                	test   %edx,%edx
  80043e:	74 10                	je     800450 <getuint+0x2a>
		return va_arg(*ap, unsigned long);
  800440:	8b 10                	mov    (%eax),%edx
  800442:	8d 4a 04             	lea    0x4(%edx),%ecx
  800445:	89 08                	mov    %ecx,(%eax)
  800447:	8b 02                	mov    (%edx),%eax
  800449:	ba 00 00 00 00       	mov    $0x0,%edx
  80044e:	eb 0e                	jmp    80045e <getuint+0x38>
	else
		return va_arg(*ap, unsigned int);
  800450:	8b 10                	mov    (%eax),%edx
  800452:	8d 4a 04             	lea    0x4(%edx),%ecx
  800455:	89 08                	mov    %ecx,(%eax)
  800457:	8b 02                	mov    (%edx),%eax
  800459:	ba 00 00 00 00       	mov    $0x0,%edx
}
  80045e:	5d                   	pop    %ebp
  80045f:	c3                   	ret    

00800460 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800460:	55                   	push   %ebp
  800461:	89 e5                	mov    %esp,%ebp
  800463:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  800466:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  80046a:	8b 10                	mov    (%eax),%edx
  80046c:	3b 50 04             	cmp    0x4(%eax),%edx
  80046f:	73 0a                	jae    80047b <sprintputch+0x1b>
		*b->buf++ = ch;
  800471:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800474:	88 0a                	mov    %cl,(%edx)
  800476:	83 c2 01             	add    $0x1,%edx
  800479:	89 10                	mov    %edx,(%eax)
}
  80047b:	5d                   	pop    %ebp
  80047c:	c3                   	ret    

0080047d <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  80047d:	55                   	push   %ebp
  80047e:	89 e5                	mov    %esp,%ebp
  800480:	57                   	push   %edi
  800481:	56                   	push   %esi
  800482:	53                   	push   %ebx
  800483:	83 ec 5c             	sub    $0x5c,%esp
  800486:	8b 7d 08             	mov    0x8(%ebp),%edi
  800489:	8b 75 0c             	mov    0xc(%ebp),%esi
  80048c:	8b 5d 10             	mov    0x10(%ebp),%ebx
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  80048f:	c7 45 c8 ff ff ff ff 	movl   $0xffffffff,-0x38(%ebp)
  800496:	eb 11                	jmp    8004a9 <vprintfmt+0x2c>
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
  800498:	85 c0                	test   %eax,%eax
  80049a:	0f 84 ec 03 00 00    	je     80088c <vprintfmt+0x40f>
				return;
			putch(ch, putdat);
  8004a0:	89 74 24 04          	mov    %esi,0x4(%esp)
  8004a4:	89 04 24             	mov    %eax,(%esp)
  8004a7:	ff d7                	call   *%edi
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8004a9:	0f b6 03             	movzbl (%ebx),%eax
  8004ac:	83 c3 01             	add    $0x1,%ebx
  8004af:	83 f8 25             	cmp    $0x25,%eax
  8004b2:	75 e4                	jne    800498 <vprintfmt+0x1b>
  8004b4:	c6 45 d4 20          	movb   $0x20,-0x2c(%ebp)
  8004b8:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
  8004bf:	c7 45 d0 ff ff ff ff 	movl   $0xffffffff,-0x30(%ebp)
  8004c6:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
  8004cd:	b9 00 00 00 00       	mov    $0x0,%ecx
  8004d2:	eb 06                	jmp    8004da <vprintfmt+0x5d>
  8004d4:	c6 45 d4 2d          	movb   $0x2d,-0x2c(%ebp)
  8004d8:	89 c3                	mov    %eax,%ebx
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8004da:	0f b6 13             	movzbl (%ebx),%edx
  8004dd:	0f b6 c2             	movzbl %dl,%eax
  8004e0:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8004e3:	8d 43 01             	lea    0x1(%ebx),%eax
  8004e6:	83 ea 23             	sub    $0x23,%edx
  8004e9:	80 fa 55             	cmp    $0x55,%dl
  8004ec:	0f 87 7d 03 00 00    	ja     80086f <vprintfmt+0x3f2>
  8004f2:	0f b6 d2             	movzbl %dl,%edx
  8004f5:	ff 24 95 40 2c 80 00 	jmp    *0x802c40(,%edx,4)
  8004fc:	c6 45 d4 30          	movb   $0x30,-0x2c(%ebp)
  800500:	eb d6                	jmp    8004d8 <vprintfmt+0x5b>
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
				precision = precision * 10 + ch - '0';
  800502:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800505:	83 ea 30             	sub    $0x30,%edx
  800508:	89 55 d0             	mov    %edx,-0x30(%ebp)
				ch = *fmt;
  80050b:	0f be 10             	movsbl (%eax),%edx
				if (ch < '0' || ch > '9')
  80050e:	8d 5a d0             	lea    -0x30(%edx),%ebx
  800511:	83 fb 09             	cmp    $0x9,%ebx
  800514:	77 4c                	ja     800562 <vprintfmt+0xe5>
  800516:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  800519:	8b 4d d0             	mov    -0x30(%ebp),%ecx
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  80051c:	83 c0 01             	add    $0x1,%eax
				precision = precision * 10 + ch - '0';
  80051f:	8d 0c 89             	lea    (%ecx,%ecx,4),%ecx
  800522:	8d 4c 4a d0          	lea    -0x30(%edx,%ecx,2),%ecx
				ch = *fmt;
  800526:	0f be 10             	movsbl (%eax),%edx
				if (ch < '0' || ch > '9')
  800529:	8d 5a d0             	lea    -0x30(%edx),%ebx
  80052c:	83 fb 09             	cmp    $0x9,%ebx
  80052f:	76 eb                	jbe    80051c <vprintfmt+0x9f>
  800531:	89 4d d0             	mov    %ecx,-0x30(%ebp)
  800534:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  800537:	eb 29                	jmp    800562 <vprintfmt+0xe5>
					break;
			}
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800539:	8b 55 14             	mov    0x14(%ebp),%edx
  80053c:	8d 5a 04             	lea    0x4(%edx),%ebx
  80053f:	89 5d 14             	mov    %ebx,0x14(%ebp)
  800542:	8b 12                	mov    (%edx),%edx
  800544:	89 55 d0             	mov    %edx,-0x30(%ebp)
			goto process_precision;
  800547:	eb 19                	jmp    800562 <vprintfmt+0xe5>

		case '.':
			if (width < 0)
  800549:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80054c:	c1 fa 1f             	sar    $0x1f,%edx
  80054f:	f7 d2                	not    %edx
  800551:	21 55 e4             	and    %edx,-0x1c(%ebp)
  800554:	eb 82                	jmp    8004d8 <vprintfmt+0x5b>
  800556:	c7 45 d8 01 00 00 00 	movl   $0x1,-0x28(%ebp)
				width = 0;
			goto reswitch;

		case '#':
			altflag = 1;
			goto reswitch;
  80055d:	e9 76 ff ff ff       	jmp    8004d8 <vprintfmt+0x5b>

		process_precision:
			if (width < 0)
  800562:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800566:	0f 89 6c ff ff ff    	jns    8004d8 <vprintfmt+0x5b>
  80056c:	8b 55 d0             	mov    -0x30(%ebp),%edx
  80056f:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  800572:	8b 55 c8             	mov    -0x38(%ebp),%edx
  800575:	89 55 d0             	mov    %edx,-0x30(%ebp)
  800578:	e9 5b ff ff ff       	jmp    8004d8 <vprintfmt+0x5b>
				width = precision, precision = -1;
			goto reswitch;

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  80057d:	83 c1 01             	add    $0x1,%ecx
			goto reswitch;
  800580:	e9 53 ff ff ff       	jmp    8004d8 <vprintfmt+0x5b>
  800585:	89 45 cc             	mov    %eax,-0x34(%ebp)

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800588:	8b 45 14             	mov    0x14(%ebp),%eax
  80058b:	8d 50 04             	lea    0x4(%eax),%edx
  80058e:	89 55 14             	mov    %edx,0x14(%ebp)
  800591:	89 74 24 04          	mov    %esi,0x4(%esp)
  800595:	8b 00                	mov    (%eax),%eax
  800597:	89 04 24             	mov    %eax,(%esp)
  80059a:	ff d7                	call   *%edi
  80059c:	8b 5d cc             	mov    -0x34(%ebp),%ebx
			break;
  80059f:	e9 05 ff ff ff       	jmp    8004a9 <vprintfmt+0x2c>
  8005a4:	89 45 cc             	mov    %eax,-0x34(%ebp)

		// error message
		case 'e':
			err = va_arg(ap, int);
  8005a7:	8b 45 14             	mov    0x14(%ebp),%eax
  8005aa:	8d 50 04             	lea    0x4(%eax),%edx
  8005ad:	89 55 14             	mov    %edx,0x14(%ebp)
  8005b0:	8b 00                	mov    (%eax),%eax
  8005b2:	89 c2                	mov    %eax,%edx
  8005b4:	c1 fa 1f             	sar    $0x1f,%edx
  8005b7:	31 d0                	xor    %edx,%eax
  8005b9:	29 d0                	sub    %edx,%eax
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  8005bb:	83 f8 0f             	cmp    $0xf,%eax
  8005be:	7f 0b                	jg     8005cb <vprintfmt+0x14e>
  8005c0:	8b 14 85 a0 2d 80 00 	mov    0x802da0(,%eax,4),%edx
  8005c7:	85 d2                	test   %edx,%edx
  8005c9:	75 20                	jne    8005eb <vprintfmt+0x16e>
				printfmt(putch, putdat, "error %d", err);
  8005cb:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8005cf:	c7 44 24 08 05 2b 80 	movl   $0x802b05,0x8(%esp)
  8005d6:	00 
  8005d7:	89 74 24 04          	mov    %esi,0x4(%esp)
  8005db:	89 3c 24             	mov    %edi,(%esp)
  8005de:	e8 31 03 00 00       	call   800914 <printfmt>
  8005e3:	8b 5d cc             	mov    -0x34(%ebp),%ebx
		// error message
		case 'e':
			err = va_arg(ap, int);
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  8005e6:	e9 be fe ff ff       	jmp    8004a9 <vprintfmt+0x2c>
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  8005eb:	89 54 24 0c          	mov    %edx,0xc(%esp)
  8005ef:	c7 44 24 08 e6 2e 80 	movl   $0x802ee6,0x8(%esp)
  8005f6:	00 
  8005f7:	89 74 24 04          	mov    %esi,0x4(%esp)
  8005fb:	89 3c 24             	mov    %edi,(%esp)
  8005fe:	e8 11 03 00 00       	call   800914 <printfmt>
  800603:	8b 5d cc             	mov    -0x34(%ebp),%ebx
  800606:	e9 9e fe ff ff       	jmp    8004a9 <vprintfmt+0x2c>
  80060b:	89 45 cc             	mov    %eax,-0x34(%ebp)
  80060e:	89 c3                	mov    %eax,%ebx
  800610:	8b 4d d0             	mov    -0x30(%ebp),%ecx
  800613:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800616:	89 45 c4             	mov    %eax,-0x3c(%ebp)
			break;

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800619:	8b 45 14             	mov    0x14(%ebp),%eax
  80061c:	8d 50 04             	lea    0x4(%eax),%edx
  80061f:	89 55 14             	mov    %edx,0x14(%ebp)
  800622:	8b 00                	mov    (%eax),%eax
  800624:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800627:	85 c0                	test   %eax,%eax
  800629:	75 07                	jne    800632 <vprintfmt+0x1b5>
  80062b:	c7 45 e0 0e 2b 80 00 	movl   $0x802b0e,-0x20(%ebp)
				p = "(null)";
			if (width > 0 && padc != '-')
  800632:	83 7d c4 00          	cmpl   $0x0,-0x3c(%ebp)
  800636:	7e 06                	jle    80063e <vprintfmt+0x1c1>
  800638:	80 7d d4 2d          	cmpb   $0x2d,-0x2c(%ebp)
  80063c:	75 13                	jne    800651 <vprintfmt+0x1d4>
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  80063e:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800641:	0f be 02             	movsbl (%edx),%eax
  800644:	85 c0                	test   %eax,%eax
  800646:	0f 85 99 00 00 00    	jne    8006e5 <vprintfmt+0x268>
  80064c:	e9 86 00 00 00       	jmp    8006d7 <vprintfmt+0x25a>
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800651:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  800655:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  800658:	89 0c 24             	mov    %ecx,(%esp)
  80065b:	e8 fb 02 00 00       	call   80095b <strnlen>
  800660:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  800663:	29 c2                	sub    %eax,%edx
  800665:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  800668:	85 d2                	test   %edx,%edx
  80066a:	7e d2                	jle    80063e <vprintfmt+0x1c1>
					putch(padc, putdat);
  80066c:	0f be 4d d4          	movsbl -0x2c(%ebp),%ecx
  800670:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  800673:	89 5d c4             	mov    %ebx,-0x3c(%ebp)
  800676:	89 d3                	mov    %edx,%ebx
  800678:	89 74 24 04          	mov    %esi,0x4(%esp)
  80067c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80067f:	89 04 24             	mov    %eax,(%esp)
  800682:	ff d7                	call   *%edi
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800684:	83 eb 01             	sub    $0x1,%ebx
  800687:	85 db                	test   %ebx,%ebx
  800689:	7f ed                	jg     800678 <vprintfmt+0x1fb>
  80068b:	8b 5d c4             	mov    -0x3c(%ebp),%ebx
  80068e:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  800695:	eb a7                	jmp    80063e <vprintfmt+0x1c1>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
  800697:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  80069b:	74 18                	je     8006b5 <vprintfmt+0x238>
  80069d:	8d 50 e0             	lea    -0x20(%eax),%edx
  8006a0:	83 fa 5e             	cmp    $0x5e,%edx
  8006a3:	76 10                	jbe    8006b5 <vprintfmt+0x238>
					putch('?', putdat);
  8006a5:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8006a9:	c7 04 24 3f 00 00 00 	movl   $0x3f,(%esp)
  8006b0:	ff 55 e0             	call   *-0x20(%ebp)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
  8006b3:	eb 0a                	jmp    8006bf <vprintfmt+0x242>
					putch('?', putdat);
				else
					putch(ch, putdat);
  8006b5:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8006b9:	89 04 24             	mov    %eax,(%esp)
  8006bc:	ff 55 e0             	call   *-0x20(%ebp)
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8006bf:	83 6d e4 01          	subl   $0x1,-0x1c(%ebp)
  8006c3:	0f be 03             	movsbl (%ebx),%eax
  8006c6:	85 c0                	test   %eax,%eax
  8006c8:	74 05                	je     8006cf <vprintfmt+0x252>
  8006ca:	83 c3 01             	add    $0x1,%ebx
  8006cd:	eb 29                	jmp    8006f8 <vprintfmt+0x27b>
  8006cf:	89 fe                	mov    %edi,%esi
  8006d1:	8b 7d e0             	mov    -0x20(%ebp),%edi
  8006d4:	8b 5d d0             	mov    -0x30(%ebp),%ebx
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  8006d7:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8006db:	7f 2e                	jg     80070b <vprintfmt+0x28e>
  8006dd:	8b 5d cc             	mov    -0x34(%ebp),%ebx
  8006e0:	e9 c4 fd ff ff       	jmp    8004a9 <vprintfmt+0x2c>
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8006e5:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8006e8:	83 c2 01             	add    $0x1,%edx
  8006eb:	89 7d e0             	mov    %edi,-0x20(%ebp)
  8006ee:	89 f7                	mov    %esi,%edi
  8006f0:	8b 75 d0             	mov    -0x30(%ebp),%esi
  8006f3:	89 5d d0             	mov    %ebx,-0x30(%ebp)
  8006f6:	89 d3                	mov    %edx,%ebx
  8006f8:	85 f6                	test   %esi,%esi
  8006fa:	78 9b                	js     800697 <vprintfmt+0x21a>
  8006fc:	83 ee 01             	sub    $0x1,%esi
  8006ff:	79 96                	jns    800697 <vprintfmt+0x21a>
  800701:	89 fe                	mov    %edi,%esi
  800703:	8b 7d e0             	mov    -0x20(%ebp),%edi
  800706:	8b 5d d0             	mov    -0x30(%ebp),%ebx
  800709:	eb cc                	jmp    8006d7 <vprintfmt+0x25a>
  80070b:	89 5d d8             	mov    %ebx,-0x28(%ebp)
  80070e:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
				putch(' ', putdat);
  800711:	89 74 24 04          	mov    %esi,0x4(%esp)
  800715:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  80071c:	ff d7                	call   *%edi
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  80071e:	83 eb 01             	sub    $0x1,%ebx
  800721:	85 db                	test   %ebx,%ebx
  800723:	7f ec                	jg     800711 <vprintfmt+0x294>
  800725:	8b 5d d8             	mov    -0x28(%ebp),%ebx
  800728:	e9 7c fd ff ff       	jmp    8004a9 <vprintfmt+0x2c>
  80072d:	89 45 cc             	mov    %eax,-0x34(%ebp)
// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
	if (lflag >= 2)
  800730:	83 f9 01             	cmp    $0x1,%ecx
  800733:	7e 16                	jle    80074b <vprintfmt+0x2ce>
		return va_arg(*ap, long long);
  800735:	8b 45 14             	mov    0x14(%ebp),%eax
  800738:	8d 50 08             	lea    0x8(%eax),%edx
  80073b:	89 55 14             	mov    %edx,0x14(%ebp)
  80073e:	8b 10                	mov    (%eax),%edx
  800740:	8b 48 04             	mov    0x4(%eax),%ecx
  800743:	89 55 d8             	mov    %edx,-0x28(%ebp)
  800746:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  800749:	eb 32                	jmp    80077d <vprintfmt+0x300>
	else if (lflag)
  80074b:	85 c9                	test   %ecx,%ecx
  80074d:	74 18                	je     800767 <vprintfmt+0x2ea>
		return va_arg(*ap, long);
  80074f:	8b 45 14             	mov    0x14(%ebp),%eax
  800752:	8d 50 04             	lea    0x4(%eax),%edx
  800755:	89 55 14             	mov    %edx,0x14(%ebp)
  800758:	8b 00                	mov    (%eax),%eax
  80075a:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80075d:	89 c1                	mov    %eax,%ecx
  80075f:	c1 f9 1f             	sar    $0x1f,%ecx
  800762:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  800765:	eb 16                	jmp    80077d <vprintfmt+0x300>
	else
		return va_arg(*ap, int);
  800767:	8b 45 14             	mov    0x14(%ebp),%eax
  80076a:	8d 50 04             	lea    0x4(%eax),%edx
  80076d:	89 55 14             	mov    %edx,0x14(%ebp)
  800770:	8b 00                	mov    (%eax),%eax
  800772:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800775:	89 c2                	mov    %eax,%edx
  800777:	c1 fa 1f             	sar    $0x1f,%edx
  80077a:	89 55 dc             	mov    %edx,-0x24(%ebp)
				putch(' ', putdat);
			break;

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  80077d:	8b 4d d8             	mov    -0x28(%ebp),%ecx
  800780:	8b 5d dc             	mov    -0x24(%ebp),%ebx
  800783:	b8 0a 00 00 00       	mov    $0xa,%eax
			if ((long long) num < 0) {
  800788:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  80078c:	0f 89 9b 00 00 00    	jns    80082d <vprintfmt+0x3b0>
				putch('-', putdat);
  800792:	89 74 24 04          	mov    %esi,0x4(%esp)
  800796:	c7 04 24 2d 00 00 00 	movl   $0x2d,(%esp)
  80079d:	ff d7                	call   *%edi
				num = -(long long) num;
  80079f:	8b 4d d8             	mov    -0x28(%ebp),%ecx
  8007a2:	8b 5d dc             	mov    -0x24(%ebp),%ebx
  8007a5:	f7 d9                	neg    %ecx
  8007a7:	83 d3 00             	adc    $0x0,%ebx
  8007aa:	f7 db                	neg    %ebx
  8007ac:	b8 0a 00 00 00       	mov    $0xa,%eax
  8007b1:	eb 7a                	jmp    80082d <vprintfmt+0x3b0>
  8007b3:	89 45 cc             	mov    %eax,-0x34(%ebp)
			base = 10;
			goto number;

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  8007b6:	89 ca                	mov    %ecx,%edx
  8007b8:	8d 45 14             	lea    0x14(%ebp),%eax
  8007bb:	e8 66 fc ff ff       	call   800426 <getuint>
  8007c0:	89 c1                	mov    %eax,%ecx
  8007c2:	89 d3                	mov    %edx,%ebx
  8007c4:	b8 0a 00 00 00       	mov    $0xa,%eax
			base = 10;
			goto number;
  8007c9:	eb 62                	jmp    80082d <vprintfmt+0x3b0>
  8007cb:	89 45 cc             	mov    %eax,-0x34(%ebp)
		case 'o':
			// Replace this with your code.
			// putch('X', putdat);
			// putch('X', putdat);
			// putch('X', putdat);
			num = getuint(&ap, lflag);
  8007ce:	89 ca                	mov    %ecx,%edx
  8007d0:	8d 45 14             	lea    0x14(%ebp),%eax
  8007d3:	e8 4e fc ff ff       	call   800426 <getuint>
  8007d8:	89 c1                	mov    %eax,%ecx
  8007da:	89 d3                	mov    %edx,%ebx
  8007dc:	b8 08 00 00 00       	mov    $0x8,%eax
			base = 8;
			goto number;
  8007e1:	eb 4a                	jmp    80082d <vprintfmt+0x3b0>
  8007e3:	89 45 cc             	mov    %eax,-0x34(%ebp)
			break;

		// pointer
		case 'p':
			putch('0', putdat);
  8007e6:	89 74 24 04          	mov    %esi,0x4(%esp)
  8007ea:	c7 04 24 30 00 00 00 	movl   $0x30,(%esp)
  8007f1:	ff d7                	call   *%edi
			putch('x', putdat);
  8007f3:	89 74 24 04          	mov    %esi,0x4(%esp)
  8007f7:	c7 04 24 78 00 00 00 	movl   $0x78,(%esp)
  8007fe:	ff d7                	call   *%edi
			num = (unsigned long long)
  800800:	8b 45 14             	mov    0x14(%ebp),%eax
  800803:	8d 50 04             	lea    0x4(%eax),%edx
  800806:	89 55 14             	mov    %edx,0x14(%ebp)
  800809:	8b 08                	mov    (%eax),%ecx
  80080b:	bb 00 00 00 00       	mov    $0x0,%ebx
  800810:	b8 10 00 00 00       	mov    $0x10,%eax
				(uintptr_t) va_arg(ap, void *);
			base = 16;
			goto number;
  800815:	eb 16                	jmp    80082d <vprintfmt+0x3b0>
  800817:	89 45 cc             	mov    %eax,-0x34(%ebp)

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  80081a:	89 ca                	mov    %ecx,%edx
  80081c:	8d 45 14             	lea    0x14(%ebp),%eax
  80081f:	e8 02 fc ff ff       	call   800426 <getuint>
  800824:	89 c1                	mov    %eax,%ecx
  800826:	89 d3                	mov    %edx,%ebx
  800828:	b8 10 00 00 00       	mov    $0x10,%eax
			base = 16;
		number:
			printnum(putch, putdat, num, base, width, padc);
  80082d:	0f be 55 d4          	movsbl -0x2c(%ebp),%edx
  800831:	89 54 24 10          	mov    %edx,0x10(%esp)
  800835:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  800838:	89 54 24 0c          	mov    %edx,0xc(%esp)
  80083c:	89 44 24 08          	mov    %eax,0x8(%esp)
  800840:	89 0c 24             	mov    %ecx,(%esp)
  800843:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  800847:	89 f2                	mov    %esi,%edx
  800849:	89 f8                	mov    %edi,%eax
  80084b:	e8 e0 fa ff ff       	call   800330 <printnum>
  800850:	8b 5d cc             	mov    -0x34(%ebp),%ebx
			break;
  800853:	e9 51 fc ff ff       	jmp    8004a9 <vprintfmt+0x2c>
  800858:	89 45 cc             	mov    %eax,-0x34(%ebp)
  80085b:	8b 55 e0             	mov    -0x20(%ebp),%edx

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  80085e:	89 74 24 04          	mov    %esi,0x4(%esp)
  800862:	89 14 24             	mov    %edx,(%esp)
  800865:	ff d7                	call   *%edi
  800867:	8b 5d cc             	mov    -0x34(%ebp),%ebx
			break;
  80086a:	e9 3a fc ff ff       	jmp    8004a9 <vprintfmt+0x2c>
			
		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  80086f:	89 74 24 04          	mov    %esi,0x4(%esp)
  800873:	c7 04 24 25 00 00 00 	movl   $0x25,(%esp)
  80087a:	ff d7                	call   *%edi
			for (fmt--; fmt[-1] != '%'; fmt--)
  80087c:	8d 43 ff             	lea    -0x1(%ebx),%eax
  80087f:	80 38 25             	cmpb   $0x25,(%eax)
  800882:	0f 84 21 fc ff ff    	je     8004a9 <vprintfmt+0x2c>
  800888:	89 c3                	mov    %eax,%ebx
  80088a:	eb f0                	jmp    80087c <vprintfmt+0x3ff>
				/* do nothing */;
			break;
		}
	}
}
  80088c:	83 c4 5c             	add    $0x5c,%esp
  80088f:	5b                   	pop    %ebx
  800890:	5e                   	pop    %esi
  800891:	5f                   	pop    %edi
  800892:	5d                   	pop    %ebp
  800893:	c3                   	ret    

00800894 <vsnprintf>:
		*b->buf++ = ch;
}

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800894:	55                   	push   %ebp
  800895:	89 e5                	mov    %esp,%ebp
  800897:	83 ec 28             	sub    $0x28,%esp
  80089a:	8b 45 08             	mov    0x8(%ebp),%eax
  80089d:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};

	if (buf == NULL || n < 1)
  8008a0:	85 c0                	test   %eax,%eax
  8008a2:	74 04                	je     8008a8 <vsnprintf+0x14>
  8008a4:	85 d2                	test   %edx,%edx
  8008a6:	7f 07                	jg     8008af <vsnprintf+0x1b>
  8008a8:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8008ad:	eb 3b                	jmp    8008ea <vsnprintf+0x56>
}

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
	struct sprintbuf b = {buf, buf+n-1, 0};
  8008af:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8008b2:	8d 44 10 ff          	lea    -0x1(%eax,%edx,1),%eax
  8008b6:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8008b9:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  8008c0:	8b 45 14             	mov    0x14(%ebp),%eax
  8008c3:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8008c7:	8b 45 10             	mov    0x10(%ebp),%eax
  8008ca:	89 44 24 08          	mov    %eax,0x8(%esp)
  8008ce:	8d 45 ec             	lea    -0x14(%ebp),%eax
  8008d1:	89 44 24 04          	mov    %eax,0x4(%esp)
  8008d5:	c7 04 24 60 04 80 00 	movl   $0x800460,(%esp)
  8008dc:	e8 9c fb ff ff       	call   80047d <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  8008e1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8008e4:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  8008e7:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  8008ea:	c9                   	leave  
  8008eb:	c3                   	ret    

008008ec <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  8008ec:	55                   	push   %ebp
  8008ed:	89 e5                	mov    %esp,%ebp
  8008ef:	83 ec 18             	sub    $0x18,%esp

	return b.cnt;
}

int
snprintf(char *buf, int n, const char *fmt, ...)
  8008f2:	8d 45 14             	lea    0x14(%ebp),%eax
{
	va_list ap;
	int rc;

	va_start(ap, fmt);
	rc = vsnprintf(buf, n, fmt, ap);
  8008f5:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8008f9:	8b 45 10             	mov    0x10(%ebp),%eax
  8008fc:	89 44 24 08          	mov    %eax,0x8(%esp)
  800900:	8b 45 0c             	mov    0xc(%ebp),%eax
  800903:	89 44 24 04          	mov    %eax,0x4(%esp)
  800907:	8b 45 08             	mov    0x8(%ebp),%eax
  80090a:	89 04 24             	mov    %eax,(%esp)
  80090d:	e8 82 ff ff ff       	call   800894 <vsnprintf>
	va_end(ap);

	return rc;
}
  800912:	c9                   	leave  
  800913:	c3                   	ret    

00800914 <printfmt>:
	}
}

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800914:	55                   	push   %ebp
  800915:	89 e5                	mov    %esp,%ebp
  800917:	83 ec 18             	sub    $0x18,%esp
		}
	}
}

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
  80091a:	8d 45 14             	lea    0x14(%ebp),%eax
{
	va_list ap;

	va_start(ap, fmt);
	vprintfmt(putch, putdat, fmt, ap);
  80091d:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800921:	8b 45 10             	mov    0x10(%ebp),%eax
  800924:	89 44 24 08          	mov    %eax,0x8(%esp)
  800928:	8b 45 0c             	mov    0xc(%ebp),%eax
  80092b:	89 44 24 04          	mov    %eax,0x4(%esp)
  80092f:	8b 45 08             	mov    0x8(%ebp),%eax
  800932:	89 04 24             	mov    %eax,(%esp)
  800935:	e8 43 fb ff ff       	call   80047d <vprintfmt>
	va_end(ap);
}
  80093a:	c9                   	leave  
  80093b:	c3                   	ret    
  80093c:	00 00                	add    %al,(%eax)
	...

00800940 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800940:	55                   	push   %ebp
  800941:	89 e5                	mov    %esp,%ebp
  800943:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  800946:	b8 00 00 00 00       	mov    $0x0,%eax
  80094b:	80 3a 00             	cmpb   $0x0,(%edx)
  80094e:	74 09                	je     800959 <strlen+0x19>
		n++;
  800950:	83 c0 01             	add    $0x1,%eax
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800953:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  800957:	75 f7                	jne    800950 <strlen+0x10>
		n++;
	return n;
}
  800959:	5d                   	pop    %ebp
  80095a:	c3                   	ret    

0080095b <strnlen>:

int
strnlen(const char *s, size_t size)
{
  80095b:	55                   	push   %ebp
  80095c:	89 e5                	mov    %esp,%ebp
  80095e:	53                   	push   %ebx
  80095f:	8b 5d 08             	mov    0x8(%ebp),%ebx
  800962:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800965:	85 c9                	test   %ecx,%ecx
  800967:	74 19                	je     800982 <strnlen+0x27>
  800969:	80 3b 00             	cmpb   $0x0,(%ebx)
  80096c:	74 14                	je     800982 <strnlen+0x27>
  80096e:	b8 00 00 00 00       	mov    $0x0,%eax
		n++;
  800973:	83 c0 01             	add    $0x1,%eax
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800976:	39 c8                	cmp    %ecx,%eax
  800978:	74 0d                	je     800987 <strnlen+0x2c>
  80097a:	80 3c 03 00          	cmpb   $0x0,(%ebx,%eax,1)
  80097e:	75 f3                	jne    800973 <strnlen+0x18>
  800980:	eb 05                	jmp    800987 <strnlen+0x2c>
  800982:	b8 00 00 00 00       	mov    $0x0,%eax
		n++;
	return n;
}
  800987:	5b                   	pop    %ebx
  800988:	5d                   	pop    %ebp
  800989:	c3                   	ret    

0080098a <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  80098a:	55                   	push   %ebp
  80098b:	89 e5                	mov    %esp,%ebp
  80098d:	53                   	push   %ebx
  80098e:	8b 45 08             	mov    0x8(%ebp),%eax
  800991:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800994:	ba 00 00 00 00       	mov    $0x0,%edx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  800999:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
  80099d:	88 0c 10             	mov    %cl,(%eax,%edx,1)
  8009a0:	83 c2 01             	add    $0x1,%edx
  8009a3:	84 c9                	test   %cl,%cl
  8009a5:	75 f2                	jne    800999 <strcpy+0xf>
		/* do nothing */;
	return ret;
}
  8009a7:	5b                   	pop    %ebx
  8009a8:	5d                   	pop    %ebp
  8009a9:	c3                   	ret    

008009aa <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  8009aa:	55                   	push   %ebp
  8009ab:	89 e5                	mov    %esp,%ebp
  8009ad:	56                   	push   %esi
  8009ae:	53                   	push   %ebx
  8009af:	8b 45 08             	mov    0x8(%ebp),%eax
  8009b2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8009b5:	8b 75 10             	mov    0x10(%ebp),%esi
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  8009b8:	85 f6                	test   %esi,%esi
  8009ba:	74 18                	je     8009d4 <strncpy+0x2a>
  8009bc:	b9 00 00 00 00       	mov    $0x0,%ecx
		*dst++ = *src;
  8009c1:	0f b6 1a             	movzbl (%edx),%ebx
  8009c4:	88 1c 08             	mov    %bl,(%eax,%ecx,1)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  8009c7:	80 3a 01             	cmpb   $0x1,(%edx)
  8009ca:	83 da ff             	sbb    $0xffffffff,%edx
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  8009cd:	83 c1 01             	add    $0x1,%ecx
  8009d0:	39 ce                	cmp    %ecx,%esi
  8009d2:	77 ed                	ja     8009c1 <strncpy+0x17>
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
}
  8009d4:	5b                   	pop    %ebx
  8009d5:	5e                   	pop    %esi
  8009d6:	5d                   	pop    %ebp
  8009d7:	c3                   	ret    

008009d8 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  8009d8:	55                   	push   %ebp
  8009d9:	89 e5                	mov    %esp,%ebp
  8009db:	56                   	push   %esi
  8009dc:	53                   	push   %ebx
  8009dd:	8b 75 08             	mov    0x8(%ebp),%esi
  8009e0:	8b 55 0c             	mov    0xc(%ebp),%edx
  8009e3:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  8009e6:	89 f0                	mov    %esi,%eax
  8009e8:	85 c9                	test   %ecx,%ecx
  8009ea:	74 27                	je     800a13 <strlcpy+0x3b>
		while (--size > 0 && *src != '\0')
  8009ec:	83 e9 01             	sub    $0x1,%ecx
  8009ef:	74 1d                	je     800a0e <strlcpy+0x36>
  8009f1:	0f b6 1a             	movzbl (%edx),%ebx
  8009f4:	84 db                	test   %bl,%bl
  8009f6:	74 16                	je     800a0e <strlcpy+0x36>
			*dst++ = *src++;
  8009f8:	88 18                	mov    %bl,(%eax)
  8009fa:	83 c0 01             	add    $0x1,%eax
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  8009fd:	83 e9 01             	sub    $0x1,%ecx
  800a00:	74 0e                	je     800a10 <strlcpy+0x38>
			*dst++ = *src++;
  800a02:	83 c2 01             	add    $0x1,%edx
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800a05:	0f b6 1a             	movzbl (%edx),%ebx
  800a08:	84 db                	test   %bl,%bl
  800a0a:	75 ec                	jne    8009f8 <strlcpy+0x20>
  800a0c:	eb 02                	jmp    800a10 <strlcpy+0x38>
  800a0e:	89 f0                	mov    %esi,%eax
			*dst++ = *src++;
		*dst = '\0';
  800a10:	c6 00 00             	movb   $0x0,(%eax)
  800a13:	29 f0                	sub    %esi,%eax
	}
	return dst - dst_in;
}
  800a15:	5b                   	pop    %ebx
  800a16:	5e                   	pop    %esi
  800a17:	5d                   	pop    %ebp
  800a18:	c3                   	ret    

00800a19 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800a19:	55                   	push   %ebp
  800a1a:	89 e5                	mov    %esp,%ebp
  800a1c:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800a1f:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  800a22:	0f b6 01             	movzbl (%ecx),%eax
  800a25:	84 c0                	test   %al,%al
  800a27:	74 15                	je     800a3e <strcmp+0x25>
  800a29:	3a 02                	cmp    (%edx),%al
  800a2b:	75 11                	jne    800a3e <strcmp+0x25>
		p++, q++;
  800a2d:	83 c1 01             	add    $0x1,%ecx
  800a30:	83 c2 01             	add    $0x1,%edx
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800a33:	0f b6 01             	movzbl (%ecx),%eax
  800a36:	84 c0                	test   %al,%al
  800a38:	74 04                	je     800a3e <strcmp+0x25>
  800a3a:	3a 02                	cmp    (%edx),%al
  800a3c:	74 ef                	je     800a2d <strcmp+0x14>
  800a3e:	0f b6 c0             	movzbl %al,%eax
  800a41:	0f b6 12             	movzbl (%edx),%edx
  800a44:	29 d0                	sub    %edx,%eax
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
}
  800a46:	5d                   	pop    %ebp
  800a47:	c3                   	ret    

00800a48 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800a48:	55                   	push   %ebp
  800a49:	89 e5                	mov    %esp,%ebp
  800a4b:	53                   	push   %ebx
  800a4c:	8b 55 08             	mov    0x8(%ebp),%edx
  800a4f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800a52:	8b 45 10             	mov    0x10(%ebp),%eax
	while (n > 0 && *p && *p == *q)
  800a55:	85 c0                	test   %eax,%eax
  800a57:	74 23                	je     800a7c <strncmp+0x34>
  800a59:	0f b6 1a             	movzbl (%edx),%ebx
  800a5c:	84 db                	test   %bl,%bl
  800a5e:	74 24                	je     800a84 <strncmp+0x3c>
  800a60:	3a 19                	cmp    (%ecx),%bl
  800a62:	75 20                	jne    800a84 <strncmp+0x3c>
  800a64:	83 e8 01             	sub    $0x1,%eax
  800a67:	74 13                	je     800a7c <strncmp+0x34>
		n--, p++, q++;
  800a69:	83 c2 01             	add    $0x1,%edx
  800a6c:	83 c1 01             	add    $0x1,%ecx
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  800a6f:	0f b6 1a             	movzbl (%edx),%ebx
  800a72:	84 db                	test   %bl,%bl
  800a74:	74 0e                	je     800a84 <strncmp+0x3c>
  800a76:	3a 19                	cmp    (%ecx),%bl
  800a78:	74 ea                	je     800a64 <strncmp+0x1c>
  800a7a:	eb 08                	jmp    800a84 <strncmp+0x3c>
  800a7c:	b8 00 00 00 00       	mov    $0x0,%eax
		n--, p++, q++;
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
}
  800a81:	5b                   	pop    %ebx
  800a82:	5d                   	pop    %ebp
  800a83:	c3                   	ret    
	while (n > 0 && *p && *p == *q)
		n--, p++, q++;
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800a84:	0f b6 02             	movzbl (%edx),%eax
  800a87:	0f b6 11             	movzbl (%ecx),%edx
  800a8a:	29 d0                	sub    %edx,%eax
  800a8c:	eb f3                	jmp    800a81 <strncmp+0x39>

00800a8e <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800a8e:	55                   	push   %ebp
  800a8f:	89 e5                	mov    %esp,%ebp
  800a91:	8b 45 08             	mov    0x8(%ebp),%eax
  800a94:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800a98:	0f b6 10             	movzbl (%eax),%edx
  800a9b:	84 d2                	test   %dl,%dl
  800a9d:	74 15                	je     800ab4 <strchr+0x26>
		if (*s == c)
  800a9f:	38 ca                	cmp    %cl,%dl
  800aa1:	75 07                	jne    800aaa <strchr+0x1c>
  800aa3:	eb 14                	jmp    800ab9 <strchr+0x2b>
  800aa5:	38 ca                	cmp    %cl,%dl
  800aa7:	90                   	nop
  800aa8:	74 0f                	je     800ab9 <strchr+0x2b>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800aaa:	83 c0 01             	add    $0x1,%eax
  800aad:	0f b6 10             	movzbl (%eax),%edx
  800ab0:	84 d2                	test   %dl,%dl
  800ab2:	75 f1                	jne    800aa5 <strchr+0x17>
  800ab4:	b8 00 00 00 00       	mov    $0x0,%eax
		if (*s == c)
			return (char *) s;
	return 0;
}
  800ab9:	5d                   	pop    %ebp
  800aba:	c3                   	ret    

00800abb <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800abb:	55                   	push   %ebp
  800abc:	89 e5                	mov    %esp,%ebp
  800abe:	8b 45 08             	mov    0x8(%ebp),%eax
  800ac1:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800ac5:	0f b6 10             	movzbl (%eax),%edx
  800ac8:	84 d2                	test   %dl,%dl
  800aca:	74 18                	je     800ae4 <strfind+0x29>
		if (*s == c)
  800acc:	38 ca                	cmp    %cl,%dl
  800ace:	75 0a                	jne    800ada <strfind+0x1f>
  800ad0:	eb 12                	jmp    800ae4 <strfind+0x29>
  800ad2:	38 ca                	cmp    %cl,%dl
  800ad4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  800ad8:	74 0a                	je     800ae4 <strfind+0x29>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800ada:	83 c0 01             	add    $0x1,%eax
  800add:	0f b6 10             	movzbl (%eax),%edx
  800ae0:	84 d2                	test   %dl,%dl
  800ae2:	75 ee                	jne    800ad2 <strfind+0x17>
		if (*s == c)
			break;
	return (char *) s;
}
  800ae4:	5d                   	pop    %ebp
  800ae5:	c3                   	ret    

00800ae6 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800ae6:	55                   	push   %ebp
  800ae7:	89 e5                	mov    %esp,%ebp
  800ae9:	83 ec 0c             	sub    $0xc,%esp
  800aec:	89 1c 24             	mov    %ebx,(%esp)
  800aef:	89 74 24 04          	mov    %esi,0x4(%esp)
  800af3:	89 7c 24 08          	mov    %edi,0x8(%esp)
  800af7:	8b 7d 08             	mov    0x8(%ebp),%edi
  800afa:	8b 45 0c             	mov    0xc(%ebp),%eax
  800afd:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800b00:	85 c9                	test   %ecx,%ecx
  800b02:	74 30                	je     800b34 <memset+0x4e>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800b04:	f7 c7 03 00 00 00    	test   $0x3,%edi
  800b0a:	75 25                	jne    800b31 <memset+0x4b>
  800b0c:	f6 c1 03             	test   $0x3,%cl
  800b0f:	75 20                	jne    800b31 <memset+0x4b>
		c &= 0xFF;
  800b11:	0f b6 d0             	movzbl %al,%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800b14:	89 d3                	mov    %edx,%ebx
  800b16:	c1 e3 08             	shl    $0x8,%ebx
  800b19:	89 d6                	mov    %edx,%esi
  800b1b:	c1 e6 18             	shl    $0x18,%esi
  800b1e:	89 d0                	mov    %edx,%eax
  800b20:	c1 e0 10             	shl    $0x10,%eax
  800b23:	09 f0                	or     %esi,%eax
  800b25:	09 d0                	or     %edx,%eax
		asm volatile("cld; rep stosl\n"
  800b27:	09 d8                	or     %ebx,%eax
  800b29:	c1 e9 02             	shr    $0x2,%ecx
  800b2c:	fc                   	cld    
  800b2d:	f3 ab                	rep stos %eax,%es:(%edi)
{
	char *p;

	if (n == 0)
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800b2f:	eb 03                	jmp    800b34 <memset+0x4e>
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800b31:	fc                   	cld    
  800b32:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800b34:	89 f8                	mov    %edi,%eax
  800b36:	8b 1c 24             	mov    (%esp),%ebx
  800b39:	8b 74 24 04          	mov    0x4(%esp),%esi
  800b3d:	8b 7c 24 08          	mov    0x8(%esp),%edi
  800b41:	89 ec                	mov    %ebp,%esp
  800b43:	5d                   	pop    %ebp
  800b44:	c3                   	ret    

00800b45 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800b45:	55                   	push   %ebp
  800b46:	89 e5                	mov    %esp,%ebp
  800b48:	83 ec 08             	sub    $0x8,%esp
  800b4b:	89 34 24             	mov    %esi,(%esp)
  800b4e:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800b52:	8b 45 08             	mov    0x8(%ebp),%eax
  800b55:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;
	
	s = src;
  800b58:	8b 75 0c             	mov    0xc(%ebp),%esi
	d = dst;
  800b5b:	89 c7                	mov    %eax,%edi
	if (s < d && s + n > d) {
  800b5d:	39 c6                	cmp    %eax,%esi
  800b5f:	73 35                	jae    800b96 <memmove+0x51>
  800b61:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800b64:	39 d0                	cmp    %edx,%eax
  800b66:	73 2e                	jae    800b96 <memmove+0x51>
		s += n;
		d += n;
  800b68:	01 cf                	add    %ecx,%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800b6a:	f6 c2 03             	test   $0x3,%dl
  800b6d:	75 1b                	jne    800b8a <memmove+0x45>
  800b6f:	f7 c7 03 00 00 00    	test   $0x3,%edi
  800b75:	75 13                	jne    800b8a <memmove+0x45>
  800b77:	f6 c1 03             	test   $0x3,%cl
  800b7a:	75 0e                	jne    800b8a <memmove+0x45>
			asm volatile("std; rep movsl\n"
  800b7c:	83 ef 04             	sub    $0x4,%edi
  800b7f:	8d 72 fc             	lea    -0x4(%edx),%esi
  800b82:	c1 e9 02             	shr    $0x2,%ecx
  800b85:	fd                   	std    
  800b86:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800b88:	eb 09                	jmp    800b93 <memmove+0x4e>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  800b8a:	83 ef 01             	sub    $0x1,%edi
  800b8d:	8d 72 ff             	lea    -0x1(%edx),%esi
  800b90:	fd                   	std    
  800b91:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800b93:	fc                   	cld    
	const char *s;
	char *d;
	
	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800b94:	eb 20                	jmp    800bb6 <memmove+0x71>
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800b96:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800b9c:	75 15                	jne    800bb3 <memmove+0x6e>
  800b9e:	f7 c7 03 00 00 00    	test   $0x3,%edi
  800ba4:	75 0d                	jne    800bb3 <memmove+0x6e>
  800ba6:	f6 c1 03             	test   $0x3,%cl
  800ba9:	75 08                	jne    800bb3 <memmove+0x6e>
			asm volatile("cld; rep movsl\n"
  800bab:	c1 e9 02             	shr    $0x2,%ecx
  800bae:	fc                   	cld    
  800baf:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800bb1:	eb 03                	jmp    800bb6 <memmove+0x71>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  800bb3:	fc                   	cld    
  800bb4:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800bb6:	8b 34 24             	mov    (%esp),%esi
  800bb9:	8b 7c 24 04          	mov    0x4(%esp),%edi
  800bbd:	89 ec                	mov    %ebp,%esp
  800bbf:	5d                   	pop    %ebp
  800bc0:	c3                   	ret    

00800bc1 <memcpy>:

/* sigh - gcc emits references to this for structure assignments! */
/* it is *not* prototyped in inc/string.h - do not use directly. */
void *
memcpy(void *dst, void *src, size_t n)
{
  800bc1:	55                   	push   %ebp
  800bc2:	89 e5                	mov    %esp,%ebp
  800bc4:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  800bc7:	8b 45 10             	mov    0x10(%ebp),%eax
  800bca:	89 44 24 08          	mov    %eax,0x8(%esp)
  800bce:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bd1:	89 44 24 04          	mov    %eax,0x4(%esp)
  800bd5:	8b 45 08             	mov    0x8(%ebp),%eax
  800bd8:	89 04 24             	mov    %eax,(%esp)
  800bdb:	e8 65 ff ff ff       	call   800b45 <memmove>
}
  800be0:	c9                   	leave  
  800be1:	c3                   	ret    

00800be2 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800be2:	55                   	push   %ebp
  800be3:	89 e5                	mov    %esp,%ebp
  800be5:	57                   	push   %edi
  800be6:	56                   	push   %esi
  800be7:	53                   	push   %ebx
  800be8:	8b 75 08             	mov    0x8(%ebp),%esi
  800beb:	8b 7d 0c             	mov    0xc(%ebp),%edi
  800bee:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800bf1:	85 c9                	test   %ecx,%ecx
  800bf3:	74 36                	je     800c2b <memcmp+0x49>
		if (*s1 != *s2)
  800bf5:	0f b6 06             	movzbl (%esi),%eax
  800bf8:	0f b6 1f             	movzbl (%edi),%ebx
  800bfb:	38 d8                	cmp    %bl,%al
  800bfd:	74 20                	je     800c1f <memcmp+0x3d>
  800bff:	eb 14                	jmp    800c15 <memcmp+0x33>
  800c01:	0f b6 44 16 01       	movzbl 0x1(%esi,%edx,1),%eax
  800c06:	0f b6 5c 17 01       	movzbl 0x1(%edi,%edx,1),%ebx
  800c0b:	83 c2 01             	add    $0x1,%edx
  800c0e:	83 e9 01             	sub    $0x1,%ecx
  800c11:	38 d8                	cmp    %bl,%al
  800c13:	74 12                	je     800c27 <memcmp+0x45>
			return (int) *s1 - (int) *s2;
  800c15:	0f b6 c0             	movzbl %al,%eax
  800c18:	0f b6 db             	movzbl %bl,%ebx
  800c1b:	29 d8                	sub    %ebx,%eax
  800c1d:	eb 11                	jmp    800c30 <memcmp+0x4e>
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800c1f:	83 e9 01             	sub    $0x1,%ecx
  800c22:	ba 00 00 00 00       	mov    $0x0,%edx
  800c27:	85 c9                	test   %ecx,%ecx
  800c29:	75 d6                	jne    800c01 <memcmp+0x1f>
  800c2b:	b8 00 00 00 00       	mov    $0x0,%eax
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
}
  800c30:	5b                   	pop    %ebx
  800c31:	5e                   	pop    %esi
  800c32:	5f                   	pop    %edi
  800c33:	5d                   	pop    %ebp
  800c34:	c3                   	ret    

00800c35 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800c35:	55                   	push   %ebp
  800c36:	89 e5                	mov    %esp,%ebp
  800c38:	8b 45 08             	mov    0x8(%ebp),%eax
	const void *ends = (const char *) s + n;
  800c3b:	89 c2                	mov    %eax,%edx
  800c3d:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800c40:	39 d0                	cmp    %edx,%eax
  800c42:	73 15                	jae    800c59 <memfind+0x24>
		if (*(const unsigned char *) s == (unsigned char) c)
  800c44:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
  800c48:	38 08                	cmp    %cl,(%eax)
  800c4a:	75 06                	jne    800c52 <memfind+0x1d>
  800c4c:	eb 0b                	jmp    800c59 <memfind+0x24>
  800c4e:	38 08                	cmp    %cl,(%eax)
  800c50:	74 07                	je     800c59 <memfind+0x24>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800c52:	83 c0 01             	add    $0x1,%eax
  800c55:	39 c2                	cmp    %eax,%edx
  800c57:	77 f5                	ja     800c4e <memfind+0x19>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
	return (void *) s;
}
  800c59:	5d                   	pop    %ebp
  800c5a:	c3                   	ret    

00800c5b <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800c5b:	55                   	push   %ebp
  800c5c:	89 e5                	mov    %esp,%ebp
  800c5e:	57                   	push   %edi
  800c5f:	56                   	push   %esi
  800c60:	53                   	push   %ebx
  800c61:	83 ec 04             	sub    $0x4,%esp
  800c64:	8b 55 08             	mov    0x8(%ebp),%edx
  800c67:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800c6a:	0f b6 02             	movzbl (%edx),%eax
  800c6d:	3c 20                	cmp    $0x20,%al
  800c6f:	74 04                	je     800c75 <strtol+0x1a>
  800c71:	3c 09                	cmp    $0x9,%al
  800c73:	75 0e                	jne    800c83 <strtol+0x28>
		s++;
  800c75:	83 c2 01             	add    $0x1,%edx
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800c78:	0f b6 02             	movzbl (%edx),%eax
  800c7b:	3c 20                	cmp    $0x20,%al
  800c7d:	74 f6                	je     800c75 <strtol+0x1a>
  800c7f:	3c 09                	cmp    $0x9,%al
  800c81:	74 f2                	je     800c75 <strtol+0x1a>
		s++;

	// plus/minus sign
	if (*s == '+')
  800c83:	3c 2b                	cmp    $0x2b,%al
  800c85:	75 0c                	jne    800c93 <strtol+0x38>
		s++;
  800c87:	83 c2 01             	add    $0x1,%edx
  800c8a:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800c91:	eb 15                	jmp    800ca8 <strtol+0x4d>
	else if (*s == '-')
  800c93:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800c9a:	3c 2d                	cmp    $0x2d,%al
  800c9c:	75 0a                	jne    800ca8 <strtol+0x4d>
		s++, neg = 1;
  800c9e:	83 c2 01             	add    $0x1,%edx
  800ca1:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800ca8:	85 db                	test   %ebx,%ebx
  800caa:	0f 94 c0             	sete   %al
  800cad:	74 05                	je     800cb4 <strtol+0x59>
  800caf:	83 fb 10             	cmp    $0x10,%ebx
  800cb2:	75 18                	jne    800ccc <strtol+0x71>
  800cb4:	80 3a 30             	cmpb   $0x30,(%edx)
  800cb7:	75 13                	jne    800ccc <strtol+0x71>
  800cb9:	80 7a 01 78          	cmpb   $0x78,0x1(%edx)
  800cbd:	8d 76 00             	lea    0x0(%esi),%esi
  800cc0:	75 0a                	jne    800ccc <strtol+0x71>
		s += 2, base = 16;
  800cc2:	83 c2 02             	add    $0x2,%edx
  800cc5:	bb 10 00 00 00       	mov    $0x10,%ebx
		s++;
	else if (*s == '-')
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800cca:	eb 15                	jmp    800ce1 <strtol+0x86>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  800ccc:	84 c0                	test   %al,%al
  800cce:	66 90                	xchg   %ax,%ax
  800cd0:	74 0f                	je     800ce1 <strtol+0x86>
  800cd2:	bb 0a 00 00 00       	mov    $0xa,%ebx
  800cd7:	80 3a 30             	cmpb   $0x30,(%edx)
  800cda:	75 05                	jne    800ce1 <strtol+0x86>
		s++, base = 8;
  800cdc:	83 c2 01             	add    $0x1,%edx
  800cdf:	b3 08                	mov    $0x8,%bl
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  800ce1:	b8 00 00 00 00       	mov    $0x0,%eax
  800ce6:	89 de                	mov    %ebx,%esi

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  800ce8:	0f b6 0a             	movzbl (%edx),%ecx
  800ceb:	89 cf                	mov    %ecx,%edi
  800ced:	8d 59 d0             	lea    -0x30(%ecx),%ebx
  800cf0:	80 fb 09             	cmp    $0x9,%bl
  800cf3:	77 08                	ja     800cfd <strtol+0xa2>
			dig = *s - '0';
  800cf5:	0f be c9             	movsbl %cl,%ecx
  800cf8:	83 e9 30             	sub    $0x30,%ecx
  800cfb:	eb 1e                	jmp    800d1b <strtol+0xc0>
		else if (*s >= 'a' && *s <= 'z')
  800cfd:	8d 5f 9f             	lea    -0x61(%edi),%ebx
  800d00:	80 fb 19             	cmp    $0x19,%bl
  800d03:	77 08                	ja     800d0d <strtol+0xb2>
			dig = *s - 'a' + 10;
  800d05:	0f be c9             	movsbl %cl,%ecx
  800d08:	83 e9 57             	sub    $0x57,%ecx
  800d0b:	eb 0e                	jmp    800d1b <strtol+0xc0>
		else if (*s >= 'A' && *s <= 'Z')
  800d0d:	8d 5f bf             	lea    -0x41(%edi),%ebx
  800d10:	80 fb 19             	cmp    $0x19,%bl
  800d13:	77 15                	ja     800d2a <strtol+0xcf>
			dig = *s - 'A' + 10;
  800d15:	0f be c9             	movsbl %cl,%ecx
  800d18:	83 e9 37             	sub    $0x37,%ecx
		else
			break;
		if (dig >= base)
  800d1b:	39 f1                	cmp    %esi,%ecx
  800d1d:	7d 0b                	jge    800d2a <strtol+0xcf>
			break;
		s++, val = (val * base) + dig;
  800d1f:	83 c2 01             	add    $0x1,%edx
  800d22:	0f af c6             	imul   %esi,%eax
  800d25:	8d 04 01             	lea    (%ecx,%eax,1),%eax
		// we don't properly detect overflow!
	}
  800d28:	eb be                	jmp    800ce8 <strtol+0x8d>
  800d2a:	89 c1                	mov    %eax,%ecx

	if (endptr)
  800d2c:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800d30:	74 05                	je     800d37 <strtol+0xdc>
		*endptr = (char *) s;
  800d32:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800d35:	89 13                	mov    %edx,(%ebx)
	return (neg ? -val : val);
  800d37:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  800d3b:	74 04                	je     800d41 <strtol+0xe6>
  800d3d:	89 c8                	mov    %ecx,%eax
  800d3f:	f7 d8                	neg    %eax
}
  800d41:	83 c4 04             	add    $0x4,%esp
  800d44:	5b                   	pop    %ebx
  800d45:	5e                   	pop    %esi
  800d46:	5f                   	pop    %edi
  800d47:	5d                   	pop    %ebp
  800d48:	c3                   	ret    
  800d49:	00 00                	add    %al,(%eax)
	...

00800d4c <sys_cgetc>:
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}

int
sys_cgetc(void)
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
  800d62:	b8 01 00 00 00       	mov    $0x1,%eax
  800d67:	89 d1                	mov    %edx,%ecx
  800d69:	89 d3                	mov    %edx,%ebx
  800d6b:	89 d7                	mov    %edx,%edi
  800d6d:	89 d6                	mov    %edx,%esi
  800d6f:	cd 30                	int    $0x30

int
sys_cgetc(void)
{
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800d71:	8b 1c 24             	mov    (%esp),%ebx
  800d74:	8b 74 24 04          	mov    0x4(%esp),%esi
  800d78:	8b 7c 24 08          	mov    0x8(%esp),%edi
  800d7c:	89 ec                	mov    %ebp,%esp
  800d7e:	5d                   	pop    %ebp
  800d7f:	c3                   	ret    

00800d80 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800d80:	55                   	push   %ebp
  800d81:	89 e5                	mov    %esp,%ebp
  800d83:	83 ec 0c             	sub    $0xc,%esp
  800d86:	89 1c 24             	mov    %ebx,(%esp)
  800d89:	89 74 24 04          	mov    %esi,0x4(%esp)
  800d8d:	89 7c 24 08          	mov    %edi,0x8(%esp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800d91:	b8 00 00 00 00       	mov    $0x0,%eax
  800d96:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d99:	8b 55 08             	mov    0x8(%ebp),%edx
  800d9c:	89 c3                	mov    %eax,%ebx
  800d9e:	89 c7                	mov    %eax,%edi
  800da0:	89 c6                	mov    %eax,%esi
  800da2:	cd 30                	int    $0x30

void
sys_cputs(const char *s, size_t len)
{
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800da4:	8b 1c 24             	mov    (%esp),%ebx
  800da7:	8b 74 24 04          	mov    0x4(%esp),%esi
  800dab:	8b 7c 24 08          	mov    0x8(%esp),%edi
  800daf:	89 ec                	mov    %ebp,%esp
  800db1:	5d                   	pop    %ebp
  800db2:	c3                   	ret    

00800db3 <sys_page_insert>:
{
	return syscall(SYS_page_waste, 0, (uint32_t)p, (uint32_t)n, 0, 0,0);
}
int
sys_page_insert(envid_t envid, void *va, struct Page *p, int perm)
{
  800db3:	55                   	push   %ebp
  800db4:	89 e5                	mov    %esp,%ebp
  800db6:	83 ec 38             	sub    $0x38,%esp
  800db9:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800dbc:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800dbf:	89 7d fc             	mov    %edi,-0x4(%ebp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800dc2:	be 00 00 00 00       	mov    $0x0,%esi
  800dc7:	b8 12 00 00 00       	mov    $0x12,%eax
  800dcc:	8b 7d 14             	mov    0x14(%ebp),%edi
  800dcf:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800dd2:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800dd5:	8b 55 08             	mov    0x8(%ebp),%edx
  800dd8:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
	
	if(check && ret > 0)
  800dda:	85 c0                	test   %eax,%eax
  800ddc:	7e 28                	jle    800e06 <sys_page_insert+0x53>
		panic("syscall %d returned %d (> 0)", num, ret);
  800dde:	89 44 24 10          	mov    %eax,0x10(%esp)
  800de2:	c7 44 24 0c 12 00 00 	movl   $0x12,0xc(%esp)
  800de9:	00 
  800dea:	c7 44 24 08 ff 2d 80 	movl   $0x802dff,0x8(%esp)
  800df1:	00 
  800df2:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800df9:	00 
  800dfa:	c7 04 24 1c 2e 80 00 	movl   $0x802e1c,(%esp)
  800e01:	e8 fe f3 ff ff       	call   800204 <_panic>
}
int
sys_page_insert(envid_t envid, void *va, struct Page *p, int perm)
{
	return syscall(SYS_page_insert, 1, envid, (uint32_t) va, (uint32_t)p, perm, 0);
}
  800e06:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800e09:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800e0c:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800e0f:	89 ec                	mov    %ebp,%esp
  800e11:	5d                   	pop    %ebp
  800e12:	c3                   	ret    

00800e13 <sys_page_waste>:
{
	return (int)syscall(SYS_receive_packet, 0, (uint32_t)buffer, 0,0,0,0);
}

int sys_page_waste(struct Page **p, int n)
{
  800e13:	55                   	push   %ebp
  800e14:	89 e5                	mov    %esp,%ebp
  800e16:	83 ec 0c             	sub    $0xc,%esp
  800e19:	89 1c 24             	mov    %ebx,(%esp)
  800e1c:	89 74 24 04          	mov    %esi,0x4(%esp)
  800e20:	89 7c 24 08          	mov    %edi,0x8(%esp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800e24:	bb 00 00 00 00       	mov    $0x0,%ebx
  800e29:	b8 11 00 00 00       	mov    $0x11,%eax
  800e2e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e31:	8b 55 08             	mov    0x8(%ebp),%edx
  800e34:	89 df                	mov    %ebx,%edi
  800e36:	89 de                	mov    %ebx,%esi
  800e38:	cd 30                	int    $0x30
}

int sys_page_waste(struct Page **p, int n)
{
	return syscall(SYS_page_waste, 0, (uint32_t)p, (uint32_t)n, 0, 0,0);
}
  800e3a:	8b 1c 24             	mov    (%esp),%ebx
  800e3d:	8b 74 24 04          	mov    0x4(%esp),%esi
  800e41:	8b 7c 24 08          	mov    0x8(%esp),%edi
  800e45:	89 ec                	mov    %ebp,%esp
  800e47:	5d                   	pop    %ebp
  800e48:	c3                   	ret    

00800e49 <sys_receive_packet>:
{
	return (int)syscall(SYS_transmit_packet, 1, (uint32_t)data, len, 0,0,0);
}

int sys_receive_packet(void* buffer)
{
  800e49:	55                   	push   %ebp
  800e4a:	89 e5                	mov    %esp,%ebp
  800e4c:	83 ec 0c             	sub    $0xc,%esp
  800e4f:	89 1c 24             	mov    %ebx,(%esp)
  800e52:	89 74 24 04          	mov    %esi,0x4(%esp)
  800e56:	89 7c 24 08          	mov    %edi,0x8(%esp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800e5a:	b9 00 00 00 00       	mov    $0x0,%ecx
  800e5f:	b8 10 00 00 00       	mov    $0x10,%eax
  800e64:	8b 55 08             	mov    0x8(%ebp),%edx
  800e67:	89 cb                	mov    %ecx,%ebx
  800e69:	89 cf                	mov    %ecx,%edi
  800e6b:	89 ce                	mov    %ecx,%esi
  800e6d:	cd 30                	int    $0x30
}

int sys_receive_packet(void* buffer)
{
	return (int)syscall(SYS_receive_packet, 0, (uint32_t)buffer, 0,0,0,0);
}
  800e6f:	8b 1c 24             	mov    (%esp),%ebx
  800e72:	8b 74 24 04          	mov    0x4(%esp),%esi
  800e76:	8b 7c 24 08          	mov    0x8(%esp),%edi
  800e7a:	89 ec                	mov    %ebp,%esp
  800e7c:	5d                   	pop    %ebp
  800e7d:	c3                   	ret    

00800e7e <sys_transmit_packet>:
{
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0,0);
}

int sys_transmit_packet(void* data, uint32_t len)
{
  800e7e:	55                   	push   %ebp
  800e7f:	89 e5                	mov    %esp,%ebp
  800e81:	83 ec 38             	sub    $0x38,%esp
  800e84:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800e87:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800e8a:	89 7d fc             	mov    %edi,-0x4(%ebp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800e8d:	bb 00 00 00 00       	mov    $0x0,%ebx
  800e92:	b8 0f 00 00 00       	mov    $0xf,%eax
  800e97:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e9a:	8b 55 08             	mov    0x8(%ebp),%edx
  800e9d:	89 df                	mov    %ebx,%edi
  800e9f:	89 de                	mov    %ebx,%esi
  800ea1:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
	
	if(check && ret > 0)
  800ea3:	85 c0                	test   %eax,%eax
  800ea5:	7e 28                	jle    800ecf <sys_transmit_packet+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  800ea7:	89 44 24 10          	mov    %eax,0x10(%esp)
  800eab:	c7 44 24 0c 0f 00 00 	movl   $0xf,0xc(%esp)
  800eb2:	00 
  800eb3:	c7 44 24 08 ff 2d 80 	movl   $0x802dff,0x8(%esp)
  800eba:	00 
  800ebb:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800ec2:	00 
  800ec3:	c7 04 24 1c 2e 80 00 	movl   $0x802e1c,(%esp)
  800eca:	e8 35 f3 ff ff       	call   800204 <_panic>
}

int sys_transmit_packet(void* data, uint32_t len)
{
	return (int)syscall(SYS_transmit_packet, 1, (uint32_t)data, len, 0,0,0);
}
  800ecf:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800ed2:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800ed5:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800ed8:	89 ec                	mov    %ebp,%esp
  800eda:	5d                   	pop    %ebp
  800edb:	c3                   	ret    

00800edc <sys_time_msec>:
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}

unsigned int
sys_time_msec(void)
{
  800edc:	55                   	push   %ebp
  800edd:	89 e5                	mov    %esp,%ebp
  800edf:	83 ec 0c             	sub    $0xc,%esp
  800ee2:	89 1c 24             	mov    %ebx,(%esp)
  800ee5:	89 74 24 04          	mov    %esi,0x4(%esp)
  800ee9:	89 7c 24 08          	mov    %edi,0x8(%esp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800eed:	ba 00 00 00 00       	mov    $0x0,%edx
  800ef2:	b8 0e 00 00 00       	mov    $0xe,%eax
  800ef7:	89 d1                	mov    %edx,%ecx
  800ef9:	89 d3                	mov    %edx,%ebx
  800efb:	89 d7                	mov    %edx,%edi
  800efd:	89 d6                	mov    %edx,%esi
  800eff:	cd 30                	int    $0x30

unsigned int
sys_time_msec(void)
{
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0,0);
}
  800f01:	8b 1c 24             	mov    (%esp),%ebx
  800f04:	8b 74 24 04          	mov    0x4(%esp),%esi
  800f08:	8b 7c 24 08          	mov    0x8(%esp),%edi
  800f0c:	89 ec                	mov    %ebp,%esp
  800f0e:	5d                   	pop    %ebp
  800f0f:	c3                   	ret    

00800f10 <sys_ipc_recv>:
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}

int
sys_ipc_recv(void *dstva)
{
  800f10:	55                   	push   %ebp
  800f11:	89 e5                	mov    %esp,%ebp
  800f13:	83 ec 38             	sub    $0x38,%esp
  800f16:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800f19:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800f1c:	89 7d fc             	mov    %edi,-0x4(%ebp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800f1f:	b9 00 00 00 00       	mov    $0x0,%ecx
  800f24:	b8 0d 00 00 00       	mov    $0xd,%eax
  800f29:	8b 55 08             	mov    0x8(%ebp),%edx
  800f2c:	89 cb                	mov    %ecx,%ebx
  800f2e:	89 cf                	mov    %ecx,%edi
  800f30:	89 ce                	mov    %ecx,%esi
  800f32:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
	
	if(check && ret > 0)
  800f34:	85 c0                	test   %eax,%eax
  800f36:	7e 28                	jle    800f60 <sys_ipc_recv+0x50>
		panic("syscall %d returned %d (> 0)", num, ret);
  800f38:	89 44 24 10          	mov    %eax,0x10(%esp)
  800f3c:	c7 44 24 0c 0d 00 00 	movl   $0xd,0xc(%esp)
  800f43:	00 
  800f44:	c7 44 24 08 ff 2d 80 	movl   $0x802dff,0x8(%esp)
  800f4b:	00 
  800f4c:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800f53:	00 
  800f54:	c7 04 24 1c 2e 80 00 	movl   $0x802e1c,(%esp)
  800f5b:	e8 a4 f2 ff ff       	call   800204 <_panic>

int
sys_ipc_recv(void *dstva)
{
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  800f60:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800f63:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800f66:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800f69:	89 ec                	mov    %ebp,%esp
  800f6b:	5d                   	pop    %ebp
  800f6c:	c3                   	ret    

00800f6d <sys_ipc_try_send>:
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800f6d:	55                   	push   %ebp
  800f6e:	89 e5                	mov    %esp,%ebp
  800f70:	83 ec 0c             	sub    $0xc,%esp
  800f73:	89 1c 24             	mov    %ebx,(%esp)
  800f76:	89 74 24 04          	mov    %esi,0x4(%esp)
  800f7a:	89 7c 24 08          	mov    %edi,0x8(%esp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800f7e:	be 00 00 00 00       	mov    $0x0,%esi
  800f83:	b8 0c 00 00 00       	mov    $0xc,%eax
  800f88:	8b 7d 14             	mov    0x14(%ebp),%edi
  800f8b:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800f8e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f91:	8b 55 08             	mov    0x8(%ebp),%edx
  800f94:	cd 30                	int    $0x30

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  800f96:	8b 1c 24             	mov    (%esp),%ebx
  800f99:	8b 74 24 04          	mov    0x4(%esp),%esi
  800f9d:	8b 7c 24 08          	mov    0x8(%esp),%edi
  800fa1:	89 ec                	mov    %ebp,%esp
  800fa3:	5d                   	pop    %ebp
  800fa4:	c3                   	ret    

00800fa5 <sys_env_set_pgfault_upcall>:
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800fa5:	55                   	push   %ebp
  800fa6:	89 e5                	mov    %esp,%ebp
  800fa8:	83 ec 38             	sub    $0x38,%esp
  800fab:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800fae:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800fb1:	89 7d fc             	mov    %edi,-0x4(%ebp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800fb4:	bb 00 00 00 00       	mov    $0x0,%ebx
  800fb9:	b8 0a 00 00 00       	mov    $0xa,%eax
  800fbe:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800fc1:	8b 55 08             	mov    0x8(%ebp),%edx
  800fc4:	89 df                	mov    %ebx,%edi
  800fc6:	89 de                	mov    %ebx,%esi
  800fc8:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
	
	if(check && ret > 0)
  800fca:	85 c0                	test   %eax,%eax
  800fcc:	7e 28                	jle    800ff6 <sys_env_set_pgfault_upcall+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  800fce:	89 44 24 10          	mov    %eax,0x10(%esp)
  800fd2:	c7 44 24 0c 0a 00 00 	movl   $0xa,0xc(%esp)
  800fd9:	00 
  800fda:	c7 44 24 08 ff 2d 80 	movl   $0x802dff,0x8(%esp)
  800fe1:	00 
  800fe2:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800fe9:	00 
  800fea:	c7 04 24 1c 2e 80 00 	movl   $0x802e1c,(%esp)
  800ff1:	e8 0e f2 ff ff       	call   800204 <_panic>

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  800ff6:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800ff9:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800ffc:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800fff:	89 ec                	mov    %ebp,%esp
  801001:	5d                   	pop    %ebp
  801002:	c3                   	ret    

00801003 <sys_env_set_trapframe>:
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  801003:	55                   	push   %ebp
  801004:	89 e5                	mov    %esp,%ebp
  801006:	83 ec 38             	sub    $0x38,%esp
  801009:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  80100c:	89 75 f8             	mov    %esi,-0x8(%ebp)
  80100f:	89 7d fc             	mov    %edi,-0x4(%ebp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801012:	bb 00 00 00 00       	mov    $0x0,%ebx
  801017:	b8 09 00 00 00       	mov    $0x9,%eax
  80101c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80101f:	8b 55 08             	mov    0x8(%ebp),%edx
  801022:	89 df                	mov    %ebx,%edi
  801024:	89 de                	mov    %ebx,%esi
  801026:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
	
	if(check && ret > 0)
  801028:	85 c0                	test   %eax,%eax
  80102a:	7e 28                	jle    801054 <sys_env_set_trapframe+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  80102c:	89 44 24 10          	mov    %eax,0x10(%esp)
  801030:	c7 44 24 0c 09 00 00 	movl   $0x9,0xc(%esp)
  801037:	00 
  801038:	c7 44 24 08 ff 2d 80 	movl   $0x802dff,0x8(%esp)
  80103f:	00 
  801040:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  801047:	00 
  801048:	c7 04 24 1c 2e 80 00 	movl   $0x802e1c,(%esp)
  80104f:	e8 b0 f1 ff ff       	call   800204 <_panic>

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  801054:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  801057:	8b 75 f8             	mov    -0x8(%ebp),%esi
  80105a:	8b 7d fc             	mov    -0x4(%ebp),%edi
  80105d:	89 ec                	mov    %ebp,%esp
  80105f:	5d                   	pop    %ebp
  801060:	c3                   	ret    

00801061 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  801061:	55                   	push   %ebp
  801062:	89 e5                	mov    %esp,%ebp
  801064:	83 ec 38             	sub    $0x38,%esp
  801067:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  80106a:	89 75 f8             	mov    %esi,-0x8(%ebp)
  80106d:	89 7d fc             	mov    %edi,-0x4(%ebp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801070:	bb 00 00 00 00       	mov    $0x0,%ebx
  801075:	b8 08 00 00 00       	mov    $0x8,%eax
  80107a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80107d:	8b 55 08             	mov    0x8(%ebp),%edx
  801080:	89 df                	mov    %ebx,%edi
  801082:	89 de                	mov    %ebx,%esi
  801084:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
	
	if(check && ret > 0)
  801086:	85 c0                	test   %eax,%eax
  801088:	7e 28                	jle    8010b2 <sys_env_set_status+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  80108a:	89 44 24 10          	mov    %eax,0x10(%esp)
  80108e:	c7 44 24 0c 08 00 00 	movl   $0x8,0xc(%esp)
  801095:	00 
  801096:	c7 44 24 08 ff 2d 80 	movl   $0x802dff,0x8(%esp)
  80109d:	00 
  80109e:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  8010a5:	00 
  8010a6:	c7 04 24 1c 2e 80 00 	movl   $0x802e1c,(%esp)
  8010ad:	e8 52 f1 ff ff       	call   800204 <_panic>

int
sys_env_set_status(envid_t envid, int status)
{
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  8010b2:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  8010b5:	8b 75 f8             	mov    -0x8(%ebp),%esi
  8010b8:	8b 7d fc             	mov    -0x4(%ebp),%edi
  8010bb:	89 ec                	mov    %ebp,%esp
  8010bd:	5d                   	pop    %ebp
  8010be:	c3                   	ret    

008010bf <sys_page_unmap>:
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}

int
sys_page_unmap(envid_t envid, void *va)
{
  8010bf:	55                   	push   %ebp
  8010c0:	89 e5                	mov    %esp,%ebp
  8010c2:	83 ec 38             	sub    $0x38,%esp
  8010c5:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  8010c8:	89 75 f8             	mov    %esi,-0x8(%ebp)
  8010cb:	89 7d fc             	mov    %edi,-0x4(%ebp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8010ce:	bb 00 00 00 00       	mov    $0x0,%ebx
  8010d3:	b8 06 00 00 00       	mov    $0x6,%eax
  8010d8:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8010db:	8b 55 08             	mov    0x8(%ebp),%edx
  8010de:	89 df                	mov    %ebx,%edi
  8010e0:	89 de                	mov    %ebx,%esi
  8010e2:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
	
	if(check && ret > 0)
  8010e4:	85 c0                	test   %eax,%eax
  8010e6:	7e 28                	jle    801110 <sys_page_unmap+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  8010e8:	89 44 24 10          	mov    %eax,0x10(%esp)
  8010ec:	c7 44 24 0c 06 00 00 	movl   $0x6,0xc(%esp)
  8010f3:	00 
  8010f4:	c7 44 24 08 ff 2d 80 	movl   $0x802dff,0x8(%esp)
  8010fb:	00 
  8010fc:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  801103:	00 
  801104:	c7 04 24 1c 2e 80 00 	movl   $0x802e1c,(%esp)
  80110b:	e8 f4 f0 ff ff       	call   800204 <_panic>

int
sys_page_unmap(envid_t envid, void *va)
{
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  801110:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  801113:	8b 75 f8             	mov    -0x8(%ebp),%esi
  801116:	8b 7d fc             	mov    -0x4(%ebp),%edi
  801119:	89 ec                	mov    %ebp,%esp
  80111b:	5d                   	pop    %ebp
  80111c:	c3                   	ret    

0080111d <sys_page_map>:
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  80111d:	55                   	push   %ebp
  80111e:	89 e5                	mov    %esp,%ebp
  801120:	83 ec 38             	sub    $0x38,%esp
  801123:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  801126:	89 75 f8             	mov    %esi,-0x8(%ebp)
  801129:	89 7d fc             	mov    %edi,-0x4(%ebp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80112c:	b8 05 00 00 00       	mov    $0x5,%eax
  801131:	8b 75 18             	mov    0x18(%ebp),%esi
  801134:	8b 7d 14             	mov    0x14(%ebp),%edi
  801137:	8b 5d 10             	mov    0x10(%ebp),%ebx
  80113a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80113d:	8b 55 08             	mov    0x8(%ebp),%edx
  801140:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
	
	if(check && ret > 0)
  801142:	85 c0                	test   %eax,%eax
  801144:	7e 28                	jle    80116e <sys_page_map+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  801146:	89 44 24 10          	mov    %eax,0x10(%esp)
  80114a:	c7 44 24 0c 05 00 00 	movl   $0x5,0xc(%esp)
  801151:	00 
  801152:	c7 44 24 08 ff 2d 80 	movl   $0x802dff,0x8(%esp)
  801159:	00 
  80115a:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  801161:	00 
  801162:	c7 04 24 1c 2e 80 00 	movl   $0x802e1c,(%esp)
  801169:	e8 96 f0 ff ff       	call   800204 <_panic>

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  80116e:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  801171:	8b 75 f8             	mov    -0x8(%ebp),%esi
  801174:	8b 7d fc             	mov    -0x4(%ebp),%edi
  801177:	89 ec                	mov    %ebp,%esp
  801179:	5d                   	pop    %ebp
  80117a:	c3                   	ret    

0080117b <sys_page_alloc>:
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  80117b:	55                   	push   %ebp
  80117c:	89 e5                	mov    %esp,%ebp
  80117e:	83 ec 38             	sub    $0x38,%esp
  801181:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  801184:	89 75 f8             	mov    %esi,-0x8(%ebp)
  801187:	89 7d fc             	mov    %edi,-0x4(%ebp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80118a:	be 00 00 00 00       	mov    $0x0,%esi
  80118f:	b8 04 00 00 00       	mov    $0x4,%eax
  801194:	8b 5d 10             	mov    0x10(%ebp),%ebx
  801197:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80119a:	8b 55 08             	mov    0x8(%ebp),%edx
  80119d:	89 f7                	mov    %esi,%edi
  80119f:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
	
	if(check && ret > 0)
  8011a1:	85 c0                	test   %eax,%eax
  8011a3:	7e 28                	jle    8011cd <sys_page_alloc+0x52>
		panic("syscall %d returned %d (> 0)", num, ret);
  8011a5:	89 44 24 10          	mov    %eax,0x10(%esp)
  8011a9:	c7 44 24 0c 04 00 00 	movl   $0x4,0xc(%esp)
  8011b0:	00 
  8011b1:	c7 44 24 08 ff 2d 80 	movl   $0x802dff,0x8(%esp)
  8011b8:	00 
  8011b9:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  8011c0:	00 
  8011c1:	c7 04 24 1c 2e 80 00 	movl   $0x802e1c,(%esp)
  8011c8:	e8 37 f0 ff ff       	call   800204 <_panic>

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  8011cd:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  8011d0:	8b 75 f8             	mov    -0x8(%ebp),%esi
  8011d3:	8b 7d fc             	mov    -0x4(%ebp),%edi
  8011d6:	89 ec                	mov    %ebp,%esp
  8011d8:	5d                   	pop    %ebp
  8011d9:	c3                   	ret    

008011da <sys_yield>:
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}

void
sys_yield(void)
{
  8011da:	55                   	push   %ebp
  8011db:	89 e5                	mov    %esp,%ebp
  8011dd:	83 ec 0c             	sub    $0xc,%esp
  8011e0:	89 1c 24             	mov    %ebx,(%esp)
  8011e3:	89 74 24 04          	mov    %esi,0x4(%esp)
  8011e7:	89 7c 24 08          	mov    %edi,0x8(%esp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8011eb:	ba 00 00 00 00       	mov    $0x0,%edx
  8011f0:	b8 0b 00 00 00       	mov    $0xb,%eax
  8011f5:	89 d1                	mov    %edx,%ecx
  8011f7:	89 d3                	mov    %edx,%ebx
  8011f9:	89 d7                	mov    %edx,%edi
  8011fb:	89 d6                	mov    %edx,%esi
  8011fd:	cd 30                	int    $0x30

void
sys_yield(void)
{
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  8011ff:	8b 1c 24             	mov    (%esp),%ebx
  801202:	8b 74 24 04          	mov    0x4(%esp),%esi
  801206:	8b 7c 24 08          	mov    0x8(%esp),%edi
  80120a:	89 ec                	mov    %ebp,%esp
  80120c:	5d                   	pop    %ebp
  80120d:	c3                   	ret    

0080120e <sys_getenvid>:
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}

envid_t
sys_getenvid(void)
{
  80120e:	55                   	push   %ebp
  80120f:	89 e5                	mov    %esp,%ebp
  801211:	83 ec 0c             	sub    $0xc,%esp
  801214:	89 1c 24             	mov    %ebx,(%esp)
  801217:	89 74 24 04          	mov    %esi,0x4(%esp)
  80121b:	89 7c 24 08          	mov    %edi,0x8(%esp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80121f:	ba 00 00 00 00       	mov    $0x0,%edx
  801224:	b8 02 00 00 00       	mov    $0x2,%eax
  801229:	89 d1                	mov    %edx,%ecx
  80122b:	89 d3                	mov    %edx,%ebx
  80122d:	89 d7                	mov    %edx,%edi
  80122f:	89 d6                	mov    %edx,%esi
  801231:	cd 30                	int    $0x30

envid_t
sys_getenvid(void)
{
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  801233:	8b 1c 24             	mov    (%esp),%ebx
  801236:	8b 74 24 04          	mov    0x4(%esp),%esi
  80123a:	8b 7c 24 08          	mov    0x8(%esp),%edi
  80123e:	89 ec                	mov    %ebp,%esp
  801240:	5d                   	pop    %ebp
  801241:	c3                   	ret    

00801242 <sys_env_destroy>:
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}

int
sys_env_destroy(envid_t envid)
{
  801242:	55                   	push   %ebp
  801243:	89 e5                	mov    %esp,%ebp
  801245:	83 ec 38             	sub    $0x38,%esp
  801248:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  80124b:	89 75 f8             	mov    %esi,-0x8(%ebp)
  80124e:	89 7d fc             	mov    %edi,-0x4(%ebp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801251:	b9 00 00 00 00       	mov    $0x0,%ecx
  801256:	b8 03 00 00 00       	mov    $0x3,%eax
  80125b:	8b 55 08             	mov    0x8(%ebp),%edx
  80125e:	89 cb                	mov    %ecx,%ebx
  801260:	89 cf                	mov    %ecx,%edi
  801262:	89 ce                	mov    %ecx,%esi
  801264:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
	
	if(check && ret > 0)
  801266:	85 c0                	test   %eax,%eax
  801268:	7e 28                	jle    801292 <sys_env_destroy+0x50>
		panic("syscall %d returned %d (> 0)", num, ret);
  80126a:	89 44 24 10          	mov    %eax,0x10(%esp)
  80126e:	c7 44 24 0c 03 00 00 	movl   $0x3,0xc(%esp)
  801275:	00 
  801276:	c7 44 24 08 ff 2d 80 	movl   $0x802dff,0x8(%esp)
  80127d:	00 
  80127e:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  801285:	00 
  801286:	c7 04 24 1c 2e 80 00 	movl   $0x802e1c,(%esp)
  80128d:	e8 72 ef ff ff       	call   800204 <_panic>

int
sys_env_destroy(envid_t envid)
{
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  801292:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  801295:	8b 75 f8             	mov    -0x8(%ebp),%esi
  801298:	8b 7d fc             	mov    -0x4(%ebp),%edi
  80129b:	89 ec                	mov    %ebp,%esp
  80129d:	5d                   	pop    %ebp
  80129e:	c3                   	ret    
	...

008012a0 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  8012a0:	55                   	push   %ebp
  8012a1:	89 e5                	mov    %esp,%ebp
  8012a3:	8b 45 08             	mov    0x8(%ebp),%eax
  8012a6:	05 00 00 00 30       	add    $0x30000000,%eax
  8012ab:	c1 e8 0c             	shr    $0xc,%eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
}
  8012ae:	5d                   	pop    %ebp
  8012af:	c3                   	ret    

008012b0 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  8012b0:	55                   	push   %ebp
  8012b1:	89 e5                	mov    %esp,%ebp
  8012b3:	83 ec 04             	sub    $0x4,%esp
	return INDEX2DATA(fd2num(fd));
  8012b6:	8b 45 08             	mov    0x8(%ebp),%eax
  8012b9:	89 04 24             	mov    %eax,(%esp)
  8012bc:	e8 df ff ff ff       	call   8012a0 <fd2num>
  8012c1:	05 20 00 0d 00       	add    $0xd0020,%eax
  8012c6:	c1 e0 0c             	shl    $0xc,%eax
}
  8012c9:	c9                   	leave  
  8012ca:	c3                   	ret    

008012cb <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  8012cb:	55                   	push   %ebp
  8012cc:	89 e5                	mov    %esp,%ebp
  8012ce:	57                   	push   %edi
  8012cf:	56                   	push   %esi
  8012d0:	53                   	push   %ebx
  8012d1:	8b 7d 08             	mov    0x8(%ebp),%edi
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((vpd[PDX(fd)] & PTE_P) == 0 || (vpt[VPN(fd)] & PTE_P) == 0) {
  8012d4:	a1 00 dd 7b ef       	mov    0xef7bdd00,%eax
  8012d9:	a8 01                	test   $0x1,%al
  8012db:	74 36                	je     801313 <fd_alloc+0x48>
  8012dd:	a1 00 00 74 ef       	mov    0xef740000,%eax
  8012e2:	a8 01                	test   $0x1,%al
  8012e4:	74 2d                	je     801313 <fd_alloc+0x48>
  8012e6:	b8 00 10 00 d0       	mov    $0xd0001000,%eax
  8012eb:	b9 00 d0 7b ef       	mov    $0xef7bd000,%ecx
  8012f0:	be 00 00 40 ef       	mov    $0xef400000,%esi
  8012f5:	89 c3                	mov    %eax,%ebx
  8012f7:	89 c2                	mov    %eax,%edx
  8012f9:	c1 ea 16             	shr    $0x16,%edx
  8012fc:	8b 14 91             	mov    (%ecx,%edx,4),%edx
  8012ff:	f6 c2 01             	test   $0x1,%dl
  801302:	74 14                	je     801318 <fd_alloc+0x4d>
  801304:	89 c2                	mov    %eax,%edx
  801306:	c1 ea 0c             	shr    $0xc,%edx
  801309:	8b 14 96             	mov    (%esi,%edx,4),%edx
  80130c:	f6 c2 01             	test   $0x1,%dl
  80130f:	75 10                	jne    801321 <fd_alloc+0x56>
  801311:	eb 05                	jmp    801318 <fd_alloc+0x4d>
  801313:	bb 00 00 00 d0       	mov    $0xd0000000,%ebx
			*fd_store = fd;
  801318:	89 1f                	mov    %ebx,(%edi)
  80131a:	b8 00 00 00 00       	mov    $0x0,%eax
			return 0;
  80131f:	eb 17                	jmp    801338 <fd_alloc+0x6d>
  801321:	05 00 10 00 00       	add    $0x1000,%eax
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  801326:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  80132b:	75 c8                	jne    8012f5 <fd_alloc+0x2a>
		if ((vpd[PDX(fd)] & PTE_P) == 0 || (vpt[VPN(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  80132d:	c7 07 00 00 00 00    	movl   $0x0,(%edi)
  801333:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
	return -E_MAX_OPEN;
}
  801338:	5b                   	pop    %ebx
  801339:	5e                   	pop    %esi
  80133a:	5f                   	pop    %edi
  80133b:	5d                   	pop    %ebp
  80133c:	c3                   	ret    

0080133d <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  80133d:	55                   	push   %ebp
  80133e:	89 e5                	mov    %esp,%ebp
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  801340:	8b 45 08             	mov    0x8(%ebp),%eax
  801343:	83 f8 1f             	cmp    $0x1f,%eax
  801346:	77 36                	ja     80137e <fd_lookup+0x41>
		if (debug)
			cprintf("[%08x] bad fd %d\n", env->env_id, fd);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  801348:	05 00 00 0d 00       	add    $0xd0000,%eax
  80134d:	c1 e0 0c             	shl    $0xc,%eax
	if (!(vpd[PDX(fd)] & PTE_P) || !(vpt[VPN(fd)] & PTE_P)) {
  801350:	89 c2                	mov    %eax,%edx
  801352:	c1 ea 16             	shr    $0x16,%edx
  801355:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  80135c:	f6 c2 01             	test   $0x1,%dl
  80135f:	74 1d                	je     80137e <fd_lookup+0x41>
  801361:	89 c2                	mov    %eax,%edx
  801363:	c1 ea 0c             	shr    $0xc,%edx
  801366:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  80136d:	f6 c2 01             	test   $0x1,%dl
  801370:	74 0c                	je     80137e <fd_lookup+0x41>
		if (debug)
			cprintf("[%08x] closed fd %d\n", env->env_id, fd);
		return -E_INVAL;
	}
	*fd_store = fd;
  801372:	8b 55 0c             	mov    0xc(%ebp),%edx
  801375:	89 02                	mov    %eax,(%edx)
  801377:	b8 00 00 00 00       	mov    $0x0,%eax
	return 0;
  80137c:	eb 05                	jmp    801383 <fd_lookup+0x46>
  80137e:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  801383:	5d                   	pop    %ebp
  801384:	c3                   	ret    

00801385 <seek>:
	return (*dev->dev_write)(fd, buf, n);
}

int
seek(int fdnum, off_t offset)
{
  801385:	55                   	push   %ebp
  801386:	89 e5                	mov    %esp,%ebp
  801388:	83 ec 18             	sub    $0x18,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80138b:	8d 45 fc             	lea    -0x4(%ebp),%eax
  80138e:	89 44 24 04          	mov    %eax,0x4(%esp)
  801392:	8b 45 08             	mov    0x8(%ebp),%eax
  801395:	89 04 24             	mov    %eax,(%esp)
  801398:	e8 a0 ff ff ff       	call   80133d <fd_lookup>
  80139d:	85 c0                	test   %eax,%eax
  80139f:	78 0e                	js     8013af <seek+0x2a>
		return r;
	fd->fd_offset = offset;
  8013a1:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8013a4:	8b 55 0c             	mov    0xc(%ebp),%edx
  8013a7:	89 50 04             	mov    %edx,0x4(%eax)
  8013aa:	b8 00 00 00 00       	mov    $0x0,%eax
	return 0;
}
  8013af:	c9                   	leave  
  8013b0:	c3                   	ret    

008013b1 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  8013b1:	55                   	push   %ebp
  8013b2:	89 e5                	mov    %esp,%ebp
  8013b4:	56                   	push   %esi
  8013b5:	53                   	push   %ebx
  8013b6:	83 ec 10             	sub    $0x10,%esp
  8013b9:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8013bc:	8b 5d 0c             	mov    0xc(%ebp),%ebx
// File functions
// --------------------------------------------------------------

static struct Dev *devtab[] =
{
	&devfile,
  8013bf:	b8 04 60 80 00       	mov    $0x806004,%eax
{
	int i;
	for (i = 0; devtab[i]; i++)
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
  8013c4:	ba 00 00 00 00       	mov    $0x0,%edx

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  8013c9:	be a8 2e 80 00       	mov    $0x802ea8,%esi
		if (devtab[i]->dev_id == dev_id) {
  8013ce:	39 08                	cmp    %ecx,(%eax)
  8013d0:	75 10                	jne    8013e2 <dev_lookup+0x31>
  8013d2:	eb 04                	jmp    8013d8 <dev_lookup+0x27>
  8013d4:	39 08                	cmp    %ecx,(%eax)
  8013d6:	75 0a                	jne    8013e2 <dev_lookup+0x31>
			*dev = devtab[i];
  8013d8:	89 03                	mov    %eax,(%ebx)
  8013da:	b8 00 00 00 00       	mov    $0x0,%eax
			return 0;
  8013df:	90                   	nop
  8013e0:	eb 31                	jmp    801413 <dev_lookup+0x62>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  8013e2:	83 c2 01             	add    $0x1,%edx
  8013e5:	8b 04 96             	mov    (%esi,%edx,4),%eax
  8013e8:	85 c0                	test   %eax,%eax
  8013ea:	75 e8                	jne    8013d4 <dev_lookup+0x23>
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", env->env_id, dev_id);
  8013ec:	a1 74 60 80 00       	mov    0x806074,%eax
  8013f1:	8b 40 4c             	mov    0x4c(%eax),%eax
  8013f4:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8013f8:	89 44 24 04          	mov    %eax,0x4(%esp)
  8013fc:	c7 04 24 2c 2e 80 00 	movl   $0x802e2c,(%esp)
  801403:	e8 c1 ee ff ff       	call   8002c9 <cprintf>
	*dev = 0;
  801408:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  80140e:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
	return -E_INVAL;
}
  801413:	83 c4 10             	add    $0x10,%esp
  801416:	5b                   	pop    %ebx
  801417:	5e                   	pop    %esi
  801418:	5d                   	pop    %ebp
  801419:	c3                   	ret    

0080141a <fstat>:
	return (*dev->dev_trunc)(fd, newsize);
}

int
fstat(int fdnum, struct Stat *stat)
{
  80141a:	55                   	push   %ebp
  80141b:	89 e5                	mov    %esp,%ebp
  80141d:	53                   	push   %ebx
  80141e:	83 ec 24             	sub    $0x24,%esp
  801421:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801424:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801427:	89 44 24 04          	mov    %eax,0x4(%esp)
  80142b:	8b 45 08             	mov    0x8(%ebp),%eax
  80142e:	89 04 24             	mov    %eax,(%esp)
  801431:	e8 07 ff ff ff       	call   80133d <fd_lookup>
  801436:	85 c0                	test   %eax,%eax
  801438:	78 53                	js     80148d <fstat+0x73>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80143a:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80143d:	89 44 24 04          	mov    %eax,0x4(%esp)
  801441:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801444:	8b 00                	mov    (%eax),%eax
  801446:	89 04 24             	mov    %eax,(%esp)
  801449:	e8 63 ff ff ff       	call   8013b1 <dev_lookup>
{
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80144e:	85 c0                	test   %eax,%eax
  801450:	78 3b                	js     80148d <fstat+0x73>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if (!dev->dev_stat)
  801452:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801457:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80145a:	83 7a 14 00          	cmpl   $0x0,0x14(%edx)
  80145e:	74 2d                	je     80148d <fstat+0x73>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  801460:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  801463:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  80146a:	00 00 00 
	stat->st_isdir = 0;
  80146d:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801474:	00 00 00 
	stat->st_dev = dev;
  801477:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80147a:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  801480:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801484:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801487:	89 14 24             	mov    %edx,(%esp)
  80148a:	ff 50 14             	call   *0x14(%eax)
}
  80148d:	83 c4 24             	add    $0x24,%esp
  801490:	5b                   	pop    %ebx
  801491:	5d                   	pop    %ebp
  801492:	c3                   	ret    

00801493 <ftruncate>:
	return 0;
}

int
ftruncate(int fdnum, off_t newsize)
{
  801493:	55                   	push   %ebp
  801494:	89 e5                	mov    %esp,%ebp
  801496:	53                   	push   %ebx
  801497:	83 ec 24             	sub    $0x24,%esp
  80149a:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  80149d:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8014a0:	89 44 24 04          	mov    %eax,0x4(%esp)
  8014a4:	89 1c 24             	mov    %ebx,(%esp)
  8014a7:	e8 91 fe ff ff       	call   80133d <fd_lookup>
  8014ac:	85 c0                	test   %eax,%eax
  8014ae:	78 5f                	js     80150f <ftruncate+0x7c>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8014b0:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8014b3:	89 44 24 04          	mov    %eax,0x4(%esp)
  8014b7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8014ba:	8b 00                	mov    (%eax),%eax
  8014bc:	89 04 24             	mov    %eax,(%esp)
  8014bf:	e8 ed fe ff ff       	call   8013b1 <dev_lookup>
ftruncate(int fdnum, off_t newsize)
{
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  8014c4:	85 c0                	test   %eax,%eax
  8014c6:	78 47                	js     80150f <ftruncate+0x7c>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8014c8:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8014cb:	f6 42 08 03          	testb  $0x3,0x8(%edx)
  8014cf:	75 23                	jne    8014f4 <ftruncate+0x61>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			env->env_id, fdnum); 
  8014d1:	a1 74 60 80 00       	mov    0x806074,%eax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  8014d6:	8b 40 4c             	mov    0x4c(%eax),%eax
  8014d9:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8014dd:	89 44 24 04          	mov    %eax,0x4(%esp)
  8014e1:	c7 04 24 4c 2e 80 00 	movl   $0x802e4c,(%esp)
  8014e8:	e8 dc ed ff ff       	call   8002c9 <cprintf>
  8014ed:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
			env->env_id, fdnum); 
		return -E_INVAL;
  8014f2:	eb 1b                	jmp    80150f <ftruncate+0x7c>
	}
	if (!dev->dev_trunc)
  8014f4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8014f7:	8b 48 18             	mov    0x18(%eax),%ecx
  8014fa:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8014ff:	85 c9                	test   %ecx,%ecx
  801501:	74 0c                	je     80150f <ftruncate+0x7c>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  801503:	8b 45 0c             	mov    0xc(%ebp),%eax
  801506:	89 44 24 04          	mov    %eax,0x4(%esp)
  80150a:	89 14 24             	mov    %edx,(%esp)
  80150d:	ff d1                	call   *%ecx
}
  80150f:	83 c4 24             	add    $0x24,%esp
  801512:	5b                   	pop    %ebx
  801513:	5d                   	pop    %ebp
  801514:	c3                   	ret    

00801515 <write>:
	return tot;
}

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  801515:	55                   	push   %ebp
  801516:	89 e5                	mov    %esp,%ebp
  801518:	53                   	push   %ebx
  801519:	83 ec 24             	sub    $0x24,%esp
  80151c:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80151f:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801522:	89 44 24 04          	mov    %eax,0x4(%esp)
  801526:	89 1c 24             	mov    %ebx,(%esp)
  801529:	e8 0f fe ff ff       	call   80133d <fd_lookup>
  80152e:	85 c0                	test   %eax,%eax
  801530:	78 66                	js     801598 <write+0x83>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801532:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801535:	89 44 24 04          	mov    %eax,0x4(%esp)
  801539:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80153c:	8b 00                	mov    (%eax),%eax
  80153e:	89 04 24             	mov    %eax,(%esp)
  801541:	e8 6b fe ff ff       	call   8013b1 <dev_lookup>
{
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801546:	85 c0                	test   %eax,%eax
  801548:	78 4e                	js     801598 <write+0x83>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  80154a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80154d:	f6 42 08 03          	testb  $0x3,0x8(%edx)
  801551:	75 23                	jne    801576 <write+0x61>
		cprintf("[%08x] write %d -- bad mode\n", env->env_id, fdnum);
  801553:	a1 74 60 80 00       	mov    0x806074,%eax
  801558:	8b 40 4c             	mov    0x4c(%eax),%eax
  80155b:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80155f:	89 44 24 04          	mov    %eax,0x4(%esp)
  801563:	c7 04 24 6d 2e 80 00 	movl   $0x802e6d,(%esp)
  80156a:	e8 5a ed ff ff       	call   8002c9 <cprintf>
  80156f:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
		return -E_INVAL;
  801574:	eb 22                	jmp    801598 <write+0x83>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  801576:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801579:	8b 48 0c             	mov    0xc(%eax),%ecx
  80157c:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801581:	85 c9                	test   %ecx,%ecx
  801583:	74 13                	je     801598 <write+0x83>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  801585:	8b 45 10             	mov    0x10(%ebp),%eax
  801588:	89 44 24 08          	mov    %eax,0x8(%esp)
  80158c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80158f:	89 44 24 04          	mov    %eax,0x4(%esp)
  801593:	89 14 24             	mov    %edx,(%esp)
  801596:	ff d1                	call   *%ecx
}
  801598:	83 c4 24             	add    $0x24,%esp
  80159b:	5b                   	pop    %ebx
  80159c:	5d                   	pop    %ebp
  80159d:	c3                   	ret    

0080159e <read>:
	return r;
}

ssize_t
read(int fdnum, void *buf, size_t n)
{
  80159e:	55                   	push   %ebp
  80159f:	89 e5                	mov    %esp,%ebp
  8015a1:	53                   	push   %ebx
  8015a2:	83 ec 24             	sub    $0x24,%esp
  8015a5:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8015a8:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8015ab:	89 44 24 04          	mov    %eax,0x4(%esp)
  8015af:	89 1c 24             	mov    %ebx,(%esp)
  8015b2:	e8 86 fd ff ff       	call   80133d <fd_lookup>
  8015b7:	85 c0                	test   %eax,%eax
  8015b9:	78 6b                	js     801626 <read+0x88>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8015bb:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8015be:	89 44 24 04          	mov    %eax,0x4(%esp)
  8015c2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8015c5:	8b 00                	mov    (%eax),%eax
  8015c7:	89 04 24             	mov    %eax,(%esp)
  8015ca:	e8 e2 fd ff ff       	call   8013b1 <dev_lookup>
{
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8015cf:	85 c0                	test   %eax,%eax
  8015d1:	78 53                	js     801626 <read+0x88>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  8015d3:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8015d6:	8b 42 08             	mov    0x8(%edx),%eax
  8015d9:	83 e0 03             	and    $0x3,%eax
  8015dc:	83 f8 01             	cmp    $0x1,%eax
  8015df:	75 23                	jne    801604 <read+0x66>
		cprintf("[%08x] read %d -- bad mode\n", env->env_id, fdnum); 
  8015e1:	a1 74 60 80 00       	mov    0x806074,%eax
  8015e6:	8b 40 4c             	mov    0x4c(%eax),%eax
  8015e9:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8015ed:	89 44 24 04          	mov    %eax,0x4(%esp)
  8015f1:	c7 04 24 8a 2e 80 00 	movl   $0x802e8a,(%esp)
  8015f8:	e8 cc ec ff ff       	call   8002c9 <cprintf>
  8015fd:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
		return -E_INVAL;
  801602:	eb 22                	jmp    801626 <read+0x88>
	}
	if (!dev->dev_read)
  801604:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801607:	8b 48 08             	mov    0x8(%eax),%ecx
  80160a:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  80160f:	85 c9                	test   %ecx,%ecx
  801611:	74 13                	je     801626 <read+0x88>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  801613:	8b 45 10             	mov    0x10(%ebp),%eax
  801616:	89 44 24 08          	mov    %eax,0x8(%esp)
  80161a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80161d:	89 44 24 04          	mov    %eax,0x4(%esp)
  801621:	89 14 24             	mov    %edx,(%esp)
  801624:	ff d1                	call   *%ecx
}
  801626:	83 c4 24             	add    $0x24,%esp
  801629:	5b                   	pop    %ebx
  80162a:	5d                   	pop    %ebp
  80162b:	c3                   	ret    

0080162c <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  80162c:	55                   	push   %ebp
  80162d:	89 e5                	mov    %esp,%ebp
  80162f:	57                   	push   %edi
  801630:	56                   	push   %esi
  801631:	53                   	push   %ebx
  801632:	83 ec 1c             	sub    $0x1c,%esp
  801635:	8b 7d 08             	mov    0x8(%ebp),%edi
  801638:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  80163b:	ba 00 00 00 00       	mov    $0x0,%edx
  801640:	bb 00 00 00 00       	mov    $0x0,%ebx
  801645:	b8 00 00 00 00       	mov    $0x0,%eax
  80164a:	85 f6                	test   %esi,%esi
  80164c:	74 29                	je     801677 <readn+0x4b>
		m = read(fdnum, (char*)buf + tot, n - tot);
  80164e:	89 f0                	mov    %esi,%eax
  801650:	29 d0                	sub    %edx,%eax
  801652:	89 44 24 08          	mov    %eax,0x8(%esp)
  801656:	03 55 0c             	add    0xc(%ebp),%edx
  801659:	89 54 24 04          	mov    %edx,0x4(%esp)
  80165d:	89 3c 24             	mov    %edi,(%esp)
  801660:	e8 39 ff ff ff       	call   80159e <read>
		if (m < 0)
  801665:	85 c0                	test   %eax,%eax
  801667:	78 0e                	js     801677 <readn+0x4b>
			return m;
		if (m == 0)
  801669:	85 c0                	test   %eax,%eax
  80166b:	74 08                	je     801675 <readn+0x49>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  80166d:	01 c3                	add    %eax,%ebx
  80166f:	89 da                	mov    %ebx,%edx
  801671:	39 f3                	cmp    %esi,%ebx
  801673:	72 d9                	jb     80164e <readn+0x22>
  801675:	89 d8                	mov    %ebx,%eax
			return m;
		if (m == 0)
			break;
	}
	return tot;
}
  801677:	83 c4 1c             	add    $0x1c,%esp
  80167a:	5b                   	pop    %ebx
  80167b:	5e                   	pop    %esi
  80167c:	5f                   	pop    %edi
  80167d:	5d                   	pop    %ebp
  80167e:	c3                   	ret    

0080167f <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  80167f:	55                   	push   %ebp
  801680:	89 e5                	mov    %esp,%ebp
  801682:	56                   	push   %esi
  801683:	53                   	push   %ebx
  801684:	83 ec 20             	sub    $0x20,%esp
  801687:	8b 75 08             	mov    0x8(%ebp),%esi
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  80168a:	89 34 24             	mov    %esi,(%esp)
  80168d:	e8 0e fc ff ff       	call   8012a0 <fd2num>
  801692:	8d 55 f4             	lea    -0xc(%ebp),%edx
  801695:	89 54 24 04          	mov    %edx,0x4(%esp)
  801699:	89 04 24             	mov    %eax,(%esp)
  80169c:	e8 9c fc ff ff       	call   80133d <fd_lookup>
  8016a1:	89 c3                	mov    %eax,%ebx
  8016a3:	85 c0                	test   %eax,%eax
  8016a5:	78 05                	js     8016ac <fd_close+0x2d>
  8016a7:	3b 75 f4             	cmp    -0xc(%ebp),%esi
  8016aa:	74 0c                	je     8016b8 <fd_close+0x39>
	    || fd != fd2)
		return (must_exist ? r : 0);
  8016ac:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8016b0:	19 c0                	sbb    %eax,%eax
  8016b2:	f7 d0                	not    %eax
  8016b4:	21 c3                	and    %eax,%ebx
  8016b6:	eb 3d                	jmp    8016f5 <fd_close+0x76>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  8016b8:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8016bb:	89 44 24 04          	mov    %eax,0x4(%esp)
  8016bf:	8b 06                	mov    (%esi),%eax
  8016c1:	89 04 24             	mov    %eax,(%esp)
  8016c4:	e8 e8 fc ff ff       	call   8013b1 <dev_lookup>
  8016c9:	89 c3                	mov    %eax,%ebx
  8016cb:	85 c0                	test   %eax,%eax
  8016cd:	78 16                	js     8016e5 <fd_close+0x66>
		if (dev->dev_close)
  8016cf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8016d2:	8b 40 10             	mov    0x10(%eax),%eax
  8016d5:	bb 00 00 00 00       	mov    $0x0,%ebx
  8016da:	85 c0                	test   %eax,%eax
  8016dc:	74 07                	je     8016e5 <fd_close+0x66>
			r = (*dev->dev_close)(fd);
  8016de:	89 34 24             	mov    %esi,(%esp)
  8016e1:	ff d0                	call   *%eax
  8016e3:	89 c3                	mov    %eax,%ebx
		else
			r = 0;
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  8016e5:	89 74 24 04          	mov    %esi,0x4(%esp)
  8016e9:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8016f0:	e8 ca f9 ff ff       	call   8010bf <sys_page_unmap>
	return r;
}
  8016f5:	89 d8                	mov    %ebx,%eax
  8016f7:	83 c4 20             	add    $0x20,%esp
  8016fa:	5b                   	pop    %ebx
  8016fb:	5e                   	pop    %esi
  8016fc:	5d                   	pop    %ebp
  8016fd:	c3                   	ret    

008016fe <close>:
	return -E_INVAL;
}

int
close(int fdnum)
{
  8016fe:	55                   	push   %ebp
  8016ff:	89 e5                	mov    %esp,%ebp
  801701:	83 ec 28             	sub    $0x28,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801704:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801707:	89 44 24 04          	mov    %eax,0x4(%esp)
  80170b:	8b 45 08             	mov    0x8(%ebp),%eax
  80170e:	89 04 24             	mov    %eax,(%esp)
  801711:	e8 27 fc ff ff       	call   80133d <fd_lookup>
  801716:	85 c0                	test   %eax,%eax
  801718:	78 13                	js     80172d <close+0x2f>
		return r;
	else
		return fd_close(fd, 1);
  80171a:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  801721:	00 
  801722:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801725:	89 04 24             	mov    %eax,(%esp)
  801728:	e8 52 ff ff ff       	call   80167f <fd_close>
}
  80172d:	c9                   	leave  
  80172e:	c3                   	ret    

0080172f <stat>:
	return (*dev->dev_stat)(fd, stat);
}

int
stat(const char *path, struct Stat *stat)
{
  80172f:	55                   	push   %ebp
  801730:	89 e5                	mov    %esp,%ebp
  801732:	83 ec 18             	sub    $0x18,%esp
  801735:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  801738:	89 75 fc             	mov    %esi,-0x4(%ebp)
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  80173b:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  801742:	00 
  801743:	8b 45 08             	mov    0x8(%ebp),%eax
  801746:	89 04 24             	mov    %eax,(%esp)
  801749:	e8 55 03 00 00       	call   801aa3 <open>
  80174e:	89 c3                	mov    %eax,%ebx
  801750:	85 c0                	test   %eax,%eax
  801752:	78 1b                	js     80176f <stat+0x40>
		return fd;
	r = fstat(fd, stat);
  801754:	8b 45 0c             	mov    0xc(%ebp),%eax
  801757:	89 44 24 04          	mov    %eax,0x4(%esp)
  80175b:	89 1c 24             	mov    %ebx,(%esp)
  80175e:	e8 b7 fc ff ff       	call   80141a <fstat>
  801763:	89 c6                	mov    %eax,%esi
	close(fd);
  801765:	89 1c 24             	mov    %ebx,(%esp)
  801768:	e8 91 ff ff ff       	call   8016fe <close>
  80176d:	89 f3                	mov    %esi,%ebx
	return r;
}
  80176f:	89 d8                	mov    %ebx,%eax
  801771:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  801774:	8b 75 fc             	mov    -0x4(%ebp),%esi
  801777:	89 ec                	mov    %ebp,%esp
  801779:	5d                   	pop    %ebp
  80177a:	c3                   	ret    

0080177b <close_all>:
		return fd_close(fd, 1);
}

void
close_all(void)
{
  80177b:	55                   	push   %ebp
  80177c:	89 e5                	mov    %esp,%ebp
  80177e:	53                   	push   %ebx
  80177f:	83 ec 14             	sub    $0x14,%esp
  801782:	bb 00 00 00 00       	mov    $0x0,%ebx
	int i;
	for (i = 0; i < MAXFD; i++)
		close(i);
  801787:	89 1c 24             	mov    %ebx,(%esp)
  80178a:	e8 6f ff ff ff       	call   8016fe <close>

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  80178f:	83 c3 01             	add    $0x1,%ebx
  801792:	83 fb 20             	cmp    $0x20,%ebx
  801795:	75 f0                	jne    801787 <close_all+0xc>
		close(i);
}
  801797:	83 c4 14             	add    $0x14,%esp
  80179a:	5b                   	pop    %ebx
  80179b:	5d                   	pop    %ebp
  80179c:	c3                   	ret    

0080179d <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  80179d:	55                   	push   %ebp
  80179e:	89 e5                	mov    %esp,%ebp
  8017a0:	83 ec 58             	sub    $0x58,%esp
  8017a3:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  8017a6:	89 75 f8             	mov    %esi,-0x8(%ebp)
  8017a9:	89 7d fc             	mov    %edi,-0x4(%ebp)
  8017ac:	8b 7d 0c             	mov    0xc(%ebp),%edi
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  8017af:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  8017b2:	89 44 24 04          	mov    %eax,0x4(%esp)
  8017b6:	8b 45 08             	mov    0x8(%ebp),%eax
  8017b9:	89 04 24             	mov    %eax,(%esp)
  8017bc:	e8 7c fb ff ff       	call   80133d <fd_lookup>
  8017c1:	89 c3                	mov    %eax,%ebx
  8017c3:	85 c0                	test   %eax,%eax
  8017c5:	0f 88 e0 00 00 00    	js     8018ab <dup+0x10e>
		return r;
	close(newfdnum);
  8017cb:	89 3c 24             	mov    %edi,(%esp)
  8017ce:	e8 2b ff ff ff       	call   8016fe <close>

	newfd = INDEX2FD(newfdnum);
  8017d3:	8d b7 00 00 0d 00    	lea    0xd0000(%edi),%esi
  8017d9:	c1 e6 0c             	shl    $0xc,%esi
	ova = fd2data(oldfd);
  8017dc:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8017df:	89 04 24             	mov    %eax,(%esp)
  8017e2:	e8 c9 fa ff ff       	call   8012b0 <fd2data>
  8017e7:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  8017e9:	89 34 24             	mov    %esi,(%esp)
  8017ec:	e8 bf fa ff ff       	call   8012b0 <fd2data>
  8017f1:	89 45 d4             	mov    %eax,-0x2c(%ebp)

	if ((vpd[PDX(ova)] & PTE_P) && (vpt[VPN(ova)] & PTE_P))
  8017f4:	89 da                	mov    %ebx,%edx
  8017f6:	89 d8                	mov    %ebx,%eax
  8017f8:	c1 e8 16             	shr    $0x16,%eax
  8017fb:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801802:	a8 01                	test   $0x1,%al
  801804:	74 43                	je     801849 <dup+0xac>
  801806:	c1 ea 0c             	shr    $0xc,%edx
  801809:	8b 04 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%eax
  801810:	a8 01                	test   $0x1,%al
  801812:	74 35                	je     801849 <dup+0xac>
		if ((r = sys_page_map(0, ova, 0, nva, vpt[VPN(ova)] & PTE_USER)) < 0)
  801814:	8b 04 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%eax
  80181b:	25 07 0e 00 00       	and    $0xe07,%eax
  801820:	89 44 24 10          	mov    %eax,0x10(%esp)
  801824:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801827:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80182b:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801832:	00 
  801833:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801837:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80183e:	e8 da f8 ff ff       	call   80111d <sys_page_map>
  801843:	89 c3                	mov    %eax,%ebx
  801845:	85 c0                	test   %eax,%eax
  801847:	78 3f                	js     801888 <dup+0xeb>
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, vpt[VPN(oldfd)] & PTE_USER)) < 0)
  801849:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80184c:	89 c2                	mov    %eax,%edx
  80184e:	c1 ea 0c             	shr    $0xc,%edx
  801851:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801858:	81 e2 07 0e 00 00    	and    $0xe07,%edx
  80185e:	89 54 24 10          	mov    %edx,0x10(%esp)
  801862:	89 74 24 0c          	mov    %esi,0xc(%esp)
  801866:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  80186d:	00 
  80186e:	89 44 24 04          	mov    %eax,0x4(%esp)
  801872:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801879:	e8 9f f8 ff ff       	call   80111d <sys_page_map>
  80187e:	89 c3                	mov    %eax,%ebx
  801880:	85 c0                	test   %eax,%eax
  801882:	78 04                	js     801888 <dup+0xeb>
  801884:	89 fb                	mov    %edi,%ebx
  801886:	eb 23                	jmp    8018ab <dup+0x10e>
		goto err;

	return newfdnum;

err:
	sys_page_unmap(0, newfd);
  801888:	89 74 24 04          	mov    %esi,0x4(%esp)
  80188c:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801893:	e8 27 f8 ff ff       	call   8010bf <sys_page_unmap>
	sys_page_unmap(0, nva);
  801898:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80189b:	89 44 24 04          	mov    %eax,0x4(%esp)
  80189f:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8018a6:	e8 14 f8 ff ff       	call   8010bf <sys_page_unmap>
	return r;
}
  8018ab:	89 d8                	mov    %ebx,%eax
  8018ad:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  8018b0:	8b 75 f8             	mov    -0x8(%ebp),%esi
  8018b3:	8b 7d fc             	mov    -0x4(%ebp),%edi
  8018b6:	89 ec                	mov    %ebp,%esp
  8018b8:	5d                   	pop    %ebp
  8018b9:	c3                   	ret    
	...

008018bc <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  8018bc:	55                   	push   %ebp
  8018bd:	89 e5                	mov    %esp,%ebp
  8018bf:	53                   	push   %ebx
  8018c0:	83 ec 14             	sub    $0x14,%esp
  8018c3:	89 d3                	mov    %edx,%ebx
	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", env->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(envs[1].env_id, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  8018c5:	8b 15 c8 00 c0 ee    	mov    0xeec000c8,%edx
  8018cb:	c7 44 24 0c 07 00 00 	movl   $0x7,0xc(%esp)
  8018d2:	00 
  8018d3:	c7 44 24 08 00 30 80 	movl   $0x803000,0x8(%esp)
  8018da:	00 
  8018db:	89 44 24 04          	mov    %eax,0x4(%esp)
  8018df:	89 14 24             	mov    %edx,(%esp)
  8018e2:	e8 f9 0d 00 00       	call   8026e0 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  8018e7:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  8018ee:	00 
  8018ef:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8018f3:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8018fa:	e8 47 0e 00 00       	call   802746 <ipc_recv>
}
  8018ff:	83 c4 14             	add    $0x14,%esp
  801902:	5b                   	pop    %ebx
  801903:	5d                   	pop    %ebp
  801904:	c3                   	ret    

00801905 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  801905:	55                   	push   %ebp
  801906:	89 e5                	mov    %esp,%ebp
  801908:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  80190b:	8b 45 08             	mov    0x8(%ebp),%eax
  80190e:	8b 40 0c             	mov    0xc(%eax),%eax
  801911:	a3 00 30 80 00       	mov    %eax,0x803000
	fsipcbuf.set_size.req_size = newsize;
  801916:	8b 45 0c             	mov    0xc(%ebp),%eax
  801919:	a3 04 30 80 00       	mov    %eax,0x803004
	return fsipc(FSREQ_SET_SIZE, NULL);
  80191e:	ba 00 00 00 00       	mov    $0x0,%edx
  801923:	b8 02 00 00 00       	mov    $0x2,%eax
  801928:	e8 8f ff ff ff       	call   8018bc <fsipc>
}
  80192d:	c9                   	leave  
  80192e:	c3                   	ret    

0080192f <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  80192f:	55                   	push   %ebp
  801930:	89 e5                	mov    %esp,%ebp
  801932:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  801935:	8b 45 08             	mov    0x8(%ebp),%eax
  801938:	8b 40 0c             	mov    0xc(%eax),%eax
  80193b:	a3 00 30 80 00       	mov    %eax,0x803000
	return fsipc(FSREQ_FLUSH, NULL);
  801940:	ba 00 00 00 00       	mov    $0x0,%edx
  801945:	b8 06 00 00 00       	mov    $0x6,%eax
  80194a:	e8 6d ff ff ff       	call   8018bc <fsipc>
}
  80194f:	c9                   	leave  
  801950:	c3                   	ret    

00801951 <sync>:
}

// Synchronize disk with buffer cache
int
sync(void)
{
  801951:	55                   	push   %ebp
  801952:	89 e5                	mov    %esp,%ebp
  801954:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  801957:	ba 00 00 00 00       	mov    $0x0,%edx
  80195c:	b8 08 00 00 00       	mov    $0x8,%eax
  801961:	e8 56 ff ff ff       	call   8018bc <fsipc>
}
  801966:	c9                   	leave  
  801967:	c3                   	ret    

00801968 <devfile_stat>:
	return fsipc(FSREQ_WRITE, NULL);	
}

static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  801968:	55                   	push   %ebp
  801969:	89 e5                	mov    %esp,%ebp
  80196b:	53                   	push   %ebx
  80196c:	83 ec 14             	sub    $0x14,%esp
  80196f:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  801972:	8b 45 08             	mov    0x8(%ebp),%eax
  801975:	8b 40 0c             	mov    0xc(%eax),%eax
  801978:	a3 00 30 80 00       	mov    %eax,0x803000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  80197d:	ba 00 00 00 00       	mov    $0x0,%edx
  801982:	b8 05 00 00 00       	mov    $0x5,%eax
  801987:	e8 30 ff ff ff       	call   8018bc <fsipc>
  80198c:	85 c0                	test   %eax,%eax
  80198e:	78 2b                	js     8019bb <devfile_stat+0x53>
		return r;
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  801990:	c7 44 24 04 00 30 80 	movl   $0x803000,0x4(%esp)
  801997:	00 
  801998:	89 1c 24             	mov    %ebx,(%esp)
  80199b:	e8 ea ef ff ff       	call   80098a <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  8019a0:	a1 80 30 80 00       	mov    0x803080,%eax
  8019a5:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  8019ab:	a1 84 30 80 00       	mov    0x803084,%eax
  8019b0:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
  8019b6:	b8 00 00 00 00       	mov    $0x0,%eax
	return 0;
}
  8019bb:	83 c4 14             	add    $0x14,%esp
  8019be:	5b                   	pop    %ebx
  8019bf:	5d                   	pop    %ebp
  8019c0:	c3                   	ret    

008019c1 <devfile_write>:
// Returns:
//	 The number of bytes successfully written.
//	 < 0 on error.
static ssize_t
devfile_write(struct Fd *fd, const void *buf, size_t n)
{
  8019c1:	55                   	push   %ebp
  8019c2:	89 e5                	mov    %esp,%ebp
  8019c4:	83 ec 18             	sub    $0x18,%esp
  8019c7:	8b 45 10             	mov    0x10(%ebp),%eax
  8019ca:	3d f8 0f 00 00       	cmp    $0xff8,%eax
  8019cf:	76 05                	jbe    8019d6 <devfile_write+0x15>
  8019d1:	b8 f8 0f 00 00       	mov    $0xff8,%eax
	// LAB 5: Your code here
	//panic("devfile_write not implemented");
	
	if (n > (PGSIZE - (sizeof(int) + sizeof(size_t))))
		n = PGSIZE - (sizeof(int) + sizeof(size_t));
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  8019d6:	8b 55 08             	mov    0x8(%ebp),%edx
  8019d9:	8b 52 0c             	mov    0xc(%edx),%edx
  8019dc:	89 15 00 30 80 00    	mov    %edx,0x803000
	fsipcbuf.write.req_n = n;
  8019e2:	a3 04 30 80 00       	mov    %eax,0x803004
	memmove (fsipcbuf.write.req_buf, (char*)buf, n);	
  8019e7:	89 44 24 08          	mov    %eax,0x8(%esp)
  8019eb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8019ee:	89 44 24 04          	mov    %eax,0x4(%esp)
  8019f2:	c7 04 24 08 30 80 00 	movl   $0x803008,(%esp)
  8019f9:	e8 47 f1 ff ff       	call   800b45 <memmove>
	return fsipc(FSREQ_WRITE, NULL);	
  8019fe:	ba 00 00 00 00       	mov    $0x0,%edx
  801a03:	b8 04 00 00 00       	mov    $0x4,%eax
  801a08:	e8 af fe ff ff       	call   8018bc <fsipc>
}
  801a0d:	c9                   	leave  
  801a0e:	c3                   	ret    

00801a0f <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  801a0f:	55                   	push   %ebp
  801a10:	89 e5                	mov    %esp,%ebp
  801a12:	53                   	push   %ebx
  801a13:	83 ec 14             	sub    $0x14,%esp
	// system server.
	// LAB 5: Your code here
	
	//panic("devfile_read not implemented");
	int r;
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  801a16:	8b 45 08             	mov    0x8(%ebp),%eax
  801a19:	8b 40 0c             	mov    0xc(%eax),%eax
  801a1c:	a3 00 30 80 00       	mov    %eax,0x803000
	fsipcbuf.read.req_n = n;
  801a21:	8b 45 10             	mov    0x10(%ebp),%eax
  801a24:	a3 04 30 80 00       	mov    %eax,0x803004
	if ((r = fsipc(FSREQ_READ, (void*)&fsipcbuf)) < 0)
  801a29:	ba 00 30 80 00       	mov    $0x803000,%edx
  801a2e:	b8 03 00 00 00       	mov    $0x3,%eax
  801a33:	e8 84 fe ff ff       	call   8018bc <fsipc>
  801a38:	89 c3                	mov    %eax,%ebx
  801a3a:	85 c0                	test   %eax,%eax
  801a3c:	78 17                	js     801a55 <devfile_read+0x46>
		return r;
	memmove((void*)buf, (void*)fsipcbuf.readRet.ret_buf, r);
  801a3e:	89 44 24 08          	mov    %eax,0x8(%esp)
  801a42:	c7 44 24 04 00 30 80 	movl   $0x803000,0x4(%esp)
  801a49:	00 
  801a4a:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a4d:	89 04 24             	mov    %eax,(%esp)
  801a50:	e8 f0 f0 ff ff       	call   800b45 <memmove>
	return r;
}
  801a55:	89 d8                	mov    %ebx,%eax
  801a57:	83 c4 14             	add    $0x14,%esp
  801a5a:	5b                   	pop    %ebx
  801a5b:	5d                   	pop    %ebp
  801a5c:	c3                   	ret    

00801a5d <remove>:
}

// Delete a file
int
remove(const char *path)
{
  801a5d:	55                   	push   %ebp
  801a5e:	89 e5                	mov    %esp,%ebp
  801a60:	53                   	push   %ebx
  801a61:	83 ec 14             	sub    $0x14,%esp
  801a64:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (strlen(path) >= MAXPATHLEN)
  801a67:	89 1c 24             	mov    %ebx,(%esp)
  801a6a:	e8 d1 ee ff ff       	call   800940 <strlen>
  801a6f:	89 c2                	mov    %eax,%edx
  801a71:	b8 f4 ff ff ff       	mov    $0xfffffff4,%eax
  801a76:	81 fa ff 03 00 00    	cmp    $0x3ff,%edx
  801a7c:	7f 1f                	jg     801a9d <remove+0x40>
		return -E_BAD_PATH;
	strcpy(fsipcbuf.remove.req_path, path);
  801a7e:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801a82:	c7 04 24 00 30 80 00 	movl   $0x803000,(%esp)
  801a89:	e8 fc ee ff ff       	call   80098a <strcpy>
	return fsipc(FSREQ_REMOVE, NULL);
  801a8e:	ba 00 00 00 00       	mov    $0x0,%edx
  801a93:	b8 07 00 00 00       	mov    $0x7,%eax
  801a98:	e8 1f fe ff ff       	call   8018bc <fsipc>
}
  801a9d:	83 c4 14             	add    $0x14,%esp
  801aa0:	5b                   	pop    %ebx
  801aa1:	5d                   	pop    %ebp
  801aa2:	c3                   	ret    

00801aa3 <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  801aa3:	55                   	push   %ebp
  801aa4:	89 e5                	mov    %esp,%ebp
  801aa6:	83 ec 28             	sub    $0x28,%esp
  801aa9:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  801aac:	89 75 fc             	mov    %esi,-0x4(%ebp)
  801aaf:	8b 75 08             	mov    0x8(%ebp),%esi
	// file descriptor.

	// LAB 5: Your code here.
	// Code added by Swastika / Sandeep
	
	if (strlen(path) >= MAXPATHLEN)
  801ab2:	89 34 24             	mov    %esi,(%esp)
  801ab5:	e8 86 ee ff ff       	call   800940 <strlen>
  801aba:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  801abf:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  801ac4:	7f 5e                	jg     801b24 <open+0x81>
		return -E_BAD_PATH;
	struct Fd * fd;
	int  r;
	if ((r = fd_alloc(&fd)) < 0)
  801ac6:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801ac9:	89 04 24             	mov    %eax,(%esp)
  801acc:	e8 fa f7 ff ff       	call   8012cb <fd_alloc>
  801ad1:	89 c3                	mov    %eax,%ebx
  801ad3:	85 c0                	test   %eax,%eax
  801ad5:	78 4d                	js     801b24 <open+0x81>
		return r;
	strcpy (fsipcbuf.open.req_path, path);
  801ad7:	89 74 24 04          	mov    %esi,0x4(%esp)
  801adb:	c7 04 24 00 30 80 00 	movl   $0x803000,(%esp)
  801ae2:	e8 a3 ee ff ff       	call   80098a <strcpy>
	fsipcbuf.open.req_omode = mode;	
  801ae7:	8b 45 0c             	mov    0xc(%ebp),%eax
  801aea:	a3 00 34 80 00       	mov    %eax,0x803400
	if ((r = fsipc(FSREQ_OPEN,(void*)fd)) < 0)
  801aef:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801af2:	b8 01 00 00 00       	mov    $0x1,%eax
  801af7:	e8 c0 fd ff ff       	call   8018bc <fsipc>
  801afc:	89 c3                	mov    %eax,%ebx
  801afe:	85 c0                	test   %eax,%eax
  801b00:	79 15                	jns    801b17 <open+0x74>
	{
		fd_close(fd,0);
  801b02:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  801b09:	00 
  801b0a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801b0d:	89 04 24             	mov    %eax,(%esp)
  801b10:	e8 6a fb ff ff       	call   80167f <fd_close>
		return r; 
  801b15:	eb 0d                	jmp    801b24 <open+0x81>
	}
	return fd2num(fd);
  801b17:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801b1a:	89 04 24             	mov    %eax,(%esp)
  801b1d:	e8 7e f7 ff ff       	call   8012a0 <fd2num>
  801b22:	89 c3                	mov    %eax,%ebx
	//panic("open not implemented");
}
  801b24:	89 d8                	mov    %ebx,%eax
  801b26:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  801b29:	8b 75 fc             	mov    -0x4(%ebp),%esi
  801b2c:	89 ec                	mov    %ebp,%esp
  801b2e:	5d                   	pop    %ebp
  801b2f:	c3                   	ret    

00801b30 <writebuf>:
};


static void
writebuf(struct printbuf *b)
{
  801b30:	55                   	push   %ebp
  801b31:	89 e5                	mov    %esp,%ebp
  801b33:	53                   	push   %ebx
  801b34:	83 ec 14             	sub    $0x14,%esp
  801b37:	89 c3                	mov    %eax,%ebx
	if (b->error > 0) {
  801b39:	83 78 0c 00          	cmpl   $0x0,0xc(%eax)
  801b3d:	7e 34                	jle    801b73 <writebuf+0x43>
		ssize_t result = write(b->fd, b->buf, b->idx);
  801b3f:	8b 40 04             	mov    0x4(%eax),%eax
  801b42:	89 44 24 08          	mov    %eax,0x8(%esp)
  801b46:	8d 43 10             	lea    0x10(%ebx),%eax
  801b49:	89 44 24 04          	mov    %eax,0x4(%esp)
  801b4d:	8b 03                	mov    (%ebx),%eax
  801b4f:	89 04 24             	mov    %eax,(%esp)
  801b52:	e8 be f9 ff ff       	call   801515 <write>
		if (result > 0)
  801b57:	85 c0                	test   %eax,%eax
  801b59:	7e 03                	jle    801b5e <writebuf+0x2e>
			b->result += result;
  801b5b:	01 43 08             	add    %eax,0x8(%ebx)
		if (result != b->idx) // error, or wrote less than supplied
  801b5e:	3b 43 04             	cmp    0x4(%ebx),%eax
  801b61:	74 10                	je     801b73 <writebuf+0x43>
			b->error = (result < 0 ? result : 0);
  801b63:	85 c0                	test   %eax,%eax
  801b65:	0f 9f c2             	setg   %dl
  801b68:	0f b6 d2             	movzbl %dl,%edx
  801b6b:	83 ea 01             	sub    $0x1,%edx
  801b6e:	21 d0                	and    %edx,%eax
  801b70:	89 43 0c             	mov    %eax,0xc(%ebx)
	}
}
  801b73:	83 c4 14             	add    $0x14,%esp
  801b76:	5b                   	pop    %ebx
  801b77:	5d                   	pop    %ebp
  801b78:	c3                   	ret    

00801b79 <vfprintf>:
	}
}

int
vfprintf(int fd, const char *fmt, va_list ap)
{
  801b79:	55                   	push   %ebp
  801b7a:	89 e5                	mov    %esp,%ebp
  801b7c:	81 ec 28 01 00 00    	sub    $0x128,%esp
	struct printbuf b;

	b.fd = fd;
  801b82:	8b 45 08             	mov    0x8(%ebp),%eax
  801b85:	89 85 e8 fe ff ff    	mov    %eax,-0x118(%ebp)
	b.idx = 0;
  801b8b:	c7 85 ec fe ff ff 00 	movl   $0x0,-0x114(%ebp)
  801b92:	00 00 00 
	b.result = 0;
  801b95:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  801b9c:	00 00 00 
	b.error = 1;
  801b9f:	c7 85 f4 fe ff ff 01 	movl   $0x1,-0x10c(%ebp)
  801ba6:	00 00 00 
	vprintfmt(putch, &b, fmt, ap);
  801ba9:	8b 45 10             	mov    0x10(%ebp),%eax
  801bac:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801bb0:	8b 45 0c             	mov    0xc(%ebp),%eax
  801bb3:	89 44 24 08          	mov    %eax,0x8(%esp)
  801bb7:	8d 85 e8 fe ff ff    	lea    -0x118(%ebp),%eax
  801bbd:	89 44 24 04          	mov    %eax,0x4(%esp)
  801bc1:	c7 04 24 36 1c 80 00 	movl   $0x801c36,(%esp)
  801bc8:	e8 b0 e8 ff ff       	call   80047d <vprintfmt>
	if (b.idx > 0)
  801bcd:	83 bd ec fe ff ff 00 	cmpl   $0x0,-0x114(%ebp)
  801bd4:	7e 0b                	jle    801be1 <vfprintf+0x68>
		writebuf(&b);
  801bd6:	8d 85 e8 fe ff ff    	lea    -0x118(%ebp),%eax
  801bdc:	e8 4f ff ff ff       	call   801b30 <writebuf>

	return (b.result ? b.result : b.error);
  801be1:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
  801be7:	85 c0                	test   %eax,%eax
  801be9:	75 06                	jne    801bf1 <vfprintf+0x78>
  801beb:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  801bf1:	c9                   	leave  
  801bf2:	c3                   	ret    

00801bf3 <printf>:
	return cnt;
}

int
printf(const char *fmt, ...)
{
  801bf3:	55                   	push   %ebp
  801bf4:	89 e5                	mov    %esp,%ebp
  801bf6:	83 ec 18             	sub    $0x18,%esp

	return cnt;
}

int
printf(const char *fmt, ...)
  801bf9:	8d 45 0c             	lea    0xc(%ebp),%eax
{
	va_list ap;
	int cnt;

	va_start(ap, fmt);
	cnt = vfprintf(1, fmt, ap);
  801bfc:	89 44 24 08          	mov    %eax,0x8(%esp)
  801c00:	8b 45 08             	mov    0x8(%ebp),%eax
  801c03:	89 44 24 04          	mov    %eax,0x4(%esp)
  801c07:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  801c0e:	e8 66 ff ff ff       	call   801b79 <vfprintf>
	va_end(ap);

	return cnt;
}
  801c13:	c9                   	leave  
  801c14:	c3                   	ret    

00801c15 <fprintf>:
	return (b.result ? b.result : b.error);
}

int
fprintf(int fd, const char *fmt, ...)
{
  801c15:	55                   	push   %ebp
  801c16:	89 e5                	mov    %esp,%ebp
  801c18:	83 ec 18             	sub    $0x18,%esp

	return (b.result ? b.result : b.error);
}

int
fprintf(int fd, const char *fmt, ...)
  801c1b:	8d 45 10             	lea    0x10(%ebp),%eax
{
	va_list ap;
	int cnt;

	va_start(ap, fmt);
	cnt = vfprintf(fd, fmt, ap);
  801c1e:	89 44 24 08          	mov    %eax,0x8(%esp)
  801c22:	8b 45 0c             	mov    0xc(%ebp),%eax
  801c25:	89 44 24 04          	mov    %eax,0x4(%esp)
  801c29:	8b 45 08             	mov    0x8(%ebp),%eax
  801c2c:	89 04 24             	mov    %eax,(%esp)
  801c2f:	e8 45 ff ff ff       	call   801b79 <vfprintf>
	va_end(ap);

	return cnt;
}
  801c34:	c9                   	leave  
  801c35:	c3                   	ret    

00801c36 <putch>:
	}
}

static void
putch(int ch, void *thunk)
{
  801c36:	55                   	push   %ebp
  801c37:	89 e5                	mov    %esp,%ebp
  801c39:	53                   	push   %ebx
  801c3a:	83 ec 04             	sub    $0x4,%esp
	struct printbuf *b = (struct printbuf *) thunk;
  801c3d:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  801c40:	8b 43 04             	mov    0x4(%ebx),%eax
  801c43:	8b 55 08             	mov    0x8(%ebp),%edx
  801c46:	88 54 03 10          	mov    %dl,0x10(%ebx,%eax,1)
  801c4a:	83 c0 01             	add    $0x1,%eax
  801c4d:	89 43 04             	mov    %eax,0x4(%ebx)
	if (b->idx == 256) {
  801c50:	3d 00 01 00 00       	cmp    $0x100,%eax
  801c55:	75 0e                	jne    801c65 <putch+0x2f>
		writebuf(b);
  801c57:	89 d8                	mov    %ebx,%eax
  801c59:	e8 d2 fe ff ff       	call   801b30 <writebuf>
		b->idx = 0;
  801c5e:	c7 43 04 00 00 00 00 	movl   $0x0,0x4(%ebx)
	}
}
  801c65:	83 c4 04             	add    $0x4,%esp
  801c68:	5b                   	pop    %ebx
  801c69:	5d                   	pop    %ebp
  801c6a:	c3                   	ret    
  801c6b:	00 00                	add    %al,(%eax)
  801c6d:	00 00                	add    %al,(%eax)
	...

00801c70 <devsock_stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  801c70:	55                   	push   %ebp
  801c71:	89 e5                	mov    %esp,%ebp
  801c73:	83 ec 18             	sub    $0x18,%esp
	strcpy(stat->st_name, "<sock>");
  801c76:	c7 44 24 04 bc 2e 80 	movl   $0x802ebc,0x4(%esp)
  801c7d:	00 
  801c7e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801c81:	89 04 24             	mov    %eax,(%esp)
  801c84:	e8 01 ed ff ff       	call   80098a <strcpy>
	return 0;
}
  801c89:	b8 00 00 00 00       	mov    $0x0,%eax
  801c8e:	c9                   	leave  
  801c8f:	c3                   	ret    

00801c90 <devsock_close>:
	return nsipc_shutdown(r, how);
}

static int
devsock_close(struct Fd *fd)
{
  801c90:	55                   	push   %ebp
  801c91:	89 e5                	mov    %esp,%ebp
  801c93:	83 ec 18             	sub    $0x18,%esp
	return nsipc_close(fd->fd_sock.sockid);
  801c96:	8b 45 08             	mov    0x8(%ebp),%eax
  801c99:	8b 40 0c             	mov    0xc(%eax),%eax
  801c9c:	89 04 24             	mov    %eax,(%esp)
  801c9f:	e8 9e 02 00 00       	call   801f42 <nsipc_close>
}
  801ca4:	c9                   	leave  
  801ca5:	c3                   	ret    

00801ca6 <devsock_write>:
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
}

static ssize_t
devsock_write(struct Fd *fd, const void *buf, size_t n)
{
  801ca6:	55                   	push   %ebp
  801ca7:	89 e5                	mov    %esp,%ebp
  801ca9:	83 ec 18             	sub    $0x18,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  801cac:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  801cb3:	00 
  801cb4:	8b 45 10             	mov    0x10(%ebp),%eax
  801cb7:	89 44 24 08          	mov    %eax,0x8(%esp)
  801cbb:	8b 45 0c             	mov    0xc(%ebp),%eax
  801cbe:	89 44 24 04          	mov    %eax,0x4(%esp)
  801cc2:	8b 45 08             	mov    0x8(%ebp),%eax
  801cc5:	8b 40 0c             	mov    0xc(%eax),%eax
  801cc8:	89 04 24             	mov    %eax,(%esp)
  801ccb:	e8 ae 02 00 00       	call   801f7e <nsipc_send>
}
  801cd0:	c9                   	leave  
  801cd1:	c3                   	ret    

00801cd2 <devsock_read>:
	return nsipc_listen(r, backlog);
}

static ssize_t
devsock_read(struct Fd *fd, void *buf, size_t n)
{
  801cd2:	55                   	push   %ebp
  801cd3:	89 e5                	mov    %esp,%ebp
  801cd5:	83 ec 18             	sub    $0x18,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  801cd8:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  801cdf:	00 
  801ce0:	8b 45 10             	mov    0x10(%ebp),%eax
  801ce3:	89 44 24 08          	mov    %eax,0x8(%esp)
  801ce7:	8b 45 0c             	mov    0xc(%ebp),%eax
  801cea:	89 44 24 04          	mov    %eax,0x4(%esp)
  801cee:	8b 45 08             	mov    0x8(%ebp),%eax
  801cf1:	8b 40 0c             	mov    0xc(%eax),%eax
  801cf4:	89 04 24             	mov    %eax,(%esp)
  801cf7:	e8 f5 02 00 00       	call   801ff1 <nsipc_recv>
}
  801cfc:	c9                   	leave  
  801cfd:	c3                   	ret    

00801cfe <alloc_sockfd>:
	return sfd->fd_sock.sockid;
}

static int
alloc_sockfd(int sockid)
{
  801cfe:	55                   	push   %ebp
  801cff:	89 e5                	mov    %esp,%ebp
  801d01:	56                   	push   %esi
  801d02:	53                   	push   %ebx
  801d03:	83 ec 20             	sub    $0x20,%esp
  801d06:	89 c6                	mov    %eax,%esi
	struct Fd *sfd;
	int r;

	if ((r = fd_alloc(&sfd)) < 0
  801d08:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801d0b:	89 04 24             	mov    %eax,(%esp)
  801d0e:	e8 b8 f5 ff ff       	call   8012cb <fd_alloc>
  801d13:	89 c3                	mov    %eax,%ebx
  801d15:	85 c0                	test   %eax,%eax
  801d17:	78 21                	js     801d3a <alloc_sockfd+0x3c>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U)) < 0) {
  801d19:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  801d20:	00 
  801d21:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d24:	89 44 24 04          	mov    %eax,0x4(%esp)
  801d28:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801d2f:	e8 47 f4 ff ff       	call   80117b <sys_page_alloc>
  801d34:	89 c3                	mov    %eax,%ebx
alloc_sockfd(int sockid)
{
	struct Fd *sfd;
	int r;

	if ((r = fd_alloc(&sfd)) < 0
  801d36:	85 c0                	test   %eax,%eax
  801d38:	79 0a                	jns    801d44 <alloc_sockfd+0x46>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U)) < 0) {
		nsipc_close(sockid);
  801d3a:	89 34 24             	mov    %esi,(%esp)
  801d3d:	e8 00 02 00 00       	call   801f42 <nsipc_close>
		return r;
  801d42:	eb 28                	jmp    801d6c <alloc_sockfd+0x6e>
	}

	sfd->fd_dev_id = devsock.dev_id;
  801d44:	8b 15 20 60 80 00    	mov    0x806020,%edx
  801d4a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d4d:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  801d4f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d52:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	sfd->fd_sock.sockid = sockid;
  801d59:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d5c:	89 70 0c             	mov    %esi,0xc(%eax)
	return fd2num(sfd);
  801d5f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d62:	89 04 24             	mov    %eax,(%esp)
  801d65:	e8 36 f5 ff ff       	call   8012a0 <fd2num>
  801d6a:	89 c3                	mov    %eax,%ebx
}
  801d6c:	89 d8                	mov    %ebx,%eax
  801d6e:	83 c4 20             	add    $0x20,%esp
  801d71:	5b                   	pop    %ebx
  801d72:	5e                   	pop    %esi
  801d73:	5d                   	pop    %ebp
  801d74:	c3                   	ret    

00801d75 <socket>:
	return 0;
}

int
socket(int domain, int type, int protocol)
{
  801d75:	55                   	push   %ebp
  801d76:	89 e5                	mov    %esp,%ebp
  801d78:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  801d7b:	8b 45 10             	mov    0x10(%ebp),%eax
  801d7e:	89 44 24 08          	mov    %eax,0x8(%esp)
  801d82:	8b 45 0c             	mov    0xc(%ebp),%eax
  801d85:	89 44 24 04          	mov    %eax,0x4(%esp)
  801d89:	8b 45 08             	mov    0x8(%ebp),%eax
  801d8c:	89 04 24             	mov    %eax,(%esp)
  801d8f:	e8 62 01 00 00       	call   801ef6 <nsipc_socket>
  801d94:	85 c0                	test   %eax,%eax
  801d96:	78 05                	js     801d9d <socket+0x28>
		return r;
	return alloc_sockfd(r);
  801d98:	e8 61 ff ff ff       	call   801cfe <alloc_sockfd>
}
  801d9d:	c9                   	leave  
  801d9e:	66 90                	xchg   %ax,%ax
  801da0:	c3                   	ret    

00801da1 <fd2sockid>:
	.dev_stat =	devsock_stat,
};

static int
fd2sockid(int fd)
{
  801da1:	55                   	push   %ebp
  801da2:	89 e5                	mov    %esp,%ebp
  801da4:	83 ec 28             	sub    $0x28,%esp
	struct Fd *sfd;
	int r;

	if ((r = fd_lookup(fd, &sfd)) < 0)
  801da7:	8d 55 f4             	lea    -0xc(%ebp),%edx
  801daa:	89 54 24 04          	mov    %edx,0x4(%esp)
  801dae:	89 04 24             	mov    %eax,(%esp)
  801db1:	e8 87 f5 ff ff       	call   80133d <fd_lookup>
  801db6:	85 c0                	test   %eax,%eax
  801db8:	78 15                	js     801dcf <fd2sockid+0x2e>
		return r;
	if (sfd->fd_dev_id != devsock.dev_id)
  801dba:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801dbd:	8b 0a                	mov    (%edx),%ecx
  801dbf:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801dc4:	3b 0d 20 60 80 00    	cmp    0x806020,%ecx
  801dca:	75 03                	jne    801dcf <fd2sockid+0x2e>
		return -E_NOT_SUPP;
	return sfd->fd_sock.sockid;
  801dcc:	8b 42 0c             	mov    0xc(%edx),%eax
}
  801dcf:	c9                   	leave  
  801dd0:	c3                   	ret    

00801dd1 <listen>:
	return nsipc_connect(r, name, namelen);
}

int
listen(int s, int backlog)
{
  801dd1:	55                   	push   %ebp
  801dd2:	89 e5                	mov    %esp,%ebp
  801dd4:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  801dd7:	8b 45 08             	mov    0x8(%ebp),%eax
  801dda:	e8 c2 ff ff ff       	call   801da1 <fd2sockid>
  801ddf:	85 c0                	test   %eax,%eax
  801de1:	78 0f                	js     801df2 <listen+0x21>
		return r;
	return nsipc_listen(r, backlog);
  801de3:	8b 55 0c             	mov    0xc(%ebp),%edx
  801de6:	89 54 24 04          	mov    %edx,0x4(%esp)
  801dea:	89 04 24             	mov    %eax,(%esp)
  801ded:	e8 2e 01 00 00       	call   801f20 <nsipc_listen>
}
  801df2:	c9                   	leave  
  801df3:	c3                   	ret    

00801df4 <connect>:
	return nsipc_close(fd->fd_sock.sockid);
}

int
connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  801df4:	55                   	push   %ebp
  801df5:	89 e5                	mov    %esp,%ebp
  801df7:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  801dfa:	8b 45 08             	mov    0x8(%ebp),%eax
  801dfd:	e8 9f ff ff ff       	call   801da1 <fd2sockid>
  801e02:	85 c0                	test   %eax,%eax
  801e04:	78 16                	js     801e1c <connect+0x28>
		return r;
	return nsipc_connect(r, name, namelen);
  801e06:	8b 55 10             	mov    0x10(%ebp),%edx
  801e09:	89 54 24 08          	mov    %edx,0x8(%esp)
  801e0d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e10:	89 54 24 04          	mov    %edx,0x4(%esp)
  801e14:	89 04 24             	mov    %eax,(%esp)
  801e17:	e8 55 02 00 00       	call   802071 <nsipc_connect>
}
  801e1c:	c9                   	leave  
  801e1d:	c3                   	ret    

00801e1e <shutdown>:
	return nsipc_bind(r, name, namelen);
}

int
shutdown(int s, int how)
{
  801e1e:	55                   	push   %ebp
  801e1f:	89 e5                	mov    %esp,%ebp
  801e21:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  801e24:	8b 45 08             	mov    0x8(%ebp),%eax
  801e27:	e8 75 ff ff ff       	call   801da1 <fd2sockid>
  801e2c:	85 c0                	test   %eax,%eax
  801e2e:	78 0f                	js     801e3f <shutdown+0x21>
		return r;
	return nsipc_shutdown(r, how);
  801e30:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e33:	89 54 24 04          	mov    %edx,0x4(%esp)
  801e37:	89 04 24             	mov    %eax,(%esp)
  801e3a:	e8 1d 01 00 00       	call   801f5c <nsipc_shutdown>
}
  801e3f:	c9                   	leave  
  801e40:	c3                   	ret    

00801e41 <bind>:
	return alloc_sockfd(r);
}

int
bind(int s, struct sockaddr *name, socklen_t namelen)
{
  801e41:	55                   	push   %ebp
  801e42:	89 e5                	mov    %esp,%ebp
  801e44:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  801e47:	8b 45 08             	mov    0x8(%ebp),%eax
  801e4a:	e8 52 ff ff ff       	call   801da1 <fd2sockid>
  801e4f:	85 c0                	test   %eax,%eax
  801e51:	78 16                	js     801e69 <bind+0x28>
		return r;
	return nsipc_bind(r, name, namelen);
  801e53:	8b 55 10             	mov    0x10(%ebp),%edx
  801e56:	89 54 24 08          	mov    %edx,0x8(%esp)
  801e5a:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e5d:	89 54 24 04          	mov    %edx,0x4(%esp)
  801e61:	89 04 24             	mov    %eax,(%esp)
  801e64:	e8 47 02 00 00       	call   8020b0 <nsipc_bind>
}
  801e69:	c9                   	leave  
  801e6a:	c3                   	ret    

00801e6b <accept>:
	return fd2num(sfd);
}

int
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  801e6b:	55                   	push   %ebp
  801e6c:	89 e5                	mov    %esp,%ebp
  801e6e:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  801e71:	8b 45 08             	mov    0x8(%ebp),%eax
  801e74:	e8 28 ff ff ff       	call   801da1 <fd2sockid>
  801e79:	85 c0                	test   %eax,%eax
  801e7b:	78 1f                	js     801e9c <accept+0x31>
		return r;
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  801e7d:	8b 55 10             	mov    0x10(%ebp),%edx
  801e80:	89 54 24 08          	mov    %edx,0x8(%esp)
  801e84:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e87:	89 54 24 04          	mov    %edx,0x4(%esp)
  801e8b:	89 04 24             	mov    %eax,(%esp)
  801e8e:	e8 5c 02 00 00       	call   8020ef <nsipc_accept>
  801e93:	85 c0                	test   %eax,%eax
  801e95:	78 05                	js     801e9c <accept+0x31>
		return r;
	return alloc_sockfd(r);
  801e97:	e8 62 fe ff ff       	call   801cfe <alloc_sockfd>
}
  801e9c:	c9                   	leave  
  801e9d:	8d 76 00             	lea    0x0(%esi),%esi
  801ea0:	c3                   	ret    
	...

00801eb0 <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  801eb0:	55                   	push   %ebp
  801eb1:	89 e5                	mov    %esp,%ebp
  801eb3:	83 ec 18             	sub    $0x18,%esp
	if (debug)
		cprintf("[%08x] nsipc %d\n", env->env_id, type);

	ipc_send(envs[2].env_id, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  801eb6:	8b 15 44 01 c0 ee    	mov    0xeec00144,%edx
  801ebc:	c7 44 24 0c 07 00 00 	movl   $0x7,0xc(%esp)
  801ec3:	00 
  801ec4:	c7 44 24 08 00 50 80 	movl   $0x805000,0x8(%esp)
  801ecb:	00 
  801ecc:	89 44 24 04          	mov    %eax,0x4(%esp)
  801ed0:	89 14 24             	mov    %edx,(%esp)
  801ed3:	e8 08 08 00 00       	call   8026e0 <ipc_send>
	return ipc_recv(NULL, NULL, NULL);
  801ed8:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801edf:	00 
  801ee0:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  801ee7:	00 
  801ee8:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801eef:	e8 52 08 00 00       	call   802746 <ipc_recv>
}
  801ef4:	c9                   	leave  
  801ef5:	c3                   	ret    

00801ef6 <nsipc_socket>:
	return nsipc(NSREQ_SEND);
}

int
nsipc_socket(int domain, int type, int protocol)
{
  801ef6:	55                   	push   %ebp
  801ef7:	89 e5                	mov    %esp,%ebp
  801ef9:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  801efc:	8b 45 08             	mov    0x8(%ebp),%eax
  801eff:	a3 00 50 80 00       	mov    %eax,0x805000
	nsipcbuf.socket.req_type = type;
  801f04:	8b 45 0c             	mov    0xc(%ebp),%eax
  801f07:	a3 04 50 80 00       	mov    %eax,0x805004
	nsipcbuf.socket.req_protocol = protocol;
  801f0c:	8b 45 10             	mov    0x10(%ebp),%eax
  801f0f:	a3 08 50 80 00       	mov    %eax,0x805008
	return nsipc(NSREQ_SOCKET);
  801f14:	b8 09 00 00 00       	mov    $0x9,%eax
  801f19:	e8 92 ff ff ff       	call   801eb0 <nsipc>
}
  801f1e:	c9                   	leave  
  801f1f:	c3                   	ret    

00801f20 <nsipc_listen>:
	return nsipc(NSREQ_CONNECT);
}

int
nsipc_listen(int s, int backlog)
{
  801f20:	55                   	push   %ebp
  801f21:	89 e5                	mov    %esp,%ebp
  801f23:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  801f26:	8b 45 08             	mov    0x8(%ebp),%eax
  801f29:	a3 00 50 80 00       	mov    %eax,0x805000
	nsipcbuf.listen.req_backlog = backlog;
  801f2e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801f31:	a3 04 50 80 00       	mov    %eax,0x805004
	return nsipc(NSREQ_LISTEN);
  801f36:	b8 06 00 00 00       	mov    $0x6,%eax
  801f3b:	e8 70 ff ff ff       	call   801eb0 <nsipc>
}
  801f40:	c9                   	leave  
  801f41:	c3                   	ret    

00801f42 <nsipc_close>:
	return nsipc(NSREQ_SHUTDOWN);
}

int
nsipc_close(int s)
{
  801f42:	55                   	push   %ebp
  801f43:	89 e5                	mov    %esp,%ebp
  801f45:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  801f48:	8b 45 08             	mov    0x8(%ebp),%eax
  801f4b:	a3 00 50 80 00       	mov    %eax,0x805000
	return nsipc(NSREQ_CLOSE);
  801f50:	b8 04 00 00 00       	mov    $0x4,%eax
  801f55:	e8 56 ff ff ff       	call   801eb0 <nsipc>
}
  801f5a:	c9                   	leave  
  801f5b:	c3                   	ret    

00801f5c <nsipc_shutdown>:
	return nsipc(NSREQ_BIND);
}

int
nsipc_shutdown(int s, int how)
{
  801f5c:	55                   	push   %ebp
  801f5d:	89 e5                	mov    %esp,%ebp
  801f5f:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  801f62:	8b 45 08             	mov    0x8(%ebp),%eax
  801f65:	a3 00 50 80 00       	mov    %eax,0x805000
	nsipcbuf.shutdown.req_how = how;
  801f6a:	8b 45 0c             	mov    0xc(%ebp),%eax
  801f6d:	a3 04 50 80 00       	mov    %eax,0x805004
	return nsipc(NSREQ_SHUTDOWN);
  801f72:	b8 03 00 00 00       	mov    $0x3,%eax
  801f77:	e8 34 ff ff ff       	call   801eb0 <nsipc>
}
  801f7c:	c9                   	leave  
  801f7d:	c3                   	ret    

00801f7e <nsipc_send>:
	return r;
}

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  801f7e:	55                   	push   %ebp
  801f7f:	89 e5                	mov    %esp,%ebp
  801f81:	53                   	push   %ebx
  801f82:	83 ec 14             	sub    $0x14,%esp
  801f85:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  801f88:	8b 45 08             	mov    0x8(%ebp),%eax
  801f8b:	a3 00 50 80 00       	mov    %eax,0x805000
	assert(size < 1600);
  801f90:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  801f96:	7e 24                	jle    801fbc <nsipc_send+0x3e>
  801f98:	c7 44 24 0c c8 2e 80 	movl   $0x802ec8,0xc(%esp)
  801f9f:	00 
  801fa0:	c7 44 24 08 d4 2e 80 	movl   $0x802ed4,0x8(%esp)
  801fa7:	00 
  801fa8:	c7 44 24 04 66 00 00 	movl   $0x66,0x4(%esp)
  801faf:	00 
  801fb0:	c7 04 24 e9 2e 80 00 	movl   $0x802ee9,(%esp)
  801fb7:	e8 48 e2 ff ff       	call   800204 <_panic>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  801fbc:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801fc0:	8b 45 0c             	mov    0xc(%ebp),%eax
  801fc3:	89 44 24 04          	mov    %eax,0x4(%esp)
  801fc7:	c7 04 24 0c 50 80 00 	movl   $0x80500c,(%esp)
  801fce:	e8 72 eb ff ff       	call   800b45 <memmove>
	nsipcbuf.send.req_size = size;
  801fd3:	89 1d 04 50 80 00    	mov    %ebx,0x805004
	nsipcbuf.send.req_flags = flags;
  801fd9:	8b 45 14             	mov    0x14(%ebp),%eax
  801fdc:	a3 08 50 80 00       	mov    %eax,0x805008
	return nsipc(NSREQ_SEND);
  801fe1:	b8 08 00 00 00       	mov    $0x8,%eax
  801fe6:	e8 c5 fe ff ff       	call   801eb0 <nsipc>
}
  801feb:	83 c4 14             	add    $0x14,%esp
  801fee:	5b                   	pop    %ebx
  801fef:	5d                   	pop    %ebp
  801ff0:	c3                   	ret    

00801ff1 <nsipc_recv>:
	return nsipc(NSREQ_LISTEN);
}

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  801ff1:	55                   	push   %ebp
  801ff2:	89 e5                	mov    %esp,%ebp
  801ff4:	56                   	push   %esi
  801ff5:	53                   	push   %ebx
  801ff6:	83 ec 10             	sub    $0x10,%esp
  801ff9:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  801ffc:	8b 45 08             	mov    0x8(%ebp),%eax
  801fff:	a3 00 50 80 00       	mov    %eax,0x805000
	nsipcbuf.recv.req_len = len;
  802004:	89 35 04 50 80 00    	mov    %esi,0x805004
	nsipcbuf.recv.req_flags = flags;
  80200a:	8b 45 14             	mov    0x14(%ebp),%eax
  80200d:	a3 08 50 80 00       	mov    %eax,0x805008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  802012:	b8 07 00 00 00       	mov    $0x7,%eax
  802017:	e8 94 fe ff ff       	call   801eb0 <nsipc>
  80201c:	89 c3                	mov    %eax,%ebx
  80201e:	85 c0                	test   %eax,%eax
  802020:	78 46                	js     802068 <nsipc_recv+0x77>
		assert(r < 1600 && r <= len);
  802022:	3d 3f 06 00 00       	cmp    $0x63f,%eax
  802027:	7f 04                	jg     80202d <nsipc_recv+0x3c>
  802029:	39 c6                	cmp    %eax,%esi
  80202b:	7d 24                	jge    802051 <nsipc_recv+0x60>
  80202d:	c7 44 24 0c f5 2e 80 	movl   $0x802ef5,0xc(%esp)
  802034:	00 
  802035:	c7 44 24 08 d4 2e 80 	movl   $0x802ed4,0x8(%esp)
  80203c:	00 
  80203d:	c7 44 24 04 5b 00 00 	movl   $0x5b,0x4(%esp)
  802044:	00 
  802045:	c7 04 24 e9 2e 80 00 	movl   $0x802ee9,(%esp)
  80204c:	e8 b3 e1 ff ff       	call   800204 <_panic>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  802051:	89 44 24 08          	mov    %eax,0x8(%esp)
  802055:	c7 44 24 04 00 50 80 	movl   $0x805000,0x4(%esp)
  80205c:	00 
  80205d:	8b 45 0c             	mov    0xc(%ebp),%eax
  802060:	89 04 24             	mov    %eax,(%esp)
  802063:	e8 dd ea ff ff       	call   800b45 <memmove>
	}

	return r;
}
  802068:	89 d8                	mov    %ebx,%eax
  80206a:	83 c4 10             	add    $0x10,%esp
  80206d:	5b                   	pop    %ebx
  80206e:	5e                   	pop    %esi
  80206f:	5d                   	pop    %ebp
  802070:	c3                   	ret    

00802071 <nsipc_connect>:
	return nsipc(NSREQ_CLOSE);
}

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  802071:	55                   	push   %ebp
  802072:	89 e5                	mov    %esp,%ebp
  802074:	53                   	push   %ebx
  802075:	83 ec 14             	sub    $0x14,%esp
  802078:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  80207b:	8b 45 08             	mov    0x8(%ebp),%eax
  80207e:	a3 00 50 80 00       	mov    %eax,0x805000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  802083:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  802087:	8b 45 0c             	mov    0xc(%ebp),%eax
  80208a:	89 44 24 04          	mov    %eax,0x4(%esp)
  80208e:	c7 04 24 04 50 80 00 	movl   $0x805004,(%esp)
  802095:	e8 ab ea ff ff       	call   800b45 <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  80209a:	89 1d 14 50 80 00    	mov    %ebx,0x805014
	return nsipc(NSREQ_CONNECT);
  8020a0:	b8 05 00 00 00       	mov    $0x5,%eax
  8020a5:	e8 06 fe ff ff       	call   801eb0 <nsipc>
}
  8020aa:	83 c4 14             	add    $0x14,%esp
  8020ad:	5b                   	pop    %ebx
  8020ae:	5d                   	pop    %ebp
  8020af:	c3                   	ret    

008020b0 <nsipc_bind>:
	return r;
}

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  8020b0:	55                   	push   %ebp
  8020b1:	89 e5                	mov    %esp,%ebp
  8020b3:	53                   	push   %ebx
  8020b4:	83 ec 14             	sub    $0x14,%esp
  8020b7:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  8020ba:	8b 45 08             	mov    0x8(%ebp),%eax
  8020bd:	a3 00 50 80 00       	mov    %eax,0x805000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  8020c2:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8020c6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8020c9:	89 44 24 04          	mov    %eax,0x4(%esp)
  8020cd:	c7 04 24 04 50 80 00 	movl   $0x805004,(%esp)
  8020d4:	e8 6c ea ff ff       	call   800b45 <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  8020d9:	89 1d 14 50 80 00    	mov    %ebx,0x805014
	return nsipc(NSREQ_BIND);
  8020df:	b8 02 00 00 00       	mov    $0x2,%eax
  8020e4:	e8 c7 fd ff ff       	call   801eb0 <nsipc>
}
  8020e9:	83 c4 14             	add    $0x14,%esp
  8020ec:	5b                   	pop    %ebx
  8020ed:	5d                   	pop    %ebp
  8020ee:	c3                   	ret    

008020ef <nsipc_accept>:
	return ipc_recv(NULL, NULL, NULL);
}

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  8020ef:	55                   	push   %ebp
  8020f0:	89 e5                	mov    %esp,%ebp
  8020f2:	83 ec 18             	sub    $0x18,%esp
  8020f5:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  8020f8:	89 75 fc             	mov    %esi,-0x4(%ebp)
	int r;
	
	nsipcbuf.accept.req_s = s;
  8020fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8020fe:	a3 00 50 80 00       	mov    %eax,0x805000
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  802103:	b8 01 00 00 00       	mov    $0x1,%eax
  802108:	e8 a3 fd ff ff       	call   801eb0 <nsipc>
  80210d:	89 c3                	mov    %eax,%ebx
  80210f:	85 c0                	test   %eax,%eax
  802111:	78 25                	js     802138 <nsipc_accept+0x49>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  802113:	be 10 50 80 00       	mov    $0x805010,%esi
  802118:	8b 06                	mov    (%esi),%eax
  80211a:	89 44 24 08          	mov    %eax,0x8(%esp)
  80211e:	c7 44 24 04 00 50 80 	movl   $0x805000,0x4(%esp)
  802125:	00 
  802126:	8b 45 0c             	mov    0xc(%ebp),%eax
  802129:	89 04 24             	mov    %eax,(%esp)
  80212c:	e8 14 ea ff ff       	call   800b45 <memmove>
		*addrlen = ret->ret_addrlen;
  802131:	8b 16                	mov    (%esi),%edx
  802133:	8b 45 10             	mov    0x10(%ebp),%eax
  802136:	89 10                	mov    %edx,(%eax)
	}
	return r;
}
  802138:	89 d8                	mov    %ebx,%eax
  80213a:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  80213d:	8b 75 fc             	mov    -0x4(%ebp),%esi
  802140:	89 ec                	mov    %ebp,%esp
  802142:	5d                   	pop    %ebp
  802143:	c3                   	ret    
	...

00802150 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  802150:	55                   	push   %ebp
  802151:	89 e5                	mov    %esp,%ebp
  802153:	83 ec 18             	sub    $0x18,%esp
  802156:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  802159:	89 75 fc             	mov    %esi,-0x4(%ebp)
  80215c:	8b 75 0c             	mov    0xc(%ebp),%esi
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  80215f:	8b 45 08             	mov    0x8(%ebp),%eax
  802162:	89 04 24             	mov    %eax,(%esp)
  802165:	e8 46 f1 ff ff       	call   8012b0 <fd2data>
  80216a:	89 c3                	mov    %eax,%ebx
	strcpy(stat->st_name, "<pipe>");
  80216c:	c7 44 24 04 0a 2f 80 	movl   $0x802f0a,0x4(%esp)
  802173:	00 
  802174:	89 34 24             	mov    %esi,(%esp)
  802177:	e8 0e e8 ff ff       	call   80098a <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  80217c:	8b 43 04             	mov    0x4(%ebx),%eax
  80217f:	2b 03                	sub    (%ebx),%eax
  802181:	89 86 80 00 00 00    	mov    %eax,0x80(%esi)
	stat->st_isdir = 0;
  802187:	c7 86 84 00 00 00 00 	movl   $0x0,0x84(%esi)
  80218e:	00 00 00 
	stat->st_dev = &devpipe;
  802191:	c7 86 88 00 00 00 3c 	movl   $0x80603c,0x88(%esi)
  802198:	60 80 00 
	return 0;
}
  80219b:	b8 00 00 00 00       	mov    $0x0,%eax
  8021a0:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  8021a3:	8b 75 fc             	mov    -0x4(%ebp),%esi
  8021a6:	89 ec                	mov    %ebp,%esp
  8021a8:	5d                   	pop    %ebp
  8021a9:	c3                   	ret    

008021aa <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  8021aa:	55                   	push   %ebp
  8021ab:	89 e5                	mov    %esp,%ebp
  8021ad:	53                   	push   %ebx
  8021ae:	83 ec 14             	sub    $0x14,%esp
  8021b1:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  8021b4:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8021b8:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8021bf:	e8 fb ee ff ff       	call   8010bf <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  8021c4:	89 1c 24             	mov    %ebx,(%esp)
  8021c7:	e8 e4 f0 ff ff       	call   8012b0 <fd2data>
  8021cc:	89 44 24 04          	mov    %eax,0x4(%esp)
  8021d0:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8021d7:	e8 e3 ee ff ff       	call   8010bf <sys_page_unmap>
}
  8021dc:	83 c4 14             	add    $0x14,%esp
  8021df:	5b                   	pop    %ebx
  8021e0:	5d                   	pop    %ebp
  8021e1:	c3                   	ret    

008021e2 <_pipeisclosed>:
	return r;
}

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  8021e2:	55                   	push   %ebp
  8021e3:	89 e5                	mov    %esp,%ebp
  8021e5:	57                   	push   %edi
  8021e6:	56                   	push   %esi
  8021e7:	53                   	push   %ebx
  8021e8:	83 ec 2c             	sub    $0x2c,%esp
  8021eb:	89 c7                	mov    %eax,%edi
  8021ed:	89 55 e4             	mov    %edx,-0x1c(%ebp)
	int n, nn, ret;

	while (1) {
		n = env->env_runs;
  8021f0:	a1 74 60 80 00       	mov    0x806074,%eax
  8021f5:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  8021f8:	89 3c 24             	mov    %edi,(%esp)
  8021fb:	e8 b0 05 00 00       	call   8027b0 <pageref>
  802200:	89 c6                	mov    %eax,%esi
  802202:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802205:	89 04 24             	mov    %eax,(%esp)
  802208:	e8 a3 05 00 00       	call   8027b0 <pageref>
  80220d:	39 c6                	cmp    %eax,%esi
  80220f:	0f 94 c0             	sete   %al
  802212:	0f b6 c0             	movzbl %al,%eax
		nn = env->env_runs;
  802215:	8b 15 74 60 80 00    	mov    0x806074,%edx
  80221b:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  80221e:	39 cb                	cmp    %ecx,%ebx
  802220:	75 08                	jne    80222a <_pipeisclosed+0x48>
			return ret;
		if (n != nn && ret == 1)
			cprintf("pipe race avoided\n", n, env->env_runs, ret);
	}
}
  802222:	83 c4 2c             	add    $0x2c,%esp
  802225:	5b                   	pop    %ebx
  802226:	5e                   	pop    %esi
  802227:	5f                   	pop    %edi
  802228:	5d                   	pop    %ebp
  802229:	c3                   	ret    
		n = env->env_runs;
		ret = pageref(fd) == pageref(p);
		nn = env->env_runs;
		if (n == nn)
			return ret;
		if (n != nn && ret == 1)
  80222a:	83 f8 01             	cmp    $0x1,%eax
  80222d:	75 c1                	jne    8021f0 <_pipeisclosed+0xe>
			cprintf("pipe race avoided\n", n, env->env_runs, ret);
  80222f:	8b 52 58             	mov    0x58(%edx),%edx
  802232:	89 44 24 0c          	mov    %eax,0xc(%esp)
  802236:	89 54 24 08          	mov    %edx,0x8(%esp)
  80223a:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  80223e:	c7 04 24 11 2f 80 00 	movl   $0x802f11,(%esp)
  802245:	e8 7f e0 ff ff       	call   8002c9 <cprintf>
  80224a:	eb a4                	jmp    8021f0 <_pipeisclosed+0xe>

0080224c <devpipe_write>:
	return i;
}

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  80224c:	55                   	push   %ebp
  80224d:	89 e5                	mov    %esp,%ebp
  80224f:	57                   	push   %edi
  802250:	56                   	push   %esi
  802251:	53                   	push   %ebx
  802252:	83 ec 1c             	sub    $0x1c,%esp
  802255:	8b 75 08             	mov    0x8(%ebp),%esi
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  802258:	89 34 24             	mov    %esi,(%esp)
  80225b:	e8 50 f0 ff ff       	call   8012b0 <fd2data>
  802260:	89 c3                	mov    %eax,%ebx
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			env->env_id, vpt[VPN(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  802262:	bf 00 00 00 00       	mov    $0x0,%edi
  802267:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80226b:	75 54                	jne    8022c1 <devpipe_write+0x75>
  80226d:	eb 60                	jmp    8022cf <devpipe_write+0x83>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  80226f:	89 da                	mov    %ebx,%edx
  802271:	89 f0                	mov    %esi,%eax
  802273:	e8 6a ff ff ff       	call   8021e2 <_pipeisclosed>
  802278:	85 c0                	test   %eax,%eax
  80227a:	74 07                	je     802283 <devpipe_write+0x37>
  80227c:	b8 00 00 00 00       	mov    $0x0,%eax
  802281:	eb 53                	jmp    8022d6 <devpipe_write+0x8a>
				return 0;
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  802283:	90                   	nop
  802284:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802288:	e8 4d ef ff ff       	call   8011da <sys_yield>
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			env->env_id, vpt[VPN(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  80228d:	8b 43 04             	mov    0x4(%ebx),%eax
  802290:	8b 13                	mov    (%ebx),%edx
  802292:	83 c2 20             	add    $0x20,%edx
  802295:	39 d0                	cmp    %edx,%eax
  802297:	73 d6                	jae    80226f <devpipe_write+0x23>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  802299:	89 c2                	mov    %eax,%edx
  80229b:	c1 fa 1f             	sar    $0x1f,%edx
  80229e:	c1 ea 1b             	shr    $0x1b,%edx
  8022a1:	01 d0                	add    %edx,%eax
  8022a3:	83 e0 1f             	and    $0x1f,%eax
  8022a6:	29 d0                	sub    %edx,%eax
  8022a8:	89 c2                	mov    %eax,%edx
  8022aa:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8022ad:	0f b6 04 39          	movzbl (%ecx,%edi,1),%eax
  8022b1:	88 44 13 08          	mov    %al,0x8(%ebx,%edx,1)
		p->p_wpos++;
  8022b5:	83 43 04 01          	addl   $0x1,0x4(%ebx)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			env->env_id, vpt[VPN(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  8022b9:	83 c7 01             	add    $0x1,%edi
  8022bc:	39 7d 10             	cmp    %edi,0x10(%ebp)
  8022bf:	76 13                	jbe    8022d4 <devpipe_write+0x88>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  8022c1:	8b 43 04             	mov    0x4(%ebx),%eax
  8022c4:	8b 13                	mov    (%ebx),%edx
  8022c6:	83 c2 20             	add    $0x20,%edx
  8022c9:	39 d0                	cmp    %edx,%eax
  8022cb:	73 a2                	jae    80226f <devpipe_write+0x23>
  8022cd:	eb ca                	jmp    802299 <devpipe_write+0x4d>
  8022cf:	bf 00 00 00 00       	mov    $0x0,%edi
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}
	
	return i;
  8022d4:	89 f8                	mov    %edi,%eax
}
  8022d6:	83 c4 1c             	add    $0x1c,%esp
  8022d9:	5b                   	pop    %ebx
  8022da:	5e                   	pop    %esi
  8022db:	5f                   	pop    %edi
  8022dc:	5d                   	pop    %ebp
  8022dd:	c3                   	ret    

008022de <devpipe_read>:
	return _pipeisclosed(fd, p);
}

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  8022de:	55                   	push   %ebp
  8022df:	89 e5                	mov    %esp,%ebp
  8022e1:	83 ec 28             	sub    $0x28,%esp
  8022e4:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  8022e7:	89 75 f8             	mov    %esi,-0x8(%ebp)
  8022ea:	89 7d fc             	mov    %edi,-0x4(%ebp)
  8022ed:	8b 7d 08             	mov    0x8(%ebp),%edi
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  8022f0:	89 3c 24             	mov    %edi,(%esp)
  8022f3:	e8 b8 ef ff ff       	call   8012b0 <fd2data>
  8022f8:	89 c3                	mov    %eax,%ebx
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			env->env_id, vpt[VPN(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  8022fa:	be 00 00 00 00       	mov    $0x0,%esi
  8022ff:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  802303:	75 4c                	jne    802351 <devpipe_read+0x73>
  802305:	eb 5b                	jmp    802362 <devpipe_read+0x84>
		while (p->p_rpos == p->p_wpos) {
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
				return i;
  802307:	89 f0                	mov    %esi,%eax
  802309:	eb 5e                	jmp    802369 <devpipe_read+0x8b>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  80230b:	89 da                	mov    %ebx,%edx
  80230d:	89 f8                	mov    %edi,%eax
  80230f:	90                   	nop
  802310:	e8 cd fe ff ff       	call   8021e2 <_pipeisclosed>
  802315:	85 c0                	test   %eax,%eax
  802317:	74 07                	je     802320 <devpipe_read+0x42>
  802319:	b8 00 00 00 00       	mov    $0x0,%eax
  80231e:	eb 49                	jmp    802369 <devpipe_read+0x8b>
				return 0;
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  802320:	e8 b5 ee ff ff       	call   8011da <sys_yield>
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			env->env_id, vpt[VPN(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  802325:	8b 03                	mov    (%ebx),%eax
  802327:	3b 43 04             	cmp    0x4(%ebx),%eax
  80232a:	74 df                	je     80230b <devpipe_read+0x2d>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  80232c:	89 c2                	mov    %eax,%edx
  80232e:	c1 fa 1f             	sar    $0x1f,%edx
  802331:	c1 ea 1b             	shr    $0x1b,%edx
  802334:	01 d0                	add    %edx,%eax
  802336:	83 e0 1f             	and    $0x1f,%eax
  802339:	29 d0                	sub    %edx,%eax
  80233b:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  802340:	8b 55 0c             	mov    0xc(%ebp),%edx
  802343:	88 04 32             	mov    %al,(%edx,%esi,1)
		p->p_rpos++;
  802346:	83 03 01             	addl   $0x1,(%ebx)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			env->env_id, vpt[VPN(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  802349:	83 c6 01             	add    $0x1,%esi
  80234c:	39 75 10             	cmp    %esi,0x10(%ebp)
  80234f:	76 16                	jbe    802367 <devpipe_read+0x89>
		while (p->p_rpos == p->p_wpos) {
  802351:	8b 03                	mov    (%ebx),%eax
  802353:	3b 43 04             	cmp    0x4(%ebx),%eax
  802356:	75 d4                	jne    80232c <devpipe_read+0x4e>
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  802358:	85 f6                	test   %esi,%esi
  80235a:	75 ab                	jne    802307 <devpipe_read+0x29>
  80235c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802360:	eb a9                	jmp    80230b <devpipe_read+0x2d>
  802362:	be 00 00 00 00       	mov    $0x0,%esi
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  802367:	89 f0                	mov    %esi,%eax
}
  802369:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  80236c:	8b 75 f8             	mov    -0x8(%ebp),%esi
  80236f:	8b 7d fc             	mov    -0x4(%ebp),%edi
  802372:	89 ec                	mov    %ebp,%esp
  802374:	5d                   	pop    %ebp
  802375:	c3                   	ret    

00802376 <pipeisclosed>:
	}
}

int
pipeisclosed(int fdnum)
{
  802376:	55                   	push   %ebp
  802377:	89 e5                	mov    %esp,%ebp
  802379:	83 ec 28             	sub    $0x28,%esp
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80237c:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80237f:	89 44 24 04          	mov    %eax,0x4(%esp)
  802383:	8b 45 08             	mov    0x8(%ebp),%eax
  802386:	89 04 24             	mov    %eax,(%esp)
  802389:	e8 af ef ff ff       	call   80133d <fd_lookup>
  80238e:	85 c0                	test   %eax,%eax
  802390:	78 15                	js     8023a7 <pipeisclosed+0x31>
		return r;
	p = (struct Pipe*) fd2data(fd);
  802392:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802395:	89 04 24             	mov    %eax,(%esp)
  802398:	e8 13 ef ff ff       	call   8012b0 <fd2data>
	return _pipeisclosed(fd, p);
  80239d:	89 c2                	mov    %eax,%edx
  80239f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023a2:	e8 3b fe ff ff       	call   8021e2 <_pipeisclosed>
}
  8023a7:	c9                   	leave  
  8023a8:	c3                   	ret    

008023a9 <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  8023a9:	55                   	push   %ebp
  8023aa:	89 e5                	mov    %esp,%ebp
  8023ac:	83 ec 48             	sub    $0x48,%esp
  8023af:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  8023b2:	89 75 f8             	mov    %esi,-0x8(%ebp)
  8023b5:	89 7d fc             	mov    %edi,-0x4(%ebp)
  8023b8:	8b 7d 08             	mov    0x8(%ebp),%edi
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  8023bb:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  8023be:	89 04 24             	mov    %eax,(%esp)
  8023c1:	e8 05 ef ff ff       	call   8012cb <fd_alloc>
  8023c6:	89 c3                	mov    %eax,%ebx
  8023c8:	85 c0                	test   %eax,%eax
  8023ca:	0f 88 42 01 00 00    	js     802512 <pipe+0x169>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8023d0:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  8023d7:	00 
  8023d8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8023db:	89 44 24 04          	mov    %eax,0x4(%esp)
  8023df:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8023e6:	e8 90 ed ff ff       	call   80117b <sys_page_alloc>
  8023eb:	89 c3                	mov    %eax,%ebx
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  8023ed:	85 c0                	test   %eax,%eax
  8023ef:	0f 88 1d 01 00 00    	js     802512 <pipe+0x169>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  8023f5:	8d 45 e0             	lea    -0x20(%ebp),%eax
  8023f8:	89 04 24             	mov    %eax,(%esp)
  8023fb:	e8 cb ee ff ff       	call   8012cb <fd_alloc>
  802400:	89 c3                	mov    %eax,%ebx
  802402:	85 c0                	test   %eax,%eax
  802404:	0f 88 f5 00 00 00    	js     8024ff <pipe+0x156>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80240a:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  802411:	00 
  802412:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802415:	89 44 24 04          	mov    %eax,0x4(%esp)
  802419:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802420:	e8 56 ed ff ff       	call   80117b <sys_page_alloc>
  802425:	89 c3                	mov    %eax,%ebx
	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  802427:	85 c0                	test   %eax,%eax
  802429:	0f 88 d0 00 00 00    	js     8024ff <pipe+0x156>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  80242f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802432:	89 04 24             	mov    %eax,(%esp)
  802435:	e8 76 ee ff ff       	call   8012b0 <fd2data>
  80243a:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80243c:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  802443:	00 
  802444:	89 44 24 04          	mov    %eax,0x4(%esp)
  802448:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80244f:	e8 27 ed ff ff       	call   80117b <sys_page_alloc>
  802454:	89 c3                	mov    %eax,%ebx
  802456:	85 c0                	test   %eax,%eax
  802458:	0f 88 8e 00 00 00    	js     8024ec <pipe+0x143>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80245e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802461:	89 04 24             	mov    %eax,(%esp)
  802464:	e8 47 ee ff ff       	call   8012b0 <fd2data>
  802469:	c7 44 24 10 07 04 00 	movl   $0x407,0x10(%esp)
  802470:	00 
  802471:	89 44 24 0c          	mov    %eax,0xc(%esp)
  802475:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  80247c:	00 
  80247d:	89 74 24 04          	mov    %esi,0x4(%esp)
  802481:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802488:	e8 90 ec ff ff       	call   80111d <sys_page_map>
  80248d:	89 c3                	mov    %eax,%ebx
  80248f:	85 c0                	test   %eax,%eax
  802491:	78 49                	js     8024dc <pipe+0x133>
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  802493:	b8 3c 60 80 00       	mov    $0x80603c,%eax
  802498:	8b 08                	mov    (%eax),%ecx
  80249a:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80249d:	89 0a                	mov    %ecx,(%edx)
	fd0->fd_omode = O_RDONLY;
  80249f:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8024a2:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%edx)

	fd1->fd_dev_id = devpipe.dev_id;
  8024a9:	8b 10                	mov    (%eax),%edx
  8024ab:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8024ae:	89 10                	mov    %edx,(%eax)
	fd1->fd_omode = O_WRONLY;
  8024b0:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8024b3:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", env->env_id, vpt[VPN(va)]);

	pfd[0] = fd2num(fd0);
  8024ba:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8024bd:	89 04 24             	mov    %eax,(%esp)
  8024c0:	e8 db ed ff ff       	call   8012a0 <fd2num>
  8024c5:	89 07                	mov    %eax,(%edi)
	pfd[1] = fd2num(fd1);
  8024c7:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8024ca:	89 04 24             	mov    %eax,(%esp)
  8024cd:	e8 ce ed ff ff       	call   8012a0 <fd2num>
  8024d2:	89 47 04             	mov    %eax,0x4(%edi)
  8024d5:	bb 00 00 00 00       	mov    $0x0,%ebx
	return 0;
  8024da:	eb 36                	jmp    802512 <pipe+0x169>

    err3:
	sys_page_unmap(0, va);
  8024dc:	89 74 24 04          	mov    %esi,0x4(%esp)
  8024e0:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8024e7:	e8 d3 eb ff ff       	call   8010bf <sys_page_unmap>
    err2:
	sys_page_unmap(0, fd1);
  8024ec:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8024ef:	89 44 24 04          	mov    %eax,0x4(%esp)
  8024f3:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8024fa:	e8 c0 eb ff ff       	call   8010bf <sys_page_unmap>
    err1:
	sys_page_unmap(0, fd0);
  8024ff:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802502:	89 44 24 04          	mov    %eax,0x4(%esp)
  802506:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80250d:	e8 ad eb ff ff       	call   8010bf <sys_page_unmap>
    err:
	return r;
}
  802512:	89 d8                	mov    %ebx,%eax
  802514:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  802517:	8b 75 f8             	mov    -0x8(%ebp),%esi
  80251a:	8b 7d fc             	mov    -0x4(%ebp),%edi
  80251d:	89 ec                	mov    %ebp,%esp
  80251f:	5d                   	pop    %ebp
  802520:	c3                   	ret    
	...

00802530 <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  802530:	55                   	push   %ebp
  802531:	89 e5                	mov    %esp,%ebp
	USED(fd);

	return 0;
}
  802533:	b8 00 00 00 00       	mov    $0x0,%eax
  802538:	5d                   	pop    %ebp
  802539:	c3                   	ret    

0080253a <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  80253a:	55                   	push   %ebp
  80253b:	89 e5                	mov    %esp,%ebp
  80253d:	83 ec 18             	sub    $0x18,%esp
	strcpy(stat->st_name, "<cons>");
  802540:	c7 44 24 04 29 2f 80 	movl   $0x802f29,0x4(%esp)
  802547:	00 
  802548:	8b 45 0c             	mov    0xc(%ebp),%eax
  80254b:	89 04 24             	mov    %eax,(%esp)
  80254e:	e8 37 e4 ff ff       	call   80098a <strcpy>
	return 0;
}
  802553:	b8 00 00 00 00       	mov    $0x0,%eax
  802558:	c9                   	leave  
  802559:	c3                   	ret    

0080255a <devcons_write>:
	return 1;
}

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  80255a:	55                   	push   %ebp
  80255b:	89 e5                	mov    %esp,%ebp
  80255d:	57                   	push   %edi
  80255e:	56                   	push   %esi
  80255f:	53                   	push   %ebx
  802560:	81 ec 9c 00 00 00    	sub    $0x9c,%esp
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs, 
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  802566:	b8 00 00 00 00       	mov    $0x0,%eax
  80256b:	be 00 00 00 00       	mov    $0x0,%esi
  802570:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  802574:	74 3f                	je     8025b5 <devcons_write+0x5b>
		m = n - tot;
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  802576:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs, 
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
		m = n - tot;
  80257c:	8b 55 10             	mov    0x10(%ebp),%edx
  80257f:	29 c2                	sub    %eax,%edx
  802581:	89 d3                	mov    %edx,%ebx
		if (m > sizeof(buf) - 1)
  802583:	83 fa 7f             	cmp    $0x7f,%edx
  802586:	76 05                	jbe    80258d <devcons_write+0x33>
  802588:	bb 7f 00 00 00       	mov    $0x7f,%ebx
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  80258d:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  802591:	03 45 0c             	add    0xc(%ebp),%eax
  802594:	89 44 24 04          	mov    %eax,0x4(%esp)
  802598:	89 3c 24             	mov    %edi,(%esp)
  80259b:	e8 a5 e5 ff ff       	call   800b45 <memmove>
		sys_cputs(buf, m);
  8025a0:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8025a4:	89 3c 24             	mov    %edi,(%esp)
  8025a7:	e8 d4 e7 ff ff       	call   800d80 <sys_cputs>
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs, 
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  8025ac:	01 de                	add    %ebx,%esi
  8025ae:	89 f0                	mov    %esi,%eax
  8025b0:	3b 75 10             	cmp    0x10(%ebp),%esi
  8025b3:	72 c7                	jb     80257c <devcons_write+0x22>
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
}
  8025b5:	89 f0                	mov    %esi,%eax
  8025b7:	81 c4 9c 00 00 00    	add    $0x9c,%esp
  8025bd:	5b                   	pop    %ebx
  8025be:	5e                   	pop    %esi
  8025bf:	5f                   	pop    %edi
  8025c0:	5d                   	pop    %ebp
  8025c1:	c3                   	ret    

008025c2 <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  8025c2:	55                   	push   %ebp
  8025c3:	89 e5                	mov    %esp,%ebp
  8025c5:	83 ec 28             	sub    $0x28,%esp
	char c = ch;
  8025c8:	8b 45 08             	mov    0x8(%ebp),%eax
  8025cb:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  8025ce:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  8025d5:	00 
  8025d6:	8d 45 f7             	lea    -0x9(%ebp),%eax
  8025d9:	89 04 24             	mov    %eax,(%esp)
  8025dc:	e8 9f e7 ff ff       	call   800d80 <sys_cputs>
}
  8025e1:	c9                   	leave  
  8025e2:	c3                   	ret    

008025e3 <devcons_read>:
	return fd2num(fd);
}

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  8025e3:	55                   	push   %ebp
  8025e4:	89 e5                	mov    %esp,%ebp
  8025e6:	83 ec 08             	sub    $0x8,%esp
	int c;

	if (n == 0)
  8025e9:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8025ed:	75 07                	jne    8025f6 <devcons_read+0x13>
  8025ef:	eb 28                	jmp    802619 <devcons_read+0x36>
		return 0;

	while ((c = sys_cgetc()) == 0)
		sys_yield();
  8025f1:	e8 e4 eb ff ff       	call   8011da <sys_yield>
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  8025f6:	66 90                	xchg   %ax,%ax
  8025f8:	e8 4f e7 ff ff       	call   800d4c <sys_cgetc>
  8025fd:	85 c0                	test   %eax,%eax
  8025ff:	90                   	nop
  802600:	74 ef                	je     8025f1 <devcons_read+0xe>
  802602:	89 c2                	mov    %eax,%edx
		sys_yield();
	if (c < 0)
  802604:	85 c0                	test   %eax,%eax
  802606:	78 16                	js     80261e <devcons_read+0x3b>
		return c;
	if (c == 0x04)	// ctl-d is eof
  802608:	83 f8 04             	cmp    $0x4,%eax
  80260b:	74 0c                	je     802619 <devcons_read+0x36>
		return 0;
	*(char*)vbuf = c;
  80260d:	8b 45 0c             	mov    0xc(%ebp),%eax
  802610:	88 10                	mov    %dl,(%eax)
  802612:	b8 01 00 00 00       	mov    $0x1,%eax
	return 1;
  802617:	eb 05                	jmp    80261e <devcons_read+0x3b>
  802619:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80261e:	c9                   	leave  
  80261f:	c3                   	ret    

00802620 <opencons>:
	return fd->fd_dev_id == devcons.dev_id;
}

int
opencons(void)
{
  802620:	55                   	push   %ebp
  802621:	89 e5                	mov    %esp,%ebp
  802623:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  802626:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802629:	89 04 24             	mov    %eax,(%esp)
  80262c:	e8 9a ec ff ff       	call   8012cb <fd_alloc>
  802631:	85 c0                	test   %eax,%eax
  802633:	78 3f                	js     802674 <opencons+0x54>
		return r;
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  802635:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  80263c:	00 
  80263d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802640:	89 44 24 04          	mov    %eax,0x4(%esp)
  802644:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80264b:	e8 2b eb ff ff       	call   80117b <sys_page_alloc>
  802650:	85 c0                	test   %eax,%eax
  802652:	78 20                	js     802674 <opencons+0x54>
		return r;
	fd->fd_dev_id = devcons.dev_id;
  802654:	8b 15 58 60 80 00    	mov    0x806058,%edx
  80265a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80265d:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  80265f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802662:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  802669:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80266c:	89 04 24             	mov    %eax,(%esp)
  80266f:	e8 2c ec ff ff       	call   8012a0 <fd2num>
}
  802674:	c9                   	leave  
  802675:	c3                   	ret    

00802676 <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  802676:	55                   	push   %ebp
  802677:	89 e5                	mov    %esp,%ebp
  802679:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80267c:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80267f:	89 44 24 04          	mov    %eax,0x4(%esp)
  802683:	8b 45 08             	mov    0x8(%ebp),%eax
  802686:	89 04 24             	mov    %eax,(%esp)
  802689:	e8 af ec ff ff       	call   80133d <fd_lookup>
  80268e:	85 c0                	test   %eax,%eax
  802690:	78 11                	js     8026a3 <iscons+0x2d>
		return r;
	return fd->fd_dev_id == devcons.dev_id;
  802692:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802695:	8b 00                	mov    (%eax),%eax
  802697:	3b 05 58 60 80 00    	cmp    0x806058,%eax
  80269d:	0f 94 c0             	sete   %al
  8026a0:	0f b6 c0             	movzbl %al,%eax
}
  8026a3:	c9                   	leave  
  8026a4:	c3                   	ret    

008026a5 <getchar>:
	sys_cputs(&c, 1);
}

int
getchar(void)
{
  8026a5:	55                   	push   %ebp
  8026a6:	89 e5                	mov    %esp,%ebp
  8026a8:	83 ec 28             	sub    $0x28,%esp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  8026ab:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  8026b2:	00 
  8026b3:	8d 45 f7             	lea    -0x9(%ebp),%eax
  8026b6:	89 44 24 04          	mov    %eax,0x4(%esp)
  8026ba:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8026c1:	e8 d8 ee ff ff       	call   80159e <read>
	if (r < 0)
  8026c6:	85 c0                	test   %eax,%eax
  8026c8:	78 0f                	js     8026d9 <getchar+0x34>
		return r;
	if (r < 1)
  8026ca:	85 c0                	test   %eax,%eax
  8026cc:	7f 07                	jg     8026d5 <getchar+0x30>
  8026ce:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  8026d3:	eb 04                	jmp    8026d9 <getchar+0x34>
		return -E_EOF;
	return c;
  8026d5:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  8026d9:	c9                   	leave  
  8026da:	c3                   	ret    
  8026db:	00 00                	add    %al,(%eax)
  8026dd:	00 00                	add    %al,(%eax)
	...

008026e0 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  8026e0:	55                   	push   %ebp
  8026e1:	89 e5                	mov    %esp,%ebp
  8026e3:	57                   	push   %edi
  8026e4:	56                   	push   %esi
  8026e5:	53                   	push   %ebx
  8026e6:	83 ec 1c             	sub    $0x1c,%esp
  8026e9:	8b 7d 0c             	mov    0xc(%ebp),%edi
  8026ec:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8026ef:	8b 75 14             	mov    0x14(%ebp),%esi
	// LAB 4: Your code here.
	int r;
	if (pg == NULL)
  8026f2:	85 db                	test   %ebx,%ebx
  8026f4:	75 2d                	jne    802723 <ipc_send+0x43>
  8026f6:	bb 00 00 c0 ee       	mov    $0xeec00000,%ebx
  8026fb:	eb 26                	jmp    802723 <ipc_send+0x43>
		pg = (void*)UTOP;
	while ((r = sys_ipc_try_send(to_env, val, pg, perm)) < 0)
	{
		if(r != -E_IPC_NOT_RECV)
  8026fd:	83 f8 f9             	cmp    $0xfffffff9,%eax
  802700:	74 1c                	je     80271e <ipc_send+0x3e>
			panic("Panic in lib ipc.c : ipc_send() \n");
  802702:	c7 44 24 08 38 2f 80 	movl   $0x802f38,0x8(%esp)
  802709:	00 
  80270a:	c7 44 24 04 44 00 00 	movl   $0x44,0x4(%esp)
  802711:	00 
  802712:	c7 04 24 5c 2f 80 00 	movl   $0x802f5c,(%esp)
  802719:	e8 e6 da ff ff       	call   800204 <_panic>
		sys_yield();
  80271e:	e8 b7 ea ff ff       	call   8011da <sys_yield>
{
	// LAB 4: Your code here.
	int r;
	if (pg == NULL)
		pg = (void*)UTOP;
	while ((r = sys_ipc_try_send(to_env, val, pg, perm)) < 0)
  802723:	89 74 24 0c          	mov    %esi,0xc(%esp)
  802727:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80272b:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80272f:	8b 45 08             	mov    0x8(%ebp),%eax
  802732:	89 04 24             	mov    %eax,(%esp)
  802735:	e8 33 e8 ff ff       	call   800f6d <sys_ipc_try_send>
  80273a:	85 c0                	test   %eax,%eax
  80273c:	78 bf                	js     8026fd <ipc_send+0x1d>
		if(r != -E_IPC_NOT_RECV)
			panic("Panic in lib ipc.c : ipc_send() \n");
		sys_yield();
	}
	//panic("ipc_send not implemented");
}
  80273e:	83 c4 1c             	add    $0x1c,%esp
  802741:	5b                   	pop    %ebx
  802742:	5e                   	pop    %esi
  802743:	5f                   	pop    %edi
  802744:	5d                   	pop    %ebp
  802745:	c3                   	ret    

00802746 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  802746:	55                   	push   %ebp
  802747:	89 e5                	mov    %esp,%ebp
  802749:	56                   	push   %esi
  80274a:	53                   	push   %ebx
  80274b:	83 ec 10             	sub    $0x10,%esp
  80274e:	8b 5d 08             	mov    0x8(%ebp),%ebx
  802751:	8b 45 0c             	mov    0xc(%ebp),%eax
  802754:	8b 75 10             	mov    0x10(%ebp),%esi
	// LAB 4: Your code here.
	int r;

	if (pg == NULL)
  802757:	85 c0                	test   %eax,%eax
  802759:	75 05                	jne    802760 <ipc_recv+0x1a>
  80275b:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
		pg = (void*)UTOP;
	if ((r = sys_ipc_recv(pg)) < 0)
  802760:	89 04 24             	mov    %eax,(%esp)
  802763:	e8 a8 e7 ff ff       	call   800f10 <sys_ipc_recv>
  802768:	85 c0                	test   %eax,%eax
  80276a:	79 16                	jns    802782 <ipc_recv+0x3c>
	{
		if (from_env_store != NULL)
  80276c:	85 db                	test   %ebx,%ebx
  80276e:	74 06                	je     802776 <ipc_recv+0x30>
			*from_env_store = 0;
  802770:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
		if(perm_store != NULL)
  802776:	85 f6                	test   %esi,%esi
  802778:	74 2c                	je     8027a6 <ipc_recv+0x60>
			*perm_store = 0;
  80277a:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
  802780:	eb 24                	jmp    8027a6 <ipc_recv+0x60>
		return r;
	}
	else
	{	
		if (from_env_store != NULL)
  802782:	85 db                	test   %ebx,%ebx
  802784:	74 0a                	je     802790 <ipc_recv+0x4a>
			*from_env_store = env->env_ipc_from;
  802786:	a1 74 60 80 00       	mov    0x806074,%eax
  80278b:	8b 40 74             	mov    0x74(%eax),%eax
  80278e:	89 03                	mov    %eax,(%ebx)
		if(perm_store != NULL)
  802790:	85 f6                	test   %esi,%esi
  802792:	74 0a                	je     80279e <ipc_recv+0x58>
			*perm_store = env->env_ipc_perm;
  802794:	a1 74 60 80 00       	mov    0x806074,%eax
  802799:	8b 40 78             	mov    0x78(%eax),%eax
  80279c:	89 06                	mov    %eax,(%esi)
		return env->env_ipc_value;
  80279e:	a1 74 60 80 00       	mov    0x806074,%eax
  8027a3:	8b 40 70             	mov    0x70(%eax),%eax
	}		
	//panic("ipc_recv not implemented");
	//return 0;
}
  8027a6:	83 c4 10             	add    $0x10,%esp
  8027a9:	5b                   	pop    %ebx
  8027aa:	5e                   	pop    %esi
  8027ab:	5d                   	pop    %ebp
  8027ac:	c3                   	ret    
  8027ad:	00 00                	add    %al,(%eax)
	...

008027b0 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  8027b0:	55                   	push   %ebp
  8027b1:	89 e5                	mov    %esp,%ebp
	pte_t pte;

	if (!(vpd[PDX(v)] & PTE_P))
  8027b3:	8b 45 08             	mov    0x8(%ebp),%eax
  8027b6:	89 c2                	mov    %eax,%edx
  8027b8:	c1 ea 16             	shr    $0x16,%edx
  8027bb:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  8027c2:	f6 c2 01             	test   $0x1,%dl
  8027c5:	74 26                	je     8027ed <pageref+0x3d>
		return 0;
	pte = vpt[VPN(v)];
  8027c7:	c1 e8 0c             	shr    $0xc,%eax
  8027ca:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
	if (!(pte & PTE_P))
  8027d1:	a8 01                	test   $0x1,%al
  8027d3:	74 18                	je     8027ed <pageref+0x3d>
		return 0;
	return pages[PPN(pte)].pp_ref;
  8027d5:	c1 e8 0c             	shr    $0xc,%eax
  8027d8:	8d 14 40             	lea    (%eax,%eax,2),%edx
  8027db:	c1 e2 02             	shl    $0x2,%edx
  8027de:	b8 00 00 00 ef       	mov    $0xef000000,%eax
  8027e3:	0f b7 44 02 08       	movzwl 0x8(%edx,%eax,1),%eax
  8027e8:	0f b7 c0             	movzwl %ax,%eax
  8027eb:	eb 05                	jmp    8027f2 <pageref+0x42>
  8027ed:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8027f2:	5d                   	pop    %ebp
  8027f3:	c3                   	ret    
	...

00802800 <__udivdi3>:
  802800:	55                   	push   %ebp
  802801:	89 e5                	mov    %esp,%ebp
  802803:	57                   	push   %edi
  802804:	56                   	push   %esi
  802805:	83 ec 10             	sub    $0x10,%esp
  802808:	8b 45 14             	mov    0x14(%ebp),%eax
  80280b:	8b 55 08             	mov    0x8(%ebp),%edx
  80280e:	8b 75 10             	mov    0x10(%ebp),%esi
  802811:	8b 7d 0c             	mov    0xc(%ebp),%edi
  802814:	85 c0                	test   %eax,%eax
  802816:	89 55 f0             	mov    %edx,-0x10(%ebp)
  802819:	75 35                	jne    802850 <__udivdi3+0x50>
  80281b:	39 fe                	cmp    %edi,%esi
  80281d:	77 61                	ja     802880 <__udivdi3+0x80>
  80281f:	85 f6                	test   %esi,%esi
  802821:	75 0b                	jne    80282e <__udivdi3+0x2e>
  802823:	b8 01 00 00 00       	mov    $0x1,%eax
  802828:	31 d2                	xor    %edx,%edx
  80282a:	f7 f6                	div    %esi
  80282c:	89 c6                	mov    %eax,%esi
  80282e:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  802831:	31 d2                	xor    %edx,%edx
  802833:	89 f8                	mov    %edi,%eax
  802835:	f7 f6                	div    %esi
  802837:	89 c7                	mov    %eax,%edi
  802839:	89 c8                	mov    %ecx,%eax
  80283b:	f7 f6                	div    %esi
  80283d:	89 c1                	mov    %eax,%ecx
  80283f:	89 fa                	mov    %edi,%edx
  802841:	89 c8                	mov    %ecx,%eax
  802843:	83 c4 10             	add    $0x10,%esp
  802846:	5e                   	pop    %esi
  802847:	5f                   	pop    %edi
  802848:	5d                   	pop    %ebp
  802849:	c3                   	ret    
  80284a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  802850:	39 f8                	cmp    %edi,%eax
  802852:	77 1c                	ja     802870 <__udivdi3+0x70>
  802854:	0f bd d0             	bsr    %eax,%edx
  802857:	83 f2 1f             	xor    $0x1f,%edx
  80285a:	89 55 f4             	mov    %edx,-0xc(%ebp)
  80285d:	75 39                	jne    802898 <__udivdi3+0x98>
  80285f:	3b 75 f0             	cmp    -0x10(%ebp),%esi
  802862:	0f 86 a0 00 00 00    	jbe    802908 <__udivdi3+0x108>
  802868:	39 f8                	cmp    %edi,%eax
  80286a:	0f 82 98 00 00 00    	jb     802908 <__udivdi3+0x108>
  802870:	31 ff                	xor    %edi,%edi
  802872:	31 c9                	xor    %ecx,%ecx
  802874:	89 c8                	mov    %ecx,%eax
  802876:	89 fa                	mov    %edi,%edx
  802878:	83 c4 10             	add    $0x10,%esp
  80287b:	5e                   	pop    %esi
  80287c:	5f                   	pop    %edi
  80287d:	5d                   	pop    %ebp
  80287e:	c3                   	ret    
  80287f:	90                   	nop
  802880:	89 d1                	mov    %edx,%ecx
  802882:	89 fa                	mov    %edi,%edx
  802884:	89 c8                	mov    %ecx,%eax
  802886:	31 ff                	xor    %edi,%edi
  802888:	f7 f6                	div    %esi
  80288a:	89 c1                	mov    %eax,%ecx
  80288c:	89 fa                	mov    %edi,%edx
  80288e:	89 c8                	mov    %ecx,%eax
  802890:	83 c4 10             	add    $0x10,%esp
  802893:	5e                   	pop    %esi
  802894:	5f                   	pop    %edi
  802895:	5d                   	pop    %ebp
  802896:	c3                   	ret    
  802897:	90                   	nop
  802898:	0f b6 4d f4          	movzbl -0xc(%ebp),%ecx
  80289c:	89 f2                	mov    %esi,%edx
  80289e:	d3 e0                	shl    %cl,%eax
  8028a0:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8028a3:	b8 20 00 00 00       	mov    $0x20,%eax
  8028a8:	2b 45 f4             	sub    -0xc(%ebp),%eax
  8028ab:	89 c1                	mov    %eax,%ecx
  8028ad:	d3 ea                	shr    %cl,%edx
  8028af:	0f b6 4d f4          	movzbl -0xc(%ebp),%ecx
  8028b3:	0b 55 ec             	or     -0x14(%ebp),%edx
  8028b6:	d3 e6                	shl    %cl,%esi
  8028b8:	89 c1                	mov    %eax,%ecx
  8028ba:	89 75 e8             	mov    %esi,-0x18(%ebp)
  8028bd:	89 fe                	mov    %edi,%esi
  8028bf:	d3 ee                	shr    %cl,%esi
  8028c1:	0f b6 4d f4          	movzbl -0xc(%ebp),%ecx
  8028c5:	89 55 ec             	mov    %edx,-0x14(%ebp)
  8028c8:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8028cb:	d3 e7                	shl    %cl,%edi
  8028cd:	89 c1                	mov    %eax,%ecx
  8028cf:	d3 ea                	shr    %cl,%edx
  8028d1:	09 d7                	or     %edx,%edi
  8028d3:	89 f2                	mov    %esi,%edx
  8028d5:	89 f8                	mov    %edi,%eax
  8028d7:	f7 75 ec             	divl   -0x14(%ebp)
  8028da:	89 d6                	mov    %edx,%esi
  8028dc:	89 c7                	mov    %eax,%edi
  8028de:	f7 65 e8             	mull   -0x18(%ebp)
  8028e1:	39 d6                	cmp    %edx,%esi
  8028e3:	89 55 ec             	mov    %edx,-0x14(%ebp)
  8028e6:	72 30                	jb     802918 <__udivdi3+0x118>
  8028e8:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8028eb:	0f b6 4d f4          	movzbl -0xc(%ebp),%ecx
  8028ef:	d3 e2                	shl    %cl,%edx
  8028f1:	39 c2                	cmp    %eax,%edx
  8028f3:	73 05                	jae    8028fa <__udivdi3+0xfa>
  8028f5:	3b 75 ec             	cmp    -0x14(%ebp),%esi
  8028f8:	74 1e                	je     802918 <__udivdi3+0x118>
  8028fa:	89 f9                	mov    %edi,%ecx
  8028fc:	31 ff                	xor    %edi,%edi
  8028fe:	e9 71 ff ff ff       	jmp    802874 <__udivdi3+0x74>
  802903:	90                   	nop
  802904:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802908:	31 ff                	xor    %edi,%edi
  80290a:	b9 01 00 00 00       	mov    $0x1,%ecx
  80290f:	e9 60 ff ff ff       	jmp    802874 <__udivdi3+0x74>
  802914:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802918:	8d 4f ff             	lea    -0x1(%edi),%ecx
  80291b:	31 ff                	xor    %edi,%edi
  80291d:	89 c8                	mov    %ecx,%eax
  80291f:	89 fa                	mov    %edi,%edx
  802921:	83 c4 10             	add    $0x10,%esp
  802924:	5e                   	pop    %esi
  802925:	5f                   	pop    %edi
  802926:	5d                   	pop    %ebp
  802927:	c3                   	ret    
	...

00802930 <__umoddi3>:
  802930:	55                   	push   %ebp
  802931:	89 e5                	mov    %esp,%ebp
  802933:	57                   	push   %edi
  802934:	56                   	push   %esi
  802935:	83 ec 20             	sub    $0x20,%esp
  802938:	8b 55 14             	mov    0x14(%ebp),%edx
  80293b:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80293e:	8b 7d 10             	mov    0x10(%ebp),%edi
  802941:	8b 75 0c             	mov    0xc(%ebp),%esi
  802944:	85 d2                	test   %edx,%edx
  802946:	89 c8                	mov    %ecx,%eax
  802948:	89 4d f4             	mov    %ecx,-0xc(%ebp)
  80294b:	75 13                	jne    802960 <__umoddi3+0x30>
  80294d:	39 f7                	cmp    %esi,%edi
  80294f:	76 3f                	jbe    802990 <__umoddi3+0x60>
  802951:	89 f2                	mov    %esi,%edx
  802953:	f7 f7                	div    %edi
  802955:	89 d0                	mov    %edx,%eax
  802957:	31 d2                	xor    %edx,%edx
  802959:	83 c4 20             	add    $0x20,%esp
  80295c:	5e                   	pop    %esi
  80295d:	5f                   	pop    %edi
  80295e:	5d                   	pop    %ebp
  80295f:	c3                   	ret    
  802960:	39 f2                	cmp    %esi,%edx
  802962:	77 4c                	ja     8029b0 <__umoddi3+0x80>
  802964:	0f bd ca             	bsr    %edx,%ecx
  802967:	83 f1 1f             	xor    $0x1f,%ecx
  80296a:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  80296d:	75 51                	jne    8029c0 <__umoddi3+0x90>
  80296f:	3b 7d f4             	cmp    -0xc(%ebp),%edi
  802972:	0f 87 e0 00 00 00    	ja     802a58 <__umoddi3+0x128>
  802978:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80297b:	29 f8                	sub    %edi,%eax
  80297d:	19 d6                	sbb    %edx,%esi
  80297f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802982:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802985:	89 f2                	mov    %esi,%edx
  802987:	83 c4 20             	add    $0x20,%esp
  80298a:	5e                   	pop    %esi
  80298b:	5f                   	pop    %edi
  80298c:	5d                   	pop    %ebp
  80298d:	c3                   	ret    
  80298e:	66 90                	xchg   %ax,%ax
  802990:	85 ff                	test   %edi,%edi
  802992:	75 0b                	jne    80299f <__umoddi3+0x6f>
  802994:	b8 01 00 00 00       	mov    $0x1,%eax
  802999:	31 d2                	xor    %edx,%edx
  80299b:	f7 f7                	div    %edi
  80299d:	89 c7                	mov    %eax,%edi
  80299f:	89 f0                	mov    %esi,%eax
  8029a1:	31 d2                	xor    %edx,%edx
  8029a3:	f7 f7                	div    %edi
  8029a5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029a8:	f7 f7                	div    %edi
  8029aa:	eb a9                	jmp    802955 <__umoddi3+0x25>
  8029ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  8029b0:	89 c8                	mov    %ecx,%eax
  8029b2:	89 f2                	mov    %esi,%edx
  8029b4:	83 c4 20             	add    $0x20,%esp
  8029b7:	5e                   	pop    %esi
  8029b8:	5f                   	pop    %edi
  8029b9:	5d                   	pop    %ebp
  8029ba:	c3                   	ret    
  8029bb:	90                   	nop
  8029bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  8029c0:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
  8029c4:	d3 e2                	shl    %cl,%edx
  8029c6:	89 55 f4             	mov    %edx,-0xc(%ebp)
  8029c9:	ba 20 00 00 00       	mov    $0x20,%edx
  8029ce:	2b 55 f0             	sub    -0x10(%ebp),%edx
  8029d1:	89 55 ec             	mov    %edx,-0x14(%ebp)
  8029d4:	0f b6 4d ec          	movzbl -0x14(%ebp),%ecx
  8029d8:	89 fa                	mov    %edi,%edx
  8029da:	d3 ea                	shr    %cl,%edx
  8029dc:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
  8029e0:	0b 55 f4             	or     -0xc(%ebp),%edx
  8029e3:	d3 e7                	shl    %cl,%edi
  8029e5:	0f b6 4d ec          	movzbl -0x14(%ebp),%ecx
  8029e9:	89 55 f4             	mov    %edx,-0xc(%ebp)
  8029ec:	89 f2                	mov    %esi,%edx
  8029ee:	89 7d e8             	mov    %edi,-0x18(%ebp)
  8029f1:	89 c7                	mov    %eax,%edi
  8029f3:	d3 ea                	shr    %cl,%edx
  8029f5:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
  8029f9:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  8029fc:	89 c2                	mov    %eax,%edx
  8029fe:	d3 e6                	shl    %cl,%esi
  802a00:	0f b6 4d ec          	movzbl -0x14(%ebp),%ecx
  802a04:	d3 ea                	shr    %cl,%edx
  802a06:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
  802a0a:	09 d6                	or     %edx,%esi
  802a0c:	89 f0                	mov    %esi,%eax
  802a0e:	8b 75 e4             	mov    -0x1c(%ebp),%esi
  802a11:	d3 e7                	shl    %cl,%edi
  802a13:	89 f2                	mov    %esi,%edx
  802a15:	f7 75 f4             	divl   -0xc(%ebp)
  802a18:	89 d6                	mov    %edx,%esi
  802a1a:	f7 65 e8             	mull   -0x18(%ebp)
  802a1d:	39 d6                	cmp    %edx,%esi
  802a1f:	72 2b                	jb     802a4c <__umoddi3+0x11c>
  802a21:	39 c7                	cmp    %eax,%edi
  802a23:	72 23                	jb     802a48 <__umoddi3+0x118>
  802a25:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
  802a29:	29 c7                	sub    %eax,%edi
  802a2b:	19 d6                	sbb    %edx,%esi
  802a2d:	89 f0                	mov    %esi,%eax
  802a2f:	89 f2                	mov    %esi,%edx
  802a31:	d3 ef                	shr    %cl,%edi
  802a33:	0f b6 4d ec          	movzbl -0x14(%ebp),%ecx
  802a37:	d3 e0                	shl    %cl,%eax
  802a39:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
  802a3d:	09 f8                	or     %edi,%eax
  802a3f:	d3 ea                	shr    %cl,%edx
  802a41:	83 c4 20             	add    $0x20,%esp
  802a44:	5e                   	pop    %esi
  802a45:	5f                   	pop    %edi
  802a46:	5d                   	pop    %ebp
  802a47:	c3                   	ret    
  802a48:	39 d6                	cmp    %edx,%esi
  802a4a:	75 d9                	jne    802a25 <__umoddi3+0xf5>
  802a4c:	2b 45 e8             	sub    -0x18(%ebp),%eax
  802a4f:	1b 55 f4             	sbb    -0xc(%ebp),%edx
  802a52:	eb d1                	jmp    802a25 <__umoddi3+0xf5>
  802a54:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802a58:	39 f2                	cmp    %esi,%edx
  802a5a:	0f 82 18 ff ff ff    	jb     802978 <__umoddi3+0x48>
  802a60:	e9 1d ff ff ff       	jmp    802982 <__umoddi3+0x52>
