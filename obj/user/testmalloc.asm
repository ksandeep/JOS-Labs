
obj/user/testmalloc:     file format elf32-i386


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
  80002c:	e8 d7 00 00 00       	call   800108 <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>
	...

00800040 <umain>:
#include <inc/lib.h>

void
umain(int argc, char **argv)
{
  800040:	55                   	push   %ebp
  800041:	89 e5                	mov    %esp,%ebp
  800043:	53                   	push   %ebx
  800044:	83 ec 14             	sub    $0x14,%esp
	char *buf;
	int n;
	void *v;

	while (1) {
		buf = readline("> ");
  800047:	c7 04 24 80 2d 80 00 	movl   $0x802d80,(%esp)
  80004e:	e8 2d 01 00 00       	call   800180 <readline>
  800053:	89 c3                	mov    %eax,%ebx
		if (buf == 0)
  800055:	85 c0                	test   %eax,%eax
  800057:	75 05                	jne    80005e <umain+0x1e>
			exit();
  800059:	e8 fa 00 00 00       	call   800158 <exit>
		if (memcmp(buf, "free ", 5) == 0) {
  80005e:	c7 44 24 08 05 00 00 	movl   $0x5,0x8(%esp)
  800065:	00 
  800066:	c7 44 24 04 83 2d 80 	movl   $0x802d83,0x4(%esp)
  80006d:	00 
  80006e:	89 1c 24             	mov    %ebx,(%esp)
  800071:	e8 9c 04 00 00       	call   800512 <memcmp>
  800076:	85 c0                	test   %eax,%eax
  800078:	75 25                	jne    80009f <umain+0x5f>
			v = (void*) strtol(buf + 5, 0, 0);
  80007a:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  800081:	00 
  800082:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  800089:	00 
  80008a:	83 c3 05             	add    $0x5,%ebx
  80008d:	89 1c 24             	mov    %ebx,(%esp)
  800090:	e8 f6 04 00 00       	call   80058b <strtol>
			free(v);
  800095:	89 04 24             	mov    %eax,(%esp)
  800098:	e8 e3 19 00 00       	call   801a80 <free>
  80009d:	eb a8                	jmp    800047 <umain+0x7>
		} else if (memcmp(buf, "malloc ", 7) == 0) {
  80009f:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  8000a6:	00 
  8000a7:	c7 44 24 04 89 2d 80 	movl   $0x802d89,0x4(%esp)
  8000ae:	00 
  8000af:	89 1c 24             	mov    %ebx,(%esp)
  8000b2:	e8 5b 04 00 00       	call   800512 <memcmp>
  8000b7:	85 c0                	test   %eax,%eax
  8000b9:	75 38                	jne    8000f3 <umain+0xb3>
			n = strtol(buf + 7, 0, 0);
  8000bb:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  8000c2:	00 
  8000c3:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  8000ca:	00 
  8000cb:	83 c3 07             	add    $0x7,%ebx
  8000ce:	89 1c 24             	mov    %ebx,(%esp)
  8000d1:	e8 b5 04 00 00       	call   80058b <strtol>
			v = malloc(n);
  8000d6:	89 04 24             	mov    %eax,(%esp)
  8000d9:	e8 75 1a 00 00       	call   801b53 <malloc>
			printf("\t0x%x\n", (uintptr_t) v);
  8000de:	89 44 24 04          	mov    %eax,0x4(%esp)
  8000e2:	c7 04 24 91 2d 80 00 	movl   $0x802d91,(%esp)
  8000e9:	e8 35 14 00 00       	call   801523 <printf>
  8000ee:	e9 54 ff ff ff       	jmp    800047 <umain+0x7>
		} else
			printf("?unknown command\n");
  8000f3:	c7 04 24 98 2d 80 00 	movl   $0x802d98,(%esp)
  8000fa:	e8 24 14 00 00       	call   801523 <printf>
  8000ff:	90                   	nop
  800100:	e9 42 ff ff ff       	jmp    800047 <umain+0x7>
  800105:	00 00                	add    %al,(%eax)
	...

00800108 <libmain>:
volatile struct Env *env;
char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  800108:	55                   	push   %ebp
  800109:	89 e5                	mov    %esp,%ebp
  80010b:	83 ec 18             	sub    $0x18,%esp
  80010e:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  800111:	89 75 fc             	mov    %esi,-0x4(%ebp)
  800114:	8b 75 08             	mov    0x8(%ebp),%esi
  800117:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	// set env to point at our env structure in envs[].
	// LAB 3b: Your code here.
	// Code added by Swastika / Sandeep	
	envid_t envid = sys_getenvid();
  80011a:	e8 1f 0a 00 00       	call   800b3e <sys_getenvid>
	env = &envs[ENVX(envid)];
  80011f:	25 ff 03 00 00       	and    $0x3ff,%eax
  800124:	6b c0 7c             	imul   $0x7c,%eax,%eax
  800127:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  80012c:	a3 84 74 80 00       	mov    %eax,0x807484

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800131:	85 f6                	test   %esi,%esi
  800133:	7e 07                	jle    80013c <libmain+0x34>
		binaryname = argv[0];
  800135:	8b 03                	mov    (%ebx),%eax
  800137:	a3 00 70 80 00       	mov    %eax,0x807000

	// call user main routine
	umain(argc, argv);
  80013c:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  800140:	89 34 24             	mov    %esi,(%esp)
  800143:	e8 f8 fe ff ff       	call   800040 <umain>

	// exit gracefully
	exit();
  800148:	e8 0b 00 00 00       	call   800158 <exit>
}
  80014d:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  800150:	8b 75 fc             	mov    -0x4(%ebp),%esi
  800153:	89 ec                	mov    %ebp,%esp
  800155:	5d                   	pop    %ebp
  800156:	c3                   	ret    
	...

00800158 <exit>:
#include <inc/lib.h>

void
exit(void)
{
  800158:	55                   	push   %ebp
  800159:	89 e5                	mov    %esp,%ebp
  80015b:	83 ec 18             	sub    $0x18,%esp
	close_all();
  80015e:	e8 48 0f 00 00       	call   8010ab <close_all>
	sys_env_destroy(0);
  800163:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80016a:	e8 03 0a 00 00       	call   800b72 <sys_env_destroy>
}
  80016f:	c9                   	leave  
  800170:	c3                   	ret    
	...

00800180 <readline>:
#define BUFLEN 1024
static char buf[BUFLEN];

char *
readline(const char *prompt)
{
  800180:	55                   	push   %ebp
  800181:	89 e5                	mov    %esp,%ebp
  800183:	57                   	push   %edi
  800184:	56                   	push   %esi
  800185:	53                   	push   %ebx
  800186:	83 ec 1c             	sub    $0x1c,%esp
  800189:	8b 45 08             	mov    0x8(%ebp),%eax

#if JOS_KERNEL
	if (prompt != NULL)
		cprintf("%s", prompt);
#else
	if (prompt != NULL)
  80018c:	85 c0                	test   %eax,%eax
  80018e:	74 18                	je     8001a8 <readline+0x28>
		fprintf(1, "%s", prompt);
  800190:	89 44 24 08          	mov    %eax,0x8(%esp)
  800194:	c7 44 24 04 b6 2e 80 	movl   $0x802eb6,0x4(%esp)
  80019b:	00 
  80019c:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  8001a3:	e8 9d 13 00 00       	call   801545 <fprintf>
#endif

	i = 0;
	echoing = iscons(0);
  8001a8:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8001af:	e8 a2 20 00 00       	call   802256 <iscons>
  8001b4:	89 c7                	mov    %eax,%edi
  8001b6:	be 00 00 00 00       	mov    $0x0,%esi
	while (1) {
		c = getchar();
  8001bb:	e8 c5 20 00 00       	call   802285 <getchar>
  8001c0:	89 c3                	mov    %eax,%ebx
		if (c < 0) {
  8001c2:	85 c0                	test   %eax,%eax
  8001c4:	79 25                	jns    8001eb <readline+0x6b>
			if (c != -E_EOF)
  8001c6:	b8 00 00 00 00       	mov    $0x0,%eax
  8001cb:	83 fb f8             	cmp    $0xfffffff8,%ebx
  8001ce:	0f 84 8f 00 00 00    	je     800263 <readline+0xe3>
				cprintf("read error: %e\n", c);
  8001d4:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8001d8:	c7 04 24 c1 2d 80 00 	movl   $0x802dc1,(%esp)
  8001df:	e8 9d 21 00 00       	call   802381 <cprintf>
  8001e4:	b8 00 00 00 00       	mov    $0x0,%eax
  8001e9:	eb 78                	jmp    800263 <readline+0xe3>
			return NULL;
		} else if ((c == '\b' || c == '\x7f') && i > 0) {
  8001eb:	83 f8 08             	cmp    $0x8,%eax
  8001ee:	74 05                	je     8001f5 <readline+0x75>
  8001f0:	83 f8 7f             	cmp    $0x7f,%eax
  8001f3:	75 1e                	jne    800213 <readline+0x93>
  8001f5:	85 f6                	test   %esi,%esi
  8001f7:	7e 1a                	jle    800213 <readline+0x93>
			if (echoing)
  8001f9:	85 ff                	test   %edi,%edi
  8001fb:	90                   	nop
  8001fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  800200:	74 0c                	je     80020e <readline+0x8e>
				cputchar('\b');
  800202:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
  800209:	e8 94 1f 00 00       	call   8021a2 <cputchar>
			i--;
  80020e:	83 ee 01             	sub    $0x1,%esi
		c = getchar();
		if (c < 0) {
			if (c != -E_EOF)
				cprintf("read error: %e\n", c);
			return NULL;
		} else if ((c == '\b' || c == '\x7f') && i > 0) {
  800211:	eb a8                	jmp    8001bb <readline+0x3b>
			if (echoing)
				cputchar('\b');
			i--;
		} else if (c >= ' ' && i < BUFLEN-1) {
  800213:	83 fb 1f             	cmp    $0x1f,%ebx
  800216:	7e 21                	jle    800239 <readline+0xb9>
  800218:	81 fe fe 03 00 00    	cmp    $0x3fe,%esi
  80021e:	66 90                	xchg   %ax,%ax
  800220:	7f 17                	jg     800239 <readline+0xb9>
			if (echoing)
  800222:	85 ff                	test   %edi,%edi
  800224:	74 08                	je     80022e <readline+0xae>
				cputchar(c);
  800226:	89 1c 24             	mov    %ebx,(%esp)
  800229:	e8 74 1f 00 00       	call   8021a2 <cputchar>
			buf[i++] = c;
  80022e:	88 9e 80 70 80 00    	mov    %bl,0x807080(%esi)
  800234:	83 c6 01             	add    $0x1,%esi
  800237:	eb 82                	jmp    8001bb <readline+0x3b>
		} else if (c == '\n' || c == '\r') {
  800239:	83 fb 0a             	cmp    $0xa,%ebx
  80023c:	74 09                	je     800247 <readline+0xc7>
  80023e:	83 fb 0d             	cmp    $0xd,%ebx
  800241:	0f 85 74 ff ff ff    	jne    8001bb <readline+0x3b>
			if (echoing)
  800247:	85 ff                	test   %edi,%edi
  800249:	74 0c                	je     800257 <readline+0xd7>
				cputchar('\n');
  80024b:	c7 04 24 0a 00 00 00 	movl   $0xa,(%esp)
  800252:	e8 4b 1f 00 00       	call   8021a2 <cputchar>
			buf[i] = 0;
  800257:	c6 86 80 70 80 00 00 	movb   $0x0,0x807080(%esi)
  80025e:	b8 80 70 80 00       	mov    $0x807080,%eax
			return buf;
		}
	}
}
  800263:	83 c4 1c             	add    $0x1c,%esp
  800266:	5b                   	pop    %ebx
  800267:	5e                   	pop    %esi
  800268:	5f                   	pop    %edi
  800269:	5d                   	pop    %ebp
  80026a:	c3                   	ret    
  80026b:	00 00                	add    %al,(%eax)
  80026d:	00 00                	add    %al,(%eax)
	...

00800270 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800270:	55                   	push   %ebp
  800271:	89 e5                	mov    %esp,%ebp
  800273:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  800276:	b8 00 00 00 00       	mov    $0x0,%eax
  80027b:	80 3a 00             	cmpb   $0x0,(%edx)
  80027e:	74 09                	je     800289 <strlen+0x19>
		n++;
  800280:	83 c0 01             	add    $0x1,%eax
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800283:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  800287:	75 f7                	jne    800280 <strlen+0x10>
		n++;
	return n;
}
  800289:	5d                   	pop    %ebp
  80028a:	c3                   	ret    

0080028b <strnlen>:

int
strnlen(const char *s, size_t size)
{
  80028b:	55                   	push   %ebp
  80028c:	89 e5                	mov    %esp,%ebp
  80028e:	53                   	push   %ebx
  80028f:	8b 5d 08             	mov    0x8(%ebp),%ebx
  800292:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800295:	85 c9                	test   %ecx,%ecx
  800297:	74 19                	je     8002b2 <strnlen+0x27>
  800299:	80 3b 00             	cmpb   $0x0,(%ebx)
  80029c:	74 14                	je     8002b2 <strnlen+0x27>
  80029e:	b8 00 00 00 00       	mov    $0x0,%eax
		n++;
  8002a3:	83 c0 01             	add    $0x1,%eax
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8002a6:	39 c8                	cmp    %ecx,%eax
  8002a8:	74 0d                	je     8002b7 <strnlen+0x2c>
  8002aa:	80 3c 03 00          	cmpb   $0x0,(%ebx,%eax,1)
  8002ae:	75 f3                	jne    8002a3 <strnlen+0x18>
  8002b0:	eb 05                	jmp    8002b7 <strnlen+0x2c>
  8002b2:	b8 00 00 00 00       	mov    $0x0,%eax
		n++;
	return n;
}
  8002b7:	5b                   	pop    %ebx
  8002b8:	5d                   	pop    %ebp
  8002b9:	c3                   	ret    

008002ba <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  8002ba:	55                   	push   %ebp
  8002bb:	89 e5                	mov    %esp,%ebp
  8002bd:	53                   	push   %ebx
  8002be:	8b 45 08             	mov    0x8(%ebp),%eax
  8002c1:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  8002c4:	ba 00 00 00 00       	mov    $0x0,%edx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  8002c9:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
  8002cd:	88 0c 10             	mov    %cl,(%eax,%edx,1)
  8002d0:	83 c2 01             	add    $0x1,%edx
  8002d3:	84 c9                	test   %cl,%cl
  8002d5:	75 f2                	jne    8002c9 <strcpy+0xf>
		/* do nothing */;
	return ret;
}
  8002d7:	5b                   	pop    %ebx
  8002d8:	5d                   	pop    %ebp
  8002d9:	c3                   	ret    

008002da <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  8002da:	55                   	push   %ebp
  8002db:	89 e5                	mov    %esp,%ebp
  8002dd:	56                   	push   %esi
  8002de:	53                   	push   %ebx
  8002df:	8b 45 08             	mov    0x8(%ebp),%eax
  8002e2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8002e5:	8b 75 10             	mov    0x10(%ebp),%esi
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  8002e8:	85 f6                	test   %esi,%esi
  8002ea:	74 18                	je     800304 <strncpy+0x2a>
  8002ec:	b9 00 00 00 00       	mov    $0x0,%ecx
		*dst++ = *src;
  8002f1:	0f b6 1a             	movzbl (%edx),%ebx
  8002f4:	88 1c 08             	mov    %bl,(%eax,%ecx,1)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  8002f7:	80 3a 01             	cmpb   $0x1,(%edx)
  8002fa:	83 da ff             	sbb    $0xffffffff,%edx
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  8002fd:	83 c1 01             	add    $0x1,%ecx
  800300:	39 ce                	cmp    %ecx,%esi
  800302:	77 ed                	ja     8002f1 <strncpy+0x17>
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
}
  800304:	5b                   	pop    %ebx
  800305:	5e                   	pop    %esi
  800306:	5d                   	pop    %ebp
  800307:	c3                   	ret    

00800308 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800308:	55                   	push   %ebp
  800309:	89 e5                	mov    %esp,%ebp
  80030b:	56                   	push   %esi
  80030c:	53                   	push   %ebx
  80030d:	8b 75 08             	mov    0x8(%ebp),%esi
  800310:	8b 55 0c             	mov    0xc(%ebp),%edx
  800313:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  800316:	89 f0                	mov    %esi,%eax
  800318:	85 c9                	test   %ecx,%ecx
  80031a:	74 27                	je     800343 <strlcpy+0x3b>
		while (--size > 0 && *src != '\0')
  80031c:	83 e9 01             	sub    $0x1,%ecx
  80031f:	74 1d                	je     80033e <strlcpy+0x36>
  800321:	0f b6 1a             	movzbl (%edx),%ebx
  800324:	84 db                	test   %bl,%bl
  800326:	74 16                	je     80033e <strlcpy+0x36>
			*dst++ = *src++;
  800328:	88 18                	mov    %bl,(%eax)
  80032a:	83 c0 01             	add    $0x1,%eax
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  80032d:	83 e9 01             	sub    $0x1,%ecx
  800330:	74 0e                	je     800340 <strlcpy+0x38>
			*dst++ = *src++;
  800332:	83 c2 01             	add    $0x1,%edx
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800335:	0f b6 1a             	movzbl (%edx),%ebx
  800338:	84 db                	test   %bl,%bl
  80033a:	75 ec                	jne    800328 <strlcpy+0x20>
  80033c:	eb 02                	jmp    800340 <strlcpy+0x38>
  80033e:	89 f0                	mov    %esi,%eax
			*dst++ = *src++;
		*dst = '\0';
  800340:	c6 00 00             	movb   $0x0,(%eax)
  800343:	29 f0                	sub    %esi,%eax
	}
	return dst - dst_in;
}
  800345:	5b                   	pop    %ebx
  800346:	5e                   	pop    %esi
  800347:	5d                   	pop    %ebp
  800348:	c3                   	ret    

00800349 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800349:	55                   	push   %ebp
  80034a:	89 e5                	mov    %esp,%ebp
  80034c:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80034f:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  800352:	0f b6 01             	movzbl (%ecx),%eax
  800355:	84 c0                	test   %al,%al
  800357:	74 15                	je     80036e <strcmp+0x25>
  800359:	3a 02                	cmp    (%edx),%al
  80035b:	75 11                	jne    80036e <strcmp+0x25>
		p++, q++;
  80035d:	83 c1 01             	add    $0x1,%ecx
  800360:	83 c2 01             	add    $0x1,%edx
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800363:	0f b6 01             	movzbl (%ecx),%eax
  800366:	84 c0                	test   %al,%al
  800368:	74 04                	je     80036e <strcmp+0x25>
  80036a:	3a 02                	cmp    (%edx),%al
  80036c:	74 ef                	je     80035d <strcmp+0x14>
  80036e:	0f b6 c0             	movzbl %al,%eax
  800371:	0f b6 12             	movzbl (%edx),%edx
  800374:	29 d0                	sub    %edx,%eax
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
}
  800376:	5d                   	pop    %ebp
  800377:	c3                   	ret    

00800378 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800378:	55                   	push   %ebp
  800379:	89 e5                	mov    %esp,%ebp
  80037b:	53                   	push   %ebx
  80037c:	8b 55 08             	mov    0x8(%ebp),%edx
  80037f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800382:	8b 45 10             	mov    0x10(%ebp),%eax
	while (n > 0 && *p && *p == *q)
  800385:	85 c0                	test   %eax,%eax
  800387:	74 23                	je     8003ac <strncmp+0x34>
  800389:	0f b6 1a             	movzbl (%edx),%ebx
  80038c:	84 db                	test   %bl,%bl
  80038e:	74 24                	je     8003b4 <strncmp+0x3c>
  800390:	3a 19                	cmp    (%ecx),%bl
  800392:	75 20                	jne    8003b4 <strncmp+0x3c>
  800394:	83 e8 01             	sub    $0x1,%eax
  800397:	74 13                	je     8003ac <strncmp+0x34>
		n--, p++, q++;
  800399:	83 c2 01             	add    $0x1,%edx
  80039c:	83 c1 01             	add    $0x1,%ecx
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  80039f:	0f b6 1a             	movzbl (%edx),%ebx
  8003a2:	84 db                	test   %bl,%bl
  8003a4:	74 0e                	je     8003b4 <strncmp+0x3c>
  8003a6:	3a 19                	cmp    (%ecx),%bl
  8003a8:	74 ea                	je     800394 <strncmp+0x1c>
  8003aa:	eb 08                	jmp    8003b4 <strncmp+0x3c>
  8003ac:	b8 00 00 00 00       	mov    $0x0,%eax
		n--, p++, q++;
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
}
  8003b1:	5b                   	pop    %ebx
  8003b2:	5d                   	pop    %ebp
  8003b3:	c3                   	ret    
	while (n > 0 && *p && *p == *q)
		n--, p++, q++;
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  8003b4:	0f b6 02             	movzbl (%edx),%eax
  8003b7:	0f b6 11             	movzbl (%ecx),%edx
  8003ba:	29 d0                	sub    %edx,%eax
  8003bc:	eb f3                	jmp    8003b1 <strncmp+0x39>

008003be <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  8003be:	55                   	push   %ebp
  8003bf:	89 e5                	mov    %esp,%ebp
  8003c1:	8b 45 08             	mov    0x8(%ebp),%eax
  8003c4:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  8003c8:	0f b6 10             	movzbl (%eax),%edx
  8003cb:	84 d2                	test   %dl,%dl
  8003cd:	74 15                	je     8003e4 <strchr+0x26>
		if (*s == c)
  8003cf:	38 ca                	cmp    %cl,%dl
  8003d1:	75 07                	jne    8003da <strchr+0x1c>
  8003d3:	eb 14                	jmp    8003e9 <strchr+0x2b>
  8003d5:	38 ca                	cmp    %cl,%dl
  8003d7:	90                   	nop
  8003d8:	74 0f                	je     8003e9 <strchr+0x2b>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  8003da:	83 c0 01             	add    $0x1,%eax
  8003dd:	0f b6 10             	movzbl (%eax),%edx
  8003e0:	84 d2                	test   %dl,%dl
  8003e2:	75 f1                	jne    8003d5 <strchr+0x17>
  8003e4:	b8 00 00 00 00       	mov    $0x0,%eax
		if (*s == c)
			return (char *) s;
	return 0;
}
  8003e9:	5d                   	pop    %ebp
  8003ea:	c3                   	ret    

008003eb <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  8003eb:	55                   	push   %ebp
  8003ec:	89 e5                	mov    %esp,%ebp
  8003ee:	8b 45 08             	mov    0x8(%ebp),%eax
  8003f1:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  8003f5:	0f b6 10             	movzbl (%eax),%edx
  8003f8:	84 d2                	test   %dl,%dl
  8003fa:	74 18                	je     800414 <strfind+0x29>
		if (*s == c)
  8003fc:	38 ca                	cmp    %cl,%dl
  8003fe:	75 0a                	jne    80040a <strfind+0x1f>
  800400:	eb 12                	jmp    800414 <strfind+0x29>
  800402:	38 ca                	cmp    %cl,%dl
  800404:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  800408:	74 0a                	je     800414 <strfind+0x29>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  80040a:	83 c0 01             	add    $0x1,%eax
  80040d:	0f b6 10             	movzbl (%eax),%edx
  800410:	84 d2                	test   %dl,%dl
  800412:	75 ee                	jne    800402 <strfind+0x17>
		if (*s == c)
			break;
	return (char *) s;
}
  800414:	5d                   	pop    %ebp
  800415:	c3                   	ret    

