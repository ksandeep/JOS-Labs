
obj/user/init:     file format elf32-i386


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
  80002c:	e8 ab 03 00 00       	call   8003dc <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>
	...

00800040 <sum>:

char bss[6000];

int
sum(const char *s, int n)
{
  800040:	55                   	push   %ebp
  800041:	89 e5                	mov    %esp,%ebp
  800043:	56                   	push   %esi
  800044:	53                   	push   %ebx
  800045:	8b 75 08             	mov    0x8(%ebp),%esi
  800048:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int i, tot = 0;
	for (i = 0; i < n; i++)
  80004b:	b8 00 00 00 00       	mov    $0x0,%eax
  800050:	ba 00 00 00 00       	mov    $0x0,%edx
  800055:	85 db                	test   %ebx,%ebx
  800057:	7e 10                	jle    800069 <sum+0x29>
		tot ^= i * s[i];
  800059:	0f be 0c 16          	movsbl (%esi,%edx,1),%ecx
  80005d:	0f af ca             	imul   %edx,%ecx
  800060:	31 c8                	xor    %ecx,%eax

int
sum(const char *s, int n)
{
	int i, tot = 0;
	for (i = 0; i < n; i++)
  800062:	83 c2 01             	add    $0x1,%edx
  800065:	39 da                	cmp    %ebx,%edx
  800067:	75 f0                	jne    800059 <sum+0x19>
		tot ^= i * s[i];
	return tot;
}
  800069:	5b                   	pop    %ebx
  80006a:	5e                   	pop    %esi
  80006b:	5d                   	pop    %ebp
  80006c:	c3                   	ret    

0080006d <umain>:
		
void
umain(int argc, char **argv)
{
  80006d:	55                   	push   %ebp
  80006e:	89 e5                	mov    %esp,%ebp
  800070:	57                   	push   %edi
  800071:	56                   	push   %esi
  800072:	53                   	push   %ebx
  800073:	83 ec 1c             	sub    $0x1c,%esp
  800076:	8b 7d 08             	mov    0x8(%ebp),%edi
  800079:	8b 75 0c             	mov    0xc(%ebp),%esi
	int i, r, x, want;

	cprintf("init: running\n");
  80007c:	c7 04 24 60 30 80 00 	movl   $0x803060,(%esp)
  800083:	e8 85 04 00 00       	call   80050d <cprintf>

	want = 0xf989e;
	if ((x = sum((char*)&data, sizeof data)) != want)
  800088:	c7 44 24 04 70 17 00 	movl   $0x1770,0x4(%esp)
  80008f:	00 
  800090:	c7 04 24 00 70 80 00 	movl   $0x807000,(%esp)
  800097:	e8 a4 ff ff ff       	call   800040 <sum>
  80009c:	3d 9e 98 0f 00       	cmp    $0xf989e,%eax
  8000a1:	74 1a                	je     8000bd <umain+0x50>
		cprintf("init: data is not initialized: got sum %08x wanted %08x\n",
  8000a3:	c7 44 24 08 9e 98 0f 	movl   $0xf989e,0x8(%esp)
  8000aa:	00 
  8000ab:	89 44 24 04          	mov    %eax,0x4(%esp)
  8000af:	c7 04 24 28 31 80 00 	movl   $0x803128,(%esp)
  8000b6:	e8 52 04 00 00       	call   80050d <cprintf>
  8000bb:	eb 0c                	jmp    8000c9 <umain+0x5c>
			x, want);
	else
		cprintf("init: data seems okay\n");
  8000bd:	c7 04 24 6f 30 80 00 	movl   $0x80306f,(%esp)
  8000c4:	e8 44 04 00 00       	call   80050d <cprintf>
	if ((x = sum(bss, sizeof bss)) != 0)
  8000c9:	c7 44 24 04 70 17 00 	movl   $0x1770,0x4(%esp)
  8000d0:	00 
  8000d1:	c7 04 24 00 88 80 00 	movl   $0x808800,(%esp)
  8000d8:	e8 63 ff ff ff       	call   800040 <sum>
  8000dd:	85 c0                	test   %eax,%eax
  8000df:	74 12                	je     8000f3 <umain+0x86>
		cprintf("bss is not initialized: wanted sum 0 got %08x\n", x);
  8000e1:	89 44 24 04          	mov    %eax,0x4(%esp)
  8000e5:	c7 04 24 64 31 80 00 	movl   $0x803164,(%esp)
  8000ec:	e8 1c 04 00 00       	call   80050d <cprintf>
  8000f1:	eb 0c                	jmp    8000ff <umain+0x92>
	else
		cprintf("init: bss seems okay\n");
  8000f3:	c7 04 24 86 30 80 00 	movl   $0x803086,(%esp)
  8000fa:	e8 0e 04 00 00       	call   80050d <cprintf>

	cprintf("init: args:");
  8000ff:	c7 04 24 9c 30 80 00 	movl   $0x80309c,(%esp)
  800106:	e8 02 04 00 00       	call   80050d <cprintf>
	for (i = 0; i < argc; i++)
  80010b:	85 ff                	test   %edi,%edi
  80010d:	7e 1f                	jle    80012e <umain+0xc1>
  80010f:	bb 00 00 00 00       	mov    $0x0,%ebx
		cprintf(" '%s'", argv[i]);
  800114:	8b 04 9e             	mov    (%esi,%ebx,4),%eax
  800117:	89 44 24 04          	mov    %eax,0x4(%esp)
  80011b:	c7 04 24 a8 30 80 00 	movl   $0x8030a8,(%esp)
  800122:	e8 e6 03 00 00       	call   80050d <cprintf>
		cprintf("bss is not initialized: wanted sum 0 got %08x\n", x);
	else
		cprintf("init: bss seems okay\n");

	cprintf("init: args:");
	for (i = 0; i < argc; i++)
  800127:	83 c3 01             	add    $0x1,%ebx
  80012a:	39 df                	cmp    %ebx,%edi
  80012c:	7f e6                	jg     800114 <umain+0xa7>
		cprintf(" '%s'", argv[i]);
	cprintf("\n");
  80012e:	c7 04 24 b3 36 80 00 	movl   $0x8036b3,(%esp)
  800135:	e8 d3 03 00 00       	call   80050d <cprintf>

	cprintf("init: running sh\n");
  80013a:	c7 04 24 ae 30 80 00 	movl   $0x8030ae,(%esp)
  800141:	e8 c7 03 00 00       	call   80050d <cprintf>

	// being run directly from kernel, so no file descriptors open yet
	close(0);
  800146:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80014d:	e8 ec 17 00 00       	call   80193e <close>
	if ((r = opencons()) < 0)
  800152:	e8 c9 01 00 00       	call   800320 <opencons>
  800157:	85 c0                	test   %eax,%eax
  800159:	79 20                	jns    80017b <umain+0x10e>
		panic("opencons: %e", r);
  80015b:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80015f:	c7 44 24 08 c0 30 80 	movl   $0x8030c0,0x8(%esp)
  800166:	00 
  800167:	c7 44 24 04 32 00 00 	movl   $0x32,0x4(%esp)
  80016e:	00 
  80016f:	c7 04 24 cd 30 80 00 	movl   $0x8030cd,(%esp)
  800176:	e8 cd 02 00 00       	call   800448 <_panic>
	if (r != 0)
  80017b:	85 c0                	test   %eax,%eax
  80017d:	74 20                	je     80019f <umain+0x132>
		panic("first opencons used fd %d", r);
  80017f:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800183:	c7 44 24 08 d9 30 80 	movl   $0x8030d9,0x8(%esp)
  80018a:	00 
  80018b:	c7 44 24 04 34 00 00 	movl   $0x34,0x4(%esp)
  800192:	00 
  800193:	c7 04 24 cd 30 80 00 	movl   $0x8030cd,(%esp)
  80019a:	e8 a9 02 00 00       	call   800448 <_panic>
	if ((r = dup(0, 1)) < 0)
  80019f:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  8001a6:	00 
  8001a7:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8001ae:	e8 2a 18 00 00       	call   8019dd <dup>
  8001b3:	85 c0                	test   %eax,%eax
  8001b5:	79 20                	jns    8001d7 <umain+0x16a>
		panic("dup: %e", r);
  8001b7:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8001bb:	c7 44 24 08 f3 30 80 	movl   $0x8030f3,0x8(%esp)
  8001c2:	00 
  8001c3:	c7 44 24 04 36 00 00 	movl   $0x36,0x4(%esp)
  8001ca:	00 
  8001cb:	c7 04 24 cd 30 80 00 	movl   $0x8030cd,(%esp)
  8001d2:	e8 71 02 00 00       	call   800448 <_panic>
	while (1) {
		cprintf("init: starting sh\n");
  8001d7:	c7 04 24 fb 30 80 00 	movl   $0x8030fb,(%esp)
  8001de:	e8 2a 03 00 00       	call   80050d <cprintf>
		r = spawnl("/sh", "sh", (char*)0);
  8001e3:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  8001ea:	00 
  8001eb:	c7 44 24 04 0f 31 80 	movl   $0x80310f,0x4(%esp)
  8001f2:	00 
  8001f3:	c7 04 24 0e 31 80 00 	movl   $0x80310e,(%esp)
  8001fa:	e8 90 21 00 00       	call   80238f <spawnl>
		if (r < 0) {
  8001ff:	85 c0                	test   %eax,%eax
  800201:	79 12                	jns    800215 <umain+0x1a8>
			cprintf("init: spawn sh: %e\n", r);
  800203:	89 44 24 04          	mov    %eax,0x4(%esp)
  800207:	c7 04 24 12 31 80 00 	movl   $0x803112,(%esp)
  80020e:	e8 fa 02 00 00       	call   80050d <cprintf>
			continue;
  800213:	eb c2                	jmp    8001d7 <umain+0x16a>
		}
		wait(r);
  800215:	89 04 24             	mov    %eax,(%esp)
  800218:	e8 47 2a 00 00       	call   802c64 <wait>
  80021d:	8d 76 00             	lea    0x0(%esi),%esi
  800220:	eb b5                	jmp    8001d7 <umain+0x16a>
	...

00800230 <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  800230:	55                   	push   %ebp
  800231:	89 e5                	mov    %esp,%ebp
	USED(fd);

	return 0;
}
  800233:	b8 00 00 00 00       	mov    $0x0,%eax
  800238:	5d                   	pop    %ebp
  800239:	c3                   	ret    

0080023a <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  80023a:	55                   	push   %ebp
  80023b:	89 e5                	mov    %esp,%ebp
  80023d:	83 ec 18             	sub    $0x18,%esp
	strcpy(stat->st_name, "<cons>");
  800240:	c7 44 24 04 93 31 80 	movl   $0x803193,0x4(%esp)
  800247:	00 
  800248:	8b 45 0c             	mov    0xc(%ebp),%eax
  80024b:	89 04 24             	mov    %eax,(%esp)
  80024e:	e8 77 09 00 00       	call   800bca <strcpy>
	return 0;
}
  800253:	b8 00 00 00 00       	mov    $0x0,%eax
  800258:	c9                   	leave  
  800259:	c3                   	ret    

0080025a <devcons_write>:
	return 1;
}

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  80025a:	55                   	push   %ebp
  80025b:	89 e5                	mov    %esp,%ebp
  80025d:	57                   	push   %edi
  80025e:	56                   	push   %esi
  80025f:	53                   	push   %ebx
  800260:	81 ec 9c 00 00 00    	sub    $0x9c,%esp
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs, 
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  800266:	b8 00 00 00 00       	mov    $0x0,%eax
  80026b:	be 00 00 00 00       	mov    $0x0,%esi
  800270:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800274:	74 3f                	je     8002b5 <devcons_write+0x5b>
		m = n - tot;
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  800276:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs, 
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
		m = n - tot;
  80027c:	8b 55 10             	mov    0x10(%ebp),%edx
  80027f:	29 c2                	sub    %eax,%edx
  800281:	89 d3                	mov    %edx,%ebx
		if (m > sizeof(buf) - 1)
  800283:	83 fa 7f             	cmp    $0x7f,%edx
  800286:	76 05                	jbe    80028d <devcons_write+0x33>
  800288:	bb 7f 00 00 00       	mov    $0x7f,%ebx
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  80028d:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  800291:	03 45 0c             	add    0xc(%ebp),%eax
  800294:	89 44 24 04          	mov    %eax,0x4(%esp)
  800298:	89 3c 24             	mov    %edi,(%esp)
  80029b:	e8 e5 0a 00 00       	call   800d85 <memmove>
		sys_cputs(buf, m);
  8002a0:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8002a4:	89 3c 24             	mov    %edi,(%esp)
  8002a7:	e8 14 0d 00 00       	call   800fc0 <sys_cputs>
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs, 
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  8002ac:	01 de                	add    %ebx,%esi
  8002ae:	89 f0                	mov    %esi,%eax
  8002b0:	3b 75 10             	cmp    0x10(%ebp),%esi
  8002b3:	72 c7                	jb     80027c <devcons_write+0x22>
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
}
  8002b5:	89 f0                	mov    %esi,%eax
  8002b7:	81 c4 9c 00 00 00    	add    $0x9c,%esp
  8002bd:	5b                   	pop    %ebx
  8002be:	5e                   	pop    %esi
  8002bf:	5f                   	pop    %edi
  8002c0:	5d                   	pop    %ebp
  8002c1:	c3                   	ret    

008002c2 <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  8002c2:	55                   	push   %ebp
  8002c3:	89 e5                	mov    %esp,%ebp
  8002c5:	83 ec 28             	sub    $0x28,%esp
	char c = ch;
  8002c8:	8b 45 08             	mov    0x8(%ebp),%eax
  8002cb:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  8002ce:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  8002d5:	00 
  8002d6:	8d 45 f7             	lea    -0x9(%ebp),%eax
  8002d9:	89 04 24             	mov    %eax,(%esp)
  8002dc:	e8 df 0c 00 00       	call   800fc0 <sys_cputs>
}
  8002e1:	c9                   	leave  
  8002e2:	c3                   	ret    

008002e3 <devcons_read>:
	return fd2num(fd);
}

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  8002e3:	55                   	push   %ebp
  8002e4:	89 e5                	mov    %esp,%ebp
  8002e6:	83 ec 08             	sub    $0x8,%esp
	int c;

	if (n == 0)
  8002e9:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8002ed:	75 07                	jne    8002f6 <devcons_read+0x13>
  8002ef:	eb 28                	jmp    800319 <devcons_read+0x36>
		return 0;

	while ((c = sys_cgetc()) == 0)
		sys_yield();
  8002f1:	e8 24 11 00 00       	call   80141a <sys_yield>
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  8002f6:	66 90                	xchg   %ax,%ax
  8002f8:	e8 8f 0c 00 00       	call   800f8c <sys_cgetc>
  8002fd:	85 c0                	test   %eax,%eax
  8002ff:	90                   	nop
  800300:	74 ef                	je     8002f1 <devcons_read+0xe>
  800302:	89 c2                	mov    %eax,%edx
		sys_yield();
	if (c < 0)
  800304:	85 c0                	test   %eax,%eax
  800306:	78 16                	js     80031e <devcons_read+0x3b>
		return c;
	if (c == 0x04)	// ctl-d is eof
  800308:	83 f8 04             	cmp    $0x4,%eax
  80030b:	74 0c                	je     800319 <devcons_read+0x36>
		return 0;
	*(char*)vbuf = c;
  80030d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800310:	88 10                	mov    %dl,(%eax)
  800312:	b8 01 00 00 00       	mov    $0x1,%eax
	return 1;
  800317:	eb 05                	jmp    80031e <devcons_read+0x3b>
  800319:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80031e:	c9                   	leave  
  80031f:	c3                   	ret    

00800320 <opencons>:
	return fd->fd_dev_id == devcons.dev_id;
}

int
opencons(void)
{
  800320:	55                   	push   %ebp
  800321:	89 e5                	mov    %esp,%ebp
  800323:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  800326:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800329:	89 04 24             	mov    %eax,(%esp)
  80032c:	e8 da 11 00 00       	call   80150b <fd_alloc>
  800331:	85 c0                	test   %eax,%eax
  800333:	78 3f                	js     800374 <opencons+0x54>
		return r;
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  800335:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  80033c:	00 
  80033d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800340:	89 44 24 04          	mov    %eax,0x4(%esp)
  800344:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80034b:	e8 6b 10 00 00       	call   8013bb <sys_page_alloc>
  800350:	85 c0                	test   %eax,%eax
  800352:	78 20                	js     800374 <opencons+0x54>
		return r;
	fd->fd_dev_id = devcons.dev_id;
  800354:	8b 15 70 87 80 00    	mov    0x808770,%edx
  80035a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80035d:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  80035f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800362:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  800369:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80036c:	89 04 24             	mov    %eax,(%esp)
  80036f:	e8 6c 11 00 00       	call   8014e0 <fd2num>
}
  800374:	c9                   	leave  
  800375:	c3                   	ret    

00800376 <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  800376:	55                   	push   %ebp
  800377:	89 e5                	mov    %esp,%ebp
  800379:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80037c:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80037f:	89 44 24 04          	mov    %eax,0x4(%esp)
  800383:	8b 45 08             	mov    0x8(%ebp),%eax
  800386:	89 04 24             	mov    %eax,(%esp)
  800389:	e8 ef 11 00 00       	call   80157d <fd_lookup>
  80038e:	85 c0                	test   %eax,%eax
  800390:	78 11                	js     8003a3 <iscons+0x2d>
		return r;
	return fd->fd_dev_id == devcons.dev_id;
  800392:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800395:	8b 00                	mov    (%eax),%eax
  800397:	3b 05 70 87 80 00    	cmp    0x808770,%eax
  80039d:	0f 94 c0             	sete   %al
  8003a0:	0f b6 c0             	movzbl %al,%eax
}
  8003a3:	c9                   	leave  
  8003a4:	c3                   	ret    

008003a5 <getchar>:
	sys_cputs(&c, 1);
}

int
getchar(void)
{
  8003a5:	55                   	push   %ebp
  8003a6:	89 e5                	mov    %esp,%ebp
  8003a8:	83 ec 28             	sub    $0x28,%esp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  8003ab:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  8003b2:	00 
  8003b3:	8d 45 f7             	lea    -0x9(%ebp),%eax
  8003b6:	89 44 24 04          	mov    %eax,0x4(%esp)
  8003ba:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8003c1:	e8 18 14 00 00       	call   8017de <read>
	if (r < 0)
  8003c6:	85 c0                	test   %eax,%eax
  8003c8:	78 0f                	js     8003d9 <getchar+0x34>
		return r;
	if (r < 1)
  8003ca:	85 c0                	test   %eax,%eax
  8003cc:	7f 07                	jg     8003d5 <getchar+0x30>
  8003ce:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  8003d3:	eb 04                	jmp    8003d9 <getchar+0x34>
		return -E_EOF;
	return c;
  8003d5:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  8003d9:	c9                   	leave  
  8003da:	c3                   	ret    
	...

008003dc <libmain>:
volatile struct Env *env;
char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  8003dc:	55                   	push   %ebp
  8003dd:	89 e5                	mov    %esp,%ebp
  8003df:	83 ec 18             	sub    $0x18,%esp
  8003e2:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  8003e5:	89 75 fc             	mov    %esi,-0x4(%ebp)
  8003e8:	8b 75 08             	mov    0x8(%ebp),%esi
  8003eb:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	// set env to point at our env structure in envs[].
	// LAB 3b: Your code here.
	// Code added by Swastika / Sandeep	
	envid_t envid = sys_getenvid();
  8003ee:	e8 5b 10 00 00       	call   80144e <sys_getenvid>
	env = &envs[ENVX(envid)];
  8003f3:	25 ff 03 00 00       	and    $0x3ff,%eax
  8003f8:	6b c0 7c             	imul   $0x7c,%eax,%eax
  8003fb:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800400:	a3 70 9f 80 00       	mov    %eax,0x809f70

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800405:	85 f6                	test   %esi,%esi
  800407:	7e 07                	jle    800410 <libmain+0x34>
		binaryname = argv[0];
  800409:	8b 03                	mov    (%ebx),%eax
  80040b:	a3 8c 87 80 00       	mov    %eax,0x80878c

	// call user main routine
	umain(argc, argv);
  800410:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  800414:	89 34 24             	mov    %esi,(%esp)
  800417:	e8 51 fc ff ff       	call   80006d <umain>

	// exit gracefully
	exit();
  80041c:	e8 0b 00 00 00       	call   80042c <exit>
}
  800421:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  800424:	8b 75 fc             	mov    -0x4(%ebp),%esi
  800427:	89 ec                	mov    %ebp,%esp
  800429:	5d                   	pop    %ebp
  80042a:	c3                   	ret    
	...

0080042c <exit>:
#include <inc/lib.h>

void
exit(void)
{
  80042c:	55                   	push   %ebp
  80042d:	89 e5                	mov    %esp,%ebp
  80042f:	83 ec 18             	sub    $0x18,%esp
	close_all();
  800432:	e8 84 15 00 00       	call   8019bb <close_all>
	sys_env_destroy(0);
  800437:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80043e:	e8 3f 10 00 00       	call   801482 <sys_env_destroy>
}
  800443:	c9                   	leave  
  800444:	c3                   	ret    
  800445:	00 00                	add    %al,(%eax)
	...

00800448 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  800448:	55                   	push   %ebp
  800449:	89 e5                	mov    %esp,%ebp
  80044b:	53                   	push   %ebx
  80044c:	83 ec 14             	sub    $0x14,%esp
 * Panic is called on unresolvable fatal errors.
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
  80044f:	8d 5d 14             	lea    0x14(%ebp),%ebx
	va_list ap;

	va_start(ap, fmt);

	// Print the panic message
	if (argv0)
  800452:	a1 74 9f 80 00       	mov    0x809f74,%eax
  800457:	85 c0                	test   %eax,%eax
  800459:	74 10                	je     80046b <_panic+0x23>
		cprintf("%s: ", argv0);
  80045b:	89 44 24 04          	mov    %eax,0x4(%esp)
  80045f:	c7 04 24 b6 31 80 00 	movl   $0x8031b6,(%esp)
  800466:	e8 a2 00 00 00       	call   80050d <cprintf>
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  80046b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80046e:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800472:	8b 45 08             	mov    0x8(%ebp),%eax
  800475:	89 44 24 08          	mov    %eax,0x8(%esp)
  800479:	a1 8c 87 80 00       	mov    0x80878c,%eax
  80047e:	89 44 24 04          	mov    %eax,0x4(%esp)
  800482:	c7 04 24 bb 31 80 00 	movl   $0x8031bb,(%esp)
  800489:	e8 7f 00 00 00       	call   80050d <cprintf>
	vcprintf(fmt, ap);
  80048e:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  800492:	8b 45 10             	mov    0x10(%ebp),%eax
  800495:	89 04 24             	mov    %eax,(%esp)
  800498:	e8 0f 00 00 00       	call   8004ac <vcprintf>
	cprintf("\n");
  80049d:	c7 04 24 b3 36 80 00 	movl   $0x8036b3,(%esp)
  8004a4:	e8 64 00 00 00       	call   80050d <cprintf>

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  8004a9:	cc                   	int3   
  8004aa:	eb fd                	jmp    8004a9 <_panic+0x61>

008004ac <vcprintf>:
	b->cnt++;
}

int
vcprintf(const char *fmt, va_list ap)
{
  8004ac:	55                   	push   %ebp
  8004ad:	89 e5                	mov    %esp,%ebp
  8004af:	81 ec 28 01 00 00    	sub    $0x128,%esp
	struct printbuf b;

	b.idx = 0;
  8004b5:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8004bc:	00 00 00 
	b.cnt = 0;
  8004bf:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8004c6:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  8004c9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004cc:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8004d0:	8b 45 08             	mov    0x8(%ebp),%eax
  8004d3:	89 44 24 08          	mov    %eax,0x8(%esp)
  8004d7:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8004dd:	89 44 24 04          	mov    %eax,0x4(%esp)
  8004e1:	c7 04 24 27 05 80 00 	movl   $0x800527,(%esp)
  8004e8:	e8 d0 01 00 00       	call   8006bd <vprintfmt>
	sys_cputs(b.buf, b.idx);
  8004ed:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
  8004f3:	89 44 24 04          	mov    %eax,0x4(%esp)
  8004f7:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  8004fd:	89 04 24             	mov    %eax,(%esp)
  800500:	e8 bb 0a 00 00       	call   800fc0 <sys_cputs>

	return b.cnt;
}
  800505:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  80050b:	c9                   	leave  
  80050c:	c3                   	ret    

0080050d <cprintf>:

int
cprintf(const char *fmt, ...)
{
  80050d:	55                   	push   %ebp
  80050e:	89 e5                	mov    %esp,%ebp
  800510:	83 ec 18             	sub    $0x18,%esp

	return b.cnt;
}

int
cprintf(const char *fmt, ...)
  800513:	8d 45 0c             	lea    0xc(%ebp),%eax
{
	va_list ap;
	int cnt;

	va_start(ap, fmt);
	cnt = vcprintf(fmt, ap);
  800516:	89 44 24 04          	mov    %eax,0x4(%esp)
  80051a:	8b 45 08             	mov    0x8(%ebp),%eax
  80051d:	89 04 24             	mov    %eax,(%esp)
  800520:	e8 87 ff ff ff       	call   8004ac <vcprintf>
	va_end(ap);

	return cnt;
}
  800525:	c9                   	leave  
  800526:	c3                   	ret    

00800527 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  800527:	55                   	push   %ebp
  800528:	89 e5                	mov    %esp,%ebp
  80052a:	53                   	push   %ebx
  80052b:	83 ec 14             	sub    $0x14,%esp
  80052e:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  800531:	8b 03                	mov    (%ebx),%eax
  800533:	8b 55 08             	mov    0x8(%ebp),%edx
  800536:	88 54 03 08          	mov    %dl,0x8(%ebx,%eax,1)
  80053a:	83 c0 01             	add    $0x1,%eax
  80053d:	89 03                	mov    %eax,(%ebx)
	if (b->idx == 256-1) {
  80053f:	3d ff 00 00 00       	cmp    $0xff,%eax
  800544:	75 19                	jne    80055f <putch+0x38>
		sys_cputs(b->buf, b->idx);
  800546:	c7 44 24 04 ff 00 00 	movl   $0xff,0x4(%esp)
  80054d:	00 
  80054e:	8d 43 08             	lea    0x8(%ebx),%eax
  800551:	89 04 24             	mov    %eax,(%esp)
  800554:	e8 67 0a 00 00       	call   800fc0 <sys_cputs>
		b->idx = 0;
  800559:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
	}
	b->cnt++;
  80055f:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  800563:	83 c4 14             	add    $0x14,%esp
  800566:	5b                   	pop    %ebx
  800567:	5d                   	pop    %ebp
  800568:	c3                   	ret    
  800569:	00 00                	add    %al,(%eax)
  80056b:	00 00                	add    %al,(%eax)
  80056d:	00 00                	add    %al,(%eax)
	...

00800570 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800570:	55                   	push   %ebp
  800571:	89 e5                	mov    %esp,%ebp
  800573:	57                   	push   %edi
  800574:	56                   	push   %esi
  800575:	53                   	push   %ebx
  800576:	83 ec 4c             	sub    $0x4c,%esp
  800579:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80057c:	89 d6                	mov    %edx,%esi
  80057e:	8b 45 08             	mov    0x8(%ebp),%eax
  800581:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800584:	8b 55 0c             	mov    0xc(%ebp),%edx
  800587:	89 55 e0             	mov    %edx,-0x20(%ebp)
  80058a:	8b 45 10             	mov    0x10(%ebp),%eax
  80058d:	8b 5d 14             	mov    0x14(%ebp),%ebx
  800590:	8b 7d 18             	mov    0x18(%ebp),%edi
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800593:	89 45 dc             	mov    %eax,-0x24(%ebp)
  800596:	b9 00 00 00 00       	mov    $0x0,%ecx
  80059b:	39 d1                	cmp    %edx,%ecx
  80059d:	72 15                	jb     8005b4 <printnum+0x44>
  80059f:	77 07                	ja     8005a8 <printnum+0x38>
  8005a1:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8005a4:	39 d0                	cmp    %edx,%eax
  8005a6:	76 0c                	jbe    8005b4 <printnum+0x44>
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8005a8:	83 eb 01             	sub    $0x1,%ebx
  8005ab:	85 db                	test   %ebx,%ebx
  8005ad:	8d 76 00             	lea    0x0(%esi),%esi
  8005b0:	7f 61                	jg     800613 <printnum+0xa3>
  8005b2:	eb 70                	jmp    800624 <printnum+0xb4>
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8005b4:	89 7c 24 10          	mov    %edi,0x10(%esp)
  8005b8:	83 eb 01             	sub    $0x1,%ebx
  8005bb:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  8005bf:	89 44 24 08          	mov    %eax,0x8(%esp)
  8005c3:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  8005c7:	8b 5c 24 0c          	mov    0xc(%esp),%ebx
  8005cb:	89 4d d0             	mov    %ecx,-0x30(%ebp)
  8005ce:	89 5d d4             	mov    %ebx,-0x2c(%ebp)
  8005d1:	8b 5d dc             	mov    -0x24(%ebp),%ebx
  8005d4:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8005d8:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  8005df:	00 
  8005e0:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8005e3:	89 04 24             	mov    %eax,(%esp)
  8005e6:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8005e9:	89 54 24 04          	mov    %edx,0x4(%esp)
  8005ed:	e8 fe 27 00 00       	call   802df0 <__udivdi3>
  8005f2:	8b 4d d0             	mov    -0x30(%ebp),%ecx
  8005f5:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
  8005f8:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8005fc:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  800600:	89 04 24             	mov    %eax,(%esp)
  800603:	89 54 24 04          	mov    %edx,0x4(%esp)
  800607:	89 f2                	mov    %esi,%edx
  800609:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80060c:	e8 5f ff ff ff       	call   800570 <printnum>
  800611:	eb 11                	jmp    800624 <printnum+0xb4>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800613:	89 74 24 04          	mov    %esi,0x4(%esp)
  800617:	89 3c 24             	mov    %edi,(%esp)
  80061a:	ff 55 e4             	call   *-0x1c(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  80061d:	83 eb 01             	sub    $0x1,%ebx
  800620:	85 db                	test   %ebx,%ebx
  800622:	7f ef                	jg     800613 <printnum+0xa3>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800624:	89 74 24 04          	mov    %esi,0x4(%esp)
  800628:	8b 74 24 04          	mov    0x4(%esp),%esi
  80062c:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80062f:	89 44 24 08          	mov    %eax,0x8(%esp)
  800633:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  80063a:	00 
  80063b:	8b 55 d8             	mov    -0x28(%ebp),%edx
  80063e:	89 14 24             	mov    %edx,(%esp)
  800641:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  800644:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  800648:	e8 d3 28 00 00       	call   802f20 <__umoddi3>
  80064d:	89 74 24 04          	mov    %esi,0x4(%esp)
  800651:	0f be 80 d7 31 80 00 	movsbl 0x8031d7(%eax),%eax
  800658:	89 04 24             	mov    %eax,(%esp)
  80065b:	ff 55 e4             	call   *-0x1c(%ebp)
}
  80065e:	83 c4 4c             	add    $0x4c,%esp
  800661:	5b                   	pop    %ebx
  800662:	5e                   	pop    %esi
  800663:	5f                   	pop    %edi
  800664:	5d                   	pop    %ebp
  800665:	c3                   	ret    

00800666 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800666:	55                   	push   %ebp
  800667:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800669:	83 fa 01             	cmp    $0x1,%edx
  80066c:	7e 0e                	jle    80067c <getuint+0x16>
		return va_arg(*ap, unsigned long long);
  80066e:	8b 10                	mov    (%eax),%edx
  800670:	8d 4a 08             	lea    0x8(%edx),%ecx
  800673:	89 08                	mov    %ecx,(%eax)
  800675:	8b 02                	mov    (%edx),%eax
  800677:	8b 52 04             	mov    0x4(%edx),%edx
  80067a:	eb 22                	jmp    80069e <getuint+0x38>
	else if (lflag)
  80067c:	85 d2                	test   %edx,%edx
  80067e:	74 10                	je     800690 <getuint+0x2a>
		return va_arg(*ap, unsigned long);
  800680:	8b 10                	mov    (%eax),%edx
  800682:	8d 4a 04             	lea    0x4(%edx),%ecx
  800685:	89 08                	mov    %ecx,(%eax)
  800687:	8b 02                	mov    (%edx),%eax
  800689:	ba 00 00 00 00       	mov    $0x0,%edx
  80068e:	eb 0e                	jmp    80069e <getuint+0x38>
	else
		return va_arg(*ap, unsigned int);
  800690:	8b 10                	mov    (%eax),%edx
  800692:	8d 4a 04             	lea    0x4(%edx),%ecx
  800695:	89 08                	mov    %ecx,(%eax)
  800697:	8b 02                	mov    (%edx),%eax
  800699:	ba 00 00 00 00       	mov    $0x0,%edx
}
  80069e:	5d                   	pop    %ebp
  80069f:	c3                   	ret    

008006a0 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8006a0:	55                   	push   %ebp
  8006a1:	89 e5                	mov    %esp,%ebp
  8006a3:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  8006a6:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  8006aa:	8b 10                	mov    (%eax),%edx
  8006ac:	3b 50 04             	cmp    0x4(%eax),%edx
  8006af:	73 0a                	jae    8006bb <sprintputch+0x1b>
		*b->buf++ = ch;
  8006b1:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8006b4:	88 0a                	mov    %cl,(%edx)
  8006b6:	83 c2 01             	add    $0x1,%edx
  8006b9:	89 10                	mov    %edx,(%eax)
}
  8006bb:	5d                   	pop    %ebp
  8006bc:	c3                   	ret    

