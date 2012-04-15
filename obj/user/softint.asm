
obj/user/softint:     file format elf32-i386


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
  80002c:	e8 0b 00 00 00       	call   80003c <libmain>
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
	asm volatile("int $14");	// page fault
  800037:	cd 0e                	int    $0xe
}
  800039:	5d                   	pop    %ebp
  80003a:	c3                   	ret    
	...

0080003c <libmain>:
volatile struct Env *env;
char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  80003c:	55                   	push   %ebp
  80003d:	89 e5                	mov    %esp,%ebp
  80003f:	83 ec 18             	sub    $0x18,%esp
  800042:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  800045:	89 75 fc             	mov    %esi,-0x4(%ebp)
  800048:	8b 75 08             	mov    0x8(%ebp),%esi
  80004b:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	// set env to point at our env structure in envs[].
	// LAB 3b: Your code here.
	// Code added by Swastika / Sandeep	
	envid_t envid = sys_getenvid();
  80004e:	e8 17 05 00 00       	call   80056a <sys_getenvid>
	env = &envs[ENVX(envid)];
  800053:	25 ff 03 00 00       	and    $0x3ff,%eax
  800058:	6b c0 7c             	imul   $0x7c,%eax,%eax
  80005b:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800060:	a3 74 60 80 00       	mov    %eax,0x806074

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800065:	85 f6                	test   %esi,%esi
  800067:	7e 07                	jle    800070 <libmain+0x34>
		binaryname = argv[0];
  800069:	8b 03                	mov    (%ebx),%eax
  80006b:	a3 00 60 80 00       	mov    %eax,0x806000

	// call user main routine
	umain(argc, argv);
  800070:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  800074:	89 34 24             	mov    %esi,(%esp)
  800077:	e8 b8 ff ff ff       	call   800034 <umain>

	// exit gracefully
	exit();
  80007c:	e8 0b 00 00 00       	call   80008c <exit>
}
  800081:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  800084:	8b 75 fc             	mov    -0x4(%ebp),%esi
  800087:	89 ec                	mov    %ebp,%esp
  800089:	5d                   	pop    %ebp
  80008a:	c3                   	ret    
	...

0080008c <exit>:
#include <inc/lib.h>

void
exit(void)
{
  80008c:	55                   	push   %ebp
  80008d:	89 e5                	mov    %esp,%ebp
  80008f:	83 ec 18             	sub    $0x18,%esp
	close_all();
  800092:	e8 44 0a 00 00       	call   800adb <close_all>
	sys_env_destroy(0);
  800097:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80009e:	e8 fb 04 00 00       	call   80059e <sys_env_destroy>
}
  8000a3:	c9                   	leave  
  8000a4:	c3                   	ret    
  8000a5:	00 00                	add    %al,(%eax)
	...

008000a8 <sys_cgetc>:
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}

