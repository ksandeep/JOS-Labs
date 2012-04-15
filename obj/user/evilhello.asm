
obj/user/evilhello:     file format elf32-i386


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
  80002c:	e8 1f 00 00 00       	call   800050 <libmain>
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
  800037:	83 ec 18             	sub    $0x18,%esp
	// try to print the kernel entry point as a string!  mua ha ha!
	sys_cputs((char*)0xf010000c, 100);
  80003a:	c7 44 24 04 64 00 00 	movl   $0x64,0x4(%esp)
  800041:	00 
  800042:	c7 04 24 0c 00 10 f0 	movl   $0xf010000c,(%esp)
  800049:	e8 a2 00 00 00       	call   8000f0 <sys_cputs>
}
  80004e:	c9                   	leave  
  80004f:	c3                   	ret    

00800050 <libmain>:
volatile struct Env *env;
char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  800050:	55                   	push   %ebp
  800051:	89 e5                	mov    %esp,%ebp
  800053:	83 ec 18             	sub    $0x18,%esp
  800056:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  800059:	89 75 fc             	mov    %esi,-0x4(%ebp)
  80005c:	8b 75 08             	mov    0x8(%ebp),%esi
  80005f:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	// set env to point at our env structure in envs[].
	// LAB 3b: Your code here.
	// Code added by Swastika / Sandeep	
	envid_t envid = sys_getenvid();
  800062:	e8 17 05 00 00       	call   80057e <sys_getenvid>
	env = &envs[ENVX(envid)];
  800067:	25 ff 03 00 00       	and    $0x3ff,%eax
  80006c:	6b c0 7c             	imul   $0x7c,%eax,%eax
  80006f:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800074:	a3 74 60 80 00       	mov    %eax,0x806074

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800079:	85 f6                	test   %esi,%esi
  80007b:	7e 07                	jle    800084 <libmain+0x34>
		binaryname = argv[0];
  80007d:	8b 03                	mov    (%ebx),%eax
  80007f:	a3 00 60 80 00       	mov    %eax,0x806000

	// call user main routine
	umain(argc, argv);
  800084:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  800088:	89 34 24             	mov    %esi,(%esp)
  80008b:	e8 a4 ff ff ff       	call   800034 <umain>

	// exit gracefully
	exit();
  800090:	e8 0b 00 00 00       	call   8000a0 <exit>
}
  800095:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  800098:	8b 75 fc             	mov    -0x4(%ebp),%esi
  80009b:	89 ec                	mov    %ebp,%esp
  80009d:	5d                   	pop    %ebp
  80009e:	c3                   	ret    
	...

008000a0 <exit>:
#include <inc/lib.h>

void
exit(void)
{
  8000a0:	55                   	push   %ebp
  8000a1:	89 e5                	mov    %esp,%ebp
  8000a3:	83 ec 18             	sub    $0x18,%esp
	close_all();
  8000a6:	e8 40 0a 00 00       	call   800aeb <close_all>
	sys_env_destroy(0);
  8000ab:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8000b2:	e8 fb 04 00 00       	call   8005b2 <sys_env_destroy>
}
  8000b7:	c9                   	leave  
  8000b8:	c3                   	ret    
  8000b9:	00 00                	add    %al,(%eax)
	...

008000bc <sys_cgetc>:
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}