008006bd <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  8006bd:	55                   	push   %ebp
  8006be:	89 e5                	mov    %esp,%ebp
  8006c0:	57                   	push   %edi
  8006c1:	56                   	push   %esi
  8006c2:	53                   	push   %ebx
  8006c3:	83 ec 5c             	sub    $0x5c,%esp
  8006c6:	8b 7d 08             	mov    0x8(%ebp),%edi
  8006c9:	8b 75 0c             	mov    0xc(%ebp),%esi
  8006cc:	8b 5d 10             	mov    0x10(%ebp),%ebx
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  8006cf:	c7 45 c8 ff ff ff ff 	movl   $0xffffffff,-0x38(%ebp)
  8006d6:	eb 11                	jmp    8006e9 <vprintfmt+0x2c>
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
  8006d8:	85 c0                	test   %eax,%eax
  8006da:	0f 84 ec 03 00 00    	je     800acc <vprintfmt+0x40f>
				return;
			putch(ch, putdat);
  8006e0:	89 74 24 04          	mov    %esi,0x4(%esp)
  8006e4:	89 04 24             	mov    %eax,(%esp)
  8006e7:	ff d7                	call   *%edi
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8006e9:	0f b6 03             	movzbl (%ebx),%eax
  8006ec:	83 c3 01             	add    $0x1,%ebx
  8006ef:	83 f8 25             	cmp    $0x25,%eax
  8006f2:	75 e4                	jne    8006d8 <vprintfmt+0x1b>
  8006f4:	c6 45 d4 20          	movb   $0x20,-0x2c(%ebp)
  8006f8:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
  8006ff:	c7 45 d0 ff ff ff ff 	movl   $0xffffffff,-0x30(%ebp)
  800706:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
  80070d:	b9 00 00 00 00       	mov    $0x0,%ecx
  800712:	eb 06                	jmp    80071a <vprintfmt+0x5d>
  800714:	c6 45 d4 2d          	movb   $0x2d,-0x2c(%ebp)
  800718:	89 c3                	mov    %eax,%ebx
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80071a:	0f b6 13             	movzbl (%ebx),%edx
  80071d:	0f b6 c2             	movzbl %dl,%eax
  800720:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800723:	8d 43 01             	lea    0x1(%ebx),%eax
  800726:	83 ea 23             	sub    $0x23,%edx
  800729:	80 fa 55             	cmp    $0x55,%dl
  80072c:	0f 87 7d 03 00 00    	ja     800aaf <vprintfmt+0x3f2>
  800732:	0f b6 d2             	movzbl %dl,%edx
  800735:	ff 24 95 20 33 80 00 	jmp    *0x803320(,%edx,4)
  80073c:	c6 45 d4 30          	movb   $0x30,-0x2c(%ebp)
  800740:	eb d6                	jmp    800718 <vprintfmt+0x5b>
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
				precision = precision * 10 + ch - '0';
  800742:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800745:	83 ea 30             	sub    $0x30,%edx
  800748:	89 55 d0             	mov    %edx,-0x30(%ebp)
				ch = *fmt;
  80074b:	0f be 10             	movsbl (%eax),%edx
				if (ch < '0' || ch > '9')
  80074e:	8d 5a d0             	lea    -0x30(%edx),%ebx
  800751:	83 fb 09             	cmp    $0x9,%ebx
  800754:	77 4c                	ja     8007a2 <vprintfmt+0xe5>
  800756:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  800759:	8b 4d d0             	mov    -0x30(%ebp),%ecx
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  80075c:	83 c0 01             	add    $0x1,%eax
				precision = precision * 10 + ch - '0';
  80075f:	8d 0c 89             	lea    (%ecx,%ecx,4),%ecx
  800762:	8d 4c 4a d0          	lea    -0x30(%edx,%ecx,2),%ecx
				ch = *fmt;
  800766:	0f be 10             	movsbl (%eax),%edx
				if (ch < '0' || ch > '9')
  800769:	8d 5a d0             	lea    -0x30(%edx),%ebx
  80076c:	83 fb 09             	cmp    $0x9,%ebx
  80076f:	76 eb                	jbe    80075c <vprintfmt+0x9f>
  800771:	89 4d d0             	mov    %ecx,-0x30(%ebp)
  800774:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  800777:	eb 29                	jmp    8007a2 <vprintfmt+0xe5>
					break;
			}
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800779:	8b 55 14             	mov    0x14(%ebp),%edx
  80077c:	8d 5a 04             	lea    0x4(%edx),%ebx
  80077f:	89 5d 14             	mov    %ebx,0x14(%ebp)
  800782:	8b 12                	mov    (%edx),%edx
  800784:	89 55 d0             	mov    %edx,-0x30(%ebp)
			goto process_precision;
  800787:	eb 19                	jmp    8007a2 <vprintfmt+0xe5>

		case '.':
			if (width < 0)
  800789:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80078c:	c1 fa 1f             	sar    $0x1f,%edx
  80078f:	f7 d2                	not    %edx
  800791:	21 55 e4             	and    %edx,-0x1c(%ebp)
  800794:	eb 82                	jmp    800718 <vprintfmt+0x5b>
  800796:	c7 45 d8 01 00 00 00 	movl   $0x1,-0x28(%ebp)
				width = 0;
			goto reswitch;

		case '#':
			altflag = 1;
			goto reswitch;
  80079d:	e9 76 ff ff ff       	jmp    800718 <vprintfmt+0x5b>

		process_precision:
			if (width < 0)
  8007a2:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8007a6:	0f 89 6c ff ff ff    	jns    800718 <vprintfmt+0x5b>
  8007ac:	8b 55 d0             	mov    -0x30(%ebp),%edx
  8007af:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  8007b2:	8b 55 c8             	mov    -0x38(%ebp),%edx
  8007b5:	89 55 d0             	mov    %edx,-0x30(%ebp)
  8007b8:	e9 5b ff ff ff       	jmp    800718 <vprintfmt+0x5b>
				width = precision, precision = -1;
			goto reswitch;

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  8007bd:	83 c1 01             	add    $0x1,%ecx
			goto reswitch;
  8007c0:	e9 53 ff ff ff       	jmp    800718 <vprintfmt+0x5b>
  8007c5:	89 45 cc             	mov    %eax,-0x34(%ebp)

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  8007c8:	8b 45 14             	mov    0x14(%ebp),%eax
  8007cb:	8d 50 04             	lea    0x4(%eax),%edx
  8007ce:	89 55 14             	mov    %edx,0x14(%ebp)
  8007d1:	89 74 24 04          	mov    %esi,0x4(%esp)
  8007d5:	8b 00                	mov    (%eax),%eax
  8007d7:	89 04 24             	mov    %eax,(%esp)
  8007da:	ff d7                	call   *%edi
  8007dc:	8b 5d cc             	mov    -0x34(%ebp),%ebx
			break;
  8007df:	e9 05 ff ff ff       	jmp    8006e9 <vprintfmt+0x2c>
  8007e4:	89 45 cc             	mov    %eax,-0x34(%ebp)

		// error message
		case 'e':
			err = va_arg(ap, int);
  8007e7:	8b 45 14             	mov    0x14(%ebp),%eax
  8007ea:	8d 50 04             	lea    0x4(%eax),%edx
  8007ed:	89 55 14             	mov    %edx,0x14(%ebp)
  8007f0:	8b 00                	mov    (%eax),%eax
  8007f2:	89 c2                	mov    %eax,%edx
  8007f4:	c1 fa 1f             	sar    $0x1f,%edx
  8007f7:	31 d0                	xor    %edx,%eax
  8007f9:	29 d0                	sub    %edx,%eax
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  8007fb:	83 f8 0f             	cmp    $0xf,%eax
  8007fe:	7f 0b                	jg     80080b <vprintfmt+0x14e>
  800800:	8b 14 85 80 34 80 00 	mov    0x803480(,%eax,4),%edx
  800807:	85 d2                	test   %edx,%edx
  800809:	75 20                	jne    80082b <vprintfmt+0x16e>
				printfmt(putch, putdat, "error %d", err);
  80080b:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80080f:	c7 44 24 08 e8 31 80 	movl   $0x8031e8,0x8(%esp)
  800816:	00 
  800817:	89 74 24 04          	mov    %esi,0x4(%esp)
  80081b:	89 3c 24             	mov    %edi,(%esp)
  80081e:	e8 31 03 00 00       	call   800b54 <printfmt>
  800823:	8b 5d cc             	mov    -0x34(%ebp),%ebx
		// error message
		case 'e':
			err = va_arg(ap, int);
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800826:	e9 be fe ff ff       	jmp    8006e9 <vprintfmt+0x2c>
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  80082b:	89 54 24 0c          	mov    %edx,0xc(%esp)
  80082f:	c7 44 24 08 c8 35 80 	movl   $0x8035c8,0x8(%esp)
  800836:	00 
  800837:	89 74 24 04          	mov    %esi,0x4(%esp)
  80083b:	89 3c 24             	mov    %edi,(%esp)
  80083e:	e8 11 03 00 00       	call   800b54 <printfmt>
  800843:	8b 5d cc             	mov    -0x34(%ebp),%ebx
  800846:	e9 9e fe ff ff       	jmp    8006e9 <vprintfmt+0x2c>
  80084b:	89 45 cc             	mov    %eax,-0x34(%ebp)
  80084e:	89 c3                	mov    %eax,%ebx
  800850:	8b 4d d0             	mov    -0x30(%ebp),%ecx
  800853:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800856:	89 45 c4             	mov    %eax,-0x3c(%ebp)
			break;

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800859:	8b 45 14             	mov    0x14(%ebp),%eax
  80085c:	8d 50 04             	lea    0x4(%eax),%edx
  80085f:	89 55 14             	mov    %edx,0x14(%ebp)
  800862:	8b 00                	mov    (%eax),%eax
  800864:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800867:	85 c0                	test   %eax,%eax
  800869:	75 07                	jne    800872 <vprintfmt+0x1b5>
  80086b:	c7 45 e0 f1 31 80 00 	movl   $0x8031f1,-0x20(%ebp)
				p = "(null)";
			if (width > 0 && padc != '-')
  800872:	83 7d c4 00          	cmpl   $0x0,-0x3c(%ebp)
  800876:	7e 06                	jle    80087e <vprintfmt+0x1c1>
  800878:	80 7d d4 2d          	cmpb   $0x2d,-0x2c(%ebp)
  80087c:	75 13                	jne    800891 <vprintfmt+0x1d4>
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  80087e:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800881:	0f be 02             	movsbl (%edx),%eax
  800884:	85 c0                	test   %eax,%eax
  800886:	0f 85 99 00 00 00    	jne    800925 <vprintfmt+0x268>
  80088c:	e9 86 00 00 00       	jmp    800917 <vprintfmt+0x25a>
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800891:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  800895:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  800898:	89 0c 24             	mov    %ecx,(%esp)
  80089b:	e8 fb 02 00 00       	call   800b9b <strnlen>
  8008a0:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  8008a3:	29 c2                	sub    %eax,%edx
  8008a5:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  8008a8:	85 d2                	test   %edx,%edx
  8008aa:	7e d2                	jle    80087e <vprintfmt+0x1c1>
					putch(padc, putdat);
  8008ac:	0f be 4d d4          	movsbl -0x2c(%ebp),%ecx
  8008b0:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  8008b3:	89 5d c4             	mov    %ebx,-0x3c(%ebp)
  8008b6:	89 d3                	mov    %edx,%ebx
  8008b8:	89 74 24 04          	mov    %esi,0x4(%esp)
  8008bc:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8008bf:	89 04 24             	mov    %eax,(%esp)
  8008c2:	ff d7                	call   *%edi
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  8008c4:	83 eb 01             	sub    $0x1,%ebx
  8008c7:	85 db                	test   %ebx,%ebx
  8008c9:	7f ed                	jg     8008b8 <vprintfmt+0x1fb>
  8008cb:	8b 5d c4             	mov    -0x3c(%ebp),%ebx
  8008ce:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  8008d5:	eb a7                	jmp    80087e <vprintfmt+0x1c1>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
  8008d7:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  8008db:	74 18                	je     8008f5 <vprintfmt+0x238>
  8008dd:	8d 50 e0             	lea    -0x20(%eax),%edx
  8008e0:	83 fa 5e             	cmp    $0x5e,%edx
  8008e3:	76 10                	jbe    8008f5 <vprintfmt+0x238>
					putch('?', putdat);
  8008e5:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8008e9:	c7 04 24 3f 00 00 00 	movl   $0x3f,(%esp)
  8008f0:	ff 55 e0             	call   *-0x20(%ebp)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
  8008f3:	eb 0a                	jmp    8008ff <vprintfmt+0x242>
					putch('?', putdat);
				else
					putch(ch, putdat);
  8008f5:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8008f9:	89 04 24             	mov    %eax,(%esp)
  8008fc:	ff 55 e0             	call   *-0x20(%ebp)
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8008ff:	83 6d e4 01          	subl   $0x1,-0x1c(%ebp)
  800903:	0f be 03             	movsbl (%ebx),%eax
  800906:	85 c0                	test   %eax,%eax
  800908:	74 05                	je     80090f <vprintfmt+0x252>
  80090a:	83 c3 01             	add    $0x1,%ebx
  80090d:	eb 29                	jmp    800938 <vprintfmt+0x27b>
  80090f:	89 fe                	mov    %edi,%esi
  800911:	8b 7d e0             	mov    -0x20(%ebp),%edi
  800914:	8b 5d d0             	mov    -0x30(%ebp),%ebx
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800917:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80091b:	7f 2e                	jg     80094b <vprintfmt+0x28e>
  80091d:	8b 5d cc             	mov    -0x34(%ebp),%ebx
  800920:	e9 c4 fd ff ff       	jmp    8006e9 <vprintfmt+0x2c>
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800925:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800928:	83 c2 01             	add    $0x1,%edx
  80092b:	89 7d e0             	mov    %edi,-0x20(%ebp)
  80092e:	89 f7                	mov    %esi,%edi
  800930:	8b 75 d0             	mov    -0x30(%ebp),%esi
  800933:	89 5d d0             	mov    %ebx,-0x30(%ebp)
  800936:	89 d3                	mov    %edx,%ebx
  800938:	85 f6                	test   %esi,%esi
  80093a:	78 9b                	js     8008d7 <vprintfmt+0x21a>
  80093c:	83 ee 01             	sub    $0x1,%esi
  80093f:	79 96                	jns    8008d7 <vprintfmt+0x21a>
  800941:	89 fe                	mov    %edi,%esi
  800943:	8b 7d e0             	mov    -0x20(%ebp),%edi
  800946:	8b 5d d0             	mov    -0x30(%ebp),%ebx
  800949:	eb cc                	jmp    800917 <vprintfmt+0x25a>
  80094b:	89 5d d8             	mov    %ebx,-0x28(%ebp)
  80094e:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
				putch(' ', putdat);
  800951:	89 74 24 04          	mov    %esi,0x4(%esp)
  800955:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  80095c:	ff d7                	call   *%edi
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  80095e:	83 eb 01             	sub    $0x1,%ebx
  800961:	85 db                	test   %ebx,%ebx
  800963:	7f ec                	jg     800951 <vprintfmt+0x294>
  800965:	8b 5d d8             	mov    -0x28(%ebp),%ebx
  800968:	e9 7c fd ff ff       	jmp    8006e9 <vprintfmt+0x2c>
  80096d:	89 45 cc             	mov    %eax,-0x34(%ebp)
// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
	if (lflag >= 2)
  800970:	83 f9 01             	cmp    $0x1,%ecx
  800973:	7e 16                	jle    80098b <vprintfmt+0x2ce>
		return va_arg(*ap, long long);
  800975:	8b 45 14             	mov    0x14(%ebp),%eax
  800978:	8d 50 08             	lea    0x8(%eax),%edx
  80097b:	89 55 14             	mov    %edx,0x14(%ebp)
  80097e:	8b 10                	mov    (%eax),%edx
  800980:	8b 48 04             	mov    0x4(%eax),%ecx
  800983:	89 55 d8             	mov    %edx,-0x28(%ebp)
  800986:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  800989:	eb 32                	jmp    8009bd <vprintfmt+0x300>
	else if (lflag)
  80098b:	85 c9                	test   %ecx,%ecx
  80098d:	74 18                	je     8009a7 <vprintfmt+0x2ea>
		return va_arg(*ap, long);
  80098f:	8b 45 14             	mov    0x14(%ebp),%eax
  800992:	8d 50 04             	lea    0x4(%eax),%edx
  800995:	89 55 14             	mov    %edx,0x14(%ebp)
  800998:	8b 00                	mov    (%eax),%eax
  80099a:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80099d:	89 c1                	mov    %eax,%ecx
  80099f:	c1 f9 1f             	sar    $0x1f,%ecx
  8009a2:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  8009a5:	eb 16                	jmp    8009bd <vprintfmt+0x300>
	else
		return va_arg(*ap, int);
  8009a7:	8b 45 14             	mov    0x14(%ebp),%eax
  8009aa:	8d 50 04             	lea    0x4(%eax),%edx
  8009ad:	89 55 14             	mov    %edx,0x14(%ebp)
  8009b0:	8b 00                	mov    (%eax),%eax
  8009b2:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8009b5:	89 c2                	mov    %eax,%edx
  8009b7:	c1 fa 1f             	sar    $0x1f,%edx
  8009ba:	89 55 dc             	mov    %edx,-0x24(%ebp)
				putch(' ', putdat);
			break;

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  8009bd:	8b 4d d8             	mov    -0x28(%ebp),%ecx
  8009c0:	8b 5d dc             	mov    -0x24(%ebp),%ebx
  8009c3:	b8 0a 00 00 00       	mov    $0xa,%eax
			if ((long long) num < 0) {
  8009c8:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8009cc:	0f 89 9b 00 00 00    	jns    800a6d <vprintfmt+0x3b0>
				putch('-', putdat);
  8009d2:	89 74 24 04          	mov    %esi,0x4(%esp)
  8009d6:	c7 04 24 2d 00 00 00 	movl   $0x2d,(%esp)
  8009dd:	ff d7                	call   *%edi
				num = -(long long) num;
  8009df:	8b 4d d8             	mov    -0x28(%ebp),%ecx
  8009e2:	8b 5d dc             	mov    -0x24(%ebp),%ebx
  8009e5:	f7 d9                	neg    %ecx
  8009e7:	83 d3 00             	adc    $0x0,%ebx
  8009ea:	f7 db                	neg    %ebx
  8009ec:	b8 0a 00 00 00       	mov    $0xa,%eax
  8009f1:	eb 7a                	jmp    800a6d <vprintfmt+0x3b0>
  8009f3:	89 45 cc             	mov    %eax,-0x34(%ebp)
			base = 10;
			goto number;

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  8009f6:	89 ca                	mov    %ecx,%edx
  8009f8:	8d 45 14             	lea    0x14(%ebp),%eax
  8009fb:	e8 66 fc ff ff       	call   800666 <getuint>
  800a00:	89 c1                	mov    %eax,%ecx
  800a02:	89 d3                	mov    %edx,%ebx
  800a04:	b8 0a 00 00 00       	mov    $0xa,%eax
			base = 10;
			goto number;
  800a09:	eb 62                	jmp    800a6d <vprintfmt+0x3b0>
  800a0b:	89 45 cc             	mov    %eax,-0x34(%ebp)
		case 'o':
			// Replace this with your code.
			// putch('X', putdat);
			// putch('X', putdat);
			// putch('X', putdat);
			num = getuint(&ap, lflag);
  800a0e:	89 ca                	mov    %ecx,%edx
  800a10:	8d 45 14             	lea    0x14(%ebp),%eax
  800a13:	e8 4e fc ff ff       	call   800666 <getuint>
  800a18:	89 c1                	mov    %eax,%ecx
  800a1a:	89 d3                	mov    %edx,%ebx
  800a1c:	b8 08 00 00 00       	mov    $0x8,%eax
			base = 8;
			goto number;
  800a21:	eb 4a                	jmp    800a6d <vprintfmt+0x3b0>
  800a23:	89 45 cc             	mov    %eax,-0x34(%ebp)
			break;

		// pointer
		case 'p':
			putch('0', putdat);
  800a26:	89 74 24 04          	mov    %esi,0x4(%esp)
  800a2a:	c7 04 24 30 00 00 00 	movl   $0x30,(%esp)
  800a31:	ff d7                	call   *%edi
			putch('x', putdat);
  800a33:	89 74 24 04          	mov    %esi,0x4(%esp)
  800a37:	c7 04 24 78 00 00 00 	movl   $0x78,(%esp)
  800a3e:	ff d7                	call   *%edi
			num = (unsigned long long)
  800a40:	8b 45 14             	mov    0x14(%ebp),%eax
  800a43:	8d 50 04             	lea    0x4(%eax),%edx
  800a46:	89 55 14             	mov    %edx,0x14(%ebp)
  800a49:	8b 08                	mov    (%eax),%ecx
  800a4b:	bb 00 00 00 00       	mov    $0x0,%ebx
  800a50:	b8 10 00 00 00       	mov    $0x10,%eax
				(uintptr_t) va_arg(ap, void *);
			base = 16;
			goto number;
  800a55:	eb 16                	jmp    800a6d <vprintfmt+0x3b0>
  800a57:	89 45 cc             	mov    %eax,-0x34(%ebp)

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800a5a:	89 ca                	mov    %ecx,%edx
  800a5c:	8d 45 14             	lea    0x14(%ebp),%eax
  800a5f:	e8 02 fc ff ff       	call   800666 <getuint>
  800a64:	89 c1                	mov    %eax,%ecx
  800a66:	89 d3                	mov    %edx,%ebx
  800a68:	b8 10 00 00 00       	mov    $0x10,%eax
			base = 16;
		number:
			printnum(putch, putdat, num, base, width, padc);
  800a6d:	0f be 55 d4          	movsbl -0x2c(%ebp),%edx
  800a71:	89 54 24 10          	mov    %edx,0x10(%esp)
  800a75:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  800a78:	89 54 24 0c          	mov    %edx,0xc(%esp)
  800a7c:	89 44 24 08          	mov    %eax,0x8(%esp)
  800a80:	89 0c 24             	mov    %ecx,(%esp)
  800a83:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  800a87:	89 f2                	mov    %esi,%edx
  800a89:	89 f8                	mov    %edi,%eax
  800a8b:	e8 e0 fa ff ff       	call   800570 <printnum>
  800a90:	8b 5d cc             	mov    -0x34(%ebp),%ebx
			break;
  800a93:	e9 51 fc ff ff       	jmp    8006e9 <vprintfmt+0x2c>
  800a98:	89 45 cc             	mov    %eax,-0x34(%ebp)
  800a9b:	8b 55 e0             	mov    -0x20(%ebp),%edx

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800a9e:	89 74 24 04          	mov    %esi,0x4(%esp)
  800aa2:	89 14 24             	mov    %edx,(%esp)
  800aa5:	ff d7                	call   *%edi
  800aa7:	8b 5d cc             	mov    -0x34(%ebp),%ebx
			break;
  800aaa:	e9 3a fc ff ff       	jmp    8006e9 <vprintfmt+0x2c>
			
		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800aaf:	89 74 24 04          	mov    %esi,0x4(%esp)
  800ab3:	c7 04 24 25 00 00 00 	movl   $0x25,(%esp)
  800aba:	ff d7                	call   *%edi
			for (fmt--; fmt[-1] != '%'; fmt--)
  800abc:	8d 43 ff             	lea    -0x1(%ebx),%eax
  800abf:	80 38 25             	cmpb   $0x25,(%eax)
  800ac2:	0f 84 21 fc ff ff    	je     8006e9 <vprintfmt+0x2c>
  800ac8:	89 c3                	mov    %eax,%ebx
  800aca:	eb f0                	jmp    800abc <vprintfmt+0x3ff>
				/* do nothing */;
			break;
		}
	}
}
  800acc:	83 c4 5c             	add    $0x5c,%esp
  800acf:	5b                   	pop    %ebx
  800ad0:	5e                   	pop    %esi
  800ad1:	5f                   	pop    %edi
  800ad2:	5d                   	pop    %ebp
  800ad3:	c3                   	ret    

00800ad4 <vsnprintf>:
		*b->buf++ = ch;
}

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800ad4:	55                   	push   %ebp
  800ad5:	89 e5                	mov    %esp,%ebp
  800ad7:	83 ec 28             	sub    $0x28,%esp
  800ada:	8b 45 08             	mov    0x8(%ebp),%eax
  800add:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};

	if (buf == NULL || n < 1)
  800ae0:	85 c0                	test   %eax,%eax
  800ae2:	74 04                	je     800ae8 <vsnprintf+0x14>
  800ae4:	85 d2                	test   %edx,%edx
  800ae6:	7f 07                	jg     800aef <vsnprintf+0x1b>
  800ae8:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800aed:	eb 3b                	jmp    800b2a <vsnprintf+0x56>
}

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
	struct sprintbuf b = {buf, buf+n-1, 0};
  800aef:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800af2:	8d 44 10 ff          	lea    -0x1(%eax,%edx,1),%eax
  800af6:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800af9:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800b00:	8b 45 14             	mov    0x14(%ebp),%eax
  800b03:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800b07:	8b 45 10             	mov    0x10(%ebp),%eax
  800b0a:	89 44 24 08          	mov    %eax,0x8(%esp)
  800b0e:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800b11:	89 44 24 04          	mov    %eax,0x4(%esp)
  800b15:	c7 04 24 a0 06 80 00 	movl   $0x8006a0,(%esp)
  800b1c:	e8 9c fb ff ff       	call   8006bd <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  800b21:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800b24:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800b27:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800b2a:	c9                   	leave  
  800b2b:	c3                   	ret    

00800b2c <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800b2c:	55                   	push   %ebp
  800b2d:	89 e5                	mov    %esp,%ebp
  800b2f:	83 ec 18             	sub    $0x18,%esp

	return b.cnt;
}

int
snprintf(char *buf, int n, const char *fmt, ...)
  800b32:	8d 45 14             	lea    0x14(%ebp),%eax
{
	va_list ap;
	int rc;

	va_start(ap, fmt);
	rc = vsnprintf(buf, n, fmt, ap);
  800b35:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800b39:	8b 45 10             	mov    0x10(%ebp),%eax
  800b3c:	89 44 24 08          	mov    %eax,0x8(%esp)
  800b40:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b43:	89 44 24 04          	mov    %eax,0x4(%esp)
  800b47:	8b 45 08             	mov    0x8(%ebp),%eax
  800b4a:	89 04 24             	mov    %eax,(%esp)
  800b4d:	e8 82 ff ff ff       	call   800ad4 <vsnprintf>
	va_end(ap);

	return rc;
}
  800b52:	c9                   	leave  
  800b53:	c3                   	ret    

00800b54 <printfmt>:
	}
}

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800b54:	55                   	push   %ebp
  800b55:	89 e5                	mov    %esp,%ebp
  800b57:	83 ec 18             	sub    $0x18,%esp
		}
	}
}

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
  800b5a:	8d 45 14             	lea    0x14(%ebp),%eax
{
	va_list ap;

	va_start(ap, fmt);
	vprintfmt(putch, putdat, fmt, ap);
  800b5d:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800b61:	8b 45 10             	mov    0x10(%ebp),%eax
  800b64:	89 44 24 08          	mov    %eax,0x8(%esp)
  800b68:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b6b:	89 44 24 04          	mov    %eax,0x4(%esp)
  800b6f:	8b 45 08             	mov    0x8(%ebp),%eax
  800b72:	89 04 24             	mov    %eax,(%esp)
  800b75:	e8 43 fb ff ff       	call   8006bd <vprintfmt>
	va_end(ap);
}
  800b7a:	c9                   	leave  
  800b7b:	c3                   	ret    
  800b7c:	00 00                	add    %al,(%eax)
	...

00800b80 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800b80:	55                   	push   %ebp
  800b81:	89 e5                	mov    %esp,%ebp
  800b83:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  800b86:	b8 00 00 00 00       	mov    $0x0,%eax
  800b8b:	80 3a 00             	cmpb   $0x0,(%edx)
  800b8e:	74 09                	je     800b99 <strlen+0x19>
		n++;
  800b90:	83 c0 01             	add    $0x1,%eax
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800b93:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  800b97:	75 f7                	jne    800b90 <strlen+0x10>
		n++;
	return n;
}
  800b99:	5d                   	pop    %ebp
  800b9a:	c3                   	ret    

00800b9b <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800b9b:	55                   	push   %ebp
  800b9c:	89 e5                	mov    %esp,%ebp
  800b9e:	53                   	push   %ebx
  800b9f:	8b 5d 08             	mov    0x8(%ebp),%ebx
  800ba2:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800ba5:	85 c9                	test   %ecx,%ecx
  800ba7:	74 19                	je     800bc2 <strnlen+0x27>
  800ba9:	80 3b 00             	cmpb   $0x0,(%ebx)
  800bac:	74 14                	je     800bc2 <strnlen+0x27>
  800bae:	b8 00 00 00 00       	mov    $0x0,%eax
		n++;
  800bb3:	83 c0 01             	add    $0x1,%eax
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800bb6:	39 c8                	cmp    %ecx,%eax
  800bb8:	74 0d                	je     800bc7 <strnlen+0x2c>
  800bba:	80 3c 03 00          	cmpb   $0x0,(%ebx,%eax,1)
  800bbe:	75 f3                	jne    800bb3 <strnlen+0x18>
  800bc0:	eb 05                	jmp    800bc7 <strnlen+0x2c>
  800bc2:	b8 00 00 00 00       	mov    $0x0,%eax
		n++;
	return n;
}
  800bc7:	5b                   	pop    %ebx
  800bc8:	5d                   	pop    %ebp
  800bc9:	c3                   	ret    

00800bca <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800bca:	55                   	push   %ebp
  800bcb:	89 e5                	mov    %esp,%ebp
  800bcd:	53                   	push   %ebx
  800bce:	8b 45 08             	mov    0x8(%ebp),%eax
  800bd1:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800bd4:	ba 00 00 00 00       	mov    $0x0,%edx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  800bd9:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
  800bdd:	88 0c 10             	mov    %cl,(%eax,%edx,1)
  800be0:	83 c2 01             	add    $0x1,%edx
  800be3:	84 c9                	test   %cl,%cl
  800be5:	75 f2                	jne    800bd9 <strcpy+0xf>
		/* do nothing */;
	return ret;
}
  800be7:	5b                   	pop    %ebx
  800be8:	5d                   	pop    %ebp
  800be9:	c3                   	ret    

00800bea <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800bea:	55                   	push   %ebp
  800beb:	89 e5                	mov    %esp,%ebp
  800bed:	56                   	push   %esi
  800bee:	53                   	push   %ebx
  800bef:	8b 45 08             	mov    0x8(%ebp),%eax
  800bf2:	8b 55 0c             	mov    0xc(%ebp),%edx
  800bf5:	8b 75 10             	mov    0x10(%ebp),%esi
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800bf8:	85 f6                	test   %esi,%esi
  800bfa:	74 18                	je     800c14 <strncpy+0x2a>
  800bfc:	b9 00 00 00 00       	mov    $0x0,%ecx
		*dst++ = *src;
  800c01:	0f b6 1a             	movzbl (%edx),%ebx
  800c04:	88 1c 08             	mov    %bl,(%eax,%ecx,1)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  800c07:	80 3a 01             	cmpb   $0x1,(%edx)
  800c0a:	83 da ff             	sbb    $0xffffffff,%edx
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800c0d:	83 c1 01             	add    $0x1,%ecx
  800c10:	39 ce                	cmp    %ecx,%esi
  800c12:	77 ed                	ja     800c01 <strncpy+0x17>
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
}
  800c14:	5b                   	pop    %ebx
  800c15:	5e                   	pop    %esi
  800c16:	5d                   	pop    %ebp
  800c17:	c3                   	ret    

00800c18 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800c18:	55                   	push   %ebp
  800c19:	89 e5                	mov    %esp,%ebp
  800c1b:	56                   	push   %esi
  800c1c:	53                   	push   %ebx
  800c1d:	8b 75 08             	mov    0x8(%ebp),%esi
  800c20:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c23:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  800c26:	89 f0                	mov    %esi,%eax
  800c28:	85 c9                	test   %ecx,%ecx
  800c2a:	74 27                	je     800c53 <strlcpy+0x3b>
		while (--size > 0 && *src != '\0')
  800c2c:	83 e9 01             	sub    $0x1,%ecx
  800c2f:	74 1d                	je     800c4e <strlcpy+0x36>
  800c31:	0f b6 1a             	movzbl (%edx),%ebx
  800c34:	84 db                	test   %bl,%bl
  800c36:	74 16                	je     800c4e <strlcpy+0x36>
			*dst++ = *src++;
  800c38:	88 18                	mov    %bl,(%eax)
  800c3a:	83 c0 01             	add    $0x1,%eax
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800c3d:	83 e9 01             	sub    $0x1,%ecx
  800c40:	74 0e                	je     800c50 <strlcpy+0x38>
			*dst++ = *src++;
  800c42:	83 c2 01             	add    $0x1,%edx
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800c45:	0f b6 1a             	movzbl (%edx),%ebx
  800c48:	84 db                	test   %bl,%bl
  800c4a:	75 ec                	jne    800c38 <strlcpy+0x20>
  800c4c:	eb 02                	jmp    800c50 <strlcpy+0x38>
  800c4e:	89 f0                	mov    %esi,%eax
			*dst++ = *src++;
		*dst = '\0';
  800c50:	c6 00 00             	movb   $0x0,(%eax)
  800c53:	29 f0                	sub    %esi,%eax
	}
	return dst - dst_in;
}
  800c55:	5b                   	pop    %ebx
  800c56:	5e                   	pop    %esi
  800c57:	5d                   	pop    %ebp
  800c58:	c3                   	ret    

00800c59 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800c59:	55                   	push   %ebp
  800c5a:	89 e5                	mov    %esp,%ebp
  800c5c:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800c5f:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  800c62:	0f b6 01             	movzbl (%ecx),%eax
  800c65:	84 c0                	test   %al,%al
  800c67:	74 15                	je     800c7e <strcmp+0x25>
  800c69:	3a 02                	cmp    (%edx),%al
  800c6b:	75 11                	jne    800c7e <strcmp+0x25>
		p++, q++;
  800c6d:	83 c1 01             	add    $0x1,%ecx
  800c70:	83 c2 01             	add    $0x1,%edx
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800c73:	0f b6 01             	movzbl (%ecx),%eax
  800c76:	84 c0                	test   %al,%al
  800c78:	74 04                	je     800c7e <strcmp+0x25>
  800c7a:	3a 02                	cmp    (%edx),%al
  800c7c:	74 ef                	je     800c6d <strcmp+0x14>
  800c7e:	0f b6 c0             	movzbl %al,%eax
  800c81:	0f b6 12             	movzbl (%edx),%edx
  800c84:	29 d0                	sub    %edx,%eax
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
}
  800c86:	5d                   	pop    %ebp
  800c87:	c3                   	ret    

