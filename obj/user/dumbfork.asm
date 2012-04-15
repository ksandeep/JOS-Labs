
obj/user/dumbfork:     file format elf32-i386


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
  80002c:	e8 1b 02 00 00       	call   80024c <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>
	...

00800034 <duppage>:
	}
}

void
duppage(envid_t dstenv, void *addr)
{
  800034:	55                   	push   %ebp
  800035:	89 e5                	mov    %esp,%ebp
  800037:	56                   	push   %esi
  800038:	53                   	push   %ebx
  800039:	83 ec 20             	sub    $0x20,%esp
  80003c:	8b 75 08             	mov    0x8(%ebp),%esi
  80003f:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;

	// This is NOT what you should do in your fork.
	if ((r = sys_page_alloc(dstenv, addr, PTE_P|PTE_U|PTE_W)) < 0)
  800042:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  800049:	00 
  80004a:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  80004e:	89 34 24             	mov    %esi,(%esp)
  800051:	e8 d5 11 00 00       	call   80122b <sys_page_alloc>
  800056:	85 c0                	test   %eax,%eax
  800058:	79 20                	jns    80007a <duppage+0x46>
		panic("duppage: sys_page_alloc: %e\n", r);
  80005a:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80005e:	c7 44 24 08 e0 29 80 	movl   $0x8029e0,0x8(%esp)
  800065:	00 
  800066:	c7 44 24 04 20 00 00 	movl   $0x20,0x4(%esp)
  80006d:	00 
  80006e:	c7 04 24 fd 29 80 00 	movl   $0x8029fd,(%esp)
  800075:	e8 3e 02 00 00       	call   8002b8 <_panic>
	if ((r = sys_page_map(dstenv, addr, 0, UTEMP, PTE_P|PTE_U|PTE_W)) < 0)
  80007a:	c7 44 24 10 07 00 00 	movl   $0x7,0x10(%esp)
  800081:	00 
  800082:	c7 44 24 0c 00 00 40 	movl   $0x400000,0xc(%esp)
  800089:	00 
  80008a:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  800091:	00 
  800092:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  800096:	89 34 24             	mov    %esi,(%esp)
  800099:	e8 2f 11 00 00       	call   8011cd <sys_page_map>
  80009e:	85 c0                	test   %eax,%eax
  8000a0:	79 20                	jns    8000c2 <duppage+0x8e>
		panic("sys_page_map: %e", r);
  8000a2:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8000a6:	c7 44 24 08 0d 2a 80 	movl   $0x802a0d,0x8(%esp)
  8000ad:	00 
  8000ae:	c7 44 24 04 22 00 00 	movl   $0x22,0x4(%esp)
  8000b5:	00 
  8000b6:	c7 04 24 fd 29 80 00 	movl   $0x8029fd,(%esp)
  8000bd:	e8 f6 01 00 00       	call   8002b8 <_panic>
	memmove(UTEMP, addr, PGSIZE);
  8000c2:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
  8000c9:	00 
  8000ca:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8000ce:	c7 04 24 00 00 40 00 	movl   $0x400000,(%esp)
  8000d5:	e8 1b 0b 00 00       	call   800bf5 <memmove>
	if ((r = sys_page_unmap(0, UTEMP)) < 0)
  8000da:	c7 44 24 04 00 00 40 	movl   $0x400000,0x4(%esp)
  8000e1:	00 
  8000e2:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8000e9:	e8 81 10 00 00       	call   80116f <sys_page_unmap>
  8000ee:	85 c0                	test   %eax,%eax
  8000f0:	79 20                	jns    800112 <duppage+0xde>
		panic("sys_page_unmap: %e", r);
  8000f2:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8000f6:	c7 44 24 08 1e 2a 80 	movl   $0x802a1e,0x8(%esp)
  8000fd:	00 
  8000fe:	c7 44 24 04 25 00 00 	movl   $0x25,0x4(%esp)
  800105:	00 
  800106:	c7 04 24 fd 29 80 00 	movl   $0x8029fd,(%esp)
  80010d:	e8 a6 01 00 00       	call   8002b8 <_panic>
}
  800112:	83 c4 20             	add    $0x20,%esp
  800115:	5b                   	pop    %ebx
  800116:	5e                   	pop    %esi
  800117:	5d                   	pop    %ebp
  800118:	c3                   	ret    

00800119 <dumbfork>:

envid_t
dumbfork(void)
{
  800119:	55                   	push   %ebp
  80011a:	89 e5                	mov    %esp,%ebp
  80011c:	53                   	push   %ebx
  80011d:	83 ec 24             	sub    $0x24,%esp
static __inline envid_t sys_exofork(void) __attribute__((always_inline));
static __inline envid_t
sys_exofork(void)
{
	envid_t ret;
	__asm __volatile("int %2"
  800120:	bb 07 00 00 00       	mov    $0x7,%ebx
  800125:	89 d8                	mov    %ebx,%eax
  800127:	cd 30                	int    $0x30
  800129:	89 c3                	mov    %eax,%ebx
	// The kernel will initialize it with a copy of our register state,
	// so that the child will appear to have called sys_exofork() too -
	// except that in the child, this "fake" call to sys_exofork()
	// will return 0 instead of the envid of the child.
	envid = sys_exofork();
	if (envid < 0)
  80012b:	85 c0                	test   %eax,%eax
  80012d:	79 20                	jns    80014f <dumbfork+0x36>
		panic("sys_exofork: %e", envid);
  80012f:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800133:	c7 44 24 08 31 2a 80 	movl   $0x802a31,0x8(%esp)
  80013a:	00 
  80013b:	c7 44 24 04 37 00 00 	movl   $0x37,0x4(%esp)
  800142:	00 
  800143:	c7 04 24 fd 29 80 00 	movl   $0x8029fd,(%esp)
  80014a:	e8 69 01 00 00       	call   8002b8 <_panic>
	if (envid == 0) {
  80014f:	85 c0                	test   %eax,%eax
  800151:	75 19                	jne    80016c <dumbfork+0x53>
		// We're the child.
		// The copied value of the global variable 'env'
		// is no longer valid (it refers to the parent!).
		// Fix it and return 0.
		env = &envs[ENVX(sys_getenvid())];
  800153:	e8 66 11 00 00       	call   8012be <sys_getenvid>
  800158:	25 ff 03 00 00       	and    $0x3ff,%eax
  80015d:	6b c0 7c             	imul   $0x7c,%eax,%eax
  800160:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800165:	a3 74 60 80 00       	mov    %eax,0x806074
		return 0;
  80016a:	eb 7e                	jmp    8001ea <dumbfork+0xd1>
	}

	// We're the parent.
	// Eagerly copy our entire address space into the child.
	// This is NOT what you should do in your fork implementation.
	for (addr = (uint8_t*) UTEXT; addr < end; addr += PGSIZE)
  80016c:	c7 45 f4 00 00 80 00 	movl   $0x800000,-0xc(%ebp)
  800173:	b8 7c 60 80 00       	mov    $0x80607c,%eax
  800178:	3d 00 00 80 00       	cmp    $0x800000,%eax
  80017d:	76 23                	jbe    8001a2 <dumbfork+0x89>
  80017f:	b8 00 00 80 00       	mov    $0x800000,%eax
		duppage(envid, addr);
  800184:	89 44 24 04          	mov    %eax,0x4(%esp)
  800188:	89 1c 24             	mov    %ebx,(%esp)
  80018b:	e8 a4 fe ff ff       	call   800034 <duppage>
	}

	// We're the parent.
	// Eagerly copy our entire address space into the child.
	// This is NOT what you should do in your fork implementation.
	for (addr = (uint8_t*) UTEXT; addr < end; addr += PGSIZE)
  800190:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800193:	05 00 10 00 00       	add    $0x1000,%eax
  800198:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80019b:	3d 7c 60 80 00       	cmp    $0x80607c,%eax
  8001a0:	72 e2                	jb     800184 <dumbfork+0x6b>
		duppage(envid, addr);
	// Also copy the stack we are currently running on.
	duppage(envid, ROUNDDOWN(&addr, PGSIZE));
  8001a2:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8001a5:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8001aa:	89 44 24 04          	mov    %eax,0x4(%esp)
  8001ae:	89 1c 24             	mov    %ebx,(%esp)
  8001b1:	e8 7e fe ff ff       	call   800034 <duppage>

	// Start the child environment running
	if ((r = sys_env_set_status(envid, ENV_RUNNABLE)) < 0)
  8001b6:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  8001bd:	00 
  8001be:	89 1c 24             	mov    %ebx,(%esp)
  8001c1:	e8 4b 0f 00 00       	call   801111 <sys_env_set_status>
  8001c6:	85 c0                	test   %eax,%eax
  8001c8:	79 20                	jns    8001ea <dumbfork+0xd1>
		panic("sys_env_set_status: %e", r);
  8001ca:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8001ce:	c7 44 24 08 41 2a 80 	movl   $0x802a41,0x8(%esp)
  8001d5:	00 
  8001d6:	c7 44 24 04 4b 00 00 	movl   $0x4b,0x4(%esp)
  8001dd:	00 
  8001de:	c7 04 24 fd 29 80 00 	movl   $0x8029fd,(%esp)
  8001e5:	e8 ce 00 00 00       	call   8002b8 <_panic>

	return envid;
}
  8001ea:	89 d8                	mov    %ebx,%eax
  8001ec:	83 c4 24             	add    $0x24,%esp
  8001ef:	5b                   	pop    %ebx
  8001f0:	5d                   	pop    %ebp
  8001f1:	c3                   	ret    

008001f2 <umain>:

envid_t dumbfork(void);

void
umain(void)
{
  8001f2:	55                   	push   %ebp
  8001f3:	89 e5                	mov    %esp,%ebp
  8001f5:	57                   	push   %edi
  8001f6:	56                   	push   %esi
  8001f7:	53                   	push   %ebx
  8001f8:	83 ec 1c             	sub    $0x1c,%esp
	envid_t who;
	int i;

	// fork a child process
	who = dumbfork();
  8001fb:	e8 19 ff ff ff       	call   800119 <dumbfork>
  800200:	89 c6                	mov    %eax,%esi
  800202:	bb 00 00 00 00       	mov    $0x0,%ebx

	// print a message and yield to the other a few times
	for (i = 0; i < (who ? 10 : 20); i++) {
		cprintf("%d: I am the %s!\n", i, who ? "parent" : "child");
  800207:	bf 5e 2a 80 00       	mov    $0x802a5e,%edi

	// fork a child process
	who = dumbfork();

	// print a message and yield to the other a few times
	for (i = 0; i < (who ? 10 : 20); i++) {
  80020c:	eb 27                	jmp    800235 <umain+0x43>
		cprintf("%d: I am the %s!\n", i, who ? "parent" : "child");
  80020e:	89 f8                	mov    %edi,%eax
  800210:	85 f6                	test   %esi,%esi
  800212:	75 05                	jne    800219 <umain+0x27>
  800214:	b8 58 2a 80 00       	mov    $0x802a58,%eax
  800219:	89 44 24 08          	mov    %eax,0x8(%esp)
  80021d:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  800221:	c7 04 24 65 2a 80 00 	movl   $0x802a65,(%esp)
  800228:	e8 50 01 00 00       	call   80037d <cprintf>
		sys_yield();
  80022d:	e8 58 10 00 00       	call   80128a <sys_yield>

	// fork a child process
	who = dumbfork();

	// print a message and yield to the other a few times
	for (i = 0; i < (who ? 10 : 20); i++) {
  800232:	83 c3 01             	add    $0x1,%ebx
  800235:	83 fe 01             	cmp    $0x1,%esi
  800238:	19 c0                	sbb    %eax,%eax
  80023a:	83 e0 0a             	and    $0xa,%eax
  80023d:	83 c0 0a             	add    $0xa,%eax
  800240:	39 d8                	cmp    %ebx,%eax
  800242:	7f ca                	jg     80020e <umain+0x1c>
		cprintf("%d: I am the %s!\n", i, who ? "parent" : "child");
		sys_yield();
	}
}
  800244:	83 c4 1c             	add    $0x1c,%esp
  800247:	5b                   	pop    %ebx
  800248:	5e                   	pop    %esi
  800249:	5f                   	pop    %edi
  80024a:	5d                   	pop    %ebp
  80024b:	c3                   	ret    

0080024c <libmain>:
volatile struct Env *env;
char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  80024c:	55                   	push   %ebp
  80024d:	89 e5                	mov    %esp,%ebp
  80024f:	83 ec 18             	sub    $0x18,%esp
  800252:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  800255:	89 75 fc             	mov    %esi,-0x4(%ebp)
  800258:	8b 75 08             	mov    0x8(%ebp),%esi
  80025b:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	// set env to point at our env structure in envs[].
	// LAB 3b: Your code here.
	// Code added by Swastika / Sandeep	
	envid_t envid = sys_getenvid();
  80025e:	e8 5b 10 00 00       	call   8012be <sys_getenvid>
	env = &envs[ENVX(envid)];
  800263:	25 ff 03 00 00       	and    $0x3ff,%eax
  800268:	6b c0 7c             	imul   $0x7c,%eax,%eax
  80026b:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800270:	a3 74 60 80 00       	mov    %eax,0x806074

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800275:	85 f6                	test   %esi,%esi
  800277:	7e 07                	jle    800280 <libmain+0x34>
		binaryname = argv[0];
  800279:	8b 03                	mov    (%ebx),%eax
  80027b:	a3 00 60 80 00       	mov    %eax,0x806000

	// call user main routine
	umain(argc, argv);
  800280:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  800284:	89 34 24             	mov    %esi,(%esp)
  800287:	e8 66 ff ff ff       	call   8001f2 <umain>

	// exit gracefully
	exit();
  80028c:	e8 0b 00 00 00       	call   80029c <exit>
}
  800291:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  800294:	8b 75 fc             	mov    -0x4(%ebp),%esi
  800297:	89 ec                	mov    %ebp,%esp
  800299:	5d                   	pop    %ebp
  80029a:	c3                   	ret    
	...

0080029c <exit>:
#include <inc/lib.h>

void
exit(void)
{
  80029c:	55                   	push   %ebp
  80029d:	89 e5                	mov    %esp,%ebp
  80029f:	83 ec 18             	sub    $0x18,%esp
	close_all();
  8002a2:	e8 84 15 00 00       	call   80182b <close_all>
	sys_env_destroy(0);
  8002a7:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8002ae:	e8 3f 10 00 00       	call   8012f2 <sys_env_destroy>
}
  8002b3:	c9                   	leave  
  8002b4:	c3                   	ret    
  8002b5:	00 00                	add    %al,(%eax)
	...

008002b8 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  8002b8:	55                   	push   %ebp
  8002b9:	89 e5                	mov    %esp,%ebp
  8002bb:	53                   	push   %ebx
  8002bc:	83 ec 14             	sub    $0x14,%esp
 * Panic is called on unresolvable fatal errors.
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
  8002bf:	8d 5d 14             	lea    0x14(%ebp),%ebx
	va_list ap;

	va_start(ap, fmt);

	// Print the panic message
	if (argv0)
  8002c2:	a1 78 60 80 00       	mov    0x806078,%eax
  8002c7:	85 c0                	test   %eax,%eax
  8002c9:	74 10                	je     8002db <_panic+0x23>
		cprintf("%s: ", argv0);
  8002cb:	89 44 24 04          	mov    %eax,0x4(%esp)
  8002cf:	c7 04 24 8e 2a 80 00 	movl   $0x802a8e,(%esp)
  8002d6:	e8 a2 00 00 00       	call   80037d <cprintf>
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  8002db:	8b 45 0c             	mov    0xc(%ebp),%eax
  8002de:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8002e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8002e5:	89 44 24 08          	mov    %eax,0x8(%esp)
  8002e9:	a1 00 60 80 00       	mov    0x806000,%eax
  8002ee:	89 44 24 04          	mov    %eax,0x4(%esp)
  8002f2:	c7 04 24 93 2a 80 00 	movl   $0x802a93,(%esp)
  8002f9:	e8 7f 00 00 00       	call   80037d <cprintf>
	vcprintf(fmt, ap);
  8002fe:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  800302:	8b 45 10             	mov    0x10(%ebp),%eax
  800305:	89 04 24             	mov    %eax,(%esp)
  800308:	e8 0f 00 00 00       	call   80031c <vcprintf>
	cprintf("\n");
  80030d:	c7 04 24 75 2a 80 00 	movl   $0x802a75,(%esp)
  800314:	e8 64 00 00 00       	call   80037d <cprintf>

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  800319:	cc                   	int3   
  80031a:	eb fd                	jmp    800319 <_panic+0x61>

0080031c <vcprintf>:
	b->cnt++;
}

int
vcprintf(const char *fmt, va_list ap)
{
  80031c:	55                   	push   %ebp
  80031d:	89 e5                	mov    %esp,%ebp
  80031f:	81 ec 28 01 00 00    	sub    $0x128,%esp
	struct printbuf b;

	b.idx = 0;
  800325:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  80032c:	00 00 00 
	b.cnt = 0;
  80032f:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800336:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  800339:	8b 45 0c             	mov    0xc(%ebp),%eax
  80033c:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800340:	8b 45 08             	mov    0x8(%ebp),%eax
  800343:	89 44 24 08          	mov    %eax,0x8(%esp)
  800347:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80034d:	89 44 24 04          	mov    %eax,0x4(%esp)
  800351:	c7 04 24 97 03 80 00 	movl   $0x800397,(%esp)
  800358:	e8 d0 01 00 00       	call   80052d <vprintfmt>
	sys_cputs(b.buf, b.idx);
  80035d:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
  800363:	89 44 24 04          	mov    %eax,0x4(%esp)
  800367:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  80036d:	89 04 24             	mov    %eax,(%esp)
  800370:	e8 bb 0a 00 00       	call   800e30 <sys_cputs>

	return b.cnt;
}
  800375:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  80037b:	c9                   	leave  
  80037c:	c3                   	ret    

0080037d <cprintf>:

int
cprintf(const char *fmt, ...)
{
  80037d:	55                   	push   %ebp
  80037e:	89 e5                	mov    %esp,%ebp
  800380:	83 ec 18             	sub    $0x18,%esp

	return b.cnt;
}

int
cprintf(const char *fmt, ...)
  800383:	8d 45 0c             	lea    0xc(%ebp),%eax
{
	va_list ap;
	int cnt;

	va_start(ap, fmt);
	cnt = vcprintf(fmt, ap);
  800386:	89 44 24 04          	mov    %eax,0x4(%esp)
  80038a:	8b 45 08             	mov    0x8(%ebp),%eax
  80038d:	89 04 24             	mov    %eax,(%esp)
  800390:	e8 87 ff ff ff       	call   80031c <vcprintf>
	va_end(ap);

	return cnt;
}
  800395:	c9                   	leave  
  800396:	c3                   	ret    

00800397 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  800397:	55                   	push   %ebp
  800398:	89 e5                	mov    %esp,%ebp
  80039a:	53                   	push   %ebx
  80039b:	83 ec 14             	sub    $0x14,%esp
  80039e:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  8003a1:	8b 03                	mov    (%ebx),%eax
  8003a3:	8b 55 08             	mov    0x8(%ebp),%edx
  8003a6:	88 54 03 08          	mov    %dl,0x8(%ebx,%eax,1)
  8003aa:	83 c0 01             	add    $0x1,%eax
  8003ad:	89 03                	mov    %eax,(%ebx)
	if (b->idx == 256-1) {
  8003af:	3d ff 00 00 00       	cmp    $0xff,%eax
  8003b4:	75 19                	jne    8003cf <putch+0x38>
		sys_cputs(b->buf, b->idx);
  8003b6:	c7 44 24 04 ff 00 00 	movl   $0xff,0x4(%esp)
  8003bd:	00 
  8003be:	8d 43 08             	lea    0x8(%ebx),%eax
  8003c1:	89 04 24             	mov    %eax,(%esp)
  8003c4:	e8 67 0a 00 00       	call   800e30 <sys_cputs>
		b->idx = 0;
  8003c9:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
	}
	b->cnt++;
  8003cf:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  8003d3:	83 c4 14             	add    $0x14,%esp
  8003d6:	5b                   	pop    %ebx
  8003d7:	5d                   	pop    %ebp
  8003d8:	c3                   	ret    
  8003d9:	00 00                	add    %al,(%eax)
  8003db:	00 00                	add    %al,(%eax)
  8003dd:	00 00                	add    %al,(%eax)
	...

008003e0 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8003e0:	55                   	push   %ebp
  8003e1:	89 e5                	mov    %esp,%ebp
  8003e3:	57                   	push   %edi
  8003e4:	56                   	push   %esi
  8003e5:	53                   	push   %ebx
  8003e6:	83 ec 4c             	sub    $0x4c,%esp
  8003e9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8003ec:	89 d6                	mov    %edx,%esi
  8003ee:	8b 45 08             	mov    0x8(%ebp),%eax
  8003f1:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8003f4:	8b 55 0c             	mov    0xc(%ebp),%edx
  8003f7:	89 55 e0             	mov    %edx,-0x20(%ebp)
  8003fa:	8b 45 10             	mov    0x10(%ebp),%eax
  8003fd:	8b 5d 14             	mov    0x14(%ebp),%ebx
  800400:	8b 7d 18             	mov    0x18(%ebp),%edi
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800403:	89 45 dc             	mov    %eax,-0x24(%ebp)
  800406:	b9 00 00 00 00       	mov    $0x0,%ecx
  80040b:	39 d1                	cmp    %edx,%ecx
  80040d:	72 15                	jb     800424 <printnum+0x44>
  80040f:	77 07                	ja     800418 <printnum+0x38>
  800411:	8b 55 d8             	mov    -0x28(%ebp),%edx
  800414:	39 d0                	cmp    %edx,%eax
  800416:	76 0c                	jbe    800424 <printnum+0x44>
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800418:	83 eb 01             	sub    $0x1,%ebx
  80041b:	85 db                	test   %ebx,%ebx
  80041d:	8d 76 00             	lea    0x0(%esi),%esi
  800420:	7f 61                	jg     800483 <printnum+0xa3>
  800422:	eb 70                	jmp    800494 <printnum+0xb4>
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800424:	89 7c 24 10          	mov    %edi,0x10(%esp)
  800428:	83 eb 01             	sub    $0x1,%ebx
  80042b:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  80042f:	89 44 24 08          	mov    %eax,0x8(%esp)
  800433:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  800437:	8b 5c 24 0c          	mov    0xc(%esp),%ebx
  80043b:	89 4d d0             	mov    %ecx,-0x30(%ebp)
  80043e:	89 5d d4             	mov    %ebx,-0x2c(%ebp)
  800441:	8b 5d dc             	mov    -0x24(%ebp),%ebx
  800444:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  800448:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  80044f:	00 
  800450:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800453:	89 04 24             	mov    %eax,(%esp)
  800456:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800459:	89 54 24 04          	mov    %edx,0x4(%esp)
  80045d:	e8 0e 23 00 00       	call   802770 <__udivdi3>
  800462:	8b 4d d0             	mov    -0x30(%ebp),%ecx
  800465:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
  800468:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  80046c:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  800470:	89 04 24             	mov    %eax,(%esp)
  800473:	89 54 24 04          	mov    %edx,0x4(%esp)
  800477:	89 f2                	mov    %esi,%edx
  800479:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80047c:	e8 5f ff ff ff       	call   8003e0 <printnum>
  800481:	eb 11                	jmp    800494 <printnum+0xb4>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800483:	89 74 24 04          	mov    %esi,0x4(%esp)
  800487:	89 3c 24             	mov    %edi,(%esp)
  80048a:	ff 55 e4             	call   *-0x1c(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  80048d:	83 eb 01             	sub    $0x1,%ebx
  800490:	85 db                	test   %ebx,%ebx
  800492:	7f ef                	jg     800483 <printnum+0xa3>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800494:	89 74 24 04          	mov    %esi,0x4(%esp)
  800498:	8b 74 24 04          	mov    0x4(%esp),%esi
  80049c:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80049f:	89 44 24 08          	mov    %eax,0x8(%esp)
  8004a3:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  8004aa:	00 
  8004ab:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8004ae:	89 14 24             	mov    %edx,(%esp)
  8004b1:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  8004b4:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8004b8:	e8 e3 23 00 00       	call   8028a0 <__umoddi3>
  8004bd:	89 74 24 04          	mov    %esi,0x4(%esp)
  8004c1:	0f be 80 af 2a 80 00 	movsbl 0x802aaf(%eax),%eax
  8004c8:	89 04 24             	mov    %eax,(%esp)
  8004cb:	ff 55 e4             	call   *-0x1c(%ebp)
}
  8004ce:	83 c4 4c             	add    $0x4c,%esp
  8004d1:	5b                   	pop    %ebx
  8004d2:	5e                   	pop    %esi
  8004d3:	5f                   	pop    %edi
  8004d4:	5d                   	pop    %ebp
  8004d5:	c3                   	ret    

008004d6 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  8004d6:	55                   	push   %ebp
  8004d7:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8004d9:	83 fa 01             	cmp    $0x1,%edx
  8004dc:	7e 0e                	jle    8004ec <getuint+0x16>
		return va_arg(*ap, unsigned long long);
  8004de:	8b 10                	mov    (%eax),%edx
  8004e0:	8d 4a 08             	lea    0x8(%edx),%ecx
  8004e3:	89 08                	mov    %ecx,(%eax)
  8004e5:	8b 02                	mov    (%edx),%eax
  8004e7:	8b 52 04             	mov    0x4(%edx),%edx
  8004ea:	eb 22                	jmp    80050e <getuint+0x38>
	else if (lflag)
  8004ec:	85 d2                	test   %edx,%edx
  8004ee:	74 10                	je     800500 <getuint+0x2a>
		return va_arg(*ap, unsigned long);
  8004f0:	8b 10                	mov    (%eax),%edx
  8004f2:	8d 4a 04             	lea    0x4(%edx),%ecx
  8004f5:	89 08                	mov    %ecx,(%eax)
  8004f7:	8b 02                	mov    (%edx),%eax
  8004f9:	ba 00 00 00 00       	mov    $0x0,%edx
  8004fe:	eb 0e                	jmp    80050e <getuint+0x38>
	else
		return va_arg(*ap, unsigned int);
  800500:	8b 10                	mov    (%eax),%edx
  800502:	8d 4a 04             	lea    0x4(%edx),%ecx
  800505:	89 08                	mov    %ecx,(%eax)
  800507:	8b 02                	mov    (%edx),%eax
  800509:	ba 00 00 00 00       	mov    $0x0,%edx
}
  80050e:	5d                   	pop    %ebp
  80050f:	c3                   	ret    

00800510 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800510:	55                   	push   %ebp
  800511:	89 e5                	mov    %esp,%ebp
  800513:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  800516:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  80051a:	8b 10                	mov    (%eax),%edx
  80051c:	3b 50 04             	cmp    0x4(%eax),%edx
  80051f:	73 0a                	jae    80052b <sprintputch+0x1b>
		*b->buf++ = ch;
  800521:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800524:	88 0a                	mov    %cl,(%edx)
  800526:	83 c2 01             	add    $0x1,%edx
  800529:	89 10                	mov    %edx,(%eax)
}
  80052b:	5d                   	pop    %ebp
  80052c:	c3                   	ret    