int
sys_cgetc(void)
{
  8000bc:	55                   	push   %ebp
  8000bd:	89 e5                	mov    %esp,%ebp
  8000bf:	83 ec 0c             	sub    $0xc,%esp
  8000c2:	89 1c 24             	mov    %ebx,(%esp)
  8000c5:	89 74 24 04          	mov    %esi,0x4(%esp)
  8000c9:	89 7c 24 08          	mov    %edi,0x8(%esp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8000cd:	ba 00 00 00 00       	mov    $0x0,%edx
  8000d2:	b8 01 00 00 00       	mov    $0x1,%eax
  8000d7:	89 d1                	mov    %edx,%ecx
  8000d9:	89 d3                	mov    %edx,%ebx
  8000db:	89 d7                	mov    %edx,%edi
  8000dd:	89 d6                	mov    %edx,%esi
  8000df:	cd 30                	int    $0x30

int
sys_cgetc(void)
{
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  8000e1:	8b 1c 24             	mov    (%esp),%ebx
  8000e4:	8b 74 24 04          	mov    0x4(%esp),%esi
  8000e8:	8b 7c 24 08          	mov    0x8(%esp),%edi
  8000ec:	89 ec                	mov    %ebp,%esp
  8000ee:	5d                   	pop    %ebp
  8000ef:	c3                   	ret    

008000f0 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  8000f0:	55                   	push   %ebp
  8000f1:	89 e5                	mov    %esp,%ebp
  8000f3:	83 ec 0c             	sub    $0xc,%esp
  8000f6:	89 1c 24             	mov    %ebx,(%esp)
  8000f9:	89 74 24 04          	mov    %esi,0x4(%esp)
  8000fd:	89 7c 24 08          	mov    %edi,0x8(%esp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800101:	b8 00 00 00 00       	mov    $0x0,%eax
  800106:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800109:	8b 55 08             	mov    0x8(%ebp),%edx
  80010c:	89 c3                	mov    %eax,%ebx
  80010e:	89 c7                	mov    %eax,%edi
  800110:	89 c6                	mov    %eax,%esi
  800112:	cd 30                	int    $0x30

void
sys_cputs(const char *s, size_t len)
{
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800114:	8b 1c 24             	mov    (%esp),%ebx
  800117:	8b 74 24 04          	mov    0x4(%esp),%esi
  80011b:	8b 7c 24 08          	mov    0x8(%esp),%edi
  80011f:	89 ec                	mov    %ebp,%esp
  800121:	5d                   	pop    %ebp
  800122:	c3                   	ret    

00800123 <sys_page_insert>:
{
	return syscall(SYS_page_waste, 0, (uint32_t)p, (uint32_t)n, 0, 0,0);
}
int
sys_page_insert(envid_t envid, void *va, struct Page *p, int perm)
{
  800123:	55                   	push   %ebp
  800124:	89 e5                	mov    %esp,%ebp
  800126:	83 ec 38             	sub    $0x38,%esp
  800129:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  80012c:	89 75 f8             	mov    %esi,-0x8(%ebp)
  80012f:	89 7d fc             	mov    %edi,-0x4(%ebp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800132:	be 00 00 00 00       	mov    $0x0,%esi
  800137:	b8 12 00 00 00       	mov    $0x12,%eax
  80013c:	8b 7d 14             	mov    0x14(%ebp),%edi
  80013f:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800142:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800145:	8b 55 08             	mov    0x8(%ebp),%edx
  800148:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
	
	if(check && ret > 0)
  80014a:	85 c0                	test   %eax,%eax
  80014c:	7e 28                	jle    800176 <sys_page_insert+0x53>
		panic("syscall %d returned %d (> 0)", num, ret);
  80014e:	89 44 24 10          	mov    %eax,0x10(%esp)
  800152:	c7 44 24 0c 12 00 00 	movl   $0x12,0xc(%esp)
  800159:	00 
  80015a:	c7 44 24 08 f7 27 80 	movl   $0x8027f7,0x8(%esp)
  800161:	00 
  800162:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800169:	00 
  80016a:	c7 04 24 14 28 80 00 	movl   $0x802814,(%esp)
  800171:	e8 96 17 00 00       	call   80190c <_panic>
}
int
sys_page_insert(envid_t envid, void *va, struct Page *p, int perm)
{
	return syscall(SYS_page_insert, 1, envid, (uint32_t) va, (uint32_t)p, perm, 0);
}
  800176:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800179:	8b 75 f8             	mov    -0x8(%ebp),%esi
  80017c:	8b 7d fc             	mov    -0x4(%ebp),%edi
  80017f:	89 ec                	mov    %ebp,%esp
  800181:	5d                   	pop    %ebp
  800182:	c3                   	ret    

00800183 <sys_page_waste>:
{
	return (int)syscall(SYS_receive_packet, 0, (uint32_t)buffer, 0,0,0,0);
}

int sys_page_waste(struct Page **p, int n)
{
  800183:	55                   	push   %ebp
  800184:	89 e5                	mov    %esp,%ebp
  800186:	83 ec 0c             	sub    $0xc,%esp
  800189:	89 1c 24             	mov    %ebx,(%esp)
  80018c:	89 74 24 04          	mov    %esi,0x4(%esp)
  800190:	89 7c 24 08          	mov    %edi,0x8(%esp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800194:	bb 00 00 00 00       	mov    $0x0,%ebx
  800199:	b8 11 00 00 00       	mov    $0x11,%eax
  80019e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8001a1:	8b 55 08             	mov    0x8(%ebp),%edx
  8001a4:	89 df                	mov    %ebx,%edi
  8001a6:	89 de                	mov    %ebx,%esi
  8001a8:	cd 30                	int    $0x30
}

int sys_page_waste(struct Page **p, int n)
{
	return syscall(SYS_page_waste, 0, (uint32_t)p, (uint32_t)n, 0, 0,0);
}
  8001aa:	8b 1c 24             	mov    (%esp),%ebx
  8001ad:	8b 74 24 04          	mov    0x4(%esp),%esi
  8001b1:	8b 7c 24 08          	mov    0x8(%esp),%edi
  8001b5:	89 ec                	mov    %ebp,%esp
  8001b7:	5d                   	pop    %ebp
  8001b8:	c3                   	ret    

008001b9 <sys_receive_packet>:
{
	return (int)syscall(SYS_transmit_packet, 1, (uint32_t)data, len, 0,0,0);
}

int sys_receive_packet(void* buffer)
{
  8001b9:	55                   	push   %ebp
  8001ba:	89 e5                	mov    %esp,%ebp
  8001bc:	83 ec 0c             	sub    $0xc,%esp
  8001bf:	89 1c 24             	mov    %ebx,(%esp)
  8001c2:	89 74 24 04          	mov    %esi,0x4(%esp)
  8001c6:	89 7c 24 08          	mov    %edi,0x8(%esp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8001ca:	b9 00 00 00 00       	mov    $0x0,%ecx
  8001cf:	b8 10 00 00 00       	mov    $0x10,%eax
  8001d4:	8b 55 08             	mov    0x8(%ebp),%edx
  8001d7:	89 cb                	mov    %ecx,%ebx
  8001d9:	89 cf                	mov    %ecx,%edi
  8001db:	89 ce                	mov    %ecx,%esi
  8001dd:	cd 30                	int    $0x30
}

int sys_receive_packet(void* buffer)
{
	return (int)syscall(SYS_receive_packet, 0, (uint32_t)buffer, 0,0,0,0);
}
  8001df:	8b 1c 24             	mov    (%esp),%ebx
  8001e2:	8b 74 24 04          	mov    0x4(%esp),%esi
  8001e6:	8b 7c 24 08          	mov    0x8(%esp),%edi
  8001ea:	89 ec                	mov    %ebp,%esp
  8001ec:	5d                   	pop    %ebp
  8001ed:	c3                   	ret    

008001ee <sys_transmit_packet>:
{
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0,0);
}

int sys_transmit_packet(void* data, uint32_t len)
{
  8001ee:	55                   	push   %ebp
  8001ef:	89 e5                	mov    %esp,%ebp
  8001f1:	83 ec 38             	sub    $0x38,%esp
  8001f4:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  8001f7:	89 75 f8             	mov    %esi,-0x8(%ebp)
  8001fa:	89 7d fc             	mov    %edi,-0x4(%ebp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8001fd:	bb 00 00 00 00       	mov    $0x0,%ebx
  800202:	b8 0f 00 00 00       	mov    $0xf,%eax
  800207:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80020a:	8b 55 08             	mov    0x8(%ebp),%edx
  80020d:	89 df                	mov    %ebx,%edi
  80020f:	89 de                	mov    %ebx,%esi
  800211:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
	
	if(check && ret > 0)
  800213:	85 c0                	test   %eax,%eax
  800215:	7e 28                	jle    80023f <sys_transmit_packet+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  800217:	89 44 24 10          	mov    %eax,0x10(%esp)
  80021b:	c7 44 24 0c 0f 00 00 	movl   $0xf,0xc(%esp)
  800222:	00 
  800223:	c7 44 24 08 f7 27 80 	movl   $0x8027f7,0x8(%esp)
  80022a:	00 
  80022b:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800232:	00 
  800233:	c7 04 24 14 28 80 00 	movl   $0x802814,(%esp)
  80023a:	e8 cd 16 00 00       	call   80190c <_panic>
}

int sys_transmit_packet(void* data, uint32_t len)
{
	return (int)syscall(SYS_transmit_packet, 1, (uint32_t)data, len, 0,0,0);
}
  80023f:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800242:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800245:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800248:	89 ec                	mov    %ebp,%esp
  80024a:	5d                   	pop    %ebp
  80024b:	c3                   	ret    

0080024c <sys_time_msec>:
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}

unsigned int
sys_time_msec(void)
{
  80024c:	55                   	push   %ebp
  80024d:	89 e5                	mov    %esp,%ebp
  80024f:	83 ec 0c             	sub    $0xc,%esp
  800252:	89 1c 24             	mov    %ebx,(%esp)
  800255:	89 74 24 04          	mov    %esi,0x4(%esp)
  800259:	89 7c 24 08          	mov    %edi,0x8(%esp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80025d:	ba 00 00 00 00       	mov    $0x0,%edx
  800262:	b8 0e 00 00 00       	mov    $0xe,%eax
  800267:	89 d1                	mov    %edx,%ecx
  800269:	89 d3                	mov    %edx,%ebx
  80026b:	89 d7                	mov    %edx,%edi
  80026d:	89 d6                	mov    %edx,%esi
  80026f:	cd 30                	int    $0x30

unsigned int
sys_time_msec(void)
{
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0,0);
}
  800271:	8b 1c 24             	mov    (%esp),%ebx
  800274:	8b 74 24 04          	mov    0x4(%esp),%esi
  800278:	8b 7c 24 08          	mov    0x8(%esp),%edi
  80027c:	89 ec                	mov    %ebp,%esp
  80027e:	5d                   	pop    %ebp
  80027f:	c3                   	ret    

00800280 <sys_ipc_recv>:
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}

int
sys_ipc_recv(void *dstva)
{
  800280:	55                   	push   %ebp
  800281:	89 e5                	mov    %esp,%ebp
  800283:	83 ec 38             	sub    $0x38,%esp
  800286:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800289:	89 75 f8             	mov    %esi,-0x8(%ebp)
  80028c:	89 7d fc             	mov    %edi,-0x4(%ebp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80028f:	b9 00 00 00 00       	mov    $0x0,%ecx
  800294:	b8 0d 00 00 00       	mov    $0xd,%eax
  800299:	8b 55 08             	mov    0x8(%ebp),%edx
  80029c:	89 cb                	mov    %ecx,%ebx
  80029e:	89 cf                	mov    %ecx,%edi
  8002a0:	89 ce                	mov    %ecx,%esi
  8002a2:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
	
	if(check && ret > 0)
  8002a4:	85 c0                	test   %eax,%eax
  8002a6:	7e 28                	jle    8002d0 <sys_ipc_recv+0x50>
		panic("syscall %d returned %d (> 0)", num, ret);
  8002a8:	89 44 24 10          	mov    %eax,0x10(%esp)
  8002ac:	c7 44 24 0c 0d 00 00 	movl   $0xd,0xc(%esp)
  8002b3:	00 
  8002b4:	c7 44 24 08 f7 27 80 	movl   $0x8027f7,0x8(%esp)
  8002bb:	00 
  8002bc:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  8002c3:	00 
  8002c4:	c7 04 24 14 28 80 00 	movl   $0x802814,(%esp)
  8002cb:	e8 3c 16 00 00       	call   80190c <_panic>

int
sys_ipc_recv(void *dstva)
{
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  8002d0:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  8002d3:	8b 75 f8             	mov    -0x8(%ebp),%esi
  8002d6:	8b 7d fc             	mov    -0x4(%ebp),%edi
  8002d9:	89 ec                	mov    %ebp,%esp
  8002db:	5d                   	pop    %ebp
  8002dc:	c3                   	ret    

008002dd <sys_ipc_try_send>:
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  8002dd:	55                   	push   %ebp
  8002de:	89 e5                	mov    %esp,%ebp
  8002e0:	83 ec 0c             	sub    $0xc,%esp
  8002e3:	89 1c 24             	mov    %ebx,(%esp)
  8002e6:	89 74 24 04          	mov    %esi,0x4(%esp)
  8002ea:	89 7c 24 08          	mov    %edi,0x8(%esp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8002ee:	be 00 00 00 00       	mov    $0x0,%esi
  8002f3:	b8 0c 00 00 00       	mov    $0xc,%eax
  8002f8:	8b 7d 14             	mov    0x14(%ebp),%edi
  8002fb:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8002fe:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800301:	8b 55 08             	mov    0x8(%ebp),%edx
  800304:	cd 30                	int    $0x30

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  800306:	8b 1c 24             	mov    (%esp),%ebx
  800309:	8b 74 24 04          	mov    0x4(%esp),%esi
  80030d:	8b 7c 24 08          	mov    0x8(%esp),%edi
  800311:	89 ec                	mov    %ebp,%esp
  800313:	5d                   	pop    %ebp
  800314:	c3                   	ret    

00800315 <sys_env_set_pgfault_upcall>:
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800315:	55                   	push   %ebp
  800316:	89 e5                	mov    %esp,%ebp
  800318:	83 ec 38             	sub    $0x38,%esp
  80031b:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  80031e:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800321:	89 7d fc             	mov    %edi,-0x4(%ebp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800324:	bb 00 00 00 00       	mov    $0x0,%ebx
  800329:	b8 0a 00 00 00       	mov    $0xa,%eax
  80032e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800331:	8b 55 08             	mov    0x8(%ebp),%edx
  800334:	89 df                	mov    %ebx,%edi
  800336:	89 de                	mov    %ebx,%esi
  800338:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
	
	if(check && ret > 0)
  80033a:	85 c0                	test   %eax,%eax
  80033c:	7e 28                	jle    800366 <sys_env_set_pgfault_upcall+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  80033e:	89 44 24 10          	mov    %eax,0x10(%esp)
  800342:	c7 44 24 0c 0a 00 00 	movl   $0xa,0xc(%esp)
  800349:	00 
  80034a:	c7 44 24 08 f7 27 80 	movl   $0x8027f7,0x8(%esp)
  800351:	00 
  800352:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800359:	00 
  80035a:	c7 04 24 14 28 80 00 	movl   $0x802814,(%esp)
  800361:	e8 a6 15 00 00       	call   80190c <_panic>

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  800366:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800369:	8b 75 f8             	mov    -0x8(%ebp),%esi
  80036c:	8b 7d fc             	mov    -0x4(%ebp),%edi
  80036f:	89 ec                	mov    %ebp,%esp
  800371:	5d                   	pop    %ebp
  800372:	c3                   	ret    

00800373 <sys_env_set_trapframe>:
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800373:	55                   	push   %ebp
  800374:	89 e5                	mov    %esp,%ebp
  800376:	83 ec 38             	sub    $0x38,%esp
  800379:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  80037c:	89 75 f8             	mov    %esi,-0x8(%ebp)
  80037f:	89 7d fc             	mov    %edi,-0x4(%ebp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800382:	bb 00 00 00 00       	mov    $0x0,%ebx
  800387:	b8 09 00 00 00       	mov    $0x9,%eax
  80038c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80038f:	8b 55 08             	mov    0x8(%ebp),%edx
  800392:	89 df                	mov    %ebx,%edi
  800394:	89 de                	mov    %ebx,%esi
  800396:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
	
	if(check && ret > 0)
  800398:	85 c0                	test   %eax,%eax
  80039a:	7e 28                	jle    8003c4 <sys_env_set_trapframe+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  80039c:	89 44 24 10          	mov    %eax,0x10(%esp)
  8003a0:	c7 44 24 0c 09 00 00 	movl   $0x9,0xc(%esp)
  8003a7:	00 
  8003a8:	c7 44 24 08 f7 27 80 	movl   $0x8027f7,0x8(%esp)
  8003af:	00 
  8003b0:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  8003b7:	00 
  8003b8:	c7 04 24 14 28 80 00 	movl   $0x802814,(%esp)
  8003bf:	e8 48 15 00 00       	call   80190c <_panic>

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  8003c4:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  8003c7:	8b 75 f8             	mov    -0x8(%ebp),%esi
  8003ca:	8b 7d fc             	mov    -0x4(%ebp),%edi
  8003cd:	89 ec                	mov    %ebp,%esp
  8003cf:	5d                   	pop    %ebp
  8003d0:	c3                   	ret    

008003d1 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  8003d1:	55                   	push   %ebp
  8003d2:	89 e5                	mov    %esp,%ebp
  8003d4:	83 ec 38             	sub    $0x38,%esp
  8003d7:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  8003da:	89 75 f8             	mov    %esi,-0x8(%ebp)
  8003dd:	89 7d fc             	mov    %edi,-0x4(%ebp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8003e0:	bb 00 00 00 00       	mov    $0x0,%ebx
  8003e5:	b8 08 00 00 00       	mov    $0x8,%eax
  8003ea:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8003ed:	8b 55 08             	mov    0x8(%ebp),%edx
  8003f0:	89 df                	mov    %ebx,%edi
  8003f2:	89 de                	mov    %ebx,%esi
  8003f4:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
	
	if(check && ret > 0)
  8003f6:	85 c0                	test   %eax,%eax
  8003f8:	7e 28                	jle    800422 <sys_env_set_status+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  8003fa:	89 44 24 10          	mov    %eax,0x10(%esp)
  8003fe:	c7 44 24 0c 08 00 00 	movl   $0x8,0xc(%esp)
  800405:	00 
  800406:	c7 44 24 08 f7 27 80 	movl   $0x8027f7,0x8(%esp)
  80040d:	00 
  80040e:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800415:	00 
  800416:	c7 04 24 14 28 80 00 	movl   $0x802814,(%esp)
  80041d:	e8 ea 14 00 00       	call   80190c <_panic>

int
sys_env_set_status(envid_t envid, int status)
{
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800422:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800425:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800428:	8b 7d fc             	mov    -0x4(%ebp),%edi
  80042b:	89 ec                	mov    %ebp,%esp
  80042d:	5d                   	pop    %ebp
  80042e:	c3                   	ret    

0080042f <sys_page_unmap>:
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}

int
sys_page_unmap(envid_t envid, void *va)
{
  80042f:	55                   	push   %ebp
  800430:	89 e5                	mov    %esp,%ebp
  800432:	83 ec 38             	sub    $0x38,%esp
  800435:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800438:	89 75 f8             	mov    %esi,-0x8(%ebp)
  80043b:	89 7d fc             	mov    %edi,-0x4(%ebp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80043e:	bb 00 00 00 00       	mov    $0x0,%ebx
  800443:	b8 06 00 00 00       	mov    $0x6,%eax
  800448:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80044b:	8b 55 08             	mov    0x8(%ebp),%edx
  80044e:	89 df                	mov    %ebx,%edi
  800450:	89 de                	mov    %ebx,%esi
  800452:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
	
	if(check && ret > 0)
  800454:	85 c0                	test   %eax,%eax
  800456:	7e 28                	jle    800480 <sys_page_unmap+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  800458:	89 44 24 10          	mov    %eax,0x10(%esp)
  80045c:	c7 44 24 0c 06 00 00 	movl   $0x6,0xc(%esp)
  800463:	00 
  800464:	c7 44 24 08 f7 27 80 	movl   $0x8027f7,0x8(%esp)
  80046b:	00 
  80046c:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800473:	00 
  800474:	c7 04 24 14 28 80 00 	movl   $0x802814,(%esp)
  80047b:	e8 8c 14 00 00       	call   80190c <_panic>

int
sys_page_unmap(envid_t envid, void *va)
{
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800480:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800483:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800486:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800489:	89 ec                	mov    %ebp,%esp
  80048b:	5d                   	pop    %ebp
  80048c:	c3                   	ret    

0080048d <sys_page_map>:
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  80048d:	55                   	push   %ebp
  80048e:	89 e5                	mov    %esp,%ebp
  800490:	83 ec 38             	sub    $0x38,%esp
  800493:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800496:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800499:	89 7d fc             	mov    %edi,-0x4(%ebp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80049c:	b8 05 00 00 00       	mov    $0x5,%eax
  8004a1:	8b 75 18             	mov    0x18(%ebp),%esi
  8004a4:	8b 7d 14             	mov    0x14(%ebp),%edi
  8004a7:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8004aa:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8004ad:	8b 55 08             	mov    0x8(%ebp),%edx
  8004b0:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
	
	if(check && ret > 0)
  8004b2:	85 c0                	test   %eax,%eax
  8004b4:	7e 28                	jle    8004de <sys_page_map+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  8004b6:	89 44 24 10          	mov    %eax,0x10(%esp)
  8004ba:	c7 44 24 0c 05 00 00 	movl   $0x5,0xc(%esp)
  8004c1:	00 
  8004c2:	c7 44 24 08 f7 27 80 	movl   $0x8027f7,0x8(%esp)
  8004c9:	00 
  8004ca:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  8004d1:	00 
  8004d2:	c7 04 24 14 28 80 00 	movl   $0x802814,(%esp)
  8004d9:	e8 2e 14 00 00       	call   80190c <_panic>

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  8004de:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  8004e1:	8b 75 f8             	mov    -0x8(%ebp),%esi
  8004e4:	8b 7d fc             	mov    -0x4(%ebp),%edi
  8004e7:	89 ec                	mov    %ebp,%esp
  8004e9:	5d                   	pop    %ebp
  8004ea:	c3                   	ret    

008004eb <sys_page_alloc>:
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  8004eb:	55                   	push   %ebp
  8004ec:	89 e5                	mov    %esp,%ebp
  8004ee:	83 ec 38             	sub    $0x38,%esp
  8004f1:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  8004f4:	89 75 f8             	mov    %esi,-0x8(%ebp)
  8004f7:	89 7d fc             	mov    %edi,-0x4(%ebp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8004fa:	be 00 00 00 00       	mov    $0x0,%esi
  8004ff:	b8 04 00 00 00       	mov    $0x4,%eax
  800504:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800507:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80050a:	8b 55 08             	mov    0x8(%ebp),%edx
  80050d:	89 f7                	mov    %esi,%edi
  80050f:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
	
	if(check && ret > 0)
  800511:	85 c0                	test   %eax,%eax
  800513:	7e 28                	jle    80053d <sys_page_alloc+0x52>
		panic("syscall %d returned %d (> 0)", num, ret);
  800515:	89 44 24 10          	mov    %eax,0x10(%esp)
  800519:	c7 44 24 0c 04 00 00 	movl   $0x4,0xc(%esp)
  800520:	00 
  800521:	c7 44 24 08 f7 27 80 	movl   $0x8027f7,0x8(%esp)
  800528:	00 
  800529:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800530:	00 
  800531:	c7 04 24 14 28 80 00 	movl   $0x802814,(%esp)
  800538:	e8 cf 13 00 00       	call   80190c <_panic>

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  80053d:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800540:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800543:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800546:	89 ec                	mov    %ebp,%esp
  800548:	5d                   	pop    %ebp
  800549:	c3                   	ret    

0080054a <sys_yield>:
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}

void
sys_yield(void)
{
  80054a:	55                   	push   %ebp
  80054b:	89 e5                	mov    %esp,%ebp
  80054d:	83 ec 0c             	sub    $0xc,%esp
  800550:	89 1c 24             	mov    %ebx,(%esp)
  800553:	89 74 24 04          	mov    %esi,0x4(%esp)
  800557:	89 7c 24 08          	mov    %edi,0x8(%esp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80055b:	ba 00 00 00 00       	mov    $0x0,%edx
  800560:	b8 0b 00 00 00       	mov    $0xb,%eax
  800565:	89 d1                	mov    %edx,%ecx
  800567:	89 d3                	mov    %edx,%ebx
  800569:	89 d7                	mov    %edx,%edi
  80056b:	89 d6                	mov    %edx,%esi
  80056d:	cd 30                	int    $0x30

void
sys_yield(void)
{
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  80056f:	8b 1c 24             	mov    (%esp),%ebx
  800572:	8b 74 24 04          	mov    0x4(%esp),%esi
  800576:	8b 7c 24 08          	mov    0x8(%esp),%edi
  80057a:	89 ec                	mov    %ebp,%esp
  80057c:	5d                   	pop    %ebp
  80057d:	c3                   	ret    

0080057e <sys_getenvid>:
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}

envid_t
sys_getenvid(void)
{
  80057e:	55                   	push   %ebp
  80057f:	89 e5                	mov    %esp,%ebp
  800581:	83 ec 0c             	sub    $0xc,%esp
  800584:	89 1c 24             	mov    %ebx,(%esp)
  800587:	89 74 24 04          	mov    %esi,0x4(%esp)
  80058b:	89 7c 24 08          	mov    %edi,0x8(%esp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80058f:	ba 00 00 00 00       	mov    $0x0,%edx
  800594:	b8 02 00 00 00       	mov    $0x2,%eax
  800599:	89 d1                	mov    %edx,%ecx
  80059b:	89 d3                	mov    %edx,%ebx
  80059d:	89 d7                	mov    %edx,%edi
  80059f:	89 d6                	mov    %edx,%esi
  8005a1:	cd 30                	int    $0x30

envid_t
sys_getenvid(void)
{
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  8005a3:	8b 1c 24             	mov    (%esp),%ebx
  8005a6:	8b 74 24 04          	mov    0x4(%esp),%esi
  8005aa:	8b 7c 24 08          	mov    0x8(%esp),%edi
  8005ae:	89 ec                	mov    %ebp,%esp
  8005b0:	5d                   	pop    %ebp
  8005b1:	c3                   	ret    

008005b2 <sys_env_destroy>:
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}

int
sys_env_destroy(envid_t envid)
{
  8005b2:	55                   	push   %ebp
  8005b3:	89 e5                	mov    %esp,%ebp
  8005b5:	83 ec 38             	sub    $0x38,%esp
  8005b8:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  8005bb:	89 75 f8             	mov    %esi,-0x8(%ebp)
  8005be:	89 7d fc             	mov    %edi,-0x4(%ebp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8005c1:	b9 00 00 00 00       	mov    $0x0,%ecx
  8005c6:	b8 03 00 00 00       	mov    $0x3,%eax
  8005cb:	8b 55 08             	mov    0x8(%ebp),%edx
  8005ce:	89 cb                	mov    %ecx,%ebx
  8005d0:	89 cf                	mov    %ecx,%edi
  8005d2:	89 ce                	mov    %ecx,%esi
  8005d4:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
	
	if(check && ret > 0)
  8005d6:	85 c0                	test   %eax,%eax
  8005d8:	7e 28                	jle    800602 <sys_env_destroy+0x50>
		panic("syscall %d returned %d (> 0)", num, ret);
  8005da:	89 44 24 10          	mov    %eax,0x10(%esp)
  8005de:	c7 44 24 0c 03 00 00 	movl   $0x3,0xc(%esp)
  8005e5:	00 
  8005e6:	c7 44 24 08 f7 27 80 	movl   $0x8027f7,0x8(%esp)
  8005ed:	00 
  8005ee:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  8005f5:	00 
  8005f6:	c7 04 24 14 28 80 00 	movl   $0x802814,(%esp)
  8005fd:	e8 0a 13 00 00       	call   80190c <_panic>

int
sys_env_destroy(envid_t envid)
{
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800602:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800605:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800608:	8b 7d fc             	mov    -0x4(%ebp),%edi
  80060b:	89 ec                	mov    %ebp,%esp
  80060d:	5d                   	pop    %ebp
  80060e:	c3                   	ret    
	...

00800610 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  800610:	55                   	push   %ebp
  800611:	89 e5                	mov    %esp,%ebp
  800613:	8b 45 08             	mov    0x8(%ebp),%eax
  800616:	05 00 00 00 30       	add    $0x30000000,%eax
  80061b:	c1 e8 0c             	shr    $0xc,%eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
}
  80061e:	5d                   	pop    %ebp
  80061f:	c3                   	ret    

00800620 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  800620:	55                   	push   %ebp
  800621:	89 e5                	mov    %esp,%ebp
  800623:	83 ec 04             	sub    $0x4,%esp
	return INDEX2DATA(fd2num(fd));
  800626:	8b 45 08             	mov    0x8(%ebp),%eax
  800629:	89 04 24             	mov    %eax,(%esp)
  80062c:	e8 df ff ff ff       	call   800610 <fd2num>
  800631:	05 20 00 0d 00       	add    $0xd0020,%eax
  800636:	c1 e0 0c             	shl    $0xc,%eax
}
  800639:	c9                   	leave  
  80063a:	c3                   	ret    

0080063b <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  80063b:	55                   	push   %ebp
  80063c:	89 e5                	mov    %esp,%ebp
  80063e:	57                   	push   %edi
  80063f:	56                   	push   %esi
  800640:	53                   	push   %ebx
  800641:	8b 7d 08             	mov    0x8(%ebp),%edi
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((vpd[PDX(fd)] & PTE_P) == 0 || (vpt[VPN(fd)] & PTE_P) == 0) {
  800644:	a1 00 dd 7b ef       	mov    0xef7bdd00,%eax
  800649:	a8 01                	test   $0x1,%al
  80064b:	74 36                	je     800683 <fd_alloc+0x48>
  80064d:	a1 00 00 74 ef       	mov    0xef740000,%eax
  800652:	a8 01                	test   $0x1,%al
  800654:	74 2d                	je     800683 <fd_alloc+0x48>
  800656:	b8 00 10 00 d0       	mov    $0xd0001000,%eax
  80065b:	b9 00 d0 7b ef       	mov    $0xef7bd000,%ecx
  800660:	be 00 00 40 ef       	mov    $0xef400000,%esi
  800665:	89 c3                	mov    %eax,%ebx
  800667:	89 c2                	mov    %eax,%edx
  800669:	c1 ea 16             	shr    $0x16,%edx
  80066c:	8b 14 91             	mov    (%ecx,%edx,4),%edx
  80066f:	f6 c2 01             	test   $0x1,%dl
  800672:	74 14                	je     800688 <fd_alloc+0x4d>
  800674:	89 c2                	mov    %eax,%edx
  800676:	c1 ea 0c             	shr    $0xc,%edx
  800679:	8b 14 96             	mov    (%esi,%edx,4),%edx
  80067c:	f6 c2 01             	test   $0x1,%dl
  80067f:	75 10                	jne    800691 <fd_alloc+0x56>
  800681:	eb 05                	jmp    800688 <fd_alloc+0x4d>
  800683:	bb 00 00 00 d0       	mov    $0xd0000000,%ebx
			*fd_store = fd;
  800688:	89 1f                	mov    %ebx,(%edi)
  80068a:	b8 00 00 00 00       	mov    $0x0,%eax
			return 0;
  80068f:	eb 17                	jmp    8006a8 <fd_alloc+0x6d>
  800691:	05 00 10 00 00       	add    $0x1000,%eax
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  800696:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  80069b:	75 c8                	jne    800665 <fd_alloc+0x2a>
		if ((vpd[PDX(fd)] & PTE_P) == 0 || (vpt[VPN(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  80069d:	c7 07 00 00 00 00    	movl   $0x0,(%edi)
  8006a3:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
	return -E_MAX_OPEN;
}
  8006a8:	5b                   	pop    %ebx
  8006a9:	5e                   	pop    %esi
  8006aa:	5f                   	pop    %edi
  8006ab:	5d                   	pop    %ebp
  8006ac:	c3                   	ret    

008006ad <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  8006ad:	55                   	push   %ebp
  8006ae:	89 e5                	mov    %esp,%ebp
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  8006b0:	8b 45 08             	mov    0x8(%ebp),%eax
  8006b3:	83 f8 1f             	cmp    $0x1f,%eax
  8006b6:	77 36                	ja     8006ee <fd_lookup+0x41>
		if (debug)
			cprintf("[%08x] bad fd %d\n", env->env_id, fd);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  8006b8:	05 00 00 0d 00       	add    $0xd0000,%eax
  8006bd:	c1 e0 0c             	shl    $0xc,%eax
	if (!(vpd[PDX(fd)] & PTE_P) || !(vpt[VPN(fd)] & PTE_P)) {
  8006c0:	89 c2                	mov    %eax,%edx
  8006c2:	c1 ea 16             	shr    $0x16,%edx
  8006c5:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  8006cc:	f6 c2 01             	test   $0x1,%dl
  8006cf:	74 1d                	je     8006ee <fd_lookup+0x41>
  8006d1:	89 c2                	mov    %eax,%edx
  8006d3:	c1 ea 0c             	shr    $0xc,%edx
  8006d6:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8006dd:	f6 c2 01             	test   $0x1,%dl
  8006e0:	74 0c                	je     8006ee <fd_lookup+0x41>
		if (debug)
			cprintf("[%08x] closed fd %d\n", env->env_id, fd);
		return -E_INVAL;
	}
	*fd_store = fd;
  8006e2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8006e5:	89 02                	mov    %eax,(%edx)
  8006e7:	b8 00 00 00 00       	mov    $0x0,%eax
	return 0;
  8006ec:	eb 05                	jmp    8006f3 <fd_lookup+0x46>
  8006ee:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  8006f3:	5d                   	pop    %ebp
  8006f4:	c3                   	ret    

008006f5 <seek>:
	return (*dev->dev_write)(fd, buf, n);
}

int
seek(int fdnum, off_t offset)
{
  8006f5:	55                   	push   %ebp
  8006f6:	89 e5                	mov    %esp,%ebp
  8006f8:	83 ec 18             	sub    $0x18,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8006fb:	8d 45 fc             	lea    -0x4(%ebp),%eax
  8006fe:	89 44 24 04          	mov    %eax,0x4(%esp)
  800702:	8b 45 08             	mov    0x8(%ebp),%eax
  800705:	89 04 24             	mov    %eax,(%esp)
  800708:	e8 a0 ff ff ff       	call   8006ad <fd_lookup>
  80070d:	85 c0                	test   %eax,%eax
  80070f:	78 0e                	js     80071f <seek+0x2a>
		return r;
	fd->fd_offset = offset;
  800711:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800714:	8b 55 0c             	mov    0xc(%ebp),%edx
  800717:	89 50 04             	mov    %edx,0x4(%eax)
  80071a:	b8 00 00 00 00       	mov    $0x0,%eax
	return 0;
}
  80071f:	c9                   	leave  
  800720:	c3                   	ret    

00800721 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  800721:	55                   	push   %ebp
  800722:	89 e5                	mov    %esp,%ebp
  800724:	56                   	push   %esi
  800725:	53                   	push   %ebx
  800726:	83 ec 10             	sub    $0x10,%esp
  800729:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80072c:	8b 5d 0c             	mov    0xc(%ebp),%ebx
// File functions
// --------------------------------------------------------------

static struct Dev *devtab[] =
{
	&devfile,
  80072f:	b8 04 60 80 00       	mov    $0x806004,%eax
{
	int i;
	for (i = 0; devtab[i]; i++)
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
  800734:	ba 00 00 00 00       	mov    $0x0,%edx

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  800739:	be a0 28 80 00       	mov    $0x8028a0,%esi
		if (devtab[i]->dev_id == dev_id) {
  80073e:	39 08                	cmp    %ecx,(%eax)
  800740:	75 10                	jne    800752 <dev_lookup+0x31>
  800742:	eb 04                	jmp    800748 <dev_lookup+0x27>
  800744:	39 08                	cmp    %ecx,(%eax)
  800746:	75 0a                	jne    800752 <dev_lookup+0x31>
			*dev = devtab[i];
  800748:	89 03                	mov    %eax,(%ebx)
  80074a:	b8 00 00 00 00       	mov    $0x0,%eax
			return 0;
  80074f:	90                   	nop
  800750:	eb 31                	jmp    800783 <dev_lookup+0x62>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  800752:	83 c2 01             	add    $0x1,%edx
  800755:	8b 04 96             	mov    (%esi,%edx,4),%eax
  800758:	85 c0                	test   %eax,%eax
  80075a:	75 e8                	jne    800744 <dev_lookup+0x23>
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", env->env_id, dev_id);
  80075c:	a1 74 60 80 00       	mov    0x806074,%eax
  800761:	8b 40 4c             	mov    0x4c(%eax),%eax
  800764:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  800768:	89 44 24 04          	mov    %eax,0x4(%esp)
  80076c:	c7 04 24 24 28 80 00 	movl   $0x802824,(%esp)
  800773:	e8 59 12 00 00       	call   8019d1 <cprintf>
	*dev = 0;
  800778:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  80077e:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
	return -E_INVAL;
}
  800783:	83 c4 10             	add    $0x10,%esp
  800786:	5b                   	pop    %ebx
  800787:	5e                   	pop    %esi
  800788:	5d                   	pop    %ebp
  800789:	c3                   	ret    

0080078a <fstat>:
	return (*dev->dev_trunc)(fd, newsize);
}

int
fstat(int fdnum, struct Stat *stat)
{
  80078a:	55                   	push   %ebp
  80078b:	89 e5                	mov    %esp,%ebp
  80078d:	53                   	push   %ebx
  80078e:	83 ec 24             	sub    $0x24,%esp
  800791:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  800794:	8d 45 f0             	lea    -0x10(%ebp),%eax
  800797:	89 44 24 04          	mov    %eax,0x4(%esp)
  80079b:	8b 45 08             	mov    0x8(%ebp),%eax
  80079e:	89 04 24             	mov    %eax,(%esp)
  8007a1:	e8 07 ff ff ff       	call   8006ad <fd_lookup>
  8007a6:	85 c0                	test   %eax,%eax
  8007a8:	78 53                	js     8007fd <fstat+0x73>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8007aa:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8007ad:	89 44 24 04          	mov    %eax,0x4(%esp)
  8007b1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8007b4:	8b 00                	mov    (%eax),%eax
  8007b6:	89 04 24             	mov    %eax,(%esp)
  8007b9:	e8 63 ff ff ff       	call   800721 <dev_lookup>
{
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8007be:	85 c0                	test   %eax,%eax
  8007c0:	78 3b                	js     8007fd <fstat+0x73>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if (!dev->dev_stat)
  8007c2:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8007c7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8007ca:	83 7a 14 00          	cmpl   $0x0,0x14(%edx)
  8007ce:	74 2d                	je     8007fd <fstat+0x73>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  8007d0:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  8007d3:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  8007da:	00 00 00 
	stat->st_isdir = 0;
  8007dd:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  8007e4:	00 00 00 
	stat->st_dev = dev;
  8007e7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8007ea:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  8007f0:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8007f4:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8007f7:	89 14 24             	mov    %edx,(%esp)
  8007fa:	ff 50 14             	call   *0x14(%eax)
}
  8007fd:	83 c4 24             	add    $0x24,%esp
  800800:	5b                   	pop    %ebx
  800801:	5d                   	pop    %ebp
  800802:	c3                   	ret    

00800803 <ftruncate>:
	return 0;
}

int
ftruncate(int fdnum, off_t newsize)
{
  800803:	55                   	push   %ebp
  800804:	89 e5                	mov    %esp,%ebp
  800806:	53                   	push   %ebx
  800807:	83 ec 24             	sub    $0x24,%esp
  80080a:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  80080d:	8d 45 f0             	lea    -0x10(%ebp),%eax
  800810:	89 44 24 04          	mov    %eax,0x4(%esp)
  800814:	89 1c 24             	mov    %ebx,(%esp)
  800817:	e8 91 fe ff ff       	call   8006ad <fd_lookup>
  80081c:	85 c0                	test   %eax,%eax
  80081e:	78 5f                	js     80087f <ftruncate+0x7c>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  800820:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800823:	89 44 24 04          	mov    %eax,0x4(%esp)
  800827:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80082a:	8b 00                	mov    (%eax),%eax
  80082c:	89 04 24             	mov    %eax,(%esp)
  80082f:	e8 ed fe ff ff       	call   800721 <dev_lookup>
ftruncate(int fdnum, off_t newsize)
{
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  800834:	85 c0                	test   %eax,%eax
  800836:	78 47                	js     80087f <ftruncate+0x7c>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  800838:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80083b:	f6 42 08 03          	testb  $0x3,0x8(%edx)
  80083f:	75 23                	jne    800864 <ftruncate+0x61>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			env->env_id, fdnum); 
  800841:	a1 74 60 80 00       	mov    0x806074,%eax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  800846:	8b 40 4c             	mov    0x4c(%eax),%eax
  800849:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80084d:	89 44 24 04          	mov    %eax,0x4(%esp)
  800851:	c7 04 24 44 28 80 00 	movl   $0x802844,(%esp)
  800858:	e8 74 11 00 00       	call   8019d1 <cprintf>
  80085d:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
			env->env_id, fdnum); 
		return -E_INVAL;
  800862:	eb 1b                	jmp    80087f <ftruncate+0x7c>
	}
	if (!dev->dev_trunc)
  800864:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800867:	8b 48 18             	mov    0x18(%eax),%ecx
  80086a:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  80086f:	85 c9                	test   %ecx,%ecx
  800871:	74 0c                	je     80087f <ftruncate+0x7c>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  800873:	8b 45 0c             	mov    0xc(%ebp),%eax
  800876:	89 44 24 04          	mov    %eax,0x4(%esp)
  80087a:	89 14 24             	mov    %edx,(%esp)
  80087d:	ff d1                	call   *%ecx
}
  80087f:	83 c4 24             	add    $0x24,%esp
  800882:	5b                   	pop    %ebx
  800883:	5d                   	pop    %ebp
  800884:	c3                   	ret    

00800885 <write>:
	return tot;
}

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  800885:	55                   	push   %ebp
  800886:	89 e5                	mov    %esp,%ebp
  800888:	53                   	push   %ebx
  800889:	83 ec 24             	sub    $0x24,%esp
  80088c:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80088f:	8d 45 f0             	lea    -0x10(%ebp),%eax
  800892:	89 44 24 04          	mov    %eax,0x4(%esp)
  800896:	89 1c 24             	mov    %ebx,(%esp)
  800899:	e8 0f fe ff ff       	call   8006ad <fd_lookup>
  80089e:	85 c0                	test   %eax,%eax
  8008a0:	78 66                	js     800908 <write+0x83>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8008a2:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8008a5:	89 44 24 04          	mov    %eax,0x4(%esp)
  8008a9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8008ac:	8b 00                	mov    (%eax),%eax
  8008ae:	89 04 24             	mov    %eax,(%esp)
  8008b1:	e8 6b fe ff ff       	call   800721 <dev_lookup>
{
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8008b6:	85 c0                	test   %eax,%eax
  8008b8:	78 4e                	js     800908 <write+0x83>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8008ba:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8008bd:	f6 42 08 03          	testb  $0x3,0x8(%edx)
  8008c1:	75 23                	jne    8008e6 <write+0x61>
		cprintf("[%08x] write %d -- bad mode\n", env->env_id, fdnum);
  8008c3:	a1 74 60 80 00       	mov    0x806074,%eax
  8008c8:	8b 40 4c             	mov    0x4c(%eax),%eax
  8008cb:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8008cf:	89 44 24 04          	mov    %eax,0x4(%esp)
  8008d3:	c7 04 24 65 28 80 00 	movl   $0x802865,(%esp)
  8008da:	e8 f2 10 00 00       	call   8019d1 <cprintf>
  8008df:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
		return -E_INVAL;
  8008e4:	eb 22                	jmp    800908 <write+0x83>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  8008e6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8008e9:	8b 48 0c             	mov    0xc(%eax),%ecx
  8008ec:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8008f1:	85 c9                	test   %ecx,%ecx
  8008f3:	74 13                	je     800908 <write+0x83>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  8008f5:	8b 45 10             	mov    0x10(%ebp),%eax
  8008f8:	89 44 24 08          	mov    %eax,0x8(%esp)
  8008fc:	8b 45 0c             	mov    0xc(%ebp),%eax
  8008ff:	89 44 24 04          	mov    %eax,0x4(%esp)
  800903:	89 14 24             	mov    %edx,(%esp)
  800906:	ff d1                	call   *%ecx
}
  800908:	83 c4 24             	add    $0x24,%esp
  80090b:	5b                   	pop    %ebx
  80090c:	5d                   	pop    %ebp
  80090d:	c3                   	ret    

0080090e <read>:
	return r;
}

ssize_t
read(int fdnum, void *buf, size_t n)
{
  80090e:	55                   	push   %ebp
  80090f:	89 e5                	mov    %esp,%ebp
  800911:	53                   	push   %ebx
  800912:	83 ec 24             	sub    $0x24,%esp
  800915:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  800918:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80091b:	89 44 24 04          	mov    %eax,0x4(%esp)
  80091f:	89 1c 24             	mov    %ebx,(%esp)
  800922:	e8 86 fd ff ff       	call   8006ad <fd_lookup>
  800927:	85 c0                	test   %eax,%eax
  800929:	78 6b                	js     800996 <read+0x88>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80092b:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80092e:	89 44 24 04          	mov    %eax,0x4(%esp)
  800932:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800935:	8b 00                	mov    (%eax),%eax
  800937:	89 04 24             	mov    %eax,(%esp)
  80093a:	e8 e2 fd ff ff       	call   800721 <dev_lookup>
{
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80093f:	85 c0                	test   %eax,%eax
  800941:	78 53                	js     800996 <read+0x88>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  800943:	8b 55 f0             	mov    -0x10(%ebp),%edx
  800946:	8b 42 08             	mov    0x8(%edx),%eax
  800949:	83 e0 03             	and    $0x3,%eax
  80094c:	83 f8 01             	cmp    $0x1,%eax
  80094f:	75 23                	jne    800974 <read+0x66>
		cprintf("[%08x] read %d -- bad mode\n", env->env_id, fdnum); 
  800951:	a1 74 60 80 00       	mov    0x806074,%eax
  800956:	8b 40 4c             	mov    0x4c(%eax),%eax
  800959:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80095d:	89 44 24 04          	mov    %eax,0x4(%esp)
  800961:	c7 04 24 82 28 80 00 	movl   $0x802882,(%esp)
  800968:	e8 64 10 00 00       	call   8019d1 <cprintf>
  80096d:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
		return -E_INVAL;
  800972:	eb 22                	jmp    800996 <read+0x88>
	}
	if (!dev->dev_read)
  800974:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800977:	8b 48 08             	mov    0x8(%eax),%ecx
  80097a:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  80097f:	85 c9                	test   %ecx,%ecx
  800981:	74 13                	je     800996 <read+0x88>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  800983:	8b 45 10             	mov    0x10(%ebp),%eax
  800986:	89 44 24 08          	mov    %eax,0x8(%esp)
  80098a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80098d:	89 44 24 04          	mov    %eax,0x4(%esp)
  800991:	89 14 24             	mov    %edx,(%esp)
  800994:	ff d1                	call   *%ecx
}
  800996:	83 c4 24             	add    $0x24,%esp
  800999:	5b                   	pop    %ebx
  80099a:	5d                   	pop    %ebp
  80099b:	c3                   	ret    

0080099c <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  80099c:	55                   	push   %ebp
  80099d:	89 e5                	mov    %esp,%ebp
  80099f:	57                   	push   %edi
  8009a0:	56                   	push   %esi
  8009a1:	53                   	push   %ebx
  8009a2:	83 ec 1c             	sub    $0x1c,%esp
  8009a5:	8b 7d 08             	mov    0x8(%ebp),%edi
  8009a8:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  8009ab:	ba 00 00 00 00       	mov    $0x0,%edx
  8009b0:	bb 00 00 00 00       	mov    $0x0,%ebx
  8009b5:	b8 00 00 00 00       	mov    $0x0,%eax
  8009ba:	85 f6                	test   %esi,%esi
  8009bc:	74 29                	je     8009e7 <readn+0x4b>
		m = read(fdnum, (char*)buf + tot, n - tot);
  8009be:	89 f0                	mov    %esi,%eax
  8009c0:	29 d0                	sub    %edx,%eax
  8009c2:	89 44 24 08          	mov    %eax,0x8(%esp)
  8009c6:	03 55 0c             	add    0xc(%ebp),%edx
  8009c9:	89 54 24 04          	mov    %edx,0x4(%esp)
  8009cd:	89 3c 24             	mov    %edi,(%esp)
  8009d0:	e8 39 ff ff ff       	call   80090e <read>
		if (m < 0)
  8009d5:	85 c0                	test   %eax,%eax
  8009d7:	78 0e                	js     8009e7 <readn+0x4b>
			return m;
		if (m == 0)
  8009d9:	85 c0                	test   %eax,%eax
  8009db:	74 08                	je     8009e5 <readn+0x49>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  8009dd:	01 c3                	add    %eax,%ebx
  8009df:	89 da                	mov    %ebx,%edx
  8009e1:	39 f3                	cmp    %esi,%ebx
  8009e3:	72 d9                	jb     8009be <readn+0x22>
  8009e5:	89 d8                	mov    %ebx,%eax
			return m;
		if (m == 0)
			break;
	}
	return tot;
}
  8009e7:	83 c4 1c             	add    $0x1c,%esp
  8009ea:	5b                   	pop    %ebx
  8009eb:	5e                   	pop    %esi
  8009ec:	5f                   	pop    %edi
  8009ed:	5d                   	pop    %ebp
  8009ee:	c3                   	ret    

008009ef <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  8009ef:	55                   	push   %ebp
  8009f0:	89 e5                	mov    %esp,%ebp
  8009f2:	56                   	push   %esi
  8009f3:	53                   	push   %ebx
  8009f4:	83 ec 20             	sub    $0x20,%esp
  8009f7:	8b 75 08             	mov    0x8(%ebp),%esi
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8009fa:	89 34 24             	mov    %esi,(%esp)
  8009fd:	e8 0e fc ff ff       	call   800610 <fd2num>
  800a02:	8d 55 f4             	lea    -0xc(%ebp),%edx
  800a05:	89 54 24 04          	mov    %edx,0x4(%esp)
  800a09:	89 04 24             	mov    %eax,(%esp)
  800a0c:	e8 9c fc ff ff       	call   8006ad <fd_lookup>
  800a11:	89 c3                	mov    %eax,%ebx
  800a13:	85 c0                	test   %eax,%eax
  800a15:	78 05                	js     800a1c <fd_close+0x2d>
  800a17:	3b 75 f4             	cmp    -0xc(%ebp),%esi
  800a1a:	74 0c                	je     800a28 <fd_close+0x39>
	    || fd != fd2)
		return (must_exist ? r : 0);
  800a1c:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800a20:	19 c0                	sbb    %eax,%eax
  800a22:	f7 d0                	not    %eax
  800a24:	21 c3                	and    %eax,%ebx
  800a26:	eb 3d                	jmp    800a65 <fd_close+0x76>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  800a28:	8d 45 f0             	lea    -0x10(%ebp),%eax
  800a2b:	89 44 24 04          	mov    %eax,0x4(%esp)
  800a2f:	8b 06                	mov    (%esi),%eax
  800a31:	89 04 24             	mov    %eax,(%esp)
  800a34:	e8 e8 fc ff ff       	call   800721 <dev_lookup>
  800a39:	89 c3                	mov    %eax,%ebx
  800a3b:	85 c0                	test   %eax,%eax
  800a3d:	78 16                	js     800a55 <fd_close+0x66>
		if (dev->dev_close)
  800a3f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800a42:	8b 40 10             	mov    0x10(%eax),%eax
  800a45:	bb 00 00 00 00       	mov    $0x0,%ebx
  800a4a:	85 c0                	test   %eax,%eax
  800a4c:	74 07                	je     800a55 <fd_close+0x66>
			r = (*dev->dev_close)(fd);
  800a4e:	89 34 24             	mov    %esi,(%esp)
  800a51:	ff d0                	call   *%eax
  800a53:	89 c3                	mov    %eax,%ebx
		else
			r = 0;
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  800a55:	89 74 24 04          	mov    %esi,0x4(%esp)
  800a59:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  800a60:	e8 ca f9 ff ff       	call   80042f <sys_page_unmap>
	return r;
}
  800a65:	89 d8                	mov    %ebx,%eax
  800a67:	83 c4 20             	add    $0x20,%esp
  800a6a:	5b                   	pop    %ebx
  800a6b:	5e                   	pop    %esi
  800a6c:	5d                   	pop    %ebp
  800a6d:	c3                   	ret    

00800a6e <close>:
	return -E_INVAL;
}

int
close(int fdnum)
{
  800a6e:	55                   	push   %ebp
  800a6f:	89 e5                	mov    %esp,%ebp
  800a71:	83 ec 28             	sub    $0x28,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  800a74:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800a77:	89 44 24 04          	mov    %eax,0x4(%esp)
  800a7b:	8b 45 08             	mov    0x8(%ebp),%eax
  800a7e:	89 04 24             	mov    %eax,(%esp)
  800a81:	e8 27 fc ff ff       	call   8006ad <fd_lookup>
  800a86:	85 c0                	test   %eax,%eax
  800a88:	78 13                	js     800a9d <close+0x2f>
		return r;
	else
		return fd_close(fd, 1);
  800a8a:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  800a91:	00 
  800a92:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800a95:	89 04 24             	mov    %eax,(%esp)
  800a98:	e8 52 ff ff ff       	call   8009ef <fd_close>
}
  800a9d:	c9                   	leave  
  800a9e:	c3                   	ret    

00800a9f <stat>:
	return (*dev->dev_stat)(fd, stat);
}

int
stat(const char *path, struct Stat *stat)
{
  800a9f:	55                   	push   %ebp
  800aa0:	89 e5                	mov    %esp,%ebp
  800aa2:	83 ec 18             	sub    $0x18,%esp
  800aa5:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  800aa8:	89 75 fc             	mov    %esi,-0x4(%ebp)
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  800aab:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  800ab2:	00 
  800ab3:	8b 45 08             	mov    0x8(%ebp),%eax
  800ab6:	89 04 24             	mov    %eax,(%esp)
  800ab9:	e8 55 03 00 00       	call   800e13 <open>
  800abe:	89 c3                	mov    %eax,%ebx
  800ac0:	85 c0                	test   %eax,%eax
  800ac2:	78 1b                	js     800adf <stat+0x40>
		return fd;
	r = fstat(fd, stat);
  800ac4:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ac7:	89 44 24 04          	mov    %eax,0x4(%esp)
  800acb:	89 1c 24             	mov    %ebx,(%esp)
  800ace:	e8 b7 fc ff ff       	call   80078a <fstat>
  800ad3:	89 c6                	mov    %eax,%esi
	close(fd);
  800ad5:	89 1c 24             	mov    %ebx,(%esp)
  800ad8:	e8 91 ff ff ff       	call   800a6e <close>
  800add:	89 f3                	mov    %esi,%ebx
	return r;
}
  800adf:	89 d8                	mov    %ebx,%eax
  800ae1:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  800ae4:	8b 75 fc             	mov    -0x4(%ebp),%esi
  800ae7:	89 ec                	mov    %ebp,%esp
  800ae9:	5d                   	pop    %ebp
  800aea:	c3                   	ret    

00800aeb <close_all>:
		return fd_close(fd, 1);
}

void
close_all(void)
{
  800aeb:	55                   	push   %ebp
  800aec:	89 e5                	mov    %esp,%ebp
  800aee:	53                   	push   %ebx
  800aef:	83 ec 14             	sub    $0x14,%esp
  800af2:	bb 00 00 00 00       	mov    $0x0,%ebx
	int i;
	for (i = 0; i < MAXFD; i++)
		close(i);
  800af7:	89 1c 24             	mov    %ebx,(%esp)
  800afa:	e8 6f ff ff ff       	call   800a6e <close>

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  800aff:	83 c3 01             	add    $0x1,%ebx
  800b02:	83 fb 20             	cmp    $0x20,%ebx
  800b05:	75 f0                	jne    800af7 <close_all+0xc>
		close(i);
}
  800b07:	83 c4 14             	add    $0x14,%esp
  800b0a:	5b                   	pop    %ebx
  800b0b:	5d                   	pop    %ebp
  800b0c:	c3                   	ret    

00800b0d <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  800b0d:	55                   	push   %ebp
  800b0e:	89 e5                	mov    %esp,%ebp
  800b10:	83 ec 58             	sub    $0x58,%esp
  800b13:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800b16:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800b19:	89 7d fc             	mov    %edi,-0x4(%ebp)
  800b1c:	8b 7d 0c             	mov    0xc(%ebp),%edi
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  800b1f:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  800b22:	89 44 24 04          	mov    %eax,0x4(%esp)
  800b26:	8b 45 08             	mov    0x8(%ebp),%eax
  800b29:	89 04 24             	mov    %eax,(%esp)
  800b2c:	e8 7c fb ff ff       	call   8006ad <fd_lookup>
  800b31:	89 c3                	mov    %eax,%ebx
  800b33:	85 c0                	test   %eax,%eax
  800b35:	0f 88 e0 00 00 00    	js     800c1b <dup+0x10e>
		return r;
	close(newfdnum);
  800b3b:	89 3c 24             	mov    %edi,(%esp)
  800b3e:	e8 2b ff ff ff       	call   800a6e <close>

	newfd = INDEX2FD(newfdnum);
  800b43:	8d b7 00 00 0d 00    	lea    0xd0000(%edi),%esi
  800b49:	c1 e6 0c             	shl    $0xc,%esi
	ova = fd2data(oldfd);
  800b4c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800b4f:	89 04 24             	mov    %eax,(%esp)
  800b52:	e8 c9 fa ff ff       	call   800620 <fd2data>
  800b57:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  800b59:	89 34 24             	mov    %esi,(%esp)
  800b5c:	e8 bf fa ff ff       	call   800620 <fd2data>
  800b61:	89 45 d4             	mov    %eax,-0x2c(%ebp)

	if ((vpd[PDX(ova)] & PTE_P) && (vpt[VPN(ova)] & PTE_P))
  800b64:	89 da                	mov    %ebx,%edx
  800b66:	89 d8                	mov    %ebx,%eax
  800b68:	c1 e8 16             	shr    $0x16,%eax
  800b6b:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  800b72:	a8 01                	test   $0x1,%al
  800b74:	74 43                	je     800bb9 <dup+0xac>
  800b76:	c1 ea 0c             	shr    $0xc,%edx
  800b79:	8b 04 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%eax
  800b80:	a8 01                	test   $0x1,%al
  800b82:	74 35                	je     800bb9 <dup+0xac>
		if ((r = sys_page_map(0, ova, 0, nva, vpt[VPN(ova)] & PTE_USER)) < 0)
  800b84:	8b 04 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%eax
  800b8b:	25 07 0e 00 00       	and    $0xe07,%eax
  800b90:	89 44 24 10          	mov    %eax,0x10(%esp)
  800b94:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800b97:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800b9b:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  800ba2:	00 
  800ba3:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  800ba7:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  800bae:	e8 da f8 ff ff       	call   80048d <sys_page_map>
  800bb3:	89 c3                	mov    %eax,%ebx
  800bb5:	85 c0                	test   %eax,%eax
  800bb7:	78 3f                	js     800bf8 <dup+0xeb>
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, vpt[VPN(oldfd)] & PTE_USER)) < 0)
  800bb9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800bbc:	89 c2                	mov    %eax,%edx
  800bbe:	c1 ea 0c             	shr    $0xc,%edx
  800bc1:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  800bc8:	81 e2 07 0e 00 00    	and    $0xe07,%edx
  800bce:	89 54 24 10          	mov    %edx,0x10(%esp)
  800bd2:	89 74 24 0c          	mov    %esi,0xc(%esp)
  800bd6:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  800bdd:	00 
  800bde:	89 44 24 04          	mov    %eax,0x4(%esp)
  800be2:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  800be9:	e8 9f f8 ff ff       	call   80048d <sys_page_map>
  800bee:	89 c3                	mov    %eax,%ebx
  800bf0:	85 c0                	test   %eax,%eax
  800bf2:	78 04                	js     800bf8 <dup+0xeb>
  800bf4:	89 fb                	mov    %edi,%ebx
  800bf6:	eb 23                	jmp    800c1b <dup+0x10e>
		goto err;

	return newfdnum;

err:
	sys_page_unmap(0, newfd);
  800bf8:	89 74 24 04          	mov    %esi,0x4(%esp)
  800bfc:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  800c03:	e8 27 f8 ff ff       	call   80042f <sys_page_unmap>
	sys_page_unmap(0, nva);
  800c08:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800c0b:	89 44 24 04          	mov    %eax,0x4(%esp)
  800c0f:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  800c16:	e8 14 f8 ff ff       	call   80042f <sys_page_unmap>
	return r;
}
  800c1b:	89 d8                	mov    %ebx,%eax
  800c1d:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800c20:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800c23:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800c26:	89 ec                	mov    %ebp,%esp
  800c28:	5d                   	pop    %ebp
  800c29:	c3                   	ret    
	...

00800c2c <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  800c2c:	55                   	push   %ebp
  800c2d:	89 e5                	mov    %esp,%ebp
  800c2f:	53                   	push   %ebx
  800c30:	83 ec 14             	sub    $0x14,%esp
  800c33:	89 d3                	mov    %edx,%ebx
	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", env->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(envs[1].env_id, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  800c35:	8b 15 c8 00 c0 ee    	mov    0xeec000c8,%edx
  800c3b:	c7 44 24 0c 07 00 00 	movl   $0x7,0xc(%esp)
  800c42:	00 
  800c43:	c7 44 24 08 00 30 80 	movl   $0x803000,0x8(%esp)
  800c4a:	00 
  800c4b:	89 44 24 04          	mov    %eax,0x4(%esp)
  800c4f:	89 14 24             	mov    %edx,(%esp)
  800c52:	e8 f9 17 00 00       	call   802450 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  800c57:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  800c5e:	00 
  800c5f:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  800c63:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  800c6a:	e8 47 18 00 00       	call   8024b6 <ipc_recv>
}
  800c6f:	83 c4 14             	add    $0x14,%esp
  800c72:	5b                   	pop    %ebx
  800c73:	5d                   	pop    %ebp
  800c74:	c3                   	ret    

00800c75 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  800c75:	55                   	push   %ebp
  800c76:	89 e5                	mov    %esp,%ebp
  800c78:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  800c7b:	8b 45 08             	mov    0x8(%ebp),%eax
  800c7e:	8b 40 0c             	mov    0xc(%eax),%eax
  800c81:	a3 00 30 80 00       	mov    %eax,0x803000
	fsipcbuf.set_size.req_size = newsize;
  800c86:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c89:	a3 04 30 80 00       	mov    %eax,0x803004
	return fsipc(FSREQ_SET_SIZE, NULL);
  800c8e:	ba 00 00 00 00       	mov    $0x0,%edx
  800c93:	b8 02 00 00 00       	mov    $0x2,%eax
  800c98:	e8 8f ff ff ff       	call   800c2c <fsipc>
}
  800c9d:	c9                   	leave  
  800c9e:	c3                   	ret    

00800c9f <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  800c9f:	55                   	push   %ebp
  800ca0:	89 e5                	mov    %esp,%ebp
  800ca2:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  800ca5:	8b 45 08             	mov    0x8(%ebp),%eax
  800ca8:	8b 40 0c             	mov    0xc(%eax),%eax
  800cab:	a3 00 30 80 00       	mov    %eax,0x803000
	return fsipc(FSREQ_FLUSH, NULL);
  800cb0:	ba 00 00 00 00       	mov    $0x0,%edx
  800cb5:	b8 06 00 00 00       	mov    $0x6,%eax
  800cba:	e8 6d ff ff ff       	call   800c2c <fsipc>
}
  800cbf:	c9                   	leave  
  800cc0:	c3                   	ret    

00800cc1 <sync>:
}

// Synchronize disk with buffer cache
int
sync(void)
{
  800cc1:	55                   	push   %ebp
  800cc2:	89 e5                	mov    %esp,%ebp
  800cc4:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  800cc7:	ba 00 00 00 00       	mov    $0x0,%edx
  800ccc:	b8 08 00 00 00       	mov    $0x8,%eax
  800cd1:	e8 56 ff ff ff       	call   800c2c <fsipc>
}
  800cd6:	c9                   	leave  
  800cd7:	c3                   	ret    

00800cd8 <devfile_stat>:
	return fsipc(FSREQ_WRITE, NULL);	
}

static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  800cd8:	55                   	push   %ebp
  800cd9:	89 e5                	mov    %esp,%ebp
  800cdb:	53                   	push   %ebx
  800cdc:	83 ec 14             	sub    $0x14,%esp
  800cdf:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  800ce2:	8b 45 08             	mov    0x8(%ebp),%eax
  800ce5:	8b 40 0c             	mov    0xc(%eax),%eax
  800ce8:	a3 00 30 80 00       	mov    %eax,0x803000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  800ced:	ba 00 00 00 00       	mov    $0x0,%edx
  800cf2:	b8 05 00 00 00       	mov    $0x5,%eax
  800cf7:	e8 30 ff ff ff       	call   800c2c <fsipc>
  800cfc:	85 c0                	test   %eax,%eax
  800cfe:	78 2b                	js     800d2b <devfile_stat+0x53>
		return r;
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  800d00:	c7 44 24 04 00 30 80 	movl   $0x803000,0x4(%esp)
  800d07:	00 
  800d08:	89 1c 24             	mov    %ebx,(%esp)
  800d0b:	e8 7a 13 00 00       	call   80208a <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  800d10:	a1 80 30 80 00       	mov    0x803080,%eax
  800d15:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  800d1b:	a1 84 30 80 00       	mov    0x803084,%eax
  800d20:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
  800d26:	b8 00 00 00 00       	mov    $0x0,%eax
	return 0;
}
  800d2b:	83 c4 14             	add    $0x14,%esp
  800d2e:	5b                   	pop    %ebx
  800d2f:	5d                   	pop    %ebp
  800d30:	c3                   	ret    

00800d31 <devfile_write>:
// Returns:
//	 The number of bytes successfully written.
//	 < 0 on error.
static ssize_t
devfile_write(struct Fd *fd, const void *buf, size_t n)
{
  800d31:	55                   	push   %ebp
  800d32:	89 e5                	mov    %esp,%ebp
  800d34:	83 ec 18             	sub    $0x18,%esp
  800d37:	8b 45 10             	mov    0x10(%ebp),%eax
  800d3a:	3d f8 0f 00 00       	cmp    $0xff8,%eax
  800d3f:	76 05                	jbe    800d46 <devfile_write+0x15>
  800d41:	b8 f8 0f 00 00       	mov    $0xff8,%eax
	// LAB 5: Your code here
	//panic("devfile_write not implemented");
	
	if (n > (PGSIZE - (sizeof(int) + sizeof(size_t))))
		n = PGSIZE - (sizeof(int) + sizeof(size_t));
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  800d46:	8b 55 08             	mov    0x8(%ebp),%edx
  800d49:	8b 52 0c             	mov    0xc(%edx),%edx
  800d4c:	89 15 00 30 80 00    	mov    %edx,0x803000
	fsipcbuf.write.req_n = n;
  800d52:	a3 04 30 80 00       	mov    %eax,0x803004
	memmove (fsipcbuf.write.req_buf, (char*)buf, n);	
  800d57:	89 44 24 08          	mov    %eax,0x8(%esp)
  800d5b:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d5e:	89 44 24 04          	mov    %eax,0x4(%esp)
  800d62:	c7 04 24 08 30 80 00 	movl   $0x803008,(%esp)
  800d69:	e8 d7 14 00 00       	call   802245 <memmove>
	return fsipc(FSREQ_WRITE, NULL);	
  800d6e:	ba 00 00 00 00       	mov    $0x0,%edx
  800d73:	b8 04 00 00 00       	mov    $0x4,%eax
  800d78:	e8 af fe ff ff       	call   800c2c <fsipc>
}
  800d7d:	c9                   	leave  
  800d7e:	c3                   	ret    

00800d7f <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  800d7f:	55                   	push   %ebp
  800d80:	89 e5                	mov    %esp,%ebp
  800d82:	53                   	push   %ebx
  800d83:	83 ec 14             	sub    $0x14,%esp
	// system server.
	// LAB 5: Your code here
	
	//panic("devfile_read not implemented");
	int r;
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  800d86:	8b 45 08             	mov    0x8(%ebp),%eax
  800d89:	8b 40 0c             	mov    0xc(%eax),%eax
  800d8c:	a3 00 30 80 00       	mov    %eax,0x803000
	fsipcbuf.read.req_n = n;
  800d91:	8b 45 10             	mov    0x10(%ebp),%eax
  800d94:	a3 04 30 80 00       	mov    %eax,0x803004
	if ((r = fsipc(FSREQ_READ, (void*)&fsipcbuf)) < 0)
  800d99:	ba 00 30 80 00       	mov    $0x803000,%edx
  800d9e:	b8 03 00 00 00       	mov    $0x3,%eax
  800da3:	e8 84 fe ff ff       	call   800c2c <fsipc>
  800da8:	89 c3                	mov    %eax,%ebx
  800daa:	85 c0                	test   %eax,%eax
  800dac:	78 17                	js     800dc5 <devfile_read+0x46>
		return r;
	memmove((void*)buf, (void*)fsipcbuf.readRet.ret_buf, r);
  800dae:	89 44 24 08          	mov    %eax,0x8(%esp)
  800db2:	c7 44 24 04 00 30 80 	movl   $0x803000,0x4(%esp)
  800db9:	00 
  800dba:	8b 45 0c             	mov    0xc(%ebp),%eax
  800dbd:	89 04 24             	mov    %eax,(%esp)
  800dc0:	e8 80 14 00 00       	call   802245 <memmove>
	return r;
}
  800dc5:	89 d8                	mov    %ebx,%eax
  800dc7:	83 c4 14             	add    $0x14,%esp
  800dca:	5b                   	pop    %ebx
  800dcb:	5d                   	pop    %ebp
  800dcc:	c3                   	ret    

00800dcd <remove>:
}

// Delete a file
int
remove(const char *path)
{
  800dcd:	55                   	push   %ebp
  800dce:	89 e5                	mov    %esp,%ebp
  800dd0:	53                   	push   %ebx
  800dd1:	83 ec 14             	sub    $0x14,%esp
  800dd4:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (strlen(path) >= MAXPATHLEN)
  800dd7:	89 1c 24             	mov    %ebx,(%esp)
  800dda:	e8 61 12 00 00       	call   802040 <strlen>
  800ddf:	89 c2                	mov    %eax,%edx
  800de1:	b8 f4 ff ff ff       	mov    $0xfffffff4,%eax
  800de6:	81 fa ff 03 00 00    	cmp    $0x3ff,%edx
  800dec:	7f 1f                	jg     800e0d <remove+0x40>
		return -E_BAD_PATH;
	strcpy(fsipcbuf.remove.req_path, path);
  800dee:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  800df2:	c7 04 24 00 30 80 00 	movl   $0x803000,(%esp)
  800df9:	e8 8c 12 00 00       	call   80208a <strcpy>
	return fsipc(FSREQ_REMOVE, NULL);
  800dfe:	ba 00 00 00 00       	mov    $0x0,%edx
  800e03:	b8 07 00 00 00       	mov    $0x7,%eax
  800e08:	e8 1f fe ff ff       	call   800c2c <fsipc>
}
  800e0d:	83 c4 14             	add    $0x14,%esp
  800e10:	5b                   	pop    %ebx
  800e11:	5d                   	pop    %ebp
  800e12:	c3                   	ret    

00800e13 <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  800e13:	55                   	push   %ebp
  800e14:	89 e5                	mov    %esp,%ebp
  800e16:	83 ec 28             	sub    $0x28,%esp
  800e19:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  800e1c:	89 75 fc             	mov    %esi,-0x4(%ebp)
  800e1f:	8b 75 08             	mov    0x8(%ebp),%esi
	// file descriptor.

	// LAB 5: Your code here.
	// Code added by Swastika / Sandeep
	
	if (strlen(path) >= MAXPATHLEN)
  800e22:	89 34 24             	mov    %esi,(%esp)
  800e25:	e8 16 12 00 00       	call   802040 <strlen>
  800e2a:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  800e2f:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  800e34:	7f 5e                	jg     800e94 <open+0x81>
		return -E_BAD_PATH;
	struct Fd * fd;
	int  r;
	if ((r = fd_alloc(&fd)) < 0)
  800e36:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800e39:	89 04 24             	mov    %eax,(%esp)
  800e3c:	e8 fa f7 ff ff       	call   80063b <fd_alloc>
  800e41:	89 c3                	mov    %eax,%ebx
  800e43:	85 c0                	test   %eax,%eax
  800e45:	78 4d                	js     800e94 <open+0x81>
		return r;
	strcpy (fsipcbuf.open.req_path, path);
  800e47:	89 74 24 04          	mov    %esi,0x4(%esp)
  800e4b:	c7 04 24 00 30 80 00 	movl   $0x803000,(%esp)
  800e52:	e8 33 12 00 00       	call   80208a <strcpy>
	fsipcbuf.open.req_omode = mode;	
  800e57:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e5a:	a3 00 34 80 00       	mov    %eax,0x803400
	if ((r = fsipc(FSREQ_OPEN,(void*)fd)) < 0)
  800e5f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800e62:	b8 01 00 00 00       	mov    $0x1,%eax
  800e67:	e8 c0 fd ff ff       	call   800c2c <fsipc>
  800e6c:	89 c3                	mov    %eax,%ebx
  800e6e:	85 c0                	test   %eax,%eax
  800e70:	79 15                	jns    800e87 <open+0x74>
	{
		fd_close(fd,0);
  800e72:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  800e79:	00 
  800e7a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800e7d:	89 04 24             	mov    %eax,(%esp)
  800e80:	e8 6a fb ff ff       	call   8009ef <fd_close>
		return r; 
  800e85:	eb 0d                	jmp    800e94 <open+0x81>
	}
	return fd2num(fd);
  800e87:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800e8a:	89 04 24             	mov    %eax,(%esp)
  800e8d:	e8 7e f7 ff ff       	call   800610 <fd2num>
  800e92:	89 c3                	mov    %eax,%ebx
	//panic("open not implemented");
}
  800e94:	89 d8                	mov    %ebx,%eax
  800e96:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  800e99:	8b 75 fc             	mov    -0x4(%ebp),%esi
  800e9c:	89 ec                	mov    %ebp,%esp
  800e9e:	5d                   	pop    %ebp
  800e9f:	c3                   	ret    

00800ea0 <devsock_stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  800ea0:	55                   	push   %ebp
  800ea1:	89 e5                	mov    %esp,%ebp
  800ea3:	83 ec 18             	sub    $0x18,%esp
	strcpy(stat->st_name, "<sock>");
  800ea6:	c7 44 24 04 b4 28 80 	movl   $0x8028b4,0x4(%esp)
  800ead:	00 
  800eae:	8b 45 0c             	mov    0xc(%ebp),%eax
  800eb1:	89 04 24             	mov    %eax,(%esp)
  800eb4:	e8 d1 11 00 00       	call   80208a <strcpy>
	return 0;
}
  800eb9:	b8 00 00 00 00       	mov    $0x0,%eax
  800ebe:	c9                   	leave  
  800ebf:	c3                   	ret    

00800ec0 <devsock_close>:
	return nsipc_shutdown(r, how);
}

static int
devsock_close(struct Fd *fd)
{
  800ec0:	55                   	push   %ebp
  800ec1:	89 e5                	mov    %esp,%ebp
  800ec3:	83 ec 18             	sub    $0x18,%esp
	return nsipc_close(fd->fd_sock.sockid);
  800ec6:	8b 45 08             	mov    0x8(%ebp),%eax
  800ec9:	8b 40 0c             	mov    0xc(%eax),%eax
  800ecc:	89 04 24             	mov    %eax,(%esp)
  800ecf:	e8 9e 02 00 00       	call   801172 <nsipc_close>
}
  800ed4:	c9                   	leave  
  800ed5:	c3                   	ret    

00800ed6 <devsock_write>:
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
}