00800c88 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800c88:	55                   	push   %ebp
  800c89:	89 e5                	mov    %esp,%ebp
  800c8b:	53                   	push   %ebx
  800c8c:	8b 55 08             	mov    0x8(%ebp),%edx
  800c8f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c92:	8b 45 10             	mov    0x10(%ebp),%eax
	while (n > 0 && *p && *p == *q)
  800c95:	85 c0                	test   %eax,%eax
  800c97:	74 23                	je     800cbc <strncmp+0x34>
  800c99:	0f b6 1a             	movzbl (%edx),%ebx
  800c9c:	84 db                	test   %bl,%bl
  800c9e:	74 24                	je     800cc4 <strncmp+0x3c>
  800ca0:	3a 19                	cmp    (%ecx),%bl
  800ca2:	75 20                	jne    800cc4 <strncmp+0x3c>
  800ca4:	83 e8 01             	sub    $0x1,%eax
  800ca7:	74 13                	je     800cbc <strncmp+0x34>
		n--, p++, q++;
  800ca9:	83 c2 01             	add    $0x1,%edx
  800cac:	83 c1 01             	add    $0x1,%ecx
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  800caf:	0f b6 1a             	movzbl (%edx),%ebx
  800cb2:	84 db                	test   %bl,%bl
  800cb4:	74 0e                	je     800cc4 <strncmp+0x3c>
  800cb6:	3a 19                	cmp    (%ecx),%bl
  800cb8:	74 ea                	je     800ca4 <strncmp+0x1c>
  800cba:	eb 08                	jmp    800cc4 <strncmp+0x3c>
  800cbc:	b8 00 00 00 00       	mov    $0x0,%eax
		n--, p++, q++;
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
}
  800cc1:	5b                   	pop    %ebx
  800cc2:	5d                   	pop    %ebp
  800cc3:	c3                   	ret    
	while (n > 0 && *p && *p == *q)
		n--, p++, q++;
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800cc4:	0f b6 02             	movzbl (%edx),%eax
  800cc7:	0f b6 11             	movzbl (%ecx),%edx
  800cca:	29 d0                	sub    %edx,%eax
  800ccc:	eb f3                	jmp    800cc1 <strncmp+0x39>

00800cce <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800cce:	55                   	push   %ebp
  800ccf:	89 e5                	mov    %esp,%ebp
  800cd1:	8b 45 08             	mov    0x8(%ebp),%eax
  800cd4:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800cd8:	0f b6 10             	movzbl (%eax),%edx
  800cdb:	84 d2                	test   %dl,%dl
  800cdd:	74 15                	je     800cf4 <strchr+0x26>
		if (*s == c)
  800cdf:	38 ca                	cmp    %cl,%dl
  800ce1:	75 07                	jne    800cea <strchr+0x1c>
  800ce3:	eb 14                	jmp    800cf9 <strchr+0x2b>
  800ce5:	38 ca                	cmp    %cl,%dl
  800ce7:	90                   	nop
  800ce8:	74 0f                	je     800cf9 <strchr+0x2b>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800cea:	83 c0 01             	add    $0x1,%eax
  800ced:	0f b6 10             	movzbl (%eax),%edx
  800cf0:	84 d2                	test   %dl,%dl
  800cf2:	75 f1                	jne    800ce5 <strchr+0x17>
  800cf4:	b8 00 00 00 00       	mov    $0x0,%eax
		if (*s == c)
			return (char *) s;
	return 0;
}
  800cf9:	5d                   	pop    %ebp
  800cfa:	c3                   	ret    

00800cfb <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800cfb:	55                   	push   %ebp
  800cfc:	89 e5                	mov    %esp,%ebp
  800cfe:	8b 45 08             	mov    0x8(%ebp),%eax
  800d01:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800d05:	0f b6 10             	movzbl (%eax),%edx
  800d08:	84 d2                	test   %dl,%dl
  800d0a:	74 18                	je     800d24 <strfind+0x29>
		if (*s == c)
  800d0c:	38 ca                	cmp    %cl,%dl
  800d0e:	75 0a                	jne    800d1a <strfind+0x1f>
  800d10:	eb 12                	jmp    800d24 <strfind+0x29>
  800d12:	38 ca                	cmp    %cl,%dl
  800d14:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  800d18:	74 0a                	je     800d24 <strfind+0x29>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800d1a:	83 c0 01             	add    $0x1,%eax
  800d1d:	0f b6 10             	movzbl (%eax),%edx
  800d20:	84 d2                	test   %dl,%dl
  800d22:	75 ee                	jne    800d12 <strfind+0x17>
		if (*s == c)
			break;
	return (char *) s;
}
  800d24:	5d                   	pop    %ebp
  800d25:	c3                   	ret    

00800d26 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800d26:	55                   	push   %ebp
  800d27:	89 e5                	mov    %esp,%ebp
  800d29:	83 ec 0c             	sub    $0xc,%esp
  800d2c:	89 1c 24             	mov    %ebx,(%esp)
  800d2f:	89 74 24 04          	mov    %esi,0x4(%esp)
  800d33:	89 7c 24 08          	mov    %edi,0x8(%esp)
  800d37:	8b 7d 08             	mov    0x8(%ebp),%edi
  800d3a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d3d:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800d40:	85 c9                	test   %ecx,%ecx
  800d42:	74 30                	je     800d74 <memset+0x4e>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800d44:	f7 c7 03 00 00 00    	test   $0x3,%edi
  800d4a:	75 25                	jne    800d71 <memset+0x4b>
  800d4c:	f6 c1 03             	test   $0x3,%cl
  800d4f:	75 20                	jne    800d71 <memset+0x4b>
		c &= 0xFF;
  800d51:	0f b6 d0             	movzbl %al,%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800d54:	89 d3                	mov    %edx,%ebx
  800d56:	c1 e3 08             	shl    $0x8,%ebx
  800d59:	89 d6                	mov    %edx,%esi
  800d5b:	c1 e6 18             	shl    $0x18,%esi
  800d5e:	89 d0                	mov    %edx,%eax
  800d60:	c1 e0 10             	shl    $0x10,%eax
  800d63:	09 f0                	or     %esi,%eax
  800d65:	09 d0                	or     %edx,%eax
		asm volatile("cld; rep stosl\n"
  800d67:	09 d8                	or     %ebx,%eax
  800d69:	c1 e9 02             	shr    $0x2,%ecx
  800d6c:	fc                   	cld    
  800d6d:	f3 ab                	rep stos %eax,%es:(%edi)
{
	char *p;

	if (n == 0)
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800d6f:	eb 03                	jmp    800d74 <memset+0x4e>
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800d71:	fc                   	cld    
  800d72:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800d74:	89 f8                	mov    %edi,%eax
  800d76:	8b 1c 24             	mov    (%esp),%ebx
  800d79:	8b 74 24 04          	mov    0x4(%esp),%esi
  800d7d:	8b 7c 24 08          	mov    0x8(%esp),%edi
  800d81:	89 ec                	mov    %ebp,%esp
  800d83:	5d                   	pop    %ebp
  800d84:	c3                   	ret    

00800d85 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800d85:	55                   	push   %ebp
  800d86:	89 e5                	mov    %esp,%ebp
  800d88:	83 ec 08             	sub    $0x8,%esp
  800d8b:	89 34 24             	mov    %esi,(%esp)
  800d8e:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800d92:	8b 45 08             	mov    0x8(%ebp),%eax
  800d95:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;
	
	s = src;
  800d98:	8b 75 0c             	mov    0xc(%ebp),%esi
	d = dst;
  800d9b:	89 c7                	mov    %eax,%edi
	if (s < d && s + n > d) {
  800d9d:	39 c6                	cmp    %eax,%esi
  800d9f:	73 35                	jae    800dd6 <memmove+0x51>
  800da1:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800da4:	39 d0                	cmp    %edx,%eax
  800da6:	73 2e                	jae    800dd6 <memmove+0x51>
		s += n;
		d += n;
  800da8:	01 cf                	add    %ecx,%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800daa:	f6 c2 03             	test   $0x3,%dl
  800dad:	75 1b                	jne    800dca <memmove+0x45>
  800daf:	f7 c7 03 00 00 00    	test   $0x3,%edi
  800db5:	75 13                	jne    800dca <memmove+0x45>
  800db7:	f6 c1 03             	test   $0x3,%cl
  800dba:	75 0e                	jne    800dca <memmove+0x45>
			asm volatile("std; rep movsl\n"
  800dbc:	83 ef 04             	sub    $0x4,%edi
  800dbf:	8d 72 fc             	lea    -0x4(%edx),%esi
  800dc2:	c1 e9 02             	shr    $0x2,%ecx
  800dc5:	fd                   	std    
  800dc6:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800dc8:	eb 09                	jmp    800dd3 <memmove+0x4e>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  800dca:	83 ef 01             	sub    $0x1,%edi
  800dcd:	8d 72 ff             	lea    -0x1(%edx),%esi
  800dd0:	fd                   	std    
  800dd1:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800dd3:	fc                   	cld    
	const char *s;
	char *d;
	
	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800dd4:	eb 20                	jmp    800df6 <memmove+0x71>
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800dd6:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800ddc:	75 15                	jne    800df3 <memmove+0x6e>
  800dde:	f7 c7 03 00 00 00    	test   $0x3,%edi
  800de4:	75 0d                	jne    800df3 <memmove+0x6e>
  800de6:	f6 c1 03             	test   $0x3,%cl
  800de9:	75 08                	jne    800df3 <memmove+0x6e>
			asm volatile("cld; rep movsl\n"
  800deb:	c1 e9 02             	shr    $0x2,%ecx
  800dee:	fc                   	cld    
  800def:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800df1:	eb 03                	jmp    800df6 <memmove+0x71>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  800df3:	fc                   	cld    
  800df4:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800df6:	8b 34 24             	mov    (%esp),%esi
  800df9:	8b 7c 24 04          	mov    0x4(%esp),%edi
  800dfd:	89 ec                	mov    %ebp,%esp
  800dff:	5d                   	pop    %ebp
  800e00:	c3                   	ret    

00800e01 <memcpy>:

/* sigh - gcc emits references to this for structure assignments! */
/* it is *not* prototyped in inc/string.h - do not use directly. */
void *
memcpy(void *dst, void *src, size_t n)
{
  800e01:	55                   	push   %ebp
  800e02:	89 e5                	mov    %esp,%ebp
  800e04:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  800e07:	8b 45 10             	mov    0x10(%ebp),%eax
  800e0a:	89 44 24 08          	mov    %eax,0x8(%esp)
  800e0e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e11:	89 44 24 04          	mov    %eax,0x4(%esp)
  800e15:	8b 45 08             	mov    0x8(%ebp),%eax
  800e18:	89 04 24             	mov    %eax,(%esp)
  800e1b:	e8 65 ff ff ff       	call   800d85 <memmove>
}
  800e20:	c9                   	leave  
  800e21:	c3                   	ret    

00800e22 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800e22:	55                   	push   %ebp
  800e23:	89 e5                	mov    %esp,%ebp
  800e25:	57                   	push   %edi
  800e26:	56                   	push   %esi
  800e27:	53                   	push   %ebx
  800e28:	8b 75 08             	mov    0x8(%ebp),%esi
  800e2b:	8b 7d 0c             	mov    0xc(%ebp),%edi
  800e2e:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800e31:	85 c9                	test   %ecx,%ecx
  800e33:	74 36                	je     800e6b <memcmp+0x49>
		if (*s1 != *s2)
  800e35:	0f b6 06             	movzbl (%esi),%eax
  800e38:	0f b6 1f             	movzbl (%edi),%ebx
  800e3b:	38 d8                	cmp    %bl,%al
  800e3d:	74 20                	je     800e5f <memcmp+0x3d>
  800e3f:	eb 14                	jmp    800e55 <memcmp+0x33>
  800e41:	0f b6 44 16 01       	movzbl 0x1(%esi,%edx,1),%eax
  800e46:	0f b6 5c 17 01       	movzbl 0x1(%edi,%edx,1),%ebx
  800e4b:	83 c2 01             	add    $0x1,%edx
  800e4e:	83 e9 01             	sub    $0x1,%ecx
  800e51:	38 d8                	cmp    %bl,%al
  800e53:	74 12                	je     800e67 <memcmp+0x45>
			return (int) *s1 - (int) *s2;
  800e55:	0f b6 c0             	movzbl %al,%eax
  800e58:	0f b6 db             	movzbl %bl,%ebx
  800e5b:	29 d8                	sub    %ebx,%eax
  800e5d:	eb 11                	jmp    800e70 <memcmp+0x4e>
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800e5f:	83 e9 01             	sub    $0x1,%ecx
  800e62:	ba 00 00 00 00       	mov    $0x0,%edx
  800e67:	85 c9                	test   %ecx,%ecx
  800e69:	75 d6                	jne    800e41 <memcmp+0x1f>
  800e6b:	b8 00 00 00 00       	mov    $0x0,%eax
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
}
  800e70:	5b                   	pop    %ebx
  800e71:	5e                   	pop    %esi
  800e72:	5f                   	pop    %edi
  800e73:	5d                   	pop    %ebp
  800e74:	c3                   	ret    

00800e75 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800e75:	55                   	push   %ebp
  800e76:	89 e5                	mov    %esp,%ebp
  800e78:	8b 45 08             	mov    0x8(%ebp),%eax
	const void *ends = (const char *) s + n;
  800e7b:	89 c2                	mov    %eax,%edx
  800e7d:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800e80:	39 d0                	cmp    %edx,%eax
  800e82:	73 15                	jae    800e99 <memfind+0x24>
		if (*(const unsigned char *) s == (unsigned char) c)
  800e84:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
  800e88:	38 08                	cmp    %cl,(%eax)
  800e8a:	75 06                	jne    800e92 <memfind+0x1d>
  800e8c:	eb 0b                	jmp    800e99 <memfind+0x24>
  800e8e:	38 08                	cmp    %cl,(%eax)
  800e90:	74 07                	je     800e99 <memfind+0x24>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800e92:	83 c0 01             	add    $0x1,%eax
  800e95:	39 c2                	cmp    %eax,%edx
  800e97:	77 f5                	ja     800e8e <memfind+0x19>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
	return (void *) s;
}
  800e99:	5d                   	pop    %ebp
  800e9a:	c3                   	ret    

00800e9b <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800e9b:	55                   	push   %ebp
  800e9c:	89 e5                	mov    %esp,%ebp
  800e9e:	57                   	push   %edi
  800e9f:	56                   	push   %esi
  800ea0:	53                   	push   %ebx
  800ea1:	83 ec 04             	sub    $0x4,%esp
  800ea4:	8b 55 08             	mov    0x8(%ebp),%edx
  800ea7:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800eaa:	0f b6 02             	movzbl (%edx),%eax
  800ead:	3c 20                	cmp    $0x20,%al
  800eaf:	74 04                	je     800eb5 <strtol+0x1a>
  800eb1:	3c 09                	cmp    $0x9,%al
  800eb3:	75 0e                	jne    800ec3 <strtol+0x28>
		s++;
  800eb5:	83 c2 01             	add    $0x1,%edx
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800eb8:	0f b6 02             	movzbl (%edx),%eax
  800ebb:	3c 20                	cmp    $0x20,%al
  800ebd:	74 f6                	je     800eb5 <strtol+0x1a>
  800ebf:	3c 09                	cmp    $0x9,%al
  800ec1:	74 f2                	je     800eb5 <strtol+0x1a>
		s++;

	// plus/minus sign
	if (*s == '+')
  800ec3:	3c 2b                	cmp    $0x2b,%al
  800ec5:	75 0c                	jne    800ed3 <strtol+0x38>
		s++;
  800ec7:	83 c2 01             	add    $0x1,%edx
  800eca:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800ed1:	eb 15                	jmp    800ee8 <strtol+0x4d>
	else if (*s == '-')
  800ed3:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800eda:	3c 2d                	cmp    $0x2d,%al
  800edc:	75 0a                	jne    800ee8 <strtol+0x4d>
		s++, neg = 1;
  800ede:	83 c2 01             	add    $0x1,%edx
  800ee1:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800ee8:	85 db                	test   %ebx,%ebx
  800eea:	0f 94 c0             	sete   %al
  800eed:	74 05                	je     800ef4 <strtol+0x59>
  800eef:	83 fb 10             	cmp    $0x10,%ebx
  800ef2:	75 18                	jne    800f0c <strtol+0x71>
  800ef4:	80 3a 30             	cmpb   $0x30,(%edx)
  800ef7:	75 13                	jne    800f0c <strtol+0x71>
  800ef9:	80 7a 01 78          	cmpb   $0x78,0x1(%edx)
  800efd:	8d 76 00             	lea    0x0(%esi),%esi
  800f00:	75 0a                	jne    800f0c <strtol+0x71>
		s += 2, base = 16;
  800f02:	83 c2 02             	add    $0x2,%edx
  800f05:	bb 10 00 00 00       	mov    $0x10,%ebx
		s++;
	else if (*s == '-')
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800f0a:	eb 15                	jmp    800f21 <strtol+0x86>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  800f0c:	84 c0                	test   %al,%al
  800f0e:	66 90                	xchg   %ax,%ax
  800f10:	74 0f                	je     800f21 <strtol+0x86>
  800f12:	bb 0a 00 00 00       	mov    $0xa,%ebx
  800f17:	80 3a 30             	cmpb   $0x30,(%edx)
  800f1a:	75 05                	jne    800f21 <strtol+0x86>
		s++, base = 8;
  800f1c:	83 c2 01             	add    $0x1,%edx
  800f1f:	b3 08                	mov    $0x8,%bl
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  800f21:	b8 00 00 00 00       	mov    $0x0,%eax
  800f26:	89 de                	mov    %ebx,%esi

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  800f28:	0f b6 0a             	movzbl (%edx),%ecx
  800f2b:	89 cf                	mov    %ecx,%edi
  800f2d:	8d 59 d0             	lea    -0x30(%ecx),%ebx
  800f30:	80 fb 09             	cmp    $0x9,%bl
  800f33:	77 08                	ja     800f3d <strtol+0xa2>
			dig = *s - '0';
  800f35:	0f be c9             	movsbl %cl,%ecx
  800f38:	83 e9 30             	sub    $0x30,%ecx
  800f3b:	eb 1e                	jmp    800f5b <strtol+0xc0>
		else if (*s >= 'a' && *s <= 'z')
  800f3d:	8d 5f 9f             	lea    -0x61(%edi),%ebx
  800f40:	80 fb 19             	cmp    $0x19,%bl
  800f43:	77 08                	ja     800f4d <strtol+0xb2>
			dig = *s - 'a' + 10;
  800f45:	0f be c9             	movsbl %cl,%ecx
  800f48:	83 e9 57             	sub    $0x57,%ecx
  800f4b:	eb 0e                	jmp    800f5b <strtol+0xc0>
		else if (*s >= 'A' && *s <= 'Z')
  800f4d:	8d 5f bf             	lea    -0x41(%edi),%ebx
  800f50:	80 fb 19             	cmp    $0x19,%bl
  800f53:	77 15                	ja     800f6a <strtol+0xcf>
			dig = *s - 'A' + 10;
  800f55:	0f be c9             	movsbl %cl,%ecx
  800f58:	83 e9 37             	sub    $0x37,%ecx
		else
			break;
		if (dig >= base)
  800f5b:	39 f1                	cmp    %esi,%ecx
  800f5d:	7d 0b                	jge    800f6a <strtol+0xcf>
			break;
		s++, val = (val * base) + dig;
  800f5f:	83 c2 01             	add    $0x1,%edx
  800f62:	0f af c6             	imul   %esi,%eax
  800f65:	8d 04 01             	lea    (%ecx,%eax,1),%eax
		// we don't properly detect overflow!
	}
  800f68:	eb be                	jmp    800f28 <strtol+0x8d>
  800f6a:	89 c1                	mov    %eax,%ecx

	if (endptr)
  800f6c:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800f70:	74 05                	je     800f77 <strtol+0xdc>
		*endptr = (char *) s;
  800f72:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800f75:	89 13                	mov    %edx,(%ebx)
	return (neg ? -val : val);
  800f77:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  800f7b:	74 04                	je     800f81 <strtol+0xe6>
  800f7d:	89 c8                	mov    %ecx,%eax
  800f7f:	f7 d8                	neg    %eax
}
  800f81:	83 c4 04             	add    $0x4,%esp
  800f84:	5b                   	pop    %ebx
  800f85:	5e                   	pop    %esi
  800f86:	5f                   	pop    %edi
  800f87:	5d                   	pop    %ebp
  800f88:	c3                   	ret    
  800f89:	00 00                	add    %al,(%eax)
	...

00800f8c <sys_cgetc>:
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}

int
sys_cgetc(void)
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
  800fa2:	b8 01 00 00 00       	mov    $0x1,%eax
  800fa7:	89 d1                	mov    %edx,%ecx
  800fa9:	89 d3                	mov    %edx,%ebx
  800fab:	89 d7                	mov    %edx,%edi
  800fad:	89 d6                	mov    %edx,%esi
  800faf:	cd 30                	int    $0x30

