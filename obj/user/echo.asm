
obj/user/echo:     file format elf32-i386


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
  80002c:	e8 e3 00 00 00       	call   800114 <libmain>
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
  800043:	57                   	push   %edi
  800044:	56                   	push   %esi
  800045:	53                   	push   %ebx
  800046:	83 ec 2c             	sub    $0x2c,%esp
  800049:	8b 7d 08             	mov    0x8(%ebp),%edi
  80004c:	8b 75 0c             	mov    0xc(%ebp),%esi
	int i, nflag;

	nflag = 0;
	if (argc > 1 && strcmp(argv[1], "-n") == 0) {
  80004f:	83 ff 01             	cmp    $0x1,%edi
  800052:	0f 8e 8b 00 00 00    	jle    8000e3 <umain+0xa3>
  800058:	8d 5e 04             	lea    0x4(%esi),%ebx
  80005b:	c7 44 24 04 a0 28 80 	movl   $0x8028a0,0x4(%esp)
  800062:	00 
  800063:	8b 03                	mov    (%ebx),%eax
  800065:	89 04 24             	mov    %eax,(%esp)
  800068:	e8 ec 01 00 00       	call   800259 <strcmp>
			write(1, " ", 1);
		write(1, argv[i], strlen(argv[i]));
	}
	if (!nflag)
		write(1, "\n", 1);
}
  80006d:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
umain(int argc, char **argv)
{
	int i, nflag;

	nflag = 0;
	if (argc > 1 && strcmp(argv[1], "-n") == 0) {
  800074:	85 c0                	test   %eax,%eax
  800076:	0f 85 85 00 00 00    	jne    800101 <umain+0xc1>
		nflag = 1;
		argc--;
  80007c:	83 ef 01             	sub    $0x1,%edi
		argv++;
	}
	for (i = 1; i < argc; i++) {
  80007f:	83 ff 01             	cmp    $0x1,%edi
  800082:	0f 8e 80 00 00 00    	jle    800108 <umain+0xc8>
  800088:	89 de                	mov    %ebx,%esi
  80008a:	c7 45 e4 01 00 00 00 	movl   $0x1,-0x1c(%ebp)
  800091:	eb 6e                	jmp    800101 <umain+0xc1>
		if (i > 1)
  800093:	83 fb 01             	cmp    $0x1,%ebx
  800096:	7e 1c                	jle    8000b4 <umain+0x74>
			write(1, " ", 1);
  800098:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  80009f:	00 
  8000a0:	c7 44 24 04 10 2a 80 	movl   $0x802a10,0x4(%esp)
  8000a7:	00 
  8000a8:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  8000af:	e8 a1 0c 00 00       	call   800d55 <write>
		write(1, argv[i], strlen(argv[i]));
  8000b4:	8b 04 9e             	mov    (%esi,%ebx,4),%eax
  8000b7:	89 04 24             	mov    %eax,(%esp)
  8000ba:	e8 c1 00 00 00       	call   800180 <strlen>
  8000bf:	89 44 24 08          	mov    %eax,0x8(%esp)
  8000c3:	8b 04 9e             	mov    (%esi,%ebx,4),%eax
  8000c6:	89 44 24 04          	mov    %eax,0x4(%esp)
  8000ca:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  8000d1:	e8 7f 0c 00 00       	call   800d55 <write>
	if (argc > 1 && strcmp(argv[1], "-n") == 0) {
		nflag = 1;
		argc--;
		argv++;
	}
	for (i = 1; i < argc; i++) {
  8000d6:	83 c3 01             	add    $0x1,%ebx
  8000d9:	39 fb                	cmp    %edi,%ebx
  8000db:	7c b6                	jl     800093 <umain+0x53>
		if (i > 1)
			write(1, " ", 1);
		write(1, argv[i], strlen(argv[i]));
	}
	if (!nflag)
  8000dd:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8000e1:	75 25                	jne    800108 <umain+0xc8>
		write(1, "\n", 1);
  8000e3:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  8000ea:	00 
  8000eb:	c7 44 24 04 de 29 80 	movl   $0x8029de,0x4(%esp)
  8000f2:	00 
  8000f3:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  8000fa:	e8 56 0c 00 00       	call   800d55 <write>
  8000ff:	eb 07                	jmp    800108 <umain+0xc8>
}
  800101:	bb 01 00 00 00       	mov    $0x1,%ebx
  800106:	eb ac                	jmp    8000b4 <umain+0x74>
  800108:	83 c4 2c             	add    $0x2c,%esp
  80010b:	5b                   	pop    %ebx
  80010c:	5e                   	pop    %esi
  80010d:	5f                   	pop    %edi
  80010e:	5d                   	pop    %ebp
  80010f:	90                   	nop
  800110:	c3                   	ret    
  800111:	00 00                	add    %al,(%eax)
	...

00800114 <libmain>:
volatile struct Env *env;
char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  800114:	55                   	push   %ebp
  800115:	89 e5                	mov    %esp,%ebp
  800117:	83 ec 18             	sub    $0x18,%esp
  80011a:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  80011d:	89 75 fc             	mov    %esi,-0x4(%ebp)
  800120:	8b 75 08             	mov    0x8(%ebp),%esi
  800123:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	// set env to point at our env structure in envs[].
	// LAB 3b: Your code here.
	// Code added by Swastika / Sandeep	
	envid_t envid = sys_getenvid();
  800126:	e8 23 09 00 00       	call   800a4e <sys_getenvid>
	env = &envs[ENVX(envid)];
  80012b:	25 ff 03 00 00       	and    $0x3ff,%eax
  800130:	6b c0 7c             	imul   $0x7c,%eax,%eax
  800133:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800138:	a3 74 60 80 00       	mov    %eax,0x806074

	// save the name of the program so that panic() can use it
	if (argc > 0)
  80013d:	85 f6                	test   %esi,%esi
  80013f:	7e 07                	jle    800148 <libmain+0x34>
		binaryname = argv[0];
  800141:	8b 03                	mov    (%ebx),%eax
  800143:	a3 00 60 80 00       	mov    %eax,0x806000

	// call user main routine
	umain(argc, argv);
  800148:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  80014c:	89 34 24             	mov    %esi,(%esp)
  80014f:	e8 ec fe ff ff       	call   800040 <umain>

	// exit gracefully
	exit();
  800154:	e8 0b 00 00 00       	call   800164 <exit>
}
  800159:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  80015c:	8b 75 fc             	mov    -0x4(%ebp),%esi
  80015f:	89 ec                	mov    %ebp,%esp
  800161:	5d                   	pop    %ebp
  800162:	c3                   	ret    
	...

00800164 <exit>:
#include <inc/lib.h>

void
exit(void)
{
  800164:	55                   	push   %ebp
  800165:	89 e5                	mov    %esp,%ebp
  800167:	83 ec 18             	sub    $0x18,%esp
	close_all();
  80016a:	e8 4c 0e 00 00       	call   800fbb <close_all>
	sys_env_destroy(0);
  80016f:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  800176:	e8 07 09 00 00       	call   800a82 <sys_env_destroy>
}
  80017b:	c9                   	leave  
  80017c:	c3                   	ret    
  80017d:	00 00                	add    %al,(%eax)
	...

00800180 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800180:	55                   	push   %ebp
  800181:	89 e5                	mov    %esp,%ebp
  800183:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  800186:	b8 00 00 00 00       	mov    $0x0,%eax
  80018b:	80 3a 00             	cmpb   $0x0,(%edx)
  80018e:	74 09                	je     800199 <strlen+0x19>
		n++;
  800190:	83 c0 01             	add    $0x1,%eax
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800193:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  800197:	75 f7                	jne    800190 <strlen+0x10>
		n++;
	return n;
}
  800199:	5d                   	pop    %ebp
  80019a:	c3                   	ret    

0080019b <strnlen>:

int
strnlen(const char *s, size_t size)
{
  80019b:	55                   	push   %ebp
  80019c:	89 e5                	mov    %esp,%ebp
  80019e:	53                   	push   %ebx
  80019f:	8b 5d 08             	mov    0x8(%ebp),%ebx
  8001a2:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8001a5:	85 c9                	test   %ecx,%ecx
  8001a7:	74 19                	je     8001c2 <strnlen+0x27>
  8001a9:	80 3b 00             	cmpb   $0x0,(%ebx)
  8001ac:	74 14                	je     8001c2 <strnlen+0x27>
  8001ae:	b8 00 00 00 00       	mov    $0x0,%eax
		n++;
  8001b3:	83 c0 01             	add    $0x1,%eax
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8001b6:	39 c8                	cmp    %ecx,%eax
  8001b8:	74 0d                	je     8001c7 <strnlen+0x2c>
  8001ba:	80 3c 03 00          	cmpb   $0x0,(%ebx,%eax,1)
  8001be:	75 f3                	jne    8001b3 <strnlen+0x18>
  8001c0:	eb 05                	jmp    8001c7 <strnlen+0x2c>
  8001c2:	b8 00 00 00 00       	mov    $0x0,%eax
		n++;
	return n;
}
  8001c7:	5b                   	pop    %ebx
  8001c8:	5d                   	pop    %ebp
  8001c9:	c3                   	ret    

008001ca <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  8001ca:	55                   	push   %ebp
  8001cb:	89 e5                	mov    %esp,%ebp
  8001cd:	53                   	push   %ebx
  8001ce:	8b 45 08             	mov    0x8(%ebp),%eax
  8001d1:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  8001d4:	ba 00 00 00 00       	mov    $0x0,%edx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  8001d9:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
  8001dd:	88 0c 10             	mov    %cl,(%eax,%edx,1)
  8001e0:	83 c2 01             	add    $0x1,%edx
  8001e3:	84 c9                	test   %cl,%cl
  8001e5:	75 f2                	jne    8001d9 <strcpy+0xf>
		/* do nothing */;
	return ret;
}
  8001e7:	5b                   	pop    %ebx
  8001e8:	5d                   	pop    %ebp
  8001e9:	c3                   	ret    

008001ea <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  8001ea:	55                   	push   %ebp
  8001eb:	89 e5                	mov    %esp,%ebp
  8001ed:	56                   	push   %esi
  8001ee:	53                   	push   %ebx
  8001ef:	8b 45 08             	mov    0x8(%ebp),%eax
  8001f2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8001f5:	8b 75 10             	mov    0x10(%ebp),%esi
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  8001f8:	85 f6                	test   %esi,%esi
  8001fa:	74 18                	je     800214 <strncpy+0x2a>
  8001fc:	b9 00 00 00 00       	mov    $0x0,%ecx
		*dst++ = *src;
  800201:	0f b6 1a             	movzbl (%edx),%ebx
  800204:	88 1c 08             	mov    %bl,(%eax,%ecx,1)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  800207:	80 3a 01             	cmpb   $0x1,(%edx)
  80020a:	83 da ff             	sbb    $0xffffffff,%edx
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  80020d:	83 c1 01             	add    $0x1,%ecx
  800210:	39 ce                	cmp    %ecx,%esi
  800212:	77 ed                	ja     800201 <strncpy+0x17>
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
}
  800214:	5b                   	pop    %ebx
  800215:	5e                   	pop    %esi
  800216:	5d                   	pop    %ebp
  800217:	c3                   	ret    

00800218 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800218:	55                   	push   %ebp
  800219:	89 e5                	mov    %esp,%ebp
  80021b:	56                   	push   %esi
  80021c:	53                   	push   %ebx
  80021d:	8b 75 08             	mov    0x8(%ebp),%esi
  800220:	8b 55 0c             	mov    0xc(%ebp),%edx
  800223:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  800226:	89 f0                	mov    %esi,%eax
  800228:	85 c9                	test   %ecx,%ecx
  80022a:	74 27                	je     800253 <strlcpy+0x3b>
		while (--size > 0 && *src != '\0')
  80022c:	83 e9 01             	sub    $0x1,%ecx
  80022f:	74 1d                	je     80024e <strlcpy+0x36>
  800231:	0f b6 1a             	movzbl (%edx),%ebx
  800234:	84 db                	test   %bl,%bl
  800236:	74 16                	je     80024e <strlcpy+0x36>
			*dst++ = *src++;
  800238:	88 18                	mov    %bl,(%eax)
  80023a:	83 c0 01             	add    $0x1,%eax
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  80023d:	83 e9 01             	sub    $0x1,%ecx
  800240:	74 0e                	je     800250 <strlcpy+0x38>
			*dst++ = *src++;
  800242:	83 c2 01             	add    $0x1,%edx
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800245:	0f b6 1a             	movzbl (%edx),%ebx
  800248:	84 db                	test   %bl,%bl
  80024a:	75 ec                	jne    800238 <strlcpy+0x20>
  80024c:	eb 02                	jmp    800250 <strlcpy+0x38>
  80024e:	89 f0                	mov    %esi,%eax
			*dst++ = *src++;
		*dst = '\0';
  800250:	c6 00 00             	movb   $0x0,(%eax)
  800253:	29 f0                	sub    %esi,%eax
	}
	return dst - dst_in;
}
  800255:	5b                   	pop    %ebx
  800256:	5e                   	pop    %esi
  800257:	5d                   	pop    %ebp
  800258:	c3                   	ret    

00800259 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800259:	55                   	push   %ebp
  80025a:	89 e5                	mov    %esp,%ebp
  80025c:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80025f:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  800262:	0f b6 01             	movzbl (%ecx),%eax
  800265:	84 c0                	test   %al,%al
  800267:	74 15                	je     80027e <strcmp+0x25>
  800269:	3a 02                	cmp    (%edx),%al
  80026b:	75 11                	jne    80027e <strcmp+0x25>
		p++, q++;
  80026d:	83 c1 01             	add    $0x1,%ecx
  800270:	83 c2 01             	add    $0x1,%edx
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800273:	0f b6 01             	movzbl (%ecx),%eax
  800276:	84 c0                	test   %al,%al
  800278:	74 04                	je     80027e <strcmp+0x25>
  80027a:	3a 02                	cmp    (%edx),%al
  80027c:	74 ef                	je     80026d <strcmp+0x14>
  80027e:	0f b6 c0             	movzbl %al,%eax
  800281:	0f b6 12             	movzbl (%edx),%edx
  800284:	29 d0                	sub    %edx,%eax
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
}
  800286:	5d                   	pop    %ebp
  800287:	c3                   	ret    

00800288 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800288:	55                   	push   %ebp
  800289:	89 e5                	mov    %esp,%ebp
  80028b:	53                   	push   %ebx
  80028c:	8b 55 08             	mov    0x8(%ebp),%edx
  80028f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800292:	8b 45 10             	mov    0x10(%ebp),%eax
	while (n > 0 && *p && *p == *q)
  800295:	85 c0                	test   %eax,%eax
  800297:	74 23                	je     8002bc <strncmp+0x34>
  800299:	0f b6 1a             	movzbl (%edx),%ebx
  80029c:	84 db                	test   %bl,%bl
  80029e:	74 24                	je     8002c4 <strncmp+0x3c>
  8002a0:	3a 19                	cmp    (%ecx),%bl
  8002a2:	75 20                	jne    8002c4 <strncmp+0x3c>
  8002a4:	83 e8 01             	sub    $0x1,%eax
  8002a7:	74 13                	je     8002bc <strncmp+0x34>
		n--, p++, q++;
  8002a9:	83 c2 01             	add    $0x1,%edx
  8002ac:	83 c1 01             	add    $0x1,%ecx
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  8002af:	0f b6 1a             	movzbl (%edx),%ebx
  8002b2:	84 db                	test   %bl,%bl
  8002b4:	74 0e                	je     8002c4 <strncmp+0x3c>
  8002b6:	3a 19                	cmp    (%ecx),%bl
  8002b8:	74 ea                	je     8002a4 <strncmp+0x1c>
  8002ba:	eb 08                	jmp    8002c4 <strncmp+0x3c>
  8002bc:	b8 00 00 00 00       	mov    $0x0,%eax
		n--, p++, q++;
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
}
  8002c1:	5b                   	pop    %ebx
  8002c2:	5d                   	pop    %ebp
  8002c3:	c3                   	ret    
	while (n > 0 && *p && *p == *q)
		n--, p++, q++;
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  8002c4:	0f b6 02             	movzbl (%edx),%eax
  8002c7:	0f b6 11             	movzbl (%ecx),%edx
  8002ca:	29 d0                	sub    %edx,%eax
  8002cc:	eb f3                	jmp    8002c1 <strncmp+0x39>

008002ce <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  8002ce:	55                   	push   %ebp
  8002cf:	89 e5                	mov    %esp,%ebp
  8002d1:	8b 45 08             	mov    0x8(%ebp),%eax
  8002d4:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  8002d8:	0f b6 10             	movzbl (%eax),%edx
  8002db:	84 d2                	test   %dl,%dl
  8002dd:	74 15                	je     8002f4 <strchr+0x26>
		if (*s == c)
  8002df:	38 ca                	cmp    %cl,%dl
  8002e1:	75 07                	jne    8002ea <strchr+0x1c>
  8002e3:	eb 14                	jmp    8002f9 <strchr+0x2b>
  8002e5:	38 ca                	cmp    %cl,%dl
  8002e7:	90                   	nop
  8002e8:	74 0f                	je     8002f9 <strchr+0x2b>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  8002ea:	83 c0 01             	add    $0x1,%eax
  8002ed:	0f b6 10             	movzbl (%eax),%edx
  8002f0:	84 d2                	test   %dl,%dl
  8002f2:	75 f1                	jne    8002e5 <strchr+0x17>
  8002f4:	b8 00 00 00 00       	mov    $0x0,%eax
		if (*s == c)
			return (char *) s;
	return 0;
}
  8002f9:	5d                   	pop    %ebp
  8002fa:	c3                   	ret    

008002fb <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  8002fb:	55                   	push   %ebp
  8002fc:	89 e5                	mov    %esp,%ebp
  8002fe:	8b 45 08             	mov    0x8(%ebp),%eax
  800301:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800305:	0f b6 10             	movzbl (%eax),%edx
  800308:	84 d2                	test   %dl,%dl
  80030a:	74 18                	je     800324 <strfind+0x29>
		if (*s == c)
  80030c:	38 ca                	cmp    %cl,%dl
  80030e:	75 0a                	jne    80031a <strfind+0x1f>
  800310:	eb 12                	jmp    800324 <strfind+0x29>
  800312:	38 ca                	cmp    %cl,%dl
  800314:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  800318:	74 0a                	je     800324 <strfind+0x29>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  80031a:	83 c0 01             	add    $0x1,%eax
  80031d:	0f b6 10             	movzbl (%eax),%edx
  800320:	84 d2                	test   %dl,%dl
  800322:	75 ee                	jne    800312 <strfind+0x17>
		if (*s == c)
			break;
	return (char *) s;
}
  800324:	5d                   	pop    %ebp
  800325:	c3                   	ret    