static ssize_t
devsock_write(struct Fd *fd, const void *buf, size_t n)
{
  800ed6:	55                   	push   %ebp
  800ed7:	89 e5                	mov    %esp,%ebp
  800ed9:	83 ec 18             	sub    $0x18,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  800edc:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  800ee3:	00 
  800ee4:	8b 45 10             	mov    0x10(%ebp),%eax
  800ee7:	89 44 24 08          	mov    %eax,0x8(%esp)
  800eeb:	8b 45 0c             	mov    0xc(%ebp),%eax
  800eee:	89 44 24 04          	mov    %eax,0x4(%esp)
  800ef2:	8b 45 08             	mov    0x8(%ebp),%eax
  800ef5:	8b 40 0c             	mov    0xc(%eax),%eax
  800ef8:	89 04 24             	mov    %eax,(%esp)
  800efb:	e8 ae 02 00 00       	call   8011ae <nsipc_send>
}
  800f00:	c9                   	leave  
  800f01:	c3                   	ret    

00800f02 <devsock_read>:
	return nsipc_listen(r, backlog);
}

static ssize_t
devsock_read(struct Fd *fd, void *buf, size_t n)
{
  800f02:	55                   	push   %ebp
  800f03:	89 e5                	mov    %esp,%ebp
  800f05:	83 ec 18             	sub    $0x18,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  800f08:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  800f0f:	00 
  800f10:	8b 45 10             	mov    0x10(%ebp),%eax
  800f13:	89 44 24 08          	mov    %eax,0x8(%esp)
  800f17:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f1a:	89 44 24 04          	mov    %eax,0x4(%esp)
  800f1e:	8b 45 08             	mov    0x8(%ebp),%eax
  800f21:	8b 40 0c             	mov    0xc(%eax),%eax
  800f24:	89 04 24             	mov    %eax,(%esp)
  800f27:	e8 f5 02 00 00       	call   801221 <nsipc_recv>
}
  800f2c:	c9                   	leave  
  800f2d:	c3                   	ret    

00800f2e <alloc_sockfd>:
	return sfd->fd_sock.sockid;
}

static int
alloc_sockfd(int sockid)
{
  800f2e:	55                   	push   %ebp
  800f2f:	89 e5                	mov    %esp,%ebp
  800f31:	56                   	push   %esi
  800f32:	53                   	push   %ebx
  800f33:	83 ec 20             	sub    $0x20,%esp
  800f36:	89 c6                	mov    %eax,%esi
	struct Fd *sfd;
	int r;

	if ((r = fd_alloc(&sfd)) < 0
  800f38:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800f3b:	89 04 24             	mov    %eax,(%esp)
  800f3e:	e8 f8 f6 ff ff       	call   80063b <fd_alloc>
  800f43:	89 c3                	mov    %eax,%ebx
  800f45:	85 c0                	test   %eax,%eax
  800f47:	78 21                	js     800f6a <alloc_sockfd+0x3c>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U)) < 0) {
  800f49:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  800f50:	00 
  800f51:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800f54:	89 44 24 04          	mov    %eax,0x4(%esp)
  800f58:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  800f5f:	e8 87 f5 ff ff       	call   8004eb <sys_page_alloc>
  800f64:	89 c3                	mov    %eax,%ebx
alloc_sockfd(int sockid)
{
	struct Fd *sfd;
	int r;

	if ((r = fd_alloc(&sfd)) < 0
  800f66:	85 c0                	test   %eax,%eax
  800f68:	79 0a                	jns    800f74 <alloc_sockfd+0x46>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U)) < 0) {
		nsipc_close(sockid);
  800f6a:	89 34 24             	mov    %esi,(%esp)
  800f6d:	e8 00 02 00 00       	call   801172 <nsipc_close>
		return r;
  800f72:	eb 28                	jmp    800f9c <alloc_sockfd+0x6e>
	}

	sfd->fd_dev_id = devsock.dev_id;
  800f74:	8b 15 20 60 80 00    	mov    0x806020,%edx
  800f7a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800f7d:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  800f7f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800f82:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	sfd->fd_sock.sockid = sockid;
  800f89:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800f8c:	89 70 0c             	mov    %esi,0xc(%eax)
	return fd2num(sfd);
  800f8f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800f92:	89 04 24             	mov    %eax,(%esp)
  800f95:	e8 76 f6 ff ff       	call   800610 <fd2num>
  800f9a:	89 c3                	mov    %eax,%ebx
}
  800f9c:	89 d8                	mov    %ebx,%eax
  800f9e:	83 c4 20             	add    $0x20,%esp
  800fa1:	5b                   	pop    %ebx
  800fa2:	5e                   	pop    %esi
  800fa3:	5d                   	pop    %ebp
  800fa4:	c3                   	ret    

