
obj/user/ls:     file format elf32-i386


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
  80002c:	e8 6b 03 00 00       	call   80039c <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>
	...

00800040 <usage>:
	printf("\n");
}

void
usage(void)
{
  800040:	55                   	push   %ebp
  800041:	89 e5                	mov    %esp,%ebp
  800043:	83 ec 18             	sub    $0x18,%esp
	printf("usage: ls [-dFl] [file...]\n");
  800046:	c7 04 24 80 2c 80 00 	movl   $0x802c80,(%esp)
  80004d:	e8 a1 1d 00 00       	call   801df3 <printf>
	exit();
  800052:	e8 95 03 00 00       	call   8003ec <exit>
}
  800057:	c9                   	leave  
  800058:	c3                   	ret    

00800059 <ls1>:
		panic("error reading directory %s: %e", path, n);
}

void
ls1(const char *prefix, bool isdir, off_t size, const char *name)
{
  800059:	55                   	push   %ebp
  80005a:	89 e5                	mov    %esp,%ebp
  80005c:	56                   	push   %esi
  80005d:	53                   	push   %ebx
  80005e:	83 ec 10             	sub    $0x10,%esp
  800061:	8b 5d 08             	mov    0x8(%ebp),%ebx
  800064:	8b 75 0c             	mov    0xc(%ebp),%esi
	char *sep;

	if(flag['l'])
  800067:	83 3d 30 72 80 00 00 	cmpl   $0x0,0x807230
  80006e:	74 22                	je     800092 <ls1+0x39>
		printf("%11d %c ", size, isdir ? 'd' : '-');
  800070:	83 fe 01             	cmp    $0x1,%esi
  800073:	19 c0                	sbb    %eax,%eax
  800075:	83 e0 c9             	and    $0xffffffc9,%eax
  800078:	83 c0 64             	add    $0x64,%eax
  80007b:	89 44 24 08          	mov    %eax,0x8(%esp)
  80007f:	8b 45 10             	mov    0x10(%ebp),%eax
  800082:	89 44 24 04          	mov    %eax,0x4(%esp)
  800086:	c7 04 24 9c 2c 80 00 	movl   $0x802c9c,(%esp)
  80008d:	e8 61 1d 00 00       	call   801df3 <printf>
	if(prefix) {
  800092:	85 db                	test   %ebx,%ebx
  800094:	74 34                	je     8000ca <ls1+0x71>
		if (prefix[0] && prefix[strlen(prefix)-1] != '/')
  800096:	80 3b 00             	cmpb   $0x0,(%ebx)
  800099:	74 16                	je     8000b1 <ls1+0x58>
  80009b:	89 1c 24             	mov    %ebx,(%esp)
  80009e:	66 90                	xchg   %ax,%ax
  8000a0:	e8 9b 0a 00 00       	call   800b40 <strlen>
  8000a5:	ba a5 2c 80 00       	mov    $0x802ca5,%edx
  8000aa:	80 7c 03 ff 2f       	cmpb   $0x2f,-0x1(%ebx,%eax,1)
  8000af:	75 05                	jne    8000b6 <ls1+0x5d>
  8000b1:	ba 9b 2c 80 00       	mov    $0x802c9b,%edx
			sep = "/";
		else
			sep = "";
		printf("%s%s", prefix, sep);
  8000b6:	89 54 24 08          	mov    %edx,0x8(%esp)
  8000ba:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8000be:	c7 04 24 a7 2c 80 00 	movl   $0x802ca7,(%esp)
  8000c5:	e8 29 1d 00 00       	call   801df3 <printf>
	}
	printf("%s", name);
  8000ca:	8b 45 14             	mov    0x14(%ebp),%eax
  8000cd:	89 44 24 04          	mov    %eax,0x4(%esp)
  8000d1:	c7 04 24 26 31 80 00 	movl   $0x803126,(%esp)
  8000d8:	e8 16 1d 00 00       	call   801df3 <printf>
	if(flag['F'] && isdir)
  8000dd:	83 3d 98 71 80 00 00 	cmpl   $0x0,0x807198
  8000e4:	74 10                	je     8000f6 <ls1+0x9d>
  8000e6:	85 f6                	test   %esi,%esi
  8000e8:	74 0c                	je     8000f6 <ls1+0x9d>
		printf("/");
  8000ea:	c7 04 24 a5 2c 80 00 	movl   $0x802ca5,(%esp)
  8000f1:	e8 fd 1c 00 00       	call   801df3 <printf>
	printf("\n");
  8000f6:	c7 04 24 9a 2c 80 00 	movl   $0x802c9a,(%esp)
  8000fd:	e8 f1 1c 00 00       	call   801df3 <printf>
}
  800102:	83 c4 10             	add    $0x10,%esp
  800105:	5b                   	pop    %ebx
  800106:	5e                   	pop    %esi
  800107:	5d                   	pop    %ebp
  800108:	c3                   	ret    

00800109 <lsdir>:
		ls1(0, st.st_isdir, st.st_size, path);
}

void
lsdir(const char *path, const char *prefix)
{
  800109:	55                   	push   %ebp
  80010a:	89 e5                	mov    %esp,%ebp
  80010c:	57                   	push   %edi
  80010d:	56                   	push   %esi
  80010e:	53                   	push   %ebx
  80010f:	81 ec 2c 01 00 00    	sub    $0x12c,%esp
  800115:	8b 7d 0c             	mov    0xc(%ebp),%edi
	int fd, n;
	struct File f;

	if ((fd = open(path, O_RDONLY)) < 0)
  800118:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  80011f:	00 
  800120:	8b 45 08             	mov    0x8(%ebp),%eax
  800123:	89 04 24             	mov    %eax,(%esp)
  800126:	e8 78 1b 00 00       	call   801ca3 <open>
  80012b:	89 c6                	mov    %eax,%esi
  80012d:	85 c0                	test   %eax,%eax
  80012f:	79 59                	jns    80018a <lsdir+0x81>
		panic("open %s: %e", path, fd);
  800131:	89 44 24 10          	mov    %eax,0x10(%esp)
  800135:	8b 45 08             	mov    0x8(%ebp),%eax
  800138:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80013c:	c7 44 24 08 ac 2c 80 	movl   $0x802cac,0x8(%esp)
  800143:	00 
  800144:	c7 44 24 04 1d 00 00 	movl   $0x1d,0x4(%esp)
  80014b:	00 
  80014c:	c7 04 24 b8 2c 80 00 	movl   $0x802cb8,(%esp)
  800153:	e8 b0 02 00 00       	call   800408 <_panic>
	while ((n = readn(fd, &f, sizeof f)) == sizeof f)
		if (f.f_name[0])
  800158:	80 bd e8 fe ff ff 00 	cmpb   $0x0,-0x118(%ebp)
  80015f:	74 2f                	je     800190 <lsdir+0x87>
			ls1(prefix, f.f_type==FTYPE_DIR, f.f_size, f.f_name);
  800161:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  800165:	8b 85 68 ff ff ff    	mov    -0x98(%ebp),%eax
  80016b:	89 44 24 08          	mov    %eax,0x8(%esp)
  80016f:	83 bd 6c ff ff ff 01 	cmpl   $0x1,-0x94(%ebp)
  800176:	0f 94 c0             	sete   %al
  800179:	0f b6 c0             	movzbl %al,%eax
  80017c:	89 44 24 04          	mov    %eax,0x4(%esp)
  800180:	89 3c 24             	mov    %edi,(%esp)
  800183:	e8 d1 fe ff ff       	call   800059 <ls1>
  800188:	eb 06                	jmp    800190 <lsdir+0x87>
	int fd, n;
	struct File f;

	if ((fd = open(path, O_RDONLY)) < 0)
		panic("open %s: %e", path, fd);
	while ((n = readn(fd, &f, sizeof f)) == sizeof f)
  80018a:	8d 9d e8 fe ff ff    	lea    -0x118(%ebp),%ebx
  800190:	c7 44 24 08 00 01 00 	movl   $0x100,0x8(%esp)
  800197:	00 
  800198:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  80019c:	89 34 24             	mov    %esi,(%esp)
  80019f:	e8 88 16 00 00       	call   80182c <readn>
  8001a4:	3d 00 01 00 00       	cmp    $0x100,%eax
  8001a9:	74 ad                	je     800158 <lsdir+0x4f>
		if (f.f_name[0])
			ls1(prefix, f.f_type==FTYPE_DIR, f.f_size, f.f_name);
	if (n > 0)
  8001ab:	85 c0                	test   %eax,%eax
  8001ad:	7e 23                	jle    8001d2 <lsdir+0xc9>
		panic("short read in directory %s", path);
  8001af:	8b 45 08             	mov    0x8(%ebp),%eax
  8001b2:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8001b6:	c7 44 24 08 c2 2c 80 	movl   $0x802cc2,0x8(%esp)
  8001bd:	00 
  8001be:	c7 44 24 04 22 00 00 	movl   $0x22,0x4(%esp)
  8001c5:	00 
  8001c6:	c7 04 24 b8 2c 80 00 	movl   $0x802cb8,(%esp)
  8001cd:	e8 36 02 00 00       	call   800408 <_panic>
	if (n < 0)
  8001d2:	85 c0                	test   %eax,%eax
  8001d4:	79 27                	jns    8001fd <lsdir+0xf4>
		panic("error reading directory %s: %e", path, n);
  8001d6:	89 44 24 10          	mov    %eax,0x10(%esp)
  8001da:	8b 45 08             	mov    0x8(%ebp),%eax
  8001dd:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8001e1:	c7 44 24 08 ec 2c 80 	movl   $0x802cec,0x8(%esp)
  8001e8:	00 
  8001e9:	c7 44 24 04 24 00 00 	movl   $0x24,0x4(%esp)
  8001f0:	00 
  8001f1:	c7 04 24 b8 2c 80 00 	movl   $0x802cb8,(%esp)
  8001f8:	e8 0b 02 00 00       	call   800408 <_panic>
}
  8001fd:	81 c4 2c 01 00 00    	add    $0x12c,%esp
  800203:	5b                   	pop    %ebx
  800204:	5e                   	pop    %esi
  800205:	5f                   	pop    %edi
  800206:	5d                   	pop    %ebp
  800207:	c3                   	ret    

00800208 <ls>:
void lsdir(const char*, const char*);
void ls1(const char*, bool, off_t, const char*);

void
ls(const char *path, const char *prefix)
{
  800208:	55                   	push   %ebp
  800209:	89 e5                	mov    %esp,%ebp
  80020b:	53                   	push   %ebx
  80020c:	81 ec b4 00 00 00    	sub    $0xb4,%esp
  800212:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Stat st;

	if ((r = stat(path, &st)) < 0)
  800215:	8d 85 6c ff ff ff    	lea    -0x94(%ebp),%eax
  80021b:	89 44 24 04          	mov    %eax,0x4(%esp)
  80021f:	89 1c 24             	mov    %ebx,(%esp)
  800222:	e8 08 17 00 00       	call   80192f <stat>
  800227:	85 c0                	test   %eax,%eax
  800229:	79 24                	jns    80024f <ls+0x47>
		panic("stat %s: %e", path, r);
  80022b:	89 44 24 10          	mov    %eax,0x10(%esp)
  80022f:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  800233:	c7 44 24 08 dd 2c 80 	movl   $0x802cdd,0x8(%esp)
  80023a:	00 
  80023b:	c7 44 24 04 0f 00 00 	movl   $0xf,0x4(%esp)
  800242:	00 
  800243:	c7 04 24 b8 2c 80 00 	movl   $0x802cb8,(%esp)
  80024a:	e8 b9 01 00 00       	call   800408 <_panic>
	if (st.st_isdir && !flag['d'])
  80024f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800252:	85 c0                	test   %eax,%eax
  800254:	74 1a                	je     800270 <ls+0x68>
  800256:	83 3d 10 72 80 00 00 	cmpl   $0x0,0x807210
  80025d:	75 11                	jne    800270 <ls+0x68>
		lsdir(path, prefix);
  80025f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800262:	89 44 24 04          	mov    %eax,0x4(%esp)
  800266:	89 1c 24             	mov    %ebx,(%esp)
  800269:	e8 9b fe ff ff       	call   800109 <lsdir>
	int r;
	struct Stat st;

	if ((r = stat(path, &st)) < 0)
		panic("stat %s: %e", path, r);
	if (st.st_isdir && !flag['d'])
  80026e:	eb 1b                	jmp    80028b <ls+0x83>
		lsdir(path, prefix);
	else
		ls1(0, st.st_isdir, st.st_size, path);
  800270:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  800274:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800277:	89 54 24 08          	mov    %edx,0x8(%esp)
  80027b:	89 44 24 04          	mov    %eax,0x4(%esp)
  80027f:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  800286:	e8 ce fd ff ff       	call   800059 <ls1>
}
  80028b:	81 c4 b4 00 00 00    	add    $0xb4,%esp
  800291:	5b                   	pop    %ebx
  800292:	5d                   	pop    %ebp
  800293:	c3                   	ret    

00800294 <umain>:
	exit();
}

void
umain(int argc, char **argv)
{
  800294:	55                   	push   %ebp
  800295:	89 e5                	mov    %esp,%ebp
  800297:	57                   	push   %edi
  800298:	56                   	push   %esi
  800299:	53                   	push   %ebx
  80029a:	83 ec 2c             	sub    $0x2c,%esp
  80029d:	8b 45 0c             	mov    0xc(%ebp),%eax
	int i;

	ARGBEGIN{
  8002a0:	85 c0                	test   %eax,%eax
  8002a2:	75 03                	jne    8002a7 <umain+0x13>
  8002a4:	8d 45 08             	lea    0x8(%ebp),%eax
  8002a7:	83 3d 84 74 80 00 00 	cmpl   $0x0,0x807484
  8002ae:	75 08                	jne    8002b8 <umain+0x24>
  8002b0:	8b 10                	mov    (%eax),%edx
  8002b2:	89 15 84 74 80 00    	mov    %edx,0x807484
  8002b8:	83 c0 04             	add    $0x4,%eax
  8002bb:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8002be:	83 6d 08 01          	subl   $0x1,0x8(%ebp)
  8002c2:	8b 30                	mov    (%eax),%esi
  8002c4:	85 f6                	test   %esi,%esi
  8002c6:	0f 84 84 00 00 00    	je     800350 <umain+0xbc>
  8002cc:	80 3e 2d             	cmpb   $0x2d,(%esi)
  8002cf:	75 7f                	jne    800350 <umain+0xbc>
  8002d1:	83 c6 01             	add    $0x1,%esi
  8002d4:	0f b6 06             	movzbl (%esi),%eax
  8002d7:	84 c0                	test   %al,%al
  8002d9:	74 75                	je     800350 <umain+0xbc>
	default:
		usage();
	case 'd':
	case 'F':
	case 'l':
		flag[(uint8_t)ARGC()]++;
  8002db:	bf 80 70 80 00       	mov    $0x807080,%edi
void
umain(int argc, char **argv)
{
	int i;

	ARGBEGIN{
  8002e0:	3c 2d                	cmp    $0x2d,%al
  8002e2:	74 0c                	je     8002f0 <umain+0x5c>
  8002e4:	0f b6 1e             	movzbl (%esi),%ebx
  8002e7:	84 db                	test   %bl,%bl
  8002e9:	74 45                	je     800330 <umain+0x9c>
  8002eb:	83 c6 01             	add    $0x1,%esi
  8002ee:	eb 12                	jmp    800302 <umain+0x6e>
  8002f0:	80 7e 01 00          	cmpb   $0x0,0x1(%esi)
  8002f4:	75 ee                	jne    8002e4 <umain+0x50>
  8002f6:	83 6d 08 01          	subl   $0x1,0x8(%ebp)
  8002fa:	83 45 e4 04          	addl   $0x4,-0x1c(%ebp)
  8002fe:	66 90                	xchg   %ax,%ax
  800300:	eb 4e                	jmp    800350 <umain+0xbc>
  800302:	80 fb 64             	cmp    $0x64,%bl
  800305:	74 16                	je     80031d <umain+0x89>
  800307:	80 fb 6c             	cmp    $0x6c,%bl
  80030a:	74 11                	je     80031d <umain+0x89>
  80030c:	80 fb 46             	cmp    $0x46,%bl
  80030f:	90                   	nop
  800310:	74 0b                	je     80031d <umain+0x89>
	default:
		usage();
  800312:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  800318:	e8 23 fd ff ff       	call   800040 <usage>
	case 'd':
	case 'F':
	case 'l':
		flag[(uint8_t)ARGC()]++;
  80031d:	0f b6 db             	movzbl %bl,%ebx
  800320:	83 04 9f 01          	addl   $0x1,(%edi,%ebx,4)
void
umain(int argc, char **argv)
{
	int i;

	ARGBEGIN{
  800324:	0f b6 1e             	movzbl (%esi),%ebx
  800327:	84 db                	test   %bl,%bl
  800329:	74 05                	je     800330 <umain+0x9c>
  80032b:	83 c6 01             	add    $0x1,%esi
  80032e:	eb d2                	jmp    800302 <umain+0x6e>
  800330:	83 6d 08 01          	subl   $0x1,0x8(%ebp)
  800334:	83 45 e4 04          	addl   $0x4,-0x1c(%ebp)
  800338:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80033b:	8b 30                	mov    (%eax),%esi
  80033d:	85 f6                	test   %esi,%esi
  80033f:	74 0f                	je     800350 <umain+0xbc>
  800341:	80 3e 2d             	cmpb   $0x2d,(%esi)
  800344:	75 0a                	jne    800350 <umain+0xbc>
  800346:	83 c6 01             	add    $0x1,%esi
  800349:	0f b6 06             	movzbl (%esi),%eax
  80034c:	84 c0                	test   %al,%al
  80034e:	75 90                	jne    8002e0 <umain+0x4c>
	case 'l':
		flag[(uint8_t)ARGC()]++;
		break;
	}ARGEND

	if (argc == 0)
  800350:	8b 45 08             	mov    0x8(%ebp),%eax
  800353:	85 c0                	test   %eax,%eax
  800355:	74 0b                	je     800362 <umain+0xce>
		ls("/", "");
  800357:	bb 00 00 00 00       	mov    $0x0,%ebx
	else {
		for (i=0; i<argc; i++)
  80035c:	85 c0                	test   %eax,%eax
  80035e:	7f 18                	jg     800378 <umain+0xe4>
  800360:	eb 30                	jmp    800392 <umain+0xfe>
		flag[(uint8_t)ARGC()]++;
		break;
	}ARGEND

	if (argc == 0)
		ls("/", "");
  800362:	c7 44 24 04 9b 2c 80 	movl   $0x802c9b,0x4(%esp)
  800369:	00 
  80036a:	c7 04 24 a5 2c 80 00 	movl   $0x802ca5,(%esp)
  800371:	e8 92 fe ff ff       	call   800208 <ls>
  800376:	eb 1a                	jmp    800392 <umain+0xfe>
	else {
		for (i=0; i<argc; i++)
			ls(argv[i], argv[i]);
  800378:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80037b:	8b 04 9a             	mov    (%edx,%ebx,4),%eax
  80037e:	89 44 24 04          	mov    %eax,0x4(%esp)
  800382:	89 04 24             	mov    %eax,(%esp)
  800385:	e8 7e fe ff ff       	call   800208 <ls>
	}ARGEND

	if (argc == 0)
		ls("/", "");
	else {
		for (i=0; i<argc; i++)
  80038a:	83 c3 01             	add    $0x1,%ebx
  80038d:	39 5d 08             	cmp    %ebx,0x8(%ebp)
  800390:	7f e6                	jg     800378 <umain+0xe4>
			ls(argv[i], argv[i]);
	}
}
  800392:	83 c4 2c             	add    $0x2c,%esp
  800395:	5b                   	pop    %ebx
  800396:	5e                   	pop    %esi
  800397:	5f                   	pop    %edi
  800398:	5d                   	pop    %ebp
  800399:	c3                   	ret    
	...

0080039c <libmain>:
volatile struct Env *env;
char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  80039c:	55                   	push   %ebp
  80039d:	89 e5                	mov    %esp,%ebp
  80039f:	83 ec 18             	sub    $0x18,%esp
  8003a2:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  8003a5:	89 75 fc             	mov    %esi,-0x4(%ebp)
  8003a8:	8b 75 08             	mov    0x8(%ebp),%esi
  8003ab:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	// set env to point at our env structure in envs[].
	// LAB 3b: Your code here.
	// Code added by Swastika / Sandeep	
	envid_t envid = sys_getenvid();
  8003ae:	e8 5b 10 00 00       	call   80140e <sys_getenvid>
	env = &envs[ENVX(envid)];
  8003b3:	25 ff 03 00 00       	and    $0x3ff,%eax
  8003b8:	6b c0 7c             	imul   $0x7c,%eax,%eax
  8003bb:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8003c0:	a3 80 74 80 00       	mov    %eax,0x807480

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8003c5:	85 f6                	test   %esi,%esi
  8003c7:	7e 07                	jle    8003d0 <libmain+0x34>
		binaryname = argv[0];
  8003c9:	8b 03                	mov    (%ebx),%eax
  8003cb:	a3 00 70 80 00       	mov    %eax,0x807000

	// call user main routine
	umain(argc, argv);
  8003d0:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8003d4:	89 34 24             	mov    %esi,(%esp)
  8003d7:	e8 b8 fe ff ff       	call   800294 <umain>

	// exit gracefully
	exit();
  8003dc:	e8 0b 00 00 00       	call   8003ec <exit>
}
  8003e1:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  8003e4:	8b 75 fc             	mov    -0x4(%ebp),%esi
  8003e7:	89 ec                	mov    %ebp,%esp
  8003e9:	5d                   	pop    %ebp
  8003ea:	c3                   	ret    
	...

008003ec <exit>:
#include <inc/lib.h>

void
exit(void)
{
  8003ec:	55                   	push   %ebp
  8003ed:	89 e5                	mov    %esp,%ebp
  8003ef:	83 ec 18             	sub    $0x18,%esp
	close_all();
  8003f2:	e8 84 15 00 00       	call   80197b <close_all>
	sys_env_destroy(0);
  8003f7:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8003fe:	e8 3f 10 00 00       	call   801442 <sys_env_destroy>
}
  800403:	c9                   	leave  
  800404:	c3                   	ret    
  800405:	00 00                	add    %al,(%eax)
	...

00800408 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  800408:	55                   	push   %ebp
  800409:	89 e5                	mov    %esp,%ebp
  80040b:	53                   	push   %ebx
  80040c:	83 ec 14             	sub    $0x14,%esp
 * Panic is called on unresolvable fatal errors.
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
  80040f:	8d 5d 14             	lea    0x14(%ebp),%ebx
	va_list ap;

	va_start(ap, fmt);

	// Print the panic message
	if (argv0)
  800412:	a1 84 74 80 00       	mov    0x807484,%eax
  800417:	85 c0                	test   %eax,%eax
  800419:	74 10                	je     80042b <_panic+0x23>
		cprintf("%s: ", argv0);
  80041b:	89 44 24 04          	mov    %eax,0x4(%esp)
  80041f:	c7 04 24 22 2d 80 00 	movl   $0x802d22,(%esp)
  800426:	e8 a2 00 00 00       	call   8004cd <cprintf>
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  80042b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80042e:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800432:	8b 45 08             	mov    0x8(%ebp),%eax
  800435:	89 44 24 08          	mov    %eax,0x8(%esp)
  800439:	a1 00 70 80 00       	mov    0x807000,%eax
  80043e:	89 44 24 04          	mov    %eax,0x4(%esp)
  800442:	c7 04 24 27 2d 80 00 	movl   $0x802d27,(%esp)
  800449:	e8 7f 00 00 00       	call   8004cd <cprintf>
	vcprintf(fmt, ap);
  80044e:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  800452:	8b 45 10             	mov    0x10(%ebp),%eax
  800455:	89 04 24             	mov    %eax,(%esp)
  800458:	e8 0f 00 00 00       	call   80046c <vcprintf>
	cprintf("\n");
  80045d:	c7 04 24 9a 2c 80 00 	movl   $0x802c9a,(%esp)
  800464:	e8 64 00 00 00       	call   8004cd <cprintf>

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  800469:	cc                   	int3   
  80046a:	eb fd                	jmp    800469 <_panic+0x61>

0080046c <vcprintf>:
	b->cnt++;
}

int
vcprintf(const char *fmt, va_list ap)
{
  80046c:	55                   	push   %ebp
  80046d:	89 e5                	mov    %esp,%ebp
  80046f:	81 ec 28 01 00 00    	sub    $0x128,%esp
	struct printbuf b;

	b.idx = 0;
  800475:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  80047c:	00 00 00 
	b.cnt = 0;
  80047f:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800486:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  800489:	8b 45 0c             	mov    0xc(%ebp),%eax
  80048c:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800490:	8b 45 08             	mov    0x8(%ebp),%eax
  800493:	89 44 24 08          	mov    %eax,0x8(%esp)
  800497:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80049d:	89 44 24 04          	mov    %eax,0x4(%esp)
  8004a1:	c7 04 24 e7 04 80 00 	movl   $0x8004e7,(%esp)
  8004a8:	e8 d0 01 00 00       	call   80067d <vprintfmt>
	sys_cputs(b.buf, b.idx);
  8004ad:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
  8004b3:	89 44 24 04          	mov    %eax,0x4(%esp)
  8004b7:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  8004bd:	89 04 24             	mov    %eax,(%esp)
  8004c0:	e8 bb 0a 00 00       	call   800f80 <sys_cputs>

	return b.cnt;
}
  8004c5:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  8004cb:	c9                   	leave  
  8004cc:	c3                   	ret    

008004cd <cprintf>:

int
cprintf(const char *fmt, ...)
{
  8004cd:	55                   	push   %ebp
  8004ce:	89 e5                	mov    %esp,%ebp
  8004d0:	83 ec 18             	sub    $0x18,%esp

	return b.cnt;
}

int
cprintf(const char *fmt, ...)
  8004d3:	8d 45 0c             	lea    0xc(%ebp),%eax
{
	va_list ap;
	int cnt;

	va_start(ap, fmt);
	cnt = vcprintf(fmt, ap);
  8004d6:	89 44 24 04          	mov    %eax,0x4(%esp)
  8004da:	8b 45 08             	mov    0x8(%ebp),%eax
  8004dd:	89 04 24             	mov    %eax,(%esp)
  8004e0:	e8 87 ff ff ff       	call   80046c <vcprintf>
	va_end(ap);

	return cnt;
}
  8004e5:	c9                   	leave  
  8004e6:	c3                   	ret    

008004e7 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  8004e7:	55                   	push   %ebp
  8004e8:	89 e5                	mov    %esp,%ebp
  8004ea:	53                   	push   %ebx
  8004eb:	83 ec 14             	sub    $0x14,%esp
  8004ee:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  8004f1:	8b 03                	mov    (%ebx),%eax
  8004f3:	8b 55 08             	mov    0x8(%ebp),%edx
  8004f6:	88 54 03 08          	mov    %dl,0x8(%ebx,%eax,1)
  8004fa:	83 c0 01             	add    $0x1,%eax
  8004fd:	89 03                	mov    %eax,(%ebx)
	if (b->idx == 256-1) {
  8004ff:	3d ff 00 00 00       	cmp    $0xff,%eax
  800504:	75 19                	jne    80051f <putch+0x38>
		sys_cputs(b->buf, b->idx);
  800506:	c7 44 24 04 ff 00 00 	movl   $0xff,0x4(%esp)
  80050d:	00 
  80050e:	8d 43 08             	lea    0x8(%ebx),%eax
  800511:	89 04 24             	mov    %eax,(%esp)
  800514:	e8 67 0a 00 00       	call   800f80 <sys_cputs>
		b->idx = 0;
  800519:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
	}
	b->cnt++;
  80051f:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  800523:	83 c4 14             	add    $0x14,%esp
  800526:	5b                   	pop    %ebx
  800527:	5d                   	pop    %ebp
  800528:	c3                   	ret    
  800529:	00 00                	add    %al,(%eax)
  80052b:	00 00                	add    %al,(%eax)
  80052d:	00 00                	add    %al,(%eax)
	...

00800530 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800530:	55                   	push   %ebp
  800531:	89 e5                	mov    %esp,%ebp
  800533:	57                   	push   %edi
  800534:	56                   	push   %esi
  800535:	53                   	push   %ebx
  800536:	83 ec 4c             	sub    $0x4c,%esp
  800539:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80053c:	89 d6                	mov    %edx,%esi
  80053e:	8b 45 08             	mov    0x8(%ebp),%eax
  800541:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800544:	8b 55 0c             	mov    0xc(%ebp),%edx
  800547:	89 55 e0             	mov    %edx,-0x20(%ebp)
  80054a:	8b 45 10             	mov    0x10(%ebp),%eax
  80054d:	8b 5d 14             	mov    0x14(%ebp),%ebx
  800550:	8b 7d 18             	mov    0x18(%ebp),%edi
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800553:	89 45 dc             	mov    %eax,-0x24(%ebp)
  800556:	b9 00 00 00 00       	mov    $0x0,%ecx
  80055b:	39 d1                	cmp    %edx,%ecx
  80055d:	72 15                	jb     800574 <printnum+0x44>
  80055f:	77 07                	ja     800568 <printnum+0x38>
  800561:	8b 55 d8             	mov    -0x28(%ebp),%edx
  800564:	39 d0                	cmp    %edx,%eax
  800566:	76 0c                	jbe    800574 <printnum+0x44>
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800568:	83 eb 01             	sub    $0x1,%ebx
  80056b:	85 db                	test   %ebx,%ebx
  80056d:	8d 76 00             	lea    0x0(%esi),%esi
  800570:	7f 61                	jg     8005d3 <printnum+0xa3>
  800572:	eb 70                	jmp    8005e4 <printnum+0xb4>
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800574:	89 7c 24 10          	mov    %edi,0x10(%esp)
  800578:	83 eb 01             	sub    $0x1,%ebx
  80057b:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  80057f:	89 44 24 08          	mov    %eax,0x8(%esp)
  800583:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  800587:	8b 5c 24 0c          	mov    0xc(%esp),%ebx
  80058b:	89 4d d0             	mov    %ecx,-0x30(%ebp)
  80058e:	89 5d d4             	mov    %ebx,-0x2c(%ebp)
  800591:	8b 5d dc             	mov    -0x24(%ebp),%ebx
  800594:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  800598:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  80059f:	00 
  8005a0:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8005a3:	89 04 24             	mov    %eax,(%esp)
  8005a6:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8005a9:	89 54 24 04          	mov    %edx,0x4(%esp)
  8005ad:	e8 4e 24 00 00       	call   802a00 <__udivdi3>
  8005b2:	8b 4d d0             	mov    -0x30(%ebp),%ecx
  8005b5:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
  8005b8:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8005bc:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  8005c0:	89 04 24             	mov    %eax,(%esp)
  8005c3:	89 54 24 04          	mov    %edx,0x4(%esp)
  8005c7:	89 f2                	mov    %esi,%edx
  8005c9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8005cc:	e8 5f ff ff ff       	call   800530 <printnum>
  8005d1:	eb 11                	jmp    8005e4 <printnum+0xb4>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  8005d3:	89 74 24 04          	mov    %esi,0x4(%esp)
  8005d7:	89 3c 24             	mov    %edi,(%esp)
  8005da:	ff 55 e4             	call   *-0x1c(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8005dd:	83 eb 01             	sub    $0x1,%ebx
  8005e0:	85 db                	test   %ebx,%ebx
  8005e2:	7f ef                	jg     8005d3 <printnum+0xa3>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8005e4:	89 74 24 04          	mov    %esi,0x4(%esp)
  8005e8:	8b 74 24 04          	mov    0x4(%esp),%esi
  8005ec:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8005ef:	89 44 24 08          	mov    %eax,0x8(%esp)
  8005f3:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  8005fa:	00 
  8005fb:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8005fe:	89 14 24             	mov    %edx,(%esp)
  800601:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  800604:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  800608:	e8 23 25 00 00       	call   802b30 <__umoddi3>
  80060d:	89 74 24 04          	mov    %esi,0x4(%esp)
  800611:	0f be 80 43 2d 80 00 	movsbl 0x802d43(%eax),%eax
  800618:	89 04 24             	mov    %eax,(%esp)
  80061b:	ff 55 e4             	call   *-0x1c(%ebp)
}
  80061e:	83 c4 4c             	add    $0x4c,%esp
  800621:	5b                   	pop    %ebx
  800622:	5e                   	pop    %esi
  800623:	5f                   	pop    %edi
  800624:	5d                   	pop    %ebp
  800625:	c3                   	ret    

00800626 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800626:	55                   	push   %ebp
  800627:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800629:	83 fa 01             	cmp    $0x1,%edx
  80062c:	7e 0e                	jle    80063c <getuint+0x16>
		return va_arg(*ap, unsigned long long);
  80062e:	8b 10                	mov    (%eax),%edx
  800630:	8d 4a 08             	lea    0x8(%edx),%ecx
  800633:	89 08                	mov    %ecx,(%eax)
  800635:	8b 02                	mov    (%edx),%eax
  800637:	8b 52 04             	mov    0x4(%edx),%edx
  80063a:	eb 22                	jmp    80065e <getuint+0x38>
	else if (lflag)
  80063c:	85 d2                	test   %edx,%edx
  80063e:	74 10                	je     800650 <getuint+0x2a>
		return va_arg(*ap, unsigned long);
  800640:	8b 10                	mov    (%eax),%edx
  800642:	8d 4a 04             	lea    0x4(%edx),%ecx
  800645:	89 08                	mov    %ecx,(%eax)
  800647:	8b 02                	mov    (%edx),%eax
  800649:	ba 00 00 00 00       	mov    $0x0,%edx
  80064e:	eb 0e                	jmp    80065e <getuint+0x38>
	else
		return va_arg(*ap, unsigned int);
  800650:	8b 10                	mov    (%eax),%edx
  800652:	8d 4a 04             	lea    0x4(%edx),%ecx
  800655:	89 08                	mov    %ecx,(%eax)
  800657:	8b 02                	mov    (%edx),%eax
  800659:	ba 00 00 00 00       	mov    $0x0,%edx
}
  80065e:	5d                   	pop    %ebp
  80065f:	c3                   	ret    

00800660 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800660:	55                   	push   %ebp
  800661:	89 e5                	mov    %esp,%ebp
  800663:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  800666:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  80066a:	8b 10                	mov    (%eax),%edx
  80066c:	3b 50 04             	cmp    0x4(%eax),%edx
  80066f:	73 0a                	jae    80067b <sprintputch+0x1b>
		*b->buf++ = ch;
  800671:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800674:	88 0a                	mov    %cl,(%edx)
  800676:	83 c2 01             	add    $0x1,%edx
  800679:	89 10                	mov    %edx,(%eax)
}
  80067b:	5d                   	pop    %ebp
  80067c:	c3                   	ret    