00800326 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800326:	55                   	push   %ebp
  800327:	89 e5                	mov    %esp,%ebp
  800329:	83 ec 0c             	sub    $0xc,%esp
  80032c:	89 1c 24             	mov    %ebx,(%esp)
  80032f:	89 74 24 04          	mov    %esi,0x4(%esp)
  800333:	89 7c 24 08          	mov    %edi,0x8(%esp)
  800337:	8b 7d 08             	mov    0x8(%ebp),%edi
  80033a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80033d:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800340:	85 c9                	test   %ecx,%ecx
  800342:	74 30                	je     800374 <memset+0x4e>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800344:	f7 c7 03 00 00 00    	test   $0x3,%edi
  80034a:	75 25                	jne    800371 <memset+0x4b>
  80034c:	f6 c1 03             	test   $0x3,%cl
  80034f:	75 20                	jne    800371 <memset+0x4b>
		c &= 0xFF;
  800351:	0f b6 d0             	movzbl %al,%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800354:	89 d3                	mov    %edx,%ebx
  800356:	c1 e3 08             	shl    $0x8,%ebx
  800359:	89 d6                	mov    %edx,%esi
  80035b:	c1 e6 18             	shl    $0x18,%esi
  80035e:	89 d0                	mov    %edx,%eax
  800360:	c1 e0 10             	shl    $0x10,%eax
  800363:	09 f0                	or     %esi,%eax
  800365:	09 d0                	or     %edx,%eax
		asm volatile("cld; rep stosl\n"
  800367:	09 d8                	or     %ebx,%eax
  800369:	c1 e9 02             	shr    $0x2,%ecx
  80036c:	fc                   	cld    
  80036d:	f3 ab                	rep stos %eax,%es:(%edi)
{
	char *p;

	if (n == 0)
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  80036f:	eb 03                	jmp    800374 <memset+0x4e>
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800371:	fc                   	cld    
  800372:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800374:	89 f8                	mov    %edi,%eax
  800376:	8b 1c 24             	mov    (%esp),%ebx
  800379:	8b 74 24 04          	mov    0x4(%esp),%esi
  80037d:	8b 7c 24 08          	mov    0x8(%esp),%edi
  800381:	89 ec                	mov    %ebp,%esp
  800383:	5d                   	pop    %ebp
  800384:	c3                   	ret    

00800385 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800385:	55                   	push   %ebp
  800386:	89 e5                	mov    %esp,%ebp
  800388:	83 ec 08             	sub    $0x8,%esp
  80038b:	89 34 24             	mov    %esi,(%esp)
  80038e:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800392:	8b 45 08             	mov    0x8(%ebp),%eax
  800395:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;
	
	s = src;
  800398:	8b 75 0c             	mov    0xc(%ebp),%esi
	d = dst;
  80039b:	89 c7                	mov    %eax,%edi
	if (s < d && s + n > d) {
  80039d:	39 c6                	cmp    %eax,%esi
  80039f:	73 35                	jae    8003d6 <memmove+0x51>
  8003a1:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  8003a4:	39 d0                	cmp    %edx,%eax
  8003a6:	73 2e                	jae    8003d6 <memmove+0x51>
		s += n;
		d += n;
  8003a8:	01 cf                	add    %ecx,%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  8003aa:	f6 c2 03             	test   $0x3,%dl
  8003ad:	75 1b                	jne    8003ca <memmove+0x45>
  8003af:	f7 c7 03 00 00 00    	test   $0x3,%edi
  8003b5:	75 13                	jne    8003ca <memmove+0x45>
  8003b7:	f6 c1 03             	test   $0x3,%cl
  8003ba:	75 0e                	jne    8003ca <memmove+0x45>
			asm volatile("std; rep movsl\n"
  8003bc:	83 ef 04             	sub    $0x4,%edi
  8003bf:	8d 72 fc             	lea    -0x4(%edx),%esi
  8003c2:	c1 e9 02             	shr    $0x2,%ecx
  8003c5:	fd                   	std    
  8003c6:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  8003c8:	eb 09                	jmp    8003d3 <memmove+0x4e>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  8003ca:	83 ef 01             	sub    $0x1,%edi
  8003cd:	8d 72 ff             	lea    -0x1(%edx),%esi
  8003d0:	fd                   	std    
  8003d1:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  8003d3:	fc                   	cld    
	const char *s;
	char *d;
	
	s = src;
	d = dst;
	if (s < d && s + n > d) {
  8003d4:	eb 20                	jmp    8003f6 <memmove+0x71>
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  8003d6:	f7 c6 03 00 00 00    	test   $0x3,%esi
  8003dc:	75 15                	jne    8003f3 <memmove+0x6e>
  8003de:	f7 c7 03 00 00 00    	test   $0x3,%edi
  8003e4:	75 0d                	jne    8003f3 <memmove+0x6e>
  8003e6:	f6 c1 03             	test   $0x3,%cl
  8003e9:	75 08                	jne    8003f3 <memmove+0x6e>
			asm volatile("cld; rep movsl\n"
  8003eb:	c1 e9 02             	shr    $0x2,%ecx
  8003ee:	fc                   	cld    
  8003ef:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  8003f1:	eb 03                	jmp    8003f6 <memmove+0x71>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  8003f3:	fc                   	cld    
  8003f4:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  8003f6:	8b 34 24             	mov    (%esp),%esi
  8003f9:	8b 7c 24 04          	mov    0x4(%esp),%edi
  8003fd:	89 ec                	mov    %ebp,%esp
  8003ff:	5d                   	pop    %ebp
  800400:	c3                   	ret    

00800401 <memcpy>:

/* sigh - gcc emits references to this for structure assignments! */
/* it is *not* prototyped in inc/string.h - do not use directly. */
void *
memcpy(void *dst, void *src, size_t n)
{
  800401:	55                   	push   %ebp
  800402:	89 e5                	mov    %esp,%ebp
  800404:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  800407:	8b 45 10             	mov    0x10(%ebp),%eax
  80040a:	89 44 24 08          	mov    %eax,0x8(%esp)
  80040e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800411:	89 44 24 04          	mov    %eax,0x4(%esp)
  800415:	8b 45 08             	mov    0x8(%ebp),%eax
  800418:	89 04 24             	mov    %eax,(%esp)
  80041b:	e8 65 ff ff ff       	call   800385 <memmove>
}
  800420:	c9                   	leave  
  800421:	c3                   	ret    

00800422 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800422:	55                   	push   %ebp
  800423:	89 e5                	mov    %esp,%ebp
  800425:	57                   	push   %edi
  800426:	56                   	push   %esi
  800427:	53                   	push   %ebx
  800428:	8b 75 08             	mov    0x8(%ebp),%esi
  80042b:	8b 7d 0c             	mov    0xc(%ebp),%edi
  80042e:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800431:	85 c9                	test   %ecx,%ecx
  800433:	74 36                	je     80046b <memcmp+0x49>
		if (*s1 != *s2)
  800435:	0f b6 06             	movzbl (%esi),%eax
  800438:	0f b6 1f             	movzbl (%edi),%ebx
  80043b:	38 d8                	cmp    %bl,%al
  80043d:	74 20                	je     80045f <memcmp+0x3d>
  80043f:	eb 14                	jmp    800455 <memcmp+0x33>
  800441:	0f b6 44 16 01       	movzbl 0x1(%esi,%edx,1),%eax
  800446:	0f b6 5c 17 01       	movzbl 0x1(%edi,%edx,1),%ebx
  80044b:	83 c2 01             	add    $0x1,%edx
  80044e:	83 e9 01             	sub    $0x1,%ecx
  800451:	38 d8                	cmp    %bl,%al
  800453:	74 12                	je     800467 <memcmp+0x45>
			return (int) *s1 - (int) *s2;
  800455:	0f b6 c0             	movzbl %al,%eax
  800458:	0f b6 db             	movzbl %bl,%ebx
  80045b:	29 d8                	sub    %ebx,%eax
  80045d:	eb 11                	jmp    800470 <memcmp+0x4e>
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  80045f:	83 e9 01             	sub    $0x1,%ecx
  800462:	ba 00 00 00 00       	mov    $0x0,%edx
  800467:	85 c9                	test   %ecx,%ecx
  800469:	75 d6                	jne    800441 <memcmp+0x1f>
  80046b:	b8 00 00 00 00       	mov    $0x0,%eax
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
}
  800470:	5b                   	pop    %ebx
  800471:	5e                   	pop    %esi
  800472:	5f                   	pop    %edi
  800473:	5d                   	pop    %ebp
  800474:	c3                   	ret    

00800475 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800475:	55                   	push   %ebp
  800476:	89 e5                	mov    %esp,%ebp
  800478:	8b 45 08             	mov    0x8(%ebp),%eax
	const void *ends = (const char *) s + n;
  80047b:	89 c2                	mov    %eax,%edx
  80047d:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800480:	39 d0                	cmp    %edx,%eax
  800482:	73 15                	jae    800499 <memfind+0x24>
		if (*(const unsigned char *) s == (unsigned char) c)
  800484:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
  800488:	38 08                	cmp    %cl,(%eax)
  80048a:	75 06                	jne    800492 <memfind+0x1d>
  80048c:	eb 0b                	jmp    800499 <memfind+0x24>
  80048e:	38 08                	cmp    %cl,(%eax)
  800490:	74 07                	je     800499 <memfind+0x24>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800492:	83 c0 01             	add    $0x1,%eax
  800495:	39 c2                	cmp    %eax,%edx
  800497:	77 f5                	ja     80048e <memfind+0x19>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
	return (void *) s;
}
  800499:	5d                   	pop    %ebp
  80049a:	c3                   	ret    

0080049b <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  80049b:	55                   	push   %ebp
  80049c:	89 e5                	mov    %esp,%ebp
  80049e:	57                   	push   %edi
  80049f:	56                   	push   %esi
  8004a0:	53                   	push   %ebx
  8004a1:	83 ec 04             	sub    $0x4,%esp
  8004a4:	8b 55 08             	mov    0x8(%ebp),%edx
  8004a7:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8004aa:	0f b6 02             	movzbl (%edx),%eax
  8004ad:	3c 20                	cmp    $0x20,%al
  8004af:	74 04                	je     8004b5 <strtol+0x1a>
  8004b1:	3c 09                	cmp    $0x9,%al
  8004b3:	75 0e                	jne    8004c3 <strtol+0x28>
		s++;
  8004b5:	83 c2 01             	add    $0x1,%edx
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8004b8:	0f b6 02             	movzbl (%edx),%eax
  8004bb:	3c 20                	cmp    $0x20,%al
  8004bd:	74 f6                	je     8004b5 <strtol+0x1a>
  8004bf:	3c 09                	cmp    $0x9,%al
  8004c1:	74 f2                	je     8004b5 <strtol+0x1a>
		s++;

	// plus/minus sign
	if (*s == '+')
  8004c3:	3c 2b                	cmp    $0x2b,%al
  8004c5:	75 0c                	jne    8004d3 <strtol+0x38>
		s++;
  8004c7:	83 c2 01             	add    $0x1,%edx
  8004ca:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8004d1:	eb 15                	jmp    8004e8 <strtol+0x4d>
	else if (*s == '-')
  8004d3:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8004da:	3c 2d                	cmp    $0x2d,%al
  8004dc:	75 0a                	jne    8004e8 <strtol+0x4d>
		s++, neg = 1;
  8004de:	83 c2 01             	add    $0x1,%edx
  8004e1:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  8004e8:	85 db                	test   %ebx,%ebx
  8004ea:	0f 94 c0             	sete   %al
  8004ed:	74 05                	je     8004f4 <strtol+0x59>
  8004ef:	83 fb 10             	cmp    $0x10,%ebx
  8004f2:	75 18                	jne    80050c <strtol+0x71>
  8004f4:	80 3a 30             	cmpb   $0x30,(%edx)
  8004f7:	75 13                	jne    80050c <strtol+0x71>
  8004f9:	80 7a 01 78          	cmpb   $0x78,0x1(%edx)
  8004fd:	8d 76 00             	lea    0x0(%esi),%esi
  800500:	75 0a                	jne    80050c <strtol+0x71>
		s += 2, base = 16;
  800502:	83 c2 02             	add    $0x2,%edx
  800505:	bb 10 00 00 00       	mov    $0x10,%ebx
		s++;
	else if (*s == '-')
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  80050a:	eb 15                	jmp    800521 <strtol+0x86>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  80050c:	84 c0                	test   %al,%al
  80050e:	66 90                	xchg   %ax,%ax
  800510:	74 0f                	je     800521 <strtol+0x86>
  800512:	bb 0a 00 00 00       	mov    $0xa,%ebx
  800517:	80 3a 30             	cmpb   $0x30,(%edx)
  80051a:	75 05                	jne    800521 <strtol+0x86>
		s++, base = 8;
  80051c:	83 c2 01             	add    $0x1,%edx
  80051f:	b3 08                	mov    $0x8,%bl
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  800521:	b8 00 00 00 00       	mov    $0x0,%eax
  800526:	89 de                	mov    %ebx,%esi

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  800528:	0f b6 0a             	movzbl (%edx),%ecx
  80052b:	89 cf                	mov    %ecx,%edi
  80052d:	8d 59 d0             	lea    -0x30(%ecx),%ebx
  800530:	80 fb 09             	cmp    $0x9,%bl
  800533:	77 08                	ja     80053d <strtol+0xa2>
			dig = *s - '0';
  800535:	0f be c9             	movsbl %cl,%ecx
  800538:	83 e9 30             	sub    $0x30,%ecx
  80053b:	eb 1e                	jmp    80055b <strtol+0xc0>
		else if (*s >= 'a' && *s <= 'z')
  80053d:	8d 5f 9f             	lea    -0x61(%edi),%ebx
  800540:	80 fb 19             	cmp    $0x19,%bl
  800543:	77 08                	ja     80054d <strtol+0xb2>
			dig = *s - 'a' + 10;
  800545:	0f be c9             	movsbl %cl,%ecx
  800548:	83 e9 57             	sub    $0x57,%ecx
  80054b:	eb 0e                	jmp    80055b <strtol+0xc0>
		else if (*s >= 'A' && *s <= 'Z')
  80054d:	8d 5f bf             	lea    -0x41(%edi),%ebx
  800550:	80 fb 19             	cmp    $0x19,%bl
  800553:	77 15                	ja     80056a <strtol+0xcf>
			dig = *s - 'A' + 10;
  800555:	0f be c9             	movsbl %cl,%ecx
  800558:	83 e9 37             	sub    $0x37,%ecx
		else
			break;
		if (dig >= base)
  80055b:	39 f1                	cmp    %esi,%ecx
  80055d:	7d 0b                	jge    80056a <strtol+0xcf>
			break;
		s++, val = (val * base) + dig;
  80055f:	83 c2 01             	add    $0x1,%edx
  800562:	0f af c6             	imul   %esi,%eax
  800565:	8d 04 01             	lea    (%ecx,%eax,1),%eax
		// we don't properly detect overflow!
	}
  800568:	eb be                	jmp    800528 <strtol+0x8d>
  80056a:	89 c1                	mov    %eax,%ecx

	if (endptr)
  80056c:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800570:	74 05                	je     800577 <strtol+0xdc>
		*endptr = (char *) s;
  800572:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800575:	89 13                	mov    %edx,(%ebx)
	return (neg ? -val : val);
  800577:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80057b:	74 04                	je     800581 <strtol+0xe6>
  80057d:	89 c8                	mov    %ecx,%eax
  80057f:	f7 d8                	neg    %eax
}
  800581:	83 c4 04             	add    $0x4,%esp
  800584:	5b                   	pop    %ebx
  800585:	5e                   	pop    %esi
  800586:	5f                   	pop    %edi
  800587:	5d                   	pop    %ebp
  800588:	c3                   	ret    
  800589:	00 00                	add    %al,(%eax)
	...

0080058c <sys_cgetc>:
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}

int
sys_cgetc(void)
{
  80058c:	55                   	push   %ebp
  80058d:	89 e5                	mov    %esp,%ebp
  80058f:	83 ec 0c             	sub    $0xc,%esp
  800592:	89 1c 24             	mov    %ebx,(%esp)
  800595:	89 74 24 04          	mov    %esi,0x4(%esp)
  800599:	89 7c 24 08          	mov    %edi,0x8(%esp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80059d:	ba 00 00 00 00       	mov    $0x0,%edx
  8005a2:	b8 01 00 00 00       	mov    $0x1,%eax
  8005a7:	89 d1                	mov    %edx,%ecx
  8005a9:	89 d3                	mov    %edx,%ebx
  8005ab:	89 d7                	mov    %edx,%edi
  8005ad:	89 d6                	mov    %edx,%esi
  8005af:	cd 30                	int    $0x30

int
sys_cgetc(void)
{
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  8005b1:	8b 1c 24             	mov    (%esp),%ebx
  8005b4:	8b 74 24 04          	mov    0x4(%esp),%esi
  8005b8:	8b 7c 24 08          	mov    0x8(%esp),%edi
  8005bc:	89 ec                	mov    %ebp,%esp
  8005be:	5d                   	pop    %ebp
  8005bf:	c3                   	ret    

008005c0 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  8005c0:	55                   	push   %ebp
  8005c1:	89 e5                	mov    %esp,%ebp
  8005c3:	83 ec 0c             	sub    $0xc,%esp
  8005c6:	89 1c 24             	mov    %ebx,(%esp)
  8005c9:	89 74 24 04          	mov    %esi,0x4(%esp)
  8005cd:	89 7c 24 08          	mov    %edi,0x8(%esp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8005d1:	b8 00 00 00 00       	mov    $0x0,%eax
  8005d6:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8005d9:	8b 55 08             	mov    0x8(%ebp),%edx
  8005dc:	89 c3                	mov    %eax,%ebx
  8005de:	89 c7                	mov    %eax,%edi
  8005e0:	89 c6                	mov    %eax,%esi
  8005e2:	cd 30                	int    $0x30

void
sys_cputs(const char *s, size_t len)
{
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  8005e4:	8b 1c 24             	mov    (%esp),%ebx
  8005e7:	8b 74 24 04          	mov    0x4(%esp),%esi
  8005eb:	8b 7c 24 08          	mov    0x8(%esp),%edi
  8005ef:	89 ec                	mov    %ebp,%esp
  8005f1:	5d                   	pop    %ebp
  8005f2:	c3                   	ret    

008005f3 <sys_page_insert>:
{
	return syscall(SYS_page_waste, 0, (uint32_t)p, (uint32_t)n, 0, 0,0);
}
int
sys_page_insert(envid_t envid, void *va, struct Page *p, int perm)
{
  8005f3:	55                   	push   %ebp
  8005f4:	89 e5                	mov    %esp,%ebp
  8005f6:	83 ec 38             	sub    $0x38,%esp
  8005f9:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  8005fc:	89 75 f8             	mov    %esi,-0x8(%ebp)
  8005ff:	89 7d fc             	mov    %edi,-0x4(%ebp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800602:	be 00 00 00 00       	mov    $0x0,%esi
  800607:	b8 12 00 00 00       	mov    $0x12,%eax
  80060c:	8b 7d 14             	mov    0x14(%ebp),%edi
  80060f:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800612:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800615:	8b 55 08             	mov    0x8(%ebp),%edx
  800618:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
	
	if(check && ret > 0)
  80061a:	85 c0                	test   %eax,%eax
  80061c:	7e 28                	jle    800646 <sys_page_insert+0x53>
		panic("syscall %d returned %d (> 0)", num, ret);
  80061e:	89 44 24 10          	mov    %eax,0x10(%esp)
  800622:	c7 44 24 0c 12 00 00 	movl   $0x12,0xc(%esp)
  800629:	00 
  80062a:	c7 44 24 08 ba 28 80 	movl   $0x8028ba,0x8(%esp)
  800631:	00 
  800632:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800639:	00 
  80063a:	c7 04 24 d7 28 80 00 	movl   $0x8028d7,(%esp)
  800641:	e8 96 17 00 00       	call   801ddc <_panic>
}
int
sys_page_insert(envid_t envid, void *va, struct Page *p, int perm)
{
	return syscall(SYS_page_insert, 1, envid, (uint32_t) va, (uint32_t)p, perm, 0);
}
  800646:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800649:	8b 75 f8             	mov    -0x8(%ebp),%esi
  80064c:	8b 7d fc             	mov    -0x4(%ebp),%edi
  80064f:	89 ec                	mov    %ebp,%esp
  800651:	5d                   	pop    %ebp
  800652:	c3                   	ret    

00800653 <sys_page_waste>:
{
	return (int)syscall(SYS_receive_packet, 0, (uint32_t)buffer, 0,0,0,0);
}

int sys_page_waste(struct Page **p, int n)
{
  800653:	55                   	push   %ebp
  800654:	89 e5                	mov    %esp,%ebp
  800656:	83 ec 0c             	sub    $0xc,%esp
  800659:	89 1c 24             	mov    %ebx,(%esp)
  80065c:	89 74 24 04          	mov    %esi,0x4(%esp)
  800660:	89 7c 24 08          	mov    %edi,0x8(%esp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800664:	bb 00 00 00 00       	mov    $0x0,%ebx
  800669:	b8 11 00 00 00       	mov    $0x11,%eax
  80066e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800671:	8b 55 08             	mov    0x8(%ebp),%edx
  800674:	89 df                	mov    %ebx,%edi
  800676:	89 de                	mov    %ebx,%esi
  800678:	cd 30                	int    $0x30
}

int sys_page_waste(struct Page **p, int n)
{
	return syscall(SYS_page_waste, 0, (uint32_t)p, (uint32_t)n, 0, 0,0);
}
  80067a:	8b 1c 24             	mov    (%esp),%ebx
  80067d:	8b 74 24 04          	mov    0x4(%esp),%esi
  800681:	8b 7c 24 08          	mov    0x8(%esp),%edi
  800685:	89 ec                	mov    %ebp,%esp
  800687:	5d                   	pop    %ebp
  800688:	c3                   	ret    

00800689 <sys_receive_packet>:
{
	return (int)syscall(SYS_transmit_packet, 1, (uint32_t)data, len, 0,0,0);
}

int sys_receive_packet(void* buffer)
{
  800689:	55                   	push   %ebp
  80068a:	89 e5                	mov    %esp,%ebp
  80068c:	83 ec 0c             	sub    $0xc,%esp
  80068f:	89 1c 24             	mov    %ebx,(%esp)
  800692:	89 74 24 04          	mov    %esi,0x4(%esp)
  800696:	89 7c 24 08          	mov    %edi,0x8(%esp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80069a:	b9 00 00 00 00       	mov    $0x0,%ecx
  80069f:	b8 10 00 00 00       	mov    $0x10,%eax
  8006a4:	8b 55 08             	mov    0x8(%ebp),%edx
  8006a7:	89 cb                	mov    %ecx,%ebx
  8006a9:	89 cf                	mov    %ecx,%edi
  8006ab:	89 ce                	mov    %ecx,%esi
  8006ad:	cd 30                	int    $0x30
}

int sys_receive_packet(void* buffer)
{
	return (int)syscall(SYS_receive_packet, 0, (uint32_t)buffer, 0,0,0,0);
}
  8006af:	8b 1c 24             	mov    (%esp),%ebx
  8006b2:	8b 74 24 04          	mov    0x4(%esp),%esi
  8006b6:	8b 7c 24 08          	mov    0x8(%esp),%edi
  8006ba:	89 ec                	mov    %ebp,%esp
  8006bc:	5d                   	pop    %ebp
  8006bd:	c3                   	ret    

008006be <sys_transmit_packet>:
{
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0,0);
}

int sys_transmit_packet(void* data, uint32_t len)
{
  8006be:	55                   	push   %ebp
  8006bf:	89 e5                	mov    %esp,%ebp
  8006c1:	83 ec 38             	sub    $0x38,%esp
  8006c4:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  8006c7:	89 75 f8             	mov    %esi,-0x8(%ebp)
  8006ca:	89 7d fc             	mov    %edi,-0x4(%ebp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8006cd:	bb 00 00 00 00       	mov    $0x0,%ebx
  8006d2:	b8 0f 00 00 00       	mov    $0xf,%eax
  8006d7:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8006da:	8b 55 08             	mov    0x8(%ebp),%edx
  8006dd:	89 df                	mov    %ebx,%edi
  8006df:	89 de                	mov    %ebx,%esi
  8006e1:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
	
	if(check && ret > 0)
  8006e3:	85 c0                	test   %eax,%eax
  8006e5:	7e 28                	jle    80070f <sys_transmit_packet+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  8006e7:	89 44 24 10          	mov    %eax,0x10(%esp)
  8006eb:	c7 44 24 0c 0f 00 00 	movl   $0xf,0xc(%esp)
  8006f2:	00 
  8006f3:	c7 44 24 08 ba 28 80 	movl   $0x8028ba,0x8(%esp)
  8006fa:	00 
  8006fb:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800702:	00 
  800703:	c7 04 24 d7 28 80 00 	movl   $0x8028d7,(%esp)
  80070a:	e8 cd 16 00 00       	call   801ddc <_panic>
}

int sys_transmit_packet(void* data, uint32_t len)
{
	return (int)syscall(SYS_transmit_packet, 1, (uint32_t)data, len, 0,0,0);
}
  80070f:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800712:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800715:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800718:	89 ec                	mov    %ebp,%esp
  80071a:	5d                   	pop    %ebp
  80071b:	c3                   	ret    

0080071c <sys_time_msec>:
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}

unsigned int
sys_time_msec(void)
{
  80071c:	55                   	push   %ebp
  80071d:	89 e5                	mov    %esp,%ebp
  80071f:	83 ec 0c             	sub    $0xc,%esp
  800722:	89 1c 24             	mov    %ebx,(%esp)
  800725:	89 74 24 04          	mov    %esi,0x4(%esp)
  800729:	89 7c 24 08          	mov    %edi,0x8(%esp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80072d:	ba 00 00 00 00       	mov    $0x0,%edx
  800732:	b8 0e 00 00 00       	mov    $0xe,%eax
  800737:	89 d1                	mov    %edx,%ecx
  800739:	89 d3                	mov    %edx,%ebx
  80073b:	89 d7                	mov    %edx,%edi
  80073d:	89 d6                	mov    %edx,%esi
  80073f:	cd 30                	int    $0x30

unsigned int
sys_time_msec(void)
{
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0,0);
}
  800741:	8b 1c 24             	mov    (%esp),%ebx
  800744:	8b 74 24 04          	mov    0x4(%esp),%esi
  800748:	8b 7c 24 08          	mov    0x8(%esp),%edi
  80074c:	89 ec                	mov    %ebp,%esp
  80074e:	5d                   	pop    %ebp
  80074f:	c3                   	ret    

00800750 <sys_ipc_recv>:
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}

int
sys_ipc_recv(void *dstva)
{
  800750:	55                   	push   %ebp
  800751:	89 e5                	mov    %esp,%ebp
  800753:	83 ec 38             	sub    $0x38,%esp
  800756:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800759:	89 75 f8             	mov    %esi,-0x8(%ebp)
  80075c:	89 7d fc             	mov    %edi,-0x4(%ebp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80075f:	b9 00 00 00 00       	mov    $0x0,%ecx
  800764:	b8 0d 00 00 00       	mov    $0xd,%eax
  800769:	8b 55 08             	mov    0x8(%ebp),%edx
  80076c:	89 cb                	mov    %ecx,%ebx
  80076e:	89 cf                	mov    %ecx,%edi
  800770:	89 ce                	mov    %ecx,%esi
  800772:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
	
	if(check && ret > 0)
  800774:	85 c0                	test   %eax,%eax
  800776:	7e 28                	jle    8007a0 <sys_ipc_recv+0x50>
		panic("syscall %d returned %d (> 0)", num, ret);
  800778:	89 44 24 10          	mov    %eax,0x10(%esp)
  80077c:	c7 44 24 0c 0d 00 00 	movl   $0xd,0xc(%esp)
  800783:	00 
  800784:	c7 44 24 08 ba 28 80 	movl   $0x8028ba,0x8(%esp)
  80078b:	00 
  80078c:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800793:	00 
  800794:	c7 04 24 d7 28 80 00 	movl   $0x8028d7,(%esp)
  80079b:	e8 3c 16 00 00       	call   801ddc <_panic>

int
sys_ipc_recv(void *dstva)
{
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  8007a0:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  8007a3:	8b 75 f8             	mov    -0x8(%ebp),%esi
  8007a6:	8b 7d fc             	mov    -0x4(%ebp),%edi
  8007a9:	89 ec                	mov    %ebp,%esp
  8007ab:	5d                   	pop    %ebp
  8007ac:	c3                   	ret    

008007ad <sys_ipc_try_send>:
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  8007ad:	55                   	push   %ebp
  8007ae:	89 e5                	mov    %esp,%ebp
  8007b0:	83 ec 0c             	sub    $0xc,%esp
  8007b3:	89 1c 24             	mov    %ebx,(%esp)
  8007b6:	89 74 24 04          	mov    %esi,0x4(%esp)
  8007ba:	89 7c 24 08          	mov    %edi,0x8(%esp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8007be:	be 00 00 00 00       	mov    $0x0,%esi
  8007c3:	b8 0c 00 00 00       	mov    $0xc,%eax
  8007c8:	8b 7d 14             	mov    0x14(%ebp),%edi
  8007cb:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8007ce:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8007d1:	8b 55 08             	mov    0x8(%ebp),%edx
  8007d4:	cd 30                	int    $0x30

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  8007d6:	8b 1c 24             	mov    (%esp),%ebx
  8007d9:	8b 74 24 04          	mov    0x4(%esp),%esi
  8007dd:	8b 7c 24 08          	mov    0x8(%esp),%edi
  8007e1:	89 ec                	mov    %ebp,%esp
  8007e3:	5d                   	pop    %ebp
  8007e4:	c3                   	ret    

008007e5 <sys_env_set_pgfault_upcall>:
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  8007e5:	55                   	push   %ebp
  8007e6:	89 e5                	mov    %esp,%ebp
  8007e8:	83 ec 38             	sub    $0x38,%esp
  8007eb:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  8007ee:	89 75 f8             	mov    %esi,-0x8(%ebp)
  8007f1:	89 7d fc             	mov    %edi,-0x4(%ebp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8007f4:	bb 00 00 00 00       	mov    $0x0,%ebx
  8007f9:	b8 0a 00 00 00       	mov    $0xa,%eax
  8007fe:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800801:	8b 55 08             	mov    0x8(%ebp),%edx
  800804:	89 df                	mov    %ebx,%edi
  800806:	89 de                	mov    %ebx,%esi
  800808:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
	
	if(check && ret > 0)
  80080a:	85 c0                	test   %eax,%eax
  80080c:	7e 28                	jle    800836 <sys_env_set_pgfault_upcall+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  80080e:	89 44 24 10          	mov    %eax,0x10(%esp)
  800812:	c7 44 24 0c 0a 00 00 	movl   $0xa,0xc(%esp)
  800819:	00 
  80081a:	c7 44 24 08 ba 28 80 	movl   $0x8028ba,0x8(%esp)
  800821:	00 
  800822:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800829:	00 
  80082a:	c7 04 24 d7 28 80 00 	movl   $0x8028d7,(%esp)
  800831:	e8 a6 15 00 00       	call   801ddc <_panic>

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  800836:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800839:	8b 75 f8             	mov    -0x8(%ebp),%esi
  80083c:	8b 7d fc             	mov    -0x4(%ebp),%edi
  80083f:	89 ec                	mov    %ebp,%esp
  800841:	5d                   	pop    %ebp
  800842:	c3                   	ret    

00800843 <sys_env_set_trapframe>:
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800843:	55                   	push   %ebp
  800844:	89 e5                	mov    %esp,%ebp
  800846:	83 ec 38             	sub    $0x38,%esp
  800849:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  80084c:	89 75 f8             	mov    %esi,-0x8(%ebp)
  80084f:	89 7d fc             	mov    %edi,-0x4(%ebp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800852:	bb 00 00 00 00       	mov    $0x0,%ebx
  800857:	b8 09 00 00 00       	mov    $0x9,%eax
  80085c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80085f:	8b 55 08             	mov    0x8(%ebp),%edx
  800862:	89 df                	mov    %ebx,%edi
  800864:	89 de                	mov    %ebx,%esi
  800866:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
	
	if(check && ret > 0)
  800868:	85 c0                	test   %eax,%eax
  80086a:	7e 28                	jle    800894 <sys_env_set_trapframe+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  80086c:	89 44 24 10          	mov    %eax,0x10(%esp)
  800870:	c7 44 24 0c 09 00 00 	movl   $0x9,0xc(%esp)
  800877:	00 
  800878:	c7 44 24 08 ba 28 80 	movl   $0x8028ba,0x8(%esp)
  80087f:	00 
  800880:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800887:	00 
  800888:	c7 04 24 d7 28 80 00 	movl   $0x8028d7,(%esp)
  80088f:	e8 48 15 00 00       	call   801ddc <_panic>

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  800894:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800897:	8b 75 f8             	mov    -0x8(%ebp),%esi
  80089a:	8b 7d fc             	mov    -0x4(%ebp),%edi
  80089d:	89 ec                	mov    %ebp,%esp
  80089f:	5d                   	pop    %ebp
  8008a0:	c3                   	ret    

008008a1 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  8008a1:	55                   	push   %ebp
  8008a2:	89 e5                	mov    %esp,%ebp
  8008a4:	83 ec 38             	sub    $0x38,%esp
  8008a7:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  8008aa:	89 75 f8             	mov    %esi,-0x8(%ebp)
  8008ad:	89 7d fc             	mov    %edi,-0x4(%ebp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8008b0:	bb 00 00 00 00       	mov    $0x0,%ebx
  8008b5:	b8 08 00 00 00       	mov    $0x8,%eax
  8008ba:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8008bd:	8b 55 08             	mov    0x8(%ebp),%edx
  8008c0:	89 df                	mov    %ebx,%edi
  8008c2:	89 de                	mov    %ebx,%esi
  8008c4:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
	
	if(check && ret > 0)
  8008c6:	85 c0                	test   %eax,%eax
  8008c8:	7e 28                	jle    8008f2 <sys_env_set_status+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  8008ca:	89 44 24 10          	mov    %eax,0x10(%esp)
  8008ce:	c7 44 24 0c 08 00 00 	movl   $0x8,0xc(%esp)
  8008d5:	00 
  8008d6:	c7 44 24 08 ba 28 80 	movl   $0x8028ba,0x8(%esp)
  8008dd:	00 
  8008de:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  8008e5:	00 
  8008e6:	c7 04 24 d7 28 80 00 	movl   $0x8028d7,(%esp)
  8008ed:	e8 ea 14 00 00       	call   801ddc <_panic>

int
sys_env_set_status(envid_t envid, int status)
{
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  8008f2:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  8008f5:	8b 75 f8             	mov    -0x8(%ebp),%esi
  8008f8:	8b 7d fc             	mov    -0x4(%ebp),%edi
  8008fb:	89 ec                	mov    %ebp,%esp
  8008fd:	5d                   	pop    %ebp
  8008fe:	c3                   	ret    

008008ff <sys_page_unmap>:
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}

int
sys_page_unmap(envid_t envid, void *va)
{
  8008ff:	55                   	push   %ebp
  800900:	89 e5                	mov    %esp,%ebp
  800902:	83 ec 38             	sub    $0x38,%esp
  800905:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800908:	89 75 f8             	mov    %esi,-0x8(%ebp)
  80090b:	89 7d fc             	mov    %edi,-0x4(%ebp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80090e:	bb 00 00 00 00       	mov    $0x0,%ebx
  800913:	b8 06 00 00 00       	mov    $0x6,%eax
  800918:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80091b:	8b 55 08             	mov    0x8(%ebp),%edx
  80091e:	89 df                	mov    %ebx,%edi
  800920:	89 de                	mov    %ebx,%esi
  800922:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
	
	if(check && ret > 0)
  800924:	85 c0                	test   %eax,%eax
  800926:	7e 28                	jle    800950 <sys_page_unmap+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  800928:	89 44 24 10          	mov    %eax,0x10(%esp)
  80092c:	c7 44 24 0c 06 00 00 	movl   $0x6,0xc(%esp)
  800933:	00 
  800934:	c7 44 24 08 ba 28 80 	movl   $0x8028ba,0x8(%esp)
  80093b:	00 
  80093c:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800943:	00 
  800944:	c7 04 24 d7 28 80 00 	movl   $0x8028d7,(%esp)
  80094b:	e8 8c 14 00 00       	call   801ddc <_panic>

int
sys_page_unmap(envid_t envid, void *va)
{
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800950:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800953:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800956:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800959:	89 ec                	mov    %ebp,%esp
  80095b:	5d                   	pop    %ebp
  80095c:	c3                   	ret    

0080095d <sys_page_map>:
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  80095d:	55                   	push   %ebp
  80095e:	89 e5                	mov    %esp,%ebp
  800960:	83 ec 38             	sub    $0x38,%esp
  800963:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800966:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800969:	89 7d fc             	mov    %edi,-0x4(%ebp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80096c:	b8 05 00 00 00       	mov    $0x5,%eax
  800971:	8b 75 18             	mov    0x18(%ebp),%esi
  800974:	8b 7d 14             	mov    0x14(%ebp),%edi
  800977:	8b 5d 10             	mov    0x10(%ebp),%ebx
  80097a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80097d:	8b 55 08             	mov    0x8(%ebp),%edx
  800980:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
	
	if(check && ret > 0)
  800982:	85 c0                	test   %eax,%eax
  800984:	7e 28                	jle    8009ae <sys_page_map+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  800986:	89 44 24 10          	mov    %eax,0x10(%esp)
  80098a:	c7 44 24 0c 05 00 00 	movl   $0x5,0xc(%esp)
  800991:	00 
  800992:	c7 44 24 08 ba 28 80 	movl   $0x8028ba,0x8(%esp)
  800999:	00 
  80099a:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  8009a1:	00 
  8009a2:	c7 04 24 d7 28 80 00 	movl   $0x8028d7,(%esp)
  8009a9:	e8 2e 14 00 00       	call   801ddc <_panic>

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  8009ae:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  8009b1:	8b 75 f8             	mov    -0x8(%ebp),%esi
  8009b4:	8b 7d fc             	mov    -0x4(%ebp),%edi
  8009b7:	89 ec                	mov    %ebp,%esp
  8009b9:	5d                   	pop    %ebp
  8009ba:	c3                   	ret    

008009bb <sys_page_alloc>:
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  8009bb:	55                   	push   %ebp
  8009bc:	89 e5                	mov    %esp,%ebp
  8009be:	83 ec 38             	sub    $0x38,%esp
  8009c1:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  8009c4:	89 75 f8             	mov    %esi,-0x8(%ebp)
  8009c7:	89 7d fc             	mov    %edi,-0x4(%ebp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8009ca:	be 00 00 00 00       	mov    $0x0,%esi
  8009cf:	b8 04 00 00 00       	mov    $0x4,%eax
  8009d4:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8009d7:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8009da:	8b 55 08             	mov    0x8(%ebp),%edx
  8009dd:	89 f7                	mov    %esi,%edi
  8009df:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
	
	if(check && ret > 0)
  8009e1:	85 c0                	test   %eax,%eax
  8009e3:	7e 28                	jle    800a0d <sys_page_alloc+0x52>
		panic("syscall %d returned %d (> 0)", num, ret);
  8009e5:	89 44 24 10          	mov    %eax,0x10(%esp)
  8009e9:	c7 44 24 0c 04 00 00 	movl   $0x4,0xc(%esp)
  8009f0:	00 
  8009f1:	c7 44 24 08 ba 28 80 	movl   $0x8028ba,0x8(%esp)
  8009f8:	00 
  8009f9:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800a00:	00 
  800a01:	c7 04 24 d7 28 80 00 	movl   $0x8028d7,(%esp)
  800a08:	e8 cf 13 00 00       	call   801ddc <_panic>

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800a0d:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800a10:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800a13:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800a16:	89 ec                	mov    %ebp,%esp
  800a18:	5d                   	pop    %ebp
  800a19:	c3                   	ret    

00800a1a <sys_yield>:
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}

void
sys_yield(void)
{
  800a1a:	55                   	push   %ebp
  800a1b:	89 e5                	mov    %esp,%ebp
  800a1d:	83 ec 0c             	sub    $0xc,%esp
  800a20:	89 1c 24             	mov    %ebx,(%esp)
  800a23:	89 74 24 04          	mov    %esi,0x4(%esp)
  800a27:	89 7c 24 08          	mov    %edi,0x8(%esp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800a2b:	ba 00 00 00 00       	mov    $0x0,%edx
  800a30:	b8 0b 00 00 00       	mov    $0xb,%eax
  800a35:	89 d1                	mov    %edx,%ecx
  800a37:	89 d3                	mov    %edx,%ebx
  800a39:	89 d7                	mov    %edx,%edi
  800a3b:	89 d6                	mov    %edx,%esi
  800a3d:	cd 30                	int    $0x30

void
sys_yield(void)
{
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800a3f:	8b 1c 24             	mov    (%esp),%ebx
  800a42:	8b 74 24 04          	mov    0x4(%esp),%esi
  800a46:	8b 7c 24 08          	mov    0x8(%esp),%edi
  800a4a:	89 ec                	mov    %ebp,%esp
  800a4c:	5d                   	pop    %ebp
  800a4d:	c3                   	ret    

00800a4e <sys_getenvid>:
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}

envid_t
sys_getenvid(void)
{
  800a4e:	55                   	push   %ebp
  800a4f:	89 e5                	mov    %esp,%ebp
  800a51:	83 ec 0c             	sub    $0xc,%esp
  800a54:	89 1c 24             	mov    %ebx,(%esp)
  800a57:	89 74 24 04          	mov    %esi,0x4(%esp)
  800a5b:	89 7c 24 08          	mov    %edi,0x8(%esp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800a5f:	ba 00 00 00 00       	mov    $0x0,%edx
  800a64:	b8 02 00 00 00       	mov    $0x2,%eax
  800a69:	89 d1                	mov    %edx,%ecx
  800a6b:	89 d3                	mov    %edx,%ebx
  800a6d:	89 d7                	mov    %edx,%edi
  800a6f:	89 d6                	mov    %edx,%esi
  800a71:	cd 30                	int    $0x30

envid_t
sys_getenvid(void)
{
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800a73:	8b 1c 24             	mov    (%esp),%ebx
  800a76:	8b 74 24 04          	mov    0x4(%esp),%esi
  800a7a:	8b 7c 24 08          	mov    0x8(%esp),%edi
  800a7e:	89 ec                	mov    %ebp,%esp
  800a80:	5d                   	pop    %ebp
  800a81:	c3                   	ret    

00800a82 <sys_env_destroy>:
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}

int
sys_env_destroy(envid_t envid)
{
  800a82:	55                   	push   %ebp
  800a83:	89 e5                	mov    %esp,%ebp
  800a85:	83 ec 38             	sub    $0x38,%esp
  800a88:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800a8b:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800a8e:	89 7d fc             	mov    %edi,-0x4(%ebp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800a91:	b9 00 00 00 00       	mov    $0x0,%ecx
  800a96:	b8 03 00 00 00       	mov    $0x3,%eax
  800a9b:	8b 55 08             	mov    0x8(%ebp),%edx
  800a9e:	89 cb                	mov    %ecx,%ebx
  800aa0:	89 cf                	mov    %ecx,%edi
  800aa2:	89 ce                	mov    %ecx,%esi
  800aa4:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
	
	if(check && ret > 0)
  800aa6:	85 c0                	test   %eax,%eax
  800aa8:	7e 28                	jle    800ad2 <sys_env_destroy+0x50>
		panic("syscall %d returned %d (> 0)", num, ret);
  800aaa:	89 44 24 10          	mov    %eax,0x10(%esp)
  800aae:	c7 44 24 0c 03 00 00 	movl   $0x3,0xc(%esp)
  800ab5:	00 
  800ab6:	c7 44 24 08 ba 28 80 	movl   $0x8028ba,0x8(%esp)
  800abd:	00 
  800abe:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800ac5:	00 
  800ac6:	c7 04 24 d7 28 80 00 	movl   $0x8028d7,(%esp)
  800acd:	e8 0a 13 00 00       	call   801ddc <_panic>

int
sys_env_destroy(envid_t envid)
{
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800ad2:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800ad5:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800ad8:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800adb:	89 ec                	mov    %ebp,%esp
  800add:	5d                   	pop    %ebp
  800ade:	c3                   	ret    
	...

00800ae0 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  800ae0:	55                   	push   %ebp
  800ae1:	89 e5                	mov    %esp,%ebp
  800ae3:	8b 45 08             	mov    0x8(%ebp),%eax
  800ae6:	05 00 00 00 30       	add    $0x30000000,%eax
  800aeb:	c1 e8 0c             	shr    $0xc,%eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
}
  800aee:	5d                   	pop    %ebp
  800aef:	c3                   	ret    

00800af0 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  800af0:	55                   	push   %ebp
  800af1:	89 e5                	mov    %esp,%ebp
  800af3:	83 ec 04             	sub    $0x4,%esp
	return INDEX2DATA(fd2num(fd));
  800af6:	8b 45 08             	mov    0x8(%ebp),%eax
  800af9:	89 04 24             	mov    %eax,(%esp)
  800afc:	e8 df ff ff ff       	call   800ae0 <fd2num>
  800b01:	05 20 00 0d 00       	add    $0xd0020,%eax
  800b06:	c1 e0 0c             	shl    $0xc,%eax
}
  800b09:	c9                   	leave  
  800b0a:	c3                   	ret    

00800b0b <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  800b0b:	55                   	push   %ebp
  800b0c:	89 e5                	mov    %esp,%ebp
  800b0e:	57                   	push   %edi
  800b0f:	56                   	push   %esi
  800b10:	53                   	push   %ebx
  800b11:	8b 7d 08             	mov    0x8(%ebp),%edi
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((vpd[PDX(fd)] & PTE_P) == 0 || (vpt[VPN(fd)] & PTE_P) == 0) {
  800b14:	a1 00 dd 7b ef       	mov    0xef7bdd00,%eax
  800b19:	a8 01                	test   $0x1,%al
  800b1b:	74 36                	je     800b53 <fd_alloc+0x48>
  800b1d:	a1 00 00 74 ef       	mov    0xef740000,%eax
  800b22:	a8 01                	test   $0x1,%al
  800b24:	74 2d                	je     800b53 <fd_alloc+0x48>
  800b26:	b8 00 10 00 d0       	mov    $0xd0001000,%eax
  800b2b:	b9 00 d0 7b ef       	mov    $0xef7bd000,%ecx
  800b30:	be 00 00 40 ef       	mov    $0xef400000,%esi
  800b35:	89 c3                	mov    %eax,%ebx
  800b37:	89 c2                	mov    %eax,%edx
  800b39:	c1 ea 16             	shr    $0x16,%edx
  800b3c:	8b 14 91             	mov    (%ecx,%edx,4),%edx
  800b3f:	f6 c2 01             	test   $0x1,%dl
  800b42:	74 14                	je     800b58 <fd_alloc+0x4d>
  800b44:	89 c2                	mov    %eax,%edx
  800b46:	c1 ea 0c             	shr    $0xc,%edx
  800b49:	8b 14 96             	mov    (%esi,%edx,4),%edx
  800b4c:	f6 c2 01             	test   $0x1,%dl
  800b4f:	75 10                	jne    800b61 <fd_alloc+0x56>
  800b51:	eb 05                	jmp    800b58 <fd_alloc+0x4d>
  800b53:	bb 00 00 00 d0       	mov    $0xd0000000,%ebx
			*fd_store = fd;
  800b58:	89 1f                	mov    %ebx,(%edi)
  800b5a:	b8 00 00 00 00       	mov    $0x0,%eax
			return 0;
  800b5f:	eb 17                	jmp    800b78 <fd_alloc+0x6d>
  800b61:	05 00 10 00 00       	add    $0x1000,%eax
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  800b66:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  800b6b:	75 c8                	jne    800b35 <fd_alloc+0x2a>
		if ((vpd[PDX(fd)] & PTE_P) == 0 || (vpt[VPN(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  800b6d:	c7 07 00 00 00 00    	movl   $0x0,(%edi)
  800b73:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
	return -E_MAX_OPEN;
}
  800b78:	5b                   	pop    %ebx
  800b79:	5e                   	pop    %esi
  800b7a:	5f                   	pop    %edi
  800b7b:	5d                   	pop    %ebp
  800b7c:	c3                   	ret    

00800b7d <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  800b7d:	55                   	push   %ebp
  800b7e:	89 e5                	mov    %esp,%ebp
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  800b80:	8b 45 08             	mov    0x8(%ebp),%eax
  800b83:	83 f8 1f             	cmp    $0x1f,%eax
  800b86:	77 36                	ja     800bbe <fd_lookup+0x41>
		if (debug)
			cprintf("[%08x] bad fd %d\n", env->env_id, fd);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  800b88:	05 00 00 0d 00       	add    $0xd0000,%eax
  800b8d:	c1 e0 0c             	shl    $0xc,%eax
	if (!(vpd[PDX(fd)] & PTE_P) || !(vpt[VPN(fd)] & PTE_P)) {
  800b90:	89 c2                	mov    %eax,%edx
  800b92:	c1 ea 16             	shr    $0x16,%edx
  800b95:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  800b9c:	f6 c2 01             	test   $0x1,%dl
  800b9f:	74 1d                	je     800bbe <fd_lookup+0x41>
  800ba1:	89 c2                	mov    %eax,%edx
  800ba3:	c1 ea 0c             	shr    $0xc,%edx
  800ba6:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  800bad:	f6 c2 01             	test   $0x1,%dl
  800bb0:	74 0c                	je     800bbe <fd_lookup+0x41>
		if (debug)
			cprintf("[%08x] closed fd %d\n", env->env_id, fd);
		return -E_INVAL;
	}
	*fd_store = fd;
  800bb2:	8b 55 0c             	mov    0xc(%ebp),%edx
  800bb5:	89 02                	mov    %eax,(%edx)
  800bb7:	b8 00 00 00 00       	mov    $0x0,%eax
	return 0;
  800bbc:	eb 05                	jmp    800bc3 <fd_lookup+0x46>
  800bbe:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  800bc3:	5d                   	pop    %ebp
  800bc4:	c3                   	ret    

00800bc5 <seek>:
	return (*dev->dev_write)(fd, buf, n);
}

int
seek(int fdnum, off_t offset)
{
  800bc5:	55                   	push   %ebp
  800bc6:	89 e5                	mov    %esp,%ebp
  800bc8:	83 ec 18             	sub    $0x18,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  800bcb:	8d 45 fc             	lea    -0x4(%ebp),%eax
  800bce:	89 44 24 04          	mov    %eax,0x4(%esp)
  800bd2:	8b 45 08             	mov    0x8(%ebp),%eax
  800bd5:	89 04 24             	mov    %eax,(%esp)
  800bd8:	e8 a0 ff ff ff       	call   800b7d <fd_lookup>
  800bdd:	85 c0                	test   %eax,%eax
  800bdf:	78 0e                	js     800bef <seek+0x2a>
		return r;
	fd->fd_offset = offset;
  800be1:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800be4:	8b 55 0c             	mov    0xc(%ebp),%edx
  800be7:	89 50 04             	mov    %edx,0x4(%eax)
  800bea:	b8 00 00 00 00       	mov    $0x0,%eax
	return 0;
}
  800bef:	c9                   	leave  
  800bf0:	c3                   	ret    

00800bf1 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  800bf1:	55                   	push   %ebp
  800bf2:	89 e5                	mov    %esp,%ebp
  800bf4:	56                   	push   %esi
  800bf5:	53                   	push   %ebx
  800bf6:	83 ec 10             	sub    $0x10,%esp
  800bf9:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800bfc:	8b 5d 0c             	mov    0xc(%ebp),%ebx
// File functions
// --------------------------------------------------------------

static struct Dev *devtab[] =
{
	&devfile,
  800bff:	b8 04 60 80 00       	mov    $0x806004,%eax
{
	int i;
	for (i = 0; devtab[i]; i++)
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
  800c04:	ba 00 00 00 00       	mov    $0x0,%edx

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  800c09:	be 64 29 80 00       	mov    $0x802964,%esi
		if (devtab[i]->dev_id == dev_id) {
  800c0e:	39 08                	cmp    %ecx,(%eax)
  800c10:	75 10                	jne    800c22 <dev_lookup+0x31>
  800c12:	eb 04                	jmp    800c18 <dev_lookup+0x27>
  800c14:	39 08                	cmp    %ecx,(%eax)
  800c16:	75 0a                	jne    800c22 <dev_lookup+0x31>
			*dev = devtab[i];
  800c18:	89 03                	mov    %eax,(%ebx)
  800c1a:	b8 00 00 00 00       	mov    $0x0,%eax
			return 0;
  800c1f:	90                   	nop
  800c20:	eb 31                	jmp    800c53 <dev_lookup+0x62>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  800c22:	83 c2 01             	add    $0x1,%edx
  800c25:	8b 04 96             	mov    (%esi,%edx,4),%eax
  800c28:	85 c0                	test   %eax,%eax
  800c2a:	75 e8                	jne    800c14 <dev_lookup+0x23>
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", env->env_id, dev_id);
  800c2c:	a1 74 60 80 00       	mov    0x806074,%eax
  800c31:	8b 40 4c             	mov    0x4c(%eax),%eax
  800c34:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  800c38:	89 44 24 04          	mov    %eax,0x4(%esp)
  800c3c:	c7 04 24 e8 28 80 00 	movl   $0x8028e8,(%esp)
  800c43:	e8 59 12 00 00       	call   801ea1 <cprintf>
	*dev = 0;
  800c48:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  800c4e:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
	return -E_INVAL;
}
  800c53:	83 c4 10             	add    $0x10,%esp
  800c56:	5b                   	pop    %ebx
  800c57:	5e                   	pop    %esi
  800c58:	5d                   	pop    %ebp
  800c59:	c3                   	ret    

00800c5a <fstat>:
	return (*dev->dev_trunc)(fd, newsize);
}

int
fstat(int fdnum, struct Stat *stat)
{
  800c5a:	55                   	push   %ebp
  800c5b:	89 e5                	mov    %esp,%ebp
  800c5d:	53                   	push   %ebx
  800c5e:	83 ec 24             	sub    $0x24,%esp
  800c61:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  800c64:	8d 45 f0             	lea    -0x10(%ebp),%eax
  800c67:	89 44 24 04          	mov    %eax,0x4(%esp)
  800c6b:	8b 45 08             	mov    0x8(%ebp),%eax
  800c6e:	89 04 24             	mov    %eax,(%esp)
  800c71:	e8 07 ff ff ff       	call   800b7d <fd_lookup>
  800c76:	85 c0                	test   %eax,%eax
  800c78:	78 53                	js     800ccd <fstat+0x73>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  800c7a:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800c7d:	89 44 24 04          	mov    %eax,0x4(%esp)
  800c81:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800c84:	8b 00                	mov    (%eax),%eax
  800c86:	89 04 24             	mov    %eax,(%esp)
  800c89:	e8 63 ff ff ff       	call   800bf1 <dev_lookup>
{
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  800c8e:	85 c0                	test   %eax,%eax
  800c90:	78 3b                	js     800ccd <fstat+0x73>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if (!dev->dev_stat)
  800c92:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  800c97:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800c9a:	83 7a 14 00          	cmpl   $0x0,0x14(%edx)
  800c9e:	74 2d                	je     800ccd <fstat+0x73>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  800ca0:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  800ca3:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  800caa:	00 00 00 
	stat->st_isdir = 0;
  800cad:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  800cb4:	00 00 00 
	stat->st_dev = dev;
  800cb7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800cba:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  800cc0:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  800cc4:	8b 55 f0             	mov    -0x10(%ebp),%edx
  800cc7:	89 14 24             	mov    %edx,(%esp)
  800cca:	ff 50 14             	call   *0x14(%eax)
}
  800ccd:	83 c4 24             	add    $0x24,%esp
  800cd0:	5b                   	pop    %ebx
  800cd1:	5d                   	pop    %ebp
  800cd2:	c3                   	ret    

00800cd3 <ftruncate>:
	return 0;
}

int
ftruncate(int fdnum, off_t newsize)
{
  800cd3:	55                   	push   %ebp
  800cd4:	89 e5                	mov    %esp,%ebp
  800cd6:	53                   	push   %ebx
  800cd7:	83 ec 24             	sub    $0x24,%esp
  800cda:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  800cdd:	8d 45 f0             	lea    -0x10(%ebp),%eax
  800ce0:	89 44 24 04          	mov    %eax,0x4(%esp)
  800ce4:	89 1c 24             	mov    %ebx,(%esp)
  800ce7:	e8 91 fe ff ff       	call   800b7d <fd_lookup>
  800cec:	85 c0                	test   %eax,%eax
  800cee:	78 5f                	js     800d4f <ftruncate+0x7c>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  800cf0:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800cf3:	89 44 24 04          	mov    %eax,0x4(%esp)
  800cf7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800cfa:	8b 00                	mov    (%eax),%eax
  800cfc:	89 04 24             	mov    %eax,(%esp)
  800cff:	e8 ed fe ff ff       	call   800bf1 <dev_lookup>
ftruncate(int fdnum, off_t newsize)
{
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  800d04:	85 c0                	test   %eax,%eax
  800d06:	78 47                	js     800d4f <ftruncate+0x7c>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  800d08:	8b 55 f0             	mov    -0x10(%ebp),%edx
  800d0b:	f6 42 08 03          	testb  $0x3,0x8(%edx)
  800d0f:	75 23                	jne    800d34 <ftruncate+0x61>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			env->env_id, fdnum); 
  800d11:	a1 74 60 80 00       	mov    0x806074,%eax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  800d16:	8b 40 4c             	mov    0x4c(%eax),%eax
  800d19:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  800d1d:	89 44 24 04          	mov    %eax,0x4(%esp)
  800d21:	c7 04 24 08 29 80 00 	movl   $0x802908,(%esp)
  800d28:	e8 74 11 00 00       	call   801ea1 <cprintf>
  800d2d:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
			env->env_id, fdnum); 
		return -E_INVAL;
  800d32:	eb 1b                	jmp    800d4f <ftruncate+0x7c>
	}
	if (!dev->dev_trunc)
  800d34:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800d37:	8b 48 18             	mov    0x18(%eax),%ecx
  800d3a:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  800d3f:	85 c9                	test   %ecx,%ecx
  800d41:	74 0c                	je     800d4f <ftruncate+0x7c>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  800d43:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d46:	89 44 24 04          	mov    %eax,0x4(%esp)
  800d4a:	89 14 24             	mov    %edx,(%esp)
  800d4d:	ff d1                	call   *%ecx
}
  800d4f:	83 c4 24             	add    $0x24,%esp
  800d52:	5b                   	pop    %ebx
  800d53:	5d                   	pop    %ebp
  800d54:	c3                   	ret    

00800d55 <write>:
	return tot;
}

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  800d55:	55                   	push   %ebp
  800d56:	89 e5                	mov    %esp,%ebp
  800d58:	53                   	push   %ebx
  800d59:	83 ec 24             	sub    $0x24,%esp
  800d5c:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  800d5f:	8d 45 f0             	lea    -0x10(%ebp),%eax
  800d62:	89 44 24 04          	mov    %eax,0x4(%esp)
  800d66:	89 1c 24             	mov    %ebx,(%esp)
  800d69:	e8 0f fe ff ff       	call   800b7d <fd_lookup>
  800d6e:	85 c0                	test   %eax,%eax
  800d70:	78 66                	js     800dd8 <write+0x83>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  800d72:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800d75:	89 44 24 04          	mov    %eax,0x4(%esp)
  800d79:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800d7c:	8b 00                	mov    (%eax),%eax
  800d7e:	89 04 24             	mov    %eax,(%esp)
  800d81:	e8 6b fe ff ff       	call   800bf1 <dev_lookup>
{
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  800d86:	85 c0                	test   %eax,%eax
  800d88:	78 4e                	js     800dd8 <write+0x83>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  800d8a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  800d8d:	f6 42 08 03          	testb  $0x3,0x8(%edx)
  800d91:	75 23                	jne    800db6 <write+0x61>
		cprintf("[%08x] write %d -- bad mode\n", env->env_id, fdnum);
  800d93:	a1 74 60 80 00       	mov    0x806074,%eax
  800d98:	8b 40 4c             	mov    0x4c(%eax),%eax
  800d9b:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  800d9f:	89 44 24 04          	mov    %eax,0x4(%esp)
  800da3:	c7 04 24 29 29 80 00 	movl   $0x802929,(%esp)
  800daa:	e8 f2 10 00 00       	call   801ea1 <cprintf>
  800daf:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
		return -E_INVAL;
  800db4:	eb 22                	jmp    800dd8 <write+0x83>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  800db6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800db9:	8b 48 0c             	mov    0xc(%eax),%ecx
  800dbc:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  800dc1:	85 c9                	test   %ecx,%ecx
  800dc3:	74 13                	je     800dd8 <write+0x83>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  800dc5:	8b 45 10             	mov    0x10(%ebp),%eax
  800dc8:	89 44 24 08          	mov    %eax,0x8(%esp)
  800dcc:	8b 45 0c             	mov    0xc(%ebp),%eax
  800dcf:	89 44 24 04          	mov    %eax,0x4(%esp)
  800dd3:	89 14 24             	mov    %edx,(%esp)
  800dd6:	ff d1                	call   *%ecx
}
  800dd8:	83 c4 24             	add    $0x24,%esp
  800ddb:	5b                   	pop    %ebx
  800ddc:	5d                   	pop    %ebp
  800ddd:	c3                   	ret    

00800dde <read>:
	return r;
}

ssize_t
read(int fdnum, void *buf, size_t n)
{
  800dde:	55                   	push   %ebp
  800ddf:	89 e5                	mov    %esp,%ebp
  800de1:	53                   	push   %ebx
  800de2:	83 ec 24             	sub    $0x24,%esp
  800de5:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  800de8:	8d 45 f0             	lea    -0x10(%ebp),%eax
  800deb:	89 44 24 04          	mov    %eax,0x4(%esp)
  800def:	89 1c 24             	mov    %ebx,(%esp)
  800df2:	e8 86 fd ff ff       	call   800b7d <fd_lookup>
  800df7:	85 c0                	test   %eax,%eax
  800df9:	78 6b                	js     800e66 <read+0x88>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  800dfb:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800dfe:	89 44 24 04          	mov    %eax,0x4(%esp)
  800e02:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800e05:	8b 00                	mov    (%eax),%eax
  800e07:	89 04 24             	mov    %eax,(%esp)
  800e0a:	e8 e2 fd ff ff       	call   800bf1 <dev_lookup>
{
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  800e0f:	85 c0                	test   %eax,%eax
  800e11:	78 53                	js     800e66 <read+0x88>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  800e13:	8b 55 f0             	mov    -0x10(%ebp),%edx
  800e16:	8b 42 08             	mov    0x8(%edx),%eax
  800e19:	83 e0 03             	and    $0x3,%eax
  800e1c:	83 f8 01             	cmp    $0x1,%eax
  800e1f:	75 23                	jne    800e44 <read+0x66>
		cprintf("[%08x] read %d -- bad mode\n", env->env_id, fdnum); 
  800e21:	a1 74 60 80 00       	mov    0x806074,%eax
  800e26:	8b 40 4c             	mov    0x4c(%eax),%eax
  800e29:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  800e2d:	89 44 24 04          	mov    %eax,0x4(%esp)
  800e31:	c7 04 24 46 29 80 00 	movl   $0x802946,(%esp)
  800e38:	e8 64 10 00 00       	call   801ea1 <cprintf>
  800e3d:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
		return -E_INVAL;
  800e42:	eb 22                	jmp    800e66 <read+0x88>
	}
	if (!dev->dev_read)
  800e44:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800e47:	8b 48 08             	mov    0x8(%eax),%ecx
  800e4a:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  800e4f:	85 c9                	test   %ecx,%ecx
  800e51:	74 13                	je     800e66 <read+0x88>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  800e53:	8b 45 10             	mov    0x10(%ebp),%eax
  800e56:	89 44 24 08          	mov    %eax,0x8(%esp)
  800e5a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e5d:	89 44 24 04          	mov    %eax,0x4(%esp)
  800e61:	89 14 24             	mov    %edx,(%esp)
  800e64:	ff d1                	call   *%ecx
}
  800e66:	83 c4 24             	add    $0x24,%esp
  800e69:	5b                   	pop    %ebx
  800e6a:	5d                   	pop    %ebp
  800e6b:	c3                   	ret    

00800e6c <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  800e6c:	55                   	push   %ebp
  800e6d:	89 e5                	mov    %esp,%ebp
  800e6f:	57                   	push   %edi
  800e70:	56                   	push   %esi
  800e71:	53                   	push   %ebx
  800e72:	83 ec 1c             	sub    $0x1c,%esp
  800e75:	8b 7d 08             	mov    0x8(%ebp),%edi
  800e78:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  800e7b:	ba 00 00 00 00       	mov    $0x0,%edx
  800e80:	bb 00 00 00 00       	mov    $0x0,%ebx
  800e85:	b8 00 00 00 00       	mov    $0x0,%eax
  800e8a:	85 f6                	test   %esi,%esi
  800e8c:	74 29                	je     800eb7 <readn+0x4b>
		m = read(fdnum, (char*)buf + tot, n - tot);
  800e8e:	89 f0                	mov    %esi,%eax
  800e90:	29 d0                	sub    %edx,%eax
  800e92:	89 44 24 08          	mov    %eax,0x8(%esp)
  800e96:	03 55 0c             	add    0xc(%ebp),%edx
  800e99:	89 54 24 04          	mov    %edx,0x4(%esp)
  800e9d:	89 3c 24             	mov    %edi,(%esp)
  800ea0:	e8 39 ff ff ff       	call   800dde <read>
		if (m < 0)
  800ea5:	85 c0                	test   %eax,%eax
  800ea7:	78 0e                	js     800eb7 <readn+0x4b>
			return m;
		if (m == 0)
  800ea9:	85 c0                	test   %eax,%eax
  800eab:	74 08                	je     800eb5 <readn+0x49>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  800ead:	01 c3                	add    %eax,%ebx
  800eaf:	89 da                	mov    %ebx,%edx
  800eb1:	39 f3                	cmp    %esi,%ebx
  800eb3:	72 d9                	jb     800e8e <readn+0x22>
  800eb5:	89 d8                	mov    %ebx,%eax
			return m;
		if (m == 0)
			break;
	}
	return tot;
}
  800eb7:	83 c4 1c             	add    $0x1c,%esp
  800eba:	5b                   	pop    %ebx
  800ebb:	5e                   	pop    %esi
  800ebc:	5f                   	pop    %edi
  800ebd:	5d                   	pop    %ebp
  800ebe:	c3                   	ret    

00800ebf <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  800ebf:	55                   	push   %ebp
  800ec0:	89 e5                	mov    %esp,%ebp
  800ec2:	56                   	push   %esi
  800ec3:	53                   	push   %ebx
  800ec4:	83 ec 20             	sub    $0x20,%esp
  800ec7:	8b 75 08             	mov    0x8(%ebp),%esi
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  800eca:	89 34 24             	mov    %esi,(%esp)
  800ecd:	e8 0e fc ff ff       	call   800ae0 <fd2num>
  800ed2:	8d 55 f4             	lea    -0xc(%ebp),%edx
  800ed5:	89 54 24 04          	mov    %edx,0x4(%esp)
  800ed9:	89 04 24             	mov    %eax,(%esp)
  800edc:	e8 9c fc ff ff       	call   800b7d <fd_lookup>
  800ee1:	89 c3                	mov    %eax,%ebx
  800ee3:	85 c0                	test   %eax,%eax
  800ee5:	78 05                	js     800eec <fd_close+0x2d>
  800ee7:	3b 75 f4             	cmp    -0xc(%ebp),%esi
  800eea:	74 0c                	je     800ef8 <fd_close+0x39>
	    || fd != fd2)
		return (must_exist ? r : 0);
  800eec:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800ef0:	19 c0                	sbb    %eax,%eax
  800ef2:	f7 d0                	not    %eax
  800ef4:	21 c3                	and    %eax,%ebx
  800ef6:	eb 3d                	jmp    800f35 <fd_close+0x76>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  800ef8:	8d 45 f0             	lea    -0x10(%ebp),%eax
  800efb:	89 44 24 04          	mov    %eax,0x4(%esp)
  800eff:	8b 06                	mov    (%esi),%eax
  800f01:	89 04 24             	mov    %eax,(%esp)
  800f04:	e8 e8 fc ff ff       	call   800bf1 <dev_lookup>
  800f09:	89 c3                	mov    %eax,%ebx
  800f0b:	85 c0                	test   %eax,%eax
  800f0d:	78 16                	js     800f25 <fd_close+0x66>
		if (dev->dev_close)
  800f0f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800f12:	8b 40 10             	mov    0x10(%eax),%eax
  800f15:	bb 00 00 00 00       	mov    $0x0,%ebx
  800f1a:	85 c0                	test   %eax,%eax
  800f1c:	74 07                	je     800f25 <fd_close+0x66>
			r = (*dev->dev_close)(fd);
  800f1e:	89 34 24             	mov    %esi,(%esp)
  800f21:	ff d0                	call   *%eax
  800f23:	89 c3                	mov    %eax,%ebx
		else
			r = 0;
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  800f25:	89 74 24 04          	mov    %esi,0x4(%esp)
  800f29:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  800f30:	e8 ca f9 ff ff       	call   8008ff <sys_page_unmap>
	return r;
}
  800f35:	89 d8                	mov    %ebx,%eax
  800f37:	83 c4 20             	add    $0x20,%esp
  800f3a:	5b                   	pop    %ebx
  800f3b:	5e                   	pop    %esi
  800f3c:	5d                   	pop    %ebp
  800f3d:	c3                   	ret    

00800f3e <close>:
	return -E_INVAL;
}

int
close(int fdnum)
{
  800f3e:	55                   	push   %ebp
  800f3f:	89 e5                	mov    %esp,%ebp
  800f41:	83 ec 28             	sub    $0x28,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  800f44:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800f47:	89 44 24 04          	mov    %eax,0x4(%esp)
  800f4b:	8b 45 08             	mov    0x8(%ebp),%eax
  800f4e:	89 04 24             	mov    %eax,(%esp)
  800f51:	e8 27 fc ff ff       	call   800b7d <fd_lookup>
  800f56:	85 c0                	test   %eax,%eax
  800f58:	78 13                	js     800f6d <close+0x2f>
		return r;
	else
		return fd_close(fd, 1);
  800f5a:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  800f61:	00 
  800f62:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800f65:	89 04 24             	mov    %eax,(%esp)
  800f68:	e8 52 ff ff ff       	call   800ebf <fd_close>
}
  800f6d:	c9                   	leave  
  800f6e:	c3                   	ret    

00800f6f <stat>:
	return (*dev->dev_stat)(fd, stat);
}

int
stat(const char *path, struct Stat *stat)
{
  800f6f:	55                   	push   %ebp
  800f70:	89 e5                	mov    %esp,%ebp
  800f72:	83 ec 18             	sub    $0x18,%esp
  800f75:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  800f78:	89 75 fc             	mov    %esi,-0x4(%ebp)
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  800f7b:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  800f82:	00 
  800f83:	8b 45 08             	mov    0x8(%ebp),%eax
  800f86:	89 04 24             	mov    %eax,(%esp)
  800f89:	e8 55 03 00 00       	call   8012e3 <open>
  800f8e:	89 c3                	mov    %eax,%ebx
  800f90:	85 c0                	test   %eax,%eax
  800f92:	78 1b                	js     800faf <stat+0x40>
		return fd;
	r = fstat(fd, stat);
  800f94:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f97:	89 44 24 04          	mov    %eax,0x4(%esp)
  800f9b:	89 1c 24             	mov    %ebx,(%esp)
  800f9e:	e8 b7 fc ff ff       	call   800c5a <fstat>
  800fa3:	89 c6                	mov    %eax,%esi
	close(fd);
  800fa5:	89 1c 24             	mov    %ebx,(%esp)
  800fa8:	e8 91 ff ff ff       	call   800f3e <close>
  800fad:	89 f3                	mov    %esi,%ebx
	return r;
}
  800faf:	89 d8                	mov    %ebx,%eax
  800fb1:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  800fb4:	8b 75 fc             	mov    -0x4(%ebp),%esi
  800fb7:	89 ec                	mov    %ebp,%esp
  800fb9:	5d                   	pop    %ebp
  800fba:	c3                   	ret    

00800fbb <close_all>:
		return fd_close(fd, 1);
}

void
close_all(void)
{
  800fbb:	55                   	push   %ebp
  800fbc:	89 e5                	mov    %esp,%ebp
  800fbe:	53                   	push   %ebx
  800fbf:	83 ec 14             	sub    $0x14,%esp
  800fc2:	bb 00 00 00 00       	mov    $0x0,%ebx
	int i;
	for (i = 0; i < MAXFD; i++)
		close(i);
  800fc7:	89 1c 24             	mov    %ebx,(%esp)
  800fca:	e8 6f ff ff ff       	call   800f3e <close>

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  800fcf:	83 c3 01             	add    $0x1,%ebx
  800fd2:	83 fb 20             	cmp    $0x20,%ebx
  800fd5:	75 f0                	jne    800fc7 <close_all+0xc>
		close(i);
}
  800fd7:	83 c4 14             	add    $0x14,%esp
  800fda:	5b                   	pop    %ebx
  800fdb:	5d                   	pop    %ebp
  800fdc:	c3                   	ret    

00800fdd <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  800fdd:	55                   	push   %ebp
  800fde:	89 e5                	mov    %esp,%ebp
  800fe0:	83 ec 58             	sub    $0x58,%esp
  800fe3:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800fe6:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800fe9:	89 7d fc             	mov    %edi,-0x4(%ebp)
  800fec:	8b 7d 0c             	mov    0xc(%ebp),%edi
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  800fef:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  800ff2:	89 44 24 04          	mov    %eax,0x4(%esp)
  800ff6:	8b 45 08             	mov    0x8(%ebp),%eax
  800ff9:	89 04 24             	mov    %eax,(%esp)
  800ffc:	e8 7c fb ff ff       	call   800b7d <fd_lookup>
  801001:	89 c3                	mov    %eax,%ebx
  801003:	85 c0                	test   %eax,%eax
  801005:	0f 88 e0 00 00 00    	js     8010eb <dup+0x10e>
		return r;
	close(newfdnum);
  80100b:	89 3c 24             	mov    %edi,(%esp)
  80100e:	e8 2b ff ff ff       	call   800f3e <close>

	newfd = INDEX2FD(newfdnum);
  801013:	8d b7 00 00 0d 00    	lea    0xd0000(%edi),%esi
  801019:	c1 e6 0c             	shl    $0xc,%esi
	ova = fd2data(oldfd);
  80101c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80101f:	89 04 24             	mov    %eax,(%esp)
  801022:	e8 c9 fa ff ff       	call   800af0 <fd2data>
  801027:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  801029:	89 34 24             	mov    %esi,(%esp)
  80102c:	e8 bf fa ff ff       	call   800af0 <fd2data>
  801031:	89 45 d4             	mov    %eax,-0x2c(%ebp)

	if ((vpd[PDX(ova)] & PTE_P) && (vpt[VPN(ova)] & PTE_P))
  801034:	89 da                	mov    %ebx,%edx
  801036:	89 d8                	mov    %ebx,%eax
  801038:	c1 e8 16             	shr    $0x16,%eax
  80103b:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801042:	a8 01                	test   $0x1,%al
  801044:	74 43                	je     801089 <dup+0xac>
  801046:	c1 ea 0c             	shr    $0xc,%edx
  801049:	8b 04 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%eax
  801050:	a8 01                	test   $0x1,%al
  801052:	74 35                	je     801089 <dup+0xac>
		if ((r = sys_page_map(0, ova, 0, nva, vpt[VPN(ova)] & PTE_USER)) < 0)
  801054:	8b 04 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%eax
  80105b:	25 07 0e 00 00       	and    $0xe07,%eax
  801060:	89 44 24 10          	mov    %eax,0x10(%esp)
  801064:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801067:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80106b:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801072:	00 
  801073:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801077:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80107e:	e8 da f8 ff ff       	call   80095d <sys_page_map>
  801083:	89 c3                	mov    %eax,%ebx
  801085:	85 c0                	test   %eax,%eax
  801087:	78 3f                	js     8010c8 <dup+0xeb>
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, vpt[VPN(oldfd)] & PTE_USER)) < 0)
  801089:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80108c:	89 c2                	mov    %eax,%edx
  80108e:	c1 ea 0c             	shr    $0xc,%edx
  801091:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801098:	81 e2 07 0e 00 00    	and    $0xe07,%edx
  80109e:	89 54 24 10          	mov    %edx,0x10(%esp)
  8010a2:	89 74 24 0c          	mov    %esi,0xc(%esp)
  8010a6:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  8010ad:	00 
  8010ae:	89 44 24 04          	mov    %eax,0x4(%esp)
  8010b2:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8010b9:	e8 9f f8 ff ff       	call   80095d <sys_page_map>
  8010be:	89 c3                	mov    %eax,%ebx
  8010c0:	85 c0                	test   %eax,%eax
  8010c2:	78 04                	js     8010c8 <dup+0xeb>
  8010c4:	89 fb                	mov    %edi,%ebx
  8010c6:	eb 23                	jmp    8010eb <dup+0x10e>
		goto err;

	return newfdnum;

err:
	sys_page_unmap(0, newfd);
  8010c8:	89 74 24 04          	mov    %esi,0x4(%esp)
  8010cc:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8010d3:	e8 27 f8 ff ff       	call   8008ff <sys_page_unmap>
	sys_page_unmap(0, nva);
  8010d8:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8010db:	89 44 24 04          	mov    %eax,0x4(%esp)
  8010df:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8010e6:	e8 14 f8 ff ff       	call   8008ff <sys_page_unmap>
	return r;
}
  8010eb:	89 d8                	mov    %ebx,%eax
  8010ed:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  8010f0:	8b 75 f8             	mov    -0x8(%ebp),%esi
  8010f3:	8b 7d fc             	mov    -0x4(%ebp),%edi
  8010f6:	89 ec                	mov    %ebp,%esp
  8010f8:	5d                   	pop    %ebp
  8010f9:	c3                   	ret    
	...

008010fc <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  8010fc:	55                   	push   %ebp
  8010fd:	89 e5                	mov    %esp,%ebp
  8010ff:	53                   	push   %ebx
  801100:	83 ec 14             	sub    $0x14,%esp
  801103:	89 d3                	mov    %edx,%ebx
	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", env->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(envs[1].env_id, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  801105:	8b 15 c8 00 c0 ee    	mov    0xeec000c8,%edx
  80110b:	c7 44 24 0c 07 00 00 	movl   $0x7,0xc(%esp)
  801112:	00 
  801113:	c7 44 24 08 00 30 80 	movl   $0x803000,0x8(%esp)
  80111a:	00 
  80111b:	89 44 24 04          	mov    %eax,0x4(%esp)
  80111f:	89 14 24             	mov    %edx,(%esp)
  801122:	e8 e9 13 00 00       	call   802510 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  801127:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  80112e:	00 
  80112f:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801133:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80113a:	e8 37 14 00 00       	call   802576 <ipc_recv>
}
  80113f:	83 c4 14             	add    $0x14,%esp
  801142:	5b                   	pop    %ebx
  801143:	5d                   	pop    %ebp
  801144:	c3                   	ret    

00801145 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  801145:	55                   	push   %ebp
  801146:	89 e5                	mov    %esp,%ebp
  801148:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  80114b:	8b 45 08             	mov    0x8(%ebp),%eax
  80114e:	8b 40 0c             	mov    0xc(%eax),%eax
  801151:	a3 00 30 80 00       	mov    %eax,0x803000
	fsipcbuf.set_size.req_size = newsize;
  801156:	8b 45 0c             	mov    0xc(%ebp),%eax
  801159:	a3 04 30 80 00       	mov    %eax,0x803004
	return fsipc(FSREQ_SET_SIZE, NULL);
  80115e:	ba 00 00 00 00       	mov    $0x0,%edx
  801163:	b8 02 00 00 00       	mov    $0x2,%eax
  801168:	e8 8f ff ff ff       	call   8010fc <fsipc>
}
  80116d:	c9                   	leave  
  80116e:	c3                   	ret    

0080116f <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  80116f:	55                   	push   %ebp
  801170:	89 e5                	mov    %esp,%ebp
  801172:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  801175:	8b 45 08             	mov    0x8(%ebp),%eax
  801178:	8b 40 0c             	mov    0xc(%eax),%eax
  80117b:	a3 00 30 80 00       	mov    %eax,0x803000
	return fsipc(FSREQ_FLUSH, NULL);
  801180:	ba 00 00 00 00       	mov    $0x0,%edx
  801185:	b8 06 00 00 00       	mov    $0x6,%eax
  80118a:	e8 6d ff ff ff       	call   8010fc <fsipc>
}
  80118f:	c9                   	leave  
  801190:	c3                   	ret    

00801191 <sync>:
}

// Synchronize disk with buffer cache
int
sync(void)
{
  801191:	55                   	push   %ebp
  801192:	89 e5                	mov    %esp,%ebp
  801194:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  801197:	ba 00 00 00 00       	mov    $0x0,%edx
  80119c:	b8 08 00 00 00       	mov    $0x8,%eax
  8011a1:	e8 56 ff ff ff       	call   8010fc <fsipc>
}
  8011a6:	c9                   	leave  
  8011a7:	c3                   	ret    

008011a8 <devfile_stat>:
	return fsipc(FSREQ_WRITE, NULL);	
}

static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  8011a8:	55                   	push   %ebp
  8011a9:	89 e5                	mov    %esp,%ebp
  8011ab:	53                   	push   %ebx
  8011ac:	83 ec 14             	sub    $0x14,%esp
  8011af:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  8011b2:	8b 45 08             	mov    0x8(%ebp),%eax
  8011b5:	8b 40 0c             	mov    0xc(%eax),%eax
  8011b8:	a3 00 30 80 00       	mov    %eax,0x803000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  8011bd:	ba 00 00 00 00       	mov    $0x0,%edx
  8011c2:	b8 05 00 00 00       	mov    $0x5,%eax
  8011c7:	e8 30 ff ff ff       	call   8010fc <fsipc>
  8011cc:	85 c0                	test   %eax,%eax
  8011ce:	78 2b                	js     8011fb <devfile_stat+0x53>
		return r;
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  8011d0:	c7 44 24 04 00 30 80 	movl   $0x803000,0x4(%esp)
  8011d7:	00 
  8011d8:	89 1c 24             	mov    %ebx,(%esp)
  8011db:	e8 ea ef ff ff       	call   8001ca <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  8011e0:	a1 80 30 80 00       	mov    0x803080,%eax
  8011e5:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  8011eb:	a1 84 30 80 00       	mov    0x803084,%eax
  8011f0:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
  8011f6:	b8 00 00 00 00       	mov    $0x0,%eax
	return 0;
}
  8011fb:	83 c4 14             	add    $0x14,%esp
  8011fe:	5b                   	pop    %ebx
  8011ff:	5d                   	pop    %ebp
  801200:	c3                   	ret    

00801201 <devfile_write>:
// Returns:
//	 The number of bytes successfully written.
//	 < 0 on error.
static ssize_t
devfile_write(struct Fd *fd, const void *buf, size_t n)
{
  801201:	55                   	push   %ebp
  801202:	89 e5                	mov    %esp,%ebp
  801204:	83 ec 18             	sub    $0x18,%esp
  801207:	8b 45 10             	mov    0x10(%ebp),%eax
  80120a:	3d f8 0f 00 00       	cmp    $0xff8,%eax
  80120f:	76 05                	jbe    801216 <devfile_write+0x15>
  801211:	b8 f8 0f 00 00       	mov    $0xff8,%eax
	// LAB 5: Your code here
	//panic("devfile_write not implemented");
	
	if (n > (PGSIZE - (sizeof(int) + sizeof(size_t))))
		n = PGSIZE - (sizeof(int) + sizeof(size_t));
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  801216:	8b 55 08             	mov    0x8(%ebp),%edx
  801219:	8b 52 0c             	mov    0xc(%edx),%edx
  80121c:	89 15 00 30 80 00    	mov    %edx,0x803000
	fsipcbuf.write.req_n = n;
  801222:	a3 04 30 80 00       	mov    %eax,0x803004
	memmove (fsipcbuf.write.req_buf, (char*)buf, n);	
  801227:	89 44 24 08          	mov    %eax,0x8(%esp)
  80122b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80122e:	89 44 24 04          	mov    %eax,0x4(%esp)
  801232:	c7 04 24 08 30 80 00 	movl   $0x803008,(%esp)
  801239:	e8 47 f1 ff ff       	call   800385 <memmove>
	return fsipc(FSREQ_WRITE, NULL);	
  80123e:	ba 00 00 00 00       	mov    $0x0,%edx
  801243:	b8 04 00 00 00       	mov    $0x4,%eax
  801248:	e8 af fe ff ff       	call   8010fc <fsipc>
}
  80124d:	c9                   	leave  
  80124e:	c3                   	ret    

0080124f <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  80124f:	55                   	push   %ebp
  801250:	89 e5                	mov    %esp,%ebp
  801252:	53                   	push   %ebx
  801253:	83 ec 14             	sub    $0x14,%esp
	// system server.
	// LAB 5: Your code here
	
	//panic("devfile_read not implemented");
	int r;
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  801256:	8b 45 08             	mov    0x8(%ebp),%eax
  801259:	8b 40 0c             	mov    0xc(%eax),%eax
  80125c:	a3 00 30 80 00       	mov    %eax,0x803000
	fsipcbuf.read.req_n = n;
  801261:	8b 45 10             	mov    0x10(%ebp),%eax
  801264:	a3 04 30 80 00       	mov    %eax,0x803004
	if ((r = fsipc(FSREQ_READ, (void*)&fsipcbuf)) < 0)
  801269:	ba 00 30 80 00       	mov    $0x803000,%edx
  80126e:	b8 03 00 00 00       	mov    $0x3,%eax
  801273:	e8 84 fe ff ff       	call   8010fc <fsipc>
  801278:	89 c3                	mov    %eax,%ebx
  80127a:	85 c0                	test   %eax,%eax
  80127c:	78 17                	js     801295 <devfile_read+0x46>
		return r;
	memmove((void*)buf, (void*)fsipcbuf.readRet.ret_buf, r);
  80127e:	89 44 24 08          	mov    %eax,0x8(%esp)
  801282:	c7 44 24 04 00 30 80 	movl   $0x803000,0x4(%esp)
  801289:	00 
  80128a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80128d:	89 04 24             	mov    %eax,(%esp)
  801290:	e8 f0 f0 ff ff       	call   800385 <memmove>
	return r;
}
  801295:	89 d8                	mov    %ebx,%eax
  801297:	83 c4 14             	add    $0x14,%esp
  80129a:	5b                   	pop    %ebx
  80129b:	5d                   	pop    %ebp
  80129c:	c3                   	ret    

0080129d <remove>:
}

// Delete a file
int
remove(const char *path)
{
  80129d:	55                   	push   %ebp
  80129e:	89 e5                	mov    %esp,%ebp
  8012a0:	53                   	push   %ebx
  8012a1:	83 ec 14             	sub    $0x14,%esp
  8012a4:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (strlen(path) >= MAXPATHLEN)
  8012a7:	89 1c 24             	mov    %ebx,(%esp)
  8012aa:	e8 d1 ee ff ff       	call   800180 <strlen>
  8012af:	89 c2                	mov    %eax,%edx
  8012b1:	b8 f4 ff ff ff       	mov    $0xfffffff4,%eax
  8012b6:	81 fa ff 03 00 00    	cmp    $0x3ff,%edx
  8012bc:	7f 1f                	jg     8012dd <remove+0x40>
		return -E_BAD_PATH;
	strcpy(fsipcbuf.remove.req_path, path);
  8012be:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8012c2:	c7 04 24 00 30 80 00 	movl   $0x803000,(%esp)
  8012c9:	e8 fc ee ff ff       	call   8001ca <strcpy>
	return fsipc(FSREQ_REMOVE, NULL);
  8012ce:	ba 00 00 00 00       	mov    $0x0,%edx
  8012d3:	b8 07 00 00 00       	mov    $0x7,%eax
  8012d8:	e8 1f fe ff ff       	call   8010fc <fsipc>
}
  8012dd:	83 c4 14             	add    $0x14,%esp
  8012e0:	5b                   	pop    %ebx
  8012e1:	5d                   	pop    %ebp
  8012e2:	c3                   	ret    

008012e3 <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  8012e3:	55                   	push   %ebp
  8012e4:	89 e5                	mov    %esp,%ebp
  8012e6:	83 ec 28             	sub    $0x28,%esp
  8012e9:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  8012ec:	89 75 fc             	mov    %esi,-0x4(%ebp)
  8012ef:	8b 75 08             	mov    0x8(%ebp),%esi
	// file descriptor.

	// LAB 5: Your code here.
	// Code added by Swastika / Sandeep
	
	if (strlen(path) >= MAXPATHLEN)
  8012f2:	89 34 24             	mov    %esi,(%esp)
  8012f5:	e8 86 ee ff ff       	call   800180 <strlen>
  8012fa:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  8012ff:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  801304:	7f 5e                	jg     801364 <open+0x81>
		return -E_BAD_PATH;
	struct Fd * fd;
	int  r;
	if ((r = fd_alloc(&fd)) < 0)
  801306:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801309:	89 04 24             	mov    %eax,(%esp)
  80130c:	e8 fa f7 ff ff       	call   800b0b <fd_alloc>
  801311:	89 c3                	mov    %eax,%ebx
  801313:	85 c0                	test   %eax,%eax
  801315:	78 4d                	js     801364 <open+0x81>
		return r;
	strcpy (fsipcbuf.open.req_path, path);
  801317:	89 74 24 04          	mov    %esi,0x4(%esp)
  80131b:	c7 04 24 00 30 80 00 	movl   $0x803000,(%esp)
  801322:	e8 a3 ee ff ff       	call   8001ca <strcpy>
	fsipcbuf.open.req_omode = mode;	
  801327:	8b 45 0c             	mov    0xc(%ebp),%eax
  80132a:	a3 00 34 80 00       	mov    %eax,0x803400
	if ((r = fsipc(FSREQ_OPEN,(void*)fd)) < 0)
  80132f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801332:	b8 01 00 00 00       	mov    $0x1,%eax
  801337:	e8 c0 fd ff ff       	call   8010fc <fsipc>
  80133c:	89 c3                	mov    %eax,%ebx
  80133e:	85 c0                	test   %eax,%eax
  801340:	79 15                	jns    801357 <open+0x74>
	{
		fd_close(fd,0);
  801342:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  801349:	00 
  80134a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80134d:	89 04 24             	mov    %eax,(%esp)
  801350:	e8 6a fb ff ff       	call   800ebf <fd_close>
		return r; 
  801355:	eb 0d                	jmp    801364 <open+0x81>
	}
	return fd2num(fd);
  801357:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80135a:	89 04 24             	mov    %eax,(%esp)
  80135d:	e8 7e f7 ff ff       	call   800ae0 <fd2num>
  801362:	89 c3                	mov    %eax,%ebx
	//panic("open not implemented");
}
  801364:	89 d8                	mov    %ebx,%eax
  801366:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  801369:	8b 75 fc             	mov    -0x4(%ebp),%esi
  80136c:	89 ec                	mov    %ebp,%esp
  80136e:	5d                   	pop    %ebp
  80136f:	c3                   	ret    

00801370 <devsock_stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  801370:	55                   	push   %ebp
  801371:	89 e5                	mov    %esp,%ebp
  801373:	83 ec 18             	sub    $0x18,%esp
	strcpy(stat->st_name, "<sock>");
  801376:	c7 44 24 04 78 29 80 	movl   $0x802978,0x4(%esp)
  80137d:	00 
  80137e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801381:	89 04 24             	mov    %eax,(%esp)
  801384:	e8 41 ee ff ff       	call   8001ca <strcpy>
	return 0;
}
  801389:	b8 00 00 00 00       	mov    $0x0,%eax
  80138e:	c9                   	leave  
  80138f:	c3                   	ret    

00801390 <devsock_close>:
	return nsipc_shutdown(r, how);
}

static int
devsock_close(struct Fd *fd)
{
  801390:	55                   	push   %ebp
  801391:	89 e5                	mov    %esp,%ebp
  801393:	83 ec 18             	sub    $0x18,%esp
	return nsipc_close(fd->fd_sock.sockid);
  801396:	8b 45 08             	mov    0x8(%ebp),%eax
  801399:	8b 40 0c             	mov    0xc(%eax),%eax
  80139c:	89 04 24             	mov    %eax,(%esp)
  80139f:	e8 9e 02 00 00       	call   801642 <nsipc_close>
}
  8013a4:	c9                   	leave  
  8013a5:	c3                   	ret    

008013a6 <devsock_write>:
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
}

static ssize_t
devsock_write(struct Fd *fd, const void *buf, size_t n)
{
  8013a6:	55                   	push   %ebp
  8013a7:	89 e5                	mov    %esp,%ebp
  8013a9:	83 ec 18             	sub    $0x18,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  8013ac:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  8013b3:	00 
  8013b4:	8b 45 10             	mov    0x10(%ebp),%eax
  8013b7:	89 44 24 08          	mov    %eax,0x8(%esp)
  8013bb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013be:	89 44 24 04          	mov    %eax,0x4(%esp)
  8013c2:	8b 45 08             	mov    0x8(%ebp),%eax
  8013c5:	8b 40 0c             	mov    0xc(%eax),%eax
  8013c8:	89 04 24             	mov    %eax,(%esp)
  8013cb:	e8 ae 02 00 00       	call   80167e <nsipc_send>
}
  8013d0:	c9                   	leave  
  8013d1:	c3                   	ret    

008013d2 <devsock_read>:
	return nsipc_listen(r, backlog);
}