00800fa5 <socket>:
	return 0;
}

int
socket(int domain, int type, int protocol)
{
  800fa5:	55                   	push   %ebp
  800fa6:	89 e5                	mov    %esp,%ebp
  800fa8:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  800fab:	8b 45 10             	mov    0x10(%ebp),%eax
  800fae:	89 44 24 08          	mov    %eax,0x8(%esp)
  800fb2:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fb5:	89 44 24 04          	mov    %eax,0x4(%esp)
  800fb9:	8b 45 08             	mov    0x8(%ebp),%eax
  800fbc:	89 04 24             	mov    %eax,(%esp)
  800fbf:	e8 62 01 00 00       	call   801126 <nsipc_socket>
  800fc4:	85 c0                	test   %eax,%eax
  800fc6:	78 05                	js     800fcd <socket+0x28>
		return r;
	return alloc_sockfd(r);
  800fc8:	e8 61 ff ff ff       	call   800f2e <alloc_sockfd>
}
  800fcd:	c9                   	leave  
  800fce:	66 90                	xchg   %ax,%ax
  800fd0:	c3                   	ret    

00800fd1 <fd2sockid>:
	.dev_stat =	devsock_stat,
};

static int
fd2sockid(int fd)
{
  800fd1:	55                   	push   %ebp
  800fd2:	89 e5                	mov    %esp,%ebp
  800fd4:	83 ec 28             	sub    $0x28,%esp
	struct Fd *sfd;
	int r;

	if ((r = fd_lookup(fd, &sfd)) < 0)
  800fd7:	8d 55 f4             	lea    -0xc(%ebp),%edx
  800fda:	89 54 24 04          	mov    %edx,0x4(%esp)
  800fde:	89 04 24             	mov    %eax,(%esp)
  800fe1:	e8 c7 f6 ff ff       	call   8006ad <fd_lookup>
  800fe6:	85 c0                	test   %eax,%eax
  800fe8:	78 15                	js     800fff <fd2sockid+0x2e>
		return r;
	if (sfd->fd_dev_id != devsock.dev_id)
  800fea:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800fed:	8b 0a                	mov    (%edx),%ecx
  800fef:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  800ff4:	3b 0d 20 60 80 00    	cmp    0x806020,%ecx
  800ffa:	75 03                	jne    800fff <fd2sockid+0x2e>
		return -E_NOT_SUPP;
	return sfd->fd_sock.sockid;
  800ffc:	8b 42 0c             	mov    0xc(%edx),%eax
}
  800fff:	c9                   	leave  
  801000:	c3                   	ret    

00801001 <listen>:
	return nsipc_connect(r, name, namelen);
}

int
listen(int s, int backlog)
{
  801001:	55                   	push   %ebp
  801002:	89 e5                	mov    %esp,%ebp
  801004:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  801007:	8b 45 08             	mov    0x8(%ebp),%eax
  80100a:	e8 c2 ff ff ff       	call   800fd1 <fd2sockid>
  80100f:	85 c0                	test   %eax,%eax
  801011:	78 0f                	js     801022 <listen+0x21>
		return r;
	return nsipc_listen(r, backlog);
  801013:	8b 55 0c             	mov    0xc(%ebp),%edx
  801016:	89 54 24 04          	mov    %edx,0x4(%esp)
  80101a:	89 04 24             	mov    %eax,(%esp)
  80101d:	e8 2e 01 00 00       	call   801150 <nsipc_listen>
}
  801022:	c9                   	leave  
  801023:	c3                   	ret    

00801024 <connect>:
	return nsipc_close(fd->fd_sock.sockid);
}

int
connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  801024:	55                   	push   %ebp
  801025:	89 e5                	mov    %esp,%ebp
  801027:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  80102a:	8b 45 08             	mov    0x8(%ebp),%eax
  80102d:	e8 9f ff ff ff       	call   800fd1 <fd2sockid>
  801032:	85 c0                	test   %eax,%eax
  801034:	78 16                	js     80104c <connect+0x28>
		return r;
	return nsipc_connect(r, name, namelen);
  801036:	8b 55 10             	mov    0x10(%ebp),%edx
  801039:	89 54 24 08          	mov    %edx,0x8(%esp)
  80103d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801040:	89 54 24 04          	mov    %edx,0x4(%esp)
  801044:	89 04 24             	mov    %eax,(%esp)
  801047:	e8 55 02 00 00       	call   8012a1 <nsipc_connect>
}
  80104c:	c9                   	leave  
  80104d:	c3                   	ret    

0080104e <shutdown>:
	return nsipc_bind(r, name, namelen);
}

int
shutdown(int s, int how)
{
  80104e:	55                   	push   %ebp
  80104f:	89 e5                	mov    %esp,%ebp
  801051:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  801054:	8b 45 08             	mov    0x8(%ebp),%eax
  801057:	e8 75 ff ff ff       	call   800fd1 <fd2sockid>
  80105c:	85 c0                	test   %eax,%eax
  80105e:	78 0f                	js     80106f <shutdown+0x21>
		return r;
	return nsipc_shutdown(r, how);
  801060:	8b 55 0c             	mov    0xc(%ebp),%edx
  801063:	89 54 24 04          	mov    %edx,0x4(%esp)
  801067:	89 04 24             	mov    %eax,(%esp)
  80106a:	e8 1d 01 00 00       	call   80118c <nsipc_shutdown>
}
  80106f:	c9                   	leave  
  801070:	c3                   	ret    

00801071 <bind>:
	return alloc_sockfd(r);
}

int
bind(int s, struct sockaddr *name, socklen_t namelen)
{
  801071:	55                   	push   %ebp
  801072:	89 e5                	mov    %esp,%ebp
  801074:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  801077:	8b 45 08             	mov    0x8(%ebp),%eax
  80107a:	e8 52 ff ff ff       	call   800fd1 <fd2sockid>
  80107f:	85 c0                	test   %eax,%eax
  801081:	78 16                	js     801099 <bind+0x28>
		return r;
	return nsipc_bind(r, name, namelen);
  801083:	8b 55 10             	mov    0x10(%ebp),%edx
  801086:	89 54 24 08          	mov    %edx,0x8(%esp)
  80108a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80108d:	89 54 24 04          	mov    %edx,0x4(%esp)
  801091:	89 04 24             	mov    %eax,(%esp)
  801094:	e8 47 02 00 00       	call   8012e0 <nsipc_bind>
}
  801099:	c9                   	leave  
  80109a:	c3                   	ret    

0080109b <accept>:
	return fd2num(sfd);
}

int
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  80109b:	55                   	push   %ebp
  80109c:	89 e5                	mov    %esp,%ebp
  80109e:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  8010a1:	8b 45 08             	mov    0x8(%ebp),%eax
  8010a4:	e8 28 ff ff ff       	call   800fd1 <fd2sockid>
  8010a9:	85 c0                	test   %eax,%eax
  8010ab:	78 1f                	js     8010cc <accept+0x31>
		return r;
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  8010ad:	8b 55 10             	mov    0x10(%ebp),%edx
  8010b0:	89 54 24 08          	mov    %edx,0x8(%esp)
  8010b4:	8b 55 0c             	mov    0xc(%ebp),%edx
  8010b7:	89 54 24 04          	mov    %edx,0x4(%esp)
  8010bb:	89 04 24             	mov    %eax,(%esp)
  8010be:	e8 5c 02 00 00       	call   80131f <nsipc_accept>
  8010c3:	85 c0                	test   %eax,%eax
  8010c5:	78 05                	js     8010cc <accept+0x31>
		return r;
	return alloc_sockfd(r);
  8010c7:	e8 62 fe ff ff       	call   800f2e <alloc_sockfd>
}
  8010cc:	c9                   	leave  
  8010cd:	8d 76 00             	lea    0x0(%esi),%esi
  8010d0:	c3                   	ret    
	...

008010e0 <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  8010e0:	55                   	push   %ebp
  8010e1:	89 e5                	mov    %esp,%ebp
  8010e3:	83 ec 18             	sub    $0x18,%esp
	if (debug)
		cprintf("[%08x] nsipc %d\n", env->env_id, type);

	ipc_send(envs[2].env_id, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  8010e6:	8b 15 44 01 c0 ee    	mov    0xeec00144,%edx
  8010ec:	c7 44 24 0c 07 00 00 	movl   $0x7,0xc(%esp)
  8010f3:	00 
  8010f4:	c7 44 24 08 00 50 80 	movl   $0x805000,0x8(%esp)
  8010fb:	00 
  8010fc:	89 44 24 04          	mov    %eax,0x4(%esp)
  801100:	89 14 24             	mov    %edx,(%esp)
  801103:	e8 48 13 00 00       	call   802450 <ipc_send>
	return ipc_recv(NULL, NULL, NULL);
  801108:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  80110f:	00 
  801110:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  801117:	00 
  801118:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80111f:	e8 92 13 00 00       	call   8024b6 <ipc_recv>
}
  801124:	c9                   	leave  
  801125:	c3                   	ret    

00801126 <nsipc_socket>:
	return nsipc(NSREQ_SEND);
}

int
nsipc_socket(int domain, int type, int protocol)
{
  801126:	55                   	push   %ebp
  801127:	89 e5                	mov    %esp,%ebp
  801129:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  80112c:	8b 45 08             	mov    0x8(%ebp),%eax
  80112f:	a3 00 50 80 00       	mov    %eax,0x805000
	nsipcbuf.socket.req_type = type;
  801134:	8b 45 0c             	mov    0xc(%ebp),%eax
  801137:	a3 04 50 80 00       	mov    %eax,0x805004
	nsipcbuf.socket.req_protocol = protocol;
  80113c:	8b 45 10             	mov    0x10(%ebp),%eax
  80113f:	a3 08 50 80 00       	mov    %eax,0x805008
	return nsipc(NSREQ_SOCKET);
  801144:	b8 09 00 00 00       	mov    $0x9,%eax
  801149:	e8 92 ff ff ff       	call   8010e0 <nsipc>
}
  80114e:	c9                   	leave  
  80114f:	c3                   	ret    

00801150 <nsipc_listen>:
	return nsipc(NSREQ_CONNECT);
}

int
nsipc_listen(int s, int backlog)
{
  801150:	55                   	push   %ebp
  801151:	89 e5                	mov    %esp,%ebp
  801153:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  801156:	8b 45 08             	mov    0x8(%ebp),%eax
  801159:	a3 00 50 80 00       	mov    %eax,0x805000
	nsipcbuf.listen.req_backlog = backlog;
  80115e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801161:	a3 04 50 80 00       	mov    %eax,0x805004
	return nsipc(NSREQ_LISTEN);
  801166:	b8 06 00 00 00       	mov    $0x6,%eax
  80116b:	e8 70 ff ff ff       	call   8010e0 <nsipc>
}
  801170:	c9                   	leave  
  801171:	c3                   	ret    

00801172 <nsipc_close>:
	return nsipc(NSREQ_SHUTDOWN);
}

int
nsipc_close(int s)
{
  801172:	55                   	push   %ebp
  801173:	89 e5                	mov    %esp,%ebp
  801175:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  801178:	8b 45 08             	mov    0x8(%ebp),%eax
  80117b:	a3 00 50 80 00       	mov    %eax,0x805000
	return nsipc(NSREQ_CLOSE);
  801180:	b8 04 00 00 00       	mov    $0x4,%eax
  801185:	e8 56 ff ff ff       	call   8010e0 <nsipc>
}
  80118a:	c9                   	leave  
  80118b:	c3                   	ret    

0080118c <nsipc_shutdown>:
	return nsipc(NSREQ_BIND);
}

int
nsipc_shutdown(int s, int how)
{
  80118c:	55                   	push   %ebp
  80118d:	89 e5                	mov    %esp,%ebp
  80118f:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  801192:	8b 45 08             	mov    0x8(%ebp),%eax
  801195:	a3 00 50 80 00       	mov    %eax,0x805000
	nsipcbuf.shutdown.req_how = how;
  80119a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80119d:	a3 04 50 80 00       	mov    %eax,0x805004
	return nsipc(NSREQ_SHUTDOWN);
  8011a2:	b8 03 00 00 00       	mov    $0x3,%eax
  8011a7:	e8 34 ff ff ff       	call   8010e0 <nsipc>
}
  8011ac:	c9                   	leave  
  8011ad:	c3                   	ret    

008011ae <nsipc_send>:
	return r;
}

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  8011ae:	55                   	push   %ebp
  8011af:	89 e5                	mov    %esp,%ebp
  8011b1:	53                   	push   %ebx
  8011b2:	83 ec 14             	sub    $0x14,%esp
  8011b5:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  8011b8:	8b 45 08             	mov    0x8(%ebp),%eax
  8011bb:	a3 00 50 80 00       	mov    %eax,0x805000
	assert(size < 1600);
  8011c0:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  8011c6:	7e 24                	jle    8011ec <nsipc_send+0x3e>
  8011c8:	c7 44 24 0c c0 28 80 	movl   $0x8028c0,0xc(%esp)
  8011cf:	00 
  8011d0:	c7 44 24 08 cc 28 80 	movl   $0x8028cc,0x8(%esp)
  8011d7:	00 
  8011d8:	c7 44 24 04 66 00 00 	movl   $0x66,0x4(%esp)
  8011df:	00 
  8011e0:	c7 04 24 e1 28 80 00 	movl   $0x8028e1,(%esp)
  8011e7:	e8 20 07 00 00       	call   80190c <_panic>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  8011ec:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8011f0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011f3:	89 44 24 04          	mov    %eax,0x4(%esp)
  8011f7:	c7 04 24 0c 50 80 00 	movl   $0x80500c,(%esp)
  8011fe:	e8 42 10 00 00       	call   802245 <memmove>
	nsipcbuf.send.req_size = size;
  801203:	89 1d 04 50 80 00    	mov    %ebx,0x805004
	nsipcbuf.send.req_flags = flags;
  801209:	8b 45 14             	mov    0x14(%ebp),%eax
  80120c:	a3 08 50 80 00       	mov    %eax,0x805008
	return nsipc(NSREQ_SEND);
  801211:	b8 08 00 00 00       	mov    $0x8,%eax
  801216:	e8 c5 fe ff ff       	call   8010e0 <nsipc>
}
  80121b:	83 c4 14             	add    $0x14,%esp
  80121e:	5b                   	pop    %ebx
  80121f:	5d                   	pop    %ebp
  801220:	c3                   	ret    

00801221 <nsipc_recv>:
	return nsipc(NSREQ_LISTEN);
}

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  801221:	55                   	push   %ebp
  801222:	89 e5                	mov    %esp,%ebp
  801224:	56                   	push   %esi
  801225:	53                   	push   %ebx
  801226:	83 ec 10             	sub    $0x10,%esp
  801229:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  80122c:	8b 45 08             	mov    0x8(%ebp),%eax
  80122f:	a3 00 50 80 00       	mov    %eax,0x805000
	nsipcbuf.recv.req_len = len;
  801234:	89 35 04 50 80 00    	mov    %esi,0x805004
	nsipcbuf.recv.req_flags = flags;
  80123a:	8b 45 14             	mov    0x14(%ebp),%eax
  80123d:	a3 08 50 80 00       	mov    %eax,0x805008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  801242:	b8 07 00 00 00       	mov    $0x7,%eax
  801247:	e8 94 fe ff ff       	call   8010e0 <nsipc>
  80124c:	89 c3                	mov    %eax,%ebx
  80124e:	85 c0                	test   %eax,%eax
  801250:	78 46                	js     801298 <nsipc_recv+0x77>
		assert(r < 1600 && r <= len);
  801252:	3d 3f 06 00 00       	cmp    $0x63f,%eax
  801257:	7f 04                	jg     80125d <nsipc_recv+0x3c>
  801259:	39 c6                	cmp    %eax,%esi
  80125b:	7d 24                	jge    801281 <nsipc_recv+0x60>
  80125d:	c7 44 24 0c ed 28 80 	movl   $0x8028ed,0xc(%esp)
  801264:	00 
  801265:	c7 44 24 08 cc 28 80 	movl   $0x8028cc,0x8(%esp)
  80126c:	00 
  80126d:	c7 44 24 04 5b 00 00 	movl   $0x5b,0x4(%esp)
  801274:	00 
  801275:	c7 04 24 e1 28 80 00 	movl   $0x8028e1,(%esp)
  80127c:	e8 8b 06 00 00       	call   80190c <_panic>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  801281:	89 44 24 08          	mov    %eax,0x8(%esp)
  801285:	c7 44 24 04 00 50 80 	movl   $0x805000,0x4(%esp)
  80128c:	00 
  80128d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801290:	89 04 24             	mov    %eax,(%esp)
  801293:	e8 ad 0f 00 00       	call   802245 <memmove>
	}

	return r;
}
  801298:	89 d8                	mov    %ebx,%eax
  80129a:	83 c4 10             	add    $0x10,%esp
  80129d:	5b                   	pop    %ebx
  80129e:	5e                   	pop    %esi
  80129f:	5d                   	pop    %ebp
  8012a0:	c3                   	ret    

008012a1 <nsipc_connect>:
	return nsipc(NSREQ_CLOSE);
}

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  8012a1:	55                   	push   %ebp
  8012a2:	89 e5                	mov    %esp,%ebp
  8012a4:	53                   	push   %ebx
  8012a5:	83 ec 14             	sub    $0x14,%esp
  8012a8:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  8012ab:	8b 45 08             	mov    0x8(%ebp),%eax
  8012ae:	a3 00 50 80 00       	mov    %eax,0x805000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  8012b3:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8012b7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012ba:	89 44 24 04          	mov    %eax,0x4(%esp)
  8012be:	c7 04 24 04 50 80 00 	movl   $0x805004,(%esp)
  8012c5:	e8 7b 0f 00 00       	call   802245 <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  8012ca:	89 1d 14 50 80 00    	mov    %ebx,0x805014
	return nsipc(NSREQ_CONNECT);
  8012d0:	b8 05 00 00 00       	mov    $0x5,%eax
  8012d5:	e8 06 fe ff ff       	call   8010e0 <nsipc>
}
  8012da:	83 c4 14             	add    $0x14,%esp
  8012dd:	5b                   	pop    %ebx
  8012de:	5d                   	pop    %ebp
  8012df:	c3                   	ret    

008012e0 <nsipc_bind>:
	return r;
}

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  8012e0:	55                   	push   %ebp
  8012e1:	89 e5                	mov    %esp,%ebp
  8012e3:	53                   	push   %ebx
  8012e4:	83 ec 14             	sub    $0x14,%esp
  8012e7:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  8012ea:	8b 45 08             	mov    0x8(%ebp),%eax
  8012ed:	a3 00 50 80 00       	mov    %eax,0x805000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  8012f2:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8012f6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012f9:	89 44 24 04          	mov    %eax,0x4(%esp)
  8012fd:	c7 04 24 04 50 80 00 	movl   $0x805004,(%esp)
  801304:	e8 3c 0f 00 00       	call   802245 <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  801309:	89 1d 14 50 80 00    	mov    %ebx,0x805014
	return nsipc(NSREQ_BIND);
  80130f:	b8 02 00 00 00       	mov    $0x2,%eax
  801314:	e8 c7 fd ff ff       	call   8010e0 <nsipc>
}
  801319:	83 c4 14             	add    $0x14,%esp
  80131c:	5b                   	pop    %ebx
  80131d:	5d                   	pop    %ebp
  80131e:	c3                   	ret    

0080131f <nsipc_accept>:
	return ipc_recv(NULL, NULL, NULL);
}

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  80131f:	55                   	push   %ebp
  801320:	89 e5                	mov    %esp,%ebp
  801322:	83 ec 18             	sub    $0x18,%esp
  801325:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  801328:	89 75 fc             	mov    %esi,-0x4(%ebp)
	int r;
	
	nsipcbuf.accept.req_s = s;
  80132b:	8b 45 08             	mov    0x8(%ebp),%eax
  80132e:	a3 00 50 80 00       	mov    %eax,0x805000
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  801333:	b8 01 00 00 00       	mov    $0x1,%eax
  801338:	e8 a3 fd ff ff       	call   8010e0 <nsipc>
  80133d:	89 c3                	mov    %eax,%ebx
  80133f:	85 c0                	test   %eax,%eax
  801341:	78 25                	js     801368 <nsipc_accept+0x49>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  801343:	be 10 50 80 00       	mov    $0x805010,%esi
  801348:	8b 06                	mov    (%esi),%eax
  80134a:	89 44 24 08          	mov    %eax,0x8(%esp)
  80134e:	c7 44 24 04 00 50 80 	movl   $0x805000,0x4(%esp)
  801355:	00 
  801356:	8b 45 0c             	mov    0xc(%ebp),%eax
  801359:	89 04 24             	mov    %eax,(%esp)
  80135c:	e8 e4 0e 00 00       	call   802245 <memmove>
		*addrlen = ret->ret_addrlen;
  801361:	8b 16                	mov    (%esi),%edx
  801363:	8b 45 10             	mov    0x10(%ebp),%eax
  801366:	89 10                	mov    %edx,(%eax)
	}
	return r;
}
  801368:	89 d8                	mov    %ebx,%eax
  80136a:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  80136d:	8b 75 fc             	mov    -0x4(%ebp),%esi
  801370:	89 ec                	mov    %ebp,%esp
  801372:	5d                   	pop    %ebp
  801373:	c3                   	ret    
	...

00801380 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  801380:	55                   	push   %ebp
  801381:	89 e5                	mov    %esp,%ebp
  801383:	83 ec 18             	sub    $0x18,%esp
  801386:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  801389:	89 75 fc             	mov    %esi,-0x4(%ebp)
  80138c:	8b 75 0c             	mov    0xc(%ebp),%esi
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  80138f:	8b 45 08             	mov    0x8(%ebp),%eax
  801392:	89 04 24             	mov    %eax,(%esp)
  801395:	e8 86 f2 ff ff       	call   800620 <fd2data>
  80139a:	89 c3                	mov    %eax,%ebx
	strcpy(stat->st_name, "<pipe>");
  80139c:	c7 44 24 04 02 29 80 	movl   $0x802902,0x4(%esp)
  8013a3:	00 
  8013a4:	89 34 24             	mov    %esi,(%esp)
  8013a7:	e8 de 0c 00 00       	call   80208a <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  8013ac:	8b 43 04             	mov    0x4(%ebx),%eax
  8013af:	2b 03                	sub    (%ebx),%eax
  8013b1:	89 86 80 00 00 00    	mov    %eax,0x80(%esi)
	stat->st_isdir = 0;
  8013b7:	c7 86 84 00 00 00 00 	movl   $0x0,0x84(%esi)
  8013be:	00 00 00 
	stat->st_dev = &devpipe;
  8013c1:	c7 86 88 00 00 00 3c 	movl   $0x80603c,0x88(%esi)
  8013c8:	60 80 00 
	return 0;
}
  8013cb:	b8 00 00 00 00       	mov    $0x0,%eax
  8013d0:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  8013d3:	8b 75 fc             	mov    -0x4(%ebp),%esi
  8013d6:	89 ec                	mov    %ebp,%esp
  8013d8:	5d                   	pop    %ebp
  8013d9:	c3                   	ret    

008013da <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  8013da:	55                   	push   %ebp
  8013db:	89 e5                	mov    %esp,%ebp
  8013dd:	53                   	push   %ebx
  8013de:	83 ec 14             	sub    $0x14,%esp
  8013e1:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  8013e4:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8013e8:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8013ef:	e8 3b f0 ff ff       	call   80042f <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  8013f4:	89 1c 24             	mov    %ebx,(%esp)
  8013f7:	e8 24 f2 ff ff       	call   800620 <fd2data>
  8013fc:	89 44 24 04          	mov    %eax,0x4(%esp)
  801400:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801407:	e8 23 f0 ff ff       	call   80042f <sys_page_unmap>
}
  80140c:	83 c4 14             	add    $0x14,%esp
  80140f:	5b                   	pop    %ebx
  801410:	5d                   	pop    %ebp
  801411:	c3                   	ret    

00801412 <_pipeisclosed>:
	return r;
}

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  801412:	55                   	push   %ebp
  801413:	89 e5                	mov    %esp,%ebp
  801415:	57                   	push   %edi
  801416:	56                   	push   %esi
  801417:	53                   	push   %ebx
  801418:	83 ec 2c             	sub    $0x2c,%esp
  80141b:	89 c7                	mov    %eax,%edi
  80141d:	89 55 e4             	mov    %edx,-0x1c(%ebp)
	int n, nn, ret;

	while (1) {
		n = env->env_runs;
  801420:	a1 74 60 80 00       	mov    0x806074,%eax
  801425:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  801428:	89 3c 24             	mov    %edi,(%esp)
  80142b:	e8 f0 10 00 00       	call   802520 <pageref>
  801430:	89 c6                	mov    %eax,%esi
  801432:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801435:	89 04 24             	mov    %eax,(%esp)
  801438:	e8 e3 10 00 00       	call   802520 <pageref>
  80143d:	39 c6                	cmp    %eax,%esi
  80143f:	0f 94 c0             	sete   %al
  801442:	0f b6 c0             	movzbl %al,%eax
		nn = env->env_runs;
  801445:	8b 15 74 60 80 00    	mov    0x806074,%edx
  80144b:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  80144e:	39 cb                	cmp    %ecx,%ebx
  801450:	75 08                	jne    80145a <_pipeisclosed+0x48>
			return ret;
		if (n != nn && ret == 1)
			cprintf("pipe race avoided\n", n, env->env_runs, ret);
	}
}
  801452:	83 c4 2c             	add    $0x2c,%esp
  801455:	5b                   	pop    %ebx
  801456:	5e                   	pop    %esi
  801457:	5f                   	pop    %edi
  801458:	5d                   	pop    %ebp
  801459:	c3                   	ret    
		n = env->env_runs;
		ret = pageref(fd) == pageref(p);
		nn = env->env_runs;
		if (n == nn)
			return ret;
		if (n != nn && ret == 1)
  80145a:	83 f8 01             	cmp    $0x1,%eax
  80145d:	75 c1                	jne    801420 <_pipeisclosed+0xe>
			cprintf("pipe race avoided\n", n, env->env_runs, ret);
  80145f:	8b 52 58             	mov    0x58(%edx),%edx
  801462:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801466:	89 54 24 08          	mov    %edx,0x8(%esp)
  80146a:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  80146e:	c7 04 24 09 29 80 00 	movl   $0x802909,(%esp)
  801475:	e8 57 05 00 00       	call   8019d1 <cprintf>
  80147a:	eb a4                	jmp    801420 <_pipeisclosed+0xe>