0080067d <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  80067d:	55                   	push   %ebp
  80067e:	89 e5                	mov    %esp,%ebp
  800680:	57                   	push   %edi
  800681:	56                   	push   %esi
  800682:	53                   	push   %ebx
  800683:	83 ec 5c             	sub    $0x5c,%esp
  800686:	8b 7d 08             	mov    0x8(%ebp),%edi
  800689:	8b 75 0c             	mov    0xc(%ebp),%esi
  80068c:	8b 5d 10             	mov    0x10(%ebp),%ebx
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  80068f:	c7 45 c8 ff ff ff ff 	movl   $0xffffffff,-0x38(%ebp)
  800696:	eb 11                	jmp    8006a9 <vprintfmt+0x2c>
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
  800698:	85 c0                	test   %eax,%eax
  80069a:	0f 84 ec 03 00 00    	je     800a8c <vprintfmt+0x40f>
				return;
			putch(ch, putdat);
  8006a0:	89 74 24 04          	mov    %esi,0x4(%esp)
  8006a4:	89 04 24             	mov    %eax,(%esp)
  8006a7:	ff d7                	call   *%edi
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8006a9:	0f b6 03             	movzbl (%ebx),%eax
  8006ac:	83 c3 01             	add    $0x1,%ebx
  8006af:	83 f8 25             	cmp    $0x25,%eax
  8006b2:	75 e4                	jne    800698 <vprintfmt+0x1b>
  8006b4:	c6 45 d4 20          	movb   $0x20,-0x2c(%ebp)
  8006b8:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
  8006bf:	c7 45 d0 ff ff ff ff 	movl   $0xffffffff,-0x30(%ebp)
  8006c6:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
  8006cd:	b9 00 00 00 00       	mov    $0x0,%ecx
  8006d2:	eb 06                	jmp    8006da <vprintfmt+0x5d>
  8006d4:	c6 45 d4 2d          	movb   $0x2d,-0x2c(%ebp)
  8006d8:	89 c3                	mov    %eax,%ebx
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8006da:	0f b6 13             	movzbl (%ebx),%edx
  8006dd:	0f b6 c2             	movzbl %dl,%eax
  8006e0:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8006e3:	8d 43 01             	lea    0x1(%ebx),%eax
  8006e6:	83 ea 23             	sub    $0x23,%edx
  8006e9:	80 fa 55             	cmp    $0x55,%dl
  8006ec:	0f 87 7d 03 00 00    	ja     800a6f <vprintfmt+0x3f2>
  8006f2:	0f b6 d2             	movzbl %dl,%edx
  8006f5:	ff 24 95 80 2e 80 00 	jmp    *0x802e80(,%edx,4)
  8006fc:	c6 45 d4 30          	movb   $0x30,-0x2c(%ebp)
  800700:	eb d6                	jmp    8006d8 <vprintfmt+0x5b>
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
				precision = precision * 10 + ch - '0';
  800702:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800705:	83 ea 30             	sub    $0x30,%edx
  800708:	89 55 d0             	mov    %edx,-0x30(%ebp)
				ch = *fmt;
  80070b:	0f be 10             	movsbl (%eax),%edx
				if (ch < '0' || ch > '9')
  80070e:	8d 5a d0             	lea    -0x30(%edx),%ebx
  800711:	83 fb 09             	cmp    $0x9,%ebx
  800714:	77 4c                	ja     800762 <vprintfmt+0xe5>
  800716:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  800719:	8b 4d d0             	mov    -0x30(%ebp),%ecx
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  80071c:	83 c0 01             	add    $0x1,%eax
				precision = precision * 10 + ch - '0';
  80071f:	8d 0c 89             	lea    (%ecx,%ecx,4),%ecx
  800722:	8d 4c 4a d0          	lea    -0x30(%edx,%ecx,2),%ecx
				ch = *fmt;
  800726:	0f be 10             	movsbl (%eax),%edx
				if (ch < '0' || ch > '9')
  800729:	8d 5a d0             	lea    -0x30(%edx),%ebx
  80072c:	83 fb 09             	cmp    $0x9,%ebx
  80072f:	76 eb                	jbe    80071c <vprintfmt+0x9f>
  800731:	89 4d d0             	mov    %ecx,-0x30(%ebp)
  800734:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  800737:	eb 29                	jmp    800762 <vprintfmt+0xe5>
					break;
			}
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800739:	8b 55 14             	mov    0x14(%ebp),%edx
  80073c:	8d 5a 04             	lea    0x4(%edx),%ebx
  80073f:	89 5d 14             	mov    %ebx,0x14(%ebp)
  800742:	8b 12                	mov    (%edx),%edx
  800744:	89 55 d0             	mov    %edx,-0x30(%ebp)
			goto process_precision;
  800747:	eb 19                	jmp    800762 <vprintfmt+0xe5>

		case '.':
			if (width < 0)
  800749:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80074c:	c1 fa 1f             	sar    $0x1f,%edx
  80074f:	f7 d2                	not    %edx
  800751:	21 55 e4             	and    %edx,-0x1c(%ebp)
  800754:	eb 82                	jmp    8006d8 <vprintfmt+0x5b>
  800756:	c7 45 d8 01 00 00 00 	movl   $0x1,-0x28(%ebp)
				width = 0;
			goto reswitch;

		case '#':
			altflag = 1;
			goto reswitch;
  80075d:	e9 76 ff ff ff       	jmp    8006d8 <vprintfmt+0x5b>

		process_precision:
			if (width < 0)
  800762:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800766:	0f 89 6c ff ff ff    	jns    8006d8 <vprintfmt+0x5b>
  80076c:	8b 55 d0             	mov    -0x30(%ebp),%edx
  80076f:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  800772:	8b 55 c8             	mov    -0x38(%ebp),%edx
  800775:	89 55 d0             	mov    %edx,-0x30(%ebp)
  800778:	e9 5b ff ff ff       	jmp    8006d8 <vprintfmt+0x5b>
				width = precision, precision = -1;
			goto reswitch;

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  80077d:	83 c1 01             	add    $0x1,%ecx
			goto reswitch;
  800780:	e9 53 ff ff ff       	jmp    8006d8 <vprintfmt+0x5b>
  800785:	89 45 cc             	mov    %eax,-0x34(%ebp)

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800788:	8b 45 14             	mov    0x14(%ebp),%eax
  80078b:	8d 50 04             	lea    0x4(%eax),%edx
  80078e:	89 55 14             	mov    %edx,0x14(%ebp)
  800791:	89 74 24 04          	mov    %esi,0x4(%esp)
  800795:	8b 00                	mov    (%eax),%eax
  800797:	89 04 24             	mov    %eax,(%esp)
  80079a:	ff d7                	call   *%edi
  80079c:	8b 5d cc             	mov    -0x34(%ebp),%ebx
			break;
  80079f:	e9 05 ff ff ff       	jmp    8006a9 <vprintfmt+0x2c>
  8007a4:	89 45 cc             	mov    %eax,-0x34(%ebp)

		// error message
		case 'e':
			err = va_arg(ap, int);
  8007a7:	8b 45 14             	mov    0x14(%ebp),%eax
  8007aa:	8d 50 04             	lea    0x4(%eax),%edx
  8007ad:	89 55 14             	mov    %edx,0x14(%ebp)
  8007b0:	8b 00                	mov    (%eax),%eax
  8007b2:	89 c2                	mov    %eax,%edx
  8007b4:	c1 fa 1f             	sar    $0x1f,%edx
  8007b7:	31 d0                	xor    %edx,%eax
  8007b9:	29 d0                	sub    %edx,%eax
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  8007bb:	83 f8 0f             	cmp    $0xf,%eax
  8007be:	7f 0b                	jg     8007cb <vprintfmt+0x14e>
  8007c0:	8b 14 85 e0 2f 80 00 	mov    0x802fe0(,%eax,4),%edx
  8007c7:	85 d2                	test   %edx,%edx
  8007c9:	75 20                	jne    8007eb <vprintfmt+0x16e>
				printfmt(putch, putdat, "error %d", err);
  8007cb:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8007cf:	c7 44 24 08 54 2d 80 	movl   $0x802d54,0x8(%esp)
  8007d6:	00 
  8007d7:	89 74 24 04          	mov    %esi,0x4(%esp)
  8007db:	89 3c 24             	mov    %edi,(%esp)
  8007de:	e8 31 03 00 00       	call   800b14 <printfmt>
  8007e3:	8b 5d cc             	mov    -0x34(%ebp),%ebx
		// error message
		case 'e':
			err = va_arg(ap, int);
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  8007e6:	e9 be fe ff ff       	jmp    8006a9 <vprintfmt+0x2c>
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  8007eb:	89 54 24 0c          	mov    %edx,0xc(%esp)
  8007ef:	c7 44 24 08 26 31 80 	movl   $0x803126,0x8(%esp)
  8007f6:	00 
  8007f7:	89 74 24 04          	mov    %esi,0x4(%esp)
  8007fb:	89 3c 24             	mov    %edi,(%esp)
  8007fe:	e8 11 03 00 00       	call   800b14 <printfmt>
  800803:	8b 5d cc             	mov    -0x34(%ebp),%ebx
  800806:	e9 9e fe ff ff       	jmp    8006a9 <vprintfmt+0x2c>
  80080b:	89 45 cc             	mov    %eax,-0x34(%ebp)
  80080e:	89 c3                	mov    %eax,%ebx
  800810:	8b 4d d0             	mov    -0x30(%ebp),%ecx
  800813:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800816:	89 45 c4             	mov    %eax,-0x3c(%ebp)
			break;

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800819:	8b 45 14             	mov    0x14(%ebp),%eax
  80081c:	8d 50 04             	lea    0x4(%eax),%edx
  80081f:	89 55 14             	mov    %edx,0x14(%ebp)
  800822:	8b 00                	mov    (%eax),%eax
  800824:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800827:	85 c0                	test   %eax,%eax
  800829:	75 07                	jne    800832 <vprintfmt+0x1b5>
  80082b:	c7 45 e0 5d 2d 80 00 	movl   $0x802d5d,-0x20(%ebp)
				p = "(null)";
			if (width > 0 && padc != '-')
  800832:	83 7d c4 00          	cmpl   $0x0,-0x3c(%ebp)
  800836:	7e 06                	jle    80083e <vprintfmt+0x1c1>
  800838:	80 7d d4 2d          	cmpb   $0x2d,-0x2c(%ebp)
  80083c:	75 13                	jne    800851 <vprintfmt+0x1d4>
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  80083e:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800841:	0f be 02             	movsbl (%edx),%eax
  800844:	85 c0                	test   %eax,%eax
  800846:	0f 85 99 00 00 00    	jne    8008e5 <vprintfmt+0x268>
  80084c:	e9 86 00 00 00       	jmp    8008d7 <vprintfmt+0x25a>
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800851:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  800855:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  800858:	89 0c 24             	mov    %ecx,(%esp)
  80085b:	e8 fb 02 00 00       	call   800b5b <strnlen>
  800860:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  800863:	29 c2                	sub    %eax,%edx
  800865:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  800868:	85 d2                	test   %edx,%edx
  80086a:	7e d2                	jle    80083e <vprintfmt+0x1c1>
					putch(padc, putdat);
  80086c:	0f be 4d d4          	movsbl -0x2c(%ebp),%ecx
  800870:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  800873:	89 5d c4             	mov    %ebx,-0x3c(%ebp)
  800876:	89 d3                	mov    %edx,%ebx
  800878:	89 74 24 04          	mov    %esi,0x4(%esp)
  80087c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80087f:	89 04 24             	mov    %eax,(%esp)
  800882:	ff d7                	call   *%edi
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800884:	83 eb 01             	sub    $0x1,%ebx
  800887:	85 db                	test   %ebx,%ebx
  800889:	7f ed                	jg     800878 <vprintfmt+0x1fb>
  80088b:	8b 5d c4             	mov    -0x3c(%ebp),%ebx
  80088e:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  800895:	eb a7                	jmp    80083e <vprintfmt+0x1c1>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
  800897:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  80089b:	74 18                	je     8008b5 <vprintfmt+0x238>
  80089d:	8d 50 e0             	lea    -0x20(%eax),%edx
  8008a0:	83 fa 5e             	cmp    $0x5e,%edx
  8008a3:	76 10                	jbe    8008b5 <vprintfmt+0x238>
					putch('?', putdat);
  8008a5:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8008a9:	c7 04 24 3f 00 00 00 	movl   $0x3f,(%esp)
  8008b0:	ff 55 e0             	call   *-0x20(%ebp)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
  8008b3:	eb 0a                	jmp    8008bf <vprintfmt+0x242>
					putch('?', putdat);
				else
					putch(ch, putdat);
  8008b5:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8008b9:	89 04 24             	mov    %eax,(%esp)
  8008bc:	ff 55 e0             	call   *-0x20(%ebp)
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8008bf:	83 6d e4 01          	subl   $0x1,-0x1c(%ebp)
  8008c3:	0f be 03             	movsbl (%ebx),%eax
  8008c6:	85 c0                	test   %eax,%eax
  8008c8:	74 05                	je     8008cf <vprintfmt+0x252>
  8008ca:	83 c3 01             	add    $0x1,%ebx
  8008cd:	eb 29                	jmp    8008f8 <vprintfmt+0x27b>
  8008cf:	89 fe                	mov    %edi,%esi
  8008d1:	8b 7d e0             	mov    -0x20(%ebp),%edi
  8008d4:	8b 5d d0             	mov    -0x30(%ebp),%ebx
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  8008d7:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8008db:	7f 2e                	jg     80090b <vprintfmt+0x28e>
  8008dd:	8b 5d cc             	mov    -0x34(%ebp),%ebx
  8008e0:	e9 c4 fd ff ff       	jmp    8006a9 <vprintfmt+0x2c>
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8008e5:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8008e8:	83 c2 01             	add    $0x1,%edx
  8008eb:	89 7d e0             	mov    %edi,-0x20(%ebp)
  8008ee:	89 f7                	mov    %esi,%edi
  8008f0:	8b 75 d0             	mov    -0x30(%ebp),%esi
  8008f3:	89 5d d0             	mov    %ebx,-0x30(%ebp)
  8008f6:	89 d3                	mov    %edx,%ebx
  8008f8:	85 f6                	test   %esi,%esi
  8008fa:	78 9b                	js     800897 <vprintfmt+0x21a>
  8008fc:	83 ee 01             	sub    $0x1,%esi
  8008ff:	79 96                	jns    800897 <vprintfmt+0x21a>
  800901:	89 fe                	mov    %edi,%esi
  800903:	8b 7d e0             	mov    -0x20(%ebp),%edi
  800906:	8b 5d d0             	mov    -0x30(%ebp),%ebx
  800909:	eb cc                	jmp    8008d7 <vprintfmt+0x25a>
  80090b:	89 5d d8             	mov    %ebx,-0x28(%ebp)
  80090e:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
				putch(' ', putdat);
  800911:	89 74 24 04          	mov    %esi,0x4(%esp)
  800915:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  80091c:	ff d7                	call   *%edi
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  80091e:	83 eb 01             	sub    $0x1,%ebx
  800921:	85 db                	test   %ebx,%ebx
  800923:	7f ec                	jg     800911 <vprintfmt+0x294>
  800925:	8b 5d d8             	mov    -0x28(%ebp),%ebx
  800928:	e9 7c fd ff ff       	jmp    8006a9 <vprintfmt+0x2c>
  80092d:	89 45 cc             	mov    %eax,-0x34(%ebp)
// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
	if (lflag >= 2)
  800930:	83 f9 01             	cmp    $0x1,%ecx
  800933:	7e 16                	jle    80094b <vprintfmt+0x2ce>
		return va_arg(*ap, long long);
  800935:	8b 45 14             	mov    0x14(%ebp),%eax
  800938:	8d 50 08             	lea    0x8(%eax),%edx
  80093b:	89 55 14             	mov    %edx,0x14(%ebp)
  80093e:	8b 10                	mov    (%eax),%edx
  800940:	8b 48 04             	mov    0x4(%eax),%ecx
  800943:	89 55 d8             	mov    %edx,-0x28(%ebp)
  800946:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  800949:	eb 32                	jmp    80097d <vprintfmt+0x300>
	else if (lflag)
  80094b:	85 c9                	test   %ecx,%ecx
  80094d:	74 18                	je     800967 <vprintfmt+0x2ea>
		return va_arg(*ap, long);
  80094f:	8b 45 14             	mov    0x14(%ebp),%eax
  800952:	8d 50 04             	lea    0x4(%eax),%edx
  800955:	89 55 14             	mov    %edx,0x14(%ebp)
  800958:	8b 00                	mov    (%eax),%eax
  80095a:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80095d:	89 c1                	mov    %eax,%ecx
  80095f:	c1 f9 1f             	sar    $0x1f,%ecx
  800962:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  800965:	eb 16                	jmp    80097d <vprintfmt+0x300>
	else
		return va_arg(*ap, int);
  800967:	8b 45 14             	mov    0x14(%ebp),%eax
  80096a:	8d 50 04             	lea    0x4(%eax),%edx
  80096d:	89 55 14             	mov    %edx,0x14(%ebp)
  800970:	8b 00                	mov    (%eax),%eax
  800972:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800975:	89 c2                	mov    %eax,%edx
  800977:	c1 fa 1f             	sar    $0x1f,%edx
  80097a:	89 55 dc             	mov    %edx,-0x24(%ebp)
				putch(' ', putdat);
			break;

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  80097d:	8b 4d d8             	mov    -0x28(%ebp),%ecx
  800980:	8b 5d dc             	mov    -0x24(%ebp),%ebx
  800983:	b8 0a 00 00 00       	mov    $0xa,%eax
			if ((long long) num < 0) {
  800988:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  80098c:	0f 89 9b 00 00 00    	jns    800a2d <vprintfmt+0x3b0>
				putch('-', putdat);
  800992:	89 74 24 04          	mov    %esi,0x4(%esp)
  800996:	c7 04 24 2d 00 00 00 	movl   $0x2d,(%esp)
  80099d:	ff d7                	call   *%edi
				num = -(long long) num;
  80099f:	8b 4d d8             	mov    -0x28(%ebp),%ecx
  8009a2:	8b 5d dc             	mov    -0x24(%ebp),%ebx
  8009a5:	f7 d9                	neg    %ecx
  8009a7:	83 d3 00             	adc    $0x0,%ebx
  8009aa:	f7 db                	neg    %ebx
  8009ac:	b8 0a 00 00 00       	mov    $0xa,%eax
  8009b1:	eb 7a                	jmp    800a2d <vprintfmt+0x3b0>
  8009b3:	89 45 cc             	mov    %eax,-0x34(%ebp)
			base = 10;
			goto number;

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  8009b6:	89 ca                	mov    %ecx,%edx
  8009b8:	8d 45 14             	lea    0x14(%ebp),%eax
  8009bb:	e8 66 fc ff ff       	call   800626 <getuint>
  8009c0:	89 c1                	mov    %eax,%ecx
  8009c2:	89 d3                	mov    %edx,%ebx
  8009c4:	b8 0a 00 00 00       	mov    $0xa,%eax
			base = 10;
			goto number;
  8009c9:	eb 62                	jmp    800a2d <vprintfmt+0x3b0>
  8009cb:	89 45 cc             	mov    %eax,-0x34(%ebp)
		case 'o':
			// Replace this with your code.
			// putch('X', putdat);
			// putch('X', putdat);
			// putch('X', putdat);
			num = getuint(&ap, lflag);
  8009ce:	89 ca                	mov    %ecx,%edx
  8009d0:	8d 45 14             	lea    0x14(%ebp),%eax
  8009d3:	e8 4e fc ff ff       	call   800626 <getuint>
  8009d8:	89 c1                	mov    %eax,%ecx
  8009da:	89 d3                	mov    %edx,%ebx
  8009dc:	b8 08 00 00 00       	mov    $0x8,%eax
			base = 8;
			goto number;
  8009e1:	eb 4a                	jmp    800a2d <vprintfmt+0x3b0>
  8009e3:	89 45 cc             	mov    %eax,-0x34(%ebp)
			break;

		// pointer
		case 'p':
			putch('0', putdat);
  8009e6:	89 74 24 04          	mov    %esi,0x4(%esp)
  8009ea:	c7 04 24 30 00 00 00 	movl   $0x30,(%esp)
  8009f1:	ff d7                	call   *%edi
			putch('x', putdat);
  8009f3:	89 74 24 04          	mov    %esi,0x4(%esp)
  8009f7:	c7 04 24 78 00 00 00 	movl   $0x78,(%esp)
  8009fe:	ff d7                	call   *%edi
			num = (unsigned long long)
  800a00:	8b 45 14             	mov    0x14(%ebp),%eax
  800a03:	8d 50 04             	lea    0x4(%eax),%edx
  800a06:	89 55 14             	mov    %edx,0x14(%ebp)
  800a09:	8b 08                	mov    (%eax),%ecx
  800a0b:	bb 00 00 00 00       	mov    $0x0,%ebx
  800a10:	b8 10 00 00 00       	mov    $0x10,%eax
				(uintptr_t) va_arg(ap, void *);
			base = 16;
			goto number;
  800a15:	eb 16                	jmp    800a2d <vprintfmt+0x3b0>
  800a17:	89 45 cc             	mov    %eax,-0x34(%ebp)

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800a1a:	89 ca                	mov    %ecx,%edx
  800a1c:	8d 45 14             	lea    0x14(%ebp),%eax
  800a1f:	e8 02 fc ff ff       	call   800626 <getuint>
  800a24:	89 c1                	mov    %eax,%ecx
  800a26:	89 d3                	mov    %edx,%ebx
  800a28:	b8 10 00 00 00       	mov    $0x10,%eax
			base = 16;
		number:
			printnum(putch, putdat, num, base, width, padc);
  800a2d:	0f be 55 d4          	movsbl -0x2c(%ebp),%edx
  800a31:	89 54 24 10          	mov    %edx,0x10(%esp)
  800a35:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  800a38:	89 54 24 0c          	mov    %edx,0xc(%esp)
  800a3c:	89 44 24 08          	mov    %eax,0x8(%esp)
  800a40:	89 0c 24             	mov    %ecx,(%esp)
  800a43:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  800a47:	89 f2                	mov    %esi,%edx
  800a49:	89 f8                	mov    %edi,%eax
  800a4b:	e8 e0 fa ff ff       	call   800530 <printnum>
  800a50:	8b 5d cc             	mov    -0x34(%ebp),%ebx
			break;
  800a53:	e9 51 fc ff ff       	jmp    8006a9 <vprintfmt+0x2c>
  800a58:	89 45 cc             	mov    %eax,-0x34(%ebp)
  800a5b:	8b 55 e0             	mov    -0x20(%ebp),%edx

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800a5e:	89 74 24 04          	mov    %esi,0x4(%esp)
  800a62:	89 14 24             	mov    %edx,(%esp)
  800a65:	ff d7                	call   *%edi
  800a67:	8b 5d cc             	mov    -0x34(%ebp),%ebx
			break;
  800a6a:	e9 3a fc ff ff       	jmp    8006a9 <vprintfmt+0x2c>
			
		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800a6f:	89 74 24 04          	mov    %esi,0x4(%esp)
  800a73:	c7 04 24 25 00 00 00 	movl   $0x25,(%esp)
  800a7a:	ff d7                	call   *%edi
			for (fmt--; fmt[-1] != '%'; fmt--)
  800a7c:	8d 43 ff             	lea    -0x1(%ebx),%eax
  800a7f:	80 38 25             	cmpb   $0x25,(%eax)
  800a82:	0f 84 21 fc ff ff    	je     8006a9 <vprintfmt+0x2c>
  800a88:	89 c3                	mov    %eax,%ebx
  800a8a:	eb f0                	jmp    800a7c <vprintfmt+0x3ff>
				/* do nothing */;
			break;
		}
	}
}
  800a8c:	83 c4 5c             	add    $0x5c,%esp
  800a8f:	5b                   	pop    %ebx
  800a90:	5e                   	pop    %esi
  800a91:	5f                   	pop    %edi
  800a92:	5d                   	pop    %ebp
  800a93:	c3                   	ret    

00800a94 <vsnprintf>:
		*b->buf++ = ch;
}

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800a94:	55                   	push   %ebp
  800a95:	89 e5                	mov    %esp,%ebp
  800a97:	83 ec 28             	sub    $0x28,%esp
  800a9a:	8b 45 08             	mov    0x8(%ebp),%eax
  800a9d:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};

	if (buf == NULL || n < 1)
  800aa0:	85 c0                	test   %eax,%eax
  800aa2:	74 04                	je     800aa8 <vsnprintf+0x14>
  800aa4:	85 d2                	test   %edx,%edx
  800aa6:	7f 07                	jg     800aaf <vsnprintf+0x1b>
  800aa8:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800aad:	eb 3b                	jmp    800aea <vsnprintf+0x56>
}

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
	struct sprintbuf b = {buf, buf+n-1, 0};
  800aaf:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800ab2:	8d 44 10 ff          	lea    -0x1(%eax,%edx,1),%eax
  800ab6:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800ab9:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800ac0:	8b 45 14             	mov    0x14(%ebp),%eax
  800ac3:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800ac7:	8b 45 10             	mov    0x10(%ebp),%eax
  800aca:	89 44 24 08          	mov    %eax,0x8(%esp)
  800ace:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800ad1:	89 44 24 04          	mov    %eax,0x4(%esp)
  800ad5:	c7 04 24 60 06 80 00 	movl   $0x800660,(%esp)
  800adc:	e8 9c fb ff ff       	call   80067d <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  800ae1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800ae4:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800ae7:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800aea:	c9                   	leave  
  800aeb:	c3                   	ret    

00800aec <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800aec:	55                   	push   %ebp
  800aed:	89 e5                	mov    %esp,%ebp
  800aef:	83 ec 18             	sub    $0x18,%esp

	return b.cnt;
}

int
snprintf(char *buf, int n, const char *fmt, ...)
  800af2:	8d 45 14             	lea    0x14(%ebp),%eax
{
	va_list ap;
	int rc;

	va_start(ap, fmt);
	rc = vsnprintf(buf, n, fmt, ap);
  800af5:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800af9:	8b 45 10             	mov    0x10(%ebp),%eax
  800afc:	89 44 24 08          	mov    %eax,0x8(%esp)
  800b00:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b03:	89 44 24 04          	mov    %eax,0x4(%esp)
  800b07:	8b 45 08             	mov    0x8(%ebp),%eax
  800b0a:	89 04 24             	mov    %eax,(%esp)
  800b0d:	e8 82 ff ff ff       	call   800a94 <vsnprintf>
	va_end(ap);

	return rc;
}
  800b12:	c9                   	leave  
  800b13:	c3                   	ret    

00800b14 <printfmt>:
	}
}

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800b14:	55                   	push   %ebp
  800b15:	89 e5                	mov    %esp,%ebp
  800b17:	83 ec 18             	sub    $0x18,%esp
		}
	}
}

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
  800b1a:	8d 45 14             	lea    0x14(%ebp),%eax
{
	va_list ap;

	va_start(ap, fmt);
	vprintfmt(putch, putdat, fmt, ap);
  800b1d:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800b21:	8b 45 10             	mov    0x10(%ebp),%eax
  800b24:	89 44 24 08          	mov    %eax,0x8(%esp)
  800b28:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b2b:	89 44 24 04          	mov    %eax,0x4(%esp)
  800b2f:	8b 45 08             	mov    0x8(%ebp),%eax
  800b32:	89 04 24             	mov    %eax,(%esp)
  800b35:	e8 43 fb ff ff       	call   80067d <vprintfmt>
	va_end(ap);
}
  800b3a:	c9                   	leave  
  800b3b:	c3                   	ret    
  800b3c:	00 00                	add    %al,(%eax)
	...

00800b40 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800b40:	55                   	push   %ebp
  800b41:	89 e5                	mov    %esp,%ebp
  800b43:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  800b46:	b8 00 00 00 00       	mov    $0x0,%eax
  800b4b:	80 3a 00             	cmpb   $0x0,(%edx)
  800b4e:	74 09                	je     800b59 <strlen+0x19>
		n++;
  800b50:	83 c0 01             	add    $0x1,%eax
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800b53:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  800b57:	75 f7                	jne    800b50 <strlen+0x10>
		n++;
	return n;
}
  800b59:	5d                   	pop    %ebp
  800b5a:	c3                   	ret    

