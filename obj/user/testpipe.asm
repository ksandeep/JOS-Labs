
obj/user/testpipe:     file format elf32-i386


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
  80002c:	e8 e7 02 00 00       	call   800318 <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>
	...

00800034 <umain>:

char *msg = "Now is the time for all good men to come to the aid of their party.";

void
umain(void)
{
  800034:	55                   	push   %ebp
  800035:	89 e5                	mov    %esp,%ebp
  800037:	56                   	push   %esi
  800038:	53                   	push   %ebx
  800039:	83 c4 80             	add    $0xffffff80,%esp
	char buf[100];
	int i, pid, p[2];

	argv0 = "pipereadeof";
  80003c:	c7 05 7c 70 80 00 a0 	movl   $0x802fa0,0x80707c
  800043:	2f 80 00 

	if ((i = pipe(p)) < 0)
  800046:	8d 45 8c             	lea    -0x74(%ebp),%eax
  800049:	89 04 24             	mov    %eax,(%esp)
  80004c:	e8 58 27 00 00       	call   8027a9 <pipe>
  800051:	89 c6                	mov    %eax,%esi
  800053:	85 c0                	test   %eax,%eax
  800055:	79 20                	jns    800077 <umain+0x43>
		panic("pipe: %e", i);
  800057:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80005b:	c7 44 24 08 ac 2f 80 	movl   $0x802fac,0x8(%esp)
  800062:	00 
  800063:	c7 44 24 04 0e 00 00 	movl   $0xe,0x4(%esp)
  80006a:	00 
  80006b:	c7 04 24 b5 2f 80 00 	movl   $0x802fb5,(%esp)
  800072:	e8 0d 03 00 00       	call   800384 <_panic>

	if ((pid = fork()) < 0)
  800077:	e8 09 15 00 00       	call   801585 <fork>
  80007c:	89 c3                	mov    %eax,%ebx
  80007e:	85 c0                	test   %eax,%eax
  800080:	79 20                	jns    8000a2 <umain+0x6e>
		panic("fork: %e", i);
  800082:	89 74 24 0c          	mov    %esi,0xc(%esp)
  800086:	c7 44 24 08 c5 2f 80 	movl   $0x802fc5,0x8(%esp)
  80008d:	00 
  80008e:	c7 44 24 04 11 00 00 	movl   $0x11,0x4(%esp)
  800095:	00 
  800096:	c7 04 24 b5 2f 80 00 	movl   $0x802fb5,(%esp)
  80009d:	e8 e2 02 00 00       	call   800384 <_panic>

	if (pid == 0) {
  8000a2:	85 c0                	test   %eax,%eax
  8000a4:	0f 85 d5 00 00 00    	jne    80017f <umain+0x14b>
		cprintf("[%08x] pipereadeof close %d\n", env->env_id, p[1]);
  8000aa:	a1 78 70 80 00       	mov    0x807078,%eax
  8000af:	8b 40 4c             	mov    0x4c(%eax),%eax
  8000b2:	8b 55 90             	mov    -0x70(%ebp),%edx
  8000b5:	89 54 24 08          	mov    %edx,0x8(%esp)
  8000b9:	89 44 24 04          	mov    %eax,0x4(%esp)
  8000bd:	c7 04 24 ce 2f 80 00 	movl   $0x802fce,(%esp)
  8000c4:	e8 80 03 00 00       	call   800449 <cprintf>
		close(p[1]);
  8000c9:	8b 45 90             	mov    -0x70(%ebp),%eax
  8000cc:	89 04 24             	mov    %eax,(%esp)
  8000cf:	e8 6a 1b 00 00       	call   801c3e <close>
		cprintf("[%08x] pipereadeof readn %d\n", env->env_id, p[0]);
  8000d4:	a1 78 70 80 00       	mov    0x807078,%eax
  8000d9:	8b 40 4c             	mov    0x4c(%eax),%eax
  8000dc:	8b 55 8c             	mov    -0x74(%ebp),%edx
  8000df:	89 54 24 08          	mov    %edx,0x8(%esp)
  8000e3:	89 44 24 04          	mov    %eax,0x4(%esp)
  8000e7:	c7 04 24 eb 2f 80 00 	movl   $0x802feb,(%esp)
  8000ee:	e8 56 03 00 00       	call   800449 <cprintf>
		i = readn(p[0], buf, sizeof buf-1);
  8000f3:	c7 44 24 08 63 00 00 	movl   $0x63,0x8(%esp)
  8000fa:	00 
  8000fb:	8d 45 94             	lea    -0x6c(%ebp),%eax
  8000fe:	89 44 24 04          	mov    %eax,0x4(%esp)
  800102:	8b 45 8c             	mov    -0x74(%ebp),%eax
  800105:	89 04 24             	mov    %eax,(%esp)
  800108:	e8 5f 1a 00 00       	call   801b6c <readn>
  80010d:	89 c6                	mov    %eax,%esi
		if (i < 0)
  80010f:	85 c0                	test   %eax,%eax
  800111:	79 20                	jns    800133 <umain+0xff>
			panic("read: %e", i);
  800113:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800117:	c7 44 24 08 08 30 80 	movl   $0x803008,0x8(%esp)
  80011e:	00 
  80011f:	c7 44 24 04 19 00 00 	movl   $0x19,0x4(%esp)
  800126:	00 
  800127:	c7 04 24 b5 2f 80 00 	movl   $0x802fb5,(%esp)
  80012e:	e8 51 02 00 00       	call   800384 <_panic>
		buf[i] = 0;
  800133:	c6 44 05 94 00       	movb   $0x0,-0x6c(%ebp,%eax,1)
		if (strcmp(buf, msg) == 0)
  800138:	a1 00 70 80 00       	mov    0x807000,%eax
  80013d:	89 44 24 04          	mov    %eax,0x4(%esp)
  800141:	8d 45 94             	lea    -0x6c(%ebp),%eax
  800144:	89 04 24             	mov    %eax,(%esp)
  800147:	e8 4d 0a 00 00       	call   800b99 <strcmp>
  80014c:	85 c0                	test   %eax,%eax
  80014e:	75 0e                	jne    80015e <umain+0x12a>
			cprintf("\npipe read closed properly\n");
  800150:	c7 04 24 11 30 80 00 	movl   $0x803011,(%esp)
  800157:	e8 ed 02 00 00       	call   800449 <cprintf>
  80015c:	eb 17                	jmp    800175 <umain+0x141>
		else
			cprintf("\ngot %d bytes: %s\n", i, buf);
  80015e:	8d 45 94             	lea    -0x6c(%ebp),%eax
  800161:	89 44 24 08          	mov    %eax,0x8(%esp)
  800165:	89 74 24 04          	mov    %esi,0x4(%esp)
  800169:	c7 04 24 2d 30 80 00 	movl   $0x80302d,(%esp)
  800170:	e8 d4 02 00 00       	call   800449 <cprintf>
		exit();
  800175:	e8 ee 01 00 00       	call   800368 <exit>
  80017a:	e9 ac 00 00 00       	jmp    80022b <umain+0x1f7>
	} else {
		cprintf("[%08x] pipereadeof close %d\n", env->env_id, p[0]);
  80017f:	a1 78 70 80 00       	mov    0x807078,%eax
  800184:	8b 40 4c             	mov    0x4c(%eax),%eax
  800187:	8b 55 8c             	mov    -0x74(%ebp),%edx
  80018a:	89 54 24 08          	mov    %edx,0x8(%esp)
  80018e:	89 44 24 04          	mov    %eax,0x4(%esp)
  800192:	c7 04 24 ce 2f 80 00 	movl   $0x802fce,(%esp)
  800199:	e8 ab 02 00 00       	call   800449 <cprintf>
		close(p[0]);
  80019e:	8b 45 8c             	mov    -0x74(%ebp),%eax
  8001a1:	89 04 24             	mov    %eax,(%esp)
  8001a4:	e8 95 1a 00 00       	call   801c3e <close>
		cprintf("[%08x] pipereadeof write %d\n", env->env_id, p[1]);
  8001a9:	a1 78 70 80 00       	mov    0x807078,%eax
  8001ae:	8b 40 4c             	mov    0x4c(%eax),%eax
  8001b1:	8b 55 90             	mov    -0x70(%ebp),%edx
  8001b4:	89 54 24 08          	mov    %edx,0x8(%esp)
  8001b8:	89 44 24 04          	mov    %eax,0x4(%esp)
  8001bc:	c7 04 24 40 30 80 00 	movl   $0x803040,(%esp)
  8001c3:	e8 81 02 00 00       	call   800449 <cprintf>
		if ((i = write(p[1], msg, strlen(msg))) != strlen(msg))
  8001c8:	a1 00 70 80 00       	mov    0x807000,%eax
  8001cd:	89 04 24             	mov    %eax,(%esp)
  8001d0:	e8 eb 08 00 00       	call   800ac0 <strlen>
  8001d5:	89 44 24 08          	mov    %eax,0x8(%esp)
  8001d9:	a1 00 70 80 00       	mov    0x807000,%eax
  8001de:	89 44 24 04          	mov    %eax,0x4(%esp)
  8001e2:	8b 45 90             	mov    -0x70(%ebp),%eax
  8001e5:	89 04 24             	mov    %eax,(%esp)
  8001e8:	e8 68 18 00 00       	call   801a55 <write>
  8001ed:	89 c6                	mov    %eax,%esi
  8001ef:	a1 00 70 80 00       	mov    0x807000,%eax
  8001f4:	89 04 24             	mov    %eax,(%esp)
  8001f7:	e8 c4 08 00 00       	call   800ac0 <strlen>
  8001fc:	39 c6                	cmp    %eax,%esi
  8001fe:	74 20                	je     800220 <umain+0x1ec>
			panic("write: %e", i);
  800200:	89 74 24 0c          	mov    %esi,0xc(%esp)
  800204:	c7 44 24 08 5d 30 80 	movl   $0x80305d,0x8(%esp)
  80020b:	00 
  80020c:	c7 44 24 04 25 00 00 	movl   $0x25,0x4(%esp)
  800213:	00 
  800214:	c7 04 24 b5 2f 80 00 	movl   $0x802fb5,(%esp)
  80021b:	e8 64 01 00 00       	call   800384 <_panic>
		close(p[1]);
  800220:	8b 45 90             	mov    -0x70(%ebp),%eax
  800223:	89 04 24             	mov    %eax,(%esp)
  800226:	e8 13 1a 00 00       	call   801c3e <close>
	}
	wait(pid);
  80022b:	89 1c 24             	mov    %ebx,(%esp)
  80022e:	e8 f1 26 00 00       	call   802924 <wait>

	argv0 = "pipewriteeof";
  800233:	c7 05 7c 70 80 00 67 	movl   $0x803067,0x80707c
  80023a:	30 80 00 
	if ((i = pipe(p)) < 0)
  80023d:	8d 45 8c             	lea    -0x74(%ebp),%eax
  800240:	89 04 24             	mov    %eax,(%esp)
  800243:	e8 61 25 00 00       	call   8027a9 <pipe>
  800248:	89 c6                	mov    %eax,%esi
  80024a:	85 c0                	test   %eax,%eax
  80024c:	79 20                	jns    80026e <umain+0x23a>
		panic("pipe: %e", i);
  80024e:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800252:	c7 44 24 08 ac 2f 80 	movl   $0x802fac,0x8(%esp)
  800259:	00 
  80025a:	c7 44 24 04 2c 00 00 	movl   $0x2c,0x4(%esp)
  800261:	00 
  800262:	c7 04 24 b5 2f 80 00 	movl   $0x802fb5,(%esp)
  800269:	e8 16 01 00 00       	call   800384 <_panic>

	if ((pid = fork()) < 0)
  80026e:	e8 12 13 00 00       	call   801585 <fork>
  800273:	89 c3                	mov    %eax,%ebx
  800275:	85 c0                	test   %eax,%eax
  800277:	79 20                	jns    800299 <umain+0x265>
		panic("fork: %e", i);
  800279:	89 74 24 0c          	mov    %esi,0xc(%esp)
  80027d:	c7 44 24 08 c5 2f 80 	movl   $0x802fc5,0x8(%esp)
  800284:	00 
  800285:	c7 44 24 04 2f 00 00 	movl   $0x2f,0x4(%esp)
  80028c:	00 
  80028d:	c7 04 24 b5 2f 80 00 	movl   $0x802fb5,(%esp)
  800294:	e8 eb 00 00 00       	call   800384 <_panic>

	if (pid == 0) {
  800299:	85 c0                	test   %eax,%eax
  80029b:	75 48                	jne    8002e5 <umain+0x2b1>
		close(p[0]);
  80029d:	8b 45 8c             	mov    -0x74(%ebp),%eax
  8002a0:	89 04 24             	mov    %eax,(%esp)
  8002a3:	e8 96 19 00 00       	call   801c3e <close>
		while (1) {
			cprintf(".");
  8002a8:	c7 04 24 74 30 80 00 	movl   $0x803074,(%esp)
  8002af:	e8 95 01 00 00       	call   800449 <cprintf>
			if (write(p[1], "x", 1) != 1)
  8002b4:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  8002bb:	00 
  8002bc:	c7 44 24 04 76 30 80 	movl   $0x803076,0x4(%esp)
  8002c3:	00 
  8002c4:	8b 45 90             	mov    -0x70(%ebp),%eax
  8002c7:	89 04 24             	mov    %eax,(%esp)
  8002ca:	e8 86 17 00 00       	call   801a55 <write>
  8002cf:	83 f8 01             	cmp    $0x1,%eax
  8002d2:	74 d4                	je     8002a8 <umain+0x274>
				break;
		}
		cprintf("\npipe write closed properly\n");
  8002d4:	c7 04 24 78 30 80 00 	movl   $0x803078,(%esp)
  8002db:	e8 69 01 00 00       	call   800449 <cprintf>
		exit();
  8002e0:	e8 83 00 00 00       	call   800368 <exit>
	}
	close(p[0]);
  8002e5:	8b 45 8c             	mov    -0x74(%ebp),%eax
  8002e8:	89 04 24             	mov    %eax,(%esp)
  8002eb:	e8 4e 19 00 00       	call   801c3e <close>
	close(p[1]);
  8002f0:	8b 45 90             	mov    -0x70(%ebp),%eax
  8002f3:	89 04 24             	mov    %eax,(%esp)
  8002f6:	e8 43 19 00 00       	call   801c3e <close>
	wait(pid);
  8002fb:	89 1c 24             	mov    %ebx,(%esp)
  8002fe:	e8 21 26 00 00       	call   802924 <wait>

	cprintf("pipe tests passed\n");
  800303:	c7 04 24 95 30 80 00 	movl   $0x803095,(%esp)
  80030a:	e8 3a 01 00 00       	call   800449 <cprintf>
}
  80030f:	83 ec 80             	sub    $0xffffff80,%esp
  800312:	5b                   	pop    %ebx
  800313:	5e                   	pop    %esi
  800314:	5d                   	pop    %ebp
  800315:	c3                   	ret    
	...

00800318 <libmain>:
volatile struct Env *env;
char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  800318:	55                   	push   %ebp
  800319:	89 e5                	mov    %esp,%ebp
  80031b:	83 ec 18             	sub    $0x18,%esp
  80031e:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  800321:	89 75 fc             	mov    %esi,-0x4(%ebp)
  800324:	8b 75 08             	mov    0x8(%ebp),%esi
  800327:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	// set env to point at our env structure in envs[].
	// LAB 3b: Your code here.
	// Code added by Swastika / Sandeep	
	envid_t envid = sys_getenvid();
  80032a:	e8 5f 10 00 00       	call   80138e <sys_getenvid>
	env = &envs[ENVX(envid)];
  80032f:	25 ff 03 00 00       	and    $0x3ff,%eax
  800334:	6b c0 7c             	imul   $0x7c,%eax,%eax
  800337:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  80033c:	a3 78 70 80 00       	mov    %eax,0x807078

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800341:	85 f6                	test   %esi,%esi
  800343:	7e 07                	jle    80034c <libmain+0x34>
		binaryname = argv[0];
  800345:	8b 03                	mov    (%ebx),%eax
  800347:	a3 04 70 80 00       	mov    %eax,0x807004

	// call user main routine
	umain(argc, argv);
  80034c:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  800350:	89 34 24             	mov    %esi,(%esp)
  800353:	e8 dc fc ff ff       	call   800034 <umain>

	// exit gracefully
	exit();
  800358:	e8 0b 00 00 00       	call   800368 <exit>
}
  80035d:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  800360:	8b 75 fc             	mov    -0x4(%ebp),%esi
  800363:	89 ec                	mov    %ebp,%esp
  800365:	5d                   	pop    %ebp
  800366:	c3                   	ret    
	...

00800368 <exit>:
#include <inc/lib.h>

void
exit(void)
{
  800368:	55                   	push   %ebp
  800369:	89 e5                	mov    %esp,%ebp
  80036b:	83 ec 18             	sub    $0x18,%esp
	close_all();
  80036e:	e8 48 19 00 00       	call   801cbb <close_all>
	sys_env_destroy(0);
  800373:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80037a:	e8 43 10 00 00       	call   8013c2 <sys_env_destroy>
}
  80037f:	c9                   	leave  
  800380:	c3                   	ret    
  800381:	00 00                	add    %al,(%eax)
	...

00800384 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  800384:	55                   	push   %ebp
  800385:	89 e5                	mov    %esp,%ebp
  800387:	53                   	push   %ebx
  800388:	83 ec 14             	sub    $0x14,%esp
 * Panic is called on unresolvable fatal errors.
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
  80038b:	8d 5d 14             	lea    0x14(%ebp),%ebx
	va_list ap;

	va_start(ap, fmt);

	// Print the panic message
	if (argv0)
  80038e:	a1 7c 70 80 00       	mov    0x80707c,%eax
  800393:	85 c0                	test   %eax,%eax
  800395:	74 10                	je     8003a7 <_panic+0x23>
		cprintf("%s: ", argv0);
  800397:	89 44 24 04          	mov    %eax,0x4(%esp)
  80039b:	c7 04 24 03 31 80 00 	movl   $0x803103,(%esp)
  8003a2:	e8 a2 00 00 00       	call   800449 <cprintf>
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  8003a7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8003aa:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8003ae:	8b 45 08             	mov    0x8(%ebp),%eax
  8003b1:	89 44 24 08          	mov    %eax,0x8(%esp)
  8003b5:	a1 04 70 80 00       	mov    0x807004,%eax
  8003ba:	89 44 24 04          	mov    %eax,0x4(%esp)
  8003be:	c7 04 24 08 31 80 00 	movl   $0x803108,(%esp)
  8003c5:	e8 7f 00 00 00       	call   800449 <cprintf>
	vcprintf(fmt, ap);
  8003ca:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8003ce:	8b 45 10             	mov    0x10(%ebp),%eax
  8003d1:	89 04 24             	mov    %eax,(%esp)
  8003d4:	e8 0f 00 00 00       	call   8003e8 <vcprintf>
	cprintf("\n");
  8003d9:	c7 04 24 e9 2f 80 00 	movl   $0x802fe9,(%esp)
  8003e0:	e8 64 00 00 00       	call   800449 <cprintf>

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  8003e5:	cc                   	int3   
  8003e6:	eb fd                	jmp    8003e5 <_panic+0x61>

008003e8 <vcprintf>:
	b->cnt++;
}

int
vcprintf(const char *fmt, va_list ap)
{
  8003e8:	55                   	push   %ebp
  8003e9:	89 e5                	mov    %esp,%ebp
  8003eb:	81 ec 28 01 00 00    	sub    $0x128,%esp
	struct printbuf b;

	b.idx = 0;
  8003f1:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8003f8:	00 00 00 
	b.cnt = 0;
  8003fb:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800402:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  800405:	8b 45 0c             	mov    0xc(%ebp),%eax
  800408:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80040c:	8b 45 08             	mov    0x8(%ebp),%eax
  80040f:	89 44 24 08          	mov    %eax,0x8(%esp)
  800413:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800419:	89 44 24 04          	mov    %eax,0x4(%esp)
  80041d:	c7 04 24 63 04 80 00 	movl   $0x800463,(%esp)
  800424:	e8 d4 01 00 00       	call   8005fd <vprintfmt>
	sys_cputs(b.buf, b.idx);
  800429:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
  80042f:	89 44 24 04          	mov    %eax,0x4(%esp)
  800433:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  800439:	89 04 24             	mov    %eax,(%esp)
  80043c:	e8 bf 0a 00 00       	call   800f00 <sys_cputs>

	return b.cnt;
}
  800441:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  800447:	c9                   	leave  
  800448:	c3                   	ret    

00800449 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  800449:	55                   	push   %ebp
  80044a:	89 e5                	mov    %esp,%ebp
  80044c:	83 ec 18             	sub    $0x18,%esp

	return b.cnt;
}

int
cprintf(const char *fmt, ...)
  80044f:	8d 45 0c             	lea    0xc(%ebp),%eax
{
	va_list ap;
	int cnt;

	va_start(ap, fmt);
	cnt = vcprintf(fmt, ap);
  800452:	89 44 24 04          	mov    %eax,0x4(%esp)
  800456:	8b 45 08             	mov    0x8(%ebp),%eax
  800459:	89 04 24             	mov    %eax,(%esp)
  80045c:	e8 87 ff ff ff       	call   8003e8 <vcprintf>
	va_end(ap);

	return cnt;
}
  800461:	c9                   	leave  
  800462:	c3                   	ret    

00800463 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  800463:	55                   	push   %ebp
  800464:	89 e5                	mov    %esp,%ebp
  800466:	53                   	push   %ebx
  800467:	83 ec 14             	sub    $0x14,%esp
  80046a:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  80046d:	8b 03                	mov    (%ebx),%eax
  80046f:	8b 55 08             	mov    0x8(%ebp),%edx
  800472:	88 54 03 08          	mov    %dl,0x8(%ebx,%eax,1)
  800476:	83 c0 01             	add    $0x1,%eax
  800479:	89 03                	mov    %eax,(%ebx)
	if (b->idx == 256-1) {
  80047b:	3d ff 00 00 00       	cmp    $0xff,%eax
  800480:	75 19                	jne    80049b <putch+0x38>
		sys_cputs(b->buf, b->idx);
  800482:	c7 44 24 04 ff 00 00 	movl   $0xff,0x4(%esp)
  800489:	00 
  80048a:	8d 43 08             	lea    0x8(%ebx),%eax
  80048d:	89 04 24             	mov    %eax,(%esp)
  800490:	e8 6b 0a 00 00       	call   800f00 <sys_cputs>
		b->idx = 0;
  800495:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
	}
	b->cnt++;
  80049b:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  80049f:	83 c4 14             	add    $0x14,%esp
  8004a2:	5b                   	pop    %ebx
  8004a3:	5d                   	pop    %ebp
  8004a4:	c3                   	ret    
	...

008004b0 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8004b0:	55                   	push   %ebp
  8004b1:	89 e5                	mov    %esp,%ebp
  8004b3:	57                   	push   %edi
  8004b4:	56                   	push   %esi
  8004b5:	53                   	push   %ebx
  8004b6:	83 ec 4c             	sub    $0x4c,%esp
  8004b9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8004bc:	89 d6                	mov    %edx,%esi
  8004be:	8b 45 08             	mov    0x8(%ebp),%eax
  8004c1:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8004c4:	8b 55 0c             	mov    0xc(%ebp),%edx
  8004c7:	89 55 e0             	mov    %edx,-0x20(%ebp)
  8004ca:	8b 45 10             	mov    0x10(%ebp),%eax
  8004cd:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8004d0:	8b 7d 18             	mov    0x18(%ebp),%edi
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8004d3:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8004d6:	b9 00 00 00 00       	mov    $0x0,%ecx
  8004db:	39 d1                	cmp    %edx,%ecx
  8004dd:	72 15                	jb     8004f4 <printnum+0x44>
  8004df:	77 07                	ja     8004e8 <printnum+0x38>
  8004e1:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8004e4:	39 d0                	cmp    %edx,%eax
  8004e6:	76 0c                	jbe    8004f4 <printnum+0x44>
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8004e8:	83 eb 01             	sub    $0x1,%ebx
  8004eb:	85 db                	test   %ebx,%ebx
  8004ed:	8d 76 00             	lea    0x0(%esi),%esi
  8004f0:	7f 61                	jg     800553 <printnum+0xa3>
  8004f2:	eb 70                	jmp    800564 <printnum+0xb4>
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8004f4:	89 7c 24 10          	mov    %edi,0x10(%esp)
  8004f8:	83 eb 01             	sub    $0x1,%ebx
  8004fb:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  8004ff:	89 44 24 08          	mov    %eax,0x8(%esp)
  800503:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  800507:	8b 5c 24 0c          	mov    0xc(%esp),%ebx
  80050b:	89 4d d0             	mov    %ecx,-0x30(%ebp)
  80050e:	89 5d d4             	mov    %ebx,-0x2c(%ebp)
  800511:	8b 5d dc             	mov    -0x24(%ebp),%ebx
  800514:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  800518:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  80051f:	00 
  800520:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800523:	89 04 24             	mov    %eax,(%esp)
  800526:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800529:	89 54 24 04          	mov    %edx,0x4(%esp)
  80052d:	e8 ee 27 00 00       	call   802d20 <__udivdi3>
  800532:	8b 4d d0             	mov    -0x30(%ebp),%ecx
  800535:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
  800538:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  80053c:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  800540:	89 04 24             	mov    %eax,(%esp)
  800543:	89 54 24 04          	mov    %edx,0x4(%esp)
  800547:	89 f2                	mov    %esi,%edx
  800549:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80054c:	e8 5f ff ff ff       	call   8004b0 <printnum>
  800551:	eb 11                	jmp    800564 <printnum+0xb4>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800553:	89 74 24 04          	mov    %esi,0x4(%esp)
  800557:	89 3c 24             	mov    %edi,(%esp)
  80055a:	ff 55 e4             	call   *-0x1c(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  80055d:	83 eb 01             	sub    $0x1,%ebx
  800560:	85 db                	test   %ebx,%ebx
  800562:	7f ef                	jg     800553 <printnum+0xa3>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800564:	89 74 24 04          	mov    %esi,0x4(%esp)
  800568:	8b 74 24 04          	mov    0x4(%esp),%esi
  80056c:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80056f:	89 44 24 08          	mov    %eax,0x8(%esp)
  800573:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  80057a:	00 
  80057b:	8b 55 d8             	mov    -0x28(%ebp),%edx
  80057e:	89 14 24             	mov    %edx,(%esp)
  800581:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  800584:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  800588:	e8 c3 28 00 00       	call   802e50 <__umoddi3>
  80058d:	89 74 24 04          	mov    %esi,0x4(%esp)
  800591:	0f be 80 24 31 80 00 	movsbl 0x803124(%eax),%eax
  800598:	89 04 24             	mov    %eax,(%esp)
  80059b:	ff 55 e4             	call   *-0x1c(%ebp)
}
  80059e:	83 c4 4c             	add    $0x4c,%esp
  8005a1:	5b                   	pop    %ebx
  8005a2:	5e                   	pop    %esi
  8005a3:	5f                   	pop    %edi
  8005a4:	5d                   	pop    %ebp
  8005a5:	c3                   	ret    

008005a6 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  8005a6:	55                   	push   %ebp
  8005a7:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8005a9:	83 fa 01             	cmp    $0x1,%edx
  8005ac:	7e 0e                	jle    8005bc <getuint+0x16>
		return va_arg(*ap, unsigned long long);
  8005ae:	8b 10                	mov    (%eax),%edx
  8005b0:	8d 4a 08             	lea    0x8(%edx),%ecx
  8005b3:	89 08                	mov    %ecx,(%eax)
  8005b5:	8b 02                	mov    (%edx),%eax
  8005b7:	8b 52 04             	mov    0x4(%edx),%edx
  8005ba:	eb 22                	jmp    8005de <getuint+0x38>
	else if (lflag)
  8005bc:	85 d2                	test   %edx,%edx
  8005be:	74 10                	je     8005d0 <getuint+0x2a>
		return va_arg(*ap, unsigned long);
  8005c0:	8b 10                	mov    (%eax),%edx
  8005c2:	8d 4a 04             	lea    0x4(%edx),%ecx
  8005c5:	89 08                	mov    %ecx,(%eax)
  8005c7:	8b 02                	mov    (%edx),%eax
  8005c9:	ba 00 00 00 00       	mov    $0x0,%edx
  8005ce:	eb 0e                	jmp    8005de <getuint+0x38>
	else
		return va_arg(*ap, unsigned int);
  8005d0:	8b 10                	mov    (%eax),%edx
  8005d2:	8d 4a 04             	lea    0x4(%edx),%ecx
  8005d5:	89 08                	mov    %ecx,(%eax)
  8005d7:	8b 02                	mov    (%edx),%eax
  8005d9:	ba 00 00 00 00       	mov    $0x0,%edx
}
  8005de:	5d                   	pop    %ebp
  8005df:	c3                   	ret    

008005e0 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8005e0:	55                   	push   %ebp
  8005e1:	89 e5                	mov    %esp,%ebp
  8005e3:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  8005e6:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  8005ea:	8b 10                	mov    (%eax),%edx
  8005ec:	3b 50 04             	cmp    0x4(%eax),%edx
  8005ef:	73 0a                	jae    8005fb <sprintputch+0x1b>
		*b->buf++ = ch;
  8005f1:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8005f4:	88 0a                	mov    %cl,(%edx)
  8005f6:	83 c2 01             	add    $0x1,%edx
  8005f9:	89 10                	mov    %edx,(%eax)
}
  8005fb:	5d                   	pop    %ebp
  8005fc:	c3                   	ret    