0080052d <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  80052d:	55                   	push   %ebp
  80052e:	89 e5                	mov    %esp,%ebp
  800530:	57                   	push   %edi
  800531:	56                   	push   %esi
  800532:	53                   	push   %ebx
  800533:	83 ec 5c             	sub    $0x5c,%esp
  800536:	8b 7d 08             	mov    0x8(%ebp),%edi
  800539:	8b 75 0c             	mov    0xc(%ebp),%esi
  80053c:	8b 5d 10             	mov    0x10(%ebp),%ebx
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  80053f:	c7 45 c8 ff ff ff ff 	movl   $0xffffffff,-0x38(%ebp)
  800546:	eb 11                	jmp    800559 <vprintfmt+0x2c>
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
  800548:	85 c0                	test   %eax,%eax
  80054a:	0f 84 ec 03 00 00    	je     80093c <vprintfmt+0x40f>
				return;
			putch(ch, putdat);
  800550:	89 74 24 04          	mov    %esi,0x4(%esp)
  800554:	89 04 24             	mov    %eax,(%esp)
  800557:	ff d7                	call   *%edi
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800559:	0f b6 03             	movzbl (%ebx),%eax
  80055c:	83 c3 01             	add    $0x1,%ebx
  80055f:	83 f8 25             	cmp    $0x25,%eax
  800562:	75 e4                	jne    800548 <vprintfmt+0x1b>
  800564:	c6 45 d4 20          	movb   $0x20,-0x2c(%ebp)
  800568:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
  80056f:	c7 45 d0 ff ff ff ff 	movl   $0xffffffff,-0x30(%ebp)
  800576:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
  80057d:	b9 00 00 00 00       	mov    $0x0,%ecx
  800582:	eb 06                	jmp    80058a <vprintfmt+0x5d>
  800584:	c6 45 d4 2d          	movb   $0x2d,-0x2c(%ebp)
  800588:	89 c3                	mov    %eax,%ebx
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80058a:	0f b6 13             	movzbl (%ebx),%edx
  80058d:	0f b6 c2             	movzbl %dl,%eax
  800590:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800593:	8d 43 01             	lea    0x1(%ebx),%eax
  800596:	83 ea 23             	sub    $0x23,%edx
  800599:	80 fa 55             	cmp    $0x55,%dl
  80059c:	0f 87 7d 03 00 00    	ja     80091f <vprintfmt+0x3f2>
  8005a2:	0f b6 d2             	movzbl %dl,%edx
  8005a5:	ff 24 95 00 2c 80 00 	jmp    *0x802c00(,%edx,4)
  8005ac:	c6 45 d4 30          	movb   $0x30,-0x2c(%ebp)
  8005b0:	eb d6                	jmp    800588 <vprintfmt+0x5b>
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
				precision = precision * 10 + ch - '0';
  8005b2:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8005b5:	83 ea 30             	sub    $0x30,%edx
  8005b8:	89 55 d0             	mov    %edx,-0x30(%ebp)
				ch = *fmt;
  8005bb:	0f be 10             	movsbl (%eax),%edx
				if (ch < '0' || ch > '9')
  8005be:	8d 5a d0             	lea    -0x30(%edx),%ebx
  8005c1:	83 fb 09             	cmp    $0x9,%ebx
  8005c4:	77 4c                	ja     800612 <vprintfmt+0xe5>
  8005c6:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  8005c9:	8b 4d d0             	mov    -0x30(%ebp),%ecx
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8005cc:	83 c0 01             	add    $0x1,%eax
				precision = precision * 10 + ch - '0';
  8005cf:	8d 0c 89             	lea    (%ecx,%ecx,4),%ecx
  8005d2:	8d 4c 4a d0          	lea    -0x30(%edx,%ecx,2),%ecx
				ch = *fmt;
  8005d6:	0f be 10             	movsbl (%eax),%edx
				if (ch < '0' || ch > '9')
  8005d9:	8d 5a d0             	lea    -0x30(%edx),%ebx
  8005dc:	83 fb 09             	cmp    $0x9,%ebx
  8005df:	76 eb                	jbe    8005cc <vprintfmt+0x9f>
  8005e1:	89 4d d0             	mov    %ecx,-0x30(%ebp)
  8005e4:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  8005e7:	eb 29                	jmp    800612 <vprintfmt+0xe5>
					break;
			}
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  8005e9:	8b 55 14             	mov    0x14(%ebp),%edx
  8005ec:	8d 5a 04             	lea    0x4(%edx),%ebx
  8005ef:	89 5d 14             	mov    %ebx,0x14(%ebp)
  8005f2:	8b 12                	mov    (%edx),%edx
  8005f4:	89 55 d0             	mov    %edx,-0x30(%ebp)
			goto process_precision;
  8005f7:	eb 19                	jmp    800612 <vprintfmt+0xe5>

		case '.':
			if (width < 0)
  8005f9:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8005fc:	c1 fa 1f             	sar    $0x1f,%edx
  8005ff:	f7 d2                	not    %edx
  800601:	21 55 e4             	and    %edx,-0x1c(%ebp)
  800604:	eb 82                	jmp    800588 <vprintfmt+0x5b>
  800606:	c7 45 d8 01 00 00 00 	movl   $0x1,-0x28(%ebp)
				width = 0;
			goto reswitch;

		case '#':
			altflag = 1;
			goto reswitch;
  80060d:	e9 76 ff ff ff       	jmp    800588 <vprintfmt+0x5b>

		process_precision:
			if (width < 0)
  800612:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800616:	0f 89 6c ff ff ff    	jns    800588 <vprintfmt+0x5b>
  80061c:	8b 55 d0             	mov    -0x30(%ebp),%edx
  80061f:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  800622:	8b 55 c8             	mov    -0x38(%ebp),%edx
  800625:	89 55 d0             	mov    %edx,-0x30(%ebp)
  800628:	e9 5b ff ff ff       	jmp    800588 <vprintfmt+0x5b>
				width = precision, precision = -1;
			goto reswitch;

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  80062d:	83 c1 01             	add    $0x1,%ecx
			goto reswitch;
  800630:	e9 53 ff ff ff       	jmp    800588 <vprintfmt+0x5b>
  800635:	89 45 cc             	mov    %eax,-0x34(%ebp)

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800638:	8b 45 14             	mov    0x14(%ebp),%eax
  80063b:	8d 50 04             	lea    0x4(%eax),%edx
  80063e:	89 55 14             	mov    %edx,0x14(%ebp)
  800641:	89 74 24 04          	mov    %esi,0x4(%esp)
  800645:	8b 00                	mov    (%eax),%eax
  800647:	89 04 24             	mov    %eax,(%esp)
  80064a:	ff d7                	call   *%edi
  80064c:	8b 5d cc             	mov    -0x34(%ebp),%ebx
			break;
  80064f:	e9 05 ff ff ff       	jmp    800559 <vprintfmt+0x2c>
  800654:	89 45 cc             	mov    %eax,-0x34(%ebp)

		// error message
		case 'e':
			err = va_arg(ap, int);
  800657:	8b 45 14             	mov    0x14(%ebp),%eax
  80065a:	8d 50 04             	lea    0x4(%eax),%edx
  80065d:	89 55 14             	mov    %edx,0x14(%ebp)
  800660:	8b 00                	mov    (%eax),%eax
  800662:	89 c2                	mov    %eax,%edx
  800664:	c1 fa 1f             	sar    $0x1f,%edx
  800667:	31 d0                	xor    %edx,%eax
  800669:	29 d0                	sub    %edx,%eax
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  80066b:	83 f8 0f             	cmp    $0xf,%eax
  80066e:	7f 0b                	jg     80067b <vprintfmt+0x14e>
  800670:	8b 14 85 60 2d 80 00 	mov    0x802d60(,%eax,4),%edx
  800677:	85 d2                	test   %edx,%edx
  800679:	75 20                	jne    80069b <vprintfmt+0x16e>
				printfmt(putch, putdat, "error %d", err);
  80067b:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80067f:	c7 44 24 08 c0 2a 80 	movl   $0x802ac0,0x8(%esp)
  800686:	00 
  800687:	89 74 24 04          	mov    %esi,0x4(%esp)
  80068b:	89 3c 24             	mov    %edi,(%esp)
  80068e:	e8 31 03 00 00       	call   8009c4 <printfmt>
  800693:	8b 5d cc             	mov    -0x34(%ebp),%ebx
		// error message
		case 'e':
			err = va_arg(ap, int);
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800696:	e9 be fe ff ff       	jmp    800559 <vprintfmt+0x2c>
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  80069b:	89 54 24 0c          	mov    %edx,0xc(%esp)
  80069f:	c7 44 24 08 a6 2e 80 	movl   $0x802ea6,0x8(%esp)
  8006a6:	00 
  8006a7:	89 74 24 04          	mov    %esi,0x4(%esp)
  8006ab:	89 3c 24             	mov    %edi,(%esp)
  8006ae:	e8 11 03 00 00       	call   8009c4 <printfmt>
  8006b3:	8b 5d cc             	mov    -0x34(%ebp),%ebx
  8006b6:	e9 9e fe ff ff       	jmp    800559 <vprintfmt+0x2c>
  8006bb:	89 45 cc             	mov    %eax,-0x34(%ebp)
  8006be:	89 c3                	mov    %eax,%ebx
  8006c0:	8b 4d d0             	mov    -0x30(%ebp),%ecx
  8006c3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8006c6:	89 45 c4             	mov    %eax,-0x3c(%ebp)
			break;

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  8006c9:	8b 45 14             	mov    0x14(%ebp),%eax
  8006cc:	8d 50 04             	lea    0x4(%eax),%edx
  8006cf:	89 55 14             	mov    %edx,0x14(%ebp)
  8006d2:	8b 00                	mov    (%eax),%eax
  8006d4:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8006d7:	85 c0                	test   %eax,%eax
  8006d9:	75 07                	jne    8006e2 <vprintfmt+0x1b5>
  8006db:	c7 45 e0 c9 2a 80 00 	movl   $0x802ac9,-0x20(%ebp)
				p = "(null)";
			if (width > 0 && padc != '-')
  8006e2:	83 7d c4 00          	cmpl   $0x0,-0x3c(%ebp)
  8006e6:	7e 06                	jle    8006ee <vprintfmt+0x1c1>
  8006e8:	80 7d d4 2d          	cmpb   $0x2d,-0x2c(%ebp)
  8006ec:	75 13                	jne    800701 <vprintfmt+0x1d4>
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8006ee:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8006f1:	0f be 02             	movsbl (%edx),%eax
  8006f4:	85 c0                	test   %eax,%eax
  8006f6:	0f 85 99 00 00 00    	jne    800795 <vprintfmt+0x268>
  8006fc:	e9 86 00 00 00       	jmp    800787 <vprintfmt+0x25a>
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800701:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  800705:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  800708:	89 0c 24             	mov    %ecx,(%esp)
  80070b:	e8 fb 02 00 00       	call   800a0b <strnlen>
  800710:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  800713:	29 c2                	sub    %eax,%edx
  800715:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  800718:	85 d2                	test   %edx,%edx
  80071a:	7e d2                	jle    8006ee <vprintfmt+0x1c1>
					putch(padc, putdat);
  80071c:	0f be 4d d4          	movsbl -0x2c(%ebp),%ecx
  800720:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  800723:	89 5d c4             	mov    %ebx,-0x3c(%ebp)
  800726:	89 d3                	mov    %edx,%ebx
  800728:	89 74 24 04          	mov    %esi,0x4(%esp)
  80072c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80072f:	89 04 24             	mov    %eax,(%esp)
  800732:	ff d7                	call   *%edi
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800734:	83 eb 01             	sub    $0x1,%ebx
  800737:	85 db                	test   %ebx,%ebx
  800739:	7f ed                	jg     800728 <vprintfmt+0x1fb>
  80073b:	8b 5d c4             	mov    -0x3c(%ebp),%ebx
  80073e:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  800745:	eb a7                	jmp    8006ee <vprintfmt+0x1c1>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
  800747:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  80074b:	74 18                	je     800765 <vprintfmt+0x238>
  80074d:	8d 50 e0             	lea    -0x20(%eax),%edx
  800750:	83 fa 5e             	cmp    $0x5e,%edx
  800753:	76 10                	jbe    800765 <vprintfmt+0x238>
					putch('?', putdat);
  800755:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800759:	c7 04 24 3f 00 00 00 	movl   $0x3f,(%esp)
  800760:	ff 55 e0             	call   *-0x20(%ebp)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
  800763:	eb 0a                	jmp    80076f <vprintfmt+0x242>
					putch('?', putdat);
				else
					putch(ch, putdat);
  800765:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800769:	89 04 24             	mov    %eax,(%esp)
  80076c:	ff 55 e0             	call   *-0x20(%ebp)
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  80076f:	83 6d e4 01          	subl   $0x1,-0x1c(%ebp)
  800773:	0f be 03             	movsbl (%ebx),%eax
  800776:	85 c0                	test   %eax,%eax
  800778:	74 05                	je     80077f <vprintfmt+0x252>
  80077a:	83 c3 01             	add    $0x1,%ebx
  80077d:	eb 29                	jmp    8007a8 <vprintfmt+0x27b>
  80077f:	89 fe                	mov    %edi,%esi
  800781:	8b 7d e0             	mov    -0x20(%ebp),%edi
  800784:	8b 5d d0             	mov    -0x30(%ebp),%ebx
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800787:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80078b:	7f 2e                	jg     8007bb <vprintfmt+0x28e>
  80078d:	8b 5d cc             	mov    -0x34(%ebp),%ebx
  800790:	e9 c4 fd ff ff       	jmp    800559 <vprintfmt+0x2c>
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800795:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800798:	83 c2 01             	add    $0x1,%edx
  80079b:	89 7d e0             	mov    %edi,-0x20(%ebp)
  80079e:	89 f7                	mov    %esi,%edi
  8007a0:	8b 75 d0             	mov    -0x30(%ebp),%esi
  8007a3:	89 5d d0             	mov    %ebx,-0x30(%ebp)
  8007a6:	89 d3                	mov    %edx,%ebx
  8007a8:	85 f6                	test   %esi,%esi
  8007aa:	78 9b                	js     800747 <vprintfmt+0x21a>
  8007ac:	83 ee 01             	sub    $0x1,%esi
  8007af:	79 96                	jns    800747 <vprintfmt+0x21a>
  8007b1:	89 fe                	mov    %edi,%esi
  8007b3:	8b 7d e0             	mov    -0x20(%ebp),%edi
  8007b6:	8b 5d d0             	mov    -0x30(%ebp),%ebx
  8007b9:	eb cc                	jmp    800787 <vprintfmt+0x25a>
  8007bb:	89 5d d8             	mov    %ebx,-0x28(%ebp)
  8007be:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
				putch(' ', putdat);
  8007c1:	89 74 24 04          	mov    %esi,0x4(%esp)
  8007c5:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  8007cc:	ff d7                	call   *%edi
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  8007ce:	83 eb 01             	sub    $0x1,%ebx
  8007d1:	85 db                	test   %ebx,%ebx
  8007d3:	7f ec                	jg     8007c1 <vprintfmt+0x294>
  8007d5:	8b 5d d8             	mov    -0x28(%ebp),%ebx
  8007d8:	e9 7c fd ff ff       	jmp    800559 <vprintfmt+0x2c>
  8007dd:	89 45 cc             	mov    %eax,-0x34(%ebp)
// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
	if (lflag >= 2)
  8007e0:	83 f9 01             	cmp    $0x1,%ecx
  8007e3:	7e 16                	jle    8007fb <vprintfmt+0x2ce>
		return va_arg(*ap, long long);
  8007e5:	8b 45 14             	mov    0x14(%ebp),%eax
  8007e8:	8d 50 08             	lea    0x8(%eax),%edx
  8007eb:	89 55 14             	mov    %edx,0x14(%ebp)
  8007ee:	8b 10                	mov    (%eax),%edx
  8007f0:	8b 48 04             	mov    0x4(%eax),%ecx
  8007f3:	89 55 d8             	mov    %edx,-0x28(%ebp)
  8007f6:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  8007f9:	eb 32                	jmp    80082d <vprintfmt+0x300>
	else if (lflag)
  8007fb:	85 c9                	test   %ecx,%ecx
  8007fd:	74 18                	je     800817 <vprintfmt+0x2ea>
		return va_arg(*ap, long);
  8007ff:	8b 45 14             	mov    0x14(%ebp),%eax
  800802:	8d 50 04             	lea    0x4(%eax),%edx
  800805:	89 55 14             	mov    %edx,0x14(%ebp)
  800808:	8b 00                	mov    (%eax),%eax
  80080a:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80080d:	89 c1                	mov    %eax,%ecx
  80080f:	c1 f9 1f             	sar    $0x1f,%ecx
  800812:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  800815:	eb 16                	jmp    80082d <vprintfmt+0x300>
	else
		return va_arg(*ap, int);
  800817:	8b 45 14             	mov    0x14(%ebp),%eax
  80081a:	8d 50 04             	lea    0x4(%eax),%edx
  80081d:	89 55 14             	mov    %edx,0x14(%ebp)
  800820:	8b 00                	mov    (%eax),%eax
  800822:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800825:	89 c2                	mov    %eax,%edx
  800827:	c1 fa 1f             	sar    $0x1f,%edx
  80082a:	89 55 dc             	mov    %edx,-0x24(%ebp)
				putch(' ', putdat);
			break;

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  80082d:	8b 4d d8             	mov    -0x28(%ebp),%ecx
  800830:	8b 5d dc             	mov    -0x24(%ebp),%ebx
  800833:	b8 0a 00 00 00       	mov    $0xa,%eax
			if ((long long) num < 0) {
  800838:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  80083c:	0f 89 9b 00 00 00    	jns    8008dd <vprintfmt+0x3b0>
				putch('-', putdat);
  800842:	89 74 24 04          	mov    %esi,0x4(%esp)
  800846:	c7 04 24 2d 00 00 00 	movl   $0x2d,(%esp)
  80084d:	ff d7                	call   *%edi
				num = -(long long) num;
  80084f:	8b 4d d8             	mov    -0x28(%ebp),%ecx
  800852:	8b 5d dc             	mov    -0x24(%ebp),%ebx
  800855:	f7 d9                	neg    %ecx
  800857:	83 d3 00             	adc    $0x0,%ebx
  80085a:	f7 db                	neg    %ebx
  80085c:	b8 0a 00 00 00       	mov    $0xa,%eax
  800861:	eb 7a                	jmp    8008dd <vprintfmt+0x3b0>
  800863:	89 45 cc             	mov    %eax,-0x34(%ebp)
			base = 10;
			goto number;

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800866:	89 ca                	mov    %ecx,%edx
  800868:	8d 45 14             	lea    0x14(%ebp),%eax
  80086b:	e8 66 fc ff ff       	call   8004d6 <getuint>
  800870:	89 c1                	mov    %eax,%ecx
  800872:	89 d3                	mov    %edx,%ebx
  800874:	b8 0a 00 00 00       	mov    $0xa,%eax
			base = 10;
			goto number;
  800879:	eb 62                	jmp    8008dd <vprintfmt+0x3b0>
  80087b:	89 45 cc             	mov    %eax,-0x34(%ebp)
		case 'o':
			// Replace this with your code.
			// putch('X', putdat);
			// putch('X', putdat);
			// putch('X', putdat);
			num = getuint(&ap, lflag);
  80087e:	89 ca                	mov    %ecx,%edx
  800880:	8d 45 14             	lea    0x14(%ebp),%eax
  800883:	e8 4e fc ff ff       	call   8004d6 <getuint>
  800888:	89 c1                	mov    %eax,%ecx
  80088a:	89 d3                	mov    %edx,%ebx
  80088c:	b8 08 00 00 00       	mov    $0x8,%eax
			base = 8;
			goto number;
  800891:	eb 4a                	jmp    8008dd <vprintfmt+0x3b0>
  800893:	89 45 cc             	mov    %eax,-0x34(%ebp)
			break;

		// pointer
		case 'p':
			putch('0', putdat);
  800896:	89 74 24 04          	mov    %esi,0x4(%esp)
  80089a:	c7 04 24 30 00 00 00 	movl   $0x30,(%esp)
  8008a1:	ff d7                	call   *%edi
			putch('x', putdat);
  8008a3:	89 74 24 04          	mov    %esi,0x4(%esp)
  8008a7:	c7 04 24 78 00 00 00 	movl   $0x78,(%esp)
  8008ae:	ff d7                	call   *%edi
			num = (unsigned long long)
  8008b0:	8b 45 14             	mov    0x14(%ebp),%eax
  8008b3:	8d 50 04             	lea    0x4(%eax),%edx
  8008b6:	89 55 14             	mov    %edx,0x14(%ebp)
  8008b9:	8b 08                	mov    (%eax),%ecx
  8008bb:	bb 00 00 00 00       	mov    $0x0,%ebx
  8008c0:	b8 10 00 00 00       	mov    $0x10,%eax
				(uintptr_t) va_arg(ap, void *);
			base = 16;
			goto number;
  8008c5:	eb 16                	jmp    8008dd <vprintfmt+0x3b0>
  8008c7:	89 45 cc             	mov    %eax,-0x34(%ebp)

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  8008ca:	89 ca                	mov    %ecx,%edx
  8008cc:	8d 45 14             	lea    0x14(%ebp),%eax
  8008cf:	e8 02 fc ff ff       	call   8004d6 <getuint>
  8008d4:	89 c1                	mov    %eax,%ecx
  8008d6:	89 d3                	mov    %edx,%ebx
  8008d8:	b8 10 00 00 00       	mov    $0x10,%eax
			base = 16;
		number:
			printnum(putch, putdat, num, base, width, padc);
  8008dd:	0f be 55 d4          	movsbl -0x2c(%ebp),%edx
  8008e1:	89 54 24 10          	mov    %edx,0x10(%esp)
  8008e5:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8008e8:	89 54 24 0c          	mov    %edx,0xc(%esp)
  8008ec:	89 44 24 08          	mov    %eax,0x8(%esp)
  8008f0:	89 0c 24             	mov    %ecx,(%esp)
  8008f3:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8008f7:	89 f2                	mov    %esi,%edx
  8008f9:	89 f8                	mov    %edi,%eax
  8008fb:	e8 e0 fa ff ff       	call   8003e0 <printnum>
  800900:	8b 5d cc             	mov    -0x34(%ebp),%ebx
			break;
  800903:	e9 51 fc ff ff       	jmp    800559 <vprintfmt+0x2c>
  800908:	89 45 cc             	mov    %eax,-0x34(%ebp)
  80090b:	8b 55 e0             	mov    -0x20(%ebp),%edx

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  80090e:	89 74 24 04          	mov    %esi,0x4(%esp)
  800912:	89 14 24             	mov    %edx,(%esp)
  800915:	ff d7                	call   *%edi
  800917:	8b 5d cc             	mov    -0x34(%ebp),%ebx
			break;
  80091a:	e9 3a fc ff ff       	jmp    800559 <vprintfmt+0x2c>
			
		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  80091f:	89 74 24 04          	mov    %esi,0x4(%esp)
  800923:	c7 04 24 25 00 00 00 	movl   $0x25,(%esp)
  80092a:	ff d7                	call   *%edi
			for (fmt--; fmt[-1] != '%'; fmt--)
  80092c:	8d 43 ff             	lea    -0x1(%ebx),%eax
  80092f:	80 38 25             	cmpb   $0x25,(%eax)
  800932:	0f 84 21 fc ff ff    	je     800559 <vprintfmt+0x2c>
  800938:	89 c3                	mov    %eax,%ebx
  80093a:	eb f0                	jmp    80092c <vprintfmt+0x3ff>
				/* do nothing */;
			break;
		}
	}
}
  80093c:	83 c4 5c             	add    $0x5c,%esp
  80093f:	5b                   	pop    %ebx
  800940:	5e                   	pop    %esi
  800941:	5f                   	pop    %edi
  800942:	5d                   	pop    %ebp
  800943:	c3                   	ret    

00800944 <vsnprintf>:
		*b->buf++ = ch;
}

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800944:	55                   	push   %ebp
  800945:	89 e5                	mov    %esp,%ebp
  800947:	83 ec 28             	sub    $0x28,%esp
  80094a:	8b 45 08             	mov    0x8(%ebp),%eax
  80094d:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};

	if (buf == NULL || n < 1)
  800950:	85 c0                	test   %eax,%eax
  800952:	74 04                	je     800958 <vsnprintf+0x14>
  800954:	85 d2                	test   %edx,%edx
  800956:	7f 07                	jg     80095f <vsnprintf+0x1b>
  800958:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80095d:	eb 3b                	jmp    80099a <vsnprintf+0x56>
}

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
	struct sprintbuf b = {buf, buf+n-1, 0};
  80095f:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800962:	8d 44 10 ff          	lea    -0x1(%eax,%edx,1),%eax
  800966:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800969:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800970:	8b 45 14             	mov    0x14(%ebp),%eax
  800973:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800977:	8b 45 10             	mov    0x10(%ebp),%eax
  80097a:	89 44 24 08          	mov    %eax,0x8(%esp)
  80097e:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800981:	89 44 24 04          	mov    %eax,0x4(%esp)
  800985:	c7 04 24 10 05 80 00 	movl   $0x800510,(%esp)
  80098c:	e8 9c fb ff ff       	call   80052d <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  800991:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800994:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800997:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  80099a:	c9                   	leave  
  80099b:	c3                   	ret    

0080099c <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  80099c:	55                   	push   %ebp
  80099d:	89 e5                	mov    %esp,%ebp
  80099f:	83 ec 18             	sub    $0x18,%esp

	return b.cnt;
}

int
snprintf(char *buf, int n, const char *fmt, ...)
  8009a2:	8d 45 14             	lea    0x14(%ebp),%eax
{
	va_list ap;
	int rc;

	va_start(ap, fmt);
	rc = vsnprintf(buf, n, fmt, ap);
  8009a5:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8009a9:	8b 45 10             	mov    0x10(%ebp),%eax
  8009ac:	89 44 24 08          	mov    %eax,0x8(%esp)
  8009b0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8009b3:	89 44 24 04          	mov    %eax,0x4(%esp)
  8009b7:	8b 45 08             	mov    0x8(%ebp),%eax
  8009ba:	89 04 24             	mov    %eax,(%esp)
  8009bd:	e8 82 ff ff ff       	call   800944 <vsnprintf>
	va_end(ap);

	return rc;
}
  8009c2:	c9                   	leave  
  8009c3:	c3                   	ret    

008009c4 <printfmt>:
	}
}

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  8009c4:	55                   	push   %ebp
  8009c5:	89 e5                	mov    %esp,%ebp
  8009c7:	83 ec 18             	sub    $0x18,%esp
		}
	}
}

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
  8009ca:	8d 45 14             	lea    0x14(%ebp),%eax
{
	va_list ap;

	va_start(ap, fmt);
	vprintfmt(putch, putdat, fmt, ap);
  8009cd:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8009d1:	8b 45 10             	mov    0x10(%ebp),%eax
  8009d4:	89 44 24 08          	mov    %eax,0x8(%esp)
  8009d8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8009db:	89 44 24 04          	mov    %eax,0x4(%esp)
  8009df:	8b 45 08             	mov    0x8(%ebp),%eax
  8009e2:	89 04 24             	mov    %eax,(%esp)
  8009e5:	e8 43 fb ff ff       	call   80052d <vprintfmt>
	va_end(ap);
}
  8009ea:	c9                   	leave  
  8009eb:	c3                   	ret    
  8009ec:	00 00                	add    %al,(%eax)
	...

008009f0 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  8009f0:	55                   	push   %ebp
  8009f1:	89 e5                	mov    %esp,%ebp
  8009f3:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  8009f6:	b8 00 00 00 00       	mov    $0x0,%eax
  8009fb:	80 3a 00             	cmpb   $0x0,(%edx)
  8009fe:	74 09                	je     800a09 <strlen+0x19>
		n++;
  800a00:	83 c0 01             	add    $0x1,%eax
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800a03:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  800a07:	75 f7                	jne    800a00 <strlen+0x10>
		n++;
	return n;
}
  800a09:	5d                   	pop    %ebp
  800a0a:	c3                   	ret    

00800a0b <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800a0b:	55                   	push   %ebp
  800a0c:	89 e5                	mov    %esp,%ebp
  800a0e:	53                   	push   %ebx
  800a0f:	8b 5d 08             	mov    0x8(%ebp),%ebx
  800a12:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800a15:	85 c9                	test   %ecx,%ecx
  800a17:	74 19                	je     800a32 <strnlen+0x27>
  800a19:	80 3b 00             	cmpb   $0x0,(%ebx)
  800a1c:	74 14                	je     800a32 <strnlen+0x27>
  800a1e:	b8 00 00 00 00       	mov    $0x0,%eax
		n++;
  800a23:	83 c0 01             	add    $0x1,%eax
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800a26:	39 c8                	cmp    %ecx,%eax
  800a28:	74 0d                	je     800a37 <strnlen+0x2c>
  800a2a:	80 3c 03 00          	cmpb   $0x0,(%ebx,%eax,1)
  800a2e:	75 f3                	jne    800a23 <strnlen+0x18>
  800a30:	eb 05                	jmp    800a37 <strnlen+0x2c>
  800a32:	b8 00 00 00 00       	mov    $0x0,%eax
		n++;
	return n;
}
  800a37:	5b                   	pop    %ebx
  800a38:	5d                   	pop    %ebp
  800a39:	c3                   	ret    

00800a3a <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800a3a:	55                   	push   %ebp
  800a3b:	89 e5                	mov    %esp,%ebp
  800a3d:	53                   	push   %ebx
  800a3e:	8b 45 08             	mov    0x8(%ebp),%eax
  800a41:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800a44:	ba 00 00 00 00       	mov    $0x0,%edx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  800a49:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
  800a4d:	88 0c 10             	mov    %cl,(%eax,%edx,1)
  800a50:	83 c2 01             	add    $0x1,%edx
  800a53:	84 c9                	test   %cl,%cl
  800a55:	75 f2                	jne    800a49 <strcpy+0xf>
		/* do nothing */;
	return ret;
}
  800a57:	5b                   	pop    %ebx
  800a58:	5d                   	pop    %ebp
  800a59:	c3                   	ret    

00800a5a <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800a5a:	55                   	push   %ebp
  800a5b:	89 e5                	mov    %esp,%ebp
  800a5d:	56                   	push   %esi
  800a5e:	53                   	push   %ebx
  800a5f:	8b 45 08             	mov    0x8(%ebp),%eax
  800a62:	8b 55 0c             	mov    0xc(%ebp),%edx
  800a65:	8b 75 10             	mov    0x10(%ebp),%esi
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800a68:	85 f6                	test   %esi,%esi
  800a6a:	74 18                	je     800a84 <strncpy+0x2a>
  800a6c:	b9 00 00 00 00       	mov    $0x0,%ecx
		*dst++ = *src;
  800a71:	0f b6 1a             	movzbl (%edx),%ebx
  800a74:	88 1c 08             	mov    %bl,(%eax,%ecx,1)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  800a77:	80 3a 01             	cmpb   $0x1,(%edx)
  800a7a:	83 da ff             	sbb    $0xffffffff,%edx
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800a7d:	83 c1 01             	add    $0x1,%ecx
  800a80:	39 ce                	cmp    %ecx,%esi
  800a82:	77 ed                	ja     800a71 <strncpy+0x17>
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
}
  800a84:	5b                   	pop    %ebx
  800a85:	5e                   	pop    %esi
  800a86:	5d                   	pop    %ebp
  800a87:	c3                   	ret    