00800416 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800416:	55                   	push   %ebp
  800417:	89 e5                	mov    %esp,%ebp
  800419:	83 ec 0c             	sub    $0xc,%esp
  80041c:	89 1c 24             	mov    %ebx,(%esp)
  80041f:	89 74 24 04          	mov    %esi,0x4(%esp)
  800423:	89 7c 24 08          	mov    %edi,0x8(%esp)
  800427:	8b 7d 08             	mov    0x8(%ebp),%edi
  80042a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80042d:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800430:	85 c9                	test   %ecx,%ecx
  800432:	74 30                	je     800464 <memset+0x4e>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800434:	f7 c7 03 00 00 00    	test   $0x3,%edi
  80043a:	75 25                	jne    800461 <memset+0x4b>
  80043c:	f6 c1 03             	test   $0x3,%cl
  80043f:	75 20                	jne    800461 <memset+0x4b>
		c &= 0xFF;
  800441:	0f b6 d0             	movzbl %al,%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800444:	89 d3                	mov    %edx,%ebx
  800446:	c1 e3 08             	shl    $0x8,%ebx
  800449:	89 d6                	mov    %edx,%esi
  80044b:	c1 e6 18             	shl    $0x18,%esi
  80044e:	89 d0                	mov    %edx,%eax
  800450:	c1 e0 10             	shl    $0x10,%eax
  800453:	09 f0                	or     %esi,%eax
  800455:	09 d0                	or     %edx,%eax
		asm volatile("cld; rep stosl\n"
  800457:	09 d8                	or     %ebx,%eax
  800459:	c1 e9 02             	shr    $0x2,%ecx
  80045c:	fc                   	cld    
  80045d:	f3 ab                	rep stos %eax,%es:(%edi)
{
	char *p;

	if (n == 0)
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  80045f:	eb 03                	jmp    800464 <memset+0x4e>
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800461:	fc                   	cld    
  800462:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800464:	89 f8                	mov    %edi,%eax
  800466:	8b 1c 24             	mov    (%esp),%ebx
  800469:	8b 74 24 04          	mov    0x4(%esp),%esi
  80046d:	8b 7c 24 08          	mov    0x8(%esp),%edi
  800471:	89 ec                	mov    %ebp,%esp
  800473:	5d                   	pop    %ebp
  800474:	c3                   	ret    

00800475 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800475:	55                   	push   %ebp
  800476:	89 e5                	mov    %esp,%ebp
  800478:	83 ec 08             	sub    $0x8,%esp
  80047b:	89 34 24             	mov    %esi,(%esp)
  80047e:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800482:	8b 45 08             	mov    0x8(%ebp),%eax
  800485:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;
	
	s = src;
  800488:	8b 75 0c             	mov    0xc(%ebp),%esi
	d = dst;
  80048b:	89 c7                	mov    %eax,%edi
	if (s < d && s + n > d) {
  80048d:	39 c6                	cmp    %eax,%esi
  80048f:	73 35                	jae    8004c6 <memmove+0x51>
  800491:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800494:	39 d0                	cmp    %edx,%eax
  800496:	73 2e                	jae    8004c6 <memmove+0x51>
		s += n;
		d += n;
  800498:	01 cf                	add    %ecx,%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  80049a:	f6 c2 03             	test   $0x3,%dl
  80049d:	75 1b                	jne    8004ba <memmove+0x45>
  80049f:	f7 c7 03 00 00 00    	test   $0x3,%edi
  8004a5:	75 13                	jne    8004ba <memmove+0x45>
  8004a7:	f6 c1 03             	test   $0x3,%cl
  8004aa:	75 0e                	jne    8004ba <memmove+0x45>
			asm volatile("std; rep movsl\n"
  8004ac:	83 ef 04             	sub    $0x4,%edi
  8004af:	8d 72 fc             	lea    -0x4(%edx),%esi
  8004b2:	c1 e9 02             	shr    $0x2,%ecx
  8004b5:	fd                   	std    
  8004b6:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  8004b8:	eb 09                	jmp    8004c3 <memmove+0x4e>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  8004ba:	83 ef 01             	sub    $0x1,%edi
  8004bd:	8d 72 ff             	lea    -0x1(%edx),%esi
  8004c0:	fd                   	std    
  8004c1:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  8004c3:	fc                   	cld    
	const char *s;
	char *d;
	
	s = src;
	d = dst;
	if (s < d && s + n > d) {
  8004c4:	eb 20                	jmp    8004e6 <memmove+0x71>
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  8004c6:	f7 c6 03 00 00 00    	test   $0x3,%esi
  8004cc:	75 15                	jne    8004e3 <memmove+0x6e>
  8004ce:	f7 c7 03 00 00 00    	test   $0x3,%edi
  8004d4:	75 0d                	jne    8004e3 <memmove+0x6e>
  8004d6:	f6 c1 03             	test   $0x3,%cl
  8004d9:	75 08                	jne    8004e3 <memmove+0x6e>
			asm volatile("cld; rep movsl\n"
  8004db:	c1 e9 02             	shr    $0x2,%ecx
  8004de:	fc                   	cld    
  8004df:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  8004e1:	eb 03                	jmp    8004e6 <memmove+0x71>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  8004e3:	fc                   	cld    
  8004e4:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  8004e6:	8b 34 24             	mov    (%esp),%esi
  8004e9:	8b 7c 24 04          	mov    0x4(%esp),%edi
  8004ed:	89 ec                	mov    %ebp,%esp
  8004ef:	5d                   	pop    %ebp
  8004f0:	c3                   	ret    

008004f1 <memcpy>:

/* sigh - gcc emits references to this for structure assignments! */
/* it is *not* prototyped in inc/string.h - do not use directly. */
void *
memcpy(void *dst, void *src, size_t n)
{
  8004f1:	55                   	push   %ebp
  8004f2:	89 e5                	mov    %esp,%ebp
  8004f4:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  8004f7:	8b 45 10             	mov    0x10(%ebp),%eax
  8004fa:	89 44 24 08          	mov    %eax,0x8(%esp)
  8004fe:	8b 45 0c             	mov    0xc(%ebp),%eax
  800501:	89 44 24 04          	mov    %eax,0x4(%esp)
  800505:	8b 45 08             	mov    0x8(%ebp),%eax
  800508:	89 04 24             	mov    %eax,(%esp)
  80050b:	e8 65 ff ff ff       	call   800475 <memmove>
}
  800510:	c9                   	leave  
  800511:	c3                   	ret    

00800512 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800512:	55                   	push   %ebp
  800513:	89 e5                	mov    %esp,%ebp
  800515:	57                   	push   %edi
  800516:	56                   	push   %esi
  800517:	53                   	push   %ebx
  800518:	8b 75 08             	mov    0x8(%ebp),%esi
  80051b:	8b 7d 0c             	mov    0xc(%ebp),%edi
  80051e:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800521:	85 c9                	test   %ecx,%ecx
  800523:	74 36                	je     80055b <memcmp+0x49>
		if (*s1 != *s2)
  800525:	0f b6 06             	movzbl (%esi),%eax
  800528:	0f b6 1f             	movzbl (%edi),%ebx
  80052b:	38 d8                	cmp    %bl,%al
  80052d:	74 20                	je     80054f <memcmp+0x3d>
  80052f:	eb 14                	jmp    800545 <memcmp+0x33>
  800531:	0f b6 44 16 01       	movzbl 0x1(%esi,%edx,1),%eax
  800536:	0f b6 5c 17 01       	movzbl 0x1(%edi,%edx,1),%ebx
  80053b:	83 c2 01             	add    $0x1,%edx
  80053e:	83 e9 01             	sub    $0x1,%ecx
  800541:	38 d8                	cmp    %bl,%al
  800543:	74 12                	je     800557 <memcmp+0x45>
			return (int) *s1 - (int) *s2;
  800545:	0f b6 c0             	movzbl %al,%eax
  800548:	0f b6 db             	movzbl %bl,%ebx
  80054b:	29 d8                	sub    %ebx,%eax
  80054d:	eb 11                	jmp    800560 <memcmp+0x4e>
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  80054f:	83 e9 01             	sub    $0x1,%ecx
  800552:	ba 00 00 00 00       	mov    $0x0,%edx
  800557:	85 c9                	test   %ecx,%ecx
  800559:	75 d6                	jne    800531 <memcmp+0x1f>
  80055b:	b8 00 00 00 00       	mov    $0x0,%eax
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
}
  800560:	5b                   	pop    %ebx
  800561:	5e                   	pop    %esi
  800562:	5f                   	pop    %edi
  800563:	5d                   	pop    %ebp
  800564:	c3                   	ret    

00800565 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800565:	55                   	push   %ebp
  800566:	89 e5                	mov    %esp,%ebp
  800568:	8b 45 08             	mov    0x8(%ebp),%eax
	const void *ends = (const char *) s + n;
  80056b:	89 c2                	mov    %eax,%edx
  80056d:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800570:	39 d0                	cmp    %edx,%eax
  800572:	73 15                	jae    800589 <memfind+0x24>
		if (*(const unsigned char *) s == (unsigned char) c)
  800574:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
  800578:	38 08                	cmp    %cl,(%eax)
  80057a:	75 06                	jne    800582 <memfind+0x1d>
  80057c:	eb 0b                	jmp    800589 <memfind+0x24>
  80057e:	38 08                	cmp    %cl,(%eax)
  800580:	74 07                	je     800589 <memfind+0x24>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800582:	83 c0 01             	add    $0x1,%eax
  800585:	39 c2                	cmp    %eax,%edx
  800587:	77 f5                	ja     80057e <memfind+0x19>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
	return (void *) s;
}
  800589:	5d                   	pop    %ebp
  80058a:	c3                   	ret    

0080058b <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  80058b:	55                   	push   %ebp
  80058c:	89 e5                	mov    %esp,%ebp
  80058e:	57                   	push   %edi
  80058f:	56                   	push   %esi
  800590:	53                   	push   %ebx
  800591:	83 ec 04             	sub    $0x4,%esp
  800594:	8b 55 08             	mov    0x8(%ebp),%edx
  800597:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  80059a:	0f b6 02             	movzbl (%edx),%eax
  80059d:	3c 20                	cmp    $0x20,%al
  80059f:	74 04                	je     8005a5 <strtol+0x1a>
  8005a1:	3c 09                	cmp    $0x9,%al
  8005a3:	75 0e                	jne    8005b3 <strtol+0x28>
		s++;
  8005a5:	83 c2 01             	add    $0x1,%edx
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8005a8:	0f b6 02             	movzbl (%edx),%eax
  8005ab:	3c 20                	cmp    $0x20,%al
  8005ad:	74 f6                	je     8005a5 <strtol+0x1a>
  8005af:	3c 09                	cmp    $0x9,%al
  8005b1:	74 f2                	je     8005a5 <strtol+0x1a>
		s++;

	// plus/minus sign
	if (*s == '+')
  8005b3:	3c 2b                	cmp    $0x2b,%al
  8005b5:	75 0c                	jne    8005c3 <strtol+0x38>
		s++;
  8005b7:	83 c2 01             	add    $0x1,%edx
  8005ba:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8005c1:	eb 15                	jmp    8005d8 <strtol+0x4d>
	else if (*s == '-')
  8005c3:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8005ca:	3c 2d                	cmp    $0x2d,%al
  8005cc:	75 0a                	jne    8005d8 <strtol+0x4d>
		s++, neg = 1;
  8005ce:	83 c2 01             	add    $0x1,%edx
  8005d1:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  8005d8:	85 db                	test   %ebx,%ebx
  8005da:	0f 94 c0             	sete   %al
  8005dd:	74 05                	je     8005e4 <strtol+0x59>
  8005df:	83 fb 10             	cmp    $0x10,%ebx
  8005e2:	75 18                	jne    8005fc <strtol+0x71>
  8005e4:	80 3a 30             	cmpb   $0x30,(%edx)
  8005e7:	75 13                	jne    8005fc <strtol+0x71>
  8005e9:	80 7a 01 78          	cmpb   $0x78,0x1(%edx)
  8005ed:	8d 76 00             	lea    0x0(%esi),%esi
  8005f0:	75 0a                	jne    8005fc <strtol+0x71>
		s += 2, base = 16;
  8005f2:	83 c2 02             	add    $0x2,%edx
  8005f5:	bb 10 00 00 00       	mov    $0x10,%ebx
		s++;
	else if (*s == '-')
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  8005fa:	eb 15                	jmp    800611 <strtol+0x86>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  8005fc:	84 c0                	test   %al,%al
  8005fe:	66 90                	xchg   %ax,%ax
  800600:	74 0f                	je     800611 <strtol+0x86>
  800602:	bb 0a 00 00 00       	mov    $0xa,%ebx
  800607:	80 3a 30             	cmpb   $0x30,(%edx)
  80060a:	75 05                	jne    800611 <strtol+0x86>
		s++, base = 8;
  80060c:	83 c2 01             	add    $0x1,%edx
  80060f:	b3 08                	mov    $0x8,%bl
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  800611:	b8 00 00 00 00       	mov    $0x0,%eax
  800616:	89 de                	mov    %ebx,%esi

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  800618:	0f b6 0a             	movzbl (%edx),%ecx
  80061b:	89 cf                	mov    %ecx,%edi
  80061d:	8d 59 d0             	lea    -0x30(%ecx),%ebx
  800620:	80 fb 09             	cmp    $0x9,%bl
  800623:	77 08                	ja     80062d <strtol+0xa2>
			dig = *s - '0';
  800625:	0f be c9             	movsbl %cl,%ecx
  800628:	83 e9 30             	sub    $0x30,%ecx
  80062b:	eb 1e                	jmp    80064b <strtol+0xc0>
		else if (*s >= 'a' && *s <= 'z')
  80062d:	8d 5f 9f             	lea    -0x61(%edi),%ebx
  800630:	80 fb 19             	cmp    $0x19,%bl
  800633:	77 08                	ja     80063d <strtol+0xb2>
			dig = *s - 'a' + 10;
  800635:	0f be c9             	movsbl %cl,%ecx
  800638:	83 e9 57             	sub    $0x57,%ecx
  80063b:	eb 0e                	jmp    80064b <strtol+0xc0>
		else if (*s >= 'A' && *s <= 'Z')
  80063d:	8d 5f bf             	lea    -0x41(%edi),%ebx
  800640:	80 fb 19             	cmp    $0x19,%bl
  800643:	77 15                	ja     80065a <strtol+0xcf>
			dig = *s - 'A' + 10;
  800645:	0f be c9             	movsbl %cl,%ecx
  800648:	83 e9 37             	sub    $0x37,%ecx
		else
			break;
		if (dig >= base)
  80064b:	39 f1                	cmp    %esi,%ecx
  80064d:	7d 0b                	jge    80065a <strtol+0xcf>
			break;
		s++, val = (val * base) + dig;
  80064f:	83 c2 01             	add    $0x1,%edx
  800652:	0f af c6             	imul   %esi,%eax
  800655:	8d 04 01             	lea    (%ecx,%eax,1),%eax
		// we don't properly detect overflow!
	}
  800658:	eb be                	jmp    800618 <strtol+0x8d>
  80065a:	89 c1                	mov    %eax,%ecx

	if (endptr)
  80065c:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800660:	74 05                	je     800667 <strtol+0xdc>
		*endptr = (char *) s;
  800662:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800665:	89 13                	mov    %edx,(%ebx)
	return (neg ? -val : val);
  800667:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80066b:	74 04                	je     800671 <strtol+0xe6>
  80066d:	89 c8                	mov    %ecx,%eax
  80066f:	f7 d8                	neg    %eax
}
  800671:	83 c4 04             	add    $0x4,%esp
  800674:	5b                   	pop    %ebx
  800675:	5e                   	pop    %esi
  800676:	5f                   	pop    %edi
  800677:	5d                   	pop    %ebp
  800678:	c3                   	ret    
  800679:	00 00                	add    %al,(%eax)
	...

0080067c <sys_cgetc>:
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}

int
sys_cgetc(void)
{
  80067c:	55                   	push   %ebp
  80067d:	89 e5                	mov    %esp,%ebp
  80067f:	83 ec 0c             	sub    $0xc,%esp
  800682:	89 1c 24             	mov    %ebx,(%esp)
  800685:	89 74 24 04          	mov    %esi,0x4(%esp)
  800689:	89 7c 24 08          	mov    %edi,0x8(%esp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80068d:	ba 00 00 00 00       	mov    $0x0,%edx
  800692:	b8 01 00 00 00       	mov    $0x1,%eax
  800697:	89 d1                	mov    %edx,%ecx
  800699:	89 d3                	mov    %edx,%ebx
  80069b:	89 d7                	mov    %edx,%edi
  80069d:	89 d6                	mov    %edx,%esi
  80069f:	cd 30                	int    $0x30

int
sys_cgetc(void)
{
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  8006a1:	8b 1c 24             	mov    (%esp),%ebx
  8006a4:	8b 74 24 04          	mov    0x4(%esp),%esi
  8006a8:	8b 7c 24 08          	mov    0x8(%esp),%edi
  8006ac:	89 ec                	mov    %ebp,%esp
  8006ae:	5d                   	pop    %ebp
  8006af:	c3                   	ret    

008006b0 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  8006b0:	55                   	push   %ebp
  8006b1:	89 e5                	mov    %esp,%ebp
  8006b3:	83 ec 0c             	sub    $0xc,%esp
  8006b6:	89 1c 24             	mov    %ebx,(%esp)
  8006b9:	89 74 24 04          	mov    %esi,0x4(%esp)
  8006bd:	89 7c 24 08          	mov    %edi,0x8(%esp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8006c1:	b8 00 00 00 00       	mov    $0x0,%eax
  8006c6:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8006c9:	8b 55 08             	mov    0x8(%ebp),%edx
  8006cc:	89 c3                	mov    %eax,%ebx
  8006ce:	89 c7                	mov    %eax,%edi
  8006d0:	89 c6                	mov    %eax,%esi
  8006d2:	cd 30                	int    $0x30

void
sys_cputs(const char *s, size_t len)
{
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  8006d4:	8b 1c 24             	mov    (%esp),%ebx
  8006d7:	8b 74 24 04          	mov    0x4(%esp),%esi
  8006db:	8b 7c 24 08          	mov    0x8(%esp),%edi
  8006df:	89 ec                	mov    %ebp,%esp
  8006e1:	5d                   	pop    %ebp
  8006e2:	c3                   	ret    

008006e3 <sys_page_insert>:
{
	return syscall(SYS_page_waste, 0, (uint32_t)p, (uint32_t)n, 0, 0,0);
}
int
sys_page_insert(envid_t envid, void *va, struct Page *p, int perm)
{
  8006e3:	55                   	push   %ebp
  8006e4:	89 e5                	mov    %esp,%ebp
  8006e6:	83 ec 38             	sub    $0x38,%esp
  8006e9:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  8006ec:	89 75 f8             	mov    %esi,-0x8(%ebp)
  8006ef:	89 7d fc             	mov    %edi,-0x4(%ebp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8006f2:	be 00 00 00 00       	mov    $0x0,%esi
  8006f7:	b8 12 00 00 00       	mov    $0x12,%eax
  8006fc:	8b 7d 14             	mov    0x14(%ebp),%edi
  8006ff:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800702:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800705:	8b 55 08             	mov    0x8(%ebp),%edx
  800708:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
	
	if(check && ret > 0)
  80070a:	85 c0                	test   %eax,%eax
  80070c:	7e 28                	jle    800736 <sys_page_insert+0x53>
		panic("syscall %d returned %d (> 0)", num, ret);
  80070e:	89 44 24 10          	mov    %eax,0x10(%esp)
  800712:	c7 44 24 0c 12 00 00 	movl   $0x12,0xc(%esp)
  800719:	00 
  80071a:	c7 44 24 08 d1 2d 80 	movl   $0x802dd1,0x8(%esp)
  800721:	00 
  800722:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800729:	00 
  80072a:	c7 04 24 ee 2d 80 00 	movl   $0x802dee,(%esp)
  800731:	e8 86 1b 00 00       	call   8022bc <_panic>
}
int
sys_page_insert(envid_t envid, void *va, struct Page *p, int perm)
{
	return syscall(SYS_page_insert, 1, envid, (uint32_t) va, (uint32_t)p, perm, 0);
}
  800736:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800739:	8b 75 f8             	mov    -0x8(%ebp),%esi
  80073c:	8b 7d fc             	mov    -0x4(%ebp),%edi
  80073f:	89 ec                	mov    %ebp,%esp
  800741:	5d                   	pop    %ebp
  800742:	c3                   	ret    

00800743 <sys_page_waste>:
{
	return (int)syscall(SYS_receive_packet, 0, (uint32_t)buffer, 0,0,0,0);
}

int sys_page_waste(struct Page **p, int n)
{
  800743:	55                   	push   %ebp
  800744:	89 e5                	mov    %esp,%ebp
  800746:	83 ec 0c             	sub    $0xc,%esp
  800749:	89 1c 24             	mov    %ebx,(%esp)
  80074c:	89 74 24 04          	mov    %esi,0x4(%esp)
  800750:	89 7c 24 08          	mov    %edi,0x8(%esp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800754:	bb 00 00 00 00       	mov    $0x0,%ebx
  800759:	b8 11 00 00 00       	mov    $0x11,%eax
  80075e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800761:	8b 55 08             	mov    0x8(%ebp),%edx
  800764:	89 df                	mov    %ebx,%edi
  800766:	89 de                	mov    %ebx,%esi
  800768:	cd 30                	int    $0x30
}

int sys_page_waste(struct Page **p, int n)
{
	return syscall(SYS_page_waste, 0, (uint32_t)p, (uint32_t)n, 0, 0,0);
}
  80076a:	8b 1c 24             	mov    (%esp),%ebx
  80076d:	8b 74 24 04          	mov    0x4(%esp),%esi
  800771:	8b 7c 24 08          	mov    0x8(%esp),%edi
  800775:	89 ec                	mov    %ebp,%esp
  800777:	5d                   	pop    %ebp
  800778:	c3                   	ret    

00800779 <sys_receive_packet>:
{
	return (int)syscall(SYS_transmit_packet, 1, (uint32_t)data, len, 0,0,0);
}

int sys_receive_packet(void* buffer)
{
  800779:	55                   	push   %ebp
  80077a:	89 e5                	mov    %esp,%ebp
  80077c:	83 ec 0c             	sub    $0xc,%esp
  80077f:	89 1c 24             	mov    %ebx,(%esp)
  800782:	89 74 24 04          	mov    %esi,0x4(%esp)
  800786:	89 7c 24 08          	mov    %edi,0x8(%esp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80078a:	b9 00 00 00 00       	mov    $0x0,%ecx
  80078f:	b8 10 00 00 00       	mov    $0x10,%eax
  800794:	8b 55 08             	mov    0x8(%ebp),%edx
  800797:	89 cb                	mov    %ecx,%ebx
  800799:	89 cf                	mov    %ecx,%edi
  80079b:	89 ce                	mov    %ecx,%esi
  80079d:	cd 30                	int    $0x30
}

int sys_receive_packet(void* buffer)
{
	return (int)syscall(SYS_receive_packet, 0, (uint32_t)buffer, 0,0,0,0);
}
  80079f:	8b 1c 24             	mov    (%esp),%ebx
  8007a2:	8b 74 24 04          	mov    0x4(%esp),%esi
  8007a6:	8b 7c 24 08          	mov    0x8(%esp),%edi
  8007aa:	89 ec                	mov    %ebp,%esp
  8007ac:	5d                   	pop    %ebp
  8007ad:	c3                   	ret    

008007ae <sys_transmit_packet>:
{
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0,0);
}

int sys_transmit_packet(void* data, uint32_t len)
{
  8007ae:	55                   	push   %ebp
  8007af:	89 e5                	mov    %esp,%ebp
  8007b1:	83 ec 38             	sub    $0x38,%esp
  8007b4:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  8007b7:	89 75 f8             	mov    %esi,-0x8(%ebp)
  8007ba:	89 7d fc             	mov    %edi,-0x4(%ebp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8007bd:	bb 00 00 00 00       	mov    $0x0,%ebx
  8007c2:	b8 0f 00 00 00       	mov    $0xf,%eax
  8007c7:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8007ca:	8b 55 08             	mov    0x8(%ebp),%edx
  8007cd:	89 df                	mov    %ebx,%edi
  8007cf:	89 de                	mov    %ebx,%esi
  8007d1:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
	
	if(check && ret > 0)
  8007d3:	85 c0                	test   %eax,%eax
  8007d5:	7e 28                	jle    8007ff <sys_transmit_packet+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  8007d7:	89 44 24 10          	mov    %eax,0x10(%esp)
  8007db:	c7 44 24 0c 0f 00 00 	movl   $0xf,0xc(%esp)
  8007e2:	00 
  8007e3:	c7 44 24 08 d1 2d 80 	movl   $0x802dd1,0x8(%esp)
  8007ea:	00 
  8007eb:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  8007f2:	00 
  8007f3:	c7 04 24 ee 2d 80 00 	movl   $0x802dee,(%esp)
  8007fa:	e8 bd 1a 00 00       	call   8022bc <_panic>
}

int sys_transmit_packet(void* data, uint32_t len)
{
	return (int)syscall(SYS_transmit_packet, 1, (uint32_t)data, len, 0,0,0);
}
  8007ff:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800802:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800805:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800808:	89 ec                	mov    %ebp,%esp
  80080a:	5d                   	pop    %ebp
  80080b:	c3                   	ret    

0080080c <sys_time_msec>:
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}

unsigned int
sys_time_msec(void)
{
  80080c:	55                   	push   %ebp
  80080d:	89 e5                	mov    %esp,%ebp
  80080f:	83 ec 0c             	sub    $0xc,%esp
  800812:	89 1c 24             	mov    %ebx,(%esp)
  800815:	89 74 24 04          	mov    %esi,0x4(%esp)
  800819:	89 7c 24 08          	mov    %edi,0x8(%esp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80081d:	ba 00 00 00 00       	mov    $0x0,%edx
  800822:	b8 0e 00 00 00       	mov    $0xe,%eax
  800827:	89 d1                	mov    %edx,%ecx
  800829:	89 d3                	mov    %edx,%ebx
  80082b:	89 d7                	mov    %edx,%edi
  80082d:	89 d6                	mov    %edx,%esi
  80082f:	cd 30                	int    $0x30

unsigned int
sys_time_msec(void)
{
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0,0);
}
  800831:	8b 1c 24             	mov    (%esp),%ebx
  800834:	8b 74 24 04          	mov    0x4(%esp),%esi
  800838:	8b 7c 24 08          	mov    0x8(%esp),%edi
  80083c:	89 ec                	mov    %ebp,%esp
  80083e:	5d                   	pop    %ebp
  80083f:	c3                   	ret    

00800840 <sys_ipc_recv>:
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}

int
sys_ipc_recv(void *dstva)
{
  800840:	55                   	push   %ebp
  800841:	89 e5                	mov    %esp,%ebp
  800843:	83 ec 38             	sub    $0x38,%esp
  800846:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800849:	89 75 f8             	mov    %esi,-0x8(%ebp)
  80084c:	89 7d fc             	mov    %edi,-0x4(%ebp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80084f:	b9 00 00 00 00       	mov    $0x0,%ecx
  800854:	b8 0d 00 00 00       	mov    $0xd,%eax
  800859:	8b 55 08             	mov    0x8(%ebp),%edx
  80085c:	89 cb                	mov    %ecx,%ebx
  80085e:	89 cf                	mov    %ecx,%edi
  800860:	89 ce                	mov    %ecx,%esi
  800862:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
	
	if(check && ret > 0)
  800864:	85 c0                	test   %eax,%eax
  800866:	7e 28                	jle    800890 <sys_ipc_recv+0x50>
		panic("syscall %d returned %d (> 0)", num, ret);
  800868:	89 44 24 10          	mov    %eax,0x10(%esp)
  80086c:	c7 44 24 0c 0d 00 00 	movl   $0xd,0xc(%esp)
  800873:	00 
  800874:	c7 44 24 08 d1 2d 80 	movl   $0x802dd1,0x8(%esp)
  80087b:	00 
  80087c:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800883:	00 
  800884:	c7 04 24 ee 2d 80 00 	movl   $0x802dee,(%esp)
  80088b:	e8 2c 1a 00 00       	call   8022bc <_panic>

int
sys_ipc_recv(void *dstva)
{
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  800890:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800893:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800896:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800899:	89 ec                	mov    %ebp,%esp
  80089b:	5d                   	pop    %ebp
  80089c:	c3                   	ret    

0080089d <sys_ipc_try_send>:
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  80089d:	55                   	push   %ebp
  80089e:	89 e5                	mov    %esp,%ebp
  8008a0:	83 ec 0c             	sub    $0xc,%esp
  8008a3:	89 1c 24             	mov    %ebx,(%esp)
  8008a6:	89 74 24 04          	mov    %esi,0x4(%esp)
  8008aa:	89 7c 24 08          	mov    %edi,0x8(%esp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8008ae:	be 00 00 00 00       	mov    $0x0,%esi
  8008b3:	b8 0c 00 00 00       	mov    $0xc,%eax
  8008b8:	8b 7d 14             	mov    0x14(%ebp),%edi
  8008bb:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8008be:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8008c1:	8b 55 08             	mov    0x8(%ebp),%edx
  8008c4:	cd 30                	int    $0x30

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  8008c6:	8b 1c 24             	mov    (%esp),%ebx
  8008c9:	8b 74 24 04          	mov    0x4(%esp),%esi
  8008cd:	8b 7c 24 08          	mov    0x8(%esp),%edi
  8008d1:	89 ec                	mov    %ebp,%esp
  8008d3:	5d                   	pop    %ebp
  8008d4:	c3                   	ret    

008008d5 <sys_env_set_pgfault_upcall>:
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  8008d5:	55                   	push   %ebp
  8008d6:	89 e5                	mov    %esp,%ebp
  8008d8:	83 ec 38             	sub    $0x38,%esp
  8008db:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  8008de:	89 75 f8             	mov    %esi,-0x8(%ebp)
  8008e1:	89 7d fc             	mov    %edi,-0x4(%ebp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8008e4:	bb 00 00 00 00       	mov    $0x0,%ebx
  8008e9:	b8 0a 00 00 00       	mov    $0xa,%eax
  8008ee:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8008f1:	8b 55 08             	mov    0x8(%ebp),%edx
  8008f4:	89 df                	mov    %ebx,%edi
  8008f6:	89 de                	mov    %ebx,%esi
  8008f8:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
	
	if(check && ret > 0)
  8008fa:	85 c0                	test   %eax,%eax
  8008fc:	7e 28                	jle    800926 <sys_env_set_pgfault_upcall+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  8008fe:	89 44 24 10          	mov    %eax,0x10(%esp)
  800902:	c7 44 24 0c 0a 00 00 	movl   $0xa,0xc(%esp)
  800909:	00 
  80090a:	c7 44 24 08 d1 2d 80 	movl   $0x802dd1,0x8(%esp)
  800911:	00 
  800912:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800919:	00 
  80091a:	c7 04 24 ee 2d 80 00 	movl   $0x802dee,(%esp)
  800921:	e8 96 19 00 00       	call   8022bc <_panic>

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  800926:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800929:	8b 75 f8             	mov    -0x8(%ebp),%esi
  80092c:	8b 7d fc             	mov    -0x4(%ebp),%edi
  80092f:	89 ec                	mov    %ebp,%esp
  800931:	5d                   	pop    %ebp
  800932:	c3                   	ret    

00800933 <sys_env_set_trapframe>:
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800933:	55                   	push   %ebp
  800934:	89 e5                	mov    %esp,%ebp
  800936:	83 ec 38             	sub    $0x38,%esp
  800939:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  80093c:	89 75 f8             	mov    %esi,-0x8(%ebp)
  80093f:	89 7d fc             	mov    %edi,-0x4(%ebp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800942:	bb 00 00 00 00       	mov    $0x0,%ebx
  800947:	b8 09 00 00 00       	mov    $0x9,%eax
  80094c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80094f:	8b 55 08             	mov    0x8(%ebp),%edx
  800952:	89 df                	mov    %ebx,%edi
  800954:	89 de                	mov    %ebx,%esi
  800956:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
	
	if(check && ret > 0)
  800958:	85 c0                	test   %eax,%eax
  80095a:	7e 28                	jle    800984 <sys_env_set_trapframe+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  80095c:	89 44 24 10          	mov    %eax,0x10(%esp)
  800960:	c7 44 24 0c 09 00 00 	movl   $0x9,0xc(%esp)
  800967:	00 
  800968:	c7 44 24 08 d1 2d 80 	movl   $0x802dd1,0x8(%esp)
  80096f:	00 
  800970:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800977:	00 
  800978:	c7 04 24 ee 2d 80 00 	movl   $0x802dee,(%esp)
  80097f:	e8 38 19 00 00       	call   8022bc <_panic>

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  800984:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800987:	8b 75 f8             	mov    -0x8(%ebp),%esi
  80098a:	8b 7d fc             	mov    -0x4(%ebp),%edi
  80098d:	89 ec                	mov    %ebp,%esp
  80098f:	5d                   	pop    %ebp
  800990:	c3                   	ret    

00800991 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800991:	55                   	push   %ebp
  800992:	89 e5                	mov    %esp,%ebp
  800994:	83 ec 38             	sub    $0x38,%esp
  800997:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  80099a:	89 75 f8             	mov    %esi,-0x8(%ebp)
  80099d:	89 7d fc             	mov    %edi,-0x4(%ebp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8009a0:	bb 00 00 00 00       	mov    $0x0,%ebx
  8009a5:	b8 08 00 00 00       	mov    $0x8,%eax
  8009aa:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8009ad:	8b 55 08             	mov    0x8(%ebp),%edx
  8009b0:	89 df                	mov    %ebx,%edi
  8009b2:	89 de                	mov    %ebx,%esi
  8009b4:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
	
	if(check && ret > 0)
  8009b6:	85 c0                	test   %eax,%eax
  8009b8:	7e 28                	jle    8009e2 <sys_env_set_status+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  8009ba:	89 44 24 10          	mov    %eax,0x10(%esp)
  8009be:	c7 44 24 0c 08 00 00 	movl   $0x8,0xc(%esp)
  8009c5:	00 
  8009c6:	c7 44 24 08 d1 2d 80 	movl   $0x802dd1,0x8(%esp)
  8009cd:	00 
  8009ce:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  8009d5:	00 
  8009d6:	c7 04 24 ee 2d 80 00 	movl   $0x802dee,(%esp)
  8009dd:	e8 da 18 00 00       	call   8022bc <_panic>

int
sys_env_set_status(envid_t envid, int status)
{
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  8009e2:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  8009e5:	8b 75 f8             	mov    -0x8(%ebp),%esi
  8009e8:	8b 7d fc             	mov    -0x4(%ebp),%edi
  8009eb:	89 ec                	mov    %ebp,%esp
  8009ed:	5d                   	pop    %ebp
  8009ee:	c3                   	ret    

008009ef <sys_page_unmap>:
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}

int
sys_page_unmap(envid_t envid, void *va)
{
  8009ef:	55                   	push   %ebp
  8009f0:	89 e5                	mov    %esp,%ebp
  8009f2:	83 ec 38             	sub    $0x38,%esp
  8009f5:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  8009f8:	89 75 f8             	mov    %esi,-0x8(%ebp)
  8009fb:	89 7d fc             	mov    %edi,-0x4(%ebp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8009fe:	bb 00 00 00 00       	mov    $0x0,%ebx
  800a03:	b8 06 00 00 00       	mov    $0x6,%eax
  800a08:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800a0b:	8b 55 08             	mov    0x8(%ebp),%edx
  800a0e:	89 df                	mov    %ebx,%edi
  800a10:	89 de                	mov    %ebx,%esi
  800a12:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
	
	if(check && ret > 0)
  800a14:	85 c0                	test   %eax,%eax
  800a16:	7e 28                	jle    800a40 <sys_page_unmap+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  800a18:	89 44 24 10          	mov    %eax,0x10(%esp)
  800a1c:	c7 44 24 0c 06 00 00 	movl   $0x6,0xc(%esp)
  800a23:	00 
  800a24:	c7 44 24 08 d1 2d 80 	movl   $0x802dd1,0x8(%esp)
  800a2b:	00 
  800a2c:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800a33:	00 
  800a34:	c7 04 24 ee 2d 80 00 	movl   $0x802dee,(%esp)
  800a3b:	e8 7c 18 00 00       	call   8022bc <_panic>

int
sys_page_unmap(envid_t envid, void *va)
{
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800a40:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800a43:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800a46:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800a49:	89 ec                	mov    %ebp,%esp
  800a4b:	5d                   	pop    %ebp
  800a4c:	c3                   	ret    

00800a4d <sys_page_map>:
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800a4d:	55                   	push   %ebp
  800a4e:	89 e5                	mov    %esp,%ebp
  800a50:	83 ec 38             	sub    $0x38,%esp
  800a53:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800a56:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800a59:	89 7d fc             	mov    %edi,-0x4(%ebp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800a5c:	b8 05 00 00 00       	mov    $0x5,%eax
  800a61:	8b 75 18             	mov    0x18(%ebp),%esi
  800a64:	8b 7d 14             	mov    0x14(%ebp),%edi
  800a67:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800a6a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800a6d:	8b 55 08             	mov    0x8(%ebp),%edx
  800a70:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
	
	if(check && ret > 0)
  800a72:	85 c0                	test   %eax,%eax
  800a74:	7e 28                	jle    800a9e <sys_page_map+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  800a76:	89 44 24 10          	mov    %eax,0x10(%esp)
  800a7a:	c7 44 24 0c 05 00 00 	movl   $0x5,0xc(%esp)
  800a81:	00 
  800a82:	c7 44 24 08 d1 2d 80 	movl   $0x802dd1,0x8(%esp)
  800a89:	00 
  800a8a:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800a91:	00 
  800a92:	c7 04 24 ee 2d 80 00 	movl   $0x802dee,(%esp)
  800a99:	e8 1e 18 00 00       	call   8022bc <_panic>

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800a9e:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800aa1:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800aa4:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800aa7:	89 ec                	mov    %ebp,%esp
  800aa9:	5d                   	pop    %ebp
  800aaa:	c3                   	ret    

00800aab <sys_page_alloc>:
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800aab:	55                   	push   %ebp
  800aac:	89 e5                	mov    %esp,%ebp
  800aae:	83 ec 38             	sub    $0x38,%esp
  800ab1:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800ab4:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800ab7:	89 7d fc             	mov    %edi,-0x4(%ebp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800aba:	be 00 00 00 00       	mov    $0x0,%esi
  800abf:	b8 04 00 00 00       	mov    $0x4,%eax
  800ac4:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800ac7:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800aca:	8b 55 08             	mov    0x8(%ebp),%edx
  800acd:	89 f7                	mov    %esi,%edi
  800acf:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
	
	if(check && ret > 0)
  800ad1:	85 c0                	test   %eax,%eax
  800ad3:	7e 28                	jle    800afd <sys_page_alloc+0x52>
		panic("syscall %d returned %d (> 0)", num, ret);
  800ad5:	89 44 24 10          	mov    %eax,0x10(%esp)
  800ad9:	c7 44 24 0c 04 00 00 	movl   $0x4,0xc(%esp)
  800ae0:	00 
  800ae1:	c7 44 24 08 d1 2d 80 	movl   $0x802dd1,0x8(%esp)
  800ae8:	00 
  800ae9:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800af0:	00 
  800af1:	c7 04 24 ee 2d 80 00 	movl   $0x802dee,(%esp)
  800af8:	e8 bf 17 00 00       	call   8022bc <_panic>

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800afd:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800b00:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800b03:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800b06:	89 ec                	mov    %ebp,%esp
  800b08:	5d                   	pop    %ebp
  800b09:	c3                   	ret    

00800b0a <sys_yield>:
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}

void
sys_yield(void)
{
  800b0a:	55                   	push   %ebp
  800b0b:	89 e5                	mov    %esp,%ebp
  800b0d:	83 ec 0c             	sub    $0xc,%esp
  800b10:	89 1c 24             	mov    %ebx,(%esp)
  800b13:	89 74 24 04          	mov    %esi,0x4(%esp)
  800b17:	89 7c 24 08          	mov    %edi,0x8(%esp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800b1b:	ba 00 00 00 00       	mov    $0x0,%edx
  800b20:	b8 0b 00 00 00       	mov    $0xb,%eax
  800b25:	89 d1                	mov    %edx,%ecx
  800b27:	89 d3                	mov    %edx,%ebx
  800b29:	89 d7                	mov    %edx,%edi
  800b2b:	89 d6                	mov    %edx,%esi
  800b2d:	cd 30                	int    $0x30

void
sys_yield(void)
{
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800b2f:	8b 1c 24             	mov    (%esp),%ebx
  800b32:	8b 74 24 04          	mov    0x4(%esp),%esi
  800b36:	8b 7c 24 08          	mov    0x8(%esp),%edi
  800b3a:	89 ec                	mov    %ebp,%esp
  800b3c:	5d                   	pop    %ebp
  800b3d:	c3                   	ret    

00800b3e <sys_getenvid>:
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}

envid_t
sys_getenvid(void)
{
  800b3e:	55                   	push   %ebp
  800b3f:	89 e5                	mov    %esp,%ebp
  800b41:	83 ec 0c             	sub    $0xc,%esp
  800b44:	89 1c 24             	mov    %ebx,(%esp)
  800b47:	89 74 24 04          	mov    %esi,0x4(%esp)
  800b4b:	89 7c 24 08          	mov    %edi,0x8(%esp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800b4f:	ba 00 00 00 00       	mov    $0x0,%edx
  800b54:	b8 02 00 00 00       	mov    $0x2,%eax
  800b59:	89 d1                	mov    %edx,%ecx
  800b5b:	89 d3                	mov    %edx,%ebx
  800b5d:	89 d7                	mov    %edx,%edi
  800b5f:	89 d6                	mov    %edx,%esi
  800b61:	cd 30                	int    $0x30

envid_t
sys_getenvid(void)
{
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800b63:	8b 1c 24             	mov    (%esp),%ebx
  800b66:	8b 74 24 04          	mov    0x4(%esp),%esi
  800b6a:	8b 7c 24 08          	mov    0x8(%esp),%edi
  800b6e:	89 ec                	mov    %ebp,%esp
  800b70:	5d                   	pop    %ebp
  800b71:	c3                   	ret    

00800b72 <sys_env_destroy>:
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}

int
sys_env_destroy(envid_t envid)
{
  800b72:	55                   	push   %ebp
  800b73:	89 e5                	mov    %esp,%ebp
  800b75:	83 ec 38             	sub    $0x38,%esp
  800b78:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800b7b:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800b7e:	89 7d fc             	mov    %edi,-0x4(%ebp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800b81:	b9 00 00 00 00       	mov    $0x0,%ecx
  800b86:	b8 03 00 00 00       	mov    $0x3,%eax
  800b8b:	8b 55 08             	mov    0x8(%ebp),%edx
  800b8e:	89 cb                	mov    %ecx,%ebx
  800b90:	89 cf                	mov    %ecx,%edi
  800b92:	89 ce                	mov    %ecx,%esi
  800b94:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
	
	if(check && ret > 0)
  800b96:	85 c0                	test   %eax,%eax
  800b98:	7e 28                	jle    800bc2 <sys_env_destroy+0x50>
		panic("syscall %d returned %d (> 0)", num, ret);
  800b9a:	89 44 24 10          	mov    %eax,0x10(%esp)
  800b9e:	c7 44 24 0c 03 00 00 	movl   $0x3,0xc(%esp)
  800ba5:	00 
  800ba6:	c7 44 24 08 d1 2d 80 	movl   $0x802dd1,0x8(%esp)
  800bad:	00 
  800bae:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800bb5:	00 
  800bb6:	c7 04 24 ee 2d 80 00 	movl   $0x802dee,(%esp)
  800bbd:	e8 fa 16 00 00       	call   8022bc <_panic>

int
sys_env_destroy(envid_t envid)
{
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800bc2:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800bc5:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800bc8:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800bcb:	89 ec                	mov    %ebp,%esp
  800bcd:	5d                   	pop    %ebp
  800bce:	c3                   	ret    
	...

00800bd0 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  800bd0:	55                   	push   %ebp
  800bd1:	89 e5                	mov    %esp,%ebp
  800bd3:	8b 45 08             	mov    0x8(%ebp),%eax
  800bd6:	05 00 00 00 30       	add    $0x30000000,%eax
  800bdb:	c1 e8 0c             	shr    $0xc,%eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
}
  800bde:	5d                   	pop    %ebp
  800bdf:	c3                   	ret    

00800be0 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  800be0:	55                   	push   %ebp
  800be1:	89 e5                	mov    %esp,%ebp
  800be3:	83 ec 04             	sub    $0x4,%esp
	return INDEX2DATA(fd2num(fd));
  800be6:	8b 45 08             	mov    0x8(%ebp),%eax
  800be9:	89 04 24             	mov    %eax,(%esp)
  800bec:	e8 df ff ff ff       	call   800bd0 <fd2num>
  800bf1:	05 20 00 0d 00       	add    $0xd0020,%eax
  800bf6:	c1 e0 0c             	shl    $0xc,%eax
}
  800bf9:	c9                   	leave  
  800bfa:	c3                   	ret    

00800bfb <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  800bfb:	55                   	push   %ebp
  800bfc:	89 e5                	mov    %esp,%ebp
  800bfe:	57                   	push   %edi
  800bff:	56                   	push   %esi
  800c00:	53                   	push   %ebx
  800c01:	8b 7d 08             	mov    0x8(%ebp),%edi
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((vpd[PDX(fd)] & PTE_P) == 0 || (vpt[VPN(fd)] & PTE_P) == 0) {
  800c04:	a1 00 dd 7b ef       	mov    0xef7bdd00,%eax
  800c09:	a8 01                	test   $0x1,%al
  800c0b:	74 36                	je     800c43 <fd_alloc+0x48>
  800c0d:	a1 00 00 74 ef       	mov    0xef740000,%eax
  800c12:	a8 01                	test   $0x1,%al
  800c14:	74 2d                	je     800c43 <fd_alloc+0x48>
  800c16:	b8 00 10 00 d0       	mov    $0xd0001000,%eax
  800c1b:	b9 00 d0 7b ef       	mov    $0xef7bd000,%ecx
  800c20:	be 00 00 40 ef       	mov    $0xef400000,%esi
  800c25:	89 c3                	mov    %eax,%ebx
  800c27:	89 c2                	mov    %eax,%edx
  800c29:	c1 ea 16             	shr    $0x16,%edx
  800c2c:	8b 14 91             	mov    (%ecx,%edx,4),%edx
  800c2f:	f6 c2 01             	test   $0x1,%dl
  800c32:	74 14                	je     800c48 <fd_alloc+0x4d>
  800c34:	89 c2                	mov    %eax,%edx
  800c36:	c1 ea 0c             	shr    $0xc,%edx
  800c39:	8b 14 96             	mov    (%esi,%edx,4),%edx
  800c3c:	f6 c2 01             	test   $0x1,%dl
  800c3f:	75 10                	jne    800c51 <fd_alloc+0x56>
  800c41:	eb 05                	jmp    800c48 <fd_alloc+0x4d>
  800c43:	bb 00 00 00 d0       	mov    $0xd0000000,%ebx
			*fd_store = fd;
  800c48:	89 1f                	mov    %ebx,(%edi)
  800c4a:	b8 00 00 00 00       	mov    $0x0,%eax
			return 0;
  800c4f:	eb 17                	jmp    800c68 <fd_alloc+0x6d>
  800c51:	05 00 10 00 00       	add    $0x1000,%eax
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  800c56:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  800c5b:	75 c8                	jne    800c25 <fd_alloc+0x2a>
		if ((vpd[PDX(fd)] & PTE_P) == 0 || (vpt[VPN(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  800c5d:	c7 07 00 00 00 00    	movl   $0x0,(%edi)
  800c63:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
	return -E_MAX_OPEN;
}
  800c68:	5b                   	pop    %ebx
  800c69:	5e                   	pop    %esi
  800c6a:	5f                   	pop    %edi
  800c6b:	5d                   	pop    %ebp
  800c6c:	c3                   	ret    

00800c6d <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  800c6d:	55                   	push   %ebp
  800c6e:	89 e5                	mov    %esp,%ebp
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  800c70:	8b 45 08             	mov    0x8(%ebp),%eax
  800c73:	83 f8 1f             	cmp    $0x1f,%eax
  800c76:	77 36                	ja     800cae <fd_lookup+0x41>
		if (debug)
			cprintf("[%08x] bad fd %d\n", env->env_id, fd);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  800c78:	05 00 00 0d 00       	add    $0xd0000,%eax
  800c7d:	c1 e0 0c             	shl    $0xc,%eax
	if (!(vpd[PDX(fd)] & PTE_P) || !(vpt[VPN(fd)] & PTE_P)) {
  800c80:	89 c2                	mov    %eax,%edx
  800c82:	c1 ea 16             	shr    $0x16,%edx
  800c85:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  800c8c:	f6 c2 01             	test   $0x1,%dl
  800c8f:	74 1d                	je     800cae <fd_lookup+0x41>
  800c91:	89 c2                	mov    %eax,%edx
  800c93:	c1 ea 0c             	shr    $0xc,%edx
  800c96:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  800c9d:	f6 c2 01             	test   $0x1,%dl
  800ca0:	74 0c                	je     800cae <fd_lookup+0x41>
		if (debug)
			cprintf("[%08x] closed fd %d\n", env->env_id, fd);
		return -E_INVAL;
	}
	*fd_store = fd;
  800ca2:	8b 55 0c             	mov    0xc(%ebp),%edx
  800ca5:	89 02                	mov    %eax,(%edx)
  800ca7:	b8 00 00 00 00       	mov    $0x0,%eax
	return 0;
  800cac:	eb 05                	jmp    800cb3 <fd_lookup+0x46>
  800cae:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  800cb3:	5d                   	pop    %ebp
  800cb4:	c3                   	ret    

00800cb5 <seek>:
	return (*dev->dev_write)(fd, buf, n);
}

int
seek(int fdnum, off_t offset)
{
  800cb5:	55                   	push   %ebp
  800cb6:	89 e5                	mov    %esp,%ebp
  800cb8:	83 ec 18             	sub    $0x18,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  800cbb:	8d 45 fc             	lea    -0x4(%ebp),%eax
  800cbe:	89 44 24 04          	mov    %eax,0x4(%esp)
  800cc2:	8b 45 08             	mov    0x8(%ebp),%eax
  800cc5:	89 04 24             	mov    %eax,(%esp)
  800cc8:	e8 a0 ff ff ff       	call   800c6d <fd_lookup>
  800ccd:	85 c0                	test   %eax,%eax
  800ccf:	78 0e                	js     800cdf <seek+0x2a>
		return r;
	fd->fd_offset = offset;
  800cd1:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800cd4:	8b 55 0c             	mov    0xc(%ebp),%edx
  800cd7:	89 50 04             	mov    %edx,0x4(%eax)
  800cda:	b8 00 00 00 00       	mov    $0x0,%eax
	return 0;
}
  800cdf:	c9                   	leave  
  800ce0:	c3                   	ret    

00800ce1 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  800ce1:	55                   	push   %ebp
  800ce2:	89 e5                	mov    %esp,%ebp
  800ce4:	56                   	push   %esi
  800ce5:	53                   	push   %ebx
  800ce6:	83 ec 10             	sub    $0x10,%esp
  800ce9:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800cec:	8b 5d 0c             	mov    0xc(%ebp),%ebx
// File functions
// --------------------------------------------------------------

static struct Dev *devtab[] =
{
	&devfile,
  800cef:	b8 04 70 80 00       	mov    $0x807004,%eax
{
	int i;
	for (i = 0; devtab[i]; i++)
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
  800cf4:	ba 00 00 00 00       	mov    $0x0,%edx

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  800cf9:	be 78 2e 80 00       	mov    $0x802e78,%esi
		if (devtab[i]->dev_id == dev_id) {
  800cfe:	39 08                	cmp    %ecx,(%eax)
  800d00:	75 10                	jne    800d12 <dev_lookup+0x31>
  800d02:	eb 04                	jmp    800d08 <dev_lookup+0x27>
  800d04:	39 08                	cmp    %ecx,(%eax)
  800d06:	75 0a                	jne    800d12 <dev_lookup+0x31>
			*dev = devtab[i];
  800d08:	89 03                	mov    %eax,(%ebx)
  800d0a:	b8 00 00 00 00       	mov    $0x0,%eax
			return 0;
  800d0f:	90                   	nop
  800d10:	eb 31                	jmp    800d43 <dev_lookup+0x62>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  800d12:	83 c2 01             	add    $0x1,%edx
  800d15:	8b 04 96             	mov    (%esi,%edx,4),%eax
  800d18:	85 c0                	test   %eax,%eax
  800d1a:	75 e8                	jne    800d04 <dev_lookup+0x23>
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", env->env_id, dev_id);
  800d1c:	a1 84 74 80 00       	mov    0x807484,%eax
  800d21:	8b 40 4c             	mov    0x4c(%eax),%eax
  800d24:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  800d28:	89 44 24 04          	mov    %eax,0x4(%esp)
  800d2c:	c7 04 24 fc 2d 80 00 	movl   $0x802dfc,(%esp)
  800d33:	e8 49 16 00 00       	call   802381 <cprintf>
	*dev = 0;
  800d38:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  800d3e:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
	return -E_INVAL;
}
  800d43:	83 c4 10             	add    $0x10,%esp
  800d46:	5b                   	pop    %ebx
  800d47:	5e                   	pop    %esi
  800d48:	5d                   	pop    %ebp
  800d49:	c3                   	ret    

00800d4a <fstat>:
	return (*dev->dev_trunc)(fd, newsize);
}

int
fstat(int fdnum, struct Stat *stat)
{
  800d4a:	55                   	push   %ebp
  800d4b:	89 e5                	mov    %esp,%ebp
  800d4d:	53                   	push   %ebx
  800d4e:	83 ec 24             	sub    $0x24,%esp
  800d51:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  800d54:	8d 45 f0             	lea    -0x10(%ebp),%eax
  800d57:	89 44 24 04          	mov    %eax,0x4(%esp)
  800d5b:	8b 45 08             	mov    0x8(%ebp),%eax
  800d5e:	89 04 24             	mov    %eax,(%esp)
  800d61:	e8 07 ff ff ff       	call   800c6d <fd_lookup>
  800d66:	85 c0                	test   %eax,%eax
  800d68:	78 53                	js     800dbd <fstat+0x73>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  800d6a:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800d6d:	89 44 24 04          	mov    %eax,0x4(%esp)
  800d71:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800d74:	8b 00                	mov    (%eax),%eax
  800d76:	89 04 24             	mov    %eax,(%esp)
  800d79:	e8 63 ff ff ff       	call   800ce1 <dev_lookup>
{
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  800d7e:	85 c0                	test   %eax,%eax
  800d80:	78 3b                	js     800dbd <fstat+0x73>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if (!dev->dev_stat)
  800d82:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  800d87:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800d8a:	83 7a 14 00          	cmpl   $0x0,0x14(%edx)
  800d8e:	74 2d                	je     800dbd <fstat+0x73>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  800d90:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  800d93:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  800d9a:	00 00 00 
	stat->st_isdir = 0;
  800d9d:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  800da4:	00 00 00 
	stat->st_dev = dev;
  800da7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800daa:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  800db0:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  800db4:	8b 55 f0             	mov    -0x10(%ebp),%edx
  800db7:	89 14 24             	mov    %edx,(%esp)
  800dba:	ff 50 14             	call   *0x14(%eax)
}
  800dbd:	83 c4 24             	add    $0x24,%esp
  800dc0:	5b                   	pop    %ebx
  800dc1:	5d                   	pop    %ebp
  800dc2:	c3                   	ret    

00800dc3 <ftruncate>:
	return 0;
}

int
ftruncate(int fdnum, off_t newsize)
{
  800dc3:	55                   	push   %ebp
  800dc4:	89 e5                	mov    %esp,%ebp
  800dc6:	53                   	push   %ebx
  800dc7:	83 ec 24             	sub    $0x24,%esp
  800dca:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  800dcd:	8d 45 f0             	lea    -0x10(%ebp),%eax
  800dd0:	89 44 24 04          	mov    %eax,0x4(%esp)
  800dd4:	89 1c 24             	mov    %ebx,(%esp)
  800dd7:	e8 91 fe ff ff       	call   800c6d <fd_lookup>
  800ddc:	85 c0                	test   %eax,%eax
  800dde:	78 5f                	js     800e3f <ftruncate+0x7c>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  800de0:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800de3:	89 44 24 04          	mov    %eax,0x4(%esp)
  800de7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800dea:	8b 00                	mov    (%eax),%eax
  800dec:	89 04 24             	mov    %eax,(%esp)
  800def:	e8 ed fe ff ff       	call   800ce1 <dev_lookup>
ftruncate(int fdnum, off_t newsize)
{
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  800df4:	85 c0                	test   %eax,%eax
  800df6:	78 47                	js     800e3f <ftruncate+0x7c>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  800df8:	8b 55 f0             	mov    -0x10(%ebp),%edx
  800dfb:	f6 42 08 03          	testb  $0x3,0x8(%edx)
  800dff:	75 23                	jne    800e24 <ftruncate+0x61>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			env->env_id, fdnum); 
  800e01:	a1 84 74 80 00       	mov    0x807484,%eax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  800e06:	8b 40 4c             	mov    0x4c(%eax),%eax
  800e09:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  800e0d:	89 44 24 04          	mov    %eax,0x4(%esp)
  800e11:	c7 04 24 1c 2e 80 00 	movl   $0x802e1c,(%esp)
  800e18:	e8 64 15 00 00       	call   802381 <cprintf>
  800e1d:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
			env->env_id, fdnum); 
		return -E_INVAL;
  800e22:	eb 1b                	jmp    800e3f <ftruncate+0x7c>
	}
	if (!dev->dev_trunc)
  800e24:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800e27:	8b 48 18             	mov    0x18(%eax),%ecx
  800e2a:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  800e2f:	85 c9                	test   %ecx,%ecx
  800e31:	74 0c                	je     800e3f <ftruncate+0x7c>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  800e33:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e36:	89 44 24 04          	mov    %eax,0x4(%esp)
  800e3a:	89 14 24             	mov    %edx,(%esp)
  800e3d:	ff d1                	call   *%ecx
}
  800e3f:	83 c4 24             	add    $0x24,%esp
  800e42:	5b                   	pop    %ebx
  800e43:	5d                   	pop    %ebp
  800e44:	c3                   	ret    

00800e45 <write>:
	return tot;
}

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  800e45:	55                   	push   %ebp
  800e46:	89 e5                	mov    %esp,%ebp
  800e48:	53                   	push   %ebx
  800e49:	83 ec 24             	sub    $0x24,%esp
  800e4c:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  800e4f:	8d 45 f0             	lea    -0x10(%ebp),%eax
  800e52:	89 44 24 04          	mov    %eax,0x4(%esp)
  800e56:	89 1c 24             	mov    %ebx,(%esp)
  800e59:	e8 0f fe ff ff       	call   800c6d <fd_lookup>
  800e5e:	85 c0                	test   %eax,%eax
  800e60:	78 66                	js     800ec8 <write+0x83>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  800e62:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800e65:	89 44 24 04          	mov    %eax,0x4(%esp)
  800e69:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800e6c:	8b 00                	mov    (%eax),%eax
  800e6e:	89 04 24             	mov    %eax,(%esp)
  800e71:	e8 6b fe ff ff       	call   800ce1 <dev_lookup>
{
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  800e76:	85 c0                	test   %eax,%eax
  800e78:	78 4e                	js     800ec8 <write+0x83>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  800e7a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  800e7d:	f6 42 08 03          	testb  $0x3,0x8(%edx)
  800e81:	75 23                	jne    800ea6 <write+0x61>
		cprintf("[%08x] write %d -- bad mode\n", env->env_id, fdnum);
  800e83:	a1 84 74 80 00       	mov    0x807484,%eax
  800e88:	8b 40 4c             	mov    0x4c(%eax),%eax
  800e8b:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  800e8f:	89 44 24 04          	mov    %eax,0x4(%esp)
  800e93:	c7 04 24 3d 2e 80 00 	movl   $0x802e3d,(%esp)
  800e9a:	e8 e2 14 00 00       	call   802381 <cprintf>
  800e9f:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
		return -E_INVAL;
  800ea4:	eb 22                	jmp    800ec8 <write+0x83>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  800ea6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800ea9:	8b 48 0c             	mov    0xc(%eax),%ecx
  800eac:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  800eb1:	85 c9                	test   %ecx,%ecx
  800eb3:	74 13                	je     800ec8 <write+0x83>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  800eb5:	8b 45 10             	mov    0x10(%ebp),%eax
  800eb8:	89 44 24 08          	mov    %eax,0x8(%esp)
  800ebc:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ebf:	89 44 24 04          	mov    %eax,0x4(%esp)
  800ec3:	89 14 24             	mov    %edx,(%esp)
  800ec6:	ff d1                	call   *%ecx
}
  800ec8:	83 c4 24             	add    $0x24,%esp
  800ecb:	5b                   	pop    %ebx
  800ecc:	5d                   	pop    %ebp
  800ecd:	c3                   	ret    

00800ece <read>:
	return r;
}

ssize_t
read(int fdnum, void *buf, size_t n)
{
  800ece:	55                   	push   %ebp
  800ecf:	89 e5                	mov    %esp,%ebp
  800ed1:	53                   	push   %ebx
  800ed2:	83 ec 24             	sub    $0x24,%esp
  800ed5:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  800ed8:	8d 45 f0             	lea    -0x10(%ebp),%eax
  800edb:	89 44 24 04          	mov    %eax,0x4(%esp)
  800edf:	89 1c 24             	mov    %ebx,(%esp)
  800ee2:	e8 86 fd ff ff       	call   800c6d <fd_lookup>
  800ee7:	85 c0                	test   %eax,%eax
  800ee9:	78 6b                	js     800f56 <read+0x88>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  800eeb:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800eee:	89 44 24 04          	mov    %eax,0x4(%esp)
  800ef2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800ef5:	8b 00                	mov    (%eax),%eax
  800ef7:	89 04 24             	mov    %eax,(%esp)
  800efa:	e8 e2 fd ff ff       	call   800ce1 <dev_lookup>
{
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  800eff:	85 c0                	test   %eax,%eax
  800f01:	78 53                	js     800f56 <read+0x88>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  800f03:	8b 55 f0             	mov    -0x10(%ebp),%edx
  800f06:	8b 42 08             	mov    0x8(%edx),%eax
  800f09:	83 e0 03             	and    $0x3,%eax
  800f0c:	83 f8 01             	cmp    $0x1,%eax
  800f0f:	75 23                	jne    800f34 <read+0x66>
		cprintf("[%08x] read %d -- bad mode\n", env->env_id, fdnum); 
  800f11:	a1 84 74 80 00       	mov    0x807484,%eax
  800f16:	8b 40 4c             	mov    0x4c(%eax),%eax
  800f19:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  800f1d:	89 44 24 04          	mov    %eax,0x4(%esp)
  800f21:	c7 04 24 5a 2e 80 00 	movl   $0x802e5a,(%esp)
  800f28:	e8 54 14 00 00       	call   802381 <cprintf>
  800f2d:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
		return -E_INVAL;
  800f32:	eb 22                	jmp    800f56 <read+0x88>
	}
	if (!dev->dev_read)
  800f34:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800f37:	8b 48 08             	mov    0x8(%eax),%ecx
  800f3a:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  800f3f:	85 c9                	test   %ecx,%ecx
  800f41:	74 13                	je     800f56 <read+0x88>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  800f43:	8b 45 10             	mov    0x10(%ebp),%eax
  800f46:	89 44 24 08          	mov    %eax,0x8(%esp)
  800f4a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f4d:	89 44 24 04          	mov    %eax,0x4(%esp)
  800f51:	89 14 24             	mov    %edx,(%esp)
  800f54:	ff d1                	call   *%ecx
}
  800f56:	83 c4 24             	add    $0x24,%esp
  800f59:	5b                   	pop    %ebx
  800f5a:	5d                   	pop    %ebp
  800f5b:	c3                   	ret    

00800f5c <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  800f5c:	55                   	push   %ebp
  800f5d:	89 e5                	mov    %esp,%ebp
  800f5f:	57                   	push   %edi
  800f60:	56                   	push   %esi
  800f61:	53                   	push   %ebx
  800f62:	83 ec 1c             	sub    $0x1c,%esp
  800f65:	8b 7d 08             	mov    0x8(%ebp),%edi
  800f68:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  800f6b:	ba 00 00 00 00       	mov    $0x0,%edx
  800f70:	bb 00 00 00 00       	mov    $0x0,%ebx
  800f75:	b8 00 00 00 00       	mov    $0x0,%eax
  800f7a:	85 f6                	test   %esi,%esi
  800f7c:	74 29                	je     800fa7 <readn+0x4b>
		m = read(fdnum, (char*)buf + tot, n - tot);
  800f7e:	89 f0                	mov    %esi,%eax
  800f80:	29 d0                	sub    %edx,%eax
  800f82:	89 44 24 08          	mov    %eax,0x8(%esp)
  800f86:	03 55 0c             	add    0xc(%ebp),%edx
  800f89:	89 54 24 04          	mov    %edx,0x4(%esp)
  800f8d:	89 3c 24             	mov    %edi,(%esp)
  800f90:	e8 39 ff ff ff       	call   800ece <read>
		if (m < 0)
  800f95:	85 c0                	test   %eax,%eax
  800f97:	78 0e                	js     800fa7 <readn+0x4b>
			return m;
		if (m == 0)
  800f99:	85 c0                	test   %eax,%eax
  800f9b:	74 08                	je     800fa5 <readn+0x49>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  800f9d:	01 c3                	add    %eax,%ebx
  800f9f:	89 da                	mov    %ebx,%edx
  800fa1:	39 f3                	cmp    %esi,%ebx
  800fa3:	72 d9                	jb     800f7e <readn+0x22>
  800fa5:	89 d8                	mov    %ebx,%eax
			return m;
		if (m == 0)
			break;
	}
	return tot;
}
  800fa7:	83 c4 1c             	add    $0x1c,%esp
  800faa:	5b                   	pop    %ebx
  800fab:	5e                   	pop    %esi
  800fac:	5f                   	pop    %edi
  800fad:	5d                   	pop    %ebp
  800fae:	c3                   	ret    

00800faf <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  800faf:	55                   	push   %ebp
  800fb0:	89 e5                	mov    %esp,%ebp
  800fb2:	56                   	push   %esi
  800fb3:	53                   	push   %ebx
  800fb4:	83 ec 20             	sub    $0x20,%esp
  800fb7:	8b 75 08             	mov    0x8(%ebp),%esi
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  800fba:	89 34 24             	mov    %esi,(%esp)
  800fbd:	e8 0e fc ff ff       	call   800bd0 <fd2num>
  800fc2:	8d 55 f4             	lea    -0xc(%ebp),%edx
  800fc5:	89 54 24 04          	mov    %edx,0x4(%esp)
  800fc9:	89 04 24             	mov    %eax,(%esp)
  800fcc:	e8 9c fc ff ff       	call   800c6d <fd_lookup>
  800fd1:	89 c3                	mov    %eax,%ebx
  800fd3:	85 c0                	test   %eax,%eax
  800fd5:	78 05                	js     800fdc <fd_close+0x2d>
  800fd7:	3b 75 f4             	cmp    -0xc(%ebp),%esi
  800fda:	74 0c                	je     800fe8 <fd_close+0x39>
	    || fd != fd2)
		return (must_exist ? r : 0);
  800fdc:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800fe0:	19 c0                	sbb    %eax,%eax
  800fe2:	f7 d0                	not    %eax
  800fe4:	21 c3                	and    %eax,%ebx
  800fe6:	eb 3d                	jmp    801025 <fd_close+0x76>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  800fe8:	8d 45 f0             	lea    -0x10(%ebp),%eax
  800feb:	89 44 24 04          	mov    %eax,0x4(%esp)
  800fef:	8b 06                	mov    (%esi),%eax
  800ff1:	89 04 24             	mov    %eax,(%esp)
  800ff4:	e8 e8 fc ff ff       	call   800ce1 <dev_lookup>
  800ff9:	89 c3                	mov    %eax,%ebx
  800ffb:	85 c0                	test   %eax,%eax
  800ffd:	78 16                	js     801015 <fd_close+0x66>
		if (dev->dev_close)
  800fff:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801002:	8b 40 10             	mov    0x10(%eax),%eax
  801005:	bb 00 00 00 00       	mov    $0x0,%ebx
  80100a:	85 c0                	test   %eax,%eax
  80100c:	74 07                	je     801015 <fd_close+0x66>
			r = (*dev->dev_close)(fd);
  80100e:	89 34 24             	mov    %esi,(%esp)
  801011:	ff d0                	call   *%eax
  801013:	89 c3                	mov    %eax,%ebx
		else
			r = 0;
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  801015:	89 74 24 04          	mov    %esi,0x4(%esp)
  801019:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801020:	e8 ca f9 ff ff       	call   8009ef <sys_page_unmap>
	return r;
}
  801025:	89 d8                	mov    %ebx,%eax
  801027:	83 c4 20             	add    $0x20,%esp
  80102a:	5b                   	pop    %ebx
  80102b:	5e                   	pop    %esi
  80102c:	5d                   	pop    %ebp
  80102d:	c3                   	ret    

0080102e <close>:
	return -E_INVAL;
}

int
close(int fdnum)
{
  80102e:	55                   	push   %ebp
  80102f:	89 e5                	mov    %esp,%ebp
  801031:	83 ec 28             	sub    $0x28,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801034:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801037:	89 44 24 04          	mov    %eax,0x4(%esp)
  80103b:	8b 45 08             	mov    0x8(%ebp),%eax
  80103e:	89 04 24             	mov    %eax,(%esp)
  801041:	e8 27 fc ff ff       	call   800c6d <fd_lookup>
  801046:	85 c0                	test   %eax,%eax
  801048:	78 13                	js     80105d <close+0x2f>
		return r;
	else
		return fd_close(fd, 1);
  80104a:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  801051:	00 
  801052:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801055:	89 04 24             	mov    %eax,(%esp)
  801058:	e8 52 ff ff ff       	call   800faf <fd_close>
}
  80105d:	c9                   	leave  
  80105e:	c3                   	ret    

0080105f <stat>:
	return (*dev->dev_stat)(fd, stat);
}

int
stat(const char *path, struct Stat *stat)
{
  80105f:	55                   	push   %ebp
  801060:	89 e5                	mov    %esp,%ebp
  801062:	83 ec 18             	sub    $0x18,%esp
  801065:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  801068:	89 75 fc             	mov    %esi,-0x4(%ebp)
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  80106b:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  801072:	00 
  801073:	8b 45 08             	mov    0x8(%ebp),%eax
  801076:	89 04 24             	mov    %eax,(%esp)
  801079:	e8 55 03 00 00       	call   8013d3 <open>
  80107e:	89 c3                	mov    %eax,%ebx
  801080:	85 c0                	test   %eax,%eax
  801082:	78 1b                	js     80109f <stat+0x40>
		return fd;
	r = fstat(fd, stat);
  801084:	8b 45 0c             	mov    0xc(%ebp),%eax
  801087:	89 44 24 04          	mov    %eax,0x4(%esp)
  80108b:	89 1c 24             	mov    %ebx,(%esp)
  80108e:	e8 b7 fc ff ff       	call   800d4a <fstat>
  801093:	89 c6                	mov    %eax,%esi
	close(fd);
  801095:	89 1c 24             	mov    %ebx,(%esp)
  801098:	e8 91 ff ff ff       	call   80102e <close>
  80109d:	89 f3                	mov    %esi,%ebx
	return r;
}
  80109f:	89 d8                	mov    %ebx,%eax
  8010a1:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  8010a4:	8b 75 fc             	mov    -0x4(%ebp),%esi
  8010a7:	89 ec                	mov    %ebp,%esp
  8010a9:	5d                   	pop    %ebp
  8010aa:	c3                   	ret    

008010ab <close_all>:
		return fd_close(fd, 1);
}

void
close_all(void)
{
  8010ab:	55                   	push   %ebp
  8010ac:	89 e5                	mov    %esp,%ebp
  8010ae:	53                   	push   %ebx
  8010af:	83 ec 14             	sub    $0x14,%esp
  8010b2:	bb 00 00 00 00       	mov    $0x0,%ebx
	int i;
	for (i = 0; i < MAXFD; i++)
		close(i);
  8010b7:	89 1c 24             	mov    %ebx,(%esp)
  8010ba:	e8 6f ff ff ff       	call   80102e <close>

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  8010bf:	83 c3 01             	add    $0x1,%ebx
  8010c2:	83 fb 20             	cmp    $0x20,%ebx
  8010c5:	75 f0                	jne    8010b7 <close_all+0xc>
		close(i);
}
  8010c7:	83 c4 14             	add    $0x14,%esp
  8010ca:	5b                   	pop    %ebx
  8010cb:	5d                   	pop    %ebp
  8010cc:	c3                   	ret    

008010cd <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  8010cd:	55                   	push   %ebp
  8010ce:	89 e5                	mov    %esp,%ebp
  8010d0:	83 ec 58             	sub    $0x58,%esp
  8010d3:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  8010d6:	89 75 f8             	mov    %esi,-0x8(%ebp)
  8010d9:	89 7d fc             	mov    %edi,-0x4(%ebp)
  8010dc:	8b 7d 0c             	mov    0xc(%ebp),%edi
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  8010df:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  8010e2:	89 44 24 04          	mov    %eax,0x4(%esp)
  8010e6:	8b 45 08             	mov    0x8(%ebp),%eax
  8010e9:	89 04 24             	mov    %eax,(%esp)
  8010ec:	e8 7c fb ff ff       	call   800c6d <fd_lookup>
  8010f1:	89 c3                	mov    %eax,%ebx
  8010f3:	85 c0                	test   %eax,%eax
  8010f5:	0f 88 e0 00 00 00    	js     8011db <dup+0x10e>
		return r;
	close(newfdnum);
  8010fb:	89 3c 24             	mov    %edi,(%esp)
  8010fe:	e8 2b ff ff ff       	call   80102e <close>

	newfd = INDEX2FD(newfdnum);
  801103:	8d b7 00 00 0d 00    	lea    0xd0000(%edi),%esi
  801109:	c1 e6 0c             	shl    $0xc,%esi
	ova = fd2data(oldfd);
  80110c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80110f:	89 04 24             	mov    %eax,(%esp)
  801112:	e8 c9 fa ff ff       	call   800be0 <fd2data>
  801117:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  801119:	89 34 24             	mov    %esi,(%esp)
  80111c:	e8 bf fa ff ff       	call   800be0 <fd2data>
  801121:	89 45 d4             	mov    %eax,-0x2c(%ebp)

	if ((vpd[PDX(ova)] & PTE_P) && (vpt[VPN(ova)] & PTE_P))
  801124:	89 da                	mov    %ebx,%edx
  801126:	89 d8                	mov    %ebx,%eax
  801128:	c1 e8 16             	shr    $0x16,%eax
  80112b:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801132:	a8 01                	test   $0x1,%al
  801134:	74 43                	je     801179 <dup+0xac>
  801136:	c1 ea 0c             	shr    $0xc,%edx
  801139:	8b 04 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%eax
  801140:	a8 01                	test   $0x1,%al
  801142:	74 35                	je     801179 <dup+0xac>
		if ((r = sys_page_map(0, ova, 0, nva, vpt[VPN(ova)] & PTE_USER)) < 0)
  801144:	8b 04 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%eax
  80114b:	25 07 0e 00 00       	and    $0xe07,%eax
  801150:	89 44 24 10          	mov    %eax,0x10(%esp)
  801154:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801157:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80115b:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801162:	00 
  801163:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801167:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80116e:	e8 da f8 ff ff       	call   800a4d <sys_page_map>
  801173:	89 c3                	mov    %eax,%ebx
  801175:	85 c0                	test   %eax,%eax
  801177:	78 3f                	js     8011b8 <dup+0xeb>
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, vpt[VPN(oldfd)] & PTE_USER)) < 0)
  801179:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80117c:	89 c2                	mov    %eax,%edx
  80117e:	c1 ea 0c             	shr    $0xc,%edx
  801181:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801188:	81 e2 07 0e 00 00    	and    $0xe07,%edx
  80118e:	89 54 24 10          	mov    %edx,0x10(%esp)
  801192:	89 74 24 0c          	mov    %esi,0xc(%esp)
  801196:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  80119d:	00 
  80119e:	89 44 24 04          	mov    %eax,0x4(%esp)
  8011a2:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8011a9:	e8 9f f8 ff ff       	call   800a4d <sys_page_map>
  8011ae:	89 c3                	mov    %eax,%ebx
  8011b0:	85 c0                	test   %eax,%eax
  8011b2:	78 04                	js     8011b8 <dup+0xeb>
  8011b4:	89 fb                	mov    %edi,%ebx
  8011b6:	eb 23                	jmp    8011db <dup+0x10e>
		goto err;

	return newfdnum;

err:
	sys_page_unmap(0, newfd);
  8011b8:	89 74 24 04          	mov    %esi,0x4(%esp)
  8011bc:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8011c3:	e8 27 f8 ff ff       	call   8009ef <sys_page_unmap>
	sys_page_unmap(0, nva);
  8011c8:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8011cb:	89 44 24 04          	mov    %eax,0x4(%esp)
  8011cf:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8011d6:	e8 14 f8 ff ff       	call   8009ef <sys_page_unmap>
	return r;
}
  8011db:	89 d8                	mov    %ebx,%eax
  8011dd:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  8011e0:	8b 75 f8             	mov    -0x8(%ebp),%esi
  8011e3:	8b 7d fc             	mov    -0x4(%ebp),%edi
  8011e6:	89 ec                	mov    %ebp,%esp
  8011e8:	5d                   	pop    %ebp
  8011e9:	c3                   	ret    
	...

008011ec <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  8011ec:	55                   	push   %ebp
  8011ed:	89 e5                	mov    %esp,%ebp
  8011ef:	53                   	push   %ebx
  8011f0:	83 ec 14             	sub    $0x14,%esp
  8011f3:	89 d3                	mov    %edx,%ebx
	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", env->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(envs[1].env_id, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  8011f5:	8b 15 c8 00 c0 ee    	mov    0xeec000c8,%edx
  8011fb:	c7 44 24 0c 07 00 00 	movl   $0x7,0xc(%esp)
  801202:	00 
  801203:	c7 44 24 08 00 40 80 	movl   $0x804000,0x8(%esp)
  80120a:	00 
  80120b:	89 44 24 04          	mov    %eax,0x4(%esp)
  80120f:	89 14 24             	mov    %edx,(%esp)
  801212:	e8 d9 17 00 00       	call   8029f0 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  801217:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  80121e:	00 
  80121f:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801223:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80122a:	e8 27 18 00 00       	call   802a56 <ipc_recv>
}
  80122f:	83 c4 14             	add    $0x14,%esp
  801232:	5b                   	pop    %ebx
  801233:	5d                   	pop    %ebp
  801234:	c3                   	ret    

00801235 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  801235:	55                   	push   %ebp
  801236:	89 e5                	mov    %esp,%ebp
  801238:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  80123b:	8b 45 08             	mov    0x8(%ebp),%eax
  80123e:	8b 40 0c             	mov    0xc(%eax),%eax
  801241:	a3 00 40 80 00       	mov    %eax,0x804000
	fsipcbuf.set_size.req_size = newsize;
  801246:	8b 45 0c             	mov    0xc(%ebp),%eax
  801249:	a3 04 40 80 00       	mov    %eax,0x804004
	return fsipc(FSREQ_SET_SIZE, NULL);
  80124e:	ba 00 00 00 00       	mov    $0x0,%edx
  801253:	b8 02 00 00 00       	mov    $0x2,%eax
  801258:	e8 8f ff ff ff       	call   8011ec <fsipc>
}
  80125d:	c9                   	leave  
  80125e:	c3                   	ret    

0080125f <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  80125f:	55                   	push   %ebp
  801260:	89 e5                	mov    %esp,%ebp
  801262:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  801265:	8b 45 08             	mov    0x8(%ebp),%eax
  801268:	8b 40 0c             	mov    0xc(%eax),%eax
  80126b:	a3 00 40 80 00       	mov    %eax,0x804000
	return fsipc(FSREQ_FLUSH, NULL);
  801270:	ba 00 00 00 00       	mov    $0x0,%edx
  801275:	b8 06 00 00 00       	mov    $0x6,%eax
  80127a:	e8 6d ff ff ff       	call   8011ec <fsipc>
}
  80127f:	c9                   	leave  
  801280:	c3                   	ret    

00801281 <sync>:
}

// Synchronize disk with buffer cache
int
sync(void)
{
  801281:	55                   	push   %ebp
  801282:	89 e5                	mov    %esp,%ebp
  801284:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  801287:	ba 00 00 00 00       	mov    $0x0,%edx
  80128c:	b8 08 00 00 00       	mov    $0x8,%eax
  801291:	e8 56 ff ff ff       	call   8011ec <fsipc>
}
  801296:	c9                   	leave  
  801297:	c3                   	ret    

00801298 <devfile_stat>:
	return fsipc(FSREQ_WRITE, NULL);	
}

static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  801298:	55                   	push   %ebp
  801299:	89 e5                	mov    %esp,%ebp
  80129b:	53                   	push   %ebx
  80129c:	83 ec 14             	sub    $0x14,%esp
  80129f:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  8012a2:	8b 45 08             	mov    0x8(%ebp),%eax
  8012a5:	8b 40 0c             	mov    0xc(%eax),%eax
  8012a8:	a3 00 40 80 00       	mov    %eax,0x804000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  8012ad:	ba 00 00 00 00       	mov    $0x0,%edx
  8012b2:	b8 05 00 00 00       	mov    $0x5,%eax
  8012b7:	e8 30 ff ff ff       	call   8011ec <fsipc>
  8012bc:	85 c0                	test   %eax,%eax
  8012be:	78 2b                	js     8012eb <devfile_stat+0x53>
		return r;
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  8012c0:	c7 44 24 04 00 40 80 	movl   $0x804000,0x4(%esp)
  8012c7:	00 
  8012c8:	89 1c 24             	mov    %ebx,(%esp)
  8012cb:	e8 ea ef ff ff       	call   8002ba <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  8012d0:	a1 80 40 80 00       	mov    0x804080,%eax
  8012d5:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  8012db:	a1 84 40 80 00       	mov    0x804084,%eax
  8012e0:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
  8012e6:	b8 00 00 00 00       	mov    $0x0,%eax
	return 0;
}
  8012eb:	83 c4 14             	add    $0x14,%esp
  8012ee:	5b                   	pop    %ebx
  8012ef:	5d                   	pop    %ebp
  8012f0:	c3                   	ret    

008012f1 <devfile_write>:
// Returns:
//	 The number of bytes successfully written.
//	 < 0 on error.
static ssize_t
devfile_write(struct Fd *fd, const void *buf, size_t n)
{
  8012f1:	55                   	push   %ebp
  8012f2:	89 e5                	mov    %esp,%ebp
  8012f4:	83 ec 18             	sub    $0x18,%esp
  8012f7:	8b 45 10             	mov    0x10(%ebp),%eax
  8012fa:	3d f8 0f 00 00       	cmp    $0xff8,%eax
  8012ff:	76 05                	jbe    801306 <devfile_write+0x15>
  801301:	b8 f8 0f 00 00       	mov    $0xff8,%eax
	// LAB 5: Your code here
	//panic("devfile_write not implemented");
	
	if (n > (PGSIZE - (sizeof(int) + sizeof(size_t))))
		n = PGSIZE - (sizeof(int) + sizeof(size_t));
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  801306:	8b 55 08             	mov    0x8(%ebp),%edx
  801309:	8b 52 0c             	mov    0xc(%edx),%edx
  80130c:	89 15 00 40 80 00    	mov    %edx,0x804000
	fsipcbuf.write.req_n = n;
  801312:	a3 04 40 80 00       	mov    %eax,0x804004
	memmove (fsipcbuf.write.req_buf, (char*)buf, n);	
  801317:	89 44 24 08          	mov    %eax,0x8(%esp)
  80131b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80131e:	89 44 24 04          	mov    %eax,0x4(%esp)
  801322:	c7 04 24 08 40 80 00 	movl   $0x804008,(%esp)
  801329:	e8 47 f1 ff ff       	call   800475 <memmove>
	return fsipc(FSREQ_WRITE, NULL);	
  80132e:	ba 00 00 00 00       	mov    $0x0,%edx
  801333:	b8 04 00 00 00       	mov    $0x4,%eax
  801338:	e8 af fe ff ff       	call   8011ec <fsipc>
}
  80133d:	c9                   	leave  
  80133e:	c3                   	ret    

0080133f <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  80133f:	55                   	push   %ebp
  801340:	89 e5                	mov    %esp,%ebp
  801342:	53                   	push   %ebx
  801343:	83 ec 14             	sub    $0x14,%esp
	// system server.
	// LAB 5: Your code here
	
	//panic("devfile_read not implemented");
	int r;
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  801346:	8b 45 08             	mov    0x8(%ebp),%eax
  801349:	8b 40 0c             	mov    0xc(%eax),%eax
  80134c:	a3 00 40 80 00       	mov    %eax,0x804000
	fsipcbuf.read.req_n = n;
  801351:	8b 45 10             	mov    0x10(%ebp),%eax
  801354:	a3 04 40 80 00       	mov    %eax,0x804004
	if ((r = fsipc(FSREQ_READ, (void*)&fsipcbuf)) < 0)
  801359:	ba 00 40 80 00       	mov    $0x804000,%edx
  80135e:	b8 03 00 00 00       	mov    $0x3,%eax
  801363:	e8 84 fe ff ff       	call   8011ec <fsipc>
  801368:	89 c3                	mov    %eax,%ebx
  80136a:	85 c0                	test   %eax,%eax
  80136c:	78 17                	js     801385 <devfile_read+0x46>
		return r;
	memmove((void*)buf, (void*)fsipcbuf.readRet.ret_buf, r);
  80136e:	89 44 24 08          	mov    %eax,0x8(%esp)
  801372:	c7 44 24 04 00 40 80 	movl   $0x804000,0x4(%esp)
  801379:	00 
  80137a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80137d:	89 04 24             	mov    %eax,(%esp)
  801380:	e8 f0 f0 ff ff       	call   800475 <memmove>
	return r;
}
  801385:	89 d8                	mov    %ebx,%eax
  801387:	83 c4 14             	add    $0x14,%esp
  80138a:	5b                   	pop    %ebx
  80138b:	5d                   	pop    %ebp
  80138c:	c3                   	ret    

0080138d <remove>:
}

// Delete a file
int
remove(const char *path)
{
  80138d:	55                   	push   %ebp
  80138e:	89 e5                	mov    %esp,%ebp
  801390:	53                   	push   %ebx
  801391:	83 ec 14             	sub    $0x14,%esp
  801394:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (strlen(path) >= MAXPATHLEN)
  801397:	89 1c 24             	mov    %ebx,(%esp)
  80139a:	e8 d1 ee ff ff       	call   800270 <strlen>
  80139f:	89 c2                	mov    %eax,%edx
  8013a1:	b8 f4 ff ff ff       	mov    $0xfffffff4,%eax
  8013a6:	81 fa ff 03 00 00    	cmp    $0x3ff,%edx
  8013ac:	7f 1f                	jg     8013cd <remove+0x40>
		return -E_BAD_PATH;
	strcpy(fsipcbuf.remove.req_path, path);
  8013ae:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8013b2:	c7 04 24 00 40 80 00 	movl   $0x804000,(%esp)
  8013b9:	e8 fc ee ff ff       	call   8002ba <strcpy>
	return fsipc(FSREQ_REMOVE, NULL);
  8013be:	ba 00 00 00 00       	mov    $0x0,%edx
  8013c3:	b8 07 00 00 00       	mov    $0x7,%eax
  8013c8:	e8 1f fe ff ff       	call   8011ec <fsipc>
}
  8013cd:	83 c4 14             	add    $0x14,%esp
  8013d0:	5b                   	pop    %ebx
  8013d1:	5d                   	pop    %ebp
  8013d2:	c3                   	ret    

008013d3 <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  8013d3:	55                   	push   %ebp
  8013d4:	89 e5                	mov    %esp,%ebp
  8013d6:	83 ec 28             	sub    $0x28,%esp
  8013d9:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  8013dc:	89 75 fc             	mov    %esi,-0x4(%ebp)
  8013df:	8b 75 08             	mov    0x8(%ebp),%esi
	// file descriptor.

	// LAB 5: Your code here.
	// Code added by Swastika / Sandeep
	
	if (strlen(path) >= MAXPATHLEN)
  8013e2:	89 34 24             	mov    %esi,(%esp)
  8013e5:	e8 86 ee ff ff       	call   800270 <strlen>
  8013ea:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  8013ef:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  8013f4:	7f 5e                	jg     801454 <open+0x81>
		return -E_BAD_PATH;
	struct Fd * fd;
	int  r;
	if ((r = fd_alloc(&fd)) < 0)
  8013f6:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8013f9:	89 04 24             	mov    %eax,(%esp)
  8013fc:	e8 fa f7 ff ff       	call   800bfb <fd_alloc>
  801401:	89 c3                	mov    %eax,%ebx
  801403:	85 c0                	test   %eax,%eax
  801405:	78 4d                	js     801454 <open+0x81>
		return r;
	strcpy (fsipcbuf.open.req_path, path);
  801407:	89 74 24 04          	mov    %esi,0x4(%esp)
  80140b:	c7 04 24 00 40 80 00 	movl   $0x804000,(%esp)
  801412:	e8 a3 ee ff ff       	call   8002ba <strcpy>
	fsipcbuf.open.req_omode = mode;	
  801417:	8b 45 0c             	mov    0xc(%ebp),%eax
  80141a:	a3 00 44 80 00       	mov    %eax,0x804400
	if ((r = fsipc(FSREQ_OPEN,(void*)fd)) < 0)
  80141f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801422:	b8 01 00 00 00       	mov    $0x1,%eax
  801427:	e8 c0 fd ff ff       	call   8011ec <fsipc>
  80142c:	89 c3                	mov    %eax,%ebx
  80142e:	85 c0                	test   %eax,%eax
  801430:	79 15                	jns    801447 <open+0x74>
	{
		fd_close(fd,0);
  801432:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  801439:	00 
  80143a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80143d:	89 04 24             	mov    %eax,(%esp)
  801440:	e8 6a fb ff ff       	call   800faf <fd_close>
		return r; 
  801445:	eb 0d                	jmp    801454 <open+0x81>
	}
	return fd2num(fd);
  801447:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80144a:	89 04 24             	mov    %eax,(%esp)
  80144d:	e8 7e f7 ff ff       	call   800bd0 <fd2num>
  801452:	89 c3                	mov    %eax,%ebx
	//panic("open not implemented");
}
  801454:	89 d8                	mov    %ebx,%eax
  801456:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  801459:	8b 75 fc             	mov    -0x4(%ebp),%esi
  80145c:	89 ec                	mov    %ebp,%esp
  80145e:	5d                   	pop    %ebp
  80145f:	c3                   	ret    

00801460 <writebuf>:
};


static void
writebuf(struct printbuf *b)
{
  801460:	55                   	push   %ebp
  801461:	89 e5                	mov    %esp,%ebp
  801463:	53                   	push   %ebx
  801464:	83 ec 14             	sub    $0x14,%esp
  801467:	89 c3                	mov    %eax,%ebx
	if (b->error > 0) {
  801469:	83 78 0c 00          	cmpl   $0x0,0xc(%eax)
  80146d:	7e 34                	jle    8014a3 <writebuf+0x43>
		ssize_t result = write(b->fd, b->buf, b->idx);
  80146f:	8b 40 04             	mov    0x4(%eax),%eax
  801472:	89 44 24 08          	mov    %eax,0x8(%esp)
  801476:	8d 43 10             	lea    0x10(%ebx),%eax
  801479:	89 44 24 04          	mov    %eax,0x4(%esp)
  80147d:	8b 03                	mov    (%ebx),%eax
  80147f:	89 04 24             	mov    %eax,(%esp)
  801482:	e8 be f9 ff ff       	call   800e45 <write>
		if (result > 0)
  801487:	85 c0                	test   %eax,%eax
  801489:	7e 03                	jle    80148e <writebuf+0x2e>
			b->result += result;
  80148b:	01 43 08             	add    %eax,0x8(%ebx)
		if (result != b->idx) // error, or wrote less than supplied
  80148e:	3b 43 04             	cmp    0x4(%ebx),%eax
  801491:	74 10                	je     8014a3 <writebuf+0x43>
			b->error = (result < 0 ? result : 0);
  801493:	85 c0                	test   %eax,%eax
  801495:	0f 9f c2             	setg   %dl
  801498:	0f b6 d2             	movzbl %dl,%edx
  80149b:	83 ea 01             	sub    $0x1,%edx
  80149e:	21 d0                	and    %edx,%eax
  8014a0:	89 43 0c             	mov    %eax,0xc(%ebx)
	}
}
  8014a3:	83 c4 14             	add    $0x14,%esp
  8014a6:	5b                   	pop    %ebx
  8014a7:	5d                   	pop    %ebp
  8014a8:	c3                   	ret    

008014a9 <vfprintf>:
	}
}

int
vfprintf(int fd, const char *fmt, va_list ap)
{
  8014a9:	55                   	push   %ebp
  8014aa:	89 e5                	mov    %esp,%ebp
  8014ac:	81 ec 28 01 00 00    	sub    $0x128,%esp
	struct printbuf b;

	b.fd = fd;
  8014b2:	8b 45 08             	mov    0x8(%ebp),%eax
  8014b5:	89 85 e8 fe ff ff    	mov    %eax,-0x118(%ebp)
	b.idx = 0;
  8014bb:	c7 85 ec fe ff ff 00 	movl   $0x0,-0x114(%ebp)
  8014c2:	00 00 00 
	b.result = 0;
  8014c5:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8014cc:	00 00 00 
	b.error = 1;
  8014cf:	c7 85 f4 fe ff ff 01 	movl   $0x1,-0x10c(%ebp)
  8014d6:	00 00 00 
	vprintfmt(putch, &b, fmt, ap);
  8014d9:	8b 45 10             	mov    0x10(%ebp),%eax
  8014dc:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8014e0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014e3:	89 44 24 08          	mov    %eax,0x8(%esp)
  8014e7:	8d 85 e8 fe ff ff    	lea    -0x118(%ebp),%eax
  8014ed:	89 44 24 04          	mov    %eax,0x4(%esp)
  8014f1:	c7 04 24 66 15 80 00 	movl   $0x801566,(%esp)
  8014f8:	e8 30 10 00 00       	call   80252d <vprintfmt>
	if (b.idx > 0)
  8014fd:	83 bd ec fe ff ff 00 	cmpl   $0x0,-0x114(%ebp)
  801504:	7e 0b                	jle    801511 <vfprintf+0x68>
		writebuf(&b);
  801506:	8d 85 e8 fe ff ff    	lea    -0x118(%ebp),%eax
  80150c:	e8 4f ff ff ff       	call   801460 <writebuf>

	return (b.result ? b.result : b.error);
  801511:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
  801517:	85 c0                	test   %eax,%eax
  801519:	75 06                	jne    801521 <vfprintf+0x78>
  80151b:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  801521:	c9                   	leave  
  801522:	c3                   	ret    

00801523 <printf>:
	return cnt;
}

int
printf(const char *fmt, ...)
{
  801523:	55                   	push   %ebp
  801524:	89 e5                	mov    %esp,%ebp
  801526:	83 ec 18             	sub    $0x18,%esp

	return cnt;
}

int
printf(const char *fmt, ...)
  801529:	8d 45 0c             	lea    0xc(%ebp),%eax
{
	va_list ap;
	int cnt;

	va_start(ap, fmt);
	cnt = vfprintf(1, fmt, ap);
  80152c:	89 44 24 08          	mov    %eax,0x8(%esp)
  801530:	8b 45 08             	mov    0x8(%ebp),%eax
  801533:	89 44 24 04          	mov    %eax,0x4(%esp)
  801537:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  80153e:	e8 66 ff ff ff       	call   8014a9 <vfprintf>
	va_end(ap);

	return cnt;
}
  801543:	c9                   	leave  
  801544:	c3                   	ret    

00801545 <fprintf>:
	return (b.result ? b.result : b.error);
}

