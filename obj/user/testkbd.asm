
obj/user/testkbd:     file format elf32-i386


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
  80002c:	e8 9b 02 00 00       	call   8002cc <libmain>
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
  80003b:	bb 00 00 00 00       	mov    $0x0,%ebx
	int i, r;

	// Spin for a bit to let the console quiet
	for (i = 0; i < 10; ++i)
		sys_yield();
  800040:	e8 b5 13 00 00       	call   8013fa <sys_yield>
umain(void)
{
	int i, r;

	// Spin for a bit to let the console quiet
	for (i = 0; i < 10; ++i)
  800045:	83 c3 01             	add    $0x1,%ebx
  800048:	83 fb 0a             	cmp    $0xa,%ebx
  80004b:	75 f3                	jne    800040 <umain+0xc>
		sys_yield();

	close(0);
  80004d:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  800054:	e8 c5 18 00 00       	call   80191e <close>
	if ((r = opencons()) < 0)
  800059:	e8 b2 01 00 00       	call   800210 <opencons>
  80005e:	85 c0                	test   %eax,%eax
  800060:	79 20                	jns    800082 <umain+0x4e>
		panic("opencons: %e", r);
  800062:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800066:	c7 44 24 08 e0 2a 80 	movl   $0x802ae0,0x8(%esp)
  80006d:	00 
  80006e:	c7 44 24 04 0f 00 00 	movl   $0xf,0x4(%esp)
  800075:	00 
  800076:	c7 04 24 ed 2a 80 00 	movl   $0x802aed,(%esp)
  80007d:	e8 b6 02 00 00       	call   800338 <_panic>
	if (r != 0)
  800082:	85 c0                	test   %eax,%eax
  800084:	74 20                	je     8000a6 <umain+0x72>
		panic("first opencons used fd %d", r);
  800086:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80008a:	c7 44 24 08 fc 2a 80 	movl   $0x802afc,0x8(%esp)
  800091:	00 
  800092:	c7 44 24 04 11 00 00 	movl   $0x11,0x4(%esp)
  800099:	00 
  80009a:	c7 04 24 ed 2a 80 00 	movl   $0x802aed,(%esp)
  8000a1:	e8 92 02 00 00       	call   800338 <_panic>
	if ((r = dup(0, 1)) < 0)
  8000a6:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  8000ad:	00 
  8000ae:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8000b5:	e8 03 19 00 00       	call   8019bd <dup>
  8000ba:	85 c0                	test   %eax,%eax
  8000bc:	79 20                	jns    8000de <umain+0xaa>
		panic("dup: %e", r);
  8000be:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8000c2:	c7 44 24 08 16 2b 80 	movl   $0x802b16,0x8(%esp)
  8000c9:	00 
  8000ca:	c7 44 24 04 13 00 00 	movl   $0x13,0x4(%esp)
  8000d1:	00 
  8000d2:	c7 04 24 ed 2a 80 00 	movl   $0x802aed,(%esp)
  8000d9:	e8 5a 02 00 00       	call   800338 <_panic>

	for(;;){
		char *buf;

		buf = readline("Type a line: ");
  8000de:	c7 04 24 1e 2b 80 00 	movl   $0x802b1e,(%esp)
  8000e5:	e8 86 09 00 00       	call   800a70 <readline>
		if (buf != NULL)
  8000ea:	85 c0                	test   %eax,%eax
  8000ec:	74 1a                	je     800108 <umain+0xd4>
			fprintf(1, "%s\n", buf);
  8000ee:	89 44 24 08          	mov    %eax,0x8(%esp)
  8000f2:	c7 44 24 04 2c 2b 80 	movl   $0x802b2c,0x4(%esp)
  8000f9:	00 
  8000fa:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  800101:	e8 2f 1d 00 00       	call   801e35 <fprintf>
  800106:	eb d6                	jmp    8000de <umain+0xaa>
		else
			fprintf(1, "(end of file received)\n");
  800108:	c7 44 24 04 30 2b 80 	movl   $0x802b30,0x4(%esp)
  80010f:	00 
  800110:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  800117:	e8 19 1d 00 00       	call   801e35 <fprintf>
  80011c:	eb c0                	jmp    8000de <umain+0xaa>
	...

00800120 <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  800120:	55                   	push   %ebp
  800121:	89 e5                	mov    %esp,%ebp
	USED(fd);

	return 0;
}
  800123:	b8 00 00 00 00       	mov    $0x0,%eax
  800128:	5d                   	pop    %ebp
  800129:	c3                   	ret    

0080012a <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  80012a:	55                   	push   %ebp
  80012b:	89 e5                	mov    %esp,%ebp
  80012d:	83 ec 18             	sub    $0x18,%esp
	strcpy(stat->st_name, "<cons>");
  800130:	c7 44 24 04 48 2b 80 	movl   $0x802b48,0x4(%esp)
  800137:	00 
  800138:	8b 45 0c             	mov    0xc(%ebp),%eax
  80013b:	89 04 24             	mov    %eax,(%esp)
  80013e:	e8 67 0a 00 00       	call   800baa <strcpy>
	return 0;
}
  800143:	b8 00 00 00 00       	mov    $0x0,%eax
  800148:	c9                   	leave  
  800149:	c3                   	ret    

0080014a <devcons_write>:
	return 1;
}

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  80014a:	55                   	push   %ebp
  80014b:	89 e5                	mov    %esp,%ebp
  80014d:	57                   	push   %edi
  80014e:	56                   	push   %esi
  80014f:	53                   	push   %ebx
  800150:	81 ec 9c 00 00 00    	sub    $0x9c,%esp
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs, 
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  800156:	b8 00 00 00 00       	mov    $0x0,%eax
  80015b:	be 00 00 00 00       	mov    $0x0,%esi
  800160:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800164:	74 3f                	je     8001a5 <devcons_write+0x5b>
		m = n - tot;
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  800166:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs, 
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
		m = n - tot;
  80016c:	8b 55 10             	mov    0x10(%ebp),%edx
  80016f:	29 c2                	sub    %eax,%edx
  800171:	89 d3                	mov    %edx,%ebx
		if (m > sizeof(buf) - 1)
  800173:	83 fa 7f             	cmp    $0x7f,%edx
  800176:	76 05                	jbe    80017d <devcons_write+0x33>
  800178:	bb 7f 00 00 00       	mov    $0x7f,%ebx
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  80017d:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  800181:	03 45 0c             	add    0xc(%ebp),%eax
  800184:	89 44 24 04          	mov    %eax,0x4(%esp)
  800188:	89 3c 24             	mov    %edi,(%esp)
  80018b:	e8 d5 0b 00 00       	call   800d65 <memmove>
		sys_cputs(buf, m);
  800190:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  800194:	89 3c 24             	mov    %edi,(%esp)
  800197:	e8 04 0e 00 00       	call   800fa0 <sys_cputs>
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs, 
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  80019c:	01 de                	add    %ebx,%esi
  80019e:	89 f0                	mov    %esi,%eax
  8001a0:	3b 75 10             	cmp    0x10(%ebp),%esi
  8001a3:	72 c7                	jb     80016c <devcons_write+0x22>
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
}
  8001a5:	89 f0                	mov    %esi,%eax
  8001a7:	81 c4 9c 00 00 00    	add    $0x9c,%esp
  8001ad:	5b                   	pop    %ebx
  8001ae:	5e                   	pop    %esi
  8001af:	5f                   	pop    %edi
  8001b0:	5d                   	pop    %ebp
  8001b1:	c3                   	ret    

008001b2 <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  8001b2:	55                   	push   %ebp
  8001b3:	89 e5                	mov    %esp,%ebp
  8001b5:	83 ec 28             	sub    $0x28,%esp
	char c = ch;
  8001b8:	8b 45 08             	mov    0x8(%ebp),%eax
  8001bb:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  8001be:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  8001c5:	00 
  8001c6:	8d 45 f7             	lea    -0x9(%ebp),%eax
  8001c9:	89 04 24             	mov    %eax,(%esp)
  8001cc:	e8 cf 0d 00 00       	call   800fa0 <sys_cputs>
}
  8001d1:	c9                   	leave  
  8001d2:	c3                   	ret    

008001d3 <devcons_read>:
	return fd2num(fd);
}

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  8001d3:	55                   	push   %ebp
  8001d4:	89 e5                	mov    %esp,%ebp
  8001d6:	83 ec 08             	sub    $0x8,%esp
	int c;

	if (n == 0)
  8001d9:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8001dd:	75 07                	jne    8001e6 <devcons_read+0x13>
  8001df:	eb 28                	jmp    800209 <devcons_read+0x36>
		return 0;

	while ((c = sys_cgetc()) == 0)
		sys_yield();
  8001e1:	e8 14 12 00 00       	call   8013fa <sys_yield>
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  8001e6:	66 90                	xchg   %ax,%ax
  8001e8:	e8 7f 0d 00 00       	call   800f6c <sys_cgetc>
  8001ed:	85 c0                	test   %eax,%eax
  8001ef:	90                   	nop
  8001f0:	74 ef                	je     8001e1 <devcons_read+0xe>
  8001f2:	89 c2                	mov    %eax,%edx
		sys_yield();
	if (c < 0)
  8001f4:	85 c0                	test   %eax,%eax
  8001f6:	78 16                	js     80020e <devcons_read+0x3b>
		return c;
	if (c == 0x04)	// ctl-d is eof
  8001f8:	83 f8 04             	cmp    $0x4,%eax
  8001fb:	74 0c                	je     800209 <devcons_read+0x36>
		return 0;
	*(char*)vbuf = c;
  8001fd:	8b 45 0c             	mov    0xc(%ebp),%eax
  800200:	88 10                	mov    %dl,(%eax)
  800202:	b8 01 00 00 00       	mov    $0x1,%eax
	return 1;
  800207:	eb 05                	jmp    80020e <devcons_read+0x3b>
  800209:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80020e:	c9                   	leave  
  80020f:	c3                   	ret    

00800210 <opencons>:
	return fd->fd_dev_id == devcons.dev_id;
}

int
opencons(void)
{
  800210:	55                   	push   %ebp
  800211:	89 e5                	mov    %esp,%ebp
  800213:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  800216:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800219:	89 04 24             	mov    %eax,(%esp)
  80021c:	e8 ca 12 00 00       	call   8014eb <fd_alloc>
  800221:	85 c0                	test   %eax,%eax
  800223:	78 3f                	js     800264 <opencons+0x54>
		return r;
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  800225:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  80022c:	00 
  80022d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800230:	89 44 24 04          	mov    %eax,0x4(%esp)
  800234:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80023b:	e8 5b 11 00 00       	call   80139b <sys_page_alloc>
  800240:	85 c0                	test   %eax,%eax
  800242:	78 20                	js     800264 <opencons+0x54>
		return r;
	fd->fd_dev_id = devcons.dev_id;
  800244:	8b 15 00 60 80 00    	mov    0x806000,%edx
  80024a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80024d:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  80024f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800252:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  800259:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80025c:	89 04 24             	mov    %eax,(%esp)
  80025f:	e8 5c 12 00 00       	call   8014c0 <fd2num>
}
  800264:	c9                   	leave  
  800265:	c3                   	ret    

00800266 <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  800266:	55                   	push   %ebp
  800267:	89 e5                	mov    %esp,%ebp
  800269:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80026c:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80026f:	89 44 24 04          	mov    %eax,0x4(%esp)
  800273:	8b 45 08             	mov    0x8(%ebp),%eax
  800276:	89 04 24             	mov    %eax,(%esp)
  800279:	e8 df 12 00 00       	call   80155d <fd_lookup>
  80027e:	85 c0                	test   %eax,%eax
  800280:	78 11                	js     800293 <iscons+0x2d>
		return r;
	return fd->fd_dev_id == devcons.dev_id;
  800282:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800285:	8b 00                	mov    (%eax),%eax
  800287:	3b 05 00 60 80 00    	cmp    0x806000,%eax
  80028d:	0f 94 c0             	sete   %al
  800290:	0f b6 c0             	movzbl %al,%eax
}
  800293:	c9                   	leave  
  800294:	c3                   	ret    

00800295 <getchar>:
	sys_cputs(&c, 1);
}

int
getchar(void)
{
  800295:	55                   	push   %ebp
  800296:	89 e5                	mov    %esp,%ebp
  800298:	83 ec 28             	sub    $0x28,%esp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  80029b:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  8002a2:	00 
  8002a3:	8d 45 f7             	lea    -0x9(%ebp),%eax
  8002a6:	89 44 24 04          	mov    %eax,0x4(%esp)
  8002aa:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8002b1:	e8 08 15 00 00       	call   8017be <read>
	if (r < 0)
  8002b6:	85 c0                	test   %eax,%eax
  8002b8:	78 0f                	js     8002c9 <getchar+0x34>
		return r;
	if (r < 1)
  8002ba:	85 c0                	test   %eax,%eax
  8002bc:	7f 07                	jg     8002c5 <getchar+0x30>
  8002be:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  8002c3:	eb 04                	jmp    8002c9 <getchar+0x34>
		return -E_EOF;
	return c;
  8002c5:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  8002c9:	c9                   	leave  
  8002ca:	c3                   	ret    
	...

008002cc <libmain>:
volatile struct Env *env;
char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  8002cc:	55                   	push   %ebp
  8002cd:	89 e5                	mov    %esp,%ebp
  8002cf:	83 ec 18             	sub    $0x18,%esp
  8002d2:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  8002d5:	89 75 fc             	mov    %esi,-0x4(%ebp)
  8002d8:	8b 75 08             	mov    0x8(%ebp),%esi
  8002db:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	// set env to point at our env structure in envs[].
	// LAB 3b: Your code here.
	// Code added by Swastika / Sandeep	
	envid_t envid = sys_getenvid();
  8002de:	e8 4b 11 00 00       	call   80142e <sys_getenvid>
	env = &envs[ENVX(envid)];
  8002e3:	25 ff 03 00 00       	and    $0x3ff,%eax
  8002e8:	6b c0 7c             	imul   $0x7c,%eax,%eax
  8002eb:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8002f0:	a3 80 64 80 00       	mov    %eax,0x806480

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8002f5:	85 f6                	test   %esi,%esi
  8002f7:	7e 07                	jle    800300 <libmain+0x34>
		binaryname = argv[0];
  8002f9:	8b 03                	mov    (%ebx),%eax
  8002fb:	a3 1c 60 80 00       	mov    %eax,0x80601c

	// call user main routine
	umain(argc, argv);
  800300:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  800304:	89 34 24             	mov    %esi,(%esp)
  800307:	e8 28 fd ff ff       	call   800034 <umain>

	// exit gracefully
	exit();
  80030c:	e8 0b 00 00 00       	call   80031c <exit>
}
  800311:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  800314:	8b 75 fc             	mov    -0x4(%ebp),%esi
  800317:	89 ec                	mov    %ebp,%esp
  800319:	5d                   	pop    %ebp
  80031a:	c3                   	ret    
	...

0080031c <exit>:
#include <inc/lib.h>

void
exit(void)
{
  80031c:	55                   	push   %ebp
  80031d:	89 e5                	mov    %esp,%ebp
  80031f:	83 ec 18             	sub    $0x18,%esp
	close_all();
  800322:	e8 74 16 00 00       	call   80199b <close_all>
	sys_env_destroy(0);
  800327:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80032e:	e8 2f 11 00 00       	call   801462 <sys_env_destroy>
}
  800333:	c9                   	leave  
  800334:	c3                   	ret    
  800335:	00 00                	add    %al,(%eax)
	...

00800338 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  800338:	55                   	push   %ebp
  800339:	89 e5                	mov    %esp,%ebp
  80033b:	53                   	push   %ebx
  80033c:	83 ec 14             	sub    $0x14,%esp
 * Panic is called on unresolvable fatal errors.
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
  80033f:	8d 5d 14             	lea    0x14(%ebp),%ebx
	va_list ap;

	va_start(ap, fmt);

	// Print the panic message
	if (argv0)
  800342:	a1 84 64 80 00       	mov    0x806484,%eax
  800347:	85 c0                	test   %eax,%eax
  800349:	74 10                	je     80035b <_panic+0x23>
		cprintf("%s: ", argv0);
  80034b:	89 44 24 04          	mov    %eax,0x4(%esp)
  80034f:	c7 04 24 6b 2b 80 00 	movl   $0x802b6b,(%esp)
  800356:	e8 a2 00 00 00       	call   8003fd <cprintf>
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  80035b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80035e:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800362:	8b 45 08             	mov    0x8(%ebp),%eax
  800365:	89 44 24 08          	mov    %eax,0x8(%esp)
  800369:	a1 1c 60 80 00       	mov    0x80601c,%eax
  80036e:	89 44 24 04          	mov    %eax,0x4(%esp)
  800372:	c7 04 24 70 2b 80 00 	movl   $0x802b70,(%esp)
  800379:	e8 7f 00 00 00       	call   8003fd <cprintf>
	vcprintf(fmt, ap);
  80037e:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  800382:	8b 45 10             	mov    0x10(%ebp),%eax
  800385:	89 04 24             	mov    %eax,(%esp)
  800388:	e8 0f 00 00 00       	call   80039c <vcprintf>
	cprintf("\n");
  80038d:	c7 04 24 46 2b 80 00 	movl   $0x802b46,(%esp)
  800394:	e8 64 00 00 00       	call   8003fd <cprintf>

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  800399:	cc                   	int3   
  80039a:	eb fd                	jmp    800399 <_panic+0x61>

0080039c <vcprintf>:
	b->cnt++;
}

int
vcprintf(const char *fmt, va_list ap)
{
  80039c:	55                   	push   %ebp
  80039d:	89 e5                	mov    %esp,%ebp
  80039f:	81 ec 28 01 00 00    	sub    $0x128,%esp
	struct printbuf b;

	b.idx = 0;
  8003a5:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8003ac:	00 00 00 
	b.cnt = 0;
  8003af:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8003b6:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  8003b9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8003bc:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8003c0:	8b 45 08             	mov    0x8(%ebp),%eax
  8003c3:	89 44 24 08          	mov    %eax,0x8(%esp)
  8003c7:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8003cd:	89 44 24 04          	mov    %eax,0x4(%esp)
  8003d1:	c7 04 24 17 04 80 00 	movl   $0x800417,(%esp)
  8003d8:	e8 d0 01 00 00       	call   8005ad <vprintfmt>
	sys_cputs(b.buf, b.idx);
  8003dd:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
  8003e3:	89 44 24 04          	mov    %eax,0x4(%esp)
  8003e7:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  8003ed:	89 04 24             	mov    %eax,(%esp)
  8003f0:	e8 ab 0b 00 00       	call   800fa0 <sys_cputs>

	return b.cnt;
}
  8003f5:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  8003fb:	c9                   	leave  
  8003fc:	c3                   	ret    

008003fd <cprintf>:

int
cprintf(const char *fmt, ...)
{
  8003fd:	55                   	push   %ebp
  8003fe:	89 e5                	mov    %esp,%ebp
  800400:	83 ec 18             	sub    $0x18,%esp

	return b.cnt;
}

int
cprintf(const char *fmt, ...)
  800403:	8d 45 0c             	lea    0xc(%ebp),%eax
{
	va_list ap;
	int cnt;

	va_start(ap, fmt);
	cnt = vcprintf(fmt, ap);
  800406:	89 44 24 04          	mov    %eax,0x4(%esp)
  80040a:	8b 45 08             	mov    0x8(%ebp),%eax
  80040d:	89 04 24             	mov    %eax,(%esp)
  800410:	e8 87 ff ff ff       	call   80039c <vcprintf>
	va_end(ap);

	return cnt;
}
  800415:	c9                   	leave  
  800416:	c3                   	ret    

00800417 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  800417:	55                   	push   %ebp
  800418:	89 e5                	mov    %esp,%ebp
  80041a:	53                   	push   %ebx
  80041b:	83 ec 14             	sub    $0x14,%esp
  80041e:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  800421:	8b 03                	mov    (%ebx),%eax
  800423:	8b 55 08             	mov    0x8(%ebp),%edx
  800426:	88 54 03 08          	mov    %dl,0x8(%ebx,%eax,1)
  80042a:	83 c0 01             	add    $0x1,%eax
  80042d:	89 03                	mov    %eax,(%ebx)
	if (b->idx == 256-1) {
  80042f:	3d ff 00 00 00       	cmp    $0xff,%eax
  800434:	75 19                	jne    80044f <putch+0x38>
		sys_cputs(b->buf, b->idx);
  800436:	c7 44 24 04 ff 00 00 	movl   $0xff,0x4(%esp)
  80043d:	00 
  80043e:	8d 43 08             	lea    0x8(%ebx),%eax
  800441:	89 04 24             	mov    %eax,(%esp)
  800444:	e8 57 0b 00 00       	call   800fa0 <sys_cputs>
		b->idx = 0;
  800449:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
	}
	b->cnt++;
  80044f:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  800453:	83 c4 14             	add    $0x14,%esp
  800456:	5b                   	pop    %ebx
  800457:	5d                   	pop    %ebp
  800458:	c3                   	ret    
  800459:	00 00                	add    %al,(%eax)
  80045b:	00 00                	add    %al,(%eax)
  80045d:	00 00                	add    %al,(%eax)
	...

00800460 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800460:	55                   	push   %ebp
  800461:	89 e5                	mov    %esp,%ebp
  800463:	57                   	push   %edi
  800464:	56                   	push   %esi
  800465:	53                   	push   %ebx
  800466:	83 ec 4c             	sub    $0x4c,%esp
  800469:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80046c:	89 d6                	mov    %edx,%esi
  80046e:	8b 45 08             	mov    0x8(%ebp),%eax
  800471:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800474:	8b 55 0c             	mov    0xc(%ebp),%edx
  800477:	89 55 e0             	mov    %edx,-0x20(%ebp)
  80047a:	8b 45 10             	mov    0x10(%ebp),%eax
  80047d:	8b 5d 14             	mov    0x14(%ebp),%ebx
  800480:	8b 7d 18             	mov    0x18(%ebp),%edi
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800483:	89 45 dc             	mov    %eax,-0x24(%ebp)
  800486:	b9 00 00 00 00       	mov    $0x0,%ecx
  80048b:	39 d1                	cmp    %edx,%ecx
  80048d:	72 15                	jb     8004a4 <printnum+0x44>
  80048f:	77 07                	ja     800498 <printnum+0x38>
  800491:	8b 55 d8             	mov    -0x28(%ebp),%edx
  800494:	39 d0                	cmp    %edx,%eax
  800496:	76 0c                	jbe    8004a4 <printnum+0x44>
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800498:	83 eb 01             	sub    $0x1,%ebx
  80049b:	85 db                	test   %ebx,%ebx
  80049d:	8d 76 00             	lea    0x0(%esi),%esi
  8004a0:	7f 61                	jg     800503 <printnum+0xa3>
  8004a2:	eb 70                	jmp    800514 <printnum+0xb4>
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8004a4:	89 7c 24 10          	mov    %edi,0x10(%esp)
  8004a8:	83 eb 01             	sub    $0x1,%ebx
  8004ab:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  8004af:	89 44 24 08          	mov    %eax,0x8(%esp)
  8004b3:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  8004b7:	8b 5c 24 0c          	mov    0xc(%esp),%ebx
  8004bb:	89 4d d0             	mov    %ecx,-0x30(%ebp)
  8004be:	89 5d d4             	mov    %ebx,-0x2c(%ebp)
  8004c1:	8b 5d dc             	mov    -0x24(%ebp),%ebx
  8004c4:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8004c8:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  8004cf:	00 
  8004d0:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8004d3:	89 04 24             	mov    %eax,(%esp)
  8004d6:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8004d9:	89 54 24 04          	mov    %edx,0x4(%esp)
  8004dd:	e8 8e 23 00 00       	call   802870 <__udivdi3>
  8004e2:	8b 4d d0             	mov    -0x30(%ebp),%ecx
  8004e5:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
  8004e8:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8004ec:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  8004f0:	89 04 24             	mov    %eax,(%esp)
  8004f3:	89 54 24 04          	mov    %edx,0x4(%esp)
  8004f7:	89 f2                	mov    %esi,%edx
  8004f9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8004fc:	e8 5f ff ff ff       	call   800460 <printnum>
  800501:	eb 11                	jmp    800514 <printnum+0xb4>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800503:	89 74 24 04          	mov    %esi,0x4(%esp)
  800507:	89 3c 24             	mov    %edi,(%esp)
  80050a:	ff 55 e4             	call   *-0x1c(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  80050d:	83 eb 01             	sub    $0x1,%ebx
  800510:	85 db                	test   %ebx,%ebx
  800512:	7f ef                	jg     800503 <printnum+0xa3>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800514:	89 74 24 04          	mov    %esi,0x4(%esp)
  800518:	8b 74 24 04          	mov    0x4(%esp),%esi
  80051c:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80051f:	89 44 24 08          	mov    %eax,0x8(%esp)
  800523:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  80052a:	00 
  80052b:	8b 55 d8             	mov    -0x28(%ebp),%edx
  80052e:	89 14 24             	mov    %edx,(%esp)
  800531:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  800534:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  800538:	e8 63 24 00 00       	call   8029a0 <__umoddi3>
  80053d:	89 74 24 04          	mov    %esi,0x4(%esp)
  800541:	0f be 80 8c 2b 80 00 	movsbl 0x802b8c(%eax),%eax
  800548:	89 04 24             	mov    %eax,(%esp)
  80054b:	ff 55 e4             	call   *-0x1c(%ebp)
}
  80054e:	83 c4 4c             	add    $0x4c,%esp
  800551:	5b                   	pop    %ebx
  800552:	5e                   	pop    %esi
  800553:	5f                   	pop    %edi
  800554:	5d                   	pop    %ebp
  800555:	c3                   	ret    

00800556 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800556:	55                   	push   %ebp
  800557:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800559:	83 fa 01             	cmp    $0x1,%edx
  80055c:	7e 0e                	jle    80056c <getuint+0x16>
		return va_arg(*ap, unsigned long long);
  80055e:	8b 10                	mov    (%eax),%edx
  800560:	8d 4a 08             	lea    0x8(%edx),%ecx
  800563:	89 08                	mov    %ecx,(%eax)
  800565:	8b 02                	mov    (%edx),%eax
  800567:	8b 52 04             	mov    0x4(%edx),%edx
  80056a:	eb 22                	jmp    80058e <getuint+0x38>
	else if (lflag)
  80056c:	85 d2                	test   %edx,%edx
  80056e:	74 10                	je     800580 <getuint+0x2a>
		return va_arg(*ap, unsigned long);
  800570:	8b 10                	mov    (%eax),%edx
  800572:	8d 4a 04             	lea    0x4(%edx),%ecx
  800575:	89 08                	mov    %ecx,(%eax)
  800577:	8b 02                	mov    (%edx),%eax
  800579:	ba 00 00 00 00       	mov    $0x0,%edx
  80057e:	eb 0e                	jmp    80058e <getuint+0x38>
	else
		return va_arg(*ap, unsigned int);
  800580:	8b 10                	mov    (%eax),%edx
  800582:	8d 4a 04             	lea    0x4(%edx),%ecx
  800585:	89 08                	mov    %ecx,(%eax)
  800587:	8b 02                	mov    (%edx),%eax
  800589:	ba 00 00 00 00       	mov    $0x0,%edx
}
  80058e:	5d                   	pop    %ebp
  80058f:	c3                   	ret    

00800590 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800590:	55                   	push   %ebp
  800591:	89 e5                	mov    %esp,%ebp
  800593:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  800596:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  80059a:	8b 10                	mov    (%eax),%edx
  80059c:	3b 50 04             	cmp    0x4(%eax),%edx
  80059f:	73 0a                	jae    8005ab <sprintputch+0x1b>
		*b->buf++ = ch;
  8005a1:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8005a4:	88 0a                	mov    %cl,(%edx)
  8005a6:	83 c2 01             	add    $0x1,%edx
  8005a9:	89 10                	mov    %edx,(%eax)
}
  8005ab:	5d                   	pop    %ebp
  8005ac:	c3                   	ret    