00800a88 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800a88:	55                   	push   %ebp
  800a89:	89 e5                	mov    %esp,%ebp
  800a8b:	56                   	push   %esi
  800a8c:	53                   	push   %ebx
  800a8d:	8b 75 08             	mov    0x8(%ebp),%esi
  800a90:	8b 55 0c             	mov    0xc(%ebp),%edx
  800a93:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  800a96:	89 f0                	mov    %esi,%eax
  800a98:	85 c9                	test   %ecx,%ecx
  800a9a:	74 27                	je     800ac3 <strlcpy+0x3b>
		while (--size > 0 && *src != '\0')
  800a9c:	83 e9 01             	sub    $0x1,%ecx
  800a9f:	74 1d                	je     800abe <strlcpy+0x36>
  800aa1:	0f b6 1a             	movzbl (%edx),%ebx
  800aa4:	84 db                	test   %bl,%bl
  800aa6:	74 16                	je     800abe <strlcpy+0x36>
			*dst++ = *src++;
  800aa8:	88 18                	mov    %bl,(%eax)
  800aaa:	83 c0 01             	add    $0x1,%eax
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800aad:	83 e9 01             	sub    $0x1,%ecx
  800ab0:	74 0e                	je     800ac0 <strlcpy+0x38>
			*dst++ = *src++;
  800ab2:	83 c2 01             	add    $0x1,%edx
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800ab5:	0f b6 1a             	movzbl (%edx),%ebx
  800ab8:	84 db                	test   %bl,%bl
  800aba:	75 ec                	jne    800aa8 <strlcpy+0x20>
  800abc:	eb 02                	jmp    800ac0 <strlcpy+0x38>
  800abe:	89 f0                	mov    %esi,%eax
			*dst++ = *src++;
		*dst = '\0';
  800ac0:	c6 00 00             	movb   $0x0,(%eax)
  800ac3:	29 f0                	sub    %esi,%eax
	}
	return dst - dst_in;
}
  800ac5:	5b                   	pop    %ebx
  800ac6:	5e                   	pop    %esi
  800ac7:	5d                   	pop    %ebp
  800ac8:	c3                   	ret    

00800ac9 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800ac9:	55                   	push   %ebp
  800aca:	89 e5                	mov    %esp,%ebp
  800acc:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800acf:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  800ad2:	0f b6 01             	movzbl (%ecx),%eax
  800ad5:	84 c0                	test   %al,%al
  800ad7:	74 15                	je     800aee <strcmp+0x25>
  800ad9:	3a 02                	cmp    (%edx),%al
  800adb:	75 11                	jne    800aee <strcmp+0x25>
		p++, q++;
  800add:	83 c1 01             	add    $0x1,%ecx
  800ae0:	83 c2 01             	add    $0x1,%edx
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800ae3:	0f b6 01             	movzbl (%ecx),%eax
  800ae6:	84 c0                	test   %al,%al
  800ae8:	74 04                	je     800aee <strcmp+0x25>
  800aea:	3a 02                	cmp    (%edx),%al
  800aec:	74 ef                	je     800add <strcmp+0x14>
  800aee:	0f b6 c0             	movzbl %al,%eax
  800af1:	0f b6 12             	movzbl (%edx),%edx
  800af4:	29 d0                	sub    %edx,%eax
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
}
  800af6:	5d                   	pop    %ebp
  800af7:	c3                   	ret    

00800af8 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800af8:	55                   	push   %ebp
  800af9:	89 e5                	mov    %esp,%ebp
  800afb:	53                   	push   %ebx
  800afc:	8b 55 08             	mov    0x8(%ebp),%edx
  800aff:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800b02:	8b 45 10             	mov    0x10(%ebp),%eax
	while (n > 0 && *p && *p == *q)
  800b05:	85 c0                	test   %eax,%eax
  800b07:	74 23                	je     800b2c <strncmp+0x34>
  800b09:	0f b6 1a             	movzbl (%edx),%ebx
  800b0c:	84 db                	test   %bl,%bl
  800b0e:	74 24                	je     800b34 <strncmp+0x3c>
  800b10:	3a 19                	cmp    (%ecx),%bl
  800b12:	75 20                	jne    800b34 <strncmp+0x3c>
  800b14:	83 e8 01             	sub    $0x1,%eax
  800b17:	74 13                	je     800b2c <strncmp+0x34>
		n--, p++, q++;
  800b19:	83 c2 01             	add    $0x1,%edx
  800b1c:	83 c1 01             	add    $0x1,%ecx
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  800b1f:	0f b6 1a             	movzbl (%edx),%ebx
  800b22:	84 db                	test   %bl,%bl
  800b24:	74 0e                	je     800b34 <strncmp+0x3c>
  800b26:	3a 19                	cmp    (%ecx),%bl
  800b28:	74 ea                	je     800b14 <strncmp+0x1c>
  800b2a:	eb 08                	jmp    800b34 <strncmp+0x3c>
  800b2c:	b8 00 00 00 00       	mov    $0x0,%eax
		n--, p++, q++;
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
}
  800b31:	5b                   	pop    %ebx
  800b32:	5d                   	pop    %ebp
  800b33:	c3                   	ret    
	while (n > 0 && *p && *p == *q)
		n--, p++, q++;
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800b34:	0f b6 02             	movzbl (%edx),%eax
  800b37:	0f b6 11             	movzbl (%ecx),%edx
  800b3a:	29 d0                	sub    %edx,%eax
  800b3c:	eb f3                	jmp    800b31 <strncmp+0x39>

00800b3e <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800b3e:	55                   	push   %ebp
  800b3f:	89 e5                	mov    %esp,%ebp
  800b41:	8b 45 08             	mov    0x8(%ebp),%eax
  800b44:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800b48:	0f b6 10             	movzbl (%eax),%edx
  800b4b:	84 d2                	test   %dl,%dl
  800b4d:	74 15                	je     800b64 <strchr+0x26>
		if (*s == c)
  800b4f:	38 ca                	cmp    %cl,%dl
  800b51:	75 07                	jne    800b5a <strchr+0x1c>
  800b53:	eb 14                	jmp    800b69 <strchr+0x2b>
  800b55:	38 ca                	cmp    %cl,%dl
  800b57:	90                   	nop
  800b58:	74 0f                	je     800b69 <strchr+0x2b>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800b5a:	83 c0 01             	add    $0x1,%eax
  800b5d:	0f b6 10             	movzbl (%eax),%edx
  800b60:	84 d2                	test   %dl,%dl
  800b62:	75 f1                	jne    800b55 <strchr+0x17>
  800b64:	b8 00 00 00 00       	mov    $0x0,%eax
		if (*s == c)
			return (char *) s;
	return 0;
}
  800b69:	5d                   	pop    %ebp
  800b6a:	c3                   	ret    

00800b6b <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800b6b:	55                   	push   %ebp
  800b6c:	89 e5                	mov    %esp,%ebp
  800b6e:	8b 45 08             	mov    0x8(%ebp),%eax
  800b71:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800b75:	0f b6 10             	movzbl (%eax),%edx
  800b78:	84 d2                	test   %dl,%dl
  800b7a:	74 18                	je     800b94 <strfind+0x29>
		if (*s == c)
  800b7c:	38 ca                	cmp    %cl,%dl
  800b7e:	75 0a                	jne    800b8a <strfind+0x1f>
  800b80:	eb 12                	jmp    800b94 <strfind+0x29>
  800b82:	38 ca                	cmp    %cl,%dl
  800b84:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  800b88:	74 0a                	je     800b94 <strfind+0x29>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800b8a:	83 c0 01             	add    $0x1,%eax
  800b8d:	0f b6 10             	movzbl (%eax),%edx
  800b90:	84 d2                	test   %dl,%dl
  800b92:	75 ee                	jne    800b82 <strfind+0x17>
		if (*s == c)
			break;
	return (char *) s;
}
  800b94:	5d                   	pop    %ebp
  800b95:	c3                   	ret    

00800b96 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800b96:	55                   	push   %ebp
  800b97:	89 e5                	mov    %esp,%ebp
  800b99:	83 ec 0c             	sub    $0xc,%esp
  800b9c:	89 1c 24             	mov    %ebx,(%esp)
  800b9f:	89 74 24 04          	mov    %esi,0x4(%esp)
  800ba3:	89 7c 24 08          	mov    %edi,0x8(%esp)
  800ba7:	8b 7d 08             	mov    0x8(%ebp),%edi
  800baa:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bad:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800bb0:	85 c9                	test   %ecx,%ecx
  800bb2:	74 30                	je     800be4 <memset+0x4e>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800bb4:	f7 c7 03 00 00 00    	test   $0x3,%edi
  800bba:	75 25                	jne    800be1 <memset+0x4b>
  800bbc:	f6 c1 03             	test   $0x3,%cl
  800bbf:	75 20                	jne    800be1 <memset+0x4b>
		c &= 0xFF;
  800bc1:	0f b6 d0             	movzbl %al,%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800bc4:	89 d3                	mov    %edx,%ebx
  800bc6:	c1 e3 08             	shl    $0x8,%ebx
  800bc9:	89 d6                	mov    %edx,%esi
  800bcb:	c1 e6 18             	shl    $0x18,%esi
  800bce:	89 d0                	mov    %edx,%eax
  800bd0:	c1 e0 10             	shl    $0x10,%eax
  800bd3:	09 f0                	or     %esi,%eax
  800bd5:	09 d0                	or     %edx,%eax
		asm volatile("cld; rep stosl\n"
  800bd7:	09 d8                	or     %ebx,%eax
  800bd9:	c1 e9 02             	shr    $0x2,%ecx
  800bdc:	fc                   	cld    
  800bdd:	f3 ab                	rep stos %eax,%es:(%edi)
{
	char *p;

	if (n == 0)
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800bdf:	eb 03                	jmp    800be4 <memset+0x4e>
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800be1:	fc                   	cld    
  800be2:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800be4:	89 f8                	mov    %edi,%eax
  800be6:	8b 1c 24             	mov    (%esp),%ebx
  800be9:	8b 74 24 04          	mov    0x4(%esp),%esi
  800bed:	8b 7c 24 08          	mov    0x8(%esp),%edi
  800bf1:	89 ec                	mov    %ebp,%esp
  800bf3:	5d                   	pop    %ebp
  800bf4:	c3                   	ret    

00800bf5 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800bf5:	55                   	push   %ebp
  800bf6:	89 e5                	mov    %esp,%ebp
  800bf8:	83 ec 08             	sub    $0x8,%esp
  800bfb:	89 34 24             	mov    %esi,(%esp)
  800bfe:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800c02:	8b 45 08             	mov    0x8(%ebp),%eax
  800c05:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;
	
	s = src;
  800c08:	8b 75 0c             	mov    0xc(%ebp),%esi
	d = dst;
  800c0b:	89 c7                	mov    %eax,%edi
	if (s < d && s + n > d) {
  800c0d:	39 c6                	cmp    %eax,%esi
  800c0f:	73 35                	jae    800c46 <memmove+0x51>
  800c11:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800c14:	39 d0                	cmp    %edx,%eax
  800c16:	73 2e                	jae    800c46 <memmove+0x51>
		s += n;
		d += n;
  800c18:	01 cf                	add    %ecx,%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800c1a:	f6 c2 03             	test   $0x3,%dl
  800c1d:	75 1b                	jne    800c3a <memmove+0x45>
  800c1f:	f7 c7 03 00 00 00    	test   $0x3,%edi
  800c25:	75 13                	jne    800c3a <memmove+0x45>
  800c27:	f6 c1 03             	test   $0x3,%cl
  800c2a:	75 0e                	jne    800c3a <memmove+0x45>
			asm volatile("std; rep movsl\n"
  800c2c:	83 ef 04             	sub    $0x4,%edi
  800c2f:	8d 72 fc             	lea    -0x4(%edx),%esi
  800c32:	c1 e9 02             	shr    $0x2,%ecx
  800c35:	fd                   	std    
  800c36:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800c38:	eb 09                	jmp    800c43 <memmove+0x4e>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  800c3a:	83 ef 01             	sub    $0x1,%edi
  800c3d:	8d 72 ff             	lea    -0x1(%edx),%esi
  800c40:	fd                   	std    
  800c41:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800c43:	fc                   	cld    
	const char *s;
	char *d;
	
	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800c44:	eb 20                	jmp    800c66 <memmove+0x71>
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800c46:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800c4c:	75 15                	jne    800c63 <memmove+0x6e>
  800c4e:	f7 c7 03 00 00 00    	test   $0x3,%edi
  800c54:	75 0d                	jne    800c63 <memmove+0x6e>
  800c56:	f6 c1 03             	test   $0x3,%cl
  800c59:	75 08                	jne    800c63 <memmove+0x6e>
			asm volatile("cld; rep movsl\n"
  800c5b:	c1 e9 02             	shr    $0x2,%ecx
  800c5e:	fc                   	cld    
  800c5f:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800c61:	eb 03                	jmp    800c66 <memmove+0x71>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  800c63:	fc                   	cld    
  800c64:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800c66:	8b 34 24             	mov    (%esp),%esi
  800c69:	8b 7c 24 04          	mov    0x4(%esp),%edi
  800c6d:	89 ec                	mov    %ebp,%esp
  800c6f:	5d                   	pop    %ebp
  800c70:	c3                   	ret    

00800c71 <memcpy>:

/* sigh - gcc emits references to this for structure assignments! */
/* it is *not* prototyped in inc/string.h - do not use directly. */
void *
memcpy(void *dst, void *src, size_t n)
{
  800c71:	55                   	push   %ebp
  800c72:	89 e5                	mov    %esp,%ebp
  800c74:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  800c77:	8b 45 10             	mov    0x10(%ebp),%eax
  800c7a:	89 44 24 08          	mov    %eax,0x8(%esp)
  800c7e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c81:	89 44 24 04          	mov    %eax,0x4(%esp)
  800c85:	8b 45 08             	mov    0x8(%ebp),%eax
  800c88:	89 04 24             	mov    %eax,(%esp)
  800c8b:	e8 65 ff ff ff       	call   800bf5 <memmove>
}
  800c90:	c9                   	leave  
  800c91:	c3                   	ret    

00800c92 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800c92:	55                   	push   %ebp
  800c93:	89 e5                	mov    %esp,%ebp
  800c95:	57                   	push   %edi
  800c96:	56                   	push   %esi
  800c97:	53                   	push   %ebx
  800c98:	8b 75 08             	mov    0x8(%ebp),%esi
  800c9b:	8b 7d 0c             	mov    0xc(%ebp),%edi
  800c9e:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800ca1:	85 c9                	test   %ecx,%ecx
  800ca3:	74 36                	je     800cdb <memcmp+0x49>
		if (*s1 != *s2)
  800ca5:	0f b6 06             	movzbl (%esi),%eax
  800ca8:	0f b6 1f             	movzbl (%edi),%ebx
  800cab:	38 d8                	cmp    %bl,%al
  800cad:	74 20                	je     800ccf <memcmp+0x3d>
  800caf:	eb 14                	jmp    800cc5 <memcmp+0x33>
  800cb1:	0f b6 44 16 01       	movzbl 0x1(%esi,%edx,1),%eax
  800cb6:	0f b6 5c 17 01       	movzbl 0x1(%edi,%edx,1),%ebx
  800cbb:	83 c2 01             	add    $0x1,%edx
  800cbe:	83 e9 01             	sub    $0x1,%ecx
  800cc1:	38 d8                	cmp    %bl,%al
  800cc3:	74 12                	je     800cd7 <memcmp+0x45>
			return (int) *s1 - (int) *s2;
  800cc5:	0f b6 c0             	movzbl %al,%eax
  800cc8:	0f b6 db             	movzbl %bl,%ebx
  800ccb:	29 d8                	sub    %ebx,%eax
  800ccd:	eb 11                	jmp    800ce0 <memcmp+0x4e>
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800ccf:	83 e9 01             	sub    $0x1,%ecx
  800cd2:	ba 00 00 00 00       	mov    $0x0,%edx
  800cd7:	85 c9                	test   %ecx,%ecx
  800cd9:	75 d6                	jne    800cb1 <memcmp+0x1f>
  800cdb:	b8 00 00 00 00       	mov    $0x0,%eax
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
}
  800ce0:	5b                   	pop    %ebx
  800ce1:	5e                   	pop    %esi
  800ce2:	5f                   	pop    %edi
  800ce3:	5d                   	pop    %ebp
  800ce4:	c3                   	ret    

00800ce5 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800ce5:	55                   	push   %ebp
  800ce6:	89 e5                	mov    %esp,%ebp
  800ce8:	8b 45 08             	mov    0x8(%ebp),%eax
	const void *ends = (const char *) s + n;
  800ceb:	89 c2                	mov    %eax,%edx
  800ced:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800cf0:	39 d0                	cmp    %edx,%eax
  800cf2:	73 15                	jae    800d09 <memfind+0x24>
		if (*(const unsigned char *) s == (unsigned char) c)
  800cf4:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
  800cf8:	38 08                	cmp    %cl,(%eax)
  800cfa:	75 06                	jne    800d02 <memfind+0x1d>
  800cfc:	eb 0b                	jmp    800d09 <memfind+0x24>
  800cfe:	38 08                	cmp    %cl,(%eax)
  800d00:	74 07                	je     800d09 <memfind+0x24>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800d02:	83 c0 01             	add    $0x1,%eax
  800d05:	39 c2                	cmp    %eax,%edx
  800d07:	77 f5                	ja     800cfe <memfind+0x19>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
	return (void *) s;
}
  800d09:	5d                   	pop    %ebp
  800d0a:	c3                   	ret    

00800d0b <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800d0b:	55                   	push   %ebp
  800d0c:	89 e5                	mov    %esp,%ebp
  800d0e:	57                   	push   %edi
  800d0f:	56                   	push   %esi
  800d10:	53                   	push   %ebx
  800d11:	83 ec 04             	sub    $0x4,%esp
  800d14:	8b 55 08             	mov    0x8(%ebp),%edx
  800d17:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800d1a:	0f b6 02             	movzbl (%edx),%eax
  800d1d:	3c 20                	cmp    $0x20,%al
  800d1f:	74 04                	je     800d25 <strtol+0x1a>
  800d21:	3c 09                	cmp    $0x9,%al
  800d23:	75 0e                	jne    800d33 <strtol+0x28>
		s++;
  800d25:	83 c2 01             	add    $0x1,%edx
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800d28:	0f b6 02             	movzbl (%edx),%eax
  800d2b:	3c 20                	cmp    $0x20,%al
  800d2d:	74 f6                	je     800d25 <strtol+0x1a>
  800d2f:	3c 09                	cmp    $0x9,%al
  800d31:	74 f2                	je     800d25 <strtol+0x1a>
		s++;

	// plus/minus sign
	if (*s == '+')
  800d33:	3c 2b                	cmp    $0x2b,%al
  800d35:	75 0c                	jne    800d43 <strtol+0x38>
		s++;
  800d37:	83 c2 01             	add    $0x1,%edx
  800d3a:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800d41:	eb 15                	jmp    800d58 <strtol+0x4d>
	else if (*s == '-')
  800d43:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800d4a:	3c 2d                	cmp    $0x2d,%al
  800d4c:	75 0a                	jne    800d58 <strtol+0x4d>
		s++, neg = 1;
  800d4e:	83 c2 01             	add    $0x1,%edx
  800d51:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800d58:	85 db                	test   %ebx,%ebx
  800d5a:	0f 94 c0             	sete   %al
  800d5d:	74 05                	je     800d64 <strtol+0x59>
  800d5f:	83 fb 10             	cmp    $0x10,%ebx
  800d62:	75 18                	jne    800d7c <strtol+0x71>
  800d64:	80 3a 30             	cmpb   $0x30,(%edx)
  800d67:	75 13                	jne    800d7c <strtol+0x71>
  800d69:	80 7a 01 78          	cmpb   $0x78,0x1(%edx)
  800d6d:	8d 76 00             	lea    0x0(%esi),%esi
  800d70:	75 0a                	jne    800d7c <strtol+0x71>
		s += 2, base = 16;
  800d72:	83 c2 02             	add    $0x2,%edx
  800d75:	bb 10 00 00 00       	mov    $0x10,%ebx
		s++;
	else if (*s == '-')
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800d7a:	eb 15                	jmp    800d91 <strtol+0x86>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  800d7c:	84 c0                	test   %al,%al
  800d7e:	66 90                	xchg   %ax,%ax
  800d80:	74 0f                	je     800d91 <strtol+0x86>
  800d82:	bb 0a 00 00 00       	mov    $0xa,%ebx
  800d87:	80 3a 30             	cmpb   $0x30,(%edx)
  800d8a:	75 05                	jne    800d91 <strtol+0x86>
		s++, base = 8;
  800d8c:	83 c2 01             	add    $0x1,%edx
  800d8f:	b3 08                	mov    $0x8,%bl
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  800d91:	b8 00 00 00 00       	mov    $0x0,%eax
  800d96:	89 de                	mov    %ebx,%esi

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  800d98:	0f b6 0a             	movzbl (%edx),%ecx
  800d9b:	89 cf                	mov    %ecx,%edi
  800d9d:	8d 59 d0             	lea    -0x30(%ecx),%ebx
  800da0:	80 fb 09             	cmp    $0x9,%bl
  800da3:	77 08                	ja     800dad <strtol+0xa2>
			dig = *s - '0';
  800da5:	0f be c9             	movsbl %cl,%ecx
  800da8:	83 e9 30             	sub    $0x30,%ecx
  800dab:	eb 1e                	jmp    800dcb <strtol+0xc0>
		else if (*s >= 'a' && *s <= 'z')
  800dad:	8d 5f 9f             	lea    -0x61(%edi),%ebx
  800db0:	80 fb 19             	cmp    $0x19,%bl
  800db3:	77 08                	ja     800dbd <strtol+0xb2>
			dig = *s - 'a' + 10;
  800db5:	0f be c9             	movsbl %cl,%ecx
  800db8:	83 e9 57             	sub    $0x57,%ecx
  800dbb:	eb 0e                	jmp    800dcb <strtol+0xc0>
		else if (*s >= 'A' && *s <= 'Z')
  800dbd:	8d 5f bf             	lea    -0x41(%edi),%ebx
  800dc0:	80 fb 19             	cmp    $0x19,%bl
  800dc3:	77 15                	ja     800dda <strtol+0xcf>
			dig = *s - 'A' + 10;
  800dc5:	0f be c9             	movsbl %cl,%ecx
  800dc8:	83 e9 37             	sub    $0x37,%ecx
		else
			break;
		if (dig >= base)
  800dcb:	39 f1                	cmp    %esi,%ecx
  800dcd:	7d 0b                	jge    800dda <strtol+0xcf>
			break;
		s++, val = (val * base) + dig;
  800dcf:	83 c2 01             	add    $0x1,%edx
  800dd2:	0f af c6             	imul   %esi,%eax
  800dd5:	8d 04 01             	lea    (%ecx,%eax,1),%eax
		// we don't properly detect overflow!
	}
  800dd8:	eb be                	jmp    800d98 <strtol+0x8d>
  800dda:	89 c1                	mov    %eax,%ecx

	if (endptr)
  800ddc:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800de0:	74 05                	je     800de7 <strtol+0xdc>
		*endptr = (char *) s;
  800de2:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800de5:	89 13                	mov    %edx,(%ebx)
	return (neg ? -val : val);
  800de7:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  800deb:	74 04                	je     800df1 <strtol+0xe6>
  800ded:	89 c8                	mov    %ecx,%eax
  800def:	f7 d8                	neg    %eax
}
  800df1:	83 c4 04             	add    $0x4,%esp
  800df4:	5b                   	pop    %ebx
  800df5:	5e                   	pop    %esi
  800df6:	5f                   	pop    %edi
  800df7:	5d                   	pop    %ebp
  800df8:	c3                   	ret    
  800df9:	00 00                	add    %al,(%eax)
	...

00800dfc <sys_cgetc>:
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}