00800b5b <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800b5b:	55                   	push   %ebp
  800b5c:	89 e5                	mov    %esp,%ebp
  800b5e:	53                   	push   %ebx
  800b5f:	8b 5d 08             	mov    0x8(%ebp),%ebx
  800b62:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800b65:	85 c9                	test   %ecx,%ecx
  800b67:	74 19                	je     800b82 <strnlen+0x27>
  800b69:	80 3b 00             	cmpb   $0x0,(%ebx)
  800b6c:	74 14                	je     800b82 <strnlen+0x27>
  800b6e:	b8 00 00 00 00       	mov    $0x0,%eax
		n++;
  800b73:	83 c0 01             	add    $0x1,%eax
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800b76:	39 c8                	cmp    %ecx,%eax
  800b78:	74 0d                	je     800b87 <strnlen+0x2c>
  800b7a:	80 3c 03 00          	cmpb   $0x0,(%ebx,%eax,1)
  800b7e:	75 f3                	jne    800b73 <strnlen+0x18>
  800b80:	eb 05                	jmp    800b87 <strnlen+0x2c>
  800b82:	b8 00 00 00 00       	mov    $0x0,%eax
		n++;
	return n;
}
  800b87:	5b                   	pop    %ebx
  800b88:	5d                   	pop    %ebp
  800b89:	c3                   	ret    

00800b8a <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800b8a:	55                   	push   %ebp
  800b8b:	89 e5                	mov    %esp,%ebp
  800b8d:	53                   	push   %ebx
  800b8e:	8b 45 08             	mov    0x8(%ebp),%eax
  800b91:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800b94:	ba 00 00 00 00       	mov    $0x0,%edx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  800b99:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
  800b9d:	88 0c 10             	mov    %cl,(%eax,%edx,1)
  800ba0:	83 c2 01             	add    $0x1,%edx
  800ba3:	84 c9                	test   %cl,%cl
  800ba5:	75 f2                	jne    800b99 <strcpy+0xf>
		/* do nothing */;
	return ret;
}
  800ba7:	5b                   	pop    %ebx
  800ba8:	5d                   	pop    %ebp
  800ba9:	c3                   	ret    

00800baa <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800baa:	55                   	push   %ebp
  800bab:	89 e5                	mov    %esp,%ebp
  800bad:	56                   	push   %esi
  800bae:	53                   	push   %ebx
  800baf:	8b 45 08             	mov    0x8(%ebp),%eax
  800bb2:	8b 55 0c             	mov    0xc(%ebp),%edx
  800bb5:	8b 75 10             	mov    0x10(%ebp),%esi
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800bb8:	85 f6                	test   %esi,%esi
  800bba:	74 18                	je     800bd4 <strncpy+0x2a>
  800bbc:	b9 00 00 00 00       	mov    $0x0,%ecx
		*dst++ = *src;
  800bc1:	0f b6 1a             	movzbl (%edx),%ebx
  800bc4:	88 1c 08             	mov    %bl,(%eax,%ecx,1)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  800bc7:	80 3a 01             	cmpb   $0x1,(%edx)
  800bca:	83 da ff             	sbb    $0xffffffff,%edx
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800bcd:	83 c1 01             	add    $0x1,%ecx
  800bd0:	39 ce                	cmp    %ecx,%esi
  800bd2:	77 ed                	ja     800bc1 <strncpy+0x17>
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
}
  800bd4:	5b                   	pop    %ebx
  800bd5:	5e                   	pop    %esi
  800bd6:	5d                   	pop    %ebp
  800bd7:	c3                   	ret    

00800bd8 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800bd8:	55                   	push   %ebp
  800bd9:	89 e5                	mov    %esp,%ebp
  800bdb:	56                   	push   %esi
  800bdc:	53                   	push   %ebx
  800bdd:	8b 75 08             	mov    0x8(%ebp),%esi
  800be0:	8b 55 0c             	mov    0xc(%ebp),%edx
  800be3:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  800be6:	89 f0                	mov    %esi,%eax
  800be8:	85 c9                	test   %ecx,%ecx
  800bea:	74 27                	je     800c13 <strlcpy+0x3b>
		while (--size > 0 && *src != '\0')
  800bec:	83 e9 01             	sub    $0x1,%ecx
  800bef:	74 1d                	je     800c0e <strlcpy+0x36>
  800bf1:	0f b6 1a             	movzbl (%edx),%ebx
  800bf4:	84 db                	test   %bl,%bl
  800bf6:	74 16                	je     800c0e <strlcpy+0x36>
			*dst++ = *src++;
  800bf8:	88 18                	mov    %bl,(%eax)
  800bfa:	83 c0 01             	add    $0x1,%eax
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800bfd:	83 e9 01             	sub    $0x1,%ecx
  800c00:	74 0e                	je     800c10 <strlcpy+0x38>
			*dst++ = *src++;
  800c02:	83 c2 01             	add    $0x1,%edx
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800c05:	0f b6 1a             	movzbl (%edx),%ebx
  800c08:	84 db                	test   %bl,%bl
  800c0a:	75 ec                	jne    800bf8 <strlcpy+0x20>
  800c0c:	eb 02                	jmp    800c10 <strlcpy+0x38>
  800c0e:	89 f0                	mov    %esi,%eax
			*dst++ = *src++;
		*dst = '\0';
  800c10:	c6 00 00             	movb   $0x0,(%eax)
  800c13:	29 f0                	sub    %esi,%eax
	}
	return dst - dst_in;
}
  800c15:	5b                   	pop    %ebx
  800c16:	5e                   	pop    %esi
  800c17:	5d                   	pop    %ebp
  800c18:	c3                   	ret    

00800c19 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800c19:	55                   	push   %ebp
  800c1a:	89 e5                	mov    %esp,%ebp
  800c1c:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800c1f:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  800c22:	0f b6 01             	movzbl (%ecx),%eax
  800c25:	84 c0                	test   %al,%al
  800c27:	74 15                	je     800c3e <strcmp+0x25>
  800c29:	3a 02                	cmp    (%edx),%al
  800c2b:	75 11                	jne    800c3e <strcmp+0x25>
		p++, q++;
  800c2d:	83 c1 01             	add    $0x1,%ecx
  800c30:	83 c2 01             	add    $0x1,%edx
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800c33:	0f b6 01             	movzbl (%ecx),%eax
  800c36:	84 c0                	test   %al,%al
  800c38:	74 04                	je     800c3e <strcmp+0x25>
  800c3a:	3a 02                	cmp    (%edx),%al
  800c3c:	74 ef                	je     800c2d <strcmp+0x14>
  800c3e:	0f b6 c0             	movzbl %al,%eax
  800c41:	0f b6 12             	movzbl (%edx),%edx
  800c44:	29 d0                	sub    %edx,%eax
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
}
  800c46:	5d                   	pop    %ebp
  800c47:	c3                   	ret    

00800c48 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800c48:	55                   	push   %ebp
  800c49:	89 e5                	mov    %esp,%ebp
  800c4b:	53                   	push   %ebx
  800c4c:	8b 55 08             	mov    0x8(%ebp),%edx
  800c4f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c52:	8b 45 10             	mov    0x10(%ebp),%eax
	while (n > 0 && *p && *p == *q)
  800c55:	85 c0                	test   %eax,%eax
  800c57:	74 23                	je     800c7c <strncmp+0x34>
  800c59:	0f b6 1a             	movzbl (%edx),%ebx
  800c5c:	84 db                	test   %bl,%bl
  800c5e:	74 24                	je     800c84 <strncmp+0x3c>
  800c60:	3a 19                	cmp    (%ecx),%bl
  800c62:	75 20                	jne    800c84 <strncmp+0x3c>
  800c64:	83 e8 01             	sub    $0x1,%eax
  800c67:	74 13                	je     800c7c <strncmp+0x34>
		n--, p++, q++;
  800c69:	83 c2 01             	add    $0x1,%edx
  800c6c:	83 c1 01             	add    $0x1,%ecx
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  800c6f:	0f b6 1a             	movzbl (%edx),%ebx
  800c72:	84 db                	test   %bl,%bl
  800c74:	74 0e                	je     800c84 <strncmp+0x3c>
  800c76:	3a 19                	cmp    (%ecx),%bl
  800c78:	74 ea                	je     800c64 <strncmp+0x1c>
  800c7a:	eb 08                	jmp    800c84 <strncmp+0x3c>
  800c7c:	b8 00 00 00 00       	mov    $0x0,%eax
		n--, p++, q++;
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
}
  800c81:	5b                   	pop    %ebx
  800c82:	5d                   	pop    %ebp
  800c83:	c3                   	ret    
	while (n > 0 && *p && *p == *q)
		n--, p++, q++;
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800c84:	0f b6 02             	movzbl (%edx),%eax
  800c87:	0f b6 11             	movzbl (%ecx),%edx
  800c8a:	29 d0                	sub    %edx,%eax
  800c8c:	eb f3                	jmp    800c81 <strncmp+0x39>

00800c8e <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800c8e:	55                   	push   %ebp
  800c8f:	89 e5                	mov    %esp,%ebp
  800c91:	8b 45 08             	mov    0x8(%ebp),%eax
  800c94:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800c98:	0f b6 10             	movzbl (%eax),%edx
  800c9b:	84 d2                	test   %dl,%dl
  800c9d:	74 15                	je     800cb4 <strchr+0x26>
		if (*s == c)
  800c9f:	38 ca                	cmp    %cl,%dl
  800ca1:	75 07                	jne    800caa <strchr+0x1c>
  800ca3:	eb 14                	jmp    800cb9 <strchr+0x2b>
  800ca5:	38 ca                	cmp    %cl,%dl
  800ca7:	90                   	nop
  800ca8:	74 0f                	je     800cb9 <strchr+0x2b>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800caa:	83 c0 01             	add    $0x1,%eax
  800cad:	0f b6 10             	movzbl (%eax),%edx
  800cb0:	84 d2                	test   %dl,%dl
  800cb2:	75 f1                	jne    800ca5 <strchr+0x17>
  800cb4:	b8 00 00 00 00       	mov    $0x0,%eax
		if (*s == c)
			return (char *) s;
	return 0;
}
  800cb9:	5d                   	pop    %ebp
  800cba:	c3                   	ret    

00800cbb <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800cbb:	55                   	push   %ebp
  800cbc:	89 e5                	mov    %esp,%ebp
  800cbe:	8b 45 08             	mov    0x8(%ebp),%eax
  800cc1:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800cc5:	0f b6 10             	movzbl (%eax),%edx
  800cc8:	84 d2                	test   %dl,%dl
  800cca:	74 18                	je     800ce4 <strfind+0x29>
		if (*s == c)
  800ccc:	38 ca                	cmp    %cl,%dl
  800cce:	75 0a                	jne    800cda <strfind+0x1f>
  800cd0:	eb 12                	jmp    800ce4 <strfind+0x29>
  800cd2:	38 ca                	cmp    %cl,%dl
  800cd4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  800cd8:	74 0a                	je     800ce4 <strfind+0x29>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800cda:	83 c0 01             	add    $0x1,%eax
  800cdd:	0f b6 10             	movzbl (%eax),%edx
  800ce0:	84 d2                	test   %dl,%dl
  800ce2:	75 ee                	jne    800cd2 <strfind+0x17>
		if (*s == c)
			break;
	return (char *) s;
}
  800ce4:	5d                   	pop    %ebp
  800ce5:	c3                   	ret    

00800ce6 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800ce6:	55                   	push   %ebp
  800ce7:	89 e5                	mov    %esp,%ebp
  800ce9:	83 ec 0c             	sub    $0xc,%esp
  800cec:	89 1c 24             	mov    %ebx,(%esp)
  800cef:	89 74 24 04          	mov    %esi,0x4(%esp)
  800cf3:	89 7c 24 08          	mov    %edi,0x8(%esp)
  800cf7:	8b 7d 08             	mov    0x8(%ebp),%edi
  800cfa:	8b 45 0c             	mov    0xc(%ebp),%eax
  800cfd:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800d00:	85 c9                	test   %ecx,%ecx
  800d02:	74 30                	je     800d34 <memset+0x4e>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800d04:	f7 c7 03 00 00 00    	test   $0x3,%edi
  800d0a:	75 25                	jne    800d31 <memset+0x4b>
  800d0c:	f6 c1 03             	test   $0x3,%cl
  800d0f:	75 20                	jne    800d31 <memset+0x4b>
		c &= 0xFF;
  800d11:	0f b6 d0             	movzbl %al,%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800d14:	89 d3                	mov    %edx,%ebx
  800d16:	c1 e3 08             	shl    $0x8,%ebx
  800d19:	89 d6                	mov    %edx,%esi
  800d1b:	c1 e6 18             	shl    $0x18,%esi
  800d1e:	89 d0                	mov    %edx,%eax
  800d20:	c1 e0 10             	shl    $0x10,%eax
  800d23:	09 f0                	or     %esi,%eax
  800d25:	09 d0                	or     %edx,%eax
		asm volatile("cld; rep stosl\n"
  800d27:	09 d8                	or     %ebx,%eax
  800d29:	c1 e9 02             	shr    $0x2,%ecx
  800d2c:	fc                   	cld    
  800d2d:	f3 ab                	rep stos %eax,%es:(%edi)
{
	char *p;

	if (n == 0)
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800d2f:	eb 03                	jmp    800d34 <memset+0x4e>
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800d31:	fc                   	cld    
  800d32:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800d34:	89 f8                	mov    %edi,%eax
  800d36:	8b 1c 24             	mov    (%esp),%ebx
  800d39:	8b 74 24 04          	mov    0x4(%esp),%esi
  800d3d:	8b 7c 24 08          	mov    0x8(%esp),%edi
  800d41:	89 ec                	mov    %ebp,%esp
  800d43:	5d                   	pop    %ebp
  800d44:	c3                   	ret    

00800d45 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800d45:	55                   	push   %ebp
  800d46:	89 e5                	mov    %esp,%ebp
  800d48:	83 ec 08             	sub    $0x8,%esp
  800d4b:	89 34 24             	mov    %esi,(%esp)
  800d4e:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800d52:	8b 45 08             	mov    0x8(%ebp),%eax
  800d55:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;
	
	s = src;
  800d58:	8b 75 0c             	mov    0xc(%ebp),%esi
	d = dst;
  800d5b:	89 c7                	mov    %eax,%edi
	if (s < d && s + n > d) {
  800d5d:	39 c6                	cmp    %eax,%esi
  800d5f:	73 35                	jae    800d96 <memmove+0x51>
  800d61:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800d64:	39 d0                	cmp    %edx,%eax
  800d66:	73 2e                	jae    800d96 <memmove+0x51>
		s += n;
		d += n;
  800d68:	01 cf                	add    %ecx,%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800d6a:	f6 c2 03             	test   $0x3,%dl
  800d6d:	75 1b                	jne    800d8a <memmove+0x45>
  800d6f:	f7 c7 03 00 00 00    	test   $0x3,%edi
  800d75:	75 13                	jne    800d8a <memmove+0x45>
  800d77:	f6 c1 03             	test   $0x3,%cl
  800d7a:	75 0e                	jne    800d8a <memmove+0x45>
			asm volatile("std; rep movsl\n"
  800d7c:	83 ef 04             	sub    $0x4,%edi
  800d7f:	8d 72 fc             	lea    -0x4(%edx),%esi
  800d82:	c1 e9 02             	shr    $0x2,%ecx
  800d85:	fd                   	std    
  800d86:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800d88:	eb 09                	jmp    800d93 <memmove+0x4e>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  800d8a:	83 ef 01             	sub    $0x1,%edi
  800d8d:	8d 72 ff             	lea    -0x1(%edx),%esi
  800d90:	fd                   	std    
  800d91:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800d93:	fc                   	cld    
	const char *s;
	char *d;
	
	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800d94:	eb 20                	jmp    800db6 <memmove+0x71>
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800d96:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800d9c:	75 15                	jne    800db3 <memmove+0x6e>
  800d9e:	f7 c7 03 00 00 00    	test   $0x3,%edi
  800da4:	75 0d                	jne    800db3 <memmove+0x6e>
  800da6:	f6 c1 03             	test   $0x3,%cl
  800da9:	75 08                	jne    800db3 <memmove+0x6e>
			asm volatile("cld; rep movsl\n"
  800dab:	c1 e9 02             	shr    $0x2,%ecx
  800dae:	fc                   	cld    
  800daf:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800db1:	eb 03                	jmp    800db6 <memmove+0x71>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  800db3:	fc                   	cld    
  800db4:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800db6:	8b 34 24             	mov    (%esp),%esi
  800db9:	8b 7c 24 04          	mov    0x4(%esp),%edi
  800dbd:	89 ec                	mov    %ebp,%esp
  800dbf:	5d                   	pop    %ebp
  800dc0:	c3                   	ret    

00800dc1 <memcpy>:

/* sigh - gcc emits references to this for structure assignments! */
/* it is *not* prototyped in inc/string.h - do not use directly. */
void *
memcpy(void *dst, void *src, size_t n)
{
  800dc1:	55                   	push   %ebp
  800dc2:	89 e5                	mov    %esp,%ebp
  800dc4:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  800dc7:	8b 45 10             	mov    0x10(%ebp),%eax
  800dca:	89 44 24 08          	mov    %eax,0x8(%esp)
  800dce:	8b 45 0c             	mov    0xc(%ebp),%eax
  800dd1:	89 44 24 04          	mov    %eax,0x4(%esp)
  800dd5:	8b 45 08             	mov    0x8(%ebp),%eax
  800dd8:	89 04 24             	mov    %eax,(%esp)
  800ddb:	e8 65 ff ff ff       	call   800d45 <memmove>
}
  800de0:	c9                   	leave  
  800de1:	c3                   	ret    

00800de2 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800de2:	55                   	push   %ebp
  800de3:	89 e5                	mov    %esp,%ebp
  800de5:	57                   	push   %edi
  800de6:	56                   	push   %esi
  800de7:	53                   	push   %ebx
  800de8:	8b 75 08             	mov    0x8(%ebp),%esi
  800deb:	8b 7d 0c             	mov    0xc(%ebp),%edi
  800dee:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800df1:	85 c9                	test   %ecx,%ecx
  800df3:	74 36                	je     800e2b <memcmp+0x49>
		if (*s1 != *s2)
  800df5:	0f b6 06             	movzbl (%esi),%eax
  800df8:	0f b6 1f             	movzbl (%edi),%ebx
  800dfb:	38 d8                	cmp    %bl,%al
  800dfd:	74 20                	je     800e1f <memcmp+0x3d>
  800dff:	eb 14                	jmp    800e15 <memcmp+0x33>
  800e01:	0f b6 44 16 01       	movzbl 0x1(%esi,%edx,1),%eax
  800e06:	0f b6 5c 17 01       	movzbl 0x1(%edi,%edx,1),%ebx
  800e0b:	83 c2 01             	add    $0x1,%edx
  800e0e:	83 e9 01             	sub    $0x1,%ecx
  800e11:	38 d8                	cmp    %bl,%al
  800e13:	74 12                	je     800e27 <memcmp+0x45>
			return (int) *s1 - (int) *s2;
  800e15:	0f b6 c0             	movzbl %al,%eax
  800e18:	0f b6 db             	movzbl %bl,%ebx
  800e1b:	29 d8                	sub    %ebx,%eax
  800e1d:	eb 11                	jmp    800e30 <memcmp+0x4e>
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800e1f:	83 e9 01             	sub    $0x1,%ecx
  800e22:	ba 00 00 00 00       	mov    $0x0,%edx
  800e27:	85 c9                	test   %ecx,%ecx
  800e29:	75 d6                	jne    800e01 <memcmp+0x1f>
  800e2b:	b8 00 00 00 00       	mov    $0x0,%eax
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
}
  800e30:	5b                   	pop    %ebx
  800e31:	5e                   	pop    %esi
  800e32:	5f                   	pop    %edi
  800e33:	5d                   	pop    %ebp
  800e34:	c3                   	ret    

00800e35 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800e35:	55                   	push   %ebp
  800e36:	89 e5                	mov    %esp,%ebp
  800e38:	8b 45 08             	mov    0x8(%ebp),%eax
	const void *ends = (const char *) s + n;
  800e3b:	89 c2                	mov    %eax,%edx
  800e3d:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800e40:	39 d0                	cmp    %edx,%eax
  800e42:	73 15                	jae    800e59 <memfind+0x24>
		if (*(const unsigned char *) s == (unsigned char) c)
  800e44:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
  800e48:	38 08                	cmp    %cl,(%eax)
  800e4a:	75 06                	jne    800e52 <memfind+0x1d>
  800e4c:	eb 0b                	jmp    800e59 <memfind+0x24>
  800e4e:	38 08                	cmp    %cl,(%eax)
  800e50:	74 07                	je     800e59 <memfind+0x24>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800e52:	83 c0 01             	add    $0x1,%eax
  800e55:	39 c2                	cmp    %eax,%edx
  800e57:	77 f5                	ja     800e4e <memfind+0x19>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
	return (void *) s;
}
  800e59:	5d                   	pop    %ebp
  800e5a:	c3                   	ret    

00800e5b <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800e5b:	55                   	push   %ebp
  800e5c:	89 e5                	mov    %esp,%ebp
  800e5e:	57                   	push   %edi
  800e5f:	56                   	push   %esi
  800e60:	53                   	push   %ebx
  800e61:	83 ec 04             	sub    $0x4,%esp
  800e64:	8b 55 08             	mov    0x8(%ebp),%edx
  800e67:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800e6a:	0f b6 02             	movzbl (%edx),%eax
  800e6d:	3c 20                	cmp    $0x20,%al
  800e6f:	74 04                	je     800e75 <strtol+0x1a>
  800e71:	3c 09                	cmp    $0x9,%al
  800e73:	75 0e                	jne    800e83 <strtol+0x28>
		s++;
  800e75:	83 c2 01             	add    $0x1,%edx
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800e78:	0f b6 02             	movzbl (%edx),%eax
  800e7b:	3c 20                	cmp    $0x20,%al
  800e7d:	74 f6                	je     800e75 <strtol+0x1a>
  800e7f:	3c 09                	cmp    $0x9,%al
  800e81:	74 f2                	je     800e75 <strtol+0x1a>
		s++;

	// plus/minus sign
	if (*s == '+')
  800e83:	3c 2b                	cmp    $0x2b,%al
  800e85:	75 0c                	jne    800e93 <strtol+0x38>
		s++;
  800e87:	83 c2 01             	add    $0x1,%edx
  800e8a:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800e91:	eb 15                	jmp    800ea8 <strtol+0x4d>
	else if (*s == '-')
  800e93:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800e9a:	3c 2d                	cmp    $0x2d,%al
  800e9c:	75 0a                	jne    800ea8 <strtol+0x4d>
		s++, neg = 1;
  800e9e:	83 c2 01             	add    $0x1,%edx
  800ea1:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800ea8:	85 db                	test   %ebx,%ebx
  800eaa:	0f 94 c0             	sete   %al
  800ead:	74 05                	je     800eb4 <strtol+0x59>
  800eaf:	83 fb 10             	cmp    $0x10,%ebx
  800eb2:	75 18                	jne    800ecc <strtol+0x71>
  800eb4:	80 3a 30             	cmpb   $0x30,(%edx)
  800eb7:	75 13                	jne    800ecc <strtol+0x71>
  800eb9:	80 7a 01 78          	cmpb   $0x78,0x1(%edx)
  800ebd:	8d 76 00             	lea    0x0(%esi),%esi
  800ec0:	75 0a                	jne    800ecc <strtol+0x71>
		s += 2, base = 16;
  800ec2:	83 c2 02             	add    $0x2,%edx
  800ec5:	bb 10 00 00 00       	mov    $0x10,%ebx
		s++;
	else if (*s == '-')
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800eca:	eb 15                	jmp    800ee1 <strtol+0x86>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  800ecc:	84 c0                	test   %al,%al
  800ece:	66 90                	xchg   %ax,%ax
  800ed0:	74 0f                	je     800ee1 <strtol+0x86>
  800ed2:	bb 0a 00 00 00       	mov    $0xa,%ebx
  800ed7:	80 3a 30             	cmpb   $0x30,(%edx)
  800eda:	75 05                	jne    800ee1 <strtol+0x86>
		s++, base = 8;
  800edc:	83 c2 01             	add    $0x1,%edx
  800edf:	b3 08                	mov    $0x8,%bl
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  800ee1:	b8 00 00 00 00       	mov    $0x0,%eax
  800ee6:	89 de                	mov    %ebx,%esi

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  800ee8:	0f b6 0a             	movzbl (%edx),%ecx
  800eeb:	89 cf                	mov    %ecx,%edi
  800eed:	8d 59 d0             	lea    -0x30(%ecx),%ebx
  800ef0:	80 fb 09             	cmp    $0x9,%bl
  800ef3:	77 08                	ja     800efd <strtol+0xa2>
			dig = *s - '0';
  800ef5:	0f be c9             	movsbl %cl,%ecx
  800ef8:	83 e9 30             	sub    $0x30,%ecx
  800efb:	eb 1e                	jmp    800f1b <strtol+0xc0>
		else if (*s >= 'a' && *s <= 'z')
  800efd:	8d 5f 9f             	lea    -0x61(%edi),%ebx
  800f00:	80 fb 19             	cmp    $0x19,%bl
  800f03:	77 08                	ja     800f0d <strtol+0xb2>
			dig = *s - 'a' + 10;
  800f05:	0f be c9             	movsbl %cl,%ecx
  800f08:	83 e9 57             	sub    $0x57,%ecx
  800f0b:	eb 0e                	jmp    800f1b <strtol+0xc0>
		else if (*s >= 'A' && *s <= 'Z')
  800f0d:	8d 5f bf             	lea    -0x41(%edi),%ebx
  800f10:	80 fb 19             	cmp    $0x19,%bl
  800f13:	77 15                	ja     800f2a <strtol+0xcf>
			dig = *s - 'A' + 10;
  800f15:	0f be c9             	movsbl %cl,%ecx
  800f18:	83 e9 37             	sub    $0x37,%ecx
		else
			break;
		if (dig >= base)
  800f1b:	39 f1                	cmp    %esi,%ecx
  800f1d:	7d 0b                	jge    800f2a <strtol+0xcf>
			break;
		s++, val = (val * base) + dig;
  800f1f:	83 c2 01             	add    $0x1,%edx
  800f22:	0f af c6             	imul   %esi,%eax
  800f25:	8d 04 01             	lea    (%ecx,%eax,1),%eax
		// we don't properly detect overflow!
	}
  800f28:	eb be                	jmp    800ee8 <strtol+0x8d>
  800f2a:	89 c1                	mov    %eax,%ecx

	if (endptr)
  800f2c:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800f30:	74 05                	je     800f37 <strtol+0xdc>
		*endptr = (char *) s;
  800f32:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800f35:	89 13                	mov    %edx,(%ebx)
	return (neg ? -val : val);
  800f37:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  800f3b:	74 04                	je     800f41 <strtol+0xe6>
  800f3d:	89 c8                	mov    %ecx,%eax
  800f3f:	f7 d8                	neg    %eax
}
  800f41:	83 c4 04             	add    $0x4,%esp
  800f44:	5b                   	pop    %ebx
  800f45:	5e                   	pop    %esi
  800f46:	5f                   	pop    %edi
  800f47:	5d                   	pop    %ebp
  800f48:	c3                   	ret    
  800f49:	00 00                	add    %al,(%eax)
	...

00800f4c <sys_cgetc>:
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}