008005ad <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  8005ad:	55                   	push   %ebp
  8005ae:	89 e5                	mov    %esp,%ebp
  8005b0:	57                   	push   %edi
  8005b1:	56                   	push   %esi
  8005b2:	53                   	push   %ebx
  8005b3:	83 ec 5c             	sub    $0x5c,%esp
  8005b6:	8b 7d 08             	mov    0x8(%ebp),%edi
  8005b9:	8b 75 0c             	mov    0xc(%ebp),%esi
  8005bc:	8b 5d 10             	mov    0x10(%ebp),%ebx
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  8005bf:	c7 45 c8 ff ff ff ff 	movl   $0xffffffff,-0x38(%ebp)
  8005c6:	eb 11                	jmp    8005d9 <vprintfmt+0x2c>
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
  8005c8:	85 c0                	test   %eax,%eax
  8005ca:	0f 84 ec 03 00 00    	je     8009bc <vprintfmt+0x40f>
				return;
			putch(ch, putdat);
  8005d0:	89 74 24 04          	mov    %esi,0x4(%esp)
  8005d4:	89 04 24             	mov    %eax,(%esp)
  8005d7:	ff d7                	call   *%edi
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8005d9:	0f b6 03             	movzbl (%ebx),%eax
  8005dc:	83 c3 01             	add    $0x1,%ebx
  8005df:	83 f8 25             	cmp    $0x25,%eax
  8005e2:	75 e4                	jne    8005c8 <vprintfmt+0x1b>
  8005e4:	c6 45 d4 20          	movb   $0x20,-0x2c(%ebp)
  8005e8:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
  8005ef:	c7 45 d0 ff ff ff ff 	movl   $0xffffffff,-0x30(%ebp)
  8005f6:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
  8005fd:	b9 00 00 00 00       	mov    $0x0,%ecx
  800602:	eb 06                	jmp    80060a <vprintfmt+0x5d>
  800604:	c6 45 d4 2d          	movb   $0x2d,-0x2c(%ebp)
  800608:	89 c3                	mov    %eax,%ebx
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80060a:	0f b6 13             	movzbl (%ebx),%edx
  80060d:	0f b6 c2             	movzbl %dl,%eax
  800610:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800613:	8d 43 01             	lea    0x1(%ebx),%eax
  800616:	83 ea 23             	sub    $0x23,%edx
  800619:	80 fa 55             	cmp    $0x55,%dl
  80061c:	0f 87 7d 03 00 00    	ja     80099f <vprintfmt+0x3f2>
  800622:	0f b6 d2             	movzbl %dl,%edx
  800625:	ff 24 95 c0 2c 80 00 	jmp    *0x802cc0(,%edx,4)
  80062c:	c6 45 d4 30          	movb   $0x30,-0x2c(%ebp)
  800630:	eb d6                	jmp    800608 <vprintfmt+0x5b>
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
				precision = precision * 10 + ch - '0';
  800632:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800635:	83 ea 30             	sub    $0x30,%edx
  800638:	89 55 d0             	mov    %edx,-0x30(%ebp)
				ch = *fmt;
  80063b:	0f be 10             	movsbl (%eax),%edx
				if (ch < '0' || ch > '9')
  80063e:	8d 5a d0             	lea    -0x30(%edx),%ebx
  800641:	83 fb 09             	cmp    $0x9,%ebx
  800644:	77 4c                	ja     800692 <vprintfmt+0xe5>
  800646:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  800649:	8b 4d d0             	mov    -0x30(%ebp),%ecx
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  80064c:	83 c0 01             	add    $0x1,%eax
				precision = precision * 10 + ch - '0';
  80064f:	8d 0c 89             	lea    (%ecx,%ecx,4),%ecx
  800652:	8d 4c 4a d0          	lea    -0x30(%edx,%ecx,2),%ecx
				ch = *fmt;
  800656:	0f be 10             	movsbl (%eax),%edx
				if (ch < '0' || ch > '9')
  800659:	8d 5a d0             	lea    -0x30(%edx),%ebx
  80065c:	83 fb 09             	cmp    $0x9,%ebx
  80065f:	76 eb                	jbe    80064c <vprintfmt+0x9f>
  800661:	89 4d d0             	mov    %ecx,-0x30(%ebp)
  800664:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  800667:	eb 29                	jmp    800692 <vprintfmt+0xe5>
					break;
			}
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800669:	8b 55 14             	mov    0x14(%ebp),%edx
  80066c:	8d 5a 04             	lea    0x4(%edx),%ebx
  80066f:	89 5d 14             	mov    %ebx,0x14(%ebp)
  800672:	8b 12                	mov    (%edx),%edx
  800674:	89 55 d0             	mov    %edx,-0x30(%ebp)
			goto process_precision;
  800677:	eb 19                	jmp    800692 <vprintfmt+0xe5>

		case '.':
			if (width < 0)
  800679:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80067c:	c1 fa 1f             	sar    $0x1f,%edx
  80067f:	f7 d2                	not    %edx
  800681:	21 55 e4             	and    %edx,-0x1c(%ebp)
  800684:	eb 82                	jmp    800608 <vprintfmt+0x5b>
  800686:	c7 45 d8 01 00 00 00 	movl   $0x1,-0x28(%ebp)
				width = 0;
			goto reswitch;

		case '#':
			altflag = 1;
			goto reswitch;
  80068d:	e9 76 ff ff ff       	jmp    800608 <vprintfmt+0x5b>

		process_precision:
			if (width < 0)
  800692:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800696:	0f 89 6c ff ff ff    	jns    800608 <vprintfmt+0x5b>
  80069c:	8b 55 d0             	mov    -0x30(%ebp),%edx
  80069f:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  8006a2:	8b 55 c8             	mov    -0x38(%ebp),%edx
  8006a5:	89 55 d0             	mov    %edx,-0x30(%ebp)
  8006a8:	e9 5b ff ff ff       	jmp    800608 <vprintfmt+0x5b>
				width = precision, precision = -1;
			goto reswitch;

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  8006ad:	83 c1 01             	add    $0x1,%ecx
			goto reswitch;
  8006b0:	e9 53 ff ff ff       	jmp    800608 <vprintfmt+0x5b>
  8006b5:	89 45 cc             	mov    %eax,-0x34(%ebp)

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  8006b8:	8b 45 14             	mov    0x14(%ebp),%eax
  8006bb:	8d 50 04             	lea    0x4(%eax),%edx
  8006be:	89 55 14             	mov    %edx,0x14(%ebp)
  8006c1:	89 74 24 04          	mov    %esi,0x4(%esp)
  8006c5:	8b 00                	mov    (%eax),%eax
  8006c7:	89 04 24             	mov    %eax,(%esp)
  8006ca:	ff d7                	call   *%edi
  8006cc:	8b 5d cc             	mov    -0x34(%ebp),%ebx
			break;
  8006cf:	e9 05 ff ff ff       	jmp    8005d9 <vprintfmt+0x2c>
  8006d4:	89 45 cc             	mov    %eax,-0x34(%ebp)

		// error message
		case 'e':
			err = va_arg(ap, int);
  8006d7:	8b 45 14             	mov    0x14(%ebp),%eax
  8006da:	8d 50 04             	lea    0x4(%eax),%edx
  8006dd:	89 55 14             	mov    %edx,0x14(%ebp)
  8006e0:	8b 00                	mov    (%eax),%eax
  8006e2:	89 c2                	mov    %eax,%edx
  8006e4:	c1 fa 1f             	sar    $0x1f,%edx
  8006e7:	31 d0                	xor    %edx,%eax
  8006e9:	29 d0                	sub    %edx,%eax
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  8006eb:	83 f8 0f             	cmp    $0xf,%eax
  8006ee:	7f 0b                	jg     8006fb <vprintfmt+0x14e>
  8006f0:	8b 14 85 20 2e 80 00 	mov    0x802e20(,%eax,4),%edx
  8006f7:	85 d2                	test   %edx,%edx
  8006f9:	75 20                	jne    80071b <vprintfmt+0x16e>
				printfmt(putch, putdat, "error %d", err);
  8006fb:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8006ff:	c7 44 24 08 9d 2b 80 	movl   $0x802b9d,0x8(%esp)
  800706:	00 
  800707:	89 74 24 04          	mov    %esi,0x4(%esp)
  80070b:	89 3c 24             	mov    %edi,(%esp)
  80070e:	e8 31 03 00 00       	call   800a44 <printfmt>
  800713:	8b 5d cc             	mov    -0x34(%ebp),%ebx
		// error message
		case 'e':
			err = va_arg(ap, int);
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800716:	e9 be fe ff ff       	jmp    8005d9 <vprintfmt+0x2c>
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  80071b:	89 54 24 0c          	mov    %edx,0xc(%esp)
  80071f:	c7 44 24 08 76 2f 80 	movl   $0x802f76,0x8(%esp)
  800726:	00 
  800727:	89 74 24 04          	mov    %esi,0x4(%esp)
  80072b:	89 3c 24             	mov    %edi,(%esp)
  80072e:	e8 11 03 00 00       	call   800a44 <printfmt>
  800733:	8b 5d cc             	mov    -0x34(%ebp),%ebx
  800736:	e9 9e fe ff ff       	jmp    8005d9 <vprintfmt+0x2c>
  80073b:	89 45 cc             	mov    %eax,-0x34(%ebp)
  80073e:	89 c3                	mov    %eax,%ebx
  800740:	8b 4d d0             	mov    -0x30(%ebp),%ecx
  800743:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800746:	89 45 c4             	mov    %eax,-0x3c(%ebp)
			break;

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800749:	8b 45 14             	mov    0x14(%ebp),%eax
  80074c:	8d 50 04             	lea    0x4(%eax),%edx
  80074f:	89 55 14             	mov    %edx,0x14(%ebp)
  800752:	8b 00                	mov    (%eax),%eax
  800754:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800757:	85 c0                	test   %eax,%eax
  800759:	75 07                	jne    800762 <vprintfmt+0x1b5>
  80075b:	c7 45 e0 a6 2b 80 00 	movl   $0x802ba6,-0x20(%ebp)
				p = "(null)";
			if (width > 0 && padc != '-')
  800762:	83 7d c4 00          	cmpl   $0x0,-0x3c(%ebp)
  800766:	7e 06                	jle    80076e <vprintfmt+0x1c1>
  800768:	80 7d d4 2d          	cmpb   $0x2d,-0x2c(%ebp)
  80076c:	75 13                	jne    800781 <vprintfmt+0x1d4>
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  80076e:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800771:	0f be 02             	movsbl (%edx),%eax
  800774:	85 c0                	test   %eax,%eax
  800776:	0f 85 99 00 00 00    	jne    800815 <vprintfmt+0x268>
  80077c:	e9 86 00 00 00       	jmp    800807 <vprintfmt+0x25a>
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800781:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  800785:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  800788:	89 0c 24             	mov    %ecx,(%esp)
  80078b:	e8 eb 03 00 00       	call   800b7b <strnlen>
  800790:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  800793:	29 c2                	sub    %eax,%edx
  800795:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  800798:	85 d2                	test   %edx,%edx
  80079a:	7e d2                	jle    80076e <vprintfmt+0x1c1>
					putch(padc, putdat);
  80079c:	0f be 4d d4          	movsbl -0x2c(%ebp),%ecx
  8007a0:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  8007a3:	89 5d c4             	mov    %ebx,-0x3c(%ebp)
  8007a6:	89 d3                	mov    %edx,%ebx
  8007a8:	89 74 24 04          	mov    %esi,0x4(%esp)
  8007ac:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8007af:	89 04 24             	mov    %eax,(%esp)
  8007b2:	ff d7                	call   *%edi
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  8007b4:	83 eb 01             	sub    $0x1,%ebx
  8007b7:	85 db                	test   %ebx,%ebx
  8007b9:	7f ed                	jg     8007a8 <vprintfmt+0x1fb>
  8007bb:	8b 5d c4             	mov    -0x3c(%ebp),%ebx
  8007be:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  8007c5:	eb a7                	jmp    80076e <vprintfmt+0x1c1>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
  8007c7:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  8007cb:	74 18                	je     8007e5 <vprintfmt+0x238>
  8007cd:	8d 50 e0             	lea    -0x20(%eax),%edx
  8007d0:	83 fa 5e             	cmp    $0x5e,%edx
  8007d3:	76 10                	jbe    8007e5 <vprintfmt+0x238>
					putch('?', putdat);
  8007d5:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8007d9:	c7 04 24 3f 00 00 00 	movl   $0x3f,(%esp)
  8007e0:	ff 55 e0             	call   *-0x20(%ebp)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
  8007e3:	eb 0a                	jmp    8007ef <vprintfmt+0x242>
					putch('?', putdat);
				else
					putch(ch, putdat);
  8007e5:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8007e9:	89 04 24             	mov    %eax,(%esp)
  8007ec:	ff 55 e0             	call   *-0x20(%ebp)
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8007ef:	83 6d e4 01          	subl   $0x1,-0x1c(%ebp)
  8007f3:	0f be 03             	movsbl (%ebx),%eax
  8007f6:	85 c0                	test   %eax,%eax
  8007f8:	74 05                	je     8007ff <vprintfmt+0x252>
  8007fa:	83 c3 01             	add    $0x1,%ebx
  8007fd:	eb 29                	jmp    800828 <vprintfmt+0x27b>
  8007ff:	89 fe                	mov    %edi,%esi
  800801:	8b 7d e0             	mov    -0x20(%ebp),%edi
  800804:	8b 5d d0             	mov    -0x30(%ebp),%ebx
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800807:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80080b:	7f 2e                	jg     80083b <vprintfmt+0x28e>
  80080d:	8b 5d cc             	mov    -0x34(%ebp),%ebx
  800810:	e9 c4 fd ff ff       	jmp    8005d9 <vprintfmt+0x2c>
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800815:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800818:	83 c2 01             	add    $0x1,%edx
  80081b:	89 7d e0             	mov    %edi,-0x20(%ebp)
  80081e:	89 f7                	mov    %esi,%edi
  800820:	8b 75 d0             	mov    -0x30(%ebp),%esi
  800823:	89 5d d0             	mov    %ebx,-0x30(%ebp)
  800826:	89 d3                	mov    %edx,%ebx
  800828:	85 f6                	test   %esi,%esi
  80082a:	78 9b                	js     8007c7 <vprintfmt+0x21a>
  80082c:	83 ee 01             	sub    $0x1,%esi
  80082f:	79 96                	jns    8007c7 <vprintfmt+0x21a>
  800831:	89 fe                	mov    %edi,%esi
  800833:	8b 7d e0             	mov    -0x20(%ebp),%edi
  800836:	8b 5d d0             	mov    -0x30(%ebp),%ebx
  800839:	eb cc                	jmp    800807 <vprintfmt+0x25a>
  80083b:	89 5d d8             	mov    %ebx,-0x28(%ebp)
  80083e:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
				putch(' ', putdat);
  800841:	89 74 24 04          	mov    %esi,0x4(%esp)
  800845:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  80084c:	ff d7                	call   *%edi
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  80084e:	83 eb 01             	sub    $0x1,%ebx
  800851:	85 db                	test   %ebx,%ebx
  800853:	7f ec                	jg     800841 <vprintfmt+0x294>
  800855:	8b 5d d8             	mov    -0x28(%ebp),%ebx
  800858:	e9 7c fd ff ff       	jmp    8005d9 <vprintfmt+0x2c>
  80085d:	89 45 cc             	mov    %eax,-0x34(%ebp)
// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
	if (lflag >= 2)
  800860:	83 f9 01             	cmp    $0x1,%ecx
  800863:	7e 16                	jle    80087b <vprintfmt+0x2ce>
		return va_arg(*ap, long long);
  800865:	8b 45 14             	mov    0x14(%ebp),%eax
  800868:	8d 50 08             	lea    0x8(%eax),%edx
  80086b:	89 55 14             	mov    %edx,0x14(%ebp)
  80086e:	8b 10                	mov    (%eax),%edx
  800870:	8b 48 04             	mov    0x4(%eax),%ecx
  800873:	89 55 d8             	mov    %edx,-0x28(%ebp)
  800876:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  800879:	eb 32                	jmp    8008ad <vprintfmt+0x300>
	else if (lflag)
  80087b:	85 c9                	test   %ecx,%ecx
  80087d:	74 18                	je     800897 <vprintfmt+0x2ea>
		return va_arg(*ap, long);
  80087f:	8b 45 14             	mov    0x14(%ebp),%eax
  800882:	8d 50 04             	lea    0x4(%eax),%edx
  800885:	89 55 14             	mov    %edx,0x14(%ebp)
  800888:	8b 00                	mov    (%eax),%eax
  80088a:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80088d:	89 c1                	mov    %eax,%ecx
  80088f:	c1 f9 1f             	sar    $0x1f,%ecx
  800892:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  800895:	eb 16                	jmp    8008ad <vprintfmt+0x300>
	else
		return va_arg(*ap, int);
  800897:	8b 45 14             	mov    0x14(%ebp),%eax
  80089a:	8d 50 04             	lea    0x4(%eax),%edx
  80089d:	89 55 14             	mov    %edx,0x14(%ebp)
  8008a0:	8b 00                	mov    (%eax),%eax
  8008a2:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8008a5:	89 c2                	mov    %eax,%edx
  8008a7:	c1 fa 1f             	sar    $0x1f,%edx
  8008aa:	89 55 dc             	mov    %edx,-0x24(%ebp)
				putch(' ', putdat);
			break;

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  8008ad:	8b 4d d8             	mov    -0x28(%ebp),%ecx
  8008b0:	8b 5d dc             	mov    -0x24(%ebp),%ebx
  8008b3:	b8 0a 00 00 00       	mov    $0xa,%eax
			if ((long long) num < 0) {
  8008b8:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8008bc:	0f 89 9b 00 00 00    	jns    80095d <vprintfmt+0x3b0>
				putch('-', putdat);
  8008c2:	89 74 24 04          	mov    %esi,0x4(%esp)
  8008c6:	c7 04 24 2d 00 00 00 	movl   $0x2d,(%esp)
  8008cd:	ff d7                	call   *%edi
				num = -(long long) num;
  8008cf:	8b 4d d8             	mov    -0x28(%ebp),%ecx
  8008d2:	8b 5d dc             	mov    -0x24(%ebp),%ebx
  8008d5:	f7 d9                	neg    %ecx
  8008d7:	83 d3 00             	adc    $0x0,%ebx
  8008da:	f7 db                	neg    %ebx
  8008dc:	b8 0a 00 00 00       	mov    $0xa,%eax
  8008e1:	eb 7a                	jmp    80095d <vprintfmt+0x3b0>
  8008e3:	89 45 cc             	mov    %eax,-0x34(%ebp)
			base = 10;
			goto number;

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  8008e6:	89 ca                	mov    %ecx,%edx
  8008e8:	8d 45 14             	lea    0x14(%ebp),%eax
  8008eb:	e8 66 fc ff ff       	call   800556 <getuint>
  8008f0:	89 c1                	mov    %eax,%ecx
  8008f2:	89 d3                	mov    %edx,%ebx
  8008f4:	b8 0a 00 00 00       	mov    $0xa,%eax
			base = 10;
			goto number;
  8008f9:	eb 62                	jmp    80095d <vprintfmt+0x3b0>
  8008fb:	89 45 cc             	mov    %eax,-0x34(%ebp)
		case 'o':
			// Replace this with your code.
			// putch('X', putdat);
			// putch('X', putdat);
			// putch('X', putdat);
			num = getuint(&ap, lflag);
  8008fe:	89 ca                	mov    %ecx,%edx
  800900:	8d 45 14             	lea    0x14(%ebp),%eax
  800903:	e8 4e fc ff ff       	call   800556 <getuint>
  800908:	89 c1                	mov    %eax,%ecx
  80090a:	89 d3                	mov    %edx,%ebx
  80090c:	b8 08 00 00 00       	mov    $0x8,%eax
			base = 8;
			goto number;
  800911:	eb 4a                	jmp    80095d <vprintfmt+0x3b0>
  800913:	89 45 cc             	mov    %eax,-0x34(%ebp)
			break;

		// pointer
		case 'p':
			putch('0', putdat);
  800916:	89 74 24 04          	mov    %esi,0x4(%esp)
  80091a:	c7 04 24 30 00 00 00 	movl   $0x30,(%esp)
  800921:	ff d7                	call   *%edi
			putch('x', putdat);
  800923:	89 74 24 04          	mov    %esi,0x4(%esp)
  800927:	c7 04 24 78 00 00 00 	movl   $0x78,(%esp)
  80092e:	ff d7                	call   *%edi
			num = (unsigned long long)
  800930:	8b 45 14             	mov    0x14(%ebp),%eax
  800933:	8d 50 04             	lea    0x4(%eax),%edx
  800936:	89 55 14             	mov    %edx,0x14(%ebp)
  800939:	8b 08                	mov    (%eax),%ecx
  80093b:	bb 00 00 00 00       	mov    $0x0,%ebx
  800940:	b8 10 00 00 00       	mov    $0x10,%eax
				(uintptr_t) va_arg(ap, void *);
			base = 16;
			goto number;
  800945:	eb 16                	jmp    80095d <vprintfmt+0x3b0>
  800947:	89 45 cc             	mov    %eax,-0x34(%ebp)

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  80094a:	89 ca                	mov    %ecx,%edx
  80094c:	8d 45 14             	lea    0x14(%ebp),%eax
  80094f:	e8 02 fc ff ff       	call   800556 <getuint>
  800954:	89 c1                	mov    %eax,%ecx
  800956:	89 d3                	mov    %edx,%ebx
  800958:	b8 10 00 00 00       	mov    $0x10,%eax
			base = 16;
		number:
			printnum(putch, putdat, num, base, width, padc);
  80095d:	0f be 55 d4          	movsbl -0x2c(%ebp),%edx
  800961:	89 54 24 10          	mov    %edx,0x10(%esp)
  800965:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  800968:	89 54 24 0c          	mov    %edx,0xc(%esp)
  80096c:	89 44 24 08          	mov    %eax,0x8(%esp)
  800970:	89 0c 24             	mov    %ecx,(%esp)
  800973:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  800977:	89 f2                	mov    %esi,%edx
  800979:	89 f8                	mov    %edi,%eax
  80097b:	e8 e0 fa ff ff       	call   800460 <printnum>
  800980:	8b 5d cc             	mov    -0x34(%ebp),%ebx
			break;
  800983:	e9 51 fc ff ff       	jmp    8005d9 <vprintfmt+0x2c>
  800988:	89 45 cc             	mov    %eax,-0x34(%ebp)
  80098b:	8b 55 e0             	mov    -0x20(%ebp),%edx

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  80098e:	89 74 24 04          	mov    %esi,0x4(%esp)
  800992:	89 14 24             	mov    %edx,(%esp)
  800995:	ff d7                	call   *%edi
  800997:	8b 5d cc             	mov    -0x34(%ebp),%ebx
			break;
  80099a:	e9 3a fc ff ff       	jmp    8005d9 <vprintfmt+0x2c>
			
		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  80099f:	89 74 24 04          	mov    %esi,0x4(%esp)
  8009a3:	c7 04 24 25 00 00 00 	movl   $0x25,(%esp)
  8009aa:	ff d7                	call   *%edi
			for (fmt--; fmt[-1] != '%'; fmt--)
  8009ac:	8d 43 ff             	lea    -0x1(%ebx),%eax
  8009af:	80 38 25             	cmpb   $0x25,(%eax)
  8009b2:	0f 84 21 fc ff ff    	je     8005d9 <vprintfmt+0x2c>
  8009b8:	89 c3                	mov    %eax,%ebx
  8009ba:	eb f0                	jmp    8009ac <vprintfmt+0x3ff>
				/* do nothing */;
			break;
		}
	}
}
  8009bc:	83 c4 5c             	add    $0x5c,%esp
  8009bf:	5b                   	pop    %ebx
  8009c0:	5e                   	pop    %esi
  8009c1:	5f                   	pop    %edi
  8009c2:	5d                   	pop    %ebp
  8009c3:	c3                   	ret    

008009c4 <vsnprintf>:
		*b->buf++ = ch;
}

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  8009c4:	55                   	push   %ebp
  8009c5:	89 e5                	mov    %esp,%ebp
  8009c7:	83 ec 28             	sub    $0x28,%esp
  8009ca:	8b 45 08             	mov    0x8(%ebp),%eax
  8009cd:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};

	if (buf == NULL || n < 1)
  8009d0:	85 c0                	test   %eax,%eax
  8009d2:	74 04                	je     8009d8 <vsnprintf+0x14>
  8009d4:	85 d2                	test   %edx,%edx
  8009d6:	7f 07                	jg     8009df <vsnprintf+0x1b>
  8009d8:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8009dd:	eb 3b                	jmp    800a1a <vsnprintf+0x56>
}

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
	struct sprintbuf b = {buf, buf+n-1, 0};
  8009df:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8009e2:	8d 44 10 ff          	lea    -0x1(%eax,%edx,1),%eax
  8009e6:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8009e9:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  8009f0:	8b 45 14             	mov    0x14(%ebp),%eax
  8009f3:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8009f7:	8b 45 10             	mov    0x10(%ebp),%eax
  8009fa:	89 44 24 08          	mov    %eax,0x8(%esp)
  8009fe:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800a01:	89 44 24 04          	mov    %eax,0x4(%esp)
  800a05:	c7 04 24 90 05 80 00 	movl   $0x800590,(%esp)
  800a0c:	e8 9c fb ff ff       	call   8005ad <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  800a11:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800a14:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800a17:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800a1a:	c9                   	leave  
  800a1b:	c3                   	ret    

00800a1c <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800a1c:	55                   	push   %ebp
  800a1d:	89 e5                	mov    %esp,%ebp
  800a1f:	83 ec 18             	sub    $0x18,%esp

	return b.cnt;
}

int
snprintf(char *buf, int n, const char *fmt, ...)
  800a22:	8d 45 14             	lea    0x14(%ebp),%eax
{
	va_list ap;
	int rc;

	va_start(ap, fmt);
	rc = vsnprintf(buf, n, fmt, ap);
  800a25:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800a29:	8b 45 10             	mov    0x10(%ebp),%eax
  800a2c:	89 44 24 08          	mov    %eax,0x8(%esp)
  800a30:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a33:	89 44 24 04          	mov    %eax,0x4(%esp)
  800a37:	8b 45 08             	mov    0x8(%ebp),%eax
  800a3a:	89 04 24             	mov    %eax,(%esp)
  800a3d:	e8 82 ff ff ff       	call   8009c4 <vsnprintf>
	va_end(ap);

	return rc;
}
  800a42:	c9                   	leave  
  800a43:	c3                   	ret    

00800a44 <printfmt>:
	}
}

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800a44:	55                   	push   %ebp
  800a45:	89 e5                	mov    %esp,%ebp
  800a47:	83 ec 18             	sub    $0x18,%esp
		}
	}
}

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
  800a4a:	8d 45 14             	lea    0x14(%ebp),%eax
{
	va_list ap;

	va_start(ap, fmt);
	vprintfmt(putch, putdat, fmt, ap);
  800a4d:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800a51:	8b 45 10             	mov    0x10(%ebp),%eax
  800a54:	89 44 24 08          	mov    %eax,0x8(%esp)
  800a58:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a5b:	89 44 24 04          	mov    %eax,0x4(%esp)
  800a5f:	8b 45 08             	mov    0x8(%ebp),%eax
  800a62:	89 04 24             	mov    %eax,(%esp)
  800a65:	e8 43 fb ff ff       	call   8005ad <vprintfmt>
	va_end(ap);
}
  800a6a:	c9                   	leave  
  800a6b:	c3                   	ret    
  800a6c:	00 00                	add    %al,(%eax)
	...

00800a70 <readline>:
#define BUFLEN 1024
static char buf[BUFLEN];

char *
readline(const char *prompt)
{
  800a70:	55                   	push   %ebp
  800a71:	89 e5                	mov    %esp,%ebp
  800a73:	57                   	push   %edi
  800a74:	56                   	push   %esi
  800a75:	53                   	push   %ebx
  800a76:	83 ec 1c             	sub    $0x1c,%esp
  800a79:	8b 45 08             	mov    0x8(%ebp),%eax

#if JOS_KERNEL
	if (prompt != NULL)
		cprintf("%s", prompt);
#else
	if (prompt != NULL)
  800a7c:	85 c0                	test   %eax,%eax
  800a7e:	74 18                	je     800a98 <readline+0x28>
		fprintf(1, "%s", prompt);
  800a80:	89 44 24 08          	mov    %eax,0x8(%esp)
  800a84:	c7 44 24 04 76 2f 80 	movl   $0x802f76,0x4(%esp)
  800a8b:	00 
  800a8c:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  800a93:	e8 9d 13 00 00       	call   801e35 <fprintf>
#endif

	i = 0;
	echoing = iscons(0);
  800a98:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  800a9f:	e8 c2 f7 ff ff       	call   800266 <iscons>
  800aa4:	89 c7                	mov    %eax,%edi
  800aa6:	be 00 00 00 00       	mov    $0x0,%esi
	while (1) {
		c = getchar();
  800aab:	e8 e5 f7 ff ff       	call   800295 <getchar>
  800ab0:	89 c3                	mov    %eax,%ebx
		if (c < 0) {
  800ab2:	85 c0                	test   %eax,%eax
  800ab4:	79 25                	jns    800adb <readline+0x6b>
			if (c != -E_EOF)
  800ab6:	b8 00 00 00 00       	mov    $0x0,%eax
  800abb:	83 fb f8             	cmp    $0xfffffff8,%ebx
  800abe:	0f 84 8f 00 00 00    	je     800b53 <readline+0xe3>
				cprintf("read error: %e\n", c);
  800ac4:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  800ac8:	c7 04 24 7f 2e 80 00 	movl   $0x802e7f,(%esp)
  800acf:	e8 29 f9 ff ff       	call   8003fd <cprintf>
  800ad4:	b8 00 00 00 00       	mov    $0x0,%eax
  800ad9:	eb 78                	jmp    800b53 <readline+0xe3>
			return NULL;
		} else if ((c == '\b' || c == '\x7f') && i > 0) {
  800adb:	83 f8 08             	cmp    $0x8,%eax
  800ade:	74 05                	je     800ae5 <readline+0x75>
  800ae0:	83 f8 7f             	cmp    $0x7f,%eax
  800ae3:	75 1e                	jne    800b03 <readline+0x93>
  800ae5:	85 f6                	test   %esi,%esi
  800ae7:	7e 1a                	jle    800b03 <readline+0x93>
			if (echoing)
  800ae9:	85 ff                	test   %edi,%edi
  800aeb:	90                   	nop
  800aec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  800af0:	74 0c                	je     800afe <readline+0x8e>
				cputchar('\b');
  800af2:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
  800af9:	e8 b4 f6 ff ff       	call   8001b2 <cputchar>
			i--;
  800afe:	83 ee 01             	sub    $0x1,%esi
		c = getchar();
		if (c < 0) {
			if (c != -E_EOF)
				cprintf("read error: %e\n", c);
			return NULL;
		} else if ((c == '\b' || c == '\x7f') && i > 0) {
  800b01:	eb a8                	jmp    800aab <readline+0x3b>
			if (echoing)
				cputchar('\b');
			i--;
		} else if (c >= ' ' && i < BUFLEN-1) {
  800b03:	83 fb 1f             	cmp    $0x1f,%ebx
  800b06:	7e 21                	jle    800b29 <readline+0xb9>
  800b08:	81 fe fe 03 00 00    	cmp    $0x3fe,%esi
  800b0e:	66 90                	xchg   %ax,%ax
  800b10:	7f 17                	jg     800b29 <readline+0xb9>
			if (echoing)
  800b12:	85 ff                	test   %edi,%edi
  800b14:	74 08                	je     800b1e <readline+0xae>
				cputchar(c);
  800b16:	89 1c 24             	mov    %ebx,(%esp)
  800b19:	e8 94 f6 ff ff       	call   8001b2 <cputchar>
			buf[i++] = c;
  800b1e:	88 9e 80 60 80 00    	mov    %bl,0x806080(%esi)
  800b24:	83 c6 01             	add    $0x1,%esi
  800b27:	eb 82                	jmp    800aab <readline+0x3b>
		} else if (c == '\n' || c == '\r') {
  800b29:	83 fb 0a             	cmp    $0xa,%ebx
  800b2c:	74 09                	je     800b37 <readline+0xc7>
  800b2e:	83 fb 0d             	cmp    $0xd,%ebx
  800b31:	0f 85 74 ff ff ff    	jne    800aab <readline+0x3b>
			if (echoing)
  800b37:	85 ff                	test   %edi,%edi
  800b39:	74 0c                	je     800b47 <readline+0xd7>
				cputchar('\n');
  800b3b:	c7 04 24 0a 00 00 00 	movl   $0xa,(%esp)
  800b42:	e8 6b f6 ff ff       	call   8001b2 <cputchar>
			buf[i] = 0;
  800b47:	c6 86 80 60 80 00 00 	movb   $0x0,0x806080(%esi)
  800b4e:	b8 80 60 80 00       	mov    $0x806080,%eax
			return buf;
		}
	}
}
  800b53:	83 c4 1c             	add    $0x1c,%esp
  800b56:	5b                   	pop    %ebx
  800b57:	5e                   	pop    %esi
  800b58:	5f                   	pop    %edi
  800b59:	5d                   	pop    %ebp
  800b5a:	c3                   	ret    
  800b5b:	00 00                	add    %al,(%eax)
  800b5d:	00 00                	add    %al,(%eax)
	...

00800b60 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800b60:	55                   	push   %ebp
  800b61:	89 e5                	mov    %esp,%ebp
  800b63:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  800b66:	b8 00 00 00 00       	mov    $0x0,%eax
  800b6b:	80 3a 00             	cmpb   $0x0,(%edx)
  800b6e:	74 09                	je     800b79 <strlen+0x19>
		n++;
  800b70:	83 c0 01             	add    $0x1,%eax
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800b73:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  800b77:	75 f7                	jne    800b70 <strlen+0x10>
		n++;
	return n;
}
  800b79:	5d                   	pop    %ebp
  800b7a:	c3                   	ret    