int
sys_cgetc(void)
{
  800dfc:	55                   	push   %ebp
  800dfd:	89 e5                	mov    %esp,%ebp
  800dff:	83 ec 0c             	sub    $0xc,%esp
  800e02:	89 1c 24             	mov    %ebx,(%esp)
  800e05:	89 74 24 04          	mov    %esi,0x4(%esp)
  800e09:	89 7c 24 08          	mov    %edi,0x8(%esp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800e0d:	ba 00 00 00 00       	mov    $0x0,%edx
  800e12:	b8 01 00 00 00       	mov    $0x1,%eax
  800e17:	89 d1                	mov    %edx,%ecx
  800e19:	89 d3                	mov    %edx,%ebx
  800e1b:	89 d7                	mov    %edx,%edi
  800e1d:	89 d6                	mov    %edx,%esi
  800e1f:	cd 30                	int    $0x30

int
sys_cgetc(void)
{
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800e21:	8b 1c 24             	mov    (%esp),%ebx
  800e24:	8b 74 24 04          	mov    0x4(%esp),%esi
  800e28:	8b 7c 24 08          	mov    0x8(%esp),%edi
  800e2c:	89 ec                	mov    %ebp,%esp
  800e2e:	5d                   	pop    %ebp
  800e2f:	c3                   	ret    

00800e30 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800e30:	55                   	push   %ebp
  800e31:	89 e5                	mov    %esp,%ebp
  800e33:	83 ec 0c             	sub    $0xc,%esp
  800e36:	89 1c 24             	mov    %ebx,(%esp)
  800e39:	89 74 24 04          	mov    %esi,0x4(%esp)
  800e3d:	89 7c 24 08          	mov    %edi,0x8(%esp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800e41:	b8 00 00 00 00       	mov    $0x0,%eax
  800e46:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e49:	8b 55 08             	mov    0x8(%ebp),%edx
  800e4c:	89 c3                	mov    %eax,%ebx
  800e4e:	89 c7                	mov    %eax,%edi
  800e50:	89 c6                	mov    %eax,%esi
  800e52:	cd 30                	int    $0x30

void
sys_cputs(const char *s, size_t len)
{
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800e54:	8b 1c 24             	mov    (%esp),%ebx
  800e57:	8b 74 24 04          	mov    0x4(%esp),%esi
  800e5b:	8b 7c 24 08          	mov    0x8(%esp),%edi
  800e5f:	89 ec                	mov    %ebp,%esp
  800e61:	5d                   	pop    %ebp
  800e62:	c3                   	ret    

00800e63 <sys_page_insert>:
{
	return syscall(SYS_page_waste, 0, (uint32_t)p, (uint32_t)n, 0, 0,0);
}
int
sys_page_insert(envid_t envid, void *va, struct Page *p, int perm)
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
  800e72:	be 00 00 00 00       	mov    $0x0,%esi
  800e77:	b8 12 00 00 00       	mov    $0x12,%eax
  800e7c:	8b 7d 14             	mov    0x14(%ebp),%edi
  800e7f:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800e82:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e85:	8b 55 08             	mov    0x8(%ebp),%edx
  800e88:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
	
	if(check && ret > 0)
  800e8a:	85 c0                	test   %eax,%eax
  800e8c:	7e 28                	jle    800eb6 <sys_page_insert+0x53>
		panic("syscall %d returned %d (> 0)", num, ret);
  800e8e:	89 44 24 10          	mov    %eax,0x10(%esp)
  800e92:	c7 44 24 0c 12 00 00 	movl   $0x12,0xc(%esp)
  800e99:	00 
  800e9a:	c7 44 24 08 bf 2d 80 	movl   $0x802dbf,0x8(%esp)
  800ea1:	00 
  800ea2:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800ea9:	00 
  800eaa:	c7 04 24 dc 2d 80 00 	movl   $0x802ddc,(%esp)
  800eb1:	e8 02 f4 ff ff       	call   8002b8 <_panic>
}
int
sys_page_insert(envid_t envid, void *va, struct Page *p, int perm)
{
	return syscall(SYS_page_insert, 1, envid, (uint32_t) va, (uint32_t)p, perm, 0);
}
  800eb6:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800eb9:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800ebc:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800ebf:	89 ec                	mov    %ebp,%esp
  800ec1:	5d                   	pop    %ebp
  800ec2:	c3                   	ret    

00800ec3 <sys_page_waste>:
{
	return (int)syscall(SYS_receive_packet, 0, (uint32_t)buffer, 0,0,0,0);
}

int sys_page_waste(struct Page **p, int n)
{
  800ec3:	55                   	push   %ebp
  800ec4:	89 e5                	mov    %esp,%ebp
  800ec6:	83 ec 0c             	sub    $0xc,%esp
  800ec9:	89 1c 24             	mov    %ebx,(%esp)
  800ecc:	89 74 24 04          	mov    %esi,0x4(%esp)
  800ed0:	89 7c 24 08          	mov    %edi,0x8(%esp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800ed4:	bb 00 00 00 00       	mov    $0x0,%ebx
  800ed9:	b8 11 00 00 00       	mov    $0x11,%eax
  800ede:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ee1:	8b 55 08             	mov    0x8(%ebp),%edx
  800ee4:	89 df                	mov    %ebx,%edi
  800ee6:	89 de                	mov    %ebx,%esi
  800ee8:	cd 30                	int    $0x30
}

int sys_page_waste(struct Page **p, int n)
{
	return syscall(SYS_page_waste, 0, (uint32_t)p, (uint32_t)n, 0, 0,0);
}
  800eea:	8b 1c 24             	mov    (%esp),%ebx
  800eed:	8b 74 24 04          	mov    0x4(%esp),%esi
  800ef1:	8b 7c 24 08          	mov    0x8(%esp),%edi
  800ef5:	89 ec                	mov    %ebp,%esp
  800ef7:	5d                   	pop    %ebp
  800ef8:	c3                   	ret    

00800ef9 <sys_receive_packet>:
{
	return (int)syscall(SYS_transmit_packet, 1, (uint32_t)data, len, 0,0,0);
}

int sys_receive_packet(void* buffer)
{
  800ef9:	55                   	push   %ebp
  800efa:	89 e5                	mov    %esp,%ebp
  800efc:	83 ec 0c             	sub    $0xc,%esp
  800eff:	89 1c 24             	mov    %ebx,(%esp)
  800f02:	89 74 24 04          	mov    %esi,0x4(%esp)
  800f06:	89 7c 24 08          	mov    %edi,0x8(%esp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800f0a:	b9 00 00 00 00       	mov    $0x0,%ecx
  800f0f:	b8 10 00 00 00       	mov    $0x10,%eax
  800f14:	8b 55 08             	mov    0x8(%ebp),%edx
  800f17:	89 cb                	mov    %ecx,%ebx
  800f19:	89 cf                	mov    %ecx,%edi
  800f1b:	89 ce                	mov    %ecx,%esi
  800f1d:	cd 30                	int    $0x30
}

int sys_receive_packet(void* buffer)
{
	return (int)syscall(SYS_receive_packet, 0, (uint32_t)buffer, 0,0,0,0);
}
  800f1f:	8b 1c 24             	mov    (%esp),%ebx
  800f22:	8b 74 24 04          	mov    0x4(%esp),%esi
  800f26:	8b 7c 24 08          	mov    0x8(%esp),%edi
  800f2a:	89 ec                	mov    %ebp,%esp
  800f2c:	5d                   	pop    %ebp
  800f2d:	c3                   	ret    

00800f2e <sys_transmit_packet>:
{
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0,0);
}

int sys_transmit_packet(void* data, uint32_t len)
{
  800f2e:	55                   	push   %ebp
  800f2f:	89 e5                	mov    %esp,%ebp
  800f31:	83 ec 38             	sub    $0x38,%esp
  800f34:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800f37:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800f3a:	89 7d fc             	mov    %edi,-0x4(%ebp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800f3d:	bb 00 00 00 00       	mov    $0x0,%ebx
  800f42:	b8 0f 00 00 00       	mov    $0xf,%eax
  800f47:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f4a:	8b 55 08             	mov    0x8(%ebp),%edx
  800f4d:	89 df                	mov    %ebx,%edi
  800f4f:	89 de                	mov    %ebx,%esi
  800f51:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
	
	if(check && ret > 0)
  800f53:	85 c0                	test   %eax,%eax
  800f55:	7e 28                	jle    800f7f <sys_transmit_packet+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  800f57:	89 44 24 10          	mov    %eax,0x10(%esp)
  800f5b:	c7 44 24 0c 0f 00 00 	movl   $0xf,0xc(%esp)
  800f62:	00 
  800f63:	c7 44 24 08 bf 2d 80 	movl   $0x802dbf,0x8(%esp)
  800f6a:	00 
  800f6b:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800f72:	00 
  800f73:	c7 04 24 dc 2d 80 00 	movl   $0x802ddc,(%esp)
  800f7a:	e8 39 f3 ff ff       	call   8002b8 <_panic>
}

int sys_transmit_packet(void* data, uint32_t len)
{
	return (int)syscall(SYS_transmit_packet, 1, (uint32_t)data, len, 0,0,0);
}
  800f7f:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800f82:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800f85:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800f88:	89 ec                	mov    %ebp,%esp
  800f8a:	5d                   	pop    %ebp
  800f8b:	c3                   	ret    

00800f8c <sys_time_msec>:
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}

unsigned int
sys_time_msec(void)
{
  800f8c:	55                   	push   %ebp
  800f8d:	89 e5                	mov    %esp,%ebp
  800f8f:	83 ec 0c             	sub    $0xc,%esp
  800f92:	89 1c 24             	mov    %ebx,(%esp)
  800f95:	89 74 24 04          	mov    %esi,0x4(%esp)
  800f99:	89 7c 24 08          	mov    %edi,0x8(%esp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800f9d:	ba 00 00 00 00       	mov    $0x0,%edx
  800fa2:	b8 0e 00 00 00       	mov    $0xe,%eax
  800fa7:	89 d1                	mov    %edx,%ecx
  800fa9:	89 d3                	mov    %edx,%ebx
  800fab:	89 d7                	mov    %edx,%edi
  800fad:	89 d6                	mov    %edx,%esi
  800faf:	cd 30                	int    $0x30

unsigned int
sys_time_msec(void)
{
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0,0);
}
  800fb1:	8b 1c 24             	mov    (%esp),%ebx
  800fb4:	8b 74 24 04          	mov    0x4(%esp),%esi
  800fb8:	8b 7c 24 08          	mov    0x8(%esp),%edi
  800fbc:	89 ec                	mov    %ebp,%esp
  800fbe:	5d                   	pop    %ebp
  800fbf:	c3                   	ret    

00800fc0 <sys_ipc_recv>:
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}

int
sys_ipc_recv(void *dstva)
{
  800fc0:	55                   	push   %ebp
  800fc1:	89 e5                	mov    %esp,%ebp
  800fc3:	83 ec 38             	sub    $0x38,%esp
  800fc6:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800fc9:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800fcc:	89 7d fc             	mov    %edi,-0x4(%ebp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800fcf:	b9 00 00 00 00       	mov    $0x0,%ecx
  800fd4:	b8 0d 00 00 00       	mov    $0xd,%eax
  800fd9:	8b 55 08             	mov    0x8(%ebp),%edx
  800fdc:	89 cb                	mov    %ecx,%ebx
  800fde:	89 cf                	mov    %ecx,%edi
  800fe0:	89 ce                	mov    %ecx,%esi
  800fe2:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
	
	if(check && ret > 0)
  800fe4:	85 c0                	test   %eax,%eax
  800fe6:	7e 28                	jle    801010 <sys_ipc_recv+0x50>
		panic("syscall %d returned %d (> 0)", num, ret);
  800fe8:	89 44 24 10          	mov    %eax,0x10(%esp)
  800fec:	c7 44 24 0c 0d 00 00 	movl   $0xd,0xc(%esp)
  800ff3:	00 
  800ff4:	c7 44 24 08 bf 2d 80 	movl   $0x802dbf,0x8(%esp)
  800ffb:	00 
  800ffc:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  801003:	00 
  801004:	c7 04 24 dc 2d 80 00 	movl   $0x802ddc,(%esp)
  80100b:	e8 a8 f2 ff ff       	call   8002b8 <_panic>

int
sys_ipc_recv(void *dstva)
{
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  801010:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  801013:	8b 75 f8             	mov    -0x8(%ebp),%esi
  801016:	8b 7d fc             	mov    -0x4(%ebp),%edi
  801019:	89 ec                	mov    %ebp,%esp
  80101b:	5d                   	pop    %ebp
  80101c:	c3                   	ret    

0080101d <sys_ipc_try_send>:
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  80101d:	55                   	push   %ebp
  80101e:	89 e5                	mov    %esp,%ebp
  801020:	83 ec 0c             	sub    $0xc,%esp
  801023:	89 1c 24             	mov    %ebx,(%esp)
  801026:	89 74 24 04          	mov    %esi,0x4(%esp)
  80102a:	89 7c 24 08          	mov    %edi,0x8(%esp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80102e:	be 00 00 00 00       	mov    $0x0,%esi
  801033:	b8 0c 00 00 00       	mov    $0xc,%eax
  801038:	8b 7d 14             	mov    0x14(%ebp),%edi
  80103b:	8b 5d 10             	mov    0x10(%ebp),%ebx
  80103e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801041:	8b 55 08             	mov    0x8(%ebp),%edx
  801044:	cd 30                	int    $0x30

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  801046:	8b 1c 24             	mov    (%esp),%ebx
  801049:	8b 74 24 04          	mov    0x4(%esp),%esi
  80104d:	8b 7c 24 08          	mov    0x8(%esp),%edi
  801051:	89 ec                	mov    %ebp,%esp
  801053:	5d                   	pop    %ebp
  801054:	c3                   	ret    

00801055 <sys_env_set_pgfault_upcall>:
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  801055:	55                   	push   %ebp
  801056:	89 e5                	mov    %esp,%ebp
  801058:	83 ec 38             	sub    $0x38,%esp
  80105b:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  80105e:	89 75 f8             	mov    %esi,-0x8(%ebp)
  801061:	89 7d fc             	mov    %edi,-0x4(%ebp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801064:	bb 00 00 00 00       	mov    $0x0,%ebx
  801069:	b8 0a 00 00 00       	mov    $0xa,%eax
  80106e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801071:	8b 55 08             	mov    0x8(%ebp),%edx
  801074:	89 df                	mov    %ebx,%edi
  801076:	89 de                	mov    %ebx,%esi
  801078:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
	
	if(check && ret > 0)
  80107a:	85 c0                	test   %eax,%eax
  80107c:	7e 28                	jle    8010a6 <sys_env_set_pgfault_upcall+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  80107e:	89 44 24 10          	mov    %eax,0x10(%esp)
  801082:	c7 44 24 0c 0a 00 00 	movl   $0xa,0xc(%esp)
  801089:	00 
  80108a:	c7 44 24 08 bf 2d 80 	movl   $0x802dbf,0x8(%esp)
  801091:	00 
  801092:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  801099:	00 
  80109a:	c7 04 24 dc 2d 80 00 	movl   $0x802ddc,(%esp)
  8010a1:	e8 12 f2 ff ff       	call   8002b8 <_panic>

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  8010a6:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  8010a9:	8b 75 f8             	mov    -0x8(%ebp),%esi
  8010ac:	8b 7d fc             	mov    -0x4(%ebp),%edi
  8010af:	89 ec                	mov    %ebp,%esp
  8010b1:	5d                   	pop    %ebp
  8010b2:	c3                   	ret    

008010b3 <sys_env_set_trapframe>:
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  8010b3:	55                   	push   %ebp
  8010b4:	89 e5                	mov    %esp,%ebp
  8010b6:	83 ec 38             	sub    $0x38,%esp
  8010b9:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  8010bc:	89 75 f8             	mov    %esi,-0x8(%ebp)
  8010bf:	89 7d fc             	mov    %edi,-0x4(%ebp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8010c2:	bb 00 00 00 00       	mov    $0x0,%ebx
  8010c7:	b8 09 00 00 00       	mov    $0x9,%eax
  8010cc:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8010cf:	8b 55 08             	mov    0x8(%ebp),%edx
  8010d2:	89 df                	mov    %ebx,%edi
  8010d4:	89 de                	mov    %ebx,%esi
  8010d6:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
	
	if(check && ret > 0)
  8010d8:	85 c0                	test   %eax,%eax
  8010da:	7e 28                	jle    801104 <sys_env_set_trapframe+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  8010dc:	89 44 24 10          	mov    %eax,0x10(%esp)
  8010e0:	c7 44 24 0c 09 00 00 	movl   $0x9,0xc(%esp)
  8010e7:	00 
  8010e8:	c7 44 24 08 bf 2d 80 	movl   $0x802dbf,0x8(%esp)
  8010ef:	00 
  8010f0:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  8010f7:	00 
  8010f8:	c7 04 24 dc 2d 80 00 	movl   $0x802ddc,(%esp)
  8010ff:	e8 b4 f1 ff ff       	call   8002b8 <_panic>

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  801104:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  801107:	8b 75 f8             	mov    -0x8(%ebp),%esi
  80110a:	8b 7d fc             	mov    -0x4(%ebp),%edi
  80110d:	89 ec                	mov    %ebp,%esp
  80110f:	5d                   	pop    %ebp
  801110:	c3                   	ret    

00801111 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  801111:	55                   	push   %ebp
  801112:	89 e5                	mov    %esp,%ebp
  801114:	83 ec 38             	sub    $0x38,%esp
  801117:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  80111a:	89 75 f8             	mov    %esi,-0x8(%ebp)
  80111d:	89 7d fc             	mov    %edi,-0x4(%ebp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801120:	bb 00 00 00 00       	mov    $0x0,%ebx
  801125:	b8 08 00 00 00       	mov    $0x8,%eax
  80112a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80112d:	8b 55 08             	mov    0x8(%ebp),%edx
  801130:	89 df                	mov    %ebx,%edi
  801132:	89 de                	mov    %ebx,%esi
  801134:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
	
	if(check && ret > 0)
  801136:	85 c0                	test   %eax,%eax
  801138:	7e 28                	jle    801162 <sys_env_set_status+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  80113a:	89 44 24 10          	mov    %eax,0x10(%esp)
  80113e:	c7 44 24 0c 08 00 00 	movl   $0x8,0xc(%esp)
  801145:	00 
  801146:	c7 44 24 08 bf 2d 80 	movl   $0x802dbf,0x8(%esp)
  80114d:	00 
  80114e:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  801155:	00 
  801156:	c7 04 24 dc 2d 80 00 	movl   $0x802ddc,(%esp)
  80115d:	e8 56 f1 ff ff       	call   8002b8 <_panic>

int
sys_env_set_status(envid_t envid, int status)
{
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  801162:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  801165:	8b 75 f8             	mov    -0x8(%ebp),%esi
  801168:	8b 7d fc             	mov    -0x4(%ebp),%edi
  80116b:	89 ec                	mov    %ebp,%esp
  80116d:	5d                   	pop    %ebp
  80116e:	c3                   	ret    

0080116f <sys_page_unmap>:
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}

int
sys_page_unmap(envid_t envid, void *va)
{
  80116f:	55                   	push   %ebp
  801170:	89 e5                	mov    %esp,%ebp
  801172:	83 ec 38             	sub    $0x38,%esp
  801175:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  801178:	89 75 f8             	mov    %esi,-0x8(%ebp)
  80117b:	89 7d fc             	mov    %edi,-0x4(%ebp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80117e:	bb 00 00 00 00       	mov    $0x0,%ebx
  801183:	b8 06 00 00 00       	mov    $0x6,%eax
  801188:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80118b:	8b 55 08             	mov    0x8(%ebp),%edx
  80118e:	89 df                	mov    %ebx,%edi
  801190:	89 de                	mov    %ebx,%esi
  801192:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
	
	if(check && ret > 0)
  801194:	85 c0                	test   %eax,%eax
  801196:	7e 28                	jle    8011c0 <sys_page_unmap+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  801198:	89 44 24 10          	mov    %eax,0x10(%esp)
  80119c:	c7 44 24 0c 06 00 00 	movl   $0x6,0xc(%esp)
  8011a3:	00 
  8011a4:	c7 44 24 08 bf 2d 80 	movl   $0x802dbf,0x8(%esp)
  8011ab:	00 
  8011ac:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  8011b3:	00 
  8011b4:	c7 04 24 dc 2d 80 00 	movl   $0x802ddc,(%esp)
  8011bb:	e8 f8 f0 ff ff       	call   8002b8 <_panic>

int
sys_page_unmap(envid_t envid, void *va)
{
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  8011c0:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  8011c3:	8b 75 f8             	mov    -0x8(%ebp),%esi
  8011c6:	8b 7d fc             	mov    -0x4(%ebp),%edi
  8011c9:	89 ec                	mov    %ebp,%esp
  8011cb:	5d                   	pop    %ebp
  8011cc:	c3                   	ret    

008011cd <sys_page_map>:
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  8011cd:	55                   	push   %ebp
  8011ce:	89 e5                	mov    %esp,%ebp
  8011d0:	83 ec 38             	sub    $0x38,%esp
  8011d3:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  8011d6:	89 75 f8             	mov    %esi,-0x8(%ebp)
  8011d9:	89 7d fc             	mov    %edi,-0x4(%ebp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8011dc:	b8 05 00 00 00       	mov    $0x5,%eax
  8011e1:	8b 75 18             	mov    0x18(%ebp),%esi
  8011e4:	8b 7d 14             	mov    0x14(%ebp),%edi
  8011e7:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8011ea:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8011ed:	8b 55 08             	mov    0x8(%ebp),%edx
  8011f0:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
	
	if(check && ret > 0)
  8011f2:	85 c0                	test   %eax,%eax
  8011f4:	7e 28                	jle    80121e <sys_page_map+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  8011f6:	89 44 24 10          	mov    %eax,0x10(%esp)
  8011fa:	c7 44 24 0c 05 00 00 	movl   $0x5,0xc(%esp)
  801201:	00 
  801202:	c7 44 24 08 bf 2d 80 	movl   $0x802dbf,0x8(%esp)
  801209:	00 
  80120a:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  801211:	00 
  801212:	c7 04 24 dc 2d 80 00 	movl   $0x802ddc,(%esp)
  801219:	e8 9a f0 ff ff       	call   8002b8 <_panic>

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  80121e:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  801221:	8b 75 f8             	mov    -0x8(%ebp),%esi
  801224:	8b 7d fc             	mov    -0x4(%ebp),%edi
  801227:	89 ec                	mov    %ebp,%esp
  801229:	5d                   	pop    %ebp
  80122a:	c3                   	ret    

0080122b <sys_page_alloc>:
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  80122b:	55                   	push   %ebp
  80122c:	89 e5                	mov    %esp,%ebp
  80122e:	83 ec 38             	sub    $0x38,%esp
  801231:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  801234:	89 75 f8             	mov    %esi,-0x8(%ebp)
  801237:	89 7d fc             	mov    %edi,-0x4(%ebp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80123a:	be 00 00 00 00       	mov    $0x0,%esi
  80123f:	b8 04 00 00 00       	mov    $0x4,%eax
  801244:	8b 5d 10             	mov    0x10(%ebp),%ebx
  801247:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80124a:	8b 55 08             	mov    0x8(%ebp),%edx
  80124d:	89 f7                	mov    %esi,%edi
  80124f:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
	
	if(check && ret > 0)
  801251:	85 c0                	test   %eax,%eax
  801253:	7e 28                	jle    80127d <sys_page_alloc+0x52>
		panic("syscall %d returned %d (> 0)", num, ret);
  801255:	89 44 24 10          	mov    %eax,0x10(%esp)
  801259:	c7 44 24 0c 04 00 00 	movl   $0x4,0xc(%esp)
  801260:	00 
  801261:	c7 44 24 08 bf 2d 80 	movl   $0x802dbf,0x8(%esp)
  801268:	00 
  801269:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  801270:	00 
  801271:	c7 04 24 dc 2d 80 00 	movl   $0x802ddc,(%esp)
  801278:	e8 3b f0 ff ff       	call   8002b8 <_panic>

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  80127d:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  801280:	8b 75 f8             	mov    -0x8(%ebp),%esi
  801283:	8b 7d fc             	mov    -0x4(%ebp),%edi
  801286:	89 ec                	mov    %ebp,%esp
  801288:	5d                   	pop    %ebp
  801289:	c3                   	ret    

0080128a <sys_yield>:
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}

void
sys_yield(void)
{
  80128a:	55                   	push   %ebp
  80128b:	89 e5                	mov    %esp,%ebp
  80128d:	83 ec 0c             	sub    $0xc,%esp
  801290:	89 1c 24             	mov    %ebx,(%esp)
  801293:	89 74 24 04          	mov    %esi,0x4(%esp)
  801297:	89 7c 24 08          	mov    %edi,0x8(%esp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80129b:	ba 00 00 00 00       	mov    $0x0,%edx
  8012a0:	b8 0b 00 00 00       	mov    $0xb,%eax
  8012a5:	89 d1                	mov    %edx,%ecx
  8012a7:	89 d3                	mov    %edx,%ebx
  8012a9:	89 d7                	mov    %edx,%edi
  8012ab:	89 d6                	mov    %edx,%esi
  8012ad:	cd 30                	int    $0x30

void
sys_yield(void)
{
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  8012af:	8b 1c 24             	mov    (%esp),%ebx
  8012b2:	8b 74 24 04          	mov    0x4(%esp),%esi
  8012b6:	8b 7c 24 08          	mov    0x8(%esp),%edi
  8012ba:	89 ec                	mov    %ebp,%esp
  8012bc:	5d                   	pop    %ebp
  8012bd:	c3                   	ret    

008012be <sys_getenvid>:
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}

envid_t
sys_getenvid(void)
{
  8012be:	55                   	push   %ebp
  8012bf:	89 e5                	mov    %esp,%ebp
  8012c1:	83 ec 0c             	sub    $0xc,%esp
  8012c4:	89 1c 24             	mov    %ebx,(%esp)
  8012c7:	89 74 24 04          	mov    %esi,0x4(%esp)
  8012cb:	89 7c 24 08          	mov    %edi,0x8(%esp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8012cf:	ba 00 00 00 00       	mov    $0x0,%edx
  8012d4:	b8 02 00 00 00       	mov    $0x2,%eax
  8012d9:	89 d1                	mov    %edx,%ecx
  8012db:	89 d3                	mov    %edx,%ebx
  8012dd:	89 d7                	mov    %edx,%edi
  8012df:	89 d6                	mov    %edx,%esi
  8012e1:	cd 30                	int    $0x30

envid_t
sys_getenvid(void)
{
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  8012e3:	8b 1c 24             	mov    (%esp),%ebx
  8012e6:	8b 74 24 04          	mov    0x4(%esp),%esi
  8012ea:	8b 7c 24 08          	mov    0x8(%esp),%edi
  8012ee:	89 ec                	mov    %ebp,%esp
  8012f0:	5d                   	pop    %ebp
  8012f1:	c3                   	ret    

008012f2 <sys_env_destroy>:
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}

int
sys_env_destroy(envid_t envid)
{
  8012f2:	55                   	push   %ebp
  8012f3:	89 e5                	mov    %esp,%ebp
  8012f5:	83 ec 38             	sub    $0x38,%esp
  8012f8:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  8012fb:	89 75 f8             	mov    %esi,-0x8(%ebp)
  8012fe:	89 7d fc             	mov    %edi,-0x4(%ebp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801301:	b9 00 00 00 00       	mov    $0x0,%ecx
  801306:	b8 03 00 00 00       	mov    $0x3,%eax
  80130b:	8b 55 08             	mov    0x8(%ebp),%edx
  80130e:	89 cb                	mov    %ecx,%ebx
  801310:	89 cf                	mov    %ecx,%edi
  801312:	89 ce                	mov    %ecx,%esi
  801314:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
	
	if(check && ret > 0)
  801316:	85 c0                	test   %eax,%eax
  801318:	7e 28                	jle    801342 <sys_env_destroy+0x50>
		panic("syscall %d returned %d (> 0)", num, ret);
  80131a:	89 44 24 10          	mov    %eax,0x10(%esp)
  80131e:	c7 44 24 0c 03 00 00 	movl   $0x3,0xc(%esp)
  801325:	00 
  801326:	c7 44 24 08 bf 2d 80 	movl   $0x802dbf,0x8(%esp)
  80132d:	00 
  80132e:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  801335:	00 
  801336:	c7 04 24 dc 2d 80 00 	movl   $0x802ddc,(%esp)
  80133d:	e8 76 ef ff ff       	call   8002b8 <_panic>

int
sys_env_destroy(envid_t envid)
{
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  801342:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  801345:	8b 75 f8             	mov    -0x8(%ebp),%esi
  801348:	8b 7d fc             	mov    -0x4(%ebp),%edi
  80134b:	89 ec                	mov    %ebp,%esp
  80134d:	5d                   	pop    %ebp
  80134e:	c3                   	ret    
	...

00801350 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  801350:	55                   	push   %ebp
  801351:	89 e5                	mov    %esp,%ebp
  801353:	8b 45 08             	mov    0x8(%ebp),%eax
  801356:	05 00 00 00 30       	add    $0x30000000,%eax
  80135b:	c1 e8 0c             	shr    $0xc,%eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
}
  80135e:	5d                   	pop    %ebp
  80135f:	c3                   	ret    

00801360 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  801360:	55                   	push   %ebp
  801361:	89 e5                	mov    %esp,%ebp
  801363:	83 ec 04             	sub    $0x4,%esp
	return INDEX2DATA(fd2num(fd));
  801366:	8b 45 08             	mov    0x8(%ebp),%eax
  801369:	89 04 24             	mov    %eax,(%esp)
  80136c:	e8 df ff ff ff       	call   801350 <fd2num>
  801371:	05 20 00 0d 00       	add    $0xd0020,%eax
  801376:	c1 e0 0c             	shl    $0xc,%eax
}
  801379:	c9                   	leave  
  80137a:	c3                   	ret    

0080137b <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  80137b:	55                   	push   %ebp
  80137c:	89 e5                	mov    %esp,%ebp
  80137e:	57                   	push   %edi
  80137f:	56                   	push   %esi
  801380:	53                   	push   %ebx
  801381:	8b 7d 08             	mov    0x8(%ebp),%edi
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((vpd[PDX(fd)] & PTE_P) == 0 || (vpt[VPN(fd)] & PTE_P) == 0) {
  801384:	a1 00 dd 7b ef       	mov    0xef7bdd00,%eax
  801389:	a8 01                	test   $0x1,%al
  80138b:	74 36                	je     8013c3 <fd_alloc+0x48>
  80138d:	a1 00 00 74 ef       	mov    0xef740000,%eax
  801392:	a8 01                	test   $0x1,%al
  801394:	74 2d                	je     8013c3 <fd_alloc+0x48>
  801396:	b8 00 10 00 d0       	mov    $0xd0001000,%eax
  80139b:	b9 00 d0 7b ef       	mov    $0xef7bd000,%ecx
  8013a0:	be 00 00 40 ef       	mov    $0xef400000,%esi
  8013a5:	89 c3                	mov    %eax,%ebx
  8013a7:	89 c2                	mov    %eax,%edx
  8013a9:	c1 ea 16             	shr    $0x16,%edx
  8013ac:	8b 14 91             	mov    (%ecx,%edx,4),%edx
  8013af:	f6 c2 01             	test   $0x1,%dl
  8013b2:	74 14                	je     8013c8 <fd_alloc+0x4d>
  8013b4:	89 c2                	mov    %eax,%edx
  8013b6:	c1 ea 0c             	shr    $0xc,%edx
  8013b9:	8b 14 96             	mov    (%esi,%edx,4),%edx
  8013bc:	f6 c2 01             	test   $0x1,%dl
  8013bf:	75 10                	jne    8013d1 <fd_alloc+0x56>
  8013c1:	eb 05                	jmp    8013c8 <fd_alloc+0x4d>
  8013c3:	bb 00 00 00 d0       	mov    $0xd0000000,%ebx
			*fd_store = fd;
  8013c8:	89 1f                	mov    %ebx,(%edi)
  8013ca:	b8 00 00 00 00       	mov    $0x0,%eax
			return 0;
  8013cf:	eb 17                	jmp    8013e8 <fd_alloc+0x6d>
  8013d1:	05 00 10 00 00       	add    $0x1000,%eax
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  8013d6:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  8013db:	75 c8                	jne    8013a5 <fd_alloc+0x2a>
		if ((vpd[PDX(fd)] & PTE_P) == 0 || (vpt[VPN(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  8013dd:	c7 07 00 00 00 00    	movl   $0x0,(%edi)
  8013e3:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
	return -E_MAX_OPEN;
}
  8013e8:	5b                   	pop    %ebx
  8013e9:	5e                   	pop    %esi
  8013ea:	5f                   	pop    %edi
  8013eb:	5d                   	pop    %ebp
  8013ec:	c3                   	ret    

008013ed <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  8013ed:	55                   	push   %ebp
  8013ee:	89 e5                	mov    %esp,%ebp
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  8013f0:	8b 45 08             	mov    0x8(%ebp),%eax
  8013f3:	83 f8 1f             	cmp    $0x1f,%eax
  8013f6:	77 36                	ja     80142e <fd_lookup+0x41>
		if (debug)
			cprintf("[%08x] bad fd %d\n", env->env_id, fd);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  8013f8:	05 00 00 0d 00       	add    $0xd0000,%eax
  8013fd:	c1 e0 0c             	shl    $0xc,%eax
	if (!(vpd[PDX(fd)] & PTE_P) || !(vpt[VPN(fd)] & PTE_P)) {
  801400:	89 c2                	mov    %eax,%edx
  801402:	c1 ea 16             	shr    $0x16,%edx
  801405:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  80140c:	f6 c2 01             	test   $0x1,%dl
  80140f:	74 1d                	je     80142e <fd_lookup+0x41>
  801411:	89 c2                	mov    %eax,%edx
  801413:	c1 ea 0c             	shr    $0xc,%edx
  801416:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  80141d:	f6 c2 01             	test   $0x1,%dl
  801420:	74 0c                	je     80142e <fd_lookup+0x41>
		if (debug)
			cprintf("[%08x] closed fd %d\n", env->env_id, fd);
		return -E_INVAL;
	}
	*fd_store = fd;
  801422:	8b 55 0c             	mov    0xc(%ebp),%edx
  801425:	89 02                	mov    %eax,(%edx)
  801427:	b8 00 00 00 00       	mov    $0x0,%eax
	return 0;
  80142c:	eb 05                	jmp    801433 <fd_lookup+0x46>
  80142e:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  801433:	5d                   	pop    %ebp
  801434:	c3                   	ret    

00801435 <seek>:
	return (*dev->dev_write)(fd, buf, n);
}

int
seek(int fdnum, off_t offset)
{
  801435:	55                   	push   %ebp
  801436:	89 e5                	mov    %esp,%ebp
  801438:	83 ec 18             	sub    $0x18,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80143b:	8d 45 fc             	lea    -0x4(%ebp),%eax
  80143e:	89 44 24 04          	mov    %eax,0x4(%esp)
  801442:	8b 45 08             	mov    0x8(%ebp),%eax
  801445:	89 04 24             	mov    %eax,(%esp)
  801448:	e8 a0 ff ff ff       	call   8013ed <fd_lookup>
  80144d:	85 c0                	test   %eax,%eax
  80144f:	78 0e                	js     80145f <seek+0x2a>
		return r;
	fd->fd_offset = offset;
  801451:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801454:	8b 55 0c             	mov    0xc(%ebp),%edx
  801457:	89 50 04             	mov    %edx,0x4(%eax)
  80145a:	b8 00 00 00 00       	mov    $0x0,%eax
	return 0;
}
  80145f:	c9                   	leave  
  801460:	c3                   	ret    

00801461 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  801461:	55                   	push   %ebp
  801462:	89 e5                	mov    %esp,%ebp
  801464:	56                   	push   %esi
  801465:	53                   	push   %ebx
  801466:	83 ec 10             	sub    $0x10,%esp
  801469:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80146c:	8b 5d 0c             	mov    0xc(%ebp),%ebx
// File functions
// --------------------------------------------------------------

static struct Dev *devtab[] =
{
	&devfile,
  80146f:	b8 04 60 80 00       	mov    $0x806004,%eax
{
	int i;
	for (i = 0; devtab[i]; i++)
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
  801474:	ba 00 00 00 00       	mov    $0x0,%edx

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  801479:	be 68 2e 80 00       	mov    $0x802e68,%esi
		if (devtab[i]->dev_id == dev_id) {
  80147e:	39 08                	cmp    %ecx,(%eax)
  801480:	75 10                	jne    801492 <dev_lookup+0x31>
  801482:	eb 04                	jmp    801488 <dev_lookup+0x27>
  801484:	39 08                	cmp    %ecx,(%eax)
  801486:	75 0a                	jne    801492 <dev_lookup+0x31>
			*dev = devtab[i];
  801488:	89 03                	mov    %eax,(%ebx)
  80148a:	b8 00 00 00 00       	mov    $0x0,%eax
			return 0;
  80148f:	90                   	nop
  801490:	eb 31                	jmp    8014c3 <dev_lookup+0x62>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  801492:	83 c2 01             	add    $0x1,%edx
  801495:	8b 04 96             	mov    (%esi,%edx,4),%eax
  801498:	85 c0                	test   %eax,%eax
  80149a:	75 e8                	jne    801484 <dev_lookup+0x23>
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", env->env_id, dev_id);
  80149c:	a1 74 60 80 00       	mov    0x806074,%eax
  8014a1:	8b 40 4c             	mov    0x4c(%eax),%eax
  8014a4:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8014a8:	89 44 24 04          	mov    %eax,0x4(%esp)
  8014ac:	c7 04 24 ec 2d 80 00 	movl   $0x802dec,(%esp)
  8014b3:	e8 c5 ee ff ff       	call   80037d <cprintf>
	*dev = 0;
  8014b8:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  8014be:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
	return -E_INVAL;
}
  8014c3:	83 c4 10             	add    $0x10,%esp
  8014c6:	5b                   	pop    %ebx
  8014c7:	5e                   	pop    %esi
  8014c8:	5d                   	pop    %ebp
  8014c9:	c3                   	ret    

008014ca <fstat>:
	return (*dev->dev_trunc)(fd, newsize);
}

int
fstat(int fdnum, struct Stat *stat)
{
  8014ca:	55                   	push   %ebp
  8014cb:	89 e5                	mov    %esp,%ebp
  8014cd:	53                   	push   %ebx
  8014ce:	83 ec 24             	sub    $0x24,%esp
  8014d1:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8014d4:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8014d7:	89 44 24 04          	mov    %eax,0x4(%esp)
  8014db:	8b 45 08             	mov    0x8(%ebp),%eax
  8014de:	89 04 24             	mov    %eax,(%esp)
  8014e1:	e8 07 ff ff ff       	call   8013ed <fd_lookup>
  8014e6:	85 c0                	test   %eax,%eax
  8014e8:	78 53                	js     80153d <fstat+0x73>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8014ea:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8014ed:	89 44 24 04          	mov    %eax,0x4(%esp)
  8014f1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8014f4:	8b 00                	mov    (%eax),%eax
  8014f6:	89 04 24             	mov    %eax,(%esp)
  8014f9:	e8 63 ff ff ff       	call   801461 <dev_lookup>
{
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8014fe:	85 c0                	test   %eax,%eax
  801500:	78 3b                	js     80153d <fstat+0x73>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if (!dev->dev_stat)
  801502:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801507:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80150a:	83 7a 14 00          	cmpl   $0x0,0x14(%edx)
  80150e:	74 2d                	je     80153d <fstat+0x73>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  801510:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  801513:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  80151a:	00 00 00 
	stat->st_isdir = 0;
  80151d:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801524:	00 00 00 
	stat->st_dev = dev;
  801527:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80152a:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  801530:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801534:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801537:	89 14 24             	mov    %edx,(%esp)
  80153a:	ff 50 14             	call   *0x14(%eax)
}
  80153d:	83 c4 24             	add    $0x24,%esp
  801540:	5b                   	pop    %ebx
  801541:	5d                   	pop    %ebp
  801542:	c3                   	ret    

00801543 <ftruncate>:
	return 0;
}

int
ftruncate(int fdnum, off_t newsize)
{
  801543:	55                   	push   %ebp
  801544:	89 e5                	mov    %esp,%ebp
  801546:	53                   	push   %ebx
  801547:	83 ec 24             	sub    $0x24,%esp
  80154a:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  80154d:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801550:	89 44 24 04          	mov    %eax,0x4(%esp)
  801554:	89 1c 24             	mov    %ebx,(%esp)
  801557:	e8 91 fe ff ff       	call   8013ed <fd_lookup>
  80155c:	85 c0                	test   %eax,%eax
  80155e:	78 5f                	js     8015bf <ftruncate+0x7c>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801560:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801563:	89 44 24 04          	mov    %eax,0x4(%esp)
  801567:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80156a:	8b 00                	mov    (%eax),%eax
  80156c:	89 04 24             	mov    %eax,(%esp)
  80156f:	e8 ed fe ff ff       	call   801461 <dev_lookup>
ftruncate(int fdnum, off_t newsize)
{
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  801574:	85 c0                	test   %eax,%eax
  801576:	78 47                	js     8015bf <ftruncate+0x7c>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801578:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80157b:	f6 42 08 03          	testb  $0x3,0x8(%edx)
  80157f:	75 23                	jne    8015a4 <ftruncate+0x61>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			env->env_id, fdnum); 
  801581:	a1 74 60 80 00       	mov    0x806074,%eax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  801586:	8b 40 4c             	mov    0x4c(%eax),%eax
  801589:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80158d:	89 44 24 04          	mov    %eax,0x4(%esp)
  801591:	c7 04 24 0c 2e 80 00 	movl   $0x802e0c,(%esp)
  801598:	e8 e0 ed ff ff       	call   80037d <cprintf>
  80159d:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
			env->env_id, fdnum); 
		return -E_INVAL;
  8015a2:	eb 1b                	jmp    8015bf <ftruncate+0x7c>
	}
	if (!dev->dev_trunc)
  8015a4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8015a7:	8b 48 18             	mov    0x18(%eax),%ecx
  8015aa:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8015af:	85 c9                	test   %ecx,%ecx
  8015b1:	74 0c                	je     8015bf <ftruncate+0x7c>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  8015b3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015b6:	89 44 24 04          	mov    %eax,0x4(%esp)
  8015ba:	89 14 24             	mov    %edx,(%esp)
  8015bd:	ff d1                	call   *%ecx
}
  8015bf:	83 c4 24             	add    $0x24,%esp
  8015c2:	5b                   	pop    %ebx
  8015c3:	5d                   	pop    %ebp
  8015c4:	c3                   	ret    

008015c5 <write>:
	return tot;
}

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  8015c5:	55                   	push   %ebp
  8015c6:	89 e5                	mov    %esp,%ebp
  8015c8:	53                   	push   %ebx
  8015c9:	83 ec 24             	sub    $0x24,%esp
  8015cc:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8015cf:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8015d2:	89 44 24 04          	mov    %eax,0x4(%esp)
  8015d6:	89 1c 24             	mov    %ebx,(%esp)
  8015d9:	e8 0f fe ff ff       	call   8013ed <fd_lookup>
  8015de:	85 c0                	test   %eax,%eax
  8015e0:	78 66                	js     801648 <write+0x83>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8015e2:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8015e5:	89 44 24 04          	mov    %eax,0x4(%esp)
  8015e9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8015ec:	8b 00                	mov    (%eax),%eax
  8015ee:	89 04 24             	mov    %eax,(%esp)
  8015f1:	e8 6b fe ff ff       	call   801461 <dev_lookup>
{
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8015f6:	85 c0                	test   %eax,%eax
  8015f8:	78 4e                	js     801648 <write+0x83>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8015fa:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8015fd:	f6 42 08 03          	testb  $0x3,0x8(%edx)
  801601:	75 23                	jne    801626 <write+0x61>
		cprintf("[%08x] write %d -- bad mode\n", env->env_id, fdnum);
  801603:	a1 74 60 80 00       	mov    0x806074,%eax
  801608:	8b 40 4c             	mov    0x4c(%eax),%eax
  80160b:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80160f:	89 44 24 04          	mov    %eax,0x4(%esp)
  801613:	c7 04 24 2d 2e 80 00 	movl   $0x802e2d,(%esp)
  80161a:	e8 5e ed ff ff       	call   80037d <cprintf>
  80161f:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
		return -E_INVAL;
  801624:	eb 22                	jmp    801648 <write+0x83>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  801626:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801629:	8b 48 0c             	mov    0xc(%eax),%ecx
  80162c:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801631:	85 c9                	test   %ecx,%ecx
  801633:	74 13                	je     801648 <write+0x83>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  801635:	8b 45 10             	mov    0x10(%ebp),%eax
  801638:	89 44 24 08          	mov    %eax,0x8(%esp)
  80163c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80163f:	89 44 24 04          	mov    %eax,0x4(%esp)
  801643:	89 14 24             	mov    %edx,(%esp)
  801646:	ff d1                	call   *%ecx
}
  801648:	83 c4 24             	add    $0x24,%esp
  80164b:	5b                   	pop    %ebx
  80164c:	5d                   	pop    %ebp
  80164d:	c3                   	ret    

0080164e <read>:
	return r;
}

ssize_t
read(int fdnum, void *buf, size_t n)
{
  80164e:	55                   	push   %ebp
  80164f:	89 e5                	mov    %esp,%ebp
  801651:	53                   	push   %ebx
  801652:	83 ec 24             	sub    $0x24,%esp
  801655:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801658:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80165b:	89 44 24 04          	mov    %eax,0x4(%esp)
  80165f:	89 1c 24             	mov    %ebx,(%esp)
  801662:	e8 86 fd ff ff       	call   8013ed <fd_lookup>
  801667:	85 c0                	test   %eax,%eax
  801669:	78 6b                	js     8016d6 <read+0x88>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80166b:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80166e:	89 44 24 04          	mov    %eax,0x4(%esp)
  801672:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801675:	8b 00                	mov    (%eax),%eax
  801677:	89 04 24             	mov    %eax,(%esp)
  80167a:	e8 e2 fd ff ff       	call   801461 <dev_lookup>
{
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80167f:	85 c0                	test   %eax,%eax
  801681:	78 53                	js     8016d6 <read+0x88>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  801683:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801686:	8b 42 08             	mov    0x8(%edx),%eax
  801689:	83 e0 03             	and    $0x3,%eax
  80168c:	83 f8 01             	cmp    $0x1,%eax
  80168f:	75 23                	jne    8016b4 <read+0x66>
		cprintf("[%08x] read %d -- bad mode\n", env->env_id, fdnum); 
  801691:	a1 74 60 80 00       	mov    0x806074,%eax
  801696:	8b 40 4c             	mov    0x4c(%eax),%eax
  801699:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80169d:	89 44 24 04          	mov    %eax,0x4(%esp)
  8016a1:	c7 04 24 4a 2e 80 00 	movl   $0x802e4a,(%esp)
  8016a8:	e8 d0 ec ff ff       	call   80037d <cprintf>
  8016ad:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
		return -E_INVAL;
  8016b2:	eb 22                	jmp    8016d6 <read+0x88>
	}
	if (!dev->dev_read)
  8016b4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8016b7:	8b 48 08             	mov    0x8(%eax),%ecx
  8016ba:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8016bf:	85 c9                	test   %ecx,%ecx
  8016c1:	74 13                	je     8016d6 <read+0x88>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  8016c3:	8b 45 10             	mov    0x10(%ebp),%eax
  8016c6:	89 44 24 08          	mov    %eax,0x8(%esp)
  8016ca:	8b 45 0c             	mov    0xc(%ebp),%eax
  8016cd:	89 44 24 04          	mov    %eax,0x4(%esp)
  8016d1:	89 14 24             	mov    %edx,(%esp)
  8016d4:	ff d1                	call   *%ecx
}
  8016d6:	83 c4 24             	add    $0x24,%esp
  8016d9:	5b                   	pop    %ebx
  8016da:	5d                   	pop    %ebp
  8016db:	c3                   	ret    

008016dc <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  8016dc:	55                   	push   %ebp
  8016dd:	89 e5                	mov    %esp,%ebp
  8016df:	57                   	push   %edi
  8016e0:	56                   	push   %esi
  8016e1:	53                   	push   %ebx
  8016e2:	83 ec 1c             	sub    $0x1c,%esp
  8016e5:	8b 7d 08             	mov    0x8(%ebp),%edi
  8016e8:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  8016eb:	ba 00 00 00 00       	mov    $0x0,%edx
  8016f0:	bb 00 00 00 00       	mov    $0x0,%ebx
  8016f5:	b8 00 00 00 00       	mov    $0x0,%eax
  8016fa:	85 f6                	test   %esi,%esi
  8016fc:	74 29                	je     801727 <readn+0x4b>
		m = read(fdnum, (char*)buf + tot, n - tot);
  8016fe:	89 f0                	mov    %esi,%eax
  801700:	29 d0                	sub    %edx,%eax
  801702:	89 44 24 08          	mov    %eax,0x8(%esp)
  801706:	03 55 0c             	add    0xc(%ebp),%edx
  801709:	89 54 24 04          	mov    %edx,0x4(%esp)
  80170d:	89 3c 24             	mov    %edi,(%esp)
  801710:	e8 39 ff ff ff       	call   80164e <read>
		if (m < 0)
  801715:	85 c0                	test   %eax,%eax
  801717:	78 0e                	js     801727 <readn+0x4b>
			return m;
		if (m == 0)
  801719:	85 c0                	test   %eax,%eax
  80171b:	74 08                	je     801725 <readn+0x49>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  80171d:	01 c3                	add    %eax,%ebx
  80171f:	89 da                	mov    %ebx,%edx
  801721:	39 f3                	cmp    %esi,%ebx
  801723:	72 d9                	jb     8016fe <readn+0x22>
  801725:	89 d8                	mov    %ebx,%eax
			return m;
		if (m == 0)
			break;
	}
	return tot;
}
  801727:	83 c4 1c             	add    $0x1c,%esp
  80172a:	5b                   	pop    %ebx
  80172b:	5e                   	pop    %esi
  80172c:	5f                   	pop    %edi
  80172d:	5d                   	pop    %ebp
  80172e:	c3                   	ret    

0080172f <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  80172f:	55                   	push   %ebp
  801730:	89 e5                	mov    %esp,%ebp
  801732:	56                   	push   %esi
  801733:	53                   	push   %ebx
  801734:	83 ec 20             	sub    $0x20,%esp
  801737:	8b 75 08             	mov    0x8(%ebp),%esi
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  80173a:	89 34 24             	mov    %esi,(%esp)
  80173d:	e8 0e fc ff ff       	call   801350 <fd2num>
  801742:	8d 55 f4             	lea    -0xc(%ebp),%edx
  801745:	89 54 24 04          	mov    %edx,0x4(%esp)
  801749:	89 04 24             	mov    %eax,(%esp)
  80174c:	e8 9c fc ff ff       	call   8013ed <fd_lookup>
  801751:	89 c3                	mov    %eax,%ebx
  801753:	85 c0                	test   %eax,%eax
  801755:	78 05                	js     80175c <fd_close+0x2d>
  801757:	3b 75 f4             	cmp    -0xc(%ebp),%esi
  80175a:	74 0c                	je     801768 <fd_close+0x39>
	    || fd != fd2)
		return (must_exist ? r : 0);
  80175c:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  801760:	19 c0                	sbb    %eax,%eax
  801762:	f7 d0                	not    %eax
  801764:	21 c3                	and    %eax,%ebx
  801766:	eb 3d                	jmp    8017a5 <fd_close+0x76>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  801768:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80176b:	89 44 24 04          	mov    %eax,0x4(%esp)
  80176f:	8b 06                	mov    (%esi),%eax
  801771:	89 04 24             	mov    %eax,(%esp)
  801774:	e8 e8 fc ff ff       	call   801461 <dev_lookup>
  801779:	89 c3                	mov    %eax,%ebx
  80177b:	85 c0                	test   %eax,%eax
  80177d:	78 16                	js     801795 <fd_close+0x66>
		if (dev->dev_close)
  80177f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801782:	8b 40 10             	mov    0x10(%eax),%eax
  801785:	bb 00 00 00 00       	mov    $0x0,%ebx
  80178a:	85 c0                	test   %eax,%eax
  80178c:	74 07                	je     801795 <fd_close+0x66>
			r = (*dev->dev_close)(fd);
  80178e:	89 34 24             	mov    %esi,(%esp)
  801791:	ff d0                	call   *%eax
  801793:	89 c3                	mov    %eax,%ebx
		else
			r = 0;
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  801795:	89 74 24 04          	mov    %esi,0x4(%esp)
  801799:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8017a0:	e8 ca f9 ff ff       	call   80116f <sys_page_unmap>
	return r;
}
  8017a5:	89 d8                	mov    %ebx,%eax
  8017a7:	83 c4 20             	add    $0x20,%esp
  8017aa:	5b                   	pop    %ebx
  8017ab:	5e                   	pop    %esi
  8017ac:	5d                   	pop    %ebp
  8017ad:	c3                   	ret    

008017ae <close>:
	return -E_INVAL;
}

int
close(int fdnum)
{
  8017ae:	55                   	push   %ebp
  8017af:	89 e5                	mov    %esp,%ebp
  8017b1:	83 ec 28             	sub    $0x28,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8017b4:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8017b7:	89 44 24 04          	mov    %eax,0x4(%esp)
  8017bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8017be:	89 04 24             	mov    %eax,(%esp)
  8017c1:	e8 27 fc ff ff       	call   8013ed <fd_lookup>
  8017c6:	85 c0                	test   %eax,%eax
  8017c8:	78 13                	js     8017dd <close+0x2f>
		return r;
	else
		return fd_close(fd, 1);
  8017ca:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  8017d1:	00 
  8017d2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8017d5:	89 04 24             	mov    %eax,(%esp)
  8017d8:	e8 52 ff ff ff       	call   80172f <fd_close>
}
  8017dd:	c9                   	leave  
  8017de:	c3                   	ret    

008017df <stat>:
	return (*dev->dev_stat)(fd, stat);
}

int
stat(const char *path, struct Stat *stat)
{
  8017df:	55                   	push   %ebp
  8017e0:	89 e5                	mov    %esp,%ebp
  8017e2:	83 ec 18             	sub    $0x18,%esp
  8017e5:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  8017e8:	89 75 fc             	mov    %esi,-0x4(%ebp)
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  8017eb:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  8017f2:	00 
  8017f3:	8b 45 08             	mov    0x8(%ebp),%eax
  8017f6:	89 04 24             	mov    %eax,(%esp)
  8017f9:	e8 55 03 00 00       	call   801b53 <open>
  8017fe:	89 c3                	mov    %eax,%ebx
  801800:	85 c0                	test   %eax,%eax
  801802:	78 1b                	js     80181f <stat+0x40>
		return fd;
	r = fstat(fd, stat);
  801804:	8b 45 0c             	mov    0xc(%ebp),%eax
  801807:	89 44 24 04          	mov    %eax,0x4(%esp)
  80180b:	89 1c 24             	mov    %ebx,(%esp)
  80180e:	e8 b7 fc ff ff       	call   8014ca <fstat>
  801813:	89 c6                	mov    %eax,%esi
	close(fd);
  801815:	89 1c 24             	mov    %ebx,(%esp)
  801818:	e8 91 ff ff ff       	call   8017ae <close>
  80181d:	89 f3                	mov    %esi,%ebx
	return r;
}
  80181f:	89 d8                	mov    %ebx,%eax
  801821:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  801824:	8b 75 fc             	mov    -0x4(%ebp),%esi
  801827:	89 ec                	mov    %ebp,%esp
  801829:	5d                   	pop    %ebp
  80182a:	c3                   	ret    

0080182b <close_all>:
		return fd_close(fd, 1);
}

void
close_all(void)
{
  80182b:	55                   	push   %ebp
  80182c:	89 e5                	mov    %esp,%ebp
  80182e:	53                   	push   %ebx
  80182f:	83 ec 14             	sub    $0x14,%esp
  801832:	bb 00 00 00 00       	mov    $0x0,%ebx
	int i;
	for (i = 0; i < MAXFD; i++)
		close(i);
  801837:	89 1c 24             	mov    %ebx,(%esp)
  80183a:	e8 6f ff ff ff       	call   8017ae <close>

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  80183f:	83 c3 01             	add    $0x1,%ebx
  801842:	83 fb 20             	cmp    $0x20,%ebx
  801845:	75 f0                	jne    801837 <close_all+0xc>
		close(i);
}
  801847:	83 c4 14             	add    $0x14,%esp
  80184a:	5b                   	pop    %ebx
  80184b:	5d                   	pop    %ebp
  80184c:	c3                   	ret    

0080184d <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  80184d:	55                   	push   %ebp
  80184e:	89 e5                	mov    %esp,%ebp
  801850:	83 ec 58             	sub    $0x58,%esp
  801853:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  801856:	89 75 f8             	mov    %esi,-0x8(%ebp)
  801859:	89 7d fc             	mov    %edi,-0x4(%ebp)
  80185c:	8b 7d 0c             	mov    0xc(%ebp),%edi
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  80185f:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  801862:	89 44 24 04          	mov    %eax,0x4(%esp)
  801866:	8b 45 08             	mov    0x8(%ebp),%eax
  801869:	89 04 24             	mov    %eax,(%esp)
  80186c:	e8 7c fb ff ff       	call   8013ed <fd_lookup>
  801871:	89 c3                	mov    %eax,%ebx
  801873:	85 c0                	test   %eax,%eax
  801875:	0f 88 e0 00 00 00    	js     80195b <dup+0x10e>
		return r;
	close(newfdnum);
  80187b:	89 3c 24             	mov    %edi,(%esp)
  80187e:	e8 2b ff ff ff       	call   8017ae <close>

	newfd = INDEX2FD(newfdnum);
  801883:	8d b7 00 00 0d 00    	lea    0xd0000(%edi),%esi
  801889:	c1 e6 0c             	shl    $0xc,%esi
	ova = fd2data(oldfd);
  80188c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80188f:	89 04 24             	mov    %eax,(%esp)
  801892:	e8 c9 fa ff ff       	call   801360 <fd2data>
  801897:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  801899:	89 34 24             	mov    %esi,(%esp)
  80189c:	e8 bf fa ff ff       	call   801360 <fd2data>
  8018a1:	89 45 d4             	mov    %eax,-0x2c(%ebp)

	if ((vpd[PDX(ova)] & PTE_P) && (vpt[VPN(ova)] & PTE_P))
  8018a4:	89 da                	mov    %ebx,%edx
  8018a6:	89 d8                	mov    %ebx,%eax
  8018a8:	c1 e8 16             	shr    $0x16,%eax
  8018ab:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  8018b2:	a8 01                	test   $0x1,%al
  8018b4:	74 43                	je     8018f9 <dup+0xac>
  8018b6:	c1 ea 0c             	shr    $0xc,%edx
  8018b9:	8b 04 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%eax
  8018c0:	a8 01                	test   $0x1,%al
  8018c2:	74 35                	je     8018f9 <dup+0xac>
		if ((r = sys_page_map(0, ova, 0, nva, vpt[VPN(ova)] & PTE_USER)) < 0)
  8018c4:	8b 04 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%eax
  8018cb:	25 07 0e 00 00       	and    $0xe07,%eax
  8018d0:	89 44 24 10          	mov    %eax,0x10(%esp)
  8018d4:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8018d7:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8018db:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  8018e2:	00 
  8018e3:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8018e7:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8018ee:	e8 da f8 ff ff       	call   8011cd <sys_page_map>
  8018f3:	89 c3                	mov    %eax,%ebx
  8018f5:	85 c0                	test   %eax,%eax
  8018f7:	78 3f                	js     801938 <dup+0xeb>
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, vpt[VPN(oldfd)] & PTE_USER)) < 0)
  8018f9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8018fc:	89 c2                	mov    %eax,%edx
  8018fe:	c1 ea 0c             	shr    $0xc,%edx
  801901:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801908:	81 e2 07 0e 00 00    	and    $0xe07,%edx
  80190e:	89 54 24 10          	mov    %edx,0x10(%esp)
  801912:	89 74 24 0c          	mov    %esi,0xc(%esp)
  801916:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  80191d:	00 
  80191e:	89 44 24 04          	mov    %eax,0x4(%esp)
  801922:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801929:	e8 9f f8 ff ff       	call   8011cd <sys_page_map>
  80192e:	89 c3                	mov    %eax,%ebx
  801930:	85 c0                	test   %eax,%eax
  801932:	78 04                	js     801938 <dup+0xeb>
  801934:	89 fb                	mov    %edi,%ebx
  801936:	eb 23                	jmp    80195b <dup+0x10e>
		goto err;

	return newfdnum;

err:
	sys_page_unmap(0, newfd);
  801938:	89 74 24 04          	mov    %esi,0x4(%esp)
  80193c:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801943:	e8 27 f8 ff ff       	call   80116f <sys_page_unmap>
	sys_page_unmap(0, nva);
  801948:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80194b:	89 44 24 04          	mov    %eax,0x4(%esp)
  80194f:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801956:	e8 14 f8 ff ff       	call   80116f <sys_page_unmap>
	return r;
}
  80195b:	89 d8                	mov    %ebx,%eax
  80195d:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  801960:	8b 75 f8             	mov    -0x8(%ebp),%esi
  801963:	8b 7d fc             	mov    -0x4(%ebp),%edi
  801966:	89 ec                	mov    %ebp,%esp
  801968:	5d                   	pop    %ebp
  801969:	c3                   	ret    
	...

0080196c <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  80196c:	55                   	push   %ebp
  80196d:	89 e5                	mov    %esp,%ebp
  80196f:	53                   	push   %ebx
  801970:	83 ec 14             	sub    $0x14,%esp
  801973:	89 d3                	mov    %edx,%ebx
	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", env->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(envs[1].env_id, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  801975:	8b 15 c8 00 c0 ee    	mov    0xeec000c8,%edx
  80197b:	c7 44 24 0c 07 00 00 	movl   $0x7,0xc(%esp)
  801982:	00 
  801983:	c7 44 24 08 00 30 80 	movl   $0x803000,0x8(%esp)
  80198a:	00 
  80198b:	89 44 24 04          	mov    %eax,0x4(%esp)
  80198f:	89 14 24             	mov    %edx,(%esp)
  801992:	e8 b9 0c 00 00       	call   802650 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  801997:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  80199e:	00 
  80199f:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8019a3:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8019aa:	e8 07 0d 00 00       	call   8026b6 <ipc_recv>
}
  8019af:	83 c4 14             	add    $0x14,%esp
  8019b2:	5b                   	pop    %ebx
  8019b3:	5d                   	pop    %ebp
  8019b4:	c3                   	ret    

008019b5 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  8019b5:	55                   	push   %ebp
  8019b6:	89 e5                	mov    %esp,%ebp
  8019b8:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  8019bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8019be:	8b 40 0c             	mov    0xc(%eax),%eax
  8019c1:	a3 00 30 80 00       	mov    %eax,0x803000
	fsipcbuf.set_size.req_size = newsize;
  8019c6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8019c9:	a3 04 30 80 00       	mov    %eax,0x803004
	return fsipc(FSREQ_SET_SIZE, NULL);
  8019ce:	ba 00 00 00 00       	mov    $0x0,%edx
  8019d3:	b8 02 00 00 00       	mov    $0x2,%eax
  8019d8:	e8 8f ff ff ff       	call   80196c <fsipc>
}
  8019dd:	c9                   	leave  
  8019de:	c3                   	ret    

008019df <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  8019df:	55                   	push   %ebp
  8019e0:	89 e5                	mov    %esp,%ebp
  8019e2:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  8019e5:	8b 45 08             	mov    0x8(%ebp),%eax
  8019e8:	8b 40 0c             	mov    0xc(%eax),%eax
  8019eb:	a3 00 30 80 00       	mov    %eax,0x803000
	return fsipc(FSREQ_FLUSH, NULL);
  8019f0:	ba 00 00 00 00       	mov    $0x0,%edx
  8019f5:	b8 06 00 00 00       	mov    $0x6,%eax
  8019fa:	e8 6d ff ff ff       	call   80196c <fsipc>
}
  8019ff:	c9                   	leave  
  801a00:	c3                   	ret    

00801a01 <sync>:
}

// Synchronize disk with buffer cache
int
sync(void)
{
  801a01:	55                   	push   %ebp
  801a02:	89 e5                	mov    %esp,%ebp
  801a04:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  801a07:	ba 00 00 00 00       	mov    $0x0,%edx
  801a0c:	b8 08 00 00 00       	mov    $0x8,%eax
  801a11:	e8 56 ff ff ff       	call   80196c <fsipc>
}
  801a16:	c9                   	leave  
  801a17:	c3                   	ret    

00801a18 <devfile_stat>:
	return fsipc(FSREQ_WRITE, NULL);	
}

static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  801a18:	55                   	push   %ebp
  801a19:	89 e5                	mov    %esp,%ebp
  801a1b:	53                   	push   %ebx
  801a1c:	83 ec 14             	sub    $0x14,%esp
  801a1f:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  801a22:	8b 45 08             	mov    0x8(%ebp),%eax
  801a25:	8b 40 0c             	mov    0xc(%eax),%eax
  801a28:	a3 00 30 80 00       	mov    %eax,0x803000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  801a2d:	ba 00 00 00 00       	mov    $0x0,%edx
  801a32:	b8 05 00 00 00       	mov    $0x5,%eax
  801a37:	e8 30 ff ff ff       	call   80196c <fsipc>
  801a3c:	85 c0                	test   %eax,%eax
  801a3e:	78 2b                	js     801a6b <devfile_stat+0x53>
		return r;
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  801a40:	c7 44 24 04 00 30 80 	movl   $0x803000,0x4(%esp)
  801a47:	00 
  801a48:	89 1c 24             	mov    %ebx,(%esp)
  801a4b:	e8 ea ef ff ff       	call   800a3a <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  801a50:	a1 80 30 80 00       	mov    0x803080,%eax
  801a55:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  801a5b:	a1 84 30 80 00       	mov    0x803084,%eax
  801a60:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
  801a66:	b8 00 00 00 00       	mov    $0x0,%eax
	return 0;
}
  801a6b:	83 c4 14             	add    $0x14,%esp
  801a6e:	5b                   	pop    %ebx
  801a6f:	5d                   	pop    %ebp
  801a70:	c3                   	ret    

00801a71 <devfile_write>:
// Returns:
//	 The number of bytes successfully written.
//	 < 0 on error.
static ssize_t
devfile_write(struct Fd *fd, const void *buf, size_t n)
{
  801a71:	55                   	push   %ebp
  801a72:	89 e5                	mov    %esp,%ebp
  801a74:	83 ec 18             	sub    $0x18,%esp
  801a77:	8b 45 10             	mov    0x10(%ebp),%eax
  801a7a:	3d f8 0f 00 00       	cmp    $0xff8,%eax
  801a7f:	76 05                	jbe    801a86 <devfile_write+0x15>
  801a81:	b8 f8 0f 00 00       	mov    $0xff8,%eax
	// LAB 5: Your code here
	//panic("devfile_write not implemented");
	
	if (n > (PGSIZE - (sizeof(int) + sizeof(size_t))))
		n = PGSIZE - (sizeof(int) + sizeof(size_t));
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  801a86:	8b 55 08             	mov    0x8(%ebp),%edx
  801a89:	8b 52 0c             	mov    0xc(%edx),%edx
  801a8c:	89 15 00 30 80 00    	mov    %edx,0x803000
	fsipcbuf.write.req_n = n;
  801a92:	a3 04 30 80 00       	mov    %eax,0x803004
	memmove (fsipcbuf.write.req_buf, (char*)buf, n);	
  801a97:	89 44 24 08          	mov    %eax,0x8(%esp)
  801a9b:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a9e:	89 44 24 04          	mov    %eax,0x4(%esp)
  801aa2:	c7 04 24 08 30 80 00 	movl   $0x803008,(%esp)
  801aa9:	e8 47 f1 ff ff       	call   800bf5 <memmove>
	return fsipc(FSREQ_WRITE, NULL);	
  801aae:	ba 00 00 00 00       	mov    $0x0,%edx
  801ab3:	b8 04 00 00 00       	mov    $0x4,%eax
  801ab8:	e8 af fe ff ff       	call   80196c <fsipc>
}
  801abd:	c9                   	leave  
  801abe:	c3                   	ret    

00801abf <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  801abf:	55                   	push   %ebp
  801ac0:	89 e5                	mov    %esp,%ebp
  801ac2:	53                   	push   %ebx
  801ac3:	83 ec 14             	sub    $0x14,%esp
	// system server.
	// LAB 5: Your code here
	
	//panic("devfile_read not implemented");
	int r;
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  801ac6:	8b 45 08             	mov    0x8(%ebp),%eax
  801ac9:	8b 40 0c             	mov    0xc(%eax),%eax
  801acc:	a3 00 30 80 00       	mov    %eax,0x803000
	fsipcbuf.read.req_n = n;
  801ad1:	8b 45 10             	mov    0x10(%ebp),%eax
  801ad4:	a3 04 30 80 00       	mov    %eax,0x803004
	if ((r = fsipc(FSREQ_READ, (void*)&fsipcbuf)) < 0)
  801ad9:	ba 00 30 80 00       	mov    $0x803000,%edx
  801ade:	b8 03 00 00 00       	mov    $0x3,%eax
  801ae3:	e8 84 fe ff ff       	call   80196c <fsipc>
  801ae8:	89 c3                	mov    %eax,%ebx
  801aea:	85 c0                	test   %eax,%eax
  801aec:	78 17                	js     801b05 <devfile_read+0x46>
		return r;
	memmove((void*)buf, (void*)fsipcbuf.readRet.ret_buf, r);
  801aee:	89 44 24 08          	mov    %eax,0x8(%esp)
  801af2:	c7 44 24 04 00 30 80 	movl   $0x803000,0x4(%esp)
  801af9:	00 
  801afa:	8b 45 0c             	mov    0xc(%ebp),%eax
  801afd:	89 04 24             	mov    %eax,(%esp)
  801b00:	e8 f0 f0 ff ff       	call   800bf5 <memmove>
	return r;
}
  801b05:	89 d8                	mov    %ebx,%eax
  801b07:	83 c4 14             	add    $0x14,%esp
  801b0a:	5b                   	pop    %ebx
  801b0b:	5d                   	pop    %ebp
  801b0c:	c3                   	ret    

00801b0d <remove>:
}

// Delete a file
int
remove(const char *path)
{
  801b0d:	55                   	push   %ebp
  801b0e:	89 e5                	mov    %esp,%ebp
  801b10:	53                   	push   %ebx
  801b11:	83 ec 14             	sub    $0x14,%esp
  801b14:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (strlen(path) >= MAXPATHLEN)
  801b17:	89 1c 24             	mov    %ebx,(%esp)
  801b1a:	e8 d1 ee ff ff       	call   8009f0 <strlen>
  801b1f:	89 c2                	mov    %eax,%edx
  801b21:	b8 f4 ff ff ff       	mov    $0xfffffff4,%eax
  801b26:	81 fa ff 03 00 00    	cmp    $0x3ff,%edx
  801b2c:	7f 1f                	jg     801b4d <remove+0x40>
		return -E_BAD_PATH;
	strcpy(fsipcbuf.remove.req_path, path);
  801b2e:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801b32:	c7 04 24 00 30 80 00 	movl   $0x803000,(%esp)
  801b39:	e8 fc ee ff ff       	call   800a3a <strcpy>
	return fsipc(FSREQ_REMOVE, NULL);
  801b3e:	ba 00 00 00 00       	mov    $0x0,%edx
  801b43:	b8 07 00 00 00       	mov    $0x7,%eax
  801b48:	e8 1f fe ff ff       	call   80196c <fsipc>
}
  801b4d:	83 c4 14             	add    $0x14,%esp
  801b50:	5b                   	pop    %ebx
  801b51:	5d                   	pop    %ebp
  801b52:	c3                   	ret    

00801b53 <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  801b53:	55                   	push   %ebp
  801b54:	89 e5                	mov    %esp,%ebp
  801b56:	83 ec 28             	sub    $0x28,%esp
  801b59:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  801b5c:	89 75 fc             	mov    %esi,-0x4(%ebp)
  801b5f:	8b 75 08             	mov    0x8(%ebp),%esi
	// file descriptor.

	// LAB 5: Your code here.
	// Code added by Swastika / Sandeep
	
	if (strlen(path) >= MAXPATHLEN)
  801b62:	89 34 24             	mov    %esi,(%esp)
  801b65:	e8 86 ee ff ff       	call   8009f0 <strlen>
  801b6a:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  801b6f:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  801b74:	7f 5e                	jg     801bd4 <open+0x81>
		return -E_BAD_PATH;
	struct Fd * fd;
	int  r;
	if ((r = fd_alloc(&fd)) < 0)
  801b76:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801b79:	89 04 24             	mov    %eax,(%esp)
  801b7c:	e8 fa f7 ff ff       	call   80137b <fd_alloc>
  801b81:	89 c3                	mov    %eax,%ebx
  801b83:	85 c0                	test   %eax,%eax
  801b85:	78 4d                	js     801bd4 <open+0x81>
		return r;
	strcpy (fsipcbuf.open.req_path, path);
  801b87:	89 74 24 04          	mov    %esi,0x4(%esp)
  801b8b:	c7 04 24 00 30 80 00 	movl   $0x803000,(%esp)
  801b92:	e8 a3 ee ff ff       	call   800a3a <strcpy>
	fsipcbuf.open.req_omode = mode;	
  801b97:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b9a:	a3 00 34 80 00       	mov    %eax,0x803400
	if ((r = fsipc(FSREQ_OPEN,(void*)fd)) < 0)
  801b9f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801ba2:	b8 01 00 00 00       	mov    $0x1,%eax
  801ba7:	e8 c0 fd ff ff       	call   80196c <fsipc>
  801bac:	89 c3                	mov    %eax,%ebx
  801bae:	85 c0                	test   %eax,%eax
  801bb0:	79 15                	jns    801bc7 <open+0x74>
	{
		fd_close(fd,0);
  801bb2:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  801bb9:	00 
  801bba:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801bbd:	89 04 24             	mov    %eax,(%esp)
  801bc0:	e8 6a fb ff ff       	call   80172f <fd_close>
		return r; 
  801bc5:	eb 0d                	jmp    801bd4 <open+0x81>
	}
	return fd2num(fd);
  801bc7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801bca:	89 04 24             	mov    %eax,(%esp)
  801bcd:	e8 7e f7 ff ff       	call   801350 <fd2num>
  801bd2:	89 c3                	mov    %eax,%ebx
	//panic("open not implemented");
}
  801bd4:	89 d8                	mov    %ebx,%eax
  801bd6:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  801bd9:	8b 75 fc             	mov    -0x4(%ebp),%esi
  801bdc:	89 ec                	mov    %ebp,%esp
  801bde:	5d                   	pop    %ebp
  801bdf:	c3                   	ret    

00801be0 <devsock_stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  801be0:	55                   	push   %ebp
  801be1:	89 e5                	mov    %esp,%ebp
  801be3:	83 ec 18             	sub    $0x18,%esp
	strcpy(stat->st_name, "<sock>");
  801be6:	c7 44 24 04 7c 2e 80 	movl   $0x802e7c,0x4(%esp)
  801bed:	00 
  801bee:	8b 45 0c             	mov    0xc(%ebp),%eax
  801bf1:	89 04 24             	mov    %eax,(%esp)
  801bf4:	e8 41 ee ff ff       	call   800a3a <strcpy>
	return 0;
}
  801bf9:	b8 00 00 00 00       	mov    $0x0,%eax
  801bfe:	c9                   	leave  
  801bff:	c3                   	ret    