int
sys_cgetc(void)
{
  8000a8:	55                   	push   %ebp
  8000a9:	89 e5                	mov    %esp,%ebp
  8000ab:	83 ec 0c             	sub    $0xc,%esp
  8000ae:	89 1c 24             	mov    %ebx,(%esp)
  8000b1:	89 74 24 04          	mov    %esi,0x4(%esp)
  8000b5:	89 7c 24 08          	mov    %edi,0x8(%esp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8000b9:	ba 00 00 00 00       	mov    $0x0,%edx
  8000be:	b8 01 00 00 00       	mov    $0x1,%eax
  8000c3:	89 d1                	mov    %edx,%ecx
  8000c5:	89 d3                	mov    %edx,%ebx
  8000c7:	89 d7                	mov    %edx,%edi
  8000c9:	89 d6                	mov    %edx,%esi
  8000cb:	cd 30                	int    $0x30

int
sys_cgetc(void)
{
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  8000cd:	8b 1c 24             	mov    (%esp),%ebx
  8000d0:	8b 74 24 04          	mov    0x4(%esp),%esi
  8000d4:	8b 7c 24 08          	mov    0x8(%esp),%edi
  8000d8:	89 ec                	mov    %ebp,%esp
  8000da:	5d                   	pop    %ebp
  8000db:	c3                   	ret    

008000dc <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  8000dc:	55                   	push   %ebp
  8000dd:	89 e5                	mov    %esp,%ebp
  8000df:	83 ec 0c             	sub    $0xc,%esp
  8000e2:	89 1c 24             	mov    %ebx,(%esp)
  8000e5:	89 74 24 04          	mov    %esi,0x4(%esp)
  8000e9:	89 7c 24 08          	mov    %edi,0x8(%esp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8000ed:	b8 00 00 00 00       	mov    $0x0,%eax
  8000f2:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8000f5:	8b 55 08             	mov    0x8(%ebp),%edx
  8000f8:	89 c3                	mov    %eax,%ebx
  8000fa:	89 c7                	mov    %eax,%edi
  8000fc:	89 c6                	mov    %eax,%esi
  8000fe:	cd 30                	int    $0x30

void
sys_cputs(const char *s, size_t len)
{
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800100:	8b 1c 24             	mov    (%esp),%ebx
  800103:	8b 74 24 04          	mov    0x4(%esp),%esi
  800107:	8b 7c 24 08          	mov    0x8(%esp),%edi
  80010b:	89 ec                	mov    %ebp,%esp
  80010d:	5d                   	pop    %ebp
  80010e:	c3                   	ret    

0080010f <sys_page_insert>:
{
	return syscall(SYS_page_waste, 0, (uint32_t)p, (uint32_t)n, 0, 0,0);
}
int
sys_page_insert(envid_t envid, void *va, struct Page *p, int perm)
{
  80010f:	55                   	push   %ebp
  800110:	89 e5                	mov    %esp,%ebp
  800112:	83 ec 38             	sub    $0x38,%esp
  800115:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800118:	89 75 f8             	mov    %esi,-0x8(%ebp)
  80011b:	89 7d fc             	mov    %edi,-0x4(%ebp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80011e:	be 00 00 00 00       	mov    $0x0,%esi
  800123:	b8 12 00 00 00       	mov    $0x12,%eax
  800128:	8b 7d 14             	mov    0x14(%ebp),%edi
  80012b:	8b 5d 10             	mov    0x10(%ebp),%ebx
  80012e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800131:	8b 55 08             	mov    0x8(%ebp),%edx
  800134:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
	
	if(check && ret > 0)
  800136:	85 c0                	test   %eax,%eax
  800138:	7e 28                	jle    800162 <sys_page_insert+0x53>
		panic("syscall %d returned %d (> 0)", num, ret);
  80013a:	89 44 24 10          	mov    %eax,0x10(%esp)
  80013e:	c7 44 24 0c 12 00 00 	movl   $0x12,0xc(%esp)
  800145:	00 
  800146:	c7 44 24 08 f7 27 80 	movl   $0x8027f7,0x8(%esp)
  80014d:	00 
  80014e:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800155:	00 
  800156:	c7 04 24 14 28 80 00 	movl   $0x802814,(%esp)
  80015d:	e8 9a 17 00 00       	call   8018fc <_panic>
}
int
sys_page_insert(envid_t envid, void *va, struct Page *p, int perm)
{
	return syscall(SYS_page_insert, 1, envid, (uint32_t) va, (uint32_t)p, perm, 0);
}
  800162:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800165:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800168:	8b 7d fc             	mov    -0x4(%ebp),%edi
  80016b:	89 ec                	mov    %ebp,%esp
  80016d:	5d                   	pop    %ebp
  80016e:	c3                   	ret    

0080016f <sys_page_waste>:
{
	return (int)syscall(SYS_receive_packet, 0, (uint32_t)buffer, 0,0,0,0);
}

int sys_page_waste(struct Page **p, int n)
{
  80016f:	55                   	push   %ebp
  800170:	89 e5                	mov    %esp,%ebp
  800172:	83 ec 0c             	sub    $0xc,%esp
  800175:	89 1c 24             	mov    %ebx,(%esp)
  800178:	89 74 24 04          	mov    %esi,0x4(%esp)
  80017c:	89 7c 24 08          	mov    %edi,0x8(%esp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800180:	bb 00 00 00 00       	mov    $0x0,%ebx
  800185:	b8 11 00 00 00       	mov    $0x11,%eax
  80018a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80018d:	8b 55 08             	mov    0x8(%ebp),%edx
  800190:	89 df                	mov    %ebx,%edi
  800192:	89 de                	mov    %ebx,%esi
  800194:	cd 30                	int    $0x30
}

int sys_page_waste(struct Page **p, int n)
{
	return syscall(SYS_page_waste, 0, (uint32_t)p, (uint32_t)n, 0, 0,0);
}
  800196:	8b 1c 24             	mov    (%esp),%ebx
  800199:	8b 74 24 04          	mov    0x4(%esp),%esi
  80019d:	8b 7c 24 08          	mov    0x8(%esp),%edi
  8001a1:	89 ec                	mov    %ebp,%esp
  8001a3:	5d                   	pop    %ebp
  8001a4:	c3                   	ret    

008001a5 <sys_receive_packet>:
{
	return (int)syscall(SYS_transmit_packet, 1, (uint32_t)data, len, 0,0,0);
}

int sys_receive_packet(void* buffer)
{
  8001a5:	55                   	push   %ebp
  8001a6:	89 e5                	mov    %esp,%ebp
  8001a8:	83 ec 0c             	sub    $0xc,%esp
  8001ab:	89 1c 24             	mov    %ebx,(%esp)
  8001ae:	89 74 24 04          	mov    %esi,0x4(%esp)
  8001b2:	89 7c 24 08          	mov    %edi,0x8(%esp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8001b6:	b9 00 00 00 00       	mov    $0x0,%ecx
  8001bb:	b8 10 00 00 00       	mov    $0x10,%eax
  8001c0:	8b 55 08             	mov    0x8(%ebp),%edx
  8001c3:	89 cb                	mov    %ecx,%ebx
  8001c5:	89 cf                	mov    %ecx,%edi
  8001c7:	89 ce                	mov    %ecx,%esi
  8001c9:	cd 30                	int    $0x30
}

int sys_receive_packet(void* buffer)
{
	return (int)syscall(SYS_receive_packet, 0, (uint32_t)buffer, 0,0,0,0);
}
  8001cb:	8b 1c 24             	mov    (%esp),%ebx
  8001ce:	8b 74 24 04          	mov    0x4(%esp),%esi
  8001d2:	8b 7c 24 08          	mov    0x8(%esp),%edi
  8001d6:	89 ec                	mov    %ebp,%esp
  8001d8:	5d                   	pop    %ebp
  8001d9:	c3                   	ret    

008001da <sys_transmit_packet>:
{
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0,0);
}

int sys_transmit_packet(void* data, uint32_t len)
{
  8001da:	55                   	push   %ebp
  8001db:	89 e5                	mov    %esp,%ebp
  8001dd:	83 ec 38             	sub    $0x38,%esp
  8001e0:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  8001e3:	89 75 f8             	mov    %esi,-0x8(%ebp)
  8001e6:	89 7d fc             	mov    %edi,-0x4(%ebp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8001e9:	bb 00 00 00 00       	mov    $0x0,%ebx
  8001ee:	b8 0f 00 00 00       	mov    $0xf,%eax
  8001f3:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8001f6:	8b 55 08             	mov    0x8(%ebp),%edx
  8001f9:	89 df                	mov    %ebx,%edi
  8001fb:	89 de                	mov    %ebx,%esi
  8001fd:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
	
	if(check && ret > 0)
  8001ff:	85 c0                	test   %eax,%eax
  800201:	7e 28                	jle    80022b <sys_transmit_packet+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  800203:	89 44 24 10          	mov    %eax,0x10(%esp)
  800207:	c7 44 24 0c 0f 00 00 	movl   $0xf,0xc(%esp)
  80020e:	00 
  80020f:	c7 44 24 08 f7 27 80 	movl   $0x8027f7,0x8(%esp)
  800216:	00 
  800217:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  80021e:	00 
  80021f:	c7 04 24 14 28 80 00 	movl   $0x802814,(%esp)
  800226:	e8 d1 16 00 00       	call   8018fc <_panic>
}

int sys_transmit_packet(void* data, uint32_t len)
{
	return (int)syscall(SYS_transmit_packet, 1, (uint32_t)data, len, 0,0,0);
}
  80022b:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  80022e:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800231:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800234:	89 ec                	mov    %ebp,%esp
  800236:	5d                   	pop    %ebp
  800237:	c3                   	ret    

00800238 <sys_time_msec>:
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}

unsigned int
sys_time_msec(void)
{
  800238:	55                   	push   %ebp
  800239:	89 e5                	mov    %esp,%ebp
  80023b:	83 ec 0c             	sub    $0xc,%esp
  80023e:	89 1c 24             	mov    %ebx,(%esp)
  800241:	89 74 24 04          	mov    %esi,0x4(%esp)
  800245:	89 7c 24 08          	mov    %edi,0x8(%esp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800249:	ba 00 00 00 00       	mov    $0x0,%edx
  80024e:	b8 0e 00 00 00       	mov    $0xe,%eax
  800253:	89 d1                	mov    %edx,%ecx
  800255:	89 d3                	mov    %edx,%ebx
  800257:	89 d7                	mov    %edx,%edi
  800259:	89 d6                	mov    %edx,%esi
  80025b:	cd 30                	int    $0x30

unsigned int
sys_time_msec(void)
{
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0,0);
}
  80025d:	8b 1c 24             	mov    (%esp),%ebx
  800260:	8b 74 24 04          	mov    0x4(%esp),%esi
  800264:	8b 7c 24 08          	mov    0x8(%esp),%edi
  800268:	89 ec                	mov    %ebp,%esp
  80026a:	5d                   	pop    %ebp
  80026b:	c3                   	ret    

0080026c <sys_ipc_recv>:
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}

int
sys_ipc_recv(void *dstva)
{
  80026c:	55                   	push   %ebp
  80026d:	89 e5                	mov    %esp,%ebp
  80026f:	83 ec 38             	sub    $0x38,%esp
  800272:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800275:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800278:	89 7d fc             	mov    %edi,-0x4(%ebp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80027b:	b9 00 00 00 00       	mov    $0x0,%ecx
  800280:	b8 0d 00 00 00       	mov    $0xd,%eax
  800285:	8b 55 08             	mov    0x8(%ebp),%edx
  800288:	89 cb                	mov    %ecx,%ebx
  80028a:	89 cf                	mov    %ecx,%edi
  80028c:	89 ce                	mov    %ecx,%esi
  80028e:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
	
	if(check && ret > 0)
  800290:	85 c0                	test   %eax,%eax
  800292:	7e 28                	jle    8002bc <sys_ipc_recv+0x50>
		panic("syscall %d returned %d (> 0)", num, ret);
  800294:	89 44 24 10          	mov    %eax,0x10(%esp)
  800298:	c7 44 24 0c 0d 00 00 	movl   $0xd,0xc(%esp)
  80029f:	00 
  8002a0:	c7 44 24 08 f7 27 80 	movl   $0x8027f7,0x8(%esp)
  8002a7:	00 
  8002a8:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  8002af:	00 
  8002b0:	c7 04 24 14 28 80 00 	movl   $0x802814,(%esp)
  8002b7:	e8 40 16 00 00       	call   8018fc <_panic>

int
sys_ipc_recv(void *dstva)
{
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  8002bc:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  8002bf:	8b 75 f8             	mov    -0x8(%ebp),%esi
  8002c2:	8b 7d fc             	mov    -0x4(%ebp),%edi
  8002c5:	89 ec                	mov    %ebp,%esp
  8002c7:	5d                   	pop    %ebp
  8002c8:	c3                   	ret    

008002c9 <sys_ipc_try_send>:
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  8002c9:	55                   	push   %ebp
  8002ca:	89 e5                	mov    %esp,%ebp
  8002cc:	83 ec 0c             	sub    $0xc,%esp
  8002cf:	89 1c 24             	mov    %ebx,(%esp)
  8002d2:	89 74 24 04          	mov    %esi,0x4(%esp)
  8002d6:	89 7c 24 08          	mov    %edi,0x8(%esp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8002da:	be 00 00 00 00       	mov    $0x0,%esi
  8002df:	b8 0c 00 00 00       	mov    $0xc,%eax
  8002e4:	8b 7d 14             	mov    0x14(%ebp),%edi
  8002e7:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8002ea:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8002ed:	8b 55 08             	mov    0x8(%ebp),%edx
  8002f0:	cd 30                	int    $0x30

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  8002f2:	8b 1c 24             	mov    (%esp),%ebx
  8002f5:	8b 74 24 04          	mov    0x4(%esp),%esi
  8002f9:	8b 7c 24 08          	mov    0x8(%esp),%edi
  8002fd:	89 ec                	mov    %ebp,%esp
  8002ff:	5d                   	pop    %ebp
  800300:	c3                   	ret    

00800301 <sys_env_set_pgfault_upcall>:
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800301:	55                   	push   %ebp
  800302:	89 e5                	mov    %esp,%ebp
  800304:	83 ec 38             	sub    $0x38,%esp
  800307:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  80030a:	89 75 f8             	mov    %esi,-0x8(%ebp)
  80030d:	89 7d fc             	mov    %edi,-0x4(%ebp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800310:	bb 00 00 00 00       	mov    $0x0,%ebx
  800315:	b8 0a 00 00 00       	mov    $0xa,%eax
  80031a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80031d:	8b 55 08             	mov    0x8(%ebp),%edx
  800320:	89 df                	mov    %ebx,%edi
  800322:	89 de                	mov    %ebx,%esi
  800324:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
	
	if(check && ret > 0)
  800326:	85 c0                	test   %eax,%eax
  800328:	7e 28                	jle    800352 <sys_env_set_pgfault_upcall+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  80032a:	89 44 24 10          	mov    %eax,0x10(%esp)
  80032e:	c7 44 24 0c 0a 00 00 	movl   $0xa,0xc(%esp)
  800335:	00 
  800336:	c7 44 24 08 f7 27 80 	movl   $0x8027f7,0x8(%esp)
  80033d:	00 
  80033e:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800345:	00 
  800346:	c7 04 24 14 28 80 00 	movl   $0x802814,(%esp)
  80034d:	e8 aa 15 00 00       	call   8018fc <_panic>

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  800352:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800355:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800358:	8b 7d fc             	mov    -0x4(%ebp),%edi
  80035b:	89 ec                	mov    %ebp,%esp
  80035d:	5d                   	pop    %ebp
  80035e:	c3                   	ret    

0080035f <sys_env_set_trapframe>:
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  80035f:	55                   	push   %ebp
  800360:	89 e5                	mov    %esp,%ebp
  800362:	83 ec 38             	sub    $0x38,%esp
  800365:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800368:	89 75 f8             	mov    %esi,-0x8(%ebp)
  80036b:	89 7d fc             	mov    %edi,-0x4(%ebp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80036e:	bb 00 00 00 00       	mov    $0x0,%ebx
  800373:	b8 09 00 00 00       	mov    $0x9,%eax
  800378:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80037b:	8b 55 08             	mov    0x8(%ebp),%edx
  80037e:	89 df                	mov    %ebx,%edi
  800380:	89 de                	mov    %ebx,%esi
  800382:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
	
	if(check && ret > 0)
  800384:	85 c0                	test   %eax,%eax
  800386:	7e 28                	jle    8003b0 <sys_env_set_trapframe+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  800388:	89 44 24 10          	mov    %eax,0x10(%esp)
  80038c:	c7 44 24 0c 09 00 00 	movl   $0x9,0xc(%esp)
  800393:	00 
  800394:	c7 44 24 08 f7 27 80 	movl   $0x8027f7,0x8(%esp)
  80039b:	00 
  80039c:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  8003a3:	00 
  8003a4:	c7 04 24 14 28 80 00 	movl   $0x802814,(%esp)
  8003ab:	e8 4c 15 00 00       	call   8018fc <_panic>

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  8003b0:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  8003b3:	8b 75 f8             	mov    -0x8(%ebp),%esi
  8003b6:	8b 7d fc             	mov    -0x4(%ebp),%edi
  8003b9:	89 ec                	mov    %ebp,%esp
  8003bb:	5d                   	pop    %ebp
  8003bc:	c3                   	ret    

008003bd <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  8003bd:	55                   	push   %ebp
  8003be:	89 e5                	mov    %esp,%ebp
  8003c0:	83 ec 38             	sub    $0x38,%esp
  8003c3:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  8003c6:	89 75 f8             	mov    %esi,-0x8(%ebp)
  8003c9:	89 7d fc             	mov    %edi,-0x4(%ebp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8003cc:	bb 00 00 00 00       	mov    $0x0,%ebx
  8003d1:	b8 08 00 00 00       	mov    $0x8,%eax
  8003d6:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8003d9:	8b 55 08             	mov    0x8(%ebp),%edx
  8003dc:	89 df                	mov    %ebx,%edi
  8003de:	89 de                	mov    %ebx,%esi
  8003e0:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
	
	if(check && ret > 0)
  8003e2:	85 c0                	test   %eax,%eax
  8003e4:	7e 28                	jle    80040e <sys_env_set_status+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  8003e6:	89 44 24 10          	mov    %eax,0x10(%esp)
  8003ea:	c7 44 24 0c 08 00 00 	movl   $0x8,0xc(%esp)
  8003f1:	00 
  8003f2:	c7 44 24 08 f7 27 80 	movl   $0x8027f7,0x8(%esp)
  8003f9:	00 
  8003fa:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800401:	00 
  800402:	c7 04 24 14 28 80 00 	movl   $0x802814,(%esp)
  800409:	e8 ee 14 00 00       	call   8018fc <_panic>

int
sys_env_set_status(envid_t envid, int status)
{
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  80040e:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800411:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800414:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800417:	89 ec                	mov    %ebp,%esp
  800419:	5d                   	pop    %ebp
  80041a:	c3                   	ret    

0080041b <sys_page_unmap>:
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}

int
sys_page_unmap(envid_t envid, void *va)
{
  80041b:	55                   	push   %ebp
  80041c:	89 e5                	mov    %esp,%ebp
  80041e:	83 ec 38             	sub    $0x38,%esp
  800421:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800424:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800427:	89 7d fc             	mov    %edi,-0x4(%ebp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80042a:	bb 00 00 00 00       	mov    $0x0,%ebx
  80042f:	b8 06 00 00 00       	mov    $0x6,%eax
  800434:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800437:	8b 55 08             	mov    0x8(%ebp),%edx
  80043a:	89 df                	mov    %ebx,%edi
  80043c:	89 de                	mov    %ebx,%esi
  80043e:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
	
	if(check && ret > 0)
  800440:	85 c0                	test   %eax,%eax
  800442:	7e 28                	jle    80046c <sys_page_unmap+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  800444:	89 44 24 10          	mov    %eax,0x10(%esp)
  800448:	c7 44 24 0c 06 00 00 	movl   $0x6,0xc(%esp)
  80044f:	00 
  800450:	c7 44 24 08 f7 27 80 	movl   $0x8027f7,0x8(%esp)
  800457:	00 
  800458:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  80045f:	00 
  800460:	c7 04 24 14 28 80 00 	movl   $0x802814,(%esp)
  800467:	e8 90 14 00 00       	call   8018fc <_panic>

int
sys_page_unmap(envid_t envid, void *va)
{
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  80046c:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  80046f:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800472:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800475:	89 ec                	mov    %ebp,%esp
  800477:	5d                   	pop    %ebp
  800478:	c3                   	ret    

00800479 <sys_page_map>:
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800479:	55                   	push   %ebp
  80047a:	89 e5                	mov    %esp,%ebp
  80047c:	83 ec 38             	sub    $0x38,%esp
  80047f:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800482:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800485:	89 7d fc             	mov    %edi,-0x4(%ebp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800488:	b8 05 00 00 00       	mov    $0x5,%eax
  80048d:	8b 75 18             	mov    0x18(%ebp),%esi
  800490:	8b 7d 14             	mov    0x14(%ebp),%edi
  800493:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800496:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800499:	8b 55 08             	mov    0x8(%ebp),%edx
  80049c:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
	
	if(check && ret > 0)
  80049e:	85 c0                	test   %eax,%eax
  8004a0:	7e 28                	jle    8004ca <sys_page_map+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  8004a2:	89 44 24 10          	mov    %eax,0x10(%esp)
  8004a6:	c7 44 24 0c 05 00 00 	movl   $0x5,0xc(%esp)
  8004ad:	00 
  8004ae:	c7 44 24 08 f7 27 80 	movl   $0x8027f7,0x8(%esp)
  8004b5:	00 
  8004b6:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  8004bd:	00 
  8004be:	c7 04 24 14 28 80 00 	movl   $0x802814,(%esp)
  8004c5:	e8 32 14 00 00       	call   8018fc <_panic>

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  8004ca:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  8004cd:	8b 75 f8             	mov    -0x8(%ebp),%esi
  8004d0:	8b 7d fc             	mov    -0x4(%ebp),%edi
  8004d3:	89 ec                	mov    %ebp,%esp
  8004d5:	5d                   	pop    %ebp
  8004d6:	c3                   	ret    

008004d7 <sys_page_alloc>:
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  8004d7:	55                   	push   %ebp
  8004d8:	89 e5                	mov    %esp,%ebp
  8004da:	83 ec 38             	sub    $0x38,%esp
  8004dd:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  8004e0:	89 75 f8             	mov    %esi,-0x8(%ebp)
  8004e3:	89 7d fc             	mov    %edi,-0x4(%ebp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8004e6:	be 00 00 00 00       	mov    $0x0,%esi
  8004eb:	b8 04 00 00 00       	mov    $0x4,%eax
  8004f0:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8004f3:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8004f6:	8b 55 08             	mov    0x8(%ebp),%edx
  8004f9:	89 f7                	mov    %esi,%edi
  8004fb:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
	
	if(check && ret > 0)
  8004fd:	85 c0                	test   %eax,%eax
  8004ff:	7e 28                	jle    800529 <sys_page_alloc+0x52>
		panic("syscall %d returned %d (> 0)", num, ret);
  800501:	89 44 24 10          	mov    %eax,0x10(%esp)
  800505:	c7 44 24 0c 04 00 00 	movl   $0x4,0xc(%esp)
  80050c:	00 
  80050d:	c7 44 24 08 f7 27 80 	movl   $0x8027f7,0x8(%esp)
  800514:	00 
  800515:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  80051c:	00 
  80051d:	c7 04 24 14 28 80 00 	movl   $0x802814,(%esp)
  800524:	e8 d3 13 00 00       	call   8018fc <_panic>

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800529:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  80052c:	8b 75 f8             	mov    -0x8(%ebp),%esi
  80052f:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800532:	89 ec                	mov    %ebp,%esp
  800534:	5d                   	pop    %ebp
  800535:	c3                   	ret    

00800536 <sys_yield>:
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}

void
sys_yield(void)
{
  800536:	55                   	push   %ebp
  800537:	89 e5                	mov    %esp,%ebp
  800539:	83 ec 0c             	sub    $0xc,%esp
  80053c:	89 1c 24             	mov    %ebx,(%esp)
  80053f:	89 74 24 04          	mov    %esi,0x4(%esp)
  800543:	89 7c 24 08          	mov    %edi,0x8(%esp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800547:	ba 00 00 00 00       	mov    $0x0,%edx
  80054c:	b8 0b 00 00 00       	mov    $0xb,%eax
  800551:	89 d1                	mov    %edx,%ecx
  800553:	89 d3                	mov    %edx,%ebx
  800555:	89 d7                	mov    %edx,%edi
  800557:	89 d6                	mov    %edx,%esi
  800559:	cd 30                	int    $0x30

void
sys_yield(void)
{
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  80055b:	8b 1c 24             	mov    (%esp),%ebx
  80055e:	8b 74 24 04          	mov    0x4(%esp),%esi
  800562:	8b 7c 24 08          	mov    0x8(%esp),%edi
  800566:	89 ec                	mov    %ebp,%esp
  800568:	5d                   	pop    %ebp
  800569:	c3                   	ret    

0080056a <sys_getenvid>:
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}

envid_t
sys_getenvid(void)
{
  80056a:	55                   	push   %ebp
  80056b:	89 e5                	mov    %esp,%ebp
  80056d:	83 ec 0c             	sub    $0xc,%esp
  800570:	89 1c 24             	mov    %ebx,(%esp)
  800573:	89 74 24 04          	mov    %esi,0x4(%esp)
  800577:	89 7c 24 08          	mov    %edi,0x8(%esp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80057b:	ba 00 00 00 00       	mov    $0x0,%edx
  800580:	b8 02 00 00 00       	mov    $0x2,%eax
  800585:	89 d1                	mov    %edx,%ecx
  800587:	89 d3                	mov    %edx,%ebx
  800589:	89 d7                	mov    %edx,%edi
  80058b:	89 d6                	mov    %edx,%esi
  80058d:	cd 30                	int    $0x30

envid_t
sys_getenvid(void)
{
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  80058f:	8b 1c 24             	mov    (%esp),%ebx
  800592:	8b 74 24 04          	mov    0x4(%esp),%esi
  800596:	8b 7c 24 08          	mov    0x8(%esp),%edi
  80059a:	89 ec                	mov    %ebp,%esp
  80059c:	5d                   	pop    %ebp
  80059d:	c3                   	ret    

0080059e <sys_env_destroy>:
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}

int
sys_env_destroy(envid_t envid)
{
  80059e:	55                   	push   %ebp
  80059f:	89 e5                	mov    %esp,%ebp
  8005a1:	83 ec 38             	sub    $0x38,%esp
  8005a4:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  8005a7:	89 75 f8             	mov    %esi,-0x8(%ebp)
  8005aa:	89 7d fc             	mov    %edi,-0x4(%ebp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8005ad:	b9 00 00 00 00       	mov    $0x0,%ecx
  8005b2:	b8 03 00 00 00       	mov    $0x3,%eax
  8005b7:	8b 55 08             	mov    0x8(%ebp),%edx
  8005ba:	89 cb                	mov    %ecx,%ebx
  8005bc:	89 cf                	mov    %ecx,%edi
  8005be:	89 ce                	mov    %ecx,%esi
  8005c0:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
	
	if(check && ret > 0)
  8005c2:	85 c0                	test   %eax,%eax
  8005c4:	7e 28                	jle    8005ee <sys_env_destroy+0x50>
		panic("syscall %d returned %d (> 0)", num, ret);
  8005c6:	89 44 24 10          	mov    %eax,0x10(%esp)
  8005ca:	c7 44 24 0c 03 00 00 	movl   $0x3,0xc(%esp)
  8005d1:	00 
  8005d2:	c7 44 24 08 f7 27 80 	movl   $0x8027f7,0x8(%esp)
  8005d9:	00 
  8005da:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  8005e1:	00 
  8005e2:	c7 04 24 14 28 80 00 	movl   $0x802814,(%esp)
  8005e9:	e8 0e 13 00 00       	call   8018fc <_panic>

int
sys_env_destroy(envid_t envid)
{
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  8005ee:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  8005f1:	8b 75 f8             	mov    -0x8(%ebp),%esi
  8005f4:	8b 7d fc             	mov    -0x4(%ebp),%edi
  8005f7:	89 ec                	mov    %ebp,%esp
  8005f9:	5d                   	pop    %ebp
  8005fa:	c3                   	ret    
  8005fb:	00 00                	add    %al,(%eax)
  8005fd:	00 00                	add    %al,(%eax)
	...

00800600 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  800600:	55                   	push   %ebp
  800601:	89 e5                	mov    %esp,%ebp
  800603:	8b 45 08             	mov    0x8(%ebp),%eax
  800606:	05 00 00 00 30       	add    $0x30000000,%eax
  80060b:	c1 e8 0c             	shr    $0xc,%eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
}
  80060e:	5d                   	pop    %ebp
  80060f:	c3                   	ret    

00800610 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  800610:	55                   	push   %ebp
  800611:	89 e5                	mov    %esp,%ebp
  800613:	83 ec 04             	sub    $0x4,%esp
	return INDEX2DATA(fd2num(fd));
  800616:	8b 45 08             	mov    0x8(%ebp),%eax
  800619:	89 04 24             	mov    %eax,(%esp)
  80061c:	e8 df ff ff ff       	call   800600 <fd2num>
  800621:	05 20 00 0d 00       	add    $0xd0020,%eax
  800626:	c1 e0 0c             	shl    $0xc,%eax
}
  800629:	c9                   	leave  
  80062a:	c3                   	ret    

0080062b <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  80062b:	55                   	push   %ebp
  80062c:	89 e5                	mov    %esp,%ebp
  80062e:	57                   	push   %edi
  80062f:	56                   	push   %esi
  800630:	53                   	push   %ebx
  800631:	8b 7d 08             	mov    0x8(%ebp),%edi
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((vpd[PDX(fd)] & PTE_P) == 0 || (vpt[VPN(fd)] & PTE_P) == 0) {
  800634:	a1 00 dd 7b ef       	mov    0xef7bdd00,%eax
  800639:	a8 01                	test   $0x1,%al
  80063b:	74 36                	je     800673 <fd_alloc+0x48>
  80063d:	a1 00 00 74 ef       	mov    0xef740000,%eax
  800642:	a8 01                	test   $0x1,%al
  800644:	74 2d                	je     800673 <fd_alloc+0x48>
  800646:	b8 00 10 00 d0       	mov    $0xd0001000,%eax
  80064b:	b9 00 d0 7b ef       	mov    $0xef7bd000,%ecx
  800650:	be 00 00 40 ef       	mov    $0xef400000,%esi
  800655:	89 c3                	mov    %eax,%ebx
  800657:	89 c2                	mov    %eax,%edx
  800659:	c1 ea 16             	shr    $0x16,%edx
  80065c:	8b 14 91             	mov    (%ecx,%edx,4),%edx
  80065f:	f6 c2 01             	test   $0x1,%dl
  800662:	74 14                	je     800678 <fd_alloc+0x4d>
  800664:	89 c2                	mov    %eax,%edx
  800666:	c1 ea 0c             	shr    $0xc,%edx
  800669:	8b 14 96             	mov    (%esi,%edx,4),%edx
  80066c:	f6 c2 01             	test   $0x1,%dl
  80066f:	75 10                	jne    800681 <fd_alloc+0x56>
  800671:	eb 05                	jmp    800678 <fd_alloc+0x4d>
  800673:	bb 00 00 00 d0       	mov    $0xd0000000,%ebx
			*fd_store = fd;
  800678:	89 1f                	mov    %ebx,(%edi)
  80067a:	b8 00 00 00 00       	mov    $0x0,%eax
			return 0;
  80067f:	eb 17                	jmp    800698 <fd_alloc+0x6d>
  800681:	05 00 10 00 00       	add    $0x1000,%eax
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  800686:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  80068b:	75 c8                	jne    800655 <fd_alloc+0x2a>
		if ((vpd[PDX(fd)] & PTE_P) == 0 || (vpt[VPN(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  80068d:	c7 07 00 00 00 00    	movl   $0x0,(%edi)
  800693:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
	return -E_MAX_OPEN;
}
  800698:	5b                   	pop    %ebx
  800699:	5e                   	pop    %esi
  80069a:	5f                   	pop    %edi
  80069b:	5d                   	pop    %ebp
  80069c:	c3                   	ret    

0080069d <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  80069d:	55                   	push   %ebp
  80069e:	89 e5                	mov    %esp,%ebp
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  8006a0:	8b 45 08             	mov    0x8(%ebp),%eax
  8006a3:	83 f8 1f             	cmp    $0x1f,%eax
  8006a6:	77 36                	ja     8006de <fd_lookup+0x41>
		if (debug)
			cprintf("[%08x] bad fd %d\n", env->env_id, fd);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  8006a8:	05 00 00 0d 00       	add    $0xd0000,%eax
  8006ad:	c1 e0 0c             	shl    $0xc,%eax
	if (!(vpd[PDX(fd)] & PTE_P) || !(vpt[VPN(fd)] & PTE_P)) {
  8006b0:	89 c2                	mov    %eax,%edx
  8006b2:	c1 ea 16             	shr    $0x16,%edx
  8006b5:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  8006bc:	f6 c2 01             	test   $0x1,%dl
  8006bf:	74 1d                	je     8006de <fd_lookup+0x41>
  8006c1:	89 c2                	mov    %eax,%edx
  8006c3:	c1 ea 0c             	shr    $0xc,%edx
  8006c6:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8006cd:	f6 c2 01             	test   $0x1,%dl
  8006d0:	74 0c                	je     8006de <fd_lookup+0x41>
		if (debug)
			cprintf("[%08x] closed fd %d\n", env->env_id, fd);
		return -E_INVAL;
	}
	*fd_store = fd;
  8006d2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8006d5:	89 02                	mov    %eax,(%edx)
  8006d7:	b8 00 00 00 00       	mov    $0x0,%eax
	return 0;
  8006dc:	eb 05                	jmp    8006e3 <fd_lookup+0x46>
  8006de:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  8006e3:	5d                   	pop    %ebp
  8006e4:	c3                   	ret    

008006e5 <seek>:
	return (*dev->dev_write)(fd, buf, n);
}

int
seek(int fdnum, off_t offset)
{
  8006e5:	55                   	push   %ebp
  8006e6:	89 e5                	mov    %esp,%ebp
  8006e8:	83 ec 18             	sub    $0x18,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8006eb:	8d 45 fc             	lea    -0x4(%ebp),%eax
  8006ee:	89 44 24 04          	mov    %eax,0x4(%esp)
  8006f2:	8b 45 08             	mov    0x8(%ebp),%eax
  8006f5:	89 04 24             	mov    %eax,(%esp)
  8006f8:	e8 a0 ff ff ff       	call   80069d <fd_lookup>
  8006fd:	85 c0                	test   %eax,%eax
  8006ff:	78 0e                	js     80070f <seek+0x2a>
		return r;
	fd->fd_offset = offset;
  800701:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800704:	8b 55 0c             	mov    0xc(%ebp),%edx
  800707:	89 50 04             	mov    %edx,0x4(%eax)
  80070a:	b8 00 00 00 00       	mov    $0x0,%eax
	return 0;
}
  80070f:	c9                   	leave  
  800710:	c3                   	ret    

00800711 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  800711:	55                   	push   %ebp
  800712:	89 e5                	mov    %esp,%ebp
  800714:	56                   	push   %esi
  800715:	53                   	push   %ebx
  800716:	83 ec 10             	sub    $0x10,%esp
  800719:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80071c:	8b 5d 0c             	mov    0xc(%ebp),%ebx
// File functions
// --------------------------------------------------------------

static struct Dev *devtab[] =
{
	&devfile,
  80071f:	b8 04 60 80 00       	mov    $0x806004,%eax
{
	int i;
	for (i = 0; devtab[i]; i++)
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
  800724:	ba 00 00 00 00       	mov    $0x0,%edx

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  800729:	be a0 28 80 00       	mov    $0x8028a0,%esi
		if (devtab[i]->dev_id == dev_id) {
  80072e:	39 08                	cmp    %ecx,(%eax)
  800730:	75 10                	jne    800742 <dev_lookup+0x31>
  800732:	eb 04                	jmp    800738 <dev_lookup+0x27>
  800734:	39 08                	cmp    %ecx,(%eax)
  800736:	75 0a                	jne    800742 <dev_lookup+0x31>
			*dev = devtab[i];
  800738:	89 03                	mov    %eax,(%ebx)
  80073a:	b8 00 00 00 00       	mov    $0x0,%eax
			return 0;
  80073f:	90                   	nop
  800740:	eb 31                	jmp    800773 <dev_lookup+0x62>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  800742:	83 c2 01             	add    $0x1,%edx
  800745:	8b 04 96             	mov    (%esi,%edx,4),%eax
  800748:	85 c0                	test   %eax,%eax
  80074a:	75 e8                	jne    800734 <dev_lookup+0x23>
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", env->env_id, dev_id);
  80074c:	a1 74 60 80 00       	mov    0x806074,%eax
  800751:	8b 40 4c             	mov    0x4c(%eax),%eax
  800754:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  800758:	89 44 24 04          	mov    %eax,0x4(%esp)
  80075c:	c7 04 24 24 28 80 00 	movl   $0x802824,(%esp)
  800763:	e8 59 12 00 00       	call   8019c1 <cprintf>
	*dev = 0;
  800768:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  80076e:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
	return -E_INVAL;
}
  800773:	83 c4 10             	add    $0x10,%esp
  800776:	5b                   	pop    %ebx
  800777:	5e                   	pop    %esi
  800778:	5d                   	pop    %ebp
  800779:	c3                   	ret    

0080077a <fstat>:
	return (*dev->dev_trunc)(fd, newsize);
}

int
fstat(int fdnum, struct Stat *stat)
{
  80077a:	55                   	push   %ebp
  80077b:	89 e5                	mov    %esp,%ebp
  80077d:	53                   	push   %ebx
  80077e:	83 ec 24             	sub    $0x24,%esp
  800781:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  800784:	8d 45 f0             	lea    -0x10(%ebp),%eax
  800787:	89 44 24 04          	mov    %eax,0x4(%esp)
  80078b:	8b 45 08             	mov    0x8(%ebp),%eax
  80078e:	89 04 24             	mov    %eax,(%esp)
  800791:	e8 07 ff ff ff       	call   80069d <fd_lookup>
  800796:	85 c0                	test   %eax,%eax
  800798:	78 53                	js     8007ed <fstat+0x73>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80079a:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80079d:	89 44 24 04          	mov    %eax,0x4(%esp)
  8007a1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8007a4:	8b 00                	mov    (%eax),%eax
  8007a6:	89 04 24             	mov    %eax,(%esp)
  8007a9:	e8 63 ff ff ff       	call   800711 <dev_lookup>
{
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8007ae:	85 c0                	test   %eax,%eax
  8007b0:	78 3b                	js     8007ed <fstat+0x73>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if (!dev->dev_stat)
  8007b2:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8007b7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8007ba:	83 7a 14 00          	cmpl   $0x0,0x14(%edx)
  8007be:	74 2d                	je     8007ed <fstat+0x73>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  8007c0:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  8007c3:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  8007ca:	00 00 00 
	stat->st_isdir = 0;
  8007cd:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  8007d4:	00 00 00 
	stat->st_dev = dev;
  8007d7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8007da:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  8007e0:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8007e4:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8007e7:	89 14 24             	mov    %edx,(%esp)
  8007ea:	ff 50 14             	call   *0x14(%eax)
}
  8007ed:	83 c4 24             	add    $0x24,%esp
  8007f0:	5b                   	pop    %ebx
  8007f1:	5d                   	pop    %ebp
  8007f2:	c3                   	ret    

008007f3 <ftruncate>:
	return 0;
}

int
ftruncate(int fdnum, off_t newsize)
{
  8007f3:	55                   	push   %ebp
  8007f4:	89 e5                	mov    %esp,%ebp
  8007f6:	53                   	push   %ebx
  8007f7:	83 ec 24             	sub    $0x24,%esp
  8007fa:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  8007fd:	8d 45 f0             	lea    -0x10(%ebp),%eax
  800800:	89 44 24 04          	mov    %eax,0x4(%esp)
  800804:	89 1c 24             	mov    %ebx,(%esp)
  800807:	e8 91 fe ff ff       	call   80069d <fd_lookup>
  80080c:	85 c0                	test   %eax,%eax
  80080e:	78 5f                	js     80086f <ftruncate+0x7c>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  800810:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800813:	89 44 24 04          	mov    %eax,0x4(%esp)
  800817:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80081a:	8b 00                	mov    (%eax),%eax
  80081c:	89 04 24             	mov    %eax,(%esp)
  80081f:	e8 ed fe ff ff       	call   800711 <dev_lookup>
ftruncate(int fdnum, off_t newsize)
{
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  800824:	85 c0                	test   %eax,%eax
  800826:	78 47                	js     80086f <ftruncate+0x7c>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  800828:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80082b:	f6 42 08 03          	testb  $0x3,0x8(%edx)
  80082f:	75 23                	jne    800854 <ftruncate+0x61>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			env->env_id, fdnum); 
  800831:	a1 74 60 80 00       	mov    0x806074,%eax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  800836:	8b 40 4c             	mov    0x4c(%eax),%eax
  800839:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80083d:	89 44 24 04          	mov    %eax,0x4(%esp)
  800841:	c7 04 24 44 28 80 00 	movl   $0x802844,(%esp)
  800848:	e8 74 11 00 00       	call   8019c1 <cprintf>
  80084d:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
			env->env_id, fdnum); 
		return -E_INVAL;
  800852:	eb 1b                	jmp    80086f <ftruncate+0x7c>
	}
	if (!dev->dev_trunc)
  800854:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800857:	8b 48 18             	mov    0x18(%eax),%ecx
  80085a:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  80085f:	85 c9                	test   %ecx,%ecx
  800861:	74 0c                	je     80086f <ftruncate+0x7c>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  800863:	8b 45 0c             	mov    0xc(%ebp),%eax
  800866:	89 44 24 04          	mov    %eax,0x4(%esp)
  80086a:	89 14 24             	mov    %edx,(%esp)
  80086d:	ff d1                	call   *%ecx
}
  80086f:	83 c4 24             	add    $0x24,%esp
  800872:	5b                   	pop    %ebx
  800873:	5d                   	pop    %ebp
  800874:	c3                   	ret    

00800875 <write>:
	return tot;
}

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  800875:	55                   	push   %ebp
  800876:	89 e5                	mov    %esp,%ebp
  800878:	53                   	push   %ebx
  800879:	83 ec 24             	sub    $0x24,%esp
  80087c:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80087f:	8d 45 f0             	lea    -0x10(%ebp),%eax
  800882:	89 44 24 04          	mov    %eax,0x4(%esp)
  800886:	89 1c 24             	mov    %ebx,(%esp)
  800889:	e8 0f fe ff ff       	call   80069d <fd_lookup>
  80088e:	85 c0                	test   %eax,%eax
  800890:	78 66                	js     8008f8 <write+0x83>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  800892:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800895:	89 44 24 04          	mov    %eax,0x4(%esp)
  800899:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80089c:	8b 00                	mov    (%eax),%eax
  80089e:	89 04 24             	mov    %eax,(%esp)
  8008a1:	e8 6b fe ff ff       	call   800711 <dev_lookup>
{
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8008a6:	85 c0                	test   %eax,%eax
  8008a8:	78 4e                	js     8008f8 <write+0x83>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8008aa:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8008ad:	f6 42 08 03          	testb  $0x3,0x8(%edx)
  8008b1:	75 23                	jne    8008d6 <write+0x61>
		cprintf("[%08x] write %d -- bad mode\n", env->env_id, fdnum);
  8008b3:	a1 74 60 80 00       	mov    0x806074,%eax
  8008b8:	8b 40 4c             	mov    0x4c(%eax),%eax
  8008bb:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8008bf:	89 44 24 04          	mov    %eax,0x4(%esp)
  8008c3:	c7 04 24 65 28 80 00 	movl   $0x802865,(%esp)
  8008ca:	e8 f2 10 00 00       	call   8019c1 <cprintf>
  8008cf:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
		return -E_INVAL;
  8008d4:	eb 22                	jmp    8008f8 <write+0x83>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  8008d6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8008d9:	8b 48 0c             	mov    0xc(%eax),%ecx
  8008dc:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8008e1:	85 c9                	test   %ecx,%ecx
  8008e3:	74 13                	je     8008f8 <write+0x83>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  8008e5:	8b 45 10             	mov    0x10(%ebp),%eax
  8008e8:	89 44 24 08          	mov    %eax,0x8(%esp)
  8008ec:	8b 45 0c             	mov    0xc(%ebp),%eax
  8008ef:	89 44 24 04          	mov    %eax,0x4(%esp)
  8008f3:	89 14 24             	mov    %edx,(%esp)
  8008f6:	ff d1                	call   *%ecx
}
  8008f8:	83 c4 24             	add    $0x24,%esp
  8008fb:	5b                   	pop    %ebx
  8008fc:	5d                   	pop    %ebp
  8008fd:	c3                   	ret    

008008fe <read>:
	return r;
}

ssize_t
read(int fdnum, void *buf, size_t n)
{
  8008fe:	55                   	push   %ebp
  8008ff:	89 e5                	mov    %esp,%ebp
  800901:	53                   	push   %ebx
  800902:	83 ec 24             	sub    $0x24,%esp
  800905:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  800908:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80090b:	89 44 24 04          	mov    %eax,0x4(%esp)
  80090f:	89 1c 24             	mov    %ebx,(%esp)
  800912:	e8 86 fd ff ff       	call   80069d <fd_lookup>
  800917:	85 c0                	test   %eax,%eax
  800919:	78 6b                	js     800986 <read+0x88>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80091b:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80091e:	89 44 24 04          	mov    %eax,0x4(%esp)
  800922:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800925:	8b 00                	mov    (%eax),%eax
  800927:	89 04 24             	mov    %eax,(%esp)
  80092a:	e8 e2 fd ff ff       	call   800711 <dev_lookup>
{
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80092f:	85 c0                	test   %eax,%eax
  800931:	78 53                	js     800986 <read+0x88>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  800933:	8b 55 f0             	mov    -0x10(%ebp),%edx
  800936:	8b 42 08             	mov    0x8(%edx),%eax
  800939:	83 e0 03             	and    $0x3,%eax
  80093c:	83 f8 01             	cmp    $0x1,%eax
  80093f:	75 23                	jne    800964 <read+0x66>
		cprintf("[%08x] read %d -- bad mode\n", env->env_id, fdnum); 
  800941:	a1 74 60 80 00       	mov    0x806074,%eax
  800946:	8b 40 4c             	mov    0x4c(%eax),%eax
  800949:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80094d:	89 44 24 04          	mov    %eax,0x4(%esp)
  800951:	c7 04 24 82 28 80 00 	movl   $0x802882,(%esp)
  800958:	e8 64 10 00 00       	call   8019c1 <cprintf>
  80095d:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
		return -E_INVAL;
  800962:	eb 22                	jmp    800986 <read+0x88>
	}
	if (!dev->dev_read)
  800964:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800967:	8b 48 08             	mov    0x8(%eax),%ecx
  80096a:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  80096f:	85 c9                	test   %ecx,%ecx
  800971:	74 13                	je     800986 <read+0x88>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  800973:	8b 45 10             	mov    0x10(%ebp),%eax
  800976:	89 44 24 08          	mov    %eax,0x8(%esp)
  80097a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80097d:	89 44 24 04          	mov    %eax,0x4(%esp)
  800981:	89 14 24             	mov    %edx,(%esp)
  800984:	ff d1                	call   *%ecx
}
  800986:	83 c4 24             	add    $0x24,%esp
  800989:	5b                   	pop    %ebx
  80098a:	5d                   	pop    %ebp
  80098b:	c3                   	ret    

0080098c <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  80098c:	55                   	push   %ebp
  80098d:	89 e5                	mov    %esp,%ebp
  80098f:	57                   	push   %edi
  800990:	56                   	push   %esi
  800991:	53                   	push   %ebx
  800992:	83 ec 1c             	sub    $0x1c,%esp
  800995:	8b 7d 08             	mov    0x8(%ebp),%edi
  800998:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  80099b:	ba 00 00 00 00       	mov    $0x0,%edx
  8009a0:	bb 00 00 00 00       	mov    $0x0,%ebx
  8009a5:	b8 00 00 00 00       	mov    $0x0,%eax
  8009aa:	85 f6                	test   %esi,%esi
  8009ac:	74 29                	je     8009d7 <readn+0x4b>
		m = read(fdnum, (char*)buf + tot, n - tot);
  8009ae:	89 f0                	mov    %esi,%eax
  8009b0:	29 d0                	sub    %edx,%eax
  8009b2:	89 44 24 08          	mov    %eax,0x8(%esp)
  8009b6:	03 55 0c             	add    0xc(%ebp),%edx
  8009b9:	89 54 24 04          	mov    %edx,0x4(%esp)
  8009bd:	89 3c 24             	mov    %edi,(%esp)
  8009c0:	e8 39 ff ff ff       	call   8008fe <read>
		if (m < 0)
  8009c5:	85 c0                	test   %eax,%eax
  8009c7:	78 0e                	js     8009d7 <readn+0x4b>
			return m;
		if (m == 0)
  8009c9:	85 c0                	test   %eax,%eax
  8009cb:	74 08                	je     8009d5 <readn+0x49>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  8009cd:	01 c3                	add    %eax,%ebx
  8009cf:	89 da                	mov    %ebx,%edx
  8009d1:	39 f3                	cmp    %esi,%ebx
  8009d3:	72 d9                	jb     8009ae <readn+0x22>
  8009d5:	89 d8                	mov    %ebx,%eax
			return m;
		if (m == 0)
			break;
	}
	return tot;
}
  8009d7:	83 c4 1c             	add    $0x1c,%esp
  8009da:	5b                   	pop    %ebx
  8009db:	5e                   	pop    %esi
  8009dc:	5f                   	pop    %edi
  8009dd:	5d                   	pop    %ebp
  8009de:	c3                   	ret    

008009df <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  8009df:	55                   	push   %ebp
  8009e0:	89 e5                	mov    %esp,%ebp
  8009e2:	56                   	push   %esi
  8009e3:	53                   	push   %ebx
  8009e4:	83 ec 20             	sub    $0x20,%esp
  8009e7:	8b 75 08             	mov    0x8(%ebp),%esi
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8009ea:	89 34 24             	mov    %esi,(%esp)
  8009ed:	e8 0e fc ff ff       	call   800600 <fd2num>
  8009f2:	8d 55 f4             	lea    -0xc(%ebp),%edx
  8009f5:	89 54 24 04          	mov    %edx,0x4(%esp)
  8009f9:	89 04 24             	mov    %eax,(%esp)
  8009fc:	e8 9c fc ff ff       	call   80069d <fd_lookup>
  800a01:	89 c3                	mov    %eax,%ebx
  800a03:	85 c0                	test   %eax,%eax
  800a05:	78 05                	js     800a0c <fd_close+0x2d>
  800a07:	3b 75 f4             	cmp    -0xc(%ebp),%esi
  800a0a:	74 0c                	je     800a18 <fd_close+0x39>
	    || fd != fd2)
		return (must_exist ? r : 0);
  800a0c:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800a10:	19 c0                	sbb    %eax,%eax
  800a12:	f7 d0                	not    %eax
  800a14:	21 c3                	and    %eax,%ebx
  800a16:	eb 3d                	jmp    800a55 <fd_close+0x76>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  800a18:	8d 45 f0             	lea    -0x10(%ebp),%eax
  800a1b:	89 44 24 04          	mov    %eax,0x4(%esp)
  800a1f:	8b 06                	mov    (%esi),%eax
  800a21:	89 04 24             	mov    %eax,(%esp)
  800a24:	e8 e8 fc ff ff       	call   800711 <dev_lookup>
  800a29:	89 c3                	mov    %eax,%ebx
  800a2b:	85 c0                	test   %eax,%eax
  800a2d:	78 16                	js     800a45 <fd_close+0x66>
		if (dev->dev_close)
  800a2f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800a32:	8b 40 10             	mov    0x10(%eax),%eax
  800a35:	bb 00 00 00 00       	mov    $0x0,%ebx
  800a3a:	85 c0                	test   %eax,%eax
  800a3c:	74 07                	je     800a45 <fd_close+0x66>
			r = (*dev->dev_close)(fd);
  800a3e:	89 34 24             	mov    %esi,(%esp)
  800a41:	ff d0                	call   *%eax
  800a43:	89 c3                	mov    %eax,%ebx
		else
			r = 0;
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  800a45:	89 74 24 04          	mov    %esi,0x4(%esp)
  800a49:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  800a50:	e8 c6 f9 ff ff       	call   80041b <sys_page_unmap>
	return r;
}
  800a55:	89 d8                	mov    %ebx,%eax
  800a57:	83 c4 20             	add    $0x20,%esp
  800a5a:	5b                   	pop    %ebx
  800a5b:	5e                   	pop    %esi
  800a5c:	5d                   	pop    %ebp
  800a5d:	c3                   	ret    

00800a5e <close>:
	return -E_INVAL;
}

int
close(int fdnum)
{
  800a5e:	55                   	push   %ebp
  800a5f:	89 e5                	mov    %esp,%ebp
  800a61:	83 ec 28             	sub    $0x28,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  800a64:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800a67:	89 44 24 04          	mov    %eax,0x4(%esp)
  800a6b:	8b 45 08             	mov    0x8(%ebp),%eax
  800a6e:	89 04 24             	mov    %eax,(%esp)
  800a71:	e8 27 fc ff ff       	call   80069d <fd_lookup>
  800a76:	85 c0                	test   %eax,%eax
  800a78:	78 13                	js     800a8d <close+0x2f>
		return r;
	else
		return fd_close(fd, 1);
  800a7a:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  800a81:	00 
  800a82:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800a85:	89 04 24             	mov    %eax,(%esp)
  800a88:	e8 52 ff ff ff       	call   8009df <fd_close>
}
  800a8d:	c9                   	leave  
  800a8e:	c3                   	ret    

00800a8f <stat>:
	return (*dev->dev_stat)(fd, stat);
}

int
stat(const char *path, struct Stat *stat)
{
  800a8f:	55                   	push   %ebp
  800a90:	89 e5                	mov    %esp,%ebp
  800a92:	83 ec 18             	sub    $0x18,%esp
  800a95:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  800a98:	89 75 fc             	mov    %esi,-0x4(%ebp)
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  800a9b:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  800aa2:	00 
  800aa3:	8b 45 08             	mov    0x8(%ebp),%eax
  800aa6:	89 04 24             	mov    %eax,(%esp)
  800aa9:	e8 55 03 00 00       	call   800e03 <open>
  800aae:	89 c3                	mov    %eax,%ebx
  800ab0:	85 c0                	test   %eax,%eax
  800ab2:	78 1b                	js     800acf <stat+0x40>
		return fd;
	r = fstat(fd, stat);
  800ab4:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ab7:	89 44 24 04          	mov    %eax,0x4(%esp)
  800abb:	89 1c 24             	mov    %ebx,(%esp)
  800abe:	e8 b7 fc ff ff       	call   80077a <fstat>
  800ac3:	89 c6                	mov    %eax,%esi
	close(fd);
  800ac5:	89 1c 24             	mov    %ebx,(%esp)
  800ac8:	e8 91 ff ff ff       	call   800a5e <close>
  800acd:	89 f3                	mov    %esi,%ebx
	return r;
}
  800acf:	89 d8                	mov    %ebx,%eax
  800ad1:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  800ad4:	8b 75 fc             	mov    -0x4(%ebp),%esi
  800ad7:	89 ec                	mov    %ebp,%esp
  800ad9:	5d                   	pop    %ebp
  800ada:	c3                   	ret    

00800adb <close_all>:
		return fd_close(fd, 1);
}

void
close_all(void)
{
  800adb:	55                   	push   %ebp
  800adc:	89 e5                	mov    %esp,%ebp
  800ade:	53                   	push   %ebx
  800adf:	83 ec 14             	sub    $0x14,%esp
  800ae2:	bb 00 00 00 00       	mov    $0x0,%ebx
	int i;
	for (i = 0; i < MAXFD; i++)
		close(i);
  800ae7:	89 1c 24             	mov    %ebx,(%esp)
  800aea:	e8 6f ff ff ff       	call   800a5e <close>

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  800aef:	83 c3 01             	add    $0x1,%ebx
  800af2:	83 fb 20             	cmp    $0x20,%ebx
  800af5:	75 f0                	jne    800ae7 <close_all+0xc>
		close(i);
}
  800af7:	83 c4 14             	add    $0x14,%esp
  800afa:	5b                   	pop    %ebx
  800afb:	5d                   	pop    %ebp
  800afc:	c3                   	ret    

00800afd <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  800afd:	55                   	push   %ebp
  800afe:	89 e5                	mov    %esp,%ebp
  800b00:	83 ec 58             	sub    $0x58,%esp
  800b03:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800b06:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800b09:	89 7d fc             	mov    %edi,-0x4(%ebp)
  800b0c:	8b 7d 0c             	mov    0xc(%ebp),%edi
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  800b0f:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  800b12:	89 44 24 04          	mov    %eax,0x4(%esp)
  800b16:	8b 45 08             	mov    0x8(%ebp),%eax
  800b19:	89 04 24             	mov    %eax,(%esp)
  800b1c:	e8 7c fb ff ff       	call   80069d <fd_lookup>
  800b21:	89 c3                	mov    %eax,%ebx
  800b23:	85 c0                	test   %eax,%eax
  800b25:	0f 88 e0 00 00 00    	js     800c0b <dup+0x10e>
		return r;
	close(newfdnum);
  800b2b:	89 3c 24             	mov    %edi,(%esp)
  800b2e:	e8 2b ff ff ff       	call   800a5e <close>

	newfd = INDEX2FD(newfdnum);
  800b33:	8d b7 00 00 0d 00    	lea    0xd0000(%edi),%esi
  800b39:	c1 e6 0c             	shl    $0xc,%esi
	ova = fd2data(oldfd);
  800b3c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800b3f:	89 04 24             	mov    %eax,(%esp)
  800b42:	e8 c9 fa ff ff       	call   800610 <fd2data>
  800b47:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  800b49:	89 34 24             	mov    %esi,(%esp)
  800b4c:	e8 bf fa ff ff       	call   800610 <fd2data>
  800b51:	89 45 d4             	mov    %eax,-0x2c(%ebp)

	if ((vpd[PDX(ova)] & PTE_P) && (vpt[VPN(ova)] & PTE_P))
  800b54:	89 da                	mov    %ebx,%edx
  800b56:	89 d8                	mov    %ebx,%eax
  800b58:	c1 e8 16             	shr    $0x16,%eax
  800b5b:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  800b62:	a8 01                	test   $0x1,%al
  800b64:	74 43                	je     800ba9 <dup+0xac>
  800b66:	c1 ea 0c             	shr    $0xc,%edx
  800b69:	8b 04 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%eax
  800b70:	a8 01                	test   $0x1,%al
  800b72:	74 35                	je     800ba9 <dup+0xac>
		if ((r = sys_page_map(0, ova, 0, nva, vpt[VPN(ova)] & PTE_USER)) < 0)
  800b74:	8b 04 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%eax
  800b7b:	25 07 0e 00 00       	and    $0xe07,%eax
  800b80:	89 44 24 10          	mov    %eax,0x10(%esp)
  800b84:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800b87:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800b8b:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  800b92:	00 
  800b93:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  800b97:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  800b9e:	e8 d6 f8 ff ff       	call   800479 <sys_page_map>
  800ba3:	89 c3                	mov    %eax,%ebx
  800ba5:	85 c0                	test   %eax,%eax
  800ba7:	78 3f                	js     800be8 <dup+0xeb>
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, vpt[VPN(oldfd)] & PTE_USER)) < 0)
  800ba9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800bac:	89 c2                	mov    %eax,%edx
  800bae:	c1 ea 0c             	shr    $0xc,%edx
  800bb1:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  800bb8:	81 e2 07 0e 00 00    	and    $0xe07,%edx
  800bbe:	89 54 24 10          	mov    %edx,0x10(%esp)
  800bc2:	89 74 24 0c          	mov    %esi,0xc(%esp)
  800bc6:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  800bcd:	00 
  800bce:	89 44 24 04          	mov    %eax,0x4(%esp)
  800bd2:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  800bd9:	e8 9b f8 ff ff       	call   800479 <sys_page_map>
  800bde:	89 c3                	mov    %eax,%ebx
  800be0:	85 c0                	test   %eax,%eax
  800be2:	78 04                	js     800be8 <dup+0xeb>
  800be4:	89 fb                	mov    %edi,%ebx
  800be6:	eb 23                	jmp    800c0b <dup+0x10e>
		goto err;

	return newfdnum;

err:
	sys_page_unmap(0, newfd);
  800be8:	89 74 24 04          	mov    %esi,0x4(%esp)
  800bec:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  800bf3:	e8 23 f8 ff ff       	call   80041b <sys_page_unmap>
	sys_page_unmap(0, nva);
  800bf8:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800bfb:	89 44 24 04          	mov    %eax,0x4(%esp)
  800bff:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  800c06:	e8 10 f8 ff ff       	call   80041b <sys_page_unmap>
	return r;
}
  800c0b:	89 d8                	mov    %ebx,%eax
  800c0d:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800c10:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800c13:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800c16:	89 ec                	mov    %ebp,%esp
  800c18:	5d                   	pop    %ebp
  800c19:	c3                   	ret    
	...

00800c1c <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  800c1c:	55                   	push   %ebp
  800c1d:	89 e5                	mov    %esp,%ebp
  800c1f:	53                   	push   %ebx
  800c20:	83 ec 14             	sub    $0x14,%esp
  800c23:	89 d3                	mov    %edx,%ebx
	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", env->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(envs[1].env_id, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  800c25:	8b 15 c8 00 c0 ee    	mov    0xeec000c8,%edx
  800c2b:	c7 44 24 0c 07 00 00 	movl   $0x7,0xc(%esp)
  800c32:	00 
  800c33:	c7 44 24 08 00 30 80 	movl   $0x803000,0x8(%esp)
  800c3a:	00 
  800c3b:	89 44 24 04          	mov    %eax,0x4(%esp)
  800c3f:	89 14 24             	mov    %edx,(%esp)
  800c42:	e8 f9 17 00 00       	call   802440 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  800c47:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  800c4e:	00 
  800c4f:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  800c53:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  800c5a:	e8 47 18 00 00       	call   8024a6 <ipc_recv>
}
  800c5f:	83 c4 14             	add    $0x14,%esp
  800c62:	5b                   	pop    %ebx
  800c63:	5d                   	pop    %ebp
  800c64:	c3                   	ret    

00800c65 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  800c65:	55                   	push   %ebp
  800c66:	89 e5                	mov    %esp,%ebp
  800c68:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  800c6b:	8b 45 08             	mov    0x8(%ebp),%eax
  800c6e:	8b 40 0c             	mov    0xc(%eax),%eax
  800c71:	a3 00 30 80 00       	mov    %eax,0x803000
	fsipcbuf.set_size.req_size = newsize;
  800c76:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c79:	a3 04 30 80 00       	mov    %eax,0x803004
	return fsipc(FSREQ_SET_SIZE, NULL);
  800c7e:	ba 00 00 00 00       	mov    $0x0,%edx
  800c83:	b8 02 00 00 00       	mov    $0x2,%eax
  800c88:	e8 8f ff ff ff       	call   800c1c <fsipc>
}
  800c8d:	c9                   	leave  
  800c8e:	c3                   	ret    

00800c8f <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  800c8f:	55                   	push   %ebp
  800c90:	89 e5                	mov    %esp,%ebp
  800c92:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  800c95:	8b 45 08             	mov    0x8(%ebp),%eax
  800c98:	8b 40 0c             	mov    0xc(%eax),%eax
  800c9b:	a3 00 30 80 00       	mov    %eax,0x803000
	return fsipc(FSREQ_FLUSH, NULL);
  800ca0:	ba 00 00 00 00       	mov    $0x0,%edx
  800ca5:	b8 06 00 00 00       	mov    $0x6,%eax
  800caa:	e8 6d ff ff ff       	call   800c1c <fsipc>
}
  800caf:	c9                   	leave  
  800cb0:	c3                   	ret    

00800cb1 <sync>:
}

// Synchronize disk with buffer cache
int
sync(void)
{
  800cb1:	55                   	push   %ebp
  800cb2:	89 e5                	mov    %esp,%ebp
  800cb4:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  800cb7:	ba 00 00 00 00       	mov    $0x0,%edx
  800cbc:	b8 08 00 00 00       	mov    $0x8,%eax
  800cc1:	e8 56 ff ff ff       	call   800c1c <fsipc>
}
  800cc6:	c9                   	leave  
  800cc7:	c3                   	ret    

00800cc8 <devfile_stat>:
	return fsipc(FSREQ_WRITE, NULL);	
}

static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  800cc8:	55                   	push   %ebp
  800cc9:	89 e5                	mov    %esp,%ebp
  800ccb:	53                   	push   %ebx
  800ccc:	83 ec 14             	sub    $0x14,%esp
  800ccf:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  800cd2:	8b 45 08             	mov    0x8(%ebp),%eax
  800cd5:	8b 40 0c             	mov    0xc(%eax),%eax
  800cd8:	a3 00 30 80 00       	mov    %eax,0x803000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  800cdd:	ba 00 00 00 00       	mov    $0x0,%edx
  800ce2:	b8 05 00 00 00       	mov    $0x5,%eax
  800ce7:	e8 30 ff ff ff       	call   800c1c <fsipc>
  800cec:	85 c0                	test   %eax,%eax
  800cee:	78 2b                	js     800d1b <devfile_stat+0x53>
		return r;
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  800cf0:	c7 44 24 04 00 30 80 	movl   $0x803000,0x4(%esp)
  800cf7:	00 
  800cf8:	89 1c 24             	mov    %ebx,(%esp)
  800cfb:	e8 7a 13 00 00       	call   80207a <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  800d00:	a1 80 30 80 00       	mov    0x803080,%eax
  800d05:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  800d0b:	a1 84 30 80 00       	mov    0x803084,%eax
  800d10:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
  800d16:	b8 00 00 00 00       	mov    $0x0,%eax
	return 0;
}
  800d1b:	83 c4 14             	add    $0x14,%esp
  800d1e:	5b                   	pop    %ebx
  800d1f:	5d                   	pop    %ebp
  800d20:	c3                   	ret    

00800d21 <devfile_write>:
// Returns:
//	 The number of bytes successfully written.
//	 < 0 on error.
static ssize_t
devfile_write(struct Fd *fd, const void *buf, size_t n)
{
  800d21:	55                   	push   %ebp
  800d22:	89 e5                	mov    %esp,%ebp
  800d24:	83 ec 18             	sub    $0x18,%esp
  800d27:	8b 45 10             	mov    0x10(%ebp),%eax
  800d2a:	3d f8 0f 00 00       	cmp    $0xff8,%eax
  800d2f:	76 05                	jbe    800d36 <devfile_write+0x15>
  800d31:	b8 f8 0f 00 00       	mov    $0xff8,%eax
	// LAB 5: Your code here
	//panic("devfile_write not implemented");
	
	if (n > (PGSIZE - (sizeof(int) + sizeof(size_t))))
		n = PGSIZE - (sizeof(int) + sizeof(size_t));
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  800d36:	8b 55 08             	mov    0x8(%ebp),%edx
  800d39:	8b 52 0c             	mov    0xc(%edx),%edx
  800d3c:	89 15 00 30 80 00    	mov    %edx,0x803000
	fsipcbuf.write.req_n = n;
  800d42:	a3 04 30 80 00       	mov    %eax,0x803004
	memmove (fsipcbuf.write.req_buf, (char*)buf, n);	
  800d47:	89 44 24 08          	mov    %eax,0x8(%esp)
  800d4b:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d4e:	89 44 24 04          	mov    %eax,0x4(%esp)
  800d52:	c7 04 24 08 30 80 00 	movl   $0x803008,(%esp)
  800d59:	e8 d7 14 00 00       	call   802235 <memmove>
	return fsipc(FSREQ_WRITE, NULL);	
  800d5e:	ba 00 00 00 00       	mov    $0x0,%edx
  800d63:	b8 04 00 00 00       	mov    $0x4,%eax
  800d68:	e8 af fe ff ff       	call   800c1c <fsipc>
}
  800d6d:	c9                   	leave  
  800d6e:	c3                   	ret    

00800d6f <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  800d6f:	55                   	push   %ebp
  800d70:	89 e5                	mov    %esp,%ebp
  800d72:	53                   	push   %ebx
  800d73:	83 ec 14             	sub    $0x14,%esp
	// system server.
	// LAB 5: Your code here
	
	//panic("devfile_read not implemented");
	int r;
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  800d76:	8b 45 08             	mov    0x8(%ebp),%eax
  800d79:	8b 40 0c             	mov    0xc(%eax),%eax
  800d7c:	a3 00 30 80 00       	mov    %eax,0x803000
	fsipcbuf.read.req_n = n;
  800d81:	8b 45 10             	mov    0x10(%ebp),%eax
  800d84:	a3 04 30 80 00       	mov    %eax,0x803004
	if ((r = fsipc(FSREQ_READ, (void*)&fsipcbuf)) < 0)
  800d89:	ba 00 30 80 00       	mov    $0x803000,%edx
  800d8e:	b8 03 00 00 00       	mov    $0x3,%eax
  800d93:	e8 84 fe ff ff       	call   800c1c <fsipc>
  800d98:	89 c3                	mov    %eax,%ebx
  800d9a:	85 c0                	test   %eax,%eax
  800d9c:	78 17                	js     800db5 <devfile_read+0x46>
		return r;
	memmove((void*)buf, (void*)fsipcbuf.readRet.ret_buf, r);
  800d9e:	89 44 24 08          	mov    %eax,0x8(%esp)
  800da2:	c7 44 24 04 00 30 80 	movl   $0x803000,0x4(%esp)
  800da9:	00 
  800daa:	8b 45 0c             	mov    0xc(%ebp),%eax
  800dad:	89 04 24             	mov    %eax,(%esp)
  800db0:	e8 80 14 00 00       	call   802235 <memmove>
	return r;
}
  800db5:	89 d8                	mov    %ebx,%eax
  800db7:	83 c4 14             	add    $0x14,%esp
  800dba:	5b                   	pop    %ebx
  800dbb:	5d                   	pop    %ebp
  800dbc:	c3                   	ret    

00800dbd <remove>:
}

// Delete a file
int
remove(const char *path)
{
  800dbd:	55                   	push   %ebp
  800dbe:	89 e5                	mov    %esp,%ebp
  800dc0:	53                   	push   %ebx
  800dc1:	83 ec 14             	sub    $0x14,%esp
  800dc4:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (strlen(path) >= MAXPATHLEN)
  800dc7:	89 1c 24             	mov    %ebx,(%esp)
  800dca:	e8 61 12 00 00       	call   802030 <strlen>
  800dcf:	89 c2                	mov    %eax,%edx
  800dd1:	b8 f4 ff ff ff       	mov    $0xfffffff4,%eax
  800dd6:	81 fa ff 03 00 00    	cmp    $0x3ff,%edx
  800ddc:	7f 1f                	jg     800dfd <remove+0x40>
		return -E_BAD_PATH;
	strcpy(fsipcbuf.remove.req_path, path);
  800dde:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  800de2:	c7 04 24 00 30 80 00 	movl   $0x803000,(%esp)
  800de9:	e8 8c 12 00 00       	call   80207a <strcpy>
	return fsipc(FSREQ_REMOVE, NULL);
  800dee:	ba 00 00 00 00       	mov    $0x0,%edx
  800df3:	b8 07 00 00 00       	mov    $0x7,%eax
  800df8:	e8 1f fe ff ff       	call   800c1c <fsipc>
}
  800dfd:	83 c4 14             	add    $0x14,%esp
  800e00:	5b                   	pop    %ebx
  800e01:	5d                   	pop    %ebp
  800e02:	c3                   	ret    

00800e03 <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  800e03:	55                   	push   %ebp
  800e04:	89 e5                	mov    %esp,%ebp
  800e06:	83 ec 28             	sub    $0x28,%esp
  800e09:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  800e0c:	89 75 fc             	mov    %esi,-0x4(%ebp)
  800e0f:	8b 75 08             	mov    0x8(%ebp),%esi
	// file descriptor.

	// LAB 5: Your code here.
	// Code added by Swastika / Sandeep
	
	if (strlen(path) >= MAXPATHLEN)
  800e12:	89 34 24             	mov    %esi,(%esp)
  800e15:	e8 16 12 00 00       	call   802030 <strlen>
  800e1a:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  800e1f:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  800e24:	7f 5e                	jg     800e84 <open+0x81>
		return -E_BAD_PATH;
	struct Fd * fd;
	int  r;
	if ((r = fd_alloc(&fd)) < 0)
  800e26:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800e29:	89 04 24             	mov    %eax,(%esp)
  800e2c:	e8 fa f7 ff ff       	call   80062b <fd_alloc>
  800e31:	89 c3                	mov    %eax,%ebx
  800e33:	85 c0                	test   %eax,%eax
  800e35:	78 4d                	js     800e84 <open+0x81>
		return r;
	strcpy (fsipcbuf.open.req_path, path);
  800e37:	89 74 24 04          	mov    %esi,0x4(%esp)
  800e3b:	c7 04 24 00 30 80 00 	movl   $0x803000,(%esp)
  800e42:	e8 33 12 00 00       	call   80207a <strcpy>
	fsipcbuf.open.req_omode = mode;	
  800e47:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e4a:	a3 00 34 80 00       	mov    %eax,0x803400
	if ((r = fsipc(FSREQ_OPEN,(void*)fd)) < 0)
  800e4f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800e52:	b8 01 00 00 00       	mov    $0x1,%eax
  800e57:	e8 c0 fd ff ff       	call   800c1c <fsipc>
  800e5c:	89 c3                	mov    %eax,%ebx
  800e5e:	85 c0                	test   %eax,%eax
  800e60:	79 15                	jns    800e77 <open+0x74>
	{
		fd_close(fd,0);
  800e62:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  800e69:	00 
  800e6a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800e6d:	89 04 24             	mov    %eax,(%esp)
  800e70:	e8 6a fb ff ff       	call   8009df <fd_close>
		return r; 
  800e75:	eb 0d                	jmp    800e84 <open+0x81>
	}
	return fd2num(fd);
  800e77:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800e7a:	89 04 24             	mov    %eax,(%esp)
  800e7d:	e8 7e f7 ff ff       	call   800600 <fd2num>
  800e82:	89 c3                	mov    %eax,%ebx
	//panic("open not implemented");
}
  800e84:	89 d8                	mov    %ebx,%eax
  800e86:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  800e89:	8b 75 fc             	mov    -0x4(%ebp),%esi
  800e8c:	89 ec                	mov    %ebp,%esp
  800e8e:	5d                   	pop    %ebp
  800e8f:	c3                   	ret    

00800e90 <devsock_stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  800e90:	55                   	push   %ebp
  800e91:	89 e5                	mov    %esp,%ebp
  800e93:	83 ec 18             	sub    $0x18,%esp
	strcpy(stat->st_name, "<sock>");
  800e96:	c7 44 24 04 b4 28 80 	movl   $0x8028b4,0x4(%esp)
  800e9d:	00 
  800e9e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ea1:	89 04 24             	mov    %eax,(%esp)
  800ea4:	e8 d1 11 00 00       	call   80207a <strcpy>
	return 0;
}
  800ea9:	b8 00 00 00 00       	mov    $0x0,%eax
  800eae:	c9                   	leave  
  800eaf:	c3                   	ret    

00800eb0 <devsock_close>:
	return nsipc_shutdown(r, how);
}

static int
devsock_close(struct Fd *fd)
{
  800eb0:	55                   	push   %ebp
  800eb1:	89 e5                	mov    %esp,%ebp
  800eb3:	83 ec 18             	sub    $0x18,%esp
	return nsipc_close(fd->fd_sock.sockid);
  800eb6:	8b 45 08             	mov    0x8(%ebp),%eax
  800eb9:	8b 40 0c             	mov    0xc(%eax),%eax
  800ebc:	89 04 24             	mov    %eax,(%esp)
  800ebf:	e8 9e 02 00 00       	call   801162 <nsipc_close>
}
  800ec4:	c9                   	leave  
  800ec5:	c3                   	ret    

00800ec6 <devsock_write>:
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
}