int
sys_cgetc(void)
{
  800f4c:	55                   	push   %ebp
  800f4d:	89 e5                	mov    %esp,%ebp
  800f4f:	83 ec 0c             	sub    $0xc,%esp
  800f52:	89 1c 24             	mov    %ebx,(%esp)
  800f55:	89 74 24 04          	mov    %esi,0x4(%esp)
  800f59:	89 7c 24 08          	mov    %edi,0x8(%esp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800f5d:	ba 00 00 00 00       	mov    $0x0,%edx
  800f62:	b8 01 00 00 00       	mov    $0x1,%eax
  800f67:	89 d1                	mov    %edx,%ecx
  800f69:	89 d3                	mov    %edx,%ebx
  800f6b:	89 d7                	mov    %edx,%edi
  800f6d:	89 d6                	mov    %edx,%esi
  800f6f:	cd 30                	int    $0x30

int
sys_cgetc(void)
{
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800f71:	8b 1c 24             	mov    (%esp),%ebx
  800f74:	8b 74 24 04          	mov    0x4(%esp),%esi
  800f78:	8b 7c 24 08          	mov    0x8(%esp),%edi
  800f7c:	89 ec                	mov    %ebp,%esp
  800f7e:	5d                   	pop    %ebp
  800f7f:	c3                   	ret    

00800f80 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800f80:	55                   	push   %ebp
  800f81:	89 e5                	mov    %esp,%ebp
  800f83:	83 ec 0c             	sub    $0xc,%esp
  800f86:	89 1c 24             	mov    %ebx,(%esp)
  800f89:	89 74 24 04          	mov    %esi,0x4(%esp)
  800f8d:	89 7c 24 08          	mov    %edi,0x8(%esp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800f91:	b8 00 00 00 00       	mov    $0x0,%eax
  800f96:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f99:	8b 55 08             	mov    0x8(%ebp),%edx
  800f9c:	89 c3                	mov    %eax,%ebx
  800f9e:	89 c7                	mov    %eax,%edi
  800fa0:	89 c6                	mov    %eax,%esi
  800fa2:	cd 30                	int    $0x30

void
sys_cputs(const char *s, size_t len)
{
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800fa4:	8b 1c 24             	mov    (%esp),%ebx
  800fa7:	8b 74 24 04          	mov    0x4(%esp),%esi
  800fab:	8b 7c 24 08          	mov    0x8(%esp),%edi
  800faf:	89 ec                	mov    %ebp,%esp
  800fb1:	5d                   	pop    %ebp
  800fb2:	c3                   	ret    

00800fb3 <sys_page_insert>:
{
	return syscall(SYS_page_waste, 0, (uint32_t)p, (uint32_t)n, 0, 0,0);
}
int
sys_page_insert(envid_t envid, void *va, struct Page *p, int perm)
{
  800fb3:	55                   	push   %ebp
  800fb4:	89 e5                	mov    %esp,%ebp
  800fb6:	83 ec 38             	sub    $0x38,%esp
  800fb9:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800fbc:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800fbf:	89 7d fc             	mov    %edi,-0x4(%ebp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800fc2:	be 00 00 00 00       	mov    $0x0,%esi
  800fc7:	b8 12 00 00 00       	mov    $0x12,%eax
  800fcc:	8b 7d 14             	mov    0x14(%ebp),%edi
  800fcf:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800fd2:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800fd5:	8b 55 08             	mov    0x8(%ebp),%edx
  800fd8:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
	
	if(check && ret > 0)
  800fda:	85 c0                	test   %eax,%eax
  800fdc:	7e 28                	jle    801006 <sys_page_insert+0x53>
		panic("syscall %d returned %d (> 0)", num, ret);
  800fde:	89 44 24 10          	mov    %eax,0x10(%esp)
  800fe2:	c7 44 24 0c 12 00 00 	movl   $0x12,0xc(%esp)
  800fe9:	00 
  800fea:	c7 44 24 08 3f 30 80 	movl   $0x80303f,0x8(%esp)
  800ff1:	00 
  800ff2:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800ff9:	00 
  800ffa:	c7 04 24 5c 30 80 00 	movl   $0x80305c,(%esp)
  801001:	e8 02 f4 ff ff       	call   800408 <_panic>
}
int
sys_page_insert(envid_t envid, void *va, struct Page *p, int perm)
{
	return syscall(SYS_page_insert, 1, envid, (uint32_t) va, (uint32_t)p, perm, 0);
}
  801006:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  801009:	8b 75 f8             	mov    -0x8(%ebp),%esi
  80100c:	8b 7d fc             	mov    -0x4(%ebp),%edi
  80100f:	89 ec                	mov    %ebp,%esp
  801011:	5d                   	pop    %ebp
  801012:	c3                   	ret    

00801013 <sys_page_waste>:
{
	return (int)syscall(SYS_receive_packet, 0, (uint32_t)buffer, 0,0,0,0);
}

int sys_page_waste(struct Page **p, int n)
{
  801013:	55                   	push   %ebp
  801014:	89 e5                	mov    %esp,%ebp
  801016:	83 ec 0c             	sub    $0xc,%esp
  801019:	89 1c 24             	mov    %ebx,(%esp)
  80101c:	89 74 24 04          	mov    %esi,0x4(%esp)
  801020:	89 7c 24 08          	mov    %edi,0x8(%esp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801024:	bb 00 00 00 00       	mov    $0x0,%ebx
  801029:	b8 11 00 00 00       	mov    $0x11,%eax
  80102e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801031:	8b 55 08             	mov    0x8(%ebp),%edx
  801034:	89 df                	mov    %ebx,%edi
  801036:	89 de                	mov    %ebx,%esi
  801038:	cd 30                	int    $0x30
}

int sys_page_waste(struct Page **p, int n)
{
	return syscall(SYS_page_waste, 0, (uint32_t)p, (uint32_t)n, 0, 0,0);
}
  80103a:	8b 1c 24             	mov    (%esp),%ebx
  80103d:	8b 74 24 04          	mov    0x4(%esp),%esi
  801041:	8b 7c 24 08          	mov    0x8(%esp),%edi
  801045:	89 ec                	mov    %ebp,%esp
  801047:	5d                   	pop    %ebp
  801048:	c3                   	ret    

00801049 <sys_receive_packet>:
{
	return (int)syscall(SYS_transmit_packet, 1, (uint32_t)data, len, 0,0,0);
}

int sys_receive_packet(void* buffer)
{
  801049:	55                   	push   %ebp
  80104a:	89 e5                	mov    %esp,%ebp
  80104c:	83 ec 0c             	sub    $0xc,%esp
  80104f:	89 1c 24             	mov    %ebx,(%esp)
  801052:	89 74 24 04          	mov    %esi,0x4(%esp)
  801056:	89 7c 24 08          	mov    %edi,0x8(%esp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80105a:	b9 00 00 00 00       	mov    $0x0,%ecx
  80105f:	b8 10 00 00 00       	mov    $0x10,%eax
  801064:	8b 55 08             	mov    0x8(%ebp),%edx
  801067:	89 cb                	mov    %ecx,%ebx
  801069:	89 cf                	mov    %ecx,%edi
  80106b:	89 ce                	mov    %ecx,%esi
  80106d:	cd 30                	int    $0x30
}

int sys_receive_packet(void* buffer)
{
	return (int)syscall(SYS_receive_packet, 0, (uint32_t)buffer, 0,0,0,0);
}
  80106f:	8b 1c 24             	mov    (%esp),%ebx
  801072:	8b 74 24 04          	mov    0x4(%esp),%esi
  801076:	8b 7c 24 08          	mov    0x8(%esp),%edi
  80107a:	89 ec                	mov    %ebp,%esp
  80107c:	5d                   	pop    %ebp
  80107d:	c3                   	ret    

0080107e <sys_transmit_packet>:
{
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0,0);
}

int sys_transmit_packet(void* data, uint32_t len)
{
  80107e:	55                   	push   %ebp
  80107f:	89 e5                	mov    %esp,%ebp
  801081:	83 ec 38             	sub    $0x38,%esp
  801084:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  801087:	89 75 f8             	mov    %esi,-0x8(%ebp)
  80108a:	89 7d fc             	mov    %edi,-0x4(%ebp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80108d:	bb 00 00 00 00       	mov    $0x0,%ebx
  801092:	b8 0f 00 00 00       	mov    $0xf,%eax
  801097:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80109a:	8b 55 08             	mov    0x8(%ebp),%edx
  80109d:	89 df                	mov    %ebx,%edi
  80109f:	89 de                	mov    %ebx,%esi
  8010a1:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
	
	if(check && ret > 0)
  8010a3:	85 c0                	test   %eax,%eax
  8010a5:	7e 28                	jle    8010cf <sys_transmit_packet+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  8010a7:	89 44 24 10          	mov    %eax,0x10(%esp)
  8010ab:	c7 44 24 0c 0f 00 00 	movl   $0xf,0xc(%esp)
  8010b2:	00 
  8010b3:	c7 44 24 08 3f 30 80 	movl   $0x80303f,0x8(%esp)
  8010ba:	00 
  8010bb:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  8010c2:	00 
  8010c3:	c7 04 24 5c 30 80 00 	movl   $0x80305c,(%esp)
  8010ca:	e8 39 f3 ff ff       	call   800408 <_panic>
}

int sys_transmit_packet(void* data, uint32_t len)
{
	return (int)syscall(SYS_transmit_packet, 1, (uint32_t)data, len, 0,0,0);
}
  8010cf:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  8010d2:	8b 75 f8             	mov    -0x8(%ebp),%esi
  8010d5:	8b 7d fc             	mov    -0x4(%ebp),%edi
  8010d8:	89 ec                	mov    %ebp,%esp
  8010da:	5d                   	pop    %ebp
  8010db:	c3                   	ret    

008010dc <sys_time_msec>:
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}

unsigned int
sys_time_msec(void)
{
  8010dc:	55                   	push   %ebp
  8010dd:	89 e5                	mov    %esp,%ebp
  8010df:	83 ec 0c             	sub    $0xc,%esp
  8010e2:	89 1c 24             	mov    %ebx,(%esp)
  8010e5:	89 74 24 04          	mov    %esi,0x4(%esp)
  8010e9:	89 7c 24 08          	mov    %edi,0x8(%esp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8010ed:	ba 00 00 00 00       	mov    $0x0,%edx
  8010f2:	b8 0e 00 00 00       	mov    $0xe,%eax
  8010f7:	89 d1                	mov    %edx,%ecx
  8010f9:	89 d3                	mov    %edx,%ebx
  8010fb:	89 d7                	mov    %edx,%edi
  8010fd:	89 d6                	mov    %edx,%esi
  8010ff:	cd 30                	int    $0x30

unsigned int
sys_time_msec(void)
{
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0,0);
}
  801101:	8b 1c 24             	mov    (%esp),%ebx
  801104:	8b 74 24 04          	mov    0x4(%esp),%esi
  801108:	8b 7c 24 08          	mov    0x8(%esp),%edi
  80110c:	89 ec                	mov    %ebp,%esp
  80110e:	5d                   	pop    %ebp
  80110f:	c3                   	ret    

00801110 <sys_ipc_recv>:
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}

int
sys_ipc_recv(void *dstva)
{
  801110:	55                   	push   %ebp
  801111:	89 e5                	mov    %esp,%ebp
  801113:	83 ec 38             	sub    $0x38,%esp
  801116:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  801119:	89 75 f8             	mov    %esi,-0x8(%ebp)
  80111c:	89 7d fc             	mov    %edi,-0x4(%ebp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80111f:	b9 00 00 00 00       	mov    $0x0,%ecx
  801124:	b8 0d 00 00 00       	mov    $0xd,%eax
  801129:	8b 55 08             	mov    0x8(%ebp),%edx
  80112c:	89 cb                	mov    %ecx,%ebx
  80112e:	89 cf                	mov    %ecx,%edi
  801130:	89 ce                	mov    %ecx,%esi
  801132:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
	
	if(check && ret > 0)
  801134:	85 c0                	test   %eax,%eax
  801136:	7e 28                	jle    801160 <sys_ipc_recv+0x50>
		panic("syscall %d returned %d (> 0)", num, ret);
  801138:	89 44 24 10          	mov    %eax,0x10(%esp)
  80113c:	c7 44 24 0c 0d 00 00 	movl   $0xd,0xc(%esp)
  801143:	00 
  801144:	c7 44 24 08 3f 30 80 	movl   $0x80303f,0x8(%esp)
  80114b:	00 
  80114c:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  801153:	00 
  801154:	c7 04 24 5c 30 80 00 	movl   $0x80305c,(%esp)
  80115b:	e8 a8 f2 ff ff       	call   800408 <_panic>

int
sys_ipc_recv(void *dstva)
{
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  801160:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  801163:	8b 75 f8             	mov    -0x8(%ebp),%esi
  801166:	8b 7d fc             	mov    -0x4(%ebp),%edi
  801169:	89 ec                	mov    %ebp,%esp
  80116b:	5d                   	pop    %ebp
  80116c:	c3                   	ret    

0080116d <sys_ipc_try_send>:
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  80116d:	55                   	push   %ebp
  80116e:	89 e5                	mov    %esp,%ebp
  801170:	83 ec 0c             	sub    $0xc,%esp
  801173:	89 1c 24             	mov    %ebx,(%esp)
  801176:	89 74 24 04          	mov    %esi,0x4(%esp)
  80117a:	89 7c 24 08          	mov    %edi,0x8(%esp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80117e:	be 00 00 00 00       	mov    $0x0,%esi
  801183:	b8 0c 00 00 00       	mov    $0xc,%eax
  801188:	8b 7d 14             	mov    0x14(%ebp),%edi
  80118b:	8b 5d 10             	mov    0x10(%ebp),%ebx
  80118e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801191:	8b 55 08             	mov    0x8(%ebp),%edx
  801194:	cd 30                	int    $0x30

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  801196:	8b 1c 24             	mov    (%esp),%ebx
  801199:	8b 74 24 04          	mov    0x4(%esp),%esi
  80119d:	8b 7c 24 08          	mov    0x8(%esp),%edi
  8011a1:	89 ec                	mov    %ebp,%esp
  8011a3:	5d                   	pop    %ebp
  8011a4:	c3                   	ret    

008011a5 <sys_env_set_pgfault_upcall>:
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  8011a5:	55                   	push   %ebp
  8011a6:	89 e5                	mov    %esp,%ebp
  8011a8:	83 ec 38             	sub    $0x38,%esp
  8011ab:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  8011ae:	89 75 f8             	mov    %esi,-0x8(%ebp)
  8011b1:	89 7d fc             	mov    %edi,-0x4(%ebp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8011b4:	bb 00 00 00 00       	mov    $0x0,%ebx
  8011b9:	b8 0a 00 00 00       	mov    $0xa,%eax
  8011be:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8011c1:	8b 55 08             	mov    0x8(%ebp),%edx
  8011c4:	89 df                	mov    %ebx,%edi
  8011c6:	89 de                	mov    %ebx,%esi
  8011c8:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
	
	if(check && ret > 0)
  8011ca:	85 c0                	test   %eax,%eax
  8011cc:	7e 28                	jle    8011f6 <sys_env_set_pgfault_upcall+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  8011ce:	89 44 24 10          	mov    %eax,0x10(%esp)
  8011d2:	c7 44 24 0c 0a 00 00 	movl   $0xa,0xc(%esp)
  8011d9:	00 
  8011da:	c7 44 24 08 3f 30 80 	movl   $0x80303f,0x8(%esp)
  8011e1:	00 
  8011e2:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  8011e9:	00 
  8011ea:	c7 04 24 5c 30 80 00 	movl   $0x80305c,(%esp)
  8011f1:	e8 12 f2 ff ff       	call   800408 <_panic>

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  8011f6:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  8011f9:	8b 75 f8             	mov    -0x8(%ebp),%esi
  8011fc:	8b 7d fc             	mov    -0x4(%ebp),%edi
  8011ff:	89 ec                	mov    %ebp,%esp
  801201:	5d                   	pop    %ebp
  801202:	c3                   	ret    

00801203 <sys_env_set_trapframe>:
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  801203:	55                   	push   %ebp
  801204:	89 e5                	mov    %esp,%ebp
  801206:	83 ec 38             	sub    $0x38,%esp
  801209:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  80120c:	89 75 f8             	mov    %esi,-0x8(%ebp)
  80120f:	89 7d fc             	mov    %edi,-0x4(%ebp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801212:	bb 00 00 00 00       	mov    $0x0,%ebx
  801217:	b8 09 00 00 00       	mov    $0x9,%eax
  80121c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80121f:	8b 55 08             	mov    0x8(%ebp),%edx
  801222:	89 df                	mov    %ebx,%edi
  801224:	89 de                	mov    %ebx,%esi
  801226:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
	
	if(check && ret > 0)
  801228:	85 c0                	test   %eax,%eax
  80122a:	7e 28                	jle    801254 <sys_env_set_trapframe+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  80122c:	89 44 24 10          	mov    %eax,0x10(%esp)
  801230:	c7 44 24 0c 09 00 00 	movl   $0x9,0xc(%esp)
  801237:	00 
  801238:	c7 44 24 08 3f 30 80 	movl   $0x80303f,0x8(%esp)
  80123f:	00 
  801240:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  801247:	00 
  801248:	c7 04 24 5c 30 80 00 	movl   $0x80305c,(%esp)
  80124f:	e8 b4 f1 ff ff       	call   800408 <_panic>

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  801254:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  801257:	8b 75 f8             	mov    -0x8(%ebp),%esi
  80125a:	8b 7d fc             	mov    -0x4(%ebp),%edi
  80125d:	89 ec                	mov    %ebp,%esp
  80125f:	5d                   	pop    %ebp
  801260:	c3                   	ret    

00801261 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  801261:	55                   	push   %ebp
  801262:	89 e5                	mov    %esp,%ebp
  801264:	83 ec 38             	sub    $0x38,%esp
  801267:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  80126a:	89 75 f8             	mov    %esi,-0x8(%ebp)
  80126d:	89 7d fc             	mov    %edi,-0x4(%ebp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801270:	bb 00 00 00 00       	mov    $0x0,%ebx
  801275:	b8 08 00 00 00       	mov    $0x8,%eax
  80127a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80127d:	8b 55 08             	mov    0x8(%ebp),%edx
  801280:	89 df                	mov    %ebx,%edi
  801282:	89 de                	mov    %ebx,%esi
  801284:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
	
	if(check && ret > 0)
  801286:	85 c0                	test   %eax,%eax
  801288:	7e 28                	jle    8012b2 <sys_env_set_status+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  80128a:	89 44 24 10          	mov    %eax,0x10(%esp)
  80128e:	c7 44 24 0c 08 00 00 	movl   $0x8,0xc(%esp)
  801295:	00 
  801296:	c7 44 24 08 3f 30 80 	movl   $0x80303f,0x8(%esp)
  80129d:	00 
  80129e:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  8012a5:	00 
  8012a6:	c7 04 24 5c 30 80 00 	movl   $0x80305c,(%esp)
  8012ad:	e8 56 f1 ff ff       	call   800408 <_panic>

int
sys_env_set_status(envid_t envid, int status)
{
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  8012b2:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  8012b5:	8b 75 f8             	mov    -0x8(%ebp),%esi
  8012b8:	8b 7d fc             	mov    -0x4(%ebp),%edi
  8012bb:	89 ec                	mov    %ebp,%esp
  8012bd:	5d                   	pop    %ebp
  8012be:	c3                   	ret    

008012bf <sys_page_unmap>:
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}

int
sys_page_unmap(envid_t envid, void *va)
{
  8012bf:	55                   	push   %ebp
  8012c0:	89 e5                	mov    %esp,%ebp
  8012c2:	83 ec 38             	sub    $0x38,%esp
  8012c5:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  8012c8:	89 75 f8             	mov    %esi,-0x8(%ebp)
  8012cb:	89 7d fc             	mov    %edi,-0x4(%ebp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8012ce:	bb 00 00 00 00       	mov    $0x0,%ebx
  8012d3:	b8 06 00 00 00       	mov    $0x6,%eax
  8012d8:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8012db:	8b 55 08             	mov    0x8(%ebp),%edx
  8012de:	89 df                	mov    %ebx,%edi
  8012e0:	89 de                	mov    %ebx,%esi
  8012e2:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
	
	if(check && ret > 0)
  8012e4:	85 c0                	test   %eax,%eax
  8012e6:	7e 28                	jle    801310 <sys_page_unmap+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  8012e8:	89 44 24 10          	mov    %eax,0x10(%esp)
  8012ec:	c7 44 24 0c 06 00 00 	movl   $0x6,0xc(%esp)
  8012f3:	00 
  8012f4:	c7 44 24 08 3f 30 80 	movl   $0x80303f,0x8(%esp)
  8012fb:	00 
  8012fc:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  801303:	00 
  801304:	c7 04 24 5c 30 80 00 	movl   $0x80305c,(%esp)
  80130b:	e8 f8 f0 ff ff       	call   800408 <_panic>

int
sys_page_unmap(envid_t envid, void *va)
{
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  801310:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  801313:	8b 75 f8             	mov    -0x8(%ebp),%esi
  801316:	8b 7d fc             	mov    -0x4(%ebp),%edi
  801319:	89 ec                	mov    %ebp,%esp
  80131b:	5d                   	pop    %ebp
  80131c:	c3                   	ret    

0080131d <sys_page_map>:
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  80131d:	55                   	push   %ebp
  80131e:	89 e5                	mov    %esp,%ebp
  801320:	83 ec 38             	sub    $0x38,%esp
  801323:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  801326:	89 75 f8             	mov    %esi,-0x8(%ebp)
  801329:	89 7d fc             	mov    %edi,-0x4(%ebp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80132c:	b8 05 00 00 00       	mov    $0x5,%eax
  801331:	8b 75 18             	mov    0x18(%ebp),%esi
  801334:	8b 7d 14             	mov    0x14(%ebp),%edi
  801337:	8b 5d 10             	mov    0x10(%ebp),%ebx
  80133a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80133d:	8b 55 08             	mov    0x8(%ebp),%edx
  801340:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
	
	if(check && ret > 0)
  801342:	85 c0                	test   %eax,%eax
  801344:	7e 28                	jle    80136e <sys_page_map+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  801346:	89 44 24 10          	mov    %eax,0x10(%esp)
  80134a:	c7 44 24 0c 05 00 00 	movl   $0x5,0xc(%esp)
  801351:	00 
  801352:	c7 44 24 08 3f 30 80 	movl   $0x80303f,0x8(%esp)
  801359:	00 
  80135a:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  801361:	00 
  801362:	c7 04 24 5c 30 80 00 	movl   $0x80305c,(%esp)
  801369:	e8 9a f0 ff ff       	call   800408 <_panic>

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  80136e:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  801371:	8b 75 f8             	mov    -0x8(%ebp),%esi
  801374:	8b 7d fc             	mov    -0x4(%ebp),%edi
  801377:	89 ec                	mov    %ebp,%esp
  801379:	5d                   	pop    %ebp
  80137a:	c3                   	ret    

0080137b <sys_page_alloc>:
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  80137b:	55                   	push   %ebp
  80137c:	89 e5                	mov    %esp,%ebp
  80137e:	83 ec 38             	sub    $0x38,%esp
  801381:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  801384:	89 75 f8             	mov    %esi,-0x8(%ebp)
  801387:	89 7d fc             	mov    %edi,-0x4(%ebp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80138a:	be 00 00 00 00       	mov    $0x0,%esi
  80138f:	b8 04 00 00 00       	mov    $0x4,%eax
  801394:	8b 5d 10             	mov    0x10(%ebp),%ebx
  801397:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80139a:	8b 55 08             	mov    0x8(%ebp),%edx
  80139d:	89 f7                	mov    %esi,%edi
  80139f:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
	
	if(check && ret > 0)
  8013a1:	85 c0                	test   %eax,%eax
  8013a3:	7e 28                	jle    8013cd <sys_page_alloc+0x52>
		panic("syscall %d returned %d (> 0)", num, ret);
  8013a5:	89 44 24 10          	mov    %eax,0x10(%esp)
  8013a9:	c7 44 24 0c 04 00 00 	movl   $0x4,0xc(%esp)
  8013b0:	00 
  8013b1:	c7 44 24 08 3f 30 80 	movl   $0x80303f,0x8(%esp)
  8013b8:	00 
  8013b9:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  8013c0:	00 
  8013c1:	c7 04 24 5c 30 80 00 	movl   $0x80305c,(%esp)
  8013c8:	e8 3b f0 ff ff       	call   800408 <_panic>

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  8013cd:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  8013d0:	8b 75 f8             	mov    -0x8(%ebp),%esi
  8013d3:	8b 7d fc             	mov    -0x4(%ebp),%edi
  8013d6:	89 ec                	mov    %ebp,%esp
  8013d8:	5d                   	pop    %ebp
  8013d9:	c3                   	ret    

008013da <sys_yield>:
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}

void
sys_yield(void)
{
  8013da:	55                   	push   %ebp
  8013db:	89 e5                	mov    %esp,%ebp
  8013dd:	83 ec 0c             	sub    $0xc,%esp
  8013e0:	89 1c 24             	mov    %ebx,(%esp)
  8013e3:	89 74 24 04          	mov    %esi,0x4(%esp)
  8013e7:	89 7c 24 08          	mov    %edi,0x8(%esp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8013eb:	ba 00 00 00 00       	mov    $0x0,%edx
  8013f0:	b8 0b 00 00 00       	mov    $0xb,%eax
  8013f5:	89 d1                	mov    %edx,%ecx
  8013f7:	89 d3                	mov    %edx,%ebx
  8013f9:	89 d7                	mov    %edx,%edi
  8013fb:	89 d6                	mov    %edx,%esi
  8013fd:	cd 30                	int    $0x30

void
sys_yield(void)
{
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  8013ff:	8b 1c 24             	mov    (%esp),%ebx
  801402:	8b 74 24 04          	mov    0x4(%esp),%esi
  801406:	8b 7c 24 08          	mov    0x8(%esp),%edi
  80140a:	89 ec                	mov    %ebp,%esp
  80140c:	5d                   	pop    %ebp
  80140d:	c3                   	ret    

0080140e <sys_getenvid>:
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}

envid_t
sys_getenvid(void)
{
  80140e:	55                   	push   %ebp
  80140f:	89 e5                	mov    %esp,%ebp
  801411:	83 ec 0c             	sub    $0xc,%esp
  801414:	89 1c 24             	mov    %ebx,(%esp)
  801417:	89 74 24 04          	mov    %esi,0x4(%esp)
  80141b:	89 7c 24 08          	mov    %edi,0x8(%esp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80141f:	ba 00 00 00 00       	mov    $0x0,%edx
  801424:	b8 02 00 00 00       	mov    $0x2,%eax
  801429:	89 d1                	mov    %edx,%ecx
  80142b:	89 d3                	mov    %edx,%ebx
  80142d:	89 d7                	mov    %edx,%edi
  80142f:	89 d6                	mov    %edx,%esi
  801431:	cd 30                	int    $0x30

envid_t
sys_getenvid(void)
{
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  801433:	8b 1c 24             	mov    (%esp),%ebx
  801436:	8b 74 24 04          	mov    0x4(%esp),%esi
  80143a:	8b 7c 24 08          	mov    0x8(%esp),%edi
  80143e:	89 ec                	mov    %ebp,%esp
  801440:	5d                   	pop    %ebp
  801441:	c3                   	ret    

00801442 <sys_env_destroy>:
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}

int
sys_env_destroy(envid_t envid)
{
  801442:	55                   	push   %ebp
  801443:	89 e5                	mov    %esp,%ebp
  801445:	83 ec 38             	sub    $0x38,%esp
  801448:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  80144b:	89 75 f8             	mov    %esi,-0x8(%ebp)
  80144e:	89 7d fc             	mov    %edi,-0x4(%ebp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801451:	b9 00 00 00 00       	mov    $0x0,%ecx
  801456:	b8 03 00 00 00       	mov    $0x3,%eax
  80145b:	8b 55 08             	mov    0x8(%ebp),%edx
  80145e:	89 cb                	mov    %ecx,%ebx
  801460:	89 cf                	mov    %ecx,%edi
  801462:	89 ce                	mov    %ecx,%esi
  801464:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
	
	if(check && ret > 0)
  801466:	85 c0                	test   %eax,%eax
  801468:	7e 28                	jle    801492 <sys_env_destroy+0x50>
		panic("syscall %d returned %d (> 0)", num, ret);
  80146a:	89 44 24 10          	mov    %eax,0x10(%esp)
  80146e:	c7 44 24 0c 03 00 00 	movl   $0x3,0xc(%esp)
  801475:	00 
  801476:	c7 44 24 08 3f 30 80 	movl   $0x80303f,0x8(%esp)
  80147d:	00 
  80147e:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  801485:	00 
  801486:	c7 04 24 5c 30 80 00 	movl   $0x80305c,(%esp)
  80148d:	e8 76 ef ff ff       	call   800408 <_panic>

int
sys_env_destroy(envid_t envid)
{
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  801492:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  801495:	8b 75 f8             	mov    -0x8(%ebp),%esi
  801498:	8b 7d fc             	mov    -0x4(%ebp),%edi
  80149b:	89 ec                	mov    %ebp,%esp
  80149d:	5d                   	pop    %ebp
  80149e:	c3                   	ret    
	...

008014a0 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  8014a0:	55                   	push   %ebp
  8014a1:	89 e5                	mov    %esp,%ebp
  8014a3:	8b 45 08             	mov    0x8(%ebp),%eax
  8014a6:	05 00 00 00 30       	add    $0x30000000,%eax
  8014ab:	c1 e8 0c             	shr    $0xc,%eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
}
  8014ae:	5d                   	pop    %ebp
  8014af:	c3                   	ret    

008014b0 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  8014b0:	55                   	push   %ebp
  8014b1:	89 e5                	mov    %esp,%ebp
  8014b3:	83 ec 04             	sub    $0x4,%esp
	return INDEX2DATA(fd2num(fd));
  8014b6:	8b 45 08             	mov    0x8(%ebp),%eax
  8014b9:	89 04 24             	mov    %eax,(%esp)
  8014bc:	e8 df ff ff ff       	call   8014a0 <fd2num>
  8014c1:	05 20 00 0d 00       	add    $0xd0020,%eax
  8014c6:	c1 e0 0c             	shl    $0xc,%eax
}
  8014c9:	c9                   	leave  
  8014ca:	c3                   	ret    

008014cb <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  8014cb:	55                   	push   %ebp
  8014cc:	89 e5                	mov    %esp,%ebp
  8014ce:	57                   	push   %edi
  8014cf:	56                   	push   %esi
  8014d0:	53                   	push   %ebx
  8014d1:	8b 7d 08             	mov    0x8(%ebp),%edi
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((vpd[PDX(fd)] & PTE_P) == 0 || (vpt[VPN(fd)] & PTE_P) == 0) {
  8014d4:	a1 00 dd 7b ef       	mov    0xef7bdd00,%eax
  8014d9:	a8 01                	test   $0x1,%al
  8014db:	74 36                	je     801513 <fd_alloc+0x48>
  8014dd:	a1 00 00 74 ef       	mov    0xef740000,%eax
  8014e2:	a8 01                	test   $0x1,%al
  8014e4:	74 2d                	je     801513 <fd_alloc+0x48>
  8014e6:	b8 00 10 00 d0       	mov    $0xd0001000,%eax
  8014eb:	b9 00 d0 7b ef       	mov    $0xef7bd000,%ecx
  8014f0:	be 00 00 40 ef       	mov    $0xef400000,%esi
  8014f5:	89 c3                	mov    %eax,%ebx
  8014f7:	89 c2                	mov    %eax,%edx
  8014f9:	c1 ea 16             	shr    $0x16,%edx
  8014fc:	8b 14 91             	mov    (%ecx,%edx,4),%edx
  8014ff:	f6 c2 01             	test   $0x1,%dl
  801502:	74 14                	je     801518 <fd_alloc+0x4d>
  801504:	89 c2                	mov    %eax,%edx
  801506:	c1 ea 0c             	shr    $0xc,%edx
  801509:	8b 14 96             	mov    (%esi,%edx,4),%edx
  80150c:	f6 c2 01             	test   $0x1,%dl
  80150f:	75 10                	jne    801521 <fd_alloc+0x56>
  801511:	eb 05                	jmp    801518 <fd_alloc+0x4d>
  801513:	bb 00 00 00 d0       	mov    $0xd0000000,%ebx
			*fd_store = fd;
  801518:	89 1f                	mov    %ebx,(%edi)
  80151a:	b8 00 00 00 00       	mov    $0x0,%eax
			return 0;
  80151f:	eb 17                	jmp    801538 <fd_alloc+0x6d>
  801521:	05 00 10 00 00       	add    $0x1000,%eax
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  801526:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  80152b:	75 c8                	jne    8014f5 <fd_alloc+0x2a>
		if ((vpd[PDX(fd)] & PTE_P) == 0 || (vpt[VPN(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  80152d:	c7 07 00 00 00 00    	movl   $0x0,(%edi)
  801533:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
	return -E_MAX_OPEN;
}
  801538:	5b                   	pop    %ebx
  801539:	5e                   	pop    %esi
  80153a:	5f                   	pop    %edi
  80153b:	5d                   	pop    %ebp
  80153c:	c3                   	ret    

0080153d <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  80153d:	55                   	push   %ebp
  80153e:	89 e5                	mov    %esp,%ebp
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  801540:	8b 45 08             	mov    0x8(%ebp),%eax
  801543:	83 f8 1f             	cmp    $0x1f,%eax
  801546:	77 36                	ja     80157e <fd_lookup+0x41>
		if (debug)
			cprintf("[%08x] bad fd %d\n", env->env_id, fd);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  801548:	05 00 00 0d 00       	add    $0xd0000,%eax
  80154d:	c1 e0 0c             	shl    $0xc,%eax
	if (!(vpd[PDX(fd)] & PTE_P) || !(vpt[VPN(fd)] & PTE_P)) {
  801550:	89 c2                	mov    %eax,%edx
  801552:	c1 ea 16             	shr    $0x16,%edx
  801555:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  80155c:	f6 c2 01             	test   $0x1,%dl
  80155f:	74 1d                	je     80157e <fd_lookup+0x41>
  801561:	89 c2                	mov    %eax,%edx
  801563:	c1 ea 0c             	shr    $0xc,%edx
  801566:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  80156d:	f6 c2 01             	test   $0x1,%dl
  801570:	74 0c                	je     80157e <fd_lookup+0x41>
		if (debug)
			cprintf("[%08x] closed fd %d\n", env->env_id, fd);
		return -E_INVAL;
	}
	*fd_store = fd;
  801572:	8b 55 0c             	mov    0xc(%ebp),%edx
  801575:	89 02                	mov    %eax,(%edx)
  801577:	b8 00 00 00 00       	mov    $0x0,%eax
	return 0;
  80157c:	eb 05                	jmp    801583 <fd_lookup+0x46>
  80157e:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  801583:	5d                   	pop    %ebp
  801584:	c3                   	ret    

00801585 <seek>:
	return (*dev->dev_write)(fd, buf, n);
}

int
seek(int fdnum, off_t offset)
{
  801585:	55                   	push   %ebp
  801586:	89 e5                	mov    %esp,%ebp
  801588:	83 ec 18             	sub    $0x18,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80158b:	8d 45 fc             	lea    -0x4(%ebp),%eax
  80158e:	89 44 24 04          	mov    %eax,0x4(%esp)
  801592:	8b 45 08             	mov    0x8(%ebp),%eax
  801595:	89 04 24             	mov    %eax,(%esp)
  801598:	e8 a0 ff ff ff       	call   80153d <fd_lookup>
  80159d:	85 c0                	test   %eax,%eax
  80159f:	78 0e                	js     8015af <seek+0x2a>
		return r;
	fd->fd_offset = offset;
  8015a1:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8015a4:	8b 55 0c             	mov    0xc(%ebp),%edx
  8015a7:	89 50 04             	mov    %edx,0x4(%eax)
  8015aa:	b8 00 00 00 00       	mov    $0x0,%eax
	return 0;
}
  8015af:	c9                   	leave  
  8015b0:	c3                   	ret    

008015b1 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  8015b1:	55                   	push   %ebp
  8015b2:	89 e5                	mov    %esp,%ebp
  8015b4:	56                   	push   %esi
  8015b5:	53                   	push   %ebx
  8015b6:	83 ec 10             	sub    $0x10,%esp
  8015b9:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8015bc:	8b 5d 0c             	mov    0xc(%ebp),%ebx
// File functions
// --------------------------------------------------------------

static struct Dev *devtab[] =
{
	&devfile,
  8015bf:	b8 04 70 80 00       	mov    $0x807004,%eax
{
	int i;
	for (i = 0; devtab[i]; i++)
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
  8015c4:	ba 00 00 00 00       	mov    $0x0,%edx

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  8015c9:	be e8 30 80 00       	mov    $0x8030e8,%esi
		if (devtab[i]->dev_id == dev_id) {
  8015ce:	39 08                	cmp    %ecx,(%eax)
  8015d0:	75 10                	jne    8015e2 <dev_lookup+0x31>
  8015d2:	eb 04                	jmp    8015d8 <dev_lookup+0x27>
  8015d4:	39 08                	cmp    %ecx,(%eax)
  8015d6:	75 0a                	jne    8015e2 <dev_lookup+0x31>
			*dev = devtab[i];
  8015d8:	89 03                	mov    %eax,(%ebx)
  8015da:	b8 00 00 00 00       	mov    $0x0,%eax
			return 0;
  8015df:	90                   	nop
  8015e0:	eb 31                	jmp    801613 <dev_lookup+0x62>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  8015e2:	83 c2 01             	add    $0x1,%edx
  8015e5:	8b 04 96             	mov    (%esi,%edx,4),%eax
  8015e8:	85 c0                	test   %eax,%eax
  8015ea:	75 e8                	jne    8015d4 <dev_lookup+0x23>
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", env->env_id, dev_id);
  8015ec:	a1 80 74 80 00       	mov    0x807480,%eax
  8015f1:	8b 40 4c             	mov    0x4c(%eax),%eax
  8015f4:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8015f8:	89 44 24 04          	mov    %eax,0x4(%esp)
  8015fc:	c7 04 24 6c 30 80 00 	movl   $0x80306c,(%esp)
  801603:	e8 c5 ee ff ff       	call   8004cd <cprintf>
	*dev = 0;
  801608:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  80160e:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
	return -E_INVAL;
}
  801613:	83 c4 10             	add    $0x10,%esp
  801616:	5b                   	pop    %ebx
  801617:	5e                   	pop    %esi
  801618:	5d                   	pop    %ebp
  801619:	c3                   	ret    

0080161a <fstat>:
	return (*dev->dev_trunc)(fd, newsize);
}

int
fstat(int fdnum, struct Stat *stat)
{
  80161a:	55                   	push   %ebp
  80161b:	89 e5                	mov    %esp,%ebp
  80161d:	53                   	push   %ebx
  80161e:	83 ec 24             	sub    $0x24,%esp
  801621:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801624:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801627:	89 44 24 04          	mov    %eax,0x4(%esp)
  80162b:	8b 45 08             	mov    0x8(%ebp),%eax
  80162e:	89 04 24             	mov    %eax,(%esp)
  801631:	e8 07 ff ff ff       	call   80153d <fd_lookup>
  801636:	85 c0                	test   %eax,%eax
  801638:	78 53                	js     80168d <fstat+0x73>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80163a:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80163d:	89 44 24 04          	mov    %eax,0x4(%esp)
  801641:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801644:	8b 00                	mov    (%eax),%eax
  801646:	89 04 24             	mov    %eax,(%esp)
  801649:	e8 63 ff ff ff       	call   8015b1 <dev_lookup>
{
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80164e:	85 c0                	test   %eax,%eax
  801650:	78 3b                	js     80168d <fstat+0x73>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if (!dev->dev_stat)
  801652:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801657:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80165a:	83 7a 14 00          	cmpl   $0x0,0x14(%edx)
  80165e:	74 2d                	je     80168d <fstat+0x73>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  801660:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  801663:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  80166a:	00 00 00 
	stat->st_isdir = 0;
  80166d:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801674:	00 00 00 
	stat->st_dev = dev;
  801677:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80167a:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  801680:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801684:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801687:	89 14 24             	mov    %edx,(%esp)
  80168a:	ff 50 14             	call   *0x14(%eax)
}
  80168d:	83 c4 24             	add    $0x24,%esp
  801690:	5b                   	pop    %ebx
  801691:	5d                   	pop    %ebp
  801692:	c3                   	ret    

00801693 <ftruncate>:
	return 0;
}

int
ftruncate(int fdnum, off_t newsize)
{
  801693:	55                   	push   %ebp
  801694:	89 e5                	mov    %esp,%ebp
  801696:	53                   	push   %ebx
  801697:	83 ec 24             	sub    $0x24,%esp
  80169a:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  80169d:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8016a0:	89 44 24 04          	mov    %eax,0x4(%esp)
  8016a4:	89 1c 24             	mov    %ebx,(%esp)
  8016a7:	e8 91 fe ff ff       	call   80153d <fd_lookup>
  8016ac:	85 c0                	test   %eax,%eax
  8016ae:	78 5f                	js     80170f <ftruncate+0x7c>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8016b0:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8016b3:	89 44 24 04          	mov    %eax,0x4(%esp)
  8016b7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8016ba:	8b 00                	mov    (%eax),%eax
  8016bc:	89 04 24             	mov    %eax,(%esp)
  8016bf:	e8 ed fe ff ff       	call   8015b1 <dev_lookup>
ftruncate(int fdnum, off_t newsize)
{
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  8016c4:	85 c0                	test   %eax,%eax
  8016c6:	78 47                	js     80170f <ftruncate+0x7c>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8016c8:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8016cb:	f6 42 08 03          	testb  $0x3,0x8(%edx)
  8016cf:	75 23                	jne    8016f4 <ftruncate+0x61>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			env->env_id, fdnum); 
  8016d1:	a1 80 74 80 00       	mov    0x807480,%eax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  8016d6:	8b 40 4c             	mov    0x4c(%eax),%eax
  8016d9:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8016dd:	89 44 24 04          	mov    %eax,0x4(%esp)
  8016e1:	c7 04 24 8c 30 80 00 	movl   $0x80308c,(%esp)
  8016e8:	e8 e0 ed ff ff       	call   8004cd <cprintf>
  8016ed:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
			env->env_id, fdnum); 
		return -E_INVAL;
  8016f2:	eb 1b                	jmp    80170f <ftruncate+0x7c>
	}
	if (!dev->dev_trunc)
  8016f4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8016f7:	8b 48 18             	mov    0x18(%eax),%ecx
  8016fa:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8016ff:	85 c9                	test   %ecx,%ecx
  801701:	74 0c                	je     80170f <ftruncate+0x7c>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  801703:	8b 45 0c             	mov    0xc(%ebp),%eax
  801706:	89 44 24 04          	mov    %eax,0x4(%esp)
  80170a:	89 14 24             	mov    %edx,(%esp)
  80170d:	ff d1                	call   *%ecx
}
  80170f:	83 c4 24             	add    $0x24,%esp
  801712:	5b                   	pop    %ebx
  801713:	5d                   	pop    %ebp
  801714:	c3                   	ret    

00801715 <write>:
	return tot;
}

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  801715:	55                   	push   %ebp
  801716:	89 e5                	mov    %esp,%ebp
  801718:	53                   	push   %ebx
  801719:	83 ec 24             	sub    $0x24,%esp
  80171c:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80171f:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801722:	89 44 24 04          	mov    %eax,0x4(%esp)
  801726:	89 1c 24             	mov    %ebx,(%esp)
  801729:	e8 0f fe ff ff       	call   80153d <fd_lookup>
  80172e:	85 c0                	test   %eax,%eax
  801730:	78 66                	js     801798 <write+0x83>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801732:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801735:	89 44 24 04          	mov    %eax,0x4(%esp)
  801739:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80173c:	8b 00                	mov    (%eax),%eax
  80173e:	89 04 24             	mov    %eax,(%esp)
  801741:	e8 6b fe ff ff       	call   8015b1 <dev_lookup>
{
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801746:	85 c0                	test   %eax,%eax
  801748:	78 4e                	js     801798 <write+0x83>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  80174a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80174d:	f6 42 08 03          	testb  $0x3,0x8(%edx)
  801751:	75 23                	jne    801776 <write+0x61>
		cprintf("[%08x] write %d -- bad mode\n", env->env_id, fdnum);
  801753:	a1 80 74 80 00       	mov    0x807480,%eax
  801758:	8b 40 4c             	mov    0x4c(%eax),%eax
  80175b:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80175f:	89 44 24 04          	mov    %eax,0x4(%esp)
  801763:	c7 04 24 ad 30 80 00 	movl   $0x8030ad,(%esp)
  80176a:	e8 5e ed ff ff       	call   8004cd <cprintf>
  80176f:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
		return -E_INVAL;
  801774:	eb 22                	jmp    801798 <write+0x83>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  801776:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801779:	8b 48 0c             	mov    0xc(%eax),%ecx
  80177c:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801781:	85 c9                	test   %ecx,%ecx
  801783:	74 13                	je     801798 <write+0x83>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  801785:	8b 45 10             	mov    0x10(%ebp),%eax
  801788:	89 44 24 08          	mov    %eax,0x8(%esp)
  80178c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80178f:	89 44 24 04          	mov    %eax,0x4(%esp)
  801793:	89 14 24             	mov    %edx,(%esp)
  801796:	ff d1                	call   *%ecx
}
  801798:	83 c4 24             	add    $0x24,%esp
  80179b:	5b                   	pop    %ebx
  80179c:	5d                   	pop    %ebp
  80179d:	c3                   	ret    

0080179e <read>:
	return r;
}

ssize_t
read(int fdnum, void *buf, size_t n)
{
  80179e:	55                   	push   %ebp
  80179f:	89 e5                	mov    %esp,%ebp
  8017a1:	53                   	push   %ebx
  8017a2:	83 ec 24             	sub    $0x24,%esp
  8017a5:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8017a8:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8017ab:	89 44 24 04          	mov    %eax,0x4(%esp)
  8017af:	89 1c 24             	mov    %ebx,(%esp)
  8017b2:	e8 86 fd ff ff       	call   80153d <fd_lookup>
  8017b7:	85 c0                	test   %eax,%eax
  8017b9:	78 6b                	js     801826 <read+0x88>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8017bb:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8017be:	89 44 24 04          	mov    %eax,0x4(%esp)
  8017c2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8017c5:	8b 00                	mov    (%eax),%eax
  8017c7:	89 04 24             	mov    %eax,(%esp)
  8017ca:	e8 e2 fd ff ff       	call   8015b1 <dev_lookup>
{
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8017cf:	85 c0                	test   %eax,%eax
  8017d1:	78 53                	js     801826 <read+0x88>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  8017d3:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8017d6:	8b 42 08             	mov    0x8(%edx),%eax
  8017d9:	83 e0 03             	and    $0x3,%eax
  8017dc:	83 f8 01             	cmp    $0x1,%eax
  8017df:	75 23                	jne    801804 <read+0x66>
		cprintf("[%08x] read %d -- bad mode\n", env->env_id, fdnum); 
  8017e1:	a1 80 74 80 00       	mov    0x807480,%eax
  8017e6:	8b 40 4c             	mov    0x4c(%eax),%eax
  8017e9:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8017ed:	89 44 24 04          	mov    %eax,0x4(%esp)
  8017f1:	c7 04 24 ca 30 80 00 	movl   $0x8030ca,(%esp)
  8017f8:	e8 d0 ec ff ff       	call   8004cd <cprintf>
  8017fd:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
		return -E_INVAL;
  801802:	eb 22                	jmp    801826 <read+0x88>
	}
	if (!dev->dev_read)
  801804:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801807:	8b 48 08             	mov    0x8(%eax),%ecx
  80180a:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  80180f:	85 c9                	test   %ecx,%ecx
  801811:	74 13                	je     801826 <read+0x88>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  801813:	8b 45 10             	mov    0x10(%ebp),%eax
  801816:	89 44 24 08          	mov    %eax,0x8(%esp)
  80181a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80181d:	89 44 24 04          	mov    %eax,0x4(%esp)
  801821:	89 14 24             	mov    %edx,(%esp)
  801824:	ff d1                	call   *%ecx
}
  801826:	83 c4 24             	add    $0x24,%esp
  801829:	5b                   	pop    %ebx
  80182a:	5d                   	pop    %ebp
  80182b:	c3                   	ret    

0080182c <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  80182c:	55                   	push   %ebp
  80182d:	89 e5                	mov    %esp,%ebp
  80182f:	57                   	push   %edi
  801830:	56                   	push   %esi
  801831:	53                   	push   %ebx
  801832:	83 ec 1c             	sub    $0x1c,%esp
  801835:	8b 7d 08             	mov    0x8(%ebp),%edi
  801838:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  80183b:	ba 00 00 00 00       	mov    $0x0,%edx
  801840:	bb 00 00 00 00       	mov    $0x0,%ebx
  801845:	b8 00 00 00 00       	mov    $0x0,%eax
  80184a:	85 f6                	test   %esi,%esi
  80184c:	74 29                	je     801877 <readn+0x4b>
		m = read(fdnum, (char*)buf + tot, n - tot);
  80184e:	89 f0                	mov    %esi,%eax
  801850:	29 d0                	sub    %edx,%eax
  801852:	89 44 24 08          	mov    %eax,0x8(%esp)
  801856:	03 55 0c             	add    0xc(%ebp),%edx
  801859:	89 54 24 04          	mov    %edx,0x4(%esp)
  80185d:	89 3c 24             	mov    %edi,(%esp)
  801860:	e8 39 ff ff ff       	call   80179e <read>
		if (m < 0)
  801865:	85 c0                	test   %eax,%eax
  801867:	78 0e                	js     801877 <readn+0x4b>
			return m;
		if (m == 0)
  801869:	85 c0                	test   %eax,%eax
  80186b:	74 08                	je     801875 <readn+0x49>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  80186d:	01 c3                	add    %eax,%ebx
  80186f:	89 da                	mov    %ebx,%edx
  801871:	39 f3                	cmp    %esi,%ebx
  801873:	72 d9                	jb     80184e <readn+0x22>
  801875:	89 d8                	mov    %ebx,%eax
			return m;
		if (m == 0)
			break;
	}
	return tot;
}
  801877:	83 c4 1c             	add    $0x1c,%esp
  80187a:	5b                   	pop    %ebx
  80187b:	5e                   	pop    %esi
  80187c:	5f                   	pop    %edi
  80187d:	5d                   	pop    %ebp
  80187e:	c3                   	ret    

0080187f <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  80187f:	55                   	push   %ebp
  801880:	89 e5                	mov    %esp,%ebp
  801882:	56                   	push   %esi
  801883:	53                   	push   %ebx
  801884:	83 ec 20             	sub    $0x20,%esp
  801887:	8b 75 08             	mov    0x8(%ebp),%esi
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  80188a:	89 34 24             	mov    %esi,(%esp)
  80188d:	e8 0e fc ff ff       	call   8014a0 <fd2num>
  801892:	8d 55 f4             	lea    -0xc(%ebp),%edx
  801895:	89 54 24 04          	mov    %edx,0x4(%esp)
  801899:	89 04 24             	mov    %eax,(%esp)
  80189c:	e8 9c fc ff ff       	call   80153d <fd_lookup>
  8018a1:	89 c3                	mov    %eax,%ebx
  8018a3:	85 c0                	test   %eax,%eax
  8018a5:	78 05                	js     8018ac <fd_close+0x2d>
  8018a7:	3b 75 f4             	cmp    -0xc(%ebp),%esi
  8018aa:	74 0c                	je     8018b8 <fd_close+0x39>
	    || fd != fd2)
		return (must_exist ? r : 0);
  8018ac:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8018b0:	19 c0                	sbb    %eax,%eax
  8018b2:	f7 d0                	not    %eax
  8018b4:	21 c3                	and    %eax,%ebx
  8018b6:	eb 3d                	jmp    8018f5 <fd_close+0x76>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  8018b8:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8018bb:	89 44 24 04          	mov    %eax,0x4(%esp)
  8018bf:	8b 06                	mov    (%esi),%eax
  8018c1:	89 04 24             	mov    %eax,(%esp)
  8018c4:	e8 e8 fc ff ff       	call   8015b1 <dev_lookup>
  8018c9:	89 c3                	mov    %eax,%ebx
  8018cb:	85 c0                	test   %eax,%eax
  8018cd:	78 16                	js     8018e5 <fd_close+0x66>
		if (dev->dev_close)
  8018cf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8018d2:	8b 40 10             	mov    0x10(%eax),%eax
  8018d5:	bb 00 00 00 00       	mov    $0x0,%ebx
  8018da:	85 c0                	test   %eax,%eax
  8018dc:	74 07                	je     8018e5 <fd_close+0x66>
			r = (*dev->dev_close)(fd);
  8018de:	89 34 24             	mov    %esi,(%esp)
  8018e1:	ff d0                	call   *%eax
  8018e3:	89 c3                	mov    %eax,%ebx
		else
			r = 0;
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  8018e5:	89 74 24 04          	mov    %esi,0x4(%esp)
  8018e9:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8018f0:	e8 ca f9 ff ff       	call   8012bf <sys_page_unmap>
	return r;
}
  8018f5:	89 d8                	mov    %ebx,%eax
  8018f7:	83 c4 20             	add    $0x20,%esp
  8018fa:	5b                   	pop    %ebx
  8018fb:	5e                   	pop    %esi
  8018fc:	5d                   	pop    %ebp
  8018fd:	c3                   	ret    

008018fe <close>:
	return -E_INVAL;
}

int
close(int fdnum)
{
  8018fe:	55                   	push   %ebp
  8018ff:	89 e5                	mov    %esp,%ebp
  801901:	83 ec 28             	sub    $0x28,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801904:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801907:	89 44 24 04          	mov    %eax,0x4(%esp)
  80190b:	8b 45 08             	mov    0x8(%ebp),%eax
  80190e:	89 04 24             	mov    %eax,(%esp)
  801911:	e8 27 fc ff ff       	call   80153d <fd_lookup>
  801916:	85 c0                	test   %eax,%eax
  801918:	78 13                	js     80192d <close+0x2f>
		return r;
	else
		return fd_close(fd, 1);
  80191a:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  801921:	00 
  801922:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801925:	89 04 24             	mov    %eax,(%esp)
  801928:	e8 52 ff ff ff       	call   80187f <fd_close>
}
  80192d:	c9                   	leave  
  80192e:	c3                   	ret    

0080192f <stat>:
	return (*dev->dev_stat)(fd, stat);
}

int
stat(const char *path, struct Stat *stat)
{
  80192f:	55                   	push   %ebp
  801930:	89 e5                	mov    %esp,%ebp
  801932:	83 ec 18             	sub    $0x18,%esp
  801935:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  801938:	89 75 fc             	mov    %esi,-0x4(%ebp)
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  80193b:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  801942:	00 
  801943:	8b 45 08             	mov    0x8(%ebp),%eax
  801946:	89 04 24             	mov    %eax,(%esp)
  801949:	e8 55 03 00 00       	call   801ca3 <open>
  80194e:	89 c3                	mov    %eax,%ebx
  801950:	85 c0                	test   %eax,%eax
  801952:	78 1b                	js     80196f <stat+0x40>
		return fd;
	r = fstat(fd, stat);
  801954:	8b 45 0c             	mov    0xc(%ebp),%eax
  801957:	89 44 24 04          	mov    %eax,0x4(%esp)
  80195b:	89 1c 24             	mov    %ebx,(%esp)
  80195e:	e8 b7 fc ff ff       	call   80161a <fstat>
  801963:	89 c6                	mov    %eax,%esi
	close(fd);
  801965:	89 1c 24             	mov    %ebx,(%esp)
  801968:	e8 91 ff ff ff       	call   8018fe <close>
  80196d:	89 f3                	mov    %esi,%ebx
	return r;
}
  80196f:	89 d8                	mov    %ebx,%eax
  801971:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  801974:	8b 75 fc             	mov    -0x4(%ebp),%esi
  801977:	89 ec                	mov    %ebp,%esp
  801979:	5d                   	pop    %ebp
  80197a:	c3                   	ret    

0080197b <close_all>:
		return fd_close(fd, 1);
}

void
close_all(void)
{
  80197b:	55                   	push   %ebp
  80197c:	89 e5                	mov    %esp,%ebp
  80197e:	53                   	push   %ebx
  80197f:	83 ec 14             	sub    $0x14,%esp
  801982:	bb 00 00 00 00       	mov    $0x0,%ebx
	int i;
	for (i = 0; i < MAXFD; i++)
		close(i);
  801987:	89 1c 24             	mov    %ebx,(%esp)
  80198a:	e8 6f ff ff ff       	call   8018fe <close>

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  80198f:	83 c3 01             	add    $0x1,%ebx
  801992:	83 fb 20             	cmp    $0x20,%ebx
  801995:	75 f0                	jne    801987 <close_all+0xc>
		close(i);
}
  801997:	83 c4 14             	add    $0x14,%esp
  80199a:	5b                   	pop    %ebx
  80199b:	5d                   	pop    %ebp
  80199c:	c3                   	ret    

0080199d <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  80199d:	55                   	push   %ebp
  80199e:	89 e5                	mov    %esp,%ebp
  8019a0:	83 ec 58             	sub    $0x58,%esp
  8019a3:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  8019a6:	89 75 f8             	mov    %esi,-0x8(%ebp)
  8019a9:	89 7d fc             	mov    %edi,-0x4(%ebp)
  8019ac:	8b 7d 0c             	mov    0xc(%ebp),%edi
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  8019af:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  8019b2:	89 44 24 04          	mov    %eax,0x4(%esp)
  8019b6:	8b 45 08             	mov    0x8(%ebp),%eax
  8019b9:	89 04 24             	mov    %eax,(%esp)
  8019bc:	e8 7c fb ff ff       	call   80153d <fd_lookup>
  8019c1:	89 c3                	mov    %eax,%ebx
  8019c3:	85 c0                	test   %eax,%eax
  8019c5:	0f 88 e0 00 00 00    	js     801aab <dup+0x10e>
		return r;
	close(newfdnum);
  8019cb:	89 3c 24             	mov    %edi,(%esp)
  8019ce:	e8 2b ff ff ff       	call   8018fe <close>

	newfd = INDEX2FD(newfdnum);
  8019d3:	8d b7 00 00 0d 00    	lea    0xd0000(%edi),%esi
  8019d9:	c1 e6 0c             	shl    $0xc,%esi
	ova = fd2data(oldfd);
  8019dc:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8019df:	89 04 24             	mov    %eax,(%esp)
  8019e2:	e8 c9 fa ff ff       	call   8014b0 <fd2data>
  8019e7:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  8019e9:	89 34 24             	mov    %esi,(%esp)
  8019ec:	e8 bf fa ff ff       	call   8014b0 <fd2data>
  8019f1:	89 45 d4             	mov    %eax,-0x2c(%ebp)

	if ((vpd[PDX(ova)] & PTE_P) && (vpt[VPN(ova)] & PTE_P))
  8019f4:	89 da                	mov    %ebx,%edx
  8019f6:	89 d8                	mov    %ebx,%eax
  8019f8:	c1 e8 16             	shr    $0x16,%eax
  8019fb:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801a02:	a8 01                	test   $0x1,%al
  801a04:	74 43                	je     801a49 <dup+0xac>
  801a06:	c1 ea 0c             	shr    $0xc,%edx
  801a09:	8b 04 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%eax
  801a10:	a8 01                	test   $0x1,%al
  801a12:	74 35                	je     801a49 <dup+0xac>
		if ((r = sys_page_map(0, ova, 0, nva, vpt[VPN(ova)] & PTE_USER)) < 0)
  801a14:	8b 04 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%eax
  801a1b:	25 07 0e 00 00       	and    $0xe07,%eax
  801a20:	89 44 24 10          	mov    %eax,0x10(%esp)
  801a24:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801a27:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801a2b:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801a32:	00 
  801a33:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801a37:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801a3e:	e8 da f8 ff ff       	call   80131d <sys_page_map>
  801a43:	89 c3                	mov    %eax,%ebx
  801a45:	85 c0                	test   %eax,%eax
  801a47:	78 3f                	js     801a88 <dup+0xeb>
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, vpt[VPN(oldfd)] & PTE_USER)) < 0)
  801a49:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801a4c:	89 c2                	mov    %eax,%edx
  801a4e:	c1 ea 0c             	shr    $0xc,%edx
  801a51:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801a58:	81 e2 07 0e 00 00    	and    $0xe07,%edx
  801a5e:	89 54 24 10          	mov    %edx,0x10(%esp)
  801a62:	89 74 24 0c          	mov    %esi,0xc(%esp)
  801a66:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801a6d:	00 
  801a6e:	89 44 24 04          	mov    %eax,0x4(%esp)
  801a72:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801a79:	e8 9f f8 ff ff       	call   80131d <sys_page_map>
  801a7e:	89 c3                	mov    %eax,%ebx
  801a80:	85 c0                	test   %eax,%eax
  801a82:	78 04                	js     801a88 <dup+0xeb>
  801a84:	89 fb                	mov    %edi,%ebx
  801a86:	eb 23                	jmp    801aab <dup+0x10e>
		goto err;

	return newfdnum;

err:
	sys_page_unmap(0, newfd);
  801a88:	89 74 24 04          	mov    %esi,0x4(%esp)
  801a8c:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801a93:	e8 27 f8 ff ff       	call   8012bf <sys_page_unmap>
	sys_page_unmap(0, nva);
  801a98:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801a9b:	89 44 24 04          	mov    %eax,0x4(%esp)
  801a9f:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801aa6:	e8 14 f8 ff ff       	call   8012bf <sys_page_unmap>
	return r;
}
  801aab:	89 d8                	mov    %ebx,%eax
  801aad:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  801ab0:	8b 75 f8             	mov    -0x8(%ebp),%esi
  801ab3:	8b 7d fc             	mov    -0x4(%ebp),%edi
  801ab6:	89 ec                	mov    %ebp,%esp
  801ab8:	5d                   	pop    %ebp
  801ab9:	c3                   	ret    
	...

00801abc <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  801abc:	55                   	push   %ebp
  801abd:	89 e5                	mov    %esp,%ebp
  801abf:	53                   	push   %ebx
  801ac0:	83 ec 14             	sub    $0x14,%esp
  801ac3:	89 d3                	mov    %edx,%ebx
	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", env->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(envs[1].env_id, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  801ac5:	8b 15 c8 00 c0 ee    	mov    0xeec000c8,%edx
  801acb:	c7 44 24 0c 07 00 00 	movl   $0x7,0xc(%esp)
  801ad2:	00 
  801ad3:	c7 44 24 08 00 40 80 	movl   $0x804000,0x8(%esp)
  801ada:	00 
  801adb:	89 44 24 04          	mov    %eax,0x4(%esp)
  801adf:	89 14 24             	mov    %edx,(%esp)
  801ae2:	e8 f9 0d 00 00       	call   8028e0 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  801ae7:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801aee:	00 
  801aef:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801af3:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801afa:	e8 47 0e 00 00       	call   802946 <ipc_recv>
}
  801aff:	83 c4 14             	add    $0x14,%esp
  801b02:	5b                   	pop    %ebx
  801b03:	5d                   	pop    %ebp
  801b04:	c3                   	ret    

00801b05 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  801b05:	55                   	push   %ebp
  801b06:	89 e5                	mov    %esp,%ebp
  801b08:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  801b0b:	8b 45 08             	mov    0x8(%ebp),%eax
  801b0e:	8b 40 0c             	mov    0xc(%eax),%eax
  801b11:	a3 00 40 80 00       	mov    %eax,0x804000
	fsipcbuf.set_size.req_size = newsize;
  801b16:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b19:	a3 04 40 80 00       	mov    %eax,0x804004
	return fsipc(FSREQ_SET_SIZE, NULL);
  801b1e:	ba 00 00 00 00       	mov    $0x0,%edx
  801b23:	b8 02 00 00 00       	mov    $0x2,%eax
  801b28:	e8 8f ff ff ff       	call   801abc <fsipc>
}
  801b2d:	c9                   	leave  
  801b2e:	c3                   	ret    

00801b2f <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  801b2f:	55                   	push   %ebp
  801b30:	89 e5                	mov    %esp,%ebp
  801b32:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  801b35:	8b 45 08             	mov    0x8(%ebp),%eax
  801b38:	8b 40 0c             	mov    0xc(%eax),%eax
  801b3b:	a3 00 40 80 00       	mov    %eax,0x804000
	return fsipc(FSREQ_FLUSH, NULL);
  801b40:	ba 00 00 00 00       	mov    $0x0,%edx
  801b45:	b8 06 00 00 00       	mov    $0x6,%eax
  801b4a:	e8 6d ff ff ff       	call   801abc <fsipc>
}
  801b4f:	c9                   	leave  
  801b50:	c3                   	ret    

00801b51 <sync>:
}

// Synchronize disk with buffer cache
int
sync(void)
{
  801b51:	55                   	push   %ebp
  801b52:	89 e5                	mov    %esp,%ebp
  801b54:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  801b57:	ba 00 00 00 00       	mov    $0x0,%edx
  801b5c:	b8 08 00 00 00       	mov    $0x8,%eax
  801b61:	e8 56 ff ff ff       	call   801abc <fsipc>
}
  801b66:	c9                   	leave  
  801b67:	c3                   	ret    

00801b68 <devfile_stat>:
	return fsipc(FSREQ_WRITE, NULL);	
}

static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  801b68:	55                   	push   %ebp
  801b69:	89 e5                	mov    %esp,%ebp
  801b6b:	53                   	push   %ebx
  801b6c:	83 ec 14             	sub    $0x14,%esp
  801b6f:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  801b72:	8b 45 08             	mov    0x8(%ebp),%eax
  801b75:	8b 40 0c             	mov    0xc(%eax),%eax
  801b78:	a3 00 40 80 00       	mov    %eax,0x804000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  801b7d:	ba 00 00 00 00       	mov    $0x0,%edx
  801b82:	b8 05 00 00 00       	mov    $0x5,%eax
  801b87:	e8 30 ff ff ff       	call   801abc <fsipc>
  801b8c:	85 c0                	test   %eax,%eax
  801b8e:	78 2b                	js     801bbb <devfile_stat+0x53>
		return r;
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  801b90:	c7 44 24 04 00 40 80 	movl   $0x804000,0x4(%esp)
  801b97:	00 
  801b98:	89 1c 24             	mov    %ebx,(%esp)
  801b9b:	e8 ea ef ff ff       	call   800b8a <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  801ba0:	a1 80 40 80 00       	mov    0x804080,%eax
  801ba5:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  801bab:	a1 84 40 80 00       	mov    0x804084,%eax
  801bb0:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
  801bb6:	b8 00 00 00 00       	mov    $0x0,%eax
	return 0;
}
  801bbb:	83 c4 14             	add    $0x14,%esp
  801bbe:	5b                   	pop    %ebx
  801bbf:	5d                   	pop    %ebp
  801bc0:	c3                   	ret    

00801bc1 <devfile_write>:
// Returns:
//	 The number of bytes successfully written.
//	 < 0 on error.
static ssize_t
devfile_write(struct Fd *fd, const void *buf, size_t n)
{
  801bc1:	55                   	push   %ebp
  801bc2:	89 e5                	mov    %esp,%ebp
  801bc4:	83 ec 18             	sub    $0x18,%esp
  801bc7:	8b 45 10             	mov    0x10(%ebp),%eax
  801bca:	3d f8 0f 00 00       	cmp    $0xff8,%eax
  801bcf:	76 05                	jbe    801bd6 <devfile_write+0x15>
  801bd1:	b8 f8 0f 00 00       	mov    $0xff8,%eax
	// LAB 5: Your code here
	//panic("devfile_write not implemented");
	
	if (n > (PGSIZE - (sizeof(int) + sizeof(size_t))))
		n = PGSIZE - (sizeof(int) + sizeof(size_t));
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  801bd6:	8b 55 08             	mov    0x8(%ebp),%edx
  801bd9:	8b 52 0c             	mov    0xc(%edx),%edx
  801bdc:	89 15 00 40 80 00    	mov    %edx,0x804000
	fsipcbuf.write.req_n = n;
  801be2:	a3 04 40 80 00       	mov    %eax,0x804004
	memmove (fsipcbuf.write.req_buf, (char*)buf, n);	
  801be7:	89 44 24 08          	mov    %eax,0x8(%esp)
  801beb:	8b 45 0c             	mov    0xc(%ebp),%eax
  801bee:	89 44 24 04          	mov    %eax,0x4(%esp)
  801bf2:	c7 04 24 08 40 80 00 	movl   $0x804008,(%esp)
  801bf9:	e8 47 f1 ff ff       	call   800d45 <memmove>
	return fsipc(FSREQ_WRITE, NULL);	
  801bfe:	ba 00 00 00 00       	mov    $0x0,%edx
  801c03:	b8 04 00 00 00       	mov    $0x4,%eax
  801c08:	e8 af fe ff ff       	call   801abc <fsipc>
}
  801c0d:	c9                   	leave  
  801c0e:	c3                   	ret    

00801c0f <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  801c0f:	55                   	push   %ebp
  801c10:	89 e5                	mov    %esp,%ebp
  801c12:	53                   	push   %ebx
  801c13:	83 ec 14             	sub    $0x14,%esp
	// system server.
	// LAB 5: Your code here
	
	//panic("devfile_read not implemented");
	int r;
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  801c16:	8b 45 08             	mov    0x8(%ebp),%eax
  801c19:	8b 40 0c             	mov    0xc(%eax),%eax
  801c1c:	a3 00 40 80 00       	mov    %eax,0x804000
	fsipcbuf.read.req_n = n;
  801c21:	8b 45 10             	mov    0x10(%ebp),%eax
  801c24:	a3 04 40 80 00       	mov    %eax,0x804004
	if ((r = fsipc(FSREQ_READ, (void*)&fsipcbuf)) < 0)
  801c29:	ba 00 40 80 00       	mov    $0x804000,%edx
  801c2e:	b8 03 00 00 00       	mov    $0x3,%eax
  801c33:	e8 84 fe ff ff       	call   801abc <fsipc>
  801c38:	89 c3                	mov    %eax,%ebx
  801c3a:	85 c0                	test   %eax,%eax
  801c3c:	78 17                	js     801c55 <devfile_read+0x46>
		return r;
	memmove((void*)buf, (void*)fsipcbuf.readRet.ret_buf, r);
  801c3e:	89 44 24 08          	mov    %eax,0x8(%esp)
  801c42:	c7 44 24 04 00 40 80 	movl   $0x804000,0x4(%esp)
  801c49:	00 
  801c4a:	8b 45 0c             	mov    0xc(%ebp),%eax
  801c4d:	89 04 24             	mov    %eax,(%esp)
  801c50:	e8 f0 f0 ff ff       	call   800d45 <memmove>
	return r;
}
  801c55:	89 d8                	mov    %ebx,%eax
  801c57:	83 c4 14             	add    $0x14,%esp
  801c5a:	5b                   	pop    %ebx
  801c5b:	5d                   	pop    %ebp
  801c5c:	c3                   	ret    

00801c5d <remove>:
}

// Delete a file
int
remove(const char *path)
{
  801c5d:	55                   	push   %ebp
  801c5e:	89 e5                	mov    %esp,%ebp
  801c60:	53                   	push   %ebx
  801c61:	83 ec 14             	sub    $0x14,%esp
  801c64:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (strlen(path) >= MAXPATHLEN)
  801c67:	89 1c 24             	mov    %ebx,(%esp)
  801c6a:	e8 d1 ee ff ff       	call   800b40 <strlen>
  801c6f:	89 c2                	mov    %eax,%edx
  801c71:	b8 f4 ff ff ff       	mov    $0xfffffff4,%eax
  801c76:	81 fa ff 03 00 00    	cmp    $0x3ff,%edx
  801c7c:	7f 1f                	jg     801c9d <remove+0x40>
		return -E_BAD_PATH;
	strcpy(fsipcbuf.remove.req_path, path);
  801c7e:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801c82:	c7 04 24 00 40 80 00 	movl   $0x804000,(%esp)
  801c89:	e8 fc ee ff ff       	call   800b8a <strcpy>
	return fsipc(FSREQ_REMOVE, NULL);
  801c8e:	ba 00 00 00 00       	mov    $0x0,%edx
  801c93:	b8 07 00 00 00       	mov    $0x7,%eax
  801c98:	e8 1f fe ff ff       	call   801abc <fsipc>
}
  801c9d:	83 c4 14             	add    $0x14,%esp
  801ca0:	5b                   	pop    %ebx
  801ca1:	5d                   	pop    %ebp
  801ca2:	c3                   	ret    

00801ca3 <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  801ca3:	55                   	push   %ebp
  801ca4:	89 e5                	mov    %esp,%ebp
  801ca6:	83 ec 28             	sub    $0x28,%esp
  801ca9:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  801cac:	89 75 fc             	mov    %esi,-0x4(%ebp)
  801caf:	8b 75 08             	mov    0x8(%ebp),%esi
	// file descriptor.

	// LAB 5: Your code here.
	// Code added by Swastika / Sandeep
	
	if (strlen(path) >= MAXPATHLEN)
  801cb2:	89 34 24             	mov    %esi,(%esp)
  801cb5:	e8 86 ee ff ff       	call   800b40 <strlen>
  801cba:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  801cbf:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  801cc4:	7f 5e                	jg     801d24 <open+0x81>
		return -E_BAD_PATH;
	struct Fd * fd;
	int  r;
	if ((r = fd_alloc(&fd)) < 0)
  801cc6:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801cc9:	89 04 24             	mov    %eax,(%esp)
  801ccc:	e8 fa f7 ff ff       	call   8014cb <fd_alloc>
  801cd1:	89 c3                	mov    %eax,%ebx
  801cd3:	85 c0                	test   %eax,%eax
  801cd5:	78 4d                	js     801d24 <open+0x81>
		return r;
	strcpy (fsipcbuf.open.req_path, path);
  801cd7:	89 74 24 04          	mov    %esi,0x4(%esp)
  801cdb:	c7 04 24 00 40 80 00 	movl   $0x804000,(%esp)
  801ce2:	e8 a3 ee ff ff       	call   800b8a <strcpy>
	fsipcbuf.open.req_omode = mode;	
  801ce7:	8b 45 0c             	mov    0xc(%ebp),%eax
  801cea:	a3 00 44 80 00       	mov    %eax,0x804400
	if ((r = fsipc(FSREQ_OPEN,(void*)fd)) < 0)
  801cef:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801cf2:	b8 01 00 00 00       	mov    $0x1,%eax
  801cf7:	e8 c0 fd ff ff       	call   801abc <fsipc>
  801cfc:	89 c3                	mov    %eax,%ebx
  801cfe:	85 c0                	test   %eax,%eax
  801d00:	79 15                	jns    801d17 <open+0x74>
	{
		fd_close(fd,0);
  801d02:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  801d09:	00 
  801d0a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d0d:	89 04 24             	mov    %eax,(%esp)
  801d10:	e8 6a fb ff ff       	call   80187f <fd_close>
		return r; 
  801d15:	eb 0d                	jmp    801d24 <open+0x81>
	}
	return fd2num(fd);
  801d17:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d1a:	89 04 24             	mov    %eax,(%esp)
  801d1d:	e8 7e f7 ff ff       	call   8014a0 <fd2num>
  801d22:	89 c3                	mov    %eax,%ebx
	//panic("open not implemented");
}
  801d24:	89 d8                	mov    %ebx,%eax
  801d26:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  801d29:	8b 75 fc             	mov    -0x4(%ebp),%esi
  801d2c:	89 ec                	mov    %ebp,%esp
  801d2e:	5d                   	pop    %ebp
  801d2f:	c3                   	ret    

00801d30 <writebuf>:
};


static void
writebuf(struct printbuf *b)
{
  801d30:	55                   	push   %ebp
  801d31:	89 e5                	mov    %esp,%ebp
  801d33:	53                   	push   %ebx
  801d34:	83 ec 14             	sub    $0x14,%esp
  801d37:	89 c3                	mov    %eax,%ebx
	if (b->error > 0) {
  801d39:	83 78 0c 00          	cmpl   $0x0,0xc(%eax)
  801d3d:	7e 34                	jle    801d73 <writebuf+0x43>
		ssize_t result = write(b->fd, b->buf, b->idx);
  801d3f:	8b 40 04             	mov    0x4(%eax),%eax
  801d42:	89 44 24 08          	mov    %eax,0x8(%esp)
  801d46:	8d 43 10             	lea    0x10(%ebx),%eax
  801d49:	89 44 24 04          	mov    %eax,0x4(%esp)
  801d4d:	8b 03                	mov    (%ebx),%eax
  801d4f:	89 04 24             	mov    %eax,(%esp)
  801d52:	e8 be f9 ff ff       	call   801715 <write>
		if (result > 0)
  801d57:	85 c0                	test   %eax,%eax
  801d59:	7e 03                	jle    801d5e <writebuf+0x2e>
			b->result += result;
  801d5b:	01 43 08             	add    %eax,0x8(%ebx)
		if (result != b->idx) // error, or wrote less than supplied
  801d5e:	3b 43 04             	cmp    0x4(%ebx),%eax
  801d61:	74 10                	je     801d73 <writebuf+0x43>
			b->error = (result < 0 ? result : 0);
  801d63:	85 c0                	test   %eax,%eax
  801d65:	0f 9f c2             	setg   %dl
  801d68:	0f b6 d2             	movzbl %dl,%edx
  801d6b:	83 ea 01             	sub    $0x1,%edx
  801d6e:	21 d0                	and    %edx,%eax
  801d70:	89 43 0c             	mov    %eax,0xc(%ebx)
	}
}
  801d73:	83 c4 14             	add    $0x14,%esp
  801d76:	5b                   	pop    %ebx
  801d77:	5d                   	pop    %ebp
  801d78:	c3                   	ret    

00801d79 <vfprintf>:
	}
}