int
fprintf(int fd, const char *fmt, ...)
{
  801545:	55                   	push   %ebp
  801546:	89 e5                	mov    %esp,%ebp
  801548:	83 ec 18             	sub    $0x18,%esp

	return (b.result ? b.result : b.error);
}

int
fprintf(int fd, const char *fmt, ...)
  80154b:	8d 45 10             	lea    0x10(%ebp),%eax
{
	va_list ap;
	int cnt;

	va_start(ap, fmt);
	cnt = vfprintf(fd, fmt, ap);
  80154e:	89 44 24 08          	mov    %eax,0x8(%esp)
  801552:	8b 45 0c             	mov    0xc(%ebp),%eax
  801555:	89 44 24 04          	mov    %eax,0x4(%esp)
  801559:	8b 45 08             	mov    0x8(%ebp),%eax
  80155c:	89 04 24             	mov    %eax,(%esp)
  80155f:	e8 45 ff ff ff       	call   8014a9 <vfprintf>
	va_end(ap);

	return cnt;
}
  801564:	c9                   	leave  
  801565:	c3                   	ret    

00801566 <putch>:
	}
}

static void
putch(int ch, void *thunk)
{
  801566:	55                   	push   %ebp
  801567:	89 e5                	mov    %esp,%ebp
  801569:	53                   	push   %ebx
  80156a:	83 ec 04             	sub    $0x4,%esp
	struct printbuf *b = (struct printbuf *) thunk;
  80156d:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  801570:	8b 43 04             	mov    0x4(%ebx),%eax
  801573:	8b 55 08             	mov    0x8(%ebp),%edx
  801576:	88 54 03 10          	mov    %dl,0x10(%ebx,%eax,1)
  80157a:	83 c0 01             	add    $0x1,%eax
  80157d:	89 43 04             	mov    %eax,0x4(%ebx)
	if (b->idx == 256) {
  801580:	3d 00 01 00 00       	cmp    $0x100,%eax
  801585:	75 0e                	jne    801595 <putch+0x2f>
		writebuf(b);
  801587:	89 d8                	mov    %ebx,%eax
  801589:	e8 d2 fe ff ff       	call   801460 <writebuf>
		b->idx = 0;
  80158e:	c7 43 04 00 00 00 00 	movl   $0x0,0x4(%ebx)
	}
}
  801595:	83 c4 04             	add    $0x4,%esp
  801598:	5b                   	pop    %ebx
  801599:	5d                   	pop    %ebp
  80159a:	c3                   	ret    
  80159b:	00 00                	add    %al,(%eax)
  80159d:	00 00                	add    %al,(%eax)
	...