00800b7b <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800b7b:	55                   	push   %ebp
  800b7c:	89 e5                	mov    %esp,%ebp
  800b7e:	53                   	push   %ebx
  800b7f:	8b 5d 08             	mov    0x8(%ebp),%ebx
  800b82:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800b85:	85 c9                	test   %ecx,%ecx
  800b87:	74 19                	je     800ba2 <strnlen+0x27>
  800b89:	80 3b 00             	cmpb   $0x0,(%ebx)
  800b8c:	74 14                	je     800ba2 <strnlen+0x27>
  800b8e:	b8 00 00 00 00       	mov    $0x0,%eax
		n++;
  800b93:	83 c0 01             	add    $0x1,%eax
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800b96:	39 c8                	cmp    %ecx,%eax
  800b98:	74 0d                	je     800ba7 <strnlen+0x2c>
  800b9a:	80 3c 03 00          	cmpb   $0x0,(%ebx,%eax,1)
  800b9e:	75 f3                	jne    800b93 <strnlen+0x18>
  800ba0:	eb 05                	jmp    800ba7 <strnlen+0x2c>
  800ba2:	b8 00 00 00 00       	mov    $0x0,%eax
		n++;
	return n;
}
  800ba7:	5b                   	pop    %ebx
  800ba8:	5d                   	pop    %ebp
  800ba9:	c3                   	ret    

00800baa <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800baa:	55                   	push   %ebp
  800bab:	89 e5                	mov    %esp,%ebp
  800bad:	53                   	push   %ebx
  800bae:	8b 45 08             	mov    0x8(%ebp),%eax
  800bb1:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800bb4:	ba 00 00 00 00       	mov    $0x0,%edx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  800bb9:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
  800bbd:	88 0c 10             	mov    %cl,(%eax,%edx,1)
  800bc0:	83 c2 01             	add    $0x1,%edx
  800bc3:	84 c9                	test   %cl,%cl
  800bc5:	75 f2                	jne    800bb9 <strcpy+0xf>
		/* do nothing */;
	return ret;
}
  800bc7:	5b                   	pop    %ebx
  800bc8:	5d                   	pop    %ebp
  800bc9:	c3                   	ret    

00800bca <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800bca:	55                   	push   %ebp
  800bcb:	89 e5                	mov    %esp,%ebp
  800bcd:	56                   	push   %esi
  800bce:	53                   	push   %ebx
  800bcf:	8b 45 08             	mov    0x8(%ebp),%eax
  800bd2:	8b 55 0c             	mov    0xc(%ebp),%edx
  800bd5:	8b 75 10             	mov    0x10(%ebp),%esi
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800bd8:	85 f6                	test   %esi,%esi
  800bda:	74 18                	je     800bf4 <strncpy+0x2a>
  800bdc:	b9 00 00 00 00       	mov    $0x0,%ecx
		*dst++ = *src;
  800be1:	0f b6 1a             	movzbl (%edx),%ebx
  800be4:	88 1c 08             	mov    %bl,(%eax,%ecx,1)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  800be7:	80 3a 01             	cmpb   $0x1,(%edx)
  800bea:	83 da ff             	sbb    $0xffffffff,%edx
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800bed:	83 c1 01             	add    $0x1,%ecx
  800bf0:	39 ce                	cmp    %ecx,%esi
  800bf2:	77 ed                	ja     800be1 <strncpy+0x17>
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
}
  800bf4:	5b                   	pop    %ebx
  800bf5:	5e                   	pop    %esi
  800bf6:	5d                   	pop    %ebp
  800bf7:	c3                   	ret    

00800bf8 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800bf8:	55                   	push   %ebp
  800bf9:	89 e5                	mov    %esp,%ebp
  800bfb:	56                   	push   %esi
  800bfc:	53                   	push   %ebx
  800bfd:	8b 75 08             	mov    0x8(%ebp),%esi
  800c00:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c03:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  800c06:	89 f0                	mov    %esi,%eax
  800c08:	85 c9                	test   %ecx,%ecx
  800c0a:	74 27                	je     800c33 <strlcpy+0x3b>
		while (--size > 0 && *src != '\0')
  800c0c:	83 e9 01             	sub    $0x1,%ecx
  800c0f:	74 1d                	je     800c2e <strlcpy+0x36>
  800c11:	0f b6 1a             	movzbl (%edx),%ebx
  800c14:	84 db                	test   %bl,%bl
  800c16:	74 16                	je     800c2e <strlcpy+0x36>
			*dst++ = *src++;
  800c18:	88 18                	mov    %bl,(%eax)
  800c1a:	83 c0 01             	add    $0x1,%eax
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800c1d:	83 e9 01             	sub    $0x1,%ecx
  800c20:	74 0e                	je     800c30 <strlcpy+0x38>
			*dst++ = *src++;
  800c22:	83 c2 01             	add    $0x1,%edx
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800c25:	0f b6 1a             	movzbl (%edx),%ebx
  800c28:	84 db                	test   %bl,%bl
  800c2a:	75 ec                	jne    800c18 <strlcpy+0x20>
  800c2c:	eb 02                	jmp    800c30 <strlcpy+0x38>
  800c2e:	89 f0                	mov    %esi,%eax
			*dst++ = *src++;
		*dst = '\0';
  800c30:	c6 00 00             	movb   $0x0,(%eax)
  800c33:	29 f0                	sub    %esi,%eax
	}
	return dst - dst_in;
}
  800c35:	5b                   	pop    %ebx
  800c36:	5e                   	pop    %esi
  800c37:	5d                   	pop    %ebp
  800c38:	c3                   	ret    

00800c39 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800c39:	55                   	push   %ebp
  800c3a:	89 e5                	mov    %esp,%ebp
  800c3c:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800c3f:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  800c42:	0f b6 01             	movzbl (%ecx),%eax
  800c45:	84 c0                	test   %al,%al
  800c47:	74 15                	je     800c5e <strcmp+0x25>
  800c49:	3a 02                	cmp    (%edx),%al
  800c4b:	75 11                	jne    800c5e <strcmp+0x25>
		p++, q++;
  800c4d:	83 c1 01             	add    $0x1,%ecx
  800c50:	83 c2 01             	add    $0x1,%edx
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800c53:	0f b6 01             	movzbl (%ecx),%eax
  800c56:	84 c0                	test   %al,%al
  800c58:	74 04                	je     800c5e <strcmp+0x25>
  800c5a:	3a 02                	cmp    (%edx),%al
  800c5c:	74 ef                	je     800c4d <strcmp+0x14>
  800c5e:	0f b6 c0             	movzbl %al,%eax
  800c61:	0f b6 12             	movzbl (%edx),%edx
  800c64:	29 d0                	sub    %edx,%eax
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
}
  800c66:	5d                   	pop    %ebp
  800c67:	c3                   	ret    

00800c68 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800c68:	55                   	push   %ebp
  800c69:	89 e5                	mov    %esp,%ebp
  800c6b:	53                   	push   %ebx
  800c6c:	8b 55 08             	mov    0x8(%ebp),%edx
  800c6f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c72:	8b 45 10             	mov    0x10(%ebp),%eax
	while (n > 0 && *p && *p == *q)
  800c75:	85 c0                	test   %eax,%eax
  800c77:	74 23                	je     800c9c <strncmp+0x34>
  800c79:	0f b6 1a             	movzbl (%edx),%ebx
  800c7c:	84 db                	test   %bl,%bl
  800c7e:	74 24                	je     800ca4 <strncmp+0x3c>
  800c80:	3a 19                	cmp    (%ecx),%bl
  800c82:	75 20                	jne    800ca4 <strncmp+0x3c>
  800c84:	83 e8 01             	sub    $0x1,%eax
  800c87:	74 13                	je     800c9c <strncmp+0x34>
		n--, p++, q++;
  800c89:	83 c2 01             	add    $0x1,%edx
  800c8c:	83 c1 01             	add    $0x1,%ecx
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  800c8f:	0f b6 1a             	movzbl (%edx),%ebx
  800c92:	84 db                	test   %bl,%bl
  800c94:	74 0e                	je     800ca4 <strncmp+0x3c>
  800c96:	3a 19                	cmp    (%ecx),%bl
  800c98:	74 ea                	je     800c84 <strncmp+0x1c>
  800c9a:	eb 08                	jmp    800ca4 <strncmp+0x3c>
  800c9c:	b8 00 00 00 00       	mov    $0x0,%eax
		n--, p++, q++;
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
}
  800ca1:	5b                   	pop    %ebx
  800ca2:	5d                   	pop    %ebp
  800ca3:	c3                   	ret    
	while (n > 0 && *p && *p == *q)
		n--, p++, q++;
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800ca4:	0f b6 02             	movzbl (%edx),%eax
  800ca7:	0f b6 11             	movzbl (%ecx),%edx
  800caa:	29 d0                	sub    %edx,%eax
  800cac:	eb f3                	jmp    800ca1 <strncmp+0x39>

00800cae <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800cae:	55                   	push   %ebp
  800caf:	89 e5                	mov    %esp,%ebp
  800cb1:	8b 45 08             	mov    0x8(%ebp),%eax
  800cb4:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800cb8:	0f b6 10             	movzbl (%eax),%edx
  800cbb:	84 d2                	test   %dl,%dl
  800cbd:	74 15                	je     800cd4 <strchr+0x26>
		if (*s == c)
  800cbf:	38 ca                	cmp    %cl,%dl
  800cc1:	75 07                	jne    800cca <strchr+0x1c>
  800cc3:	eb 14                	jmp    800cd9 <strchr+0x2b>
  800cc5:	38 ca                	cmp    %cl,%dl
  800cc7:	90                   	nop
  800cc8:	74 0f                	je     800cd9 <strchr+0x2b>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800cca:	83 c0 01             	add    $0x1,%eax
  800ccd:	0f b6 10             	movzbl (%eax),%edx
  800cd0:	84 d2                	test   %dl,%dl
  800cd2:	75 f1                	jne    800cc5 <strchr+0x17>
  800cd4:	b8 00 00 00 00       	mov    $0x0,%eax
		if (*s == c)
			return (char *) s;
	return 0;
}
  800cd9:	5d                   	pop    %ebp
  800cda:	c3                   	ret    

00800cdb <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800cdb:	55                   	push   %ebp
  800cdc:	89 e5                	mov    %esp,%ebp
  800cde:	8b 45 08             	mov    0x8(%ebp),%eax
  800ce1:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800ce5:	0f b6 10             	movzbl (%eax),%edx
  800ce8:	84 d2                	test   %dl,%dl
  800cea:	74 18                	je     800d04 <strfind+0x29>
		if (*s == c)
  800cec:	38 ca                	cmp    %cl,%dl
  800cee:	75 0a                	jne    800cfa <strfind+0x1f>
  800cf0:	eb 12                	jmp    800d04 <strfind+0x29>
  800cf2:	38 ca                	cmp    %cl,%dl
  800cf4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  800cf8:	74 0a                	je     800d04 <strfind+0x29>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800cfa:	83 c0 01             	add    $0x1,%eax
  800cfd:	0f b6 10             	movzbl (%eax),%edx
  800d00:	84 d2                	test   %dl,%dl
  800d02:	75 ee                	jne    800cf2 <strfind+0x17>
		if (*s == c)
			break;
	return (char *) s;
}
  800d04:	5d                   	pop    %ebp
  800d05:	c3                   	ret    

00800d06 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800d06:	55                   	push   %ebp
  800d07:	89 e5                	mov    %esp,%ebp
  800d09:	83 ec 0c             	sub    $0xc,%esp
  800d0c:	89 1c 24             	mov    %ebx,(%esp)
  800d0f:	89 74 24 04          	mov    %esi,0x4(%esp)
  800d13:	89 7c 24 08          	mov    %edi,0x8(%esp)
  800d17:	8b 7d 08             	mov    0x8(%ebp),%edi
  800d1a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d1d:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800d20:	85 c9                	test   %ecx,%ecx
  800d22:	74 30                	je     800d54 <memset+0x4e>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800d24:	f7 c7 03 00 00 00    	test   $0x3,%edi
  800d2a:	75 25                	jne    800d51 <memset+0x4b>
  800d2c:	f6 c1 03             	test   $0x3,%cl
  800d2f:	75 20                	jne    800d51 <memset+0x4b>
		c &= 0xFF;
  800d31:	0f b6 d0             	movzbl %al,%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800d34:	89 d3                	mov    %edx,%ebx
  800d36:	c1 e3 08             	shl    $0x8,%ebx
  800d39:	89 d6                	mov    %edx,%esi
  800d3b:	c1 e6 18             	shl    $0x18,%esi
  800d3e:	89 d0                	mov    %edx,%eax
  800d40:	c1 e0 10             	shl    $0x10,%eax
  800d43:	09 f0                	or     %esi,%eax
  800d45:	09 d0                	or     %edx,%eax
		asm volatile("cld; rep stosl\n"
  800d47:	09 d8                	or     %ebx,%eax
  800d49:	c1 e9 02             	shr    $0x2,%ecx
  800d4c:	fc                   	cld    
  800d4d:	f3 ab                	rep stos %eax,%es:(%edi)
{
	char *p;

	if (n == 0)
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800d4f:	eb 03                	jmp    800d54 <memset+0x4e>
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800d51:	fc                   	cld    
  800d52:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800d54:	89 f8                	mov    %edi,%eax
  800d56:	8b 1c 24             	mov    (%esp),%ebx
  800d59:	8b 74 24 04          	mov    0x4(%esp),%esi
  800d5d:	8b 7c 24 08          	mov    0x8(%esp),%edi
  800d61:	89 ec                	mov    %ebp,%esp
  800d63:	5d                   	pop    %ebp
  800d64:	c3                   	ret    

00800d65 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800d65:	55                   	push   %ebp
  800d66:	89 e5                	mov    %esp,%ebp
  800d68:	83 ec 08             	sub    $0x8,%esp
  800d6b:	89 34 24             	mov    %esi,(%esp)
  800d6e:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800d72:	8b 45 08             	mov    0x8(%ebp),%eax
  800d75:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;
	
	s = src;
  800d78:	8b 75 0c             	mov    0xc(%ebp),%esi
	d = dst;
  800d7b:	89 c7                	mov    %eax,%edi
	if (s < d && s + n > d) {
  800d7d:	39 c6                	cmp    %eax,%esi
  800d7f:	73 35                	jae    800db6 <memmove+0x51>
  800d81:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800d84:	39 d0                	cmp    %edx,%eax
  800d86:	73 2e                	jae    800db6 <memmove+0x51>
		s += n;
		d += n;
  800d88:	01 cf                	add    %ecx,%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800d8a:	f6 c2 03             	test   $0x3,%dl
  800d8d:	75 1b                	jne    800daa <memmove+0x45>
  800d8f:	f7 c7 03 00 00 00    	test   $0x3,%edi
  800d95:	75 13                	jne    800daa <memmove+0x45>
  800d97:	f6 c1 03             	test   $0x3,%cl
  800d9a:	75 0e                	jne    800daa <memmove+0x45>
			asm volatile("std; rep movsl\n"
  800d9c:	83 ef 04             	sub    $0x4,%edi
  800d9f:	8d 72 fc             	lea    -0x4(%edx),%esi
  800da2:	c1 e9 02             	shr    $0x2,%ecx
  800da5:	fd                   	std    
  800da6:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800da8:	eb 09                	jmp    800db3 <memmove+0x4e>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  800daa:	83 ef 01             	sub    $0x1,%edi
  800dad:	8d 72 ff             	lea    -0x1(%edx),%esi
  800db0:	fd                   	std    
  800db1:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800db3:	fc                   	cld    
	const char *s;
	char *d;
	
	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800db4:	eb 20                	jmp    800dd6 <memmove+0x71>
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800db6:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800dbc:	75 15                	jne    800dd3 <memmove+0x6e>
  800dbe:	f7 c7 03 00 00 00    	test   $0x3,%edi
  800dc4:	75 0d                	jne    800dd3 <memmove+0x6e>
  800dc6:	f6 c1 03             	test   $0x3,%cl
  800dc9:	75 08                	jne    800dd3 <memmove+0x6e>
			asm volatile("cld; rep movsl\n"
  800dcb:	c1 e9 02             	shr    $0x2,%ecx
  800dce:	fc                   	cld    
  800dcf:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800dd1:	eb 03                	jmp    800dd6 <memmove+0x71>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  800dd3:	fc                   	cld    
  800dd4:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800dd6:	8b 34 24             	mov    (%esp),%esi
  800dd9:	8b 7c 24 04          	mov    0x4(%esp),%edi
  800ddd:	89 ec                	mov    %ebp,%esp
  800ddf:	5d                   	pop    %ebp
  800de0:	c3                   	ret    

00800de1 <memcpy>:

/* sigh - gcc emits references to this for structure assignments! */
/* it is *not* prototyped in inc/string.h - do not use directly. */
void *
memcpy(void *dst, void *src, size_t n)
{
  800de1:	55                   	push   %ebp
  800de2:	89 e5                	mov    %esp,%ebp
  800de4:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  800de7:	8b 45 10             	mov    0x10(%ebp),%eax
  800dea:	89 44 24 08          	mov    %eax,0x8(%esp)
  800dee:	8b 45 0c             	mov    0xc(%ebp),%eax
  800df1:	89 44 24 04          	mov    %eax,0x4(%esp)
  800df5:	8b 45 08             	mov    0x8(%ebp),%eax
  800df8:	89 04 24             	mov    %eax,(%esp)
  800dfb:	e8 65 ff ff ff       	call   800d65 <memmove>
}
  800e00:	c9                   	leave  
  800e01:	c3                   	ret    

00800e02 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800e02:	55                   	push   %ebp
  800e03:	89 e5                	mov    %esp,%ebp
  800e05:	57                   	push   %edi
  800e06:	56                   	push   %esi
  800e07:	53                   	push   %ebx
  800e08:	8b 75 08             	mov    0x8(%ebp),%esi
  800e0b:	8b 7d 0c             	mov    0xc(%ebp),%edi
  800e0e:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800e11:	85 c9                	test   %ecx,%ecx
  800e13:	74 36                	je     800e4b <memcmp+0x49>
		if (*s1 != *s2)
  800e15:	0f b6 06             	movzbl (%esi),%eax
  800e18:	0f b6 1f             	movzbl (%edi),%ebx
  800e1b:	38 d8                	cmp    %bl,%al
  800e1d:	74 20                	je     800e3f <memcmp+0x3d>
  800e1f:	eb 14                	jmp    800e35 <memcmp+0x33>
  800e21:	0f b6 44 16 01       	movzbl 0x1(%esi,%edx,1),%eax
  800e26:	0f b6 5c 17 01       	movzbl 0x1(%edi,%edx,1),%ebx
  800e2b:	83 c2 01             	add    $0x1,%edx
  800e2e:	83 e9 01             	sub    $0x1,%ecx
  800e31:	38 d8                	cmp    %bl,%al
  800e33:	74 12                	je     800e47 <memcmp+0x45>
			return (int) *s1 - (int) *s2;
  800e35:	0f b6 c0             	movzbl %al,%eax
  800e38:	0f b6 db             	movzbl %bl,%ebx
  800e3b:	29 d8                	sub    %ebx,%eax
  800e3d:	eb 11                	jmp    800e50 <memcmp+0x4e>
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800e3f:	83 e9 01             	sub    $0x1,%ecx
  800e42:	ba 00 00 00 00       	mov    $0x0,%edx
  800e47:	85 c9                	test   %ecx,%ecx
  800e49:	75 d6                	jne    800e21 <memcmp+0x1f>
  800e4b:	b8 00 00 00 00       	mov    $0x0,%eax
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
}
  800e50:	5b                   	pop    %ebx
  800e51:	5e                   	pop    %esi
  800e52:	5f                   	pop    %edi
  800e53:	5d                   	pop    %ebp
  800e54:	c3                   	ret    

00800e55 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800e55:	55                   	push   %ebp
  800e56:	89 e5                	mov    %esp,%ebp
  800e58:	8b 45 08             	mov    0x8(%ebp),%eax
	const void *ends = (const char *) s + n;
  800e5b:	89 c2                	mov    %eax,%edx
  800e5d:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800e60:	39 d0                	cmp    %edx,%eax
  800e62:	73 15                	jae    800e79 <memfind+0x24>
		if (*(const unsigned char *) s == (unsigned char) c)
  800e64:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
  800e68:	38 08                	cmp    %cl,(%eax)
  800e6a:	75 06                	jne    800e72 <memfind+0x1d>
  800e6c:	eb 0b                	jmp    800e79 <memfind+0x24>
  800e6e:	38 08                	cmp    %cl,(%eax)
  800e70:	74 07                	je     800e79 <memfind+0x24>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800e72:	83 c0 01             	add    $0x1,%eax
  800e75:	39 c2                	cmp    %eax,%edx
  800e77:	77 f5                	ja     800e6e <memfind+0x19>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
	return (void *) s;
}
  800e79:	5d                   	pop    %ebp
  800e7a:	c3                   	ret    

00800e7b <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800e7b:	55                   	push   %ebp
  800e7c:	89 e5                	mov    %esp,%ebp
  800e7e:	57                   	push   %edi
  800e7f:	56                   	push   %esi
  800e80:	53                   	push   %ebx
  800e81:	83 ec 04             	sub    $0x4,%esp
  800e84:	8b 55 08             	mov    0x8(%ebp),%edx
  800e87:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800e8a:	0f b6 02             	movzbl (%edx),%eax
  800e8d:	3c 20                	cmp    $0x20,%al
  800e8f:	74 04                	je     800e95 <strtol+0x1a>
  800e91:	3c 09                	cmp    $0x9,%al
  800e93:	75 0e                	jne    800ea3 <strtol+0x28>
		s++;
  800e95:	83 c2 01             	add    $0x1,%edx
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800e98:	0f b6 02             	movzbl (%edx),%eax
  800e9b:	3c 20                	cmp    $0x20,%al
  800e9d:	74 f6                	je     800e95 <strtol+0x1a>
  800e9f:	3c 09                	cmp    $0x9,%al
  800ea1:	74 f2                	je     800e95 <strtol+0x1a>
		s++;

	// plus/minus sign
	if (*s == '+')
  800ea3:	3c 2b                	cmp    $0x2b,%al
  800ea5:	75 0c                	jne    800eb3 <strtol+0x38>
		s++;
  800ea7:	83 c2 01             	add    $0x1,%edx
  800eaa:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800eb1:	eb 15                	jmp    800ec8 <strtol+0x4d>
	else if (*s == '-')
  800eb3:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800eba:	3c 2d                	cmp    $0x2d,%al
  800ebc:	75 0a                	jne    800ec8 <strtol+0x4d>
		s++, neg = 1;
  800ebe:	83 c2 01             	add    $0x1,%edx
  800ec1:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800ec8:	85 db                	test   %ebx,%ebx
  800eca:	0f 94 c0             	sete   %al
  800ecd:	74 05                	je     800ed4 <strtol+0x59>
  800ecf:	83 fb 10             	cmp    $0x10,%ebx
  800ed2:	75 18                	jne    800eec <strtol+0x71>
  800ed4:	80 3a 30             	cmpb   $0x30,(%edx)
  800ed7:	75 13                	jne    800eec <strtol+0x71>
  800ed9:	80 7a 01 78          	cmpb   $0x78,0x1(%edx)
  800edd:	8d 76 00             	lea    0x0(%esi),%esi
  800ee0:	75 0a                	jne    800eec <strtol+0x71>
		s += 2, base = 16;
  800ee2:	83 c2 02             	add    $0x2,%edx
  800ee5:	bb 10 00 00 00       	mov    $0x10,%ebx
		s++;
	else if (*s == '-')
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800eea:	eb 15                	jmp    800f01 <strtol+0x86>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  800eec:	84 c0                	test   %al,%al
  800eee:	66 90                	xchg   %ax,%ax
  800ef0:	74 0f                	je     800f01 <strtol+0x86>
  800ef2:	bb 0a 00 00 00       	mov    $0xa,%ebx
  800ef7:	80 3a 30             	cmpb   $0x30,(%edx)
  800efa:	75 05                	jne    800f01 <strtol+0x86>
		s++, base = 8;
  800efc:	83 c2 01             	add    $0x1,%edx
  800eff:	b3 08                	mov    $0x8,%bl
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  800f01:	b8 00 00 00 00       	mov    $0x0,%eax
  800f06:	89 de                	mov    %ebx,%esi

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  800f08:	0f b6 0a             	movzbl (%edx),%ecx
  800f0b:	89 cf                	mov    %ecx,%edi
  800f0d:	8d 59 d0             	lea    -0x30(%ecx),%ebx
  800f10:	80 fb 09             	cmp    $0x9,%bl
  800f13:	77 08                	ja     800f1d <strtol+0xa2>
			dig = *s - '0';
  800f15:	0f be c9             	movsbl %cl,%ecx
  800f18:	83 e9 30             	sub    $0x30,%ecx
  800f1b:	eb 1e                	jmp    800f3b <strtol+0xc0>
		else if (*s >= 'a' && *s <= 'z')
  800f1d:	8d 5f 9f             	lea    -0x61(%edi),%ebx
  800f20:	80 fb 19             	cmp    $0x19,%bl
  800f23:	77 08                	ja     800f2d <strtol+0xb2>
			dig = *s - 'a' + 10;
  800f25:	0f be c9             	movsbl %cl,%ecx
  800f28:	83 e9 57             	sub    $0x57,%ecx
  800f2b:	eb 0e                	jmp    800f3b <strtol+0xc0>
		else if (*s >= 'A' && *s <= 'Z')
  800f2d:	8d 5f bf             	lea    -0x41(%edi),%ebx
  800f30:	80 fb 19             	cmp    $0x19,%bl
  800f33:	77 15                	ja     800f4a <strtol+0xcf>
			dig = *s - 'A' + 10;
  800f35:	0f be c9             	movsbl %cl,%ecx
  800f38:	83 e9 37             	sub    $0x37,%ecx
		else
			break;
		if (dig >= base)
  800f3b:	39 f1                	cmp    %esi,%ecx
  800f3d:	7d 0b                	jge    800f4a <strtol+0xcf>
			break;
		s++, val = (val * base) + dig;
  800f3f:	83 c2 01             	add    $0x1,%edx
  800f42:	0f af c6             	imul   %esi,%eax
  800f45:	8d 04 01             	lea    (%ecx,%eax,1),%eax
		// we don't properly detect overflow!
	}
  800f48:	eb be                	jmp    800f08 <strtol+0x8d>
  800f4a:	89 c1                	mov    %eax,%ecx

	if (endptr)
  800f4c:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800f50:	74 05                	je     800f57 <strtol+0xdc>
		*endptr = (char *) s;
  800f52:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800f55:	89 13                	mov    %edx,(%ebx)
	return (neg ? -val : val);
  800f57:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  800f5b:	74 04                	je     800f61 <strtol+0xe6>
  800f5d:	89 c8                	mov    %ecx,%eax
  800f5f:	f7 d8                	neg    %eax
}
  800f61:	83 c4 04             	add    $0x4,%esp
  800f64:	5b                   	pop    %ebx
  800f65:	5e                   	pop    %esi
  800f66:	5f                   	pop    %edi
  800f67:	5d                   	pop    %ebp
  800f68:	c3                   	ret    
  800f69:	00 00                	add    %al,(%eax)
	...

00800f6c <sys_cgetc>:
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}