int
vfprintf(int fd, const char *fmt, va_list ap)
{
  801d79:	55                   	push   %ebp
  801d7a:	89 e5                	mov    %esp,%ebp
  801d7c:	81 ec 28 01 00 00    	sub    $0x128,%esp
	struct printbuf b;

	b.fd = fd;
  801d82:	8b 45 08             	mov    0x8(%ebp),%eax
  801d85:	89 85 e8 fe ff ff    	mov    %eax,-0x118(%ebp)
	b.idx = 0;
  801d8b:	c7 85 ec fe ff ff 00 	movl   $0x0,-0x114(%ebp)
  801d92:	00 00 00 
	b.result = 0;
  801d95:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  801d9c:	00 00 00 
	b.error = 1;
  801d9f:	c7 85 f4 fe ff ff 01 	movl   $0x1,-0x10c(%ebp)
  801da6:	00 00 00 
	vprintfmt(putch, &b, fmt, ap);
  801da9:	8b 45 10             	mov    0x10(%ebp),%eax
  801dac:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801db0:	8b 45 0c             	mov    0xc(%ebp),%eax
  801db3:	89 44 24 08          	mov    %eax,0x8(%esp)
  801db7:	8d 85 e8 fe ff ff    	lea    -0x118(%ebp),%eax
  801dbd:	89 44 24 04          	mov    %eax,0x4(%esp)
  801dc1:	c7 04 24 36 1e 80 00 	movl   $0x801e36,(%esp)
  801dc8:	e8 b0 e8 ff ff       	call   80067d <vprintfmt>
	if (b.idx > 0)
  801dcd:	83 bd ec fe ff ff 00 	cmpl   $0x0,-0x114(%ebp)
  801dd4:	7e 0b                	jle    801de1 <vfprintf+0x68>
		writebuf(&b);
  801dd6:	8d 85 e8 fe ff ff    	lea    -0x118(%ebp),%eax
  801ddc:	e8 4f ff ff ff       	call   801d30 <writebuf>

	return (b.result ? b.result : b.error);
  801de1:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
  801de7:	85 c0                	test   %eax,%eax
  801de9:	75 06                	jne    801df1 <vfprintf+0x78>
  801deb:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  801df1:	c9                   	leave  
  801df2:	c3                   	ret    

00801df3 <printf>:
	return cnt;
}