008015a0 <devsock_stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  8015a0:	55                   	push   %ebp
  8015a1:	89 e5                	mov    %esp,%ebp
  8015a3:	83 ec 18             	sub    $0x18,%esp
	strcpy(stat->st_name, "<sock>");
  8015a6:	c7 44 24 04 8c 2e 80 	movl   $0x802e8c,0x4(%esp)
  8015ad:	00 
  8015ae:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015b1:	89 04 24             	mov    %eax,(%esp)
  8015b4:	e8 01 ed ff ff       	call   8002ba <strcpy>
	return 0;
}
  8015b9:	b8 00 00 00 00       	mov    $0x0,%eax
  8015be:	c9                   	leave  
  8015bf:	c3                   	ret    

008015c0 <devsock_close>:
	return nsipc_shutdown(r, how);
}

static int
devsock_close(struct Fd *fd)
{
  8015c0:	55                   	push   %ebp
  8015c1:	89 e5                	mov    %esp,%ebp
  8015c3:	83 ec 18             	sub    $0x18,%esp
	return nsipc_close(fd->fd_sock.sockid);
  8015c6:	8b 45 08             	mov    0x8(%ebp),%eax
  8015c9:	8b 40 0c             	mov    0xc(%eax),%eax
  8015cc:	89 04 24             	mov    %eax,(%esp)
  8015cf:	e8 9e 02 00 00       	call   801872 <nsipc_close>
}
  8015d4:	c9                   	leave  
  8015d5:	c3                   	ret    

008015d6 <devsock_write>:
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
}

static ssize_t
devsock_write(struct Fd *fd, const void *buf, size_t n)
{
  8015d6:	55                   	push   %ebp
  8015d7:	89 e5                	mov    %esp,%ebp
  8015d9:	83 ec 18             	sub    $0x18,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  8015dc:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  8015e3:	00 
  8015e4:	8b 45 10             	mov    0x10(%ebp),%eax
  8015e7:	89 44 24 08          	mov    %eax,0x8(%esp)
  8015eb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015ee:	89 44 24 04          	mov    %eax,0x4(%esp)
  8015f2:	8b 45 08             	mov    0x8(%ebp),%eax
  8015f5:	8b 40 0c             	mov    0xc(%eax),%eax
  8015f8:	89 04 24             	mov    %eax,(%esp)
  8015fb:	e8 ae 02 00 00       	call   8018ae <nsipc_send>
}
  801600:	c9                   	leave  
  801601:	c3                   	ret    

00801602 <devsock_read>:
	return nsipc_listen(r, backlog);
}

static ssize_t
devsock_read(struct Fd *fd, void *buf, size_t n)
{
  801602:	55                   	push   %ebp
  801603:	89 e5                	mov    %esp,%ebp
  801605:	83 ec 18             	sub    $0x18,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  801608:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  80160f:	00 
  801610:	8b 45 10             	mov    0x10(%ebp),%eax
  801613:	89 44 24 08          	mov    %eax,0x8(%esp)
  801617:	8b 45 0c             	mov    0xc(%ebp),%eax
  80161a:	89 44 24 04          	mov    %eax,0x4(%esp)
  80161e:	8b 45 08             	mov    0x8(%ebp),%eax
  801621:	8b 40 0c             	mov    0xc(%eax),%eax
  801624:	89 04 24             	mov    %eax,(%esp)
  801627:	e8 f5 02 00 00       	call   801921 <nsipc_recv>
}
  80162c:	c9                   	leave  
  80162d:	c3                   	ret    

0080162e <alloc_sockfd>:
	return sfd->fd_sock.sockid;
}

static int
alloc_sockfd(int sockid)
{
  80162e:	55                   	push   %ebp
  80162f:	89 e5                	mov    %esp,%ebp
  801631:	56                   	push   %esi
  801632:	53                   	push   %ebx
  801633:	83 ec 20             	sub    $0x20,%esp
  801636:	89 c6                	mov    %eax,%esi
	struct Fd *sfd;
	int r;

	if ((r = fd_alloc(&sfd)) < 0
  801638:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80163b:	89 04 24             	mov    %eax,(%esp)
  80163e:	e8 b8 f5 ff ff       	call   800bfb <fd_alloc>
  801643:	89 c3                	mov    %eax,%ebx
  801645:	85 c0                	test   %eax,%eax
  801647:	78 21                	js     80166a <alloc_sockfd+0x3c>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U)) < 0) {
  801649:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  801650:	00 
  801651:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801654:	89 44 24 04          	mov    %eax,0x4(%esp)
  801658:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80165f:	e8 47 f4 ff ff       	call   800aab <sys_page_alloc>
  801664:	89 c3                	mov    %eax,%ebx
alloc_sockfd(int sockid)
{
	struct Fd *sfd;
	int r;

	if ((r = fd_alloc(&sfd)) < 0
  801666:	85 c0                	test   %eax,%eax
  801668:	79 0a                	jns    801674 <alloc_sockfd+0x46>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U)) < 0) {
		nsipc_close(sockid);
  80166a:	89 34 24             	mov    %esi,(%esp)
  80166d:	e8 00 02 00 00       	call   801872 <nsipc_close>
		return r;
  801672:	eb 28                	jmp    80169c <alloc_sockfd+0x6e>
	}

	sfd->fd_dev_id = devsock.dev_id;
  801674:	8b 15 20 70 80 00    	mov    0x807020,%edx
  80167a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80167d:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  80167f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801682:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	sfd->fd_sock.sockid = sockid;
  801689:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80168c:	89 70 0c             	mov    %esi,0xc(%eax)
	return fd2num(sfd);
  80168f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801692:	89 04 24             	mov    %eax,(%esp)
  801695:	e8 36 f5 ff ff       	call   800bd0 <fd2num>
  80169a:	89 c3                	mov    %eax,%ebx
}
  80169c:	89 d8                	mov    %ebx,%eax
  80169e:	83 c4 20             	add    $0x20,%esp
  8016a1:	5b                   	pop    %ebx
  8016a2:	5e                   	pop    %esi
  8016a3:	5d                   	pop    %ebp
  8016a4:	c3                   	ret    

008016a5 <socket>:
	return 0;
}

int
socket(int domain, int type, int protocol)
{
  8016a5:	55                   	push   %ebp
  8016a6:	89 e5                	mov    %esp,%ebp
  8016a8:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  8016ab:	8b 45 10             	mov    0x10(%ebp),%eax
  8016ae:	89 44 24 08          	mov    %eax,0x8(%esp)
  8016b2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8016b5:	89 44 24 04          	mov    %eax,0x4(%esp)
  8016b9:	8b 45 08             	mov    0x8(%ebp),%eax
  8016bc:	89 04 24             	mov    %eax,(%esp)
  8016bf:	e8 62 01 00 00       	call   801826 <nsipc_socket>
  8016c4:	85 c0                	test   %eax,%eax
  8016c6:	78 05                	js     8016cd <socket+0x28>
		return r;
	return alloc_sockfd(r);
  8016c8:	e8 61 ff ff ff       	call   80162e <alloc_sockfd>
}
  8016cd:	c9                   	leave  
  8016ce:	66 90                	xchg   %ax,%ax
  8016d0:	c3                   	ret    