00801c00 <devsock_close>:
	return nsipc_shutdown(r, how);
}

static int
devsock_close(struct Fd *fd)
{
  801c00:	55                   	push   %ebp
  801c01:	89 e5                	mov    %esp,%ebp
  801c03:	83 ec 18             	sub    $0x18,%esp
	return nsipc_close(fd->fd_sock.sockid);
  801c06:	8b 45 08             	mov    0x8(%ebp),%eax
  801c09:	8b 40 0c             	mov    0xc(%eax),%eax
  801c0c:	89 04 24             	mov    %eax,(%esp)
  801c0f:	e8 9e 02 00 00       	call   801eb2 <nsipc_close>
}
  801c14:	c9                   	leave  
  801c15:	c3                   	ret    

00801c16 <devsock_write>:
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
}

static ssize_t
devsock_write(struct Fd *fd, const void *buf, size_t n)
{
  801c16:	55                   	push   %ebp
  801c17:	89 e5                	mov    %esp,%ebp
  801c19:	83 ec 18             	sub    $0x18,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  801c1c:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  801c23:	00 
  801c24:	8b 45 10             	mov    0x10(%ebp),%eax
  801c27:	89 44 24 08          	mov    %eax,0x8(%esp)
  801c2b:	8b 45 0c             	mov    0xc(%ebp),%eax
  801c2e:	89 44 24 04          	mov    %eax,0x4(%esp)
  801c32:	8b 45 08             	mov    0x8(%ebp),%eax
  801c35:	8b 40 0c             	mov    0xc(%eax),%eax
  801c38:	89 04 24             	mov    %eax,(%esp)
  801c3b:	e8 ae 02 00 00       	call   801eee <nsipc_send>
}
  801c40:	c9                   	leave  
  801c41:	c3                   	ret    