int
sys_cgetc(void)
{
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800fb1:	8b 1c 24             	mov    (%esp),%ebx
  800fb4:	8b 74 24 04          	mov    0x4(%esp),%esi
  800fb8:	8b 7c 24 08          	mov    0x8(%esp),%edi
  800fbc:	89 ec                	mov    %ebp,%esp
  800fbe:	5d                   	pop    %ebp
  800fbf:	c3                   	ret    

00800fc0 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800fc0:	55                   	push   %ebp
  800fc1:	89 e5                	mov    %esp,%ebp
  800fc3:	83 ec 0c             	sub    $0xc,%esp
  800fc6:	89 1c 24             	mov    %ebx,(%esp)
  800fc9:	89 74 24 04          	mov    %esi,0x4(%esp)
  800fcd:	89 7c 24 08          	mov    %edi,0x8(%esp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800fd1:	b8 00 00 00 00       	mov    $0x0,%eax
  800fd6:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800fd9:	8b 55 08             	mov    0x8(%ebp),%edx
  800fdc:	89 c3                	mov    %eax,%ebx
  800fde:	89 c7                	mov    %eax,%edi
  800fe0:	89 c6                	mov    %eax,%esi
  800fe2:	cd 30                	int    $0x30

void
sys_cputs(const char *s, size_t len)
{
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800fe4:	8b 1c 24             	mov    (%esp),%ebx
  800fe7:	8b 74 24 04          	mov    0x4(%esp),%esi
  800feb:	8b 7c 24 08          	mov    0x8(%esp),%edi
  800fef:	89 ec                	mov    %ebp,%esp
  800ff1:	5d                   	pop    %ebp
  800ff2:	c3                   	ret    

00800ff3 <sys_page_insert>:
{
	return syscall(SYS_page_waste, 0, (uint32_t)p, (uint32_t)n, 0, 0,0);
}
int
sys_page_insert(envid_t envid, void *va, struct Page *p, int perm)
{
  800ff3:	55                   	push   %ebp
  800ff4:	89 e5                	mov    %esp,%ebp
  800ff6:	83 ec 38             	sub    $0x38,%esp
  800ff9:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800ffc:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800fff:	89 7d fc             	mov    %edi,-0x4(%ebp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801002:	be 00 00 00 00       	mov    $0x0,%esi
  801007:	b8 12 00 00 00       	mov    $0x12,%eax
  80100c:	8b 7d 14             	mov    0x14(%ebp),%edi
  80100f:	8b 5d 10             	mov    0x10(%ebp),%ebx
  801012:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801015:	8b 55 08             	mov    0x8(%ebp),%edx
  801018:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
	
	if(check && ret > 0)
  80101a:	85 c0                	test   %eax,%eax
  80101c:	7e 28                	jle    801046 <sys_page_insert+0x53>
		panic("syscall %d returned %d (> 0)", num, ret);
  80101e:	89 44 24 10          	mov    %eax,0x10(%esp)
  801022:	c7 44 24 0c 12 00 00 	movl   $0x12,0xc(%esp)
  801029:	00 
  80102a:	c7 44 24 08 df 34 80 	movl   $0x8034df,0x8(%esp)
  801031:	00 
  801032:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  801039:	00 
  80103a:	c7 04 24 fc 34 80 00 	movl   $0x8034fc,(%esp)
  801041:	e8 02 f4 ff ff       	call   800448 <_panic>
}
int
sys_page_insert(envid_t envid, void *va, struct Page *p, int perm)
{
	return syscall(SYS_page_insert, 1, envid, (uint32_t) va, (uint32_t)p, perm, 0);
}
  801046:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  801049:	8b 75 f8             	mov    -0x8(%ebp),%esi
  80104c:	8b 7d fc             	mov    -0x4(%ebp),%edi
  80104f:	89 ec                	mov    %ebp,%esp
  801051:	5d                   	pop    %ebp
  801052:	c3                   	ret    

00801053 <sys_page_waste>:
{
	return (int)syscall(SYS_receive_packet, 0, (uint32_t)buffer, 0,0,0,0);
}

int sys_page_waste(struct Page **p, int n)
{
  801053:	55                   	push   %ebp
  801054:	89 e5                	mov    %esp,%ebp
  801056:	83 ec 0c             	sub    $0xc,%esp
  801059:	89 1c 24             	mov    %ebx,(%esp)
  80105c:	89 74 24 04          	mov    %esi,0x4(%esp)
  801060:	89 7c 24 08          	mov    %edi,0x8(%esp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801064:	bb 00 00 00 00       	mov    $0x0,%ebx
  801069:	b8 11 00 00 00       	mov    $0x11,%eax
  80106e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801071:	8b 55 08             	mov    0x8(%ebp),%edx
  801074:	89 df                	mov    %ebx,%edi
  801076:	89 de                	mov    %ebx,%esi
  801078:	cd 30                	int    $0x30
}

int sys_page_waste(struct Page **p, int n)
{
	return syscall(SYS_page_waste, 0, (uint32_t)p, (uint32_t)n, 0, 0,0);
}
  80107a:	8b 1c 24             	mov    (%esp),%ebx
  80107d:	8b 74 24 04          	mov    0x4(%esp),%esi
  801081:	8b 7c 24 08          	mov    0x8(%esp),%edi
  801085:	89 ec                	mov    %ebp,%esp
  801087:	5d                   	pop    %ebp
  801088:	c3                   	ret    

00801089 <sys_receive_packet>:
{
	return (int)syscall(SYS_transmit_packet, 1, (uint32_t)data, len, 0,0,0);
}

int sys_receive_packet(void* buffer)
{
  801089:	55                   	push   %ebp
  80108a:	89 e5                	mov    %esp,%ebp
  80108c:	83 ec 0c             	sub    $0xc,%esp
  80108f:	89 1c 24             	mov    %ebx,(%esp)
  801092:	89 74 24 04          	mov    %esi,0x4(%esp)
  801096:	89 7c 24 08          	mov    %edi,0x8(%esp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80109a:	b9 00 00 00 00       	mov    $0x0,%ecx
  80109f:	b8 10 00 00 00       	mov    $0x10,%eax
  8010a4:	8b 55 08             	mov    0x8(%ebp),%edx
  8010a7:	89 cb                	mov    %ecx,%ebx
  8010a9:	89 cf                	mov    %ecx,%edi
  8010ab:	89 ce                	mov    %ecx,%esi
  8010ad:	cd 30                	int    $0x30
}

int sys_receive_packet(void* buffer)
{
	return (int)syscall(SYS_receive_packet, 0, (uint32_t)buffer, 0,0,0,0);
}
  8010af:	8b 1c 24             	mov    (%esp),%ebx
  8010b2:	8b 74 24 04          	mov    0x4(%esp),%esi
  8010b6:	8b 7c 24 08          	mov    0x8(%esp),%edi
  8010ba:	89 ec                	mov    %ebp,%esp
  8010bc:	5d                   	pop    %ebp
  8010bd:	c3                   	ret    

008010be <sys_transmit_packet>:
{
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0,0);
}

int sys_transmit_packet(void* data, uint32_t len)
{
  8010be:	55                   	push   %ebp
  8010bf:	89 e5                	mov    %esp,%ebp
  8010c1:	83 ec 38             	sub    $0x38,%esp
  8010c4:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  8010c7:	89 75 f8             	mov    %esi,-0x8(%ebp)
  8010ca:	89 7d fc             	mov    %edi,-0x4(%ebp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8010cd:	bb 00 00 00 00       	mov    $0x0,%ebx
  8010d2:	b8 0f 00 00 00       	mov    $0xf,%eax
  8010d7:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8010da:	8b 55 08             	mov    0x8(%ebp),%edx
  8010dd:	89 df                	mov    %ebx,%edi
  8010df:	89 de                	mov    %ebx,%esi
  8010e1:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
	
	if(check && ret > 0)
  8010e3:	85 c0                	test   %eax,%eax
  8010e5:	7e 28                	jle    80110f <sys_transmit_packet+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  8010e7:	89 44 24 10          	mov    %eax,0x10(%esp)
  8010eb:	c7 44 24 0c 0f 00 00 	movl   $0xf,0xc(%esp)
  8010f2:	00 
  8010f3:	c7 44 24 08 df 34 80 	movl   $0x8034df,0x8(%esp)
  8010fa:	00 
  8010fb:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  801102:	00 
  801103:	c7 04 24 fc 34 80 00 	movl   $0x8034fc,(%esp)
  80110a:	e8 39 f3 ff ff       	call   800448 <_panic>
}

int sys_transmit_packet(void* data, uint32_t len)
{
	return (int)syscall(SYS_transmit_packet, 1, (uint32_t)data, len, 0,0,0);
}
  80110f:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  801112:	8b 75 f8             	mov    -0x8(%ebp),%esi
  801115:	8b 7d fc             	mov    -0x4(%ebp),%edi
  801118:	89 ec                	mov    %ebp,%esp
  80111a:	5d                   	pop    %ebp
  80111b:	c3                   	ret    

0080111c <sys_time_msec>:
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}

unsigned int
sys_time_msec(void)
{
  80111c:	55                   	push   %ebp
  80111d:	89 e5                	mov    %esp,%ebp
  80111f:	83 ec 0c             	sub    $0xc,%esp
  801122:	89 1c 24             	mov    %ebx,(%esp)
  801125:	89 74 24 04          	mov    %esi,0x4(%esp)
  801129:	89 7c 24 08          	mov    %edi,0x8(%esp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80112d:	ba 00 00 00 00       	mov    $0x0,%edx
  801132:	b8 0e 00 00 00       	mov    $0xe,%eax
  801137:	89 d1                	mov    %edx,%ecx
  801139:	89 d3                	mov    %edx,%ebx
  80113b:	89 d7                	mov    %edx,%edi
  80113d:	89 d6                	mov    %edx,%esi
  80113f:	cd 30                	int    $0x30

unsigned int
sys_time_msec(void)
{
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0,0);
}
  801141:	8b 1c 24             	mov    (%esp),%ebx
  801144:	8b 74 24 04          	mov    0x4(%esp),%esi
  801148:	8b 7c 24 08          	mov    0x8(%esp),%edi
  80114c:	89 ec                	mov    %ebp,%esp
  80114e:	5d                   	pop    %ebp
  80114f:	c3                   	ret    

00801150 <sys_ipc_recv>:
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}

int
sys_ipc_recv(void *dstva)
{
  801150:	55                   	push   %ebp
  801151:	89 e5                	mov    %esp,%ebp
  801153:	83 ec 38             	sub    $0x38,%esp
  801156:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  801159:	89 75 f8             	mov    %esi,-0x8(%ebp)
  80115c:	89 7d fc             	mov    %edi,-0x4(%ebp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80115f:	b9 00 00 00 00       	mov    $0x0,%ecx
  801164:	b8 0d 00 00 00       	mov    $0xd,%eax
  801169:	8b 55 08             	mov    0x8(%ebp),%edx
  80116c:	89 cb                	mov    %ecx,%ebx
  80116e:	89 cf                	mov    %ecx,%edi
  801170:	89 ce                	mov    %ecx,%esi
  801172:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
	
	if(check && ret > 0)
  801174:	85 c0                	test   %eax,%eax
  801176:	7e 28                	jle    8011a0 <sys_ipc_recv+0x50>
		panic("syscall %d returned %d (> 0)", num, ret);
  801178:	89 44 24 10          	mov    %eax,0x10(%esp)
  80117c:	c7 44 24 0c 0d 00 00 	movl   $0xd,0xc(%esp)
  801183:	00 
  801184:	c7 44 24 08 df 34 80 	movl   $0x8034df,0x8(%esp)
  80118b:	00 
  80118c:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  801193:	00 
  801194:	c7 04 24 fc 34 80 00 	movl   $0x8034fc,(%esp)
  80119b:	e8 a8 f2 ff ff       	call   800448 <_panic>

int
sys_ipc_recv(void *dstva)
{
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  8011a0:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  8011a3:	8b 75 f8             	mov    -0x8(%ebp),%esi
  8011a6:	8b 7d fc             	mov    -0x4(%ebp),%edi
  8011a9:	89 ec                	mov    %ebp,%esp
  8011ab:	5d                   	pop    %ebp
  8011ac:	c3                   	ret    

008011ad <sys_ipc_try_send>:
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  8011ad:	55                   	push   %ebp
  8011ae:	89 e5                	mov    %esp,%ebp
  8011b0:	83 ec 0c             	sub    $0xc,%esp
  8011b3:	89 1c 24             	mov    %ebx,(%esp)
  8011b6:	89 74 24 04          	mov    %esi,0x4(%esp)
  8011ba:	89 7c 24 08          	mov    %edi,0x8(%esp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8011be:	be 00 00 00 00       	mov    $0x0,%esi
  8011c3:	b8 0c 00 00 00       	mov    $0xc,%eax
  8011c8:	8b 7d 14             	mov    0x14(%ebp),%edi
  8011cb:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8011ce:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8011d1:	8b 55 08             	mov    0x8(%ebp),%edx
  8011d4:	cd 30                	int    $0x30

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  8011d6:	8b 1c 24             	mov    (%esp),%ebx
  8011d9:	8b 74 24 04          	mov    0x4(%esp),%esi
  8011dd:	8b 7c 24 08          	mov    0x8(%esp),%edi
  8011e1:	89 ec                	mov    %ebp,%esp
  8011e3:	5d                   	pop    %ebp
  8011e4:	c3                   	ret    

008011e5 <sys_env_set_pgfault_upcall>:
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  8011e5:	55                   	push   %ebp
  8011e6:	89 e5                	mov    %esp,%ebp
  8011e8:	83 ec 38             	sub    $0x38,%esp
  8011eb:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  8011ee:	89 75 f8             	mov    %esi,-0x8(%ebp)
  8011f1:	89 7d fc             	mov    %edi,-0x4(%ebp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8011f4:	bb 00 00 00 00       	mov    $0x0,%ebx
  8011f9:	b8 0a 00 00 00       	mov    $0xa,%eax
  8011fe:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801201:	8b 55 08             	mov    0x8(%ebp),%edx
  801204:	89 df                	mov    %ebx,%edi
  801206:	89 de                	mov    %ebx,%esi
  801208:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
	
	if(check && ret > 0)
  80120a:	85 c0                	test   %eax,%eax
  80120c:	7e 28                	jle    801236 <sys_env_set_pgfault_upcall+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  80120e:	89 44 24 10          	mov    %eax,0x10(%esp)
  801212:	c7 44 24 0c 0a 00 00 	movl   $0xa,0xc(%esp)
  801219:	00 
  80121a:	c7 44 24 08 df 34 80 	movl   $0x8034df,0x8(%esp)
  801221:	00 
  801222:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  801229:	00 
  80122a:	c7 04 24 fc 34 80 00 	movl   $0x8034fc,(%esp)
  801231:	e8 12 f2 ff ff       	call   800448 <_panic>

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  801236:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  801239:	8b 75 f8             	mov    -0x8(%ebp),%esi
  80123c:	8b 7d fc             	mov    -0x4(%ebp),%edi
  80123f:	89 ec                	mov    %ebp,%esp
  801241:	5d                   	pop    %ebp
  801242:	c3                   	ret    

00801243 <sys_env_set_trapframe>:
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  801243:	55                   	push   %ebp
  801244:	89 e5                	mov    %esp,%ebp
  801246:	83 ec 38             	sub    $0x38,%esp
  801249:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  80124c:	89 75 f8             	mov    %esi,-0x8(%ebp)
  80124f:	89 7d fc             	mov    %edi,-0x4(%ebp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801252:	bb 00 00 00 00       	mov    $0x0,%ebx
  801257:	b8 09 00 00 00       	mov    $0x9,%eax
  80125c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80125f:	8b 55 08             	mov    0x8(%ebp),%edx
  801262:	89 df                	mov    %ebx,%edi
  801264:	89 de                	mov    %ebx,%esi
  801266:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
	
	if(check && ret > 0)
  801268:	85 c0                	test   %eax,%eax
  80126a:	7e 28                	jle    801294 <sys_env_set_trapframe+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  80126c:	89 44 24 10          	mov    %eax,0x10(%esp)
  801270:	c7 44 24 0c 09 00 00 	movl   $0x9,0xc(%esp)
  801277:	00 
  801278:	c7 44 24 08 df 34 80 	movl   $0x8034df,0x8(%esp)
  80127f:	00 
  801280:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  801287:	00 
  801288:	c7 04 24 fc 34 80 00 	movl   $0x8034fc,(%esp)
  80128f:	e8 b4 f1 ff ff       	call   800448 <_panic>

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  801294:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  801297:	8b 75 f8             	mov    -0x8(%ebp),%esi
  80129a:	8b 7d fc             	mov    -0x4(%ebp),%edi
  80129d:	89 ec                	mov    %ebp,%esp
  80129f:	5d                   	pop    %ebp
  8012a0:	c3                   	ret    

008012a1 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  8012a1:	55                   	push   %ebp
  8012a2:	89 e5                	mov    %esp,%ebp
  8012a4:	83 ec 38             	sub    $0x38,%esp
  8012a7:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  8012aa:	89 75 f8             	mov    %esi,-0x8(%ebp)
  8012ad:	89 7d fc             	mov    %edi,-0x4(%ebp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8012b0:	bb 00 00 00 00       	mov    $0x0,%ebx
  8012b5:	b8 08 00 00 00       	mov    $0x8,%eax
  8012ba:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8012bd:	8b 55 08             	mov    0x8(%ebp),%edx
  8012c0:	89 df                	mov    %ebx,%edi
  8012c2:	89 de                	mov    %ebx,%esi
  8012c4:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
	
	if(check && ret > 0)
  8012c6:	85 c0                	test   %eax,%eax
  8012c8:	7e 28                	jle    8012f2 <sys_env_set_status+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  8012ca:	89 44 24 10          	mov    %eax,0x10(%esp)
  8012ce:	c7 44 24 0c 08 00 00 	movl   $0x8,0xc(%esp)
  8012d5:	00 
  8012d6:	c7 44 24 08 df 34 80 	movl   $0x8034df,0x8(%esp)
  8012dd:	00 
  8012de:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  8012e5:	00 
  8012e6:	c7 04 24 fc 34 80 00 	movl   $0x8034fc,(%esp)
  8012ed:	e8 56 f1 ff ff       	call   800448 <_panic>

int
sys_env_set_status(envid_t envid, int status)
{
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  8012f2:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  8012f5:	8b 75 f8             	mov    -0x8(%ebp),%esi
  8012f8:	8b 7d fc             	mov    -0x4(%ebp),%edi
  8012fb:	89 ec                	mov    %ebp,%esp
  8012fd:	5d                   	pop    %ebp
  8012fe:	c3                   	ret    

008012ff <sys_page_unmap>:
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}

int
sys_page_unmap(envid_t envid, void *va)
{
  8012ff:	55                   	push   %ebp
  801300:	89 e5                	mov    %esp,%ebp
  801302:	83 ec 38             	sub    $0x38,%esp
  801305:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  801308:	89 75 f8             	mov    %esi,-0x8(%ebp)
  80130b:	89 7d fc             	mov    %edi,-0x4(%ebp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80130e:	bb 00 00 00 00       	mov    $0x0,%ebx
  801313:	b8 06 00 00 00       	mov    $0x6,%eax
  801318:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80131b:	8b 55 08             	mov    0x8(%ebp),%edx
  80131e:	89 df                	mov    %ebx,%edi
  801320:	89 de                	mov    %ebx,%esi
  801322:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
	
	if(check && ret > 0)
  801324:	85 c0                	test   %eax,%eax
  801326:	7e 28                	jle    801350 <sys_page_unmap+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  801328:	89 44 24 10          	mov    %eax,0x10(%esp)
  80132c:	c7 44 24 0c 06 00 00 	movl   $0x6,0xc(%esp)
  801333:	00 
  801334:	c7 44 24 08 df 34 80 	movl   $0x8034df,0x8(%esp)
  80133b:	00 
  80133c:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  801343:	00 
  801344:	c7 04 24 fc 34 80 00 	movl   $0x8034fc,(%esp)
  80134b:	e8 f8 f0 ff ff       	call   800448 <_panic>

int
sys_page_unmap(envid_t envid, void *va)
{
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  801350:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  801353:	8b 75 f8             	mov    -0x8(%ebp),%esi
  801356:	8b 7d fc             	mov    -0x4(%ebp),%edi
  801359:	89 ec                	mov    %ebp,%esp
  80135b:	5d                   	pop    %ebp
  80135c:	c3                   	ret    

0080135d <sys_page_map>:
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  80135d:	55                   	push   %ebp
  80135e:	89 e5                	mov    %esp,%ebp
  801360:	83 ec 38             	sub    $0x38,%esp
  801363:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  801366:	89 75 f8             	mov    %esi,-0x8(%ebp)
  801369:	89 7d fc             	mov    %edi,-0x4(%ebp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80136c:	b8 05 00 00 00       	mov    $0x5,%eax
  801371:	8b 75 18             	mov    0x18(%ebp),%esi
  801374:	8b 7d 14             	mov    0x14(%ebp),%edi
  801377:	8b 5d 10             	mov    0x10(%ebp),%ebx
  80137a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80137d:	8b 55 08             	mov    0x8(%ebp),%edx
  801380:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
	
	if(check && ret > 0)
  801382:	85 c0                	test   %eax,%eax
  801384:	7e 28                	jle    8013ae <sys_page_map+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  801386:	89 44 24 10          	mov    %eax,0x10(%esp)
  80138a:	c7 44 24 0c 05 00 00 	movl   $0x5,0xc(%esp)
  801391:	00 
  801392:	c7 44 24 08 df 34 80 	movl   $0x8034df,0x8(%esp)
  801399:	00 
  80139a:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  8013a1:	00 
  8013a2:	c7 04 24 fc 34 80 00 	movl   $0x8034fc,(%esp)
  8013a9:	e8 9a f0 ff ff       	call   800448 <_panic>

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  8013ae:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  8013b1:	8b 75 f8             	mov    -0x8(%ebp),%esi
  8013b4:	8b 7d fc             	mov    -0x4(%ebp),%edi
  8013b7:	89 ec                	mov    %ebp,%esp
  8013b9:	5d                   	pop    %ebp
  8013ba:	c3                   	ret    

008013bb <sys_page_alloc>:
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  8013bb:	55                   	push   %ebp
  8013bc:	89 e5                	mov    %esp,%ebp
  8013be:	83 ec 38             	sub    $0x38,%esp
  8013c1:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  8013c4:	89 75 f8             	mov    %esi,-0x8(%ebp)
  8013c7:	89 7d fc             	mov    %edi,-0x4(%ebp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8013ca:	be 00 00 00 00       	mov    $0x0,%esi
  8013cf:	b8 04 00 00 00       	mov    $0x4,%eax
  8013d4:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8013d7:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8013da:	8b 55 08             	mov    0x8(%ebp),%edx
  8013dd:	89 f7                	mov    %esi,%edi
  8013df:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
	
	if(check && ret > 0)
  8013e1:	85 c0                	test   %eax,%eax
  8013e3:	7e 28                	jle    80140d <sys_page_alloc+0x52>
		panic("syscall %d returned %d (> 0)", num, ret);
  8013e5:	89 44 24 10          	mov    %eax,0x10(%esp)
  8013e9:	c7 44 24 0c 04 00 00 	movl   $0x4,0xc(%esp)
  8013f0:	00 
  8013f1:	c7 44 24 08 df 34 80 	movl   $0x8034df,0x8(%esp)
  8013f8:	00 
  8013f9:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  801400:	00 
  801401:	c7 04 24 fc 34 80 00 	movl   $0x8034fc,(%esp)
  801408:	e8 3b f0 ff ff       	call   800448 <_panic>

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  80140d:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  801410:	8b 75 f8             	mov    -0x8(%ebp),%esi
  801413:	8b 7d fc             	mov    -0x4(%ebp),%edi
  801416:	89 ec                	mov    %ebp,%esp
  801418:	5d                   	pop    %ebp
  801419:	c3                   	ret    

0080141a <sys_yield>:
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}

void
sys_yield(void)
{
  80141a:	55                   	push   %ebp
  80141b:	89 e5                	mov    %esp,%ebp
  80141d:	83 ec 0c             	sub    $0xc,%esp
  801420:	89 1c 24             	mov    %ebx,(%esp)
  801423:	89 74 24 04          	mov    %esi,0x4(%esp)
  801427:	89 7c 24 08          	mov    %edi,0x8(%esp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80142b:	ba 00 00 00 00       	mov    $0x0,%edx
  801430:	b8 0b 00 00 00       	mov    $0xb,%eax
  801435:	89 d1                	mov    %edx,%ecx
  801437:	89 d3                	mov    %edx,%ebx
  801439:	89 d7                	mov    %edx,%edi
  80143b:	89 d6                	mov    %edx,%esi
  80143d:	cd 30                	int    $0x30

void
sys_yield(void)
{
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  80143f:	8b 1c 24             	mov    (%esp),%ebx
  801442:	8b 74 24 04          	mov    0x4(%esp),%esi
  801446:	8b 7c 24 08          	mov    0x8(%esp),%edi
  80144a:	89 ec                	mov    %ebp,%esp
  80144c:	5d                   	pop    %ebp
  80144d:	c3                   	ret    

0080144e <sys_getenvid>:
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}

envid_t
sys_getenvid(void)
{
  80144e:	55                   	push   %ebp
  80144f:	89 e5                	mov    %esp,%ebp
  801451:	83 ec 0c             	sub    $0xc,%esp
  801454:	89 1c 24             	mov    %ebx,(%esp)
  801457:	89 74 24 04          	mov    %esi,0x4(%esp)
  80145b:	89 7c 24 08          	mov    %edi,0x8(%esp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80145f:	ba 00 00 00 00       	mov    $0x0,%edx
  801464:	b8 02 00 00 00       	mov    $0x2,%eax
  801469:	89 d1                	mov    %edx,%ecx
  80146b:	89 d3                	mov    %edx,%ebx
  80146d:	89 d7                	mov    %edx,%edi
  80146f:	89 d6                	mov    %edx,%esi
  801471:	cd 30                	int    $0x30

envid_t
sys_getenvid(void)
{
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  801473:	8b 1c 24             	mov    (%esp),%ebx
  801476:	8b 74 24 04          	mov    0x4(%esp),%esi
  80147a:	8b 7c 24 08          	mov    0x8(%esp),%edi
  80147e:	89 ec                	mov    %ebp,%esp
  801480:	5d                   	pop    %ebp
  801481:	c3                   	ret    

00801482 <sys_env_destroy>:
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}

int
sys_env_destroy(envid_t envid)
{
  801482:	55                   	push   %ebp
  801483:	89 e5                	mov    %esp,%ebp
  801485:	83 ec 38             	sub    $0x38,%esp
  801488:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  80148b:	89 75 f8             	mov    %esi,-0x8(%ebp)
  80148e:	89 7d fc             	mov    %edi,-0x4(%ebp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801491:	b9 00 00 00 00       	mov    $0x0,%ecx
  801496:	b8 03 00 00 00       	mov    $0x3,%eax
  80149b:	8b 55 08             	mov    0x8(%ebp),%edx
  80149e:	89 cb                	mov    %ecx,%ebx
  8014a0:	89 cf                	mov    %ecx,%edi
  8014a2:	89 ce                	mov    %ecx,%esi
  8014a4:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
	
	if(check && ret > 0)
  8014a6:	85 c0                	test   %eax,%eax
  8014a8:	7e 28                	jle    8014d2 <sys_env_destroy+0x50>
		panic("syscall %d returned %d (> 0)", num, ret);
  8014aa:	89 44 24 10          	mov    %eax,0x10(%esp)
  8014ae:	c7 44 24 0c 03 00 00 	movl   $0x3,0xc(%esp)
  8014b5:	00 
  8014b6:	c7 44 24 08 df 34 80 	movl   $0x8034df,0x8(%esp)
  8014bd:	00 
  8014be:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  8014c5:	00 
  8014c6:	c7 04 24 fc 34 80 00 	movl   $0x8034fc,(%esp)
  8014cd:	e8 76 ef ff ff       	call   800448 <_panic>

int
sys_env_destroy(envid_t envid)
{
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  8014d2:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  8014d5:	8b 75 f8             	mov    -0x8(%ebp),%esi
  8014d8:	8b 7d fc             	mov    -0x4(%ebp),%edi
  8014db:	89 ec                	mov    %ebp,%esp
  8014dd:	5d                   	pop    %ebp
  8014de:	c3                   	ret    
	...

008014e0 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  8014e0:	55                   	push   %ebp
  8014e1:	89 e5                	mov    %esp,%ebp
  8014e3:	8b 45 08             	mov    0x8(%ebp),%eax
  8014e6:	05 00 00 00 30       	add    $0x30000000,%eax
  8014eb:	c1 e8 0c             	shr    $0xc,%eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
}
  8014ee:	5d                   	pop    %ebp
  8014ef:	c3                   	ret    

008014f0 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  8014f0:	55                   	push   %ebp
  8014f1:	89 e5                	mov    %esp,%ebp
  8014f3:	83 ec 04             	sub    $0x4,%esp
	return INDEX2DATA(fd2num(fd));
  8014f6:	8b 45 08             	mov    0x8(%ebp),%eax
  8014f9:	89 04 24             	mov    %eax,(%esp)
  8014fc:	e8 df ff ff ff       	call   8014e0 <fd2num>
  801501:	05 20 00 0d 00       	add    $0xd0020,%eax
  801506:	c1 e0 0c             	shl    $0xc,%eax
}
  801509:	c9                   	leave  
  80150a:	c3                   	ret    

0080150b <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  80150b:	55                   	push   %ebp
  80150c:	89 e5                	mov    %esp,%ebp
  80150e:	57                   	push   %edi
  80150f:	56                   	push   %esi
  801510:	53                   	push   %ebx
  801511:	8b 7d 08             	mov    0x8(%ebp),%edi
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((vpd[PDX(fd)] & PTE_P) == 0 || (vpt[VPN(fd)] & PTE_P) == 0) {
  801514:	a1 00 dd 7b ef       	mov    0xef7bdd00,%eax
  801519:	a8 01                	test   $0x1,%al
  80151b:	74 36                	je     801553 <fd_alloc+0x48>
  80151d:	a1 00 00 74 ef       	mov    0xef740000,%eax
  801522:	a8 01                	test   $0x1,%al
  801524:	74 2d                	je     801553 <fd_alloc+0x48>
  801526:	b8 00 10 00 d0       	mov    $0xd0001000,%eax
  80152b:	b9 00 d0 7b ef       	mov    $0xef7bd000,%ecx
  801530:	be 00 00 40 ef       	mov    $0xef400000,%esi
  801535:	89 c3                	mov    %eax,%ebx
  801537:	89 c2                	mov    %eax,%edx
  801539:	c1 ea 16             	shr    $0x16,%edx
  80153c:	8b 14 91             	mov    (%ecx,%edx,4),%edx
  80153f:	f6 c2 01             	test   $0x1,%dl
  801542:	74 14                	je     801558 <fd_alloc+0x4d>
  801544:	89 c2                	mov    %eax,%edx
  801546:	c1 ea 0c             	shr    $0xc,%edx
  801549:	8b 14 96             	mov    (%esi,%edx,4),%edx
  80154c:	f6 c2 01             	test   $0x1,%dl
  80154f:	75 10                	jne    801561 <fd_alloc+0x56>
  801551:	eb 05                	jmp    801558 <fd_alloc+0x4d>
  801553:	bb 00 00 00 d0       	mov    $0xd0000000,%ebx
			*fd_store = fd;
  801558:	89 1f                	mov    %ebx,(%edi)
  80155a:	b8 00 00 00 00       	mov    $0x0,%eax
			return 0;
  80155f:	eb 17                	jmp    801578 <fd_alloc+0x6d>
  801561:	05 00 10 00 00       	add    $0x1000,%eax
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  801566:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  80156b:	75 c8                	jne    801535 <fd_alloc+0x2a>
		if ((vpd[PDX(fd)] & PTE_P) == 0 || (vpt[VPN(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  80156d:	c7 07 00 00 00 00    	movl   $0x0,(%edi)
  801573:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
	return -E_MAX_OPEN;
}
  801578:	5b                   	pop    %ebx
  801579:	5e                   	pop    %esi
  80157a:	5f                   	pop    %edi
  80157b:	5d                   	pop    %ebp
  80157c:	c3                   	ret    

0080157d <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  80157d:	55                   	push   %ebp
  80157e:	89 e5                	mov    %esp,%ebp
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  801580:	8b 45 08             	mov    0x8(%ebp),%eax
  801583:	83 f8 1f             	cmp    $0x1f,%eax
  801586:	77 36                	ja     8015be <fd_lookup+0x41>
		if (debug)
			cprintf("[%08x] bad fd %d\n", env->env_id, fd);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  801588:	05 00 00 0d 00       	add    $0xd0000,%eax
  80158d:	c1 e0 0c             	shl    $0xc,%eax
	if (!(vpd[PDX(fd)] & PTE_P) || !(vpt[VPN(fd)] & PTE_P)) {
  801590:	89 c2                	mov    %eax,%edx
  801592:	c1 ea 16             	shr    $0x16,%edx
  801595:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  80159c:	f6 c2 01             	test   $0x1,%dl
  80159f:	74 1d                	je     8015be <fd_lookup+0x41>
  8015a1:	89 c2                	mov    %eax,%edx
  8015a3:	c1 ea 0c             	shr    $0xc,%edx
  8015a6:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8015ad:	f6 c2 01             	test   $0x1,%dl
  8015b0:	74 0c                	je     8015be <fd_lookup+0x41>
		if (debug)
			cprintf("[%08x] closed fd %d\n", env->env_id, fd);
		return -E_INVAL;
	}
	*fd_store = fd;
  8015b2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8015b5:	89 02                	mov    %eax,(%edx)
  8015b7:	b8 00 00 00 00       	mov    $0x0,%eax
	return 0;
  8015bc:	eb 05                	jmp    8015c3 <fd_lookup+0x46>
  8015be:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  8015c3:	5d                   	pop    %ebp
  8015c4:	c3                   	ret    

008015c5 <seek>:
	return (*dev->dev_write)(fd, buf, n);
}

int
seek(int fdnum, off_t offset)
{
  8015c5:	55                   	push   %ebp
  8015c6:	89 e5                	mov    %esp,%ebp
  8015c8:	83 ec 18             	sub    $0x18,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8015cb:	8d 45 fc             	lea    -0x4(%ebp),%eax
  8015ce:	89 44 24 04          	mov    %eax,0x4(%esp)
  8015d2:	8b 45 08             	mov    0x8(%ebp),%eax
  8015d5:	89 04 24             	mov    %eax,(%esp)
  8015d8:	e8 a0 ff ff ff       	call   80157d <fd_lookup>
  8015dd:	85 c0                	test   %eax,%eax
  8015df:	78 0e                	js     8015ef <seek+0x2a>
		return r;
	fd->fd_offset = offset;
  8015e1:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8015e4:	8b 55 0c             	mov    0xc(%ebp),%edx
  8015e7:	89 50 04             	mov    %edx,0x4(%eax)
  8015ea:	b8 00 00 00 00       	mov    $0x0,%eax
	return 0;
}
  8015ef:	c9                   	leave  
  8015f0:	c3                   	ret    

008015f1 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  8015f1:	55                   	push   %ebp
  8015f2:	89 e5                	mov    %esp,%ebp
  8015f4:	56                   	push   %esi
  8015f5:	53                   	push   %ebx
  8015f6:	83 ec 10             	sub    $0x10,%esp
  8015f9:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8015fc:	8b 5d 0c             	mov    0xc(%ebp),%ebx
// File functions
// --------------------------------------------------------------

static struct Dev *devtab[] =
{
	&devfile,
  8015ff:	b8 90 87 80 00       	mov    $0x808790,%eax
{
	int i;
	for (i = 0; devtab[i]; i++)
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
  801604:	ba 00 00 00 00       	mov    $0x0,%edx

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  801609:	be 88 35 80 00       	mov    $0x803588,%esi
		if (devtab[i]->dev_id == dev_id) {
  80160e:	39 08                	cmp    %ecx,(%eax)
  801610:	75 10                	jne    801622 <dev_lookup+0x31>
  801612:	eb 04                	jmp    801618 <dev_lookup+0x27>
  801614:	39 08                	cmp    %ecx,(%eax)
  801616:	75 0a                	jne    801622 <dev_lookup+0x31>
			*dev = devtab[i];
  801618:	89 03                	mov    %eax,(%ebx)
  80161a:	b8 00 00 00 00       	mov    $0x0,%eax
			return 0;
  80161f:	90                   	nop
  801620:	eb 31                	jmp    801653 <dev_lookup+0x62>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  801622:	83 c2 01             	add    $0x1,%edx
  801625:	8b 04 96             	mov    (%esi,%edx,4),%eax
  801628:	85 c0                	test   %eax,%eax
  80162a:	75 e8                	jne    801614 <dev_lookup+0x23>
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", env->env_id, dev_id);
  80162c:	a1 70 9f 80 00       	mov    0x809f70,%eax
  801631:	8b 40 4c             	mov    0x4c(%eax),%eax
  801634:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801638:	89 44 24 04          	mov    %eax,0x4(%esp)
  80163c:	c7 04 24 0c 35 80 00 	movl   $0x80350c,(%esp)
  801643:	e8 c5 ee ff ff       	call   80050d <cprintf>
	*dev = 0;
  801648:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  80164e:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
	return -E_INVAL;
}
  801653:	83 c4 10             	add    $0x10,%esp
  801656:	5b                   	pop    %ebx
  801657:	5e                   	pop    %esi
  801658:	5d                   	pop    %ebp
  801659:	c3                   	ret    

0080165a <fstat>:
	return (*dev->dev_trunc)(fd, newsize);
}

int
fstat(int fdnum, struct Stat *stat)
{
  80165a:	55                   	push   %ebp
  80165b:	89 e5                	mov    %esp,%ebp
  80165d:	53                   	push   %ebx
  80165e:	83 ec 24             	sub    $0x24,%esp
  801661:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801664:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801667:	89 44 24 04          	mov    %eax,0x4(%esp)
  80166b:	8b 45 08             	mov    0x8(%ebp),%eax
  80166e:	89 04 24             	mov    %eax,(%esp)
  801671:	e8 07 ff ff ff       	call   80157d <fd_lookup>
  801676:	85 c0                	test   %eax,%eax
  801678:	78 53                	js     8016cd <fstat+0x73>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80167a:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80167d:	89 44 24 04          	mov    %eax,0x4(%esp)
  801681:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801684:	8b 00                	mov    (%eax),%eax
  801686:	89 04 24             	mov    %eax,(%esp)
  801689:	e8 63 ff ff ff       	call   8015f1 <dev_lookup>
{
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80168e:	85 c0                	test   %eax,%eax
  801690:	78 3b                	js     8016cd <fstat+0x73>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if (!dev->dev_stat)
  801692:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801697:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80169a:	83 7a 14 00          	cmpl   $0x0,0x14(%edx)
  80169e:	74 2d                	je     8016cd <fstat+0x73>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  8016a0:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  8016a3:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  8016aa:	00 00 00 
	stat->st_isdir = 0;
  8016ad:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  8016b4:	00 00 00 
	stat->st_dev = dev;
  8016b7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8016ba:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  8016c0:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8016c4:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8016c7:	89 14 24             	mov    %edx,(%esp)
  8016ca:	ff 50 14             	call   *0x14(%eax)
}
  8016cd:	83 c4 24             	add    $0x24,%esp
  8016d0:	5b                   	pop    %ebx
  8016d1:	5d                   	pop    %ebp
  8016d2:	c3                   	ret    

008016d3 <ftruncate>:
	return 0;
}

int
ftruncate(int fdnum, off_t newsize)
{
  8016d3:	55                   	push   %ebp
  8016d4:	89 e5                	mov    %esp,%ebp
  8016d6:	53                   	push   %ebx
  8016d7:	83 ec 24             	sub    $0x24,%esp
  8016da:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  8016dd:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8016e0:	89 44 24 04          	mov    %eax,0x4(%esp)
  8016e4:	89 1c 24             	mov    %ebx,(%esp)
  8016e7:	e8 91 fe ff ff       	call   80157d <fd_lookup>
  8016ec:	85 c0                	test   %eax,%eax
  8016ee:	78 5f                	js     80174f <ftruncate+0x7c>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8016f0:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8016f3:	89 44 24 04          	mov    %eax,0x4(%esp)
  8016f7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8016fa:	8b 00                	mov    (%eax),%eax
  8016fc:	89 04 24             	mov    %eax,(%esp)
  8016ff:	e8 ed fe ff ff       	call   8015f1 <dev_lookup>
ftruncate(int fdnum, off_t newsize)
{
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  801704:	85 c0                	test   %eax,%eax
  801706:	78 47                	js     80174f <ftruncate+0x7c>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801708:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80170b:	f6 42 08 03          	testb  $0x3,0x8(%edx)
  80170f:	75 23                	jne    801734 <ftruncate+0x61>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			env->env_id, fdnum); 
  801711:	a1 70 9f 80 00       	mov    0x809f70,%eax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  801716:	8b 40 4c             	mov    0x4c(%eax),%eax
  801719:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80171d:	89 44 24 04          	mov    %eax,0x4(%esp)
  801721:	c7 04 24 2c 35 80 00 	movl   $0x80352c,(%esp)
  801728:	e8 e0 ed ff ff       	call   80050d <cprintf>
  80172d:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
			env->env_id, fdnum); 
		return -E_INVAL;
  801732:	eb 1b                	jmp    80174f <ftruncate+0x7c>
	}
	if (!dev->dev_trunc)
  801734:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801737:	8b 48 18             	mov    0x18(%eax),%ecx
  80173a:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  80173f:	85 c9                	test   %ecx,%ecx
  801741:	74 0c                	je     80174f <ftruncate+0x7c>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  801743:	8b 45 0c             	mov    0xc(%ebp),%eax
  801746:	89 44 24 04          	mov    %eax,0x4(%esp)
  80174a:	89 14 24             	mov    %edx,(%esp)
  80174d:	ff d1                	call   *%ecx
}
  80174f:	83 c4 24             	add    $0x24,%esp
  801752:	5b                   	pop    %ebx
  801753:	5d                   	pop    %ebp
  801754:	c3                   	ret    

00801755 <write>:
	return tot;
}

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  801755:	55                   	push   %ebp
  801756:	89 e5                	mov    %esp,%ebp
  801758:	53                   	push   %ebx
  801759:	83 ec 24             	sub    $0x24,%esp
  80175c:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80175f:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801762:	89 44 24 04          	mov    %eax,0x4(%esp)
  801766:	89 1c 24             	mov    %ebx,(%esp)
  801769:	e8 0f fe ff ff       	call   80157d <fd_lookup>
  80176e:	85 c0                	test   %eax,%eax
  801770:	78 66                	js     8017d8 <write+0x83>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801772:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801775:	89 44 24 04          	mov    %eax,0x4(%esp)
  801779:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80177c:	8b 00                	mov    (%eax),%eax
  80177e:	89 04 24             	mov    %eax,(%esp)
  801781:	e8 6b fe ff ff       	call   8015f1 <dev_lookup>
{
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801786:	85 c0                	test   %eax,%eax
  801788:	78 4e                	js     8017d8 <write+0x83>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  80178a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80178d:	f6 42 08 03          	testb  $0x3,0x8(%edx)
  801791:	75 23                	jne    8017b6 <write+0x61>
		cprintf("[%08x] write %d -- bad mode\n", env->env_id, fdnum);
  801793:	a1 70 9f 80 00       	mov    0x809f70,%eax
  801798:	8b 40 4c             	mov    0x4c(%eax),%eax
  80179b:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80179f:	89 44 24 04          	mov    %eax,0x4(%esp)
  8017a3:	c7 04 24 4d 35 80 00 	movl   $0x80354d,(%esp)
  8017aa:	e8 5e ed ff ff       	call   80050d <cprintf>
  8017af:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
		return -E_INVAL;
  8017b4:	eb 22                	jmp    8017d8 <write+0x83>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  8017b6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8017b9:	8b 48 0c             	mov    0xc(%eax),%ecx
  8017bc:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8017c1:	85 c9                	test   %ecx,%ecx
  8017c3:	74 13                	je     8017d8 <write+0x83>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  8017c5:	8b 45 10             	mov    0x10(%ebp),%eax
  8017c8:	89 44 24 08          	mov    %eax,0x8(%esp)
  8017cc:	8b 45 0c             	mov    0xc(%ebp),%eax
  8017cf:	89 44 24 04          	mov    %eax,0x4(%esp)
  8017d3:	89 14 24             	mov    %edx,(%esp)
  8017d6:	ff d1                	call   *%ecx
}
  8017d8:	83 c4 24             	add    $0x24,%esp
  8017db:	5b                   	pop    %ebx
  8017dc:	5d                   	pop    %ebp
  8017dd:	c3                   	ret    

008017de <read>:
	return r;
}

ssize_t
read(int fdnum, void *buf, size_t n)
{
  8017de:	55                   	push   %ebp
  8017df:	89 e5                	mov    %esp,%ebp
  8017e1:	53                   	push   %ebx
  8017e2:	83 ec 24             	sub    $0x24,%esp
  8017e5:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8017e8:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8017eb:	89 44 24 04          	mov    %eax,0x4(%esp)
  8017ef:	89 1c 24             	mov    %ebx,(%esp)
  8017f2:	e8 86 fd ff ff       	call   80157d <fd_lookup>
  8017f7:	85 c0                	test   %eax,%eax
  8017f9:	78 6b                	js     801866 <read+0x88>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8017fb:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8017fe:	89 44 24 04          	mov    %eax,0x4(%esp)
  801802:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801805:	8b 00                	mov    (%eax),%eax
  801807:	89 04 24             	mov    %eax,(%esp)
  80180a:	e8 e2 fd ff ff       	call   8015f1 <dev_lookup>
{
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80180f:	85 c0                	test   %eax,%eax
  801811:	78 53                	js     801866 <read+0x88>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  801813:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801816:	8b 42 08             	mov    0x8(%edx),%eax
  801819:	83 e0 03             	and    $0x3,%eax
  80181c:	83 f8 01             	cmp    $0x1,%eax
  80181f:	75 23                	jne    801844 <read+0x66>
		cprintf("[%08x] read %d -- bad mode\n", env->env_id, fdnum); 
  801821:	a1 70 9f 80 00       	mov    0x809f70,%eax
  801826:	8b 40 4c             	mov    0x4c(%eax),%eax
  801829:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80182d:	89 44 24 04          	mov    %eax,0x4(%esp)
  801831:	c7 04 24 6a 35 80 00 	movl   $0x80356a,(%esp)
  801838:	e8 d0 ec ff ff       	call   80050d <cprintf>
  80183d:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
		return -E_INVAL;
  801842:	eb 22                	jmp    801866 <read+0x88>
	}
	if (!dev->dev_read)
  801844:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801847:	8b 48 08             	mov    0x8(%eax),%ecx
  80184a:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  80184f:	85 c9                	test   %ecx,%ecx
  801851:	74 13                	je     801866 <read+0x88>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  801853:	8b 45 10             	mov    0x10(%ebp),%eax
  801856:	89 44 24 08          	mov    %eax,0x8(%esp)
  80185a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80185d:	89 44 24 04          	mov    %eax,0x4(%esp)
  801861:	89 14 24             	mov    %edx,(%esp)
  801864:	ff d1                	call   *%ecx
}
  801866:	83 c4 24             	add    $0x24,%esp
  801869:	5b                   	pop    %ebx
  80186a:	5d                   	pop    %ebp
  80186b:	c3                   	ret    

0080186c <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  80186c:	55                   	push   %ebp
  80186d:	89 e5                	mov    %esp,%ebp
  80186f:	57                   	push   %edi
  801870:	56                   	push   %esi
  801871:	53                   	push   %ebx
  801872:	83 ec 1c             	sub    $0x1c,%esp
  801875:	8b 7d 08             	mov    0x8(%ebp),%edi
  801878:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  80187b:	ba 00 00 00 00       	mov    $0x0,%edx
  801880:	bb 00 00 00 00       	mov    $0x0,%ebx
  801885:	b8 00 00 00 00       	mov    $0x0,%eax
  80188a:	85 f6                	test   %esi,%esi
  80188c:	74 29                	je     8018b7 <readn+0x4b>
		m = read(fdnum, (char*)buf + tot, n - tot);
  80188e:	89 f0                	mov    %esi,%eax
  801890:	29 d0                	sub    %edx,%eax
  801892:	89 44 24 08          	mov    %eax,0x8(%esp)
  801896:	03 55 0c             	add    0xc(%ebp),%edx
  801899:	89 54 24 04          	mov    %edx,0x4(%esp)
  80189d:	89 3c 24             	mov    %edi,(%esp)
  8018a0:	e8 39 ff ff ff       	call   8017de <read>
		if (m < 0)
  8018a5:	85 c0                	test   %eax,%eax
  8018a7:	78 0e                	js     8018b7 <readn+0x4b>
			return m;
		if (m == 0)
  8018a9:	85 c0                	test   %eax,%eax
  8018ab:	74 08                	je     8018b5 <readn+0x49>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  8018ad:	01 c3                	add    %eax,%ebx
  8018af:	89 da                	mov    %ebx,%edx
  8018b1:	39 f3                	cmp    %esi,%ebx
  8018b3:	72 d9                	jb     80188e <readn+0x22>
  8018b5:	89 d8                	mov    %ebx,%eax
			return m;
		if (m == 0)
			break;
	}
	return tot;
}
  8018b7:	83 c4 1c             	add    $0x1c,%esp
  8018ba:	5b                   	pop    %ebx
  8018bb:	5e                   	pop    %esi
  8018bc:	5f                   	pop    %edi
  8018bd:	5d                   	pop    %ebp
  8018be:	c3                   	ret    

008018bf <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  8018bf:	55                   	push   %ebp
  8018c0:	89 e5                	mov    %esp,%ebp
  8018c2:	56                   	push   %esi
  8018c3:	53                   	push   %ebx
  8018c4:	83 ec 20             	sub    $0x20,%esp
  8018c7:	8b 75 08             	mov    0x8(%ebp),%esi
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8018ca:	89 34 24             	mov    %esi,(%esp)
  8018cd:	e8 0e fc ff ff       	call   8014e0 <fd2num>
  8018d2:	8d 55 f4             	lea    -0xc(%ebp),%edx
  8018d5:	89 54 24 04          	mov    %edx,0x4(%esp)
  8018d9:	89 04 24             	mov    %eax,(%esp)
  8018dc:	e8 9c fc ff ff       	call   80157d <fd_lookup>
  8018e1:	89 c3                	mov    %eax,%ebx
  8018e3:	85 c0                	test   %eax,%eax
  8018e5:	78 05                	js     8018ec <fd_close+0x2d>
  8018e7:	3b 75 f4             	cmp    -0xc(%ebp),%esi
  8018ea:	74 0c                	je     8018f8 <fd_close+0x39>
	    || fd != fd2)
		return (must_exist ? r : 0);
  8018ec:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8018f0:	19 c0                	sbb    %eax,%eax
  8018f2:	f7 d0                	not    %eax
  8018f4:	21 c3                	and    %eax,%ebx
  8018f6:	eb 3d                	jmp    801935 <fd_close+0x76>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  8018f8:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8018fb:	89 44 24 04          	mov    %eax,0x4(%esp)
  8018ff:	8b 06                	mov    (%esi),%eax
  801901:	89 04 24             	mov    %eax,(%esp)
  801904:	e8 e8 fc ff ff       	call   8015f1 <dev_lookup>
  801909:	89 c3                	mov    %eax,%ebx
  80190b:	85 c0                	test   %eax,%eax
  80190d:	78 16                	js     801925 <fd_close+0x66>
		if (dev->dev_close)
  80190f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801912:	8b 40 10             	mov    0x10(%eax),%eax
  801915:	bb 00 00 00 00       	mov    $0x0,%ebx
  80191a:	85 c0                	test   %eax,%eax
  80191c:	74 07                	je     801925 <fd_close+0x66>
			r = (*dev->dev_close)(fd);
  80191e:	89 34 24             	mov    %esi,(%esp)
  801921:	ff d0                	call   *%eax
  801923:	89 c3                	mov    %eax,%ebx
		else
			r = 0;
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  801925:	89 74 24 04          	mov    %esi,0x4(%esp)
  801929:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801930:	e8 ca f9 ff ff       	call   8012ff <sys_page_unmap>
	return r;
}
  801935:	89 d8                	mov    %ebx,%eax
  801937:	83 c4 20             	add    $0x20,%esp
  80193a:	5b                   	pop    %ebx
  80193b:	5e                   	pop    %esi
  80193c:	5d                   	pop    %ebp
  80193d:	c3                   	ret    

0080193e <close>:
	return -E_INVAL;
}

int
close(int fdnum)
{
  80193e:	55                   	push   %ebp
  80193f:	89 e5                	mov    %esp,%ebp
  801941:	83 ec 28             	sub    $0x28,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801944:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801947:	89 44 24 04          	mov    %eax,0x4(%esp)
  80194b:	8b 45 08             	mov    0x8(%ebp),%eax
  80194e:	89 04 24             	mov    %eax,(%esp)
  801951:	e8 27 fc ff ff       	call   80157d <fd_lookup>
  801956:	85 c0                	test   %eax,%eax
  801958:	78 13                	js     80196d <close+0x2f>
		return r;
	else
		return fd_close(fd, 1);
  80195a:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  801961:	00 
  801962:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801965:	89 04 24             	mov    %eax,(%esp)
  801968:	e8 52 ff ff ff       	call   8018bf <fd_close>
}
  80196d:	c9                   	leave  
  80196e:	c3                   	ret    

0080196f <stat>:
	return (*dev->dev_stat)(fd, stat);
}

int
stat(const char *path, struct Stat *stat)
{
  80196f:	55                   	push   %ebp
  801970:	89 e5                	mov    %esp,%ebp
  801972:	83 ec 18             	sub    $0x18,%esp
  801975:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  801978:	89 75 fc             	mov    %esi,-0x4(%ebp)
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  80197b:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  801982:	00 
  801983:	8b 45 08             	mov    0x8(%ebp),%eax
  801986:	89 04 24             	mov    %eax,(%esp)
  801989:	e8 55 03 00 00       	call   801ce3 <open>
  80198e:	89 c3                	mov    %eax,%ebx
  801990:	85 c0                	test   %eax,%eax
  801992:	78 1b                	js     8019af <stat+0x40>
		return fd;
	r = fstat(fd, stat);
  801994:	8b 45 0c             	mov    0xc(%ebp),%eax
  801997:	89 44 24 04          	mov    %eax,0x4(%esp)
  80199b:	89 1c 24             	mov    %ebx,(%esp)
  80199e:	e8 b7 fc ff ff       	call   80165a <fstat>
  8019a3:	89 c6                	mov    %eax,%esi
	close(fd);
  8019a5:	89 1c 24             	mov    %ebx,(%esp)
  8019a8:	e8 91 ff ff ff       	call   80193e <close>
  8019ad:	89 f3                	mov    %esi,%ebx
	return r;
}
  8019af:	89 d8                	mov    %ebx,%eax
  8019b1:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  8019b4:	8b 75 fc             	mov    -0x4(%ebp),%esi
  8019b7:	89 ec                	mov    %ebp,%esp
  8019b9:	5d                   	pop    %ebp
  8019ba:	c3                   	ret    

008019bb <close_all>:
		return fd_close(fd, 1);
}

void
close_all(void)
{
  8019bb:	55                   	push   %ebp
  8019bc:	89 e5                	mov    %esp,%ebp
  8019be:	53                   	push   %ebx
  8019bf:	83 ec 14             	sub    $0x14,%esp
  8019c2:	bb 00 00 00 00       	mov    $0x0,%ebx
	int i;
	for (i = 0; i < MAXFD; i++)
		close(i);
  8019c7:	89 1c 24             	mov    %ebx,(%esp)
  8019ca:	e8 6f ff ff ff       	call   80193e <close>

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  8019cf:	83 c3 01             	add    $0x1,%ebx
  8019d2:	83 fb 20             	cmp    $0x20,%ebx
  8019d5:	75 f0                	jne    8019c7 <close_all+0xc>
		close(i);
}
  8019d7:	83 c4 14             	add    $0x14,%esp
  8019da:	5b                   	pop    %ebx
  8019db:	5d                   	pop    %ebp
  8019dc:	c3                   	ret    

008019dd <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  8019dd:	55                   	push   %ebp
  8019de:	89 e5                	mov    %esp,%ebp
  8019e0:	83 ec 58             	sub    $0x58,%esp
  8019e3:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  8019e6:	89 75 f8             	mov    %esi,-0x8(%ebp)
  8019e9:	89 7d fc             	mov    %edi,-0x4(%ebp)
  8019ec:	8b 7d 0c             	mov    0xc(%ebp),%edi
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  8019ef:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  8019f2:	89 44 24 04          	mov    %eax,0x4(%esp)
  8019f6:	8b 45 08             	mov    0x8(%ebp),%eax
  8019f9:	89 04 24             	mov    %eax,(%esp)
  8019fc:	e8 7c fb ff ff       	call   80157d <fd_lookup>
  801a01:	89 c3                	mov    %eax,%ebx
  801a03:	85 c0                	test   %eax,%eax
  801a05:	0f 88 e0 00 00 00    	js     801aeb <dup+0x10e>
		return r;
	close(newfdnum);
  801a0b:	89 3c 24             	mov    %edi,(%esp)
  801a0e:	e8 2b ff ff ff       	call   80193e <close>

	newfd = INDEX2FD(newfdnum);
  801a13:	8d b7 00 00 0d 00    	lea    0xd0000(%edi),%esi
  801a19:	c1 e6 0c             	shl    $0xc,%esi
	ova = fd2data(oldfd);
  801a1c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801a1f:	89 04 24             	mov    %eax,(%esp)
  801a22:	e8 c9 fa ff ff       	call   8014f0 <fd2data>
  801a27:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  801a29:	89 34 24             	mov    %esi,(%esp)
  801a2c:	e8 bf fa ff ff       	call   8014f0 <fd2data>
  801a31:	89 45 d4             	mov    %eax,-0x2c(%ebp)

	if ((vpd[PDX(ova)] & PTE_P) && (vpt[VPN(ova)] & PTE_P))
  801a34:	89 da                	mov    %ebx,%edx
  801a36:	89 d8                	mov    %ebx,%eax
  801a38:	c1 e8 16             	shr    $0x16,%eax
  801a3b:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801a42:	a8 01                	test   $0x1,%al
  801a44:	74 43                	je     801a89 <dup+0xac>
  801a46:	c1 ea 0c             	shr    $0xc,%edx
  801a49:	8b 04 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%eax
  801a50:	a8 01                	test   $0x1,%al
  801a52:	74 35                	je     801a89 <dup+0xac>
		if ((r = sys_page_map(0, ova, 0, nva, vpt[VPN(ova)] & PTE_USER)) < 0)
  801a54:	8b 04 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%eax
  801a5b:	25 07 0e 00 00       	and    $0xe07,%eax
  801a60:	89 44 24 10          	mov    %eax,0x10(%esp)
  801a64:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801a67:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801a6b:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801a72:	00 
  801a73:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801a77:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801a7e:	e8 da f8 ff ff       	call   80135d <sys_page_map>
  801a83:	89 c3                	mov    %eax,%ebx
  801a85:	85 c0                	test   %eax,%eax
  801a87:	78 3f                	js     801ac8 <dup+0xeb>
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, vpt[VPN(oldfd)] & PTE_USER)) < 0)
  801a89:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801a8c:	89 c2                	mov    %eax,%edx
  801a8e:	c1 ea 0c             	shr    $0xc,%edx
  801a91:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801a98:	81 e2 07 0e 00 00    	and    $0xe07,%edx
  801a9e:	89 54 24 10          	mov    %edx,0x10(%esp)
  801aa2:	89 74 24 0c          	mov    %esi,0xc(%esp)
  801aa6:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801aad:	00 
  801aae:	89 44 24 04          	mov    %eax,0x4(%esp)
  801ab2:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801ab9:	e8 9f f8 ff ff       	call   80135d <sys_page_map>
  801abe:	89 c3                	mov    %eax,%ebx
  801ac0:	85 c0                	test   %eax,%eax
  801ac2:	78 04                	js     801ac8 <dup+0xeb>
  801ac4:	89 fb                	mov    %edi,%ebx
  801ac6:	eb 23                	jmp    801aeb <dup+0x10e>
		goto err;

	return newfdnum;

err:
	sys_page_unmap(0, newfd);
  801ac8:	89 74 24 04          	mov    %esi,0x4(%esp)
  801acc:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801ad3:	e8 27 f8 ff ff       	call   8012ff <sys_page_unmap>
	sys_page_unmap(0, nva);
  801ad8:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801adb:	89 44 24 04          	mov    %eax,0x4(%esp)
  801adf:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801ae6:	e8 14 f8 ff ff       	call   8012ff <sys_page_unmap>
	return r;
}
  801aeb:	89 d8                	mov    %ebx,%eax
  801aed:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  801af0:	8b 75 f8             	mov    -0x8(%ebp),%esi
  801af3:	8b 7d fc             	mov    -0x4(%ebp),%edi
  801af6:	89 ec                	mov    %ebp,%esp
  801af8:	5d                   	pop    %ebp
  801af9:	c3                   	ret    
	...

00801afc <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  801afc:	55                   	push   %ebp
  801afd:	89 e5                	mov    %esp,%ebp
  801aff:	53                   	push   %ebx
  801b00:	83 ec 14             	sub    $0x14,%esp
  801b03:	89 d3                	mov    %edx,%ebx
	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", env->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(envs[1].env_id, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  801b05:	8b 15 c8 00 c0 ee    	mov    0xeec000c8,%edx
  801b0b:	c7 44 24 0c 07 00 00 	movl   $0x7,0xc(%esp)
  801b12:	00 
  801b13:	c7 44 24 08 00 40 80 	movl   $0x804000,0x8(%esp)
  801b1a:	00 
  801b1b:	89 44 24 04          	mov    %eax,0x4(%esp)
  801b1f:	89 14 24             	mov    %edx,(%esp)
  801b22:	e8 a9 11 00 00       	call   802cd0 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  801b27:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801b2e:	00 
  801b2f:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801b33:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801b3a:	e8 f7 11 00 00       	call   802d36 <ipc_recv>
}
  801b3f:	83 c4 14             	add    $0x14,%esp
  801b42:	5b                   	pop    %ebx
  801b43:	5d                   	pop    %ebp
  801b44:	c3                   	ret    

00801b45 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  801b45:	55                   	push   %ebp
  801b46:	89 e5                	mov    %esp,%ebp
  801b48:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  801b4b:	8b 45 08             	mov    0x8(%ebp),%eax
  801b4e:	8b 40 0c             	mov    0xc(%eax),%eax
  801b51:	a3 00 40 80 00       	mov    %eax,0x804000
	fsipcbuf.set_size.req_size = newsize;
  801b56:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b59:	a3 04 40 80 00       	mov    %eax,0x804004
	return fsipc(FSREQ_SET_SIZE, NULL);
  801b5e:	ba 00 00 00 00       	mov    $0x0,%edx
  801b63:	b8 02 00 00 00       	mov    $0x2,%eax
  801b68:	e8 8f ff ff ff       	call   801afc <fsipc>
}
  801b6d:	c9                   	leave  
  801b6e:	c3                   	ret    

00801b6f <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  801b6f:	55                   	push   %ebp
  801b70:	89 e5                	mov    %esp,%ebp
  801b72:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  801b75:	8b 45 08             	mov    0x8(%ebp),%eax
  801b78:	8b 40 0c             	mov    0xc(%eax),%eax
  801b7b:	a3 00 40 80 00       	mov    %eax,0x804000
	return fsipc(FSREQ_FLUSH, NULL);
  801b80:	ba 00 00 00 00       	mov    $0x0,%edx
  801b85:	b8 06 00 00 00       	mov    $0x6,%eax
  801b8a:	e8 6d ff ff ff       	call   801afc <fsipc>
}
  801b8f:	c9                   	leave  
  801b90:	c3                   	ret    

00801b91 <sync>:
}

// Synchronize disk with buffer cache
int
sync(void)
{
  801b91:	55                   	push   %ebp
  801b92:	89 e5                	mov    %esp,%ebp
  801b94:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  801b97:	ba 00 00 00 00       	mov    $0x0,%edx
  801b9c:	b8 08 00 00 00       	mov    $0x8,%eax
  801ba1:	e8 56 ff ff ff       	call   801afc <fsipc>
}
  801ba6:	c9                   	leave  
  801ba7:	c3                   	ret    

00801ba8 <devfile_stat>:
	return fsipc(FSREQ_WRITE, NULL);	
}

static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  801ba8:	55                   	push   %ebp
  801ba9:	89 e5                	mov    %esp,%ebp
  801bab:	53                   	push   %ebx
  801bac:	83 ec 14             	sub    $0x14,%esp
  801baf:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  801bb2:	8b 45 08             	mov    0x8(%ebp),%eax
  801bb5:	8b 40 0c             	mov    0xc(%eax),%eax
  801bb8:	a3 00 40 80 00       	mov    %eax,0x804000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  801bbd:	ba 00 00 00 00       	mov    $0x0,%edx
  801bc2:	b8 05 00 00 00       	mov    $0x5,%eax
  801bc7:	e8 30 ff ff ff       	call   801afc <fsipc>
  801bcc:	85 c0                	test   %eax,%eax
  801bce:	78 2b                	js     801bfb <devfile_stat+0x53>
		return r;
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  801bd0:	c7 44 24 04 00 40 80 	movl   $0x804000,0x4(%esp)
  801bd7:	00 
  801bd8:	89 1c 24             	mov    %ebx,(%esp)
  801bdb:	e8 ea ef ff ff       	call   800bca <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  801be0:	a1 80 40 80 00       	mov    0x804080,%eax
  801be5:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  801beb:	a1 84 40 80 00       	mov    0x804084,%eax
  801bf0:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
  801bf6:	b8 00 00 00 00       	mov    $0x0,%eax
	return 0;
}
  801bfb:	83 c4 14             	add    $0x14,%esp
  801bfe:	5b                   	pop    %ebx
  801bff:	5d                   	pop    %ebp
  801c00:	c3                   	ret    

00801c01 <devfile_write>:
// Returns:
//	 The number of bytes successfully written.
//	 < 0 on error.
static ssize_t
devfile_write(struct Fd *fd, const void *buf, size_t n)
{
  801c01:	55                   	push   %ebp
  801c02:	89 e5                	mov    %esp,%ebp
  801c04:	83 ec 18             	sub    $0x18,%esp
  801c07:	8b 45 10             	mov    0x10(%ebp),%eax
  801c0a:	3d f8 0f 00 00       	cmp    $0xff8,%eax
  801c0f:	76 05                	jbe    801c16 <devfile_write+0x15>
  801c11:	b8 f8 0f 00 00       	mov    $0xff8,%eax
	// LAB 5: Your code here
	//panic("devfile_write not implemented");
	
	if (n > (PGSIZE - (sizeof(int) + sizeof(size_t))))
		n = PGSIZE - (sizeof(int) + sizeof(size_t));
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  801c16:	8b 55 08             	mov    0x8(%ebp),%edx
  801c19:	8b 52 0c             	mov    0xc(%edx),%edx
  801c1c:	89 15 00 40 80 00    	mov    %edx,0x804000
	fsipcbuf.write.req_n = n;
  801c22:	a3 04 40 80 00       	mov    %eax,0x804004
	memmove (fsipcbuf.write.req_buf, (char*)buf, n);	
  801c27:	89 44 24 08          	mov    %eax,0x8(%esp)
  801c2b:	8b 45 0c             	mov    0xc(%ebp),%eax
  801c2e:	89 44 24 04          	mov    %eax,0x4(%esp)
  801c32:	c7 04 24 08 40 80 00 	movl   $0x804008,(%esp)
  801c39:	e8 47 f1 ff ff       	call   800d85 <memmove>
	return fsipc(FSREQ_WRITE, NULL);	
  801c3e:	ba 00 00 00 00       	mov    $0x0,%edx
  801c43:	b8 04 00 00 00       	mov    $0x4,%eax
  801c48:	e8 af fe ff ff       	call   801afc <fsipc>
}
  801c4d:	c9                   	leave  
  801c4e:	c3                   	ret    

00801c4f <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  801c4f:	55                   	push   %ebp
  801c50:	89 e5                	mov    %esp,%ebp
  801c52:	53                   	push   %ebx
  801c53:	83 ec 14             	sub    $0x14,%esp
	// system server.
	// LAB 5: Your code here
	
	//panic("devfile_read not implemented");
	int r;
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  801c56:	8b 45 08             	mov    0x8(%ebp),%eax
  801c59:	8b 40 0c             	mov    0xc(%eax),%eax
  801c5c:	a3 00 40 80 00       	mov    %eax,0x804000
	fsipcbuf.read.req_n = n;
  801c61:	8b 45 10             	mov    0x10(%ebp),%eax
  801c64:	a3 04 40 80 00       	mov    %eax,0x804004
	if ((r = fsipc(FSREQ_READ, (void*)&fsipcbuf)) < 0)
  801c69:	ba 00 40 80 00       	mov    $0x804000,%edx
  801c6e:	b8 03 00 00 00       	mov    $0x3,%eax
  801c73:	e8 84 fe ff ff       	call   801afc <fsipc>
  801c78:	89 c3                	mov    %eax,%ebx
  801c7a:	85 c0                	test   %eax,%eax
  801c7c:	78 17                	js     801c95 <devfile_read+0x46>
		return r;
	memmove((void*)buf, (void*)fsipcbuf.readRet.ret_buf, r);
  801c7e:	89 44 24 08          	mov    %eax,0x8(%esp)
  801c82:	c7 44 24 04 00 40 80 	movl   $0x804000,0x4(%esp)
  801c89:	00 
  801c8a:	8b 45 0c             	mov    0xc(%ebp),%eax
  801c8d:	89 04 24             	mov    %eax,(%esp)
  801c90:	e8 f0 f0 ff ff       	call   800d85 <memmove>
	return r;
}
  801c95:	89 d8                	mov    %ebx,%eax
  801c97:	83 c4 14             	add    $0x14,%esp
  801c9a:	5b                   	pop    %ebx
  801c9b:	5d                   	pop    %ebp
  801c9c:	c3                   	ret    

00801c9d <remove>:
}

// Delete a file
int
remove(const char *path)
{
  801c9d:	55                   	push   %ebp
  801c9e:	89 e5                	mov    %esp,%ebp
  801ca0:	53                   	push   %ebx
  801ca1:	83 ec 14             	sub    $0x14,%esp
  801ca4:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (strlen(path) >= MAXPATHLEN)
  801ca7:	89 1c 24             	mov    %ebx,(%esp)
  801caa:	e8 d1 ee ff ff       	call   800b80 <strlen>
  801caf:	89 c2                	mov    %eax,%edx
  801cb1:	b8 f4 ff ff ff       	mov    $0xfffffff4,%eax
  801cb6:	81 fa ff 03 00 00    	cmp    $0x3ff,%edx
  801cbc:	7f 1f                	jg     801cdd <remove+0x40>
		return -E_BAD_PATH;
	strcpy(fsipcbuf.remove.req_path, path);
  801cbe:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801cc2:	c7 04 24 00 40 80 00 	movl   $0x804000,(%esp)
  801cc9:	e8 fc ee ff ff       	call   800bca <strcpy>
	return fsipc(FSREQ_REMOVE, NULL);
  801cce:	ba 00 00 00 00       	mov    $0x0,%edx
  801cd3:	b8 07 00 00 00       	mov    $0x7,%eax
  801cd8:	e8 1f fe ff ff       	call   801afc <fsipc>
}
  801cdd:	83 c4 14             	add    $0x14,%esp
  801ce0:	5b                   	pop    %ebx
  801ce1:	5d                   	pop    %ebp
  801ce2:	c3                   	ret    

00801ce3 <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  801ce3:	55                   	push   %ebp
  801ce4:	89 e5                	mov    %esp,%ebp
  801ce6:	83 ec 28             	sub    $0x28,%esp
  801ce9:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  801cec:	89 75 fc             	mov    %esi,-0x4(%ebp)
  801cef:	8b 75 08             	mov    0x8(%ebp),%esi
	// file descriptor.

	// LAB 5: Your code here.
	// Code added by Swastika / Sandeep
	
	if (strlen(path) >= MAXPATHLEN)
  801cf2:	89 34 24             	mov    %esi,(%esp)
  801cf5:	e8 86 ee ff ff       	call   800b80 <strlen>
  801cfa:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  801cff:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  801d04:	7f 5e                	jg     801d64 <open+0x81>
		return -E_BAD_PATH;
	struct Fd * fd;
	int  r;
	if ((r = fd_alloc(&fd)) < 0)
  801d06:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801d09:	89 04 24             	mov    %eax,(%esp)
  801d0c:	e8 fa f7 ff ff       	call   80150b <fd_alloc>
  801d11:	89 c3                	mov    %eax,%ebx
  801d13:	85 c0                	test   %eax,%eax
  801d15:	78 4d                	js     801d64 <open+0x81>
		return r;
	strcpy (fsipcbuf.open.req_path, path);
  801d17:	89 74 24 04          	mov    %esi,0x4(%esp)
  801d1b:	c7 04 24 00 40 80 00 	movl   $0x804000,(%esp)
  801d22:	e8 a3 ee ff ff       	call   800bca <strcpy>
	fsipcbuf.open.req_omode = mode;	
  801d27:	8b 45 0c             	mov    0xc(%ebp),%eax
  801d2a:	a3 00 44 80 00       	mov    %eax,0x804400
	if ((r = fsipc(FSREQ_OPEN,(void*)fd)) < 0)
  801d2f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801d32:	b8 01 00 00 00       	mov    $0x1,%eax
  801d37:	e8 c0 fd ff ff       	call   801afc <fsipc>
  801d3c:	89 c3                	mov    %eax,%ebx
  801d3e:	85 c0                	test   %eax,%eax
  801d40:	79 15                	jns    801d57 <open+0x74>
	{
		fd_close(fd,0);
  801d42:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  801d49:	00 
  801d4a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d4d:	89 04 24             	mov    %eax,(%esp)
  801d50:	e8 6a fb ff ff       	call   8018bf <fd_close>
		return r; 
  801d55:	eb 0d                	jmp    801d64 <open+0x81>
	}
	return fd2num(fd);
  801d57:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d5a:	89 04 24             	mov    %eax,(%esp)
  801d5d:	e8 7e f7 ff ff       	call   8014e0 <fd2num>
  801d62:	89 c3                	mov    %eax,%ebx
	//panic("open not implemented");
}
  801d64:	89 d8                	mov    %ebx,%eax
  801d66:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  801d69:	8b 75 fc             	mov    -0x4(%ebp),%esi
  801d6c:	89 ec                	mov    %ebp,%esp
  801d6e:	5d                   	pop    %ebp
  801d6f:	c3                   	ret    

00801d70 <spawn>:
// argv: pointer to null-terminated array of pointers to strings,
// 	 which will be passed to the child as its command-line arguments.
// Returns child envid on success, < 0 on failure.
int
spawn(const char *prog, const char **argv)
{
  801d70:	55                   	push   %ebp
  801d71:	89 e5                	mov    %esp,%ebp
  801d73:	57                   	push   %edi
  801d74:	56                   	push   %esi
  801d75:	53                   	push   %ebx
  801d76:	81 ec 9c 02 00 00    	sub    $0x29c,%esp
	//   - Call sys_env_set_trapframe(child, &child_tf) to set up the
	//     correct initial eip and esp values in the child.
	//
	//   - Start the child process running with sys_env_set_status().

	if ((r = open(prog, O_RDONLY)) < 0)
  801d7c:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  801d83:	00 
  801d84:	8b 45 08             	mov    0x8(%ebp),%eax
  801d87:	89 04 24             	mov    %eax,(%esp)
  801d8a:	e8 54 ff ff ff       	call   801ce3 <open>
  801d8f:	89 85 84 fd ff ff    	mov    %eax,-0x27c(%ebp)
  801d95:	89 c3                	mov    %eax,%ebx
  801d97:	85 c0                	test   %eax,%eax
  801d99:	0f 88 be 05 00 00    	js     80235d <spawn+0x5ed>
	fd = r;

	// Read elf header
	elf = (struct Elf*) elf_buf;
	if (read(fd, elf_buf, sizeof(elf_buf)) != sizeof(elf_buf)
	    || elf->e_magic != ELF_MAGIC) {
  801d9f:	c7 44 24 08 00 02 00 	movl   $0x200,0x8(%esp)
  801da6:	00 
  801da7:	8d 85 e8 fd ff ff    	lea    -0x218(%ebp),%eax
  801dad:	89 44 24 04          	mov    %eax,0x4(%esp)
  801db1:	89 1c 24             	mov    %ebx,(%esp)
  801db4:	e8 25 fa ff ff       	call   8017de <read>
		return r;
	fd = r;

	// Read elf header
	elf = (struct Elf*) elf_buf;
	if (read(fd, elf_buf, sizeof(elf_buf)) != sizeof(elf_buf)
  801db9:	3d 00 02 00 00       	cmp    $0x200,%eax
  801dbe:	75 0c                	jne    801dcc <spawn+0x5c>
	    || elf->e_magic != ELF_MAGIC) {
  801dc0:	81 bd e8 fd ff ff 7f 	cmpl   $0x464c457f,-0x218(%ebp)
  801dc7:	45 4c 46 
  801dca:	74 36                	je     801e02 <spawn+0x92>
		close(fd);
  801dcc:	8b 85 84 fd ff ff    	mov    -0x27c(%ebp),%eax
  801dd2:	89 04 24             	mov    %eax,(%esp)
  801dd5:	e8 64 fb ff ff       	call   80193e <close>
		cprintf("elf magic %08x want %08x\n", elf->e_magic, ELF_MAGIC);
  801dda:	c7 44 24 08 7f 45 4c 	movl   $0x464c457f,0x8(%esp)
  801de1:	46 
  801de2:	8b 85 e8 fd ff ff    	mov    -0x218(%ebp),%eax
  801de8:	89 44 24 04          	mov    %eax,0x4(%esp)
  801dec:	c7 04 24 9c 35 80 00 	movl   $0x80359c,(%esp)
  801df3:	e8 15 e7 ff ff       	call   80050d <cprintf>
  801df8:	bb f2 ff ff ff       	mov    $0xfffffff2,%ebx
		return -E_NOT_EXEC;
  801dfd:	e9 5b 05 00 00       	jmp    80235d <spawn+0x5ed>
static __inline envid_t sys_exofork(void) __attribute__((always_inline));
static __inline envid_t
sys_exofork(void)
{
	envid_t ret;
	__asm __volatile("int %2"
  801e02:	ba 07 00 00 00       	mov    $0x7,%edx
  801e07:	89 d0                	mov    %edx,%eax
  801e09:	cd 30                	int    $0x30
  801e0b:	89 85 8c fd ff ff    	mov    %eax,-0x274(%ebp)
	}

	// Create new child environment
	if ((r = sys_exofork()) < 0)
  801e11:	85 c0                	test   %eax,%eax
  801e13:	0f 88 3e 05 00 00    	js     802357 <spawn+0x5e7>
		return r;
	child = r;

	// Set up trap frame, including initial stack.
	child_tf = envs[ENVX(child)].env_tf;
  801e19:	89 c6                	mov    %eax,%esi
  801e1b:	81 e6 ff 03 00 00    	and    $0x3ff,%esi
  801e21:	6b f6 7c             	imul   $0x7c,%esi,%esi
  801e24:	8d bd a4 fd ff ff    	lea    -0x25c(%ebp),%edi
  801e2a:	81 c6 00 00 c0 ee    	add    $0xeec00000,%esi
  801e30:	b9 11 00 00 00       	mov    $0x11,%ecx
  801e35:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
	child_tf.tf_eip = elf->e_entry;
  801e37:	8b 85 00 fe ff ff    	mov    -0x200(%ebp),%eax
  801e3d:	89 85 d4 fd ff ff    	mov    %eax,-0x22c(%ebp)
	uintptr_t *argv_store;

	// Count the number of arguments (argc)
	// and the total amount of space needed for strings (string_size).
	string_size = 0;
	for (argc = 0; argv[argc] != 0; argc++)
  801e43:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e46:	8b 02                	mov    (%edx),%eax
  801e48:	bb 00 00 00 00       	mov    $0x0,%ebx
  801e4d:	be 00 00 00 00       	mov    $0x0,%esi
  801e52:	85 c0                	test   %eax,%eax
  801e54:	75 16                	jne    801e6c <spawn+0xfc>
  801e56:	c7 85 7c fd ff ff 00 	movl   $0x0,-0x284(%ebp)
  801e5d:	00 00 00 
  801e60:	c7 85 78 fd ff ff 00 	movl   $0x0,-0x288(%ebp)
  801e67:	00 00 00 
  801e6a:	eb 2c                	jmp    801e98 <spawn+0x128>
  801e6c:	8b 7d 0c             	mov    0xc(%ebp),%edi
		string_size += strlen(argv[argc]) + 1;
  801e6f:	89 04 24             	mov    %eax,(%esp)
  801e72:	e8 09 ed ff ff       	call   800b80 <strlen>
  801e77:	8d 5c 18 01          	lea    0x1(%eax,%ebx,1),%ebx
	uintptr_t *argv_store;

	// Count the number of arguments (argc)
	// and the total amount of space needed for strings (string_size).
	string_size = 0;
	for (argc = 0; argv[argc] != 0; argc++)
  801e7b:	83 c6 01             	add    $0x1,%esi
  801e7e:	8d 14 b5 00 00 00 00 	lea    0x0(,%esi,4),%edx
  801e85:	8b 04 b7             	mov    (%edi,%esi,4),%eax
  801e88:	85 c0                	test   %eax,%eax
  801e8a:	75 e3                	jne    801e6f <spawn+0xff>
  801e8c:	89 95 7c fd ff ff    	mov    %edx,-0x284(%ebp)
  801e92:	89 b5 78 fd ff ff    	mov    %esi,-0x288(%ebp)
	// Determine where to place the strings and the argv array.
	// Set up pointers into the temporary page 'UTEMP'; we'll map a page
	// there later, then remap that page into the child environment
	// at (USTACKTOP - PGSIZE).
	// strings is the topmost thing on the stack.
	string_store = (char*) UTEMP + PGSIZE - string_size;
  801e98:	f7 db                	neg    %ebx
  801e9a:	8d bb 00 10 40 00    	lea    0x401000(%ebx),%edi
	// argv is below that.  There's one argument pointer per argument, plus
	// a null pointer.
	argv_store = (uintptr_t*) (ROUNDDOWN(string_store, 4) - 4 * (argc + 1));
  801ea0:	89 fa                	mov    %edi,%edx
  801ea2:	83 e2 fc             	and    $0xfffffffc,%edx
  801ea5:	89 f0                	mov    %esi,%eax
  801ea7:	f7 d0                	not    %eax
  801ea9:	8d 04 82             	lea    (%edx,%eax,4),%eax
  801eac:	89 85 94 fd ff ff    	mov    %eax,-0x26c(%ebp)
	
	// Make sure that argv, strings, and the 2 words that hold 'argc'
	// and 'argv' themselves will all fit in a single stack page.
	if ((void*) (argv_store - 2) < (void*) UTEMP)
  801eb2:	83 e8 08             	sub    $0x8,%eax
  801eb5:	89 85 80 fd ff ff    	mov    %eax,-0x280(%ebp)
	return child;

error:
	sys_env_destroy(child);
	close(fd);
	return r;
  801ebb:	bb fc ff ff ff       	mov    $0xfffffffc,%ebx
	// a null pointer.
	argv_store = (uintptr_t*) (ROUNDDOWN(string_store, 4) - 4 * (argc + 1));
	
	// Make sure that argv, strings, and the 2 words that hold 'argc'
	// and 'argv' themselves will all fit in a single stack page.
	if ((void*) (argv_store - 2) < (void*) UTEMP)
  801ec0:	3d ff ff 3f 00       	cmp    $0x3fffff,%eax
  801ec5:	0f 86 92 04 00 00    	jbe    80235d <spawn+0x5ed>
		return -E_NO_MEM;

	// Allocate the single stack page at UTEMP.
	if ((r = sys_page_alloc(0, (void*) UTEMP, PTE_P|PTE_U|PTE_W)) < 0)
  801ecb:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  801ed2:	00 
  801ed3:	c7 44 24 04 00 00 40 	movl   $0x400000,0x4(%esp)
  801eda:	00 
  801edb:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801ee2:	e8 d4 f4 ff ff       	call   8013bb <sys_page_alloc>
  801ee7:	89 c3                	mov    %eax,%ebx
  801ee9:	85 c0                	test   %eax,%eax
  801eeb:	0f 88 6c 04 00 00    	js     80235d <spawn+0x5ed>
	//	  (Again, argv should use an address valid in the child's
	//	  environment.)
	//
	//	* Set *init_esp to the initial stack pointer for the child,
	//	  (Again, use an address valid in the child's environment.)
	for (i = 0; i < argc; i++) {
  801ef1:	85 f6                	test   %esi,%esi
  801ef3:	7e 46                	jle    801f3b <spawn+0x1cb>
  801ef5:	bb 00 00 00 00       	mov    $0x0,%ebx
  801efa:	89 b5 88 fd ff ff    	mov    %esi,-0x278(%ebp)
  801f00:	8b 75 0c             	mov    0xc(%ebp),%esi
		argv_store[i] = UTEMP2USTACK(string_store);
  801f03:	8d 87 00 d0 7f ee    	lea    -0x11803000(%edi),%eax
  801f09:	8b 95 94 fd ff ff    	mov    -0x26c(%ebp),%edx
  801f0f:	89 04 9a             	mov    %eax,(%edx,%ebx,4)
		strcpy(string_store, argv[i]);
  801f12:	8b 04 9e             	mov    (%esi,%ebx,4),%eax
  801f15:	89 44 24 04          	mov    %eax,0x4(%esp)
  801f19:	89 3c 24             	mov    %edi,(%esp)
  801f1c:	e8 a9 ec ff ff       	call   800bca <strcpy>
		string_store += strlen(argv[i]) + 1;
  801f21:	8b 04 9e             	mov    (%esi,%ebx,4),%eax
  801f24:	89 04 24             	mov    %eax,(%esp)
  801f27:	e8 54 ec ff ff       	call   800b80 <strlen>
  801f2c:	8d 7c 07 01          	lea    0x1(%edi,%eax,1),%edi
	//	  (Again, argv should use an address valid in the child's
	//	  environment.)
	//
	//	* Set *init_esp to the initial stack pointer for the child,
	//	  (Again, use an address valid in the child's environment.)
	for (i = 0; i < argc; i++) {
  801f30:	83 c3 01             	add    $0x1,%ebx
  801f33:	3b 9d 88 fd ff ff    	cmp    -0x278(%ebp),%ebx
  801f39:	7c c8                	jl     801f03 <spawn+0x193>
		argv_store[i] = UTEMP2USTACK(string_store);
		strcpy(string_store, argv[i]);
		string_store += strlen(argv[i]) + 1;
	}
	argv_store[argc] = 0;
  801f3b:	8b 95 94 fd ff ff    	mov    -0x26c(%ebp),%edx
  801f41:	8b 85 7c fd ff ff    	mov    -0x284(%ebp),%eax
  801f47:	c7 04 02 00 00 00 00 	movl   $0x0,(%edx,%eax,1)
	assert(string_store == (char*)UTEMP + PGSIZE);
  801f4e:	81 ff 00 10 40 00    	cmp    $0x401000,%edi
  801f54:	74 24                	je     801f7a <spawn+0x20a>
  801f56:	c7 44 24 0c 3c 36 80 	movl   $0x80363c,0xc(%esp)
  801f5d:	00 
  801f5e:	c7 44 24 08 b6 35 80 	movl   $0x8035b6,0x8(%esp)
  801f65:	00 
  801f66:	c7 44 24 04 d9 00 00 	movl   $0xd9,0x4(%esp)
  801f6d:	00 
  801f6e:	c7 04 24 cb 35 80 00 	movl   $0x8035cb,(%esp)
  801f75:	e8 ce e4 ff ff       	call   800448 <_panic>

	argv_store[-1] = UTEMP2USTACK(argv_store);
  801f7a:	8b 85 94 fd ff ff    	mov    -0x26c(%ebp),%eax
  801f80:	2d 00 30 80 11       	sub    $0x11803000,%eax
  801f85:	8b 95 94 fd ff ff    	mov    -0x26c(%ebp),%edx
  801f8b:	89 42 fc             	mov    %eax,-0x4(%edx)
	argv_store[-2] = argc;
  801f8e:	8b 95 78 fd ff ff    	mov    -0x288(%ebp),%edx
  801f94:	8b 85 80 fd ff ff    	mov    -0x280(%ebp),%eax
  801f9a:	89 10                	mov    %edx,(%eax)

	*init_esp = UTEMP2USTACK(&argv_store[-2]);
  801f9c:	8b 85 94 fd ff ff    	mov    -0x26c(%ebp),%eax
  801fa2:	2d 08 30 80 11       	sub    $0x11803008,%eax
  801fa7:	89 85 e0 fd ff ff    	mov    %eax,-0x220(%ebp)

	// After completing the stack, map it into the child's address space
	// and unmap it from ours!
	if ((r = sys_page_map(0, UTEMP, child, (void*) (USTACKTOP - PGSIZE), PTE_P | PTE_U | PTE_W)) < 0)
  801fad:	c7 44 24 10 07 00 00 	movl   $0x7,0x10(%esp)
  801fb4:	00 
  801fb5:	c7 44 24 0c 00 d0 bf 	movl   $0xeebfd000,0xc(%esp)
  801fbc:	ee 
  801fbd:	8b 85 8c fd ff ff    	mov    -0x274(%ebp),%eax
  801fc3:	89 44 24 08          	mov    %eax,0x8(%esp)
  801fc7:	c7 44 24 04 00 00 40 	movl   $0x400000,0x4(%esp)
  801fce:	00 
  801fcf:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801fd6:	e8 82 f3 ff ff       	call   80135d <sys_page_map>
  801fdb:	89 c3                	mov    %eax,%ebx
  801fdd:	85 c0                	test   %eax,%eax
  801fdf:	78 1a                	js     801ffb <spawn+0x28b>
		goto error;
	if ((r = sys_page_unmap(0, UTEMP)) < 0)
  801fe1:	c7 44 24 04 00 00 40 	movl   $0x400000,0x4(%esp)
  801fe8:	00 
  801fe9:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801ff0:	e8 0a f3 ff ff       	call   8012ff <sys_page_unmap>
  801ff5:	89 c3                	mov    %eax,%ebx
  801ff7:	85 c0                	test   %eax,%eax
  801ff9:	79 19                	jns    802014 <spawn+0x2a4>
		goto error;

	return 0;

error:
	sys_page_unmap(0, UTEMP);
  801ffb:	c7 44 24 04 00 00 40 	movl   $0x400000,0x4(%esp)
  802002:	00 
  802003:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80200a:	e8 f0 f2 ff ff       	call   8012ff <sys_page_unmap>
  80200f:	e9 49 03 00 00       	jmp    80235d <spawn+0x5ed>

	if ((r = init_stack(child, argv, &child_tf.tf_esp)) < 0)
		return r;

	// Set up program segments as defined in ELF header.
	ph = (struct Proghdr*) (elf_buf + elf->e_phoff);
  802014:	8b 85 04 fe ff ff    	mov    -0x1fc(%ebp),%eax
	for (i = 0; i < elf->e_phnum; i++, ph++) {
  80201a:	66 83 bd 14 fe ff ff 	cmpw   $0x0,-0x1ec(%ebp)
  802021:	00 
  802022:	0f 84 e3 01 00 00    	je     80220b <spawn+0x49b>

	if ((r = init_stack(child, argv, &child_tf.tf_esp)) < 0)
		return r;

	// Set up program segments as defined in ELF header.
	ph = (struct Proghdr*) (elf_buf + elf->e_phoff);
  802028:	8d 84 05 e8 fd ff ff 	lea    -0x218(%ebp,%eax,1),%eax
  80202f:	89 85 80 fd ff ff    	mov    %eax,-0x280(%ebp)
  802035:	c7 85 7c fd ff ff 00 	movl   $0x0,-0x284(%ebp)
  80203c:	00 00 00 
	for (i = 0; i < elf->e_phnum; i++, ph++) {
		if (ph->p_type != ELF_PROG_LOAD)
  80203f:	8b 95 80 fd ff ff    	mov    -0x280(%ebp),%edx
  802045:	83 3a 01             	cmpl   $0x1,(%edx)
  802048:	0f 85 9b 01 00 00    	jne    8021e9 <spawn+0x479>
			continue;
		perm = PTE_P | PTE_U;
		if (ph->p_flags & ELF_PROG_FLAG_WRITE)
  80204e:	8b 42 18             	mov    0x18(%edx),%eax
  802051:	83 e0 02             	and    $0x2,%eax
  802054:	83 f8 01             	cmp    $0x1,%eax
  802057:	19 c0                	sbb    %eax,%eax
  802059:	83 e0 fe             	and    $0xfffffffe,%eax
  80205c:	83 c0 07             	add    $0x7,%eax
  80205f:	89 85 94 fd ff ff    	mov    %eax,-0x26c(%ebp)
			perm |= PTE_W;
		if ((r = map_segment(child, ph->p_va, ph->p_memsz, 
  802065:	8b 52 04             	mov    0x4(%edx),%edx
  802068:	89 95 78 fd ff ff    	mov    %edx,-0x288(%ebp)
  80206e:	8b 85 80 fd ff ff    	mov    -0x280(%ebp),%eax
  802074:	8b 58 10             	mov    0x10(%eax),%ebx
  802077:	8b 50 14             	mov    0x14(%eax),%edx
  80207a:	89 95 88 fd ff ff    	mov    %edx,-0x278(%ebp)
  802080:	8b 40 08             	mov    0x8(%eax),%eax
  802083:	89 85 90 fd ff ff    	mov    %eax,-0x270(%ebp)
	int i, r;
	void *blk;

	//cprintf("map_segment %x+%x\n", va, memsz);

	if ((i = PGOFF(va))) {
  802089:	25 ff 0f 00 00       	and    $0xfff,%eax
  80208e:	74 16                	je     8020a6 <spawn+0x336>
		va -= i;
  802090:	29 85 90 fd ff ff    	sub    %eax,-0x270(%ebp)
		memsz += i;
  802096:	01 c2                	add    %eax,%edx
  802098:	89 95 88 fd ff ff    	mov    %edx,-0x278(%ebp)
		filesz += i;
  80209e:	01 c3                	add    %eax,%ebx
		fileoffset -= i;
  8020a0:	29 85 78 fd ff ff    	sub    %eax,-0x288(%ebp)
	}

	for (i = 0; i < memsz; i += PGSIZE) {
  8020a6:	83 bd 88 fd ff ff 00 	cmpl   $0x0,-0x278(%ebp)
  8020ad:	0f 84 36 01 00 00    	je     8021e9 <spawn+0x479>
  8020b3:	bf 00 00 00 00       	mov    $0x0,%edi
  8020b8:	be 00 00 00 00       	mov    $0x0,%esi
		if (i >= filesz) {
  8020bd:	39 fb                	cmp    %edi,%ebx
  8020bf:	77 31                	ja     8020f2 <spawn+0x382>
			// allocate a blank page
			if ((r = sys_page_alloc(child, (void*) (va + i), perm)) < 0)
  8020c1:	8b 95 94 fd ff ff    	mov    -0x26c(%ebp),%edx
  8020c7:	89 54 24 08          	mov    %edx,0x8(%esp)
  8020cb:	03 bd 90 fd ff ff    	add    -0x270(%ebp),%edi
  8020d1:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8020d5:	8b 85 8c fd ff ff    	mov    -0x274(%ebp),%eax
  8020db:	89 04 24             	mov    %eax,(%esp)
  8020de:	e8 d8 f2 ff ff       	call   8013bb <sys_page_alloc>
  8020e3:	85 c0                	test   %eax,%eax
  8020e5:	0f 89 ea 00 00 00    	jns    8021d5 <spawn+0x465>
  8020eb:	89 c3                	mov    %eax,%ebx
  8020ed:	e9 47 02 00 00       	jmp    802339 <spawn+0x5c9>
				return r;
		} else {
			// from file
			if ((r = sys_page_alloc(0, UTEMP, PTE_P|PTE_U|PTE_W)) < 0)
  8020f2:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  8020f9:	00 
  8020fa:	c7 44 24 04 00 00 40 	movl   $0x400000,0x4(%esp)
  802101:	00 
  802102:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802109:	e8 ad f2 ff ff       	call   8013bb <sys_page_alloc>
  80210e:	85 c0                	test   %eax,%eax
  802110:	0f 88 19 02 00 00    	js     80232f <spawn+0x5bf>
				return r;
			if ((r = seek(fd, fileoffset + i)) < 0)
  802116:	8b 95 78 fd ff ff    	mov    -0x288(%ebp),%edx
  80211c:	8d 04 16             	lea    (%esi,%edx,1),%eax
  80211f:	89 44 24 04          	mov    %eax,0x4(%esp)
  802123:	8b 85 84 fd ff ff    	mov    -0x27c(%ebp),%eax
  802129:	89 04 24             	mov    %eax,(%esp)
  80212c:	e8 94 f4 ff ff       	call   8015c5 <seek>
  802131:	85 c0                	test   %eax,%eax
  802133:	0f 88 fa 01 00 00    	js     802333 <spawn+0x5c3>
				return r;
			if ((r = read(fd, UTEMP, MIN(PGSIZE, filesz-i))) < 0)
  802139:	89 d8                	mov    %ebx,%eax
  80213b:	29 f8                	sub    %edi,%eax
  80213d:	3d 00 10 00 00       	cmp    $0x1000,%eax
  802142:	76 05                	jbe    802149 <spawn+0x3d9>
  802144:	b8 00 10 00 00       	mov    $0x1000,%eax
  802149:	89 44 24 08          	mov    %eax,0x8(%esp)
  80214d:	c7 44 24 04 00 00 40 	movl   $0x400000,0x4(%esp)
  802154:	00 
  802155:	8b 95 84 fd ff ff    	mov    -0x27c(%ebp),%edx
  80215b:	89 14 24             	mov    %edx,(%esp)
  80215e:	e8 7b f6 ff ff       	call   8017de <read>
  802163:	85 c0                	test   %eax,%eax
  802165:	0f 88 cc 01 00 00    	js     802337 <spawn+0x5c7>
				return r;
			if ((r = sys_page_map(0, UTEMP, child, (void*) (va + i), perm)) < 0)
  80216b:	8b 85 94 fd ff ff    	mov    -0x26c(%ebp),%eax
  802171:	89 44 24 10          	mov    %eax,0x10(%esp)
  802175:	03 bd 90 fd ff ff    	add    -0x270(%ebp),%edi
  80217b:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  80217f:	8b 95 8c fd ff ff    	mov    -0x274(%ebp),%edx
  802185:	89 54 24 08          	mov    %edx,0x8(%esp)
  802189:	c7 44 24 04 00 00 40 	movl   $0x400000,0x4(%esp)
  802190:	00 
  802191:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802198:	e8 c0 f1 ff ff       	call   80135d <sys_page_map>
  80219d:	85 c0                	test   %eax,%eax
  80219f:	79 20                	jns    8021c1 <spawn+0x451>
				panic("spawn: sys_page_map data: %e", r);
  8021a1:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8021a5:	c7 44 24 08 d7 35 80 	movl   $0x8035d7,0x8(%esp)
  8021ac:	00 
  8021ad:	c7 44 24 04 0c 01 00 	movl   $0x10c,0x4(%esp)
  8021b4:	00 
  8021b5:	c7 04 24 cb 35 80 00 	movl   $0x8035cb,(%esp)
  8021bc:	e8 87 e2 ff ff       	call   800448 <_panic>
			sys_page_unmap(0, UTEMP);
  8021c1:	c7 44 24 04 00 00 40 	movl   $0x400000,0x4(%esp)
  8021c8:	00 
  8021c9:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8021d0:	e8 2a f1 ff ff       	call   8012ff <sys_page_unmap>
		memsz += i;
		filesz += i;
		fileoffset -= i;
	}

	for (i = 0; i < memsz; i += PGSIZE) {
  8021d5:	81 c6 00 10 00 00    	add    $0x1000,%esi
  8021db:	89 f7                	mov    %esi,%edi
  8021dd:	39 b5 88 fd ff ff    	cmp    %esi,-0x278(%ebp)
  8021e3:	0f 87 d4 fe ff ff    	ja     8020bd <spawn+0x34d>
	if ((r = init_stack(child, argv, &child_tf.tf_esp)) < 0)
		return r;

	// Set up program segments as defined in ELF header.
	ph = (struct Proghdr*) (elf_buf + elf->e_phoff);
	for (i = 0; i < elf->e_phnum; i++, ph++) {
  8021e9:	83 85 7c fd ff ff 01 	addl   $0x1,-0x284(%ebp)
  8021f0:	0f b7 85 14 fe ff ff 	movzwl -0x1ec(%ebp),%eax
  8021f7:	3b 85 7c fd ff ff    	cmp    -0x284(%ebp),%eax
  8021fd:	7e 0c                	jle    80220b <spawn+0x49b>
  8021ff:	83 85 80 fd ff ff 20 	addl   $0x20,-0x280(%ebp)
  802206:	e9 34 fe ff ff       	jmp    80203f <spawn+0x2cf>
			perm |= PTE_W;
		if ((r = map_segment(child, ph->p_va, ph->p_memsz, 
				     fd, ph->p_filesz, ph->p_offset, perm)) < 0)
			goto error;
	}
	close(fd);
  80220b:	8b 85 84 fd ff ff    	mov    -0x27c(%ebp),%eax
  802211:	89 04 24             	mov    %eax,(%esp)
  802214:	e8 25 f7 ff ff       	call   80193e <close>
  802219:	c7 85 94 fd ff ff 00 	movl   $0x0,-0x26c(%ebp)
  802220:	00 00 00 
	void * va;
	int r;
	
	for (pde_x = VPD(0); pde_x < VPD(UTOP); pde_x++)
	{
		if ((vpd[pde_x] & PTE_P) == PTE_P)
  802223:	8b 95 94 fd ff ff    	mov    -0x26c(%ebp),%edx
  802229:	8b 04 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%eax
  802230:	a8 01                	test   $0x1,%al
  802232:	74 65                	je     802299 <spawn+0x529>
		{
			for (pte_x = 0; pte_x < NPTENTRIES; pte_x++)
			{
				vpn = (pde_x << (PDXSHIFT - PTXSHIFT)) + pte_x;
  802234:	89 d7                	mov    %edx,%edi
  802236:	c1 e7 0a             	shl    $0xa,%edi
  802239:	89 d6                	mov    %edx,%esi
  80223b:	c1 e6 16             	shl    $0x16,%esi
  80223e:	bb 00 00 00 00       	mov    $0x0,%ebx
  802243:	8d 04 3b             	lea    (%ebx,%edi,1),%eax
				pte = vpt[vpn];
  802246:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
				if ((pte & PTE_P) && (pte & PTE_SHARE))
  80224d:	89 c2                	mov    %eax,%edx
  80224f:	81 e2 01 04 00 00    	and    $0x401,%edx
  802255:	81 fa 01 04 00 00    	cmp    $0x401,%edx
  80225b:	75 2b                	jne    802288 <spawn+0x518>
				{
					va = (void*)(vpn * PGSIZE);
					r = sys_page_map(0, va, child, va, pte & PTE_USER);
  80225d:	25 07 0e 00 00       	and    $0xe07,%eax
  802262:	89 44 24 10          	mov    %eax,0x10(%esp)
  802266:	89 74 24 0c          	mov    %esi,0xc(%esp)
  80226a:	8b 85 8c fd ff ff    	mov    -0x274(%ebp),%eax
  802270:	89 44 24 08          	mov    %eax,0x8(%esp)
  802274:	89 74 24 04          	mov    %esi,0x4(%esp)
  802278:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80227f:	e8 d9 f0 ff ff       	call   80135d <sys_page_map>
					if (r < 0)
  802284:	85 c0                	test   %eax,%eax
  802286:	78 2d                	js     8022b5 <spawn+0x545>
	
	for (pde_x = VPD(0); pde_x < VPD(UTOP); pde_x++)
	{
		if ((vpd[pde_x] & PTE_P) == PTE_P)
		{
			for (pte_x = 0; pte_x < NPTENTRIES; pte_x++)
  802288:	83 c3 01             	add    $0x1,%ebx
  80228b:	81 c6 00 10 00 00    	add    $0x1000,%esi
  802291:	81 fb 00 04 00 00    	cmp    $0x400,%ebx
  802297:	75 aa                	jne    802243 <spawn+0x4d3>
	uint32_t pde_x, pte_x, vpn;
	pte_t pte;
	void * va;
	int r;
	
	for (pde_x = VPD(0); pde_x < VPD(UTOP); pde_x++)
  802299:	83 85 94 fd ff ff 01 	addl   $0x1,-0x26c(%ebp)
  8022a0:	81 bd 94 fd ff ff bb 	cmpl   $0x3bb,-0x26c(%ebp)
  8022a7:	03 00 00 
  8022aa:	0f 85 73 ff ff ff    	jne    802223 <spawn+0x4b3>
  8022b0:	e9 b5 00 00 00       	jmp    80236a <spawn+0x5fa>
	close(fd);
	fd = -1;

	// Copy shared library state.
	if ((r = copy_shared_pages(child)) < 0)
		panic("copy_shared_pages: %e", r);
  8022b5:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8022b9:	c7 44 24 08 f4 35 80 	movl   $0x8035f4,0x8(%esp)
  8022c0:	00 
  8022c1:	c7 44 24 04 82 00 00 	movl   $0x82,0x4(%esp)
  8022c8:	00 
  8022c9:	c7 04 24 cb 35 80 00 	movl   $0x8035cb,(%esp)
  8022d0:	e8 73 e1 ff ff       	call   800448 <_panic>

	if ((r = sys_env_set_trapframe(child, &child_tf)) < 0)
		panic("sys_env_set_trapframe: %e", r);
  8022d5:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8022d9:	c7 44 24 08 0a 36 80 	movl   $0x80360a,0x8(%esp)
  8022e0:	00 
  8022e1:	c7 44 24 04 85 00 00 	movl   $0x85,0x4(%esp)
  8022e8:	00 
  8022e9:	c7 04 24 cb 35 80 00 	movl   $0x8035cb,(%esp)
  8022f0:	e8 53 e1 ff ff       	call   800448 <_panic>

	if ((r = sys_env_set_status(child, ENV_RUNNABLE)) < 0)
  8022f5:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  8022fc:	00 
  8022fd:	8b 95 8c fd ff ff    	mov    -0x274(%ebp),%edx
  802303:	89 14 24             	mov    %edx,(%esp)
  802306:	e8 96 ef ff ff       	call   8012a1 <sys_env_set_status>
  80230b:	85 c0                	test   %eax,%eax
  80230d:	79 48                	jns    802357 <spawn+0x5e7>
		panic("sys_env_set_status: %e", r);
  80230f:	89 44 24 0c          	mov    %eax,0xc(%esp)
  802313:	c7 44 24 08 24 36 80 	movl   $0x803624,0x8(%esp)
  80231a:	00 
  80231b:	c7 44 24 04 88 00 00 	movl   $0x88,0x4(%esp)
  802322:	00 
  802323:	c7 04 24 cb 35 80 00 	movl   $0x8035cb,(%esp)
  80232a:	e8 19 e1 ff ff       	call   800448 <_panic>
  80232f:	89 c3                	mov    %eax,%ebx
  802331:	eb 06                	jmp    802339 <spawn+0x5c9>
  802333:	89 c3                	mov    %eax,%ebx
  802335:	eb 02                	jmp    802339 <spawn+0x5c9>
  802337:	89 c3                	mov    %eax,%ebx

	return child;

error:
	sys_env_destroy(child);
  802339:	8b 85 8c fd ff ff    	mov    -0x274(%ebp),%eax
  80233f:	89 04 24             	mov    %eax,(%esp)
  802342:	e8 3b f1 ff ff       	call   801482 <sys_env_destroy>
	close(fd);
  802347:	8b 95 84 fd ff ff    	mov    -0x27c(%ebp),%edx
  80234d:	89 14 24             	mov    %edx,(%esp)
  802350:	e8 e9 f5 ff ff       	call   80193e <close>
	return r;
  802355:	eb 06                	jmp    80235d <spawn+0x5ed>
  802357:	8b 9d 8c fd ff ff    	mov    -0x274(%ebp),%ebx
}
  80235d:	89 d8                	mov    %ebx,%eax
  80235f:	81 c4 9c 02 00 00    	add    $0x29c,%esp
  802365:	5b                   	pop    %ebx
  802366:	5e                   	pop    %esi
  802367:	5f                   	pop    %edi
  802368:	5d                   	pop    %ebp
  802369:	c3                   	ret    

	// Copy shared library state.
	if ((r = copy_shared_pages(child)) < 0)
		panic("copy_shared_pages: %e", r);

	if ((r = sys_env_set_trapframe(child, &child_tf)) < 0)
  80236a:	8d 85 a4 fd ff ff    	lea    -0x25c(%ebp),%eax
  802370:	89 44 24 04          	mov    %eax,0x4(%esp)
  802374:	8b 85 8c fd ff ff    	mov    -0x274(%ebp),%eax
  80237a:	89 04 24             	mov    %eax,(%esp)
  80237d:	e8 c1 ee ff ff       	call   801243 <sys_env_set_trapframe>
  802382:	85 c0                	test   %eax,%eax
  802384:	0f 89 6b ff ff ff    	jns    8022f5 <spawn+0x585>
  80238a:	e9 46 ff ff ff       	jmp    8022d5 <spawn+0x565>

0080238f <spawnl>:
}

// Spawn, taking command-line arguments array directly on the stack.
int
spawnl(const char *prog, const char *arg0, ...)
{
  80238f:	55                   	push   %ebp
  802390:	89 e5                	mov    %esp,%ebp
  802392:	83 ec 18             	sub    $0x18,%esp
	return spawn(prog, &arg0);
  802395:	8d 45 0c             	lea    0xc(%ebp),%eax
  802398:	89 44 24 04          	mov    %eax,0x4(%esp)
  80239c:	8b 45 08             	mov    0x8(%ebp),%eax
  80239f:	89 04 24             	mov    %eax,(%esp)
  8023a2:	e8 c9 f9 ff ff       	call   801d70 <spawn>
}
  8023a7:	c9                   	leave  
  8023a8:	c3                   	ret    
  8023a9:	00 00                	add    %al,(%eax)
  8023ab:	00 00                	add    %al,(%eax)
  8023ad:	00 00                	add    %al,(%eax)
	...

008023b0 <devsock_stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  8023b0:	55                   	push   %ebp
  8023b1:	89 e5                	mov    %esp,%ebp
  8023b3:	83 ec 18             	sub    $0x18,%esp
	strcpy(stat->st_name, "<sock>");
  8023b6:	c7 44 24 04 62 36 80 	movl   $0x803662,0x4(%esp)
  8023bd:	00 
  8023be:	8b 45 0c             	mov    0xc(%ebp),%eax
  8023c1:	89 04 24             	mov    %eax,(%esp)
  8023c4:	e8 01 e8 ff ff       	call   800bca <strcpy>
	return 0;
}
  8023c9:	b8 00 00 00 00       	mov    $0x0,%eax
  8023ce:	c9                   	leave  
  8023cf:	c3                   	ret    

008023d0 <devsock_close>:
	return nsipc_shutdown(r, how);
}

static int
devsock_close(struct Fd *fd)
{
  8023d0:	55                   	push   %ebp
  8023d1:	89 e5                	mov    %esp,%ebp
  8023d3:	83 ec 18             	sub    $0x18,%esp
	return nsipc_close(fd->fd_sock.sockid);
  8023d6:	8b 45 08             	mov    0x8(%ebp),%eax
  8023d9:	8b 40 0c             	mov    0xc(%eax),%eax
  8023dc:	89 04 24             	mov    %eax,(%esp)
  8023df:	e8 9e 02 00 00       	call   802682 <nsipc_close>
}
  8023e4:	c9                   	leave  
  8023e5:	c3                   	ret    

008023e6 <devsock_write>:
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
}

static ssize_t
devsock_write(struct Fd *fd, const void *buf, size_t n)
{
  8023e6:	55                   	push   %ebp
  8023e7:	89 e5                	mov    %esp,%ebp
  8023e9:	83 ec 18             	sub    $0x18,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  8023ec:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  8023f3:	00 
  8023f4:	8b 45 10             	mov    0x10(%ebp),%eax
  8023f7:	89 44 24 08          	mov    %eax,0x8(%esp)
  8023fb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8023fe:	89 44 24 04          	mov    %eax,0x4(%esp)
  802402:	8b 45 08             	mov    0x8(%ebp),%eax
  802405:	8b 40 0c             	mov    0xc(%eax),%eax
  802408:	89 04 24             	mov    %eax,(%esp)
  80240b:	e8 ae 02 00 00       	call   8026be <nsipc_send>
}
  802410:	c9                   	leave  
  802411:	c3                   	ret    

00802412 <devsock_read>:
	return nsipc_listen(r, backlog);
}

static ssize_t
devsock_read(struct Fd *fd, void *buf, size_t n)
{
  802412:	55                   	push   %ebp
  802413:	89 e5                	mov    %esp,%ebp
  802415:	83 ec 18             	sub    $0x18,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  802418:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  80241f:	00 
  802420:	8b 45 10             	mov    0x10(%ebp),%eax
  802423:	89 44 24 08          	mov    %eax,0x8(%esp)
  802427:	8b 45 0c             	mov    0xc(%ebp),%eax
  80242a:	89 44 24 04          	mov    %eax,0x4(%esp)
  80242e:	8b 45 08             	mov    0x8(%ebp),%eax
  802431:	8b 40 0c             	mov    0xc(%eax),%eax
  802434:	89 04 24             	mov    %eax,(%esp)
  802437:	e8 f5 02 00 00       	call   802731 <nsipc_recv>
}
  80243c:	c9                   	leave  
  80243d:	c3                   	ret    

0080243e <alloc_sockfd>:
	return sfd->fd_sock.sockid;
}

static int
alloc_sockfd(int sockid)
{
  80243e:	55                   	push   %ebp
  80243f:	89 e5                	mov    %esp,%ebp
  802441:	56                   	push   %esi
  802442:	53                   	push   %ebx
  802443:	83 ec 20             	sub    $0x20,%esp
  802446:	89 c6                	mov    %eax,%esi
	struct Fd *sfd;
	int r;

	if ((r = fd_alloc(&sfd)) < 0
  802448:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80244b:	89 04 24             	mov    %eax,(%esp)
  80244e:	e8 b8 f0 ff ff       	call   80150b <fd_alloc>
  802453:	89 c3                	mov    %eax,%ebx
  802455:	85 c0                	test   %eax,%eax
  802457:	78 21                	js     80247a <alloc_sockfd+0x3c>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U)) < 0) {
  802459:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  802460:	00 
  802461:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802464:	89 44 24 04          	mov    %eax,0x4(%esp)
  802468:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80246f:	e8 47 ef ff ff       	call   8013bb <sys_page_alloc>
  802474:	89 c3                	mov    %eax,%ebx
alloc_sockfd(int sockid)
{
	struct Fd *sfd;
	int r;

	if ((r = fd_alloc(&sfd)) < 0
  802476:	85 c0                	test   %eax,%eax
  802478:	79 0a                	jns    802484 <alloc_sockfd+0x46>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U)) < 0) {
		nsipc_close(sockid);
  80247a:	89 34 24             	mov    %esi,(%esp)
  80247d:	e8 00 02 00 00       	call   802682 <nsipc_close>
		return r;
  802482:	eb 28                	jmp    8024ac <alloc_sockfd+0x6e>
	}

	sfd->fd_dev_id = devsock.dev_id;
  802484:	8b 15 ac 87 80 00    	mov    0x8087ac,%edx
  80248a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80248d:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  80248f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802492:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	sfd->fd_sock.sockid = sockid;
  802499:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80249c:	89 70 0c             	mov    %esi,0xc(%eax)
	return fd2num(sfd);
  80249f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024a2:	89 04 24             	mov    %eax,(%esp)
  8024a5:	e8 36 f0 ff ff       	call   8014e0 <fd2num>
  8024aa:	89 c3                	mov    %eax,%ebx
}
  8024ac:	89 d8                	mov    %ebx,%eax
  8024ae:	83 c4 20             	add    $0x20,%esp
  8024b1:	5b                   	pop    %ebx
  8024b2:	5e                   	pop    %esi
  8024b3:	5d                   	pop    %ebp
  8024b4:	c3                   	ret    

008024b5 <socket>:
	return 0;
}

int
socket(int domain, int type, int protocol)
{
  8024b5:	55                   	push   %ebp
  8024b6:	89 e5                	mov    %esp,%ebp
  8024b8:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  8024bb:	8b 45 10             	mov    0x10(%ebp),%eax
  8024be:	89 44 24 08          	mov    %eax,0x8(%esp)
  8024c2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8024c5:	89 44 24 04          	mov    %eax,0x4(%esp)
  8024c9:	8b 45 08             	mov    0x8(%ebp),%eax
  8024cc:	89 04 24             	mov    %eax,(%esp)
  8024cf:	e8 62 01 00 00       	call   802636 <nsipc_socket>
  8024d4:	85 c0                	test   %eax,%eax
  8024d6:	78 05                	js     8024dd <socket+0x28>
		return r;
	return alloc_sockfd(r);
  8024d8:	e8 61 ff ff ff       	call   80243e <alloc_sockfd>
}
  8024dd:	c9                   	leave  
  8024de:	66 90                	xchg   %ax,%ax
  8024e0:	c3                   	ret    

008024e1 <fd2sockid>:
	.dev_stat =	devsock_stat,
};

static int
fd2sockid(int fd)
{
  8024e1:	55                   	push   %ebp
  8024e2:	89 e5                	mov    %esp,%ebp
  8024e4:	83 ec 28             	sub    $0x28,%esp
	struct Fd *sfd;
	int r;

	if ((r = fd_lookup(fd, &sfd)) < 0)
  8024e7:	8d 55 f4             	lea    -0xc(%ebp),%edx
  8024ea:	89 54 24 04          	mov    %edx,0x4(%esp)
  8024ee:	89 04 24             	mov    %eax,(%esp)
  8024f1:	e8 87 f0 ff ff       	call   80157d <fd_lookup>
  8024f6:	85 c0                	test   %eax,%eax
  8024f8:	78 15                	js     80250f <fd2sockid+0x2e>
		return r;
	if (sfd->fd_dev_id != devsock.dev_id)
  8024fa:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8024fd:	8b 0a                	mov    (%edx),%ecx
  8024ff:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  802504:	3b 0d ac 87 80 00    	cmp    0x8087ac,%ecx
  80250a:	75 03                	jne    80250f <fd2sockid+0x2e>
		return -E_NOT_SUPP;
	return sfd->fd_sock.sockid;
  80250c:	8b 42 0c             	mov    0xc(%edx),%eax
}
  80250f:	c9                   	leave  
  802510:	c3                   	ret    

00802511 <listen>:
	return nsipc_connect(r, name, namelen);
}

int
listen(int s, int backlog)
{
  802511:	55                   	push   %ebp
  802512:	89 e5                	mov    %esp,%ebp
  802514:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  802517:	8b 45 08             	mov    0x8(%ebp),%eax
  80251a:	e8 c2 ff ff ff       	call   8024e1 <fd2sockid>
  80251f:	85 c0                	test   %eax,%eax
  802521:	78 0f                	js     802532 <listen+0x21>
		return r;
	return nsipc_listen(r, backlog);
  802523:	8b 55 0c             	mov    0xc(%ebp),%edx
  802526:	89 54 24 04          	mov    %edx,0x4(%esp)
  80252a:	89 04 24             	mov    %eax,(%esp)
  80252d:	e8 2e 01 00 00       	call   802660 <nsipc_listen>
}
  802532:	c9                   	leave  
  802533:	c3                   	ret    

00802534 <connect>:
	return nsipc_close(fd->fd_sock.sockid);
}

int
connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  802534:	55                   	push   %ebp
  802535:	89 e5                	mov    %esp,%ebp
  802537:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  80253a:	8b 45 08             	mov    0x8(%ebp),%eax
  80253d:	e8 9f ff ff ff       	call   8024e1 <fd2sockid>
  802542:	85 c0                	test   %eax,%eax
  802544:	78 16                	js     80255c <connect+0x28>
		return r;
	return nsipc_connect(r, name, namelen);
  802546:	8b 55 10             	mov    0x10(%ebp),%edx
  802549:	89 54 24 08          	mov    %edx,0x8(%esp)
  80254d:	8b 55 0c             	mov    0xc(%ebp),%edx
  802550:	89 54 24 04          	mov    %edx,0x4(%esp)
  802554:	89 04 24             	mov    %eax,(%esp)
  802557:	e8 55 02 00 00       	call   8027b1 <nsipc_connect>
}
  80255c:	c9                   	leave  
  80255d:	c3                   	ret    

0080255e <shutdown>:
	return nsipc_bind(r, name, namelen);
}

int
shutdown(int s, int how)
{
  80255e:	55                   	push   %ebp
  80255f:	89 e5                	mov    %esp,%ebp
  802561:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  802564:	8b 45 08             	mov    0x8(%ebp),%eax
  802567:	e8 75 ff ff ff       	call   8024e1 <fd2sockid>
  80256c:	85 c0                	test   %eax,%eax
  80256e:	78 0f                	js     80257f <shutdown+0x21>
		return r;
	return nsipc_shutdown(r, how);
  802570:	8b 55 0c             	mov    0xc(%ebp),%edx
  802573:	89 54 24 04          	mov    %edx,0x4(%esp)
  802577:	89 04 24             	mov    %eax,(%esp)
  80257a:	e8 1d 01 00 00       	call   80269c <nsipc_shutdown>
}
  80257f:	c9                   	leave  
  802580:	c3                   	ret    

00802581 <bind>:
	return alloc_sockfd(r);
}

int
bind(int s, struct sockaddr *name, socklen_t namelen)
{
  802581:	55                   	push   %ebp
  802582:	89 e5                	mov    %esp,%ebp
  802584:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  802587:	8b 45 08             	mov    0x8(%ebp),%eax
  80258a:	e8 52 ff ff ff       	call   8024e1 <fd2sockid>
  80258f:	85 c0                	test   %eax,%eax
  802591:	78 16                	js     8025a9 <bind+0x28>
		return r;
	return nsipc_bind(r, name, namelen);
  802593:	8b 55 10             	mov    0x10(%ebp),%edx
  802596:	89 54 24 08          	mov    %edx,0x8(%esp)
  80259a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80259d:	89 54 24 04          	mov    %edx,0x4(%esp)
  8025a1:	89 04 24             	mov    %eax,(%esp)
  8025a4:	e8 47 02 00 00       	call   8027f0 <nsipc_bind>
}
  8025a9:	c9                   	leave  
  8025aa:	c3                   	ret    

008025ab <accept>:
	return fd2num(sfd);
}

int
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  8025ab:	55                   	push   %ebp
  8025ac:	89 e5                	mov    %esp,%ebp
  8025ae:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  8025b1:	8b 45 08             	mov    0x8(%ebp),%eax
  8025b4:	e8 28 ff ff ff       	call   8024e1 <fd2sockid>
  8025b9:	85 c0                	test   %eax,%eax
  8025bb:	78 1f                	js     8025dc <accept+0x31>
		return r;
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  8025bd:	8b 55 10             	mov    0x10(%ebp),%edx
  8025c0:	89 54 24 08          	mov    %edx,0x8(%esp)
  8025c4:	8b 55 0c             	mov    0xc(%ebp),%edx
  8025c7:	89 54 24 04          	mov    %edx,0x4(%esp)
  8025cb:	89 04 24             	mov    %eax,(%esp)
  8025ce:	e8 5c 02 00 00       	call   80282f <nsipc_accept>
  8025d3:	85 c0                	test   %eax,%eax
  8025d5:	78 05                	js     8025dc <accept+0x31>
		return r;
	return alloc_sockfd(r);
  8025d7:	e8 62 fe ff ff       	call   80243e <alloc_sockfd>
}
  8025dc:	c9                   	leave  
  8025dd:	8d 76 00             	lea    0x0(%esi),%esi
  8025e0:	c3                   	ret    
	...

008025f0 <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  8025f0:	55                   	push   %ebp
  8025f1:	89 e5                	mov    %esp,%ebp
  8025f3:	83 ec 18             	sub    $0x18,%esp
	if (debug)
		cprintf("[%08x] nsipc %d\n", env->env_id, type);

	ipc_send(envs[2].env_id, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  8025f6:	8b 15 44 01 c0 ee    	mov    0xeec00144,%edx
  8025fc:	c7 44 24 0c 07 00 00 	movl   $0x7,0xc(%esp)
  802603:	00 
  802604:	c7 44 24 08 00 60 80 	movl   $0x806000,0x8(%esp)
  80260b:	00 
  80260c:	89 44 24 04          	mov    %eax,0x4(%esp)
  802610:	89 14 24             	mov    %edx,(%esp)
  802613:	e8 b8 06 00 00       	call   802cd0 <ipc_send>
	return ipc_recv(NULL, NULL, NULL);
  802618:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  80261f:	00 
  802620:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  802627:	00 
  802628:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80262f:	e8 02 07 00 00       	call   802d36 <ipc_recv>
}
  802634:	c9                   	leave  
  802635:	c3                   	ret    

00802636 <nsipc_socket>:
	return nsipc(NSREQ_SEND);
}