int
printf(const char *fmt, ...)
{
  801df3:	55                   	push   %ebp
  801df4:	89 e5                	mov    %esp,%ebp
  801df6:	83 ec 18             	sub    $0x18,%esp

	return cnt;
}

int
printf(const char *fmt, ...)
  801df9:	8d 45 0c             	lea    0xc(%ebp),%eax
{
	va_list ap;
	int cnt;

	va_start(ap, fmt);
	cnt = vfprintf(1, fmt, ap);
  801dfc:	89 44 24 08          	mov    %eax,0x8(%esp)
  801e00:	8b 45 08             	mov    0x8(%ebp),%eax
  801e03:	89 44 24 04          	mov    %eax,0x4(%esp)
  801e07:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  801e0e:	e8 66 ff ff ff       	call   801d79 <vfprintf>
	va_end(ap);

	return cnt;
}
  801e13:	c9                   	leave  
  801e14:	c3                   	ret    

00801e15 <fprintf>:
	return (b.result ? b.result : b.error);
}

int
fprintf(int fd, const char *fmt, ...)
{
  801e15:	55                   	push   %ebp
  801e16:	89 e5                	mov    %esp,%ebp
  801e18:	83 ec 18             	sub    $0x18,%esp

	return (b.result ? b.result : b.error);
}

int
fprintf(int fd, const char *fmt, ...)
  801e1b:	8d 45 10             	lea    0x10(%ebp),%eax
{
	va_list ap;
	int cnt;

	va_start(ap, fmt);
	cnt = vfprintf(fd, fmt, ap);
  801e1e:	89 44 24 08          	mov    %eax,0x8(%esp)
  801e22:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e25:	89 44 24 04          	mov    %eax,0x4(%esp)
  801e29:	8b 45 08             	mov    0x8(%ebp),%eax
  801e2c:	89 04 24             	mov    %eax,(%esp)
  801e2f:	e8 45 ff ff ff       	call   801d79 <vfprintf>
	va_end(ap);

	return cnt;
}
  801e34:	c9                   	leave  
  801e35:	c3                   	ret    

00801e36 <putch>:
	}
}

static void
putch(int ch, void *thunk)
{
  801e36:	55                   	push   %ebp
  801e37:	89 e5                	mov    %esp,%ebp
  801e39:	53                   	push   %ebx
  801e3a:	83 ec 04             	sub    $0x4,%esp
	struct printbuf *b = (struct printbuf *) thunk;
  801e3d:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  801e40:	8b 43 04             	mov    0x4(%ebx),%eax
  801e43:	8b 55 08             	mov    0x8(%ebp),%edx
  801e46:	88 54 03 10          	mov    %dl,0x10(%ebx,%eax,1)
  801e4a:	83 c0 01             	add    $0x1,%eax
  801e4d:	89 43 04             	mov    %eax,0x4(%ebx)
	if (b->idx == 256) {
  801e50:	3d 00 01 00 00       	cmp    $0x100,%eax
  801e55:	75 0e                	jne    801e65 <putch+0x2f>
		writebuf(b);
  801e57:	89 d8                	mov    %ebx,%eax
  801e59:	e8 d2 fe ff ff       	call   801d30 <writebuf>
		b->idx = 0;
  801e5e:	c7 43 04 00 00 00 00 	movl   $0x0,0x4(%ebx)
	}
}
  801e65:	83 c4 04             	add    $0x4,%esp
  801e68:	5b                   	pop    %ebx
  801e69:	5d                   	pop    %ebp
  801e6a:	c3                   	ret    
  801e6b:	00 00                	add    %al,(%eax)
  801e6d:	00 00                	add    %al,(%eax)
	...

00801e70 <devsock_stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  801e70:	55                   	push   %ebp
  801e71:	89 e5                	mov    %esp,%ebp
  801e73:	83 ec 18             	sub    $0x18,%esp
	strcpy(stat->st_name, "<sock>");
  801e76:	c7 44 24 04 fc 30 80 	movl   $0x8030fc,0x4(%esp)
  801e7d:	00 
  801e7e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e81:	89 04 24             	mov    %eax,(%esp)
  801e84:	e8 01 ed ff ff       	call   800b8a <strcpy>
	return 0;
}
  801e89:	b8 00 00 00 00       	mov    $0x0,%eax
  801e8e:	c9                   	leave  
  801e8f:	c3                   	ret    

00801e90 <devsock_close>:
	return nsipc_shutdown(r, how);
}

static int
devsock_close(struct Fd *fd)
{
  801e90:	55                   	push   %ebp
  801e91:	89 e5                	mov    %esp,%ebp
  801e93:	83 ec 18             	sub    $0x18,%esp
	return nsipc_close(fd->fd_sock.sockid);
  801e96:	8b 45 08             	mov    0x8(%ebp),%eax
  801e99:	8b 40 0c             	mov    0xc(%eax),%eax
  801e9c:	89 04 24             	mov    %eax,(%esp)
  801e9f:	e8 9e 02 00 00       	call   802142 <nsipc_close>
}
  801ea4:	c9                   	leave  
  801ea5:	c3                   	ret    

00801ea6 <devsock_write>:
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
}

static ssize_t
devsock_write(struct Fd *fd, const void *buf, size_t n)
{
  801ea6:	55                   	push   %ebp
  801ea7:	89 e5                	mov    %esp,%ebp
  801ea9:	83 ec 18             	sub    $0x18,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  801eac:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  801eb3:	00 
  801eb4:	8b 45 10             	mov    0x10(%ebp),%eax
  801eb7:	89 44 24 08          	mov    %eax,0x8(%esp)
  801ebb:	8b 45 0c             	mov    0xc(%ebp),%eax
  801ebe:	89 44 24 04          	mov    %eax,0x4(%esp)
  801ec2:	8b 45 08             	mov    0x8(%ebp),%eax
  801ec5:	8b 40 0c             	mov    0xc(%eax),%eax
  801ec8:	89 04 24             	mov    %eax,(%esp)
  801ecb:	e8 ae 02 00 00       	call   80217e <nsipc_send>
}
  801ed0:	c9                   	leave  
  801ed1:	c3                   	ret    

00801ed2 <devsock_read>:
	return nsipc_listen(r, backlog);
}

static ssize_t
devsock_read(struct Fd *fd, void *buf, size_t n)
{
  801ed2:	55                   	push   %ebp
  801ed3:	89 e5                	mov    %esp,%ebp
  801ed5:	83 ec 18             	sub    $0x18,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  801ed8:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  801edf:	00 
  801ee0:	8b 45 10             	mov    0x10(%ebp),%eax
  801ee3:	89 44 24 08          	mov    %eax,0x8(%esp)
  801ee7:	8b 45 0c             	mov    0xc(%ebp),%eax
  801eea:	89 44 24 04          	mov    %eax,0x4(%esp)
  801eee:	8b 45 08             	mov    0x8(%ebp),%eax
  801ef1:	8b 40 0c             	mov    0xc(%eax),%eax
  801ef4:	89 04 24             	mov    %eax,(%esp)
  801ef7:	e8 f5 02 00 00       	call   8021f1 <nsipc_recv>
}
  801efc:	c9                   	leave  
  801efd:	c3                   	ret    

00801efe <alloc_sockfd>:
	return sfd->fd_sock.sockid;
}

static int
alloc_sockfd(int sockid)
{
  801efe:	55                   	push   %ebp
  801eff:	89 e5                	mov    %esp,%ebp
  801f01:	56                   	push   %esi
  801f02:	53                   	push   %ebx
  801f03:	83 ec 20             	sub    $0x20,%esp
  801f06:	89 c6                	mov    %eax,%esi
	struct Fd *sfd;
	int r;

	if ((r = fd_alloc(&sfd)) < 0
  801f08:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801f0b:	89 04 24             	mov    %eax,(%esp)
  801f0e:	e8 b8 f5 ff ff       	call   8014cb <fd_alloc>
  801f13:	89 c3                	mov    %eax,%ebx
  801f15:	85 c0                	test   %eax,%eax
  801f17:	78 21                	js     801f3a <alloc_sockfd+0x3c>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U)) < 0) {
  801f19:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  801f20:	00 
  801f21:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f24:	89 44 24 04          	mov    %eax,0x4(%esp)
  801f28:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801f2f:	e8 47 f4 ff ff       	call   80137b <sys_page_alloc>
  801f34:	89 c3                	mov    %eax,%ebx
alloc_sockfd(int sockid)
{
	struct Fd *sfd;
	int r;

	if ((r = fd_alloc(&sfd)) < 0
  801f36:	85 c0                	test   %eax,%eax
  801f38:	79 0a                	jns    801f44 <alloc_sockfd+0x46>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U)) < 0) {
		nsipc_close(sockid);
  801f3a:	89 34 24             	mov    %esi,(%esp)
  801f3d:	e8 00 02 00 00       	call   802142 <nsipc_close>
		return r;
  801f42:	eb 28                	jmp    801f6c <alloc_sockfd+0x6e>
	}

	sfd->fd_dev_id = devsock.dev_id;
  801f44:	8b 15 20 70 80 00    	mov    0x807020,%edx
  801f4a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f4d:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  801f4f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f52:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	sfd->fd_sock.sockid = sockid;
  801f59:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f5c:	89 70 0c             	mov    %esi,0xc(%eax)
	return fd2num(sfd);
  801f5f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f62:	89 04 24             	mov    %eax,(%esp)
  801f65:	e8 36 f5 ff ff       	call   8014a0 <fd2num>
  801f6a:	89 c3                	mov    %eax,%ebx
}
  801f6c:	89 d8                	mov    %ebx,%eax
  801f6e:	83 c4 20             	add    $0x20,%esp
  801f71:	5b                   	pop    %ebx
  801f72:	5e                   	pop    %esi
  801f73:	5d                   	pop    %ebp
  801f74:	c3                   	ret    

00801f75 <socket>:
	return 0;
}

int
socket(int domain, int type, int protocol)
{
  801f75:	55                   	push   %ebp
  801f76:	89 e5                	mov    %esp,%ebp
  801f78:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  801f7b:	8b 45 10             	mov    0x10(%ebp),%eax
  801f7e:	89 44 24 08          	mov    %eax,0x8(%esp)
  801f82:	8b 45 0c             	mov    0xc(%ebp),%eax
  801f85:	89 44 24 04          	mov    %eax,0x4(%esp)
  801f89:	8b 45 08             	mov    0x8(%ebp),%eax
  801f8c:	89 04 24             	mov    %eax,(%esp)
  801f8f:	e8 62 01 00 00       	call   8020f6 <nsipc_socket>
  801f94:	85 c0                	test   %eax,%eax
  801f96:	78 05                	js     801f9d <socket+0x28>
		return r;
	return alloc_sockfd(r);
  801f98:	e8 61 ff ff ff       	call   801efe <alloc_sockfd>
}
  801f9d:	c9                   	leave  
  801f9e:	66 90                	xchg   %ax,%ax
  801fa0:	c3                   	ret    

00801fa1 <fd2sockid>:
	.dev_stat =	devsock_stat,
};

static int
fd2sockid(int fd)
{
  801fa1:	55                   	push   %ebp
  801fa2:	89 e5                	mov    %esp,%ebp
  801fa4:	83 ec 28             	sub    $0x28,%esp
	struct Fd *sfd;
	int r;

	if ((r = fd_lookup(fd, &sfd)) < 0)
  801fa7:	8d 55 f4             	lea    -0xc(%ebp),%edx
  801faa:	89 54 24 04          	mov    %edx,0x4(%esp)
  801fae:	89 04 24             	mov    %eax,(%esp)
  801fb1:	e8 87 f5 ff ff       	call   80153d <fd_lookup>
  801fb6:	85 c0                	test   %eax,%eax
  801fb8:	78 15                	js     801fcf <fd2sockid+0x2e>
		return r;
	if (sfd->fd_dev_id != devsock.dev_id)
  801fba:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801fbd:	8b 0a                	mov    (%edx),%ecx
  801fbf:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801fc4:	3b 0d 20 70 80 00    	cmp    0x807020,%ecx
  801fca:	75 03                	jne    801fcf <fd2sockid+0x2e>
		return -E_NOT_SUPP;
	return sfd->fd_sock.sockid;
  801fcc:	8b 42 0c             	mov    0xc(%edx),%eax
}
  801fcf:	c9                   	leave  
  801fd0:	c3                   	ret    

00801fd1 <listen>:
	return nsipc_connect(r, name, namelen);
}

int
listen(int s, int backlog)
{
  801fd1:	55                   	push   %ebp
  801fd2:	89 e5                	mov    %esp,%ebp
  801fd4:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  801fd7:	8b 45 08             	mov    0x8(%ebp),%eax
  801fda:	e8 c2 ff ff ff       	call   801fa1 <fd2sockid>
  801fdf:	85 c0                	test   %eax,%eax
  801fe1:	78 0f                	js     801ff2 <listen+0x21>
		return r;
	return nsipc_listen(r, backlog);
  801fe3:	8b 55 0c             	mov    0xc(%ebp),%edx
  801fe6:	89 54 24 04          	mov    %edx,0x4(%esp)
  801fea:	89 04 24             	mov    %eax,(%esp)
  801fed:	e8 2e 01 00 00       	call   802120 <nsipc_listen>
}
  801ff2:	c9                   	leave  
  801ff3:	c3                   	ret    

00801ff4 <connect>:
	return nsipc_close(fd->fd_sock.sockid);
}

int
connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  801ff4:	55                   	push   %ebp
  801ff5:	89 e5                	mov    %esp,%ebp
  801ff7:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  801ffa:	8b 45 08             	mov    0x8(%ebp),%eax
  801ffd:	e8 9f ff ff ff       	call   801fa1 <fd2sockid>
  802002:	85 c0                	test   %eax,%eax
  802004:	78 16                	js     80201c <connect+0x28>
		return r;
	return nsipc_connect(r, name, namelen);
  802006:	8b 55 10             	mov    0x10(%ebp),%edx
  802009:	89 54 24 08          	mov    %edx,0x8(%esp)
  80200d:	8b 55 0c             	mov    0xc(%ebp),%edx
  802010:	89 54 24 04          	mov    %edx,0x4(%esp)
  802014:	89 04 24             	mov    %eax,(%esp)
  802017:	e8 55 02 00 00       	call   802271 <nsipc_connect>
}
  80201c:	c9                   	leave  
  80201d:	c3                   	ret    

0080201e <shutdown>:
	return nsipc_bind(r, name, namelen);
}

int
shutdown(int s, int how)
{
  80201e:	55                   	push   %ebp
  80201f:	89 e5                	mov    %esp,%ebp
  802021:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  802024:	8b 45 08             	mov    0x8(%ebp),%eax
  802027:	e8 75 ff ff ff       	call   801fa1 <fd2sockid>
  80202c:	85 c0                	test   %eax,%eax
  80202e:	78 0f                	js     80203f <shutdown+0x21>
		return r;
	return nsipc_shutdown(r, how);
  802030:	8b 55 0c             	mov    0xc(%ebp),%edx
  802033:	89 54 24 04          	mov    %edx,0x4(%esp)
  802037:	89 04 24             	mov    %eax,(%esp)
  80203a:	e8 1d 01 00 00       	call   80215c <nsipc_shutdown>
}
  80203f:	c9                   	leave  
  802040:	c3                   	ret    

00802041 <bind>:
	return alloc_sockfd(r);
}

int
bind(int s, struct sockaddr *name, socklen_t namelen)
{
  802041:	55                   	push   %ebp
  802042:	89 e5                	mov    %esp,%ebp
  802044:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  802047:	8b 45 08             	mov    0x8(%ebp),%eax
  80204a:	e8 52 ff ff ff       	call   801fa1 <fd2sockid>
  80204f:	85 c0                	test   %eax,%eax
  802051:	78 16                	js     802069 <bind+0x28>
		return r;
	return nsipc_bind(r, name, namelen);
  802053:	8b 55 10             	mov    0x10(%ebp),%edx
  802056:	89 54 24 08          	mov    %edx,0x8(%esp)
  80205a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80205d:	89 54 24 04          	mov    %edx,0x4(%esp)
  802061:	89 04 24             	mov    %eax,(%esp)
  802064:	e8 47 02 00 00       	call   8022b0 <nsipc_bind>
}
  802069:	c9                   	leave  
  80206a:	c3                   	ret    

0080206b <accept>:
	return fd2num(sfd);
}

int
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  80206b:	55                   	push   %ebp
  80206c:	89 e5                	mov    %esp,%ebp
  80206e:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  802071:	8b 45 08             	mov    0x8(%ebp),%eax
  802074:	e8 28 ff ff ff       	call   801fa1 <fd2sockid>
  802079:	85 c0                	test   %eax,%eax
  80207b:	78 1f                	js     80209c <accept+0x31>
		return r;
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  80207d:	8b 55 10             	mov    0x10(%ebp),%edx
  802080:	89 54 24 08          	mov    %edx,0x8(%esp)
  802084:	8b 55 0c             	mov    0xc(%ebp),%edx
  802087:	89 54 24 04          	mov    %edx,0x4(%esp)
  80208b:	89 04 24             	mov    %eax,(%esp)
  80208e:	e8 5c 02 00 00       	call   8022ef <nsipc_accept>
  802093:	85 c0                	test   %eax,%eax
  802095:	78 05                	js     80209c <accept+0x31>
		return r;
	return alloc_sockfd(r);
  802097:	e8 62 fe ff ff       	call   801efe <alloc_sockfd>
}
  80209c:	c9                   	leave  
  80209d:	8d 76 00             	lea    0x0(%esi),%esi
  8020a0:	c3                   	ret    
	...

008020b0 <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  8020b0:	55                   	push   %ebp
  8020b1:	89 e5                	mov    %esp,%ebp
  8020b3:	83 ec 18             	sub    $0x18,%esp
	if (debug)
		cprintf("[%08x] nsipc %d\n", env->env_id, type);

	ipc_send(envs[2].env_id, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  8020b6:	8b 15 44 01 c0 ee    	mov    0xeec00144,%edx
  8020bc:	c7 44 24 0c 07 00 00 	movl   $0x7,0xc(%esp)
  8020c3:	00 
  8020c4:	c7 44 24 08 00 60 80 	movl   $0x806000,0x8(%esp)
  8020cb:	00 
  8020cc:	89 44 24 04          	mov    %eax,0x4(%esp)
  8020d0:	89 14 24             	mov    %edx,(%esp)
  8020d3:	e8 08 08 00 00       	call   8028e0 <ipc_send>
	return ipc_recv(NULL, NULL, NULL);
  8020d8:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  8020df:	00 
  8020e0:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  8020e7:	00 
  8020e8:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8020ef:	e8 52 08 00 00       	call   802946 <ipc_recv>
}
  8020f4:	c9                   	leave  
  8020f5:	c3                   	ret    