008016d1 <fd2sockid>:
	.dev_stat =	devsock_stat,
};

static int
fd2sockid(int fd)
{
  8016d1:	55                   	push   %ebp
  8016d2:	89 e5                	mov    %esp,%ebp
  8016d4:	83 ec 28             	sub    $0x28,%esp
	struct Fd *sfd;
	int r;

	if ((r = fd_lookup(fd, &sfd)) < 0)
  8016d7:	8d 55 f4             	lea    -0xc(%ebp),%edx
  8016da:	89 54 24 04          	mov    %edx,0x4(%esp)
  8016de:	89 04 24             	mov    %eax,(%esp)
  8016e1:	e8 87 f5 ff ff       	call   800c6d <fd_lookup>
  8016e6:	85 c0                	test   %eax,%eax
  8016e8:	78 15                	js     8016ff <fd2sockid+0x2e>
		return r;
	if (sfd->fd_dev_id != devsock.dev_id)
  8016ea:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8016ed:	8b 0a                	mov    (%edx),%ecx
  8016ef:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8016f4:	3b 0d 20 70 80 00    	cmp    0x807020,%ecx
  8016fa:	75 03                	jne    8016ff <fd2sockid+0x2e>
		return -E_NOT_SUPP;
	return sfd->fd_sock.sockid;
  8016fc:	8b 42 0c             	mov    0xc(%edx),%eax
}
  8016ff:	c9                   	leave  
  801700:	c3                   	ret    

00801701 <listen>:
	return nsipc_connect(r, name, namelen);
}

int
listen(int s, int backlog)
{
  801701:	55                   	push   %ebp
  801702:	89 e5                	mov    %esp,%ebp
  801704:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  801707:	8b 45 08             	mov    0x8(%ebp),%eax
  80170a:	e8 c2 ff ff ff       	call   8016d1 <fd2sockid>
  80170f:	85 c0                	test   %eax,%eax
  801711:	78 0f                	js     801722 <listen+0x21>
		return r;
	return nsipc_listen(r, backlog);
  801713:	8b 55 0c             	mov    0xc(%ebp),%edx
  801716:	89 54 24 04          	mov    %edx,0x4(%esp)
  80171a:	89 04 24             	mov    %eax,(%esp)
  80171d:	e8 2e 01 00 00       	call   801850 <nsipc_listen>
}
  801722:	c9                   	leave  
  801723:	c3                   	ret    

00801724 <connect>:
	return nsipc_close(fd->fd_sock.sockid);
}

int
connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  801724:	55                   	push   %ebp
  801725:	89 e5                	mov    %esp,%ebp
  801727:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  80172a:	8b 45 08             	mov    0x8(%ebp),%eax
  80172d:	e8 9f ff ff ff       	call   8016d1 <fd2sockid>
  801732:	85 c0                	test   %eax,%eax
  801734:	78 16                	js     80174c <connect+0x28>
		return r;
	return nsipc_connect(r, name, namelen);
  801736:	8b 55 10             	mov    0x10(%ebp),%edx
  801739:	89 54 24 08          	mov    %edx,0x8(%esp)
  80173d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801740:	89 54 24 04          	mov    %edx,0x4(%esp)
  801744:	89 04 24             	mov    %eax,(%esp)
  801747:	e8 55 02 00 00       	call   8019a1 <nsipc_connect>
}
  80174c:	c9                   	leave  
  80174d:	c3                   	ret    

0080174e <shutdown>:
	return nsipc_bind(r, name, namelen);
}

int
shutdown(int s, int how)
{
  80174e:	55                   	push   %ebp
  80174f:	89 e5                	mov    %esp,%ebp
  801751:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  801754:	8b 45 08             	mov    0x8(%ebp),%eax
  801757:	e8 75 ff ff ff       	call   8016d1 <fd2sockid>
  80175c:	85 c0                	test   %eax,%eax
  80175e:	78 0f                	js     80176f <shutdown+0x21>
		return r;
	return nsipc_shutdown(r, how);
  801760:	8b 55 0c             	mov    0xc(%ebp),%edx
  801763:	89 54 24 04          	mov    %edx,0x4(%esp)
  801767:	89 04 24             	mov    %eax,(%esp)
  80176a:	e8 1d 01 00 00       	call   80188c <nsipc_shutdown>
}
  80176f:	c9                   	leave  
  801770:	c3                   	ret    

00801771 <bind>:
	return alloc_sockfd(r);
}

int
bind(int s, struct sockaddr *name, socklen_t namelen)
{
  801771:	55                   	push   %ebp
  801772:	89 e5                	mov    %esp,%ebp
  801774:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  801777:	8b 45 08             	mov    0x8(%ebp),%eax
  80177a:	e8 52 ff ff ff       	call   8016d1 <fd2sockid>
  80177f:	85 c0                	test   %eax,%eax
  801781:	78 16                	js     801799 <bind+0x28>
		return r;
	return nsipc_bind(r, name, namelen);
  801783:	8b 55 10             	mov    0x10(%ebp),%edx
  801786:	89 54 24 08          	mov    %edx,0x8(%esp)
  80178a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80178d:	89 54 24 04          	mov    %edx,0x4(%esp)
  801791:	89 04 24             	mov    %eax,(%esp)
  801794:	e8 47 02 00 00       	call   8019e0 <nsipc_bind>
}
  801799:	c9                   	leave  
  80179a:	c3                   	ret    

0080179b <accept>:
	return fd2num(sfd);
}

int
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  80179b:	55                   	push   %ebp
  80179c:	89 e5                	mov    %esp,%ebp
  80179e:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  8017a1:	8b 45 08             	mov    0x8(%ebp),%eax
  8017a4:	e8 28 ff ff ff       	call   8016d1 <fd2sockid>
  8017a9:	85 c0                	test   %eax,%eax
  8017ab:	78 1f                	js     8017cc <accept+0x31>
		return r;
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  8017ad:	8b 55 10             	mov    0x10(%ebp),%edx
  8017b0:	89 54 24 08          	mov    %edx,0x8(%esp)
  8017b4:	8b 55 0c             	mov    0xc(%ebp),%edx
  8017b7:	89 54 24 04          	mov    %edx,0x4(%esp)
  8017bb:	89 04 24             	mov    %eax,(%esp)
  8017be:	e8 5c 02 00 00       	call   801a1f <nsipc_accept>
  8017c3:	85 c0                	test   %eax,%eax
  8017c5:	78 05                	js     8017cc <accept+0x31>
		return r;
	return alloc_sockfd(r);
  8017c7:	e8 62 fe ff ff       	call   80162e <alloc_sockfd>
}
  8017cc:	c9                   	leave  
  8017cd:	8d 76 00             	lea    0x0(%esi),%esi
  8017d0:	c3                   	ret    
	...

008017e0 <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  8017e0:	55                   	push   %ebp
  8017e1:	89 e5                	mov    %esp,%ebp
  8017e3:	83 ec 18             	sub    $0x18,%esp
	if (debug)
		cprintf("[%08x] nsipc %d\n", env->env_id, type);

	ipc_send(envs[2].env_id, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  8017e6:	8b 15 44 01 c0 ee    	mov    0xeec00144,%edx
  8017ec:	c7 44 24 0c 07 00 00 	movl   $0x7,0xc(%esp)
  8017f3:	00 
  8017f4:	c7 44 24 08 00 60 80 	movl   $0x806000,0x8(%esp)
  8017fb:	00 
  8017fc:	89 44 24 04          	mov    %eax,0x4(%esp)
  801800:	89 14 24             	mov    %edx,(%esp)
  801803:	e8 e8 11 00 00       	call   8029f0 <ipc_send>
	return ipc_recv(NULL, NULL, NULL);
  801808:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  80180f:	00 
  801810:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  801817:	00 
  801818:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80181f:	e8 32 12 00 00       	call   802a56 <ipc_recv>
}
  801824:	c9                   	leave  
  801825:	c3                   	ret    

00801826 <nsipc_socket>:
	return nsipc(NSREQ_SEND);
}

int
nsipc_socket(int domain, int type, int protocol)
{
  801826:	55                   	push   %ebp
  801827:	89 e5                	mov    %esp,%ebp
  801829:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  80182c:	8b 45 08             	mov    0x8(%ebp),%eax
  80182f:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.socket.req_type = type;
  801834:	8b 45 0c             	mov    0xc(%ebp),%eax
  801837:	a3 04 60 80 00       	mov    %eax,0x806004
	nsipcbuf.socket.req_protocol = protocol;
  80183c:	8b 45 10             	mov    0x10(%ebp),%eax
  80183f:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SOCKET);
  801844:	b8 09 00 00 00       	mov    $0x9,%eax
  801849:	e8 92 ff ff ff       	call   8017e0 <nsipc>
}
  80184e:	c9                   	leave  
  80184f:	c3                   	ret    

00801850 <nsipc_listen>:
	return nsipc(NSREQ_CONNECT);
}

int
nsipc_listen(int s, int backlog)
{
  801850:	55                   	push   %ebp
  801851:	89 e5                	mov    %esp,%ebp
  801853:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  801856:	8b 45 08             	mov    0x8(%ebp),%eax
  801859:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.listen.req_backlog = backlog;
  80185e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801861:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_LISTEN);
  801866:	b8 06 00 00 00       	mov    $0x6,%eax
  80186b:	e8 70 ff ff ff       	call   8017e0 <nsipc>
}
  801870:	c9                   	leave  
  801871:	c3                   	ret    

00801872 <nsipc_close>:
	return nsipc(NSREQ_SHUTDOWN);
}

int
nsipc_close(int s)
{
  801872:	55                   	push   %ebp
  801873:	89 e5                	mov    %esp,%ebp
  801875:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  801878:	8b 45 08             	mov    0x8(%ebp),%eax
  80187b:	a3 00 60 80 00       	mov    %eax,0x806000
	return nsipc(NSREQ_CLOSE);
  801880:	b8 04 00 00 00       	mov    $0x4,%eax
  801885:	e8 56 ff ff ff       	call   8017e0 <nsipc>
}
  80188a:	c9                   	leave  
  80188b:	c3                   	ret    

0080188c <nsipc_shutdown>:
	return nsipc(NSREQ_BIND);
}

int
nsipc_shutdown(int s, int how)
{
  80188c:	55                   	push   %ebp
  80188d:	89 e5                	mov    %esp,%ebp
  80188f:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  801892:	8b 45 08             	mov    0x8(%ebp),%eax
  801895:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.shutdown.req_how = how;
  80189a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80189d:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_SHUTDOWN);
  8018a2:	b8 03 00 00 00       	mov    $0x3,%eax
  8018a7:	e8 34 ff ff ff       	call   8017e0 <nsipc>
}
  8018ac:	c9                   	leave  
  8018ad:	c3                   	ret    

008018ae <nsipc_send>:
	return r;
}

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  8018ae:	55                   	push   %ebp
  8018af:	89 e5                	mov    %esp,%ebp
  8018b1:	53                   	push   %ebx
  8018b2:	83 ec 14             	sub    $0x14,%esp
  8018b5:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  8018b8:	8b 45 08             	mov    0x8(%ebp),%eax
  8018bb:	a3 00 60 80 00       	mov    %eax,0x806000
	assert(size < 1600);
  8018c0:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  8018c6:	7e 24                	jle    8018ec <nsipc_send+0x3e>
  8018c8:	c7 44 24 0c 98 2e 80 	movl   $0x802e98,0xc(%esp)
  8018cf:	00 
  8018d0:	c7 44 24 08 a4 2e 80 	movl   $0x802ea4,0x8(%esp)
  8018d7:	00 
  8018d8:	c7 44 24 04 66 00 00 	movl   $0x66,0x4(%esp)
  8018df:	00 
  8018e0:	c7 04 24 b9 2e 80 00 	movl   $0x802eb9,(%esp)
  8018e7:	e8 d0 09 00 00       	call   8022bc <_panic>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  8018ec:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8018f0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8018f3:	89 44 24 04          	mov    %eax,0x4(%esp)
  8018f7:	c7 04 24 0c 60 80 00 	movl   $0x80600c,(%esp)
  8018fe:	e8 72 eb ff ff       	call   800475 <memmove>
	nsipcbuf.send.req_size = size;
  801903:	89 1d 04 60 80 00    	mov    %ebx,0x806004
	nsipcbuf.send.req_flags = flags;
  801909:	8b 45 14             	mov    0x14(%ebp),%eax
  80190c:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SEND);
  801911:	b8 08 00 00 00       	mov    $0x8,%eax
  801916:	e8 c5 fe ff ff       	call   8017e0 <nsipc>
}
  80191b:	83 c4 14             	add    $0x14,%esp
  80191e:	5b                   	pop    %ebx
  80191f:	5d                   	pop    %ebp
  801920:	c3                   	ret    

00801921 <nsipc_recv>:
	return nsipc(NSREQ_LISTEN);
}

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  801921:	55                   	push   %ebp
  801922:	89 e5                	mov    %esp,%ebp
  801924:	56                   	push   %esi
  801925:	53                   	push   %ebx
  801926:	83 ec 10             	sub    $0x10,%esp
  801929:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  80192c:	8b 45 08             	mov    0x8(%ebp),%eax
  80192f:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.recv.req_len = len;
  801934:	89 35 04 60 80 00    	mov    %esi,0x806004
	nsipcbuf.recv.req_flags = flags;
  80193a:	8b 45 14             	mov    0x14(%ebp),%eax
  80193d:	a3 08 60 80 00       	mov    %eax,0x806008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  801942:	b8 07 00 00 00       	mov    $0x7,%eax
  801947:	e8 94 fe ff ff       	call   8017e0 <nsipc>
  80194c:	89 c3                	mov    %eax,%ebx
  80194e:	85 c0                	test   %eax,%eax
  801950:	78 46                	js     801998 <nsipc_recv+0x77>
		assert(r < 1600 && r <= len);
  801952:	3d 3f 06 00 00       	cmp    $0x63f,%eax
  801957:	7f 04                	jg     80195d <nsipc_recv+0x3c>
  801959:	39 c6                	cmp    %eax,%esi
  80195b:	7d 24                	jge    801981 <nsipc_recv+0x60>
  80195d:	c7 44 24 0c c5 2e 80 	movl   $0x802ec5,0xc(%esp)
  801964:	00 
  801965:	c7 44 24 08 a4 2e 80 	movl   $0x802ea4,0x8(%esp)
  80196c:	00 
  80196d:	c7 44 24 04 5b 00 00 	movl   $0x5b,0x4(%esp)
  801974:	00 
  801975:	c7 04 24 b9 2e 80 00 	movl   $0x802eb9,(%esp)
  80197c:	e8 3b 09 00 00       	call   8022bc <_panic>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  801981:	89 44 24 08          	mov    %eax,0x8(%esp)
  801985:	c7 44 24 04 00 60 80 	movl   $0x806000,0x4(%esp)
  80198c:	00 
  80198d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801990:	89 04 24             	mov    %eax,(%esp)
  801993:	e8 dd ea ff ff       	call   800475 <memmove>
	}

	return r;
}
  801998:	89 d8                	mov    %ebx,%eax
  80199a:	83 c4 10             	add    $0x10,%esp
  80199d:	5b                   	pop    %ebx
  80199e:	5e                   	pop    %esi
  80199f:	5d                   	pop    %ebp
  8019a0:	c3                   	ret    

008019a1 <nsipc_connect>:
	return nsipc(NSREQ_CLOSE);
}

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  8019a1:	55                   	push   %ebp
  8019a2:	89 e5                	mov    %esp,%ebp
  8019a4:	53                   	push   %ebx
  8019a5:	83 ec 14             	sub    $0x14,%esp
  8019a8:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  8019ab:	8b 45 08             	mov    0x8(%ebp),%eax
  8019ae:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  8019b3:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8019b7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8019ba:	89 44 24 04          	mov    %eax,0x4(%esp)
  8019be:	c7 04 24 04 60 80 00 	movl   $0x806004,(%esp)
  8019c5:	e8 ab ea ff ff       	call   800475 <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  8019ca:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_CONNECT);
  8019d0:	b8 05 00 00 00       	mov    $0x5,%eax
  8019d5:	e8 06 fe ff ff       	call   8017e0 <nsipc>
}
  8019da:	83 c4 14             	add    $0x14,%esp
  8019dd:	5b                   	pop    %ebx
  8019de:	5d                   	pop    %ebp
  8019df:	c3                   	ret    

008019e0 <nsipc_bind>:
	return r;
}

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  8019e0:	55                   	push   %ebp
  8019e1:	89 e5                	mov    %esp,%ebp
  8019e3:	53                   	push   %ebx
  8019e4:	83 ec 14             	sub    $0x14,%esp
  8019e7:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  8019ea:	8b 45 08             	mov    0x8(%ebp),%eax
  8019ed:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  8019f2:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8019f6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8019f9:	89 44 24 04          	mov    %eax,0x4(%esp)
  8019fd:	c7 04 24 04 60 80 00 	movl   $0x806004,(%esp)
  801a04:	e8 6c ea ff ff       	call   800475 <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  801a09:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_BIND);
  801a0f:	b8 02 00 00 00       	mov    $0x2,%eax
  801a14:	e8 c7 fd ff ff       	call   8017e0 <nsipc>
}
  801a19:	83 c4 14             	add    $0x14,%esp
  801a1c:	5b                   	pop    %ebx
  801a1d:	5d                   	pop    %ebp
  801a1e:	c3                   	ret    

00801a1f <nsipc_accept>:
	return ipc_recv(NULL, NULL, NULL);
}

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  801a1f:	55                   	push   %ebp
  801a20:	89 e5                	mov    %esp,%ebp
  801a22:	83 ec 18             	sub    $0x18,%esp
  801a25:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  801a28:	89 75 fc             	mov    %esi,-0x4(%ebp)
	int r;
	
	nsipcbuf.accept.req_s = s;
  801a2b:	8b 45 08             	mov    0x8(%ebp),%eax
  801a2e:	a3 00 60 80 00       	mov    %eax,0x806000
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  801a33:	b8 01 00 00 00       	mov    $0x1,%eax
  801a38:	e8 a3 fd ff ff       	call   8017e0 <nsipc>
  801a3d:	89 c3                	mov    %eax,%ebx
  801a3f:	85 c0                	test   %eax,%eax
  801a41:	78 25                	js     801a68 <nsipc_accept+0x49>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  801a43:	be 10 60 80 00       	mov    $0x806010,%esi
  801a48:	8b 06                	mov    (%esi),%eax
  801a4a:	89 44 24 08          	mov    %eax,0x8(%esp)
  801a4e:	c7 44 24 04 00 60 80 	movl   $0x806000,0x4(%esp)
  801a55:	00 
  801a56:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a59:	89 04 24             	mov    %eax,(%esp)
  801a5c:	e8 14 ea ff ff       	call   800475 <memmove>
		*addrlen = ret->ret_addrlen;
  801a61:	8b 16                	mov    (%esi),%edx
  801a63:	8b 45 10             	mov    0x10(%ebp),%eax
  801a66:	89 10                	mov    %edx,(%eax)
	}
	return r;
}
  801a68:	89 d8                	mov    %ebx,%eax
  801a6a:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  801a6d:	8b 75 fc             	mov    -0x4(%ebp),%esi
  801a70:	89 ec                	mov    %ebp,%esp
  801a72:	5d                   	pop    %ebp
  801a73:	c3                   	ret    
	...

00801a80 <free>:
	return v;
}