static ssize_t
devsock_write(struct Fd *fd, const void *buf, size_t n)
{
  800ec6:	55                   	push   %ebp
  800ec7:	89 e5                	mov    %esp,%ebp
  800ec9:	83 ec 18             	sub    $0x18,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  800ecc:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  800ed3:	00 
  800ed4:	8b 45 10             	mov    0x10(%ebp),%eax
  800ed7:	89 44 24 08          	mov    %eax,0x8(%esp)
  800edb:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ede:	89 44 24 04          	mov    %eax,0x4(%esp)
  800ee2:	8b 45 08             	mov    0x8(%ebp),%eax
  800ee5:	8b 40 0c             	mov    0xc(%eax),%eax
  800ee8:	89 04 24             	mov    %eax,(%esp)
  800eeb:	e8 ae 02 00 00       	call   80119e <nsipc_send>
}
  800ef0:	c9                   	leave  
  800ef1:	c3                   	ret    

00800ef2 <devsock_read>:
	return nsipc_listen(r, backlog);
}

static ssize_t
devsock_read(struct Fd *fd, void *buf, size_t n)
{
  800ef2:	55                   	push   %ebp
  800ef3:	89 e5                	mov    %esp,%ebp
  800ef5:	83 ec 18             	sub    $0x18,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  800ef8:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  800eff:	00 
  800f00:	8b 45 10             	mov    0x10(%ebp),%eax
  800f03:	89 44 24 08          	mov    %eax,0x8(%esp)
  800f07:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f0a:	89 44 24 04          	mov    %eax,0x4(%esp)
  800f0e:	8b 45 08             	mov    0x8(%ebp),%eax
  800f11:	8b 40 0c             	mov    0xc(%eax),%eax
  800f14:	89 04 24             	mov    %eax,(%esp)
  800f17:	e8 f5 02 00 00       	call   801211 <nsipc_recv>
}
  800f1c:	c9                   	leave  
  800f1d:	c3                   	ret    

00800f1e <alloc_sockfd>:
	return sfd->fd_sock.sockid;
}

static int
alloc_sockfd(int sockid)
{
  800f1e:	55                   	push   %ebp
  800f1f:	89 e5                	mov    %esp,%ebp
  800f21:	56                   	push   %esi
  800f22:	53                   	push   %ebx
  800f23:	83 ec 20             	sub    $0x20,%esp
  800f26:	89 c6                	mov    %eax,%esi
	struct Fd *sfd;
	int r;

	if ((r = fd_alloc(&sfd)) < 0
  800f28:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800f2b:	89 04 24             	mov    %eax,(%esp)
  800f2e:	e8 f8 f6 ff ff       	call   80062b <fd_alloc>
  800f33:	89 c3                	mov    %eax,%ebx
  800f35:	85 c0                	test   %eax,%eax
  800f37:	78 21                	js     800f5a <alloc_sockfd+0x3c>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U)) < 0) {
  800f39:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  800f40:	00 
  800f41:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800f44:	89 44 24 04          	mov    %eax,0x4(%esp)
  800f48:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  800f4f:	e8 83 f5 ff ff       	call   8004d7 <sys_page_alloc>
  800f54:	89 c3                	mov    %eax,%ebx
alloc_sockfd(int sockid)
{
	struct Fd *sfd;
	int r;

	if ((r = fd_alloc(&sfd)) < 0
  800f56:	85 c0                	test   %eax,%eax
  800f58:	79 0a                	jns    800f64 <alloc_sockfd+0x46>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U)) < 0) {
		nsipc_close(sockid);
  800f5a:	89 34 24             	mov    %esi,(%esp)
  800f5d:	e8 00 02 00 00       	call   801162 <nsipc_close>
		return r;
  800f62:	eb 28                	jmp    800f8c <alloc_sockfd+0x6e>
	}

	sfd->fd_dev_id = devsock.dev_id;
  800f64:	8b 15 20 60 80 00    	mov    0x806020,%edx
  800f6a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800f6d:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  800f6f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800f72:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	sfd->fd_sock.sockid = sockid;
  800f79:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800f7c:	89 70 0c             	mov    %esi,0xc(%eax)
	return fd2num(sfd);
  800f7f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800f82:	89 04 24             	mov    %eax,(%esp)
  800f85:	e8 76 f6 ff ff       	call   800600 <fd2num>
  800f8a:	89 c3                	mov    %eax,%ebx
}
  800f8c:	89 d8                	mov    %ebx,%eax
  800f8e:	83 c4 20             	add    $0x20,%esp
  800f91:	5b                   	pop    %ebx
  800f92:	5e                   	pop    %esi
  800f93:	5d                   	pop    %ebp
  800f94:	c3                   	ret    

00800f95 <socket>:
	return 0;
}

