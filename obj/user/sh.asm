
obj/user/sh:     file format elf32-i386


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
  80002c:	e8 5b 0a 00 00       	call   800a8c <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>
	...

00800040 <usage>:
}


void
usage(void)
{
  800040:	55                   	push   %ebp
  800041:	89 e5                	mov    %esp,%ebp
  800043:	83 ec 18             	sub    $0x18,%esp
	cprintf("usage: sh [-dix] [command-file]\n");
  800046:	c7 04 24 c0 3d 80 00 	movl   $0x803dc0,(%esp)
  80004d:	e8 6b 0b 00 00       	call   800bbd <cprintf>
	exit();
  800052:	e8 85 0a 00 00       	call   800adc <exit>
}
  800057:	c9                   	leave  
  800058:	c3                   	ret    

00800059 <_gettoken>:
#define WHITESPACE " \t\r\n"
#define SYMBOLS "<|>&;()"

int
_gettoken(char *s, char **p1, char **p2)
{
  800059:	55                   	push   %ebp
  80005a:	89 e5                	mov    %esp,%ebp
  80005c:	57                   	push   %edi
  80005d:	56                   	push   %esi
  80005e:	53                   	push   %ebx
  80005f:	83 ec 1c             	sub    $0x1c,%esp
  800062:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int t;

	if (s == 0) {
  800065:	85 db                	test   %ebx,%ebx
  800067:	75 23                	jne    80008c <_gettoken+0x33>
		if (debug > 1)
  800069:	83 3d 80 80 80 00 01 	cmpl   $0x1,0x808080
  800070:	0f 8e 42 01 00 00    	jle    8001b8 <_gettoken+0x15f>
			cprintf("GETTOKEN NULL\n");
  800076:	c7 04 24 32 3e 80 00 	movl   $0x803e32,(%esp)
  80007d:	e8 3b 0b 00 00       	call   800bbd <cprintf>
  800082:	be 00 00 00 00       	mov    $0x0,%esi
  800087:	e9 31 01 00 00       	jmp    8001bd <_gettoken+0x164>
		return 0;
	}

	if (debug > 1)
  80008c:	83 3d 80 80 80 00 01 	cmpl   $0x1,0x808080
  800093:	7e 10                	jle    8000a5 <_gettoken+0x4c>
		cprintf("GETTOKEN: %s\n", s);
  800095:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  800099:	c7 04 24 41 3e 80 00 	movl   $0x803e41,(%esp)
  8000a0:	e8 18 0b 00 00       	call   800bbd <cprintf>

	*p1 = 0;
  8000a5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8000a8:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	*p2 = 0;
  8000ae:	8b 55 10             	mov    0x10(%ebp),%edx
  8000b1:	c7 02 00 00 00 00    	movl   $0x0,(%edx)

	while (strchr(WHITESPACE, *s))
  8000b7:	eb 06                	jmp    8000bf <_gettoken+0x66>
		*s++ = 0;
  8000b9:	c6 03 00             	movb   $0x0,(%ebx)
  8000bc:	83 c3 01             	add    $0x1,%ebx
		cprintf("GETTOKEN: %s\n", s);

	*p1 = 0;
	*p2 = 0;

	while (strchr(WHITESPACE, *s))
  8000bf:	0f be 03             	movsbl (%ebx),%eax
  8000c2:	89 44 24 04          	mov    %eax,0x4(%esp)
  8000c6:	c7 04 24 4f 3e 80 00 	movl   $0x803e4f,(%esp)
  8000cd:	e8 9c 13 00 00       	call   80146e <strchr>
  8000d2:	85 c0                	test   %eax,%eax
  8000d4:	75 e3                	jne    8000b9 <_gettoken+0x60>
  8000d6:	89 df                	mov    %ebx,%edi
		*s++ = 0;
	if (*s == 0) {
  8000d8:	0f b6 03             	movzbl (%ebx),%eax
  8000db:	84 c0                	test   %al,%al
  8000dd:	75 23                	jne    800102 <_gettoken+0xa9>
		if (debug > 1)
  8000df:	83 3d 80 80 80 00 01 	cmpl   $0x1,0x808080
  8000e6:	0f 8e cc 00 00 00    	jle    8001b8 <_gettoken+0x15f>
			cprintf("EOL\n");
  8000ec:	c7 04 24 54 3e 80 00 	movl   $0x803e54,(%esp)
  8000f3:	e8 c5 0a 00 00       	call   800bbd <cprintf>
  8000f8:	be 00 00 00 00       	mov    $0x0,%esi
  8000fd:	e9 bb 00 00 00       	jmp    8001bd <_gettoken+0x164>
		return 0;
	}
	if (strchr(SYMBOLS, *s)) {
  800102:	0f be c0             	movsbl %al,%eax
  800105:	89 44 24 04          	mov    %eax,0x4(%esp)
  800109:	c7 04 24 65 3e 80 00 	movl   $0x803e65,(%esp)
  800110:	e8 59 13 00 00       	call   80146e <strchr>
  800115:	85 c0                	test   %eax,%eax
  800117:	74 32                	je     80014b <_gettoken+0xf2>
		t = *s;
  800119:	0f be 33             	movsbl (%ebx),%esi
		*p1 = s;
  80011c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80011f:	89 18                	mov    %ebx,(%eax)
		*s++ = 0;
  800121:	c6 03 00             	movb   $0x0,(%ebx)
		*p2 = s;
  800124:	83 c7 01             	add    $0x1,%edi
  800127:	8b 55 10             	mov    0x10(%ebp),%edx
  80012a:	89 3a                	mov    %edi,(%edx)
		if (debug > 1)
  80012c:	83 3d 80 80 80 00 01 	cmpl   $0x1,0x808080
  800133:	0f 8e 84 00 00 00    	jle    8001bd <_gettoken+0x164>
			cprintf("TOK %c\n", t);
  800139:	89 74 24 04          	mov    %esi,0x4(%esp)
  80013d:	c7 04 24 59 3e 80 00 	movl   $0x803e59,(%esp)
  800144:	e8 74 0a 00 00       	call   800bbd <cprintf>
  800149:	eb 72                	jmp    8001bd <_gettoken+0x164>
		return t;
	}
	*p1 = s;
  80014b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80014e:	89 18                	mov    %ebx,(%eax)
	while (*s && !strchr(WHITESPACE SYMBOLS, *s))
  800150:	0f b6 03             	movzbl (%ebx),%eax
  800153:	84 c0                	test   %al,%al
  800155:	75 0c                	jne    800163 <_gettoken+0x10a>
  800157:	eb 21                	jmp    80017a <_gettoken+0x121>
		s++;
  800159:	83 c3 01             	add    $0x1,%ebx
		if (debug > 1)
			cprintf("TOK %c\n", t);
		return t;
	}
	*p1 = s;
	while (*s && !strchr(WHITESPACE SYMBOLS, *s))
  80015c:	0f b6 03             	movzbl (%ebx),%eax
  80015f:	84 c0                	test   %al,%al
  800161:	74 17                	je     80017a <_gettoken+0x121>
  800163:	0f be c0             	movsbl %al,%eax
  800166:	89 44 24 04          	mov    %eax,0x4(%esp)
  80016a:	c7 04 24 61 3e 80 00 	movl   $0x803e61,(%esp)
  800171:	e8 f8 12 00 00       	call   80146e <strchr>
  800176:	85 c0                	test   %eax,%eax
  800178:	74 df                	je     800159 <_gettoken+0x100>
		s++;
	*p2 = s;
  80017a:	8b 55 10             	mov    0x10(%ebp),%edx
  80017d:	89 1a                	mov    %ebx,(%edx)
	if (debug > 1) {
  80017f:	be 77 00 00 00       	mov    $0x77,%esi
  800184:	83 3d 80 80 80 00 01 	cmpl   $0x1,0x808080
  80018b:	7e 30                	jle    8001bd <_gettoken+0x164>
		t = **p2;
  80018d:	0f b6 33             	movzbl (%ebx),%esi
		**p2 = 0;
  800190:	c6 03 00             	movb   $0x0,(%ebx)
		cprintf("WORD: %s\n", *p1);
  800193:	8b 55 0c             	mov    0xc(%ebp),%edx
  800196:	8b 02                	mov    (%edx),%eax
  800198:	89 44 24 04          	mov    %eax,0x4(%esp)
  80019c:	c7 04 24 6d 3e 80 00 	movl   $0x803e6d,(%esp)
  8001a3:	e8 15 0a 00 00       	call   800bbd <cprintf>
		**p2 = t;
  8001a8:	8b 55 10             	mov    0x10(%ebp),%edx
  8001ab:	8b 02                	mov    (%edx),%eax
  8001ad:	89 f2                	mov    %esi,%edx
  8001af:	88 10                	mov    %dl,(%eax)
  8001b1:	be 77 00 00 00       	mov    $0x77,%esi
  8001b6:	eb 05                	jmp    8001bd <_gettoken+0x164>
  8001b8:	be 00 00 00 00       	mov    $0x0,%esi
	}
	return 'w';
}
  8001bd:	89 f0                	mov    %esi,%eax
  8001bf:	83 c4 1c             	add    $0x1c,%esp
  8001c2:	5b                   	pop    %ebx
  8001c3:	5e                   	pop    %esi
  8001c4:	5f                   	pop    %edi
  8001c5:	5d                   	pop    %ebp
  8001c6:	c3                   	ret    

008001c7 <gettoken>:

int
gettoken(char *s, char **p1)
{
  8001c7:	55                   	push   %ebp
  8001c8:	89 e5                	mov    %esp,%ebp
  8001ca:	83 ec 18             	sub    $0x18,%esp
  8001cd:	8b 45 08             	mov    0x8(%ebp),%eax
	static int c, nc;
	static char* np1, *np2;

	if (s) {
  8001d0:	85 c0                	test   %eax,%eax
  8001d2:	74 24                	je     8001f8 <gettoken+0x31>
		nc = _gettoken(s, &np1, &np2);
  8001d4:	c7 44 24 08 84 80 80 	movl   $0x808084,0x8(%esp)
  8001db:	00 
  8001dc:	c7 44 24 04 88 80 80 	movl   $0x808088,0x4(%esp)
  8001e3:	00 
  8001e4:	89 04 24             	mov    %eax,(%esp)
  8001e7:	e8 6d fe ff ff       	call   800059 <_gettoken>
  8001ec:	a3 8c 80 80 00       	mov    %eax,0x80808c
  8001f1:	b8 00 00 00 00       	mov    $0x0,%eax
		return 0;
  8001f6:	eb 3c                	jmp    800234 <gettoken+0x6d>
	}
	c = nc;
  8001f8:	a1 8c 80 80 00       	mov    0x80808c,%eax
  8001fd:	a3 90 80 80 00       	mov    %eax,0x808090
	*p1 = np1;
  800202:	8b 15 88 80 80 00    	mov    0x808088,%edx
  800208:	8b 45 0c             	mov    0xc(%ebp),%eax
  80020b:	89 10                	mov    %edx,(%eax)
	nc = _gettoken(np2, &np1, &np2);
  80020d:	c7 44 24 08 84 80 80 	movl   $0x808084,0x8(%esp)
  800214:	00 
  800215:	c7 44 24 04 88 80 80 	movl   $0x808088,0x4(%esp)
  80021c:	00 
  80021d:	a1 84 80 80 00       	mov    0x808084,%eax
  800222:	89 04 24             	mov    %eax,(%esp)
  800225:	e8 2f fe ff ff       	call   800059 <_gettoken>
  80022a:	a3 8c 80 80 00       	mov    %eax,0x80808c
	return c;
  80022f:	a1 90 80 80 00       	mov    0x808090,%eax
}
  800234:	c9                   	leave  
  800235:	c3                   	ret    

00800236 <runcmd>:
// runcmd() is called in a forked child,
// so it's OK to manipulate file descriptor state.
#define MAXARGS 16
void
runcmd(char* s)
{
  800236:	55                   	push   %ebp
  800237:	89 e5                	mov    %esp,%ebp
  800239:	57                   	push   %edi
  80023a:	56                   	push   %esi
  80023b:	53                   	push   %ebx
  80023c:	81 ec 6c 04 00 00    	sub    $0x46c,%esp
	char *argv[MAXARGS], *t, argv0buf[BUFSIZ];
	int argc, c, i, r, p[2], fd, pipe_child;

	pipe_child = 0;
	gettoken(s, 0);
  800242:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  800249:	00 
  80024a:	8b 45 08             	mov    0x8(%ebp),%eax
  80024d:	89 04 24             	mov    %eax,(%esp)
  800250:	e8 72 ff ff ff       	call   8001c7 <gettoken>
  800255:	be 00 00 00 00       	mov    $0x0,%esi
	
again:
	argc = 0;
	while (1) {
		switch ((c = gettoken(0, &t))) {
  80025a:	8d 5d a4             	lea    -0x5c(%ebp),%ebx
  80025d:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  800261:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  800268:	e8 5a ff ff ff       	call   8001c7 <gettoken>
  80026d:	83 f8 77             	cmp    $0x77,%eax
  800270:	74 3b                	je     8002ad <runcmd+0x77>
  800272:	83 f8 77             	cmp    $0x77,%eax
  800275:	7f 24                	jg     80029b <runcmd+0x65>
  800277:	83 f8 3c             	cmp    $0x3c,%eax
  80027a:	74 53                	je     8002cf <runcmd+0x99>
  80027c:	83 f8 3e             	cmp    $0x3e,%eax
  80027f:	90                   	nop
  800280:	0f 84 cd 00 00 00    	je     800353 <runcmd+0x11d>
		case 0:		// String is complete
			// Run the current command!
			goto runit;
			
		default:
			panic("bad return %d from gettoken", c);
  800286:	bf 00 00 00 00       	mov    $0x0,%edi
	gettoken(s, 0);
	
again:
	argc = 0;
	while (1) {
		switch ((c = gettoken(0, &t))) {
  80028b:	85 c0                	test   %eax,%eax
  80028d:	8d 76 00             	lea    0x0(%esi),%esi
  800290:	0f 84 4b 02 00 00    	je     8004e1 <runcmd+0x2ab>
  800296:	e9 26 02 00 00       	jmp    8004c1 <runcmd+0x28b>
  80029b:	83 f8 7c             	cmp    $0x7c,%eax
  80029e:	66 90                	xchg   %ax,%ax
  8002a0:	0f 85 1b 02 00 00    	jne    8004c1 <runcmd+0x28b>
  8002a6:	66 90                	xchg   %ax,%ax
  8002a8:	e9 27 01 00 00       	jmp    8003d4 <runcmd+0x19e>

		case 'w':	// Add an argument
			if (argc == MAXARGS) {
  8002ad:	83 fe 10             	cmp    $0x10,%esi
  8002b0:	75 11                	jne    8002c3 <runcmd+0x8d>
				cprintf("too many arguments\n");
  8002b2:	c7 04 24 77 3e 80 00 	movl   $0x803e77,(%esp)
  8002b9:	e8 ff 08 00 00       	call   800bbd <cprintf>
				exit();
  8002be:	e8 19 08 00 00       	call   800adc <exit>
			}
			argv[argc++] = t;
  8002c3:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  8002c6:	89 44 b5 a8          	mov    %eax,-0x58(%ebp,%esi,4)
  8002ca:	83 c6 01             	add    $0x1,%esi
			break;
  8002cd:	eb 8e                	jmp    80025d <runcmd+0x27>
			
		case '<':	// Input redirection
			// Grab the filename from the argument list
			if (gettoken(0, &t) != 'w') {
  8002cf:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8002d3:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8002da:	e8 e8 fe ff ff       	call   8001c7 <gettoken>
  8002df:	83 f8 77             	cmp    $0x77,%eax
  8002e2:	74 11                	je     8002f5 <runcmd+0xbf>
				cprintf("syntax error: < not followed by word\n");
  8002e4:	c7 04 24 e4 3d 80 00 	movl   $0x803de4,(%esp)
  8002eb:	e8 cd 08 00 00       	call   800bbd <cprintf>
				exit();
  8002f0:	e8 e7 07 00 00       	call   800adc <exit>
			}
			if ((fd = open(t, O_RDONLY)) < 0) {
  8002f5:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  8002fc:	00 
  8002fd:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  800300:	89 04 24             	mov    %eax,(%esp)
  800303:	e8 3b 25 00 00       	call   802843 <open>
  800308:	89 c7                	mov    %eax,%edi
  80030a:	85 c0                	test   %eax,%eax
  80030c:	79 1e                	jns    80032c <runcmd+0xf6>
				cprintf("open %s for read: %e", t, fd);
  80030e:	89 44 24 08          	mov    %eax,0x8(%esp)
  800312:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  800315:	89 44 24 04          	mov    %eax,0x4(%esp)
  800319:	c7 04 24 8b 3e 80 00 	movl   $0x803e8b,(%esp)
  800320:	e8 98 08 00 00       	call   800bbd <cprintf>
				exit();
  800325:	e8 b2 07 00 00       	call   800adc <exit>
  80032a:	eb 0a                	jmp    800336 <runcmd+0x100>
			}
			if (fd != 0) {
  80032c:	85 c0                	test   %eax,%eax
  80032e:	66 90                	xchg   %ax,%ax
  800330:	0f 84 27 ff ff ff    	je     80025d <runcmd+0x27>
				dup(fd, 0);
  800336:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  80033d:	00 
  80033e:	89 3c 24             	mov    %edi,(%esp)
  800341:	e8 f7 21 00 00       	call   80253d <dup>
				close(fd);
  800346:	89 3c 24             	mov    %edi,(%esp)
  800349:	e8 50 21 00 00       	call   80249e <close>
  80034e:	e9 0a ff ff ff       	jmp    80025d <runcmd+0x27>
			}
			break;
			
		case '>':	// Output redirection
			// Grab the filename from the argument list
			if (gettoken(0, &t) != 'w') {
  800353:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  800357:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80035e:	e8 64 fe ff ff       	call   8001c7 <gettoken>
  800363:	83 f8 77             	cmp    $0x77,%eax
  800366:	74 11                	je     800379 <runcmd+0x143>
				cprintf("syntax error: > not followed by word\n");
  800368:	c7 04 24 0c 3e 80 00 	movl   $0x803e0c,(%esp)
  80036f:	e8 49 08 00 00       	call   800bbd <cprintf>
				exit();
  800374:	e8 63 07 00 00       	call   800adc <exit>
			}
			if ((fd = open(t, O_WRONLY|O_CREAT|O_TRUNC)) < 0) {
  800379:	c7 44 24 04 01 03 00 	movl   $0x301,0x4(%esp)
  800380:	00 
  800381:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  800384:	89 04 24             	mov    %eax,(%esp)
  800387:	e8 b7 24 00 00       	call   802843 <open>
  80038c:	89 c7                	mov    %eax,%edi
  80038e:	85 c0                	test   %eax,%eax
  800390:	79 1c                	jns    8003ae <runcmd+0x178>
				cprintf("open %s for write: %e", t, fd);
  800392:	89 44 24 08          	mov    %eax,0x8(%esp)
  800396:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  800399:	89 44 24 04          	mov    %eax,0x4(%esp)
  80039d:	c7 04 24 a0 3e 80 00 	movl   $0x803ea0,(%esp)
  8003a4:	e8 14 08 00 00       	call   800bbd <cprintf>
				exit();
  8003a9:	e8 2e 07 00 00       	call   800adc <exit>
			}
			if (fd != 1) {
  8003ae:	83 ff 01             	cmp    $0x1,%edi
  8003b1:	0f 84 a6 fe ff ff    	je     80025d <runcmd+0x27>
				dup(fd, 1);
  8003b7:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  8003be:	00 
  8003bf:	89 3c 24             	mov    %edi,(%esp)
  8003c2:	e8 76 21 00 00       	call   80253d <dup>
				close(fd);
  8003c7:	89 3c 24             	mov    %edi,(%esp)
  8003ca:	e8 cf 20 00 00       	call   80249e <close>
  8003cf:	e9 89 fe ff ff       	jmp    80025d <runcmd+0x27>
			}
			break;
			
		case '|':	// Pipe
			if ((r = pipe(p)) < 0) {
  8003d4:	8d 85 9c fb ff ff    	lea    -0x464(%ebp),%eax
  8003da:	89 04 24             	mov    %eax,(%esp)
  8003dd:	e8 a7 33 00 00       	call   803789 <pipe>
  8003e2:	85 c0                	test   %eax,%eax
  8003e4:	79 15                	jns    8003fb <runcmd+0x1c5>
				cprintf("pipe: %e", r);
  8003e6:	89 44 24 04          	mov    %eax,0x4(%esp)
  8003ea:	c7 04 24 b6 3e 80 00 	movl   $0x803eb6,(%esp)
  8003f1:	e8 c7 07 00 00       	call   800bbd <cprintf>
				exit();
  8003f6:	e8 e1 06 00 00       	call   800adc <exit>
			}
			if (debug)
  8003fb:	83 3d 80 80 80 00 00 	cmpl   $0x0,0x808080
  800402:	74 20                	je     800424 <runcmd+0x1ee>
				cprintf("PIPE: %d %d\n", p[0], p[1]);
  800404:	8b 85 a0 fb ff ff    	mov    -0x460(%ebp),%eax
  80040a:	89 44 24 08          	mov    %eax,0x8(%esp)
  80040e:	8b 85 9c fb ff ff    	mov    -0x464(%ebp),%eax
  800414:	89 44 24 04          	mov    %eax,0x4(%esp)
  800418:	c7 04 24 bf 3e 80 00 	movl   $0x803ebf,(%esp)
  80041f:	e8 99 07 00 00       	call   800bbd <cprintf>
			if ((r = fork()) < 0) {
  800424:	e8 bc 19 00 00       	call   801de5 <fork>
  800429:	89 c7                	mov    %eax,%edi
  80042b:	85 c0                	test   %eax,%eax
  80042d:	79 15                	jns    800444 <runcmd+0x20e>
				cprintf("fork: %e", r);
  80042f:	89 44 24 04          	mov    %eax,0x4(%esp)
  800433:	c7 04 24 cc 3e 80 00 	movl   $0x803ecc,(%esp)
  80043a:	e8 7e 07 00 00       	call   800bbd <cprintf>
				exit();
  80043f:	e8 98 06 00 00       	call   800adc <exit>
			}
			if (r == 0) {
  800444:	85 ff                	test   %edi,%edi
  800446:	75 40                	jne    800488 <runcmd+0x252>
				if (p[0] != 0) {
  800448:	8b 85 9c fb ff ff    	mov    -0x464(%ebp),%eax
  80044e:	85 c0                	test   %eax,%eax
  800450:	74 1e                	je     800470 <runcmd+0x23a>
					dup(p[0], 0);
  800452:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  800459:	00 
  80045a:	89 04 24             	mov    %eax,(%esp)
  80045d:	e8 db 20 00 00       	call   80253d <dup>
					close(p[0]);
  800462:	8b 85 9c fb ff ff    	mov    -0x464(%ebp),%eax
  800468:	89 04 24             	mov    %eax,(%esp)
  80046b:	e8 2e 20 00 00       	call   80249e <close>
				}
				close(p[1]);
  800470:	8b 85 a0 fb ff ff    	mov    -0x460(%ebp),%eax
  800476:	89 04 24             	mov    %eax,(%esp)
  800479:	e8 20 20 00 00       	call   80249e <close>
  80047e:	be 00 00 00 00       	mov    $0x0,%esi
  800483:	e9 d5 fd ff ff       	jmp    80025d <runcmd+0x27>
				goto again;
			} else {
				pipe_child = r;
				if (p[1] != 1) {
  800488:	8b 85 a0 fb ff ff    	mov    -0x460(%ebp),%eax
  80048e:	83 f8 01             	cmp    $0x1,%eax
  800491:	74 1e                	je     8004b1 <runcmd+0x27b>
					dup(p[1], 1);
  800493:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  80049a:	00 
  80049b:	89 04 24             	mov    %eax,(%esp)
  80049e:	e8 9a 20 00 00       	call   80253d <dup>
					close(p[1]);
  8004a3:	8b 85 a0 fb ff ff    	mov    -0x460(%ebp),%eax
  8004a9:	89 04 24             	mov    %eax,(%esp)
  8004ac:	e8 ed 1f 00 00       	call   80249e <close>
				}
				close(p[0]);
  8004b1:	8b 85 9c fb ff ff    	mov    -0x464(%ebp),%eax
  8004b7:	89 04 24             	mov    %eax,(%esp)
  8004ba:	e8 df 1f 00 00       	call   80249e <close>
				goto runit;
  8004bf:	eb 20                	jmp    8004e1 <runcmd+0x2ab>
		case 0:		// String is complete
			// Run the current command!
			goto runit;
			
		default:
			panic("bad return %d from gettoken", c);
  8004c1:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8004c5:	c7 44 24 08 d5 3e 80 	movl   $0x803ed5,0x8(%esp)
  8004cc:	00 
  8004cd:	c7 44 24 04 6e 00 00 	movl   $0x6e,0x4(%esp)
  8004d4:	00 
  8004d5:	c7 04 24 f1 3e 80 00 	movl   $0x803ef1,(%esp)
  8004dc:	e8 17 06 00 00       	call   800af8 <_panic>
		}
	}

runit:
	// Return immediately if command line was empty.
	if(argc == 0) {
  8004e1:	85 f6                	test   %esi,%esi
  8004e3:	75 1e                	jne    800503 <runcmd+0x2cd>
		if (debug)
  8004e5:	83 3d 80 80 80 00 00 	cmpl   $0x0,0x808080
  8004ec:	0f 84 7f 01 00 00    	je     800671 <runcmd+0x43b>
			cprintf("EMPTY COMMAND\n");
  8004f2:	c7 04 24 fb 3e 80 00 	movl   $0x803efb,(%esp)
  8004f9:	e8 bf 06 00 00       	call   800bbd <cprintf>
  8004fe:	e9 6e 01 00 00       	jmp    800671 <runcmd+0x43b>

	// Clean up command line.
	// Read all commands from the filesystem: add an initial '/' to
	// the command name.
	// This essentially acts like 'PATH=/'.
	if (argv[0][0] != '/') {
  800503:	8b 45 a8             	mov    -0x58(%ebp),%eax
  800506:	80 38 2f             	cmpb   $0x2f,(%eax)
  800509:	74 22                	je     80052d <runcmd+0x2f7>
		argv0buf[0] = '/';
  80050b:	c6 85 a4 fb ff ff 2f 	movb   $0x2f,-0x45c(%ebp)
		strcpy(argv0buf + 1, argv[0]);
  800512:	89 44 24 04          	mov    %eax,0x4(%esp)
  800516:	8d 9d a4 fb ff ff    	lea    -0x45c(%ebp),%ebx
  80051c:	8d 85 a5 fb ff ff    	lea    -0x45b(%ebp),%eax
  800522:	89 04 24             	mov    %eax,(%esp)
  800525:	e8 40 0e 00 00       	call   80136a <strcpy>
		argv[0] = argv0buf;
  80052a:	89 5d a8             	mov    %ebx,-0x58(%ebp)
	}
	argv[argc] = 0;
  80052d:	c7 44 b5 a8 00 00 00 	movl   $0x0,-0x58(%ebp,%esi,4)
  800534:	00 
	
	// Print the command.
	if (debug) {
  800535:	83 3d 80 80 80 00 00 	cmpl   $0x0,0x808080
  80053c:	74 47                	je     800585 <runcmd+0x34f>
		cprintf("[%08x] SPAWN:", env->env_id);
  80053e:	a1 a0 84 80 00       	mov    0x8084a0,%eax
  800543:	8b 40 4c             	mov    0x4c(%eax),%eax
  800546:	89 44 24 04          	mov    %eax,0x4(%esp)
  80054a:	c7 04 24 0a 3f 80 00 	movl   $0x803f0a,(%esp)
  800551:	e8 67 06 00 00       	call   800bbd <cprintf>
		for (i = 0; argv[i]; i++)
  800556:	8b 45 a8             	mov    -0x58(%ebp),%eax
  800559:	85 c0                	test   %eax,%eax
  80055b:	74 1c                	je     800579 <runcmd+0x343>
  80055d:	8d 5d ac             	lea    -0x54(%ebp),%ebx
			cprintf(" %s", argv[i]);
  800560:	89 44 24 04          	mov    %eax,0x4(%esp)
  800564:	c7 04 24 92 3f 80 00 	movl   $0x803f92,(%esp)
  80056b:	e8 4d 06 00 00       	call   800bbd <cprintf>
	argv[argc] = 0;
	
	// Print the command.
	if (debug) {
		cprintf("[%08x] SPAWN:", env->env_id);
		for (i = 0; argv[i]; i++)
  800570:	8b 03                	mov    (%ebx),%eax
  800572:	83 c3 04             	add    $0x4,%ebx
  800575:	85 c0                	test   %eax,%eax
  800577:	75 e7                	jne    800560 <runcmd+0x32a>
			cprintf(" %s", argv[i]);
		cprintf("\n");
  800579:	c7 04 24 52 3e 80 00 	movl   $0x803e52,(%esp)
  800580:	e8 38 06 00 00       	call   800bbd <cprintf>
	}

	// Spawn the command!
	if ((r = spawn(argv[0], (const char**) argv)) < 0)
  800585:	8d 45 a8             	lea    -0x58(%ebp),%eax
  800588:	89 44 24 04          	mov    %eax,0x4(%esp)
  80058c:	8b 45 a8             	mov    -0x58(%ebp),%eax
  80058f:	89 04 24             	mov    %eax,(%esp)
  800592:	e8 75 24 00 00       	call   802a0c <spawn>
  800597:	89 c3                	mov    %eax,%ebx
  800599:	85 c0                	test   %eax,%eax
  80059b:	79 1e                	jns    8005bb <runcmd+0x385>
		cprintf("spawn %s: %e\n", argv[0], r);
  80059d:	89 44 24 08          	mov    %eax,0x8(%esp)
  8005a1:	8b 45 a8             	mov    -0x58(%ebp),%eax
  8005a4:	89 44 24 04          	mov    %eax,0x4(%esp)
  8005a8:	c7 04 24 18 3f 80 00 	movl   $0x803f18,(%esp)
  8005af:	e8 09 06 00 00       	call   800bbd <cprintf>

	// In the parent, close all file descriptors and wait for the
	// spawned command to exit.
	close_all();
  8005b4:	e8 62 1f 00 00       	call   80251b <close_all>
  8005b9:	eb 5f                	jmp    80061a <runcmd+0x3e4>
  8005bb:	90                   	nop
  8005bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  8005c0:	e8 56 1f 00 00       	call   80251b <close_all>
	if (r >= 0) {
		if (debug)
  8005c5:	83 3d 80 80 80 00 00 	cmpl   $0x0,0x808080
  8005cc:	74 23                	je     8005f1 <runcmd+0x3bb>
			cprintf("[%08x] WAIT %s %08x\n", env->env_id, argv[0], r);
  8005ce:	a1 a0 84 80 00       	mov    0x8084a0,%eax
  8005d3:	8b 40 4c             	mov    0x4c(%eax),%eax
  8005d6:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  8005da:	8b 55 a8             	mov    -0x58(%ebp),%edx
  8005dd:	89 54 24 08          	mov    %edx,0x8(%esp)
  8005e1:	89 44 24 04          	mov    %eax,0x4(%esp)
  8005e5:	c7 04 24 26 3f 80 00 	movl   $0x803f26,(%esp)
  8005ec:	e8 cc 05 00 00       	call   800bbd <cprintf>
		wait(r);
  8005f1:	89 1c 24             	mov    %ebx,(%esp)
  8005f4:	e8 0b 33 00 00       	call   803904 <wait>
		if (debug)
  8005f9:	83 3d 80 80 80 00 00 	cmpl   $0x0,0x808080
  800600:	74 18                	je     80061a <runcmd+0x3e4>
			cprintf("[%08x] wait finished\n", env->env_id);
  800602:	a1 a0 84 80 00       	mov    0x8084a0,%eax
  800607:	8b 40 4c             	mov    0x4c(%eax),%eax
  80060a:	89 44 24 04          	mov    %eax,0x4(%esp)
  80060e:	c7 04 24 3b 3f 80 00 	movl   $0x803f3b,(%esp)
  800615:	e8 a3 05 00 00       	call   800bbd <cprintf>
	}

	// If we were the left-hand part of a pipe,
	// wait for the right-hand part to finish.
	if (pipe_child) {
  80061a:	85 ff                	test   %edi,%edi
  80061c:	74 4e                	je     80066c <runcmd+0x436>
		if (debug)
  80061e:	83 3d 80 80 80 00 00 	cmpl   $0x0,0x808080
  800625:	74 1c                	je     800643 <runcmd+0x40d>
			cprintf("[%08x] WAIT pipe_child %08x\n", env->env_id, pipe_child);
  800627:	a1 a0 84 80 00       	mov    0x8084a0,%eax
  80062c:	8b 40 4c             	mov    0x4c(%eax),%eax
  80062f:	89 7c 24 08          	mov    %edi,0x8(%esp)
  800633:	89 44 24 04          	mov    %eax,0x4(%esp)
  800637:	c7 04 24 51 3f 80 00 	movl   $0x803f51,(%esp)
  80063e:	e8 7a 05 00 00       	call   800bbd <cprintf>
		wait(pipe_child);
  800643:	89 3c 24             	mov    %edi,(%esp)
  800646:	e8 b9 32 00 00       	call   803904 <wait>
		if (debug)
  80064b:	83 3d 80 80 80 00 00 	cmpl   $0x0,0x808080
  800652:	74 18                	je     80066c <runcmd+0x436>
			cprintf("[%08x] wait finished\n", env->env_id);
  800654:	a1 a0 84 80 00       	mov    0x8084a0,%eax
  800659:	8b 40 4c             	mov    0x4c(%eax),%eax
  80065c:	89 44 24 04          	mov    %eax,0x4(%esp)
  800660:	c7 04 24 3b 3f 80 00 	movl   $0x803f3b,(%esp)
  800667:	e8 51 05 00 00       	call   800bbd <cprintf>
	}

	// Done!
	exit();
  80066c:	e8 6b 04 00 00       	call   800adc <exit>
}
  800671:	81 c4 6c 04 00 00    	add    $0x46c,%esp
  800677:	5b                   	pop    %ebx
  800678:	5e                   	pop    %esi
  800679:	5f                   	pop    %edi
  80067a:	5d                   	pop    %ebp
  80067b:	c3                   	ret    

0080067c <umain>:
	exit();
}

void
umain(int argc, char **argv)
{
  80067c:	55                   	push   %ebp
  80067d:	89 e5                	mov    %esp,%ebp
  80067f:	57                   	push   %edi
  800680:	56                   	push   %esi
  800681:	53                   	push   %ebx
  800682:	83 ec 3c             	sub    $0x3c,%esp
  800685:	8b 45 0c             	mov    0xc(%ebp),%eax
	int r, interactive, echocmds;

	interactive = '?';
	echocmds = 0;
	ARGBEGIN{
  800688:	85 c0                	test   %eax,%eax
  80068a:	75 03                	jne    80068f <umain+0x13>
  80068c:	8d 45 08             	lea    0x8(%ebp),%eax
  80068f:	83 3d a4 84 80 00 00 	cmpl   $0x0,0x8084a4
  800696:	75 08                	jne    8006a0 <umain+0x24>
  800698:	8b 10                	mov    (%eax),%edx
  80069a:	89 15 a4 84 80 00    	mov    %edx,0x8084a4
  8006a0:	83 c0 04             	add    $0x4,%eax
  8006a3:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8006a6:	83 6d 08 01          	subl   $0x1,0x8(%ebp)
  8006aa:	8b 18                	mov    (%eax),%ebx
  8006ac:	85 db                	test   %ebx,%ebx
  8006ae:	0f 84 98 00 00 00    	je     80074c <umain+0xd0>
  8006b4:	80 3b 2d             	cmpb   $0x2d,(%ebx)
  8006b7:	0f 85 8f 00 00 00    	jne    80074c <umain+0xd0>
  8006bd:	83 c3 01             	add    $0x1,%ebx
  8006c0:	0f b6 03             	movzbl (%ebx),%eax
  8006c3:	84 c0                	test   %al,%al
  8006c5:	0f 84 81 00 00 00    	je     80074c <umain+0xd0>
  8006cb:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  8006d2:	bf 3f 00 00 00       	mov    $0x3f,%edi
  8006d7:	be 01 00 00 00       	mov    $0x1,%esi
  8006dc:	3c 2d                	cmp    $0x2d,%al
  8006de:	75 21                	jne    800701 <umain+0x85>
  8006e0:	80 7b 01 00          	cmpb   $0x0,0x1(%ebx)
  8006e4:	75 1b                	jne    800701 <umain+0x85>
  8006e6:	83 6d 08 01          	subl   $0x1,0x8(%ebp)
  8006ea:	83 45 e0 04          	addl   $0x4,-0x20(%ebp)
  8006ee:	eb 68                	jmp    800758 <umain+0xdc>
	case 'd':
		debug++;
  8006f0:	83 05 80 80 80 00 01 	addl   $0x1,0x808080
		break;
  8006f7:	eb 05                	jmp    8006fe <umain+0x82>
		break;
	case 'x':
		echocmds = 1;
		break;
	default:
		usage();
  8006f9:	e8 42 f9 ff ff       	call   800040 <usage>
{
	int r, interactive, echocmds;

	interactive = '?';
	echocmds = 0;
	ARGBEGIN{
  8006fe:	83 c3 01             	add    $0x1,%ebx
  800701:	0f b6 03             	movzbl (%ebx),%eax
  800704:	84 c0                	test   %al,%al
  800706:	74 22                	je     80072a <umain+0xae>
  800708:	3c 69                	cmp    $0x69,%al
  80070a:	74 16                	je     800722 <umain+0xa6>
  80070c:	3c 78                	cmp    $0x78,%al
  80070e:	74 0a                	je     80071a <umain+0x9e>
  800710:	3c 64                	cmp    $0x64,%al
  800712:	75 e5                	jne    8006f9 <umain+0x7d>
  800714:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  800718:	eb d6                	jmp    8006f0 <umain+0x74>
  80071a:	89 75 e4             	mov    %esi,-0x1c(%ebp)
  80071d:	8d 76 00             	lea    0x0(%esi),%esi
  800720:	eb dc                	jmp    8006fe <umain+0x82>
  800722:	89 f7                	mov    %esi,%edi
  800724:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  800728:	eb d4                	jmp    8006fe <umain+0x82>
  80072a:	83 6d 08 01          	subl   $0x1,0x8(%ebp)
  80072e:	83 45 e0 04          	addl   $0x4,-0x20(%ebp)
  800732:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800735:	8b 18                	mov    (%eax),%ebx
  800737:	85 db                	test   %ebx,%ebx
  800739:	74 1d                	je     800758 <umain+0xdc>
  80073b:	80 3b 2d             	cmpb   $0x2d,(%ebx)
  80073e:	75 18                	jne    800758 <umain+0xdc>
  800740:	83 c3 01             	add    $0x1,%ebx
  800743:	0f b6 03             	movzbl (%ebx),%eax
  800746:	84 c0                	test   %al,%al
  800748:	75 92                	jne    8006dc <umain+0x60>
  80074a:	eb 0c                	jmp    800758 <umain+0xdc>
  80074c:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  800753:	bf 3f 00 00 00       	mov    $0x3f,%edi
		break;
	default:
		usage();
	}ARGEND

	if (argc > 1)
  800758:	83 7d 08 01          	cmpl   $0x1,0x8(%ebp)
  80075c:	7e 07                	jle    800765 <umain+0xe9>
		usage();
  80075e:	66 90                	xchg   %ax,%ax
  800760:	e8 db f8 ff ff       	call   800040 <usage>
	if (argc == 1) {
  800765:	83 7d 08 01          	cmpl   $0x1,0x8(%ebp)
  800769:	75 76                	jne    8007e1 <umain+0x165>
		close(0);
  80076b:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  800772:	e8 27 1d 00 00       	call   80249e <close>
		if ((r = open(argv[0], O_RDONLY)) < 0)
  800777:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  80077e:	00 
  80077f:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800782:	8b 02                	mov    (%edx),%eax
  800784:	89 04 24             	mov    %eax,(%esp)
  800787:	e8 b7 20 00 00       	call   802843 <open>
  80078c:	85 c0                	test   %eax,%eax
  80078e:	79 29                	jns    8007b9 <umain+0x13d>
			panic("open %s: %e", argv[0], r);
  800790:	89 44 24 10          	mov    %eax,0x10(%esp)
  800794:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800797:	8b 02                	mov    (%edx),%eax
  800799:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80079d:	c7 44 24 08 6e 3f 80 	movl   $0x803f6e,0x8(%esp)
  8007a4:	00 
  8007a5:	c7 44 24 04 1b 01 00 	movl   $0x11b,0x4(%esp)
  8007ac:	00 
  8007ad:	c7 04 24 f1 3e 80 00 	movl   $0x803ef1,(%esp)
  8007b4:	e8 3f 03 00 00       	call   800af8 <_panic>
		assert(r == 0);
  8007b9:	85 c0                	test   %eax,%eax
  8007bb:	74 24                	je     8007e1 <umain+0x165>
  8007bd:	c7 44 24 0c 7a 3f 80 	movl   $0x803f7a,0xc(%esp)
  8007c4:	00 
  8007c5:	c7 44 24 08 81 3f 80 	movl   $0x803f81,0x8(%esp)
  8007cc:	00 
  8007cd:	c7 44 24 04 1c 01 00 	movl   $0x11c,0x4(%esp)
  8007d4:	00 
  8007d5:	c7 04 24 f1 3e 80 00 	movl   $0x803ef1,(%esp)
  8007dc:	e8 17 03 00 00       	call   800af8 <_panic>
	}
	if (interactive == '?')
  8007e1:	83 ff 3f             	cmp    $0x3f,%edi
  8007e4:	75 0e                	jne    8007f4 <umain+0x178>
		interactive = iscons(0);
  8007e6:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8007ed:	e8 34 02 00 00       	call   800a26 <iscons>
  8007f2:	89 c7                	mov    %eax,%edi
	
	while (1) {
		char *buf;

		buf = readline(interactive ? "$ " : NULL);
  8007f4:	83 ff 01             	cmp    $0x1,%edi
  8007f7:	19 c0                	sbb    %eax,%eax
  8007f9:	f7 d0                	not    %eax
  8007fb:	25 96 3f 80 00       	and    $0x803f96,%eax
  800800:	89 04 24             	mov    %eax,(%esp)
  800803:	e8 28 0a 00 00       	call   801230 <readline>
  800808:	89 c3                	mov    %eax,%ebx
		if (buf == NULL) {
  80080a:	85 c0                	test   %eax,%eax
  80080c:	75 1a                	jne    800828 <umain+0x1ac>
			if (debug)
  80080e:	83 3d 80 80 80 00 00 	cmpl   $0x0,0x808080
  800815:	74 0c                	je     800823 <umain+0x1a7>
				cprintf("EXITING\n");
  800817:	c7 04 24 99 3f 80 00 	movl   $0x803f99,(%esp)
  80081e:	e8 9a 03 00 00       	call   800bbd <cprintf>
			exit();	// end of file
  800823:	e8 b4 02 00 00       	call   800adc <exit>
		}
		if (debug)
  800828:	83 3d 80 80 80 00 00 	cmpl   $0x0,0x808080
  80082f:	74 10                	je     800841 <umain+0x1c5>
			cprintf("LINE: %s\n", buf);
  800831:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  800835:	c7 04 24 a2 3f 80 00 	movl   $0x803fa2,(%esp)
  80083c:	e8 7c 03 00 00       	call   800bbd <cprintf>
		if (buf[0] == '#')
  800841:	80 3b 23             	cmpb   $0x23,(%ebx)
  800844:	74 ae                	je     8007f4 <umain+0x178>
			continue;
		if (echocmds)
  800846:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80084a:	74 10                	je     80085c <umain+0x1e0>
			printf("# %s\n", buf);
  80084c:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  800850:	c7 04 24 ac 3f 80 00 	movl   $0x803fac,(%esp)
  800857:	e8 37 21 00 00       	call   802993 <printf>
		if (debug)
  80085c:	83 3d 80 80 80 00 00 	cmpl   $0x0,0x808080
  800863:	74 0c                	je     800871 <umain+0x1f5>
			cprintf("BEFORE FORK\n");
  800865:	c7 04 24 b2 3f 80 00 	movl   $0x803fb2,(%esp)
  80086c:	e8 4c 03 00 00       	call   800bbd <cprintf>
		if ((r = fork()) < 0)
  800871:	e8 6f 15 00 00       	call   801de5 <fork>
  800876:	89 c6                	mov    %eax,%esi
  800878:	85 c0                	test   %eax,%eax
  80087a:	79 20                	jns    80089c <umain+0x220>
			panic("fork: %e", r);
  80087c:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800880:	c7 44 24 08 cc 3e 80 	movl   $0x803ecc,0x8(%esp)
  800887:	00 
  800888:	c7 44 24 04 33 01 00 	movl   $0x133,0x4(%esp)
  80088f:	00 
  800890:	c7 04 24 f1 3e 80 00 	movl   $0x803ef1,(%esp)
  800897:	e8 5c 02 00 00       	call   800af8 <_panic>
		if (debug)
  80089c:	83 3d 80 80 80 00 00 	cmpl   $0x0,0x808080
  8008a3:	74 10                	je     8008b5 <umain+0x239>
			cprintf("FORK: %d\n", r);
  8008a5:	89 44 24 04          	mov    %eax,0x4(%esp)
  8008a9:	c7 04 24 bf 3f 80 00 	movl   $0x803fbf,(%esp)
  8008b0:	e8 08 03 00 00       	call   800bbd <cprintf>
		if (r == 0) {
  8008b5:	85 f6                	test   %esi,%esi
  8008b7:	75 12                	jne    8008cb <umain+0x24f>
			runcmd(buf);
  8008b9:	89 1c 24             	mov    %ebx,(%esp)
  8008bc:	e8 75 f9 ff ff       	call   800236 <runcmd>
			exit();
  8008c1:	e8 16 02 00 00       	call   800adc <exit>
  8008c6:	e9 29 ff ff ff       	jmp    8007f4 <umain+0x178>
		} else
			wait(r);
  8008cb:	89 34 24             	mov    %esi,(%esp)
  8008ce:	66 90                	xchg   %ax,%ax
  8008d0:	e8 2f 30 00 00       	call   803904 <wait>
  8008d5:	e9 1a ff ff ff       	jmp    8007f4 <umain+0x178>
  8008da:	00 00                	add    %al,(%eax)
  8008dc:	00 00                	add    %al,(%eax)
	...

008008e0 <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  8008e0:	55                   	push   %ebp
  8008e1:	89 e5                	mov    %esp,%ebp
	USED(fd);

	return 0;
}
  8008e3:	b8 00 00 00 00       	mov    $0x0,%eax
  8008e8:	5d                   	pop    %ebp
  8008e9:	c3                   	ret    

008008ea <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  8008ea:	55                   	push   %ebp
  8008eb:	89 e5                	mov    %esp,%ebp
  8008ed:	83 ec 18             	sub    $0x18,%esp
	strcpy(stat->st_name, "<cons>");
  8008f0:	c7 44 24 04 c9 3f 80 	movl   $0x803fc9,0x4(%esp)
  8008f7:	00 
  8008f8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8008fb:	89 04 24             	mov    %eax,(%esp)
  8008fe:	e8 67 0a 00 00       	call   80136a <strcpy>
	return 0;
}
  800903:	b8 00 00 00 00       	mov    $0x0,%eax
  800908:	c9                   	leave  
  800909:	c3                   	ret    

0080090a <devcons_write>:
	return 1;
}

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  80090a:	55                   	push   %ebp
  80090b:	89 e5                	mov    %esp,%ebp
  80090d:	57                   	push   %edi
  80090e:	56                   	push   %esi
  80090f:	53                   	push   %ebx
  800910:	81 ec 9c 00 00 00    	sub    $0x9c,%esp
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs, 
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  800916:	b8 00 00 00 00       	mov    $0x0,%eax
  80091b:	be 00 00 00 00       	mov    $0x0,%esi
  800920:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800924:	74 3f                	je     800965 <devcons_write+0x5b>
		m = n - tot;
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  800926:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs, 
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
		m = n - tot;
  80092c:	8b 55 10             	mov    0x10(%ebp),%edx
  80092f:	29 c2                	sub    %eax,%edx
  800931:	89 d3                	mov    %edx,%ebx
		if (m > sizeof(buf) - 1)
  800933:	83 fa 7f             	cmp    $0x7f,%edx
  800936:	76 05                	jbe    80093d <devcons_write+0x33>
  800938:	bb 7f 00 00 00       	mov    $0x7f,%ebx
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  80093d:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  800941:	03 45 0c             	add    0xc(%ebp),%eax
  800944:	89 44 24 04          	mov    %eax,0x4(%esp)
  800948:	89 3c 24             	mov    %edi,(%esp)
  80094b:	e8 d5 0b 00 00       	call   801525 <memmove>
		sys_cputs(buf, m);
  800950:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  800954:	89 3c 24             	mov    %edi,(%esp)
  800957:	e8 04 0e 00 00       	call   801760 <sys_cputs>
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs, 
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  80095c:	01 de                	add    %ebx,%esi
  80095e:	89 f0                	mov    %esi,%eax
  800960:	3b 75 10             	cmp    0x10(%ebp),%esi
  800963:	72 c7                	jb     80092c <devcons_write+0x22>
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
}
  800965:	89 f0                	mov    %esi,%eax
  800967:	81 c4 9c 00 00 00    	add    $0x9c,%esp
  80096d:	5b                   	pop    %ebx
  80096e:	5e                   	pop    %esi
  80096f:	5f                   	pop    %edi
  800970:	5d                   	pop    %ebp
  800971:	c3                   	ret    

00800972 <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  800972:	55                   	push   %ebp
  800973:	89 e5                	mov    %esp,%ebp
  800975:	83 ec 28             	sub    $0x28,%esp
	char c = ch;
  800978:	8b 45 08             	mov    0x8(%ebp),%eax
  80097b:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  80097e:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  800985:	00 
  800986:	8d 45 f7             	lea    -0x9(%ebp),%eax
  800989:	89 04 24             	mov    %eax,(%esp)
  80098c:	e8 cf 0d 00 00       	call   801760 <sys_cputs>
}
  800991:	c9                   	leave  
  800992:	c3                   	ret    

00800993 <devcons_read>:
	return fd2num(fd);
}

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  800993:	55                   	push   %ebp
  800994:	89 e5                	mov    %esp,%ebp
  800996:	83 ec 08             	sub    $0x8,%esp
	int c;

	if (n == 0)
  800999:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80099d:	75 07                	jne    8009a6 <devcons_read+0x13>
  80099f:	eb 28                	jmp    8009c9 <devcons_read+0x36>
		return 0;

	while ((c = sys_cgetc()) == 0)
		sys_yield();
  8009a1:	e8 14 12 00 00       	call   801bba <sys_yield>
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  8009a6:	66 90                	xchg   %ax,%ax
  8009a8:	e8 7f 0d 00 00       	call   80172c <sys_cgetc>
  8009ad:	85 c0                	test   %eax,%eax
  8009af:	90                   	nop
  8009b0:	74 ef                	je     8009a1 <devcons_read+0xe>
  8009b2:	89 c2                	mov    %eax,%edx
		sys_yield();
	if (c < 0)
  8009b4:	85 c0                	test   %eax,%eax
  8009b6:	78 16                	js     8009ce <devcons_read+0x3b>
		return c;
	if (c == 0x04)	// ctl-d is eof
  8009b8:	83 f8 04             	cmp    $0x4,%eax
  8009bb:	74 0c                	je     8009c9 <devcons_read+0x36>
		return 0;
	*(char*)vbuf = c;
  8009bd:	8b 45 0c             	mov    0xc(%ebp),%eax
  8009c0:	88 10                	mov    %dl,(%eax)
  8009c2:	b8 01 00 00 00       	mov    $0x1,%eax
	return 1;
  8009c7:	eb 05                	jmp    8009ce <devcons_read+0x3b>
  8009c9:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8009ce:	c9                   	leave  
  8009cf:	c3                   	ret    

008009d0 <opencons>:
	return fd->fd_dev_id == devcons.dev_id;
}

int
opencons(void)
{
  8009d0:	55                   	push   %ebp
  8009d1:	89 e5                	mov    %esp,%ebp
  8009d3:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  8009d6:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8009d9:	89 04 24             	mov    %eax,(%esp)
  8009dc:	e8 8a 16 00 00       	call   80206b <fd_alloc>
  8009e1:	85 c0                	test   %eax,%eax
  8009e3:	78 3f                	js     800a24 <opencons+0x54>
		return r;
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  8009e5:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  8009ec:	00 
  8009ed:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8009f0:	89 44 24 04          	mov    %eax,0x4(%esp)
  8009f4:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8009fb:	e8 5b 11 00 00       	call   801b5b <sys_page_alloc>
  800a00:	85 c0                	test   %eax,%eax
  800a02:	78 20                	js     800a24 <opencons+0x54>
		return r;
	fd->fd_dev_id = devcons.dev_id;
  800a04:	8b 15 00 80 80 00    	mov    0x808000,%edx
  800a0a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800a0d:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  800a0f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800a12:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  800a19:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800a1c:	89 04 24             	mov    %eax,(%esp)
  800a1f:	e8 1c 16 00 00       	call   802040 <fd2num>
}
  800a24:	c9                   	leave  
  800a25:	c3                   	ret    

00800a26 <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  800a26:	55                   	push   %ebp
  800a27:	89 e5                	mov    %esp,%ebp
  800a29:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  800a2c:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800a2f:	89 44 24 04          	mov    %eax,0x4(%esp)
  800a33:	8b 45 08             	mov    0x8(%ebp),%eax
  800a36:	89 04 24             	mov    %eax,(%esp)
  800a39:	e8 9f 16 00 00       	call   8020dd <fd_lookup>
  800a3e:	85 c0                	test   %eax,%eax
  800a40:	78 11                	js     800a53 <iscons+0x2d>
		return r;
	return fd->fd_dev_id == devcons.dev_id;
  800a42:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800a45:	8b 00                	mov    (%eax),%eax
  800a47:	3b 05 00 80 80 00    	cmp    0x808000,%eax
  800a4d:	0f 94 c0             	sete   %al
  800a50:	0f b6 c0             	movzbl %al,%eax
}
  800a53:	c9                   	leave  
  800a54:	c3                   	ret    

00800a55 <getchar>:
	sys_cputs(&c, 1);
}

int
getchar(void)
{
  800a55:	55                   	push   %ebp
  800a56:	89 e5                	mov    %esp,%ebp
  800a58:	83 ec 28             	sub    $0x28,%esp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  800a5b:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  800a62:	00 
  800a63:	8d 45 f7             	lea    -0x9(%ebp),%eax
  800a66:	89 44 24 04          	mov    %eax,0x4(%esp)
  800a6a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  800a71:	e8 c8 18 00 00       	call   80233e <read>
	if (r < 0)
  800a76:	85 c0                	test   %eax,%eax
  800a78:	78 0f                	js     800a89 <getchar+0x34>
		return r;
	if (r < 1)
  800a7a:	85 c0                	test   %eax,%eax
  800a7c:	7f 07                	jg     800a85 <getchar+0x30>
  800a7e:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  800a83:	eb 04                	jmp    800a89 <getchar+0x34>
		return -E_EOF;
	return c;
  800a85:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  800a89:	c9                   	leave  
  800a8a:	c3                   	ret    
	...

00800a8c <libmain>:
volatile struct Env *env;
char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  800a8c:	55                   	push   %ebp
  800a8d:	89 e5                	mov    %esp,%ebp
  800a8f:	83 ec 18             	sub    $0x18,%esp
  800a92:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  800a95:	89 75 fc             	mov    %esi,-0x4(%ebp)
  800a98:	8b 75 08             	mov    0x8(%ebp),%esi
  800a9b:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	// set env to point at our env structure in envs[].
	// LAB 3b: Your code here.
	// Code added by Swastika / Sandeep	
	envid_t envid = sys_getenvid();
  800a9e:	e8 4b 11 00 00       	call   801bee <sys_getenvid>
	env = &envs[ENVX(envid)];
  800aa3:	25 ff 03 00 00       	and    $0x3ff,%eax
  800aa8:	6b c0 7c             	imul   $0x7c,%eax,%eax
  800aab:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800ab0:	a3 a0 84 80 00       	mov    %eax,0x8084a0

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800ab5:	85 f6                	test   %esi,%esi
  800ab7:	7e 07                	jle    800ac0 <libmain+0x34>
		binaryname = argv[0];
  800ab9:	8b 03                	mov    (%ebx),%eax
  800abb:	a3 1c 80 80 00       	mov    %eax,0x80801c

	// call user main routine
	umain(argc, argv);
  800ac0:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  800ac4:	89 34 24             	mov    %esi,(%esp)
  800ac7:	e8 b0 fb ff ff       	call   80067c <umain>

	// exit gracefully
	exit();
  800acc:	e8 0b 00 00 00       	call   800adc <exit>
}
  800ad1:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  800ad4:	8b 75 fc             	mov    -0x4(%ebp),%esi
  800ad7:	89 ec                	mov    %ebp,%esp
  800ad9:	5d                   	pop    %ebp
  800ada:	c3                   	ret    
	...

00800adc <exit>:
#include <inc/lib.h>

void
exit(void)
{
  800adc:	55                   	push   %ebp
  800add:	89 e5                	mov    %esp,%ebp
  800adf:	83 ec 18             	sub    $0x18,%esp
	close_all();
  800ae2:	e8 34 1a 00 00       	call   80251b <close_all>
	sys_env_destroy(0);
  800ae7:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  800aee:	e8 2f 11 00 00       	call   801c22 <sys_env_destroy>
}
  800af3:	c9                   	leave  
  800af4:	c3                   	ret    
  800af5:	00 00                	add    %al,(%eax)
	...

00800af8 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  800af8:	55                   	push   %ebp
  800af9:	89 e5                	mov    %esp,%ebp
  800afb:	53                   	push   %ebx
  800afc:	83 ec 14             	sub    $0x14,%esp
 * Panic is called on unresolvable fatal errors.
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
  800aff:	8d 5d 14             	lea    0x14(%ebp),%ebx
	va_list ap;

	va_start(ap, fmt);

	// Print the panic message
	if (argv0)
  800b02:	a1 a4 84 80 00       	mov    0x8084a4,%eax
  800b07:	85 c0                	test   %eax,%eax
  800b09:	74 10                	je     800b1b <_panic+0x23>
		cprintf("%s: ", argv0);
  800b0b:	89 44 24 04          	mov    %eax,0x4(%esp)
  800b0f:	c7 04 24 ec 3f 80 00 	movl   $0x803fec,(%esp)
  800b16:	e8 a2 00 00 00       	call   800bbd <cprintf>
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  800b1b:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b1e:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800b22:	8b 45 08             	mov    0x8(%ebp),%eax
  800b25:	89 44 24 08          	mov    %eax,0x8(%esp)
  800b29:	a1 1c 80 80 00       	mov    0x80801c,%eax
  800b2e:	89 44 24 04          	mov    %eax,0x4(%esp)
  800b32:	c7 04 24 f1 3f 80 00 	movl   $0x803ff1,(%esp)
  800b39:	e8 7f 00 00 00       	call   800bbd <cprintf>
	vcprintf(fmt, ap);
  800b3e:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  800b42:	8b 45 10             	mov    0x10(%ebp),%eax
  800b45:	89 04 24             	mov    %eax,(%esp)
  800b48:	e8 0f 00 00 00       	call   800b5c <vcprintf>
	cprintf("\n");
  800b4d:	c7 04 24 52 3e 80 00 	movl   $0x803e52,(%esp)
  800b54:	e8 64 00 00 00       	call   800bbd <cprintf>

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  800b59:	cc                   	int3   
  800b5a:	eb fd                	jmp    800b59 <_panic+0x61>

00800b5c <vcprintf>:
	b->cnt++;
}

int
vcprintf(const char *fmt, va_list ap)
{
  800b5c:	55                   	push   %ebp
  800b5d:	89 e5                	mov    %esp,%ebp
  800b5f:	81 ec 28 01 00 00    	sub    $0x128,%esp
	struct printbuf b;

	b.idx = 0;
  800b65:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800b6c:	00 00 00 
	b.cnt = 0;
  800b6f:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800b76:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  800b79:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b7c:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800b80:	8b 45 08             	mov    0x8(%ebp),%eax
  800b83:	89 44 24 08          	mov    %eax,0x8(%esp)
  800b87:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800b8d:	89 44 24 04          	mov    %eax,0x4(%esp)
  800b91:	c7 04 24 d7 0b 80 00 	movl   $0x800bd7,(%esp)
  800b98:	e8 d0 01 00 00       	call   800d6d <vprintfmt>
	sys_cputs(b.buf, b.idx);
  800b9d:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
  800ba3:	89 44 24 04          	mov    %eax,0x4(%esp)
  800ba7:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  800bad:	89 04 24             	mov    %eax,(%esp)
  800bb0:	e8 ab 0b 00 00       	call   801760 <sys_cputs>

	return b.cnt;
}
  800bb5:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  800bbb:	c9                   	leave  
  800bbc:	c3                   	ret    

00800bbd <cprintf>:

int
cprintf(const char *fmt, ...)
{
  800bbd:	55                   	push   %ebp
  800bbe:	89 e5                	mov    %esp,%ebp
  800bc0:	83 ec 18             	sub    $0x18,%esp

	return b.cnt;
}

int
cprintf(const char *fmt, ...)
  800bc3:	8d 45 0c             	lea    0xc(%ebp),%eax
{
	va_list ap;
	int cnt;

	va_start(ap, fmt);
	cnt = vcprintf(fmt, ap);
  800bc6:	89 44 24 04          	mov    %eax,0x4(%esp)
  800bca:	8b 45 08             	mov    0x8(%ebp),%eax
  800bcd:	89 04 24             	mov    %eax,(%esp)
  800bd0:	e8 87 ff ff ff       	call   800b5c <vcprintf>
	va_end(ap);

	return cnt;
}
  800bd5:	c9                   	leave  
  800bd6:	c3                   	ret    

00800bd7 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  800bd7:	55                   	push   %ebp
  800bd8:	89 e5                	mov    %esp,%ebp
  800bda:	53                   	push   %ebx
  800bdb:	83 ec 14             	sub    $0x14,%esp
  800bde:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  800be1:	8b 03                	mov    (%ebx),%eax
  800be3:	8b 55 08             	mov    0x8(%ebp),%edx
  800be6:	88 54 03 08          	mov    %dl,0x8(%ebx,%eax,1)
  800bea:	83 c0 01             	add    $0x1,%eax
  800bed:	89 03                	mov    %eax,(%ebx)
	if (b->idx == 256-1) {
  800bef:	3d ff 00 00 00       	cmp    $0xff,%eax
  800bf4:	75 19                	jne    800c0f <putch+0x38>
		sys_cputs(b->buf, b->idx);
  800bf6:	c7 44 24 04 ff 00 00 	movl   $0xff,0x4(%esp)
  800bfd:	00 
  800bfe:	8d 43 08             	lea    0x8(%ebx),%eax
  800c01:	89 04 24             	mov    %eax,(%esp)
  800c04:	e8 57 0b 00 00       	call   801760 <sys_cputs>
		b->idx = 0;
  800c09:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
	}
	b->cnt++;
  800c0f:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  800c13:	83 c4 14             	add    $0x14,%esp
  800c16:	5b                   	pop    %ebx
  800c17:	5d                   	pop    %ebp
  800c18:	c3                   	ret    
  800c19:	00 00                	add    %al,(%eax)
  800c1b:	00 00                	add    %al,(%eax)
  800c1d:	00 00                	add    %al,(%eax)
	...

00800c20 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800c20:	55                   	push   %ebp
  800c21:	89 e5                	mov    %esp,%ebp
  800c23:	57                   	push   %edi
  800c24:	56                   	push   %esi
  800c25:	53                   	push   %ebx
  800c26:	83 ec 4c             	sub    $0x4c,%esp
  800c29:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800c2c:	89 d6                	mov    %edx,%esi
  800c2e:	8b 45 08             	mov    0x8(%ebp),%eax
  800c31:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800c34:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c37:	89 55 e0             	mov    %edx,-0x20(%ebp)
  800c3a:	8b 45 10             	mov    0x10(%ebp),%eax
  800c3d:	8b 5d 14             	mov    0x14(%ebp),%ebx
  800c40:	8b 7d 18             	mov    0x18(%ebp),%edi
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800c43:	89 45 dc             	mov    %eax,-0x24(%ebp)
  800c46:	b9 00 00 00 00       	mov    $0x0,%ecx
  800c4b:	39 d1                	cmp    %edx,%ecx
  800c4d:	72 15                	jb     800c64 <printnum+0x44>
  800c4f:	77 07                	ja     800c58 <printnum+0x38>
  800c51:	8b 55 d8             	mov    -0x28(%ebp),%edx
  800c54:	39 d0                	cmp    %edx,%eax
  800c56:	76 0c                	jbe    800c64 <printnum+0x44>
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800c58:	83 eb 01             	sub    $0x1,%ebx
  800c5b:	85 db                	test   %ebx,%ebx
  800c5d:	8d 76 00             	lea    0x0(%esi),%esi
  800c60:	7f 61                	jg     800cc3 <printnum+0xa3>
  800c62:	eb 70                	jmp    800cd4 <printnum+0xb4>
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800c64:	89 7c 24 10          	mov    %edi,0x10(%esp)
  800c68:	83 eb 01             	sub    $0x1,%ebx
  800c6b:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  800c6f:	89 44 24 08          	mov    %eax,0x8(%esp)
  800c73:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  800c77:	8b 5c 24 0c          	mov    0xc(%esp),%ebx
  800c7b:	89 4d d0             	mov    %ecx,-0x30(%ebp)
  800c7e:	89 5d d4             	mov    %ebx,-0x2c(%ebp)
  800c81:	8b 5d dc             	mov    -0x24(%ebp),%ebx
  800c84:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  800c88:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  800c8f:	00 
  800c90:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800c93:	89 04 24             	mov    %eax,(%esp)
  800c96:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800c99:	89 54 24 04          	mov    %edx,0x4(%esp)
  800c9d:	e8 ae 2e 00 00       	call   803b50 <__udivdi3>
  800ca2:	8b 4d d0             	mov    -0x30(%ebp),%ecx
  800ca5:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
  800ca8:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  800cac:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  800cb0:	89 04 24             	mov    %eax,(%esp)
  800cb3:	89 54 24 04          	mov    %edx,0x4(%esp)
  800cb7:	89 f2                	mov    %esi,%edx
  800cb9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800cbc:	e8 5f ff ff ff       	call   800c20 <printnum>
  800cc1:	eb 11                	jmp    800cd4 <printnum+0xb4>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800cc3:	89 74 24 04          	mov    %esi,0x4(%esp)
  800cc7:	89 3c 24             	mov    %edi,(%esp)
  800cca:	ff 55 e4             	call   *-0x1c(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800ccd:	83 eb 01             	sub    $0x1,%ebx
  800cd0:	85 db                	test   %ebx,%ebx
  800cd2:	7f ef                	jg     800cc3 <printnum+0xa3>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800cd4:	89 74 24 04          	mov    %esi,0x4(%esp)
  800cd8:	8b 74 24 04          	mov    0x4(%esp),%esi
  800cdc:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800cdf:	89 44 24 08          	mov    %eax,0x8(%esp)
  800ce3:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  800cea:	00 
  800ceb:	8b 55 d8             	mov    -0x28(%ebp),%edx
  800cee:	89 14 24             	mov    %edx,(%esp)
  800cf1:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  800cf4:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  800cf8:	e8 83 2f 00 00       	call   803c80 <__umoddi3>
  800cfd:	89 74 24 04          	mov    %esi,0x4(%esp)
  800d01:	0f be 80 0d 40 80 00 	movsbl 0x80400d(%eax),%eax
  800d08:	89 04 24             	mov    %eax,(%esp)
  800d0b:	ff 55 e4             	call   *-0x1c(%ebp)
}
  800d0e:	83 c4 4c             	add    $0x4c,%esp
  800d11:	5b                   	pop    %ebx
  800d12:	5e                   	pop    %esi
  800d13:	5f                   	pop    %edi
  800d14:	5d                   	pop    %ebp
  800d15:	c3                   	ret    

00800d16 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800d16:	55                   	push   %ebp
  800d17:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800d19:	83 fa 01             	cmp    $0x1,%edx
  800d1c:	7e 0e                	jle    800d2c <getuint+0x16>
		return va_arg(*ap, unsigned long long);
  800d1e:	8b 10                	mov    (%eax),%edx
  800d20:	8d 4a 08             	lea    0x8(%edx),%ecx
  800d23:	89 08                	mov    %ecx,(%eax)
  800d25:	8b 02                	mov    (%edx),%eax
  800d27:	8b 52 04             	mov    0x4(%edx),%edx
  800d2a:	eb 22                	jmp    800d4e <getuint+0x38>
	else if (lflag)
  800d2c:	85 d2                	test   %edx,%edx
  800d2e:	74 10                	je     800d40 <getuint+0x2a>
		return va_arg(*ap, unsigned long);
  800d30:	8b 10                	mov    (%eax),%edx
  800d32:	8d 4a 04             	lea    0x4(%edx),%ecx
  800d35:	89 08                	mov    %ecx,(%eax)
  800d37:	8b 02                	mov    (%edx),%eax
  800d39:	ba 00 00 00 00       	mov    $0x0,%edx
  800d3e:	eb 0e                	jmp    800d4e <getuint+0x38>
	else
		return va_arg(*ap, unsigned int);
  800d40:	8b 10                	mov    (%eax),%edx
  800d42:	8d 4a 04             	lea    0x4(%edx),%ecx
  800d45:	89 08                	mov    %ecx,(%eax)
  800d47:	8b 02                	mov    (%edx),%eax
  800d49:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800d4e:	5d                   	pop    %ebp
  800d4f:	c3                   	ret    

00800d50 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800d50:	55                   	push   %ebp
  800d51:	89 e5                	mov    %esp,%ebp
  800d53:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  800d56:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  800d5a:	8b 10                	mov    (%eax),%edx
  800d5c:	3b 50 04             	cmp    0x4(%eax),%edx
  800d5f:	73 0a                	jae    800d6b <sprintputch+0x1b>
		*b->buf++ = ch;
  800d61:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800d64:	88 0a                	mov    %cl,(%edx)
  800d66:	83 c2 01             	add    $0x1,%edx
  800d69:	89 10                	mov    %edx,(%eax)
}
  800d6b:	5d                   	pop    %ebp
  800d6c:	c3                   	ret    

00800d6d <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800d6d:	55                   	push   %ebp
  800d6e:	89 e5                	mov    %esp,%ebp
  800d70:	57                   	push   %edi
  800d71:	56                   	push   %esi
  800d72:	53                   	push   %ebx
  800d73:	83 ec 5c             	sub    $0x5c,%esp
  800d76:	8b 7d 08             	mov    0x8(%ebp),%edi
  800d79:	8b 75 0c             	mov    0xc(%ebp),%esi
  800d7c:	8b 5d 10             	mov    0x10(%ebp),%ebx
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800d7f:	c7 45 c8 ff ff ff ff 	movl   $0xffffffff,-0x38(%ebp)
  800d86:	eb 11                	jmp    800d99 <vprintfmt+0x2c>
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
  800d88:	85 c0                	test   %eax,%eax
  800d8a:	0f 84 ec 03 00 00    	je     80117c <vprintfmt+0x40f>
				return;
			putch(ch, putdat);
  800d90:	89 74 24 04          	mov    %esi,0x4(%esp)
  800d94:	89 04 24             	mov    %eax,(%esp)
  800d97:	ff d7                	call   *%edi
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800d99:	0f b6 03             	movzbl (%ebx),%eax
  800d9c:	83 c3 01             	add    $0x1,%ebx
  800d9f:	83 f8 25             	cmp    $0x25,%eax
  800da2:	75 e4                	jne    800d88 <vprintfmt+0x1b>
  800da4:	c6 45 d4 20          	movb   $0x20,-0x2c(%ebp)
  800da8:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
  800daf:	c7 45 d0 ff ff ff ff 	movl   $0xffffffff,-0x30(%ebp)
  800db6:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
  800dbd:	b9 00 00 00 00       	mov    $0x0,%ecx
  800dc2:	eb 06                	jmp    800dca <vprintfmt+0x5d>
  800dc4:	c6 45 d4 2d          	movb   $0x2d,-0x2c(%ebp)
  800dc8:	89 c3                	mov    %eax,%ebx
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800dca:	0f b6 13             	movzbl (%ebx),%edx
  800dcd:	0f b6 c2             	movzbl %dl,%eax
  800dd0:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800dd3:	8d 43 01             	lea    0x1(%ebx),%eax
  800dd6:	83 ea 23             	sub    $0x23,%edx
  800dd9:	80 fa 55             	cmp    $0x55,%dl
  800ddc:	0f 87 7d 03 00 00    	ja     80115f <vprintfmt+0x3f2>
  800de2:	0f b6 d2             	movzbl %dl,%edx
  800de5:	ff 24 95 40 41 80 00 	jmp    *0x804140(,%edx,4)
  800dec:	c6 45 d4 30          	movb   $0x30,-0x2c(%ebp)
  800df0:	eb d6                	jmp    800dc8 <vprintfmt+0x5b>
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
				precision = precision * 10 + ch - '0';
  800df2:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800df5:	83 ea 30             	sub    $0x30,%edx
  800df8:	89 55 d0             	mov    %edx,-0x30(%ebp)
				ch = *fmt;
  800dfb:	0f be 10             	movsbl (%eax),%edx
				if (ch < '0' || ch > '9')
  800dfe:	8d 5a d0             	lea    -0x30(%edx),%ebx
  800e01:	83 fb 09             	cmp    $0x9,%ebx
  800e04:	77 4c                	ja     800e52 <vprintfmt+0xe5>
  800e06:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  800e09:	8b 4d d0             	mov    -0x30(%ebp),%ecx
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800e0c:	83 c0 01             	add    $0x1,%eax
				precision = precision * 10 + ch - '0';
  800e0f:	8d 0c 89             	lea    (%ecx,%ecx,4),%ecx
  800e12:	8d 4c 4a d0          	lea    -0x30(%edx,%ecx,2),%ecx
				ch = *fmt;
  800e16:	0f be 10             	movsbl (%eax),%edx
				if (ch < '0' || ch > '9')
  800e19:	8d 5a d0             	lea    -0x30(%edx),%ebx
  800e1c:	83 fb 09             	cmp    $0x9,%ebx
  800e1f:	76 eb                	jbe    800e0c <vprintfmt+0x9f>
  800e21:	89 4d d0             	mov    %ecx,-0x30(%ebp)
  800e24:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  800e27:	eb 29                	jmp    800e52 <vprintfmt+0xe5>
					break;
			}
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800e29:	8b 55 14             	mov    0x14(%ebp),%edx
  800e2c:	8d 5a 04             	lea    0x4(%edx),%ebx
  800e2f:	89 5d 14             	mov    %ebx,0x14(%ebp)
  800e32:	8b 12                	mov    (%edx),%edx
  800e34:	89 55 d0             	mov    %edx,-0x30(%ebp)
			goto process_precision;
  800e37:	eb 19                	jmp    800e52 <vprintfmt+0xe5>

		case '.':
			if (width < 0)
  800e39:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  800e3c:	c1 fa 1f             	sar    $0x1f,%edx
  800e3f:	f7 d2                	not    %edx
  800e41:	21 55 e4             	and    %edx,-0x1c(%ebp)
  800e44:	eb 82                	jmp    800dc8 <vprintfmt+0x5b>
  800e46:	c7 45 d8 01 00 00 00 	movl   $0x1,-0x28(%ebp)
				width = 0;
			goto reswitch;

		case '#':
			altflag = 1;
			goto reswitch;
  800e4d:	e9 76 ff ff ff       	jmp    800dc8 <vprintfmt+0x5b>

		process_precision:
			if (width < 0)
  800e52:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800e56:	0f 89 6c ff ff ff    	jns    800dc8 <vprintfmt+0x5b>
  800e5c:	8b 55 d0             	mov    -0x30(%ebp),%edx
  800e5f:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  800e62:	8b 55 c8             	mov    -0x38(%ebp),%edx
  800e65:	89 55 d0             	mov    %edx,-0x30(%ebp)
  800e68:	e9 5b ff ff ff       	jmp    800dc8 <vprintfmt+0x5b>
				width = precision, precision = -1;
			goto reswitch;

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800e6d:	83 c1 01             	add    $0x1,%ecx
			goto reswitch;
  800e70:	e9 53 ff ff ff       	jmp    800dc8 <vprintfmt+0x5b>
  800e75:	89 45 cc             	mov    %eax,-0x34(%ebp)

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800e78:	8b 45 14             	mov    0x14(%ebp),%eax
  800e7b:	8d 50 04             	lea    0x4(%eax),%edx
  800e7e:	89 55 14             	mov    %edx,0x14(%ebp)
  800e81:	89 74 24 04          	mov    %esi,0x4(%esp)
  800e85:	8b 00                	mov    (%eax),%eax
  800e87:	89 04 24             	mov    %eax,(%esp)
  800e8a:	ff d7                	call   *%edi
  800e8c:	8b 5d cc             	mov    -0x34(%ebp),%ebx
			break;
  800e8f:	e9 05 ff ff ff       	jmp    800d99 <vprintfmt+0x2c>
  800e94:	89 45 cc             	mov    %eax,-0x34(%ebp)

		// error message
		case 'e':
			err = va_arg(ap, int);
  800e97:	8b 45 14             	mov    0x14(%ebp),%eax
  800e9a:	8d 50 04             	lea    0x4(%eax),%edx
  800e9d:	89 55 14             	mov    %edx,0x14(%ebp)
  800ea0:	8b 00                	mov    (%eax),%eax
  800ea2:	89 c2                	mov    %eax,%edx
  800ea4:	c1 fa 1f             	sar    $0x1f,%edx
  800ea7:	31 d0                	xor    %edx,%eax
  800ea9:	29 d0                	sub    %edx,%eax
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800eab:	83 f8 0f             	cmp    $0xf,%eax
  800eae:	7f 0b                	jg     800ebb <vprintfmt+0x14e>
  800eb0:	8b 14 85 a0 42 80 00 	mov    0x8042a0(,%eax,4),%edx
  800eb7:	85 d2                	test   %edx,%edx
  800eb9:	75 20                	jne    800edb <vprintfmt+0x16e>
				printfmt(putch, putdat, "error %d", err);
  800ebb:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800ebf:	c7 44 24 08 1e 40 80 	movl   $0x80401e,0x8(%esp)
  800ec6:	00 
  800ec7:	89 74 24 04          	mov    %esi,0x4(%esp)
  800ecb:	89 3c 24             	mov    %edi,(%esp)
  800ece:	e8 31 03 00 00       	call   801204 <printfmt>
  800ed3:	8b 5d cc             	mov    -0x34(%ebp),%ebx
		// error message
		case 'e':
			err = va_arg(ap, int);
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800ed6:	e9 be fe ff ff       	jmp    800d99 <vprintfmt+0x2c>
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800edb:	89 54 24 0c          	mov    %edx,0xc(%esp)
  800edf:	c7 44 24 08 93 3f 80 	movl   $0x803f93,0x8(%esp)
  800ee6:	00 
  800ee7:	89 74 24 04          	mov    %esi,0x4(%esp)
  800eeb:	89 3c 24             	mov    %edi,(%esp)
  800eee:	e8 11 03 00 00       	call   801204 <printfmt>
  800ef3:	8b 5d cc             	mov    -0x34(%ebp),%ebx
  800ef6:	e9 9e fe ff ff       	jmp    800d99 <vprintfmt+0x2c>
  800efb:	89 45 cc             	mov    %eax,-0x34(%ebp)
  800efe:	89 c3                	mov    %eax,%ebx
  800f00:	8b 4d d0             	mov    -0x30(%ebp),%ecx
  800f03:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800f06:	89 45 c4             	mov    %eax,-0x3c(%ebp)
			break;

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800f09:	8b 45 14             	mov    0x14(%ebp),%eax
  800f0c:	8d 50 04             	lea    0x4(%eax),%edx
  800f0f:	89 55 14             	mov    %edx,0x14(%ebp)
  800f12:	8b 00                	mov    (%eax),%eax
  800f14:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800f17:	85 c0                	test   %eax,%eax
  800f19:	75 07                	jne    800f22 <vprintfmt+0x1b5>
  800f1b:	c7 45 e0 27 40 80 00 	movl   $0x804027,-0x20(%ebp)
				p = "(null)";
			if (width > 0 && padc != '-')
  800f22:	83 7d c4 00          	cmpl   $0x0,-0x3c(%ebp)
  800f26:	7e 06                	jle    800f2e <vprintfmt+0x1c1>
  800f28:	80 7d d4 2d          	cmpb   $0x2d,-0x2c(%ebp)
  800f2c:	75 13                	jne    800f41 <vprintfmt+0x1d4>
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800f2e:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800f31:	0f be 02             	movsbl (%edx),%eax
  800f34:	85 c0                	test   %eax,%eax
  800f36:	0f 85 99 00 00 00    	jne    800fd5 <vprintfmt+0x268>
  800f3c:	e9 86 00 00 00       	jmp    800fc7 <vprintfmt+0x25a>
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800f41:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  800f45:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  800f48:	89 0c 24             	mov    %ecx,(%esp)
  800f4b:	e8 eb 03 00 00       	call   80133b <strnlen>
  800f50:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  800f53:	29 c2                	sub    %eax,%edx
  800f55:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  800f58:	85 d2                	test   %edx,%edx
  800f5a:	7e d2                	jle    800f2e <vprintfmt+0x1c1>
					putch(padc, putdat);
  800f5c:	0f be 4d d4          	movsbl -0x2c(%ebp),%ecx
  800f60:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  800f63:	89 5d c4             	mov    %ebx,-0x3c(%ebp)
  800f66:	89 d3                	mov    %edx,%ebx
  800f68:	89 74 24 04          	mov    %esi,0x4(%esp)
  800f6c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800f6f:	89 04 24             	mov    %eax,(%esp)
  800f72:	ff d7                	call   *%edi
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800f74:	83 eb 01             	sub    $0x1,%ebx
  800f77:	85 db                	test   %ebx,%ebx
  800f79:	7f ed                	jg     800f68 <vprintfmt+0x1fb>
  800f7b:	8b 5d c4             	mov    -0x3c(%ebp),%ebx
  800f7e:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  800f85:	eb a7                	jmp    800f2e <vprintfmt+0x1c1>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
  800f87:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  800f8b:	74 18                	je     800fa5 <vprintfmt+0x238>
  800f8d:	8d 50 e0             	lea    -0x20(%eax),%edx
  800f90:	83 fa 5e             	cmp    $0x5e,%edx
  800f93:	76 10                	jbe    800fa5 <vprintfmt+0x238>
					putch('?', putdat);
  800f95:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800f99:	c7 04 24 3f 00 00 00 	movl   $0x3f,(%esp)
  800fa0:	ff 55 e0             	call   *-0x20(%ebp)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
  800fa3:	eb 0a                	jmp    800faf <vprintfmt+0x242>
					putch('?', putdat);
				else
					putch(ch, putdat);
  800fa5:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800fa9:	89 04 24             	mov    %eax,(%esp)
  800fac:	ff 55 e0             	call   *-0x20(%ebp)
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800faf:	83 6d e4 01          	subl   $0x1,-0x1c(%ebp)
  800fb3:	0f be 03             	movsbl (%ebx),%eax
  800fb6:	85 c0                	test   %eax,%eax
  800fb8:	74 05                	je     800fbf <vprintfmt+0x252>
  800fba:	83 c3 01             	add    $0x1,%ebx
  800fbd:	eb 29                	jmp    800fe8 <vprintfmt+0x27b>
  800fbf:	89 fe                	mov    %edi,%esi
  800fc1:	8b 7d e0             	mov    -0x20(%ebp),%edi
  800fc4:	8b 5d d0             	mov    -0x30(%ebp),%ebx
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800fc7:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800fcb:	7f 2e                	jg     800ffb <vprintfmt+0x28e>
  800fcd:	8b 5d cc             	mov    -0x34(%ebp),%ebx
  800fd0:	e9 c4 fd ff ff       	jmp    800d99 <vprintfmt+0x2c>
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800fd5:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800fd8:	83 c2 01             	add    $0x1,%edx
  800fdb:	89 7d e0             	mov    %edi,-0x20(%ebp)
  800fde:	89 f7                	mov    %esi,%edi
  800fe0:	8b 75 d0             	mov    -0x30(%ebp),%esi
  800fe3:	89 5d d0             	mov    %ebx,-0x30(%ebp)
  800fe6:	89 d3                	mov    %edx,%ebx
  800fe8:	85 f6                	test   %esi,%esi
  800fea:	78 9b                	js     800f87 <vprintfmt+0x21a>
  800fec:	83 ee 01             	sub    $0x1,%esi
  800fef:	79 96                	jns    800f87 <vprintfmt+0x21a>
  800ff1:	89 fe                	mov    %edi,%esi
  800ff3:	8b 7d e0             	mov    -0x20(%ebp),%edi
  800ff6:	8b 5d d0             	mov    -0x30(%ebp),%ebx
  800ff9:	eb cc                	jmp    800fc7 <vprintfmt+0x25a>
  800ffb:	89 5d d8             	mov    %ebx,-0x28(%ebp)
  800ffe:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
				putch(' ', putdat);
  801001:	89 74 24 04          	mov    %esi,0x4(%esp)
  801005:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  80100c:	ff d7                	call   *%edi
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  80100e:	83 eb 01             	sub    $0x1,%ebx
  801011:	85 db                	test   %ebx,%ebx
  801013:	7f ec                	jg     801001 <vprintfmt+0x294>
  801015:	8b 5d d8             	mov    -0x28(%ebp),%ebx
  801018:	e9 7c fd ff ff       	jmp    800d99 <vprintfmt+0x2c>
  80101d:	89 45 cc             	mov    %eax,-0x34(%ebp)
// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
	if (lflag >= 2)
  801020:	83 f9 01             	cmp    $0x1,%ecx
  801023:	7e 16                	jle    80103b <vprintfmt+0x2ce>
		return va_arg(*ap, long long);
  801025:	8b 45 14             	mov    0x14(%ebp),%eax
  801028:	8d 50 08             	lea    0x8(%eax),%edx
  80102b:	89 55 14             	mov    %edx,0x14(%ebp)
  80102e:	8b 10                	mov    (%eax),%edx
  801030:	8b 48 04             	mov    0x4(%eax),%ecx
  801033:	89 55 d8             	mov    %edx,-0x28(%ebp)
  801036:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  801039:	eb 32                	jmp    80106d <vprintfmt+0x300>
	else if (lflag)
  80103b:	85 c9                	test   %ecx,%ecx
  80103d:	74 18                	je     801057 <vprintfmt+0x2ea>
		return va_arg(*ap, long);
  80103f:	8b 45 14             	mov    0x14(%ebp),%eax
  801042:	8d 50 04             	lea    0x4(%eax),%edx
  801045:	89 55 14             	mov    %edx,0x14(%ebp)
  801048:	8b 00                	mov    (%eax),%eax
  80104a:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80104d:	89 c1                	mov    %eax,%ecx
  80104f:	c1 f9 1f             	sar    $0x1f,%ecx
  801052:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  801055:	eb 16                	jmp    80106d <vprintfmt+0x300>
	else
		return va_arg(*ap, int);
  801057:	8b 45 14             	mov    0x14(%ebp),%eax
  80105a:	8d 50 04             	lea    0x4(%eax),%edx
  80105d:	89 55 14             	mov    %edx,0x14(%ebp)
  801060:	8b 00                	mov    (%eax),%eax
  801062:	89 45 d8             	mov    %eax,-0x28(%ebp)
  801065:	89 c2                	mov    %eax,%edx
  801067:	c1 fa 1f             	sar    $0x1f,%edx
  80106a:	89 55 dc             	mov    %edx,-0x24(%ebp)
				putch(' ', putdat);
			break;

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  80106d:	8b 4d d8             	mov    -0x28(%ebp),%ecx
  801070:	8b 5d dc             	mov    -0x24(%ebp),%ebx
  801073:	b8 0a 00 00 00       	mov    $0xa,%eax
			if ((long long) num < 0) {
  801078:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  80107c:	0f 89 9b 00 00 00    	jns    80111d <vprintfmt+0x3b0>
				putch('-', putdat);
  801082:	89 74 24 04          	mov    %esi,0x4(%esp)
  801086:	c7 04 24 2d 00 00 00 	movl   $0x2d,(%esp)
  80108d:	ff d7                	call   *%edi
				num = -(long long) num;
  80108f:	8b 4d d8             	mov    -0x28(%ebp),%ecx
  801092:	8b 5d dc             	mov    -0x24(%ebp),%ebx
  801095:	f7 d9                	neg    %ecx
  801097:	83 d3 00             	adc    $0x0,%ebx
  80109a:	f7 db                	neg    %ebx
  80109c:	b8 0a 00 00 00       	mov    $0xa,%eax
  8010a1:	eb 7a                	jmp    80111d <vprintfmt+0x3b0>
  8010a3:	89 45 cc             	mov    %eax,-0x34(%ebp)
			base = 10;
			goto number;

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  8010a6:	89 ca                	mov    %ecx,%edx
  8010a8:	8d 45 14             	lea    0x14(%ebp),%eax
  8010ab:	e8 66 fc ff ff       	call   800d16 <getuint>
  8010b0:	89 c1                	mov    %eax,%ecx
  8010b2:	89 d3                	mov    %edx,%ebx
  8010b4:	b8 0a 00 00 00       	mov    $0xa,%eax
			base = 10;
			goto number;
  8010b9:	eb 62                	jmp    80111d <vprintfmt+0x3b0>
  8010bb:	89 45 cc             	mov    %eax,-0x34(%ebp)
		case 'o':
			// Replace this with your code.
			// putch('X', putdat);
			// putch('X', putdat);
			// putch('X', putdat);
			num = getuint(&ap, lflag);
  8010be:	89 ca                	mov    %ecx,%edx
  8010c0:	8d 45 14             	lea    0x14(%ebp),%eax
  8010c3:	e8 4e fc ff ff       	call   800d16 <getuint>
  8010c8:	89 c1                	mov    %eax,%ecx
  8010ca:	89 d3                	mov    %edx,%ebx
  8010cc:	b8 08 00 00 00       	mov    $0x8,%eax
			base = 8;
			goto number;
  8010d1:	eb 4a                	jmp    80111d <vprintfmt+0x3b0>
  8010d3:	89 45 cc             	mov    %eax,-0x34(%ebp)
			break;

		// pointer
		case 'p':
			putch('0', putdat);
  8010d6:	89 74 24 04          	mov    %esi,0x4(%esp)
  8010da:	c7 04 24 30 00 00 00 	movl   $0x30,(%esp)
  8010e1:	ff d7                	call   *%edi
			putch('x', putdat);
  8010e3:	89 74 24 04          	mov    %esi,0x4(%esp)
  8010e7:	c7 04 24 78 00 00 00 	movl   $0x78,(%esp)
  8010ee:	ff d7                	call   *%edi
			num = (unsigned long long)
  8010f0:	8b 45 14             	mov    0x14(%ebp),%eax
  8010f3:	8d 50 04             	lea    0x4(%eax),%edx
  8010f6:	89 55 14             	mov    %edx,0x14(%ebp)
  8010f9:	8b 08                	mov    (%eax),%ecx
  8010fb:	bb 00 00 00 00       	mov    $0x0,%ebx
  801100:	b8 10 00 00 00       	mov    $0x10,%eax
				(uintptr_t) va_arg(ap, void *);
			base = 16;
			goto number;
  801105:	eb 16                	jmp    80111d <vprintfmt+0x3b0>
  801107:	89 45 cc             	mov    %eax,-0x34(%ebp)

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  80110a:	89 ca                	mov    %ecx,%edx
  80110c:	8d 45 14             	lea    0x14(%ebp),%eax
  80110f:	e8 02 fc ff ff       	call   800d16 <getuint>
  801114:	89 c1                	mov    %eax,%ecx
  801116:	89 d3                	mov    %edx,%ebx
  801118:	b8 10 00 00 00       	mov    $0x10,%eax
			base = 16;
		number:
			printnum(putch, putdat, num, base, width, padc);
  80111d:	0f be 55 d4          	movsbl -0x2c(%ebp),%edx
  801121:	89 54 24 10          	mov    %edx,0x10(%esp)
  801125:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801128:	89 54 24 0c          	mov    %edx,0xc(%esp)
  80112c:	89 44 24 08          	mov    %eax,0x8(%esp)
  801130:	89 0c 24             	mov    %ecx,(%esp)
  801133:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801137:	89 f2                	mov    %esi,%edx
  801139:	89 f8                	mov    %edi,%eax
  80113b:	e8 e0 fa ff ff       	call   800c20 <printnum>
  801140:	8b 5d cc             	mov    -0x34(%ebp),%ebx
			break;
  801143:	e9 51 fc ff ff       	jmp    800d99 <vprintfmt+0x2c>
  801148:	89 45 cc             	mov    %eax,-0x34(%ebp)
  80114b:	8b 55 e0             	mov    -0x20(%ebp),%edx

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  80114e:	89 74 24 04          	mov    %esi,0x4(%esp)
  801152:	89 14 24             	mov    %edx,(%esp)
  801155:	ff d7                	call   *%edi
  801157:	8b 5d cc             	mov    -0x34(%ebp),%ebx
			break;
  80115a:	e9 3a fc ff ff       	jmp    800d99 <vprintfmt+0x2c>
			
		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  80115f:	89 74 24 04          	mov    %esi,0x4(%esp)
  801163:	c7 04 24 25 00 00 00 	movl   $0x25,(%esp)
  80116a:	ff d7                	call   *%edi
			for (fmt--; fmt[-1] != '%'; fmt--)
  80116c:	8d 43 ff             	lea    -0x1(%ebx),%eax
  80116f:	80 38 25             	cmpb   $0x25,(%eax)
  801172:	0f 84 21 fc ff ff    	je     800d99 <vprintfmt+0x2c>
  801178:	89 c3                	mov    %eax,%ebx
  80117a:	eb f0                	jmp    80116c <vprintfmt+0x3ff>
				/* do nothing */;
			break;
		}
	}
}
  80117c:	83 c4 5c             	add    $0x5c,%esp
  80117f:	5b                   	pop    %ebx
  801180:	5e                   	pop    %esi
  801181:	5f                   	pop    %edi
  801182:	5d                   	pop    %ebp
  801183:	c3                   	ret    

00801184 <vsnprintf>:
		*b->buf++ = ch;
}

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  801184:	55                   	push   %ebp
  801185:	89 e5                	mov    %esp,%ebp
  801187:	83 ec 28             	sub    $0x28,%esp
  80118a:	8b 45 08             	mov    0x8(%ebp),%eax
  80118d:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};

	if (buf == NULL || n < 1)
  801190:	85 c0                	test   %eax,%eax
  801192:	74 04                	je     801198 <vsnprintf+0x14>
  801194:	85 d2                	test   %edx,%edx
  801196:	7f 07                	jg     80119f <vsnprintf+0x1b>
  801198:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80119d:	eb 3b                	jmp    8011da <vsnprintf+0x56>
}

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
	struct sprintbuf b = {buf, buf+n-1, 0};
  80119f:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8011a2:	8d 44 10 ff          	lea    -0x1(%eax,%edx,1),%eax
  8011a6:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8011a9:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  8011b0:	8b 45 14             	mov    0x14(%ebp),%eax
  8011b3:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8011b7:	8b 45 10             	mov    0x10(%ebp),%eax
  8011ba:	89 44 24 08          	mov    %eax,0x8(%esp)
  8011be:	8d 45 ec             	lea    -0x14(%ebp),%eax
  8011c1:	89 44 24 04          	mov    %eax,0x4(%esp)
  8011c5:	c7 04 24 50 0d 80 00 	movl   $0x800d50,(%esp)
  8011cc:	e8 9c fb ff ff       	call   800d6d <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  8011d1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8011d4:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  8011d7:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  8011da:	c9                   	leave  
  8011db:	c3                   	ret    

008011dc <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  8011dc:	55                   	push   %ebp
  8011dd:	89 e5                	mov    %esp,%ebp
  8011df:	83 ec 18             	sub    $0x18,%esp

	return b.cnt;
}

int
snprintf(char *buf, int n, const char *fmt, ...)
  8011e2:	8d 45 14             	lea    0x14(%ebp),%eax
{
	va_list ap;
	int rc;

	va_start(ap, fmt);
	rc = vsnprintf(buf, n, fmt, ap);
  8011e5:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8011e9:	8b 45 10             	mov    0x10(%ebp),%eax
  8011ec:	89 44 24 08          	mov    %eax,0x8(%esp)
  8011f0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011f3:	89 44 24 04          	mov    %eax,0x4(%esp)
  8011f7:	8b 45 08             	mov    0x8(%ebp),%eax
  8011fa:	89 04 24             	mov    %eax,(%esp)
  8011fd:	e8 82 ff ff ff       	call   801184 <vsnprintf>
	va_end(ap);

	return rc;
}
  801202:	c9                   	leave  
  801203:	c3                   	ret    

00801204 <printfmt>:
	}
}

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  801204:	55                   	push   %ebp
  801205:	89 e5                	mov    %esp,%ebp
  801207:	83 ec 18             	sub    $0x18,%esp
		}
	}
}

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
  80120a:	8d 45 14             	lea    0x14(%ebp),%eax
{
	va_list ap;

	va_start(ap, fmt);
	vprintfmt(putch, putdat, fmt, ap);
  80120d:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801211:	8b 45 10             	mov    0x10(%ebp),%eax
  801214:	89 44 24 08          	mov    %eax,0x8(%esp)
  801218:	8b 45 0c             	mov    0xc(%ebp),%eax
  80121b:	89 44 24 04          	mov    %eax,0x4(%esp)
  80121f:	8b 45 08             	mov    0x8(%ebp),%eax
  801222:	89 04 24             	mov    %eax,(%esp)
  801225:	e8 43 fb ff ff       	call   800d6d <vprintfmt>
	va_end(ap);
}
  80122a:	c9                   	leave  
  80122b:	c3                   	ret    
  80122c:	00 00                	add    %al,(%eax)
	...

00801230 <readline>:
#define BUFLEN 1024
static char buf[BUFLEN];

char *
readline(const char *prompt)
{
  801230:	55                   	push   %ebp
  801231:	89 e5                	mov    %esp,%ebp
  801233:	57                   	push   %edi
  801234:	56                   	push   %esi
  801235:	53                   	push   %ebx
  801236:	83 ec 1c             	sub    $0x1c,%esp
  801239:	8b 45 08             	mov    0x8(%ebp),%eax

#if JOS_KERNEL
	if (prompt != NULL)
		cprintf("%s", prompt);
#else
	if (prompt != NULL)
  80123c:	85 c0                	test   %eax,%eax
  80123e:	74 18                	je     801258 <readline+0x28>
		fprintf(1, "%s", prompt);
  801240:	89 44 24 08          	mov    %eax,0x8(%esp)
  801244:	c7 44 24 04 93 3f 80 	movl   $0x803f93,0x4(%esp)
  80124b:	00 
  80124c:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  801253:	e8 5d 17 00 00       	call   8029b5 <fprintf>
#endif

	i = 0;
	echoing = iscons(0);
  801258:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80125f:	e8 c2 f7 ff ff       	call   800a26 <iscons>
  801264:	89 c7                	mov    %eax,%edi
  801266:	be 00 00 00 00       	mov    $0x0,%esi
	while (1) {
		c = getchar();
  80126b:	e8 e5 f7 ff ff       	call   800a55 <getchar>
  801270:	89 c3                	mov    %eax,%ebx
		if (c < 0) {
  801272:	85 c0                	test   %eax,%eax
  801274:	79 25                	jns    80129b <readline+0x6b>
			if (c != -E_EOF)
  801276:	b8 00 00 00 00       	mov    $0x0,%eax
  80127b:	83 fb f8             	cmp    $0xfffffff8,%ebx
  80127e:	0f 84 8f 00 00 00    	je     801313 <readline+0xe3>
				cprintf("read error: %e\n", c);
  801284:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801288:	c7 04 24 ff 42 80 00 	movl   $0x8042ff,(%esp)
  80128f:	e8 29 f9 ff ff       	call   800bbd <cprintf>
  801294:	b8 00 00 00 00       	mov    $0x0,%eax
  801299:	eb 78                	jmp    801313 <readline+0xe3>
			return NULL;
		} else if ((c == '\b' || c == '\x7f') && i > 0) {
  80129b:	83 f8 08             	cmp    $0x8,%eax
  80129e:	74 05                	je     8012a5 <readline+0x75>
  8012a0:	83 f8 7f             	cmp    $0x7f,%eax
  8012a3:	75 1e                	jne    8012c3 <readline+0x93>
  8012a5:	85 f6                	test   %esi,%esi
  8012a7:	7e 1a                	jle    8012c3 <readline+0x93>
			if (echoing)
  8012a9:	85 ff                	test   %edi,%edi
  8012ab:	90                   	nop
  8012ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  8012b0:	74 0c                	je     8012be <readline+0x8e>
				cputchar('\b');
  8012b2:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
  8012b9:	e8 b4 f6 ff ff       	call   800972 <cputchar>
			i--;
  8012be:	83 ee 01             	sub    $0x1,%esi
		c = getchar();
		if (c < 0) {
			if (c != -E_EOF)
				cprintf("read error: %e\n", c);
			return NULL;
		} else if ((c == '\b' || c == '\x7f') && i > 0) {
  8012c1:	eb a8                	jmp    80126b <readline+0x3b>
			if (echoing)
				cputchar('\b');
			i--;
		} else if (c >= ' ' && i < BUFLEN-1) {
  8012c3:	83 fb 1f             	cmp    $0x1f,%ebx
  8012c6:	7e 21                	jle    8012e9 <readline+0xb9>
  8012c8:	81 fe fe 03 00 00    	cmp    $0x3fe,%esi
  8012ce:	66 90                	xchg   %ax,%ax
  8012d0:	7f 17                	jg     8012e9 <readline+0xb9>
			if (echoing)
  8012d2:	85 ff                	test   %edi,%edi
  8012d4:	74 08                	je     8012de <readline+0xae>
				cputchar(c);
  8012d6:	89 1c 24             	mov    %ebx,(%esp)
  8012d9:	e8 94 f6 ff ff       	call   800972 <cputchar>
			buf[i++] = c;
  8012de:	88 9e a0 80 80 00    	mov    %bl,0x8080a0(%esi)
  8012e4:	83 c6 01             	add    $0x1,%esi
  8012e7:	eb 82                	jmp    80126b <readline+0x3b>
		} else if (c == '\n' || c == '\r') {
  8012e9:	83 fb 0a             	cmp    $0xa,%ebx
  8012ec:	74 09                	je     8012f7 <readline+0xc7>
  8012ee:	83 fb 0d             	cmp    $0xd,%ebx
  8012f1:	0f 85 74 ff ff ff    	jne    80126b <readline+0x3b>
			if (echoing)
  8012f7:	85 ff                	test   %edi,%edi
  8012f9:	74 0c                	je     801307 <readline+0xd7>
				cputchar('\n');
  8012fb:	c7 04 24 0a 00 00 00 	movl   $0xa,(%esp)
  801302:	e8 6b f6 ff ff       	call   800972 <cputchar>
			buf[i] = 0;
  801307:	c6 86 a0 80 80 00 00 	movb   $0x0,0x8080a0(%esi)
  80130e:	b8 a0 80 80 00       	mov    $0x8080a0,%eax
			return buf;
		}
	}
}
  801313:	83 c4 1c             	add    $0x1c,%esp
  801316:	5b                   	pop    %ebx
  801317:	5e                   	pop    %esi
  801318:	5f                   	pop    %edi
  801319:	5d                   	pop    %ebp
  80131a:	c3                   	ret    
  80131b:	00 00                	add    %al,(%eax)
  80131d:	00 00                	add    %al,(%eax)
	...

00801320 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  801320:	55                   	push   %ebp
  801321:	89 e5                	mov    %esp,%ebp
  801323:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  801326:	b8 00 00 00 00       	mov    $0x0,%eax
  80132b:	80 3a 00             	cmpb   $0x0,(%edx)
  80132e:	74 09                	je     801339 <strlen+0x19>
		n++;
  801330:	83 c0 01             	add    $0x1,%eax
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  801333:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  801337:	75 f7                	jne    801330 <strlen+0x10>
		n++;
	return n;
}
  801339:	5d                   	pop    %ebp
  80133a:	c3                   	ret    

0080133b <strnlen>:

int
strnlen(const char *s, size_t size)
{
  80133b:	55                   	push   %ebp
  80133c:	89 e5                	mov    %esp,%ebp
  80133e:	53                   	push   %ebx
  80133f:	8b 5d 08             	mov    0x8(%ebp),%ebx
  801342:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801345:	85 c9                	test   %ecx,%ecx
  801347:	74 19                	je     801362 <strnlen+0x27>
  801349:	80 3b 00             	cmpb   $0x0,(%ebx)
  80134c:	74 14                	je     801362 <strnlen+0x27>
  80134e:	b8 00 00 00 00       	mov    $0x0,%eax
		n++;
  801353:	83 c0 01             	add    $0x1,%eax
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801356:	39 c8                	cmp    %ecx,%eax
  801358:	74 0d                	je     801367 <strnlen+0x2c>
  80135a:	80 3c 03 00          	cmpb   $0x0,(%ebx,%eax,1)
  80135e:	75 f3                	jne    801353 <strnlen+0x18>
  801360:	eb 05                	jmp    801367 <strnlen+0x2c>
  801362:	b8 00 00 00 00       	mov    $0x0,%eax
		n++;
	return n;
}
  801367:	5b                   	pop    %ebx
  801368:	5d                   	pop    %ebp
  801369:	c3                   	ret    

0080136a <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  80136a:	55                   	push   %ebp
  80136b:	89 e5                	mov    %esp,%ebp
  80136d:	53                   	push   %ebx
  80136e:	8b 45 08             	mov    0x8(%ebp),%eax
  801371:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  801374:	ba 00 00 00 00       	mov    $0x0,%edx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  801379:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
  80137d:	88 0c 10             	mov    %cl,(%eax,%edx,1)
  801380:	83 c2 01             	add    $0x1,%edx
  801383:	84 c9                	test   %cl,%cl
  801385:	75 f2                	jne    801379 <strcpy+0xf>
		/* do nothing */;
	return ret;
}
  801387:	5b                   	pop    %ebx
  801388:	5d                   	pop    %ebp
  801389:	c3                   	ret    

0080138a <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  80138a:	55                   	push   %ebp
  80138b:	89 e5                	mov    %esp,%ebp
  80138d:	56                   	push   %esi
  80138e:	53                   	push   %ebx
  80138f:	8b 45 08             	mov    0x8(%ebp),%eax
  801392:	8b 55 0c             	mov    0xc(%ebp),%edx
  801395:	8b 75 10             	mov    0x10(%ebp),%esi
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  801398:	85 f6                	test   %esi,%esi
  80139a:	74 18                	je     8013b4 <strncpy+0x2a>
  80139c:	b9 00 00 00 00       	mov    $0x0,%ecx
		*dst++ = *src;
  8013a1:	0f b6 1a             	movzbl (%edx),%ebx
  8013a4:	88 1c 08             	mov    %bl,(%eax,%ecx,1)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  8013a7:	80 3a 01             	cmpb   $0x1,(%edx)
  8013aa:	83 da ff             	sbb    $0xffffffff,%edx
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  8013ad:	83 c1 01             	add    $0x1,%ecx
  8013b0:	39 ce                	cmp    %ecx,%esi
  8013b2:	77 ed                	ja     8013a1 <strncpy+0x17>
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
}
  8013b4:	5b                   	pop    %ebx
  8013b5:	5e                   	pop    %esi
  8013b6:	5d                   	pop    %ebp
  8013b7:	c3                   	ret    

008013b8 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  8013b8:	55                   	push   %ebp
  8013b9:	89 e5                	mov    %esp,%ebp
  8013bb:	56                   	push   %esi
  8013bc:	53                   	push   %ebx
  8013bd:	8b 75 08             	mov    0x8(%ebp),%esi
  8013c0:	8b 55 0c             	mov    0xc(%ebp),%edx
  8013c3:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  8013c6:	89 f0                	mov    %esi,%eax
  8013c8:	85 c9                	test   %ecx,%ecx
  8013ca:	74 27                	je     8013f3 <strlcpy+0x3b>
		while (--size > 0 && *src != '\0')
  8013cc:	83 e9 01             	sub    $0x1,%ecx
  8013cf:	74 1d                	je     8013ee <strlcpy+0x36>
  8013d1:	0f b6 1a             	movzbl (%edx),%ebx
  8013d4:	84 db                	test   %bl,%bl
  8013d6:	74 16                	je     8013ee <strlcpy+0x36>
			*dst++ = *src++;
  8013d8:	88 18                	mov    %bl,(%eax)
  8013da:	83 c0 01             	add    $0x1,%eax
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  8013dd:	83 e9 01             	sub    $0x1,%ecx
  8013e0:	74 0e                	je     8013f0 <strlcpy+0x38>
			*dst++ = *src++;
  8013e2:	83 c2 01             	add    $0x1,%edx
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  8013e5:	0f b6 1a             	movzbl (%edx),%ebx
  8013e8:	84 db                	test   %bl,%bl
  8013ea:	75 ec                	jne    8013d8 <strlcpy+0x20>
  8013ec:	eb 02                	jmp    8013f0 <strlcpy+0x38>
  8013ee:	89 f0                	mov    %esi,%eax
			*dst++ = *src++;
		*dst = '\0';
  8013f0:	c6 00 00             	movb   $0x0,(%eax)
  8013f3:	29 f0                	sub    %esi,%eax
	}
	return dst - dst_in;
}
  8013f5:	5b                   	pop    %ebx
  8013f6:	5e                   	pop    %esi
  8013f7:	5d                   	pop    %ebp
  8013f8:	c3                   	ret    

008013f9 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  8013f9:	55                   	push   %ebp
  8013fa:	89 e5                	mov    %esp,%ebp
  8013fc:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8013ff:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  801402:	0f b6 01             	movzbl (%ecx),%eax
  801405:	84 c0                	test   %al,%al
  801407:	74 15                	je     80141e <strcmp+0x25>
  801409:	3a 02                	cmp    (%edx),%al
  80140b:	75 11                	jne    80141e <strcmp+0x25>
		p++, q++;
  80140d:	83 c1 01             	add    $0x1,%ecx
  801410:	83 c2 01             	add    $0x1,%edx
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  801413:	0f b6 01             	movzbl (%ecx),%eax
  801416:	84 c0                	test   %al,%al
  801418:	74 04                	je     80141e <strcmp+0x25>
  80141a:	3a 02                	cmp    (%edx),%al
  80141c:	74 ef                	je     80140d <strcmp+0x14>
  80141e:	0f b6 c0             	movzbl %al,%eax
  801421:	0f b6 12             	movzbl (%edx),%edx
  801424:	29 d0                	sub    %edx,%eax
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
}
  801426:	5d                   	pop    %ebp
  801427:	c3                   	ret    

00801428 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  801428:	55                   	push   %ebp
  801429:	89 e5                	mov    %esp,%ebp
  80142b:	53                   	push   %ebx
  80142c:	8b 55 08             	mov    0x8(%ebp),%edx
  80142f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801432:	8b 45 10             	mov    0x10(%ebp),%eax
	while (n > 0 && *p && *p == *q)
  801435:	85 c0                	test   %eax,%eax
  801437:	74 23                	je     80145c <strncmp+0x34>
  801439:	0f b6 1a             	movzbl (%edx),%ebx
  80143c:	84 db                	test   %bl,%bl
  80143e:	74 24                	je     801464 <strncmp+0x3c>
  801440:	3a 19                	cmp    (%ecx),%bl
  801442:	75 20                	jne    801464 <strncmp+0x3c>
  801444:	83 e8 01             	sub    $0x1,%eax
  801447:	74 13                	je     80145c <strncmp+0x34>
		n--, p++, q++;
  801449:	83 c2 01             	add    $0x1,%edx
  80144c:	83 c1 01             	add    $0x1,%ecx
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  80144f:	0f b6 1a             	movzbl (%edx),%ebx
  801452:	84 db                	test   %bl,%bl
  801454:	74 0e                	je     801464 <strncmp+0x3c>
  801456:	3a 19                	cmp    (%ecx),%bl
  801458:	74 ea                	je     801444 <strncmp+0x1c>
  80145a:	eb 08                	jmp    801464 <strncmp+0x3c>
  80145c:	b8 00 00 00 00       	mov    $0x0,%eax
		n--, p++, q++;
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
}
  801461:	5b                   	pop    %ebx
  801462:	5d                   	pop    %ebp
  801463:	c3                   	ret    
	while (n > 0 && *p && *p == *q)
		n--, p++, q++;
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  801464:	0f b6 02             	movzbl (%edx),%eax
  801467:	0f b6 11             	movzbl (%ecx),%edx
  80146a:	29 d0                	sub    %edx,%eax
  80146c:	eb f3                	jmp    801461 <strncmp+0x39>

0080146e <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  80146e:	55                   	push   %ebp
  80146f:	89 e5                	mov    %esp,%ebp
  801471:	8b 45 08             	mov    0x8(%ebp),%eax
  801474:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  801478:	0f b6 10             	movzbl (%eax),%edx
  80147b:	84 d2                	test   %dl,%dl
  80147d:	74 15                	je     801494 <strchr+0x26>
		if (*s == c)
  80147f:	38 ca                	cmp    %cl,%dl
  801481:	75 07                	jne    80148a <strchr+0x1c>
  801483:	eb 14                	jmp    801499 <strchr+0x2b>
  801485:	38 ca                	cmp    %cl,%dl
  801487:	90                   	nop
  801488:	74 0f                	je     801499 <strchr+0x2b>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  80148a:	83 c0 01             	add    $0x1,%eax
  80148d:	0f b6 10             	movzbl (%eax),%edx
  801490:	84 d2                	test   %dl,%dl
  801492:	75 f1                	jne    801485 <strchr+0x17>
  801494:	b8 00 00 00 00       	mov    $0x0,%eax
		if (*s == c)
			return (char *) s;
	return 0;
}
  801499:	5d                   	pop    %ebp
  80149a:	c3                   	ret    

0080149b <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  80149b:	55                   	push   %ebp
  80149c:	89 e5                	mov    %esp,%ebp
  80149e:	8b 45 08             	mov    0x8(%ebp),%eax
  8014a1:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  8014a5:	0f b6 10             	movzbl (%eax),%edx
  8014a8:	84 d2                	test   %dl,%dl
  8014aa:	74 18                	je     8014c4 <strfind+0x29>
		if (*s == c)
  8014ac:	38 ca                	cmp    %cl,%dl
  8014ae:	75 0a                	jne    8014ba <strfind+0x1f>
  8014b0:	eb 12                	jmp    8014c4 <strfind+0x29>
  8014b2:	38 ca                	cmp    %cl,%dl
  8014b4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  8014b8:	74 0a                	je     8014c4 <strfind+0x29>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  8014ba:	83 c0 01             	add    $0x1,%eax
  8014bd:	0f b6 10             	movzbl (%eax),%edx
  8014c0:	84 d2                	test   %dl,%dl
  8014c2:	75 ee                	jne    8014b2 <strfind+0x17>
		if (*s == c)
			break;
	return (char *) s;
}
  8014c4:	5d                   	pop    %ebp
  8014c5:	c3                   	ret    

008014c6 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  8014c6:	55                   	push   %ebp
  8014c7:	89 e5                	mov    %esp,%ebp
  8014c9:	83 ec 0c             	sub    $0xc,%esp
  8014cc:	89 1c 24             	mov    %ebx,(%esp)
  8014cf:	89 74 24 04          	mov    %esi,0x4(%esp)
  8014d3:	89 7c 24 08          	mov    %edi,0x8(%esp)
  8014d7:	8b 7d 08             	mov    0x8(%ebp),%edi
  8014da:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014dd:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  8014e0:	85 c9                	test   %ecx,%ecx
  8014e2:	74 30                	je     801514 <memset+0x4e>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  8014e4:	f7 c7 03 00 00 00    	test   $0x3,%edi
  8014ea:	75 25                	jne    801511 <memset+0x4b>
  8014ec:	f6 c1 03             	test   $0x3,%cl
  8014ef:	75 20                	jne    801511 <memset+0x4b>
		c &= 0xFF;
  8014f1:	0f b6 d0             	movzbl %al,%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  8014f4:	89 d3                	mov    %edx,%ebx
  8014f6:	c1 e3 08             	shl    $0x8,%ebx
  8014f9:	89 d6                	mov    %edx,%esi
  8014fb:	c1 e6 18             	shl    $0x18,%esi
  8014fe:	89 d0                	mov    %edx,%eax
  801500:	c1 e0 10             	shl    $0x10,%eax
  801503:	09 f0                	or     %esi,%eax
  801505:	09 d0                	or     %edx,%eax
		asm volatile("cld; rep stosl\n"
  801507:	09 d8                	or     %ebx,%eax
  801509:	c1 e9 02             	shr    $0x2,%ecx
  80150c:	fc                   	cld    
  80150d:	f3 ab                	rep stos %eax,%es:(%edi)
{
	char *p;

	if (n == 0)
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  80150f:	eb 03                	jmp    801514 <memset+0x4e>
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  801511:	fc                   	cld    
  801512:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  801514:	89 f8                	mov    %edi,%eax
  801516:	8b 1c 24             	mov    (%esp),%ebx
  801519:	8b 74 24 04          	mov    0x4(%esp),%esi
  80151d:	8b 7c 24 08          	mov    0x8(%esp),%edi
  801521:	89 ec                	mov    %ebp,%esp
  801523:	5d                   	pop    %ebp
  801524:	c3                   	ret    

00801525 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  801525:	55                   	push   %ebp
  801526:	89 e5                	mov    %esp,%ebp
  801528:	83 ec 08             	sub    $0x8,%esp
  80152b:	89 34 24             	mov    %esi,(%esp)
  80152e:	89 7c 24 04          	mov    %edi,0x4(%esp)
  801532:	8b 45 08             	mov    0x8(%ebp),%eax
  801535:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;
	
	s = src;
  801538:	8b 75 0c             	mov    0xc(%ebp),%esi
	d = dst;
  80153b:	89 c7                	mov    %eax,%edi
	if (s < d && s + n > d) {
  80153d:	39 c6                	cmp    %eax,%esi
  80153f:	73 35                	jae    801576 <memmove+0x51>
  801541:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  801544:	39 d0                	cmp    %edx,%eax
  801546:	73 2e                	jae    801576 <memmove+0x51>
		s += n;
		d += n;
  801548:	01 cf                	add    %ecx,%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  80154a:	f6 c2 03             	test   $0x3,%dl
  80154d:	75 1b                	jne    80156a <memmove+0x45>
  80154f:	f7 c7 03 00 00 00    	test   $0x3,%edi
  801555:	75 13                	jne    80156a <memmove+0x45>
  801557:	f6 c1 03             	test   $0x3,%cl
  80155a:	75 0e                	jne    80156a <memmove+0x45>
			asm volatile("std; rep movsl\n"
  80155c:	83 ef 04             	sub    $0x4,%edi
  80155f:	8d 72 fc             	lea    -0x4(%edx),%esi
  801562:	c1 e9 02             	shr    $0x2,%ecx
  801565:	fd                   	std    
  801566:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  801568:	eb 09                	jmp    801573 <memmove+0x4e>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  80156a:	83 ef 01             	sub    $0x1,%edi
  80156d:	8d 72 ff             	lea    -0x1(%edx),%esi
  801570:	fd                   	std    
  801571:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  801573:	fc                   	cld    
	const char *s;
	char *d;
	
	s = src;
	d = dst;
	if (s < d && s + n > d) {
  801574:	eb 20                	jmp    801596 <memmove+0x71>
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  801576:	f7 c6 03 00 00 00    	test   $0x3,%esi
  80157c:	75 15                	jne    801593 <memmove+0x6e>
  80157e:	f7 c7 03 00 00 00    	test   $0x3,%edi
  801584:	75 0d                	jne    801593 <memmove+0x6e>
  801586:	f6 c1 03             	test   $0x3,%cl
  801589:	75 08                	jne    801593 <memmove+0x6e>
			asm volatile("cld; rep movsl\n"
  80158b:	c1 e9 02             	shr    $0x2,%ecx
  80158e:	fc                   	cld    
  80158f:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  801591:	eb 03                	jmp    801596 <memmove+0x71>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  801593:	fc                   	cld    
  801594:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  801596:	8b 34 24             	mov    (%esp),%esi
  801599:	8b 7c 24 04          	mov    0x4(%esp),%edi
  80159d:	89 ec                	mov    %ebp,%esp
  80159f:	5d                   	pop    %ebp
  8015a0:	c3                   	ret    

008015a1 <memcpy>:

/* sigh - gcc emits references to this for structure assignments! */
/* it is *not* prototyped in inc/string.h - do not use directly. */
void *
memcpy(void *dst, void *src, size_t n)
{
  8015a1:	55                   	push   %ebp
  8015a2:	89 e5                	mov    %esp,%ebp
  8015a4:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  8015a7:	8b 45 10             	mov    0x10(%ebp),%eax
  8015aa:	89 44 24 08          	mov    %eax,0x8(%esp)
  8015ae:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015b1:	89 44 24 04          	mov    %eax,0x4(%esp)
  8015b5:	8b 45 08             	mov    0x8(%ebp),%eax
  8015b8:	89 04 24             	mov    %eax,(%esp)
  8015bb:	e8 65 ff ff ff       	call   801525 <memmove>
}
  8015c0:	c9                   	leave  
  8015c1:	c3                   	ret    

008015c2 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  8015c2:	55                   	push   %ebp
  8015c3:	89 e5                	mov    %esp,%ebp
  8015c5:	57                   	push   %edi
  8015c6:	56                   	push   %esi
  8015c7:	53                   	push   %ebx
  8015c8:	8b 75 08             	mov    0x8(%ebp),%esi
  8015cb:	8b 7d 0c             	mov    0xc(%ebp),%edi
  8015ce:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  8015d1:	85 c9                	test   %ecx,%ecx
  8015d3:	74 36                	je     80160b <memcmp+0x49>
		if (*s1 != *s2)
  8015d5:	0f b6 06             	movzbl (%esi),%eax
  8015d8:	0f b6 1f             	movzbl (%edi),%ebx
  8015db:	38 d8                	cmp    %bl,%al
  8015dd:	74 20                	je     8015ff <memcmp+0x3d>
  8015df:	eb 14                	jmp    8015f5 <memcmp+0x33>
  8015e1:	0f b6 44 16 01       	movzbl 0x1(%esi,%edx,1),%eax
  8015e6:	0f b6 5c 17 01       	movzbl 0x1(%edi,%edx,1),%ebx
  8015eb:	83 c2 01             	add    $0x1,%edx
  8015ee:	83 e9 01             	sub    $0x1,%ecx
  8015f1:	38 d8                	cmp    %bl,%al
  8015f3:	74 12                	je     801607 <memcmp+0x45>
			return (int) *s1 - (int) *s2;
  8015f5:	0f b6 c0             	movzbl %al,%eax
  8015f8:	0f b6 db             	movzbl %bl,%ebx
  8015fb:	29 d8                	sub    %ebx,%eax
  8015fd:	eb 11                	jmp    801610 <memcmp+0x4e>
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  8015ff:	83 e9 01             	sub    $0x1,%ecx
  801602:	ba 00 00 00 00       	mov    $0x0,%edx
  801607:	85 c9                	test   %ecx,%ecx
  801609:	75 d6                	jne    8015e1 <memcmp+0x1f>
  80160b:	b8 00 00 00 00       	mov    $0x0,%eax
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
}
  801610:	5b                   	pop    %ebx
  801611:	5e                   	pop    %esi
  801612:	5f                   	pop    %edi
  801613:	5d                   	pop    %ebp
  801614:	c3                   	ret    

00801615 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  801615:	55                   	push   %ebp
  801616:	89 e5                	mov    %esp,%ebp
  801618:	8b 45 08             	mov    0x8(%ebp),%eax
	const void *ends = (const char *) s + n;
  80161b:	89 c2                	mov    %eax,%edx
  80161d:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  801620:	39 d0                	cmp    %edx,%eax
  801622:	73 15                	jae    801639 <memfind+0x24>
		if (*(const unsigned char *) s == (unsigned char) c)
  801624:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
  801628:	38 08                	cmp    %cl,(%eax)
  80162a:	75 06                	jne    801632 <memfind+0x1d>
  80162c:	eb 0b                	jmp    801639 <memfind+0x24>
  80162e:	38 08                	cmp    %cl,(%eax)
  801630:	74 07                	je     801639 <memfind+0x24>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  801632:	83 c0 01             	add    $0x1,%eax
  801635:	39 c2                	cmp    %eax,%edx
  801637:	77 f5                	ja     80162e <memfind+0x19>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
	return (void *) s;
}
  801639:	5d                   	pop    %ebp
  80163a:	c3                   	ret    

0080163b <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  80163b:	55                   	push   %ebp
  80163c:	89 e5                	mov    %esp,%ebp
  80163e:	57                   	push   %edi
  80163f:	56                   	push   %esi
  801640:	53                   	push   %ebx
  801641:	83 ec 04             	sub    $0x4,%esp
  801644:	8b 55 08             	mov    0x8(%ebp),%edx
  801647:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  80164a:	0f b6 02             	movzbl (%edx),%eax
  80164d:	3c 20                	cmp    $0x20,%al
  80164f:	74 04                	je     801655 <strtol+0x1a>
  801651:	3c 09                	cmp    $0x9,%al
  801653:	75 0e                	jne    801663 <strtol+0x28>
		s++;
  801655:	83 c2 01             	add    $0x1,%edx
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801658:	0f b6 02             	movzbl (%edx),%eax
  80165b:	3c 20                	cmp    $0x20,%al
  80165d:	74 f6                	je     801655 <strtol+0x1a>
  80165f:	3c 09                	cmp    $0x9,%al
  801661:	74 f2                	je     801655 <strtol+0x1a>
		s++;

	// plus/minus sign
	if (*s == '+')
  801663:	3c 2b                	cmp    $0x2b,%al
  801665:	75 0c                	jne    801673 <strtol+0x38>
		s++;
  801667:	83 c2 01             	add    $0x1,%edx
  80166a:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  801671:	eb 15                	jmp    801688 <strtol+0x4d>
	else if (*s == '-')
  801673:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  80167a:	3c 2d                	cmp    $0x2d,%al
  80167c:	75 0a                	jne    801688 <strtol+0x4d>
		s++, neg = 1;
  80167e:	83 c2 01             	add    $0x1,%edx
  801681:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801688:	85 db                	test   %ebx,%ebx
  80168a:	0f 94 c0             	sete   %al
  80168d:	74 05                	je     801694 <strtol+0x59>
  80168f:	83 fb 10             	cmp    $0x10,%ebx
  801692:	75 18                	jne    8016ac <strtol+0x71>
  801694:	80 3a 30             	cmpb   $0x30,(%edx)
  801697:	75 13                	jne    8016ac <strtol+0x71>
  801699:	80 7a 01 78          	cmpb   $0x78,0x1(%edx)
  80169d:	8d 76 00             	lea    0x0(%esi),%esi
  8016a0:	75 0a                	jne    8016ac <strtol+0x71>
		s += 2, base = 16;
  8016a2:	83 c2 02             	add    $0x2,%edx
  8016a5:	bb 10 00 00 00       	mov    $0x10,%ebx
		s++;
	else if (*s == '-')
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  8016aa:	eb 15                	jmp    8016c1 <strtol+0x86>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  8016ac:	84 c0                	test   %al,%al
  8016ae:	66 90                	xchg   %ax,%ax
  8016b0:	74 0f                	je     8016c1 <strtol+0x86>
  8016b2:	bb 0a 00 00 00       	mov    $0xa,%ebx
  8016b7:	80 3a 30             	cmpb   $0x30,(%edx)
  8016ba:	75 05                	jne    8016c1 <strtol+0x86>
		s++, base = 8;
  8016bc:	83 c2 01             	add    $0x1,%edx
  8016bf:	b3 08                	mov    $0x8,%bl
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  8016c1:	b8 00 00 00 00       	mov    $0x0,%eax
  8016c6:	89 de                	mov    %ebx,%esi

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  8016c8:	0f b6 0a             	movzbl (%edx),%ecx
  8016cb:	89 cf                	mov    %ecx,%edi
  8016cd:	8d 59 d0             	lea    -0x30(%ecx),%ebx
  8016d0:	80 fb 09             	cmp    $0x9,%bl
  8016d3:	77 08                	ja     8016dd <strtol+0xa2>
			dig = *s - '0';
  8016d5:	0f be c9             	movsbl %cl,%ecx
  8016d8:	83 e9 30             	sub    $0x30,%ecx
  8016db:	eb 1e                	jmp    8016fb <strtol+0xc0>
		else if (*s >= 'a' && *s <= 'z')
  8016dd:	8d 5f 9f             	lea    -0x61(%edi),%ebx
  8016e0:	80 fb 19             	cmp    $0x19,%bl
  8016e3:	77 08                	ja     8016ed <strtol+0xb2>
			dig = *s - 'a' + 10;
  8016e5:	0f be c9             	movsbl %cl,%ecx
  8016e8:	83 e9 57             	sub    $0x57,%ecx
  8016eb:	eb 0e                	jmp    8016fb <strtol+0xc0>
		else if (*s >= 'A' && *s <= 'Z')
  8016ed:	8d 5f bf             	lea    -0x41(%edi),%ebx
  8016f0:	80 fb 19             	cmp    $0x19,%bl
  8016f3:	77 15                	ja     80170a <strtol+0xcf>
			dig = *s - 'A' + 10;
  8016f5:	0f be c9             	movsbl %cl,%ecx
  8016f8:	83 e9 37             	sub    $0x37,%ecx
		else
			break;
		if (dig >= base)
  8016fb:	39 f1                	cmp    %esi,%ecx
  8016fd:	7d 0b                	jge    80170a <strtol+0xcf>
			break;
		s++, val = (val * base) + dig;
  8016ff:	83 c2 01             	add    $0x1,%edx
  801702:	0f af c6             	imul   %esi,%eax
  801705:	8d 04 01             	lea    (%ecx,%eax,1),%eax
		// we don't properly detect overflow!
	}
  801708:	eb be                	jmp    8016c8 <strtol+0x8d>
  80170a:	89 c1                	mov    %eax,%ecx

	if (endptr)
  80170c:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801710:	74 05                	je     801717 <strtol+0xdc>
		*endptr = (char *) s;
  801712:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  801715:	89 13                	mov    %edx,(%ebx)
	return (neg ? -val : val);
  801717:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80171b:	74 04                	je     801721 <strtol+0xe6>
  80171d:	89 c8                	mov    %ecx,%eax
  80171f:	f7 d8                	neg    %eax
}
  801721:	83 c4 04             	add    $0x4,%esp
  801724:	5b                   	pop    %ebx
  801725:	5e                   	pop    %esi
  801726:	5f                   	pop    %edi
  801727:	5d                   	pop    %ebp
  801728:	c3                   	ret    
  801729:	00 00                	add    %al,(%eax)
	...

0080172c <sys_cgetc>:
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}

int
sys_cgetc(void)
{
  80172c:	55                   	push   %ebp
  80172d:	89 e5                	mov    %esp,%ebp
  80172f:	83 ec 0c             	sub    $0xc,%esp
  801732:	89 1c 24             	mov    %ebx,(%esp)
  801735:	89 74 24 04          	mov    %esi,0x4(%esp)
  801739:	89 7c 24 08          	mov    %edi,0x8(%esp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80173d:	ba 00 00 00 00       	mov    $0x0,%edx
  801742:	b8 01 00 00 00       	mov    $0x1,%eax
  801747:	89 d1                	mov    %edx,%ecx
  801749:	89 d3                	mov    %edx,%ebx
  80174b:	89 d7                	mov    %edx,%edi
  80174d:	89 d6                	mov    %edx,%esi
  80174f:	cd 30                	int    $0x30

int
sys_cgetc(void)
{
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  801751:	8b 1c 24             	mov    (%esp),%ebx
  801754:	8b 74 24 04          	mov    0x4(%esp),%esi
  801758:	8b 7c 24 08          	mov    0x8(%esp),%edi
  80175c:	89 ec                	mov    %ebp,%esp
  80175e:	5d                   	pop    %ebp
  80175f:	c3                   	ret    

00801760 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  801760:	55                   	push   %ebp
  801761:	89 e5                	mov    %esp,%ebp
  801763:	83 ec 0c             	sub    $0xc,%esp
  801766:	89 1c 24             	mov    %ebx,(%esp)
  801769:	89 74 24 04          	mov    %esi,0x4(%esp)
  80176d:	89 7c 24 08          	mov    %edi,0x8(%esp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801771:	b8 00 00 00 00       	mov    $0x0,%eax
  801776:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801779:	8b 55 08             	mov    0x8(%ebp),%edx
  80177c:	89 c3                	mov    %eax,%ebx
  80177e:	89 c7                	mov    %eax,%edi
  801780:	89 c6                	mov    %eax,%esi
  801782:	cd 30                	int    $0x30

void
sys_cputs(const char *s, size_t len)
{
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  801784:	8b 1c 24             	mov    (%esp),%ebx
  801787:	8b 74 24 04          	mov    0x4(%esp),%esi
  80178b:	8b 7c 24 08          	mov    0x8(%esp),%edi
  80178f:	89 ec                	mov    %ebp,%esp
  801791:	5d                   	pop    %ebp
  801792:	c3                   	ret    

00801793 <sys_page_insert>:
{
	return syscall(SYS_page_waste, 0, (uint32_t)p, (uint32_t)n, 0, 0,0);
}
int
sys_page_insert(envid_t envid, void *va, struct Page *p, int perm)
{
  801793:	55                   	push   %ebp
  801794:	89 e5                	mov    %esp,%ebp
  801796:	83 ec 38             	sub    $0x38,%esp
  801799:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  80179c:	89 75 f8             	mov    %esi,-0x8(%ebp)
  80179f:	89 7d fc             	mov    %edi,-0x4(%ebp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8017a2:	be 00 00 00 00       	mov    $0x0,%esi
  8017a7:	b8 12 00 00 00       	mov    $0x12,%eax
  8017ac:	8b 7d 14             	mov    0x14(%ebp),%edi
  8017af:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8017b2:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8017b5:	8b 55 08             	mov    0x8(%ebp),%edx
  8017b8:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
	
	if(check && ret > 0)
  8017ba:	85 c0                	test   %eax,%eax
  8017bc:	7e 28                	jle    8017e6 <sys_page_insert+0x53>
		panic("syscall %d returned %d (> 0)", num, ret);
  8017be:	89 44 24 10          	mov    %eax,0x10(%esp)
  8017c2:	c7 44 24 0c 12 00 00 	movl   $0x12,0xc(%esp)
  8017c9:	00 
  8017ca:	c7 44 24 08 0f 43 80 	movl   $0x80430f,0x8(%esp)
  8017d1:	00 
  8017d2:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  8017d9:	00 
  8017da:	c7 04 24 2c 43 80 00 	movl   $0x80432c,(%esp)
  8017e1:	e8 12 f3 ff ff       	call   800af8 <_panic>
}
int
sys_page_insert(envid_t envid, void *va, struct Page *p, int perm)
{
	return syscall(SYS_page_insert, 1, envid, (uint32_t) va, (uint32_t)p, perm, 0);
}
  8017e6:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  8017e9:	8b 75 f8             	mov    -0x8(%ebp),%esi
  8017ec:	8b 7d fc             	mov    -0x4(%ebp),%edi
  8017ef:	89 ec                	mov    %ebp,%esp
  8017f1:	5d                   	pop    %ebp
  8017f2:	c3                   	ret    

008017f3 <sys_page_waste>:
{
	return (int)syscall(SYS_receive_packet, 0, (uint32_t)buffer, 0,0,0,0);
}

int sys_page_waste(struct Page **p, int n)
{
  8017f3:	55                   	push   %ebp
  8017f4:	89 e5                	mov    %esp,%ebp
  8017f6:	83 ec 0c             	sub    $0xc,%esp
  8017f9:	89 1c 24             	mov    %ebx,(%esp)
  8017fc:	89 74 24 04          	mov    %esi,0x4(%esp)
  801800:	89 7c 24 08          	mov    %edi,0x8(%esp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801804:	bb 00 00 00 00       	mov    $0x0,%ebx
  801809:	b8 11 00 00 00       	mov    $0x11,%eax
  80180e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801811:	8b 55 08             	mov    0x8(%ebp),%edx
  801814:	89 df                	mov    %ebx,%edi
  801816:	89 de                	mov    %ebx,%esi
  801818:	cd 30                	int    $0x30
}

int sys_page_waste(struct Page **p, int n)
{
	return syscall(SYS_page_waste, 0, (uint32_t)p, (uint32_t)n, 0, 0,0);
}
  80181a:	8b 1c 24             	mov    (%esp),%ebx
  80181d:	8b 74 24 04          	mov    0x4(%esp),%esi
  801821:	8b 7c 24 08          	mov    0x8(%esp),%edi
  801825:	89 ec                	mov    %ebp,%esp
  801827:	5d                   	pop    %ebp
  801828:	c3                   	ret    

00801829 <sys_receive_packet>:
{
	return (int)syscall(SYS_transmit_packet, 1, (uint32_t)data, len, 0,0,0);
}

int sys_receive_packet(void* buffer)
{
  801829:	55                   	push   %ebp
  80182a:	89 e5                	mov    %esp,%ebp
  80182c:	83 ec 0c             	sub    $0xc,%esp
  80182f:	89 1c 24             	mov    %ebx,(%esp)
  801832:	89 74 24 04          	mov    %esi,0x4(%esp)
  801836:	89 7c 24 08          	mov    %edi,0x8(%esp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80183a:	b9 00 00 00 00       	mov    $0x0,%ecx
  80183f:	b8 10 00 00 00       	mov    $0x10,%eax
  801844:	8b 55 08             	mov    0x8(%ebp),%edx
  801847:	89 cb                	mov    %ecx,%ebx
  801849:	89 cf                	mov    %ecx,%edi
  80184b:	89 ce                	mov    %ecx,%esi
  80184d:	cd 30                	int    $0x30
}

int sys_receive_packet(void* buffer)
{
	return (int)syscall(SYS_receive_packet, 0, (uint32_t)buffer, 0,0,0,0);
}
  80184f:	8b 1c 24             	mov    (%esp),%ebx
  801852:	8b 74 24 04          	mov    0x4(%esp),%esi
  801856:	8b 7c 24 08          	mov    0x8(%esp),%edi
  80185a:	89 ec                	mov    %ebp,%esp
  80185c:	5d                   	pop    %ebp
  80185d:	c3                   	ret    

0080185e <sys_transmit_packet>:
{
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0,0);
}

int sys_transmit_packet(void* data, uint32_t len)
{
  80185e:	55                   	push   %ebp
  80185f:	89 e5                	mov    %esp,%ebp
  801861:	83 ec 38             	sub    $0x38,%esp
  801864:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  801867:	89 75 f8             	mov    %esi,-0x8(%ebp)
  80186a:	89 7d fc             	mov    %edi,-0x4(%ebp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80186d:	bb 00 00 00 00       	mov    $0x0,%ebx
  801872:	b8 0f 00 00 00       	mov    $0xf,%eax
  801877:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80187a:	8b 55 08             	mov    0x8(%ebp),%edx
  80187d:	89 df                	mov    %ebx,%edi
  80187f:	89 de                	mov    %ebx,%esi
  801881:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
	
	if(check && ret > 0)
  801883:	85 c0                	test   %eax,%eax
  801885:	7e 28                	jle    8018af <sys_transmit_packet+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  801887:	89 44 24 10          	mov    %eax,0x10(%esp)
  80188b:	c7 44 24 0c 0f 00 00 	movl   $0xf,0xc(%esp)
  801892:	00 
  801893:	c7 44 24 08 0f 43 80 	movl   $0x80430f,0x8(%esp)
  80189a:	00 
  80189b:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  8018a2:	00 
  8018a3:	c7 04 24 2c 43 80 00 	movl   $0x80432c,(%esp)
  8018aa:	e8 49 f2 ff ff       	call   800af8 <_panic>
}

int sys_transmit_packet(void* data, uint32_t len)
{
	return (int)syscall(SYS_transmit_packet, 1, (uint32_t)data, len, 0,0,0);
}
  8018af:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  8018b2:	8b 75 f8             	mov    -0x8(%ebp),%esi
  8018b5:	8b 7d fc             	mov    -0x4(%ebp),%edi
  8018b8:	89 ec                	mov    %ebp,%esp
  8018ba:	5d                   	pop    %ebp
  8018bb:	c3                   	ret    

008018bc <sys_time_msec>:
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}

unsigned int
sys_time_msec(void)
{
  8018bc:	55                   	push   %ebp
  8018bd:	89 e5                	mov    %esp,%ebp
  8018bf:	83 ec 0c             	sub    $0xc,%esp
  8018c2:	89 1c 24             	mov    %ebx,(%esp)
  8018c5:	89 74 24 04          	mov    %esi,0x4(%esp)
  8018c9:	89 7c 24 08          	mov    %edi,0x8(%esp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8018cd:	ba 00 00 00 00       	mov    $0x0,%edx
  8018d2:	b8 0e 00 00 00       	mov    $0xe,%eax
  8018d7:	89 d1                	mov    %edx,%ecx
  8018d9:	89 d3                	mov    %edx,%ebx
  8018db:	89 d7                	mov    %edx,%edi
  8018dd:	89 d6                	mov    %edx,%esi
  8018df:	cd 30                	int    $0x30

unsigned int
sys_time_msec(void)
{
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0,0);
}
  8018e1:	8b 1c 24             	mov    (%esp),%ebx
  8018e4:	8b 74 24 04          	mov    0x4(%esp),%esi
  8018e8:	8b 7c 24 08          	mov    0x8(%esp),%edi
  8018ec:	89 ec                	mov    %ebp,%esp
  8018ee:	5d                   	pop    %ebp
  8018ef:	c3                   	ret    

008018f0 <sys_ipc_recv>:
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}

int
sys_ipc_recv(void *dstva)
{
  8018f0:	55                   	push   %ebp
  8018f1:	89 e5                	mov    %esp,%ebp
  8018f3:	83 ec 38             	sub    $0x38,%esp
  8018f6:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  8018f9:	89 75 f8             	mov    %esi,-0x8(%ebp)
  8018fc:	89 7d fc             	mov    %edi,-0x4(%ebp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8018ff:	b9 00 00 00 00       	mov    $0x0,%ecx
  801904:	b8 0d 00 00 00       	mov    $0xd,%eax
  801909:	8b 55 08             	mov    0x8(%ebp),%edx
  80190c:	89 cb                	mov    %ecx,%ebx
  80190e:	89 cf                	mov    %ecx,%edi
  801910:	89 ce                	mov    %ecx,%esi
  801912:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
	
	if(check && ret > 0)
  801914:	85 c0                	test   %eax,%eax
  801916:	7e 28                	jle    801940 <sys_ipc_recv+0x50>
		panic("syscall %d returned %d (> 0)", num, ret);
  801918:	89 44 24 10          	mov    %eax,0x10(%esp)
  80191c:	c7 44 24 0c 0d 00 00 	movl   $0xd,0xc(%esp)
  801923:	00 
  801924:	c7 44 24 08 0f 43 80 	movl   $0x80430f,0x8(%esp)
  80192b:	00 
  80192c:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  801933:	00 
  801934:	c7 04 24 2c 43 80 00 	movl   $0x80432c,(%esp)
  80193b:	e8 b8 f1 ff ff       	call   800af8 <_panic>

int
sys_ipc_recv(void *dstva)
{
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  801940:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  801943:	8b 75 f8             	mov    -0x8(%ebp),%esi
  801946:	8b 7d fc             	mov    -0x4(%ebp),%edi
  801949:	89 ec                	mov    %ebp,%esp
  80194b:	5d                   	pop    %ebp
  80194c:	c3                   	ret    

0080194d <sys_ipc_try_send>:
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  80194d:	55                   	push   %ebp
  80194e:	89 e5                	mov    %esp,%ebp
  801950:	83 ec 0c             	sub    $0xc,%esp
  801953:	89 1c 24             	mov    %ebx,(%esp)
  801956:	89 74 24 04          	mov    %esi,0x4(%esp)
  80195a:	89 7c 24 08          	mov    %edi,0x8(%esp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80195e:	be 00 00 00 00       	mov    $0x0,%esi
  801963:	b8 0c 00 00 00       	mov    $0xc,%eax
  801968:	8b 7d 14             	mov    0x14(%ebp),%edi
  80196b:	8b 5d 10             	mov    0x10(%ebp),%ebx
  80196e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801971:	8b 55 08             	mov    0x8(%ebp),%edx
  801974:	cd 30                	int    $0x30

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  801976:	8b 1c 24             	mov    (%esp),%ebx
  801979:	8b 74 24 04          	mov    0x4(%esp),%esi
  80197d:	8b 7c 24 08          	mov    0x8(%esp),%edi
  801981:	89 ec                	mov    %ebp,%esp
  801983:	5d                   	pop    %ebp
  801984:	c3                   	ret    

00801985 <sys_env_set_pgfault_upcall>:
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  801985:	55                   	push   %ebp
  801986:	89 e5                	mov    %esp,%ebp
  801988:	83 ec 38             	sub    $0x38,%esp
  80198b:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  80198e:	89 75 f8             	mov    %esi,-0x8(%ebp)
  801991:	89 7d fc             	mov    %edi,-0x4(%ebp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801994:	bb 00 00 00 00       	mov    $0x0,%ebx
  801999:	b8 0a 00 00 00       	mov    $0xa,%eax
  80199e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8019a1:	8b 55 08             	mov    0x8(%ebp),%edx
  8019a4:	89 df                	mov    %ebx,%edi
  8019a6:	89 de                	mov    %ebx,%esi
  8019a8:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
	
	if(check && ret > 0)
  8019aa:	85 c0                	test   %eax,%eax
  8019ac:	7e 28                	jle    8019d6 <sys_env_set_pgfault_upcall+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  8019ae:	89 44 24 10          	mov    %eax,0x10(%esp)
  8019b2:	c7 44 24 0c 0a 00 00 	movl   $0xa,0xc(%esp)
  8019b9:	00 
  8019ba:	c7 44 24 08 0f 43 80 	movl   $0x80430f,0x8(%esp)
  8019c1:	00 
  8019c2:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  8019c9:	00 
  8019ca:	c7 04 24 2c 43 80 00 	movl   $0x80432c,(%esp)
  8019d1:	e8 22 f1 ff ff       	call   800af8 <_panic>

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  8019d6:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  8019d9:	8b 75 f8             	mov    -0x8(%ebp),%esi
  8019dc:	8b 7d fc             	mov    -0x4(%ebp),%edi
  8019df:	89 ec                	mov    %ebp,%esp
  8019e1:	5d                   	pop    %ebp
  8019e2:	c3                   	ret    

008019e3 <sys_env_set_trapframe>:
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  8019e3:	55                   	push   %ebp
  8019e4:	89 e5                	mov    %esp,%ebp
  8019e6:	83 ec 38             	sub    $0x38,%esp
  8019e9:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  8019ec:	89 75 f8             	mov    %esi,-0x8(%ebp)
  8019ef:	89 7d fc             	mov    %edi,-0x4(%ebp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8019f2:	bb 00 00 00 00       	mov    $0x0,%ebx
  8019f7:	b8 09 00 00 00       	mov    $0x9,%eax
  8019fc:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8019ff:	8b 55 08             	mov    0x8(%ebp),%edx
  801a02:	89 df                	mov    %ebx,%edi
  801a04:	89 de                	mov    %ebx,%esi
  801a06:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
	
	if(check && ret > 0)
  801a08:	85 c0                	test   %eax,%eax
  801a0a:	7e 28                	jle    801a34 <sys_env_set_trapframe+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  801a0c:	89 44 24 10          	mov    %eax,0x10(%esp)
  801a10:	c7 44 24 0c 09 00 00 	movl   $0x9,0xc(%esp)
  801a17:	00 
  801a18:	c7 44 24 08 0f 43 80 	movl   $0x80430f,0x8(%esp)
  801a1f:	00 
  801a20:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  801a27:	00 
  801a28:	c7 04 24 2c 43 80 00 	movl   $0x80432c,(%esp)
  801a2f:	e8 c4 f0 ff ff       	call   800af8 <_panic>

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  801a34:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  801a37:	8b 75 f8             	mov    -0x8(%ebp),%esi
  801a3a:	8b 7d fc             	mov    -0x4(%ebp),%edi
  801a3d:	89 ec                	mov    %ebp,%esp
  801a3f:	5d                   	pop    %ebp
  801a40:	c3                   	ret    

00801a41 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  801a41:	55                   	push   %ebp
  801a42:	89 e5                	mov    %esp,%ebp
  801a44:	83 ec 38             	sub    $0x38,%esp
  801a47:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  801a4a:	89 75 f8             	mov    %esi,-0x8(%ebp)
  801a4d:	89 7d fc             	mov    %edi,-0x4(%ebp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801a50:	bb 00 00 00 00       	mov    $0x0,%ebx
  801a55:	b8 08 00 00 00       	mov    $0x8,%eax
  801a5a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801a5d:	8b 55 08             	mov    0x8(%ebp),%edx
  801a60:	89 df                	mov    %ebx,%edi
  801a62:	89 de                	mov    %ebx,%esi
  801a64:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
	
	if(check && ret > 0)
  801a66:	85 c0                	test   %eax,%eax
  801a68:	7e 28                	jle    801a92 <sys_env_set_status+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  801a6a:	89 44 24 10          	mov    %eax,0x10(%esp)
  801a6e:	c7 44 24 0c 08 00 00 	movl   $0x8,0xc(%esp)
  801a75:	00 
  801a76:	c7 44 24 08 0f 43 80 	movl   $0x80430f,0x8(%esp)
  801a7d:	00 
  801a7e:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  801a85:	00 
  801a86:	c7 04 24 2c 43 80 00 	movl   $0x80432c,(%esp)
  801a8d:	e8 66 f0 ff ff       	call   800af8 <_panic>

int
sys_env_set_status(envid_t envid, int status)
{
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  801a92:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  801a95:	8b 75 f8             	mov    -0x8(%ebp),%esi
  801a98:	8b 7d fc             	mov    -0x4(%ebp),%edi
  801a9b:	89 ec                	mov    %ebp,%esp
  801a9d:	5d                   	pop    %ebp
  801a9e:	c3                   	ret    

00801a9f <sys_page_unmap>:
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}

int
sys_page_unmap(envid_t envid, void *va)
{
  801a9f:	55                   	push   %ebp
  801aa0:	89 e5                	mov    %esp,%ebp
  801aa2:	83 ec 38             	sub    $0x38,%esp
  801aa5:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  801aa8:	89 75 f8             	mov    %esi,-0x8(%ebp)
  801aab:	89 7d fc             	mov    %edi,-0x4(%ebp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801aae:	bb 00 00 00 00       	mov    $0x0,%ebx
  801ab3:	b8 06 00 00 00       	mov    $0x6,%eax
  801ab8:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801abb:	8b 55 08             	mov    0x8(%ebp),%edx
  801abe:	89 df                	mov    %ebx,%edi
  801ac0:	89 de                	mov    %ebx,%esi
  801ac2:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
	
	if(check && ret > 0)
  801ac4:	85 c0                	test   %eax,%eax
  801ac6:	7e 28                	jle    801af0 <sys_page_unmap+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  801ac8:	89 44 24 10          	mov    %eax,0x10(%esp)
  801acc:	c7 44 24 0c 06 00 00 	movl   $0x6,0xc(%esp)
  801ad3:	00 
  801ad4:	c7 44 24 08 0f 43 80 	movl   $0x80430f,0x8(%esp)
  801adb:	00 
  801adc:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  801ae3:	00 
  801ae4:	c7 04 24 2c 43 80 00 	movl   $0x80432c,(%esp)
  801aeb:	e8 08 f0 ff ff       	call   800af8 <_panic>

int
sys_page_unmap(envid_t envid, void *va)
{
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  801af0:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  801af3:	8b 75 f8             	mov    -0x8(%ebp),%esi
  801af6:	8b 7d fc             	mov    -0x4(%ebp),%edi
  801af9:	89 ec                	mov    %ebp,%esp
  801afb:	5d                   	pop    %ebp
  801afc:	c3                   	ret    

00801afd <sys_page_map>:
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  801afd:	55                   	push   %ebp
  801afe:	89 e5                	mov    %esp,%ebp
  801b00:	83 ec 38             	sub    $0x38,%esp
  801b03:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  801b06:	89 75 f8             	mov    %esi,-0x8(%ebp)
  801b09:	89 7d fc             	mov    %edi,-0x4(%ebp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801b0c:	b8 05 00 00 00       	mov    $0x5,%eax
  801b11:	8b 75 18             	mov    0x18(%ebp),%esi
  801b14:	8b 7d 14             	mov    0x14(%ebp),%edi
  801b17:	8b 5d 10             	mov    0x10(%ebp),%ebx
  801b1a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801b1d:	8b 55 08             	mov    0x8(%ebp),%edx
  801b20:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
	
	if(check && ret > 0)
  801b22:	85 c0                	test   %eax,%eax
  801b24:	7e 28                	jle    801b4e <sys_page_map+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  801b26:	89 44 24 10          	mov    %eax,0x10(%esp)
  801b2a:	c7 44 24 0c 05 00 00 	movl   $0x5,0xc(%esp)
  801b31:	00 
  801b32:	c7 44 24 08 0f 43 80 	movl   $0x80430f,0x8(%esp)
  801b39:	00 
  801b3a:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  801b41:	00 
  801b42:	c7 04 24 2c 43 80 00 	movl   $0x80432c,(%esp)
  801b49:	e8 aa ef ff ff       	call   800af8 <_panic>

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  801b4e:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  801b51:	8b 75 f8             	mov    -0x8(%ebp),%esi
  801b54:	8b 7d fc             	mov    -0x4(%ebp),%edi
  801b57:	89 ec                	mov    %ebp,%esp
  801b59:	5d                   	pop    %ebp
  801b5a:	c3                   	ret    

00801b5b <sys_page_alloc>:
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  801b5b:	55                   	push   %ebp
  801b5c:	89 e5                	mov    %esp,%ebp
  801b5e:	83 ec 38             	sub    $0x38,%esp
  801b61:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  801b64:	89 75 f8             	mov    %esi,-0x8(%ebp)
  801b67:	89 7d fc             	mov    %edi,-0x4(%ebp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801b6a:	be 00 00 00 00       	mov    $0x0,%esi
  801b6f:	b8 04 00 00 00       	mov    $0x4,%eax
  801b74:	8b 5d 10             	mov    0x10(%ebp),%ebx
  801b77:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801b7a:	8b 55 08             	mov    0x8(%ebp),%edx
  801b7d:	89 f7                	mov    %esi,%edi
  801b7f:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
	
	if(check && ret > 0)
  801b81:	85 c0                	test   %eax,%eax
  801b83:	7e 28                	jle    801bad <sys_page_alloc+0x52>
		panic("syscall %d returned %d (> 0)", num, ret);
  801b85:	89 44 24 10          	mov    %eax,0x10(%esp)
  801b89:	c7 44 24 0c 04 00 00 	movl   $0x4,0xc(%esp)
  801b90:	00 
  801b91:	c7 44 24 08 0f 43 80 	movl   $0x80430f,0x8(%esp)
  801b98:	00 
  801b99:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  801ba0:	00 
  801ba1:	c7 04 24 2c 43 80 00 	movl   $0x80432c,(%esp)
  801ba8:	e8 4b ef ff ff       	call   800af8 <_panic>

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  801bad:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  801bb0:	8b 75 f8             	mov    -0x8(%ebp),%esi
  801bb3:	8b 7d fc             	mov    -0x4(%ebp),%edi
  801bb6:	89 ec                	mov    %ebp,%esp
  801bb8:	5d                   	pop    %ebp
  801bb9:	c3                   	ret    

00801bba <sys_yield>:
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}

void
sys_yield(void)
{
  801bba:	55                   	push   %ebp
  801bbb:	89 e5                	mov    %esp,%ebp
  801bbd:	83 ec 0c             	sub    $0xc,%esp
  801bc0:	89 1c 24             	mov    %ebx,(%esp)
  801bc3:	89 74 24 04          	mov    %esi,0x4(%esp)
  801bc7:	89 7c 24 08          	mov    %edi,0x8(%esp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801bcb:	ba 00 00 00 00       	mov    $0x0,%edx
  801bd0:	b8 0b 00 00 00       	mov    $0xb,%eax
  801bd5:	89 d1                	mov    %edx,%ecx
  801bd7:	89 d3                	mov    %edx,%ebx
  801bd9:	89 d7                	mov    %edx,%edi
  801bdb:	89 d6                	mov    %edx,%esi
  801bdd:	cd 30                	int    $0x30

void
sys_yield(void)
{
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  801bdf:	8b 1c 24             	mov    (%esp),%ebx
  801be2:	8b 74 24 04          	mov    0x4(%esp),%esi
  801be6:	8b 7c 24 08          	mov    0x8(%esp),%edi
  801bea:	89 ec                	mov    %ebp,%esp
  801bec:	5d                   	pop    %ebp
  801bed:	c3                   	ret    

00801bee <sys_getenvid>:
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}

envid_t
sys_getenvid(void)
{
  801bee:	55                   	push   %ebp
  801bef:	89 e5                	mov    %esp,%ebp
  801bf1:	83 ec 0c             	sub    $0xc,%esp
  801bf4:	89 1c 24             	mov    %ebx,(%esp)
  801bf7:	89 74 24 04          	mov    %esi,0x4(%esp)
  801bfb:	89 7c 24 08          	mov    %edi,0x8(%esp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801bff:	ba 00 00 00 00       	mov    $0x0,%edx
  801c04:	b8 02 00 00 00       	mov    $0x2,%eax
  801c09:	89 d1                	mov    %edx,%ecx
  801c0b:	89 d3                	mov    %edx,%ebx
  801c0d:	89 d7                	mov    %edx,%edi
  801c0f:	89 d6                	mov    %edx,%esi
  801c11:	cd 30                	int    $0x30

envid_t
sys_getenvid(void)
{
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  801c13:	8b 1c 24             	mov    (%esp),%ebx
  801c16:	8b 74 24 04          	mov    0x4(%esp),%esi
  801c1a:	8b 7c 24 08          	mov    0x8(%esp),%edi
  801c1e:	89 ec                	mov    %ebp,%esp
  801c20:	5d                   	pop    %ebp
  801c21:	c3                   	ret    

00801c22 <sys_env_destroy>:
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}

int
sys_env_destroy(envid_t envid)
{
  801c22:	55                   	push   %ebp
  801c23:	89 e5                	mov    %esp,%ebp
  801c25:	83 ec 38             	sub    $0x38,%esp
  801c28:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  801c2b:	89 75 f8             	mov    %esi,-0x8(%ebp)
  801c2e:	89 7d fc             	mov    %edi,-0x4(%ebp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801c31:	b9 00 00 00 00       	mov    $0x0,%ecx
  801c36:	b8 03 00 00 00       	mov    $0x3,%eax
  801c3b:	8b 55 08             	mov    0x8(%ebp),%edx
  801c3e:	89 cb                	mov    %ecx,%ebx
  801c40:	89 cf                	mov    %ecx,%edi
  801c42:	89 ce                	mov    %ecx,%esi
  801c44:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
	
	if(check && ret > 0)
  801c46:	85 c0                	test   %eax,%eax
  801c48:	7e 28                	jle    801c72 <sys_env_destroy+0x50>
		panic("syscall %d returned %d (> 0)", num, ret);
  801c4a:	89 44 24 10          	mov    %eax,0x10(%esp)
  801c4e:	c7 44 24 0c 03 00 00 	movl   $0x3,0xc(%esp)
  801c55:	00 
  801c56:	c7 44 24 08 0f 43 80 	movl   $0x80430f,0x8(%esp)
  801c5d:	00 
  801c5e:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  801c65:	00 
  801c66:	c7 04 24 2c 43 80 00 	movl   $0x80432c,(%esp)
  801c6d:	e8 86 ee ff ff       	call   800af8 <_panic>

int
sys_env_destroy(envid_t envid)
{
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  801c72:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  801c75:	8b 75 f8             	mov    -0x8(%ebp),%esi
  801c78:	8b 7d fc             	mov    -0x4(%ebp),%edi
  801c7b:	89 ec                	mov    %ebp,%esp
  801c7d:	5d                   	pop    %ebp
  801c7e:	c3                   	ret    
	...

00801c80 <sfork>:
}

// Challenge!
int
sfork(void)
{
  801c80:	55                   	push   %ebp
  801c81:	89 e5                	mov    %esp,%ebp
  801c83:	83 ec 18             	sub    $0x18,%esp
	panic("sfork not implemented");
  801c86:	c7 44 24 08 3a 43 80 	movl   $0x80433a,0x8(%esp)
  801c8d:	00 
  801c8e:	c7 44 24 04 f2 00 00 	movl   $0xf2,0x4(%esp)
  801c95:	00 
  801c96:	c7 04 24 50 43 80 00 	movl   $0x804350,(%esp)
  801c9d:	e8 56 ee ff ff       	call   800af8 <_panic>

00801ca2 <pgfault>:
// Custom page fault handler - if faulting page is copy-on-write,
// map in our own private writable copy.
//
static void
pgfault(struct UTrapframe *utf)
{
  801ca2:	55                   	push   %ebp
  801ca3:	89 e5                	mov    %esp,%ebp
  801ca5:	53                   	push   %ebx
  801ca6:	83 ec 24             	sub    $0x24,%esp
  801ca9:	8b 45 08             	mov    0x8(%ebp),%eax
	void *addr = (void *) utf->utf_fault_va;
  801cac:	8b 18                	mov    (%eax),%ebx
	uint32_t err = utf->utf_err;
  801cae:	f6 40 04 02          	testb  $0x2,0x4(%eax)
  801cb2:	75 1c                	jne    801cd0 <pgfault+0x2e>
	// LAB 4: Your code here.
	if ((err & FEC_WR) != FEC_WR)
	{
		if (debug)
			cprintf("Error caught = %x\n", err);
		panic ("user panic in lib/fork.c - pgfault(): faulting access is not write\n");
  801cb4:	c7 44 24 08 5c 43 80 	movl   $0x80435c,0x8(%esp)
  801cbb:	00 
  801cbc:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  801cc3:	00 
  801cc4:	c7 04 24 50 43 80 00 	movl   $0x804350,(%esp)
  801ccb:	e8 28 ee ff ff       	call   800af8 <_panic>
	}
	pte = vpt[VPN(addr)];
  801cd0:	89 d8                	mov    %ebx,%eax
  801cd2:	c1 e8 0c             	shr    $0xc,%eax
  801cd5:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
	if ((pte & PTE_COW) != PTE_COW)
  801cdc:	f6 c4 08             	test   $0x8,%ah
  801cdf:	75 1c                	jne    801cfd <pgfault+0x5b>
		panic ("user panic in lib/fork.c - pgfault(): faulting access is not to a COW page\n");
  801ce1:	c7 44 24 08 a0 43 80 	movl   $0x8043a0,0x8(%esp)
  801ce8:	00 
  801ce9:	c7 44 24 04 27 00 00 	movl   $0x27,0x4(%esp)
  801cf0:	00 
  801cf1:	c7 04 24 50 43 80 00 	movl   $0x804350,(%esp)
  801cf8:	e8 fb ed ff ff       	call   800af8 <_panic>
	// Hint:
	//   You should make three system calls.
	//   No need to explicitly delete the old page's mapping.

	// LAB 4: Your code here.
	if ((r = sys_page_alloc(0, (void*)PFTEMP, PTE_P | PTE_U | PTE_W)) < 0)
  801cfd:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  801d04:	00 
  801d05:	c7 44 24 04 00 f0 7f 	movl   $0x7ff000,0x4(%esp)
  801d0c:	00 
  801d0d:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801d14:	e8 42 fe ff ff       	call   801b5b <sys_page_alloc>
  801d19:	85 c0                	test   %eax,%eax
  801d1b:	79 20                	jns    801d3d <pgfault+0x9b>
		panic ("user panic in lib/fork.c - pgfault(): sys_page_alloc: %e", r);
  801d1d:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801d21:	c7 44 24 08 ec 43 80 	movl   $0x8043ec,0x8(%esp)
  801d28:	00 
  801d29:	c7 44 24 04 32 00 00 	movl   $0x32,0x4(%esp)
  801d30:	00 
  801d31:	c7 04 24 50 43 80 00 	movl   $0x804350,(%esp)
  801d38:	e8 bb ed ff ff       	call   800af8 <_panic>
	
	memmove((void*)PFTEMP, (void*)ROUNDDOWN(addr,PGSIZE), PGSIZE);
  801d3d:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  801d43:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
  801d4a:	00 
  801d4b:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801d4f:	c7 04 24 00 f0 7f 00 	movl   $0x7ff000,(%esp)
  801d56:	e8 ca f7 ff ff       	call   801525 <memmove>
		
	if ((r = sys_page_map(0, (void*)PFTEMP, 0, (void*)ROUNDDOWN(addr,PGSIZE), PTE_P | PTE_U | PTE_W)) < 0)	
  801d5b:	c7 44 24 10 07 00 00 	movl   $0x7,0x10(%esp)
  801d62:	00 
  801d63:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  801d67:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801d6e:	00 
  801d6f:	c7 44 24 04 00 f0 7f 	movl   $0x7ff000,0x4(%esp)
  801d76:	00 
  801d77:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801d7e:	e8 7a fd ff ff       	call   801afd <sys_page_map>
  801d83:	85 c0                	test   %eax,%eax
  801d85:	79 20                	jns    801da7 <pgfault+0x105>
		panic ("user panic in lib/fork.c - pgfault(): sys_page_map: %e", r);
  801d87:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801d8b:	c7 44 24 08 28 44 80 	movl   $0x804428,0x8(%esp)
  801d92:	00 
  801d93:	c7 44 24 04 37 00 00 	movl   $0x37,0x4(%esp)
  801d9a:	00 
  801d9b:	c7 04 24 50 43 80 00 	movl   $0x804350,(%esp)
  801da2:	e8 51 ed ff ff       	call   800af8 <_panic>
	if ((r = sys_page_unmap(0, (void*)PFTEMP)) < 0)
  801da7:	c7 44 24 04 00 f0 7f 	movl   $0x7ff000,0x4(%esp)
  801dae:	00 
  801daf:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801db6:	e8 e4 fc ff ff       	call   801a9f <sys_page_unmap>
  801dbb:	85 c0                	test   %eax,%eax
  801dbd:	79 20                	jns    801ddf <pgfault+0x13d>
		panic ("user panic in lib/fork.c - pgfault(): sys_page_unmap: %e", r);
  801dbf:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801dc3:	c7 44 24 08 60 44 80 	movl   $0x804460,0x8(%esp)
  801dca:	00 
  801dcb:	c7 44 24 04 39 00 00 	movl   $0x39,0x4(%esp)
  801dd2:	00 
  801dd3:	c7 04 24 50 43 80 00 	movl   $0x804350,(%esp)
  801dda:	e8 19 ed ff ff       	call   800af8 <_panic>
	// panic("pgfault not implemented");
}
  801ddf:	83 c4 24             	add    $0x24,%esp
  801de2:	5b                   	pop    %ebx
  801de3:	5d                   	pop    %ebp
  801de4:	c3                   	ret    

00801de5 <fork>:
//   Neither user exception stack should ever be marked copy-on-write,
//   so you must allocate a new page for the child's user exception stack.
//
envid_t
fork(void)
{
  801de5:	55                   	push   %ebp
  801de6:	89 e5                	mov    %esp,%ebp
  801de8:	57                   	push   %edi
  801de9:	56                   	push   %esi
  801dea:	53                   	push   %ebx
  801deb:	83 ec 3c             	sub    $0x3c,%esp
	int r;
	uint32_t pde_x, pte_x, vpn;	// page directory index, page table index and page number
	

	// Set up our page fault handler appropriately.
	set_pgfault_handler(pgfault);
  801dee:	c7 04 24 a2 1c 80 00 	movl   $0x801ca2,(%esp)
  801df5:	e8 76 1b 00 00       	call   803970 <set_pgfault_handler>
static __inline envid_t sys_exofork(void) __attribute__((always_inline));
static __inline envid_t
sys_exofork(void)
{
	envid_t ret;
	__asm __volatile("int %2"
  801dfa:	ba 07 00 00 00       	mov    $0x7,%edx
  801dff:	89 d0                	mov    %edx,%eax
  801e01:	cd 30                	int    $0x30
  801e03:	89 45 e0             	mov    %eax,-0x20(%ebp)
		cprintf("\n After set_pgfaulthandler()\n");
	// Create a child.
	child_envid = sys_exofork();
	if (debug)
		cprintf("\n After exofork()\n");
	if (child_envid < 0)
  801e06:	85 c0                	test   %eax,%eax
  801e08:	0f 88 21 02 00 00    	js     80202f <fork+0x24a>
	if (child_envid == 0)
	{
		if (debug)
			cprintf("\n After child_envid == 0\n");
		env = &envs[ENVX(sys_getenvid())];
		return 0;
  801e0e:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
		return child_envid;
	if (debug)
		cprintf("\n After child_envid >= 0\n");
		// panic(" panic in lib/fork.c - fork():sys_exofork: %e", child_env);
	// fix "env" in the child process
	if (child_envid == 0)
  801e15:	85 c0                	test   %eax,%eax
  801e17:	75 1c                	jne    801e35 <fork+0x50>
	{
		if (debug)
			cprintf("\n After child_envid == 0\n");
		env = &envs[ENVX(sys_getenvid())];
  801e19:	e8 d0 fd ff ff       	call   801bee <sys_getenvid>
  801e1e:	25 ff 03 00 00       	and    $0x3ff,%eax
  801e23:	6b c0 7c             	imul   $0x7c,%eax,%eax
  801e26:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  801e2b:	a3 a0 84 80 00       	mov    %eax,0x8084a0
		return 0;
  801e30:	e9 fa 01 00 00       	jmp    80202f <fork+0x24a>
	// Map the address space except the user exception stack
	if (debug)
		cprintf("\n After child_envid > 0\n");
	for (pde_x = VPD(0); pde_x < VPD(UTOP); pde_x++)
	{
		if ((vpd[pde_x] & PTE_P) == PTE_P)
  801e35:	8b 55 dc             	mov    -0x24(%ebp),%edx
  801e38:	8b 04 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%eax
  801e3f:	a8 01                	test   $0x1,%al
  801e41:	0f 84 16 01 00 00    	je     801f5d <fork+0x178>
		{
			for (pte_x = 0; pte_x < NPTENTRIES; pte_x++)
			{
				vpn = (pde_x << (PDXSHIFT - PTXSHIFT)) + pte_x;		//removed hardcoding
  801e47:	89 d3                	mov    %edx,%ebx
  801e49:	c1 e3 0a             	shl    $0xa,%ebx
  801e4c:	89 d7                	mov    %edx,%edi
  801e4e:	c1 e7 16             	shl    $0x16,%edi
  801e51:	be 00 00 00 00       	mov    $0x0,%esi
				if(((vpt[vpn] & PTE_P) == PTE_P) && (vpn < VPN(UXSTACKTOP - PGSIZE)))
  801e56:	8b 04 9d 00 00 40 ef 	mov    -0x10c00000(,%ebx,4),%eax
  801e5d:	a8 01                	test   $0x1,%al
  801e5f:	0f 84 e0 00 00 00    	je     801f45 <fork+0x160>
  801e65:	81 fb fe eb 0e 00    	cmp    $0xeebfe,%ebx
  801e6b:	0f 87 d4 00 00 00    	ja     801f45 <fork+0x160>
	
	// LAB 4: Your code here.
	if (debug)
		cprintf("\n duppage: 1\n");	

	pte_t pte = vpt[pn];
  801e71:	8b 14 9d 00 00 40 ef 	mov    -0x10c00000(,%ebx,4),%edx
	int perm = pte & PTE_USER;
  801e78:	89 d0                	mov    %edx,%eax
  801e7a:	25 07 0e 00 00       	and    $0xe07,%eax
	void *va = (void*) (pn*PGSIZE);	
	if (debug)
		cprintf("\n duppage: 2\n");	
	
	if ((perm & PTE_P) != PTE_P)
  801e7f:	f6 c2 01             	test   $0x1,%dl
  801e82:	75 1c                	jne    801ea0 <fork+0xbb>
		panic ("user panic: lib\fork.c: duppage(): page to be duplicated is not PTE_P\n");
  801e84:	c7 44 24 08 9c 44 80 	movl   $0x80449c,0x8(%esp)
  801e8b:	00 
  801e8c:	c7 44 24 04 58 00 00 	movl   $0x58,0x4(%esp)
  801e93:	00 
  801e94:	c7 04 24 50 43 80 00 	movl   $0x804350,(%esp)
  801e9b:	e8 58 ec ff ff       	call   800af8 <_panic>
	if ((perm & PTE_U) != PTE_U)
  801ea0:	a8 04                	test   $0x4,%al
  801ea2:	75 1c                	jne    801ec0 <fork+0xdb>
		panic ("user panic: lib\fork.c: duppage(): page to be duplicated is not PTE_U\n");
  801ea4:	c7 44 24 08 e4 44 80 	movl   $0x8044e4,0x8(%esp)
  801eab:	00 
  801eac:	c7 44 24 04 5a 00 00 	movl   $0x5a,0x4(%esp)
  801eb3:	00 
  801eb4:	c7 04 24 50 43 80 00 	movl   $0x804350,(%esp)
  801ebb:	e8 38 ec ff ff       	call   800af8 <_panic>
  801ec0:	89 7d e4             	mov    %edi,-0x1c(%ebp)
	if (debug)
		cprintf("\n duppage: 3\n");	

	// LAB 7: Include PTE_SHARE convention
	if ( !(perm & PTE_SHARE) && (((perm & PTE_W) == PTE_W) || ((perm & PTE_COW) == PTE_COW)))
  801ec3:	f6 c4 04             	test   $0x4,%ah
  801ec6:	75 5b                	jne    801f23 <fork+0x13e>
  801ec8:	a9 02 08 00 00       	test   $0x802,%eax
  801ecd:	74 54                	je     801f23 <fork+0x13e>
	{
		if (debug)
			cprintf("\n duppage: 4\n");	
		// perm = PTE_P | PTE_U | PTE_COW;	// buggy permissions, removed in LAB 7
		perm &= ~PTE_W;				// remove write from perm
  801ecf:	83 e0 fd             	and    $0xfffffffd,%eax
		perm |= PTE_COW;			// add copy-on-write
  801ed2:	80 cc 08             	or     $0x8,%ah
  801ed5:	89 45 d8             	mov    %eax,-0x28(%ebp)
		if (debug)
			cprintf("\n duppage: 10\n");	
		if ((r = sys_page_map(0, va, envid, va, perm)) < 0)
  801ed8:	89 44 24 10          	mov    %eax,0x10(%esp)
  801edc:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  801ee0:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801ee3:	89 54 24 08          	mov    %edx,0x8(%esp)
  801ee7:	89 7c 24 04          	mov    %edi,0x4(%esp)
  801eeb:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801ef2:	e8 06 fc ff ff       	call   801afd <sys_page_map>
  801ef7:	85 c0                	test   %eax,%eax
  801ef9:	78 4a                	js     801f45 <fork+0x160>
			return r;
		if (debug)
			cprintf("\n duppage: 11\n");	
		if ((r = sys_page_map(0, va, 0, va, perm)) < 0)
  801efb:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801efe:	89 44 24 10          	mov    %eax,0x10(%esp)
  801f02:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801f05:	89 54 24 0c          	mov    %edx,0xc(%esp)
  801f09:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801f10:	00 
  801f11:	89 54 24 04          	mov    %edx,0x4(%esp)
  801f15:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801f1c:	e8 dc fb ff ff       	call   801afd <sys_page_map>
  801f21:	eb 22                	jmp    801f45 <fork+0x160>
	// LAB 7: Include PTE_SHARE convention
	else
	{
		if (debug)
			cprintf("\n duppage: 6\n");	
		if ((r = sys_page_map(0, va, envid, va, perm)) < 0)
  801f23:	89 44 24 10          	mov    %eax,0x10(%esp)
  801f27:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801f2a:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801f2e:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801f31:	89 54 24 08          	mov    %edx,0x8(%esp)
  801f35:	89 44 24 04          	mov    %eax,0x4(%esp)
  801f39:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801f40:	e8 b8 fb ff ff       	call   801afd <sys_page_map>
		cprintf("\n After child_envid > 0\n");
	for (pde_x = VPD(0); pde_x < VPD(UTOP); pde_x++)
	{
		if ((vpd[pde_x] & PTE_P) == PTE_P)
		{
			for (pte_x = 0; pte_x < NPTENTRIES; pte_x++)
  801f45:	83 c6 01             	add    $0x1,%esi
  801f48:	83 c3 01             	add    $0x1,%ebx
  801f4b:	81 c7 00 10 00 00    	add    $0x1000,%edi
  801f51:	81 fe 00 04 00 00    	cmp    $0x400,%esi
  801f57:	0f 85 f9 fe ff ff    	jne    801e56 <fork+0x71>
	}
	// reached here... we're the parent process
	// Map the address space except the user exception stack
	if (debug)
		cprintf("\n After child_envid > 0\n");
	for (pde_x = VPD(0); pde_x < VPD(UTOP); pde_x++)
  801f5d:	83 45 dc 01          	addl   $0x1,-0x24(%ebp)
  801f61:	81 7d dc bb 03 00 00 	cmpl   $0x3bb,-0x24(%ebp)
  801f68:	0f 85 c7 fe ff ff    	jne    801e35 <fork+0x50>
	}	
	if (debug)
		cprintf("\n After duppaging()\n");
	// Allocate and copy the use exception stack for the child environment
	// Allocate a page for the stack in the child
	if ((r = sys_page_alloc(child_envid, (void*)(UXSTACKTOP - PGSIZE), PTE_P | PTE_U | PTE_W)) < 0)
  801f6e:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  801f75:	00 
  801f76:	c7 44 24 04 00 f0 bf 	movl   $0xeebff000,0x4(%esp)
  801f7d:	ee 
  801f7e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801f81:	89 04 24             	mov    %eax,(%esp)
  801f84:	e8 d2 fb ff ff       	call   801b5b <sys_page_alloc>
  801f89:	85 c0                	test   %eax,%eax
  801f8b:	79 08                	jns    801f95 <fork+0x1b0>
  801f8d:	89 45 e0             	mov    %eax,-0x20(%ebp)
  801f90:	e9 9a 00 00 00       	jmp    80202f <fork+0x24a>
		return r;
	if (debug)
		cprintf("\n After set_pgfaulthandler()\n");
	// Map this page to a free virtual address space in parent
	if ((r = sys_page_map(child_envid, (void*)(UXSTACKTOP - PGSIZE), 0, (void*)UTEMP, PTE_P | PTE_U | PTE_W)) < 0)
  801f95:	c7 44 24 10 07 00 00 	movl   $0x7,0x10(%esp)
  801f9c:	00 
  801f9d:	c7 44 24 0c 00 00 40 	movl   $0x400000,0xc(%esp)
  801fa4:	00 
  801fa5:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801fac:	00 
  801fad:	c7 44 24 04 00 f0 bf 	movl   $0xeebff000,0x4(%esp)
  801fb4:	ee 
  801fb5:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801fb8:	89 14 24             	mov    %edx,(%esp)
  801fbb:	e8 3d fb ff ff       	call   801afd <sys_page_map>
  801fc0:	85 c0                	test   %eax,%eax
  801fc2:	79 05                	jns    801fc9 <fork+0x1e4>
  801fc4:	89 45 e0             	mov    %eax,-0x20(%ebp)
  801fc7:	eb 66                	jmp    80202f <fork+0x24a>
		return r;
	if (debug)
		cprintf("\n After sys_page_map()\n");
	// Copy the parent exception stack to the above, i.e. page from child mapped to parent's address space
	memmove((void*)UTEMP, (void*)(UXSTACKTOP - PGSIZE), PGSIZE);
  801fc9:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
  801fd0:	00 
  801fd1:	c7 44 24 04 00 f0 bf 	movl   $0xeebff000,0x4(%esp)
  801fd8:	ee 
  801fd9:	c7 04 24 00 00 40 00 	movl   $0x400000,(%esp)
  801fe0:	e8 40 f5 ff ff       	call   801525 <memmove>
	if (debug)
		cprintf("\n After memmove()\n");
	// Unmap this page from the parent
	sys_page_unmap(0, (void*)UTEMP);
  801fe5:	c7 44 24 04 00 00 40 	movl   $0x400000,0x4(%esp)
  801fec:	00 
  801fed:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801ff4:	e8 a6 fa ff ff       	call   801a9f <sys_page_unmap>
	if (debug)
		cprintf("\n After sys_page_unmap()\n");

	// Set up the page fault handler
	if ((r = sys_env_set_pgfault_upcall(child_envid, _pgfault_upcall)) < 0)
  801ff9:	c7 44 24 04 04 3a 80 	movl   $0x803a04,0x4(%esp)
  802000:	00 
  802001:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802004:	89 04 24             	mov    %eax,(%esp)
  802007:	e8 79 f9 ff ff       	call   801985 <sys_env_set_pgfault_upcall>
  80200c:	85 c0                	test   %eax,%eax
  80200e:	79 05                	jns    802015 <fork+0x230>
  802010:	89 45 e0             	mov    %eax,-0x20(%ebp)
  802013:	eb 1a                	jmp    80202f <fork+0x24a>
		// panic(" panic in lib/fork.c - fork():sys_env_set_pgfault_upcall: %e", child_env);
	if (debug)
		cprintf("\n After set_upcall()\n");

	// Mark the child runnable
	if ((r = sys_env_set_status(child_envid, ENV_RUNNABLE)) < 0)
  802015:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  80201c:	00 
  80201d:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802020:	89 14 24             	mov    %edx,(%esp)
  802023:	e8 19 fa ff ff       	call   801a41 <sys_env_set_status>
  802028:	85 c0                	test   %eax,%eax
  80202a:	79 03                	jns    80202f <fork+0x24a>
  80202c:	89 45 e0             	mov    %eax,-0x20(%ebp)
	if (debug)
		cprintf("\n After set_status()\n");
	
	return child_envid;
	
}
  80202f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802032:	83 c4 3c             	add    $0x3c,%esp
  802035:	5b                   	pop    %ebx
  802036:	5e                   	pop    %esi
  802037:	5f                   	pop    %edi
  802038:	5d                   	pop    %ebp
  802039:	c3                   	ret    
  80203a:	00 00                	add    %al,(%eax)
  80203c:	00 00                	add    %al,(%eax)
	...

00802040 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  802040:	55                   	push   %ebp
  802041:	89 e5                	mov    %esp,%ebp
  802043:	8b 45 08             	mov    0x8(%ebp),%eax
  802046:	05 00 00 00 30       	add    $0x30000000,%eax
  80204b:	c1 e8 0c             	shr    $0xc,%eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
}
  80204e:	5d                   	pop    %ebp
  80204f:	c3                   	ret    

00802050 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  802050:	55                   	push   %ebp
  802051:	89 e5                	mov    %esp,%ebp
  802053:	83 ec 04             	sub    $0x4,%esp
	return INDEX2DATA(fd2num(fd));
  802056:	8b 45 08             	mov    0x8(%ebp),%eax
  802059:	89 04 24             	mov    %eax,(%esp)
  80205c:	e8 df ff ff ff       	call   802040 <fd2num>
  802061:	05 20 00 0d 00       	add    $0xd0020,%eax
  802066:	c1 e0 0c             	shl    $0xc,%eax
}
  802069:	c9                   	leave  
  80206a:	c3                   	ret    

0080206b <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  80206b:	55                   	push   %ebp
  80206c:	89 e5                	mov    %esp,%ebp
  80206e:	57                   	push   %edi
  80206f:	56                   	push   %esi
  802070:	53                   	push   %ebx
  802071:	8b 7d 08             	mov    0x8(%ebp),%edi
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((vpd[PDX(fd)] & PTE_P) == 0 || (vpt[VPN(fd)] & PTE_P) == 0) {
  802074:	a1 00 dd 7b ef       	mov    0xef7bdd00,%eax
  802079:	a8 01                	test   $0x1,%al
  80207b:	74 36                	je     8020b3 <fd_alloc+0x48>
  80207d:	a1 00 00 74 ef       	mov    0xef740000,%eax
  802082:	a8 01                	test   $0x1,%al
  802084:	74 2d                	je     8020b3 <fd_alloc+0x48>
  802086:	b8 00 10 00 d0       	mov    $0xd0001000,%eax
  80208b:	b9 00 d0 7b ef       	mov    $0xef7bd000,%ecx
  802090:	be 00 00 40 ef       	mov    $0xef400000,%esi
  802095:	89 c3                	mov    %eax,%ebx
  802097:	89 c2                	mov    %eax,%edx
  802099:	c1 ea 16             	shr    $0x16,%edx
  80209c:	8b 14 91             	mov    (%ecx,%edx,4),%edx
  80209f:	f6 c2 01             	test   $0x1,%dl
  8020a2:	74 14                	je     8020b8 <fd_alloc+0x4d>
  8020a4:	89 c2                	mov    %eax,%edx
  8020a6:	c1 ea 0c             	shr    $0xc,%edx
  8020a9:	8b 14 96             	mov    (%esi,%edx,4),%edx
  8020ac:	f6 c2 01             	test   $0x1,%dl
  8020af:	75 10                	jne    8020c1 <fd_alloc+0x56>
  8020b1:	eb 05                	jmp    8020b8 <fd_alloc+0x4d>
  8020b3:	bb 00 00 00 d0       	mov    $0xd0000000,%ebx
			*fd_store = fd;
  8020b8:	89 1f                	mov    %ebx,(%edi)
  8020ba:	b8 00 00 00 00       	mov    $0x0,%eax
			return 0;
  8020bf:	eb 17                	jmp    8020d8 <fd_alloc+0x6d>
  8020c1:	05 00 10 00 00       	add    $0x1000,%eax
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  8020c6:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  8020cb:	75 c8                	jne    802095 <fd_alloc+0x2a>
		if ((vpd[PDX(fd)] & PTE_P) == 0 || (vpt[VPN(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  8020cd:	c7 07 00 00 00 00    	movl   $0x0,(%edi)
  8020d3:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
	return -E_MAX_OPEN;
}
  8020d8:	5b                   	pop    %ebx
  8020d9:	5e                   	pop    %esi
  8020da:	5f                   	pop    %edi
  8020db:	5d                   	pop    %ebp
  8020dc:	c3                   	ret    

008020dd <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  8020dd:	55                   	push   %ebp
  8020de:	89 e5                	mov    %esp,%ebp
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  8020e0:	8b 45 08             	mov    0x8(%ebp),%eax
  8020e3:	83 f8 1f             	cmp    $0x1f,%eax
  8020e6:	77 36                	ja     80211e <fd_lookup+0x41>
		if (debug)
			cprintf("[%08x] bad fd %d\n", env->env_id, fd);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  8020e8:	05 00 00 0d 00       	add    $0xd0000,%eax
  8020ed:	c1 e0 0c             	shl    $0xc,%eax
	if (!(vpd[PDX(fd)] & PTE_P) || !(vpt[VPN(fd)] & PTE_P)) {
  8020f0:	89 c2                	mov    %eax,%edx
  8020f2:	c1 ea 16             	shr    $0x16,%edx
  8020f5:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  8020fc:	f6 c2 01             	test   $0x1,%dl
  8020ff:	74 1d                	je     80211e <fd_lookup+0x41>
  802101:	89 c2                	mov    %eax,%edx
  802103:	c1 ea 0c             	shr    $0xc,%edx
  802106:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  80210d:	f6 c2 01             	test   $0x1,%dl
  802110:	74 0c                	je     80211e <fd_lookup+0x41>
		if (debug)
			cprintf("[%08x] closed fd %d\n", env->env_id, fd);
		return -E_INVAL;
	}
	*fd_store = fd;
  802112:	8b 55 0c             	mov    0xc(%ebp),%edx
  802115:	89 02                	mov    %eax,(%edx)
  802117:	b8 00 00 00 00       	mov    $0x0,%eax
	return 0;
  80211c:	eb 05                	jmp    802123 <fd_lookup+0x46>
  80211e:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  802123:	5d                   	pop    %ebp
  802124:	c3                   	ret    

00802125 <seek>:
	return (*dev->dev_write)(fd, buf, n);
}

int
seek(int fdnum, off_t offset)
{
  802125:	55                   	push   %ebp
  802126:	89 e5                	mov    %esp,%ebp
  802128:	83 ec 18             	sub    $0x18,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80212b:	8d 45 fc             	lea    -0x4(%ebp),%eax
  80212e:	89 44 24 04          	mov    %eax,0x4(%esp)
  802132:	8b 45 08             	mov    0x8(%ebp),%eax
  802135:	89 04 24             	mov    %eax,(%esp)
  802138:	e8 a0 ff ff ff       	call   8020dd <fd_lookup>
  80213d:	85 c0                	test   %eax,%eax
  80213f:	78 0e                	js     80214f <seek+0x2a>
		return r;
	fd->fd_offset = offset;
  802141:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802144:	8b 55 0c             	mov    0xc(%ebp),%edx
  802147:	89 50 04             	mov    %edx,0x4(%eax)
  80214a:	b8 00 00 00 00       	mov    $0x0,%eax
	return 0;
}
  80214f:	c9                   	leave  
  802150:	c3                   	ret    

00802151 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  802151:	55                   	push   %ebp
  802152:	89 e5                	mov    %esp,%ebp
  802154:	56                   	push   %esi
  802155:	53                   	push   %ebx
  802156:	83 ec 10             	sub    $0x10,%esp
  802159:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80215c:	8b 5d 0c             	mov    0xc(%ebp),%ebx
// File functions
// --------------------------------------------------------------

static struct Dev *devtab[] =
{
	&devfile,
  80215f:	b8 20 80 80 00       	mov    $0x808020,%eax
{
	int i;
	for (i = 0; devtab[i]; i++)
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
  802164:	ba 00 00 00 00       	mov    $0x0,%edx

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  802169:	be a8 45 80 00       	mov    $0x8045a8,%esi
		if (devtab[i]->dev_id == dev_id) {
  80216e:	39 08                	cmp    %ecx,(%eax)
  802170:	75 10                	jne    802182 <dev_lookup+0x31>
  802172:	eb 04                	jmp    802178 <dev_lookup+0x27>
  802174:	39 08                	cmp    %ecx,(%eax)
  802176:	75 0a                	jne    802182 <dev_lookup+0x31>
			*dev = devtab[i];
  802178:	89 03                	mov    %eax,(%ebx)
  80217a:	b8 00 00 00 00       	mov    $0x0,%eax
			return 0;
  80217f:	90                   	nop
  802180:	eb 31                	jmp    8021b3 <dev_lookup+0x62>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  802182:	83 c2 01             	add    $0x1,%edx
  802185:	8b 04 96             	mov    (%esi,%edx,4),%eax
  802188:	85 c0                	test   %eax,%eax
  80218a:	75 e8                	jne    802174 <dev_lookup+0x23>
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", env->env_id, dev_id);
  80218c:	a1 a0 84 80 00       	mov    0x8084a0,%eax
  802191:	8b 40 4c             	mov    0x4c(%eax),%eax
  802194:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802198:	89 44 24 04          	mov    %eax,0x4(%esp)
  80219c:	c7 04 24 2c 45 80 00 	movl   $0x80452c,(%esp)
  8021a3:	e8 15 ea ff ff       	call   800bbd <cprintf>
	*dev = 0;
  8021a8:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  8021ae:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
	return -E_INVAL;
}
  8021b3:	83 c4 10             	add    $0x10,%esp
  8021b6:	5b                   	pop    %ebx
  8021b7:	5e                   	pop    %esi
  8021b8:	5d                   	pop    %ebp
  8021b9:	c3                   	ret    

008021ba <fstat>:
	return (*dev->dev_trunc)(fd, newsize);
}

int
fstat(int fdnum, struct Stat *stat)
{
  8021ba:	55                   	push   %ebp
  8021bb:	89 e5                	mov    %esp,%ebp
  8021bd:	53                   	push   %ebx
  8021be:	83 ec 24             	sub    $0x24,%esp
  8021c1:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8021c4:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8021c7:	89 44 24 04          	mov    %eax,0x4(%esp)
  8021cb:	8b 45 08             	mov    0x8(%ebp),%eax
  8021ce:	89 04 24             	mov    %eax,(%esp)
  8021d1:	e8 07 ff ff ff       	call   8020dd <fd_lookup>
  8021d6:	85 c0                	test   %eax,%eax
  8021d8:	78 53                	js     80222d <fstat+0x73>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8021da:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8021dd:	89 44 24 04          	mov    %eax,0x4(%esp)
  8021e1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8021e4:	8b 00                	mov    (%eax),%eax
  8021e6:	89 04 24             	mov    %eax,(%esp)
  8021e9:	e8 63 ff ff ff       	call   802151 <dev_lookup>
{
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8021ee:	85 c0                	test   %eax,%eax
  8021f0:	78 3b                	js     80222d <fstat+0x73>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if (!dev->dev_stat)
  8021f2:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8021f7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8021fa:	83 7a 14 00          	cmpl   $0x0,0x14(%edx)
  8021fe:	74 2d                	je     80222d <fstat+0x73>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  802200:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  802203:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  80220a:	00 00 00 
	stat->st_isdir = 0;
  80220d:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  802214:	00 00 00 
	stat->st_dev = dev;
  802217:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80221a:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  802220:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  802224:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802227:	89 14 24             	mov    %edx,(%esp)
  80222a:	ff 50 14             	call   *0x14(%eax)
}
  80222d:	83 c4 24             	add    $0x24,%esp
  802230:	5b                   	pop    %ebx
  802231:	5d                   	pop    %ebp
  802232:	c3                   	ret    

00802233 <ftruncate>:
	return 0;
}

int
ftruncate(int fdnum, off_t newsize)
{
  802233:	55                   	push   %ebp
  802234:	89 e5                	mov    %esp,%ebp
  802236:	53                   	push   %ebx
  802237:	83 ec 24             	sub    $0x24,%esp
  80223a:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  80223d:	8d 45 f0             	lea    -0x10(%ebp),%eax
  802240:	89 44 24 04          	mov    %eax,0x4(%esp)
  802244:	89 1c 24             	mov    %ebx,(%esp)
  802247:	e8 91 fe ff ff       	call   8020dd <fd_lookup>
  80224c:	85 c0                	test   %eax,%eax
  80224e:	78 5f                	js     8022af <ftruncate+0x7c>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802250:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802253:	89 44 24 04          	mov    %eax,0x4(%esp)
  802257:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80225a:	8b 00                	mov    (%eax),%eax
  80225c:	89 04 24             	mov    %eax,(%esp)
  80225f:	e8 ed fe ff ff       	call   802151 <dev_lookup>
ftruncate(int fdnum, off_t newsize)
{
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  802264:	85 c0                	test   %eax,%eax
  802266:	78 47                	js     8022af <ftruncate+0x7c>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  802268:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80226b:	f6 42 08 03          	testb  $0x3,0x8(%edx)
  80226f:	75 23                	jne    802294 <ftruncate+0x61>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			env->env_id, fdnum); 
  802271:	a1 a0 84 80 00       	mov    0x8084a0,%eax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  802276:	8b 40 4c             	mov    0x4c(%eax),%eax
  802279:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80227d:	89 44 24 04          	mov    %eax,0x4(%esp)
  802281:	c7 04 24 4c 45 80 00 	movl   $0x80454c,(%esp)
  802288:	e8 30 e9 ff ff       	call   800bbd <cprintf>
  80228d:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
			env->env_id, fdnum); 
		return -E_INVAL;
  802292:	eb 1b                	jmp    8022af <ftruncate+0x7c>
	}
	if (!dev->dev_trunc)
  802294:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802297:	8b 48 18             	mov    0x18(%eax),%ecx
  80229a:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  80229f:	85 c9                	test   %ecx,%ecx
  8022a1:	74 0c                	je     8022af <ftruncate+0x7c>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  8022a3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8022a6:	89 44 24 04          	mov    %eax,0x4(%esp)
  8022aa:	89 14 24             	mov    %edx,(%esp)
  8022ad:	ff d1                	call   *%ecx
}
  8022af:	83 c4 24             	add    $0x24,%esp
  8022b2:	5b                   	pop    %ebx
  8022b3:	5d                   	pop    %ebp
  8022b4:	c3                   	ret    

008022b5 <write>:
	return tot;
}

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  8022b5:	55                   	push   %ebp
  8022b6:	89 e5                	mov    %esp,%ebp
  8022b8:	53                   	push   %ebx
  8022b9:	83 ec 24             	sub    $0x24,%esp
  8022bc:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8022bf:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8022c2:	89 44 24 04          	mov    %eax,0x4(%esp)
  8022c6:	89 1c 24             	mov    %ebx,(%esp)
  8022c9:	e8 0f fe ff ff       	call   8020dd <fd_lookup>
  8022ce:	85 c0                	test   %eax,%eax
  8022d0:	78 66                	js     802338 <write+0x83>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8022d2:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8022d5:	89 44 24 04          	mov    %eax,0x4(%esp)
  8022d9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8022dc:	8b 00                	mov    (%eax),%eax
  8022de:	89 04 24             	mov    %eax,(%esp)
  8022e1:	e8 6b fe ff ff       	call   802151 <dev_lookup>
{
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8022e6:	85 c0                	test   %eax,%eax
  8022e8:	78 4e                	js     802338 <write+0x83>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8022ea:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8022ed:	f6 42 08 03          	testb  $0x3,0x8(%edx)
  8022f1:	75 23                	jne    802316 <write+0x61>
		cprintf("[%08x] write %d -- bad mode\n", env->env_id, fdnum);
  8022f3:	a1 a0 84 80 00       	mov    0x8084a0,%eax
  8022f8:	8b 40 4c             	mov    0x4c(%eax),%eax
  8022fb:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8022ff:	89 44 24 04          	mov    %eax,0x4(%esp)
  802303:	c7 04 24 6d 45 80 00 	movl   $0x80456d,(%esp)
  80230a:	e8 ae e8 ff ff       	call   800bbd <cprintf>
  80230f:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
		return -E_INVAL;
  802314:	eb 22                	jmp    802338 <write+0x83>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  802316:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802319:	8b 48 0c             	mov    0xc(%eax),%ecx
  80231c:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  802321:	85 c9                	test   %ecx,%ecx
  802323:	74 13                	je     802338 <write+0x83>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  802325:	8b 45 10             	mov    0x10(%ebp),%eax
  802328:	89 44 24 08          	mov    %eax,0x8(%esp)
  80232c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80232f:	89 44 24 04          	mov    %eax,0x4(%esp)
  802333:	89 14 24             	mov    %edx,(%esp)
  802336:	ff d1                	call   *%ecx
}
  802338:	83 c4 24             	add    $0x24,%esp
  80233b:	5b                   	pop    %ebx
  80233c:	5d                   	pop    %ebp
  80233d:	c3                   	ret    

0080233e <read>:
	return r;
}

ssize_t
read(int fdnum, void *buf, size_t n)
{
  80233e:	55                   	push   %ebp
  80233f:	89 e5                	mov    %esp,%ebp
  802341:	53                   	push   %ebx
  802342:	83 ec 24             	sub    $0x24,%esp
  802345:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  802348:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80234b:	89 44 24 04          	mov    %eax,0x4(%esp)
  80234f:	89 1c 24             	mov    %ebx,(%esp)
  802352:	e8 86 fd ff ff       	call   8020dd <fd_lookup>
  802357:	85 c0                	test   %eax,%eax
  802359:	78 6b                	js     8023c6 <read+0x88>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80235b:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80235e:	89 44 24 04          	mov    %eax,0x4(%esp)
  802362:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802365:	8b 00                	mov    (%eax),%eax
  802367:	89 04 24             	mov    %eax,(%esp)
  80236a:	e8 e2 fd ff ff       	call   802151 <dev_lookup>
{
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80236f:	85 c0                	test   %eax,%eax
  802371:	78 53                	js     8023c6 <read+0x88>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  802373:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802376:	8b 42 08             	mov    0x8(%edx),%eax
  802379:	83 e0 03             	and    $0x3,%eax
  80237c:	83 f8 01             	cmp    $0x1,%eax
  80237f:	75 23                	jne    8023a4 <read+0x66>
		cprintf("[%08x] read %d -- bad mode\n", env->env_id, fdnum); 
  802381:	a1 a0 84 80 00       	mov    0x8084a0,%eax
  802386:	8b 40 4c             	mov    0x4c(%eax),%eax
  802389:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80238d:	89 44 24 04          	mov    %eax,0x4(%esp)
  802391:	c7 04 24 8a 45 80 00 	movl   $0x80458a,(%esp)
  802398:	e8 20 e8 ff ff       	call   800bbd <cprintf>
  80239d:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
		return -E_INVAL;
  8023a2:	eb 22                	jmp    8023c6 <read+0x88>
	}
	if (!dev->dev_read)
  8023a4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023a7:	8b 48 08             	mov    0x8(%eax),%ecx
  8023aa:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8023af:	85 c9                	test   %ecx,%ecx
  8023b1:	74 13                	je     8023c6 <read+0x88>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  8023b3:	8b 45 10             	mov    0x10(%ebp),%eax
  8023b6:	89 44 24 08          	mov    %eax,0x8(%esp)
  8023ba:	8b 45 0c             	mov    0xc(%ebp),%eax
  8023bd:	89 44 24 04          	mov    %eax,0x4(%esp)
  8023c1:	89 14 24             	mov    %edx,(%esp)
  8023c4:	ff d1                	call   *%ecx
}
  8023c6:	83 c4 24             	add    $0x24,%esp
  8023c9:	5b                   	pop    %ebx
  8023ca:	5d                   	pop    %ebp
  8023cb:	c3                   	ret    

008023cc <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  8023cc:	55                   	push   %ebp
  8023cd:	89 e5                	mov    %esp,%ebp
  8023cf:	57                   	push   %edi
  8023d0:	56                   	push   %esi
  8023d1:	53                   	push   %ebx
  8023d2:	83 ec 1c             	sub    $0x1c,%esp
  8023d5:	8b 7d 08             	mov    0x8(%ebp),%edi
  8023d8:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  8023db:	ba 00 00 00 00       	mov    $0x0,%edx
  8023e0:	bb 00 00 00 00       	mov    $0x0,%ebx
  8023e5:	b8 00 00 00 00       	mov    $0x0,%eax
  8023ea:	85 f6                	test   %esi,%esi
  8023ec:	74 29                	je     802417 <readn+0x4b>
		m = read(fdnum, (char*)buf + tot, n - tot);
  8023ee:	89 f0                	mov    %esi,%eax
  8023f0:	29 d0                	sub    %edx,%eax
  8023f2:	89 44 24 08          	mov    %eax,0x8(%esp)
  8023f6:	03 55 0c             	add    0xc(%ebp),%edx
  8023f9:	89 54 24 04          	mov    %edx,0x4(%esp)
  8023fd:	89 3c 24             	mov    %edi,(%esp)
  802400:	e8 39 ff ff ff       	call   80233e <read>
		if (m < 0)
  802405:	85 c0                	test   %eax,%eax
  802407:	78 0e                	js     802417 <readn+0x4b>
			return m;
		if (m == 0)
  802409:	85 c0                	test   %eax,%eax
  80240b:	74 08                	je     802415 <readn+0x49>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  80240d:	01 c3                	add    %eax,%ebx
  80240f:	89 da                	mov    %ebx,%edx
  802411:	39 f3                	cmp    %esi,%ebx
  802413:	72 d9                	jb     8023ee <readn+0x22>
  802415:	89 d8                	mov    %ebx,%eax
			return m;
		if (m == 0)
			break;
	}
	return tot;
}
  802417:	83 c4 1c             	add    $0x1c,%esp
  80241a:	5b                   	pop    %ebx
  80241b:	5e                   	pop    %esi
  80241c:	5f                   	pop    %edi
  80241d:	5d                   	pop    %ebp
  80241e:	c3                   	ret    

0080241f <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  80241f:	55                   	push   %ebp
  802420:	89 e5                	mov    %esp,%ebp
  802422:	56                   	push   %esi
  802423:	53                   	push   %ebx
  802424:	83 ec 20             	sub    $0x20,%esp
  802427:	8b 75 08             	mov    0x8(%ebp),%esi
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  80242a:	89 34 24             	mov    %esi,(%esp)
  80242d:	e8 0e fc ff ff       	call   802040 <fd2num>
  802432:	8d 55 f4             	lea    -0xc(%ebp),%edx
  802435:	89 54 24 04          	mov    %edx,0x4(%esp)
  802439:	89 04 24             	mov    %eax,(%esp)
  80243c:	e8 9c fc ff ff       	call   8020dd <fd_lookup>
  802441:	89 c3                	mov    %eax,%ebx
  802443:	85 c0                	test   %eax,%eax
  802445:	78 05                	js     80244c <fd_close+0x2d>
  802447:	3b 75 f4             	cmp    -0xc(%ebp),%esi
  80244a:	74 0c                	je     802458 <fd_close+0x39>
	    || fd != fd2)
		return (must_exist ? r : 0);
  80244c:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  802450:	19 c0                	sbb    %eax,%eax
  802452:	f7 d0                	not    %eax
  802454:	21 c3                	and    %eax,%ebx
  802456:	eb 3d                	jmp    802495 <fd_close+0x76>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  802458:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80245b:	89 44 24 04          	mov    %eax,0x4(%esp)
  80245f:	8b 06                	mov    (%esi),%eax
  802461:	89 04 24             	mov    %eax,(%esp)
  802464:	e8 e8 fc ff ff       	call   802151 <dev_lookup>
  802469:	89 c3                	mov    %eax,%ebx
  80246b:	85 c0                	test   %eax,%eax
  80246d:	78 16                	js     802485 <fd_close+0x66>
		if (dev->dev_close)
  80246f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802472:	8b 40 10             	mov    0x10(%eax),%eax
  802475:	bb 00 00 00 00       	mov    $0x0,%ebx
  80247a:	85 c0                	test   %eax,%eax
  80247c:	74 07                	je     802485 <fd_close+0x66>
			r = (*dev->dev_close)(fd);
  80247e:	89 34 24             	mov    %esi,(%esp)
  802481:	ff d0                	call   *%eax
  802483:	89 c3                	mov    %eax,%ebx
		else
			r = 0;
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  802485:	89 74 24 04          	mov    %esi,0x4(%esp)
  802489:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802490:	e8 0a f6 ff ff       	call   801a9f <sys_page_unmap>
	return r;
}
  802495:	89 d8                	mov    %ebx,%eax
  802497:	83 c4 20             	add    $0x20,%esp
  80249a:	5b                   	pop    %ebx
  80249b:	5e                   	pop    %esi
  80249c:	5d                   	pop    %ebp
  80249d:	c3                   	ret    

0080249e <close>:
	return -E_INVAL;
}

int
close(int fdnum)
{
  80249e:	55                   	push   %ebp
  80249f:	89 e5                	mov    %esp,%ebp
  8024a1:	83 ec 28             	sub    $0x28,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8024a4:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8024a7:	89 44 24 04          	mov    %eax,0x4(%esp)
  8024ab:	8b 45 08             	mov    0x8(%ebp),%eax
  8024ae:	89 04 24             	mov    %eax,(%esp)
  8024b1:	e8 27 fc ff ff       	call   8020dd <fd_lookup>
  8024b6:	85 c0                	test   %eax,%eax
  8024b8:	78 13                	js     8024cd <close+0x2f>
		return r;
	else
		return fd_close(fd, 1);
  8024ba:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  8024c1:	00 
  8024c2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024c5:	89 04 24             	mov    %eax,(%esp)
  8024c8:	e8 52 ff ff ff       	call   80241f <fd_close>
}
  8024cd:	c9                   	leave  
  8024ce:	c3                   	ret    

008024cf <stat>:
	return (*dev->dev_stat)(fd, stat);
}

int
stat(const char *path, struct Stat *stat)
{
  8024cf:	55                   	push   %ebp
  8024d0:	89 e5                	mov    %esp,%ebp
  8024d2:	83 ec 18             	sub    $0x18,%esp
  8024d5:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  8024d8:	89 75 fc             	mov    %esi,-0x4(%ebp)
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  8024db:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  8024e2:	00 
  8024e3:	8b 45 08             	mov    0x8(%ebp),%eax
  8024e6:	89 04 24             	mov    %eax,(%esp)
  8024e9:	e8 55 03 00 00       	call   802843 <open>
  8024ee:	89 c3                	mov    %eax,%ebx
  8024f0:	85 c0                	test   %eax,%eax
  8024f2:	78 1b                	js     80250f <stat+0x40>
		return fd;
	r = fstat(fd, stat);
  8024f4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8024f7:	89 44 24 04          	mov    %eax,0x4(%esp)
  8024fb:	89 1c 24             	mov    %ebx,(%esp)
  8024fe:	e8 b7 fc ff ff       	call   8021ba <fstat>
  802503:	89 c6                	mov    %eax,%esi
	close(fd);
  802505:	89 1c 24             	mov    %ebx,(%esp)
  802508:	e8 91 ff ff ff       	call   80249e <close>
  80250d:	89 f3                	mov    %esi,%ebx
	return r;
}
  80250f:	89 d8                	mov    %ebx,%eax
  802511:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  802514:	8b 75 fc             	mov    -0x4(%ebp),%esi
  802517:	89 ec                	mov    %ebp,%esp
  802519:	5d                   	pop    %ebp
  80251a:	c3                   	ret    

0080251b <close_all>:
		return fd_close(fd, 1);
}

void
close_all(void)
{
  80251b:	55                   	push   %ebp
  80251c:	89 e5                	mov    %esp,%ebp
  80251e:	53                   	push   %ebx
  80251f:	83 ec 14             	sub    $0x14,%esp
  802522:	bb 00 00 00 00       	mov    $0x0,%ebx
	int i;
	for (i = 0; i < MAXFD; i++)
		close(i);
  802527:	89 1c 24             	mov    %ebx,(%esp)
  80252a:	e8 6f ff ff ff       	call   80249e <close>

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  80252f:	83 c3 01             	add    $0x1,%ebx
  802532:	83 fb 20             	cmp    $0x20,%ebx
  802535:	75 f0                	jne    802527 <close_all+0xc>
		close(i);
}
  802537:	83 c4 14             	add    $0x14,%esp
  80253a:	5b                   	pop    %ebx
  80253b:	5d                   	pop    %ebp
  80253c:	c3                   	ret    

0080253d <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  80253d:	55                   	push   %ebp
  80253e:	89 e5                	mov    %esp,%ebp
  802540:	83 ec 58             	sub    $0x58,%esp
  802543:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  802546:	89 75 f8             	mov    %esi,-0x8(%ebp)
  802549:	89 7d fc             	mov    %edi,-0x4(%ebp)
  80254c:	8b 7d 0c             	mov    0xc(%ebp),%edi
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  80254f:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  802552:	89 44 24 04          	mov    %eax,0x4(%esp)
  802556:	8b 45 08             	mov    0x8(%ebp),%eax
  802559:	89 04 24             	mov    %eax,(%esp)
  80255c:	e8 7c fb ff ff       	call   8020dd <fd_lookup>
  802561:	89 c3                	mov    %eax,%ebx
  802563:	85 c0                	test   %eax,%eax
  802565:	0f 88 e0 00 00 00    	js     80264b <dup+0x10e>
		return r;
	close(newfdnum);
  80256b:	89 3c 24             	mov    %edi,(%esp)
  80256e:	e8 2b ff ff ff       	call   80249e <close>

	newfd = INDEX2FD(newfdnum);
  802573:	8d b7 00 00 0d 00    	lea    0xd0000(%edi),%esi
  802579:	c1 e6 0c             	shl    $0xc,%esi
	ova = fd2data(oldfd);
  80257c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80257f:	89 04 24             	mov    %eax,(%esp)
  802582:	e8 c9 fa ff ff       	call   802050 <fd2data>
  802587:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  802589:	89 34 24             	mov    %esi,(%esp)
  80258c:	e8 bf fa ff ff       	call   802050 <fd2data>
  802591:	89 45 d4             	mov    %eax,-0x2c(%ebp)

	if ((vpd[PDX(ova)] & PTE_P) && (vpt[VPN(ova)] & PTE_P))
  802594:	89 da                	mov    %ebx,%edx
  802596:	89 d8                	mov    %ebx,%eax
  802598:	c1 e8 16             	shr    $0x16,%eax
  80259b:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  8025a2:	a8 01                	test   $0x1,%al
  8025a4:	74 43                	je     8025e9 <dup+0xac>
  8025a6:	c1 ea 0c             	shr    $0xc,%edx
  8025a9:	8b 04 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%eax
  8025b0:	a8 01                	test   $0x1,%al
  8025b2:	74 35                	je     8025e9 <dup+0xac>
		if ((r = sys_page_map(0, ova, 0, nva, vpt[VPN(ova)] & PTE_USER)) < 0)
  8025b4:	8b 04 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%eax
  8025bb:	25 07 0e 00 00       	and    $0xe07,%eax
  8025c0:	89 44 24 10          	mov    %eax,0x10(%esp)
  8025c4:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8025c7:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8025cb:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  8025d2:	00 
  8025d3:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8025d7:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8025de:	e8 1a f5 ff ff       	call   801afd <sys_page_map>
  8025e3:	89 c3                	mov    %eax,%ebx
  8025e5:	85 c0                	test   %eax,%eax
  8025e7:	78 3f                	js     802628 <dup+0xeb>
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, vpt[VPN(oldfd)] & PTE_USER)) < 0)
  8025e9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8025ec:	89 c2                	mov    %eax,%edx
  8025ee:	c1 ea 0c             	shr    $0xc,%edx
  8025f1:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8025f8:	81 e2 07 0e 00 00    	and    $0xe07,%edx
  8025fe:	89 54 24 10          	mov    %edx,0x10(%esp)
  802602:	89 74 24 0c          	mov    %esi,0xc(%esp)
  802606:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  80260d:	00 
  80260e:	89 44 24 04          	mov    %eax,0x4(%esp)
  802612:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802619:	e8 df f4 ff ff       	call   801afd <sys_page_map>
  80261e:	89 c3                	mov    %eax,%ebx
  802620:	85 c0                	test   %eax,%eax
  802622:	78 04                	js     802628 <dup+0xeb>
  802624:	89 fb                	mov    %edi,%ebx
  802626:	eb 23                	jmp    80264b <dup+0x10e>
		goto err;

	return newfdnum;

err:
	sys_page_unmap(0, newfd);
  802628:	89 74 24 04          	mov    %esi,0x4(%esp)
  80262c:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802633:	e8 67 f4 ff ff       	call   801a9f <sys_page_unmap>
	sys_page_unmap(0, nva);
  802638:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80263b:	89 44 24 04          	mov    %eax,0x4(%esp)
  80263f:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802646:	e8 54 f4 ff ff       	call   801a9f <sys_page_unmap>
	return r;
}
  80264b:	89 d8                	mov    %ebx,%eax
  80264d:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  802650:	8b 75 f8             	mov    -0x8(%ebp),%esi
  802653:	8b 7d fc             	mov    -0x4(%ebp),%edi
  802656:	89 ec                	mov    %ebp,%esp
  802658:	5d                   	pop    %ebp
  802659:	c3                   	ret    
	...

0080265c <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  80265c:	55                   	push   %ebp
  80265d:	89 e5                	mov    %esp,%ebp
  80265f:	53                   	push   %ebx
  802660:	83 ec 14             	sub    $0x14,%esp
  802663:	89 d3                	mov    %edx,%ebx
	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", env->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(envs[1].env_id, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  802665:	8b 15 c8 00 c0 ee    	mov    0xeec000c8,%edx
  80266b:	c7 44 24 0c 07 00 00 	movl   $0x7,0xc(%esp)
  802672:	00 
  802673:	c7 44 24 08 00 50 80 	movl   $0x805000,0x8(%esp)
  80267a:	00 
  80267b:	89 44 24 04          	mov    %eax,0x4(%esp)
  80267f:	89 14 24             	mov    %edx,(%esp)
  802682:	e8 a9 13 00 00       	call   803a30 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  802687:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  80268e:	00 
  80268f:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  802693:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80269a:	e8 f7 13 00 00       	call   803a96 <ipc_recv>
}
  80269f:	83 c4 14             	add    $0x14,%esp
  8026a2:	5b                   	pop    %ebx
  8026a3:	5d                   	pop    %ebp
  8026a4:	c3                   	ret    

008026a5 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  8026a5:	55                   	push   %ebp
  8026a6:	89 e5                	mov    %esp,%ebp
  8026a8:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  8026ab:	8b 45 08             	mov    0x8(%ebp),%eax
  8026ae:	8b 40 0c             	mov    0xc(%eax),%eax
  8026b1:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.set_size.req_size = newsize;
  8026b6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8026b9:	a3 04 50 80 00       	mov    %eax,0x805004
	return fsipc(FSREQ_SET_SIZE, NULL);
  8026be:	ba 00 00 00 00       	mov    $0x0,%edx
  8026c3:	b8 02 00 00 00       	mov    $0x2,%eax
  8026c8:	e8 8f ff ff ff       	call   80265c <fsipc>
}
  8026cd:	c9                   	leave  
  8026ce:	c3                   	ret    

008026cf <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  8026cf:	55                   	push   %ebp
  8026d0:	89 e5                	mov    %esp,%ebp
  8026d2:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  8026d5:	8b 45 08             	mov    0x8(%ebp),%eax
  8026d8:	8b 40 0c             	mov    0xc(%eax),%eax
  8026db:	a3 00 50 80 00       	mov    %eax,0x805000
	return fsipc(FSREQ_FLUSH, NULL);
  8026e0:	ba 00 00 00 00       	mov    $0x0,%edx
  8026e5:	b8 06 00 00 00       	mov    $0x6,%eax
  8026ea:	e8 6d ff ff ff       	call   80265c <fsipc>
}
  8026ef:	c9                   	leave  
  8026f0:	c3                   	ret    

008026f1 <sync>:
}

// Synchronize disk with buffer cache
int
sync(void)
{
  8026f1:	55                   	push   %ebp
  8026f2:	89 e5                	mov    %esp,%ebp
  8026f4:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  8026f7:	ba 00 00 00 00       	mov    $0x0,%edx
  8026fc:	b8 08 00 00 00       	mov    $0x8,%eax
  802701:	e8 56 ff ff ff       	call   80265c <fsipc>
}
  802706:	c9                   	leave  
  802707:	c3                   	ret    

00802708 <devfile_stat>:
	return fsipc(FSREQ_WRITE, NULL);	
}

static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  802708:	55                   	push   %ebp
  802709:	89 e5                	mov    %esp,%ebp
  80270b:	53                   	push   %ebx
  80270c:	83 ec 14             	sub    $0x14,%esp
  80270f:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  802712:	8b 45 08             	mov    0x8(%ebp),%eax
  802715:	8b 40 0c             	mov    0xc(%eax),%eax
  802718:	a3 00 50 80 00       	mov    %eax,0x805000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  80271d:	ba 00 00 00 00       	mov    $0x0,%edx
  802722:	b8 05 00 00 00       	mov    $0x5,%eax
  802727:	e8 30 ff ff ff       	call   80265c <fsipc>
  80272c:	85 c0                	test   %eax,%eax
  80272e:	78 2b                	js     80275b <devfile_stat+0x53>
		return r;
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  802730:	c7 44 24 04 00 50 80 	movl   $0x805000,0x4(%esp)
  802737:	00 
  802738:	89 1c 24             	mov    %ebx,(%esp)
  80273b:	e8 2a ec ff ff       	call   80136a <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  802740:	a1 80 50 80 00       	mov    0x805080,%eax
  802745:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  80274b:	a1 84 50 80 00       	mov    0x805084,%eax
  802750:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
  802756:	b8 00 00 00 00       	mov    $0x0,%eax
	return 0;
}
  80275b:	83 c4 14             	add    $0x14,%esp
  80275e:	5b                   	pop    %ebx
  80275f:	5d                   	pop    %ebp
  802760:	c3                   	ret    

00802761 <devfile_write>:
// Returns:
//	 The number of bytes successfully written.
//	 < 0 on error.
static ssize_t
devfile_write(struct Fd *fd, const void *buf, size_t n)
{
  802761:	55                   	push   %ebp
  802762:	89 e5                	mov    %esp,%ebp
  802764:	83 ec 18             	sub    $0x18,%esp
  802767:	8b 45 10             	mov    0x10(%ebp),%eax
  80276a:	3d f8 0f 00 00       	cmp    $0xff8,%eax
  80276f:	76 05                	jbe    802776 <devfile_write+0x15>
  802771:	b8 f8 0f 00 00       	mov    $0xff8,%eax
	// LAB 5: Your code here
	//panic("devfile_write not implemented");
	
	if (n > (PGSIZE - (sizeof(int) + sizeof(size_t))))
		n = PGSIZE - (sizeof(int) + sizeof(size_t));
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  802776:	8b 55 08             	mov    0x8(%ebp),%edx
  802779:	8b 52 0c             	mov    0xc(%edx),%edx
  80277c:	89 15 00 50 80 00    	mov    %edx,0x805000
	fsipcbuf.write.req_n = n;
  802782:	a3 04 50 80 00       	mov    %eax,0x805004
	memmove (fsipcbuf.write.req_buf, (char*)buf, n);	
  802787:	89 44 24 08          	mov    %eax,0x8(%esp)
  80278b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80278e:	89 44 24 04          	mov    %eax,0x4(%esp)
  802792:	c7 04 24 08 50 80 00 	movl   $0x805008,(%esp)
  802799:	e8 87 ed ff ff       	call   801525 <memmove>
	return fsipc(FSREQ_WRITE, NULL);	
  80279e:	ba 00 00 00 00       	mov    $0x0,%edx
  8027a3:	b8 04 00 00 00       	mov    $0x4,%eax
  8027a8:	e8 af fe ff ff       	call   80265c <fsipc>
}
  8027ad:	c9                   	leave  
  8027ae:	c3                   	ret    

008027af <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  8027af:	55                   	push   %ebp
  8027b0:	89 e5                	mov    %esp,%ebp
  8027b2:	53                   	push   %ebx
  8027b3:	83 ec 14             	sub    $0x14,%esp
	// system server.
	// LAB 5: Your code here
	
	//panic("devfile_read not implemented");
	int r;
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  8027b6:	8b 45 08             	mov    0x8(%ebp),%eax
  8027b9:	8b 40 0c             	mov    0xc(%eax),%eax
  8027bc:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.read.req_n = n;
  8027c1:	8b 45 10             	mov    0x10(%ebp),%eax
  8027c4:	a3 04 50 80 00       	mov    %eax,0x805004
	if ((r = fsipc(FSREQ_READ, (void*)&fsipcbuf)) < 0)
  8027c9:	ba 00 50 80 00       	mov    $0x805000,%edx
  8027ce:	b8 03 00 00 00       	mov    $0x3,%eax
  8027d3:	e8 84 fe ff ff       	call   80265c <fsipc>
  8027d8:	89 c3                	mov    %eax,%ebx
  8027da:	85 c0                	test   %eax,%eax
  8027dc:	78 17                	js     8027f5 <devfile_read+0x46>
		return r;
	memmove((void*)buf, (void*)fsipcbuf.readRet.ret_buf, r);
  8027de:	89 44 24 08          	mov    %eax,0x8(%esp)
  8027e2:	c7 44 24 04 00 50 80 	movl   $0x805000,0x4(%esp)
  8027e9:	00 
  8027ea:	8b 45 0c             	mov    0xc(%ebp),%eax
  8027ed:	89 04 24             	mov    %eax,(%esp)
  8027f0:	e8 30 ed ff ff       	call   801525 <memmove>
	return r;
}
  8027f5:	89 d8                	mov    %ebx,%eax
  8027f7:	83 c4 14             	add    $0x14,%esp
  8027fa:	5b                   	pop    %ebx
  8027fb:	5d                   	pop    %ebp
  8027fc:	c3                   	ret    

008027fd <remove>:
}

// Delete a file
int
remove(const char *path)
{
  8027fd:	55                   	push   %ebp
  8027fe:	89 e5                	mov    %esp,%ebp
  802800:	53                   	push   %ebx
  802801:	83 ec 14             	sub    $0x14,%esp
  802804:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (strlen(path) >= MAXPATHLEN)
  802807:	89 1c 24             	mov    %ebx,(%esp)
  80280a:	e8 11 eb ff ff       	call   801320 <strlen>
  80280f:	89 c2                	mov    %eax,%edx
  802811:	b8 f4 ff ff ff       	mov    $0xfffffff4,%eax
  802816:	81 fa ff 03 00 00    	cmp    $0x3ff,%edx
  80281c:	7f 1f                	jg     80283d <remove+0x40>
		return -E_BAD_PATH;
	strcpy(fsipcbuf.remove.req_path, path);
  80281e:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  802822:	c7 04 24 00 50 80 00 	movl   $0x805000,(%esp)
  802829:	e8 3c eb ff ff       	call   80136a <strcpy>
	return fsipc(FSREQ_REMOVE, NULL);
  80282e:	ba 00 00 00 00       	mov    $0x0,%edx
  802833:	b8 07 00 00 00       	mov    $0x7,%eax
  802838:	e8 1f fe ff ff       	call   80265c <fsipc>
}
  80283d:	83 c4 14             	add    $0x14,%esp
  802840:	5b                   	pop    %ebx
  802841:	5d                   	pop    %ebp
  802842:	c3                   	ret    

00802843 <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  802843:	55                   	push   %ebp
  802844:	89 e5                	mov    %esp,%ebp
  802846:	83 ec 28             	sub    $0x28,%esp
  802849:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  80284c:	89 75 fc             	mov    %esi,-0x4(%ebp)
  80284f:	8b 75 08             	mov    0x8(%ebp),%esi
	// file descriptor.

	// LAB 5: Your code here.
	// Code added by Swastika / Sandeep
	
	if (strlen(path) >= MAXPATHLEN)
  802852:	89 34 24             	mov    %esi,(%esp)
  802855:	e8 c6 ea ff ff       	call   801320 <strlen>
  80285a:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  80285f:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  802864:	7f 5e                	jg     8028c4 <open+0x81>
		return -E_BAD_PATH;
	struct Fd * fd;
	int  r;
	if ((r = fd_alloc(&fd)) < 0)
  802866:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802869:	89 04 24             	mov    %eax,(%esp)
  80286c:	e8 fa f7 ff ff       	call   80206b <fd_alloc>
  802871:	89 c3                	mov    %eax,%ebx
  802873:	85 c0                	test   %eax,%eax
  802875:	78 4d                	js     8028c4 <open+0x81>
		return r;
	strcpy (fsipcbuf.open.req_path, path);
  802877:	89 74 24 04          	mov    %esi,0x4(%esp)
  80287b:	c7 04 24 00 50 80 00 	movl   $0x805000,(%esp)
  802882:	e8 e3 ea ff ff       	call   80136a <strcpy>
	fsipcbuf.open.req_omode = mode;	
  802887:	8b 45 0c             	mov    0xc(%ebp),%eax
  80288a:	a3 00 54 80 00       	mov    %eax,0x805400
	if ((r = fsipc(FSREQ_OPEN,(void*)fd)) < 0)
  80288f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802892:	b8 01 00 00 00       	mov    $0x1,%eax
  802897:	e8 c0 fd ff ff       	call   80265c <fsipc>
  80289c:	89 c3                	mov    %eax,%ebx
  80289e:	85 c0                	test   %eax,%eax
  8028a0:	79 15                	jns    8028b7 <open+0x74>
	{
		fd_close(fd,0);
  8028a2:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  8028a9:	00 
  8028aa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028ad:	89 04 24             	mov    %eax,(%esp)
  8028b0:	e8 6a fb ff ff       	call   80241f <fd_close>
		return r; 
  8028b5:	eb 0d                	jmp    8028c4 <open+0x81>
	}
	return fd2num(fd);
  8028b7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028ba:	89 04 24             	mov    %eax,(%esp)
  8028bd:	e8 7e f7 ff ff       	call   802040 <fd2num>
  8028c2:	89 c3                	mov    %eax,%ebx
	//panic("open not implemented");
}
  8028c4:	89 d8                	mov    %ebx,%eax
  8028c6:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  8028c9:	8b 75 fc             	mov    -0x4(%ebp),%esi
  8028cc:	89 ec                	mov    %ebp,%esp
  8028ce:	5d                   	pop    %ebp
  8028cf:	c3                   	ret    

008028d0 <writebuf>:
};


static void
writebuf(struct printbuf *b)
{
  8028d0:	55                   	push   %ebp
  8028d1:	89 e5                	mov    %esp,%ebp
  8028d3:	53                   	push   %ebx
  8028d4:	83 ec 14             	sub    $0x14,%esp
  8028d7:	89 c3                	mov    %eax,%ebx
	if (b->error > 0) {
  8028d9:	83 78 0c 00          	cmpl   $0x0,0xc(%eax)
  8028dd:	7e 34                	jle    802913 <writebuf+0x43>
		ssize_t result = write(b->fd, b->buf, b->idx);
  8028df:	8b 40 04             	mov    0x4(%eax),%eax
  8028e2:	89 44 24 08          	mov    %eax,0x8(%esp)
  8028e6:	8d 43 10             	lea    0x10(%ebx),%eax
  8028e9:	89 44 24 04          	mov    %eax,0x4(%esp)
  8028ed:	8b 03                	mov    (%ebx),%eax
  8028ef:	89 04 24             	mov    %eax,(%esp)
  8028f2:	e8 be f9 ff ff       	call   8022b5 <write>
		if (result > 0)
  8028f7:	85 c0                	test   %eax,%eax
  8028f9:	7e 03                	jle    8028fe <writebuf+0x2e>
			b->result += result;
  8028fb:	01 43 08             	add    %eax,0x8(%ebx)
		if (result != b->idx) // error, or wrote less than supplied
  8028fe:	3b 43 04             	cmp    0x4(%ebx),%eax
  802901:	74 10                	je     802913 <writebuf+0x43>
			b->error = (result < 0 ? result : 0);
  802903:	85 c0                	test   %eax,%eax
  802905:	0f 9f c2             	setg   %dl
  802908:	0f b6 d2             	movzbl %dl,%edx
  80290b:	83 ea 01             	sub    $0x1,%edx
  80290e:	21 d0                	and    %edx,%eax
  802910:	89 43 0c             	mov    %eax,0xc(%ebx)
	}
}
  802913:	83 c4 14             	add    $0x14,%esp
  802916:	5b                   	pop    %ebx
  802917:	5d                   	pop    %ebp
  802918:	c3                   	ret    

00802919 <vfprintf>:
	}
}

int
vfprintf(int fd, const char *fmt, va_list ap)
{
  802919:	55                   	push   %ebp
  80291a:	89 e5                	mov    %esp,%ebp
  80291c:	81 ec 28 01 00 00    	sub    $0x128,%esp
	struct printbuf b;

	b.fd = fd;
  802922:	8b 45 08             	mov    0x8(%ebp),%eax
  802925:	89 85 e8 fe ff ff    	mov    %eax,-0x118(%ebp)
	b.idx = 0;
  80292b:	c7 85 ec fe ff ff 00 	movl   $0x0,-0x114(%ebp)
  802932:	00 00 00 
	b.result = 0;
  802935:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  80293c:	00 00 00 
	b.error = 1;
  80293f:	c7 85 f4 fe ff ff 01 	movl   $0x1,-0x10c(%ebp)
  802946:	00 00 00 
	vprintfmt(putch, &b, fmt, ap);
  802949:	8b 45 10             	mov    0x10(%ebp),%eax
  80294c:	89 44 24 0c          	mov    %eax,0xc(%esp)
  802950:	8b 45 0c             	mov    0xc(%ebp),%eax
  802953:	89 44 24 08          	mov    %eax,0x8(%esp)
  802957:	8d 85 e8 fe ff ff    	lea    -0x118(%ebp),%eax
  80295d:	89 44 24 04          	mov    %eax,0x4(%esp)
  802961:	c7 04 24 d6 29 80 00 	movl   $0x8029d6,(%esp)
  802968:	e8 00 e4 ff ff       	call   800d6d <vprintfmt>
	if (b.idx > 0)
  80296d:	83 bd ec fe ff ff 00 	cmpl   $0x0,-0x114(%ebp)
  802974:	7e 0b                	jle    802981 <vfprintf+0x68>
		writebuf(&b);
  802976:	8d 85 e8 fe ff ff    	lea    -0x118(%ebp),%eax
  80297c:	e8 4f ff ff ff       	call   8028d0 <writebuf>

	return (b.result ? b.result : b.error);
  802981:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
  802987:	85 c0                	test   %eax,%eax
  802989:	75 06                	jne    802991 <vfprintf+0x78>
  80298b:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  802991:	c9                   	leave  
  802992:	c3                   	ret    

00802993 <printf>:
	return cnt;
}

int
printf(const char *fmt, ...)
{
  802993:	55                   	push   %ebp
  802994:	89 e5                	mov    %esp,%ebp
  802996:	83 ec 18             	sub    $0x18,%esp

	return cnt;
}

int
printf(const char *fmt, ...)
  802999:	8d 45 0c             	lea    0xc(%ebp),%eax
{
	va_list ap;
	int cnt;

	va_start(ap, fmt);
	cnt = vfprintf(1, fmt, ap);
  80299c:	89 44 24 08          	mov    %eax,0x8(%esp)
  8029a0:	8b 45 08             	mov    0x8(%ebp),%eax
  8029a3:	89 44 24 04          	mov    %eax,0x4(%esp)
  8029a7:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  8029ae:	e8 66 ff ff ff       	call   802919 <vfprintf>
	va_end(ap);

	return cnt;
}
  8029b3:	c9                   	leave  
  8029b4:	c3                   	ret    

008029b5 <fprintf>:
	return (b.result ? b.result : b.error);
}

int
fprintf(int fd, const char *fmt, ...)
{
  8029b5:	55                   	push   %ebp
  8029b6:	89 e5                	mov    %esp,%ebp
  8029b8:	83 ec 18             	sub    $0x18,%esp

	return (b.result ? b.result : b.error);
}

int
fprintf(int fd, const char *fmt, ...)
  8029bb:	8d 45 10             	lea    0x10(%ebp),%eax
{
	va_list ap;
	int cnt;

	va_start(ap, fmt);
	cnt = vfprintf(fd, fmt, ap);
  8029be:	89 44 24 08          	mov    %eax,0x8(%esp)
  8029c2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8029c5:	89 44 24 04          	mov    %eax,0x4(%esp)
  8029c9:	8b 45 08             	mov    0x8(%ebp),%eax
  8029cc:	89 04 24             	mov    %eax,(%esp)
  8029cf:	e8 45 ff ff ff       	call   802919 <vfprintf>
	va_end(ap);

	return cnt;
}
  8029d4:	c9                   	leave  
  8029d5:	c3                   	ret    

008029d6 <putch>:
	}
}

static void
putch(int ch, void *thunk)
{
  8029d6:	55                   	push   %ebp
  8029d7:	89 e5                	mov    %esp,%ebp
  8029d9:	53                   	push   %ebx
  8029da:	83 ec 04             	sub    $0x4,%esp
	struct printbuf *b = (struct printbuf *) thunk;
  8029dd:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  8029e0:	8b 43 04             	mov    0x4(%ebx),%eax
  8029e3:	8b 55 08             	mov    0x8(%ebp),%edx
  8029e6:	88 54 03 10          	mov    %dl,0x10(%ebx,%eax,1)
  8029ea:	83 c0 01             	add    $0x1,%eax
  8029ed:	89 43 04             	mov    %eax,0x4(%ebx)
	if (b->idx == 256) {
  8029f0:	3d 00 01 00 00       	cmp    $0x100,%eax
  8029f5:	75 0e                	jne    802a05 <putch+0x2f>
		writebuf(b);
  8029f7:	89 d8                	mov    %ebx,%eax
  8029f9:	e8 d2 fe ff ff       	call   8028d0 <writebuf>
		b->idx = 0;
  8029fe:	c7 43 04 00 00 00 00 	movl   $0x0,0x4(%ebx)
	}
}
  802a05:	83 c4 04             	add    $0x4,%esp
  802a08:	5b                   	pop    %ebx
  802a09:	5d                   	pop    %ebp
  802a0a:	c3                   	ret    
	...

00802a0c <spawn>:
// argv: pointer to null-terminated array of pointers to strings,
// 	 which will be passed to the child as its command-line arguments.
// Returns child envid on success, < 0 on failure.
int
spawn(const char *prog, const char **argv)
{
  802a0c:	55                   	push   %ebp
  802a0d:	89 e5                	mov    %esp,%ebp
  802a0f:	57                   	push   %edi
  802a10:	56                   	push   %esi
  802a11:	53                   	push   %ebx
  802a12:	81 ec 9c 02 00 00    	sub    $0x29c,%esp
	//   - Call sys_env_set_trapframe(child, &child_tf) to set up the
	//     correct initial eip and esp values in the child.
	//
	//   - Start the child process running with sys_env_set_status().

	if ((r = open(prog, O_RDONLY)) < 0)
  802a18:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  802a1f:	00 
  802a20:	8b 45 08             	mov    0x8(%ebp),%eax
  802a23:	89 04 24             	mov    %eax,(%esp)
  802a26:	e8 18 fe ff ff       	call   802843 <open>
  802a2b:	89 85 84 fd ff ff    	mov    %eax,-0x27c(%ebp)
  802a31:	89 c3                	mov    %eax,%ebx
  802a33:	85 c0                	test   %eax,%eax
  802a35:	0f 88 be 05 00 00    	js     802ff9 <spawn+0x5ed>
	fd = r;

	// Read elf header
	elf = (struct Elf*) elf_buf;
	if (read(fd, elf_buf, sizeof(elf_buf)) != sizeof(elf_buf)
	    || elf->e_magic != ELF_MAGIC) {
  802a3b:	c7 44 24 08 00 02 00 	movl   $0x200,0x8(%esp)
  802a42:	00 
  802a43:	8d 85 e8 fd ff ff    	lea    -0x218(%ebp),%eax
  802a49:	89 44 24 04          	mov    %eax,0x4(%esp)
  802a4d:	89 1c 24             	mov    %ebx,(%esp)
  802a50:	e8 e9 f8 ff ff       	call   80233e <read>
		return r;
	fd = r;

	// Read elf header
	elf = (struct Elf*) elf_buf;
	if (read(fd, elf_buf, sizeof(elf_buf)) != sizeof(elf_buf)
  802a55:	3d 00 02 00 00       	cmp    $0x200,%eax
  802a5a:	75 0c                	jne    802a68 <spawn+0x5c>
	    || elf->e_magic != ELF_MAGIC) {
  802a5c:	81 bd e8 fd ff ff 7f 	cmpl   $0x464c457f,-0x218(%ebp)
  802a63:	45 4c 46 
  802a66:	74 36                	je     802a9e <spawn+0x92>
		close(fd);
  802a68:	8b 85 84 fd ff ff    	mov    -0x27c(%ebp),%eax
  802a6e:	89 04 24             	mov    %eax,(%esp)
  802a71:	e8 28 fa ff ff       	call   80249e <close>
		cprintf("elf magic %08x want %08x\n", elf->e_magic, ELF_MAGIC);
  802a76:	c7 44 24 08 7f 45 4c 	movl   $0x464c457f,0x8(%esp)
  802a7d:	46 
  802a7e:	8b 85 e8 fd ff ff    	mov    -0x218(%ebp),%eax
  802a84:	89 44 24 04          	mov    %eax,0x4(%esp)
  802a88:	c7 04 24 bc 45 80 00 	movl   $0x8045bc,(%esp)
  802a8f:	e8 29 e1 ff ff       	call   800bbd <cprintf>
  802a94:	bb f2 ff ff ff       	mov    $0xfffffff2,%ebx
		return -E_NOT_EXEC;
  802a99:	e9 5b 05 00 00       	jmp    802ff9 <spawn+0x5ed>
  802a9e:	ba 07 00 00 00       	mov    $0x7,%edx
  802aa3:	89 d0                	mov    %edx,%eax
  802aa5:	cd 30                	int    $0x30
  802aa7:	89 85 8c fd ff ff    	mov    %eax,-0x274(%ebp)
	}

	// Create new child environment
	if ((r = sys_exofork()) < 0)
  802aad:	85 c0                	test   %eax,%eax
  802aaf:	0f 88 3e 05 00 00    	js     802ff3 <spawn+0x5e7>
		return r;
	child = r;

	// Set up trap frame, including initial stack.
	child_tf = envs[ENVX(child)].env_tf;
  802ab5:	89 c6                	mov    %eax,%esi
  802ab7:	81 e6 ff 03 00 00    	and    $0x3ff,%esi
  802abd:	6b f6 7c             	imul   $0x7c,%esi,%esi
  802ac0:	8d bd a4 fd ff ff    	lea    -0x25c(%ebp),%edi
  802ac6:	81 c6 00 00 c0 ee    	add    $0xeec00000,%esi
  802acc:	b9 11 00 00 00       	mov    $0x11,%ecx
  802ad1:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
	child_tf.tf_eip = elf->e_entry;
  802ad3:	8b 85 00 fe ff ff    	mov    -0x200(%ebp),%eax
  802ad9:	89 85 d4 fd ff ff    	mov    %eax,-0x22c(%ebp)
	uintptr_t *argv_store;

	// Count the number of arguments (argc)
	// and the total amount of space needed for strings (string_size).
	string_size = 0;
	for (argc = 0; argv[argc] != 0; argc++)
  802adf:	8b 55 0c             	mov    0xc(%ebp),%edx
  802ae2:	8b 02                	mov    (%edx),%eax
  802ae4:	bb 00 00 00 00       	mov    $0x0,%ebx
  802ae9:	be 00 00 00 00       	mov    $0x0,%esi
  802aee:	85 c0                	test   %eax,%eax
  802af0:	75 16                	jne    802b08 <spawn+0xfc>
  802af2:	c7 85 7c fd ff ff 00 	movl   $0x0,-0x284(%ebp)
  802af9:	00 00 00 
  802afc:	c7 85 78 fd ff ff 00 	movl   $0x0,-0x288(%ebp)
  802b03:	00 00 00 
  802b06:	eb 2c                	jmp    802b34 <spawn+0x128>
  802b08:	8b 7d 0c             	mov    0xc(%ebp),%edi
		string_size += strlen(argv[argc]) + 1;
  802b0b:	89 04 24             	mov    %eax,(%esp)
  802b0e:	e8 0d e8 ff ff       	call   801320 <strlen>
  802b13:	8d 5c 18 01          	lea    0x1(%eax,%ebx,1),%ebx
	uintptr_t *argv_store;

	// Count the number of arguments (argc)
	// and the total amount of space needed for strings (string_size).
	string_size = 0;
	for (argc = 0; argv[argc] != 0; argc++)
  802b17:	83 c6 01             	add    $0x1,%esi
  802b1a:	8d 14 b5 00 00 00 00 	lea    0x0(,%esi,4),%edx
  802b21:	8b 04 b7             	mov    (%edi,%esi,4),%eax
  802b24:	85 c0                	test   %eax,%eax
  802b26:	75 e3                	jne    802b0b <spawn+0xff>
  802b28:	89 95 7c fd ff ff    	mov    %edx,-0x284(%ebp)
  802b2e:	89 b5 78 fd ff ff    	mov    %esi,-0x288(%ebp)
	// Determine where to place the strings and the argv array.
	// Set up pointers into the temporary page 'UTEMP'; we'll map a page
	// there later, then remap that page into the child environment
	// at (USTACKTOP - PGSIZE).
	// strings is the topmost thing on the stack.
	string_store = (char*) UTEMP + PGSIZE - string_size;
  802b34:	f7 db                	neg    %ebx
  802b36:	8d bb 00 10 40 00    	lea    0x401000(%ebx),%edi
	// argv is below that.  There's one argument pointer per argument, plus
	// a null pointer.
	argv_store = (uintptr_t*) (ROUNDDOWN(string_store, 4) - 4 * (argc + 1));
  802b3c:	89 fa                	mov    %edi,%edx
  802b3e:	83 e2 fc             	and    $0xfffffffc,%edx
  802b41:	89 f0                	mov    %esi,%eax
  802b43:	f7 d0                	not    %eax
  802b45:	8d 04 82             	lea    (%edx,%eax,4),%eax
  802b48:	89 85 94 fd ff ff    	mov    %eax,-0x26c(%ebp)
	
	// Make sure that argv, strings, and the 2 words that hold 'argc'
	// and 'argv' themselves will all fit in a single stack page.
	if ((void*) (argv_store - 2) < (void*) UTEMP)
  802b4e:	83 e8 08             	sub    $0x8,%eax
  802b51:	89 85 80 fd ff ff    	mov    %eax,-0x280(%ebp)
	return child;

error:
	sys_env_destroy(child);
	close(fd);
	return r;
  802b57:	bb fc ff ff ff       	mov    $0xfffffffc,%ebx
	// a null pointer.
	argv_store = (uintptr_t*) (ROUNDDOWN(string_store, 4) - 4 * (argc + 1));
	
	// Make sure that argv, strings, and the 2 words that hold 'argc'
	// and 'argv' themselves will all fit in a single stack page.
	if ((void*) (argv_store - 2) < (void*) UTEMP)
  802b5c:	3d ff ff 3f 00       	cmp    $0x3fffff,%eax
  802b61:	0f 86 92 04 00 00    	jbe    802ff9 <spawn+0x5ed>
		return -E_NO_MEM;

	// Allocate the single stack page at UTEMP.
	if ((r = sys_page_alloc(0, (void*) UTEMP, PTE_P|PTE_U|PTE_W)) < 0)
  802b67:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  802b6e:	00 
  802b6f:	c7 44 24 04 00 00 40 	movl   $0x400000,0x4(%esp)
  802b76:	00 
  802b77:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802b7e:	e8 d8 ef ff ff       	call   801b5b <sys_page_alloc>
  802b83:	89 c3                	mov    %eax,%ebx
  802b85:	85 c0                	test   %eax,%eax
  802b87:	0f 88 6c 04 00 00    	js     802ff9 <spawn+0x5ed>
	//	  (Again, argv should use an address valid in the child's
	//	  environment.)
	//
	//	* Set *init_esp to the initial stack pointer for the child,
	//	  (Again, use an address valid in the child's environment.)
	for (i = 0; i < argc; i++) {
  802b8d:	85 f6                	test   %esi,%esi
  802b8f:	7e 46                	jle    802bd7 <spawn+0x1cb>
  802b91:	bb 00 00 00 00       	mov    $0x0,%ebx
  802b96:	89 b5 88 fd ff ff    	mov    %esi,-0x278(%ebp)
  802b9c:	8b 75 0c             	mov    0xc(%ebp),%esi
		argv_store[i] = UTEMP2USTACK(string_store);
  802b9f:	8d 87 00 d0 7f ee    	lea    -0x11803000(%edi),%eax
  802ba5:	8b 95 94 fd ff ff    	mov    -0x26c(%ebp),%edx
  802bab:	89 04 9a             	mov    %eax,(%edx,%ebx,4)
		strcpy(string_store, argv[i]);
  802bae:	8b 04 9e             	mov    (%esi,%ebx,4),%eax
  802bb1:	89 44 24 04          	mov    %eax,0x4(%esp)
  802bb5:	89 3c 24             	mov    %edi,(%esp)
  802bb8:	e8 ad e7 ff ff       	call   80136a <strcpy>
		string_store += strlen(argv[i]) + 1;
  802bbd:	8b 04 9e             	mov    (%esi,%ebx,4),%eax
  802bc0:	89 04 24             	mov    %eax,(%esp)
  802bc3:	e8 58 e7 ff ff       	call   801320 <strlen>
  802bc8:	8d 7c 07 01          	lea    0x1(%edi,%eax,1),%edi
	//	  (Again, argv should use an address valid in the child's
	//	  environment.)
	//
	//	* Set *init_esp to the initial stack pointer for the child,
	//	  (Again, use an address valid in the child's environment.)
	for (i = 0; i < argc; i++) {
  802bcc:	83 c3 01             	add    $0x1,%ebx
  802bcf:	3b 9d 88 fd ff ff    	cmp    -0x278(%ebp),%ebx
  802bd5:	7c c8                	jl     802b9f <spawn+0x193>
		argv_store[i] = UTEMP2USTACK(string_store);
		strcpy(string_store, argv[i]);
		string_store += strlen(argv[i]) + 1;
	}
	argv_store[argc] = 0;
  802bd7:	8b 95 94 fd ff ff    	mov    -0x26c(%ebp),%edx
  802bdd:	8b 85 7c fd ff ff    	mov    -0x284(%ebp),%eax
  802be3:	c7 04 02 00 00 00 00 	movl   $0x0,(%edx,%eax,1)
	assert(string_store == (char*)UTEMP + PGSIZE);
  802bea:	81 ff 00 10 40 00    	cmp    $0x401000,%edi
  802bf0:	74 24                	je     802c16 <spawn+0x20a>
  802bf2:	c7 44 24 0c 48 46 80 	movl   $0x804648,0xc(%esp)
  802bf9:	00 
  802bfa:	c7 44 24 08 81 3f 80 	movl   $0x803f81,0x8(%esp)
  802c01:	00 
  802c02:	c7 44 24 04 d9 00 00 	movl   $0xd9,0x4(%esp)
  802c09:	00 
  802c0a:	c7 04 24 d6 45 80 00 	movl   $0x8045d6,(%esp)
  802c11:	e8 e2 de ff ff       	call   800af8 <_panic>

	argv_store[-1] = UTEMP2USTACK(argv_store);
  802c16:	8b 85 94 fd ff ff    	mov    -0x26c(%ebp),%eax
  802c1c:	2d 00 30 80 11       	sub    $0x11803000,%eax
  802c21:	8b 95 94 fd ff ff    	mov    -0x26c(%ebp),%edx
  802c27:	89 42 fc             	mov    %eax,-0x4(%edx)
	argv_store[-2] = argc;
  802c2a:	8b 95 78 fd ff ff    	mov    -0x288(%ebp),%edx
  802c30:	8b 85 80 fd ff ff    	mov    -0x280(%ebp),%eax
  802c36:	89 10                	mov    %edx,(%eax)

	*init_esp = UTEMP2USTACK(&argv_store[-2]);
  802c38:	8b 85 94 fd ff ff    	mov    -0x26c(%ebp),%eax
  802c3e:	2d 08 30 80 11       	sub    $0x11803008,%eax
  802c43:	89 85 e0 fd ff ff    	mov    %eax,-0x220(%ebp)

	// After completing the stack, map it into the child's address space
	// and unmap it from ours!
	if ((r = sys_page_map(0, UTEMP, child, (void*) (USTACKTOP - PGSIZE), PTE_P | PTE_U | PTE_W)) < 0)
  802c49:	c7 44 24 10 07 00 00 	movl   $0x7,0x10(%esp)
  802c50:	00 
  802c51:	c7 44 24 0c 00 d0 bf 	movl   $0xeebfd000,0xc(%esp)
  802c58:	ee 
  802c59:	8b 85 8c fd ff ff    	mov    -0x274(%ebp),%eax
  802c5f:	89 44 24 08          	mov    %eax,0x8(%esp)
  802c63:	c7 44 24 04 00 00 40 	movl   $0x400000,0x4(%esp)
  802c6a:	00 
  802c6b:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802c72:	e8 86 ee ff ff       	call   801afd <sys_page_map>
  802c77:	89 c3                	mov    %eax,%ebx
  802c79:	85 c0                	test   %eax,%eax
  802c7b:	78 1a                	js     802c97 <spawn+0x28b>
		goto error;
	if ((r = sys_page_unmap(0, UTEMP)) < 0)
  802c7d:	c7 44 24 04 00 00 40 	movl   $0x400000,0x4(%esp)
  802c84:	00 
  802c85:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802c8c:	e8 0e ee ff ff       	call   801a9f <sys_page_unmap>
  802c91:	89 c3                	mov    %eax,%ebx
  802c93:	85 c0                	test   %eax,%eax
  802c95:	79 19                	jns    802cb0 <spawn+0x2a4>
		goto error;

	return 0;

error:
	sys_page_unmap(0, UTEMP);
  802c97:	c7 44 24 04 00 00 40 	movl   $0x400000,0x4(%esp)
  802c9e:	00 
  802c9f:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802ca6:	e8 f4 ed ff ff       	call   801a9f <sys_page_unmap>
  802cab:	e9 49 03 00 00       	jmp    802ff9 <spawn+0x5ed>

	if ((r = init_stack(child, argv, &child_tf.tf_esp)) < 0)
		return r;

	// Set up program segments as defined in ELF header.
	ph = (struct Proghdr*) (elf_buf + elf->e_phoff);
  802cb0:	8b 85 04 fe ff ff    	mov    -0x1fc(%ebp),%eax
	for (i = 0; i < elf->e_phnum; i++, ph++) {
  802cb6:	66 83 bd 14 fe ff ff 	cmpw   $0x0,-0x1ec(%ebp)
  802cbd:	00 
  802cbe:	0f 84 e3 01 00 00    	je     802ea7 <spawn+0x49b>

	if ((r = init_stack(child, argv, &child_tf.tf_esp)) < 0)
		return r;

	// Set up program segments as defined in ELF header.
	ph = (struct Proghdr*) (elf_buf + elf->e_phoff);
  802cc4:	8d 84 05 e8 fd ff ff 	lea    -0x218(%ebp,%eax,1),%eax
  802ccb:	89 85 80 fd ff ff    	mov    %eax,-0x280(%ebp)
  802cd1:	c7 85 7c fd ff ff 00 	movl   $0x0,-0x284(%ebp)
  802cd8:	00 00 00 
	for (i = 0; i < elf->e_phnum; i++, ph++) {
		if (ph->p_type != ELF_PROG_LOAD)
  802cdb:	8b 95 80 fd ff ff    	mov    -0x280(%ebp),%edx
  802ce1:	83 3a 01             	cmpl   $0x1,(%edx)
  802ce4:	0f 85 9b 01 00 00    	jne    802e85 <spawn+0x479>
			continue;
		perm = PTE_P | PTE_U;
		if (ph->p_flags & ELF_PROG_FLAG_WRITE)
  802cea:	8b 42 18             	mov    0x18(%edx),%eax
  802ced:	83 e0 02             	and    $0x2,%eax
  802cf0:	83 f8 01             	cmp    $0x1,%eax
  802cf3:	19 c0                	sbb    %eax,%eax
  802cf5:	83 e0 fe             	and    $0xfffffffe,%eax
  802cf8:	83 c0 07             	add    $0x7,%eax
  802cfb:	89 85 94 fd ff ff    	mov    %eax,-0x26c(%ebp)
			perm |= PTE_W;
		if ((r = map_segment(child, ph->p_va, ph->p_memsz, 
  802d01:	8b 52 04             	mov    0x4(%edx),%edx
  802d04:	89 95 78 fd ff ff    	mov    %edx,-0x288(%ebp)
  802d0a:	8b 85 80 fd ff ff    	mov    -0x280(%ebp),%eax
  802d10:	8b 58 10             	mov    0x10(%eax),%ebx
  802d13:	8b 50 14             	mov    0x14(%eax),%edx
  802d16:	89 95 88 fd ff ff    	mov    %edx,-0x278(%ebp)
  802d1c:	8b 40 08             	mov    0x8(%eax),%eax
  802d1f:	89 85 90 fd ff ff    	mov    %eax,-0x270(%ebp)
	int i, r;
	void *blk;

	//cprintf("map_segment %x+%x\n", va, memsz);

	if ((i = PGOFF(va))) {
  802d25:	25 ff 0f 00 00       	and    $0xfff,%eax
  802d2a:	74 16                	je     802d42 <spawn+0x336>
		va -= i;
  802d2c:	29 85 90 fd ff ff    	sub    %eax,-0x270(%ebp)
		memsz += i;
  802d32:	01 c2                	add    %eax,%edx
  802d34:	89 95 88 fd ff ff    	mov    %edx,-0x278(%ebp)
		filesz += i;
  802d3a:	01 c3                	add    %eax,%ebx
		fileoffset -= i;
  802d3c:	29 85 78 fd ff ff    	sub    %eax,-0x288(%ebp)
	}

	for (i = 0; i < memsz; i += PGSIZE) {
  802d42:	83 bd 88 fd ff ff 00 	cmpl   $0x0,-0x278(%ebp)
  802d49:	0f 84 36 01 00 00    	je     802e85 <spawn+0x479>
  802d4f:	bf 00 00 00 00       	mov    $0x0,%edi
  802d54:	be 00 00 00 00       	mov    $0x0,%esi
		if (i >= filesz) {
  802d59:	39 fb                	cmp    %edi,%ebx
  802d5b:	77 31                	ja     802d8e <spawn+0x382>
			// allocate a blank page
			if ((r = sys_page_alloc(child, (void*) (va + i), perm)) < 0)
  802d5d:	8b 95 94 fd ff ff    	mov    -0x26c(%ebp),%edx
  802d63:	89 54 24 08          	mov    %edx,0x8(%esp)
  802d67:	03 bd 90 fd ff ff    	add    -0x270(%ebp),%edi
  802d6d:	89 7c 24 04          	mov    %edi,0x4(%esp)
  802d71:	8b 85 8c fd ff ff    	mov    -0x274(%ebp),%eax
  802d77:	89 04 24             	mov    %eax,(%esp)
  802d7a:	e8 dc ed ff ff       	call   801b5b <sys_page_alloc>
  802d7f:	85 c0                	test   %eax,%eax
  802d81:	0f 89 ea 00 00 00    	jns    802e71 <spawn+0x465>
  802d87:	89 c3                	mov    %eax,%ebx
  802d89:	e9 47 02 00 00       	jmp    802fd5 <spawn+0x5c9>
				return r;
		} else {
			// from file
			if ((r = sys_page_alloc(0, UTEMP, PTE_P|PTE_U|PTE_W)) < 0)
  802d8e:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  802d95:	00 
  802d96:	c7 44 24 04 00 00 40 	movl   $0x400000,0x4(%esp)
  802d9d:	00 
  802d9e:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802da5:	e8 b1 ed ff ff       	call   801b5b <sys_page_alloc>
  802daa:	85 c0                	test   %eax,%eax
  802dac:	0f 88 19 02 00 00    	js     802fcb <spawn+0x5bf>
				return r;
			if ((r = seek(fd, fileoffset + i)) < 0)
  802db2:	8b 95 78 fd ff ff    	mov    -0x288(%ebp),%edx
  802db8:	8d 04 16             	lea    (%esi,%edx,1),%eax
  802dbb:	89 44 24 04          	mov    %eax,0x4(%esp)
  802dbf:	8b 85 84 fd ff ff    	mov    -0x27c(%ebp),%eax
  802dc5:	89 04 24             	mov    %eax,(%esp)
  802dc8:	e8 58 f3 ff ff       	call   802125 <seek>
  802dcd:	85 c0                	test   %eax,%eax
  802dcf:	0f 88 fa 01 00 00    	js     802fcf <spawn+0x5c3>
				return r;
			if ((r = read(fd, UTEMP, MIN(PGSIZE, filesz-i))) < 0)
  802dd5:	89 d8                	mov    %ebx,%eax
  802dd7:	29 f8                	sub    %edi,%eax
  802dd9:	3d 00 10 00 00       	cmp    $0x1000,%eax
  802dde:	76 05                	jbe    802de5 <spawn+0x3d9>
  802de0:	b8 00 10 00 00       	mov    $0x1000,%eax
  802de5:	89 44 24 08          	mov    %eax,0x8(%esp)
  802de9:	c7 44 24 04 00 00 40 	movl   $0x400000,0x4(%esp)
  802df0:	00 
  802df1:	8b 95 84 fd ff ff    	mov    -0x27c(%ebp),%edx
  802df7:	89 14 24             	mov    %edx,(%esp)
  802dfa:	e8 3f f5 ff ff       	call   80233e <read>
  802dff:	85 c0                	test   %eax,%eax
  802e01:	0f 88 cc 01 00 00    	js     802fd3 <spawn+0x5c7>
				return r;
			if ((r = sys_page_map(0, UTEMP, child, (void*) (va + i), perm)) < 0)
  802e07:	8b 85 94 fd ff ff    	mov    -0x26c(%ebp),%eax
  802e0d:	89 44 24 10          	mov    %eax,0x10(%esp)
  802e11:	03 bd 90 fd ff ff    	add    -0x270(%ebp),%edi
  802e17:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  802e1b:	8b 95 8c fd ff ff    	mov    -0x274(%ebp),%edx
  802e21:	89 54 24 08          	mov    %edx,0x8(%esp)
  802e25:	c7 44 24 04 00 00 40 	movl   $0x400000,0x4(%esp)
  802e2c:	00 
  802e2d:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802e34:	e8 c4 ec ff ff       	call   801afd <sys_page_map>
  802e39:	85 c0                	test   %eax,%eax
  802e3b:	79 20                	jns    802e5d <spawn+0x451>
				panic("spawn: sys_page_map data: %e", r);
  802e3d:	89 44 24 0c          	mov    %eax,0xc(%esp)
  802e41:	c7 44 24 08 e2 45 80 	movl   $0x8045e2,0x8(%esp)
  802e48:	00 
  802e49:	c7 44 24 04 0c 01 00 	movl   $0x10c,0x4(%esp)
  802e50:	00 
  802e51:	c7 04 24 d6 45 80 00 	movl   $0x8045d6,(%esp)
  802e58:	e8 9b dc ff ff       	call   800af8 <_panic>
			sys_page_unmap(0, UTEMP);
  802e5d:	c7 44 24 04 00 00 40 	movl   $0x400000,0x4(%esp)
  802e64:	00 
  802e65:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802e6c:	e8 2e ec ff ff       	call   801a9f <sys_page_unmap>
		memsz += i;
		filesz += i;
		fileoffset -= i;
	}

	for (i = 0; i < memsz; i += PGSIZE) {
  802e71:	81 c6 00 10 00 00    	add    $0x1000,%esi
  802e77:	89 f7                	mov    %esi,%edi
  802e79:	39 b5 88 fd ff ff    	cmp    %esi,-0x278(%ebp)
  802e7f:	0f 87 d4 fe ff ff    	ja     802d59 <spawn+0x34d>
	if ((r = init_stack(child, argv, &child_tf.tf_esp)) < 0)
		return r;

	// Set up program segments as defined in ELF header.
	ph = (struct Proghdr*) (elf_buf + elf->e_phoff);
	for (i = 0; i < elf->e_phnum; i++, ph++) {
  802e85:	83 85 7c fd ff ff 01 	addl   $0x1,-0x284(%ebp)
  802e8c:	0f b7 85 14 fe ff ff 	movzwl -0x1ec(%ebp),%eax
  802e93:	3b 85 7c fd ff ff    	cmp    -0x284(%ebp),%eax
  802e99:	7e 0c                	jle    802ea7 <spawn+0x49b>
  802e9b:	83 85 80 fd ff ff 20 	addl   $0x20,-0x280(%ebp)
  802ea2:	e9 34 fe ff ff       	jmp    802cdb <spawn+0x2cf>
			perm |= PTE_W;
		if ((r = map_segment(child, ph->p_va, ph->p_memsz, 
				     fd, ph->p_filesz, ph->p_offset, perm)) < 0)
			goto error;
	}
	close(fd);
  802ea7:	8b 85 84 fd ff ff    	mov    -0x27c(%ebp),%eax
  802ead:	89 04 24             	mov    %eax,(%esp)
  802eb0:	e8 e9 f5 ff ff       	call   80249e <close>
  802eb5:	c7 85 94 fd ff ff 00 	movl   $0x0,-0x26c(%ebp)
  802ebc:	00 00 00 
	void * va;
	int r;
	
	for (pde_x = VPD(0); pde_x < VPD(UTOP); pde_x++)
	{
		if ((vpd[pde_x] & PTE_P) == PTE_P)
  802ebf:	8b 95 94 fd ff ff    	mov    -0x26c(%ebp),%edx
  802ec5:	8b 04 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%eax
  802ecc:	a8 01                	test   $0x1,%al
  802ece:	74 65                	je     802f35 <spawn+0x529>
		{
			for (pte_x = 0; pte_x < NPTENTRIES; pte_x++)
			{
				vpn = (pde_x << (PDXSHIFT - PTXSHIFT)) + pte_x;
  802ed0:	89 d7                	mov    %edx,%edi
  802ed2:	c1 e7 0a             	shl    $0xa,%edi
  802ed5:	89 d6                	mov    %edx,%esi
  802ed7:	c1 e6 16             	shl    $0x16,%esi
  802eda:	bb 00 00 00 00       	mov    $0x0,%ebx
  802edf:	8d 04 3b             	lea    (%ebx,%edi,1),%eax
				pte = vpt[vpn];
  802ee2:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
				if ((pte & PTE_P) && (pte & PTE_SHARE))
  802ee9:	89 c2                	mov    %eax,%edx
  802eeb:	81 e2 01 04 00 00    	and    $0x401,%edx
  802ef1:	81 fa 01 04 00 00    	cmp    $0x401,%edx
  802ef7:	75 2b                	jne    802f24 <spawn+0x518>
				{
					va = (void*)(vpn * PGSIZE);
					r = sys_page_map(0, va, child, va, pte & PTE_USER);
  802ef9:	25 07 0e 00 00       	and    $0xe07,%eax
  802efe:	89 44 24 10          	mov    %eax,0x10(%esp)
  802f02:	89 74 24 0c          	mov    %esi,0xc(%esp)
  802f06:	8b 85 8c fd ff ff    	mov    -0x274(%ebp),%eax
  802f0c:	89 44 24 08          	mov    %eax,0x8(%esp)
  802f10:	89 74 24 04          	mov    %esi,0x4(%esp)
  802f14:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802f1b:	e8 dd eb ff ff       	call   801afd <sys_page_map>
					if (r < 0)
  802f20:	85 c0                	test   %eax,%eax
  802f22:	78 2d                	js     802f51 <spawn+0x545>
	
	for (pde_x = VPD(0); pde_x < VPD(UTOP); pde_x++)
	{
		if ((vpd[pde_x] & PTE_P) == PTE_P)
		{
			for (pte_x = 0; pte_x < NPTENTRIES; pte_x++)
  802f24:	83 c3 01             	add    $0x1,%ebx
  802f27:	81 c6 00 10 00 00    	add    $0x1000,%esi
  802f2d:	81 fb 00 04 00 00    	cmp    $0x400,%ebx
  802f33:	75 aa                	jne    802edf <spawn+0x4d3>
	uint32_t pde_x, pte_x, vpn;
	pte_t pte;
	void * va;
	int r;
	
	for (pde_x = VPD(0); pde_x < VPD(UTOP); pde_x++)
  802f35:	83 85 94 fd ff ff 01 	addl   $0x1,-0x26c(%ebp)
  802f3c:	81 bd 94 fd ff ff bb 	cmpl   $0x3bb,-0x26c(%ebp)
  802f43:	03 00 00 
  802f46:	0f 85 73 ff ff ff    	jne    802ebf <spawn+0x4b3>
  802f4c:	e9 b5 00 00 00       	jmp    803006 <spawn+0x5fa>
	close(fd);
	fd = -1;

	// Copy shared library state.
	if ((r = copy_shared_pages(child)) < 0)
		panic("copy_shared_pages: %e", r);
  802f51:	89 44 24 0c          	mov    %eax,0xc(%esp)
  802f55:	c7 44 24 08 ff 45 80 	movl   $0x8045ff,0x8(%esp)
  802f5c:	00 
  802f5d:	c7 44 24 04 82 00 00 	movl   $0x82,0x4(%esp)
  802f64:	00 
  802f65:	c7 04 24 d6 45 80 00 	movl   $0x8045d6,(%esp)
  802f6c:	e8 87 db ff ff       	call   800af8 <_panic>

	if ((r = sys_env_set_trapframe(child, &child_tf)) < 0)
		panic("sys_env_set_trapframe: %e", r);
  802f71:	89 44 24 0c          	mov    %eax,0xc(%esp)
  802f75:	c7 44 24 08 15 46 80 	movl   $0x804615,0x8(%esp)
  802f7c:	00 
  802f7d:	c7 44 24 04 85 00 00 	movl   $0x85,0x4(%esp)
  802f84:	00 
  802f85:	c7 04 24 d6 45 80 00 	movl   $0x8045d6,(%esp)
  802f8c:	e8 67 db ff ff       	call   800af8 <_panic>

	if ((r = sys_env_set_status(child, ENV_RUNNABLE)) < 0)
  802f91:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  802f98:	00 
  802f99:	8b 95 8c fd ff ff    	mov    -0x274(%ebp),%edx
  802f9f:	89 14 24             	mov    %edx,(%esp)
  802fa2:	e8 9a ea ff ff       	call   801a41 <sys_env_set_status>
  802fa7:	85 c0                	test   %eax,%eax
  802fa9:	79 48                	jns    802ff3 <spawn+0x5e7>
		panic("sys_env_set_status: %e", r);
  802fab:	89 44 24 0c          	mov    %eax,0xc(%esp)
  802faf:	c7 44 24 08 2f 46 80 	movl   $0x80462f,0x8(%esp)
  802fb6:	00 
  802fb7:	c7 44 24 04 88 00 00 	movl   $0x88,0x4(%esp)
  802fbe:	00 
  802fbf:	c7 04 24 d6 45 80 00 	movl   $0x8045d6,(%esp)
  802fc6:	e8 2d db ff ff       	call   800af8 <_panic>
  802fcb:	89 c3                	mov    %eax,%ebx
  802fcd:	eb 06                	jmp    802fd5 <spawn+0x5c9>
  802fcf:	89 c3                	mov    %eax,%ebx
  802fd1:	eb 02                	jmp    802fd5 <spawn+0x5c9>
  802fd3:	89 c3                	mov    %eax,%ebx

	return child;

error:
	sys_env_destroy(child);
  802fd5:	8b 85 8c fd ff ff    	mov    -0x274(%ebp),%eax
  802fdb:	89 04 24             	mov    %eax,(%esp)
  802fde:	e8 3f ec ff ff       	call   801c22 <sys_env_destroy>
	close(fd);
  802fe3:	8b 95 84 fd ff ff    	mov    -0x27c(%ebp),%edx
  802fe9:	89 14 24             	mov    %edx,(%esp)
  802fec:	e8 ad f4 ff ff       	call   80249e <close>
	return r;
  802ff1:	eb 06                	jmp    802ff9 <spawn+0x5ed>
  802ff3:	8b 9d 8c fd ff ff    	mov    -0x274(%ebp),%ebx
}
  802ff9:	89 d8                	mov    %ebx,%eax
  802ffb:	81 c4 9c 02 00 00    	add    $0x29c,%esp
  803001:	5b                   	pop    %ebx
  803002:	5e                   	pop    %esi
  803003:	5f                   	pop    %edi
  803004:	5d                   	pop    %ebp
  803005:	c3                   	ret    

	// Copy shared library state.
	if ((r = copy_shared_pages(child)) < 0)
		panic("copy_shared_pages: %e", r);

	if ((r = sys_env_set_trapframe(child, &child_tf)) < 0)
  803006:	8d 85 a4 fd ff ff    	lea    -0x25c(%ebp),%eax
  80300c:	89 44 24 04          	mov    %eax,0x4(%esp)
  803010:	8b 85 8c fd ff ff    	mov    -0x274(%ebp),%eax
  803016:	89 04 24             	mov    %eax,(%esp)
  803019:	e8 c5 e9 ff ff       	call   8019e3 <sys_env_set_trapframe>
  80301e:	85 c0                	test   %eax,%eax
  803020:	0f 89 6b ff ff ff    	jns    802f91 <spawn+0x585>
  803026:	e9 46 ff ff ff       	jmp    802f71 <spawn+0x565>

0080302b <spawnl>:
}

// Spawn, taking command-line arguments array directly on the stack.
int
spawnl(const char *prog, const char *arg0, ...)
{
  80302b:	55                   	push   %ebp
  80302c:	89 e5                	mov    %esp,%ebp
  80302e:	83 ec 18             	sub    $0x18,%esp
	return spawn(prog, &arg0);
  803031:	8d 45 0c             	lea    0xc(%ebp),%eax
  803034:	89 44 24 04          	mov    %eax,0x4(%esp)
  803038:	8b 45 08             	mov    0x8(%ebp),%eax
  80303b:	89 04 24             	mov    %eax,(%esp)
  80303e:	e8 c9 f9 ff ff       	call   802a0c <spawn>
}
  803043:	c9                   	leave  
  803044:	c3                   	ret    
	...

00803050 <devsock_stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  803050:	55                   	push   %ebp
  803051:	89 e5                	mov    %esp,%ebp
  803053:	83 ec 18             	sub    $0x18,%esp
	strcpy(stat->st_name, "<sock>");
  803056:	c7 44 24 04 6e 46 80 	movl   $0x80466e,0x4(%esp)
  80305d:	00 
  80305e:	8b 45 0c             	mov    0xc(%ebp),%eax
  803061:	89 04 24             	mov    %eax,(%esp)
  803064:	e8 01 e3 ff ff       	call   80136a <strcpy>
	return 0;
}
  803069:	b8 00 00 00 00       	mov    $0x0,%eax
  80306e:	c9                   	leave  
  80306f:	c3                   	ret    

00803070 <devsock_close>:
	return nsipc_shutdown(r, how);
}

static int
devsock_close(struct Fd *fd)
{
  803070:	55                   	push   %ebp
  803071:	89 e5                	mov    %esp,%ebp
  803073:	83 ec 18             	sub    $0x18,%esp
	return nsipc_close(fd->fd_sock.sockid);
  803076:	8b 45 08             	mov    0x8(%ebp),%eax
  803079:	8b 40 0c             	mov    0xc(%eax),%eax
  80307c:	89 04 24             	mov    %eax,(%esp)
  80307f:	e8 9e 02 00 00       	call   803322 <nsipc_close>
}
  803084:	c9                   	leave  
  803085:	c3                   	ret    

00803086 <devsock_write>:
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
}

static ssize_t
devsock_write(struct Fd *fd, const void *buf, size_t n)
{
  803086:	55                   	push   %ebp
  803087:	89 e5                	mov    %esp,%ebp
  803089:	83 ec 18             	sub    $0x18,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  80308c:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  803093:	00 
  803094:	8b 45 10             	mov    0x10(%ebp),%eax
  803097:	89 44 24 08          	mov    %eax,0x8(%esp)
  80309b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80309e:	89 44 24 04          	mov    %eax,0x4(%esp)
  8030a2:	8b 45 08             	mov    0x8(%ebp),%eax
  8030a5:	8b 40 0c             	mov    0xc(%eax),%eax
  8030a8:	89 04 24             	mov    %eax,(%esp)
  8030ab:	e8 ae 02 00 00       	call   80335e <nsipc_send>
}
  8030b0:	c9                   	leave  
  8030b1:	c3                   	ret    

008030b2 <devsock_read>:
	return nsipc_listen(r, backlog);
}

static ssize_t
devsock_read(struct Fd *fd, void *buf, size_t n)
{
  8030b2:	55                   	push   %ebp
  8030b3:	89 e5                	mov    %esp,%ebp
  8030b5:	83 ec 18             	sub    $0x18,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  8030b8:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  8030bf:	00 
  8030c0:	8b 45 10             	mov    0x10(%ebp),%eax
  8030c3:	89 44 24 08          	mov    %eax,0x8(%esp)
  8030c7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8030ca:	89 44 24 04          	mov    %eax,0x4(%esp)
  8030ce:	8b 45 08             	mov    0x8(%ebp),%eax
  8030d1:	8b 40 0c             	mov    0xc(%eax),%eax
  8030d4:	89 04 24             	mov    %eax,(%esp)
  8030d7:	e8 f5 02 00 00       	call   8033d1 <nsipc_recv>
}
  8030dc:	c9                   	leave  
  8030dd:	c3                   	ret    

008030de <alloc_sockfd>:
	return sfd->fd_sock.sockid;
}

static int
alloc_sockfd(int sockid)
{
  8030de:	55                   	push   %ebp
  8030df:	89 e5                	mov    %esp,%ebp
  8030e1:	56                   	push   %esi
  8030e2:	53                   	push   %ebx
  8030e3:	83 ec 20             	sub    $0x20,%esp
  8030e6:	89 c6                	mov    %eax,%esi
	struct Fd *sfd;
	int r;

	if ((r = fd_alloc(&sfd)) < 0
  8030e8:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8030eb:	89 04 24             	mov    %eax,(%esp)
  8030ee:	e8 78 ef ff ff       	call   80206b <fd_alloc>
  8030f3:	89 c3                	mov    %eax,%ebx
  8030f5:	85 c0                	test   %eax,%eax
  8030f7:	78 21                	js     80311a <alloc_sockfd+0x3c>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U)) < 0) {
  8030f9:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  803100:	00 
  803101:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803104:	89 44 24 04          	mov    %eax,0x4(%esp)
  803108:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80310f:	e8 47 ea ff ff       	call   801b5b <sys_page_alloc>
  803114:	89 c3                	mov    %eax,%ebx
alloc_sockfd(int sockid)
{
	struct Fd *sfd;
	int r;

	if ((r = fd_alloc(&sfd)) < 0
  803116:	85 c0                	test   %eax,%eax
  803118:	79 0a                	jns    803124 <alloc_sockfd+0x46>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U)) < 0) {
		nsipc_close(sockid);
  80311a:	89 34 24             	mov    %esi,(%esp)
  80311d:	e8 00 02 00 00       	call   803322 <nsipc_close>
		return r;
  803122:	eb 28                	jmp    80314c <alloc_sockfd+0x6e>
	}

	sfd->fd_dev_id = devsock.dev_id;
  803124:	8b 15 3c 80 80 00    	mov    0x80803c,%edx
  80312a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80312d:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  80312f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803132:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	sfd->fd_sock.sockid = sockid;
  803139:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80313c:	89 70 0c             	mov    %esi,0xc(%eax)
	return fd2num(sfd);
  80313f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803142:	89 04 24             	mov    %eax,(%esp)
  803145:	e8 f6 ee ff ff       	call   802040 <fd2num>
  80314a:	89 c3                	mov    %eax,%ebx
}
  80314c:	89 d8                	mov    %ebx,%eax
  80314e:	83 c4 20             	add    $0x20,%esp
  803151:	5b                   	pop    %ebx
  803152:	5e                   	pop    %esi
  803153:	5d                   	pop    %ebp
  803154:	c3                   	ret    

00803155 <socket>:
	return 0;
}

int
socket(int domain, int type, int protocol)
{
  803155:	55                   	push   %ebp
  803156:	89 e5                	mov    %esp,%ebp
  803158:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  80315b:	8b 45 10             	mov    0x10(%ebp),%eax
  80315e:	89 44 24 08          	mov    %eax,0x8(%esp)
  803162:	8b 45 0c             	mov    0xc(%ebp),%eax
  803165:	89 44 24 04          	mov    %eax,0x4(%esp)
  803169:	8b 45 08             	mov    0x8(%ebp),%eax
  80316c:	89 04 24             	mov    %eax,(%esp)
  80316f:	e8 62 01 00 00       	call   8032d6 <nsipc_socket>
  803174:	85 c0                	test   %eax,%eax
  803176:	78 05                	js     80317d <socket+0x28>
		return r;
	return alloc_sockfd(r);
  803178:	e8 61 ff ff ff       	call   8030de <alloc_sockfd>
}
  80317d:	c9                   	leave  
  80317e:	66 90                	xchg   %ax,%ax
  803180:	c3                   	ret    

00803181 <fd2sockid>:
	.dev_stat =	devsock_stat,
};

static int
fd2sockid(int fd)
{
  803181:	55                   	push   %ebp
  803182:	89 e5                	mov    %esp,%ebp
  803184:	83 ec 28             	sub    $0x28,%esp
	struct Fd *sfd;
	int r;

	if ((r = fd_lookup(fd, &sfd)) < 0)
  803187:	8d 55 f4             	lea    -0xc(%ebp),%edx
  80318a:	89 54 24 04          	mov    %edx,0x4(%esp)
  80318e:	89 04 24             	mov    %eax,(%esp)
  803191:	e8 47 ef ff ff       	call   8020dd <fd_lookup>
  803196:	85 c0                	test   %eax,%eax
  803198:	78 15                	js     8031af <fd2sockid+0x2e>
		return r;
	if (sfd->fd_dev_id != devsock.dev_id)
  80319a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80319d:	8b 0a                	mov    (%edx),%ecx
  80319f:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8031a4:	3b 0d 3c 80 80 00    	cmp    0x80803c,%ecx
  8031aa:	75 03                	jne    8031af <fd2sockid+0x2e>
		return -E_NOT_SUPP;
	return sfd->fd_sock.sockid;
  8031ac:	8b 42 0c             	mov    0xc(%edx),%eax
}
  8031af:	c9                   	leave  
  8031b0:	c3                   	ret    

008031b1 <listen>:
	return nsipc_connect(r, name, namelen);
}

int
listen(int s, int backlog)
{
  8031b1:	55                   	push   %ebp
  8031b2:	89 e5                	mov    %esp,%ebp
  8031b4:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  8031b7:	8b 45 08             	mov    0x8(%ebp),%eax
  8031ba:	e8 c2 ff ff ff       	call   803181 <fd2sockid>
  8031bf:	85 c0                	test   %eax,%eax
  8031c1:	78 0f                	js     8031d2 <listen+0x21>
		return r;
	return nsipc_listen(r, backlog);
  8031c3:	8b 55 0c             	mov    0xc(%ebp),%edx
  8031c6:	89 54 24 04          	mov    %edx,0x4(%esp)
  8031ca:	89 04 24             	mov    %eax,(%esp)
  8031cd:	e8 2e 01 00 00       	call   803300 <nsipc_listen>
}
  8031d2:	c9                   	leave  
  8031d3:	c3                   	ret    

008031d4 <connect>:
	return nsipc_close(fd->fd_sock.sockid);
}

int
connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  8031d4:	55                   	push   %ebp
  8031d5:	89 e5                	mov    %esp,%ebp
  8031d7:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  8031da:	8b 45 08             	mov    0x8(%ebp),%eax
  8031dd:	e8 9f ff ff ff       	call   803181 <fd2sockid>
  8031e2:	85 c0                	test   %eax,%eax
  8031e4:	78 16                	js     8031fc <connect+0x28>
		return r;
	return nsipc_connect(r, name, namelen);
  8031e6:	8b 55 10             	mov    0x10(%ebp),%edx
  8031e9:	89 54 24 08          	mov    %edx,0x8(%esp)
  8031ed:	8b 55 0c             	mov    0xc(%ebp),%edx
  8031f0:	89 54 24 04          	mov    %edx,0x4(%esp)
  8031f4:	89 04 24             	mov    %eax,(%esp)
  8031f7:	e8 55 02 00 00       	call   803451 <nsipc_connect>
}
  8031fc:	c9                   	leave  
  8031fd:	c3                   	ret    

008031fe <shutdown>:
	return nsipc_bind(r, name, namelen);
}

int
shutdown(int s, int how)
{
  8031fe:	55                   	push   %ebp
  8031ff:	89 e5                	mov    %esp,%ebp
  803201:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  803204:	8b 45 08             	mov    0x8(%ebp),%eax
  803207:	e8 75 ff ff ff       	call   803181 <fd2sockid>
  80320c:	85 c0                	test   %eax,%eax
  80320e:	78 0f                	js     80321f <shutdown+0x21>
		return r;
	return nsipc_shutdown(r, how);
  803210:	8b 55 0c             	mov    0xc(%ebp),%edx
  803213:	89 54 24 04          	mov    %edx,0x4(%esp)
  803217:	89 04 24             	mov    %eax,(%esp)
  80321a:	e8 1d 01 00 00       	call   80333c <nsipc_shutdown>
}
  80321f:	c9                   	leave  
  803220:	c3                   	ret    

00803221 <bind>:
	return alloc_sockfd(r);
}

int
bind(int s, struct sockaddr *name, socklen_t namelen)
{
  803221:	55                   	push   %ebp
  803222:	89 e5                	mov    %esp,%ebp
  803224:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  803227:	8b 45 08             	mov    0x8(%ebp),%eax
  80322a:	e8 52 ff ff ff       	call   803181 <fd2sockid>
  80322f:	85 c0                	test   %eax,%eax
  803231:	78 16                	js     803249 <bind+0x28>
		return r;
	return nsipc_bind(r, name, namelen);
  803233:	8b 55 10             	mov    0x10(%ebp),%edx
  803236:	89 54 24 08          	mov    %edx,0x8(%esp)
  80323a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80323d:	89 54 24 04          	mov    %edx,0x4(%esp)
  803241:	89 04 24             	mov    %eax,(%esp)
  803244:	e8 47 02 00 00       	call   803490 <nsipc_bind>
}
  803249:	c9                   	leave  
  80324a:	c3                   	ret    

0080324b <accept>:
	return fd2num(sfd);
}

int
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  80324b:	55                   	push   %ebp
  80324c:	89 e5                	mov    %esp,%ebp
  80324e:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  803251:	8b 45 08             	mov    0x8(%ebp),%eax
  803254:	e8 28 ff ff ff       	call   803181 <fd2sockid>
  803259:	85 c0                	test   %eax,%eax
  80325b:	78 1f                	js     80327c <accept+0x31>
		return r;
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  80325d:	8b 55 10             	mov    0x10(%ebp),%edx
  803260:	89 54 24 08          	mov    %edx,0x8(%esp)
  803264:	8b 55 0c             	mov    0xc(%ebp),%edx
  803267:	89 54 24 04          	mov    %edx,0x4(%esp)
  80326b:	89 04 24             	mov    %eax,(%esp)
  80326e:	e8 5c 02 00 00       	call   8034cf <nsipc_accept>
  803273:	85 c0                	test   %eax,%eax
  803275:	78 05                	js     80327c <accept+0x31>
		return r;
	return alloc_sockfd(r);
  803277:	e8 62 fe ff ff       	call   8030de <alloc_sockfd>
}
  80327c:	c9                   	leave  
  80327d:	8d 76 00             	lea    0x0(%esi),%esi
  803280:	c3                   	ret    
	...

00803290 <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  803290:	55                   	push   %ebp
  803291:	89 e5                	mov    %esp,%ebp
  803293:	83 ec 18             	sub    $0x18,%esp
	if (debug)
		cprintf("[%08x] nsipc %d\n", env->env_id, type);

	ipc_send(envs[2].env_id, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  803296:	8b 15 44 01 c0 ee    	mov    0xeec00144,%edx
  80329c:	c7 44 24 0c 07 00 00 	movl   $0x7,0xc(%esp)
  8032a3:	00 
  8032a4:	c7 44 24 08 00 70 80 	movl   $0x807000,0x8(%esp)
  8032ab:	00 
  8032ac:	89 44 24 04          	mov    %eax,0x4(%esp)
  8032b0:	89 14 24             	mov    %edx,(%esp)
  8032b3:	e8 78 07 00 00       	call   803a30 <ipc_send>
	return ipc_recv(NULL, NULL, NULL);
  8032b8:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  8032bf:	00 
  8032c0:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  8032c7:	00 
  8032c8:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8032cf:	e8 c2 07 00 00       	call   803a96 <ipc_recv>
}
  8032d4:	c9                   	leave  
  8032d5:	c3                   	ret    

008032d6 <nsipc_socket>:
	return nsipc(NSREQ_SEND);
}

int
nsipc_socket(int domain, int type, int protocol)
{
  8032d6:	55                   	push   %ebp
  8032d7:	89 e5                	mov    %esp,%ebp
  8032d9:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  8032dc:	8b 45 08             	mov    0x8(%ebp),%eax
  8032df:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.socket.req_type = type;
  8032e4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8032e7:	a3 04 70 80 00       	mov    %eax,0x807004
	nsipcbuf.socket.req_protocol = protocol;
  8032ec:	8b 45 10             	mov    0x10(%ebp),%eax
  8032ef:	a3 08 70 80 00       	mov    %eax,0x807008
	return nsipc(NSREQ_SOCKET);
  8032f4:	b8 09 00 00 00       	mov    $0x9,%eax
  8032f9:	e8 92 ff ff ff       	call   803290 <nsipc>
}
  8032fe:	c9                   	leave  
  8032ff:	c3                   	ret    

00803300 <nsipc_listen>:
	return nsipc(NSREQ_CONNECT);
}

int
nsipc_listen(int s, int backlog)
{
  803300:	55                   	push   %ebp
  803301:	89 e5                	mov    %esp,%ebp
  803303:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  803306:	8b 45 08             	mov    0x8(%ebp),%eax
  803309:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.listen.req_backlog = backlog;
  80330e:	8b 45 0c             	mov    0xc(%ebp),%eax
  803311:	a3 04 70 80 00       	mov    %eax,0x807004
	return nsipc(NSREQ_LISTEN);
  803316:	b8 06 00 00 00       	mov    $0x6,%eax
  80331b:	e8 70 ff ff ff       	call   803290 <nsipc>
}
  803320:	c9                   	leave  
  803321:	c3                   	ret    

00803322 <nsipc_close>:
	return nsipc(NSREQ_SHUTDOWN);
}

int
nsipc_close(int s)
{
  803322:	55                   	push   %ebp
  803323:	89 e5                	mov    %esp,%ebp
  803325:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  803328:	8b 45 08             	mov    0x8(%ebp),%eax
  80332b:	a3 00 70 80 00       	mov    %eax,0x807000
	return nsipc(NSREQ_CLOSE);
  803330:	b8 04 00 00 00       	mov    $0x4,%eax
  803335:	e8 56 ff ff ff       	call   803290 <nsipc>
}
  80333a:	c9                   	leave  
  80333b:	c3                   	ret    

0080333c <nsipc_shutdown>:
	return nsipc(NSREQ_BIND);
}

int
nsipc_shutdown(int s, int how)
{
  80333c:	55                   	push   %ebp
  80333d:	89 e5                	mov    %esp,%ebp
  80333f:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  803342:	8b 45 08             	mov    0x8(%ebp),%eax
  803345:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.shutdown.req_how = how;
  80334a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80334d:	a3 04 70 80 00       	mov    %eax,0x807004
	return nsipc(NSREQ_SHUTDOWN);
  803352:	b8 03 00 00 00       	mov    $0x3,%eax
  803357:	e8 34 ff ff ff       	call   803290 <nsipc>
}
  80335c:	c9                   	leave  
  80335d:	c3                   	ret    

0080335e <nsipc_send>:
	return r;
}

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  80335e:	55                   	push   %ebp
  80335f:	89 e5                	mov    %esp,%ebp
  803361:	53                   	push   %ebx
  803362:	83 ec 14             	sub    $0x14,%esp
  803365:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  803368:	8b 45 08             	mov    0x8(%ebp),%eax
  80336b:	a3 00 70 80 00       	mov    %eax,0x807000
	assert(size < 1600);
  803370:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  803376:	7e 24                	jle    80339c <nsipc_send+0x3e>
  803378:	c7 44 24 0c 7a 46 80 	movl   $0x80467a,0xc(%esp)
  80337f:	00 
  803380:	c7 44 24 08 81 3f 80 	movl   $0x803f81,0x8(%esp)
  803387:	00 
  803388:	c7 44 24 04 66 00 00 	movl   $0x66,0x4(%esp)
  80338f:	00 
  803390:	c7 04 24 86 46 80 00 	movl   $0x804686,(%esp)
  803397:	e8 5c d7 ff ff       	call   800af8 <_panic>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  80339c:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8033a0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8033a3:	89 44 24 04          	mov    %eax,0x4(%esp)
  8033a7:	c7 04 24 0c 70 80 00 	movl   $0x80700c,(%esp)
  8033ae:	e8 72 e1 ff ff       	call   801525 <memmove>
	nsipcbuf.send.req_size = size;
  8033b3:	89 1d 04 70 80 00    	mov    %ebx,0x807004
	nsipcbuf.send.req_flags = flags;
  8033b9:	8b 45 14             	mov    0x14(%ebp),%eax
  8033bc:	a3 08 70 80 00       	mov    %eax,0x807008
	return nsipc(NSREQ_SEND);
  8033c1:	b8 08 00 00 00       	mov    $0x8,%eax
  8033c6:	e8 c5 fe ff ff       	call   803290 <nsipc>
}
  8033cb:	83 c4 14             	add    $0x14,%esp
  8033ce:	5b                   	pop    %ebx
  8033cf:	5d                   	pop    %ebp
  8033d0:	c3                   	ret    

008033d1 <nsipc_recv>:
	return nsipc(NSREQ_LISTEN);
}

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  8033d1:	55                   	push   %ebp
  8033d2:	89 e5                	mov    %esp,%ebp
  8033d4:	56                   	push   %esi
  8033d5:	53                   	push   %ebx
  8033d6:	83 ec 10             	sub    $0x10,%esp
  8033d9:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  8033dc:	8b 45 08             	mov    0x8(%ebp),%eax
  8033df:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.recv.req_len = len;
  8033e4:	89 35 04 70 80 00    	mov    %esi,0x807004
	nsipcbuf.recv.req_flags = flags;
  8033ea:	8b 45 14             	mov    0x14(%ebp),%eax
  8033ed:	a3 08 70 80 00       	mov    %eax,0x807008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  8033f2:	b8 07 00 00 00       	mov    $0x7,%eax
  8033f7:	e8 94 fe ff ff       	call   803290 <nsipc>
  8033fc:	89 c3                	mov    %eax,%ebx
  8033fe:	85 c0                	test   %eax,%eax
  803400:	78 46                	js     803448 <nsipc_recv+0x77>
		assert(r < 1600 && r <= len);
  803402:	3d 3f 06 00 00       	cmp    $0x63f,%eax
  803407:	7f 04                	jg     80340d <nsipc_recv+0x3c>
  803409:	39 c6                	cmp    %eax,%esi
  80340b:	7d 24                	jge    803431 <nsipc_recv+0x60>
  80340d:	c7 44 24 0c 92 46 80 	movl   $0x804692,0xc(%esp)
  803414:	00 
  803415:	c7 44 24 08 81 3f 80 	movl   $0x803f81,0x8(%esp)
  80341c:	00 
  80341d:	c7 44 24 04 5b 00 00 	movl   $0x5b,0x4(%esp)
  803424:	00 
  803425:	c7 04 24 86 46 80 00 	movl   $0x804686,(%esp)
  80342c:	e8 c7 d6 ff ff       	call   800af8 <_panic>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  803431:	89 44 24 08          	mov    %eax,0x8(%esp)
  803435:	c7 44 24 04 00 70 80 	movl   $0x807000,0x4(%esp)
  80343c:	00 
  80343d:	8b 45 0c             	mov    0xc(%ebp),%eax
  803440:	89 04 24             	mov    %eax,(%esp)
  803443:	e8 dd e0 ff ff       	call   801525 <memmove>
	}

	return r;
}
  803448:	89 d8                	mov    %ebx,%eax
  80344a:	83 c4 10             	add    $0x10,%esp
  80344d:	5b                   	pop    %ebx
  80344e:	5e                   	pop    %esi
  80344f:	5d                   	pop    %ebp
  803450:	c3                   	ret    

00803451 <nsipc_connect>:
	return nsipc(NSREQ_CLOSE);
}

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  803451:	55                   	push   %ebp
  803452:	89 e5                	mov    %esp,%ebp
  803454:	53                   	push   %ebx
  803455:	83 ec 14             	sub    $0x14,%esp
  803458:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  80345b:	8b 45 08             	mov    0x8(%ebp),%eax
  80345e:	a3 00 70 80 00       	mov    %eax,0x807000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  803463:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  803467:	8b 45 0c             	mov    0xc(%ebp),%eax
  80346a:	89 44 24 04          	mov    %eax,0x4(%esp)
  80346e:	c7 04 24 04 70 80 00 	movl   $0x807004,(%esp)
  803475:	e8 ab e0 ff ff       	call   801525 <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  80347a:	89 1d 14 70 80 00    	mov    %ebx,0x807014
	return nsipc(NSREQ_CONNECT);
  803480:	b8 05 00 00 00       	mov    $0x5,%eax
  803485:	e8 06 fe ff ff       	call   803290 <nsipc>
}
  80348a:	83 c4 14             	add    $0x14,%esp
  80348d:	5b                   	pop    %ebx
  80348e:	5d                   	pop    %ebp
  80348f:	c3                   	ret    

00803490 <nsipc_bind>:
	return r;
}

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  803490:	55                   	push   %ebp
  803491:	89 e5                	mov    %esp,%ebp
  803493:	53                   	push   %ebx
  803494:	83 ec 14             	sub    $0x14,%esp
  803497:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  80349a:	8b 45 08             	mov    0x8(%ebp),%eax
  80349d:	a3 00 70 80 00       	mov    %eax,0x807000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  8034a2:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8034a6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8034a9:	89 44 24 04          	mov    %eax,0x4(%esp)
  8034ad:	c7 04 24 04 70 80 00 	movl   $0x807004,(%esp)
  8034b4:	e8 6c e0 ff ff       	call   801525 <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  8034b9:	89 1d 14 70 80 00    	mov    %ebx,0x807014
	return nsipc(NSREQ_BIND);
  8034bf:	b8 02 00 00 00       	mov    $0x2,%eax
  8034c4:	e8 c7 fd ff ff       	call   803290 <nsipc>
}
  8034c9:	83 c4 14             	add    $0x14,%esp
  8034cc:	5b                   	pop    %ebx
  8034cd:	5d                   	pop    %ebp
  8034ce:	c3                   	ret    

008034cf <nsipc_accept>:
	return ipc_recv(NULL, NULL, NULL);
}

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  8034cf:	55                   	push   %ebp
  8034d0:	89 e5                	mov    %esp,%ebp
  8034d2:	83 ec 18             	sub    $0x18,%esp
  8034d5:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  8034d8:	89 75 fc             	mov    %esi,-0x4(%ebp)
	int r;
	
	nsipcbuf.accept.req_s = s;
  8034db:	8b 45 08             	mov    0x8(%ebp),%eax
  8034de:	a3 00 70 80 00       	mov    %eax,0x807000
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  8034e3:	b8 01 00 00 00       	mov    $0x1,%eax
  8034e8:	e8 a3 fd ff ff       	call   803290 <nsipc>
  8034ed:	89 c3                	mov    %eax,%ebx
  8034ef:	85 c0                	test   %eax,%eax
  8034f1:	78 25                	js     803518 <nsipc_accept+0x49>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  8034f3:	be 10 70 80 00       	mov    $0x807010,%esi
  8034f8:	8b 06                	mov    (%esi),%eax
  8034fa:	89 44 24 08          	mov    %eax,0x8(%esp)
  8034fe:	c7 44 24 04 00 70 80 	movl   $0x807000,0x4(%esp)
  803505:	00 
  803506:	8b 45 0c             	mov    0xc(%ebp),%eax
  803509:	89 04 24             	mov    %eax,(%esp)
  80350c:	e8 14 e0 ff ff       	call   801525 <memmove>
		*addrlen = ret->ret_addrlen;
  803511:	8b 16                	mov    (%esi),%edx
  803513:	8b 45 10             	mov    0x10(%ebp),%eax
  803516:	89 10                	mov    %edx,(%eax)
	}
	return r;
}
  803518:	89 d8                	mov    %ebx,%eax
  80351a:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  80351d:	8b 75 fc             	mov    -0x4(%ebp),%esi
  803520:	89 ec                	mov    %ebp,%esp
  803522:	5d                   	pop    %ebp
  803523:	c3                   	ret    
	...

00803530 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  803530:	55                   	push   %ebp
  803531:	89 e5                	mov    %esp,%ebp
  803533:	83 ec 18             	sub    $0x18,%esp
  803536:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  803539:	89 75 fc             	mov    %esi,-0x4(%ebp)
  80353c:	8b 75 0c             	mov    0xc(%ebp),%esi
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  80353f:	8b 45 08             	mov    0x8(%ebp),%eax
  803542:	89 04 24             	mov    %eax,(%esp)
  803545:	e8 06 eb ff ff       	call   802050 <fd2data>
  80354a:	89 c3                	mov    %eax,%ebx
	strcpy(stat->st_name, "<pipe>");
  80354c:	c7 44 24 04 a7 46 80 	movl   $0x8046a7,0x4(%esp)
  803553:	00 
  803554:	89 34 24             	mov    %esi,(%esp)
  803557:	e8 0e de ff ff       	call   80136a <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  80355c:	8b 43 04             	mov    0x4(%ebx),%eax
  80355f:	2b 03                	sub    (%ebx),%eax
  803561:	89 86 80 00 00 00    	mov    %eax,0x80(%esi)
	stat->st_isdir = 0;
  803567:	c7 86 84 00 00 00 00 	movl   $0x0,0x84(%esi)
  80356e:	00 00 00 
	stat->st_dev = &devpipe;
  803571:	c7 86 88 00 00 00 58 	movl   $0x808058,0x88(%esi)
  803578:	80 80 00 
	return 0;
}
  80357b:	b8 00 00 00 00       	mov    $0x0,%eax
  803580:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  803583:	8b 75 fc             	mov    -0x4(%ebp),%esi
  803586:	89 ec                	mov    %ebp,%esp
  803588:	5d                   	pop    %ebp
  803589:	c3                   	ret    

0080358a <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  80358a:	55                   	push   %ebp
  80358b:	89 e5                	mov    %esp,%ebp
  80358d:	53                   	push   %ebx
  80358e:	83 ec 14             	sub    $0x14,%esp
  803591:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  803594:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  803598:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80359f:	e8 fb e4 ff ff       	call   801a9f <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  8035a4:	89 1c 24             	mov    %ebx,(%esp)
  8035a7:	e8 a4 ea ff ff       	call   802050 <fd2data>
  8035ac:	89 44 24 04          	mov    %eax,0x4(%esp)
  8035b0:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8035b7:	e8 e3 e4 ff ff       	call   801a9f <sys_page_unmap>
}
  8035bc:	83 c4 14             	add    $0x14,%esp
  8035bf:	5b                   	pop    %ebx
  8035c0:	5d                   	pop    %ebp
  8035c1:	c3                   	ret    

008035c2 <_pipeisclosed>:
	return r;
}

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  8035c2:	55                   	push   %ebp
  8035c3:	89 e5                	mov    %esp,%ebp
  8035c5:	57                   	push   %edi
  8035c6:	56                   	push   %esi
  8035c7:	53                   	push   %ebx
  8035c8:	83 ec 2c             	sub    $0x2c,%esp
  8035cb:	89 c7                	mov    %eax,%edi
  8035cd:	89 55 e4             	mov    %edx,-0x1c(%ebp)
	int n, nn, ret;

	while (1) {
		n = env->env_runs;
  8035d0:	a1 a0 84 80 00       	mov    0x8084a0,%eax
  8035d5:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  8035d8:	89 3c 24             	mov    %edi,(%esp)
  8035db:	e8 20 05 00 00       	call   803b00 <pageref>
  8035e0:	89 c6                	mov    %eax,%esi
  8035e2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8035e5:	89 04 24             	mov    %eax,(%esp)
  8035e8:	e8 13 05 00 00       	call   803b00 <pageref>
  8035ed:	39 c6                	cmp    %eax,%esi
  8035ef:	0f 94 c0             	sete   %al
  8035f2:	0f b6 c0             	movzbl %al,%eax
		nn = env->env_runs;
  8035f5:	8b 15 a0 84 80 00    	mov    0x8084a0,%edx
  8035fb:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  8035fe:	39 cb                	cmp    %ecx,%ebx
  803600:	75 08                	jne    80360a <_pipeisclosed+0x48>
			return ret;
		if (n != nn && ret == 1)
			cprintf("pipe race avoided\n", n, env->env_runs, ret);
	}
}
  803602:	83 c4 2c             	add    $0x2c,%esp
  803605:	5b                   	pop    %ebx
  803606:	5e                   	pop    %esi
  803607:	5f                   	pop    %edi
  803608:	5d                   	pop    %ebp
  803609:	c3                   	ret    
		n = env->env_runs;
		ret = pageref(fd) == pageref(p);
		nn = env->env_runs;
		if (n == nn)
			return ret;
		if (n != nn && ret == 1)
  80360a:	83 f8 01             	cmp    $0x1,%eax
  80360d:	75 c1                	jne    8035d0 <_pipeisclosed+0xe>
			cprintf("pipe race avoided\n", n, env->env_runs, ret);
  80360f:	8b 52 58             	mov    0x58(%edx),%edx
  803612:	89 44 24 0c          	mov    %eax,0xc(%esp)
  803616:	89 54 24 08          	mov    %edx,0x8(%esp)
  80361a:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  80361e:	c7 04 24 ae 46 80 00 	movl   $0x8046ae,(%esp)
  803625:	e8 93 d5 ff ff       	call   800bbd <cprintf>
  80362a:	eb a4                	jmp    8035d0 <_pipeisclosed+0xe>

0080362c <devpipe_write>:
	return i;
}

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  80362c:	55                   	push   %ebp
  80362d:	89 e5                	mov    %esp,%ebp
  80362f:	57                   	push   %edi
  803630:	56                   	push   %esi
  803631:	53                   	push   %ebx
  803632:	83 ec 1c             	sub    $0x1c,%esp
  803635:	8b 75 08             	mov    0x8(%ebp),%esi
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  803638:	89 34 24             	mov    %esi,(%esp)
  80363b:	e8 10 ea ff ff       	call   802050 <fd2data>
  803640:	89 c3                	mov    %eax,%ebx
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			env->env_id, vpt[VPN(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  803642:	bf 00 00 00 00       	mov    $0x0,%edi
  803647:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80364b:	75 54                	jne    8036a1 <devpipe_write+0x75>
  80364d:	eb 60                	jmp    8036af <devpipe_write+0x83>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  80364f:	89 da                	mov    %ebx,%edx
  803651:	89 f0                	mov    %esi,%eax
  803653:	e8 6a ff ff ff       	call   8035c2 <_pipeisclosed>
  803658:	85 c0                	test   %eax,%eax
  80365a:	74 07                	je     803663 <devpipe_write+0x37>
  80365c:	b8 00 00 00 00       	mov    $0x0,%eax
  803661:	eb 53                	jmp    8036b6 <devpipe_write+0x8a>
				return 0;
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  803663:	90                   	nop
  803664:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  803668:	e8 4d e5 ff ff       	call   801bba <sys_yield>
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			env->env_id, vpt[VPN(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  80366d:	8b 43 04             	mov    0x4(%ebx),%eax
  803670:	8b 13                	mov    (%ebx),%edx
  803672:	83 c2 20             	add    $0x20,%edx
  803675:	39 d0                	cmp    %edx,%eax
  803677:	73 d6                	jae    80364f <devpipe_write+0x23>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  803679:	89 c2                	mov    %eax,%edx
  80367b:	c1 fa 1f             	sar    $0x1f,%edx
  80367e:	c1 ea 1b             	shr    $0x1b,%edx
  803681:	01 d0                	add    %edx,%eax
  803683:	83 e0 1f             	and    $0x1f,%eax
  803686:	29 d0                	sub    %edx,%eax
  803688:	89 c2                	mov    %eax,%edx
  80368a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80368d:	0f b6 04 39          	movzbl (%ecx,%edi,1),%eax
  803691:	88 44 13 08          	mov    %al,0x8(%ebx,%edx,1)
		p->p_wpos++;
  803695:	83 43 04 01          	addl   $0x1,0x4(%ebx)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			env->env_id, vpt[VPN(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  803699:	83 c7 01             	add    $0x1,%edi
  80369c:	39 7d 10             	cmp    %edi,0x10(%ebp)
  80369f:	76 13                	jbe    8036b4 <devpipe_write+0x88>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  8036a1:	8b 43 04             	mov    0x4(%ebx),%eax
  8036a4:	8b 13                	mov    (%ebx),%edx
  8036a6:	83 c2 20             	add    $0x20,%edx
  8036a9:	39 d0                	cmp    %edx,%eax
  8036ab:	73 a2                	jae    80364f <devpipe_write+0x23>
  8036ad:	eb ca                	jmp    803679 <devpipe_write+0x4d>
  8036af:	bf 00 00 00 00       	mov    $0x0,%edi
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}
	
	return i;
  8036b4:	89 f8                	mov    %edi,%eax
}
  8036b6:	83 c4 1c             	add    $0x1c,%esp
  8036b9:	5b                   	pop    %ebx
  8036ba:	5e                   	pop    %esi
  8036bb:	5f                   	pop    %edi
  8036bc:	5d                   	pop    %ebp
  8036bd:	c3                   	ret    

008036be <devpipe_read>:
	return _pipeisclosed(fd, p);
}

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  8036be:	55                   	push   %ebp
  8036bf:	89 e5                	mov    %esp,%ebp
  8036c1:	83 ec 28             	sub    $0x28,%esp
  8036c4:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  8036c7:	89 75 f8             	mov    %esi,-0x8(%ebp)
  8036ca:	89 7d fc             	mov    %edi,-0x4(%ebp)
  8036cd:	8b 7d 08             	mov    0x8(%ebp),%edi
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  8036d0:	89 3c 24             	mov    %edi,(%esp)
  8036d3:	e8 78 e9 ff ff       	call   802050 <fd2data>
  8036d8:	89 c3                	mov    %eax,%ebx
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			env->env_id, vpt[VPN(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  8036da:	be 00 00 00 00       	mov    $0x0,%esi
  8036df:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8036e3:	75 4c                	jne    803731 <devpipe_read+0x73>
  8036e5:	eb 5b                	jmp    803742 <devpipe_read+0x84>
		while (p->p_rpos == p->p_wpos) {
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
				return i;
  8036e7:	89 f0                	mov    %esi,%eax
  8036e9:	eb 5e                	jmp    803749 <devpipe_read+0x8b>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  8036eb:	89 da                	mov    %ebx,%edx
  8036ed:	89 f8                	mov    %edi,%eax
  8036ef:	90                   	nop
  8036f0:	e8 cd fe ff ff       	call   8035c2 <_pipeisclosed>
  8036f5:	85 c0                	test   %eax,%eax
  8036f7:	74 07                	je     803700 <devpipe_read+0x42>
  8036f9:	b8 00 00 00 00       	mov    $0x0,%eax
  8036fe:	eb 49                	jmp    803749 <devpipe_read+0x8b>
				return 0;
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  803700:	e8 b5 e4 ff ff       	call   801bba <sys_yield>
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			env->env_id, vpt[VPN(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  803705:	8b 03                	mov    (%ebx),%eax
  803707:	3b 43 04             	cmp    0x4(%ebx),%eax
  80370a:	74 df                	je     8036eb <devpipe_read+0x2d>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  80370c:	89 c2                	mov    %eax,%edx
  80370e:	c1 fa 1f             	sar    $0x1f,%edx
  803711:	c1 ea 1b             	shr    $0x1b,%edx
  803714:	01 d0                	add    %edx,%eax
  803716:	83 e0 1f             	and    $0x1f,%eax
  803719:	29 d0                	sub    %edx,%eax
  80371b:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  803720:	8b 55 0c             	mov    0xc(%ebp),%edx
  803723:	88 04 32             	mov    %al,(%edx,%esi,1)
		p->p_rpos++;
  803726:	83 03 01             	addl   $0x1,(%ebx)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			env->env_id, vpt[VPN(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  803729:	83 c6 01             	add    $0x1,%esi
  80372c:	39 75 10             	cmp    %esi,0x10(%ebp)
  80372f:	76 16                	jbe    803747 <devpipe_read+0x89>
		while (p->p_rpos == p->p_wpos) {
  803731:	8b 03                	mov    (%ebx),%eax
  803733:	3b 43 04             	cmp    0x4(%ebx),%eax
  803736:	75 d4                	jne    80370c <devpipe_read+0x4e>
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  803738:	85 f6                	test   %esi,%esi
  80373a:	75 ab                	jne    8036e7 <devpipe_read+0x29>
  80373c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  803740:	eb a9                	jmp    8036eb <devpipe_read+0x2d>
  803742:	be 00 00 00 00       	mov    $0x0,%esi
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  803747:	89 f0                	mov    %esi,%eax
}
  803749:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  80374c:	8b 75 f8             	mov    -0x8(%ebp),%esi
  80374f:	8b 7d fc             	mov    -0x4(%ebp),%edi
  803752:	89 ec                	mov    %ebp,%esp
  803754:	5d                   	pop    %ebp
  803755:	c3                   	ret    

00803756 <pipeisclosed>:
	}
}

int
pipeisclosed(int fdnum)
{
  803756:	55                   	push   %ebp
  803757:	89 e5                	mov    %esp,%ebp
  803759:	83 ec 28             	sub    $0x28,%esp
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80375c:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80375f:	89 44 24 04          	mov    %eax,0x4(%esp)
  803763:	8b 45 08             	mov    0x8(%ebp),%eax
  803766:	89 04 24             	mov    %eax,(%esp)
  803769:	e8 6f e9 ff ff       	call   8020dd <fd_lookup>
  80376e:	85 c0                	test   %eax,%eax
  803770:	78 15                	js     803787 <pipeisclosed+0x31>
		return r;
	p = (struct Pipe*) fd2data(fd);
  803772:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803775:	89 04 24             	mov    %eax,(%esp)
  803778:	e8 d3 e8 ff ff       	call   802050 <fd2data>
	return _pipeisclosed(fd, p);
  80377d:	89 c2                	mov    %eax,%edx
  80377f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803782:	e8 3b fe ff ff       	call   8035c2 <_pipeisclosed>
}
  803787:	c9                   	leave  
  803788:	c3                   	ret    

00803789 <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  803789:	55                   	push   %ebp
  80378a:	89 e5                	mov    %esp,%ebp
  80378c:	83 ec 48             	sub    $0x48,%esp
  80378f:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  803792:	89 75 f8             	mov    %esi,-0x8(%ebp)
  803795:	89 7d fc             	mov    %edi,-0x4(%ebp)
  803798:	8b 7d 08             	mov    0x8(%ebp),%edi
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  80379b:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  80379e:	89 04 24             	mov    %eax,(%esp)
  8037a1:	e8 c5 e8 ff ff       	call   80206b <fd_alloc>
  8037a6:	89 c3                	mov    %eax,%ebx
  8037a8:	85 c0                	test   %eax,%eax
  8037aa:	0f 88 42 01 00 00    	js     8038f2 <pipe+0x169>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8037b0:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  8037b7:	00 
  8037b8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8037bb:	89 44 24 04          	mov    %eax,0x4(%esp)
  8037bf:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8037c6:	e8 90 e3 ff ff       	call   801b5b <sys_page_alloc>
  8037cb:	89 c3                	mov    %eax,%ebx
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  8037cd:	85 c0                	test   %eax,%eax
  8037cf:	0f 88 1d 01 00 00    	js     8038f2 <pipe+0x169>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  8037d5:	8d 45 e0             	lea    -0x20(%ebp),%eax
  8037d8:	89 04 24             	mov    %eax,(%esp)
  8037db:	e8 8b e8 ff ff       	call   80206b <fd_alloc>
  8037e0:	89 c3                	mov    %eax,%ebx
  8037e2:	85 c0                	test   %eax,%eax
  8037e4:	0f 88 f5 00 00 00    	js     8038df <pipe+0x156>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8037ea:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  8037f1:	00 
  8037f2:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8037f5:	89 44 24 04          	mov    %eax,0x4(%esp)
  8037f9:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  803800:	e8 56 e3 ff ff       	call   801b5b <sys_page_alloc>
  803805:	89 c3                	mov    %eax,%ebx
	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  803807:	85 c0                	test   %eax,%eax
  803809:	0f 88 d0 00 00 00    	js     8038df <pipe+0x156>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  80380f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803812:	89 04 24             	mov    %eax,(%esp)
  803815:	e8 36 e8 ff ff       	call   802050 <fd2data>
  80381a:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80381c:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  803823:	00 
  803824:	89 44 24 04          	mov    %eax,0x4(%esp)
  803828:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80382f:	e8 27 e3 ff ff       	call   801b5b <sys_page_alloc>
  803834:	89 c3                	mov    %eax,%ebx
  803836:	85 c0                	test   %eax,%eax
  803838:	0f 88 8e 00 00 00    	js     8038cc <pipe+0x143>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80383e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803841:	89 04 24             	mov    %eax,(%esp)
  803844:	e8 07 e8 ff ff       	call   802050 <fd2data>
  803849:	c7 44 24 10 07 04 00 	movl   $0x407,0x10(%esp)
  803850:	00 
  803851:	89 44 24 0c          	mov    %eax,0xc(%esp)
  803855:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  80385c:	00 
  80385d:	89 74 24 04          	mov    %esi,0x4(%esp)
  803861:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  803868:	e8 90 e2 ff ff       	call   801afd <sys_page_map>
  80386d:	89 c3                	mov    %eax,%ebx
  80386f:	85 c0                	test   %eax,%eax
  803871:	78 49                	js     8038bc <pipe+0x133>
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  803873:	b8 58 80 80 00       	mov    $0x808058,%eax
  803878:	8b 08                	mov    (%eax),%ecx
  80387a:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80387d:	89 0a                	mov    %ecx,(%edx)
	fd0->fd_omode = O_RDONLY;
  80387f:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803882:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%edx)

	fd1->fd_dev_id = devpipe.dev_id;
  803889:	8b 10                	mov    (%eax),%edx
  80388b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80388e:	89 10                	mov    %edx,(%eax)
	fd1->fd_omode = O_WRONLY;
  803890:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803893:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", env->env_id, vpt[VPN(va)]);

	pfd[0] = fd2num(fd0);
  80389a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80389d:	89 04 24             	mov    %eax,(%esp)
  8038a0:	e8 9b e7 ff ff       	call   802040 <fd2num>
  8038a5:	89 07                	mov    %eax,(%edi)
	pfd[1] = fd2num(fd1);
  8038a7:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8038aa:	89 04 24             	mov    %eax,(%esp)
  8038ad:	e8 8e e7 ff ff       	call   802040 <fd2num>
  8038b2:	89 47 04             	mov    %eax,0x4(%edi)
  8038b5:	bb 00 00 00 00       	mov    $0x0,%ebx
	return 0;
  8038ba:	eb 36                	jmp    8038f2 <pipe+0x169>

    err3:
	sys_page_unmap(0, va);
  8038bc:	89 74 24 04          	mov    %esi,0x4(%esp)
  8038c0:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8038c7:	e8 d3 e1 ff ff       	call   801a9f <sys_page_unmap>
    err2:
	sys_page_unmap(0, fd1);
  8038cc:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8038cf:	89 44 24 04          	mov    %eax,0x4(%esp)
  8038d3:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8038da:	e8 c0 e1 ff ff       	call   801a9f <sys_page_unmap>
    err1:
	sys_page_unmap(0, fd0);
  8038df:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8038e2:	89 44 24 04          	mov    %eax,0x4(%esp)
  8038e6:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8038ed:	e8 ad e1 ff ff       	call   801a9f <sys_page_unmap>
    err:
	return r;
}
  8038f2:	89 d8                	mov    %ebx,%eax
  8038f4:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  8038f7:	8b 75 f8             	mov    -0x8(%ebp),%esi
  8038fa:	8b 7d fc             	mov    -0x4(%ebp),%edi
  8038fd:	89 ec                	mov    %ebp,%esp
  8038ff:	5d                   	pop    %ebp
  803900:	c3                   	ret    
  803901:	00 00                	add    %al,(%eax)
	...

00803904 <wait>:
#include <inc/lib.h>

// Waits until 'envid' exits.
void
wait(envid_t envid)
{
  803904:	55                   	push   %ebp
  803905:	89 e5                	mov    %esp,%ebp
  803907:	56                   	push   %esi
  803908:	53                   	push   %ebx
  803909:	83 ec 10             	sub    $0x10,%esp
  80390c:	8b 45 08             	mov    0x8(%ebp),%eax
	volatile struct Env *e;

	assert(envid != 0);
  80390f:	85 c0                	test   %eax,%eax
  803911:	75 24                	jne    803937 <wait+0x33>
  803913:	c7 44 24 0c c6 46 80 	movl   $0x8046c6,0xc(%esp)
  80391a:	00 
  80391b:	c7 44 24 08 81 3f 80 	movl   $0x803f81,0x8(%esp)
  803922:	00 
  803923:	c7 44 24 04 09 00 00 	movl   $0x9,0x4(%esp)
  80392a:	00 
  80392b:	c7 04 24 d1 46 80 00 	movl   $0x8046d1,(%esp)
  803932:	e8 c1 d1 ff ff       	call   800af8 <_panic>
	e = &envs[ENVX(envid)];
  803937:	89 c3                	mov    %eax,%ebx
  803939:	81 e3 ff 03 00 00    	and    $0x3ff,%ebx
  80393f:	6b db 7c             	imul   $0x7c,%ebx,%ebx
  803942:	81 c3 00 00 c0 ee    	add    $0xeec00000,%ebx
	while (e->env_id == envid && e->env_status != ENV_FREE)
  803948:	8b 73 4c             	mov    0x4c(%ebx),%esi
  80394b:	39 c6                	cmp    %eax,%esi
  80394d:	75 1a                	jne    803969 <wait+0x65>
  80394f:	8b 43 54             	mov    0x54(%ebx),%eax
  803952:	85 c0                	test   %eax,%eax
  803954:	74 13                	je     803969 <wait+0x65>
		sys_yield();
  803956:	e8 5f e2 ff ff       	call   801bba <sys_yield>
{
	volatile struct Env *e;

	assert(envid != 0);
	e = &envs[ENVX(envid)];
	while (e->env_id == envid && e->env_status != ENV_FREE)
  80395b:	8b 43 4c             	mov    0x4c(%ebx),%eax
  80395e:	39 f0                	cmp    %esi,%eax
  803960:	75 07                	jne    803969 <wait+0x65>
  803962:	8b 43 54             	mov    0x54(%ebx),%eax
  803965:	85 c0                	test   %eax,%eax
  803967:	75 ed                	jne    803956 <wait+0x52>
		sys_yield();
}
  803969:	83 c4 10             	add    $0x10,%esp
  80396c:	5b                   	pop    %ebx
  80396d:	5e                   	pop    %esi
  80396e:	5d                   	pop    %ebp
  80396f:	c3                   	ret    

00803970 <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  803970:	55                   	push   %ebp
  803971:	89 e5                	mov    %esp,%ebp
  803973:	83 ec 18             	sub    $0x18,%esp
	int r;

	if (_pgfault_handler == 0) {
  803976:	83 3d a8 84 80 00 00 	cmpl   $0x0,0x8084a8
  80397d:	75 78                	jne    8039f7 <set_pgfault_handler+0x87>
		// First time through!
		// LAB 4: Your code here.
		// panic("set_pgfault_handler not implemented");
		int ret;	
		if ((ret = sys_page_alloc(0, (void*)(UXSTACKTOP - PGSIZE), PTE_U | PTE_P | PTE_W)) < 0)
  80397f:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  803986:	00 
  803987:	c7 44 24 04 00 f0 bf 	movl   $0xeebff000,0x4(%esp)
  80398e:	ee 
  80398f:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  803996:	e8 c0 e1 ff ff       	call   801b5b <sys_page_alloc>
  80399b:	85 c0                	test   %eax,%eax
  80399d:	79 20                	jns    8039bf <set_pgfault_handler+0x4f>
			panic (" error in sys_page_alloc: %e\n", ret);
  80399f:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8039a3:	c7 44 24 08 dc 46 80 	movl   $0x8046dc,0x8(%esp)
  8039aa:	00 
  8039ab:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  8039b2:	00 
  8039b3:	c7 04 24 fa 46 80 00 	movl   $0x8046fa,(%esp)
  8039ba:	e8 39 d1 ff ff       	call   800af8 <_panic>
		if ((ret = sys_env_set_pgfault_upcall(0, _pgfault_upcall)) < 0)
  8039bf:	c7 44 24 04 04 3a 80 	movl   $0x803a04,0x4(%esp)
  8039c6:	00 
  8039c7:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8039ce:	e8 b2 df ff ff       	call   801985 <sys_env_set_pgfault_upcall>
  8039d3:	85 c0                	test   %eax,%eax
  8039d5:	79 20                	jns    8039f7 <set_pgfault_handler+0x87>
			panic (" error in sys_env_set_pgfault_upcall: %e\n", ret);
  8039d7:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8039db:	c7 44 24 08 08 47 80 	movl   $0x804708,0x8(%esp)
  8039e2:	00 
  8039e3:	c7 44 24 04 25 00 00 	movl   $0x25,0x4(%esp)
  8039ea:	00 
  8039eb:	c7 04 24 fa 46 80 00 	movl   $0x8046fa,(%esp)
  8039f2:	e8 01 d1 ff ff       	call   800af8 <_panic>
	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  8039f7:	8b 45 08             	mov    0x8(%ebp),%eax
  8039fa:	a3 a8 84 80 00       	mov    %eax,0x8084a8
	
}
  8039ff:	c9                   	leave  
  803a00:	c3                   	ret    
  803a01:	00 00                	add    %al,(%eax)
	...

00803a04 <_pgfault_upcall>:

.text
.globl _pgfault_upcall
_pgfault_upcall:
	// Call the C page fault handler.
	pushl %esp			// function argument: pointer to UTF
  803a04:	54                   	push   %esp
	movl _pgfault_handler, %eax
  803a05:	a1 a8 84 80 00       	mov    0x8084a8,%eax
	call *%eax
  803a0a:	ff d0                	call   *%eax
	addl $4, %esp			// pop function argument
  803a0c:	83 c4 04             	add    $0x4,%esp
	// may find that you have to rearrange your code in non-obvious
	// ways as registers become unavailable as scratch space.
	//
	// LAB 4: Your code here.
	
	movl %esp, %ecx			// back up esp to ecx
  803a0f:	89 e1                	mov    %esp,%ecx
	movl 0x28(%esp), %ebx		// store trap-time eip into ebx
  803a11:	8b 5c 24 28          	mov    0x28(%esp),%ebx
	movl 0x30(%esp), %edx		// store trap-time esp into edx
  803a15:	8b 54 24 30          	mov    0x30(%esp),%edx
	movl %edx, %esp			// switch to trap-time stack
  803a19:	89 d4                	mov    %edx,%esp
	pushl %ebx			// push trap-time eip here
  803a1b:	53                   	push   %ebx
	movl %ecx, %esp			// come back to user exception stack
  803a1c:	89 cc                	mov    %ecx,%esp
	
	// for the push made above, update the trap-time esp value in this user exception stack
	// this enables popl %esp to cause esp point to the adjusted trap-time stack 
	subl $0x4, %edx			
  803a1e:	83 ea 04             	sub    $0x4,%edx
	movl %edx, 0x30(%esp)
  803a21:	89 54 24 30          	mov    %edx,0x30(%esp)
	

	// Restore the trap-time registers.  After you do this, you
	// can no longer modify any general-purpose registers.
	// LAB 4: Your code here.
	addl $0x8, %esp
  803a25:	83 c4 08             	add    $0x8,%esp
	popal
  803a28:	61                   	popa   
	// Restore eflags from the stack.  After you do this, you can
	// no longer use arithmetic operations or anything else that
	// modifies eflags.
	// LAB 4: Your code here.
	
	addl $0x4, %esp
  803a29:	83 c4 04             	add    $0x4,%esp
	popfl
  803a2c:	9d                   	popf   

	// Switch back to the adjusted trap-time stack.
	// LAB 4: Your code here.

	popl %esp
  803a2d:	5c                   	pop    %esp

	// Return to re-execute the instruction that faulted.
	// LAB 4: Your code here.
	
	ret
  803a2e:	c3                   	ret    
	...

00803a30 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  803a30:	55                   	push   %ebp
  803a31:	89 e5                	mov    %esp,%ebp
  803a33:	57                   	push   %edi
  803a34:	56                   	push   %esi
  803a35:	53                   	push   %ebx
  803a36:	83 ec 1c             	sub    $0x1c,%esp
  803a39:	8b 7d 0c             	mov    0xc(%ebp),%edi
  803a3c:	8b 5d 10             	mov    0x10(%ebp),%ebx
  803a3f:	8b 75 14             	mov    0x14(%ebp),%esi
	// LAB 4: Your code here.
	int r;
	if (pg == NULL)
  803a42:	85 db                	test   %ebx,%ebx
  803a44:	75 2d                	jne    803a73 <ipc_send+0x43>
  803a46:	bb 00 00 c0 ee       	mov    $0xeec00000,%ebx
  803a4b:	eb 26                	jmp    803a73 <ipc_send+0x43>
		pg = (void*)UTOP;
	while ((r = sys_ipc_try_send(to_env, val, pg, perm)) < 0)
	{
		if(r != -E_IPC_NOT_RECV)
  803a4d:	83 f8 f9             	cmp    $0xfffffff9,%eax
  803a50:	74 1c                	je     803a6e <ipc_send+0x3e>
			panic("Panic in lib ipc.c : ipc_send() \n");
  803a52:	c7 44 24 08 34 47 80 	movl   $0x804734,0x8(%esp)
  803a59:	00 
  803a5a:	c7 44 24 04 44 00 00 	movl   $0x44,0x4(%esp)
  803a61:	00 
  803a62:	c7 04 24 58 47 80 00 	movl   $0x804758,(%esp)
  803a69:	e8 8a d0 ff ff       	call   800af8 <_panic>
		sys_yield();
  803a6e:	e8 47 e1 ff ff       	call   801bba <sys_yield>
{
	// LAB 4: Your code here.
	int r;
	if (pg == NULL)
		pg = (void*)UTOP;
	while ((r = sys_ipc_try_send(to_env, val, pg, perm)) < 0)
  803a73:	89 74 24 0c          	mov    %esi,0xc(%esp)
  803a77:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  803a7b:	89 7c 24 04          	mov    %edi,0x4(%esp)
  803a7f:	8b 45 08             	mov    0x8(%ebp),%eax
  803a82:	89 04 24             	mov    %eax,(%esp)
  803a85:	e8 c3 de ff ff       	call   80194d <sys_ipc_try_send>
  803a8a:	85 c0                	test   %eax,%eax
  803a8c:	78 bf                	js     803a4d <ipc_send+0x1d>
		if(r != -E_IPC_NOT_RECV)
			panic("Panic in lib ipc.c : ipc_send() \n");
		sys_yield();
	}
	//panic("ipc_send not implemented");
}
  803a8e:	83 c4 1c             	add    $0x1c,%esp
  803a91:	5b                   	pop    %ebx
  803a92:	5e                   	pop    %esi
  803a93:	5f                   	pop    %edi
  803a94:	5d                   	pop    %ebp
  803a95:	c3                   	ret    

00803a96 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  803a96:	55                   	push   %ebp
  803a97:	89 e5                	mov    %esp,%ebp
  803a99:	56                   	push   %esi
  803a9a:	53                   	push   %ebx
  803a9b:	83 ec 10             	sub    $0x10,%esp
  803a9e:	8b 5d 08             	mov    0x8(%ebp),%ebx
  803aa1:	8b 45 0c             	mov    0xc(%ebp),%eax
  803aa4:	8b 75 10             	mov    0x10(%ebp),%esi
	// LAB 4: Your code here.
	int r;

	if (pg == NULL)
  803aa7:	85 c0                	test   %eax,%eax
  803aa9:	75 05                	jne    803ab0 <ipc_recv+0x1a>
  803aab:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
		pg = (void*)UTOP;
	if ((r = sys_ipc_recv(pg)) < 0)
  803ab0:	89 04 24             	mov    %eax,(%esp)
  803ab3:	e8 38 de ff ff       	call   8018f0 <sys_ipc_recv>
  803ab8:	85 c0                	test   %eax,%eax
  803aba:	79 16                	jns    803ad2 <ipc_recv+0x3c>
	{
		if (from_env_store != NULL)
  803abc:	85 db                	test   %ebx,%ebx
  803abe:	74 06                	je     803ac6 <ipc_recv+0x30>
			*from_env_store = 0;
  803ac0:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
		if(perm_store != NULL)
  803ac6:	85 f6                	test   %esi,%esi
  803ac8:	74 2c                	je     803af6 <ipc_recv+0x60>
			*perm_store = 0;
  803aca:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
  803ad0:	eb 24                	jmp    803af6 <ipc_recv+0x60>
		return r;
	}
	else
	{	
		if (from_env_store != NULL)
  803ad2:	85 db                	test   %ebx,%ebx
  803ad4:	74 0a                	je     803ae0 <ipc_recv+0x4a>
			*from_env_store = env->env_ipc_from;
  803ad6:	a1 a0 84 80 00       	mov    0x8084a0,%eax
  803adb:	8b 40 74             	mov    0x74(%eax),%eax
  803ade:	89 03                	mov    %eax,(%ebx)
		if(perm_store != NULL)
  803ae0:	85 f6                	test   %esi,%esi
  803ae2:	74 0a                	je     803aee <ipc_recv+0x58>
			*perm_store = env->env_ipc_perm;
  803ae4:	a1 a0 84 80 00       	mov    0x8084a0,%eax
  803ae9:	8b 40 78             	mov    0x78(%eax),%eax
  803aec:	89 06                	mov    %eax,(%esi)
		return env->env_ipc_value;
  803aee:	a1 a0 84 80 00       	mov    0x8084a0,%eax
  803af3:	8b 40 70             	mov    0x70(%eax),%eax
	}		
	//panic("ipc_recv not implemented");
	//return 0;
}
  803af6:	83 c4 10             	add    $0x10,%esp
  803af9:	5b                   	pop    %ebx
  803afa:	5e                   	pop    %esi
  803afb:	5d                   	pop    %ebp
  803afc:	c3                   	ret    
  803afd:	00 00                	add    %al,(%eax)
	...

00803b00 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  803b00:	55                   	push   %ebp
  803b01:	89 e5                	mov    %esp,%ebp
	pte_t pte;

	if (!(vpd[PDX(v)] & PTE_P))
  803b03:	8b 45 08             	mov    0x8(%ebp),%eax
  803b06:	89 c2                	mov    %eax,%edx
  803b08:	c1 ea 16             	shr    $0x16,%edx
  803b0b:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  803b12:	f6 c2 01             	test   $0x1,%dl
  803b15:	74 26                	je     803b3d <pageref+0x3d>
		return 0;
	pte = vpt[VPN(v)];
  803b17:	c1 e8 0c             	shr    $0xc,%eax
  803b1a:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
	if (!(pte & PTE_P))
  803b21:	a8 01                	test   $0x1,%al
  803b23:	74 18                	je     803b3d <pageref+0x3d>
		return 0;
	return pages[PPN(pte)].pp_ref;
  803b25:	c1 e8 0c             	shr    $0xc,%eax
  803b28:	8d 14 40             	lea    (%eax,%eax,2),%edx
  803b2b:	c1 e2 02             	shl    $0x2,%edx
  803b2e:	b8 00 00 00 ef       	mov    $0xef000000,%eax
  803b33:	0f b7 44 02 08       	movzwl 0x8(%edx,%eax,1),%eax
  803b38:	0f b7 c0             	movzwl %ax,%eax
  803b3b:	eb 05                	jmp    803b42 <pageref+0x42>
  803b3d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803b42:	5d                   	pop    %ebp
  803b43:	c3                   	ret    
	...

00803b50 <__udivdi3>:
  803b50:	55                   	push   %ebp
  803b51:	89 e5                	mov    %esp,%ebp
  803b53:	57                   	push   %edi
  803b54:	56                   	push   %esi
  803b55:	83 ec 10             	sub    $0x10,%esp
  803b58:	8b 45 14             	mov    0x14(%ebp),%eax
  803b5b:	8b 55 08             	mov    0x8(%ebp),%edx
  803b5e:	8b 75 10             	mov    0x10(%ebp),%esi
  803b61:	8b 7d 0c             	mov    0xc(%ebp),%edi
  803b64:	85 c0                	test   %eax,%eax
  803b66:	89 55 f0             	mov    %edx,-0x10(%ebp)
  803b69:	75 35                	jne    803ba0 <__udivdi3+0x50>
  803b6b:	39 fe                	cmp    %edi,%esi
  803b6d:	77 61                	ja     803bd0 <__udivdi3+0x80>
  803b6f:	85 f6                	test   %esi,%esi
  803b71:	75 0b                	jne    803b7e <__udivdi3+0x2e>
  803b73:	b8 01 00 00 00       	mov    $0x1,%eax
  803b78:	31 d2                	xor    %edx,%edx
  803b7a:	f7 f6                	div    %esi
  803b7c:	89 c6                	mov    %eax,%esi
  803b7e:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  803b81:	31 d2                	xor    %edx,%edx
  803b83:	89 f8                	mov    %edi,%eax
  803b85:	f7 f6                	div    %esi
  803b87:	89 c7                	mov    %eax,%edi
  803b89:	89 c8                	mov    %ecx,%eax
  803b8b:	f7 f6                	div    %esi
  803b8d:	89 c1                	mov    %eax,%ecx
  803b8f:	89 fa                	mov    %edi,%edx
  803b91:	89 c8                	mov    %ecx,%eax
  803b93:	83 c4 10             	add    $0x10,%esp
  803b96:	5e                   	pop    %esi
  803b97:	5f                   	pop    %edi
  803b98:	5d                   	pop    %ebp
  803b99:	c3                   	ret    
  803b9a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  803ba0:	39 f8                	cmp    %edi,%eax
  803ba2:	77 1c                	ja     803bc0 <__udivdi3+0x70>
  803ba4:	0f bd d0             	bsr    %eax,%edx
  803ba7:	83 f2 1f             	xor    $0x1f,%edx
  803baa:	89 55 f4             	mov    %edx,-0xc(%ebp)
  803bad:	75 39                	jne    803be8 <__udivdi3+0x98>
  803baf:	3b 75 f0             	cmp    -0x10(%ebp),%esi
  803bb2:	0f 86 a0 00 00 00    	jbe    803c58 <__udivdi3+0x108>
  803bb8:	39 f8                	cmp    %edi,%eax
  803bba:	0f 82 98 00 00 00    	jb     803c58 <__udivdi3+0x108>
  803bc0:	31 ff                	xor    %edi,%edi
  803bc2:	31 c9                	xor    %ecx,%ecx
  803bc4:	89 c8                	mov    %ecx,%eax
  803bc6:	89 fa                	mov    %edi,%edx
  803bc8:	83 c4 10             	add    $0x10,%esp
  803bcb:	5e                   	pop    %esi
  803bcc:	5f                   	pop    %edi
  803bcd:	5d                   	pop    %ebp
  803bce:	c3                   	ret    
  803bcf:	90                   	nop
  803bd0:	89 d1                	mov    %edx,%ecx
  803bd2:	89 fa                	mov    %edi,%edx
  803bd4:	89 c8                	mov    %ecx,%eax
  803bd6:	31 ff                	xor    %edi,%edi
  803bd8:	f7 f6                	div    %esi
  803bda:	89 c1                	mov    %eax,%ecx
  803bdc:	89 fa                	mov    %edi,%edx
  803bde:	89 c8                	mov    %ecx,%eax
  803be0:	83 c4 10             	add    $0x10,%esp
  803be3:	5e                   	pop    %esi
  803be4:	5f                   	pop    %edi
  803be5:	5d                   	pop    %ebp
  803be6:	c3                   	ret    
  803be7:	90                   	nop
  803be8:	0f b6 4d f4          	movzbl -0xc(%ebp),%ecx
  803bec:	89 f2                	mov    %esi,%edx
  803bee:	d3 e0                	shl    %cl,%eax
  803bf0:	89 45 ec             	mov    %eax,-0x14(%ebp)
  803bf3:	b8 20 00 00 00       	mov    $0x20,%eax
  803bf8:	2b 45 f4             	sub    -0xc(%ebp),%eax
  803bfb:	89 c1                	mov    %eax,%ecx
  803bfd:	d3 ea                	shr    %cl,%edx
  803bff:	0f b6 4d f4          	movzbl -0xc(%ebp),%ecx
  803c03:	0b 55 ec             	or     -0x14(%ebp),%edx
  803c06:	d3 e6                	shl    %cl,%esi
  803c08:	89 c1                	mov    %eax,%ecx
  803c0a:	89 75 e8             	mov    %esi,-0x18(%ebp)
  803c0d:	89 fe                	mov    %edi,%esi
  803c0f:	d3 ee                	shr    %cl,%esi
  803c11:	0f b6 4d f4          	movzbl -0xc(%ebp),%ecx
  803c15:	89 55 ec             	mov    %edx,-0x14(%ebp)
  803c18:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803c1b:	d3 e7                	shl    %cl,%edi
  803c1d:	89 c1                	mov    %eax,%ecx
  803c1f:	d3 ea                	shr    %cl,%edx
  803c21:	09 d7                	or     %edx,%edi
  803c23:	89 f2                	mov    %esi,%edx
  803c25:	89 f8                	mov    %edi,%eax
  803c27:	f7 75 ec             	divl   -0x14(%ebp)
  803c2a:	89 d6                	mov    %edx,%esi
  803c2c:	89 c7                	mov    %eax,%edi
  803c2e:	f7 65 e8             	mull   -0x18(%ebp)
  803c31:	39 d6                	cmp    %edx,%esi
  803c33:	89 55 ec             	mov    %edx,-0x14(%ebp)
  803c36:	72 30                	jb     803c68 <__udivdi3+0x118>
  803c38:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803c3b:	0f b6 4d f4          	movzbl -0xc(%ebp),%ecx
  803c3f:	d3 e2                	shl    %cl,%edx
  803c41:	39 c2                	cmp    %eax,%edx
  803c43:	73 05                	jae    803c4a <__udivdi3+0xfa>
  803c45:	3b 75 ec             	cmp    -0x14(%ebp),%esi
  803c48:	74 1e                	je     803c68 <__udivdi3+0x118>
  803c4a:	89 f9                	mov    %edi,%ecx
  803c4c:	31 ff                	xor    %edi,%edi
  803c4e:	e9 71 ff ff ff       	jmp    803bc4 <__udivdi3+0x74>
  803c53:	90                   	nop
  803c54:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  803c58:	31 ff                	xor    %edi,%edi
  803c5a:	b9 01 00 00 00       	mov    $0x1,%ecx
  803c5f:	e9 60 ff ff ff       	jmp    803bc4 <__udivdi3+0x74>
  803c64:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  803c68:	8d 4f ff             	lea    -0x1(%edi),%ecx
  803c6b:	31 ff                	xor    %edi,%edi
  803c6d:	89 c8                	mov    %ecx,%eax
  803c6f:	89 fa                	mov    %edi,%edx
  803c71:	83 c4 10             	add    $0x10,%esp
  803c74:	5e                   	pop    %esi
  803c75:	5f                   	pop    %edi
  803c76:	5d                   	pop    %ebp
  803c77:	c3                   	ret    
	...

00803c80 <__umoddi3>:
  803c80:	55                   	push   %ebp
  803c81:	89 e5                	mov    %esp,%ebp
  803c83:	57                   	push   %edi
  803c84:	56                   	push   %esi
  803c85:	83 ec 20             	sub    $0x20,%esp
  803c88:	8b 55 14             	mov    0x14(%ebp),%edx
  803c8b:	8b 4d 08             	mov    0x8(%ebp),%ecx
  803c8e:	8b 7d 10             	mov    0x10(%ebp),%edi
  803c91:	8b 75 0c             	mov    0xc(%ebp),%esi
  803c94:	85 d2                	test   %edx,%edx
  803c96:	89 c8                	mov    %ecx,%eax
  803c98:	89 4d f4             	mov    %ecx,-0xc(%ebp)
  803c9b:	75 13                	jne    803cb0 <__umoddi3+0x30>
  803c9d:	39 f7                	cmp    %esi,%edi
  803c9f:	76 3f                	jbe    803ce0 <__umoddi3+0x60>
  803ca1:	89 f2                	mov    %esi,%edx
  803ca3:	f7 f7                	div    %edi
  803ca5:	89 d0                	mov    %edx,%eax
  803ca7:	31 d2                	xor    %edx,%edx
  803ca9:	83 c4 20             	add    $0x20,%esp
  803cac:	5e                   	pop    %esi
  803cad:	5f                   	pop    %edi
  803cae:	5d                   	pop    %ebp
  803caf:	c3                   	ret    
  803cb0:	39 f2                	cmp    %esi,%edx
  803cb2:	77 4c                	ja     803d00 <__umoddi3+0x80>
  803cb4:	0f bd ca             	bsr    %edx,%ecx
  803cb7:	83 f1 1f             	xor    $0x1f,%ecx
  803cba:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  803cbd:	75 51                	jne    803d10 <__umoddi3+0x90>
  803cbf:	3b 7d f4             	cmp    -0xc(%ebp),%edi
  803cc2:	0f 87 e0 00 00 00    	ja     803da8 <__umoddi3+0x128>
  803cc8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803ccb:	29 f8                	sub    %edi,%eax
  803ccd:	19 d6                	sbb    %edx,%esi
  803ccf:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803cd2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803cd5:	89 f2                	mov    %esi,%edx
  803cd7:	83 c4 20             	add    $0x20,%esp
  803cda:	5e                   	pop    %esi
  803cdb:	5f                   	pop    %edi
  803cdc:	5d                   	pop    %ebp
  803cdd:	c3                   	ret    
  803cde:	66 90                	xchg   %ax,%ax
  803ce0:	85 ff                	test   %edi,%edi
  803ce2:	75 0b                	jne    803cef <__umoddi3+0x6f>
  803ce4:	b8 01 00 00 00       	mov    $0x1,%eax
  803ce9:	31 d2                	xor    %edx,%edx
  803ceb:	f7 f7                	div    %edi
  803ced:	89 c7                	mov    %eax,%edi
  803cef:	89 f0                	mov    %esi,%eax
  803cf1:	31 d2                	xor    %edx,%edx
  803cf3:	f7 f7                	div    %edi
  803cf5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803cf8:	f7 f7                	div    %edi
  803cfa:	eb a9                	jmp    803ca5 <__umoddi3+0x25>
  803cfc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  803d00:	89 c8                	mov    %ecx,%eax
  803d02:	89 f2                	mov    %esi,%edx
  803d04:	83 c4 20             	add    $0x20,%esp
  803d07:	5e                   	pop    %esi
  803d08:	5f                   	pop    %edi
  803d09:	5d                   	pop    %ebp
  803d0a:	c3                   	ret    
  803d0b:	90                   	nop
  803d0c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  803d10:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
  803d14:	d3 e2                	shl    %cl,%edx
  803d16:	89 55 f4             	mov    %edx,-0xc(%ebp)
  803d19:	ba 20 00 00 00       	mov    $0x20,%edx
  803d1e:	2b 55 f0             	sub    -0x10(%ebp),%edx
  803d21:	89 55 ec             	mov    %edx,-0x14(%ebp)
  803d24:	0f b6 4d ec          	movzbl -0x14(%ebp),%ecx
  803d28:	89 fa                	mov    %edi,%edx
  803d2a:	d3 ea                	shr    %cl,%edx
  803d2c:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
  803d30:	0b 55 f4             	or     -0xc(%ebp),%edx
  803d33:	d3 e7                	shl    %cl,%edi
  803d35:	0f b6 4d ec          	movzbl -0x14(%ebp),%ecx
  803d39:	89 55 f4             	mov    %edx,-0xc(%ebp)
  803d3c:	89 f2                	mov    %esi,%edx
  803d3e:	89 7d e8             	mov    %edi,-0x18(%ebp)
  803d41:	89 c7                	mov    %eax,%edi
  803d43:	d3 ea                	shr    %cl,%edx
  803d45:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
  803d49:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  803d4c:	89 c2                	mov    %eax,%edx
  803d4e:	d3 e6                	shl    %cl,%esi
  803d50:	0f b6 4d ec          	movzbl -0x14(%ebp),%ecx
  803d54:	d3 ea                	shr    %cl,%edx
  803d56:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
  803d5a:	09 d6                	or     %edx,%esi
  803d5c:	89 f0                	mov    %esi,%eax
  803d5e:	8b 75 e4             	mov    -0x1c(%ebp),%esi
  803d61:	d3 e7                	shl    %cl,%edi
  803d63:	89 f2                	mov    %esi,%edx
  803d65:	f7 75 f4             	divl   -0xc(%ebp)
  803d68:	89 d6                	mov    %edx,%esi
  803d6a:	f7 65 e8             	mull   -0x18(%ebp)
  803d6d:	39 d6                	cmp    %edx,%esi
  803d6f:	72 2b                	jb     803d9c <__umoddi3+0x11c>
  803d71:	39 c7                	cmp    %eax,%edi
  803d73:	72 23                	jb     803d98 <__umoddi3+0x118>
  803d75:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
  803d79:	29 c7                	sub    %eax,%edi
  803d7b:	19 d6                	sbb    %edx,%esi
  803d7d:	89 f0                	mov    %esi,%eax
  803d7f:	89 f2                	mov    %esi,%edx
  803d81:	d3 ef                	shr    %cl,%edi
  803d83:	0f b6 4d ec          	movzbl -0x14(%ebp),%ecx
  803d87:	d3 e0                	shl    %cl,%eax
  803d89:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
  803d8d:	09 f8                	or     %edi,%eax
  803d8f:	d3 ea                	shr    %cl,%edx
  803d91:	83 c4 20             	add    $0x20,%esp
  803d94:	5e                   	pop    %esi
  803d95:	5f                   	pop    %edi
  803d96:	5d                   	pop    %ebp
  803d97:	c3                   	ret    
  803d98:	39 d6                	cmp    %edx,%esi
  803d9a:	75 d9                	jne    803d75 <__umoddi3+0xf5>
  803d9c:	2b 45 e8             	sub    -0x18(%ebp),%eax
  803d9f:	1b 55 f4             	sbb    -0xc(%ebp),%edx
  803da2:	eb d1                	jmp    803d75 <__umoddi3+0xf5>
  803da4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  803da8:	39 f2                	cmp    %esi,%edx
  803daa:	0f 82 18 ff ff ff    	jb     803cc8 <__umoddi3+0x48>
  803db0:	e9 1d ff ff ff       	jmp    803cd2 <__umoddi3+0x52>