int
nsipc_socket(int domain, int type, int protocol)
{
  802636:	55                   	push   %ebp
  802637:	89 e5                	mov    %esp,%ebp
  802639:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  80263c:	8b 45 08             	mov    0x8(%ebp),%eax
  80263f:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.socket.req_type = type;
  802644:	8b 45 0c             	mov    0xc(%ebp),%eax
  802647:	a3 04 60 80 00       	mov    %eax,0x806004
	nsipcbuf.socket.req_protocol = protocol;
  80264c:	8b 45 10             	mov    0x10(%ebp),%eax
  80264f:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SOCKET);
  802654:	b8 09 00 00 00       	mov    $0x9,%eax
  802659:	e8 92 ff ff ff       	call   8025f0 <nsipc>
}
  80265e:	c9                   	leave  
  80265f:	c3                   	ret    

00802660 <nsipc_listen>:
	return nsipc(NSREQ_CONNECT);
}

int
nsipc_listen(int s, int backlog)
{
  802660:	55                   	push   %ebp
  802661:	89 e5                	mov    %esp,%ebp
  802663:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  802666:	8b 45 08             	mov    0x8(%ebp),%eax
  802669:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.listen.req_backlog = backlog;
  80266e:	8b 45 0c             	mov    0xc(%ebp),%eax
  802671:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_LISTEN);
  802676:	b8 06 00 00 00       	mov    $0x6,%eax
  80267b:	e8 70 ff ff ff       	call   8025f0 <nsipc>
}
  802680:	c9                   	leave  
  802681:	c3                   	ret    