void
free(void *v)
{
  801a80:	55                   	push   %ebp
  801a81:	89 e5                	mov    %esp,%ebp
  801a83:	56                   	push   %esi
  801a84:	53                   	push   %ebx
  801a85:	83 ec 10             	sub    $0x10,%esp
  801a88:	8b 5d 08             	mov    0x8(%ebp),%ebx
	uint8_t *c;
	uint32_t *ref;

	if (v == 0)
  801a8b:	85 db                	test   %ebx,%ebx
  801a8d:	0f 84 b9 00 00 00    	je     801b4c <free+0xcc>
		return;
	assert(mbegin <= (uint8_t*) v && (uint8_t*) v < mend);
  801a93:	81 fb ff ff ff 07    	cmp    $0x7ffffff,%ebx
  801a99:	76 08                	jbe    801aa3 <free+0x23>
  801a9b:	81 fb ff ff ff 0f    	cmp    $0xfffffff,%ebx
  801aa1:	76 24                	jbe    801ac7 <free+0x47>
  801aa3:	c7 44 24 0c dc 2e 80 	movl   $0x802edc,0xc(%esp)
  801aaa:	00 
  801aab:	c7 44 24 08 a4 2e 80 	movl   $0x802ea4,0x8(%esp)
  801ab2:	00 
  801ab3:	c7 44 24 04 7a 00 00 	movl   $0x7a,0x4(%esp)
  801aba:	00 
  801abb:	c7 04 24 0a 2f 80 00 	movl   $0x802f0a,(%esp)
  801ac2:	e8 f5 07 00 00       	call   8022bc <_panic>

	c = ROUNDDOWN(v, PGSIZE);
  801ac7:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx

	while (vpt[VPN(c)] & PTE_CONTINUED) {
  801acd:	be 00 00 40 ef       	mov    $0xef400000,%esi
  801ad2:	eb 4a                	jmp    801b1e <free+0x9e>
		sys_page_unmap(0, c);
  801ad4:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801ad8:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801adf:	e8 0b ef ff ff       	call   8009ef <sys_page_unmap>
		c += PGSIZE;
  801ae4:	81 c3 00 10 00 00    	add    $0x1000,%ebx
		assert(mbegin <= c && c < mend);
  801aea:	81 fb ff ff ff 07    	cmp    $0x7ffffff,%ebx
  801af0:	76 08                	jbe    801afa <free+0x7a>
  801af2:	81 fb ff ff ff 0f    	cmp    $0xfffffff,%ebx
  801af8:	76 24                	jbe    801b1e <free+0x9e>
  801afa:	c7 44 24 0c 17 2f 80 	movl   $0x802f17,0xc(%esp)
  801b01:	00 
  801b02:	c7 44 24 08 a4 2e 80 	movl   $0x802ea4,0x8(%esp)
  801b09:	00 
  801b0a:	c7 44 24 04 81 00 00 	movl   $0x81,0x4(%esp)
  801b11:	00 
  801b12:	c7 04 24 0a 2f 80 00 	movl   $0x802f0a,(%esp)
  801b19:	e8 9e 07 00 00       	call   8022bc <_panic>
		return;
	assert(mbegin <= (uint8_t*) v && (uint8_t*) v < mend);

	c = ROUNDDOWN(v, PGSIZE);

	while (vpt[VPN(c)] & PTE_CONTINUED) {
  801b1e:	89 d8                	mov    %ebx,%eax
  801b20:	c1 e8 0c             	shr    $0xc,%eax
  801b23:	8b 04 86             	mov    (%esi,%eax,4),%eax
  801b26:	f6 c4 04             	test   $0x4,%ah
  801b29:	75 a9                	jne    801ad4 <free+0x54>

	/*
	 * c is just a piece of this page, so dec the ref count
	 * and maybe free the page.
	 */
	ref = (uint32_t*) (c + PGSIZE - 4);
  801b2b:	8d 93 fc 0f 00 00    	lea    0xffc(%ebx),%edx
	if (--(*ref) == 0)
  801b31:	8b 02                	mov    (%edx),%eax
  801b33:	83 e8 01             	sub    $0x1,%eax
  801b36:	89 02                	mov    %eax,(%edx)
  801b38:	85 c0                	test   %eax,%eax
  801b3a:	75 10                	jne    801b4c <free+0xcc>
		sys_page_unmap(0, c);	
  801b3c:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801b40:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801b47:	e8 a3 ee ff ff       	call   8009ef <sys_page_unmap>
}
  801b4c:	83 c4 10             	add    $0x10,%esp
  801b4f:	5b                   	pop    %ebx
  801b50:	5e                   	pop    %esi
  801b51:	5d                   	pop    %ebp
  801b52:	c3                   	ret    

00801b53 <malloc>:
	return 1;
}

void*
malloc(size_t n)
{
  801b53:	55                   	push   %ebp
  801b54:	89 e5                	mov    %esp,%ebp
  801b56:	57                   	push   %edi
  801b57:	56                   	push   %esi
  801b58:	53                   	push   %ebx
  801b59:	83 ec 3c             	sub    $0x3c,%esp
	int i, cont;
	int nwrap;
	uint32_t *ref;
	void *v;

	if (mptr == 0)
  801b5c:	83 3d 80 74 80 00 00 	cmpl   $0x0,0x807480
  801b63:	75 0a                	jne    801b6f <malloc+0x1c>
		mptr = mbegin;
  801b65:	c7 05 80 74 80 00 00 	movl   $0x8000000,0x807480
  801b6c:	00 00 08 

	n = ROUNDUP(n, 4);
  801b6f:	8b 45 08             	mov    0x8(%ebp),%eax
  801b72:	83 c0 03             	add    $0x3,%eax
  801b75:	83 e0 fc             	and    $0xfffffffc,%eax
  801b78:	89 45 d8             	mov    %eax,-0x28(%ebp)

	if (n >= MAXMALLOC)
  801b7b:	3d ff ff 0f 00       	cmp    $0xfffff,%eax
  801b80:	0f 87 97 01 00 00    	ja     801d1d <malloc+0x1ca>
		return 0;

	if ((uintptr_t) mptr % PGSIZE){
  801b86:	a1 80 74 80 00       	mov    0x807480,%eax
  801b8b:	89 c2                	mov    %eax,%edx
  801b8d:	a9 ff 0f 00 00       	test   $0xfff,%eax
  801b92:	74 4d                	je     801be1 <malloc+0x8e>
		 * we're in the middle of a partially
		 * allocated page - can we add this chunk?
		 * the +4 below is for the ref count.
		 */
		ref = (uint32_t*) (ROUNDUP(mptr, PGSIZE) - 4);
		if ((uintptr_t) mptr / PGSIZE == (uintptr_t) (mptr + n - 1 + 4) / PGSIZE) {
  801b94:	89 c3                	mov    %eax,%ebx
  801b96:	c1 eb 0c             	shr    $0xc,%ebx
  801b99:	8b 75 d8             	mov    -0x28(%ebp),%esi
  801b9c:	8d 4c 30 03          	lea    0x3(%eax,%esi,1),%ecx
  801ba0:	c1 e9 0c             	shr    $0xc,%ecx
  801ba3:	39 cb                	cmp    %ecx,%ebx
  801ba5:	75 1e                	jne    801bc5 <malloc+0x72>
		/*
		 * we're in the middle of a partially
		 * allocated page - can we add this chunk?
		 * the +4 below is for the ref count.
		 */
		ref = (uint32_t*) (ROUNDUP(mptr, PGSIZE) - 4);
  801ba7:	81 c2 ff 0f 00 00    	add    $0xfff,%edx
  801bad:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
		if ((uintptr_t) mptr / PGSIZE == (uintptr_t) (mptr + n - 1 + 4) / PGSIZE) {
			(*ref)++;
  801bb3:	83 42 fc 01          	addl   $0x1,-0x4(%edx)
			v = mptr;
			mptr += n;
  801bb7:	8d 14 30             	lea    (%eax,%esi,1),%edx
  801bba:	89 15 80 74 80 00    	mov    %edx,0x807480
			return v;
  801bc0:	e9 5d 01 00 00       	jmp    801d22 <malloc+0x1cf>
		}
		/*
		 * stop working on this page and move on.
		 */
		free(mptr);	/* drop reference to this page */
  801bc5:	89 04 24             	mov    %eax,(%esp)
  801bc8:	e8 b3 fe ff ff       	call   801a80 <free>
		mptr = ROUNDDOWN(mptr + PGSIZE, PGSIZE);
  801bcd:	a1 80 74 80 00       	mov    0x807480,%eax
  801bd2:	05 00 10 00 00       	add    $0x1000,%eax
  801bd7:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801bdc:	a3 80 74 80 00       	mov    %eax,0x807480
  801be1:	8b 3d 80 74 80 00    	mov    0x807480,%edi
  801be7:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
			return 0;
	return 1;
}

void*
malloc(size_t n)
  801bee:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801bf1:	83 c0 04             	add    $0x4,%eax
  801bf4:	89 45 dc             	mov    %eax,-0x24(%ebp)
{
	uintptr_t va, end_va = (uintptr_t) v + n;

	for (va = (uintptr_t) v; va < end_va; va += PGSIZE)
		if (va >= (uintptr_t) mend
		    || ((vpd[PDX(va)] & PTE_P) && (vpt[VPN(va)] & PTE_P)))
  801bf7:	bb 00 d0 7b ef       	mov    $0xef7bd000,%ebx
  801bfc:	be 00 00 40 ef       	mov    $0xef400000,%esi
			return 0;
	return 1;
}

void*
malloc(size_t n)
  801c01:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  801c04:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  801c07:	8d 0c 0f             	lea    (%edi,%ecx,1),%ecx
  801c0a:	89 7d e4             	mov    %edi,-0x1c(%ebp)
static int
isfree(void *v, size_t n)
{
	uintptr_t va, end_va = (uintptr_t) v + n;

	for (va = (uintptr_t) v; va < end_va; va += PGSIZE)
  801c0d:	39 cf                	cmp    %ecx,%edi
  801c0f:	0f 83 d7 00 00 00    	jae    801cec <malloc+0x199>
		if (va >= (uintptr_t) mend
  801c15:	89 f8                	mov    %edi,%eax
  801c17:	81 ff ff ff ff 0f    	cmp    $0xfffffff,%edi
  801c1d:	76 09                	jbe    801c28 <malloc+0xd5>
  801c1f:	eb 38                	jmp    801c59 <malloc+0x106>
  801c21:	3d ff ff ff 0f       	cmp    $0xfffffff,%eax
  801c26:	77 31                	ja     801c59 <malloc+0x106>
		    || ((vpd[PDX(va)] & PTE_P) && (vpt[VPN(va)] & PTE_P)))
  801c28:	89 c2                	mov    %eax,%edx
  801c2a:	c1 ea 16             	shr    $0x16,%edx
  801c2d:	8b 14 93             	mov    (%ebx,%edx,4),%edx
isfree(void *v, size_t n)
{
	uintptr_t va, end_va = (uintptr_t) v + n;

	for (va = (uintptr_t) v; va < end_va; va += PGSIZE)
		if (va >= (uintptr_t) mend
  801c30:	f6 c2 01             	test   $0x1,%dl
  801c33:	74 0d                	je     801c42 <malloc+0xef>
		    || ((vpd[PDX(va)] & PTE_P) && (vpt[VPN(va)] & PTE_P)))
  801c35:	89 c2                	mov    %eax,%edx
  801c37:	c1 ea 0c             	shr    $0xc,%edx
  801c3a:	8b 14 96             	mov    (%esi,%edx,4),%edx
isfree(void *v, size_t n)
{
	uintptr_t va, end_va = (uintptr_t) v + n;

	for (va = (uintptr_t) v; va < end_va; va += PGSIZE)
		if (va >= (uintptr_t) mend
  801c3d:	f6 c2 01             	test   $0x1,%dl
  801c40:	75 17                	jne    801c59 <malloc+0x106>
static int
isfree(void *v, size_t n)
{
	uintptr_t va, end_va = (uintptr_t) v + n;

	for (va = (uintptr_t) v; va < end_va; va += PGSIZE)
  801c42:	05 00 10 00 00       	add    $0x1000,%eax
  801c47:	39 c8                	cmp    %ecx,%eax
  801c49:	72 d6                	jb     801c21 <malloc+0xce>
  801c4b:	8b 75 e4             	mov    -0x1c(%ebp),%esi
  801c4e:	89 35 80 74 80 00    	mov    %esi,0x807480
  801c54:	e9 9b 00 00 00       	jmp    801cf4 <malloc+0x1a1>
  801c59:	81 c7 00 10 00 00    	add    $0x1000,%edi
  801c5f:	81 c1 00 10 00 00    	add    $0x1000,%ecx
	nwrap = 0;
	while (1) {
		if (isfree(mptr, n + 4))
			break;
		mptr += PGSIZE;
		if (mptr == mend) {
  801c65:	81 ff 00 00 00 10    	cmp    $0x10000000,%edi
  801c6b:	75 9d                	jne    801c0a <malloc+0xb7>
			mptr = mbegin;
			if (++nwrap == 2)
  801c6d:	83 45 e0 01          	addl   $0x1,-0x20(%ebp)
  801c71:	83 7d e0 02          	cmpl   $0x2,-0x20(%ebp)
  801c75:	74 07                	je     801c7e <malloc+0x12b>
  801c77:	bf 00 00 00 08       	mov    $0x8000000,%edi
  801c7c:	eb 83                	jmp    801c01 <malloc+0xae>
  801c7e:	c7 05 80 74 80 00 00 	movl   $0x8000000,0x807480
  801c85:	00 00 08 
  801c88:	b8 00 00 00 00       	mov    $0x0,%eax
  801c8d:	e9 90 00 00 00       	jmp    801d22 <malloc+0x1cf>

	/*
	 * allocate at mptr - the +4 makes sure we allocate a ref count.
	 */
	for (i = 0; i < n + 4; i += PGSIZE){
		cont = (i + PGSIZE < n + 4) ? PTE_CONTINUED : 0;
  801c92:	8d b3 00 10 00 00    	lea    0x1000(%ebx),%esi
  801c98:	39 fe                	cmp    %edi,%esi
  801c9a:	19 c0                	sbb    %eax,%eax
  801c9c:	25 00 04 00 00       	and    $0x400,%eax
		if (sys_page_alloc(0, mptr + i, PTE_P|PTE_U|PTE_W|cont) < 0){
  801ca1:	83 c8 07             	or     $0x7,%eax
  801ca4:	89 44 24 08          	mov    %eax,0x8(%esp)
  801ca8:	03 15 80 74 80 00    	add    0x807480,%edx
  801cae:	89 54 24 04          	mov    %edx,0x4(%esp)
  801cb2:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801cb9:	e8 ed ed ff ff       	call   800aab <sys_page_alloc>
  801cbe:	85 c0                	test   %eax,%eax
  801cc0:	78 04                	js     801cc6 <malloc+0x173>
  801cc2:	89 f3                	mov    %esi,%ebx
  801cc4:	eb 36                	jmp    801cfc <malloc+0x1a9>
			for (; i >= 0; i -= PGSIZE)
  801cc6:	85 db                	test   %ebx,%ebx
  801cc8:	78 53                	js     801d1d <malloc+0x1ca>
				sys_page_unmap(0, mptr + i);
  801cca:	89 d8                	mov    %ebx,%eax
  801ccc:	03 05 80 74 80 00    	add    0x807480,%eax
  801cd2:	89 44 24 04          	mov    %eax,0x4(%esp)
  801cd6:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801cdd:	e8 0d ed ff ff       	call   8009ef <sys_page_unmap>
	 * allocate at mptr - the +4 makes sure we allocate a ref count.
	 */
	for (i = 0; i < n + 4; i += PGSIZE){
		cont = (i + PGSIZE < n + 4) ? PTE_CONTINUED : 0;
		if (sys_page_alloc(0, mptr + i, PTE_P|PTE_U|PTE_W|cont) < 0){
			for (; i >= 0; i -= PGSIZE)
  801ce2:	81 eb 00 10 00 00    	sub    $0x1000,%ebx
  801ce8:	79 e0                	jns    801cca <malloc+0x177>
  801cea:	eb 31                	jmp    801d1d <malloc+0x1ca>
  801cec:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801cef:	a3 80 74 80 00       	mov    %eax,0x807480
  801cf4:	bb 00 00 00 00       	mov    $0x0,%ebx
  801cf9:	8b 7d d4             	mov    -0x2c(%ebp),%edi
  801cfc:	89 da                	mov    %ebx,%edx
	}

	/*
	 * allocate at mptr - the +4 makes sure we allocate a ref count.
	 */
	for (i = 0; i < n + 4; i += PGSIZE){
  801cfe:	39 fb                	cmp    %edi,%ebx
  801d00:	72 90                	jb     801c92 <malloc+0x13f>
				sys_page_unmap(0, mptr + i);
			return 0;	/* out of physical memory */
		}
	}

	ref = (uint32_t*) (mptr + i - 4);
  801d02:	a1 80 74 80 00       	mov    0x807480,%eax
	*ref = 2;	/* reference for mptr, reference for returned block */
  801d07:	c7 44 18 fc 02 00 00 	movl   $0x2,-0x4(%eax,%ebx,1)
  801d0e:	00 
	v = mptr;
	mptr += n;
  801d0f:	8b 4d d8             	mov    -0x28(%ebp),%ecx
  801d12:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  801d15:	89 15 80 74 80 00    	mov    %edx,0x807480
	return v;
  801d1b:	eb 05                	jmp    801d22 <malloc+0x1cf>
  801d1d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801d22:	83 c4 3c             	add    $0x3c,%esp
  801d25:	5b                   	pop    %ebx
  801d26:	5e                   	pop    %esi
  801d27:	5f                   	pop    %edi
  801d28:	5d                   	pop    %ebp
  801d29:	c3                   	ret    
  801d2a:	00 00                	add    %al,(%eax)
  801d2c:	00 00                	add    %al,(%eax)
	...

00801d30 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  801d30:	55                   	push   %ebp
  801d31:	89 e5                	mov    %esp,%ebp
  801d33:	83 ec 18             	sub    $0x18,%esp
  801d36:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  801d39:	89 75 fc             	mov    %esi,-0x4(%ebp)
  801d3c:	8b 75 0c             	mov    0xc(%ebp),%esi
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  801d3f:	8b 45 08             	mov    0x8(%ebp),%eax
  801d42:	89 04 24             	mov    %eax,(%esp)
  801d45:	e8 96 ee ff ff       	call   800be0 <fd2data>
  801d4a:	89 c3                	mov    %eax,%ebx
	strcpy(stat->st_name, "<pipe>");
  801d4c:	c7 44 24 04 2f 2f 80 	movl   $0x802f2f,0x4(%esp)
  801d53:	00 
  801d54:	89 34 24             	mov    %esi,(%esp)
  801d57:	e8 5e e5 ff ff       	call   8002ba <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  801d5c:	8b 43 04             	mov    0x4(%ebx),%eax
  801d5f:	2b 03                	sub    (%ebx),%eax
  801d61:	89 86 80 00 00 00    	mov    %eax,0x80(%esi)
	stat->st_isdir = 0;
  801d67:	c7 86 84 00 00 00 00 	movl   $0x0,0x84(%esi)
  801d6e:	00 00 00 
	stat->st_dev = &devpipe;
  801d71:	c7 86 88 00 00 00 3c 	movl   $0x80703c,0x88(%esi)
  801d78:	70 80 00 
	return 0;
}
  801d7b:	b8 00 00 00 00       	mov    $0x0,%eax
  801d80:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  801d83:	8b 75 fc             	mov    -0x4(%ebp),%esi
  801d86:	89 ec                	mov    %ebp,%esp
  801d88:	5d                   	pop    %ebp
  801d89:	c3                   	ret    

00801d8a <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  801d8a:	55                   	push   %ebp
  801d8b:	89 e5                	mov    %esp,%ebp
  801d8d:	53                   	push   %ebx
  801d8e:	83 ec 14             	sub    $0x14,%esp
  801d91:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  801d94:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801d98:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801d9f:	e8 4b ec ff ff       	call   8009ef <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  801da4:	89 1c 24             	mov    %ebx,(%esp)
  801da7:	e8 34 ee ff ff       	call   800be0 <fd2data>
  801dac:	89 44 24 04          	mov    %eax,0x4(%esp)
  801db0:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801db7:	e8 33 ec ff ff       	call   8009ef <sys_page_unmap>
}
  801dbc:	83 c4 14             	add    $0x14,%esp
  801dbf:	5b                   	pop    %ebx
  801dc0:	5d                   	pop    %ebp
  801dc1:	c3                   	ret    

00801dc2 <_pipeisclosed>:
	return r;
}

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  801dc2:	55                   	push   %ebp
  801dc3:	89 e5                	mov    %esp,%ebp
  801dc5:	57                   	push   %edi
  801dc6:	56                   	push   %esi
  801dc7:	53                   	push   %ebx
  801dc8:	83 ec 2c             	sub    $0x2c,%esp
  801dcb:	89 c7                	mov    %eax,%edi
  801dcd:	89 55 e4             	mov    %edx,-0x1c(%ebp)
	int n, nn, ret;

	while (1) {
		n = env->env_runs;
  801dd0:	a1 84 74 80 00       	mov    0x807484,%eax
  801dd5:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  801dd8:	89 3c 24             	mov    %edi,(%esp)
  801ddb:	e8 e0 0c 00 00       	call   802ac0 <pageref>
  801de0:	89 c6                	mov    %eax,%esi
  801de2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801de5:	89 04 24             	mov    %eax,(%esp)
  801de8:	e8 d3 0c 00 00       	call   802ac0 <pageref>
  801ded:	39 c6                	cmp    %eax,%esi
  801def:	0f 94 c0             	sete   %al
  801df2:	0f b6 c0             	movzbl %al,%eax
		nn = env->env_runs;
  801df5:	8b 15 84 74 80 00    	mov    0x807484,%edx
  801dfb:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  801dfe:	39 cb                	cmp    %ecx,%ebx
  801e00:	75 08                	jne    801e0a <_pipeisclosed+0x48>
			return ret;
		if (n != nn && ret == 1)
			cprintf("pipe race avoided\n", n, env->env_runs, ret);
	}
}
  801e02:	83 c4 2c             	add    $0x2c,%esp
  801e05:	5b                   	pop    %ebx
  801e06:	5e                   	pop    %esi
  801e07:	5f                   	pop    %edi
  801e08:	5d                   	pop    %ebp
  801e09:	c3                   	ret    
		n = env->env_runs;
		ret = pageref(fd) == pageref(p);
		nn = env->env_runs;
		if (n == nn)
			return ret;
		if (n != nn && ret == 1)
  801e0a:	83 f8 01             	cmp    $0x1,%eax
  801e0d:	75 c1                	jne    801dd0 <_pipeisclosed+0xe>
			cprintf("pipe race avoided\n", n, env->env_runs, ret);
  801e0f:	8b 52 58             	mov    0x58(%edx),%edx
  801e12:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801e16:	89 54 24 08          	mov    %edx,0x8(%esp)
  801e1a:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801e1e:	c7 04 24 36 2f 80 00 	movl   $0x802f36,(%esp)
  801e25:	e8 57 05 00 00       	call   802381 <cprintf>
  801e2a:	eb a4                	jmp    801dd0 <_pipeisclosed+0xe>

00801e2c <devpipe_write>:
	return i;
}

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  801e2c:	55                   	push   %ebp
  801e2d:	89 e5                	mov    %esp,%ebp
  801e2f:	57                   	push   %edi
  801e30:	56                   	push   %esi
  801e31:	53                   	push   %ebx
  801e32:	83 ec 1c             	sub    $0x1c,%esp
  801e35:	8b 75 08             	mov    0x8(%ebp),%esi
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  801e38:	89 34 24             	mov    %esi,(%esp)
  801e3b:	e8 a0 ed ff ff       	call   800be0 <fd2data>
  801e40:	89 c3                	mov    %eax,%ebx
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			env->env_id, vpt[VPN(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  801e42:	bf 00 00 00 00       	mov    $0x0,%edi
  801e47:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801e4b:	75 54                	jne    801ea1 <devpipe_write+0x75>
  801e4d:	eb 60                	jmp    801eaf <devpipe_write+0x83>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  801e4f:	89 da                	mov    %ebx,%edx
  801e51:	89 f0                	mov    %esi,%eax
  801e53:	e8 6a ff ff ff       	call   801dc2 <_pipeisclosed>
  801e58:	85 c0                	test   %eax,%eax
  801e5a:	74 07                	je     801e63 <devpipe_write+0x37>
  801e5c:	b8 00 00 00 00       	mov    $0x0,%eax
  801e61:	eb 53                	jmp    801eb6 <devpipe_write+0x8a>
				return 0;
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  801e63:	90                   	nop
  801e64:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  801e68:	e8 9d ec ff ff       	call   800b0a <sys_yield>
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			env->env_id, vpt[VPN(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  801e6d:	8b 43 04             	mov    0x4(%ebx),%eax
  801e70:	8b 13                	mov    (%ebx),%edx
  801e72:	83 c2 20             	add    $0x20,%edx
  801e75:	39 d0                	cmp    %edx,%eax
  801e77:	73 d6                	jae    801e4f <devpipe_write+0x23>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  801e79:	89 c2                	mov    %eax,%edx
  801e7b:	c1 fa 1f             	sar    $0x1f,%edx
  801e7e:	c1 ea 1b             	shr    $0x1b,%edx
  801e81:	01 d0                	add    %edx,%eax
  801e83:	83 e0 1f             	and    $0x1f,%eax
  801e86:	29 d0                	sub    %edx,%eax
  801e88:	89 c2                	mov    %eax,%edx
  801e8a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801e8d:	0f b6 04 39          	movzbl (%ecx,%edi,1),%eax
  801e91:	88 44 13 08          	mov    %al,0x8(%ebx,%edx,1)
		p->p_wpos++;
  801e95:	83 43 04 01          	addl   $0x1,0x4(%ebx)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			env->env_id, vpt[VPN(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  801e99:	83 c7 01             	add    $0x1,%edi
  801e9c:	39 7d 10             	cmp    %edi,0x10(%ebp)
  801e9f:	76 13                	jbe    801eb4 <devpipe_write+0x88>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  801ea1:	8b 43 04             	mov    0x4(%ebx),%eax
  801ea4:	8b 13                	mov    (%ebx),%edx
  801ea6:	83 c2 20             	add    $0x20,%edx
  801ea9:	39 d0                	cmp    %edx,%eax
  801eab:	73 a2                	jae    801e4f <devpipe_write+0x23>
  801ead:	eb ca                	jmp    801e79 <devpipe_write+0x4d>
  801eaf:	bf 00 00 00 00       	mov    $0x0,%edi
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}
	
	return i;
  801eb4:	89 f8                	mov    %edi,%eax
}
  801eb6:	83 c4 1c             	add    $0x1c,%esp
  801eb9:	5b                   	pop    %ebx
  801eba:	5e                   	pop    %esi
  801ebb:	5f                   	pop    %edi
  801ebc:	5d                   	pop    %ebp
  801ebd:	c3                   	ret    

00801ebe <devpipe_read>:
	return _pipeisclosed(fd, p);
}

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  801ebe:	55                   	push   %ebp
  801ebf:	89 e5                	mov    %esp,%ebp
  801ec1:	83 ec 28             	sub    $0x28,%esp
  801ec4:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  801ec7:	89 75 f8             	mov    %esi,-0x8(%ebp)
  801eca:	89 7d fc             	mov    %edi,-0x4(%ebp)
  801ecd:	8b 7d 08             	mov    0x8(%ebp),%edi
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  801ed0:	89 3c 24             	mov    %edi,(%esp)
  801ed3:	e8 08 ed ff ff       	call   800be0 <fd2data>
  801ed8:	89 c3                	mov    %eax,%ebx
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			env->env_id, vpt[VPN(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  801eda:	be 00 00 00 00       	mov    $0x0,%esi
  801edf:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801ee3:	75 4c                	jne    801f31 <devpipe_read+0x73>
  801ee5:	eb 5b                	jmp    801f42 <devpipe_read+0x84>
		while (p->p_rpos == p->p_wpos) {
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
				return i;
  801ee7:	89 f0                	mov    %esi,%eax
  801ee9:	eb 5e                	jmp    801f49 <devpipe_read+0x8b>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  801eeb:	89 da                	mov    %ebx,%edx
  801eed:	89 f8                	mov    %edi,%eax
  801eef:	90                   	nop
  801ef0:	e8 cd fe ff ff       	call   801dc2 <_pipeisclosed>
  801ef5:	85 c0                	test   %eax,%eax
  801ef7:	74 07                	je     801f00 <devpipe_read+0x42>
  801ef9:	b8 00 00 00 00       	mov    $0x0,%eax
  801efe:	eb 49                	jmp    801f49 <devpipe_read+0x8b>
				return 0;
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  801f00:	e8 05 ec ff ff       	call   800b0a <sys_yield>
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			env->env_id, vpt[VPN(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  801f05:	8b 03                	mov    (%ebx),%eax
  801f07:	3b 43 04             	cmp    0x4(%ebx),%eax
  801f0a:	74 df                	je     801eeb <devpipe_read+0x2d>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  801f0c:	89 c2                	mov    %eax,%edx
  801f0e:	c1 fa 1f             	sar    $0x1f,%edx
  801f11:	c1 ea 1b             	shr    $0x1b,%edx
  801f14:	01 d0                	add    %edx,%eax
  801f16:	83 e0 1f             	and    $0x1f,%eax
  801f19:	29 d0                	sub    %edx,%eax
  801f1b:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  801f20:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f23:	88 04 32             	mov    %al,(%edx,%esi,1)
		p->p_rpos++;
  801f26:	83 03 01             	addl   $0x1,(%ebx)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			env->env_id, vpt[VPN(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  801f29:	83 c6 01             	add    $0x1,%esi
  801f2c:	39 75 10             	cmp    %esi,0x10(%ebp)
  801f2f:	76 16                	jbe    801f47 <devpipe_read+0x89>
		while (p->p_rpos == p->p_wpos) {
  801f31:	8b 03                	mov    (%ebx),%eax
  801f33:	3b 43 04             	cmp    0x4(%ebx),%eax
  801f36:	75 d4                	jne    801f0c <devpipe_read+0x4e>
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  801f38:	85 f6                	test   %esi,%esi
  801f3a:	75 ab                	jne    801ee7 <devpipe_read+0x29>
  801f3c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  801f40:	eb a9                	jmp    801eeb <devpipe_read+0x2d>
  801f42:	be 00 00 00 00       	mov    $0x0,%esi
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  801f47:	89 f0                	mov    %esi,%eax
}
  801f49:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  801f4c:	8b 75 f8             	mov    -0x8(%ebp),%esi
  801f4f:	8b 7d fc             	mov    -0x4(%ebp),%edi
  801f52:	89 ec                	mov    %ebp,%esp
  801f54:	5d                   	pop    %ebp
  801f55:	c3                   	ret    

00801f56 <pipeisclosed>:
	}
}

int
pipeisclosed(int fdnum)
{
  801f56:	55                   	push   %ebp
  801f57:	89 e5                	mov    %esp,%ebp
  801f59:	83 ec 28             	sub    $0x28,%esp
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801f5c:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801f5f:	89 44 24 04          	mov    %eax,0x4(%esp)
  801f63:	8b 45 08             	mov    0x8(%ebp),%eax
  801f66:	89 04 24             	mov    %eax,(%esp)
  801f69:	e8 ff ec ff ff       	call   800c6d <fd_lookup>
  801f6e:	85 c0                	test   %eax,%eax
  801f70:	78 15                	js     801f87 <pipeisclosed+0x31>
		return r;
	p = (struct Pipe*) fd2data(fd);
  801f72:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f75:	89 04 24             	mov    %eax,(%esp)
  801f78:	e8 63 ec ff ff       	call   800be0 <fd2data>
	return _pipeisclosed(fd, p);
  801f7d:	89 c2                	mov    %eax,%edx
  801f7f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f82:	e8 3b fe ff ff       	call   801dc2 <_pipeisclosed>
}
  801f87:	c9                   	leave  
  801f88:	c3                   	ret    

00801f89 <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  801f89:	55                   	push   %ebp
  801f8a:	89 e5                	mov    %esp,%ebp
  801f8c:	83 ec 48             	sub    $0x48,%esp
  801f8f:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  801f92:	89 75 f8             	mov    %esi,-0x8(%ebp)
  801f95:	89 7d fc             	mov    %edi,-0x4(%ebp)
  801f98:	8b 7d 08             	mov    0x8(%ebp),%edi
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  801f9b:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  801f9e:	89 04 24             	mov    %eax,(%esp)
  801fa1:	e8 55 ec ff ff       	call   800bfb <fd_alloc>
  801fa6:	89 c3                	mov    %eax,%ebx
  801fa8:	85 c0                	test   %eax,%eax
  801faa:	0f 88 42 01 00 00    	js     8020f2 <pipe+0x169>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801fb0:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  801fb7:	00 
  801fb8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801fbb:	89 44 24 04          	mov    %eax,0x4(%esp)
  801fbf:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801fc6:	e8 e0 ea ff ff       	call   800aab <sys_page_alloc>
  801fcb:	89 c3                	mov    %eax,%ebx
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  801fcd:	85 c0                	test   %eax,%eax
  801fcf:	0f 88 1d 01 00 00    	js     8020f2 <pipe+0x169>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  801fd5:	8d 45 e0             	lea    -0x20(%ebp),%eax
  801fd8:	89 04 24             	mov    %eax,(%esp)
  801fdb:	e8 1b ec ff ff       	call   800bfb <fd_alloc>
  801fe0:	89 c3                	mov    %eax,%ebx
  801fe2:	85 c0                	test   %eax,%eax
  801fe4:	0f 88 f5 00 00 00    	js     8020df <pipe+0x156>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801fea:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  801ff1:	00 
  801ff2:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801ff5:	89 44 24 04          	mov    %eax,0x4(%esp)
  801ff9:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802000:	e8 a6 ea ff ff       	call   800aab <sys_page_alloc>
  802005:	89 c3                	mov    %eax,%ebx
	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  802007:	85 c0                	test   %eax,%eax
  802009:	0f 88 d0 00 00 00    	js     8020df <pipe+0x156>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  80200f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802012:	89 04 24             	mov    %eax,(%esp)
  802015:	e8 c6 eb ff ff       	call   800be0 <fd2data>
  80201a:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80201c:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  802023:	00 
  802024:	89 44 24 04          	mov    %eax,0x4(%esp)
  802028:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80202f:	e8 77 ea ff ff       	call   800aab <sys_page_alloc>
  802034:	89 c3                	mov    %eax,%ebx
  802036:	85 c0                	test   %eax,%eax
  802038:	0f 88 8e 00 00 00    	js     8020cc <pipe+0x143>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80203e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802041:	89 04 24             	mov    %eax,(%esp)
  802044:	e8 97 eb ff ff       	call   800be0 <fd2data>
  802049:	c7 44 24 10 07 04 00 	movl   $0x407,0x10(%esp)
  802050:	00 
  802051:	89 44 24 0c          	mov    %eax,0xc(%esp)
  802055:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  80205c:	00 
  80205d:	89 74 24 04          	mov    %esi,0x4(%esp)
  802061:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802068:	e8 e0 e9 ff ff       	call   800a4d <sys_page_map>
  80206d:	89 c3                	mov    %eax,%ebx
  80206f:	85 c0                	test   %eax,%eax
  802071:	78 49                	js     8020bc <pipe+0x133>
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  802073:	b8 3c 70 80 00       	mov    $0x80703c,%eax
  802078:	8b 08                	mov    (%eax),%ecx
  80207a:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80207d:	89 0a                	mov    %ecx,(%edx)
	fd0->fd_omode = O_RDONLY;
  80207f:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802082:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%edx)

	fd1->fd_dev_id = devpipe.dev_id;
  802089:	8b 10                	mov    (%eax),%edx
  80208b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80208e:	89 10                	mov    %edx,(%eax)
	fd1->fd_omode = O_WRONLY;
  802090:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802093:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", env->env_id, vpt[VPN(va)]);

	pfd[0] = fd2num(fd0);
  80209a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80209d:	89 04 24             	mov    %eax,(%esp)
  8020a0:	e8 2b eb ff ff       	call   800bd0 <fd2num>
  8020a5:	89 07                	mov    %eax,(%edi)
	pfd[1] = fd2num(fd1);
  8020a7:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8020aa:	89 04 24             	mov    %eax,(%esp)
  8020ad:	e8 1e eb ff ff       	call   800bd0 <fd2num>
  8020b2:	89 47 04             	mov    %eax,0x4(%edi)
  8020b5:	bb 00 00 00 00       	mov    $0x0,%ebx
	return 0;
  8020ba:	eb 36                	jmp    8020f2 <pipe+0x169>

    err3:
	sys_page_unmap(0, va);
  8020bc:	89 74 24 04          	mov    %esi,0x4(%esp)
  8020c0:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8020c7:	e8 23 e9 ff ff       	call   8009ef <sys_page_unmap>
    err2:
	sys_page_unmap(0, fd1);
  8020cc:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8020cf:	89 44 24 04          	mov    %eax,0x4(%esp)
  8020d3:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8020da:	e8 10 e9 ff ff       	call   8009ef <sys_page_unmap>
    err1:
	sys_page_unmap(0, fd0);
  8020df:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8020e2:	89 44 24 04          	mov    %eax,0x4(%esp)
  8020e6:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8020ed:	e8 fd e8 ff ff       	call   8009ef <sys_page_unmap>
    err:
	return r;
}
  8020f2:	89 d8                	mov    %ebx,%eax
  8020f4:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  8020f7:	8b 75 f8             	mov    -0x8(%ebp),%esi
  8020fa:	8b 7d fc             	mov    -0x4(%ebp),%edi
  8020fd:	89 ec                	mov    %ebp,%esp
  8020ff:	5d                   	pop    %ebp
  802100:	c3                   	ret    
	...

00802110 <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  802110:	55                   	push   %ebp
  802111:	89 e5                	mov    %esp,%ebp
	USED(fd);

	return 0;
}
  802113:	b8 00 00 00 00       	mov    $0x0,%eax
  802118:	5d                   	pop    %ebp
  802119:	c3                   	ret    

0080211a <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  80211a:	55                   	push   %ebp
  80211b:	89 e5                	mov    %esp,%ebp
  80211d:	83 ec 18             	sub    $0x18,%esp
	strcpy(stat->st_name, "<cons>");
  802120:	c7 44 24 04 4e 2f 80 	movl   $0x802f4e,0x4(%esp)
  802127:	00 
  802128:	8b 45 0c             	mov    0xc(%ebp),%eax
  80212b:	89 04 24             	mov    %eax,(%esp)
  80212e:	e8 87 e1 ff ff       	call   8002ba <strcpy>
	return 0;
}
  802133:	b8 00 00 00 00       	mov    $0x0,%eax
  802138:	c9                   	leave  
  802139:	c3                   	ret    

0080213a <devcons_write>:
	return 1;
}

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  80213a:	55                   	push   %ebp
  80213b:	89 e5                	mov    %esp,%ebp
  80213d:	57                   	push   %edi
  80213e:	56                   	push   %esi
  80213f:	53                   	push   %ebx
  802140:	81 ec 9c 00 00 00    	sub    $0x9c,%esp
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs, 
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  802146:	b8 00 00 00 00       	mov    $0x0,%eax
  80214b:	be 00 00 00 00       	mov    $0x0,%esi
  802150:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  802154:	74 3f                	je     802195 <devcons_write+0x5b>
		m = n - tot;
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  802156:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs, 
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
		m = n - tot;
  80215c:	8b 55 10             	mov    0x10(%ebp),%edx
  80215f:	29 c2                	sub    %eax,%edx
  802161:	89 d3                	mov    %edx,%ebx
		if (m > sizeof(buf) - 1)
  802163:	83 fa 7f             	cmp    $0x7f,%edx
  802166:	76 05                	jbe    80216d <devcons_write+0x33>
  802168:	bb 7f 00 00 00       	mov    $0x7f,%ebx
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  80216d:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  802171:	03 45 0c             	add    0xc(%ebp),%eax
  802174:	89 44 24 04          	mov    %eax,0x4(%esp)
  802178:	89 3c 24             	mov    %edi,(%esp)
  80217b:	e8 f5 e2 ff ff       	call   800475 <memmove>
		sys_cputs(buf, m);
  802180:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  802184:	89 3c 24             	mov    %edi,(%esp)
  802187:	e8 24 e5 ff ff       	call   8006b0 <sys_cputs>
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs, 
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  80218c:	01 de                	add    %ebx,%esi
  80218e:	89 f0                	mov    %esi,%eax
  802190:	3b 75 10             	cmp    0x10(%ebp),%esi
  802193:	72 c7                	jb     80215c <devcons_write+0x22>
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
}
  802195:	89 f0                	mov    %esi,%eax
  802197:	81 c4 9c 00 00 00    	add    $0x9c,%esp
  80219d:	5b                   	pop    %ebx
  80219e:	5e                   	pop    %esi
  80219f:	5f                   	pop    %edi
  8021a0:	5d                   	pop    %ebp
  8021a1:	c3                   	ret    

008021a2 <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  8021a2:	55                   	push   %ebp
  8021a3:	89 e5                	mov    %esp,%ebp
  8021a5:	83 ec 28             	sub    $0x28,%esp
	char c = ch;
  8021a8:	8b 45 08             	mov    0x8(%ebp),%eax
  8021ab:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  8021ae:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  8021b5:	00 
  8021b6:	8d 45 f7             	lea    -0x9(%ebp),%eax
  8021b9:	89 04 24             	mov    %eax,(%esp)
  8021bc:	e8 ef e4 ff ff       	call   8006b0 <sys_cputs>
}
  8021c1:	c9                   	leave  
  8021c2:	c3                   	ret    

008021c3 <devcons_read>:
	return fd2num(fd);
}

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  8021c3:	55                   	push   %ebp
  8021c4:	89 e5                	mov    %esp,%ebp
  8021c6:	83 ec 08             	sub    $0x8,%esp
	int c;

	if (n == 0)
  8021c9:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8021cd:	75 07                	jne    8021d6 <devcons_read+0x13>
  8021cf:	eb 28                	jmp    8021f9 <devcons_read+0x36>
		return 0;

	while ((c = sys_cgetc()) == 0)
		sys_yield();
  8021d1:	e8 34 e9 ff ff       	call   800b0a <sys_yield>
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  8021d6:	66 90                	xchg   %ax,%ax
  8021d8:	e8 9f e4 ff ff       	call   80067c <sys_cgetc>
  8021dd:	85 c0                	test   %eax,%eax
  8021df:	90                   	nop
  8021e0:	74 ef                	je     8021d1 <devcons_read+0xe>
  8021e2:	89 c2                	mov    %eax,%edx
		sys_yield();
	if (c < 0)
  8021e4:	85 c0                	test   %eax,%eax
  8021e6:	78 16                	js     8021fe <devcons_read+0x3b>
		return c;
	if (c == 0x04)	// ctl-d is eof
  8021e8:	83 f8 04             	cmp    $0x4,%eax
  8021eb:	74 0c                	je     8021f9 <devcons_read+0x36>
		return 0;
	*(char*)vbuf = c;
  8021ed:	8b 45 0c             	mov    0xc(%ebp),%eax
  8021f0:	88 10                	mov    %dl,(%eax)
  8021f2:	b8 01 00 00 00       	mov    $0x1,%eax
	return 1;
  8021f7:	eb 05                	jmp    8021fe <devcons_read+0x3b>
  8021f9:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8021fe:	c9                   	leave  
  8021ff:	c3                   	ret    

00802200 <opencons>:
	return fd->fd_dev_id == devcons.dev_id;
}

int
opencons(void)
{
  802200:	55                   	push   %ebp
  802201:	89 e5                	mov    %esp,%ebp
  802203:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  802206:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802209:	89 04 24             	mov    %eax,(%esp)
  80220c:	e8 ea e9 ff ff       	call   800bfb <fd_alloc>
  802211:	85 c0                	test   %eax,%eax
  802213:	78 3f                	js     802254 <opencons+0x54>
		return r;
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  802215:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  80221c:	00 
  80221d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802220:	89 44 24 04          	mov    %eax,0x4(%esp)
  802224:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80222b:	e8 7b e8 ff ff       	call   800aab <sys_page_alloc>
  802230:	85 c0                	test   %eax,%eax
  802232:	78 20                	js     802254 <opencons+0x54>
		return r;
	fd->fd_dev_id = devcons.dev_id;
  802234:	8b 15 58 70 80 00    	mov    0x807058,%edx
  80223a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80223d:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  80223f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802242:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  802249:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80224c:	89 04 24             	mov    %eax,(%esp)
  80224f:	e8 7c e9 ff ff       	call   800bd0 <fd2num>
}
  802254:	c9                   	leave  
  802255:	c3                   	ret    

00802256 <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  802256:	55                   	push   %ebp
  802257:	89 e5                	mov    %esp,%ebp
  802259:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80225c:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80225f:	89 44 24 04          	mov    %eax,0x4(%esp)
  802263:	8b 45 08             	mov    0x8(%ebp),%eax
  802266:	89 04 24             	mov    %eax,(%esp)
  802269:	e8 ff e9 ff ff       	call   800c6d <fd_lookup>
  80226e:	85 c0                	test   %eax,%eax
  802270:	78 11                	js     802283 <iscons+0x2d>
		return r;
	return fd->fd_dev_id == devcons.dev_id;
  802272:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802275:	8b 00                	mov    (%eax),%eax
  802277:	3b 05 58 70 80 00    	cmp    0x807058,%eax
  80227d:	0f 94 c0             	sete   %al
  802280:	0f b6 c0             	movzbl %al,%eax
}
  802283:	c9                   	leave  
  802284:	c3                   	ret    

00802285 <getchar>:
	sys_cputs(&c, 1);
}

int
getchar(void)
{
  802285:	55                   	push   %ebp
  802286:	89 e5                	mov    %esp,%ebp
  802288:	83 ec 28             	sub    $0x28,%esp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  80228b:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  802292:	00 
  802293:	8d 45 f7             	lea    -0x9(%ebp),%eax
  802296:	89 44 24 04          	mov    %eax,0x4(%esp)
  80229a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8022a1:	e8 28 ec ff ff       	call   800ece <read>
	if (r < 0)
  8022a6:	85 c0                	test   %eax,%eax
  8022a8:	78 0f                	js     8022b9 <getchar+0x34>
		return r;
	if (r < 1)
  8022aa:	85 c0                	test   %eax,%eax
  8022ac:	7f 07                	jg     8022b5 <getchar+0x30>
  8022ae:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  8022b3:	eb 04                	jmp    8022b9 <getchar+0x34>
		return -E_EOF;
	return c;
  8022b5:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  8022b9:	c9                   	leave  
  8022ba:	c3                   	ret    
	...

008022bc <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  8022bc:	55                   	push   %ebp
  8022bd:	89 e5                	mov    %esp,%ebp
  8022bf:	53                   	push   %ebx
  8022c0:	83 ec 14             	sub    $0x14,%esp
 * Panic is called on unresolvable fatal errors.
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
  8022c3:	8d 5d 14             	lea    0x14(%ebp),%ebx
	va_list ap;

	va_start(ap, fmt);

	// Print the panic message
	if (argv0)
  8022c6:	a1 88 74 80 00       	mov    0x807488,%eax
  8022cb:	85 c0                	test   %eax,%eax
  8022cd:	74 10                	je     8022df <_panic+0x23>
		cprintf("%s: ", argv0);
  8022cf:	89 44 24 04          	mov    %eax,0x4(%esp)
  8022d3:	c7 04 24 5a 2f 80 00 	movl   $0x802f5a,(%esp)
  8022da:	e8 a2 00 00 00       	call   802381 <cprintf>
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  8022df:	8b 45 0c             	mov    0xc(%ebp),%eax
  8022e2:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8022e6:	8b 45 08             	mov    0x8(%ebp),%eax
  8022e9:	89 44 24 08          	mov    %eax,0x8(%esp)
  8022ed:	a1 00 70 80 00       	mov    0x807000,%eax
  8022f2:	89 44 24 04          	mov    %eax,0x4(%esp)
  8022f6:	c7 04 24 5f 2f 80 00 	movl   $0x802f5f,(%esp)
  8022fd:	e8 7f 00 00 00       	call   802381 <cprintf>
	vcprintf(fmt, ap);
  802302:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  802306:	8b 45 10             	mov    0x10(%ebp),%eax
  802309:	89 04 24             	mov    %eax,(%esp)
  80230c:	e8 0f 00 00 00       	call   802320 <vcprintf>
	cprintf("\n");
  802311:	c7 04 24 47 2f 80 00 	movl   $0x802f47,(%esp)
  802318:	e8 64 00 00 00       	call   802381 <cprintf>

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  80231d:	cc                   	int3   
  80231e:	eb fd                	jmp    80231d <_panic+0x61>

00802320 <vcprintf>:
	b->cnt++;
}

int
vcprintf(const char *fmt, va_list ap)
{
  802320:	55                   	push   %ebp
  802321:	89 e5                	mov    %esp,%ebp
  802323:	81 ec 28 01 00 00    	sub    $0x128,%esp
	struct printbuf b;

	b.idx = 0;
  802329:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  802330:	00 00 00 
	b.cnt = 0;
  802333:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  80233a:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  80233d:	8b 45 0c             	mov    0xc(%ebp),%eax
  802340:	89 44 24 0c          	mov    %eax,0xc(%esp)
  802344:	8b 45 08             	mov    0x8(%ebp),%eax
  802347:	89 44 24 08          	mov    %eax,0x8(%esp)
  80234b:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  802351:	89 44 24 04          	mov    %eax,0x4(%esp)
  802355:	c7 04 24 9b 23 80 00 	movl   $0x80239b,(%esp)
  80235c:	e8 cc 01 00 00       	call   80252d <vprintfmt>
	sys_cputs(b.buf, b.idx);
  802361:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
  802367:	89 44 24 04          	mov    %eax,0x4(%esp)
  80236b:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  802371:	89 04 24             	mov    %eax,(%esp)
  802374:	e8 37 e3 ff ff       	call   8006b0 <sys_cputs>

	return b.cnt;
}
  802379:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  80237f:	c9                   	leave  
  802380:	c3                   	ret    

00802381 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  802381:	55                   	push   %ebp
  802382:	89 e5                	mov    %esp,%ebp
  802384:	83 ec 18             	sub    $0x18,%esp

	return b.cnt;
}

int
cprintf(const char *fmt, ...)
  802387:	8d 45 0c             	lea    0xc(%ebp),%eax
{
	va_list ap;
	int cnt;

	va_start(ap, fmt);
	cnt = vcprintf(fmt, ap);
  80238a:	89 44 24 04          	mov    %eax,0x4(%esp)
  80238e:	8b 45 08             	mov    0x8(%ebp),%eax
  802391:	89 04 24             	mov    %eax,(%esp)
  802394:	e8 87 ff ff ff       	call   802320 <vcprintf>
	va_end(ap);

	return cnt;
}
  802399:	c9                   	leave  
  80239a:	c3                   	ret    

0080239b <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  80239b:	55                   	push   %ebp
  80239c:	89 e5                	mov    %esp,%ebp
  80239e:	53                   	push   %ebx
  80239f:	83 ec 14             	sub    $0x14,%esp
  8023a2:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  8023a5:	8b 03                	mov    (%ebx),%eax
  8023a7:	8b 55 08             	mov    0x8(%ebp),%edx
  8023aa:	88 54 03 08          	mov    %dl,0x8(%ebx,%eax,1)
  8023ae:	83 c0 01             	add    $0x1,%eax
  8023b1:	89 03                	mov    %eax,(%ebx)
	if (b->idx == 256-1) {
  8023b3:	3d ff 00 00 00       	cmp    $0xff,%eax
  8023b8:	75 19                	jne    8023d3 <putch+0x38>
		sys_cputs(b->buf, b->idx);
  8023ba:	c7 44 24 04 ff 00 00 	movl   $0xff,0x4(%esp)
  8023c1:	00 
  8023c2:	8d 43 08             	lea    0x8(%ebx),%eax
  8023c5:	89 04 24             	mov    %eax,(%esp)
  8023c8:	e8 e3 e2 ff ff       	call   8006b0 <sys_cputs>
		b->idx = 0;
  8023cd:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
	}
	b->cnt++;
  8023d3:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  8023d7:	83 c4 14             	add    $0x14,%esp
  8023da:	5b                   	pop    %ebx
  8023db:	5d                   	pop    %ebp
  8023dc:	c3                   	ret    
  8023dd:	00 00                	add    %al,(%eax)
	...

008023e0 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8023e0:	55                   	push   %ebp
  8023e1:	89 e5                	mov    %esp,%ebp
  8023e3:	57                   	push   %edi
  8023e4:	56                   	push   %esi
  8023e5:	53                   	push   %ebx
  8023e6:	83 ec 4c             	sub    $0x4c,%esp
  8023e9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8023ec:	89 d6                	mov    %edx,%esi
  8023ee:	8b 45 08             	mov    0x8(%ebp),%eax
  8023f1:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8023f4:	8b 55 0c             	mov    0xc(%ebp),%edx
  8023f7:	89 55 e0             	mov    %edx,-0x20(%ebp)
  8023fa:	8b 45 10             	mov    0x10(%ebp),%eax
  8023fd:	8b 5d 14             	mov    0x14(%ebp),%ebx
  802400:	8b 7d 18             	mov    0x18(%ebp),%edi
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  802403:	89 45 dc             	mov    %eax,-0x24(%ebp)
  802406:	b9 00 00 00 00       	mov    $0x0,%ecx
  80240b:	39 d1                	cmp    %edx,%ecx
  80240d:	72 15                	jb     802424 <printnum+0x44>
  80240f:	77 07                	ja     802418 <printnum+0x38>
  802411:	8b 55 d8             	mov    -0x28(%ebp),%edx
  802414:	39 d0                	cmp    %edx,%eax
  802416:	76 0c                	jbe    802424 <printnum+0x44>
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  802418:	83 eb 01             	sub    $0x1,%ebx
  80241b:	85 db                	test   %ebx,%ebx
  80241d:	8d 76 00             	lea    0x0(%esi),%esi
  802420:	7f 61                	jg     802483 <printnum+0xa3>
  802422:	eb 70                	jmp    802494 <printnum+0xb4>
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
  802424:	89 7c 24 10          	mov    %edi,0x10(%esp)
  802428:	83 eb 01             	sub    $0x1,%ebx
  80242b:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  80242f:	89 44 24 08          	mov    %eax,0x8(%esp)
  802433:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  802437:	8b 5c 24 0c          	mov    0xc(%esp),%ebx
  80243b:	89 4d d0             	mov    %ecx,-0x30(%ebp)
  80243e:	89 5d d4             	mov    %ebx,-0x2c(%ebp)
  802441:	8b 5d dc             	mov    -0x24(%ebp),%ebx
  802444:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  802448:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  80244f:	00 
  802450:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802453:	89 04 24             	mov    %eax,(%esp)
  802456:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802459:	89 54 24 04          	mov    %edx,0x4(%esp)
  80245d:	e8 ae 06 00 00       	call   802b10 <__udivdi3>
  802462:	8b 4d d0             	mov    -0x30(%ebp),%ecx
  802465:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
  802468:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  80246c:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  802470:	89 04 24             	mov    %eax,(%esp)
  802473:	89 54 24 04          	mov    %edx,0x4(%esp)
  802477:	89 f2                	mov    %esi,%edx
  802479:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80247c:	e8 5f ff ff ff       	call   8023e0 <printnum>
  802481:	eb 11                	jmp    802494 <printnum+0xb4>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  802483:	89 74 24 04          	mov    %esi,0x4(%esp)
  802487:	89 3c 24             	mov    %edi,(%esp)
  80248a:	ff 55 e4             	call   *-0x1c(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  80248d:	83 eb 01             	sub    $0x1,%ebx
  802490:	85 db                	test   %ebx,%ebx
  802492:	7f ef                	jg     802483 <printnum+0xa3>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  802494:	89 74 24 04          	mov    %esi,0x4(%esp)
  802498:	8b 74 24 04          	mov    0x4(%esp),%esi
  80249c:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80249f:	89 44 24 08          	mov    %eax,0x8(%esp)
  8024a3:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  8024aa:	00 
  8024ab:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8024ae:	89 14 24             	mov    %edx,(%esp)
  8024b1:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  8024b4:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8024b8:	e8 83 07 00 00       	call   802c40 <__umoddi3>
  8024bd:	89 74 24 04          	mov    %esi,0x4(%esp)
  8024c1:	0f be 80 7b 2f 80 00 	movsbl 0x802f7b(%eax),%eax
  8024c8:	89 04 24             	mov    %eax,(%esp)
  8024cb:	ff 55 e4             	call   *-0x1c(%ebp)
}
  8024ce:	83 c4 4c             	add    $0x4c,%esp
  8024d1:	5b                   	pop    %ebx
  8024d2:	5e                   	pop    %esi
  8024d3:	5f                   	pop    %edi
  8024d4:	5d                   	pop    %ebp
  8024d5:	c3                   	ret    

008024d6 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  8024d6:	55                   	push   %ebp
  8024d7:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8024d9:	83 fa 01             	cmp    $0x1,%edx
  8024dc:	7e 0e                	jle    8024ec <getuint+0x16>
		return va_arg(*ap, unsigned long long);
  8024de:	8b 10                	mov    (%eax),%edx
  8024e0:	8d 4a 08             	lea    0x8(%edx),%ecx
  8024e3:	89 08                	mov    %ecx,(%eax)
  8024e5:	8b 02                	mov    (%edx),%eax
  8024e7:	8b 52 04             	mov    0x4(%edx),%edx
  8024ea:	eb 22                	jmp    80250e <getuint+0x38>
	else if (lflag)
  8024ec:	85 d2                	test   %edx,%edx
  8024ee:	74 10                	je     802500 <getuint+0x2a>
		return va_arg(*ap, unsigned long);
  8024f0:	8b 10                	mov    (%eax),%edx
  8024f2:	8d 4a 04             	lea    0x4(%edx),%ecx
  8024f5:	89 08                	mov    %ecx,(%eax)
  8024f7:	8b 02                	mov    (%edx),%eax
  8024f9:	ba 00 00 00 00       	mov    $0x0,%edx
  8024fe:	eb 0e                	jmp    80250e <getuint+0x38>
	else
		return va_arg(*ap, unsigned int);
  802500:	8b 10                	mov    (%eax),%edx
  802502:	8d 4a 04             	lea    0x4(%edx),%ecx
  802505:	89 08                	mov    %ecx,(%eax)
  802507:	8b 02                	mov    (%edx),%eax
  802509:	ba 00 00 00 00       	mov    $0x0,%edx
}
  80250e:	5d                   	pop    %ebp
  80250f:	c3                   	ret    

00802510 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  802510:	55                   	push   %ebp
  802511:	89 e5                	mov    %esp,%ebp
  802513:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  802516:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  80251a:	8b 10                	mov    (%eax),%edx
  80251c:	3b 50 04             	cmp    0x4(%eax),%edx
  80251f:	73 0a                	jae    80252b <sprintputch+0x1b>
		*b->buf++ = ch;
  802521:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802524:	88 0a                	mov    %cl,(%edx)
  802526:	83 c2 01             	add    $0x1,%edx
  802529:	89 10                	mov    %edx,(%eax)
}
  80252b:	5d                   	pop    %ebp
  80252c:	c3                   	ret    

0080252d <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  80252d:	55                   	push   %ebp
  80252e:	89 e5                	mov    %esp,%ebp
  802530:	57                   	push   %edi
  802531:	56                   	push   %esi
  802532:	53                   	push   %ebx
  802533:	83 ec 5c             	sub    $0x5c,%esp
  802536:	8b 7d 08             	mov    0x8(%ebp),%edi
  802539:	8b 75 0c             	mov    0xc(%ebp),%esi
  80253c:	8b 5d 10             	mov    0x10(%ebp),%ebx
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  80253f:	c7 45 c8 ff ff ff ff 	movl   $0xffffffff,-0x38(%ebp)
  802546:	eb 11                	jmp    802559 <vprintfmt+0x2c>
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
  802548:	85 c0                	test   %eax,%eax
  80254a:	0f 84 ec 03 00 00    	je     80293c <vprintfmt+0x40f>
				return;
			putch(ch, putdat);
  802550:	89 74 24 04          	mov    %esi,0x4(%esp)
  802554:	89 04 24             	mov    %eax,(%esp)
  802557:	ff d7                	call   *%edi
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  802559:	0f b6 03             	movzbl (%ebx),%eax
  80255c:	83 c3 01             	add    $0x1,%ebx
  80255f:	83 f8 25             	cmp    $0x25,%eax
  802562:	75 e4                	jne    802548 <vprintfmt+0x1b>
  802564:	c6 45 d4 20          	movb   $0x20,-0x2c(%ebp)
  802568:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
  80256f:	c7 45 d0 ff ff ff ff 	movl   $0xffffffff,-0x30(%ebp)
  802576:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
  80257d:	b9 00 00 00 00       	mov    $0x0,%ecx
  802582:	eb 06                	jmp    80258a <vprintfmt+0x5d>
  802584:	c6 45 d4 2d          	movb   $0x2d,-0x2c(%ebp)
  802588:	89 c3                	mov    %eax,%ebx
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80258a:	0f b6 13             	movzbl (%ebx),%edx
  80258d:	0f b6 c2             	movzbl %dl,%eax
  802590:	89 45 e0             	mov    %eax,-0x20(%ebp)
  802593:	8d 43 01             	lea    0x1(%ebx),%eax
  802596:	83 ea 23             	sub    $0x23,%edx
  802599:	80 fa 55             	cmp    $0x55,%dl
  80259c:	0f 87 7d 03 00 00    	ja     80291f <vprintfmt+0x3f2>
  8025a2:	0f b6 d2             	movzbl %dl,%edx
  8025a5:	ff 24 95 c0 30 80 00 	jmp    *0x8030c0(,%edx,4)
  8025ac:	c6 45 d4 30          	movb   $0x30,-0x2c(%ebp)
  8025b0:	eb d6                	jmp    802588 <vprintfmt+0x5b>
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
				precision = precision * 10 + ch - '0';
  8025b2:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8025b5:	83 ea 30             	sub    $0x30,%edx
  8025b8:	89 55 d0             	mov    %edx,-0x30(%ebp)
				ch = *fmt;
  8025bb:	0f be 10             	movsbl (%eax),%edx
				if (ch < '0' || ch > '9')
  8025be:	8d 5a d0             	lea    -0x30(%edx),%ebx
  8025c1:	83 fb 09             	cmp    $0x9,%ebx
  8025c4:	77 4c                	ja     802612 <vprintfmt+0xe5>
  8025c6:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  8025c9:	8b 4d d0             	mov    -0x30(%ebp),%ecx
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8025cc:	83 c0 01             	add    $0x1,%eax
				precision = precision * 10 + ch - '0';
  8025cf:	8d 0c 89             	lea    (%ecx,%ecx,4),%ecx
  8025d2:	8d 4c 4a d0          	lea    -0x30(%edx,%ecx,2),%ecx
				ch = *fmt;
  8025d6:	0f be 10             	movsbl (%eax),%edx
				if (ch < '0' || ch > '9')
  8025d9:	8d 5a d0             	lea    -0x30(%edx),%ebx
  8025dc:	83 fb 09             	cmp    $0x9,%ebx
  8025df:	76 eb                	jbe    8025cc <vprintfmt+0x9f>
  8025e1:	89 4d d0             	mov    %ecx,-0x30(%ebp)
  8025e4:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  8025e7:	eb 29                	jmp    802612 <vprintfmt+0xe5>
					break;
			}
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  8025e9:	8b 55 14             	mov    0x14(%ebp),%edx
  8025ec:	8d 5a 04             	lea    0x4(%edx),%ebx
  8025ef:	89 5d 14             	mov    %ebx,0x14(%ebp)
  8025f2:	8b 12                	mov    (%edx),%edx
  8025f4:	89 55 d0             	mov    %edx,-0x30(%ebp)
			goto process_precision;
  8025f7:	eb 19                	jmp    802612 <vprintfmt+0xe5>

		case '.':
			if (width < 0)
  8025f9:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8025fc:	c1 fa 1f             	sar    $0x1f,%edx
  8025ff:	f7 d2                	not    %edx
  802601:	21 55 e4             	and    %edx,-0x1c(%ebp)
  802604:	eb 82                	jmp    802588 <vprintfmt+0x5b>
  802606:	c7 45 d8 01 00 00 00 	movl   $0x1,-0x28(%ebp)
				width = 0;
			goto reswitch;

		case '#':
			altflag = 1;
			goto reswitch;
  80260d:	e9 76 ff ff ff       	jmp    802588 <vprintfmt+0x5b>

		process_precision:
			if (width < 0)
  802612:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  802616:	0f 89 6c ff ff ff    	jns    802588 <vprintfmt+0x5b>
  80261c:	8b 55 d0             	mov    -0x30(%ebp),%edx
  80261f:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  802622:	8b 55 c8             	mov    -0x38(%ebp),%edx
  802625:	89 55 d0             	mov    %edx,-0x30(%ebp)
  802628:	e9 5b ff ff ff       	jmp    802588 <vprintfmt+0x5b>
				width = precision, precision = -1;
			goto reswitch;

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  80262d:	83 c1 01             	add    $0x1,%ecx
			goto reswitch;
  802630:	e9 53 ff ff ff       	jmp    802588 <vprintfmt+0x5b>
  802635:	89 45 cc             	mov    %eax,-0x34(%ebp)

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  802638:	8b 45 14             	mov    0x14(%ebp),%eax
  80263b:	8d 50 04             	lea    0x4(%eax),%edx
  80263e:	89 55 14             	mov    %edx,0x14(%ebp)
  802641:	89 74 24 04          	mov    %esi,0x4(%esp)
  802645:	8b 00                	mov    (%eax),%eax
  802647:	89 04 24             	mov    %eax,(%esp)
  80264a:	ff d7                	call   *%edi
  80264c:	8b 5d cc             	mov    -0x34(%ebp),%ebx
			break;
  80264f:	e9 05 ff ff ff       	jmp    802559 <vprintfmt+0x2c>
  802654:	89 45 cc             	mov    %eax,-0x34(%ebp)

		// error message
		case 'e':
			err = va_arg(ap, int);
  802657:	8b 45 14             	mov    0x14(%ebp),%eax
  80265a:	8d 50 04             	lea    0x4(%eax),%edx
  80265d:	89 55 14             	mov    %edx,0x14(%ebp)
  802660:	8b 00                	mov    (%eax),%eax
  802662:	89 c2                	mov    %eax,%edx
  802664:	c1 fa 1f             	sar    $0x1f,%edx
  802667:	31 d0                	xor    %edx,%eax
  802669:	29 d0                	sub    %edx,%eax
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  80266b:	83 f8 0f             	cmp    $0xf,%eax
  80266e:	7f 0b                	jg     80267b <vprintfmt+0x14e>
  802670:	8b 14 85 20 32 80 00 	mov    0x803220(,%eax,4),%edx
  802677:	85 d2                	test   %edx,%edx
  802679:	75 20                	jne    80269b <vprintfmt+0x16e>
				printfmt(putch, putdat, "error %d", err);
  80267b:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80267f:	c7 44 24 08 8c 2f 80 	movl   $0x802f8c,0x8(%esp)
  802686:	00 
  802687:	89 74 24 04          	mov    %esi,0x4(%esp)
  80268b:	89 3c 24             	mov    %edi,(%esp)
  80268e:	e8 31 03 00 00       	call   8029c4 <printfmt>
  802693:	8b 5d cc             	mov    -0x34(%ebp),%ebx
		// error message
		case 'e':
			err = va_arg(ap, int);
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  802696:	e9 be fe ff ff       	jmp    802559 <vprintfmt+0x2c>
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  80269b:	89 54 24 0c          	mov    %edx,0xc(%esp)
  80269f:	c7 44 24 08 b6 2e 80 	movl   $0x802eb6,0x8(%esp)
  8026a6:	00 
  8026a7:	89 74 24 04          	mov    %esi,0x4(%esp)
  8026ab:	89 3c 24             	mov    %edi,(%esp)
  8026ae:	e8 11 03 00 00       	call   8029c4 <printfmt>
  8026b3:	8b 5d cc             	mov    -0x34(%ebp),%ebx
  8026b6:	e9 9e fe ff ff       	jmp    802559 <vprintfmt+0x2c>
  8026bb:	89 45 cc             	mov    %eax,-0x34(%ebp)
  8026be:	89 c3                	mov    %eax,%ebx
  8026c0:	8b 4d d0             	mov    -0x30(%ebp),%ecx
  8026c3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8026c6:	89 45 c4             	mov    %eax,-0x3c(%ebp)
			break;

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  8026c9:	8b 45 14             	mov    0x14(%ebp),%eax
  8026cc:	8d 50 04             	lea    0x4(%eax),%edx
  8026cf:	89 55 14             	mov    %edx,0x14(%ebp)
  8026d2:	8b 00                	mov    (%eax),%eax
  8026d4:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8026d7:	85 c0                	test   %eax,%eax
  8026d9:	75 07                	jne    8026e2 <vprintfmt+0x1b5>
  8026db:	c7 45 e0 95 2f 80 00 	movl   $0x802f95,-0x20(%ebp)
				p = "(null)";
			if (width > 0 && padc != '-')
  8026e2:	83 7d c4 00          	cmpl   $0x0,-0x3c(%ebp)
  8026e6:	7e 06                	jle    8026ee <vprintfmt+0x1c1>
  8026e8:	80 7d d4 2d          	cmpb   $0x2d,-0x2c(%ebp)
  8026ec:	75 13                	jne    802701 <vprintfmt+0x1d4>
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8026ee:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8026f1:	0f be 02             	movsbl (%edx),%eax
  8026f4:	85 c0                	test   %eax,%eax
  8026f6:	0f 85 99 00 00 00    	jne    802795 <vprintfmt+0x268>
  8026fc:	e9 86 00 00 00       	jmp    802787 <vprintfmt+0x25a>
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  802701:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  802705:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  802708:	89 0c 24             	mov    %ecx,(%esp)
  80270b:	e8 7b db ff ff       	call   80028b <strnlen>
  802710:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  802713:	29 c2                	sub    %eax,%edx
  802715:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  802718:	85 d2                	test   %edx,%edx
  80271a:	7e d2                	jle    8026ee <vprintfmt+0x1c1>
					putch(padc, putdat);
  80271c:	0f be 4d d4          	movsbl -0x2c(%ebp),%ecx
  802720:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  802723:	89 5d c4             	mov    %ebx,-0x3c(%ebp)
  802726:	89 d3                	mov    %edx,%ebx
  802728:	89 74 24 04          	mov    %esi,0x4(%esp)
  80272c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80272f:	89 04 24             	mov    %eax,(%esp)
  802732:	ff d7                	call   *%edi
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  802734:	83 eb 01             	sub    $0x1,%ebx
  802737:	85 db                	test   %ebx,%ebx
  802739:	7f ed                	jg     802728 <vprintfmt+0x1fb>
  80273b:	8b 5d c4             	mov    -0x3c(%ebp),%ebx
  80273e:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  802745:	eb a7                	jmp    8026ee <vprintfmt+0x1c1>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
  802747:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  80274b:	74 18                	je     802765 <vprintfmt+0x238>
  80274d:	8d 50 e0             	lea    -0x20(%eax),%edx
  802750:	83 fa 5e             	cmp    $0x5e,%edx
  802753:	76 10                	jbe    802765 <vprintfmt+0x238>
					putch('?', putdat);
  802755:	89 7c 24 04          	mov    %edi,0x4(%esp)
  802759:	c7 04 24 3f 00 00 00 	movl   $0x3f,(%esp)
  802760:	ff 55 e0             	call   *-0x20(%ebp)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
  802763:	eb 0a                	jmp    80276f <vprintfmt+0x242>
					putch('?', putdat);
				else
					putch(ch, putdat);
  802765:	89 7c 24 04          	mov    %edi,0x4(%esp)
  802769:	89 04 24             	mov    %eax,(%esp)
  80276c:	ff 55 e0             	call   *-0x20(%ebp)
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  80276f:	83 6d e4 01          	subl   $0x1,-0x1c(%ebp)
  802773:	0f be 03             	movsbl (%ebx),%eax
  802776:	85 c0                	test   %eax,%eax
  802778:	74 05                	je     80277f <vprintfmt+0x252>
  80277a:	83 c3 01             	add    $0x1,%ebx
  80277d:	eb 29                	jmp    8027a8 <vprintfmt+0x27b>
  80277f:	89 fe                	mov    %edi,%esi
  802781:	8b 7d e0             	mov    -0x20(%ebp),%edi
  802784:	8b 5d d0             	mov    -0x30(%ebp),%ebx
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  802787:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80278b:	7f 2e                	jg     8027bb <vprintfmt+0x28e>
  80278d:	8b 5d cc             	mov    -0x34(%ebp),%ebx
  802790:	e9 c4 fd ff ff       	jmp    802559 <vprintfmt+0x2c>
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  802795:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802798:	83 c2 01             	add    $0x1,%edx
  80279b:	89 7d e0             	mov    %edi,-0x20(%ebp)
  80279e:	89 f7                	mov    %esi,%edi
  8027a0:	8b 75 d0             	mov    -0x30(%ebp),%esi
  8027a3:	89 5d d0             	mov    %ebx,-0x30(%ebp)
  8027a6:	89 d3                	mov    %edx,%ebx
  8027a8:	85 f6                	test   %esi,%esi
  8027aa:	78 9b                	js     802747 <vprintfmt+0x21a>
  8027ac:	83 ee 01             	sub    $0x1,%esi
  8027af:	79 96                	jns    802747 <vprintfmt+0x21a>
  8027b1:	89 fe                	mov    %edi,%esi
  8027b3:	8b 7d e0             	mov    -0x20(%ebp),%edi
  8027b6:	8b 5d d0             	mov    -0x30(%ebp),%ebx
  8027b9:	eb cc                	jmp    802787 <vprintfmt+0x25a>
  8027bb:	89 5d d8             	mov    %ebx,-0x28(%ebp)
  8027be:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
				putch(' ', putdat);
  8027c1:	89 74 24 04          	mov    %esi,0x4(%esp)
  8027c5:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  8027cc:	ff d7                	call   *%edi
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  8027ce:	83 eb 01             	sub    $0x1,%ebx
  8027d1:	85 db                	test   %ebx,%ebx
  8027d3:	7f ec                	jg     8027c1 <vprintfmt+0x294>
  8027d5:	8b 5d d8             	mov    -0x28(%ebp),%ebx
  8027d8:	e9 7c fd ff ff       	jmp    802559 <vprintfmt+0x2c>
  8027dd:	89 45 cc             	mov    %eax,-0x34(%ebp)
// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
	if (lflag >= 2)
  8027e0:	83 f9 01             	cmp    $0x1,%ecx
  8027e3:	7e 16                	jle    8027fb <vprintfmt+0x2ce>
		return va_arg(*ap, long long);
  8027e5:	8b 45 14             	mov    0x14(%ebp),%eax
  8027e8:	8d 50 08             	lea    0x8(%eax),%edx
  8027eb:	89 55 14             	mov    %edx,0x14(%ebp)
  8027ee:	8b 10                	mov    (%eax),%edx
  8027f0:	8b 48 04             	mov    0x4(%eax),%ecx
  8027f3:	89 55 d8             	mov    %edx,-0x28(%ebp)
  8027f6:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  8027f9:	eb 32                	jmp    80282d <vprintfmt+0x300>
	else if (lflag)
  8027fb:	85 c9                	test   %ecx,%ecx
  8027fd:	74 18                	je     802817 <vprintfmt+0x2ea>
		return va_arg(*ap, long);
  8027ff:	8b 45 14             	mov    0x14(%ebp),%eax
  802802:	8d 50 04             	lea    0x4(%eax),%edx
  802805:	89 55 14             	mov    %edx,0x14(%ebp)
  802808:	8b 00                	mov    (%eax),%eax
  80280a:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80280d:	89 c1                	mov    %eax,%ecx
  80280f:	c1 f9 1f             	sar    $0x1f,%ecx
  802812:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  802815:	eb 16                	jmp    80282d <vprintfmt+0x300>
	else
		return va_arg(*ap, int);
  802817:	8b 45 14             	mov    0x14(%ebp),%eax
  80281a:	8d 50 04             	lea    0x4(%eax),%edx
  80281d:	89 55 14             	mov    %edx,0x14(%ebp)
  802820:	8b 00                	mov    (%eax),%eax
  802822:	89 45 d8             	mov    %eax,-0x28(%ebp)
  802825:	89 c2                	mov    %eax,%edx
  802827:	c1 fa 1f             	sar    $0x1f,%edx
  80282a:	89 55 dc             	mov    %edx,-0x24(%ebp)
				putch(' ', putdat);
			break;

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  80282d:	8b 4d d8             	mov    -0x28(%ebp),%ecx
  802830:	8b 5d dc             	mov    -0x24(%ebp),%ebx
  802833:	b8 0a 00 00 00       	mov    $0xa,%eax
			if ((long long) num < 0) {
  802838:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  80283c:	0f 89 9b 00 00 00    	jns    8028dd <vprintfmt+0x3b0>
				putch('-', putdat);
  802842:	89 74 24 04          	mov    %esi,0x4(%esp)
  802846:	c7 04 24 2d 00 00 00 	movl   $0x2d,(%esp)
  80284d:	ff d7                	call   *%edi
				num = -(long long) num;
  80284f:	8b 4d d8             	mov    -0x28(%ebp),%ecx
  802852:	8b 5d dc             	mov    -0x24(%ebp),%ebx
  802855:	f7 d9                	neg    %ecx
  802857:	83 d3 00             	adc    $0x0,%ebx
  80285a:	f7 db                	neg    %ebx
  80285c:	b8 0a 00 00 00       	mov    $0xa,%eax
  802861:	eb 7a                	jmp    8028dd <vprintfmt+0x3b0>
  802863:	89 45 cc             	mov    %eax,-0x34(%ebp)
			base = 10;
			goto number;

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  802866:	89 ca                	mov    %ecx,%edx
  802868:	8d 45 14             	lea    0x14(%ebp),%eax
  80286b:	e8 66 fc ff ff       	call   8024d6 <getuint>
  802870:	89 c1                	mov    %eax,%ecx
  802872:	89 d3                	mov    %edx,%ebx
  802874:	b8 0a 00 00 00       	mov    $0xa,%eax
			base = 10;
			goto number;
  802879:	eb 62                	jmp    8028dd <vprintfmt+0x3b0>
  80287b:	89 45 cc             	mov    %eax,-0x34(%ebp)
		case 'o':
			// Replace this with your code.
			// putch('X', putdat);
			// putch('X', putdat);
			// putch('X', putdat);
			num = getuint(&ap, lflag);
  80287e:	89 ca                	mov    %ecx,%edx
  802880:	8d 45 14             	lea    0x14(%ebp),%eax
  802883:	e8 4e fc ff ff       	call   8024d6 <getuint>
  802888:	89 c1                	mov    %eax,%ecx
  80288a:	89 d3                	mov    %edx,%ebx
  80288c:	b8 08 00 00 00       	mov    $0x8,%eax
			base = 8;
			goto number;
  802891:	eb 4a                	jmp    8028dd <vprintfmt+0x3b0>
  802893:	89 45 cc             	mov    %eax,-0x34(%ebp)
			break;

		// pointer
		case 'p':
			putch('0', putdat);
  802896:	89 74 24 04          	mov    %esi,0x4(%esp)
  80289a:	c7 04 24 30 00 00 00 	movl   $0x30,(%esp)
  8028a1:	ff d7                	call   *%edi
			putch('x', putdat);
  8028a3:	89 74 24 04          	mov    %esi,0x4(%esp)
  8028a7:	c7 04 24 78 00 00 00 	movl   $0x78,(%esp)
  8028ae:	ff d7                	call   *%edi
			num = (unsigned long long)
  8028b0:	8b 45 14             	mov    0x14(%ebp),%eax
  8028b3:	8d 50 04             	lea    0x4(%eax),%edx
  8028b6:	89 55 14             	mov    %edx,0x14(%ebp)
  8028b9:	8b 08                	mov    (%eax),%ecx
  8028bb:	bb 00 00 00 00       	mov    $0x0,%ebx
  8028c0:	b8 10 00 00 00       	mov    $0x10,%eax
				(uintptr_t) va_arg(ap, void *);
			base = 16;
			goto number;
  8028c5:	eb 16                	jmp    8028dd <vprintfmt+0x3b0>
  8028c7:	89 45 cc             	mov    %eax,-0x34(%ebp)

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  8028ca:	89 ca                	mov    %ecx,%edx
  8028cc:	8d 45 14             	lea    0x14(%ebp),%eax
  8028cf:	e8 02 fc ff ff       	call   8024d6 <getuint>
  8028d4:	89 c1                	mov    %eax,%ecx
  8028d6:	89 d3                	mov    %edx,%ebx
  8028d8:	b8 10 00 00 00       	mov    $0x10,%eax
			base = 16;
		number:
			printnum(putch, putdat, num, base, width, padc);
  8028dd:	0f be 55 d4          	movsbl -0x2c(%ebp),%edx
  8028e1:	89 54 24 10          	mov    %edx,0x10(%esp)
  8028e5:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8028e8:	89 54 24 0c          	mov    %edx,0xc(%esp)
  8028ec:	89 44 24 08          	mov    %eax,0x8(%esp)
  8028f0:	89 0c 24             	mov    %ecx,(%esp)
  8028f3:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8028f7:	89 f2                	mov    %esi,%edx
  8028f9:	89 f8                	mov    %edi,%eax
  8028fb:	e8 e0 fa ff ff       	call   8023e0 <printnum>
  802900:	8b 5d cc             	mov    -0x34(%ebp),%ebx
			break;
  802903:	e9 51 fc ff ff       	jmp    802559 <vprintfmt+0x2c>
  802908:	89 45 cc             	mov    %eax,-0x34(%ebp)
  80290b:	8b 55 e0             	mov    -0x20(%ebp),%edx

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  80290e:	89 74 24 04          	mov    %esi,0x4(%esp)
  802912:	89 14 24             	mov    %edx,(%esp)
  802915:	ff d7                	call   *%edi
  802917:	8b 5d cc             	mov    -0x34(%ebp),%ebx
			break;
  80291a:	e9 3a fc ff ff       	jmp    802559 <vprintfmt+0x2c>
			
		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  80291f:	89 74 24 04          	mov    %esi,0x4(%esp)
  802923:	c7 04 24 25 00 00 00 	movl   $0x25,(%esp)
  80292a:	ff d7                	call   *%edi
			for (fmt--; fmt[-1] != '%'; fmt--)
  80292c:	8d 43 ff             	lea    -0x1(%ebx),%eax
  80292f:	80 38 25             	cmpb   $0x25,(%eax)
  802932:	0f 84 21 fc ff ff    	je     802559 <vprintfmt+0x2c>
  802938:	89 c3                	mov    %eax,%ebx
  80293a:	eb f0                	jmp    80292c <vprintfmt+0x3ff>
				/* do nothing */;
			break;
		}
	}
}
  80293c:	83 c4 5c             	add    $0x5c,%esp
  80293f:	5b                   	pop    %ebx
  802940:	5e                   	pop    %esi
  802941:	5f                   	pop    %edi
  802942:	5d                   	pop    %ebp
  802943:	c3                   	ret    