int
socket(int domain, int type, int protocol)
{
  800f95:	55                   	push   %ebp
  800f96:	89 e5                	mov    %esp,%ebp
  800f98:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  800f9b:	8b 45 10             	mov    0x10(%ebp),%eax
  800f9e:	89 44 24 08          	mov    %eax,0x8(%esp)
  800fa2:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fa5:	89 44 24 04          	mov    %eax,0x4(%esp)
  800fa9:	8b 45 08             	mov    0x8(%ebp),%eax
  800fac:	89 04 24             	mov    %eax,(%esp)
  800faf:	e8 62 01 00 00       	call   801116 <nsipc_socket>
  800fb4:	85 c0                	test   %eax,%eax
  800fb6:	78 05                	js     800fbd <socket+0x28>
		return r;
	return alloc_sockfd(r);
  800fb8:	e8 61 ff ff ff       	call   800f1e <alloc_sockfd>
}
  800fbd:	c9                   	leave  
  800fbe:	66 90                	xchg   %ax,%ax
  800fc0:	c3                   	ret    

00800fc1 <fd2sockid>:
	.dev_stat =	devsock_stat,
};

static int
fd2sockid(int fd)
{
  800fc1:	55                   	push   %ebp
  800fc2:	89 e5                	mov    %esp,%ebp
  800fc4:	83 ec 28             	sub    $0x28,%esp
	struct Fd *sfd;
	int r;

	if ((r = fd_lookup(fd, &sfd)) < 0)
  800fc7:	8d 55 f4             	lea    -0xc(%ebp),%edx
  800fca:	89 54 24 04          	mov    %edx,0x4(%esp)
  800fce:	89 04 24             	mov    %eax,(%esp)
  800fd1:	e8 c7 f6 ff ff       	call   80069d <fd_lookup>
  800fd6:	85 c0                	test   %eax,%eax
  800fd8:	78 15                	js     800fef <fd2sockid+0x2e>
		return r;
	if (sfd->fd_dev_id != devsock.dev_id)
  800fda:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800fdd:	8b 0a                	mov    (%edx),%ecx
  800fdf:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  800fe4:	3b 0d 20 60 80 00    	cmp    0x806020,%ecx
  800fea:	75 03                	jne    800fef <fd2sockid+0x2e>
		return -E_NOT_SUPP;
	return sfd->fd_sock.sockid;
  800fec:	8b 42 0c             	mov    0xc(%edx),%eax
}
  800fef:	c9                   	leave  
  800ff0:	c3                   	ret    

00800ff1 <listen>:
	return nsipc_connect(r, name, namelen);
}

int
listen(int s, int backlog)
{
  800ff1:	55                   	push   %ebp
  800ff2:	89 e5                	mov    %esp,%ebp
  800ff4:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  800ff7:	8b 45 08             	mov    0x8(%ebp),%eax
  800ffa:	e8 c2 ff ff ff       	call   800fc1 <fd2sockid>
  800fff:	85 c0                	test   %eax,%eax
  801001:	78 0f                	js     801012 <listen+0x21>
		return r;
	return nsipc_listen(r, backlog);
  801003:	8b 55 0c             	mov    0xc(%ebp),%edx
  801006:	89 54 24 04          	mov    %edx,0x4(%esp)
  80100a:	89 04 24             	mov    %eax,(%esp)
  80100d:	e8 2e 01 00 00       	call   801140 <nsipc_listen>
}
  801012:	c9                   	leave  
  801013:	c3                   	ret    

00801014 <connect>:
	return nsipc_close(fd->fd_sock.sockid);
}

int
connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  801014:	55                   	push   %ebp
  801015:	89 e5                	mov    %esp,%ebp
  801017:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  80101a:	8b 45 08             	mov    0x8(%ebp),%eax
  80101d:	e8 9f ff ff ff       	call   800fc1 <fd2sockid>
  801022:	85 c0                	test   %eax,%eax
  801024:	78 16                	js     80103c <connect+0x28>
		return r;
	return nsipc_connect(r, name, namelen);
  801026:	8b 55 10             	mov    0x10(%ebp),%edx
  801029:	89 54 24 08          	mov    %edx,0x8(%esp)
  80102d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801030:	89 54 24 04          	mov    %edx,0x4(%esp)
  801034:	89 04 24             	mov    %eax,(%esp)
  801037:	e8 55 02 00 00       	call   801291 <nsipc_connect>
}
  80103c:	c9                   	leave  
  80103d:	c3                   	ret    

0080103e <shutdown>:
	return nsipc_bind(r, name, namelen);
}

int
shutdown(int s, int how)
{
  80103e:	55                   	push   %ebp
  80103f:	89 e5                	mov    %esp,%ebp
  801041:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  801044:	8b 45 08             	mov    0x8(%ebp),%eax
  801047:	e8 75 ff ff ff       	call   800fc1 <fd2sockid>
  80104c:	85 c0                	test   %eax,%eax
  80104e:	78 0f                	js     80105f <shutdown+0x21>
		return r;
	return nsipc_shutdown(r, how);
  801050:	8b 55 0c             	mov    0xc(%ebp),%edx
  801053:	89 54 24 04          	mov    %edx,0x4(%esp)
  801057:	89 04 24             	mov    %eax,(%esp)
  80105a:	e8 1d 01 00 00       	call   80117c <nsipc_shutdown>
}
  80105f:	c9                   	leave  
  801060:	c3                   	ret    

00801061 <bind>:
	return alloc_sockfd(r);
}

int
bind(int s, struct sockaddr *name, socklen_t namelen)
{
  801061:	55                   	push   %ebp
  801062:	89 e5                	mov    %esp,%ebp
  801064:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  801067:	8b 45 08             	mov    0x8(%ebp),%eax
  80106a:	e8 52 ff ff ff       	call   800fc1 <fd2sockid>
  80106f:	85 c0                	test   %eax,%eax
  801071:	78 16                	js     801089 <bind+0x28>
		return r;
	return nsipc_bind(r, name, namelen);
  801073:	8b 55 10             	mov    0x10(%ebp),%edx
  801076:	89 54 24 08          	mov    %edx,0x8(%esp)
  80107a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80107d:	89 54 24 04          	mov    %edx,0x4(%esp)
  801081:	89 04 24             	mov    %eax,(%esp)
  801084:	e8 47 02 00 00       	call   8012d0 <nsipc_bind>
}
  801089:	c9                   	leave  
  80108a:	c3                   	ret    

0080108b <accept>:
	return fd2num(sfd);
}

int
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  80108b:	55                   	push   %ebp
  80108c:	89 e5                	mov    %esp,%ebp
  80108e:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  801091:	8b 45 08             	mov    0x8(%ebp),%eax
  801094:	e8 28 ff ff ff       	call   800fc1 <fd2sockid>
  801099:	85 c0                	test   %eax,%eax
  80109b:	78 1f                	js     8010bc <accept+0x31>
		return r;
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  80109d:	8b 55 10             	mov    0x10(%ebp),%edx
  8010a0:	89 54 24 08          	mov    %edx,0x8(%esp)
  8010a4:	8b 55 0c             	mov    0xc(%ebp),%edx
  8010a7:	89 54 24 04          	mov    %edx,0x4(%esp)
  8010ab:	89 04 24             	mov    %eax,(%esp)
  8010ae:	e8 5c 02 00 00       	call   80130f <nsipc_accept>
  8010b3:	85 c0                	test   %eax,%eax
  8010b5:	78 05                	js     8010bc <accept+0x31>
		return r;
	return alloc_sockfd(r);
  8010b7:	e8 62 fe ff ff       	call   800f1e <alloc_sockfd>
}
  8010bc:	c9                   	leave  
  8010bd:	8d 76 00             	lea    0x0(%esi),%esi
  8010c0:	c3                   	ret    
	...

008010d0 <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  8010d0:	55                   	push   %ebp
  8010d1:	89 e5                	mov    %esp,%ebp
  8010d3:	83 ec 18             	sub    $0x18,%esp
	if (debug)
		cprintf("[%08x] nsipc %d\n", env->env_id, type);

	ipc_send(envs[2].env_id, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  8010d6:	8b 15 44 01 c0 ee    	mov    0xeec00144,%edx
  8010dc:	c7 44 24 0c 07 00 00 	movl   $0x7,0xc(%esp)
  8010e3:	00 
  8010e4:	c7 44 24 08 00 50 80 	movl   $0x805000,0x8(%esp)
  8010eb:	00 
  8010ec:	89 44 24 04          	mov    %eax,0x4(%esp)
  8010f0:	89 14 24             	mov    %edx,(%esp)
  8010f3:	e8 48 13 00 00       	call   802440 <ipc_send>
	return ipc_recv(NULL, NULL, NULL);
  8010f8:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  8010ff:	00 
  801100:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  801107:	00 
  801108:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80110f:	e8 92 13 00 00       	call   8024a6 <ipc_recv>
}
  801114:	c9                   	leave  
  801115:	c3                   	ret    

00801116 <nsipc_socket>:
	return nsipc(NSREQ_SEND);
}

int
nsipc_socket(int domain, int type, int protocol)
{
  801116:	55                   	push   %ebp
  801117:	89 e5                	mov    %esp,%ebp
  801119:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  80111c:	8b 45 08             	mov    0x8(%ebp),%eax
  80111f:	a3 00 50 80 00       	mov    %eax,0x805000
	nsipcbuf.socket.req_type = type;
  801124:	8b 45 0c             	mov    0xc(%ebp),%eax
  801127:	a3 04 50 80 00       	mov    %eax,0x805004
	nsipcbuf.socket.req_protocol = protocol;
  80112c:	8b 45 10             	mov    0x10(%ebp),%eax
  80112f:	a3 08 50 80 00       	mov    %eax,0x805008
	return nsipc(NSREQ_SOCKET);
  801134:	b8 09 00 00 00       	mov    $0x9,%eax
  801139:	e8 92 ff ff ff       	call   8010d0 <nsipc>
}
  80113e:	c9                   	leave  
  80113f:	c3                   	ret    

00801140 <nsipc_listen>:
	return nsipc(NSREQ_CONNECT);
}

int
nsipc_listen(int s, int backlog)
{
  801140:	55                   	push   %ebp
  801141:	89 e5                	mov    %esp,%ebp
  801143:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  801146:	8b 45 08             	mov    0x8(%ebp),%eax
  801149:	a3 00 50 80 00       	mov    %eax,0x805000
	nsipcbuf.listen.req_backlog = backlog;
  80114e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801151:	a3 04 50 80 00       	mov    %eax,0x805004
	return nsipc(NSREQ_LISTEN);
  801156:	b8 06 00 00 00       	mov    $0x6,%eax
  80115b:	e8 70 ff ff ff       	call   8010d0 <nsipc>
}
  801160:	c9                   	leave  
  801161:	c3                   	ret    

00801162 <nsipc_close>:
	return nsipc(NSREQ_SHUTDOWN);
}

int
nsipc_close(int s)
{
  801162:	55                   	push   %ebp
  801163:	89 e5                	mov    %esp,%ebp
  801165:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  801168:	8b 45 08             	mov    0x8(%ebp),%eax
  80116b:	a3 00 50 80 00       	mov    %eax,0x805000
	return nsipc(NSREQ_CLOSE);
  801170:	b8 04 00 00 00       	mov    $0x4,%eax
  801175:	e8 56 ff ff ff       	call   8010d0 <nsipc>
}
  80117a:	c9                   	leave  
  80117b:	c3                   	ret    

0080117c <nsipc_shutdown>:
	return nsipc(NSREQ_BIND);
}

int
nsipc_shutdown(int s, int how)
{
  80117c:	55                   	push   %ebp
  80117d:	89 e5                	mov    %esp,%ebp
  80117f:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  801182:	8b 45 08             	mov    0x8(%ebp),%eax
  801185:	a3 00 50 80 00       	mov    %eax,0x805000
	nsipcbuf.shutdown.req_how = how;
  80118a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80118d:	a3 04 50 80 00       	mov    %eax,0x805004
	return nsipc(NSREQ_SHUTDOWN);
  801192:	b8 03 00 00 00       	mov    $0x3,%eax
  801197:	e8 34 ff ff ff       	call   8010d0 <nsipc>
}
  80119c:	c9                   	leave  
  80119d:	c3                   	ret    

0080119e <nsipc_send>:
	return r;
}

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  80119e:	55                   	push   %ebp
  80119f:	89 e5                	mov    %esp,%ebp
  8011a1:	53                   	push   %ebx
  8011a2:	83 ec 14             	sub    $0x14,%esp
  8011a5:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  8011a8:	8b 45 08             	mov    0x8(%ebp),%eax
  8011ab:	a3 00 50 80 00       	mov    %eax,0x805000
	assert(size < 1600);
  8011b0:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  8011b6:	7e 24                	jle    8011dc <nsipc_send+0x3e>
  8011b8:	c7 44 24 0c c0 28 80 	movl   $0x8028c0,0xc(%esp)
  8011bf:	00 
  8011c0:	c7 44 24 08 cc 28 80 	movl   $0x8028cc,0x8(%esp)
  8011c7:	00 
  8011c8:	c7 44 24 04 66 00 00 	movl   $0x66,0x4(%esp)
  8011cf:	00 
  8011d0:	c7 04 24 e1 28 80 00 	movl   $0x8028e1,(%esp)
  8011d7:	e8 20 07 00 00       	call   8018fc <_panic>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  8011dc:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8011e0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011e3:	89 44 24 04          	mov    %eax,0x4(%esp)
  8011e7:	c7 04 24 0c 50 80 00 	movl   $0x80500c,(%esp)
  8011ee:	e8 42 10 00 00       	call   802235 <memmove>
	nsipcbuf.send.req_size = size;
  8011f3:	89 1d 04 50 80 00    	mov    %ebx,0x805004
	nsipcbuf.send.req_flags = flags;
  8011f9:	8b 45 14             	mov    0x14(%ebp),%eax
  8011fc:	a3 08 50 80 00       	mov    %eax,0x805008
	return nsipc(NSREQ_SEND);
  801201:	b8 08 00 00 00       	mov    $0x8,%eax
  801206:	e8 c5 fe ff ff       	call   8010d0 <nsipc>
}
  80120b:	83 c4 14             	add    $0x14,%esp
  80120e:	5b                   	pop    %ebx
  80120f:	5d                   	pop    %ebp
  801210:	c3                   	ret    

00801211 <nsipc_recv>:
	return nsipc(NSREQ_LISTEN);
}

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  801211:	55                   	push   %ebp
  801212:	89 e5                	mov    %esp,%ebp
  801214:	56                   	push   %esi
  801215:	53                   	push   %ebx
  801216:	83 ec 10             	sub    $0x10,%esp
  801219:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  80121c:	8b 45 08             	mov    0x8(%ebp),%eax
  80121f:	a3 00 50 80 00       	mov    %eax,0x805000
	nsipcbuf.recv.req_len = len;
  801224:	89 35 04 50 80 00    	mov    %esi,0x805004
	nsipcbuf.recv.req_flags = flags;
  80122a:	8b 45 14             	mov    0x14(%ebp),%eax
  80122d:	a3 08 50 80 00       	mov    %eax,0x805008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  801232:	b8 07 00 00 00       	mov    $0x7,%eax
  801237:	e8 94 fe ff ff       	call   8010d0 <nsipc>
  80123c:	89 c3                	mov    %eax,%ebx
  80123e:	85 c0                	test   %eax,%eax
  801240:	78 46                	js     801288 <nsipc_recv+0x77>
		assert(r < 1600 && r <= len);
  801242:	3d 3f 06 00 00       	cmp    $0x63f,%eax
  801247:	7f 04                	jg     80124d <nsipc_recv+0x3c>
  801249:	39 c6                	cmp    %eax,%esi
  80124b:	7d 24                	jge    801271 <nsipc_recv+0x60>
  80124d:	c7 44 24 0c ed 28 80 	movl   $0x8028ed,0xc(%esp)
  801254:	00 
  801255:	c7 44 24 08 cc 28 80 	movl   $0x8028cc,0x8(%esp)
  80125c:	00 
  80125d:	c7 44 24 04 5b 00 00 	movl   $0x5b,0x4(%esp)
  801264:	00 
  801265:	c7 04 24 e1 28 80 00 	movl   $0x8028e1,(%esp)
  80126c:	e8 8b 06 00 00       	call   8018fc <_panic>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  801271:	89 44 24 08          	mov    %eax,0x8(%esp)
  801275:	c7 44 24 04 00 50 80 	movl   $0x805000,0x4(%esp)
  80127c:	00 
  80127d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801280:	89 04 24             	mov    %eax,(%esp)
  801283:	e8 ad 0f 00 00       	call   802235 <memmove>
	}

	return r;
}
  801288:	89 d8                	mov    %ebx,%eax
  80128a:	83 c4 10             	add    $0x10,%esp
  80128d:	5b                   	pop    %ebx
  80128e:	5e                   	pop    %esi
  80128f:	5d                   	pop    %ebp
  801290:	c3                   	ret    

00801291 <nsipc_connect>:
	return nsipc(NSREQ_CLOSE);
}

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  801291:	55                   	push   %ebp
  801292:	89 e5                	mov    %esp,%ebp
  801294:	53                   	push   %ebx
  801295:	83 ec 14             	sub    $0x14,%esp
  801298:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  80129b:	8b 45 08             	mov    0x8(%ebp),%eax
  80129e:	a3 00 50 80 00       	mov    %eax,0x805000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  8012a3:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8012a7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012aa:	89 44 24 04          	mov    %eax,0x4(%esp)
  8012ae:	c7 04 24 04 50 80 00 	movl   $0x805004,(%esp)
  8012b5:	e8 7b 0f 00 00       	call   802235 <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  8012ba:	89 1d 14 50 80 00    	mov    %ebx,0x805014
	return nsipc(NSREQ_CONNECT);
  8012c0:	b8 05 00 00 00       	mov    $0x5,%eax
  8012c5:	e8 06 fe ff ff       	call   8010d0 <nsipc>
}
  8012ca:	83 c4 14             	add    $0x14,%esp
  8012cd:	5b                   	pop    %ebx
  8012ce:	5d                   	pop    %ebp
  8012cf:	c3                   	ret    

008012d0 <nsipc_bind>:
	return r;
}

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  8012d0:	55                   	push   %ebp
  8012d1:	89 e5                	mov    %esp,%ebp
  8012d3:	53                   	push   %ebx
  8012d4:	83 ec 14             	sub    $0x14,%esp
  8012d7:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  8012da:	8b 45 08             	mov    0x8(%ebp),%eax
  8012dd:	a3 00 50 80 00       	mov    %eax,0x805000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  8012e2:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8012e6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012e9:	89 44 24 04          	mov    %eax,0x4(%esp)
  8012ed:	c7 04 24 04 50 80 00 	movl   $0x805004,(%esp)
  8012f4:	e8 3c 0f 00 00       	call   802235 <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  8012f9:	89 1d 14 50 80 00    	mov    %ebx,0x805014
	return nsipc(NSREQ_BIND);
  8012ff:	b8 02 00 00 00       	mov    $0x2,%eax
  801304:	e8 c7 fd ff ff       	call   8010d0 <nsipc>
}
  801309:	83 c4 14             	add    $0x14,%esp
  80130c:	5b                   	pop    %ebx
  80130d:	5d                   	pop    %ebp
  80130e:	c3                   	ret    

0080130f <nsipc_accept>:
	return ipc_recv(NULL, NULL, NULL);
}

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  80130f:	55                   	push   %ebp
  801310:	89 e5                	mov    %esp,%ebp
  801312:	83 ec 18             	sub    $0x18,%esp
  801315:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  801318:	89 75 fc             	mov    %esi,-0x4(%ebp)
	int r;
	
	nsipcbuf.accept.req_s = s;
  80131b:	8b 45 08             	mov    0x8(%ebp),%eax
  80131e:	a3 00 50 80 00       	mov    %eax,0x805000
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  801323:	b8 01 00 00 00       	mov    $0x1,%eax
  801328:	e8 a3 fd ff ff       	call   8010d0 <nsipc>
  80132d:	89 c3                	mov    %eax,%ebx
  80132f:	85 c0                	test   %eax,%eax
  801331:	78 25                	js     801358 <nsipc_accept+0x49>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  801333:	be 10 50 80 00       	mov    $0x805010,%esi
  801338:	8b 06                	mov    (%esi),%eax
  80133a:	89 44 24 08          	mov    %eax,0x8(%esp)
  80133e:	c7 44 24 04 00 50 80 	movl   $0x805000,0x4(%esp)
  801345:	00 
  801346:	8b 45 0c             	mov    0xc(%ebp),%eax
  801349:	89 04 24             	mov    %eax,(%esp)
  80134c:	e8 e4 0e 00 00       	call   802235 <memmove>
		*addrlen = ret->ret_addrlen;
  801351:	8b 16                	mov    (%esi),%edx
  801353:	8b 45 10             	mov    0x10(%ebp),%eax
  801356:	89 10                	mov    %edx,(%eax)
	}
	return r;
}
  801358:	89 d8                	mov    %ebx,%eax
  80135a:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  80135d:	8b 75 fc             	mov    -0x4(%ebp),%esi
  801360:	89 ec                	mov    %ebp,%esp
  801362:	5d                   	pop    %ebp
  801363:	c3                   	ret    
	...

00801370 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  801370:	55                   	push   %ebp
  801371:	89 e5                	mov    %esp,%ebp
  801373:	83 ec 18             	sub    $0x18,%esp
  801376:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  801379:	89 75 fc             	mov    %esi,-0x4(%ebp)
  80137c:	8b 75 0c             	mov    0xc(%ebp),%esi
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  80137f:	8b 45 08             	mov    0x8(%ebp),%eax
  801382:	89 04 24             	mov    %eax,(%esp)
  801385:	e8 86 f2 ff ff       	call   800610 <fd2data>
  80138a:	89 c3                	mov    %eax,%ebx
	strcpy(stat->st_name, "<pipe>");
  80138c:	c7 44 24 04 02 29 80 	movl   $0x802902,0x4(%esp)
  801393:	00 
  801394:	89 34 24             	mov    %esi,(%esp)
  801397:	e8 de 0c 00 00       	call   80207a <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  80139c:	8b 43 04             	mov    0x4(%ebx),%eax
  80139f:	2b 03                	sub    (%ebx),%eax
  8013a1:	89 86 80 00 00 00    	mov    %eax,0x80(%esi)
	stat->st_isdir = 0;
  8013a7:	c7 86 84 00 00 00 00 	movl   $0x0,0x84(%esi)
  8013ae:	00 00 00 
	stat->st_dev = &devpipe;
  8013b1:	c7 86 88 00 00 00 3c 	movl   $0x80603c,0x88(%esi)
  8013b8:	60 80 00 
	return 0;
}
  8013bb:	b8 00 00 00 00       	mov    $0x0,%eax
  8013c0:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  8013c3:	8b 75 fc             	mov    -0x4(%ebp),%esi
  8013c6:	89 ec                	mov    %ebp,%esp
  8013c8:	5d                   	pop    %ebp
  8013c9:	c3                   	ret    

008013ca <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  8013ca:	55                   	push   %ebp
  8013cb:	89 e5                	mov    %esp,%ebp
  8013cd:	53                   	push   %ebx
  8013ce:	83 ec 14             	sub    $0x14,%esp
  8013d1:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  8013d4:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8013d8:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8013df:	e8 37 f0 ff ff       	call   80041b <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  8013e4:	89 1c 24             	mov    %ebx,(%esp)
  8013e7:	e8 24 f2 ff ff       	call   800610 <fd2data>
  8013ec:	89 44 24 04          	mov    %eax,0x4(%esp)
  8013f0:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8013f7:	e8 1f f0 ff ff       	call   80041b <sys_page_unmap>
}
  8013fc:	83 c4 14             	add    $0x14,%esp
  8013ff:	5b                   	pop    %ebx
  801400:	5d                   	pop    %ebp
  801401:	c3                   	ret    

00801402 <_pipeisclosed>:
	return r;
}

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  801402:	55                   	push   %ebp
  801403:	89 e5                	mov    %esp,%ebp
  801405:	57                   	push   %edi
  801406:	56                   	push   %esi
  801407:	53                   	push   %ebx
  801408:	83 ec 2c             	sub    $0x2c,%esp
  80140b:	89 c7                	mov    %eax,%edi
  80140d:	89 55 e4             	mov    %edx,-0x1c(%ebp)
	int n, nn, ret;

	while (1) {
		n = env->env_runs;
  801410:	a1 74 60 80 00       	mov    0x806074,%eax
  801415:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  801418:	89 3c 24             	mov    %edi,(%esp)
  80141b:	e8 f0 10 00 00       	call   802510 <pageref>
  801420:	89 c6                	mov    %eax,%esi
  801422:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801425:	89 04 24             	mov    %eax,(%esp)
  801428:	e8 e3 10 00 00       	call   802510 <pageref>
  80142d:	39 c6                	cmp    %eax,%esi
  80142f:	0f 94 c0             	sete   %al
  801432:	0f b6 c0             	movzbl %al,%eax
		nn = env->env_runs;
  801435:	8b 15 74 60 80 00    	mov    0x806074,%edx
  80143b:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  80143e:	39 cb                	cmp    %ecx,%ebx
  801440:	75 08                	jne    80144a <_pipeisclosed+0x48>
			return ret;
		if (n != nn && ret == 1)
			cprintf("pipe race avoided\n", n, env->env_runs, ret);
	}
}
  801442:	83 c4 2c             	add    $0x2c,%esp
  801445:	5b                   	pop    %ebx
  801446:	5e                   	pop    %esi
  801447:	5f                   	pop    %edi
  801448:	5d                   	pop    %ebp
  801449:	c3                   	ret    
		n = env->env_runs;
		ret = pageref(fd) == pageref(p);
		nn = env->env_runs;
		if (n == nn)
			return ret;
		if (n != nn && ret == 1)
  80144a:	83 f8 01             	cmp    $0x1,%eax
  80144d:	75 c1                	jne    801410 <_pipeisclosed+0xe>
			cprintf("pipe race avoided\n", n, env->env_runs, ret);
  80144f:	8b 52 58             	mov    0x58(%edx),%edx
  801452:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801456:	89 54 24 08          	mov    %edx,0x8(%esp)
  80145a:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  80145e:	c7 04 24 09 29 80 00 	movl   $0x802909,(%esp)
  801465:	e8 57 05 00 00       	call   8019c1 <cprintf>
  80146a:	eb a4                	jmp    801410 <_pipeisclosed+0xe>

