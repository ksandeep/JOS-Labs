
obj/fs/fs:     file format elf32-i386


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
  80002c:	e8 33 1c 00 00       	call   801c64 <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>
	...

00800040 <ide_wait_ready>:

static int diskno = 1;

static int
ide_wait_ready(bool check_error)
{
  800040:	55                   	push   %ebp
  800041:	89 e5                	mov    %esp,%ebp
  800043:	53                   	push   %ebx
  800044:	89 c1                	mov    %eax,%ecx

static __inline uint8_t
inb(int port)
{
	uint8_t data;
	__asm __volatile("inb %w1,%0" : "=a" (data) : "d" (port));
  800046:	ba f7 01 00 00       	mov    $0x1f7,%edx
  80004b:	ec                   	in     (%dx),%al
	int r;

	while (((r = inb(0x1F7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
  80004c:	0f b6 d8             	movzbl %al,%ebx
  80004f:	89 d8                	mov    %ebx,%eax
  800051:	25 c0 00 00 00       	and    $0xc0,%eax
  800056:	83 f8 40             	cmp    $0x40,%eax
  800059:	75 f0                	jne    80004b <ide_wait_ready+0xb>
		/* do nothing */;

	if (check_error && (r & (IDE_DF|IDE_ERR)) != 0)
  80005b:	85 c9                	test   %ecx,%ecx
  80005d:	74 0a                	je     800069 <ide_wait_ready+0x29>
  80005f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  800064:	f6 c3 21             	test   $0x21,%bl
  800067:	75 05                	jne    80006e <ide_wait_ready+0x2e>
  800069:	b8 00 00 00 00       	mov    $0x0,%eax
		return -1;
	return 0;
}
  80006e:	5b                   	pop    %ebx
  80006f:	5d                   	pop    %ebp
  800070:	c3                   	ret    

00800071 <ide_write>:
	return 0;
}

int
ide_write(uint32_t secno, const void *src, size_t nsecs)
{
  800071:	55                   	push   %ebp
  800072:	89 e5                	mov    %esp,%ebp
  800074:	57                   	push   %edi
  800075:	56                   	push   %esi
  800076:	53                   	push   %ebx
  800077:	83 ec 1c             	sub    $0x1c,%esp
  80007a:	8b 75 08             	mov    0x8(%ebp),%esi
  80007d:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800080:	8b 7d 10             	mov    0x10(%ebp),%edi
	int r;
	
	assert(nsecs <= 256);
  800083:	81 ff 00 01 00 00    	cmp    $0x100,%edi
  800089:	76 24                	jbe    8000af <ide_write+0x3e>
  80008b:	c7 44 24 0c c0 44 80 	movl   $0x8044c0,0xc(%esp)
  800092:	00 
  800093:	c7 44 24 08 cd 44 80 	movl   $0x8044cd,0x8(%esp)
  80009a:	00 
  80009b:	c7 44 24 04 5c 00 00 	movl   $0x5c,0x4(%esp)
  8000a2:	00 
  8000a3:	c7 04 24 e2 44 80 00 	movl   $0x8044e2,(%esp)
  8000aa:	e8 21 1c 00 00       	call   801cd0 <_panic>

	ide_wait_ready(0);
  8000af:	b8 00 00 00 00       	mov    $0x0,%eax
  8000b4:	e8 87 ff ff ff       	call   800040 <ide_wait_ready>
}

static __inline void
outb(int port, uint8_t data)
{
	__asm __volatile("outb %0,%w1" : : "a" (data), "d" (port));
  8000b9:	ba f2 01 00 00       	mov    $0x1f2,%edx
  8000be:	89 f8                	mov    %edi,%eax
  8000c0:	ee                   	out    %al,(%dx)
  8000c1:	b2 f3                	mov    $0xf3,%dl
  8000c3:	89 f0                	mov    %esi,%eax
  8000c5:	ee                   	out    %al,(%dx)
  8000c6:	89 f0                	mov    %esi,%eax
  8000c8:	c1 e8 08             	shr    $0x8,%eax
  8000cb:	b2 f4                	mov    $0xf4,%dl
  8000cd:	ee                   	out    %al,(%dx)
  8000ce:	89 f0                	mov    %esi,%eax
  8000d0:	c1 e8 10             	shr    $0x10,%eax
  8000d3:	b2 f5                	mov    $0xf5,%dl
  8000d5:	ee                   	out    %al,(%dx)
  8000d6:	a1 00 80 80 00       	mov    0x808000,%eax
  8000db:	83 e0 01             	and    $0x1,%eax
  8000de:	c1 e0 04             	shl    $0x4,%eax
  8000e1:	83 c8 e0             	or     $0xffffffe0,%eax
  8000e4:	c1 ee 18             	shr    $0x18,%esi
  8000e7:	83 e6 0f             	and    $0xf,%esi
  8000ea:	09 f0                	or     %esi,%eax
  8000ec:	b2 f6                	mov    $0xf6,%dl
  8000ee:	ee                   	out    %al,(%dx)
  8000ef:	b2 f7                	mov    $0xf7,%dl
  8000f1:	b8 30 00 00 00       	mov    $0x30,%eax
  8000f6:	ee                   	out    %al,(%dx)
	outb(0x1F4, (secno >> 8) & 0xFF);
	outb(0x1F5, (secno >> 16) & 0xFF);
	outb(0x1F6, 0xE0 | ((diskno&1)<<4) | ((secno>>24)&0x0F));
	outb(0x1F7, 0x30);	// CMD 0x30 means write sector

	for (; nsecs > 0; nsecs--, src += SECTSIZE) {
  8000f7:	85 ff                	test   %edi,%edi
  8000f9:	74 2a                	je     800125 <ide_write+0xb4>
		if ((r = ide_wait_ready(1)) < 0)
  8000fb:	b8 01 00 00 00       	mov    $0x1,%eax
  800100:	e8 3b ff ff ff       	call   800040 <ide_wait_ready>
  800105:	85 c0                	test   %eax,%eax
  800107:	78 21                	js     80012a <ide_write+0xb9>
}

static __inline void
outsl(int port, const void *addr, int cnt)
{
	__asm __volatile("cld\n\trepne\n\toutsl"		:
  800109:	89 de                	mov    %ebx,%esi
  80010b:	b9 80 00 00 00       	mov    $0x80,%ecx
  800110:	ba f0 01 00 00       	mov    $0x1f0,%edx
  800115:	fc                   	cld    
  800116:	f2 6f                	repnz outsl %ds:(%esi),(%dx)
	outb(0x1F4, (secno >> 8) & 0xFF);
	outb(0x1F5, (secno >> 16) & 0xFF);
	outb(0x1F6, 0xE0 | ((diskno&1)<<4) | ((secno>>24)&0x0F));
	outb(0x1F7, 0x30);	// CMD 0x30 means write sector

	for (; nsecs > 0; nsecs--, src += SECTSIZE) {
  800118:	83 ef 01             	sub    $0x1,%edi
  80011b:	74 08                	je     800125 <ide_write+0xb4>
  80011d:	81 c3 00 02 00 00    	add    $0x200,%ebx
  800123:	eb d6                	jmp    8000fb <ide_write+0x8a>
  800125:	b8 00 00 00 00       	mov    $0x0,%eax
			return r;
		outsl(0x1F0, src, SECTSIZE/4);
	}

	return 0;
}
  80012a:	83 c4 1c             	add    $0x1c,%esp
  80012d:	5b                   	pop    %ebx
  80012e:	5e                   	pop    %esi
  80012f:	5f                   	pop    %edi
  800130:	5d                   	pop    %ebp
  800131:	c3                   	ret    

00800132 <ide_read>:
	diskno = d;
}

int
ide_read(uint32_t secno, void *dst, size_t nsecs)
{
  800132:	55                   	push   %ebp
  800133:	89 e5                	mov    %esp,%ebp
  800135:	57                   	push   %edi
  800136:	56                   	push   %esi
  800137:	53                   	push   %ebx
  800138:	83 ec 1c             	sub    $0x1c,%esp
  80013b:	8b 7d 08             	mov    0x8(%ebp),%edi
  80013e:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800141:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	assert(nsecs <= 256);
  800144:	81 fe 00 01 00 00    	cmp    $0x100,%esi
  80014a:	76 24                	jbe    800170 <ide_read+0x3e>
  80014c:	c7 44 24 0c c0 44 80 	movl   $0x8044c0,0xc(%esp)
  800153:	00 
  800154:	c7 44 24 08 cd 44 80 	movl   $0x8044cd,0x8(%esp)
  80015b:	00 
  80015c:	c7 44 24 04 43 00 00 	movl   $0x43,0x4(%esp)
  800163:	00 
  800164:	c7 04 24 e2 44 80 00 	movl   $0x8044e2,(%esp)
  80016b:	e8 60 1b 00 00       	call   801cd0 <_panic>

	ide_wait_ready(0);
  800170:	b8 00 00 00 00       	mov    $0x0,%eax
  800175:	e8 c6 fe ff ff       	call   800040 <ide_wait_ready>
}

static __inline void
outb(int port, uint8_t data)
{
	__asm __volatile("outb %0,%w1" : : "a" (data), "d" (port));
  80017a:	ba f2 01 00 00       	mov    $0x1f2,%edx
  80017f:	89 f0                	mov    %esi,%eax
  800181:	ee                   	out    %al,(%dx)
  800182:	b2 f3                	mov    $0xf3,%dl
  800184:	89 f8                	mov    %edi,%eax
  800186:	ee                   	out    %al,(%dx)
  800187:	89 f8                	mov    %edi,%eax
  800189:	c1 e8 08             	shr    $0x8,%eax
  80018c:	b2 f4                	mov    $0xf4,%dl
  80018e:	ee                   	out    %al,(%dx)
  80018f:	89 f8                	mov    %edi,%eax
  800191:	c1 e8 10             	shr    $0x10,%eax
  800194:	b2 f5                	mov    $0xf5,%dl
  800196:	ee                   	out    %al,(%dx)
  800197:	a1 00 80 80 00       	mov    0x808000,%eax
  80019c:	83 e0 01             	and    $0x1,%eax
  80019f:	c1 e0 04             	shl    $0x4,%eax
  8001a2:	83 c8 e0             	or     $0xffffffe0,%eax
  8001a5:	c1 ef 18             	shr    $0x18,%edi
  8001a8:	83 e7 0f             	and    $0xf,%edi
  8001ab:	09 f8                	or     %edi,%eax
  8001ad:	b2 f6                	mov    $0xf6,%dl
  8001af:	ee                   	out    %al,(%dx)
  8001b0:	b2 f7                	mov    $0xf7,%dl
  8001b2:	b8 20 00 00 00       	mov    $0x20,%eax
  8001b7:	ee                   	out    %al,(%dx)
	outb(0x1F4, (secno >> 8) & 0xFF);
	outb(0x1F5, (secno >> 16) & 0xFF);
	outb(0x1F6, 0xE0 | ((diskno&1)<<4) | ((secno>>24)&0x0F));
	outb(0x1F7, 0x20);	// CMD 0x20 means read sector

	for (; nsecs > 0; nsecs--, dst += SECTSIZE) {
  8001b8:	85 f6                	test   %esi,%esi
  8001ba:	74 2a                	je     8001e6 <ide_read+0xb4>
		if ((r = ide_wait_ready(1)) < 0)
  8001bc:	b8 01 00 00 00       	mov    $0x1,%eax
  8001c1:	e8 7a fe ff ff       	call   800040 <ide_wait_ready>
  8001c6:	85 c0                	test   %eax,%eax
  8001c8:	78 21                	js     8001eb <ide_read+0xb9>
}

static __inline void
insl(int port, void *addr, int cnt)
{
	__asm __volatile("cld\n\trepne\n\tinsl"			:
  8001ca:	89 df                	mov    %ebx,%edi
  8001cc:	b9 80 00 00 00       	mov    $0x80,%ecx
  8001d1:	ba f0 01 00 00       	mov    $0x1f0,%edx
  8001d6:	fc                   	cld    
  8001d7:	f2 6d                	repnz insl (%dx),%es:(%edi)
	outb(0x1F4, (secno >> 8) & 0xFF);
	outb(0x1F5, (secno >> 16) & 0xFF);
	outb(0x1F6, 0xE0 | ((diskno&1)<<4) | ((secno>>24)&0x0F));
	outb(0x1F7, 0x20);	// CMD 0x20 means read sector

	for (; nsecs > 0; nsecs--, dst += SECTSIZE) {
  8001d9:	83 ee 01             	sub    $0x1,%esi
  8001dc:	74 08                	je     8001e6 <ide_read+0xb4>
  8001de:	81 c3 00 02 00 00    	add    $0x200,%ebx
  8001e4:	eb d6                	jmp    8001bc <ide_read+0x8a>
  8001e6:	b8 00 00 00 00       	mov    $0x0,%eax
			return r;
		insl(0x1F0, dst, SECTSIZE/4);
	}
	
	return 0;
}
  8001eb:	83 c4 1c             	add    $0x1c,%esp
  8001ee:	5b                   	pop    %ebx
  8001ef:	5e                   	pop    %esi
  8001f0:	5f                   	pop    %edi
  8001f1:	5d                   	pop    %ebp
  8001f2:	c3                   	ret    

008001f3 <ide_set_disk>:
	return (x < 1000);
}

void
ide_set_disk(int d)
{
  8001f3:	55                   	push   %ebp
  8001f4:	89 e5                	mov    %esp,%ebp
  8001f6:	83 ec 18             	sub    $0x18,%esp
  8001f9:	8b 45 08             	mov    0x8(%ebp),%eax
	if (d != 0 && d != 1)
  8001fc:	83 f8 01             	cmp    $0x1,%eax
  8001ff:	76 1c                	jbe    80021d <ide_set_disk+0x2a>
		panic("bad disk number");
  800201:	c7 44 24 08 eb 44 80 	movl   $0x8044eb,0x8(%esp)
  800208:	00 
  800209:	c7 44 24 04 3a 00 00 	movl   $0x3a,0x4(%esp)
  800210:	00 
  800211:	c7 04 24 e2 44 80 00 	movl   $0x8044e2,(%esp)
  800218:	e8 b3 1a 00 00       	call   801cd0 <_panic>
	diskno = d;
  80021d:	a3 00 80 80 00       	mov    %eax,0x808000
}
  800222:	c9                   	leave  
  800223:	c3                   	ret    

00800224 <ide_probe_disk1>:
	return 0;
}

bool
ide_probe_disk1(void)
{
  800224:	55                   	push   %ebp
  800225:	89 e5                	mov    %esp,%ebp
  800227:	53                   	push   %ebx
  800228:	83 ec 14             	sub    $0x14,%esp
	int r, x;

	// wait for Device 0 to be ready
	ide_wait_ready(0);
  80022b:	b8 00 00 00 00       	mov    $0x0,%eax
  800230:	e8 0b fe ff ff       	call   800040 <ide_wait_ready>
}

static __inline void
outb(int port, uint8_t data)
{
	__asm __volatile("outb %0,%w1" : : "a" (data), "d" (port));
  800235:	ba f6 01 00 00       	mov    $0x1f6,%edx
  80023a:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  80023f:	ee                   	out    %al,(%dx)

static __inline uint8_t
inb(int port)
{
	uint8_t data;
	__asm __volatile("inb %w1,%0" : "=a" (data) : "d" (port));
  800240:	b2 f7                	mov    $0xf7,%dl
  800242:	ec                   	in     (%dx),%al

	// switch to Device 1
	outb(0x1F6, 0xE0 | (1<<4));

	// check for Device 1 to be ready for a while
	for (x = 0; 
  800243:	b9 01 00 00 00       	mov    $0x1,%ecx
  800248:	a8 a1                	test   $0xa1,%al
  80024a:	75 0f                	jne    80025b <ide_probe_disk1+0x37>
  80024c:	b1 00                	mov    $0x0,%cl
  80024e:	eb 10                	jmp    800260 <ide_probe_disk1+0x3c>
	     x < 1000 && ((r = inb(0x1F7)) & (IDE_BSY|IDE_DF|IDE_ERR)) != 0; 
	     x++)
  800250:	83 c1 01             	add    $0x1,%ecx

	// switch to Device 1
	outb(0x1F6, 0xE0 | (1<<4));

	// check for Device 1 to be ready for a while
	for (x = 0; 
  800253:	81 f9 e8 03 00 00    	cmp    $0x3e8,%ecx
  800259:	74 05                	je     800260 <ide_probe_disk1+0x3c>
  80025b:	ec                   	in     (%dx),%al
  80025c:	a8 a1                	test   $0xa1,%al
  80025e:	75 f0                	jne    800250 <ide_probe_disk1+0x2c>
}

static __inline void
outb(int port, uint8_t data)
{
	__asm __volatile("outb %0,%w1" : : "a" (data), "d" (port));
  800260:	ba f6 01 00 00       	mov    $0x1f6,%edx
  800265:	b8 e0 ff ff ff       	mov    $0xffffffe0,%eax
  80026a:	ee                   	out    %al,(%dx)
		/* do nothing */;

	// switch back to Device 0
	outb(0x1F6, 0xE0 | (0<<4));

	cprintf("Device 1 presence: %d\n", (x < 1000));
  80026b:	81 f9 e7 03 00 00    	cmp    $0x3e7,%ecx
  800271:	0f 9e c3             	setle  %bl
  800274:	0f b6 db             	movzbl %bl,%ebx
  800277:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  80027b:	c7 04 24 fb 44 80 00 	movl   $0x8044fb,(%esp)
  800282:	e8 0e 1b 00 00       	call   801d95 <cprintf>
	return (x < 1000);
}
  800287:	89 d8                	mov    %ebx,%eax
  800289:	83 c4 14             	add    $0x14,%esp
  80028c:	5b                   	pop    %ebx
  80028d:	5d                   	pop    %ebp
  80028e:	c3                   	ret    
	...

00800290 <va_is_mapped>:
}

// Is this virtual address mapped?
bool
va_is_mapped(void *va)
{
  800290:	55                   	push   %ebp
  800291:	89 e5                	mov    %esp,%ebp
	return (vpd[PDX(va)] & PTE_P) && (vpt[VPN(va)] & PTE_P);
  800293:	8b 55 08             	mov    0x8(%ebp),%edx
  800296:	89 d0                	mov    %edx,%eax
  800298:	c1 e8 16             	shr    $0x16,%eax
  80029b:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
  8002a2:	b8 00 00 00 00       	mov    $0x0,%eax
  8002a7:	f6 c1 01             	test   $0x1,%cl
  8002aa:	74 0d                	je     8002b9 <va_is_mapped+0x29>
  8002ac:	c1 ea 0c             	shr    $0xc,%edx
  8002af:	8b 04 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%eax
  8002b6:	83 e0 01             	and    $0x1,%eax
}
  8002b9:	5d                   	pop    %ebp
  8002ba:	c3                   	ret    

008002bb <va_is_dirty>:

// Is this virtual address dirty?
bool
va_is_dirty(void *va)
{
  8002bb:	55                   	push   %ebp
  8002bc:	89 e5                	mov    %esp,%ebp
	return (vpt[VPN(va)] & PTE_D) != 0;
  8002be:	8b 45 08             	mov    0x8(%ebp),%eax
  8002c1:	c1 e8 0c             	shr    $0xc,%eax
  8002c4:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8002cb:	c1 e8 06             	shr    $0x6,%eax
  8002ce:	83 e0 01             	and    $0x1,%eax
}
  8002d1:	5d                   	pop    %ebp
  8002d2:	c3                   	ret    

008002d3 <diskaddr>:
#include "fs.h"

// Return the virtual address of this disk block.
void*
diskaddr(uint32_t blockno)
{
  8002d3:	55                   	push   %ebp
  8002d4:	89 e5                	mov    %esp,%ebp
  8002d6:	83 ec 18             	sub    $0x18,%esp
  8002d9:	8b 45 08             	mov    0x8(%ebp),%eax
	if (blockno == 0 || (super && blockno >= super->s_nblocks))
  8002dc:	85 c0                	test   %eax,%eax
  8002de:	74 0f                	je     8002ef <diskaddr+0x1c>
  8002e0:	8b 15 dc c0 80 00    	mov    0x80c0dc,%edx
  8002e6:	85 d2                	test   %edx,%edx
  8002e8:	74 25                	je     80030f <diskaddr+0x3c>
  8002ea:	3b 42 04             	cmp    0x4(%edx),%eax
  8002ed:	72 20                	jb     80030f <diskaddr+0x3c>
		panic("bad block number %08x in diskaddr", blockno);
  8002ef:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8002f3:	c7 44 24 08 14 45 80 	movl   $0x804514,0x8(%esp)
  8002fa:	00 
  8002fb:	c7 44 24 04 09 00 00 	movl   $0x9,0x4(%esp)
  800302:	00 
  800303:	c7 04 24 b0 45 80 00 	movl   $0x8045b0,(%esp)
  80030a:	e8 c1 19 00 00       	call   801cd0 <_panic>
  80030f:	05 00 00 01 00       	add    $0x10000,%eax
  800314:	c1 e0 0c             	shl    $0xc,%eax
	return (char*) (DISKMAP + blockno * BLKSIZE);
}
  800317:	c9                   	leave  
  800318:	c3                   	ret    

00800319 <bc_pgfault>:
// Fault any disk block that is read or written in to memory by
// loading it from disk.
// Hint: Use ide_read and BLKSECTS.
static void
bc_pgfault(struct UTrapframe *utf)
{
  800319:	55                   	push   %ebp
  80031a:	89 e5                	mov    %esp,%ebp
  80031c:	56                   	push   %esi
  80031d:	53                   	push   %ebx
  80031e:	83 ec 20             	sub    $0x20,%esp
  800321:	8b 45 08             	mov    0x8(%ebp),%eax
	void *addr = (void *) utf->utf_fault_va;
  800324:	8b 18                	mov    (%eax),%ebx
	uint32_t blockno = ((uint32_t)addr - DISKMAP) / BLKSIZE;
	int r;
	// Check that the fault was within the block cache region
	if (addr < (void*)DISKMAP || addr >= (void*)(DISKMAP + DISKSIZE))
  800326:	8d 93 00 00 00 f0    	lea    -0x10000000(%ebx),%edx
  80032c:	81 fa ff ff ff bf    	cmp    $0xbfffffff,%edx
  800332:	76 2e                	jbe    800362 <bc_pgfault+0x49>
		panic("page fault in FS: eip %08x, va %08x, err %04x",
  800334:	8b 50 04             	mov    0x4(%eax),%edx
  800337:	89 54 24 14          	mov    %edx,0x14(%esp)
  80033b:	89 5c 24 10          	mov    %ebx,0x10(%esp)
  80033f:	8b 40 28             	mov    0x28(%eax),%eax
  800342:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800346:	c7 44 24 08 38 45 80 	movl   $0x804538,0x8(%esp)
  80034d:	00 
  80034e:	c7 44 24 04 27 00 00 	movl   $0x27,0x4(%esp)
  800355:	00 
  800356:	c7 04 24 b0 45 80 00 	movl   $0x8045b0,(%esp)
  80035d:	e8 6e 19 00 00       	call   801cd0 <_panic>
	// contents of the block from the disk into that page.
	//
	// LAB 5: Your code here
	// Code added by Sandeep / Swastika
	// use sys_page_alloc to allocate a page
	if ((r = sys_page_alloc(0, ROUNDDOWN(addr, PGSIZE), PTE_U | PTE_P | PTE_W)) < 0)
  800362:	89 de                	mov    %ebx,%esi
  800364:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
  80036a:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  800371:	00 
  800372:	89 74 24 04          	mov    %esi,0x4(%esp)
  800376:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80037d:	e8 c9 28 00 00       	call   802c4b <sys_page_alloc>
  800382:	85 c0                	test   %eax,%eax
  800384:	79 1c                	jns    8003a2 <bc_pgfault+0x89>
		panic ("panic in bc.c: bc_pgfault");
  800386:	c7 44 24 08 b8 45 80 	movl   $0x8045b8,0x8(%esp)
  80038d:	00 
  80038e:	c7 44 24 04 30 00 00 	movl   $0x30,0x4(%esp)
  800395:	00 
  800396:	c7 04 24 b0 45 80 00 	movl   $0x8045b0,(%esp)
  80039d:	e8 2e 19 00 00       	call   801cd0 <_panic>
// Hint: Use ide_read and BLKSECTS.
static void
bc_pgfault(struct UTrapframe *utf)
{
	void *addr = (void *) utf->utf_fault_va;
	uint32_t blockno = ((uint32_t)addr - DISKMAP) / BLKSIZE;
  8003a2:	81 eb 00 00 00 10    	sub    $0x10000000,%ebx
  8003a8:	c1 eb 0c             	shr    $0xc,%ebx
	// use sys_page_alloc to allocate a page
	if ((r = sys_page_alloc(0, ROUNDDOWN(addr, PGSIZE), PTE_U | PTE_P | PTE_W)) < 0)
		panic ("panic in bc.c: bc_pgfault");
	
	// read the contents of the block from disk into this page
	ide_read(blockno*BLKSECTS, ROUNDDOWN(addr, PGSIZE), BLKSECTS);	
  8003ab:	c7 44 24 08 08 00 00 	movl   $0x8,0x8(%esp)
  8003b2:	00 
  8003b3:	89 74 24 04          	mov    %esi,0x4(%esp)
  8003b7:	8d 04 dd 00 00 00 00 	lea    0x0(,%ebx,8),%eax
  8003be:	89 04 24             	mov    %eax,(%esp)
  8003c1:	e8 6c fd ff ff       	call   800132 <ide_read>

	// Sanity check the block number. (exercise for the reader:
	// why do we do this *after* reading the block in?)
	if (super && blockno >= super->s_nblocks)
  8003c6:	a1 dc c0 80 00       	mov    0x80c0dc,%eax
  8003cb:	85 c0                	test   %eax,%eax
  8003cd:	74 25                	je     8003f4 <bc_pgfault+0xdb>
  8003cf:	3b 58 04             	cmp    0x4(%eax),%ebx
  8003d2:	72 20                	jb     8003f4 <bc_pgfault+0xdb>
		panic("reading non-existent block %08x\n", blockno);
  8003d4:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  8003d8:	c7 44 24 08 68 45 80 	movl   $0x804568,0x8(%esp)
  8003df:	00 
  8003e0:	c7 44 24 04 38 00 00 	movl   $0x38,0x4(%esp)
  8003e7:	00 
  8003e8:	c7 04 24 b0 45 80 00 	movl   $0x8045b0,(%esp)
  8003ef:	e8 dc 18 00 00       	call   801cd0 <_panic>

	// Check that the block we read was allocated.
	if (bitmap && block_is_free(blockno))
  8003f4:	83 3d d8 c0 80 00 00 	cmpl   $0x0,0x80c0d8
  8003fb:	74 2c                	je     800429 <bc_pgfault+0x110>
  8003fd:	89 1c 24             	mov    %ebx,(%esp)
  800400:	e8 ab 02 00 00       	call   8006b0 <block_is_free>
  800405:	85 c0                	test   %eax,%eax
  800407:	74 20                	je     800429 <bc_pgfault+0x110>
		panic("reading free block %08x\n", blockno);
  800409:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  80040d:	c7 44 24 08 d2 45 80 	movl   $0x8045d2,0x8(%esp)
  800414:	00 
  800415:	c7 44 24 04 3c 00 00 	movl   $0x3c,0x4(%esp)
  80041c:	00 
  80041d:	c7 04 24 b0 45 80 00 	movl   $0x8045b0,(%esp)
  800424:	e8 a7 18 00 00       	call   801cd0 <_panic>
}
  800429:	83 c4 20             	add    $0x20,%esp
  80042c:	5b                   	pop    %ebx
  80042d:	5e                   	pop    %esi
  80042e:	5d                   	pop    %ebp
  80042f:	c3                   	ret    

00800430 <flush_block>:
// Hint: Use va_is_mapped, va_is_dirty, and ide_write.
// Hint: Use the PTE_USER constant when calling sys_page_map.
// Hint: Don't forget to round addr down.
void
flush_block(void *addr)
{
  800430:	55                   	push   %ebp
  800431:	89 e5                	mov    %esp,%ebp
  800433:	83 ec 28             	sub    $0x28,%esp
  800436:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  800439:	89 75 fc             	mov    %esi,-0x4(%ebp)
  80043c:	8b 5d 08             	mov    0x8(%ebp),%ebx
	uint32_t blockno = ((uint32_t)addr - DISKMAP) / BLKSIZE;

	if (addr < (void*)DISKMAP || addr >= (void*)(DISKMAP + DISKSIZE))
  80043f:	8d 83 00 00 00 f0    	lea    -0x10000000(%ebx),%eax
  800445:	3d ff ff ff bf       	cmp    $0xbfffffff,%eax
  80044a:	76 20                	jbe    80046c <flush_block+0x3c>
		panic("flush_block of bad va %08x", addr);
  80044c:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  800450:	c7 44 24 08 eb 45 80 	movl   $0x8045eb,0x8(%esp)
  800457:	00 
  800458:	c7 44 24 04 4c 00 00 	movl   $0x4c,0x4(%esp)
  80045f:	00 
  800460:	c7 04 24 b0 45 80 00 	movl   $0x8045b0,(%esp)
  800467:	e8 64 18 00 00       	call   801cd0 <_panic>

	// LAB 5: Your code here.
	// Code added by Swastika / Sandeep
	// flush the contents of the block out to disk
	// clear the PTE_D bit
	if(va_is_mapped(addr) && va_is_dirty(addr))
  80046c:	89 1c 24             	mov    %ebx,(%esp)
  80046f:	e8 1c fe ff ff       	call   800290 <va_is_mapped>
  800474:	85 c0                	test   %eax,%eax
  800476:	74 58                	je     8004d0 <flush_block+0xa0>
  800478:	89 1c 24             	mov    %ebx,(%esp)
  80047b:	e8 3b fe ff ff       	call   8002bb <va_is_dirty>
  800480:	85 c0                	test   %eax,%eax
  800482:	74 4c                	je     8004d0 <flush_block+0xa0>
	{
		ide_write(blockno*BLKSECTS, ROUNDDOWN(addr, PGSIZE), BLKSECTS);
  800484:	89 de                	mov    %ebx,%esi
  800486:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
  80048c:	c7 44 24 08 08 00 00 	movl   $0x8,0x8(%esp)
  800493:	00 
  800494:	89 74 24 04          	mov    %esi,0x4(%esp)
  800498:	81 eb 00 00 00 10    	sub    $0x10000000,%ebx
  80049e:	c1 eb 0c             	shr    $0xc,%ebx
  8004a1:	c1 e3 03             	shl    $0x3,%ebx
  8004a4:	89 1c 24             	mov    %ebx,(%esp)
  8004a7:	e8 c5 fb ff ff       	call   800071 <ide_write>
		sys_page_map(0, ROUNDDOWN(addr, PGSIZE), 0, ROUNDDOWN(addr,PGSIZE), PTE_USER);
  8004ac:	c7 44 24 10 07 0e 00 	movl   $0xe07,0x10(%esp)
  8004b3:	00 
  8004b4:	89 74 24 0c          	mov    %esi,0xc(%esp)
  8004b8:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  8004bf:	00 
  8004c0:	89 74 24 04          	mov    %esi,0x4(%esp)
  8004c4:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8004cb:	e8 1d 27 00 00       	call   802bed <sys_page_map>
	}
	// panic("flush_block not implemented");
}
  8004d0:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  8004d3:	8b 75 fc             	mov    -0x4(%ebp),%esi
  8004d6:	89 ec                	mov    %ebp,%esp
  8004d8:	5d                   	pop    %ebp
  8004d9:	c3                   	ret    

008004da <check_bc>:

// Test that the block cache works, by smashing the superblock and
// reading it back.
static void
check_bc(void)
{
  8004da:	55                   	push   %ebp
  8004db:	89 e5                	mov    %esp,%ebp
  8004dd:	81 ec 28 01 00 00    	sub    $0x128,%esp
	struct Super backup;

	// back up super block
	memmove(&backup, diskaddr(1), sizeof backup);
  8004e3:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  8004ea:	e8 e4 fd ff ff       	call   8002d3 <diskaddr>
  8004ef:	c7 44 24 08 08 01 00 	movl   $0x108,0x8(%esp)
  8004f6:	00 
  8004f7:	89 44 24 04          	mov    %eax,0x4(%esp)
  8004fb:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800501:	89 04 24             	mov    %eax,(%esp)
  800504:	e8 0c 21 00 00       	call   802615 <memmove>

	// smash it 
	strcpy(diskaddr(1), "OOPS!\n");
  800509:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  800510:	e8 be fd ff ff       	call   8002d3 <diskaddr>
  800515:	c7 44 24 04 06 46 80 	movl   $0x804606,0x4(%esp)
  80051c:	00 
  80051d:	89 04 24             	mov    %eax,(%esp)
  800520:	e8 35 1f 00 00       	call   80245a <strcpy>
	flush_block(diskaddr(1));
  800525:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  80052c:	e8 a2 fd ff ff       	call   8002d3 <diskaddr>
  800531:	89 04 24             	mov    %eax,(%esp)
  800534:	e8 f7 fe ff ff       	call   800430 <flush_block>
	assert(va_is_mapped(diskaddr(1)));
  800539:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  800540:	e8 8e fd ff ff       	call   8002d3 <diskaddr>
  800545:	89 04 24             	mov    %eax,(%esp)
  800548:	e8 43 fd ff ff       	call   800290 <va_is_mapped>
  80054d:	85 c0                	test   %eax,%eax
  80054f:	75 24                	jne    800575 <check_bc+0x9b>
  800551:	c7 44 24 0c 28 46 80 	movl   $0x804628,0xc(%esp)
  800558:	00 
  800559:	c7 44 24 08 cd 44 80 	movl   $0x8044cd,0x8(%esp)
  800560:	00 
  800561:	c7 44 24 04 67 00 00 	movl   $0x67,0x4(%esp)
  800568:	00 
  800569:	c7 04 24 b0 45 80 00 	movl   $0x8045b0,(%esp)
  800570:	e8 5b 17 00 00       	call   801cd0 <_panic>
	assert(!va_is_dirty(diskaddr(1)));
  800575:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  80057c:	e8 52 fd ff ff       	call   8002d3 <diskaddr>
  800581:	89 04 24             	mov    %eax,(%esp)
  800584:	e8 32 fd ff ff       	call   8002bb <va_is_dirty>
  800589:	85 c0                	test   %eax,%eax
  80058b:	74 24                	je     8005b1 <check_bc+0xd7>
  80058d:	c7 44 24 0c 0d 46 80 	movl   $0x80460d,0xc(%esp)
  800594:	00 
  800595:	c7 44 24 08 cd 44 80 	movl   $0x8044cd,0x8(%esp)
  80059c:	00 
  80059d:	c7 44 24 04 68 00 00 	movl   $0x68,0x4(%esp)
  8005a4:	00 
  8005a5:	c7 04 24 b0 45 80 00 	movl   $0x8045b0,(%esp)
  8005ac:	e8 1f 17 00 00       	call   801cd0 <_panic>

	// clear it out
	sys_page_unmap(0, diskaddr(1));
  8005b1:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  8005b8:	e8 16 fd ff ff       	call   8002d3 <diskaddr>
  8005bd:	89 44 24 04          	mov    %eax,0x4(%esp)
  8005c1:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8005c8:	e8 c2 25 00 00       	call   802b8f <sys_page_unmap>
	assert(!va_is_mapped(diskaddr(1)));
  8005cd:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  8005d4:	e8 fa fc ff ff       	call   8002d3 <diskaddr>
  8005d9:	89 04 24             	mov    %eax,(%esp)
  8005dc:	e8 af fc ff ff       	call   800290 <va_is_mapped>
  8005e1:	85 c0                	test   %eax,%eax
  8005e3:	74 24                	je     800609 <check_bc+0x12f>
  8005e5:	c7 44 24 0c 27 46 80 	movl   $0x804627,0xc(%esp)
  8005ec:	00 
  8005ed:	c7 44 24 08 cd 44 80 	movl   $0x8044cd,0x8(%esp)
  8005f4:	00 
  8005f5:	c7 44 24 04 6c 00 00 	movl   $0x6c,0x4(%esp)
  8005fc:	00 
  8005fd:	c7 04 24 b0 45 80 00 	movl   $0x8045b0,(%esp)
  800604:	e8 c7 16 00 00       	call   801cd0 <_panic>

	// read it back in
	assert(strcmp(diskaddr(1), "OOPS!\n") == 0);
  800609:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  800610:	e8 be fc ff ff       	call   8002d3 <diskaddr>
  800615:	c7 44 24 04 06 46 80 	movl   $0x804606,0x4(%esp)
  80061c:	00 
  80061d:	89 04 24             	mov    %eax,(%esp)
  800620:	e8 c4 1e 00 00       	call   8024e9 <strcmp>
  800625:	85 c0                	test   %eax,%eax
  800627:	74 24                	je     80064d <check_bc+0x173>
  800629:	c7 44 24 0c 8c 45 80 	movl   $0x80458c,0xc(%esp)
  800630:	00 
  800631:	c7 44 24 08 cd 44 80 	movl   $0x8044cd,0x8(%esp)
  800638:	00 
  800639:	c7 44 24 04 6f 00 00 	movl   $0x6f,0x4(%esp)
  800640:	00 
  800641:	c7 04 24 b0 45 80 00 	movl   $0x8045b0,(%esp)
  800648:	e8 83 16 00 00       	call   801cd0 <_panic>

	// fix it
	memmove(diskaddr(1), &backup, sizeof backup);
  80064d:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  800654:	e8 7a fc ff ff       	call   8002d3 <diskaddr>
  800659:	c7 44 24 08 08 01 00 	movl   $0x108,0x8(%esp)
  800660:	00 
  800661:	8d 95 f0 fe ff ff    	lea    -0x110(%ebp),%edx
  800667:	89 54 24 04          	mov    %edx,0x4(%esp)
  80066b:	89 04 24             	mov    %eax,(%esp)
  80066e:	e8 a2 1f 00 00       	call   802615 <memmove>
	flush_block(diskaddr(1));
  800673:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  80067a:	e8 54 fc ff ff       	call   8002d3 <diskaddr>
  80067f:	89 04 24             	mov    %eax,(%esp)
  800682:	e8 a9 fd ff ff       	call   800430 <flush_block>

	cprintf("block cache is good\n");
  800687:	c7 04 24 42 46 80 00 	movl   $0x804642,(%esp)
  80068e:	e8 02 17 00 00       	call   801d95 <cprintf>
}
  800693:	c9                   	leave  
  800694:	c3                   	ret    

00800695 <bc_init>:

void
bc_init(void)
{
  800695:	55                   	push   %ebp
  800696:	89 e5                	mov    %esp,%ebp
  800698:	83 ec 18             	sub    $0x18,%esp
	set_pgfault_handler(bc_pgfault);
  80069b:	c7 04 24 19 03 80 00 	movl   $0x800319,(%esp)
  8006a2:	e8 c9 26 00 00       	call   802d70 <set_pgfault_handler>
	check_bc();
  8006a7:	e8 2e fe ff ff       	call   8004da <check_bc>
}
  8006ac:	c9                   	leave  
  8006ad:	c3                   	ret    
	...

008006b0 <block_is_free>:

// Check to see if the block bitmap indicates that block 'blockno' is free.
// Return 1 if the block is free, 0 if not.
bool
block_is_free(uint32_t blockno)
{
  8006b0:	55                   	push   %ebp
  8006b1:	89 e5                	mov    %esp,%ebp
  8006b3:	53                   	push   %ebx
  8006b4:	8b 45 08             	mov    0x8(%ebp),%eax
	if (super == 0 || blockno >= super->s_nblocks)
  8006b7:	8b 15 dc c0 80 00    	mov    0x80c0dc,%edx
  8006bd:	85 d2                	test   %edx,%edx
  8006bf:	74 25                	je     8006e6 <block_is_free+0x36>
  8006c1:	39 42 04             	cmp    %eax,0x4(%edx)
  8006c4:	76 20                	jbe    8006e6 <block_is_free+0x36>
  8006c6:	89 c1                	mov    %eax,%ecx
  8006c8:	83 e1 1f             	and    $0x1f,%ecx
  8006cb:	ba 01 00 00 00       	mov    $0x1,%edx
  8006d0:	d3 e2                	shl    %cl,%edx
  8006d2:	c1 e8 05             	shr    $0x5,%eax
  8006d5:	8b 1d d8 c0 80 00    	mov    0x80c0d8,%ebx
  8006db:	85 14 83             	test   %edx,(%ebx,%eax,4)
  8006de:	0f 95 c0             	setne  %al
  8006e1:	0f b6 c0             	movzbl %al,%eax
  8006e4:	eb 05                	jmp    8006eb <block_is_free+0x3b>
  8006e6:	b8 00 00 00 00       	mov    $0x0,%eax
		return 0;
	if (bitmap[blockno / 32] & (1 << (blockno % 32)))
		return 1;
	return 0;
}
  8006eb:	5b                   	pop    %ebx
  8006ec:	5d                   	pop    %ebp
  8006ed:	c3                   	ret    

008006ee <skip_slash>:
}

// Skip over slashes.
static const char*
skip_slash(const char *p)
{
  8006ee:	55                   	push   %ebp
  8006ef:	89 e5                	mov    %esp,%ebp
	while (*p == '/')
  8006f1:	80 38 2f             	cmpb   $0x2f,(%eax)
  8006f4:	75 08                	jne    8006fe <skip_slash+0x10>
		p++;
  8006f6:	83 c0 01             	add    $0x1,%eax

// Skip over slashes.
static const char*
skip_slash(const char *p)
{
	while (*p == '/')
  8006f9:	80 38 2f             	cmpb   $0x2f,(%eax)
  8006fc:	74 f8                	je     8006f6 <skip_slash+0x8>
		p++;
	return p;
}
  8006fe:	5d                   	pop    %ebp
  8006ff:	c3                   	ret    

00800700 <fs_sync>:
}

// Sync the entire file system.  A big hammer.
void
fs_sync(void)
{
  800700:	55                   	push   %ebp
  800701:	89 e5                	mov    %esp,%ebp
  800703:	53                   	push   %ebx
  800704:	83 ec 14             	sub    $0x14,%esp
	int i;
	for (i = 1; i < super->s_nblocks; i++)
  800707:	a1 dc c0 80 00       	mov    0x80c0dc,%eax
  80070c:	83 78 04 01          	cmpl   $0x1,0x4(%eax)
  800710:	76 2a                	jbe    80073c <fs_sync+0x3c>
  800712:	b8 01 00 00 00       	mov    $0x1,%eax
  800717:	bb 01 00 00 00       	mov    $0x1,%ebx
		flush_block(diskaddr(i));
  80071c:	89 04 24             	mov    %eax,(%esp)
  80071f:	e8 af fb ff ff       	call   8002d3 <diskaddr>
  800724:	89 04 24             	mov    %eax,(%esp)
  800727:	e8 04 fd ff ff       	call   800430 <flush_block>
// Sync the entire file system.  A big hammer.
void
fs_sync(void)
{
	int i;
	for (i = 1; i < super->s_nblocks; i++)
  80072c:	83 c3 01             	add    $0x1,%ebx
  80072f:	89 d8                	mov    %ebx,%eax
  800731:	8b 15 dc c0 80 00    	mov    0x80c0dc,%edx
  800737:	39 5a 04             	cmp    %ebx,0x4(%edx)
  80073a:	77 e0                	ja     80071c <fs_sync+0x1c>
		flush_block(diskaddr(i));
}
  80073c:	83 c4 14             	add    $0x14,%esp
  80073f:	5b                   	pop    %ebx
  800740:	5d                   	pop    %ebp
  800741:	c3                   	ret    

00800742 <alloc_block>:
// -E_NO_DISK if we are out of blocks.
//
// Hint: use free_block as an example for manipulating the bitmap.
int
alloc_block(void)
{
  800742:	55                   	push   %ebp
  800743:	89 e5                	mov    %esp,%ebp
  800745:	56                   	push   %esi
  800746:	53                   	push   %ebx
  800747:	83 ec 10             	sub    $0x10,%esp

	// LAB 5: Your code here.
	// Code added by Sandeep / Swastika
	int i;
	uint32_t blockno;
	for (blockno = 2 + (super->s_nblocks / BLKBITSIZE); blockno < super->s_nblocks; blockno++)
  80074a:	a1 dc c0 80 00       	mov    0x80c0dc,%eax
  80074f:	8b 70 04             	mov    0x4(%eax),%esi
  800752:	89 f3                	mov    %esi,%ebx
  800754:	c1 eb 0f             	shr    $0xf,%ebx
  800757:	83 c3 02             	add    $0x2,%ebx
  80075a:	39 de                	cmp    %ebx,%esi
  80075c:	76 41                	jbe    80079f <alloc_block+0x5d>
	{
		// cprintf("\n Checking block: %d \n",blockno);
		if(block_is_free(blockno))
  80075e:	89 1c 24             	mov    %ebx,(%esp)
  800761:	e8 4a ff ff ff       	call   8006b0 <block_is_free>
  800766:	85 c0                	test   %eax,%eax
  800768:	74 2e                	je     800798 <alloc_block+0x56>
		{
			// cprintf("\n Found a free block: %d \n",blockno);
			bitmap[blockno/32] &= ~(1<<(blockno%32));
  80076a:	89 d8                	mov    %ebx,%eax
  80076c:	c1 e8 05             	shr    $0x5,%eax
  80076f:	c1 e0 02             	shl    $0x2,%eax
  800772:	03 05 d8 c0 80 00    	add    0x80c0d8,%eax
  800778:	89 d9                	mov    %ebx,%ecx
  80077a:	83 e1 1f             	and    $0x1f,%ecx
  80077d:	ba fe ff ff ff       	mov    $0xfffffffe,%edx
  800782:	d3 c2                	rol    %cl,%edx
  800784:	21 10                	and    %edx,(%eax)
			flush_block((void*)diskaddr(blockno));
  800786:	89 1c 24             	mov    %ebx,(%esp)
  800789:	e8 45 fb ff ff       	call   8002d3 <diskaddr>
  80078e:	89 04 24             	mov    %eax,(%esp)
  800791:	e8 9a fc ff ff       	call   800430 <flush_block>
			return (blockno);
  800796:	eb 0c                	jmp    8007a4 <alloc_block+0x62>

	// LAB 5: Your code here.
	// Code added by Sandeep / Swastika
	int i;
	uint32_t blockno;
	for (blockno = 2 + (super->s_nblocks / BLKBITSIZE); blockno < super->s_nblocks; blockno++)
  800798:	83 c3 01             	add    $0x1,%ebx
  80079b:	39 de                	cmp    %ebx,%esi
  80079d:	77 bf                	ja     80075e <alloc_block+0x1c>
  80079f:	bb f7 ff ff ff       	mov    $0xfffffff7,%ebx
			return (blockno);
		}
	}
	return  -E_NO_DISK;
			
}
  8007a4:	89 d8                	mov    %ebx,%eax
  8007a6:	83 c4 10             	add    $0x10,%esp
  8007a9:	5b                   	pop    %ebx
  8007aa:	5e                   	pop    %esi
  8007ab:	5d                   	pop    %ebp
  8007ac:	c3                   	ret    

008007ad <free_block>:
}

// Mark a block free in the bitmap
void
free_block(uint32_t blockno)
{
  8007ad:	55                   	push   %ebp
  8007ae:	89 e5                	mov    %esp,%ebp
  8007b0:	83 ec 18             	sub    $0x18,%esp
  8007b3:	8b 4d 08             	mov    0x8(%ebp),%ecx
	// Blockno zero is the null pointer of block numbers.
	if (blockno == 0)
  8007b6:	85 c9                	test   %ecx,%ecx
  8007b8:	75 1c                	jne    8007d6 <free_block+0x29>
		panic("attempt to free zero block");
  8007ba:	c7 44 24 08 57 46 80 	movl   $0x804657,0x8(%esp)
  8007c1:	00 
  8007c2:	c7 44 24 04 2c 00 00 	movl   $0x2c,0x4(%esp)
  8007c9:	00 
  8007ca:	c7 04 24 72 46 80 00 	movl   $0x804672,(%esp)
  8007d1:	e8 fa 14 00 00       	call   801cd0 <_panic>
	bitmap[blockno/32] |= 1<<(blockno%32);
  8007d6:	89 c8                	mov    %ecx,%eax
  8007d8:	c1 e8 05             	shr    $0x5,%eax
  8007db:	c1 e0 02             	shl    $0x2,%eax
  8007de:	03 05 d8 c0 80 00    	add    0x80c0d8,%eax
  8007e4:	83 e1 1f             	and    $0x1f,%ecx
  8007e7:	ba 01 00 00 00       	mov    $0x1,%edx
  8007ec:	d3 e2                	shl    %cl,%edx
  8007ee:	09 10                	or     %edx,(%eax)
}
  8007f0:	c9                   	leave  
  8007f1:	c3                   	ret    

008007f2 <check_bitmap>:
//
// Check that all reserved blocks -- 0, 1, and the bitmap blocks themselves --
// are all marked as in-use.
void
check_bitmap(void)
{
  8007f2:	55                   	push   %ebp
  8007f3:	89 e5                	mov    %esp,%ebp
  8007f5:	56                   	push   %esi
  8007f6:	53                   	push   %ebx
  8007f7:	83 ec 10             	sub    $0x10,%esp
	uint32_t i;

	// Make sure all bitmap blocks are marked in-use
	for (i = 0; i * BLKBITSIZE < super->s_nblocks; i++)
  8007fa:	a1 dc c0 80 00       	mov    0x80c0dc,%eax
  8007ff:	8b 70 04             	mov    0x4(%eax),%esi
  800802:	85 f6                	test   %esi,%esi
  800804:	74 44                	je     80084a <check_bitmap+0x58>
  800806:	bb 00 00 00 00       	mov    $0x0,%ebx
		assert(!block_is_free(2+i));
  80080b:	8d 43 02             	lea    0x2(%ebx),%eax
  80080e:	89 04 24             	mov    %eax,(%esp)
  800811:	e8 9a fe ff ff       	call   8006b0 <block_is_free>
  800816:	85 c0                	test   %eax,%eax
  800818:	74 24                	je     80083e <check_bitmap+0x4c>
  80081a:	c7 44 24 0c 7a 46 80 	movl   $0x80467a,0xc(%esp)
  800821:	00 
  800822:	c7 44 24 08 cd 44 80 	movl   $0x8044cd,0x8(%esp)
  800829:	00 
  80082a:	c7 44 24 04 5e 00 00 	movl   $0x5e,0x4(%esp)
  800831:	00 
  800832:	c7 04 24 72 46 80 00 	movl   $0x804672,(%esp)
  800839:	e8 92 14 00 00       	call   801cd0 <_panic>
check_bitmap(void)
{
	uint32_t i;

	// Make sure all bitmap blocks are marked in-use
	for (i = 0; i * BLKBITSIZE < super->s_nblocks; i++)
  80083e:	83 c3 01             	add    $0x1,%ebx
  800841:	89 d8                	mov    %ebx,%eax
  800843:	c1 e0 0f             	shl    $0xf,%eax
  800846:	39 f0                	cmp    %esi,%eax
  800848:	72 c1                	jb     80080b <check_bitmap+0x19>
		assert(!block_is_free(2+i));
	// cprintf("\n the value of i after checking: %d \n", i);
	
	// Make sure the reserved and root blocks are marked in-use.
	assert(!block_is_free(0));
  80084a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  800851:	e8 5a fe ff ff       	call   8006b0 <block_is_free>
  800856:	85 c0                	test   %eax,%eax
  800858:	74 24                	je     80087e <check_bitmap+0x8c>
  80085a:	c7 44 24 0c 8e 46 80 	movl   $0x80468e,0xc(%esp)
  800861:	00 
  800862:	c7 44 24 08 cd 44 80 	movl   $0x8044cd,0x8(%esp)
  800869:	00 
  80086a:	c7 44 24 04 62 00 00 	movl   $0x62,0x4(%esp)
  800871:	00 
  800872:	c7 04 24 72 46 80 00 	movl   $0x804672,(%esp)
  800879:	e8 52 14 00 00       	call   801cd0 <_panic>
	assert(!block_is_free(1));
  80087e:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  800885:	e8 26 fe ff ff       	call   8006b0 <block_is_free>
  80088a:	85 c0                	test   %eax,%eax
  80088c:	74 24                	je     8008b2 <check_bitmap+0xc0>
  80088e:	c7 44 24 0c a0 46 80 	movl   $0x8046a0,0xc(%esp)
  800895:	00 
  800896:	c7 44 24 08 cd 44 80 	movl   $0x8044cd,0x8(%esp)
  80089d:	00 
  80089e:	c7 44 24 04 63 00 00 	movl   $0x63,0x4(%esp)
  8008a5:	00 
  8008a6:	c7 04 24 72 46 80 00 	movl   $0x804672,(%esp)
  8008ad:	e8 1e 14 00 00       	call   801cd0 <_panic>

	cprintf("bitmap is good\n");
  8008b2:	c7 04 24 b2 46 80 00 	movl   $0x8046b2,(%esp)
  8008b9:	e8 d7 14 00 00       	call   801d95 <cprintf>
}
  8008be:	83 c4 10             	add    $0x10,%esp
  8008c1:	5b                   	pop    %ebx
  8008c2:	5e                   	pop    %esi
  8008c3:	5d                   	pop    %ebp
  8008c4:	c3                   	ret    

008008c5 <check_super>:
// --------------------------------------------------------------

// Validate the file system super-block.
void
check_super(void)
{
  8008c5:	55                   	push   %ebp
  8008c6:	89 e5                	mov    %esp,%ebp
  8008c8:	83 ec 18             	sub    $0x18,%esp
	if (super->s_magic != FS_MAGIC)
  8008cb:	a1 dc c0 80 00       	mov    0x80c0dc,%eax
  8008d0:	81 38 ae 30 05 4a    	cmpl   $0x4a0530ae,(%eax)
  8008d6:	74 1c                	je     8008f4 <check_super+0x2f>
		panic("bad file system magic number");
  8008d8:	c7 44 24 08 c2 46 80 	movl   $0x8046c2,0x8(%esp)
  8008df:	00 
  8008e0:	c7 44 24 04 0e 00 00 	movl   $0xe,0x4(%esp)
  8008e7:	00 
  8008e8:	c7 04 24 72 46 80 00 	movl   $0x804672,(%esp)
  8008ef:	e8 dc 13 00 00       	call   801cd0 <_panic>

	if (super->s_nblocks > DISKSIZE/BLKSIZE)
  8008f4:	81 78 04 00 00 0c 00 	cmpl   $0xc0000,0x4(%eax)
  8008fb:	76 1c                	jbe    800919 <check_super+0x54>
		panic("file system is too large");
  8008fd:	c7 44 24 08 df 46 80 	movl   $0x8046df,0x8(%esp)
  800904:	00 
  800905:	c7 44 24 04 11 00 00 	movl   $0x11,0x4(%esp)
  80090c:	00 
  80090d:	c7 04 24 72 46 80 00 	movl   $0x804672,(%esp)
  800914:	e8 b7 13 00 00       	call   801cd0 <_panic>

	cprintf("superblock is good\n");
  800919:	c7 04 24 f8 46 80 00 	movl   $0x8046f8,(%esp)
  800920:	e8 70 14 00 00       	call   801d95 <cprintf>
}
  800925:	c9                   	leave  
  800926:	c3                   	ret    

00800927 <file_block_walk>:
//
// Analogy: This is like pgdir_walk for files.  
// Hint: Don't forget to clear any block you allocate.
static int
file_block_walk(struct File *f, uint32_t filebno, uint32_t **ppdiskbno, bool alloc)
{
  800927:	55                   	push   %ebp
  800928:	89 e5                	mov    %esp,%ebp
  80092a:	83 ec 38             	sub    $0x38,%esp
  80092d:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800930:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800933:	89 7d fc             	mov    %edi,-0x4(%ebp)
  800936:	89 c6                	mov    %eax,%esi
  800938:	89 d7                	mov    %edx,%edi
  80093a:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
	// panic("file_block_walk not implemented");
	
	int blockno;
	uint32_t *ptr;
	// filebno is out of range
	if (filebno >= (NDIRECT + NINDIRECT))
  80093d:	bb fd ff ff ff       	mov    $0xfffffffd,%ebx
  800942:	81 fa 09 04 00 00    	cmp    $0x409,%edx
  800948:	77 76                	ja     8009c0 <file_block_walk+0x99>
		return -E_INVAL;
	// direct block
	if (filebno < NDIRECT)
  80094a:	83 fa 09             	cmp    $0x9,%edx
  80094d:	77 10                	ja     80095f <file_block_walk+0x38>
	{
		*ppdiskbno = &f->f_direct[filebno];
  80094f:	8d 84 90 88 00 00 00 	lea    0x88(%eax,%edx,4),%eax
  800956:	89 01                	mov    %eax,(%ecx)
  800958:	bb 00 00 00 00       	mov    $0x0,%ebx
		return 0;
  80095d:	eb 61                	jmp    8009c0 <file_block_walk+0x99>
	}		
	else
	{
		if (f->f_indirect == 0)
  80095f:	83 b8 b0 00 00 00 00 	cmpl   $0x0,0xb0(%eax)
  800966:	75 3c                	jne    8009a4 <file_block_walk+0x7d>
		{
			if (alloc)
  800968:	bb f5 ff ff ff       	mov    $0xfffffff5,%ebx
  80096d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800971:	74 4d                	je     8009c0 <file_block_walk+0x99>
			{
				if ((blockno = alloc_block()) < 0)
  800973:	e8 ca fd ff ff       	call   800742 <alloc_block>
  800978:	89 c3                	mov    %eax,%ebx
  80097a:	85 c0                	test   %eax,%eax
  80097c:	78 42                	js     8009c0 <file_block_walk+0x99>
					return blockno;		// -E_NO_DISK
				memset(diskaddr(blockno), 0, BLKSIZE);	 
  80097e:	89 04 24             	mov    %eax,(%esp)
  800981:	e8 4d f9 ff ff       	call   8002d3 <diskaddr>
  800986:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
  80098d:	00 
  80098e:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  800995:	00 
  800996:	89 04 24             	mov    %eax,(%esp)
  800999:	e8 18 1c 00 00       	call   8025b6 <memset>
				f->f_indirect = blockno;
  80099e:	89 9e b0 00 00 00    	mov    %ebx,0xb0(%esi)
			else
				return -E_NOT_FOUND;
		}
				
		// we have a valid value in f->f_indirect, hence we can walk the indirect blocks
		ptr = (uint32_t*)  diskaddr(f->f_indirect);
  8009a4:	8b 86 b0 00 00 00    	mov    0xb0(%esi),%eax
  8009aa:	89 04 24             	mov    %eax,(%esp)
  8009ad:	e8 21 f9 ff ff       	call   8002d3 <diskaddr>
		// *ppdiskbno = &ptr[filebno];
		*ppdiskbno = &ptr[filebno - NDIRECT];	//updated as per the course page update
  8009b2:	8d 44 b8 d8          	lea    -0x28(%eax,%edi,4),%eax
  8009b6:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8009b9:	89 02                	mov    %eax,(%edx)
  8009bb:	bb 00 00 00 00       	mov    $0x0,%ebx
		return 0;
	}
}
  8009c0:	89 d8                	mov    %ebx,%eax
  8009c2:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  8009c5:	8b 75 f8             	mov    -0x8(%ebp),%esi
  8009c8:	8b 7d fc             	mov    -0x4(%ebp),%edi
  8009cb:	89 ec                	mov    %ebp,%esp
  8009cd:	5d                   	pop    %ebp
  8009ce:	c3                   	ret    

008009cf <file_truncate_blocks>:
// (Remember to clear the f->f_indirect pointer so you'll know
// whether it's valid!)
// Do not change f->f_size.
static void
file_truncate_blocks(struct File *f, off_t newsize)
{
  8009cf:	55                   	push   %ebp
  8009d0:	89 e5                	mov    %esp,%ebp
  8009d2:	57                   	push   %edi
  8009d3:	56                   	push   %esi
  8009d4:	53                   	push   %ebx
  8009d5:	83 ec 3c             	sub    $0x3c,%esp
  8009d8:	89 c6                	mov    %eax,%esi
	int r;
	uint32_t bno, old_nblocks, new_nblocks;

	old_nblocks = (f->f_size + BLKSIZE - 1) / BLKSIZE;
  8009da:	8b 80 80 00 00 00    	mov    0x80(%eax),%eax
  8009e0:	05 ff 0f 00 00       	add    $0xfff,%eax
  8009e5:	89 c7                	mov    %eax,%edi
  8009e7:	c1 ff 1f             	sar    $0x1f,%edi
  8009ea:	c1 ef 14             	shr    $0x14,%edi
  8009ed:	01 c7                	add    %eax,%edi
  8009ef:	c1 ff 0c             	sar    $0xc,%edi
	new_nblocks = (newsize + BLKSIZE - 1) / BLKSIZE;
  8009f2:	81 c2 ff 0f 00 00    	add    $0xfff,%edx
  8009f8:	89 d0                	mov    %edx,%eax
  8009fa:	c1 f8 1f             	sar    $0x1f,%eax
  8009fd:	c1 e8 14             	shr    $0x14,%eax
  800a00:	8d 14 10             	lea    (%eax,%edx,1),%edx
  800a03:	c1 fa 0c             	sar    $0xc,%edx
  800a06:	89 55 d4             	mov    %edx,-0x2c(%ebp)
	for (bno = new_nblocks; bno < old_nblocks; bno++)
  800a09:	39 d7                	cmp    %edx,%edi
  800a0b:	76 4c                	jbe    800a59 <file_truncate_blocks+0x8a>
  800a0d:	89 d3                	mov    %edx,%ebx
file_free_block(struct File *f, uint32_t filebno)
{
	int r;
	uint32_t *ptr;

	if ((r = file_block_walk(f, filebno, &ptr, 0)) < 0)
  800a0f:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  800a16:	8d 4d e4             	lea    -0x1c(%ebp),%ecx
  800a19:	89 da                	mov    %ebx,%edx
  800a1b:	89 f0                	mov    %esi,%eax
  800a1d:	e8 05 ff ff ff       	call   800927 <file_block_walk>
  800a22:	85 c0                	test   %eax,%eax
  800a24:	78 1c                	js     800a42 <file_truncate_blocks+0x73>
		return r;
	if (*ptr) {
  800a26:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800a29:	8b 00                	mov    (%eax),%eax
  800a2b:	85 c0                	test   %eax,%eax
  800a2d:	74 23                	je     800a52 <file_truncate_blocks+0x83>
		free_block(*ptr);
  800a2f:	89 04 24             	mov    %eax,(%esp)
  800a32:	e8 76 fd ff ff       	call   8007ad <free_block>
		*ptr = 0;
  800a37:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800a3a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  800a40:	eb 10                	jmp    800a52 <file_truncate_blocks+0x83>

	old_nblocks = (f->f_size + BLKSIZE - 1) / BLKSIZE;
	new_nblocks = (newsize + BLKSIZE - 1) / BLKSIZE;
	for (bno = new_nblocks; bno < old_nblocks; bno++)
		if ((r = file_free_block(f, bno)) < 0)
			cprintf("warning: file_free_block: %e", r);
  800a42:	89 44 24 04          	mov    %eax,0x4(%esp)
  800a46:	c7 04 24 0c 47 80 00 	movl   $0x80470c,(%esp)
  800a4d:	e8 43 13 00 00       	call   801d95 <cprintf>
	int r;
	uint32_t bno, old_nblocks, new_nblocks;

	old_nblocks = (f->f_size + BLKSIZE - 1) / BLKSIZE;
	new_nblocks = (newsize + BLKSIZE - 1) / BLKSIZE;
	for (bno = new_nblocks; bno < old_nblocks; bno++)
  800a52:	83 c3 01             	add    $0x1,%ebx
  800a55:	39 df                	cmp    %ebx,%edi
  800a57:	77 b6                	ja     800a0f <file_truncate_blocks+0x40>
		if ((r = file_free_block(f, bno)) < 0)
			cprintf("warning: file_free_block: %e", r);

	if (new_nblocks <= NDIRECT && f->f_indirect) {
  800a59:	83 7d d4 0a          	cmpl   $0xa,-0x2c(%ebp)
  800a5d:	77 1c                	ja     800a7b <file_truncate_blocks+0xac>
  800a5f:	8b 86 b0 00 00 00    	mov    0xb0(%esi),%eax
  800a65:	85 c0                	test   %eax,%eax
  800a67:	74 12                	je     800a7b <file_truncate_blocks+0xac>
		free_block(f->f_indirect);
  800a69:	89 04 24             	mov    %eax,(%esp)
  800a6c:	e8 3c fd ff ff       	call   8007ad <free_block>
		f->f_indirect = 0;
  800a71:	c7 86 b0 00 00 00 00 	movl   $0x0,0xb0(%esi)
  800a78:	00 00 00 
	}
}
  800a7b:	83 c4 3c             	add    $0x3c,%esp
  800a7e:	5b                   	pop    %ebx
  800a7f:	5e                   	pop    %esi
  800a80:	5f                   	pop    %edi
  800a81:	5d                   	pop    %ebp
  800a82:	c3                   	ret    

00800a83 <file_set_size>:

// Set the size of file f, truncating or extending as necessary.
int
file_set_size(struct File *f, off_t newsize)
{
  800a83:	55                   	push   %ebp
  800a84:	89 e5                	mov    %esp,%ebp
  800a86:	83 ec 18             	sub    $0x18,%esp
  800a89:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  800a8c:	89 75 fc             	mov    %esi,-0x4(%ebp)
  800a8f:	8b 5d 08             	mov    0x8(%ebp),%ebx
  800a92:	8b 75 0c             	mov    0xc(%ebp),%esi
	if (f->f_size > newsize)
  800a95:	39 b3 80 00 00 00    	cmp    %esi,0x80(%ebx)
  800a9b:	7e 09                	jle    800aa6 <file_set_size+0x23>
		file_truncate_blocks(f, newsize);
  800a9d:	89 f2                	mov    %esi,%edx
  800a9f:	89 d8                	mov    %ebx,%eax
  800aa1:	e8 29 ff ff ff       	call   8009cf <file_truncate_blocks>
	f->f_size = newsize;
  800aa6:	89 b3 80 00 00 00    	mov    %esi,0x80(%ebx)
	flush_block(f);
  800aac:	89 1c 24             	mov    %ebx,(%esp)
  800aaf:	e8 7c f9 ff ff       	call   800430 <flush_block>
	return 0;
}
  800ab4:	b8 00 00 00 00       	mov    $0x0,%eax
  800ab9:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  800abc:	8b 75 fc             	mov    -0x4(%ebp),%esi
  800abf:	89 ec                	mov    %ebp,%esp
  800ac1:	5d                   	pop    %ebp
  800ac2:	c3                   	ret    

00800ac3 <file_flush>:
// Loop over all the blocks in file.
// Translate the file block number into a disk block number
// and then check whether that disk block is dirty.  If so, write it out.
void
file_flush(struct File *f)
{
  800ac3:	55                   	push   %ebp
  800ac4:	89 e5                	mov    %esp,%ebp
  800ac6:	57                   	push   %edi
  800ac7:	56                   	push   %esi
  800ac8:	53                   	push   %ebx
  800ac9:	83 ec 2c             	sub    $0x2c,%esp
  800acc:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int i;
	uint32_t *pdiskbno;

	for (i = 0; i < (f->f_size + BLKSIZE - 1) / BLKSIZE; i++) {
  800acf:	8b 83 80 00 00 00    	mov    0x80(%ebx),%eax
  800ad5:	05 ff 0f 00 00       	add    $0xfff,%eax
  800ada:	3d ff 0f 00 00       	cmp    $0xfff,%eax
  800adf:	7e 5b                	jle    800b3c <file_flush+0x79>
  800ae1:	be 00 00 00 00       	mov    $0x0,%esi
		if (file_block_walk(f, i, &pdiskbno, 0) < 0 ||
  800ae6:	8d 7d e4             	lea    -0x1c(%ebp),%edi
  800ae9:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  800af0:	89 f9                	mov    %edi,%ecx
  800af2:	89 f2                	mov    %esi,%edx
  800af4:	89 d8                	mov    %ebx,%eax
  800af6:	e8 2c fe ff ff       	call   800927 <file_block_walk>
  800afb:	85 c0                	test   %eax,%eax
  800afd:	78 1d                	js     800b1c <file_flush+0x59>
		    pdiskbno == NULL || *pdiskbno == 0)
  800aff:	8b 45 e4             	mov    -0x1c(%ebp),%eax
{
	int i;
	uint32_t *pdiskbno;

	for (i = 0; i < (f->f_size + BLKSIZE - 1) / BLKSIZE; i++) {
		if (file_block_walk(f, i, &pdiskbno, 0) < 0 ||
  800b02:	85 c0                	test   %eax,%eax
  800b04:	74 16                	je     800b1c <file_flush+0x59>
		    pdiskbno == NULL || *pdiskbno == 0)
  800b06:	8b 00                	mov    (%eax),%eax
{
	int i;
	uint32_t *pdiskbno;

	for (i = 0; i < (f->f_size + BLKSIZE - 1) / BLKSIZE; i++) {
		if (file_block_walk(f, i, &pdiskbno, 0) < 0 ||
  800b08:	85 c0                	test   %eax,%eax
  800b0a:	74 10                	je     800b1c <file_flush+0x59>
		    pdiskbno == NULL || *pdiskbno == 0)
			continue;
		flush_block(diskaddr(*pdiskbno));
  800b0c:	89 04 24             	mov    %eax,(%esp)
  800b0f:	e8 bf f7 ff ff       	call   8002d3 <diskaddr>
  800b14:	89 04 24             	mov    %eax,(%esp)
  800b17:	e8 14 f9 ff ff       	call   800430 <flush_block>
file_flush(struct File *f)
{
	int i;
	uint32_t *pdiskbno;

	for (i = 0; i < (f->f_size + BLKSIZE - 1) / BLKSIZE; i++) {
  800b1c:	83 c6 01             	add    $0x1,%esi
  800b1f:	8b 83 80 00 00 00    	mov    0x80(%ebx),%eax
  800b25:	05 ff 0f 00 00       	add    $0xfff,%eax
  800b2a:	89 c2                	mov    %eax,%edx
  800b2c:	c1 fa 1f             	sar    $0x1f,%edx
  800b2f:	c1 ea 14             	shr    $0x14,%edx
  800b32:	8d 04 02             	lea    (%edx,%eax,1),%eax
  800b35:	c1 f8 0c             	sar    $0xc,%eax
  800b38:	39 f0                	cmp    %esi,%eax
  800b3a:	7f ad                	jg     800ae9 <file_flush+0x26>
		if (file_block_walk(f, i, &pdiskbno, 0) < 0 ||
		    pdiskbno == NULL || *pdiskbno == 0)
			continue;
		flush_block(diskaddr(*pdiskbno));
	}
	flush_block(f);
  800b3c:	89 1c 24             	mov    %ebx,(%esp)
  800b3f:	e8 ec f8 ff ff       	call   800430 <flush_block>
	if (f->f_indirect)
  800b44:	8b 83 b0 00 00 00    	mov    0xb0(%ebx),%eax
  800b4a:	85 c0                	test   %eax,%eax
  800b4c:	74 10                	je     800b5e <file_flush+0x9b>
		flush_block(diskaddr(f->f_indirect));
  800b4e:	89 04 24             	mov    %eax,(%esp)
  800b51:	e8 7d f7 ff ff       	call   8002d3 <diskaddr>
  800b56:	89 04 24             	mov    %eax,(%esp)
  800b59:	e8 d2 f8 ff ff       	call   800430 <flush_block>
}
  800b5e:	83 c4 2c             	add    $0x2c,%esp
  800b61:	5b                   	pop    %ebx
  800b62:	5e                   	pop    %esi
  800b63:	5f                   	pop    %edi
  800b64:	5d                   	pop    %ebp
  800b65:	c3                   	ret    

00800b66 <file_get_block>:
//	-E_INVAL if filebno is out of range.
//
// Hint: Use file_block_walk and alloc_block.
int
file_get_block(struct File *f, uint32_t filebno, char **blk)
{
  800b66:	55                   	push   %ebp
  800b67:	89 e5                	mov    %esp,%ebp
  800b69:	83 ec 28             	sub    $0x28,%esp
	
	//panic("file_get_block not implemented");
	uint32_t *ppdiskbno;
	int r;

	if ((r = file_block_walk(f, filebno, &ppdiskbno, 1)) < 0)
  800b6c:	8d 4d f4             	lea    -0xc(%ebp),%ecx
  800b6f:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  800b76:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b79:	8b 45 08             	mov    0x8(%ebp),%eax
  800b7c:	e8 a6 fd ff ff       	call   800927 <file_block_walk>
  800b81:	85 c0                	test   %eax,%eax
  800b83:	78 30                	js     800bb5 <file_get_block+0x4f>
		return r;		// takes care of -E_INVAL and -E_NO_DISK
	if (*ppdiskbno == 0)
  800b85:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800b88:	83 38 00             	cmpl   $0x0,(%eax)
  800b8b:	75 11                	jne    800b9e <file_get_block+0x38>
	{
		// the block doesn't exist; try to allocate
		if ((r = alloc_block()) < 0)
  800b8d:	8d 76 00             	lea    0x0(%esi),%esi
  800b90:	e8 ad fb ff ff       	call   800742 <alloc_block>
  800b95:	85 c0                	test   %eax,%eax
  800b97:	78 1c                	js     800bb5 <file_get_block+0x4f>
			return r; 	// -E_NO_DISK
		 *ppdiskbno = r;
  800b99:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800b9c:	89 02                	mov    %eax,(%edx)
	}
	// the block exists now
	*blk  = diskaddr (*ppdiskbno);
  800b9e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800ba1:	8b 00                	mov    (%eax),%eax
  800ba3:	89 04 24             	mov    %eax,(%esp)
  800ba6:	e8 28 f7 ff ff       	call   8002d3 <diskaddr>
  800bab:	8b 55 10             	mov    0x10(%ebp),%edx
  800bae:	89 02                	mov    %eax,(%edx)
  800bb0:	b8 00 00 00 00       	mov    $0x0,%eax
	return 0;
}
  800bb5:	c9                   	leave  
  800bb6:	c3                   	ret    

00800bb7 <walk_path>:
// If we cannot find the file but find the directory
// it should be in, set *pdir and copy the final path
// element into lastelem.
static int
walk_path(const char *path, struct File **pdir, struct File **pf, char *lastelem)
{
  800bb7:	55                   	push   %ebp
  800bb8:	89 e5                	mov    %esp,%ebp
  800bba:	57                   	push   %edi
  800bbb:	56                   	push   %esi
  800bbc:	53                   	push   %ebx
  800bbd:	81 ec cc 00 00 00    	sub    $0xcc,%esp
  800bc3:	89 95 40 ff ff ff    	mov    %edx,-0xc0(%ebp)
  800bc9:	89 8d 3c ff ff ff    	mov    %ecx,-0xc4(%ebp)
	struct File *dir, *f;
	int r;

	// if (*path != '/')
	//	return -E_BAD_PATH;
	path = skip_slash(path);
  800bcf:	e8 1a fb ff ff       	call   8006ee <skip_slash>
  800bd4:	89 85 48 ff ff ff    	mov    %eax,-0xb8(%ebp)
	f = &super->s_root;
  800bda:	a1 dc c0 80 00       	mov    0x80c0dc,%eax
	dir = 0;
	name[0] = 0;
  800bdf:	c6 85 68 ff ff ff 00 	movb   $0x0,-0x98(%ebp)

	if (pdir)
  800be6:	83 bd 40 ff ff ff 00 	cmpl   $0x0,-0xc0(%ebp)
  800bed:	74 0c                	je     800bfb <walk_path+0x44>
		*pdir = 0;
  800bef:	8b 95 40 ff ff ff    	mov    -0xc0(%ebp),%edx
  800bf5:	c7 02 00 00 00 00    	movl   $0x0,(%edx)
	int r;

	// if (*path != '/')
	//	return -E_BAD_PATH;
	path = skip_slash(path);
	f = &super->s_root;
  800bfb:	83 c0 08             	add    $0x8,%eax
  800bfe:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%ebp)
	dir = 0;
	name[0] = 0;

	if (pdir)
		*pdir = 0;
	*pf = 0;
  800c04:	8b 8d 3c ff ff ff    	mov    -0xc4(%ebp),%ecx
  800c0a:	c7 01 00 00 00 00    	movl   $0x0,(%ecx)
  800c10:	ba 00 00 00 00       	mov    $0x0,%edx
	while (*path != '\0') {
  800c15:	e9 a0 01 00 00       	jmp    800dba <walk_path+0x203>
		dir = f;
		p = path;
		while (*path != '/' && *path != '\0')
			path++;
  800c1a:	83 c6 01             	add    $0x1,%esi
		*pdir = 0;
	*pf = 0;
	while (*path != '\0') {
		dir = f;
		p = path;
		while (*path != '/' && *path != '\0')
  800c1d:	0f b6 06             	movzbl (%esi),%eax
  800c20:	3c 2f                	cmp    $0x2f,%al
  800c22:	74 04                	je     800c28 <walk_path+0x71>
  800c24:	84 c0                	test   %al,%al
  800c26:	75 f2                	jne    800c1a <walk_path+0x63>
			path++;
		if (path - p >= MAXNAMELEN)
  800c28:	89 f3                	mov    %esi,%ebx
  800c2a:	2b 9d 48 ff ff ff    	sub    -0xb8(%ebp),%ebx
  800c30:	83 fb 7f             	cmp    $0x7f,%ebx
  800c33:	7e 0a                	jle    800c3f <walk_path+0x88>
  800c35:	b8 f4 ff ff ff       	mov    $0xfffffff4,%eax
  800c3a:	e9 c2 01 00 00       	jmp    800e01 <walk_path+0x24a>
			return -E_BAD_PATH;
		memmove(name, p, path - p);
  800c3f:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  800c43:	8b 85 48 ff ff ff    	mov    -0xb8(%ebp),%eax
  800c49:	89 44 24 04          	mov    %eax,0x4(%esp)
  800c4d:	8d 95 68 ff ff ff    	lea    -0x98(%ebp),%edx
  800c53:	89 14 24             	mov    %edx,(%esp)
  800c56:	e8 ba 19 00 00       	call   802615 <memmove>
		name[path - p] = '\0';
  800c5b:	c6 84 1d 68 ff ff ff 	movb   $0x0,-0x98(%ebp,%ebx,1)
  800c62:	00 
		path = skip_slash(path);
  800c63:	89 f0                	mov    %esi,%eax
  800c65:	e8 84 fa ff ff       	call   8006ee <skip_slash>
  800c6a:	89 85 48 ff ff ff    	mov    %eax,-0xb8(%ebp)

		if (dir->f_type != FTYPE_DIR)
  800c70:	8b 8d 4c ff ff ff    	mov    -0xb4(%ebp),%ecx
  800c76:	83 b9 84 00 00 00 01 	cmpl   $0x1,0x84(%ecx)
  800c7d:	0f 85 79 01 00 00    	jne    800dfc <walk_path+0x245>
	struct File *f;

	// Search dir for name.
	// We maintain the invariant that the size of a directory-file
	// is always a multiple of the file system's block size.
	assert((dir->f_size % BLKSIZE) == 0);
  800c83:	8b 81 80 00 00 00    	mov    0x80(%ecx),%eax
  800c89:	a9 ff 0f 00 00       	test   $0xfff,%eax
  800c8e:	74 24                	je     800cb4 <walk_path+0xfd>
  800c90:	c7 44 24 0c 29 47 80 	movl   $0x804729,0xc(%esp)
  800c97:	00 
  800c98:	c7 44 24 08 cd 44 80 	movl   $0x8044cd,0x8(%esp)
  800c9f:	00 
  800ca0:	c7 44 24 04 ee 00 00 	movl   $0xee,0x4(%esp)
  800ca7:	00 
  800ca8:	c7 04 24 72 46 80 00 	movl   $0x804672,(%esp)
  800caf:	e8 1c 10 00 00       	call   801cd0 <_panic>
	nblock = dir->f_size / BLKSIZE;
  800cb4:	89 c2                	mov    %eax,%edx
  800cb6:	c1 fa 1f             	sar    $0x1f,%edx
  800cb9:	c1 ea 14             	shr    $0x14,%edx
  800cbc:	8d 04 02             	lea    (%edx,%eax,1),%eax
  800cbf:	c1 f8 0c             	sar    $0xc,%eax
  800cc2:	89 85 44 ff ff ff    	mov    %eax,-0xbc(%ebp)
	for (i = 0; i < nblock; i++) {
  800cc8:	85 c0                	test   %eax,%eax
  800cca:	0f 84 8a 00 00 00    	je     800d5a <walk_path+0x1a3>
  800cd0:	c7 85 50 ff ff ff 00 	movl   $0x0,-0xb0(%ebp)
  800cd7:	00 00 00 
		if ((r = file_get_block(dir, i, &blk)) < 0)
			return r;
		f = (struct File*) blk;
		for (j = 0; j < BLKFILES; j++)
			if (strcmp(f[j].f_name, name) == 0) {
  800cda:	8d b5 68 ff ff ff    	lea    -0x98(%ebp),%esi
	// We maintain the invariant that the size of a directory-file
	// is always a multiple of the file system's block size.
	assert((dir->f_size % BLKSIZE) == 0);
	nblock = dir->f_size / BLKSIZE;
	for (i = 0; i < nblock; i++) {
		if ((r = file_get_block(dir, i, &blk)) < 0)
  800ce0:	8d 85 64 ff ff ff    	lea    -0x9c(%ebp),%eax
  800ce6:	89 44 24 08          	mov    %eax,0x8(%esp)
  800cea:	8b 95 50 ff ff ff    	mov    -0xb0(%ebp),%edx
  800cf0:	89 54 24 04          	mov    %edx,0x4(%esp)
  800cf4:	8b 8d 4c ff ff ff    	mov    -0xb4(%ebp),%ecx
  800cfa:	89 0c 24             	mov    %ecx,(%esp)
  800cfd:	e8 64 fe ff ff       	call   800b66 <file_get_block>
  800d02:	85 c0                	test   %eax,%eax
  800d04:	78 4b                	js     800d51 <walk_path+0x19a>
  800d06:	8b 9d 64 ff ff ff    	mov    -0x9c(%ebp),%ebx
// and set *pdir to the directory the file is in.
// If we cannot find the file but find the directory
// it should be in, set *pdir and copy the final path
// element into lastelem.
static int
walk_path(const char *path, struct File **pdir, struct File **pf, char *lastelem)
  800d0c:	8d 83 00 10 00 00    	lea    0x1000(%ebx),%eax
  800d12:	89 85 54 ff ff ff    	mov    %eax,-0xac(%ebp)
	for (i = 0; i < nblock; i++) {
		if ((r = file_get_block(dir, i, &blk)) < 0)
			return r;
		f = (struct File*) blk;
		for (j = 0; j < BLKFILES; j++)
			if (strcmp(f[j].f_name, name) == 0) {
  800d18:	89 74 24 04          	mov    %esi,0x4(%esp)
  800d1c:	89 1c 24             	mov    %ebx,(%esp)
  800d1f:	e8 c5 17 00 00       	call   8024e9 <strcmp>
  800d24:	85 c0                	test   %eax,%eax
  800d26:	0f 84 82 00 00 00    	je     800dae <walk_path+0x1f7>
  800d2c:	81 c3 00 01 00 00    	add    $0x100,%ebx
	nblock = dir->f_size / BLKSIZE;
	for (i = 0; i < nblock; i++) {
		if ((r = file_get_block(dir, i, &blk)) < 0)
			return r;
		f = (struct File*) blk;
		for (j = 0; j < BLKFILES; j++)
  800d32:	3b 9d 54 ff ff ff    	cmp    -0xac(%ebp),%ebx
  800d38:	75 de                	jne    800d18 <walk_path+0x161>
	// Search dir for name.
	// We maintain the invariant that the size of a directory-file
	// is always a multiple of the file system's block size.
	assert((dir->f_size % BLKSIZE) == 0);
	nblock = dir->f_size / BLKSIZE;
	for (i = 0; i < nblock; i++) {
  800d3a:	83 85 50 ff ff ff 01 	addl   $0x1,-0xb0(%ebp)
  800d41:	8b 95 50 ff ff ff    	mov    -0xb0(%ebp),%edx
  800d47:	39 95 44 ff ff ff    	cmp    %edx,-0xbc(%ebp)
  800d4d:	77 91                	ja     800ce0 <walk_path+0x129>
  800d4f:	eb 09                	jmp    800d5a <walk_path+0x1a3>

		if (dir->f_type != FTYPE_DIR)
			return -E_NOT_FOUND;

		if ((r = dir_lookup(dir, name, &f)) < 0) {
			if (r == -E_NOT_FOUND && *path == '\0') {
  800d51:	83 f8 f5             	cmp    $0xfffffff5,%eax
  800d54:	0f 85 a7 00 00 00    	jne    800e01 <walk_path+0x24a>
  800d5a:	8b 8d 48 ff ff ff    	mov    -0xb8(%ebp),%ecx
  800d60:	80 39 00             	cmpb   $0x0,(%ecx)
  800d63:	0f 85 93 00 00 00    	jne    800dfc <walk_path+0x245>
				if (pdir)
  800d69:	83 bd 40 ff ff ff 00 	cmpl   $0x0,-0xc0(%ebp)
  800d70:	74 0e                	je     800d80 <walk_path+0x1c9>
					*pdir = dir;
  800d72:	8b 95 4c ff ff ff    	mov    -0xb4(%ebp),%edx
  800d78:	8b 85 40 ff ff ff    	mov    -0xc0(%ebp),%eax
  800d7e:	89 10                	mov    %edx,(%eax)
				if (lastelem)
  800d80:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800d84:	74 15                	je     800d9b <walk_path+0x1e4>
					strcpy(lastelem, name);
  800d86:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
  800d8c:	89 44 24 04          	mov    %eax,0x4(%esp)
  800d90:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800d93:	89 0c 24             	mov    %ecx,(%esp)
  800d96:	e8 bf 16 00 00       	call   80245a <strcpy>
				*pf = 0;
  800d9b:	8b 85 3c ff ff ff    	mov    -0xc4(%ebp),%eax
  800da1:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  800da7:	b8 f5 ff ff ff       	mov    $0xfffffff5,%eax
  800dac:	eb 53                	jmp    800e01 <walk_path+0x24a>
  800dae:	8b 95 4c ff ff ff    	mov    -0xb4(%ebp),%edx
  800db4:	89 9d 4c ff ff ff    	mov    %ebx,-0xb4(%ebp)
	name[0] = 0;

	if (pdir)
		*pdir = 0;
	*pf = 0;
	while (*path != '\0') {
  800dba:	8b 8d 48 ff ff ff    	mov    -0xb8(%ebp),%ecx
  800dc0:	0f b6 01             	movzbl (%ecx),%eax
  800dc3:	84 c0                	test   %al,%al
  800dc5:	74 0f                	je     800dd6 <walk_path+0x21f>
  800dc7:	89 ce                	mov    %ecx,%esi
		dir = f;
		p = path;
		while (*path != '/' && *path != '\0')
  800dc9:	3c 2f                	cmp    $0x2f,%al
  800dcb:	0f 85 49 fe ff ff    	jne    800c1a <walk_path+0x63>
  800dd1:	e9 52 fe ff ff       	jmp    800c28 <walk_path+0x71>
			}
			return r;
		}
	}

	if (pdir)
  800dd6:	83 bd 40 ff ff ff 00 	cmpl   $0x0,-0xc0(%ebp)
  800ddd:	74 08                	je     800de7 <walk_path+0x230>
		*pdir = dir;
  800ddf:	8b 85 40 ff ff ff    	mov    -0xc0(%ebp),%eax
  800de5:	89 10                	mov    %edx,(%eax)
	*pf = f;
  800de7:	8b 8d 4c ff ff ff    	mov    -0xb4(%ebp),%ecx
  800ded:	8b 95 3c ff ff ff    	mov    -0xc4(%ebp),%edx
  800df3:	89 0a                	mov    %ecx,(%edx)
  800df5:	b8 00 00 00 00       	mov    $0x0,%eax
	return 0;
  800dfa:	eb 05                	jmp    800e01 <walk_path+0x24a>
  800dfc:	b8 f5 ff ff ff       	mov    $0xfffffff5,%eax
}
  800e01:	81 c4 cc 00 00 00    	add    $0xcc,%esp
  800e07:	5b                   	pop    %ebx
  800e08:	5e                   	pop    %esi
  800e09:	5f                   	pop    %edi
  800e0a:	5d                   	pop    %ebp
  800e0b:	c3                   	ret    

00800e0c <file_remove>:
}

// Remove a file by truncating it and then zeroing the name.
int
file_remove(const char *path)
{
  800e0c:	55                   	push   %ebp
  800e0d:	89 e5                	mov    %esp,%ebp
  800e0f:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct File *f;

	if ((r = walk_path(path, 0, &f, 0)) < 0)
  800e12:	8d 4d f4             	lea    -0xc(%ebp),%ecx
  800e15:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  800e1c:	ba 00 00 00 00       	mov    $0x0,%edx
  800e21:	8b 45 08             	mov    0x8(%ebp),%eax
  800e24:	e8 8e fd ff ff       	call   800bb7 <walk_path>
  800e29:	85 c0                	test   %eax,%eax
  800e2b:	78 30                	js     800e5d <file_remove+0x51>
		return r;

	file_truncate_blocks(f, 0);
  800e2d:	ba 00 00 00 00       	mov    $0x0,%edx
  800e32:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800e35:	e8 95 fb ff ff       	call   8009cf <file_truncate_blocks>
	f->f_name[0] = '\0';
  800e3a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800e3d:	c6 00 00             	movb   $0x0,(%eax)
	f->f_size = 0;
  800e40:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800e43:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%eax)
  800e4a:	00 00 00 
	flush_block(f);
  800e4d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800e50:	89 04 24             	mov    %eax,(%esp)
  800e53:	e8 d8 f5 ff ff       	call   800430 <flush_block>
  800e58:	b8 00 00 00 00       	mov    $0x0,%eax

	return 0;
}
  800e5d:	c9                   	leave  
  800e5e:	c3                   	ret    

00800e5f <file_open>:

// Open "path".  On success set *pf to point at the file and return 0.
// On error return < 0.
int
file_open(const char *path, struct File **pf)
{
  800e5f:	55                   	push   %ebp
  800e60:	89 e5                	mov    %esp,%ebp
  800e62:	83 ec 18             	sub    $0x18,%esp
	return walk_path(path, 0, pf, 0);
  800e65:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  800e6c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e6f:	ba 00 00 00 00       	mov    $0x0,%edx
  800e74:	8b 45 08             	mov    0x8(%ebp),%eax
  800e77:	e8 3b fd ff ff       	call   800bb7 <walk_path>
}
  800e7c:	c9                   	leave  
  800e7d:	c3                   	ret    

00800e7e <file_write>:
// offset.  This is meant to mimic the standard pwrite function.
// Extends the file if necessary.
// Returns the number of bytes written, < 0 on error.
int
file_write(struct File *f, const void *buf, size_t count, off_t offset)
{
  800e7e:	55                   	push   %ebp
  800e7f:	89 e5                	mov    %esp,%ebp
  800e81:	57                   	push   %edi
  800e82:	56                   	push   %esi
  800e83:	53                   	push   %ebx
  800e84:	83 ec 3c             	sub    $0x3c,%esp
  800e87:	8b 7d 0c             	mov    0xc(%ebp),%edi
  800e8a:	8b 5d 14             	mov    0x14(%ebp),%ebx
	int r, bn;
	off_t pos;
	char *blk;

	// Extend file if necessary
	if (offset + count > f->f_size)
  800e8d:	89 5d d0             	mov    %ebx,-0x30(%ebp)
  800e90:	8b 45 10             	mov    0x10(%ebp),%eax
  800e93:	01 d8                	add    %ebx,%eax
  800e95:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  800e98:	8b 55 08             	mov    0x8(%ebp),%edx
  800e9b:	3b 82 80 00 00 00    	cmp    0x80(%edx),%eax
  800ea1:	77 0d                	ja     800eb0 <file_write+0x32>
		if ((r = file_set_size(f, offset + count)) < 0)
			return r;

	for (pos = offset; pos < offset + count; ) {
  800ea3:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800ea6:	39 45 d0             	cmp    %eax,-0x30(%ebp)
  800ea9:	72 1d                	jb     800ec8 <file_write+0x4a>
  800eab:	e9 85 00 00 00       	jmp    800f35 <file_write+0xb7>
	off_t pos;
	char *blk;

	// Extend file if necessary
	if (offset + count > f->f_size)
		if ((r = file_set_size(f, offset + count)) < 0)
  800eb0:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  800eb3:	89 54 24 04          	mov    %edx,0x4(%esp)
  800eb7:	8b 45 08             	mov    0x8(%ebp),%eax
  800eba:	89 04 24             	mov    %eax,(%esp)
  800ebd:	e8 c1 fb ff ff       	call   800a83 <file_set_size>
  800ec2:	85 c0                	test   %eax,%eax
  800ec4:	79 dd                	jns    800ea3 <file_write+0x25>
  800ec6:	eb 70                	jmp    800f38 <file_write+0xba>
			return r;

	for (pos = offset; pos < offset + count; ) {
		if ((r = file_get_block(f, pos / BLKSIZE, &blk)) < 0)
  800ec8:	8d 55 e4             	lea    -0x1c(%ebp),%edx
  800ecb:	89 54 24 08          	mov    %edx,0x8(%esp)
  800ecf:	89 d8                	mov    %ebx,%eax
  800ed1:	c1 f8 1f             	sar    $0x1f,%eax
  800ed4:	c1 e8 14             	shr    $0x14,%eax
  800ed7:	01 d8                	add    %ebx,%eax
  800ed9:	c1 f8 0c             	sar    $0xc,%eax
  800edc:	89 44 24 04          	mov    %eax,0x4(%esp)
  800ee0:	8b 45 08             	mov    0x8(%ebp),%eax
  800ee3:	89 04 24             	mov    %eax,(%esp)
  800ee6:	e8 7b fc ff ff       	call   800b66 <file_get_block>
  800eeb:	85 c0                	test   %eax,%eax
  800eed:	78 49                	js     800f38 <file_write+0xba>
			return r;
		bn = MIN(BLKSIZE - pos % BLKSIZE, offset + count - pos);
  800eef:	89 da                	mov    %ebx,%edx
  800ef1:	c1 fa 1f             	sar    $0x1f,%edx
  800ef4:	c1 ea 14             	shr    $0x14,%edx
  800ef7:	8d 04 13             	lea    (%ebx,%edx,1),%eax
  800efa:	25 ff 0f 00 00       	and    $0xfff,%eax
  800eff:	29 d0                	sub    %edx,%eax
  800f01:	be 00 10 00 00       	mov    $0x1000,%esi
  800f06:	29 c6                	sub    %eax,%esi
  800f08:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  800f0b:	2b 55 d0             	sub    -0x30(%ebp),%edx
  800f0e:	39 d6                	cmp    %edx,%esi
  800f10:	76 02                	jbe    800f14 <file_write+0x96>
  800f12:	89 d6                	mov    %edx,%esi
		memmove(blk + pos % BLKSIZE, buf, bn);
  800f14:	89 74 24 08          	mov    %esi,0x8(%esp)
  800f18:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800f1c:	03 45 e4             	add    -0x1c(%ebp),%eax
  800f1f:	89 04 24             	mov    %eax,(%esp)
  800f22:	e8 ee 16 00 00       	call   802615 <memmove>
		pos += bn;
  800f27:	01 f3                	add    %esi,%ebx
	// Extend file if necessary
	if (offset + count > f->f_size)
		if ((r = file_set_size(f, offset + count)) < 0)
			return r;

	for (pos = offset; pos < offset + count; ) {
  800f29:	89 5d d0             	mov    %ebx,-0x30(%ebp)
  800f2c:	39 5d d4             	cmp    %ebx,-0x2c(%ebp)
  800f2f:	76 04                	jbe    800f35 <file_write+0xb7>
		if ((r = file_get_block(f, pos / BLKSIZE, &blk)) < 0)
			return r;
		bn = MIN(BLKSIZE - pos % BLKSIZE, offset + count - pos);
		memmove(blk + pos % BLKSIZE, buf, bn);
		pos += bn;
		buf += bn;
  800f31:	01 f7                	add    %esi,%edi
  800f33:	eb 93                	jmp    800ec8 <file_write+0x4a>
	}

	return count;
  800f35:	8b 45 10             	mov    0x10(%ebp),%eax
}
  800f38:	83 c4 3c             	add    $0x3c,%esp
  800f3b:	5b                   	pop    %ebx
  800f3c:	5e                   	pop    %esi
  800f3d:	5f                   	pop    %edi
  800f3e:	5d                   	pop    %ebp
  800f3f:	c3                   	ret    

00800f40 <file_read>:
// Read count bytes from f into buf, starting from seek position
// offset.  This meant to mimic the standard pread function.
// Returns the number of bytes read, < 0 on error.
ssize_t
file_read(struct File *f, void *buf, size_t count, off_t offset)
{
  800f40:	55                   	push   %ebp
  800f41:	89 e5                	mov    %esp,%ebp
  800f43:	57                   	push   %edi
  800f44:	56                   	push   %esi
  800f45:	53                   	push   %ebx
  800f46:	83 ec 3c             	sub    $0x3c,%esp
  800f49:	8b 7d 0c             	mov    0xc(%ebp),%edi
  800f4c:	8b 55 10             	mov    0x10(%ebp),%edx
  800f4f:	8b 5d 14             	mov    0x14(%ebp),%ebx
	int r, bn;
	off_t pos;
	char *blk;

	if (offset >= f->f_size)
  800f52:	8b 45 08             	mov    0x8(%ebp),%eax
  800f55:	8b 88 80 00 00 00    	mov    0x80(%eax),%ecx
  800f5b:	b8 00 00 00 00       	mov    $0x0,%eax
  800f60:	39 d9                	cmp    %ebx,%ecx
  800f62:	0f 8e 8b 00 00 00    	jle    800ff3 <file_read+0xb3>
		return 0;

	count = MIN(count, f->f_size - offset);
  800f68:	29 d9                	sub    %ebx,%ecx
  800f6a:	89 4d cc             	mov    %ecx,-0x34(%ebp)
  800f6d:	39 d1                	cmp    %edx,%ecx
  800f6f:	76 03                	jbe    800f74 <file_read+0x34>
  800f71:	89 55 cc             	mov    %edx,-0x34(%ebp)

	for (pos = offset; pos < offset + count; ) {
  800f74:	89 5d d0             	mov    %ebx,-0x30(%ebp)
  800f77:	8b 45 cc             	mov    -0x34(%ebp),%eax
  800f7a:	01 d8                	add    %ebx,%eax
  800f7c:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  800f7f:	39 d8                	cmp    %ebx,%eax
  800f81:	76 6d                	jbe    800ff0 <file_read+0xb0>
		if ((r = file_get_block(f, pos / BLKSIZE, &blk)) < 0)
  800f83:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  800f86:	89 44 24 08          	mov    %eax,0x8(%esp)
  800f8a:	89 d8                	mov    %ebx,%eax
  800f8c:	c1 f8 1f             	sar    $0x1f,%eax
  800f8f:	c1 e8 14             	shr    $0x14,%eax
  800f92:	01 d8                	add    %ebx,%eax
  800f94:	c1 f8 0c             	sar    $0xc,%eax
  800f97:	89 44 24 04          	mov    %eax,0x4(%esp)
  800f9b:	8b 45 08             	mov    0x8(%ebp),%eax
  800f9e:	89 04 24             	mov    %eax,(%esp)
  800fa1:	e8 c0 fb ff ff       	call   800b66 <file_get_block>
  800fa6:	85 c0                	test   %eax,%eax
  800fa8:	78 49                	js     800ff3 <file_read+0xb3>
			return r;
		bn = MIN(BLKSIZE - pos % BLKSIZE, offset + count - pos);
  800faa:	89 da                	mov    %ebx,%edx
  800fac:	c1 fa 1f             	sar    $0x1f,%edx
  800faf:	c1 ea 14             	shr    $0x14,%edx
  800fb2:	8d 04 13             	lea    (%ebx,%edx,1),%eax
  800fb5:	25 ff 0f 00 00       	and    $0xfff,%eax
  800fba:	29 d0                	sub    %edx,%eax
  800fbc:	be 00 10 00 00       	mov    $0x1000,%esi
  800fc1:	29 c6                	sub    %eax,%esi
  800fc3:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  800fc6:	2b 55 d0             	sub    -0x30(%ebp),%edx
  800fc9:	39 d6                	cmp    %edx,%esi
  800fcb:	76 02                	jbe    800fcf <file_read+0x8f>
  800fcd:	89 d6                	mov    %edx,%esi
		memmove(buf, blk + pos % BLKSIZE, bn);
  800fcf:	89 74 24 08          	mov    %esi,0x8(%esp)
  800fd3:	03 45 e4             	add    -0x1c(%ebp),%eax
  800fd6:	89 44 24 04          	mov    %eax,0x4(%esp)
  800fda:	89 3c 24             	mov    %edi,(%esp)
  800fdd:	e8 33 16 00 00       	call   802615 <memmove>
		pos += bn;
  800fe2:	01 f3                	add    %esi,%ebx
	if (offset >= f->f_size)
		return 0;

	count = MIN(count, f->f_size - offset);

	for (pos = offset; pos < offset + count; ) {
  800fe4:	89 5d d0             	mov    %ebx,-0x30(%ebp)
  800fe7:	39 5d d4             	cmp    %ebx,-0x2c(%ebp)
  800fea:	76 04                	jbe    800ff0 <file_read+0xb0>
		if ((r = file_get_block(f, pos / BLKSIZE, &blk)) < 0)
			return r;
		bn = MIN(BLKSIZE - pos % BLKSIZE, offset + count - pos);
		memmove(buf, blk + pos % BLKSIZE, bn);
		pos += bn;
		buf += bn;
  800fec:	01 f7                	add    %esi,%edi
  800fee:	eb 93                	jmp    800f83 <file_read+0x43>
	}
	return count;
  800ff0:	8b 45 cc             	mov    -0x34(%ebp),%eax
}
  800ff3:	83 c4 3c             	add    $0x3c,%esp
  800ff6:	5b                   	pop    %ebx
  800ff7:	5e                   	pop    %esi
  800ff8:	5f                   	pop    %edi
  800ff9:	5d                   	pop    %ebp
  800ffa:	c3                   	ret    

00800ffb <file_create>:

// Create "path".  On success set *pf to point at the file and return 0.
// On error return < 0.
int
file_create(const char *path, struct File **pf)
{
  800ffb:	55                   	push   %ebp
  800ffc:	89 e5                	mov    %esp,%ebp
  800ffe:	57                   	push   %edi
  800fff:	56                   	push   %esi
  801000:	53                   	push   %ebx
  801001:	81 ec bc 00 00 00    	sub    $0xbc,%esp
	char name[MAXNAMELEN];
	int r;
	struct File *dir, *f;

	if ((r = walk_path(path, &dir, &f, name)) == 0)
  801007:	8d 8d 60 ff ff ff    	lea    -0xa0(%ebp),%ecx
  80100d:	8d 95 64 ff ff ff    	lea    -0x9c(%ebp),%edx
  801013:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
  801019:	89 04 24             	mov    %eax,(%esp)
  80101c:	8b 45 08             	mov    0x8(%ebp),%eax
  80101f:	e8 93 fb ff ff       	call   800bb7 <walk_path>
  801024:	89 c3                	mov    %eax,%ebx
  801026:	85 c0                	test   %eax,%eax
  801028:	0f 84 ed 00 00 00    	je     80111b <file_create+0x120>
		return -E_FILE_EXISTS;
	if (r != -E_NOT_FOUND || dir == 0)
  80102e:	83 f8 f5             	cmp    $0xfffffff5,%eax
  801031:	0f 85 e9 00 00 00    	jne    801120 <file_create+0x125>
  801037:	8b bd 64 ff ff ff    	mov    -0x9c(%ebp),%edi
  80103d:	85 ff                	test   %edi,%edi
  80103f:	0f 84 db 00 00 00    	je     801120 <file_create+0x125>
	int r;
	uint32_t nblock, i, j;
	char *blk;
	struct File *f;

	assert((dir->f_size % BLKSIZE) == 0);
  801045:	8b 87 80 00 00 00    	mov    0x80(%edi),%eax
  80104b:	a9 ff 0f 00 00       	test   $0xfff,%eax
  801050:	74 24                	je     801076 <file_create+0x7b>
  801052:	c7 44 24 0c 29 47 80 	movl   $0x804729,0xc(%esp)
  801059:	00 
  80105a:	c7 44 24 08 cd 44 80 	movl   $0x8044cd,0x8(%esp)
  801061:	00 
  801062:	c7 44 24 04 07 01 00 	movl   $0x107,0x4(%esp)
  801069:	00 
  80106a:	c7 04 24 72 46 80 00 	movl   $0x804672,(%esp)
  801071:	e8 5a 0c 00 00       	call   801cd0 <_panic>
	nblock = dir->f_size / BLKSIZE;
  801076:	89 c2                	mov    %eax,%edx
  801078:	c1 fa 1f             	sar    $0x1f,%edx
  80107b:	c1 ea 14             	shr    $0x14,%edx
  80107e:	8d 04 02             	lea    (%edx,%eax,1),%eax
  801081:	c1 f8 0c             	sar    $0xc,%eax
  801084:	89 85 54 ff ff ff    	mov    %eax,-0xac(%ebp)
	for (i = 0; i < nblock; i++) {
  80108a:	be 00 00 00 00       	mov    $0x0,%esi
  80108f:	85 c0                	test   %eax,%eax
  801091:	74 56                	je     8010e9 <file_create+0xee>
		if ((r = file_get_block(dir, i, &blk)) < 0)
  801093:	8d 85 5c ff ff ff    	lea    -0xa4(%ebp),%eax
  801099:	89 44 24 08          	mov    %eax,0x8(%esp)
  80109d:	89 74 24 04          	mov    %esi,0x4(%esp)
  8010a1:	89 3c 24             	mov    %edi,(%esp)
  8010a4:	e8 bd fa ff ff       	call   800b66 <file_get_block>
  8010a9:	85 c0                	test   %eax,%eax
  8010ab:	78 73                	js     801120 <file_create+0x125>
			return r;
		f = (struct File*) blk;
  8010ad:	8b 8d 5c ff ff ff    	mov    -0xa4(%ebp),%ecx
  8010b3:	89 ca                	mov    %ecx,%edx
		for (j = 0; j < BLKFILES; j++)
			if (f[j].f_name[0] == '\0') {
  8010b5:	80 39 00             	cmpb   $0x0,(%ecx)
  8010b8:	74 13                	je     8010cd <file_create+0xd2>
  8010ba:	8d 81 00 01 00 00    	lea    0x100(%ecx),%eax
// --------------------------------------------------------------

// Create "path".  On success set *pf to point at the file and return 0.
// On error return < 0.
int
file_create(const char *path, struct File **pf)
  8010c0:	81 c1 00 10 00 00    	add    $0x1000,%ecx
  8010c6:	89 c2                	mov    %eax,%edx
	for (i = 0; i < nblock; i++) {
		if ((r = file_get_block(dir, i, &blk)) < 0)
			return r;
		f = (struct File*) blk;
		for (j = 0; j < BLKFILES; j++)
			if (f[j].f_name[0] == '\0') {
  8010c8:	80 38 00             	cmpb   $0x0,(%eax)
  8010cb:	75 08                	jne    8010d5 <file_create+0xda>
				*file = &f[j];
  8010cd:	89 95 60 ff ff ff    	mov    %edx,-0xa0(%ebp)
  8010d3:	eb 58                	jmp    80112d <file_create+0x132>
  8010d5:	05 00 01 00 00       	add    $0x100,%eax
	nblock = dir->f_size / BLKSIZE;
	for (i = 0; i < nblock; i++) {
		if ((r = file_get_block(dir, i, &blk)) < 0)
			return r;
		f = (struct File*) blk;
		for (j = 0; j < BLKFILES; j++)
  8010da:	39 c8                	cmp    %ecx,%eax
  8010dc:	75 e8                	jne    8010c6 <file_create+0xcb>
	char *blk;
	struct File *f;

	assert((dir->f_size % BLKSIZE) == 0);
	nblock = dir->f_size / BLKSIZE;
	for (i = 0; i < nblock; i++) {
  8010de:	83 c6 01             	add    $0x1,%esi
  8010e1:	39 b5 54 ff ff ff    	cmp    %esi,-0xac(%ebp)
  8010e7:	77 aa                	ja     801093 <file_create+0x98>
			if (f[j].f_name[0] == '\0') {
				*file = &f[j];
				return 0;
			}
	}
	dir->f_size += BLKSIZE;
  8010e9:	81 87 80 00 00 00 00 	addl   $0x1000,0x80(%edi)
  8010f0:	10 00 00 
	if ((r = file_get_block(dir, i, &blk)) < 0)
  8010f3:	8d 85 5c ff ff ff    	lea    -0xa4(%ebp),%eax
  8010f9:	89 44 24 08          	mov    %eax,0x8(%esp)
  8010fd:	89 74 24 04          	mov    %esi,0x4(%esp)
  801101:	89 3c 24             	mov    %edi,(%esp)
  801104:	e8 5d fa ff ff       	call   800b66 <file_get_block>
  801109:	85 c0                	test   %eax,%eax
  80110b:	78 13                	js     801120 <file_create+0x125>
		return r;
	f = (struct File*) blk;
	*file = &f[0];
  80110d:	8b 85 5c ff ff ff    	mov    -0xa4(%ebp),%eax
  801113:	89 85 60 ff ff ff    	mov    %eax,-0xa0(%ebp)
  801119:	eb 12                	jmp    80112d <file_create+0x132>
  80111b:	bb f3 ff ff ff       	mov    $0xfffffff3,%ebx
		return r;
	strcpy(f->f_name, name);
	*pf = f;
	file_flush(dir);
	return 0;
}
  801120:	89 d8                	mov    %ebx,%eax
  801122:	81 c4 bc 00 00 00    	add    $0xbc,%esp
  801128:	5b                   	pop    %ebx
  801129:	5e                   	pop    %esi
  80112a:	5f                   	pop    %edi
  80112b:	5d                   	pop    %ebp
  80112c:	c3                   	ret    
		return -E_FILE_EXISTS;
	if (r != -E_NOT_FOUND || dir == 0)
		return r;
	if (dir_alloc_file(dir, &f) < 0)
		return r;
	strcpy(f->f_name, name);
  80112d:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
  801133:	89 44 24 04          	mov    %eax,0x4(%esp)
  801137:	8b 85 60 ff ff ff    	mov    -0xa0(%ebp),%eax
  80113d:	89 04 24             	mov    %eax,(%esp)
  801140:	e8 15 13 00 00       	call   80245a <strcpy>
	*pf = f;
  801145:	8b 95 60 ff ff ff    	mov    -0xa0(%ebp),%edx
  80114b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80114e:	89 10                	mov    %edx,(%eax)
	file_flush(dir);
  801150:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
  801156:	89 04 24             	mov    %eax,(%esp)
  801159:	e8 65 f9 ff ff       	call   800ac3 <file_flush>
  80115e:	bb 00 00 00 00       	mov    $0x0,%ebx
	return 0;
  801163:	eb bb                	jmp    801120 <file_create+0x125>

00801165 <fs_init>:
// --------------------------------------------------------------

// Initialize the file system
void
fs_init(void)
{
  801165:	55                   	push   %ebp
  801166:	89 e5                	mov    %esp,%ebp
  801168:	83 ec 18             	sub    $0x18,%esp
	static_assert(sizeof(struct File) == 256);

	// Find a JOS disk.  Use the second IDE disk (number 1) if available.
	if (ide_probe_disk1())
  80116b:	e8 b4 f0 ff ff       	call   800224 <ide_probe_disk1>
  801170:	85 c0                	test   %eax,%eax
  801172:	74 0e                	je     801182 <fs_init+0x1d>
		ide_set_disk(1);
  801174:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  80117b:	e8 73 f0 ff ff       	call   8001f3 <ide_set_disk>
  801180:	eb 0c                	jmp    80118e <fs_init+0x29>
	else
		ide_set_disk(0);
  801182:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801189:	e8 65 f0 ff ff       	call   8001f3 <ide_set_disk>
	
	bc_init();
  80118e:	66 90                	xchg   %ax,%ax
  801190:	e8 00 f5 ff ff       	call   800695 <bc_init>

	// Set "super" to point to the super block.
	super = diskaddr(1);
  801195:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  80119c:	e8 32 f1 ff ff       	call   8002d3 <diskaddr>
  8011a1:	a3 dc c0 80 00       	mov    %eax,0x80c0dc
	// Set "bitmap" to the beginning of the first bitmap block.
	bitmap = diskaddr(2);
  8011a6:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
  8011ad:	e8 21 f1 ff ff       	call   8002d3 <diskaddr>
  8011b2:	a3 d8 c0 80 00       	mov    %eax,0x80c0d8

	check_super();
  8011b7:	e8 09 f7 ff ff       	call   8008c5 <check_super>
	check_bitmap();
  8011bc:	e8 31 f6 ff ff       	call   8007f2 <check_bitmap>
}
  8011c1:	c9                   	leave  
  8011c2:	c3                   	ret    
	...

008011d0 <serve_init>:
// Virtual address at which to receive page mappings containing client requests.
union Fsipc *fsreq = (union Fsipc *)0x0ffff000;

void
serve_init(void)
{
  8011d0:	55                   	push   %ebp
  8011d1:	89 e5                	mov    %esp,%ebp
  8011d3:	ba 20 80 80 00       	mov    $0x808020,%edx
  8011d8:	b9 00 00 00 d0       	mov    $0xd0000000,%ecx
  8011dd:	b8 00 00 00 00       	mov    $0x0,%eax
	int i;
	uintptr_t va = FILEVA;
	for (i = 0; i < MAXOPEN; i++) {
		opentab[i].o_fileid = i;
  8011e2:	89 02                	mov    %eax,(%edx)
		opentab[i].o_fd = (struct Fd*) va;
  8011e4:	89 4a 0c             	mov    %ecx,0xc(%edx)
		va += PGSIZE;
  8011e7:	81 c1 00 10 00 00    	add    $0x1000,%ecx
void
serve_init(void)
{
	int i;
	uintptr_t va = FILEVA;
	for (i = 0; i < MAXOPEN; i++) {
  8011ed:	83 c0 01             	add    $0x1,%eax
  8011f0:	83 c2 10             	add    $0x10,%edx
  8011f3:	3d 00 04 00 00       	cmp    $0x400,%eax
  8011f8:	75 e8                	jne    8011e2 <serve_init+0x12>
		opentab[i].o_fileid = i;
		opentab[i].o_fd = (struct Fd*) va;
		va += PGSIZE;
	}
}
  8011fa:	5d                   	pop    %ebp
  8011fb:	c3                   	ret    

008011fc <serve_sync>:
}

// Sync the file system.
int
serve_sync(envid_t envid, union Fsipc *req)
{
  8011fc:	55                   	push   %ebp
  8011fd:	89 e5                	mov    %esp,%ebp
  8011ff:	83 ec 08             	sub    $0x8,%esp
	fs_sync();
  801202:	e8 f9 f4 ff ff       	call   800700 <fs_sync>
	return 0;
}
  801207:	b8 00 00 00 00       	mov    $0x0,%eax
  80120c:	c9                   	leave  
  80120d:	c3                   	ret    

0080120e <serve_remove>:
}

// Remove the file req->req_path.
int
serve_remove(envid_t envid, struct Fsreq_remove *req)
{
  80120e:	55                   	push   %ebp
  80120f:	89 e5                	mov    %esp,%ebp
  801211:	53                   	push   %ebx
  801212:	81 ec 14 04 00 00    	sub    $0x414,%esp

	// Delete the named file.
	// Note: This request doesn't refer to an open file.

	// Copy in the path, making sure it's null-terminated
	memmove(path, req->req_path, MAXPATHLEN);
  801218:	c7 44 24 08 00 04 00 	movl   $0x400,0x8(%esp)
  80121f:	00 
  801220:	8b 45 0c             	mov    0xc(%ebp),%eax
  801223:	89 44 24 04          	mov    %eax,0x4(%esp)
  801227:	8d 9d f8 fb ff ff    	lea    -0x408(%ebp),%ebx
  80122d:	89 1c 24             	mov    %ebx,(%esp)
  801230:	e8 e0 13 00 00       	call   802615 <memmove>
	path[MAXPATHLEN-1] = 0;
  801235:	c6 45 f7 00          	movb   $0x0,-0x9(%ebp)

	// Delete the specified file
	return file_remove(path);
  801239:	89 1c 24             	mov    %ebx,(%esp)
  80123c:	e8 cb fb ff ff       	call   800e0c <file_remove>
}
  801241:	81 c4 14 04 00 00    	add    $0x414,%esp
  801247:	5b                   	pop    %ebx
  801248:	5d                   	pop    %ebp
  801249:	c3                   	ret    

0080124a <openfile_lookup>:
}

// Look up an open file for envid.
int
openfile_lookup(envid_t envid, uint32_t fileid, struct OpenFile **po)
{
  80124a:	55                   	push   %ebp
  80124b:	89 e5                	mov    %esp,%ebp
  80124d:	83 ec 18             	sub    $0x18,%esp
  801250:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  801253:	89 75 fc             	mov    %esi,-0x4(%ebp)
  801256:	8b 75 0c             	mov    0xc(%ebp),%esi
	struct OpenFile *o;

	o = &opentab[fileid % MAXOPEN];
  801259:	89 f3                	mov    %esi,%ebx
  80125b:	81 e3 ff 03 00 00    	and    $0x3ff,%ebx
  801261:	c1 e3 04             	shl    $0x4,%ebx
  801264:	81 c3 20 80 80 00    	add    $0x808020,%ebx
	if (pageref(o->o_fd) == 1 || o->o_fileid != fileid)
  80126a:	8b 43 0c             	mov    0xc(%ebx),%eax
  80126d:	89 04 24             	mov    %eax,(%esp)
  801270:	e8 1b 25 00 00       	call   803790 <pageref>
  801275:	83 f8 01             	cmp    $0x1,%eax
  801278:	74 10                	je     80128a <openfile_lookup+0x40>
  80127a:	39 33                	cmp    %esi,(%ebx)
  80127c:	75 0c                	jne    80128a <openfile_lookup+0x40>
		return -E_INVAL;
	*po = o;
  80127e:	8b 45 10             	mov    0x10(%ebp),%eax
  801281:	89 18                	mov    %ebx,(%eax)
  801283:	b8 00 00 00 00       	mov    $0x0,%eax
	return 0;
  801288:	eb 05                	jmp    80128f <openfile_lookup+0x45>
  80128a:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  80128f:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  801292:	8b 75 fc             	mov    -0x4(%ebp),%esi
  801295:	89 ec                	mov    %ebp,%esp
  801297:	5d                   	pop    %ebp
  801298:	c3                   	ret    

00801299 <serve_flush>:
}

// Flush all data and metadata of req->req_fileid to disk.
int
serve_flush(envid_t envid, struct Fsreq_flush *req)
{
  801299:	55                   	push   %ebp
  80129a:	89 e5                	mov    %esp,%ebp
  80129c:	83 ec 28             	sub    $0x28,%esp
	int r;

	if (debug)
		cprintf("serve_flush %08x %08x\n", envid, req->req_fileid);

	if ((r = openfile_lookup(envid, req->req_fileid, &o)) < 0)
  80129f:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8012a2:	89 44 24 08          	mov    %eax,0x8(%esp)
  8012a6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012a9:	8b 00                	mov    (%eax),%eax
  8012ab:	89 44 24 04          	mov    %eax,0x4(%esp)
  8012af:	8b 45 08             	mov    0x8(%ebp),%eax
  8012b2:	89 04 24             	mov    %eax,(%esp)
  8012b5:	e8 90 ff ff ff       	call   80124a <openfile_lookup>
  8012ba:	85 c0                	test   %eax,%eax
  8012bc:	78 13                	js     8012d1 <serve_flush+0x38>
		return r;
	file_flush(o->o_file);
  8012be:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8012c1:	8b 40 04             	mov    0x4(%eax),%eax
  8012c4:	89 04 24             	mov    %eax,(%esp)
  8012c7:	e8 f7 f7 ff ff       	call   800ac3 <file_flush>
  8012cc:	b8 00 00 00 00       	mov    $0x0,%eax
	return 0;
}
  8012d1:	c9                   	leave  
  8012d2:	c3                   	ret    

008012d3 <serve_stat>:

// Stat ipc->stat.req_fileid.  Return the file's struct Stat to the
// caller in ipc->statRet.
int
serve_stat(envid_t envid, union Fsipc *ipc)
{
  8012d3:	55                   	push   %ebp
  8012d4:	89 e5                	mov    %esp,%ebp
  8012d6:	53                   	push   %ebx
  8012d7:	83 ec 24             	sub    $0x24,%esp
  8012da:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;

	if (debug)
		cprintf("serve_stat %08x %08x\n", envid, req->req_fileid);

	if ((r = openfile_lookup(envid, req->req_fileid, &o)) < 0)
  8012dd:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8012e0:	89 44 24 08          	mov    %eax,0x8(%esp)
  8012e4:	8b 03                	mov    (%ebx),%eax
  8012e6:	89 44 24 04          	mov    %eax,0x4(%esp)
  8012ea:	8b 45 08             	mov    0x8(%ebp),%eax
  8012ed:	89 04 24             	mov    %eax,(%esp)
  8012f0:	e8 55 ff ff ff       	call   80124a <openfile_lookup>
  8012f5:	85 c0                	test   %eax,%eax
  8012f7:	78 3f                	js     801338 <serve_stat+0x65>
		return r;

	strcpy(ret->ret_name, o->o_file->f_name);
  8012f9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8012fc:	8b 40 04             	mov    0x4(%eax),%eax
  8012ff:	89 44 24 04          	mov    %eax,0x4(%esp)
  801303:	89 1c 24             	mov    %ebx,(%esp)
  801306:	e8 4f 11 00 00       	call   80245a <strcpy>
	ret->ret_size = o->o_file->f_size;
  80130b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80130e:	8b 50 04             	mov    0x4(%eax),%edx
  801311:	8b 92 80 00 00 00    	mov    0x80(%edx),%edx
  801317:	89 93 80 00 00 00    	mov    %edx,0x80(%ebx)
	ret->ret_isdir = (o->o_file->f_type == FTYPE_DIR);
  80131d:	8b 40 04             	mov    0x4(%eax),%eax
  801320:	83 b8 84 00 00 00 01 	cmpl   $0x1,0x84(%eax)
  801327:	0f 94 c0             	sete   %al
  80132a:	0f b6 c0             	movzbl %al,%eax
  80132d:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
  801333:	b8 00 00 00 00       	mov    $0x0,%eax
	return 0;
}
  801338:	83 c4 24             	add    $0x24,%esp
  80133b:	5b                   	pop    %ebx
  80133c:	5d                   	pop    %ebp
  80133d:	c3                   	ret    

0080133e <serve_write>:
// the current seek position, and update the seek position
// accordingly.  Extend the file if necessary.  Returns the number of
// bytes written, or < 0 on error.
int
serve_write(envid_t envid, struct Fsreq_write *req)
{
  80133e:	55                   	push   %ebp
  80133f:	89 e5                	mov    %esp,%ebp
  801341:	56                   	push   %esi
  801342:	53                   	push   %ebx
  801343:	83 ec 20             	sub    $0x20,%esp
  801346:	8b 5d 0c             	mov    0xc(%ebp),%ebx

	// LAB 5: Your code here.
	// Code added by Sandeep / Swastika
	struct OpenFile *o;
	int r;
	int size = req->req_n;
  801349:	8b 43 04             	mov    0x4(%ebx),%eax
  80134c:	89 c6                	mov    %eax,%esi
	if (size > PGSIZE - (sizeof(int) + sizeof(size_t)))
  80134e:	3d f8 0f 00 00       	cmp    $0xff8,%eax
  801353:	76 05                	jbe    80135a <serve_write+0x1c>
  801355:	be f8 0f 00 00       	mov    $0xff8,%esi
		size = PGSIZE - (sizeof(int) + sizeof(size_t));
	if ((r = openfile_lookup(envid, req->req_fileid, &o)) < 0)
  80135a:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80135d:	89 44 24 08          	mov    %eax,0x8(%esp)
  801361:	8b 03                	mov    (%ebx),%eax
  801363:	89 44 24 04          	mov    %eax,0x4(%esp)
  801367:	8b 45 08             	mov    0x8(%ebp),%eax
  80136a:	89 04 24             	mov    %eax,(%esp)
  80136d:	e8 d8 fe ff ff       	call   80124a <openfile_lookup>
  801372:	85 c0                	test   %eax,%eax
  801374:	78 30                	js     8013a6 <serve_write+0x68>
		return r;
	if ((r = file_write(o->o_file, req->req_buf, size, o->o_fd->fd_offset)) < 0)
  801376:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801379:	8b 50 0c             	mov    0xc(%eax),%edx
  80137c:	8b 52 04             	mov    0x4(%edx),%edx
  80137f:	89 54 24 0c          	mov    %edx,0xc(%esp)
  801383:	89 74 24 08          	mov    %esi,0x8(%esp)
  801387:	83 c3 08             	add    $0x8,%ebx
  80138a:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  80138e:	8b 40 04             	mov    0x4(%eax),%eax
  801391:	89 04 24             	mov    %eax,(%esp)
  801394:	e8 e5 fa ff ff       	call   800e7e <file_write>
  801399:	85 c0                	test   %eax,%eax
  80139b:	78 09                	js     8013a6 <serve_write+0x68>
		return r;
	o->o_fd->fd_offset = o->o_fd->fd_offset + r;
  80139d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8013a0:	8b 52 0c             	mov    0xc(%edx),%edx
  8013a3:	01 42 04             	add    %eax,0x4(%edx)
	return r;

	// panic("serve_write not implemented");
}
  8013a6:	83 c4 20             	add    $0x20,%esp
  8013a9:	5b                   	pop    %ebx
  8013aa:	5e                   	pop    %esi
  8013ab:	5d                   	pop    %ebp
  8013ac:	c3                   	ret    

008013ad <serve_read>:
// in ipc->read.req_fileid.  Return the bytes read from the file to
// the caller in ipc->readRet, then update the seek position.  Returns
// the number of bytes successfully read, or < 0 on error.
int
serve_read(envid_t envid, union Fsipc *ipc)
{
  8013ad:	55                   	push   %ebp
  8013ae:	89 e5                	mov    %esp,%ebp
  8013b0:	56                   	push   %esi
  8013b1:	53                   	push   %ebx
  8013b2:	83 ec 20             	sub    $0x20,%esp
  8013b5:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	// Hint: The seek position is stored in the struct Fd.
	// LAB 5: Your code here
	// Code added by Swastika / Sandeep
	struct OpenFile *o;
	int r;
	int size = req->req_n;
  8013b8:	8b 73 04             	mov    0x4(%ebx),%esi
	if (size > PGSIZE)
		size = PGSIZE;
	if ((r = openfile_lookup(envid, req->req_fileid, &o)) < 0)
  8013bb:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8013be:	89 44 24 08          	mov    %eax,0x8(%esp)
  8013c2:	8b 03                	mov    (%ebx),%eax
  8013c4:	89 44 24 04          	mov    %eax,0x4(%esp)
  8013c8:	8b 45 08             	mov    0x8(%ebp),%eax
  8013cb:	89 04 24             	mov    %eax,(%esp)
  8013ce:	e8 77 fe ff ff       	call   80124a <openfile_lookup>
  8013d3:	85 c0                	test   %eax,%eax
  8013d5:	78 3a                	js     801411 <serve_read+0x64>
		return r;
	if ((r = file_read(o->o_file, ret->ret_buf, size, o->o_fd->fd_offset )) < 0)
  8013d7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8013da:	8b 50 0c             	mov    0xc(%eax),%edx
  8013dd:	8b 52 04             	mov    0x4(%edx),%edx
  8013e0:	89 54 24 0c          	mov    %edx,0xc(%esp)
  8013e4:	81 fe 00 10 00 00    	cmp    $0x1000,%esi
  8013ea:	7e 05                	jle    8013f1 <serve_read+0x44>
  8013ec:	be 00 10 00 00       	mov    $0x1000,%esi
  8013f1:	89 74 24 08          	mov    %esi,0x8(%esp)
  8013f5:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8013f9:	8b 40 04             	mov    0x4(%eax),%eax
  8013fc:	89 04 24             	mov    %eax,(%esp)
  8013ff:	e8 3c fb ff ff       	call   800f40 <file_read>
  801404:	85 c0                	test   %eax,%eax
  801406:	78 09                	js     801411 <serve_read+0x64>
		return r;
	o->o_fd->fd_offset = o->o_fd->fd_offset + r;
  801408:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80140b:	8b 52 0c             	mov    0xc(%edx),%edx
  80140e:	01 42 04             	add    %eax,0x4(%edx)
	return r;
	//panic("serve_read not implemented");
}
  801411:	83 c4 20             	add    $0x20,%esp
  801414:	5b                   	pop    %ebx
  801415:	5e                   	pop    %esi
  801416:	5d                   	pop    %ebp
  801417:	c3                   	ret    

00801418 <serve_set_size>:

// Set the size of req->req_fileid to req->req_size bytes, truncating
// or extending the file as necessary.
int
serve_set_size(envid_t envid, struct Fsreq_set_size *req)
{
  801418:	55                   	push   %ebp
  801419:	89 e5                	mov    %esp,%ebp
  80141b:	53                   	push   %ebx
  80141c:	83 ec 24             	sub    $0x24,%esp
  80141f:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	// Every file system IPC call has the same general structure.
	// Here's how it goes.

	// First, use openfile_lookup to find the relevant open file.
	// On failure, return the error code to the client with ipc_send.
	if ((r = openfile_lookup(envid, req->req_fileid, &o)) < 0)
  801422:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801425:	89 44 24 08          	mov    %eax,0x8(%esp)
  801429:	8b 03                	mov    (%ebx),%eax
  80142b:	89 44 24 04          	mov    %eax,0x4(%esp)
  80142f:	8b 45 08             	mov    0x8(%ebp),%eax
  801432:	89 04 24             	mov    %eax,(%esp)
  801435:	e8 10 fe ff ff       	call   80124a <openfile_lookup>
  80143a:	85 c0                	test   %eax,%eax
  80143c:	78 15                	js     801453 <serve_set_size+0x3b>
		return r;

	// Second, call the relevant file system function (from fs/fs.c).
	// On failure, return the error code to the client.
	return file_set_size(o->o_file, req->req_size);
  80143e:	8b 43 04             	mov    0x4(%ebx),%eax
  801441:	89 44 24 04          	mov    %eax,0x4(%esp)
  801445:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801448:	8b 40 04             	mov    0x4(%eax),%eax
  80144b:	89 04 24             	mov    %eax,(%esp)
  80144e:	e8 30 f6 ff ff       	call   800a83 <file_set_size>
}
  801453:	83 c4 24             	add    $0x24,%esp
  801456:	5b                   	pop    %ebx
  801457:	5d                   	pop    %ebp
  801458:	c3                   	ret    

00801459 <openfile_alloc>:
}

// Allocate an open file.
int
openfile_alloc(struct OpenFile **o)
{
  801459:	55                   	push   %ebp
  80145a:	89 e5                	mov    %esp,%ebp
  80145c:	83 ec 28             	sub    $0x28,%esp
  80145f:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  801462:	89 75 f8             	mov    %esi,-0x8(%ebp)
  801465:	89 7d fc             	mov    %edi,-0x4(%ebp)
  801468:	8b 7d 08             	mov    0x8(%ebp),%edi
  80146b:	bb 00 00 00 00       	mov    $0x0,%ebx
	int i, r;

	// Find an available open-file table entry
	for (i = 0; i < MAXOPEN; i++) {
		switch (pageref(opentab[i].o_fd)) {
  801470:	be 2c 80 80 00       	mov    $0x80802c,%esi
  801475:	89 d8                	mov    %ebx,%eax
  801477:	c1 e0 04             	shl    $0x4,%eax
  80147a:	8b 04 06             	mov    (%esi,%eax,1),%eax
  80147d:	89 04 24             	mov    %eax,(%esp)
  801480:	e8 0b 23 00 00       	call   803790 <pageref>
  801485:	85 c0                	test   %eax,%eax
  801487:	74 09                	je     801492 <openfile_alloc+0x39>
  801489:	83 f8 01             	cmp    $0x1,%eax
  80148c:	75 64                	jne    8014f2 <openfile_alloc+0x99>
  80148e:	66 90                	xchg   %ax,%ax
  801490:	eb 27                	jmp    8014b9 <openfile_alloc+0x60>
		case 0:
			if ((r = sys_page_alloc(0, opentab[i].o_fd, PTE_P|PTE_U|PTE_W)) < 0)
  801492:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  801499:	00 
  80149a:	89 d8                	mov    %ebx,%eax
  80149c:	c1 e0 04             	shl    $0x4,%eax
  80149f:	8b 80 2c 80 80 00    	mov    0x80802c(%eax),%eax
  8014a5:	89 44 24 04          	mov    %eax,0x4(%esp)
  8014a9:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8014b0:	e8 96 17 00 00       	call   802c4b <sys_page_alloc>
  8014b5:	85 c0                	test   %eax,%eax
  8014b7:	78 4d                	js     801506 <openfile_alloc+0xad>
				return r;
			/* fall through */
		case 1:
			opentab[i].o_fileid += MAXOPEN;
  8014b9:	c1 e3 04             	shl    $0x4,%ebx
  8014bc:	81 83 20 80 80 00 00 	addl   $0x400,0x808020(%ebx)
  8014c3:	04 00 00 
			*o = &opentab[i];
  8014c6:	8d 83 20 80 80 00    	lea    0x808020(%ebx),%eax
  8014cc:	89 07                	mov    %eax,(%edi)
			memset(opentab[i].o_fd, 0, PGSIZE);
  8014ce:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
  8014d5:	00 
  8014d6:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  8014dd:	00 
  8014de:	8b 83 2c 80 80 00    	mov    0x80802c(%ebx),%eax
  8014e4:	89 04 24             	mov    %eax,(%esp)
  8014e7:	e8 ca 10 00 00       	call   8025b6 <memset>
			return (*o)->o_fileid;
  8014ec:	8b 07                	mov    (%edi),%eax
  8014ee:	8b 00                	mov    (%eax),%eax
  8014f0:	eb 14                	jmp    801506 <openfile_alloc+0xad>
openfile_alloc(struct OpenFile **o)
{
	int i, r;

	// Find an available open-file table entry
	for (i = 0; i < MAXOPEN; i++) {
  8014f2:	83 c3 01             	add    $0x1,%ebx
  8014f5:	81 fb 00 04 00 00    	cmp    $0x400,%ebx
  8014fb:	0f 85 74 ff ff ff    	jne    801475 <openfile_alloc+0x1c>
  801501:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
			memset(opentab[i].o_fd, 0, PGSIZE);
			return (*o)->o_fileid;
		}
	}
	return -E_MAX_OPEN;
}
  801506:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  801509:	8b 75 f8             	mov    -0x8(%ebp),%esi
  80150c:	8b 7d fc             	mov    -0x4(%ebp),%edi
  80150f:	89 ec                	mov    %ebp,%esp
  801511:	5d                   	pop    %ebp
  801512:	c3                   	ret    

00801513 <serve_open>:
// permissions to return to the calling environment in *pg_store and
// *perm_store respectively.
int
serve_open(envid_t envid, struct Fsreq_open *req,
	   void **pg_store, int *perm_store)
{
  801513:	55                   	push   %ebp
  801514:	89 e5                	mov    %esp,%ebp
  801516:	53                   	push   %ebx
  801517:	81 ec 24 04 00 00    	sub    $0x424,%esp
  80151d:	8b 5d 0c             	mov    0xc(%ebp),%ebx

	if (debug)
		cprintf("serve_open %08x %s 0x%x\n", envid, req->req_path, req->req_omode);

	// Copy in the path, making sure it's null-terminated
	memmove(path, req->req_path, MAXPATHLEN);
  801520:	c7 44 24 08 00 04 00 	movl   $0x400,0x8(%esp)
  801527:	00 
  801528:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  80152c:	8d 85 f8 fb ff ff    	lea    -0x408(%ebp),%eax
  801532:	89 04 24             	mov    %eax,(%esp)
  801535:	e8 db 10 00 00       	call   802615 <memmove>
	path[MAXPATHLEN-1] = 0;
  80153a:	c6 45 f7 00          	movb   $0x0,-0x9(%ebp)

	// Find an open file ID
	if ((r = openfile_alloc(&o)) < 0) {
  80153e:	8d 85 f0 fb ff ff    	lea    -0x410(%ebp),%eax
  801544:	89 04 24             	mov    %eax,(%esp)
  801547:	e8 0d ff ff ff       	call   801459 <openfile_alloc>
  80154c:	85 c0                	test   %eax,%eax
  80154e:	0f 88 ec 00 00 00    	js     801640 <serve_open+0x12d>
		return r;
	}
	fileid = r;

	// Open the file
	if (req->req_omode & O_CREAT) {
  801554:	f6 83 01 04 00 00 01 	testb  $0x1,0x401(%ebx)
  80155b:	74 32                	je     80158f <serve_open+0x7c>
		if ((r = file_create(path, &f)) < 0) {
  80155d:	8d 85 f4 fb ff ff    	lea    -0x40c(%ebp),%eax
  801563:	89 44 24 04          	mov    %eax,0x4(%esp)
  801567:	8d 85 f8 fb ff ff    	lea    -0x408(%ebp),%eax
  80156d:	89 04 24             	mov    %eax,(%esp)
  801570:	e8 86 fa ff ff       	call   800ffb <file_create>
  801575:	85 c0                	test   %eax,%eax
  801577:	79 36                	jns    8015af <serve_open+0x9c>
			if (!(req->req_omode & O_EXCL) && r == -E_FILE_EXISTS)
  801579:	f6 83 01 04 00 00 04 	testb  $0x4,0x401(%ebx)
  801580:	0f 85 ba 00 00 00    	jne    801640 <serve_open+0x12d>
  801586:	83 f8 f3             	cmp    $0xfffffff3,%eax
  801589:	0f 85 b1 00 00 00    	jne    801640 <serve_open+0x12d>
				cprintf("file_create failed: %e", r);
			return r;
		}
	} else {
try_open:
		if ((r = file_open(path, &f)) < 0) {
  80158f:	8d 85 f4 fb ff ff    	lea    -0x40c(%ebp),%eax
  801595:	89 44 24 04          	mov    %eax,0x4(%esp)
  801599:	8d 85 f8 fb ff ff    	lea    -0x408(%ebp),%eax
  80159f:	89 04 24             	mov    %eax,(%esp)
  8015a2:	e8 b8 f8 ff ff       	call   800e5f <file_open>
  8015a7:	85 c0                	test   %eax,%eax
  8015a9:	0f 88 91 00 00 00    	js     801640 <serve_open+0x12d>
			return r;
		}
	}

	// Truncate
	if (req->req_omode & O_TRUNC) {
  8015af:	f6 83 01 04 00 00 02 	testb  $0x2,0x401(%ebx)
  8015b6:	74 1a                	je     8015d2 <serve_open+0xbf>
		if ((r = file_set_size(f, 0)) < 0) {
  8015b8:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  8015bf:	00 
  8015c0:	8b 85 f4 fb ff ff    	mov    -0x40c(%ebp),%eax
  8015c6:	89 04 24             	mov    %eax,(%esp)
  8015c9:	e8 b5 f4 ff ff       	call   800a83 <file_set_size>
  8015ce:	85 c0                	test   %eax,%eax
  8015d0:	78 6e                	js     801640 <serve_open+0x12d>
			return r;
		}
	}

	// Save the file pointer
	o->o_file = f;
  8015d2:	8b 95 f4 fb ff ff    	mov    -0x40c(%ebp),%edx
  8015d8:	8b 85 f0 fb ff ff    	mov    -0x410(%ebp),%eax
  8015de:	89 50 04             	mov    %edx,0x4(%eax)

	// Fill out the Fd structure
	o->o_fd->fd_file.id = o->o_fileid;
  8015e1:	8b 85 f0 fb ff ff    	mov    -0x410(%ebp),%eax
  8015e7:	8b 50 0c             	mov    0xc(%eax),%edx
  8015ea:	8b 00                	mov    (%eax),%eax
  8015ec:	89 42 0c             	mov    %eax,0xc(%edx)
	o->o_fd->fd_omode = req->req_omode & O_ACCMODE;
  8015ef:	8b 85 f0 fb ff ff    	mov    -0x410(%ebp),%eax
  8015f5:	8b 40 0c             	mov    0xc(%eax),%eax
  8015f8:	8b 93 00 04 00 00    	mov    0x400(%ebx),%edx
  8015fe:	83 e2 03             	and    $0x3,%edx
  801601:	89 50 08             	mov    %edx,0x8(%eax)
	o->o_fd->fd_dev_id = devfile.dev_id;
  801604:	8b 85 f0 fb ff ff    	mov    -0x410(%ebp),%eax
  80160a:	8b 40 0c             	mov    0xc(%eax),%eax
  80160d:	8b 15 68 c0 80 00    	mov    0x80c068,%edx
  801613:	89 10                	mov    %edx,(%eax)
	o->o_mode = req->req_omode;
  801615:	8b 93 00 04 00 00    	mov    0x400(%ebx),%edx
  80161b:	8b 85 f0 fb ff ff    	mov    -0x410(%ebp),%eax
  801621:	89 50 08             	mov    %edx,0x8(%eax)

	if (debug)
		cprintf("sending success, page %08x\n", (uintptr_t) o->o_fd);

	// Share the FD page with the caller
	*pg_store = o->o_fd;
  801624:	8b 85 f0 fb ff ff    	mov    -0x410(%ebp),%eax
  80162a:	8b 50 0c             	mov    0xc(%eax),%edx
  80162d:	8b 45 10             	mov    0x10(%ebp),%eax
  801630:	89 10                	mov    %edx,(%eax)
	// LAB 7: Added PTE_SHARE so that all file descriptor pages get mapped with PTE_SHARE
	*perm_store = PTE_P|PTE_U|PTE_W|PTE_SHARE;
  801632:	8b 45 14             	mov    0x14(%ebp),%eax
  801635:	c7 00 07 04 00 00    	movl   $0x407,(%eax)
  80163b:	b8 00 00 00 00       	mov    $0x0,%eax
	return 0;
}
  801640:	81 c4 24 04 00 00    	add    $0x424,%esp
  801646:	5b                   	pop    %ebx
  801647:	5d                   	pop    %ebp
  801648:	c3                   	ret    

00801649 <serve>:
};
#define NHANDLERS (sizeof(handlers)/sizeof(handlers[0]))

void
serve(void)
{
  801649:	55                   	push   %ebp
  80164a:	89 e5                	mov    %esp,%ebp
  80164c:	57                   	push   %edi
  80164d:	56                   	push   %esi
  80164e:	53                   	push   %ebx
  80164f:	83 ec 2c             	sub    $0x2c,%esp
	int perm, r;
	void *pg;

	while (1) {
		perm = 0;
		req = ipc_recv((int32_t *) &whom, fsreq, &perm);
  801652:	8d 5d e0             	lea    -0x20(%ebp),%ebx
  801655:	8d 75 e4             	lea    -0x1c(%ebp),%esi
		}

		pg = NULL;
		if (req == FSREQ_OPEN) {
			r = serve_open(whom, (struct Fsreq_open*)fsreq, &pg, &perm);
		} else if (req < NHANDLERS && handlers[req]) {
  801658:	bf 40 c0 80 00       	mov    $0x80c040,%edi
	uint32_t req, whom;
	int perm, r;
	void *pg;

	while (1) {
		perm = 0;
  80165d:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
		req = ipc_recv((int32_t *) &whom, fsreq, &perm);
  801664:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801668:	a1 20 c0 80 00       	mov    0x80c020,%eax
  80166d:	89 44 24 04          	mov    %eax,0x4(%esp)
  801671:	89 34 24             	mov    %esi,(%esp)
  801674:	e8 1d 18 00 00       	call   802e96 <ipc_recv>
		if (debug)
			cprintf("fs req %d from %08x [page %08x: %s]\n",
				req, whom, vpt[VPN(fsreq)], fsreq);

		// All requests must contain an argument page
		if (!(perm & PTE_P)) {
  801679:	f6 45 e0 01          	testb  $0x1,-0x20(%ebp)
  80167d:	75 15                	jne    801694 <serve+0x4b>
			cprintf("Invalid request from %08x: no argument page\n",
  80167f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801682:	89 44 24 04          	mov    %eax,0x4(%esp)
  801686:	c7 04 24 48 47 80 00 	movl   $0x804748,(%esp)
  80168d:	e8 03 07 00 00       	call   801d95 <cprintf>
				whom);
			continue; // just leave it hanging...
  801692:	eb c9                	jmp    80165d <serve+0x14>
		}

		pg = NULL;
  801694:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
		if (req == FSREQ_OPEN) {
  80169b:	83 f8 01             	cmp    $0x1,%eax
  80169e:	75 21                	jne    8016c1 <serve+0x78>
			r = serve_open(whom, (struct Fsreq_open*)fsreq, &pg, &perm);
  8016a0:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  8016a4:	8d 45 dc             	lea    -0x24(%ebp),%eax
  8016a7:	89 44 24 08          	mov    %eax,0x8(%esp)
  8016ab:	a1 20 c0 80 00       	mov    0x80c020,%eax
  8016b0:	89 44 24 04          	mov    %eax,0x4(%esp)
  8016b4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8016b7:	89 04 24             	mov    %eax,(%esp)
  8016ba:	e8 54 fe ff ff       	call   801513 <serve_open>
  8016bf:	eb 40                	jmp    801701 <serve+0xb8>
		} else if (req < NHANDLERS && handlers[req]) {
  8016c1:	83 f8 08             	cmp    $0x8,%eax
  8016c4:	77 1f                	ja     8016e5 <serve+0x9c>
  8016c6:	8b 14 87             	mov    (%edi,%eax,4),%edx
  8016c9:	85 d2                	test   %edx,%edx
  8016cb:	90                   	nop
  8016cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  8016d0:	74 13                	je     8016e5 <serve+0x9c>
			r = handlers[req](whom, fsreq);
  8016d2:	a1 20 c0 80 00       	mov    0x80c020,%eax
  8016d7:	89 44 24 04          	mov    %eax,0x4(%esp)
  8016db:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8016de:	89 04 24             	mov    %eax,(%esp)
  8016e1:	ff d2                	call   *%edx
		}

		pg = NULL;
		if (req == FSREQ_OPEN) {
			r = serve_open(whom, (struct Fsreq_open*)fsreq, &pg, &perm);
		} else if (req < NHANDLERS && handlers[req]) {
  8016e3:	eb 1c                	jmp    801701 <serve+0xb8>
			r = handlers[req](whom, fsreq);
		} else {
			cprintf("Invalid request code %d from %08x\n", whom, req);
  8016e5:	89 44 24 08          	mov    %eax,0x8(%esp)
  8016e9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8016ec:	89 44 24 04          	mov    %eax,0x4(%esp)
  8016f0:	c7 04 24 78 47 80 00 	movl   $0x804778,(%esp)
  8016f7:	e8 99 06 00 00       	call   801d95 <cprintf>
  8016fc:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
			r = -E_INVAL;
		}
		ipc_send(whom, r, pg, perm);
  801701:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801704:	89 54 24 0c          	mov    %edx,0xc(%esp)
  801708:	8b 55 dc             	mov    -0x24(%ebp),%edx
  80170b:	89 54 24 08          	mov    %edx,0x8(%esp)
  80170f:	89 44 24 04          	mov    %eax,0x4(%esp)
  801713:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801716:	89 04 24             	mov    %eax,(%esp)
  801719:	e8 12 17 00 00       	call   802e30 <ipc_send>
		sys_page_unmap(0, fsreq);
  80171e:	a1 20 c0 80 00       	mov    0x80c020,%eax
  801723:	89 44 24 04          	mov    %eax,0x4(%esp)
  801727:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80172e:	e8 5c 14 00 00       	call   802b8f <sys_page_unmap>
  801733:	e9 25 ff ff ff       	jmp    80165d <serve+0x14>

00801738 <umain>:
	}
}

void
umain(void)
{
  801738:	55                   	push   %ebp
  801739:	89 e5                	mov    %esp,%ebp
  80173b:	83 ec 18             	sub    $0x18,%esp
	static_assert(sizeof(struct File) == 256);
	binaryname = "fs";
  80173e:	c7 05 64 c0 80 00 9b 	movl   $0x80479b,0x80c064
  801745:	47 80 00 
	cprintf("FS is running\n");
  801748:	c7 04 24 9e 47 80 00 	movl   $0x80479e,(%esp)
  80174f:	e8 41 06 00 00       	call   801d95 <cprintf>
}

static __inline void
outw(int port, uint16_t data)
{
	__asm __volatile("outw %0,%w1" : : "a" (data), "d" (port));
  801754:	ba 00 8a 00 00       	mov    $0x8a00,%edx
  801759:	b8 00 8a ff ff       	mov    $0xffff8a00,%eax
  80175e:	66 ef                	out    %ax,(%dx)

	// Check that we are able to do I/O
	outw(0x8A00, 0x8A00);
	cprintf("FS can do I/O\n");
  801760:	c7 04 24 ad 47 80 00 	movl   $0x8047ad,(%esp)
  801767:	e8 29 06 00 00       	call   801d95 <cprintf>

	serve_init();
  80176c:	e8 5f fa ff ff       	call   8011d0 <serve_init>
	fs_init();
  801771:	e8 ef f9 ff ff       	call   801165 <fs_init>
	fs_test();
  801776:	e8 0d 00 00 00       	call   801788 <fs_test>

	serve();
  80177b:	90                   	nop
  80177c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  801780:	e8 c4 fe ff ff       	call   801649 <serve>
}
  801785:	c9                   	leave  
  801786:	c3                   	ret    
	...

00801788 <fs_test>:

static char *msg = "This is the NEW message of the day!\n\n";

void
fs_test(void)
{
  801788:	55                   	push   %ebp
  801789:	89 e5                	mov    %esp,%ebp
  80178b:	53                   	push   %ebx
  80178c:	83 ec 24             	sub    $0x24,%esp
	int r;
	char *blk;
	uint32_t *bits;

	// back up bitmap
	if ((r = sys_page_alloc(0, (void*) PGSIZE, PTE_P|PTE_U|PTE_W)) < 0)
  80178f:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  801796:	00 
  801797:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
  80179e:	00 
  80179f:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8017a6:	e8 a0 14 00 00       	call   802c4b <sys_page_alloc>
  8017ab:	85 c0                	test   %eax,%eax
  8017ad:	79 20                	jns    8017cf <fs_test+0x47>
		panic("sys_page_alloc: %e", r);
  8017af:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8017b3:	c7 44 24 08 bc 47 80 	movl   $0x8047bc,0x8(%esp)
  8017ba:	00 
  8017bb:	c7 44 24 04 13 00 00 	movl   $0x13,0x4(%esp)
  8017c2:	00 
  8017c3:	c7 04 24 cf 47 80 00 	movl   $0x8047cf,(%esp)
  8017ca:	e8 01 05 00 00       	call   801cd0 <_panic>
	bits = (uint32_t*) PGSIZE;
	memmove(bits, bitmap, PGSIZE);
  8017cf:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
  8017d6:	00 
  8017d7:	a1 d8 c0 80 00       	mov    0x80c0d8,%eax
  8017dc:	89 44 24 04          	mov    %eax,0x4(%esp)
  8017e0:	c7 04 24 00 10 00 00 	movl   $0x1000,(%esp)
  8017e7:	e8 29 0e 00 00       	call   802615 <memmove>
	// allocate block
	if ((r = alloc_block()) < 0)
  8017ec:	e8 51 ef ff ff       	call   800742 <alloc_block>
  8017f1:	85 c0                	test   %eax,%eax
  8017f3:	79 20                	jns    801815 <fs_test+0x8d>
		panic("alloc_block: %e", r);
  8017f5:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8017f9:	c7 44 24 08 d9 47 80 	movl   $0x8047d9,0x8(%esp)
  801800:	00 
  801801:	c7 44 24 04 18 00 00 	movl   $0x18,0x4(%esp)
  801808:	00 
  801809:	c7 04 24 cf 47 80 00 	movl   $0x8047cf,(%esp)
  801810:	e8 bb 04 00 00       	call   801cd0 <_panic>
	// Added by Sandeep
	// cprintf("\n The block allocated was: %d \n", r);
	// check that block was free
	assert(bits[r/32] & (1 << (r%32)));
  801815:	89 c3                	mov    %eax,%ebx
  801817:	c1 fb 1f             	sar    $0x1f,%ebx
  80181a:	c1 eb 1b             	shr    $0x1b,%ebx
  80181d:	8d 04 03             	lea    (%ebx,%eax,1),%eax
  801820:	89 c2                	mov    %eax,%edx
  801822:	c1 fa 05             	sar    $0x5,%edx
  801825:	c1 e2 02             	shl    $0x2,%edx
  801828:	89 c1                	mov    %eax,%ecx
  80182a:	83 e1 1f             	and    $0x1f,%ecx
  80182d:	29 d9                	sub    %ebx,%ecx
  80182f:	b8 01 00 00 00       	mov    $0x1,%eax
  801834:	d3 e0                	shl    %cl,%eax
  801836:	85 82 00 10 00 00    	test   %eax,0x1000(%edx)
  80183c:	75 24                	jne    801862 <fs_test+0xda>
  80183e:	c7 44 24 0c e9 47 80 	movl   $0x8047e9,0xc(%esp)
  801845:	00 
  801846:	c7 44 24 08 cd 44 80 	movl   $0x8044cd,0x8(%esp)
  80184d:	00 
  80184e:	c7 44 24 04 1c 00 00 	movl   $0x1c,0x4(%esp)
  801855:	00 
  801856:	c7 04 24 cf 47 80 00 	movl   $0x8047cf,(%esp)
  80185d:	e8 6e 04 00 00       	call   801cd0 <_panic>
	// and is not free any more
	assert(!(bitmap[r/32] & (1 << (r%32))));
  801862:	8b 0d d8 c0 80 00    	mov    0x80c0d8,%ecx
  801868:	85 04 11             	test   %eax,(%ecx,%edx,1)
  80186b:	74 24                	je     801891 <fs_test+0x109>
  80186d:	c7 44 24 0c 5c 49 80 	movl   $0x80495c,0xc(%esp)
  801874:	00 
  801875:	c7 44 24 08 cd 44 80 	movl   $0x8044cd,0x8(%esp)
  80187c:	00 
  80187d:	c7 44 24 04 1e 00 00 	movl   $0x1e,0x4(%esp)
  801884:	00 
  801885:	c7 04 24 cf 47 80 00 	movl   $0x8047cf,(%esp)
  80188c:	e8 3f 04 00 00       	call   801cd0 <_panic>
	cprintf("alloc_block is good\n");
  801891:	c7 04 24 04 48 80 00 	movl   $0x804804,(%esp)
  801898:	e8 f8 04 00 00       	call   801d95 <cprintf>

	if ((r = file_open("/not-found", &f)) < 0 && r != -E_NOT_FOUND)
  80189d:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8018a0:	89 44 24 04          	mov    %eax,0x4(%esp)
  8018a4:	c7 04 24 19 48 80 00 	movl   $0x804819,(%esp)
  8018ab:	e8 af f5 ff ff       	call   800e5f <file_open>
  8018b0:	85 c0                	test   %eax,%eax
  8018b2:	79 25                	jns    8018d9 <fs_test+0x151>
  8018b4:	83 f8 f5             	cmp    $0xfffffff5,%eax
  8018b7:	74 40                	je     8018f9 <fs_test+0x171>
		panic("file_open /not-found: %e", r);
  8018b9:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8018bd:	c7 44 24 08 24 48 80 	movl   $0x804824,0x8(%esp)
  8018c4:	00 
  8018c5:	c7 44 24 04 22 00 00 	movl   $0x22,0x4(%esp)
  8018cc:	00 
  8018cd:	c7 04 24 cf 47 80 00 	movl   $0x8047cf,(%esp)
  8018d4:	e8 f7 03 00 00       	call   801cd0 <_panic>
	else if (r == 0)
  8018d9:	85 c0                	test   %eax,%eax
  8018db:	75 1c                	jne    8018f9 <fs_test+0x171>
		panic("file_open /not-found succeeded!");
  8018dd:	c7 44 24 08 7c 49 80 	movl   $0x80497c,0x8(%esp)
  8018e4:	00 
  8018e5:	c7 44 24 04 24 00 00 	movl   $0x24,0x4(%esp)
  8018ec:	00 
  8018ed:	c7 04 24 cf 47 80 00 	movl   $0x8047cf,(%esp)
  8018f4:	e8 d7 03 00 00       	call   801cd0 <_panic>
	if ((r = file_open("/newmotd", &f)) < 0)
  8018f9:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8018fc:	89 44 24 04          	mov    %eax,0x4(%esp)
  801900:	c7 04 24 3d 48 80 00 	movl   $0x80483d,(%esp)
  801907:	e8 53 f5 ff ff       	call   800e5f <file_open>
  80190c:	85 c0                	test   %eax,%eax
  80190e:	79 20                	jns    801930 <fs_test+0x1a8>
		panic("file_open /newmotd: %e", r);
  801910:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801914:	c7 44 24 08 46 48 80 	movl   $0x804846,0x8(%esp)
  80191b:	00 
  80191c:	c7 44 24 04 26 00 00 	movl   $0x26,0x4(%esp)
  801923:	00 
  801924:	c7 04 24 cf 47 80 00 	movl   $0x8047cf,(%esp)
  80192b:	e8 a0 03 00 00       	call   801cd0 <_panic>
	cprintf("file_open is good\n");
  801930:	c7 04 24 5d 48 80 00 	movl   $0x80485d,(%esp)
  801937:	e8 59 04 00 00       	call   801d95 <cprintf>

	if ((r = file_get_block(f, 0, &blk)) < 0)
  80193c:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80193f:	89 44 24 08          	mov    %eax,0x8(%esp)
  801943:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  80194a:	00 
  80194b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80194e:	89 04 24             	mov    %eax,(%esp)
  801951:	e8 10 f2 ff ff       	call   800b66 <file_get_block>
  801956:	85 c0                	test   %eax,%eax
  801958:	79 20                	jns    80197a <fs_test+0x1f2>
		panic("file_get_block: %e", r);
  80195a:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80195e:	c7 44 24 08 70 48 80 	movl   $0x804870,0x8(%esp)
  801965:	00 
  801966:	c7 44 24 04 2a 00 00 	movl   $0x2a,0x4(%esp)
  80196d:	00 
  80196e:	c7 04 24 cf 47 80 00 	movl   $0x8047cf,(%esp)
  801975:	e8 56 03 00 00       	call   801cd0 <_panic>
	if (strcmp(blk, msg) != 0)
  80197a:	8b 1d e8 49 80 00    	mov    0x8049e8,%ebx
  801980:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801984:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801987:	89 04 24             	mov    %eax,(%esp)
  80198a:	e8 5a 0b 00 00       	call   8024e9 <strcmp>
  80198f:	85 c0                	test   %eax,%eax
  801991:	74 1c                	je     8019af <fs_test+0x227>
		panic("file_get_block returned wrong data");
  801993:	c7 44 24 08 9c 49 80 	movl   $0x80499c,0x8(%esp)
  80199a:	00 
  80199b:	c7 44 24 04 2c 00 00 	movl   $0x2c,0x4(%esp)
  8019a2:	00 
  8019a3:	c7 04 24 cf 47 80 00 	movl   $0x8047cf,(%esp)
  8019aa:	e8 21 03 00 00       	call   801cd0 <_panic>
	cprintf("file_get_block is good\n");
  8019af:	c7 04 24 83 48 80 00 	movl   $0x804883,(%esp)
  8019b6:	e8 da 03 00 00       	call   801d95 <cprintf>

	*(volatile char*)blk = *(volatile char*)blk;
  8019bb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8019be:	0f b6 10             	movzbl (%eax),%edx
  8019c1:	88 10                	mov    %dl,(%eax)
	assert((vpt[VPN(blk)] & PTE_D));
  8019c3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8019c6:	c1 e8 0c             	shr    $0xc,%eax
  8019c9:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8019d0:	a8 40                	test   $0x40,%al
  8019d2:	75 24                	jne    8019f8 <fs_test+0x270>
  8019d4:	c7 44 24 0c 9c 48 80 	movl   $0x80489c,0xc(%esp)
  8019db:	00 
  8019dc:	c7 44 24 08 cd 44 80 	movl   $0x8044cd,0x8(%esp)
  8019e3:	00 
  8019e4:	c7 44 24 04 30 00 00 	movl   $0x30,0x4(%esp)
  8019eb:	00 
  8019ec:	c7 04 24 cf 47 80 00 	movl   $0x8047cf,(%esp)
  8019f3:	e8 d8 02 00 00       	call   801cd0 <_panic>
	file_flush(f);
  8019f8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8019fb:	89 04 24             	mov    %eax,(%esp)
  8019fe:	e8 c0 f0 ff ff       	call   800ac3 <file_flush>
	assert(!(vpt[VPN(blk)] & PTE_D));
  801a03:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801a06:	c1 e8 0c             	shr    $0xc,%eax
  801a09:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801a10:	a8 40                	test   $0x40,%al
  801a12:	74 24                	je     801a38 <fs_test+0x2b0>
  801a14:	c7 44 24 0c 9b 48 80 	movl   $0x80489b,0xc(%esp)
  801a1b:	00 
  801a1c:	c7 44 24 08 cd 44 80 	movl   $0x8044cd,0x8(%esp)
  801a23:	00 
  801a24:	c7 44 24 04 32 00 00 	movl   $0x32,0x4(%esp)
  801a2b:	00 
  801a2c:	c7 04 24 cf 47 80 00 	movl   $0x8047cf,(%esp)
  801a33:	e8 98 02 00 00       	call   801cd0 <_panic>
	cprintf("file_flush is good\n");
  801a38:	c7 04 24 b4 48 80 00 	movl   $0x8048b4,(%esp)
  801a3f:	e8 51 03 00 00       	call   801d95 <cprintf>

	if ((r = file_set_size(f, 0)) < 0)
  801a44:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  801a4b:	00 
  801a4c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a4f:	89 04 24             	mov    %eax,(%esp)
  801a52:	e8 2c f0 ff ff       	call   800a83 <file_set_size>
  801a57:	85 c0                	test   %eax,%eax
  801a59:	79 20                	jns    801a7b <fs_test+0x2f3>
		panic("file_set_size: %e", r);
  801a5b:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801a5f:	c7 44 24 08 c8 48 80 	movl   $0x8048c8,0x8(%esp)
  801a66:	00 
  801a67:	c7 44 24 04 36 00 00 	movl   $0x36,0x4(%esp)
  801a6e:	00 
  801a6f:	c7 04 24 cf 47 80 00 	movl   $0x8047cf,(%esp)
  801a76:	e8 55 02 00 00       	call   801cd0 <_panic>
	assert(f->f_direct[0] == 0);
  801a7b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a7e:	83 b8 88 00 00 00 00 	cmpl   $0x0,0x88(%eax)
  801a85:	74 24                	je     801aab <fs_test+0x323>
  801a87:	c7 44 24 0c da 48 80 	movl   $0x8048da,0xc(%esp)
  801a8e:	00 
  801a8f:	c7 44 24 08 cd 44 80 	movl   $0x8044cd,0x8(%esp)
  801a96:	00 
  801a97:	c7 44 24 04 37 00 00 	movl   $0x37,0x4(%esp)
  801a9e:	00 
  801a9f:	c7 04 24 cf 47 80 00 	movl   $0x8047cf,(%esp)
  801aa6:	e8 25 02 00 00       	call   801cd0 <_panic>
	assert(!(vpt[VPN(f)] & PTE_D));
  801aab:	c1 e8 0c             	shr    $0xc,%eax
  801aae:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801ab5:	a8 40                	test   $0x40,%al
  801ab7:	74 24                	je     801add <fs_test+0x355>
  801ab9:	c7 44 24 0c ee 48 80 	movl   $0x8048ee,0xc(%esp)
  801ac0:	00 
  801ac1:	c7 44 24 08 cd 44 80 	movl   $0x8044cd,0x8(%esp)
  801ac8:	00 
  801ac9:	c7 44 24 04 38 00 00 	movl   $0x38,0x4(%esp)
  801ad0:	00 
  801ad1:	c7 04 24 cf 47 80 00 	movl   $0x8047cf,(%esp)
  801ad8:	e8 f3 01 00 00       	call   801cd0 <_panic>
	cprintf("file_truncate is good\n");
  801add:	c7 04 24 05 49 80 00 	movl   $0x804905,(%esp)
  801ae4:	e8 ac 02 00 00       	call   801d95 <cprintf>

	if ((r = file_set_size(f, strlen(msg))) < 0)
  801ae9:	89 1c 24             	mov    %ebx,(%esp)
  801aec:	e8 1f 09 00 00       	call   802410 <strlen>
  801af1:	89 44 24 04          	mov    %eax,0x4(%esp)
  801af5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801af8:	89 04 24             	mov    %eax,(%esp)
  801afb:	e8 83 ef ff ff       	call   800a83 <file_set_size>
  801b00:	85 c0                	test   %eax,%eax
  801b02:	79 20                	jns    801b24 <fs_test+0x39c>
		panic("file_set_size 2: %e", r);
  801b04:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801b08:	c7 44 24 08 1c 49 80 	movl   $0x80491c,0x8(%esp)
  801b0f:	00 
  801b10:	c7 44 24 04 3c 00 00 	movl   $0x3c,0x4(%esp)
  801b17:	00 
  801b18:	c7 04 24 cf 47 80 00 	movl   $0x8047cf,(%esp)
  801b1f:	e8 ac 01 00 00       	call   801cd0 <_panic>
	assert(!(vpt[VPN(f)] & PTE_D));
  801b24:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801b27:	89 c2                	mov    %eax,%edx
  801b29:	c1 ea 0c             	shr    $0xc,%edx
  801b2c:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801b33:	f6 c2 40             	test   $0x40,%dl
  801b36:	74 24                	je     801b5c <fs_test+0x3d4>
  801b38:	c7 44 24 0c ee 48 80 	movl   $0x8048ee,0xc(%esp)
  801b3f:	00 
  801b40:	c7 44 24 08 cd 44 80 	movl   $0x8044cd,0x8(%esp)
  801b47:	00 
  801b48:	c7 44 24 04 3d 00 00 	movl   $0x3d,0x4(%esp)
  801b4f:	00 
  801b50:	c7 04 24 cf 47 80 00 	movl   $0x8047cf,(%esp)
  801b57:	e8 74 01 00 00       	call   801cd0 <_panic>
	if ((r = file_get_block(f, 0, &blk)) < 0)
  801b5c:	8d 55 f0             	lea    -0x10(%ebp),%edx
  801b5f:	89 54 24 08          	mov    %edx,0x8(%esp)
  801b63:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  801b6a:	00 
  801b6b:	89 04 24             	mov    %eax,(%esp)
  801b6e:	e8 f3 ef ff ff       	call   800b66 <file_get_block>
  801b73:	85 c0                	test   %eax,%eax
  801b75:	79 20                	jns    801b97 <fs_test+0x40f>
		panic("file_get_block 2: %e", r);
  801b77:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801b7b:	c7 44 24 08 30 49 80 	movl   $0x804930,0x8(%esp)
  801b82:	00 
  801b83:	c7 44 24 04 3f 00 00 	movl   $0x3f,0x4(%esp)
  801b8a:	00 
  801b8b:	c7 04 24 cf 47 80 00 	movl   $0x8047cf,(%esp)
  801b92:	e8 39 01 00 00       	call   801cd0 <_panic>
	strcpy(blk, msg);
  801b97:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801b9b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801b9e:	89 04 24             	mov    %eax,(%esp)
  801ba1:	e8 b4 08 00 00       	call   80245a <strcpy>
	assert((vpt[VPN(blk)] & PTE_D));
  801ba6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801ba9:	c1 e8 0c             	shr    $0xc,%eax
  801bac:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801bb3:	a8 40                	test   $0x40,%al
  801bb5:	75 24                	jne    801bdb <fs_test+0x453>
  801bb7:	c7 44 24 0c 9c 48 80 	movl   $0x80489c,0xc(%esp)
  801bbe:	00 
  801bbf:	c7 44 24 08 cd 44 80 	movl   $0x8044cd,0x8(%esp)
  801bc6:	00 
  801bc7:	c7 44 24 04 41 00 00 	movl   $0x41,0x4(%esp)
  801bce:	00 
  801bcf:	c7 04 24 cf 47 80 00 	movl   $0x8047cf,(%esp)
  801bd6:	e8 f5 00 00 00       	call   801cd0 <_panic>
	file_flush(f);
  801bdb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801bde:	89 04 24             	mov    %eax,(%esp)
  801be1:	e8 dd ee ff ff       	call   800ac3 <file_flush>
	assert(!(vpt[VPN(blk)] & PTE_D));
  801be6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801be9:	c1 e8 0c             	shr    $0xc,%eax
  801bec:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801bf3:	a8 40                	test   $0x40,%al
  801bf5:	74 24                	je     801c1b <fs_test+0x493>
  801bf7:	c7 44 24 0c 9b 48 80 	movl   $0x80489b,0xc(%esp)
  801bfe:	00 
  801bff:	c7 44 24 08 cd 44 80 	movl   $0x8044cd,0x8(%esp)
  801c06:	00 
  801c07:	c7 44 24 04 43 00 00 	movl   $0x43,0x4(%esp)
  801c0e:	00 
  801c0f:	c7 04 24 cf 47 80 00 	movl   $0x8047cf,(%esp)
  801c16:	e8 b5 00 00 00       	call   801cd0 <_panic>
	assert(!(vpt[VPN(f)] & PTE_D));
  801c1b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c1e:	c1 e8 0c             	shr    $0xc,%eax
  801c21:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801c28:	a8 40                	test   $0x40,%al
  801c2a:	74 24                	je     801c50 <fs_test+0x4c8>
  801c2c:	c7 44 24 0c ee 48 80 	movl   $0x8048ee,0xc(%esp)
  801c33:	00 
  801c34:	c7 44 24 08 cd 44 80 	movl   $0x8044cd,0x8(%esp)
  801c3b:	00 
  801c3c:	c7 44 24 04 44 00 00 	movl   $0x44,0x4(%esp)
  801c43:	00 
  801c44:	c7 04 24 cf 47 80 00 	movl   $0x8047cf,(%esp)
  801c4b:	e8 80 00 00 00       	call   801cd0 <_panic>
	cprintf("file rewrite is good\n");
  801c50:	c7 04 24 45 49 80 00 	movl   $0x804945,(%esp)
  801c57:	e8 39 01 00 00       	call   801d95 <cprintf>
}
  801c5c:	83 c4 24             	add    $0x24,%esp
  801c5f:	5b                   	pop    %ebx
  801c60:	5d                   	pop    %ebp
  801c61:	c3                   	ret    
	...

00801c64 <libmain>:
volatile struct Env *env;
char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  801c64:	55                   	push   %ebp
  801c65:	89 e5                	mov    %esp,%ebp
  801c67:	83 ec 18             	sub    $0x18,%esp
  801c6a:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  801c6d:	89 75 fc             	mov    %esi,-0x4(%ebp)
  801c70:	8b 75 08             	mov    0x8(%ebp),%esi
  801c73:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	// set env to point at our env structure in envs[].
	// LAB 3b: Your code here.
	// Code added by Swastika / Sandeep	
	envid_t envid = sys_getenvid();
  801c76:	e8 63 10 00 00       	call   802cde <sys_getenvid>
	env = &envs[ENVX(envid)];
  801c7b:	25 ff 03 00 00       	and    $0x3ff,%eax
  801c80:	6b c0 7c             	imul   $0x7c,%eax,%eax
  801c83:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  801c88:	a3 e0 c0 80 00       	mov    %eax,0x80c0e0

	// save the name of the program so that panic() can use it
	if (argc > 0)
  801c8d:	85 f6                	test   %esi,%esi
  801c8f:	7e 07                	jle    801c98 <libmain+0x34>
		binaryname = argv[0];
  801c91:	8b 03                	mov    (%ebx),%eax
  801c93:	a3 64 c0 80 00       	mov    %eax,0x80c064

	// call user main routine
	umain(argc, argv);
  801c98:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801c9c:	89 34 24             	mov    %esi,(%esp)
  801c9f:	e8 94 fa ff ff       	call   801738 <umain>

	// exit gracefully
	exit();
  801ca4:	e8 0b 00 00 00       	call   801cb4 <exit>
}
  801ca9:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  801cac:	8b 75 fc             	mov    -0x4(%ebp),%esi
  801caf:	89 ec                	mov    %ebp,%esp
  801cb1:	5d                   	pop    %ebp
  801cb2:	c3                   	ret    
	...

00801cb4 <exit>:
#include <inc/lib.h>

void
exit(void)
{
  801cb4:	55                   	push   %ebp
  801cb5:	89 e5                	mov    %esp,%ebp
  801cb7:	83 ec 18             	sub    $0x18,%esp
	close_all();
  801cba:	e8 1c 17 00 00       	call   8033db <close_all>
	sys_env_destroy(0);
  801cbf:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801cc6:	e8 47 10 00 00       	call   802d12 <sys_env_destroy>
}
  801ccb:	c9                   	leave  
  801ccc:	c3                   	ret    
  801ccd:	00 00                	add    %al,(%eax)
	...

00801cd0 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  801cd0:	55                   	push   %ebp
  801cd1:	89 e5                	mov    %esp,%ebp
  801cd3:	53                   	push   %ebx
  801cd4:	83 ec 14             	sub    $0x14,%esp
 * Panic is called on unresolvable fatal errors.
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
  801cd7:	8d 5d 14             	lea    0x14(%ebp),%ebx
	va_list ap;

	va_start(ap, fmt);

	// Print the panic message
	if (argv0)
  801cda:	a1 e4 c0 80 00       	mov    0x80c0e4,%eax
  801cdf:	85 c0                	test   %eax,%eax
  801ce1:	74 10                	je     801cf3 <_panic+0x23>
		cprintf("%s: ", argv0);
  801ce3:	89 44 24 04          	mov    %eax,0x4(%esp)
  801ce7:	c7 04 24 03 4a 80 00 	movl   $0x804a03,(%esp)
  801cee:	e8 a2 00 00 00       	call   801d95 <cprintf>
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  801cf3:	8b 45 0c             	mov    0xc(%ebp),%eax
  801cf6:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801cfa:	8b 45 08             	mov    0x8(%ebp),%eax
  801cfd:	89 44 24 08          	mov    %eax,0x8(%esp)
  801d01:	a1 64 c0 80 00       	mov    0x80c064,%eax
  801d06:	89 44 24 04          	mov    %eax,0x4(%esp)
  801d0a:	c7 04 24 08 4a 80 00 	movl   $0x804a08,(%esp)
  801d11:	e8 7f 00 00 00       	call   801d95 <cprintf>
	vcprintf(fmt, ap);
  801d16:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801d1a:	8b 45 10             	mov    0x10(%ebp),%eax
  801d1d:	89 04 24             	mov    %eax,(%esp)
  801d20:	e8 0f 00 00 00       	call   801d34 <vcprintf>
	cprintf("\n");
  801d25:	c7 04 24 0b 46 80 00 	movl   $0x80460b,(%esp)
  801d2c:	e8 64 00 00 00       	call   801d95 <cprintf>

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  801d31:	cc                   	int3   
  801d32:	eb fd                	jmp    801d31 <_panic+0x61>

00801d34 <vcprintf>:
	b->cnt++;
}

int
vcprintf(const char *fmt, va_list ap)
{
  801d34:	55                   	push   %ebp
  801d35:	89 e5                	mov    %esp,%ebp
  801d37:	81 ec 28 01 00 00    	sub    $0x128,%esp
	struct printbuf b;

	b.idx = 0;
  801d3d:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  801d44:	00 00 00 
	b.cnt = 0;
  801d47:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  801d4e:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  801d51:	8b 45 0c             	mov    0xc(%ebp),%eax
  801d54:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801d58:	8b 45 08             	mov    0x8(%ebp),%eax
  801d5b:	89 44 24 08          	mov    %eax,0x8(%esp)
  801d5f:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  801d65:	89 44 24 04          	mov    %eax,0x4(%esp)
  801d69:	c7 04 24 af 1d 80 00 	movl   $0x801daf,(%esp)
  801d70:	e8 d8 01 00 00       	call   801f4d <vprintfmt>
	sys_cputs(b.buf, b.idx);
  801d75:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
  801d7b:	89 44 24 04          	mov    %eax,0x4(%esp)
  801d7f:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  801d85:	89 04 24             	mov    %eax,(%esp)
  801d88:	e8 c3 0a 00 00       	call   802850 <sys_cputs>

	return b.cnt;
}
  801d8d:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  801d93:	c9                   	leave  
  801d94:	c3                   	ret    

00801d95 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  801d95:	55                   	push   %ebp
  801d96:	89 e5                	mov    %esp,%ebp
  801d98:	83 ec 18             	sub    $0x18,%esp

	return b.cnt;
}

int
cprintf(const char *fmt, ...)
  801d9b:	8d 45 0c             	lea    0xc(%ebp),%eax
{
	va_list ap;
	int cnt;

	va_start(ap, fmt);
	cnt = vcprintf(fmt, ap);
  801d9e:	89 44 24 04          	mov    %eax,0x4(%esp)
  801da2:	8b 45 08             	mov    0x8(%ebp),%eax
  801da5:	89 04 24             	mov    %eax,(%esp)
  801da8:	e8 87 ff ff ff       	call   801d34 <vcprintf>
	va_end(ap);

	return cnt;
}
  801dad:	c9                   	leave  
  801dae:	c3                   	ret    

00801daf <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  801daf:	55                   	push   %ebp
  801db0:	89 e5                	mov    %esp,%ebp
  801db2:	53                   	push   %ebx
  801db3:	83 ec 14             	sub    $0x14,%esp
  801db6:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  801db9:	8b 03                	mov    (%ebx),%eax
  801dbb:	8b 55 08             	mov    0x8(%ebp),%edx
  801dbe:	88 54 03 08          	mov    %dl,0x8(%ebx,%eax,1)
  801dc2:	83 c0 01             	add    $0x1,%eax
  801dc5:	89 03                	mov    %eax,(%ebx)
	if (b->idx == 256-1) {
  801dc7:	3d ff 00 00 00       	cmp    $0xff,%eax
  801dcc:	75 19                	jne    801de7 <putch+0x38>
		sys_cputs(b->buf, b->idx);
  801dce:	c7 44 24 04 ff 00 00 	movl   $0xff,0x4(%esp)
  801dd5:	00 
  801dd6:	8d 43 08             	lea    0x8(%ebx),%eax
  801dd9:	89 04 24             	mov    %eax,(%esp)
  801ddc:	e8 6f 0a 00 00       	call   802850 <sys_cputs>
		b->idx = 0;
  801de1:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
	}
	b->cnt++;
  801de7:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  801deb:	83 c4 14             	add    $0x14,%esp
  801dee:	5b                   	pop    %ebx
  801def:	5d                   	pop    %ebp
  801df0:	c3                   	ret    
	...

00801e00 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  801e00:	55                   	push   %ebp
  801e01:	89 e5                	mov    %esp,%ebp
  801e03:	57                   	push   %edi
  801e04:	56                   	push   %esi
  801e05:	53                   	push   %ebx
  801e06:	83 ec 4c             	sub    $0x4c,%esp
  801e09:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801e0c:	89 d6                	mov    %edx,%esi
  801e0e:	8b 45 08             	mov    0x8(%ebp),%eax
  801e11:	89 45 d8             	mov    %eax,-0x28(%ebp)
  801e14:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e17:	89 55 e0             	mov    %edx,-0x20(%ebp)
  801e1a:	8b 45 10             	mov    0x10(%ebp),%eax
  801e1d:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801e20:	8b 7d 18             	mov    0x18(%ebp),%edi
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  801e23:	89 45 dc             	mov    %eax,-0x24(%ebp)
  801e26:	b9 00 00 00 00       	mov    $0x0,%ecx
  801e2b:	39 d1                	cmp    %edx,%ecx
  801e2d:	72 15                	jb     801e44 <printnum+0x44>
  801e2f:	77 07                	ja     801e38 <printnum+0x38>
  801e31:	8b 55 d8             	mov    -0x28(%ebp),%edx
  801e34:	39 d0                	cmp    %edx,%eax
  801e36:	76 0c                	jbe    801e44 <printnum+0x44>
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  801e38:	83 eb 01             	sub    $0x1,%ebx
  801e3b:	85 db                	test   %ebx,%ebx
  801e3d:	8d 76 00             	lea    0x0(%esi),%esi
  801e40:	7f 61                	jg     801ea3 <printnum+0xa3>
  801e42:	eb 70                	jmp    801eb4 <printnum+0xb4>
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
  801e44:	89 7c 24 10          	mov    %edi,0x10(%esp)
  801e48:	83 eb 01             	sub    $0x1,%ebx
  801e4b:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  801e4f:	89 44 24 08          	mov    %eax,0x8(%esp)
  801e53:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  801e57:	8b 5c 24 0c          	mov    0xc(%esp),%ebx
  801e5b:	89 4d d0             	mov    %ecx,-0x30(%ebp)
  801e5e:	89 5d d4             	mov    %ebx,-0x2c(%ebp)
  801e61:	8b 5d dc             	mov    -0x24(%ebp),%ebx
  801e64:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801e68:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  801e6f:	00 
  801e70:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801e73:	89 04 24             	mov    %eax,(%esp)
  801e76:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801e79:	89 54 24 04          	mov    %edx,0x4(%esp)
  801e7d:	e8 ce 23 00 00       	call   804250 <__udivdi3>
  801e82:	8b 4d d0             	mov    -0x30(%ebp),%ecx
  801e85:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
  801e88:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801e8c:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  801e90:	89 04 24             	mov    %eax,(%esp)
  801e93:	89 54 24 04          	mov    %edx,0x4(%esp)
  801e97:	89 f2                	mov    %esi,%edx
  801e99:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801e9c:	e8 5f ff ff ff       	call   801e00 <printnum>
  801ea1:	eb 11                	jmp    801eb4 <printnum+0xb4>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  801ea3:	89 74 24 04          	mov    %esi,0x4(%esp)
  801ea7:	89 3c 24             	mov    %edi,(%esp)
  801eaa:	ff 55 e4             	call   *-0x1c(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  801ead:	83 eb 01             	sub    $0x1,%ebx
  801eb0:	85 db                	test   %ebx,%ebx
  801eb2:	7f ef                	jg     801ea3 <printnum+0xa3>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  801eb4:	89 74 24 04          	mov    %esi,0x4(%esp)
  801eb8:	8b 74 24 04          	mov    0x4(%esp),%esi
  801ebc:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801ebf:	89 44 24 08          	mov    %eax,0x8(%esp)
  801ec3:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  801eca:	00 
  801ecb:	8b 55 d8             	mov    -0x28(%ebp),%edx
  801ece:	89 14 24             	mov    %edx,(%esp)
  801ed1:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  801ed4:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801ed8:	e8 a3 24 00 00       	call   804380 <__umoddi3>
  801edd:	89 74 24 04          	mov    %esi,0x4(%esp)
  801ee1:	0f be 80 24 4a 80 00 	movsbl 0x804a24(%eax),%eax
  801ee8:	89 04 24             	mov    %eax,(%esp)
  801eeb:	ff 55 e4             	call   *-0x1c(%ebp)
}
  801eee:	83 c4 4c             	add    $0x4c,%esp
  801ef1:	5b                   	pop    %ebx
  801ef2:	5e                   	pop    %esi
  801ef3:	5f                   	pop    %edi
  801ef4:	5d                   	pop    %ebp
  801ef5:	c3                   	ret    

00801ef6 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  801ef6:	55                   	push   %ebp
  801ef7:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  801ef9:	83 fa 01             	cmp    $0x1,%edx
  801efc:	7e 0e                	jle    801f0c <getuint+0x16>
		return va_arg(*ap, unsigned long long);
  801efe:	8b 10                	mov    (%eax),%edx
  801f00:	8d 4a 08             	lea    0x8(%edx),%ecx
  801f03:	89 08                	mov    %ecx,(%eax)
  801f05:	8b 02                	mov    (%edx),%eax
  801f07:	8b 52 04             	mov    0x4(%edx),%edx
  801f0a:	eb 22                	jmp    801f2e <getuint+0x38>
	else if (lflag)
  801f0c:	85 d2                	test   %edx,%edx
  801f0e:	74 10                	je     801f20 <getuint+0x2a>
		return va_arg(*ap, unsigned long);
  801f10:	8b 10                	mov    (%eax),%edx
  801f12:	8d 4a 04             	lea    0x4(%edx),%ecx
  801f15:	89 08                	mov    %ecx,(%eax)
  801f17:	8b 02                	mov    (%edx),%eax
  801f19:	ba 00 00 00 00       	mov    $0x0,%edx
  801f1e:	eb 0e                	jmp    801f2e <getuint+0x38>
	else
		return va_arg(*ap, unsigned int);
  801f20:	8b 10                	mov    (%eax),%edx
  801f22:	8d 4a 04             	lea    0x4(%edx),%ecx
  801f25:	89 08                	mov    %ecx,(%eax)
  801f27:	8b 02                	mov    (%edx),%eax
  801f29:	ba 00 00 00 00       	mov    $0x0,%edx
}
  801f2e:	5d                   	pop    %ebp
  801f2f:	c3                   	ret    

00801f30 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  801f30:	55                   	push   %ebp
  801f31:	89 e5                	mov    %esp,%ebp
  801f33:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  801f36:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  801f3a:	8b 10                	mov    (%eax),%edx
  801f3c:	3b 50 04             	cmp    0x4(%eax),%edx
  801f3f:	73 0a                	jae    801f4b <sprintputch+0x1b>
		*b->buf++ = ch;
  801f41:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801f44:	88 0a                	mov    %cl,(%edx)
  801f46:	83 c2 01             	add    $0x1,%edx
  801f49:	89 10                	mov    %edx,(%eax)
}
  801f4b:	5d                   	pop    %ebp
  801f4c:	c3                   	ret    

00801f4d <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  801f4d:	55                   	push   %ebp
  801f4e:	89 e5                	mov    %esp,%ebp
  801f50:	57                   	push   %edi
  801f51:	56                   	push   %esi
  801f52:	53                   	push   %ebx
  801f53:	83 ec 5c             	sub    $0x5c,%esp
  801f56:	8b 7d 08             	mov    0x8(%ebp),%edi
  801f59:	8b 75 0c             	mov    0xc(%ebp),%esi
  801f5c:	8b 5d 10             	mov    0x10(%ebp),%ebx
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  801f5f:	c7 45 c8 ff ff ff ff 	movl   $0xffffffff,-0x38(%ebp)
  801f66:	eb 11                	jmp    801f79 <vprintfmt+0x2c>
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
  801f68:	85 c0                	test   %eax,%eax
  801f6a:	0f 84 ec 03 00 00    	je     80235c <vprintfmt+0x40f>
				return;
			putch(ch, putdat);
  801f70:	89 74 24 04          	mov    %esi,0x4(%esp)
  801f74:	89 04 24             	mov    %eax,(%esp)
  801f77:	ff d7                	call   *%edi
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  801f79:	0f b6 03             	movzbl (%ebx),%eax
  801f7c:	83 c3 01             	add    $0x1,%ebx
  801f7f:	83 f8 25             	cmp    $0x25,%eax
  801f82:	75 e4                	jne    801f68 <vprintfmt+0x1b>
  801f84:	c6 45 d4 20          	movb   $0x20,-0x2c(%ebp)
  801f88:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
  801f8f:	c7 45 d0 ff ff ff ff 	movl   $0xffffffff,-0x30(%ebp)
  801f96:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
  801f9d:	b9 00 00 00 00       	mov    $0x0,%ecx
  801fa2:	eb 06                	jmp    801faa <vprintfmt+0x5d>
  801fa4:	c6 45 d4 2d          	movb   $0x2d,-0x2c(%ebp)
  801fa8:	89 c3                	mov    %eax,%ebx
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  801faa:	0f b6 13             	movzbl (%ebx),%edx
  801fad:	0f b6 c2             	movzbl %dl,%eax
  801fb0:	89 45 e0             	mov    %eax,-0x20(%ebp)
  801fb3:	8d 43 01             	lea    0x1(%ebx),%eax
  801fb6:	83 ea 23             	sub    $0x23,%edx
  801fb9:	80 fa 55             	cmp    $0x55,%dl
  801fbc:	0f 87 7d 03 00 00    	ja     80233f <vprintfmt+0x3f2>
  801fc2:	0f b6 d2             	movzbl %dl,%edx
  801fc5:	ff 24 95 60 4b 80 00 	jmp    *0x804b60(,%edx,4)
  801fcc:	c6 45 d4 30          	movb   $0x30,-0x2c(%ebp)
  801fd0:	eb d6                	jmp    801fa8 <vprintfmt+0x5b>
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
				precision = precision * 10 + ch - '0';
  801fd2:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801fd5:	83 ea 30             	sub    $0x30,%edx
  801fd8:	89 55 d0             	mov    %edx,-0x30(%ebp)
				ch = *fmt;
  801fdb:	0f be 10             	movsbl (%eax),%edx
				if (ch < '0' || ch > '9')
  801fde:	8d 5a d0             	lea    -0x30(%edx),%ebx
  801fe1:	83 fb 09             	cmp    $0x9,%ebx
  801fe4:	77 4c                	ja     802032 <vprintfmt+0xe5>
  801fe6:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  801fe9:	8b 4d d0             	mov    -0x30(%ebp),%ecx
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  801fec:	83 c0 01             	add    $0x1,%eax
				precision = precision * 10 + ch - '0';
  801fef:	8d 0c 89             	lea    (%ecx,%ecx,4),%ecx
  801ff2:	8d 4c 4a d0          	lea    -0x30(%edx,%ecx,2),%ecx
				ch = *fmt;
  801ff6:	0f be 10             	movsbl (%eax),%edx
				if (ch < '0' || ch > '9')
  801ff9:	8d 5a d0             	lea    -0x30(%edx),%ebx
  801ffc:	83 fb 09             	cmp    $0x9,%ebx
  801fff:	76 eb                	jbe    801fec <vprintfmt+0x9f>
  802001:	89 4d d0             	mov    %ecx,-0x30(%ebp)
  802004:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  802007:	eb 29                	jmp    802032 <vprintfmt+0xe5>
					break;
			}
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  802009:	8b 55 14             	mov    0x14(%ebp),%edx
  80200c:	8d 5a 04             	lea    0x4(%edx),%ebx
  80200f:	89 5d 14             	mov    %ebx,0x14(%ebp)
  802012:	8b 12                	mov    (%edx),%edx
  802014:	89 55 d0             	mov    %edx,-0x30(%ebp)
			goto process_precision;
  802017:	eb 19                	jmp    802032 <vprintfmt+0xe5>

		case '.':
			if (width < 0)
  802019:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80201c:	c1 fa 1f             	sar    $0x1f,%edx
  80201f:	f7 d2                	not    %edx
  802021:	21 55 e4             	and    %edx,-0x1c(%ebp)
  802024:	eb 82                	jmp    801fa8 <vprintfmt+0x5b>
  802026:	c7 45 d8 01 00 00 00 	movl   $0x1,-0x28(%ebp)
				width = 0;
			goto reswitch;

		case '#':
			altflag = 1;
			goto reswitch;
  80202d:	e9 76 ff ff ff       	jmp    801fa8 <vprintfmt+0x5b>

		process_precision:
			if (width < 0)
  802032:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  802036:	0f 89 6c ff ff ff    	jns    801fa8 <vprintfmt+0x5b>
  80203c:	8b 55 d0             	mov    -0x30(%ebp),%edx
  80203f:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  802042:	8b 55 c8             	mov    -0x38(%ebp),%edx
  802045:	89 55 d0             	mov    %edx,-0x30(%ebp)
  802048:	e9 5b ff ff ff       	jmp    801fa8 <vprintfmt+0x5b>
				width = precision, precision = -1;
			goto reswitch;

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  80204d:	83 c1 01             	add    $0x1,%ecx
			goto reswitch;
  802050:	e9 53 ff ff ff       	jmp    801fa8 <vprintfmt+0x5b>
  802055:	89 45 cc             	mov    %eax,-0x34(%ebp)

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  802058:	8b 45 14             	mov    0x14(%ebp),%eax
  80205b:	8d 50 04             	lea    0x4(%eax),%edx
  80205e:	89 55 14             	mov    %edx,0x14(%ebp)
  802061:	89 74 24 04          	mov    %esi,0x4(%esp)
  802065:	8b 00                	mov    (%eax),%eax
  802067:	89 04 24             	mov    %eax,(%esp)
  80206a:	ff d7                	call   *%edi
  80206c:	8b 5d cc             	mov    -0x34(%ebp),%ebx
			break;
  80206f:	e9 05 ff ff ff       	jmp    801f79 <vprintfmt+0x2c>
  802074:	89 45 cc             	mov    %eax,-0x34(%ebp)

		// error message
		case 'e':
			err = va_arg(ap, int);
  802077:	8b 45 14             	mov    0x14(%ebp),%eax
  80207a:	8d 50 04             	lea    0x4(%eax),%edx
  80207d:	89 55 14             	mov    %edx,0x14(%ebp)
  802080:	8b 00                	mov    (%eax),%eax
  802082:	89 c2                	mov    %eax,%edx
  802084:	c1 fa 1f             	sar    $0x1f,%edx
  802087:	31 d0                	xor    %edx,%eax
  802089:	29 d0                	sub    %edx,%eax
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  80208b:	83 f8 0f             	cmp    $0xf,%eax
  80208e:	7f 0b                	jg     80209b <vprintfmt+0x14e>
  802090:	8b 14 85 c0 4c 80 00 	mov    0x804cc0(,%eax,4),%edx
  802097:	85 d2                	test   %edx,%edx
  802099:	75 20                	jne    8020bb <vprintfmt+0x16e>
				printfmt(putch, putdat, "error %d", err);
  80209b:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80209f:	c7 44 24 08 35 4a 80 	movl   $0x804a35,0x8(%esp)
  8020a6:	00 
  8020a7:	89 74 24 04          	mov    %esi,0x4(%esp)
  8020ab:	89 3c 24             	mov    %edi,(%esp)
  8020ae:	e8 31 03 00 00       	call   8023e4 <printfmt>
  8020b3:	8b 5d cc             	mov    -0x34(%ebp),%ebx
		// error message
		case 'e':
			err = va_arg(ap, int);
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  8020b6:	e9 be fe ff ff       	jmp    801f79 <vprintfmt+0x2c>
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  8020bb:	89 54 24 0c          	mov    %edx,0xc(%esp)
  8020bf:	c7 44 24 08 df 44 80 	movl   $0x8044df,0x8(%esp)
  8020c6:	00 
  8020c7:	89 74 24 04          	mov    %esi,0x4(%esp)
  8020cb:	89 3c 24             	mov    %edi,(%esp)
  8020ce:	e8 11 03 00 00       	call   8023e4 <printfmt>
  8020d3:	8b 5d cc             	mov    -0x34(%ebp),%ebx
  8020d6:	e9 9e fe ff ff       	jmp    801f79 <vprintfmt+0x2c>
  8020db:	89 45 cc             	mov    %eax,-0x34(%ebp)
  8020de:	89 c3                	mov    %eax,%ebx
  8020e0:	8b 4d d0             	mov    -0x30(%ebp),%ecx
  8020e3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8020e6:	89 45 c4             	mov    %eax,-0x3c(%ebp)
			break;

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  8020e9:	8b 45 14             	mov    0x14(%ebp),%eax
  8020ec:	8d 50 04             	lea    0x4(%eax),%edx
  8020ef:	89 55 14             	mov    %edx,0x14(%ebp)
  8020f2:	8b 00                	mov    (%eax),%eax
  8020f4:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8020f7:	85 c0                	test   %eax,%eax
  8020f9:	75 07                	jne    802102 <vprintfmt+0x1b5>
  8020fb:	c7 45 e0 3e 4a 80 00 	movl   $0x804a3e,-0x20(%ebp)
				p = "(null)";
			if (width > 0 && padc != '-')
  802102:	83 7d c4 00          	cmpl   $0x0,-0x3c(%ebp)
  802106:	7e 06                	jle    80210e <vprintfmt+0x1c1>
  802108:	80 7d d4 2d          	cmpb   $0x2d,-0x2c(%ebp)
  80210c:	75 13                	jne    802121 <vprintfmt+0x1d4>
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  80210e:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802111:	0f be 02             	movsbl (%edx),%eax
  802114:	85 c0                	test   %eax,%eax
  802116:	0f 85 99 00 00 00    	jne    8021b5 <vprintfmt+0x268>
  80211c:	e9 86 00 00 00       	jmp    8021a7 <vprintfmt+0x25a>
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  802121:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  802125:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  802128:	89 0c 24             	mov    %ecx,(%esp)
  80212b:	e8 fb 02 00 00       	call   80242b <strnlen>
  802130:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  802133:	29 c2                	sub    %eax,%edx
  802135:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  802138:	85 d2                	test   %edx,%edx
  80213a:	7e d2                	jle    80210e <vprintfmt+0x1c1>
					putch(padc, putdat);
  80213c:	0f be 4d d4          	movsbl -0x2c(%ebp),%ecx
  802140:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  802143:	89 5d c4             	mov    %ebx,-0x3c(%ebp)
  802146:	89 d3                	mov    %edx,%ebx
  802148:	89 74 24 04          	mov    %esi,0x4(%esp)
  80214c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80214f:	89 04 24             	mov    %eax,(%esp)
  802152:	ff d7                	call   *%edi
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  802154:	83 eb 01             	sub    $0x1,%ebx
  802157:	85 db                	test   %ebx,%ebx
  802159:	7f ed                	jg     802148 <vprintfmt+0x1fb>
  80215b:	8b 5d c4             	mov    -0x3c(%ebp),%ebx
  80215e:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  802165:	eb a7                	jmp    80210e <vprintfmt+0x1c1>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
  802167:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  80216b:	74 18                	je     802185 <vprintfmt+0x238>
  80216d:	8d 50 e0             	lea    -0x20(%eax),%edx
  802170:	83 fa 5e             	cmp    $0x5e,%edx
  802173:	76 10                	jbe    802185 <vprintfmt+0x238>
					putch('?', putdat);
  802175:	89 7c 24 04          	mov    %edi,0x4(%esp)
  802179:	c7 04 24 3f 00 00 00 	movl   $0x3f,(%esp)
  802180:	ff 55 e0             	call   *-0x20(%ebp)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
  802183:	eb 0a                	jmp    80218f <vprintfmt+0x242>
					putch('?', putdat);
				else
					putch(ch, putdat);
  802185:	89 7c 24 04          	mov    %edi,0x4(%esp)
  802189:	89 04 24             	mov    %eax,(%esp)
  80218c:	ff 55 e0             	call   *-0x20(%ebp)
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  80218f:	83 6d e4 01          	subl   $0x1,-0x1c(%ebp)
  802193:	0f be 03             	movsbl (%ebx),%eax
  802196:	85 c0                	test   %eax,%eax
  802198:	74 05                	je     80219f <vprintfmt+0x252>
  80219a:	83 c3 01             	add    $0x1,%ebx
  80219d:	eb 29                	jmp    8021c8 <vprintfmt+0x27b>
  80219f:	89 fe                	mov    %edi,%esi
  8021a1:	8b 7d e0             	mov    -0x20(%ebp),%edi
  8021a4:	8b 5d d0             	mov    -0x30(%ebp),%ebx
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  8021a7:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8021ab:	7f 2e                	jg     8021db <vprintfmt+0x28e>
  8021ad:	8b 5d cc             	mov    -0x34(%ebp),%ebx
  8021b0:	e9 c4 fd ff ff       	jmp    801f79 <vprintfmt+0x2c>
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8021b5:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8021b8:	83 c2 01             	add    $0x1,%edx
  8021bb:	89 7d e0             	mov    %edi,-0x20(%ebp)
  8021be:	89 f7                	mov    %esi,%edi
  8021c0:	8b 75 d0             	mov    -0x30(%ebp),%esi
  8021c3:	89 5d d0             	mov    %ebx,-0x30(%ebp)
  8021c6:	89 d3                	mov    %edx,%ebx
  8021c8:	85 f6                	test   %esi,%esi
  8021ca:	78 9b                	js     802167 <vprintfmt+0x21a>
  8021cc:	83 ee 01             	sub    $0x1,%esi
  8021cf:	79 96                	jns    802167 <vprintfmt+0x21a>
  8021d1:	89 fe                	mov    %edi,%esi
  8021d3:	8b 7d e0             	mov    -0x20(%ebp),%edi
  8021d6:	8b 5d d0             	mov    -0x30(%ebp),%ebx
  8021d9:	eb cc                	jmp    8021a7 <vprintfmt+0x25a>
  8021db:	89 5d d8             	mov    %ebx,-0x28(%ebp)
  8021de:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
				putch(' ', putdat);
  8021e1:	89 74 24 04          	mov    %esi,0x4(%esp)
  8021e5:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  8021ec:	ff d7                	call   *%edi
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  8021ee:	83 eb 01             	sub    $0x1,%ebx
  8021f1:	85 db                	test   %ebx,%ebx
  8021f3:	7f ec                	jg     8021e1 <vprintfmt+0x294>
  8021f5:	8b 5d d8             	mov    -0x28(%ebp),%ebx
  8021f8:	e9 7c fd ff ff       	jmp    801f79 <vprintfmt+0x2c>
  8021fd:	89 45 cc             	mov    %eax,-0x34(%ebp)
// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
	if (lflag >= 2)
  802200:	83 f9 01             	cmp    $0x1,%ecx
  802203:	7e 16                	jle    80221b <vprintfmt+0x2ce>
		return va_arg(*ap, long long);
  802205:	8b 45 14             	mov    0x14(%ebp),%eax
  802208:	8d 50 08             	lea    0x8(%eax),%edx
  80220b:	89 55 14             	mov    %edx,0x14(%ebp)
  80220e:	8b 10                	mov    (%eax),%edx
  802210:	8b 48 04             	mov    0x4(%eax),%ecx
  802213:	89 55 d8             	mov    %edx,-0x28(%ebp)
  802216:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  802219:	eb 32                	jmp    80224d <vprintfmt+0x300>
	else if (lflag)
  80221b:	85 c9                	test   %ecx,%ecx
  80221d:	74 18                	je     802237 <vprintfmt+0x2ea>
		return va_arg(*ap, long);
  80221f:	8b 45 14             	mov    0x14(%ebp),%eax
  802222:	8d 50 04             	lea    0x4(%eax),%edx
  802225:	89 55 14             	mov    %edx,0x14(%ebp)
  802228:	8b 00                	mov    (%eax),%eax
  80222a:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80222d:	89 c1                	mov    %eax,%ecx
  80222f:	c1 f9 1f             	sar    $0x1f,%ecx
  802232:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  802235:	eb 16                	jmp    80224d <vprintfmt+0x300>
	else
		return va_arg(*ap, int);
  802237:	8b 45 14             	mov    0x14(%ebp),%eax
  80223a:	8d 50 04             	lea    0x4(%eax),%edx
  80223d:	89 55 14             	mov    %edx,0x14(%ebp)
  802240:	8b 00                	mov    (%eax),%eax
  802242:	89 45 d8             	mov    %eax,-0x28(%ebp)
  802245:	89 c2                	mov    %eax,%edx
  802247:	c1 fa 1f             	sar    $0x1f,%edx
  80224a:	89 55 dc             	mov    %edx,-0x24(%ebp)
				putch(' ', putdat);
			break;

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  80224d:	8b 4d d8             	mov    -0x28(%ebp),%ecx
  802250:	8b 5d dc             	mov    -0x24(%ebp),%ebx
  802253:	b8 0a 00 00 00       	mov    $0xa,%eax
			if ((long long) num < 0) {
  802258:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  80225c:	0f 89 9b 00 00 00    	jns    8022fd <vprintfmt+0x3b0>
				putch('-', putdat);
  802262:	89 74 24 04          	mov    %esi,0x4(%esp)
  802266:	c7 04 24 2d 00 00 00 	movl   $0x2d,(%esp)
  80226d:	ff d7                	call   *%edi
				num = -(long long) num;
  80226f:	8b 4d d8             	mov    -0x28(%ebp),%ecx
  802272:	8b 5d dc             	mov    -0x24(%ebp),%ebx
  802275:	f7 d9                	neg    %ecx
  802277:	83 d3 00             	adc    $0x0,%ebx
  80227a:	f7 db                	neg    %ebx
  80227c:	b8 0a 00 00 00       	mov    $0xa,%eax
  802281:	eb 7a                	jmp    8022fd <vprintfmt+0x3b0>
  802283:	89 45 cc             	mov    %eax,-0x34(%ebp)
			base = 10;
			goto number;

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  802286:	89 ca                	mov    %ecx,%edx
  802288:	8d 45 14             	lea    0x14(%ebp),%eax
  80228b:	e8 66 fc ff ff       	call   801ef6 <getuint>
  802290:	89 c1                	mov    %eax,%ecx
  802292:	89 d3                	mov    %edx,%ebx
  802294:	b8 0a 00 00 00       	mov    $0xa,%eax
			base = 10;
			goto number;
  802299:	eb 62                	jmp    8022fd <vprintfmt+0x3b0>
  80229b:	89 45 cc             	mov    %eax,-0x34(%ebp)
		case 'o':
			// Replace this with your code.
			// putch('X', putdat);
			// putch('X', putdat);
			// putch('X', putdat);
			num = getuint(&ap, lflag);
  80229e:	89 ca                	mov    %ecx,%edx
  8022a0:	8d 45 14             	lea    0x14(%ebp),%eax
  8022a3:	e8 4e fc ff ff       	call   801ef6 <getuint>
  8022a8:	89 c1                	mov    %eax,%ecx
  8022aa:	89 d3                	mov    %edx,%ebx
  8022ac:	b8 08 00 00 00       	mov    $0x8,%eax
			base = 8;
			goto number;
  8022b1:	eb 4a                	jmp    8022fd <vprintfmt+0x3b0>
  8022b3:	89 45 cc             	mov    %eax,-0x34(%ebp)
			break;

		// pointer
		case 'p':
			putch('0', putdat);
  8022b6:	89 74 24 04          	mov    %esi,0x4(%esp)
  8022ba:	c7 04 24 30 00 00 00 	movl   $0x30,(%esp)
  8022c1:	ff d7                	call   *%edi
			putch('x', putdat);
  8022c3:	89 74 24 04          	mov    %esi,0x4(%esp)
  8022c7:	c7 04 24 78 00 00 00 	movl   $0x78,(%esp)
  8022ce:	ff d7                	call   *%edi
			num = (unsigned long long)
  8022d0:	8b 45 14             	mov    0x14(%ebp),%eax
  8022d3:	8d 50 04             	lea    0x4(%eax),%edx
  8022d6:	89 55 14             	mov    %edx,0x14(%ebp)
  8022d9:	8b 08                	mov    (%eax),%ecx
  8022db:	bb 00 00 00 00       	mov    $0x0,%ebx
  8022e0:	b8 10 00 00 00       	mov    $0x10,%eax
				(uintptr_t) va_arg(ap, void *);
			base = 16;
			goto number;
  8022e5:	eb 16                	jmp    8022fd <vprintfmt+0x3b0>
  8022e7:	89 45 cc             	mov    %eax,-0x34(%ebp)

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  8022ea:	89 ca                	mov    %ecx,%edx
  8022ec:	8d 45 14             	lea    0x14(%ebp),%eax
  8022ef:	e8 02 fc ff ff       	call   801ef6 <getuint>
  8022f4:	89 c1                	mov    %eax,%ecx
  8022f6:	89 d3                	mov    %edx,%ebx
  8022f8:	b8 10 00 00 00       	mov    $0x10,%eax
			base = 16;
		number:
			printnum(putch, putdat, num, base, width, padc);
  8022fd:	0f be 55 d4          	movsbl -0x2c(%ebp),%edx
  802301:	89 54 24 10          	mov    %edx,0x10(%esp)
  802305:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802308:	89 54 24 0c          	mov    %edx,0xc(%esp)
  80230c:	89 44 24 08          	mov    %eax,0x8(%esp)
  802310:	89 0c 24             	mov    %ecx,(%esp)
  802313:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  802317:	89 f2                	mov    %esi,%edx
  802319:	89 f8                	mov    %edi,%eax
  80231b:	e8 e0 fa ff ff       	call   801e00 <printnum>
  802320:	8b 5d cc             	mov    -0x34(%ebp),%ebx
			break;
  802323:	e9 51 fc ff ff       	jmp    801f79 <vprintfmt+0x2c>
  802328:	89 45 cc             	mov    %eax,-0x34(%ebp)
  80232b:	8b 55 e0             	mov    -0x20(%ebp),%edx

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  80232e:	89 74 24 04          	mov    %esi,0x4(%esp)
  802332:	89 14 24             	mov    %edx,(%esp)
  802335:	ff d7                	call   *%edi
  802337:	8b 5d cc             	mov    -0x34(%ebp),%ebx
			break;
  80233a:	e9 3a fc ff ff       	jmp    801f79 <vprintfmt+0x2c>
			
		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  80233f:	89 74 24 04          	mov    %esi,0x4(%esp)
  802343:	c7 04 24 25 00 00 00 	movl   $0x25,(%esp)
  80234a:	ff d7                	call   *%edi
			for (fmt--; fmt[-1] != '%'; fmt--)
  80234c:	8d 43 ff             	lea    -0x1(%ebx),%eax
  80234f:	80 38 25             	cmpb   $0x25,(%eax)
  802352:	0f 84 21 fc ff ff    	je     801f79 <vprintfmt+0x2c>
  802358:	89 c3                	mov    %eax,%ebx
  80235a:	eb f0                	jmp    80234c <vprintfmt+0x3ff>
				/* do nothing */;
			break;
		}
	}
}
  80235c:	83 c4 5c             	add    $0x5c,%esp
  80235f:	5b                   	pop    %ebx
  802360:	5e                   	pop    %esi
  802361:	5f                   	pop    %edi
  802362:	5d                   	pop    %ebp
  802363:	c3                   	ret    

00802364 <vsnprintf>:
		*b->buf++ = ch;
}

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  802364:	55                   	push   %ebp
  802365:	89 e5                	mov    %esp,%ebp
  802367:	83 ec 28             	sub    $0x28,%esp
  80236a:	8b 45 08             	mov    0x8(%ebp),%eax
  80236d:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};

	if (buf == NULL || n < 1)
  802370:	85 c0                	test   %eax,%eax
  802372:	74 04                	je     802378 <vsnprintf+0x14>
  802374:	85 d2                	test   %edx,%edx
  802376:	7f 07                	jg     80237f <vsnprintf+0x1b>
  802378:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80237d:	eb 3b                	jmp    8023ba <vsnprintf+0x56>
}

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
	struct sprintbuf b = {buf, buf+n-1, 0};
  80237f:	89 45 ec             	mov    %eax,-0x14(%ebp)
  802382:	8d 44 10 ff          	lea    -0x1(%eax,%edx,1),%eax
  802386:	89 45 f0             	mov    %eax,-0x10(%ebp)
  802389:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  802390:	8b 45 14             	mov    0x14(%ebp),%eax
  802393:	89 44 24 0c          	mov    %eax,0xc(%esp)
  802397:	8b 45 10             	mov    0x10(%ebp),%eax
  80239a:	89 44 24 08          	mov    %eax,0x8(%esp)
  80239e:	8d 45 ec             	lea    -0x14(%ebp),%eax
  8023a1:	89 44 24 04          	mov    %eax,0x4(%esp)
  8023a5:	c7 04 24 30 1f 80 00 	movl   $0x801f30,(%esp)
  8023ac:	e8 9c fb ff ff       	call   801f4d <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  8023b1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8023b4:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  8023b7:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  8023ba:	c9                   	leave  
  8023bb:	c3                   	ret    

008023bc <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  8023bc:	55                   	push   %ebp
  8023bd:	89 e5                	mov    %esp,%ebp
  8023bf:	83 ec 18             	sub    $0x18,%esp

	return b.cnt;
}

int
snprintf(char *buf, int n, const char *fmt, ...)
  8023c2:	8d 45 14             	lea    0x14(%ebp),%eax
{
	va_list ap;
	int rc;

	va_start(ap, fmt);
	rc = vsnprintf(buf, n, fmt, ap);
  8023c5:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8023c9:	8b 45 10             	mov    0x10(%ebp),%eax
  8023cc:	89 44 24 08          	mov    %eax,0x8(%esp)
  8023d0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8023d3:	89 44 24 04          	mov    %eax,0x4(%esp)
  8023d7:	8b 45 08             	mov    0x8(%ebp),%eax
  8023da:	89 04 24             	mov    %eax,(%esp)
  8023dd:	e8 82 ff ff ff       	call   802364 <vsnprintf>
	va_end(ap);

	return rc;
}
  8023e2:	c9                   	leave  
  8023e3:	c3                   	ret    

008023e4 <printfmt>:
	}
}

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  8023e4:	55                   	push   %ebp
  8023e5:	89 e5                	mov    %esp,%ebp
  8023e7:	83 ec 18             	sub    $0x18,%esp
		}
	}
}

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
  8023ea:	8d 45 14             	lea    0x14(%ebp),%eax
{
	va_list ap;

	va_start(ap, fmt);
	vprintfmt(putch, putdat, fmt, ap);
  8023ed:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8023f1:	8b 45 10             	mov    0x10(%ebp),%eax
  8023f4:	89 44 24 08          	mov    %eax,0x8(%esp)
  8023f8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8023fb:	89 44 24 04          	mov    %eax,0x4(%esp)
  8023ff:	8b 45 08             	mov    0x8(%ebp),%eax
  802402:	89 04 24             	mov    %eax,(%esp)
  802405:	e8 43 fb ff ff       	call   801f4d <vprintfmt>
	va_end(ap);
}
  80240a:	c9                   	leave  
  80240b:	c3                   	ret    
  80240c:	00 00                	add    %al,(%eax)
	...

00802410 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  802410:	55                   	push   %ebp
  802411:	89 e5                	mov    %esp,%ebp
  802413:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  802416:	b8 00 00 00 00       	mov    $0x0,%eax
  80241b:	80 3a 00             	cmpb   $0x0,(%edx)
  80241e:	74 09                	je     802429 <strlen+0x19>
		n++;
  802420:	83 c0 01             	add    $0x1,%eax
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  802423:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  802427:	75 f7                	jne    802420 <strlen+0x10>
		n++;
	return n;
}
  802429:	5d                   	pop    %ebp
  80242a:	c3                   	ret    

0080242b <strnlen>:

int
strnlen(const char *s, size_t size)
{
  80242b:	55                   	push   %ebp
  80242c:	89 e5                	mov    %esp,%ebp
  80242e:	53                   	push   %ebx
  80242f:	8b 5d 08             	mov    0x8(%ebp),%ebx
  802432:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  802435:	85 c9                	test   %ecx,%ecx
  802437:	74 19                	je     802452 <strnlen+0x27>
  802439:	80 3b 00             	cmpb   $0x0,(%ebx)
  80243c:	74 14                	je     802452 <strnlen+0x27>
  80243e:	b8 00 00 00 00       	mov    $0x0,%eax
		n++;
  802443:	83 c0 01             	add    $0x1,%eax
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  802446:	39 c8                	cmp    %ecx,%eax
  802448:	74 0d                	je     802457 <strnlen+0x2c>
  80244a:	80 3c 03 00          	cmpb   $0x0,(%ebx,%eax,1)
  80244e:	75 f3                	jne    802443 <strnlen+0x18>
  802450:	eb 05                	jmp    802457 <strnlen+0x2c>
  802452:	b8 00 00 00 00       	mov    $0x0,%eax
		n++;
	return n;
}
  802457:	5b                   	pop    %ebx
  802458:	5d                   	pop    %ebp
  802459:	c3                   	ret    

0080245a <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  80245a:	55                   	push   %ebp
  80245b:	89 e5                	mov    %esp,%ebp
  80245d:	53                   	push   %ebx
  80245e:	8b 45 08             	mov    0x8(%ebp),%eax
  802461:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  802464:	ba 00 00 00 00       	mov    $0x0,%edx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  802469:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
  80246d:	88 0c 10             	mov    %cl,(%eax,%edx,1)
  802470:	83 c2 01             	add    $0x1,%edx
  802473:	84 c9                	test   %cl,%cl
  802475:	75 f2                	jne    802469 <strcpy+0xf>
		/* do nothing */;
	return ret;
}
  802477:	5b                   	pop    %ebx
  802478:	5d                   	pop    %ebp
  802479:	c3                   	ret    

0080247a <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  80247a:	55                   	push   %ebp
  80247b:	89 e5                	mov    %esp,%ebp
  80247d:	56                   	push   %esi
  80247e:	53                   	push   %ebx
  80247f:	8b 45 08             	mov    0x8(%ebp),%eax
  802482:	8b 55 0c             	mov    0xc(%ebp),%edx
  802485:	8b 75 10             	mov    0x10(%ebp),%esi
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  802488:	85 f6                	test   %esi,%esi
  80248a:	74 18                	je     8024a4 <strncpy+0x2a>
  80248c:	b9 00 00 00 00       	mov    $0x0,%ecx
		*dst++ = *src;
  802491:	0f b6 1a             	movzbl (%edx),%ebx
  802494:	88 1c 08             	mov    %bl,(%eax,%ecx,1)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  802497:	80 3a 01             	cmpb   $0x1,(%edx)
  80249a:	83 da ff             	sbb    $0xffffffff,%edx
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  80249d:	83 c1 01             	add    $0x1,%ecx
  8024a0:	39 ce                	cmp    %ecx,%esi
  8024a2:	77 ed                	ja     802491 <strncpy+0x17>
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
}
  8024a4:	5b                   	pop    %ebx
  8024a5:	5e                   	pop    %esi
  8024a6:	5d                   	pop    %ebp
  8024a7:	c3                   	ret    

008024a8 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  8024a8:	55                   	push   %ebp
  8024a9:	89 e5                	mov    %esp,%ebp
  8024ab:	56                   	push   %esi
  8024ac:	53                   	push   %ebx
  8024ad:	8b 75 08             	mov    0x8(%ebp),%esi
  8024b0:	8b 55 0c             	mov    0xc(%ebp),%edx
  8024b3:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  8024b6:	89 f0                	mov    %esi,%eax
  8024b8:	85 c9                	test   %ecx,%ecx
  8024ba:	74 27                	je     8024e3 <strlcpy+0x3b>
		while (--size > 0 && *src != '\0')
  8024bc:	83 e9 01             	sub    $0x1,%ecx
  8024bf:	74 1d                	je     8024de <strlcpy+0x36>
  8024c1:	0f b6 1a             	movzbl (%edx),%ebx
  8024c4:	84 db                	test   %bl,%bl
  8024c6:	74 16                	je     8024de <strlcpy+0x36>
			*dst++ = *src++;
  8024c8:	88 18                	mov    %bl,(%eax)
  8024ca:	83 c0 01             	add    $0x1,%eax
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  8024cd:	83 e9 01             	sub    $0x1,%ecx
  8024d0:	74 0e                	je     8024e0 <strlcpy+0x38>
			*dst++ = *src++;
  8024d2:	83 c2 01             	add    $0x1,%edx
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  8024d5:	0f b6 1a             	movzbl (%edx),%ebx
  8024d8:	84 db                	test   %bl,%bl
  8024da:	75 ec                	jne    8024c8 <strlcpy+0x20>
  8024dc:	eb 02                	jmp    8024e0 <strlcpy+0x38>
  8024de:	89 f0                	mov    %esi,%eax
			*dst++ = *src++;
		*dst = '\0';
  8024e0:	c6 00 00             	movb   $0x0,(%eax)
  8024e3:	29 f0                	sub    %esi,%eax
	}
	return dst - dst_in;
}
  8024e5:	5b                   	pop    %ebx
  8024e6:	5e                   	pop    %esi
  8024e7:	5d                   	pop    %ebp
  8024e8:	c3                   	ret    

008024e9 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  8024e9:	55                   	push   %ebp
  8024ea:	89 e5                	mov    %esp,%ebp
  8024ec:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8024ef:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  8024f2:	0f b6 01             	movzbl (%ecx),%eax
  8024f5:	84 c0                	test   %al,%al
  8024f7:	74 15                	je     80250e <strcmp+0x25>
  8024f9:	3a 02                	cmp    (%edx),%al
  8024fb:	75 11                	jne    80250e <strcmp+0x25>
		p++, q++;
  8024fd:	83 c1 01             	add    $0x1,%ecx
  802500:	83 c2 01             	add    $0x1,%edx
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  802503:	0f b6 01             	movzbl (%ecx),%eax
  802506:	84 c0                	test   %al,%al
  802508:	74 04                	je     80250e <strcmp+0x25>
  80250a:	3a 02                	cmp    (%edx),%al
  80250c:	74 ef                	je     8024fd <strcmp+0x14>
  80250e:	0f b6 c0             	movzbl %al,%eax
  802511:	0f b6 12             	movzbl (%edx),%edx
  802514:	29 d0                	sub    %edx,%eax
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
}
  802516:	5d                   	pop    %ebp
  802517:	c3                   	ret    

00802518 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  802518:	55                   	push   %ebp
  802519:	89 e5                	mov    %esp,%ebp
  80251b:	53                   	push   %ebx
  80251c:	8b 55 08             	mov    0x8(%ebp),%edx
  80251f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  802522:	8b 45 10             	mov    0x10(%ebp),%eax
	while (n > 0 && *p && *p == *q)
  802525:	85 c0                	test   %eax,%eax
  802527:	74 23                	je     80254c <strncmp+0x34>
  802529:	0f b6 1a             	movzbl (%edx),%ebx
  80252c:	84 db                	test   %bl,%bl
  80252e:	74 24                	je     802554 <strncmp+0x3c>
  802530:	3a 19                	cmp    (%ecx),%bl
  802532:	75 20                	jne    802554 <strncmp+0x3c>
  802534:	83 e8 01             	sub    $0x1,%eax
  802537:	74 13                	je     80254c <strncmp+0x34>
		n--, p++, q++;
  802539:	83 c2 01             	add    $0x1,%edx
  80253c:	83 c1 01             	add    $0x1,%ecx
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  80253f:	0f b6 1a             	movzbl (%edx),%ebx
  802542:	84 db                	test   %bl,%bl
  802544:	74 0e                	je     802554 <strncmp+0x3c>
  802546:	3a 19                	cmp    (%ecx),%bl
  802548:	74 ea                	je     802534 <strncmp+0x1c>
  80254a:	eb 08                	jmp    802554 <strncmp+0x3c>
  80254c:	b8 00 00 00 00       	mov    $0x0,%eax
		n--, p++, q++;
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
}
  802551:	5b                   	pop    %ebx
  802552:	5d                   	pop    %ebp
  802553:	c3                   	ret    
	while (n > 0 && *p && *p == *q)
		n--, p++, q++;
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  802554:	0f b6 02             	movzbl (%edx),%eax
  802557:	0f b6 11             	movzbl (%ecx),%edx
  80255a:	29 d0                	sub    %edx,%eax
  80255c:	eb f3                	jmp    802551 <strncmp+0x39>

0080255e <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  80255e:	55                   	push   %ebp
  80255f:	89 e5                	mov    %esp,%ebp
  802561:	8b 45 08             	mov    0x8(%ebp),%eax
  802564:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  802568:	0f b6 10             	movzbl (%eax),%edx
  80256b:	84 d2                	test   %dl,%dl
  80256d:	74 15                	je     802584 <strchr+0x26>
		if (*s == c)
  80256f:	38 ca                	cmp    %cl,%dl
  802571:	75 07                	jne    80257a <strchr+0x1c>
  802573:	eb 14                	jmp    802589 <strchr+0x2b>
  802575:	38 ca                	cmp    %cl,%dl
  802577:	90                   	nop
  802578:	74 0f                	je     802589 <strchr+0x2b>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  80257a:	83 c0 01             	add    $0x1,%eax
  80257d:	0f b6 10             	movzbl (%eax),%edx
  802580:	84 d2                	test   %dl,%dl
  802582:	75 f1                	jne    802575 <strchr+0x17>
  802584:	b8 00 00 00 00       	mov    $0x0,%eax
		if (*s == c)
			return (char *) s;
	return 0;
}
  802589:	5d                   	pop    %ebp
  80258a:	c3                   	ret    

0080258b <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  80258b:	55                   	push   %ebp
  80258c:	89 e5                	mov    %esp,%ebp
  80258e:	8b 45 08             	mov    0x8(%ebp),%eax
  802591:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  802595:	0f b6 10             	movzbl (%eax),%edx
  802598:	84 d2                	test   %dl,%dl
  80259a:	74 18                	je     8025b4 <strfind+0x29>
		if (*s == c)
  80259c:	38 ca                	cmp    %cl,%dl
  80259e:	75 0a                	jne    8025aa <strfind+0x1f>
  8025a0:	eb 12                	jmp    8025b4 <strfind+0x29>
  8025a2:	38 ca                	cmp    %cl,%dl
  8025a4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  8025a8:	74 0a                	je     8025b4 <strfind+0x29>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  8025aa:	83 c0 01             	add    $0x1,%eax
  8025ad:	0f b6 10             	movzbl (%eax),%edx
  8025b0:	84 d2                	test   %dl,%dl
  8025b2:	75 ee                	jne    8025a2 <strfind+0x17>
		if (*s == c)
			break;
	return (char *) s;
}
  8025b4:	5d                   	pop    %ebp
  8025b5:	c3                   	ret    

008025b6 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  8025b6:	55                   	push   %ebp
  8025b7:	89 e5                	mov    %esp,%ebp
  8025b9:	83 ec 0c             	sub    $0xc,%esp
  8025bc:	89 1c 24             	mov    %ebx,(%esp)
  8025bf:	89 74 24 04          	mov    %esi,0x4(%esp)
  8025c3:	89 7c 24 08          	mov    %edi,0x8(%esp)
  8025c7:	8b 7d 08             	mov    0x8(%ebp),%edi
  8025ca:	8b 45 0c             	mov    0xc(%ebp),%eax
  8025cd:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  8025d0:	85 c9                	test   %ecx,%ecx
  8025d2:	74 30                	je     802604 <memset+0x4e>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  8025d4:	f7 c7 03 00 00 00    	test   $0x3,%edi
  8025da:	75 25                	jne    802601 <memset+0x4b>
  8025dc:	f6 c1 03             	test   $0x3,%cl
  8025df:	75 20                	jne    802601 <memset+0x4b>
		c &= 0xFF;
  8025e1:	0f b6 d0             	movzbl %al,%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  8025e4:	89 d3                	mov    %edx,%ebx
  8025e6:	c1 e3 08             	shl    $0x8,%ebx
  8025e9:	89 d6                	mov    %edx,%esi
  8025eb:	c1 e6 18             	shl    $0x18,%esi
  8025ee:	89 d0                	mov    %edx,%eax
  8025f0:	c1 e0 10             	shl    $0x10,%eax
  8025f3:	09 f0                	or     %esi,%eax
  8025f5:	09 d0                	or     %edx,%eax
		asm volatile("cld; rep stosl\n"
  8025f7:	09 d8                	or     %ebx,%eax
  8025f9:	c1 e9 02             	shr    $0x2,%ecx
  8025fc:	fc                   	cld    
  8025fd:	f3 ab                	rep stos %eax,%es:(%edi)
{
	char *p;

	if (n == 0)
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  8025ff:	eb 03                	jmp    802604 <memset+0x4e>
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  802601:	fc                   	cld    
  802602:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  802604:	89 f8                	mov    %edi,%eax
  802606:	8b 1c 24             	mov    (%esp),%ebx
  802609:	8b 74 24 04          	mov    0x4(%esp),%esi
  80260d:	8b 7c 24 08          	mov    0x8(%esp),%edi
  802611:	89 ec                	mov    %ebp,%esp
  802613:	5d                   	pop    %ebp
  802614:	c3                   	ret    

00802615 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  802615:	55                   	push   %ebp
  802616:	89 e5                	mov    %esp,%ebp
  802618:	83 ec 08             	sub    $0x8,%esp
  80261b:	89 34 24             	mov    %esi,(%esp)
  80261e:	89 7c 24 04          	mov    %edi,0x4(%esp)
  802622:	8b 45 08             	mov    0x8(%ebp),%eax
  802625:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;
	
	s = src;
  802628:	8b 75 0c             	mov    0xc(%ebp),%esi
	d = dst;
  80262b:	89 c7                	mov    %eax,%edi
	if (s < d && s + n > d) {
  80262d:	39 c6                	cmp    %eax,%esi
  80262f:	73 35                	jae    802666 <memmove+0x51>
  802631:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  802634:	39 d0                	cmp    %edx,%eax
  802636:	73 2e                	jae    802666 <memmove+0x51>
		s += n;
		d += n;
  802638:	01 cf                	add    %ecx,%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  80263a:	f6 c2 03             	test   $0x3,%dl
  80263d:	75 1b                	jne    80265a <memmove+0x45>
  80263f:	f7 c7 03 00 00 00    	test   $0x3,%edi
  802645:	75 13                	jne    80265a <memmove+0x45>
  802647:	f6 c1 03             	test   $0x3,%cl
  80264a:	75 0e                	jne    80265a <memmove+0x45>
			asm volatile("std; rep movsl\n"
  80264c:	83 ef 04             	sub    $0x4,%edi
  80264f:	8d 72 fc             	lea    -0x4(%edx),%esi
  802652:	c1 e9 02             	shr    $0x2,%ecx
  802655:	fd                   	std    
  802656:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  802658:	eb 09                	jmp    802663 <memmove+0x4e>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  80265a:	83 ef 01             	sub    $0x1,%edi
  80265d:	8d 72 ff             	lea    -0x1(%edx),%esi
  802660:	fd                   	std    
  802661:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  802663:	fc                   	cld    
	const char *s;
	char *d;
	
	s = src;
	d = dst;
	if (s < d && s + n > d) {
  802664:	eb 20                	jmp    802686 <memmove+0x71>
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  802666:	f7 c6 03 00 00 00    	test   $0x3,%esi
  80266c:	75 15                	jne    802683 <memmove+0x6e>
  80266e:	f7 c7 03 00 00 00    	test   $0x3,%edi
  802674:	75 0d                	jne    802683 <memmove+0x6e>
  802676:	f6 c1 03             	test   $0x3,%cl
  802679:	75 08                	jne    802683 <memmove+0x6e>
			asm volatile("cld; rep movsl\n"
  80267b:	c1 e9 02             	shr    $0x2,%ecx
  80267e:	fc                   	cld    
  80267f:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  802681:	eb 03                	jmp    802686 <memmove+0x71>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  802683:	fc                   	cld    
  802684:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  802686:	8b 34 24             	mov    (%esp),%esi
  802689:	8b 7c 24 04          	mov    0x4(%esp),%edi
  80268d:	89 ec                	mov    %ebp,%esp
  80268f:	5d                   	pop    %ebp
  802690:	c3                   	ret    

00802691 <memcpy>:

/* sigh - gcc emits references to this for structure assignments! */
/* it is *not* prototyped in inc/string.h - do not use directly. */
void *
memcpy(void *dst, void *src, size_t n)
{
  802691:	55                   	push   %ebp
  802692:	89 e5                	mov    %esp,%ebp
  802694:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  802697:	8b 45 10             	mov    0x10(%ebp),%eax
  80269a:	89 44 24 08          	mov    %eax,0x8(%esp)
  80269e:	8b 45 0c             	mov    0xc(%ebp),%eax
  8026a1:	89 44 24 04          	mov    %eax,0x4(%esp)
  8026a5:	8b 45 08             	mov    0x8(%ebp),%eax
  8026a8:	89 04 24             	mov    %eax,(%esp)
  8026ab:	e8 65 ff ff ff       	call   802615 <memmove>
}
  8026b0:	c9                   	leave  
  8026b1:	c3                   	ret    

008026b2 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  8026b2:	55                   	push   %ebp
  8026b3:	89 e5                	mov    %esp,%ebp
  8026b5:	57                   	push   %edi
  8026b6:	56                   	push   %esi
  8026b7:	53                   	push   %ebx
  8026b8:	8b 75 08             	mov    0x8(%ebp),%esi
  8026bb:	8b 7d 0c             	mov    0xc(%ebp),%edi
  8026be:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  8026c1:	85 c9                	test   %ecx,%ecx
  8026c3:	74 36                	je     8026fb <memcmp+0x49>
		if (*s1 != *s2)
  8026c5:	0f b6 06             	movzbl (%esi),%eax
  8026c8:	0f b6 1f             	movzbl (%edi),%ebx
  8026cb:	38 d8                	cmp    %bl,%al
  8026cd:	74 20                	je     8026ef <memcmp+0x3d>
  8026cf:	eb 14                	jmp    8026e5 <memcmp+0x33>
  8026d1:	0f b6 44 16 01       	movzbl 0x1(%esi,%edx,1),%eax
  8026d6:	0f b6 5c 17 01       	movzbl 0x1(%edi,%edx,1),%ebx
  8026db:	83 c2 01             	add    $0x1,%edx
  8026de:	83 e9 01             	sub    $0x1,%ecx
  8026e1:	38 d8                	cmp    %bl,%al
  8026e3:	74 12                	je     8026f7 <memcmp+0x45>
			return (int) *s1 - (int) *s2;
  8026e5:	0f b6 c0             	movzbl %al,%eax
  8026e8:	0f b6 db             	movzbl %bl,%ebx
  8026eb:	29 d8                	sub    %ebx,%eax
  8026ed:	eb 11                	jmp    802700 <memcmp+0x4e>
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  8026ef:	83 e9 01             	sub    $0x1,%ecx
  8026f2:	ba 00 00 00 00       	mov    $0x0,%edx
  8026f7:	85 c9                	test   %ecx,%ecx
  8026f9:	75 d6                	jne    8026d1 <memcmp+0x1f>
  8026fb:	b8 00 00 00 00       	mov    $0x0,%eax
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
}
  802700:	5b                   	pop    %ebx
  802701:	5e                   	pop    %esi
  802702:	5f                   	pop    %edi
  802703:	5d                   	pop    %ebp
  802704:	c3                   	ret    

00802705 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  802705:	55                   	push   %ebp
  802706:	89 e5                	mov    %esp,%ebp
  802708:	8b 45 08             	mov    0x8(%ebp),%eax
	const void *ends = (const char *) s + n;
  80270b:	89 c2                	mov    %eax,%edx
  80270d:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  802710:	39 d0                	cmp    %edx,%eax
  802712:	73 15                	jae    802729 <memfind+0x24>
		if (*(const unsigned char *) s == (unsigned char) c)
  802714:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
  802718:	38 08                	cmp    %cl,(%eax)
  80271a:	75 06                	jne    802722 <memfind+0x1d>
  80271c:	eb 0b                	jmp    802729 <memfind+0x24>
  80271e:	38 08                	cmp    %cl,(%eax)
  802720:	74 07                	je     802729 <memfind+0x24>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  802722:	83 c0 01             	add    $0x1,%eax
  802725:	39 c2                	cmp    %eax,%edx
  802727:	77 f5                	ja     80271e <memfind+0x19>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
	return (void *) s;
}
  802729:	5d                   	pop    %ebp
  80272a:	c3                   	ret    

0080272b <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  80272b:	55                   	push   %ebp
  80272c:	89 e5                	mov    %esp,%ebp
  80272e:	57                   	push   %edi
  80272f:	56                   	push   %esi
  802730:	53                   	push   %ebx
  802731:	83 ec 04             	sub    $0x4,%esp
  802734:	8b 55 08             	mov    0x8(%ebp),%edx
  802737:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  80273a:	0f b6 02             	movzbl (%edx),%eax
  80273d:	3c 20                	cmp    $0x20,%al
  80273f:	74 04                	je     802745 <strtol+0x1a>
  802741:	3c 09                	cmp    $0x9,%al
  802743:	75 0e                	jne    802753 <strtol+0x28>
		s++;
  802745:	83 c2 01             	add    $0x1,%edx
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  802748:	0f b6 02             	movzbl (%edx),%eax
  80274b:	3c 20                	cmp    $0x20,%al
  80274d:	74 f6                	je     802745 <strtol+0x1a>
  80274f:	3c 09                	cmp    $0x9,%al
  802751:	74 f2                	je     802745 <strtol+0x1a>
		s++;

	// plus/minus sign
	if (*s == '+')
  802753:	3c 2b                	cmp    $0x2b,%al
  802755:	75 0c                	jne    802763 <strtol+0x38>
		s++;
  802757:	83 c2 01             	add    $0x1,%edx
  80275a:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  802761:	eb 15                	jmp    802778 <strtol+0x4d>
	else if (*s == '-')
  802763:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  80276a:	3c 2d                	cmp    $0x2d,%al
  80276c:	75 0a                	jne    802778 <strtol+0x4d>
		s++, neg = 1;
  80276e:	83 c2 01             	add    $0x1,%edx
  802771:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  802778:	85 db                	test   %ebx,%ebx
  80277a:	0f 94 c0             	sete   %al
  80277d:	74 05                	je     802784 <strtol+0x59>
  80277f:	83 fb 10             	cmp    $0x10,%ebx
  802782:	75 18                	jne    80279c <strtol+0x71>
  802784:	80 3a 30             	cmpb   $0x30,(%edx)
  802787:	75 13                	jne    80279c <strtol+0x71>
  802789:	80 7a 01 78          	cmpb   $0x78,0x1(%edx)
  80278d:	8d 76 00             	lea    0x0(%esi),%esi
  802790:	75 0a                	jne    80279c <strtol+0x71>
		s += 2, base = 16;
  802792:	83 c2 02             	add    $0x2,%edx
  802795:	bb 10 00 00 00       	mov    $0x10,%ebx
		s++;
	else if (*s == '-')
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  80279a:	eb 15                	jmp    8027b1 <strtol+0x86>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  80279c:	84 c0                	test   %al,%al
  80279e:	66 90                	xchg   %ax,%ax
  8027a0:	74 0f                	je     8027b1 <strtol+0x86>
  8027a2:	bb 0a 00 00 00       	mov    $0xa,%ebx
  8027a7:	80 3a 30             	cmpb   $0x30,(%edx)
  8027aa:	75 05                	jne    8027b1 <strtol+0x86>
		s++, base = 8;
  8027ac:	83 c2 01             	add    $0x1,%edx
  8027af:	b3 08                	mov    $0x8,%bl
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  8027b1:	b8 00 00 00 00       	mov    $0x0,%eax
  8027b6:	89 de                	mov    %ebx,%esi

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  8027b8:	0f b6 0a             	movzbl (%edx),%ecx
  8027bb:	89 cf                	mov    %ecx,%edi
  8027bd:	8d 59 d0             	lea    -0x30(%ecx),%ebx
  8027c0:	80 fb 09             	cmp    $0x9,%bl
  8027c3:	77 08                	ja     8027cd <strtol+0xa2>
			dig = *s - '0';
  8027c5:	0f be c9             	movsbl %cl,%ecx
  8027c8:	83 e9 30             	sub    $0x30,%ecx
  8027cb:	eb 1e                	jmp    8027eb <strtol+0xc0>
		else if (*s >= 'a' && *s <= 'z')
  8027cd:	8d 5f 9f             	lea    -0x61(%edi),%ebx
  8027d0:	80 fb 19             	cmp    $0x19,%bl
  8027d3:	77 08                	ja     8027dd <strtol+0xb2>
			dig = *s - 'a' + 10;
  8027d5:	0f be c9             	movsbl %cl,%ecx
  8027d8:	83 e9 57             	sub    $0x57,%ecx
  8027db:	eb 0e                	jmp    8027eb <strtol+0xc0>
		else if (*s >= 'A' && *s <= 'Z')
  8027dd:	8d 5f bf             	lea    -0x41(%edi),%ebx
  8027e0:	80 fb 19             	cmp    $0x19,%bl
  8027e3:	77 15                	ja     8027fa <strtol+0xcf>
			dig = *s - 'A' + 10;
  8027e5:	0f be c9             	movsbl %cl,%ecx
  8027e8:	83 e9 37             	sub    $0x37,%ecx
		else
			break;
		if (dig >= base)
  8027eb:	39 f1                	cmp    %esi,%ecx
  8027ed:	7d 0b                	jge    8027fa <strtol+0xcf>
			break;
		s++, val = (val * base) + dig;
  8027ef:	83 c2 01             	add    $0x1,%edx
  8027f2:	0f af c6             	imul   %esi,%eax
  8027f5:	8d 04 01             	lea    (%ecx,%eax,1),%eax
		// we don't properly detect overflow!
	}
  8027f8:	eb be                	jmp    8027b8 <strtol+0x8d>
  8027fa:	89 c1                	mov    %eax,%ecx

	if (endptr)
  8027fc:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802800:	74 05                	je     802807 <strtol+0xdc>
		*endptr = (char *) s;
  802802:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  802805:	89 13                	mov    %edx,(%ebx)
	return (neg ? -val : val);
  802807:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80280b:	74 04                	je     802811 <strtol+0xe6>
  80280d:	89 c8                	mov    %ecx,%eax
  80280f:	f7 d8                	neg    %eax
}
  802811:	83 c4 04             	add    $0x4,%esp
  802814:	5b                   	pop    %ebx
  802815:	5e                   	pop    %esi
  802816:	5f                   	pop    %edi
  802817:	5d                   	pop    %ebp
  802818:	c3                   	ret    
  802819:	00 00                	add    %al,(%eax)
	...

0080281c <sys_cgetc>:
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}

int
sys_cgetc(void)
{
  80281c:	55                   	push   %ebp
  80281d:	89 e5                	mov    %esp,%ebp
  80281f:	83 ec 0c             	sub    $0xc,%esp
  802822:	89 1c 24             	mov    %ebx,(%esp)
  802825:	89 74 24 04          	mov    %esi,0x4(%esp)
  802829:	89 7c 24 08          	mov    %edi,0x8(%esp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80282d:	ba 00 00 00 00       	mov    $0x0,%edx
  802832:	b8 01 00 00 00       	mov    $0x1,%eax
  802837:	89 d1                	mov    %edx,%ecx
  802839:	89 d3                	mov    %edx,%ebx
  80283b:	89 d7                	mov    %edx,%edi
  80283d:	89 d6                	mov    %edx,%esi
  80283f:	cd 30                	int    $0x30

int
sys_cgetc(void)
{
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  802841:	8b 1c 24             	mov    (%esp),%ebx
  802844:	8b 74 24 04          	mov    0x4(%esp),%esi
  802848:	8b 7c 24 08          	mov    0x8(%esp),%edi
  80284c:	89 ec                	mov    %ebp,%esp
  80284e:	5d                   	pop    %ebp
  80284f:	c3                   	ret    

00802850 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  802850:	55                   	push   %ebp
  802851:	89 e5                	mov    %esp,%ebp
  802853:	83 ec 0c             	sub    $0xc,%esp
  802856:	89 1c 24             	mov    %ebx,(%esp)
  802859:	89 74 24 04          	mov    %esi,0x4(%esp)
  80285d:	89 7c 24 08          	mov    %edi,0x8(%esp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  802861:	b8 00 00 00 00       	mov    $0x0,%eax
  802866:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  802869:	8b 55 08             	mov    0x8(%ebp),%edx
  80286c:	89 c3                	mov    %eax,%ebx
  80286e:	89 c7                	mov    %eax,%edi
  802870:	89 c6                	mov    %eax,%esi
  802872:	cd 30                	int    $0x30

void
sys_cputs(const char *s, size_t len)
{
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  802874:	8b 1c 24             	mov    (%esp),%ebx
  802877:	8b 74 24 04          	mov    0x4(%esp),%esi
  80287b:	8b 7c 24 08          	mov    0x8(%esp),%edi
  80287f:	89 ec                	mov    %ebp,%esp
  802881:	5d                   	pop    %ebp
  802882:	c3                   	ret    

00802883 <sys_page_insert>:
{
	return syscall(SYS_page_waste, 0, (uint32_t)p, (uint32_t)n, 0, 0,0);
}
int
sys_page_insert(envid_t envid, void *va, struct Page *p, int perm)
{
  802883:	55                   	push   %ebp
  802884:	89 e5                	mov    %esp,%ebp
  802886:	83 ec 38             	sub    $0x38,%esp
  802889:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  80288c:	89 75 f8             	mov    %esi,-0x8(%ebp)
  80288f:	89 7d fc             	mov    %edi,-0x4(%ebp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  802892:	be 00 00 00 00       	mov    $0x0,%esi
  802897:	b8 12 00 00 00       	mov    $0x12,%eax
  80289c:	8b 7d 14             	mov    0x14(%ebp),%edi
  80289f:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8028a2:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8028a5:	8b 55 08             	mov    0x8(%ebp),%edx
  8028a8:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
	
	if(check && ret > 0)
  8028aa:	85 c0                	test   %eax,%eax
  8028ac:	7e 28                	jle    8028d6 <sys_page_insert+0x53>
		panic("syscall %d returned %d (> 0)", num, ret);
  8028ae:	89 44 24 10          	mov    %eax,0x10(%esp)
  8028b2:	c7 44 24 0c 12 00 00 	movl   $0x12,0xc(%esp)
  8028b9:	00 
  8028ba:	c7 44 24 08 1f 4d 80 	movl   $0x804d1f,0x8(%esp)
  8028c1:	00 
  8028c2:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  8028c9:	00 
  8028ca:	c7 04 24 3c 4d 80 00 	movl   $0x804d3c,(%esp)
  8028d1:	e8 fa f3 ff ff       	call   801cd0 <_panic>
}
int
sys_page_insert(envid_t envid, void *va, struct Page *p, int perm)
{
	return syscall(SYS_page_insert, 1, envid, (uint32_t) va, (uint32_t)p, perm, 0);
}
  8028d6:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  8028d9:	8b 75 f8             	mov    -0x8(%ebp),%esi
  8028dc:	8b 7d fc             	mov    -0x4(%ebp),%edi
  8028df:	89 ec                	mov    %ebp,%esp
  8028e1:	5d                   	pop    %ebp
  8028e2:	c3                   	ret    

008028e3 <sys_page_waste>:
{
	return (int)syscall(SYS_receive_packet, 0, (uint32_t)buffer, 0,0,0,0);
}

int sys_page_waste(struct Page **p, int n)
{
  8028e3:	55                   	push   %ebp
  8028e4:	89 e5                	mov    %esp,%ebp
  8028e6:	83 ec 0c             	sub    $0xc,%esp
  8028e9:	89 1c 24             	mov    %ebx,(%esp)
  8028ec:	89 74 24 04          	mov    %esi,0x4(%esp)
  8028f0:	89 7c 24 08          	mov    %edi,0x8(%esp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8028f4:	bb 00 00 00 00       	mov    $0x0,%ebx
  8028f9:	b8 11 00 00 00       	mov    $0x11,%eax
  8028fe:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  802901:	8b 55 08             	mov    0x8(%ebp),%edx
  802904:	89 df                	mov    %ebx,%edi
  802906:	89 de                	mov    %ebx,%esi
  802908:	cd 30                	int    $0x30
}

int sys_page_waste(struct Page **p, int n)
{
	return syscall(SYS_page_waste, 0, (uint32_t)p, (uint32_t)n, 0, 0,0);
}
  80290a:	8b 1c 24             	mov    (%esp),%ebx
  80290d:	8b 74 24 04          	mov    0x4(%esp),%esi
  802911:	8b 7c 24 08          	mov    0x8(%esp),%edi
  802915:	89 ec                	mov    %ebp,%esp
  802917:	5d                   	pop    %ebp
  802918:	c3                   	ret    

00802919 <sys_receive_packet>:
{
	return (int)syscall(SYS_transmit_packet, 1, (uint32_t)data, len, 0,0,0);
}

int sys_receive_packet(void* buffer)
{
  802919:	55                   	push   %ebp
  80291a:	89 e5                	mov    %esp,%ebp
  80291c:	83 ec 0c             	sub    $0xc,%esp
  80291f:	89 1c 24             	mov    %ebx,(%esp)
  802922:	89 74 24 04          	mov    %esi,0x4(%esp)
  802926:	89 7c 24 08          	mov    %edi,0x8(%esp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80292a:	b9 00 00 00 00       	mov    $0x0,%ecx
  80292f:	b8 10 00 00 00       	mov    $0x10,%eax
  802934:	8b 55 08             	mov    0x8(%ebp),%edx
  802937:	89 cb                	mov    %ecx,%ebx
  802939:	89 cf                	mov    %ecx,%edi
  80293b:	89 ce                	mov    %ecx,%esi
  80293d:	cd 30                	int    $0x30
}

int sys_receive_packet(void* buffer)
{
	return (int)syscall(SYS_receive_packet, 0, (uint32_t)buffer, 0,0,0,0);
}
  80293f:	8b 1c 24             	mov    (%esp),%ebx
  802942:	8b 74 24 04          	mov    0x4(%esp),%esi
  802946:	8b 7c 24 08          	mov    0x8(%esp),%edi
  80294a:	89 ec                	mov    %ebp,%esp
  80294c:	5d                   	pop    %ebp
  80294d:	c3                   	ret    

0080294e <sys_transmit_packet>:
{
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0,0);
}

int sys_transmit_packet(void* data, uint32_t len)
{
  80294e:	55                   	push   %ebp
  80294f:	89 e5                	mov    %esp,%ebp
  802951:	83 ec 38             	sub    $0x38,%esp
  802954:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  802957:	89 75 f8             	mov    %esi,-0x8(%ebp)
  80295a:	89 7d fc             	mov    %edi,-0x4(%ebp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80295d:	bb 00 00 00 00       	mov    $0x0,%ebx
  802962:	b8 0f 00 00 00       	mov    $0xf,%eax
  802967:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80296a:	8b 55 08             	mov    0x8(%ebp),%edx
  80296d:	89 df                	mov    %ebx,%edi
  80296f:	89 de                	mov    %ebx,%esi
  802971:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
	
	if(check && ret > 0)
  802973:	85 c0                	test   %eax,%eax
  802975:	7e 28                	jle    80299f <sys_transmit_packet+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  802977:	89 44 24 10          	mov    %eax,0x10(%esp)
  80297b:	c7 44 24 0c 0f 00 00 	movl   $0xf,0xc(%esp)
  802982:	00 
  802983:	c7 44 24 08 1f 4d 80 	movl   $0x804d1f,0x8(%esp)
  80298a:	00 
  80298b:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  802992:	00 
  802993:	c7 04 24 3c 4d 80 00 	movl   $0x804d3c,(%esp)
  80299a:	e8 31 f3 ff ff       	call   801cd0 <_panic>
}

int sys_transmit_packet(void* data, uint32_t len)
{
	return (int)syscall(SYS_transmit_packet, 1, (uint32_t)data, len, 0,0,0);
}
  80299f:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  8029a2:	8b 75 f8             	mov    -0x8(%ebp),%esi
  8029a5:	8b 7d fc             	mov    -0x4(%ebp),%edi
  8029a8:	89 ec                	mov    %ebp,%esp
  8029aa:	5d                   	pop    %ebp
  8029ab:	c3                   	ret    

008029ac <sys_time_msec>:
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}

unsigned int
sys_time_msec(void)
{
  8029ac:	55                   	push   %ebp
  8029ad:	89 e5                	mov    %esp,%ebp
  8029af:	83 ec 0c             	sub    $0xc,%esp
  8029b2:	89 1c 24             	mov    %ebx,(%esp)
  8029b5:	89 74 24 04          	mov    %esi,0x4(%esp)
  8029b9:	89 7c 24 08          	mov    %edi,0x8(%esp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8029bd:	ba 00 00 00 00       	mov    $0x0,%edx
  8029c2:	b8 0e 00 00 00       	mov    $0xe,%eax
  8029c7:	89 d1                	mov    %edx,%ecx
  8029c9:	89 d3                	mov    %edx,%ebx
  8029cb:	89 d7                	mov    %edx,%edi
  8029cd:	89 d6                	mov    %edx,%esi
  8029cf:	cd 30                	int    $0x30

unsigned int
sys_time_msec(void)
{
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0,0);
}
  8029d1:	8b 1c 24             	mov    (%esp),%ebx
  8029d4:	8b 74 24 04          	mov    0x4(%esp),%esi
  8029d8:	8b 7c 24 08          	mov    0x8(%esp),%edi
  8029dc:	89 ec                	mov    %ebp,%esp
  8029de:	5d                   	pop    %ebp
  8029df:	c3                   	ret    

008029e0 <sys_ipc_recv>:
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}

int
sys_ipc_recv(void *dstva)
{
  8029e0:	55                   	push   %ebp
  8029e1:	89 e5                	mov    %esp,%ebp
  8029e3:	83 ec 38             	sub    $0x38,%esp
  8029e6:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  8029e9:	89 75 f8             	mov    %esi,-0x8(%ebp)
  8029ec:	89 7d fc             	mov    %edi,-0x4(%ebp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8029ef:	b9 00 00 00 00       	mov    $0x0,%ecx
  8029f4:	b8 0d 00 00 00       	mov    $0xd,%eax
  8029f9:	8b 55 08             	mov    0x8(%ebp),%edx
  8029fc:	89 cb                	mov    %ecx,%ebx
  8029fe:	89 cf                	mov    %ecx,%edi
  802a00:	89 ce                	mov    %ecx,%esi
  802a02:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
	
	if(check && ret > 0)
  802a04:	85 c0                	test   %eax,%eax
  802a06:	7e 28                	jle    802a30 <sys_ipc_recv+0x50>
		panic("syscall %d returned %d (> 0)", num, ret);
  802a08:	89 44 24 10          	mov    %eax,0x10(%esp)
  802a0c:	c7 44 24 0c 0d 00 00 	movl   $0xd,0xc(%esp)
  802a13:	00 
  802a14:	c7 44 24 08 1f 4d 80 	movl   $0x804d1f,0x8(%esp)
  802a1b:	00 
  802a1c:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  802a23:	00 
  802a24:	c7 04 24 3c 4d 80 00 	movl   $0x804d3c,(%esp)
  802a2b:	e8 a0 f2 ff ff       	call   801cd0 <_panic>

int
sys_ipc_recv(void *dstva)
{
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  802a30:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  802a33:	8b 75 f8             	mov    -0x8(%ebp),%esi
  802a36:	8b 7d fc             	mov    -0x4(%ebp),%edi
  802a39:	89 ec                	mov    %ebp,%esp
  802a3b:	5d                   	pop    %ebp
  802a3c:	c3                   	ret    

00802a3d <sys_ipc_try_send>:
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  802a3d:	55                   	push   %ebp
  802a3e:	89 e5                	mov    %esp,%ebp
  802a40:	83 ec 0c             	sub    $0xc,%esp
  802a43:	89 1c 24             	mov    %ebx,(%esp)
  802a46:	89 74 24 04          	mov    %esi,0x4(%esp)
  802a4a:	89 7c 24 08          	mov    %edi,0x8(%esp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  802a4e:	be 00 00 00 00       	mov    $0x0,%esi
  802a53:	b8 0c 00 00 00       	mov    $0xc,%eax
  802a58:	8b 7d 14             	mov    0x14(%ebp),%edi
  802a5b:	8b 5d 10             	mov    0x10(%ebp),%ebx
  802a5e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  802a61:	8b 55 08             	mov    0x8(%ebp),%edx
  802a64:	cd 30                	int    $0x30

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  802a66:	8b 1c 24             	mov    (%esp),%ebx
  802a69:	8b 74 24 04          	mov    0x4(%esp),%esi
  802a6d:	8b 7c 24 08          	mov    0x8(%esp),%edi
  802a71:	89 ec                	mov    %ebp,%esp
  802a73:	5d                   	pop    %ebp
  802a74:	c3                   	ret    

00802a75 <sys_env_set_pgfault_upcall>:
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  802a75:	55                   	push   %ebp
  802a76:	89 e5                	mov    %esp,%ebp
  802a78:	83 ec 38             	sub    $0x38,%esp
  802a7b:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  802a7e:	89 75 f8             	mov    %esi,-0x8(%ebp)
  802a81:	89 7d fc             	mov    %edi,-0x4(%ebp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  802a84:	bb 00 00 00 00       	mov    $0x0,%ebx
  802a89:	b8 0a 00 00 00       	mov    $0xa,%eax
  802a8e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  802a91:	8b 55 08             	mov    0x8(%ebp),%edx
  802a94:	89 df                	mov    %ebx,%edi
  802a96:	89 de                	mov    %ebx,%esi
  802a98:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
	
	if(check && ret > 0)
  802a9a:	85 c0                	test   %eax,%eax
  802a9c:	7e 28                	jle    802ac6 <sys_env_set_pgfault_upcall+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  802a9e:	89 44 24 10          	mov    %eax,0x10(%esp)
  802aa2:	c7 44 24 0c 0a 00 00 	movl   $0xa,0xc(%esp)
  802aa9:	00 
  802aaa:	c7 44 24 08 1f 4d 80 	movl   $0x804d1f,0x8(%esp)
  802ab1:	00 
  802ab2:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  802ab9:	00 
  802aba:	c7 04 24 3c 4d 80 00 	movl   $0x804d3c,(%esp)
  802ac1:	e8 0a f2 ff ff       	call   801cd0 <_panic>

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  802ac6:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  802ac9:	8b 75 f8             	mov    -0x8(%ebp),%esi
  802acc:	8b 7d fc             	mov    -0x4(%ebp),%edi
  802acf:	89 ec                	mov    %ebp,%esp
  802ad1:	5d                   	pop    %ebp
  802ad2:	c3                   	ret    

00802ad3 <sys_env_set_trapframe>:
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  802ad3:	55                   	push   %ebp
  802ad4:	89 e5                	mov    %esp,%ebp
  802ad6:	83 ec 38             	sub    $0x38,%esp
  802ad9:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  802adc:	89 75 f8             	mov    %esi,-0x8(%ebp)
  802adf:	89 7d fc             	mov    %edi,-0x4(%ebp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  802ae2:	bb 00 00 00 00       	mov    $0x0,%ebx
  802ae7:	b8 09 00 00 00       	mov    $0x9,%eax
  802aec:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  802aef:	8b 55 08             	mov    0x8(%ebp),%edx
  802af2:	89 df                	mov    %ebx,%edi
  802af4:	89 de                	mov    %ebx,%esi
  802af6:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
	
	if(check && ret > 0)
  802af8:	85 c0                	test   %eax,%eax
  802afa:	7e 28                	jle    802b24 <sys_env_set_trapframe+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  802afc:	89 44 24 10          	mov    %eax,0x10(%esp)
  802b00:	c7 44 24 0c 09 00 00 	movl   $0x9,0xc(%esp)
  802b07:	00 
  802b08:	c7 44 24 08 1f 4d 80 	movl   $0x804d1f,0x8(%esp)
  802b0f:	00 
  802b10:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  802b17:	00 
  802b18:	c7 04 24 3c 4d 80 00 	movl   $0x804d3c,(%esp)
  802b1f:	e8 ac f1 ff ff       	call   801cd0 <_panic>

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  802b24:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  802b27:	8b 75 f8             	mov    -0x8(%ebp),%esi
  802b2a:	8b 7d fc             	mov    -0x4(%ebp),%edi
  802b2d:	89 ec                	mov    %ebp,%esp
  802b2f:	5d                   	pop    %ebp
  802b30:	c3                   	ret    

00802b31 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  802b31:	55                   	push   %ebp
  802b32:	89 e5                	mov    %esp,%ebp
  802b34:	83 ec 38             	sub    $0x38,%esp
  802b37:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  802b3a:	89 75 f8             	mov    %esi,-0x8(%ebp)
  802b3d:	89 7d fc             	mov    %edi,-0x4(%ebp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  802b40:	bb 00 00 00 00       	mov    $0x0,%ebx
  802b45:	b8 08 00 00 00       	mov    $0x8,%eax
  802b4a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  802b4d:	8b 55 08             	mov    0x8(%ebp),%edx
  802b50:	89 df                	mov    %ebx,%edi
  802b52:	89 de                	mov    %ebx,%esi
  802b54:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
	
	if(check && ret > 0)
  802b56:	85 c0                	test   %eax,%eax
  802b58:	7e 28                	jle    802b82 <sys_env_set_status+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  802b5a:	89 44 24 10          	mov    %eax,0x10(%esp)
  802b5e:	c7 44 24 0c 08 00 00 	movl   $0x8,0xc(%esp)
  802b65:	00 
  802b66:	c7 44 24 08 1f 4d 80 	movl   $0x804d1f,0x8(%esp)
  802b6d:	00 
  802b6e:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  802b75:	00 
  802b76:	c7 04 24 3c 4d 80 00 	movl   $0x804d3c,(%esp)
  802b7d:	e8 4e f1 ff ff       	call   801cd0 <_panic>

int
sys_env_set_status(envid_t envid, int status)
{
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  802b82:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  802b85:	8b 75 f8             	mov    -0x8(%ebp),%esi
  802b88:	8b 7d fc             	mov    -0x4(%ebp),%edi
  802b8b:	89 ec                	mov    %ebp,%esp
  802b8d:	5d                   	pop    %ebp
  802b8e:	c3                   	ret    

00802b8f <sys_page_unmap>:
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}

int
sys_page_unmap(envid_t envid, void *va)
{
  802b8f:	55                   	push   %ebp
  802b90:	89 e5                	mov    %esp,%ebp
  802b92:	83 ec 38             	sub    $0x38,%esp
  802b95:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  802b98:	89 75 f8             	mov    %esi,-0x8(%ebp)
  802b9b:	89 7d fc             	mov    %edi,-0x4(%ebp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  802b9e:	bb 00 00 00 00       	mov    $0x0,%ebx
  802ba3:	b8 06 00 00 00       	mov    $0x6,%eax
  802ba8:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  802bab:	8b 55 08             	mov    0x8(%ebp),%edx
  802bae:	89 df                	mov    %ebx,%edi
  802bb0:	89 de                	mov    %ebx,%esi
  802bb2:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
	
	if(check && ret > 0)
  802bb4:	85 c0                	test   %eax,%eax
  802bb6:	7e 28                	jle    802be0 <sys_page_unmap+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  802bb8:	89 44 24 10          	mov    %eax,0x10(%esp)
  802bbc:	c7 44 24 0c 06 00 00 	movl   $0x6,0xc(%esp)
  802bc3:	00 
  802bc4:	c7 44 24 08 1f 4d 80 	movl   $0x804d1f,0x8(%esp)
  802bcb:	00 
  802bcc:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  802bd3:	00 
  802bd4:	c7 04 24 3c 4d 80 00 	movl   $0x804d3c,(%esp)
  802bdb:	e8 f0 f0 ff ff       	call   801cd0 <_panic>

int
sys_page_unmap(envid_t envid, void *va)
{
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  802be0:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  802be3:	8b 75 f8             	mov    -0x8(%ebp),%esi
  802be6:	8b 7d fc             	mov    -0x4(%ebp),%edi
  802be9:	89 ec                	mov    %ebp,%esp
  802beb:	5d                   	pop    %ebp
  802bec:	c3                   	ret    

00802bed <sys_page_map>:
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  802bed:	55                   	push   %ebp
  802bee:	89 e5                	mov    %esp,%ebp
  802bf0:	83 ec 38             	sub    $0x38,%esp
  802bf3:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  802bf6:	89 75 f8             	mov    %esi,-0x8(%ebp)
  802bf9:	89 7d fc             	mov    %edi,-0x4(%ebp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  802bfc:	b8 05 00 00 00       	mov    $0x5,%eax
  802c01:	8b 75 18             	mov    0x18(%ebp),%esi
  802c04:	8b 7d 14             	mov    0x14(%ebp),%edi
  802c07:	8b 5d 10             	mov    0x10(%ebp),%ebx
  802c0a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  802c0d:	8b 55 08             	mov    0x8(%ebp),%edx
  802c10:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
	
	if(check && ret > 0)
  802c12:	85 c0                	test   %eax,%eax
  802c14:	7e 28                	jle    802c3e <sys_page_map+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  802c16:	89 44 24 10          	mov    %eax,0x10(%esp)
  802c1a:	c7 44 24 0c 05 00 00 	movl   $0x5,0xc(%esp)
  802c21:	00 
  802c22:	c7 44 24 08 1f 4d 80 	movl   $0x804d1f,0x8(%esp)
  802c29:	00 
  802c2a:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  802c31:	00 
  802c32:	c7 04 24 3c 4d 80 00 	movl   $0x804d3c,(%esp)
  802c39:	e8 92 f0 ff ff       	call   801cd0 <_panic>

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  802c3e:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  802c41:	8b 75 f8             	mov    -0x8(%ebp),%esi
  802c44:	8b 7d fc             	mov    -0x4(%ebp),%edi
  802c47:	89 ec                	mov    %ebp,%esp
  802c49:	5d                   	pop    %ebp
  802c4a:	c3                   	ret    

00802c4b <sys_page_alloc>:
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  802c4b:	55                   	push   %ebp
  802c4c:	89 e5                	mov    %esp,%ebp
  802c4e:	83 ec 38             	sub    $0x38,%esp
  802c51:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  802c54:	89 75 f8             	mov    %esi,-0x8(%ebp)
  802c57:	89 7d fc             	mov    %edi,-0x4(%ebp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  802c5a:	be 00 00 00 00       	mov    $0x0,%esi
  802c5f:	b8 04 00 00 00       	mov    $0x4,%eax
  802c64:	8b 5d 10             	mov    0x10(%ebp),%ebx
  802c67:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  802c6a:	8b 55 08             	mov    0x8(%ebp),%edx
  802c6d:	89 f7                	mov    %esi,%edi
  802c6f:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
	
	if(check && ret > 0)
  802c71:	85 c0                	test   %eax,%eax
  802c73:	7e 28                	jle    802c9d <sys_page_alloc+0x52>
		panic("syscall %d returned %d (> 0)", num, ret);
  802c75:	89 44 24 10          	mov    %eax,0x10(%esp)
  802c79:	c7 44 24 0c 04 00 00 	movl   $0x4,0xc(%esp)
  802c80:	00 
  802c81:	c7 44 24 08 1f 4d 80 	movl   $0x804d1f,0x8(%esp)
  802c88:	00 
  802c89:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  802c90:	00 
  802c91:	c7 04 24 3c 4d 80 00 	movl   $0x804d3c,(%esp)
  802c98:	e8 33 f0 ff ff       	call   801cd0 <_panic>

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  802c9d:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  802ca0:	8b 75 f8             	mov    -0x8(%ebp),%esi
  802ca3:	8b 7d fc             	mov    -0x4(%ebp),%edi
  802ca6:	89 ec                	mov    %ebp,%esp
  802ca8:	5d                   	pop    %ebp
  802ca9:	c3                   	ret    

00802caa <sys_yield>:
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}

void
sys_yield(void)
{
  802caa:	55                   	push   %ebp
  802cab:	89 e5                	mov    %esp,%ebp
  802cad:	83 ec 0c             	sub    $0xc,%esp
  802cb0:	89 1c 24             	mov    %ebx,(%esp)
  802cb3:	89 74 24 04          	mov    %esi,0x4(%esp)
  802cb7:	89 7c 24 08          	mov    %edi,0x8(%esp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  802cbb:	ba 00 00 00 00       	mov    $0x0,%edx
  802cc0:	b8 0b 00 00 00       	mov    $0xb,%eax
  802cc5:	89 d1                	mov    %edx,%ecx
  802cc7:	89 d3                	mov    %edx,%ebx
  802cc9:	89 d7                	mov    %edx,%edi
  802ccb:	89 d6                	mov    %edx,%esi
  802ccd:	cd 30                	int    $0x30

void
sys_yield(void)
{
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  802ccf:	8b 1c 24             	mov    (%esp),%ebx
  802cd2:	8b 74 24 04          	mov    0x4(%esp),%esi
  802cd6:	8b 7c 24 08          	mov    0x8(%esp),%edi
  802cda:	89 ec                	mov    %ebp,%esp
  802cdc:	5d                   	pop    %ebp
  802cdd:	c3                   	ret    

00802cde <sys_getenvid>:
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}

envid_t
sys_getenvid(void)
{
  802cde:	55                   	push   %ebp
  802cdf:	89 e5                	mov    %esp,%ebp
  802ce1:	83 ec 0c             	sub    $0xc,%esp
  802ce4:	89 1c 24             	mov    %ebx,(%esp)
  802ce7:	89 74 24 04          	mov    %esi,0x4(%esp)
  802ceb:	89 7c 24 08          	mov    %edi,0x8(%esp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  802cef:	ba 00 00 00 00       	mov    $0x0,%edx
  802cf4:	b8 02 00 00 00       	mov    $0x2,%eax
  802cf9:	89 d1                	mov    %edx,%ecx
  802cfb:	89 d3                	mov    %edx,%ebx
  802cfd:	89 d7                	mov    %edx,%edi
  802cff:	89 d6                	mov    %edx,%esi
  802d01:	cd 30                	int    $0x30

envid_t
sys_getenvid(void)
{
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  802d03:	8b 1c 24             	mov    (%esp),%ebx
  802d06:	8b 74 24 04          	mov    0x4(%esp),%esi
  802d0a:	8b 7c 24 08          	mov    0x8(%esp),%edi
  802d0e:	89 ec                	mov    %ebp,%esp
  802d10:	5d                   	pop    %ebp
  802d11:	c3                   	ret    

00802d12 <sys_env_destroy>:
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}

int
sys_env_destroy(envid_t envid)
{
  802d12:	55                   	push   %ebp
  802d13:	89 e5                	mov    %esp,%ebp
  802d15:	83 ec 38             	sub    $0x38,%esp
  802d18:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  802d1b:	89 75 f8             	mov    %esi,-0x8(%ebp)
  802d1e:	89 7d fc             	mov    %edi,-0x4(%ebp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  802d21:	b9 00 00 00 00       	mov    $0x0,%ecx
  802d26:	b8 03 00 00 00       	mov    $0x3,%eax
  802d2b:	8b 55 08             	mov    0x8(%ebp),%edx
  802d2e:	89 cb                	mov    %ecx,%ebx
  802d30:	89 cf                	mov    %ecx,%edi
  802d32:	89 ce                	mov    %ecx,%esi
  802d34:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
	
	if(check && ret > 0)
  802d36:	85 c0                	test   %eax,%eax
  802d38:	7e 28                	jle    802d62 <sys_env_destroy+0x50>
		panic("syscall %d returned %d (> 0)", num, ret);
  802d3a:	89 44 24 10          	mov    %eax,0x10(%esp)
  802d3e:	c7 44 24 0c 03 00 00 	movl   $0x3,0xc(%esp)
  802d45:	00 
  802d46:	c7 44 24 08 1f 4d 80 	movl   $0x804d1f,0x8(%esp)
  802d4d:	00 
  802d4e:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  802d55:	00 
  802d56:	c7 04 24 3c 4d 80 00 	movl   $0x804d3c,(%esp)
  802d5d:	e8 6e ef ff ff       	call   801cd0 <_panic>

int
sys_env_destroy(envid_t envid)
{
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  802d62:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  802d65:	8b 75 f8             	mov    -0x8(%ebp),%esi
  802d68:	8b 7d fc             	mov    -0x4(%ebp),%edi
  802d6b:	89 ec                	mov    %ebp,%esp
  802d6d:	5d                   	pop    %ebp
  802d6e:	c3                   	ret    
	...

00802d70 <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  802d70:	55                   	push   %ebp
  802d71:	89 e5                	mov    %esp,%ebp
  802d73:	83 ec 18             	sub    $0x18,%esp
	int r;

	if (_pgfault_handler == 0) {
  802d76:	83 3d e8 c0 80 00 00 	cmpl   $0x0,0x80c0e8
  802d7d:	75 78                	jne    802df7 <set_pgfault_handler+0x87>
		// First time through!
		// LAB 4: Your code here.
		// panic("set_pgfault_handler not implemented");
		int ret;	
		if ((ret = sys_page_alloc(0, (void*)(UXSTACKTOP - PGSIZE), PTE_U | PTE_P | PTE_W)) < 0)
  802d7f:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  802d86:	00 
  802d87:	c7 44 24 04 00 f0 bf 	movl   $0xeebff000,0x4(%esp)
  802d8e:	ee 
  802d8f:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802d96:	e8 b0 fe ff ff       	call   802c4b <sys_page_alloc>
  802d9b:	85 c0                	test   %eax,%eax
  802d9d:	79 20                	jns    802dbf <set_pgfault_handler+0x4f>
			panic (" error in sys_page_alloc: %e\n", ret);
  802d9f:	89 44 24 0c          	mov    %eax,0xc(%esp)
  802da3:	c7 44 24 08 4a 4d 80 	movl   $0x804d4a,0x8(%esp)
  802daa:	00 
  802dab:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  802db2:	00 
  802db3:	c7 04 24 68 4d 80 00 	movl   $0x804d68,(%esp)
  802dba:	e8 11 ef ff ff       	call   801cd0 <_panic>
		if ((ret = sys_env_set_pgfault_upcall(0, _pgfault_upcall)) < 0)
  802dbf:	c7 44 24 04 04 2e 80 	movl   $0x802e04,0x4(%esp)
  802dc6:	00 
  802dc7:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802dce:	e8 a2 fc ff ff       	call   802a75 <sys_env_set_pgfault_upcall>
  802dd3:	85 c0                	test   %eax,%eax
  802dd5:	79 20                	jns    802df7 <set_pgfault_handler+0x87>
			panic (" error in sys_env_set_pgfault_upcall: %e\n", ret);
  802dd7:	89 44 24 0c          	mov    %eax,0xc(%esp)
  802ddb:	c7 44 24 08 78 4d 80 	movl   $0x804d78,0x8(%esp)
  802de2:	00 
  802de3:	c7 44 24 04 25 00 00 	movl   $0x25,0x4(%esp)
  802dea:	00 
  802deb:	c7 04 24 68 4d 80 00 	movl   $0x804d68,(%esp)
  802df2:	e8 d9 ee ff ff       	call   801cd0 <_panic>
	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  802df7:	8b 45 08             	mov    0x8(%ebp),%eax
  802dfa:	a3 e8 c0 80 00       	mov    %eax,0x80c0e8
	
}
  802dff:	c9                   	leave  
  802e00:	c3                   	ret    
  802e01:	00 00                	add    %al,(%eax)
	...

00802e04 <_pgfault_upcall>:

.text
.globl _pgfault_upcall
_pgfault_upcall:
	// Call the C page fault handler.
	pushl %esp			// function argument: pointer to UTF
  802e04:	54                   	push   %esp
	movl _pgfault_handler, %eax
  802e05:	a1 e8 c0 80 00       	mov    0x80c0e8,%eax
	call *%eax
  802e0a:	ff d0                	call   *%eax
	addl $4, %esp			// pop function argument
  802e0c:	83 c4 04             	add    $0x4,%esp
	// may find that you have to rearrange your code in non-obvious
	// ways as registers become unavailable as scratch space.
	//
	// LAB 4: Your code here.
	
	movl %esp, %ecx			// back up esp to ecx
  802e0f:	89 e1                	mov    %esp,%ecx
	movl 0x28(%esp), %ebx		// store trap-time eip into ebx
  802e11:	8b 5c 24 28          	mov    0x28(%esp),%ebx
	movl 0x30(%esp), %edx		// store trap-time esp into edx
  802e15:	8b 54 24 30          	mov    0x30(%esp),%edx
	movl %edx, %esp			// switch to trap-time stack
  802e19:	89 d4                	mov    %edx,%esp
	pushl %ebx			// push trap-time eip here
  802e1b:	53                   	push   %ebx
	movl %ecx, %esp			// come back to user exception stack
  802e1c:	89 cc                	mov    %ecx,%esp
	
	// for the push made above, update the trap-time esp value in this user exception stack
	// this enables popl %esp to cause esp point to the adjusted trap-time stack 
	subl $0x4, %edx			
  802e1e:	83 ea 04             	sub    $0x4,%edx
	movl %edx, 0x30(%esp)
  802e21:	89 54 24 30          	mov    %edx,0x30(%esp)
	

	// Restore the trap-time registers.  After you do this, you
	// can no longer modify any general-purpose registers.
	// LAB 4: Your code here.
	addl $0x8, %esp
  802e25:	83 c4 08             	add    $0x8,%esp
	popal
  802e28:	61                   	popa   
	// Restore eflags from the stack.  After you do this, you can
	// no longer use arithmetic operations or anything else that
	// modifies eflags.
	// LAB 4: Your code here.
	
	addl $0x4, %esp
  802e29:	83 c4 04             	add    $0x4,%esp
	popfl
  802e2c:	9d                   	popf   

	// Switch back to the adjusted trap-time stack.
	// LAB 4: Your code here.

	popl %esp
  802e2d:	5c                   	pop    %esp

	// Return to re-execute the instruction that faulted.
	// LAB 4: Your code here.
	
	ret
  802e2e:	c3                   	ret    
	...

00802e30 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  802e30:	55                   	push   %ebp
  802e31:	89 e5                	mov    %esp,%ebp
  802e33:	57                   	push   %edi
  802e34:	56                   	push   %esi
  802e35:	53                   	push   %ebx
  802e36:	83 ec 1c             	sub    $0x1c,%esp
  802e39:	8b 7d 0c             	mov    0xc(%ebp),%edi
  802e3c:	8b 5d 10             	mov    0x10(%ebp),%ebx
  802e3f:	8b 75 14             	mov    0x14(%ebp),%esi
	// LAB 4: Your code here.
	int r;
	if (pg == NULL)
  802e42:	85 db                	test   %ebx,%ebx
  802e44:	75 2d                	jne    802e73 <ipc_send+0x43>
  802e46:	bb 00 00 c0 ee       	mov    $0xeec00000,%ebx
  802e4b:	eb 26                	jmp    802e73 <ipc_send+0x43>
		pg = (void*)UTOP;
	while ((r = sys_ipc_try_send(to_env, val, pg, perm)) < 0)
	{
		if(r != -E_IPC_NOT_RECV)
  802e4d:	83 f8 f9             	cmp    $0xfffffff9,%eax
  802e50:	74 1c                	je     802e6e <ipc_send+0x3e>
			panic("Panic in lib ipc.c : ipc_send() \n");
  802e52:	c7 44 24 08 a4 4d 80 	movl   $0x804da4,0x8(%esp)
  802e59:	00 
  802e5a:	c7 44 24 04 44 00 00 	movl   $0x44,0x4(%esp)
  802e61:	00 
  802e62:	c7 04 24 c6 4d 80 00 	movl   $0x804dc6,(%esp)
  802e69:	e8 62 ee ff ff       	call   801cd0 <_panic>
		sys_yield();
  802e6e:	e8 37 fe ff ff       	call   802caa <sys_yield>
{
	// LAB 4: Your code here.
	int r;
	if (pg == NULL)
		pg = (void*)UTOP;
	while ((r = sys_ipc_try_send(to_env, val, pg, perm)) < 0)
  802e73:	89 74 24 0c          	mov    %esi,0xc(%esp)
  802e77:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  802e7b:	89 7c 24 04          	mov    %edi,0x4(%esp)
  802e7f:	8b 45 08             	mov    0x8(%ebp),%eax
  802e82:	89 04 24             	mov    %eax,(%esp)
  802e85:	e8 b3 fb ff ff       	call   802a3d <sys_ipc_try_send>
  802e8a:	85 c0                	test   %eax,%eax
  802e8c:	78 bf                	js     802e4d <ipc_send+0x1d>
		if(r != -E_IPC_NOT_RECV)
			panic("Panic in lib ipc.c : ipc_send() \n");
		sys_yield();
	}
	//panic("ipc_send not implemented");
}
  802e8e:	83 c4 1c             	add    $0x1c,%esp
  802e91:	5b                   	pop    %ebx
  802e92:	5e                   	pop    %esi
  802e93:	5f                   	pop    %edi
  802e94:	5d                   	pop    %ebp
  802e95:	c3                   	ret    

00802e96 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  802e96:	55                   	push   %ebp
  802e97:	89 e5                	mov    %esp,%ebp
  802e99:	56                   	push   %esi
  802e9a:	53                   	push   %ebx
  802e9b:	83 ec 10             	sub    $0x10,%esp
  802e9e:	8b 5d 08             	mov    0x8(%ebp),%ebx
  802ea1:	8b 45 0c             	mov    0xc(%ebp),%eax
  802ea4:	8b 75 10             	mov    0x10(%ebp),%esi
	// LAB 4: Your code here.
	int r;

	if (pg == NULL)
  802ea7:	85 c0                	test   %eax,%eax
  802ea9:	75 05                	jne    802eb0 <ipc_recv+0x1a>
  802eab:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
		pg = (void*)UTOP;
	if ((r = sys_ipc_recv(pg)) < 0)
  802eb0:	89 04 24             	mov    %eax,(%esp)
  802eb3:	e8 28 fb ff ff       	call   8029e0 <sys_ipc_recv>
  802eb8:	85 c0                	test   %eax,%eax
  802eba:	79 16                	jns    802ed2 <ipc_recv+0x3c>
	{
		if (from_env_store != NULL)
  802ebc:	85 db                	test   %ebx,%ebx
  802ebe:	74 06                	je     802ec6 <ipc_recv+0x30>
			*from_env_store = 0;
  802ec0:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
		if(perm_store != NULL)
  802ec6:	85 f6                	test   %esi,%esi
  802ec8:	74 2c                	je     802ef6 <ipc_recv+0x60>
			*perm_store = 0;
  802eca:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
  802ed0:	eb 24                	jmp    802ef6 <ipc_recv+0x60>
		return r;
	}
	else
	{	
		if (from_env_store != NULL)
  802ed2:	85 db                	test   %ebx,%ebx
  802ed4:	74 0a                	je     802ee0 <ipc_recv+0x4a>
			*from_env_store = env->env_ipc_from;
  802ed6:	a1 e0 c0 80 00       	mov    0x80c0e0,%eax
  802edb:	8b 40 74             	mov    0x74(%eax),%eax
  802ede:	89 03                	mov    %eax,(%ebx)
		if(perm_store != NULL)
  802ee0:	85 f6                	test   %esi,%esi
  802ee2:	74 0a                	je     802eee <ipc_recv+0x58>
			*perm_store = env->env_ipc_perm;
  802ee4:	a1 e0 c0 80 00       	mov    0x80c0e0,%eax
  802ee9:	8b 40 78             	mov    0x78(%eax),%eax
  802eec:	89 06                	mov    %eax,(%esi)
		return env->env_ipc_value;
  802eee:	a1 e0 c0 80 00       	mov    0x80c0e0,%eax
  802ef3:	8b 40 70             	mov    0x70(%eax),%eax
	}		
	//panic("ipc_recv not implemented");
	//return 0;
}
  802ef6:	83 c4 10             	add    $0x10,%esp
  802ef9:	5b                   	pop    %ebx
  802efa:	5e                   	pop    %esi
  802efb:	5d                   	pop    %ebp
  802efc:	c3                   	ret    
  802efd:	00 00                	add    %al,(%eax)
	...

00802f00 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  802f00:	55                   	push   %ebp
  802f01:	89 e5                	mov    %esp,%ebp
  802f03:	8b 45 08             	mov    0x8(%ebp),%eax
  802f06:	05 00 00 00 30       	add    $0x30000000,%eax
  802f0b:	c1 e8 0c             	shr    $0xc,%eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
}
  802f0e:	5d                   	pop    %ebp
  802f0f:	c3                   	ret    

00802f10 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  802f10:	55                   	push   %ebp
  802f11:	89 e5                	mov    %esp,%ebp
  802f13:	83 ec 04             	sub    $0x4,%esp
	return INDEX2DATA(fd2num(fd));
  802f16:	8b 45 08             	mov    0x8(%ebp),%eax
  802f19:	89 04 24             	mov    %eax,(%esp)
  802f1c:	e8 df ff ff ff       	call   802f00 <fd2num>
  802f21:	05 20 00 0d 00       	add    $0xd0020,%eax
  802f26:	c1 e0 0c             	shl    $0xc,%eax
}
  802f29:	c9                   	leave  
  802f2a:	c3                   	ret    

00802f2b <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  802f2b:	55                   	push   %ebp
  802f2c:	89 e5                	mov    %esp,%ebp
  802f2e:	57                   	push   %edi
  802f2f:	56                   	push   %esi
  802f30:	53                   	push   %ebx
  802f31:	8b 7d 08             	mov    0x8(%ebp),%edi
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((vpd[PDX(fd)] & PTE_P) == 0 || (vpt[VPN(fd)] & PTE_P) == 0) {
  802f34:	a1 00 dd 7b ef       	mov    0xef7bdd00,%eax
  802f39:	a8 01                	test   $0x1,%al
  802f3b:	74 36                	je     802f73 <fd_alloc+0x48>
  802f3d:	a1 00 00 74 ef       	mov    0xef740000,%eax
  802f42:	a8 01                	test   $0x1,%al
  802f44:	74 2d                	je     802f73 <fd_alloc+0x48>
  802f46:	b8 00 10 00 d0       	mov    $0xd0001000,%eax
  802f4b:	b9 00 d0 7b ef       	mov    $0xef7bd000,%ecx
  802f50:	be 00 00 40 ef       	mov    $0xef400000,%esi
  802f55:	89 c3                	mov    %eax,%ebx
  802f57:	89 c2                	mov    %eax,%edx
  802f59:	c1 ea 16             	shr    $0x16,%edx
  802f5c:	8b 14 91             	mov    (%ecx,%edx,4),%edx
  802f5f:	f6 c2 01             	test   $0x1,%dl
  802f62:	74 14                	je     802f78 <fd_alloc+0x4d>
  802f64:	89 c2                	mov    %eax,%edx
  802f66:	c1 ea 0c             	shr    $0xc,%edx
  802f69:	8b 14 96             	mov    (%esi,%edx,4),%edx
  802f6c:	f6 c2 01             	test   $0x1,%dl
  802f6f:	75 10                	jne    802f81 <fd_alloc+0x56>
  802f71:	eb 05                	jmp    802f78 <fd_alloc+0x4d>
  802f73:	bb 00 00 00 d0       	mov    $0xd0000000,%ebx
			*fd_store = fd;
  802f78:	89 1f                	mov    %ebx,(%edi)
  802f7a:	b8 00 00 00 00       	mov    $0x0,%eax
			return 0;
  802f7f:	eb 17                	jmp    802f98 <fd_alloc+0x6d>
  802f81:	05 00 10 00 00       	add    $0x1000,%eax
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  802f86:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  802f8b:	75 c8                	jne    802f55 <fd_alloc+0x2a>
		if ((vpd[PDX(fd)] & PTE_P) == 0 || (vpt[VPN(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  802f8d:	c7 07 00 00 00 00    	movl   $0x0,(%edi)
  802f93:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
	return -E_MAX_OPEN;
}
  802f98:	5b                   	pop    %ebx
  802f99:	5e                   	pop    %esi
  802f9a:	5f                   	pop    %edi
  802f9b:	5d                   	pop    %ebp
  802f9c:	c3                   	ret    

00802f9d <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  802f9d:	55                   	push   %ebp
  802f9e:	89 e5                	mov    %esp,%ebp
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  802fa0:	8b 45 08             	mov    0x8(%ebp),%eax
  802fa3:	83 f8 1f             	cmp    $0x1f,%eax
  802fa6:	77 36                	ja     802fde <fd_lookup+0x41>
		if (debug)
			cprintf("[%08x] bad fd %d\n", env->env_id, fd);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  802fa8:	05 00 00 0d 00       	add    $0xd0000,%eax
  802fad:	c1 e0 0c             	shl    $0xc,%eax
	if (!(vpd[PDX(fd)] & PTE_P) || !(vpt[VPN(fd)] & PTE_P)) {
  802fb0:	89 c2                	mov    %eax,%edx
  802fb2:	c1 ea 16             	shr    $0x16,%edx
  802fb5:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  802fbc:	f6 c2 01             	test   $0x1,%dl
  802fbf:	74 1d                	je     802fde <fd_lookup+0x41>
  802fc1:	89 c2                	mov    %eax,%edx
  802fc3:	c1 ea 0c             	shr    $0xc,%edx
  802fc6:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  802fcd:	f6 c2 01             	test   $0x1,%dl
  802fd0:	74 0c                	je     802fde <fd_lookup+0x41>
		if (debug)
			cprintf("[%08x] closed fd %d\n", env->env_id, fd);
		return -E_INVAL;
	}
	*fd_store = fd;
  802fd2:	8b 55 0c             	mov    0xc(%ebp),%edx
  802fd5:	89 02                	mov    %eax,(%edx)
  802fd7:	b8 00 00 00 00       	mov    $0x0,%eax
	return 0;
  802fdc:	eb 05                	jmp    802fe3 <fd_lookup+0x46>
  802fde:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  802fe3:	5d                   	pop    %ebp
  802fe4:	c3                   	ret    

00802fe5 <seek>:
	return (*dev->dev_write)(fd, buf, n);
}

int
seek(int fdnum, off_t offset)
{
  802fe5:	55                   	push   %ebp
  802fe6:	89 e5                	mov    %esp,%ebp
  802fe8:	83 ec 18             	sub    $0x18,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802feb:	8d 45 fc             	lea    -0x4(%ebp),%eax
  802fee:	89 44 24 04          	mov    %eax,0x4(%esp)
  802ff2:	8b 45 08             	mov    0x8(%ebp),%eax
  802ff5:	89 04 24             	mov    %eax,(%esp)
  802ff8:	e8 a0 ff ff ff       	call   802f9d <fd_lookup>
  802ffd:	85 c0                	test   %eax,%eax
  802fff:	78 0e                	js     80300f <seek+0x2a>
		return r;
	fd->fd_offset = offset;
  803001:	8b 45 fc             	mov    -0x4(%ebp),%eax
  803004:	8b 55 0c             	mov    0xc(%ebp),%edx
  803007:	89 50 04             	mov    %edx,0x4(%eax)
  80300a:	b8 00 00 00 00       	mov    $0x0,%eax
	return 0;
}
  80300f:	c9                   	leave  
  803010:	c3                   	ret    

00803011 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  803011:	55                   	push   %ebp
  803012:	89 e5                	mov    %esp,%ebp
  803014:	56                   	push   %esi
  803015:	53                   	push   %ebx
  803016:	83 ec 10             	sub    $0x10,%esp
  803019:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80301c:	8b 5d 0c             	mov    0xc(%ebp),%ebx
// File functions
// --------------------------------------------------------------

static struct Dev *devtab[] =
{
	&devfile,
  80301f:	b8 68 c0 80 00       	mov    $0x80c068,%eax
{
	int i;
	for (i = 0; devtab[i]; i++)
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
  803024:	ba 00 00 00 00       	mov    $0x0,%edx

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  803029:	be 50 4e 80 00       	mov    $0x804e50,%esi
		if (devtab[i]->dev_id == dev_id) {
  80302e:	39 08                	cmp    %ecx,(%eax)
  803030:	75 10                	jne    803042 <dev_lookup+0x31>
  803032:	eb 04                	jmp    803038 <dev_lookup+0x27>
  803034:	39 08                	cmp    %ecx,(%eax)
  803036:	75 0a                	jne    803042 <dev_lookup+0x31>
			*dev = devtab[i];
  803038:	89 03                	mov    %eax,(%ebx)
  80303a:	b8 00 00 00 00       	mov    $0x0,%eax
			return 0;
  80303f:	90                   	nop
  803040:	eb 31                	jmp    803073 <dev_lookup+0x62>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  803042:	83 c2 01             	add    $0x1,%edx
  803045:	8b 04 96             	mov    (%esi,%edx,4),%eax
  803048:	85 c0                	test   %eax,%eax
  80304a:	75 e8                	jne    803034 <dev_lookup+0x23>
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", env->env_id, dev_id);
  80304c:	a1 e0 c0 80 00       	mov    0x80c0e0,%eax
  803051:	8b 40 4c             	mov    0x4c(%eax),%eax
  803054:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  803058:	89 44 24 04          	mov    %eax,0x4(%esp)
  80305c:	c7 04 24 d0 4d 80 00 	movl   $0x804dd0,(%esp)
  803063:	e8 2d ed ff ff       	call   801d95 <cprintf>
	*dev = 0;
  803068:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  80306e:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
	return -E_INVAL;
}
  803073:	83 c4 10             	add    $0x10,%esp
  803076:	5b                   	pop    %ebx
  803077:	5e                   	pop    %esi
  803078:	5d                   	pop    %ebp
  803079:	c3                   	ret    

0080307a <fstat>:
	return (*dev->dev_trunc)(fd, newsize);
}

int
fstat(int fdnum, struct Stat *stat)
{
  80307a:	55                   	push   %ebp
  80307b:	89 e5                	mov    %esp,%ebp
  80307d:	53                   	push   %ebx
  80307e:	83 ec 24             	sub    $0x24,%esp
  803081:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  803084:	8d 45 f0             	lea    -0x10(%ebp),%eax
  803087:	89 44 24 04          	mov    %eax,0x4(%esp)
  80308b:	8b 45 08             	mov    0x8(%ebp),%eax
  80308e:	89 04 24             	mov    %eax,(%esp)
  803091:	e8 07 ff ff ff       	call   802f9d <fd_lookup>
  803096:	85 c0                	test   %eax,%eax
  803098:	78 53                	js     8030ed <fstat+0x73>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80309a:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80309d:	89 44 24 04          	mov    %eax,0x4(%esp)
  8030a1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8030a4:	8b 00                	mov    (%eax),%eax
  8030a6:	89 04 24             	mov    %eax,(%esp)
  8030a9:	e8 63 ff ff ff       	call   803011 <dev_lookup>
{
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8030ae:	85 c0                	test   %eax,%eax
  8030b0:	78 3b                	js     8030ed <fstat+0x73>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if (!dev->dev_stat)
  8030b2:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8030b7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8030ba:	83 7a 14 00          	cmpl   $0x0,0x14(%edx)
  8030be:	74 2d                	je     8030ed <fstat+0x73>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  8030c0:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  8030c3:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  8030ca:	00 00 00 
	stat->st_isdir = 0;
  8030cd:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  8030d4:	00 00 00 
	stat->st_dev = dev;
  8030d7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030da:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  8030e0:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8030e4:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8030e7:	89 14 24             	mov    %edx,(%esp)
  8030ea:	ff 50 14             	call   *0x14(%eax)
}
  8030ed:	83 c4 24             	add    $0x24,%esp
  8030f0:	5b                   	pop    %ebx
  8030f1:	5d                   	pop    %ebp
  8030f2:	c3                   	ret    

008030f3 <ftruncate>:
	return 0;
}

int
ftruncate(int fdnum, off_t newsize)
{
  8030f3:	55                   	push   %ebp
  8030f4:	89 e5                	mov    %esp,%ebp
  8030f6:	53                   	push   %ebx
  8030f7:	83 ec 24             	sub    $0x24,%esp
  8030fa:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  8030fd:	8d 45 f0             	lea    -0x10(%ebp),%eax
  803100:	89 44 24 04          	mov    %eax,0x4(%esp)
  803104:	89 1c 24             	mov    %ebx,(%esp)
  803107:	e8 91 fe ff ff       	call   802f9d <fd_lookup>
  80310c:	85 c0                	test   %eax,%eax
  80310e:	78 5f                	js     80316f <ftruncate+0x7c>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  803110:	8d 45 f4             	lea    -0xc(%ebp),%eax
  803113:	89 44 24 04          	mov    %eax,0x4(%esp)
  803117:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80311a:	8b 00                	mov    (%eax),%eax
  80311c:	89 04 24             	mov    %eax,(%esp)
  80311f:	e8 ed fe ff ff       	call   803011 <dev_lookup>
ftruncate(int fdnum, off_t newsize)
{
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  803124:	85 c0                	test   %eax,%eax
  803126:	78 47                	js     80316f <ftruncate+0x7c>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  803128:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80312b:	f6 42 08 03          	testb  $0x3,0x8(%edx)
  80312f:	75 23                	jne    803154 <ftruncate+0x61>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			env->env_id, fdnum); 
  803131:	a1 e0 c0 80 00       	mov    0x80c0e0,%eax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  803136:	8b 40 4c             	mov    0x4c(%eax),%eax
  803139:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80313d:	89 44 24 04          	mov    %eax,0x4(%esp)
  803141:	c7 04 24 f0 4d 80 00 	movl   $0x804df0,(%esp)
  803148:	e8 48 ec ff ff       	call   801d95 <cprintf>
  80314d:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
			env->env_id, fdnum); 
		return -E_INVAL;
  803152:	eb 1b                	jmp    80316f <ftruncate+0x7c>
	}
	if (!dev->dev_trunc)
  803154:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803157:	8b 48 18             	mov    0x18(%eax),%ecx
  80315a:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  80315f:	85 c9                	test   %ecx,%ecx
  803161:	74 0c                	je     80316f <ftruncate+0x7c>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  803163:	8b 45 0c             	mov    0xc(%ebp),%eax
  803166:	89 44 24 04          	mov    %eax,0x4(%esp)
  80316a:	89 14 24             	mov    %edx,(%esp)
  80316d:	ff d1                	call   *%ecx
}
  80316f:	83 c4 24             	add    $0x24,%esp
  803172:	5b                   	pop    %ebx
  803173:	5d                   	pop    %ebp
  803174:	c3                   	ret    

00803175 <write>:
	return tot;
}

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  803175:	55                   	push   %ebp
  803176:	89 e5                	mov    %esp,%ebp
  803178:	53                   	push   %ebx
  803179:	83 ec 24             	sub    $0x24,%esp
  80317c:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80317f:	8d 45 f0             	lea    -0x10(%ebp),%eax
  803182:	89 44 24 04          	mov    %eax,0x4(%esp)
  803186:	89 1c 24             	mov    %ebx,(%esp)
  803189:	e8 0f fe ff ff       	call   802f9d <fd_lookup>
  80318e:	85 c0                	test   %eax,%eax
  803190:	78 66                	js     8031f8 <write+0x83>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  803192:	8d 45 f4             	lea    -0xc(%ebp),%eax
  803195:	89 44 24 04          	mov    %eax,0x4(%esp)
  803199:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80319c:	8b 00                	mov    (%eax),%eax
  80319e:	89 04 24             	mov    %eax,(%esp)
  8031a1:	e8 6b fe ff ff       	call   803011 <dev_lookup>
{
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8031a6:	85 c0                	test   %eax,%eax
  8031a8:	78 4e                	js     8031f8 <write+0x83>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8031aa:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8031ad:	f6 42 08 03          	testb  $0x3,0x8(%edx)
  8031b1:	75 23                	jne    8031d6 <write+0x61>
		cprintf("[%08x] write %d -- bad mode\n", env->env_id, fdnum);
  8031b3:	a1 e0 c0 80 00       	mov    0x80c0e0,%eax
  8031b8:	8b 40 4c             	mov    0x4c(%eax),%eax
  8031bb:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8031bf:	89 44 24 04          	mov    %eax,0x4(%esp)
  8031c3:	c7 04 24 14 4e 80 00 	movl   $0x804e14,(%esp)
  8031ca:	e8 c6 eb ff ff       	call   801d95 <cprintf>
  8031cf:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
		return -E_INVAL;
  8031d4:	eb 22                	jmp    8031f8 <write+0x83>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  8031d6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031d9:	8b 48 0c             	mov    0xc(%eax),%ecx
  8031dc:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8031e1:	85 c9                	test   %ecx,%ecx
  8031e3:	74 13                	je     8031f8 <write+0x83>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  8031e5:	8b 45 10             	mov    0x10(%ebp),%eax
  8031e8:	89 44 24 08          	mov    %eax,0x8(%esp)
  8031ec:	8b 45 0c             	mov    0xc(%ebp),%eax
  8031ef:	89 44 24 04          	mov    %eax,0x4(%esp)
  8031f3:	89 14 24             	mov    %edx,(%esp)
  8031f6:	ff d1                	call   *%ecx
}
  8031f8:	83 c4 24             	add    $0x24,%esp
  8031fb:	5b                   	pop    %ebx
  8031fc:	5d                   	pop    %ebp
  8031fd:	c3                   	ret    

008031fe <read>:
	return r;
}

ssize_t
read(int fdnum, void *buf, size_t n)
{
  8031fe:	55                   	push   %ebp
  8031ff:	89 e5                	mov    %esp,%ebp
  803201:	53                   	push   %ebx
  803202:	83 ec 24             	sub    $0x24,%esp
  803205:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  803208:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80320b:	89 44 24 04          	mov    %eax,0x4(%esp)
  80320f:	89 1c 24             	mov    %ebx,(%esp)
  803212:	e8 86 fd ff ff       	call   802f9d <fd_lookup>
  803217:	85 c0                	test   %eax,%eax
  803219:	78 6b                	js     803286 <read+0x88>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80321b:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80321e:	89 44 24 04          	mov    %eax,0x4(%esp)
  803222:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803225:	8b 00                	mov    (%eax),%eax
  803227:	89 04 24             	mov    %eax,(%esp)
  80322a:	e8 e2 fd ff ff       	call   803011 <dev_lookup>
{
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80322f:	85 c0                	test   %eax,%eax
  803231:	78 53                	js     803286 <read+0x88>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  803233:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803236:	8b 42 08             	mov    0x8(%edx),%eax
  803239:	83 e0 03             	and    $0x3,%eax
  80323c:	83 f8 01             	cmp    $0x1,%eax
  80323f:	75 23                	jne    803264 <read+0x66>
		cprintf("[%08x] read %d -- bad mode\n", env->env_id, fdnum); 
  803241:	a1 e0 c0 80 00       	mov    0x80c0e0,%eax
  803246:	8b 40 4c             	mov    0x4c(%eax),%eax
  803249:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80324d:	89 44 24 04          	mov    %eax,0x4(%esp)
  803251:	c7 04 24 31 4e 80 00 	movl   $0x804e31,(%esp)
  803258:	e8 38 eb ff ff       	call   801d95 <cprintf>
  80325d:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
		return -E_INVAL;
  803262:	eb 22                	jmp    803286 <read+0x88>
	}
	if (!dev->dev_read)
  803264:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803267:	8b 48 08             	mov    0x8(%eax),%ecx
  80326a:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  80326f:	85 c9                	test   %ecx,%ecx
  803271:	74 13                	je     803286 <read+0x88>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  803273:	8b 45 10             	mov    0x10(%ebp),%eax
  803276:	89 44 24 08          	mov    %eax,0x8(%esp)
  80327a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80327d:	89 44 24 04          	mov    %eax,0x4(%esp)
  803281:	89 14 24             	mov    %edx,(%esp)
  803284:	ff d1                	call   *%ecx
}
  803286:	83 c4 24             	add    $0x24,%esp
  803289:	5b                   	pop    %ebx
  80328a:	5d                   	pop    %ebp
  80328b:	c3                   	ret    

0080328c <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  80328c:	55                   	push   %ebp
  80328d:	89 e5                	mov    %esp,%ebp
  80328f:	57                   	push   %edi
  803290:	56                   	push   %esi
  803291:	53                   	push   %ebx
  803292:	83 ec 1c             	sub    $0x1c,%esp
  803295:	8b 7d 08             	mov    0x8(%ebp),%edi
  803298:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  80329b:	ba 00 00 00 00       	mov    $0x0,%edx
  8032a0:	bb 00 00 00 00       	mov    $0x0,%ebx
  8032a5:	b8 00 00 00 00       	mov    $0x0,%eax
  8032aa:	85 f6                	test   %esi,%esi
  8032ac:	74 29                	je     8032d7 <readn+0x4b>
		m = read(fdnum, (char*)buf + tot, n - tot);
  8032ae:	89 f0                	mov    %esi,%eax
  8032b0:	29 d0                	sub    %edx,%eax
  8032b2:	89 44 24 08          	mov    %eax,0x8(%esp)
  8032b6:	03 55 0c             	add    0xc(%ebp),%edx
  8032b9:	89 54 24 04          	mov    %edx,0x4(%esp)
  8032bd:	89 3c 24             	mov    %edi,(%esp)
  8032c0:	e8 39 ff ff ff       	call   8031fe <read>
		if (m < 0)
  8032c5:	85 c0                	test   %eax,%eax
  8032c7:	78 0e                	js     8032d7 <readn+0x4b>
			return m;
		if (m == 0)
  8032c9:	85 c0                	test   %eax,%eax
  8032cb:	74 08                	je     8032d5 <readn+0x49>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  8032cd:	01 c3                	add    %eax,%ebx
  8032cf:	89 da                	mov    %ebx,%edx
  8032d1:	39 f3                	cmp    %esi,%ebx
  8032d3:	72 d9                	jb     8032ae <readn+0x22>
  8032d5:	89 d8                	mov    %ebx,%eax
			return m;
		if (m == 0)
			break;
	}
	return tot;
}
  8032d7:	83 c4 1c             	add    $0x1c,%esp
  8032da:	5b                   	pop    %ebx
  8032db:	5e                   	pop    %esi
  8032dc:	5f                   	pop    %edi
  8032dd:	5d                   	pop    %ebp
  8032de:	c3                   	ret    

008032df <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  8032df:	55                   	push   %ebp
  8032e0:	89 e5                	mov    %esp,%ebp
  8032e2:	56                   	push   %esi
  8032e3:	53                   	push   %ebx
  8032e4:	83 ec 20             	sub    $0x20,%esp
  8032e7:	8b 75 08             	mov    0x8(%ebp),%esi
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8032ea:	89 34 24             	mov    %esi,(%esp)
  8032ed:	e8 0e fc ff ff       	call   802f00 <fd2num>
  8032f2:	8d 55 f4             	lea    -0xc(%ebp),%edx
  8032f5:	89 54 24 04          	mov    %edx,0x4(%esp)
  8032f9:	89 04 24             	mov    %eax,(%esp)
  8032fc:	e8 9c fc ff ff       	call   802f9d <fd_lookup>
  803301:	89 c3                	mov    %eax,%ebx
  803303:	85 c0                	test   %eax,%eax
  803305:	78 05                	js     80330c <fd_close+0x2d>
  803307:	3b 75 f4             	cmp    -0xc(%ebp),%esi
  80330a:	74 0c                	je     803318 <fd_close+0x39>
	    || fd != fd2)
		return (must_exist ? r : 0);
  80330c:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  803310:	19 c0                	sbb    %eax,%eax
  803312:	f7 d0                	not    %eax
  803314:	21 c3                	and    %eax,%ebx
  803316:	eb 3d                	jmp    803355 <fd_close+0x76>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  803318:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80331b:	89 44 24 04          	mov    %eax,0x4(%esp)
  80331f:	8b 06                	mov    (%esi),%eax
  803321:	89 04 24             	mov    %eax,(%esp)
  803324:	e8 e8 fc ff ff       	call   803011 <dev_lookup>
  803329:	89 c3                	mov    %eax,%ebx
  80332b:	85 c0                	test   %eax,%eax
  80332d:	78 16                	js     803345 <fd_close+0x66>
		if (dev->dev_close)
  80332f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803332:	8b 40 10             	mov    0x10(%eax),%eax
  803335:	bb 00 00 00 00       	mov    $0x0,%ebx
  80333a:	85 c0                	test   %eax,%eax
  80333c:	74 07                	je     803345 <fd_close+0x66>
			r = (*dev->dev_close)(fd);
  80333e:	89 34 24             	mov    %esi,(%esp)
  803341:	ff d0                	call   *%eax
  803343:	89 c3                	mov    %eax,%ebx
		else
			r = 0;
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  803345:	89 74 24 04          	mov    %esi,0x4(%esp)
  803349:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  803350:	e8 3a f8 ff ff       	call   802b8f <sys_page_unmap>
	return r;
}
  803355:	89 d8                	mov    %ebx,%eax
  803357:	83 c4 20             	add    $0x20,%esp
  80335a:	5b                   	pop    %ebx
  80335b:	5e                   	pop    %esi
  80335c:	5d                   	pop    %ebp
  80335d:	c3                   	ret    

0080335e <close>:
	return -E_INVAL;
}

int
close(int fdnum)
{
  80335e:	55                   	push   %ebp
  80335f:	89 e5                	mov    %esp,%ebp
  803361:	83 ec 28             	sub    $0x28,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  803364:	8d 45 f4             	lea    -0xc(%ebp),%eax
  803367:	89 44 24 04          	mov    %eax,0x4(%esp)
  80336b:	8b 45 08             	mov    0x8(%ebp),%eax
  80336e:	89 04 24             	mov    %eax,(%esp)
  803371:	e8 27 fc ff ff       	call   802f9d <fd_lookup>
  803376:	85 c0                	test   %eax,%eax
  803378:	78 13                	js     80338d <close+0x2f>
		return r;
	else
		return fd_close(fd, 1);
  80337a:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  803381:	00 
  803382:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803385:	89 04 24             	mov    %eax,(%esp)
  803388:	e8 52 ff ff ff       	call   8032df <fd_close>
}
  80338d:	c9                   	leave  
  80338e:	c3                   	ret    

0080338f <stat>:
	return (*dev->dev_stat)(fd, stat);
}

int
stat(const char *path, struct Stat *stat)
{
  80338f:	55                   	push   %ebp
  803390:	89 e5                	mov    %esp,%ebp
  803392:	83 ec 18             	sub    $0x18,%esp
  803395:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  803398:	89 75 fc             	mov    %esi,-0x4(%ebp)
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  80339b:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  8033a2:	00 
  8033a3:	8b 45 08             	mov    0x8(%ebp),%eax
  8033a6:	89 04 24             	mov    %eax,(%esp)
  8033a9:	e8 55 03 00 00       	call   803703 <open>
  8033ae:	89 c3                	mov    %eax,%ebx
  8033b0:	85 c0                	test   %eax,%eax
  8033b2:	78 1b                	js     8033cf <stat+0x40>
		return fd;
	r = fstat(fd, stat);
  8033b4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8033b7:	89 44 24 04          	mov    %eax,0x4(%esp)
  8033bb:	89 1c 24             	mov    %ebx,(%esp)
  8033be:	e8 b7 fc ff ff       	call   80307a <fstat>
  8033c3:	89 c6                	mov    %eax,%esi
	close(fd);
  8033c5:	89 1c 24             	mov    %ebx,(%esp)
  8033c8:	e8 91 ff ff ff       	call   80335e <close>
  8033cd:	89 f3                	mov    %esi,%ebx
	return r;
}
  8033cf:	89 d8                	mov    %ebx,%eax
  8033d1:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  8033d4:	8b 75 fc             	mov    -0x4(%ebp),%esi
  8033d7:	89 ec                	mov    %ebp,%esp
  8033d9:	5d                   	pop    %ebp
  8033da:	c3                   	ret    

008033db <close_all>:
		return fd_close(fd, 1);
}

void
close_all(void)
{
  8033db:	55                   	push   %ebp
  8033dc:	89 e5                	mov    %esp,%ebp
  8033de:	53                   	push   %ebx
  8033df:	83 ec 14             	sub    $0x14,%esp
  8033e2:	bb 00 00 00 00       	mov    $0x0,%ebx
	int i;
	for (i = 0; i < MAXFD; i++)
		close(i);
  8033e7:	89 1c 24             	mov    %ebx,(%esp)
  8033ea:	e8 6f ff ff ff       	call   80335e <close>

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  8033ef:	83 c3 01             	add    $0x1,%ebx
  8033f2:	83 fb 20             	cmp    $0x20,%ebx
  8033f5:	75 f0                	jne    8033e7 <close_all+0xc>
		close(i);
}
  8033f7:	83 c4 14             	add    $0x14,%esp
  8033fa:	5b                   	pop    %ebx
  8033fb:	5d                   	pop    %ebp
  8033fc:	c3                   	ret    

008033fd <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  8033fd:	55                   	push   %ebp
  8033fe:	89 e5                	mov    %esp,%ebp
  803400:	83 ec 58             	sub    $0x58,%esp
  803403:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  803406:	89 75 f8             	mov    %esi,-0x8(%ebp)
  803409:	89 7d fc             	mov    %edi,-0x4(%ebp)
  80340c:	8b 7d 0c             	mov    0xc(%ebp),%edi
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  80340f:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  803412:	89 44 24 04          	mov    %eax,0x4(%esp)
  803416:	8b 45 08             	mov    0x8(%ebp),%eax
  803419:	89 04 24             	mov    %eax,(%esp)
  80341c:	e8 7c fb ff ff       	call   802f9d <fd_lookup>
  803421:	89 c3                	mov    %eax,%ebx
  803423:	85 c0                	test   %eax,%eax
  803425:	0f 88 e0 00 00 00    	js     80350b <dup+0x10e>
		return r;
	close(newfdnum);
  80342b:	89 3c 24             	mov    %edi,(%esp)
  80342e:	e8 2b ff ff ff       	call   80335e <close>

	newfd = INDEX2FD(newfdnum);
  803433:	8d b7 00 00 0d 00    	lea    0xd0000(%edi),%esi
  803439:	c1 e6 0c             	shl    $0xc,%esi
	ova = fd2data(oldfd);
  80343c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80343f:	89 04 24             	mov    %eax,(%esp)
  803442:	e8 c9 fa ff ff       	call   802f10 <fd2data>
  803447:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  803449:	89 34 24             	mov    %esi,(%esp)
  80344c:	e8 bf fa ff ff       	call   802f10 <fd2data>
  803451:	89 45 d4             	mov    %eax,-0x2c(%ebp)

	if ((vpd[PDX(ova)] & PTE_P) && (vpt[VPN(ova)] & PTE_P))
  803454:	89 da                	mov    %ebx,%edx
  803456:	89 d8                	mov    %ebx,%eax
  803458:	c1 e8 16             	shr    $0x16,%eax
  80345b:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  803462:	a8 01                	test   $0x1,%al
  803464:	74 43                	je     8034a9 <dup+0xac>
  803466:	c1 ea 0c             	shr    $0xc,%edx
  803469:	8b 04 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%eax
  803470:	a8 01                	test   $0x1,%al
  803472:	74 35                	je     8034a9 <dup+0xac>
		if ((r = sys_page_map(0, ova, 0, nva, vpt[VPN(ova)] & PTE_USER)) < 0)
  803474:	8b 04 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%eax
  80347b:	25 07 0e 00 00       	and    $0xe07,%eax
  803480:	89 44 24 10          	mov    %eax,0x10(%esp)
  803484:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  803487:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80348b:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  803492:	00 
  803493:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  803497:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80349e:	e8 4a f7 ff ff       	call   802bed <sys_page_map>
  8034a3:	89 c3                	mov    %eax,%ebx
  8034a5:	85 c0                	test   %eax,%eax
  8034a7:	78 3f                	js     8034e8 <dup+0xeb>
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, vpt[VPN(oldfd)] & PTE_USER)) < 0)
  8034a9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8034ac:	89 c2                	mov    %eax,%edx
  8034ae:	c1 ea 0c             	shr    $0xc,%edx
  8034b1:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8034b8:	81 e2 07 0e 00 00    	and    $0xe07,%edx
  8034be:	89 54 24 10          	mov    %edx,0x10(%esp)
  8034c2:	89 74 24 0c          	mov    %esi,0xc(%esp)
  8034c6:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  8034cd:	00 
  8034ce:	89 44 24 04          	mov    %eax,0x4(%esp)
  8034d2:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8034d9:	e8 0f f7 ff ff       	call   802bed <sys_page_map>
  8034de:	89 c3                	mov    %eax,%ebx
  8034e0:	85 c0                	test   %eax,%eax
  8034e2:	78 04                	js     8034e8 <dup+0xeb>
  8034e4:	89 fb                	mov    %edi,%ebx
  8034e6:	eb 23                	jmp    80350b <dup+0x10e>
		goto err;

	return newfdnum;

err:
	sys_page_unmap(0, newfd);
  8034e8:	89 74 24 04          	mov    %esi,0x4(%esp)
  8034ec:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8034f3:	e8 97 f6 ff ff       	call   802b8f <sys_page_unmap>
	sys_page_unmap(0, nva);
  8034f8:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8034fb:	89 44 24 04          	mov    %eax,0x4(%esp)
  8034ff:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  803506:	e8 84 f6 ff ff       	call   802b8f <sys_page_unmap>
	return r;
}
  80350b:	89 d8                	mov    %ebx,%eax
  80350d:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  803510:	8b 75 f8             	mov    -0x8(%ebp),%esi
  803513:	8b 7d fc             	mov    -0x4(%ebp),%edi
  803516:	89 ec                	mov    %ebp,%esp
  803518:	5d                   	pop    %ebp
  803519:	c3                   	ret    
	...

0080351c <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  80351c:	55                   	push   %ebp
  80351d:	89 e5                	mov    %esp,%ebp
  80351f:	53                   	push   %ebx
  803520:	83 ec 14             	sub    $0x14,%esp
  803523:	89 d3                	mov    %edx,%ebx
	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", env->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(envs[1].env_id, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  803525:	8b 15 c8 00 c0 ee    	mov    0xeec000c8,%edx
  80352b:	c7 44 24 0c 07 00 00 	movl   $0x7,0xc(%esp)
  803532:	00 
  803533:	c7 44 24 08 00 50 80 	movl   $0x805000,0x8(%esp)
  80353a:	00 
  80353b:	89 44 24 04          	mov    %eax,0x4(%esp)
  80353f:	89 14 24             	mov    %edx,(%esp)
  803542:	e8 e9 f8 ff ff       	call   802e30 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  803547:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  80354e:	00 
  80354f:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  803553:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80355a:	e8 37 f9 ff ff       	call   802e96 <ipc_recv>
}
  80355f:	83 c4 14             	add    $0x14,%esp
  803562:	5b                   	pop    %ebx
  803563:	5d                   	pop    %ebp
  803564:	c3                   	ret    

00803565 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  803565:	55                   	push   %ebp
  803566:	89 e5                	mov    %esp,%ebp
  803568:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  80356b:	8b 45 08             	mov    0x8(%ebp),%eax
  80356e:	8b 40 0c             	mov    0xc(%eax),%eax
  803571:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.set_size.req_size = newsize;
  803576:	8b 45 0c             	mov    0xc(%ebp),%eax
  803579:	a3 04 50 80 00       	mov    %eax,0x805004
	return fsipc(FSREQ_SET_SIZE, NULL);
  80357e:	ba 00 00 00 00       	mov    $0x0,%edx
  803583:	b8 02 00 00 00       	mov    $0x2,%eax
  803588:	e8 8f ff ff ff       	call   80351c <fsipc>
}
  80358d:	c9                   	leave  
  80358e:	c3                   	ret    

0080358f <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  80358f:	55                   	push   %ebp
  803590:	89 e5                	mov    %esp,%ebp
  803592:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  803595:	8b 45 08             	mov    0x8(%ebp),%eax
  803598:	8b 40 0c             	mov    0xc(%eax),%eax
  80359b:	a3 00 50 80 00       	mov    %eax,0x805000
	return fsipc(FSREQ_FLUSH, NULL);
  8035a0:	ba 00 00 00 00       	mov    $0x0,%edx
  8035a5:	b8 06 00 00 00       	mov    $0x6,%eax
  8035aa:	e8 6d ff ff ff       	call   80351c <fsipc>
}
  8035af:	c9                   	leave  
  8035b0:	c3                   	ret    

008035b1 <sync>:
}

// Synchronize disk with buffer cache
int
sync(void)
{
  8035b1:	55                   	push   %ebp
  8035b2:	89 e5                	mov    %esp,%ebp
  8035b4:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  8035b7:	ba 00 00 00 00       	mov    $0x0,%edx
  8035bc:	b8 08 00 00 00       	mov    $0x8,%eax
  8035c1:	e8 56 ff ff ff       	call   80351c <fsipc>
}
  8035c6:	c9                   	leave  
  8035c7:	c3                   	ret    

008035c8 <devfile_stat>:
	return fsipc(FSREQ_WRITE, NULL);	
}

static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  8035c8:	55                   	push   %ebp
  8035c9:	89 e5                	mov    %esp,%ebp
  8035cb:	53                   	push   %ebx
  8035cc:	83 ec 14             	sub    $0x14,%esp
  8035cf:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  8035d2:	8b 45 08             	mov    0x8(%ebp),%eax
  8035d5:	8b 40 0c             	mov    0xc(%eax),%eax
  8035d8:	a3 00 50 80 00       	mov    %eax,0x805000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  8035dd:	ba 00 00 00 00       	mov    $0x0,%edx
  8035e2:	b8 05 00 00 00       	mov    $0x5,%eax
  8035e7:	e8 30 ff ff ff       	call   80351c <fsipc>
  8035ec:	85 c0                	test   %eax,%eax
  8035ee:	78 2b                	js     80361b <devfile_stat+0x53>
		return r;
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  8035f0:	c7 44 24 04 00 50 80 	movl   $0x805000,0x4(%esp)
  8035f7:	00 
  8035f8:	89 1c 24             	mov    %ebx,(%esp)
  8035fb:	e8 5a ee ff ff       	call   80245a <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  803600:	a1 80 50 80 00       	mov    0x805080,%eax
  803605:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  80360b:	a1 84 50 80 00       	mov    0x805084,%eax
  803610:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
  803616:	b8 00 00 00 00       	mov    $0x0,%eax
	return 0;
}
  80361b:	83 c4 14             	add    $0x14,%esp
  80361e:	5b                   	pop    %ebx
  80361f:	5d                   	pop    %ebp
  803620:	c3                   	ret    

00803621 <devfile_write>:
// Returns:
//	 The number of bytes successfully written.
//	 < 0 on error.
static ssize_t
devfile_write(struct Fd *fd, const void *buf, size_t n)
{
  803621:	55                   	push   %ebp
  803622:	89 e5                	mov    %esp,%ebp
  803624:	83 ec 18             	sub    $0x18,%esp
  803627:	8b 45 10             	mov    0x10(%ebp),%eax
  80362a:	3d f8 0f 00 00       	cmp    $0xff8,%eax
  80362f:	76 05                	jbe    803636 <devfile_write+0x15>
  803631:	b8 f8 0f 00 00       	mov    $0xff8,%eax
	// LAB 5: Your code here
	//panic("devfile_write not implemented");
	
	if (n > (PGSIZE - (sizeof(int) + sizeof(size_t))))
		n = PGSIZE - (sizeof(int) + sizeof(size_t));
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  803636:	8b 55 08             	mov    0x8(%ebp),%edx
  803639:	8b 52 0c             	mov    0xc(%edx),%edx
  80363c:	89 15 00 50 80 00    	mov    %edx,0x805000
	fsipcbuf.write.req_n = n;
  803642:	a3 04 50 80 00       	mov    %eax,0x805004
	memmove (fsipcbuf.write.req_buf, (char*)buf, n);	
  803647:	89 44 24 08          	mov    %eax,0x8(%esp)
  80364b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80364e:	89 44 24 04          	mov    %eax,0x4(%esp)
  803652:	c7 04 24 08 50 80 00 	movl   $0x805008,(%esp)
  803659:	e8 b7 ef ff ff       	call   802615 <memmove>
	return fsipc(FSREQ_WRITE, NULL);	
  80365e:	ba 00 00 00 00       	mov    $0x0,%edx
  803663:	b8 04 00 00 00       	mov    $0x4,%eax
  803668:	e8 af fe ff ff       	call   80351c <fsipc>
}
  80366d:	c9                   	leave  
  80366e:	c3                   	ret    

0080366f <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  80366f:	55                   	push   %ebp
  803670:	89 e5                	mov    %esp,%ebp
  803672:	53                   	push   %ebx
  803673:	83 ec 14             	sub    $0x14,%esp
	// system server.
	// LAB 5: Your code here
	
	//panic("devfile_read not implemented");
	int r;
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  803676:	8b 45 08             	mov    0x8(%ebp),%eax
  803679:	8b 40 0c             	mov    0xc(%eax),%eax
  80367c:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.read.req_n = n;
  803681:	8b 45 10             	mov    0x10(%ebp),%eax
  803684:	a3 04 50 80 00       	mov    %eax,0x805004
	if ((r = fsipc(FSREQ_READ, (void*)&fsipcbuf)) < 0)
  803689:	ba 00 50 80 00       	mov    $0x805000,%edx
  80368e:	b8 03 00 00 00       	mov    $0x3,%eax
  803693:	e8 84 fe ff ff       	call   80351c <fsipc>
  803698:	89 c3                	mov    %eax,%ebx
  80369a:	85 c0                	test   %eax,%eax
  80369c:	78 17                	js     8036b5 <devfile_read+0x46>
		return r;
	memmove((void*)buf, (void*)fsipcbuf.readRet.ret_buf, r);
  80369e:	89 44 24 08          	mov    %eax,0x8(%esp)
  8036a2:	c7 44 24 04 00 50 80 	movl   $0x805000,0x4(%esp)
  8036a9:	00 
  8036aa:	8b 45 0c             	mov    0xc(%ebp),%eax
  8036ad:	89 04 24             	mov    %eax,(%esp)
  8036b0:	e8 60 ef ff ff       	call   802615 <memmove>
	return r;
}
  8036b5:	89 d8                	mov    %ebx,%eax
  8036b7:	83 c4 14             	add    $0x14,%esp
  8036ba:	5b                   	pop    %ebx
  8036bb:	5d                   	pop    %ebp
  8036bc:	c3                   	ret    

008036bd <remove>:
}

// Delete a file
int
remove(const char *path)
{
  8036bd:	55                   	push   %ebp
  8036be:	89 e5                	mov    %esp,%ebp
  8036c0:	53                   	push   %ebx
  8036c1:	83 ec 14             	sub    $0x14,%esp
  8036c4:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (strlen(path) >= MAXPATHLEN)
  8036c7:	89 1c 24             	mov    %ebx,(%esp)
  8036ca:	e8 41 ed ff ff       	call   802410 <strlen>
  8036cf:	89 c2                	mov    %eax,%edx
  8036d1:	b8 f4 ff ff ff       	mov    $0xfffffff4,%eax
  8036d6:	81 fa ff 03 00 00    	cmp    $0x3ff,%edx
  8036dc:	7f 1f                	jg     8036fd <remove+0x40>
		return -E_BAD_PATH;
	strcpy(fsipcbuf.remove.req_path, path);
  8036de:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8036e2:	c7 04 24 00 50 80 00 	movl   $0x805000,(%esp)
  8036e9:	e8 6c ed ff ff       	call   80245a <strcpy>
	return fsipc(FSREQ_REMOVE, NULL);
  8036ee:	ba 00 00 00 00       	mov    $0x0,%edx
  8036f3:	b8 07 00 00 00       	mov    $0x7,%eax
  8036f8:	e8 1f fe ff ff       	call   80351c <fsipc>
}
  8036fd:	83 c4 14             	add    $0x14,%esp
  803700:	5b                   	pop    %ebx
  803701:	5d                   	pop    %ebp
  803702:	c3                   	ret    

00803703 <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  803703:	55                   	push   %ebp
  803704:	89 e5                	mov    %esp,%ebp
  803706:	83 ec 28             	sub    $0x28,%esp
  803709:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  80370c:	89 75 fc             	mov    %esi,-0x4(%ebp)
  80370f:	8b 75 08             	mov    0x8(%ebp),%esi
	// file descriptor.

	// LAB 5: Your code here.
	// Code added by Swastika / Sandeep
	
	if (strlen(path) >= MAXPATHLEN)
  803712:	89 34 24             	mov    %esi,(%esp)
  803715:	e8 f6 ec ff ff       	call   802410 <strlen>
  80371a:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  80371f:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  803724:	7f 5e                	jg     803784 <open+0x81>
		return -E_BAD_PATH;
	struct Fd * fd;
	int  r;
	if ((r = fd_alloc(&fd)) < 0)
  803726:	8d 45 f4             	lea    -0xc(%ebp),%eax
  803729:	89 04 24             	mov    %eax,(%esp)
  80372c:	e8 fa f7 ff ff       	call   802f2b <fd_alloc>
  803731:	89 c3                	mov    %eax,%ebx
  803733:	85 c0                	test   %eax,%eax
  803735:	78 4d                	js     803784 <open+0x81>
		return r;
	strcpy (fsipcbuf.open.req_path, path);
  803737:	89 74 24 04          	mov    %esi,0x4(%esp)
  80373b:	c7 04 24 00 50 80 00 	movl   $0x805000,(%esp)
  803742:	e8 13 ed ff ff       	call   80245a <strcpy>
	fsipcbuf.open.req_omode = mode;	
  803747:	8b 45 0c             	mov    0xc(%ebp),%eax
  80374a:	a3 00 54 80 00       	mov    %eax,0x805400
	if ((r = fsipc(FSREQ_OPEN,(void*)fd)) < 0)
  80374f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803752:	b8 01 00 00 00       	mov    $0x1,%eax
  803757:	e8 c0 fd ff ff       	call   80351c <fsipc>
  80375c:	89 c3                	mov    %eax,%ebx
  80375e:	85 c0                	test   %eax,%eax
  803760:	79 15                	jns    803777 <open+0x74>
	{
		fd_close(fd,0);
  803762:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  803769:	00 
  80376a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80376d:	89 04 24             	mov    %eax,(%esp)
  803770:	e8 6a fb ff ff       	call   8032df <fd_close>
		return r; 
  803775:	eb 0d                	jmp    803784 <open+0x81>
	}
	return fd2num(fd);
  803777:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80377a:	89 04 24             	mov    %eax,(%esp)
  80377d:	e8 7e f7 ff ff       	call   802f00 <fd2num>
  803782:	89 c3                	mov    %eax,%ebx
	//panic("open not implemented");
}
  803784:	89 d8                	mov    %ebx,%eax
  803786:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  803789:	8b 75 fc             	mov    -0x4(%ebp),%esi
  80378c:	89 ec                	mov    %ebp,%esp
  80378e:	5d                   	pop    %ebp
  80378f:	c3                   	ret    

00803790 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  803790:	55                   	push   %ebp
  803791:	89 e5                	mov    %esp,%ebp
	pte_t pte;

	if (!(vpd[PDX(v)] & PTE_P))
  803793:	8b 45 08             	mov    0x8(%ebp),%eax
  803796:	89 c2                	mov    %eax,%edx
  803798:	c1 ea 16             	shr    $0x16,%edx
  80379b:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  8037a2:	f6 c2 01             	test   $0x1,%dl
  8037a5:	74 26                	je     8037cd <pageref+0x3d>
		return 0;
	pte = vpt[VPN(v)];
  8037a7:	c1 e8 0c             	shr    $0xc,%eax
  8037aa:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
	if (!(pte & PTE_P))
  8037b1:	a8 01                	test   $0x1,%al
  8037b3:	74 18                	je     8037cd <pageref+0x3d>
		return 0;
	return pages[PPN(pte)].pp_ref;
  8037b5:	c1 e8 0c             	shr    $0xc,%eax
  8037b8:	8d 14 40             	lea    (%eax,%eax,2),%edx
  8037bb:	c1 e2 02             	shl    $0x2,%edx
  8037be:	b8 00 00 00 ef       	mov    $0xef000000,%eax
  8037c3:	0f b7 44 02 08       	movzwl 0x8(%edx,%eax,1),%eax
  8037c8:	0f b7 c0             	movzwl %ax,%eax
  8037cb:	eb 05                	jmp    8037d2 <pageref+0x42>
  8037cd:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8037d2:	5d                   	pop    %ebp
  8037d3:	c3                   	ret    
	...

008037e0 <devsock_stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  8037e0:	55                   	push   %ebp
  8037e1:	89 e5                	mov    %esp,%ebp
  8037e3:	83 ec 18             	sub    $0x18,%esp
	strcpy(stat->st_name, "<sock>");
  8037e6:	c7 44 24 04 64 4e 80 	movl   $0x804e64,0x4(%esp)
  8037ed:	00 
  8037ee:	8b 45 0c             	mov    0xc(%ebp),%eax
  8037f1:	89 04 24             	mov    %eax,(%esp)
  8037f4:	e8 61 ec ff ff       	call   80245a <strcpy>
	return 0;
}
  8037f9:	b8 00 00 00 00       	mov    $0x0,%eax
  8037fe:	c9                   	leave  
  8037ff:	c3                   	ret    

00803800 <devsock_close>:
	return nsipc_shutdown(r, how);
}

static int
devsock_close(struct Fd *fd)
{
  803800:	55                   	push   %ebp
  803801:	89 e5                	mov    %esp,%ebp
  803803:	83 ec 18             	sub    $0x18,%esp
	return nsipc_close(fd->fd_sock.sockid);
  803806:	8b 45 08             	mov    0x8(%ebp),%eax
  803809:	8b 40 0c             	mov    0xc(%eax),%eax
  80380c:	89 04 24             	mov    %eax,(%esp)
  80380f:	e8 9e 02 00 00       	call   803ab2 <nsipc_close>
}
  803814:	c9                   	leave  
  803815:	c3                   	ret    

00803816 <devsock_write>:
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
}

static ssize_t
devsock_write(struct Fd *fd, const void *buf, size_t n)
{
  803816:	55                   	push   %ebp
  803817:	89 e5                	mov    %esp,%ebp
  803819:	83 ec 18             	sub    $0x18,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  80381c:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  803823:	00 
  803824:	8b 45 10             	mov    0x10(%ebp),%eax
  803827:	89 44 24 08          	mov    %eax,0x8(%esp)
  80382b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80382e:	89 44 24 04          	mov    %eax,0x4(%esp)
  803832:	8b 45 08             	mov    0x8(%ebp),%eax
  803835:	8b 40 0c             	mov    0xc(%eax),%eax
  803838:	89 04 24             	mov    %eax,(%esp)
  80383b:	e8 ae 02 00 00       	call   803aee <nsipc_send>
}
  803840:	c9                   	leave  
  803841:	c3                   	ret    

00803842 <devsock_read>:
	return nsipc_listen(r, backlog);
}

static ssize_t
devsock_read(struct Fd *fd, void *buf, size_t n)
{
  803842:	55                   	push   %ebp
  803843:	89 e5                	mov    %esp,%ebp
  803845:	83 ec 18             	sub    $0x18,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  803848:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  80384f:	00 
  803850:	8b 45 10             	mov    0x10(%ebp),%eax
  803853:	89 44 24 08          	mov    %eax,0x8(%esp)
  803857:	8b 45 0c             	mov    0xc(%ebp),%eax
  80385a:	89 44 24 04          	mov    %eax,0x4(%esp)
  80385e:	8b 45 08             	mov    0x8(%ebp),%eax
  803861:	8b 40 0c             	mov    0xc(%eax),%eax
  803864:	89 04 24             	mov    %eax,(%esp)
  803867:	e8 f5 02 00 00       	call   803b61 <nsipc_recv>
}
  80386c:	c9                   	leave  
  80386d:	c3                   	ret    

0080386e <alloc_sockfd>:
	return sfd->fd_sock.sockid;
}

static int
alloc_sockfd(int sockid)
{
  80386e:	55                   	push   %ebp
  80386f:	89 e5                	mov    %esp,%ebp
  803871:	56                   	push   %esi
  803872:	53                   	push   %ebx
  803873:	83 ec 20             	sub    $0x20,%esp
  803876:	89 c6                	mov    %eax,%esi
	struct Fd *sfd;
	int r;

	if ((r = fd_alloc(&sfd)) < 0
  803878:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80387b:	89 04 24             	mov    %eax,(%esp)
  80387e:	e8 a8 f6 ff ff       	call   802f2b <fd_alloc>
  803883:	89 c3                	mov    %eax,%ebx
  803885:	85 c0                	test   %eax,%eax
  803887:	78 21                	js     8038aa <alloc_sockfd+0x3c>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U)) < 0) {
  803889:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  803890:	00 
  803891:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803894:	89 44 24 04          	mov    %eax,0x4(%esp)
  803898:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80389f:	e8 a7 f3 ff ff       	call   802c4b <sys_page_alloc>
  8038a4:	89 c3                	mov    %eax,%ebx
alloc_sockfd(int sockid)
{
	struct Fd *sfd;
	int r;

	if ((r = fd_alloc(&sfd)) < 0
  8038a6:	85 c0                	test   %eax,%eax
  8038a8:	79 0a                	jns    8038b4 <alloc_sockfd+0x46>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U)) < 0) {
		nsipc_close(sockid);
  8038aa:	89 34 24             	mov    %esi,(%esp)
  8038ad:	e8 00 02 00 00       	call   803ab2 <nsipc_close>
		return r;
  8038b2:	eb 28                	jmp    8038dc <alloc_sockfd+0x6e>
	}

	sfd->fd_dev_id = devsock.dev_id;
  8038b4:	8b 15 84 c0 80 00    	mov    0x80c084,%edx
  8038ba:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8038bd:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  8038bf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8038c2:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	sfd->fd_sock.sockid = sockid;
  8038c9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8038cc:	89 70 0c             	mov    %esi,0xc(%eax)
	return fd2num(sfd);
  8038cf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8038d2:	89 04 24             	mov    %eax,(%esp)
  8038d5:	e8 26 f6 ff ff       	call   802f00 <fd2num>
  8038da:	89 c3                	mov    %eax,%ebx
}
  8038dc:	89 d8                	mov    %ebx,%eax
  8038de:	83 c4 20             	add    $0x20,%esp
  8038e1:	5b                   	pop    %ebx
  8038e2:	5e                   	pop    %esi
  8038e3:	5d                   	pop    %ebp
  8038e4:	c3                   	ret    

008038e5 <socket>:
	return 0;
}

int
socket(int domain, int type, int protocol)
{
  8038e5:	55                   	push   %ebp
  8038e6:	89 e5                	mov    %esp,%ebp
  8038e8:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  8038eb:	8b 45 10             	mov    0x10(%ebp),%eax
  8038ee:	89 44 24 08          	mov    %eax,0x8(%esp)
  8038f2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8038f5:	89 44 24 04          	mov    %eax,0x4(%esp)
  8038f9:	8b 45 08             	mov    0x8(%ebp),%eax
  8038fc:	89 04 24             	mov    %eax,(%esp)
  8038ff:	e8 62 01 00 00       	call   803a66 <nsipc_socket>
  803904:	85 c0                	test   %eax,%eax
  803906:	78 05                	js     80390d <socket+0x28>
		return r;
	return alloc_sockfd(r);
  803908:	e8 61 ff ff ff       	call   80386e <alloc_sockfd>
}
  80390d:	c9                   	leave  
  80390e:	66 90                	xchg   %ax,%ax
  803910:	c3                   	ret    

00803911 <fd2sockid>:
	.dev_stat =	devsock_stat,
};

static int
fd2sockid(int fd)
{
  803911:	55                   	push   %ebp
  803912:	89 e5                	mov    %esp,%ebp
  803914:	83 ec 28             	sub    $0x28,%esp
	struct Fd *sfd;
	int r;

	if ((r = fd_lookup(fd, &sfd)) < 0)
  803917:	8d 55 f4             	lea    -0xc(%ebp),%edx
  80391a:	89 54 24 04          	mov    %edx,0x4(%esp)
  80391e:	89 04 24             	mov    %eax,(%esp)
  803921:	e8 77 f6 ff ff       	call   802f9d <fd_lookup>
  803926:	85 c0                	test   %eax,%eax
  803928:	78 15                	js     80393f <fd2sockid+0x2e>
		return r;
	if (sfd->fd_dev_id != devsock.dev_id)
  80392a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80392d:	8b 0a                	mov    (%edx),%ecx
  80392f:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  803934:	3b 0d 84 c0 80 00    	cmp    0x80c084,%ecx
  80393a:	75 03                	jne    80393f <fd2sockid+0x2e>
		return -E_NOT_SUPP;
	return sfd->fd_sock.sockid;
  80393c:	8b 42 0c             	mov    0xc(%edx),%eax
}
  80393f:	c9                   	leave  
  803940:	c3                   	ret    

00803941 <listen>:
	return nsipc_connect(r, name, namelen);
}

int
listen(int s, int backlog)
{
  803941:	55                   	push   %ebp
  803942:	89 e5                	mov    %esp,%ebp
  803944:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  803947:	8b 45 08             	mov    0x8(%ebp),%eax
  80394a:	e8 c2 ff ff ff       	call   803911 <fd2sockid>
  80394f:	85 c0                	test   %eax,%eax
  803951:	78 0f                	js     803962 <listen+0x21>
		return r;
	return nsipc_listen(r, backlog);
  803953:	8b 55 0c             	mov    0xc(%ebp),%edx
  803956:	89 54 24 04          	mov    %edx,0x4(%esp)
  80395a:	89 04 24             	mov    %eax,(%esp)
  80395d:	e8 2e 01 00 00       	call   803a90 <nsipc_listen>
}
  803962:	c9                   	leave  
  803963:	c3                   	ret    

00803964 <connect>:
	return nsipc_close(fd->fd_sock.sockid);
}

int
connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  803964:	55                   	push   %ebp
  803965:	89 e5                	mov    %esp,%ebp
  803967:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  80396a:	8b 45 08             	mov    0x8(%ebp),%eax
  80396d:	e8 9f ff ff ff       	call   803911 <fd2sockid>
  803972:	85 c0                	test   %eax,%eax
  803974:	78 16                	js     80398c <connect+0x28>
		return r;
	return nsipc_connect(r, name, namelen);
  803976:	8b 55 10             	mov    0x10(%ebp),%edx
  803979:	89 54 24 08          	mov    %edx,0x8(%esp)
  80397d:	8b 55 0c             	mov    0xc(%ebp),%edx
  803980:	89 54 24 04          	mov    %edx,0x4(%esp)
  803984:	89 04 24             	mov    %eax,(%esp)
  803987:	e8 55 02 00 00       	call   803be1 <nsipc_connect>
}
  80398c:	c9                   	leave  
  80398d:	c3                   	ret    

0080398e <shutdown>:
	return nsipc_bind(r, name, namelen);
}

int
shutdown(int s, int how)
{
  80398e:	55                   	push   %ebp
  80398f:	89 e5                	mov    %esp,%ebp
  803991:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  803994:	8b 45 08             	mov    0x8(%ebp),%eax
  803997:	e8 75 ff ff ff       	call   803911 <fd2sockid>
  80399c:	85 c0                	test   %eax,%eax
  80399e:	78 0f                	js     8039af <shutdown+0x21>
		return r;
	return nsipc_shutdown(r, how);
  8039a0:	8b 55 0c             	mov    0xc(%ebp),%edx
  8039a3:	89 54 24 04          	mov    %edx,0x4(%esp)
  8039a7:	89 04 24             	mov    %eax,(%esp)
  8039aa:	e8 1d 01 00 00       	call   803acc <nsipc_shutdown>
}
  8039af:	c9                   	leave  
  8039b0:	c3                   	ret    

008039b1 <bind>:
	return alloc_sockfd(r);
}

int
bind(int s, struct sockaddr *name, socklen_t namelen)
{
  8039b1:	55                   	push   %ebp
  8039b2:	89 e5                	mov    %esp,%ebp
  8039b4:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  8039b7:	8b 45 08             	mov    0x8(%ebp),%eax
  8039ba:	e8 52 ff ff ff       	call   803911 <fd2sockid>
  8039bf:	85 c0                	test   %eax,%eax
  8039c1:	78 16                	js     8039d9 <bind+0x28>
		return r;
	return nsipc_bind(r, name, namelen);
  8039c3:	8b 55 10             	mov    0x10(%ebp),%edx
  8039c6:	89 54 24 08          	mov    %edx,0x8(%esp)
  8039ca:	8b 55 0c             	mov    0xc(%ebp),%edx
  8039cd:	89 54 24 04          	mov    %edx,0x4(%esp)
  8039d1:	89 04 24             	mov    %eax,(%esp)
  8039d4:	e8 47 02 00 00       	call   803c20 <nsipc_bind>
}
  8039d9:	c9                   	leave  
  8039da:	c3                   	ret    

008039db <accept>:
	return fd2num(sfd);
}

int
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  8039db:	55                   	push   %ebp
  8039dc:	89 e5                	mov    %esp,%ebp
  8039de:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  8039e1:	8b 45 08             	mov    0x8(%ebp),%eax
  8039e4:	e8 28 ff ff ff       	call   803911 <fd2sockid>
  8039e9:	85 c0                	test   %eax,%eax
  8039eb:	78 1f                	js     803a0c <accept+0x31>
		return r;
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  8039ed:	8b 55 10             	mov    0x10(%ebp),%edx
  8039f0:	89 54 24 08          	mov    %edx,0x8(%esp)
  8039f4:	8b 55 0c             	mov    0xc(%ebp),%edx
  8039f7:	89 54 24 04          	mov    %edx,0x4(%esp)
  8039fb:	89 04 24             	mov    %eax,(%esp)
  8039fe:	e8 5c 02 00 00       	call   803c5f <nsipc_accept>
  803a03:	85 c0                	test   %eax,%eax
  803a05:	78 05                	js     803a0c <accept+0x31>
		return r;
	return alloc_sockfd(r);
  803a07:	e8 62 fe ff ff       	call   80386e <alloc_sockfd>
}
  803a0c:	c9                   	leave  
  803a0d:	8d 76 00             	lea    0x0(%esi),%esi
  803a10:	c3                   	ret    
	...

00803a20 <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  803a20:	55                   	push   %ebp
  803a21:	89 e5                	mov    %esp,%ebp
  803a23:	83 ec 18             	sub    $0x18,%esp
	if (debug)
		cprintf("[%08x] nsipc %d\n", env->env_id, type);

	ipc_send(envs[2].env_id, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  803a26:	8b 15 44 01 c0 ee    	mov    0xeec00144,%edx
  803a2c:	c7 44 24 0c 07 00 00 	movl   $0x7,0xc(%esp)
  803a33:	00 
  803a34:	c7 44 24 08 00 70 80 	movl   $0x807000,0x8(%esp)
  803a3b:	00 
  803a3c:	89 44 24 04          	mov    %eax,0x4(%esp)
  803a40:	89 14 24             	mov    %edx,(%esp)
  803a43:	e8 e8 f3 ff ff       	call   802e30 <ipc_send>
	return ipc_recv(NULL, NULL, NULL);
  803a48:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  803a4f:	00 
  803a50:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  803a57:	00 
  803a58:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  803a5f:	e8 32 f4 ff ff       	call   802e96 <ipc_recv>
}
  803a64:	c9                   	leave  
  803a65:	c3                   	ret    

00803a66 <nsipc_socket>:
	return nsipc(NSREQ_SEND);
}

int
nsipc_socket(int domain, int type, int protocol)
{
  803a66:	55                   	push   %ebp
  803a67:	89 e5                	mov    %esp,%ebp
  803a69:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  803a6c:	8b 45 08             	mov    0x8(%ebp),%eax
  803a6f:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.socket.req_type = type;
  803a74:	8b 45 0c             	mov    0xc(%ebp),%eax
  803a77:	a3 04 70 80 00       	mov    %eax,0x807004
	nsipcbuf.socket.req_protocol = protocol;
  803a7c:	8b 45 10             	mov    0x10(%ebp),%eax
  803a7f:	a3 08 70 80 00       	mov    %eax,0x807008
	return nsipc(NSREQ_SOCKET);
  803a84:	b8 09 00 00 00       	mov    $0x9,%eax
  803a89:	e8 92 ff ff ff       	call   803a20 <nsipc>
}
  803a8e:	c9                   	leave  
  803a8f:	c3                   	ret    

00803a90 <nsipc_listen>:
	return nsipc(NSREQ_CONNECT);
}

int
nsipc_listen(int s, int backlog)
{
  803a90:	55                   	push   %ebp
  803a91:	89 e5                	mov    %esp,%ebp
  803a93:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  803a96:	8b 45 08             	mov    0x8(%ebp),%eax
  803a99:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.listen.req_backlog = backlog;
  803a9e:	8b 45 0c             	mov    0xc(%ebp),%eax
  803aa1:	a3 04 70 80 00       	mov    %eax,0x807004
	return nsipc(NSREQ_LISTEN);
  803aa6:	b8 06 00 00 00       	mov    $0x6,%eax
  803aab:	e8 70 ff ff ff       	call   803a20 <nsipc>
}
  803ab0:	c9                   	leave  
  803ab1:	c3                   	ret    

00803ab2 <nsipc_close>:
	return nsipc(NSREQ_SHUTDOWN);
}

int
nsipc_close(int s)
{
  803ab2:	55                   	push   %ebp
  803ab3:	89 e5                	mov    %esp,%ebp
  803ab5:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  803ab8:	8b 45 08             	mov    0x8(%ebp),%eax
  803abb:	a3 00 70 80 00       	mov    %eax,0x807000
	return nsipc(NSREQ_CLOSE);
  803ac0:	b8 04 00 00 00       	mov    $0x4,%eax
  803ac5:	e8 56 ff ff ff       	call   803a20 <nsipc>
}
  803aca:	c9                   	leave  
  803acb:	c3                   	ret    

00803acc <nsipc_shutdown>:
	return nsipc(NSREQ_BIND);
}

int
nsipc_shutdown(int s, int how)
{
  803acc:	55                   	push   %ebp
  803acd:	89 e5                	mov    %esp,%ebp
  803acf:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  803ad2:	8b 45 08             	mov    0x8(%ebp),%eax
  803ad5:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.shutdown.req_how = how;
  803ada:	8b 45 0c             	mov    0xc(%ebp),%eax
  803add:	a3 04 70 80 00       	mov    %eax,0x807004
	return nsipc(NSREQ_SHUTDOWN);
  803ae2:	b8 03 00 00 00       	mov    $0x3,%eax
  803ae7:	e8 34 ff ff ff       	call   803a20 <nsipc>
}
  803aec:	c9                   	leave  
  803aed:	c3                   	ret    

00803aee <nsipc_send>:
	return r;
}

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  803aee:	55                   	push   %ebp
  803aef:	89 e5                	mov    %esp,%ebp
  803af1:	53                   	push   %ebx
  803af2:	83 ec 14             	sub    $0x14,%esp
  803af5:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  803af8:	8b 45 08             	mov    0x8(%ebp),%eax
  803afb:	a3 00 70 80 00       	mov    %eax,0x807000
	assert(size < 1600);
  803b00:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  803b06:	7e 24                	jle    803b2c <nsipc_send+0x3e>
  803b08:	c7 44 24 0c 70 4e 80 	movl   $0x804e70,0xc(%esp)
  803b0f:	00 
  803b10:	c7 44 24 08 cd 44 80 	movl   $0x8044cd,0x8(%esp)
  803b17:	00 
  803b18:	c7 44 24 04 66 00 00 	movl   $0x66,0x4(%esp)
  803b1f:	00 
  803b20:	c7 04 24 7c 4e 80 00 	movl   $0x804e7c,(%esp)
  803b27:	e8 a4 e1 ff ff       	call   801cd0 <_panic>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  803b2c:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  803b30:	8b 45 0c             	mov    0xc(%ebp),%eax
  803b33:	89 44 24 04          	mov    %eax,0x4(%esp)
  803b37:	c7 04 24 0c 70 80 00 	movl   $0x80700c,(%esp)
  803b3e:	e8 d2 ea ff ff       	call   802615 <memmove>
	nsipcbuf.send.req_size = size;
  803b43:	89 1d 04 70 80 00    	mov    %ebx,0x807004
	nsipcbuf.send.req_flags = flags;
  803b49:	8b 45 14             	mov    0x14(%ebp),%eax
  803b4c:	a3 08 70 80 00       	mov    %eax,0x807008
	return nsipc(NSREQ_SEND);
  803b51:	b8 08 00 00 00       	mov    $0x8,%eax
  803b56:	e8 c5 fe ff ff       	call   803a20 <nsipc>
}
  803b5b:	83 c4 14             	add    $0x14,%esp
  803b5e:	5b                   	pop    %ebx
  803b5f:	5d                   	pop    %ebp
  803b60:	c3                   	ret    

00803b61 <nsipc_recv>:
	return nsipc(NSREQ_LISTEN);
}

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  803b61:	55                   	push   %ebp
  803b62:	89 e5                	mov    %esp,%ebp
  803b64:	56                   	push   %esi
  803b65:	53                   	push   %ebx
  803b66:	83 ec 10             	sub    $0x10,%esp
  803b69:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  803b6c:	8b 45 08             	mov    0x8(%ebp),%eax
  803b6f:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.recv.req_len = len;
  803b74:	89 35 04 70 80 00    	mov    %esi,0x807004
	nsipcbuf.recv.req_flags = flags;
  803b7a:	8b 45 14             	mov    0x14(%ebp),%eax
  803b7d:	a3 08 70 80 00       	mov    %eax,0x807008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  803b82:	b8 07 00 00 00       	mov    $0x7,%eax
  803b87:	e8 94 fe ff ff       	call   803a20 <nsipc>
  803b8c:	89 c3                	mov    %eax,%ebx
  803b8e:	85 c0                	test   %eax,%eax
  803b90:	78 46                	js     803bd8 <nsipc_recv+0x77>
		assert(r < 1600 && r <= len);
  803b92:	3d 3f 06 00 00       	cmp    $0x63f,%eax
  803b97:	7f 04                	jg     803b9d <nsipc_recv+0x3c>
  803b99:	39 c6                	cmp    %eax,%esi
  803b9b:	7d 24                	jge    803bc1 <nsipc_recv+0x60>
  803b9d:	c7 44 24 0c 88 4e 80 	movl   $0x804e88,0xc(%esp)
  803ba4:	00 
  803ba5:	c7 44 24 08 cd 44 80 	movl   $0x8044cd,0x8(%esp)
  803bac:	00 
  803bad:	c7 44 24 04 5b 00 00 	movl   $0x5b,0x4(%esp)
  803bb4:	00 
  803bb5:	c7 04 24 7c 4e 80 00 	movl   $0x804e7c,(%esp)
  803bbc:	e8 0f e1 ff ff       	call   801cd0 <_panic>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  803bc1:	89 44 24 08          	mov    %eax,0x8(%esp)
  803bc5:	c7 44 24 04 00 70 80 	movl   $0x807000,0x4(%esp)
  803bcc:	00 
  803bcd:	8b 45 0c             	mov    0xc(%ebp),%eax
  803bd0:	89 04 24             	mov    %eax,(%esp)
  803bd3:	e8 3d ea ff ff       	call   802615 <memmove>
	}

	return r;
}
  803bd8:	89 d8                	mov    %ebx,%eax
  803bda:	83 c4 10             	add    $0x10,%esp
  803bdd:	5b                   	pop    %ebx
  803bde:	5e                   	pop    %esi
  803bdf:	5d                   	pop    %ebp
  803be0:	c3                   	ret    

00803be1 <nsipc_connect>:
	return nsipc(NSREQ_CLOSE);
}

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  803be1:	55                   	push   %ebp
  803be2:	89 e5                	mov    %esp,%ebp
  803be4:	53                   	push   %ebx
  803be5:	83 ec 14             	sub    $0x14,%esp
  803be8:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  803beb:	8b 45 08             	mov    0x8(%ebp),%eax
  803bee:	a3 00 70 80 00       	mov    %eax,0x807000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  803bf3:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  803bf7:	8b 45 0c             	mov    0xc(%ebp),%eax
  803bfa:	89 44 24 04          	mov    %eax,0x4(%esp)
  803bfe:	c7 04 24 04 70 80 00 	movl   $0x807004,(%esp)
  803c05:	e8 0b ea ff ff       	call   802615 <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  803c0a:	89 1d 14 70 80 00    	mov    %ebx,0x807014
	return nsipc(NSREQ_CONNECT);
  803c10:	b8 05 00 00 00       	mov    $0x5,%eax
  803c15:	e8 06 fe ff ff       	call   803a20 <nsipc>
}
  803c1a:	83 c4 14             	add    $0x14,%esp
  803c1d:	5b                   	pop    %ebx
  803c1e:	5d                   	pop    %ebp
  803c1f:	c3                   	ret    

00803c20 <nsipc_bind>:
	return r;
}

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  803c20:	55                   	push   %ebp
  803c21:	89 e5                	mov    %esp,%ebp
  803c23:	53                   	push   %ebx
  803c24:	83 ec 14             	sub    $0x14,%esp
  803c27:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  803c2a:	8b 45 08             	mov    0x8(%ebp),%eax
  803c2d:	a3 00 70 80 00       	mov    %eax,0x807000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  803c32:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  803c36:	8b 45 0c             	mov    0xc(%ebp),%eax
  803c39:	89 44 24 04          	mov    %eax,0x4(%esp)
  803c3d:	c7 04 24 04 70 80 00 	movl   $0x807004,(%esp)
  803c44:	e8 cc e9 ff ff       	call   802615 <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  803c49:	89 1d 14 70 80 00    	mov    %ebx,0x807014
	return nsipc(NSREQ_BIND);
  803c4f:	b8 02 00 00 00       	mov    $0x2,%eax
  803c54:	e8 c7 fd ff ff       	call   803a20 <nsipc>
}
  803c59:	83 c4 14             	add    $0x14,%esp
  803c5c:	5b                   	pop    %ebx
  803c5d:	5d                   	pop    %ebp
  803c5e:	c3                   	ret    

00803c5f <nsipc_accept>:
	return ipc_recv(NULL, NULL, NULL);
}

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  803c5f:	55                   	push   %ebp
  803c60:	89 e5                	mov    %esp,%ebp
  803c62:	83 ec 18             	sub    $0x18,%esp
  803c65:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  803c68:	89 75 fc             	mov    %esi,-0x4(%ebp)
	int r;
	
	nsipcbuf.accept.req_s = s;
  803c6b:	8b 45 08             	mov    0x8(%ebp),%eax
  803c6e:	a3 00 70 80 00       	mov    %eax,0x807000
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  803c73:	b8 01 00 00 00       	mov    $0x1,%eax
  803c78:	e8 a3 fd ff ff       	call   803a20 <nsipc>
  803c7d:	89 c3                	mov    %eax,%ebx
  803c7f:	85 c0                	test   %eax,%eax
  803c81:	78 25                	js     803ca8 <nsipc_accept+0x49>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  803c83:	be 10 70 80 00       	mov    $0x807010,%esi
  803c88:	8b 06                	mov    (%esi),%eax
  803c8a:	89 44 24 08          	mov    %eax,0x8(%esp)
  803c8e:	c7 44 24 04 00 70 80 	movl   $0x807000,0x4(%esp)
  803c95:	00 
  803c96:	8b 45 0c             	mov    0xc(%ebp),%eax
  803c99:	89 04 24             	mov    %eax,(%esp)
  803c9c:	e8 74 e9 ff ff       	call   802615 <memmove>
		*addrlen = ret->ret_addrlen;
  803ca1:	8b 16                	mov    (%esi),%edx
  803ca3:	8b 45 10             	mov    0x10(%ebp),%eax
  803ca6:	89 10                	mov    %edx,(%eax)
	}
	return r;
}
  803ca8:	89 d8                	mov    %ebx,%eax
  803caa:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  803cad:	8b 75 fc             	mov    -0x4(%ebp),%esi
  803cb0:	89 ec                	mov    %ebp,%esp
  803cb2:	5d                   	pop    %ebp
  803cb3:	c3                   	ret    
	...

00803cc0 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  803cc0:	55                   	push   %ebp
  803cc1:	89 e5                	mov    %esp,%ebp
  803cc3:	83 ec 18             	sub    $0x18,%esp
  803cc6:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  803cc9:	89 75 fc             	mov    %esi,-0x4(%ebp)
  803ccc:	8b 75 0c             	mov    0xc(%ebp),%esi
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  803ccf:	8b 45 08             	mov    0x8(%ebp),%eax
  803cd2:	89 04 24             	mov    %eax,(%esp)
  803cd5:	e8 36 f2 ff ff       	call   802f10 <fd2data>
  803cda:	89 c3                	mov    %eax,%ebx
	strcpy(stat->st_name, "<pipe>");
  803cdc:	c7 44 24 04 9d 4e 80 	movl   $0x804e9d,0x4(%esp)
  803ce3:	00 
  803ce4:	89 34 24             	mov    %esi,(%esp)
  803ce7:	e8 6e e7 ff ff       	call   80245a <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  803cec:	8b 43 04             	mov    0x4(%ebx),%eax
  803cef:	2b 03                	sub    (%ebx),%eax
  803cf1:	89 86 80 00 00 00    	mov    %eax,0x80(%esi)
	stat->st_isdir = 0;
  803cf7:	c7 86 84 00 00 00 00 	movl   $0x0,0x84(%esi)
  803cfe:	00 00 00 
	stat->st_dev = &devpipe;
  803d01:	c7 86 88 00 00 00 a0 	movl   $0x80c0a0,0x88(%esi)
  803d08:	c0 80 00 
	return 0;
}
  803d0b:	b8 00 00 00 00       	mov    $0x0,%eax
  803d10:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  803d13:	8b 75 fc             	mov    -0x4(%ebp),%esi
  803d16:	89 ec                	mov    %ebp,%esp
  803d18:	5d                   	pop    %ebp
  803d19:	c3                   	ret    

00803d1a <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  803d1a:	55                   	push   %ebp
  803d1b:	89 e5                	mov    %esp,%ebp
  803d1d:	53                   	push   %ebx
  803d1e:	83 ec 14             	sub    $0x14,%esp
  803d21:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  803d24:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  803d28:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  803d2f:	e8 5b ee ff ff       	call   802b8f <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  803d34:	89 1c 24             	mov    %ebx,(%esp)
  803d37:	e8 d4 f1 ff ff       	call   802f10 <fd2data>
  803d3c:	89 44 24 04          	mov    %eax,0x4(%esp)
  803d40:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  803d47:	e8 43 ee ff ff       	call   802b8f <sys_page_unmap>
}
  803d4c:	83 c4 14             	add    $0x14,%esp
  803d4f:	5b                   	pop    %ebx
  803d50:	5d                   	pop    %ebp
  803d51:	c3                   	ret    

00803d52 <_pipeisclosed>:
	return r;
}

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  803d52:	55                   	push   %ebp
  803d53:	89 e5                	mov    %esp,%ebp
  803d55:	57                   	push   %edi
  803d56:	56                   	push   %esi
  803d57:	53                   	push   %ebx
  803d58:	83 ec 2c             	sub    $0x2c,%esp
  803d5b:	89 c7                	mov    %eax,%edi
  803d5d:	89 55 e4             	mov    %edx,-0x1c(%ebp)
	int n, nn, ret;

	while (1) {
		n = env->env_runs;
  803d60:	a1 e0 c0 80 00       	mov    0x80c0e0,%eax
  803d65:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  803d68:	89 3c 24             	mov    %edi,(%esp)
  803d6b:	e8 20 fa ff ff       	call   803790 <pageref>
  803d70:	89 c6                	mov    %eax,%esi
  803d72:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803d75:	89 04 24             	mov    %eax,(%esp)
  803d78:	e8 13 fa ff ff       	call   803790 <pageref>
  803d7d:	39 c6                	cmp    %eax,%esi
  803d7f:	0f 94 c0             	sete   %al
  803d82:	0f b6 c0             	movzbl %al,%eax
		nn = env->env_runs;
  803d85:	8b 15 e0 c0 80 00    	mov    0x80c0e0,%edx
  803d8b:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  803d8e:	39 cb                	cmp    %ecx,%ebx
  803d90:	75 08                	jne    803d9a <_pipeisclosed+0x48>
			return ret;
		if (n != nn && ret == 1)
			cprintf("pipe race avoided\n", n, env->env_runs, ret);
	}
}
  803d92:	83 c4 2c             	add    $0x2c,%esp
  803d95:	5b                   	pop    %ebx
  803d96:	5e                   	pop    %esi
  803d97:	5f                   	pop    %edi
  803d98:	5d                   	pop    %ebp
  803d99:	c3                   	ret    
		n = env->env_runs;
		ret = pageref(fd) == pageref(p);
		nn = env->env_runs;
		if (n == nn)
			return ret;
		if (n != nn && ret == 1)
  803d9a:	83 f8 01             	cmp    $0x1,%eax
  803d9d:	75 c1                	jne    803d60 <_pipeisclosed+0xe>
			cprintf("pipe race avoided\n", n, env->env_runs, ret);
  803d9f:	8b 52 58             	mov    0x58(%edx),%edx
  803da2:	89 44 24 0c          	mov    %eax,0xc(%esp)
  803da6:	89 54 24 08          	mov    %edx,0x8(%esp)
  803daa:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  803dae:	c7 04 24 a4 4e 80 00 	movl   $0x804ea4,(%esp)
  803db5:	e8 db df ff ff       	call   801d95 <cprintf>
  803dba:	eb a4                	jmp    803d60 <_pipeisclosed+0xe>

00803dbc <devpipe_write>:
	return i;
}

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  803dbc:	55                   	push   %ebp
  803dbd:	89 e5                	mov    %esp,%ebp
  803dbf:	57                   	push   %edi
  803dc0:	56                   	push   %esi
  803dc1:	53                   	push   %ebx
  803dc2:	83 ec 1c             	sub    $0x1c,%esp
  803dc5:	8b 75 08             	mov    0x8(%ebp),%esi
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  803dc8:	89 34 24             	mov    %esi,(%esp)
  803dcb:	e8 40 f1 ff ff       	call   802f10 <fd2data>
  803dd0:	89 c3                	mov    %eax,%ebx
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			env->env_id, vpt[VPN(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  803dd2:	bf 00 00 00 00       	mov    $0x0,%edi
  803dd7:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  803ddb:	75 54                	jne    803e31 <devpipe_write+0x75>
  803ddd:	eb 60                	jmp    803e3f <devpipe_write+0x83>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  803ddf:	89 da                	mov    %ebx,%edx
  803de1:	89 f0                	mov    %esi,%eax
  803de3:	e8 6a ff ff ff       	call   803d52 <_pipeisclosed>
  803de8:	85 c0                	test   %eax,%eax
  803dea:	74 07                	je     803df3 <devpipe_write+0x37>
  803dec:	b8 00 00 00 00       	mov    $0x0,%eax
  803df1:	eb 53                	jmp    803e46 <devpipe_write+0x8a>
				return 0;
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  803df3:	90                   	nop
  803df4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  803df8:	e8 ad ee ff ff       	call   802caa <sys_yield>
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			env->env_id, vpt[VPN(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  803dfd:	8b 43 04             	mov    0x4(%ebx),%eax
  803e00:	8b 13                	mov    (%ebx),%edx
  803e02:	83 c2 20             	add    $0x20,%edx
  803e05:	39 d0                	cmp    %edx,%eax
  803e07:	73 d6                	jae    803ddf <devpipe_write+0x23>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  803e09:	89 c2                	mov    %eax,%edx
  803e0b:	c1 fa 1f             	sar    $0x1f,%edx
  803e0e:	c1 ea 1b             	shr    $0x1b,%edx
  803e11:	01 d0                	add    %edx,%eax
  803e13:	83 e0 1f             	and    $0x1f,%eax
  803e16:	29 d0                	sub    %edx,%eax
  803e18:	89 c2                	mov    %eax,%edx
  803e1a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  803e1d:	0f b6 04 39          	movzbl (%ecx,%edi,1),%eax
  803e21:	88 44 13 08          	mov    %al,0x8(%ebx,%edx,1)
		p->p_wpos++;
  803e25:	83 43 04 01          	addl   $0x1,0x4(%ebx)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			env->env_id, vpt[VPN(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  803e29:	83 c7 01             	add    $0x1,%edi
  803e2c:	39 7d 10             	cmp    %edi,0x10(%ebp)
  803e2f:	76 13                	jbe    803e44 <devpipe_write+0x88>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  803e31:	8b 43 04             	mov    0x4(%ebx),%eax
  803e34:	8b 13                	mov    (%ebx),%edx
  803e36:	83 c2 20             	add    $0x20,%edx
  803e39:	39 d0                	cmp    %edx,%eax
  803e3b:	73 a2                	jae    803ddf <devpipe_write+0x23>
  803e3d:	eb ca                	jmp    803e09 <devpipe_write+0x4d>
  803e3f:	bf 00 00 00 00       	mov    $0x0,%edi
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}
	
	return i;
  803e44:	89 f8                	mov    %edi,%eax
}
  803e46:	83 c4 1c             	add    $0x1c,%esp
  803e49:	5b                   	pop    %ebx
  803e4a:	5e                   	pop    %esi
  803e4b:	5f                   	pop    %edi
  803e4c:	5d                   	pop    %ebp
  803e4d:	c3                   	ret    

00803e4e <devpipe_read>:
	return _pipeisclosed(fd, p);
}

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  803e4e:	55                   	push   %ebp
  803e4f:	89 e5                	mov    %esp,%ebp
  803e51:	83 ec 28             	sub    $0x28,%esp
  803e54:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  803e57:	89 75 f8             	mov    %esi,-0x8(%ebp)
  803e5a:	89 7d fc             	mov    %edi,-0x4(%ebp)
  803e5d:	8b 7d 08             	mov    0x8(%ebp),%edi
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  803e60:	89 3c 24             	mov    %edi,(%esp)
  803e63:	e8 a8 f0 ff ff       	call   802f10 <fd2data>
  803e68:	89 c3                	mov    %eax,%ebx
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			env->env_id, vpt[VPN(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  803e6a:	be 00 00 00 00       	mov    $0x0,%esi
  803e6f:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  803e73:	75 4c                	jne    803ec1 <devpipe_read+0x73>
  803e75:	eb 5b                	jmp    803ed2 <devpipe_read+0x84>
		while (p->p_rpos == p->p_wpos) {
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
				return i;
  803e77:	89 f0                	mov    %esi,%eax
  803e79:	eb 5e                	jmp    803ed9 <devpipe_read+0x8b>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  803e7b:	89 da                	mov    %ebx,%edx
  803e7d:	89 f8                	mov    %edi,%eax
  803e7f:	90                   	nop
  803e80:	e8 cd fe ff ff       	call   803d52 <_pipeisclosed>
  803e85:	85 c0                	test   %eax,%eax
  803e87:	74 07                	je     803e90 <devpipe_read+0x42>
  803e89:	b8 00 00 00 00       	mov    $0x0,%eax
  803e8e:	eb 49                	jmp    803ed9 <devpipe_read+0x8b>
				return 0;
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  803e90:	e8 15 ee ff ff       	call   802caa <sys_yield>
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			env->env_id, vpt[VPN(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  803e95:	8b 03                	mov    (%ebx),%eax
  803e97:	3b 43 04             	cmp    0x4(%ebx),%eax
  803e9a:	74 df                	je     803e7b <devpipe_read+0x2d>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  803e9c:	89 c2                	mov    %eax,%edx
  803e9e:	c1 fa 1f             	sar    $0x1f,%edx
  803ea1:	c1 ea 1b             	shr    $0x1b,%edx
  803ea4:	01 d0                	add    %edx,%eax
  803ea6:	83 e0 1f             	and    $0x1f,%eax
  803ea9:	29 d0                	sub    %edx,%eax
  803eab:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  803eb0:	8b 55 0c             	mov    0xc(%ebp),%edx
  803eb3:	88 04 32             	mov    %al,(%edx,%esi,1)
		p->p_rpos++;
  803eb6:	83 03 01             	addl   $0x1,(%ebx)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			env->env_id, vpt[VPN(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  803eb9:	83 c6 01             	add    $0x1,%esi
  803ebc:	39 75 10             	cmp    %esi,0x10(%ebp)
  803ebf:	76 16                	jbe    803ed7 <devpipe_read+0x89>
		while (p->p_rpos == p->p_wpos) {
  803ec1:	8b 03                	mov    (%ebx),%eax
  803ec3:	3b 43 04             	cmp    0x4(%ebx),%eax
  803ec6:	75 d4                	jne    803e9c <devpipe_read+0x4e>
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  803ec8:	85 f6                	test   %esi,%esi
  803eca:	75 ab                	jne    803e77 <devpipe_read+0x29>
  803ecc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  803ed0:	eb a9                	jmp    803e7b <devpipe_read+0x2d>
  803ed2:	be 00 00 00 00       	mov    $0x0,%esi
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  803ed7:	89 f0                	mov    %esi,%eax
}
  803ed9:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  803edc:	8b 75 f8             	mov    -0x8(%ebp),%esi
  803edf:	8b 7d fc             	mov    -0x4(%ebp),%edi
  803ee2:	89 ec                	mov    %ebp,%esp
  803ee4:	5d                   	pop    %ebp
  803ee5:	c3                   	ret    

00803ee6 <pipeisclosed>:
	}
}

int
pipeisclosed(int fdnum)
{
  803ee6:	55                   	push   %ebp
  803ee7:	89 e5                	mov    %esp,%ebp
  803ee9:	83 ec 28             	sub    $0x28,%esp
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  803eec:	8d 45 f4             	lea    -0xc(%ebp),%eax
  803eef:	89 44 24 04          	mov    %eax,0x4(%esp)
  803ef3:	8b 45 08             	mov    0x8(%ebp),%eax
  803ef6:	89 04 24             	mov    %eax,(%esp)
  803ef9:	e8 9f f0 ff ff       	call   802f9d <fd_lookup>
  803efe:	85 c0                	test   %eax,%eax
  803f00:	78 15                	js     803f17 <pipeisclosed+0x31>
		return r;
	p = (struct Pipe*) fd2data(fd);
  803f02:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803f05:	89 04 24             	mov    %eax,(%esp)
  803f08:	e8 03 f0 ff ff       	call   802f10 <fd2data>
	return _pipeisclosed(fd, p);
  803f0d:	89 c2                	mov    %eax,%edx
  803f0f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803f12:	e8 3b fe ff ff       	call   803d52 <_pipeisclosed>
}
  803f17:	c9                   	leave  
  803f18:	c3                   	ret    

00803f19 <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  803f19:	55                   	push   %ebp
  803f1a:	89 e5                	mov    %esp,%ebp
  803f1c:	83 ec 48             	sub    $0x48,%esp
  803f1f:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  803f22:	89 75 f8             	mov    %esi,-0x8(%ebp)
  803f25:	89 7d fc             	mov    %edi,-0x4(%ebp)
  803f28:	8b 7d 08             	mov    0x8(%ebp),%edi
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  803f2b:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  803f2e:	89 04 24             	mov    %eax,(%esp)
  803f31:	e8 f5 ef ff ff       	call   802f2b <fd_alloc>
  803f36:	89 c3                	mov    %eax,%ebx
  803f38:	85 c0                	test   %eax,%eax
  803f3a:	0f 88 42 01 00 00    	js     804082 <pipe+0x169>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  803f40:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  803f47:	00 
  803f48:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803f4b:	89 44 24 04          	mov    %eax,0x4(%esp)
  803f4f:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  803f56:	e8 f0 ec ff ff       	call   802c4b <sys_page_alloc>
  803f5b:	89 c3                	mov    %eax,%ebx
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  803f5d:	85 c0                	test   %eax,%eax
  803f5f:	0f 88 1d 01 00 00    	js     804082 <pipe+0x169>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  803f65:	8d 45 e0             	lea    -0x20(%ebp),%eax
  803f68:	89 04 24             	mov    %eax,(%esp)
  803f6b:	e8 bb ef ff ff       	call   802f2b <fd_alloc>
  803f70:	89 c3                	mov    %eax,%ebx
  803f72:	85 c0                	test   %eax,%eax
  803f74:	0f 88 f5 00 00 00    	js     80406f <pipe+0x156>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  803f7a:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  803f81:	00 
  803f82:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803f85:	89 44 24 04          	mov    %eax,0x4(%esp)
  803f89:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  803f90:	e8 b6 ec ff ff       	call   802c4b <sys_page_alloc>
  803f95:	89 c3                	mov    %eax,%ebx
	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  803f97:	85 c0                	test   %eax,%eax
  803f99:	0f 88 d0 00 00 00    	js     80406f <pipe+0x156>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  803f9f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803fa2:	89 04 24             	mov    %eax,(%esp)
  803fa5:	e8 66 ef ff ff       	call   802f10 <fd2data>
  803faa:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  803fac:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  803fb3:	00 
  803fb4:	89 44 24 04          	mov    %eax,0x4(%esp)
  803fb8:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  803fbf:	e8 87 ec ff ff       	call   802c4b <sys_page_alloc>
  803fc4:	89 c3                	mov    %eax,%ebx
  803fc6:	85 c0                	test   %eax,%eax
  803fc8:	0f 88 8e 00 00 00    	js     80405c <pipe+0x143>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  803fce:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803fd1:	89 04 24             	mov    %eax,(%esp)
  803fd4:	e8 37 ef ff ff       	call   802f10 <fd2data>
  803fd9:	c7 44 24 10 07 04 00 	movl   $0x407,0x10(%esp)
  803fe0:	00 
  803fe1:	89 44 24 0c          	mov    %eax,0xc(%esp)
  803fe5:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  803fec:	00 
  803fed:	89 74 24 04          	mov    %esi,0x4(%esp)
  803ff1:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  803ff8:	e8 f0 eb ff ff       	call   802bed <sys_page_map>
  803ffd:	89 c3                	mov    %eax,%ebx
  803fff:	85 c0                	test   %eax,%eax
  804001:	78 49                	js     80404c <pipe+0x133>
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  804003:	b8 a0 c0 80 00       	mov    $0x80c0a0,%eax
  804008:	8b 08                	mov    (%eax),%ecx
  80400a:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80400d:	89 0a                	mov    %ecx,(%edx)
	fd0->fd_omode = O_RDONLY;
  80400f:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  804012:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%edx)

	fd1->fd_dev_id = devpipe.dev_id;
  804019:	8b 10                	mov    (%eax),%edx
  80401b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80401e:	89 10                	mov    %edx,(%eax)
	fd1->fd_omode = O_WRONLY;
  804020:	8b 45 e0             	mov    -0x20(%ebp),%eax
  804023:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", env->env_id, vpt[VPN(va)]);

	pfd[0] = fd2num(fd0);
  80402a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80402d:	89 04 24             	mov    %eax,(%esp)
  804030:	e8 cb ee ff ff       	call   802f00 <fd2num>
  804035:	89 07                	mov    %eax,(%edi)
	pfd[1] = fd2num(fd1);
  804037:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80403a:	89 04 24             	mov    %eax,(%esp)
  80403d:	e8 be ee ff ff       	call   802f00 <fd2num>
  804042:	89 47 04             	mov    %eax,0x4(%edi)
  804045:	bb 00 00 00 00       	mov    $0x0,%ebx
	return 0;
  80404a:	eb 36                	jmp    804082 <pipe+0x169>

    err3:
	sys_page_unmap(0, va);
  80404c:	89 74 24 04          	mov    %esi,0x4(%esp)
  804050:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  804057:	e8 33 eb ff ff       	call   802b8f <sys_page_unmap>
    err2:
	sys_page_unmap(0, fd1);
  80405c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80405f:	89 44 24 04          	mov    %eax,0x4(%esp)
  804063:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80406a:	e8 20 eb ff ff       	call   802b8f <sys_page_unmap>
    err1:
	sys_page_unmap(0, fd0);
  80406f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804072:	89 44 24 04          	mov    %eax,0x4(%esp)
  804076:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80407d:	e8 0d eb ff ff       	call   802b8f <sys_page_unmap>
    err:
	return r;
}
  804082:	89 d8                	mov    %ebx,%eax
  804084:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  804087:	8b 75 f8             	mov    -0x8(%ebp),%esi
  80408a:	8b 7d fc             	mov    -0x4(%ebp),%edi
  80408d:	89 ec                	mov    %ebp,%esp
  80408f:	5d                   	pop    %ebp
  804090:	c3                   	ret    
	...

008040a0 <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  8040a0:	55                   	push   %ebp
  8040a1:	89 e5                	mov    %esp,%ebp
	USED(fd);

	return 0;
}
  8040a3:	b8 00 00 00 00       	mov    $0x0,%eax
  8040a8:	5d                   	pop    %ebp
  8040a9:	c3                   	ret    

008040aa <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  8040aa:	55                   	push   %ebp
  8040ab:	89 e5                	mov    %esp,%ebp
  8040ad:	83 ec 18             	sub    $0x18,%esp
	strcpy(stat->st_name, "<cons>");
  8040b0:	c7 44 24 04 bc 4e 80 	movl   $0x804ebc,0x4(%esp)
  8040b7:	00 
  8040b8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8040bb:	89 04 24             	mov    %eax,(%esp)
  8040be:	e8 97 e3 ff ff       	call   80245a <strcpy>
	return 0;
}
  8040c3:	b8 00 00 00 00       	mov    $0x0,%eax
  8040c8:	c9                   	leave  
  8040c9:	c3                   	ret    

008040ca <devcons_write>:
	return 1;
}

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  8040ca:	55                   	push   %ebp
  8040cb:	89 e5                	mov    %esp,%ebp
  8040cd:	57                   	push   %edi
  8040ce:	56                   	push   %esi
  8040cf:	53                   	push   %ebx
  8040d0:	81 ec 9c 00 00 00    	sub    $0x9c,%esp
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs, 
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  8040d6:	b8 00 00 00 00       	mov    $0x0,%eax
  8040db:	be 00 00 00 00       	mov    $0x0,%esi
  8040e0:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8040e4:	74 3f                	je     804125 <devcons_write+0x5b>
		m = n - tot;
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  8040e6:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs, 
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
		m = n - tot;
  8040ec:	8b 55 10             	mov    0x10(%ebp),%edx
  8040ef:	29 c2                	sub    %eax,%edx
  8040f1:	89 d3                	mov    %edx,%ebx
		if (m > sizeof(buf) - 1)
  8040f3:	83 fa 7f             	cmp    $0x7f,%edx
  8040f6:	76 05                	jbe    8040fd <devcons_write+0x33>
  8040f8:	bb 7f 00 00 00       	mov    $0x7f,%ebx
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  8040fd:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  804101:	03 45 0c             	add    0xc(%ebp),%eax
  804104:	89 44 24 04          	mov    %eax,0x4(%esp)
  804108:	89 3c 24             	mov    %edi,(%esp)
  80410b:	e8 05 e5 ff ff       	call   802615 <memmove>
		sys_cputs(buf, m);
  804110:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  804114:	89 3c 24             	mov    %edi,(%esp)
  804117:	e8 34 e7 ff ff       	call   802850 <sys_cputs>
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs, 
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  80411c:	01 de                	add    %ebx,%esi
  80411e:	89 f0                	mov    %esi,%eax
  804120:	3b 75 10             	cmp    0x10(%ebp),%esi
  804123:	72 c7                	jb     8040ec <devcons_write+0x22>
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
}
  804125:	89 f0                	mov    %esi,%eax
  804127:	81 c4 9c 00 00 00    	add    $0x9c,%esp
  80412d:	5b                   	pop    %ebx
  80412e:	5e                   	pop    %esi
  80412f:	5f                   	pop    %edi
  804130:	5d                   	pop    %ebp
  804131:	c3                   	ret    

00804132 <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  804132:	55                   	push   %ebp
  804133:	89 e5                	mov    %esp,%ebp
  804135:	83 ec 28             	sub    $0x28,%esp
	char c = ch;
  804138:	8b 45 08             	mov    0x8(%ebp),%eax
  80413b:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  80413e:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  804145:	00 
  804146:	8d 45 f7             	lea    -0x9(%ebp),%eax
  804149:	89 04 24             	mov    %eax,(%esp)
  80414c:	e8 ff e6 ff ff       	call   802850 <sys_cputs>
}
  804151:	c9                   	leave  
  804152:	c3                   	ret    

00804153 <devcons_read>:
	return fd2num(fd);
}

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  804153:	55                   	push   %ebp
  804154:	89 e5                	mov    %esp,%ebp
  804156:	83 ec 08             	sub    $0x8,%esp
	int c;

	if (n == 0)
  804159:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80415d:	75 07                	jne    804166 <devcons_read+0x13>
  80415f:	eb 28                	jmp    804189 <devcons_read+0x36>
		return 0;

	while ((c = sys_cgetc()) == 0)
		sys_yield();
  804161:	e8 44 eb ff ff       	call   802caa <sys_yield>
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  804166:	66 90                	xchg   %ax,%ax
  804168:	e8 af e6 ff ff       	call   80281c <sys_cgetc>
  80416d:	85 c0                	test   %eax,%eax
  80416f:	90                   	nop
  804170:	74 ef                	je     804161 <devcons_read+0xe>
  804172:	89 c2                	mov    %eax,%edx
		sys_yield();
	if (c < 0)
  804174:	85 c0                	test   %eax,%eax
  804176:	78 16                	js     80418e <devcons_read+0x3b>
		return c;
	if (c == 0x04)	// ctl-d is eof
  804178:	83 f8 04             	cmp    $0x4,%eax
  80417b:	74 0c                	je     804189 <devcons_read+0x36>
		return 0;
	*(char*)vbuf = c;
  80417d:	8b 45 0c             	mov    0xc(%ebp),%eax
  804180:	88 10                	mov    %dl,(%eax)
  804182:	b8 01 00 00 00       	mov    $0x1,%eax
	return 1;
  804187:	eb 05                	jmp    80418e <devcons_read+0x3b>
  804189:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80418e:	c9                   	leave  
  80418f:	c3                   	ret    

00804190 <opencons>:
	return fd->fd_dev_id == devcons.dev_id;
}

int
opencons(void)
{
  804190:	55                   	push   %ebp
  804191:	89 e5                	mov    %esp,%ebp
  804193:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  804196:	8d 45 f4             	lea    -0xc(%ebp),%eax
  804199:	89 04 24             	mov    %eax,(%esp)
  80419c:	e8 8a ed ff ff       	call   802f2b <fd_alloc>
  8041a1:	85 c0                	test   %eax,%eax
  8041a3:	78 3f                	js     8041e4 <opencons+0x54>
		return r;
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  8041a5:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  8041ac:	00 
  8041ad:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8041b0:	89 44 24 04          	mov    %eax,0x4(%esp)
  8041b4:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8041bb:	e8 8b ea ff ff       	call   802c4b <sys_page_alloc>
  8041c0:	85 c0                	test   %eax,%eax
  8041c2:	78 20                	js     8041e4 <opencons+0x54>
		return r;
	fd->fd_dev_id = devcons.dev_id;
  8041c4:	8b 15 bc c0 80 00    	mov    0x80c0bc,%edx
  8041ca:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8041cd:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  8041cf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8041d2:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  8041d9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8041dc:	89 04 24             	mov    %eax,(%esp)
  8041df:	e8 1c ed ff ff       	call   802f00 <fd2num>
}
  8041e4:	c9                   	leave  
  8041e5:	c3                   	ret    

008041e6 <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  8041e6:	55                   	push   %ebp
  8041e7:	89 e5                	mov    %esp,%ebp
  8041e9:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8041ec:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8041ef:	89 44 24 04          	mov    %eax,0x4(%esp)
  8041f3:	8b 45 08             	mov    0x8(%ebp),%eax
  8041f6:	89 04 24             	mov    %eax,(%esp)
  8041f9:	e8 9f ed ff ff       	call   802f9d <fd_lookup>
  8041fe:	85 c0                	test   %eax,%eax
  804200:	78 11                	js     804213 <iscons+0x2d>
		return r;
	return fd->fd_dev_id == devcons.dev_id;
  804202:	8b 45 f4             	mov    -0xc(%ebp),%eax
  804205:	8b 00                	mov    (%eax),%eax
  804207:	3b 05 bc c0 80 00    	cmp    0x80c0bc,%eax
  80420d:	0f 94 c0             	sete   %al
  804210:	0f b6 c0             	movzbl %al,%eax
}
  804213:	c9                   	leave  
  804214:	c3                   	ret    

00804215 <getchar>:
	sys_cputs(&c, 1);
}

int
getchar(void)
{
  804215:	55                   	push   %ebp
  804216:	89 e5                	mov    %esp,%ebp
  804218:	83 ec 28             	sub    $0x28,%esp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  80421b:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  804222:	00 
  804223:	8d 45 f7             	lea    -0x9(%ebp),%eax
  804226:	89 44 24 04          	mov    %eax,0x4(%esp)
  80422a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  804231:	e8 c8 ef ff ff       	call   8031fe <read>
	if (r < 0)
  804236:	85 c0                	test   %eax,%eax
  804238:	78 0f                	js     804249 <getchar+0x34>
		return r;
	if (r < 1)
  80423a:	85 c0                	test   %eax,%eax
  80423c:	7f 07                	jg     804245 <getchar+0x30>
  80423e:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  804243:	eb 04                	jmp    804249 <getchar+0x34>
		return -E_EOF;
	return c;
  804245:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  804249:	c9                   	leave  
  80424a:	c3                   	ret    
  80424b:	00 00                	add    %al,(%eax)
  80424d:	00 00                	add    %al,(%eax)
	...

00804250 <__udivdi3>:
  804250:	55                   	push   %ebp
  804251:	89 e5                	mov    %esp,%ebp
  804253:	57                   	push   %edi
  804254:	56                   	push   %esi
  804255:	83 ec 10             	sub    $0x10,%esp
  804258:	8b 45 14             	mov    0x14(%ebp),%eax
  80425b:	8b 55 08             	mov    0x8(%ebp),%edx
  80425e:	8b 75 10             	mov    0x10(%ebp),%esi
  804261:	8b 7d 0c             	mov    0xc(%ebp),%edi
  804264:	85 c0                	test   %eax,%eax
  804266:	89 55 f0             	mov    %edx,-0x10(%ebp)
  804269:	75 35                	jne    8042a0 <__udivdi3+0x50>
  80426b:	39 fe                	cmp    %edi,%esi
  80426d:	77 61                	ja     8042d0 <__udivdi3+0x80>
  80426f:	85 f6                	test   %esi,%esi
  804271:	75 0b                	jne    80427e <__udivdi3+0x2e>
  804273:	b8 01 00 00 00       	mov    $0x1,%eax
  804278:	31 d2                	xor    %edx,%edx
  80427a:	f7 f6                	div    %esi
  80427c:	89 c6                	mov    %eax,%esi
  80427e:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  804281:	31 d2                	xor    %edx,%edx
  804283:	89 f8                	mov    %edi,%eax
  804285:	f7 f6                	div    %esi
  804287:	89 c7                	mov    %eax,%edi
  804289:	89 c8                	mov    %ecx,%eax
  80428b:	f7 f6                	div    %esi
  80428d:	89 c1                	mov    %eax,%ecx
  80428f:	89 fa                	mov    %edi,%edx
  804291:	89 c8                	mov    %ecx,%eax
  804293:	83 c4 10             	add    $0x10,%esp
  804296:	5e                   	pop    %esi
  804297:	5f                   	pop    %edi
  804298:	5d                   	pop    %ebp
  804299:	c3                   	ret    
  80429a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  8042a0:	39 f8                	cmp    %edi,%eax
  8042a2:	77 1c                	ja     8042c0 <__udivdi3+0x70>
  8042a4:	0f bd d0             	bsr    %eax,%edx
  8042a7:	83 f2 1f             	xor    $0x1f,%edx
  8042aa:	89 55 f4             	mov    %edx,-0xc(%ebp)
  8042ad:	75 39                	jne    8042e8 <__udivdi3+0x98>
  8042af:	3b 75 f0             	cmp    -0x10(%ebp),%esi
  8042b2:	0f 86 a0 00 00 00    	jbe    804358 <__udivdi3+0x108>
  8042b8:	39 f8                	cmp    %edi,%eax
  8042ba:	0f 82 98 00 00 00    	jb     804358 <__udivdi3+0x108>
  8042c0:	31 ff                	xor    %edi,%edi
  8042c2:	31 c9                	xor    %ecx,%ecx
  8042c4:	89 c8                	mov    %ecx,%eax
  8042c6:	89 fa                	mov    %edi,%edx
  8042c8:	83 c4 10             	add    $0x10,%esp
  8042cb:	5e                   	pop    %esi
  8042cc:	5f                   	pop    %edi
  8042cd:	5d                   	pop    %ebp
  8042ce:	c3                   	ret    
  8042cf:	90                   	nop
  8042d0:	89 d1                	mov    %edx,%ecx
  8042d2:	89 fa                	mov    %edi,%edx
  8042d4:	89 c8                	mov    %ecx,%eax
  8042d6:	31 ff                	xor    %edi,%edi
  8042d8:	f7 f6                	div    %esi
  8042da:	89 c1                	mov    %eax,%ecx
  8042dc:	89 fa                	mov    %edi,%edx
  8042de:	89 c8                	mov    %ecx,%eax
  8042e0:	83 c4 10             	add    $0x10,%esp
  8042e3:	5e                   	pop    %esi
  8042e4:	5f                   	pop    %edi
  8042e5:	5d                   	pop    %ebp
  8042e6:	c3                   	ret    
  8042e7:	90                   	nop
  8042e8:	0f b6 4d f4          	movzbl -0xc(%ebp),%ecx
  8042ec:	89 f2                	mov    %esi,%edx
  8042ee:	d3 e0                	shl    %cl,%eax
  8042f0:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8042f3:	b8 20 00 00 00       	mov    $0x20,%eax
  8042f8:	2b 45 f4             	sub    -0xc(%ebp),%eax
  8042fb:	89 c1                	mov    %eax,%ecx
  8042fd:	d3 ea                	shr    %cl,%edx
  8042ff:	0f b6 4d f4          	movzbl -0xc(%ebp),%ecx
  804303:	0b 55 ec             	or     -0x14(%ebp),%edx
  804306:	d3 e6                	shl    %cl,%esi
  804308:	89 c1                	mov    %eax,%ecx
  80430a:	89 75 e8             	mov    %esi,-0x18(%ebp)
  80430d:	89 fe                	mov    %edi,%esi
  80430f:	d3 ee                	shr    %cl,%esi
  804311:	0f b6 4d f4          	movzbl -0xc(%ebp),%ecx
  804315:	89 55 ec             	mov    %edx,-0x14(%ebp)
  804318:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80431b:	d3 e7                	shl    %cl,%edi
  80431d:	89 c1                	mov    %eax,%ecx
  80431f:	d3 ea                	shr    %cl,%edx
  804321:	09 d7                	or     %edx,%edi
  804323:	89 f2                	mov    %esi,%edx
  804325:	89 f8                	mov    %edi,%eax
  804327:	f7 75 ec             	divl   -0x14(%ebp)
  80432a:	89 d6                	mov    %edx,%esi
  80432c:	89 c7                	mov    %eax,%edi
  80432e:	f7 65 e8             	mull   -0x18(%ebp)
  804331:	39 d6                	cmp    %edx,%esi
  804333:	89 55 ec             	mov    %edx,-0x14(%ebp)
  804336:	72 30                	jb     804368 <__udivdi3+0x118>
  804338:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80433b:	0f b6 4d f4          	movzbl -0xc(%ebp),%ecx
  80433f:	d3 e2                	shl    %cl,%edx
  804341:	39 c2                	cmp    %eax,%edx
  804343:	73 05                	jae    80434a <__udivdi3+0xfa>
  804345:	3b 75 ec             	cmp    -0x14(%ebp),%esi
  804348:	74 1e                	je     804368 <__udivdi3+0x118>
  80434a:	89 f9                	mov    %edi,%ecx
  80434c:	31 ff                	xor    %edi,%edi
  80434e:	e9 71 ff ff ff       	jmp    8042c4 <__udivdi3+0x74>
  804353:	90                   	nop
  804354:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  804358:	31 ff                	xor    %edi,%edi
  80435a:	b9 01 00 00 00       	mov    $0x1,%ecx
  80435f:	e9 60 ff ff ff       	jmp    8042c4 <__udivdi3+0x74>
  804364:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  804368:	8d 4f ff             	lea    -0x1(%edi),%ecx
  80436b:	31 ff                	xor    %edi,%edi
  80436d:	89 c8                	mov    %ecx,%eax
  80436f:	89 fa                	mov    %edi,%edx
  804371:	83 c4 10             	add    $0x10,%esp
  804374:	5e                   	pop    %esi
  804375:	5f                   	pop    %edi
  804376:	5d                   	pop    %ebp
  804377:	c3                   	ret    
	...

00804380 <__umoddi3>:
  804380:	55                   	push   %ebp
  804381:	89 e5                	mov    %esp,%ebp
  804383:	57                   	push   %edi
  804384:	56                   	push   %esi
  804385:	83 ec 20             	sub    $0x20,%esp
  804388:	8b 55 14             	mov    0x14(%ebp),%edx
  80438b:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80438e:	8b 7d 10             	mov    0x10(%ebp),%edi
  804391:	8b 75 0c             	mov    0xc(%ebp),%esi
  804394:	85 d2                	test   %edx,%edx
  804396:	89 c8                	mov    %ecx,%eax
  804398:	89 4d f4             	mov    %ecx,-0xc(%ebp)
  80439b:	75 13                	jne    8043b0 <__umoddi3+0x30>
  80439d:	39 f7                	cmp    %esi,%edi
  80439f:	76 3f                	jbe    8043e0 <__umoddi3+0x60>
  8043a1:	89 f2                	mov    %esi,%edx
  8043a3:	f7 f7                	div    %edi
  8043a5:	89 d0                	mov    %edx,%eax
  8043a7:	31 d2                	xor    %edx,%edx
  8043a9:	83 c4 20             	add    $0x20,%esp
  8043ac:	5e                   	pop    %esi
  8043ad:	5f                   	pop    %edi
  8043ae:	5d                   	pop    %ebp
  8043af:	c3                   	ret    
  8043b0:	39 f2                	cmp    %esi,%edx
  8043b2:	77 4c                	ja     804400 <__umoddi3+0x80>
  8043b4:	0f bd ca             	bsr    %edx,%ecx
  8043b7:	83 f1 1f             	xor    $0x1f,%ecx
  8043ba:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  8043bd:	75 51                	jne    804410 <__umoddi3+0x90>
  8043bf:	3b 7d f4             	cmp    -0xc(%ebp),%edi
  8043c2:	0f 87 e0 00 00 00    	ja     8044a8 <__umoddi3+0x128>
  8043c8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8043cb:	29 f8                	sub    %edi,%eax
  8043cd:	19 d6                	sbb    %edx,%esi
  8043cf:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8043d2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8043d5:	89 f2                	mov    %esi,%edx
  8043d7:	83 c4 20             	add    $0x20,%esp
  8043da:	5e                   	pop    %esi
  8043db:	5f                   	pop    %edi
  8043dc:	5d                   	pop    %ebp
  8043dd:	c3                   	ret    
  8043de:	66 90                	xchg   %ax,%ax
  8043e0:	85 ff                	test   %edi,%edi
  8043e2:	75 0b                	jne    8043ef <__umoddi3+0x6f>
  8043e4:	b8 01 00 00 00       	mov    $0x1,%eax
  8043e9:	31 d2                	xor    %edx,%edx
  8043eb:	f7 f7                	div    %edi
  8043ed:	89 c7                	mov    %eax,%edi
  8043ef:	89 f0                	mov    %esi,%eax
  8043f1:	31 d2                	xor    %edx,%edx
  8043f3:	f7 f7                	div    %edi
  8043f5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8043f8:	f7 f7                	div    %edi
  8043fa:	eb a9                	jmp    8043a5 <__umoddi3+0x25>
  8043fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  804400:	89 c8                	mov    %ecx,%eax
  804402:	89 f2                	mov    %esi,%edx
  804404:	83 c4 20             	add    $0x20,%esp
  804407:	5e                   	pop    %esi
  804408:	5f                   	pop    %edi
  804409:	5d                   	pop    %ebp
  80440a:	c3                   	ret    
  80440b:	90                   	nop
  80440c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  804410:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
  804414:	d3 e2                	shl    %cl,%edx
  804416:	89 55 f4             	mov    %edx,-0xc(%ebp)
  804419:	ba 20 00 00 00       	mov    $0x20,%edx
  80441e:	2b 55 f0             	sub    -0x10(%ebp),%edx
  804421:	89 55 ec             	mov    %edx,-0x14(%ebp)
  804424:	0f b6 4d ec          	movzbl -0x14(%ebp),%ecx
  804428:	89 fa                	mov    %edi,%edx
  80442a:	d3 ea                	shr    %cl,%edx
  80442c:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
  804430:	0b 55 f4             	or     -0xc(%ebp),%edx
  804433:	d3 e7                	shl    %cl,%edi
  804435:	0f b6 4d ec          	movzbl -0x14(%ebp),%ecx
  804439:	89 55 f4             	mov    %edx,-0xc(%ebp)
  80443c:	89 f2                	mov    %esi,%edx
  80443e:	89 7d e8             	mov    %edi,-0x18(%ebp)
  804441:	89 c7                	mov    %eax,%edi
  804443:	d3 ea                	shr    %cl,%edx
  804445:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
  804449:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  80444c:	89 c2                	mov    %eax,%edx
  80444e:	d3 e6                	shl    %cl,%esi
  804450:	0f b6 4d ec          	movzbl -0x14(%ebp),%ecx
  804454:	d3 ea                	shr    %cl,%edx
  804456:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
  80445a:	09 d6                	or     %edx,%esi
  80445c:	89 f0                	mov    %esi,%eax
  80445e:	8b 75 e4             	mov    -0x1c(%ebp),%esi
  804461:	d3 e7                	shl    %cl,%edi
  804463:	89 f2                	mov    %esi,%edx
  804465:	f7 75 f4             	divl   -0xc(%ebp)
  804468:	89 d6                	mov    %edx,%esi
  80446a:	f7 65 e8             	mull   -0x18(%ebp)
  80446d:	39 d6                	cmp    %edx,%esi
  80446f:	72 2b                	jb     80449c <__umoddi3+0x11c>
  804471:	39 c7                	cmp    %eax,%edi
  804473:	72 23                	jb     804498 <__umoddi3+0x118>
  804475:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
  804479:	29 c7                	sub    %eax,%edi
  80447b:	19 d6                	sbb    %edx,%esi
  80447d:	89 f0                	mov    %esi,%eax
  80447f:	89 f2                	mov    %esi,%edx
  804481:	d3 ef                	shr    %cl,%edi
  804483:	0f b6 4d ec          	movzbl -0x14(%ebp),%ecx
  804487:	d3 e0                	shl    %cl,%eax
  804489:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
  80448d:	09 f8                	or     %edi,%eax
  80448f:	d3 ea                	shr    %cl,%edx
  804491:	83 c4 20             	add    $0x20,%esp
  804494:	5e                   	pop    %esi
  804495:	5f                   	pop    %edi
  804496:	5d                   	pop    %ebp
  804497:	c3                   	ret    
  804498:	39 d6                	cmp    %edx,%esi
  80449a:	75 d9                	jne    804475 <__umoddi3+0xf5>
  80449c:	2b 45 e8             	sub    -0x18(%ebp),%eax
  80449f:	1b 55 f4             	sbb    -0xc(%ebp),%edx
  8044a2:	eb d1                	jmp    804475 <__umoddi3+0xf5>
  8044a4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  8044a8:	39 f2                	cmp    %esi,%edx
  8044aa:	0f 82 18 ff ff ff    	jb     8043c8 <__umoddi3+0x48>
  8044b0:	e9 1d ff ff ff       	jmp    8043d2 <__umoddi3+0x52>