008020f6 <nsipc_socket>:
	return nsipc(NSREQ_SEND);
}

int
nsipc_socket(int domain, int type, int protocol)
{
  8020f6:	55                   	push   %ebp
  8020f7:	89 e5                	mov    %esp,%ebp
  8020f9:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  8020fc:	8b 45 08             	mov    0x8(%ebp),%eax
  8020ff:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.socket.req_type = type;
  802104:	8b 45 0c             	mov    0xc(%ebp),%eax
  802107:	a3 04 60 80 00       	mov    %eax,0x806004
	nsipcbuf.socket.req_protocol = protocol;
  80210c:	8b 45 10             	mov    0x10(%ebp),%eax
  80210f:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SOCKET);
  802114:	b8 09 00 00 00       	mov    $0x9,%eax
  802119:	e8 92 ff ff ff       	call   8020b0 <nsipc>
}
  80211e:	c9                   	leave  
  80211f:	c3                   	ret    

00802120 <nsipc_listen>:
	return nsipc(NSREQ_CONNECT);
}

int
nsipc_listen(int s, int backlog)
{
  802120:	55                   	push   %ebp
  802121:	89 e5                	mov    %esp,%ebp
  802123:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  802126:	8b 45 08             	mov    0x8(%ebp),%eax
  802129:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.listen.req_backlog = backlog;
  80212e:	8b 45 0c             	mov    0xc(%ebp),%eax
  802131:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_LISTEN);
  802136:	b8 06 00 00 00       	mov    $0x6,%eax
  80213b:	e8 70 ff ff ff       	call   8020b0 <nsipc>
}
  802140:	c9                   	leave  
  802141:	c3                   	ret    

00802142 <nsipc_close>:
	return nsipc(NSREQ_SHUTDOWN);
}

int
nsipc_close(int s)
{
  802142:	55                   	push   %ebp
  802143:	89 e5                	mov    %esp,%ebp
  802145:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  802148:	8b 45 08             	mov    0x8(%ebp),%eax
  80214b:	a3 00 60 80 00       	mov    %eax,0x806000
	return nsipc(NSREQ_CLOSE);
  802150:	b8 04 00 00 00       	mov    $0x4,%eax
  802155:	e8 56 ff ff ff       	call   8020b0 <nsipc>
}
  80215a:	c9                   	leave  
  80215b:	c3                   	ret    

0080215c <nsipc_shutdown>:
	return nsipc(NSREQ_BIND);
}

int
nsipc_shutdown(int s, int how)
{
  80215c:	55                   	push   %ebp
  80215d:	89 e5                	mov    %esp,%ebp
  80215f:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  802162:	8b 45 08             	mov    0x8(%ebp),%eax
  802165:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.shutdown.req_how = how;
  80216a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80216d:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_SHUTDOWN);
  802172:	b8 03 00 00 00       	mov    $0x3,%eax
  802177:	e8 34 ff ff ff       	call   8020b0 <nsipc>
}
  80217c:	c9                   	leave  
  80217d:	c3                   	ret    

0080217e <nsipc_send>:
	return r;
}

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  80217e:	55                   	push   %ebp
  80217f:	89 e5                	mov    %esp,%ebp
  802181:	53                   	push   %ebx
  802182:	83 ec 14             	sub    $0x14,%esp
  802185:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  802188:	8b 45 08             	mov    0x8(%ebp),%eax
  80218b:	a3 00 60 80 00       	mov    %eax,0x806000
	assert(size < 1600);
  802190:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  802196:	7e 24                	jle    8021bc <nsipc_send+0x3e>
  802198:	c7 44 24 0c 08 31 80 	movl   $0x803108,0xc(%esp)
  80219f:	00 
  8021a0:	c7 44 24 08 14 31 80 	movl   $0x803114,0x8(%esp)
  8021a7:	00 
  8021a8:	c7 44 24 04 66 00 00 	movl   $0x66,0x4(%esp)
  8021af:	00 
  8021b0:	c7 04 24 29 31 80 00 	movl   $0x803129,(%esp)
  8021b7:	e8 4c e2 ff ff       	call   800408 <_panic>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  8021bc:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8021c0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8021c3:	89 44 24 04          	mov    %eax,0x4(%esp)
  8021c7:	c7 04 24 0c 60 80 00 	movl   $0x80600c,(%esp)
  8021ce:	e8 72 eb ff ff       	call   800d45 <memmove>
	nsipcbuf.send.req_size = size;
  8021d3:	89 1d 04 60 80 00    	mov    %ebx,0x806004
	nsipcbuf.send.req_flags = flags;
  8021d9:	8b 45 14             	mov    0x14(%ebp),%eax
  8021dc:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SEND);
  8021e1:	b8 08 00 00 00       	mov    $0x8,%eax
  8021e6:	e8 c5 fe ff ff       	call   8020b0 <nsipc>
}
  8021eb:	83 c4 14             	add    $0x14,%esp
  8021ee:	5b                   	pop    %ebx
  8021ef:	5d                   	pop    %ebp
  8021f0:	c3                   	ret    

008021f1 <nsipc_recv>:
	return nsipc(NSREQ_LISTEN);
}

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  8021f1:	55                   	push   %ebp
  8021f2:	89 e5                	mov    %esp,%ebp
  8021f4:	56                   	push   %esi
  8021f5:	53                   	push   %ebx
  8021f6:	83 ec 10             	sub    $0x10,%esp
  8021f9:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  8021fc:	8b 45 08             	mov    0x8(%ebp),%eax
  8021ff:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.recv.req_len = len;
  802204:	89 35 04 60 80 00    	mov    %esi,0x806004
	nsipcbuf.recv.req_flags = flags;
  80220a:	8b 45 14             	mov    0x14(%ebp),%eax
  80220d:	a3 08 60 80 00       	mov    %eax,0x806008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  802212:	b8 07 00 00 00       	mov    $0x7,%eax
  802217:	e8 94 fe ff ff       	call   8020b0 <nsipc>
  80221c:	89 c3                	mov    %eax,%ebx
  80221e:	85 c0                	test   %eax,%eax
  802220:	78 46                	js     802268 <nsipc_recv+0x77>
		assert(r < 1600 && r <= len);
  802222:	3d 3f 06 00 00       	cmp    $0x63f,%eax
  802227:	7f 04                	jg     80222d <nsipc_recv+0x3c>
  802229:	39 c6                	cmp    %eax,%esi
  80222b:	7d 24                	jge    802251 <nsipc_recv+0x60>
  80222d:	c7 44 24 0c 35 31 80 	movl   $0x803135,0xc(%esp)
  802234:	00 
  802235:	c7 44 24 08 14 31 80 	movl   $0x803114,0x8(%esp)
  80223c:	00 
  80223d:	c7 44 24 04 5b 00 00 	movl   $0x5b,0x4(%esp)
  802244:	00 
  802245:	c7 04 24 29 31 80 00 	movl   $0x803129,(%esp)
  80224c:	e8 b7 e1 ff ff       	call   800408 <_panic>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  802251:	89 44 24 08          	mov    %eax,0x8(%esp)
  802255:	c7 44 24 04 00 60 80 	movl   $0x806000,0x4(%esp)
  80225c:	00 
  80225d:	8b 45 0c             	mov    0xc(%ebp),%eax
  802260:	89 04 24             	mov    %eax,(%esp)
  802263:	e8 dd ea ff ff       	call   800d45 <memmove>
	}

	return r;
}
  802268:	89 d8                	mov    %ebx,%eax
  80226a:	83 c4 10             	add    $0x10,%esp
  80226d:	5b                   	pop    %ebx
  80226e:	5e                   	pop    %esi
  80226f:	5d                   	pop    %ebp
  802270:	c3                   	ret    

00802271 <nsipc_connect>:
	return nsipc(NSREQ_CLOSE);
}

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  802271:	55                   	push   %ebp
  802272:	89 e5                	mov    %esp,%ebp
  802274:	53                   	push   %ebx
  802275:	83 ec 14             	sub    $0x14,%esp
  802278:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  80227b:	8b 45 08             	mov    0x8(%ebp),%eax
  80227e:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  802283:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  802287:	8b 45 0c             	mov    0xc(%ebp),%eax
  80228a:	89 44 24 04          	mov    %eax,0x4(%esp)
  80228e:	c7 04 24 04 60 80 00 	movl   $0x806004,(%esp)
  802295:	e8 ab ea ff ff       	call   800d45 <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  80229a:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_CONNECT);
  8022a0:	b8 05 00 00 00       	mov    $0x5,%eax
  8022a5:	e8 06 fe ff ff       	call   8020b0 <nsipc>
}
  8022aa:	83 c4 14             	add    $0x14,%esp
  8022ad:	5b                   	pop    %ebx
  8022ae:	5d                   	pop    %ebp
  8022af:	c3                   	ret    

008022b0 <nsipc_bind>:
	return r;
}

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  8022b0:	55                   	push   %ebp
  8022b1:	89 e5                	mov    %esp,%ebp
  8022b3:	53                   	push   %ebx
  8022b4:	83 ec 14             	sub    $0x14,%esp
  8022b7:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  8022ba:	8b 45 08             	mov    0x8(%ebp),%eax
  8022bd:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  8022c2:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8022c6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8022c9:	89 44 24 04          	mov    %eax,0x4(%esp)
  8022cd:	c7 04 24 04 60 80 00 	movl   $0x806004,(%esp)
  8022d4:	e8 6c ea ff ff       	call   800d45 <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  8022d9:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_BIND);
  8022df:	b8 02 00 00 00       	mov    $0x2,%eax
  8022e4:	e8 c7 fd ff ff       	call   8020b0 <nsipc>
}
  8022e9:	83 c4 14             	add    $0x14,%esp
  8022ec:	5b                   	pop    %ebx
  8022ed:	5d                   	pop    %ebp
  8022ee:	c3                   	ret    

008022ef <nsipc_accept>:
	return ipc_recv(NULL, NULL, NULL);
}

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  8022ef:	55                   	push   %ebp
  8022f0:	89 e5                	mov    %esp,%ebp
  8022f2:	83 ec 18             	sub    $0x18,%esp
  8022f5:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  8022f8:	89 75 fc             	mov    %esi,-0x4(%ebp)
	int r;
	
	nsipcbuf.accept.req_s = s;
  8022fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8022fe:	a3 00 60 80 00       	mov    %eax,0x806000
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  802303:	b8 01 00 00 00       	mov    $0x1,%eax
  802308:	e8 a3 fd ff ff       	call   8020b0 <nsipc>
  80230d:	89 c3                	mov    %eax,%ebx
  80230f:	85 c0                	test   %eax,%eax
  802311:	78 25                	js     802338 <nsipc_accept+0x49>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  802313:	be 10 60 80 00       	mov    $0x806010,%esi
  802318:	8b 06                	mov    (%esi),%eax
  80231a:	89 44 24 08          	mov    %eax,0x8(%esp)
  80231e:	c7 44 24 04 00 60 80 	movl   $0x806000,0x4(%esp)
  802325:	00 
  802326:	8b 45 0c             	mov    0xc(%ebp),%eax
  802329:	89 04 24             	mov    %eax,(%esp)
  80232c:	e8 14 ea ff ff       	call   800d45 <memmove>
		*addrlen = ret->ret_addrlen;
  802331:	8b 16                	mov    (%esi),%edx
  802333:	8b 45 10             	mov    0x10(%ebp),%eax
  802336:	89 10                	mov    %edx,(%eax)
	}
	return r;
}
  802338:	89 d8                	mov    %ebx,%eax
  80233a:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  80233d:	8b 75 fc             	mov    -0x4(%ebp),%esi
  802340:	89 ec                	mov    %ebp,%esp
  802342:	5d                   	pop    %ebp
  802343:	c3                   	ret    
	...

00802350 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  802350:	55                   	push   %ebp
  802351:	89 e5                	mov    %esp,%ebp
  802353:	83 ec 18             	sub    $0x18,%esp
  802356:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  802359:	89 75 fc             	mov    %esi,-0x4(%ebp)
  80235c:	8b 75 0c             	mov    0xc(%ebp),%esi
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  80235f:	8b 45 08             	mov    0x8(%ebp),%eax
  802362:	89 04 24             	mov    %eax,(%esp)
  802365:	e8 46 f1 ff ff       	call   8014b0 <fd2data>
  80236a:	89 c3                	mov    %eax,%ebx
	strcpy(stat->st_name, "<pipe>");
  80236c:	c7 44 24 04 4a 31 80 	movl   $0x80314a,0x4(%esp)
  802373:	00 
  802374:	89 34 24             	mov    %esi,(%esp)
  802377:	e8 0e e8 ff ff       	call   800b8a <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  80237c:	8b 43 04             	mov    0x4(%ebx),%eax
  80237f:	2b 03                	sub    (%ebx),%eax
  802381:	89 86 80 00 00 00    	mov    %eax,0x80(%esi)
	stat->st_isdir = 0;
  802387:	c7 86 84 00 00 00 00 	movl   $0x0,0x84(%esi)
  80238e:	00 00 00 
	stat->st_dev = &devpipe;
  802391:	c7 86 88 00 00 00 3c 	movl   $0x80703c,0x88(%esi)
  802398:	70 80 00 
	return 0;
}
  80239b:	b8 00 00 00 00       	mov    $0x0,%eax
  8023a0:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  8023a3:	8b 75 fc             	mov    -0x4(%ebp),%esi
  8023a6:	89 ec                	mov    %ebp,%esp
  8023a8:	5d                   	pop    %ebp
  8023a9:	c3                   	ret    

008023aa <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  8023aa:	55                   	push   %ebp
  8023ab:	89 e5                	mov    %esp,%ebp
  8023ad:	53                   	push   %ebx
  8023ae:	83 ec 14             	sub    $0x14,%esp
  8023b1:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  8023b4:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8023b8:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8023bf:	e8 fb ee ff ff       	call   8012bf <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  8023c4:	89 1c 24             	mov    %ebx,(%esp)
  8023c7:	e8 e4 f0 ff ff       	call   8014b0 <fd2data>
  8023cc:	89 44 24 04          	mov    %eax,0x4(%esp)
  8023d0:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8023d7:	e8 e3 ee ff ff       	call   8012bf <sys_page_unmap>
}
  8023dc:	83 c4 14             	add    $0x14,%esp
  8023df:	5b                   	pop    %ebx
  8023e0:	5d                   	pop    %ebp
  8023e1:	c3                   	ret    

008023e2 <_pipeisclosed>:
	return r;
}

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  8023e2:	55                   	push   %ebp
  8023e3:	89 e5                	mov    %esp,%ebp
  8023e5:	57                   	push   %edi
  8023e6:	56                   	push   %esi
  8023e7:	53                   	push   %ebx
  8023e8:	83 ec 2c             	sub    $0x2c,%esp
  8023eb:	89 c7                	mov    %eax,%edi
  8023ed:	89 55 e4             	mov    %edx,-0x1c(%ebp)
	int n, nn, ret;

	while (1) {
		n = env->env_runs;
  8023f0:	a1 80 74 80 00       	mov    0x807480,%eax
  8023f5:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  8023f8:	89 3c 24             	mov    %edi,(%esp)
  8023fb:	e8 b0 05 00 00       	call   8029b0 <pageref>
  802400:	89 c6                	mov    %eax,%esi
  802402:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802405:	89 04 24             	mov    %eax,(%esp)
  802408:	e8 a3 05 00 00       	call   8029b0 <pageref>
  80240d:	39 c6                	cmp    %eax,%esi
  80240f:	0f 94 c0             	sete   %al
  802412:	0f b6 c0             	movzbl %al,%eax
		nn = env->env_runs;
  802415:	8b 15 80 74 80 00    	mov    0x807480,%edx
  80241b:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  80241e:	39 cb                	cmp    %ecx,%ebx
  802420:	75 08                	jne    80242a <_pipeisclosed+0x48>
			return ret;
		if (n != nn && ret == 1)
			cprintf("pipe race avoided\n", n, env->env_runs, ret);
	}
}
  802422:	83 c4 2c             	add    $0x2c,%esp
  802425:	5b                   	pop    %ebx
  802426:	5e                   	pop    %esi
  802427:	5f                   	pop    %edi
  802428:	5d                   	pop    %ebp
  802429:	c3                   	ret    
		n = env->env_runs;
		ret = pageref(fd) == pageref(p);
		nn = env->env_runs;
		if (n == nn)
			return ret;
		if (n != nn && ret == 1)
  80242a:	83 f8 01             	cmp    $0x1,%eax
  80242d:	75 c1                	jne    8023f0 <_pipeisclosed+0xe>
			cprintf("pipe race avoided\n", n, env->env_runs, ret);
  80242f:	8b 52 58             	mov    0x58(%edx),%edx
  802432:	89 44 24 0c          	mov    %eax,0xc(%esp)
  802436:	89 54 24 08          	mov    %edx,0x8(%esp)
  80243a:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  80243e:	c7 04 24 51 31 80 00 	movl   $0x803151,(%esp)
  802445:	e8 83 e0 ff ff       	call   8004cd <cprintf>
  80244a:	eb a4                	jmp    8023f0 <_pipeisclosed+0xe>

0080244c <devpipe_write>:
	return i;
}

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  80244c:	55                   	push   %ebp
  80244d:	89 e5                	mov    %esp,%ebp
  80244f:	57                   	push   %edi
  802450:	56                   	push   %esi
  802451:	53                   	push   %ebx
  802452:	83 ec 1c             	sub    $0x1c,%esp
  802455:	8b 75 08             	mov    0x8(%ebp),%esi
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  802458:	89 34 24             	mov    %esi,(%esp)
  80245b:	e8 50 f0 ff ff       	call   8014b0 <fd2data>
  802460:	89 c3                	mov    %eax,%ebx
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			env->env_id, vpt[VPN(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  802462:	bf 00 00 00 00       	mov    $0x0,%edi
  802467:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80246b:	75 54                	jne    8024c1 <devpipe_write+0x75>
  80246d:	eb 60                	jmp    8024cf <devpipe_write+0x83>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  80246f:	89 da                	mov    %ebx,%edx
  802471:	89 f0                	mov    %esi,%eax
  802473:	e8 6a ff ff ff       	call   8023e2 <_pipeisclosed>
  802478:	85 c0                	test   %eax,%eax
  80247a:	74 07                	je     802483 <devpipe_write+0x37>
  80247c:	b8 00 00 00 00       	mov    $0x0,%eax
  802481:	eb 53                	jmp    8024d6 <devpipe_write+0x8a>
				return 0;
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  802483:	90                   	nop
  802484:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802488:	e8 4d ef ff ff       	call   8013da <sys_yield>
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			env->env_id, vpt[VPN(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  80248d:	8b 43 04             	mov    0x4(%ebx),%eax
  802490:	8b 13                	mov    (%ebx),%edx
  802492:	83 c2 20             	add    $0x20,%edx
  802495:	39 d0                	cmp    %edx,%eax
  802497:	73 d6                	jae    80246f <devpipe_write+0x23>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  802499:	89 c2                	mov    %eax,%edx
  80249b:	c1 fa 1f             	sar    $0x1f,%edx
  80249e:	c1 ea 1b             	shr    $0x1b,%edx
  8024a1:	01 d0                	add    %edx,%eax
  8024a3:	83 e0 1f             	and    $0x1f,%eax
  8024a6:	29 d0                	sub    %edx,%eax
  8024a8:	89 c2                	mov    %eax,%edx
  8024aa:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8024ad:	0f b6 04 39          	movzbl (%ecx,%edi,1),%eax
  8024b1:	88 44 13 08          	mov    %al,0x8(%ebx,%edx,1)
		p->p_wpos++;
  8024b5:	83 43 04 01          	addl   $0x1,0x4(%ebx)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			env->env_id, vpt[VPN(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  8024b9:	83 c7 01             	add    $0x1,%edi
  8024bc:	39 7d 10             	cmp    %edi,0x10(%ebp)
  8024bf:	76 13                	jbe    8024d4 <devpipe_write+0x88>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  8024c1:	8b 43 04             	mov    0x4(%ebx),%eax
  8024c4:	8b 13                	mov    (%ebx),%edx
  8024c6:	83 c2 20             	add    $0x20,%edx
  8024c9:	39 d0                	cmp    %edx,%eax
  8024cb:	73 a2                	jae    80246f <devpipe_write+0x23>
  8024cd:	eb ca                	jmp    802499 <devpipe_write+0x4d>
  8024cf:	bf 00 00 00 00       	mov    $0x0,%edi
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}
	
	return i;
  8024d4:	89 f8                	mov    %edi,%eax
}
  8024d6:	83 c4 1c             	add    $0x1c,%esp
  8024d9:	5b                   	pop    %ebx
  8024da:	5e                   	pop    %esi
  8024db:	5f                   	pop    %edi
  8024dc:	5d                   	pop    %ebp
  8024dd:	c3                   	ret    

008024de <devpipe_read>:
	return _pipeisclosed(fd, p);
}

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  8024de:	55                   	push   %ebp
  8024df:	89 e5                	mov    %esp,%ebp
  8024e1:	83 ec 28             	sub    $0x28,%esp
  8024e4:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  8024e7:	89 75 f8             	mov    %esi,-0x8(%ebp)
  8024ea:	89 7d fc             	mov    %edi,-0x4(%ebp)
  8024ed:	8b 7d 08             	mov    0x8(%ebp),%edi
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  8024f0:	89 3c 24             	mov    %edi,(%esp)
  8024f3:	e8 b8 ef ff ff       	call   8014b0 <fd2data>
  8024f8:	89 c3                	mov    %eax,%ebx
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			env->env_id, vpt[VPN(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  8024fa:	be 00 00 00 00       	mov    $0x0,%esi
  8024ff:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  802503:	75 4c                	jne    802551 <devpipe_read+0x73>
  802505:	eb 5b                	jmp    802562 <devpipe_read+0x84>
		while (p->p_rpos == p->p_wpos) {
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
				return i;
  802507:	89 f0                	mov    %esi,%eax
  802509:	eb 5e                	jmp    802569 <devpipe_read+0x8b>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  80250b:	89 da                	mov    %ebx,%edx
  80250d:	89 f8                	mov    %edi,%eax
  80250f:	90                   	nop
  802510:	e8 cd fe ff ff       	call   8023e2 <_pipeisclosed>
  802515:	85 c0                	test   %eax,%eax
  802517:	74 07                	je     802520 <devpipe_read+0x42>
  802519:	b8 00 00 00 00       	mov    $0x0,%eax
  80251e:	eb 49                	jmp    802569 <devpipe_read+0x8b>
				return 0;
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  802520:	e8 b5 ee ff ff       	call   8013da <sys_yield>
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			env->env_id, vpt[VPN(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  802525:	8b 03                	mov    (%ebx),%eax
  802527:	3b 43 04             	cmp    0x4(%ebx),%eax
  80252a:	74 df                	je     80250b <devpipe_read+0x2d>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  80252c:	89 c2                	mov    %eax,%edx
  80252e:	c1 fa 1f             	sar    $0x1f,%edx
  802531:	c1 ea 1b             	shr    $0x1b,%edx
  802534:	01 d0                	add    %edx,%eax
  802536:	83 e0 1f             	and    $0x1f,%eax
  802539:	29 d0                	sub    %edx,%eax
  80253b:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  802540:	8b 55 0c             	mov    0xc(%ebp),%edx
  802543:	88 04 32             	mov    %al,(%edx,%esi,1)
		p->p_rpos++;
  802546:	83 03 01             	addl   $0x1,(%ebx)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			env->env_id, vpt[VPN(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  802549:	83 c6 01             	add    $0x1,%esi
  80254c:	39 75 10             	cmp    %esi,0x10(%ebp)
  80254f:	76 16                	jbe    802567 <devpipe_read+0x89>
		while (p->p_rpos == p->p_wpos) {
  802551:	8b 03                	mov    (%ebx),%eax
  802553:	3b 43 04             	cmp    0x4(%ebx),%eax
  802556:	75 d4                	jne    80252c <devpipe_read+0x4e>
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  802558:	85 f6                	test   %esi,%esi
  80255a:	75 ab                	jne    802507 <devpipe_read+0x29>
  80255c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802560:	eb a9                	jmp    80250b <devpipe_read+0x2d>
  802562:	be 00 00 00 00       	mov    $0x0,%esi
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  802567:	89 f0                	mov    %esi,%eax
}
  802569:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  80256c:	8b 75 f8             	mov    -0x8(%ebp),%esi
  80256f:	8b 7d fc             	mov    -0x4(%ebp),%edi
  802572:	89 ec                	mov    %ebp,%esp
  802574:	5d                   	pop    %ebp
  802575:	c3                   	ret    

00802576 <pipeisclosed>:
	}
}

int
pipeisclosed(int fdnum)
{
  802576:	55                   	push   %ebp
  802577:	89 e5                	mov    %esp,%ebp
  802579:	83 ec 28             	sub    $0x28,%esp
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80257c:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80257f:	89 44 24 04          	mov    %eax,0x4(%esp)
  802583:	8b 45 08             	mov    0x8(%ebp),%eax
  802586:	89 04 24             	mov    %eax,(%esp)
  802589:	e8 af ef ff ff       	call   80153d <fd_lookup>
  80258e:	85 c0                	test   %eax,%eax
  802590:	78 15                	js     8025a7 <pipeisclosed+0x31>
		return r;
	p = (struct Pipe*) fd2data(fd);
  802592:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802595:	89 04 24             	mov    %eax,(%esp)
  802598:	e8 13 ef ff ff       	call   8014b0 <fd2data>
	return _pipeisclosed(fd, p);
  80259d:	89 c2                	mov    %eax,%edx
  80259f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025a2:	e8 3b fe ff ff       	call   8023e2 <_pipeisclosed>
}
  8025a7:	c9                   	leave  
  8025a8:	c3                   	ret    

008025a9 <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  8025a9:	55                   	push   %ebp
  8025aa:	89 e5                	mov    %esp,%ebp
  8025ac:	83 ec 48             	sub    $0x48,%esp
  8025af:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  8025b2:	89 75 f8             	mov    %esi,-0x8(%ebp)
  8025b5:	89 7d fc             	mov    %edi,-0x4(%ebp)
  8025b8:	8b 7d 08             	mov    0x8(%ebp),%edi
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  8025bb:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  8025be:	89 04 24             	mov    %eax,(%esp)
  8025c1:	e8 05 ef ff ff       	call   8014cb <fd_alloc>
  8025c6:	89 c3                	mov    %eax,%ebx
  8025c8:	85 c0                	test   %eax,%eax
  8025ca:	0f 88 42 01 00 00    	js     802712 <pipe+0x169>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8025d0:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  8025d7:	00 
  8025d8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8025db:	89 44 24 04          	mov    %eax,0x4(%esp)
  8025df:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8025e6:	e8 90 ed ff ff       	call   80137b <sys_page_alloc>
  8025eb:	89 c3                	mov    %eax,%ebx
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  8025ed:	85 c0                	test   %eax,%eax
  8025ef:	0f 88 1d 01 00 00    	js     802712 <pipe+0x169>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  8025f5:	8d 45 e0             	lea    -0x20(%ebp),%eax
  8025f8:	89 04 24             	mov    %eax,(%esp)
  8025fb:	e8 cb ee ff ff       	call   8014cb <fd_alloc>
  802600:	89 c3                	mov    %eax,%ebx
  802602:	85 c0                	test   %eax,%eax
  802604:	0f 88 f5 00 00 00    	js     8026ff <pipe+0x156>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80260a:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  802611:	00 
  802612:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802615:	89 44 24 04          	mov    %eax,0x4(%esp)
  802619:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802620:	e8 56 ed ff ff       	call   80137b <sys_page_alloc>
  802625:	89 c3                	mov    %eax,%ebx
	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  802627:	85 c0                	test   %eax,%eax
  802629:	0f 88 d0 00 00 00    	js     8026ff <pipe+0x156>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  80262f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802632:	89 04 24             	mov    %eax,(%esp)
  802635:	e8 76 ee ff ff       	call   8014b0 <fd2data>
  80263a:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80263c:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  802643:	00 
  802644:	89 44 24 04          	mov    %eax,0x4(%esp)
  802648:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80264f:	e8 27 ed ff ff       	call   80137b <sys_page_alloc>
  802654:	89 c3                	mov    %eax,%ebx
  802656:	85 c0                	test   %eax,%eax
  802658:	0f 88 8e 00 00 00    	js     8026ec <pipe+0x143>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80265e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802661:	89 04 24             	mov    %eax,(%esp)
  802664:	e8 47 ee ff ff       	call   8014b0 <fd2data>
  802669:	c7 44 24 10 07 04 00 	movl   $0x407,0x10(%esp)
  802670:	00 
  802671:	89 44 24 0c          	mov    %eax,0xc(%esp)
  802675:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  80267c:	00 
  80267d:	89 74 24 04          	mov    %esi,0x4(%esp)
  802681:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802688:	e8 90 ec ff ff       	call   80131d <sys_page_map>
  80268d:	89 c3                	mov    %eax,%ebx
  80268f:	85 c0                	test   %eax,%eax
  802691:	78 49                	js     8026dc <pipe+0x133>
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  802693:	b8 3c 70 80 00       	mov    $0x80703c,%eax
  802698:	8b 08                	mov    (%eax),%ecx
  80269a:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80269d:	89 0a                	mov    %ecx,(%edx)
	fd0->fd_omode = O_RDONLY;
  80269f:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8026a2:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%edx)

	fd1->fd_dev_id = devpipe.dev_id;
  8026a9:	8b 10                	mov    (%eax),%edx
  8026ab:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8026ae:	89 10                	mov    %edx,(%eax)
	fd1->fd_omode = O_WRONLY;
  8026b0:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8026b3:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", env->env_id, vpt[VPN(va)]);

	pfd[0] = fd2num(fd0);
  8026ba:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8026bd:	89 04 24             	mov    %eax,(%esp)
  8026c0:	e8 db ed ff ff       	call   8014a0 <fd2num>
  8026c5:	89 07                	mov    %eax,(%edi)
	pfd[1] = fd2num(fd1);
  8026c7:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8026ca:	89 04 24             	mov    %eax,(%esp)
  8026cd:	e8 ce ed ff ff       	call   8014a0 <fd2num>
  8026d2:	89 47 04             	mov    %eax,0x4(%edi)
  8026d5:	bb 00 00 00 00       	mov    $0x0,%ebx
	return 0;
  8026da:	eb 36                	jmp    802712 <pipe+0x169>

    err3:
	sys_page_unmap(0, va);
  8026dc:	89 74 24 04          	mov    %esi,0x4(%esp)
  8026e0:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8026e7:	e8 d3 eb ff ff       	call   8012bf <sys_page_unmap>
    err2:
	sys_page_unmap(0, fd1);
  8026ec:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8026ef:	89 44 24 04          	mov    %eax,0x4(%esp)
  8026f3:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8026fa:	e8 c0 eb ff ff       	call   8012bf <sys_page_unmap>
    err1:
	sys_page_unmap(0, fd0);
  8026ff:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802702:	89 44 24 04          	mov    %eax,0x4(%esp)
  802706:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80270d:	e8 ad eb ff ff       	call   8012bf <sys_page_unmap>
    err:
	return r;
}
  802712:	89 d8                	mov    %ebx,%eax
  802714:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  802717:	8b 75 f8             	mov    -0x8(%ebp),%esi
  80271a:	8b 7d fc             	mov    -0x4(%ebp),%edi
  80271d:	89 ec                	mov    %ebp,%esp
  80271f:	5d                   	pop    %ebp
  802720:	c3                   	ret    
	...

00802730 <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  802730:	55                   	push   %ebp
  802731:	89 e5                	mov    %esp,%ebp
	USED(fd);

	return 0;
}
  802733:	b8 00 00 00 00       	mov    $0x0,%eax
  802738:	5d                   	pop    %ebp
  802739:	c3                   	ret    

0080273a <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  80273a:	55                   	push   %ebp
  80273b:	89 e5                	mov    %esp,%ebp
  80273d:	83 ec 18             	sub    $0x18,%esp
	strcpy(stat->st_name, "<cons>");
  802740:	c7 44 24 04 69 31 80 	movl   $0x803169,0x4(%esp)
  802747:	00 
  802748:	8b 45 0c             	mov    0xc(%ebp),%eax
  80274b:	89 04 24             	mov    %eax,(%esp)
  80274e:	e8 37 e4 ff ff       	call   800b8a <strcpy>
	return 0;
}
  802753:	b8 00 00 00 00       	mov    $0x0,%eax
  802758:	c9                   	leave  
  802759:	c3                   	ret    

0080275a <devcons_write>:
	return 1;
}

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  80275a:	55                   	push   %ebp
  80275b:	89 e5                	mov    %esp,%ebp
  80275d:	57                   	push   %edi
  80275e:	56                   	push   %esi
  80275f:	53                   	push   %ebx
  802760:	81 ec 9c 00 00 00    	sub    $0x9c,%esp
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs, 
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  802766:	b8 00 00 00 00       	mov    $0x0,%eax
  80276b:	be 00 00 00 00       	mov    $0x0,%esi
  802770:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  802774:	74 3f                	je     8027b5 <devcons_write+0x5b>
		m = n - tot;
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  802776:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs, 
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
		m = n - tot;
  80277c:	8b 55 10             	mov    0x10(%ebp),%edx
  80277f:	29 c2                	sub    %eax,%edx
  802781:	89 d3                	mov    %edx,%ebx
		if (m > sizeof(buf) - 1)
  802783:	83 fa 7f             	cmp    $0x7f,%edx
  802786:	76 05                	jbe    80278d <devcons_write+0x33>
  802788:	bb 7f 00 00 00       	mov    $0x7f,%ebx
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  80278d:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  802791:	03 45 0c             	add    0xc(%ebp),%eax
  802794:	89 44 24 04          	mov    %eax,0x4(%esp)
  802798:	89 3c 24             	mov    %edi,(%esp)
  80279b:	e8 a5 e5 ff ff       	call   800d45 <memmove>
		sys_cputs(buf, m);
  8027a0:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8027a4:	89 3c 24             	mov    %edi,(%esp)
  8027a7:	e8 d4 e7 ff ff       	call   800f80 <sys_cputs>
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs, 
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  8027ac:	01 de                	add    %ebx,%esi
  8027ae:	89 f0                	mov    %esi,%eax
  8027b0:	3b 75 10             	cmp    0x10(%ebp),%esi
  8027b3:	72 c7                	jb     80277c <devcons_write+0x22>
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
}
  8027b5:	89 f0                	mov    %esi,%eax
  8027b7:	81 c4 9c 00 00 00    	add    $0x9c,%esp
  8027bd:	5b                   	pop    %ebx
  8027be:	5e                   	pop    %esi
  8027bf:	5f                   	pop    %edi
  8027c0:	5d                   	pop    %ebp
  8027c1:	c3                   	ret    

008027c2 <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  8027c2:	55                   	push   %ebp
  8027c3:	89 e5                	mov    %esp,%ebp
  8027c5:	83 ec 28             	sub    $0x28,%esp
	char c = ch;
  8027c8:	8b 45 08             	mov    0x8(%ebp),%eax
  8027cb:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  8027ce:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  8027d5:	00 
  8027d6:	8d 45 f7             	lea    -0x9(%ebp),%eax
  8027d9:	89 04 24             	mov    %eax,(%esp)
  8027dc:	e8 9f e7 ff ff       	call   800f80 <sys_cputs>
}
  8027e1:	c9                   	leave  
  8027e2:	c3                   	ret    

008027e3 <devcons_read>:
	return fd2num(fd);
}

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  8027e3:	55                   	push   %ebp
  8027e4:	89 e5                	mov    %esp,%ebp
  8027e6:	83 ec 08             	sub    $0x8,%esp
	int c;

	if (n == 0)
  8027e9:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8027ed:	75 07                	jne    8027f6 <devcons_read+0x13>
  8027ef:	eb 28                	jmp    802819 <devcons_read+0x36>
		return 0;

	while ((c = sys_cgetc()) == 0)
		sys_yield();
  8027f1:	e8 e4 eb ff ff       	call   8013da <sys_yield>
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  8027f6:	66 90                	xchg   %ax,%ax
  8027f8:	e8 4f e7 ff ff       	call   800f4c <sys_cgetc>
  8027fd:	85 c0                	test   %eax,%eax
  8027ff:	90                   	nop
  802800:	74 ef                	je     8027f1 <devcons_read+0xe>
  802802:	89 c2                	mov    %eax,%edx
		sys_yield();
	if (c < 0)
  802804:	85 c0                	test   %eax,%eax
  802806:	78 16                	js     80281e <devcons_read+0x3b>
		return c;
	if (c == 0x04)	// ctl-d is eof
  802808:	83 f8 04             	cmp    $0x4,%eax
  80280b:	74 0c                	je     802819 <devcons_read+0x36>
		return 0;
	*(char*)vbuf = c;
  80280d:	8b 45 0c             	mov    0xc(%ebp),%eax
  802810:	88 10                	mov    %dl,(%eax)
  802812:	b8 01 00 00 00       	mov    $0x1,%eax
	return 1;
  802817:	eb 05                	jmp    80281e <devcons_read+0x3b>
  802819:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80281e:	c9                   	leave  
  80281f:	c3                   	ret    