int
sys_cgetc(void)
{
  800f6c:	55                   	push   %ebp
  800f6d:	89 e5                	mov    %esp,%ebp
  800f6f:	83 ec 0c             	sub    $0xc,%esp
  800f72:	89 1c 24             	mov    %ebx,(%esp)
  800f75:	89 74 24 04          	mov    %esi,0x4(%esp)
  800f79:	89 7c 24 08          	mov    %edi,0x8(%esp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800f7d:	ba 00 00 00 00       	mov    $0x0,%edx
  800f82:	b8 01 00 00 00       	mov    $0x1,%eax
  800f87:	89 d1                	mov    %edx,%ecx
  800f89:	89 d3                	mov    %edx,%ebx
  800f8b:	89 d7                	mov    %edx,%edi
  800f8d:	89 d6                	mov    %edx,%esi
  800f8f:	cd 30                	int    $0x30

int
sys_cgetc(void)
{
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800f91:	8b 1c 24             	mov    (%esp),%ebx
  800f94:	8b 74 24 04          	mov    0x4(%esp),%esi
  800f98:	8b 7c 24 08          	mov    0x8(%esp),%edi
  800f9c:	89 ec                	mov    %ebp,%esp
  800f9e:	5d                   	pop    %ebp
  800f9f:	c3                   	ret    

00800fa0 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800fa0:	55                   	push   %ebp
  800fa1:	89 e5                	mov    %esp,%ebp
  800fa3:	83 ec 0c             	sub    $0xc,%esp
  800fa6:	89 1c 24             	mov    %ebx,(%esp)
  800fa9:	89 74 24 04          	mov    %esi,0x4(%esp)
  800fad:	89 7c 24 08          	mov    %edi,0x8(%esp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800fb1:	b8 00 00 00 00       	mov    $0x0,%eax
  800fb6:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800fb9:	8b 55 08             	mov    0x8(%ebp),%edx
  800fbc:	89 c3                	mov    %eax,%ebx
  800fbe:	89 c7                	mov    %eax,%edi
  800fc0:	89 c6                	mov    %eax,%esi
  800fc2:	cd 30                	int    $0x30

void
sys_cputs(const char *s, size_t len)
{
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800fc4:	8b 1c 24             	mov    (%esp),%ebx
  800fc7:	8b 74 24 04          	mov    0x4(%esp),%esi
  800fcb:	8b 7c 24 08          	mov    0x8(%esp),%edi
  800fcf:	89 ec                	mov    %ebp,%esp
  800fd1:	5d                   	pop    %ebp
  800fd2:	c3                   	ret    

00800fd3 <sys_page_insert>:
{
	return syscall(SYS_page_waste, 0, (uint32_t)p, (uint32_t)n, 0, 0,0);
}
int
sys_page_insert(envid_t envid, void *va, struct Page *p, int perm)
{
  800fd3:	55                   	push   %ebp
  800fd4:	89 e5                	mov    %esp,%ebp
  800fd6:	83 ec 38             	sub    $0x38,%esp
  800fd9:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800fdc:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800fdf:	89 7d fc             	mov    %edi,-0x4(%ebp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800fe2:	be 00 00 00 00       	mov    $0x0,%esi
  800fe7:	b8 12 00 00 00       	mov    $0x12,%eax
  800fec:	8b 7d 14             	mov    0x14(%ebp),%edi
  800fef:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800ff2:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ff5:	8b 55 08             	mov    0x8(%ebp),%edx
  800ff8:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
	
	if(check && ret > 0)
  800ffa:	85 c0                	test   %eax,%eax
  800ffc:	7e 28                	jle    801026 <sys_page_insert+0x53>
		panic("syscall %d returned %d (> 0)", num, ret);
  800ffe:	89 44 24 10          	mov    %eax,0x10(%esp)
  801002:	c7 44 24 0c 12 00 00 	movl   $0x12,0xc(%esp)
  801009:	00 
  80100a:	c7 44 24 08 8f 2e 80 	movl   $0x802e8f,0x8(%esp)
  801011:	00 
  801012:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  801019:	00 
  80101a:	c7 04 24 ac 2e 80 00 	movl   $0x802eac,(%esp)
  801021:	e8 12 f3 ff ff       	call   800338 <_panic>
}
int
sys_page_insert(envid_t envid, void *va, struct Page *p, int perm)
{
	return syscall(SYS_page_insert, 1, envid, (uint32_t) va, (uint32_t)p, perm, 0);
}
  801026:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  801029:	8b 75 f8             	mov    -0x8(%ebp),%esi
  80102c:	8b 7d fc             	mov    -0x4(%ebp),%edi
  80102f:	89 ec                	mov    %ebp,%esp
  801031:	5d                   	pop    %ebp
  801032:	c3                   	ret    

00801033 <sys_page_waste>:
{
	return (int)syscall(SYS_receive_packet, 0, (uint32_t)buffer, 0,0,0,0);
}

int sys_page_waste(struct Page **p, int n)
{
  801033:	55                   	push   %ebp
  801034:	89 e5                	mov    %esp,%ebp
  801036:	83 ec 0c             	sub    $0xc,%esp
  801039:	89 1c 24             	mov    %ebx,(%esp)
  80103c:	89 74 24 04          	mov    %esi,0x4(%esp)
  801040:	89 7c 24 08          	mov    %edi,0x8(%esp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801044:	bb 00 00 00 00       	mov    $0x0,%ebx
  801049:	b8 11 00 00 00       	mov    $0x11,%eax
  80104e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801051:	8b 55 08             	mov    0x8(%ebp),%edx
  801054:	89 df                	mov    %ebx,%edi
  801056:	89 de                	mov    %ebx,%esi
  801058:	cd 30                	int    $0x30
}

int sys_page_waste(struct Page **p, int n)
{
	return syscall(SYS_page_waste, 0, (uint32_t)p, (uint32_t)n, 0, 0,0);
}
  80105a:	8b 1c 24             	mov    (%esp),%ebx
  80105d:	8b 74 24 04          	mov    0x4(%esp),%esi
  801061:	8b 7c 24 08          	mov    0x8(%esp),%edi
  801065:	89 ec                	mov    %ebp,%esp
  801067:	5d                   	pop    %ebp
  801068:	c3                   	ret    

00801069 <sys_receive_packet>:
{
	return (int)syscall(SYS_transmit_packet, 1, (uint32_t)data, len, 0,0,0);
}

int sys_receive_packet(void* buffer)
{
  801069:	55                   	push   %ebp
  80106a:	89 e5                	mov    %esp,%ebp
  80106c:	83 ec 0c             	sub    $0xc,%esp
  80106f:	89 1c 24             	mov    %ebx,(%esp)
  801072:	89 74 24 04          	mov    %esi,0x4(%esp)
  801076:	89 7c 24 08          	mov    %edi,0x8(%esp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80107a:	b9 00 00 00 00       	mov    $0x0,%ecx
  80107f:	b8 10 00 00 00       	mov    $0x10,%eax
  801084:	8b 55 08             	mov    0x8(%ebp),%edx
  801087:	89 cb                	mov    %ecx,%ebx
  801089:	89 cf                	mov    %ecx,%edi
  80108b:	89 ce                	mov    %ecx,%esi
  80108d:	cd 30                	int    $0x30
}

int sys_receive_packet(void* buffer)
{
	return (int)syscall(SYS_receive_packet, 0, (uint32_t)buffer, 0,0,0,0);
}
  80108f:	8b 1c 24             	mov    (%esp),%ebx
  801092:	8b 74 24 04          	mov    0x4(%esp),%esi
  801096:	8b 7c 24 08          	mov    0x8(%esp),%edi
  80109a:	89 ec                	mov    %ebp,%esp
  80109c:	5d                   	pop    %ebp
  80109d:	c3                   	ret    

0080109e <sys_transmit_packet>:
{
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0,0);
}

int sys_transmit_packet(void* data, uint32_t len)
{
  80109e:	55                   	push   %ebp
  80109f:	89 e5                	mov    %esp,%ebp
  8010a1:	83 ec 38             	sub    $0x38,%esp
  8010a4:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  8010a7:	89 75 f8             	mov    %esi,-0x8(%ebp)
  8010aa:	89 7d fc             	mov    %edi,-0x4(%ebp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8010ad:	bb 00 00 00 00       	mov    $0x0,%ebx
  8010b2:	b8 0f 00 00 00       	mov    $0xf,%eax
  8010b7:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8010ba:	8b 55 08             	mov    0x8(%ebp),%edx
  8010bd:	89 df                	mov    %ebx,%edi
  8010bf:	89 de                	mov    %ebx,%esi
  8010c1:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
	
	if(check && ret > 0)
  8010c3:	85 c0                	test   %eax,%eax
  8010c5:	7e 28                	jle    8010ef <sys_transmit_packet+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  8010c7:	89 44 24 10          	mov    %eax,0x10(%esp)
  8010cb:	c7 44 24 0c 0f 00 00 	movl   $0xf,0xc(%esp)
  8010d2:	00 
  8010d3:	c7 44 24 08 8f 2e 80 	movl   $0x802e8f,0x8(%esp)
  8010da:	00 
  8010db:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  8010e2:	00 
  8010e3:	c7 04 24 ac 2e 80 00 	movl   $0x802eac,(%esp)
  8010ea:	e8 49 f2 ff ff       	call   800338 <_panic>
}

int sys_transmit_packet(void* data, uint32_t len)
{
	return (int)syscall(SYS_transmit_packet, 1, (uint32_t)data, len, 0,0,0);
}
  8010ef:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  8010f2:	8b 75 f8             	mov    -0x8(%ebp),%esi
  8010f5:	8b 7d fc             	mov    -0x4(%ebp),%edi
  8010f8:	89 ec                	mov    %ebp,%esp
  8010fa:	5d                   	pop    %ebp
  8010fb:	c3                   	ret    

008010fc <sys_time_msec>:
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}

unsigned int
sys_time_msec(void)
{
  8010fc:	55                   	push   %ebp
  8010fd:	89 e5                	mov    %esp,%ebp
  8010ff:	83 ec 0c             	sub    $0xc,%esp
  801102:	89 1c 24             	mov    %ebx,(%esp)
  801105:	89 74 24 04          	mov    %esi,0x4(%esp)
  801109:	89 7c 24 08          	mov    %edi,0x8(%esp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80110d:	ba 00 00 00 00       	mov    $0x0,%edx
  801112:	b8 0e 00 00 00       	mov    $0xe,%eax
  801117:	89 d1                	mov    %edx,%ecx
  801119:	89 d3                	mov    %edx,%ebx
  80111b:	89 d7                	mov    %edx,%edi
  80111d:	89 d6                	mov    %edx,%esi
  80111f:	cd 30                	int    $0x30

unsigned int
sys_time_msec(void)
{
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0,0);
}
  801121:	8b 1c 24             	mov    (%esp),%ebx
  801124:	8b 74 24 04          	mov    0x4(%esp),%esi
  801128:	8b 7c 24 08          	mov    0x8(%esp),%edi
  80112c:	89 ec                	mov    %ebp,%esp
  80112e:	5d                   	pop    %ebp
  80112f:	c3                   	ret    

00801130 <sys_ipc_recv>:
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}

int
sys_ipc_recv(void *dstva)
{
  801130:	55                   	push   %ebp
  801131:	89 e5                	mov    %esp,%ebp
  801133:	83 ec 38             	sub    $0x38,%esp
  801136:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  801139:	89 75 f8             	mov    %esi,-0x8(%ebp)
  80113c:	89 7d fc             	mov    %edi,-0x4(%ebp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80113f:	b9 00 00 00 00       	mov    $0x0,%ecx
  801144:	b8 0d 00 00 00       	mov    $0xd,%eax
  801149:	8b 55 08             	mov    0x8(%ebp),%edx
  80114c:	89 cb                	mov    %ecx,%ebx
  80114e:	89 cf                	mov    %ecx,%edi
  801150:	89 ce                	mov    %ecx,%esi
  801152:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
	
	if(check && ret > 0)
  801154:	85 c0                	test   %eax,%eax
  801156:	7e 28                	jle    801180 <sys_ipc_recv+0x50>
		panic("syscall %d returned %d (> 0)", num, ret);
  801158:	89 44 24 10          	mov    %eax,0x10(%esp)
  80115c:	c7 44 24 0c 0d 00 00 	movl   $0xd,0xc(%esp)
  801163:	00 
  801164:	c7 44 24 08 8f 2e 80 	movl   $0x802e8f,0x8(%esp)
  80116b:	00 
  80116c:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  801173:	00 
  801174:	c7 04 24 ac 2e 80 00 	movl   $0x802eac,(%esp)
  80117b:	e8 b8 f1 ff ff       	call   800338 <_panic>

int
sys_ipc_recv(void *dstva)
{
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  801180:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  801183:	8b 75 f8             	mov    -0x8(%ebp),%esi
  801186:	8b 7d fc             	mov    -0x4(%ebp),%edi
  801189:	89 ec                	mov    %ebp,%esp
  80118b:	5d                   	pop    %ebp
  80118c:	c3                   	ret    

0080118d <sys_ipc_try_send>:
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  80118d:	55                   	push   %ebp
  80118e:	89 e5                	mov    %esp,%ebp
  801190:	83 ec 0c             	sub    $0xc,%esp
  801193:	89 1c 24             	mov    %ebx,(%esp)
  801196:	89 74 24 04          	mov    %esi,0x4(%esp)
  80119a:	89 7c 24 08          	mov    %edi,0x8(%esp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80119e:	be 00 00 00 00       	mov    $0x0,%esi
  8011a3:	b8 0c 00 00 00       	mov    $0xc,%eax
  8011a8:	8b 7d 14             	mov    0x14(%ebp),%edi
  8011ab:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8011ae:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8011b1:	8b 55 08             	mov    0x8(%ebp),%edx
  8011b4:	cd 30                	int    $0x30

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  8011b6:	8b 1c 24             	mov    (%esp),%ebx
  8011b9:	8b 74 24 04          	mov    0x4(%esp),%esi
  8011bd:	8b 7c 24 08          	mov    0x8(%esp),%edi
  8011c1:	89 ec                	mov    %ebp,%esp
  8011c3:	5d                   	pop    %ebp
  8011c4:	c3                   	ret    

008011c5 <sys_env_set_pgfault_upcall>:
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  8011c5:	55                   	push   %ebp
  8011c6:	89 e5                	mov    %esp,%ebp
  8011c8:	83 ec 38             	sub    $0x38,%esp
  8011cb:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  8011ce:	89 75 f8             	mov    %esi,-0x8(%ebp)
  8011d1:	89 7d fc             	mov    %edi,-0x4(%ebp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8011d4:	bb 00 00 00 00       	mov    $0x0,%ebx
  8011d9:	b8 0a 00 00 00       	mov    $0xa,%eax
  8011de:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8011e1:	8b 55 08             	mov    0x8(%ebp),%edx
  8011e4:	89 df                	mov    %ebx,%edi
  8011e6:	89 de                	mov    %ebx,%esi
  8011e8:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
	
	if(check && ret > 0)
  8011ea:	85 c0                	test   %eax,%eax
  8011ec:	7e 28                	jle    801216 <sys_env_set_pgfault_upcall+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  8011ee:	89 44 24 10          	mov    %eax,0x10(%esp)
  8011f2:	c7 44 24 0c 0a 00 00 	movl   $0xa,0xc(%esp)
  8011f9:	00 
  8011fa:	c7 44 24 08 8f 2e 80 	movl   $0x802e8f,0x8(%esp)
  801201:	00 
  801202:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  801209:	00 
  80120a:	c7 04 24 ac 2e 80 00 	movl   $0x802eac,(%esp)
  801211:	e8 22 f1 ff ff       	call   800338 <_panic>

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  801216:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  801219:	8b 75 f8             	mov    -0x8(%ebp),%esi
  80121c:	8b 7d fc             	mov    -0x4(%ebp),%edi
  80121f:	89 ec                	mov    %ebp,%esp
  801221:	5d                   	pop    %ebp
  801222:	c3                   	ret    

00801223 <sys_env_set_trapframe>:
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  801223:	55                   	push   %ebp
  801224:	89 e5                	mov    %esp,%ebp
  801226:	83 ec 38             	sub    $0x38,%esp
  801229:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  80122c:	89 75 f8             	mov    %esi,-0x8(%ebp)
  80122f:	89 7d fc             	mov    %edi,-0x4(%ebp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801232:	bb 00 00 00 00       	mov    $0x0,%ebx
  801237:	b8 09 00 00 00       	mov    $0x9,%eax
  80123c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80123f:	8b 55 08             	mov    0x8(%ebp),%edx
  801242:	89 df                	mov    %ebx,%edi
  801244:	89 de                	mov    %ebx,%esi
  801246:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
	
	if(check && ret > 0)
  801248:	85 c0                	test   %eax,%eax
  80124a:	7e 28                	jle    801274 <sys_env_set_trapframe+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  80124c:	89 44 24 10          	mov    %eax,0x10(%esp)
  801250:	c7 44 24 0c 09 00 00 	movl   $0x9,0xc(%esp)
  801257:	00 
  801258:	c7 44 24 08 8f 2e 80 	movl   $0x802e8f,0x8(%esp)
  80125f:	00 
  801260:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  801267:	00 
  801268:	c7 04 24 ac 2e 80 00 	movl   $0x802eac,(%esp)
  80126f:	e8 c4 f0 ff ff       	call   800338 <_panic>

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  801274:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  801277:	8b 75 f8             	mov    -0x8(%ebp),%esi
  80127a:	8b 7d fc             	mov    -0x4(%ebp),%edi
  80127d:	89 ec                	mov    %ebp,%esp
  80127f:	5d                   	pop    %ebp
  801280:	c3                   	ret    

00801281 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  801281:	55                   	push   %ebp
  801282:	89 e5                	mov    %esp,%ebp
  801284:	83 ec 38             	sub    $0x38,%esp
  801287:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  80128a:	89 75 f8             	mov    %esi,-0x8(%ebp)
  80128d:	89 7d fc             	mov    %edi,-0x4(%ebp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801290:	bb 00 00 00 00       	mov    $0x0,%ebx
  801295:	b8 08 00 00 00       	mov    $0x8,%eax
  80129a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80129d:	8b 55 08             	mov    0x8(%ebp),%edx
  8012a0:	89 df                	mov    %ebx,%edi
  8012a2:	89 de                	mov    %ebx,%esi
  8012a4:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
	
	if(check && ret > 0)
  8012a6:	85 c0                	test   %eax,%eax
  8012a8:	7e 28                	jle    8012d2 <sys_env_set_status+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  8012aa:	89 44 24 10          	mov    %eax,0x10(%esp)
  8012ae:	c7 44 24 0c 08 00 00 	movl   $0x8,0xc(%esp)
  8012b5:	00 
  8012b6:	c7 44 24 08 8f 2e 80 	movl   $0x802e8f,0x8(%esp)
  8012bd:	00 
  8012be:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  8012c5:	00 
  8012c6:	c7 04 24 ac 2e 80 00 	movl   $0x802eac,(%esp)
  8012cd:	e8 66 f0 ff ff       	call   800338 <_panic>

int
sys_env_set_status(envid_t envid, int status)
{
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  8012d2:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  8012d5:	8b 75 f8             	mov    -0x8(%ebp),%esi
  8012d8:	8b 7d fc             	mov    -0x4(%ebp),%edi
  8012db:	89 ec                	mov    %ebp,%esp
  8012dd:	5d                   	pop    %ebp
  8012de:	c3                   	ret    

008012df <sys_page_unmap>:
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}

int
sys_page_unmap(envid_t envid, void *va)
{
  8012df:	55                   	push   %ebp
  8012e0:	89 e5                	mov    %esp,%ebp
  8012e2:	83 ec 38             	sub    $0x38,%esp
  8012e5:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  8012e8:	89 75 f8             	mov    %esi,-0x8(%ebp)
  8012eb:	89 7d fc             	mov    %edi,-0x4(%ebp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8012ee:	bb 00 00 00 00       	mov    $0x0,%ebx
  8012f3:	b8 06 00 00 00       	mov    $0x6,%eax
  8012f8:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8012fb:	8b 55 08             	mov    0x8(%ebp),%edx
  8012fe:	89 df                	mov    %ebx,%edi
  801300:	89 de                	mov    %ebx,%esi
  801302:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
	
	if(check && ret > 0)
  801304:	85 c0                	test   %eax,%eax
  801306:	7e 28                	jle    801330 <sys_page_unmap+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  801308:	89 44 24 10          	mov    %eax,0x10(%esp)
  80130c:	c7 44 24 0c 06 00 00 	movl   $0x6,0xc(%esp)
  801313:	00 
  801314:	c7 44 24 08 8f 2e 80 	movl   $0x802e8f,0x8(%esp)
  80131b:	00 
  80131c:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  801323:	00 
  801324:	c7 04 24 ac 2e 80 00 	movl   $0x802eac,(%esp)
  80132b:	e8 08 f0 ff ff       	call   800338 <_panic>

int
sys_page_unmap(envid_t envid, void *va)
{
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  801330:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  801333:	8b 75 f8             	mov    -0x8(%ebp),%esi
  801336:	8b 7d fc             	mov    -0x4(%ebp),%edi
  801339:	89 ec                	mov    %ebp,%esp
  80133b:	5d                   	pop    %ebp
  80133c:	c3                   	ret    

0080133d <sys_page_map>:
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  80133d:	55                   	push   %ebp
  80133e:	89 e5                	mov    %esp,%ebp
  801340:	83 ec 38             	sub    $0x38,%esp
  801343:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  801346:	89 75 f8             	mov    %esi,-0x8(%ebp)
  801349:	89 7d fc             	mov    %edi,-0x4(%ebp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80134c:	b8 05 00 00 00       	mov    $0x5,%eax
  801351:	8b 75 18             	mov    0x18(%ebp),%esi
  801354:	8b 7d 14             	mov    0x14(%ebp),%edi
  801357:	8b 5d 10             	mov    0x10(%ebp),%ebx
  80135a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80135d:	8b 55 08             	mov    0x8(%ebp),%edx
  801360:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
	
	if(check && ret > 0)
  801362:	85 c0                	test   %eax,%eax
  801364:	7e 28                	jle    80138e <sys_page_map+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  801366:	89 44 24 10          	mov    %eax,0x10(%esp)
  80136a:	c7 44 24 0c 05 00 00 	movl   $0x5,0xc(%esp)
  801371:	00 
  801372:	c7 44 24 08 8f 2e 80 	movl   $0x802e8f,0x8(%esp)
  801379:	00 
  80137a:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  801381:	00 
  801382:	c7 04 24 ac 2e 80 00 	movl   $0x802eac,(%esp)
  801389:	e8 aa ef ff ff       	call   800338 <_panic>

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  80138e:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  801391:	8b 75 f8             	mov    -0x8(%ebp),%esi
  801394:	8b 7d fc             	mov    -0x4(%ebp),%edi
  801397:	89 ec                	mov    %ebp,%esp
  801399:	5d                   	pop    %ebp
  80139a:	c3                   	ret    

0080139b <sys_page_alloc>:
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  80139b:	55                   	push   %ebp
  80139c:	89 e5                	mov    %esp,%ebp
  80139e:	83 ec 38             	sub    $0x38,%esp
  8013a1:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  8013a4:	89 75 f8             	mov    %esi,-0x8(%ebp)
  8013a7:	89 7d fc             	mov    %edi,-0x4(%ebp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8013aa:	be 00 00 00 00       	mov    $0x0,%esi
  8013af:	b8 04 00 00 00       	mov    $0x4,%eax
  8013b4:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8013b7:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8013ba:	8b 55 08             	mov    0x8(%ebp),%edx
  8013bd:	89 f7                	mov    %esi,%edi
  8013bf:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
	
	if(check && ret > 0)
  8013c1:	85 c0                	test   %eax,%eax
  8013c3:	7e 28                	jle    8013ed <sys_page_alloc+0x52>
		panic("syscall %d returned %d (> 0)", num, ret);
  8013c5:	89 44 24 10          	mov    %eax,0x10(%esp)
  8013c9:	c7 44 24 0c 04 00 00 	movl   $0x4,0xc(%esp)
  8013d0:	00 
  8013d1:	c7 44 24 08 8f 2e 80 	movl   $0x802e8f,0x8(%esp)
  8013d8:	00 
  8013d9:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  8013e0:	00 
  8013e1:	c7 04 24 ac 2e 80 00 	movl   $0x802eac,(%esp)
  8013e8:	e8 4b ef ff ff       	call   800338 <_panic>

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  8013ed:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  8013f0:	8b 75 f8             	mov    -0x8(%ebp),%esi
  8013f3:	8b 7d fc             	mov    -0x4(%ebp),%edi
  8013f6:	89 ec                	mov    %ebp,%esp
  8013f8:	5d                   	pop    %ebp
  8013f9:	c3                   	ret    

008013fa <sys_yield>:
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}

void
sys_yield(void)
{
  8013fa:	55                   	push   %ebp
  8013fb:	89 e5                	mov    %esp,%ebp
  8013fd:	83 ec 0c             	sub    $0xc,%esp
  801400:	89 1c 24             	mov    %ebx,(%esp)
  801403:	89 74 24 04          	mov    %esi,0x4(%esp)
  801407:	89 7c 24 08          	mov    %edi,0x8(%esp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80140b:	ba 00 00 00 00       	mov    $0x0,%edx
  801410:	b8 0b 00 00 00       	mov    $0xb,%eax
  801415:	89 d1                	mov    %edx,%ecx
  801417:	89 d3                	mov    %edx,%ebx
  801419:	89 d7                	mov    %edx,%edi
  80141b:	89 d6                	mov    %edx,%esi
  80141d:	cd 30                	int    $0x30

void
sys_yield(void)
{
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  80141f:	8b 1c 24             	mov    (%esp),%ebx
  801422:	8b 74 24 04          	mov    0x4(%esp),%esi
  801426:	8b 7c 24 08          	mov    0x8(%esp),%edi
  80142a:	89 ec                	mov    %ebp,%esp
  80142c:	5d                   	pop    %ebp
  80142d:	c3                   	ret    

0080142e <sys_getenvid>:
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}

envid_t
sys_getenvid(void)
{
  80142e:	55                   	push   %ebp
  80142f:	89 e5                	mov    %esp,%ebp
  801431:	83 ec 0c             	sub    $0xc,%esp
  801434:	89 1c 24             	mov    %ebx,(%esp)
  801437:	89 74 24 04          	mov    %esi,0x4(%esp)
  80143b:	89 7c 24 08          	mov    %edi,0x8(%esp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80143f:	ba 00 00 00 00       	mov    $0x0,%edx
  801444:	b8 02 00 00 00       	mov    $0x2,%eax
  801449:	89 d1                	mov    %edx,%ecx
  80144b:	89 d3                	mov    %edx,%ebx
  80144d:	89 d7                	mov    %edx,%edi
  80144f:	89 d6                	mov    %edx,%esi
  801451:	cd 30                	int    $0x30

envid_t
sys_getenvid(void)
{
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  801453:	8b 1c 24             	mov    (%esp),%ebx
  801456:	8b 74 24 04          	mov    0x4(%esp),%esi
  80145a:	8b 7c 24 08          	mov    0x8(%esp),%edi
  80145e:	89 ec                	mov    %ebp,%esp
  801460:	5d                   	pop    %ebp
  801461:	c3                   	ret    

00801462 <sys_env_destroy>:
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}

int
sys_env_destroy(envid_t envid)
{
  801462:	55                   	push   %ebp
  801463:	89 e5                	mov    %esp,%ebp
  801465:	83 ec 38             	sub    $0x38,%esp
  801468:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  80146b:	89 75 f8             	mov    %esi,-0x8(%ebp)
  80146e:	89 7d fc             	mov    %edi,-0x4(%ebp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801471:	b9 00 00 00 00       	mov    $0x0,%ecx
  801476:	b8 03 00 00 00       	mov    $0x3,%eax
  80147b:	8b 55 08             	mov    0x8(%ebp),%edx
  80147e:	89 cb                	mov    %ecx,%ebx
  801480:	89 cf                	mov    %ecx,%edi
  801482:	89 ce                	mov    %ecx,%esi
  801484:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
	
	if(check && ret > 0)
  801486:	85 c0                	test   %eax,%eax
  801488:	7e 28                	jle    8014b2 <sys_env_destroy+0x50>
		panic("syscall %d returned %d (> 0)", num, ret);
  80148a:	89 44 24 10          	mov    %eax,0x10(%esp)
  80148e:	c7 44 24 0c 03 00 00 	movl   $0x3,0xc(%esp)
  801495:	00 
  801496:	c7 44 24 08 8f 2e 80 	movl   $0x802e8f,0x8(%esp)
  80149d:	00 
  80149e:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  8014a5:	00 
  8014a6:	c7 04 24 ac 2e 80 00 	movl   $0x802eac,(%esp)
  8014ad:	e8 86 ee ff ff       	call   800338 <_panic>

int
sys_env_destroy(envid_t envid)
{
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  8014b2:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  8014b5:	8b 75 f8             	mov    -0x8(%ebp),%esi
  8014b8:	8b 7d fc             	mov    -0x4(%ebp),%edi
  8014bb:	89 ec                	mov    %ebp,%esp
  8014bd:	5d                   	pop    %ebp
  8014be:	c3                   	ret    
	...

008014c0 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  8014c0:	55                   	push   %ebp
  8014c1:	89 e5                	mov    %esp,%ebp
  8014c3:	8b 45 08             	mov    0x8(%ebp),%eax
  8014c6:	05 00 00 00 30       	add    $0x30000000,%eax
  8014cb:	c1 e8 0c             	shr    $0xc,%eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
}
  8014ce:	5d                   	pop    %ebp
  8014cf:	c3                   	ret    

008014d0 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  8014d0:	55                   	push   %ebp
  8014d1:	89 e5                	mov    %esp,%ebp
  8014d3:	83 ec 04             	sub    $0x4,%esp
	return INDEX2DATA(fd2num(fd));
  8014d6:	8b 45 08             	mov    0x8(%ebp),%eax
  8014d9:	89 04 24             	mov    %eax,(%esp)
  8014dc:	e8 df ff ff ff       	call   8014c0 <fd2num>
  8014e1:	05 20 00 0d 00       	add    $0xd0020,%eax
  8014e6:	c1 e0 0c             	shl    $0xc,%eax
}
  8014e9:	c9                   	leave  
  8014ea:	c3                   	ret    

008014eb <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  8014eb:	55                   	push   %ebp
  8014ec:	89 e5                	mov    %esp,%ebp
  8014ee:	57                   	push   %edi
  8014ef:	56                   	push   %esi
  8014f0:	53                   	push   %ebx
  8014f1:	8b 7d 08             	mov    0x8(%ebp),%edi
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((vpd[PDX(fd)] & PTE_P) == 0 || (vpt[VPN(fd)] & PTE_P) == 0) {
  8014f4:	a1 00 dd 7b ef       	mov    0xef7bdd00,%eax
  8014f9:	a8 01                	test   $0x1,%al
  8014fb:	74 36                	je     801533 <fd_alloc+0x48>
  8014fd:	a1 00 00 74 ef       	mov    0xef740000,%eax
  801502:	a8 01                	test   $0x1,%al
  801504:	74 2d                	je     801533 <fd_alloc+0x48>
  801506:	b8 00 10 00 d0       	mov    $0xd0001000,%eax
  80150b:	b9 00 d0 7b ef       	mov    $0xef7bd000,%ecx
  801510:	be 00 00 40 ef       	mov    $0xef400000,%esi
  801515:	89 c3                	mov    %eax,%ebx
  801517:	89 c2                	mov    %eax,%edx
  801519:	c1 ea 16             	shr    $0x16,%edx
  80151c:	8b 14 91             	mov    (%ecx,%edx,4),%edx
  80151f:	f6 c2 01             	test   $0x1,%dl
  801522:	74 14                	je     801538 <fd_alloc+0x4d>
  801524:	89 c2                	mov    %eax,%edx
  801526:	c1 ea 0c             	shr    $0xc,%edx
  801529:	8b 14 96             	mov    (%esi,%edx,4),%edx
  80152c:	f6 c2 01             	test   $0x1,%dl
  80152f:	75 10                	jne    801541 <fd_alloc+0x56>
  801531:	eb 05                	jmp    801538 <fd_alloc+0x4d>
  801533:	bb 00 00 00 d0       	mov    $0xd0000000,%ebx
			*fd_store = fd;
  801538:	89 1f                	mov    %ebx,(%edi)
  80153a:	b8 00 00 00 00       	mov    $0x0,%eax
			return 0;
  80153f:	eb 17                	jmp    801558 <fd_alloc+0x6d>
  801541:	05 00 10 00 00       	add    $0x1000,%eax
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  801546:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  80154b:	75 c8                	jne    801515 <fd_alloc+0x2a>
		if ((vpd[PDX(fd)] & PTE_P) == 0 || (vpt[VPN(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  80154d:	c7 07 00 00 00 00    	movl   $0x0,(%edi)
  801553:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
	return -E_MAX_OPEN;
}
  801558:	5b                   	pop    %ebx
  801559:	5e                   	pop    %esi
  80155a:	5f                   	pop    %edi
  80155b:	5d                   	pop    %ebp
  80155c:	c3                   	ret    

0080155d <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  80155d:	55                   	push   %ebp
  80155e:	89 e5                	mov    %esp,%ebp
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  801560:	8b 45 08             	mov    0x8(%ebp),%eax
  801563:	83 f8 1f             	cmp    $0x1f,%eax
  801566:	77 36                	ja     80159e <fd_lookup+0x41>
		if (debug)
			cprintf("[%08x] bad fd %d\n", env->env_id, fd);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  801568:	05 00 00 0d 00       	add    $0xd0000,%eax
  80156d:	c1 e0 0c             	shl    $0xc,%eax
	if (!(vpd[PDX(fd)] & PTE_P) || !(vpt[VPN(fd)] & PTE_P)) {
  801570:	89 c2                	mov    %eax,%edx
  801572:	c1 ea 16             	shr    $0x16,%edx
  801575:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  80157c:	f6 c2 01             	test   $0x1,%dl
  80157f:	74 1d                	je     80159e <fd_lookup+0x41>
  801581:	89 c2                	mov    %eax,%edx
  801583:	c1 ea 0c             	shr    $0xc,%edx
  801586:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  80158d:	f6 c2 01             	test   $0x1,%dl
  801590:	74 0c                	je     80159e <fd_lookup+0x41>
		if (debug)
			cprintf("[%08x] closed fd %d\n", env->env_id, fd);
		return -E_INVAL;
	}
	*fd_store = fd;
  801592:	8b 55 0c             	mov    0xc(%ebp),%edx
  801595:	89 02                	mov    %eax,(%edx)
  801597:	b8 00 00 00 00       	mov    $0x0,%eax
	return 0;
  80159c:	eb 05                	jmp    8015a3 <fd_lookup+0x46>
  80159e:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  8015a3:	5d                   	pop    %ebp
  8015a4:	c3                   	ret    

008015a5 <seek>:
	return (*dev->dev_write)(fd, buf, n);
}

int
seek(int fdnum, off_t offset)
{
  8015a5:	55                   	push   %ebp
  8015a6:	89 e5                	mov    %esp,%ebp
  8015a8:	83 ec 18             	sub    $0x18,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8015ab:	8d 45 fc             	lea    -0x4(%ebp),%eax
  8015ae:	89 44 24 04          	mov    %eax,0x4(%esp)
  8015b2:	8b 45 08             	mov    0x8(%ebp),%eax
  8015b5:	89 04 24             	mov    %eax,(%esp)
  8015b8:	e8 a0 ff ff ff       	call   80155d <fd_lookup>
  8015bd:	85 c0                	test   %eax,%eax
  8015bf:	78 0e                	js     8015cf <seek+0x2a>
		return r;
	fd->fd_offset = offset;
  8015c1:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8015c4:	8b 55 0c             	mov    0xc(%ebp),%edx
  8015c7:	89 50 04             	mov    %edx,0x4(%eax)
  8015ca:	b8 00 00 00 00       	mov    $0x0,%eax
	return 0;
}
  8015cf:	c9                   	leave  
  8015d0:	c3                   	ret    

008015d1 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  8015d1:	55                   	push   %ebp
  8015d2:	89 e5                	mov    %esp,%ebp
  8015d4:	56                   	push   %esi
  8015d5:	53                   	push   %ebx
  8015d6:	83 ec 10             	sub    $0x10,%esp
  8015d9:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8015dc:	8b 5d 0c             	mov    0xc(%ebp),%ebx
// File functions
// --------------------------------------------------------------

static struct Dev *devtab[] =
{
	&devfile,
  8015df:	b8 20 60 80 00       	mov    $0x806020,%eax
{
	int i;
	for (i = 0; devtab[i]; i++)
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
  8015e4:	ba 00 00 00 00       	mov    $0x0,%edx

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  8015e9:	be 38 2f 80 00       	mov    $0x802f38,%esi
		if (devtab[i]->dev_id == dev_id) {
  8015ee:	39 08                	cmp    %ecx,(%eax)
  8015f0:	75 10                	jne    801602 <dev_lookup+0x31>
  8015f2:	eb 04                	jmp    8015f8 <dev_lookup+0x27>
  8015f4:	39 08                	cmp    %ecx,(%eax)
  8015f6:	75 0a                	jne    801602 <dev_lookup+0x31>
			*dev = devtab[i];
  8015f8:	89 03                	mov    %eax,(%ebx)
  8015fa:	b8 00 00 00 00       	mov    $0x0,%eax
			return 0;
  8015ff:	90                   	nop
  801600:	eb 31                	jmp    801633 <dev_lookup+0x62>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  801602:	83 c2 01             	add    $0x1,%edx
  801605:	8b 04 96             	mov    (%esi,%edx,4),%eax
  801608:	85 c0                	test   %eax,%eax
  80160a:	75 e8                	jne    8015f4 <dev_lookup+0x23>
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", env->env_id, dev_id);
  80160c:	a1 80 64 80 00       	mov    0x806480,%eax
  801611:	8b 40 4c             	mov    0x4c(%eax),%eax
  801614:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801618:	89 44 24 04          	mov    %eax,0x4(%esp)
  80161c:	c7 04 24 bc 2e 80 00 	movl   $0x802ebc,(%esp)
  801623:	e8 d5 ed ff ff       	call   8003fd <cprintf>
	*dev = 0;
  801628:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  80162e:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
	return -E_INVAL;
}
  801633:	83 c4 10             	add    $0x10,%esp
  801636:	5b                   	pop    %ebx
  801637:	5e                   	pop    %esi
  801638:	5d                   	pop    %ebp
  801639:	c3                   	ret    

0080163a <fstat>:
	return (*dev->dev_trunc)(fd, newsize);
}

int
fstat(int fdnum, struct Stat *stat)
{
  80163a:	55                   	push   %ebp
  80163b:	89 e5                	mov    %esp,%ebp
  80163d:	53                   	push   %ebx
  80163e:	83 ec 24             	sub    $0x24,%esp
  801641:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801644:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801647:	89 44 24 04          	mov    %eax,0x4(%esp)
  80164b:	8b 45 08             	mov    0x8(%ebp),%eax
  80164e:	89 04 24             	mov    %eax,(%esp)
  801651:	e8 07 ff ff ff       	call   80155d <fd_lookup>
  801656:	85 c0                	test   %eax,%eax
  801658:	78 53                	js     8016ad <fstat+0x73>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80165a:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80165d:	89 44 24 04          	mov    %eax,0x4(%esp)
  801661:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801664:	8b 00                	mov    (%eax),%eax
  801666:	89 04 24             	mov    %eax,(%esp)
  801669:	e8 63 ff ff ff       	call   8015d1 <dev_lookup>
{
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80166e:	85 c0                	test   %eax,%eax
  801670:	78 3b                	js     8016ad <fstat+0x73>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if (!dev->dev_stat)
  801672:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801677:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80167a:	83 7a 14 00          	cmpl   $0x0,0x14(%edx)
  80167e:	74 2d                	je     8016ad <fstat+0x73>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  801680:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  801683:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  80168a:	00 00 00 
	stat->st_isdir = 0;
  80168d:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801694:	00 00 00 
	stat->st_dev = dev;
  801697:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80169a:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  8016a0:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8016a4:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8016a7:	89 14 24             	mov    %edx,(%esp)
  8016aa:	ff 50 14             	call   *0x14(%eax)
}
  8016ad:	83 c4 24             	add    $0x24,%esp
  8016b0:	5b                   	pop    %ebx
  8016b1:	5d                   	pop    %ebp
  8016b2:	c3                   	ret    

008016b3 <ftruncate>:
	return 0;
}

int
ftruncate(int fdnum, off_t newsize)
{
  8016b3:	55                   	push   %ebp
  8016b4:	89 e5                	mov    %esp,%ebp
  8016b6:	53                   	push   %ebx
  8016b7:	83 ec 24             	sub    $0x24,%esp
  8016ba:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  8016bd:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8016c0:	89 44 24 04          	mov    %eax,0x4(%esp)
  8016c4:	89 1c 24             	mov    %ebx,(%esp)
  8016c7:	e8 91 fe ff ff       	call   80155d <fd_lookup>
  8016cc:	85 c0                	test   %eax,%eax
  8016ce:	78 5f                	js     80172f <ftruncate+0x7c>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8016d0:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8016d3:	89 44 24 04          	mov    %eax,0x4(%esp)
  8016d7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8016da:	8b 00                	mov    (%eax),%eax
  8016dc:	89 04 24             	mov    %eax,(%esp)
  8016df:	e8 ed fe ff ff       	call   8015d1 <dev_lookup>
ftruncate(int fdnum, off_t newsize)
{
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  8016e4:	85 c0                	test   %eax,%eax
  8016e6:	78 47                	js     80172f <ftruncate+0x7c>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8016e8:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8016eb:	f6 42 08 03          	testb  $0x3,0x8(%edx)
  8016ef:	75 23                	jne    801714 <ftruncate+0x61>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			env->env_id, fdnum); 
  8016f1:	a1 80 64 80 00       	mov    0x806480,%eax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  8016f6:	8b 40 4c             	mov    0x4c(%eax),%eax
  8016f9:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8016fd:	89 44 24 04          	mov    %eax,0x4(%esp)
  801701:	c7 04 24 dc 2e 80 00 	movl   $0x802edc,(%esp)
  801708:	e8 f0 ec ff ff       	call   8003fd <cprintf>
  80170d:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
			env->env_id, fdnum); 
		return -E_INVAL;
  801712:	eb 1b                	jmp    80172f <ftruncate+0x7c>
	}
	if (!dev->dev_trunc)
  801714:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801717:	8b 48 18             	mov    0x18(%eax),%ecx
  80171a:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  80171f:	85 c9                	test   %ecx,%ecx
  801721:	74 0c                	je     80172f <ftruncate+0x7c>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  801723:	8b 45 0c             	mov    0xc(%ebp),%eax
  801726:	89 44 24 04          	mov    %eax,0x4(%esp)
  80172a:	89 14 24             	mov    %edx,(%esp)
  80172d:	ff d1                	call   *%ecx
}
  80172f:	83 c4 24             	add    $0x24,%esp
  801732:	5b                   	pop    %ebx
  801733:	5d                   	pop    %ebp
  801734:	c3                   	ret    

00801735 <write>:
	return tot;
}

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  801735:	55                   	push   %ebp
  801736:	89 e5                	mov    %esp,%ebp
  801738:	53                   	push   %ebx
  801739:	83 ec 24             	sub    $0x24,%esp
  80173c:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80173f:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801742:	89 44 24 04          	mov    %eax,0x4(%esp)
  801746:	89 1c 24             	mov    %ebx,(%esp)
  801749:	e8 0f fe ff ff       	call   80155d <fd_lookup>
  80174e:	85 c0                	test   %eax,%eax
  801750:	78 66                	js     8017b8 <write+0x83>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801752:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801755:	89 44 24 04          	mov    %eax,0x4(%esp)
  801759:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80175c:	8b 00                	mov    (%eax),%eax
  80175e:	89 04 24             	mov    %eax,(%esp)
  801761:	e8 6b fe ff ff       	call   8015d1 <dev_lookup>
{
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801766:	85 c0                	test   %eax,%eax
  801768:	78 4e                	js     8017b8 <write+0x83>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  80176a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80176d:	f6 42 08 03          	testb  $0x3,0x8(%edx)
  801771:	75 23                	jne    801796 <write+0x61>
		cprintf("[%08x] write %d -- bad mode\n", env->env_id, fdnum);
  801773:	a1 80 64 80 00       	mov    0x806480,%eax
  801778:	8b 40 4c             	mov    0x4c(%eax),%eax
  80177b:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80177f:	89 44 24 04          	mov    %eax,0x4(%esp)
  801783:	c7 04 24 fd 2e 80 00 	movl   $0x802efd,(%esp)
  80178a:	e8 6e ec ff ff       	call   8003fd <cprintf>
  80178f:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
		return -E_INVAL;
  801794:	eb 22                	jmp    8017b8 <write+0x83>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  801796:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801799:	8b 48 0c             	mov    0xc(%eax),%ecx
  80179c:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8017a1:	85 c9                	test   %ecx,%ecx
  8017a3:	74 13                	je     8017b8 <write+0x83>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  8017a5:	8b 45 10             	mov    0x10(%ebp),%eax
  8017a8:	89 44 24 08          	mov    %eax,0x8(%esp)
  8017ac:	8b 45 0c             	mov    0xc(%ebp),%eax
  8017af:	89 44 24 04          	mov    %eax,0x4(%esp)
  8017b3:	89 14 24             	mov    %edx,(%esp)
  8017b6:	ff d1                	call   *%ecx
}
  8017b8:	83 c4 24             	add    $0x24,%esp
  8017bb:	5b                   	pop    %ebx
  8017bc:	5d                   	pop    %ebp
  8017bd:	c3                   	ret    

008017be <read>:
	return r;
}

ssize_t
read(int fdnum, void *buf, size_t n)
{
  8017be:	55                   	push   %ebp
  8017bf:	89 e5                	mov    %esp,%ebp
  8017c1:	53                   	push   %ebx
  8017c2:	83 ec 24             	sub    $0x24,%esp
  8017c5:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8017c8:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8017cb:	89 44 24 04          	mov    %eax,0x4(%esp)
  8017cf:	89 1c 24             	mov    %ebx,(%esp)
  8017d2:	e8 86 fd ff ff       	call   80155d <fd_lookup>
  8017d7:	85 c0                	test   %eax,%eax
  8017d9:	78 6b                	js     801846 <read+0x88>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8017db:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8017de:	89 44 24 04          	mov    %eax,0x4(%esp)
  8017e2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8017e5:	8b 00                	mov    (%eax),%eax
  8017e7:	89 04 24             	mov    %eax,(%esp)
  8017ea:	e8 e2 fd ff ff       	call   8015d1 <dev_lookup>
{
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8017ef:	85 c0                	test   %eax,%eax
  8017f1:	78 53                	js     801846 <read+0x88>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  8017f3:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8017f6:	8b 42 08             	mov    0x8(%edx),%eax
  8017f9:	83 e0 03             	and    $0x3,%eax
  8017fc:	83 f8 01             	cmp    $0x1,%eax
  8017ff:	75 23                	jne    801824 <read+0x66>
		cprintf("[%08x] read %d -- bad mode\n", env->env_id, fdnum); 
  801801:	a1 80 64 80 00       	mov    0x806480,%eax
  801806:	8b 40 4c             	mov    0x4c(%eax),%eax
  801809:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80180d:	89 44 24 04          	mov    %eax,0x4(%esp)
  801811:	c7 04 24 1a 2f 80 00 	movl   $0x802f1a,(%esp)
  801818:	e8 e0 eb ff ff       	call   8003fd <cprintf>
  80181d:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
		return -E_INVAL;
  801822:	eb 22                	jmp    801846 <read+0x88>
	}
	if (!dev->dev_read)
  801824:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801827:	8b 48 08             	mov    0x8(%eax),%ecx
  80182a:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  80182f:	85 c9                	test   %ecx,%ecx
  801831:	74 13                	je     801846 <read+0x88>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  801833:	8b 45 10             	mov    0x10(%ebp),%eax
  801836:	89 44 24 08          	mov    %eax,0x8(%esp)
  80183a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80183d:	89 44 24 04          	mov    %eax,0x4(%esp)
  801841:	89 14 24             	mov    %edx,(%esp)
  801844:	ff d1                	call   *%ecx
}
  801846:	83 c4 24             	add    $0x24,%esp
  801849:	5b                   	pop    %ebx
  80184a:	5d                   	pop    %ebp
  80184b:	c3                   	ret    

0080184c <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  80184c:	55                   	push   %ebp
  80184d:	89 e5                	mov    %esp,%ebp
  80184f:	57                   	push   %edi
  801850:	56                   	push   %esi
  801851:	53                   	push   %ebx
  801852:	83 ec 1c             	sub    $0x1c,%esp
  801855:	8b 7d 08             	mov    0x8(%ebp),%edi
  801858:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  80185b:	ba 00 00 00 00       	mov    $0x0,%edx
  801860:	bb 00 00 00 00       	mov    $0x0,%ebx
  801865:	b8 00 00 00 00       	mov    $0x0,%eax
  80186a:	85 f6                	test   %esi,%esi
  80186c:	74 29                	je     801897 <readn+0x4b>
		m = read(fdnum, (char*)buf + tot, n - tot);
  80186e:	89 f0                	mov    %esi,%eax
  801870:	29 d0                	sub    %edx,%eax
  801872:	89 44 24 08          	mov    %eax,0x8(%esp)
  801876:	03 55 0c             	add    0xc(%ebp),%edx
  801879:	89 54 24 04          	mov    %edx,0x4(%esp)
  80187d:	89 3c 24             	mov    %edi,(%esp)
  801880:	e8 39 ff ff ff       	call   8017be <read>
		if (m < 0)
  801885:	85 c0                	test   %eax,%eax
  801887:	78 0e                	js     801897 <readn+0x4b>
			return m;
		if (m == 0)
  801889:	85 c0                	test   %eax,%eax
  80188b:	74 08                	je     801895 <readn+0x49>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  80188d:	01 c3                	add    %eax,%ebx
  80188f:	89 da                	mov    %ebx,%edx
  801891:	39 f3                	cmp    %esi,%ebx
  801893:	72 d9                	jb     80186e <readn+0x22>
  801895:	89 d8                	mov    %ebx,%eax
			return m;
		if (m == 0)
			break;
	}
	return tot;
}
  801897:	83 c4 1c             	add    $0x1c,%esp
  80189a:	5b                   	pop    %ebx
  80189b:	5e                   	pop    %esi
  80189c:	5f                   	pop    %edi
  80189d:	5d                   	pop    %ebp
  80189e:	c3                   	ret    

0080189f <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  80189f:	55                   	push   %ebp
  8018a0:	89 e5                	mov    %esp,%ebp
  8018a2:	56                   	push   %esi
  8018a3:	53                   	push   %ebx
  8018a4:	83 ec 20             	sub    $0x20,%esp
  8018a7:	8b 75 08             	mov    0x8(%ebp),%esi
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8018aa:	89 34 24             	mov    %esi,(%esp)
  8018ad:	e8 0e fc ff ff       	call   8014c0 <fd2num>
  8018b2:	8d 55 f4             	lea    -0xc(%ebp),%edx
  8018b5:	89 54 24 04          	mov    %edx,0x4(%esp)
  8018b9:	89 04 24             	mov    %eax,(%esp)
  8018bc:	e8 9c fc ff ff       	call   80155d <fd_lookup>
  8018c1:	89 c3                	mov    %eax,%ebx
  8018c3:	85 c0                	test   %eax,%eax
  8018c5:	78 05                	js     8018cc <fd_close+0x2d>
  8018c7:	3b 75 f4             	cmp    -0xc(%ebp),%esi
  8018ca:	74 0c                	je     8018d8 <fd_close+0x39>
	    || fd != fd2)
		return (must_exist ? r : 0);
  8018cc:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8018d0:	19 c0                	sbb    %eax,%eax
  8018d2:	f7 d0                	not    %eax
  8018d4:	21 c3                	and    %eax,%ebx
  8018d6:	eb 3d                	jmp    801915 <fd_close+0x76>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  8018d8:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8018db:	89 44 24 04          	mov    %eax,0x4(%esp)
  8018df:	8b 06                	mov    (%esi),%eax
  8018e1:	89 04 24             	mov    %eax,(%esp)
  8018e4:	e8 e8 fc ff ff       	call   8015d1 <dev_lookup>
  8018e9:	89 c3                	mov    %eax,%ebx
  8018eb:	85 c0                	test   %eax,%eax
  8018ed:	78 16                	js     801905 <fd_close+0x66>
		if (dev->dev_close)
  8018ef:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8018f2:	8b 40 10             	mov    0x10(%eax),%eax
  8018f5:	bb 00 00 00 00       	mov    $0x0,%ebx
  8018fa:	85 c0                	test   %eax,%eax
  8018fc:	74 07                	je     801905 <fd_close+0x66>
			r = (*dev->dev_close)(fd);
  8018fe:	89 34 24             	mov    %esi,(%esp)
  801901:	ff d0                	call   *%eax
  801903:	89 c3                	mov    %eax,%ebx
		else
			r = 0;
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  801905:	89 74 24 04          	mov    %esi,0x4(%esp)
  801909:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801910:	e8 ca f9 ff ff       	call   8012df <sys_page_unmap>
	return r;
}
  801915:	89 d8                	mov    %ebx,%eax
  801917:	83 c4 20             	add    $0x20,%esp
  80191a:	5b                   	pop    %ebx
  80191b:	5e                   	pop    %esi
  80191c:	5d                   	pop    %ebp
  80191d:	c3                   	ret    

0080191e <close>:
	return -E_INVAL;
}

int
close(int fdnum)
{
  80191e:	55                   	push   %ebp
  80191f:	89 e5                	mov    %esp,%ebp
  801921:	83 ec 28             	sub    $0x28,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801924:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801927:	89 44 24 04          	mov    %eax,0x4(%esp)
  80192b:	8b 45 08             	mov    0x8(%ebp),%eax
  80192e:	89 04 24             	mov    %eax,(%esp)
  801931:	e8 27 fc ff ff       	call   80155d <fd_lookup>
  801936:	85 c0                	test   %eax,%eax
  801938:	78 13                	js     80194d <close+0x2f>
		return r;
	else
		return fd_close(fd, 1);
  80193a:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  801941:	00 
  801942:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801945:	89 04 24             	mov    %eax,(%esp)
  801948:	e8 52 ff ff ff       	call   80189f <fd_close>
}
  80194d:	c9                   	leave  
  80194e:	c3                   	ret    

0080194f <stat>:
	return (*dev->dev_stat)(fd, stat);
}

int
stat(const char *path, struct Stat *stat)
{
  80194f:	55                   	push   %ebp
  801950:	89 e5                	mov    %esp,%ebp
  801952:	83 ec 18             	sub    $0x18,%esp
  801955:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  801958:	89 75 fc             	mov    %esi,-0x4(%ebp)
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  80195b:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  801962:	00 
  801963:	8b 45 08             	mov    0x8(%ebp),%eax
  801966:	89 04 24             	mov    %eax,(%esp)
  801969:	e8 55 03 00 00       	call   801cc3 <open>
  80196e:	89 c3                	mov    %eax,%ebx
  801970:	85 c0                	test   %eax,%eax
  801972:	78 1b                	js     80198f <stat+0x40>
		return fd;
	r = fstat(fd, stat);
  801974:	8b 45 0c             	mov    0xc(%ebp),%eax
  801977:	89 44 24 04          	mov    %eax,0x4(%esp)
  80197b:	89 1c 24             	mov    %ebx,(%esp)
  80197e:	e8 b7 fc ff ff       	call   80163a <fstat>
  801983:	89 c6                	mov    %eax,%esi
	close(fd);
  801985:	89 1c 24             	mov    %ebx,(%esp)
  801988:	e8 91 ff ff ff       	call   80191e <close>
  80198d:	89 f3                	mov    %esi,%ebx
	return r;
}
  80198f:	89 d8                	mov    %ebx,%eax
  801991:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  801994:	8b 75 fc             	mov    -0x4(%ebp),%esi
  801997:	89 ec                	mov    %ebp,%esp
  801999:	5d                   	pop    %ebp
  80199a:	c3                   	ret    

0080199b <close_all>:
		return fd_close(fd, 1);
}

void
close_all(void)
{
  80199b:	55                   	push   %ebp
  80199c:	89 e5                	mov    %esp,%ebp
  80199e:	53                   	push   %ebx
  80199f:	83 ec 14             	sub    $0x14,%esp
  8019a2:	bb 00 00 00 00       	mov    $0x0,%ebx
	int i;
	for (i = 0; i < MAXFD; i++)
		close(i);
  8019a7:	89 1c 24             	mov    %ebx,(%esp)
  8019aa:	e8 6f ff ff ff       	call   80191e <close>

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  8019af:	83 c3 01             	add    $0x1,%ebx
  8019b2:	83 fb 20             	cmp    $0x20,%ebx
  8019b5:	75 f0                	jne    8019a7 <close_all+0xc>
		close(i);
}
  8019b7:	83 c4 14             	add    $0x14,%esp
  8019ba:	5b                   	pop    %ebx
  8019bb:	5d                   	pop    %ebp
  8019bc:	c3                   	ret    

008019bd <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  8019bd:	55                   	push   %ebp
  8019be:	89 e5                	mov    %esp,%ebp
  8019c0:	83 ec 58             	sub    $0x58,%esp
  8019c3:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  8019c6:	89 75 f8             	mov    %esi,-0x8(%ebp)
  8019c9:	89 7d fc             	mov    %edi,-0x4(%ebp)
  8019cc:	8b 7d 0c             	mov    0xc(%ebp),%edi
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  8019cf:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  8019d2:	89 44 24 04          	mov    %eax,0x4(%esp)
  8019d6:	8b 45 08             	mov    0x8(%ebp),%eax
  8019d9:	89 04 24             	mov    %eax,(%esp)
  8019dc:	e8 7c fb ff ff       	call   80155d <fd_lookup>
  8019e1:	89 c3                	mov    %eax,%ebx
  8019e3:	85 c0                	test   %eax,%eax
  8019e5:	0f 88 e0 00 00 00    	js     801acb <dup+0x10e>
		return r;
	close(newfdnum);
  8019eb:	89 3c 24             	mov    %edi,(%esp)
  8019ee:	e8 2b ff ff ff       	call   80191e <close>

	newfd = INDEX2FD(newfdnum);
  8019f3:	8d b7 00 00 0d 00    	lea    0xd0000(%edi),%esi
  8019f9:	c1 e6 0c             	shl    $0xc,%esi
	ova = fd2data(oldfd);
  8019fc:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8019ff:	89 04 24             	mov    %eax,(%esp)
  801a02:	e8 c9 fa ff ff       	call   8014d0 <fd2data>
  801a07:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  801a09:	89 34 24             	mov    %esi,(%esp)
  801a0c:	e8 bf fa ff ff       	call   8014d0 <fd2data>
  801a11:	89 45 d4             	mov    %eax,-0x2c(%ebp)

	if ((vpd[PDX(ova)] & PTE_P) && (vpt[VPN(ova)] & PTE_P))
  801a14:	89 da                	mov    %ebx,%edx
  801a16:	89 d8                	mov    %ebx,%eax
  801a18:	c1 e8 16             	shr    $0x16,%eax
  801a1b:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801a22:	a8 01                	test   $0x1,%al
  801a24:	74 43                	je     801a69 <dup+0xac>
  801a26:	c1 ea 0c             	shr    $0xc,%edx
  801a29:	8b 04 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%eax
  801a30:	a8 01                	test   $0x1,%al
  801a32:	74 35                	je     801a69 <dup+0xac>
		if ((r = sys_page_map(0, ova, 0, nva, vpt[VPN(ova)] & PTE_USER)) < 0)
  801a34:	8b 04 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%eax
  801a3b:	25 07 0e 00 00       	and    $0xe07,%eax
  801a40:	89 44 24 10          	mov    %eax,0x10(%esp)
  801a44:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801a47:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801a4b:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801a52:	00 
  801a53:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801a57:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801a5e:	e8 da f8 ff ff       	call   80133d <sys_page_map>
  801a63:	89 c3                	mov    %eax,%ebx
  801a65:	85 c0                	test   %eax,%eax
  801a67:	78 3f                	js     801aa8 <dup+0xeb>
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, vpt[VPN(oldfd)] & PTE_USER)) < 0)
  801a69:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801a6c:	89 c2                	mov    %eax,%edx
  801a6e:	c1 ea 0c             	shr    $0xc,%edx
  801a71:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801a78:	81 e2 07 0e 00 00    	and    $0xe07,%edx
  801a7e:	89 54 24 10          	mov    %edx,0x10(%esp)
  801a82:	89 74 24 0c          	mov    %esi,0xc(%esp)
  801a86:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801a8d:	00 
  801a8e:	89 44 24 04          	mov    %eax,0x4(%esp)
  801a92:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801a99:	e8 9f f8 ff ff       	call   80133d <sys_page_map>
  801a9e:	89 c3                	mov    %eax,%ebx
  801aa0:	85 c0                	test   %eax,%eax
  801aa2:	78 04                	js     801aa8 <dup+0xeb>
  801aa4:	89 fb                	mov    %edi,%ebx
  801aa6:	eb 23                	jmp    801acb <dup+0x10e>
		goto err;

	return newfdnum;

err:
	sys_page_unmap(0, newfd);
  801aa8:	89 74 24 04          	mov    %esi,0x4(%esp)
  801aac:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801ab3:	e8 27 f8 ff ff       	call   8012df <sys_page_unmap>
	sys_page_unmap(0, nva);
  801ab8:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801abb:	89 44 24 04          	mov    %eax,0x4(%esp)
  801abf:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801ac6:	e8 14 f8 ff ff       	call   8012df <sys_page_unmap>
	return r;
}
  801acb:	89 d8                	mov    %ebx,%eax
  801acd:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  801ad0:	8b 75 f8             	mov    -0x8(%ebp),%esi
  801ad3:	8b 7d fc             	mov    -0x4(%ebp),%edi
  801ad6:	89 ec                	mov    %ebp,%esp
  801ad8:	5d                   	pop    %ebp
  801ad9:	c3                   	ret    
	...

00801adc <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  801adc:	55                   	push   %ebp
  801add:	89 e5                	mov    %esp,%ebp
  801adf:	53                   	push   %ebx
  801ae0:	83 ec 14             	sub    $0x14,%esp
  801ae3:	89 d3                	mov    %edx,%ebx
	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", env->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(envs[1].env_id, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  801ae5:	8b 15 c8 00 c0 ee    	mov    0xeec000c8,%edx
  801aeb:	c7 44 24 0c 07 00 00 	movl   $0x7,0xc(%esp)
  801af2:	00 
  801af3:	c7 44 24 08 00 30 80 	movl   $0x803000,0x8(%esp)
  801afa:	00 
  801afb:	89 44 24 04          	mov    %eax,0x4(%esp)
  801aff:	89 14 24             	mov    %edx,(%esp)
  801b02:	e8 49 0c 00 00       	call   802750 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  801b07:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801b0e:	00 
  801b0f:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801b13:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801b1a:	e8 97 0c 00 00       	call   8027b6 <ipc_recv>
}
  801b1f:	83 c4 14             	add    $0x14,%esp
  801b22:	5b                   	pop    %ebx
  801b23:	5d                   	pop    %ebp
  801b24:	c3                   	ret    

00801b25 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  801b25:	55                   	push   %ebp
  801b26:	89 e5                	mov    %esp,%ebp
  801b28:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  801b2b:	8b 45 08             	mov    0x8(%ebp),%eax
  801b2e:	8b 40 0c             	mov    0xc(%eax),%eax
  801b31:	a3 00 30 80 00       	mov    %eax,0x803000
	fsipcbuf.set_size.req_size = newsize;
  801b36:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b39:	a3 04 30 80 00       	mov    %eax,0x803004
	return fsipc(FSREQ_SET_SIZE, NULL);
  801b3e:	ba 00 00 00 00       	mov    $0x0,%edx
  801b43:	b8 02 00 00 00       	mov    $0x2,%eax
  801b48:	e8 8f ff ff ff       	call   801adc <fsipc>
}
  801b4d:	c9                   	leave  
  801b4e:	c3                   	ret    

00801b4f <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  801b4f:	55                   	push   %ebp
  801b50:	89 e5                	mov    %esp,%ebp
  801b52:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  801b55:	8b 45 08             	mov    0x8(%ebp),%eax
  801b58:	8b 40 0c             	mov    0xc(%eax),%eax
  801b5b:	a3 00 30 80 00       	mov    %eax,0x803000
	return fsipc(FSREQ_FLUSH, NULL);
  801b60:	ba 00 00 00 00       	mov    $0x0,%edx
  801b65:	b8 06 00 00 00       	mov    $0x6,%eax
  801b6a:	e8 6d ff ff ff       	call   801adc <fsipc>
}
  801b6f:	c9                   	leave  
  801b70:	c3                   	ret    

00801b71 <sync>:
}

// Synchronize disk with buffer cache
int
sync(void)
{
  801b71:	55                   	push   %ebp
  801b72:	89 e5                	mov    %esp,%ebp
  801b74:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  801b77:	ba 00 00 00 00       	mov    $0x0,%edx
  801b7c:	b8 08 00 00 00       	mov    $0x8,%eax
  801b81:	e8 56 ff ff ff       	call   801adc <fsipc>
}
  801b86:	c9                   	leave  
  801b87:	c3                   	ret    

00801b88 <devfile_stat>:
	return fsipc(FSREQ_WRITE, NULL);	
}

static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  801b88:	55                   	push   %ebp
  801b89:	89 e5                	mov    %esp,%ebp
  801b8b:	53                   	push   %ebx
  801b8c:	83 ec 14             	sub    $0x14,%esp
  801b8f:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  801b92:	8b 45 08             	mov    0x8(%ebp),%eax
  801b95:	8b 40 0c             	mov    0xc(%eax),%eax
  801b98:	a3 00 30 80 00       	mov    %eax,0x803000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  801b9d:	ba 00 00 00 00       	mov    $0x0,%edx
  801ba2:	b8 05 00 00 00       	mov    $0x5,%eax
  801ba7:	e8 30 ff ff ff       	call   801adc <fsipc>
  801bac:	85 c0                	test   %eax,%eax
  801bae:	78 2b                	js     801bdb <devfile_stat+0x53>
		return r;
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  801bb0:	c7 44 24 04 00 30 80 	movl   $0x803000,0x4(%esp)
  801bb7:	00 
  801bb8:	89 1c 24             	mov    %ebx,(%esp)
  801bbb:	e8 ea ef ff ff       	call   800baa <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  801bc0:	a1 80 30 80 00       	mov    0x803080,%eax
  801bc5:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  801bcb:	a1 84 30 80 00       	mov    0x803084,%eax
  801bd0:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
  801bd6:	b8 00 00 00 00       	mov    $0x0,%eax
	return 0;
}
  801bdb:	83 c4 14             	add    $0x14,%esp
  801bde:	5b                   	pop    %ebx
  801bdf:	5d                   	pop    %ebp
  801be0:	c3                   	ret    

00801be1 <devfile_write>:
// Returns:
//	 The number of bytes successfully written.
//	 < 0 on error.
static ssize_t
devfile_write(struct Fd *fd, const void *buf, size_t n)
{
  801be1:	55                   	push   %ebp
  801be2:	89 e5                	mov    %esp,%ebp
  801be4:	83 ec 18             	sub    $0x18,%esp
  801be7:	8b 45 10             	mov    0x10(%ebp),%eax
  801bea:	3d f8 0f 00 00       	cmp    $0xff8,%eax
  801bef:	76 05                	jbe    801bf6 <devfile_write+0x15>
  801bf1:	b8 f8 0f 00 00       	mov    $0xff8,%eax
	// LAB 5: Your code here
	//panic("devfile_write not implemented");
	
	if (n > (PGSIZE - (sizeof(int) + sizeof(size_t))))
		n = PGSIZE - (sizeof(int) + sizeof(size_t));
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  801bf6:	8b 55 08             	mov    0x8(%ebp),%edx
  801bf9:	8b 52 0c             	mov    0xc(%edx),%edx
  801bfc:	89 15 00 30 80 00    	mov    %edx,0x803000
	fsipcbuf.write.req_n = n;
  801c02:	a3 04 30 80 00       	mov    %eax,0x803004
	memmove (fsipcbuf.write.req_buf, (char*)buf, n);	
  801c07:	89 44 24 08          	mov    %eax,0x8(%esp)
  801c0b:	8b 45 0c             	mov    0xc(%ebp),%eax
  801c0e:	89 44 24 04          	mov    %eax,0x4(%esp)
  801c12:	c7 04 24 08 30 80 00 	movl   $0x803008,(%esp)
  801c19:	e8 47 f1 ff ff       	call   800d65 <memmove>
	return fsipc(FSREQ_WRITE, NULL);	
  801c1e:	ba 00 00 00 00       	mov    $0x0,%edx
  801c23:	b8 04 00 00 00       	mov    $0x4,%eax
  801c28:	e8 af fe ff ff       	call   801adc <fsipc>
}
  801c2d:	c9                   	leave  
  801c2e:	c3                   	ret    

00801c2f <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  801c2f:	55                   	push   %ebp
  801c30:	89 e5                	mov    %esp,%ebp
  801c32:	53                   	push   %ebx
  801c33:	83 ec 14             	sub    $0x14,%esp
	// system server.
	// LAB 5: Your code here
	
	//panic("devfile_read not implemented");
	int r;
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  801c36:	8b 45 08             	mov    0x8(%ebp),%eax
  801c39:	8b 40 0c             	mov    0xc(%eax),%eax
  801c3c:	a3 00 30 80 00       	mov    %eax,0x803000
	fsipcbuf.read.req_n = n;
  801c41:	8b 45 10             	mov    0x10(%ebp),%eax
  801c44:	a3 04 30 80 00       	mov    %eax,0x803004
	if ((r = fsipc(FSREQ_READ, (void*)&fsipcbuf)) < 0)
  801c49:	ba 00 30 80 00       	mov    $0x803000,%edx
  801c4e:	b8 03 00 00 00       	mov    $0x3,%eax
  801c53:	e8 84 fe ff ff       	call   801adc <fsipc>
  801c58:	89 c3                	mov    %eax,%ebx
  801c5a:	85 c0                	test   %eax,%eax
  801c5c:	78 17                	js     801c75 <devfile_read+0x46>
		return r;
	memmove((void*)buf, (void*)fsipcbuf.readRet.ret_buf, r);
  801c5e:	89 44 24 08          	mov    %eax,0x8(%esp)
  801c62:	c7 44 24 04 00 30 80 	movl   $0x803000,0x4(%esp)
  801c69:	00 
  801c6a:	8b 45 0c             	mov    0xc(%ebp),%eax
  801c6d:	89 04 24             	mov    %eax,(%esp)
  801c70:	e8 f0 f0 ff ff       	call   800d65 <memmove>
	return r;
}
  801c75:	89 d8                	mov    %ebx,%eax
  801c77:	83 c4 14             	add    $0x14,%esp
  801c7a:	5b                   	pop    %ebx
  801c7b:	5d                   	pop    %ebp
  801c7c:	c3                   	ret    

00801c7d <remove>:
}

// Delete a file
int
remove(const char *path)
{
  801c7d:	55                   	push   %ebp
  801c7e:	89 e5                	mov    %esp,%ebp
  801c80:	53                   	push   %ebx
  801c81:	83 ec 14             	sub    $0x14,%esp
  801c84:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (strlen(path) >= MAXPATHLEN)
  801c87:	89 1c 24             	mov    %ebx,(%esp)
  801c8a:	e8 d1 ee ff ff       	call   800b60 <strlen>
  801c8f:	89 c2                	mov    %eax,%edx
  801c91:	b8 f4 ff ff ff       	mov    $0xfffffff4,%eax
  801c96:	81 fa ff 03 00 00    	cmp    $0x3ff,%edx
  801c9c:	7f 1f                	jg     801cbd <remove+0x40>
		return -E_BAD_PATH;
	strcpy(fsipcbuf.remove.req_path, path);
  801c9e:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801ca2:	c7 04 24 00 30 80 00 	movl   $0x803000,(%esp)
  801ca9:	e8 fc ee ff ff       	call   800baa <strcpy>
	return fsipc(FSREQ_REMOVE, NULL);
  801cae:	ba 00 00 00 00       	mov    $0x0,%edx
  801cb3:	b8 07 00 00 00       	mov    $0x7,%eax
  801cb8:	e8 1f fe ff ff       	call   801adc <fsipc>
}
  801cbd:	83 c4 14             	add    $0x14,%esp
  801cc0:	5b                   	pop    %ebx
  801cc1:	5d                   	pop    %ebp
  801cc2:	c3                   	ret    

00801cc3 <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  801cc3:	55                   	push   %ebp
  801cc4:	89 e5                	mov    %esp,%ebp
  801cc6:	83 ec 28             	sub    $0x28,%esp
  801cc9:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  801ccc:	89 75 fc             	mov    %esi,-0x4(%ebp)
  801ccf:	8b 75 08             	mov    0x8(%ebp),%esi
	// file descriptor.

	// LAB 5: Your code here.
	// Code added by Swastika / Sandeep
	
	if (strlen(path) >= MAXPATHLEN)
  801cd2:	89 34 24             	mov    %esi,(%esp)
  801cd5:	e8 86 ee ff ff       	call   800b60 <strlen>
  801cda:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  801cdf:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  801ce4:	7f 5e                	jg     801d44 <open+0x81>
		return -E_BAD_PATH;
	struct Fd * fd;
	int  r;
	if ((r = fd_alloc(&fd)) < 0)
  801ce6:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801ce9:	89 04 24             	mov    %eax,(%esp)
  801cec:	e8 fa f7 ff ff       	call   8014eb <fd_alloc>
  801cf1:	89 c3                	mov    %eax,%ebx
  801cf3:	85 c0                	test   %eax,%eax
  801cf5:	78 4d                	js     801d44 <open+0x81>
		return r;
	strcpy (fsipcbuf.open.req_path, path);
  801cf7:	89 74 24 04          	mov    %esi,0x4(%esp)
  801cfb:	c7 04 24 00 30 80 00 	movl   $0x803000,(%esp)
  801d02:	e8 a3 ee ff ff       	call   800baa <strcpy>
	fsipcbuf.open.req_omode = mode;	
  801d07:	8b 45 0c             	mov    0xc(%ebp),%eax
  801d0a:	a3 00 34 80 00       	mov    %eax,0x803400
	if ((r = fsipc(FSREQ_OPEN,(void*)fd)) < 0)
  801d0f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801d12:	b8 01 00 00 00       	mov    $0x1,%eax
  801d17:	e8 c0 fd ff ff       	call   801adc <fsipc>
  801d1c:	89 c3                	mov    %eax,%ebx
  801d1e:	85 c0                	test   %eax,%eax
  801d20:	79 15                	jns    801d37 <open+0x74>
	{
		fd_close(fd,0);
  801d22:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  801d29:	00 
  801d2a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d2d:	89 04 24             	mov    %eax,(%esp)
  801d30:	e8 6a fb ff ff       	call   80189f <fd_close>
		return r; 
  801d35:	eb 0d                	jmp    801d44 <open+0x81>
	}
	return fd2num(fd);
  801d37:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d3a:	89 04 24             	mov    %eax,(%esp)
  801d3d:	e8 7e f7 ff ff       	call   8014c0 <fd2num>
  801d42:	89 c3                	mov    %eax,%ebx
	//panic("open not implemented");
}
  801d44:	89 d8                	mov    %ebx,%eax
  801d46:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  801d49:	8b 75 fc             	mov    -0x4(%ebp),%esi
  801d4c:	89 ec                	mov    %ebp,%esp
  801d4e:	5d                   	pop    %ebp
  801d4f:	c3                   	ret    

00801d50 <writebuf>:
};


static void
writebuf(struct printbuf *b)
{
  801d50:	55                   	push   %ebp
  801d51:	89 e5                	mov    %esp,%ebp
  801d53:	53                   	push   %ebx
  801d54:	83 ec 14             	sub    $0x14,%esp
  801d57:	89 c3                	mov    %eax,%ebx
	if (b->error > 0) {
  801d59:	83 78 0c 00          	cmpl   $0x0,0xc(%eax)
  801d5d:	7e 34                	jle    801d93 <writebuf+0x43>
		ssize_t result = write(b->fd, b->buf, b->idx);
  801d5f:	8b 40 04             	mov    0x4(%eax),%eax
  801d62:	89 44 24 08          	mov    %eax,0x8(%esp)
  801d66:	8d 43 10             	lea    0x10(%ebx),%eax
  801d69:	89 44 24 04          	mov    %eax,0x4(%esp)
  801d6d:	8b 03                	mov    (%ebx),%eax
  801d6f:	89 04 24             	mov    %eax,(%esp)
  801d72:	e8 be f9 ff ff       	call   801735 <write>
		if (result > 0)
  801d77:	85 c0                	test   %eax,%eax
  801d79:	7e 03                	jle    801d7e <writebuf+0x2e>
			b->result += result;
  801d7b:	01 43 08             	add    %eax,0x8(%ebx)
		if (result != b->idx) // error, or wrote less than supplied
  801d7e:	3b 43 04             	cmp    0x4(%ebx),%eax
  801d81:	74 10                	je     801d93 <writebuf+0x43>
			b->error = (result < 0 ? result : 0);
  801d83:	85 c0                	test   %eax,%eax
  801d85:	0f 9f c2             	setg   %dl
  801d88:	0f b6 d2             	movzbl %dl,%edx
  801d8b:	83 ea 01             	sub    $0x1,%edx
  801d8e:	21 d0                	and    %edx,%eax
  801d90:	89 43 0c             	mov    %eax,0xc(%ebx)
	}
}
  801d93:	83 c4 14             	add    $0x14,%esp
  801d96:	5b                   	pop    %ebx
  801d97:	5d                   	pop    %ebp
  801d98:	c3                   	ret    

00801d99 <vfprintf>:
	}
}