0080146c <devpipe_write>:
	return i;
}

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  80146c:	55                   	push   %ebp
  80146d:	89 e5                	mov    %esp,%ebp
  80146f:	57                   	push   %edi
  801470:	56                   	push   %esi
  801471:	53                   	push   %ebx
  801472:	83 ec 1c             	sub    $0x1c,%esp
  801475:	8b 75 08             	mov    0x8(%ebp),%esi
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  801478:	89 34 24             	mov    %esi,(%esp)
  80147b:	e8 90 f1 ff ff       	call   800610 <fd2data>
  801480:	89 c3                	mov    %eax,%ebx
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			env->env_id, vpt[VPN(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  801482:	bf 00 00 00 00       	mov    $0x0,%edi
  801487:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80148b:	75 54                	jne    8014e1 <devpipe_write+0x75>
  80148d:	eb 60                	jmp    8014ef <devpipe_write+0x83>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  80148f:	89 da                	mov    %ebx,%edx
  801491:	89 f0                	mov    %esi,%eax
  801493:	e8 6a ff ff ff       	call   801402 <_pipeisclosed>
  801498:	85 c0                	test   %eax,%eax
  80149a:	74 07                	je     8014a3 <devpipe_write+0x37>
  80149c:	b8 00 00 00 00       	mov    $0x0,%eax
  8014a1:	eb 53                	jmp    8014f6 <devpipe_write+0x8a>
				return 0;
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  8014a3:	90                   	nop
  8014a4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  8014a8:	e8 89 f0 ff ff       	call   800536 <sys_yield>
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			env->env_id, vpt[VPN(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  8014ad:	8b 43 04             	mov    0x4(%ebx),%eax
  8014b0:	8b 13                	mov    (%ebx),%edx
  8014b2:	83 c2 20             	add    $0x20,%edx
  8014b5:	39 d0                	cmp    %edx,%eax
  8014b7:	73 d6                	jae    80148f <devpipe_write+0x23>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  8014b9:	89 c2                	mov    %eax,%edx
  8014bb:	c1 fa 1f             	sar    $0x1f,%edx
  8014be:	c1 ea 1b             	shr    $0x1b,%edx
  8014c1:	01 d0                	add    %edx,%eax
  8014c3:	83 e0 1f             	and    $0x1f,%eax
  8014c6:	29 d0                	sub    %edx,%eax
  8014c8:	89 c2                	mov    %eax,%edx
  8014ca:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8014cd:	0f b6 04 39          	movzbl (%ecx,%edi,1),%eax
  8014d1:	88 44 13 08          	mov    %al,0x8(%ebx,%edx,1)
		p->p_wpos++;
  8014d5:	83 43 04 01          	addl   $0x1,0x4(%ebx)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			env->env_id, vpt[VPN(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  8014d9:	83 c7 01             	add    $0x1,%edi
  8014dc:	39 7d 10             	cmp    %edi,0x10(%ebp)
  8014df:	76 13                	jbe    8014f4 <devpipe_write+0x88>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  8014e1:	8b 43 04             	mov    0x4(%ebx),%eax
  8014e4:	8b 13                	mov    (%ebx),%edx
  8014e6:	83 c2 20             	add    $0x20,%edx
  8014e9:	39 d0                	cmp    %edx,%eax
  8014eb:	73 a2                	jae    80148f <devpipe_write+0x23>
  8014ed:	eb ca                	jmp    8014b9 <devpipe_write+0x4d>
  8014ef:	bf 00 00 00 00       	mov    $0x0,%edi
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}
	
	return i;
  8014f4:	89 f8                	mov    %edi,%eax
}
  8014f6:	83 c4 1c             	add    $0x1c,%esp
  8014f9:	5b                   	pop    %ebx
  8014fa:	5e                   	pop    %esi
  8014fb:	5f                   	pop    %edi
  8014fc:	5d                   	pop    %ebp
  8014fd:	c3                   	ret    

008014fe <devpipe_read>:
	return _pipeisclosed(fd, p);
}

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  8014fe:	55                   	push   %ebp
  8014ff:	89 e5                	mov    %esp,%ebp
  801501:	83 ec 28             	sub    $0x28,%esp
  801504:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  801507:	89 75 f8             	mov    %esi,-0x8(%ebp)
  80150a:	89 7d fc             	mov    %edi,-0x4(%ebp)
  80150d:	8b 7d 08             	mov    0x8(%ebp),%edi
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  801510:	89 3c 24             	mov    %edi,(%esp)
  801513:	e8 f8 f0 ff ff       	call   800610 <fd2data>
  801518:	89 c3                	mov    %eax,%ebx
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			env->env_id, vpt[VPN(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  80151a:	be 00 00 00 00       	mov    $0x0,%esi
  80151f:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801523:	75 4c                	jne    801571 <devpipe_read+0x73>
  801525:	eb 5b                	jmp    801582 <devpipe_read+0x84>
		while (p->p_rpos == p->p_wpos) {
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
				return i;
  801527:	89 f0                	mov    %esi,%eax
  801529:	eb 5e                	jmp    801589 <devpipe_read+0x8b>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  80152b:	89 da                	mov    %ebx,%edx
  80152d:	89 f8                	mov    %edi,%eax
  80152f:	90                   	nop
  801530:	e8 cd fe ff ff       	call   801402 <_pipeisclosed>
  801535:	85 c0                	test   %eax,%eax
  801537:	74 07                	je     801540 <devpipe_read+0x42>
  801539:	b8 00 00 00 00       	mov    $0x0,%eax
  80153e:	eb 49                	jmp    801589 <devpipe_read+0x8b>
				return 0;
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  801540:	e8 f1 ef ff ff       	call   800536 <sys_yield>
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			env->env_id, vpt[VPN(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  801545:	8b 03                	mov    (%ebx),%eax
  801547:	3b 43 04             	cmp    0x4(%ebx),%eax
  80154a:	74 df                	je     80152b <devpipe_read+0x2d>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  80154c:	89 c2                	mov    %eax,%edx
  80154e:	c1 fa 1f             	sar    $0x1f,%edx
  801551:	c1 ea 1b             	shr    $0x1b,%edx
  801554:	01 d0                	add    %edx,%eax
  801556:	83 e0 1f             	and    $0x1f,%eax
  801559:	29 d0                	sub    %edx,%eax
  80155b:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  801560:	8b 55 0c             	mov    0xc(%ebp),%edx
  801563:	88 04 32             	mov    %al,(%edx,%esi,1)
		p->p_rpos++;
  801566:	83 03 01             	addl   $0x1,(%ebx)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			env->env_id, vpt[VPN(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  801569:	83 c6 01             	add    $0x1,%esi
  80156c:	39 75 10             	cmp    %esi,0x10(%ebp)
  80156f:	76 16                	jbe    801587 <devpipe_read+0x89>
		while (p->p_rpos == p->p_wpos) {
  801571:	8b 03                	mov    (%ebx),%eax
  801573:	3b 43 04             	cmp    0x4(%ebx),%eax
  801576:	75 d4                	jne    80154c <devpipe_read+0x4e>
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  801578:	85 f6                	test   %esi,%esi
  80157a:	75 ab                	jne    801527 <devpipe_read+0x29>
  80157c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  801580:	eb a9                	jmp    80152b <devpipe_read+0x2d>
  801582:	be 00 00 00 00       	mov    $0x0,%esi
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  801587:	89 f0                	mov    %esi,%eax
}
  801589:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  80158c:	8b 75 f8             	mov    -0x8(%ebp),%esi
  80158f:	8b 7d fc             	mov    -0x4(%ebp),%edi
  801592:	89 ec                	mov    %ebp,%esp
  801594:	5d                   	pop    %ebp
  801595:	c3                   	ret    

00801596 <pipeisclosed>:
	}
}

int
pipeisclosed(int fdnum)
{
  801596:	55                   	push   %ebp
  801597:	89 e5                	mov    %esp,%ebp
  801599:	83 ec 28             	sub    $0x28,%esp
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80159c:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80159f:	89 44 24 04          	mov    %eax,0x4(%esp)
  8015a3:	8b 45 08             	mov    0x8(%ebp),%eax
  8015a6:	89 04 24             	mov    %eax,(%esp)
  8015a9:	e8 ef f0 ff ff       	call   80069d <fd_lookup>
  8015ae:	85 c0                	test   %eax,%eax
  8015b0:	78 15                	js     8015c7 <pipeisclosed+0x31>
		return r;
	p = (struct Pipe*) fd2data(fd);
  8015b2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8015b5:	89 04 24             	mov    %eax,(%esp)
  8015b8:	e8 53 f0 ff ff       	call   800610 <fd2data>
	return _pipeisclosed(fd, p);
  8015bd:	89 c2                	mov    %eax,%edx
  8015bf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8015c2:	e8 3b fe ff ff       	call   801402 <_pipeisclosed>
}
  8015c7:	c9                   	leave  
  8015c8:	c3                   	ret    

008015c9 <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  8015c9:	55                   	push   %ebp
  8015ca:	89 e5                	mov    %esp,%ebp
  8015cc:	83 ec 48             	sub    $0x48,%esp
  8015cf:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  8015d2:	89 75 f8             	mov    %esi,-0x8(%ebp)
  8015d5:	89 7d fc             	mov    %edi,-0x4(%ebp)
  8015d8:	8b 7d 08             	mov    0x8(%ebp),%edi
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  8015db:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  8015de:	89 04 24             	mov    %eax,(%esp)
  8015e1:	e8 45 f0 ff ff       	call   80062b <fd_alloc>
  8015e6:	89 c3                	mov    %eax,%ebx
  8015e8:	85 c0                	test   %eax,%eax
  8015ea:	0f 88 42 01 00 00    	js     801732 <pipe+0x169>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8015f0:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  8015f7:	00 
  8015f8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8015fb:	89 44 24 04          	mov    %eax,0x4(%esp)
  8015ff:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801606:	e8 cc ee ff ff       	call   8004d7 <sys_page_alloc>
  80160b:	89 c3                	mov    %eax,%ebx
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  80160d:	85 c0                	test   %eax,%eax
  80160f:	0f 88 1d 01 00 00    	js     801732 <pipe+0x169>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  801615:	8d 45 e0             	lea    -0x20(%ebp),%eax
  801618:	89 04 24             	mov    %eax,(%esp)
  80161b:	e8 0b f0 ff ff       	call   80062b <fd_alloc>
  801620:	89 c3                	mov    %eax,%ebx
  801622:	85 c0                	test   %eax,%eax
  801624:	0f 88 f5 00 00 00    	js     80171f <pipe+0x156>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80162a:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  801631:	00 
  801632:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801635:	89 44 24 04          	mov    %eax,0x4(%esp)
  801639:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801640:	e8 92 ee ff ff       	call   8004d7 <sys_page_alloc>
  801645:	89 c3                	mov    %eax,%ebx
	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  801647:	85 c0                	test   %eax,%eax
  801649:	0f 88 d0 00 00 00    	js     80171f <pipe+0x156>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  80164f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801652:	89 04 24             	mov    %eax,(%esp)
  801655:	e8 b6 ef ff ff       	call   800610 <fd2data>
  80165a:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80165c:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  801663:	00 
  801664:	89 44 24 04          	mov    %eax,0x4(%esp)
  801668:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80166f:	e8 63 ee ff ff       	call   8004d7 <sys_page_alloc>
  801674:	89 c3                	mov    %eax,%ebx
  801676:	85 c0                	test   %eax,%eax
  801678:	0f 88 8e 00 00 00    	js     80170c <pipe+0x143>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80167e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801681:	89 04 24             	mov    %eax,(%esp)
  801684:	e8 87 ef ff ff       	call   800610 <fd2data>
  801689:	c7 44 24 10 07 04 00 	movl   $0x407,0x10(%esp)
  801690:	00 
  801691:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801695:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  80169c:	00 
  80169d:	89 74 24 04          	mov    %esi,0x4(%esp)
  8016a1:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8016a8:	e8 cc ed ff ff       	call   800479 <sys_page_map>
  8016ad:	89 c3                	mov    %eax,%ebx
  8016af:	85 c0                	test   %eax,%eax
  8016b1:	78 49                	js     8016fc <pipe+0x133>
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  8016b3:	b8 3c 60 80 00       	mov    $0x80603c,%eax
  8016b8:	8b 08                	mov    (%eax),%ecx
  8016ba:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8016bd:	89 0a                	mov    %ecx,(%edx)
	fd0->fd_omode = O_RDONLY;
  8016bf:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8016c2:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%edx)

	fd1->fd_dev_id = devpipe.dev_id;
  8016c9:	8b 10                	mov    (%eax),%edx
  8016cb:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8016ce:	89 10                	mov    %edx,(%eax)
	fd1->fd_omode = O_WRONLY;
  8016d0:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8016d3:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", env->env_id, vpt[VPN(va)]);

	pfd[0] = fd2num(fd0);
  8016da:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8016dd:	89 04 24             	mov    %eax,(%esp)
  8016e0:	e8 1b ef ff ff       	call   800600 <fd2num>
  8016e5:	89 07                	mov    %eax,(%edi)
	pfd[1] = fd2num(fd1);
  8016e7:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8016ea:	89 04 24             	mov    %eax,(%esp)
  8016ed:	e8 0e ef ff ff       	call   800600 <fd2num>
  8016f2:	89 47 04             	mov    %eax,0x4(%edi)
  8016f5:	bb 00 00 00 00       	mov    $0x0,%ebx
	return 0;
  8016fa:	eb 36                	jmp    801732 <pipe+0x169>

    err3:
	sys_page_unmap(0, va);
  8016fc:	89 74 24 04          	mov    %esi,0x4(%esp)
  801700:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801707:	e8 0f ed ff ff       	call   80041b <sys_page_unmap>
    err2:
	sys_page_unmap(0, fd1);
  80170c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80170f:	89 44 24 04          	mov    %eax,0x4(%esp)
  801713:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80171a:	e8 fc ec ff ff       	call   80041b <sys_page_unmap>
    err1:
	sys_page_unmap(0, fd0);
  80171f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801722:	89 44 24 04          	mov    %eax,0x4(%esp)
  801726:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80172d:	e8 e9 ec ff ff       	call   80041b <sys_page_unmap>
    err:
	return r;
}
  801732:	89 d8                	mov    %ebx,%eax
  801734:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  801737:	8b 75 f8             	mov    -0x8(%ebp),%esi
  80173a:	8b 7d fc             	mov    -0x4(%ebp),%edi
  80173d:	89 ec                	mov    %ebp,%esp
  80173f:	5d                   	pop    %ebp
  801740:	c3                   	ret    
	...

00801750 <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  801750:	55                   	push   %ebp
  801751:	89 e5                	mov    %esp,%ebp
	USED(fd);

	return 0;
}
  801753:	b8 00 00 00 00       	mov    $0x0,%eax
  801758:	5d                   	pop    %ebp
  801759:	c3                   	ret    

0080175a <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  80175a:	55                   	push   %ebp
  80175b:	89 e5                	mov    %esp,%ebp
  80175d:	83 ec 18             	sub    $0x18,%esp
	strcpy(stat->st_name, "<cons>");
  801760:	c7 44 24 04 21 29 80 	movl   $0x802921,0x4(%esp)
  801767:	00 
  801768:	8b 45 0c             	mov    0xc(%ebp),%eax
  80176b:	89 04 24             	mov    %eax,(%esp)
  80176e:	e8 07 09 00 00       	call   80207a <strcpy>
	return 0;
}
  801773:	b8 00 00 00 00       	mov    $0x0,%eax
  801778:	c9                   	leave  
  801779:	c3                   	ret    

0080177a <devcons_write>:
	return 1;
}

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  80177a:	55                   	push   %ebp
  80177b:	89 e5                	mov    %esp,%ebp
  80177d:	57                   	push   %edi
  80177e:	56                   	push   %esi
  80177f:	53                   	push   %ebx
  801780:	81 ec 9c 00 00 00    	sub    $0x9c,%esp
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs, 
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  801786:	b8 00 00 00 00       	mov    $0x0,%eax
  80178b:	be 00 00 00 00       	mov    $0x0,%esi
  801790:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801794:	74 3f                	je     8017d5 <devcons_write+0x5b>
		m = n - tot;
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  801796:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs, 
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
		m = n - tot;
  80179c:	8b 55 10             	mov    0x10(%ebp),%edx
  80179f:	29 c2                	sub    %eax,%edx
  8017a1:	89 d3                	mov    %edx,%ebx
		if (m > sizeof(buf) - 1)
  8017a3:	83 fa 7f             	cmp    $0x7f,%edx
  8017a6:	76 05                	jbe    8017ad <devcons_write+0x33>
  8017a8:	bb 7f 00 00 00       	mov    $0x7f,%ebx
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  8017ad:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8017b1:	03 45 0c             	add    0xc(%ebp),%eax
  8017b4:	89 44 24 04          	mov    %eax,0x4(%esp)
  8017b8:	89 3c 24             	mov    %edi,(%esp)
  8017bb:	e8 75 0a 00 00       	call   802235 <memmove>
		sys_cputs(buf, m);
  8017c0:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8017c4:	89 3c 24             	mov    %edi,(%esp)
  8017c7:	e8 10 e9 ff ff       	call   8000dc <sys_cputs>
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs, 
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  8017cc:	01 de                	add    %ebx,%esi
  8017ce:	89 f0                	mov    %esi,%eax
  8017d0:	3b 75 10             	cmp    0x10(%ebp),%esi
  8017d3:	72 c7                	jb     80179c <devcons_write+0x22>
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
}
  8017d5:	89 f0                	mov    %esi,%eax
  8017d7:	81 c4 9c 00 00 00    	add    $0x9c,%esp
  8017dd:	5b                   	pop    %ebx
  8017de:	5e                   	pop    %esi
  8017df:	5f                   	pop    %edi
  8017e0:	5d                   	pop    %ebp
  8017e1:	c3                   	ret    

008017e2 <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  8017e2:	55                   	push   %ebp
  8017e3:	89 e5                	mov    %esp,%ebp
  8017e5:	83 ec 28             	sub    $0x28,%esp
	char c = ch;
  8017e8:	8b 45 08             	mov    0x8(%ebp),%eax
  8017eb:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  8017ee:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  8017f5:	00 
  8017f6:	8d 45 f7             	lea    -0x9(%ebp),%eax
  8017f9:	89 04 24             	mov    %eax,(%esp)
  8017fc:	e8 db e8 ff ff       	call   8000dc <sys_cputs>
}
  801801:	c9                   	leave  
  801802:	c3                   	ret    

00801803 <devcons_read>:
	return fd2num(fd);
}

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  801803:	55                   	push   %ebp
  801804:	89 e5                	mov    %esp,%ebp
  801806:	83 ec 08             	sub    $0x8,%esp
	int c;

	if (n == 0)
  801809:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80180d:	75 07                	jne    801816 <devcons_read+0x13>
  80180f:	eb 28                	jmp    801839 <devcons_read+0x36>
		return 0;

	while ((c = sys_cgetc()) == 0)
		sys_yield();
  801811:	e8 20 ed ff ff       	call   800536 <sys_yield>
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  801816:	66 90                	xchg   %ax,%ax
  801818:	e8 8b e8 ff ff       	call   8000a8 <sys_cgetc>
  80181d:	85 c0                	test   %eax,%eax
  80181f:	90                   	nop
  801820:	74 ef                	je     801811 <devcons_read+0xe>
  801822:	89 c2                	mov    %eax,%edx
		sys_yield();
	if (c < 0)
  801824:	85 c0                	test   %eax,%eax
  801826:	78 16                	js     80183e <devcons_read+0x3b>
		return c;
	if (c == 0x04)	// ctl-d is eof
  801828:	83 f8 04             	cmp    $0x4,%eax
  80182b:	74 0c                	je     801839 <devcons_read+0x36>
		return 0;
	*(char*)vbuf = c;
  80182d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801830:	88 10                	mov    %dl,(%eax)
  801832:	b8 01 00 00 00       	mov    $0x1,%eax
	return 1;
  801837:	eb 05                	jmp    80183e <devcons_read+0x3b>
  801839:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80183e:	c9                   	leave  
  80183f:	c3                   	ret    

00801840 <opencons>:
	return fd->fd_dev_id == devcons.dev_id;
}

int
opencons(void)
{
  801840:	55                   	push   %ebp
  801841:	89 e5                	mov    %esp,%ebp
  801843:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  801846:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801849:	89 04 24             	mov    %eax,(%esp)
  80184c:	e8 da ed ff ff       	call   80062b <fd_alloc>
  801851:	85 c0                	test   %eax,%eax
  801853:	78 3f                	js     801894 <opencons+0x54>
		return r;
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  801855:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  80185c:	00 
  80185d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801860:	89 44 24 04          	mov    %eax,0x4(%esp)
  801864:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80186b:	e8 67 ec ff ff       	call   8004d7 <sys_page_alloc>
  801870:	85 c0                	test   %eax,%eax
  801872:	78 20                	js     801894 <opencons+0x54>
		return r;
	fd->fd_dev_id = devcons.dev_id;
  801874:	8b 15 58 60 80 00    	mov    0x806058,%edx
  80187a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80187d:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  80187f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801882:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  801889:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80188c:	89 04 24             	mov    %eax,(%esp)
  80188f:	e8 6c ed ff ff       	call   800600 <fd2num>
}
  801894:	c9                   	leave  
  801895:	c3                   	ret    

00801896 <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  801896:	55                   	push   %ebp
  801897:	89 e5                	mov    %esp,%ebp
  801899:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80189c:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80189f:	89 44 24 04          	mov    %eax,0x4(%esp)
  8018a3:	8b 45 08             	mov    0x8(%ebp),%eax
  8018a6:	89 04 24             	mov    %eax,(%esp)
  8018a9:	e8 ef ed ff ff       	call   80069d <fd_lookup>
  8018ae:	85 c0                	test   %eax,%eax
  8018b0:	78 11                	js     8018c3 <iscons+0x2d>
		return r;
	return fd->fd_dev_id == devcons.dev_id;
  8018b2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8018b5:	8b 00                	mov    (%eax),%eax
  8018b7:	3b 05 58 60 80 00    	cmp    0x806058,%eax
  8018bd:	0f 94 c0             	sete   %al
  8018c0:	0f b6 c0             	movzbl %al,%eax
}
  8018c3:	c9                   	leave  
  8018c4:	c3                   	ret    

008018c5 <getchar>:
	sys_cputs(&c, 1);
}

int
getchar(void)
{
  8018c5:	55                   	push   %ebp
  8018c6:	89 e5                	mov    %esp,%ebp
  8018c8:	83 ec 28             	sub    $0x28,%esp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  8018cb:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  8018d2:	00 
  8018d3:	8d 45 f7             	lea    -0x9(%ebp),%eax
  8018d6:	89 44 24 04          	mov    %eax,0x4(%esp)
  8018da:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8018e1:	e8 18 f0 ff ff       	call   8008fe <read>
	if (r < 0)
  8018e6:	85 c0                	test   %eax,%eax
  8018e8:	78 0f                	js     8018f9 <getchar+0x34>
		return r;
	if (r < 1)
  8018ea:	85 c0                	test   %eax,%eax
  8018ec:	7f 07                	jg     8018f5 <getchar+0x30>
  8018ee:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  8018f3:	eb 04                	jmp    8018f9 <getchar+0x34>
		return -E_EOF;
	return c;
  8018f5:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  8018f9:	c9                   	leave  
  8018fa:	c3                   	ret    
	...

008018fc <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  8018fc:	55                   	push   %ebp
  8018fd:	89 e5                	mov    %esp,%ebp
  8018ff:	53                   	push   %ebx
  801900:	83 ec 14             	sub    $0x14,%esp
 * Panic is called on unresolvable fatal errors.
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
  801903:	8d 5d 14             	lea    0x14(%ebp),%ebx
	va_list ap;

	va_start(ap, fmt);

	// Print the panic message
	if (argv0)
  801906:	a1 78 60 80 00       	mov    0x806078,%eax
  80190b:	85 c0                	test   %eax,%eax
  80190d:	74 10                	je     80191f <_panic+0x23>
		cprintf("%s: ", argv0);
  80190f:	89 44 24 04          	mov    %eax,0x4(%esp)
  801913:	c7 04 24 2d 29 80 00 	movl   $0x80292d,(%esp)
  80191a:	e8 a2 00 00 00       	call   8019c1 <cprintf>
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  80191f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801922:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801926:	8b 45 08             	mov    0x8(%ebp),%eax
  801929:	89 44 24 08          	mov    %eax,0x8(%esp)
  80192d:	a1 00 60 80 00       	mov    0x806000,%eax
  801932:	89 44 24 04          	mov    %eax,0x4(%esp)
  801936:	c7 04 24 32 29 80 00 	movl   $0x802932,(%esp)
  80193d:	e8 7f 00 00 00       	call   8019c1 <cprintf>
	vcprintf(fmt, ap);
  801942:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801946:	8b 45 10             	mov    0x10(%ebp),%eax
  801949:	89 04 24             	mov    %eax,(%esp)
  80194c:	e8 0f 00 00 00       	call   801960 <vcprintf>
	cprintf("\n");
  801951:	c7 04 24 1a 29 80 00 	movl   $0x80291a,(%esp)
  801958:	e8 64 00 00 00       	call   8019c1 <cprintf>

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  80195d:	cc                   	int3   
  80195e:	eb fd                	jmp    80195d <_panic+0x61>

00801960 <vcprintf>:
	b->cnt++;
}

int
vcprintf(const char *fmt, va_list ap)
{
  801960:	55                   	push   %ebp
  801961:	89 e5                	mov    %esp,%ebp
  801963:	81 ec 28 01 00 00    	sub    $0x128,%esp
	struct printbuf b;

	b.idx = 0;
  801969:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  801970:	00 00 00 
	b.cnt = 0;
  801973:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  80197a:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  80197d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801980:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801984:	8b 45 08             	mov    0x8(%ebp),%eax
  801987:	89 44 24 08          	mov    %eax,0x8(%esp)
  80198b:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  801991:	89 44 24 04          	mov    %eax,0x4(%esp)
  801995:	c7 04 24 db 19 80 00 	movl   $0x8019db,(%esp)
  80199c:	e8 cc 01 00 00       	call   801b6d <vprintfmt>
	sys_cputs(b.buf, b.idx);
  8019a1:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
  8019a7:	89 44 24 04          	mov    %eax,0x4(%esp)
  8019ab:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  8019b1:	89 04 24             	mov    %eax,(%esp)
  8019b4:	e8 23 e7 ff ff       	call   8000dc <sys_cputs>

	return b.cnt;
}
  8019b9:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  8019bf:	c9                   	leave  
  8019c0:	c3                   	ret    

008019c1 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  8019c1:	55                   	push   %ebp
  8019c2:	89 e5                	mov    %esp,%ebp
  8019c4:	83 ec 18             	sub    $0x18,%esp

	return b.cnt;
}

int
cprintf(const char *fmt, ...)
  8019c7:	8d 45 0c             	lea    0xc(%ebp),%eax
{
	va_list ap;
	int cnt;

	va_start(ap, fmt);
	cnt = vcprintf(fmt, ap);
  8019ca:	89 44 24 04          	mov    %eax,0x4(%esp)
  8019ce:	8b 45 08             	mov    0x8(%ebp),%eax
  8019d1:	89 04 24             	mov    %eax,(%esp)
  8019d4:	e8 87 ff ff ff       	call   801960 <vcprintf>
	va_end(ap);

	return cnt;
}
  8019d9:	c9                   	leave  
  8019da:	c3                   	ret    

008019db <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  8019db:	55                   	push   %ebp
  8019dc:	89 e5                	mov    %esp,%ebp
  8019de:	53                   	push   %ebx
  8019df:	83 ec 14             	sub    $0x14,%esp
  8019e2:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  8019e5:	8b 03                	mov    (%ebx),%eax
  8019e7:	8b 55 08             	mov    0x8(%ebp),%edx
  8019ea:	88 54 03 08          	mov    %dl,0x8(%ebx,%eax,1)
  8019ee:	83 c0 01             	add    $0x1,%eax
  8019f1:	89 03                	mov    %eax,(%ebx)
	if (b->idx == 256-1) {
  8019f3:	3d ff 00 00 00       	cmp    $0xff,%eax
  8019f8:	75 19                	jne    801a13 <putch+0x38>
		sys_cputs(b->buf, b->idx);
  8019fa:	c7 44 24 04 ff 00 00 	movl   $0xff,0x4(%esp)
  801a01:	00 
  801a02:	8d 43 08             	lea    0x8(%ebx),%eax
  801a05:	89 04 24             	mov    %eax,(%esp)
  801a08:	e8 cf e6 ff ff       	call   8000dc <sys_cputs>
		b->idx = 0;
  801a0d:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
	}
	b->cnt++;
  801a13:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  801a17:	83 c4 14             	add    $0x14,%esp
  801a1a:	5b                   	pop    %ebx
  801a1b:	5d                   	pop    %ebp
  801a1c:	c3                   	ret    
  801a1d:	00 00                	add    %al,(%eax)
	...