00802820 <opencons>:
	return fd->fd_dev_id == devcons.dev_id;
}

int
opencons(void)
{
  802820:	55                   	push   %ebp
  802821:	89 e5                	mov    %esp,%ebp
  802823:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  802826:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802829:	89 04 24             	mov    %eax,(%esp)
  80282c:	e8 9a ec ff ff       	call   8014cb <fd_alloc>
  802831:	85 c0                	test   %eax,%eax
  802833:	78 3f                	js     802874 <opencons+0x54>
		return r;
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  802835:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  80283c:	00 
  80283d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802840:	89 44 24 04          	mov    %eax,0x4(%esp)
  802844:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80284b:	e8 2b eb ff ff       	call   80137b <sys_page_alloc>
  802850:	85 c0                	test   %eax,%eax
  802852:	78 20                	js     802874 <opencons+0x54>
		return r;
	fd->fd_dev_id = devcons.dev_id;
  802854:	8b 15 58 70 80 00    	mov    0x807058,%edx
  80285a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80285d:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  80285f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802862:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  802869:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80286c:	89 04 24             	mov    %eax,(%esp)
  80286f:	e8 2c ec ff ff       	call   8014a0 <fd2num>
}
  802874:	c9                   	leave  
  802875:	c3                   	ret    

00802876 <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  802876:	55                   	push   %ebp
  802877:	89 e5                	mov    %esp,%ebp
  802879:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80287c:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80287f:	89 44 24 04          	mov    %eax,0x4(%esp)
  802883:	8b 45 08             	mov    0x8(%ebp),%eax
  802886:	89 04 24             	mov    %eax,(%esp)
  802889:	e8 af ec ff ff       	call   80153d <fd_lookup>
  80288e:	85 c0                	test   %eax,%eax
  802890:	78 11                	js     8028a3 <iscons+0x2d>
		return r;
	return fd->fd_dev_id == devcons.dev_id;
  802892:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802895:	8b 00                	mov    (%eax),%eax
  802897:	3b 05 58 70 80 00    	cmp    0x807058,%eax
  80289d:	0f 94 c0             	sete   %al
  8028a0:	0f b6 c0             	movzbl %al,%eax
}
  8028a3:	c9                   	leave  
  8028a4:	c3                   	ret    

008028a5 <getchar>:
	sys_cputs(&c, 1);
}

int
getchar(void)
{
  8028a5:	55                   	push   %ebp
  8028a6:	89 e5                	mov    %esp,%ebp
  8028a8:	83 ec 28             	sub    $0x28,%esp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  8028ab:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  8028b2:	00 
  8028b3:	8d 45 f7             	lea    -0x9(%ebp),%eax
  8028b6:	89 44 24 04          	mov    %eax,0x4(%esp)
  8028ba:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8028c1:	e8 d8 ee ff ff       	call   80179e <read>
	if (r < 0)
  8028c6:	85 c0                	test   %eax,%eax
  8028c8:	78 0f                	js     8028d9 <getchar+0x34>
		return r;
	if (r < 1)
  8028ca:	85 c0                	test   %eax,%eax
  8028cc:	7f 07                	jg     8028d5 <getchar+0x30>
  8028ce:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  8028d3:	eb 04                	jmp    8028d9 <getchar+0x34>
		return -E_EOF;
	return c;
  8028d5:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  8028d9:	c9                   	leave  
  8028da:	c3                   	ret    
  8028db:	00 00                	add    %al,(%eax)
  8028dd:	00 00                	add    %al,(%eax)
	...

008028e0 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  8028e0:	55                   	push   %ebp
  8028e1:	89 e5                	mov    %esp,%ebp
  8028e3:	57                   	push   %edi
  8028e4:	56                   	push   %esi
  8028e5:	53                   	push   %ebx
  8028e6:	83 ec 1c             	sub    $0x1c,%esp
  8028e9:	8b 7d 0c             	mov    0xc(%ebp),%edi
  8028ec:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8028ef:	8b 75 14             	mov    0x14(%ebp),%esi
	// LAB 4: Your code here.
	int r;
	if (pg == NULL)
  8028f2:	85 db                	test   %ebx,%ebx
  8028f4:	75 2d                	jne    802923 <ipc_send+0x43>
  8028f6:	bb 00 00 c0 ee       	mov    $0xeec00000,%ebx
  8028fb:	eb 26                	jmp    802923 <ipc_send+0x43>
		pg = (void*)UTOP;
	while ((r = sys_ipc_try_send(to_env, val, pg, perm)) < 0)
	{
		if(r != -E_IPC_NOT_RECV)
  8028fd:	83 f8 f9             	cmp    $0xfffffff9,%eax
  802900:	74 1c                	je     80291e <ipc_send+0x3e>
			panic("Panic in lib ipc.c : ipc_send() \n");
  802902:	c7 44 24 08 78 31 80 	movl   $0x803178,0x8(%esp)
  802909:	00 
  80290a:	c7 44 24 04 44 00 00 	movl   $0x44,0x4(%esp)
  802911:	00 
  802912:	c7 04 24 9c 31 80 00 	movl   $0x80319c,(%esp)
  802919:	e8 ea da ff ff       	call   800408 <_panic>
		sys_yield();
  80291e:	e8 b7 ea ff ff       	call   8013da <sys_yield>
{
	// LAB 4: Your code here.
	int r;
	if (pg == NULL)
		pg = (void*)UTOP;
	while ((r = sys_ipc_try_send(to_env, val, pg, perm)) < 0)
  802923:	89 74 24 0c          	mov    %esi,0xc(%esp)
  802927:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80292b:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80292f:	8b 45 08             	mov    0x8(%ebp),%eax
  802932:	89 04 24             	mov    %eax,(%esp)
  802935:	e8 33 e8 ff ff       	call   80116d <sys_ipc_try_send>
  80293a:	85 c0                	test   %eax,%eax
  80293c:	78 bf                	js     8028fd <ipc_send+0x1d>
		if(r != -E_IPC_NOT_RECV)
			panic("Panic in lib ipc.c : ipc_send() \n");
		sys_yield();
	}
	//panic("ipc_send not implemented");
}
  80293e:	83 c4 1c             	add    $0x1c,%esp
  802941:	5b                   	pop    %ebx
  802942:	5e                   	pop    %esi
  802943:	5f                   	pop    %edi
  802944:	5d                   	pop    %ebp
  802945:	c3                   	ret    

00802946 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  802946:	55                   	push   %ebp
  802947:	89 e5                	mov    %esp,%ebp
  802949:	56                   	push   %esi
  80294a:	53                   	push   %ebx
  80294b:	83 ec 10             	sub    $0x10,%esp
  80294e:	8b 5d 08             	mov    0x8(%ebp),%ebx
  802951:	8b 45 0c             	mov    0xc(%ebp),%eax
  802954:	8b 75 10             	mov    0x10(%ebp),%esi
	// LAB 4: Your code here.
	int r;

	if (pg == NULL)
  802957:	85 c0                	test   %eax,%eax
  802959:	75 05                	jne    802960 <ipc_recv+0x1a>
  80295b:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
		pg = (void*)UTOP;
	if ((r = sys_ipc_recv(pg)) < 0)
  802960:	89 04 24             	mov    %eax,(%esp)
  802963:	e8 a8 e7 ff ff       	call   801110 <sys_ipc_recv>
  802968:	85 c0                	test   %eax,%eax
  80296a:	79 16                	jns    802982 <ipc_recv+0x3c>
	{
		if (from_env_store != NULL)
  80296c:	85 db                	test   %ebx,%ebx
  80296e:	74 06                	je     802976 <ipc_recv+0x30>
			*from_env_store = 0;
  802970:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
		if(perm_store != NULL)
  802976:	85 f6                	test   %esi,%esi
  802978:	74 2c                	je     8029a6 <ipc_recv+0x60>
			*perm_store = 0;
  80297a:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
  802980:	eb 24                	jmp    8029a6 <ipc_recv+0x60>
		return r;
	}
	else
	{	
		if (from_env_store != NULL)
  802982:	85 db                	test   %ebx,%ebx
  802984:	74 0a                	je     802990 <ipc_recv+0x4a>
			*from_env_store = env->env_ipc_from;
  802986:	a1 80 74 80 00       	mov    0x807480,%eax
  80298b:	8b 40 74             	mov    0x74(%eax),%eax
  80298e:	89 03                	mov    %eax,(%ebx)
		if(perm_store != NULL)
  802990:	85 f6                	test   %esi,%esi
  802992:	74 0a                	je     80299e <ipc_recv+0x58>
			*perm_store = env->env_ipc_perm;
  802994:	a1 80 74 80 00       	mov    0x807480,%eax
  802999:	8b 40 78             	mov    0x78(%eax),%eax
  80299c:	89 06                	mov    %eax,(%esi)
		return env->env_ipc_value;
  80299e:	a1 80 74 80 00       	mov    0x807480,%eax
  8029a3:	8b 40 70             	mov    0x70(%eax),%eax
	}		
	//panic("ipc_recv not implemented");
	//return 0;
}
  8029a6:	83 c4 10             	add    $0x10,%esp
  8029a9:	5b                   	pop    %ebx
  8029aa:	5e                   	pop    %esi
  8029ab:	5d                   	pop    %ebp
  8029ac:	c3                   	ret    
  8029ad:	00 00                	add    %al,(%eax)
	...

008029b0 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  8029b0:	55                   	push   %ebp
  8029b1:	89 e5                	mov    %esp,%ebp
	pte_t pte;

	if (!(vpd[PDX(v)] & PTE_P))
  8029b3:	8b 45 08             	mov    0x8(%ebp),%eax
  8029b6:	89 c2                	mov    %eax,%edx
  8029b8:	c1 ea 16             	shr    $0x16,%edx
  8029bb:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  8029c2:	f6 c2 01             	test   $0x1,%dl
  8029c5:	74 26                	je     8029ed <pageref+0x3d>
		return 0;
	pte = vpt[VPN(v)];
  8029c7:	c1 e8 0c             	shr    $0xc,%eax
  8029ca:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
	if (!(pte & PTE_P))
  8029d1:	a8 01                	test   $0x1,%al
  8029d3:	74 18                	je     8029ed <pageref+0x3d>
		return 0;
	return pages[PPN(pte)].pp_ref;
  8029d5:	c1 e8 0c             	shr    $0xc,%eax
  8029d8:	8d 14 40             	lea    (%eax,%eax,2),%edx
  8029db:	c1 e2 02             	shl    $0x2,%edx
  8029de:	b8 00 00 00 ef       	mov    $0xef000000,%eax
  8029e3:	0f b7 44 02 08       	movzwl 0x8(%edx,%eax,1),%eax
  8029e8:	0f b7 c0             	movzwl %ax,%eax
  8029eb:	eb 05                	jmp    8029f2 <pageref+0x42>
  8029ed:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8029f2:	5d                   	pop    %ebp
  8029f3:	c3                   	ret    
	...

00802a00 <__udivdi3>:
  802a00:	55                   	push   %ebp
  802a01:	89 e5                	mov    %esp,%ebp
  802a03:	57                   	push   %edi
  802a04:	56                   	push   %esi
  802a05:	83 ec 10             	sub    $0x10,%esp
  802a08:	8b 45 14             	mov    0x14(%ebp),%eax
  802a0b:	8b 55 08             	mov    0x8(%ebp),%edx
  802a0e:	8b 75 10             	mov    0x10(%ebp),%esi
  802a11:	8b 7d 0c             	mov    0xc(%ebp),%edi
  802a14:	85 c0                	test   %eax,%eax
  802a16:	89 55 f0             	mov    %edx,-0x10(%ebp)
  802a19:	75 35                	jne    802a50 <__udivdi3+0x50>
  802a1b:	39 fe                	cmp    %edi,%esi
  802a1d:	77 61                	ja     802a80 <__udivdi3+0x80>
  802a1f:	85 f6                	test   %esi,%esi
  802a21:	75 0b                	jne    802a2e <__udivdi3+0x2e>
  802a23:	b8 01 00 00 00       	mov    $0x1,%eax
  802a28:	31 d2                	xor    %edx,%edx
  802a2a:	f7 f6                	div    %esi
  802a2c:	89 c6                	mov    %eax,%esi
  802a2e:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  802a31:	31 d2                	xor    %edx,%edx
  802a33:	89 f8                	mov    %edi,%eax
  802a35:	f7 f6                	div    %esi
  802a37:	89 c7                	mov    %eax,%edi
  802a39:	89 c8                	mov    %ecx,%eax
  802a3b:	f7 f6                	div    %esi
  802a3d:	89 c1                	mov    %eax,%ecx
  802a3f:	89 fa                	mov    %edi,%edx
  802a41:	89 c8                	mov    %ecx,%eax
  802a43:	83 c4 10             	add    $0x10,%esp
  802a46:	5e                   	pop    %esi
  802a47:	5f                   	pop    %edi
  802a48:	5d                   	pop    %ebp
  802a49:	c3                   	ret    
  802a4a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  802a50:	39 f8                	cmp    %edi,%eax
  802a52:	77 1c                	ja     802a70 <__udivdi3+0x70>
  802a54:	0f bd d0             	bsr    %eax,%edx
  802a57:	83 f2 1f             	xor    $0x1f,%edx
  802a5a:	89 55 f4             	mov    %edx,-0xc(%ebp)
  802a5d:	75 39                	jne    802a98 <__udivdi3+0x98>
  802a5f:	3b 75 f0             	cmp    -0x10(%ebp),%esi
  802a62:	0f 86 a0 00 00 00    	jbe    802b08 <__udivdi3+0x108>
  802a68:	39 f8                	cmp    %edi,%eax
  802a6a:	0f 82 98 00 00 00    	jb     802b08 <__udivdi3+0x108>
  802a70:	31 ff                	xor    %edi,%edi
  802a72:	31 c9                	xor    %ecx,%ecx
  802a74:	89 c8                	mov    %ecx,%eax
  802a76:	89 fa                	mov    %edi,%edx
  802a78:	83 c4 10             	add    $0x10,%esp
  802a7b:	5e                   	pop    %esi
  802a7c:	5f                   	pop    %edi
  802a7d:	5d                   	pop    %ebp
  802a7e:	c3                   	ret    
  802a7f:	90                   	nop
  802a80:	89 d1                	mov    %edx,%ecx
  802a82:	89 fa                	mov    %edi,%edx
  802a84:	89 c8                	mov    %ecx,%eax
  802a86:	31 ff                	xor    %edi,%edi
  802a88:	f7 f6                	div    %esi
  802a8a:	89 c1                	mov    %eax,%ecx
  802a8c:	89 fa                	mov    %edi,%edx
  802a8e:	89 c8                	mov    %ecx,%eax
  802a90:	83 c4 10             	add    $0x10,%esp
  802a93:	5e                   	pop    %esi
  802a94:	5f                   	pop    %edi
  802a95:	5d                   	pop    %ebp
  802a96:	c3                   	ret    
  802a97:	90                   	nop
  802a98:	0f b6 4d f4          	movzbl -0xc(%ebp),%ecx
  802a9c:	89 f2                	mov    %esi,%edx
  802a9e:	d3 e0                	shl    %cl,%eax
  802aa0:	89 45 ec             	mov    %eax,-0x14(%ebp)
  802aa3:	b8 20 00 00 00       	mov    $0x20,%eax
  802aa8:	2b 45 f4             	sub    -0xc(%ebp),%eax
  802aab:	89 c1                	mov    %eax,%ecx
  802aad:	d3 ea                	shr    %cl,%edx
  802aaf:	0f b6 4d f4          	movzbl -0xc(%ebp),%ecx
  802ab3:	0b 55 ec             	or     -0x14(%ebp),%edx
  802ab6:	d3 e6                	shl    %cl,%esi
  802ab8:	89 c1                	mov    %eax,%ecx
  802aba:	89 75 e8             	mov    %esi,-0x18(%ebp)
  802abd:	89 fe                	mov    %edi,%esi
  802abf:	d3 ee                	shr    %cl,%esi
  802ac1:	0f b6 4d f4          	movzbl -0xc(%ebp),%ecx
  802ac5:	89 55 ec             	mov    %edx,-0x14(%ebp)
  802ac8:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802acb:	d3 e7                	shl    %cl,%edi
  802acd:	89 c1                	mov    %eax,%ecx
  802acf:	d3 ea                	shr    %cl,%edx
  802ad1:	09 d7                	or     %edx,%edi
  802ad3:	89 f2                	mov    %esi,%edx
  802ad5:	89 f8                	mov    %edi,%eax
  802ad7:	f7 75 ec             	divl   -0x14(%ebp)
  802ada:	89 d6                	mov    %edx,%esi
  802adc:	89 c7                	mov    %eax,%edi
  802ade:	f7 65 e8             	mull   -0x18(%ebp)
  802ae1:	39 d6                	cmp    %edx,%esi
  802ae3:	89 55 ec             	mov    %edx,-0x14(%ebp)
  802ae6:	72 30                	jb     802b18 <__udivdi3+0x118>
  802ae8:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802aeb:	0f b6 4d f4          	movzbl -0xc(%ebp),%ecx
  802aef:	d3 e2                	shl    %cl,%edx
  802af1:	39 c2                	cmp    %eax,%edx
  802af3:	73 05                	jae    802afa <__udivdi3+0xfa>
  802af5:	3b 75 ec             	cmp    -0x14(%ebp),%esi
  802af8:	74 1e                	je     802b18 <__udivdi3+0x118>
  802afa:	89 f9                	mov    %edi,%ecx
  802afc:	31 ff                	xor    %edi,%edi
  802afe:	e9 71 ff ff ff       	jmp    802a74 <__udivdi3+0x74>
  802b03:	90                   	nop
  802b04:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802b08:	31 ff                	xor    %edi,%edi
  802b0a:	b9 01 00 00 00       	mov    $0x1,%ecx
  802b0f:	e9 60 ff ff ff       	jmp    802a74 <__udivdi3+0x74>
  802b14:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802b18:	8d 4f ff             	lea    -0x1(%edi),%ecx
  802b1b:	31 ff                	xor    %edi,%edi
  802b1d:	89 c8                	mov    %ecx,%eax
  802b1f:	89 fa                	mov    %edi,%edx
  802b21:	83 c4 10             	add    $0x10,%esp
  802b24:	5e                   	pop    %esi
  802b25:	5f                   	pop    %edi
  802b26:	5d                   	pop    %ebp
  802b27:	c3                   	ret    
	...

00802b30 <__umoddi3>:
  802b30:	55                   	push   %ebp
  802b31:	89 e5                	mov    %esp,%ebp
  802b33:	57                   	push   %edi
  802b34:	56                   	push   %esi
  802b35:	83 ec 20             	sub    $0x20,%esp
  802b38:	8b 55 14             	mov    0x14(%ebp),%edx
  802b3b:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802b3e:	8b 7d 10             	mov    0x10(%ebp),%edi
  802b41:	8b 75 0c             	mov    0xc(%ebp),%esi
  802b44:	85 d2                	test   %edx,%edx
  802b46:	89 c8                	mov    %ecx,%eax
  802b48:	89 4d f4             	mov    %ecx,-0xc(%ebp)
  802b4b:	75 13                	jne    802b60 <__umoddi3+0x30>
  802b4d:	39 f7                	cmp    %esi,%edi
  802b4f:	76 3f                	jbe    802b90 <__umoddi3+0x60>
  802b51:	89 f2                	mov    %esi,%edx
  802b53:	f7 f7                	div    %edi
  802b55:	89 d0                	mov    %edx,%eax
  802b57:	31 d2                	xor    %edx,%edx
  802b59:	83 c4 20             	add    $0x20,%esp
  802b5c:	5e                   	pop    %esi
  802b5d:	5f                   	pop    %edi
  802b5e:	5d                   	pop    %ebp
  802b5f:	c3                   	ret    
  802b60:	39 f2                	cmp    %esi,%edx
  802b62:	77 4c                	ja     802bb0 <__umoddi3+0x80>
  802b64:	0f bd ca             	bsr    %edx,%ecx
  802b67:	83 f1 1f             	xor    $0x1f,%ecx
  802b6a:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  802b6d:	75 51                	jne    802bc0 <__umoddi3+0x90>
  802b6f:	3b 7d f4             	cmp    -0xc(%ebp),%edi
  802b72:	0f 87 e0 00 00 00    	ja     802c58 <__umoddi3+0x128>
  802b78:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b7b:	29 f8                	sub    %edi,%eax
  802b7d:	19 d6                	sbb    %edx,%esi
  802b7f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802b82:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b85:	89 f2                	mov    %esi,%edx
  802b87:	83 c4 20             	add    $0x20,%esp
  802b8a:	5e                   	pop    %esi
  802b8b:	5f                   	pop    %edi
  802b8c:	5d                   	pop    %ebp
  802b8d:	c3                   	ret    
  802b8e:	66 90                	xchg   %ax,%ax
  802b90:	85 ff                	test   %edi,%edi
  802b92:	75 0b                	jne    802b9f <__umoddi3+0x6f>
  802b94:	b8 01 00 00 00       	mov    $0x1,%eax
  802b99:	31 d2                	xor    %edx,%edx
  802b9b:	f7 f7                	div    %edi
  802b9d:	89 c7                	mov    %eax,%edi
  802b9f:	89 f0                	mov    %esi,%eax
  802ba1:	31 d2                	xor    %edx,%edx
  802ba3:	f7 f7                	div    %edi
  802ba5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ba8:	f7 f7                	div    %edi
  802baa:	eb a9                	jmp    802b55 <__umoddi3+0x25>
  802bac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802bb0:	89 c8                	mov    %ecx,%eax
  802bb2:	89 f2                	mov    %esi,%edx
  802bb4:	83 c4 20             	add    $0x20,%esp
  802bb7:	5e                   	pop    %esi
  802bb8:	5f                   	pop    %edi
  802bb9:	5d                   	pop    %ebp
  802bba:	c3                   	ret    
  802bbb:	90                   	nop
  802bbc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802bc0:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
  802bc4:	d3 e2                	shl    %cl,%edx
  802bc6:	89 55 f4             	mov    %edx,-0xc(%ebp)
  802bc9:	ba 20 00 00 00       	mov    $0x20,%edx
  802bce:	2b 55 f0             	sub    -0x10(%ebp),%edx
  802bd1:	89 55 ec             	mov    %edx,-0x14(%ebp)
  802bd4:	0f b6 4d ec          	movzbl -0x14(%ebp),%ecx
  802bd8:	89 fa                	mov    %edi,%edx
  802bda:	d3 ea                	shr    %cl,%edx
  802bdc:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
  802be0:	0b 55 f4             	or     -0xc(%ebp),%edx
  802be3:	d3 e7                	shl    %cl,%edi
  802be5:	0f b6 4d ec          	movzbl -0x14(%ebp),%ecx
  802be9:	89 55 f4             	mov    %edx,-0xc(%ebp)
  802bec:	89 f2                	mov    %esi,%edx
  802bee:	89 7d e8             	mov    %edi,-0x18(%ebp)
  802bf1:	89 c7                	mov    %eax,%edi
  802bf3:	d3 ea                	shr    %cl,%edx
  802bf5:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
  802bf9:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  802bfc:	89 c2                	mov    %eax,%edx
  802bfe:	d3 e6                	shl    %cl,%esi
  802c00:	0f b6 4d ec          	movzbl -0x14(%ebp),%ecx
  802c04:	d3 ea                	shr    %cl,%edx
  802c06:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
  802c0a:	09 d6                	or     %edx,%esi
  802c0c:	89 f0                	mov    %esi,%eax
  802c0e:	8b 75 e4             	mov    -0x1c(%ebp),%esi
  802c11:	d3 e7                	shl    %cl,%edi
  802c13:	89 f2                	mov    %esi,%edx
  802c15:	f7 75 f4             	divl   -0xc(%ebp)
  802c18:	89 d6                	mov    %edx,%esi
  802c1a:	f7 65 e8             	mull   -0x18(%ebp)
  802c1d:	39 d6                	cmp    %edx,%esi
  802c1f:	72 2b                	jb     802c4c <__umoddi3+0x11c>
  802c21:	39 c7                	cmp    %eax,%edi
  802c23:	72 23                	jb     802c48 <__umoddi3+0x118>
  802c25:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
  802c29:	29 c7                	sub    %eax,%edi
  802c2b:	19 d6                	sbb    %edx,%esi
  802c2d:	89 f0                	mov    %esi,%eax
  802c2f:	89 f2                	mov    %esi,%edx
  802c31:	d3 ef                	shr    %cl,%edi
  802c33:	0f b6 4d ec          	movzbl -0x14(%ebp),%ecx
  802c37:	d3 e0                	shl    %cl,%eax
  802c39:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
  802c3d:	09 f8                	or     %edi,%eax
  802c3f:	d3 ea                	shr    %cl,%edx
  802c41:	83 c4 20             	add    $0x20,%esp
  802c44:	5e                   	pop    %esi
  802c45:	5f                   	pop    %edi
  802c46:	5d                   	pop    %ebp
  802c47:	c3                   	ret    
  802c48:	39 d6                	cmp    %edx,%esi
  802c4a:	75 d9                	jne    802c25 <__umoddi3+0xf5>
  802c4c:	2b 45 e8             	sub    -0x18(%ebp),%eax
  802c4f:	1b 55 f4             	sbb    -0xc(%ebp),%edx
  802c52:	eb d1                	jmp    802c25 <__umoddi3+0xf5>
  802c54:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802c58:	39 f2                	cmp    %esi,%edx
  802c5a:	0f 82 18 ff ff ff    	jb     802b78 <__umoddi3+0x48>
  802c60:	e9 1d ff ff ff       	jmp    802b82 <__umoddi3+0x52>