static ssize_t
devsock_read(struct Fd *fd, void *buf, size_t n)
{
  8013d2:	55                   	push   %ebp
  8013d3:	89 e5                	mov    %esp,%ebp
  8013d5:	83 ec 18             	sub    $0x18,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  8013d8:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  8013df:	00 
  8013e0:	8b 45 10             	mov    0x10(%ebp),%eax
  8013e3:	89 44 24 08          	mov    %eax,0x8(%esp)
  8013e7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013ea:	89 44 24 04          	mov    %eax,0x4(%esp)
  8013ee:	8b 45 08             	mov    0x8(%ebp),%eax
  8013f1:	8b 40 0c             	mov    0xc(%eax),%eax
  8013f4:	89 04 24             	mov    %eax,(%esp)
  8013f7:	e8 f5 02 00 00       	call   8016f1 <nsipc_recv>
}
  8013fc:	c9                   	leave  
  8013fd:	c3                   	ret    

008013fe <alloc_sockfd>:
	return sfd->fd_sock.sockid;
}

static int
alloc_sockfd(int sockid)
{
  8013fe:	55                   	push   %ebp
  8013ff:	89 e5                	mov    %esp,%ebp
  801401:	56                   	push   %esi
  801402:	53                   	push   %ebx
  801403:	83 ec 20             	sub    $0x20,%esp
  801406:	89 c6                	mov    %eax,%esi
	struct Fd *sfd;
	int r;

	if ((r = fd_alloc(&sfd)) < 0
  801408:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80140b:	89 04 24             	mov    %eax,(%esp)
  80140e:	e8 f8 f6 ff ff       	call   800b0b <fd_alloc>
  801413:	89 c3                	mov    %eax,%ebx
  801415:	85 c0                	test   %eax,%eax
  801417:	78 21                	js     80143a <alloc_sockfd+0x3c>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U)) < 0) {
  801419:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  801420:	00 
  801421:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801424:	89 44 24 04          	mov    %eax,0x4(%esp)
  801428:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80142f:	e8 87 f5 ff ff       	call   8009bb <sys_page_alloc>
  801434:	89 c3                	mov    %eax,%ebx
alloc_sockfd(int sockid)
{
	struct Fd *sfd;
	int r;

	if ((r = fd_alloc(&sfd)) < 0
  801436:	85 c0                	test   %eax,%eax
  801438:	79 0a                	jns    801444 <alloc_sockfd+0x46>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U)) < 0) {
		nsipc_close(sockid);
  80143a:	89 34 24             	mov    %esi,(%esp)
  80143d:	e8 00 02 00 00       	call   801642 <nsipc_close>
		return r;
  801442:	eb 28                	jmp    80146c <alloc_sockfd+0x6e>
	}

	sfd->fd_dev_id = devsock.dev_id;
  801444:	8b 15 20 60 80 00    	mov    0x806020,%edx
  80144a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80144d:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  80144f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801452:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	sfd->fd_sock.sockid = sockid;
  801459:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80145c:	89 70 0c             	mov    %esi,0xc(%eax)
	return fd2num(sfd);
  80145f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801462:	89 04 24             	mov    %eax,(%esp)
  801465:	e8 76 f6 ff ff       	call   800ae0 <fd2num>
  80146a:	89 c3                	mov    %eax,%ebx
}
  80146c:	89 d8                	mov    %ebx,%eax
  80146e:	83 c4 20             	add    $0x20,%esp
  801471:	5b                   	pop    %ebx
  801472:	5e                   	pop    %esi
  801473:	5d                   	pop    %ebp
  801474:	c3                   	ret    