00801a20 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  801a20:	55                   	push   %ebp
  801a21:	89 e5                	mov    %esp,%ebp
  801a23:	57                   	push   %edi
  801a24:	56                   	push   %esi
  801a25:	53                   	push   %ebx
  801a26:	83 ec 4c             	sub    $0x4c,%esp
  801a29:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801a2c:	89 d6                	mov    %edx,%esi
  801a2e:	8b 45 08             	mov    0x8(%ebp),%eax
  801a31:	89 45 d8             	mov    %eax,-0x28(%ebp)
  801a34:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a37:	89 55 e0             	mov    %edx,-0x20(%ebp)
  801a3a:	8b 45 10             	mov    0x10(%ebp),%eax
  801a3d:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801a40:	8b 7d 18             	mov    0x18(%ebp),%edi
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  801a43:	89 45 dc             	mov    %eax,-0x24(%ebp)
  801a46:	b9 00 00 00 00       	mov    $0x0,%ecx
  801a4b:	39 d1                	cmp    %edx,%ecx
  801a4d:	72 15                	jb     801a64 <printnum+0x44>
  801a4f:	77 07                	ja     801a58 <printnum+0x38>
  801a51:	8b 55 d8             	mov    -0x28(%ebp),%edx
  801a54:	39 d0                	cmp    %edx,%eax
  801a56:	76 0c                	jbe    801a64 <printnum+0x44>
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  801a58:	83 eb 01             	sub    $0x1,%ebx
  801a5b:	85 db                	test   %ebx,%ebx
  801a5d:	8d 76 00             	lea    0x0(%esi),%esi
  801a60:	7f 61                	jg     801ac3 <printnum+0xa3>
  801a62:	eb 70                	jmp    801ad4 <printnum+0xb4>
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
  801a64:	89 7c 24 10          	mov    %edi,0x10(%esp)
  801a68:	83 eb 01             	sub    $0x1,%ebx
  801a6b:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  801a6f:	89 44 24 08          	mov    %eax,0x8(%esp)
  801a73:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  801a77:	8b 5c 24 0c          	mov    0xc(%esp),%ebx
  801a7b:	89 4d d0             	mov    %ecx,-0x30(%ebp)
  801a7e:	89 5d d4             	mov    %ebx,-0x2c(%ebp)
  801a81:	8b 5d dc             	mov    -0x24(%ebp),%ebx
  801a84:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801a88:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  801a8f:	00 
  801a90:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801a93:	89 04 24             	mov    %eax,(%esp)
  801a96:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801a99:	89 54 24 04          	mov    %edx,0x4(%esp)
  801a9d:	e8 be 0a 00 00       	call   802560 <__udivdi3>
  801aa2:	8b 4d d0             	mov    -0x30(%ebp),%ecx
  801aa5:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
  801aa8:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801aac:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  801ab0:	89 04 24             	mov    %eax,(%esp)
  801ab3:	89 54 24 04          	mov    %edx,0x4(%esp)
  801ab7:	89 f2                	mov    %esi,%edx
  801ab9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801abc:	e8 5f ff ff ff       	call   801a20 <printnum>
  801ac1:	eb 11                	jmp    801ad4 <printnum+0xb4>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  801ac3:	89 74 24 04          	mov    %esi,0x4(%esp)
  801ac7:	89 3c 24             	mov    %edi,(%esp)
  801aca:	ff 55 e4             	call   *-0x1c(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  801acd:	83 eb 01             	sub    $0x1,%ebx
  801ad0:	85 db                	test   %ebx,%ebx
  801ad2:	7f ef                	jg     801ac3 <printnum+0xa3>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  801ad4:	89 74 24 04          	mov    %esi,0x4(%esp)
  801ad8:	8b 74 24 04          	mov    0x4(%esp),%esi
  801adc:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801adf:	89 44 24 08          	mov    %eax,0x8(%esp)
  801ae3:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  801aea:	00 
  801aeb:	8b 55 d8             	mov    -0x28(%ebp),%edx
  801aee:	89 14 24             	mov    %edx,(%esp)
  801af1:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  801af4:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801af8:	e8 93 0b 00 00       	call   802690 <__umoddi3>
  801afd:	89 74 24 04          	mov    %esi,0x4(%esp)
  801b01:	0f be 80 4e 29 80 00 	movsbl 0x80294e(%eax),%eax
  801b08:	89 04 24             	mov    %eax,(%esp)
  801b0b:	ff 55 e4             	call   *-0x1c(%ebp)
}
  801b0e:	83 c4 4c             	add    $0x4c,%esp
  801b11:	5b                   	pop    %ebx
  801b12:	5e                   	pop    %esi
  801b13:	5f                   	pop    %edi
  801b14:	5d                   	pop    %ebp
  801b15:	c3                   	ret    

00801b16 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  801b16:	55                   	push   %ebp
  801b17:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  801b19:	83 fa 01             	cmp    $0x1,%edx
  801b1c:	7e 0e                	jle    801b2c <getuint+0x16>
		return va_arg(*ap, unsigned long long);
  801b1e:	8b 10                	mov    (%eax),%edx
  801b20:	8d 4a 08             	lea    0x8(%edx),%ecx
  801b23:	89 08                	mov    %ecx,(%eax)
  801b25:	8b 02                	mov    (%edx),%eax
  801b27:	8b 52 04             	mov    0x4(%edx),%edx
  801b2a:	eb 22                	jmp    801b4e <getuint+0x38>
	else if (lflag)
  801b2c:	85 d2                	test   %edx,%edx
  801b2e:	74 10                	je     801b40 <getuint+0x2a>
		return va_arg(*ap, unsigned long);
  801b30:	8b 10                	mov    (%eax),%edx
  801b32:	8d 4a 04             	lea    0x4(%edx),%ecx
  801b35:	89 08                	mov    %ecx,(%eax)
  801b37:	8b 02                	mov    (%edx),%eax
  801b39:	ba 00 00 00 00       	mov    $0x0,%edx
  801b3e:	eb 0e                	jmp    801b4e <getuint+0x38>
	else
		return va_arg(*ap, unsigned int);
  801b40:	8b 10                	mov    (%eax),%edx
  801b42:	8d 4a 04             	lea    0x4(%edx),%ecx
  801b45:	89 08                	mov    %ecx,(%eax)
  801b47:	8b 02                	mov    (%edx),%eax
  801b49:	ba 00 00 00 00       	mov    $0x0,%edx
}
  801b4e:	5d                   	pop    %ebp
  801b4f:	c3                   	ret    

00801b50 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  801b50:	55                   	push   %ebp
  801b51:	89 e5                	mov    %esp,%ebp
  801b53:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  801b56:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  801b5a:	8b 10                	mov    (%eax),%edx
  801b5c:	3b 50 04             	cmp    0x4(%eax),%edx
  801b5f:	73 0a                	jae    801b6b <sprintputch+0x1b>
		*b->buf++ = ch;
  801b61:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801b64:	88 0a                	mov    %cl,(%edx)
  801b66:	83 c2 01             	add    $0x1,%edx
  801b69:	89 10                	mov    %edx,(%eax)
}
  801b6b:	5d                   	pop    %ebp
  801b6c:	c3                   	ret    

00801b6d <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  801b6d:	55                   	push   %ebp
  801b6e:	89 e5                	mov    %esp,%ebp
  801b70:	57                   	push   %edi
  801b71:	56                   	push   %esi
  801b72:	53                   	push   %ebx
  801b73:	83 ec 5c             	sub    $0x5c,%esp
  801b76:	8b 7d 08             	mov    0x8(%ebp),%edi
  801b79:	8b 75 0c             	mov    0xc(%ebp),%esi
  801b7c:	8b 5d 10             	mov    0x10(%ebp),%ebx
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  801b7f:	c7 45 c8 ff ff ff ff 	movl   $0xffffffff,-0x38(%ebp)
  801b86:	eb 11                	jmp    801b99 <vprintfmt+0x2c>
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
  801b88:	85 c0                	test   %eax,%eax
  801b8a:	0f 84 ec 03 00 00    	je     801f7c <vprintfmt+0x40f>
				return;
			putch(ch, putdat);
  801b90:	89 74 24 04          	mov    %esi,0x4(%esp)
  801b94:	89 04 24             	mov    %eax,(%esp)
  801b97:	ff d7                	call   *%edi
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  801b99:	0f b6 03             	movzbl (%ebx),%eax
  801b9c:	83 c3 01             	add    $0x1,%ebx
  801b9f:	83 f8 25             	cmp    $0x25,%eax
  801ba2:	75 e4                	jne    801b88 <vprintfmt+0x1b>
  801ba4:	c6 45 d4 20          	movb   $0x20,-0x2c(%ebp)
  801ba8:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
  801baf:	c7 45 d0 ff ff ff ff 	movl   $0xffffffff,-0x30(%ebp)
  801bb6:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
  801bbd:	b9 00 00 00 00       	mov    $0x0,%ecx
  801bc2:	eb 06                	jmp    801bca <vprintfmt+0x5d>
  801bc4:	c6 45 d4 2d          	movb   $0x2d,-0x2c(%ebp)
  801bc8:	89 c3                	mov    %eax,%ebx
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  801bca:	0f b6 13             	movzbl (%ebx),%edx
  801bcd:	0f b6 c2             	movzbl %dl,%eax
  801bd0:	89 45 e0             	mov    %eax,-0x20(%ebp)
  801bd3:	8d 43 01             	lea    0x1(%ebx),%eax
  801bd6:	83 ea 23             	sub    $0x23,%edx
  801bd9:	80 fa 55             	cmp    $0x55,%dl
  801bdc:	0f 87 7d 03 00 00    	ja     801f5f <vprintfmt+0x3f2>
  801be2:	0f b6 d2             	movzbl %dl,%edx
  801be5:	ff 24 95 a0 2a 80 00 	jmp    *0x802aa0(,%edx,4)
  801bec:	c6 45 d4 30          	movb   $0x30,-0x2c(%ebp)
  801bf0:	eb d6                	jmp    801bc8 <vprintfmt+0x5b>
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
				precision = precision * 10 + ch - '0';
  801bf2:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801bf5:	83 ea 30             	sub    $0x30,%edx
  801bf8:	89 55 d0             	mov    %edx,-0x30(%ebp)
				ch = *fmt;
  801bfb:	0f be 10             	movsbl (%eax),%edx
				if (ch < '0' || ch > '9')
  801bfe:	8d 5a d0             	lea    -0x30(%edx),%ebx
  801c01:	83 fb 09             	cmp    $0x9,%ebx
  801c04:	77 4c                	ja     801c52 <vprintfmt+0xe5>
  801c06:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  801c09:	8b 4d d0             	mov    -0x30(%ebp),%ecx
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  801c0c:	83 c0 01             	add    $0x1,%eax
				precision = precision * 10 + ch - '0';
  801c0f:	8d 0c 89             	lea    (%ecx,%ecx,4),%ecx
  801c12:	8d 4c 4a d0          	lea    -0x30(%edx,%ecx,2),%ecx
				ch = *fmt;
  801c16:	0f be 10             	movsbl (%eax),%edx
				if (ch < '0' || ch > '9')
  801c19:	8d 5a d0             	lea    -0x30(%edx),%ebx
  801c1c:	83 fb 09             	cmp    $0x9,%ebx
  801c1f:	76 eb                	jbe    801c0c <vprintfmt+0x9f>
  801c21:	89 4d d0             	mov    %ecx,-0x30(%ebp)
  801c24:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  801c27:	eb 29                	jmp    801c52 <vprintfmt+0xe5>
					break;
			}
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  801c29:	8b 55 14             	mov    0x14(%ebp),%edx
  801c2c:	8d 5a 04             	lea    0x4(%edx),%ebx
  801c2f:	89 5d 14             	mov    %ebx,0x14(%ebp)
  801c32:	8b 12                	mov    (%edx),%edx
  801c34:	89 55 d0             	mov    %edx,-0x30(%ebp)
			goto process_precision;
  801c37:	eb 19                	jmp    801c52 <vprintfmt+0xe5>

		case '.':
			if (width < 0)
  801c39:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801c3c:	c1 fa 1f             	sar    $0x1f,%edx
  801c3f:	f7 d2                	not    %edx
  801c41:	21 55 e4             	and    %edx,-0x1c(%ebp)
  801c44:	eb 82                	jmp    801bc8 <vprintfmt+0x5b>
  801c46:	c7 45 d8 01 00 00 00 	movl   $0x1,-0x28(%ebp)
				width = 0;
			goto reswitch;

		case '#':
			altflag = 1;
			goto reswitch;
  801c4d:	e9 76 ff ff ff       	jmp    801bc8 <vprintfmt+0x5b>

		process_precision:
			if (width < 0)
  801c52:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801c56:	0f 89 6c ff ff ff    	jns    801bc8 <vprintfmt+0x5b>
  801c5c:	8b 55 d0             	mov    -0x30(%ebp),%edx
  801c5f:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  801c62:	8b 55 c8             	mov    -0x38(%ebp),%edx
  801c65:	89 55 d0             	mov    %edx,-0x30(%ebp)
  801c68:	e9 5b ff ff ff       	jmp    801bc8 <vprintfmt+0x5b>
				width = precision, precision = -1;
			goto reswitch;

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  801c6d:	83 c1 01             	add    $0x1,%ecx
			goto reswitch;
  801c70:	e9 53 ff ff ff       	jmp    801bc8 <vprintfmt+0x5b>
  801c75:	89 45 cc             	mov    %eax,-0x34(%ebp)

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  801c78:	8b 45 14             	mov    0x14(%ebp),%eax
  801c7b:	8d 50 04             	lea    0x4(%eax),%edx
  801c7e:	89 55 14             	mov    %edx,0x14(%ebp)
  801c81:	89 74 24 04          	mov    %esi,0x4(%esp)
  801c85:	8b 00                	mov    (%eax),%eax
  801c87:	89 04 24             	mov    %eax,(%esp)
  801c8a:	ff d7                	call   *%edi
  801c8c:	8b 5d cc             	mov    -0x34(%ebp),%ebx
			break;
  801c8f:	e9 05 ff ff ff       	jmp    801b99 <vprintfmt+0x2c>
  801c94:	89 45 cc             	mov    %eax,-0x34(%ebp)

		// error message
		case 'e':
			err = va_arg(ap, int);
  801c97:	8b 45 14             	mov    0x14(%ebp),%eax
  801c9a:	8d 50 04             	lea    0x4(%eax),%edx
  801c9d:	89 55 14             	mov    %edx,0x14(%ebp)
  801ca0:	8b 00                	mov    (%eax),%eax
  801ca2:	89 c2                	mov    %eax,%edx
  801ca4:	c1 fa 1f             	sar    $0x1f,%edx
  801ca7:	31 d0                	xor    %edx,%eax
  801ca9:	29 d0                	sub    %edx,%eax
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  801cab:	83 f8 0f             	cmp    $0xf,%eax
  801cae:	7f 0b                	jg     801cbb <vprintfmt+0x14e>
  801cb0:	8b 14 85 00 2c 80 00 	mov    0x802c00(,%eax,4),%edx
  801cb7:	85 d2                	test   %edx,%edx
  801cb9:	75 20                	jne    801cdb <vprintfmt+0x16e>
				printfmt(putch, putdat, "error %d", err);
  801cbb:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801cbf:	c7 44 24 08 5f 29 80 	movl   $0x80295f,0x8(%esp)
  801cc6:	00 
  801cc7:	89 74 24 04          	mov    %esi,0x4(%esp)
  801ccb:	89 3c 24             	mov    %edi,(%esp)
  801cce:	e8 31 03 00 00       	call   802004 <printfmt>
  801cd3:	8b 5d cc             	mov    -0x34(%ebp),%ebx
		// error message
		case 'e':
			err = va_arg(ap, int);
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  801cd6:	e9 be fe ff ff       	jmp    801b99 <vprintfmt+0x2c>
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  801cdb:	89 54 24 0c          	mov    %edx,0xc(%esp)
  801cdf:	c7 44 24 08 de 28 80 	movl   $0x8028de,0x8(%esp)
  801ce6:	00 
  801ce7:	89 74 24 04          	mov    %esi,0x4(%esp)
  801ceb:	89 3c 24             	mov    %edi,(%esp)
  801cee:	e8 11 03 00 00       	call   802004 <printfmt>
  801cf3:	8b 5d cc             	mov    -0x34(%ebp),%ebx
  801cf6:	e9 9e fe ff ff       	jmp    801b99 <vprintfmt+0x2c>
  801cfb:	89 45 cc             	mov    %eax,-0x34(%ebp)
  801cfe:	89 c3                	mov    %eax,%ebx
  801d00:	8b 4d d0             	mov    -0x30(%ebp),%ecx
  801d03:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801d06:	89 45 c4             	mov    %eax,-0x3c(%ebp)
			break;

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  801d09:	8b 45 14             	mov    0x14(%ebp),%eax
  801d0c:	8d 50 04             	lea    0x4(%eax),%edx
  801d0f:	89 55 14             	mov    %edx,0x14(%ebp)
  801d12:	8b 00                	mov    (%eax),%eax
  801d14:	89 45 e0             	mov    %eax,-0x20(%ebp)
  801d17:	85 c0                	test   %eax,%eax
  801d19:	75 07                	jne    801d22 <vprintfmt+0x1b5>
  801d1b:	c7 45 e0 68 29 80 00 	movl   $0x802968,-0x20(%ebp)
				p = "(null)";
			if (width > 0 && padc != '-')
  801d22:	83 7d c4 00          	cmpl   $0x0,-0x3c(%ebp)
  801d26:	7e 06                	jle    801d2e <vprintfmt+0x1c1>
  801d28:	80 7d d4 2d          	cmpb   $0x2d,-0x2c(%ebp)
  801d2c:	75 13                	jne    801d41 <vprintfmt+0x1d4>
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  801d2e:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801d31:	0f be 02             	movsbl (%edx),%eax
  801d34:	85 c0                	test   %eax,%eax
  801d36:	0f 85 99 00 00 00    	jne    801dd5 <vprintfmt+0x268>
  801d3c:	e9 86 00 00 00       	jmp    801dc7 <vprintfmt+0x25a>
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  801d41:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801d45:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  801d48:	89 0c 24             	mov    %ecx,(%esp)
  801d4b:	e8 fb 02 00 00       	call   80204b <strnlen>
  801d50:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  801d53:	29 c2                	sub    %eax,%edx
  801d55:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  801d58:	85 d2                	test   %edx,%edx
  801d5a:	7e d2                	jle    801d2e <vprintfmt+0x1c1>
					putch(padc, putdat);
  801d5c:	0f be 4d d4          	movsbl -0x2c(%ebp),%ecx
  801d60:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  801d63:	89 5d c4             	mov    %ebx,-0x3c(%ebp)
  801d66:	89 d3                	mov    %edx,%ebx
  801d68:	89 74 24 04          	mov    %esi,0x4(%esp)
  801d6c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801d6f:	89 04 24             	mov    %eax,(%esp)
  801d72:	ff d7                	call   *%edi
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  801d74:	83 eb 01             	sub    $0x1,%ebx
  801d77:	85 db                	test   %ebx,%ebx
  801d79:	7f ed                	jg     801d68 <vprintfmt+0x1fb>
  801d7b:	8b 5d c4             	mov    -0x3c(%ebp),%ebx
  801d7e:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  801d85:	eb a7                	jmp    801d2e <vprintfmt+0x1c1>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
  801d87:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  801d8b:	74 18                	je     801da5 <vprintfmt+0x238>
  801d8d:	8d 50 e0             	lea    -0x20(%eax),%edx
  801d90:	83 fa 5e             	cmp    $0x5e,%edx
  801d93:	76 10                	jbe    801da5 <vprintfmt+0x238>
					putch('?', putdat);
  801d95:	89 7c 24 04          	mov    %edi,0x4(%esp)
  801d99:	c7 04 24 3f 00 00 00 	movl   $0x3f,(%esp)
  801da0:	ff 55 e0             	call   *-0x20(%ebp)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
  801da3:	eb 0a                	jmp    801daf <vprintfmt+0x242>
					putch('?', putdat);
				else
					putch(ch, putdat);
  801da5:	89 7c 24 04          	mov    %edi,0x4(%esp)
  801da9:	89 04 24             	mov    %eax,(%esp)
  801dac:	ff 55 e0             	call   *-0x20(%ebp)
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  801daf:	83 6d e4 01          	subl   $0x1,-0x1c(%ebp)
  801db3:	0f be 03             	movsbl (%ebx),%eax
  801db6:	85 c0                	test   %eax,%eax
  801db8:	74 05                	je     801dbf <vprintfmt+0x252>
  801dba:	83 c3 01             	add    $0x1,%ebx
  801dbd:	eb 29                	jmp    801de8 <vprintfmt+0x27b>
  801dbf:	89 fe                	mov    %edi,%esi
  801dc1:	8b 7d e0             	mov    -0x20(%ebp),%edi
  801dc4:	8b 5d d0             	mov    -0x30(%ebp),%ebx
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  801dc7:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801dcb:	7f 2e                	jg     801dfb <vprintfmt+0x28e>
  801dcd:	8b 5d cc             	mov    -0x34(%ebp),%ebx
  801dd0:	e9 c4 fd ff ff       	jmp    801b99 <vprintfmt+0x2c>
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  801dd5:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801dd8:	83 c2 01             	add    $0x1,%edx
  801ddb:	89 7d e0             	mov    %edi,-0x20(%ebp)
  801dde:	89 f7                	mov    %esi,%edi
  801de0:	8b 75 d0             	mov    -0x30(%ebp),%esi
  801de3:	89 5d d0             	mov    %ebx,-0x30(%ebp)
  801de6:	89 d3                	mov    %edx,%ebx
  801de8:	85 f6                	test   %esi,%esi
  801dea:	78 9b                	js     801d87 <vprintfmt+0x21a>
  801dec:	83 ee 01             	sub    $0x1,%esi
  801def:	79 96                	jns    801d87 <vprintfmt+0x21a>
  801df1:	89 fe                	mov    %edi,%esi
  801df3:	8b 7d e0             	mov    -0x20(%ebp),%edi
  801df6:	8b 5d d0             	mov    -0x30(%ebp),%ebx
  801df9:	eb cc                	jmp    801dc7 <vprintfmt+0x25a>
  801dfb:	89 5d d8             	mov    %ebx,-0x28(%ebp)
  801dfe:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
				putch(' ', putdat);
  801e01:	89 74 24 04          	mov    %esi,0x4(%esp)
  801e05:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  801e0c:	ff d7                	call   *%edi
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  801e0e:	83 eb 01             	sub    $0x1,%ebx
  801e11:	85 db                	test   %ebx,%ebx
  801e13:	7f ec                	jg     801e01 <vprintfmt+0x294>
  801e15:	8b 5d d8             	mov    -0x28(%ebp),%ebx
  801e18:	e9 7c fd ff ff       	jmp    801b99 <vprintfmt+0x2c>
  801e1d:	89 45 cc             	mov    %eax,-0x34(%ebp)
// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
	if (lflag >= 2)
  801e20:	83 f9 01             	cmp    $0x1,%ecx
  801e23:	7e 16                	jle    801e3b <vprintfmt+0x2ce>
		return va_arg(*ap, long long);
  801e25:	8b 45 14             	mov    0x14(%ebp),%eax
  801e28:	8d 50 08             	lea    0x8(%eax),%edx
  801e2b:	89 55 14             	mov    %edx,0x14(%ebp)
  801e2e:	8b 10                	mov    (%eax),%edx
  801e30:	8b 48 04             	mov    0x4(%eax),%ecx
  801e33:	89 55 d8             	mov    %edx,-0x28(%ebp)
  801e36:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  801e39:	eb 32                	jmp    801e6d <vprintfmt+0x300>
	else if (lflag)
  801e3b:	85 c9                	test   %ecx,%ecx
  801e3d:	74 18                	je     801e57 <vprintfmt+0x2ea>
		return va_arg(*ap, long);
  801e3f:	8b 45 14             	mov    0x14(%ebp),%eax
  801e42:	8d 50 04             	lea    0x4(%eax),%edx
  801e45:	89 55 14             	mov    %edx,0x14(%ebp)
  801e48:	8b 00                	mov    (%eax),%eax
  801e4a:	89 45 d8             	mov    %eax,-0x28(%ebp)
  801e4d:	89 c1                	mov    %eax,%ecx
  801e4f:	c1 f9 1f             	sar    $0x1f,%ecx
  801e52:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  801e55:	eb 16                	jmp    801e6d <vprintfmt+0x300>
	else
		return va_arg(*ap, int);
  801e57:	8b 45 14             	mov    0x14(%ebp),%eax
  801e5a:	8d 50 04             	lea    0x4(%eax),%edx
  801e5d:	89 55 14             	mov    %edx,0x14(%ebp)
  801e60:	8b 00                	mov    (%eax),%eax
  801e62:	89 45 d8             	mov    %eax,-0x28(%ebp)
  801e65:	89 c2                	mov    %eax,%edx
  801e67:	c1 fa 1f             	sar    $0x1f,%edx
  801e6a:	89 55 dc             	mov    %edx,-0x24(%ebp)
				putch(' ', putdat);
			break;

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  801e6d:	8b 4d d8             	mov    -0x28(%ebp),%ecx
  801e70:	8b 5d dc             	mov    -0x24(%ebp),%ebx
  801e73:	b8 0a 00 00 00       	mov    $0xa,%eax
			if ((long long) num < 0) {
  801e78:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  801e7c:	0f 89 9b 00 00 00    	jns    801f1d <vprintfmt+0x3b0>
				putch('-', putdat);
  801e82:	89 74 24 04          	mov    %esi,0x4(%esp)
  801e86:	c7 04 24 2d 00 00 00 	movl   $0x2d,(%esp)
  801e8d:	ff d7                	call   *%edi
				num = -(long long) num;
  801e8f:	8b 4d d8             	mov    -0x28(%ebp),%ecx
  801e92:	8b 5d dc             	mov    -0x24(%ebp),%ebx
  801e95:	f7 d9                	neg    %ecx
  801e97:	83 d3 00             	adc    $0x0,%ebx
  801e9a:	f7 db                	neg    %ebx
  801e9c:	b8 0a 00 00 00       	mov    $0xa,%eax
  801ea1:	eb 7a                	jmp    801f1d <vprintfmt+0x3b0>
  801ea3:	89 45 cc             	mov    %eax,-0x34(%ebp)
			base = 10;
			goto number;

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  801ea6:	89 ca                	mov    %ecx,%edx
  801ea8:	8d 45 14             	lea    0x14(%ebp),%eax
  801eab:	e8 66 fc ff ff       	call   801b16 <getuint>
  801eb0:	89 c1                	mov    %eax,%ecx
  801eb2:	89 d3                	mov    %edx,%ebx
  801eb4:	b8 0a 00 00 00       	mov    $0xa,%eax
			base = 10;
			goto number;
  801eb9:	eb 62                	jmp    801f1d <vprintfmt+0x3b0>
  801ebb:	89 45 cc             	mov    %eax,-0x34(%ebp)
		case 'o':
			// Replace this with your code.
			// putch('X', putdat);
			// putch('X', putdat);
			// putch('X', putdat);
			num = getuint(&ap, lflag);
  801ebe:	89 ca                	mov    %ecx,%edx
  801ec0:	8d 45 14             	lea    0x14(%ebp),%eax
  801ec3:	e8 4e fc ff ff       	call   801b16 <getuint>
  801ec8:	89 c1                	mov    %eax,%ecx
  801eca:	89 d3                	mov    %edx,%ebx
  801ecc:	b8 08 00 00 00       	mov    $0x8,%eax
			base = 8;
			goto number;
  801ed1:	eb 4a                	jmp    801f1d <vprintfmt+0x3b0>
  801ed3:	89 45 cc             	mov    %eax,-0x34(%ebp)
			break;

		// pointer
		case 'p':
			putch('0', putdat);
  801ed6:	89 74 24 04          	mov    %esi,0x4(%esp)
  801eda:	c7 04 24 30 00 00 00 	movl   $0x30,(%esp)
  801ee1:	ff d7                	call   *%edi
			putch('x', putdat);
  801ee3:	89 74 24 04          	mov    %esi,0x4(%esp)
  801ee7:	c7 04 24 78 00 00 00 	movl   $0x78,(%esp)
  801eee:	ff d7                	call   *%edi
			num = (unsigned long long)
  801ef0:	8b 45 14             	mov    0x14(%ebp),%eax
  801ef3:	8d 50 04             	lea    0x4(%eax),%edx
  801ef6:	89 55 14             	mov    %edx,0x14(%ebp)
  801ef9:	8b 08                	mov    (%eax),%ecx
  801efb:	bb 00 00 00 00       	mov    $0x0,%ebx
  801f00:	b8 10 00 00 00       	mov    $0x10,%eax
				(uintptr_t) va_arg(ap, void *);
			base = 16;
			goto number;
  801f05:	eb 16                	jmp    801f1d <vprintfmt+0x3b0>
  801f07:	89 45 cc             	mov    %eax,-0x34(%ebp)

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  801f0a:	89 ca                	mov    %ecx,%edx
  801f0c:	8d 45 14             	lea    0x14(%ebp),%eax
  801f0f:	e8 02 fc ff ff       	call   801b16 <getuint>
  801f14:	89 c1                	mov    %eax,%ecx
  801f16:	89 d3                	mov    %edx,%ebx
  801f18:	b8 10 00 00 00       	mov    $0x10,%eax
			base = 16;
		number:
			printnum(putch, putdat, num, base, width, padc);
  801f1d:	0f be 55 d4          	movsbl -0x2c(%ebp),%edx
  801f21:	89 54 24 10          	mov    %edx,0x10(%esp)
  801f25:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801f28:	89 54 24 0c          	mov    %edx,0xc(%esp)
  801f2c:	89 44 24 08          	mov    %eax,0x8(%esp)
  801f30:	89 0c 24             	mov    %ecx,(%esp)
  801f33:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801f37:	89 f2                	mov    %esi,%edx
  801f39:	89 f8                	mov    %edi,%eax
  801f3b:	e8 e0 fa ff ff       	call   801a20 <printnum>
  801f40:	8b 5d cc             	mov    -0x34(%ebp),%ebx
			break;
  801f43:	e9 51 fc ff ff       	jmp    801b99 <vprintfmt+0x2c>
  801f48:	89 45 cc             	mov    %eax,-0x34(%ebp)
  801f4b:	8b 55 e0             	mov    -0x20(%ebp),%edx

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  801f4e:	89 74 24 04          	mov    %esi,0x4(%esp)
  801f52:	89 14 24             	mov    %edx,(%esp)
  801f55:	ff d7                	call   *%edi
  801f57:	8b 5d cc             	mov    -0x34(%ebp),%ebx
			break;
  801f5a:	e9 3a fc ff ff       	jmp    801b99 <vprintfmt+0x2c>
			
		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  801f5f:	89 74 24 04          	mov    %esi,0x4(%esp)
  801f63:	c7 04 24 25 00 00 00 	movl   $0x25,(%esp)
  801f6a:	ff d7                	call   *%edi
			for (fmt--; fmt[-1] != '%'; fmt--)
  801f6c:	8d 43 ff             	lea    -0x1(%ebx),%eax
  801f6f:	80 38 25             	cmpb   $0x25,(%eax)
  801f72:	0f 84 21 fc ff ff    	je     801b99 <vprintfmt+0x2c>
  801f78:	89 c3                	mov    %eax,%ebx
  801f7a:	eb f0                	jmp    801f6c <vprintfmt+0x3ff>
				/* do nothing */;
			break;
		}
	}
}
  801f7c:	83 c4 5c             	add    $0x5c,%esp
  801f7f:	5b                   	pop    %ebx
  801f80:	5e                   	pop    %esi
  801f81:	5f                   	pop    %edi
  801f82:	5d                   	pop    %ebp
  801f83:	c3                   	ret    