00801c42 <devsock_read>:
	return nsipc_listen(r, backlog);
}

static ssize_t
devsock_read(struct Fd *fd, void *buf, size_t n)
{
  801c42:	55                   	push   %ebp
  801c43:	89 e5                	mov    %esp,%ebp
  801c45:	83 ec 18             	sub    $0x18,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  801c48:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  801c4f:	00 
  801c50:	8b 45 10             	mov    0x10(%ebp),%eax
  801c53:	89 44 24 08          	mov    %eax,0x8(%esp)
  801c57:	8b 45 0c             	mov    0xc(%ebp),%eax
  801c5a:	89 44 24 04          	mov    %eax,0x4(%esp)
  801c5e:	8b 45 08             	mov    0x8(%ebp),%eax
  801c61:	8b 40 0c             	mov    0xc(%eax),%eax
  801c64:	89 04 24             	mov    %eax,(%esp)
  801c67:	e8 f5 02 00 00       	call   801f61 <nsipc_recv>
}
  801c6c:	c9                   	leave  
  801c6d:	c3                   	ret    

00801c6e <alloc_sockfd>:
	return sfd->fd_sock.sockid;
}

static int
alloc_sockfd(int sockid)
{
  801c6e:	55                   	push   %ebp
  801c6f:	89 e5                	mov    %esp,%ebp
  801c71:	56                   	push   %esi
  801c72:	53                   	push   %ebx
  801c73:	83 ec 20             	sub    $0x20,%esp
  801c76:	89 c6                	mov    %eax,%esi
	struct Fd *sfd;
	int r;

	if ((r = fd_alloc(&sfd)) < 0
  801c78:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801c7b:	89 04 24             	mov    %eax,(%esp)
  801c7e:	e8 f8 f6 ff ff       	call   80137b <fd_alloc>
  801c83:	89 c3                	mov    %eax,%ebx
  801c85:	85 c0                	test   %eax,%eax
  801c87:	78 21                	js     801caa <alloc_sockfd+0x3c>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U)) < 0) {
  801c89:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  801c90:	00 
  801c91:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c94:	89 44 24 04          	mov    %eax,0x4(%esp)
  801c98:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801c9f:	e8 87 f5 ff ff       	call   80122b <sys_page_alloc>
  801ca4:	89 c3                	mov    %eax,%ebx
alloc_sockfd(int sockid)
{
	struct Fd *sfd;
	int r;

	if ((r = fd_alloc(&sfd)) < 0
  801ca6:	85 c0                	test   %eax,%eax
  801ca8:	79 0a                	jns    801cb4 <alloc_sockfd+0x46>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U)) < 0) {
		nsipc_close(sockid);
  801caa:	89 34 24             	mov    %esi,(%esp)
  801cad:	e8 00 02 00 00       	call   801eb2 <nsipc_close>
		return r;
  801cb2:	eb 28                	jmp    801cdc <alloc_sockfd+0x6e>
	}

	sfd->fd_dev_id = devsock.dev_id;
  801cb4:	8b 15 20 60 80 00    	mov    0x806020,%edx
  801cba:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801cbd:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  801cbf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801cc2:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	sfd->fd_sock.sockid = sockid;
  801cc9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ccc:	89 70 0c             	mov    %esi,0xc(%eax)
	return fd2num(sfd);
  801ccf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801cd2:	89 04 24             	mov    %eax,(%esp)
  801cd5:	e8 76 f6 ff ff       	call   801350 <fd2num>
  801cda:	89 c3                	mov    %eax,%ebx
}
  801cdc:	89 d8                	mov    %ebx,%eax
  801cde:	83 c4 20             	add    $0x20,%esp
  801ce1:	5b                   	pop    %ebx
  801ce2:	5e                   	pop    %esi
  801ce3:	5d                   	pop    %ebp
  801ce4:	c3                   	ret    

00801ce5 <socket>:
	return 0;
}

int
socket(int domain, int type, int protocol)
{
  801ce5:	55                   	push   %ebp
  801ce6:	89 e5                	mov    %esp,%ebp
  801ce8:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  801ceb:	8b 45 10             	mov    0x10(%ebp),%eax
  801cee:	89 44 24 08          	mov    %eax,0x8(%esp)
  801cf2:	8b 45 0c             	mov    0xc(%ebp),%eax
  801cf5:	89 44 24 04          	mov    %eax,0x4(%esp)
  801cf9:	8b 45 08             	mov    0x8(%ebp),%eax
  801cfc:	89 04 24             	mov    %eax,(%esp)
  801cff:	e8 62 01 00 00       	call   801e66 <nsipc_socket>
  801d04:	85 c0                	test   %eax,%eax
  801d06:	78 05                	js     801d0d <socket+0x28>
		return r;
	return alloc_sockfd(r);
  801d08:	e8 61 ff ff ff       	call   801c6e <alloc_sockfd>
}
  801d0d:	c9                   	leave  
  801d0e:	66 90                	xchg   %ax,%ax
  801d10:	c3                   	ret    

00801d11 <fd2sockid>:
	.dev_stat =	devsock_stat,
};

static int
fd2sockid(int fd)
{
  801d11:	55                   	push   %ebp
  801d12:	89 e5                	mov    %esp,%ebp
  801d14:	83 ec 28             	sub    $0x28,%esp
	struct Fd *sfd;
	int r;

	if ((r = fd_lookup(fd, &sfd)) < 0)
  801d17:	8d 55 f4             	lea    -0xc(%ebp),%edx
  801d1a:	89 54 24 04          	mov    %edx,0x4(%esp)
  801d1e:	89 04 24             	mov    %eax,(%esp)
  801d21:	e8 c7 f6 ff ff       	call   8013ed <fd_lookup>
  801d26:	85 c0                	test   %eax,%eax
  801d28:	78 15                	js     801d3f <fd2sockid+0x2e>
		return r;
	if (sfd->fd_dev_id != devsock.dev_id)
  801d2a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801d2d:	8b 0a                	mov    (%edx),%ecx
  801d2f:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801d34:	3b 0d 20 60 80 00    	cmp    0x806020,%ecx
  801d3a:	75 03                	jne    801d3f <fd2sockid+0x2e>
		return -E_NOT_SUPP;
	return sfd->fd_sock.sockid;
  801d3c:	8b 42 0c             	mov    0xc(%edx),%eax
}
  801d3f:	c9                   	leave  
  801d40:	c3                   	ret    

00801d41 <listen>:
	return nsipc_connect(r, name, namelen);
}

int
listen(int s, int backlog)
{
  801d41:	55                   	push   %ebp
  801d42:	89 e5                	mov    %esp,%ebp
  801d44:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  801d47:	8b 45 08             	mov    0x8(%ebp),%eax
  801d4a:	e8 c2 ff ff ff       	call   801d11 <fd2sockid>
  801d4f:	85 c0                	test   %eax,%eax
  801d51:	78 0f                	js     801d62 <listen+0x21>
		return r;
	return nsipc_listen(r, backlog);
  801d53:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d56:	89 54 24 04          	mov    %edx,0x4(%esp)
  801d5a:	89 04 24             	mov    %eax,(%esp)
  801d5d:	e8 2e 01 00 00       	call   801e90 <nsipc_listen>
}
  801d62:	c9                   	leave  
  801d63:	c3                   	ret    

00801d64 <connect>:
	return nsipc_close(fd->fd_sock.sockid);
}

int
connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  801d64:	55                   	push   %ebp
  801d65:	89 e5                	mov    %esp,%ebp
  801d67:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  801d6a:	8b 45 08             	mov    0x8(%ebp),%eax
  801d6d:	e8 9f ff ff ff       	call   801d11 <fd2sockid>
  801d72:	85 c0                	test   %eax,%eax
  801d74:	78 16                	js     801d8c <connect+0x28>
		return r;
	return nsipc_connect(r, name, namelen);
  801d76:	8b 55 10             	mov    0x10(%ebp),%edx
  801d79:	89 54 24 08          	mov    %edx,0x8(%esp)
  801d7d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d80:	89 54 24 04          	mov    %edx,0x4(%esp)
  801d84:	89 04 24             	mov    %eax,(%esp)
  801d87:	e8 55 02 00 00       	call   801fe1 <nsipc_connect>
}
  801d8c:	c9                   	leave  
  801d8d:	c3                   	ret    

00801d8e <shutdown>:
	return nsipc_bind(r, name, namelen);
}

int
shutdown(int s, int how)
{
  801d8e:	55                   	push   %ebp
  801d8f:	89 e5                	mov    %esp,%ebp
  801d91:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  801d94:	8b 45 08             	mov    0x8(%ebp),%eax
  801d97:	e8 75 ff ff ff       	call   801d11 <fd2sockid>
  801d9c:	85 c0                	test   %eax,%eax
  801d9e:	78 0f                	js     801daf <shutdown+0x21>
		return r;
	return nsipc_shutdown(r, how);
  801da0:	8b 55 0c             	mov    0xc(%ebp),%edx
  801da3:	89 54 24 04          	mov    %edx,0x4(%esp)
  801da7:	89 04 24             	mov    %eax,(%esp)
  801daa:	e8 1d 01 00 00       	call   801ecc <nsipc_shutdown>
}
  801daf:	c9                   	leave  
  801db0:	c3                   	ret    

00801db1 <bind>:
	return alloc_sockfd(r);
}

int
bind(int s, struct sockaddr *name, socklen_t namelen)
{
  801db1:	55                   	push   %ebp
  801db2:	89 e5                	mov    %esp,%ebp
  801db4:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  801db7:	8b 45 08             	mov    0x8(%ebp),%eax
  801dba:	e8 52 ff ff ff       	call   801d11 <fd2sockid>
  801dbf:	85 c0                	test   %eax,%eax
  801dc1:	78 16                	js     801dd9 <bind+0x28>
		return r;
	return nsipc_bind(r, name, namelen);
  801dc3:	8b 55 10             	mov    0x10(%ebp),%edx
  801dc6:	89 54 24 08          	mov    %edx,0x8(%esp)
  801dca:	8b 55 0c             	mov    0xc(%ebp),%edx
  801dcd:	89 54 24 04          	mov    %edx,0x4(%esp)
  801dd1:	89 04 24             	mov    %eax,(%esp)
  801dd4:	e8 47 02 00 00       	call   802020 <nsipc_bind>
}
  801dd9:	c9                   	leave  
  801dda:	c3                   	ret    

00801ddb <accept>:
	return fd2num(sfd);
}

int
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  801ddb:	55                   	push   %ebp
  801ddc:	89 e5                	mov    %esp,%ebp
  801dde:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  801de1:	8b 45 08             	mov    0x8(%ebp),%eax
  801de4:	e8 28 ff ff ff       	call   801d11 <fd2sockid>
  801de9:	85 c0                	test   %eax,%eax
  801deb:	78 1f                	js     801e0c <accept+0x31>
		return r;
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  801ded:	8b 55 10             	mov    0x10(%ebp),%edx
  801df0:	89 54 24 08          	mov    %edx,0x8(%esp)
  801df4:	8b 55 0c             	mov    0xc(%ebp),%edx
  801df7:	89 54 24 04          	mov    %edx,0x4(%esp)
  801dfb:	89 04 24             	mov    %eax,(%esp)
  801dfe:	e8 5c 02 00 00       	call   80205f <nsipc_accept>
  801e03:	85 c0                	test   %eax,%eax
  801e05:	78 05                	js     801e0c <accept+0x31>
		return r;
	return alloc_sockfd(r);
  801e07:	e8 62 fe ff ff       	call   801c6e <alloc_sockfd>
}
  801e0c:	c9                   	leave  
  801e0d:	8d 76 00             	lea    0x0(%esi),%esi
  801e10:	c3                   	ret    
	...

00801e20 <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  801e20:	55                   	push   %ebp
  801e21:	89 e5                	mov    %esp,%ebp
  801e23:	83 ec 18             	sub    $0x18,%esp
	if (debug)
		cprintf("[%08x] nsipc %d\n", env->env_id, type);

	ipc_send(envs[2].env_id, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  801e26:	8b 15 44 01 c0 ee    	mov    0xeec00144,%edx
  801e2c:	c7 44 24 0c 07 00 00 	movl   $0x7,0xc(%esp)
  801e33:	00 
  801e34:	c7 44 24 08 00 50 80 	movl   $0x805000,0x8(%esp)
  801e3b:	00 
  801e3c:	89 44 24 04          	mov    %eax,0x4(%esp)
  801e40:	89 14 24             	mov    %edx,(%esp)
  801e43:	e8 08 08 00 00       	call   802650 <ipc_send>
	return ipc_recv(NULL, NULL, NULL);
  801e48:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801e4f:	00 
  801e50:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  801e57:	00 
  801e58:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801e5f:	e8 52 08 00 00       	call   8026b6 <ipc_recv>
}
  801e64:	c9                   	leave  
  801e65:	c3                   	ret    

00801e66 <nsipc_socket>:
	return nsipc(NSREQ_SEND);
}

int
nsipc_socket(int domain, int type, int protocol)
{
  801e66:	55                   	push   %ebp
  801e67:	89 e5                	mov    %esp,%ebp
  801e69:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  801e6c:	8b 45 08             	mov    0x8(%ebp),%eax
  801e6f:	a3 00 50 80 00       	mov    %eax,0x805000
	nsipcbuf.socket.req_type = type;
  801e74:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e77:	a3 04 50 80 00       	mov    %eax,0x805004
	nsipcbuf.socket.req_protocol = protocol;
  801e7c:	8b 45 10             	mov    0x10(%ebp),%eax
  801e7f:	a3 08 50 80 00       	mov    %eax,0x805008
	return nsipc(NSREQ_SOCKET);
  801e84:	b8 09 00 00 00       	mov    $0x9,%eax
  801e89:	e8 92 ff ff ff       	call   801e20 <nsipc>
}
  801e8e:	c9                   	leave  
  801e8f:	c3                   	ret    

00801e90 <nsipc_listen>:
	return nsipc(NSREQ_CONNECT);
}

int
nsipc_listen(int s, int backlog)
{
  801e90:	55                   	push   %ebp
  801e91:	89 e5                	mov    %esp,%ebp
  801e93:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  801e96:	8b 45 08             	mov    0x8(%ebp),%eax
  801e99:	a3 00 50 80 00       	mov    %eax,0x805000
	nsipcbuf.listen.req_backlog = backlog;
  801e9e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801ea1:	a3 04 50 80 00       	mov    %eax,0x805004
	return nsipc(NSREQ_LISTEN);
  801ea6:	b8 06 00 00 00       	mov    $0x6,%eax
  801eab:	e8 70 ff ff ff       	call   801e20 <nsipc>
}
  801eb0:	c9                   	leave  
  801eb1:	c3                   	ret    

00801eb2 <nsipc_close>:
	return nsipc(NSREQ_SHUTDOWN);
}

int
nsipc_close(int s)
{
  801eb2:	55                   	push   %ebp
  801eb3:	89 e5                	mov    %esp,%ebp
  801eb5:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  801eb8:	8b 45 08             	mov    0x8(%ebp),%eax
  801ebb:	a3 00 50 80 00       	mov    %eax,0x805000
	return nsipc(NSREQ_CLOSE);
  801ec0:	b8 04 00 00 00       	mov    $0x4,%eax
  801ec5:	e8 56 ff ff ff       	call   801e20 <nsipc>
}
  801eca:	c9                   	leave  
  801ecb:	c3                   	ret    

00801ecc <nsipc_shutdown>:
	return nsipc(NSREQ_BIND);
}

int
nsipc_shutdown(int s, int how)
{
  801ecc:	55                   	push   %ebp
  801ecd:	89 e5                	mov    %esp,%ebp
  801ecf:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  801ed2:	8b 45 08             	mov    0x8(%ebp),%eax
  801ed5:	a3 00 50 80 00       	mov    %eax,0x805000
	nsipcbuf.shutdown.req_how = how;
  801eda:	8b 45 0c             	mov    0xc(%ebp),%eax
  801edd:	a3 04 50 80 00       	mov    %eax,0x805004
	return nsipc(NSREQ_SHUTDOWN);
  801ee2:	b8 03 00 00 00       	mov    $0x3,%eax
  801ee7:	e8 34 ff ff ff       	call   801e20 <nsipc>
}
  801eec:	c9                   	leave  
  801eed:	c3                   	ret    