00801475 <socket>:
	return 0;
}

int
socket(int domain, int type, int protocol)
{
  801475:	55                   	push   %ebp
  801476:	89 e5                	mov    %esp,%ebp
  801478:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  80147b:	8b 45 10             	mov    0x10(%ebp),%eax
  80147e:	89 44 24 08          	mov    %eax,0x8(%esp)
  801482:	8b 45 0c             	mov    0xc(%ebp),%eax
  801485:	89 44 24 04          	mov    %eax,0x4(%esp)
  801489:	8b 45 08             	mov    0x8(%ebp),%eax
  80148c:	89 04 24             	mov    %eax,(%esp)
  80148f:	e8 62 01 00 00       	call   8015f6 <nsipc_socket>
  801494:	85 c0                	test   %eax,%eax
  801496:	78 05                	js     80149d <socket+0x28>
		return r;
	return alloc_sockfd(r);
  801498:	e8 61 ff ff ff       	call   8013fe <alloc_sockfd>
}
  80149d:	c9                   	leave  
  80149e:	66 90                	xchg   %ax,%ax
  8014a0:	c3                   	ret    

008014a1 <fd2sockid>:
	.dev_stat =	devsock_stat,
};

static int
fd2sockid(int fd)
{
  8014a1:	55                   	push   %ebp
  8014a2:	89 e5                	mov    %esp,%ebp
  8014a4:	83 ec 28             	sub    $0x28,%esp
	struct Fd *sfd;
	int r;

	if ((r = fd_lookup(fd, &sfd)) < 0)
  8014a7:	8d 55 f4             	lea    -0xc(%ebp),%edx
  8014aa:	89 54 24 04          	mov    %edx,0x4(%esp)
  8014ae:	89 04 24             	mov    %eax,(%esp)
  8014b1:	e8 c7 f6 ff ff       	call   800b7d <fd_lookup>
  8014b6:	85 c0                	test   %eax,%eax
  8014b8:	78 15                	js     8014cf <fd2sockid+0x2e>
		return r;
	if (sfd->fd_dev_id != devsock.dev_id)
  8014ba:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8014bd:	8b 0a                	mov    (%edx),%ecx
  8014bf:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8014c4:	3b 0d 20 60 80 00    	cmp    0x806020,%ecx
  8014ca:	75 03                	jne    8014cf <fd2sockid+0x2e>
		return -E_NOT_SUPP;
	return sfd->fd_sock.sockid;
  8014cc:	8b 42 0c             	mov    0xc(%edx),%eax
}
  8014cf:	c9                   	leave  
  8014d0:	c3                   	ret    