008005fd <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  8005fd:	55                   	push   %ebp
  8005fe:	89 e5                	mov    %esp,%ebp
  800600:	57                   	push   %edi
  800601:	56                   	push   %esi
  800602:	53                   	push   %ebx
  800603:	83 ec 5c             	sub    $0x5c,%esp
  800606:	8b 7d 08             	mov    0x8(%ebp),%edi
  800609:	8b 75 0c             	mov    0xc(%ebp),%esi
  80060c:	8b 5d 10             	mov    0x10(%ebp),%ebx
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  80060f:	c7 45 c8 ff ff ff ff 	movl   $0xffffffff,-0x38(%ebp)
  800616:	eb 11                	jmp    800629 <vprintfmt+0x2c>
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
  800618:	85 c0                	test   %eax,%eax
  80061a:	0f 84 ec 03 00 00    	je     800a0c <vprintfmt+0x40f>
				return;
			putch(ch, putdat);
  800620:	89 74 24 04          	mov    %esi,0x4(%esp)
  800624:	89 04 24             	mov    %eax,(%esp)
  800627:	ff d7                	call   *%edi
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800629:	0f b6 03             	movzbl (%ebx),%eax
  80062c:	83 c3 01             	add    $0x1,%ebx
  80062f:	83 f8 25             	cmp    $0x25,%eax
  800632:	75 e4                	jne    800618 <vprintfmt+0x1b>
  800634:	c6 45 d4 20          	movb   $0x20,-0x2c(%ebp)
  800638:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
  80063f:	c7 45 d0 ff ff ff ff 	movl   $0xffffffff,-0x30(%ebp)
  800646:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
  80064d:	b9 00 00 00 00       	mov    $0x0,%ecx
  800652:	eb 06                	jmp    80065a <vprintfmt+0x5d>
  800654:	c6 45 d4 2d          	movb   $0x2d,-0x2c(%ebp)
  800658:	89 c3                	mov    %eax,%ebx
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80065a:	0f b6 13             	movzbl (%ebx),%edx
  80065d:	0f b6 c2             	movzbl %dl,%eax
  800660:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800663:	8d 43 01             	lea    0x1(%ebx),%eax
  800666:	83 ea 23             	sub    $0x23,%edx
  800669:	80 fa 55             	cmp    $0x55,%dl
  80066c:	0f 87 7d 03 00 00    	ja     8009ef <vprintfmt+0x3f2>
  800672:	0f b6 d2             	movzbl %dl,%edx
  800675:	ff 24 95 60 32 80 00 	jmp    *0x803260(,%edx,4)
  80067c:	c6 45 d4 30          	movb   $0x30,-0x2c(%ebp)
  800680:	eb d6                	jmp    800658 <vprintfmt+0x5b>
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
				precision = precision * 10 + ch - '0';
  800682:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800685:	83 ea 30             	sub    $0x30,%edx
  800688:	89 55 d0             	mov    %edx,-0x30(%ebp)
				ch = *fmt;
  80068b:	0f be 10             	movsbl (%eax),%edx
				if (ch < '0' || ch > '9')
  80068e:	8d 5a d0             	lea    -0x30(%edx),%ebx
  800691:	83 fb 09             	cmp    $0x9,%ebx
  800694:	77 4c                	ja     8006e2 <vprintfmt+0xe5>
  800696:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  800699:	8b 4d d0             	mov    -0x30(%ebp),%ecx
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  80069c:	83 c0 01             	add    $0x1,%eax
				precision = precision * 10 + ch - '0';
  80069f:	8d 0c 89             	lea    (%ecx,%ecx,4),%ecx
  8006a2:	8d 4c 4a d0          	lea    -0x30(%edx,%ecx,2),%ecx
				ch = *fmt;
  8006a6:	0f be 10             	movsbl (%eax),%edx
				if (ch < '0' || ch > '9')
  8006a9:	8d 5a d0             	lea    -0x30(%edx),%ebx
  8006ac:	83 fb 09             	cmp    $0x9,%ebx
  8006af:	76 eb                	jbe    80069c <vprintfmt+0x9f>
  8006b1:	89 4d d0             	mov    %ecx,-0x30(%ebp)
  8006b4:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  8006b7:	eb 29                	jmp    8006e2 <vprintfmt+0xe5>
					break;
			}
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  8006b9:	8b 55 14             	mov    0x14(%ebp),%edx
  8006bc:	8d 5a 04             	lea    0x4(%edx),%ebx
  8006bf:	89 5d 14             	mov    %ebx,0x14(%ebp)
  8006c2:	8b 12                	mov    (%edx),%edx
  8006c4:	89 55 d0             	mov    %edx,-0x30(%ebp)
			goto process_precision;
  8006c7:	eb 19                	jmp    8006e2 <vprintfmt+0xe5>

		case '.':
			if (width < 0)
  8006c9:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8006cc:	c1 fa 1f             	sar    $0x1f,%edx
  8006cf:	f7 d2                	not    %edx
  8006d1:	21 55 e4             	and    %edx,-0x1c(%ebp)
  8006d4:	eb 82                	jmp    800658 <vprintfmt+0x5b>
  8006d6:	c7 45 d8 01 00 00 00 	movl   $0x1,-0x28(%ebp)
				width = 0;
			goto reswitch;

		case '#':
			altflag = 1;
			goto reswitch;
  8006dd:	e9 76 ff ff ff       	jmp    800658 <vprintfmt+0x5b>

		process_precision:
			if (width < 0)
  8006e2:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8006e6:	0f 89 6c ff ff ff    	jns    800658 <vprintfmt+0x5b>
  8006ec:	8b 55 d0             	mov    -0x30(%ebp),%edx
  8006ef:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  8006f2:	8b 55 c8             	mov    -0x38(%ebp),%edx
  8006f5:	89 55 d0             	mov    %edx,-0x30(%ebp)
  8006f8:	e9 5b ff ff ff       	jmp    800658 <vprintfmt+0x5b>
				width = precision, precision = -1;
			goto reswitch;

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  8006fd:	83 c1 01             	add    $0x1,%ecx
			goto reswitch;
  800700:	e9 53 ff ff ff       	jmp    800658 <vprintfmt+0x5b>
  800705:	89 45 cc             	mov    %eax,-0x34(%ebp)

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800708:	8b 45 14             	mov    0x14(%ebp),%eax
  80070b:	8d 50 04             	lea    0x4(%eax),%edx
  80070e:	89 55 14             	mov    %edx,0x14(%ebp)
  800711:	89 74 24 04          	mov    %esi,0x4(%esp)
  800715:	8b 00                	mov    (%eax),%eax
  800717:	89 04 24             	mov    %eax,(%esp)
  80071a:	ff d7                	call   *%edi
  80071c:	8b 5d cc             	mov    -0x34(%ebp),%ebx
			break;
  80071f:	e9 05 ff ff ff       	jmp    800629 <vprintfmt+0x2c>
  800724:	89 45 cc             	mov    %eax,-0x34(%ebp)

		// error message
		case 'e':
			err = va_arg(ap, int);
  800727:	8b 45 14             	mov    0x14(%ebp),%eax
  80072a:	8d 50 04             	lea    0x4(%eax),%edx
  80072d:	89 55 14             	mov    %edx,0x14(%ebp)
  800730:	8b 00                	mov    (%eax),%eax
  800732:	89 c2                	mov    %eax,%edx
  800734:	c1 fa 1f             	sar    $0x1f,%edx
  800737:	31 d0                	xor    %edx,%eax
  800739:	29 d0                	sub    %edx,%eax
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  80073b:	83 f8 0f             	cmp    $0xf,%eax
  80073e:	7f 0b                	jg     80074b <vprintfmt+0x14e>
  800740:	8b 14 85 c0 33 80 00 	mov    0x8033c0(,%eax,4),%edx
  800747:	85 d2                	test   %edx,%edx
  800749:	75 20                	jne    80076b <vprintfmt+0x16e>
				printfmt(putch, putdat, "error %d", err);
  80074b:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80074f:	c7 44 24 08 35 31 80 	movl   $0x803135,0x8(%esp)
  800756:	00 
  800757:	89 74 24 04          	mov    %esi,0x4(%esp)
  80075b:	89 3c 24             	mov    %edi,(%esp)
  80075e:	e8 31 03 00 00       	call   800a94 <printfmt>
  800763:	8b 5d cc             	mov    -0x34(%ebp),%ebx
		// error message
		case 'e':
			err = va_arg(ap, int);
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800766:	e9 be fe ff ff       	jmp    800629 <vprintfmt+0x2c>
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  80076b:	89 54 24 0c          	mov    %edx,0xc(%esp)
  80076f:	c7 44 24 08 f6 36 80 	movl   $0x8036f6,0x8(%esp)
  800776:	00 
  800777:	89 74 24 04          	mov    %esi,0x4(%esp)
  80077b:	89 3c 24             	mov    %edi,(%esp)
  80077e:	e8 11 03 00 00       	call   800a94 <printfmt>
  800783:	8b 5d cc             	mov    -0x34(%ebp),%ebx
  800786:	e9 9e fe ff ff       	jmp    800629 <vprintfmt+0x2c>
  80078b:	89 45 cc             	mov    %eax,-0x34(%ebp)
  80078e:	89 c3                	mov    %eax,%ebx
  800790:	8b 4d d0             	mov    -0x30(%ebp),%ecx
  800793:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800796:	89 45 c4             	mov    %eax,-0x3c(%ebp)
			break;

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800799:	8b 45 14             	mov    0x14(%ebp),%eax
  80079c:	8d 50 04             	lea    0x4(%eax),%edx
  80079f:	89 55 14             	mov    %edx,0x14(%ebp)
  8007a2:	8b 00                	mov    (%eax),%eax
  8007a4:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8007a7:	85 c0                	test   %eax,%eax
  8007a9:	75 07                	jne    8007b2 <vprintfmt+0x1b5>
  8007ab:	c7 45 e0 3e 31 80 00 	movl   $0x80313e,-0x20(%ebp)
				p = "(null)";
			if (width > 0 && padc != '-')
  8007b2:	83 7d c4 00          	cmpl   $0x0,-0x3c(%ebp)
  8007b6:	7e 06                	jle    8007be <vprintfmt+0x1c1>
  8007b8:	80 7d d4 2d          	cmpb   $0x2d,-0x2c(%ebp)
  8007bc:	75 13                	jne    8007d1 <vprintfmt+0x1d4>
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8007be:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8007c1:	0f be 02             	movsbl (%edx),%eax
  8007c4:	85 c0                	test   %eax,%eax
  8007c6:	0f 85 99 00 00 00    	jne    800865 <vprintfmt+0x268>
  8007cc:	e9 86 00 00 00       	jmp    800857 <vprintfmt+0x25a>
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  8007d1:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8007d5:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  8007d8:	89 0c 24             	mov    %ecx,(%esp)
  8007db:	e8 fb 02 00 00       	call   800adb <strnlen>
  8007e0:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  8007e3:	29 c2                	sub    %eax,%edx
  8007e5:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  8007e8:	85 d2                	test   %edx,%edx
  8007ea:	7e d2                	jle    8007be <vprintfmt+0x1c1>
					putch(padc, putdat);
  8007ec:	0f be 4d d4          	movsbl -0x2c(%ebp),%ecx
  8007f0:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  8007f3:	89 5d c4             	mov    %ebx,-0x3c(%ebp)
  8007f6:	89 d3                	mov    %edx,%ebx
  8007f8:	89 74 24 04          	mov    %esi,0x4(%esp)
  8007fc:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8007ff:	89 04 24             	mov    %eax,(%esp)
  800802:	ff d7                	call   *%edi
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800804:	83 eb 01             	sub    $0x1,%ebx
  800807:	85 db                	test   %ebx,%ebx
  800809:	7f ed                	jg     8007f8 <vprintfmt+0x1fb>
  80080b:	8b 5d c4             	mov    -0x3c(%ebp),%ebx
  80080e:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  800815:	eb a7                	jmp    8007be <vprintfmt+0x1c1>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
  800817:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  80081b:	74 18                	je     800835 <vprintfmt+0x238>
  80081d:	8d 50 e0             	lea    -0x20(%eax),%edx
  800820:	83 fa 5e             	cmp    $0x5e,%edx
  800823:	76 10                	jbe    800835 <vprintfmt+0x238>
					putch('?', putdat);
  800825:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800829:	c7 04 24 3f 00 00 00 	movl   $0x3f,(%esp)
  800830:	ff 55 e0             	call   *-0x20(%ebp)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
  800833:	eb 0a                	jmp    80083f <vprintfmt+0x242>
					putch('?', putdat);
				else
					putch(ch, putdat);
  800835:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800839:	89 04 24             	mov    %eax,(%esp)
  80083c:	ff 55 e0             	call   *-0x20(%ebp)
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  80083f:	83 6d e4 01          	subl   $0x1,-0x1c(%ebp)
  800843:	0f be 03             	movsbl (%ebx),%eax
  800846:	85 c0                	test   %eax,%eax
  800848:	74 05                	je     80084f <vprintfmt+0x252>
  80084a:	83 c3 01             	add    $0x1,%ebx
  80084d:	eb 29                	jmp    800878 <vprintfmt+0x27b>
  80084f:	89 fe                	mov    %edi,%esi
  800851:	8b 7d e0             	mov    -0x20(%ebp),%edi
  800854:	8b 5d d0             	mov    -0x30(%ebp),%ebx
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800857:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80085b:	7f 2e                	jg     80088b <vprintfmt+0x28e>
  80085d:	8b 5d cc             	mov    -0x34(%ebp),%ebx
  800860:	e9 c4 fd ff ff       	jmp    800629 <vprintfmt+0x2c>
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800865:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800868:	83 c2 01             	add    $0x1,%edx
  80086b:	89 7d e0             	mov    %edi,-0x20(%ebp)
  80086e:	89 f7                	mov    %esi,%edi
  800870:	8b 75 d0             	mov    -0x30(%ebp),%esi
  800873:	89 5d d0             	mov    %ebx,-0x30(%ebp)
  800876:	89 d3                	mov    %edx,%ebx
  800878:	85 f6                	test   %esi,%esi
  80087a:	78 9b                	js     800817 <vprintfmt+0x21a>
  80087c:	83 ee 01             	sub    $0x1,%esi
  80087f:	79 96                	jns    800817 <vprintfmt+0x21a>
  800881:	89 fe                	mov    %edi,%esi
  800883:	8b 7d e0             	mov    -0x20(%ebp),%edi
  800886:	8b 5d d0             	mov    -0x30(%ebp),%ebx
  800889:	eb cc                	jmp    800857 <vprintfmt+0x25a>
  80088b:	89 5d d8             	mov    %ebx,-0x28(%ebp)
  80088e:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
				putch(' ', putdat);
  800891:	89 74 24 04          	mov    %esi,0x4(%esp)
  800895:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  80089c:	ff d7                	call   *%edi
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  80089e:	83 eb 01             	sub    $0x1,%ebx
  8008a1:	85 db                	test   %ebx,%ebx
  8008a3:	7f ec                	jg     800891 <vprintfmt+0x294>
  8008a5:	8b 5d d8             	mov    -0x28(%ebp),%ebx
  8008a8:	e9 7c fd ff ff       	jmp    800629 <vprintfmt+0x2c>
  8008ad:	89 45 cc             	mov    %eax,-0x34(%ebp)
// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
	if (lflag >= 2)
  8008b0:	83 f9 01             	cmp    $0x1,%ecx
  8008b3:	7e 16                	jle    8008cb <vprintfmt+0x2ce>
		return va_arg(*ap, long long);
  8008b5:	8b 45 14             	mov    0x14(%ebp),%eax
  8008b8:	8d 50 08             	lea    0x8(%eax),%edx
  8008bb:	89 55 14             	mov    %edx,0x14(%ebp)
  8008be:	8b 10                	mov    (%eax),%edx
  8008c0:	8b 48 04             	mov    0x4(%eax),%ecx
  8008c3:	89 55 d8             	mov    %edx,-0x28(%ebp)
  8008c6:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  8008c9:	eb 32                	jmp    8008fd <vprintfmt+0x300>
	else if (lflag)
  8008cb:	85 c9                	test   %ecx,%ecx
  8008cd:	74 18                	je     8008e7 <vprintfmt+0x2ea>
		return va_arg(*ap, long);
  8008cf:	8b 45 14             	mov    0x14(%ebp),%eax
  8008d2:	8d 50 04             	lea    0x4(%eax),%edx
  8008d5:	89 55 14             	mov    %edx,0x14(%ebp)
  8008d8:	8b 00                	mov    (%eax),%eax
  8008da:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8008dd:	89 c1                	mov    %eax,%ecx
  8008df:	c1 f9 1f             	sar    $0x1f,%ecx
  8008e2:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  8008e5:	eb 16                	jmp    8008fd <vprintfmt+0x300>
	else
		return va_arg(*ap, int);
  8008e7:	8b 45 14             	mov    0x14(%ebp),%eax
  8008ea:	8d 50 04             	lea    0x4(%eax),%edx
  8008ed:	89 55 14             	mov    %edx,0x14(%ebp)
  8008f0:	8b 00                	mov    (%eax),%eax
  8008f2:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8008f5:	89 c2                	mov    %eax,%edx
  8008f7:	c1 fa 1f             	sar    $0x1f,%edx
  8008fa:	89 55 dc             	mov    %edx,-0x24(%ebp)
				putch(' ', putdat);
			break;

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  8008fd:	8b 4d d8             	mov    -0x28(%ebp),%ecx
  800900:	8b 5d dc             	mov    -0x24(%ebp),%ebx
  800903:	b8 0a 00 00 00       	mov    $0xa,%eax
			if ((long long) num < 0) {
  800908:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  80090c:	0f 89 9b 00 00 00    	jns    8009ad <vprintfmt+0x3b0>
				putch('-', putdat);
  800912:	89 74 24 04          	mov    %esi,0x4(%esp)
  800916:	c7 04 24 2d 00 00 00 	movl   $0x2d,(%esp)
  80091d:	ff d7                	call   *%edi
				num = -(long long) num;
  80091f:	8b 4d d8             	mov    -0x28(%ebp),%ecx
  800922:	8b 5d dc             	mov    -0x24(%ebp),%ebx
  800925:	f7 d9                	neg    %ecx
  800927:	83 d3 00             	adc    $0x0,%ebx
  80092a:	f7 db                	neg    %ebx
  80092c:	b8 0a 00 00 00       	mov    $0xa,%eax
  800931:	eb 7a                	jmp    8009ad <vprintfmt+0x3b0>
  800933:	89 45 cc             	mov    %eax,-0x34(%ebp)
			base = 10;
			goto number;

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800936:	89 ca                	mov    %ecx,%edx
  800938:	8d 45 14             	lea    0x14(%ebp),%eax
  80093b:	e8 66 fc ff ff       	call   8005a6 <getuint>
  800940:	89 c1                	mov    %eax,%ecx
  800942:	89 d3                	mov    %edx,%ebx
  800944:	b8 0a 00 00 00       	mov    $0xa,%eax
			base = 10;
			goto number;
  800949:	eb 62                	jmp    8009ad <vprintfmt+0x3b0>
  80094b:	89 45 cc             	mov    %eax,-0x34(%ebp)
		case 'o':
			// Replace this with your code.
			// putch('X', putdat);
			// putch('X', putdat);
			// putch('X', putdat);
			num = getuint(&ap, lflag);
  80094e:	89 ca                	mov    %ecx,%edx
  800950:	8d 45 14             	lea    0x14(%ebp),%eax
  800953:	e8 4e fc ff ff       	call   8005a6 <getuint>
  800958:	89 c1                	mov    %eax,%ecx
  80095a:	89 d3                	mov    %edx,%ebx
  80095c:	b8 08 00 00 00       	mov    $0x8,%eax
			base = 8;
			goto number;
  800961:	eb 4a                	jmp    8009ad <vprintfmt+0x3b0>
  800963:	89 45 cc             	mov    %eax,-0x34(%ebp)
			break;

		// pointer
		case 'p':
			putch('0', putdat);
  800966:	89 74 24 04          	mov    %esi,0x4(%esp)
  80096a:	c7 04 24 30 00 00 00 	movl   $0x30,(%esp)
  800971:	ff d7                	call   *%edi
			putch('x', putdat);
  800973:	89 74 24 04          	mov    %esi,0x4(%esp)
  800977:	c7 04 24 78 00 00 00 	movl   $0x78,(%esp)
  80097e:	ff d7                	call   *%edi
			num = (unsigned long long)
  800980:	8b 45 14             	mov    0x14(%ebp),%eax
  800983:	8d 50 04             	lea    0x4(%eax),%edx
  800986:	89 55 14             	mov    %edx,0x14(%ebp)
  800989:	8b 08                	mov    (%eax),%ecx
  80098b:	bb 00 00 00 00       	mov    $0x0,%ebx
  800990:	b8 10 00 00 00       	mov    $0x10,%eax
				(uintptr_t) va_arg(ap, void *);
			base = 16;
			goto number;
  800995:	eb 16                	jmp    8009ad <vprintfmt+0x3b0>
  800997:	89 45 cc             	mov    %eax,-0x34(%ebp)

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  80099a:	89 ca                	mov    %ecx,%edx
  80099c:	8d 45 14             	lea    0x14(%ebp),%eax
  80099f:	e8 02 fc ff ff       	call   8005a6 <getuint>
  8009a4:	89 c1                	mov    %eax,%ecx
  8009a6:	89 d3                	mov    %edx,%ebx
  8009a8:	b8 10 00 00 00       	mov    $0x10,%eax
			base = 16;
		number:
			printnum(putch, putdat, num, base, width, padc);
  8009ad:	0f be 55 d4          	movsbl -0x2c(%ebp),%edx
  8009b1:	89 54 24 10          	mov    %edx,0x10(%esp)
  8009b5:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8009b8:	89 54 24 0c          	mov    %edx,0xc(%esp)
  8009bc:	89 44 24 08          	mov    %eax,0x8(%esp)
  8009c0:	89 0c 24             	mov    %ecx,(%esp)
  8009c3:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8009c7:	89 f2                	mov    %esi,%edx
  8009c9:	89 f8                	mov    %edi,%eax
  8009cb:	e8 e0 fa ff ff       	call   8004b0 <printnum>
  8009d0:	8b 5d cc             	mov    -0x34(%ebp),%ebx
			break;
  8009d3:	e9 51 fc ff ff       	jmp    800629 <vprintfmt+0x2c>
  8009d8:	89 45 cc             	mov    %eax,-0x34(%ebp)
  8009db:	8b 55 e0             	mov    -0x20(%ebp),%edx

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  8009de:	89 74 24 04          	mov    %esi,0x4(%esp)
  8009e2:	89 14 24             	mov    %edx,(%esp)
  8009e5:	ff d7                	call   *%edi
  8009e7:	8b 5d cc             	mov    -0x34(%ebp),%ebx
			break;
  8009ea:	e9 3a fc ff ff       	jmp    800629 <vprintfmt+0x2c>
			
		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  8009ef:	89 74 24 04          	mov    %esi,0x4(%esp)
  8009f3:	c7 04 24 25 00 00 00 	movl   $0x25,(%esp)
  8009fa:	ff d7                	call   *%edi
			for (fmt--; fmt[-1] != '%'; fmt--)
  8009fc:	8d 43 ff             	lea    -0x1(%ebx),%eax
  8009ff:	80 38 25             	cmpb   $0x25,(%eax)
  800a02:	0f 84 21 fc ff ff    	je     800629 <vprintfmt+0x2c>
  800a08:	89 c3                	mov    %eax,%ebx
  800a0a:	eb f0                	jmp    8009fc <vprintfmt+0x3ff>
				/* do nothing */;
			break;
		}
	}
}
  800a0c:	83 c4 5c             	add    $0x5c,%esp
  800a0f:	5b                   	pop    %ebx
  800a10:	5e                   	pop    %esi
  800a11:	5f                   	pop    %edi
  800a12:	5d                   	pop    %ebp
  800a13:	c3                   	ret    

00800a14 <vsnprintf>:
		*b->buf++ = ch;
}

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800a14:	55                   	push   %ebp
  800a15:	89 e5                	mov    %esp,%ebp
  800a17:	83 ec 28             	sub    $0x28,%esp
  800a1a:	8b 45 08             	mov    0x8(%ebp),%eax
  800a1d:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};

	if (buf == NULL || n < 1)
  800a20:	85 c0                	test   %eax,%eax
  800a22:	74 04                	je     800a28 <vsnprintf+0x14>
  800a24:	85 d2                	test   %edx,%edx
  800a26:	7f 07                	jg     800a2f <vsnprintf+0x1b>
  800a28:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800a2d:	eb 3b                	jmp    800a6a <vsnprintf+0x56>
}

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
	struct sprintbuf b = {buf, buf+n-1, 0};
  800a2f:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800a32:	8d 44 10 ff          	lea    -0x1(%eax,%edx,1),%eax
  800a36:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a39:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800a40:	8b 45 14             	mov    0x14(%ebp),%eax
  800a43:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800a47:	8b 45 10             	mov    0x10(%ebp),%eax
  800a4a:	89 44 24 08          	mov    %eax,0x8(%esp)
  800a4e:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800a51:	89 44 24 04          	mov    %eax,0x4(%esp)
  800a55:	c7 04 24 e0 05 80 00 	movl   $0x8005e0,(%esp)
  800a5c:	e8 9c fb ff ff       	call   8005fd <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  800a61:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800a64:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800a67:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800a6a:	c9                   	leave  
  800a6b:	c3                   	ret    

00800a6c <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800a6c:	55                   	push   %ebp
  800a6d:	89 e5                	mov    %esp,%ebp
  800a6f:	83 ec 18             	sub    $0x18,%esp

	return b.cnt;
}

int
snprintf(char *buf, int n, const char *fmt, ...)
  800a72:	8d 45 14             	lea    0x14(%ebp),%eax
{
	va_list ap;
	int rc;

	va_start(ap, fmt);
	rc = vsnprintf(buf, n, fmt, ap);
  800a75:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800a79:	8b 45 10             	mov    0x10(%ebp),%eax
  800a7c:	89 44 24 08          	mov    %eax,0x8(%esp)
  800a80:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a83:	89 44 24 04          	mov    %eax,0x4(%esp)
  800a87:	8b 45 08             	mov    0x8(%ebp),%eax
  800a8a:	89 04 24             	mov    %eax,(%esp)
  800a8d:	e8 82 ff ff ff       	call   800a14 <vsnprintf>
	va_end(ap);

	return rc;
}
  800a92:	c9                   	leave  
  800a93:	c3                   	ret    

00800a94 <printfmt>:
	}
}

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800a94:	55                   	push   %ebp
  800a95:	89 e5                	mov    %esp,%ebp
  800a97:	83 ec 18             	sub    $0x18,%esp
		}
	}
}

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
  800a9a:	8d 45 14             	lea    0x14(%ebp),%eax
{
	va_list ap;

	va_start(ap, fmt);
	vprintfmt(putch, putdat, fmt, ap);
  800a9d:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800aa1:	8b 45 10             	mov    0x10(%ebp),%eax
  800aa4:	89 44 24 08          	mov    %eax,0x8(%esp)
  800aa8:	8b 45 0c             	mov    0xc(%ebp),%eax
  800aab:	89 44 24 04          	mov    %eax,0x4(%esp)
  800aaf:	8b 45 08             	mov    0x8(%ebp),%eax
  800ab2:	89 04 24             	mov    %eax,(%esp)
  800ab5:	e8 43 fb ff ff       	call   8005fd <vprintfmt>
	va_end(ap);
}
  800aba:	c9                   	leave  
  800abb:	c3                   	ret    
  800abc:	00 00                	add    %al,(%eax)
	...

00800ac0 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800ac0:	55                   	push   %ebp
  800ac1:	89 e5                	mov    %esp,%ebp
  800ac3:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  800ac6:	b8 00 00 00 00       	mov    $0x0,%eax
  800acb:	80 3a 00             	cmpb   $0x0,(%edx)
  800ace:	74 09                	je     800ad9 <strlen+0x19>
		n++;
  800ad0:	83 c0 01             	add    $0x1,%eax
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800ad3:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  800ad7:	75 f7                	jne    800ad0 <strlen+0x10>
		n++;
	return n;
}
  800ad9:	5d                   	pop    %ebp
  800ada:	c3                   	ret    

00800adb <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800adb:	55                   	push   %ebp
  800adc:	89 e5                	mov    %esp,%ebp
  800ade:	53                   	push   %ebx
  800adf:	8b 5d 08             	mov    0x8(%ebp),%ebx
  800ae2:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800ae5:	85 c9                	test   %ecx,%ecx
  800ae7:	74 19                	je     800b02 <strnlen+0x27>
  800ae9:	80 3b 00             	cmpb   $0x0,(%ebx)
  800aec:	74 14                	je     800b02 <strnlen+0x27>
  800aee:	b8 00 00 00 00       	mov    $0x0,%eax
		n++;
  800af3:	83 c0 01             	add    $0x1,%eax
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800af6:	39 c8                	cmp    %ecx,%eax
  800af8:	74 0d                	je     800b07 <strnlen+0x2c>
  800afa:	80 3c 03 00          	cmpb   $0x0,(%ebx,%eax,1)
  800afe:	75 f3                	jne    800af3 <strnlen+0x18>
  800b00:	eb 05                	jmp    800b07 <strnlen+0x2c>
  800b02:	b8 00 00 00 00       	mov    $0x0,%eax
		n++;
	return n;
}
  800b07:	5b                   	pop    %ebx
  800b08:	5d                   	pop    %ebp
  800b09:	c3                   	ret    

00800b0a <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800b0a:	55                   	push   %ebp
  800b0b:	89 e5                	mov    %esp,%ebp
  800b0d:	53                   	push   %ebx
  800b0e:	8b 45 08             	mov    0x8(%ebp),%eax
  800b11:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800b14:	ba 00 00 00 00       	mov    $0x0,%edx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  800b19:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
  800b1d:	88 0c 10             	mov    %cl,(%eax,%edx,1)
  800b20:	83 c2 01             	add    $0x1,%edx
  800b23:	84 c9                	test   %cl,%cl
  800b25:	75 f2                	jne    800b19 <strcpy+0xf>
		/* do nothing */;
	return ret;
}
  800b27:	5b                   	pop    %ebx
  800b28:	5d                   	pop    %ebp
  800b29:	c3                   	ret    

00800b2a <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800b2a:	55                   	push   %ebp
  800b2b:	89 e5                	mov    %esp,%ebp
  800b2d:	56                   	push   %esi
  800b2e:	53                   	push   %ebx
  800b2f:	8b 45 08             	mov    0x8(%ebp),%eax
  800b32:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b35:	8b 75 10             	mov    0x10(%ebp),%esi
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800b38:	85 f6                	test   %esi,%esi
  800b3a:	74 18                	je     800b54 <strncpy+0x2a>
  800b3c:	b9 00 00 00 00       	mov    $0x0,%ecx
		*dst++ = *src;
  800b41:	0f b6 1a             	movzbl (%edx),%ebx
  800b44:	88 1c 08             	mov    %bl,(%eax,%ecx,1)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  800b47:	80 3a 01             	cmpb   $0x1,(%edx)
  800b4a:	83 da ff             	sbb    $0xffffffff,%edx
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800b4d:	83 c1 01             	add    $0x1,%ecx
  800b50:	39 ce                	cmp    %ecx,%esi
  800b52:	77 ed                	ja     800b41 <strncpy+0x17>
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
}
  800b54:	5b                   	pop    %ebx
  800b55:	5e                   	pop    %esi
  800b56:	5d                   	pop    %ebp
  800b57:	c3                   	ret    

00800b58 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800b58:	55                   	push   %ebp
  800b59:	89 e5                	mov    %esp,%ebp
  800b5b:	56                   	push   %esi
  800b5c:	53                   	push   %ebx
  800b5d:	8b 75 08             	mov    0x8(%ebp),%esi
  800b60:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b63:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  800b66:	89 f0                	mov    %esi,%eax
  800b68:	85 c9                	test   %ecx,%ecx
  800b6a:	74 27                	je     800b93 <strlcpy+0x3b>
		while (--size > 0 && *src != '\0')
  800b6c:	83 e9 01             	sub    $0x1,%ecx
  800b6f:	74 1d                	je     800b8e <strlcpy+0x36>
  800b71:	0f b6 1a             	movzbl (%edx),%ebx
  800b74:	84 db                	test   %bl,%bl
  800b76:	74 16                	je     800b8e <strlcpy+0x36>
			*dst++ = *src++;
  800b78:	88 18                	mov    %bl,(%eax)
  800b7a:	83 c0 01             	add    $0x1,%eax
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800b7d:	83 e9 01             	sub    $0x1,%ecx
  800b80:	74 0e                	je     800b90 <strlcpy+0x38>
			*dst++ = *src++;
  800b82:	83 c2 01             	add    $0x1,%edx
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800b85:	0f b6 1a             	movzbl (%edx),%ebx
  800b88:	84 db                	test   %bl,%bl
  800b8a:	75 ec                	jne    800b78 <strlcpy+0x20>
  800b8c:	eb 02                	jmp    800b90 <strlcpy+0x38>
  800b8e:	89 f0                	mov    %esi,%eax
			*dst++ = *src++;
		*dst = '\0';
  800b90:	c6 00 00             	movb   $0x0,(%eax)
  800b93:	29 f0                	sub    %esi,%eax
	}
	return dst - dst_in;
}
  800b95:	5b                   	pop    %ebx
  800b96:	5e                   	pop    %esi
  800b97:	5d                   	pop    %ebp
  800b98:	c3                   	ret    

00800b99 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800b99:	55                   	push   %ebp
  800b9a:	89 e5                	mov    %esp,%ebp
  800b9c:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800b9f:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  800ba2:	0f b6 01             	movzbl (%ecx),%eax
  800ba5:	84 c0                	test   %al,%al
  800ba7:	74 15                	je     800bbe <strcmp+0x25>
  800ba9:	3a 02                	cmp    (%edx),%al
  800bab:	75 11                	jne    800bbe <strcmp+0x25>
		p++, q++;
  800bad:	83 c1 01             	add    $0x1,%ecx
  800bb0:	83 c2 01             	add    $0x1,%edx
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800bb3:	0f b6 01             	movzbl (%ecx),%eax
  800bb6:	84 c0                	test   %al,%al
  800bb8:	74 04                	je     800bbe <strcmp+0x25>
  800bba:	3a 02                	cmp    (%edx),%al
  800bbc:	74 ef                	je     800bad <strcmp+0x14>
  800bbe:	0f b6 c0             	movzbl %al,%eax
  800bc1:	0f b6 12             	movzbl (%edx),%edx
  800bc4:	29 d0                	sub    %edx,%eax
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
}
  800bc6:	5d                   	pop    %ebp
  800bc7:	c3                   	ret    

00800bc8 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800bc8:	55                   	push   %ebp
  800bc9:	89 e5                	mov    %esp,%ebp
  800bcb:	53                   	push   %ebx
  800bcc:	8b 55 08             	mov    0x8(%ebp),%edx
  800bcf:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800bd2:	8b 45 10             	mov    0x10(%ebp),%eax
	while (n > 0 && *p && *p == *q)
  800bd5:	85 c0                	test   %eax,%eax
  800bd7:	74 23                	je     800bfc <strncmp+0x34>
  800bd9:	0f b6 1a             	movzbl (%edx),%ebx
  800bdc:	84 db                	test   %bl,%bl
  800bde:	74 24                	je     800c04 <strncmp+0x3c>
  800be0:	3a 19                	cmp    (%ecx),%bl
  800be2:	75 20                	jne    800c04 <strncmp+0x3c>
  800be4:	83 e8 01             	sub    $0x1,%eax
  800be7:	74 13                	je     800bfc <strncmp+0x34>
		n--, p++, q++;
  800be9:	83 c2 01             	add    $0x1,%edx
  800bec:	83 c1 01             	add    $0x1,%ecx
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  800bef:	0f b6 1a             	movzbl (%edx),%ebx
  800bf2:	84 db                	test   %bl,%bl
  800bf4:	74 0e                	je     800c04 <strncmp+0x3c>
  800bf6:	3a 19                	cmp    (%ecx),%bl
  800bf8:	74 ea                	je     800be4 <strncmp+0x1c>
  800bfa:	eb 08                	jmp    800c04 <strncmp+0x3c>
  800bfc:	b8 00 00 00 00       	mov    $0x0,%eax
		n--, p++, q++;
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
}
  800c01:	5b                   	pop    %ebx
  800c02:	5d                   	pop    %ebp
  800c03:	c3                   	ret    
	while (n > 0 && *p && *p == *q)
		n--, p++, q++;
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800c04:	0f b6 02             	movzbl (%edx),%eax
  800c07:	0f b6 11             	movzbl (%ecx),%edx
  800c0a:	29 d0                	sub    %edx,%eax
  800c0c:	eb f3                	jmp    800c01 <strncmp+0x39>

00800c0e <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800c0e:	55                   	push   %ebp
  800c0f:	89 e5                	mov    %esp,%ebp
  800c11:	8b 45 08             	mov    0x8(%ebp),%eax
  800c14:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800c18:	0f b6 10             	movzbl (%eax),%edx
  800c1b:	84 d2                	test   %dl,%dl
  800c1d:	74 15                	je     800c34 <strchr+0x26>
		if (*s == c)
  800c1f:	38 ca                	cmp    %cl,%dl
  800c21:	75 07                	jne    800c2a <strchr+0x1c>
  800c23:	eb 14                	jmp    800c39 <strchr+0x2b>
  800c25:	38 ca                	cmp    %cl,%dl
  800c27:	90                   	nop
  800c28:	74 0f                	je     800c39 <strchr+0x2b>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800c2a:	83 c0 01             	add    $0x1,%eax
  800c2d:	0f b6 10             	movzbl (%eax),%edx
  800c30:	84 d2                	test   %dl,%dl
  800c32:	75 f1                	jne    800c25 <strchr+0x17>
  800c34:	b8 00 00 00 00       	mov    $0x0,%eax
		if (*s == c)
			return (char *) s;
	return 0;
}
  800c39:	5d                   	pop    %ebp
  800c3a:	c3                   	ret    