0080147c <devpipe_write>:
	return i;
}

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  80147c:	55                   	push   %ebp
  80147d:	89 e5                	mov    %esp,%ebp
  80147f:	57                   	push   %edi
  801480:	56                   	push   %esi
  801481:	53                   	push   %ebx
  801482:	83 ec 1c             	sub    $0x1c,%esp
  801485:	8b 75 08             	mov    0x8(%ebp),%esi
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  801488:	89 34 24             	mov    %esi,(%esp)
  80148b:	e8 90 f1 ff ff       	call   800620 <fd2data>
  801490:	89 c3                	mov    %eax,%ebx
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			env->env_id, vpt[VPN(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  801492:	bf 00 00 00 00       	mov    $0x0,%edi
  801497:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80149b:	75 54                	jne    8014f1 <devpipe_write+0x75>
  80149d:	eb 60                	jmp    8014ff <devpipe_write+0x83>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  80149f:	89 da                	mov    %ebx,%edx
  8014a1:	89 f0                	mov    %esi,%eax
  8014a3:	e8 6a ff ff ff       	call   801412 <_pipeisclosed>
  8014a8:	85 c0                	test   %eax,%eax
  8014aa:	74 07                	je     8014b3 <devpipe_write+0x37>
  8014ac:	b8 00 00 00 00       	mov    $0x0,%eax
  8014b1:	eb 53                	jmp    801506 <devpipe_write+0x8a>
				return 0;
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  8014b3:	90                   	nop
  8014b4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  8014b8:	e8 8d f0 ff ff       	call   80054a <sys_yield>
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			env->env_id, vpt[VPN(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  8014bd:	8b 43 04             	mov    0x4(%ebx),%eax
  8014c0:	8b 13                	mov    (%ebx),%edx
  8014c2:	83 c2 20             	add    $0x20,%edx
  8014c5:	39 d0                	cmp    %edx,%eax
  8014c7:	73 d6                	jae    80149f <devpipe_write+0x23>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  8014c9:	89 c2                	mov    %eax,%edx
  8014cb:	c1 fa 1f             	sar    $0x1f,%edx
  8014ce:	c1 ea 1b             	shr    $0x1b,%edx
  8014d1:	01 d0                	add    %edx,%eax
  8014d3:	83 e0 1f             	and    $0x1f,%eax
  8014d6:	29 d0                	sub    %edx,%eax
  8014d8:	89 c2                	mov    %eax,%edx
  8014da:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8014dd:	0f b6 04 39          	movzbl (%ecx,%edi,1),%eax
  8014e1:	88 44 13 08          	mov    %al,0x8(%ebx,%edx,1)
		p->p_wpos++;
  8014e5:	83 43 04 01          	addl   $0x1,0x4(%ebx)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			env->env_id, vpt[VPN(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  8014e9:	83 c7 01             	add    $0x1,%edi
  8014ec:	39 7d 10             	cmp    %edi,0x10(%ebp)
  8014ef:	76 13                	jbe    801504 <devpipe_write+0x88>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  8014f1:	8b 43 04             	mov    0x4(%ebx),%eax
  8014f4:	8b 13                	mov    (%ebx),%edx
  8014f6:	83 c2 20             	add    $0x20,%edx
  8014f9:	39 d0                	cmp    %edx,%eax
  8014fb:	73 a2                	jae    80149f <devpipe_write+0x23>
  8014fd:	eb ca                	jmp    8014c9 <devpipe_write+0x4d>
  8014ff:	bf 00 00 00 00       	mov    $0x0,%edi
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}
	
	return i;
  801504:	89 f8                	mov    %edi,%eax
}
  801506:	83 c4 1c             	add    $0x1c,%esp
  801509:	5b                   	pop    %ebx
  80150a:	5e                   	pop    %esi
  80150b:	5f                   	pop    %edi
  80150c:	5d                   	pop    %ebp
  80150d:	c3                   	ret    

0080150e <devpipe_read>:
	return _pipeisclosed(fd, p);
}

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  80150e:	55                   	push   %ebp
  80150f:	89 e5                	mov    %esp,%ebp
  801511:	83 ec 28             	sub    $0x28,%esp
  801514:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  801517:	89 75 f8             	mov    %esi,-0x8(%ebp)
  80151a:	89 7d fc             	mov    %edi,-0x4(%ebp)
  80151d:	8b 7d 08             	mov    0x8(%ebp),%edi
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  801520:	89 3c 24             	mov    %edi,(%esp)
  801523:	e8 f8 f0 ff ff       	call   800620 <fd2data>
  801528:	89 c3                	mov    %eax,%ebx
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			env->env_id, vpt[VPN(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  80152a:	be 00 00 00 00       	mov    $0x0,%esi
  80152f:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801533:	75 4c                	jne    801581 <devpipe_read+0x73>
  801535:	eb 5b                	jmp    801592 <devpipe_read+0x84>
		while (p->p_rpos == p->p_wpos) {
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
				return i;
  801537:	89 f0                	mov    %esi,%eax
  801539:	eb 5e                	jmp    801599 <devpipe_read+0x8b>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  80153b:	89 da                	mov    %ebx,%edx
  80153d:	89 f8                	mov    %edi,%eax
  80153f:	90                   	nop
  801540:	e8 cd fe ff ff       	call   801412 <_pipeisclosed>
  801545:	85 c0                	test   %eax,%eax
  801547:	74 07                	je     801550 <devpipe_read+0x42>
  801549:	b8 00 00 00 00       	mov    $0x0,%eax
  80154e:	eb 49                	jmp    801599 <devpipe_read+0x8b>
				return 0;
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  801550:	e8 f5 ef ff ff       	call   80054a <sys_yield>
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			env->env_id, vpt[VPN(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  801555:	8b 03                	mov    (%ebx),%eax
  801557:	3b 43 04             	cmp    0x4(%ebx),%eax
  80155a:	74 df                	je     80153b <devpipe_read+0x2d>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  80155c:	89 c2                	mov    %eax,%edx
  80155e:	c1 fa 1f             	sar    $0x1f,%edx
  801561:	c1 ea 1b             	shr    $0x1b,%edx
  801564:	01 d0                	add    %edx,%eax
  801566:	83 e0 1f             	and    $0x1f,%eax
  801569:	29 d0                	sub    %edx,%eax
  80156b:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  801570:	8b 55 0c             	mov    0xc(%ebp),%edx
  801573:	88 04 32             	mov    %al,(%edx,%esi,1)
		p->p_rpos++;
  801576:	83 03 01             	addl   $0x1,(%ebx)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			env->env_id, vpt[VPN(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  801579:	83 c6 01             	add    $0x1,%esi
  80157c:	39 75 10             	cmp    %esi,0x10(%ebp)
  80157f:	76 16                	jbe    801597 <devpipe_read+0x89>
		while (p->p_rpos == p->p_wpos) {
  801581:	8b 03                	mov    (%ebx),%eax
  801583:	3b 43 04             	cmp    0x4(%ebx),%eax
  801586:	75 d4                	jne    80155c <devpipe_read+0x4e>
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  801588:	85 f6                	test   %esi,%esi
  80158a:	75 ab                	jne    801537 <devpipe_read+0x29>
  80158c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  801590:	eb a9                	jmp    80153b <devpipe_read+0x2d>
  801592:	be 00 00 00 00       	mov    $0x0,%esi
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  801597:	89 f0                	mov    %esi,%eax
}
  801599:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  80159c:	8b 75 f8             	mov    -0x8(%ebp),%esi
  80159f:	8b 7d fc             	mov    -0x4(%ebp),%edi
  8015a2:	89 ec                	mov    %ebp,%esp
  8015a4:	5d                   	pop    %ebp
  8015a5:	c3                   	ret    

008015a6 <pipeisclosed>:
	}
}

int
pipeisclosed(int fdnum)
{
  8015a6:	55                   	push   %ebp
  8015a7:	89 e5                	mov    %esp,%ebp
  8015a9:	83 ec 28             	sub    $0x28,%esp
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8015ac:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8015af:	89 44 24 04          	mov    %eax,0x4(%esp)
  8015b3:	8b 45 08             	mov    0x8(%ebp),%eax
  8015b6:	89 04 24             	mov    %eax,(%esp)
  8015b9:	e8 ef f0 ff ff       	call   8006ad <fd_lookup>
  8015be:	85 c0                	test   %eax,%eax
  8015c0:	78 15                	js     8015d7 <pipeisclosed+0x31>
		return r;
	p = (struct Pipe*) fd2data(fd);
  8015c2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8015c5:	89 04 24             	mov    %eax,(%esp)
  8015c8:	e8 53 f0 ff ff       	call   800620 <fd2data>
	return _pipeisclosed(fd, p);
  8015cd:	89 c2                	mov    %eax,%edx
  8015cf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8015d2:	e8 3b fe ff ff       	call   801412 <_pipeisclosed>
}
  8015d7:	c9                   	leave  
  8015d8:	c3                   	ret    

008015d9 <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  8015d9:	55                   	push   %ebp
  8015da:	89 e5                	mov    %esp,%ebp
  8015dc:	83 ec 48             	sub    $0x48,%esp
  8015df:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  8015e2:	89 75 f8             	mov    %esi,-0x8(%ebp)
  8015e5:	89 7d fc             	mov    %edi,-0x4(%ebp)
  8015e8:	8b 7d 08             	mov    0x8(%ebp),%edi
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  8015eb:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  8015ee:	89 04 24             	mov    %eax,(%esp)
  8015f1:	e8 45 f0 ff ff       	call   80063b <fd_alloc>
  8015f6:	89 c3                	mov    %eax,%ebx
  8015f8:	85 c0                	test   %eax,%eax
  8015fa:	0f 88 42 01 00 00    	js     801742 <pipe+0x169>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801600:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  801607:	00 
  801608:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80160b:	89 44 24 04          	mov    %eax,0x4(%esp)
  80160f:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801616:	e8 d0 ee ff ff       	call   8004eb <sys_page_alloc>
  80161b:	89 c3                	mov    %eax,%ebx
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  80161d:	85 c0                	test   %eax,%eax
  80161f:	0f 88 1d 01 00 00    	js     801742 <pipe+0x169>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  801625:	8d 45 e0             	lea    -0x20(%ebp),%eax
  801628:	89 04 24             	mov    %eax,(%esp)
  80162b:	e8 0b f0 ff ff       	call   80063b <fd_alloc>
  801630:	89 c3                	mov    %eax,%ebx
  801632:	85 c0                	test   %eax,%eax
  801634:	0f 88 f5 00 00 00    	js     80172f <pipe+0x156>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80163a:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  801641:	00 
  801642:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801645:	89 44 24 04          	mov    %eax,0x4(%esp)
  801649:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801650:	e8 96 ee ff ff       	call   8004eb <sys_page_alloc>
  801655:	89 c3                	mov    %eax,%ebx
	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  801657:	85 c0                	test   %eax,%eax
  801659:	0f 88 d0 00 00 00    	js     80172f <pipe+0x156>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  80165f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801662:	89 04 24             	mov    %eax,(%esp)
  801665:	e8 b6 ef ff ff       	call   800620 <fd2data>
  80166a:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80166c:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  801673:	00 
  801674:	89 44 24 04          	mov    %eax,0x4(%esp)
  801678:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80167f:	e8 67 ee ff ff       	call   8004eb <sys_page_alloc>
  801684:	89 c3                	mov    %eax,%ebx
  801686:	85 c0                	test   %eax,%eax
  801688:	0f 88 8e 00 00 00    	js     80171c <pipe+0x143>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80168e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801691:	89 04 24             	mov    %eax,(%esp)
  801694:	e8 87 ef ff ff       	call   800620 <fd2data>
  801699:	c7 44 24 10 07 04 00 	movl   $0x407,0x10(%esp)
  8016a0:	00 
  8016a1:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8016a5:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  8016ac:	00 
  8016ad:	89 74 24 04          	mov    %esi,0x4(%esp)
  8016b1:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8016b8:	e8 d0 ed ff ff       	call   80048d <sys_page_map>
  8016bd:	89 c3                	mov    %eax,%ebx
  8016bf:	85 c0                	test   %eax,%eax
  8016c1:	78 49                	js     80170c <pipe+0x133>
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  8016c3:	b8 3c 60 80 00       	mov    $0x80603c,%eax
  8016c8:	8b 08                	mov    (%eax),%ecx
  8016ca:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8016cd:	89 0a                	mov    %ecx,(%edx)
	fd0->fd_omode = O_RDONLY;
  8016cf:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8016d2:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%edx)

	fd1->fd_dev_id = devpipe.dev_id;
  8016d9:	8b 10                	mov    (%eax),%edx
  8016db:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8016de:	89 10                	mov    %edx,(%eax)
	fd1->fd_omode = O_WRONLY;
  8016e0:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8016e3:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", env->env_id, vpt[VPN(va)]);

	pfd[0] = fd2num(fd0);
  8016ea:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8016ed:	89 04 24             	mov    %eax,(%esp)
  8016f0:	e8 1b ef ff ff       	call   800610 <fd2num>
  8016f5:	89 07                	mov    %eax,(%edi)
	pfd[1] = fd2num(fd1);
  8016f7:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8016fa:	89 04 24             	mov    %eax,(%esp)
  8016fd:	e8 0e ef ff ff       	call   800610 <fd2num>
  801702:	89 47 04             	mov    %eax,0x4(%edi)
  801705:	bb 00 00 00 00       	mov    $0x0,%ebx
	return 0;
  80170a:	eb 36                	jmp    801742 <pipe+0x169>

    err3:
	sys_page_unmap(0, va);
  80170c:	89 74 24 04          	mov    %esi,0x4(%esp)
  801710:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801717:	e8 13 ed ff ff       	call   80042f <sys_page_unmap>
    err2:
	sys_page_unmap(0, fd1);
  80171c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80171f:	89 44 24 04          	mov    %eax,0x4(%esp)
  801723:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80172a:	e8 00 ed ff ff       	call   80042f <sys_page_unmap>
    err1:
	sys_page_unmap(0, fd0);
  80172f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801732:	89 44 24 04          	mov    %eax,0x4(%esp)
  801736:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80173d:	e8 ed ec ff ff       	call   80042f <sys_page_unmap>
    err:
	return r;
}
  801742:	89 d8                	mov    %ebx,%eax
  801744:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  801747:	8b 75 f8             	mov    -0x8(%ebp),%esi
  80174a:	8b 7d fc             	mov    -0x4(%ebp),%edi
  80174d:	89 ec                	mov    %ebp,%esp
  80174f:	5d                   	pop    %ebp
  801750:	c3                   	ret    
	...

00801760 <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  801760:	55                   	push   %ebp
  801761:	89 e5                	mov    %esp,%ebp
	USED(fd);

	return 0;
}
  801763:	b8 00 00 00 00       	mov    $0x0,%eax
  801768:	5d                   	pop    %ebp
  801769:	c3                   	ret    

0080176a <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  80176a:	55                   	push   %ebp
  80176b:	89 e5                	mov    %esp,%ebp
  80176d:	83 ec 18             	sub    $0x18,%esp
	strcpy(stat->st_name, "<cons>");
  801770:	c7 44 24 04 21 29 80 	movl   $0x802921,0x4(%esp)
  801777:	00 
  801778:	8b 45 0c             	mov    0xc(%ebp),%eax
  80177b:	89 04 24             	mov    %eax,(%esp)
  80177e:	e8 07 09 00 00       	call   80208a <strcpy>
	return 0;
}
  801783:	b8 00 00 00 00       	mov    $0x0,%eax
  801788:	c9                   	leave  
  801789:	c3                   	ret    

0080178a <devcons_write>:
	return 1;
}

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  80178a:	55                   	push   %ebp
  80178b:	89 e5                	mov    %esp,%ebp
  80178d:	57                   	push   %edi
  80178e:	56                   	push   %esi
  80178f:	53                   	push   %ebx
  801790:	81 ec 9c 00 00 00    	sub    $0x9c,%esp
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs, 
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  801796:	b8 00 00 00 00       	mov    $0x0,%eax
  80179b:	be 00 00 00 00       	mov    $0x0,%esi
  8017a0:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8017a4:	74 3f                	je     8017e5 <devcons_write+0x5b>
		m = n - tot;
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  8017a6:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs, 
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
		m = n - tot;
  8017ac:	8b 55 10             	mov    0x10(%ebp),%edx
  8017af:	29 c2                	sub    %eax,%edx
  8017b1:	89 d3                	mov    %edx,%ebx
		if (m > sizeof(buf) - 1)
  8017b3:	83 fa 7f             	cmp    $0x7f,%edx
  8017b6:	76 05                	jbe    8017bd <devcons_write+0x33>
  8017b8:	bb 7f 00 00 00       	mov    $0x7f,%ebx
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  8017bd:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8017c1:	03 45 0c             	add    0xc(%ebp),%eax
  8017c4:	89 44 24 04          	mov    %eax,0x4(%esp)
  8017c8:	89 3c 24             	mov    %edi,(%esp)
  8017cb:	e8 75 0a 00 00       	call   802245 <memmove>
		sys_cputs(buf, m);
  8017d0:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8017d4:	89 3c 24             	mov    %edi,(%esp)
  8017d7:	e8 14 e9 ff ff       	call   8000f0 <sys_cputs>
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs, 
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  8017dc:	01 de                	add    %ebx,%esi
  8017de:	89 f0                	mov    %esi,%eax
  8017e0:	3b 75 10             	cmp    0x10(%ebp),%esi
  8017e3:	72 c7                	jb     8017ac <devcons_write+0x22>
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
}
  8017e5:	89 f0                	mov    %esi,%eax
  8017e7:	81 c4 9c 00 00 00    	add    $0x9c,%esp
  8017ed:	5b                   	pop    %ebx
  8017ee:	5e                   	pop    %esi
  8017ef:	5f                   	pop    %edi
  8017f0:	5d                   	pop    %ebp
  8017f1:	c3                   	ret    

008017f2 <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  8017f2:	55                   	push   %ebp
  8017f3:	89 e5                	mov    %esp,%ebp
  8017f5:	83 ec 28             	sub    $0x28,%esp
	char c = ch;
  8017f8:	8b 45 08             	mov    0x8(%ebp),%eax
  8017fb:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  8017fe:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  801805:	00 
  801806:	8d 45 f7             	lea    -0x9(%ebp),%eax
  801809:	89 04 24             	mov    %eax,(%esp)
  80180c:	e8 df e8 ff ff       	call   8000f0 <sys_cputs>
}
  801811:	c9                   	leave  
  801812:	c3                   	ret    

00801813 <devcons_read>:
	return fd2num(fd);
}

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  801813:	55                   	push   %ebp
  801814:	89 e5                	mov    %esp,%ebp
  801816:	83 ec 08             	sub    $0x8,%esp
	int c;

	if (n == 0)
  801819:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80181d:	75 07                	jne    801826 <devcons_read+0x13>
  80181f:	eb 28                	jmp    801849 <devcons_read+0x36>
		return 0;

	while ((c = sys_cgetc()) == 0)
		sys_yield();
  801821:	e8 24 ed ff ff       	call   80054a <sys_yield>
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  801826:	66 90                	xchg   %ax,%ax
  801828:	e8 8f e8 ff ff       	call   8000bc <sys_cgetc>
  80182d:	85 c0                	test   %eax,%eax
  80182f:	90                   	nop
  801830:	74 ef                	je     801821 <devcons_read+0xe>
  801832:	89 c2                	mov    %eax,%edx
		sys_yield();
	if (c < 0)
  801834:	85 c0                	test   %eax,%eax
  801836:	78 16                	js     80184e <devcons_read+0x3b>
		return c;
	if (c == 0x04)	// ctl-d is eof
  801838:	83 f8 04             	cmp    $0x4,%eax
  80183b:	74 0c                	je     801849 <devcons_read+0x36>
		return 0;
	*(char*)vbuf = c;
  80183d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801840:	88 10                	mov    %dl,(%eax)
  801842:	b8 01 00 00 00       	mov    $0x1,%eax
	return 1;
  801847:	eb 05                	jmp    80184e <devcons_read+0x3b>
  801849:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80184e:	c9                   	leave  
  80184f:	c3                   	ret    

00801850 <opencons>:
	return fd->fd_dev_id == devcons.dev_id;
}

int
opencons(void)
{
  801850:	55                   	push   %ebp
  801851:	89 e5                	mov    %esp,%ebp
  801853:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  801856:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801859:	89 04 24             	mov    %eax,(%esp)
  80185c:	e8 da ed ff ff       	call   80063b <fd_alloc>
  801861:	85 c0                	test   %eax,%eax
  801863:	78 3f                	js     8018a4 <opencons+0x54>
		return r;
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  801865:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  80186c:	00 
  80186d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801870:	89 44 24 04          	mov    %eax,0x4(%esp)
  801874:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80187b:	e8 6b ec ff ff       	call   8004eb <sys_page_alloc>
  801880:	85 c0                	test   %eax,%eax
  801882:	78 20                	js     8018a4 <opencons+0x54>
		return r;
	fd->fd_dev_id = devcons.dev_id;
  801884:	8b 15 58 60 80 00    	mov    0x806058,%edx
  80188a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80188d:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  80188f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801892:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  801899:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80189c:	89 04 24             	mov    %eax,(%esp)
  80189f:	e8 6c ed ff ff       	call   800610 <fd2num>
}
  8018a4:	c9                   	leave  
  8018a5:	c3                   	ret    

008018a6 <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  8018a6:	55                   	push   %ebp
  8018a7:	89 e5                	mov    %esp,%ebp
  8018a9:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8018ac:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8018af:	89 44 24 04          	mov    %eax,0x4(%esp)
  8018b3:	8b 45 08             	mov    0x8(%ebp),%eax
  8018b6:	89 04 24             	mov    %eax,(%esp)
  8018b9:	e8 ef ed ff ff       	call   8006ad <fd_lookup>
  8018be:	85 c0                	test   %eax,%eax
  8018c0:	78 11                	js     8018d3 <iscons+0x2d>
		return r;
	return fd->fd_dev_id == devcons.dev_id;
  8018c2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8018c5:	8b 00                	mov    (%eax),%eax
  8018c7:	3b 05 58 60 80 00    	cmp    0x806058,%eax
  8018cd:	0f 94 c0             	sete   %al
  8018d0:	0f b6 c0             	movzbl %al,%eax
}
  8018d3:	c9                   	leave  
  8018d4:	c3                   	ret    

008018d5 <getchar>:
	sys_cputs(&c, 1);
}

int
getchar(void)
{
  8018d5:	55                   	push   %ebp
  8018d6:	89 e5                	mov    %esp,%ebp
  8018d8:	83 ec 28             	sub    $0x28,%esp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  8018db:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  8018e2:	00 
  8018e3:	8d 45 f7             	lea    -0x9(%ebp),%eax
  8018e6:	89 44 24 04          	mov    %eax,0x4(%esp)
  8018ea:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8018f1:	e8 18 f0 ff ff       	call   80090e <read>
	if (r < 0)
  8018f6:	85 c0                	test   %eax,%eax
  8018f8:	78 0f                	js     801909 <getchar+0x34>
		return r;
	if (r < 1)
  8018fa:	85 c0                	test   %eax,%eax
  8018fc:	7f 07                	jg     801905 <getchar+0x30>
  8018fe:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  801903:	eb 04                	jmp    801909 <getchar+0x34>
		return -E_EOF;
	return c;
  801905:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  801909:	c9                   	leave  
  80190a:	c3                   	ret    
	...

0080190c <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  80190c:	55                   	push   %ebp
  80190d:	89 e5                	mov    %esp,%ebp
  80190f:	53                   	push   %ebx
  801910:	83 ec 14             	sub    $0x14,%esp
 * Panic is called on unresolvable fatal errors.
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
  801913:	8d 5d 14             	lea    0x14(%ebp),%ebx
	va_list ap;

	va_start(ap, fmt);

	// Print the panic message
	if (argv0)
  801916:	a1 78 60 80 00       	mov    0x806078,%eax
  80191b:	85 c0                	test   %eax,%eax
  80191d:	74 10                	je     80192f <_panic+0x23>
		cprintf("%s: ", argv0);
  80191f:	89 44 24 04          	mov    %eax,0x4(%esp)
  801923:	c7 04 24 2d 29 80 00 	movl   $0x80292d,(%esp)
  80192a:	e8 a2 00 00 00       	call   8019d1 <cprintf>
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  80192f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801932:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801936:	8b 45 08             	mov    0x8(%ebp),%eax
  801939:	89 44 24 08          	mov    %eax,0x8(%esp)
  80193d:	a1 00 60 80 00       	mov    0x806000,%eax
  801942:	89 44 24 04          	mov    %eax,0x4(%esp)
  801946:	c7 04 24 32 29 80 00 	movl   $0x802932,(%esp)
  80194d:	e8 7f 00 00 00       	call   8019d1 <cprintf>
	vcprintf(fmt, ap);
  801952:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801956:	8b 45 10             	mov    0x10(%ebp),%eax
  801959:	89 04 24             	mov    %eax,(%esp)
  80195c:	e8 0f 00 00 00       	call   801970 <vcprintf>
	cprintf("\n");
  801961:	c7 04 24 1a 29 80 00 	movl   $0x80291a,(%esp)
  801968:	e8 64 00 00 00       	call   8019d1 <cprintf>

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  80196d:	cc                   	int3   
  80196e:	eb fd                	jmp    80196d <_panic+0x61>

00801970 <vcprintf>:
	b->cnt++;
}

int
vcprintf(const char *fmt, va_list ap)
{
  801970:	55                   	push   %ebp
  801971:	89 e5                	mov    %esp,%ebp
  801973:	81 ec 28 01 00 00    	sub    $0x128,%esp
	struct printbuf b;

	b.idx = 0;
  801979:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  801980:	00 00 00 
	b.cnt = 0;
  801983:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  80198a:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  80198d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801990:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801994:	8b 45 08             	mov    0x8(%ebp),%eax
  801997:	89 44 24 08          	mov    %eax,0x8(%esp)
  80199b:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8019a1:	89 44 24 04          	mov    %eax,0x4(%esp)
  8019a5:	c7 04 24 eb 19 80 00 	movl   $0x8019eb,(%esp)
  8019ac:	e8 cc 01 00 00       	call   801b7d <vprintfmt>
	sys_cputs(b.buf, b.idx);
  8019b1:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
  8019b7:	89 44 24 04          	mov    %eax,0x4(%esp)
  8019bb:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  8019c1:	89 04 24             	mov    %eax,(%esp)
  8019c4:	e8 27 e7 ff ff       	call   8000f0 <sys_cputs>

	return b.cnt;
}
  8019c9:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  8019cf:	c9                   	leave  
  8019d0:	c3                   	ret    

008019d1 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  8019d1:	55                   	push   %ebp
  8019d2:	89 e5                	mov    %esp,%ebp
  8019d4:	83 ec 18             	sub    $0x18,%esp

	return b.cnt;
}

int
cprintf(const char *fmt, ...)
  8019d7:	8d 45 0c             	lea    0xc(%ebp),%eax
{
	va_list ap;
	int cnt;

	va_start(ap, fmt);
	cnt = vcprintf(fmt, ap);
  8019da:	89 44 24 04          	mov    %eax,0x4(%esp)
  8019de:	8b 45 08             	mov    0x8(%ebp),%eax
  8019e1:	89 04 24             	mov    %eax,(%esp)
  8019e4:	e8 87 ff ff ff       	call   801970 <vcprintf>
	va_end(ap);

	return cnt;
}
  8019e9:	c9                   	leave  
  8019ea:	c3                   	ret    

008019eb <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  8019eb:	55                   	push   %ebp
  8019ec:	89 e5                	mov    %esp,%ebp
  8019ee:	53                   	push   %ebx
  8019ef:	83 ec 14             	sub    $0x14,%esp
  8019f2:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  8019f5:	8b 03                	mov    (%ebx),%eax
  8019f7:	8b 55 08             	mov    0x8(%ebp),%edx
  8019fa:	88 54 03 08          	mov    %dl,0x8(%ebx,%eax,1)
  8019fe:	83 c0 01             	add    $0x1,%eax
  801a01:	89 03                	mov    %eax,(%ebx)
	if (b->idx == 256-1) {
  801a03:	3d ff 00 00 00       	cmp    $0xff,%eax
  801a08:	75 19                	jne    801a23 <putch+0x38>
		sys_cputs(b->buf, b->idx);
  801a0a:	c7 44 24 04 ff 00 00 	movl   $0xff,0x4(%esp)
  801a11:	00 
  801a12:	8d 43 08             	lea    0x8(%ebx),%eax
  801a15:	89 04 24             	mov    %eax,(%esp)
  801a18:	e8 d3 e6 ff ff       	call   8000f0 <sys_cputs>
		b->idx = 0;
  801a1d:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
	}
	b->cnt++;
  801a23:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  801a27:	83 c4 14             	add    $0x14,%esp
  801a2a:	5b                   	pop    %ebx
  801a2b:	5d                   	pop    %ebp
  801a2c:	c3                   	ret    
  801a2d:	00 00                	add    %al,(%eax)
	...