00801f84 <vsnprintf>:
		*b->buf++ = ch;
}

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  801f84:	55                   	push   %ebp
  801f85:	89 e5                	mov    %esp,%ebp
  801f87:	83 ec 28             	sub    $0x28,%esp
  801f8a:	8b 45 08             	mov    0x8(%ebp),%eax
  801f8d:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};

	if (buf == NULL || n < 1)
  801f90:	85 c0                	test   %eax,%eax
  801f92:	74 04                	je     801f98 <vsnprintf+0x14>
  801f94:	85 d2                	test   %edx,%edx
  801f96:	7f 07                	jg     801f9f <vsnprintf+0x1b>
  801f98:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801f9d:	eb 3b                	jmp    801fda <vsnprintf+0x56>
}

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
	struct sprintbuf b = {buf, buf+n-1, 0};
  801f9f:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801fa2:	8d 44 10 ff          	lea    -0x1(%eax,%edx,1),%eax
  801fa6:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801fa9:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  801fb0:	8b 45 14             	mov    0x14(%ebp),%eax
  801fb3:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801fb7:	8b 45 10             	mov    0x10(%ebp),%eax
  801fba:	89 44 24 08          	mov    %eax,0x8(%esp)
  801fbe:	8d 45 ec             	lea    -0x14(%ebp),%eax
  801fc1:	89 44 24 04          	mov    %eax,0x4(%esp)
  801fc5:	c7 04 24 50 1b 80 00 	movl   $0x801b50,(%esp)
  801fcc:	e8 9c fb ff ff       	call   801b6d <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  801fd1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801fd4:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  801fd7:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  801fda:	c9                   	leave  
  801fdb:	c3                   	ret    

00801fdc <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  801fdc:	55                   	push   %ebp
  801fdd:	89 e5                	mov    %esp,%ebp
  801fdf:	83 ec 18             	sub    $0x18,%esp

	return b.cnt;
}

int
snprintf(char *buf, int n, const char *fmt, ...)
  801fe2:	8d 45 14             	lea    0x14(%ebp),%eax
{
	va_list ap;
	int rc;

	va_start(ap, fmt);
	rc = vsnprintf(buf, n, fmt, ap);
  801fe5:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801fe9:	8b 45 10             	mov    0x10(%ebp),%eax
  801fec:	89 44 24 08          	mov    %eax,0x8(%esp)
  801ff0:	8b 45 0c             	mov    0xc(%ebp),%eax
  801ff3:	89 44 24 04          	mov    %eax,0x4(%esp)
  801ff7:	8b 45 08             	mov    0x8(%ebp),%eax
  801ffa:	89 04 24             	mov    %eax,(%esp)
  801ffd:	e8 82 ff ff ff       	call   801f84 <vsnprintf>
	va_end(ap);

	return rc;
}
  802002:	c9                   	leave  
  802003:	c3                   	ret    

00802004 <printfmt>:
	}
}

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  802004:	55                   	push   %ebp
  802005:	89 e5                	mov    %esp,%ebp
  802007:	83 ec 18             	sub    $0x18,%esp
		}
	}
}

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
  80200a:	8d 45 14             	lea    0x14(%ebp),%eax
{
	va_list ap;

	va_start(ap, fmt);
	vprintfmt(putch, putdat, fmt, ap);
  80200d:	89 44 24 0c          	mov    %eax,0xc(%esp)
  802011:	8b 45 10             	mov    0x10(%ebp),%eax
  802014:	89 44 24 08          	mov    %eax,0x8(%esp)
  802018:	8b 45 0c             	mov    0xc(%ebp),%eax
  80201b:	89 44 24 04          	mov    %eax,0x4(%esp)
  80201f:	8b 45 08             	mov    0x8(%ebp),%eax
  802022:	89 04 24             	mov    %eax,(%esp)
  802025:	e8 43 fb ff ff       	call   801b6d <vprintfmt>
	va_end(ap);
}
  80202a:	c9                   	leave  
  80202b:	c3                   	ret    
  80202c:	00 00                	add    %al,(%eax)
	...

00802030 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  802030:	55                   	push   %ebp
  802031:	89 e5                	mov    %esp,%ebp
  802033:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  802036:	b8 00 00 00 00       	mov    $0x0,%eax
  80203b:	80 3a 00             	cmpb   $0x0,(%edx)
  80203e:	74 09                	je     802049 <strlen+0x19>
		n++;
  802040:	83 c0 01             	add    $0x1,%eax
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  802043:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  802047:	75 f7                	jne    802040 <strlen+0x10>
		n++;
	return n;
}
  802049:	5d                   	pop    %ebp
  80204a:	c3                   	ret    

0080204b <strnlen>:

int
strnlen(const char *s, size_t size)
{
  80204b:	55                   	push   %ebp
  80204c:	89 e5                	mov    %esp,%ebp
  80204e:	53                   	push   %ebx
  80204f:	8b 5d 08             	mov    0x8(%ebp),%ebx
  802052:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  802055:	85 c9                	test   %ecx,%ecx
  802057:	74 19                	je     802072 <strnlen+0x27>
  802059:	80 3b 00             	cmpb   $0x0,(%ebx)
  80205c:	74 14                	je     802072 <strnlen+0x27>
  80205e:	b8 00 00 00 00       	mov    $0x0,%eax
		n++;
  802063:	83 c0 01             	add    $0x1,%eax
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  802066:	39 c8                	cmp    %ecx,%eax
  802068:	74 0d                	je     802077 <strnlen+0x2c>
  80206a:	80 3c 03 00          	cmpb   $0x0,(%ebx,%eax,1)
  80206e:	75 f3                	jne    802063 <strnlen+0x18>
  802070:	eb 05                	jmp    802077 <strnlen+0x2c>
  802072:	b8 00 00 00 00       	mov    $0x0,%eax
		n++;
	return n;
}
  802077:	5b                   	pop    %ebx
  802078:	5d                   	pop    %ebp
  802079:	c3                   	ret    

0080207a <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  80207a:	55                   	push   %ebp
  80207b:	89 e5                	mov    %esp,%ebp
  80207d:	53                   	push   %ebx
  80207e:	8b 45 08             	mov    0x8(%ebp),%eax
  802081:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  802084:	ba 00 00 00 00       	mov    $0x0,%edx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  802089:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
  80208d:	88 0c 10             	mov    %cl,(%eax,%edx,1)
  802090:	83 c2 01             	add    $0x1,%edx
  802093:	84 c9                	test   %cl,%cl
  802095:	75 f2                	jne    802089 <strcpy+0xf>
		/* do nothing */;
	return ret;
}
  802097:	5b                   	pop    %ebx
  802098:	5d                   	pop    %ebp
  802099:	c3                   	ret    

0080209a <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  80209a:	55                   	push   %ebp
  80209b:	89 e5                	mov    %esp,%ebp
  80209d:	56                   	push   %esi
  80209e:	53                   	push   %ebx
  80209f:	8b 45 08             	mov    0x8(%ebp),%eax
  8020a2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8020a5:	8b 75 10             	mov    0x10(%ebp),%esi
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  8020a8:	85 f6                	test   %esi,%esi
  8020aa:	74 18                	je     8020c4 <strncpy+0x2a>
  8020ac:	b9 00 00 00 00       	mov    $0x0,%ecx
		*dst++ = *src;
  8020b1:	0f b6 1a             	movzbl (%edx),%ebx
  8020b4:	88 1c 08             	mov    %bl,(%eax,%ecx,1)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  8020b7:	80 3a 01             	cmpb   $0x1,(%edx)
  8020ba:	83 da ff             	sbb    $0xffffffff,%edx
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  8020bd:	83 c1 01             	add    $0x1,%ecx
  8020c0:	39 ce                	cmp    %ecx,%esi
  8020c2:	77 ed                	ja     8020b1 <strncpy+0x17>
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
}
  8020c4:	5b                   	pop    %ebx
  8020c5:	5e                   	pop    %esi
  8020c6:	5d                   	pop    %ebp
  8020c7:	c3                   	ret    

008020c8 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  8020c8:	55                   	push   %ebp
  8020c9:	89 e5                	mov    %esp,%ebp
  8020cb:	56                   	push   %esi
  8020cc:	53                   	push   %ebx
  8020cd:	8b 75 08             	mov    0x8(%ebp),%esi
  8020d0:	8b 55 0c             	mov    0xc(%ebp),%edx
  8020d3:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  8020d6:	89 f0                	mov    %esi,%eax
  8020d8:	85 c9                	test   %ecx,%ecx
  8020da:	74 27                	je     802103 <strlcpy+0x3b>
		while (--size > 0 && *src != '\0')
  8020dc:	83 e9 01             	sub    $0x1,%ecx
  8020df:	74 1d                	je     8020fe <strlcpy+0x36>
  8020e1:	0f b6 1a             	movzbl (%edx),%ebx
  8020e4:	84 db                	test   %bl,%bl
  8020e6:	74 16                	je     8020fe <strlcpy+0x36>
			*dst++ = *src++;
  8020e8:	88 18                	mov    %bl,(%eax)
  8020ea:	83 c0 01             	add    $0x1,%eax
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  8020ed:	83 e9 01             	sub    $0x1,%ecx
  8020f0:	74 0e                	je     802100 <strlcpy+0x38>
			*dst++ = *src++;
  8020f2:	83 c2 01             	add    $0x1,%edx
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  8020f5:	0f b6 1a             	movzbl (%edx),%ebx
  8020f8:	84 db                	test   %bl,%bl
  8020fa:	75 ec                	jne    8020e8 <strlcpy+0x20>
  8020fc:	eb 02                	jmp    802100 <strlcpy+0x38>
  8020fe:	89 f0                	mov    %esi,%eax
			*dst++ = *src++;
		*dst = '\0';
  802100:	c6 00 00             	movb   $0x0,(%eax)
  802103:	29 f0                	sub    %esi,%eax
	}
	return dst - dst_in;
}
  802105:	5b                   	pop    %ebx
  802106:	5e                   	pop    %esi
  802107:	5d                   	pop    %ebp
  802108:	c3                   	ret    

00802109 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  802109:	55                   	push   %ebp
  80210a:	89 e5                	mov    %esp,%ebp
  80210c:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80210f:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  802112:	0f b6 01             	movzbl (%ecx),%eax
  802115:	84 c0                	test   %al,%al
  802117:	74 15                	je     80212e <strcmp+0x25>
  802119:	3a 02                	cmp    (%edx),%al
  80211b:	75 11                	jne    80212e <strcmp+0x25>
		p++, q++;
  80211d:	83 c1 01             	add    $0x1,%ecx
  802120:	83 c2 01             	add    $0x1,%edx
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  802123:	0f b6 01             	movzbl (%ecx),%eax
  802126:	84 c0                	test   %al,%al
  802128:	74 04                	je     80212e <strcmp+0x25>
  80212a:	3a 02                	cmp    (%edx),%al
  80212c:	74 ef                	je     80211d <strcmp+0x14>
  80212e:	0f b6 c0             	movzbl %al,%eax
  802131:	0f b6 12             	movzbl (%edx),%edx
  802134:	29 d0                	sub    %edx,%eax
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
}
  802136:	5d                   	pop    %ebp
  802137:	c3                   	ret    

00802138 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  802138:	55                   	push   %ebp
  802139:	89 e5                	mov    %esp,%ebp
  80213b:	53                   	push   %ebx
  80213c:	8b 55 08             	mov    0x8(%ebp),%edx
  80213f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  802142:	8b 45 10             	mov    0x10(%ebp),%eax
	while (n > 0 && *p && *p == *q)
  802145:	85 c0                	test   %eax,%eax
  802147:	74 23                	je     80216c <strncmp+0x34>
  802149:	0f b6 1a             	movzbl (%edx),%ebx
  80214c:	84 db                	test   %bl,%bl
  80214e:	74 24                	je     802174 <strncmp+0x3c>
  802150:	3a 19                	cmp    (%ecx),%bl
  802152:	75 20                	jne    802174 <strncmp+0x3c>
  802154:	83 e8 01             	sub    $0x1,%eax
  802157:	74 13                	je     80216c <strncmp+0x34>
		n--, p++, q++;
  802159:	83 c2 01             	add    $0x1,%edx
  80215c:	83 c1 01             	add    $0x1,%ecx
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  80215f:	0f b6 1a             	movzbl (%edx),%ebx
  802162:	84 db                	test   %bl,%bl
  802164:	74 0e                	je     802174 <strncmp+0x3c>
  802166:	3a 19                	cmp    (%ecx),%bl
  802168:	74 ea                	je     802154 <strncmp+0x1c>
  80216a:	eb 08                	jmp    802174 <strncmp+0x3c>
  80216c:	b8 00 00 00 00       	mov    $0x0,%eax
		n--, p++, q++;
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
}
  802171:	5b                   	pop    %ebx
  802172:	5d                   	pop    %ebp
  802173:	c3                   	ret    
	while (n > 0 && *p && *p == *q)
		n--, p++, q++;
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  802174:	0f b6 02             	movzbl (%edx),%eax
  802177:	0f b6 11             	movzbl (%ecx),%edx
  80217a:	29 d0                	sub    %edx,%eax
  80217c:	eb f3                	jmp    802171 <strncmp+0x39>

0080217e <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  80217e:	55                   	push   %ebp
  80217f:	89 e5                	mov    %esp,%ebp
  802181:	8b 45 08             	mov    0x8(%ebp),%eax
  802184:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  802188:	0f b6 10             	movzbl (%eax),%edx
  80218b:	84 d2                	test   %dl,%dl
  80218d:	74 15                	je     8021a4 <strchr+0x26>
		if (*s == c)
  80218f:	38 ca                	cmp    %cl,%dl
  802191:	75 07                	jne    80219a <strchr+0x1c>
  802193:	eb 14                	jmp    8021a9 <strchr+0x2b>
  802195:	38 ca                	cmp    %cl,%dl
  802197:	90                   	nop
  802198:	74 0f                	je     8021a9 <strchr+0x2b>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  80219a:	83 c0 01             	add    $0x1,%eax
  80219d:	0f b6 10             	movzbl (%eax),%edx
  8021a0:	84 d2                	test   %dl,%dl
  8021a2:	75 f1                	jne    802195 <strchr+0x17>
  8021a4:	b8 00 00 00 00       	mov    $0x0,%eax
		if (*s == c)
			return (char *) s;
	return 0;
}
  8021a9:	5d                   	pop    %ebp
  8021aa:	c3                   	ret    

008021ab <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  8021ab:	55                   	push   %ebp
  8021ac:	89 e5                	mov    %esp,%ebp
  8021ae:	8b 45 08             	mov    0x8(%ebp),%eax
  8021b1:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  8021b5:	0f b6 10             	movzbl (%eax),%edx
  8021b8:	84 d2                	test   %dl,%dl
  8021ba:	74 18                	je     8021d4 <strfind+0x29>
		if (*s == c)
  8021bc:	38 ca                	cmp    %cl,%dl
  8021be:	75 0a                	jne    8021ca <strfind+0x1f>
  8021c0:	eb 12                	jmp    8021d4 <strfind+0x29>
  8021c2:	38 ca                	cmp    %cl,%dl
  8021c4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  8021c8:	74 0a                	je     8021d4 <strfind+0x29>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  8021ca:	83 c0 01             	add    $0x1,%eax
  8021cd:	0f b6 10             	movzbl (%eax),%edx
  8021d0:	84 d2                	test   %dl,%dl
  8021d2:	75 ee                	jne    8021c2 <strfind+0x17>
		if (*s == c)
			break;
	return (char *) s;
}
  8021d4:	5d                   	pop    %ebp
  8021d5:	c3                   	ret    