00800c3b <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800c3b:	55                   	push   %ebp
  800c3c:	89 e5                	mov    %esp,%ebp
  800c3e:	8b 45 08             	mov    0x8(%ebp),%eax
  800c41:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800c45:	0f b6 10             	movzbl (%eax),%edx
  800c48:	84 d2                	test   %dl,%dl
  800c4a:	74 18                	je     800c64 <strfind+0x29>
		if (*s == c)
  800c4c:	38 ca                	cmp    %cl,%dl
  800c4e:	75 0a                	jne    800c5a <strfind+0x1f>
  800c50:	eb 12                	jmp    800c64 <strfind+0x29>
  800c52:	38 ca                	cmp    %cl,%dl
  800c54:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  800c58:	74 0a                	je     800c64 <strfind+0x29>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800c5a:	83 c0 01             	add    $0x1,%eax
  800c5d:	0f b6 10             	movzbl (%eax),%edx
  800c60:	84 d2                	test   %dl,%dl
  800c62:	75 ee                	jne    800c52 <strfind+0x17>
		if (*s == c)
			break;
	return (char *) s;
}
  800c64:	5d                   	pop    %ebp
  800c65:	c3                   	ret    

00800c66 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800c66:	55                   	push   %ebp
  800c67:	89 e5                	mov    %esp,%ebp
  800c69:	83 ec 0c             	sub    $0xc,%esp
  800c6c:	89 1c 24             	mov    %ebx,(%esp)
  800c6f:	89 74 24 04          	mov    %esi,0x4(%esp)
  800c73:	89 7c 24 08          	mov    %edi,0x8(%esp)
  800c77:	8b 7d 08             	mov    0x8(%ebp),%edi
  800c7a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c7d:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800c80:	85 c9                	test   %ecx,%ecx
  800c82:	74 30                	je     800cb4 <memset+0x4e>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800c84:	f7 c7 03 00 00 00    	test   $0x3,%edi
  800c8a:	75 25                	jne    800cb1 <memset+0x4b>
  800c8c:	f6 c1 03             	test   $0x3,%cl
  800c8f:	75 20                	jne    800cb1 <memset+0x4b>
		c &= 0xFF;
  800c91:	0f b6 d0             	movzbl %al,%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800c94:	89 d3                	mov    %edx,%ebx
  800c96:	c1 e3 08             	shl    $0x8,%ebx
  800c99:	89 d6                	mov    %edx,%esi
  800c9b:	c1 e6 18             	shl    $0x18,%esi
  800c9e:	89 d0                	mov    %edx,%eax
  800ca0:	c1 e0 10             	shl    $0x10,%eax
  800ca3:	09 f0                	or     %esi,%eax
  800ca5:	09 d0                	or     %edx,%eax
		asm volatile("cld; rep stosl\n"
  800ca7:	09 d8                	or     %ebx,%eax
  800ca9:	c1 e9 02             	shr    $0x2,%ecx
  800cac:	fc                   	cld    
  800cad:	f3 ab                	rep stos %eax,%es:(%edi)
{
	char *p;

	if (n == 0)
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800caf:	eb 03                	jmp    800cb4 <memset+0x4e>
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800cb1:	fc                   	cld    
  800cb2:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800cb4:	89 f8                	mov    %edi,%eax
  800cb6:	8b 1c 24             	mov    (%esp),%ebx
  800cb9:	8b 74 24 04          	mov    0x4(%esp),%esi
  800cbd:	8b 7c 24 08          	mov    0x8(%esp),%edi
  800cc1:	89 ec                	mov    %ebp,%esp
  800cc3:	5d                   	pop    %ebp
  800cc4:	c3                   	ret    

00800cc5 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800cc5:	55                   	push   %ebp
  800cc6:	89 e5                	mov    %esp,%ebp
  800cc8:	83 ec 08             	sub    $0x8,%esp
  800ccb:	89 34 24             	mov    %esi,(%esp)
  800cce:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800cd2:	8b 45 08             	mov    0x8(%ebp),%eax
  800cd5:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;
	
	s = src;
  800cd8:	8b 75 0c             	mov    0xc(%ebp),%esi
	d = dst;
  800cdb:	89 c7                	mov    %eax,%edi
	if (s < d && s + n > d) {
  800cdd:	39 c6                	cmp    %eax,%esi
  800cdf:	73 35                	jae    800d16 <memmove+0x51>
  800ce1:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800ce4:	39 d0                	cmp    %edx,%eax
  800ce6:	73 2e                	jae    800d16 <memmove+0x51>
		s += n;
		d += n;
  800ce8:	01 cf                	add    %ecx,%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800cea:	f6 c2 03             	test   $0x3,%dl
  800ced:	75 1b                	jne    800d0a <memmove+0x45>
  800cef:	f7 c7 03 00 00 00    	test   $0x3,%edi
  800cf5:	75 13                	jne    800d0a <memmove+0x45>
  800cf7:	f6 c1 03             	test   $0x3,%cl
  800cfa:	75 0e                	jne    800d0a <memmove+0x45>
			asm volatile("std; rep movsl\n"
  800cfc:	83 ef 04             	sub    $0x4,%edi
  800cff:	8d 72 fc             	lea    -0x4(%edx),%esi
  800d02:	c1 e9 02             	shr    $0x2,%ecx
  800d05:	fd                   	std    
  800d06:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800d08:	eb 09                	jmp    800d13 <memmove+0x4e>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  800d0a:	83 ef 01             	sub    $0x1,%edi
  800d0d:	8d 72 ff             	lea    -0x1(%edx),%esi
  800d10:	fd                   	std    
  800d11:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800d13:	fc                   	cld    
	const char *s;
	char *d;
	
	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800d14:	eb 20                	jmp    800d36 <memmove+0x71>
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800d16:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800d1c:	75 15                	jne    800d33 <memmove+0x6e>
  800d1e:	f7 c7 03 00 00 00    	test   $0x3,%edi
  800d24:	75 0d                	jne    800d33 <memmove+0x6e>
  800d26:	f6 c1 03             	test   $0x3,%cl
  800d29:	75 08                	jne    800d33 <memmove+0x6e>
			asm volatile("cld; rep movsl\n"
  800d2b:	c1 e9 02             	shr    $0x2,%ecx
  800d2e:	fc                   	cld    
  800d2f:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800d31:	eb 03                	jmp    800d36 <memmove+0x71>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  800d33:	fc                   	cld    
  800d34:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800d36:	8b 34 24             	mov    (%esp),%esi
  800d39:	8b 7c 24 04          	mov    0x4(%esp),%edi
  800d3d:	89 ec                	mov    %ebp,%esp
  800d3f:	5d                   	pop    %ebp
  800d40:	c3                   	ret    

00800d41 <memcpy>:

/* sigh - gcc emits references to this for structure assignments! */
/* it is *not* prototyped in inc/string.h - do not use directly. */
void *
memcpy(void *dst, void *src, size_t n)
{
  800d41:	55                   	push   %ebp
  800d42:	89 e5                	mov    %esp,%ebp
  800d44:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  800d47:	8b 45 10             	mov    0x10(%ebp),%eax
  800d4a:	89 44 24 08          	mov    %eax,0x8(%esp)
  800d4e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d51:	89 44 24 04          	mov    %eax,0x4(%esp)
  800d55:	8b 45 08             	mov    0x8(%ebp),%eax
  800d58:	89 04 24             	mov    %eax,(%esp)
  800d5b:	e8 65 ff ff ff       	call   800cc5 <memmove>
}
  800d60:	c9                   	leave  
  800d61:	c3                   	ret    

00800d62 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800d62:	55                   	push   %ebp
  800d63:	89 e5                	mov    %esp,%ebp
  800d65:	57                   	push   %edi
  800d66:	56                   	push   %esi
  800d67:	53                   	push   %ebx
  800d68:	8b 75 08             	mov    0x8(%ebp),%esi
  800d6b:	8b 7d 0c             	mov    0xc(%ebp),%edi
  800d6e:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800d71:	85 c9                	test   %ecx,%ecx
  800d73:	74 36                	je     800dab <memcmp+0x49>
		if (*s1 != *s2)
  800d75:	0f b6 06             	movzbl (%esi),%eax
  800d78:	0f b6 1f             	movzbl (%edi),%ebx
  800d7b:	38 d8                	cmp    %bl,%al
  800d7d:	74 20                	je     800d9f <memcmp+0x3d>
  800d7f:	eb 14                	jmp    800d95 <memcmp+0x33>
  800d81:	0f b6 44 16 01       	movzbl 0x1(%esi,%edx,1),%eax
  800d86:	0f b6 5c 17 01       	movzbl 0x1(%edi,%edx,1),%ebx
  800d8b:	83 c2 01             	add    $0x1,%edx
  800d8e:	83 e9 01             	sub    $0x1,%ecx
  800d91:	38 d8                	cmp    %bl,%al
  800d93:	74 12                	je     800da7 <memcmp+0x45>
			return (int) *s1 - (int) *s2;
  800d95:	0f b6 c0             	movzbl %al,%eax
  800d98:	0f b6 db             	movzbl %bl,%ebx
  800d9b:	29 d8                	sub    %ebx,%eax
  800d9d:	eb 11                	jmp    800db0 <memcmp+0x4e>
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800d9f:	83 e9 01             	sub    $0x1,%ecx
  800da2:	ba 00 00 00 00       	mov    $0x0,%edx
  800da7:	85 c9                	test   %ecx,%ecx
  800da9:	75 d6                	jne    800d81 <memcmp+0x1f>
  800dab:	b8 00 00 00 00       	mov    $0x0,%eax
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
}
  800db0:	5b                   	pop    %ebx
  800db1:	5e                   	pop    %esi
  800db2:	5f                   	pop    %edi
  800db3:	5d                   	pop    %ebp
  800db4:	c3                   	ret    

00800db5 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800db5:	55                   	push   %ebp
  800db6:	89 e5                	mov    %esp,%ebp
  800db8:	8b 45 08             	mov    0x8(%ebp),%eax
	const void *ends = (const char *) s + n;
  800dbb:	89 c2                	mov    %eax,%edx
  800dbd:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800dc0:	39 d0                	cmp    %edx,%eax
  800dc2:	73 15                	jae    800dd9 <memfind+0x24>
		if (*(const unsigned char *) s == (unsigned char) c)
  800dc4:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
  800dc8:	38 08                	cmp    %cl,(%eax)
  800dca:	75 06                	jne    800dd2 <memfind+0x1d>
  800dcc:	eb 0b                	jmp    800dd9 <memfind+0x24>
  800dce:	38 08                	cmp    %cl,(%eax)
  800dd0:	74 07                	je     800dd9 <memfind+0x24>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800dd2:	83 c0 01             	add    $0x1,%eax
  800dd5:	39 c2                	cmp    %eax,%edx
  800dd7:	77 f5                	ja     800dce <memfind+0x19>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
	return (void *) s;
}
  800dd9:	5d                   	pop    %ebp
  800dda:	c3                   	ret    

00800ddb <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800ddb:	55                   	push   %ebp
  800ddc:	89 e5                	mov    %esp,%ebp
  800dde:	57                   	push   %edi
  800ddf:	56                   	push   %esi
  800de0:	53                   	push   %ebx
  800de1:	83 ec 04             	sub    $0x4,%esp
  800de4:	8b 55 08             	mov    0x8(%ebp),%edx
  800de7:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800dea:	0f b6 02             	movzbl (%edx),%eax
  800ded:	3c 20                	cmp    $0x20,%al
  800def:	74 04                	je     800df5 <strtol+0x1a>
  800df1:	3c 09                	cmp    $0x9,%al
  800df3:	75 0e                	jne    800e03 <strtol+0x28>
		s++;
  800df5:	83 c2 01             	add    $0x1,%edx
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800df8:	0f b6 02             	movzbl (%edx),%eax
  800dfb:	3c 20                	cmp    $0x20,%al
  800dfd:	74 f6                	je     800df5 <strtol+0x1a>
  800dff:	3c 09                	cmp    $0x9,%al
  800e01:	74 f2                	je     800df5 <strtol+0x1a>
		s++;

	// plus/minus sign
	if (*s == '+')
  800e03:	3c 2b                	cmp    $0x2b,%al
  800e05:	75 0c                	jne    800e13 <strtol+0x38>
		s++;
  800e07:	83 c2 01             	add    $0x1,%edx
  800e0a:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800e11:	eb 15                	jmp    800e28 <strtol+0x4d>
	else if (*s == '-')
  800e13:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800e1a:	3c 2d                	cmp    $0x2d,%al
  800e1c:	75 0a                	jne    800e28 <strtol+0x4d>
		s++, neg = 1;
  800e1e:	83 c2 01             	add    $0x1,%edx
  800e21:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800e28:	85 db                	test   %ebx,%ebx
  800e2a:	0f 94 c0             	sete   %al
  800e2d:	74 05                	je     800e34 <strtol+0x59>
  800e2f:	83 fb 10             	cmp    $0x10,%ebx
  800e32:	75 18                	jne    800e4c <strtol+0x71>
  800e34:	80 3a 30             	cmpb   $0x30,(%edx)
  800e37:	75 13                	jne    800e4c <strtol+0x71>
  800e39:	80 7a 01 78          	cmpb   $0x78,0x1(%edx)
  800e3d:	8d 76 00             	lea    0x0(%esi),%esi
  800e40:	75 0a                	jne    800e4c <strtol+0x71>
		s += 2, base = 16;
  800e42:	83 c2 02             	add    $0x2,%edx
  800e45:	bb 10 00 00 00       	mov    $0x10,%ebx
		s++;
	else if (*s == '-')
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800e4a:	eb 15                	jmp    800e61 <strtol+0x86>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  800e4c:	84 c0                	test   %al,%al
  800e4e:	66 90                	xchg   %ax,%ax
  800e50:	74 0f                	je     800e61 <strtol+0x86>
  800e52:	bb 0a 00 00 00       	mov    $0xa,%ebx
  800e57:	80 3a 30             	cmpb   $0x30,(%edx)
  800e5a:	75 05                	jne    800e61 <strtol+0x86>
		s++, base = 8;
  800e5c:	83 c2 01             	add    $0x1,%edx
  800e5f:	b3 08                	mov    $0x8,%bl
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  800e61:	b8 00 00 00 00       	mov    $0x0,%eax
  800e66:	89 de                	mov    %ebx,%esi

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  800e68:	0f b6 0a             	movzbl (%edx),%ecx
  800e6b:	89 cf                	mov    %ecx,%edi
  800e6d:	8d 59 d0             	lea    -0x30(%ecx),%ebx
  800e70:	80 fb 09             	cmp    $0x9,%bl
  800e73:	77 08                	ja     800e7d <strtol+0xa2>
			dig = *s - '0';
  800e75:	0f be c9             	movsbl %cl,%ecx
  800e78:	83 e9 30             	sub    $0x30,%ecx
  800e7b:	eb 1e                	jmp    800e9b <strtol+0xc0>
		else if (*s >= 'a' && *s <= 'z')
  800e7d:	8d 5f 9f             	lea    -0x61(%edi),%ebx
  800e80:	80 fb 19             	cmp    $0x19,%bl
  800e83:	77 08                	ja     800e8d <strtol+0xb2>
			dig = *s - 'a' + 10;
  800e85:	0f be c9             	movsbl %cl,%ecx
  800e88:	83 e9 57             	sub    $0x57,%ecx
  800e8b:	eb 0e                	jmp    800e9b <strtol+0xc0>
		else if (*s >= 'A' && *s <= 'Z')
  800e8d:	8d 5f bf             	lea    -0x41(%edi),%ebx
  800e90:	80 fb 19             	cmp    $0x19,%bl
  800e93:	77 15                	ja     800eaa <strtol+0xcf>
			dig = *s - 'A' + 10;
  800e95:	0f be c9             	movsbl %cl,%ecx
  800e98:	83 e9 37             	sub    $0x37,%ecx
		else
			break;
		if (dig >= base)
  800e9b:	39 f1                	cmp    %esi,%ecx
  800e9d:	7d 0b                	jge    800eaa <strtol+0xcf>
			break;
		s++, val = (val * base) + dig;
  800e9f:	83 c2 01             	add    $0x1,%edx
  800ea2:	0f af c6             	imul   %esi,%eax
  800ea5:	8d 04 01             	lea    (%ecx,%eax,1),%eax
		// we don't properly detect overflow!
	}
  800ea8:	eb be                	jmp    800e68 <strtol+0x8d>
  800eaa:	89 c1                	mov    %eax,%ecx

	if (endptr)
  800eac:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800eb0:	74 05                	je     800eb7 <strtol+0xdc>
		*endptr = (char *) s;
  800eb2:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800eb5:	89 13                	mov    %edx,(%ebx)
	return (neg ? -val : val);
  800eb7:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  800ebb:	74 04                	je     800ec1 <strtol+0xe6>
  800ebd:	89 c8                	mov    %ecx,%eax
  800ebf:	f7 d8                	neg    %eax
}
  800ec1:	83 c4 04             	add    $0x4,%esp
  800ec4:	5b                   	pop    %ebx
  800ec5:	5e                   	pop    %esi
  800ec6:	5f                   	pop    %edi
  800ec7:	5d                   	pop    %ebp
  800ec8:	c3                   	ret    
  800ec9:	00 00                	add    %al,(%eax)
	...

00800ecc <sys_cgetc>:
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}