008014d1 <listen>:
	return nsipc_connect(r, name, namelen);
}

int
listen(int s, int backlog)
{
  8014d1:	55                   	push   %ebp
  8014d2:	89 e5                	mov    %esp,%ebp
  8014d4:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  8014d7:	8b 45 08             	mov    0x8(%ebp),%eax
  8014da:	e8 c2 ff ff ff       	call   8014a1 <fd2sockid>
  8014df:	85 c0                	test   %eax,%eax
  8014e1:	78 0f                	js     8014f2 <listen+0x21>
		return r;
	return nsipc_listen(r, backlog);
  8014e3:	8b 55 0c             	mov    0xc(%ebp),%edx
  8014e6:	89 54 24 04          	mov    %edx,0x4(%esp)
  8014ea:	89 04 24             	mov    %eax,(%esp)
  8014ed:	e8 2e 01 00 00       	call   801620 <nsipc_listen>
}
  8014f2:	c9                   	leave  
  8014f3:	c3                   	ret    

008014f4 <connect>:
	return nsipc_close(fd->fd_sock.sockid);
}

int
connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  8014f4:	55                   	push   %ebp
  8014f5:	89 e5                	mov    %esp,%ebp
  8014f7:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  8014fa:	8b 45 08             	mov    0x8(%ebp),%eax
  8014fd:	e8 9f ff ff ff       	call   8014a1 <fd2sockid>
  801502:	85 c0                	test   %eax,%eax
  801504:	78 16                	js     80151c <connect+0x28>
		return r;
	return nsipc_connect(r, name, namelen);
  801506:	8b 55 10             	mov    0x10(%ebp),%edx
  801509:	89 54 24 08          	mov    %edx,0x8(%esp)
  80150d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801510:	89 54 24 04          	mov    %edx,0x4(%esp)
  801514:	89 04 24             	mov    %eax,(%esp)
  801517:	e8 55 02 00 00       	call   801771 <nsipc_connect>
}
  80151c:	c9                   	leave  
  80151d:	c3                   	ret    

0080151e <shutdown>:
	return nsipc_bind(r, name, namelen);
}

int
shutdown(int s, int how)
{
  80151e:	55                   	push   %ebp
  80151f:	89 e5                	mov    %esp,%ebp
  801521:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  801524:	8b 45 08             	mov    0x8(%ebp),%eax
  801527:	e8 75 ff ff ff       	call   8014a1 <fd2sockid>
  80152c:	85 c0                	test   %eax,%eax
  80152e:	78 0f                	js     80153f <shutdown+0x21>
		return r;
	return nsipc_shutdown(r, how);
  801530:	8b 55 0c             	mov    0xc(%ebp),%edx
  801533:	89 54 24 04          	mov    %edx,0x4(%esp)
  801537:	89 04 24             	mov    %eax,(%esp)
  80153a:	e8 1d 01 00 00       	call   80165c <nsipc_shutdown>
}
  80153f:	c9                   	leave  
  801540:	c3                   	ret    

00801541 <bind>:
	return alloc_sockfd(r);
}

int
bind(int s, struct sockaddr *name, socklen_t namelen)
{
  801541:	55                   	push   %ebp
  801542:	89 e5                	mov    %esp,%ebp
  801544:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  801547:	8b 45 08             	mov    0x8(%ebp),%eax
  80154a:	e8 52 ff ff ff       	call   8014a1 <fd2sockid>
  80154f:	85 c0                	test   %eax,%eax
  801551:	78 16                	js     801569 <bind+0x28>
		return r;
	return nsipc_bind(r, name, namelen);
  801553:	8b 55 10             	mov    0x10(%ebp),%edx
  801556:	89 54 24 08          	mov    %edx,0x8(%esp)
  80155a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80155d:	89 54 24 04          	mov    %edx,0x4(%esp)
  801561:	89 04 24             	mov    %eax,(%esp)
  801564:	e8 47 02 00 00       	call   8017b0 <nsipc_bind>
}
  801569:	c9                   	leave  
  80156a:	c3                   	ret    

0080156b <accept>:
	return fd2num(sfd);
}

int
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  80156b:	55                   	push   %ebp
  80156c:	89 e5                	mov    %esp,%ebp
  80156e:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  801571:	8b 45 08             	mov    0x8(%ebp),%eax
  801574:	e8 28 ff ff ff       	call   8014a1 <fd2sockid>
  801579:	85 c0                	test   %eax,%eax
  80157b:	78 1f                	js     80159c <accept+0x31>
		return r;
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  80157d:	8b 55 10             	mov    0x10(%ebp),%edx
  801580:	89 54 24 08          	mov    %edx,0x8(%esp)
  801584:	8b 55 0c             	mov    0xc(%ebp),%edx
  801587:	89 54 24 04          	mov    %edx,0x4(%esp)
  80158b:	89 04 24             	mov    %eax,(%esp)
  80158e:	e8 5c 02 00 00       	call   8017ef <nsipc_accept>
  801593:	85 c0                	test   %eax,%eax
  801595:	78 05                	js     80159c <accept+0x31>
		return r;
	return alloc_sockfd(r);
  801597:	e8 62 fe ff ff       	call   8013fe <alloc_sockfd>
}
  80159c:	c9                   	leave  
  80159d:	8d 76 00             	lea    0x0(%esi),%esi
  8015a0:	c3                   	ret    
	...

008015b0 <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  8015b0:	55                   	push   %ebp
  8015b1:	89 e5                	mov    %esp,%ebp
  8015b3:	83 ec 18             	sub    $0x18,%esp
	if (debug)
		cprintf("[%08x] nsipc %d\n", env->env_id, type);

	ipc_send(envs[2].env_id, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  8015b6:	8b 15 44 01 c0 ee    	mov    0xeec00144,%edx
  8015bc:	c7 44 24 0c 07 00 00 	movl   $0x7,0xc(%esp)
  8015c3:	00 
  8015c4:	c7 44 24 08 00 50 80 	movl   $0x805000,0x8(%esp)
  8015cb:	00 
  8015cc:	89 44 24 04          	mov    %eax,0x4(%esp)
  8015d0:	89 14 24             	mov    %edx,(%esp)
  8015d3:	e8 38 0f 00 00       	call   802510 <ipc_send>
	return ipc_recv(NULL, NULL, NULL);
  8015d8:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  8015df:	00 
  8015e0:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  8015e7:	00 
  8015e8:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8015ef:	e8 82 0f 00 00       	call   802576 <ipc_recv>
}
  8015f4:	c9                   	leave  
  8015f5:	c3                   	ret    

008015f6 <nsipc_socket>:
	return nsipc(NSREQ_SEND);
}

int
nsipc_socket(int domain, int type, int protocol)
{
  8015f6:	55                   	push   %ebp
  8015f7:	89 e5                	mov    %esp,%ebp
  8015f9:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  8015fc:	8b 45 08             	mov    0x8(%ebp),%eax
  8015ff:	a3 00 50 80 00       	mov    %eax,0x805000
	nsipcbuf.socket.req_type = type;
  801604:	8b 45 0c             	mov    0xc(%ebp),%eax
  801607:	a3 04 50 80 00       	mov    %eax,0x805004
	nsipcbuf.socket.req_protocol = protocol;
  80160c:	8b 45 10             	mov    0x10(%ebp),%eax
  80160f:	a3 08 50 80 00       	mov    %eax,0x805008
	return nsipc(NSREQ_SOCKET);
  801614:	b8 09 00 00 00       	mov    $0x9,%eax
  801619:	e8 92 ff ff ff       	call   8015b0 <nsipc>
}
  80161e:	c9                   	leave  
  80161f:	c3                   	ret    

00801620 <nsipc_listen>:
	return nsipc(NSREQ_CONNECT);
}

int
nsipc_listen(int s, int backlog)
{
  801620:	55                   	push   %ebp
  801621:	89 e5                	mov    %esp,%ebp
  801623:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  801626:	8b 45 08             	mov    0x8(%ebp),%eax
  801629:	a3 00 50 80 00       	mov    %eax,0x805000
	nsipcbuf.listen.req_backlog = backlog;
  80162e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801631:	a3 04 50 80 00       	mov    %eax,0x805004
	return nsipc(NSREQ_LISTEN);
  801636:	b8 06 00 00 00       	mov    $0x6,%eax
  80163b:	e8 70 ff ff ff       	call   8015b0 <nsipc>
}
  801640:	c9                   	leave  
  801641:	c3                   	ret    

00801642 <nsipc_close>:
	return nsipc(NSREQ_SHUTDOWN);
}

int
nsipc_close(int s)
{
  801642:	55                   	push   %ebp
  801643:	89 e5                	mov    %esp,%ebp
  801645:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  801648:	8b 45 08             	mov    0x8(%ebp),%eax
  80164b:	a3 00 50 80 00       	mov    %eax,0x805000
	return nsipc(NSREQ_CLOSE);
  801650:	b8 04 00 00 00       	mov    $0x4,%eax
  801655:	e8 56 ff ff ff       	call   8015b0 <nsipc>
}
  80165a:	c9                   	leave  
  80165b:	c3                   	ret    

0080165c <nsipc_shutdown>:
	return nsipc(NSREQ_BIND);
}

int
nsipc_shutdown(int s, int how)
{
  80165c:	55                   	push   %ebp
  80165d:	89 e5                	mov    %esp,%ebp
  80165f:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  801662:	8b 45 08             	mov    0x8(%ebp),%eax
  801665:	a3 00 50 80 00       	mov    %eax,0x805000
	nsipcbuf.shutdown.req_how = how;
  80166a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80166d:	a3 04 50 80 00       	mov    %eax,0x805004
	return nsipc(NSREQ_SHUTDOWN);
  801672:	b8 03 00 00 00       	mov    $0x3,%eax
  801677:	e8 34 ff ff ff       	call   8015b0 <nsipc>
}
  80167c:	c9                   	leave  
  80167d:	c3                   	ret    

0080167e <nsipc_send>:
	return r;
}

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  80167e:	55                   	push   %ebp
  80167f:	89 e5                	mov    %esp,%ebp
  801681:	53                   	push   %ebx
  801682:	83 ec 14             	sub    $0x14,%esp
  801685:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  801688:	8b 45 08             	mov    0x8(%ebp),%eax
  80168b:	a3 00 50 80 00       	mov    %eax,0x805000
	assert(size < 1600);
  801690:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  801696:	7e 24                	jle    8016bc <nsipc_send+0x3e>
  801698:	c7 44 24 0c 84 29 80 	movl   $0x802984,0xc(%esp)
  80169f:	00 
  8016a0:	c7 44 24 08 90 29 80 	movl   $0x802990,0x8(%esp)
  8016a7:	00 
  8016a8:	c7 44 24 04 66 00 00 	movl   $0x66,0x4(%esp)
  8016af:	00 
  8016b0:	c7 04 24 a5 29 80 00 	movl   $0x8029a5,(%esp)
  8016b7:	e8 20 07 00 00       	call   801ddc <_panic>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  8016bc:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8016c0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8016c3:	89 44 24 04          	mov    %eax,0x4(%esp)
  8016c7:	c7 04 24 0c 50 80 00 	movl   $0x80500c,(%esp)
  8016ce:	e8 b2 ec ff ff       	call   800385 <memmove>
	nsipcbuf.send.req_size = size;
  8016d3:	89 1d 04 50 80 00    	mov    %ebx,0x805004
	nsipcbuf.send.req_flags = flags;
  8016d9:	8b 45 14             	mov    0x14(%ebp),%eax
  8016dc:	a3 08 50 80 00       	mov    %eax,0x805008
	return nsipc(NSREQ_SEND);
  8016e1:	b8 08 00 00 00       	mov    $0x8,%eax
  8016e6:	e8 c5 fe ff ff       	call   8015b0 <nsipc>
}
  8016eb:	83 c4 14             	add    $0x14,%esp
  8016ee:	5b                   	pop    %ebx
  8016ef:	5d                   	pop    %ebp
  8016f0:	c3                   	ret    

008016f1 <nsipc_recv>:
	return nsipc(NSREQ_LISTEN);
}

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  8016f1:	55                   	push   %ebp
  8016f2:	89 e5                	mov    %esp,%ebp
  8016f4:	56                   	push   %esi
  8016f5:	53                   	push   %ebx
  8016f6:	83 ec 10             	sub    $0x10,%esp
  8016f9:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  8016fc:	8b 45 08             	mov    0x8(%ebp),%eax
  8016ff:	a3 00 50 80 00       	mov    %eax,0x805000
	nsipcbuf.recv.req_len = len;
  801704:	89 35 04 50 80 00    	mov    %esi,0x805004
	nsipcbuf.recv.req_flags = flags;
  80170a:	8b 45 14             	mov    0x14(%ebp),%eax
  80170d:	a3 08 50 80 00       	mov    %eax,0x805008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  801712:	b8 07 00 00 00       	mov    $0x7,%eax
  801717:	e8 94 fe ff ff       	call   8015b0 <nsipc>
  80171c:	89 c3                	mov    %eax,%ebx
  80171e:	85 c0                	test   %eax,%eax
  801720:	78 46                	js     801768 <nsipc_recv+0x77>
		assert(r < 1600 && r <= len);
  801722:	3d 3f 06 00 00       	cmp    $0x63f,%eax
  801727:	7f 04                	jg     80172d <nsipc_recv+0x3c>
  801729:	39 c6                	cmp    %eax,%esi
  80172b:	7d 24                	jge    801751 <nsipc_recv+0x60>
  80172d:	c7 44 24 0c b1 29 80 	movl   $0x8029b1,0xc(%esp)
  801734:	00 
  801735:	c7 44 24 08 90 29 80 	movl   $0x802990,0x8(%esp)
  80173c:	00 
  80173d:	c7 44 24 04 5b 00 00 	movl   $0x5b,0x4(%esp)
  801744:	00 
  801745:	c7 04 24 a5 29 80 00 	movl   $0x8029a5,(%esp)
  80174c:	e8 8b 06 00 00       	call   801ddc <_panic>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  801751:	89 44 24 08          	mov    %eax,0x8(%esp)
  801755:	c7 44 24 04 00 50 80 	movl   $0x805000,0x4(%esp)
  80175c:	00 
  80175d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801760:	89 04 24             	mov    %eax,(%esp)
  801763:	e8 1d ec ff ff       	call   800385 <memmove>
	}

	return r;
}
  801768:	89 d8                	mov    %ebx,%eax
  80176a:	83 c4 10             	add    $0x10,%esp
  80176d:	5b                   	pop    %ebx
  80176e:	5e                   	pop    %esi
  80176f:	5d                   	pop    %ebp
  801770:	c3                   	ret    

00801771 <nsipc_connect>:
	return nsipc(NSREQ_CLOSE);
}

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  801771:	55                   	push   %ebp
  801772:	89 e5                	mov    %esp,%ebp
  801774:	53                   	push   %ebx
  801775:	83 ec 14             	sub    $0x14,%esp
  801778:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  80177b:	8b 45 08             	mov    0x8(%ebp),%eax
  80177e:	a3 00 50 80 00       	mov    %eax,0x805000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  801783:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801787:	8b 45 0c             	mov    0xc(%ebp),%eax
  80178a:	89 44 24 04          	mov    %eax,0x4(%esp)
  80178e:	c7 04 24 04 50 80 00 	movl   $0x805004,(%esp)
  801795:	e8 eb eb ff ff       	call   800385 <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  80179a:	89 1d 14 50 80 00    	mov    %ebx,0x805014
	return nsipc(NSREQ_CONNECT);
  8017a0:	b8 05 00 00 00       	mov    $0x5,%eax
  8017a5:	e8 06 fe ff ff       	call   8015b0 <nsipc>
}
  8017aa:	83 c4 14             	add    $0x14,%esp
  8017ad:	5b                   	pop    %ebx
  8017ae:	5d                   	pop    %ebp
  8017af:	c3                   	ret    

008017b0 <nsipc_bind>:
	return r;
}

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  8017b0:	55                   	push   %ebp
  8017b1:	89 e5                	mov    %esp,%ebp
  8017b3:	53                   	push   %ebx
  8017b4:	83 ec 14             	sub    $0x14,%esp
  8017b7:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  8017ba:	8b 45 08             	mov    0x8(%ebp),%eax
  8017bd:	a3 00 50 80 00       	mov    %eax,0x805000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  8017c2:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8017c6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8017c9:	89 44 24 04          	mov    %eax,0x4(%esp)
  8017cd:	c7 04 24 04 50 80 00 	movl   $0x805004,(%esp)
  8017d4:	e8 ac eb ff ff       	call   800385 <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  8017d9:	89 1d 14 50 80 00    	mov    %ebx,0x805014
	return nsipc(NSREQ_BIND);
  8017df:	b8 02 00 00 00       	mov    $0x2,%eax
  8017e4:	e8 c7 fd ff ff       	call   8015b0 <nsipc>
}
  8017e9:	83 c4 14             	add    $0x14,%esp
  8017ec:	5b                   	pop    %ebx
  8017ed:	5d                   	pop    %ebp
  8017ee:	c3                   	ret    

008017ef <nsipc_accept>:
	return ipc_recv(NULL, NULL, NULL);
}

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  8017ef:	55                   	push   %ebp
  8017f0:	89 e5                	mov    %esp,%ebp
  8017f2:	83 ec 18             	sub    $0x18,%esp
  8017f5:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  8017f8:	89 75 fc             	mov    %esi,-0x4(%ebp)
	int r;
	
	nsipcbuf.accept.req_s = s;
  8017fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8017fe:	a3 00 50 80 00       	mov    %eax,0x805000
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  801803:	b8 01 00 00 00       	mov    $0x1,%eax
  801808:	e8 a3 fd ff ff       	call   8015b0 <nsipc>
  80180d:	89 c3                	mov    %eax,%ebx
  80180f:	85 c0                	test   %eax,%eax
  801811:	78 25                	js     801838 <nsipc_accept+0x49>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  801813:	be 10 50 80 00       	mov    $0x805010,%esi
  801818:	8b 06                	mov    (%esi),%eax
  80181a:	89 44 24 08          	mov    %eax,0x8(%esp)
  80181e:	c7 44 24 04 00 50 80 	movl   $0x805000,0x4(%esp)
  801825:	00 
  801826:	8b 45 0c             	mov    0xc(%ebp),%eax
  801829:	89 04 24             	mov    %eax,(%esp)
  80182c:	e8 54 eb ff ff       	call   800385 <memmove>
		*addrlen = ret->ret_addrlen;
  801831:	8b 16                	mov    (%esi),%edx
  801833:	8b 45 10             	mov    0x10(%ebp),%eax
  801836:	89 10                	mov    %edx,(%eax)
	}
	return r;
}
  801838:	89 d8                	mov    %ebx,%eax
  80183a:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  80183d:	8b 75 fc             	mov    -0x4(%ebp),%esi
  801840:	89 ec                	mov    %ebp,%esp
  801842:	5d                   	pop    %ebp
  801843:	c3                   	ret    
	...

00801850 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  801850:	55                   	push   %ebp
  801851:	89 e5                	mov    %esp,%ebp
  801853:	83 ec 18             	sub    $0x18,%esp
  801856:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  801859:	89 75 fc             	mov    %esi,-0x4(%ebp)
  80185c:	8b 75 0c             	mov    0xc(%ebp),%esi
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  80185f:	8b 45 08             	mov    0x8(%ebp),%eax
  801862:	89 04 24             	mov    %eax,(%esp)
  801865:	e8 86 f2 ff ff       	call   800af0 <fd2data>
  80186a:	89 c3                	mov    %eax,%ebx
	strcpy(stat->st_name, "<pipe>");
  80186c:	c7 44 24 04 c6 29 80 	movl   $0x8029c6,0x4(%esp)
  801873:	00 
  801874:	89 34 24             	mov    %esi,(%esp)
  801877:	e8 4e e9 ff ff       	call   8001ca <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  80187c:	8b 43 04             	mov    0x4(%ebx),%eax
  80187f:	2b 03                	sub    (%ebx),%eax
  801881:	89 86 80 00 00 00    	mov    %eax,0x80(%esi)
	stat->st_isdir = 0;
  801887:	c7 86 84 00 00 00 00 	movl   $0x0,0x84(%esi)
  80188e:	00 00 00 
	stat->st_dev = &devpipe;
  801891:	c7 86 88 00 00 00 3c 	movl   $0x80603c,0x88(%esi)
  801898:	60 80 00 
	return 0;
}
  80189b:	b8 00 00 00 00       	mov    $0x0,%eax
  8018a0:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  8018a3:	8b 75 fc             	mov    -0x4(%ebp),%esi
  8018a6:	89 ec                	mov    %ebp,%esp
  8018a8:	5d                   	pop    %ebp
  8018a9:	c3                   	ret    

008018aa <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  8018aa:	55                   	push   %ebp
  8018ab:	89 e5                	mov    %esp,%ebp
  8018ad:	53                   	push   %ebx
  8018ae:	83 ec 14             	sub    $0x14,%esp
  8018b1:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  8018b4:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8018b8:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8018bf:	e8 3b f0 ff ff       	call   8008ff <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  8018c4:	89 1c 24             	mov    %ebx,(%esp)
  8018c7:	e8 24 f2 ff ff       	call   800af0 <fd2data>
  8018cc:	89 44 24 04          	mov    %eax,0x4(%esp)
  8018d0:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8018d7:	e8 23 f0 ff ff       	call   8008ff <sys_page_unmap>
}
  8018dc:	83 c4 14             	add    $0x14,%esp
  8018df:	5b                   	pop    %ebx
  8018e0:	5d                   	pop    %ebp
  8018e1:	c3                   	ret    

008018e2 <_pipeisclosed>:
	return r;
}

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  8018e2:	55                   	push   %ebp
  8018e3:	89 e5                	mov    %esp,%ebp
  8018e5:	57                   	push   %edi
  8018e6:	56                   	push   %esi
  8018e7:	53                   	push   %ebx
  8018e8:	83 ec 2c             	sub    $0x2c,%esp
  8018eb:	89 c7                	mov    %eax,%edi
  8018ed:	89 55 e4             	mov    %edx,-0x1c(%ebp)
	int n, nn, ret;

	while (1) {
		n = env->env_runs;
  8018f0:	a1 74 60 80 00       	mov    0x806074,%eax
  8018f5:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  8018f8:	89 3c 24             	mov    %edi,(%esp)
  8018fb:	e8 e0 0c 00 00       	call   8025e0 <pageref>
  801900:	89 c6                	mov    %eax,%esi
  801902:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801905:	89 04 24             	mov    %eax,(%esp)
  801908:	e8 d3 0c 00 00       	call   8025e0 <pageref>
  80190d:	39 c6                	cmp    %eax,%esi
  80190f:	0f 94 c0             	sete   %al
  801912:	0f b6 c0             	movzbl %al,%eax
		nn = env->env_runs;
  801915:	8b 15 74 60 80 00    	mov    0x806074,%edx
  80191b:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  80191e:	39 cb                	cmp    %ecx,%ebx
  801920:	75 08                	jne    80192a <_pipeisclosed+0x48>
			return ret;
		if (n != nn && ret == 1)
			cprintf("pipe race avoided\n", n, env->env_runs, ret);
	}
}
  801922:	83 c4 2c             	add    $0x2c,%esp
  801925:	5b                   	pop    %ebx
  801926:	5e                   	pop    %esi
  801927:	5f                   	pop    %edi
  801928:	5d                   	pop    %ebp
  801929:	c3                   	ret    
		n = env->env_runs;
		ret = pageref(fd) == pageref(p);
		nn = env->env_runs;
		if (n == nn)
			return ret;
		if (n != nn && ret == 1)
  80192a:	83 f8 01             	cmp    $0x1,%eax
  80192d:	75 c1                	jne    8018f0 <_pipeisclosed+0xe>
			cprintf("pipe race avoided\n", n, env->env_runs, ret);
  80192f:	8b 52 58             	mov    0x58(%edx),%edx
  801932:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801936:	89 54 24 08          	mov    %edx,0x8(%esp)
  80193a:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  80193e:	c7 04 24 cd 29 80 00 	movl   $0x8029cd,(%esp)
  801945:	e8 57 05 00 00       	call   801ea1 <cprintf>
  80194a:	eb a4                	jmp    8018f0 <_pipeisclosed+0xe>