int
vfprintf(int fd, const char *fmt, va_list ap)
{
  801d99:	55                   	push   %ebp
  801d9a:	89 e5                	mov    %esp,%ebp
  801d9c:	81 ec 28 01 00 00    	sub    $0x128,%esp
	struct printbuf b;

	b.fd = fd;
  801da2:	8b 45 08             	mov    0x8(%ebp),%eax
  801da5:	89 85 e8 fe ff ff    	mov    %eax,-0x118(%ebp)
	b.idx = 0;
  801dab:	c7 85 ec fe ff ff 00 	movl   $0x0,-0x114(%ebp)
  801db2:	00 00 00 
	b.result = 0;
  801db5:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  801dbc:	00 00 00 
	b.error = 1;
  801dbf:	c7 85 f4 fe ff ff 01 	movl   $0x1,-0x10c(%ebp)
  801dc6:	00 00 00 
	vprintfmt(putch, &b, fmt, ap);
  801dc9:	8b 45 10             	mov    0x10(%ebp),%eax
  801dcc:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801dd0:	8b 45 0c             	mov    0xc(%ebp),%eax
  801dd3:	89 44 24 08          	mov    %eax,0x8(%esp)
  801dd7:	8d 85 e8 fe ff ff    	lea    -0x118(%ebp),%eax
  801ddd:	89 44 24 04          	mov    %eax,0x4(%esp)
  801de1:	c7 04 24 56 1e 80 00 	movl   $0x801e56,(%esp)
  801de8:	e8 c0 e7 ff ff       	call   8005ad <vprintfmt>
	if (b.idx > 0)
  801ded:	83 bd ec fe ff ff 00 	cmpl   $0x0,-0x114(%ebp)
  801df4:	7e 0b                	jle    801e01 <vfprintf+0x68>
		writebuf(&b);
  801df6:	8d 85 e8 fe ff ff    	lea    -0x118(%ebp),%eax
  801dfc:	e8 4f ff ff ff       	call   801d50 <writebuf>

	return (b.result ? b.result : b.error);
  801e01:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
  801e07:	85 c0                	test   %eax,%eax
  801e09:	75 06                	jne    801e11 <vfprintf+0x78>
  801e0b:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  801e11:	c9                   	leave  
  801e12:	c3                   	ret    

00801e13 <printf>:
	return cnt;
}