int
sys_cgetc(void)
{
  800ecc:	55                   	push   %ebp
  800ecd:	89 e5                	mov    %esp,%ebp
  800ecf:	83 ec 0c             	sub    $0xc,%esp
  800ed2:	89 1c 24             	mov    %ebx,(%esp)
  800ed5:	89 74 24 04          	mov    %esi,0x4(%esp)
  800ed9:	89 7c 24 08          	mov    %edi,0x8(%esp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800edd:	ba 00 00 00 00       	mov    $0x0,%edx
  800ee2:	b8 01 00 00 00       	mov    $0x1,%eax
  800ee7:	89 d1                	mov    %edx,%ecx
  800ee9:	89 d3                	mov    %edx,%ebx
  800eeb:	89 d7                	mov    %edx,%edi
  800eed:	89 d6                	mov    %edx,%esi
  800eef:	cd 30                	int    $0x30

int
sys_cgetc(void)
{
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800ef1:	8b 1c 24             	mov    (%esp),%ebx
  800ef4:	8b 74 24 04          	mov    0x4(%esp),%esi
  800ef8:	8b 7c 24 08          	mov    0x8(%esp),%edi
  800efc:	89 ec                	mov    %ebp,%esp
  800efe:	5d                   	pop    %ebp
  800eff:	c3                   	ret    

00800f00 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800f00:	55                   	push   %ebp
  800f01:	89 e5                	mov    %esp,%ebp
  800f03:	83 ec 0c             	sub    $0xc,%esp
  800f06:	89 1c 24             	mov    %ebx,(%esp)
  800f09:	89 74 24 04          	mov    %esi,0x4(%esp)
  800f0d:	89 7c 24 08          	mov    %edi,0x8(%esp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800f11:	b8 00 00 00 00       	mov    $0x0,%eax
  800f16:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f19:	8b 55 08             	mov    0x8(%ebp),%edx
  800f1c:	89 c3                	mov    %eax,%ebx
  800f1e:	89 c7                	mov    %eax,%edi
  800f20:	89 c6                	mov    %eax,%esi
  800f22:	cd 30                	int    $0x30

void
sys_cputs(const char *s, size_t len)
{
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800f24:	8b 1c 24             	mov    (%esp),%ebx
  800f27:	8b 74 24 04          	mov    0x4(%esp),%esi
  800f2b:	8b 7c 24 08          	mov    0x8(%esp),%edi
  800f2f:	89 ec                	mov    %ebp,%esp
  800f31:	5d                   	pop    %ebp
  800f32:	c3                   	ret    

00800f33 <sys_page_insert>:
{
	return syscall(SYS_page_waste, 0, (uint32_t)p, (uint32_t)n, 0, 0,0);
}
int
sys_page_insert(envid_t envid, void *va, struct Page *p, int perm)
{
  800f33:	55                   	push   %ebp
  800f34:	89 e5                	mov    %esp,%ebp
  800f36:	83 ec 38             	sub    $0x38,%esp
  800f39:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800f3c:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800f3f:	89 7d fc             	mov    %edi,-0x4(%ebp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800f42:	be 00 00 00 00       	mov    $0x0,%esi
  800f47:	b8 12 00 00 00       	mov    $0x12,%eax
  800f4c:	8b 7d 14             	mov    0x14(%ebp),%edi
  800f4f:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800f52:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f55:	8b 55 08             	mov    0x8(%ebp),%edx
  800f58:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
	
	if(check && ret > 0)
  800f5a:	85 c0                	test   %eax,%eax
  800f5c:	7e 28                	jle    800f86 <sys_page_insert+0x53>
		panic("syscall %d returned %d (> 0)", num, ret);
  800f5e:	89 44 24 10          	mov    %eax,0x10(%esp)
  800f62:	c7 44 24 0c 12 00 00 	movl   $0x12,0xc(%esp)
  800f69:	00 
  800f6a:	c7 44 24 08 1f 34 80 	movl   $0x80341f,0x8(%esp)
  800f71:	00 
  800f72:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800f79:	00 
  800f7a:	c7 04 24 3c 34 80 00 	movl   $0x80343c,(%esp)
  800f81:	e8 fe f3 ff ff       	call   800384 <_panic>
}
int
sys_page_insert(envid_t envid, void *va, struct Page *p, int perm)
{
	return syscall(SYS_page_insert, 1, envid, (uint32_t) va, (uint32_t)p, perm, 0);
}
  800f86:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800f89:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800f8c:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800f8f:	89 ec                	mov    %ebp,%esp
  800f91:	5d                   	pop    %ebp
  800f92:	c3                   	ret    

00800f93 <sys_page_waste>:
{
	return (int)syscall(SYS_receive_packet, 0, (uint32_t)buffer, 0,0,0,0);
}

int sys_page_waste(struct Page **p, int n)
{
  800f93:	55                   	push   %ebp
  800f94:	89 e5                	mov    %esp,%ebp
  800f96:	83 ec 0c             	sub    $0xc,%esp
  800f99:	89 1c 24             	mov    %ebx,(%esp)
  800f9c:	89 74 24 04          	mov    %esi,0x4(%esp)
  800fa0:	89 7c 24 08          	mov    %edi,0x8(%esp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800fa4:	bb 00 00 00 00       	mov    $0x0,%ebx
  800fa9:	b8 11 00 00 00       	mov    $0x11,%eax
  800fae:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800fb1:	8b 55 08             	mov    0x8(%ebp),%edx
  800fb4:	89 df                	mov    %ebx,%edi
  800fb6:	89 de                	mov    %ebx,%esi
  800fb8:	cd 30                	int    $0x30
}

int sys_page_waste(struct Page **p, int n)
{
	return syscall(SYS_page_waste, 0, (uint32_t)p, (uint32_t)n, 0, 0,0);
}
  800fba:	8b 1c 24             	mov    (%esp),%ebx
  800fbd:	8b 74 24 04          	mov    0x4(%esp),%esi
  800fc1:	8b 7c 24 08          	mov    0x8(%esp),%edi
  800fc5:	89 ec                	mov    %ebp,%esp
  800fc7:	5d                   	pop    %ebp
  800fc8:	c3                   	ret    

00800fc9 <sys_receive_packet>:
{
	return (int)syscall(SYS_transmit_packet, 1, (uint32_t)data, len, 0,0,0);
}

int sys_receive_packet(void* buffer)
{
  800fc9:	55                   	push   %ebp
  800fca:	89 e5                	mov    %esp,%ebp
  800fcc:	83 ec 0c             	sub    $0xc,%esp
  800fcf:	89 1c 24             	mov    %ebx,(%esp)
  800fd2:	89 74 24 04          	mov    %esi,0x4(%esp)
  800fd6:	89 7c 24 08          	mov    %edi,0x8(%esp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800fda:	b9 00 00 00 00       	mov    $0x0,%ecx
  800fdf:	b8 10 00 00 00       	mov    $0x10,%eax
  800fe4:	8b 55 08             	mov    0x8(%ebp),%edx
  800fe7:	89 cb                	mov    %ecx,%ebx
  800fe9:	89 cf                	mov    %ecx,%edi
  800feb:	89 ce                	mov    %ecx,%esi
  800fed:	cd 30                	int    $0x30
}

int sys_receive_packet(void* buffer)
{
	return (int)syscall(SYS_receive_packet, 0, (uint32_t)buffer, 0,0,0,0);
}
  800fef:	8b 1c 24             	mov    (%esp),%ebx
  800ff2:	8b 74 24 04          	mov    0x4(%esp),%esi
  800ff6:	8b 7c 24 08          	mov    0x8(%esp),%edi
  800ffa:	89 ec                	mov    %ebp,%esp
  800ffc:	5d                   	pop    %ebp
  800ffd:	c3                   	ret    

00800ffe <sys_transmit_packet>:
{
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0,0);
}

int sys_transmit_packet(void* data, uint32_t len)
{
  800ffe:	55                   	push   %ebp
  800fff:	89 e5                	mov    %esp,%ebp
  801001:	83 ec 38             	sub    $0x38,%esp
  801004:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  801007:	89 75 f8             	mov    %esi,-0x8(%ebp)
  80100a:	89 7d fc             	mov    %edi,-0x4(%ebp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80100d:	bb 00 00 00 00       	mov    $0x0,%ebx
  801012:	b8 0f 00 00 00       	mov    $0xf,%eax
  801017:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80101a:	8b 55 08             	mov    0x8(%ebp),%edx
  80101d:	89 df                	mov    %ebx,%edi
  80101f:	89 de                	mov    %ebx,%esi
  801021:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
	
	if(check && ret > 0)
  801023:	85 c0                	test   %eax,%eax
  801025:	7e 28                	jle    80104f <sys_transmit_packet+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  801027:	89 44 24 10          	mov    %eax,0x10(%esp)
  80102b:	c7 44 24 0c 0f 00 00 	movl   $0xf,0xc(%esp)
  801032:	00 
  801033:	c7 44 24 08 1f 34 80 	movl   $0x80341f,0x8(%esp)
  80103a:	00 
  80103b:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  801042:	00 
  801043:	c7 04 24 3c 34 80 00 	movl   $0x80343c,(%esp)
  80104a:	e8 35 f3 ff ff       	call   800384 <_panic>
}

int sys_transmit_packet(void* data, uint32_t len)
{
	return (int)syscall(SYS_transmit_packet, 1, (uint32_t)data, len, 0,0,0);
}
  80104f:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  801052:	8b 75 f8             	mov    -0x8(%ebp),%esi
  801055:	8b 7d fc             	mov    -0x4(%ebp),%edi
  801058:	89 ec                	mov    %ebp,%esp
  80105a:	5d                   	pop    %ebp
  80105b:	c3                   	ret    

0080105c <sys_time_msec>:
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}

unsigned int
sys_time_msec(void)
{
  80105c:	55                   	push   %ebp
  80105d:	89 e5                	mov    %esp,%ebp
  80105f:	83 ec 0c             	sub    $0xc,%esp
  801062:	89 1c 24             	mov    %ebx,(%esp)
  801065:	89 74 24 04          	mov    %esi,0x4(%esp)
  801069:	89 7c 24 08          	mov    %edi,0x8(%esp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80106d:	ba 00 00 00 00       	mov    $0x0,%edx
  801072:	b8 0e 00 00 00       	mov    $0xe,%eax
  801077:	89 d1                	mov    %edx,%ecx
  801079:	89 d3                	mov    %edx,%ebx
  80107b:	89 d7                	mov    %edx,%edi
  80107d:	89 d6                	mov    %edx,%esi
  80107f:	cd 30                	int    $0x30

unsigned int
sys_time_msec(void)
{
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0,0);
}
  801081:	8b 1c 24             	mov    (%esp),%ebx
  801084:	8b 74 24 04          	mov    0x4(%esp),%esi
  801088:	8b 7c 24 08          	mov    0x8(%esp),%edi
  80108c:	89 ec                	mov    %ebp,%esp
  80108e:	5d                   	pop    %ebp
  80108f:	c3                   	ret    

00801090 <sys_ipc_recv>:
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}

int
sys_ipc_recv(void *dstva)
{
  801090:	55                   	push   %ebp
  801091:	89 e5                	mov    %esp,%ebp
  801093:	83 ec 38             	sub    $0x38,%esp
  801096:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  801099:	89 75 f8             	mov    %esi,-0x8(%ebp)
  80109c:	89 7d fc             	mov    %edi,-0x4(%ebp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80109f:	b9 00 00 00 00       	mov    $0x0,%ecx
  8010a4:	b8 0d 00 00 00       	mov    $0xd,%eax
  8010a9:	8b 55 08             	mov    0x8(%ebp),%edx
  8010ac:	89 cb                	mov    %ecx,%ebx
  8010ae:	89 cf                	mov    %ecx,%edi
  8010b0:	89 ce                	mov    %ecx,%esi
  8010b2:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
	
	if(check && ret > 0)
  8010b4:	85 c0                	test   %eax,%eax
  8010b6:	7e 28                	jle    8010e0 <sys_ipc_recv+0x50>
		panic("syscall %d returned %d (> 0)", num, ret);
  8010b8:	89 44 24 10          	mov    %eax,0x10(%esp)
  8010bc:	c7 44 24 0c 0d 00 00 	movl   $0xd,0xc(%esp)
  8010c3:	00 
  8010c4:	c7 44 24 08 1f 34 80 	movl   $0x80341f,0x8(%esp)
  8010cb:	00 
  8010cc:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  8010d3:	00 
  8010d4:	c7 04 24 3c 34 80 00 	movl   $0x80343c,(%esp)
  8010db:	e8 a4 f2 ff ff       	call   800384 <_panic>

int
sys_ipc_recv(void *dstva)
{
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  8010e0:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  8010e3:	8b 75 f8             	mov    -0x8(%ebp),%esi
  8010e6:	8b 7d fc             	mov    -0x4(%ebp),%edi
  8010e9:	89 ec                	mov    %ebp,%esp
  8010eb:	5d                   	pop    %ebp
  8010ec:	c3                   	ret    

008010ed <sys_ipc_try_send>:
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  8010ed:	55                   	push   %ebp
  8010ee:	89 e5                	mov    %esp,%ebp
  8010f0:	83 ec 0c             	sub    $0xc,%esp
  8010f3:	89 1c 24             	mov    %ebx,(%esp)
  8010f6:	89 74 24 04          	mov    %esi,0x4(%esp)
  8010fa:	89 7c 24 08          	mov    %edi,0x8(%esp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8010fe:	be 00 00 00 00       	mov    $0x0,%esi
  801103:	b8 0c 00 00 00       	mov    $0xc,%eax
  801108:	8b 7d 14             	mov    0x14(%ebp),%edi
  80110b:	8b 5d 10             	mov    0x10(%ebp),%ebx
  80110e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801111:	8b 55 08             	mov    0x8(%ebp),%edx
  801114:	cd 30                	int    $0x30

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  801116:	8b 1c 24             	mov    (%esp),%ebx
  801119:	8b 74 24 04          	mov    0x4(%esp),%esi
  80111d:	8b 7c 24 08          	mov    0x8(%esp),%edi
  801121:	89 ec                	mov    %ebp,%esp
  801123:	5d                   	pop    %ebp
  801124:	c3                   	ret    

00801125 <sys_env_set_pgfault_upcall>:
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  801125:	55                   	push   %ebp
  801126:	89 e5                	mov    %esp,%ebp
  801128:	83 ec 38             	sub    $0x38,%esp
  80112b:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  80112e:	89 75 f8             	mov    %esi,-0x8(%ebp)
  801131:	89 7d fc             	mov    %edi,-0x4(%ebp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801134:	bb 00 00 00 00       	mov    $0x0,%ebx
  801139:	b8 0a 00 00 00       	mov    $0xa,%eax
  80113e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801141:	8b 55 08             	mov    0x8(%ebp),%edx
  801144:	89 df                	mov    %ebx,%edi
  801146:	89 de                	mov    %ebx,%esi
  801148:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
	
	if(check && ret > 0)
  80114a:	85 c0                	test   %eax,%eax
  80114c:	7e 28                	jle    801176 <sys_env_set_pgfault_upcall+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  80114e:	89 44 24 10          	mov    %eax,0x10(%esp)
  801152:	c7 44 24 0c 0a 00 00 	movl   $0xa,0xc(%esp)
  801159:	00 
  80115a:	c7 44 24 08 1f 34 80 	movl   $0x80341f,0x8(%esp)
  801161:	00 
  801162:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  801169:	00 
  80116a:	c7 04 24 3c 34 80 00 	movl   $0x80343c,(%esp)
  801171:	e8 0e f2 ff ff       	call   800384 <_panic>

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  801176:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  801179:	8b 75 f8             	mov    -0x8(%ebp),%esi
  80117c:	8b 7d fc             	mov    -0x4(%ebp),%edi
  80117f:	89 ec                	mov    %ebp,%esp
  801181:	5d                   	pop    %ebp
  801182:	c3                   	ret    

00801183 <sys_env_set_trapframe>:
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  801183:	55                   	push   %ebp
  801184:	89 e5                	mov    %esp,%ebp
  801186:	83 ec 38             	sub    $0x38,%esp
  801189:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  80118c:	89 75 f8             	mov    %esi,-0x8(%ebp)
  80118f:	89 7d fc             	mov    %edi,-0x4(%ebp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801192:	bb 00 00 00 00       	mov    $0x0,%ebx
  801197:	b8 09 00 00 00       	mov    $0x9,%eax
  80119c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80119f:	8b 55 08             	mov    0x8(%ebp),%edx
  8011a2:	89 df                	mov    %ebx,%edi
  8011a4:	89 de                	mov    %ebx,%esi
  8011a6:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
	
	if(check && ret > 0)
  8011a8:	85 c0                	test   %eax,%eax
  8011aa:	7e 28                	jle    8011d4 <sys_env_set_trapframe+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  8011ac:	89 44 24 10          	mov    %eax,0x10(%esp)
  8011b0:	c7 44 24 0c 09 00 00 	movl   $0x9,0xc(%esp)
  8011b7:	00 
  8011b8:	c7 44 24 08 1f 34 80 	movl   $0x80341f,0x8(%esp)
  8011bf:	00 
  8011c0:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  8011c7:	00 
  8011c8:	c7 04 24 3c 34 80 00 	movl   $0x80343c,(%esp)
  8011cf:	e8 b0 f1 ff ff       	call   800384 <_panic>

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  8011d4:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  8011d7:	8b 75 f8             	mov    -0x8(%ebp),%esi
  8011da:	8b 7d fc             	mov    -0x4(%ebp),%edi
  8011dd:	89 ec                	mov    %ebp,%esp
  8011df:	5d                   	pop    %ebp
  8011e0:	c3                   	ret    

008011e1 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  8011e1:	55                   	push   %ebp
  8011e2:	89 e5                	mov    %esp,%ebp
  8011e4:	83 ec 38             	sub    $0x38,%esp
  8011e7:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  8011ea:	89 75 f8             	mov    %esi,-0x8(%ebp)
  8011ed:	89 7d fc             	mov    %edi,-0x4(%ebp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8011f0:	bb 00 00 00 00       	mov    $0x0,%ebx
  8011f5:	b8 08 00 00 00       	mov    $0x8,%eax
  8011fa:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8011fd:	8b 55 08             	mov    0x8(%ebp),%edx
  801200:	89 df                	mov    %ebx,%edi
  801202:	89 de                	mov    %ebx,%esi
  801204:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
	
	if(check && ret > 0)
  801206:	85 c0                	test   %eax,%eax
  801208:	7e 28                	jle    801232 <sys_env_set_status+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  80120a:	89 44 24 10          	mov    %eax,0x10(%esp)
  80120e:	c7 44 24 0c 08 00 00 	movl   $0x8,0xc(%esp)
  801215:	00 
  801216:	c7 44 24 08 1f 34 80 	movl   $0x80341f,0x8(%esp)
  80121d:	00 
  80121e:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  801225:	00 
  801226:	c7 04 24 3c 34 80 00 	movl   $0x80343c,(%esp)
  80122d:	e8 52 f1 ff ff       	call   800384 <_panic>

int
sys_env_set_status(envid_t envid, int status)
{
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  801232:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  801235:	8b 75 f8             	mov    -0x8(%ebp),%esi
  801238:	8b 7d fc             	mov    -0x4(%ebp),%edi
  80123b:	89 ec                	mov    %ebp,%esp
  80123d:	5d                   	pop    %ebp
  80123e:	c3                   	ret    

0080123f <sys_page_unmap>:
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}

int
sys_page_unmap(envid_t envid, void *va)
{
  80123f:	55                   	push   %ebp
  801240:	89 e5                	mov    %esp,%ebp
  801242:	83 ec 38             	sub    $0x38,%esp
  801245:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  801248:	89 75 f8             	mov    %esi,-0x8(%ebp)
  80124b:	89 7d fc             	mov    %edi,-0x4(%ebp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80124e:	bb 00 00 00 00       	mov    $0x0,%ebx
  801253:	b8 06 00 00 00       	mov    $0x6,%eax
  801258:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80125b:	8b 55 08             	mov    0x8(%ebp),%edx
  80125e:	89 df                	mov    %ebx,%edi
  801260:	89 de                	mov    %ebx,%esi
  801262:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
	
	if(check && ret > 0)
  801264:	85 c0                	test   %eax,%eax
  801266:	7e 28                	jle    801290 <sys_page_unmap+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  801268:	89 44 24 10          	mov    %eax,0x10(%esp)
  80126c:	c7 44 24 0c 06 00 00 	movl   $0x6,0xc(%esp)
  801273:	00 
  801274:	c7 44 24 08 1f 34 80 	movl   $0x80341f,0x8(%esp)
  80127b:	00 
  80127c:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  801283:	00 
  801284:	c7 04 24 3c 34 80 00 	movl   $0x80343c,(%esp)
  80128b:	e8 f4 f0 ff ff       	call   800384 <_panic>

int
sys_page_unmap(envid_t envid, void *va)
{
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  801290:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  801293:	8b 75 f8             	mov    -0x8(%ebp),%esi
  801296:	8b 7d fc             	mov    -0x4(%ebp),%edi
  801299:	89 ec                	mov    %ebp,%esp
  80129b:	5d                   	pop    %ebp
  80129c:	c3                   	ret    

0080129d <sys_page_map>:
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  80129d:	55                   	push   %ebp
  80129e:	89 e5                	mov    %esp,%ebp
  8012a0:	83 ec 38             	sub    $0x38,%esp
  8012a3:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  8012a6:	89 75 f8             	mov    %esi,-0x8(%ebp)
  8012a9:	89 7d fc             	mov    %edi,-0x4(%ebp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8012ac:	b8 05 00 00 00       	mov    $0x5,%eax
  8012b1:	8b 75 18             	mov    0x18(%ebp),%esi
  8012b4:	8b 7d 14             	mov    0x14(%ebp),%edi
  8012b7:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8012ba:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8012bd:	8b 55 08             	mov    0x8(%ebp),%edx
  8012c0:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
	
	if(check && ret > 0)
  8012c2:	85 c0                	test   %eax,%eax
  8012c4:	7e 28                	jle    8012ee <sys_page_map+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  8012c6:	89 44 24 10          	mov    %eax,0x10(%esp)
  8012ca:	c7 44 24 0c 05 00 00 	movl   $0x5,0xc(%esp)
  8012d1:	00 
  8012d2:	c7 44 24 08 1f 34 80 	movl   $0x80341f,0x8(%esp)
  8012d9:	00 
  8012da:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  8012e1:	00 
  8012e2:	c7 04 24 3c 34 80 00 	movl   $0x80343c,(%esp)
  8012e9:	e8 96 f0 ff ff       	call   800384 <_panic>

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  8012ee:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  8012f1:	8b 75 f8             	mov    -0x8(%ebp),%esi
  8012f4:	8b 7d fc             	mov    -0x4(%ebp),%edi
  8012f7:	89 ec                	mov    %ebp,%esp
  8012f9:	5d                   	pop    %ebp
  8012fa:	c3                   	ret    

008012fb <sys_page_alloc>:
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  8012fb:	55                   	push   %ebp
  8012fc:	89 e5                	mov    %esp,%ebp
  8012fe:	83 ec 38             	sub    $0x38,%esp
  801301:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  801304:	89 75 f8             	mov    %esi,-0x8(%ebp)
  801307:	89 7d fc             	mov    %edi,-0x4(%ebp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80130a:	be 00 00 00 00       	mov    $0x0,%esi
  80130f:	b8 04 00 00 00       	mov    $0x4,%eax
  801314:	8b 5d 10             	mov    0x10(%ebp),%ebx
  801317:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80131a:	8b 55 08             	mov    0x8(%ebp),%edx
  80131d:	89 f7                	mov    %esi,%edi
  80131f:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
	
	if(check && ret > 0)
  801321:	85 c0                	test   %eax,%eax
  801323:	7e 28                	jle    80134d <sys_page_alloc+0x52>
		panic("syscall %d returned %d (> 0)", num, ret);
  801325:	89 44 24 10          	mov    %eax,0x10(%esp)
  801329:	c7 44 24 0c 04 00 00 	movl   $0x4,0xc(%esp)
  801330:	00 
  801331:	c7 44 24 08 1f 34 80 	movl   $0x80341f,0x8(%esp)
  801338:	00 
  801339:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  801340:	00 
  801341:	c7 04 24 3c 34 80 00 	movl   $0x80343c,(%esp)
  801348:	e8 37 f0 ff ff       	call   800384 <_panic>

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  80134d:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  801350:	8b 75 f8             	mov    -0x8(%ebp),%esi
  801353:	8b 7d fc             	mov    -0x4(%ebp),%edi
  801356:	89 ec                	mov    %ebp,%esp
  801358:	5d                   	pop    %ebp
  801359:	c3                   	ret    

0080135a <sys_yield>:
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}

void
sys_yield(void)
{
  80135a:	55                   	push   %ebp
  80135b:	89 e5                	mov    %esp,%ebp
  80135d:	83 ec 0c             	sub    $0xc,%esp
  801360:	89 1c 24             	mov    %ebx,(%esp)
  801363:	89 74 24 04          	mov    %esi,0x4(%esp)
  801367:	89 7c 24 08          	mov    %edi,0x8(%esp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80136b:	ba 00 00 00 00       	mov    $0x0,%edx
  801370:	b8 0b 00 00 00       	mov    $0xb,%eax
  801375:	89 d1                	mov    %edx,%ecx
  801377:	89 d3                	mov    %edx,%ebx
  801379:	89 d7                	mov    %edx,%edi
  80137b:	89 d6                	mov    %edx,%esi
  80137d:	cd 30                	int    $0x30

void
sys_yield(void)
{
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  80137f:	8b 1c 24             	mov    (%esp),%ebx
  801382:	8b 74 24 04          	mov    0x4(%esp),%esi
  801386:	8b 7c 24 08          	mov    0x8(%esp),%edi
  80138a:	89 ec                	mov    %ebp,%esp
  80138c:	5d                   	pop    %ebp
  80138d:	c3                   	ret    

0080138e <sys_getenvid>:
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}

envid_t
sys_getenvid(void)
{
  80138e:	55                   	push   %ebp
  80138f:	89 e5                	mov    %esp,%ebp
  801391:	83 ec 0c             	sub    $0xc,%esp
  801394:	89 1c 24             	mov    %ebx,(%esp)
  801397:	89 74 24 04          	mov    %esi,0x4(%esp)
  80139b:	89 7c 24 08          	mov    %edi,0x8(%esp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80139f:	ba 00 00 00 00       	mov    $0x0,%edx
  8013a4:	b8 02 00 00 00       	mov    $0x2,%eax
  8013a9:	89 d1                	mov    %edx,%ecx
  8013ab:	89 d3                	mov    %edx,%ebx
  8013ad:	89 d7                	mov    %edx,%edi
  8013af:	89 d6                	mov    %edx,%esi
  8013b1:	cd 30                	int    $0x30

envid_t
sys_getenvid(void)
{
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  8013b3:	8b 1c 24             	mov    (%esp),%ebx
  8013b6:	8b 74 24 04          	mov    0x4(%esp),%esi
  8013ba:	8b 7c 24 08          	mov    0x8(%esp),%edi
  8013be:	89 ec                	mov    %ebp,%esp
  8013c0:	5d                   	pop    %ebp
  8013c1:	c3                   	ret    

008013c2 <sys_env_destroy>:
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}

int
sys_env_destroy(envid_t envid)
{
  8013c2:	55                   	push   %ebp
  8013c3:	89 e5                	mov    %esp,%ebp
  8013c5:	83 ec 38             	sub    $0x38,%esp
  8013c8:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  8013cb:	89 75 f8             	mov    %esi,-0x8(%ebp)
  8013ce:	89 7d fc             	mov    %edi,-0x4(%ebp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8013d1:	b9 00 00 00 00       	mov    $0x0,%ecx
  8013d6:	b8 03 00 00 00       	mov    $0x3,%eax
  8013db:	8b 55 08             	mov    0x8(%ebp),%edx
  8013de:	89 cb                	mov    %ecx,%ebx
  8013e0:	89 cf                	mov    %ecx,%edi
  8013e2:	89 ce                	mov    %ecx,%esi
  8013e4:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
	
	if(check && ret > 0)
  8013e6:	85 c0                	test   %eax,%eax
  8013e8:	7e 28                	jle    801412 <sys_env_destroy+0x50>
		panic("syscall %d returned %d (> 0)", num, ret);
  8013ea:	89 44 24 10          	mov    %eax,0x10(%esp)
  8013ee:	c7 44 24 0c 03 00 00 	movl   $0x3,0xc(%esp)
  8013f5:	00 
  8013f6:	c7 44 24 08 1f 34 80 	movl   $0x80341f,0x8(%esp)
  8013fd:	00 
  8013fe:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  801405:	00 
  801406:	c7 04 24 3c 34 80 00 	movl   $0x80343c,(%esp)
  80140d:	e8 72 ef ff ff       	call   800384 <_panic>

int
sys_env_destroy(envid_t envid)
{
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  801412:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  801415:	8b 75 f8             	mov    -0x8(%ebp),%esi
  801418:	8b 7d fc             	mov    -0x4(%ebp),%edi
  80141b:	89 ec                	mov    %ebp,%esp
  80141d:	5d                   	pop    %ebp
  80141e:	c3                   	ret    
	...

00801420 <sfork>:
}

// Challenge!
int
sfork(void)
{
  801420:	55                   	push   %ebp
  801421:	89 e5                	mov    %esp,%ebp
  801423:	83 ec 18             	sub    $0x18,%esp
	panic("sfork not implemented");
  801426:	c7 44 24 08 4a 34 80 	movl   $0x80344a,0x8(%esp)
  80142d:	00 
  80142e:	c7 44 24 04 f2 00 00 	movl   $0xf2,0x4(%esp)
  801435:	00 
  801436:	c7 04 24 60 34 80 00 	movl   $0x803460,(%esp)
  80143d:	e8 42 ef ff ff       	call   800384 <_panic>

00801442 <pgfault>:
// Custom page fault handler - if faulting page is copy-on-write,
// map in our own private writable copy.
//
static void
pgfault(struct UTrapframe *utf)
{
  801442:	55                   	push   %ebp
  801443:	89 e5                	mov    %esp,%ebp
  801445:	53                   	push   %ebx
  801446:	83 ec 24             	sub    $0x24,%esp
  801449:	8b 45 08             	mov    0x8(%ebp),%eax
	void *addr = (void *) utf->utf_fault_va;
  80144c:	8b 18                	mov    (%eax),%ebx
	uint32_t err = utf->utf_err;
  80144e:	f6 40 04 02          	testb  $0x2,0x4(%eax)
  801452:	75 1c                	jne    801470 <pgfault+0x2e>
	// LAB 4: Your code here.
	if ((err & FEC_WR) != FEC_WR)
	{
		if (debug)
			cprintf("Error caught = %x\n", err);
		panic ("user panic in lib/fork.c - pgfault(): faulting access is not write\n");
  801454:	c7 44 24 08 6c 34 80 	movl   $0x80346c,0x8(%esp)
  80145b:	00 
  80145c:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  801463:	00 
  801464:	c7 04 24 60 34 80 00 	movl   $0x803460,(%esp)
  80146b:	e8 14 ef ff ff       	call   800384 <_panic>
	}
	pte = vpt[VPN(addr)];
  801470:	89 d8                	mov    %ebx,%eax
  801472:	c1 e8 0c             	shr    $0xc,%eax
  801475:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
	if ((pte & PTE_COW) != PTE_COW)
  80147c:	f6 c4 08             	test   $0x8,%ah
  80147f:	75 1c                	jne    80149d <pgfault+0x5b>
		panic ("user panic in lib/fork.c - pgfault(): faulting access is not to a COW page\n");
  801481:	c7 44 24 08 b0 34 80 	movl   $0x8034b0,0x8(%esp)
  801488:	00 
  801489:	c7 44 24 04 27 00 00 	movl   $0x27,0x4(%esp)
  801490:	00 
  801491:	c7 04 24 60 34 80 00 	movl   $0x803460,(%esp)
  801498:	e8 e7 ee ff ff       	call   800384 <_panic>
	// Hint:
	//   You should make three system calls.
	//   No need to explicitly delete the old page's mapping.

	// LAB 4: Your code here.
	if ((r = sys_page_alloc(0, (void*)PFTEMP, PTE_P | PTE_U | PTE_W)) < 0)
  80149d:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  8014a4:	00 
  8014a5:	c7 44 24 04 00 f0 7f 	movl   $0x7ff000,0x4(%esp)
  8014ac:	00 
  8014ad:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8014b4:	e8 42 fe ff ff       	call   8012fb <sys_page_alloc>
  8014b9:	85 c0                	test   %eax,%eax
  8014bb:	79 20                	jns    8014dd <pgfault+0x9b>
		panic ("user panic in lib/fork.c - pgfault(): sys_page_alloc: %e", r);
  8014bd:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8014c1:	c7 44 24 08 fc 34 80 	movl   $0x8034fc,0x8(%esp)
  8014c8:	00 
  8014c9:	c7 44 24 04 32 00 00 	movl   $0x32,0x4(%esp)
  8014d0:	00 
  8014d1:	c7 04 24 60 34 80 00 	movl   $0x803460,(%esp)
  8014d8:	e8 a7 ee ff ff       	call   800384 <_panic>
	
	memmove((void*)PFTEMP, (void*)ROUNDDOWN(addr,PGSIZE), PGSIZE);
  8014dd:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  8014e3:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
  8014ea:	00 
  8014eb:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8014ef:	c7 04 24 00 f0 7f 00 	movl   $0x7ff000,(%esp)
  8014f6:	e8 ca f7 ff ff       	call   800cc5 <memmove>
		
	if ((r = sys_page_map(0, (void*)PFTEMP, 0, (void*)ROUNDDOWN(addr,PGSIZE), PTE_P | PTE_U | PTE_W)) < 0)	
  8014fb:	c7 44 24 10 07 00 00 	movl   $0x7,0x10(%esp)
  801502:	00 
  801503:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  801507:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  80150e:	00 
  80150f:	c7 44 24 04 00 f0 7f 	movl   $0x7ff000,0x4(%esp)
  801516:	00 
  801517:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80151e:	e8 7a fd ff ff       	call   80129d <sys_page_map>
  801523:	85 c0                	test   %eax,%eax
  801525:	79 20                	jns    801547 <pgfault+0x105>
		panic ("user panic in lib/fork.c - pgfault(): sys_page_map: %e", r);
  801527:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80152b:	c7 44 24 08 38 35 80 	movl   $0x803538,0x8(%esp)
  801532:	00 
  801533:	c7 44 24 04 37 00 00 	movl   $0x37,0x4(%esp)
  80153a:	00 
  80153b:	c7 04 24 60 34 80 00 	movl   $0x803460,(%esp)
  801542:	e8 3d ee ff ff       	call   800384 <_panic>
	if ((r = sys_page_unmap(0, (void*)PFTEMP)) < 0)
  801547:	c7 44 24 04 00 f0 7f 	movl   $0x7ff000,0x4(%esp)
  80154e:	00 
  80154f:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801556:	e8 e4 fc ff ff       	call   80123f <sys_page_unmap>
  80155b:	85 c0                	test   %eax,%eax
  80155d:	79 20                	jns    80157f <pgfault+0x13d>
		panic ("user panic in lib/fork.c - pgfault(): sys_page_unmap: %e", r);
  80155f:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801563:	c7 44 24 08 70 35 80 	movl   $0x803570,0x8(%esp)
  80156a:	00 
  80156b:	c7 44 24 04 39 00 00 	movl   $0x39,0x4(%esp)
  801572:	00 
  801573:	c7 04 24 60 34 80 00 	movl   $0x803460,(%esp)
  80157a:	e8 05 ee ff ff       	call   800384 <_panic>
	// panic("pgfault not implemented");
}
  80157f:	83 c4 24             	add    $0x24,%esp
  801582:	5b                   	pop    %ebx
  801583:	5d                   	pop    %ebp
  801584:	c3                   	ret    

00801585 <fork>:
//   Neither user exception stack should ever be marked copy-on-write,
//   so you must allocate a new page for the child's user exception stack.
//
envid_t
fork(void)
{
  801585:	55                   	push   %ebp
  801586:	89 e5                	mov    %esp,%ebp
  801588:	57                   	push   %edi
  801589:	56                   	push   %esi
  80158a:	53                   	push   %ebx
  80158b:	83 ec 3c             	sub    $0x3c,%esp
	int r;
	uint32_t pde_x, pte_x, vpn;	// page directory index, page table index and page number
	

	// Set up our page fault handler appropriately.
	set_pgfault_handler(pgfault);
  80158e:	c7 04 24 42 14 80 00 	movl   $0x801442,(%esp)
  801595:	e8 a2 15 00 00       	call   802b3c <set_pgfault_handler>
static __inline envid_t sys_exofork(void) __attribute__((always_inline));
static __inline envid_t
sys_exofork(void)
{
	envid_t ret;
	__asm __volatile("int %2"
  80159a:	ba 07 00 00 00       	mov    $0x7,%edx
  80159f:	89 d0                	mov    %edx,%eax
  8015a1:	cd 30                	int    $0x30
  8015a3:	89 45 e0             	mov    %eax,-0x20(%ebp)
		cprintf("\n After set_pgfaulthandler()\n");
	// Create a child.
	child_envid = sys_exofork();
	if (debug)
		cprintf("\n After exofork()\n");
	if (child_envid < 0)
  8015a6:	85 c0                	test   %eax,%eax
  8015a8:	0f 88 21 02 00 00    	js     8017cf <fork+0x24a>
	if (child_envid == 0)
	{
		if (debug)
			cprintf("\n After child_envid == 0\n");
		env = &envs[ENVX(sys_getenvid())];
		return 0;
  8015ae:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
		return child_envid;
	if (debug)
		cprintf("\n After child_envid >= 0\n");
		// panic(" panic in lib/fork.c - fork():sys_exofork: %e", child_env);
	// fix "env" in the child process
	if (child_envid == 0)
  8015b5:	85 c0                	test   %eax,%eax
  8015b7:	75 1c                	jne    8015d5 <fork+0x50>
	{
		if (debug)
			cprintf("\n After child_envid == 0\n");
		env = &envs[ENVX(sys_getenvid())];
  8015b9:	e8 d0 fd ff ff       	call   80138e <sys_getenvid>
  8015be:	25 ff 03 00 00       	and    $0x3ff,%eax
  8015c3:	6b c0 7c             	imul   $0x7c,%eax,%eax
  8015c6:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8015cb:	a3 78 70 80 00       	mov    %eax,0x807078
		return 0;
  8015d0:	e9 fa 01 00 00       	jmp    8017cf <fork+0x24a>
	// Map the address space except the user exception stack
	if (debug)
		cprintf("\n After child_envid > 0\n");
	for (pde_x = VPD(0); pde_x < VPD(UTOP); pde_x++)
	{
		if ((vpd[pde_x] & PTE_P) == PTE_P)
  8015d5:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8015d8:	8b 04 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%eax
  8015df:	a8 01                	test   $0x1,%al
  8015e1:	0f 84 16 01 00 00    	je     8016fd <fork+0x178>
		{
			for (pte_x = 0; pte_x < NPTENTRIES; pte_x++)
			{
				vpn = (pde_x << (PDXSHIFT - PTXSHIFT)) + pte_x;		//removed hardcoding
  8015e7:	89 d3                	mov    %edx,%ebx
  8015e9:	c1 e3 0a             	shl    $0xa,%ebx
  8015ec:	89 d7                	mov    %edx,%edi
  8015ee:	c1 e7 16             	shl    $0x16,%edi
  8015f1:	be 00 00 00 00       	mov    $0x0,%esi
				if(((vpt[vpn] & PTE_P) == PTE_P) && (vpn < VPN(UXSTACKTOP - PGSIZE)))
  8015f6:	8b 04 9d 00 00 40 ef 	mov    -0x10c00000(,%ebx,4),%eax
  8015fd:	a8 01                	test   $0x1,%al
  8015ff:	0f 84 e0 00 00 00    	je     8016e5 <fork+0x160>
  801605:	81 fb fe eb 0e 00    	cmp    $0xeebfe,%ebx
  80160b:	0f 87 d4 00 00 00    	ja     8016e5 <fork+0x160>
	
	// LAB 4: Your code here.
	if (debug)
		cprintf("\n duppage: 1\n");	

	pte_t pte = vpt[pn];
  801611:	8b 14 9d 00 00 40 ef 	mov    -0x10c00000(,%ebx,4),%edx
	int perm = pte & PTE_USER;
  801618:	89 d0                	mov    %edx,%eax
  80161a:	25 07 0e 00 00       	and    $0xe07,%eax
	void *va = (void*) (pn*PGSIZE);	
	if (debug)
		cprintf("\n duppage: 2\n");	
	
	if ((perm & PTE_P) != PTE_P)
  80161f:	f6 c2 01             	test   $0x1,%dl
  801622:	75 1c                	jne    801640 <fork+0xbb>
		panic ("user panic: lib\fork.c: duppage(): page to be duplicated is not PTE_P\n");
  801624:	c7 44 24 08 ac 35 80 	movl   $0x8035ac,0x8(%esp)
  80162b:	00 
  80162c:	c7 44 24 04 58 00 00 	movl   $0x58,0x4(%esp)
  801633:	00 
  801634:	c7 04 24 60 34 80 00 	movl   $0x803460,(%esp)
  80163b:	e8 44 ed ff ff       	call   800384 <_panic>
	if ((perm & PTE_U) != PTE_U)
  801640:	a8 04                	test   $0x4,%al
  801642:	75 1c                	jne    801660 <fork+0xdb>
		panic ("user panic: lib\fork.c: duppage(): page to be duplicated is not PTE_U\n");
  801644:	c7 44 24 08 f4 35 80 	movl   $0x8035f4,0x8(%esp)
  80164b:	00 
  80164c:	c7 44 24 04 5a 00 00 	movl   $0x5a,0x4(%esp)
  801653:	00 
  801654:	c7 04 24 60 34 80 00 	movl   $0x803460,(%esp)
  80165b:	e8 24 ed ff ff       	call   800384 <_panic>
  801660:	89 7d e4             	mov    %edi,-0x1c(%ebp)
	if (debug)
		cprintf("\n duppage: 3\n");	

	// LAB 7: Include PTE_SHARE convention
	if ( !(perm & PTE_SHARE) && (((perm & PTE_W) == PTE_W) || ((perm & PTE_COW) == PTE_COW)))
  801663:	f6 c4 04             	test   $0x4,%ah
  801666:	75 5b                	jne    8016c3 <fork+0x13e>
  801668:	a9 02 08 00 00       	test   $0x802,%eax
  80166d:	74 54                	je     8016c3 <fork+0x13e>
	{
		if (debug)
			cprintf("\n duppage: 4\n");	
		// perm = PTE_P | PTE_U | PTE_COW;	// buggy permissions, removed in LAB 7
		perm &= ~PTE_W;				// remove write from perm
  80166f:	83 e0 fd             	and    $0xfffffffd,%eax
		perm |= PTE_COW;			// add copy-on-write
  801672:	80 cc 08             	or     $0x8,%ah
  801675:	89 45 d8             	mov    %eax,-0x28(%ebp)
		if (debug)
			cprintf("\n duppage: 10\n");	
		if ((r = sys_page_map(0, va, envid, va, perm)) < 0)
  801678:	89 44 24 10          	mov    %eax,0x10(%esp)
  80167c:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  801680:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801683:	89 54 24 08          	mov    %edx,0x8(%esp)
  801687:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80168b:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801692:	e8 06 fc ff ff       	call   80129d <sys_page_map>
  801697:	85 c0                	test   %eax,%eax
  801699:	78 4a                	js     8016e5 <fork+0x160>
			return r;
		if (debug)
			cprintf("\n duppage: 11\n");	
		if ((r = sys_page_map(0, va, 0, va, perm)) < 0)
  80169b:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80169e:	89 44 24 10          	mov    %eax,0x10(%esp)
  8016a2:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8016a5:	89 54 24 0c          	mov    %edx,0xc(%esp)
  8016a9:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  8016b0:	00 
  8016b1:	89 54 24 04          	mov    %edx,0x4(%esp)
  8016b5:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8016bc:	e8 dc fb ff ff       	call   80129d <sys_page_map>
  8016c1:	eb 22                	jmp    8016e5 <fork+0x160>
	// LAB 7: Include PTE_SHARE convention
	else
	{
		if (debug)
			cprintf("\n duppage: 6\n");	
		if ((r = sys_page_map(0, va, envid, va, perm)) < 0)
  8016c3:	89 44 24 10          	mov    %eax,0x10(%esp)
  8016c7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8016ca:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8016ce:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8016d1:	89 54 24 08          	mov    %edx,0x8(%esp)
  8016d5:	89 44 24 04          	mov    %eax,0x4(%esp)
  8016d9:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8016e0:	e8 b8 fb ff ff       	call   80129d <sys_page_map>
		cprintf("\n After child_envid > 0\n");
	for (pde_x = VPD(0); pde_x < VPD(UTOP); pde_x++)
	{
		if ((vpd[pde_x] & PTE_P) == PTE_P)
		{
			for (pte_x = 0; pte_x < NPTENTRIES; pte_x++)
  8016e5:	83 c6 01             	add    $0x1,%esi
  8016e8:	83 c3 01             	add    $0x1,%ebx
  8016eb:	81 c7 00 10 00 00    	add    $0x1000,%edi
  8016f1:	81 fe 00 04 00 00    	cmp    $0x400,%esi
  8016f7:	0f 85 f9 fe ff ff    	jne    8015f6 <fork+0x71>
	}
	// reached here... we're the parent process
	// Map the address space except the user exception stack
	if (debug)
		cprintf("\n After child_envid > 0\n");
	for (pde_x = VPD(0); pde_x < VPD(UTOP); pde_x++)
  8016fd:	83 45 dc 01          	addl   $0x1,-0x24(%ebp)
  801701:	81 7d dc bb 03 00 00 	cmpl   $0x3bb,-0x24(%ebp)
  801708:	0f 85 c7 fe ff ff    	jne    8015d5 <fork+0x50>
	}	
	if (debug)
		cprintf("\n After duppaging()\n");
	// Allocate and copy the use exception stack for the child environment
	// Allocate a page for the stack in the child
	if ((r = sys_page_alloc(child_envid, (void*)(UXSTACKTOP - PGSIZE), PTE_P | PTE_U | PTE_W)) < 0)
  80170e:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  801715:	00 
  801716:	c7 44 24 04 00 f0 bf 	movl   $0xeebff000,0x4(%esp)
  80171d:	ee 
  80171e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801721:	89 04 24             	mov    %eax,(%esp)
  801724:	e8 d2 fb ff ff       	call   8012fb <sys_page_alloc>
  801729:	85 c0                	test   %eax,%eax
  80172b:	79 08                	jns    801735 <fork+0x1b0>
  80172d:	89 45 e0             	mov    %eax,-0x20(%ebp)
  801730:	e9 9a 00 00 00       	jmp    8017cf <fork+0x24a>
		return r;
	if (debug)
		cprintf("\n After set_pgfaulthandler()\n");
	// Map this page to a free virtual address space in parent
	if ((r = sys_page_map(child_envid, (void*)(UXSTACKTOP - PGSIZE), 0, (void*)UTEMP, PTE_P | PTE_U | PTE_W)) < 0)
  801735:	c7 44 24 10 07 00 00 	movl   $0x7,0x10(%esp)
  80173c:	00 
  80173d:	c7 44 24 0c 00 00 40 	movl   $0x400000,0xc(%esp)
  801744:	00 
  801745:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  80174c:	00 
  80174d:	c7 44 24 04 00 f0 bf 	movl   $0xeebff000,0x4(%esp)
  801754:	ee 
  801755:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801758:	89 14 24             	mov    %edx,(%esp)
  80175b:	e8 3d fb ff ff       	call   80129d <sys_page_map>
  801760:	85 c0                	test   %eax,%eax
  801762:	79 05                	jns    801769 <fork+0x1e4>
  801764:	89 45 e0             	mov    %eax,-0x20(%ebp)
  801767:	eb 66                	jmp    8017cf <fork+0x24a>
		return r;
	if (debug)
		cprintf("\n After sys_page_map()\n");
	// Copy the parent exception stack to the above, i.e. page from child mapped to parent's address space
	memmove((void*)UTEMP, (void*)(UXSTACKTOP - PGSIZE), PGSIZE);
  801769:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
  801770:	00 
  801771:	c7 44 24 04 00 f0 bf 	movl   $0xeebff000,0x4(%esp)
  801778:	ee 
  801779:	c7 04 24 00 00 40 00 	movl   $0x400000,(%esp)
  801780:	e8 40 f5 ff ff       	call   800cc5 <memmove>
	if (debug)
		cprintf("\n After memmove()\n");
	// Unmap this page from the parent
	sys_page_unmap(0, (void*)UTEMP);
  801785:	c7 44 24 04 00 00 40 	movl   $0x400000,0x4(%esp)
  80178c:	00 
  80178d:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801794:	e8 a6 fa ff ff       	call   80123f <sys_page_unmap>
	if (debug)
		cprintf("\n After sys_page_unmap()\n");

	// Set up the page fault handler
	if ((r = sys_env_set_pgfault_upcall(child_envid, _pgfault_upcall)) < 0)
  801799:	c7 44 24 04 d0 2b 80 	movl   $0x802bd0,0x4(%esp)
  8017a0:	00 
  8017a1:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8017a4:	89 04 24             	mov    %eax,(%esp)
  8017a7:	e8 79 f9 ff ff       	call   801125 <sys_env_set_pgfault_upcall>
  8017ac:	85 c0                	test   %eax,%eax
  8017ae:	79 05                	jns    8017b5 <fork+0x230>
  8017b0:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8017b3:	eb 1a                	jmp    8017cf <fork+0x24a>
		// panic(" panic in lib/fork.c - fork():sys_env_set_pgfault_upcall: %e", child_env);
	if (debug)
		cprintf("\n After set_upcall()\n");

	// Mark the child runnable
	if ((r = sys_env_set_status(child_envid, ENV_RUNNABLE)) < 0)
  8017b5:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  8017bc:	00 
  8017bd:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8017c0:	89 14 24             	mov    %edx,(%esp)
  8017c3:	e8 19 fa ff ff       	call   8011e1 <sys_env_set_status>
  8017c8:	85 c0                	test   %eax,%eax
  8017ca:	79 03                	jns    8017cf <fork+0x24a>
  8017cc:	89 45 e0             	mov    %eax,-0x20(%ebp)
	if (debug)
		cprintf("\n After set_status()\n");
	
	return child_envid;
	
}
  8017cf:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8017d2:	83 c4 3c             	add    $0x3c,%esp
  8017d5:	5b                   	pop    %ebx
  8017d6:	5e                   	pop    %esi
  8017d7:	5f                   	pop    %edi
  8017d8:	5d                   	pop    %ebp
  8017d9:	c3                   	ret    
  8017da:	00 00                	add    %al,(%eax)
  8017dc:	00 00                	add    %al,(%eax)
	...

008017e0 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  8017e0:	55                   	push   %ebp
  8017e1:	89 e5                	mov    %esp,%ebp
  8017e3:	8b 45 08             	mov    0x8(%ebp),%eax
  8017e6:	05 00 00 00 30       	add    $0x30000000,%eax
  8017eb:	c1 e8 0c             	shr    $0xc,%eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
}
  8017ee:	5d                   	pop    %ebp
  8017ef:	c3                   	ret    

008017f0 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  8017f0:	55                   	push   %ebp
  8017f1:	89 e5                	mov    %esp,%ebp
  8017f3:	83 ec 04             	sub    $0x4,%esp
	return INDEX2DATA(fd2num(fd));
  8017f6:	8b 45 08             	mov    0x8(%ebp),%eax
  8017f9:	89 04 24             	mov    %eax,(%esp)
  8017fc:	e8 df ff ff ff       	call   8017e0 <fd2num>
  801801:	05 20 00 0d 00       	add    $0xd0020,%eax
  801806:	c1 e0 0c             	shl    $0xc,%eax
}
  801809:	c9                   	leave  
  80180a:	c3                   	ret    

0080180b <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  80180b:	55                   	push   %ebp
  80180c:	89 e5                	mov    %esp,%ebp
  80180e:	57                   	push   %edi
  80180f:	56                   	push   %esi
  801810:	53                   	push   %ebx
  801811:	8b 7d 08             	mov    0x8(%ebp),%edi
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((vpd[PDX(fd)] & PTE_P) == 0 || (vpt[VPN(fd)] & PTE_P) == 0) {
  801814:	a1 00 dd 7b ef       	mov    0xef7bdd00,%eax
  801819:	a8 01                	test   $0x1,%al
  80181b:	74 36                	je     801853 <fd_alloc+0x48>
  80181d:	a1 00 00 74 ef       	mov    0xef740000,%eax
  801822:	a8 01                	test   $0x1,%al
  801824:	74 2d                	je     801853 <fd_alloc+0x48>
  801826:	b8 00 10 00 d0       	mov    $0xd0001000,%eax
  80182b:	b9 00 d0 7b ef       	mov    $0xef7bd000,%ecx
  801830:	be 00 00 40 ef       	mov    $0xef400000,%esi
  801835:	89 c3                	mov    %eax,%ebx
  801837:	89 c2                	mov    %eax,%edx
  801839:	c1 ea 16             	shr    $0x16,%edx
  80183c:	8b 14 91             	mov    (%ecx,%edx,4),%edx
  80183f:	f6 c2 01             	test   $0x1,%dl
  801842:	74 14                	je     801858 <fd_alloc+0x4d>
  801844:	89 c2                	mov    %eax,%edx
  801846:	c1 ea 0c             	shr    $0xc,%edx
  801849:	8b 14 96             	mov    (%esi,%edx,4),%edx
  80184c:	f6 c2 01             	test   $0x1,%dl
  80184f:	75 10                	jne    801861 <fd_alloc+0x56>
  801851:	eb 05                	jmp    801858 <fd_alloc+0x4d>
  801853:	bb 00 00 00 d0       	mov    $0xd0000000,%ebx
			*fd_store = fd;
  801858:	89 1f                	mov    %ebx,(%edi)
  80185a:	b8 00 00 00 00       	mov    $0x0,%eax
			return 0;
  80185f:	eb 17                	jmp    801878 <fd_alloc+0x6d>
  801861:	05 00 10 00 00       	add    $0x1000,%eax
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  801866:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  80186b:	75 c8                	jne    801835 <fd_alloc+0x2a>
		if ((vpd[PDX(fd)] & PTE_P) == 0 || (vpt[VPN(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  80186d:	c7 07 00 00 00 00    	movl   $0x0,(%edi)
  801873:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
	return -E_MAX_OPEN;
}
  801878:	5b                   	pop    %ebx
  801879:	5e                   	pop    %esi
  80187a:	5f                   	pop    %edi
  80187b:	5d                   	pop    %ebp
  80187c:	c3                   	ret    

0080187d <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  80187d:	55                   	push   %ebp
  80187e:	89 e5                	mov    %esp,%ebp
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  801880:	8b 45 08             	mov    0x8(%ebp),%eax
  801883:	83 f8 1f             	cmp    $0x1f,%eax
  801886:	77 36                	ja     8018be <fd_lookup+0x41>
		if (debug)
			cprintf("[%08x] bad fd %d\n", env->env_id, fd);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  801888:	05 00 00 0d 00       	add    $0xd0000,%eax
  80188d:	c1 e0 0c             	shl    $0xc,%eax
	if (!(vpd[PDX(fd)] & PTE_P) || !(vpt[VPN(fd)] & PTE_P)) {
  801890:	89 c2                	mov    %eax,%edx
  801892:	c1 ea 16             	shr    $0x16,%edx
  801895:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  80189c:	f6 c2 01             	test   $0x1,%dl
  80189f:	74 1d                	je     8018be <fd_lookup+0x41>
  8018a1:	89 c2                	mov    %eax,%edx
  8018a3:	c1 ea 0c             	shr    $0xc,%edx
  8018a6:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8018ad:	f6 c2 01             	test   $0x1,%dl
  8018b0:	74 0c                	je     8018be <fd_lookup+0x41>
		if (debug)
			cprintf("[%08x] closed fd %d\n", env->env_id, fd);
		return -E_INVAL;
	}
	*fd_store = fd;
  8018b2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8018b5:	89 02                	mov    %eax,(%edx)
  8018b7:	b8 00 00 00 00       	mov    $0x0,%eax
	return 0;
  8018bc:	eb 05                	jmp    8018c3 <fd_lookup+0x46>
  8018be:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  8018c3:	5d                   	pop    %ebp
  8018c4:	c3                   	ret    

008018c5 <seek>:
	return (*dev->dev_write)(fd, buf, n);
}

int
seek(int fdnum, off_t offset)
{
  8018c5:	55                   	push   %ebp
  8018c6:	89 e5                	mov    %esp,%ebp
  8018c8:	83 ec 18             	sub    $0x18,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8018cb:	8d 45 fc             	lea    -0x4(%ebp),%eax
  8018ce:	89 44 24 04          	mov    %eax,0x4(%esp)
  8018d2:	8b 45 08             	mov    0x8(%ebp),%eax
  8018d5:	89 04 24             	mov    %eax,(%esp)
  8018d8:	e8 a0 ff ff ff       	call   80187d <fd_lookup>
  8018dd:	85 c0                	test   %eax,%eax
  8018df:	78 0e                	js     8018ef <seek+0x2a>
		return r;
	fd->fd_offset = offset;
  8018e1:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8018e4:	8b 55 0c             	mov    0xc(%ebp),%edx
  8018e7:	89 50 04             	mov    %edx,0x4(%eax)
  8018ea:	b8 00 00 00 00       	mov    $0x0,%eax
	return 0;
}
  8018ef:	c9                   	leave  
  8018f0:	c3                   	ret    

008018f1 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  8018f1:	55                   	push   %ebp
  8018f2:	89 e5                	mov    %esp,%ebp
  8018f4:	56                   	push   %esi
  8018f5:	53                   	push   %ebx
  8018f6:	83 ec 10             	sub    $0x10,%esp
  8018f9:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8018fc:	8b 5d 0c             	mov    0xc(%ebp),%ebx
// File functions
// --------------------------------------------------------------

static struct Dev *devtab[] =
{
	&devfile,
  8018ff:	b8 08 70 80 00       	mov    $0x807008,%eax
{
	int i;
	for (i = 0; devtab[i]; i++)
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
  801904:	ba 00 00 00 00       	mov    $0x0,%edx

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  801909:	be b8 36 80 00       	mov    $0x8036b8,%esi
		if (devtab[i]->dev_id == dev_id) {
  80190e:	39 08                	cmp    %ecx,(%eax)
  801910:	75 10                	jne    801922 <dev_lookup+0x31>
  801912:	eb 04                	jmp    801918 <dev_lookup+0x27>
  801914:	39 08                	cmp    %ecx,(%eax)
  801916:	75 0a                	jne    801922 <dev_lookup+0x31>
			*dev = devtab[i];
  801918:	89 03                	mov    %eax,(%ebx)
  80191a:	b8 00 00 00 00       	mov    $0x0,%eax
			return 0;
  80191f:	90                   	nop
  801920:	eb 31                	jmp    801953 <dev_lookup+0x62>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  801922:	83 c2 01             	add    $0x1,%edx
  801925:	8b 04 96             	mov    (%esi,%edx,4),%eax
  801928:	85 c0                	test   %eax,%eax
  80192a:	75 e8                	jne    801914 <dev_lookup+0x23>
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", env->env_id, dev_id);
  80192c:	a1 78 70 80 00       	mov    0x807078,%eax
  801931:	8b 40 4c             	mov    0x4c(%eax),%eax
  801934:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801938:	89 44 24 04          	mov    %eax,0x4(%esp)
  80193c:	c7 04 24 3c 36 80 00 	movl   $0x80363c,(%esp)
  801943:	e8 01 eb ff ff       	call   800449 <cprintf>
	*dev = 0;
  801948:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  80194e:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
	return -E_INVAL;
}
  801953:	83 c4 10             	add    $0x10,%esp
  801956:	5b                   	pop    %ebx
  801957:	5e                   	pop    %esi
  801958:	5d                   	pop    %ebp
  801959:	c3                   	ret    

0080195a <fstat>:
	return (*dev->dev_trunc)(fd, newsize);
}

int
fstat(int fdnum, struct Stat *stat)
{
  80195a:	55                   	push   %ebp
  80195b:	89 e5                	mov    %esp,%ebp
  80195d:	53                   	push   %ebx
  80195e:	83 ec 24             	sub    $0x24,%esp
  801961:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801964:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801967:	89 44 24 04          	mov    %eax,0x4(%esp)
  80196b:	8b 45 08             	mov    0x8(%ebp),%eax
  80196e:	89 04 24             	mov    %eax,(%esp)
  801971:	e8 07 ff ff ff       	call   80187d <fd_lookup>
  801976:	85 c0                	test   %eax,%eax
  801978:	78 53                	js     8019cd <fstat+0x73>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80197a:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80197d:	89 44 24 04          	mov    %eax,0x4(%esp)
  801981:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801984:	8b 00                	mov    (%eax),%eax
  801986:	89 04 24             	mov    %eax,(%esp)
  801989:	e8 63 ff ff ff       	call   8018f1 <dev_lookup>
{
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80198e:	85 c0                	test   %eax,%eax
  801990:	78 3b                	js     8019cd <fstat+0x73>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if (!dev->dev_stat)
  801992:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801997:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80199a:	83 7a 14 00          	cmpl   $0x0,0x14(%edx)
  80199e:	74 2d                	je     8019cd <fstat+0x73>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  8019a0:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  8019a3:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  8019aa:	00 00 00 
	stat->st_isdir = 0;
  8019ad:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  8019b4:	00 00 00 
	stat->st_dev = dev;
  8019b7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8019ba:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  8019c0:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8019c4:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8019c7:	89 14 24             	mov    %edx,(%esp)
  8019ca:	ff 50 14             	call   *0x14(%eax)
}
  8019cd:	83 c4 24             	add    $0x24,%esp
  8019d0:	5b                   	pop    %ebx
  8019d1:	5d                   	pop    %ebp
  8019d2:	c3                   	ret    

008019d3 <ftruncate>:
	return 0;
}

int
ftruncate(int fdnum, off_t newsize)
{
  8019d3:	55                   	push   %ebp
  8019d4:	89 e5                	mov    %esp,%ebp
  8019d6:	53                   	push   %ebx
  8019d7:	83 ec 24             	sub    $0x24,%esp
  8019da:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  8019dd:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8019e0:	89 44 24 04          	mov    %eax,0x4(%esp)
  8019e4:	89 1c 24             	mov    %ebx,(%esp)
  8019e7:	e8 91 fe ff ff       	call   80187d <fd_lookup>
  8019ec:	85 c0                	test   %eax,%eax
  8019ee:	78 5f                	js     801a4f <ftruncate+0x7c>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8019f0:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8019f3:	89 44 24 04          	mov    %eax,0x4(%esp)
  8019f7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8019fa:	8b 00                	mov    (%eax),%eax
  8019fc:	89 04 24             	mov    %eax,(%esp)
  8019ff:	e8 ed fe ff ff       	call   8018f1 <dev_lookup>
ftruncate(int fdnum, off_t newsize)
{
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  801a04:	85 c0                	test   %eax,%eax
  801a06:	78 47                	js     801a4f <ftruncate+0x7c>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801a08:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801a0b:	f6 42 08 03          	testb  $0x3,0x8(%edx)
  801a0f:	75 23                	jne    801a34 <ftruncate+0x61>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			env->env_id, fdnum); 
  801a11:	a1 78 70 80 00       	mov    0x807078,%eax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  801a16:	8b 40 4c             	mov    0x4c(%eax),%eax
  801a19:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801a1d:	89 44 24 04          	mov    %eax,0x4(%esp)
  801a21:	c7 04 24 5c 36 80 00 	movl   $0x80365c,(%esp)
  801a28:	e8 1c ea ff ff       	call   800449 <cprintf>
  801a2d:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
			env->env_id, fdnum); 
		return -E_INVAL;
  801a32:	eb 1b                	jmp    801a4f <ftruncate+0x7c>
	}
	if (!dev->dev_trunc)
  801a34:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a37:	8b 48 18             	mov    0x18(%eax),%ecx
  801a3a:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801a3f:	85 c9                	test   %ecx,%ecx
  801a41:	74 0c                	je     801a4f <ftruncate+0x7c>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  801a43:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a46:	89 44 24 04          	mov    %eax,0x4(%esp)
  801a4a:	89 14 24             	mov    %edx,(%esp)
  801a4d:	ff d1                	call   *%ecx
}
  801a4f:	83 c4 24             	add    $0x24,%esp
  801a52:	5b                   	pop    %ebx
  801a53:	5d                   	pop    %ebp
  801a54:	c3                   	ret    

00801a55 <write>:
	return tot;
}

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  801a55:	55                   	push   %ebp
  801a56:	89 e5                	mov    %esp,%ebp
  801a58:	53                   	push   %ebx
  801a59:	83 ec 24             	sub    $0x24,%esp
  801a5c:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801a5f:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801a62:	89 44 24 04          	mov    %eax,0x4(%esp)
  801a66:	89 1c 24             	mov    %ebx,(%esp)
  801a69:	e8 0f fe ff ff       	call   80187d <fd_lookup>
  801a6e:	85 c0                	test   %eax,%eax
  801a70:	78 66                	js     801ad8 <write+0x83>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801a72:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801a75:	89 44 24 04          	mov    %eax,0x4(%esp)
  801a79:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801a7c:	8b 00                	mov    (%eax),%eax
  801a7e:	89 04 24             	mov    %eax,(%esp)
  801a81:	e8 6b fe ff ff       	call   8018f1 <dev_lookup>
{
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801a86:	85 c0                	test   %eax,%eax
  801a88:	78 4e                	js     801ad8 <write+0x83>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801a8a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801a8d:	f6 42 08 03          	testb  $0x3,0x8(%edx)
  801a91:	75 23                	jne    801ab6 <write+0x61>
		cprintf("[%08x] write %d -- bad mode\n", env->env_id, fdnum);
  801a93:	a1 78 70 80 00       	mov    0x807078,%eax
  801a98:	8b 40 4c             	mov    0x4c(%eax),%eax
  801a9b:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801a9f:	89 44 24 04          	mov    %eax,0x4(%esp)
  801aa3:	c7 04 24 7d 36 80 00 	movl   $0x80367d,(%esp)
  801aaa:	e8 9a e9 ff ff       	call   800449 <cprintf>
  801aaf:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
		return -E_INVAL;
  801ab4:	eb 22                	jmp    801ad8 <write+0x83>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  801ab6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ab9:	8b 48 0c             	mov    0xc(%eax),%ecx
  801abc:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801ac1:	85 c9                	test   %ecx,%ecx
  801ac3:	74 13                	je     801ad8 <write+0x83>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  801ac5:	8b 45 10             	mov    0x10(%ebp),%eax
  801ac8:	89 44 24 08          	mov    %eax,0x8(%esp)
  801acc:	8b 45 0c             	mov    0xc(%ebp),%eax
  801acf:	89 44 24 04          	mov    %eax,0x4(%esp)
  801ad3:	89 14 24             	mov    %edx,(%esp)
  801ad6:	ff d1                	call   *%ecx
}
  801ad8:	83 c4 24             	add    $0x24,%esp
  801adb:	5b                   	pop    %ebx
  801adc:	5d                   	pop    %ebp
  801add:	c3                   	ret    

00801ade <read>:
	return r;
}

ssize_t
read(int fdnum, void *buf, size_t n)
{
  801ade:	55                   	push   %ebp
  801adf:	89 e5                	mov    %esp,%ebp
  801ae1:	53                   	push   %ebx
  801ae2:	83 ec 24             	sub    $0x24,%esp
  801ae5:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801ae8:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801aeb:	89 44 24 04          	mov    %eax,0x4(%esp)
  801aef:	89 1c 24             	mov    %ebx,(%esp)
  801af2:	e8 86 fd ff ff       	call   80187d <fd_lookup>
  801af7:	85 c0                	test   %eax,%eax
  801af9:	78 6b                	js     801b66 <read+0x88>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801afb:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801afe:	89 44 24 04          	mov    %eax,0x4(%esp)
  801b02:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801b05:	8b 00                	mov    (%eax),%eax
  801b07:	89 04 24             	mov    %eax,(%esp)
  801b0a:	e8 e2 fd ff ff       	call   8018f1 <dev_lookup>
{
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801b0f:	85 c0                	test   %eax,%eax
  801b11:	78 53                	js     801b66 <read+0x88>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  801b13:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801b16:	8b 42 08             	mov    0x8(%edx),%eax
  801b19:	83 e0 03             	and    $0x3,%eax
  801b1c:	83 f8 01             	cmp    $0x1,%eax
  801b1f:	75 23                	jne    801b44 <read+0x66>
		cprintf("[%08x] read %d -- bad mode\n", env->env_id, fdnum); 
  801b21:	a1 78 70 80 00       	mov    0x807078,%eax
  801b26:	8b 40 4c             	mov    0x4c(%eax),%eax
  801b29:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801b2d:	89 44 24 04          	mov    %eax,0x4(%esp)
  801b31:	c7 04 24 9a 36 80 00 	movl   $0x80369a,(%esp)
  801b38:	e8 0c e9 ff ff       	call   800449 <cprintf>
  801b3d:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
		return -E_INVAL;
  801b42:	eb 22                	jmp    801b66 <read+0x88>
	}
	if (!dev->dev_read)
  801b44:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801b47:	8b 48 08             	mov    0x8(%eax),%ecx
  801b4a:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801b4f:	85 c9                	test   %ecx,%ecx
  801b51:	74 13                	je     801b66 <read+0x88>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  801b53:	8b 45 10             	mov    0x10(%ebp),%eax
  801b56:	89 44 24 08          	mov    %eax,0x8(%esp)
  801b5a:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b5d:	89 44 24 04          	mov    %eax,0x4(%esp)
  801b61:	89 14 24             	mov    %edx,(%esp)
  801b64:	ff d1                	call   *%ecx
}
  801b66:	83 c4 24             	add    $0x24,%esp
  801b69:	5b                   	pop    %ebx
  801b6a:	5d                   	pop    %ebp
  801b6b:	c3                   	ret    

00801b6c <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  801b6c:	55                   	push   %ebp
  801b6d:	89 e5                	mov    %esp,%ebp
  801b6f:	57                   	push   %edi
  801b70:	56                   	push   %esi
  801b71:	53                   	push   %ebx
  801b72:	83 ec 1c             	sub    $0x1c,%esp
  801b75:	8b 7d 08             	mov    0x8(%ebp),%edi
  801b78:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  801b7b:	ba 00 00 00 00       	mov    $0x0,%edx
  801b80:	bb 00 00 00 00       	mov    $0x0,%ebx
  801b85:	b8 00 00 00 00       	mov    $0x0,%eax
  801b8a:	85 f6                	test   %esi,%esi
  801b8c:	74 29                	je     801bb7 <readn+0x4b>
		m = read(fdnum, (char*)buf + tot, n - tot);
  801b8e:	89 f0                	mov    %esi,%eax
  801b90:	29 d0                	sub    %edx,%eax
  801b92:	89 44 24 08          	mov    %eax,0x8(%esp)
  801b96:	03 55 0c             	add    0xc(%ebp),%edx
  801b99:	89 54 24 04          	mov    %edx,0x4(%esp)
  801b9d:	89 3c 24             	mov    %edi,(%esp)
  801ba0:	e8 39 ff ff ff       	call   801ade <read>
		if (m < 0)
  801ba5:	85 c0                	test   %eax,%eax
  801ba7:	78 0e                	js     801bb7 <readn+0x4b>
			return m;
		if (m == 0)
  801ba9:	85 c0                	test   %eax,%eax
  801bab:	74 08                	je     801bb5 <readn+0x49>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  801bad:	01 c3                	add    %eax,%ebx
  801baf:	89 da                	mov    %ebx,%edx
  801bb1:	39 f3                	cmp    %esi,%ebx
  801bb3:	72 d9                	jb     801b8e <readn+0x22>
  801bb5:	89 d8                	mov    %ebx,%eax
			return m;
		if (m == 0)
			break;
	}
	return tot;
}
  801bb7:	83 c4 1c             	add    $0x1c,%esp
  801bba:	5b                   	pop    %ebx
  801bbb:	5e                   	pop    %esi
  801bbc:	5f                   	pop    %edi
  801bbd:	5d                   	pop    %ebp
  801bbe:	c3                   	ret    

00801bbf <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  801bbf:	55                   	push   %ebp
  801bc0:	89 e5                	mov    %esp,%ebp
  801bc2:	56                   	push   %esi
  801bc3:	53                   	push   %ebx
  801bc4:	83 ec 20             	sub    $0x20,%esp
  801bc7:	8b 75 08             	mov    0x8(%ebp),%esi
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801bca:	89 34 24             	mov    %esi,(%esp)
  801bcd:	e8 0e fc ff ff       	call   8017e0 <fd2num>
  801bd2:	8d 55 f4             	lea    -0xc(%ebp),%edx
  801bd5:	89 54 24 04          	mov    %edx,0x4(%esp)
  801bd9:	89 04 24             	mov    %eax,(%esp)
  801bdc:	e8 9c fc ff ff       	call   80187d <fd_lookup>
  801be1:	89 c3                	mov    %eax,%ebx
  801be3:	85 c0                	test   %eax,%eax
  801be5:	78 05                	js     801bec <fd_close+0x2d>
  801be7:	3b 75 f4             	cmp    -0xc(%ebp),%esi
  801bea:	74 0c                	je     801bf8 <fd_close+0x39>
	    || fd != fd2)
		return (must_exist ? r : 0);
  801bec:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  801bf0:	19 c0                	sbb    %eax,%eax
  801bf2:	f7 d0                	not    %eax
  801bf4:	21 c3                	and    %eax,%ebx
  801bf6:	eb 3d                	jmp    801c35 <fd_close+0x76>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  801bf8:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801bfb:	89 44 24 04          	mov    %eax,0x4(%esp)
  801bff:	8b 06                	mov    (%esi),%eax
  801c01:	89 04 24             	mov    %eax,(%esp)
  801c04:	e8 e8 fc ff ff       	call   8018f1 <dev_lookup>
  801c09:	89 c3                	mov    %eax,%ebx
  801c0b:	85 c0                	test   %eax,%eax
  801c0d:	78 16                	js     801c25 <fd_close+0x66>
		if (dev->dev_close)
  801c0f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801c12:	8b 40 10             	mov    0x10(%eax),%eax
  801c15:	bb 00 00 00 00       	mov    $0x0,%ebx
  801c1a:	85 c0                	test   %eax,%eax
  801c1c:	74 07                	je     801c25 <fd_close+0x66>
			r = (*dev->dev_close)(fd);
  801c1e:	89 34 24             	mov    %esi,(%esp)
  801c21:	ff d0                	call   *%eax
  801c23:	89 c3                	mov    %eax,%ebx
		else
			r = 0;
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  801c25:	89 74 24 04          	mov    %esi,0x4(%esp)
  801c29:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801c30:	e8 0a f6 ff ff       	call   80123f <sys_page_unmap>
	return r;
}
  801c35:	89 d8                	mov    %ebx,%eax
  801c37:	83 c4 20             	add    $0x20,%esp
  801c3a:	5b                   	pop    %ebx
  801c3b:	5e                   	pop    %esi
  801c3c:	5d                   	pop    %ebp
  801c3d:	c3                   	ret    

00801c3e <close>:
	return -E_INVAL;
}

int
close(int fdnum)
{
  801c3e:	55                   	push   %ebp
  801c3f:	89 e5                	mov    %esp,%ebp
  801c41:	83 ec 28             	sub    $0x28,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801c44:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801c47:	89 44 24 04          	mov    %eax,0x4(%esp)
  801c4b:	8b 45 08             	mov    0x8(%ebp),%eax
  801c4e:	89 04 24             	mov    %eax,(%esp)
  801c51:	e8 27 fc ff ff       	call   80187d <fd_lookup>
  801c56:	85 c0                	test   %eax,%eax
  801c58:	78 13                	js     801c6d <close+0x2f>
		return r;
	else
		return fd_close(fd, 1);
  801c5a:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  801c61:	00 
  801c62:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c65:	89 04 24             	mov    %eax,(%esp)
  801c68:	e8 52 ff ff ff       	call   801bbf <fd_close>
}
  801c6d:	c9                   	leave  
  801c6e:	c3                   	ret    

00801c6f <stat>:
	return (*dev->dev_stat)(fd, stat);
}

int
stat(const char *path, struct Stat *stat)
{
  801c6f:	55                   	push   %ebp
  801c70:	89 e5                	mov    %esp,%ebp
  801c72:	83 ec 18             	sub    $0x18,%esp
  801c75:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  801c78:	89 75 fc             	mov    %esi,-0x4(%ebp)
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  801c7b:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  801c82:	00 
  801c83:	8b 45 08             	mov    0x8(%ebp),%eax
  801c86:	89 04 24             	mov    %eax,(%esp)
  801c89:	e8 55 03 00 00       	call   801fe3 <open>
  801c8e:	89 c3                	mov    %eax,%ebx
  801c90:	85 c0                	test   %eax,%eax
  801c92:	78 1b                	js     801caf <stat+0x40>
		return fd;
	r = fstat(fd, stat);
  801c94:	8b 45 0c             	mov    0xc(%ebp),%eax
  801c97:	89 44 24 04          	mov    %eax,0x4(%esp)
  801c9b:	89 1c 24             	mov    %ebx,(%esp)
  801c9e:	e8 b7 fc ff ff       	call   80195a <fstat>
  801ca3:	89 c6                	mov    %eax,%esi
	close(fd);
  801ca5:	89 1c 24             	mov    %ebx,(%esp)
  801ca8:	e8 91 ff ff ff       	call   801c3e <close>
  801cad:	89 f3                	mov    %esi,%ebx
	return r;
}
  801caf:	89 d8                	mov    %ebx,%eax
  801cb1:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  801cb4:	8b 75 fc             	mov    -0x4(%ebp),%esi
  801cb7:	89 ec                	mov    %ebp,%esp
  801cb9:	5d                   	pop    %ebp
  801cba:	c3                   	ret    

00801cbb <close_all>:
		return fd_close(fd, 1);
}

void
close_all(void)
{
  801cbb:	55                   	push   %ebp
  801cbc:	89 e5                	mov    %esp,%ebp
  801cbe:	53                   	push   %ebx
  801cbf:	83 ec 14             	sub    $0x14,%esp
  801cc2:	bb 00 00 00 00       	mov    $0x0,%ebx
	int i;
	for (i = 0; i < MAXFD; i++)
		close(i);
  801cc7:	89 1c 24             	mov    %ebx,(%esp)
  801cca:	e8 6f ff ff ff       	call   801c3e <close>

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  801ccf:	83 c3 01             	add    $0x1,%ebx
  801cd2:	83 fb 20             	cmp    $0x20,%ebx
  801cd5:	75 f0                	jne    801cc7 <close_all+0xc>
		close(i);
}
  801cd7:	83 c4 14             	add    $0x14,%esp
  801cda:	5b                   	pop    %ebx
  801cdb:	5d                   	pop    %ebp
  801cdc:	c3                   	ret    

00801cdd <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  801cdd:	55                   	push   %ebp
  801cde:	89 e5                	mov    %esp,%ebp
  801ce0:	83 ec 58             	sub    $0x58,%esp
  801ce3:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  801ce6:	89 75 f8             	mov    %esi,-0x8(%ebp)
  801ce9:	89 7d fc             	mov    %edi,-0x4(%ebp)
  801cec:	8b 7d 0c             	mov    0xc(%ebp),%edi
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  801cef:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  801cf2:	89 44 24 04          	mov    %eax,0x4(%esp)
  801cf6:	8b 45 08             	mov    0x8(%ebp),%eax
  801cf9:	89 04 24             	mov    %eax,(%esp)
  801cfc:	e8 7c fb ff ff       	call   80187d <fd_lookup>
  801d01:	89 c3                	mov    %eax,%ebx
  801d03:	85 c0                	test   %eax,%eax
  801d05:	0f 88 e0 00 00 00    	js     801deb <dup+0x10e>
		return r;
	close(newfdnum);
  801d0b:	89 3c 24             	mov    %edi,(%esp)
  801d0e:	e8 2b ff ff ff       	call   801c3e <close>

	newfd = INDEX2FD(newfdnum);
  801d13:	8d b7 00 00 0d 00    	lea    0xd0000(%edi),%esi
  801d19:	c1 e6 0c             	shl    $0xc,%esi
	ova = fd2data(oldfd);
  801d1c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801d1f:	89 04 24             	mov    %eax,(%esp)
  801d22:	e8 c9 fa ff ff       	call   8017f0 <fd2data>
  801d27:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  801d29:	89 34 24             	mov    %esi,(%esp)
  801d2c:	e8 bf fa ff ff       	call   8017f0 <fd2data>
  801d31:	89 45 d4             	mov    %eax,-0x2c(%ebp)

	if ((vpd[PDX(ova)] & PTE_P) && (vpt[VPN(ova)] & PTE_P))
  801d34:	89 da                	mov    %ebx,%edx
  801d36:	89 d8                	mov    %ebx,%eax
  801d38:	c1 e8 16             	shr    $0x16,%eax
  801d3b:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801d42:	a8 01                	test   $0x1,%al
  801d44:	74 43                	je     801d89 <dup+0xac>
  801d46:	c1 ea 0c             	shr    $0xc,%edx
  801d49:	8b 04 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%eax
  801d50:	a8 01                	test   $0x1,%al
  801d52:	74 35                	je     801d89 <dup+0xac>
		if ((r = sys_page_map(0, ova, 0, nva, vpt[VPN(ova)] & PTE_USER)) < 0)
  801d54:	8b 04 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%eax
  801d5b:	25 07 0e 00 00       	and    $0xe07,%eax
  801d60:	89 44 24 10          	mov    %eax,0x10(%esp)
  801d64:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801d67:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801d6b:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801d72:	00 
  801d73:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801d77:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801d7e:	e8 1a f5 ff ff       	call   80129d <sys_page_map>
  801d83:	89 c3                	mov    %eax,%ebx
  801d85:	85 c0                	test   %eax,%eax
  801d87:	78 3f                	js     801dc8 <dup+0xeb>
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, vpt[VPN(oldfd)] & PTE_USER)) < 0)
  801d89:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801d8c:	89 c2                	mov    %eax,%edx
  801d8e:	c1 ea 0c             	shr    $0xc,%edx
  801d91:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801d98:	81 e2 07 0e 00 00    	and    $0xe07,%edx
  801d9e:	89 54 24 10          	mov    %edx,0x10(%esp)
  801da2:	89 74 24 0c          	mov    %esi,0xc(%esp)
  801da6:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801dad:	00 
  801dae:	89 44 24 04          	mov    %eax,0x4(%esp)
  801db2:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801db9:	e8 df f4 ff ff       	call   80129d <sys_page_map>
  801dbe:	89 c3                	mov    %eax,%ebx
  801dc0:	85 c0                	test   %eax,%eax
  801dc2:	78 04                	js     801dc8 <dup+0xeb>
  801dc4:	89 fb                	mov    %edi,%ebx
  801dc6:	eb 23                	jmp    801deb <dup+0x10e>
		goto err;

	return newfdnum;

err:
	sys_page_unmap(0, newfd);
  801dc8:	89 74 24 04          	mov    %esi,0x4(%esp)
  801dcc:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801dd3:	e8 67 f4 ff ff       	call   80123f <sys_page_unmap>
	sys_page_unmap(0, nva);
  801dd8:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801ddb:	89 44 24 04          	mov    %eax,0x4(%esp)
  801ddf:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801de6:	e8 54 f4 ff ff       	call   80123f <sys_page_unmap>
	return r;
}
  801deb:	89 d8                	mov    %ebx,%eax
  801ded:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  801df0:	8b 75 f8             	mov    -0x8(%ebp),%esi
  801df3:	8b 7d fc             	mov    -0x4(%ebp),%edi
  801df6:	89 ec                	mov    %ebp,%esp
  801df8:	5d                   	pop    %ebp
  801df9:	c3                   	ret    
	...

00801dfc <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  801dfc:	55                   	push   %ebp
  801dfd:	89 e5                	mov    %esp,%ebp
  801dff:	53                   	push   %ebx
  801e00:	83 ec 14             	sub    $0x14,%esp
  801e03:	89 d3                	mov    %edx,%ebx
	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", env->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(envs[1].env_id, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  801e05:	8b 15 c8 00 c0 ee    	mov    0xeec000c8,%edx
  801e0b:	c7 44 24 0c 07 00 00 	movl   $0x7,0xc(%esp)
  801e12:	00 
  801e13:	c7 44 24 08 00 40 80 	movl   $0x804000,0x8(%esp)
  801e1a:	00 
  801e1b:	89 44 24 04          	mov    %eax,0x4(%esp)
  801e1f:	89 14 24             	mov    %edx,(%esp)
  801e22:	e8 d9 0d 00 00       	call   802c00 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  801e27:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801e2e:	00 
  801e2f:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801e33:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801e3a:	e8 27 0e 00 00       	call   802c66 <ipc_recv>
}
  801e3f:	83 c4 14             	add    $0x14,%esp
  801e42:	5b                   	pop    %ebx
  801e43:	5d                   	pop    %ebp
  801e44:	c3                   	ret    

00801e45 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  801e45:	55                   	push   %ebp
  801e46:	89 e5                	mov    %esp,%ebp
  801e48:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  801e4b:	8b 45 08             	mov    0x8(%ebp),%eax
  801e4e:	8b 40 0c             	mov    0xc(%eax),%eax
  801e51:	a3 00 40 80 00       	mov    %eax,0x804000
	fsipcbuf.set_size.req_size = newsize;
  801e56:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e59:	a3 04 40 80 00       	mov    %eax,0x804004
	return fsipc(FSREQ_SET_SIZE, NULL);
  801e5e:	ba 00 00 00 00       	mov    $0x0,%edx
  801e63:	b8 02 00 00 00       	mov    $0x2,%eax
  801e68:	e8 8f ff ff ff       	call   801dfc <fsipc>
}
  801e6d:	c9                   	leave  
  801e6e:	c3                   	ret    

00801e6f <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  801e6f:	55                   	push   %ebp
  801e70:	89 e5                	mov    %esp,%ebp
  801e72:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  801e75:	8b 45 08             	mov    0x8(%ebp),%eax
  801e78:	8b 40 0c             	mov    0xc(%eax),%eax
  801e7b:	a3 00 40 80 00       	mov    %eax,0x804000
	return fsipc(FSREQ_FLUSH, NULL);
  801e80:	ba 00 00 00 00       	mov    $0x0,%edx
  801e85:	b8 06 00 00 00       	mov    $0x6,%eax
  801e8a:	e8 6d ff ff ff       	call   801dfc <fsipc>
}
  801e8f:	c9                   	leave  
  801e90:	c3                   	ret    

00801e91 <sync>:
}

// Synchronize disk with buffer cache
int
sync(void)
{
  801e91:	55                   	push   %ebp
  801e92:	89 e5                	mov    %esp,%ebp
  801e94:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  801e97:	ba 00 00 00 00       	mov    $0x0,%edx
  801e9c:	b8 08 00 00 00       	mov    $0x8,%eax
  801ea1:	e8 56 ff ff ff       	call   801dfc <fsipc>
}
  801ea6:	c9                   	leave  
  801ea7:	c3                   	ret    

00801ea8 <devfile_stat>:
	return fsipc(FSREQ_WRITE, NULL);	
}

static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  801ea8:	55                   	push   %ebp
  801ea9:	89 e5                	mov    %esp,%ebp
  801eab:	53                   	push   %ebx
  801eac:	83 ec 14             	sub    $0x14,%esp
  801eaf:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  801eb2:	8b 45 08             	mov    0x8(%ebp),%eax
  801eb5:	8b 40 0c             	mov    0xc(%eax),%eax
  801eb8:	a3 00 40 80 00       	mov    %eax,0x804000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  801ebd:	ba 00 00 00 00       	mov    $0x0,%edx
  801ec2:	b8 05 00 00 00       	mov    $0x5,%eax
  801ec7:	e8 30 ff ff ff       	call   801dfc <fsipc>
  801ecc:	85 c0                	test   %eax,%eax
  801ece:	78 2b                	js     801efb <devfile_stat+0x53>
		return r;
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  801ed0:	c7 44 24 04 00 40 80 	movl   $0x804000,0x4(%esp)
  801ed7:	00 
  801ed8:	89 1c 24             	mov    %ebx,(%esp)
  801edb:	e8 2a ec ff ff       	call   800b0a <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  801ee0:	a1 80 40 80 00       	mov    0x804080,%eax
  801ee5:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  801eeb:	a1 84 40 80 00       	mov    0x804084,%eax
  801ef0:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
  801ef6:	b8 00 00 00 00       	mov    $0x0,%eax
	return 0;
}
  801efb:	83 c4 14             	add    $0x14,%esp
  801efe:	5b                   	pop    %ebx
  801eff:	5d                   	pop    %ebp
  801f00:	c3                   	ret    

00801f01 <devfile_write>:
// Returns:
//	 The number of bytes successfully written.
//	 < 0 on error.
static ssize_t
devfile_write(struct Fd *fd, const void *buf, size_t n)
{
  801f01:	55                   	push   %ebp
  801f02:	89 e5                	mov    %esp,%ebp
  801f04:	83 ec 18             	sub    $0x18,%esp
  801f07:	8b 45 10             	mov    0x10(%ebp),%eax
  801f0a:	3d f8 0f 00 00       	cmp    $0xff8,%eax
  801f0f:	76 05                	jbe    801f16 <devfile_write+0x15>
  801f11:	b8 f8 0f 00 00       	mov    $0xff8,%eax
	// LAB 5: Your code here
	//panic("devfile_write not implemented");
	
	if (n > (PGSIZE - (sizeof(int) + sizeof(size_t))))
		n = PGSIZE - (sizeof(int) + sizeof(size_t));
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  801f16:	8b 55 08             	mov    0x8(%ebp),%edx
  801f19:	8b 52 0c             	mov    0xc(%edx),%edx
  801f1c:	89 15 00 40 80 00    	mov    %edx,0x804000
	fsipcbuf.write.req_n = n;
  801f22:	a3 04 40 80 00       	mov    %eax,0x804004
	memmove (fsipcbuf.write.req_buf, (char*)buf, n);	
  801f27:	89 44 24 08          	mov    %eax,0x8(%esp)
  801f2b:	8b 45 0c             	mov    0xc(%ebp),%eax
  801f2e:	89 44 24 04          	mov    %eax,0x4(%esp)
  801f32:	c7 04 24 08 40 80 00 	movl   $0x804008,(%esp)
  801f39:	e8 87 ed ff ff       	call   800cc5 <memmove>
	return fsipc(FSREQ_WRITE, NULL);	
  801f3e:	ba 00 00 00 00       	mov    $0x0,%edx
  801f43:	b8 04 00 00 00       	mov    $0x4,%eax
  801f48:	e8 af fe ff ff       	call   801dfc <fsipc>
}
  801f4d:	c9                   	leave  
  801f4e:	c3                   	ret    

00801f4f <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  801f4f:	55                   	push   %ebp
  801f50:	89 e5                	mov    %esp,%ebp
  801f52:	53                   	push   %ebx
  801f53:	83 ec 14             	sub    $0x14,%esp
	// system server.
	// LAB 5: Your code here
	
	//panic("devfile_read not implemented");
	int r;
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  801f56:	8b 45 08             	mov    0x8(%ebp),%eax
  801f59:	8b 40 0c             	mov    0xc(%eax),%eax
  801f5c:	a3 00 40 80 00       	mov    %eax,0x804000
	fsipcbuf.read.req_n = n;
  801f61:	8b 45 10             	mov    0x10(%ebp),%eax
  801f64:	a3 04 40 80 00       	mov    %eax,0x804004
	if ((r = fsipc(FSREQ_READ, (void*)&fsipcbuf)) < 0)
  801f69:	ba 00 40 80 00       	mov    $0x804000,%edx
  801f6e:	b8 03 00 00 00       	mov    $0x3,%eax
  801f73:	e8 84 fe ff ff       	call   801dfc <fsipc>
  801f78:	89 c3                	mov    %eax,%ebx
  801f7a:	85 c0                	test   %eax,%eax
  801f7c:	78 17                	js     801f95 <devfile_read+0x46>
		return r;
	memmove((void*)buf, (void*)fsipcbuf.readRet.ret_buf, r);
  801f7e:	89 44 24 08          	mov    %eax,0x8(%esp)
  801f82:	c7 44 24 04 00 40 80 	movl   $0x804000,0x4(%esp)
  801f89:	00 
  801f8a:	8b 45 0c             	mov    0xc(%ebp),%eax
  801f8d:	89 04 24             	mov    %eax,(%esp)
  801f90:	e8 30 ed ff ff       	call   800cc5 <memmove>
	return r;
}
  801f95:	89 d8                	mov    %ebx,%eax
  801f97:	83 c4 14             	add    $0x14,%esp
  801f9a:	5b                   	pop    %ebx
  801f9b:	5d                   	pop    %ebp
  801f9c:	c3                   	ret    

00801f9d <remove>:
}

// Delete a file
int
remove(const char *path)
{
  801f9d:	55                   	push   %ebp
  801f9e:	89 e5                	mov    %esp,%ebp
  801fa0:	53                   	push   %ebx
  801fa1:	83 ec 14             	sub    $0x14,%esp
  801fa4:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (strlen(path) >= MAXPATHLEN)
  801fa7:	89 1c 24             	mov    %ebx,(%esp)
  801faa:	e8 11 eb ff ff       	call   800ac0 <strlen>
  801faf:	89 c2                	mov    %eax,%edx
  801fb1:	b8 f4 ff ff ff       	mov    $0xfffffff4,%eax
  801fb6:	81 fa ff 03 00 00    	cmp    $0x3ff,%edx
  801fbc:	7f 1f                	jg     801fdd <remove+0x40>
		return -E_BAD_PATH;
	strcpy(fsipcbuf.remove.req_path, path);
  801fbe:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801fc2:	c7 04 24 00 40 80 00 	movl   $0x804000,(%esp)
  801fc9:	e8 3c eb ff ff       	call   800b0a <strcpy>
	return fsipc(FSREQ_REMOVE, NULL);
  801fce:	ba 00 00 00 00       	mov    $0x0,%edx
  801fd3:	b8 07 00 00 00       	mov    $0x7,%eax
  801fd8:	e8 1f fe ff ff       	call   801dfc <fsipc>
}
  801fdd:	83 c4 14             	add    $0x14,%esp
  801fe0:	5b                   	pop    %ebx
  801fe1:	5d                   	pop    %ebp
  801fe2:	c3                   	ret    

00801fe3 <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  801fe3:	55                   	push   %ebp
  801fe4:	89 e5                	mov    %esp,%ebp
  801fe6:	83 ec 28             	sub    $0x28,%esp
  801fe9:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  801fec:	89 75 fc             	mov    %esi,-0x4(%ebp)
  801fef:	8b 75 08             	mov    0x8(%ebp),%esi
	// file descriptor.

	// LAB 5: Your code here.
	// Code added by Swastika / Sandeep
	
	if (strlen(path) >= MAXPATHLEN)
  801ff2:	89 34 24             	mov    %esi,(%esp)
  801ff5:	e8 c6 ea ff ff       	call   800ac0 <strlen>
  801ffa:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  801fff:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  802004:	7f 5e                	jg     802064 <open+0x81>
		return -E_BAD_PATH;
	struct Fd * fd;
	int  r;
	if ((r = fd_alloc(&fd)) < 0)
  802006:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802009:	89 04 24             	mov    %eax,(%esp)
  80200c:	e8 fa f7 ff ff       	call   80180b <fd_alloc>
  802011:	89 c3                	mov    %eax,%ebx
  802013:	85 c0                	test   %eax,%eax
  802015:	78 4d                	js     802064 <open+0x81>
		return r;
	strcpy (fsipcbuf.open.req_path, path);
  802017:	89 74 24 04          	mov    %esi,0x4(%esp)
  80201b:	c7 04 24 00 40 80 00 	movl   $0x804000,(%esp)
  802022:	e8 e3 ea ff ff       	call   800b0a <strcpy>
	fsipcbuf.open.req_omode = mode;	
  802027:	8b 45 0c             	mov    0xc(%ebp),%eax
  80202a:	a3 00 44 80 00       	mov    %eax,0x804400
	if ((r = fsipc(FSREQ_OPEN,(void*)fd)) < 0)
  80202f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802032:	b8 01 00 00 00       	mov    $0x1,%eax
  802037:	e8 c0 fd ff ff       	call   801dfc <fsipc>
  80203c:	89 c3                	mov    %eax,%ebx
  80203e:	85 c0                	test   %eax,%eax
  802040:	79 15                	jns    802057 <open+0x74>
	{
		fd_close(fd,0);
  802042:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  802049:	00 
  80204a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80204d:	89 04 24             	mov    %eax,(%esp)
  802050:	e8 6a fb ff ff       	call   801bbf <fd_close>
		return r; 
  802055:	eb 0d                	jmp    802064 <open+0x81>
	}
	return fd2num(fd);
  802057:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80205a:	89 04 24             	mov    %eax,(%esp)
  80205d:	e8 7e f7 ff ff       	call   8017e0 <fd2num>
  802062:	89 c3                	mov    %eax,%ebx
	//panic("open not implemented");
}
  802064:	89 d8                	mov    %ebx,%eax
  802066:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  802069:	8b 75 fc             	mov    -0x4(%ebp),%esi
  80206c:	89 ec                	mov    %ebp,%esp
  80206e:	5d                   	pop    %ebp
  80206f:	c3                   	ret    

00802070 <devsock_stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  802070:	55                   	push   %ebp
  802071:	89 e5                	mov    %esp,%ebp
  802073:	83 ec 18             	sub    $0x18,%esp
	strcpy(stat->st_name, "<sock>");
  802076:	c7 44 24 04 cc 36 80 	movl   $0x8036cc,0x4(%esp)
  80207d:	00 
  80207e:	8b 45 0c             	mov    0xc(%ebp),%eax
  802081:	89 04 24             	mov    %eax,(%esp)
  802084:	e8 81 ea ff ff       	call   800b0a <strcpy>
	return 0;
}
  802089:	b8 00 00 00 00       	mov    $0x0,%eax
  80208e:	c9                   	leave  
  80208f:	c3                   	ret    

00802090 <devsock_close>:
	return nsipc_shutdown(r, how);
}

static int
devsock_close(struct Fd *fd)
{
  802090:	55                   	push   %ebp
  802091:	89 e5                	mov    %esp,%ebp
  802093:	83 ec 18             	sub    $0x18,%esp
	return nsipc_close(fd->fd_sock.sockid);
  802096:	8b 45 08             	mov    0x8(%ebp),%eax
  802099:	8b 40 0c             	mov    0xc(%eax),%eax
  80209c:	89 04 24             	mov    %eax,(%esp)
  80209f:	e8 9e 02 00 00       	call   802342 <nsipc_close>
}
  8020a4:	c9                   	leave  
  8020a5:	c3                   	ret    

008020a6 <devsock_write>:
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
}

static ssize_t
devsock_write(struct Fd *fd, const void *buf, size_t n)
{
  8020a6:	55                   	push   %ebp
  8020a7:	89 e5                	mov    %esp,%ebp
  8020a9:	83 ec 18             	sub    $0x18,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  8020ac:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  8020b3:	00 
  8020b4:	8b 45 10             	mov    0x10(%ebp),%eax
  8020b7:	89 44 24 08          	mov    %eax,0x8(%esp)
  8020bb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8020be:	89 44 24 04          	mov    %eax,0x4(%esp)
  8020c2:	8b 45 08             	mov    0x8(%ebp),%eax
  8020c5:	8b 40 0c             	mov    0xc(%eax),%eax
  8020c8:	89 04 24             	mov    %eax,(%esp)
  8020cb:	e8 ae 02 00 00       	call   80237e <nsipc_send>
}
  8020d0:	c9                   	leave  
  8020d1:	c3                   	ret    

008020d2 <devsock_read>:
	return nsipc_listen(r, backlog);
}

static ssize_t
devsock_read(struct Fd *fd, void *buf, size_t n)
{
  8020d2:	55                   	push   %ebp
  8020d3:	89 e5                	mov    %esp,%ebp
  8020d5:	83 ec 18             	sub    $0x18,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  8020d8:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  8020df:	00 
  8020e0:	8b 45 10             	mov    0x10(%ebp),%eax
  8020e3:	89 44 24 08          	mov    %eax,0x8(%esp)
  8020e7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8020ea:	89 44 24 04          	mov    %eax,0x4(%esp)
  8020ee:	8b 45 08             	mov    0x8(%ebp),%eax
  8020f1:	8b 40 0c             	mov    0xc(%eax),%eax
  8020f4:	89 04 24             	mov    %eax,(%esp)
  8020f7:	e8 f5 02 00 00       	call   8023f1 <nsipc_recv>
}
  8020fc:	c9                   	leave  
  8020fd:	c3                   	ret    

008020fe <alloc_sockfd>:
	return sfd->fd_sock.sockid;
}

static int
alloc_sockfd(int sockid)
{
  8020fe:	55                   	push   %ebp
  8020ff:	89 e5                	mov    %esp,%ebp
  802101:	56                   	push   %esi
  802102:	53                   	push   %ebx
  802103:	83 ec 20             	sub    $0x20,%esp
  802106:	89 c6                	mov    %eax,%esi
	struct Fd *sfd;
	int r;

	if ((r = fd_alloc(&sfd)) < 0
  802108:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80210b:	89 04 24             	mov    %eax,(%esp)
  80210e:	e8 f8 f6 ff ff       	call   80180b <fd_alloc>
  802113:	89 c3                	mov    %eax,%ebx
  802115:	85 c0                	test   %eax,%eax
  802117:	78 21                	js     80213a <alloc_sockfd+0x3c>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U)) < 0) {
  802119:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  802120:	00 
  802121:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802124:	89 44 24 04          	mov    %eax,0x4(%esp)
  802128:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80212f:	e8 c7 f1 ff ff       	call   8012fb <sys_page_alloc>
  802134:	89 c3                	mov    %eax,%ebx
alloc_sockfd(int sockid)
{
	struct Fd *sfd;
	int r;

	if ((r = fd_alloc(&sfd)) < 0
  802136:	85 c0                	test   %eax,%eax
  802138:	79 0a                	jns    802144 <alloc_sockfd+0x46>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U)) < 0) {
		nsipc_close(sockid);
  80213a:	89 34 24             	mov    %esi,(%esp)
  80213d:	e8 00 02 00 00       	call   802342 <nsipc_close>
		return r;
  802142:	eb 28                	jmp    80216c <alloc_sockfd+0x6e>
	}

	sfd->fd_dev_id = devsock.dev_id;
  802144:	8b 15 24 70 80 00    	mov    0x807024,%edx
  80214a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80214d:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  80214f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802152:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	sfd->fd_sock.sockid = sockid;
  802159:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80215c:	89 70 0c             	mov    %esi,0xc(%eax)
	return fd2num(sfd);
  80215f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802162:	89 04 24             	mov    %eax,(%esp)
  802165:	e8 76 f6 ff ff       	call   8017e0 <fd2num>
  80216a:	89 c3                	mov    %eax,%ebx
}
  80216c:	89 d8                	mov    %ebx,%eax
  80216e:	83 c4 20             	add    $0x20,%esp
  802171:	5b                   	pop    %ebx
  802172:	5e                   	pop    %esi
  802173:	5d                   	pop    %ebp
  802174:	c3                   	ret    

00802175 <socket>:
	return 0;
}

int
socket(int domain, int type, int protocol)
{
  802175:	55                   	push   %ebp
  802176:	89 e5                	mov    %esp,%ebp
  802178:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  80217b:	8b 45 10             	mov    0x10(%ebp),%eax
  80217e:	89 44 24 08          	mov    %eax,0x8(%esp)
  802182:	8b 45 0c             	mov    0xc(%ebp),%eax
  802185:	89 44 24 04          	mov    %eax,0x4(%esp)
  802189:	8b 45 08             	mov    0x8(%ebp),%eax
  80218c:	89 04 24             	mov    %eax,(%esp)
  80218f:	e8 62 01 00 00       	call   8022f6 <nsipc_socket>
  802194:	85 c0                	test   %eax,%eax
  802196:	78 05                	js     80219d <socket+0x28>
		return r;
	return alloc_sockfd(r);
  802198:	e8 61 ff ff ff       	call   8020fe <alloc_sockfd>
}
  80219d:	c9                   	leave  
  80219e:	66 90                	xchg   %ax,%ax
  8021a0:	c3                   	ret    

008021a1 <fd2sockid>:
	.dev_stat =	devsock_stat,
};

static int
fd2sockid(int fd)
{
  8021a1:	55                   	push   %ebp
  8021a2:	89 e5                	mov    %esp,%ebp
  8021a4:	83 ec 28             	sub    $0x28,%esp
	struct Fd *sfd;
	int r;

	if ((r = fd_lookup(fd, &sfd)) < 0)
  8021a7:	8d 55 f4             	lea    -0xc(%ebp),%edx
  8021aa:	89 54 24 04          	mov    %edx,0x4(%esp)
  8021ae:	89 04 24             	mov    %eax,(%esp)
  8021b1:	e8 c7 f6 ff ff       	call   80187d <fd_lookup>
  8021b6:	85 c0                	test   %eax,%eax
  8021b8:	78 15                	js     8021cf <fd2sockid+0x2e>
		return r;
	if (sfd->fd_dev_id != devsock.dev_id)
  8021ba:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8021bd:	8b 0a                	mov    (%edx),%ecx
  8021bf:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8021c4:	3b 0d 24 70 80 00    	cmp    0x807024,%ecx
  8021ca:	75 03                	jne    8021cf <fd2sockid+0x2e>
		return -E_NOT_SUPP;
	return sfd->fd_sock.sockid;
  8021cc:	8b 42 0c             	mov    0xc(%edx),%eax
}
  8021cf:	c9                   	leave  
  8021d0:	c3                   	ret    

008021d1 <listen>:
	return nsipc_connect(r, name, namelen);
}

int
listen(int s, int backlog)
{
  8021d1:	55                   	push   %ebp
  8021d2:	89 e5                	mov    %esp,%ebp
  8021d4:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  8021d7:	8b 45 08             	mov    0x8(%ebp),%eax
  8021da:	e8 c2 ff ff ff       	call   8021a1 <fd2sockid>
  8021df:	85 c0                	test   %eax,%eax
  8021e1:	78 0f                	js     8021f2 <listen+0x21>
		return r;
	return nsipc_listen(r, backlog);
  8021e3:	8b 55 0c             	mov    0xc(%ebp),%edx
  8021e6:	89 54 24 04          	mov    %edx,0x4(%esp)
  8021ea:	89 04 24             	mov    %eax,(%esp)
  8021ed:	e8 2e 01 00 00       	call   802320 <nsipc_listen>
}
  8021f2:	c9                   	leave  
  8021f3:	c3                   	ret    

008021f4 <connect>:
	return nsipc_close(fd->fd_sock.sockid);
}

int
connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  8021f4:	55                   	push   %ebp
  8021f5:	89 e5                	mov    %esp,%ebp
  8021f7:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  8021fa:	8b 45 08             	mov    0x8(%ebp),%eax
  8021fd:	e8 9f ff ff ff       	call   8021a1 <fd2sockid>
  802202:	85 c0                	test   %eax,%eax
  802204:	78 16                	js     80221c <connect+0x28>
		return r;
	return nsipc_connect(r, name, namelen);
  802206:	8b 55 10             	mov    0x10(%ebp),%edx
  802209:	89 54 24 08          	mov    %edx,0x8(%esp)
  80220d:	8b 55 0c             	mov    0xc(%ebp),%edx
  802210:	89 54 24 04          	mov    %edx,0x4(%esp)
  802214:	89 04 24             	mov    %eax,(%esp)
  802217:	e8 55 02 00 00       	call   802471 <nsipc_connect>
}
  80221c:	c9                   	leave  
  80221d:	c3                   	ret    