00802682 <nsipc_close>:
	return nsipc(NSREQ_SHUTDOWN);
}

int
nsipc_close(int s)
{
  802682:	55                   	push   %ebp
  802683:	89 e5                	mov    %esp,%ebp
  802685:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  802688:	8b 45 08             	mov    0x8(%ebp),%eax
  80268b:	a3 00 60 80 00       	mov    %eax,0x806000
	return nsipc(NSREQ_CLOSE);
  802690:	b8 04 00 00 00       	mov    $0x4,%eax
  802695:	e8 56 ff ff ff       	call   8025f0 <nsipc>
}
  80269a:	c9                   	leave  
  80269b:	c3                   	ret    

0080269c <nsipc_shutdown>:
	return nsipc(NSREQ_BIND);
}

int
nsipc_shutdown(int s, int how)
{
  80269c:	55                   	push   %ebp
  80269d:	89 e5                	mov    %esp,%ebp
  80269f:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  8026a2:	8b 45 08             	mov    0x8(%ebp),%eax
  8026a5:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.shutdown.req_how = how;
  8026aa:	8b 45 0c             	mov    0xc(%ebp),%eax
  8026ad:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_SHUTDOWN);
  8026b2:	b8 03 00 00 00       	mov    $0x3,%eax
  8026b7:	e8 34 ff ff ff       	call   8025f0 <nsipc>
}
  8026bc:	c9                   	leave  
  8026bd:	c3                   	ret    