00801a30 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  801a30:	55                   	push   %ebp
  801a31:	89 e5                	mov    %esp,%ebp
  801a33:	57                   	push   %edi
  801a34:	56                   	push   %esi
  801a35:	53                   	push   %ebx
  801a36:	83 ec 4c             	sub    $0x4c,%esp
  801a39:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801a3c:	89 d6                	mov    %edx,%esi
  801a3e:	8b 45 08             	mov    0x8(%ebp),%eax
  801a41:	89 45 d8             	mov    %eax,-0x28(%ebp)
  801a44:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a47:	89 55 e0             	mov    %edx,-0x20(%ebp)
  801a4a:	8b 45 10             	mov    0x10(%ebp),%eax
  801a4d:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801a50:	8b 7d 18             	mov    0x18(%ebp),%edi
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  801a53:	89 45 dc             	mov    %eax,-0x24(%ebp)
  801a56:	b9 00 00 00 00       	mov    $0x0,%ecx
  801a5b:	39 d1                	cmp    %edx,%ecx
  801a5d:	72 15                	jb     801a74 <printnum+0x44>
  801a5f:	77 07                	ja     801a68 <printnum+0x38>
  801a61:	8b 55 d8             	mov    -0x28(%ebp),%edx
  801a64:	39 d0                	cmp    %edx,%eax
  801a66:	76 0c                	jbe    801a74 <printnum+0x44>
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  801a68:	83 eb 01             	sub    $0x1,%ebx
  801a6b:	85 db                	test   %ebx,%ebx
  801a6d:	8d 76 00             	lea    0x0(%esi),%esi
  801a70:	7f 61                	jg     801ad3 <printnum+0xa3>
  801a72:	eb 70                	jmp    801ae4 <printnum+0xb4>
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
  801a74:	89 7c 24 10          	mov    %edi,0x10(%esp)
  801a78:	83 eb 01             	sub    $0x1,%ebx
  801a7b:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  801a7f:	89 44 24 08          	mov    %eax,0x8(%esp)
  801a83:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  801a87:	8b 5c 24 0c          	mov    0xc(%esp),%ebx
  801a8b:	89 4d d0             	mov    %ecx,-0x30(%ebp)
  801a8e:	89 5d d4             	mov    %ebx,-0x2c(%ebp)
  801a91:	8b 5d dc             	mov    -0x24(%ebp),%ebx
  801a94:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801a98:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  801a9f:	00 
  801aa0:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801aa3:	89 04 24             	mov    %eax,(%esp)
  801aa6:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801aa9:	89 54 24 04          	mov    %edx,0x4(%esp)
  801aad:	e8 be 0a 00 00       	call   802570 <__udivdi3>
  801ab2:	8b 4d d0             	mov    -0x30(%ebp),%ecx
  801ab5:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
  801ab8:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801abc:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  801ac0:	89 04 24             	mov    %eax,(%esp)
  801ac3:	89 54 24 04          	mov    %edx,0x4(%esp)
  801ac7:	89 f2                	mov    %esi,%edx
  801ac9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801acc:	e8 5f ff ff ff       	call   801a30 <printnum>
  801ad1:	eb 11                	jmp    801ae4 <printnum+0xb4>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  801ad3:	89 74 24 04          	mov    %esi,0x4(%esp)
  801ad7:	89 3c 24             	mov    %edi,(%esp)
  801ada:	ff 55 e4             	call   *-0x1c(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  801add:	83 eb 01             	sub    $0x1,%ebx
  801ae0:	85 db                	test   %ebx,%ebx
  801ae2:	7f ef                	jg     801ad3 <printnum+0xa3>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  801ae4:	89 74 24 04          	mov    %esi,0x4(%esp)
  801ae8:	8b 74 24 04          	mov    0x4(%esp),%esi
  801aec:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801aef:	89 44 24 08          	mov    %eax,0x8(%esp)
  801af3:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  801afa:	00 
  801afb:	8b 55 d8             	mov    -0x28(%ebp),%edx
  801afe:	89 14 24             	mov    %edx,(%esp)
  801b01:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  801b04:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801b08:	e8 93 0b 00 00       	call   8026a0 <__umoddi3>
  801b0d:	89 74 24 04          	mov    %esi,0x4(%esp)
  801b11:	0f be 80 4e 29 80 00 	movsbl 0x80294e(%eax),%eax
  801b18:	89 04 24             	mov    %eax,(%esp)
  801b1b:	ff 55 e4             	call   *-0x1c(%ebp)
}
  801b1e:	83 c4 4c             	add    $0x4c,%esp
  801b21:	5b                   	pop    %ebx
  801b22:	5e                   	pop    %esi
  801b23:	5f                   	pop    %edi
  801b24:	5d                   	pop    %ebp
  801b25:	c3                   	ret    

00801b26 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  801b26:	55                   	push   %ebp
  801b27:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  801b29:	83 fa 01             	cmp    $0x1,%edx
  801b2c:	7e 0e                	jle    801b3c <getuint+0x16>
		return va_arg(*ap, unsigned long long);
  801b2e:	8b 10                	mov    (%eax),%edx
  801b30:	8d 4a 08             	lea    0x8(%edx),%ecx
  801b33:	89 08                	mov    %ecx,(%eax)
  801b35:	8b 02                	mov    (%edx),%eax
  801b37:	8b 52 04             	mov    0x4(%edx),%edx
  801b3a:	eb 22                	jmp    801b5e <getuint+0x38>
	else if (lflag)
  801b3c:	85 d2                	test   %edx,%edx
  801b3e:	74 10                	je     801b50 <getuint+0x2a>
		return va_arg(*ap, unsigned long);
  801b40:	8b 10                	mov    (%eax),%edx
  801b42:	8d 4a 04             	lea    0x4(%edx),%ecx
  801b45:	89 08                	mov    %ecx,(%eax)
  801b47:	8b 02                	mov    (%edx),%eax
  801b49:	ba 00 00 00 00       	mov    $0x0,%edx
  801b4e:	eb 0e                	jmp    801b5e <getuint+0x38>
	else
		return va_arg(*ap, unsigned int);
  801b50:	8b 10                	mov    (%eax),%edx
  801b52:	8d 4a 04             	lea    0x4(%edx),%ecx
  801b55:	89 08                	mov    %ecx,(%eax)
  801b57:	8b 02                	mov    (%edx),%eax
  801b59:	ba 00 00 00 00       	mov    $0x0,%edx
}
  801b5e:	5d                   	pop    %ebp
  801b5f:	c3                   	ret    

00801b60 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  801b60:	55                   	push   %ebp
  801b61:	89 e5                	mov    %esp,%ebp
  801b63:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  801b66:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  801b6a:	8b 10                	mov    (%eax),%edx
  801b6c:	3b 50 04             	cmp    0x4(%eax),%edx
  801b6f:	73 0a                	jae    801b7b <sprintputch+0x1b>
		*b->buf++ = ch;
  801b71:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801b74:	88 0a                	mov    %cl,(%edx)
  801b76:	83 c2 01             	add    $0x1,%edx
  801b79:	89 10                	mov    %edx,(%eax)
}
  801b7b:	5d                   	pop    %ebp
  801b7c:	c3                   	ret    

00801b7d <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  801b7d:	55                   	push   %ebp
  801b7e:	89 e5                	mov    %esp,%ebp
  801b80:	57                   	push   %edi
  801b81:	56                   	push   %esi
  801b82:	53                   	push   %ebx
  801b83:	83 ec 5c             	sub    $0x5c,%esp
  801b86:	8b 7d 08             	mov    0x8(%ebp),%edi
  801b89:	8b 75 0c             	mov    0xc(%ebp),%esi
  801b8c:	8b 5d 10             	mov    0x10(%ebp),%ebx
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  801b8f:	c7 45 c8 ff ff ff ff 	movl   $0xffffffff,-0x38(%ebp)
  801b96:	eb 11                	jmp    801ba9 <vprintfmt+0x2c>
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
  801b98:	85 c0                	test   %eax,%eax
  801b9a:	0f 84 ec 03 00 00    	je     801f8c <vprintfmt+0x40f>
				return;
			putch(ch, putdat);
  801ba0:	89 74 24 04          	mov    %esi,0x4(%esp)
  801ba4:	89 04 24             	mov    %eax,(%esp)
  801ba7:	ff d7                	call   *%edi
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  801ba9:	0f b6 03             	movzbl (%ebx),%eax
  801bac:	83 c3 01             	add    $0x1,%ebx
  801baf:	83 f8 25             	cmp    $0x25,%eax
  801bb2:	75 e4                	jne    801b98 <vprintfmt+0x1b>
  801bb4:	c6 45 d4 20          	movb   $0x20,-0x2c(%ebp)
  801bb8:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
  801bbf:	c7 45 d0 ff ff ff ff 	movl   $0xffffffff,-0x30(%ebp)
  801bc6:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
  801bcd:	b9 00 00 00 00       	mov    $0x0,%ecx
  801bd2:	eb 06                	jmp    801bda <vprintfmt+0x5d>
  801bd4:	c6 45 d4 2d          	movb   $0x2d,-0x2c(%ebp)
  801bd8:	89 c3                	mov    %eax,%ebx
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  801bda:	0f b6 13             	movzbl (%ebx),%edx
  801bdd:	0f b6 c2             	movzbl %dl,%eax
  801be0:	89 45 e0             	mov    %eax,-0x20(%ebp)
  801be3:	8d 43 01             	lea    0x1(%ebx),%eax
  801be6:	83 ea 23             	sub    $0x23,%edx
  801be9:	80 fa 55             	cmp    $0x55,%dl
  801bec:	0f 87 7d 03 00 00    	ja     801f6f <vprintfmt+0x3f2>
  801bf2:	0f b6 d2             	movzbl %dl,%edx
  801bf5:	ff 24 95 a0 2a 80 00 	jmp    *0x802aa0(,%edx,4)
  801bfc:	c6 45 d4 30          	movb   $0x30,-0x2c(%ebp)
  801c00:	eb d6                	jmp    801bd8 <vprintfmt+0x5b>
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
				precision = precision * 10 + ch - '0';
  801c02:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801c05:	83 ea 30             	sub    $0x30,%edx
  801c08:	89 55 d0             	mov    %edx,-0x30(%ebp)
				ch = *fmt;
  801c0b:	0f be 10             	movsbl (%eax),%edx
				if (ch < '0' || ch > '9')
  801c0e:	8d 5a d0             	lea    -0x30(%edx),%ebx
  801c11:	83 fb 09             	cmp    $0x9,%ebx
  801c14:	77 4c                	ja     801c62 <vprintfmt+0xe5>
  801c16:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  801c19:	8b 4d d0             	mov    -0x30(%ebp),%ecx
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  801c1c:	83 c0 01             	add    $0x1,%eax
				precision = precision * 10 + ch - '0';
  801c1f:	8d 0c 89             	lea    (%ecx,%ecx,4),%ecx
  801c22:	8d 4c 4a d0          	lea    -0x30(%edx,%ecx,2),%ecx
				ch = *fmt;
  801c26:	0f be 10             	movsbl (%eax),%edx
				if (ch < '0' || ch > '9')
  801c29:	8d 5a d0             	lea    -0x30(%edx),%ebx
  801c2c:	83 fb 09             	cmp    $0x9,%ebx
  801c2f:	76 eb                	jbe    801c1c <vprintfmt+0x9f>
  801c31:	89 4d d0             	mov    %ecx,-0x30(%ebp)
  801c34:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  801c37:	eb 29                	jmp    801c62 <vprintfmt+0xe5>
					break;
			}
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  801c39:	8b 55 14             	mov    0x14(%ebp),%edx
  801c3c:	8d 5a 04             	lea    0x4(%edx),%ebx
  801c3f:	89 5d 14             	mov    %ebx,0x14(%ebp)
  801c42:	8b 12                	mov    (%edx),%edx
  801c44:	89 55 d0             	mov    %edx,-0x30(%ebp)
			goto process_precision;
  801c47:	eb 19                	jmp    801c62 <vprintfmt+0xe5>

		case '.':
			if (width < 0)
  801c49:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801c4c:	c1 fa 1f             	sar    $0x1f,%edx
  801c4f:	f7 d2                	not    %edx
  801c51:	21 55 e4             	and    %edx,-0x1c(%ebp)
  801c54:	eb 82                	jmp    801bd8 <vprintfmt+0x5b>
  801c56:	c7 45 d8 01 00 00 00 	movl   $0x1,-0x28(%ebp)
				width = 0;
			goto reswitch;

		case '#':
			altflag = 1;
			goto reswitch;
  801c5d:	e9 76 ff ff ff       	jmp    801bd8 <vprintfmt+0x5b>

		process_precision:
			if (width < 0)
  801c62:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801c66:	0f 89 6c ff ff ff    	jns    801bd8 <vprintfmt+0x5b>
  801c6c:	8b 55 d0             	mov    -0x30(%ebp),%edx
  801c6f:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  801c72:	8b 55 c8             	mov    -0x38(%ebp),%edx
  801c75:	89 55 d0             	mov    %edx,-0x30(%ebp)
  801c78:	e9 5b ff ff ff       	jmp    801bd8 <vprintfmt+0x5b>
				width = precision, precision = -1;
			goto reswitch;

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  801c7d:	83 c1 01             	add    $0x1,%ecx
			goto reswitch;
  801c80:	e9 53 ff ff ff       	jmp    801bd8 <vprintfmt+0x5b>
  801c85:	89 45 cc             	mov    %eax,-0x34(%ebp)

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  801c88:	8b 45 14             	mov    0x14(%ebp),%eax
  801c8b:	8d 50 04             	lea    0x4(%eax),%edx
  801c8e:	89 55 14             	mov    %edx,0x14(%ebp)
  801c91:	89 74 24 04          	mov    %esi,0x4(%esp)
  801c95:	8b 00                	mov    (%eax),%eax
  801c97:	89 04 24             	mov    %eax,(%esp)
  801c9a:	ff d7                	call   *%edi
  801c9c:	8b 5d cc             	mov    -0x34(%ebp),%ebx
			break;
  801c9f:	e9 05 ff ff ff       	jmp    801ba9 <vprintfmt+0x2c>
  801ca4:	89 45 cc             	mov    %eax,-0x34(%ebp)

		// error message
		case 'e':
			err = va_arg(ap, int);
  801ca7:	8b 45 14             	mov    0x14(%ebp),%eax
  801caa:	8d 50 04             	lea    0x4(%eax),%edx
  801cad:	89 55 14             	mov    %edx,0x14(%ebp)
  801cb0:	8b 00                	mov    (%eax),%eax
  801cb2:	89 c2                	mov    %eax,%edx
  801cb4:	c1 fa 1f             	sar    $0x1f,%edx
  801cb7:	31 d0                	xor    %edx,%eax
  801cb9:	29 d0                	sub    %edx,%eax
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  801cbb:	83 f8 0f             	cmp    $0xf,%eax
  801cbe:	7f 0b                	jg     801ccb <vprintfmt+0x14e>
  801cc0:	8b 14 85 00 2c 80 00 	mov    0x802c00(,%eax,4),%edx
  801cc7:	85 d2                	test   %edx,%edx
  801cc9:	75 20                	jne    801ceb <vprintfmt+0x16e>
				printfmt(putch, putdat, "error %d", err);
  801ccb:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801ccf:	c7 44 24 08 5f 29 80 	movl   $0x80295f,0x8(%esp)
  801cd6:	00 
  801cd7:	89 74 24 04          	mov    %esi,0x4(%esp)
  801cdb:	89 3c 24             	mov    %edi,(%esp)
  801cde:	e8 31 03 00 00       	call   802014 <printfmt>
  801ce3:	8b 5d cc             	mov    -0x34(%ebp),%ebx
		// error message
		case 'e':
			err = va_arg(ap, int);
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  801ce6:	e9 be fe ff ff       	jmp    801ba9 <vprintfmt+0x2c>
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  801ceb:	89 54 24 0c          	mov    %edx,0xc(%esp)
  801cef:	c7 44 24 08 de 28 80 	movl   $0x8028de,0x8(%esp)
  801cf6:	00 
  801cf7:	89 74 24 04          	mov    %esi,0x4(%esp)
  801cfb:	89 3c 24             	mov    %edi,(%esp)
  801cfe:	e8 11 03 00 00       	call   802014 <printfmt>
  801d03:	8b 5d cc             	mov    -0x34(%ebp),%ebx
  801d06:	e9 9e fe ff ff       	jmp    801ba9 <vprintfmt+0x2c>
  801d0b:	89 45 cc             	mov    %eax,-0x34(%ebp)
  801d0e:	89 c3                	mov    %eax,%ebx
  801d10:	8b 4d d0             	mov    -0x30(%ebp),%ecx
  801d13:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801d16:	89 45 c4             	mov    %eax,-0x3c(%ebp)
			break;

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  801d19:	8b 45 14             	mov    0x14(%ebp),%eax
  801d1c:	8d 50 04             	lea    0x4(%eax),%edx
  801d1f:	89 55 14             	mov    %edx,0x14(%ebp)
  801d22:	8b 00                	mov    (%eax),%eax
  801d24:	89 45 e0             	mov    %eax,-0x20(%ebp)
  801d27:	85 c0                	test   %eax,%eax
  801d29:	75 07                	jne    801d32 <vprintfmt+0x1b5>
  801d2b:	c7 45 e0 68 29 80 00 	movl   $0x802968,-0x20(%ebp)
				p = "(null)";
			if (width > 0 && padc != '-')
  801d32:	83 7d c4 00          	cmpl   $0x0,-0x3c(%ebp)
  801d36:	7e 06                	jle    801d3e <vprintfmt+0x1c1>
  801d38:	80 7d d4 2d          	cmpb   $0x2d,-0x2c(%ebp)
  801d3c:	75 13                	jne    801d51 <vprintfmt+0x1d4>
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  801d3e:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801d41:	0f be 02             	movsbl (%edx),%eax
  801d44:	85 c0                	test   %eax,%eax
  801d46:	0f 85 99 00 00 00    	jne    801de5 <vprintfmt+0x268>
  801d4c:	e9 86 00 00 00       	jmp    801dd7 <vprintfmt+0x25a>
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  801d51:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801d55:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  801d58:	89 0c 24             	mov    %ecx,(%esp)
  801d5b:	e8 fb 02 00 00       	call   80205b <strnlen>
  801d60:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  801d63:	29 c2                	sub    %eax,%edx
  801d65:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  801d68:	85 d2                	test   %edx,%edx
  801d6a:	7e d2                	jle    801d3e <vprintfmt+0x1c1>
					putch(padc, putdat);
  801d6c:	0f be 4d d4          	movsbl -0x2c(%ebp),%ecx
  801d70:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  801d73:	89 5d c4             	mov    %ebx,-0x3c(%ebp)
  801d76:	89 d3                	mov    %edx,%ebx
  801d78:	89 74 24 04          	mov    %esi,0x4(%esp)
  801d7c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801d7f:	89 04 24             	mov    %eax,(%esp)
  801d82:	ff d7                	call   *%edi
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  801d84:	83 eb 01             	sub    $0x1,%ebx
  801d87:	85 db                	test   %ebx,%ebx
  801d89:	7f ed                	jg     801d78 <vprintfmt+0x1fb>
  801d8b:	8b 5d c4             	mov    -0x3c(%ebp),%ebx
  801d8e:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  801d95:	eb a7                	jmp    801d3e <vprintfmt+0x1c1>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
  801d97:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  801d9b:	74 18                	je     801db5 <vprintfmt+0x238>
  801d9d:	8d 50 e0             	lea    -0x20(%eax),%edx
  801da0:	83 fa 5e             	cmp    $0x5e,%edx
  801da3:	76 10                	jbe    801db5 <vprintfmt+0x238>
					putch('?', putdat);
  801da5:	89 7c 24 04          	mov    %edi,0x4(%esp)
  801da9:	c7 04 24 3f 00 00 00 	movl   $0x3f,(%esp)
  801db0:	ff 55 e0             	call   *-0x20(%ebp)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
  801db3:	eb 0a                	jmp    801dbf <vprintfmt+0x242>
					putch('?', putdat);
				else
					putch(ch, putdat);
  801db5:	89 7c 24 04          	mov    %edi,0x4(%esp)
  801db9:	89 04 24             	mov    %eax,(%esp)
  801dbc:	ff 55 e0             	call   *-0x20(%ebp)
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  801dbf:	83 6d e4 01          	subl   $0x1,-0x1c(%ebp)
  801dc3:	0f be 03             	movsbl (%ebx),%eax
  801dc6:	85 c0                	test   %eax,%eax
  801dc8:	74 05                	je     801dcf <vprintfmt+0x252>
  801dca:	83 c3 01             	add    $0x1,%ebx
  801dcd:	eb 29                	jmp    801df8 <vprintfmt+0x27b>
  801dcf:	89 fe                	mov    %edi,%esi
  801dd1:	8b 7d e0             	mov    -0x20(%ebp),%edi
  801dd4:	8b 5d d0             	mov    -0x30(%ebp),%ebx
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  801dd7:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801ddb:	7f 2e                	jg     801e0b <vprintfmt+0x28e>
  801ddd:	8b 5d cc             	mov    -0x34(%ebp),%ebx
  801de0:	e9 c4 fd ff ff       	jmp    801ba9 <vprintfmt+0x2c>
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  801de5:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801de8:	83 c2 01             	add    $0x1,%edx
  801deb:	89 7d e0             	mov    %edi,-0x20(%ebp)
  801dee:	89 f7                	mov    %esi,%edi
  801df0:	8b 75 d0             	mov    -0x30(%ebp),%esi
  801df3:	89 5d d0             	mov    %ebx,-0x30(%ebp)
  801df6:	89 d3                	mov    %edx,%ebx
  801df8:	85 f6                	test   %esi,%esi
  801dfa:	78 9b                	js     801d97 <vprintfmt+0x21a>
  801dfc:	83 ee 01             	sub    $0x1,%esi
  801dff:	79 96                	jns    801d97 <vprintfmt+0x21a>
  801e01:	89 fe                	mov    %edi,%esi
  801e03:	8b 7d e0             	mov    -0x20(%ebp),%edi
  801e06:	8b 5d d0             	mov    -0x30(%ebp),%ebx
  801e09:	eb cc                	jmp    801dd7 <vprintfmt+0x25a>
  801e0b:	89 5d d8             	mov    %ebx,-0x28(%ebp)
  801e0e:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
				putch(' ', putdat);
  801e11:	89 74 24 04          	mov    %esi,0x4(%esp)
  801e15:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  801e1c:	ff d7                	call   *%edi
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  801e1e:	83 eb 01             	sub    $0x1,%ebx
  801e21:	85 db                	test   %ebx,%ebx
  801e23:	7f ec                	jg     801e11 <vprintfmt+0x294>
  801e25:	8b 5d d8             	mov    -0x28(%ebp),%ebx
  801e28:	e9 7c fd ff ff       	jmp    801ba9 <vprintfmt+0x2c>
  801e2d:	89 45 cc             	mov    %eax,-0x34(%ebp)
// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
	if (lflag >= 2)
  801e30:	83 f9 01             	cmp    $0x1,%ecx
  801e33:	7e 16                	jle    801e4b <vprintfmt+0x2ce>
		return va_arg(*ap, long long);
  801e35:	8b 45 14             	mov    0x14(%ebp),%eax
  801e38:	8d 50 08             	lea    0x8(%eax),%edx
  801e3b:	89 55 14             	mov    %edx,0x14(%ebp)
  801e3e:	8b 10                	mov    (%eax),%edx
  801e40:	8b 48 04             	mov    0x4(%eax),%ecx
  801e43:	89 55 d8             	mov    %edx,-0x28(%ebp)
  801e46:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  801e49:	eb 32                	jmp    801e7d <vprintfmt+0x300>
	else if (lflag)
  801e4b:	85 c9                	test   %ecx,%ecx
  801e4d:	74 18                	je     801e67 <vprintfmt+0x2ea>
		return va_arg(*ap, long);
  801e4f:	8b 45 14             	mov    0x14(%ebp),%eax
  801e52:	8d 50 04             	lea    0x4(%eax),%edx
  801e55:	89 55 14             	mov    %edx,0x14(%ebp)
  801e58:	8b 00                	mov    (%eax),%eax
  801e5a:	89 45 d8             	mov    %eax,-0x28(%ebp)
  801e5d:	89 c1                	mov    %eax,%ecx
  801e5f:	c1 f9 1f             	sar    $0x1f,%ecx
  801e62:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  801e65:	eb 16                	jmp    801e7d <vprintfmt+0x300>
	else
		return va_arg(*ap, int);
  801e67:	8b 45 14             	mov    0x14(%ebp),%eax
  801e6a:	8d 50 04             	lea    0x4(%eax),%edx
  801e6d:	89 55 14             	mov    %edx,0x14(%ebp)
  801e70:	8b 00                	mov    (%eax),%eax
  801e72:	89 45 d8             	mov    %eax,-0x28(%ebp)
  801e75:	89 c2                	mov    %eax,%edx
  801e77:	c1 fa 1f             	sar    $0x1f,%edx
  801e7a:	89 55 dc             	mov    %edx,-0x24(%ebp)
				putch(' ', putdat);
			break;

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  801e7d:	8b 4d d8             	mov    -0x28(%ebp),%ecx
  801e80:	8b 5d dc             	mov    -0x24(%ebp),%ebx
  801e83:	b8 0a 00 00 00       	mov    $0xa,%eax
			if ((long long) num < 0) {
  801e88:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  801e8c:	0f 89 9b 00 00 00    	jns    801f2d <vprintfmt+0x3b0>
				putch('-', putdat);
  801e92:	89 74 24 04          	mov    %esi,0x4(%esp)
  801e96:	c7 04 24 2d 00 00 00 	movl   $0x2d,(%esp)
  801e9d:	ff d7                	call   *%edi
				num = -(long long) num;
  801e9f:	8b 4d d8             	mov    -0x28(%ebp),%ecx
  801ea2:	8b 5d dc             	mov    -0x24(%ebp),%ebx
  801ea5:	f7 d9                	neg    %ecx
  801ea7:	83 d3 00             	adc    $0x0,%ebx
  801eaa:	f7 db                	neg    %ebx
  801eac:	b8 0a 00 00 00       	mov    $0xa,%eax
  801eb1:	eb 7a                	jmp    801f2d <vprintfmt+0x3b0>
  801eb3:	89 45 cc             	mov    %eax,-0x34(%ebp)
			base = 10;
			goto number;

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  801eb6:	89 ca                	mov    %ecx,%edx
  801eb8:	8d 45 14             	lea    0x14(%ebp),%eax
  801ebb:	e8 66 fc ff ff       	call   801b26 <getuint>
  801ec0:	89 c1                	mov    %eax,%ecx
  801ec2:	89 d3                	mov    %edx,%ebx
  801ec4:	b8 0a 00 00 00       	mov    $0xa,%eax
			base = 10;
			goto number;
  801ec9:	eb 62                	jmp    801f2d <vprintfmt+0x3b0>
  801ecb:	89 45 cc             	mov    %eax,-0x34(%ebp)
		case 'o':
			// Replace this with your code.
			// putch('X', putdat);
			// putch('X', putdat);
			// putch('X', putdat);
			num = getuint(&ap, lflag);
  801ece:	89 ca                	mov    %ecx,%edx
  801ed0:	8d 45 14             	lea    0x14(%ebp),%eax
  801ed3:	e8 4e fc ff ff       	call   801b26 <getuint>
  801ed8:	89 c1                	mov    %eax,%ecx
  801eda:	89 d3                	mov    %edx,%ebx
  801edc:	b8 08 00 00 00       	mov    $0x8,%eax
			base = 8;
			goto number;
  801ee1:	eb 4a                	jmp    801f2d <vprintfmt+0x3b0>
  801ee3:	89 45 cc             	mov    %eax,-0x34(%ebp)
			break;

		// pointer
		case 'p':
			putch('0', putdat);
  801ee6:	89 74 24 04          	mov    %esi,0x4(%esp)
  801eea:	c7 04 24 30 00 00 00 	movl   $0x30,(%esp)
  801ef1:	ff d7                	call   *%edi
			putch('x', putdat);
  801ef3:	89 74 24 04          	mov    %esi,0x4(%esp)
  801ef7:	c7 04 24 78 00 00 00 	movl   $0x78,(%esp)
  801efe:	ff d7                	call   *%edi
			num = (unsigned long long)
  801f00:	8b 45 14             	mov    0x14(%ebp),%eax
  801f03:	8d 50 04             	lea    0x4(%eax),%edx
  801f06:	89 55 14             	mov    %edx,0x14(%ebp)
  801f09:	8b 08                	mov    (%eax),%ecx
  801f0b:	bb 00 00 00 00       	mov    $0x0,%ebx
  801f10:	b8 10 00 00 00       	mov    $0x10,%eax
				(uintptr_t) va_arg(ap, void *);
			base = 16;
			goto number;
  801f15:	eb 16                	jmp    801f2d <vprintfmt+0x3b0>
  801f17:	89 45 cc             	mov    %eax,-0x34(%ebp)

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  801f1a:	89 ca                	mov    %ecx,%edx
  801f1c:	8d 45 14             	lea    0x14(%ebp),%eax
  801f1f:	e8 02 fc ff ff       	call   801b26 <getuint>
  801f24:	89 c1                	mov    %eax,%ecx
  801f26:	89 d3                	mov    %edx,%ebx
  801f28:	b8 10 00 00 00       	mov    $0x10,%eax
			base = 16;
		number:
			printnum(putch, putdat, num, base, width, padc);
  801f2d:	0f be 55 d4          	movsbl -0x2c(%ebp),%edx
  801f31:	89 54 24 10          	mov    %edx,0x10(%esp)
  801f35:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801f38:	89 54 24 0c          	mov    %edx,0xc(%esp)
  801f3c:	89 44 24 08          	mov    %eax,0x8(%esp)
  801f40:	89 0c 24             	mov    %ecx,(%esp)
  801f43:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801f47:	89 f2                	mov    %esi,%edx
  801f49:	89 f8                	mov    %edi,%eax
  801f4b:	e8 e0 fa ff ff       	call   801a30 <printnum>
  801f50:	8b 5d cc             	mov    -0x34(%ebp),%ebx
			break;
  801f53:	e9 51 fc ff ff       	jmp    801ba9 <vprintfmt+0x2c>
  801f58:	89 45 cc             	mov    %eax,-0x34(%ebp)
  801f5b:	8b 55 e0             	mov    -0x20(%ebp),%edx

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  801f5e:	89 74 24 04          	mov    %esi,0x4(%esp)
  801f62:	89 14 24             	mov    %edx,(%esp)
  801f65:	ff d7                	call   *%edi
  801f67:	8b 5d cc             	mov    -0x34(%ebp),%ebx
			break;
  801f6a:	e9 3a fc ff ff       	jmp    801ba9 <vprintfmt+0x2c>
			
		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  801f6f:	89 74 24 04          	mov    %esi,0x4(%esp)
  801f73:	c7 04 24 25 00 00 00 	movl   $0x25,(%esp)
  801f7a:	ff d7                	call   *%edi
			for (fmt--; fmt[-1] != '%'; fmt--)
  801f7c:	8d 43 ff             	lea    -0x1(%ebx),%eax
  801f7f:	80 38 25             	cmpb   $0x25,(%eax)
  801f82:	0f 84 21 fc ff ff    	je     801ba9 <vprintfmt+0x2c>
  801f88:	89 c3                	mov    %eax,%ebx
  801f8a:	eb f0                	jmp    801f7c <vprintfmt+0x3ff>
				/* do nothing */;
			break;
		}
	}
}
  801f8c:	83 c4 5c             	add    $0x5c,%esp
  801f8f:	5b                   	pop    %ebx
  801f90:	5e                   	pop    %esi
  801f91:	5f                   	pop    %edi
  801f92:	5d                   	pop    %ebp
  801f93:	c3                   	ret    