0080221e <shutdown>:
	return nsipc_bind(r, name, namelen);
}

int
shutdown(int s, int how)
{
  80221e:	55                   	push   %ebp
  80221f:	89 e5                	mov    %esp,%ebp
  802221:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  802224:	8b 45 08             	mov    0x8(%ebp),%eax
  802227:	e8 75 ff ff ff       	call   8021a1 <fd2sockid>
  80222c:	85 c0                	test   %eax,%eax
  80222e:	78 0f                	js     80223f <shutdown+0x21>
		return r;
	return nsipc_shutdown(r, how);
  802230:	8b 55 0c             	mov    0xc(%ebp),%edx
  802233:	89 54 24 04          	mov    %edx,0x4(%esp)
  802237:	89 04 24             	mov    %eax,(%esp)
  80223a:	e8 1d 01 00 00       	call   80235c <nsipc_shutdown>
}
  80223f:	c9                   	leave  
  802240:	c3                   	ret    

00802241 <bind>:
	return alloc_sockfd(r);
}

int
bind(int s, struct sockaddr *name, socklen_t namelen)
{
  802241:	55                   	push   %ebp
  802242:	89 e5                	mov    %esp,%ebp
  802244:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  802247:	8b 45 08             	mov    0x8(%ebp),%eax
  80224a:	e8 52 ff ff ff       	call   8021a1 <fd2sockid>
  80224f:	85 c0                	test   %eax,%eax
  802251:	78 16                	js     802269 <bind+0x28>
		return r;
	return nsipc_bind(r, name, namelen);
  802253:	8b 55 10             	mov    0x10(%ebp),%edx
  802256:	89 54 24 08          	mov    %edx,0x8(%esp)
  80225a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80225d:	89 54 24 04          	mov    %edx,0x4(%esp)
  802261:	89 04 24             	mov    %eax,(%esp)
  802264:	e8 47 02 00 00       	call   8024b0 <nsipc_bind>
}
  802269:	c9                   	leave  
  80226a:	c3                   	ret    