int
printf(const char *fmt, ...)
{
  801e13:	55                   	push   %ebp
  801e14:	89 e5                	mov    %esp,%ebp
  801e16:	83 ec 18             	sub    $0x18,%esp

	return cnt;
}

int
printf(const char *fmt, ...)
  801e19:	8d 45 0c             	lea    0xc(%ebp),%eax
{
	va_list ap;
	int cnt;

	va_start(ap, fmt);
	cnt = vfprintf(1, fmt, ap);
  801e1c:	89 44 24 08          	mov    %eax,0x8(%esp)
  801e20:	8b 45 08             	mov    0x8(%ebp),%eax
  801e23:	89 44 24 04          	mov    %eax,0x4(%esp)
  801e27:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  801e2e:	e8 66 ff ff ff       	call   801d99 <vfprintf>
	va_end(ap);

	return cnt;
}
  801e33:	c9                   	leave  
  801e34:	c3                   	ret    

00801e35 <fprintf>:
	return (b.result ? b.result : b.error);
}

int
fprintf(int fd, const char *fmt, ...)
{
  801e35:	55                   	push   %ebp
  801e36:	89 e5                	mov    %esp,%ebp
  801e38:	83 ec 18             	sub    $0x18,%esp

	return (b.result ? b.result : b.error);
}

int
fprintf(int fd, const char *fmt, ...)
  801e3b:	8d 45 10             	lea    0x10(%ebp),%eax
{
	va_list ap;
	int cnt;

	va_start(ap, fmt);
	cnt = vfprintf(fd, fmt, ap);
  801e3e:	89 44 24 08          	mov    %eax,0x8(%esp)
  801e42:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e45:	89 44 24 04          	mov    %eax,0x4(%esp)
  801e49:	8b 45 08             	mov    0x8(%ebp),%eax
  801e4c:	89 04 24             	mov    %eax,(%esp)
  801e4f:	e8 45 ff ff ff       	call   801d99 <vfprintf>
	va_end(ap);

	return cnt;
}
  801e54:	c9                   	leave  
  801e55:	c3                   	ret    

00801e56 <putch>:
	}
}

static void
putch(int ch, void *thunk)
{
  801e56:	55                   	push   %ebp
  801e57:	89 e5                	mov    %esp,%ebp
  801e59:	53                   	push   %ebx
  801e5a:	83 ec 04             	sub    $0x4,%esp
	struct printbuf *b = (struct printbuf *) thunk;
  801e5d:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  801e60:	8b 43 04             	mov    0x4(%ebx),%eax
  801e63:	8b 55 08             	mov    0x8(%ebp),%edx
  801e66:	88 54 03 10          	mov    %dl,0x10(%ebx,%eax,1)
  801e6a:	83 c0 01             	add    $0x1,%eax
  801e6d:	89 43 04             	mov    %eax,0x4(%ebx)
	if (b->idx == 256) {
  801e70:	3d 00 01 00 00       	cmp    $0x100,%eax
  801e75:	75 0e                	jne    801e85 <putch+0x2f>
		writebuf(b);
  801e77:	89 d8                	mov    %ebx,%eax
  801e79:	e8 d2 fe ff ff       	call   801d50 <writebuf>
		b->idx = 0;
  801e7e:	c7 43 04 00 00 00 00 	movl   $0x0,0x4(%ebx)
	}
}
  801e85:	83 c4 04             	add    $0x4,%esp
  801e88:	5b                   	pop    %ebx
  801e89:	5d                   	pop    %ebp
  801e8a:	c3                   	ret    
  801e8b:	00 00                	add    %al,(%eax)
  801e8d:	00 00                	add    %al,(%eax)
	...

00801e90 <devsock_stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  801e90:	55                   	push   %ebp
  801e91:	89 e5                	mov    %esp,%ebp
  801e93:	83 ec 18             	sub    $0x18,%esp
	strcpy(stat->st_name, "<sock>");
  801e96:	c7 44 24 04 4c 2f 80 	movl   $0x802f4c,0x4(%esp)
  801e9d:	00 
  801e9e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801ea1:	89 04 24             	mov    %eax,(%esp)
  801ea4:	e8 01 ed ff ff       	call   800baa <strcpy>
	return 0;
}
  801ea9:	b8 00 00 00 00       	mov    $0x0,%eax
  801eae:	c9                   	leave  
  801eaf:	c3                   	ret    

00801eb0 <devsock_close>:
	return nsipc_shutdown(r, how);
}

static int
devsock_close(struct Fd *fd)
{
  801eb0:	55                   	push   %ebp
  801eb1:	89 e5                	mov    %esp,%ebp
  801eb3:	83 ec 18             	sub    $0x18,%esp
	return nsipc_close(fd->fd_sock.sockid);
  801eb6:	8b 45 08             	mov    0x8(%ebp),%eax
  801eb9:	8b 40 0c             	mov    0xc(%eax),%eax
  801ebc:	89 04 24             	mov    %eax,(%esp)
  801ebf:	e8 9e 02 00 00       	call   802162 <nsipc_close>
}
  801ec4:	c9                   	leave  
  801ec5:	c3                   	ret    

00801ec6 <devsock_write>:
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
}

static ssize_t
devsock_write(struct Fd *fd, const void *buf, size_t n)
{
  801ec6:	55                   	push   %ebp
  801ec7:	89 e5                	mov    %esp,%ebp
  801ec9:	83 ec 18             	sub    $0x18,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  801ecc:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  801ed3:	00 
  801ed4:	8b 45 10             	mov    0x10(%ebp),%eax
  801ed7:	89 44 24 08          	mov    %eax,0x8(%esp)
  801edb:	8b 45 0c             	mov    0xc(%ebp),%eax
  801ede:	89 44 24 04          	mov    %eax,0x4(%esp)
  801ee2:	8b 45 08             	mov    0x8(%ebp),%eax
  801ee5:	8b 40 0c             	mov    0xc(%eax),%eax
  801ee8:	89 04 24             	mov    %eax,(%esp)
  801eeb:	e8 ae 02 00 00       	call   80219e <nsipc_send>
}
  801ef0:	c9                   	leave  
  801ef1:	c3                   	ret    

00801ef2 <devsock_read>:
	return nsipc_listen(r, backlog);
}

static ssize_t
devsock_read(struct Fd *fd, void *buf, size_t n)
{
  801ef2:	55                   	push   %ebp
  801ef3:	89 e5                	mov    %esp,%ebp
  801ef5:	83 ec 18             	sub    $0x18,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  801ef8:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  801eff:	00 
  801f00:	8b 45 10             	mov    0x10(%ebp),%eax
  801f03:	89 44 24 08          	mov    %eax,0x8(%esp)
  801f07:	8b 45 0c             	mov    0xc(%ebp),%eax
  801f0a:	89 44 24 04          	mov    %eax,0x4(%esp)
  801f0e:	8b 45 08             	mov    0x8(%ebp),%eax
  801f11:	8b 40 0c             	mov    0xc(%eax),%eax
  801f14:	89 04 24             	mov    %eax,(%esp)
  801f17:	e8 f5 02 00 00       	call   802211 <nsipc_recv>
}
  801f1c:	c9                   	leave  
  801f1d:	c3                   	ret    

00801f1e <alloc_sockfd>:
	return sfd->fd_sock.sockid;
}

static int
alloc_sockfd(int sockid)
{
  801f1e:	55                   	push   %ebp
  801f1f:	89 e5                	mov    %esp,%ebp
  801f21:	56                   	push   %esi
  801f22:	53                   	push   %ebx
  801f23:	83 ec 20             	sub    $0x20,%esp
  801f26:	89 c6                	mov    %eax,%esi
	struct Fd *sfd;
	int r;

	if ((r = fd_alloc(&sfd)) < 0
  801f28:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801f2b:	89 04 24             	mov    %eax,(%esp)
  801f2e:	e8 b8 f5 ff ff       	call   8014eb <fd_alloc>
  801f33:	89 c3                	mov    %eax,%ebx
  801f35:	85 c0                	test   %eax,%eax
  801f37:	78 21                	js     801f5a <alloc_sockfd+0x3c>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U)) < 0) {
  801f39:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  801f40:	00 
  801f41:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f44:	89 44 24 04          	mov    %eax,0x4(%esp)
  801f48:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801f4f:	e8 47 f4 ff ff       	call   80139b <sys_page_alloc>
  801f54:	89 c3                	mov    %eax,%ebx
alloc_sockfd(int sockid)
{
	struct Fd *sfd;
	int r;

	if ((r = fd_alloc(&sfd)) < 0
  801f56:	85 c0                	test   %eax,%eax
  801f58:	79 0a                	jns    801f64 <alloc_sockfd+0x46>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U)) < 0) {
		nsipc_close(sockid);
  801f5a:	89 34 24             	mov    %esi,(%esp)
  801f5d:	e8 00 02 00 00       	call   802162 <nsipc_close>
		return r;
  801f62:	eb 28                	jmp    801f8c <alloc_sockfd+0x6e>
	}

	sfd->fd_dev_id = devsock.dev_id;
  801f64:	8b 15 3c 60 80 00    	mov    0x80603c,%edx
  801f6a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f6d:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  801f6f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f72:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	sfd->fd_sock.sockid = sockid;
  801f79:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f7c:	89 70 0c             	mov    %esi,0xc(%eax)
	return fd2num(sfd);
  801f7f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f82:	89 04 24             	mov    %eax,(%esp)
  801f85:	e8 36 f5 ff ff       	call   8014c0 <fd2num>
  801f8a:	89 c3                	mov    %eax,%ebx
}
  801f8c:	89 d8                	mov    %ebx,%eax
  801f8e:	83 c4 20             	add    $0x20,%esp
  801f91:	5b                   	pop    %ebx
  801f92:	5e                   	pop    %esi
  801f93:	5d                   	pop    %ebp
  801f94:	c3                   	ret    

00801f95 <socket>:
	return 0;
}

int
socket(int domain, int type, int protocol)
{
  801f95:	55                   	push   %ebp
  801f96:	89 e5                	mov    %esp,%ebp
  801f98:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  801f9b:	8b 45 10             	mov    0x10(%ebp),%eax
  801f9e:	89 44 24 08          	mov    %eax,0x8(%esp)
  801fa2:	8b 45 0c             	mov    0xc(%ebp),%eax
  801fa5:	89 44 24 04          	mov    %eax,0x4(%esp)
  801fa9:	8b 45 08             	mov    0x8(%ebp),%eax
  801fac:	89 04 24             	mov    %eax,(%esp)
  801faf:	e8 62 01 00 00       	call   802116 <nsipc_socket>
  801fb4:	85 c0                	test   %eax,%eax
  801fb6:	78 05                	js     801fbd <socket+0x28>
		return r;
	return alloc_sockfd(r);
  801fb8:	e8 61 ff ff ff       	call   801f1e <alloc_sockfd>
}
  801fbd:	c9                   	leave  
  801fbe:	66 90                	xchg   %ax,%ax
  801fc0:	c3                   	ret    

00801fc1 <fd2sockid>:
	.dev_stat =	devsock_stat,
};

static int
fd2sockid(int fd)
{
  801fc1:	55                   	push   %ebp
  801fc2:	89 e5                	mov    %esp,%ebp
  801fc4:	83 ec 28             	sub    $0x28,%esp
	struct Fd *sfd;
	int r;

	if ((r = fd_lookup(fd, &sfd)) < 0)
  801fc7:	8d 55 f4             	lea    -0xc(%ebp),%edx
  801fca:	89 54 24 04          	mov    %edx,0x4(%esp)
  801fce:	89 04 24             	mov    %eax,(%esp)
  801fd1:	e8 87 f5 ff ff       	call   80155d <fd_lookup>
  801fd6:	85 c0                	test   %eax,%eax
  801fd8:	78 15                	js     801fef <fd2sockid+0x2e>
		return r;
	if (sfd->fd_dev_id != devsock.dev_id)
  801fda:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801fdd:	8b 0a                	mov    (%edx),%ecx
  801fdf:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801fe4:	3b 0d 3c 60 80 00    	cmp    0x80603c,%ecx
  801fea:	75 03                	jne    801fef <fd2sockid+0x2e>
		return -E_NOT_SUPP;
	return sfd->fd_sock.sockid;
  801fec:	8b 42 0c             	mov    0xc(%edx),%eax
}
  801fef:	c9                   	leave  
  801ff0:	c3                   	ret    

00801ff1 <listen>:
	return nsipc_connect(r, name, namelen);
}