00801f94 <vsnprintf>:
		*b->buf++ = ch;
}

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  801f94:	55                   	push   %ebp
  801f95:	89 e5                	mov    %esp,%ebp
  801f97:	83 ec 28             	sub    $0x28,%esp
  801f9a:	8b 45 08             	mov    0x8(%ebp),%eax
  801f9d:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};

	if (buf == NULL || n < 1)
  801fa0:	85 c0                	test   %eax,%eax
  801fa2:	74 04                	je     801fa8 <vsnprintf+0x14>
  801fa4:	85 d2                	test   %edx,%edx
  801fa6:	7f 07                	jg     801faf <vsnprintf+0x1b>
  801fa8:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801fad:	eb 3b                	jmp    801fea <vsnprintf+0x56>
}

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
	struct sprintbuf b = {buf, buf+n-1, 0};
  801faf:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801fb2:	8d 44 10 ff          	lea    -0x1(%eax,%edx,1),%eax
  801fb6:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801fb9:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  801fc0:	8b 45 14             	mov    0x14(%ebp),%eax
  801fc3:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801fc7:	8b 45 10             	mov    0x10(%ebp),%eax
  801fca:	89 44 24 08          	mov    %eax,0x8(%esp)
  801fce:	8d 45 ec             	lea    -0x14(%ebp),%eax
  801fd1:	89 44 24 04          	mov    %eax,0x4(%esp)
  801fd5:	c7 04 24 60 1b 80 00 	movl   $0x801b60,(%esp)
  801fdc:	e8 9c fb ff ff       	call   801b7d <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  801fe1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801fe4:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  801fe7:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  801fea:	c9                   	leave  
  801feb:	c3                   	ret    

00801fec <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  801fec:	55                   	push   %ebp
  801fed:	89 e5                	mov    %esp,%ebp
  801fef:	83 ec 18             	sub    $0x18,%esp

	return b.cnt;
}

int
snprintf(char *buf, int n, const char *fmt, ...)
  801ff2:	8d 45 14             	lea    0x14(%ebp),%eax
{
	va_list ap;
	int rc;

	va_start(ap, fmt);
	rc = vsnprintf(buf, n, fmt, ap);
  801ff5:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801ff9:	8b 45 10             	mov    0x10(%ebp),%eax
  801ffc:	89 44 24 08          	mov    %eax,0x8(%esp)
  802000:	8b 45 0c             	mov    0xc(%ebp),%eax
  802003:	89 44 24 04          	mov    %eax,0x4(%esp)
  802007:	8b 45 08             	mov    0x8(%ebp),%eax
  80200a:	89 04 24             	mov    %eax,(%esp)
  80200d:	e8 82 ff ff ff       	call   801f94 <vsnprintf>
	va_end(ap);

	return rc;
}
  802012:	c9                   	leave  
  802013:	c3                   	ret    

00802014 <printfmt>:
	}
}

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  802014:	55                   	push   %ebp
  802015:	89 e5                	mov    %esp,%ebp
  802017:	83 ec 18             	sub    $0x18,%esp
		}
	}
}

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
  80201a:	8d 45 14             	lea    0x14(%ebp),%eax
{
	va_list ap;

	va_start(ap, fmt);
	vprintfmt(putch, putdat, fmt, ap);
  80201d:	89 44 24 0c          	mov    %eax,0xc(%esp)
  802021:	8b 45 10             	mov    0x10(%ebp),%eax
  802024:	89 44 24 08          	mov    %eax,0x8(%esp)
  802028:	8b 45 0c             	mov    0xc(%ebp),%eax
  80202b:	89 44 24 04          	mov    %eax,0x4(%esp)
  80202f:	8b 45 08             	mov    0x8(%ebp),%eax
  802032:	89 04 24             	mov    %eax,(%esp)
  802035:	e8 43 fb ff ff       	call   801b7d <vprintfmt>
	va_end(ap);
}
  80203a:	c9                   	leave  
  80203b:	c3                   	ret    
  80203c:	00 00                	add    %al,(%eax)
	...

00802040 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  802040:	55                   	push   %ebp
  802041:	89 e5                	mov    %esp,%ebp
  802043:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  802046:	b8 00 00 00 00       	mov    $0x0,%eax
  80204b:	80 3a 00             	cmpb   $0x0,(%edx)
  80204e:	74 09                	je     802059 <strlen+0x19>
		n++;
  802050:	83 c0 01             	add    $0x1,%eax
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  802053:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  802057:	75 f7                	jne    802050 <strlen+0x10>
		n++;
	return n;
}
  802059:	5d                   	pop    %ebp
  80205a:	c3                   	ret    

0080205b <strnlen>:

int
strnlen(const char *s, size_t size)
{
  80205b:	55                   	push   %ebp
  80205c:	89 e5                	mov    %esp,%ebp
  80205e:	53                   	push   %ebx
  80205f:	8b 5d 08             	mov    0x8(%ebp),%ebx
  802062:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  802065:	85 c9                	test   %ecx,%ecx
  802067:	74 19                	je     802082 <strnlen+0x27>
  802069:	80 3b 00             	cmpb   $0x0,(%ebx)
  80206c:	74 14                	je     802082 <strnlen+0x27>
  80206e:	b8 00 00 00 00       	mov    $0x0,%eax
		n++;
  802073:	83 c0 01             	add    $0x1,%eax
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  802076:	39 c8                	cmp    %ecx,%eax
  802078:	74 0d                	je     802087 <strnlen+0x2c>
  80207a:	80 3c 03 00          	cmpb   $0x0,(%ebx,%eax,1)
  80207e:	75 f3                	jne    802073 <strnlen+0x18>
  802080:	eb 05                	jmp    802087 <strnlen+0x2c>
  802082:	b8 00 00 00 00       	mov    $0x0,%eax
		n++;
	return n;
}
  802087:	5b                   	pop    %ebx
  802088:	5d                   	pop    %ebp
  802089:	c3                   	ret    

0080208a <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  80208a:	55                   	push   %ebp
  80208b:	89 e5                	mov    %esp,%ebp
  80208d:	53                   	push   %ebx
  80208e:	8b 45 08             	mov    0x8(%ebp),%eax
  802091:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  802094:	ba 00 00 00 00       	mov    $0x0,%edx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  802099:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
  80209d:	88 0c 10             	mov    %cl,(%eax,%edx,1)
  8020a0:	83 c2 01             	add    $0x1,%edx
  8020a3:	84 c9                	test   %cl,%cl
  8020a5:	75 f2                	jne    802099 <strcpy+0xf>
		/* do nothing */;
	return ret;
}
  8020a7:	5b                   	pop    %ebx
  8020a8:	5d                   	pop    %ebp
  8020a9:	c3                   	ret    

008020aa <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  8020aa:	55                   	push   %ebp
  8020ab:	89 e5                	mov    %esp,%ebp
  8020ad:	56                   	push   %esi
  8020ae:	53                   	push   %ebx
  8020af:	8b 45 08             	mov    0x8(%ebp),%eax
  8020b2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8020b5:	8b 75 10             	mov    0x10(%ebp),%esi
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  8020b8:	85 f6                	test   %esi,%esi
  8020ba:	74 18                	je     8020d4 <strncpy+0x2a>
  8020bc:	b9 00 00 00 00       	mov    $0x0,%ecx
		*dst++ = *src;
  8020c1:	0f b6 1a             	movzbl (%edx),%ebx
  8020c4:	88 1c 08             	mov    %bl,(%eax,%ecx,1)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  8020c7:	80 3a 01             	cmpb   $0x1,(%edx)
  8020ca:	83 da ff             	sbb    $0xffffffff,%edx
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  8020cd:	83 c1 01             	add    $0x1,%ecx
  8020d0:	39 ce                	cmp    %ecx,%esi
  8020d2:	77 ed                	ja     8020c1 <strncpy+0x17>
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
}
  8020d4:	5b                   	pop    %ebx
  8020d5:	5e                   	pop    %esi
  8020d6:	5d                   	pop    %ebp
  8020d7:	c3                   	ret    

008020d8 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  8020d8:	55                   	push   %ebp
  8020d9:	89 e5                	mov    %esp,%ebp
  8020db:	56                   	push   %esi
  8020dc:	53                   	push   %ebx
  8020dd:	8b 75 08             	mov    0x8(%ebp),%esi
  8020e0:	8b 55 0c             	mov    0xc(%ebp),%edx
  8020e3:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  8020e6:	89 f0                	mov    %esi,%eax
  8020e8:	85 c9                	test   %ecx,%ecx
  8020ea:	74 27                	je     802113 <strlcpy+0x3b>
		while (--size > 0 && *src != '\0')
  8020ec:	83 e9 01             	sub    $0x1,%ecx
  8020ef:	74 1d                	je     80210e <strlcpy+0x36>
  8020f1:	0f b6 1a             	movzbl (%edx),%ebx
  8020f4:	84 db                	test   %bl,%bl
  8020f6:	74 16                	je     80210e <strlcpy+0x36>
			*dst++ = *src++;
  8020f8:	88 18                	mov    %bl,(%eax)
  8020fa:	83 c0 01             	add    $0x1,%eax
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  8020fd:	83 e9 01             	sub    $0x1,%ecx
  802100:	74 0e                	je     802110 <strlcpy+0x38>
			*dst++ = *src++;
  802102:	83 c2 01             	add    $0x1,%edx
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  802105:	0f b6 1a             	movzbl (%edx),%ebx
  802108:	84 db                	test   %bl,%bl
  80210a:	75 ec                	jne    8020f8 <strlcpy+0x20>
  80210c:	eb 02                	jmp    802110 <strlcpy+0x38>
  80210e:	89 f0                	mov    %esi,%eax
			*dst++ = *src++;
		*dst = '\0';
  802110:	c6 00 00             	movb   $0x0,(%eax)
  802113:	29 f0                	sub    %esi,%eax
	}
	return dst - dst_in;
}
  802115:	5b                   	pop    %ebx
  802116:	5e                   	pop    %esi
  802117:	5d                   	pop    %ebp
  802118:	c3                   	ret    

00802119 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  802119:	55                   	push   %ebp
  80211a:	89 e5                	mov    %esp,%ebp
  80211c:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80211f:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  802122:	0f b6 01             	movzbl (%ecx),%eax
  802125:	84 c0                	test   %al,%al
  802127:	74 15                	je     80213e <strcmp+0x25>
  802129:	3a 02                	cmp    (%edx),%al
  80212b:	75 11                	jne    80213e <strcmp+0x25>
		p++, q++;
  80212d:	83 c1 01             	add    $0x1,%ecx
  802130:	83 c2 01             	add    $0x1,%edx
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  802133:	0f b6 01             	movzbl (%ecx),%eax
  802136:	84 c0                	test   %al,%al
  802138:	74 04                	je     80213e <strcmp+0x25>
  80213a:	3a 02                	cmp    (%edx),%al
  80213c:	74 ef                	je     80212d <strcmp+0x14>
  80213e:	0f b6 c0             	movzbl %al,%eax
  802141:	0f b6 12             	movzbl (%edx),%edx
  802144:	29 d0                	sub    %edx,%eax
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
}
  802146:	5d                   	pop    %ebp
  802147:	c3                   	ret    

00802148 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  802148:	55                   	push   %ebp
  802149:	89 e5                	mov    %esp,%ebp
  80214b:	53                   	push   %ebx
  80214c:	8b 55 08             	mov    0x8(%ebp),%edx
  80214f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  802152:	8b 45 10             	mov    0x10(%ebp),%eax
	while (n > 0 && *p && *p == *q)
  802155:	85 c0                	test   %eax,%eax
  802157:	74 23                	je     80217c <strncmp+0x34>
  802159:	0f b6 1a             	movzbl (%edx),%ebx
  80215c:	84 db                	test   %bl,%bl
  80215e:	74 24                	je     802184 <strncmp+0x3c>
  802160:	3a 19                	cmp    (%ecx),%bl
  802162:	75 20                	jne    802184 <strncmp+0x3c>
  802164:	83 e8 01             	sub    $0x1,%eax
  802167:	74 13                	je     80217c <strncmp+0x34>
		n--, p++, q++;
  802169:	83 c2 01             	add    $0x1,%edx
  80216c:	83 c1 01             	add    $0x1,%ecx
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  80216f:	0f b6 1a             	movzbl (%edx),%ebx
  802172:	84 db                	test   %bl,%bl
  802174:	74 0e                	je     802184 <strncmp+0x3c>
  802176:	3a 19                	cmp    (%ecx),%bl
  802178:	74 ea                	je     802164 <strncmp+0x1c>
  80217a:	eb 08                	jmp    802184 <strncmp+0x3c>
  80217c:	b8 00 00 00 00       	mov    $0x0,%eax
		n--, p++, q++;
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
}
  802181:	5b                   	pop    %ebx
  802182:	5d                   	pop    %ebp
  802183:	c3                   	ret    
	while (n > 0 && *p && *p == *q)
		n--, p++, q++;
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  802184:	0f b6 02             	movzbl (%edx),%eax
  802187:	0f b6 11             	movzbl (%ecx),%edx
  80218a:	29 d0                	sub    %edx,%eax
  80218c:	eb f3                	jmp    802181 <strncmp+0x39>

0080218e <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  80218e:	55                   	push   %ebp
  80218f:	89 e5                	mov    %esp,%ebp
  802191:	8b 45 08             	mov    0x8(%ebp),%eax
  802194:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  802198:	0f b6 10             	movzbl (%eax),%edx
  80219b:	84 d2                	test   %dl,%dl
  80219d:	74 15                	je     8021b4 <strchr+0x26>
		if (*s == c)
  80219f:	38 ca                	cmp    %cl,%dl
  8021a1:	75 07                	jne    8021aa <strchr+0x1c>
  8021a3:	eb 14                	jmp    8021b9 <strchr+0x2b>
  8021a5:	38 ca                	cmp    %cl,%dl
  8021a7:	90                   	nop
  8021a8:	74 0f                	je     8021b9 <strchr+0x2b>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  8021aa:	83 c0 01             	add    $0x1,%eax
  8021ad:	0f b6 10             	movzbl (%eax),%edx
  8021b0:	84 d2                	test   %dl,%dl
  8021b2:	75 f1                	jne    8021a5 <strchr+0x17>
  8021b4:	b8 00 00 00 00       	mov    $0x0,%eax
		if (*s == c)
			return (char *) s;
	return 0;
}
  8021b9:	5d                   	pop    %ebp
  8021ba:	c3                   	ret    

008021bb <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  8021bb:	55                   	push   %ebp
  8021bc:	89 e5                	mov    %esp,%ebp
  8021be:	8b 45 08             	mov    0x8(%ebp),%eax
  8021c1:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  8021c5:	0f b6 10             	movzbl (%eax),%edx
  8021c8:	84 d2                	test   %dl,%dl
  8021ca:	74 18                	je     8021e4 <strfind+0x29>
		if (*s == c)
  8021cc:	38 ca                	cmp    %cl,%dl
  8021ce:	75 0a                	jne    8021da <strfind+0x1f>
  8021d0:	eb 12                	jmp    8021e4 <strfind+0x29>
  8021d2:	38 ca                	cmp    %cl,%dl
  8021d4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  8021d8:	74 0a                	je     8021e4 <strfind+0x29>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  8021da:	83 c0 01             	add    $0x1,%eax
  8021dd:	0f b6 10             	movzbl (%eax),%edx
  8021e0:	84 d2                	test   %dl,%dl
  8021e2:	75 ee                	jne    8021d2 <strfind+0x17>
		if (*s == c)
			break;
	return (char *) s;
}
  8021e4:	5d                   	pop    %ebp
  8021e5:	c3                   	ret    