008021d6 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  8021d6:	55                   	push   %ebp
  8021d7:	89 e5                	mov    %esp,%ebp
  8021d9:	83 ec 0c             	sub    $0xc,%esp
  8021dc:	89 1c 24             	mov    %ebx,(%esp)
  8021df:	89 74 24 04          	mov    %esi,0x4(%esp)
  8021e3:	89 7c 24 08          	mov    %edi,0x8(%esp)
  8021e7:	8b 7d 08             	mov    0x8(%ebp),%edi
  8021ea:	8b 45 0c             	mov    0xc(%ebp),%eax
  8021ed:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  8021f0:	85 c9                	test   %ecx,%ecx
  8021f2:	74 30                	je     802224 <memset+0x4e>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  8021f4:	f7 c7 03 00 00 00    	test   $0x3,%edi
  8021fa:	75 25                	jne    802221 <memset+0x4b>
  8021fc:	f6 c1 03             	test   $0x3,%cl
  8021ff:	75 20                	jne    802221 <memset+0x4b>
		c &= 0xFF;
  802201:	0f b6 d0             	movzbl %al,%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  802204:	89 d3                	mov    %edx,%ebx
  802206:	c1 e3 08             	shl    $0x8,%ebx
  802209:	89 d6                	mov    %edx,%esi
  80220b:	c1 e6 18             	shl    $0x18,%esi
  80220e:	89 d0                	mov    %edx,%eax
  802210:	c1 e0 10             	shl    $0x10,%eax
  802213:	09 f0                	or     %esi,%eax
  802215:	09 d0                	or     %edx,%eax
		asm volatile("cld; rep stosl\n"
  802217:	09 d8                	or     %ebx,%eax
  802219:	c1 e9 02             	shr    $0x2,%ecx
  80221c:	fc                   	cld    
  80221d:	f3 ab                	rep stos %eax,%es:(%edi)
{
	char *p;

	if (n == 0)
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  80221f:	eb 03                	jmp    802224 <memset+0x4e>
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  802221:	fc                   	cld    
  802222:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  802224:	89 f8                	mov    %edi,%eax
  802226:	8b 1c 24             	mov    (%esp),%ebx
  802229:	8b 74 24 04          	mov    0x4(%esp),%esi
  80222d:	8b 7c 24 08          	mov    0x8(%esp),%edi
  802231:	89 ec                	mov    %ebp,%esp
  802233:	5d                   	pop    %ebp
  802234:	c3                   	ret    

00802235 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  802235:	55                   	push   %ebp
  802236:	89 e5                	mov    %esp,%ebp
  802238:	83 ec 08             	sub    $0x8,%esp
  80223b:	89 34 24             	mov    %esi,(%esp)
  80223e:	89 7c 24 04          	mov    %edi,0x4(%esp)
  802242:	8b 45 08             	mov    0x8(%ebp),%eax
  802245:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;
	
	s = src;
  802248:	8b 75 0c             	mov    0xc(%ebp),%esi
	d = dst;
  80224b:	89 c7                	mov    %eax,%edi
	if (s < d && s + n > d) {
  80224d:	39 c6                	cmp    %eax,%esi
  80224f:	73 35                	jae    802286 <memmove+0x51>
  802251:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  802254:	39 d0                	cmp    %edx,%eax
  802256:	73 2e                	jae    802286 <memmove+0x51>
		s += n;
		d += n;
  802258:	01 cf                	add    %ecx,%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  80225a:	f6 c2 03             	test   $0x3,%dl
  80225d:	75 1b                	jne    80227a <memmove+0x45>
  80225f:	f7 c7 03 00 00 00    	test   $0x3,%edi
  802265:	75 13                	jne    80227a <memmove+0x45>
  802267:	f6 c1 03             	test   $0x3,%cl
  80226a:	75 0e                	jne    80227a <memmove+0x45>
			asm volatile("std; rep movsl\n"
  80226c:	83 ef 04             	sub    $0x4,%edi
  80226f:	8d 72 fc             	lea    -0x4(%edx),%esi
  802272:	c1 e9 02             	shr    $0x2,%ecx
  802275:	fd                   	std    
  802276:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  802278:	eb 09                	jmp    802283 <memmove+0x4e>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  80227a:	83 ef 01             	sub    $0x1,%edi
  80227d:	8d 72 ff             	lea    -0x1(%edx),%esi
  802280:	fd                   	std    
  802281:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  802283:	fc                   	cld    
	const char *s;
	char *d;
	
	s = src;
	d = dst;
	if (s < d && s + n > d) {
  802284:	eb 20                	jmp    8022a6 <memmove+0x71>
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  802286:	f7 c6 03 00 00 00    	test   $0x3,%esi
  80228c:	75 15                	jne    8022a3 <memmove+0x6e>
  80228e:	f7 c7 03 00 00 00    	test   $0x3,%edi
  802294:	75 0d                	jne    8022a3 <memmove+0x6e>
  802296:	f6 c1 03             	test   $0x3,%cl
  802299:	75 08                	jne    8022a3 <memmove+0x6e>
			asm volatile("cld; rep movsl\n"
  80229b:	c1 e9 02             	shr    $0x2,%ecx
  80229e:	fc                   	cld    
  80229f:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  8022a1:	eb 03                	jmp    8022a6 <memmove+0x71>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  8022a3:	fc                   	cld    
  8022a4:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  8022a6:	8b 34 24             	mov    (%esp),%esi
  8022a9:	8b 7c 24 04          	mov    0x4(%esp),%edi
  8022ad:	89 ec                	mov    %ebp,%esp
  8022af:	5d                   	pop    %ebp
  8022b0:	c3                   	ret    

008022b1 <memcpy>:

/* sigh - gcc emits references to this for structure assignments! */
/* it is *not* prototyped in inc/string.h - do not use directly. */
void *
memcpy(void *dst, void *src, size_t n)
{
  8022b1:	55                   	push   %ebp
  8022b2:	89 e5                	mov    %esp,%ebp
  8022b4:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  8022b7:	8b 45 10             	mov    0x10(%ebp),%eax
  8022ba:	89 44 24 08          	mov    %eax,0x8(%esp)
  8022be:	8b 45 0c             	mov    0xc(%ebp),%eax
  8022c1:	89 44 24 04          	mov    %eax,0x4(%esp)
  8022c5:	8b 45 08             	mov    0x8(%ebp),%eax
  8022c8:	89 04 24             	mov    %eax,(%esp)
  8022cb:	e8 65 ff ff ff       	call   802235 <memmove>
}
  8022d0:	c9                   	leave  
  8022d1:	c3                   	ret    

008022d2 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  8022d2:	55                   	push   %ebp
  8022d3:	89 e5                	mov    %esp,%ebp
  8022d5:	57                   	push   %edi
  8022d6:	56                   	push   %esi
  8022d7:	53                   	push   %ebx
  8022d8:	8b 75 08             	mov    0x8(%ebp),%esi
  8022db:	8b 7d 0c             	mov    0xc(%ebp),%edi
  8022de:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  8022e1:	85 c9                	test   %ecx,%ecx
  8022e3:	74 36                	je     80231b <memcmp+0x49>
		if (*s1 != *s2)
  8022e5:	0f b6 06             	movzbl (%esi),%eax
  8022e8:	0f b6 1f             	movzbl (%edi),%ebx
  8022eb:	38 d8                	cmp    %bl,%al
  8022ed:	74 20                	je     80230f <memcmp+0x3d>
  8022ef:	eb 14                	jmp    802305 <memcmp+0x33>
  8022f1:	0f b6 44 16 01       	movzbl 0x1(%esi,%edx,1),%eax
  8022f6:	0f b6 5c 17 01       	movzbl 0x1(%edi,%edx,1),%ebx
  8022fb:	83 c2 01             	add    $0x1,%edx
  8022fe:	83 e9 01             	sub    $0x1,%ecx
  802301:	38 d8                	cmp    %bl,%al
  802303:	74 12                	je     802317 <memcmp+0x45>
			return (int) *s1 - (int) *s2;
  802305:	0f b6 c0             	movzbl %al,%eax
  802308:	0f b6 db             	movzbl %bl,%ebx
  80230b:	29 d8                	sub    %ebx,%eax
  80230d:	eb 11                	jmp    802320 <memcmp+0x4e>
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  80230f:	83 e9 01             	sub    $0x1,%ecx
  802312:	ba 00 00 00 00       	mov    $0x0,%edx
  802317:	85 c9                	test   %ecx,%ecx
  802319:	75 d6                	jne    8022f1 <memcmp+0x1f>
  80231b:	b8 00 00 00 00       	mov    $0x0,%eax
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
}
  802320:	5b                   	pop    %ebx
  802321:	5e                   	pop    %esi
  802322:	5f                   	pop    %edi
  802323:	5d                   	pop    %ebp
  802324:	c3                   	ret    

00802325 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  802325:	55                   	push   %ebp
  802326:	89 e5                	mov    %esp,%ebp
  802328:	8b 45 08             	mov    0x8(%ebp),%eax
	const void *ends = (const char *) s + n;
  80232b:	89 c2                	mov    %eax,%edx
  80232d:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  802330:	39 d0                	cmp    %edx,%eax
  802332:	73 15                	jae    802349 <memfind+0x24>
		if (*(const unsigned char *) s == (unsigned char) c)
  802334:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
  802338:	38 08                	cmp    %cl,(%eax)
  80233a:	75 06                	jne    802342 <memfind+0x1d>
  80233c:	eb 0b                	jmp    802349 <memfind+0x24>
  80233e:	38 08                	cmp    %cl,(%eax)
  802340:	74 07                	je     802349 <memfind+0x24>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  802342:	83 c0 01             	add    $0x1,%eax
  802345:	39 c2                	cmp    %eax,%edx
  802347:	77 f5                	ja     80233e <memfind+0x19>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
	return (void *) s;
}
  802349:	5d                   	pop    %ebp
  80234a:	c3                   	ret    

0080234b <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  80234b:	55                   	push   %ebp
  80234c:	89 e5                	mov    %esp,%ebp
  80234e:	57                   	push   %edi
  80234f:	56                   	push   %esi
  802350:	53                   	push   %ebx
  802351:	83 ec 04             	sub    $0x4,%esp
  802354:	8b 55 08             	mov    0x8(%ebp),%edx
  802357:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  80235a:	0f b6 02             	movzbl (%edx),%eax
  80235d:	3c 20                	cmp    $0x20,%al
  80235f:	74 04                	je     802365 <strtol+0x1a>
  802361:	3c 09                	cmp    $0x9,%al
  802363:	75 0e                	jne    802373 <strtol+0x28>
		s++;
  802365:	83 c2 01             	add    $0x1,%edx
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  802368:	0f b6 02             	movzbl (%edx),%eax
  80236b:	3c 20                	cmp    $0x20,%al
  80236d:	74 f6                	je     802365 <strtol+0x1a>
  80236f:	3c 09                	cmp    $0x9,%al
  802371:	74 f2                	je     802365 <strtol+0x1a>
		s++;

	// plus/minus sign
	if (*s == '+')
  802373:	3c 2b                	cmp    $0x2b,%al
  802375:	75 0c                	jne    802383 <strtol+0x38>
		s++;
  802377:	83 c2 01             	add    $0x1,%edx
  80237a:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  802381:	eb 15                	jmp    802398 <strtol+0x4d>
	else if (*s == '-')
  802383:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  80238a:	3c 2d                	cmp    $0x2d,%al
  80238c:	75 0a                	jne    802398 <strtol+0x4d>
		s++, neg = 1;
  80238e:	83 c2 01             	add    $0x1,%edx
  802391:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  802398:	85 db                	test   %ebx,%ebx
  80239a:	0f 94 c0             	sete   %al
  80239d:	74 05                	je     8023a4 <strtol+0x59>
  80239f:	83 fb 10             	cmp    $0x10,%ebx
  8023a2:	75 18                	jne    8023bc <strtol+0x71>
  8023a4:	80 3a 30             	cmpb   $0x30,(%edx)
  8023a7:	75 13                	jne    8023bc <strtol+0x71>
  8023a9:	80 7a 01 78          	cmpb   $0x78,0x1(%edx)
  8023ad:	8d 76 00             	lea    0x0(%esi),%esi
  8023b0:	75 0a                	jne    8023bc <strtol+0x71>
		s += 2, base = 16;
  8023b2:	83 c2 02             	add    $0x2,%edx
  8023b5:	bb 10 00 00 00       	mov    $0x10,%ebx
		s++;
	else if (*s == '-')
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  8023ba:	eb 15                	jmp    8023d1 <strtol+0x86>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  8023bc:	84 c0                	test   %al,%al
  8023be:	66 90                	xchg   %ax,%ax
  8023c0:	74 0f                	je     8023d1 <strtol+0x86>
  8023c2:	bb 0a 00 00 00       	mov    $0xa,%ebx
  8023c7:	80 3a 30             	cmpb   $0x30,(%edx)
  8023ca:	75 05                	jne    8023d1 <strtol+0x86>
		s++, base = 8;
  8023cc:	83 c2 01             	add    $0x1,%edx
  8023cf:	b3 08                	mov    $0x8,%bl
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  8023d1:	b8 00 00 00 00       	mov    $0x0,%eax
  8023d6:	89 de                	mov    %ebx,%esi

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  8023d8:	0f b6 0a             	movzbl (%edx),%ecx
  8023db:	89 cf                	mov    %ecx,%edi
  8023dd:	8d 59 d0             	lea    -0x30(%ecx),%ebx
  8023e0:	80 fb 09             	cmp    $0x9,%bl
  8023e3:	77 08                	ja     8023ed <strtol+0xa2>
			dig = *s - '0';
  8023e5:	0f be c9             	movsbl %cl,%ecx
  8023e8:	83 e9 30             	sub    $0x30,%ecx
  8023eb:	eb 1e                	jmp    80240b <strtol+0xc0>
		else if (*s >= 'a' && *s <= 'z')
  8023ed:	8d 5f 9f             	lea    -0x61(%edi),%ebx
  8023f0:	80 fb 19             	cmp    $0x19,%bl
  8023f3:	77 08                	ja     8023fd <strtol+0xb2>
			dig = *s - 'a' + 10;
  8023f5:	0f be c9             	movsbl %cl,%ecx
  8023f8:	83 e9 57             	sub    $0x57,%ecx
  8023fb:	eb 0e                	jmp    80240b <strtol+0xc0>
		else if (*s >= 'A' && *s <= 'Z')
  8023fd:	8d 5f bf             	lea    -0x41(%edi),%ebx
  802400:	80 fb 19             	cmp    $0x19,%bl
  802403:	77 15                	ja     80241a <strtol+0xcf>
			dig = *s - 'A' + 10;
  802405:	0f be c9             	movsbl %cl,%ecx
  802408:	83 e9 37             	sub    $0x37,%ecx
		else
			break;
		if (dig >= base)
  80240b:	39 f1                	cmp    %esi,%ecx
  80240d:	7d 0b                	jge    80241a <strtol+0xcf>
			break;
		s++, val = (val * base) + dig;
  80240f:	83 c2 01             	add    $0x1,%edx
  802412:	0f af c6             	imul   %esi,%eax
  802415:	8d 04 01             	lea    (%ecx,%eax,1),%eax
		// we don't properly detect overflow!
	}
  802418:	eb be                	jmp    8023d8 <strtol+0x8d>
  80241a:	89 c1                	mov    %eax,%ecx

	if (endptr)
  80241c:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802420:	74 05                	je     802427 <strtol+0xdc>
		*endptr = (char *) s;
  802422:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  802425:	89 13                	mov    %edx,(%ebx)
	return (neg ? -val : val);
  802427:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80242b:	74 04                	je     802431 <strtol+0xe6>
  80242d:	89 c8                	mov    %ecx,%eax
  80242f:	f7 d8                	neg    %eax
}
  802431:	83 c4 04             	add    $0x4,%esp
  802434:	5b                   	pop    %ebx
  802435:	5e                   	pop    %esi
  802436:	5f                   	pop    %edi
  802437:	5d                   	pop    %ebp
  802438:	c3                   	ret    
  802439:	00 00                	add    %al,(%eax)
  80243b:	00 00                	add    %al,(%eax)
  80243d:	00 00                	add    %al,(%eax)
	...

00802440 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  802440:	55                   	push   %ebp
  802441:	89 e5                	mov    %esp,%ebp
  802443:	57                   	push   %edi
  802444:	56                   	push   %esi
  802445:	53                   	push   %ebx
  802446:	83 ec 1c             	sub    $0x1c,%esp
  802449:	8b 7d 0c             	mov    0xc(%ebp),%edi
  80244c:	8b 5d 10             	mov    0x10(%ebp),%ebx
  80244f:	8b 75 14             	mov    0x14(%ebp),%esi
	// LAB 4: Your code here.
	int r;
	if (pg == NULL)
  802452:	85 db                	test   %ebx,%ebx
  802454:	75 2d                	jne    802483 <ipc_send+0x43>
  802456:	bb 00 00 c0 ee       	mov    $0xeec00000,%ebx
  80245b:	eb 26                	jmp    802483 <ipc_send+0x43>
		pg = (void*)UTOP;
	while ((r = sys_ipc_try_send(to_env, val, pg, perm)) < 0)
	{
		if(r != -E_IPC_NOT_RECV)
  80245d:	83 f8 f9             	cmp    $0xfffffff9,%eax
  802460:	74 1c                	je     80247e <ipc_send+0x3e>
			panic("Panic in lib ipc.c : ipc_send() \n");
  802462:	c7 44 24 08 60 2c 80 	movl   $0x802c60,0x8(%esp)
  802469:	00 
  80246a:	c7 44 24 04 44 00 00 	movl   $0x44,0x4(%esp)
  802471:	00 
  802472:	c7 04 24 84 2c 80 00 	movl   $0x802c84,(%esp)
  802479:	e8 7e f4 ff ff       	call   8018fc <_panic>
		sys_yield();
  80247e:	e8 b3 e0 ff ff       	call   800536 <sys_yield>
{
	// LAB 4: Your code here.
	int r;
	if (pg == NULL)
		pg = (void*)UTOP;
	while ((r = sys_ipc_try_send(to_env, val, pg, perm)) < 0)
  802483:	89 74 24 0c          	mov    %esi,0xc(%esp)
  802487:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80248b:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80248f:	8b 45 08             	mov    0x8(%ebp),%eax
  802492:	89 04 24             	mov    %eax,(%esp)
  802495:	e8 2f de ff ff       	call   8002c9 <sys_ipc_try_send>
  80249a:	85 c0                	test   %eax,%eax
  80249c:	78 bf                	js     80245d <ipc_send+0x1d>
		if(r != -E_IPC_NOT_RECV)
			panic("Panic in lib ipc.c : ipc_send() \n");
		sys_yield();
	}
	//panic("ipc_send not implemented");
}
  80249e:	83 c4 1c             	add    $0x1c,%esp
  8024a1:	5b                   	pop    %ebx
  8024a2:	5e                   	pop    %esi
  8024a3:	5f                   	pop    %edi
  8024a4:	5d                   	pop    %ebp
  8024a5:	c3                   	ret    

008024a6 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  8024a6:	55                   	push   %ebp
  8024a7:	89 e5                	mov    %esp,%ebp
  8024a9:	56                   	push   %esi
  8024aa:	53                   	push   %ebx
  8024ab:	83 ec 10             	sub    $0x10,%esp
  8024ae:	8b 5d 08             	mov    0x8(%ebp),%ebx
  8024b1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8024b4:	8b 75 10             	mov    0x10(%ebp),%esi
	// LAB 4: Your code here.
	int r;

	if (pg == NULL)
  8024b7:	85 c0                	test   %eax,%eax
  8024b9:	75 05                	jne    8024c0 <ipc_recv+0x1a>
  8024bb:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
		pg = (void*)UTOP;
	if ((r = sys_ipc_recv(pg)) < 0)
  8024c0:	89 04 24             	mov    %eax,(%esp)
  8024c3:	e8 a4 dd ff ff       	call   80026c <sys_ipc_recv>
  8024c8:	85 c0                	test   %eax,%eax
  8024ca:	79 16                	jns    8024e2 <ipc_recv+0x3c>
	{
		if (from_env_store != NULL)
  8024cc:	85 db                	test   %ebx,%ebx
  8024ce:	74 06                	je     8024d6 <ipc_recv+0x30>
			*from_env_store = 0;
  8024d0:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
		if(perm_store != NULL)
  8024d6:	85 f6                	test   %esi,%esi
  8024d8:	74 2c                	je     802506 <ipc_recv+0x60>
			*perm_store = 0;
  8024da:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
  8024e0:	eb 24                	jmp    802506 <ipc_recv+0x60>
		return r;
	}
	else
	{	
		if (from_env_store != NULL)
  8024e2:	85 db                	test   %ebx,%ebx
  8024e4:	74 0a                	je     8024f0 <ipc_recv+0x4a>
			*from_env_store = env->env_ipc_from;
  8024e6:	a1 74 60 80 00       	mov    0x806074,%eax
  8024eb:	8b 40 74             	mov    0x74(%eax),%eax
  8024ee:	89 03                	mov    %eax,(%ebx)
		if(perm_store != NULL)
  8024f0:	85 f6                	test   %esi,%esi
  8024f2:	74 0a                	je     8024fe <ipc_recv+0x58>
			*perm_store = env->env_ipc_perm;
  8024f4:	a1 74 60 80 00       	mov    0x806074,%eax
  8024f9:	8b 40 78             	mov    0x78(%eax),%eax
  8024fc:	89 06                	mov    %eax,(%esi)
		return env->env_ipc_value;
  8024fe:	a1 74 60 80 00       	mov    0x806074,%eax
  802503:	8b 40 70             	mov    0x70(%eax),%eax
	}		
	//panic("ipc_recv not implemented");
	//return 0;
}
  802506:	83 c4 10             	add    $0x10,%esp
  802509:	5b                   	pop    %ebx
  80250a:	5e                   	pop    %esi
  80250b:	5d                   	pop    %ebp
  80250c:	c3                   	ret    
  80250d:	00 00                	add    %al,(%eax)
	...

00802510 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  802510:	55                   	push   %ebp
  802511:	89 e5                	mov    %esp,%ebp
	pte_t pte;

	if (!(vpd[PDX(v)] & PTE_P))
  802513:	8b 45 08             	mov    0x8(%ebp),%eax
  802516:	89 c2                	mov    %eax,%edx
  802518:	c1 ea 16             	shr    $0x16,%edx
  80251b:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  802522:	f6 c2 01             	test   $0x1,%dl
  802525:	74 26                	je     80254d <pageref+0x3d>
		return 0;
	pte = vpt[VPN(v)];
  802527:	c1 e8 0c             	shr    $0xc,%eax
  80252a:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
	if (!(pte & PTE_P))
  802531:	a8 01                	test   $0x1,%al
  802533:	74 18                	je     80254d <pageref+0x3d>
		return 0;
	return pages[PPN(pte)].pp_ref;
  802535:	c1 e8 0c             	shr    $0xc,%eax
  802538:	8d 14 40             	lea    (%eax,%eax,2),%edx
  80253b:	c1 e2 02             	shl    $0x2,%edx
  80253e:	b8 00 00 00 ef       	mov    $0xef000000,%eax
  802543:	0f b7 44 02 08       	movzwl 0x8(%edx,%eax,1),%eax
  802548:	0f b7 c0             	movzwl %ax,%eax
  80254b:	eb 05                	jmp    802552 <pageref+0x42>
  80254d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802552:	5d                   	pop    %ebp
  802553:	c3                   	ret    
	...

00802560 <__udivdi3>:
  802560:	55                   	push   %ebp
  802561:	89 e5                	mov    %esp,%ebp
  802563:	57                   	push   %edi
  802564:	56                   	push   %esi
  802565:	83 ec 10             	sub    $0x10,%esp
  802568:	8b 45 14             	mov    0x14(%ebp),%eax
  80256b:	8b 55 08             	mov    0x8(%ebp),%edx
  80256e:	8b 75 10             	mov    0x10(%ebp),%esi
  802571:	8b 7d 0c             	mov    0xc(%ebp),%edi
  802574:	85 c0                	test   %eax,%eax
  802576:	89 55 f0             	mov    %edx,-0x10(%ebp)
  802579:	75 35                	jne    8025b0 <__udivdi3+0x50>
  80257b:	39 fe                	cmp    %edi,%esi
  80257d:	77 61                	ja     8025e0 <__udivdi3+0x80>
  80257f:	85 f6                	test   %esi,%esi
  802581:	75 0b                	jne    80258e <__udivdi3+0x2e>
  802583:	b8 01 00 00 00       	mov    $0x1,%eax
  802588:	31 d2                	xor    %edx,%edx
  80258a:	f7 f6                	div    %esi
  80258c:	89 c6                	mov    %eax,%esi
  80258e:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  802591:	31 d2                	xor    %edx,%edx
  802593:	89 f8                	mov    %edi,%eax
  802595:	f7 f6                	div    %esi
  802597:	89 c7                	mov    %eax,%edi
  802599:	89 c8                	mov    %ecx,%eax
  80259b:	f7 f6                	div    %esi
  80259d:	89 c1                	mov    %eax,%ecx
  80259f:	89 fa                	mov    %edi,%edx
  8025a1:	89 c8                	mov    %ecx,%eax
  8025a3:	83 c4 10             	add    $0x10,%esp
  8025a6:	5e                   	pop    %esi
  8025a7:	5f                   	pop    %edi
  8025a8:	5d                   	pop    %ebp
  8025a9:	c3                   	ret    
  8025aa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  8025b0:	39 f8                	cmp    %edi,%eax
  8025b2:	77 1c                	ja     8025d0 <__udivdi3+0x70>
  8025b4:	0f bd d0             	bsr    %eax,%edx
  8025b7:	83 f2 1f             	xor    $0x1f,%edx
  8025ba:	89 55 f4             	mov    %edx,-0xc(%ebp)
  8025bd:	75 39                	jne    8025f8 <__udivdi3+0x98>
  8025bf:	3b 75 f0             	cmp    -0x10(%ebp),%esi
  8025c2:	0f 86 a0 00 00 00    	jbe    802668 <__udivdi3+0x108>
  8025c8:	39 f8                	cmp    %edi,%eax
  8025ca:	0f 82 98 00 00 00    	jb     802668 <__udivdi3+0x108>
  8025d0:	31 ff                	xor    %edi,%edi
  8025d2:	31 c9                	xor    %ecx,%ecx
  8025d4:	89 c8                	mov    %ecx,%eax
  8025d6:	89 fa                	mov    %edi,%edx
  8025d8:	83 c4 10             	add    $0x10,%esp
  8025db:	5e                   	pop    %esi
  8025dc:	5f                   	pop    %edi
  8025dd:	5d                   	pop    %ebp
  8025de:	c3                   	ret    
  8025df:	90                   	nop
  8025e0:	89 d1                	mov    %edx,%ecx
  8025e2:	89 fa                	mov    %edi,%edx
  8025e4:	89 c8                	mov    %ecx,%eax
  8025e6:	31 ff                	xor    %edi,%edi
  8025e8:	f7 f6                	div    %esi
  8025ea:	89 c1                	mov    %eax,%ecx
  8025ec:	89 fa                	mov    %edi,%edx
  8025ee:	89 c8                	mov    %ecx,%eax
  8025f0:	83 c4 10             	add    $0x10,%esp
  8025f3:	5e                   	pop    %esi
  8025f4:	5f                   	pop    %edi
  8025f5:	5d                   	pop    %ebp
  8025f6:	c3                   	ret    
  8025f7:	90                   	nop
  8025f8:	0f b6 4d f4          	movzbl -0xc(%ebp),%ecx
  8025fc:	89 f2                	mov    %esi,%edx
  8025fe:	d3 e0                	shl    %cl,%eax
  802600:	89 45 ec             	mov    %eax,-0x14(%ebp)
  802603:	b8 20 00 00 00       	mov    $0x20,%eax
  802608:	2b 45 f4             	sub    -0xc(%ebp),%eax
  80260b:	89 c1                	mov    %eax,%ecx
  80260d:	d3 ea                	shr    %cl,%edx
  80260f:	0f b6 4d f4          	movzbl -0xc(%ebp),%ecx
  802613:	0b 55 ec             	or     -0x14(%ebp),%edx
  802616:	d3 e6                	shl    %cl,%esi
  802618:	89 c1                	mov    %eax,%ecx
  80261a:	89 75 e8             	mov    %esi,-0x18(%ebp)
  80261d:	89 fe                	mov    %edi,%esi
  80261f:	d3 ee                	shr    %cl,%esi
  802621:	0f b6 4d f4          	movzbl -0xc(%ebp),%ecx
  802625:	89 55 ec             	mov    %edx,-0x14(%ebp)
  802628:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80262b:	d3 e7                	shl    %cl,%edi
  80262d:	89 c1                	mov    %eax,%ecx
  80262f:	d3 ea                	shr    %cl,%edx
  802631:	09 d7                	or     %edx,%edi
  802633:	89 f2                	mov    %esi,%edx
  802635:	89 f8                	mov    %edi,%eax
  802637:	f7 75 ec             	divl   -0x14(%ebp)
  80263a:	89 d6                	mov    %edx,%esi
  80263c:	89 c7                	mov    %eax,%edi
  80263e:	f7 65 e8             	mull   -0x18(%ebp)
  802641:	39 d6                	cmp    %edx,%esi
  802643:	89 55 ec             	mov    %edx,-0x14(%ebp)
  802646:	72 30                	jb     802678 <__udivdi3+0x118>
  802648:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80264b:	0f b6 4d f4          	movzbl -0xc(%ebp),%ecx
  80264f:	d3 e2                	shl    %cl,%edx
  802651:	39 c2                	cmp    %eax,%edx
  802653:	73 05                	jae    80265a <__udivdi3+0xfa>
  802655:	3b 75 ec             	cmp    -0x14(%ebp),%esi
  802658:	74 1e                	je     802678 <__udivdi3+0x118>
  80265a:	89 f9                	mov    %edi,%ecx
  80265c:	31 ff                	xor    %edi,%edi
  80265e:	e9 71 ff ff ff       	jmp    8025d4 <__udivdi3+0x74>
  802663:	90                   	nop
  802664:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802668:	31 ff                	xor    %edi,%edi
  80266a:	b9 01 00 00 00       	mov    $0x1,%ecx
  80266f:	e9 60 ff ff ff       	jmp    8025d4 <__udivdi3+0x74>
  802674:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802678:	8d 4f ff             	lea    -0x1(%edi),%ecx
  80267b:	31 ff                	xor    %edi,%edi
  80267d:	89 c8                	mov    %ecx,%eax
  80267f:	89 fa                	mov    %edi,%edx
  802681:	83 c4 10             	add    $0x10,%esp
  802684:	5e                   	pop    %esi
  802685:	5f                   	pop    %edi
  802686:	5d                   	pop    %ebp
  802687:	c3                   	ret    
	...

00802690 <__umoddi3>:
  802690:	55                   	push   %ebp
  802691:	89 e5                	mov    %esp,%ebp
  802693:	57                   	push   %edi
  802694:	56                   	push   %esi
  802695:	83 ec 20             	sub    $0x20,%esp
  802698:	8b 55 14             	mov    0x14(%ebp),%edx
  80269b:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80269e:	8b 7d 10             	mov    0x10(%ebp),%edi
  8026a1:	8b 75 0c             	mov    0xc(%ebp),%esi
  8026a4:	85 d2                	test   %edx,%edx
  8026a6:	89 c8                	mov    %ecx,%eax
  8026a8:	89 4d f4             	mov    %ecx,-0xc(%ebp)
  8026ab:	75 13                	jne    8026c0 <__umoddi3+0x30>
  8026ad:	39 f7                	cmp    %esi,%edi
  8026af:	76 3f                	jbe    8026f0 <__umoddi3+0x60>
  8026b1:	89 f2                	mov    %esi,%edx
  8026b3:	f7 f7                	div    %edi
  8026b5:	89 d0                	mov    %edx,%eax
  8026b7:	31 d2                	xor    %edx,%edx
  8026b9:	83 c4 20             	add    $0x20,%esp
  8026bc:	5e                   	pop    %esi
  8026bd:	5f                   	pop    %edi
  8026be:	5d                   	pop    %ebp
  8026bf:	c3                   	ret    
  8026c0:	39 f2                	cmp    %esi,%edx
  8026c2:	77 4c                	ja     802710 <__umoddi3+0x80>
  8026c4:	0f bd ca             	bsr    %edx,%ecx
  8026c7:	83 f1 1f             	xor    $0x1f,%ecx
  8026ca:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  8026cd:	75 51                	jne    802720 <__umoddi3+0x90>
  8026cf:	3b 7d f4             	cmp    -0xc(%ebp),%edi
  8026d2:	0f 87 e0 00 00 00    	ja     8027b8 <__umoddi3+0x128>
  8026d8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026db:	29 f8                	sub    %edi,%eax
  8026dd:	19 d6                	sbb    %edx,%esi
  8026df:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8026e2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026e5:	89 f2                	mov    %esi,%edx
  8026e7:	83 c4 20             	add    $0x20,%esp
  8026ea:	5e                   	pop    %esi
  8026eb:	5f                   	pop    %edi
  8026ec:	5d                   	pop    %ebp
  8026ed:	c3                   	ret    
  8026ee:	66 90                	xchg   %ax,%ax
  8026f0:	85 ff                	test   %edi,%edi
  8026f2:	75 0b                	jne    8026ff <__umoddi3+0x6f>
  8026f4:	b8 01 00 00 00       	mov    $0x1,%eax
  8026f9:	31 d2                	xor    %edx,%edx
  8026fb:	f7 f7                	div    %edi
  8026fd:	89 c7                	mov    %eax,%edi
  8026ff:	89 f0                	mov    %esi,%eax
  802701:	31 d2                	xor    %edx,%edx
  802703:	f7 f7                	div    %edi
  802705:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802708:	f7 f7                	div    %edi
  80270a:	eb a9                	jmp    8026b5 <__umoddi3+0x25>
  80270c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802710:	89 c8                	mov    %ecx,%eax
  802712:	89 f2                	mov    %esi,%edx
  802714:	83 c4 20             	add    $0x20,%esp
  802717:	5e                   	pop    %esi
  802718:	5f                   	pop    %edi
  802719:	5d                   	pop    %ebp
  80271a:	c3                   	ret    
  80271b:	90                   	nop
  80271c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802720:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
  802724:	d3 e2                	shl    %cl,%edx
  802726:	89 55 f4             	mov    %edx,-0xc(%ebp)
  802729:	ba 20 00 00 00       	mov    $0x20,%edx
  80272e:	2b 55 f0             	sub    -0x10(%ebp),%edx
  802731:	89 55 ec             	mov    %edx,-0x14(%ebp)
  802734:	0f b6 4d ec          	movzbl -0x14(%ebp),%ecx
  802738:	89 fa                	mov    %edi,%edx
  80273a:	d3 ea                	shr    %cl,%edx
  80273c:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
  802740:	0b 55 f4             	or     -0xc(%ebp),%edx
  802743:	d3 e7                	shl    %cl,%edi
  802745:	0f b6 4d ec          	movzbl -0x14(%ebp),%ecx
  802749:	89 55 f4             	mov    %edx,-0xc(%ebp)
  80274c:	89 f2                	mov    %esi,%edx
  80274e:	89 7d e8             	mov    %edi,-0x18(%ebp)
  802751:	89 c7                	mov    %eax,%edi
  802753:	d3 ea                	shr    %cl,%edx
  802755:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
  802759:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  80275c:	89 c2                	mov    %eax,%edx
  80275e:	d3 e6                	shl    %cl,%esi
  802760:	0f b6 4d ec          	movzbl -0x14(%ebp),%ecx
  802764:	d3 ea                	shr    %cl,%edx
  802766:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
  80276a:	09 d6                	or     %edx,%esi
  80276c:	89 f0                	mov    %esi,%eax
  80276e:	8b 75 e4             	mov    -0x1c(%ebp),%esi
  802771:	d3 e7                	shl    %cl,%edi
  802773:	89 f2                	mov    %esi,%edx
  802775:	f7 75 f4             	divl   -0xc(%ebp)
  802778:	89 d6                	mov    %edx,%esi
  80277a:	f7 65 e8             	mull   -0x18(%ebp)
  80277d:	39 d6                	cmp    %edx,%esi
  80277f:	72 2b                	jb     8027ac <__umoddi3+0x11c>
  802781:	39 c7                	cmp    %eax,%edi
  802783:	72 23                	jb     8027a8 <__umoddi3+0x118>
  802785:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
  802789:	29 c7                	sub    %eax,%edi
  80278b:	19 d6                	sbb    %edx,%esi
  80278d:	89 f0                	mov    %esi,%eax
  80278f:	89 f2                	mov    %esi,%edx
  802791:	d3 ef                	shr    %cl,%edi
  802793:	0f b6 4d ec          	movzbl -0x14(%ebp),%ecx
  802797:	d3 e0                	shl    %cl,%eax
  802799:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
  80279d:	09 f8                	or     %edi,%eax
  80279f:	d3 ea                	shr    %cl,%edx
  8027a1:	83 c4 20             	add    $0x20,%esp
  8027a4:	5e                   	pop    %esi
  8027a5:	5f                   	pop    %edi
  8027a6:	5d                   	pop    %ebp
  8027a7:	c3                   	ret    
  8027a8:	39 d6                	cmp    %edx,%esi
  8027aa:	75 d9                	jne    802785 <__umoddi3+0xf5>
  8027ac:	2b 45 e8             	sub    -0x18(%ebp),%eax
  8027af:	1b 55 f4             	sbb    -0xc(%ebp),%edx
  8027b2:	eb d1                	jmp    802785 <__umoddi3+0xf5>
  8027b4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  8027b8:	39 f2                	cmp    %esi,%edx
  8027ba:	0f 82 18 ff ff ff    	jb     8026d8 <__umoddi3+0x48>
  8027c0:	e9 1d ff ff ff       	jmp    8026e2 <__umoddi3+0x52>