int
listen(int s, int backlog)
{
  801ff1:	55                   	push   %ebp
  801ff2:	89 e5                	mov    %esp,%ebp
  801ff4:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  801ff7:	8b 45 08             	mov    0x8(%ebp),%eax
  801ffa:	e8 c2 ff ff ff       	call   801fc1 <fd2sockid>
  801fff:	85 c0                	test   %eax,%eax
  802001:	78 0f                	js     802012 <listen+0x21>
		return r;
	return nsipc_listen(r, backlog);
  802003:	8b 55 0c             	mov    0xc(%ebp),%edx
  802006:	89 54 24 04          	mov    %edx,0x4(%esp)
  80200a:	89 04 24             	mov    %eax,(%esp)
  80200d:	e8 2e 01 00 00       	call   802140 <nsipc_listen>
}
  802012:	c9                   	leave  
  802013:	c3                   	ret    

00802014 <connect>:
	return nsipc_close(fd->fd_sock.sockid);
}

int
connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  802014:	55                   	push   %ebp
  802015:	89 e5                	mov    %esp,%ebp
  802017:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  80201a:	8b 45 08             	mov    0x8(%ebp),%eax
  80201d:	e8 9f ff ff ff       	call   801fc1 <fd2sockid>
  802022:	85 c0                	test   %eax,%eax
  802024:	78 16                	js     80203c <connect+0x28>
		return r;
	return nsipc_connect(r, name, namelen);
  802026:	8b 55 10             	mov    0x10(%ebp),%edx
  802029:	89 54 24 08          	mov    %edx,0x8(%esp)
  80202d:	8b 55 0c             	mov    0xc(%ebp),%edx
  802030:	89 54 24 04          	mov    %edx,0x4(%esp)
  802034:	89 04 24             	mov    %eax,(%esp)
  802037:	e8 55 02 00 00       	call   802291 <nsipc_connect>
}
  80203c:	c9                   	leave  
  80203d:	c3                   	ret    

0080203e <shutdown>:
	return nsipc_bind(r, name, namelen);
}

int
shutdown(int s, int how)
{
  80203e:	55                   	push   %ebp
  80203f:	89 e5                	mov    %esp,%ebp
  802041:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  802044:	8b 45 08             	mov    0x8(%ebp),%eax
  802047:	e8 75 ff ff ff       	call   801fc1 <fd2sockid>
  80204c:	85 c0                	test   %eax,%eax
  80204e:	78 0f                	js     80205f <shutdown+0x21>
		return r;
	return nsipc_shutdown(r, how);
  802050:	8b 55 0c             	mov    0xc(%ebp),%edx
  802053:	89 54 24 04          	mov    %edx,0x4(%esp)
  802057:	89 04 24             	mov    %eax,(%esp)
  80205a:	e8 1d 01 00 00       	call   80217c <nsipc_shutdown>
}
  80205f:	c9                   	leave  
  802060:	c3                   	ret    

00802061 <bind>:
	return alloc_sockfd(r);
}

int
bind(int s, struct sockaddr *name, socklen_t namelen)
{
  802061:	55                   	push   %ebp
  802062:	89 e5                	mov    %esp,%ebp
  802064:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  802067:	8b 45 08             	mov    0x8(%ebp),%eax
  80206a:	e8 52 ff ff ff       	call   801fc1 <fd2sockid>
  80206f:	85 c0                	test   %eax,%eax
  802071:	78 16                	js     802089 <bind+0x28>
		return r;
	return nsipc_bind(r, name, namelen);
  802073:	8b 55 10             	mov    0x10(%ebp),%edx
  802076:	89 54 24 08          	mov    %edx,0x8(%esp)
  80207a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80207d:	89 54 24 04          	mov    %edx,0x4(%esp)
  802081:	89 04 24             	mov    %eax,(%esp)
  802084:	e8 47 02 00 00       	call   8022d0 <nsipc_bind>
}
  802089:	c9                   	leave  
  80208a:	c3                   	ret    

0080208b <accept>:
	return fd2num(sfd);
}

int
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  80208b:	55                   	push   %ebp
  80208c:	89 e5                	mov    %esp,%ebp
  80208e:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  802091:	8b 45 08             	mov    0x8(%ebp),%eax
  802094:	e8 28 ff ff ff       	call   801fc1 <fd2sockid>
  802099:	85 c0                	test   %eax,%eax
  80209b:	78 1f                	js     8020bc <accept+0x31>
		return r;
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  80209d:	8b 55 10             	mov    0x10(%ebp),%edx
  8020a0:	89 54 24 08          	mov    %edx,0x8(%esp)
  8020a4:	8b 55 0c             	mov    0xc(%ebp),%edx
  8020a7:	89 54 24 04          	mov    %edx,0x4(%esp)
  8020ab:	89 04 24             	mov    %eax,(%esp)
  8020ae:	e8 5c 02 00 00       	call   80230f <nsipc_accept>
  8020b3:	85 c0                	test   %eax,%eax
  8020b5:	78 05                	js     8020bc <accept+0x31>
		return r;
	return alloc_sockfd(r);
  8020b7:	e8 62 fe ff ff       	call   801f1e <alloc_sockfd>
}
  8020bc:	c9                   	leave  
  8020bd:	8d 76 00             	lea    0x0(%esi),%esi
  8020c0:	c3                   	ret    
	...

008020d0 <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  8020d0:	55                   	push   %ebp
  8020d1:	89 e5                	mov    %esp,%ebp
  8020d3:	83 ec 18             	sub    $0x18,%esp
	if (debug)
		cprintf("[%08x] nsipc %d\n", env->env_id, type);

	ipc_send(envs[2].env_id, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  8020d6:	8b 15 44 01 c0 ee    	mov    0xeec00144,%edx
  8020dc:	c7 44 24 0c 07 00 00 	movl   $0x7,0xc(%esp)
  8020e3:	00 
  8020e4:	c7 44 24 08 00 50 80 	movl   $0x805000,0x8(%esp)
  8020eb:	00 
  8020ec:	89 44 24 04          	mov    %eax,0x4(%esp)
  8020f0:	89 14 24             	mov    %edx,(%esp)
  8020f3:	e8 58 06 00 00       	call   802750 <ipc_send>
	return ipc_recv(NULL, NULL, NULL);
  8020f8:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  8020ff:	00 
  802100:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  802107:	00 
  802108:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80210f:	e8 a2 06 00 00       	call   8027b6 <ipc_recv>
}
  802114:	c9                   	leave  
  802115:	c3                   	ret    

00802116 <nsipc_socket>:
	return nsipc(NSREQ_SEND);
}

int
nsipc_socket(int domain, int type, int protocol)
{
  802116:	55                   	push   %ebp
  802117:	89 e5                	mov    %esp,%ebp
  802119:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  80211c:	8b 45 08             	mov    0x8(%ebp),%eax
  80211f:	a3 00 50 80 00       	mov    %eax,0x805000
	nsipcbuf.socket.req_type = type;
  802124:	8b 45 0c             	mov    0xc(%ebp),%eax
  802127:	a3 04 50 80 00       	mov    %eax,0x805004
	nsipcbuf.socket.req_protocol = protocol;
  80212c:	8b 45 10             	mov    0x10(%ebp),%eax
  80212f:	a3 08 50 80 00       	mov    %eax,0x805008
	return nsipc(NSREQ_SOCKET);
  802134:	b8 09 00 00 00       	mov    $0x9,%eax
  802139:	e8 92 ff ff ff       	call   8020d0 <nsipc>
}
  80213e:	c9                   	leave  
  80213f:	c3                   	ret    

00802140 <nsipc_listen>:
	return nsipc(NSREQ_CONNECT);
}

int
nsipc_listen(int s, int backlog)
{
  802140:	55                   	push   %ebp
  802141:	89 e5                	mov    %esp,%ebp
  802143:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  802146:	8b 45 08             	mov    0x8(%ebp),%eax
  802149:	a3 00 50 80 00       	mov    %eax,0x805000
	nsipcbuf.listen.req_backlog = backlog;
  80214e:	8b 45 0c             	mov    0xc(%ebp),%eax
  802151:	a3 04 50 80 00       	mov    %eax,0x805004
	return nsipc(NSREQ_LISTEN);
  802156:	b8 06 00 00 00       	mov    $0x6,%eax
  80215b:	e8 70 ff ff ff       	call   8020d0 <nsipc>
}
  802160:	c9                   	leave  
  802161:	c3                   	ret    

00802162 <nsipc_close>:
	return nsipc(NSREQ_SHUTDOWN);
}

int
nsipc_close(int s)
{
  802162:	55                   	push   %ebp
  802163:	89 e5                	mov    %esp,%ebp
  802165:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  802168:	8b 45 08             	mov    0x8(%ebp),%eax
  80216b:	a3 00 50 80 00       	mov    %eax,0x805000
	return nsipc(NSREQ_CLOSE);
  802170:	b8 04 00 00 00       	mov    $0x4,%eax
  802175:	e8 56 ff ff ff       	call   8020d0 <nsipc>
}
  80217a:	c9                   	leave  
  80217b:	c3                   	ret    

0080217c <nsipc_shutdown>:
	return nsipc(NSREQ_BIND);
}

int
nsipc_shutdown(int s, int how)
{
  80217c:	55                   	push   %ebp
  80217d:	89 e5                	mov    %esp,%ebp
  80217f:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  802182:	8b 45 08             	mov    0x8(%ebp),%eax
  802185:	a3 00 50 80 00       	mov    %eax,0x805000
	nsipcbuf.shutdown.req_how = how;
  80218a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80218d:	a3 04 50 80 00       	mov    %eax,0x805004
	return nsipc(NSREQ_SHUTDOWN);
  802192:	b8 03 00 00 00       	mov    $0x3,%eax
  802197:	e8 34 ff ff ff       	call   8020d0 <nsipc>
}
  80219c:	c9                   	leave  
  80219d:	c3                   	ret    

0080219e <nsipc_send>:
	return r;
}

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  80219e:	55                   	push   %ebp
  80219f:	89 e5                	mov    %esp,%ebp
  8021a1:	53                   	push   %ebx
  8021a2:	83 ec 14             	sub    $0x14,%esp
  8021a5:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  8021a8:	8b 45 08             	mov    0x8(%ebp),%eax
  8021ab:	a3 00 50 80 00       	mov    %eax,0x805000
	assert(size < 1600);
  8021b0:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  8021b6:	7e 24                	jle    8021dc <nsipc_send+0x3e>
  8021b8:	c7 44 24 0c 58 2f 80 	movl   $0x802f58,0xc(%esp)
  8021bf:	00 
  8021c0:	c7 44 24 08 64 2f 80 	movl   $0x802f64,0x8(%esp)
  8021c7:	00 
  8021c8:	c7 44 24 04 66 00 00 	movl   $0x66,0x4(%esp)
  8021cf:	00 
  8021d0:	c7 04 24 79 2f 80 00 	movl   $0x802f79,(%esp)
  8021d7:	e8 5c e1 ff ff       	call   800338 <_panic>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  8021dc:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8021e0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8021e3:	89 44 24 04          	mov    %eax,0x4(%esp)
  8021e7:	c7 04 24 0c 50 80 00 	movl   $0x80500c,(%esp)
  8021ee:	e8 72 eb ff ff       	call   800d65 <memmove>
	nsipcbuf.send.req_size = size;
  8021f3:	89 1d 04 50 80 00    	mov    %ebx,0x805004
	nsipcbuf.send.req_flags = flags;
  8021f9:	8b 45 14             	mov    0x14(%ebp),%eax
  8021fc:	a3 08 50 80 00       	mov    %eax,0x805008
	return nsipc(NSREQ_SEND);
  802201:	b8 08 00 00 00       	mov    $0x8,%eax
  802206:	e8 c5 fe ff ff       	call   8020d0 <nsipc>
}
  80220b:	83 c4 14             	add    $0x14,%esp
  80220e:	5b                   	pop    %ebx
  80220f:	5d                   	pop    %ebp
  802210:	c3                   	ret    

00802211 <nsipc_recv>:
	return nsipc(NSREQ_LISTEN);
}

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  802211:	55                   	push   %ebp
  802212:	89 e5                	mov    %esp,%ebp
  802214:	56                   	push   %esi
  802215:	53                   	push   %ebx
  802216:	83 ec 10             	sub    $0x10,%esp
  802219:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  80221c:	8b 45 08             	mov    0x8(%ebp),%eax
  80221f:	a3 00 50 80 00       	mov    %eax,0x805000
	nsipcbuf.recv.req_len = len;
  802224:	89 35 04 50 80 00    	mov    %esi,0x805004
	nsipcbuf.recv.req_flags = flags;
  80222a:	8b 45 14             	mov    0x14(%ebp),%eax
  80222d:	a3 08 50 80 00       	mov    %eax,0x805008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  802232:	b8 07 00 00 00       	mov    $0x7,%eax
  802237:	e8 94 fe ff ff       	call   8020d0 <nsipc>
  80223c:	89 c3                	mov    %eax,%ebx
  80223e:	85 c0                	test   %eax,%eax
  802240:	78 46                	js     802288 <nsipc_recv+0x77>
		assert(r < 1600 && r <= len);
  802242:	3d 3f 06 00 00       	cmp    $0x63f,%eax
  802247:	7f 04                	jg     80224d <nsipc_recv+0x3c>
  802249:	39 c6                	cmp    %eax,%esi
  80224b:	7d 24                	jge    802271 <nsipc_recv+0x60>
  80224d:	c7 44 24 0c 85 2f 80 	movl   $0x802f85,0xc(%esp)
  802254:	00 
  802255:	c7 44 24 08 64 2f 80 	movl   $0x802f64,0x8(%esp)
  80225c:	00 
  80225d:	c7 44 24 04 5b 00 00 	movl   $0x5b,0x4(%esp)
  802264:	00 
  802265:	c7 04 24 79 2f 80 00 	movl   $0x802f79,(%esp)
  80226c:	e8 c7 e0 ff ff       	call   800338 <_panic>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  802271:	89 44 24 08          	mov    %eax,0x8(%esp)
  802275:	c7 44 24 04 00 50 80 	movl   $0x805000,0x4(%esp)
  80227c:	00 
  80227d:	8b 45 0c             	mov    0xc(%ebp),%eax
  802280:	89 04 24             	mov    %eax,(%esp)
  802283:	e8 dd ea ff ff       	call   800d65 <memmove>
	}

	return r;
}
  802288:	89 d8                	mov    %ebx,%eax
  80228a:	83 c4 10             	add    $0x10,%esp
  80228d:	5b                   	pop    %ebx
  80228e:	5e                   	pop    %esi
  80228f:	5d                   	pop    %ebp
  802290:	c3                   	ret    

00802291 <nsipc_connect>:
	return nsipc(NSREQ_CLOSE);
}

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  802291:	55                   	push   %ebp
  802292:	89 e5                	mov    %esp,%ebp
  802294:	53                   	push   %ebx
  802295:	83 ec 14             	sub    $0x14,%esp
  802298:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  80229b:	8b 45 08             	mov    0x8(%ebp),%eax
  80229e:	a3 00 50 80 00       	mov    %eax,0x805000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  8022a3:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8022a7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8022aa:	89 44 24 04          	mov    %eax,0x4(%esp)
  8022ae:	c7 04 24 04 50 80 00 	movl   $0x805004,(%esp)
  8022b5:	e8 ab ea ff ff       	call   800d65 <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  8022ba:	89 1d 14 50 80 00    	mov    %ebx,0x805014
	return nsipc(NSREQ_CONNECT);
  8022c0:	b8 05 00 00 00       	mov    $0x5,%eax
  8022c5:	e8 06 fe ff ff       	call   8020d0 <nsipc>
}
  8022ca:	83 c4 14             	add    $0x14,%esp
  8022cd:	5b                   	pop    %ebx
  8022ce:	5d                   	pop    %ebp
  8022cf:	c3                   	ret    

008022d0 <nsipc_bind>:
	return r;
}

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  8022d0:	55                   	push   %ebp
  8022d1:	89 e5                	mov    %esp,%ebp
  8022d3:	53                   	push   %ebx
  8022d4:	83 ec 14             	sub    $0x14,%esp
  8022d7:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  8022da:	8b 45 08             	mov    0x8(%ebp),%eax
  8022dd:	a3 00 50 80 00       	mov    %eax,0x805000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  8022e2:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8022e6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8022e9:	89 44 24 04          	mov    %eax,0x4(%esp)
  8022ed:	c7 04 24 04 50 80 00 	movl   $0x805004,(%esp)
  8022f4:	e8 6c ea ff ff       	call   800d65 <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  8022f9:	89 1d 14 50 80 00    	mov    %ebx,0x805014
	return nsipc(NSREQ_BIND);
  8022ff:	b8 02 00 00 00       	mov    $0x2,%eax
  802304:	e8 c7 fd ff ff       	call   8020d0 <nsipc>
}
  802309:	83 c4 14             	add    $0x14,%esp
  80230c:	5b                   	pop    %ebx
  80230d:	5d                   	pop    %ebp
  80230e:	c3                   	ret    

0080230f <nsipc_accept>:
	return ipc_recv(NULL, NULL, NULL);
}

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  80230f:	55                   	push   %ebp
  802310:	89 e5                	mov    %esp,%ebp
  802312:	83 ec 18             	sub    $0x18,%esp
  802315:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  802318:	89 75 fc             	mov    %esi,-0x4(%ebp)
	int r;
	
	nsipcbuf.accept.req_s = s;
  80231b:	8b 45 08             	mov    0x8(%ebp),%eax
  80231e:	a3 00 50 80 00       	mov    %eax,0x805000
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  802323:	b8 01 00 00 00       	mov    $0x1,%eax
  802328:	e8 a3 fd ff ff       	call   8020d0 <nsipc>
  80232d:	89 c3                	mov    %eax,%ebx
  80232f:	85 c0                	test   %eax,%eax
  802331:	78 25                	js     802358 <nsipc_accept+0x49>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  802333:	be 10 50 80 00       	mov    $0x805010,%esi
  802338:	8b 06                	mov    (%esi),%eax
  80233a:	89 44 24 08          	mov    %eax,0x8(%esp)
  80233e:	c7 44 24 04 00 50 80 	movl   $0x805000,0x4(%esp)
  802345:	00 
  802346:	8b 45 0c             	mov    0xc(%ebp),%eax
  802349:	89 04 24             	mov    %eax,(%esp)
  80234c:	e8 14 ea ff ff       	call   800d65 <memmove>
		*addrlen = ret->ret_addrlen;
  802351:	8b 16                	mov    (%esi),%edx
  802353:	8b 45 10             	mov    0x10(%ebp),%eax
  802356:	89 10                	mov    %edx,(%eax)
	}
	return r;
}
  802358:	89 d8                	mov    %ebx,%eax
  80235a:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  80235d:	8b 75 fc             	mov    -0x4(%ebp),%esi
  802360:	89 ec                	mov    %ebp,%esp
  802362:	5d                   	pop    %ebp
  802363:	c3                   	ret    
	...

00802370 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  802370:	55                   	push   %ebp
  802371:	89 e5                	mov    %esp,%ebp
  802373:	83 ec 18             	sub    $0x18,%esp
  802376:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  802379:	89 75 fc             	mov    %esi,-0x4(%ebp)
  80237c:	8b 75 0c             	mov    0xc(%ebp),%esi
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  80237f:	8b 45 08             	mov    0x8(%ebp),%eax
  802382:	89 04 24             	mov    %eax,(%esp)
  802385:	e8 46 f1 ff ff       	call   8014d0 <fd2data>
  80238a:	89 c3                	mov    %eax,%ebx
	strcpy(stat->st_name, "<pipe>");
  80238c:	c7 44 24 04 9a 2f 80 	movl   $0x802f9a,0x4(%esp)
  802393:	00 
  802394:	89 34 24             	mov    %esi,(%esp)
  802397:	e8 0e e8 ff ff       	call   800baa <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  80239c:	8b 43 04             	mov    0x4(%ebx),%eax
  80239f:	2b 03                	sub    (%ebx),%eax
  8023a1:	89 86 80 00 00 00    	mov    %eax,0x80(%esi)
	stat->st_isdir = 0;
  8023a7:	c7 86 84 00 00 00 00 	movl   $0x0,0x84(%esi)
  8023ae:	00 00 00 
	stat->st_dev = &devpipe;
  8023b1:	c7 86 88 00 00 00 58 	movl   $0x806058,0x88(%esi)
  8023b8:	60 80 00 
	return 0;
}
  8023bb:	b8 00 00 00 00       	mov    $0x0,%eax
  8023c0:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  8023c3:	8b 75 fc             	mov    -0x4(%ebp),%esi
  8023c6:	89 ec                	mov    %ebp,%esp
  8023c8:	5d                   	pop    %ebp
  8023c9:	c3                   	ret    

008023ca <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  8023ca:	55                   	push   %ebp
  8023cb:	89 e5                	mov    %esp,%ebp
  8023cd:	53                   	push   %ebx
  8023ce:	83 ec 14             	sub    $0x14,%esp
  8023d1:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  8023d4:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8023d8:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8023df:	e8 fb ee ff ff       	call   8012df <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  8023e4:	89 1c 24             	mov    %ebx,(%esp)
  8023e7:	e8 e4 f0 ff ff       	call   8014d0 <fd2data>
  8023ec:	89 44 24 04          	mov    %eax,0x4(%esp)
  8023f0:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8023f7:	e8 e3 ee ff ff       	call   8012df <sys_page_unmap>
}
  8023fc:	83 c4 14             	add    $0x14,%esp
  8023ff:	5b                   	pop    %ebx
  802400:	5d                   	pop    %ebp
  802401:	c3                   	ret    

00802402 <_pipeisclosed>:
	return r;
}

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  802402:	55                   	push   %ebp
  802403:	89 e5                	mov    %esp,%ebp
  802405:	57                   	push   %edi
  802406:	56                   	push   %esi
  802407:	53                   	push   %ebx
  802408:	83 ec 2c             	sub    $0x2c,%esp
  80240b:	89 c7                	mov    %eax,%edi
  80240d:	89 55 e4             	mov    %edx,-0x1c(%ebp)
	int n, nn, ret;

	while (1) {
		n = env->env_runs;
  802410:	a1 80 64 80 00       	mov    0x806480,%eax
  802415:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  802418:	89 3c 24             	mov    %edi,(%esp)
  80241b:	e8 00 04 00 00       	call   802820 <pageref>
  802420:	89 c6                	mov    %eax,%esi
  802422:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802425:	89 04 24             	mov    %eax,(%esp)
  802428:	e8 f3 03 00 00       	call   802820 <pageref>
  80242d:	39 c6                	cmp    %eax,%esi
  80242f:	0f 94 c0             	sete   %al
  802432:	0f b6 c0             	movzbl %al,%eax
		nn = env->env_runs;
  802435:	8b 15 80 64 80 00    	mov    0x806480,%edx
  80243b:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  80243e:	39 cb                	cmp    %ecx,%ebx
  802440:	75 08                	jne    80244a <_pipeisclosed+0x48>
			return ret;
		if (n != nn && ret == 1)
			cprintf("pipe race avoided\n", n, env->env_runs, ret);
	}
}
  802442:	83 c4 2c             	add    $0x2c,%esp
  802445:	5b                   	pop    %ebx
  802446:	5e                   	pop    %esi
  802447:	5f                   	pop    %edi
  802448:	5d                   	pop    %ebp
  802449:	c3                   	ret    
		n = env->env_runs;
		ret = pageref(fd) == pageref(p);
		nn = env->env_runs;
		if (n == nn)
			return ret;
		if (n != nn && ret == 1)
  80244a:	83 f8 01             	cmp    $0x1,%eax
  80244d:	75 c1                	jne    802410 <_pipeisclosed+0xe>
			cprintf("pipe race avoided\n", n, env->env_runs, ret);
  80244f:	8b 52 58             	mov    0x58(%edx),%edx
  802452:	89 44 24 0c          	mov    %eax,0xc(%esp)
  802456:	89 54 24 08          	mov    %edx,0x8(%esp)
  80245a:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  80245e:	c7 04 24 a1 2f 80 00 	movl   $0x802fa1,(%esp)
  802465:	e8 93 df ff ff       	call   8003fd <cprintf>
  80246a:	eb a4                	jmp    802410 <_pipeisclosed+0xe>