008021e6 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  8021e6:	55                   	push   %ebp
  8021e7:	89 e5                	mov    %esp,%ebp
  8021e9:	83 ec 0c             	sub    $0xc,%esp
  8021ec:	89 1c 24             	mov    %ebx,(%esp)
  8021ef:	89 74 24 04          	mov    %esi,0x4(%esp)
  8021f3:	89 7c 24 08          	mov    %edi,0x8(%esp)
  8021f7:	8b 7d 08             	mov    0x8(%ebp),%edi
  8021fa:	8b 45 0c             	mov    0xc(%ebp),%eax
  8021fd:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  802200:	85 c9                	test   %ecx,%ecx
  802202:	74 30                	je     802234 <memset+0x4e>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  802204:	f7 c7 03 00 00 00    	test   $0x3,%edi
  80220a:	75 25                	jne    802231 <memset+0x4b>
  80220c:	f6 c1 03             	test   $0x3,%cl
  80220f:	75 20                	jne    802231 <memset+0x4b>
		c &= 0xFF;
  802211:	0f b6 d0             	movzbl %al,%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  802214:	89 d3                	mov    %edx,%ebx
  802216:	c1 e3 08             	shl    $0x8,%ebx
  802219:	89 d6                	mov    %edx,%esi
  80221b:	c1 e6 18             	shl    $0x18,%esi
  80221e:	89 d0                	mov    %edx,%eax
  802220:	c1 e0 10             	shl    $0x10,%eax
  802223:	09 f0                	or     %esi,%eax
  802225:	09 d0                	or     %edx,%eax
		asm volatile("cld; rep stosl\n"
  802227:	09 d8                	or     %ebx,%eax
  802229:	c1 e9 02             	shr    $0x2,%ecx
  80222c:	fc                   	cld    
  80222d:	f3 ab                	rep stos %eax,%es:(%edi)
{
	char *p;

	if (n == 0)
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  80222f:	eb 03                	jmp    802234 <memset+0x4e>
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  802231:	fc                   	cld    
  802232:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  802234:	89 f8                	mov    %edi,%eax
  802236:	8b 1c 24             	mov    (%esp),%ebx
  802239:	8b 74 24 04          	mov    0x4(%esp),%esi
  80223d:	8b 7c 24 08          	mov    0x8(%esp),%edi
  802241:	89 ec                	mov    %ebp,%esp
  802243:	5d                   	pop    %ebp
  802244:	c3                   	ret    

00802245 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  802245:	55                   	push   %ebp
  802246:	89 e5                	mov    %esp,%ebp
  802248:	83 ec 08             	sub    $0x8,%esp
  80224b:	89 34 24             	mov    %esi,(%esp)
  80224e:	89 7c 24 04          	mov    %edi,0x4(%esp)
  802252:	8b 45 08             	mov    0x8(%ebp),%eax
  802255:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;
	
	s = src;
  802258:	8b 75 0c             	mov    0xc(%ebp),%esi
	d = dst;
  80225b:	89 c7                	mov    %eax,%edi
	if (s < d && s + n > d) {
  80225d:	39 c6                	cmp    %eax,%esi
  80225f:	73 35                	jae    802296 <memmove+0x51>
  802261:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  802264:	39 d0                	cmp    %edx,%eax
  802266:	73 2e                	jae    802296 <memmove+0x51>
		s += n;
		d += n;
  802268:	01 cf                	add    %ecx,%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  80226a:	f6 c2 03             	test   $0x3,%dl
  80226d:	75 1b                	jne    80228a <memmove+0x45>
  80226f:	f7 c7 03 00 00 00    	test   $0x3,%edi
  802275:	75 13                	jne    80228a <memmove+0x45>
  802277:	f6 c1 03             	test   $0x3,%cl
  80227a:	75 0e                	jne    80228a <memmove+0x45>
			asm volatile("std; rep movsl\n"
  80227c:	83 ef 04             	sub    $0x4,%edi
  80227f:	8d 72 fc             	lea    -0x4(%edx),%esi
  802282:	c1 e9 02             	shr    $0x2,%ecx
  802285:	fd                   	std    
  802286:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  802288:	eb 09                	jmp    802293 <memmove+0x4e>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  80228a:	83 ef 01             	sub    $0x1,%edi
  80228d:	8d 72 ff             	lea    -0x1(%edx),%esi
  802290:	fd                   	std    
  802291:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  802293:	fc                   	cld    
	const char *s;
	char *d;
	
	s = src;
	d = dst;
	if (s < d && s + n > d) {
  802294:	eb 20                	jmp    8022b6 <memmove+0x71>
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  802296:	f7 c6 03 00 00 00    	test   $0x3,%esi
  80229c:	75 15                	jne    8022b3 <memmove+0x6e>
  80229e:	f7 c7 03 00 00 00    	test   $0x3,%edi
  8022a4:	75 0d                	jne    8022b3 <memmove+0x6e>
  8022a6:	f6 c1 03             	test   $0x3,%cl
  8022a9:	75 08                	jne    8022b3 <memmove+0x6e>
			asm volatile("cld; rep movsl\n"
  8022ab:	c1 e9 02             	shr    $0x2,%ecx
  8022ae:	fc                   	cld    
  8022af:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  8022b1:	eb 03                	jmp    8022b6 <memmove+0x71>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  8022b3:	fc                   	cld    
  8022b4:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  8022b6:	8b 34 24             	mov    (%esp),%esi
  8022b9:	8b 7c 24 04          	mov    0x4(%esp),%edi
  8022bd:	89 ec                	mov    %ebp,%esp
  8022bf:	5d                   	pop    %ebp
  8022c0:	c3                   	ret    

008022c1 <memcpy>:

/* sigh - gcc emits references to this for structure assignments! */
/* it is *not* prototyped in inc/string.h - do not use directly. */
void *
memcpy(void *dst, void *src, size_t n)
{
  8022c1:	55                   	push   %ebp
  8022c2:	89 e5                	mov    %esp,%ebp
  8022c4:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  8022c7:	8b 45 10             	mov    0x10(%ebp),%eax
  8022ca:	89 44 24 08          	mov    %eax,0x8(%esp)
  8022ce:	8b 45 0c             	mov    0xc(%ebp),%eax
  8022d1:	89 44 24 04          	mov    %eax,0x4(%esp)
  8022d5:	8b 45 08             	mov    0x8(%ebp),%eax
  8022d8:	89 04 24             	mov    %eax,(%esp)
  8022db:	e8 65 ff ff ff       	call   802245 <memmove>
}
  8022e0:	c9                   	leave  
  8022e1:	c3                   	ret    

008022e2 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  8022e2:	55                   	push   %ebp
  8022e3:	89 e5                	mov    %esp,%ebp
  8022e5:	57                   	push   %edi
  8022e6:	56                   	push   %esi
  8022e7:	53                   	push   %ebx
  8022e8:	8b 75 08             	mov    0x8(%ebp),%esi
  8022eb:	8b 7d 0c             	mov    0xc(%ebp),%edi
  8022ee:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  8022f1:	85 c9                	test   %ecx,%ecx
  8022f3:	74 36                	je     80232b <memcmp+0x49>
		if (*s1 != *s2)
  8022f5:	0f b6 06             	movzbl (%esi),%eax
  8022f8:	0f b6 1f             	movzbl (%edi),%ebx
  8022fb:	38 d8                	cmp    %bl,%al
  8022fd:	74 20                	je     80231f <memcmp+0x3d>
  8022ff:	eb 14                	jmp    802315 <memcmp+0x33>
  802301:	0f b6 44 16 01       	movzbl 0x1(%esi,%edx,1),%eax
  802306:	0f b6 5c 17 01       	movzbl 0x1(%edi,%edx,1),%ebx
  80230b:	83 c2 01             	add    $0x1,%edx
  80230e:	83 e9 01             	sub    $0x1,%ecx
  802311:	38 d8                	cmp    %bl,%al
  802313:	74 12                	je     802327 <memcmp+0x45>
			return (int) *s1 - (int) *s2;
  802315:	0f b6 c0             	movzbl %al,%eax
  802318:	0f b6 db             	movzbl %bl,%ebx
  80231b:	29 d8                	sub    %ebx,%eax
  80231d:	eb 11                	jmp    802330 <memcmp+0x4e>
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  80231f:	83 e9 01             	sub    $0x1,%ecx
  802322:	ba 00 00 00 00       	mov    $0x0,%edx
  802327:	85 c9                	test   %ecx,%ecx
  802329:	75 d6                	jne    802301 <memcmp+0x1f>
  80232b:	b8 00 00 00 00       	mov    $0x0,%eax
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
}
  802330:	5b                   	pop    %ebx
  802331:	5e                   	pop    %esi
  802332:	5f                   	pop    %edi
  802333:	5d                   	pop    %ebp
  802334:	c3                   	ret    

00802335 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  802335:	55                   	push   %ebp
  802336:	89 e5                	mov    %esp,%ebp
  802338:	8b 45 08             	mov    0x8(%ebp),%eax
	const void *ends = (const char *) s + n;
  80233b:	89 c2                	mov    %eax,%edx
  80233d:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  802340:	39 d0                	cmp    %edx,%eax
  802342:	73 15                	jae    802359 <memfind+0x24>
		if (*(const unsigned char *) s == (unsigned char) c)
  802344:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
  802348:	38 08                	cmp    %cl,(%eax)
  80234a:	75 06                	jne    802352 <memfind+0x1d>
  80234c:	eb 0b                	jmp    802359 <memfind+0x24>
  80234e:	38 08                	cmp    %cl,(%eax)
  802350:	74 07                	je     802359 <memfind+0x24>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  802352:	83 c0 01             	add    $0x1,%eax
  802355:	39 c2                	cmp    %eax,%edx
  802357:	77 f5                	ja     80234e <memfind+0x19>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
	return (void *) s;
}
  802359:	5d                   	pop    %ebp
  80235a:	c3                   	ret    

0080235b <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  80235b:	55                   	push   %ebp
  80235c:	89 e5                	mov    %esp,%ebp
  80235e:	57                   	push   %edi
  80235f:	56                   	push   %esi
  802360:	53                   	push   %ebx
  802361:	83 ec 04             	sub    $0x4,%esp
  802364:	8b 55 08             	mov    0x8(%ebp),%edx
  802367:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  80236a:	0f b6 02             	movzbl (%edx),%eax
  80236d:	3c 20                	cmp    $0x20,%al
  80236f:	74 04                	je     802375 <strtol+0x1a>
  802371:	3c 09                	cmp    $0x9,%al
  802373:	75 0e                	jne    802383 <strtol+0x28>
		s++;
  802375:	83 c2 01             	add    $0x1,%edx
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  802378:	0f b6 02             	movzbl (%edx),%eax
  80237b:	3c 20                	cmp    $0x20,%al
  80237d:	74 f6                	je     802375 <strtol+0x1a>
  80237f:	3c 09                	cmp    $0x9,%al
  802381:	74 f2                	je     802375 <strtol+0x1a>
		s++;

	// plus/minus sign
	if (*s == '+')
  802383:	3c 2b                	cmp    $0x2b,%al
  802385:	75 0c                	jne    802393 <strtol+0x38>
		s++;
  802387:	83 c2 01             	add    $0x1,%edx
  80238a:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  802391:	eb 15                	jmp    8023a8 <strtol+0x4d>
	else if (*s == '-')
  802393:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  80239a:	3c 2d                	cmp    $0x2d,%al
  80239c:	75 0a                	jne    8023a8 <strtol+0x4d>
		s++, neg = 1;
  80239e:	83 c2 01             	add    $0x1,%edx
  8023a1:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  8023a8:	85 db                	test   %ebx,%ebx
  8023aa:	0f 94 c0             	sete   %al
  8023ad:	74 05                	je     8023b4 <strtol+0x59>
  8023af:	83 fb 10             	cmp    $0x10,%ebx
  8023b2:	75 18                	jne    8023cc <strtol+0x71>
  8023b4:	80 3a 30             	cmpb   $0x30,(%edx)
  8023b7:	75 13                	jne    8023cc <strtol+0x71>
  8023b9:	80 7a 01 78          	cmpb   $0x78,0x1(%edx)
  8023bd:	8d 76 00             	lea    0x0(%esi),%esi
  8023c0:	75 0a                	jne    8023cc <strtol+0x71>
		s += 2, base = 16;
  8023c2:	83 c2 02             	add    $0x2,%edx
  8023c5:	bb 10 00 00 00       	mov    $0x10,%ebx
		s++;
	else if (*s == '-')
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  8023ca:	eb 15                	jmp    8023e1 <strtol+0x86>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  8023cc:	84 c0                	test   %al,%al
  8023ce:	66 90                	xchg   %ax,%ax
  8023d0:	74 0f                	je     8023e1 <strtol+0x86>
  8023d2:	bb 0a 00 00 00       	mov    $0xa,%ebx
  8023d7:	80 3a 30             	cmpb   $0x30,(%edx)
  8023da:	75 05                	jne    8023e1 <strtol+0x86>
		s++, base = 8;
  8023dc:	83 c2 01             	add    $0x1,%edx
  8023df:	b3 08                	mov    $0x8,%bl
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  8023e1:	b8 00 00 00 00       	mov    $0x0,%eax
  8023e6:	89 de                	mov    %ebx,%esi

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  8023e8:	0f b6 0a             	movzbl (%edx),%ecx
  8023eb:	89 cf                	mov    %ecx,%edi
  8023ed:	8d 59 d0             	lea    -0x30(%ecx),%ebx
  8023f0:	80 fb 09             	cmp    $0x9,%bl
  8023f3:	77 08                	ja     8023fd <strtol+0xa2>
			dig = *s - '0';
  8023f5:	0f be c9             	movsbl %cl,%ecx
  8023f8:	83 e9 30             	sub    $0x30,%ecx
  8023fb:	eb 1e                	jmp    80241b <strtol+0xc0>
		else if (*s >= 'a' && *s <= 'z')
  8023fd:	8d 5f 9f             	lea    -0x61(%edi),%ebx
  802400:	80 fb 19             	cmp    $0x19,%bl
  802403:	77 08                	ja     80240d <strtol+0xb2>
			dig = *s - 'a' + 10;
  802405:	0f be c9             	movsbl %cl,%ecx
  802408:	83 e9 57             	sub    $0x57,%ecx
  80240b:	eb 0e                	jmp    80241b <strtol+0xc0>
		else if (*s >= 'A' && *s <= 'Z')
  80240d:	8d 5f bf             	lea    -0x41(%edi),%ebx
  802410:	80 fb 19             	cmp    $0x19,%bl
  802413:	77 15                	ja     80242a <strtol+0xcf>
			dig = *s - 'A' + 10;
  802415:	0f be c9             	movsbl %cl,%ecx
  802418:	83 e9 37             	sub    $0x37,%ecx
		else
			break;
		if (dig >= base)
  80241b:	39 f1                	cmp    %esi,%ecx
  80241d:	7d 0b                	jge    80242a <strtol+0xcf>
			break;
		s++, val = (val * base) + dig;
  80241f:	83 c2 01             	add    $0x1,%edx
  802422:	0f af c6             	imul   %esi,%eax
  802425:	8d 04 01             	lea    (%ecx,%eax,1),%eax
		// we don't properly detect overflow!
	}
  802428:	eb be                	jmp    8023e8 <strtol+0x8d>
  80242a:	89 c1                	mov    %eax,%ecx

	if (endptr)
  80242c:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802430:	74 05                	je     802437 <strtol+0xdc>
		*endptr = (char *) s;
  802432:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  802435:	89 13                	mov    %edx,(%ebx)
	return (neg ? -val : val);
  802437:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80243b:	74 04                	je     802441 <strtol+0xe6>
  80243d:	89 c8                	mov    %ecx,%eax
  80243f:	f7 d8                	neg    %eax
}
  802441:	83 c4 04             	add    $0x4,%esp
  802444:	5b                   	pop    %ebx
  802445:	5e                   	pop    %esi
  802446:	5f                   	pop    %edi
  802447:	5d                   	pop    %ebp
  802448:	c3                   	ret    
  802449:	00 00                	add    %al,(%eax)
  80244b:	00 00                	add    %al,(%eax)
  80244d:	00 00                	add    %al,(%eax)
	...

00802450 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  802450:	55                   	push   %ebp
  802451:	89 e5                	mov    %esp,%ebp
  802453:	57                   	push   %edi
  802454:	56                   	push   %esi
  802455:	53                   	push   %ebx
  802456:	83 ec 1c             	sub    $0x1c,%esp
  802459:	8b 7d 0c             	mov    0xc(%ebp),%edi
  80245c:	8b 5d 10             	mov    0x10(%ebp),%ebx
  80245f:	8b 75 14             	mov    0x14(%ebp),%esi
	// LAB 4: Your code here.
	int r;
	if (pg == NULL)
  802462:	85 db                	test   %ebx,%ebx
  802464:	75 2d                	jne    802493 <ipc_send+0x43>
  802466:	bb 00 00 c0 ee       	mov    $0xeec00000,%ebx
  80246b:	eb 26                	jmp    802493 <ipc_send+0x43>
		pg = (void*)UTOP;
	while ((r = sys_ipc_try_send(to_env, val, pg, perm)) < 0)
	{
		if(r != -E_IPC_NOT_RECV)
  80246d:	83 f8 f9             	cmp    $0xfffffff9,%eax
  802470:	74 1c                	je     80248e <ipc_send+0x3e>
			panic("Panic in lib ipc.c : ipc_send() \n");
  802472:	c7 44 24 08 60 2c 80 	movl   $0x802c60,0x8(%esp)
  802479:	00 
  80247a:	c7 44 24 04 44 00 00 	movl   $0x44,0x4(%esp)
  802481:	00 
  802482:	c7 04 24 84 2c 80 00 	movl   $0x802c84,(%esp)
  802489:	e8 7e f4 ff ff       	call   80190c <_panic>
		sys_yield();
  80248e:	e8 b7 e0 ff ff       	call   80054a <sys_yield>
{
	// LAB 4: Your code here.
	int r;
	if (pg == NULL)
		pg = (void*)UTOP;
	while ((r = sys_ipc_try_send(to_env, val, pg, perm)) < 0)
  802493:	89 74 24 0c          	mov    %esi,0xc(%esp)
  802497:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80249b:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80249f:	8b 45 08             	mov    0x8(%ebp),%eax
  8024a2:	89 04 24             	mov    %eax,(%esp)
  8024a5:	e8 33 de ff ff       	call   8002dd <sys_ipc_try_send>
  8024aa:	85 c0                	test   %eax,%eax
  8024ac:	78 bf                	js     80246d <ipc_send+0x1d>
		if(r != -E_IPC_NOT_RECV)
			panic("Panic in lib ipc.c : ipc_send() \n");
		sys_yield();
	}
	//panic("ipc_send not implemented");
}
  8024ae:	83 c4 1c             	add    $0x1c,%esp
  8024b1:	5b                   	pop    %ebx
  8024b2:	5e                   	pop    %esi
  8024b3:	5f                   	pop    %edi
  8024b4:	5d                   	pop    %ebp
  8024b5:	c3                   	ret    

008024b6 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  8024b6:	55                   	push   %ebp
  8024b7:	89 e5                	mov    %esp,%ebp
  8024b9:	56                   	push   %esi
  8024ba:	53                   	push   %ebx
  8024bb:	83 ec 10             	sub    $0x10,%esp
  8024be:	8b 5d 08             	mov    0x8(%ebp),%ebx
  8024c1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8024c4:	8b 75 10             	mov    0x10(%ebp),%esi
	// LAB 4: Your code here.
	int r;

	if (pg == NULL)
  8024c7:	85 c0                	test   %eax,%eax
  8024c9:	75 05                	jne    8024d0 <ipc_recv+0x1a>
  8024cb:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
		pg = (void*)UTOP;
	if ((r = sys_ipc_recv(pg)) < 0)
  8024d0:	89 04 24             	mov    %eax,(%esp)
  8024d3:	e8 a8 dd ff ff       	call   800280 <sys_ipc_recv>
  8024d8:	85 c0                	test   %eax,%eax
  8024da:	79 16                	jns    8024f2 <ipc_recv+0x3c>
	{
		if (from_env_store != NULL)
  8024dc:	85 db                	test   %ebx,%ebx
  8024de:	74 06                	je     8024e6 <ipc_recv+0x30>
			*from_env_store = 0;
  8024e0:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
		if(perm_store != NULL)
  8024e6:	85 f6                	test   %esi,%esi
  8024e8:	74 2c                	je     802516 <ipc_recv+0x60>
			*perm_store = 0;
  8024ea:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
  8024f0:	eb 24                	jmp    802516 <ipc_recv+0x60>
		return r;
	}
	else
	{	
		if (from_env_store != NULL)
  8024f2:	85 db                	test   %ebx,%ebx
  8024f4:	74 0a                	je     802500 <ipc_recv+0x4a>
			*from_env_store = env->env_ipc_from;
  8024f6:	a1 74 60 80 00       	mov    0x806074,%eax
  8024fb:	8b 40 74             	mov    0x74(%eax),%eax
  8024fe:	89 03                	mov    %eax,(%ebx)
		if(perm_store != NULL)
  802500:	85 f6                	test   %esi,%esi
  802502:	74 0a                	je     80250e <ipc_recv+0x58>
			*perm_store = env->env_ipc_perm;
  802504:	a1 74 60 80 00       	mov    0x806074,%eax
  802509:	8b 40 78             	mov    0x78(%eax),%eax
  80250c:	89 06                	mov    %eax,(%esi)
		return env->env_ipc_value;
  80250e:	a1 74 60 80 00       	mov    0x806074,%eax
  802513:	8b 40 70             	mov    0x70(%eax),%eax
	}		
	//panic("ipc_recv not implemented");
	//return 0;
}
  802516:	83 c4 10             	add    $0x10,%esp
  802519:	5b                   	pop    %ebx
  80251a:	5e                   	pop    %esi
  80251b:	5d                   	pop    %ebp
  80251c:	c3                   	ret    
  80251d:	00 00                	add    %al,(%eax)
	...

00802520 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  802520:	55                   	push   %ebp
  802521:	89 e5                	mov    %esp,%ebp
	pte_t pte;

	if (!(vpd[PDX(v)] & PTE_P))
  802523:	8b 45 08             	mov    0x8(%ebp),%eax
  802526:	89 c2                	mov    %eax,%edx
  802528:	c1 ea 16             	shr    $0x16,%edx
  80252b:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  802532:	f6 c2 01             	test   $0x1,%dl
  802535:	74 26                	je     80255d <pageref+0x3d>
		return 0;
	pte = vpt[VPN(v)];
  802537:	c1 e8 0c             	shr    $0xc,%eax
  80253a:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
	if (!(pte & PTE_P))
  802541:	a8 01                	test   $0x1,%al
  802543:	74 18                	je     80255d <pageref+0x3d>
		return 0;
	return pages[PPN(pte)].pp_ref;
  802545:	c1 e8 0c             	shr    $0xc,%eax
  802548:	8d 14 40             	lea    (%eax,%eax,2),%edx
  80254b:	c1 e2 02             	shl    $0x2,%edx
  80254e:	b8 00 00 00 ef       	mov    $0xef000000,%eax
  802553:	0f b7 44 02 08       	movzwl 0x8(%edx,%eax,1),%eax
  802558:	0f b7 c0             	movzwl %ax,%eax
  80255b:	eb 05                	jmp    802562 <pageref+0x42>
  80255d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802562:	5d                   	pop    %ebp
  802563:	c3                   	ret    
	...

00802570 <__udivdi3>:
  802570:	55                   	push   %ebp
  802571:	89 e5                	mov    %esp,%ebp
  802573:	57                   	push   %edi
  802574:	56                   	push   %esi
  802575:	83 ec 10             	sub    $0x10,%esp
  802578:	8b 45 14             	mov    0x14(%ebp),%eax
  80257b:	8b 55 08             	mov    0x8(%ebp),%edx
  80257e:	8b 75 10             	mov    0x10(%ebp),%esi
  802581:	8b 7d 0c             	mov    0xc(%ebp),%edi
  802584:	85 c0                	test   %eax,%eax
  802586:	89 55 f0             	mov    %edx,-0x10(%ebp)
  802589:	75 35                	jne    8025c0 <__udivdi3+0x50>
  80258b:	39 fe                	cmp    %edi,%esi
  80258d:	77 61                	ja     8025f0 <__udivdi3+0x80>
  80258f:	85 f6                	test   %esi,%esi
  802591:	75 0b                	jne    80259e <__udivdi3+0x2e>
  802593:	b8 01 00 00 00       	mov    $0x1,%eax
  802598:	31 d2                	xor    %edx,%edx
  80259a:	f7 f6                	div    %esi
  80259c:	89 c6                	mov    %eax,%esi
  80259e:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  8025a1:	31 d2                	xor    %edx,%edx
  8025a3:	89 f8                	mov    %edi,%eax
  8025a5:	f7 f6                	div    %esi
  8025a7:	89 c7                	mov    %eax,%edi
  8025a9:	89 c8                	mov    %ecx,%eax
  8025ab:	f7 f6                	div    %esi
  8025ad:	89 c1                	mov    %eax,%ecx
  8025af:	89 fa                	mov    %edi,%edx
  8025b1:	89 c8                	mov    %ecx,%eax
  8025b3:	83 c4 10             	add    $0x10,%esp
  8025b6:	5e                   	pop    %esi
  8025b7:	5f                   	pop    %edi
  8025b8:	5d                   	pop    %ebp
  8025b9:	c3                   	ret    
  8025ba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  8025c0:	39 f8                	cmp    %edi,%eax
  8025c2:	77 1c                	ja     8025e0 <__udivdi3+0x70>
  8025c4:	0f bd d0             	bsr    %eax,%edx
  8025c7:	83 f2 1f             	xor    $0x1f,%edx
  8025ca:	89 55 f4             	mov    %edx,-0xc(%ebp)
  8025cd:	75 39                	jne    802608 <__udivdi3+0x98>
  8025cf:	3b 75 f0             	cmp    -0x10(%ebp),%esi
  8025d2:	0f 86 a0 00 00 00    	jbe    802678 <__udivdi3+0x108>
  8025d8:	39 f8                	cmp    %edi,%eax
  8025da:	0f 82 98 00 00 00    	jb     802678 <__udivdi3+0x108>
  8025e0:	31 ff                	xor    %edi,%edi
  8025e2:	31 c9                	xor    %ecx,%ecx
  8025e4:	89 c8                	mov    %ecx,%eax
  8025e6:	89 fa                	mov    %edi,%edx
  8025e8:	83 c4 10             	add    $0x10,%esp
  8025eb:	5e                   	pop    %esi
  8025ec:	5f                   	pop    %edi
  8025ed:	5d                   	pop    %ebp
  8025ee:	c3                   	ret    
  8025ef:	90                   	nop
  8025f0:	89 d1                	mov    %edx,%ecx
  8025f2:	89 fa                	mov    %edi,%edx
  8025f4:	89 c8                	mov    %ecx,%eax
  8025f6:	31 ff                	xor    %edi,%edi
  8025f8:	f7 f6                	div    %esi
  8025fa:	89 c1                	mov    %eax,%ecx
  8025fc:	89 fa                	mov    %edi,%edx
  8025fe:	89 c8                	mov    %ecx,%eax
  802600:	83 c4 10             	add    $0x10,%esp
  802603:	5e                   	pop    %esi
  802604:	5f                   	pop    %edi
  802605:	5d                   	pop    %ebp
  802606:	c3                   	ret    
  802607:	90                   	nop
  802608:	0f b6 4d f4          	movzbl -0xc(%ebp),%ecx
  80260c:	89 f2                	mov    %esi,%edx
  80260e:	d3 e0                	shl    %cl,%eax
  802610:	89 45 ec             	mov    %eax,-0x14(%ebp)
  802613:	b8 20 00 00 00       	mov    $0x20,%eax
  802618:	2b 45 f4             	sub    -0xc(%ebp),%eax
  80261b:	89 c1                	mov    %eax,%ecx
  80261d:	d3 ea                	shr    %cl,%edx
  80261f:	0f b6 4d f4          	movzbl -0xc(%ebp),%ecx
  802623:	0b 55 ec             	or     -0x14(%ebp),%edx
  802626:	d3 e6                	shl    %cl,%esi
  802628:	89 c1                	mov    %eax,%ecx
  80262a:	89 75 e8             	mov    %esi,-0x18(%ebp)
  80262d:	89 fe                	mov    %edi,%esi
  80262f:	d3 ee                	shr    %cl,%esi
  802631:	0f b6 4d f4          	movzbl -0xc(%ebp),%ecx
  802635:	89 55 ec             	mov    %edx,-0x14(%ebp)
  802638:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80263b:	d3 e7                	shl    %cl,%edi
  80263d:	89 c1                	mov    %eax,%ecx
  80263f:	d3 ea                	shr    %cl,%edx
  802641:	09 d7                	or     %edx,%edi
  802643:	89 f2                	mov    %esi,%edx
  802645:	89 f8                	mov    %edi,%eax
  802647:	f7 75 ec             	divl   -0x14(%ebp)
  80264a:	89 d6                	mov    %edx,%esi
  80264c:	89 c7                	mov    %eax,%edi
  80264e:	f7 65 e8             	mull   -0x18(%ebp)
  802651:	39 d6                	cmp    %edx,%esi
  802653:	89 55 ec             	mov    %edx,-0x14(%ebp)
  802656:	72 30                	jb     802688 <__udivdi3+0x118>
  802658:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80265b:	0f b6 4d f4          	movzbl -0xc(%ebp),%ecx
  80265f:	d3 e2                	shl    %cl,%edx
  802661:	39 c2                	cmp    %eax,%edx
  802663:	73 05                	jae    80266a <__udivdi3+0xfa>
  802665:	3b 75 ec             	cmp    -0x14(%ebp),%esi
  802668:	74 1e                	je     802688 <__udivdi3+0x118>
  80266a:	89 f9                	mov    %edi,%ecx
  80266c:	31 ff                	xor    %edi,%edi
  80266e:	e9 71 ff ff ff       	jmp    8025e4 <__udivdi3+0x74>
  802673:	90                   	nop
  802674:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802678:	31 ff                	xor    %edi,%edi
  80267a:	b9 01 00 00 00       	mov    $0x1,%ecx
  80267f:	e9 60 ff ff ff       	jmp    8025e4 <__udivdi3+0x74>
  802684:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802688:	8d 4f ff             	lea    -0x1(%edi),%ecx
  80268b:	31 ff                	xor    %edi,%edi
  80268d:	89 c8                	mov    %ecx,%eax
  80268f:	89 fa                	mov    %edi,%edx
  802691:	83 c4 10             	add    $0x10,%esp
  802694:	5e                   	pop    %esi
  802695:	5f                   	pop    %edi
  802696:	5d                   	pop    %ebp
  802697:	c3                   	ret    
	...

008026a0 <__umoddi3>:
  8026a0:	55                   	push   %ebp
  8026a1:	89 e5                	mov    %esp,%ebp
  8026a3:	57                   	push   %edi
  8026a4:	56                   	push   %esi
  8026a5:	83 ec 20             	sub    $0x20,%esp
  8026a8:	8b 55 14             	mov    0x14(%ebp),%edx
  8026ab:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8026ae:	8b 7d 10             	mov    0x10(%ebp),%edi
  8026b1:	8b 75 0c             	mov    0xc(%ebp),%esi
  8026b4:	85 d2                	test   %edx,%edx
  8026b6:	89 c8                	mov    %ecx,%eax
  8026b8:	89 4d f4             	mov    %ecx,-0xc(%ebp)
  8026bb:	75 13                	jne    8026d0 <__umoddi3+0x30>
  8026bd:	39 f7                	cmp    %esi,%edi
  8026bf:	76 3f                	jbe    802700 <__umoddi3+0x60>
  8026c1:	89 f2                	mov    %esi,%edx
  8026c3:	f7 f7                	div    %edi
  8026c5:	89 d0                	mov    %edx,%eax
  8026c7:	31 d2                	xor    %edx,%edx
  8026c9:	83 c4 20             	add    $0x20,%esp
  8026cc:	5e                   	pop    %esi
  8026cd:	5f                   	pop    %edi
  8026ce:	5d                   	pop    %ebp
  8026cf:	c3                   	ret    
  8026d0:	39 f2                	cmp    %esi,%edx
  8026d2:	77 4c                	ja     802720 <__umoddi3+0x80>
  8026d4:	0f bd ca             	bsr    %edx,%ecx
  8026d7:	83 f1 1f             	xor    $0x1f,%ecx
  8026da:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  8026dd:	75 51                	jne    802730 <__umoddi3+0x90>
  8026df:	3b 7d f4             	cmp    -0xc(%ebp),%edi
  8026e2:	0f 87 e0 00 00 00    	ja     8027c8 <__umoddi3+0x128>
  8026e8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026eb:	29 f8                	sub    %edi,%eax
  8026ed:	19 d6                	sbb    %edx,%esi
  8026ef:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8026f2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026f5:	89 f2                	mov    %esi,%edx
  8026f7:	83 c4 20             	add    $0x20,%esp
  8026fa:	5e                   	pop    %esi
  8026fb:	5f                   	pop    %edi
  8026fc:	5d                   	pop    %ebp
  8026fd:	c3                   	ret    
  8026fe:	66 90                	xchg   %ax,%ax
  802700:	85 ff                	test   %edi,%edi
  802702:	75 0b                	jne    80270f <__umoddi3+0x6f>
  802704:	b8 01 00 00 00       	mov    $0x1,%eax
  802709:	31 d2                	xor    %edx,%edx
  80270b:	f7 f7                	div    %edi
  80270d:	89 c7                	mov    %eax,%edi
  80270f:	89 f0                	mov    %esi,%eax
  802711:	31 d2                	xor    %edx,%edx
  802713:	f7 f7                	div    %edi
  802715:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802718:	f7 f7                	div    %edi
  80271a:	eb a9                	jmp    8026c5 <__umoddi3+0x25>
  80271c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802720:	89 c8                	mov    %ecx,%eax
  802722:	89 f2                	mov    %esi,%edx
  802724:	83 c4 20             	add    $0x20,%esp
  802727:	5e                   	pop    %esi
  802728:	5f                   	pop    %edi
  802729:	5d                   	pop    %ebp
  80272a:	c3                   	ret    
  80272b:	90                   	nop
  80272c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802730:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
  802734:	d3 e2                	shl    %cl,%edx
  802736:	89 55 f4             	mov    %edx,-0xc(%ebp)
  802739:	ba 20 00 00 00       	mov    $0x20,%edx
  80273e:	2b 55 f0             	sub    -0x10(%ebp),%edx
  802741:	89 55 ec             	mov    %edx,-0x14(%ebp)
  802744:	0f b6 4d ec          	movzbl -0x14(%ebp),%ecx
  802748:	89 fa                	mov    %edi,%edx
  80274a:	d3 ea                	shr    %cl,%edx
  80274c:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
  802750:	0b 55 f4             	or     -0xc(%ebp),%edx
  802753:	d3 e7                	shl    %cl,%edi
  802755:	0f b6 4d ec          	movzbl -0x14(%ebp),%ecx
  802759:	89 55 f4             	mov    %edx,-0xc(%ebp)
  80275c:	89 f2                	mov    %esi,%edx
  80275e:	89 7d e8             	mov    %edi,-0x18(%ebp)
  802761:	89 c7                	mov    %eax,%edi
  802763:	d3 ea                	shr    %cl,%edx
  802765:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
  802769:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  80276c:	89 c2                	mov    %eax,%edx
  80276e:	d3 e6                	shl    %cl,%esi
  802770:	0f b6 4d ec          	movzbl -0x14(%ebp),%ecx
  802774:	d3 ea                	shr    %cl,%edx
  802776:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
  80277a:	09 d6                	or     %edx,%esi
  80277c:	89 f0                	mov    %esi,%eax
  80277e:	8b 75 e4             	mov    -0x1c(%ebp),%esi
  802781:	d3 e7                	shl    %cl,%edi
  802783:	89 f2                	mov    %esi,%edx
  802785:	f7 75 f4             	divl   -0xc(%ebp)
  802788:	89 d6                	mov    %edx,%esi
  80278a:	f7 65 e8             	mull   -0x18(%ebp)
  80278d:	39 d6                	cmp    %edx,%esi
  80278f:	72 2b                	jb     8027bc <__umoddi3+0x11c>
  802791:	39 c7                	cmp    %eax,%edi
  802793:	72 23                	jb     8027b8 <__umoddi3+0x118>
  802795:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
  802799:	29 c7                	sub    %eax,%edi
  80279b:	19 d6                	sbb    %edx,%esi
  80279d:	89 f0                	mov    %esi,%eax
  80279f:	89 f2                	mov    %esi,%edx
  8027a1:	d3 ef                	shr    %cl,%edi
  8027a3:	0f b6 4d ec          	movzbl -0x14(%ebp),%ecx
  8027a7:	d3 e0                	shl    %cl,%eax
  8027a9:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
  8027ad:	09 f8                	or     %edi,%eax
  8027af:	d3 ea                	shr    %cl,%edx
  8027b1:	83 c4 20             	add    $0x20,%esp
  8027b4:	5e                   	pop    %esi
  8027b5:	5f                   	pop    %edi
  8027b6:	5d                   	pop    %ebp
  8027b7:	c3                   	ret    
  8027b8:	39 d6                	cmp    %edx,%esi
  8027ba:	75 d9                	jne    802795 <__umoddi3+0xf5>
  8027bc:	2b 45 e8             	sub    -0x18(%ebp),%eax
  8027bf:	1b 55 f4             	sbb    -0xc(%ebp),%edx
  8027c2:	eb d1                	jmp    802795 <__umoddi3+0xf5>
  8027c4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  8027c8:	39 f2                	cmp    %esi,%edx
  8027ca:	0f 82 18 ff ff ff    	jb     8026e8 <__umoddi3+0x48>
  8027d0:	e9 1d ff ff ff       	jmp    8026f2 <__umoddi3+0x52>