0080226b <accept>:
	return fd2num(sfd);
}

int
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  80226b:	55                   	push   %ebp
  80226c:	89 e5                	mov    %esp,%ebp
  80226e:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  802271:	8b 45 08             	mov    0x8(%ebp),%eax
  802274:	e8 28 ff ff ff       	call   8021a1 <fd2sockid>
  802279:	85 c0                	test   %eax,%eax
  80227b:	78 1f                	js     80229c <accept+0x31>
		return r;
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  80227d:	8b 55 10             	mov    0x10(%ebp),%edx
  802280:	89 54 24 08          	mov    %edx,0x8(%esp)
  802284:	8b 55 0c             	mov    0xc(%ebp),%edx
  802287:	89 54 24 04          	mov    %edx,0x4(%esp)
  80228b:	89 04 24             	mov    %eax,(%esp)
  80228e:	e8 5c 02 00 00       	call   8024ef <nsipc_accept>
  802293:	85 c0                	test   %eax,%eax
  802295:	78 05                	js     80229c <accept+0x31>
		return r;
	return alloc_sockfd(r);
  802297:	e8 62 fe ff ff       	call   8020fe <alloc_sockfd>
}
  80229c:	c9                   	leave  
  80229d:	8d 76 00             	lea    0x0(%esi),%esi
  8022a0:	c3                   	ret    
	...

008022b0 <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  8022b0:	55                   	push   %ebp
  8022b1:	89 e5                	mov    %esp,%ebp
  8022b3:	83 ec 18             	sub    $0x18,%esp
	if (debug)
		cprintf("[%08x] nsipc %d\n", env->env_id, type);

	ipc_send(envs[2].env_id, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  8022b6:	8b 15 44 01 c0 ee    	mov    0xeec00144,%edx
  8022bc:	c7 44 24 0c 07 00 00 	movl   $0x7,0xc(%esp)
  8022c3:	00 
  8022c4:	c7 44 24 08 00 60 80 	movl   $0x806000,0x8(%esp)
  8022cb:	00 
  8022cc:	89 44 24 04          	mov    %eax,0x4(%esp)
  8022d0:	89 14 24             	mov    %edx,(%esp)
  8022d3:	e8 28 09 00 00       	call   802c00 <ipc_send>
	return ipc_recv(NULL, NULL, NULL);
  8022d8:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  8022df:	00 
  8022e0:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  8022e7:	00 
  8022e8:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8022ef:	e8 72 09 00 00       	call   802c66 <ipc_recv>
}
  8022f4:	c9                   	leave  
  8022f5:	c3                   	ret    

008022f6 <nsipc_socket>:
	return nsipc(NSREQ_SEND);
}

int
nsipc_socket(int domain, int type, int protocol)
{
  8022f6:	55                   	push   %ebp
  8022f7:	89 e5                	mov    %esp,%ebp
  8022f9:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  8022fc:	8b 45 08             	mov    0x8(%ebp),%eax
  8022ff:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.socket.req_type = type;
  802304:	8b 45 0c             	mov    0xc(%ebp),%eax
  802307:	a3 04 60 80 00       	mov    %eax,0x806004
	nsipcbuf.socket.req_protocol = protocol;
  80230c:	8b 45 10             	mov    0x10(%ebp),%eax
  80230f:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SOCKET);
  802314:	b8 09 00 00 00       	mov    $0x9,%eax
  802319:	e8 92 ff ff ff       	call   8022b0 <nsipc>
}
  80231e:	c9                   	leave  
  80231f:	c3                   	ret    

00802320 <nsipc_listen>:
	return nsipc(NSREQ_CONNECT);
}

int
nsipc_listen(int s, int backlog)
{
  802320:	55                   	push   %ebp
  802321:	89 e5                	mov    %esp,%ebp
  802323:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  802326:	8b 45 08             	mov    0x8(%ebp),%eax
  802329:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.listen.req_backlog = backlog;
  80232e:	8b 45 0c             	mov    0xc(%ebp),%eax
  802331:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_LISTEN);
  802336:	b8 06 00 00 00       	mov    $0x6,%eax
  80233b:	e8 70 ff ff ff       	call   8022b0 <nsipc>
}
  802340:	c9                   	leave  
  802341:	c3                   	ret    

00802342 <nsipc_close>:
	return nsipc(NSREQ_SHUTDOWN);
}

int
nsipc_close(int s)
{
  802342:	55                   	push   %ebp
  802343:	89 e5                	mov    %esp,%ebp
  802345:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  802348:	8b 45 08             	mov    0x8(%ebp),%eax
  80234b:	a3 00 60 80 00       	mov    %eax,0x806000
	return nsipc(NSREQ_CLOSE);
  802350:	b8 04 00 00 00       	mov    $0x4,%eax
  802355:	e8 56 ff ff ff       	call   8022b0 <nsipc>
}
  80235a:	c9                   	leave  
  80235b:	c3                   	ret    

0080235c <nsipc_shutdown>:
	return nsipc(NSREQ_BIND);
}

int
nsipc_shutdown(int s, int how)
{
  80235c:	55                   	push   %ebp
  80235d:	89 e5                	mov    %esp,%ebp
  80235f:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  802362:	8b 45 08             	mov    0x8(%ebp),%eax
  802365:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.shutdown.req_how = how;
  80236a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80236d:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_SHUTDOWN);
  802372:	b8 03 00 00 00       	mov    $0x3,%eax
  802377:	e8 34 ff ff ff       	call   8022b0 <nsipc>
}
  80237c:	c9                   	leave  
  80237d:	c3                   	ret    

0080237e <nsipc_send>:
	return r;
}

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  80237e:	55                   	push   %ebp
  80237f:	89 e5                	mov    %esp,%ebp
  802381:	53                   	push   %ebx
  802382:	83 ec 14             	sub    $0x14,%esp
  802385:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  802388:	8b 45 08             	mov    0x8(%ebp),%eax
  80238b:	a3 00 60 80 00       	mov    %eax,0x806000
	assert(size < 1600);
  802390:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  802396:	7e 24                	jle    8023bc <nsipc_send+0x3e>
  802398:	c7 44 24 0c d8 36 80 	movl   $0x8036d8,0xc(%esp)
  80239f:	00 
  8023a0:	c7 44 24 08 e4 36 80 	movl   $0x8036e4,0x8(%esp)
  8023a7:	00 
  8023a8:	c7 44 24 04 66 00 00 	movl   $0x66,0x4(%esp)
  8023af:	00 
  8023b0:	c7 04 24 f9 36 80 00 	movl   $0x8036f9,(%esp)
  8023b7:	e8 c8 df ff ff       	call   800384 <_panic>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  8023bc:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8023c0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8023c3:	89 44 24 04          	mov    %eax,0x4(%esp)
  8023c7:	c7 04 24 0c 60 80 00 	movl   $0x80600c,(%esp)
  8023ce:	e8 f2 e8 ff ff       	call   800cc5 <memmove>
	nsipcbuf.send.req_size = size;
  8023d3:	89 1d 04 60 80 00    	mov    %ebx,0x806004
	nsipcbuf.send.req_flags = flags;
  8023d9:	8b 45 14             	mov    0x14(%ebp),%eax
  8023dc:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SEND);
  8023e1:	b8 08 00 00 00       	mov    $0x8,%eax
  8023e6:	e8 c5 fe ff ff       	call   8022b0 <nsipc>
}
  8023eb:	83 c4 14             	add    $0x14,%esp
  8023ee:	5b                   	pop    %ebx
  8023ef:	5d                   	pop    %ebp
  8023f0:	c3                   	ret    