0080246c <devpipe_write>:
	return i;
}

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  80246c:	55                   	push   %ebp
  80246d:	89 e5                	mov    %esp,%ebp
  80246f:	57                   	push   %edi
  802470:	56                   	push   %esi
  802471:	53                   	push   %ebx
  802472:	83 ec 1c             	sub    $0x1c,%esp
  802475:	8b 75 08             	mov    0x8(%ebp),%esi
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  802478:	89 34 24             	mov    %esi,(%esp)
  80247b:	e8 50 f0 ff ff       	call   8014d0 <fd2data>
  802480:	89 c3                	mov    %eax,%ebx
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			env->env_id, vpt[VPN(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  802482:	bf 00 00 00 00       	mov    $0x0,%edi
  802487:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80248b:	75 54                	jne    8024e1 <devpipe_write+0x75>
  80248d:	eb 60                	jmp    8024ef <devpipe_write+0x83>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  80248f:	89 da                	mov    %ebx,%edx
  802491:	89 f0                	mov    %esi,%eax
  802493:	e8 6a ff ff ff       	call   802402 <_pipeisclosed>
  802498:	85 c0                	test   %eax,%eax
  80249a:	74 07                	je     8024a3 <devpipe_write+0x37>
  80249c:	b8 00 00 00 00       	mov    $0x0,%eax
  8024a1:	eb 53                	jmp    8024f6 <devpipe_write+0x8a>
				return 0;
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  8024a3:	90                   	nop
  8024a4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  8024a8:	e8 4d ef ff ff       	call   8013fa <sys_yield>
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			env->env_id, vpt[VPN(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  8024ad:	8b 43 04             	mov    0x4(%ebx),%eax
  8024b0:	8b 13                	mov    (%ebx),%edx
  8024b2:	83 c2 20             	add    $0x20,%edx
  8024b5:	39 d0                	cmp    %edx,%eax
  8024b7:	73 d6                	jae    80248f <devpipe_write+0x23>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  8024b9:	89 c2                	mov    %eax,%edx
  8024bb:	c1 fa 1f             	sar    $0x1f,%edx
  8024be:	c1 ea 1b             	shr    $0x1b,%edx
  8024c1:	01 d0                	add    %edx,%eax
  8024c3:	83 e0 1f             	and    $0x1f,%eax
  8024c6:	29 d0                	sub    %edx,%eax
  8024c8:	89 c2                	mov    %eax,%edx
  8024ca:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8024cd:	0f b6 04 39          	movzbl (%ecx,%edi,1),%eax
  8024d1:	88 44 13 08          	mov    %al,0x8(%ebx,%edx,1)
		p->p_wpos++;
  8024d5:	83 43 04 01          	addl   $0x1,0x4(%ebx)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			env->env_id, vpt[VPN(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  8024d9:	83 c7 01             	add    $0x1,%edi
  8024dc:	39 7d 10             	cmp    %edi,0x10(%ebp)
  8024df:	76 13                	jbe    8024f4 <devpipe_write+0x88>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  8024e1:	8b 43 04             	mov    0x4(%ebx),%eax
  8024e4:	8b 13                	mov    (%ebx),%edx
  8024e6:	83 c2 20             	add    $0x20,%edx
  8024e9:	39 d0                	cmp    %edx,%eax
  8024eb:	73 a2                	jae    80248f <devpipe_write+0x23>
  8024ed:	eb ca                	jmp    8024b9 <devpipe_write+0x4d>
  8024ef:	bf 00 00 00 00       	mov    $0x0,%edi
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}
	
	return i;
  8024f4:	89 f8                	mov    %edi,%eax
}
  8024f6:	83 c4 1c             	add    $0x1c,%esp
  8024f9:	5b                   	pop    %ebx
  8024fa:	5e                   	pop    %esi
  8024fb:	5f                   	pop    %edi
  8024fc:	5d                   	pop    %ebp
  8024fd:	c3                   	ret    

008024fe <devpipe_read>:
	return _pipeisclosed(fd, p);
}

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  8024fe:	55                   	push   %ebp
  8024ff:	89 e5                	mov    %esp,%ebp
  802501:	83 ec 28             	sub    $0x28,%esp
  802504:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  802507:	89 75 f8             	mov    %esi,-0x8(%ebp)
  80250a:	89 7d fc             	mov    %edi,-0x4(%ebp)
  80250d:	8b 7d 08             	mov    0x8(%ebp),%edi
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  802510:	89 3c 24             	mov    %edi,(%esp)
  802513:	e8 b8 ef ff ff       	call   8014d0 <fd2data>
  802518:	89 c3                	mov    %eax,%ebx
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			env->env_id, vpt[VPN(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  80251a:	be 00 00 00 00       	mov    $0x0,%esi
  80251f:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  802523:	75 4c                	jne    802571 <devpipe_read+0x73>
  802525:	eb 5b                	jmp    802582 <devpipe_read+0x84>
		while (p->p_rpos == p->p_wpos) {
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
				return i;
  802527:	89 f0                	mov    %esi,%eax
  802529:	eb 5e                	jmp    802589 <devpipe_read+0x8b>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  80252b:	89 da                	mov    %ebx,%edx
  80252d:	89 f8                	mov    %edi,%eax
  80252f:	90                   	nop
  802530:	e8 cd fe ff ff       	call   802402 <_pipeisclosed>
  802535:	85 c0                	test   %eax,%eax
  802537:	74 07                	je     802540 <devpipe_read+0x42>
  802539:	b8 00 00 00 00       	mov    $0x0,%eax
  80253e:	eb 49                	jmp    802589 <devpipe_read+0x8b>
				return 0;
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  802540:	e8 b5 ee ff ff       	call   8013fa <sys_yield>
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			env->env_id, vpt[VPN(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  802545:	8b 03                	mov    (%ebx),%eax
  802547:	3b 43 04             	cmp    0x4(%ebx),%eax
  80254a:	74 df                	je     80252b <devpipe_read+0x2d>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  80254c:	89 c2                	mov    %eax,%edx
  80254e:	c1 fa 1f             	sar    $0x1f,%edx
  802551:	c1 ea 1b             	shr    $0x1b,%edx
  802554:	01 d0                	add    %edx,%eax
  802556:	83 e0 1f             	and    $0x1f,%eax
  802559:	29 d0                	sub    %edx,%eax
  80255b:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  802560:	8b 55 0c             	mov    0xc(%ebp),%edx
  802563:	88 04 32             	mov    %al,(%edx,%esi,1)
		p->p_rpos++;
  802566:	83 03 01             	addl   $0x1,(%ebx)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			env->env_id, vpt[VPN(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  802569:	83 c6 01             	add    $0x1,%esi
  80256c:	39 75 10             	cmp    %esi,0x10(%ebp)
  80256f:	76 16                	jbe    802587 <devpipe_read+0x89>
		while (p->p_rpos == p->p_wpos) {
  802571:	8b 03                	mov    (%ebx),%eax
  802573:	3b 43 04             	cmp    0x4(%ebx),%eax
  802576:	75 d4                	jne    80254c <devpipe_read+0x4e>
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  802578:	85 f6                	test   %esi,%esi
  80257a:	75 ab                	jne    802527 <devpipe_read+0x29>
  80257c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802580:	eb a9                	jmp    80252b <devpipe_read+0x2d>
  802582:	be 00 00 00 00       	mov    $0x0,%esi
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  802587:	89 f0                	mov    %esi,%eax
}
  802589:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  80258c:	8b 75 f8             	mov    -0x8(%ebp),%esi
  80258f:	8b 7d fc             	mov    -0x4(%ebp),%edi
  802592:	89 ec                	mov    %ebp,%esp
  802594:	5d                   	pop    %ebp
  802595:	c3                   	ret    

00802596 <pipeisclosed>:
	}
}

int
pipeisclosed(int fdnum)
{
  802596:	55                   	push   %ebp
  802597:	89 e5                	mov    %esp,%ebp
  802599:	83 ec 28             	sub    $0x28,%esp
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80259c:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80259f:	89 44 24 04          	mov    %eax,0x4(%esp)
  8025a3:	8b 45 08             	mov    0x8(%ebp),%eax
  8025a6:	89 04 24             	mov    %eax,(%esp)
  8025a9:	e8 af ef ff ff       	call   80155d <fd_lookup>
  8025ae:	85 c0                	test   %eax,%eax
  8025b0:	78 15                	js     8025c7 <pipeisclosed+0x31>
		return r;
	p = (struct Pipe*) fd2data(fd);
  8025b2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025b5:	89 04 24             	mov    %eax,(%esp)
  8025b8:	e8 13 ef ff ff       	call   8014d0 <fd2data>
	return _pipeisclosed(fd, p);
  8025bd:	89 c2                	mov    %eax,%edx
  8025bf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025c2:	e8 3b fe ff ff       	call   802402 <_pipeisclosed>
}
  8025c7:	c9                   	leave  
  8025c8:	c3                   	ret    

008025c9 <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  8025c9:	55                   	push   %ebp
  8025ca:	89 e5                	mov    %esp,%ebp
  8025cc:	83 ec 48             	sub    $0x48,%esp
  8025cf:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  8025d2:	89 75 f8             	mov    %esi,-0x8(%ebp)
  8025d5:	89 7d fc             	mov    %edi,-0x4(%ebp)
  8025d8:	8b 7d 08             	mov    0x8(%ebp),%edi
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  8025db:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  8025de:	89 04 24             	mov    %eax,(%esp)
  8025e1:	e8 05 ef ff ff       	call   8014eb <fd_alloc>
  8025e6:	89 c3                	mov    %eax,%ebx
  8025e8:	85 c0                	test   %eax,%eax
  8025ea:	0f 88 42 01 00 00    	js     802732 <pipe+0x169>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8025f0:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  8025f7:	00 
  8025f8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8025fb:	89 44 24 04          	mov    %eax,0x4(%esp)
  8025ff:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802606:	e8 90 ed ff ff       	call   80139b <sys_page_alloc>
  80260b:	89 c3                	mov    %eax,%ebx
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  80260d:	85 c0                	test   %eax,%eax
  80260f:	0f 88 1d 01 00 00    	js     802732 <pipe+0x169>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  802615:	8d 45 e0             	lea    -0x20(%ebp),%eax
  802618:	89 04 24             	mov    %eax,(%esp)
  80261b:	e8 cb ee ff ff       	call   8014eb <fd_alloc>
  802620:	89 c3                	mov    %eax,%ebx
  802622:	85 c0                	test   %eax,%eax
  802624:	0f 88 f5 00 00 00    	js     80271f <pipe+0x156>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80262a:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  802631:	00 
  802632:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802635:	89 44 24 04          	mov    %eax,0x4(%esp)
  802639:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802640:	e8 56 ed ff ff       	call   80139b <sys_page_alloc>
  802645:	89 c3                	mov    %eax,%ebx
	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  802647:	85 c0                	test   %eax,%eax
  802649:	0f 88 d0 00 00 00    	js     80271f <pipe+0x156>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  80264f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802652:	89 04 24             	mov    %eax,(%esp)
  802655:	e8 76 ee ff ff       	call   8014d0 <fd2data>
  80265a:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80265c:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  802663:	00 
  802664:	89 44 24 04          	mov    %eax,0x4(%esp)
  802668:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80266f:	e8 27 ed ff ff       	call   80139b <sys_page_alloc>
  802674:	89 c3                	mov    %eax,%ebx
  802676:	85 c0                	test   %eax,%eax
  802678:	0f 88 8e 00 00 00    	js     80270c <pipe+0x143>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80267e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802681:	89 04 24             	mov    %eax,(%esp)
  802684:	e8 47 ee ff ff       	call   8014d0 <fd2data>
  802689:	c7 44 24 10 07 04 00 	movl   $0x407,0x10(%esp)
  802690:	00 
  802691:	89 44 24 0c          	mov    %eax,0xc(%esp)
  802695:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  80269c:	00 
  80269d:	89 74 24 04          	mov    %esi,0x4(%esp)
  8026a1:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8026a8:	e8 90 ec ff ff       	call   80133d <sys_page_map>
  8026ad:	89 c3                	mov    %eax,%ebx
  8026af:	85 c0                	test   %eax,%eax
  8026b1:	78 49                	js     8026fc <pipe+0x133>
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  8026b3:	b8 58 60 80 00       	mov    $0x806058,%eax
  8026b8:	8b 08                	mov    (%eax),%ecx
  8026ba:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8026bd:	89 0a                	mov    %ecx,(%edx)
	fd0->fd_omode = O_RDONLY;
  8026bf:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8026c2:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%edx)

	fd1->fd_dev_id = devpipe.dev_id;
  8026c9:	8b 10                	mov    (%eax),%edx
  8026cb:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8026ce:	89 10                	mov    %edx,(%eax)
	fd1->fd_omode = O_WRONLY;
  8026d0:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8026d3:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", env->env_id, vpt[VPN(va)]);

	pfd[0] = fd2num(fd0);
  8026da:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8026dd:	89 04 24             	mov    %eax,(%esp)
  8026e0:	e8 db ed ff ff       	call   8014c0 <fd2num>
  8026e5:	89 07                	mov    %eax,(%edi)
	pfd[1] = fd2num(fd1);
  8026e7:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8026ea:	89 04 24             	mov    %eax,(%esp)
  8026ed:	e8 ce ed ff ff       	call   8014c0 <fd2num>
  8026f2:	89 47 04             	mov    %eax,0x4(%edi)
  8026f5:	bb 00 00 00 00       	mov    $0x0,%ebx
	return 0;
  8026fa:	eb 36                	jmp    802732 <pipe+0x169>

    err3:
	sys_page_unmap(0, va);
  8026fc:	89 74 24 04          	mov    %esi,0x4(%esp)
  802700:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802707:	e8 d3 eb ff ff       	call   8012df <sys_page_unmap>
    err2:
	sys_page_unmap(0, fd1);
  80270c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80270f:	89 44 24 04          	mov    %eax,0x4(%esp)
  802713:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80271a:	e8 c0 eb ff ff       	call   8012df <sys_page_unmap>
    err1:
	sys_page_unmap(0, fd0);
  80271f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802722:	89 44 24 04          	mov    %eax,0x4(%esp)
  802726:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80272d:	e8 ad eb ff ff       	call   8012df <sys_page_unmap>
    err:
	return r;
}
  802732:	89 d8                	mov    %ebx,%eax
  802734:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  802737:	8b 75 f8             	mov    -0x8(%ebp),%esi
  80273a:	8b 7d fc             	mov    -0x4(%ebp),%edi
  80273d:	89 ec                	mov    %ebp,%esp
  80273f:	5d                   	pop    %ebp
  802740:	c3                   	ret    
	...

00802750 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  802750:	55                   	push   %ebp
  802751:	89 e5                	mov    %esp,%ebp
  802753:	57                   	push   %edi
  802754:	56                   	push   %esi
  802755:	53                   	push   %ebx
  802756:	83 ec 1c             	sub    $0x1c,%esp
  802759:	8b 7d 0c             	mov    0xc(%ebp),%edi
  80275c:	8b 5d 10             	mov    0x10(%ebp),%ebx
  80275f:	8b 75 14             	mov    0x14(%ebp),%esi
	// LAB 4: Your code here.
	int r;
	if (pg == NULL)
  802762:	85 db                	test   %ebx,%ebx
  802764:	75 2d                	jne    802793 <ipc_send+0x43>
  802766:	bb 00 00 c0 ee       	mov    $0xeec00000,%ebx
  80276b:	eb 26                	jmp    802793 <ipc_send+0x43>
		pg = (void*)UTOP;
	while ((r = sys_ipc_try_send(to_env, val, pg, perm)) < 0)
	{
		if(r != -E_IPC_NOT_RECV)
  80276d:	83 f8 f9             	cmp    $0xfffffff9,%eax
  802770:	74 1c                	je     80278e <ipc_send+0x3e>
			panic("Panic in lib ipc.c : ipc_send() \n");
  802772:	c7 44 24 08 bc 2f 80 	movl   $0x802fbc,0x8(%esp)
  802779:	00 
  80277a:	c7 44 24 04 44 00 00 	movl   $0x44,0x4(%esp)
  802781:	00 
  802782:	c7 04 24 e0 2f 80 00 	movl   $0x802fe0,(%esp)
  802789:	e8 aa db ff ff       	call   800338 <_panic>
		sys_yield();
  80278e:	e8 67 ec ff ff       	call   8013fa <sys_yield>
{
	// LAB 4: Your code here.
	int r;
	if (pg == NULL)
		pg = (void*)UTOP;
	while ((r = sys_ipc_try_send(to_env, val, pg, perm)) < 0)
  802793:	89 74 24 0c          	mov    %esi,0xc(%esp)
  802797:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80279b:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80279f:	8b 45 08             	mov    0x8(%ebp),%eax
  8027a2:	89 04 24             	mov    %eax,(%esp)
  8027a5:	e8 e3 e9 ff ff       	call   80118d <sys_ipc_try_send>
  8027aa:	85 c0                	test   %eax,%eax
  8027ac:	78 bf                	js     80276d <ipc_send+0x1d>
		if(r != -E_IPC_NOT_RECV)
			panic("Panic in lib ipc.c : ipc_send() \n");
		sys_yield();
	}
	//panic("ipc_send not implemented");
}
  8027ae:	83 c4 1c             	add    $0x1c,%esp
  8027b1:	5b                   	pop    %ebx
  8027b2:	5e                   	pop    %esi
  8027b3:	5f                   	pop    %edi
  8027b4:	5d                   	pop    %ebp
  8027b5:	c3                   	ret    

008027b6 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  8027b6:	55                   	push   %ebp
  8027b7:	89 e5                	mov    %esp,%ebp
  8027b9:	56                   	push   %esi
  8027ba:	53                   	push   %ebx
  8027bb:	83 ec 10             	sub    $0x10,%esp
  8027be:	8b 5d 08             	mov    0x8(%ebp),%ebx
  8027c1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8027c4:	8b 75 10             	mov    0x10(%ebp),%esi
	// LAB 4: Your code here.
	int r;

	if (pg == NULL)
  8027c7:	85 c0                	test   %eax,%eax
  8027c9:	75 05                	jne    8027d0 <ipc_recv+0x1a>
  8027cb:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
		pg = (void*)UTOP;
	if ((r = sys_ipc_recv(pg)) < 0)
  8027d0:	89 04 24             	mov    %eax,(%esp)
  8027d3:	e8 58 e9 ff ff       	call   801130 <sys_ipc_recv>
  8027d8:	85 c0                	test   %eax,%eax
  8027da:	79 16                	jns    8027f2 <ipc_recv+0x3c>
	{
		if (from_env_store != NULL)
  8027dc:	85 db                	test   %ebx,%ebx
  8027de:	74 06                	je     8027e6 <ipc_recv+0x30>
			*from_env_store = 0;
  8027e0:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
		if(perm_store != NULL)
  8027e6:	85 f6                	test   %esi,%esi
  8027e8:	74 2c                	je     802816 <ipc_recv+0x60>
			*perm_store = 0;
  8027ea:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
  8027f0:	eb 24                	jmp    802816 <ipc_recv+0x60>
		return r;
	}
	else
	{	
		if (from_env_store != NULL)
  8027f2:	85 db                	test   %ebx,%ebx
  8027f4:	74 0a                	je     802800 <ipc_recv+0x4a>
			*from_env_store = env->env_ipc_from;
  8027f6:	a1 80 64 80 00       	mov    0x806480,%eax
  8027fb:	8b 40 74             	mov    0x74(%eax),%eax
  8027fe:	89 03                	mov    %eax,(%ebx)
		if(perm_store != NULL)
  802800:	85 f6                	test   %esi,%esi
  802802:	74 0a                	je     80280e <ipc_recv+0x58>
			*perm_store = env->env_ipc_perm;
  802804:	a1 80 64 80 00       	mov    0x806480,%eax
  802809:	8b 40 78             	mov    0x78(%eax),%eax
  80280c:	89 06                	mov    %eax,(%esi)
		return env->env_ipc_value;
  80280e:	a1 80 64 80 00       	mov    0x806480,%eax
  802813:	8b 40 70             	mov    0x70(%eax),%eax
	}		
	//panic("ipc_recv not implemented");
	//return 0;
}
  802816:	83 c4 10             	add    $0x10,%esp
  802819:	5b                   	pop    %ebx
  80281a:	5e                   	pop    %esi
  80281b:	5d                   	pop    %ebp
  80281c:	c3                   	ret    
  80281d:	00 00                	add    %al,(%eax)
	...

00802820 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  802820:	55                   	push   %ebp
  802821:	89 e5                	mov    %esp,%ebp
	pte_t pte;

	if (!(vpd[PDX(v)] & PTE_P))
  802823:	8b 45 08             	mov    0x8(%ebp),%eax
  802826:	89 c2                	mov    %eax,%edx
  802828:	c1 ea 16             	shr    $0x16,%edx
  80282b:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  802832:	f6 c2 01             	test   $0x1,%dl
  802835:	74 26                	je     80285d <pageref+0x3d>
		return 0;
	pte = vpt[VPN(v)];
  802837:	c1 e8 0c             	shr    $0xc,%eax
  80283a:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
	if (!(pte & PTE_P))
  802841:	a8 01                	test   $0x1,%al
  802843:	74 18                	je     80285d <pageref+0x3d>
		return 0;
	return pages[PPN(pte)].pp_ref;
  802845:	c1 e8 0c             	shr    $0xc,%eax
  802848:	8d 14 40             	lea    (%eax,%eax,2),%edx
  80284b:	c1 e2 02             	shl    $0x2,%edx
  80284e:	b8 00 00 00 ef       	mov    $0xef000000,%eax
  802853:	0f b7 44 02 08       	movzwl 0x8(%edx,%eax,1),%eax
  802858:	0f b7 c0             	movzwl %ax,%eax
  80285b:	eb 05                	jmp    802862 <pageref+0x42>
  80285d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802862:	5d                   	pop    %ebp
  802863:	c3                   	ret    
	...

00802870 <__udivdi3>:
  802870:	55                   	push   %ebp
  802871:	89 e5                	mov    %esp,%ebp
  802873:	57                   	push   %edi
  802874:	56                   	push   %esi
  802875:	83 ec 10             	sub    $0x10,%esp
  802878:	8b 45 14             	mov    0x14(%ebp),%eax
  80287b:	8b 55 08             	mov    0x8(%ebp),%edx
  80287e:	8b 75 10             	mov    0x10(%ebp),%esi
  802881:	8b 7d 0c             	mov    0xc(%ebp),%edi
  802884:	85 c0                	test   %eax,%eax
  802886:	89 55 f0             	mov    %edx,-0x10(%ebp)
  802889:	75 35                	jne    8028c0 <__udivdi3+0x50>
  80288b:	39 fe                	cmp    %edi,%esi
  80288d:	77 61                	ja     8028f0 <__udivdi3+0x80>
  80288f:	85 f6                	test   %esi,%esi
  802891:	75 0b                	jne    80289e <__udivdi3+0x2e>
  802893:	b8 01 00 00 00       	mov    $0x1,%eax
  802898:	31 d2                	xor    %edx,%edx
  80289a:	f7 f6                	div    %esi
  80289c:	89 c6                	mov    %eax,%esi
  80289e:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  8028a1:	31 d2                	xor    %edx,%edx
  8028a3:	89 f8                	mov    %edi,%eax
  8028a5:	f7 f6                	div    %esi
  8028a7:	89 c7                	mov    %eax,%edi
  8028a9:	89 c8                	mov    %ecx,%eax
  8028ab:	f7 f6                	div    %esi
  8028ad:	89 c1                	mov    %eax,%ecx
  8028af:	89 fa                	mov    %edi,%edx
  8028b1:	89 c8                	mov    %ecx,%eax
  8028b3:	83 c4 10             	add    $0x10,%esp
  8028b6:	5e                   	pop    %esi
  8028b7:	5f                   	pop    %edi
  8028b8:	5d                   	pop    %ebp
  8028b9:	c3                   	ret    
  8028ba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  8028c0:	39 f8                	cmp    %edi,%eax
  8028c2:	77 1c                	ja     8028e0 <__udivdi3+0x70>
  8028c4:	0f bd d0             	bsr    %eax,%edx
  8028c7:	83 f2 1f             	xor    $0x1f,%edx
  8028ca:	89 55 f4             	mov    %edx,-0xc(%ebp)
  8028cd:	75 39                	jne    802908 <__udivdi3+0x98>
  8028cf:	3b 75 f0             	cmp    -0x10(%ebp),%esi
  8028d2:	0f 86 a0 00 00 00    	jbe    802978 <__udivdi3+0x108>
  8028d8:	39 f8                	cmp    %edi,%eax
  8028da:	0f 82 98 00 00 00    	jb     802978 <__udivdi3+0x108>
  8028e0:	31 ff                	xor    %edi,%edi
  8028e2:	31 c9                	xor    %ecx,%ecx
  8028e4:	89 c8                	mov    %ecx,%eax
  8028e6:	89 fa                	mov    %edi,%edx
  8028e8:	83 c4 10             	add    $0x10,%esp
  8028eb:	5e                   	pop    %esi
  8028ec:	5f                   	pop    %edi
  8028ed:	5d                   	pop    %ebp
  8028ee:	c3                   	ret    
  8028ef:	90                   	nop
  8028f0:	89 d1                	mov    %edx,%ecx
  8028f2:	89 fa                	mov    %edi,%edx
  8028f4:	89 c8                	mov    %ecx,%eax
  8028f6:	31 ff                	xor    %edi,%edi
  8028f8:	f7 f6                	div    %esi
  8028fa:	89 c1                	mov    %eax,%ecx
  8028fc:	89 fa                	mov    %edi,%edx
  8028fe:	89 c8                	mov    %ecx,%eax
  802900:	83 c4 10             	add    $0x10,%esp
  802903:	5e                   	pop    %esi
  802904:	5f                   	pop    %edi
  802905:	5d                   	pop    %ebp
  802906:	c3                   	ret    
  802907:	90                   	nop
  802908:	0f b6 4d f4          	movzbl -0xc(%ebp),%ecx
  80290c:	89 f2                	mov    %esi,%edx
  80290e:	d3 e0                	shl    %cl,%eax
  802910:	89 45 ec             	mov    %eax,-0x14(%ebp)
  802913:	b8 20 00 00 00       	mov    $0x20,%eax
  802918:	2b 45 f4             	sub    -0xc(%ebp),%eax
  80291b:	89 c1                	mov    %eax,%ecx
  80291d:	d3 ea                	shr    %cl,%edx
  80291f:	0f b6 4d f4          	movzbl -0xc(%ebp),%ecx
  802923:	0b 55 ec             	or     -0x14(%ebp),%edx
  802926:	d3 e6                	shl    %cl,%esi
  802928:	89 c1                	mov    %eax,%ecx
  80292a:	89 75 e8             	mov    %esi,-0x18(%ebp)
  80292d:	89 fe                	mov    %edi,%esi
  80292f:	d3 ee                	shr    %cl,%esi
  802931:	0f b6 4d f4          	movzbl -0xc(%ebp),%ecx
  802935:	89 55 ec             	mov    %edx,-0x14(%ebp)
  802938:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80293b:	d3 e7                	shl    %cl,%edi
  80293d:	89 c1                	mov    %eax,%ecx
  80293f:	d3 ea                	shr    %cl,%edx
  802941:	09 d7                	or     %edx,%edi
  802943:	89 f2                	mov    %esi,%edx
  802945:	89 f8                	mov    %edi,%eax
  802947:	f7 75 ec             	divl   -0x14(%ebp)
  80294a:	89 d6                	mov    %edx,%esi
  80294c:	89 c7                	mov    %eax,%edi
  80294e:	f7 65 e8             	mull   -0x18(%ebp)
  802951:	39 d6                	cmp    %edx,%esi
  802953:	89 55 ec             	mov    %edx,-0x14(%ebp)
  802956:	72 30                	jb     802988 <__udivdi3+0x118>
  802958:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80295b:	0f b6 4d f4          	movzbl -0xc(%ebp),%ecx
  80295f:	d3 e2                	shl    %cl,%edx
  802961:	39 c2                	cmp    %eax,%edx
  802963:	73 05                	jae    80296a <__udivdi3+0xfa>
  802965:	3b 75 ec             	cmp    -0x14(%ebp),%esi
  802968:	74 1e                	je     802988 <__udivdi3+0x118>
  80296a:	89 f9                	mov    %edi,%ecx
  80296c:	31 ff                	xor    %edi,%edi
  80296e:	e9 71 ff ff ff       	jmp    8028e4 <__udivdi3+0x74>
  802973:	90                   	nop
  802974:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802978:	31 ff                	xor    %edi,%edi
  80297a:	b9 01 00 00 00       	mov    $0x1,%ecx
  80297f:	e9 60 ff ff ff       	jmp    8028e4 <__udivdi3+0x74>
  802984:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802988:	8d 4f ff             	lea    -0x1(%edi),%ecx
  80298b:	31 ff                	xor    %edi,%edi
  80298d:	89 c8                	mov    %ecx,%eax
  80298f:	89 fa                	mov    %edi,%edx
  802991:	83 c4 10             	add    $0x10,%esp
  802994:	5e                   	pop    %esi
  802995:	5f                   	pop    %edi
  802996:	5d                   	pop    %ebp
  802997:	c3                   	ret    
	...

008029a0 <__umoddi3>:
  8029a0:	55                   	push   %ebp
  8029a1:	89 e5                	mov    %esp,%ebp
  8029a3:	57                   	push   %edi
  8029a4:	56                   	push   %esi
  8029a5:	83 ec 20             	sub    $0x20,%esp
  8029a8:	8b 55 14             	mov    0x14(%ebp),%edx
  8029ab:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8029ae:	8b 7d 10             	mov    0x10(%ebp),%edi
  8029b1:	8b 75 0c             	mov    0xc(%ebp),%esi
  8029b4:	85 d2                	test   %edx,%edx
  8029b6:	89 c8                	mov    %ecx,%eax
  8029b8:	89 4d f4             	mov    %ecx,-0xc(%ebp)
  8029bb:	75 13                	jne    8029d0 <__umoddi3+0x30>
  8029bd:	39 f7                	cmp    %esi,%edi
  8029bf:	76 3f                	jbe    802a00 <__umoddi3+0x60>
  8029c1:	89 f2                	mov    %esi,%edx
  8029c3:	f7 f7                	div    %edi
  8029c5:	89 d0                	mov    %edx,%eax
  8029c7:	31 d2                	xor    %edx,%edx
  8029c9:	83 c4 20             	add    $0x20,%esp
  8029cc:	5e                   	pop    %esi
  8029cd:	5f                   	pop    %edi
  8029ce:	5d                   	pop    %ebp
  8029cf:	c3                   	ret    
  8029d0:	39 f2                	cmp    %esi,%edx
  8029d2:	77 4c                	ja     802a20 <__umoddi3+0x80>
  8029d4:	0f bd ca             	bsr    %edx,%ecx
  8029d7:	83 f1 1f             	xor    $0x1f,%ecx
  8029da:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  8029dd:	75 51                	jne    802a30 <__umoddi3+0x90>
  8029df:	3b 7d f4             	cmp    -0xc(%ebp),%edi
  8029e2:	0f 87 e0 00 00 00    	ja     802ac8 <__umoddi3+0x128>
  8029e8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029eb:	29 f8                	sub    %edi,%eax
  8029ed:	19 d6                	sbb    %edx,%esi
  8029ef:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8029f2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029f5:	89 f2                	mov    %esi,%edx
  8029f7:	83 c4 20             	add    $0x20,%esp
  8029fa:	5e                   	pop    %esi
  8029fb:	5f                   	pop    %edi
  8029fc:	5d                   	pop    %ebp
  8029fd:	c3                   	ret    
  8029fe:	66 90                	xchg   %ax,%ax
  802a00:	85 ff                	test   %edi,%edi
  802a02:	75 0b                	jne    802a0f <__umoddi3+0x6f>
  802a04:	b8 01 00 00 00       	mov    $0x1,%eax
  802a09:	31 d2                	xor    %edx,%edx
  802a0b:	f7 f7                	div    %edi
  802a0d:	89 c7                	mov    %eax,%edi
  802a0f:	89 f0                	mov    %esi,%eax
  802a11:	31 d2                	xor    %edx,%edx
  802a13:	f7 f7                	div    %edi
  802a15:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a18:	f7 f7                	div    %edi
  802a1a:	eb a9                	jmp    8029c5 <__umoddi3+0x25>
  802a1c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802a20:	89 c8                	mov    %ecx,%eax
  802a22:	89 f2                	mov    %esi,%edx
  802a24:	83 c4 20             	add    $0x20,%esp
  802a27:	5e                   	pop    %esi
  802a28:	5f                   	pop    %edi
  802a29:	5d                   	pop    %ebp
  802a2a:	c3                   	ret    
  802a2b:	90                   	nop
  802a2c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802a30:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
  802a34:	d3 e2                	shl    %cl,%edx
  802a36:	89 55 f4             	mov    %edx,-0xc(%ebp)
  802a39:	ba 20 00 00 00       	mov    $0x20,%edx
  802a3e:	2b 55 f0             	sub    -0x10(%ebp),%edx
  802a41:	89 55 ec             	mov    %edx,-0x14(%ebp)
  802a44:	0f b6 4d ec          	movzbl -0x14(%ebp),%ecx
  802a48:	89 fa                	mov    %edi,%edx
  802a4a:	d3 ea                	shr    %cl,%edx
  802a4c:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
  802a50:	0b 55 f4             	or     -0xc(%ebp),%edx
  802a53:	d3 e7                	shl    %cl,%edi
  802a55:	0f b6 4d ec          	movzbl -0x14(%ebp),%ecx
  802a59:	89 55 f4             	mov    %edx,-0xc(%ebp)
  802a5c:	89 f2                	mov    %esi,%edx
  802a5e:	89 7d e8             	mov    %edi,-0x18(%ebp)
  802a61:	89 c7                	mov    %eax,%edi
  802a63:	d3 ea                	shr    %cl,%edx
  802a65:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
  802a69:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  802a6c:	89 c2                	mov    %eax,%edx
  802a6e:	d3 e6                	shl    %cl,%esi
  802a70:	0f b6 4d ec          	movzbl -0x14(%ebp),%ecx
  802a74:	d3 ea                	shr    %cl,%edx
  802a76:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
  802a7a:	09 d6                	or     %edx,%esi
  802a7c:	89 f0                	mov    %esi,%eax
  802a7e:	8b 75 e4             	mov    -0x1c(%ebp),%esi
  802a81:	d3 e7                	shl    %cl,%edi
  802a83:	89 f2                	mov    %esi,%edx
  802a85:	f7 75 f4             	divl   -0xc(%ebp)
  802a88:	89 d6                	mov    %edx,%esi
  802a8a:	f7 65 e8             	mull   -0x18(%ebp)
  802a8d:	39 d6                	cmp    %edx,%esi
  802a8f:	72 2b                	jb     802abc <__umoddi3+0x11c>
  802a91:	39 c7                	cmp    %eax,%edi
  802a93:	72 23                	jb     802ab8 <__umoddi3+0x118>
  802a95:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
  802a99:	29 c7                	sub    %eax,%edi
  802a9b:	19 d6                	sbb    %edx,%esi
  802a9d:	89 f0                	mov    %esi,%eax
  802a9f:	89 f2                	mov    %esi,%edx
  802aa1:	d3 ef                	shr    %cl,%edi
  802aa3:	0f b6 4d ec          	movzbl -0x14(%ebp),%ecx
  802aa7:	d3 e0                	shl    %cl,%eax
  802aa9:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
  802aad:	09 f8                	or     %edi,%eax
  802aaf:	d3 ea                	shr    %cl,%edx
  802ab1:	83 c4 20             	add    $0x20,%esp
  802ab4:	5e                   	pop    %esi
  802ab5:	5f                   	pop    %edi
  802ab6:	5d                   	pop    %ebp
  802ab7:	c3                   	ret    
  802ab8:	39 d6                	cmp    %edx,%esi
  802aba:	75 d9                	jne    802a95 <__umoddi3+0xf5>
  802abc:	2b 45 e8             	sub    -0x18(%ebp),%eax
  802abf:	1b 55 f4             	sbb    -0xc(%ebp),%edx
  802ac2:	eb d1                	jmp    802a95 <__umoddi3+0xf5>
  802ac4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802ac8:	39 f2                	cmp    %esi,%edx
  802aca:	0f 82 18 ff ff ff    	jb     8029e8 <__umoddi3+0x48>
  802ad0:	e9 1d ff ff ff       	jmp    8029f2 <__umoddi3+0x52>