00802944 <vsnprintf>:
		*b->buf++ = ch;
}

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  802944:	55                   	push   %ebp
  802945:	89 e5                	mov    %esp,%ebp
  802947:	83 ec 28             	sub    $0x28,%esp
  80294a:	8b 45 08             	mov    0x8(%ebp),%eax
  80294d:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};

	if (buf == NULL || n < 1)
  802950:	85 c0                	test   %eax,%eax
  802952:	74 04                	je     802958 <vsnprintf+0x14>
  802954:	85 d2                	test   %edx,%edx
  802956:	7f 07                	jg     80295f <vsnprintf+0x1b>
  802958:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80295d:	eb 3b                	jmp    80299a <vsnprintf+0x56>
}

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
	struct sprintbuf b = {buf, buf+n-1, 0};
  80295f:	89 45 ec             	mov    %eax,-0x14(%ebp)
  802962:	8d 44 10 ff          	lea    -0x1(%eax,%edx,1),%eax
  802966:	89 45 f0             	mov    %eax,-0x10(%ebp)
  802969:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  802970:	8b 45 14             	mov    0x14(%ebp),%eax
  802973:	89 44 24 0c          	mov    %eax,0xc(%esp)
  802977:	8b 45 10             	mov    0x10(%ebp),%eax
  80297a:	89 44 24 08          	mov    %eax,0x8(%esp)
  80297e:	8d 45 ec             	lea    -0x14(%ebp),%eax
  802981:	89 44 24 04          	mov    %eax,0x4(%esp)
  802985:	c7 04 24 10 25 80 00 	movl   $0x802510,(%esp)
  80298c:	e8 9c fb ff ff       	call   80252d <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  802991:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802994:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  802997:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  80299a:	c9                   	leave  
  80299b:	c3                   	ret    

0080299c <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  80299c:	55                   	push   %ebp
  80299d:	89 e5                	mov    %esp,%ebp
  80299f:	83 ec 18             	sub    $0x18,%esp

	return b.cnt;
}

int
snprintf(char *buf, int n, const char *fmt, ...)
  8029a2:	8d 45 14             	lea    0x14(%ebp),%eax
{
	va_list ap;
	int rc;

	va_start(ap, fmt);
	rc = vsnprintf(buf, n, fmt, ap);
  8029a5:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8029a9:	8b 45 10             	mov    0x10(%ebp),%eax
  8029ac:	89 44 24 08          	mov    %eax,0x8(%esp)
  8029b0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8029b3:	89 44 24 04          	mov    %eax,0x4(%esp)
  8029b7:	8b 45 08             	mov    0x8(%ebp),%eax
  8029ba:	89 04 24             	mov    %eax,(%esp)
  8029bd:	e8 82 ff ff ff       	call   802944 <vsnprintf>
	va_end(ap);

	return rc;
}
  8029c2:	c9                   	leave  
  8029c3:	c3                   	ret    

008029c4 <printfmt>:
	}
}

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  8029c4:	55                   	push   %ebp
  8029c5:	89 e5                	mov    %esp,%ebp
  8029c7:	83 ec 18             	sub    $0x18,%esp
		}
	}
}

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
  8029ca:	8d 45 14             	lea    0x14(%ebp),%eax
{
	va_list ap;

	va_start(ap, fmt);
	vprintfmt(putch, putdat, fmt, ap);
  8029cd:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8029d1:	8b 45 10             	mov    0x10(%ebp),%eax
  8029d4:	89 44 24 08          	mov    %eax,0x8(%esp)
  8029d8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8029db:	89 44 24 04          	mov    %eax,0x4(%esp)
  8029df:	8b 45 08             	mov    0x8(%ebp),%eax
  8029e2:	89 04 24             	mov    %eax,(%esp)
  8029e5:	e8 43 fb ff ff       	call   80252d <vprintfmt>
	va_end(ap);
}
  8029ea:	c9                   	leave  
  8029eb:	c3                   	ret    
  8029ec:	00 00                	add    %al,(%eax)
	...

008029f0 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  8029f0:	55                   	push   %ebp
  8029f1:	89 e5                	mov    %esp,%ebp
  8029f3:	57                   	push   %edi
  8029f4:	56                   	push   %esi
  8029f5:	53                   	push   %ebx
  8029f6:	83 ec 1c             	sub    $0x1c,%esp
  8029f9:	8b 7d 0c             	mov    0xc(%ebp),%edi
  8029fc:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8029ff:	8b 75 14             	mov    0x14(%ebp),%esi
	// LAB 4: Your code here.
	int r;
	if (pg == NULL)
  802a02:	85 db                	test   %ebx,%ebx
  802a04:	75 2d                	jne    802a33 <ipc_send+0x43>
  802a06:	bb 00 00 c0 ee       	mov    $0xeec00000,%ebx
  802a0b:	eb 26                	jmp    802a33 <ipc_send+0x43>
		pg = (void*)UTOP;
	while ((r = sys_ipc_try_send(to_env, val, pg, perm)) < 0)
	{
		if(r != -E_IPC_NOT_RECV)
  802a0d:	83 f8 f9             	cmp    $0xfffffff9,%eax
  802a10:	74 1c                	je     802a2e <ipc_send+0x3e>
			panic("Panic in lib ipc.c : ipc_send() \n");
  802a12:	c7 44 24 08 80 32 80 	movl   $0x803280,0x8(%esp)
  802a19:	00 
  802a1a:	c7 44 24 04 44 00 00 	movl   $0x44,0x4(%esp)
  802a21:	00 
  802a22:	c7 04 24 a4 32 80 00 	movl   $0x8032a4,(%esp)
  802a29:	e8 8e f8 ff ff       	call   8022bc <_panic>
		sys_yield();
  802a2e:	e8 d7 e0 ff ff       	call   800b0a <sys_yield>
{
	// LAB 4: Your code here.
	int r;
	if (pg == NULL)
		pg = (void*)UTOP;
	while ((r = sys_ipc_try_send(to_env, val, pg, perm)) < 0)
  802a33:	89 74 24 0c          	mov    %esi,0xc(%esp)
  802a37:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  802a3b:	89 7c 24 04          	mov    %edi,0x4(%esp)
  802a3f:	8b 45 08             	mov    0x8(%ebp),%eax
  802a42:	89 04 24             	mov    %eax,(%esp)
  802a45:	e8 53 de ff ff       	call   80089d <sys_ipc_try_send>
  802a4a:	85 c0                	test   %eax,%eax
  802a4c:	78 bf                	js     802a0d <ipc_send+0x1d>
		if(r != -E_IPC_NOT_RECV)
			panic("Panic in lib ipc.c : ipc_send() \n");
		sys_yield();
	}
	//panic("ipc_send not implemented");
}
  802a4e:	83 c4 1c             	add    $0x1c,%esp
  802a51:	5b                   	pop    %ebx
  802a52:	5e                   	pop    %esi
  802a53:	5f                   	pop    %edi
  802a54:	5d                   	pop    %ebp
  802a55:	c3                   	ret    

00802a56 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  802a56:	55                   	push   %ebp
  802a57:	89 e5                	mov    %esp,%ebp
  802a59:	56                   	push   %esi
  802a5a:	53                   	push   %ebx
  802a5b:	83 ec 10             	sub    $0x10,%esp
  802a5e:	8b 5d 08             	mov    0x8(%ebp),%ebx
  802a61:	8b 45 0c             	mov    0xc(%ebp),%eax
  802a64:	8b 75 10             	mov    0x10(%ebp),%esi
	// LAB 4: Your code here.
	int r;

	if (pg == NULL)
  802a67:	85 c0                	test   %eax,%eax
  802a69:	75 05                	jne    802a70 <ipc_recv+0x1a>
  802a6b:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
		pg = (void*)UTOP;
	if ((r = sys_ipc_recv(pg)) < 0)
  802a70:	89 04 24             	mov    %eax,(%esp)
  802a73:	e8 c8 dd ff ff       	call   800840 <sys_ipc_recv>
  802a78:	85 c0                	test   %eax,%eax
  802a7a:	79 16                	jns    802a92 <ipc_recv+0x3c>
	{
		if (from_env_store != NULL)
  802a7c:	85 db                	test   %ebx,%ebx
  802a7e:	74 06                	je     802a86 <ipc_recv+0x30>
			*from_env_store = 0;
  802a80:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
		if(perm_store != NULL)
  802a86:	85 f6                	test   %esi,%esi
  802a88:	74 2c                	je     802ab6 <ipc_recv+0x60>
			*perm_store = 0;
  802a8a:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
  802a90:	eb 24                	jmp    802ab6 <ipc_recv+0x60>
		return r;
	}
	else
	{	
		if (from_env_store != NULL)
  802a92:	85 db                	test   %ebx,%ebx
  802a94:	74 0a                	je     802aa0 <ipc_recv+0x4a>
			*from_env_store = env->env_ipc_from;
  802a96:	a1 84 74 80 00       	mov    0x807484,%eax
  802a9b:	8b 40 74             	mov    0x74(%eax),%eax
  802a9e:	89 03                	mov    %eax,(%ebx)
		if(perm_store != NULL)
  802aa0:	85 f6                	test   %esi,%esi
  802aa2:	74 0a                	je     802aae <ipc_recv+0x58>
			*perm_store = env->env_ipc_perm;
  802aa4:	a1 84 74 80 00       	mov    0x807484,%eax
  802aa9:	8b 40 78             	mov    0x78(%eax),%eax
  802aac:	89 06                	mov    %eax,(%esi)
		return env->env_ipc_value;
  802aae:	a1 84 74 80 00       	mov    0x807484,%eax
  802ab3:	8b 40 70             	mov    0x70(%eax),%eax
	}		
	//panic("ipc_recv not implemented");
	//return 0;
}
  802ab6:	83 c4 10             	add    $0x10,%esp
  802ab9:	5b                   	pop    %ebx
  802aba:	5e                   	pop    %esi
  802abb:	5d                   	pop    %ebp
  802abc:	c3                   	ret    
  802abd:	00 00                	add    %al,(%eax)
	...

00802ac0 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  802ac0:	55                   	push   %ebp
  802ac1:	89 e5                	mov    %esp,%ebp
	pte_t pte;

	if (!(vpd[PDX(v)] & PTE_P))
  802ac3:	8b 45 08             	mov    0x8(%ebp),%eax
  802ac6:	89 c2                	mov    %eax,%edx
  802ac8:	c1 ea 16             	shr    $0x16,%edx
  802acb:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  802ad2:	f6 c2 01             	test   $0x1,%dl
  802ad5:	74 26                	je     802afd <pageref+0x3d>
		return 0;
	pte = vpt[VPN(v)];
  802ad7:	c1 e8 0c             	shr    $0xc,%eax
  802ada:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
	if (!(pte & PTE_P))
  802ae1:	a8 01                	test   $0x1,%al
  802ae3:	74 18                	je     802afd <pageref+0x3d>
		return 0;
	return pages[PPN(pte)].pp_ref;
  802ae5:	c1 e8 0c             	shr    $0xc,%eax
  802ae8:	8d 14 40             	lea    (%eax,%eax,2),%edx
  802aeb:	c1 e2 02             	shl    $0x2,%edx
  802aee:	b8 00 00 00 ef       	mov    $0xef000000,%eax
  802af3:	0f b7 44 02 08       	movzwl 0x8(%edx,%eax,1),%eax
  802af8:	0f b7 c0             	movzwl %ax,%eax
  802afb:	eb 05                	jmp    802b02 <pageref+0x42>
  802afd:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802b02:	5d                   	pop    %ebp
  802b03:	c3                   	ret    
	...

00802b10 <__udivdi3>:
  802b10:	55                   	push   %ebp
  802b11:	89 e5                	mov    %esp,%ebp
  802b13:	57                   	push   %edi
  802b14:	56                   	push   %esi
  802b15:	83 ec 10             	sub    $0x10,%esp
  802b18:	8b 45 14             	mov    0x14(%ebp),%eax
  802b1b:	8b 55 08             	mov    0x8(%ebp),%edx
  802b1e:	8b 75 10             	mov    0x10(%ebp),%esi
  802b21:	8b 7d 0c             	mov    0xc(%ebp),%edi
  802b24:	85 c0                	test   %eax,%eax
  802b26:	89 55 f0             	mov    %edx,-0x10(%ebp)
  802b29:	75 35                	jne    802b60 <__udivdi3+0x50>
  802b2b:	39 fe                	cmp    %edi,%esi
  802b2d:	77 61                	ja     802b90 <__udivdi3+0x80>
  802b2f:	85 f6                	test   %esi,%esi
  802b31:	75 0b                	jne    802b3e <__udivdi3+0x2e>
  802b33:	b8 01 00 00 00       	mov    $0x1,%eax
  802b38:	31 d2                	xor    %edx,%edx
  802b3a:	f7 f6                	div    %esi
  802b3c:	89 c6                	mov    %eax,%esi
  802b3e:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  802b41:	31 d2                	xor    %edx,%edx
  802b43:	89 f8                	mov    %edi,%eax
  802b45:	f7 f6                	div    %esi
  802b47:	89 c7                	mov    %eax,%edi
  802b49:	89 c8                	mov    %ecx,%eax
  802b4b:	f7 f6                	div    %esi
  802b4d:	89 c1                	mov    %eax,%ecx
  802b4f:	89 fa                	mov    %edi,%edx
  802b51:	89 c8                	mov    %ecx,%eax
  802b53:	83 c4 10             	add    $0x10,%esp
  802b56:	5e                   	pop    %esi
  802b57:	5f                   	pop    %edi
  802b58:	5d                   	pop    %ebp
  802b59:	c3                   	ret    
  802b5a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  802b60:	39 f8                	cmp    %edi,%eax
  802b62:	77 1c                	ja     802b80 <__udivdi3+0x70>
  802b64:	0f bd d0             	bsr    %eax,%edx
  802b67:	83 f2 1f             	xor    $0x1f,%edx
  802b6a:	89 55 f4             	mov    %edx,-0xc(%ebp)
  802b6d:	75 39                	jne    802ba8 <__udivdi3+0x98>
  802b6f:	3b 75 f0             	cmp    -0x10(%ebp),%esi
  802b72:	0f 86 a0 00 00 00    	jbe    802c18 <__udivdi3+0x108>
  802b78:	39 f8                	cmp    %edi,%eax
  802b7a:	0f 82 98 00 00 00    	jb     802c18 <__udivdi3+0x108>
  802b80:	31 ff                	xor    %edi,%edi
  802b82:	31 c9                	xor    %ecx,%ecx
  802b84:	89 c8                	mov    %ecx,%eax
  802b86:	89 fa                	mov    %edi,%edx
  802b88:	83 c4 10             	add    $0x10,%esp
  802b8b:	5e                   	pop    %esi
  802b8c:	5f                   	pop    %edi
  802b8d:	5d                   	pop    %ebp
  802b8e:	c3                   	ret    
  802b8f:	90                   	nop
  802b90:	89 d1                	mov    %edx,%ecx
  802b92:	89 fa                	mov    %edi,%edx
  802b94:	89 c8                	mov    %ecx,%eax
  802b96:	31 ff                	xor    %edi,%edi
  802b98:	f7 f6                	div    %esi
  802b9a:	89 c1                	mov    %eax,%ecx
  802b9c:	89 fa                	mov    %edi,%edx
  802b9e:	89 c8                	mov    %ecx,%eax
  802ba0:	83 c4 10             	add    $0x10,%esp
  802ba3:	5e                   	pop    %esi
  802ba4:	5f                   	pop    %edi
  802ba5:	5d                   	pop    %ebp
  802ba6:	c3                   	ret    
  802ba7:	90                   	nop
  802ba8:	0f b6 4d f4          	movzbl -0xc(%ebp),%ecx
  802bac:	89 f2                	mov    %esi,%edx
  802bae:	d3 e0                	shl    %cl,%eax
  802bb0:	89 45 ec             	mov    %eax,-0x14(%ebp)
  802bb3:	b8 20 00 00 00       	mov    $0x20,%eax
  802bb8:	2b 45 f4             	sub    -0xc(%ebp),%eax
  802bbb:	89 c1                	mov    %eax,%ecx
  802bbd:	d3 ea                	shr    %cl,%edx
  802bbf:	0f b6 4d f4          	movzbl -0xc(%ebp),%ecx
  802bc3:	0b 55 ec             	or     -0x14(%ebp),%edx
  802bc6:	d3 e6                	shl    %cl,%esi
  802bc8:	89 c1                	mov    %eax,%ecx
  802bca:	89 75 e8             	mov    %esi,-0x18(%ebp)
  802bcd:	89 fe                	mov    %edi,%esi
  802bcf:	d3 ee                	shr    %cl,%esi
  802bd1:	0f b6 4d f4          	movzbl -0xc(%ebp),%ecx
  802bd5:	89 55 ec             	mov    %edx,-0x14(%ebp)
  802bd8:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802bdb:	d3 e7                	shl    %cl,%edi
  802bdd:	89 c1                	mov    %eax,%ecx
  802bdf:	d3 ea                	shr    %cl,%edx
  802be1:	09 d7                	or     %edx,%edi
  802be3:	89 f2                	mov    %esi,%edx
  802be5:	89 f8                	mov    %edi,%eax
  802be7:	f7 75 ec             	divl   -0x14(%ebp)
  802bea:	89 d6                	mov    %edx,%esi
  802bec:	89 c7                	mov    %eax,%edi
  802bee:	f7 65 e8             	mull   -0x18(%ebp)
  802bf1:	39 d6                	cmp    %edx,%esi
  802bf3:	89 55 ec             	mov    %edx,-0x14(%ebp)
  802bf6:	72 30                	jb     802c28 <__udivdi3+0x118>
  802bf8:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802bfb:	0f b6 4d f4          	movzbl -0xc(%ebp),%ecx
  802bff:	d3 e2                	shl    %cl,%edx
  802c01:	39 c2                	cmp    %eax,%edx
  802c03:	73 05                	jae    802c0a <__udivdi3+0xfa>
  802c05:	3b 75 ec             	cmp    -0x14(%ebp),%esi
  802c08:	74 1e                	je     802c28 <__udivdi3+0x118>
  802c0a:	89 f9                	mov    %edi,%ecx
  802c0c:	31 ff                	xor    %edi,%edi
  802c0e:	e9 71 ff ff ff       	jmp    802b84 <__udivdi3+0x74>
  802c13:	90                   	nop
  802c14:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802c18:	31 ff                	xor    %edi,%edi
  802c1a:	b9 01 00 00 00       	mov    $0x1,%ecx
  802c1f:	e9 60 ff ff ff       	jmp    802b84 <__udivdi3+0x74>
  802c24:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802c28:	8d 4f ff             	lea    -0x1(%edi),%ecx
  802c2b:	31 ff                	xor    %edi,%edi
  802c2d:	89 c8                	mov    %ecx,%eax
  802c2f:	89 fa                	mov    %edi,%edx
  802c31:	83 c4 10             	add    $0x10,%esp
  802c34:	5e                   	pop    %esi
  802c35:	5f                   	pop    %edi
  802c36:	5d                   	pop    %ebp
  802c37:	c3                   	ret    
	...

00802c40 <__umoddi3>:
  802c40:	55                   	push   %ebp
  802c41:	89 e5                	mov    %esp,%ebp
  802c43:	57                   	push   %edi
  802c44:	56                   	push   %esi
  802c45:	83 ec 20             	sub    $0x20,%esp
  802c48:	8b 55 14             	mov    0x14(%ebp),%edx
  802c4b:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802c4e:	8b 7d 10             	mov    0x10(%ebp),%edi
  802c51:	8b 75 0c             	mov    0xc(%ebp),%esi
  802c54:	85 d2                	test   %edx,%edx
  802c56:	89 c8                	mov    %ecx,%eax
  802c58:	89 4d f4             	mov    %ecx,-0xc(%ebp)
  802c5b:	75 13                	jne    802c70 <__umoddi3+0x30>
  802c5d:	39 f7                	cmp    %esi,%edi
  802c5f:	76 3f                	jbe    802ca0 <__umoddi3+0x60>
  802c61:	89 f2                	mov    %esi,%edx
  802c63:	f7 f7                	div    %edi
  802c65:	89 d0                	mov    %edx,%eax
  802c67:	31 d2                	xor    %edx,%edx
  802c69:	83 c4 20             	add    $0x20,%esp
  802c6c:	5e                   	pop    %esi
  802c6d:	5f                   	pop    %edi
  802c6e:	5d                   	pop    %ebp
  802c6f:	c3                   	ret    
  802c70:	39 f2                	cmp    %esi,%edx
  802c72:	77 4c                	ja     802cc0 <__umoddi3+0x80>
  802c74:	0f bd ca             	bsr    %edx,%ecx
  802c77:	83 f1 1f             	xor    $0x1f,%ecx
  802c7a:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  802c7d:	75 51                	jne    802cd0 <__umoddi3+0x90>
  802c7f:	3b 7d f4             	cmp    -0xc(%ebp),%edi
  802c82:	0f 87 e0 00 00 00    	ja     802d68 <__umoddi3+0x128>
  802c88:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c8b:	29 f8                	sub    %edi,%eax
  802c8d:	19 d6                	sbb    %edx,%esi
  802c8f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802c92:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c95:	89 f2                	mov    %esi,%edx
  802c97:	83 c4 20             	add    $0x20,%esp
  802c9a:	5e                   	pop    %esi
  802c9b:	5f                   	pop    %edi
  802c9c:	5d                   	pop    %ebp
  802c9d:	c3                   	ret    
  802c9e:	66 90                	xchg   %ax,%ax
  802ca0:	85 ff                	test   %edi,%edi
  802ca2:	75 0b                	jne    802caf <__umoddi3+0x6f>
  802ca4:	b8 01 00 00 00       	mov    $0x1,%eax
  802ca9:	31 d2                	xor    %edx,%edx
  802cab:	f7 f7                	div    %edi
  802cad:	89 c7                	mov    %eax,%edi
  802caf:	89 f0                	mov    %esi,%eax
  802cb1:	31 d2                	xor    %edx,%edx
  802cb3:	f7 f7                	div    %edi
  802cb5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cb8:	f7 f7                	div    %edi
  802cba:	eb a9                	jmp    802c65 <__umoddi3+0x25>
  802cbc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802cc0:	89 c8                	mov    %ecx,%eax
  802cc2:	89 f2                	mov    %esi,%edx
  802cc4:	83 c4 20             	add    $0x20,%esp
  802cc7:	5e                   	pop    %esi
  802cc8:	5f                   	pop    %edi
  802cc9:	5d                   	pop    %ebp
  802cca:	c3                   	ret    
  802ccb:	90                   	nop
  802ccc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802cd0:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
  802cd4:	d3 e2                	shl    %cl,%edx
  802cd6:	89 55 f4             	mov    %edx,-0xc(%ebp)
  802cd9:	ba 20 00 00 00       	mov    $0x20,%edx
  802cde:	2b 55 f0             	sub    -0x10(%ebp),%edx
  802ce1:	89 55 ec             	mov    %edx,-0x14(%ebp)
  802ce4:	0f b6 4d ec          	movzbl -0x14(%ebp),%ecx
  802ce8:	89 fa                	mov    %edi,%edx
  802cea:	d3 ea                	shr    %cl,%edx
  802cec:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
  802cf0:	0b 55 f4             	or     -0xc(%ebp),%edx
  802cf3:	d3 e7                	shl    %cl,%edi
  802cf5:	0f b6 4d ec          	movzbl -0x14(%ebp),%ecx
  802cf9:	89 55 f4             	mov    %edx,-0xc(%ebp)
  802cfc:	89 f2                	mov    %esi,%edx
  802cfe:	89 7d e8             	mov    %edi,-0x18(%ebp)
  802d01:	89 c7                	mov    %eax,%edi
  802d03:	d3 ea                	shr    %cl,%edx
  802d05:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
  802d09:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  802d0c:	89 c2                	mov    %eax,%edx
  802d0e:	d3 e6                	shl    %cl,%esi
  802d10:	0f b6 4d ec          	movzbl -0x14(%ebp),%ecx
  802d14:	d3 ea                	shr    %cl,%edx
  802d16:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
  802d1a:	09 d6                	or     %edx,%esi
  802d1c:	89 f0                	mov    %esi,%eax
  802d1e:	8b 75 e4             	mov    -0x1c(%ebp),%esi
  802d21:	d3 e7                	shl    %cl,%edi
  802d23:	89 f2                	mov    %esi,%edx
  802d25:	f7 75 f4             	divl   -0xc(%ebp)
  802d28:	89 d6                	mov    %edx,%esi
  802d2a:	f7 65 e8             	mull   -0x18(%ebp)
  802d2d:	39 d6                	cmp    %edx,%esi
  802d2f:	72 2b                	jb     802d5c <__umoddi3+0x11c>
  802d31:	39 c7                	cmp    %eax,%edi
  802d33:	72 23                	jb     802d58 <__umoddi3+0x118>
  802d35:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
  802d39:	29 c7                	sub    %eax,%edi
  802d3b:	19 d6                	sbb    %edx,%esi
  802d3d:	89 f0                	mov    %esi,%eax
  802d3f:	89 f2                	mov    %esi,%edx
  802d41:	d3 ef                	shr    %cl,%edi
  802d43:	0f b6 4d ec          	movzbl -0x14(%ebp),%ecx
  802d47:	d3 e0                	shl    %cl,%eax
  802d49:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
  802d4d:	09 f8                	or     %edi,%eax
  802d4f:	d3 ea                	shr    %cl,%edx
  802d51:	83 c4 20             	add    $0x20,%esp
  802d54:	5e                   	pop    %esi
  802d55:	5f                   	pop    %edi
  802d56:	5d                   	pop    %ebp
  802d57:	c3                   	ret    
  802d58:	39 d6                	cmp    %edx,%esi
  802d5a:	75 d9                	jne    802d35 <__umoddi3+0xf5>
  802d5c:	2b 45 e8             	sub    -0x18(%ebp),%eax
  802d5f:	1b 55 f4             	sbb    -0xc(%ebp),%edx
  802d62:	eb d1                	jmp    802d35 <__umoddi3+0xf5>
  802d64:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802d68:	39 f2                	cmp    %esi,%edx
  802d6a:	0f 82 18 ff ff ff    	jb     802c88 <__umoddi3+0x48>
  802d70:	e9 1d ff ff ff       	jmp    802c92 <__umoddi3+0x52>