008023f1 <nsipc_recv>:
	return nsipc(NSREQ_LISTEN);
}

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  8023f1:	55                   	push   %ebp
  8023f2:	89 e5                	mov    %esp,%ebp
  8023f4:	56                   	push   %esi
  8023f5:	53                   	push   %ebx
  8023f6:	83 ec 10             	sub    $0x10,%esp
  8023f9:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  8023fc:	8b 45 08             	mov    0x8(%ebp),%eax
  8023ff:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.recv.req_len = len;
  802404:	89 35 04 60 80 00    	mov    %esi,0x806004
	nsipcbuf.recv.req_flags = flags;
  80240a:	8b 45 14             	mov    0x14(%ebp),%eax
  80240d:	a3 08 60 80 00       	mov    %eax,0x806008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  802412:	b8 07 00 00 00       	mov    $0x7,%eax
  802417:	e8 94 fe ff ff       	call   8022b0 <nsipc>
  80241c:	89 c3                	mov    %eax,%ebx
  80241e:	85 c0                	test   %eax,%eax
  802420:	78 46                	js     802468 <nsipc_recv+0x77>
		assert(r < 1600 && r <= len);
  802422:	3d 3f 06 00 00       	cmp    $0x63f,%eax
  802427:	7f 04                	jg     80242d <nsipc_recv+0x3c>
  802429:	39 c6                	cmp    %eax,%esi
  80242b:	7d 24                	jge    802451 <nsipc_recv+0x60>
  80242d:	c7 44 24 0c 05 37 80 	movl   $0x803705,0xc(%esp)
  802434:	00 
  802435:	c7 44 24 08 e4 36 80 	movl   $0x8036e4,0x8(%esp)
  80243c:	00 
  80243d:	c7 44 24 04 5b 00 00 	movl   $0x5b,0x4(%esp)
  802444:	00 
  802445:	c7 04 24 f9 36 80 00 	movl   $0x8036f9,(%esp)
  80244c:	e8 33 df ff ff       	call   800384 <_panic>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  802451:	89 44 24 08          	mov    %eax,0x8(%esp)
  802455:	c7 44 24 04 00 60 80 	movl   $0x806000,0x4(%esp)
  80245c:	00 
  80245d:	8b 45 0c             	mov    0xc(%ebp),%eax
  802460:	89 04 24             	mov    %eax,(%esp)
  802463:	e8 5d e8 ff ff       	call   800cc5 <memmove>
	}

	return r;
}
  802468:	89 d8                	mov    %ebx,%eax
  80246a:	83 c4 10             	add    $0x10,%esp
  80246d:	5b                   	pop    %ebx
  80246e:	5e                   	pop    %esi
  80246f:	5d                   	pop    %ebp
  802470:	c3                   	ret    

00802471 <nsipc_connect>:
	return nsipc(NSREQ_CLOSE);
}

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  802471:	55                   	push   %ebp
  802472:	89 e5                	mov    %esp,%ebp
  802474:	53                   	push   %ebx
  802475:	83 ec 14             	sub    $0x14,%esp
  802478:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  80247b:	8b 45 08             	mov    0x8(%ebp),%eax
  80247e:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  802483:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  802487:	8b 45 0c             	mov    0xc(%ebp),%eax
  80248a:	89 44 24 04          	mov    %eax,0x4(%esp)
  80248e:	c7 04 24 04 60 80 00 	movl   $0x806004,(%esp)
  802495:	e8 2b e8 ff ff       	call   800cc5 <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  80249a:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_CONNECT);
  8024a0:	b8 05 00 00 00       	mov    $0x5,%eax
  8024a5:	e8 06 fe ff ff       	call   8022b0 <nsipc>
}
  8024aa:	83 c4 14             	add    $0x14,%esp
  8024ad:	5b                   	pop    %ebx
  8024ae:	5d                   	pop    %ebp
  8024af:	c3                   	ret    

008024b0 <nsipc_bind>:
	return r;
}

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  8024b0:	55                   	push   %ebp
  8024b1:	89 e5                	mov    %esp,%ebp
  8024b3:	53                   	push   %ebx
  8024b4:	83 ec 14             	sub    $0x14,%esp
  8024b7:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  8024ba:	8b 45 08             	mov    0x8(%ebp),%eax
  8024bd:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  8024c2:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8024c6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8024c9:	89 44 24 04          	mov    %eax,0x4(%esp)
  8024cd:	c7 04 24 04 60 80 00 	movl   $0x806004,(%esp)
  8024d4:	e8 ec e7 ff ff       	call   800cc5 <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  8024d9:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_BIND);
  8024df:	b8 02 00 00 00       	mov    $0x2,%eax
  8024e4:	e8 c7 fd ff ff       	call   8022b0 <nsipc>
}
  8024e9:	83 c4 14             	add    $0x14,%esp
  8024ec:	5b                   	pop    %ebx
  8024ed:	5d                   	pop    %ebp
  8024ee:	c3                   	ret    

008024ef <nsipc_accept>:
	return ipc_recv(NULL, NULL, NULL);
}

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  8024ef:	55                   	push   %ebp
  8024f0:	89 e5                	mov    %esp,%ebp
  8024f2:	83 ec 18             	sub    $0x18,%esp
  8024f5:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  8024f8:	89 75 fc             	mov    %esi,-0x4(%ebp)
	int r;
	
	nsipcbuf.accept.req_s = s;
  8024fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8024fe:	a3 00 60 80 00       	mov    %eax,0x806000
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  802503:	b8 01 00 00 00       	mov    $0x1,%eax
  802508:	e8 a3 fd ff ff       	call   8022b0 <nsipc>
  80250d:	89 c3                	mov    %eax,%ebx
  80250f:	85 c0                	test   %eax,%eax
  802511:	78 25                	js     802538 <nsipc_accept+0x49>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  802513:	be 10 60 80 00       	mov    $0x806010,%esi
  802518:	8b 06                	mov    (%esi),%eax
  80251a:	89 44 24 08          	mov    %eax,0x8(%esp)
  80251e:	c7 44 24 04 00 60 80 	movl   $0x806000,0x4(%esp)
  802525:	00 
  802526:	8b 45 0c             	mov    0xc(%ebp),%eax
  802529:	89 04 24             	mov    %eax,(%esp)
  80252c:	e8 94 e7 ff ff       	call   800cc5 <memmove>
		*addrlen = ret->ret_addrlen;
  802531:	8b 16                	mov    (%esi),%edx
  802533:	8b 45 10             	mov    0x10(%ebp),%eax
  802536:	89 10                	mov    %edx,(%eax)
	}
	return r;
}
  802538:	89 d8                	mov    %ebx,%eax
  80253a:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  80253d:	8b 75 fc             	mov    -0x4(%ebp),%esi
  802540:	89 ec                	mov    %ebp,%esp
  802542:	5d                   	pop    %ebp
  802543:	c3                   	ret    
	...

00802550 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  802550:	55                   	push   %ebp
  802551:	89 e5                	mov    %esp,%ebp
  802553:	83 ec 18             	sub    $0x18,%esp
  802556:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  802559:	89 75 fc             	mov    %esi,-0x4(%ebp)
  80255c:	8b 75 0c             	mov    0xc(%ebp),%esi
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  80255f:	8b 45 08             	mov    0x8(%ebp),%eax
  802562:	89 04 24             	mov    %eax,(%esp)
  802565:	e8 86 f2 ff ff       	call   8017f0 <fd2data>
  80256a:	89 c3                	mov    %eax,%ebx
	strcpy(stat->st_name, "<pipe>");
  80256c:	c7 44 24 04 1a 37 80 	movl   $0x80371a,0x4(%esp)
  802573:	00 
  802574:	89 34 24             	mov    %esi,(%esp)
  802577:	e8 8e e5 ff ff       	call   800b0a <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  80257c:	8b 43 04             	mov    0x4(%ebx),%eax
  80257f:	2b 03                	sub    (%ebx),%eax
  802581:	89 86 80 00 00 00    	mov    %eax,0x80(%esi)
	stat->st_isdir = 0;
  802587:	c7 86 84 00 00 00 00 	movl   $0x0,0x84(%esi)
  80258e:	00 00 00 
	stat->st_dev = &devpipe;
  802591:	c7 86 88 00 00 00 40 	movl   $0x807040,0x88(%esi)
  802598:	70 80 00 
	return 0;
}
  80259b:	b8 00 00 00 00       	mov    $0x0,%eax
  8025a0:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  8025a3:	8b 75 fc             	mov    -0x4(%ebp),%esi
  8025a6:	89 ec                	mov    %ebp,%esp
  8025a8:	5d                   	pop    %ebp
  8025a9:	c3                   	ret    

008025aa <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  8025aa:	55                   	push   %ebp
  8025ab:	89 e5                	mov    %esp,%ebp
  8025ad:	53                   	push   %ebx
  8025ae:	83 ec 14             	sub    $0x14,%esp
  8025b1:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  8025b4:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8025b8:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8025bf:	e8 7b ec ff ff       	call   80123f <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  8025c4:	89 1c 24             	mov    %ebx,(%esp)
  8025c7:	e8 24 f2 ff ff       	call   8017f0 <fd2data>
  8025cc:	89 44 24 04          	mov    %eax,0x4(%esp)
  8025d0:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8025d7:	e8 63 ec ff ff       	call   80123f <sys_page_unmap>
}
  8025dc:	83 c4 14             	add    $0x14,%esp
  8025df:	5b                   	pop    %ebx
  8025e0:	5d                   	pop    %ebp
  8025e1:	c3                   	ret    

008025e2 <_pipeisclosed>:
	return r;
}

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  8025e2:	55                   	push   %ebp
  8025e3:	89 e5                	mov    %esp,%ebp
  8025e5:	57                   	push   %edi
  8025e6:	56                   	push   %esi
  8025e7:	53                   	push   %ebx
  8025e8:	83 ec 2c             	sub    $0x2c,%esp
  8025eb:	89 c7                	mov    %eax,%edi
  8025ed:	89 55 e4             	mov    %edx,-0x1c(%ebp)
	int n, nn, ret;

	while (1) {
		n = env->env_runs;
  8025f0:	a1 78 70 80 00       	mov    0x807078,%eax
  8025f5:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  8025f8:	89 3c 24             	mov    %edi,(%esp)
  8025fb:	e8 d0 06 00 00       	call   802cd0 <pageref>
  802600:	89 c6                	mov    %eax,%esi
  802602:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802605:	89 04 24             	mov    %eax,(%esp)
  802608:	e8 c3 06 00 00       	call   802cd0 <pageref>
  80260d:	39 c6                	cmp    %eax,%esi
  80260f:	0f 94 c0             	sete   %al
  802612:	0f b6 c0             	movzbl %al,%eax
		nn = env->env_runs;
  802615:	8b 15 78 70 80 00    	mov    0x807078,%edx
  80261b:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  80261e:	39 cb                	cmp    %ecx,%ebx
  802620:	75 08                	jne    80262a <_pipeisclosed+0x48>
			return ret;
		if (n != nn && ret == 1)
			cprintf("pipe race avoided\n", n, env->env_runs, ret);
	}
}
  802622:	83 c4 2c             	add    $0x2c,%esp
  802625:	5b                   	pop    %ebx
  802626:	5e                   	pop    %esi
  802627:	5f                   	pop    %edi
  802628:	5d                   	pop    %ebp
  802629:	c3                   	ret    
		n = env->env_runs;
		ret = pageref(fd) == pageref(p);
		nn = env->env_runs;
		if (n == nn)
			return ret;
		if (n != nn && ret == 1)
  80262a:	83 f8 01             	cmp    $0x1,%eax
  80262d:	75 c1                	jne    8025f0 <_pipeisclosed+0xe>
			cprintf("pipe race avoided\n", n, env->env_runs, ret);
  80262f:	8b 52 58             	mov    0x58(%edx),%edx
  802632:	89 44 24 0c          	mov    %eax,0xc(%esp)
  802636:	89 54 24 08          	mov    %edx,0x8(%esp)
  80263a:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  80263e:	c7 04 24 21 37 80 00 	movl   $0x803721,(%esp)
  802645:	e8 ff dd ff ff       	call   800449 <cprintf>
  80264a:	eb a4                	jmp    8025f0 <_pipeisclosed+0xe>

0080264c <devpipe_write>:
	return i;
}

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  80264c:	55                   	push   %ebp
  80264d:	89 e5                	mov    %esp,%ebp
  80264f:	57                   	push   %edi
  802650:	56                   	push   %esi
  802651:	53                   	push   %ebx
  802652:	83 ec 1c             	sub    $0x1c,%esp
  802655:	8b 75 08             	mov    0x8(%ebp),%esi
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  802658:	89 34 24             	mov    %esi,(%esp)
  80265b:	e8 90 f1 ff ff       	call   8017f0 <fd2data>
  802660:	89 c3                	mov    %eax,%ebx
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			env->env_id, vpt[VPN(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  802662:	bf 00 00 00 00       	mov    $0x0,%edi
  802667:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80266b:	75 54                	jne    8026c1 <devpipe_write+0x75>
  80266d:	eb 60                	jmp    8026cf <devpipe_write+0x83>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  80266f:	89 da                	mov    %ebx,%edx
  802671:	89 f0                	mov    %esi,%eax
  802673:	e8 6a ff ff ff       	call   8025e2 <_pipeisclosed>
  802678:	85 c0                	test   %eax,%eax
  80267a:	74 07                	je     802683 <devpipe_write+0x37>
  80267c:	b8 00 00 00 00       	mov    $0x0,%eax
  802681:	eb 53                	jmp    8026d6 <devpipe_write+0x8a>
				return 0;
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  802683:	90                   	nop
  802684:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802688:	e8 cd ec ff ff       	call   80135a <sys_yield>
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			env->env_id, vpt[VPN(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  80268d:	8b 43 04             	mov    0x4(%ebx),%eax
  802690:	8b 13                	mov    (%ebx),%edx
  802692:	83 c2 20             	add    $0x20,%edx
  802695:	39 d0                	cmp    %edx,%eax
  802697:	73 d6                	jae    80266f <devpipe_write+0x23>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  802699:	89 c2                	mov    %eax,%edx
  80269b:	c1 fa 1f             	sar    $0x1f,%edx
  80269e:	c1 ea 1b             	shr    $0x1b,%edx
  8026a1:	01 d0                	add    %edx,%eax
  8026a3:	83 e0 1f             	and    $0x1f,%eax
  8026a6:	29 d0                	sub    %edx,%eax
  8026a8:	89 c2                	mov    %eax,%edx
  8026aa:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8026ad:	0f b6 04 39          	movzbl (%ecx,%edi,1),%eax
  8026b1:	88 44 13 08          	mov    %al,0x8(%ebx,%edx,1)
		p->p_wpos++;
  8026b5:	83 43 04 01          	addl   $0x1,0x4(%ebx)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			env->env_id, vpt[VPN(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  8026b9:	83 c7 01             	add    $0x1,%edi
  8026bc:	39 7d 10             	cmp    %edi,0x10(%ebp)
  8026bf:	76 13                	jbe    8026d4 <devpipe_write+0x88>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  8026c1:	8b 43 04             	mov    0x4(%ebx),%eax
  8026c4:	8b 13                	mov    (%ebx),%edx
  8026c6:	83 c2 20             	add    $0x20,%edx
  8026c9:	39 d0                	cmp    %edx,%eax
  8026cb:	73 a2                	jae    80266f <devpipe_write+0x23>
  8026cd:	eb ca                	jmp    802699 <devpipe_write+0x4d>
  8026cf:	bf 00 00 00 00       	mov    $0x0,%edi
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}
	
	return i;
  8026d4:	89 f8                	mov    %edi,%eax
}
  8026d6:	83 c4 1c             	add    $0x1c,%esp
  8026d9:	5b                   	pop    %ebx
  8026da:	5e                   	pop    %esi
  8026db:	5f                   	pop    %edi
  8026dc:	5d                   	pop    %ebp
  8026dd:	c3                   	ret    

008026de <devpipe_read>:
	return _pipeisclosed(fd, p);
}

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  8026de:	55                   	push   %ebp
  8026df:	89 e5                	mov    %esp,%ebp
  8026e1:	83 ec 28             	sub    $0x28,%esp
  8026e4:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  8026e7:	89 75 f8             	mov    %esi,-0x8(%ebp)
  8026ea:	89 7d fc             	mov    %edi,-0x4(%ebp)
  8026ed:	8b 7d 08             	mov    0x8(%ebp),%edi
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  8026f0:	89 3c 24             	mov    %edi,(%esp)
  8026f3:	e8 f8 f0 ff ff       	call   8017f0 <fd2data>
  8026f8:	89 c3                	mov    %eax,%ebx
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			env->env_id, vpt[VPN(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  8026fa:	be 00 00 00 00       	mov    $0x0,%esi
  8026ff:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  802703:	75 4c                	jne    802751 <devpipe_read+0x73>
  802705:	eb 5b                	jmp    802762 <devpipe_read+0x84>
		while (p->p_rpos == p->p_wpos) {
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
				return i;
  802707:	89 f0                	mov    %esi,%eax
  802709:	eb 5e                	jmp    802769 <devpipe_read+0x8b>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  80270b:	89 da                	mov    %ebx,%edx
  80270d:	89 f8                	mov    %edi,%eax
  80270f:	90                   	nop
  802710:	e8 cd fe ff ff       	call   8025e2 <_pipeisclosed>
  802715:	85 c0                	test   %eax,%eax
  802717:	74 07                	je     802720 <devpipe_read+0x42>
  802719:	b8 00 00 00 00       	mov    $0x0,%eax
  80271e:	eb 49                	jmp    802769 <devpipe_read+0x8b>
				return 0;
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  802720:	e8 35 ec ff ff       	call   80135a <sys_yield>
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			env->env_id, vpt[VPN(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  802725:	8b 03                	mov    (%ebx),%eax
  802727:	3b 43 04             	cmp    0x4(%ebx),%eax
  80272a:	74 df                	je     80270b <devpipe_read+0x2d>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  80272c:	89 c2                	mov    %eax,%edx
  80272e:	c1 fa 1f             	sar    $0x1f,%edx
  802731:	c1 ea 1b             	shr    $0x1b,%edx
  802734:	01 d0                	add    %edx,%eax
  802736:	83 e0 1f             	and    $0x1f,%eax
  802739:	29 d0                	sub    %edx,%eax
  80273b:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  802740:	8b 55 0c             	mov    0xc(%ebp),%edx
  802743:	88 04 32             	mov    %al,(%edx,%esi,1)
		p->p_rpos++;
  802746:	83 03 01             	addl   $0x1,(%ebx)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			env->env_id, vpt[VPN(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  802749:	83 c6 01             	add    $0x1,%esi
  80274c:	39 75 10             	cmp    %esi,0x10(%ebp)
  80274f:	76 16                	jbe    802767 <devpipe_read+0x89>
		while (p->p_rpos == p->p_wpos) {
  802751:	8b 03                	mov    (%ebx),%eax
  802753:	3b 43 04             	cmp    0x4(%ebx),%eax
  802756:	75 d4                	jne    80272c <devpipe_read+0x4e>
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  802758:	85 f6                	test   %esi,%esi
  80275a:	75 ab                	jne    802707 <devpipe_read+0x29>
  80275c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802760:	eb a9                	jmp    80270b <devpipe_read+0x2d>
  802762:	be 00 00 00 00       	mov    $0x0,%esi
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  802767:	89 f0                	mov    %esi,%eax
}
  802769:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  80276c:	8b 75 f8             	mov    -0x8(%ebp),%esi
  80276f:	8b 7d fc             	mov    -0x4(%ebp),%edi
  802772:	89 ec                	mov    %ebp,%esp
  802774:	5d                   	pop    %ebp
  802775:	c3                   	ret    

00802776 <pipeisclosed>:
	}
}

int
pipeisclosed(int fdnum)
{
  802776:	55                   	push   %ebp
  802777:	89 e5                	mov    %esp,%ebp
  802779:	83 ec 28             	sub    $0x28,%esp
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80277c:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80277f:	89 44 24 04          	mov    %eax,0x4(%esp)
  802783:	8b 45 08             	mov    0x8(%ebp),%eax
  802786:	89 04 24             	mov    %eax,(%esp)
  802789:	e8 ef f0 ff ff       	call   80187d <fd_lookup>
  80278e:	85 c0                	test   %eax,%eax
  802790:	78 15                	js     8027a7 <pipeisclosed+0x31>
		return r;
	p = (struct Pipe*) fd2data(fd);
  802792:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802795:	89 04 24             	mov    %eax,(%esp)
  802798:	e8 53 f0 ff ff       	call   8017f0 <fd2data>
	return _pipeisclosed(fd, p);
  80279d:	89 c2                	mov    %eax,%edx
  80279f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027a2:	e8 3b fe ff ff       	call   8025e2 <_pipeisclosed>
}
  8027a7:	c9                   	leave  
  8027a8:	c3                   	ret    

008027a9 <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  8027a9:	55                   	push   %ebp
  8027aa:	89 e5                	mov    %esp,%ebp
  8027ac:	83 ec 48             	sub    $0x48,%esp
  8027af:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  8027b2:	89 75 f8             	mov    %esi,-0x8(%ebp)
  8027b5:	89 7d fc             	mov    %edi,-0x4(%ebp)
  8027b8:	8b 7d 08             	mov    0x8(%ebp),%edi
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  8027bb:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  8027be:	89 04 24             	mov    %eax,(%esp)
  8027c1:	e8 45 f0 ff ff       	call   80180b <fd_alloc>
  8027c6:	89 c3                	mov    %eax,%ebx
  8027c8:	85 c0                	test   %eax,%eax
  8027ca:	0f 88 42 01 00 00    	js     802912 <pipe+0x169>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8027d0:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  8027d7:	00 
  8027d8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8027db:	89 44 24 04          	mov    %eax,0x4(%esp)
  8027df:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8027e6:	e8 10 eb ff ff       	call   8012fb <sys_page_alloc>
  8027eb:	89 c3                	mov    %eax,%ebx
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  8027ed:	85 c0                	test   %eax,%eax
  8027ef:	0f 88 1d 01 00 00    	js     802912 <pipe+0x169>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  8027f5:	8d 45 e0             	lea    -0x20(%ebp),%eax
  8027f8:	89 04 24             	mov    %eax,(%esp)
  8027fb:	e8 0b f0 ff ff       	call   80180b <fd_alloc>
  802800:	89 c3                	mov    %eax,%ebx
  802802:	85 c0                	test   %eax,%eax
  802804:	0f 88 f5 00 00 00    	js     8028ff <pipe+0x156>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80280a:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  802811:	00 
  802812:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802815:	89 44 24 04          	mov    %eax,0x4(%esp)
  802819:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802820:	e8 d6 ea ff ff       	call   8012fb <sys_page_alloc>
  802825:	89 c3                	mov    %eax,%ebx
	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  802827:	85 c0                	test   %eax,%eax
  802829:	0f 88 d0 00 00 00    	js     8028ff <pipe+0x156>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  80282f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802832:	89 04 24             	mov    %eax,(%esp)
  802835:	e8 b6 ef ff ff       	call   8017f0 <fd2data>
  80283a:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80283c:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  802843:	00 
  802844:	89 44 24 04          	mov    %eax,0x4(%esp)
  802848:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80284f:	e8 a7 ea ff ff       	call   8012fb <sys_page_alloc>
  802854:	89 c3                	mov    %eax,%ebx
  802856:	85 c0                	test   %eax,%eax
  802858:	0f 88 8e 00 00 00    	js     8028ec <pipe+0x143>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80285e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802861:	89 04 24             	mov    %eax,(%esp)
  802864:	e8 87 ef ff ff       	call   8017f0 <fd2data>
  802869:	c7 44 24 10 07 04 00 	movl   $0x407,0x10(%esp)
  802870:	00 
  802871:	89 44 24 0c          	mov    %eax,0xc(%esp)
  802875:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  80287c:	00 
  80287d:	89 74 24 04          	mov    %esi,0x4(%esp)
  802881:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802888:	e8 10 ea ff ff       	call   80129d <sys_page_map>
  80288d:	89 c3                	mov    %eax,%ebx
  80288f:	85 c0                	test   %eax,%eax
  802891:	78 49                	js     8028dc <pipe+0x133>
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  802893:	b8 40 70 80 00       	mov    $0x807040,%eax
  802898:	8b 08                	mov    (%eax),%ecx
  80289a:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80289d:	89 0a                	mov    %ecx,(%edx)
	fd0->fd_omode = O_RDONLY;
  80289f:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8028a2:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%edx)

	fd1->fd_dev_id = devpipe.dev_id;
  8028a9:	8b 10                	mov    (%eax),%edx
  8028ab:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8028ae:	89 10                	mov    %edx,(%eax)
	fd1->fd_omode = O_WRONLY;
  8028b0:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8028b3:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", env->env_id, vpt[VPN(va)]);

	pfd[0] = fd2num(fd0);
  8028ba:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8028bd:	89 04 24             	mov    %eax,(%esp)
  8028c0:	e8 1b ef ff ff       	call   8017e0 <fd2num>
  8028c5:	89 07                	mov    %eax,(%edi)
	pfd[1] = fd2num(fd1);
  8028c7:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8028ca:	89 04 24             	mov    %eax,(%esp)
  8028cd:	e8 0e ef ff ff       	call   8017e0 <fd2num>
  8028d2:	89 47 04             	mov    %eax,0x4(%edi)
  8028d5:	bb 00 00 00 00       	mov    $0x0,%ebx
	return 0;
  8028da:	eb 36                	jmp    802912 <pipe+0x169>

    err3:
	sys_page_unmap(0, va);
  8028dc:	89 74 24 04          	mov    %esi,0x4(%esp)
  8028e0:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8028e7:	e8 53 e9 ff ff       	call   80123f <sys_page_unmap>
    err2:
	sys_page_unmap(0, fd1);
  8028ec:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8028ef:	89 44 24 04          	mov    %eax,0x4(%esp)
  8028f3:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8028fa:	e8 40 e9 ff ff       	call   80123f <sys_page_unmap>
    err1:
	sys_page_unmap(0, fd0);
  8028ff:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802902:	89 44 24 04          	mov    %eax,0x4(%esp)
  802906:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80290d:	e8 2d e9 ff ff       	call   80123f <sys_page_unmap>
    err:
	return r;
}
  802912:	89 d8                	mov    %ebx,%eax
  802914:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  802917:	8b 75 f8             	mov    -0x8(%ebp),%esi
  80291a:	8b 7d fc             	mov    -0x4(%ebp),%edi
  80291d:	89 ec                	mov    %ebp,%esp
  80291f:	5d                   	pop    %ebp
  802920:	c3                   	ret    
  802921:	00 00                	add    %al,(%eax)
	...

00802924 <wait>:
#include <inc/lib.h>

// Waits until 'envid' exits.
void
wait(envid_t envid)
{
  802924:	55                   	push   %ebp
  802925:	89 e5                	mov    %esp,%ebp
  802927:	56                   	push   %esi
  802928:	53                   	push   %ebx
  802929:	83 ec 10             	sub    $0x10,%esp
  80292c:	8b 45 08             	mov    0x8(%ebp),%eax
	volatile struct Env *e;

	assert(envid != 0);
  80292f:	85 c0                	test   %eax,%eax
  802931:	75 24                	jne    802957 <wait+0x33>
  802933:	c7 44 24 0c 39 37 80 	movl   $0x803739,0xc(%esp)
  80293a:	00 
  80293b:	c7 44 24 08 e4 36 80 	movl   $0x8036e4,0x8(%esp)
  802942:	00 
  802943:	c7 44 24 04 09 00 00 	movl   $0x9,0x4(%esp)
  80294a:	00 
  80294b:	c7 04 24 44 37 80 00 	movl   $0x803744,(%esp)
  802952:	e8 2d da ff ff       	call   800384 <_panic>
	e = &envs[ENVX(envid)];
  802957:	89 c3                	mov    %eax,%ebx
  802959:	81 e3 ff 03 00 00    	and    $0x3ff,%ebx
  80295f:	6b db 7c             	imul   $0x7c,%ebx,%ebx
  802962:	81 c3 00 00 c0 ee    	add    $0xeec00000,%ebx
	while (e->env_id == envid && e->env_status != ENV_FREE)
  802968:	8b 73 4c             	mov    0x4c(%ebx),%esi
  80296b:	39 c6                	cmp    %eax,%esi
  80296d:	75 1a                	jne    802989 <wait+0x65>
  80296f:	8b 43 54             	mov    0x54(%ebx),%eax
  802972:	85 c0                	test   %eax,%eax
  802974:	74 13                	je     802989 <wait+0x65>
		sys_yield();
  802976:	e8 df e9 ff ff       	call   80135a <sys_yield>
{
	volatile struct Env *e;

	assert(envid != 0);
	e = &envs[ENVX(envid)];
	while (e->env_id == envid && e->env_status != ENV_FREE)
  80297b:	8b 43 4c             	mov    0x4c(%ebx),%eax
  80297e:	39 f0                	cmp    %esi,%eax
  802980:	75 07                	jne    802989 <wait+0x65>
  802982:	8b 43 54             	mov    0x54(%ebx),%eax
  802985:	85 c0                	test   %eax,%eax
  802987:	75 ed                	jne    802976 <wait+0x52>
		sys_yield();
}
  802989:	83 c4 10             	add    $0x10,%esp
  80298c:	5b                   	pop    %ebx
  80298d:	5e                   	pop    %esi
  80298e:	5d                   	pop    %ebp
  80298f:	c3                   	ret    

00802990 <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  802990:	55                   	push   %ebp
  802991:	89 e5                	mov    %esp,%ebp
	USED(fd);

	return 0;
}
  802993:	b8 00 00 00 00       	mov    $0x0,%eax
  802998:	5d                   	pop    %ebp
  802999:	c3                   	ret    

0080299a <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  80299a:	55                   	push   %ebp
  80299b:	89 e5                	mov    %esp,%ebp
  80299d:	83 ec 18             	sub    $0x18,%esp
	strcpy(stat->st_name, "<cons>");
  8029a0:	c7 44 24 04 4f 37 80 	movl   $0x80374f,0x4(%esp)
  8029a7:	00 
  8029a8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8029ab:	89 04 24             	mov    %eax,(%esp)
  8029ae:	e8 57 e1 ff ff       	call   800b0a <strcpy>
	return 0;
}
  8029b3:	b8 00 00 00 00       	mov    $0x0,%eax
  8029b8:	c9                   	leave  
  8029b9:	c3                   	ret    

008029ba <devcons_write>:
	return 1;
}

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  8029ba:	55                   	push   %ebp
  8029bb:	89 e5                	mov    %esp,%ebp
  8029bd:	57                   	push   %edi
  8029be:	56                   	push   %esi
  8029bf:	53                   	push   %ebx
  8029c0:	81 ec 9c 00 00 00    	sub    $0x9c,%esp
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs, 
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  8029c6:	b8 00 00 00 00       	mov    $0x0,%eax
  8029cb:	be 00 00 00 00       	mov    $0x0,%esi
  8029d0:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8029d4:	74 3f                	je     802a15 <devcons_write+0x5b>
		m = n - tot;
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  8029d6:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs, 
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
		m = n - tot;
  8029dc:	8b 55 10             	mov    0x10(%ebp),%edx
  8029df:	29 c2                	sub    %eax,%edx
  8029e1:	89 d3                	mov    %edx,%ebx
		if (m > sizeof(buf) - 1)
  8029e3:	83 fa 7f             	cmp    $0x7f,%edx
  8029e6:	76 05                	jbe    8029ed <devcons_write+0x33>
  8029e8:	bb 7f 00 00 00       	mov    $0x7f,%ebx
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  8029ed:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8029f1:	03 45 0c             	add    0xc(%ebp),%eax
  8029f4:	89 44 24 04          	mov    %eax,0x4(%esp)
  8029f8:	89 3c 24             	mov    %edi,(%esp)
  8029fb:	e8 c5 e2 ff ff       	call   800cc5 <memmove>
		sys_cputs(buf, m);
  802a00:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  802a04:	89 3c 24             	mov    %edi,(%esp)
  802a07:	e8 f4 e4 ff ff       	call   800f00 <sys_cputs>
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs, 
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  802a0c:	01 de                	add    %ebx,%esi
  802a0e:	89 f0                	mov    %esi,%eax
  802a10:	3b 75 10             	cmp    0x10(%ebp),%esi
  802a13:	72 c7                	jb     8029dc <devcons_write+0x22>
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
}
  802a15:	89 f0                	mov    %esi,%eax
  802a17:	81 c4 9c 00 00 00    	add    $0x9c,%esp
  802a1d:	5b                   	pop    %ebx
  802a1e:	5e                   	pop    %esi
  802a1f:	5f                   	pop    %edi
  802a20:	5d                   	pop    %ebp
  802a21:	c3                   	ret    

00802a22 <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  802a22:	55                   	push   %ebp
  802a23:	89 e5                	mov    %esp,%ebp
  802a25:	83 ec 28             	sub    $0x28,%esp
	char c = ch;
  802a28:	8b 45 08             	mov    0x8(%ebp),%eax
  802a2b:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  802a2e:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  802a35:	00 
  802a36:	8d 45 f7             	lea    -0x9(%ebp),%eax
  802a39:	89 04 24             	mov    %eax,(%esp)
  802a3c:	e8 bf e4 ff ff       	call   800f00 <sys_cputs>
}
  802a41:	c9                   	leave  
  802a42:	c3                   	ret    

00802a43 <devcons_read>:
	return fd2num(fd);
}

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  802a43:	55                   	push   %ebp
  802a44:	89 e5                	mov    %esp,%ebp
  802a46:	83 ec 08             	sub    $0x8,%esp
	int c;

	if (n == 0)
  802a49:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  802a4d:	75 07                	jne    802a56 <devcons_read+0x13>
  802a4f:	eb 28                	jmp    802a79 <devcons_read+0x36>
		return 0;

	while ((c = sys_cgetc()) == 0)
		sys_yield();
  802a51:	e8 04 e9 ff ff       	call   80135a <sys_yield>
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  802a56:	66 90                	xchg   %ax,%ax
  802a58:	e8 6f e4 ff ff       	call   800ecc <sys_cgetc>
  802a5d:	85 c0                	test   %eax,%eax
  802a5f:	90                   	nop
  802a60:	74 ef                	je     802a51 <devcons_read+0xe>
  802a62:	89 c2                	mov    %eax,%edx
		sys_yield();
	if (c < 0)
  802a64:	85 c0                	test   %eax,%eax
  802a66:	78 16                	js     802a7e <devcons_read+0x3b>
		return c;
	if (c == 0x04)	// ctl-d is eof
  802a68:	83 f8 04             	cmp    $0x4,%eax
  802a6b:	74 0c                	je     802a79 <devcons_read+0x36>
		return 0;
	*(char*)vbuf = c;
  802a6d:	8b 45 0c             	mov    0xc(%ebp),%eax
  802a70:	88 10                	mov    %dl,(%eax)
  802a72:	b8 01 00 00 00       	mov    $0x1,%eax
	return 1;
  802a77:	eb 05                	jmp    802a7e <devcons_read+0x3b>
  802a79:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802a7e:	c9                   	leave  
  802a7f:	c3                   	ret    

00802a80 <opencons>:
	return fd->fd_dev_id == devcons.dev_id;
}