00801eee <nsipc_send>:
	return r;
}

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  801eee:	55                   	push   %ebp
  801eef:	89 e5                	mov    %esp,%ebp
  801ef1:	53                   	push   %ebx
  801ef2:	83 ec 14             	sub    $0x14,%esp
  801ef5:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  801ef8:	8b 45 08             	mov    0x8(%ebp),%eax
  801efb:	a3 00 50 80 00       	mov    %eax,0x805000
	assert(size < 1600);
  801f00:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  801f06:	7e 24                	jle    801f2c <nsipc_send+0x3e>
  801f08:	c7 44 24 0c 88 2e 80 	movl   $0x802e88,0xc(%esp)
  801f0f:	00 
  801f10:	c7 44 24 08 94 2e 80 	movl   $0x802e94,0x8(%esp)
  801f17:	00 
  801f18:	c7 44 24 04 66 00 00 	movl   $0x66,0x4(%esp)
  801f1f:	00 
  801f20:	c7 04 24 a9 2e 80 00 	movl   $0x802ea9,(%esp)
  801f27:	e8 8c e3 ff ff       	call   8002b8 <_panic>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  801f2c:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801f30:	8b 45 0c             	mov    0xc(%ebp),%eax
  801f33:	89 44 24 04          	mov    %eax,0x4(%esp)
  801f37:	c7 04 24 0c 50 80 00 	movl   $0x80500c,(%esp)
  801f3e:	e8 b2 ec ff ff       	call   800bf5 <memmove>
	nsipcbuf.send.req_size = size;
  801f43:	89 1d 04 50 80 00    	mov    %ebx,0x805004
	nsipcbuf.send.req_flags = flags;
  801f49:	8b 45 14             	mov    0x14(%ebp),%eax
  801f4c:	a3 08 50 80 00       	mov    %eax,0x805008
	return nsipc(NSREQ_SEND);
  801f51:	b8 08 00 00 00       	mov    $0x8,%eax
  801f56:	e8 c5 fe ff ff       	call   801e20 <nsipc>
}
  801f5b:	83 c4 14             	add    $0x14,%esp
  801f5e:	5b                   	pop    %ebx
  801f5f:	5d                   	pop    %ebp
  801f60:	c3                   	ret    

00801f61 <nsipc_recv>:
	return nsipc(NSREQ_LISTEN);
}

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  801f61:	55                   	push   %ebp
  801f62:	89 e5                	mov    %esp,%ebp
  801f64:	56                   	push   %esi
  801f65:	53                   	push   %ebx
  801f66:	83 ec 10             	sub    $0x10,%esp
  801f69:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  801f6c:	8b 45 08             	mov    0x8(%ebp),%eax
  801f6f:	a3 00 50 80 00       	mov    %eax,0x805000
	nsipcbuf.recv.req_len = len;
  801f74:	89 35 04 50 80 00    	mov    %esi,0x805004
	nsipcbuf.recv.req_flags = flags;
  801f7a:	8b 45 14             	mov    0x14(%ebp),%eax
  801f7d:	a3 08 50 80 00       	mov    %eax,0x805008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  801f82:	b8 07 00 00 00       	mov    $0x7,%eax
  801f87:	e8 94 fe ff ff       	call   801e20 <nsipc>
  801f8c:	89 c3                	mov    %eax,%ebx
  801f8e:	85 c0                	test   %eax,%eax
  801f90:	78 46                	js     801fd8 <nsipc_recv+0x77>
		assert(r < 1600 && r <= len);
  801f92:	3d 3f 06 00 00       	cmp    $0x63f,%eax
  801f97:	7f 04                	jg     801f9d <nsipc_recv+0x3c>
  801f99:	39 c6                	cmp    %eax,%esi
  801f9b:	7d 24                	jge    801fc1 <nsipc_recv+0x60>
  801f9d:	c7 44 24 0c b5 2e 80 	movl   $0x802eb5,0xc(%esp)
  801fa4:	00 
  801fa5:	c7 44 24 08 94 2e 80 	movl   $0x802e94,0x8(%esp)
  801fac:	00 
  801fad:	c7 44 24 04 5b 00 00 	movl   $0x5b,0x4(%esp)
  801fb4:	00 
  801fb5:	c7 04 24 a9 2e 80 00 	movl   $0x802ea9,(%esp)
  801fbc:	e8 f7 e2 ff ff       	call   8002b8 <_panic>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  801fc1:	89 44 24 08          	mov    %eax,0x8(%esp)
  801fc5:	c7 44 24 04 00 50 80 	movl   $0x805000,0x4(%esp)
  801fcc:	00 
  801fcd:	8b 45 0c             	mov    0xc(%ebp),%eax
  801fd0:	89 04 24             	mov    %eax,(%esp)
  801fd3:	e8 1d ec ff ff       	call   800bf5 <memmove>
	}

	return r;
}
  801fd8:	89 d8                	mov    %ebx,%eax
  801fda:	83 c4 10             	add    $0x10,%esp
  801fdd:	5b                   	pop    %ebx
  801fde:	5e                   	pop    %esi
  801fdf:	5d                   	pop    %ebp
  801fe0:	c3                   	ret    

00801fe1 <nsipc_connect>:
	return nsipc(NSREQ_CLOSE);
}

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  801fe1:	55                   	push   %ebp
  801fe2:	89 e5                	mov    %esp,%ebp
  801fe4:	53                   	push   %ebx
  801fe5:	83 ec 14             	sub    $0x14,%esp
  801fe8:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  801feb:	8b 45 08             	mov    0x8(%ebp),%eax
  801fee:	a3 00 50 80 00       	mov    %eax,0x805000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  801ff3:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801ff7:	8b 45 0c             	mov    0xc(%ebp),%eax
  801ffa:	89 44 24 04          	mov    %eax,0x4(%esp)
  801ffe:	c7 04 24 04 50 80 00 	movl   $0x805004,(%esp)
  802005:	e8 eb eb ff ff       	call   800bf5 <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  80200a:	89 1d 14 50 80 00    	mov    %ebx,0x805014
	return nsipc(NSREQ_CONNECT);
  802010:	b8 05 00 00 00       	mov    $0x5,%eax
  802015:	e8 06 fe ff ff       	call   801e20 <nsipc>
}
  80201a:	83 c4 14             	add    $0x14,%esp
  80201d:	5b                   	pop    %ebx
  80201e:	5d                   	pop    %ebp
  80201f:	c3                   	ret    

00802020 <nsipc_bind>:
	return r;
}

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  802020:	55                   	push   %ebp
  802021:	89 e5                	mov    %esp,%ebp
  802023:	53                   	push   %ebx
  802024:	83 ec 14             	sub    $0x14,%esp
  802027:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  80202a:	8b 45 08             	mov    0x8(%ebp),%eax
  80202d:	a3 00 50 80 00       	mov    %eax,0x805000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  802032:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  802036:	8b 45 0c             	mov    0xc(%ebp),%eax
  802039:	89 44 24 04          	mov    %eax,0x4(%esp)
  80203d:	c7 04 24 04 50 80 00 	movl   $0x805004,(%esp)
  802044:	e8 ac eb ff ff       	call   800bf5 <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  802049:	89 1d 14 50 80 00    	mov    %ebx,0x805014
	return nsipc(NSREQ_BIND);
  80204f:	b8 02 00 00 00       	mov    $0x2,%eax
  802054:	e8 c7 fd ff ff       	call   801e20 <nsipc>
}
  802059:	83 c4 14             	add    $0x14,%esp
  80205c:	5b                   	pop    %ebx
  80205d:	5d                   	pop    %ebp
  80205e:	c3                   	ret    

0080205f <nsipc_accept>:
	return ipc_recv(NULL, NULL, NULL);
}

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  80205f:	55                   	push   %ebp
  802060:	89 e5                	mov    %esp,%ebp
  802062:	83 ec 18             	sub    $0x18,%esp
  802065:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  802068:	89 75 fc             	mov    %esi,-0x4(%ebp)
	int r;
	
	nsipcbuf.accept.req_s = s;
  80206b:	8b 45 08             	mov    0x8(%ebp),%eax
  80206e:	a3 00 50 80 00       	mov    %eax,0x805000
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  802073:	b8 01 00 00 00       	mov    $0x1,%eax
  802078:	e8 a3 fd ff ff       	call   801e20 <nsipc>
  80207d:	89 c3                	mov    %eax,%ebx
  80207f:	85 c0                	test   %eax,%eax
  802081:	78 25                	js     8020a8 <nsipc_accept+0x49>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  802083:	be 10 50 80 00       	mov    $0x805010,%esi
  802088:	8b 06                	mov    (%esi),%eax
  80208a:	89 44 24 08          	mov    %eax,0x8(%esp)
  80208e:	c7 44 24 04 00 50 80 	movl   $0x805000,0x4(%esp)
  802095:	00 
  802096:	8b 45 0c             	mov    0xc(%ebp),%eax
  802099:	89 04 24             	mov    %eax,(%esp)
  80209c:	e8 54 eb ff ff       	call   800bf5 <memmove>
		*addrlen = ret->ret_addrlen;
  8020a1:	8b 16                	mov    (%esi),%edx
  8020a3:	8b 45 10             	mov    0x10(%ebp),%eax
  8020a6:	89 10                	mov    %edx,(%eax)
	}
	return r;
}
  8020a8:	89 d8                	mov    %ebx,%eax
  8020aa:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  8020ad:	8b 75 fc             	mov    -0x4(%ebp),%esi
  8020b0:	89 ec                	mov    %ebp,%esp
  8020b2:	5d                   	pop    %ebp
  8020b3:	c3                   	ret    
	...

008020c0 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  8020c0:	55                   	push   %ebp
  8020c1:	89 e5                	mov    %esp,%ebp
  8020c3:	83 ec 18             	sub    $0x18,%esp
  8020c6:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  8020c9:	89 75 fc             	mov    %esi,-0x4(%ebp)
  8020cc:	8b 75 0c             	mov    0xc(%ebp),%esi
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  8020cf:	8b 45 08             	mov    0x8(%ebp),%eax
  8020d2:	89 04 24             	mov    %eax,(%esp)
  8020d5:	e8 86 f2 ff ff       	call   801360 <fd2data>
  8020da:	89 c3                	mov    %eax,%ebx
	strcpy(stat->st_name, "<pipe>");
  8020dc:	c7 44 24 04 ca 2e 80 	movl   $0x802eca,0x4(%esp)
  8020e3:	00 
  8020e4:	89 34 24             	mov    %esi,(%esp)
  8020e7:	e8 4e e9 ff ff       	call   800a3a <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  8020ec:	8b 43 04             	mov    0x4(%ebx),%eax
  8020ef:	2b 03                	sub    (%ebx),%eax
  8020f1:	89 86 80 00 00 00    	mov    %eax,0x80(%esi)
	stat->st_isdir = 0;
  8020f7:	c7 86 84 00 00 00 00 	movl   $0x0,0x84(%esi)
  8020fe:	00 00 00 
	stat->st_dev = &devpipe;
  802101:	c7 86 88 00 00 00 3c 	movl   $0x80603c,0x88(%esi)
  802108:	60 80 00 
	return 0;
}
  80210b:	b8 00 00 00 00       	mov    $0x0,%eax
  802110:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  802113:	8b 75 fc             	mov    -0x4(%ebp),%esi
  802116:	89 ec                	mov    %ebp,%esp
  802118:	5d                   	pop    %ebp
  802119:	c3                   	ret    

0080211a <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  80211a:	55                   	push   %ebp
  80211b:	89 e5                	mov    %esp,%ebp
  80211d:	53                   	push   %ebx
  80211e:	83 ec 14             	sub    $0x14,%esp
  802121:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  802124:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  802128:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80212f:	e8 3b f0 ff ff       	call   80116f <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  802134:	89 1c 24             	mov    %ebx,(%esp)
  802137:	e8 24 f2 ff ff       	call   801360 <fd2data>
  80213c:	89 44 24 04          	mov    %eax,0x4(%esp)
  802140:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802147:	e8 23 f0 ff ff       	call   80116f <sys_page_unmap>
}
  80214c:	83 c4 14             	add    $0x14,%esp
  80214f:	5b                   	pop    %ebx
  802150:	5d                   	pop    %ebp
  802151:	c3                   	ret    

00802152 <_pipeisclosed>:
	return r;
}

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  802152:	55                   	push   %ebp
  802153:	89 e5                	mov    %esp,%ebp
  802155:	57                   	push   %edi
  802156:	56                   	push   %esi
  802157:	53                   	push   %ebx
  802158:	83 ec 2c             	sub    $0x2c,%esp
  80215b:	89 c7                	mov    %eax,%edi
  80215d:	89 55 e4             	mov    %edx,-0x1c(%ebp)
	int n, nn, ret;

	while (1) {
		n = env->env_runs;
  802160:	a1 74 60 80 00       	mov    0x806074,%eax
  802165:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  802168:	89 3c 24             	mov    %edi,(%esp)
  80216b:	e8 b0 05 00 00       	call   802720 <pageref>
  802170:	89 c6                	mov    %eax,%esi
  802172:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802175:	89 04 24             	mov    %eax,(%esp)
  802178:	e8 a3 05 00 00       	call   802720 <pageref>
  80217d:	39 c6                	cmp    %eax,%esi
  80217f:	0f 94 c0             	sete   %al
  802182:	0f b6 c0             	movzbl %al,%eax
		nn = env->env_runs;
  802185:	8b 15 74 60 80 00    	mov    0x806074,%edx
  80218b:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  80218e:	39 cb                	cmp    %ecx,%ebx
  802190:	75 08                	jne    80219a <_pipeisclosed+0x48>
			return ret;
		if (n != nn && ret == 1)
			cprintf("pipe race avoided\n", n, env->env_runs, ret);
	}
}
  802192:	83 c4 2c             	add    $0x2c,%esp
  802195:	5b                   	pop    %ebx
  802196:	5e                   	pop    %esi
  802197:	5f                   	pop    %edi
  802198:	5d                   	pop    %ebp
  802199:	c3                   	ret    
		n = env->env_runs;
		ret = pageref(fd) == pageref(p);
		nn = env->env_runs;
		if (n == nn)
			return ret;
		if (n != nn && ret == 1)
  80219a:	83 f8 01             	cmp    $0x1,%eax
  80219d:	75 c1                	jne    802160 <_pipeisclosed+0xe>
			cprintf("pipe race avoided\n", n, env->env_runs, ret);
  80219f:	8b 52 58             	mov    0x58(%edx),%edx
  8021a2:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8021a6:	89 54 24 08          	mov    %edx,0x8(%esp)
  8021aa:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8021ae:	c7 04 24 d1 2e 80 00 	movl   $0x802ed1,(%esp)
  8021b5:	e8 c3 e1 ff ff       	call   80037d <cprintf>
  8021ba:	eb a4                	jmp    802160 <_pipeisclosed+0xe>

008021bc <devpipe_write>:
	return i;
}

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  8021bc:	55                   	push   %ebp
  8021bd:	89 e5                	mov    %esp,%ebp
  8021bf:	57                   	push   %edi
  8021c0:	56                   	push   %esi
  8021c1:	53                   	push   %ebx
  8021c2:	83 ec 1c             	sub    $0x1c,%esp
  8021c5:	8b 75 08             	mov    0x8(%ebp),%esi
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  8021c8:	89 34 24             	mov    %esi,(%esp)
  8021cb:	e8 90 f1 ff ff       	call   801360 <fd2data>
  8021d0:	89 c3                	mov    %eax,%ebx
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			env->env_id, vpt[VPN(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  8021d2:	bf 00 00 00 00       	mov    $0x0,%edi
  8021d7:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8021db:	75 54                	jne    802231 <devpipe_write+0x75>
  8021dd:	eb 60                	jmp    80223f <devpipe_write+0x83>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  8021df:	89 da                	mov    %ebx,%edx
  8021e1:	89 f0                	mov    %esi,%eax
  8021e3:	e8 6a ff ff ff       	call   802152 <_pipeisclosed>
  8021e8:	85 c0                	test   %eax,%eax
  8021ea:	74 07                	je     8021f3 <devpipe_write+0x37>
  8021ec:	b8 00 00 00 00       	mov    $0x0,%eax
  8021f1:	eb 53                	jmp    802246 <devpipe_write+0x8a>
				return 0;
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  8021f3:	90                   	nop
  8021f4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  8021f8:	e8 8d f0 ff ff       	call   80128a <sys_yield>
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			env->env_id, vpt[VPN(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  8021fd:	8b 43 04             	mov    0x4(%ebx),%eax
  802200:	8b 13                	mov    (%ebx),%edx
  802202:	83 c2 20             	add    $0x20,%edx
  802205:	39 d0                	cmp    %edx,%eax
  802207:	73 d6                	jae    8021df <devpipe_write+0x23>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  802209:	89 c2                	mov    %eax,%edx
  80220b:	c1 fa 1f             	sar    $0x1f,%edx
  80220e:	c1 ea 1b             	shr    $0x1b,%edx
  802211:	01 d0                	add    %edx,%eax
  802213:	83 e0 1f             	and    $0x1f,%eax
  802216:	29 d0                	sub    %edx,%eax
  802218:	89 c2                	mov    %eax,%edx
  80221a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80221d:	0f b6 04 39          	movzbl (%ecx,%edi,1),%eax
  802221:	88 44 13 08          	mov    %al,0x8(%ebx,%edx,1)
		p->p_wpos++;
  802225:	83 43 04 01          	addl   $0x1,0x4(%ebx)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			env->env_id, vpt[VPN(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  802229:	83 c7 01             	add    $0x1,%edi
  80222c:	39 7d 10             	cmp    %edi,0x10(%ebp)
  80222f:	76 13                	jbe    802244 <devpipe_write+0x88>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  802231:	8b 43 04             	mov    0x4(%ebx),%eax
  802234:	8b 13                	mov    (%ebx),%edx
  802236:	83 c2 20             	add    $0x20,%edx
  802239:	39 d0                	cmp    %edx,%eax
  80223b:	73 a2                	jae    8021df <devpipe_write+0x23>
  80223d:	eb ca                	jmp    802209 <devpipe_write+0x4d>
  80223f:	bf 00 00 00 00       	mov    $0x0,%edi
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}
	
	return i;
  802244:	89 f8                	mov    %edi,%eax
}
  802246:	83 c4 1c             	add    $0x1c,%esp
  802249:	5b                   	pop    %ebx
  80224a:	5e                   	pop    %esi
  80224b:	5f                   	pop    %edi
  80224c:	5d                   	pop    %ebp
  80224d:	c3                   	ret    

0080224e <devpipe_read>:
	return _pipeisclosed(fd, p);
}

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  80224e:	55                   	push   %ebp
  80224f:	89 e5                	mov    %esp,%ebp
  802251:	83 ec 28             	sub    $0x28,%esp
  802254:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  802257:	89 75 f8             	mov    %esi,-0x8(%ebp)
  80225a:	89 7d fc             	mov    %edi,-0x4(%ebp)
  80225d:	8b 7d 08             	mov    0x8(%ebp),%edi
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  802260:	89 3c 24             	mov    %edi,(%esp)
  802263:	e8 f8 f0 ff ff       	call   801360 <fd2data>
  802268:	89 c3                	mov    %eax,%ebx
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			env->env_id, vpt[VPN(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  80226a:	be 00 00 00 00       	mov    $0x0,%esi
  80226f:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  802273:	75 4c                	jne    8022c1 <devpipe_read+0x73>
  802275:	eb 5b                	jmp    8022d2 <devpipe_read+0x84>
		while (p->p_rpos == p->p_wpos) {
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
				return i;
  802277:	89 f0                	mov    %esi,%eax
  802279:	eb 5e                	jmp    8022d9 <devpipe_read+0x8b>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  80227b:	89 da                	mov    %ebx,%edx
  80227d:	89 f8                	mov    %edi,%eax
  80227f:	90                   	nop
  802280:	e8 cd fe ff ff       	call   802152 <_pipeisclosed>
  802285:	85 c0                	test   %eax,%eax
  802287:	74 07                	je     802290 <devpipe_read+0x42>
  802289:	b8 00 00 00 00       	mov    $0x0,%eax
  80228e:	eb 49                	jmp    8022d9 <devpipe_read+0x8b>
				return 0;
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  802290:	e8 f5 ef ff ff       	call   80128a <sys_yield>
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			env->env_id, vpt[VPN(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  802295:	8b 03                	mov    (%ebx),%eax
  802297:	3b 43 04             	cmp    0x4(%ebx),%eax
  80229a:	74 df                	je     80227b <devpipe_read+0x2d>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  80229c:	89 c2                	mov    %eax,%edx
  80229e:	c1 fa 1f             	sar    $0x1f,%edx
  8022a1:	c1 ea 1b             	shr    $0x1b,%edx
  8022a4:	01 d0                	add    %edx,%eax
  8022a6:	83 e0 1f             	and    $0x1f,%eax
  8022a9:	29 d0                	sub    %edx,%eax
  8022ab:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  8022b0:	8b 55 0c             	mov    0xc(%ebp),%edx
  8022b3:	88 04 32             	mov    %al,(%edx,%esi,1)
		p->p_rpos++;
  8022b6:	83 03 01             	addl   $0x1,(%ebx)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			env->env_id, vpt[VPN(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  8022b9:	83 c6 01             	add    $0x1,%esi
  8022bc:	39 75 10             	cmp    %esi,0x10(%ebp)
  8022bf:	76 16                	jbe    8022d7 <devpipe_read+0x89>
		while (p->p_rpos == p->p_wpos) {
  8022c1:	8b 03                	mov    (%ebx),%eax
  8022c3:	3b 43 04             	cmp    0x4(%ebx),%eax
  8022c6:	75 d4                	jne    80229c <devpipe_read+0x4e>
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  8022c8:	85 f6                	test   %esi,%esi
  8022ca:	75 ab                	jne    802277 <devpipe_read+0x29>
  8022cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  8022d0:	eb a9                	jmp    80227b <devpipe_read+0x2d>
  8022d2:	be 00 00 00 00       	mov    $0x0,%esi
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  8022d7:	89 f0                	mov    %esi,%eax
}
  8022d9:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  8022dc:	8b 75 f8             	mov    -0x8(%ebp),%esi
  8022df:	8b 7d fc             	mov    -0x4(%ebp),%edi
  8022e2:	89 ec                	mov    %ebp,%esp
  8022e4:	5d                   	pop    %ebp
  8022e5:	c3                   	ret    

008022e6 <pipeisclosed>:
	}
}

int
pipeisclosed(int fdnum)
{
  8022e6:	55                   	push   %ebp
  8022e7:	89 e5                	mov    %esp,%ebp
  8022e9:	83 ec 28             	sub    $0x28,%esp
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8022ec:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8022ef:	89 44 24 04          	mov    %eax,0x4(%esp)
  8022f3:	8b 45 08             	mov    0x8(%ebp),%eax
  8022f6:	89 04 24             	mov    %eax,(%esp)
  8022f9:	e8 ef f0 ff ff       	call   8013ed <fd_lookup>
  8022fe:	85 c0                	test   %eax,%eax
  802300:	78 15                	js     802317 <pipeisclosed+0x31>
		return r;
	p = (struct Pipe*) fd2data(fd);
  802302:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802305:	89 04 24             	mov    %eax,(%esp)
  802308:	e8 53 f0 ff ff       	call   801360 <fd2data>
	return _pipeisclosed(fd, p);
  80230d:	89 c2                	mov    %eax,%edx
  80230f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802312:	e8 3b fe ff ff       	call   802152 <_pipeisclosed>
}
  802317:	c9                   	leave  
  802318:	c3                   	ret    

00802319 <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  802319:	55                   	push   %ebp
  80231a:	89 e5                	mov    %esp,%ebp
  80231c:	83 ec 48             	sub    $0x48,%esp
  80231f:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  802322:	89 75 f8             	mov    %esi,-0x8(%ebp)
  802325:	89 7d fc             	mov    %edi,-0x4(%ebp)
  802328:	8b 7d 08             	mov    0x8(%ebp),%edi
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  80232b:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  80232e:	89 04 24             	mov    %eax,(%esp)
  802331:	e8 45 f0 ff ff       	call   80137b <fd_alloc>
  802336:	89 c3                	mov    %eax,%ebx
  802338:	85 c0                	test   %eax,%eax
  80233a:	0f 88 42 01 00 00    	js     802482 <pipe+0x169>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802340:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  802347:	00 
  802348:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80234b:	89 44 24 04          	mov    %eax,0x4(%esp)
  80234f:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802356:	e8 d0 ee ff ff       	call   80122b <sys_page_alloc>
  80235b:	89 c3                	mov    %eax,%ebx
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  80235d:	85 c0                	test   %eax,%eax
  80235f:	0f 88 1d 01 00 00    	js     802482 <pipe+0x169>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  802365:	8d 45 e0             	lea    -0x20(%ebp),%eax
  802368:	89 04 24             	mov    %eax,(%esp)
  80236b:	e8 0b f0 ff ff       	call   80137b <fd_alloc>
  802370:	89 c3                	mov    %eax,%ebx
  802372:	85 c0                	test   %eax,%eax
  802374:	0f 88 f5 00 00 00    	js     80246f <pipe+0x156>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80237a:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  802381:	00 
  802382:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802385:	89 44 24 04          	mov    %eax,0x4(%esp)
  802389:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802390:	e8 96 ee ff ff       	call   80122b <sys_page_alloc>
  802395:	89 c3                	mov    %eax,%ebx
	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  802397:	85 c0                	test   %eax,%eax
  802399:	0f 88 d0 00 00 00    	js     80246f <pipe+0x156>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  80239f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8023a2:	89 04 24             	mov    %eax,(%esp)
  8023a5:	e8 b6 ef ff ff       	call   801360 <fd2data>
  8023aa:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8023ac:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  8023b3:	00 
  8023b4:	89 44 24 04          	mov    %eax,0x4(%esp)
  8023b8:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8023bf:	e8 67 ee ff ff       	call   80122b <sys_page_alloc>
  8023c4:	89 c3                	mov    %eax,%ebx
  8023c6:	85 c0                	test   %eax,%eax
  8023c8:	0f 88 8e 00 00 00    	js     80245c <pipe+0x143>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8023ce:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8023d1:	89 04 24             	mov    %eax,(%esp)
  8023d4:	e8 87 ef ff ff       	call   801360 <fd2data>
  8023d9:	c7 44 24 10 07 04 00 	movl   $0x407,0x10(%esp)
  8023e0:	00 
  8023e1:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8023e5:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  8023ec:	00 
  8023ed:	89 74 24 04          	mov    %esi,0x4(%esp)
  8023f1:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8023f8:	e8 d0 ed ff ff       	call   8011cd <sys_page_map>
  8023fd:	89 c3                	mov    %eax,%ebx
  8023ff:	85 c0                	test   %eax,%eax
  802401:	78 49                	js     80244c <pipe+0x133>
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  802403:	b8 3c 60 80 00       	mov    $0x80603c,%eax
  802408:	8b 08                	mov    (%eax),%ecx
  80240a:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80240d:	89 0a                	mov    %ecx,(%edx)
	fd0->fd_omode = O_RDONLY;
  80240f:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802412:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%edx)

	fd1->fd_dev_id = devpipe.dev_id;
  802419:	8b 10                	mov    (%eax),%edx
  80241b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80241e:	89 10                	mov    %edx,(%eax)
	fd1->fd_omode = O_WRONLY;
  802420:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802423:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", env->env_id, vpt[VPN(va)]);

	pfd[0] = fd2num(fd0);
  80242a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80242d:	89 04 24             	mov    %eax,(%esp)
  802430:	e8 1b ef ff ff       	call   801350 <fd2num>
  802435:	89 07                	mov    %eax,(%edi)
	pfd[1] = fd2num(fd1);
  802437:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80243a:	89 04 24             	mov    %eax,(%esp)
  80243d:	e8 0e ef ff ff       	call   801350 <fd2num>
  802442:	89 47 04             	mov    %eax,0x4(%edi)
  802445:	bb 00 00 00 00       	mov    $0x0,%ebx
	return 0;
  80244a:	eb 36                	jmp    802482 <pipe+0x169>

    err3:
	sys_page_unmap(0, va);
  80244c:	89 74 24 04          	mov    %esi,0x4(%esp)
  802450:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802457:	e8 13 ed ff ff       	call   80116f <sys_page_unmap>
    err2:
	sys_page_unmap(0, fd1);
  80245c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80245f:	89 44 24 04          	mov    %eax,0x4(%esp)
  802463:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80246a:	e8 00 ed ff ff       	call   80116f <sys_page_unmap>
    err1:
	sys_page_unmap(0, fd0);
  80246f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802472:	89 44 24 04          	mov    %eax,0x4(%esp)
  802476:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80247d:	e8 ed ec ff ff       	call   80116f <sys_page_unmap>
    err:
	return r;
}
  802482:	89 d8                	mov    %ebx,%eax
  802484:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  802487:	8b 75 f8             	mov    -0x8(%ebp),%esi
  80248a:	8b 7d fc             	mov    -0x4(%ebp),%edi
  80248d:	89 ec                	mov    %ebp,%esp
  80248f:	5d                   	pop    %ebp
  802490:	c3                   	ret    
	...

008024a0 <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  8024a0:	55                   	push   %ebp
  8024a1:	89 e5                	mov    %esp,%ebp
	USED(fd);

	return 0;
}
  8024a3:	b8 00 00 00 00       	mov    $0x0,%eax
  8024a8:	5d                   	pop    %ebp
  8024a9:	c3                   	ret    

008024aa <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  8024aa:	55                   	push   %ebp
  8024ab:	89 e5                	mov    %esp,%ebp
  8024ad:	83 ec 18             	sub    $0x18,%esp
	strcpy(stat->st_name, "<cons>");
  8024b0:	c7 44 24 04 e9 2e 80 	movl   $0x802ee9,0x4(%esp)
  8024b7:	00 
  8024b8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8024bb:	89 04 24             	mov    %eax,(%esp)
  8024be:	e8 77 e5 ff ff       	call   800a3a <strcpy>
	return 0;
}
  8024c3:	b8 00 00 00 00       	mov    $0x0,%eax
  8024c8:	c9                   	leave  
  8024c9:	c3                   	ret    

008024ca <devcons_write>:
	return 1;
}

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  8024ca:	55                   	push   %ebp
  8024cb:	89 e5                	mov    %esp,%ebp
  8024cd:	57                   	push   %edi
  8024ce:	56                   	push   %esi
  8024cf:	53                   	push   %ebx
  8024d0:	81 ec 9c 00 00 00    	sub    $0x9c,%esp
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs, 
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  8024d6:	b8 00 00 00 00       	mov    $0x0,%eax
  8024db:	be 00 00 00 00       	mov    $0x0,%esi
  8024e0:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8024e4:	74 3f                	je     802525 <devcons_write+0x5b>
		m = n - tot;
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  8024e6:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs, 
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
		m = n - tot;
  8024ec:	8b 55 10             	mov    0x10(%ebp),%edx
  8024ef:	29 c2                	sub    %eax,%edx
  8024f1:	89 d3                	mov    %edx,%ebx
		if (m > sizeof(buf) - 1)
  8024f3:	83 fa 7f             	cmp    $0x7f,%edx
  8024f6:	76 05                	jbe    8024fd <devcons_write+0x33>
  8024f8:	bb 7f 00 00 00       	mov    $0x7f,%ebx
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  8024fd:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  802501:	03 45 0c             	add    0xc(%ebp),%eax
  802504:	89 44 24 04          	mov    %eax,0x4(%esp)
  802508:	89 3c 24             	mov    %edi,(%esp)
  80250b:	e8 e5 e6 ff ff       	call   800bf5 <memmove>
		sys_cputs(buf, m);
  802510:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  802514:	89 3c 24             	mov    %edi,(%esp)
  802517:	e8 14 e9 ff ff       	call   800e30 <sys_cputs>
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs, 
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  80251c:	01 de                	add    %ebx,%esi
  80251e:	89 f0                	mov    %esi,%eax
  802520:	3b 75 10             	cmp    0x10(%ebp),%esi
  802523:	72 c7                	jb     8024ec <devcons_write+0x22>
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
}
  802525:	89 f0                	mov    %esi,%eax
  802527:	81 c4 9c 00 00 00    	add    $0x9c,%esp
  80252d:	5b                   	pop    %ebx
  80252e:	5e                   	pop    %esi
  80252f:	5f                   	pop    %edi
  802530:	5d                   	pop    %ebp
  802531:	c3                   	ret    

00802532 <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  802532:	55                   	push   %ebp
  802533:	89 e5                	mov    %esp,%ebp
  802535:	83 ec 28             	sub    $0x28,%esp
	char c = ch;
  802538:	8b 45 08             	mov    0x8(%ebp),%eax
  80253b:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  80253e:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  802545:	00 
  802546:	8d 45 f7             	lea    -0x9(%ebp),%eax
  802549:	89 04 24             	mov    %eax,(%esp)
  80254c:	e8 df e8 ff ff       	call   800e30 <sys_cputs>
}
  802551:	c9                   	leave  
  802552:	c3                   	ret    

00802553 <devcons_read>:
	return fd2num(fd);
}

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  802553:	55                   	push   %ebp
  802554:	89 e5                	mov    %esp,%ebp
  802556:	83 ec 08             	sub    $0x8,%esp
	int c;

	if (n == 0)
  802559:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80255d:	75 07                	jne    802566 <devcons_read+0x13>
  80255f:	eb 28                	jmp    802589 <devcons_read+0x36>
		return 0;

	while ((c = sys_cgetc()) == 0)
		sys_yield();
  802561:	e8 24 ed ff ff       	call   80128a <sys_yield>
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  802566:	66 90                	xchg   %ax,%ax
  802568:	e8 8f e8 ff ff       	call   800dfc <sys_cgetc>
  80256d:	85 c0                	test   %eax,%eax
  80256f:	90                   	nop
  802570:	74 ef                	je     802561 <devcons_read+0xe>
  802572:	89 c2                	mov    %eax,%edx
		sys_yield();
	if (c < 0)
  802574:	85 c0                	test   %eax,%eax
  802576:	78 16                	js     80258e <devcons_read+0x3b>
		return c;
	if (c == 0x04)	// ctl-d is eof
  802578:	83 f8 04             	cmp    $0x4,%eax
  80257b:	74 0c                	je     802589 <devcons_read+0x36>
		return 0;
	*(char*)vbuf = c;
  80257d:	8b 45 0c             	mov    0xc(%ebp),%eax
  802580:	88 10                	mov    %dl,(%eax)
  802582:	b8 01 00 00 00       	mov    $0x1,%eax
	return 1;
  802587:	eb 05                	jmp    80258e <devcons_read+0x3b>
  802589:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80258e:	c9                   	leave  
  80258f:	c3                   	ret    