0080194c <devpipe_write>:
	return i;
}

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  80194c:	55                   	push   %ebp
  80194d:	89 e5                	mov    %esp,%ebp
  80194f:	57                   	push   %edi
  801950:	56                   	push   %esi
  801951:	53                   	push   %ebx
  801952:	83 ec 1c             	sub    $0x1c,%esp
  801955:	8b 75 08             	mov    0x8(%ebp),%esi
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  801958:	89 34 24             	mov    %esi,(%esp)
  80195b:	e8 90 f1 ff ff       	call   800af0 <fd2data>
  801960:	89 c3                	mov    %eax,%ebx
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			env->env_id, vpt[VPN(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  801962:	bf 00 00 00 00       	mov    $0x0,%edi
  801967:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80196b:	75 54                	jne    8019c1 <devpipe_write+0x75>
  80196d:	eb 60                	jmp    8019cf <devpipe_write+0x83>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  80196f:	89 da                	mov    %ebx,%edx
  801971:	89 f0                	mov    %esi,%eax
  801973:	e8 6a ff ff ff       	call   8018e2 <_pipeisclosed>
  801978:	85 c0                	test   %eax,%eax
  80197a:	74 07                	je     801983 <devpipe_write+0x37>
  80197c:	b8 00 00 00 00       	mov    $0x0,%eax
  801981:	eb 53                	jmp    8019d6 <devpipe_write+0x8a>
				return 0;
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  801983:	90                   	nop
  801984:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  801988:	e8 8d f0 ff ff       	call   800a1a <sys_yield>
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			env->env_id, vpt[VPN(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  80198d:	8b 43 04             	mov    0x4(%ebx),%eax
  801990:	8b 13                	mov    (%ebx),%edx
  801992:	83 c2 20             	add    $0x20,%edx
  801995:	39 d0                	cmp    %edx,%eax
  801997:	73 d6                	jae    80196f <devpipe_write+0x23>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  801999:	89 c2                	mov    %eax,%edx
  80199b:	c1 fa 1f             	sar    $0x1f,%edx
  80199e:	c1 ea 1b             	shr    $0x1b,%edx
  8019a1:	01 d0                	add    %edx,%eax
  8019a3:	83 e0 1f             	and    $0x1f,%eax
  8019a6:	29 d0                	sub    %edx,%eax
  8019a8:	89 c2                	mov    %eax,%edx
  8019aa:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8019ad:	0f b6 04 39          	movzbl (%ecx,%edi,1),%eax
  8019b1:	88 44 13 08          	mov    %al,0x8(%ebx,%edx,1)
		p->p_wpos++;
  8019b5:	83 43 04 01          	addl   $0x1,0x4(%ebx)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			env->env_id, vpt[VPN(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  8019b9:	83 c7 01             	add    $0x1,%edi
  8019bc:	39 7d 10             	cmp    %edi,0x10(%ebp)
  8019bf:	76 13                	jbe    8019d4 <devpipe_write+0x88>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  8019c1:	8b 43 04             	mov    0x4(%ebx),%eax
  8019c4:	8b 13                	mov    (%ebx),%edx
  8019c6:	83 c2 20             	add    $0x20,%edx
  8019c9:	39 d0                	cmp    %edx,%eax
  8019cb:	73 a2                	jae    80196f <devpipe_write+0x23>
  8019cd:	eb ca                	jmp    801999 <devpipe_write+0x4d>
  8019cf:	bf 00 00 00 00       	mov    $0x0,%edi
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}
	
	return i;
  8019d4:	89 f8                	mov    %edi,%eax
}
  8019d6:	83 c4 1c             	add    $0x1c,%esp
  8019d9:	5b                   	pop    %ebx
  8019da:	5e                   	pop    %esi
  8019db:	5f                   	pop    %edi
  8019dc:	5d                   	pop    %ebp
  8019dd:	c3                   	ret    

008019de <devpipe_read>:
	return _pipeisclosed(fd, p);
}

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  8019de:	55                   	push   %ebp
  8019df:	89 e5                	mov    %esp,%ebp
  8019e1:	83 ec 28             	sub    $0x28,%esp
  8019e4:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  8019e7:	89 75 f8             	mov    %esi,-0x8(%ebp)
  8019ea:	89 7d fc             	mov    %edi,-0x4(%ebp)
  8019ed:	8b 7d 08             	mov    0x8(%ebp),%edi
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  8019f0:	89 3c 24             	mov    %edi,(%esp)
  8019f3:	e8 f8 f0 ff ff       	call   800af0 <fd2data>
  8019f8:	89 c3                	mov    %eax,%ebx
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			env->env_id, vpt[VPN(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  8019fa:	be 00 00 00 00       	mov    $0x0,%esi
  8019ff:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801a03:	75 4c                	jne    801a51 <devpipe_read+0x73>
  801a05:	eb 5b                	jmp    801a62 <devpipe_read+0x84>
		while (p->p_rpos == p->p_wpos) {
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
				return i;
  801a07:	89 f0                	mov    %esi,%eax
  801a09:	eb 5e                	jmp    801a69 <devpipe_read+0x8b>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  801a0b:	89 da                	mov    %ebx,%edx
  801a0d:	89 f8                	mov    %edi,%eax
  801a0f:	90                   	nop
  801a10:	e8 cd fe ff ff       	call   8018e2 <_pipeisclosed>
  801a15:	85 c0                	test   %eax,%eax
  801a17:	74 07                	je     801a20 <devpipe_read+0x42>
  801a19:	b8 00 00 00 00       	mov    $0x0,%eax
  801a1e:	eb 49                	jmp    801a69 <devpipe_read+0x8b>
				return 0;
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  801a20:	e8 f5 ef ff ff       	call   800a1a <sys_yield>
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			env->env_id, vpt[VPN(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  801a25:	8b 03                	mov    (%ebx),%eax
  801a27:	3b 43 04             	cmp    0x4(%ebx),%eax
  801a2a:	74 df                	je     801a0b <devpipe_read+0x2d>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  801a2c:	89 c2                	mov    %eax,%edx
  801a2e:	c1 fa 1f             	sar    $0x1f,%edx
  801a31:	c1 ea 1b             	shr    $0x1b,%edx
  801a34:	01 d0                	add    %edx,%eax
  801a36:	83 e0 1f             	and    $0x1f,%eax
  801a39:	29 d0                	sub    %edx,%eax
  801a3b:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  801a40:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a43:	88 04 32             	mov    %al,(%edx,%esi,1)
		p->p_rpos++;
  801a46:	83 03 01             	addl   $0x1,(%ebx)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			env->env_id, vpt[VPN(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  801a49:	83 c6 01             	add    $0x1,%esi
  801a4c:	39 75 10             	cmp    %esi,0x10(%ebp)
  801a4f:	76 16                	jbe    801a67 <devpipe_read+0x89>
		while (p->p_rpos == p->p_wpos) {
  801a51:	8b 03                	mov    (%ebx),%eax
  801a53:	3b 43 04             	cmp    0x4(%ebx),%eax
  801a56:	75 d4                	jne    801a2c <devpipe_read+0x4e>
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  801a58:	85 f6                	test   %esi,%esi
  801a5a:	75 ab                	jne    801a07 <devpipe_read+0x29>
  801a5c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  801a60:	eb a9                	jmp    801a0b <devpipe_read+0x2d>
  801a62:	be 00 00 00 00       	mov    $0x0,%esi
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  801a67:	89 f0                	mov    %esi,%eax
}
  801a69:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  801a6c:	8b 75 f8             	mov    -0x8(%ebp),%esi
  801a6f:	8b 7d fc             	mov    -0x4(%ebp),%edi
  801a72:	89 ec                	mov    %ebp,%esp
  801a74:	5d                   	pop    %ebp
  801a75:	c3                   	ret    

00801a76 <pipeisclosed>:
	}
}

int
pipeisclosed(int fdnum)
{
  801a76:	55                   	push   %ebp
  801a77:	89 e5                	mov    %esp,%ebp
  801a79:	83 ec 28             	sub    $0x28,%esp
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801a7c:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801a7f:	89 44 24 04          	mov    %eax,0x4(%esp)
  801a83:	8b 45 08             	mov    0x8(%ebp),%eax
  801a86:	89 04 24             	mov    %eax,(%esp)
  801a89:	e8 ef f0 ff ff       	call   800b7d <fd_lookup>
  801a8e:	85 c0                	test   %eax,%eax
  801a90:	78 15                	js     801aa7 <pipeisclosed+0x31>
		return r;
	p = (struct Pipe*) fd2data(fd);
  801a92:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a95:	89 04 24             	mov    %eax,(%esp)
  801a98:	e8 53 f0 ff ff       	call   800af0 <fd2data>
	return _pipeisclosed(fd, p);
  801a9d:	89 c2                	mov    %eax,%edx
  801a9f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801aa2:	e8 3b fe ff ff       	call   8018e2 <_pipeisclosed>
}
  801aa7:	c9                   	leave  
  801aa8:	c3                   	ret    

00801aa9 <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  801aa9:	55                   	push   %ebp
  801aaa:	89 e5                	mov    %esp,%ebp
  801aac:	83 ec 48             	sub    $0x48,%esp
  801aaf:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  801ab2:	89 75 f8             	mov    %esi,-0x8(%ebp)
  801ab5:	89 7d fc             	mov    %edi,-0x4(%ebp)
  801ab8:	8b 7d 08             	mov    0x8(%ebp),%edi
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  801abb:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  801abe:	89 04 24             	mov    %eax,(%esp)
  801ac1:	e8 45 f0 ff ff       	call   800b0b <fd_alloc>
  801ac6:	89 c3                	mov    %eax,%ebx
  801ac8:	85 c0                	test   %eax,%eax
  801aca:	0f 88 42 01 00 00    	js     801c12 <pipe+0x169>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801ad0:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  801ad7:	00 
  801ad8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801adb:	89 44 24 04          	mov    %eax,0x4(%esp)
  801adf:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801ae6:	e8 d0 ee ff ff       	call   8009bb <sys_page_alloc>
  801aeb:	89 c3                	mov    %eax,%ebx
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  801aed:	85 c0                	test   %eax,%eax
  801aef:	0f 88 1d 01 00 00    	js     801c12 <pipe+0x169>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  801af5:	8d 45 e0             	lea    -0x20(%ebp),%eax
  801af8:	89 04 24             	mov    %eax,(%esp)
  801afb:	e8 0b f0 ff ff       	call   800b0b <fd_alloc>
  801b00:	89 c3                	mov    %eax,%ebx
  801b02:	85 c0                	test   %eax,%eax
  801b04:	0f 88 f5 00 00 00    	js     801bff <pipe+0x156>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801b0a:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  801b11:	00 
  801b12:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801b15:	89 44 24 04          	mov    %eax,0x4(%esp)
  801b19:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801b20:	e8 96 ee ff ff       	call   8009bb <sys_page_alloc>
  801b25:	89 c3                	mov    %eax,%ebx
	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  801b27:	85 c0                	test   %eax,%eax
  801b29:	0f 88 d0 00 00 00    	js     801bff <pipe+0x156>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  801b2f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801b32:	89 04 24             	mov    %eax,(%esp)
  801b35:	e8 b6 ef ff ff       	call   800af0 <fd2data>
  801b3a:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801b3c:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  801b43:	00 
  801b44:	89 44 24 04          	mov    %eax,0x4(%esp)
  801b48:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801b4f:	e8 67 ee ff ff       	call   8009bb <sys_page_alloc>
  801b54:	89 c3                	mov    %eax,%ebx
  801b56:	85 c0                	test   %eax,%eax
  801b58:	0f 88 8e 00 00 00    	js     801bec <pipe+0x143>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801b5e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801b61:	89 04 24             	mov    %eax,(%esp)
  801b64:	e8 87 ef ff ff       	call   800af0 <fd2data>
  801b69:	c7 44 24 10 07 04 00 	movl   $0x407,0x10(%esp)
  801b70:	00 
  801b71:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801b75:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801b7c:	00 
  801b7d:	89 74 24 04          	mov    %esi,0x4(%esp)
  801b81:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801b88:	e8 d0 ed ff ff       	call   80095d <sys_page_map>
  801b8d:	89 c3                	mov    %eax,%ebx
  801b8f:	85 c0                	test   %eax,%eax
  801b91:	78 49                	js     801bdc <pipe+0x133>
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  801b93:	b8 3c 60 80 00       	mov    $0x80603c,%eax
  801b98:	8b 08                	mov    (%eax),%ecx
  801b9a:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801b9d:	89 0a                	mov    %ecx,(%edx)
	fd0->fd_omode = O_RDONLY;
  801b9f:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801ba2:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%edx)

	fd1->fd_dev_id = devpipe.dev_id;
  801ba9:	8b 10                	mov    (%eax),%edx
  801bab:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801bae:	89 10                	mov    %edx,(%eax)
	fd1->fd_omode = O_WRONLY;
  801bb0:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801bb3:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", env->env_id, vpt[VPN(va)]);

	pfd[0] = fd2num(fd0);
  801bba:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801bbd:	89 04 24             	mov    %eax,(%esp)
  801bc0:	e8 1b ef ff ff       	call   800ae0 <fd2num>
  801bc5:	89 07                	mov    %eax,(%edi)
	pfd[1] = fd2num(fd1);
  801bc7:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801bca:	89 04 24             	mov    %eax,(%esp)
  801bcd:	e8 0e ef ff ff       	call   800ae0 <fd2num>
  801bd2:	89 47 04             	mov    %eax,0x4(%edi)
  801bd5:	bb 00 00 00 00       	mov    $0x0,%ebx
	return 0;
  801bda:	eb 36                	jmp    801c12 <pipe+0x169>

    err3:
	sys_page_unmap(0, va);
  801bdc:	89 74 24 04          	mov    %esi,0x4(%esp)
  801be0:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801be7:	e8 13 ed ff ff       	call   8008ff <sys_page_unmap>
    err2:
	sys_page_unmap(0, fd1);
  801bec:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801bef:	89 44 24 04          	mov    %eax,0x4(%esp)
  801bf3:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801bfa:	e8 00 ed ff ff       	call   8008ff <sys_page_unmap>
    err1:
	sys_page_unmap(0, fd0);
  801bff:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801c02:	89 44 24 04          	mov    %eax,0x4(%esp)
  801c06:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801c0d:	e8 ed ec ff ff       	call   8008ff <sys_page_unmap>
    err:
	return r;
}
  801c12:	89 d8                	mov    %ebx,%eax
  801c14:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  801c17:	8b 75 f8             	mov    -0x8(%ebp),%esi
  801c1a:	8b 7d fc             	mov    -0x4(%ebp),%edi
  801c1d:	89 ec                	mov    %ebp,%esp
  801c1f:	5d                   	pop    %ebp
  801c20:	c3                   	ret    
	...

00801c30 <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  801c30:	55                   	push   %ebp
  801c31:	89 e5                	mov    %esp,%ebp
	USED(fd);

	return 0;
}
  801c33:	b8 00 00 00 00       	mov    $0x0,%eax
  801c38:	5d                   	pop    %ebp
  801c39:	c3                   	ret    

00801c3a <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  801c3a:	55                   	push   %ebp
  801c3b:	89 e5                	mov    %esp,%ebp
  801c3d:	83 ec 18             	sub    $0x18,%esp
	strcpy(stat->st_name, "<cons>");
  801c40:	c7 44 24 04 e5 29 80 	movl   $0x8029e5,0x4(%esp)
  801c47:	00 
  801c48:	8b 45 0c             	mov    0xc(%ebp),%eax
  801c4b:	89 04 24             	mov    %eax,(%esp)
  801c4e:	e8 77 e5 ff ff       	call   8001ca <strcpy>
	return 0;
}
  801c53:	b8 00 00 00 00       	mov    $0x0,%eax
  801c58:	c9                   	leave  
  801c59:	c3                   	ret    

00801c5a <devcons_write>:
	return 1;
}

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  801c5a:	55                   	push   %ebp
  801c5b:	89 e5                	mov    %esp,%ebp
  801c5d:	57                   	push   %edi
  801c5e:	56                   	push   %esi
  801c5f:	53                   	push   %ebx
  801c60:	81 ec 9c 00 00 00    	sub    $0x9c,%esp
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs, 
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  801c66:	b8 00 00 00 00       	mov    $0x0,%eax
  801c6b:	be 00 00 00 00       	mov    $0x0,%esi
  801c70:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801c74:	74 3f                	je     801cb5 <devcons_write+0x5b>
		m = n - tot;
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  801c76:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs, 
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
		m = n - tot;
  801c7c:	8b 55 10             	mov    0x10(%ebp),%edx
  801c7f:	29 c2                	sub    %eax,%edx
  801c81:	89 d3                	mov    %edx,%ebx
		if (m > sizeof(buf) - 1)
  801c83:	83 fa 7f             	cmp    $0x7f,%edx
  801c86:	76 05                	jbe    801c8d <devcons_write+0x33>
  801c88:	bb 7f 00 00 00       	mov    $0x7f,%ebx
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  801c8d:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801c91:	03 45 0c             	add    0xc(%ebp),%eax
  801c94:	89 44 24 04          	mov    %eax,0x4(%esp)
  801c98:	89 3c 24             	mov    %edi,(%esp)
  801c9b:	e8 e5 e6 ff ff       	call   800385 <memmove>
		sys_cputs(buf, m);
  801ca0:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801ca4:	89 3c 24             	mov    %edi,(%esp)
  801ca7:	e8 14 e9 ff ff       	call   8005c0 <sys_cputs>
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs, 
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  801cac:	01 de                	add    %ebx,%esi
  801cae:	89 f0                	mov    %esi,%eax
  801cb0:	3b 75 10             	cmp    0x10(%ebp),%esi
  801cb3:	72 c7                	jb     801c7c <devcons_write+0x22>
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
}
  801cb5:	89 f0                	mov    %esi,%eax
  801cb7:	81 c4 9c 00 00 00    	add    $0x9c,%esp
  801cbd:	5b                   	pop    %ebx
  801cbe:	5e                   	pop    %esi
  801cbf:	5f                   	pop    %edi
  801cc0:	5d                   	pop    %ebp
  801cc1:	c3                   	ret    

00801cc2 <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  801cc2:	55                   	push   %ebp
  801cc3:	89 e5                	mov    %esp,%ebp
  801cc5:	83 ec 28             	sub    $0x28,%esp
	char c = ch;
  801cc8:	8b 45 08             	mov    0x8(%ebp),%eax
  801ccb:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  801cce:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  801cd5:	00 
  801cd6:	8d 45 f7             	lea    -0x9(%ebp),%eax
  801cd9:	89 04 24             	mov    %eax,(%esp)
  801cdc:	e8 df e8 ff ff       	call   8005c0 <sys_cputs>
}
  801ce1:	c9                   	leave  
  801ce2:	c3                   	ret    

00801ce3 <devcons_read>:
	return fd2num(fd);
}

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  801ce3:	55                   	push   %ebp
  801ce4:	89 e5                	mov    %esp,%ebp
  801ce6:	83 ec 08             	sub    $0x8,%esp
	int c;

	if (n == 0)
  801ce9:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801ced:	75 07                	jne    801cf6 <devcons_read+0x13>
  801cef:	eb 28                	jmp    801d19 <devcons_read+0x36>
		return 0;

	while ((c = sys_cgetc()) == 0)
		sys_yield();
  801cf1:	e8 24 ed ff ff       	call   800a1a <sys_yield>
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  801cf6:	66 90                	xchg   %ax,%ax
  801cf8:	e8 8f e8 ff ff       	call   80058c <sys_cgetc>
  801cfd:	85 c0                	test   %eax,%eax
  801cff:	90                   	nop
  801d00:	74 ef                	je     801cf1 <devcons_read+0xe>
  801d02:	89 c2                	mov    %eax,%edx
		sys_yield();
	if (c < 0)
  801d04:	85 c0                	test   %eax,%eax
  801d06:	78 16                	js     801d1e <devcons_read+0x3b>
		return c;
	if (c == 0x04)	// ctl-d is eof
  801d08:	83 f8 04             	cmp    $0x4,%eax
  801d0b:	74 0c                	je     801d19 <devcons_read+0x36>
		return 0;
	*(char*)vbuf = c;
  801d0d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801d10:	88 10                	mov    %dl,(%eax)
  801d12:	b8 01 00 00 00       	mov    $0x1,%eax
	return 1;
  801d17:	eb 05                	jmp    801d1e <devcons_read+0x3b>
  801d19:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801d1e:	c9                   	leave  
  801d1f:	c3                   	ret    

00801d20 <opencons>:
	return fd->fd_dev_id == devcons.dev_id;
}

int
opencons(void)
{
  801d20:	55                   	push   %ebp
  801d21:	89 e5                	mov    %esp,%ebp
  801d23:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  801d26:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801d29:	89 04 24             	mov    %eax,(%esp)
  801d2c:	e8 da ed ff ff       	call   800b0b <fd_alloc>
  801d31:	85 c0                	test   %eax,%eax
  801d33:	78 3f                	js     801d74 <opencons+0x54>
		return r;
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  801d35:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  801d3c:	00 
  801d3d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d40:	89 44 24 04          	mov    %eax,0x4(%esp)
  801d44:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801d4b:	e8 6b ec ff ff       	call   8009bb <sys_page_alloc>
  801d50:	85 c0                	test   %eax,%eax
  801d52:	78 20                	js     801d74 <opencons+0x54>
		return r;
	fd->fd_dev_id = devcons.dev_id;
  801d54:	8b 15 58 60 80 00    	mov    0x806058,%edx
  801d5a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d5d:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  801d5f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d62:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  801d69:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d6c:	89 04 24             	mov    %eax,(%esp)
  801d6f:	e8 6c ed ff ff       	call   800ae0 <fd2num>
}
  801d74:	c9                   	leave  
  801d75:	c3                   	ret    

00801d76 <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  801d76:	55                   	push   %ebp
  801d77:	89 e5                	mov    %esp,%ebp
  801d79:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801d7c:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801d7f:	89 44 24 04          	mov    %eax,0x4(%esp)
  801d83:	8b 45 08             	mov    0x8(%ebp),%eax
  801d86:	89 04 24             	mov    %eax,(%esp)
  801d89:	e8 ef ed ff ff       	call   800b7d <fd_lookup>
  801d8e:	85 c0                	test   %eax,%eax
  801d90:	78 11                	js     801da3 <iscons+0x2d>
		return r;
	return fd->fd_dev_id == devcons.dev_id;
  801d92:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d95:	8b 00                	mov    (%eax),%eax
  801d97:	3b 05 58 60 80 00    	cmp    0x806058,%eax
  801d9d:	0f 94 c0             	sete   %al
  801da0:	0f b6 c0             	movzbl %al,%eax
}
  801da3:	c9                   	leave  
  801da4:	c3                   	ret    

00801da5 <getchar>:
	sys_cputs(&c, 1);
}

int
getchar(void)
{
  801da5:	55                   	push   %ebp
  801da6:	89 e5                	mov    %esp,%ebp
  801da8:	83 ec 28             	sub    $0x28,%esp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  801dab:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  801db2:	00 
  801db3:	8d 45 f7             	lea    -0x9(%ebp),%eax
  801db6:	89 44 24 04          	mov    %eax,0x4(%esp)
  801dba:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801dc1:	e8 18 f0 ff ff       	call   800dde <read>
	if (r < 0)
  801dc6:	85 c0                	test   %eax,%eax
  801dc8:	78 0f                	js     801dd9 <getchar+0x34>
		return r;
	if (r < 1)
  801dca:	85 c0                	test   %eax,%eax
  801dcc:	7f 07                	jg     801dd5 <getchar+0x30>
  801dce:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  801dd3:	eb 04                	jmp    801dd9 <getchar+0x34>
		return -E_EOF;
	return c;
  801dd5:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  801dd9:	c9                   	leave  
  801dda:	c3                   	ret    
	...

00801ddc <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  801ddc:	55                   	push   %ebp
  801ddd:	89 e5                	mov    %esp,%ebp
  801ddf:	53                   	push   %ebx
  801de0:	83 ec 14             	sub    $0x14,%esp
 * Panic is called on unresolvable fatal errors.
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
  801de3:	8d 5d 14             	lea    0x14(%ebp),%ebx
	va_list ap;

	va_start(ap, fmt);

	// Print the panic message
	if (argv0)
  801de6:	a1 78 60 80 00       	mov    0x806078,%eax
  801deb:	85 c0                	test   %eax,%eax
  801ded:	74 10                	je     801dff <_panic+0x23>
		cprintf("%s: ", argv0);
  801def:	89 44 24 04          	mov    %eax,0x4(%esp)
  801df3:	c7 04 24 f1 29 80 00 	movl   $0x8029f1,(%esp)
  801dfa:	e8 a2 00 00 00       	call   801ea1 <cprintf>
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  801dff:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e02:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801e06:	8b 45 08             	mov    0x8(%ebp),%eax
  801e09:	89 44 24 08          	mov    %eax,0x8(%esp)
  801e0d:	a1 00 60 80 00       	mov    0x806000,%eax
  801e12:	89 44 24 04          	mov    %eax,0x4(%esp)
  801e16:	c7 04 24 f6 29 80 00 	movl   $0x8029f6,(%esp)
  801e1d:	e8 7f 00 00 00       	call   801ea1 <cprintf>
	vcprintf(fmt, ap);
  801e22:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801e26:	8b 45 10             	mov    0x10(%ebp),%eax
  801e29:	89 04 24             	mov    %eax,(%esp)
  801e2c:	e8 0f 00 00 00       	call   801e40 <vcprintf>
	cprintf("\n");
  801e31:	c7 04 24 de 29 80 00 	movl   $0x8029de,(%esp)
  801e38:	e8 64 00 00 00       	call   801ea1 <cprintf>

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  801e3d:	cc                   	int3   
  801e3e:	eb fd                	jmp    801e3d <_panic+0x61>

00801e40 <vcprintf>:
	b->cnt++;
}

int
vcprintf(const char *fmt, va_list ap)
{
  801e40:	55                   	push   %ebp
  801e41:	89 e5                	mov    %esp,%ebp
  801e43:	81 ec 28 01 00 00    	sub    $0x128,%esp
	struct printbuf b;

	b.idx = 0;
  801e49:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  801e50:	00 00 00 
	b.cnt = 0;
  801e53:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  801e5a:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  801e5d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e60:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801e64:	8b 45 08             	mov    0x8(%ebp),%eax
  801e67:	89 44 24 08          	mov    %eax,0x8(%esp)
  801e6b:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  801e71:	89 44 24 04          	mov    %eax,0x4(%esp)
  801e75:	c7 04 24 bb 1e 80 00 	movl   $0x801ebb,(%esp)
  801e7c:	e8 cc 01 00 00       	call   80204d <vprintfmt>
	sys_cputs(b.buf, b.idx);
  801e81:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
  801e87:	89 44 24 04          	mov    %eax,0x4(%esp)
  801e8b:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  801e91:	89 04 24             	mov    %eax,(%esp)
  801e94:	e8 27 e7 ff ff       	call   8005c0 <sys_cputs>

	return b.cnt;
}
  801e99:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  801e9f:	c9                   	leave  
  801ea0:	c3                   	ret    

00801ea1 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  801ea1:	55                   	push   %ebp
  801ea2:	89 e5                	mov    %esp,%ebp
  801ea4:	83 ec 18             	sub    $0x18,%esp

	return b.cnt;
}

int
cprintf(const char *fmt, ...)
  801ea7:	8d 45 0c             	lea    0xc(%ebp),%eax
{
	va_list ap;
	int cnt;

	va_start(ap, fmt);
	cnt = vcprintf(fmt, ap);
  801eaa:	89 44 24 04          	mov    %eax,0x4(%esp)
  801eae:	8b 45 08             	mov    0x8(%ebp),%eax
  801eb1:	89 04 24             	mov    %eax,(%esp)
  801eb4:	e8 87 ff ff ff       	call   801e40 <vcprintf>
	va_end(ap);

	return cnt;
}
  801eb9:	c9                   	leave  
  801eba:	c3                   	ret    

00801ebb <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  801ebb:	55                   	push   %ebp
  801ebc:	89 e5                	mov    %esp,%ebp
  801ebe:	53                   	push   %ebx
  801ebf:	83 ec 14             	sub    $0x14,%esp
  801ec2:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  801ec5:	8b 03                	mov    (%ebx),%eax
  801ec7:	8b 55 08             	mov    0x8(%ebp),%edx
  801eca:	88 54 03 08          	mov    %dl,0x8(%ebx,%eax,1)
  801ece:	83 c0 01             	add    $0x1,%eax
  801ed1:	89 03                	mov    %eax,(%ebx)
	if (b->idx == 256-1) {
  801ed3:	3d ff 00 00 00       	cmp    $0xff,%eax
  801ed8:	75 19                	jne    801ef3 <putch+0x38>
		sys_cputs(b->buf, b->idx);
  801eda:	c7 44 24 04 ff 00 00 	movl   $0xff,0x4(%esp)
  801ee1:	00 
  801ee2:	8d 43 08             	lea    0x8(%ebx),%eax
  801ee5:	89 04 24             	mov    %eax,(%esp)
  801ee8:	e8 d3 e6 ff ff       	call   8005c0 <sys_cputs>
		b->idx = 0;
  801eed:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
	}
	b->cnt++;
  801ef3:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  801ef7:	83 c4 14             	add    $0x14,%esp
  801efa:	5b                   	pop    %ebx
  801efb:	5d                   	pop    %ebp
  801efc:	c3                   	ret    
  801efd:	00 00                	add    %al,(%eax)
	...