int
opencons(void)
{
  802a80:	55                   	push   %ebp
  802a81:	89 e5                	mov    %esp,%ebp
  802a83:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  802a86:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802a89:	89 04 24             	mov    %eax,(%esp)
  802a8c:	e8 7a ed ff ff       	call   80180b <fd_alloc>
  802a91:	85 c0                	test   %eax,%eax
  802a93:	78 3f                	js     802ad4 <opencons+0x54>
		return r;
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  802a95:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  802a9c:	00 
  802a9d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802aa0:	89 44 24 04          	mov    %eax,0x4(%esp)
  802aa4:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802aab:	e8 4b e8 ff ff       	call   8012fb <sys_page_alloc>
  802ab0:	85 c0                	test   %eax,%eax
  802ab2:	78 20                	js     802ad4 <opencons+0x54>
		return r;
	fd->fd_dev_id = devcons.dev_id;
  802ab4:	8b 15 5c 70 80 00    	mov    0x80705c,%edx
  802aba:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802abd:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  802abf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ac2:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  802ac9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802acc:	89 04 24             	mov    %eax,(%esp)
  802acf:	e8 0c ed ff ff       	call   8017e0 <fd2num>
}
  802ad4:	c9                   	leave  
  802ad5:	c3                   	ret    

00802ad6 <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  802ad6:	55                   	push   %ebp
  802ad7:	89 e5                	mov    %esp,%ebp
  802ad9:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802adc:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802adf:	89 44 24 04          	mov    %eax,0x4(%esp)
  802ae3:	8b 45 08             	mov    0x8(%ebp),%eax
  802ae6:	89 04 24             	mov    %eax,(%esp)
  802ae9:	e8 8f ed ff ff       	call   80187d <fd_lookup>
  802aee:	85 c0                	test   %eax,%eax
  802af0:	78 11                	js     802b03 <iscons+0x2d>
		return r;
	return fd->fd_dev_id == devcons.dev_id;
  802af2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802af5:	8b 00                	mov    (%eax),%eax
  802af7:	3b 05 5c 70 80 00    	cmp    0x80705c,%eax
  802afd:	0f 94 c0             	sete   %al
  802b00:	0f b6 c0             	movzbl %al,%eax
}
  802b03:	c9                   	leave  
  802b04:	c3                   	ret    

00802b05 <getchar>:
	sys_cputs(&c, 1);
}

int
getchar(void)
{
  802b05:	55                   	push   %ebp
  802b06:	89 e5                	mov    %esp,%ebp
  802b08:	83 ec 28             	sub    $0x28,%esp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  802b0b:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  802b12:	00 
  802b13:	8d 45 f7             	lea    -0x9(%ebp),%eax
  802b16:	89 44 24 04          	mov    %eax,0x4(%esp)
  802b1a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802b21:	e8 b8 ef ff ff       	call   801ade <read>
	if (r < 0)
  802b26:	85 c0                	test   %eax,%eax
  802b28:	78 0f                	js     802b39 <getchar+0x34>
		return r;
	if (r < 1)
  802b2a:	85 c0                	test   %eax,%eax
  802b2c:	7f 07                	jg     802b35 <getchar+0x30>
  802b2e:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  802b33:	eb 04                	jmp    802b39 <getchar+0x34>
		return -E_EOF;
	return c;
  802b35:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  802b39:	c9                   	leave  
  802b3a:	c3                   	ret    
	...

00802b3c <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  802b3c:	55                   	push   %ebp
  802b3d:	89 e5                	mov    %esp,%ebp
  802b3f:	83 ec 18             	sub    $0x18,%esp
	int r;

	if (_pgfault_handler == 0) {
  802b42:	83 3d 80 70 80 00 00 	cmpl   $0x0,0x807080
  802b49:	75 78                	jne    802bc3 <set_pgfault_handler+0x87>
		// First time through!
		// LAB 4: Your code here.
		// panic("set_pgfault_handler not implemented");
		int ret;	
		if ((ret = sys_page_alloc(0, (void*)(UXSTACKTOP - PGSIZE), PTE_U | PTE_P | PTE_W)) < 0)
  802b4b:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  802b52:	00 
  802b53:	c7 44 24 04 00 f0 bf 	movl   $0xeebff000,0x4(%esp)
  802b5a:	ee 
  802b5b:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802b62:	e8 94 e7 ff ff       	call   8012fb <sys_page_alloc>
  802b67:	85 c0                	test   %eax,%eax
  802b69:	79 20                	jns    802b8b <set_pgfault_handler+0x4f>
			panic (" error in sys_page_alloc: %e\n", ret);
  802b6b:	89 44 24 0c          	mov    %eax,0xc(%esp)
  802b6f:	c7 44 24 08 5b 37 80 	movl   $0x80375b,0x8(%esp)
  802b76:	00 
  802b77:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  802b7e:	00 
  802b7f:	c7 04 24 79 37 80 00 	movl   $0x803779,(%esp)
  802b86:	e8 f9 d7 ff ff       	call   800384 <_panic>
		if ((ret = sys_env_set_pgfault_upcall(0, _pgfault_upcall)) < 0)
  802b8b:	c7 44 24 04 d0 2b 80 	movl   $0x802bd0,0x4(%esp)
  802b92:	00 
  802b93:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802b9a:	e8 86 e5 ff ff       	call   801125 <sys_env_set_pgfault_upcall>
  802b9f:	85 c0                	test   %eax,%eax
  802ba1:	79 20                	jns    802bc3 <set_pgfault_handler+0x87>
			panic (" error in sys_env_set_pgfault_upcall: %e\n", ret);
  802ba3:	89 44 24 0c          	mov    %eax,0xc(%esp)
  802ba7:	c7 44 24 08 88 37 80 	movl   $0x803788,0x8(%esp)
  802bae:	00 
  802baf:	c7 44 24 04 25 00 00 	movl   $0x25,0x4(%esp)
  802bb6:	00 
  802bb7:	c7 04 24 79 37 80 00 	movl   $0x803779,(%esp)
  802bbe:	e8 c1 d7 ff ff       	call   800384 <_panic>
	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  802bc3:	8b 45 08             	mov    0x8(%ebp),%eax
  802bc6:	a3 80 70 80 00       	mov    %eax,0x807080
	
}
  802bcb:	c9                   	leave  
  802bcc:	c3                   	ret    
  802bcd:	00 00                	add    %al,(%eax)
	...

00802bd0 <_pgfault_upcall>:

.text
.globl _pgfault_upcall
_pgfault_upcall:
	// Call the C page fault handler.
	pushl %esp			// function argument: pointer to UTF
  802bd0:	54                   	push   %esp
	movl _pgfault_handler, %eax
  802bd1:	a1 80 70 80 00       	mov    0x807080,%eax
	call *%eax
  802bd6:	ff d0                	call   *%eax
	addl $4, %esp			// pop function argument
  802bd8:	83 c4 04             	add    $0x4,%esp
	// may find that you have to rearrange your code in non-obvious
	// ways as registers become unavailable as scratch space.
	//
	// LAB 4: Your code here.
	
	movl %esp, %ecx			// back up esp to ecx
  802bdb:	89 e1                	mov    %esp,%ecx
	movl 0x28(%esp), %ebx		// store trap-time eip into ebx
  802bdd:	8b 5c 24 28          	mov    0x28(%esp),%ebx
	movl 0x30(%esp), %edx		// store trap-time esp into edx
  802be1:	8b 54 24 30          	mov    0x30(%esp),%edx
	movl %edx, %esp			// switch to trap-time stack
  802be5:	89 d4                	mov    %edx,%esp
	pushl %ebx			// push trap-time eip here
  802be7:	53                   	push   %ebx
	movl %ecx, %esp			// come back to user exception stack
  802be8:	89 cc                	mov    %ecx,%esp
	
	// for the push made above, update the trap-time esp value in this user exception stack
	// this enables popl %esp to cause esp point to the adjusted trap-time stack 
	subl $0x4, %edx			
  802bea:	83 ea 04             	sub    $0x4,%edx
	movl %edx, 0x30(%esp)
  802bed:	89 54 24 30          	mov    %edx,0x30(%esp)
	

	// Restore the trap-time registers.  After you do this, you
	// can no longer modify any general-purpose registers.
	// LAB 4: Your code here.
	addl $0x8, %esp
  802bf1:	83 c4 08             	add    $0x8,%esp
	popal
  802bf4:	61                   	popa   
	// Restore eflags from the stack.  After you do this, you can
	// no longer use arithmetic operations or anything else that
	// modifies eflags.
	// LAB 4: Your code here.
	
	addl $0x4, %esp
  802bf5:	83 c4 04             	add    $0x4,%esp
	popfl
  802bf8:	9d                   	popf   

	// Switch back to the adjusted trap-time stack.
	// LAB 4: Your code here.

	popl %esp
  802bf9:	5c                   	pop    %esp

	// Return to re-execute the instruction that faulted.
	// LAB 4: Your code here.
	
	ret
  802bfa:	c3                   	ret    
  802bfb:	00 00                	add    %al,(%eax)
  802bfd:	00 00                	add    %al,(%eax)
	...

00802c00 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  802c00:	55                   	push   %ebp
  802c01:	89 e5                	mov    %esp,%ebp
  802c03:	57                   	push   %edi
  802c04:	56                   	push   %esi
  802c05:	53                   	push   %ebx
  802c06:	83 ec 1c             	sub    $0x1c,%esp
  802c09:	8b 7d 0c             	mov    0xc(%ebp),%edi
  802c0c:	8b 5d 10             	mov    0x10(%ebp),%ebx
  802c0f:	8b 75 14             	mov    0x14(%ebp),%esi
	// LAB 4: Your code here.
	int r;
	if (pg == NULL)
  802c12:	85 db                	test   %ebx,%ebx
  802c14:	75 2d                	jne    802c43 <ipc_send+0x43>
  802c16:	bb 00 00 c0 ee       	mov    $0xeec00000,%ebx
  802c1b:	eb 26                	jmp    802c43 <ipc_send+0x43>
		pg = (void*)UTOP;
	while ((r = sys_ipc_try_send(to_env, val, pg, perm)) < 0)
	{
		if(r != -E_IPC_NOT_RECV)
  802c1d:	83 f8 f9             	cmp    $0xfffffff9,%eax
  802c20:	74 1c                	je     802c3e <ipc_send+0x3e>
			panic("Panic in lib ipc.c : ipc_send() \n");
  802c22:	c7 44 24 08 b4 37 80 	movl   $0x8037b4,0x8(%esp)
  802c29:	00 
  802c2a:	c7 44 24 04 44 00 00 	movl   $0x44,0x4(%esp)
  802c31:	00 
  802c32:	c7 04 24 d8 37 80 00 	movl   $0x8037d8,(%esp)
  802c39:	e8 46 d7 ff ff       	call   800384 <_panic>
		sys_yield();
  802c3e:	e8 17 e7 ff ff       	call   80135a <sys_yield>
{
	// LAB 4: Your code here.
	int r;
	if (pg == NULL)
		pg = (void*)UTOP;
	while ((r = sys_ipc_try_send(to_env, val, pg, perm)) < 0)
  802c43:	89 74 24 0c          	mov    %esi,0xc(%esp)
  802c47:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  802c4b:	89 7c 24 04          	mov    %edi,0x4(%esp)
  802c4f:	8b 45 08             	mov    0x8(%ebp),%eax
  802c52:	89 04 24             	mov    %eax,(%esp)
  802c55:	e8 93 e4 ff ff       	call   8010ed <sys_ipc_try_send>
  802c5a:	85 c0                	test   %eax,%eax
  802c5c:	78 bf                	js     802c1d <ipc_send+0x1d>
		if(r != -E_IPC_NOT_RECV)
			panic("Panic in lib ipc.c : ipc_send() \n");
		sys_yield();
	}
	//panic("ipc_send not implemented");
}
  802c5e:	83 c4 1c             	add    $0x1c,%esp
  802c61:	5b                   	pop    %ebx
  802c62:	5e                   	pop    %esi
  802c63:	5f                   	pop    %edi
  802c64:	5d                   	pop    %ebp
  802c65:	c3                   	ret    

00802c66 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  802c66:	55                   	push   %ebp
  802c67:	89 e5                	mov    %esp,%ebp
  802c69:	56                   	push   %esi
  802c6a:	53                   	push   %ebx
  802c6b:	83 ec 10             	sub    $0x10,%esp
  802c6e:	8b 5d 08             	mov    0x8(%ebp),%ebx
  802c71:	8b 45 0c             	mov    0xc(%ebp),%eax
  802c74:	8b 75 10             	mov    0x10(%ebp),%esi
	// LAB 4: Your code here.
	int r;

	if (pg == NULL)
  802c77:	85 c0                	test   %eax,%eax
  802c79:	75 05                	jne    802c80 <ipc_recv+0x1a>
  802c7b:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
		pg = (void*)UTOP;
	if ((r = sys_ipc_recv(pg)) < 0)
  802c80:	89 04 24             	mov    %eax,(%esp)
  802c83:	e8 08 e4 ff ff       	call   801090 <sys_ipc_recv>
  802c88:	85 c0                	test   %eax,%eax
  802c8a:	79 16                	jns    802ca2 <ipc_recv+0x3c>
	{
		if (from_env_store != NULL)
  802c8c:	85 db                	test   %ebx,%ebx
  802c8e:	74 06                	je     802c96 <ipc_recv+0x30>
			*from_env_store = 0;
  802c90:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
		if(perm_store != NULL)
  802c96:	85 f6                	test   %esi,%esi
  802c98:	74 2c                	je     802cc6 <ipc_recv+0x60>
			*perm_store = 0;
  802c9a:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
  802ca0:	eb 24                	jmp    802cc6 <ipc_recv+0x60>
		return r;
	}
	else
	{	
		if (from_env_store != NULL)
  802ca2:	85 db                	test   %ebx,%ebx
  802ca4:	74 0a                	je     802cb0 <ipc_recv+0x4a>
			*from_env_store = env->env_ipc_from;
  802ca6:	a1 78 70 80 00       	mov    0x807078,%eax
  802cab:	8b 40 74             	mov    0x74(%eax),%eax
  802cae:	89 03                	mov    %eax,(%ebx)
		if(perm_store != NULL)
  802cb0:	85 f6                	test   %esi,%esi
  802cb2:	74 0a                	je     802cbe <ipc_recv+0x58>
			*perm_store = env->env_ipc_perm;
  802cb4:	a1 78 70 80 00       	mov    0x807078,%eax
  802cb9:	8b 40 78             	mov    0x78(%eax),%eax
  802cbc:	89 06                	mov    %eax,(%esi)
		return env->env_ipc_value;
  802cbe:	a1 78 70 80 00       	mov    0x807078,%eax
  802cc3:	8b 40 70             	mov    0x70(%eax),%eax
	}		
	//panic("ipc_recv not implemented");
	//return 0;
}
  802cc6:	83 c4 10             	add    $0x10,%esp
  802cc9:	5b                   	pop    %ebx
  802cca:	5e                   	pop    %esi
  802ccb:	5d                   	pop    %ebp
  802ccc:	c3                   	ret    
  802ccd:	00 00                	add    %al,(%eax)
	...

00802cd0 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  802cd0:	55                   	push   %ebp
  802cd1:	89 e5                	mov    %esp,%ebp
	pte_t pte;

	if (!(vpd[PDX(v)] & PTE_P))
  802cd3:	8b 45 08             	mov    0x8(%ebp),%eax
  802cd6:	89 c2                	mov    %eax,%edx
  802cd8:	c1 ea 16             	shr    $0x16,%edx
  802cdb:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  802ce2:	f6 c2 01             	test   $0x1,%dl
  802ce5:	74 26                	je     802d0d <pageref+0x3d>
		return 0;
	pte = vpt[VPN(v)];
  802ce7:	c1 e8 0c             	shr    $0xc,%eax
  802cea:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
	if (!(pte & PTE_P))
  802cf1:	a8 01                	test   $0x1,%al
  802cf3:	74 18                	je     802d0d <pageref+0x3d>
		return 0;
	return pages[PPN(pte)].pp_ref;
  802cf5:	c1 e8 0c             	shr    $0xc,%eax
  802cf8:	8d 14 40             	lea    (%eax,%eax,2),%edx
  802cfb:	c1 e2 02             	shl    $0x2,%edx
  802cfe:	b8 00 00 00 ef       	mov    $0xef000000,%eax
  802d03:	0f b7 44 02 08       	movzwl 0x8(%edx,%eax,1),%eax
  802d08:	0f b7 c0             	movzwl %ax,%eax
  802d0b:	eb 05                	jmp    802d12 <pageref+0x42>
  802d0d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802d12:	5d                   	pop    %ebp
  802d13:	c3                   	ret    
	...

00802d20 <__udivdi3>:
  802d20:	55                   	push   %ebp
  802d21:	89 e5                	mov    %esp,%ebp
  802d23:	57                   	push   %edi
  802d24:	56                   	push   %esi
  802d25:	83 ec 10             	sub    $0x10,%esp
  802d28:	8b 45 14             	mov    0x14(%ebp),%eax
  802d2b:	8b 55 08             	mov    0x8(%ebp),%edx
  802d2e:	8b 75 10             	mov    0x10(%ebp),%esi
  802d31:	8b 7d 0c             	mov    0xc(%ebp),%edi
  802d34:	85 c0                	test   %eax,%eax
  802d36:	89 55 f0             	mov    %edx,-0x10(%ebp)
  802d39:	75 35                	jne    802d70 <__udivdi3+0x50>
  802d3b:	39 fe                	cmp    %edi,%esi
  802d3d:	77 61                	ja     802da0 <__udivdi3+0x80>
  802d3f:	85 f6                	test   %esi,%esi
  802d41:	75 0b                	jne    802d4e <__udivdi3+0x2e>
  802d43:	b8 01 00 00 00       	mov    $0x1,%eax
  802d48:	31 d2                	xor    %edx,%edx
  802d4a:	f7 f6                	div    %esi
  802d4c:	89 c6                	mov    %eax,%esi
  802d4e:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  802d51:	31 d2                	xor    %edx,%edx
  802d53:	89 f8                	mov    %edi,%eax
  802d55:	f7 f6                	div    %esi
  802d57:	89 c7                	mov    %eax,%edi
  802d59:	89 c8                	mov    %ecx,%eax
  802d5b:	f7 f6                	div    %esi
  802d5d:	89 c1                	mov    %eax,%ecx
  802d5f:	89 fa                	mov    %edi,%edx
  802d61:	89 c8                	mov    %ecx,%eax
  802d63:	83 c4 10             	add    $0x10,%esp
  802d66:	5e                   	pop    %esi
  802d67:	5f                   	pop    %edi
  802d68:	5d                   	pop    %ebp
  802d69:	c3                   	ret    
  802d6a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  802d70:	39 f8                	cmp    %edi,%eax
  802d72:	77 1c                	ja     802d90 <__udivdi3+0x70>
  802d74:	0f bd d0             	bsr    %eax,%edx
  802d77:	83 f2 1f             	xor    $0x1f,%edx
  802d7a:	89 55 f4             	mov    %edx,-0xc(%ebp)
  802d7d:	75 39                	jne    802db8 <__udivdi3+0x98>
  802d7f:	3b 75 f0             	cmp    -0x10(%ebp),%esi
  802d82:	0f 86 a0 00 00 00    	jbe    802e28 <__udivdi3+0x108>
  802d88:	39 f8                	cmp    %edi,%eax
  802d8a:	0f 82 98 00 00 00    	jb     802e28 <__udivdi3+0x108>
  802d90:	31 ff                	xor    %edi,%edi
  802d92:	31 c9                	xor    %ecx,%ecx
  802d94:	89 c8                	mov    %ecx,%eax
  802d96:	89 fa                	mov    %edi,%edx
  802d98:	83 c4 10             	add    $0x10,%esp
  802d9b:	5e                   	pop    %esi
  802d9c:	5f                   	pop    %edi
  802d9d:	5d                   	pop    %ebp
  802d9e:	c3                   	ret    
  802d9f:	90                   	nop
  802da0:	89 d1                	mov    %edx,%ecx
  802da2:	89 fa                	mov    %edi,%edx
  802da4:	89 c8                	mov    %ecx,%eax
  802da6:	31 ff                	xor    %edi,%edi
  802da8:	f7 f6                	div    %esi
  802daa:	89 c1                	mov    %eax,%ecx
  802dac:	89 fa                	mov    %edi,%edx
  802dae:	89 c8                	mov    %ecx,%eax
  802db0:	83 c4 10             	add    $0x10,%esp
  802db3:	5e                   	pop    %esi
  802db4:	5f                   	pop    %edi
  802db5:	5d                   	pop    %ebp
  802db6:	c3                   	ret    
  802db7:	90                   	nop
  802db8:	0f b6 4d f4          	movzbl -0xc(%ebp),%ecx
  802dbc:	89 f2                	mov    %esi,%edx
  802dbe:	d3 e0                	shl    %cl,%eax
  802dc0:	89 45 ec             	mov    %eax,-0x14(%ebp)
  802dc3:	b8 20 00 00 00       	mov    $0x20,%eax
  802dc8:	2b 45 f4             	sub    -0xc(%ebp),%eax
  802dcb:	89 c1                	mov    %eax,%ecx
  802dcd:	d3 ea                	shr    %cl,%edx
  802dcf:	0f b6 4d f4          	movzbl -0xc(%ebp),%ecx
  802dd3:	0b 55 ec             	or     -0x14(%ebp),%edx
  802dd6:	d3 e6                	shl    %cl,%esi
  802dd8:	89 c1                	mov    %eax,%ecx
  802dda:	89 75 e8             	mov    %esi,-0x18(%ebp)
  802ddd:	89 fe                	mov    %edi,%esi
  802ddf:	d3 ee                	shr    %cl,%esi
  802de1:	0f b6 4d f4          	movzbl -0xc(%ebp),%ecx
  802de5:	89 55 ec             	mov    %edx,-0x14(%ebp)
  802de8:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802deb:	d3 e7                	shl    %cl,%edi
  802ded:	89 c1                	mov    %eax,%ecx
  802def:	d3 ea                	shr    %cl,%edx
  802df1:	09 d7                	or     %edx,%edi
  802df3:	89 f2                	mov    %esi,%edx
  802df5:	89 f8                	mov    %edi,%eax
  802df7:	f7 75 ec             	divl   -0x14(%ebp)
  802dfa:	89 d6                	mov    %edx,%esi
  802dfc:	89 c7                	mov    %eax,%edi
  802dfe:	f7 65 e8             	mull   -0x18(%ebp)
  802e01:	39 d6                	cmp    %edx,%esi
  802e03:	89 55 ec             	mov    %edx,-0x14(%ebp)
  802e06:	72 30                	jb     802e38 <__udivdi3+0x118>
  802e08:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802e0b:	0f b6 4d f4          	movzbl -0xc(%ebp),%ecx
  802e0f:	d3 e2                	shl    %cl,%edx
  802e11:	39 c2                	cmp    %eax,%edx
  802e13:	73 05                	jae    802e1a <__udivdi3+0xfa>
  802e15:	3b 75 ec             	cmp    -0x14(%ebp),%esi
  802e18:	74 1e                	je     802e38 <__udivdi3+0x118>
  802e1a:	89 f9                	mov    %edi,%ecx
  802e1c:	31 ff                	xor    %edi,%edi
  802e1e:	e9 71 ff ff ff       	jmp    802d94 <__udivdi3+0x74>
  802e23:	90                   	nop
  802e24:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802e28:	31 ff                	xor    %edi,%edi
  802e2a:	b9 01 00 00 00       	mov    $0x1,%ecx
  802e2f:	e9 60 ff ff ff       	jmp    802d94 <__udivdi3+0x74>
  802e34:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802e38:	8d 4f ff             	lea    -0x1(%edi),%ecx
  802e3b:	31 ff                	xor    %edi,%edi
  802e3d:	89 c8                	mov    %ecx,%eax
  802e3f:	89 fa                	mov    %edi,%edx
  802e41:	83 c4 10             	add    $0x10,%esp
  802e44:	5e                   	pop    %esi
  802e45:	5f                   	pop    %edi
  802e46:	5d                   	pop    %ebp
  802e47:	c3                   	ret    
	...

00802e50 <__umoddi3>:
  802e50:	55                   	push   %ebp
  802e51:	89 e5                	mov    %esp,%ebp
  802e53:	57                   	push   %edi
  802e54:	56                   	push   %esi
  802e55:	83 ec 20             	sub    $0x20,%esp
  802e58:	8b 55 14             	mov    0x14(%ebp),%edx
  802e5b:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802e5e:	8b 7d 10             	mov    0x10(%ebp),%edi
  802e61:	8b 75 0c             	mov    0xc(%ebp),%esi
  802e64:	85 d2                	test   %edx,%edx
  802e66:	89 c8                	mov    %ecx,%eax
  802e68:	89 4d f4             	mov    %ecx,-0xc(%ebp)
  802e6b:	75 13                	jne    802e80 <__umoddi3+0x30>
  802e6d:	39 f7                	cmp    %esi,%edi
  802e6f:	76 3f                	jbe    802eb0 <__umoddi3+0x60>
  802e71:	89 f2                	mov    %esi,%edx
  802e73:	f7 f7                	div    %edi
  802e75:	89 d0                	mov    %edx,%eax
  802e77:	31 d2                	xor    %edx,%edx
  802e79:	83 c4 20             	add    $0x20,%esp
  802e7c:	5e                   	pop    %esi
  802e7d:	5f                   	pop    %edi
  802e7e:	5d                   	pop    %ebp
  802e7f:	c3                   	ret    
  802e80:	39 f2                	cmp    %esi,%edx
  802e82:	77 4c                	ja     802ed0 <__umoddi3+0x80>
  802e84:	0f bd ca             	bsr    %edx,%ecx
  802e87:	83 f1 1f             	xor    $0x1f,%ecx
  802e8a:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  802e8d:	75 51                	jne    802ee0 <__umoddi3+0x90>
  802e8f:	3b 7d f4             	cmp    -0xc(%ebp),%edi
  802e92:	0f 87 e0 00 00 00    	ja     802f78 <__umoddi3+0x128>
  802e98:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e9b:	29 f8                	sub    %edi,%eax
  802e9d:	19 d6                	sbb    %edx,%esi
  802e9f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802ea2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ea5:	89 f2                	mov    %esi,%edx
  802ea7:	83 c4 20             	add    $0x20,%esp
  802eaa:	5e                   	pop    %esi
  802eab:	5f                   	pop    %edi
  802eac:	5d                   	pop    %ebp
  802ead:	c3                   	ret    
  802eae:	66 90                	xchg   %ax,%ax
  802eb0:	85 ff                	test   %edi,%edi
  802eb2:	75 0b                	jne    802ebf <__umoddi3+0x6f>
  802eb4:	b8 01 00 00 00       	mov    $0x1,%eax
  802eb9:	31 d2                	xor    %edx,%edx
  802ebb:	f7 f7                	div    %edi
  802ebd:	89 c7                	mov    %eax,%edi
  802ebf:	89 f0                	mov    %esi,%eax
  802ec1:	31 d2                	xor    %edx,%edx
  802ec3:	f7 f7                	div    %edi
  802ec5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ec8:	f7 f7                	div    %edi
  802eca:	eb a9                	jmp    802e75 <__umoddi3+0x25>
  802ecc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802ed0:	89 c8                	mov    %ecx,%eax
  802ed2:	89 f2                	mov    %esi,%edx
  802ed4:	83 c4 20             	add    $0x20,%esp
  802ed7:	5e                   	pop    %esi
  802ed8:	5f                   	pop    %edi
  802ed9:	5d                   	pop    %ebp
  802eda:	c3                   	ret    
  802edb:	90                   	nop
  802edc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802ee0:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
  802ee4:	d3 e2                	shl    %cl,%edx
  802ee6:	89 55 f4             	mov    %edx,-0xc(%ebp)
  802ee9:	ba 20 00 00 00       	mov    $0x20,%edx
  802eee:	2b 55 f0             	sub    -0x10(%ebp),%edx
  802ef1:	89 55 ec             	mov    %edx,-0x14(%ebp)
  802ef4:	0f b6 4d ec          	movzbl -0x14(%ebp),%ecx
  802ef8:	89 fa                	mov    %edi,%edx
  802efa:	d3 ea                	shr    %cl,%edx
  802efc:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
  802f00:	0b 55 f4             	or     -0xc(%ebp),%edx
  802f03:	d3 e7                	shl    %cl,%edi
  802f05:	0f b6 4d ec          	movzbl -0x14(%ebp),%ecx
  802f09:	89 55 f4             	mov    %edx,-0xc(%ebp)
  802f0c:	89 f2                	mov    %esi,%edx
  802f0e:	89 7d e8             	mov    %edi,-0x18(%ebp)
  802f11:	89 c7                	mov    %eax,%edi
  802f13:	d3 ea                	shr    %cl,%edx
  802f15:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
  802f19:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  802f1c:	89 c2                	mov    %eax,%edx
  802f1e:	d3 e6                	shl    %cl,%esi
  802f20:	0f b6 4d ec          	movzbl -0x14(%ebp),%ecx
  802f24:	d3 ea                	shr    %cl,%edx
  802f26:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
  802f2a:	09 d6                	or     %edx,%esi
  802f2c:	89 f0                	mov    %esi,%eax
  802f2e:	8b 75 e4             	mov    -0x1c(%ebp),%esi
  802f31:	d3 e7                	shl    %cl,%edi
  802f33:	89 f2                	mov    %esi,%edx
  802f35:	f7 75 f4             	divl   -0xc(%ebp)
  802f38:	89 d6                	mov    %edx,%esi
  802f3a:	f7 65 e8             	mull   -0x18(%ebp)
  802f3d:	39 d6                	cmp    %edx,%esi
  802f3f:	72 2b                	jb     802f6c <__umoddi3+0x11c>
  802f41:	39 c7                	cmp    %eax,%edi
  802f43:	72 23                	jb     802f68 <__umoddi3+0x118>
  802f45:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
  802f49:	29 c7                	sub    %eax,%edi
  802f4b:	19 d6                	sbb    %edx,%esi
  802f4d:	89 f0                	mov    %esi,%eax
  802f4f:	89 f2                	mov    %esi,%edx
  802f51:	d3 ef                	shr    %cl,%edi
  802f53:	0f b6 4d ec          	movzbl -0x14(%ebp),%ecx
  802f57:	d3 e0                	shl    %cl,%eax
  802f59:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
  802f5d:	09 f8                	or     %edi,%eax
  802f5f:	d3 ea                	shr    %cl,%edx
  802f61:	83 c4 20             	add    $0x20,%esp
  802f64:	5e                   	pop    %esi
  802f65:	5f                   	pop    %edi
  802f66:	5d                   	pop    %ebp
  802f67:	c3                   	ret    
  802f68:	39 d6                	cmp    %edx,%esi
  802f6a:	75 d9                	jne    802f45 <__umoddi3+0xf5>
  802f6c:	2b 45 e8             	sub    -0x18(%ebp),%eax
  802f6f:	1b 55 f4             	sbb    -0xc(%ebp),%edx
  802f72:	eb d1                	jmp    802f45 <__umoddi3+0xf5>
  802f74:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802f78:	39 f2                	cmp    %esi,%edx
  802f7a:	0f 82 18 ff ff ff    	jb     802e98 <__umoddi3+0x48>
  802f80:	e9 1d ff ff ff       	jmp    802ea2 <__umoddi3+0x52>