008026be <nsipc_send>:
	return r;
}

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  8026be:	55                   	push   %ebp
  8026bf:	89 e5                	mov    %esp,%ebp
  8026c1:	53                   	push   %ebx
  8026c2:	83 ec 14             	sub    $0x14,%esp
  8026c5:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  8026c8:	8b 45 08             	mov    0x8(%ebp),%eax
  8026cb:	a3 00 60 80 00       	mov    %eax,0x806000
	assert(size < 1600);
  8026d0:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  8026d6:	7e 24                	jle    8026fc <nsipc_send+0x3e>
  8026d8:	c7 44 24 0c 6e 36 80 	movl   $0x80366e,0xc(%esp)
  8026df:	00 
  8026e0:	c7 44 24 08 b6 35 80 	movl   $0x8035b6,0x8(%esp)
  8026e7:	00 
  8026e8:	c7 44 24 04 66 00 00 	movl   $0x66,0x4(%esp)
  8026ef:	00 
  8026f0:	c7 04 24 7a 36 80 00 	movl   $0x80367a,(%esp)
  8026f7:	e8 4c dd ff ff       	call   800448 <_panic>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  8026fc:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  802700:	8b 45 0c             	mov    0xc(%ebp),%eax
  802703:	89 44 24 04          	mov    %eax,0x4(%esp)
  802707:	c7 04 24 0c 60 80 00 	movl   $0x80600c,(%esp)
  80270e:	e8 72 e6 ff ff       	call   800d85 <memmove>
	nsipcbuf.send.req_size = size;
  802713:	89 1d 04 60 80 00    	mov    %ebx,0x806004
	nsipcbuf.send.req_flags = flags;
  802719:	8b 45 14             	mov    0x14(%ebp),%eax
  80271c:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SEND);
  802721:	b8 08 00 00 00       	mov    $0x8,%eax
  802726:	e8 c5 fe ff ff       	call   8025f0 <nsipc>
}
  80272b:	83 c4 14             	add    $0x14,%esp
  80272e:	5b                   	pop    %ebx
  80272f:	5d                   	pop    %ebp
  802730:	c3                   	ret    

00802731 <nsipc_recv>:
	return nsipc(NSREQ_LISTEN);
}

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  802731:	55                   	push   %ebp
  802732:	89 e5                	mov    %esp,%ebp
  802734:	56                   	push   %esi
  802735:	53                   	push   %ebx
  802736:	83 ec 10             	sub    $0x10,%esp
  802739:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  80273c:	8b 45 08             	mov    0x8(%ebp),%eax
  80273f:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.recv.req_len = len;
  802744:	89 35 04 60 80 00    	mov    %esi,0x806004
	nsipcbuf.recv.req_flags = flags;
  80274a:	8b 45 14             	mov    0x14(%ebp),%eax
  80274d:	a3 08 60 80 00       	mov    %eax,0x806008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  802752:	b8 07 00 00 00       	mov    $0x7,%eax
  802757:	e8 94 fe ff ff       	call   8025f0 <nsipc>
  80275c:	89 c3                	mov    %eax,%ebx
  80275e:	85 c0                	test   %eax,%eax
  802760:	78 46                	js     8027a8 <nsipc_recv+0x77>
		assert(r < 1600 && r <= len);
  802762:	3d 3f 06 00 00       	cmp    $0x63f,%eax
  802767:	7f 04                	jg     80276d <nsipc_recv+0x3c>
  802769:	39 c6                	cmp    %eax,%esi
  80276b:	7d 24                	jge    802791 <nsipc_recv+0x60>
  80276d:	c7 44 24 0c 86 36 80 	movl   $0x803686,0xc(%esp)
  802774:	00 
  802775:	c7 44 24 08 b6 35 80 	movl   $0x8035b6,0x8(%esp)
  80277c:	00 
  80277d:	c7 44 24 04 5b 00 00 	movl   $0x5b,0x4(%esp)
  802784:	00 
  802785:	c7 04 24 7a 36 80 00 	movl   $0x80367a,(%esp)
  80278c:	e8 b7 dc ff ff       	call   800448 <_panic>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  802791:	89 44 24 08          	mov    %eax,0x8(%esp)
  802795:	c7 44 24 04 00 60 80 	movl   $0x806000,0x4(%esp)
  80279c:	00 
  80279d:	8b 45 0c             	mov    0xc(%ebp),%eax
  8027a0:	89 04 24             	mov    %eax,(%esp)
  8027a3:	e8 dd e5 ff ff       	call   800d85 <memmove>
	}

	return r;
}
  8027a8:	89 d8                	mov    %ebx,%eax
  8027aa:	83 c4 10             	add    $0x10,%esp
  8027ad:	5b                   	pop    %ebx
  8027ae:	5e                   	pop    %esi
  8027af:	5d                   	pop    %ebp
  8027b0:	c3                   	ret    

008027b1 <nsipc_connect>:
	return nsipc(NSREQ_CLOSE);
}

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  8027b1:	55                   	push   %ebp
  8027b2:	89 e5                	mov    %esp,%ebp
  8027b4:	53                   	push   %ebx
  8027b5:	83 ec 14             	sub    $0x14,%esp
  8027b8:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  8027bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8027be:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  8027c3:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8027c7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8027ca:	89 44 24 04          	mov    %eax,0x4(%esp)
  8027ce:	c7 04 24 04 60 80 00 	movl   $0x806004,(%esp)
  8027d5:	e8 ab e5 ff ff       	call   800d85 <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  8027da:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_CONNECT);
  8027e0:	b8 05 00 00 00       	mov    $0x5,%eax
  8027e5:	e8 06 fe ff ff       	call   8025f0 <nsipc>
}
  8027ea:	83 c4 14             	add    $0x14,%esp
  8027ed:	5b                   	pop    %ebx
  8027ee:	5d                   	pop    %ebp
  8027ef:	c3                   	ret    

008027f0 <nsipc_bind>:
	return r;
}

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  8027f0:	55                   	push   %ebp
  8027f1:	89 e5                	mov    %esp,%ebp
  8027f3:	53                   	push   %ebx
  8027f4:	83 ec 14             	sub    $0x14,%esp
  8027f7:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  8027fa:	8b 45 08             	mov    0x8(%ebp),%eax
  8027fd:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  802802:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  802806:	8b 45 0c             	mov    0xc(%ebp),%eax
  802809:	89 44 24 04          	mov    %eax,0x4(%esp)
  80280d:	c7 04 24 04 60 80 00 	movl   $0x806004,(%esp)
  802814:	e8 6c e5 ff ff       	call   800d85 <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  802819:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_BIND);
  80281f:	b8 02 00 00 00       	mov    $0x2,%eax
  802824:	e8 c7 fd ff ff       	call   8025f0 <nsipc>
}
  802829:	83 c4 14             	add    $0x14,%esp
  80282c:	5b                   	pop    %ebx
  80282d:	5d                   	pop    %ebp
  80282e:	c3                   	ret    

0080282f <nsipc_accept>:
	return ipc_recv(NULL, NULL, NULL);
}

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  80282f:	55                   	push   %ebp
  802830:	89 e5                	mov    %esp,%ebp
  802832:	83 ec 18             	sub    $0x18,%esp
  802835:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  802838:	89 75 fc             	mov    %esi,-0x4(%ebp)
	int r;
	
	nsipcbuf.accept.req_s = s;
  80283b:	8b 45 08             	mov    0x8(%ebp),%eax
  80283e:	a3 00 60 80 00       	mov    %eax,0x806000
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  802843:	b8 01 00 00 00       	mov    $0x1,%eax
  802848:	e8 a3 fd ff ff       	call   8025f0 <nsipc>
  80284d:	89 c3                	mov    %eax,%ebx
  80284f:	85 c0                	test   %eax,%eax
  802851:	78 25                	js     802878 <nsipc_accept+0x49>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  802853:	be 10 60 80 00       	mov    $0x806010,%esi
  802858:	8b 06                	mov    (%esi),%eax
  80285a:	89 44 24 08          	mov    %eax,0x8(%esp)
  80285e:	c7 44 24 04 00 60 80 	movl   $0x806000,0x4(%esp)
  802865:	00 
  802866:	8b 45 0c             	mov    0xc(%ebp),%eax
  802869:	89 04 24             	mov    %eax,(%esp)
  80286c:	e8 14 e5 ff ff       	call   800d85 <memmove>
		*addrlen = ret->ret_addrlen;
  802871:	8b 16                	mov    (%esi),%edx
  802873:	8b 45 10             	mov    0x10(%ebp),%eax
  802876:	89 10                	mov    %edx,(%eax)
	}
	return r;
}
  802878:	89 d8                	mov    %ebx,%eax
  80287a:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  80287d:	8b 75 fc             	mov    -0x4(%ebp),%esi
  802880:	89 ec                	mov    %ebp,%esp
  802882:	5d                   	pop    %ebp
  802883:	c3                   	ret    
	...

00802890 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  802890:	55                   	push   %ebp
  802891:	89 e5                	mov    %esp,%ebp
  802893:	83 ec 18             	sub    $0x18,%esp
  802896:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  802899:	89 75 fc             	mov    %esi,-0x4(%ebp)
  80289c:	8b 75 0c             	mov    0xc(%ebp),%esi
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  80289f:	8b 45 08             	mov    0x8(%ebp),%eax
  8028a2:	89 04 24             	mov    %eax,(%esp)
  8028a5:	e8 46 ec ff ff       	call   8014f0 <fd2data>
  8028aa:	89 c3                	mov    %eax,%ebx
	strcpy(stat->st_name, "<pipe>");
  8028ac:	c7 44 24 04 9b 36 80 	movl   $0x80369b,0x4(%esp)
  8028b3:	00 
  8028b4:	89 34 24             	mov    %esi,(%esp)
  8028b7:	e8 0e e3 ff ff       	call   800bca <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  8028bc:	8b 43 04             	mov    0x4(%ebx),%eax
  8028bf:	2b 03                	sub    (%ebx),%eax
  8028c1:	89 86 80 00 00 00    	mov    %eax,0x80(%esi)
	stat->st_isdir = 0;
  8028c7:	c7 86 84 00 00 00 00 	movl   $0x0,0x84(%esi)
  8028ce:	00 00 00 
	stat->st_dev = &devpipe;
  8028d1:	c7 86 88 00 00 00 c8 	movl   $0x8087c8,0x88(%esi)
  8028d8:	87 80 00 
	return 0;
}
  8028db:	b8 00 00 00 00       	mov    $0x0,%eax
  8028e0:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  8028e3:	8b 75 fc             	mov    -0x4(%ebp),%esi
  8028e6:	89 ec                	mov    %ebp,%esp
  8028e8:	5d                   	pop    %ebp
  8028e9:	c3                   	ret    

008028ea <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  8028ea:	55                   	push   %ebp
  8028eb:	89 e5                	mov    %esp,%ebp
  8028ed:	53                   	push   %ebx
  8028ee:	83 ec 14             	sub    $0x14,%esp
  8028f1:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  8028f4:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8028f8:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8028ff:	e8 fb e9 ff ff       	call   8012ff <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  802904:	89 1c 24             	mov    %ebx,(%esp)
  802907:	e8 e4 eb ff ff       	call   8014f0 <fd2data>
  80290c:	89 44 24 04          	mov    %eax,0x4(%esp)
  802910:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802917:	e8 e3 e9 ff ff       	call   8012ff <sys_page_unmap>
}
  80291c:	83 c4 14             	add    $0x14,%esp
  80291f:	5b                   	pop    %ebx
  802920:	5d                   	pop    %ebp
  802921:	c3                   	ret    

00802922 <_pipeisclosed>:
	return r;
}

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  802922:	55                   	push   %ebp
  802923:	89 e5                	mov    %esp,%ebp
  802925:	57                   	push   %edi
  802926:	56                   	push   %esi
  802927:	53                   	push   %ebx
  802928:	83 ec 2c             	sub    $0x2c,%esp
  80292b:	89 c7                	mov    %eax,%edi
  80292d:	89 55 e4             	mov    %edx,-0x1c(%ebp)
	int n, nn, ret;

	while (1) {
		n = env->env_runs;
  802930:	a1 70 9f 80 00       	mov    0x809f70,%eax
  802935:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  802938:	89 3c 24             	mov    %edi,(%esp)
  80293b:	e8 60 04 00 00       	call   802da0 <pageref>
  802940:	89 c6                	mov    %eax,%esi
  802942:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802945:	89 04 24             	mov    %eax,(%esp)
  802948:	e8 53 04 00 00       	call   802da0 <pageref>
  80294d:	39 c6                	cmp    %eax,%esi
  80294f:	0f 94 c0             	sete   %al
  802952:	0f b6 c0             	movzbl %al,%eax
		nn = env->env_runs;
  802955:	8b 15 70 9f 80 00    	mov    0x809f70,%edx
  80295b:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  80295e:	39 cb                	cmp    %ecx,%ebx
  802960:	75 08                	jne    80296a <_pipeisclosed+0x48>
			return ret;
		if (n != nn && ret == 1)
			cprintf("pipe race avoided\n", n, env->env_runs, ret);
	}
}
  802962:	83 c4 2c             	add    $0x2c,%esp
  802965:	5b                   	pop    %ebx
  802966:	5e                   	pop    %esi
  802967:	5f                   	pop    %edi
  802968:	5d                   	pop    %ebp
  802969:	c3                   	ret    
		n = env->env_runs;
		ret = pageref(fd) == pageref(p);
		nn = env->env_runs;
		if (n == nn)
			return ret;
		if (n != nn && ret == 1)
  80296a:	83 f8 01             	cmp    $0x1,%eax
  80296d:	75 c1                	jne    802930 <_pipeisclosed+0xe>
			cprintf("pipe race avoided\n", n, env->env_runs, ret);
  80296f:	8b 52 58             	mov    0x58(%edx),%edx
  802972:	89 44 24 0c          	mov    %eax,0xc(%esp)
  802976:	89 54 24 08          	mov    %edx,0x8(%esp)
  80297a:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  80297e:	c7 04 24 a2 36 80 00 	movl   $0x8036a2,(%esp)
  802985:	e8 83 db ff ff       	call   80050d <cprintf>
  80298a:	eb a4                	jmp    802930 <_pipeisclosed+0xe>