00801f00 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  801f00:	55                   	push   %ebp
  801f01:	89 e5                	mov    %esp,%ebp
  801f03:	57                   	push   %edi
  801f04:	56                   	push   %esi
  801f05:	53                   	push   %ebx
  801f06:	83 ec 4c             	sub    $0x4c,%esp
  801f09:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801f0c:	89 d6                	mov    %edx,%esi
  801f0e:	8b 45 08             	mov    0x8(%ebp),%eax
  801f11:	89 45 d8             	mov    %eax,-0x28(%ebp)
  801f14:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f17:	89 55 e0             	mov    %edx,-0x20(%ebp)
  801f1a:	8b 45 10             	mov    0x10(%ebp),%eax
  801f1d:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801f20:	8b 7d 18             	mov    0x18(%ebp),%edi
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  801f23:	89 45 dc             	mov    %eax,-0x24(%ebp)
  801f26:	b9 00 00 00 00       	mov    $0x0,%ecx
  801f2b:	39 d1                	cmp    %edx,%ecx
  801f2d:	72 15                	jb     801f44 <printnum+0x44>
  801f2f:	77 07                	ja     801f38 <printnum+0x38>
  801f31:	8b 55 d8             	mov    -0x28(%ebp),%edx
  801f34:	39 d0                	cmp    %edx,%eax
  801f36:	76 0c                	jbe    801f44 <printnum+0x44>
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  801f38:	83 eb 01             	sub    $0x1,%ebx
  801f3b:	85 db                	test   %ebx,%ebx
  801f3d:	8d 76 00             	lea    0x0(%esi),%esi
  801f40:	7f 61                	jg     801fa3 <printnum+0xa3>
  801f42:	eb 70                	jmp    801fb4 <printnum+0xb4>
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
  801f44:	89 7c 24 10          	mov    %edi,0x10(%esp)
  801f48:	83 eb 01             	sub    $0x1,%ebx
  801f4b:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  801f4f:	89 44 24 08          	mov    %eax,0x8(%esp)
  801f53:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  801f57:	8b 5c 24 0c          	mov    0xc(%esp),%ebx
  801f5b:	89 4d d0             	mov    %ecx,-0x30(%ebp)
  801f5e:	89 5d d4             	mov    %ebx,-0x2c(%ebp)
  801f61:	8b 5d dc             	mov    -0x24(%ebp),%ebx
  801f64:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801f68:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  801f6f:	00 
  801f70:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801f73:	89 04 24             	mov    %eax,(%esp)
  801f76:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801f79:	89 54 24 04          	mov    %edx,0x4(%esp)
  801f7d:	e8 ae 06 00 00       	call   802630 <__udivdi3>
  801f82:	8b 4d d0             	mov    -0x30(%ebp),%ecx
  801f85:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
  801f88:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801f8c:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  801f90:	89 04 24             	mov    %eax,(%esp)
  801f93:	89 54 24 04          	mov    %edx,0x4(%esp)
  801f97:	89 f2                	mov    %esi,%edx
  801f99:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801f9c:	e8 5f ff ff ff       	call   801f00 <printnum>
  801fa1:	eb 11                	jmp    801fb4 <printnum+0xb4>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  801fa3:	89 74 24 04          	mov    %esi,0x4(%esp)
  801fa7:	89 3c 24             	mov    %edi,(%esp)
  801faa:	ff 55 e4             	call   *-0x1c(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  801fad:	83 eb 01             	sub    $0x1,%ebx
  801fb0:	85 db                	test   %ebx,%ebx
  801fb2:	7f ef                	jg     801fa3 <printnum+0xa3>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  801fb4:	89 74 24 04          	mov    %esi,0x4(%esp)
  801fb8:	8b 74 24 04          	mov    0x4(%esp),%esi
  801fbc:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801fbf:	89 44 24 08          	mov    %eax,0x8(%esp)
  801fc3:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  801fca:	00 
  801fcb:	8b 55 d8             	mov    -0x28(%ebp),%edx
  801fce:	89 14 24             	mov    %edx,(%esp)
  801fd1:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  801fd4:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801fd8:	e8 83 07 00 00       	call   802760 <__umoddi3>
  801fdd:	89 74 24 04          	mov    %esi,0x4(%esp)
  801fe1:	0f be 80 12 2a 80 00 	movsbl 0x802a12(%eax),%eax
  801fe8:	89 04 24             	mov    %eax,(%esp)
  801feb:	ff 55 e4             	call   *-0x1c(%ebp)
}
  801fee:	83 c4 4c             	add    $0x4c,%esp
  801ff1:	5b                   	pop    %ebx
  801ff2:	5e                   	pop    %esi
  801ff3:	5f                   	pop    %edi
  801ff4:	5d                   	pop    %ebp
  801ff5:	c3                   	ret    

00801ff6 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  801ff6:	55                   	push   %ebp
  801ff7:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  801ff9:	83 fa 01             	cmp    $0x1,%edx
  801ffc:	7e 0e                	jle    80200c <getuint+0x16>
		return va_arg(*ap, unsigned long long);
  801ffe:	8b 10                	mov    (%eax),%edx
  802000:	8d 4a 08             	lea    0x8(%edx),%ecx
  802003:	89 08                	mov    %ecx,(%eax)
  802005:	8b 02                	mov    (%edx),%eax
  802007:	8b 52 04             	mov    0x4(%edx),%edx
  80200a:	eb 22                	jmp    80202e <getuint+0x38>
	else if (lflag)
  80200c:	85 d2                	test   %edx,%edx
  80200e:	74 10                	je     802020 <getuint+0x2a>
		return va_arg(*ap, unsigned long);
  802010:	8b 10                	mov    (%eax),%edx
  802012:	8d 4a 04             	lea    0x4(%edx),%ecx
  802015:	89 08                	mov    %ecx,(%eax)
  802017:	8b 02                	mov    (%edx),%eax
  802019:	ba 00 00 00 00       	mov    $0x0,%edx
  80201e:	eb 0e                	jmp    80202e <getuint+0x38>
	else
		return va_arg(*ap, unsigned int);
  802020:	8b 10                	mov    (%eax),%edx
  802022:	8d 4a 04             	lea    0x4(%edx),%ecx
  802025:	89 08                	mov    %ecx,(%eax)
  802027:	8b 02                	mov    (%edx),%eax
  802029:	ba 00 00 00 00       	mov    $0x0,%edx
}
  80202e:	5d                   	pop    %ebp
  80202f:	c3                   	ret    

00802030 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  802030:	55                   	push   %ebp
  802031:	89 e5                	mov    %esp,%ebp
  802033:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  802036:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  80203a:	8b 10                	mov    (%eax),%edx
  80203c:	3b 50 04             	cmp    0x4(%eax),%edx
  80203f:	73 0a                	jae    80204b <sprintputch+0x1b>
		*b->buf++ = ch;
  802041:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802044:	88 0a                	mov    %cl,(%edx)
  802046:	83 c2 01             	add    $0x1,%edx
  802049:	89 10                	mov    %edx,(%eax)
}
  80204b:	5d                   	pop    %ebp
  80204c:	c3                   	ret    

0080204d <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  80204d:	55                   	push   %ebp
  80204e:	89 e5                	mov    %esp,%ebp
  802050:	57                   	push   %edi
  802051:	56                   	push   %esi
  802052:	53                   	push   %ebx
  802053:	83 ec 5c             	sub    $0x5c,%esp
  802056:	8b 7d 08             	mov    0x8(%ebp),%edi
  802059:	8b 75 0c             	mov    0xc(%ebp),%esi
  80205c:	8b 5d 10             	mov    0x10(%ebp),%ebx
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  80205f:	c7 45 c8 ff ff ff ff 	movl   $0xffffffff,-0x38(%ebp)
  802066:	eb 11                	jmp    802079 <vprintfmt+0x2c>
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
  802068:	85 c0                	test   %eax,%eax
  80206a:	0f 84 ec 03 00 00    	je     80245c <vprintfmt+0x40f>
				return;
			putch(ch, putdat);
  802070:	89 74 24 04          	mov    %esi,0x4(%esp)
  802074:	89 04 24             	mov    %eax,(%esp)
  802077:	ff d7                	call   *%edi
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  802079:	0f b6 03             	movzbl (%ebx),%eax
  80207c:	83 c3 01             	add    $0x1,%ebx
  80207f:	83 f8 25             	cmp    $0x25,%eax
  802082:	75 e4                	jne    802068 <vprintfmt+0x1b>
  802084:	c6 45 d4 20          	movb   $0x20,-0x2c(%ebp)
  802088:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
  80208f:	c7 45 d0 ff ff ff ff 	movl   $0xffffffff,-0x30(%ebp)
  802096:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
  80209d:	b9 00 00 00 00       	mov    $0x0,%ecx
  8020a2:	eb 06                	jmp    8020aa <vprintfmt+0x5d>
  8020a4:	c6 45 d4 2d          	movb   $0x2d,-0x2c(%ebp)
  8020a8:	89 c3                	mov    %eax,%ebx
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8020aa:	0f b6 13             	movzbl (%ebx),%edx
  8020ad:	0f b6 c2             	movzbl %dl,%eax
  8020b0:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8020b3:	8d 43 01             	lea    0x1(%ebx),%eax
  8020b6:	83 ea 23             	sub    $0x23,%edx
  8020b9:	80 fa 55             	cmp    $0x55,%dl
  8020bc:	0f 87 7d 03 00 00    	ja     80243f <vprintfmt+0x3f2>
  8020c2:	0f b6 d2             	movzbl %dl,%edx
  8020c5:	ff 24 95 60 2b 80 00 	jmp    *0x802b60(,%edx,4)
  8020cc:	c6 45 d4 30          	movb   $0x30,-0x2c(%ebp)
  8020d0:	eb d6                	jmp    8020a8 <vprintfmt+0x5b>
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
				precision = precision * 10 + ch - '0';
  8020d2:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8020d5:	83 ea 30             	sub    $0x30,%edx
  8020d8:	89 55 d0             	mov    %edx,-0x30(%ebp)
				ch = *fmt;
  8020db:	0f be 10             	movsbl (%eax),%edx
				if (ch < '0' || ch > '9')
  8020de:	8d 5a d0             	lea    -0x30(%edx),%ebx
  8020e1:	83 fb 09             	cmp    $0x9,%ebx
  8020e4:	77 4c                	ja     802132 <vprintfmt+0xe5>
  8020e6:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  8020e9:	8b 4d d0             	mov    -0x30(%ebp),%ecx
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8020ec:	83 c0 01             	add    $0x1,%eax
				precision = precision * 10 + ch - '0';
  8020ef:	8d 0c 89             	lea    (%ecx,%ecx,4),%ecx
  8020f2:	8d 4c 4a d0          	lea    -0x30(%edx,%ecx,2),%ecx
				ch = *fmt;
  8020f6:	0f be 10             	movsbl (%eax),%edx
				if (ch < '0' || ch > '9')
  8020f9:	8d 5a d0             	lea    -0x30(%edx),%ebx
  8020fc:	83 fb 09             	cmp    $0x9,%ebx
  8020ff:	76 eb                	jbe    8020ec <vprintfmt+0x9f>
  802101:	89 4d d0             	mov    %ecx,-0x30(%ebp)
  802104:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  802107:	eb 29                	jmp    802132 <vprintfmt+0xe5>
					break;
			}
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  802109:	8b 55 14             	mov    0x14(%ebp),%edx
  80210c:	8d 5a 04             	lea    0x4(%edx),%ebx
  80210f:	89 5d 14             	mov    %ebx,0x14(%ebp)
  802112:	8b 12                	mov    (%edx),%edx
  802114:	89 55 d0             	mov    %edx,-0x30(%ebp)
			goto process_precision;
  802117:	eb 19                	jmp    802132 <vprintfmt+0xe5>

		case '.':
			if (width < 0)
  802119:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80211c:	c1 fa 1f             	sar    $0x1f,%edx
  80211f:	f7 d2                	not    %edx
  802121:	21 55 e4             	and    %edx,-0x1c(%ebp)
  802124:	eb 82                	jmp    8020a8 <vprintfmt+0x5b>
  802126:	c7 45 d8 01 00 00 00 	movl   $0x1,-0x28(%ebp)
				width = 0;
			goto reswitch;

		case '#':
			altflag = 1;
			goto reswitch;
  80212d:	e9 76 ff ff ff       	jmp    8020a8 <vprintfmt+0x5b>

		process_precision:
			if (width < 0)
  802132:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  802136:	0f 89 6c ff ff ff    	jns    8020a8 <vprintfmt+0x5b>
  80213c:	8b 55 d0             	mov    -0x30(%ebp),%edx
  80213f:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  802142:	8b 55 c8             	mov    -0x38(%ebp),%edx
  802145:	89 55 d0             	mov    %edx,-0x30(%ebp)
  802148:	e9 5b ff ff ff       	jmp    8020a8 <vprintfmt+0x5b>
				width = precision, precision = -1;
			goto reswitch;

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  80214d:	83 c1 01             	add    $0x1,%ecx
			goto reswitch;
  802150:	e9 53 ff ff ff       	jmp    8020a8 <vprintfmt+0x5b>
  802155:	89 45 cc             	mov    %eax,-0x34(%ebp)

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  802158:	8b 45 14             	mov    0x14(%ebp),%eax
  80215b:	8d 50 04             	lea    0x4(%eax),%edx
  80215e:	89 55 14             	mov    %edx,0x14(%ebp)
  802161:	89 74 24 04          	mov    %esi,0x4(%esp)
  802165:	8b 00                	mov    (%eax),%eax
  802167:	89 04 24             	mov    %eax,(%esp)
  80216a:	ff d7                	call   *%edi
  80216c:	8b 5d cc             	mov    -0x34(%ebp),%ebx
			break;
  80216f:	e9 05 ff ff ff       	jmp    802079 <vprintfmt+0x2c>
  802174:	89 45 cc             	mov    %eax,-0x34(%ebp)

		// error message
		case 'e':
			err = va_arg(ap, int);
  802177:	8b 45 14             	mov    0x14(%ebp),%eax
  80217a:	8d 50 04             	lea    0x4(%eax),%edx
  80217d:	89 55 14             	mov    %edx,0x14(%ebp)
  802180:	8b 00                	mov    (%eax),%eax
  802182:	89 c2                	mov    %eax,%edx
  802184:	c1 fa 1f             	sar    $0x1f,%edx
  802187:	31 d0                	xor    %edx,%eax
  802189:	29 d0                	sub    %edx,%eax
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  80218b:	83 f8 0f             	cmp    $0xf,%eax
  80218e:	7f 0b                	jg     80219b <vprintfmt+0x14e>
  802190:	8b 14 85 c0 2c 80 00 	mov    0x802cc0(,%eax,4),%edx
  802197:	85 d2                	test   %edx,%edx
  802199:	75 20                	jne    8021bb <vprintfmt+0x16e>
				printfmt(putch, putdat, "error %d", err);
  80219b:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80219f:	c7 44 24 08 23 2a 80 	movl   $0x802a23,0x8(%esp)
  8021a6:	00 
  8021a7:	89 74 24 04          	mov    %esi,0x4(%esp)
  8021ab:	89 3c 24             	mov    %edi,(%esp)
  8021ae:	e8 31 03 00 00       	call   8024e4 <printfmt>
  8021b3:	8b 5d cc             	mov    -0x34(%ebp),%ebx
		// error message
		case 'e':
			err = va_arg(ap, int);
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  8021b6:	e9 be fe ff ff       	jmp    802079 <vprintfmt+0x2c>
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  8021bb:	89 54 24 0c          	mov    %edx,0xc(%esp)
  8021bf:	c7 44 24 08 a2 29 80 	movl   $0x8029a2,0x8(%esp)
  8021c6:	00 
  8021c7:	89 74 24 04          	mov    %esi,0x4(%esp)
  8021cb:	89 3c 24             	mov    %edi,(%esp)
  8021ce:	e8 11 03 00 00       	call   8024e4 <printfmt>
  8021d3:	8b 5d cc             	mov    -0x34(%ebp),%ebx
  8021d6:	e9 9e fe ff ff       	jmp    802079 <vprintfmt+0x2c>
  8021db:	89 45 cc             	mov    %eax,-0x34(%ebp)
  8021de:	89 c3                	mov    %eax,%ebx
  8021e0:	8b 4d d0             	mov    -0x30(%ebp),%ecx
  8021e3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8021e6:	89 45 c4             	mov    %eax,-0x3c(%ebp)
			break;

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  8021e9:	8b 45 14             	mov    0x14(%ebp),%eax
  8021ec:	8d 50 04             	lea    0x4(%eax),%edx
  8021ef:	89 55 14             	mov    %edx,0x14(%ebp)
  8021f2:	8b 00                	mov    (%eax),%eax
  8021f4:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8021f7:	85 c0                	test   %eax,%eax
  8021f9:	75 07                	jne    802202 <vprintfmt+0x1b5>
  8021fb:	c7 45 e0 2c 2a 80 00 	movl   $0x802a2c,-0x20(%ebp)
				p = "(null)";
			if (width > 0 && padc != '-')
  802202:	83 7d c4 00          	cmpl   $0x0,-0x3c(%ebp)
  802206:	7e 06                	jle    80220e <vprintfmt+0x1c1>
  802208:	80 7d d4 2d          	cmpb   $0x2d,-0x2c(%ebp)
  80220c:	75 13                	jne    802221 <vprintfmt+0x1d4>
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  80220e:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802211:	0f be 02             	movsbl (%edx),%eax
  802214:	85 c0                	test   %eax,%eax
  802216:	0f 85 99 00 00 00    	jne    8022b5 <vprintfmt+0x268>
  80221c:	e9 86 00 00 00       	jmp    8022a7 <vprintfmt+0x25a>
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  802221:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  802225:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  802228:	89 0c 24             	mov    %ecx,(%esp)
  80222b:	e8 6b df ff ff       	call   80019b <strnlen>
  802230:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  802233:	29 c2                	sub    %eax,%edx
  802235:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  802238:	85 d2                	test   %edx,%edx
  80223a:	7e d2                	jle    80220e <vprintfmt+0x1c1>
					putch(padc, putdat);
  80223c:	0f be 4d d4          	movsbl -0x2c(%ebp),%ecx
  802240:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  802243:	89 5d c4             	mov    %ebx,-0x3c(%ebp)
  802246:	89 d3                	mov    %edx,%ebx
  802248:	89 74 24 04          	mov    %esi,0x4(%esp)
  80224c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80224f:	89 04 24             	mov    %eax,(%esp)
  802252:	ff d7                	call   *%edi
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  802254:	83 eb 01             	sub    $0x1,%ebx
  802257:	85 db                	test   %ebx,%ebx
  802259:	7f ed                	jg     802248 <vprintfmt+0x1fb>
  80225b:	8b 5d c4             	mov    -0x3c(%ebp),%ebx
  80225e:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  802265:	eb a7                	jmp    80220e <vprintfmt+0x1c1>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
  802267:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  80226b:	74 18                	je     802285 <vprintfmt+0x238>
  80226d:	8d 50 e0             	lea    -0x20(%eax),%edx
  802270:	83 fa 5e             	cmp    $0x5e,%edx
  802273:	76 10                	jbe    802285 <vprintfmt+0x238>
					putch('?', putdat);
  802275:	89 7c 24 04          	mov    %edi,0x4(%esp)
  802279:	c7 04 24 3f 00 00 00 	movl   $0x3f,(%esp)
  802280:	ff 55 e0             	call   *-0x20(%ebp)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
  802283:	eb 0a                	jmp    80228f <vprintfmt+0x242>
					putch('?', putdat);
				else
					putch(ch, putdat);
  802285:	89 7c 24 04          	mov    %edi,0x4(%esp)
  802289:	89 04 24             	mov    %eax,(%esp)
  80228c:	ff 55 e0             	call   *-0x20(%ebp)
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  80228f:	83 6d e4 01          	subl   $0x1,-0x1c(%ebp)
  802293:	0f be 03             	movsbl (%ebx),%eax
  802296:	85 c0                	test   %eax,%eax
  802298:	74 05                	je     80229f <vprintfmt+0x252>
  80229a:	83 c3 01             	add    $0x1,%ebx
  80229d:	eb 29                	jmp    8022c8 <vprintfmt+0x27b>
  80229f:	89 fe                	mov    %edi,%esi
  8022a1:	8b 7d e0             	mov    -0x20(%ebp),%edi
  8022a4:	8b 5d d0             	mov    -0x30(%ebp),%ebx
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  8022a7:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8022ab:	7f 2e                	jg     8022db <vprintfmt+0x28e>
  8022ad:	8b 5d cc             	mov    -0x34(%ebp),%ebx
  8022b0:	e9 c4 fd ff ff       	jmp    802079 <vprintfmt+0x2c>
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8022b5:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8022b8:	83 c2 01             	add    $0x1,%edx
  8022bb:	89 7d e0             	mov    %edi,-0x20(%ebp)
  8022be:	89 f7                	mov    %esi,%edi
  8022c0:	8b 75 d0             	mov    -0x30(%ebp),%esi
  8022c3:	89 5d d0             	mov    %ebx,-0x30(%ebp)
  8022c6:	89 d3                	mov    %edx,%ebx
  8022c8:	85 f6                	test   %esi,%esi
  8022ca:	78 9b                	js     802267 <vprintfmt+0x21a>
  8022cc:	83 ee 01             	sub    $0x1,%esi
  8022cf:	79 96                	jns    802267 <vprintfmt+0x21a>
  8022d1:	89 fe                	mov    %edi,%esi
  8022d3:	8b 7d e0             	mov    -0x20(%ebp),%edi
  8022d6:	8b 5d d0             	mov    -0x30(%ebp),%ebx
  8022d9:	eb cc                	jmp    8022a7 <vprintfmt+0x25a>
  8022db:	89 5d d8             	mov    %ebx,-0x28(%ebp)
  8022de:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
				putch(' ', putdat);
  8022e1:	89 74 24 04          	mov    %esi,0x4(%esp)
  8022e5:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  8022ec:	ff d7                	call   *%edi
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  8022ee:	83 eb 01             	sub    $0x1,%ebx
  8022f1:	85 db                	test   %ebx,%ebx
  8022f3:	7f ec                	jg     8022e1 <vprintfmt+0x294>
  8022f5:	8b 5d d8             	mov    -0x28(%ebp),%ebx
  8022f8:	e9 7c fd ff ff       	jmp    802079 <vprintfmt+0x2c>
  8022fd:	89 45 cc             	mov    %eax,-0x34(%ebp)
// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
	if (lflag >= 2)
  802300:	83 f9 01             	cmp    $0x1,%ecx
  802303:	7e 16                	jle    80231b <vprintfmt+0x2ce>
		return va_arg(*ap, long long);
  802305:	8b 45 14             	mov    0x14(%ebp),%eax
  802308:	8d 50 08             	lea    0x8(%eax),%edx
  80230b:	89 55 14             	mov    %edx,0x14(%ebp)
  80230e:	8b 10                	mov    (%eax),%edx
  802310:	8b 48 04             	mov    0x4(%eax),%ecx
  802313:	89 55 d8             	mov    %edx,-0x28(%ebp)
  802316:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  802319:	eb 32                	jmp    80234d <vprintfmt+0x300>
	else if (lflag)
  80231b:	85 c9                	test   %ecx,%ecx
  80231d:	74 18                	je     802337 <vprintfmt+0x2ea>
		return va_arg(*ap, long);
  80231f:	8b 45 14             	mov    0x14(%ebp),%eax
  802322:	8d 50 04             	lea    0x4(%eax),%edx
  802325:	89 55 14             	mov    %edx,0x14(%ebp)
  802328:	8b 00                	mov    (%eax),%eax
  80232a:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80232d:	89 c1                	mov    %eax,%ecx
  80232f:	c1 f9 1f             	sar    $0x1f,%ecx
  802332:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  802335:	eb 16                	jmp    80234d <vprintfmt+0x300>
	else
		return va_arg(*ap, int);
  802337:	8b 45 14             	mov    0x14(%ebp),%eax
  80233a:	8d 50 04             	lea    0x4(%eax),%edx
  80233d:	89 55 14             	mov    %edx,0x14(%ebp)
  802340:	8b 00                	mov    (%eax),%eax
  802342:	89 45 d8             	mov    %eax,-0x28(%ebp)
  802345:	89 c2                	mov    %eax,%edx
  802347:	c1 fa 1f             	sar    $0x1f,%edx
  80234a:	89 55 dc             	mov    %edx,-0x24(%ebp)
				putch(' ', putdat);
			break;

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  80234d:	8b 4d d8             	mov    -0x28(%ebp),%ecx
  802350:	8b 5d dc             	mov    -0x24(%ebp),%ebx
  802353:	b8 0a 00 00 00       	mov    $0xa,%eax
			if ((long long) num < 0) {
  802358:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  80235c:	0f 89 9b 00 00 00    	jns    8023fd <vprintfmt+0x3b0>
				putch('-', putdat);
  802362:	89 74 24 04          	mov    %esi,0x4(%esp)
  802366:	c7 04 24 2d 00 00 00 	movl   $0x2d,(%esp)
  80236d:	ff d7                	call   *%edi
				num = -(long long) num;
  80236f:	8b 4d d8             	mov    -0x28(%ebp),%ecx
  802372:	8b 5d dc             	mov    -0x24(%ebp),%ebx
  802375:	f7 d9                	neg    %ecx
  802377:	83 d3 00             	adc    $0x0,%ebx
  80237a:	f7 db                	neg    %ebx
  80237c:	b8 0a 00 00 00       	mov    $0xa,%eax
  802381:	eb 7a                	jmp    8023fd <vprintfmt+0x3b0>
  802383:	89 45 cc             	mov    %eax,-0x34(%ebp)
			base = 10;
			goto number;

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  802386:	89 ca                	mov    %ecx,%edx
  802388:	8d 45 14             	lea    0x14(%ebp),%eax
  80238b:	e8 66 fc ff ff       	call   801ff6 <getuint>
  802390:	89 c1                	mov    %eax,%ecx
  802392:	89 d3                	mov    %edx,%ebx
  802394:	b8 0a 00 00 00       	mov    $0xa,%eax
			base = 10;
			goto number;
  802399:	eb 62                	jmp    8023fd <vprintfmt+0x3b0>
  80239b:	89 45 cc             	mov    %eax,-0x34(%ebp)
		case 'o':
			// Replace this with your code.
			// putch('X', putdat);
			// putch('X', putdat);
			// putch('X', putdat);
			num = getuint(&ap, lflag);
  80239e:	89 ca                	mov    %ecx,%edx
  8023a0:	8d 45 14             	lea    0x14(%ebp),%eax
  8023a3:	e8 4e fc ff ff       	call   801ff6 <getuint>
  8023a8:	89 c1                	mov    %eax,%ecx
  8023aa:	89 d3                	mov    %edx,%ebx
  8023ac:	b8 08 00 00 00       	mov    $0x8,%eax
			base = 8;
			goto number;
  8023b1:	eb 4a                	jmp    8023fd <vprintfmt+0x3b0>
  8023b3:	89 45 cc             	mov    %eax,-0x34(%ebp)
			break;

		// pointer
		case 'p':
			putch('0', putdat);
  8023b6:	89 74 24 04          	mov    %esi,0x4(%esp)
  8023ba:	c7 04 24 30 00 00 00 	movl   $0x30,(%esp)
  8023c1:	ff d7                	call   *%edi
			putch('x', putdat);
  8023c3:	89 74 24 04          	mov    %esi,0x4(%esp)
  8023c7:	c7 04 24 78 00 00 00 	movl   $0x78,(%esp)
  8023ce:	ff d7                	call   *%edi
			num = (unsigned long long)
  8023d0:	8b 45 14             	mov    0x14(%ebp),%eax
  8023d3:	8d 50 04             	lea    0x4(%eax),%edx
  8023d6:	89 55 14             	mov    %edx,0x14(%ebp)
  8023d9:	8b 08                	mov    (%eax),%ecx
  8023db:	bb 00 00 00 00       	mov    $0x0,%ebx
  8023e0:	b8 10 00 00 00       	mov    $0x10,%eax
				(uintptr_t) va_arg(ap, void *);
			base = 16;
			goto number;
  8023e5:	eb 16                	jmp    8023fd <vprintfmt+0x3b0>
  8023e7:	89 45 cc             	mov    %eax,-0x34(%ebp)

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  8023ea:	89 ca                	mov    %ecx,%edx
  8023ec:	8d 45 14             	lea    0x14(%ebp),%eax
  8023ef:	e8 02 fc ff ff       	call   801ff6 <getuint>
  8023f4:	89 c1                	mov    %eax,%ecx
  8023f6:	89 d3                	mov    %edx,%ebx
  8023f8:	b8 10 00 00 00       	mov    $0x10,%eax
			base = 16;
		number:
			printnum(putch, putdat, num, base, width, padc);
  8023fd:	0f be 55 d4          	movsbl -0x2c(%ebp),%edx
  802401:	89 54 24 10          	mov    %edx,0x10(%esp)
  802405:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802408:	89 54 24 0c          	mov    %edx,0xc(%esp)
  80240c:	89 44 24 08          	mov    %eax,0x8(%esp)
  802410:	89 0c 24             	mov    %ecx,(%esp)
  802413:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  802417:	89 f2                	mov    %esi,%edx
  802419:	89 f8                	mov    %edi,%eax
  80241b:	e8 e0 fa ff ff       	call   801f00 <printnum>
  802420:	8b 5d cc             	mov    -0x34(%ebp),%ebx
			break;
  802423:	e9 51 fc ff ff       	jmp    802079 <vprintfmt+0x2c>
  802428:	89 45 cc             	mov    %eax,-0x34(%ebp)
  80242b:	8b 55 e0             	mov    -0x20(%ebp),%edx

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  80242e:	89 74 24 04          	mov    %esi,0x4(%esp)
  802432:	89 14 24             	mov    %edx,(%esp)
  802435:	ff d7                	call   *%edi
  802437:	8b 5d cc             	mov    -0x34(%ebp),%ebx
			break;
  80243a:	e9 3a fc ff ff       	jmp    802079 <vprintfmt+0x2c>
			
		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  80243f:	89 74 24 04          	mov    %esi,0x4(%esp)
  802443:	c7 04 24 25 00 00 00 	movl   $0x25,(%esp)
  80244a:	ff d7                	call   *%edi
			for (fmt--; fmt[-1] != '%'; fmt--)
  80244c:	8d 43 ff             	lea    -0x1(%ebx),%eax
  80244f:	80 38 25             	cmpb   $0x25,(%eax)
  802452:	0f 84 21 fc ff ff    	je     802079 <vprintfmt+0x2c>
  802458:	89 c3                	mov    %eax,%ebx
  80245a:	eb f0                	jmp    80244c <vprintfmt+0x3ff>
				/* do nothing */;
			break;
		}
	}
}
  80245c:	83 c4 5c             	add    $0x5c,%esp
  80245f:	5b                   	pop    %ebx
  802460:	5e                   	pop    %esi
  802461:	5f                   	pop    %edi
  802462:	5d                   	pop    %ebp
  802463:	c3                   	ret    