00802590 <opencons>:
	return fd->fd_dev_id == devcons.dev_id;
}

int
opencons(void)
{
  802590:	55                   	push   %ebp
  802591:	89 e5                	mov    %esp,%ebp
  802593:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  802596:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802599:	89 04 24             	mov    %eax,(%esp)
  80259c:	e8 da ed ff ff       	call   80137b <fd_alloc>
  8025a1:	85 c0                	test   %eax,%eax
  8025a3:	78 3f                	js     8025e4 <opencons+0x54>
		return r;
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  8025a5:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  8025ac:	00 
  8025ad:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025b0:	89 44 24 04          	mov    %eax,0x4(%esp)
  8025b4:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8025bb:	e8 6b ec ff ff       	call   80122b <sys_page_alloc>
  8025c0:	85 c0                	test   %eax,%eax
  8025c2:	78 20                	js     8025e4 <opencons+0x54>
		return r;
	fd->fd_dev_id = devcons.dev_id;
  8025c4:	8b 15 58 60 80 00    	mov    0x806058,%edx
  8025ca:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025cd:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  8025cf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025d2:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  8025d9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025dc:	89 04 24             	mov    %eax,(%esp)
  8025df:	e8 6c ed ff ff       	call   801350 <fd2num>
}
  8025e4:	c9                   	leave  
  8025e5:	c3                   	ret    

008025e6 <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  8025e6:	55                   	push   %ebp
  8025e7:	89 e5                	mov    %esp,%ebp
  8025e9:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8025ec:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8025ef:	89 44 24 04          	mov    %eax,0x4(%esp)
  8025f3:	8b 45 08             	mov    0x8(%ebp),%eax
  8025f6:	89 04 24             	mov    %eax,(%esp)
  8025f9:	e8 ef ed ff ff       	call   8013ed <fd_lookup>
  8025fe:	85 c0                	test   %eax,%eax
  802600:	78 11                	js     802613 <iscons+0x2d>
		return r;
	return fd->fd_dev_id == devcons.dev_id;
  802602:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802605:	8b 00                	mov    (%eax),%eax
  802607:	3b 05 58 60 80 00    	cmp    0x806058,%eax
  80260d:	0f 94 c0             	sete   %al
  802610:	0f b6 c0             	movzbl %al,%eax
}
  802613:	c9                   	leave  
  802614:	c3                   	ret    

00802615 <getchar>:
	sys_cputs(&c, 1);
}

int
getchar(void)
{
  802615:	55                   	push   %ebp
  802616:	89 e5                	mov    %esp,%ebp
  802618:	83 ec 28             	sub    $0x28,%esp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  80261b:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  802622:	00 
  802623:	8d 45 f7             	lea    -0x9(%ebp),%eax
  802626:	89 44 24 04          	mov    %eax,0x4(%esp)
  80262a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802631:	e8 18 f0 ff ff       	call   80164e <read>
	if (r < 0)
  802636:	85 c0                	test   %eax,%eax
  802638:	78 0f                	js     802649 <getchar+0x34>
		return r;
	if (r < 1)
  80263a:	85 c0                	test   %eax,%eax
  80263c:	7f 07                	jg     802645 <getchar+0x30>
  80263e:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  802643:	eb 04                	jmp    802649 <getchar+0x34>
		return -E_EOF;
	return c;
  802645:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  802649:	c9                   	leave  
  80264a:	c3                   	ret    
  80264b:	00 00                	add    %al,(%eax)
  80264d:	00 00                	add    %al,(%eax)
	...

00802650 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  802650:	55                   	push   %ebp
  802651:	89 e5                	mov    %esp,%ebp
  802653:	57                   	push   %edi
  802654:	56                   	push   %esi
  802655:	53                   	push   %ebx
  802656:	83 ec 1c             	sub    $0x1c,%esp
  802659:	8b 7d 0c             	mov    0xc(%ebp),%edi
  80265c:	8b 5d 10             	mov    0x10(%ebp),%ebx
  80265f:	8b 75 14             	mov    0x14(%ebp),%esi
	// LAB 4: Your code here.
	int r;
	if (pg == NULL)
  802662:	85 db                	test   %ebx,%ebx
  802664:	75 2d                	jne    802693 <ipc_send+0x43>
  802666:	bb 00 00 c0 ee       	mov    $0xeec00000,%ebx
  80266b:	eb 26                	jmp    802693 <ipc_send+0x43>
		pg = (void*)UTOP;
	while ((r = sys_ipc_try_send(to_env, val, pg, perm)) < 0)
	{
		if(r != -E_IPC_NOT_RECV)
  80266d:	83 f8 f9             	cmp    $0xfffffff9,%eax
  802670:	74 1c                	je     80268e <ipc_send+0x3e>
			panic("Panic in lib ipc.c : ipc_send() \n");
  802672:	c7 44 24 08 f8 2e 80 	movl   $0x802ef8,0x8(%esp)
  802679:	00 
  80267a:	c7 44 24 04 44 00 00 	movl   $0x44,0x4(%esp)
  802681:	00 
  802682:	c7 04 24 1c 2f 80 00 	movl   $0x802f1c,(%esp)
  802689:	e8 2a dc ff ff       	call   8002b8 <_panic>
		sys_yield();
  80268e:	e8 f7 eb ff ff       	call   80128a <sys_yield>
{
	// LAB 4: Your code here.
	int r;
	if (pg == NULL)
		pg = (void*)UTOP;
	while ((r = sys_ipc_try_send(to_env, val, pg, perm)) < 0)
  802693:	89 74 24 0c          	mov    %esi,0xc(%esp)
  802697:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80269b:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80269f:	8b 45 08             	mov    0x8(%ebp),%eax
  8026a2:	89 04 24             	mov    %eax,(%esp)
  8026a5:	e8 73 e9 ff ff       	call   80101d <sys_ipc_try_send>
  8026aa:	85 c0                	test   %eax,%eax
  8026ac:	78 bf                	js     80266d <ipc_send+0x1d>
		if(r != -E_IPC_NOT_RECV)
			panic("Panic in lib ipc.c : ipc_send() \n");
		sys_yield();
	}
	//panic("ipc_send not implemented");
}
  8026ae:	83 c4 1c             	add    $0x1c,%esp
  8026b1:	5b                   	pop    %ebx
  8026b2:	5e                   	pop    %esi
  8026b3:	5f                   	pop    %edi
  8026b4:	5d                   	pop    %ebp
  8026b5:	c3                   	ret    

008026b6 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  8026b6:	55                   	push   %ebp
  8026b7:	89 e5                	mov    %esp,%ebp
  8026b9:	56                   	push   %esi
  8026ba:	53                   	push   %ebx
  8026bb:	83 ec 10             	sub    $0x10,%esp
  8026be:	8b 5d 08             	mov    0x8(%ebp),%ebx
  8026c1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8026c4:	8b 75 10             	mov    0x10(%ebp),%esi
	// LAB 4: Your code here.
	int r;

	if (pg == NULL)
  8026c7:	85 c0                	test   %eax,%eax
  8026c9:	75 05                	jne    8026d0 <ipc_recv+0x1a>
  8026cb:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
		pg = (void*)UTOP;
	if ((r = sys_ipc_recv(pg)) < 0)
  8026d0:	89 04 24             	mov    %eax,(%esp)
  8026d3:	e8 e8 e8 ff ff       	call   800fc0 <sys_ipc_recv>
  8026d8:	85 c0                	test   %eax,%eax
  8026da:	79 16                	jns    8026f2 <ipc_recv+0x3c>
	{
		if (from_env_store != NULL)
  8026dc:	85 db                	test   %ebx,%ebx
  8026de:	74 06                	je     8026e6 <ipc_recv+0x30>
			*from_env_store = 0;
  8026e0:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
		if(perm_store != NULL)
  8026e6:	85 f6                	test   %esi,%esi
  8026e8:	74 2c                	je     802716 <ipc_recv+0x60>
			*perm_store = 0;
  8026ea:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
  8026f0:	eb 24                	jmp    802716 <ipc_recv+0x60>
		return r;
	}
	else
	{	
		if (from_env_store != NULL)
  8026f2:	85 db                	test   %ebx,%ebx
  8026f4:	74 0a                	je     802700 <ipc_recv+0x4a>
			*from_env_store = env->env_ipc_from;
  8026f6:	a1 74 60 80 00       	mov    0x806074,%eax
  8026fb:	8b 40 74             	mov    0x74(%eax),%eax
  8026fe:	89 03                	mov    %eax,(%ebx)
		if(perm_store != NULL)
  802700:	85 f6                	test   %esi,%esi
  802702:	74 0a                	je     80270e <ipc_recv+0x58>
			*perm_store = env->env_ipc_perm;
  802704:	a1 74 60 80 00       	mov    0x806074,%eax
  802709:	8b 40 78             	mov    0x78(%eax),%eax
  80270c:	89 06                	mov    %eax,(%esi)
		return env->env_ipc_value;
  80270e:	a1 74 60 80 00       	mov    0x806074,%eax
  802713:	8b 40 70             	mov    0x70(%eax),%eax
	}		
	//panic("ipc_recv not implemented");
	//return 0;
}
  802716:	83 c4 10             	add    $0x10,%esp
  802719:	5b                   	pop    %ebx
  80271a:	5e                   	pop    %esi
  80271b:	5d                   	pop    %ebp
  80271c:	c3                   	ret    
  80271d:	00 00                	add    %al,(%eax)
	...

00802720 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  802720:	55                   	push   %ebp
  802721:	89 e5                	mov    %esp,%ebp
	pte_t pte;

	if (!(vpd[PDX(v)] & PTE_P))
  802723:	8b 45 08             	mov    0x8(%ebp),%eax
  802726:	89 c2                	mov    %eax,%edx
  802728:	c1 ea 16             	shr    $0x16,%edx
  80272b:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  802732:	f6 c2 01             	test   $0x1,%dl
  802735:	74 26                	je     80275d <pageref+0x3d>
		return 0;
	pte = vpt[VPN(v)];
  802737:	c1 e8 0c             	shr    $0xc,%eax
  80273a:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
	if (!(pte & PTE_P))
  802741:	a8 01                	test   $0x1,%al
  802743:	74 18                	je     80275d <pageref+0x3d>
		return 0;
	return pages[PPN(pte)].pp_ref;
  802745:	c1 e8 0c             	shr    $0xc,%eax
  802748:	8d 14 40             	lea    (%eax,%eax,2),%edx
  80274b:	c1 e2 02             	shl    $0x2,%edx
  80274e:	b8 00 00 00 ef       	mov    $0xef000000,%eax
  802753:	0f b7 44 02 08       	movzwl 0x8(%edx,%eax,1),%eax
  802758:	0f b7 c0             	movzwl %ax,%eax
  80275b:	eb 05                	jmp    802762 <pageref+0x42>
  80275d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802762:	5d                   	pop    %ebp
  802763:	c3                   	ret    
	...

00802770 <__udivdi3>:
  802770:	55                   	push   %ebp
  802771:	89 e5                	mov    %esp,%ebp
  802773:	57                   	push   %edi
  802774:	56                   	push   %esi
  802775:	83 ec 10             	sub    $0x10,%esp
  802778:	8b 45 14             	mov    0x14(%ebp),%eax
  80277b:	8b 55 08             	mov    0x8(%ebp),%edx
  80277e:	8b 75 10             	mov    0x10(%ebp),%esi
  802781:	8b 7d 0c             	mov    0xc(%ebp),%edi
  802784:	85 c0                	test   %eax,%eax
  802786:	89 55 f0             	mov    %edx,-0x10(%ebp)
  802789:	75 35                	jne    8027c0 <__udivdi3+0x50>
  80278b:	39 fe                	cmp    %edi,%esi
  80278d:	77 61                	ja     8027f0 <__udivdi3+0x80>
  80278f:	85 f6                	test   %esi,%esi
  802791:	75 0b                	jne    80279e <__udivdi3+0x2e>
  802793:	b8 01 00 00 00       	mov    $0x1,%eax
  802798:	31 d2                	xor    %edx,%edx
  80279a:	f7 f6                	div    %esi
  80279c:	89 c6                	mov    %eax,%esi
  80279e:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  8027a1:	31 d2                	xor    %edx,%edx
  8027a3:	89 f8                	mov    %edi,%eax
  8027a5:	f7 f6                	div    %esi
  8027a7:	89 c7                	mov    %eax,%edi
  8027a9:	89 c8                	mov    %ecx,%eax
  8027ab:	f7 f6                	div    %esi
  8027ad:	89 c1                	mov    %eax,%ecx
  8027af:	89 fa                	mov    %edi,%edx
  8027b1:	89 c8                	mov    %ecx,%eax
  8027b3:	83 c4 10             	add    $0x10,%esp
  8027b6:	5e                   	pop    %esi
  8027b7:	5f                   	pop    %edi
  8027b8:	5d                   	pop    %ebp
  8027b9:	c3                   	ret    
  8027ba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  8027c0:	39 f8                	cmp    %edi,%eax
  8027c2:	77 1c                	ja     8027e0 <__udivdi3+0x70>
  8027c4:	0f bd d0             	bsr    %eax,%edx
  8027c7:	83 f2 1f             	xor    $0x1f,%edx
  8027ca:	89 55 f4             	mov    %edx,-0xc(%ebp)
  8027cd:	75 39                	jne    802808 <__udivdi3+0x98>
  8027cf:	3b 75 f0             	cmp    -0x10(%ebp),%esi
  8027d2:	0f 86 a0 00 00 00    	jbe    802878 <__udivdi3+0x108>
  8027d8:	39 f8                	cmp    %edi,%eax
  8027da:	0f 82 98 00 00 00    	jb     802878 <__udivdi3+0x108>
  8027e0:	31 ff                	xor    %edi,%edi
  8027e2:	31 c9                	xor    %ecx,%ecx
  8027e4:	89 c8                	mov    %ecx,%eax
  8027e6:	89 fa                	mov    %edi,%edx
  8027e8:	83 c4 10             	add    $0x10,%esp
  8027eb:	5e                   	pop    %esi
  8027ec:	5f                   	pop    %edi
  8027ed:	5d                   	pop    %ebp
  8027ee:	c3                   	ret    
  8027ef:	90                   	nop
  8027f0:	89 d1                	mov    %edx,%ecx
  8027f2:	89 fa                	mov    %edi,%edx
  8027f4:	89 c8                	mov    %ecx,%eax
  8027f6:	31 ff                	xor    %edi,%edi
  8027f8:	f7 f6                	div    %esi
  8027fa:	89 c1                	mov    %eax,%ecx
  8027fc:	89 fa                	mov    %edi,%edx
  8027fe:	89 c8                	mov    %ecx,%eax
  802800:	83 c4 10             	add    $0x10,%esp
  802803:	5e                   	pop    %esi
  802804:	5f                   	pop    %edi
  802805:	5d                   	pop    %ebp
  802806:	c3                   	ret    
  802807:	90                   	nop
  802808:	0f b6 4d f4          	movzbl -0xc(%ebp),%ecx
  80280c:	89 f2                	mov    %esi,%edx
  80280e:	d3 e0                	shl    %cl,%eax
  802810:	89 45 ec             	mov    %eax,-0x14(%ebp)
  802813:	b8 20 00 00 00       	mov    $0x20,%eax
  802818:	2b 45 f4             	sub    -0xc(%ebp),%eax
  80281b:	89 c1                	mov    %eax,%ecx
  80281d:	d3 ea                	shr    %cl,%edx
  80281f:	0f b6 4d f4          	movzbl -0xc(%ebp),%ecx
  802823:	0b 55 ec             	or     -0x14(%ebp),%edx
  802826:	d3 e6                	shl    %cl,%esi
  802828:	89 c1                	mov    %eax,%ecx
  80282a:	89 75 e8             	mov    %esi,-0x18(%ebp)
  80282d:	89 fe                	mov    %edi,%esi
  80282f:	d3 ee                	shr    %cl,%esi
  802831:	0f b6 4d f4          	movzbl -0xc(%ebp),%ecx
  802835:	89 55 ec             	mov    %edx,-0x14(%ebp)
  802838:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80283b:	d3 e7                	shl    %cl,%edi
  80283d:	89 c1                	mov    %eax,%ecx
  80283f:	d3 ea                	shr    %cl,%edx
  802841:	09 d7                	or     %edx,%edi
  802843:	89 f2                	mov    %esi,%edx
  802845:	89 f8                	mov    %edi,%eax
  802847:	f7 75 ec             	divl   -0x14(%ebp)
  80284a:	89 d6                	mov    %edx,%esi
  80284c:	89 c7                	mov    %eax,%edi
  80284e:	f7 65 e8             	mull   -0x18(%ebp)
  802851:	39 d6                	cmp    %edx,%esi
  802853:	89 55 ec             	mov    %edx,-0x14(%ebp)
  802856:	72 30                	jb     802888 <__udivdi3+0x118>
  802858:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80285b:	0f b6 4d f4          	movzbl -0xc(%ebp),%ecx
  80285f:	d3 e2                	shl    %cl,%edx
  802861:	39 c2                	cmp    %eax,%edx
  802863:	73 05                	jae    80286a <__udivdi3+0xfa>
  802865:	3b 75 ec             	cmp    -0x14(%ebp),%esi
  802868:	74 1e                	je     802888 <__udivdi3+0x118>
  80286a:	89 f9                	mov    %edi,%ecx
  80286c:	31 ff                	xor    %edi,%edi
  80286e:	e9 71 ff ff ff       	jmp    8027e4 <__udivdi3+0x74>
  802873:	90                   	nop
  802874:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802878:	31 ff                	xor    %edi,%edi
  80287a:	b9 01 00 00 00       	mov    $0x1,%ecx
  80287f:	e9 60 ff ff ff       	jmp    8027e4 <__udivdi3+0x74>
  802884:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802888:	8d 4f ff             	lea    -0x1(%edi),%ecx
  80288b:	31 ff                	xor    %edi,%edi
  80288d:	89 c8                	mov    %ecx,%eax
  80288f:	89 fa                	mov    %edi,%edx
  802891:	83 c4 10             	add    $0x10,%esp
  802894:	5e                   	pop    %esi
  802895:	5f                   	pop    %edi
  802896:	5d                   	pop    %ebp
  802897:	c3                   	ret    
	...

008028a0 <__umoddi3>:
  8028a0:	55                   	push   %ebp
  8028a1:	89 e5                	mov    %esp,%ebp
  8028a3:	57                   	push   %edi
  8028a4:	56                   	push   %esi
  8028a5:	83 ec 20             	sub    $0x20,%esp
  8028a8:	8b 55 14             	mov    0x14(%ebp),%edx
  8028ab:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8028ae:	8b 7d 10             	mov    0x10(%ebp),%edi
  8028b1:	8b 75 0c             	mov    0xc(%ebp),%esi
  8028b4:	85 d2                	test   %edx,%edx
  8028b6:	89 c8                	mov    %ecx,%eax
  8028b8:	89 4d f4             	mov    %ecx,-0xc(%ebp)
  8028bb:	75 13                	jne    8028d0 <__umoddi3+0x30>
  8028bd:	39 f7                	cmp    %esi,%edi
  8028bf:	76 3f                	jbe    802900 <__umoddi3+0x60>
  8028c1:	89 f2                	mov    %esi,%edx
  8028c3:	f7 f7                	div    %edi
  8028c5:	89 d0                	mov    %edx,%eax
  8028c7:	31 d2                	xor    %edx,%edx
  8028c9:	83 c4 20             	add    $0x20,%esp
  8028cc:	5e                   	pop    %esi
  8028cd:	5f                   	pop    %edi
  8028ce:	5d                   	pop    %ebp
  8028cf:	c3                   	ret    
  8028d0:	39 f2                	cmp    %esi,%edx
  8028d2:	77 4c                	ja     802920 <__umoddi3+0x80>
  8028d4:	0f bd ca             	bsr    %edx,%ecx
  8028d7:	83 f1 1f             	xor    $0x1f,%ecx
  8028da:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  8028dd:	75 51                	jne    802930 <__umoddi3+0x90>
  8028df:	3b 7d f4             	cmp    -0xc(%ebp),%edi
  8028e2:	0f 87 e0 00 00 00    	ja     8029c8 <__umoddi3+0x128>
  8028e8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028eb:	29 f8                	sub    %edi,%eax
  8028ed:	19 d6                	sbb    %edx,%esi
  8028ef:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8028f2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028f5:	89 f2                	mov    %esi,%edx
  8028f7:	83 c4 20             	add    $0x20,%esp
  8028fa:	5e                   	pop    %esi
  8028fb:	5f                   	pop    %edi
  8028fc:	5d                   	pop    %ebp
  8028fd:	c3                   	ret    
  8028fe:	66 90                	xchg   %ax,%ax
  802900:	85 ff                	test   %edi,%edi
  802902:	75 0b                	jne    80290f <__umoddi3+0x6f>
  802904:	b8 01 00 00 00       	mov    $0x1,%eax
  802909:	31 d2                	xor    %edx,%edx
  80290b:	f7 f7                	div    %edi
  80290d:	89 c7                	mov    %eax,%edi
  80290f:	89 f0                	mov    %esi,%eax
  802911:	31 d2                	xor    %edx,%edx
  802913:	f7 f7                	div    %edi
  802915:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802918:	f7 f7                	div    %edi
  80291a:	eb a9                	jmp    8028c5 <__umoddi3+0x25>
  80291c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802920:	89 c8                	mov    %ecx,%eax
  802922:	89 f2                	mov    %esi,%edx
  802924:	83 c4 20             	add    $0x20,%esp
  802927:	5e                   	pop    %esi
  802928:	5f                   	pop    %edi
  802929:	5d                   	pop    %ebp
  80292a:	c3                   	ret    
  80292b:	90                   	nop
  80292c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802930:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
  802934:	d3 e2                	shl    %cl,%edx
  802936:	89 55 f4             	mov    %edx,-0xc(%ebp)
  802939:	ba 20 00 00 00       	mov    $0x20,%edx
  80293e:	2b 55 f0             	sub    -0x10(%ebp),%edx
  802941:	89 55 ec             	mov    %edx,-0x14(%ebp)
  802944:	0f b6 4d ec          	movzbl -0x14(%ebp),%ecx
  802948:	89 fa                	mov    %edi,%edx
  80294a:	d3 ea                	shr    %cl,%edx
  80294c:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
  802950:	0b 55 f4             	or     -0xc(%ebp),%edx
  802953:	d3 e7                	shl    %cl,%edi
  802955:	0f b6 4d ec          	movzbl -0x14(%ebp),%ecx
  802959:	89 55 f4             	mov    %edx,-0xc(%ebp)
  80295c:	89 f2                	mov    %esi,%edx
  80295e:	89 7d e8             	mov    %edi,-0x18(%ebp)
  802961:	89 c7                	mov    %eax,%edi
  802963:	d3 ea                	shr    %cl,%edx
  802965:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
  802969:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  80296c:	89 c2                	mov    %eax,%edx
  80296e:	d3 e6                	shl    %cl,%esi
  802970:	0f b6 4d ec          	movzbl -0x14(%ebp),%ecx
  802974:	d3 ea                	shr    %cl,%edx
  802976:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
  80297a:	09 d6                	or     %edx,%esi
  80297c:	89 f0                	mov    %esi,%eax
  80297e:	8b 75 e4             	mov    -0x1c(%ebp),%esi
  802981:	d3 e7                	shl    %cl,%edi
  802983:	89 f2                	mov    %esi,%edx
  802985:	f7 75 f4             	divl   -0xc(%ebp)
  802988:	89 d6                	mov    %edx,%esi
  80298a:	f7 65 e8             	mull   -0x18(%ebp)
  80298d:	39 d6                	cmp    %edx,%esi
  80298f:	72 2b                	jb     8029bc <__umoddi3+0x11c>
  802991:	39 c7                	cmp    %eax,%edi
  802993:	72 23                	jb     8029b8 <__umoddi3+0x118>
  802995:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
  802999:	29 c7                	sub    %eax,%edi
  80299b:	19 d6                	sbb    %edx,%esi
  80299d:	89 f0                	mov    %esi,%eax
  80299f:	89 f2                	mov    %esi,%edx
  8029a1:	d3 ef                	shr    %cl,%edi
  8029a3:	0f b6 4d ec          	movzbl -0x14(%ebp),%ecx
  8029a7:	d3 e0                	shl    %cl,%eax
  8029a9:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
  8029ad:	09 f8                	or     %edi,%eax
  8029af:	d3 ea                	shr    %cl,%edx
  8029b1:	83 c4 20             	add    $0x20,%esp
  8029b4:	5e                   	pop    %esi
  8029b5:	5f                   	pop    %edi
  8029b6:	5d                   	pop    %ebp
  8029b7:	c3                   	ret    
  8029b8:	39 d6                	cmp    %edx,%esi
  8029ba:	75 d9                	jne    802995 <__umoddi3+0xf5>
  8029bc:	2b 45 e8             	sub    -0x18(%ebp),%eax
  8029bf:	1b 55 f4             	sbb    -0xc(%ebp),%edx
  8029c2:	eb d1                	jmp    802995 <__umoddi3+0xf5>
  8029c4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  8029c8:	39 f2                	cmp    %esi,%edx
  8029ca:	0f 82 18 ff ff ff    	jb     8028e8 <__umoddi3+0x48>
  8029d0:	e9 1d ff ff ff       	jmp    8028f2 <__umoddi3+0x52>