0080298c <devpipe_write>:
	return i;
}

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  80298c:	55                   	push   %ebp
  80298d:	89 e5                	mov    %esp,%ebp
  80298f:	57                   	push   %edi
  802990:	56                   	push   %esi
  802991:	53                   	push   %ebx
  802992:	83 ec 1c             	sub    $0x1c,%esp
  802995:	8b 75 08             	mov    0x8(%ebp),%esi
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  802998:	89 34 24             	mov    %esi,(%esp)
  80299b:	e8 50 eb ff ff       	call   8014f0 <fd2data>
  8029a0:	89 c3                	mov    %eax,%ebx
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			env->env_id, vpt[VPN(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  8029a2:	bf 00 00 00 00       	mov    $0x0,%edi
  8029a7:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8029ab:	75 54                	jne    802a01 <devpipe_write+0x75>
  8029ad:	eb 60                	jmp    802a0f <devpipe_write+0x83>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  8029af:	89 da                	mov    %ebx,%edx
  8029b1:	89 f0                	mov    %esi,%eax
  8029b3:	e8 6a ff ff ff       	call   802922 <_pipeisclosed>
  8029b8:	85 c0                	test   %eax,%eax
  8029ba:	74 07                	je     8029c3 <devpipe_write+0x37>
  8029bc:	b8 00 00 00 00       	mov    $0x0,%eax
  8029c1:	eb 53                	jmp    802a16 <devpipe_write+0x8a>
				return 0;
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  8029c3:	90                   	nop
  8029c4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  8029c8:	e8 4d ea ff ff       	call   80141a <sys_yield>
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			env->env_id, vpt[VPN(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  8029cd:	8b 43 04             	mov    0x4(%ebx),%eax
  8029d0:	8b 13                	mov    (%ebx),%edx
  8029d2:	83 c2 20             	add    $0x20,%edx
  8029d5:	39 d0                	cmp    %edx,%eax
  8029d7:	73 d6                	jae    8029af <devpipe_write+0x23>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  8029d9:	89 c2                	mov    %eax,%edx
  8029db:	c1 fa 1f             	sar    $0x1f,%edx
  8029de:	c1 ea 1b             	shr    $0x1b,%edx
  8029e1:	01 d0                	add    %edx,%eax
  8029e3:	83 e0 1f             	and    $0x1f,%eax
  8029e6:	29 d0                	sub    %edx,%eax
  8029e8:	89 c2                	mov    %eax,%edx
  8029ea:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8029ed:	0f b6 04 39          	movzbl (%ecx,%edi,1),%eax
  8029f1:	88 44 13 08          	mov    %al,0x8(%ebx,%edx,1)
		p->p_wpos++;
  8029f5:	83 43 04 01          	addl   $0x1,0x4(%ebx)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			env->env_id, vpt[VPN(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  8029f9:	83 c7 01             	add    $0x1,%edi
  8029fc:	39 7d 10             	cmp    %edi,0x10(%ebp)
  8029ff:	76 13                	jbe    802a14 <devpipe_write+0x88>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  802a01:	8b 43 04             	mov    0x4(%ebx),%eax
  802a04:	8b 13                	mov    (%ebx),%edx
  802a06:	83 c2 20             	add    $0x20,%edx
  802a09:	39 d0                	cmp    %edx,%eax
  802a0b:	73 a2                	jae    8029af <devpipe_write+0x23>
  802a0d:	eb ca                	jmp    8029d9 <devpipe_write+0x4d>
  802a0f:	bf 00 00 00 00       	mov    $0x0,%edi
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}
	
	return i;
  802a14:	89 f8                	mov    %edi,%eax
}
  802a16:	83 c4 1c             	add    $0x1c,%esp
  802a19:	5b                   	pop    %ebx
  802a1a:	5e                   	pop    %esi
  802a1b:	5f                   	pop    %edi
  802a1c:	5d                   	pop    %ebp
  802a1d:	c3                   	ret    

00802a1e <devpipe_read>:
	return _pipeisclosed(fd, p);
}

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  802a1e:	55                   	push   %ebp
  802a1f:	89 e5                	mov    %esp,%ebp
  802a21:	83 ec 28             	sub    $0x28,%esp
  802a24:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  802a27:	89 75 f8             	mov    %esi,-0x8(%ebp)
  802a2a:	89 7d fc             	mov    %edi,-0x4(%ebp)
  802a2d:	8b 7d 08             	mov    0x8(%ebp),%edi
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  802a30:	89 3c 24             	mov    %edi,(%esp)
  802a33:	e8 b8 ea ff ff       	call   8014f0 <fd2data>
  802a38:	89 c3                	mov    %eax,%ebx
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			env->env_id, vpt[VPN(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  802a3a:	be 00 00 00 00       	mov    $0x0,%esi
  802a3f:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  802a43:	75 4c                	jne    802a91 <devpipe_read+0x73>
  802a45:	eb 5b                	jmp    802aa2 <devpipe_read+0x84>
		while (p->p_rpos == p->p_wpos) {
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
				return i;
  802a47:	89 f0                	mov    %esi,%eax
  802a49:	eb 5e                	jmp    802aa9 <devpipe_read+0x8b>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  802a4b:	89 da                	mov    %ebx,%edx
  802a4d:	89 f8                	mov    %edi,%eax
  802a4f:	90                   	nop
  802a50:	e8 cd fe ff ff       	call   802922 <_pipeisclosed>
  802a55:	85 c0                	test   %eax,%eax
  802a57:	74 07                	je     802a60 <devpipe_read+0x42>
  802a59:	b8 00 00 00 00       	mov    $0x0,%eax
  802a5e:	eb 49                	jmp    802aa9 <devpipe_read+0x8b>
				return 0;
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  802a60:	e8 b5 e9 ff ff       	call   80141a <sys_yield>
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			env->env_id, vpt[VPN(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  802a65:	8b 03                	mov    (%ebx),%eax
  802a67:	3b 43 04             	cmp    0x4(%ebx),%eax
  802a6a:	74 df                	je     802a4b <devpipe_read+0x2d>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  802a6c:	89 c2                	mov    %eax,%edx
  802a6e:	c1 fa 1f             	sar    $0x1f,%edx
  802a71:	c1 ea 1b             	shr    $0x1b,%edx
  802a74:	01 d0                	add    %edx,%eax
  802a76:	83 e0 1f             	and    $0x1f,%eax
  802a79:	29 d0                	sub    %edx,%eax
  802a7b:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  802a80:	8b 55 0c             	mov    0xc(%ebp),%edx
  802a83:	88 04 32             	mov    %al,(%edx,%esi,1)
		p->p_rpos++;
  802a86:	83 03 01             	addl   $0x1,(%ebx)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			env->env_id, vpt[VPN(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  802a89:	83 c6 01             	add    $0x1,%esi
  802a8c:	39 75 10             	cmp    %esi,0x10(%ebp)
  802a8f:	76 16                	jbe    802aa7 <devpipe_read+0x89>
		while (p->p_rpos == p->p_wpos) {
  802a91:	8b 03                	mov    (%ebx),%eax
  802a93:	3b 43 04             	cmp    0x4(%ebx),%eax
  802a96:	75 d4                	jne    802a6c <devpipe_read+0x4e>
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  802a98:	85 f6                	test   %esi,%esi
  802a9a:	75 ab                	jne    802a47 <devpipe_read+0x29>
  802a9c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802aa0:	eb a9                	jmp    802a4b <devpipe_read+0x2d>
  802aa2:	be 00 00 00 00       	mov    $0x0,%esi
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  802aa7:	89 f0                	mov    %esi,%eax
}
  802aa9:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  802aac:	8b 75 f8             	mov    -0x8(%ebp),%esi
  802aaf:	8b 7d fc             	mov    -0x4(%ebp),%edi
  802ab2:	89 ec                	mov    %ebp,%esp
  802ab4:	5d                   	pop    %ebp
  802ab5:	c3                   	ret    

00802ab6 <pipeisclosed>:
	}
}

int
pipeisclosed(int fdnum)
{
  802ab6:	55                   	push   %ebp
  802ab7:	89 e5                	mov    %esp,%ebp
  802ab9:	83 ec 28             	sub    $0x28,%esp
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802abc:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802abf:	89 44 24 04          	mov    %eax,0x4(%esp)
  802ac3:	8b 45 08             	mov    0x8(%ebp),%eax
  802ac6:	89 04 24             	mov    %eax,(%esp)
  802ac9:	e8 af ea ff ff       	call   80157d <fd_lookup>
  802ace:	85 c0                	test   %eax,%eax
  802ad0:	78 15                	js     802ae7 <pipeisclosed+0x31>
		return r;
	p = (struct Pipe*) fd2data(fd);
  802ad2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ad5:	89 04 24             	mov    %eax,(%esp)
  802ad8:	e8 13 ea ff ff       	call   8014f0 <fd2data>
	return _pipeisclosed(fd, p);
  802add:	89 c2                	mov    %eax,%edx
  802adf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ae2:	e8 3b fe ff ff       	call   802922 <_pipeisclosed>
}
  802ae7:	c9                   	leave  
  802ae8:	c3                   	ret    

00802ae9 <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  802ae9:	55                   	push   %ebp
  802aea:	89 e5                	mov    %esp,%ebp
  802aec:	83 ec 48             	sub    $0x48,%esp
  802aef:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  802af2:	89 75 f8             	mov    %esi,-0x8(%ebp)
  802af5:	89 7d fc             	mov    %edi,-0x4(%ebp)
  802af8:	8b 7d 08             	mov    0x8(%ebp),%edi
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  802afb:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  802afe:	89 04 24             	mov    %eax,(%esp)
  802b01:	e8 05 ea ff ff       	call   80150b <fd_alloc>
  802b06:	89 c3                	mov    %eax,%ebx
  802b08:	85 c0                	test   %eax,%eax
  802b0a:	0f 88 42 01 00 00    	js     802c52 <pipe+0x169>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802b10:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  802b17:	00 
  802b18:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802b1b:	89 44 24 04          	mov    %eax,0x4(%esp)
  802b1f:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802b26:	e8 90 e8 ff ff       	call   8013bb <sys_page_alloc>
  802b2b:	89 c3                	mov    %eax,%ebx
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  802b2d:	85 c0                	test   %eax,%eax
  802b2f:	0f 88 1d 01 00 00    	js     802c52 <pipe+0x169>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  802b35:	8d 45 e0             	lea    -0x20(%ebp),%eax
  802b38:	89 04 24             	mov    %eax,(%esp)
  802b3b:	e8 cb e9 ff ff       	call   80150b <fd_alloc>
  802b40:	89 c3                	mov    %eax,%ebx
  802b42:	85 c0                	test   %eax,%eax
  802b44:	0f 88 f5 00 00 00    	js     802c3f <pipe+0x156>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802b4a:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  802b51:	00 
  802b52:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802b55:	89 44 24 04          	mov    %eax,0x4(%esp)
  802b59:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802b60:	e8 56 e8 ff ff       	call   8013bb <sys_page_alloc>
  802b65:	89 c3                	mov    %eax,%ebx
	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  802b67:	85 c0                	test   %eax,%eax
  802b69:	0f 88 d0 00 00 00    	js     802c3f <pipe+0x156>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  802b6f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802b72:	89 04 24             	mov    %eax,(%esp)
  802b75:	e8 76 e9 ff ff       	call   8014f0 <fd2data>
  802b7a:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802b7c:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  802b83:	00 
  802b84:	89 44 24 04          	mov    %eax,0x4(%esp)
  802b88:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802b8f:	e8 27 e8 ff ff       	call   8013bb <sys_page_alloc>
  802b94:	89 c3                	mov    %eax,%ebx
  802b96:	85 c0                	test   %eax,%eax
  802b98:	0f 88 8e 00 00 00    	js     802c2c <pipe+0x143>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802b9e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802ba1:	89 04 24             	mov    %eax,(%esp)
  802ba4:	e8 47 e9 ff ff       	call   8014f0 <fd2data>
  802ba9:	c7 44 24 10 07 04 00 	movl   $0x407,0x10(%esp)
  802bb0:	00 
  802bb1:	89 44 24 0c          	mov    %eax,0xc(%esp)
  802bb5:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  802bbc:	00 
  802bbd:	89 74 24 04          	mov    %esi,0x4(%esp)
  802bc1:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802bc8:	e8 90 e7 ff ff       	call   80135d <sys_page_map>
  802bcd:	89 c3                	mov    %eax,%ebx
  802bcf:	85 c0                	test   %eax,%eax
  802bd1:	78 49                	js     802c1c <pipe+0x133>
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  802bd3:	b8 c8 87 80 00       	mov    $0x8087c8,%eax
  802bd8:	8b 08                	mov    (%eax),%ecx
  802bda:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802bdd:	89 0a                	mov    %ecx,(%edx)
	fd0->fd_omode = O_RDONLY;
  802bdf:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802be2:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%edx)

	fd1->fd_dev_id = devpipe.dev_id;
  802be9:	8b 10                	mov    (%eax),%edx
  802beb:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802bee:	89 10                	mov    %edx,(%eax)
	fd1->fd_omode = O_WRONLY;
  802bf0:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802bf3:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", env->env_id, vpt[VPN(va)]);

	pfd[0] = fd2num(fd0);
  802bfa:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802bfd:	89 04 24             	mov    %eax,(%esp)
  802c00:	e8 db e8 ff ff       	call   8014e0 <fd2num>
  802c05:	89 07                	mov    %eax,(%edi)
	pfd[1] = fd2num(fd1);
  802c07:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802c0a:	89 04 24             	mov    %eax,(%esp)
  802c0d:	e8 ce e8 ff ff       	call   8014e0 <fd2num>
  802c12:	89 47 04             	mov    %eax,0x4(%edi)
  802c15:	bb 00 00 00 00       	mov    $0x0,%ebx
	return 0;
  802c1a:	eb 36                	jmp    802c52 <pipe+0x169>

    err3:
	sys_page_unmap(0, va);
  802c1c:	89 74 24 04          	mov    %esi,0x4(%esp)
  802c20:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802c27:	e8 d3 e6 ff ff       	call   8012ff <sys_page_unmap>
    err2:
	sys_page_unmap(0, fd1);
  802c2c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802c2f:	89 44 24 04          	mov    %eax,0x4(%esp)
  802c33:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802c3a:	e8 c0 e6 ff ff       	call   8012ff <sys_page_unmap>
    err1:
	sys_page_unmap(0, fd0);
  802c3f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802c42:	89 44 24 04          	mov    %eax,0x4(%esp)
  802c46:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802c4d:	e8 ad e6 ff ff       	call   8012ff <sys_page_unmap>
    err:
	return r;
}
  802c52:	89 d8                	mov    %ebx,%eax
  802c54:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  802c57:	8b 75 f8             	mov    -0x8(%ebp),%esi
  802c5a:	8b 7d fc             	mov    -0x4(%ebp),%edi
  802c5d:	89 ec                	mov    %ebp,%esp
  802c5f:	5d                   	pop    %ebp
  802c60:	c3                   	ret    
  802c61:	00 00                	add    %al,(%eax)
	...

00802c64 <wait>:
#include <inc/lib.h>

// Waits until 'envid' exits.
void
wait(envid_t envid)
{
  802c64:	55                   	push   %ebp
  802c65:	89 e5                	mov    %esp,%ebp
  802c67:	56                   	push   %esi
  802c68:	53                   	push   %ebx
  802c69:	83 ec 10             	sub    $0x10,%esp
  802c6c:	8b 45 08             	mov    0x8(%ebp),%eax
	volatile struct Env *e;

	assert(envid != 0);
  802c6f:	85 c0                	test   %eax,%eax
  802c71:	75 24                	jne    802c97 <wait+0x33>
  802c73:	c7 44 24 0c ba 36 80 	movl   $0x8036ba,0xc(%esp)
  802c7a:	00 
  802c7b:	c7 44 24 08 b6 35 80 	movl   $0x8035b6,0x8(%esp)
  802c82:	00 
  802c83:	c7 44 24 04 09 00 00 	movl   $0x9,0x4(%esp)
  802c8a:	00 
  802c8b:	c7 04 24 c5 36 80 00 	movl   $0x8036c5,(%esp)
  802c92:	e8 b1 d7 ff ff       	call   800448 <_panic>
	e = &envs[ENVX(envid)];
  802c97:	89 c3                	mov    %eax,%ebx
  802c99:	81 e3 ff 03 00 00    	and    $0x3ff,%ebx
  802c9f:	6b db 7c             	imul   $0x7c,%ebx,%ebx
  802ca2:	81 c3 00 00 c0 ee    	add    $0xeec00000,%ebx
	while (e->env_id == envid && e->env_status != ENV_FREE)
  802ca8:	8b 73 4c             	mov    0x4c(%ebx),%esi
  802cab:	39 c6                	cmp    %eax,%esi
  802cad:	75 1a                	jne    802cc9 <wait+0x65>
  802caf:	8b 43 54             	mov    0x54(%ebx),%eax
  802cb2:	85 c0                	test   %eax,%eax
  802cb4:	74 13                	je     802cc9 <wait+0x65>
		sys_yield();
  802cb6:	e8 5f e7 ff ff       	call   80141a <sys_yield>
{
	volatile struct Env *e;

	assert(envid != 0);
	e = &envs[ENVX(envid)];
	while (e->env_id == envid && e->env_status != ENV_FREE)
  802cbb:	8b 43 4c             	mov    0x4c(%ebx),%eax
  802cbe:	39 f0                	cmp    %esi,%eax
  802cc0:	75 07                	jne    802cc9 <wait+0x65>
  802cc2:	8b 43 54             	mov    0x54(%ebx),%eax
  802cc5:	85 c0                	test   %eax,%eax
  802cc7:	75 ed                	jne    802cb6 <wait+0x52>
		sys_yield();
}
  802cc9:	83 c4 10             	add    $0x10,%esp
  802ccc:	5b                   	pop    %ebx
  802ccd:	5e                   	pop    %esi
  802cce:	5d                   	pop    %ebp
  802ccf:	c3                   	ret    

00802cd0 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  802cd0:	55                   	push   %ebp
  802cd1:	89 e5                	mov    %esp,%ebp
  802cd3:	57                   	push   %edi
  802cd4:	56                   	push   %esi
  802cd5:	53                   	push   %ebx
  802cd6:	83 ec 1c             	sub    $0x1c,%esp
  802cd9:	8b 7d 0c             	mov    0xc(%ebp),%edi
  802cdc:	8b 5d 10             	mov    0x10(%ebp),%ebx
  802cdf:	8b 75 14             	mov    0x14(%ebp),%esi
	// LAB 4: Your code here.
	int r;
	if (pg == NULL)
  802ce2:	85 db                	test   %ebx,%ebx
  802ce4:	75 2d                	jne    802d13 <ipc_send+0x43>
  802ce6:	bb 00 00 c0 ee       	mov    $0xeec00000,%ebx
  802ceb:	eb 26                	jmp    802d13 <ipc_send+0x43>
		pg = (void*)UTOP;
	while ((r = sys_ipc_try_send(to_env, val, pg, perm)) < 0)
	{
		if(r != -E_IPC_NOT_RECV)
  802ced:	83 f8 f9             	cmp    $0xfffffff9,%eax
  802cf0:	74 1c                	je     802d0e <ipc_send+0x3e>
			panic("Panic in lib ipc.c : ipc_send() \n");
  802cf2:	c7 44 24 08 d0 36 80 	movl   $0x8036d0,0x8(%esp)
  802cf9:	00 
  802cfa:	c7 44 24 04 44 00 00 	movl   $0x44,0x4(%esp)
  802d01:	00 
  802d02:	c7 04 24 f4 36 80 00 	movl   $0x8036f4,(%esp)
  802d09:	e8 3a d7 ff ff       	call   800448 <_panic>
		sys_yield();
  802d0e:	e8 07 e7 ff ff       	call   80141a <sys_yield>
{
	// LAB 4: Your code here.
	int r;
	if (pg == NULL)
		pg = (void*)UTOP;
	while ((r = sys_ipc_try_send(to_env, val, pg, perm)) < 0)
  802d13:	89 74 24 0c          	mov    %esi,0xc(%esp)
  802d17:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  802d1b:	89 7c 24 04          	mov    %edi,0x4(%esp)
  802d1f:	8b 45 08             	mov    0x8(%ebp),%eax
  802d22:	89 04 24             	mov    %eax,(%esp)
  802d25:	e8 83 e4 ff ff       	call   8011ad <sys_ipc_try_send>
  802d2a:	85 c0                	test   %eax,%eax
  802d2c:	78 bf                	js     802ced <ipc_send+0x1d>
		if(r != -E_IPC_NOT_RECV)
			panic("Panic in lib ipc.c : ipc_send() \n");
		sys_yield();
	}
	//panic("ipc_send not implemented");
}
  802d2e:	83 c4 1c             	add    $0x1c,%esp
  802d31:	5b                   	pop    %ebx
  802d32:	5e                   	pop    %esi
  802d33:	5f                   	pop    %edi
  802d34:	5d                   	pop    %ebp
  802d35:	c3                   	ret    

00802d36 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  802d36:	55                   	push   %ebp
  802d37:	89 e5                	mov    %esp,%ebp
  802d39:	56                   	push   %esi
  802d3a:	53                   	push   %ebx
  802d3b:	83 ec 10             	sub    $0x10,%esp
  802d3e:	8b 5d 08             	mov    0x8(%ebp),%ebx
  802d41:	8b 45 0c             	mov    0xc(%ebp),%eax
  802d44:	8b 75 10             	mov    0x10(%ebp),%esi
	// LAB 4: Your code here.
	int r;

	if (pg == NULL)
  802d47:	85 c0                	test   %eax,%eax
  802d49:	75 05                	jne    802d50 <ipc_recv+0x1a>
  802d4b:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
		pg = (void*)UTOP;
	if ((r = sys_ipc_recv(pg)) < 0)
  802d50:	89 04 24             	mov    %eax,(%esp)
  802d53:	e8 f8 e3 ff ff       	call   801150 <sys_ipc_recv>
  802d58:	85 c0                	test   %eax,%eax
  802d5a:	79 16                	jns    802d72 <ipc_recv+0x3c>
	{
		if (from_env_store != NULL)
  802d5c:	85 db                	test   %ebx,%ebx
  802d5e:	74 06                	je     802d66 <ipc_recv+0x30>
			*from_env_store = 0;
  802d60:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
		if(perm_store != NULL)
  802d66:	85 f6                	test   %esi,%esi
  802d68:	74 2c                	je     802d96 <ipc_recv+0x60>
			*perm_store = 0;
  802d6a:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
  802d70:	eb 24                	jmp    802d96 <ipc_recv+0x60>
		return r;
	}
	else
	{	
		if (from_env_store != NULL)
  802d72:	85 db                	test   %ebx,%ebx
  802d74:	74 0a                	je     802d80 <ipc_recv+0x4a>
			*from_env_store = env->env_ipc_from;
  802d76:	a1 70 9f 80 00       	mov    0x809f70,%eax
  802d7b:	8b 40 74             	mov    0x74(%eax),%eax
  802d7e:	89 03                	mov    %eax,(%ebx)
		if(perm_store != NULL)
  802d80:	85 f6                	test   %esi,%esi
  802d82:	74 0a                	je     802d8e <ipc_recv+0x58>
			*perm_store = env->env_ipc_perm;
  802d84:	a1 70 9f 80 00       	mov    0x809f70,%eax
  802d89:	8b 40 78             	mov    0x78(%eax),%eax
  802d8c:	89 06                	mov    %eax,(%esi)
		return env->env_ipc_value;
  802d8e:	a1 70 9f 80 00       	mov    0x809f70,%eax
  802d93:	8b 40 70             	mov    0x70(%eax),%eax
	}		
	//panic("ipc_recv not implemented");
	//return 0;
}
  802d96:	83 c4 10             	add    $0x10,%esp
  802d99:	5b                   	pop    %ebx
  802d9a:	5e                   	pop    %esi
  802d9b:	5d                   	pop    %ebp
  802d9c:	c3                   	ret    
  802d9d:	00 00                	add    %al,(%eax)
	...

00802da0 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  802da0:	55                   	push   %ebp
  802da1:	89 e5                	mov    %esp,%ebp
	pte_t pte;

	if (!(vpd[PDX(v)] & PTE_P))
  802da3:	8b 45 08             	mov    0x8(%ebp),%eax
  802da6:	89 c2                	mov    %eax,%edx
  802da8:	c1 ea 16             	shr    $0x16,%edx
  802dab:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  802db2:	f6 c2 01             	test   $0x1,%dl
  802db5:	74 26                	je     802ddd <pageref+0x3d>
		return 0;
	pte = vpt[VPN(v)];
  802db7:	c1 e8 0c             	shr    $0xc,%eax
  802dba:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
	if (!(pte & PTE_P))
  802dc1:	a8 01                	test   $0x1,%al
  802dc3:	74 18                	je     802ddd <pageref+0x3d>
		return 0;
	return pages[PPN(pte)].pp_ref;
  802dc5:	c1 e8 0c             	shr    $0xc,%eax
  802dc8:	8d 14 40             	lea    (%eax,%eax,2),%edx
  802dcb:	c1 e2 02             	shl    $0x2,%edx
  802dce:	b8 00 00 00 ef       	mov    $0xef000000,%eax
  802dd3:	0f b7 44 02 08       	movzwl 0x8(%edx,%eax,1),%eax
  802dd8:	0f b7 c0             	movzwl %ax,%eax
  802ddb:	eb 05                	jmp    802de2 <pageref+0x42>
  802ddd:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802de2:	5d                   	pop    %ebp
  802de3:	c3                   	ret    
	...

00802df0 <__udivdi3>:
  802df0:	55                   	push   %ebp
  802df1:	89 e5                	mov    %esp,%ebp
  802df3:	57                   	push   %edi
  802df4:	56                   	push   %esi
  802df5:	83 ec 10             	sub    $0x10,%esp
  802df8:	8b 45 14             	mov    0x14(%ebp),%eax
  802dfb:	8b 55 08             	mov    0x8(%ebp),%edx
  802dfe:	8b 75 10             	mov    0x10(%ebp),%esi
  802e01:	8b 7d 0c             	mov    0xc(%ebp),%edi
  802e04:	85 c0                	test   %eax,%eax
  802e06:	89 55 f0             	mov    %edx,-0x10(%ebp)
  802e09:	75 35                	jne    802e40 <__udivdi3+0x50>
  802e0b:	39 fe                	cmp    %edi,%esi
  802e0d:	77 61                	ja     802e70 <__udivdi3+0x80>
  802e0f:	85 f6                	test   %esi,%esi
  802e11:	75 0b                	jne    802e1e <__udivdi3+0x2e>
  802e13:	b8 01 00 00 00       	mov    $0x1,%eax
  802e18:	31 d2                	xor    %edx,%edx
  802e1a:	f7 f6                	div    %esi
  802e1c:	89 c6                	mov    %eax,%esi
  802e1e:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  802e21:	31 d2                	xor    %edx,%edx
  802e23:	89 f8                	mov    %edi,%eax
  802e25:	f7 f6                	div    %esi
  802e27:	89 c7                	mov    %eax,%edi
  802e29:	89 c8                	mov    %ecx,%eax
  802e2b:	f7 f6                	div    %esi
  802e2d:	89 c1                	mov    %eax,%ecx
  802e2f:	89 fa                	mov    %edi,%edx
  802e31:	89 c8                	mov    %ecx,%eax
  802e33:	83 c4 10             	add    $0x10,%esp
  802e36:	5e                   	pop    %esi
  802e37:	5f                   	pop    %edi
  802e38:	5d                   	pop    %ebp
  802e39:	c3                   	ret    
  802e3a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  802e40:	39 f8                	cmp    %edi,%eax
  802e42:	77 1c                	ja     802e60 <__udivdi3+0x70>
  802e44:	0f bd d0             	bsr    %eax,%edx
  802e47:	83 f2 1f             	xor    $0x1f,%edx
  802e4a:	89 55 f4             	mov    %edx,-0xc(%ebp)
  802e4d:	75 39                	jne    802e88 <__udivdi3+0x98>
  802e4f:	3b 75 f0             	cmp    -0x10(%ebp),%esi
  802e52:	0f 86 a0 00 00 00    	jbe    802ef8 <__udivdi3+0x108>
  802e58:	39 f8                	cmp    %edi,%eax
  802e5a:	0f 82 98 00 00 00    	jb     802ef8 <__udivdi3+0x108>
  802e60:	31 ff                	xor    %edi,%edi
  802e62:	31 c9                	xor    %ecx,%ecx
  802e64:	89 c8                	mov    %ecx,%eax
  802e66:	89 fa                	mov    %edi,%edx
  802e68:	83 c4 10             	add    $0x10,%esp
  802e6b:	5e                   	pop    %esi
  802e6c:	5f                   	pop    %edi
  802e6d:	5d                   	pop    %ebp
  802e6e:	c3                   	ret    
  802e6f:	90                   	nop
  802e70:	89 d1                	mov    %edx,%ecx
  802e72:	89 fa                	mov    %edi,%edx
  802e74:	89 c8                	mov    %ecx,%eax
  802e76:	31 ff                	xor    %edi,%edi
  802e78:	f7 f6                	div    %esi
  802e7a:	89 c1                	mov    %eax,%ecx
  802e7c:	89 fa                	mov    %edi,%edx
  802e7e:	89 c8                	mov    %ecx,%eax
  802e80:	83 c4 10             	add    $0x10,%esp
  802e83:	5e                   	pop    %esi
  802e84:	5f                   	pop    %edi
  802e85:	5d                   	pop    %ebp
  802e86:	c3                   	ret    
  802e87:	90                   	nop
  802e88:	0f b6 4d f4          	movzbl -0xc(%ebp),%ecx
  802e8c:	89 f2                	mov    %esi,%edx
  802e8e:	d3 e0                	shl    %cl,%eax
  802e90:	89 45 ec             	mov    %eax,-0x14(%ebp)
  802e93:	b8 20 00 00 00       	mov    $0x20,%eax
  802e98:	2b 45 f4             	sub    -0xc(%ebp),%eax
  802e9b:	89 c1                	mov    %eax,%ecx
  802e9d:	d3 ea                	shr    %cl,%edx
  802e9f:	0f b6 4d f4          	movzbl -0xc(%ebp),%ecx
  802ea3:	0b 55 ec             	or     -0x14(%ebp),%edx
  802ea6:	d3 e6                	shl    %cl,%esi
  802ea8:	89 c1                	mov    %eax,%ecx
  802eaa:	89 75 e8             	mov    %esi,-0x18(%ebp)
  802ead:	89 fe                	mov    %edi,%esi
  802eaf:	d3 ee                	shr    %cl,%esi
  802eb1:	0f b6 4d f4          	movzbl -0xc(%ebp),%ecx
  802eb5:	89 55 ec             	mov    %edx,-0x14(%ebp)
  802eb8:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802ebb:	d3 e7                	shl    %cl,%edi
  802ebd:	89 c1                	mov    %eax,%ecx
  802ebf:	d3 ea                	shr    %cl,%edx
  802ec1:	09 d7                	or     %edx,%edi
  802ec3:	89 f2                	mov    %esi,%edx
  802ec5:	89 f8                	mov    %edi,%eax
  802ec7:	f7 75 ec             	divl   -0x14(%ebp)
  802eca:	89 d6                	mov    %edx,%esi
  802ecc:	89 c7                	mov    %eax,%edi
  802ece:	f7 65 e8             	mull   -0x18(%ebp)
  802ed1:	39 d6                	cmp    %edx,%esi
  802ed3:	89 55 ec             	mov    %edx,-0x14(%ebp)
  802ed6:	72 30                	jb     802f08 <__udivdi3+0x118>
  802ed8:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802edb:	0f b6 4d f4          	movzbl -0xc(%ebp),%ecx
  802edf:	d3 e2                	shl    %cl,%edx
  802ee1:	39 c2                	cmp    %eax,%edx
  802ee3:	73 05                	jae    802eea <__udivdi3+0xfa>
  802ee5:	3b 75 ec             	cmp    -0x14(%ebp),%esi
  802ee8:	74 1e                	je     802f08 <__udivdi3+0x118>
  802eea:	89 f9                	mov    %edi,%ecx
  802eec:	31 ff                	xor    %edi,%edi
  802eee:	e9 71 ff ff ff       	jmp    802e64 <__udivdi3+0x74>
  802ef3:	90                   	nop
  802ef4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802ef8:	31 ff                	xor    %edi,%edi
  802efa:	b9 01 00 00 00       	mov    $0x1,%ecx
  802eff:	e9 60 ff ff ff       	jmp    802e64 <__udivdi3+0x74>
  802f04:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802f08:	8d 4f ff             	lea    -0x1(%edi),%ecx
  802f0b:	31 ff                	xor    %edi,%edi
  802f0d:	89 c8                	mov    %ecx,%eax
  802f0f:	89 fa                	mov    %edi,%edx
  802f11:	83 c4 10             	add    $0x10,%esp
  802f14:	5e                   	pop    %esi
  802f15:	5f                   	pop    %edi
  802f16:	5d                   	pop    %ebp
  802f17:	c3                   	ret    
	...

00802f20 <__umoddi3>:
  802f20:	55                   	push   %ebp
  802f21:	89 e5                	mov    %esp,%ebp
  802f23:	57                   	push   %edi
  802f24:	56                   	push   %esi
  802f25:	83 ec 20             	sub    $0x20,%esp
  802f28:	8b 55 14             	mov    0x14(%ebp),%edx
  802f2b:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802f2e:	8b 7d 10             	mov    0x10(%ebp),%edi
  802f31:	8b 75 0c             	mov    0xc(%ebp),%esi
  802f34:	85 d2                	test   %edx,%edx
  802f36:	89 c8                	mov    %ecx,%eax
  802f38:	89 4d f4             	mov    %ecx,-0xc(%ebp)
  802f3b:	75 13                	jne    802f50 <__umoddi3+0x30>
  802f3d:	39 f7                	cmp    %esi,%edi
  802f3f:	76 3f                	jbe    802f80 <__umoddi3+0x60>
  802f41:	89 f2                	mov    %esi,%edx
  802f43:	f7 f7                	div    %edi
  802f45:	89 d0                	mov    %edx,%eax
  802f47:	31 d2                	xor    %edx,%edx
  802f49:	83 c4 20             	add    $0x20,%esp
  802f4c:	5e                   	pop    %esi
  802f4d:	5f                   	pop    %edi
  802f4e:	5d                   	pop    %ebp
  802f4f:	c3                   	ret    
  802f50:	39 f2                	cmp    %esi,%edx
  802f52:	77 4c                	ja     802fa0 <__umoddi3+0x80>
  802f54:	0f bd ca             	bsr    %edx,%ecx
  802f57:	83 f1 1f             	xor    $0x1f,%ecx
  802f5a:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  802f5d:	75 51                	jne    802fb0 <__umoddi3+0x90>
  802f5f:	3b 7d f4             	cmp    -0xc(%ebp),%edi
  802f62:	0f 87 e0 00 00 00    	ja     803048 <__umoddi3+0x128>
  802f68:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f6b:	29 f8                	sub    %edi,%eax
  802f6d:	19 d6                	sbb    %edx,%esi
  802f6f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802f72:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f75:	89 f2                	mov    %esi,%edx
  802f77:	83 c4 20             	add    $0x20,%esp
  802f7a:	5e                   	pop    %esi
  802f7b:	5f                   	pop    %edi
  802f7c:	5d                   	pop    %ebp
  802f7d:	c3                   	ret    
  802f7e:	66 90                	xchg   %ax,%ax
  802f80:	85 ff                	test   %edi,%edi
  802f82:	75 0b                	jne    802f8f <__umoddi3+0x6f>
  802f84:	b8 01 00 00 00       	mov    $0x1,%eax
  802f89:	31 d2                	xor    %edx,%edx
  802f8b:	f7 f7                	div    %edi
  802f8d:	89 c7                	mov    %eax,%edi
  802f8f:	89 f0                	mov    %esi,%eax
  802f91:	31 d2                	xor    %edx,%edx
  802f93:	f7 f7                	div    %edi
  802f95:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f98:	f7 f7                	div    %edi
  802f9a:	eb a9                	jmp    802f45 <__umoddi3+0x25>
  802f9c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802fa0:	89 c8                	mov    %ecx,%eax
  802fa2:	89 f2                	mov    %esi,%edx
  802fa4:	83 c4 20             	add    $0x20,%esp
  802fa7:	5e                   	pop    %esi
  802fa8:	5f                   	pop    %edi
  802fa9:	5d                   	pop    %ebp
  802faa:	c3                   	ret    
  802fab:	90                   	nop
  802fac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802fb0:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
  802fb4:	d3 e2                	shl    %cl,%edx
  802fb6:	89 55 f4             	mov    %edx,-0xc(%ebp)
  802fb9:	ba 20 00 00 00       	mov    $0x20,%edx
  802fbe:	2b 55 f0             	sub    -0x10(%ebp),%edx
  802fc1:	89 55 ec             	mov    %edx,-0x14(%ebp)
  802fc4:	0f b6 4d ec          	movzbl -0x14(%ebp),%ecx
  802fc8:	89 fa                	mov    %edi,%edx
  802fca:	d3 ea                	shr    %cl,%edx
  802fcc:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
  802fd0:	0b 55 f4             	or     -0xc(%ebp),%edx
  802fd3:	d3 e7                	shl    %cl,%edi
  802fd5:	0f b6 4d ec          	movzbl -0x14(%ebp),%ecx
  802fd9:	89 55 f4             	mov    %edx,-0xc(%ebp)
  802fdc:	89 f2                	mov    %esi,%edx
  802fde:	89 7d e8             	mov    %edi,-0x18(%ebp)
  802fe1:	89 c7                	mov    %eax,%edi
  802fe3:	d3 ea                	shr    %cl,%edx
  802fe5:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
  802fe9:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  802fec:	89 c2                	mov    %eax,%edx
  802fee:	d3 e6                	shl    %cl,%esi
  802ff0:	0f b6 4d ec          	movzbl -0x14(%ebp),%ecx
  802ff4:	d3 ea                	shr    %cl,%edx
  802ff6:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
  802ffa:	09 d6                	or     %edx,%esi
  802ffc:	89 f0                	mov    %esi,%eax
  802ffe:	8b 75 e4             	mov    -0x1c(%ebp),%esi
  803001:	d3 e7                	shl    %cl,%edi
  803003:	89 f2                	mov    %esi,%edx
  803005:	f7 75 f4             	divl   -0xc(%ebp)
  803008:	89 d6                	mov    %edx,%esi
  80300a:	f7 65 e8             	mull   -0x18(%ebp)
  80300d:	39 d6                	cmp    %edx,%esi
  80300f:	72 2b                	jb     80303c <__umoddi3+0x11c>
  803011:	39 c7                	cmp    %eax,%edi
  803013:	72 23                	jb     803038 <__umoddi3+0x118>
  803015:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
  803019:	29 c7                	sub    %eax,%edi
  80301b:	19 d6                	sbb    %edx,%esi
  80301d:	89 f0                	mov    %esi,%eax
  80301f:	89 f2                	mov    %esi,%edx
  803021:	d3 ef                	shr    %cl,%edi
  803023:	0f b6 4d ec          	movzbl -0x14(%ebp),%ecx
  803027:	d3 e0                	shl    %cl,%eax
  803029:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
  80302d:	09 f8                	or     %edi,%eax
  80302f:	d3 ea                	shr    %cl,%edx
  803031:	83 c4 20             	add    $0x20,%esp
  803034:	5e                   	pop    %esi
  803035:	5f                   	pop    %edi
  803036:	5d                   	pop    %ebp
  803037:	c3                   	ret    
  803038:	39 d6                	cmp    %edx,%esi
  80303a:	75 d9                	jne    803015 <__umoddi3+0xf5>
  80303c:	2b 45 e8             	sub    -0x18(%ebp),%eax
  80303f:	1b 55 f4             	sbb    -0xc(%ebp),%edx
  803042:	eb d1                	jmp    803015 <__umoddi3+0xf5>
  803044:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  803048:	39 f2                	cmp    %esi,%edx
  80304a:	0f 82 18 ff ff ff    	jb     802f68 <__umoddi3+0x48>
  803050:	e9 1d ff ff ff       	jmp    802f72 <__umoddi3+0x52>