00802464 <vsnprintf>:
		*b->buf++ = ch;
}

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  802464:	55                   	push   %ebp
  802465:	89 e5                	mov    %esp,%ebp
  802467:	83 ec 28             	sub    $0x28,%esp
  80246a:	8b 45 08             	mov    0x8(%ebp),%eax
  80246d:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};

	if (buf == NULL || n < 1)
  802470:	85 c0                	test   %eax,%eax
  802472:	74 04                	je     802478 <vsnprintf+0x14>
  802474:	85 d2                	test   %edx,%edx
  802476:	7f 07                	jg     80247f <vsnprintf+0x1b>
  802478:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80247d:	eb 3b                	jmp    8024ba <vsnprintf+0x56>
}

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
	struct sprintbuf b = {buf, buf+n-1, 0};
  80247f:	89 45 ec             	mov    %eax,-0x14(%ebp)
  802482:	8d 44 10 ff          	lea    -0x1(%eax,%edx,1),%eax
  802486:	89 45 f0             	mov    %eax,-0x10(%ebp)
  802489:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  802490:	8b 45 14             	mov    0x14(%ebp),%eax
  802493:	89 44 24 0c          	mov    %eax,0xc(%esp)
  802497:	8b 45 10             	mov    0x10(%ebp),%eax
  80249a:	89 44 24 08          	mov    %eax,0x8(%esp)
  80249e:	8d 45 ec             	lea    -0x14(%ebp),%eax
  8024a1:	89 44 24 04          	mov    %eax,0x4(%esp)
  8024a5:	c7 04 24 30 20 80 00 	movl   $0x802030,(%esp)
  8024ac:	e8 9c fb ff ff       	call   80204d <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  8024b1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8024b4:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  8024b7:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  8024ba:	c9                   	leave  
  8024bb:	c3                   	ret    

008024bc <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  8024bc:	55                   	push   %ebp
  8024bd:	89 e5                	mov    %esp,%ebp
  8024bf:	83 ec 18             	sub    $0x18,%esp

	return b.cnt;
}

int
snprintf(char *buf, int n, const char *fmt, ...)
  8024c2:	8d 45 14             	lea    0x14(%ebp),%eax
{
	va_list ap;
	int rc;

	va_start(ap, fmt);
	rc = vsnprintf(buf, n, fmt, ap);
  8024c5:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8024c9:	8b 45 10             	mov    0x10(%ebp),%eax
  8024cc:	89 44 24 08          	mov    %eax,0x8(%esp)
  8024d0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8024d3:	89 44 24 04          	mov    %eax,0x4(%esp)
  8024d7:	8b 45 08             	mov    0x8(%ebp),%eax
  8024da:	89 04 24             	mov    %eax,(%esp)
  8024dd:	e8 82 ff ff ff       	call   802464 <vsnprintf>
	va_end(ap);

	return rc;
}
  8024e2:	c9                   	leave  
  8024e3:	c3                   	ret    

008024e4 <printfmt>:
	}
}

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  8024e4:	55                   	push   %ebp
  8024e5:	89 e5                	mov    %esp,%ebp
  8024e7:	83 ec 18             	sub    $0x18,%esp
		}
	}
}

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
  8024ea:	8d 45 14             	lea    0x14(%ebp),%eax
{
	va_list ap;

	va_start(ap, fmt);
	vprintfmt(putch, putdat, fmt, ap);
  8024ed:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8024f1:	8b 45 10             	mov    0x10(%ebp),%eax
  8024f4:	89 44 24 08          	mov    %eax,0x8(%esp)
  8024f8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8024fb:	89 44 24 04          	mov    %eax,0x4(%esp)
  8024ff:	8b 45 08             	mov    0x8(%ebp),%eax
  802502:	89 04 24             	mov    %eax,(%esp)
  802505:	e8 43 fb ff ff       	call   80204d <vprintfmt>
	va_end(ap);
}
  80250a:	c9                   	leave  
  80250b:	c3                   	ret    
  80250c:	00 00                	add    %al,(%eax)
	...

00802510 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  802510:	55                   	push   %ebp
  802511:	89 e5                	mov    %esp,%ebp
  802513:	57                   	push   %edi
  802514:	56                   	push   %esi
  802515:	53                   	push   %ebx
  802516:	83 ec 1c             	sub    $0x1c,%esp
  802519:	8b 7d 0c             	mov    0xc(%ebp),%edi
  80251c:	8b 5d 10             	mov    0x10(%ebp),%ebx
  80251f:	8b 75 14             	mov    0x14(%ebp),%esi
	// LAB 4: Your code here.
	int r;
	if (pg == NULL)
  802522:	85 db                	test   %ebx,%ebx
  802524:	75 2d                	jne    802553 <ipc_send+0x43>
  802526:	bb 00 00 c0 ee       	mov    $0xeec00000,%ebx
  80252b:	eb 26                	jmp    802553 <ipc_send+0x43>
		pg = (void*)UTOP;
	while ((r = sys_ipc_try_send(to_env, val, pg, perm)) < 0)
	{
		if(r != -E_IPC_NOT_RECV)
  80252d:	83 f8 f9             	cmp    $0xfffffff9,%eax
  802530:	74 1c                	je     80254e <ipc_send+0x3e>
			panic("Panic in lib ipc.c : ipc_send() \n");
  802532:	c7 44 24 08 20 2d 80 	movl   $0x802d20,0x8(%esp)
  802539:	00 
  80253a:	c7 44 24 04 44 00 00 	movl   $0x44,0x4(%esp)
  802541:	00 
  802542:	c7 04 24 44 2d 80 00 	movl   $0x802d44,(%esp)
  802549:	e8 8e f8 ff ff       	call   801ddc <_panic>
		sys_yield();
  80254e:	e8 c7 e4 ff ff       	call   800a1a <sys_yield>
{
	// LAB 4: Your code here.
	int r;
	if (pg == NULL)
		pg = (void*)UTOP;
	while ((r = sys_ipc_try_send(to_env, val, pg, perm)) < 0)
  802553:	89 74 24 0c          	mov    %esi,0xc(%esp)
  802557:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80255b:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80255f:	8b 45 08             	mov    0x8(%ebp),%eax
  802562:	89 04 24             	mov    %eax,(%esp)
  802565:	e8 43 e2 ff ff       	call   8007ad <sys_ipc_try_send>
  80256a:	85 c0                	test   %eax,%eax
  80256c:	78 bf                	js     80252d <ipc_send+0x1d>
		if(r != -E_IPC_NOT_RECV)
			panic("Panic in lib ipc.c : ipc_send() \n");
		sys_yield();
	}
	//panic("ipc_send not implemented");
}
  80256e:	83 c4 1c             	add    $0x1c,%esp
  802571:	5b                   	pop    %ebx
  802572:	5e                   	pop    %esi
  802573:	5f                   	pop    %edi
  802574:	5d                   	pop    %ebp
  802575:	c3                   	ret    

00802576 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  802576:	55                   	push   %ebp
  802577:	89 e5                	mov    %esp,%ebp
  802579:	56                   	push   %esi
  80257a:	53                   	push   %ebx
  80257b:	83 ec 10             	sub    $0x10,%esp
  80257e:	8b 5d 08             	mov    0x8(%ebp),%ebx
  802581:	8b 45 0c             	mov    0xc(%ebp),%eax
  802584:	8b 75 10             	mov    0x10(%ebp),%esi
	// LAB 4: Your code here.
	int r;

	if (pg == NULL)
  802587:	85 c0                	test   %eax,%eax
  802589:	75 05                	jne    802590 <ipc_recv+0x1a>
  80258b:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
		pg = (void*)UTOP;
	if ((r = sys_ipc_recv(pg)) < 0)
  802590:	89 04 24             	mov    %eax,(%esp)
  802593:	e8 b8 e1 ff ff       	call   800750 <sys_ipc_recv>
  802598:	85 c0                	test   %eax,%eax
  80259a:	79 16                	jns    8025b2 <ipc_recv+0x3c>
	{
		if (from_env_store != NULL)
  80259c:	85 db                	test   %ebx,%ebx
  80259e:	74 06                	je     8025a6 <ipc_recv+0x30>
			*from_env_store = 0;
  8025a0:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
		if(perm_store != NULL)
  8025a6:	85 f6                	test   %esi,%esi
  8025a8:	74 2c                	je     8025d6 <ipc_recv+0x60>
			*perm_store = 0;
  8025aa:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
  8025b0:	eb 24                	jmp    8025d6 <ipc_recv+0x60>
		return r;
	}
	else
	{	
		if (from_env_store != NULL)
  8025b2:	85 db                	test   %ebx,%ebx
  8025b4:	74 0a                	je     8025c0 <ipc_recv+0x4a>
			*from_env_store = env->env_ipc_from;
  8025b6:	a1 74 60 80 00       	mov    0x806074,%eax
  8025bb:	8b 40 74             	mov    0x74(%eax),%eax
  8025be:	89 03                	mov    %eax,(%ebx)
		if(perm_store != NULL)
  8025c0:	85 f6                	test   %esi,%esi
  8025c2:	74 0a                	je     8025ce <ipc_recv+0x58>
			*perm_store = env->env_ipc_perm;
  8025c4:	a1 74 60 80 00       	mov    0x806074,%eax
  8025c9:	8b 40 78             	mov    0x78(%eax),%eax
  8025cc:	89 06                	mov    %eax,(%esi)
		return env->env_ipc_value;
  8025ce:	a1 74 60 80 00       	mov    0x806074,%eax
  8025d3:	8b 40 70             	mov    0x70(%eax),%eax
	}		
	//panic("ipc_recv not implemented");
	//return 0;
}
  8025d6:	83 c4 10             	add    $0x10,%esp
  8025d9:	5b                   	pop    %ebx
  8025da:	5e                   	pop    %esi
  8025db:	5d                   	pop    %ebp
  8025dc:	c3                   	ret    
  8025dd:	00 00                	add    %al,(%eax)
	...

008025e0 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  8025e0:	55                   	push   %ebp
  8025e1:	89 e5                	mov    %esp,%ebp
	pte_t pte;

	if (!(vpd[PDX(v)] & PTE_P))
  8025e3:	8b 45 08             	mov    0x8(%ebp),%eax
  8025e6:	89 c2                	mov    %eax,%edx
  8025e8:	c1 ea 16             	shr    $0x16,%edx
  8025eb:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  8025f2:	f6 c2 01             	test   $0x1,%dl
  8025f5:	74 26                	je     80261d <pageref+0x3d>
		return 0;
	pte = vpt[VPN(v)];
  8025f7:	c1 e8 0c             	shr    $0xc,%eax
  8025fa:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
	if (!(pte & PTE_P))
  802601:	a8 01                	test   $0x1,%al
  802603:	74 18                	je     80261d <pageref+0x3d>
		return 0;
	return pages[PPN(pte)].pp_ref;
  802605:	c1 e8 0c             	shr    $0xc,%eax
  802608:	8d 14 40             	lea    (%eax,%eax,2),%edx
  80260b:	c1 e2 02             	shl    $0x2,%edx
  80260e:	b8 00 00 00 ef       	mov    $0xef000000,%eax
  802613:	0f b7 44 02 08       	movzwl 0x8(%edx,%eax,1),%eax
  802618:	0f b7 c0             	movzwl %ax,%eax
  80261b:	eb 05                	jmp    802622 <pageref+0x42>
  80261d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802622:	5d                   	pop    %ebp
  802623:	c3                   	ret    
	...

00802630 <__udivdi3>:
  802630:	55                   	push   %ebp
  802631:	89 e5                	mov    %esp,%ebp
  802633:	57                   	push   %edi
  802634:	56                   	push   %esi
  802635:	83 ec 10             	sub    $0x10,%esp
  802638:	8b 45 14             	mov    0x14(%ebp),%eax
  80263b:	8b 55 08             	mov    0x8(%ebp),%edx
  80263e:	8b 75 10             	mov    0x10(%ebp),%esi
  802641:	8b 7d 0c             	mov    0xc(%ebp),%edi
  802644:	85 c0                	test   %eax,%eax
  802646:	89 55 f0             	mov    %edx,-0x10(%ebp)
  802649:	75 35                	jne    802680 <__udivdi3+0x50>
  80264b:	39 fe                	cmp    %edi,%esi
  80264d:	77 61                	ja     8026b0 <__udivdi3+0x80>
  80264f:	85 f6                	test   %esi,%esi
  802651:	75 0b                	jne    80265e <__udivdi3+0x2e>
  802653:	b8 01 00 00 00       	mov    $0x1,%eax
  802658:	31 d2                	xor    %edx,%edx
  80265a:	f7 f6                	div    %esi
  80265c:	89 c6                	mov    %eax,%esi
  80265e:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  802661:	31 d2                	xor    %edx,%edx
  802663:	89 f8                	mov    %edi,%eax
  802665:	f7 f6                	div    %esi
  802667:	89 c7                	mov    %eax,%edi
  802669:	89 c8                	mov    %ecx,%eax
  80266b:	f7 f6                	div    %esi
  80266d:	89 c1                	mov    %eax,%ecx
  80266f:	89 fa                	mov    %edi,%edx
  802671:	89 c8                	mov    %ecx,%eax
  802673:	83 c4 10             	add    $0x10,%esp
  802676:	5e                   	pop    %esi
  802677:	5f                   	pop    %edi
  802678:	5d                   	pop    %ebp
  802679:	c3                   	ret    
  80267a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  802680:	39 f8                	cmp    %edi,%eax
  802682:	77 1c                	ja     8026a0 <__udivdi3+0x70>
  802684:	0f bd d0             	bsr    %eax,%edx
  802687:	83 f2 1f             	xor    $0x1f,%edx
  80268a:	89 55 f4             	mov    %edx,-0xc(%ebp)
  80268d:	75 39                	jne    8026c8 <__udivdi3+0x98>
  80268f:	3b 75 f0             	cmp    -0x10(%ebp),%esi
  802692:	0f 86 a0 00 00 00    	jbe    802738 <__udivdi3+0x108>
  802698:	39 f8                	cmp    %edi,%eax
  80269a:	0f 82 98 00 00 00    	jb     802738 <__udivdi3+0x108>
  8026a0:	31 ff                	xor    %edi,%edi
  8026a2:	31 c9                	xor    %ecx,%ecx
  8026a4:	89 c8                	mov    %ecx,%eax
  8026a6:	89 fa                	mov    %edi,%edx
  8026a8:	83 c4 10             	add    $0x10,%esp
  8026ab:	5e                   	pop    %esi
  8026ac:	5f                   	pop    %edi
  8026ad:	5d                   	pop    %ebp
  8026ae:	c3                   	ret    
  8026af:	90                   	nop
  8026b0:	89 d1                	mov    %edx,%ecx
  8026b2:	89 fa                	mov    %edi,%edx
  8026b4:	89 c8                	mov    %ecx,%eax
  8026b6:	31 ff                	xor    %edi,%edi
  8026b8:	f7 f6                	div    %esi
  8026ba:	89 c1                	mov    %eax,%ecx
  8026bc:	89 fa                	mov    %edi,%edx
  8026be:	89 c8                	mov    %ecx,%eax
  8026c0:	83 c4 10             	add    $0x10,%esp
  8026c3:	5e                   	pop    %esi
  8026c4:	5f                   	pop    %edi
  8026c5:	5d                   	pop    %ebp
  8026c6:	c3                   	ret    
  8026c7:	90                   	nop
  8026c8:	0f b6 4d f4          	movzbl -0xc(%ebp),%ecx
  8026cc:	89 f2                	mov    %esi,%edx
  8026ce:	d3 e0                	shl    %cl,%eax
  8026d0:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8026d3:	b8 20 00 00 00       	mov    $0x20,%eax
  8026d8:	2b 45 f4             	sub    -0xc(%ebp),%eax
  8026db:	89 c1                	mov    %eax,%ecx
  8026dd:	d3 ea                	shr    %cl,%edx
  8026df:	0f b6 4d f4          	movzbl -0xc(%ebp),%ecx
  8026e3:	0b 55 ec             	or     -0x14(%ebp),%edx
  8026e6:	d3 e6                	shl    %cl,%esi
  8026e8:	89 c1                	mov    %eax,%ecx
  8026ea:	89 75 e8             	mov    %esi,-0x18(%ebp)
  8026ed:	89 fe                	mov    %edi,%esi
  8026ef:	d3 ee                	shr    %cl,%esi
  8026f1:	0f b6 4d f4          	movzbl -0xc(%ebp),%ecx
  8026f5:	89 55 ec             	mov    %edx,-0x14(%ebp)
  8026f8:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8026fb:	d3 e7                	shl    %cl,%edi
  8026fd:	89 c1                	mov    %eax,%ecx
  8026ff:	d3 ea                	shr    %cl,%edx
  802701:	09 d7                	or     %edx,%edi
  802703:	89 f2                	mov    %esi,%edx
  802705:	89 f8                	mov    %edi,%eax
  802707:	f7 75 ec             	divl   -0x14(%ebp)
  80270a:	89 d6                	mov    %edx,%esi
  80270c:	89 c7                	mov    %eax,%edi
  80270e:	f7 65 e8             	mull   -0x18(%ebp)
  802711:	39 d6                	cmp    %edx,%esi
  802713:	89 55 ec             	mov    %edx,-0x14(%ebp)
  802716:	72 30                	jb     802748 <__udivdi3+0x118>
  802718:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80271b:	0f b6 4d f4          	movzbl -0xc(%ebp),%ecx
  80271f:	d3 e2                	shl    %cl,%edx
  802721:	39 c2                	cmp    %eax,%edx
  802723:	73 05                	jae    80272a <__udivdi3+0xfa>
  802725:	3b 75 ec             	cmp    -0x14(%ebp),%esi
  802728:	74 1e                	je     802748 <__udivdi3+0x118>
  80272a:	89 f9                	mov    %edi,%ecx
  80272c:	31 ff                	xor    %edi,%edi
  80272e:	e9 71 ff ff ff       	jmp    8026a4 <__udivdi3+0x74>
  802733:	90                   	nop
  802734:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802738:	31 ff                	xor    %edi,%edi
  80273a:	b9 01 00 00 00       	mov    $0x1,%ecx
  80273f:	e9 60 ff ff ff       	jmp    8026a4 <__udivdi3+0x74>
  802744:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802748:	8d 4f ff             	lea    -0x1(%edi),%ecx
  80274b:	31 ff                	xor    %edi,%edi
  80274d:	89 c8                	mov    %ecx,%eax
  80274f:	89 fa                	mov    %edi,%edx
  802751:	83 c4 10             	add    $0x10,%esp
  802754:	5e                   	pop    %esi
  802755:	5f                   	pop    %edi
  802756:	5d                   	pop    %ebp
  802757:	c3                   	ret    
	...

00802760 <__umoddi3>:
  802760:	55                   	push   %ebp
  802761:	89 e5                	mov    %esp,%ebp
  802763:	57                   	push   %edi
  802764:	56                   	push   %esi
  802765:	83 ec 20             	sub    $0x20,%esp
  802768:	8b 55 14             	mov    0x14(%ebp),%edx
  80276b:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80276e:	8b 7d 10             	mov    0x10(%ebp),%edi
  802771:	8b 75 0c             	mov    0xc(%ebp),%esi
  802774:	85 d2                	test   %edx,%edx
  802776:	89 c8                	mov    %ecx,%eax
  802778:	89 4d f4             	mov    %ecx,-0xc(%ebp)
  80277b:	75 13                	jne    802790 <__umoddi3+0x30>
  80277d:	39 f7                	cmp    %esi,%edi
  80277f:	76 3f                	jbe    8027c0 <__umoddi3+0x60>
  802781:	89 f2                	mov    %esi,%edx
  802783:	f7 f7                	div    %edi
  802785:	89 d0                	mov    %edx,%eax
  802787:	31 d2                	xor    %edx,%edx
  802789:	83 c4 20             	add    $0x20,%esp
  80278c:	5e                   	pop    %esi
  80278d:	5f                   	pop    %edi
  80278e:	5d                   	pop    %ebp
  80278f:	c3                   	ret    
  802790:	39 f2                	cmp    %esi,%edx
  802792:	77 4c                	ja     8027e0 <__umoddi3+0x80>
  802794:	0f bd ca             	bsr    %edx,%ecx
  802797:	83 f1 1f             	xor    $0x1f,%ecx
  80279a:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  80279d:	75 51                	jne    8027f0 <__umoddi3+0x90>
  80279f:	3b 7d f4             	cmp    -0xc(%ebp),%edi
  8027a2:	0f 87 e0 00 00 00    	ja     802888 <__umoddi3+0x128>
  8027a8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027ab:	29 f8                	sub    %edi,%eax
  8027ad:	19 d6                	sbb    %edx,%esi
  8027af:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8027b2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027b5:	89 f2                	mov    %esi,%edx
  8027b7:	83 c4 20             	add    $0x20,%esp
  8027ba:	5e                   	pop    %esi
  8027bb:	5f                   	pop    %edi
  8027bc:	5d                   	pop    %ebp
  8027bd:	c3                   	ret    
  8027be:	66 90                	xchg   %ax,%ax
  8027c0:	85 ff                	test   %edi,%edi
  8027c2:	75 0b                	jne    8027cf <__umoddi3+0x6f>
  8027c4:	b8 01 00 00 00       	mov    $0x1,%eax
  8027c9:	31 d2                	xor    %edx,%edx
  8027cb:	f7 f7                	div    %edi
  8027cd:	89 c7                	mov    %eax,%edi
  8027cf:	89 f0                	mov    %esi,%eax
  8027d1:	31 d2                	xor    %edx,%edx
  8027d3:	f7 f7                	div    %edi
  8027d5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027d8:	f7 f7                	div    %edi
  8027da:	eb a9                	jmp    802785 <__umoddi3+0x25>
  8027dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  8027e0:	89 c8                	mov    %ecx,%eax
  8027e2:	89 f2                	mov    %esi,%edx
  8027e4:	83 c4 20             	add    $0x20,%esp
  8027e7:	5e                   	pop    %esi
  8027e8:	5f                   	pop    %edi
  8027e9:	5d                   	pop    %ebp
  8027ea:	c3                   	ret    
  8027eb:	90                   	nop
  8027ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  8027f0:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
  8027f4:	d3 e2                	shl    %cl,%edx
  8027f6:	89 55 f4             	mov    %edx,-0xc(%ebp)
  8027f9:	ba 20 00 00 00       	mov    $0x20,%edx
  8027fe:	2b 55 f0             	sub    -0x10(%ebp),%edx
  802801:	89 55 ec             	mov    %edx,-0x14(%ebp)
  802804:	0f b6 4d ec          	movzbl -0x14(%ebp),%ecx
  802808:	89 fa                	mov    %edi,%edx
  80280a:	d3 ea                	shr    %cl,%edx
  80280c:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
  802810:	0b 55 f4             	or     -0xc(%ebp),%edx
  802813:	d3 e7                	shl    %cl,%edi
  802815:	0f b6 4d ec          	movzbl -0x14(%ebp),%ecx
  802819:	89 55 f4             	mov    %edx,-0xc(%ebp)
  80281c:	89 f2                	mov    %esi,%edx
  80281e:	89 7d e8             	mov    %edi,-0x18(%ebp)
  802821:	89 c7                	mov    %eax,%edi
  802823:	d3 ea                	shr    %cl,%edx
  802825:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
  802829:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  80282c:	89 c2                	mov    %eax,%edx
  80282e:	d3 e6                	shl    %cl,%esi
  802830:	0f b6 4d ec          	movzbl -0x14(%ebp),%ecx
  802834:	d3 ea                	shr    %cl,%edx
  802836:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
  80283a:	09 d6                	or     %edx,%esi
  80283c:	89 f0                	mov    %esi,%eax
  80283e:	8b 75 e4             	mov    -0x1c(%ebp),%esi
  802841:	d3 e7                	shl    %cl,%edi
  802843:	89 f2                	mov    %esi,%edx
  802845:	f7 75 f4             	divl   -0xc(%ebp)
  802848:	89 d6                	mov    %edx,%esi
  80284a:	f7 65 e8             	mull   -0x18(%ebp)
  80284d:	39 d6                	cmp    %edx,%esi
  80284f:	72 2b                	jb     80287c <__umoddi3+0x11c>
  802851:	39 c7                	cmp    %eax,%edi
  802853:	72 23                	jb     802878 <__umoddi3+0x118>
  802855:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
  802859:	29 c7                	sub    %eax,%edi
  80285b:	19 d6                	sbb    %edx,%esi
  80285d:	89 f0                	mov    %esi,%eax
  80285f:	89 f2                	mov    %esi,%edx
  802861:	d3 ef                	shr    %cl,%edi
  802863:	0f b6 4d ec          	movzbl -0x14(%ebp),%ecx
  802867:	d3 e0                	shl    %cl,%eax
  802869:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
  80286d:	09 f8                	or     %edi,%eax
  80286f:	d3 ea                	shr    %cl,%edx
  802871:	83 c4 20             	add    $0x20,%esp
  802874:	5e                   	pop    %esi
  802875:	5f                   	pop    %edi
  802876:	5d                   	pop    %ebp
  802877:	c3                   	ret    
  802878:	39 d6                	cmp    %edx,%esi
  80287a:	75 d9                	jne    802855 <__umoddi3+0xf5>
  80287c:	2b 45 e8             	sub    -0x18(%ebp),%eax
  80287f:	1b 55 f4             	sbb    -0xc(%ebp),%edx
  802882:	eb d1                	jmp    802855 <__umoddi3+0xf5>
  802884:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802888:	39 f2                	cmp    %esi,%edx
  80288a:	0f 82 18 ff ff ff    	jb     8027a8 <__umoddi3+0x48>
  802890:	e9 1d ff ff ff       	jmp    8027b2 <__umoddi3+0x52>
