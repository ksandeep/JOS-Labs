
obj/net/testoutput:     file format elf32-i386


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
  80002c:	e8 27 03 00 00       	call   800358 <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>
	...

00800040 <umain>:
static struct jif_pkt *pkt = (struct jif_pkt*)REQVA;


void
umain(void)
{
  800040:	55                   	push   %ebp
  800041:	89 e5                	mov    %esp,%ebp
  800043:	56                   	push   %esi
  800044:	53                   	push   %ebx
  800045:	83 ec 10             	sub    $0x10,%esp
	envid_t ns_envid = sys_getenvid();
  800048:	e8 81 13 00 00       	call   8013ce <sys_getenvid>
  80004d:	89 c6                	mov    %eax,%esi
	int i, r;

	binaryname = "testoutput";
  80004f:	c7 05 00 70 80 00 60 	movl   $0x802f60,0x807000
  800056:	2f 80 00 

	output_envid = fork();
  800059:	e8 67 15 00 00       	call   8015c5 <fork>
  80005e:	a3 74 70 80 00       	mov    %eax,0x807074
	if (output_envid < 0)
  800063:	85 c0                	test   %eax,%eax
  800065:	79 1c                	jns    800083 <umain+0x43>
		panic("error forking");
  800067:	c7 44 24 08 6b 2f 80 	movl   $0x802f6b,0x8(%esp)
  80006e:	00 
  80006f:	c7 44 24 04 16 00 00 	movl   $0x16,0x4(%esp)
  800076:	00 
  800077:	c7 04 24 79 2f 80 00 	movl   $0x802f79,(%esp)
  80007e:	e8 41 03 00 00       	call   8003c4 <_panic>
	else if (output_envid == 0) {
		output(ns_envid);
		return;
  800083:	bb 00 00 00 00       	mov    $0x0,%ebx
	binaryname = "testoutput";

	output_envid = fork();
	if (output_envid < 0)
		panic("error forking");
	else if (output_envid == 0) {
  800088:	85 c0                	test   %eax,%eax
  80008a:	75 0d                	jne    800099 <umain+0x59>
		output(ns_envid);
  80008c:	89 34 24             	mov    %esi,(%esp)
  80008f:	e8 3c 02 00 00       	call   8002d0 <output>
		return;
  800094:	e9 c9 00 00 00       	jmp    800162 <umain+0x122>
	}

	for (i = 0; i < TESTOUTPUT_COUNT; i++) {
		if ((r = sys_page_alloc(0, pkt, PTE_P|PTE_U|PTE_W)) < 0)
  800099:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  8000a0:	00 
  8000a1:	c7 44 24 04 00 b0 fe 	movl   $0xffeb000,0x4(%esp)
  8000a8:	0f 
  8000a9:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8000b0:	e8 86 12 00 00       	call   80133b <sys_page_alloc>
  8000b5:	85 c0                	test   %eax,%eax
  8000b7:	79 20                	jns    8000d9 <umain+0x99>
			panic("sys_page_alloc: %e", r);
  8000b9:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8000bd:	c7 44 24 08 8a 2f 80 	movl   $0x802f8a,0x8(%esp)
  8000c4:	00 
  8000c5:	c7 44 24 04 1e 00 00 	movl   $0x1e,0x4(%esp)
  8000cc:	00 
  8000cd:	c7 04 24 79 2f 80 00 	movl   $0x802f79,(%esp)
  8000d4:	e8 eb 02 00 00       	call   8003c4 <_panic>
		pkt->jp_len = snprintf(pkt->jp_data,
  8000d9:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  8000dd:	c7 44 24 08 9d 2f 80 	movl   $0x802f9d,0x8(%esp)
  8000e4:	00 
  8000e5:	c7 44 24 04 fc 0f 00 	movl   $0xffc,0x4(%esp)
  8000ec:	00 
  8000ed:	c7 04 24 04 b0 fe 0f 	movl   $0xffeb004,(%esp)
  8000f4:	e8 b3 09 00 00       	call   800aac <snprintf>
  8000f9:	a3 00 b0 fe 0f       	mov    %eax,0xffeb000
				       PGSIZE - sizeof(pkt->jp_len),
				       "Packet %02d", i);
		cprintf("Transmitting packet %d\n", i);
  8000fe:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  800102:	c7 04 24 a9 2f 80 00 	movl   $0x802fa9,(%esp)
  800109:	e8 7b 03 00 00       	call   800489 <cprintf>
		ipc_send(output_envid, NSREQ_OUTPUT, pkt, PTE_P|PTE_W|PTE_U);
  80010e:	c7 44 24 0c 07 00 00 	movl   $0x7,0xc(%esp)
  800115:	00 
  800116:	c7 44 24 08 00 b0 fe 	movl   $0xffeb000,0x8(%esp)
  80011d:	0f 
  80011e:	c7 44 24 04 0b 00 00 	movl   $0xb,0x4(%esp)
  800125:	00 
  800126:	a1 74 70 80 00       	mov    0x807074,%eax
  80012b:	89 04 24             	mov    %eax,(%esp)
  80012e:	e8 ed 16 00 00       	call   801820 <ipc_send>
		sys_page_unmap(0, pkt);
  800133:	c7 44 24 04 00 b0 fe 	movl   $0xffeb000,0x4(%esp)
  80013a:	0f 
  80013b:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  800142:	e8 38 11 00 00       	call   80127f <sys_page_unmap>
	else if (output_envid == 0) {
		output(ns_envid);
		return;
	}

	for (i = 0; i < TESTOUTPUT_COUNT; i++) {
  800147:	83 c3 01             	add    $0x1,%ebx
  80014a:	83 fb 0a             	cmp    $0xa,%ebx
  80014d:	0f 85 46 ff ff ff    	jne    800099 <umain+0x59>
  800153:	b3 00                	mov    $0x0,%bl
		sys_page_unmap(0, pkt);
	}

	// Spin for a while, just in case IPC's or packets need to be flushed
	for (i = 0; i < TESTOUTPUT_COUNT*2; i++)
		sys_yield();
  800155:	e8 40 12 00 00       	call   80139a <sys_yield>
		ipc_send(output_envid, NSREQ_OUTPUT, pkt, PTE_P|PTE_W|PTE_U);
		sys_page_unmap(0, pkt);
	}

	// Spin for a while, just in case IPC's or packets need to be flushed
	for (i = 0; i < TESTOUTPUT_COUNT*2; i++)
  80015a:	83 c3 01             	add    $0x1,%ebx
  80015d:	83 fb 14             	cmp    $0x14,%ebx
  800160:	75 f3                	jne    800155 <umain+0x115>
		sys_yield();
}
  800162:	83 c4 10             	add    $0x10,%esp
  800165:	5b                   	pop    %ebx
  800166:	5e                   	pop    %esi
  800167:	5d                   	pop    %ebp
  800168:	c3                   	ret    
  800169:	00 00                	add    %al,(%eax)
  80016b:	00 00                	add    %al,(%eax)
  80016d:	00 00                	add    %al,(%eax)
	...

00800170 <timer>:
#include "ns.h"

void
timer(envid_t ns_envid, uint32_t initial_to) {
  800170:	55                   	push   %ebp
  800171:	89 e5                	mov    %esp,%ebp
  800173:	57                   	push   %edi
  800174:	56                   	push   %esi
  800175:	53                   	push   %ebx
  800176:	83 ec 2c             	sub    $0x2c,%esp
  800179:	8b 75 08             	mov    0x8(%ebp),%esi
	uint32_t stop = sys_time_msec() + initial_to;
  80017c:	e8 1b 0f 00 00       	call   80109c <sys_time_msec>
  800181:	89 c3                	mov    %eax,%ebx
  800183:	03 5d 0c             	add    0xc(%ebp),%ebx

	binaryname = "ns_timer";
  800186:	c7 05 00 70 80 00 c1 	movl   $0x802fc1,0x807000
  80018d:	2f 80 00 

		ipc_send(ns_envid, NSREQ_TIMER, 0, 0);

		while (1) {
			uint32_t to, whom;
			to = ipc_recv((int32_t *) &whom, 0, 0);
  800190:	8d 7d e4             	lea    -0x1c(%ebp),%edi
  800193:	eb 05                	jmp    80019a <timer+0x2a>

	binaryname = "ns_timer";

	while (1) {
		while(sys_time_msec() < stop) {
			sys_yield();
  800195:	e8 00 12 00 00       	call   80139a <sys_yield>
	uint32_t stop = sys_time_msec() + initial_to;

	binaryname = "ns_timer";

	while (1) {
		while(sys_time_msec() < stop) {
  80019a:	e8 fd 0e 00 00       	call   80109c <sys_time_msec>
  80019f:	39 c3                	cmp    %eax,%ebx
  8001a1:	77 f2                	ja     800195 <timer+0x25>
			sys_yield();
		}

		ipc_send(ns_envid, NSREQ_TIMER, 0, 0);
  8001a3:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  8001aa:	00 
  8001ab:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  8001b2:	00 
  8001b3:	c7 44 24 04 0c 00 00 	movl   $0xc,0x4(%esp)
  8001ba:	00 
  8001bb:	89 34 24             	mov    %esi,(%esp)
  8001be:	e8 5d 16 00 00       	call   801820 <ipc_send>

		while (1) {
			uint32_t to, whom;
			to = ipc_recv((int32_t *) &whom, 0, 0);
  8001c3:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  8001ca:	00 
  8001cb:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  8001d2:	00 
  8001d3:	89 3c 24             	mov    %edi,(%esp)
  8001d6:	e8 ab 16 00 00       	call   801886 <ipc_recv>
  8001db:	89 c3                	mov    %eax,%ebx

			if (whom != ns_envid) {
  8001dd:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8001e0:	39 c6                	cmp    %eax,%esi
  8001e2:	74 12                	je     8001f6 <timer+0x86>
				cprintf("NS TIMER: timer thread got IPC message from env %x not NS\n", whom);
  8001e4:	89 44 24 04          	mov    %eax,0x4(%esp)
  8001e8:	c7 04 24 cc 2f 80 00 	movl   $0x802fcc,(%esp)
  8001ef:	e8 95 02 00 00       	call   800489 <cprintf>
				continue;
			}

			stop = sys_time_msec() + to;
			break;
		}
  8001f4:	eb cd                	jmp    8001c3 <timer+0x53>
			if (whom != ns_envid) {
				cprintf("NS TIMER: timer thread got IPC message from env %x not NS\n", whom);
				continue;
			}

			stop = sys_time_msec() + to;
  8001f6:	e8 a1 0e 00 00       	call   80109c <sys_time_msec>
  8001fb:	8d 1c 18             	lea    (%eax,%ebx,1),%ebx
  8001fe:	66 90                	xchg   %ax,%ax
  800200:	eb 98                	jmp    80019a <timer+0x2a>
	...

00800210 <input>:

extern union Nsipc nsipcbuf;

void
input(envid_t ns_envid)
{
  800210:	55                   	push   %ebp
  800211:	89 e5                	mov    %esp,%ebp
  800213:	53                   	push   %ebx
  800214:	83 ec 14             	sub    $0x14,%esp
  800217:	8b 5d 08             	mov    0x8(%ebp),%ebx
	binaryname = "ns_input";
  80021a:	c7 05 00 70 80 00 07 	movl   $0x803007,0x807000
  800221:	30 80 00 
	int len;

	while (1)
	{

		if (sys_page_alloc(0, &nsipcbuf, PTE_U | PTE_P | PTE_W) < 0)
  800224:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  80022b:	00 
  80022c:	c7 44 24 04 00 60 80 	movl   $0x806000,0x4(%esp)
  800233:	00 
  800234:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80023b:	e8 fb 10 00 00       	call   80133b <sys_page_alloc>
  800240:	85 c0                	test   %eax,%eax
  800242:	79 0e                	jns    800252 <input+0x42>
		{
			cprintf("\n input.c: error in sys_page_alloc");
  800244:	c7 04 24 2c 30 80 00 	movl   $0x80302c,(%esp)
  80024b:	e8 39 02 00 00       	call   800489 <cprintf>
			continue;
  800250:	eb d2                	jmp    800224 <input+0x14>
		}
		len = sys_receive_packet(nsipcbuf.pkt.jp_data);
  800252:	c7 04 24 04 60 80 00 	movl   $0x806004,(%esp)
  800259:	e8 ab 0d 00 00       	call   801009 <sys_receive_packet>
		if (len < 0)
  80025e:	85 c0                	test   %eax,%eax
  800260:	79 13                	jns    800275 <input+0x65>
		{
			// there was an error in sys_receive_packet, print the message and continue
			cprintf("\n input.c: error in receive");	
  800262:	c7 04 24 10 30 80 00 	movl   $0x803010,(%esp)
  800269:	e8 1b 02 00 00       	call   800489 <cprintf>
			sys_yield();
  80026e:	e8 27 11 00 00       	call   80139a <sys_yield>
			continue;
  800273:	eb af                	jmp    800224 <input+0x14>
		}
		else if (len == 0)
  800275:	85 c0                	test   %eax,%eax
  800277:	75 0e                	jne    800287 <input+0x77>
		{
			// nothing was received, continue
			sys_yield();
  800279:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  800280:	e8 15 11 00 00       	call   80139a <sys_yield>
			continue;
  800285:	eb 9d                	jmp    800224 <input+0x14>
		}
		else 
		{
			//cprintf("\n input.c: ipc_send");
			nsipcbuf.pkt.jp_len = len;	
  800287:	a3 00 60 80 00       	mov    %eax,0x806000
			ipc_send(ns_envid, NSREQ_INPUT, &nsipcbuf, PTE_P | PTE_U | PTE_W);
  80028c:	c7 44 24 0c 07 00 00 	movl   $0x7,0xc(%esp)
  800293:	00 
  800294:	c7 44 24 08 00 60 80 	movl   $0x806000,0x8(%esp)
  80029b:	00 
  80029c:	c7 44 24 04 0a 00 00 	movl   $0xa,0x4(%esp)
  8002a3:	00 
  8002a4:	89 1c 24             	mov    %ebx,(%esp)
  8002a7:	e8 74 15 00 00       	call   801820 <ipc_send>
		}
		sys_page_unmap(0, &nsipcbuf);
  8002ac:	c7 44 24 04 00 60 80 	movl   $0x806000,0x4(%esp)
  8002b3:	00 
  8002b4:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8002bb:	e8 bf 0f 00 00       	call   80127f <sys_page_unmap>
  8002c0:	e9 5f ff ff ff       	jmp    800224 <input+0x14>
	...

008002d0 <output>:

extern union Nsipc nsipcbuf;

void
output(envid_t ns_envid)
{
  8002d0:	55                   	push   %ebp
  8002d1:	89 e5                	mov    %esp,%ebp
  8002d3:	57                   	push   %edi
  8002d4:	56                   	push   %esi
  8002d5:	53                   	push   %ebx
  8002d6:	83 ec 2c             	sub    $0x2c,%esp
  8002d9:	8b 7d 08             	mov    0x8(%ebp),%edi
	binaryname = "ns_output";
  8002dc:	c7 05 00 70 80 00 4f 	movl   $0x80304f,0x807000
  8002e3:	30 80 00 
	uint32_t request;
	int perm;
	while(1)
	{
		perm = 0;
		request = ipc_recv(&from_env, (void*)&nsipcbuf, &perm);
  8002e6:	8d 5d e0             	lea    -0x20(%ebp),%ebx
  8002e9:	8d 75 e4             	lea    -0x1c(%ebp),%esi
	envid_t from_env;
	uint32_t request;
	int perm;
	while(1)
	{
		perm = 0;
  8002ec:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
		request = ipc_recv(&from_env, (void*)&nsipcbuf, &perm);
  8002f3:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8002f7:	c7 44 24 04 00 60 80 	movl   $0x806000,0x4(%esp)
  8002fe:	00 
  8002ff:	89 34 24             	mov    %esi,(%esp)
  800302:	e8 7f 15 00 00       	call   801886 <ipc_recv>
		if (!(perm & PTE_P))
  800307:	f6 45 e0 01          	testb  $0x1,-0x20(%ebp)
  80030b:	75 0e                	jne    80031b <output+0x4b>
		{
			cprintf("\n output.c : Page not present! ");
  80030d:	c7 04 24 5c 30 80 00 	movl   $0x80305c,(%esp)
  800314:	e8 70 01 00 00       	call   800489 <cprintf>
			continue;
  800319:	eb d1                	jmp    8002ec <output+0x1c>
		}
		if (from_env != ns_envid)
  80031b:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
  80031e:	74 0e                	je     80032e <output+0x5e>
		{
			cprintf("\n output.c : Request received from bogus environment! ");
  800320:	c7 04 24 7c 30 80 00 	movl   $0x80307c,(%esp)
  800327:	e8 5d 01 00 00       	call   800489 <cprintf>
			continue;
  80032c:	eb be                	jmp    8002ec <output+0x1c>
		}
		if (request == NSREQ_OUTPUT)
  80032e:	83 f8 0b             	cmp    $0xb,%eax
  800331:	75 17                	jne    80034a <output+0x7a>
		{	
			sys_transmit_packet(nsipcbuf.pkt.jp_data, nsipcbuf.pkt.jp_len);
  800333:	a1 00 60 80 00       	mov    0x806000,%eax
  800338:	89 44 24 04          	mov    %eax,0x4(%esp)
  80033c:	c7 04 24 04 60 80 00 	movl   $0x806004,(%esp)
  800343:	e8 f6 0c 00 00       	call   80103e <sys_transmit_packet>
  800348:	eb a2                	jmp    8002ec <output+0x1c>
		}
		else
			cprintf("\n output.c : Invalid request received! ");
  80034a:	c7 04 24 b4 30 80 00 	movl   $0x8030b4,(%esp)
  800351:	e8 33 01 00 00       	call   800489 <cprintf>
  800356:	eb 94                	jmp    8002ec <output+0x1c>

00800358 <libmain>:
volatile struct Env *env;
char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  800358:	55                   	push   %ebp
  800359:	89 e5                	mov    %esp,%ebp
  80035b:	83 ec 18             	sub    $0x18,%esp
  80035e:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  800361:	89 75 fc             	mov    %esi,-0x4(%ebp)
  800364:	8b 75 08             	mov    0x8(%ebp),%esi
  800367:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	// set env to point at our env structure in envs[].
	// LAB 3b: Your code here.
	// Code added by Swastika / Sandeep	
	envid_t envid = sys_getenvid();
  80036a:	e8 5f 10 00 00       	call   8013ce <sys_getenvid>
	env = &envs[ENVX(envid)];
  80036f:	25 ff 03 00 00       	and    $0x3ff,%eax
  800374:	6b c0 7c             	imul   $0x7c,%eax,%eax
  800377:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  80037c:	a3 78 70 80 00       	mov    %eax,0x807078

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800381:	85 f6                	test   %esi,%esi
  800383:	7e 07                	jle    80038c <libmain+0x34>
		binaryname = argv[0];
  800385:	8b 03                	mov    (%ebx),%eax
  800387:	a3 00 70 80 00       	mov    %eax,0x807000

	// call user main routine
	umain(argc, argv);
  80038c:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  800390:	89 34 24             	mov    %esi,(%esp)
  800393:	e8 a8 fc ff ff       	call   800040 <umain>

	// exit gracefully
	exit();
  800398:	e8 0b 00 00 00       	call   8003a8 <exit>
}
  80039d:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  8003a0:	8b 75 fc             	mov    -0x4(%ebp),%esi
  8003a3:	89 ec                	mov    %ebp,%esp
  8003a5:	5d                   	pop    %ebp
  8003a6:	c3                   	ret    
	...

008003a8 <exit>:
#include <inc/lib.h>

void
exit(void)
{
  8003a8:	55                   	push   %ebp
  8003a9:	89 e5                	mov    %esp,%ebp
  8003ab:	83 ec 18             	sub    $0x18,%esp
	close_all();
  8003ae:	e8 18 1a 00 00       	call   801dcb <close_all>
	sys_env_destroy(0);
  8003b3:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8003ba:	e8 43 10 00 00       	call   801402 <sys_env_destroy>
}
  8003bf:	c9                   	leave  
  8003c0:	c3                   	ret    
  8003c1:	00 00                	add    %al,(%eax)
	...

008003c4 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  8003c4:	55                   	push   %ebp
  8003c5:	89 e5                	mov    %esp,%ebp
  8003c7:	53                   	push   %ebx
  8003c8:	83 ec 14             	sub    $0x14,%esp
 * Panic is called on unresolvable fatal errors.
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
  8003cb:	8d 5d 14             	lea    0x14(%ebp),%ebx
	va_list ap;

	va_start(ap, fmt);

	// Print the panic message
	if (argv0)
  8003ce:	a1 7c 70 80 00       	mov    0x80707c,%eax
  8003d3:	85 c0                	test   %eax,%eax
  8003d5:	74 10                	je     8003e7 <_panic+0x23>
		cprintf("%s: ", argv0);
  8003d7:	89 44 24 04          	mov    %eax,0x4(%esp)
  8003db:	c7 04 24 f3 30 80 00 	movl   $0x8030f3,(%esp)
  8003e2:	e8 a2 00 00 00       	call   800489 <cprintf>
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  8003e7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8003ea:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8003ee:	8b 45 08             	mov    0x8(%ebp),%eax
  8003f1:	89 44 24 08          	mov    %eax,0x8(%esp)
  8003f5:	a1 00 70 80 00       	mov    0x807000,%eax
  8003fa:	89 44 24 04          	mov    %eax,0x4(%esp)
  8003fe:	c7 04 24 f8 30 80 00 	movl   $0x8030f8,(%esp)
  800405:	e8 7f 00 00 00       	call   800489 <cprintf>
	vcprintf(fmt, ap);
  80040a:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  80040e:	8b 45 10             	mov    0x10(%ebp),%eax
  800411:	89 04 24             	mov    %eax,(%esp)
  800414:	e8 0f 00 00 00       	call   800428 <vcprintf>
	cprintf("\n");
  800419:	c7 04 24 bf 2f 80 00 	movl   $0x802fbf,(%esp)
  800420:	e8 64 00 00 00       	call   800489 <cprintf>

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  800425:	cc                   	int3   
  800426:	eb fd                	jmp    800425 <_panic+0x61>

00800428 <vcprintf>:
	b->cnt++;
}

int
vcprintf(const char *fmt, va_list ap)
{
  800428:	55                   	push   %ebp
  800429:	89 e5                	mov    %esp,%ebp
  80042b:	81 ec 28 01 00 00    	sub    $0x128,%esp
	struct printbuf b;

	b.idx = 0;
  800431:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800438:	00 00 00 
	b.cnt = 0;
  80043b:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800442:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  800445:	8b 45 0c             	mov    0xc(%ebp),%eax
  800448:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80044c:	8b 45 08             	mov    0x8(%ebp),%eax
  80044f:	89 44 24 08          	mov    %eax,0x8(%esp)
  800453:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800459:	89 44 24 04          	mov    %eax,0x4(%esp)
  80045d:	c7 04 24 a3 04 80 00 	movl   $0x8004a3,(%esp)
  800464:	e8 d4 01 00 00       	call   80063d <vprintfmt>
	sys_cputs(b.buf, b.idx);
  800469:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
  80046f:	89 44 24 04          	mov    %eax,0x4(%esp)
  800473:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  800479:	89 04 24             	mov    %eax,(%esp)
  80047c:	e8 bf 0a 00 00       	call   800f40 <sys_cputs>

	return b.cnt;
}
  800481:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  800487:	c9                   	leave  
  800488:	c3                   	ret    

00800489 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  800489:	55                   	push   %ebp
  80048a:	89 e5                	mov    %esp,%ebp
  80048c:	83 ec 18             	sub    $0x18,%esp

	return b.cnt;
}

int
cprintf(const char *fmt, ...)
  80048f:	8d 45 0c             	lea    0xc(%ebp),%eax
{
	va_list ap;
	int cnt;

	va_start(ap, fmt);
	cnt = vcprintf(fmt, ap);
  800492:	89 44 24 04          	mov    %eax,0x4(%esp)
  800496:	8b 45 08             	mov    0x8(%ebp),%eax
  800499:	89 04 24             	mov    %eax,(%esp)
  80049c:	e8 87 ff ff ff       	call   800428 <vcprintf>
	va_end(ap);

	return cnt;
}
  8004a1:	c9                   	leave  
  8004a2:	c3                   	ret    

008004a3 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  8004a3:	55                   	push   %ebp
  8004a4:	89 e5                	mov    %esp,%ebp
  8004a6:	53                   	push   %ebx
  8004a7:	83 ec 14             	sub    $0x14,%esp
  8004aa:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  8004ad:	8b 03                	mov    (%ebx),%eax
  8004af:	8b 55 08             	mov    0x8(%ebp),%edx
  8004b2:	88 54 03 08          	mov    %dl,0x8(%ebx,%eax,1)
  8004b6:	83 c0 01             	add    $0x1,%eax
  8004b9:	89 03                	mov    %eax,(%ebx)
	if (b->idx == 256-1) {
  8004bb:	3d ff 00 00 00       	cmp    $0xff,%eax
  8004c0:	75 19                	jne    8004db <putch+0x38>
		sys_cputs(b->buf, b->idx);
  8004c2:	c7 44 24 04 ff 00 00 	movl   $0xff,0x4(%esp)
  8004c9:	00 
  8004ca:	8d 43 08             	lea    0x8(%ebx),%eax
  8004cd:	89 04 24             	mov    %eax,(%esp)
  8004d0:	e8 6b 0a 00 00       	call   800f40 <sys_cputs>
		b->idx = 0;
  8004d5:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
	}
	b->cnt++;
  8004db:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  8004df:	83 c4 14             	add    $0x14,%esp
  8004e2:	5b                   	pop    %ebx
  8004e3:	5d                   	pop    %ebp
  8004e4:	c3                   	ret    
	...

008004f0 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8004f0:	55                   	push   %ebp
  8004f1:	89 e5                	mov    %esp,%ebp
  8004f3:	57                   	push   %edi
  8004f4:	56                   	push   %esi
  8004f5:	53                   	push   %ebx
  8004f6:	83 ec 4c             	sub    $0x4c,%esp
  8004f9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8004fc:	89 d6                	mov    %edx,%esi
  8004fe:	8b 45 08             	mov    0x8(%ebp),%eax
  800501:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800504:	8b 55 0c             	mov    0xc(%ebp),%edx
  800507:	89 55 e0             	mov    %edx,-0x20(%ebp)
  80050a:	8b 45 10             	mov    0x10(%ebp),%eax
  80050d:	8b 5d 14             	mov    0x14(%ebp),%ebx
  800510:	8b 7d 18             	mov    0x18(%ebp),%edi
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800513:	89 45 dc             	mov    %eax,-0x24(%ebp)
  800516:	b9 00 00 00 00       	mov    $0x0,%ecx
  80051b:	39 d1                	cmp    %edx,%ecx
  80051d:	72 15                	jb     800534 <printnum+0x44>
  80051f:	77 07                	ja     800528 <printnum+0x38>
  800521:	8b 55 d8             	mov    -0x28(%ebp),%edx
  800524:	39 d0                	cmp    %edx,%eax
  800526:	76 0c                	jbe    800534 <printnum+0x44>
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800528:	83 eb 01             	sub    $0x1,%ebx
  80052b:	85 db                	test   %ebx,%ebx
  80052d:	8d 76 00             	lea    0x0(%esi),%esi
  800530:	7f 61                	jg     800593 <printnum+0xa3>
  800532:	eb 70                	jmp    8005a4 <printnum+0xb4>
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800534:	89 7c 24 10          	mov    %edi,0x10(%esp)
  800538:	83 eb 01             	sub    $0x1,%ebx
  80053b:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  80053f:	89 44 24 08          	mov    %eax,0x8(%esp)
  800543:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  800547:	8b 5c 24 0c          	mov    0xc(%esp),%ebx
  80054b:	89 4d d0             	mov    %ecx,-0x30(%ebp)
  80054e:	89 5d d4             	mov    %ebx,-0x2c(%ebp)
  800551:	8b 5d dc             	mov    -0x24(%ebp),%ebx
  800554:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  800558:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  80055f:	00 
  800560:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800563:	89 04 24             	mov    %eax,(%esp)
  800566:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800569:	89 54 24 04          	mov    %edx,0x4(%esp)
  80056d:	e8 7e 27 00 00       	call   802cf0 <__udivdi3>
  800572:	8b 4d d0             	mov    -0x30(%ebp),%ecx
  800575:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
  800578:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  80057c:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  800580:	89 04 24             	mov    %eax,(%esp)
  800583:	89 54 24 04          	mov    %edx,0x4(%esp)
  800587:	89 f2                	mov    %esi,%edx
  800589:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80058c:	e8 5f ff ff ff       	call   8004f0 <printnum>
  800591:	eb 11                	jmp    8005a4 <printnum+0xb4>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800593:	89 74 24 04          	mov    %esi,0x4(%esp)
  800597:	89 3c 24             	mov    %edi,(%esp)
  80059a:	ff 55 e4             	call   *-0x1c(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  80059d:	83 eb 01             	sub    $0x1,%ebx
  8005a0:	85 db                	test   %ebx,%ebx
  8005a2:	7f ef                	jg     800593 <printnum+0xa3>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8005a4:	89 74 24 04          	mov    %esi,0x4(%esp)
  8005a8:	8b 74 24 04          	mov    0x4(%esp),%esi
  8005ac:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8005af:	89 44 24 08          	mov    %eax,0x8(%esp)
  8005b3:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  8005ba:	00 
  8005bb:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8005be:	89 14 24             	mov    %edx,(%esp)
  8005c1:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  8005c4:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8005c8:	e8 53 28 00 00       	call   802e20 <__umoddi3>
  8005cd:	89 74 24 04          	mov    %esi,0x4(%esp)
  8005d1:	0f be 80 14 31 80 00 	movsbl 0x803114(%eax),%eax
  8005d8:	89 04 24             	mov    %eax,(%esp)
  8005db:	ff 55 e4             	call   *-0x1c(%ebp)
}
  8005de:	83 c4 4c             	add    $0x4c,%esp
  8005e1:	5b                   	pop    %ebx
  8005e2:	5e                   	pop    %esi
  8005e3:	5f                   	pop    %edi
  8005e4:	5d                   	pop    %ebp
  8005e5:	c3                   	ret    

008005e6 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  8005e6:	55                   	push   %ebp
  8005e7:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8005e9:	83 fa 01             	cmp    $0x1,%edx
  8005ec:	7e 0e                	jle    8005fc <getuint+0x16>
		return va_arg(*ap, unsigned long long);
  8005ee:	8b 10                	mov    (%eax),%edx
  8005f0:	8d 4a 08             	lea    0x8(%edx),%ecx
  8005f3:	89 08                	mov    %ecx,(%eax)
  8005f5:	8b 02                	mov    (%edx),%eax
  8005f7:	8b 52 04             	mov    0x4(%edx),%edx
  8005fa:	eb 22                	jmp    80061e <getuint+0x38>
	else if (lflag)
  8005fc:	85 d2                	test   %edx,%edx
  8005fe:	74 10                	je     800610 <getuint+0x2a>
		return va_arg(*ap, unsigned long);
  800600:	8b 10                	mov    (%eax),%edx
  800602:	8d 4a 04             	lea    0x4(%edx),%ecx
  800605:	89 08                	mov    %ecx,(%eax)
  800607:	8b 02                	mov    (%edx),%eax
  800609:	ba 00 00 00 00       	mov    $0x0,%edx
  80060e:	eb 0e                	jmp    80061e <getuint+0x38>
	else
		return va_arg(*ap, unsigned int);
  800610:	8b 10                	mov    (%eax),%edx
  800612:	8d 4a 04             	lea    0x4(%edx),%ecx
  800615:	89 08                	mov    %ecx,(%eax)
  800617:	8b 02                	mov    (%edx),%eax
  800619:	ba 00 00 00 00       	mov    $0x0,%edx
}
  80061e:	5d                   	pop    %ebp
  80061f:	c3                   	ret    

00800620 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800620:	55                   	push   %ebp
  800621:	89 e5                	mov    %esp,%ebp
  800623:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  800626:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  80062a:	8b 10                	mov    (%eax),%edx
  80062c:	3b 50 04             	cmp    0x4(%eax),%edx
  80062f:	73 0a                	jae    80063b <sprintputch+0x1b>
		*b->buf++ = ch;
  800631:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800634:	88 0a                	mov    %cl,(%edx)
  800636:	83 c2 01             	add    $0x1,%edx
  800639:	89 10                	mov    %edx,(%eax)
}
  80063b:	5d                   	pop    %ebp
  80063c:	c3                   	ret    

0080063d <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  80063d:	55                   	push   %ebp
  80063e:	89 e5                	mov    %esp,%ebp
  800640:	57                   	push   %edi
  800641:	56                   	push   %esi
  800642:	53                   	push   %ebx
  800643:	83 ec 5c             	sub    $0x5c,%esp
  800646:	8b 7d 08             	mov    0x8(%ebp),%edi
  800649:	8b 75 0c             	mov    0xc(%ebp),%esi
  80064c:	8b 5d 10             	mov    0x10(%ebp),%ebx
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  80064f:	c7 45 c8 ff ff ff ff 	movl   $0xffffffff,-0x38(%ebp)
  800656:	eb 11                	jmp    800669 <vprintfmt+0x2c>
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
  800658:	85 c0                	test   %eax,%eax
  80065a:	0f 84 ec 03 00 00    	je     800a4c <vprintfmt+0x40f>
				return;
			putch(ch, putdat);
  800660:	89 74 24 04          	mov    %esi,0x4(%esp)
  800664:	89 04 24             	mov    %eax,(%esp)
  800667:	ff d7                	call   *%edi
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800669:	0f b6 03             	movzbl (%ebx),%eax
  80066c:	83 c3 01             	add    $0x1,%ebx
  80066f:	83 f8 25             	cmp    $0x25,%eax
  800672:	75 e4                	jne    800658 <vprintfmt+0x1b>
  800674:	c6 45 d4 20          	movb   $0x20,-0x2c(%ebp)
  800678:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
  80067f:	c7 45 d0 ff ff ff ff 	movl   $0xffffffff,-0x30(%ebp)
  800686:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
  80068d:	b9 00 00 00 00       	mov    $0x0,%ecx
  800692:	eb 06                	jmp    80069a <vprintfmt+0x5d>
  800694:	c6 45 d4 2d          	movb   $0x2d,-0x2c(%ebp)
  800698:	89 c3                	mov    %eax,%ebx
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80069a:	0f b6 13             	movzbl (%ebx),%edx
  80069d:	0f b6 c2             	movzbl %dl,%eax
  8006a0:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8006a3:	8d 43 01             	lea    0x1(%ebx),%eax
  8006a6:	83 ea 23             	sub    $0x23,%edx
  8006a9:	80 fa 55             	cmp    $0x55,%dl
  8006ac:	0f 87 7d 03 00 00    	ja     800a2f <vprintfmt+0x3f2>
  8006b2:	0f b6 d2             	movzbl %dl,%edx
  8006b5:	ff 24 95 60 32 80 00 	jmp    *0x803260(,%edx,4)
  8006bc:	c6 45 d4 30          	movb   $0x30,-0x2c(%ebp)
  8006c0:	eb d6                	jmp    800698 <vprintfmt+0x5b>
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
				precision = precision * 10 + ch - '0';
  8006c2:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8006c5:	83 ea 30             	sub    $0x30,%edx
  8006c8:	89 55 d0             	mov    %edx,-0x30(%ebp)
				ch = *fmt;
  8006cb:	0f be 10             	movsbl (%eax),%edx
				if (ch < '0' || ch > '9')
  8006ce:	8d 5a d0             	lea    -0x30(%edx),%ebx
  8006d1:	83 fb 09             	cmp    $0x9,%ebx
  8006d4:	77 4c                	ja     800722 <vprintfmt+0xe5>
  8006d6:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  8006d9:	8b 4d d0             	mov    -0x30(%ebp),%ecx
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8006dc:	83 c0 01             	add    $0x1,%eax
				precision = precision * 10 + ch - '0';
  8006df:	8d 0c 89             	lea    (%ecx,%ecx,4),%ecx
  8006e2:	8d 4c 4a d0          	lea    -0x30(%edx,%ecx,2),%ecx
				ch = *fmt;
  8006e6:	0f be 10             	movsbl (%eax),%edx
				if (ch < '0' || ch > '9')
  8006e9:	8d 5a d0             	lea    -0x30(%edx),%ebx
  8006ec:	83 fb 09             	cmp    $0x9,%ebx
  8006ef:	76 eb                	jbe    8006dc <vprintfmt+0x9f>
  8006f1:	89 4d d0             	mov    %ecx,-0x30(%ebp)
  8006f4:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  8006f7:	eb 29                	jmp    800722 <vprintfmt+0xe5>
					break;
			}
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  8006f9:	8b 55 14             	mov    0x14(%ebp),%edx
  8006fc:	8d 5a 04             	lea    0x4(%edx),%ebx
  8006ff:	89 5d 14             	mov    %ebx,0x14(%ebp)
  800702:	8b 12                	mov    (%edx),%edx
  800704:	89 55 d0             	mov    %edx,-0x30(%ebp)
			goto process_precision;
  800707:	eb 19                	jmp    800722 <vprintfmt+0xe5>

		case '.':
			if (width < 0)
  800709:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80070c:	c1 fa 1f             	sar    $0x1f,%edx
  80070f:	f7 d2                	not    %edx
  800711:	21 55 e4             	and    %edx,-0x1c(%ebp)
  800714:	eb 82                	jmp    800698 <vprintfmt+0x5b>
  800716:	c7 45 d8 01 00 00 00 	movl   $0x1,-0x28(%ebp)
				width = 0;
			goto reswitch;

		case '#':
			altflag = 1;
			goto reswitch;
  80071d:	e9 76 ff ff ff       	jmp    800698 <vprintfmt+0x5b>

		process_precision:
			if (width < 0)
  800722:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800726:	0f 89 6c ff ff ff    	jns    800698 <vprintfmt+0x5b>
  80072c:	8b 55 d0             	mov    -0x30(%ebp),%edx
  80072f:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  800732:	8b 55 c8             	mov    -0x38(%ebp),%edx
  800735:	89 55 d0             	mov    %edx,-0x30(%ebp)
  800738:	e9 5b ff ff ff       	jmp    800698 <vprintfmt+0x5b>
				width = precision, precision = -1;
			goto reswitch;

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  80073d:	83 c1 01             	add    $0x1,%ecx
			goto reswitch;
  800740:	e9 53 ff ff ff       	jmp    800698 <vprintfmt+0x5b>
  800745:	89 45 cc             	mov    %eax,-0x34(%ebp)

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800748:	8b 45 14             	mov    0x14(%ebp),%eax
  80074b:	8d 50 04             	lea    0x4(%eax),%edx
  80074e:	89 55 14             	mov    %edx,0x14(%ebp)
  800751:	89 74 24 04          	mov    %esi,0x4(%esp)
  800755:	8b 00                	mov    (%eax),%eax
  800757:	89 04 24             	mov    %eax,(%esp)
  80075a:	ff d7                	call   *%edi
  80075c:	8b 5d cc             	mov    -0x34(%ebp),%ebx
			break;
  80075f:	e9 05 ff ff ff       	jmp    800669 <vprintfmt+0x2c>
  800764:	89 45 cc             	mov    %eax,-0x34(%ebp)

		// error message
		case 'e':
			err = va_arg(ap, int);
  800767:	8b 45 14             	mov    0x14(%ebp),%eax
  80076a:	8d 50 04             	lea    0x4(%eax),%edx
  80076d:	89 55 14             	mov    %edx,0x14(%ebp)
  800770:	8b 00                	mov    (%eax),%eax
  800772:	89 c2                	mov    %eax,%edx
  800774:	c1 fa 1f             	sar    $0x1f,%edx
  800777:	31 d0                	xor    %edx,%eax
  800779:	29 d0                	sub    %edx,%eax
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  80077b:	83 f8 0f             	cmp    $0xf,%eax
  80077e:	7f 0b                	jg     80078b <vprintfmt+0x14e>
  800780:	8b 14 85 c0 33 80 00 	mov    0x8033c0(,%eax,4),%edx
  800787:	85 d2                	test   %edx,%edx
  800789:	75 20                	jne    8007ab <vprintfmt+0x16e>
				printfmt(putch, putdat, "error %d", err);
  80078b:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80078f:	c7 44 24 08 25 31 80 	movl   $0x803125,0x8(%esp)
  800796:	00 
  800797:	89 74 24 04          	mov    %esi,0x4(%esp)
  80079b:	89 3c 24             	mov    %edi,(%esp)
  80079e:	e8 31 03 00 00       	call   800ad4 <printfmt>
  8007a3:	8b 5d cc             	mov    -0x34(%ebp),%ebx
		// error message
		case 'e':
			err = va_arg(ap, int);
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  8007a6:	e9 be fe ff ff       	jmp    800669 <vprintfmt+0x2c>
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  8007ab:	89 54 24 0c          	mov    %edx,0xc(%esp)
  8007af:	c7 44 24 08 22 37 80 	movl   $0x803722,0x8(%esp)
  8007b6:	00 
  8007b7:	89 74 24 04          	mov    %esi,0x4(%esp)
  8007bb:	89 3c 24             	mov    %edi,(%esp)
  8007be:	e8 11 03 00 00       	call   800ad4 <printfmt>
  8007c3:	8b 5d cc             	mov    -0x34(%ebp),%ebx
  8007c6:	e9 9e fe ff ff       	jmp    800669 <vprintfmt+0x2c>
  8007cb:	89 45 cc             	mov    %eax,-0x34(%ebp)
  8007ce:	89 c3                	mov    %eax,%ebx
  8007d0:	8b 4d d0             	mov    -0x30(%ebp),%ecx
  8007d3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8007d6:	89 45 c4             	mov    %eax,-0x3c(%ebp)
			break;

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  8007d9:	8b 45 14             	mov    0x14(%ebp),%eax
  8007dc:	8d 50 04             	lea    0x4(%eax),%edx
  8007df:	89 55 14             	mov    %edx,0x14(%ebp)
  8007e2:	8b 00                	mov    (%eax),%eax
  8007e4:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8007e7:	85 c0                	test   %eax,%eax
  8007e9:	75 07                	jne    8007f2 <vprintfmt+0x1b5>
  8007eb:	c7 45 e0 2e 31 80 00 	movl   $0x80312e,-0x20(%ebp)
				p = "(null)";
			if (width > 0 && padc != '-')
  8007f2:	83 7d c4 00          	cmpl   $0x0,-0x3c(%ebp)
  8007f6:	7e 06                	jle    8007fe <vprintfmt+0x1c1>
  8007f8:	80 7d d4 2d          	cmpb   $0x2d,-0x2c(%ebp)
  8007fc:	75 13                	jne    800811 <vprintfmt+0x1d4>
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8007fe:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800801:	0f be 02             	movsbl (%edx),%eax
  800804:	85 c0                	test   %eax,%eax
  800806:	0f 85 99 00 00 00    	jne    8008a5 <vprintfmt+0x268>
  80080c:	e9 86 00 00 00       	jmp    800897 <vprintfmt+0x25a>
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800811:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  800815:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  800818:	89 0c 24             	mov    %ecx,(%esp)
  80081b:	e8 fb 02 00 00       	call   800b1b <strnlen>
  800820:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  800823:	29 c2                	sub    %eax,%edx
  800825:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  800828:	85 d2                	test   %edx,%edx
  80082a:	7e d2                	jle    8007fe <vprintfmt+0x1c1>
					putch(padc, putdat);
  80082c:	0f be 4d d4          	movsbl -0x2c(%ebp),%ecx
  800830:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  800833:	89 5d c4             	mov    %ebx,-0x3c(%ebp)
  800836:	89 d3                	mov    %edx,%ebx
  800838:	89 74 24 04          	mov    %esi,0x4(%esp)
  80083c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80083f:	89 04 24             	mov    %eax,(%esp)
  800842:	ff d7                	call   *%edi
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800844:	83 eb 01             	sub    $0x1,%ebx
  800847:	85 db                	test   %ebx,%ebx
  800849:	7f ed                	jg     800838 <vprintfmt+0x1fb>
  80084b:	8b 5d c4             	mov    -0x3c(%ebp),%ebx
  80084e:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  800855:	eb a7                	jmp    8007fe <vprintfmt+0x1c1>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
  800857:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  80085b:	74 18                	je     800875 <vprintfmt+0x238>
  80085d:	8d 50 e0             	lea    -0x20(%eax),%edx
  800860:	83 fa 5e             	cmp    $0x5e,%edx
  800863:	76 10                	jbe    800875 <vprintfmt+0x238>
					putch('?', putdat);
  800865:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800869:	c7 04 24 3f 00 00 00 	movl   $0x3f,(%esp)
  800870:	ff 55 e0             	call   *-0x20(%ebp)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
  800873:	eb 0a                	jmp    80087f <vprintfmt+0x242>
					putch('?', putdat);
				else
					putch(ch, putdat);
  800875:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800879:	89 04 24             	mov    %eax,(%esp)
  80087c:	ff 55 e0             	call   *-0x20(%ebp)
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  80087f:	83 6d e4 01          	subl   $0x1,-0x1c(%ebp)
  800883:	0f be 03             	movsbl (%ebx),%eax
  800886:	85 c0                	test   %eax,%eax
  800888:	74 05                	je     80088f <vprintfmt+0x252>
  80088a:	83 c3 01             	add    $0x1,%ebx
  80088d:	eb 29                	jmp    8008b8 <vprintfmt+0x27b>
  80088f:	89 fe                	mov    %edi,%esi
  800891:	8b 7d e0             	mov    -0x20(%ebp),%edi
  800894:	8b 5d d0             	mov    -0x30(%ebp),%ebx
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800897:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80089b:	7f 2e                	jg     8008cb <vprintfmt+0x28e>
  80089d:	8b 5d cc             	mov    -0x34(%ebp),%ebx
  8008a0:	e9 c4 fd ff ff       	jmp    800669 <vprintfmt+0x2c>
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8008a5:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8008a8:	83 c2 01             	add    $0x1,%edx
  8008ab:	89 7d e0             	mov    %edi,-0x20(%ebp)
  8008ae:	89 f7                	mov    %esi,%edi
  8008b0:	8b 75 d0             	mov    -0x30(%ebp),%esi
  8008b3:	89 5d d0             	mov    %ebx,-0x30(%ebp)
  8008b6:	89 d3                	mov    %edx,%ebx
  8008b8:	85 f6                	test   %esi,%esi
  8008ba:	78 9b                	js     800857 <vprintfmt+0x21a>
  8008bc:	83 ee 01             	sub    $0x1,%esi
  8008bf:	79 96                	jns    800857 <vprintfmt+0x21a>
  8008c1:	89 fe                	mov    %edi,%esi
  8008c3:	8b 7d e0             	mov    -0x20(%ebp),%edi
  8008c6:	8b 5d d0             	mov    -0x30(%ebp),%ebx
  8008c9:	eb cc                	jmp    800897 <vprintfmt+0x25a>
  8008cb:	89 5d d8             	mov    %ebx,-0x28(%ebp)
  8008ce:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
				putch(' ', putdat);
  8008d1:	89 74 24 04          	mov    %esi,0x4(%esp)
  8008d5:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  8008dc:	ff d7                	call   *%edi
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  8008de:	83 eb 01             	sub    $0x1,%ebx
  8008e1:	85 db                	test   %ebx,%ebx
  8008e3:	7f ec                	jg     8008d1 <vprintfmt+0x294>
  8008e5:	8b 5d d8             	mov    -0x28(%ebp),%ebx
  8008e8:	e9 7c fd ff ff       	jmp    800669 <vprintfmt+0x2c>
  8008ed:	89 45 cc             	mov    %eax,-0x34(%ebp)
// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
	if (lflag >= 2)
  8008f0:	83 f9 01             	cmp    $0x1,%ecx
  8008f3:	7e 16                	jle    80090b <vprintfmt+0x2ce>
		return va_arg(*ap, long long);
  8008f5:	8b 45 14             	mov    0x14(%ebp),%eax
  8008f8:	8d 50 08             	lea    0x8(%eax),%edx
  8008fb:	89 55 14             	mov    %edx,0x14(%ebp)
  8008fe:	8b 10                	mov    (%eax),%edx
  800900:	8b 48 04             	mov    0x4(%eax),%ecx
  800903:	89 55 d8             	mov    %edx,-0x28(%ebp)
  800906:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  800909:	eb 32                	jmp    80093d <vprintfmt+0x300>
	else if (lflag)
  80090b:	85 c9                	test   %ecx,%ecx
  80090d:	74 18                	je     800927 <vprintfmt+0x2ea>
		return va_arg(*ap, long);
  80090f:	8b 45 14             	mov    0x14(%ebp),%eax
  800912:	8d 50 04             	lea    0x4(%eax),%edx
  800915:	89 55 14             	mov    %edx,0x14(%ebp)
  800918:	8b 00                	mov    (%eax),%eax
  80091a:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80091d:	89 c1                	mov    %eax,%ecx
  80091f:	c1 f9 1f             	sar    $0x1f,%ecx
  800922:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  800925:	eb 16                	jmp    80093d <vprintfmt+0x300>
	else
		return va_arg(*ap, int);
  800927:	8b 45 14             	mov    0x14(%ebp),%eax
  80092a:	8d 50 04             	lea    0x4(%eax),%edx
  80092d:	89 55 14             	mov    %edx,0x14(%ebp)
  800930:	8b 00                	mov    (%eax),%eax
  800932:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800935:	89 c2                	mov    %eax,%edx
  800937:	c1 fa 1f             	sar    $0x1f,%edx
  80093a:	89 55 dc             	mov    %edx,-0x24(%ebp)
				putch(' ', putdat);
			break;

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  80093d:	8b 4d d8             	mov    -0x28(%ebp),%ecx
  800940:	8b 5d dc             	mov    -0x24(%ebp),%ebx
  800943:	b8 0a 00 00 00       	mov    $0xa,%eax
			if ((long long) num < 0) {
  800948:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  80094c:	0f 89 9b 00 00 00    	jns    8009ed <vprintfmt+0x3b0>
				putch('-', putdat);
  800952:	89 74 24 04          	mov    %esi,0x4(%esp)
  800956:	c7 04 24 2d 00 00 00 	movl   $0x2d,(%esp)
  80095d:	ff d7                	call   *%edi
				num = -(long long) num;
  80095f:	8b 4d d8             	mov    -0x28(%ebp),%ecx
  800962:	8b 5d dc             	mov    -0x24(%ebp),%ebx
  800965:	f7 d9                	neg    %ecx
  800967:	83 d3 00             	adc    $0x0,%ebx
  80096a:	f7 db                	neg    %ebx
  80096c:	b8 0a 00 00 00       	mov    $0xa,%eax
  800971:	eb 7a                	jmp    8009ed <vprintfmt+0x3b0>
  800973:	89 45 cc             	mov    %eax,-0x34(%ebp)
			base = 10;
			goto number;

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800976:	89 ca                	mov    %ecx,%edx
  800978:	8d 45 14             	lea    0x14(%ebp),%eax
  80097b:	e8 66 fc ff ff       	call   8005e6 <getuint>
  800980:	89 c1                	mov    %eax,%ecx
  800982:	89 d3                	mov    %edx,%ebx
  800984:	b8 0a 00 00 00       	mov    $0xa,%eax
			base = 10;
			goto number;
  800989:	eb 62                	jmp    8009ed <vprintfmt+0x3b0>
  80098b:	89 45 cc             	mov    %eax,-0x34(%ebp)
		case 'o':
			// Replace this with your code.
			// putch('X', putdat);
			// putch('X', putdat);
			// putch('X', putdat);
			num = getuint(&ap, lflag);
  80098e:	89 ca                	mov    %ecx,%edx
  800990:	8d 45 14             	lea    0x14(%ebp),%eax
  800993:	e8 4e fc ff ff       	call   8005e6 <getuint>
  800998:	89 c1                	mov    %eax,%ecx
  80099a:	89 d3                	mov    %edx,%ebx
  80099c:	b8 08 00 00 00       	mov    $0x8,%eax
			base = 8;
			goto number;
  8009a1:	eb 4a                	jmp    8009ed <vprintfmt+0x3b0>
  8009a3:	89 45 cc             	mov    %eax,-0x34(%ebp)
			break;

		// pointer
		case 'p':
			putch('0', putdat);
  8009a6:	89 74 24 04          	mov    %esi,0x4(%esp)
  8009aa:	c7 04 24 30 00 00 00 	movl   $0x30,(%esp)
  8009b1:	ff d7                	call   *%edi
			putch('x', putdat);
  8009b3:	89 74 24 04          	mov    %esi,0x4(%esp)
  8009b7:	c7 04 24 78 00 00 00 	movl   $0x78,(%esp)
  8009be:	ff d7                	call   *%edi
			num = (unsigned long long)
  8009c0:	8b 45 14             	mov    0x14(%ebp),%eax
  8009c3:	8d 50 04             	lea    0x4(%eax),%edx
  8009c6:	89 55 14             	mov    %edx,0x14(%ebp)
  8009c9:	8b 08                	mov    (%eax),%ecx
  8009cb:	bb 00 00 00 00       	mov    $0x0,%ebx
  8009d0:	b8 10 00 00 00       	mov    $0x10,%eax
				(uintptr_t) va_arg(ap, void *);
			base = 16;
			goto number;
  8009d5:	eb 16                	jmp    8009ed <vprintfmt+0x3b0>
  8009d7:	89 45 cc             	mov    %eax,-0x34(%ebp)

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  8009da:	89 ca                	mov    %ecx,%edx
  8009dc:	8d 45 14             	lea    0x14(%ebp),%eax
  8009df:	e8 02 fc ff ff       	call   8005e6 <getuint>
  8009e4:	89 c1                	mov    %eax,%ecx
  8009e6:	89 d3                	mov    %edx,%ebx
  8009e8:	b8 10 00 00 00       	mov    $0x10,%eax
			base = 16;
		number:
			printnum(putch, putdat, num, base, width, padc);
  8009ed:	0f be 55 d4          	movsbl -0x2c(%ebp),%edx
  8009f1:	89 54 24 10          	mov    %edx,0x10(%esp)
  8009f5:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8009f8:	89 54 24 0c          	mov    %edx,0xc(%esp)
  8009fc:	89 44 24 08          	mov    %eax,0x8(%esp)
  800a00:	89 0c 24             	mov    %ecx,(%esp)
  800a03:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  800a07:	89 f2                	mov    %esi,%edx
  800a09:	89 f8                	mov    %edi,%eax
  800a0b:	e8 e0 fa ff ff       	call   8004f0 <printnum>
  800a10:	8b 5d cc             	mov    -0x34(%ebp),%ebx
			break;
  800a13:	e9 51 fc ff ff       	jmp    800669 <vprintfmt+0x2c>
  800a18:	89 45 cc             	mov    %eax,-0x34(%ebp)
  800a1b:	8b 55 e0             	mov    -0x20(%ebp),%edx

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800a1e:	89 74 24 04          	mov    %esi,0x4(%esp)
  800a22:	89 14 24             	mov    %edx,(%esp)
  800a25:	ff d7                	call   *%edi
  800a27:	8b 5d cc             	mov    -0x34(%ebp),%ebx
			break;
  800a2a:	e9 3a fc ff ff       	jmp    800669 <vprintfmt+0x2c>
			
		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800a2f:	89 74 24 04          	mov    %esi,0x4(%esp)
  800a33:	c7 04 24 25 00 00 00 	movl   $0x25,(%esp)
  800a3a:	ff d7                	call   *%edi
			for (fmt--; fmt[-1] != '%'; fmt--)
  800a3c:	8d 43 ff             	lea    -0x1(%ebx),%eax
  800a3f:	80 38 25             	cmpb   $0x25,(%eax)
  800a42:	0f 84 21 fc ff ff    	je     800669 <vprintfmt+0x2c>
  800a48:	89 c3                	mov    %eax,%ebx
  800a4a:	eb f0                	jmp    800a3c <vprintfmt+0x3ff>
				/* do nothing */;
			break;
		}
	}
}
  800a4c:	83 c4 5c             	add    $0x5c,%esp
  800a4f:	5b                   	pop    %ebx
  800a50:	5e                   	pop    %esi
  800a51:	5f                   	pop    %edi
  800a52:	5d                   	pop    %ebp
  800a53:	c3                   	ret    

00800a54 <vsnprintf>:
		*b->buf++ = ch;
}

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800a54:	55                   	push   %ebp
  800a55:	89 e5                	mov    %esp,%ebp
  800a57:	83 ec 28             	sub    $0x28,%esp
  800a5a:	8b 45 08             	mov    0x8(%ebp),%eax
  800a5d:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};

	if (buf == NULL || n < 1)
  800a60:	85 c0                	test   %eax,%eax
  800a62:	74 04                	je     800a68 <vsnprintf+0x14>
  800a64:	85 d2                	test   %edx,%edx
  800a66:	7f 07                	jg     800a6f <vsnprintf+0x1b>
  800a68:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800a6d:	eb 3b                	jmp    800aaa <vsnprintf+0x56>
}

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
	struct sprintbuf b = {buf, buf+n-1, 0};
  800a6f:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800a72:	8d 44 10 ff          	lea    -0x1(%eax,%edx,1),%eax
  800a76:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a79:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800a80:	8b 45 14             	mov    0x14(%ebp),%eax
  800a83:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800a87:	8b 45 10             	mov    0x10(%ebp),%eax
  800a8a:	89 44 24 08          	mov    %eax,0x8(%esp)
  800a8e:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800a91:	89 44 24 04          	mov    %eax,0x4(%esp)
  800a95:	c7 04 24 20 06 80 00 	movl   $0x800620,(%esp)
  800a9c:	e8 9c fb ff ff       	call   80063d <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  800aa1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800aa4:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800aa7:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800aaa:	c9                   	leave  
  800aab:	c3                   	ret    

00800aac <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800aac:	55                   	push   %ebp
  800aad:	89 e5                	mov    %esp,%ebp
  800aaf:	83 ec 18             	sub    $0x18,%esp

	return b.cnt;
}

int
snprintf(char *buf, int n, const char *fmt, ...)
  800ab2:	8d 45 14             	lea    0x14(%ebp),%eax
{
	va_list ap;
	int rc;

	va_start(ap, fmt);
	rc = vsnprintf(buf, n, fmt, ap);
  800ab5:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800ab9:	8b 45 10             	mov    0x10(%ebp),%eax
  800abc:	89 44 24 08          	mov    %eax,0x8(%esp)
  800ac0:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ac3:	89 44 24 04          	mov    %eax,0x4(%esp)
  800ac7:	8b 45 08             	mov    0x8(%ebp),%eax
  800aca:	89 04 24             	mov    %eax,(%esp)
  800acd:	e8 82 ff ff ff       	call   800a54 <vsnprintf>
	va_end(ap);

	return rc;
}
  800ad2:	c9                   	leave  
  800ad3:	c3                   	ret    

00800ad4 <printfmt>:
	}
}

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800ad4:	55                   	push   %ebp
  800ad5:	89 e5                	mov    %esp,%ebp
  800ad7:	83 ec 18             	sub    $0x18,%esp
		}
	}
}

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
  800ada:	8d 45 14             	lea    0x14(%ebp),%eax
{
	va_list ap;

	va_start(ap, fmt);
	vprintfmt(putch, putdat, fmt, ap);
  800add:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800ae1:	8b 45 10             	mov    0x10(%ebp),%eax
  800ae4:	89 44 24 08          	mov    %eax,0x8(%esp)
  800ae8:	8b 45 0c             	mov    0xc(%ebp),%eax
  800aeb:	89 44 24 04          	mov    %eax,0x4(%esp)
  800aef:	8b 45 08             	mov    0x8(%ebp),%eax
  800af2:	89 04 24             	mov    %eax,(%esp)
  800af5:	e8 43 fb ff ff       	call   80063d <vprintfmt>
	va_end(ap);
}
  800afa:	c9                   	leave  
  800afb:	c3                   	ret    
  800afc:	00 00                	add    %al,(%eax)
	...

00800b00 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800b00:	55                   	push   %ebp
  800b01:	89 e5                	mov    %esp,%ebp
  800b03:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  800b06:	b8 00 00 00 00       	mov    $0x0,%eax
  800b0b:	80 3a 00             	cmpb   $0x0,(%edx)
  800b0e:	74 09                	je     800b19 <strlen+0x19>
		n++;
  800b10:	83 c0 01             	add    $0x1,%eax
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800b13:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  800b17:	75 f7                	jne    800b10 <strlen+0x10>
		n++;
	return n;
}
  800b19:	5d                   	pop    %ebp
  800b1a:	c3                   	ret    

00800b1b <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800b1b:	55                   	push   %ebp
  800b1c:	89 e5                	mov    %esp,%ebp
  800b1e:	53                   	push   %ebx
  800b1f:	8b 5d 08             	mov    0x8(%ebp),%ebx
  800b22:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800b25:	85 c9                	test   %ecx,%ecx
  800b27:	74 19                	je     800b42 <strnlen+0x27>
  800b29:	80 3b 00             	cmpb   $0x0,(%ebx)
  800b2c:	74 14                	je     800b42 <strnlen+0x27>
  800b2e:	b8 00 00 00 00       	mov    $0x0,%eax
		n++;
  800b33:	83 c0 01             	add    $0x1,%eax
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800b36:	39 c8                	cmp    %ecx,%eax
  800b38:	74 0d                	je     800b47 <strnlen+0x2c>
  800b3a:	80 3c 03 00          	cmpb   $0x0,(%ebx,%eax,1)
  800b3e:	75 f3                	jne    800b33 <strnlen+0x18>
  800b40:	eb 05                	jmp    800b47 <strnlen+0x2c>
  800b42:	b8 00 00 00 00       	mov    $0x0,%eax
		n++;
	return n;
}
  800b47:	5b                   	pop    %ebx
  800b48:	5d                   	pop    %ebp
  800b49:	c3                   	ret    

00800b4a <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800b4a:	55                   	push   %ebp
  800b4b:	89 e5                	mov    %esp,%ebp
  800b4d:	53                   	push   %ebx
  800b4e:	8b 45 08             	mov    0x8(%ebp),%eax
  800b51:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800b54:	ba 00 00 00 00       	mov    $0x0,%edx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  800b59:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
  800b5d:	88 0c 10             	mov    %cl,(%eax,%edx,1)
  800b60:	83 c2 01             	add    $0x1,%edx
  800b63:	84 c9                	test   %cl,%cl
  800b65:	75 f2                	jne    800b59 <strcpy+0xf>
		/* do nothing */;
	return ret;
}
  800b67:	5b                   	pop    %ebx
  800b68:	5d                   	pop    %ebp
  800b69:	c3                   	ret    

00800b6a <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800b6a:	55                   	push   %ebp
  800b6b:	89 e5                	mov    %esp,%ebp
  800b6d:	56                   	push   %esi
  800b6e:	53                   	push   %ebx
  800b6f:	8b 45 08             	mov    0x8(%ebp),%eax
  800b72:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b75:	8b 75 10             	mov    0x10(%ebp),%esi
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800b78:	85 f6                	test   %esi,%esi
  800b7a:	74 18                	je     800b94 <strncpy+0x2a>
  800b7c:	b9 00 00 00 00       	mov    $0x0,%ecx
		*dst++ = *src;
  800b81:	0f b6 1a             	movzbl (%edx),%ebx
  800b84:	88 1c 08             	mov    %bl,(%eax,%ecx,1)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  800b87:	80 3a 01             	cmpb   $0x1,(%edx)
  800b8a:	83 da ff             	sbb    $0xffffffff,%edx
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800b8d:	83 c1 01             	add    $0x1,%ecx
  800b90:	39 ce                	cmp    %ecx,%esi
  800b92:	77 ed                	ja     800b81 <strncpy+0x17>
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
}
  800b94:	5b                   	pop    %ebx
  800b95:	5e                   	pop    %esi
  800b96:	5d                   	pop    %ebp
  800b97:	c3                   	ret    

00800b98 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800b98:	55                   	push   %ebp
  800b99:	89 e5                	mov    %esp,%ebp
  800b9b:	56                   	push   %esi
  800b9c:	53                   	push   %ebx
  800b9d:	8b 75 08             	mov    0x8(%ebp),%esi
  800ba0:	8b 55 0c             	mov    0xc(%ebp),%edx
  800ba3:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  800ba6:	89 f0                	mov    %esi,%eax
  800ba8:	85 c9                	test   %ecx,%ecx
  800baa:	74 27                	je     800bd3 <strlcpy+0x3b>
		while (--size > 0 && *src != '\0')
  800bac:	83 e9 01             	sub    $0x1,%ecx
  800baf:	74 1d                	je     800bce <strlcpy+0x36>
  800bb1:	0f b6 1a             	movzbl (%edx),%ebx
  800bb4:	84 db                	test   %bl,%bl
  800bb6:	74 16                	je     800bce <strlcpy+0x36>
			*dst++ = *src++;
  800bb8:	88 18                	mov    %bl,(%eax)
  800bba:	83 c0 01             	add    $0x1,%eax
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800bbd:	83 e9 01             	sub    $0x1,%ecx
  800bc0:	74 0e                	je     800bd0 <strlcpy+0x38>
			*dst++ = *src++;
  800bc2:	83 c2 01             	add    $0x1,%edx
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800bc5:	0f b6 1a             	movzbl (%edx),%ebx
  800bc8:	84 db                	test   %bl,%bl
  800bca:	75 ec                	jne    800bb8 <strlcpy+0x20>
  800bcc:	eb 02                	jmp    800bd0 <strlcpy+0x38>
  800bce:	89 f0                	mov    %esi,%eax
			*dst++ = *src++;
		*dst = '\0';
  800bd0:	c6 00 00             	movb   $0x0,(%eax)
  800bd3:	29 f0                	sub    %esi,%eax
	}
	return dst - dst_in;
}
  800bd5:	5b                   	pop    %ebx
  800bd6:	5e                   	pop    %esi
  800bd7:	5d                   	pop    %ebp
  800bd8:	c3                   	ret    

00800bd9 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800bd9:	55                   	push   %ebp
  800bda:	89 e5                	mov    %esp,%ebp
  800bdc:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800bdf:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  800be2:	0f b6 01             	movzbl (%ecx),%eax
  800be5:	84 c0                	test   %al,%al
  800be7:	74 15                	je     800bfe <strcmp+0x25>
  800be9:	3a 02                	cmp    (%edx),%al
  800beb:	75 11                	jne    800bfe <strcmp+0x25>
		p++, q++;
  800bed:	83 c1 01             	add    $0x1,%ecx
  800bf0:	83 c2 01             	add    $0x1,%edx
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800bf3:	0f b6 01             	movzbl (%ecx),%eax
  800bf6:	84 c0                	test   %al,%al
  800bf8:	74 04                	je     800bfe <strcmp+0x25>
  800bfa:	3a 02                	cmp    (%edx),%al
  800bfc:	74 ef                	je     800bed <strcmp+0x14>
  800bfe:	0f b6 c0             	movzbl %al,%eax
  800c01:	0f b6 12             	movzbl (%edx),%edx
  800c04:	29 d0                	sub    %edx,%eax
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
}
  800c06:	5d                   	pop    %ebp
  800c07:	c3                   	ret    

00800c08 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800c08:	55                   	push   %ebp
  800c09:	89 e5                	mov    %esp,%ebp
  800c0b:	53                   	push   %ebx
  800c0c:	8b 55 08             	mov    0x8(%ebp),%edx
  800c0f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c12:	8b 45 10             	mov    0x10(%ebp),%eax
	while (n > 0 && *p && *p == *q)
  800c15:	85 c0                	test   %eax,%eax
  800c17:	74 23                	je     800c3c <strncmp+0x34>
  800c19:	0f b6 1a             	movzbl (%edx),%ebx
  800c1c:	84 db                	test   %bl,%bl
  800c1e:	74 24                	je     800c44 <strncmp+0x3c>
  800c20:	3a 19                	cmp    (%ecx),%bl
  800c22:	75 20                	jne    800c44 <strncmp+0x3c>
  800c24:	83 e8 01             	sub    $0x1,%eax
  800c27:	74 13                	je     800c3c <strncmp+0x34>
		n--, p++, q++;
  800c29:	83 c2 01             	add    $0x1,%edx
  800c2c:	83 c1 01             	add    $0x1,%ecx
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  800c2f:	0f b6 1a             	movzbl (%edx),%ebx
  800c32:	84 db                	test   %bl,%bl
  800c34:	74 0e                	je     800c44 <strncmp+0x3c>
  800c36:	3a 19                	cmp    (%ecx),%bl
  800c38:	74 ea                	je     800c24 <strncmp+0x1c>
  800c3a:	eb 08                	jmp    800c44 <strncmp+0x3c>
  800c3c:	b8 00 00 00 00       	mov    $0x0,%eax
		n--, p++, q++;
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
}
  800c41:	5b                   	pop    %ebx
  800c42:	5d                   	pop    %ebp
  800c43:	c3                   	ret    
	while (n > 0 && *p && *p == *q)
		n--, p++, q++;
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800c44:	0f b6 02             	movzbl (%edx),%eax
  800c47:	0f b6 11             	movzbl (%ecx),%edx
  800c4a:	29 d0                	sub    %edx,%eax
  800c4c:	eb f3                	jmp    800c41 <strncmp+0x39>

00800c4e <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800c4e:	55                   	push   %ebp
  800c4f:	89 e5                	mov    %esp,%ebp
  800c51:	8b 45 08             	mov    0x8(%ebp),%eax
  800c54:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800c58:	0f b6 10             	movzbl (%eax),%edx
  800c5b:	84 d2                	test   %dl,%dl
  800c5d:	74 15                	je     800c74 <strchr+0x26>
		if (*s == c)
  800c5f:	38 ca                	cmp    %cl,%dl
  800c61:	75 07                	jne    800c6a <strchr+0x1c>
  800c63:	eb 14                	jmp    800c79 <strchr+0x2b>
  800c65:	38 ca                	cmp    %cl,%dl
  800c67:	90                   	nop
  800c68:	74 0f                	je     800c79 <strchr+0x2b>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800c6a:	83 c0 01             	add    $0x1,%eax
  800c6d:	0f b6 10             	movzbl (%eax),%edx
  800c70:	84 d2                	test   %dl,%dl
  800c72:	75 f1                	jne    800c65 <strchr+0x17>
  800c74:	b8 00 00 00 00       	mov    $0x0,%eax
		if (*s == c)
			return (char *) s;
	return 0;
}
  800c79:	5d                   	pop    %ebp
  800c7a:	c3                   	ret    

00800c7b <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800c7b:	55                   	push   %ebp
  800c7c:	89 e5                	mov    %esp,%ebp
  800c7e:	8b 45 08             	mov    0x8(%ebp),%eax
  800c81:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800c85:	0f b6 10             	movzbl (%eax),%edx
  800c88:	84 d2                	test   %dl,%dl
  800c8a:	74 18                	je     800ca4 <strfind+0x29>
		if (*s == c)
  800c8c:	38 ca                	cmp    %cl,%dl
  800c8e:	75 0a                	jne    800c9a <strfind+0x1f>
  800c90:	eb 12                	jmp    800ca4 <strfind+0x29>
  800c92:	38 ca                	cmp    %cl,%dl
  800c94:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  800c98:	74 0a                	je     800ca4 <strfind+0x29>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800c9a:	83 c0 01             	add    $0x1,%eax
  800c9d:	0f b6 10             	movzbl (%eax),%edx
  800ca0:	84 d2                	test   %dl,%dl
  800ca2:	75 ee                	jne    800c92 <strfind+0x17>
		if (*s == c)
			break;
	return (char *) s;
}
  800ca4:	5d                   	pop    %ebp
  800ca5:	c3                   	ret    

00800ca6 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800ca6:	55                   	push   %ebp
  800ca7:	89 e5                	mov    %esp,%ebp
  800ca9:	83 ec 0c             	sub    $0xc,%esp
  800cac:	89 1c 24             	mov    %ebx,(%esp)
  800caf:	89 74 24 04          	mov    %esi,0x4(%esp)
  800cb3:	89 7c 24 08          	mov    %edi,0x8(%esp)
  800cb7:	8b 7d 08             	mov    0x8(%ebp),%edi
  800cba:	8b 45 0c             	mov    0xc(%ebp),%eax
  800cbd:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800cc0:	85 c9                	test   %ecx,%ecx
  800cc2:	74 30                	je     800cf4 <memset+0x4e>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800cc4:	f7 c7 03 00 00 00    	test   $0x3,%edi
  800cca:	75 25                	jne    800cf1 <memset+0x4b>
  800ccc:	f6 c1 03             	test   $0x3,%cl
  800ccf:	75 20                	jne    800cf1 <memset+0x4b>
		c &= 0xFF;
  800cd1:	0f b6 d0             	movzbl %al,%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800cd4:	89 d3                	mov    %edx,%ebx
  800cd6:	c1 e3 08             	shl    $0x8,%ebx
  800cd9:	89 d6                	mov    %edx,%esi
  800cdb:	c1 e6 18             	shl    $0x18,%esi
  800cde:	89 d0                	mov    %edx,%eax
  800ce0:	c1 e0 10             	shl    $0x10,%eax
  800ce3:	09 f0                	or     %esi,%eax
  800ce5:	09 d0                	or     %edx,%eax
		asm volatile("cld; rep stosl\n"
  800ce7:	09 d8                	or     %ebx,%eax
  800ce9:	c1 e9 02             	shr    $0x2,%ecx
  800cec:	fc                   	cld    
  800ced:	f3 ab                	rep stos %eax,%es:(%edi)
{
	char *p;

	if (n == 0)
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800cef:	eb 03                	jmp    800cf4 <memset+0x4e>
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800cf1:	fc                   	cld    
  800cf2:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800cf4:	89 f8                	mov    %edi,%eax
  800cf6:	8b 1c 24             	mov    (%esp),%ebx
  800cf9:	8b 74 24 04          	mov    0x4(%esp),%esi
  800cfd:	8b 7c 24 08          	mov    0x8(%esp),%edi
  800d01:	89 ec                	mov    %ebp,%esp
  800d03:	5d                   	pop    %ebp
  800d04:	c3                   	ret    

00800d05 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800d05:	55                   	push   %ebp
  800d06:	89 e5                	mov    %esp,%ebp
  800d08:	83 ec 08             	sub    $0x8,%esp
  800d0b:	89 34 24             	mov    %esi,(%esp)
  800d0e:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800d12:	8b 45 08             	mov    0x8(%ebp),%eax
  800d15:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;
	
	s = src;
  800d18:	8b 75 0c             	mov    0xc(%ebp),%esi
	d = dst;
  800d1b:	89 c7                	mov    %eax,%edi
	if (s < d && s + n > d) {
  800d1d:	39 c6                	cmp    %eax,%esi
  800d1f:	73 35                	jae    800d56 <memmove+0x51>
  800d21:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800d24:	39 d0                	cmp    %edx,%eax
  800d26:	73 2e                	jae    800d56 <memmove+0x51>
		s += n;
		d += n;
  800d28:	01 cf                	add    %ecx,%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800d2a:	f6 c2 03             	test   $0x3,%dl
  800d2d:	75 1b                	jne    800d4a <memmove+0x45>
  800d2f:	f7 c7 03 00 00 00    	test   $0x3,%edi
  800d35:	75 13                	jne    800d4a <memmove+0x45>
  800d37:	f6 c1 03             	test   $0x3,%cl
  800d3a:	75 0e                	jne    800d4a <memmove+0x45>
			asm volatile("std; rep movsl\n"
  800d3c:	83 ef 04             	sub    $0x4,%edi
  800d3f:	8d 72 fc             	lea    -0x4(%edx),%esi
  800d42:	c1 e9 02             	shr    $0x2,%ecx
  800d45:	fd                   	std    
  800d46:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800d48:	eb 09                	jmp    800d53 <memmove+0x4e>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  800d4a:	83 ef 01             	sub    $0x1,%edi
  800d4d:	8d 72 ff             	lea    -0x1(%edx),%esi
  800d50:	fd                   	std    
  800d51:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800d53:	fc                   	cld    
	const char *s;
	char *d;
	
	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800d54:	eb 20                	jmp    800d76 <memmove+0x71>
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800d56:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800d5c:	75 15                	jne    800d73 <memmove+0x6e>
  800d5e:	f7 c7 03 00 00 00    	test   $0x3,%edi
  800d64:	75 0d                	jne    800d73 <memmove+0x6e>
  800d66:	f6 c1 03             	test   $0x3,%cl
  800d69:	75 08                	jne    800d73 <memmove+0x6e>
			asm volatile("cld; rep movsl\n"
  800d6b:	c1 e9 02             	shr    $0x2,%ecx
  800d6e:	fc                   	cld    
  800d6f:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800d71:	eb 03                	jmp    800d76 <memmove+0x71>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  800d73:	fc                   	cld    
  800d74:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800d76:	8b 34 24             	mov    (%esp),%esi
  800d79:	8b 7c 24 04          	mov    0x4(%esp),%edi
  800d7d:	89 ec                	mov    %ebp,%esp
  800d7f:	5d                   	pop    %ebp
  800d80:	c3                   	ret    

00800d81 <memcpy>:

/* sigh - gcc emits references to this for structure assignments! */
/* it is *not* prototyped in inc/string.h - do not use directly. */
void *
memcpy(void *dst, void *src, size_t n)
{
  800d81:	55                   	push   %ebp
  800d82:	89 e5                	mov    %esp,%ebp
  800d84:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  800d87:	8b 45 10             	mov    0x10(%ebp),%eax
  800d8a:	89 44 24 08          	mov    %eax,0x8(%esp)
  800d8e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d91:	89 44 24 04          	mov    %eax,0x4(%esp)
  800d95:	8b 45 08             	mov    0x8(%ebp),%eax
  800d98:	89 04 24             	mov    %eax,(%esp)
  800d9b:	e8 65 ff ff ff       	call   800d05 <memmove>
}
  800da0:	c9                   	leave  
  800da1:	c3                   	ret    

00800da2 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800da2:	55                   	push   %ebp
  800da3:	89 e5                	mov    %esp,%ebp
  800da5:	57                   	push   %edi
  800da6:	56                   	push   %esi
  800da7:	53                   	push   %ebx
  800da8:	8b 75 08             	mov    0x8(%ebp),%esi
  800dab:	8b 7d 0c             	mov    0xc(%ebp),%edi
  800dae:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800db1:	85 c9                	test   %ecx,%ecx
  800db3:	74 36                	je     800deb <memcmp+0x49>
		if (*s1 != *s2)
  800db5:	0f b6 06             	movzbl (%esi),%eax
  800db8:	0f b6 1f             	movzbl (%edi),%ebx
  800dbb:	38 d8                	cmp    %bl,%al
  800dbd:	74 20                	je     800ddf <memcmp+0x3d>
  800dbf:	eb 14                	jmp    800dd5 <memcmp+0x33>
  800dc1:	0f b6 44 16 01       	movzbl 0x1(%esi,%edx,1),%eax
  800dc6:	0f b6 5c 17 01       	movzbl 0x1(%edi,%edx,1),%ebx
  800dcb:	83 c2 01             	add    $0x1,%edx
  800dce:	83 e9 01             	sub    $0x1,%ecx
  800dd1:	38 d8                	cmp    %bl,%al
  800dd3:	74 12                	je     800de7 <memcmp+0x45>
			return (int) *s1 - (int) *s2;
  800dd5:	0f b6 c0             	movzbl %al,%eax
  800dd8:	0f b6 db             	movzbl %bl,%ebx
  800ddb:	29 d8                	sub    %ebx,%eax
  800ddd:	eb 11                	jmp    800df0 <memcmp+0x4e>
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800ddf:	83 e9 01             	sub    $0x1,%ecx
  800de2:	ba 00 00 00 00       	mov    $0x0,%edx
  800de7:	85 c9                	test   %ecx,%ecx
  800de9:	75 d6                	jne    800dc1 <memcmp+0x1f>
  800deb:	b8 00 00 00 00       	mov    $0x0,%eax
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
}
  800df0:	5b                   	pop    %ebx
  800df1:	5e                   	pop    %esi
  800df2:	5f                   	pop    %edi
  800df3:	5d                   	pop    %ebp
  800df4:	c3                   	ret    

00800df5 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800df5:	55                   	push   %ebp
  800df6:	89 e5                	mov    %esp,%ebp
  800df8:	8b 45 08             	mov    0x8(%ebp),%eax
	const void *ends = (const char *) s + n;
  800dfb:	89 c2                	mov    %eax,%edx
  800dfd:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800e00:	39 d0                	cmp    %edx,%eax
  800e02:	73 15                	jae    800e19 <memfind+0x24>
		if (*(const unsigned char *) s == (unsigned char) c)
  800e04:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
  800e08:	38 08                	cmp    %cl,(%eax)
  800e0a:	75 06                	jne    800e12 <memfind+0x1d>
  800e0c:	eb 0b                	jmp    800e19 <memfind+0x24>
  800e0e:	38 08                	cmp    %cl,(%eax)
  800e10:	74 07                	je     800e19 <memfind+0x24>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800e12:	83 c0 01             	add    $0x1,%eax
  800e15:	39 c2                	cmp    %eax,%edx
  800e17:	77 f5                	ja     800e0e <memfind+0x19>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
	return (void *) s;
}
  800e19:	5d                   	pop    %ebp
  800e1a:	c3                   	ret    

00800e1b <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800e1b:	55                   	push   %ebp
  800e1c:	89 e5                	mov    %esp,%ebp
  800e1e:	57                   	push   %edi
  800e1f:	56                   	push   %esi
  800e20:	53                   	push   %ebx
  800e21:	83 ec 04             	sub    $0x4,%esp
  800e24:	8b 55 08             	mov    0x8(%ebp),%edx
  800e27:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800e2a:	0f b6 02             	movzbl (%edx),%eax
  800e2d:	3c 20                	cmp    $0x20,%al
  800e2f:	74 04                	je     800e35 <strtol+0x1a>
  800e31:	3c 09                	cmp    $0x9,%al
  800e33:	75 0e                	jne    800e43 <strtol+0x28>
		s++;
  800e35:	83 c2 01             	add    $0x1,%edx
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800e38:	0f b6 02             	movzbl (%edx),%eax
  800e3b:	3c 20                	cmp    $0x20,%al
  800e3d:	74 f6                	je     800e35 <strtol+0x1a>
  800e3f:	3c 09                	cmp    $0x9,%al
  800e41:	74 f2                	je     800e35 <strtol+0x1a>
		s++;

	// plus/minus sign
	if (*s == '+')
  800e43:	3c 2b                	cmp    $0x2b,%al
  800e45:	75 0c                	jne    800e53 <strtol+0x38>
		s++;
  800e47:	83 c2 01             	add    $0x1,%edx
  800e4a:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800e51:	eb 15                	jmp    800e68 <strtol+0x4d>
	else if (*s == '-')
  800e53:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800e5a:	3c 2d                	cmp    $0x2d,%al
  800e5c:	75 0a                	jne    800e68 <strtol+0x4d>
		s++, neg = 1;
  800e5e:	83 c2 01             	add    $0x1,%edx
  800e61:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800e68:	85 db                	test   %ebx,%ebx
  800e6a:	0f 94 c0             	sete   %al
  800e6d:	74 05                	je     800e74 <strtol+0x59>
  800e6f:	83 fb 10             	cmp    $0x10,%ebx
  800e72:	75 18                	jne    800e8c <strtol+0x71>
  800e74:	80 3a 30             	cmpb   $0x30,(%edx)
  800e77:	75 13                	jne    800e8c <strtol+0x71>
  800e79:	80 7a 01 78          	cmpb   $0x78,0x1(%edx)
  800e7d:	8d 76 00             	lea    0x0(%esi),%esi
  800e80:	75 0a                	jne    800e8c <strtol+0x71>
		s += 2, base = 16;
  800e82:	83 c2 02             	add    $0x2,%edx
  800e85:	bb 10 00 00 00       	mov    $0x10,%ebx
		s++;
	else if (*s == '-')
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800e8a:	eb 15                	jmp    800ea1 <strtol+0x86>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  800e8c:	84 c0                	test   %al,%al
  800e8e:	66 90                	xchg   %ax,%ax
  800e90:	74 0f                	je     800ea1 <strtol+0x86>
  800e92:	bb 0a 00 00 00       	mov    $0xa,%ebx
  800e97:	80 3a 30             	cmpb   $0x30,(%edx)
  800e9a:	75 05                	jne    800ea1 <strtol+0x86>
		s++, base = 8;
  800e9c:	83 c2 01             	add    $0x1,%edx
  800e9f:	b3 08                	mov    $0x8,%bl
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  800ea1:	b8 00 00 00 00       	mov    $0x0,%eax
  800ea6:	89 de                	mov    %ebx,%esi

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  800ea8:	0f b6 0a             	movzbl (%edx),%ecx
  800eab:	89 cf                	mov    %ecx,%edi
  800ead:	8d 59 d0             	lea    -0x30(%ecx),%ebx
  800eb0:	80 fb 09             	cmp    $0x9,%bl
  800eb3:	77 08                	ja     800ebd <strtol+0xa2>
			dig = *s - '0';
  800eb5:	0f be c9             	movsbl %cl,%ecx
  800eb8:	83 e9 30             	sub    $0x30,%ecx
  800ebb:	eb 1e                	jmp    800edb <strtol+0xc0>
		else if (*s >= 'a' && *s <= 'z')
  800ebd:	8d 5f 9f             	lea    -0x61(%edi),%ebx
  800ec0:	80 fb 19             	cmp    $0x19,%bl
  800ec3:	77 08                	ja     800ecd <strtol+0xb2>
			dig = *s - 'a' + 10;
  800ec5:	0f be c9             	movsbl %cl,%ecx
  800ec8:	83 e9 57             	sub    $0x57,%ecx
  800ecb:	eb 0e                	jmp    800edb <strtol+0xc0>
		else if (*s >= 'A' && *s <= 'Z')
  800ecd:	8d 5f bf             	lea    -0x41(%edi),%ebx
  800ed0:	80 fb 19             	cmp    $0x19,%bl
  800ed3:	77 15                	ja     800eea <strtol+0xcf>
			dig = *s - 'A' + 10;
  800ed5:	0f be c9             	movsbl %cl,%ecx
  800ed8:	83 e9 37             	sub    $0x37,%ecx
		else
			break;
		if (dig >= base)
  800edb:	39 f1                	cmp    %esi,%ecx
  800edd:	7d 0b                	jge    800eea <strtol+0xcf>
			break;
		s++, val = (val * base) + dig;
  800edf:	83 c2 01             	add    $0x1,%edx
  800ee2:	0f af c6             	imul   %esi,%eax
  800ee5:	8d 04 01             	lea    (%ecx,%eax,1),%eax
		// we don't properly detect overflow!
	}
  800ee8:	eb be                	jmp    800ea8 <strtol+0x8d>
  800eea:	89 c1                	mov    %eax,%ecx

	if (endptr)
  800eec:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800ef0:	74 05                	je     800ef7 <strtol+0xdc>
		*endptr = (char *) s;
  800ef2:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800ef5:	89 13                	mov    %edx,(%ebx)
	return (neg ? -val : val);
  800ef7:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  800efb:	74 04                	je     800f01 <strtol+0xe6>
  800efd:	89 c8                	mov    %ecx,%eax
  800eff:	f7 d8                	neg    %eax
}
  800f01:	83 c4 04             	add    $0x4,%esp
  800f04:	5b                   	pop    %ebx
  800f05:	5e                   	pop    %esi
  800f06:	5f                   	pop    %edi
  800f07:	5d                   	pop    %ebp
  800f08:	c3                   	ret    
  800f09:	00 00                	add    %al,(%eax)
	...

00800f0c <sys_cgetc>:
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}

int
sys_cgetc(void)
{
  800f0c:	55                   	push   %ebp
  800f0d:	89 e5                	mov    %esp,%ebp
  800f0f:	83 ec 0c             	sub    $0xc,%esp
  800f12:	89 1c 24             	mov    %ebx,(%esp)
  800f15:	89 74 24 04          	mov    %esi,0x4(%esp)
  800f19:	89 7c 24 08          	mov    %edi,0x8(%esp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800f1d:	ba 00 00 00 00       	mov    $0x0,%edx
  800f22:	b8 01 00 00 00       	mov    $0x1,%eax
  800f27:	89 d1                	mov    %edx,%ecx
  800f29:	89 d3                	mov    %edx,%ebx
  800f2b:	89 d7                	mov    %edx,%edi
  800f2d:	89 d6                	mov    %edx,%esi
  800f2f:	cd 30                	int    $0x30

int
sys_cgetc(void)
{
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800f31:	8b 1c 24             	mov    (%esp),%ebx
  800f34:	8b 74 24 04          	mov    0x4(%esp),%esi
  800f38:	8b 7c 24 08          	mov    0x8(%esp),%edi
  800f3c:	89 ec                	mov    %ebp,%esp
  800f3e:	5d                   	pop    %ebp
  800f3f:	c3                   	ret    

00800f40 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800f40:	55                   	push   %ebp
  800f41:	89 e5                	mov    %esp,%ebp
  800f43:	83 ec 0c             	sub    $0xc,%esp
  800f46:	89 1c 24             	mov    %ebx,(%esp)
  800f49:	89 74 24 04          	mov    %esi,0x4(%esp)
  800f4d:	89 7c 24 08          	mov    %edi,0x8(%esp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800f51:	b8 00 00 00 00       	mov    $0x0,%eax
  800f56:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f59:	8b 55 08             	mov    0x8(%ebp),%edx
  800f5c:	89 c3                	mov    %eax,%ebx
  800f5e:	89 c7                	mov    %eax,%edi
  800f60:	89 c6                	mov    %eax,%esi
  800f62:	cd 30                	int    $0x30

void
sys_cputs(const char *s, size_t len)
{
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800f64:	8b 1c 24             	mov    (%esp),%ebx
  800f67:	8b 74 24 04          	mov    0x4(%esp),%esi
  800f6b:	8b 7c 24 08          	mov    0x8(%esp),%edi
  800f6f:	89 ec                	mov    %ebp,%esp
  800f71:	5d                   	pop    %ebp
  800f72:	c3                   	ret    

00800f73 <sys_page_insert>:
{
	return syscall(SYS_page_waste, 0, (uint32_t)p, (uint32_t)n, 0, 0,0);
}
int
sys_page_insert(envid_t envid, void *va, struct Page *p, int perm)
{
  800f73:	55                   	push   %ebp
  800f74:	89 e5                	mov    %esp,%ebp
  800f76:	83 ec 38             	sub    $0x38,%esp
  800f79:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800f7c:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800f7f:	89 7d fc             	mov    %edi,-0x4(%ebp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800f82:	be 00 00 00 00       	mov    $0x0,%esi
  800f87:	b8 12 00 00 00       	mov    $0x12,%eax
  800f8c:	8b 7d 14             	mov    0x14(%ebp),%edi
  800f8f:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800f92:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f95:	8b 55 08             	mov    0x8(%ebp),%edx
  800f98:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
	
	if(check && ret > 0)
  800f9a:	85 c0                	test   %eax,%eax
  800f9c:	7e 28                	jle    800fc6 <sys_page_insert+0x53>
		panic("syscall %d returned %d (> 0)", num, ret);
  800f9e:	89 44 24 10          	mov    %eax,0x10(%esp)
  800fa2:	c7 44 24 0c 12 00 00 	movl   $0x12,0xc(%esp)
  800fa9:	00 
  800faa:	c7 44 24 08 1f 34 80 	movl   $0x80341f,0x8(%esp)
  800fb1:	00 
  800fb2:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800fb9:	00 
  800fba:	c7 04 24 3c 34 80 00 	movl   $0x80343c,(%esp)
  800fc1:	e8 fe f3 ff ff       	call   8003c4 <_panic>
}
int
sys_page_insert(envid_t envid, void *va, struct Page *p, int perm)
{
	return syscall(SYS_page_insert, 1, envid, (uint32_t) va, (uint32_t)p, perm, 0);
}
  800fc6:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800fc9:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800fcc:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800fcf:	89 ec                	mov    %ebp,%esp
  800fd1:	5d                   	pop    %ebp
  800fd2:	c3                   	ret    

00800fd3 <sys_page_waste>:
{
	return (int)syscall(SYS_receive_packet, 0, (uint32_t)buffer, 0,0,0,0);
}

int sys_page_waste(struct Page **p, int n)
{
  800fd3:	55                   	push   %ebp
  800fd4:	89 e5                	mov    %esp,%ebp
  800fd6:	83 ec 0c             	sub    $0xc,%esp
  800fd9:	89 1c 24             	mov    %ebx,(%esp)
  800fdc:	89 74 24 04          	mov    %esi,0x4(%esp)
  800fe0:	89 7c 24 08          	mov    %edi,0x8(%esp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800fe4:	bb 00 00 00 00       	mov    $0x0,%ebx
  800fe9:	b8 11 00 00 00       	mov    $0x11,%eax
  800fee:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ff1:	8b 55 08             	mov    0x8(%ebp),%edx
  800ff4:	89 df                	mov    %ebx,%edi
  800ff6:	89 de                	mov    %ebx,%esi
  800ff8:	cd 30                	int    $0x30
}

int sys_page_waste(struct Page **p, int n)
{
	return syscall(SYS_page_waste, 0, (uint32_t)p, (uint32_t)n, 0, 0,0);
}
  800ffa:	8b 1c 24             	mov    (%esp),%ebx
  800ffd:	8b 74 24 04          	mov    0x4(%esp),%esi
  801001:	8b 7c 24 08          	mov    0x8(%esp),%edi
  801005:	89 ec                	mov    %ebp,%esp
  801007:	5d                   	pop    %ebp
  801008:	c3                   	ret    

00801009 <sys_receive_packet>:
{
	return (int)syscall(SYS_transmit_packet, 1, (uint32_t)data, len, 0,0,0);
}

int sys_receive_packet(void* buffer)
{
  801009:	55                   	push   %ebp
  80100a:	89 e5                	mov    %esp,%ebp
  80100c:	83 ec 0c             	sub    $0xc,%esp
  80100f:	89 1c 24             	mov    %ebx,(%esp)
  801012:	89 74 24 04          	mov    %esi,0x4(%esp)
  801016:	89 7c 24 08          	mov    %edi,0x8(%esp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80101a:	b9 00 00 00 00       	mov    $0x0,%ecx
  80101f:	b8 10 00 00 00       	mov    $0x10,%eax
  801024:	8b 55 08             	mov    0x8(%ebp),%edx
  801027:	89 cb                	mov    %ecx,%ebx
  801029:	89 cf                	mov    %ecx,%edi
  80102b:	89 ce                	mov    %ecx,%esi
  80102d:	cd 30                	int    $0x30
}

int sys_receive_packet(void* buffer)
{
	return (int)syscall(SYS_receive_packet, 0, (uint32_t)buffer, 0,0,0,0);
}
  80102f:	8b 1c 24             	mov    (%esp),%ebx
  801032:	8b 74 24 04          	mov    0x4(%esp),%esi
  801036:	8b 7c 24 08          	mov    0x8(%esp),%edi
  80103a:	89 ec                	mov    %ebp,%esp
  80103c:	5d                   	pop    %ebp
  80103d:	c3                   	ret    

0080103e <sys_transmit_packet>:
{
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0,0);
}

int sys_transmit_packet(void* data, uint32_t len)
{
  80103e:	55                   	push   %ebp
  80103f:	89 e5                	mov    %esp,%ebp
  801041:	83 ec 38             	sub    $0x38,%esp
  801044:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  801047:	89 75 f8             	mov    %esi,-0x8(%ebp)
  80104a:	89 7d fc             	mov    %edi,-0x4(%ebp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80104d:	bb 00 00 00 00       	mov    $0x0,%ebx
  801052:	b8 0f 00 00 00       	mov    $0xf,%eax
  801057:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80105a:	8b 55 08             	mov    0x8(%ebp),%edx
  80105d:	89 df                	mov    %ebx,%edi
  80105f:	89 de                	mov    %ebx,%esi
  801061:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
	
	if(check && ret > 0)
  801063:	85 c0                	test   %eax,%eax
  801065:	7e 28                	jle    80108f <sys_transmit_packet+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  801067:	89 44 24 10          	mov    %eax,0x10(%esp)
  80106b:	c7 44 24 0c 0f 00 00 	movl   $0xf,0xc(%esp)
  801072:	00 
  801073:	c7 44 24 08 1f 34 80 	movl   $0x80341f,0x8(%esp)
  80107a:	00 
  80107b:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  801082:	00 
  801083:	c7 04 24 3c 34 80 00 	movl   $0x80343c,(%esp)
  80108a:	e8 35 f3 ff ff       	call   8003c4 <_panic>
}

int sys_transmit_packet(void* data, uint32_t len)
{
	return (int)syscall(SYS_transmit_packet, 1, (uint32_t)data, len, 0,0,0);
}
  80108f:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  801092:	8b 75 f8             	mov    -0x8(%ebp),%esi
  801095:	8b 7d fc             	mov    -0x4(%ebp),%edi
  801098:	89 ec                	mov    %ebp,%esp
  80109a:	5d                   	pop    %ebp
  80109b:	c3                   	ret    

0080109c <sys_time_msec>:
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}

unsigned int
sys_time_msec(void)
{
  80109c:	55                   	push   %ebp
  80109d:	89 e5                	mov    %esp,%ebp
  80109f:	83 ec 0c             	sub    $0xc,%esp
  8010a2:	89 1c 24             	mov    %ebx,(%esp)
  8010a5:	89 74 24 04          	mov    %esi,0x4(%esp)
  8010a9:	89 7c 24 08          	mov    %edi,0x8(%esp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8010ad:	ba 00 00 00 00       	mov    $0x0,%edx
  8010b2:	b8 0e 00 00 00       	mov    $0xe,%eax
  8010b7:	89 d1                	mov    %edx,%ecx
  8010b9:	89 d3                	mov    %edx,%ebx
  8010bb:	89 d7                	mov    %edx,%edi
  8010bd:	89 d6                	mov    %edx,%esi
  8010bf:	cd 30                	int    $0x30

unsigned int
sys_time_msec(void)
{
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0,0);
}
  8010c1:	8b 1c 24             	mov    (%esp),%ebx
  8010c4:	8b 74 24 04          	mov    0x4(%esp),%esi
  8010c8:	8b 7c 24 08          	mov    0x8(%esp),%edi
  8010cc:	89 ec                	mov    %ebp,%esp
  8010ce:	5d                   	pop    %ebp
  8010cf:	c3                   	ret    

008010d0 <sys_ipc_recv>:
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}

int
sys_ipc_recv(void *dstva)
{
  8010d0:	55                   	push   %ebp
  8010d1:	89 e5                	mov    %esp,%ebp
  8010d3:	83 ec 38             	sub    $0x38,%esp
  8010d6:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  8010d9:	89 75 f8             	mov    %esi,-0x8(%ebp)
  8010dc:	89 7d fc             	mov    %edi,-0x4(%ebp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8010df:	b9 00 00 00 00       	mov    $0x0,%ecx
  8010e4:	b8 0d 00 00 00       	mov    $0xd,%eax
  8010e9:	8b 55 08             	mov    0x8(%ebp),%edx
  8010ec:	89 cb                	mov    %ecx,%ebx
  8010ee:	89 cf                	mov    %ecx,%edi
  8010f0:	89 ce                	mov    %ecx,%esi
  8010f2:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
	
	if(check && ret > 0)
  8010f4:	85 c0                	test   %eax,%eax
  8010f6:	7e 28                	jle    801120 <sys_ipc_recv+0x50>
		panic("syscall %d returned %d (> 0)", num, ret);
  8010f8:	89 44 24 10          	mov    %eax,0x10(%esp)
  8010fc:	c7 44 24 0c 0d 00 00 	movl   $0xd,0xc(%esp)
  801103:	00 
  801104:	c7 44 24 08 1f 34 80 	movl   $0x80341f,0x8(%esp)
  80110b:	00 
  80110c:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  801113:	00 
  801114:	c7 04 24 3c 34 80 00 	movl   $0x80343c,(%esp)
  80111b:	e8 a4 f2 ff ff       	call   8003c4 <_panic>

int
sys_ipc_recv(void *dstva)
{
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  801120:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  801123:	8b 75 f8             	mov    -0x8(%ebp),%esi
  801126:	8b 7d fc             	mov    -0x4(%ebp),%edi
  801129:	89 ec                	mov    %ebp,%esp
  80112b:	5d                   	pop    %ebp
  80112c:	c3                   	ret    

0080112d <sys_ipc_try_send>:
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  80112d:	55                   	push   %ebp
  80112e:	89 e5                	mov    %esp,%ebp
  801130:	83 ec 0c             	sub    $0xc,%esp
  801133:	89 1c 24             	mov    %ebx,(%esp)
  801136:	89 74 24 04          	mov    %esi,0x4(%esp)
  80113a:	89 7c 24 08          	mov    %edi,0x8(%esp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80113e:	be 00 00 00 00       	mov    $0x0,%esi
  801143:	b8 0c 00 00 00       	mov    $0xc,%eax
  801148:	8b 7d 14             	mov    0x14(%ebp),%edi
  80114b:	8b 5d 10             	mov    0x10(%ebp),%ebx
  80114e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801151:	8b 55 08             	mov    0x8(%ebp),%edx
  801154:	cd 30                	int    $0x30

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  801156:	8b 1c 24             	mov    (%esp),%ebx
  801159:	8b 74 24 04          	mov    0x4(%esp),%esi
  80115d:	8b 7c 24 08          	mov    0x8(%esp),%edi
  801161:	89 ec                	mov    %ebp,%esp
  801163:	5d                   	pop    %ebp
  801164:	c3                   	ret    

00801165 <sys_env_set_pgfault_upcall>:
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  801165:	55                   	push   %ebp
  801166:	89 e5                	mov    %esp,%ebp
  801168:	83 ec 38             	sub    $0x38,%esp
  80116b:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  80116e:	89 75 f8             	mov    %esi,-0x8(%ebp)
  801171:	89 7d fc             	mov    %edi,-0x4(%ebp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801174:	bb 00 00 00 00       	mov    $0x0,%ebx
  801179:	b8 0a 00 00 00       	mov    $0xa,%eax
  80117e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801181:	8b 55 08             	mov    0x8(%ebp),%edx
  801184:	89 df                	mov    %ebx,%edi
  801186:	89 de                	mov    %ebx,%esi
  801188:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
	
	if(check && ret > 0)
  80118a:	85 c0                	test   %eax,%eax
  80118c:	7e 28                	jle    8011b6 <sys_env_set_pgfault_upcall+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  80118e:	89 44 24 10          	mov    %eax,0x10(%esp)
  801192:	c7 44 24 0c 0a 00 00 	movl   $0xa,0xc(%esp)
  801199:	00 
  80119a:	c7 44 24 08 1f 34 80 	movl   $0x80341f,0x8(%esp)
  8011a1:	00 
  8011a2:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  8011a9:	00 
  8011aa:	c7 04 24 3c 34 80 00 	movl   $0x80343c,(%esp)
  8011b1:	e8 0e f2 ff ff       	call   8003c4 <_panic>

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  8011b6:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  8011b9:	8b 75 f8             	mov    -0x8(%ebp),%esi
  8011bc:	8b 7d fc             	mov    -0x4(%ebp),%edi
  8011bf:	89 ec                	mov    %ebp,%esp
  8011c1:	5d                   	pop    %ebp
  8011c2:	c3                   	ret    

008011c3 <sys_env_set_trapframe>:
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  8011c3:	55                   	push   %ebp
  8011c4:	89 e5                	mov    %esp,%ebp
  8011c6:	83 ec 38             	sub    $0x38,%esp
  8011c9:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  8011cc:	89 75 f8             	mov    %esi,-0x8(%ebp)
  8011cf:	89 7d fc             	mov    %edi,-0x4(%ebp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8011d2:	bb 00 00 00 00       	mov    $0x0,%ebx
  8011d7:	b8 09 00 00 00       	mov    $0x9,%eax
  8011dc:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8011df:	8b 55 08             	mov    0x8(%ebp),%edx
  8011e2:	89 df                	mov    %ebx,%edi
  8011e4:	89 de                	mov    %ebx,%esi
  8011e6:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
	
	if(check && ret > 0)
  8011e8:	85 c0                	test   %eax,%eax
  8011ea:	7e 28                	jle    801214 <sys_env_set_trapframe+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  8011ec:	89 44 24 10          	mov    %eax,0x10(%esp)
  8011f0:	c7 44 24 0c 09 00 00 	movl   $0x9,0xc(%esp)
  8011f7:	00 
  8011f8:	c7 44 24 08 1f 34 80 	movl   $0x80341f,0x8(%esp)
  8011ff:	00 
  801200:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  801207:	00 
  801208:	c7 04 24 3c 34 80 00 	movl   $0x80343c,(%esp)
  80120f:	e8 b0 f1 ff ff       	call   8003c4 <_panic>

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  801214:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  801217:	8b 75 f8             	mov    -0x8(%ebp),%esi
  80121a:	8b 7d fc             	mov    -0x4(%ebp),%edi
  80121d:	89 ec                	mov    %ebp,%esp
  80121f:	5d                   	pop    %ebp
  801220:	c3                   	ret    

00801221 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  801221:	55                   	push   %ebp
  801222:	89 e5                	mov    %esp,%ebp
  801224:	83 ec 38             	sub    $0x38,%esp
  801227:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  80122a:	89 75 f8             	mov    %esi,-0x8(%ebp)
  80122d:	89 7d fc             	mov    %edi,-0x4(%ebp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801230:	bb 00 00 00 00       	mov    $0x0,%ebx
  801235:	b8 08 00 00 00       	mov    $0x8,%eax
  80123a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80123d:	8b 55 08             	mov    0x8(%ebp),%edx
  801240:	89 df                	mov    %ebx,%edi
  801242:	89 de                	mov    %ebx,%esi
  801244:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
	
	if(check && ret > 0)
  801246:	85 c0                	test   %eax,%eax
  801248:	7e 28                	jle    801272 <sys_env_set_status+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  80124a:	89 44 24 10          	mov    %eax,0x10(%esp)
  80124e:	c7 44 24 0c 08 00 00 	movl   $0x8,0xc(%esp)
  801255:	00 
  801256:	c7 44 24 08 1f 34 80 	movl   $0x80341f,0x8(%esp)
  80125d:	00 
  80125e:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  801265:	00 
  801266:	c7 04 24 3c 34 80 00 	movl   $0x80343c,(%esp)
  80126d:	e8 52 f1 ff ff       	call   8003c4 <_panic>

int
sys_env_set_status(envid_t envid, int status)
{
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  801272:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  801275:	8b 75 f8             	mov    -0x8(%ebp),%esi
  801278:	8b 7d fc             	mov    -0x4(%ebp),%edi
  80127b:	89 ec                	mov    %ebp,%esp
  80127d:	5d                   	pop    %ebp
  80127e:	c3                   	ret    

0080127f <sys_page_unmap>:
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}

int
sys_page_unmap(envid_t envid, void *va)
{
  80127f:	55                   	push   %ebp
  801280:	89 e5                	mov    %esp,%ebp
  801282:	83 ec 38             	sub    $0x38,%esp
  801285:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  801288:	89 75 f8             	mov    %esi,-0x8(%ebp)
  80128b:	89 7d fc             	mov    %edi,-0x4(%ebp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80128e:	bb 00 00 00 00       	mov    $0x0,%ebx
  801293:	b8 06 00 00 00       	mov    $0x6,%eax
  801298:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80129b:	8b 55 08             	mov    0x8(%ebp),%edx
  80129e:	89 df                	mov    %ebx,%edi
  8012a0:	89 de                	mov    %ebx,%esi
  8012a2:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
	
	if(check && ret > 0)
  8012a4:	85 c0                	test   %eax,%eax
  8012a6:	7e 28                	jle    8012d0 <sys_page_unmap+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  8012a8:	89 44 24 10          	mov    %eax,0x10(%esp)
  8012ac:	c7 44 24 0c 06 00 00 	movl   $0x6,0xc(%esp)
  8012b3:	00 
  8012b4:	c7 44 24 08 1f 34 80 	movl   $0x80341f,0x8(%esp)
  8012bb:	00 
  8012bc:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  8012c3:	00 
  8012c4:	c7 04 24 3c 34 80 00 	movl   $0x80343c,(%esp)
  8012cb:	e8 f4 f0 ff ff       	call   8003c4 <_panic>

int
sys_page_unmap(envid_t envid, void *va)
{
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  8012d0:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  8012d3:	8b 75 f8             	mov    -0x8(%ebp),%esi
  8012d6:	8b 7d fc             	mov    -0x4(%ebp),%edi
  8012d9:	89 ec                	mov    %ebp,%esp
  8012db:	5d                   	pop    %ebp
  8012dc:	c3                   	ret    

008012dd <sys_page_map>:
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  8012dd:	55                   	push   %ebp
  8012de:	89 e5                	mov    %esp,%ebp
  8012e0:	83 ec 38             	sub    $0x38,%esp
  8012e3:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  8012e6:	89 75 f8             	mov    %esi,-0x8(%ebp)
  8012e9:	89 7d fc             	mov    %edi,-0x4(%ebp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8012ec:	b8 05 00 00 00       	mov    $0x5,%eax
  8012f1:	8b 75 18             	mov    0x18(%ebp),%esi
  8012f4:	8b 7d 14             	mov    0x14(%ebp),%edi
  8012f7:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8012fa:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8012fd:	8b 55 08             	mov    0x8(%ebp),%edx
  801300:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
	
	if(check && ret > 0)
  801302:	85 c0                	test   %eax,%eax
  801304:	7e 28                	jle    80132e <sys_page_map+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  801306:	89 44 24 10          	mov    %eax,0x10(%esp)
  80130a:	c7 44 24 0c 05 00 00 	movl   $0x5,0xc(%esp)
  801311:	00 
  801312:	c7 44 24 08 1f 34 80 	movl   $0x80341f,0x8(%esp)
  801319:	00 
  80131a:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  801321:	00 
  801322:	c7 04 24 3c 34 80 00 	movl   $0x80343c,(%esp)
  801329:	e8 96 f0 ff ff       	call   8003c4 <_panic>

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  80132e:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  801331:	8b 75 f8             	mov    -0x8(%ebp),%esi
  801334:	8b 7d fc             	mov    -0x4(%ebp),%edi
  801337:	89 ec                	mov    %ebp,%esp
  801339:	5d                   	pop    %ebp
  80133a:	c3                   	ret    

0080133b <sys_page_alloc>:
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  80133b:	55                   	push   %ebp
  80133c:	89 e5                	mov    %esp,%ebp
  80133e:	83 ec 38             	sub    $0x38,%esp
  801341:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  801344:	89 75 f8             	mov    %esi,-0x8(%ebp)
  801347:	89 7d fc             	mov    %edi,-0x4(%ebp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80134a:	be 00 00 00 00       	mov    $0x0,%esi
  80134f:	b8 04 00 00 00       	mov    $0x4,%eax
  801354:	8b 5d 10             	mov    0x10(%ebp),%ebx
  801357:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80135a:	8b 55 08             	mov    0x8(%ebp),%edx
  80135d:	89 f7                	mov    %esi,%edi
  80135f:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
	
	if(check && ret > 0)
  801361:	85 c0                	test   %eax,%eax
  801363:	7e 28                	jle    80138d <sys_page_alloc+0x52>
		panic("syscall %d returned %d (> 0)", num, ret);
  801365:	89 44 24 10          	mov    %eax,0x10(%esp)
  801369:	c7 44 24 0c 04 00 00 	movl   $0x4,0xc(%esp)
  801370:	00 
  801371:	c7 44 24 08 1f 34 80 	movl   $0x80341f,0x8(%esp)
  801378:	00 
  801379:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  801380:	00 
  801381:	c7 04 24 3c 34 80 00 	movl   $0x80343c,(%esp)
  801388:	e8 37 f0 ff ff       	call   8003c4 <_panic>

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  80138d:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  801390:	8b 75 f8             	mov    -0x8(%ebp),%esi
  801393:	8b 7d fc             	mov    -0x4(%ebp),%edi
  801396:	89 ec                	mov    %ebp,%esp
  801398:	5d                   	pop    %ebp
  801399:	c3                   	ret    

0080139a <sys_yield>:
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}

void
sys_yield(void)
{
  80139a:	55                   	push   %ebp
  80139b:	89 e5                	mov    %esp,%ebp
  80139d:	83 ec 0c             	sub    $0xc,%esp
  8013a0:	89 1c 24             	mov    %ebx,(%esp)
  8013a3:	89 74 24 04          	mov    %esi,0x4(%esp)
  8013a7:	89 7c 24 08          	mov    %edi,0x8(%esp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8013ab:	ba 00 00 00 00       	mov    $0x0,%edx
  8013b0:	b8 0b 00 00 00       	mov    $0xb,%eax
  8013b5:	89 d1                	mov    %edx,%ecx
  8013b7:	89 d3                	mov    %edx,%ebx
  8013b9:	89 d7                	mov    %edx,%edi
  8013bb:	89 d6                	mov    %edx,%esi
  8013bd:	cd 30                	int    $0x30

void
sys_yield(void)
{
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  8013bf:	8b 1c 24             	mov    (%esp),%ebx
  8013c2:	8b 74 24 04          	mov    0x4(%esp),%esi
  8013c6:	8b 7c 24 08          	mov    0x8(%esp),%edi
  8013ca:	89 ec                	mov    %ebp,%esp
  8013cc:	5d                   	pop    %ebp
  8013cd:	c3                   	ret    

008013ce <sys_getenvid>:
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}

envid_t
sys_getenvid(void)
{
  8013ce:	55                   	push   %ebp
  8013cf:	89 e5                	mov    %esp,%ebp
  8013d1:	83 ec 0c             	sub    $0xc,%esp
  8013d4:	89 1c 24             	mov    %ebx,(%esp)
  8013d7:	89 74 24 04          	mov    %esi,0x4(%esp)
  8013db:	89 7c 24 08          	mov    %edi,0x8(%esp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8013df:	ba 00 00 00 00       	mov    $0x0,%edx
  8013e4:	b8 02 00 00 00       	mov    $0x2,%eax
  8013e9:	89 d1                	mov    %edx,%ecx
  8013eb:	89 d3                	mov    %edx,%ebx
  8013ed:	89 d7                	mov    %edx,%edi
  8013ef:	89 d6                	mov    %edx,%esi
  8013f1:	cd 30                	int    $0x30

envid_t
sys_getenvid(void)
{
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  8013f3:	8b 1c 24             	mov    (%esp),%ebx
  8013f6:	8b 74 24 04          	mov    0x4(%esp),%esi
  8013fa:	8b 7c 24 08          	mov    0x8(%esp),%edi
  8013fe:	89 ec                	mov    %ebp,%esp
  801400:	5d                   	pop    %ebp
  801401:	c3                   	ret    

00801402 <sys_env_destroy>:
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}

int
sys_env_destroy(envid_t envid)
{
  801402:	55                   	push   %ebp
  801403:	89 e5                	mov    %esp,%ebp
  801405:	83 ec 38             	sub    $0x38,%esp
  801408:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  80140b:	89 75 f8             	mov    %esi,-0x8(%ebp)
  80140e:	89 7d fc             	mov    %edi,-0x4(%ebp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801411:	b9 00 00 00 00       	mov    $0x0,%ecx
  801416:	b8 03 00 00 00       	mov    $0x3,%eax
  80141b:	8b 55 08             	mov    0x8(%ebp),%edx
  80141e:	89 cb                	mov    %ecx,%ebx
  801420:	89 cf                	mov    %ecx,%edi
  801422:	89 ce                	mov    %ecx,%esi
  801424:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
	
	if(check && ret > 0)
  801426:	85 c0                	test   %eax,%eax
  801428:	7e 28                	jle    801452 <sys_env_destroy+0x50>
		panic("syscall %d returned %d (> 0)", num, ret);
  80142a:	89 44 24 10          	mov    %eax,0x10(%esp)
  80142e:	c7 44 24 0c 03 00 00 	movl   $0x3,0xc(%esp)
  801435:	00 
  801436:	c7 44 24 08 1f 34 80 	movl   $0x80341f,0x8(%esp)
  80143d:	00 
  80143e:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  801445:	00 
  801446:	c7 04 24 3c 34 80 00 	movl   $0x80343c,(%esp)
  80144d:	e8 72 ef ff ff       	call   8003c4 <_panic>

int
sys_env_destroy(envid_t envid)
{
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  801452:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  801455:	8b 75 f8             	mov    -0x8(%ebp),%esi
  801458:	8b 7d fc             	mov    -0x4(%ebp),%edi
  80145b:	89 ec                	mov    %ebp,%esp
  80145d:	5d                   	pop    %ebp
  80145e:	c3                   	ret    
	...

00801460 <sfork>:
}

// Challenge!
int
sfork(void)
{
  801460:	55                   	push   %ebp
  801461:	89 e5                	mov    %esp,%ebp
  801463:	83 ec 18             	sub    $0x18,%esp
	panic("sfork not implemented");
  801466:	c7 44 24 08 4a 34 80 	movl   $0x80344a,0x8(%esp)
  80146d:	00 
  80146e:	c7 44 24 04 f2 00 00 	movl   $0xf2,0x4(%esp)
  801475:	00 
  801476:	c7 04 24 60 34 80 00 	movl   $0x803460,(%esp)
  80147d:	e8 42 ef ff ff       	call   8003c4 <_panic>

00801482 <pgfault>:
// Custom page fault handler - if faulting page is copy-on-write,
// map in our own private writable copy.
//
static void
pgfault(struct UTrapframe *utf)
{
  801482:	55                   	push   %ebp
  801483:	89 e5                	mov    %esp,%ebp
  801485:	53                   	push   %ebx
  801486:	83 ec 24             	sub    $0x24,%esp
  801489:	8b 45 08             	mov    0x8(%ebp),%eax
	void *addr = (void *) utf->utf_fault_va;
  80148c:	8b 18                	mov    (%eax),%ebx
	uint32_t err = utf->utf_err;
  80148e:	f6 40 04 02          	testb  $0x2,0x4(%eax)
  801492:	75 1c                	jne    8014b0 <pgfault+0x2e>
	// LAB 4: Your code here.
	if ((err & FEC_WR) != FEC_WR)
	{
		if (debug)
			cprintf("Error caught = %x\n", err);
		panic ("user panic in lib/fork.c - pgfault(): faulting access is not write\n");
  801494:	c7 44 24 08 6c 34 80 	movl   $0x80346c,0x8(%esp)
  80149b:	00 
  80149c:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  8014a3:	00 
  8014a4:	c7 04 24 60 34 80 00 	movl   $0x803460,(%esp)
  8014ab:	e8 14 ef ff ff       	call   8003c4 <_panic>
	}
	pte = vpt[VPN(addr)];
  8014b0:	89 d8                	mov    %ebx,%eax
  8014b2:	c1 e8 0c             	shr    $0xc,%eax
  8014b5:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
	if ((pte & PTE_COW) != PTE_COW)
  8014bc:	f6 c4 08             	test   $0x8,%ah
  8014bf:	75 1c                	jne    8014dd <pgfault+0x5b>
		panic ("user panic in lib/fork.c - pgfault(): faulting access is not to a COW page\n");
  8014c1:	c7 44 24 08 b0 34 80 	movl   $0x8034b0,0x8(%esp)
  8014c8:	00 
  8014c9:	c7 44 24 04 27 00 00 	movl   $0x27,0x4(%esp)
  8014d0:	00 
  8014d1:	c7 04 24 60 34 80 00 	movl   $0x803460,(%esp)
  8014d8:	e8 e7 ee ff ff       	call   8003c4 <_panic>
	// Hint:
	//   You should make three system calls.
	//   No need to explicitly delete the old page's mapping.

	// LAB 4: Your code here.
	if ((r = sys_page_alloc(0, (void*)PFTEMP, PTE_P | PTE_U | PTE_W)) < 0)
  8014dd:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  8014e4:	00 
  8014e5:	c7 44 24 04 00 f0 7f 	movl   $0x7ff000,0x4(%esp)
  8014ec:	00 
  8014ed:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8014f4:	e8 42 fe ff ff       	call   80133b <sys_page_alloc>
  8014f9:	85 c0                	test   %eax,%eax
  8014fb:	79 20                	jns    80151d <pgfault+0x9b>
		panic ("user panic in lib/fork.c - pgfault(): sys_page_alloc: %e", r);
  8014fd:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801501:	c7 44 24 08 fc 34 80 	movl   $0x8034fc,0x8(%esp)
  801508:	00 
  801509:	c7 44 24 04 32 00 00 	movl   $0x32,0x4(%esp)
  801510:	00 
  801511:	c7 04 24 60 34 80 00 	movl   $0x803460,(%esp)
  801518:	e8 a7 ee ff ff       	call   8003c4 <_panic>
	
	memmove((void*)PFTEMP, (void*)ROUNDDOWN(addr,PGSIZE), PGSIZE);
  80151d:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  801523:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
  80152a:	00 
  80152b:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  80152f:	c7 04 24 00 f0 7f 00 	movl   $0x7ff000,(%esp)
  801536:	e8 ca f7 ff ff       	call   800d05 <memmove>
		
	if ((r = sys_page_map(0, (void*)PFTEMP, 0, (void*)ROUNDDOWN(addr,PGSIZE), PTE_P | PTE_U | PTE_W)) < 0)	
  80153b:	c7 44 24 10 07 00 00 	movl   $0x7,0x10(%esp)
  801542:	00 
  801543:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  801547:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  80154e:	00 
  80154f:	c7 44 24 04 00 f0 7f 	movl   $0x7ff000,0x4(%esp)
  801556:	00 
  801557:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80155e:	e8 7a fd ff ff       	call   8012dd <sys_page_map>
  801563:	85 c0                	test   %eax,%eax
  801565:	79 20                	jns    801587 <pgfault+0x105>
		panic ("user panic in lib/fork.c - pgfault(): sys_page_map: %e", r);
  801567:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80156b:	c7 44 24 08 38 35 80 	movl   $0x803538,0x8(%esp)
  801572:	00 
  801573:	c7 44 24 04 37 00 00 	movl   $0x37,0x4(%esp)
  80157a:	00 
  80157b:	c7 04 24 60 34 80 00 	movl   $0x803460,(%esp)
  801582:	e8 3d ee ff ff       	call   8003c4 <_panic>
	if ((r = sys_page_unmap(0, (void*)PFTEMP)) < 0)
  801587:	c7 44 24 04 00 f0 7f 	movl   $0x7ff000,0x4(%esp)
  80158e:	00 
  80158f:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801596:	e8 e4 fc ff ff       	call   80127f <sys_page_unmap>
  80159b:	85 c0                	test   %eax,%eax
  80159d:	79 20                	jns    8015bf <pgfault+0x13d>
		panic ("user panic in lib/fork.c - pgfault(): sys_page_unmap: %e", r);
  80159f:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8015a3:	c7 44 24 08 70 35 80 	movl   $0x803570,0x8(%esp)
  8015aa:	00 
  8015ab:	c7 44 24 04 39 00 00 	movl   $0x39,0x4(%esp)
  8015b2:	00 
  8015b3:	c7 04 24 60 34 80 00 	movl   $0x803460,(%esp)
  8015ba:	e8 05 ee ff ff       	call   8003c4 <_panic>
	// panic("pgfault not implemented");
}
  8015bf:	83 c4 24             	add    $0x24,%esp
  8015c2:	5b                   	pop    %ebx
  8015c3:	5d                   	pop    %ebp
  8015c4:	c3                   	ret    

008015c5 <fork>:
//   Neither user exception stack should ever be marked copy-on-write,
//   so you must allocate a new page for the child's user exception stack.
//
envid_t
fork(void)
{
  8015c5:	55                   	push   %ebp
  8015c6:	89 e5                	mov    %esp,%ebp
  8015c8:	57                   	push   %edi
  8015c9:	56                   	push   %esi
  8015ca:	53                   	push   %ebx
  8015cb:	83 ec 3c             	sub    $0x3c,%esp
	int r;
	uint32_t pde_x, pte_x, vpn;	// page directory index, page table index and page number
	

	// Set up our page fault handler appropriately.
	set_pgfault_handler(pgfault);
  8015ce:	c7 04 24 82 14 80 00 	movl   $0x801482,(%esp)
  8015d5:	e8 12 16 00 00       	call   802bec <set_pgfault_handler>
static __inline envid_t sys_exofork(void) __attribute__((always_inline));
static __inline envid_t
sys_exofork(void)
{
	envid_t ret;
	__asm __volatile("int %2"
  8015da:	ba 07 00 00 00       	mov    $0x7,%edx
  8015df:	89 d0                	mov    %edx,%eax
  8015e1:	cd 30                	int    $0x30
  8015e3:	89 45 e0             	mov    %eax,-0x20(%ebp)
		cprintf("\n After set_pgfaulthandler()\n");
	// Create a child.
	child_envid = sys_exofork();
	if (debug)
		cprintf("\n After exofork()\n");
	if (child_envid < 0)
  8015e6:	85 c0                	test   %eax,%eax
  8015e8:	0f 88 21 02 00 00    	js     80180f <fork+0x24a>
	if (child_envid == 0)
	{
		if (debug)
			cprintf("\n After child_envid == 0\n");
		env = &envs[ENVX(sys_getenvid())];
		return 0;
  8015ee:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
		return child_envid;
	if (debug)
		cprintf("\n After child_envid >= 0\n");
		// panic(" panic in lib/fork.c - fork():sys_exofork: %e", child_env);
	// fix "env" in the child process
	if (child_envid == 0)
  8015f5:	85 c0                	test   %eax,%eax
  8015f7:	75 1c                	jne    801615 <fork+0x50>
	{
		if (debug)
			cprintf("\n After child_envid == 0\n");
		env = &envs[ENVX(sys_getenvid())];
  8015f9:	e8 d0 fd ff ff       	call   8013ce <sys_getenvid>
  8015fe:	25 ff 03 00 00       	and    $0x3ff,%eax
  801603:	6b c0 7c             	imul   $0x7c,%eax,%eax
  801606:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  80160b:	a3 78 70 80 00       	mov    %eax,0x807078
		return 0;
  801610:	e9 fa 01 00 00       	jmp    80180f <fork+0x24a>
	// Map the address space except the user exception stack
	if (debug)
		cprintf("\n After child_envid > 0\n");
	for (pde_x = VPD(0); pde_x < VPD(UTOP); pde_x++)
	{
		if ((vpd[pde_x] & PTE_P) == PTE_P)
  801615:	8b 55 dc             	mov    -0x24(%ebp),%edx
  801618:	8b 04 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%eax
  80161f:	a8 01                	test   $0x1,%al
  801621:	0f 84 16 01 00 00    	je     80173d <fork+0x178>
		{
			for (pte_x = 0; pte_x < NPTENTRIES; pte_x++)
			{
				vpn = (pde_x << (PDXSHIFT - PTXSHIFT)) + pte_x;		//removed hardcoding
  801627:	89 d3                	mov    %edx,%ebx
  801629:	c1 e3 0a             	shl    $0xa,%ebx
  80162c:	89 d7                	mov    %edx,%edi
  80162e:	c1 e7 16             	shl    $0x16,%edi
  801631:	be 00 00 00 00       	mov    $0x0,%esi
				if(((vpt[vpn] & PTE_P) == PTE_P) && (vpn < VPN(UXSTACKTOP - PGSIZE)))
  801636:	8b 04 9d 00 00 40 ef 	mov    -0x10c00000(,%ebx,4),%eax
  80163d:	a8 01                	test   $0x1,%al
  80163f:	0f 84 e0 00 00 00    	je     801725 <fork+0x160>
  801645:	81 fb fe eb 0e 00    	cmp    $0xeebfe,%ebx
  80164b:	0f 87 d4 00 00 00    	ja     801725 <fork+0x160>
	
	// LAB 4: Your code here.
	if (debug)
		cprintf("\n duppage: 1\n");	

	pte_t pte = vpt[pn];
  801651:	8b 14 9d 00 00 40 ef 	mov    -0x10c00000(,%ebx,4),%edx
	int perm = pte & PTE_USER;
  801658:	89 d0                	mov    %edx,%eax
  80165a:	25 07 0e 00 00       	and    $0xe07,%eax
	void *va = (void*) (pn*PGSIZE);	
	if (debug)
		cprintf("\n duppage: 2\n");	
	
	if ((perm & PTE_P) != PTE_P)
  80165f:	f6 c2 01             	test   $0x1,%dl
  801662:	75 1c                	jne    801680 <fork+0xbb>
		panic ("user panic: lib\fork.c: duppage(): page to be duplicated is not PTE_P\n");
  801664:	c7 44 24 08 ac 35 80 	movl   $0x8035ac,0x8(%esp)
  80166b:	00 
  80166c:	c7 44 24 04 58 00 00 	movl   $0x58,0x4(%esp)
  801673:	00 
  801674:	c7 04 24 60 34 80 00 	movl   $0x803460,(%esp)
  80167b:	e8 44 ed ff ff       	call   8003c4 <_panic>
	if ((perm & PTE_U) != PTE_U)
  801680:	a8 04                	test   $0x4,%al
  801682:	75 1c                	jne    8016a0 <fork+0xdb>
		panic ("user panic: lib\fork.c: duppage(): page to be duplicated is not PTE_U\n");
  801684:	c7 44 24 08 f4 35 80 	movl   $0x8035f4,0x8(%esp)
  80168b:	00 
  80168c:	c7 44 24 04 5a 00 00 	movl   $0x5a,0x4(%esp)
  801693:	00 
  801694:	c7 04 24 60 34 80 00 	movl   $0x803460,(%esp)
  80169b:	e8 24 ed ff ff       	call   8003c4 <_panic>
  8016a0:	89 7d e4             	mov    %edi,-0x1c(%ebp)
	if (debug)
		cprintf("\n duppage: 3\n");	

	// LAB 7: Include PTE_SHARE convention
	if ( !(perm & PTE_SHARE) && (((perm & PTE_W) == PTE_W) || ((perm & PTE_COW) == PTE_COW)))
  8016a3:	f6 c4 04             	test   $0x4,%ah
  8016a6:	75 5b                	jne    801703 <fork+0x13e>
  8016a8:	a9 02 08 00 00       	test   $0x802,%eax
  8016ad:	74 54                	je     801703 <fork+0x13e>
	{
		if (debug)
			cprintf("\n duppage: 4\n");	
		// perm = PTE_P | PTE_U | PTE_COW;	// buggy permissions, removed in LAB 7
		perm &= ~PTE_W;				// remove write from perm
  8016af:	83 e0 fd             	and    $0xfffffffd,%eax
		perm |= PTE_COW;			// add copy-on-write
  8016b2:	80 cc 08             	or     $0x8,%ah
  8016b5:	89 45 d8             	mov    %eax,-0x28(%ebp)
		if (debug)
			cprintf("\n duppage: 10\n");	
		if ((r = sys_page_map(0, va, envid, va, perm)) < 0)
  8016b8:	89 44 24 10          	mov    %eax,0x10(%esp)
  8016bc:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8016c0:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8016c3:	89 54 24 08          	mov    %edx,0x8(%esp)
  8016c7:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8016cb:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8016d2:	e8 06 fc ff ff       	call   8012dd <sys_page_map>
  8016d7:	85 c0                	test   %eax,%eax
  8016d9:	78 4a                	js     801725 <fork+0x160>
			return r;
		if (debug)
			cprintf("\n duppage: 11\n");	
		if ((r = sys_page_map(0, va, 0, va, perm)) < 0)
  8016db:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8016de:	89 44 24 10          	mov    %eax,0x10(%esp)
  8016e2:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8016e5:	89 54 24 0c          	mov    %edx,0xc(%esp)
  8016e9:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  8016f0:	00 
  8016f1:	89 54 24 04          	mov    %edx,0x4(%esp)
  8016f5:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8016fc:	e8 dc fb ff ff       	call   8012dd <sys_page_map>
  801701:	eb 22                	jmp    801725 <fork+0x160>
	// LAB 7: Include PTE_SHARE convention
	else
	{
		if (debug)
			cprintf("\n duppage: 6\n");	
		if ((r = sys_page_map(0, va, envid, va, perm)) < 0)
  801703:	89 44 24 10          	mov    %eax,0x10(%esp)
  801707:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80170a:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80170e:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801711:	89 54 24 08          	mov    %edx,0x8(%esp)
  801715:	89 44 24 04          	mov    %eax,0x4(%esp)
  801719:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801720:	e8 b8 fb ff ff       	call   8012dd <sys_page_map>
		cprintf("\n After child_envid > 0\n");
	for (pde_x = VPD(0); pde_x < VPD(UTOP); pde_x++)
	{
		if ((vpd[pde_x] & PTE_P) == PTE_P)
		{
			for (pte_x = 0; pte_x < NPTENTRIES; pte_x++)
  801725:	83 c6 01             	add    $0x1,%esi
  801728:	83 c3 01             	add    $0x1,%ebx
  80172b:	81 c7 00 10 00 00    	add    $0x1000,%edi
  801731:	81 fe 00 04 00 00    	cmp    $0x400,%esi
  801737:	0f 85 f9 fe ff ff    	jne    801636 <fork+0x71>
	}
	// reached here... we're the parent process
	// Map the address space except the user exception stack
	if (debug)
		cprintf("\n After child_envid > 0\n");
	for (pde_x = VPD(0); pde_x < VPD(UTOP); pde_x++)
  80173d:	83 45 dc 01          	addl   $0x1,-0x24(%ebp)
  801741:	81 7d dc bb 03 00 00 	cmpl   $0x3bb,-0x24(%ebp)
  801748:	0f 85 c7 fe ff ff    	jne    801615 <fork+0x50>
	}	
	if (debug)
		cprintf("\n After duppaging()\n");
	// Allocate and copy the use exception stack for the child environment
	// Allocate a page for the stack in the child
	if ((r = sys_page_alloc(child_envid, (void*)(UXSTACKTOP - PGSIZE), PTE_P | PTE_U | PTE_W)) < 0)
  80174e:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  801755:	00 
  801756:	c7 44 24 04 00 f0 bf 	movl   $0xeebff000,0x4(%esp)
  80175d:	ee 
  80175e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801761:	89 04 24             	mov    %eax,(%esp)
  801764:	e8 d2 fb ff ff       	call   80133b <sys_page_alloc>
  801769:	85 c0                	test   %eax,%eax
  80176b:	79 08                	jns    801775 <fork+0x1b0>
  80176d:	89 45 e0             	mov    %eax,-0x20(%ebp)
  801770:	e9 9a 00 00 00       	jmp    80180f <fork+0x24a>
		return r;
	if (debug)
		cprintf("\n After set_pgfaulthandler()\n");
	// Map this page to a free virtual address space in parent
	if ((r = sys_page_map(child_envid, (void*)(UXSTACKTOP - PGSIZE), 0, (void*)UTEMP, PTE_P | PTE_U | PTE_W)) < 0)
  801775:	c7 44 24 10 07 00 00 	movl   $0x7,0x10(%esp)
  80177c:	00 
  80177d:	c7 44 24 0c 00 00 40 	movl   $0x400000,0xc(%esp)
  801784:	00 
  801785:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  80178c:	00 
  80178d:	c7 44 24 04 00 f0 bf 	movl   $0xeebff000,0x4(%esp)
  801794:	ee 
  801795:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801798:	89 14 24             	mov    %edx,(%esp)
  80179b:	e8 3d fb ff ff       	call   8012dd <sys_page_map>
  8017a0:	85 c0                	test   %eax,%eax
  8017a2:	79 05                	jns    8017a9 <fork+0x1e4>
  8017a4:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8017a7:	eb 66                	jmp    80180f <fork+0x24a>
		return r;
	if (debug)
		cprintf("\n After sys_page_map()\n");
	// Copy the parent exception stack to the above, i.e. page from child mapped to parent's address space
	memmove((void*)UTEMP, (void*)(UXSTACKTOP - PGSIZE), PGSIZE);
  8017a9:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
  8017b0:	00 
  8017b1:	c7 44 24 04 00 f0 bf 	movl   $0xeebff000,0x4(%esp)
  8017b8:	ee 
  8017b9:	c7 04 24 00 00 40 00 	movl   $0x400000,(%esp)
  8017c0:	e8 40 f5 ff ff       	call   800d05 <memmove>
	if (debug)
		cprintf("\n After memmove()\n");
	// Unmap this page from the parent
	sys_page_unmap(0, (void*)UTEMP);
  8017c5:	c7 44 24 04 00 00 40 	movl   $0x400000,0x4(%esp)
  8017cc:	00 
  8017cd:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8017d4:	e8 a6 fa ff ff       	call   80127f <sys_page_unmap>
	if (debug)
		cprintf("\n After sys_page_unmap()\n");

	// Set up the page fault handler
	if ((r = sys_env_set_pgfault_upcall(child_envid, _pgfault_upcall)) < 0)
  8017d9:	c7 44 24 04 80 2c 80 	movl   $0x802c80,0x4(%esp)
  8017e0:	00 
  8017e1:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8017e4:	89 04 24             	mov    %eax,(%esp)
  8017e7:	e8 79 f9 ff ff       	call   801165 <sys_env_set_pgfault_upcall>
  8017ec:	85 c0                	test   %eax,%eax
  8017ee:	79 05                	jns    8017f5 <fork+0x230>
  8017f0:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8017f3:	eb 1a                	jmp    80180f <fork+0x24a>
		// panic(" panic in lib/fork.c - fork():sys_env_set_pgfault_upcall: %e", child_env);
	if (debug)
		cprintf("\n After set_upcall()\n");

	// Mark the child runnable
	if ((r = sys_env_set_status(child_envid, ENV_RUNNABLE)) < 0)
  8017f5:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  8017fc:	00 
  8017fd:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801800:	89 14 24             	mov    %edx,(%esp)
  801803:	e8 19 fa ff ff       	call   801221 <sys_env_set_status>
  801808:	85 c0                	test   %eax,%eax
  80180a:	79 03                	jns    80180f <fork+0x24a>
  80180c:	89 45 e0             	mov    %eax,-0x20(%ebp)
	if (debug)
		cprintf("\n After set_status()\n");
	
	return child_envid;
	
}
  80180f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801812:	83 c4 3c             	add    $0x3c,%esp
  801815:	5b                   	pop    %ebx
  801816:	5e                   	pop    %esi
  801817:	5f                   	pop    %edi
  801818:	5d                   	pop    %ebp
  801819:	c3                   	ret    
  80181a:	00 00                	add    %al,(%eax)
  80181c:	00 00                	add    %al,(%eax)
	...

00801820 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  801820:	55                   	push   %ebp
  801821:	89 e5                	mov    %esp,%ebp
  801823:	57                   	push   %edi
  801824:	56                   	push   %esi
  801825:	53                   	push   %ebx
  801826:	83 ec 1c             	sub    $0x1c,%esp
  801829:	8b 7d 0c             	mov    0xc(%ebp),%edi
  80182c:	8b 5d 10             	mov    0x10(%ebp),%ebx
  80182f:	8b 75 14             	mov    0x14(%ebp),%esi
	// LAB 4: Your code here.
	int r;
	if (pg == NULL)
  801832:	85 db                	test   %ebx,%ebx
  801834:	75 2d                	jne    801863 <ipc_send+0x43>
  801836:	bb 00 00 c0 ee       	mov    $0xeec00000,%ebx
  80183b:	eb 26                	jmp    801863 <ipc_send+0x43>
		pg = (void*)UTOP;
	while ((r = sys_ipc_try_send(to_env, val, pg, perm)) < 0)
	{
		if(r != -E_IPC_NOT_RECV)
  80183d:	83 f8 f9             	cmp    $0xfffffff9,%eax
  801840:	74 1c                	je     80185e <ipc_send+0x3e>
			panic("Panic in lib ipc.c : ipc_send() \n");
  801842:	c7 44 24 08 3c 36 80 	movl   $0x80363c,0x8(%esp)
  801849:	00 
  80184a:	c7 44 24 04 44 00 00 	movl   $0x44,0x4(%esp)
  801851:	00 
  801852:	c7 04 24 5e 36 80 00 	movl   $0x80365e,(%esp)
  801859:	e8 66 eb ff ff       	call   8003c4 <_panic>
		sys_yield();
  80185e:	e8 37 fb ff ff       	call   80139a <sys_yield>
{
	// LAB 4: Your code here.
	int r;
	if (pg == NULL)
		pg = (void*)UTOP;
	while ((r = sys_ipc_try_send(to_env, val, pg, perm)) < 0)
  801863:	89 74 24 0c          	mov    %esi,0xc(%esp)
  801867:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80186b:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80186f:	8b 45 08             	mov    0x8(%ebp),%eax
  801872:	89 04 24             	mov    %eax,(%esp)
  801875:	e8 b3 f8 ff ff       	call   80112d <sys_ipc_try_send>
  80187a:	85 c0                	test   %eax,%eax
  80187c:	78 bf                	js     80183d <ipc_send+0x1d>
		if(r != -E_IPC_NOT_RECV)
			panic("Panic in lib ipc.c : ipc_send() \n");
		sys_yield();
	}
	//panic("ipc_send not implemented");
}
  80187e:	83 c4 1c             	add    $0x1c,%esp
  801881:	5b                   	pop    %ebx
  801882:	5e                   	pop    %esi
  801883:	5f                   	pop    %edi
  801884:	5d                   	pop    %ebp
  801885:	c3                   	ret    

00801886 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  801886:	55                   	push   %ebp
  801887:	89 e5                	mov    %esp,%ebp
  801889:	56                   	push   %esi
  80188a:	53                   	push   %ebx
  80188b:	83 ec 10             	sub    $0x10,%esp
  80188e:	8b 5d 08             	mov    0x8(%ebp),%ebx
  801891:	8b 45 0c             	mov    0xc(%ebp),%eax
  801894:	8b 75 10             	mov    0x10(%ebp),%esi
	// LAB 4: Your code here.
	int r;

	if (pg == NULL)
  801897:	85 c0                	test   %eax,%eax
  801899:	75 05                	jne    8018a0 <ipc_recv+0x1a>
  80189b:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
		pg = (void*)UTOP;
	if ((r = sys_ipc_recv(pg)) < 0)
  8018a0:	89 04 24             	mov    %eax,(%esp)
  8018a3:	e8 28 f8 ff ff       	call   8010d0 <sys_ipc_recv>
  8018a8:	85 c0                	test   %eax,%eax
  8018aa:	79 16                	jns    8018c2 <ipc_recv+0x3c>
	{
		if (from_env_store != NULL)
  8018ac:	85 db                	test   %ebx,%ebx
  8018ae:	74 06                	je     8018b6 <ipc_recv+0x30>
			*from_env_store = 0;
  8018b0:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
		if(perm_store != NULL)
  8018b6:	85 f6                	test   %esi,%esi
  8018b8:	74 2c                	je     8018e6 <ipc_recv+0x60>
			*perm_store = 0;
  8018ba:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
  8018c0:	eb 24                	jmp    8018e6 <ipc_recv+0x60>
		return r;
	}
	else
	{	
		if (from_env_store != NULL)
  8018c2:	85 db                	test   %ebx,%ebx
  8018c4:	74 0a                	je     8018d0 <ipc_recv+0x4a>
			*from_env_store = env->env_ipc_from;
  8018c6:	a1 78 70 80 00       	mov    0x807078,%eax
  8018cb:	8b 40 74             	mov    0x74(%eax),%eax
  8018ce:	89 03                	mov    %eax,(%ebx)
		if(perm_store != NULL)
  8018d0:	85 f6                	test   %esi,%esi
  8018d2:	74 0a                	je     8018de <ipc_recv+0x58>
			*perm_store = env->env_ipc_perm;
  8018d4:	a1 78 70 80 00       	mov    0x807078,%eax
  8018d9:	8b 40 78             	mov    0x78(%eax),%eax
  8018dc:	89 06                	mov    %eax,(%esi)
		return env->env_ipc_value;
  8018de:	a1 78 70 80 00       	mov    0x807078,%eax
  8018e3:	8b 40 70             	mov    0x70(%eax),%eax
	}		
	//panic("ipc_recv not implemented");
	//return 0;
}
  8018e6:	83 c4 10             	add    $0x10,%esp
  8018e9:	5b                   	pop    %ebx
  8018ea:	5e                   	pop    %esi
  8018eb:	5d                   	pop    %ebp
  8018ec:	c3                   	ret    
  8018ed:	00 00                	add    %al,(%eax)
	...

008018f0 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  8018f0:	55                   	push   %ebp
  8018f1:	89 e5                	mov    %esp,%ebp
  8018f3:	8b 45 08             	mov    0x8(%ebp),%eax
  8018f6:	05 00 00 00 30       	add    $0x30000000,%eax
  8018fb:	c1 e8 0c             	shr    $0xc,%eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
}
  8018fe:	5d                   	pop    %ebp
  8018ff:	c3                   	ret    

00801900 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  801900:	55                   	push   %ebp
  801901:	89 e5                	mov    %esp,%ebp
  801903:	83 ec 04             	sub    $0x4,%esp
	return INDEX2DATA(fd2num(fd));
  801906:	8b 45 08             	mov    0x8(%ebp),%eax
  801909:	89 04 24             	mov    %eax,(%esp)
  80190c:	e8 df ff ff ff       	call   8018f0 <fd2num>
  801911:	05 20 00 0d 00       	add    $0xd0020,%eax
  801916:	c1 e0 0c             	shl    $0xc,%eax
}
  801919:	c9                   	leave  
  80191a:	c3                   	ret    

0080191b <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  80191b:	55                   	push   %ebp
  80191c:	89 e5                	mov    %esp,%ebp
  80191e:	57                   	push   %edi
  80191f:	56                   	push   %esi
  801920:	53                   	push   %ebx
  801921:	8b 7d 08             	mov    0x8(%ebp),%edi
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((vpd[PDX(fd)] & PTE_P) == 0 || (vpt[VPN(fd)] & PTE_P) == 0) {
  801924:	a1 00 dd 7b ef       	mov    0xef7bdd00,%eax
  801929:	a8 01                	test   $0x1,%al
  80192b:	74 36                	je     801963 <fd_alloc+0x48>
  80192d:	a1 00 00 74 ef       	mov    0xef740000,%eax
  801932:	a8 01                	test   $0x1,%al
  801934:	74 2d                	je     801963 <fd_alloc+0x48>
  801936:	b8 00 10 00 d0       	mov    $0xd0001000,%eax
  80193b:	b9 00 d0 7b ef       	mov    $0xef7bd000,%ecx
  801940:	be 00 00 40 ef       	mov    $0xef400000,%esi
  801945:	89 c3                	mov    %eax,%ebx
  801947:	89 c2                	mov    %eax,%edx
  801949:	c1 ea 16             	shr    $0x16,%edx
  80194c:	8b 14 91             	mov    (%ecx,%edx,4),%edx
  80194f:	f6 c2 01             	test   $0x1,%dl
  801952:	74 14                	je     801968 <fd_alloc+0x4d>
  801954:	89 c2                	mov    %eax,%edx
  801956:	c1 ea 0c             	shr    $0xc,%edx
  801959:	8b 14 96             	mov    (%esi,%edx,4),%edx
  80195c:	f6 c2 01             	test   $0x1,%dl
  80195f:	75 10                	jne    801971 <fd_alloc+0x56>
  801961:	eb 05                	jmp    801968 <fd_alloc+0x4d>
  801963:	bb 00 00 00 d0       	mov    $0xd0000000,%ebx
			*fd_store = fd;
  801968:	89 1f                	mov    %ebx,(%edi)
  80196a:	b8 00 00 00 00       	mov    $0x0,%eax
			return 0;
  80196f:	eb 17                	jmp    801988 <fd_alloc+0x6d>
  801971:	05 00 10 00 00       	add    $0x1000,%eax
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  801976:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  80197b:	75 c8                	jne    801945 <fd_alloc+0x2a>
		if ((vpd[PDX(fd)] & PTE_P) == 0 || (vpt[VPN(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  80197d:	c7 07 00 00 00 00    	movl   $0x0,(%edi)
  801983:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
	return -E_MAX_OPEN;
}
  801988:	5b                   	pop    %ebx
  801989:	5e                   	pop    %esi
  80198a:	5f                   	pop    %edi
  80198b:	5d                   	pop    %ebp
  80198c:	c3                   	ret    

0080198d <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  80198d:	55                   	push   %ebp
  80198e:	89 e5                	mov    %esp,%ebp
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  801990:	8b 45 08             	mov    0x8(%ebp),%eax
  801993:	83 f8 1f             	cmp    $0x1f,%eax
  801996:	77 36                	ja     8019ce <fd_lookup+0x41>
		if (debug)
			cprintf("[%08x] bad fd %d\n", env->env_id, fd);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  801998:	05 00 00 0d 00       	add    $0xd0000,%eax
  80199d:	c1 e0 0c             	shl    $0xc,%eax
	if (!(vpd[PDX(fd)] & PTE_P) || !(vpt[VPN(fd)] & PTE_P)) {
  8019a0:	89 c2                	mov    %eax,%edx
  8019a2:	c1 ea 16             	shr    $0x16,%edx
  8019a5:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  8019ac:	f6 c2 01             	test   $0x1,%dl
  8019af:	74 1d                	je     8019ce <fd_lookup+0x41>
  8019b1:	89 c2                	mov    %eax,%edx
  8019b3:	c1 ea 0c             	shr    $0xc,%edx
  8019b6:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8019bd:	f6 c2 01             	test   $0x1,%dl
  8019c0:	74 0c                	je     8019ce <fd_lookup+0x41>
		if (debug)
			cprintf("[%08x] closed fd %d\n", env->env_id, fd);
		return -E_INVAL;
	}
	*fd_store = fd;
  8019c2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8019c5:	89 02                	mov    %eax,(%edx)
  8019c7:	b8 00 00 00 00       	mov    $0x0,%eax
	return 0;
  8019cc:	eb 05                	jmp    8019d3 <fd_lookup+0x46>
  8019ce:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  8019d3:	5d                   	pop    %ebp
  8019d4:	c3                   	ret    

008019d5 <seek>:
	return (*dev->dev_write)(fd, buf, n);
}

int
seek(int fdnum, off_t offset)
{
  8019d5:	55                   	push   %ebp
  8019d6:	89 e5                	mov    %esp,%ebp
  8019d8:	83 ec 18             	sub    $0x18,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8019db:	8d 45 fc             	lea    -0x4(%ebp),%eax
  8019de:	89 44 24 04          	mov    %eax,0x4(%esp)
  8019e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8019e5:	89 04 24             	mov    %eax,(%esp)
  8019e8:	e8 a0 ff ff ff       	call   80198d <fd_lookup>
  8019ed:	85 c0                	test   %eax,%eax
  8019ef:	78 0e                	js     8019ff <seek+0x2a>
		return r;
	fd->fd_offset = offset;
  8019f1:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8019f4:	8b 55 0c             	mov    0xc(%ebp),%edx
  8019f7:	89 50 04             	mov    %edx,0x4(%eax)
  8019fa:	b8 00 00 00 00       	mov    $0x0,%eax
	return 0;
}
  8019ff:	c9                   	leave  
  801a00:	c3                   	ret    

00801a01 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  801a01:	55                   	push   %ebp
  801a02:	89 e5                	mov    %esp,%ebp
  801a04:	56                   	push   %esi
  801a05:	53                   	push   %ebx
  801a06:	83 ec 10             	sub    $0x10,%esp
  801a09:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801a0c:	8b 5d 0c             	mov    0xc(%ebp),%ebx
// File functions
// --------------------------------------------------------------

static struct Dev *devtab[] =
{
	&devfile,
  801a0f:	b8 04 70 80 00       	mov    $0x807004,%eax
{
	int i;
	for (i = 0; devtab[i]; i++)
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
  801a14:	ba 00 00 00 00       	mov    $0x0,%edx

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  801a19:	be e4 36 80 00       	mov    $0x8036e4,%esi
		if (devtab[i]->dev_id == dev_id) {
  801a1e:	39 08                	cmp    %ecx,(%eax)
  801a20:	75 10                	jne    801a32 <dev_lookup+0x31>
  801a22:	eb 04                	jmp    801a28 <dev_lookup+0x27>
  801a24:	39 08                	cmp    %ecx,(%eax)
  801a26:	75 0a                	jne    801a32 <dev_lookup+0x31>
			*dev = devtab[i];
  801a28:	89 03                	mov    %eax,(%ebx)
  801a2a:	b8 00 00 00 00       	mov    $0x0,%eax
			return 0;
  801a2f:	90                   	nop
  801a30:	eb 31                	jmp    801a63 <dev_lookup+0x62>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  801a32:	83 c2 01             	add    $0x1,%edx
  801a35:	8b 04 96             	mov    (%esi,%edx,4),%eax
  801a38:	85 c0                	test   %eax,%eax
  801a3a:	75 e8                	jne    801a24 <dev_lookup+0x23>
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", env->env_id, dev_id);
  801a3c:	a1 78 70 80 00       	mov    0x807078,%eax
  801a41:	8b 40 4c             	mov    0x4c(%eax),%eax
  801a44:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801a48:	89 44 24 04          	mov    %eax,0x4(%esp)
  801a4c:	c7 04 24 68 36 80 00 	movl   $0x803668,(%esp)
  801a53:	e8 31 ea ff ff       	call   800489 <cprintf>
	*dev = 0;
  801a58:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  801a5e:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
	return -E_INVAL;
}
  801a63:	83 c4 10             	add    $0x10,%esp
  801a66:	5b                   	pop    %ebx
  801a67:	5e                   	pop    %esi
  801a68:	5d                   	pop    %ebp
  801a69:	c3                   	ret    

00801a6a <fstat>:
	return (*dev->dev_trunc)(fd, newsize);
}

int
fstat(int fdnum, struct Stat *stat)
{
  801a6a:	55                   	push   %ebp
  801a6b:	89 e5                	mov    %esp,%ebp
  801a6d:	53                   	push   %ebx
  801a6e:	83 ec 24             	sub    $0x24,%esp
  801a71:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801a74:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801a77:	89 44 24 04          	mov    %eax,0x4(%esp)
  801a7b:	8b 45 08             	mov    0x8(%ebp),%eax
  801a7e:	89 04 24             	mov    %eax,(%esp)
  801a81:	e8 07 ff ff ff       	call   80198d <fd_lookup>
  801a86:	85 c0                	test   %eax,%eax
  801a88:	78 53                	js     801add <fstat+0x73>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801a8a:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801a8d:	89 44 24 04          	mov    %eax,0x4(%esp)
  801a91:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801a94:	8b 00                	mov    (%eax),%eax
  801a96:	89 04 24             	mov    %eax,(%esp)
  801a99:	e8 63 ff ff ff       	call   801a01 <dev_lookup>
{
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801a9e:	85 c0                	test   %eax,%eax
  801aa0:	78 3b                	js     801add <fstat+0x73>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if (!dev->dev_stat)
  801aa2:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801aa7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801aaa:	83 7a 14 00          	cmpl   $0x0,0x14(%edx)
  801aae:	74 2d                	je     801add <fstat+0x73>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  801ab0:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  801ab3:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  801aba:	00 00 00 
	stat->st_isdir = 0;
  801abd:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801ac4:	00 00 00 
	stat->st_dev = dev;
  801ac7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801aca:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  801ad0:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801ad4:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801ad7:	89 14 24             	mov    %edx,(%esp)
  801ada:	ff 50 14             	call   *0x14(%eax)
}
  801add:	83 c4 24             	add    $0x24,%esp
  801ae0:	5b                   	pop    %ebx
  801ae1:	5d                   	pop    %ebp
  801ae2:	c3                   	ret    

00801ae3 <ftruncate>:
	return 0;
}

int
ftruncate(int fdnum, off_t newsize)
{
  801ae3:	55                   	push   %ebp
  801ae4:	89 e5                	mov    %esp,%ebp
  801ae6:	53                   	push   %ebx
  801ae7:	83 ec 24             	sub    $0x24,%esp
  801aea:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  801aed:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801af0:	89 44 24 04          	mov    %eax,0x4(%esp)
  801af4:	89 1c 24             	mov    %ebx,(%esp)
  801af7:	e8 91 fe ff ff       	call   80198d <fd_lookup>
  801afc:	85 c0                	test   %eax,%eax
  801afe:	78 5f                	js     801b5f <ftruncate+0x7c>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801b00:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801b03:	89 44 24 04          	mov    %eax,0x4(%esp)
  801b07:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801b0a:	8b 00                	mov    (%eax),%eax
  801b0c:	89 04 24             	mov    %eax,(%esp)
  801b0f:	e8 ed fe ff ff       	call   801a01 <dev_lookup>
ftruncate(int fdnum, off_t newsize)
{
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  801b14:	85 c0                	test   %eax,%eax
  801b16:	78 47                	js     801b5f <ftruncate+0x7c>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801b18:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801b1b:	f6 42 08 03          	testb  $0x3,0x8(%edx)
  801b1f:	75 23                	jne    801b44 <ftruncate+0x61>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			env->env_id, fdnum); 
  801b21:	a1 78 70 80 00       	mov    0x807078,%eax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  801b26:	8b 40 4c             	mov    0x4c(%eax),%eax
  801b29:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801b2d:	89 44 24 04          	mov    %eax,0x4(%esp)
  801b31:	c7 04 24 88 36 80 00 	movl   $0x803688,(%esp)
  801b38:	e8 4c e9 ff ff       	call   800489 <cprintf>
  801b3d:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
			env->env_id, fdnum); 
		return -E_INVAL;
  801b42:	eb 1b                	jmp    801b5f <ftruncate+0x7c>
	}
	if (!dev->dev_trunc)
  801b44:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801b47:	8b 48 18             	mov    0x18(%eax),%ecx
  801b4a:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801b4f:	85 c9                	test   %ecx,%ecx
  801b51:	74 0c                	je     801b5f <ftruncate+0x7c>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  801b53:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b56:	89 44 24 04          	mov    %eax,0x4(%esp)
  801b5a:	89 14 24             	mov    %edx,(%esp)
  801b5d:	ff d1                	call   *%ecx
}
  801b5f:	83 c4 24             	add    $0x24,%esp
  801b62:	5b                   	pop    %ebx
  801b63:	5d                   	pop    %ebp
  801b64:	c3                   	ret    

00801b65 <write>:
	return tot;
}

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  801b65:	55                   	push   %ebp
  801b66:	89 e5                	mov    %esp,%ebp
  801b68:	53                   	push   %ebx
  801b69:	83 ec 24             	sub    $0x24,%esp
  801b6c:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801b6f:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801b72:	89 44 24 04          	mov    %eax,0x4(%esp)
  801b76:	89 1c 24             	mov    %ebx,(%esp)
  801b79:	e8 0f fe ff ff       	call   80198d <fd_lookup>
  801b7e:	85 c0                	test   %eax,%eax
  801b80:	78 66                	js     801be8 <write+0x83>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801b82:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801b85:	89 44 24 04          	mov    %eax,0x4(%esp)
  801b89:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801b8c:	8b 00                	mov    (%eax),%eax
  801b8e:	89 04 24             	mov    %eax,(%esp)
  801b91:	e8 6b fe ff ff       	call   801a01 <dev_lookup>
{
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801b96:	85 c0                	test   %eax,%eax
  801b98:	78 4e                	js     801be8 <write+0x83>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801b9a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801b9d:	f6 42 08 03          	testb  $0x3,0x8(%edx)
  801ba1:	75 23                	jne    801bc6 <write+0x61>
		cprintf("[%08x] write %d -- bad mode\n", env->env_id, fdnum);
  801ba3:	a1 78 70 80 00       	mov    0x807078,%eax
  801ba8:	8b 40 4c             	mov    0x4c(%eax),%eax
  801bab:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801baf:	89 44 24 04          	mov    %eax,0x4(%esp)
  801bb3:	c7 04 24 a9 36 80 00 	movl   $0x8036a9,(%esp)
  801bba:	e8 ca e8 ff ff       	call   800489 <cprintf>
  801bbf:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
		return -E_INVAL;
  801bc4:	eb 22                	jmp    801be8 <write+0x83>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  801bc6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801bc9:	8b 48 0c             	mov    0xc(%eax),%ecx
  801bcc:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801bd1:	85 c9                	test   %ecx,%ecx
  801bd3:	74 13                	je     801be8 <write+0x83>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  801bd5:	8b 45 10             	mov    0x10(%ebp),%eax
  801bd8:	89 44 24 08          	mov    %eax,0x8(%esp)
  801bdc:	8b 45 0c             	mov    0xc(%ebp),%eax
  801bdf:	89 44 24 04          	mov    %eax,0x4(%esp)
  801be3:	89 14 24             	mov    %edx,(%esp)
  801be6:	ff d1                	call   *%ecx
}
  801be8:	83 c4 24             	add    $0x24,%esp
  801beb:	5b                   	pop    %ebx
  801bec:	5d                   	pop    %ebp
  801bed:	c3                   	ret    

00801bee <read>:
	return r;
}

ssize_t
read(int fdnum, void *buf, size_t n)
{
  801bee:	55                   	push   %ebp
  801bef:	89 e5                	mov    %esp,%ebp
  801bf1:	53                   	push   %ebx
  801bf2:	83 ec 24             	sub    $0x24,%esp
  801bf5:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801bf8:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801bfb:	89 44 24 04          	mov    %eax,0x4(%esp)
  801bff:	89 1c 24             	mov    %ebx,(%esp)
  801c02:	e8 86 fd ff ff       	call   80198d <fd_lookup>
  801c07:	85 c0                	test   %eax,%eax
  801c09:	78 6b                	js     801c76 <read+0x88>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801c0b:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801c0e:	89 44 24 04          	mov    %eax,0x4(%esp)
  801c12:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801c15:	8b 00                	mov    (%eax),%eax
  801c17:	89 04 24             	mov    %eax,(%esp)
  801c1a:	e8 e2 fd ff ff       	call   801a01 <dev_lookup>
{
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801c1f:	85 c0                	test   %eax,%eax
  801c21:	78 53                	js     801c76 <read+0x88>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  801c23:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801c26:	8b 42 08             	mov    0x8(%edx),%eax
  801c29:	83 e0 03             	and    $0x3,%eax
  801c2c:	83 f8 01             	cmp    $0x1,%eax
  801c2f:	75 23                	jne    801c54 <read+0x66>
		cprintf("[%08x] read %d -- bad mode\n", env->env_id, fdnum); 
  801c31:	a1 78 70 80 00       	mov    0x807078,%eax
  801c36:	8b 40 4c             	mov    0x4c(%eax),%eax
  801c39:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801c3d:	89 44 24 04          	mov    %eax,0x4(%esp)
  801c41:	c7 04 24 c6 36 80 00 	movl   $0x8036c6,(%esp)
  801c48:	e8 3c e8 ff ff       	call   800489 <cprintf>
  801c4d:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
		return -E_INVAL;
  801c52:	eb 22                	jmp    801c76 <read+0x88>
	}
	if (!dev->dev_read)
  801c54:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c57:	8b 48 08             	mov    0x8(%eax),%ecx
  801c5a:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801c5f:	85 c9                	test   %ecx,%ecx
  801c61:	74 13                	je     801c76 <read+0x88>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  801c63:	8b 45 10             	mov    0x10(%ebp),%eax
  801c66:	89 44 24 08          	mov    %eax,0x8(%esp)
  801c6a:	8b 45 0c             	mov    0xc(%ebp),%eax
  801c6d:	89 44 24 04          	mov    %eax,0x4(%esp)
  801c71:	89 14 24             	mov    %edx,(%esp)
  801c74:	ff d1                	call   *%ecx
}
  801c76:	83 c4 24             	add    $0x24,%esp
  801c79:	5b                   	pop    %ebx
  801c7a:	5d                   	pop    %ebp
  801c7b:	c3                   	ret    

00801c7c <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  801c7c:	55                   	push   %ebp
  801c7d:	89 e5                	mov    %esp,%ebp
  801c7f:	57                   	push   %edi
  801c80:	56                   	push   %esi
  801c81:	53                   	push   %ebx
  801c82:	83 ec 1c             	sub    $0x1c,%esp
  801c85:	8b 7d 08             	mov    0x8(%ebp),%edi
  801c88:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  801c8b:	ba 00 00 00 00       	mov    $0x0,%edx
  801c90:	bb 00 00 00 00       	mov    $0x0,%ebx
  801c95:	b8 00 00 00 00       	mov    $0x0,%eax
  801c9a:	85 f6                	test   %esi,%esi
  801c9c:	74 29                	je     801cc7 <readn+0x4b>
		m = read(fdnum, (char*)buf + tot, n - tot);
  801c9e:	89 f0                	mov    %esi,%eax
  801ca0:	29 d0                	sub    %edx,%eax
  801ca2:	89 44 24 08          	mov    %eax,0x8(%esp)
  801ca6:	03 55 0c             	add    0xc(%ebp),%edx
  801ca9:	89 54 24 04          	mov    %edx,0x4(%esp)
  801cad:	89 3c 24             	mov    %edi,(%esp)
  801cb0:	e8 39 ff ff ff       	call   801bee <read>
		if (m < 0)
  801cb5:	85 c0                	test   %eax,%eax
  801cb7:	78 0e                	js     801cc7 <readn+0x4b>
			return m;
		if (m == 0)
  801cb9:	85 c0                	test   %eax,%eax
  801cbb:	74 08                	je     801cc5 <readn+0x49>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  801cbd:	01 c3                	add    %eax,%ebx
  801cbf:	89 da                	mov    %ebx,%edx
  801cc1:	39 f3                	cmp    %esi,%ebx
  801cc3:	72 d9                	jb     801c9e <readn+0x22>
  801cc5:	89 d8                	mov    %ebx,%eax
			return m;
		if (m == 0)
			break;
	}
	return tot;
}
  801cc7:	83 c4 1c             	add    $0x1c,%esp
  801cca:	5b                   	pop    %ebx
  801ccb:	5e                   	pop    %esi
  801ccc:	5f                   	pop    %edi
  801ccd:	5d                   	pop    %ebp
  801cce:	c3                   	ret    

00801ccf <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  801ccf:	55                   	push   %ebp
  801cd0:	89 e5                	mov    %esp,%ebp
  801cd2:	56                   	push   %esi
  801cd3:	53                   	push   %ebx
  801cd4:	83 ec 20             	sub    $0x20,%esp
  801cd7:	8b 75 08             	mov    0x8(%ebp),%esi
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801cda:	89 34 24             	mov    %esi,(%esp)
  801cdd:	e8 0e fc ff ff       	call   8018f0 <fd2num>
  801ce2:	8d 55 f4             	lea    -0xc(%ebp),%edx
  801ce5:	89 54 24 04          	mov    %edx,0x4(%esp)
  801ce9:	89 04 24             	mov    %eax,(%esp)
  801cec:	e8 9c fc ff ff       	call   80198d <fd_lookup>
  801cf1:	89 c3                	mov    %eax,%ebx
  801cf3:	85 c0                	test   %eax,%eax
  801cf5:	78 05                	js     801cfc <fd_close+0x2d>
  801cf7:	3b 75 f4             	cmp    -0xc(%ebp),%esi
  801cfa:	74 0c                	je     801d08 <fd_close+0x39>
	    || fd != fd2)
		return (must_exist ? r : 0);
  801cfc:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  801d00:	19 c0                	sbb    %eax,%eax
  801d02:	f7 d0                	not    %eax
  801d04:	21 c3                	and    %eax,%ebx
  801d06:	eb 3d                	jmp    801d45 <fd_close+0x76>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  801d08:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801d0b:	89 44 24 04          	mov    %eax,0x4(%esp)
  801d0f:	8b 06                	mov    (%esi),%eax
  801d11:	89 04 24             	mov    %eax,(%esp)
  801d14:	e8 e8 fc ff ff       	call   801a01 <dev_lookup>
  801d19:	89 c3                	mov    %eax,%ebx
  801d1b:	85 c0                	test   %eax,%eax
  801d1d:	78 16                	js     801d35 <fd_close+0x66>
		if (dev->dev_close)
  801d1f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801d22:	8b 40 10             	mov    0x10(%eax),%eax
  801d25:	bb 00 00 00 00       	mov    $0x0,%ebx
  801d2a:	85 c0                	test   %eax,%eax
  801d2c:	74 07                	je     801d35 <fd_close+0x66>
			r = (*dev->dev_close)(fd);
  801d2e:	89 34 24             	mov    %esi,(%esp)
  801d31:	ff d0                	call   *%eax
  801d33:	89 c3                	mov    %eax,%ebx
		else
			r = 0;
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  801d35:	89 74 24 04          	mov    %esi,0x4(%esp)
  801d39:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801d40:	e8 3a f5 ff ff       	call   80127f <sys_page_unmap>
	return r;
}
  801d45:	89 d8                	mov    %ebx,%eax
  801d47:	83 c4 20             	add    $0x20,%esp
  801d4a:	5b                   	pop    %ebx
  801d4b:	5e                   	pop    %esi
  801d4c:	5d                   	pop    %ebp
  801d4d:	c3                   	ret    

00801d4e <close>:
	return -E_INVAL;
}

int
close(int fdnum)
{
  801d4e:	55                   	push   %ebp
  801d4f:	89 e5                	mov    %esp,%ebp
  801d51:	83 ec 28             	sub    $0x28,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801d54:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801d57:	89 44 24 04          	mov    %eax,0x4(%esp)
  801d5b:	8b 45 08             	mov    0x8(%ebp),%eax
  801d5e:	89 04 24             	mov    %eax,(%esp)
  801d61:	e8 27 fc ff ff       	call   80198d <fd_lookup>
  801d66:	85 c0                	test   %eax,%eax
  801d68:	78 13                	js     801d7d <close+0x2f>
		return r;
	else
		return fd_close(fd, 1);
  801d6a:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  801d71:	00 
  801d72:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d75:	89 04 24             	mov    %eax,(%esp)
  801d78:	e8 52 ff ff ff       	call   801ccf <fd_close>
}
  801d7d:	c9                   	leave  
  801d7e:	c3                   	ret    

00801d7f <stat>:
	return (*dev->dev_stat)(fd, stat);
}

int
stat(const char *path, struct Stat *stat)
{
  801d7f:	55                   	push   %ebp
  801d80:	89 e5                	mov    %esp,%ebp
  801d82:	83 ec 18             	sub    $0x18,%esp
  801d85:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  801d88:	89 75 fc             	mov    %esi,-0x4(%ebp)
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  801d8b:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  801d92:	00 
  801d93:	8b 45 08             	mov    0x8(%ebp),%eax
  801d96:	89 04 24             	mov    %eax,(%esp)
  801d99:	e8 55 03 00 00       	call   8020f3 <open>
  801d9e:	89 c3                	mov    %eax,%ebx
  801da0:	85 c0                	test   %eax,%eax
  801da2:	78 1b                	js     801dbf <stat+0x40>
		return fd;
	r = fstat(fd, stat);
  801da4:	8b 45 0c             	mov    0xc(%ebp),%eax
  801da7:	89 44 24 04          	mov    %eax,0x4(%esp)
  801dab:	89 1c 24             	mov    %ebx,(%esp)
  801dae:	e8 b7 fc ff ff       	call   801a6a <fstat>
  801db3:	89 c6                	mov    %eax,%esi
	close(fd);
  801db5:	89 1c 24             	mov    %ebx,(%esp)
  801db8:	e8 91 ff ff ff       	call   801d4e <close>
  801dbd:	89 f3                	mov    %esi,%ebx
	return r;
}
  801dbf:	89 d8                	mov    %ebx,%eax
  801dc1:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  801dc4:	8b 75 fc             	mov    -0x4(%ebp),%esi
  801dc7:	89 ec                	mov    %ebp,%esp
  801dc9:	5d                   	pop    %ebp
  801dca:	c3                   	ret    

00801dcb <close_all>:
		return fd_close(fd, 1);
}

void
close_all(void)
{
  801dcb:	55                   	push   %ebp
  801dcc:	89 e5                	mov    %esp,%ebp
  801dce:	53                   	push   %ebx
  801dcf:	83 ec 14             	sub    $0x14,%esp
  801dd2:	bb 00 00 00 00       	mov    $0x0,%ebx
	int i;
	for (i = 0; i < MAXFD; i++)
		close(i);
  801dd7:	89 1c 24             	mov    %ebx,(%esp)
  801dda:	e8 6f ff ff ff       	call   801d4e <close>

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  801ddf:	83 c3 01             	add    $0x1,%ebx
  801de2:	83 fb 20             	cmp    $0x20,%ebx
  801de5:	75 f0                	jne    801dd7 <close_all+0xc>
		close(i);
}
  801de7:	83 c4 14             	add    $0x14,%esp
  801dea:	5b                   	pop    %ebx
  801deb:	5d                   	pop    %ebp
  801dec:	c3                   	ret    

00801ded <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  801ded:	55                   	push   %ebp
  801dee:	89 e5                	mov    %esp,%ebp
  801df0:	83 ec 58             	sub    $0x58,%esp
  801df3:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  801df6:	89 75 f8             	mov    %esi,-0x8(%ebp)
  801df9:	89 7d fc             	mov    %edi,-0x4(%ebp)
  801dfc:	8b 7d 0c             	mov    0xc(%ebp),%edi
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  801dff:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  801e02:	89 44 24 04          	mov    %eax,0x4(%esp)
  801e06:	8b 45 08             	mov    0x8(%ebp),%eax
  801e09:	89 04 24             	mov    %eax,(%esp)
  801e0c:	e8 7c fb ff ff       	call   80198d <fd_lookup>
  801e11:	89 c3                	mov    %eax,%ebx
  801e13:	85 c0                	test   %eax,%eax
  801e15:	0f 88 e0 00 00 00    	js     801efb <dup+0x10e>
		return r;
	close(newfdnum);
  801e1b:	89 3c 24             	mov    %edi,(%esp)
  801e1e:	e8 2b ff ff ff       	call   801d4e <close>

	newfd = INDEX2FD(newfdnum);
  801e23:	8d b7 00 00 0d 00    	lea    0xd0000(%edi),%esi
  801e29:	c1 e6 0c             	shl    $0xc,%esi
	ova = fd2data(oldfd);
  801e2c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801e2f:	89 04 24             	mov    %eax,(%esp)
  801e32:	e8 c9 fa ff ff       	call   801900 <fd2data>
  801e37:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  801e39:	89 34 24             	mov    %esi,(%esp)
  801e3c:	e8 bf fa ff ff       	call   801900 <fd2data>
  801e41:	89 45 d4             	mov    %eax,-0x2c(%ebp)

	if ((vpd[PDX(ova)] & PTE_P) && (vpt[VPN(ova)] & PTE_P))
  801e44:	89 da                	mov    %ebx,%edx
  801e46:	89 d8                	mov    %ebx,%eax
  801e48:	c1 e8 16             	shr    $0x16,%eax
  801e4b:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801e52:	a8 01                	test   $0x1,%al
  801e54:	74 43                	je     801e99 <dup+0xac>
  801e56:	c1 ea 0c             	shr    $0xc,%edx
  801e59:	8b 04 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%eax
  801e60:	a8 01                	test   $0x1,%al
  801e62:	74 35                	je     801e99 <dup+0xac>
		if ((r = sys_page_map(0, ova, 0, nva, vpt[VPN(ova)] & PTE_USER)) < 0)
  801e64:	8b 04 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%eax
  801e6b:	25 07 0e 00 00       	and    $0xe07,%eax
  801e70:	89 44 24 10          	mov    %eax,0x10(%esp)
  801e74:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801e77:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801e7b:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801e82:	00 
  801e83:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801e87:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801e8e:	e8 4a f4 ff ff       	call   8012dd <sys_page_map>
  801e93:	89 c3                	mov    %eax,%ebx
  801e95:	85 c0                	test   %eax,%eax
  801e97:	78 3f                	js     801ed8 <dup+0xeb>
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, vpt[VPN(oldfd)] & PTE_USER)) < 0)
  801e99:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801e9c:	89 c2                	mov    %eax,%edx
  801e9e:	c1 ea 0c             	shr    $0xc,%edx
  801ea1:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801ea8:	81 e2 07 0e 00 00    	and    $0xe07,%edx
  801eae:	89 54 24 10          	mov    %edx,0x10(%esp)
  801eb2:	89 74 24 0c          	mov    %esi,0xc(%esp)
  801eb6:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801ebd:	00 
  801ebe:	89 44 24 04          	mov    %eax,0x4(%esp)
  801ec2:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801ec9:	e8 0f f4 ff ff       	call   8012dd <sys_page_map>
  801ece:	89 c3                	mov    %eax,%ebx
  801ed0:	85 c0                	test   %eax,%eax
  801ed2:	78 04                	js     801ed8 <dup+0xeb>
  801ed4:	89 fb                	mov    %edi,%ebx
  801ed6:	eb 23                	jmp    801efb <dup+0x10e>
		goto err;

	return newfdnum;

err:
	sys_page_unmap(0, newfd);
  801ed8:	89 74 24 04          	mov    %esi,0x4(%esp)
  801edc:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801ee3:	e8 97 f3 ff ff       	call   80127f <sys_page_unmap>
	sys_page_unmap(0, nva);
  801ee8:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801eeb:	89 44 24 04          	mov    %eax,0x4(%esp)
  801eef:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801ef6:	e8 84 f3 ff ff       	call   80127f <sys_page_unmap>
	return r;
}
  801efb:	89 d8                	mov    %ebx,%eax
  801efd:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  801f00:	8b 75 f8             	mov    -0x8(%ebp),%esi
  801f03:	8b 7d fc             	mov    -0x4(%ebp),%edi
  801f06:	89 ec                	mov    %ebp,%esp
  801f08:	5d                   	pop    %ebp
  801f09:	c3                   	ret    
	...

00801f0c <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  801f0c:	55                   	push   %ebp
  801f0d:	89 e5                	mov    %esp,%ebp
  801f0f:	53                   	push   %ebx
  801f10:	83 ec 14             	sub    $0x14,%esp
  801f13:	89 d3                	mov    %edx,%ebx
	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", env->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(envs[1].env_id, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  801f15:	8b 15 c8 00 c0 ee    	mov    0xeec000c8,%edx
  801f1b:	c7 44 24 0c 07 00 00 	movl   $0x7,0xc(%esp)
  801f22:	00 
  801f23:	c7 44 24 08 00 40 80 	movl   $0x804000,0x8(%esp)
  801f2a:	00 
  801f2b:	89 44 24 04          	mov    %eax,0x4(%esp)
  801f2f:	89 14 24             	mov    %edx,(%esp)
  801f32:	e8 e9 f8 ff ff       	call   801820 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  801f37:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801f3e:	00 
  801f3f:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801f43:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801f4a:	e8 37 f9 ff ff       	call   801886 <ipc_recv>
}
  801f4f:	83 c4 14             	add    $0x14,%esp
  801f52:	5b                   	pop    %ebx
  801f53:	5d                   	pop    %ebp
  801f54:	c3                   	ret    

00801f55 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  801f55:	55                   	push   %ebp
  801f56:	89 e5                	mov    %esp,%ebp
  801f58:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  801f5b:	8b 45 08             	mov    0x8(%ebp),%eax
  801f5e:	8b 40 0c             	mov    0xc(%eax),%eax
  801f61:	a3 00 40 80 00       	mov    %eax,0x804000
	fsipcbuf.set_size.req_size = newsize;
  801f66:	8b 45 0c             	mov    0xc(%ebp),%eax
  801f69:	a3 04 40 80 00       	mov    %eax,0x804004
	return fsipc(FSREQ_SET_SIZE, NULL);
  801f6e:	ba 00 00 00 00       	mov    $0x0,%edx
  801f73:	b8 02 00 00 00       	mov    $0x2,%eax
  801f78:	e8 8f ff ff ff       	call   801f0c <fsipc>
}
  801f7d:	c9                   	leave  
  801f7e:	c3                   	ret    

00801f7f <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  801f7f:	55                   	push   %ebp
  801f80:	89 e5                	mov    %esp,%ebp
  801f82:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  801f85:	8b 45 08             	mov    0x8(%ebp),%eax
  801f88:	8b 40 0c             	mov    0xc(%eax),%eax
  801f8b:	a3 00 40 80 00       	mov    %eax,0x804000
	return fsipc(FSREQ_FLUSH, NULL);
  801f90:	ba 00 00 00 00       	mov    $0x0,%edx
  801f95:	b8 06 00 00 00       	mov    $0x6,%eax
  801f9a:	e8 6d ff ff ff       	call   801f0c <fsipc>
}
  801f9f:	c9                   	leave  
  801fa0:	c3                   	ret    

00801fa1 <sync>:
}

// Synchronize disk with buffer cache
int
sync(void)
{
  801fa1:	55                   	push   %ebp
  801fa2:	89 e5                	mov    %esp,%ebp
  801fa4:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  801fa7:	ba 00 00 00 00       	mov    $0x0,%edx
  801fac:	b8 08 00 00 00       	mov    $0x8,%eax
  801fb1:	e8 56 ff ff ff       	call   801f0c <fsipc>
}
  801fb6:	c9                   	leave  
  801fb7:	c3                   	ret    

00801fb8 <devfile_stat>:
	return fsipc(FSREQ_WRITE, NULL);	
}

static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  801fb8:	55                   	push   %ebp
  801fb9:	89 e5                	mov    %esp,%ebp
  801fbb:	53                   	push   %ebx
  801fbc:	83 ec 14             	sub    $0x14,%esp
  801fbf:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  801fc2:	8b 45 08             	mov    0x8(%ebp),%eax
  801fc5:	8b 40 0c             	mov    0xc(%eax),%eax
  801fc8:	a3 00 40 80 00       	mov    %eax,0x804000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  801fcd:	ba 00 00 00 00       	mov    $0x0,%edx
  801fd2:	b8 05 00 00 00       	mov    $0x5,%eax
  801fd7:	e8 30 ff ff ff       	call   801f0c <fsipc>
  801fdc:	85 c0                	test   %eax,%eax
  801fde:	78 2b                	js     80200b <devfile_stat+0x53>
		return r;
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  801fe0:	c7 44 24 04 00 40 80 	movl   $0x804000,0x4(%esp)
  801fe7:	00 
  801fe8:	89 1c 24             	mov    %ebx,(%esp)
  801feb:	e8 5a eb ff ff       	call   800b4a <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  801ff0:	a1 80 40 80 00       	mov    0x804080,%eax
  801ff5:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  801ffb:	a1 84 40 80 00       	mov    0x804084,%eax
  802000:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
  802006:	b8 00 00 00 00       	mov    $0x0,%eax
	return 0;
}
  80200b:	83 c4 14             	add    $0x14,%esp
  80200e:	5b                   	pop    %ebx
  80200f:	5d                   	pop    %ebp
  802010:	c3                   	ret    

00802011 <devfile_write>:
// Returns:
//	 The number of bytes successfully written.
//	 < 0 on error.
static ssize_t
devfile_write(struct Fd *fd, const void *buf, size_t n)
{
  802011:	55                   	push   %ebp
  802012:	89 e5                	mov    %esp,%ebp
  802014:	83 ec 18             	sub    $0x18,%esp
  802017:	8b 45 10             	mov    0x10(%ebp),%eax
  80201a:	3d f8 0f 00 00       	cmp    $0xff8,%eax
  80201f:	76 05                	jbe    802026 <devfile_write+0x15>
  802021:	b8 f8 0f 00 00       	mov    $0xff8,%eax
	// LAB 5: Your code here
	//panic("devfile_write not implemented");
	
	if (n > (PGSIZE - (sizeof(int) + sizeof(size_t))))
		n = PGSIZE - (sizeof(int) + sizeof(size_t));
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  802026:	8b 55 08             	mov    0x8(%ebp),%edx
  802029:	8b 52 0c             	mov    0xc(%edx),%edx
  80202c:	89 15 00 40 80 00    	mov    %edx,0x804000
	fsipcbuf.write.req_n = n;
  802032:	a3 04 40 80 00       	mov    %eax,0x804004
	memmove (fsipcbuf.write.req_buf, (char*)buf, n);	
  802037:	89 44 24 08          	mov    %eax,0x8(%esp)
  80203b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80203e:	89 44 24 04          	mov    %eax,0x4(%esp)
  802042:	c7 04 24 08 40 80 00 	movl   $0x804008,(%esp)
  802049:	e8 b7 ec ff ff       	call   800d05 <memmove>
	return fsipc(FSREQ_WRITE, NULL);	
  80204e:	ba 00 00 00 00       	mov    $0x0,%edx
  802053:	b8 04 00 00 00       	mov    $0x4,%eax
  802058:	e8 af fe ff ff       	call   801f0c <fsipc>
}
  80205d:	c9                   	leave  
  80205e:	c3                   	ret    

0080205f <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  80205f:	55                   	push   %ebp
  802060:	89 e5                	mov    %esp,%ebp
  802062:	53                   	push   %ebx
  802063:	83 ec 14             	sub    $0x14,%esp
	// system server.
	// LAB 5: Your code here
	
	//panic("devfile_read not implemented");
	int r;
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  802066:	8b 45 08             	mov    0x8(%ebp),%eax
  802069:	8b 40 0c             	mov    0xc(%eax),%eax
  80206c:	a3 00 40 80 00       	mov    %eax,0x804000
	fsipcbuf.read.req_n = n;
  802071:	8b 45 10             	mov    0x10(%ebp),%eax
  802074:	a3 04 40 80 00       	mov    %eax,0x804004
	if ((r = fsipc(FSREQ_READ, (void*)&fsipcbuf)) < 0)
  802079:	ba 00 40 80 00       	mov    $0x804000,%edx
  80207e:	b8 03 00 00 00       	mov    $0x3,%eax
  802083:	e8 84 fe ff ff       	call   801f0c <fsipc>
  802088:	89 c3                	mov    %eax,%ebx
  80208a:	85 c0                	test   %eax,%eax
  80208c:	78 17                	js     8020a5 <devfile_read+0x46>
		return r;
	memmove((void*)buf, (void*)fsipcbuf.readRet.ret_buf, r);
  80208e:	89 44 24 08          	mov    %eax,0x8(%esp)
  802092:	c7 44 24 04 00 40 80 	movl   $0x804000,0x4(%esp)
  802099:	00 
  80209a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80209d:	89 04 24             	mov    %eax,(%esp)
  8020a0:	e8 60 ec ff ff       	call   800d05 <memmove>
	return r;
}
  8020a5:	89 d8                	mov    %ebx,%eax
  8020a7:	83 c4 14             	add    $0x14,%esp
  8020aa:	5b                   	pop    %ebx
  8020ab:	5d                   	pop    %ebp
  8020ac:	c3                   	ret    

008020ad <remove>:
}

// Delete a file
int
remove(const char *path)
{
  8020ad:	55                   	push   %ebp
  8020ae:	89 e5                	mov    %esp,%ebp
  8020b0:	53                   	push   %ebx
  8020b1:	83 ec 14             	sub    $0x14,%esp
  8020b4:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (strlen(path) >= MAXPATHLEN)
  8020b7:	89 1c 24             	mov    %ebx,(%esp)
  8020ba:	e8 41 ea ff ff       	call   800b00 <strlen>
  8020bf:	89 c2                	mov    %eax,%edx
  8020c1:	b8 f4 ff ff ff       	mov    $0xfffffff4,%eax
  8020c6:	81 fa ff 03 00 00    	cmp    $0x3ff,%edx
  8020cc:	7f 1f                	jg     8020ed <remove+0x40>
		return -E_BAD_PATH;
	strcpy(fsipcbuf.remove.req_path, path);
  8020ce:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8020d2:	c7 04 24 00 40 80 00 	movl   $0x804000,(%esp)
  8020d9:	e8 6c ea ff ff       	call   800b4a <strcpy>
	return fsipc(FSREQ_REMOVE, NULL);
  8020de:	ba 00 00 00 00       	mov    $0x0,%edx
  8020e3:	b8 07 00 00 00       	mov    $0x7,%eax
  8020e8:	e8 1f fe ff ff       	call   801f0c <fsipc>
}
  8020ed:	83 c4 14             	add    $0x14,%esp
  8020f0:	5b                   	pop    %ebx
  8020f1:	5d                   	pop    %ebp
  8020f2:	c3                   	ret    

008020f3 <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  8020f3:	55                   	push   %ebp
  8020f4:	89 e5                	mov    %esp,%ebp
  8020f6:	83 ec 28             	sub    $0x28,%esp
  8020f9:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  8020fc:	89 75 fc             	mov    %esi,-0x4(%ebp)
  8020ff:	8b 75 08             	mov    0x8(%ebp),%esi
	// file descriptor.

	// LAB 5: Your code here.
	// Code added by Swastika / Sandeep
	
	if (strlen(path) >= MAXPATHLEN)
  802102:	89 34 24             	mov    %esi,(%esp)
  802105:	e8 f6 e9 ff ff       	call   800b00 <strlen>
  80210a:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  80210f:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  802114:	7f 5e                	jg     802174 <open+0x81>
		return -E_BAD_PATH;
	struct Fd * fd;
	int  r;
	if ((r = fd_alloc(&fd)) < 0)
  802116:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802119:	89 04 24             	mov    %eax,(%esp)
  80211c:	e8 fa f7 ff ff       	call   80191b <fd_alloc>
  802121:	89 c3                	mov    %eax,%ebx
  802123:	85 c0                	test   %eax,%eax
  802125:	78 4d                	js     802174 <open+0x81>
		return r;
	strcpy (fsipcbuf.open.req_path, path);
  802127:	89 74 24 04          	mov    %esi,0x4(%esp)
  80212b:	c7 04 24 00 40 80 00 	movl   $0x804000,(%esp)
  802132:	e8 13 ea ff ff       	call   800b4a <strcpy>
	fsipcbuf.open.req_omode = mode;	
  802137:	8b 45 0c             	mov    0xc(%ebp),%eax
  80213a:	a3 00 44 80 00       	mov    %eax,0x804400
	if ((r = fsipc(FSREQ_OPEN,(void*)fd)) < 0)
  80213f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802142:	b8 01 00 00 00       	mov    $0x1,%eax
  802147:	e8 c0 fd ff ff       	call   801f0c <fsipc>
  80214c:	89 c3                	mov    %eax,%ebx
  80214e:	85 c0                	test   %eax,%eax
  802150:	79 15                	jns    802167 <open+0x74>
	{
		fd_close(fd,0);
  802152:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  802159:	00 
  80215a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80215d:	89 04 24             	mov    %eax,(%esp)
  802160:	e8 6a fb ff ff       	call   801ccf <fd_close>
		return r; 
  802165:	eb 0d                	jmp    802174 <open+0x81>
	}
	return fd2num(fd);
  802167:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80216a:	89 04 24             	mov    %eax,(%esp)
  80216d:	e8 7e f7 ff ff       	call   8018f0 <fd2num>
  802172:	89 c3                	mov    %eax,%ebx
	//panic("open not implemented");
}
  802174:	89 d8                	mov    %ebx,%eax
  802176:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  802179:	8b 75 fc             	mov    -0x4(%ebp),%esi
  80217c:	89 ec                	mov    %ebp,%esp
  80217e:	5d                   	pop    %ebp
  80217f:	c3                   	ret    

00802180 <devsock_stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  802180:	55                   	push   %ebp
  802181:	89 e5                	mov    %esp,%ebp
  802183:	83 ec 18             	sub    $0x18,%esp
	strcpy(stat->st_name, "<sock>");
  802186:	c7 44 24 04 f8 36 80 	movl   $0x8036f8,0x4(%esp)
  80218d:	00 
  80218e:	8b 45 0c             	mov    0xc(%ebp),%eax
  802191:	89 04 24             	mov    %eax,(%esp)
  802194:	e8 b1 e9 ff ff       	call   800b4a <strcpy>
	return 0;
}
  802199:	b8 00 00 00 00       	mov    $0x0,%eax
  80219e:	c9                   	leave  
  80219f:	c3                   	ret    

008021a0 <devsock_close>:
	return nsipc_shutdown(r, how);
}

static int
devsock_close(struct Fd *fd)
{
  8021a0:	55                   	push   %ebp
  8021a1:	89 e5                	mov    %esp,%ebp
  8021a3:	83 ec 18             	sub    $0x18,%esp
	return nsipc_close(fd->fd_sock.sockid);
  8021a6:	8b 45 08             	mov    0x8(%ebp),%eax
  8021a9:	8b 40 0c             	mov    0xc(%eax),%eax
  8021ac:	89 04 24             	mov    %eax,(%esp)
  8021af:	e8 9e 02 00 00       	call   802452 <nsipc_close>
}
  8021b4:	c9                   	leave  
  8021b5:	c3                   	ret    

008021b6 <devsock_write>:
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
}

static ssize_t
devsock_write(struct Fd *fd, const void *buf, size_t n)
{
  8021b6:	55                   	push   %ebp
  8021b7:	89 e5                	mov    %esp,%ebp
  8021b9:	83 ec 18             	sub    $0x18,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  8021bc:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  8021c3:	00 
  8021c4:	8b 45 10             	mov    0x10(%ebp),%eax
  8021c7:	89 44 24 08          	mov    %eax,0x8(%esp)
  8021cb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8021ce:	89 44 24 04          	mov    %eax,0x4(%esp)
  8021d2:	8b 45 08             	mov    0x8(%ebp),%eax
  8021d5:	8b 40 0c             	mov    0xc(%eax),%eax
  8021d8:	89 04 24             	mov    %eax,(%esp)
  8021db:	e8 ae 02 00 00       	call   80248e <nsipc_send>
}
  8021e0:	c9                   	leave  
  8021e1:	c3                   	ret    

008021e2 <devsock_read>:
	return nsipc_listen(r, backlog);
}

static ssize_t
devsock_read(struct Fd *fd, void *buf, size_t n)
{
  8021e2:	55                   	push   %ebp
  8021e3:	89 e5                	mov    %esp,%ebp
  8021e5:	83 ec 18             	sub    $0x18,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  8021e8:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  8021ef:	00 
  8021f0:	8b 45 10             	mov    0x10(%ebp),%eax
  8021f3:	89 44 24 08          	mov    %eax,0x8(%esp)
  8021f7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8021fa:	89 44 24 04          	mov    %eax,0x4(%esp)
  8021fe:	8b 45 08             	mov    0x8(%ebp),%eax
  802201:	8b 40 0c             	mov    0xc(%eax),%eax
  802204:	89 04 24             	mov    %eax,(%esp)
  802207:	e8 f5 02 00 00       	call   802501 <nsipc_recv>
}
  80220c:	c9                   	leave  
  80220d:	c3                   	ret    

0080220e <alloc_sockfd>:
	return sfd->fd_sock.sockid;
}

static int
alloc_sockfd(int sockid)
{
  80220e:	55                   	push   %ebp
  80220f:	89 e5                	mov    %esp,%ebp
  802211:	56                   	push   %esi
  802212:	53                   	push   %ebx
  802213:	83 ec 20             	sub    $0x20,%esp
  802216:	89 c6                	mov    %eax,%esi
	struct Fd *sfd;
	int r;

	if ((r = fd_alloc(&sfd)) < 0
  802218:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80221b:	89 04 24             	mov    %eax,(%esp)
  80221e:	e8 f8 f6 ff ff       	call   80191b <fd_alloc>
  802223:	89 c3                	mov    %eax,%ebx
  802225:	85 c0                	test   %eax,%eax
  802227:	78 21                	js     80224a <alloc_sockfd+0x3c>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U)) < 0) {
  802229:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  802230:	00 
  802231:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802234:	89 44 24 04          	mov    %eax,0x4(%esp)
  802238:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80223f:	e8 f7 f0 ff ff       	call   80133b <sys_page_alloc>
  802244:	89 c3                	mov    %eax,%ebx
alloc_sockfd(int sockid)
{
	struct Fd *sfd;
	int r;

	if ((r = fd_alloc(&sfd)) < 0
  802246:	85 c0                	test   %eax,%eax
  802248:	79 0a                	jns    802254 <alloc_sockfd+0x46>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U)) < 0) {
		nsipc_close(sockid);
  80224a:	89 34 24             	mov    %esi,(%esp)
  80224d:	e8 00 02 00 00       	call   802452 <nsipc_close>
		return r;
  802252:	eb 28                	jmp    80227c <alloc_sockfd+0x6e>
	}

	sfd->fd_dev_id = devsock.dev_id;
  802254:	8b 15 20 70 80 00    	mov    0x807020,%edx
  80225a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80225d:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  80225f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802262:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	sfd->fd_sock.sockid = sockid;
  802269:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80226c:	89 70 0c             	mov    %esi,0xc(%eax)
	return fd2num(sfd);
  80226f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802272:	89 04 24             	mov    %eax,(%esp)
  802275:	e8 76 f6 ff ff       	call   8018f0 <fd2num>
  80227a:	89 c3                	mov    %eax,%ebx
}
  80227c:	89 d8                	mov    %ebx,%eax
  80227e:	83 c4 20             	add    $0x20,%esp
  802281:	5b                   	pop    %ebx
  802282:	5e                   	pop    %esi
  802283:	5d                   	pop    %ebp
  802284:	c3                   	ret    

00802285 <socket>:
	return 0;
}

int
socket(int domain, int type, int protocol)
{
  802285:	55                   	push   %ebp
  802286:	89 e5                	mov    %esp,%ebp
  802288:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  80228b:	8b 45 10             	mov    0x10(%ebp),%eax
  80228e:	89 44 24 08          	mov    %eax,0x8(%esp)
  802292:	8b 45 0c             	mov    0xc(%ebp),%eax
  802295:	89 44 24 04          	mov    %eax,0x4(%esp)
  802299:	8b 45 08             	mov    0x8(%ebp),%eax
  80229c:	89 04 24             	mov    %eax,(%esp)
  80229f:	e8 62 01 00 00       	call   802406 <nsipc_socket>
  8022a4:	85 c0                	test   %eax,%eax
  8022a6:	78 05                	js     8022ad <socket+0x28>
		return r;
	return alloc_sockfd(r);
  8022a8:	e8 61 ff ff ff       	call   80220e <alloc_sockfd>
}
  8022ad:	c9                   	leave  
  8022ae:	66 90                	xchg   %ax,%ax
  8022b0:	c3                   	ret    

008022b1 <fd2sockid>:
	.dev_stat =	devsock_stat,
};

static int
fd2sockid(int fd)
{
  8022b1:	55                   	push   %ebp
  8022b2:	89 e5                	mov    %esp,%ebp
  8022b4:	83 ec 28             	sub    $0x28,%esp
	struct Fd *sfd;
	int r;

	if ((r = fd_lookup(fd, &sfd)) < 0)
  8022b7:	8d 55 f4             	lea    -0xc(%ebp),%edx
  8022ba:	89 54 24 04          	mov    %edx,0x4(%esp)
  8022be:	89 04 24             	mov    %eax,(%esp)
  8022c1:	e8 c7 f6 ff ff       	call   80198d <fd_lookup>
  8022c6:	85 c0                	test   %eax,%eax
  8022c8:	78 15                	js     8022df <fd2sockid+0x2e>
		return r;
	if (sfd->fd_dev_id != devsock.dev_id)
  8022ca:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8022cd:	8b 0a                	mov    (%edx),%ecx
  8022cf:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8022d4:	3b 0d 20 70 80 00    	cmp    0x807020,%ecx
  8022da:	75 03                	jne    8022df <fd2sockid+0x2e>
		return -E_NOT_SUPP;
	return sfd->fd_sock.sockid;
  8022dc:	8b 42 0c             	mov    0xc(%edx),%eax
}
  8022df:	c9                   	leave  
  8022e0:	c3                   	ret    

008022e1 <listen>:
	return nsipc_connect(r, name, namelen);
}

int
listen(int s, int backlog)
{
  8022e1:	55                   	push   %ebp
  8022e2:	89 e5                	mov    %esp,%ebp
  8022e4:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  8022e7:	8b 45 08             	mov    0x8(%ebp),%eax
  8022ea:	e8 c2 ff ff ff       	call   8022b1 <fd2sockid>
  8022ef:	85 c0                	test   %eax,%eax
  8022f1:	78 0f                	js     802302 <listen+0x21>
		return r;
	return nsipc_listen(r, backlog);
  8022f3:	8b 55 0c             	mov    0xc(%ebp),%edx
  8022f6:	89 54 24 04          	mov    %edx,0x4(%esp)
  8022fa:	89 04 24             	mov    %eax,(%esp)
  8022fd:	e8 2e 01 00 00       	call   802430 <nsipc_listen>
}
  802302:	c9                   	leave  
  802303:	c3                   	ret    

00802304 <connect>:
	return nsipc_close(fd->fd_sock.sockid);
}

int
connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  802304:	55                   	push   %ebp
  802305:	89 e5                	mov    %esp,%ebp
  802307:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  80230a:	8b 45 08             	mov    0x8(%ebp),%eax
  80230d:	e8 9f ff ff ff       	call   8022b1 <fd2sockid>
  802312:	85 c0                	test   %eax,%eax
  802314:	78 16                	js     80232c <connect+0x28>
		return r;
	return nsipc_connect(r, name, namelen);
  802316:	8b 55 10             	mov    0x10(%ebp),%edx
  802319:	89 54 24 08          	mov    %edx,0x8(%esp)
  80231d:	8b 55 0c             	mov    0xc(%ebp),%edx
  802320:	89 54 24 04          	mov    %edx,0x4(%esp)
  802324:	89 04 24             	mov    %eax,(%esp)
  802327:	e8 55 02 00 00       	call   802581 <nsipc_connect>
}
  80232c:	c9                   	leave  
  80232d:	c3                   	ret    

0080232e <shutdown>:
	return nsipc_bind(r, name, namelen);
}

int
shutdown(int s, int how)
{
  80232e:	55                   	push   %ebp
  80232f:	89 e5                	mov    %esp,%ebp
  802331:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  802334:	8b 45 08             	mov    0x8(%ebp),%eax
  802337:	e8 75 ff ff ff       	call   8022b1 <fd2sockid>
  80233c:	85 c0                	test   %eax,%eax
  80233e:	78 0f                	js     80234f <shutdown+0x21>
		return r;
	return nsipc_shutdown(r, how);
  802340:	8b 55 0c             	mov    0xc(%ebp),%edx
  802343:	89 54 24 04          	mov    %edx,0x4(%esp)
  802347:	89 04 24             	mov    %eax,(%esp)
  80234a:	e8 1d 01 00 00       	call   80246c <nsipc_shutdown>
}
  80234f:	c9                   	leave  
  802350:	c3                   	ret    

00802351 <bind>:
	return alloc_sockfd(r);
}

int
bind(int s, struct sockaddr *name, socklen_t namelen)
{
  802351:	55                   	push   %ebp
  802352:	89 e5                	mov    %esp,%ebp
  802354:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  802357:	8b 45 08             	mov    0x8(%ebp),%eax
  80235a:	e8 52 ff ff ff       	call   8022b1 <fd2sockid>
  80235f:	85 c0                	test   %eax,%eax
  802361:	78 16                	js     802379 <bind+0x28>
		return r;
	return nsipc_bind(r, name, namelen);
  802363:	8b 55 10             	mov    0x10(%ebp),%edx
  802366:	89 54 24 08          	mov    %edx,0x8(%esp)
  80236a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80236d:	89 54 24 04          	mov    %edx,0x4(%esp)
  802371:	89 04 24             	mov    %eax,(%esp)
  802374:	e8 47 02 00 00       	call   8025c0 <nsipc_bind>
}
  802379:	c9                   	leave  
  80237a:	c3                   	ret    

0080237b <accept>:
	return fd2num(sfd);
}

int
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  80237b:	55                   	push   %ebp
  80237c:	89 e5                	mov    %esp,%ebp
  80237e:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  802381:	8b 45 08             	mov    0x8(%ebp),%eax
  802384:	e8 28 ff ff ff       	call   8022b1 <fd2sockid>
  802389:	85 c0                	test   %eax,%eax
  80238b:	78 1f                	js     8023ac <accept+0x31>
		return r;
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  80238d:	8b 55 10             	mov    0x10(%ebp),%edx
  802390:	89 54 24 08          	mov    %edx,0x8(%esp)
  802394:	8b 55 0c             	mov    0xc(%ebp),%edx
  802397:	89 54 24 04          	mov    %edx,0x4(%esp)
  80239b:	89 04 24             	mov    %eax,(%esp)
  80239e:	e8 5c 02 00 00       	call   8025ff <nsipc_accept>
  8023a3:	85 c0                	test   %eax,%eax
  8023a5:	78 05                	js     8023ac <accept+0x31>
		return r;
	return alloc_sockfd(r);
  8023a7:	e8 62 fe ff ff       	call   80220e <alloc_sockfd>
}
  8023ac:	c9                   	leave  
  8023ad:	8d 76 00             	lea    0x0(%esi),%esi
  8023b0:	c3                   	ret    
	...

008023c0 <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  8023c0:	55                   	push   %ebp
  8023c1:	89 e5                	mov    %esp,%ebp
  8023c3:	83 ec 18             	sub    $0x18,%esp
	if (debug)
		cprintf("[%08x] nsipc %d\n", env->env_id, type);

	ipc_send(envs[2].env_id, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  8023c6:	8b 15 44 01 c0 ee    	mov    0xeec00144,%edx
  8023cc:	c7 44 24 0c 07 00 00 	movl   $0x7,0xc(%esp)
  8023d3:	00 
  8023d4:	c7 44 24 08 00 60 80 	movl   $0x806000,0x8(%esp)
  8023db:	00 
  8023dc:	89 44 24 04          	mov    %eax,0x4(%esp)
  8023e0:	89 14 24             	mov    %edx,(%esp)
  8023e3:	e8 38 f4 ff ff       	call   801820 <ipc_send>
	return ipc_recv(NULL, NULL, NULL);
  8023e8:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  8023ef:	00 
  8023f0:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  8023f7:	00 
  8023f8:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8023ff:	e8 82 f4 ff ff       	call   801886 <ipc_recv>
}
  802404:	c9                   	leave  
  802405:	c3                   	ret    

00802406 <nsipc_socket>:
	return nsipc(NSREQ_SEND);
}

int
nsipc_socket(int domain, int type, int protocol)
{
  802406:	55                   	push   %ebp
  802407:	89 e5                	mov    %esp,%ebp
  802409:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  80240c:	8b 45 08             	mov    0x8(%ebp),%eax
  80240f:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.socket.req_type = type;
  802414:	8b 45 0c             	mov    0xc(%ebp),%eax
  802417:	a3 04 60 80 00       	mov    %eax,0x806004
	nsipcbuf.socket.req_protocol = protocol;
  80241c:	8b 45 10             	mov    0x10(%ebp),%eax
  80241f:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SOCKET);
  802424:	b8 09 00 00 00       	mov    $0x9,%eax
  802429:	e8 92 ff ff ff       	call   8023c0 <nsipc>
}
  80242e:	c9                   	leave  
  80242f:	c3                   	ret    

00802430 <nsipc_listen>:
	return nsipc(NSREQ_CONNECT);
}

int
nsipc_listen(int s, int backlog)
{
  802430:	55                   	push   %ebp
  802431:	89 e5                	mov    %esp,%ebp
  802433:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  802436:	8b 45 08             	mov    0x8(%ebp),%eax
  802439:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.listen.req_backlog = backlog;
  80243e:	8b 45 0c             	mov    0xc(%ebp),%eax
  802441:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_LISTEN);
  802446:	b8 06 00 00 00       	mov    $0x6,%eax
  80244b:	e8 70 ff ff ff       	call   8023c0 <nsipc>
}
  802450:	c9                   	leave  
  802451:	c3                   	ret    

00802452 <nsipc_close>:
	return nsipc(NSREQ_SHUTDOWN);
}

int
nsipc_close(int s)
{
  802452:	55                   	push   %ebp
  802453:	89 e5                	mov    %esp,%ebp
  802455:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  802458:	8b 45 08             	mov    0x8(%ebp),%eax
  80245b:	a3 00 60 80 00       	mov    %eax,0x806000
	return nsipc(NSREQ_CLOSE);
  802460:	b8 04 00 00 00       	mov    $0x4,%eax
  802465:	e8 56 ff ff ff       	call   8023c0 <nsipc>
}
  80246a:	c9                   	leave  
  80246b:	c3                   	ret    

0080246c <nsipc_shutdown>:
	return nsipc(NSREQ_BIND);
}

int
nsipc_shutdown(int s, int how)
{
  80246c:	55                   	push   %ebp
  80246d:	89 e5                	mov    %esp,%ebp
  80246f:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  802472:	8b 45 08             	mov    0x8(%ebp),%eax
  802475:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.shutdown.req_how = how;
  80247a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80247d:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_SHUTDOWN);
  802482:	b8 03 00 00 00       	mov    $0x3,%eax
  802487:	e8 34 ff ff ff       	call   8023c0 <nsipc>
}
  80248c:	c9                   	leave  
  80248d:	c3                   	ret    

0080248e <nsipc_send>:
	return r;
}

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  80248e:	55                   	push   %ebp
  80248f:	89 e5                	mov    %esp,%ebp
  802491:	53                   	push   %ebx
  802492:	83 ec 14             	sub    $0x14,%esp
  802495:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  802498:	8b 45 08             	mov    0x8(%ebp),%eax
  80249b:	a3 00 60 80 00       	mov    %eax,0x806000
	assert(size < 1600);
  8024a0:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  8024a6:	7e 24                	jle    8024cc <nsipc_send+0x3e>
  8024a8:	c7 44 24 0c 04 37 80 	movl   $0x803704,0xc(%esp)
  8024af:	00 
  8024b0:	c7 44 24 08 10 37 80 	movl   $0x803710,0x8(%esp)
  8024b7:	00 
  8024b8:	c7 44 24 04 66 00 00 	movl   $0x66,0x4(%esp)
  8024bf:	00 
  8024c0:	c7 04 24 25 37 80 00 	movl   $0x803725,(%esp)
  8024c7:	e8 f8 de ff ff       	call   8003c4 <_panic>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  8024cc:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8024d0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8024d3:	89 44 24 04          	mov    %eax,0x4(%esp)
  8024d7:	c7 04 24 0c 60 80 00 	movl   $0x80600c,(%esp)
  8024de:	e8 22 e8 ff ff       	call   800d05 <memmove>
	nsipcbuf.send.req_size = size;
  8024e3:	89 1d 04 60 80 00    	mov    %ebx,0x806004
	nsipcbuf.send.req_flags = flags;
  8024e9:	8b 45 14             	mov    0x14(%ebp),%eax
  8024ec:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SEND);
  8024f1:	b8 08 00 00 00       	mov    $0x8,%eax
  8024f6:	e8 c5 fe ff ff       	call   8023c0 <nsipc>
}
  8024fb:	83 c4 14             	add    $0x14,%esp
  8024fe:	5b                   	pop    %ebx
  8024ff:	5d                   	pop    %ebp
  802500:	c3                   	ret    

00802501 <nsipc_recv>:
	return nsipc(NSREQ_LISTEN);
}

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  802501:	55                   	push   %ebp
  802502:	89 e5                	mov    %esp,%ebp
  802504:	56                   	push   %esi
  802505:	53                   	push   %ebx
  802506:	83 ec 10             	sub    $0x10,%esp
  802509:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  80250c:	8b 45 08             	mov    0x8(%ebp),%eax
  80250f:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.recv.req_len = len;
  802514:	89 35 04 60 80 00    	mov    %esi,0x806004
	nsipcbuf.recv.req_flags = flags;
  80251a:	8b 45 14             	mov    0x14(%ebp),%eax
  80251d:	a3 08 60 80 00       	mov    %eax,0x806008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  802522:	b8 07 00 00 00       	mov    $0x7,%eax
  802527:	e8 94 fe ff ff       	call   8023c0 <nsipc>
  80252c:	89 c3                	mov    %eax,%ebx
  80252e:	85 c0                	test   %eax,%eax
  802530:	78 46                	js     802578 <nsipc_recv+0x77>
		assert(r < 1600 && r <= len);
  802532:	3d 3f 06 00 00       	cmp    $0x63f,%eax
  802537:	7f 04                	jg     80253d <nsipc_recv+0x3c>
  802539:	39 c6                	cmp    %eax,%esi
  80253b:	7d 24                	jge    802561 <nsipc_recv+0x60>
  80253d:	c7 44 24 0c 31 37 80 	movl   $0x803731,0xc(%esp)
  802544:	00 
  802545:	c7 44 24 08 10 37 80 	movl   $0x803710,0x8(%esp)
  80254c:	00 
  80254d:	c7 44 24 04 5b 00 00 	movl   $0x5b,0x4(%esp)
  802554:	00 
  802555:	c7 04 24 25 37 80 00 	movl   $0x803725,(%esp)
  80255c:	e8 63 de ff ff       	call   8003c4 <_panic>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  802561:	89 44 24 08          	mov    %eax,0x8(%esp)
  802565:	c7 44 24 04 00 60 80 	movl   $0x806000,0x4(%esp)
  80256c:	00 
  80256d:	8b 45 0c             	mov    0xc(%ebp),%eax
  802570:	89 04 24             	mov    %eax,(%esp)
  802573:	e8 8d e7 ff ff       	call   800d05 <memmove>
	}

	return r;
}
  802578:	89 d8                	mov    %ebx,%eax
  80257a:	83 c4 10             	add    $0x10,%esp
  80257d:	5b                   	pop    %ebx
  80257e:	5e                   	pop    %esi
  80257f:	5d                   	pop    %ebp
  802580:	c3                   	ret    

00802581 <nsipc_connect>:
	return nsipc(NSREQ_CLOSE);
}

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  802581:	55                   	push   %ebp
  802582:	89 e5                	mov    %esp,%ebp
  802584:	53                   	push   %ebx
  802585:	83 ec 14             	sub    $0x14,%esp
  802588:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  80258b:	8b 45 08             	mov    0x8(%ebp),%eax
  80258e:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  802593:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  802597:	8b 45 0c             	mov    0xc(%ebp),%eax
  80259a:	89 44 24 04          	mov    %eax,0x4(%esp)
  80259e:	c7 04 24 04 60 80 00 	movl   $0x806004,(%esp)
  8025a5:	e8 5b e7 ff ff       	call   800d05 <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  8025aa:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_CONNECT);
  8025b0:	b8 05 00 00 00       	mov    $0x5,%eax
  8025b5:	e8 06 fe ff ff       	call   8023c0 <nsipc>
}
  8025ba:	83 c4 14             	add    $0x14,%esp
  8025bd:	5b                   	pop    %ebx
  8025be:	5d                   	pop    %ebp
  8025bf:	c3                   	ret    

008025c0 <nsipc_bind>:
	return r;
}

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  8025c0:	55                   	push   %ebp
  8025c1:	89 e5                	mov    %esp,%ebp
  8025c3:	53                   	push   %ebx
  8025c4:	83 ec 14             	sub    $0x14,%esp
  8025c7:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  8025ca:	8b 45 08             	mov    0x8(%ebp),%eax
  8025cd:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  8025d2:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8025d6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8025d9:	89 44 24 04          	mov    %eax,0x4(%esp)
  8025dd:	c7 04 24 04 60 80 00 	movl   $0x806004,(%esp)
  8025e4:	e8 1c e7 ff ff       	call   800d05 <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  8025e9:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_BIND);
  8025ef:	b8 02 00 00 00       	mov    $0x2,%eax
  8025f4:	e8 c7 fd ff ff       	call   8023c0 <nsipc>
}
  8025f9:	83 c4 14             	add    $0x14,%esp
  8025fc:	5b                   	pop    %ebx
  8025fd:	5d                   	pop    %ebp
  8025fe:	c3                   	ret    

008025ff <nsipc_accept>:
	return ipc_recv(NULL, NULL, NULL);
}

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  8025ff:	55                   	push   %ebp
  802600:	89 e5                	mov    %esp,%ebp
  802602:	83 ec 18             	sub    $0x18,%esp
  802605:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  802608:	89 75 fc             	mov    %esi,-0x4(%ebp)
	int r;
	
	nsipcbuf.accept.req_s = s;
  80260b:	8b 45 08             	mov    0x8(%ebp),%eax
  80260e:	a3 00 60 80 00       	mov    %eax,0x806000
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  802613:	b8 01 00 00 00       	mov    $0x1,%eax
  802618:	e8 a3 fd ff ff       	call   8023c0 <nsipc>
  80261d:	89 c3                	mov    %eax,%ebx
  80261f:	85 c0                	test   %eax,%eax
  802621:	78 25                	js     802648 <nsipc_accept+0x49>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  802623:	be 10 60 80 00       	mov    $0x806010,%esi
  802628:	8b 06                	mov    (%esi),%eax
  80262a:	89 44 24 08          	mov    %eax,0x8(%esp)
  80262e:	c7 44 24 04 00 60 80 	movl   $0x806000,0x4(%esp)
  802635:	00 
  802636:	8b 45 0c             	mov    0xc(%ebp),%eax
  802639:	89 04 24             	mov    %eax,(%esp)
  80263c:	e8 c4 e6 ff ff       	call   800d05 <memmove>
		*addrlen = ret->ret_addrlen;
  802641:	8b 16                	mov    (%esi),%edx
  802643:	8b 45 10             	mov    0x10(%ebp),%eax
  802646:	89 10                	mov    %edx,(%eax)
	}
	return r;
}
  802648:	89 d8                	mov    %ebx,%eax
  80264a:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  80264d:	8b 75 fc             	mov    -0x4(%ebp),%esi
  802650:	89 ec                	mov    %ebp,%esp
  802652:	5d                   	pop    %ebp
  802653:	c3                   	ret    
	...

00802660 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  802660:	55                   	push   %ebp
  802661:	89 e5                	mov    %esp,%ebp
  802663:	83 ec 18             	sub    $0x18,%esp
  802666:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  802669:	89 75 fc             	mov    %esi,-0x4(%ebp)
  80266c:	8b 75 0c             	mov    0xc(%ebp),%esi
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  80266f:	8b 45 08             	mov    0x8(%ebp),%eax
  802672:	89 04 24             	mov    %eax,(%esp)
  802675:	e8 86 f2 ff ff       	call   801900 <fd2data>
  80267a:	89 c3                	mov    %eax,%ebx
	strcpy(stat->st_name, "<pipe>");
  80267c:	c7 44 24 04 46 37 80 	movl   $0x803746,0x4(%esp)
  802683:	00 
  802684:	89 34 24             	mov    %esi,(%esp)
  802687:	e8 be e4 ff ff       	call   800b4a <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  80268c:	8b 43 04             	mov    0x4(%ebx),%eax
  80268f:	2b 03                	sub    (%ebx),%eax
  802691:	89 86 80 00 00 00    	mov    %eax,0x80(%esi)
	stat->st_isdir = 0;
  802697:	c7 86 84 00 00 00 00 	movl   $0x0,0x84(%esi)
  80269e:	00 00 00 
	stat->st_dev = &devpipe;
  8026a1:	c7 86 88 00 00 00 3c 	movl   $0x80703c,0x88(%esi)
  8026a8:	70 80 00 
	return 0;
}
  8026ab:	b8 00 00 00 00       	mov    $0x0,%eax
  8026b0:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  8026b3:	8b 75 fc             	mov    -0x4(%ebp),%esi
  8026b6:	89 ec                	mov    %ebp,%esp
  8026b8:	5d                   	pop    %ebp
  8026b9:	c3                   	ret    

008026ba <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  8026ba:	55                   	push   %ebp
  8026bb:	89 e5                	mov    %esp,%ebp
  8026bd:	53                   	push   %ebx
  8026be:	83 ec 14             	sub    $0x14,%esp
  8026c1:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  8026c4:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8026c8:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8026cf:	e8 ab eb ff ff       	call   80127f <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  8026d4:	89 1c 24             	mov    %ebx,(%esp)
  8026d7:	e8 24 f2 ff ff       	call   801900 <fd2data>
  8026dc:	89 44 24 04          	mov    %eax,0x4(%esp)
  8026e0:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8026e7:	e8 93 eb ff ff       	call   80127f <sys_page_unmap>
}
  8026ec:	83 c4 14             	add    $0x14,%esp
  8026ef:	5b                   	pop    %ebx
  8026f0:	5d                   	pop    %ebp
  8026f1:	c3                   	ret    

008026f2 <_pipeisclosed>:
	return r;
}

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  8026f2:	55                   	push   %ebp
  8026f3:	89 e5                	mov    %esp,%ebp
  8026f5:	57                   	push   %edi
  8026f6:	56                   	push   %esi
  8026f7:	53                   	push   %ebx
  8026f8:	83 ec 2c             	sub    $0x2c,%esp
  8026fb:	89 c7                	mov    %eax,%edi
  8026fd:	89 55 e4             	mov    %edx,-0x1c(%ebp)
	int n, nn, ret;

	while (1) {
		n = env->env_runs;
  802700:	a1 78 70 80 00       	mov    0x807078,%eax
  802705:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  802708:	89 3c 24             	mov    %edi,(%esp)
  80270b:	e8 9c 05 00 00       	call   802cac <pageref>
  802710:	89 c6                	mov    %eax,%esi
  802712:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802715:	89 04 24             	mov    %eax,(%esp)
  802718:	e8 8f 05 00 00       	call   802cac <pageref>
  80271d:	39 c6                	cmp    %eax,%esi
  80271f:	0f 94 c0             	sete   %al
  802722:	0f b6 c0             	movzbl %al,%eax
		nn = env->env_runs;
  802725:	8b 15 78 70 80 00    	mov    0x807078,%edx
  80272b:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  80272e:	39 cb                	cmp    %ecx,%ebx
  802730:	75 08                	jne    80273a <_pipeisclosed+0x48>
			return ret;
		if (n != nn && ret == 1)
			cprintf("pipe race avoided\n", n, env->env_runs, ret);
	}
}
  802732:	83 c4 2c             	add    $0x2c,%esp
  802735:	5b                   	pop    %ebx
  802736:	5e                   	pop    %esi
  802737:	5f                   	pop    %edi
  802738:	5d                   	pop    %ebp
  802739:	c3                   	ret    
		n = env->env_runs;
		ret = pageref(fd) == pageref(p);
		nn = env->env_runs;
		if (n == nn)
			return ret;
		if (n != nn && ret == 1)
  80273a:	83 f8 01             	cmp    $0x1,%eax
  80273d:	75 c1                	jne    802700 <_pipeisclosed+0xe>
			cprintf("pipe race avoided\n", n, env->env_runs, ret);
  80273f:	8b 52 58             	mov    0x58(%edx),%edx
  802742:	89 44 24 0c          	mov    %eax,0xc(%esp)
  802746:	89 54 24 08          	mov    %edx,0x8(%esp)
  80274a:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  80274e:	c7 04 24 4d 37 80 00 	movl   $0x80374d,(%esp)
  802755:	e8 2f dd ff ff       	call   800489 <cprintf>
  80275a:	eb a4                	jmp    802700 <_pipeisclosed+0xe>

0080275c <devpipe_write>:
	return i;
}

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  80275c:	55                   	push   %ebp
  80275d:	89 e5                	mov    %esp,%ebp
  80275f:	57                   	push   %edi
  802760:	56                   	push   %esi
  802761:	53                   	push   %ebx
  802762:	83 ec 1c             	sub    $0x1c,%esp
  802765:	8b 75 08             	mov    0x8(%ebp),%esi
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  802768:	89 34 24             	mov    %esi,(%esp)
  80276b:	e8 90 f1 ff ff       	call   801900 <fd2data>
  802770:	89 c3                	mov    %eax,%ebx
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			env->env_id, vpt[VPN(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  802772:	bf 00 00 00 00       	mov    $0x0,%edi
  802777:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80277b:	75 54                	jne    8027d1 <devpipe_write+0x75>
  80277d:	eb 60                	jmp    8027df <devpipe_write+0x83>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  80277f:	89 da                	mov    %ebx,%edx
  802781:	89 f0                	mov    %esi,%eax
  802783:	e8 6a ff ff ff       	call   8026f2 <_pipeisclosed>
  802788:	85 c0                	test   %eax,%eax
  80278a:	74 07                	je     802793 <devpipe_write+0x37>
  80278c:	b8 00 00 00 00       	mov    $0x0,%eax
  802791:	eb 53                	jmp    8027e6 <devpipe_write+0x8a>
				return 0;
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  802793:	90                   	nop
  802794:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802798:	e8 fd eb ff ff       	call   80139a <sys_yield>
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			env->env_id, vpt[VPN(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  80279d:	8b 43 04             	mov    0x4(%ebx),%eax
  8027a0:	8b 13                	mov    (%ebx),%edx
  8027a2:	83 c2 20             	add    $0x20,%edx
  8027a5:	39 d0                	cmp    %edx,%eax
  8027a7:	73 d6                	jae    80277f <devpipe_write+0x23>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  8027a9:	89 c2                	mov    %eax,%edx
  8027ab:	c1 fa 1f             	sar    $0x1f,%edx
  8027ae:	c1 ea 1b             	shr    $0x1b,%edx
  8027b1:	01 d0                	add    %edx,%eax
  8027b3:	83 e0 1f             	and    $0x1f,%eax
  8027b6:	29 d0                	sub    %edx,%eax
  8027b8:	89 c2                	mov    %eax,%edx
  8027ba:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8027bd:	0f b6 04 39          	movzbl (%ecx,%edi,1),%eax
  8027c1:	88 44 13 08          	mov    %al,0x8(%ebx,%edx,1)
		p->p_wpos++;
  8027c5:	83 43 04 01          	addl   $0x1,0x4(%ebx)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			env->env_id, vpt[VPN(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  8027c9:	83 c7 01             	add    $0x1,%edi
  8027cc:	39 7d 10             	cmp    %edi,0x10(%ebp)
  8027cf:	76 13                	jbe    8027e4 <devpipe_write+0x88>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  8027d1:	8b 43 04             	mov    0x4(%ebx),%eax
  8027d4:	8b 13                	mov    (%ebx),%edx
  8027d6:	83 c2 20             	add    $0x20,%edx
  8027d9:	39 d0                	cmp    %edx,%eax
  8027db:	73 a2                	jae    80277f <devpipe_write+0x23>
  8027dd:	eb ca                	jmp    8027a9 <devpipe_write+0x4d>
  8027df:	bf 00 00 00 00       	mov    $0x0,%edi
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}
	
	return i;
  8027e4:	89 f8                	mov    %edi,%eax
}
  8027e6:	83 c4 1c             	add    $0x1c,%esp
  8027e9:	5b                   	pop    %ebx
  8027ea:	5e                   	pop    %esi
  8027eb:	5f                   	pop    %edi
  8027ec:	5d                   	pop    %ebp
  8027ed:	c3                   	ret    

008027ee <devpipe_read>:
	return _pipeisclosed(fd, p);
}

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  8027ee:	55                   	push   %ebp
  8027ef:	89 e5                	mov    %esp,%ebp
  8027f1:	83 ec 28             	sub    $0x28,%esp
  8027f4:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  8027f7:	89 75 f8             	mov    %esi,-0x8(%ebp)
  8027fa:	89 7d fc             	mov    %edi,-0x4(%ebp)
  8027fd:	8b 7d 08             	mov    0x8(%ebp),%edi
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  802800:	89 3c 24             	mov    %edi,(%esp)
  802803:	e8 f8 f0 ff ff       	call   801900 <fd2data>
  802808:	89 c3                	mov    %eax,%ebx
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			env->env_id, vpt[VPN(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  80280a:	be 00 00 00 00       	mov    $0x0,%esi
  80280f:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  802813:	75 4c                	jne    802861 <devpipe_read+0x73>
  802815:	eb 5b                	jmp    802872 <devpipe_read+0x84>
		while (p->p_rpos == p->p_wpos) {
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
				return i;
  802817:	89 f0                	mov    %esi,%eax
  802819:	eb 5e                	jmp    802879 <devpipe_read+0x8b>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  80281b:	89 da                	mov    %ebx,%edx
  80281d:	89 f8                	mov    %edi,%eax
  80281f:	90                   	nop
  802820:	e8 cd fe ff ff       	call   8026f2 <_pipeisclosed>
  802825:	85 c0                	test   %eax,%eax
  802827:	74 07                	je     802830 <devpipe_read+0x42>
  802829:	b8 00 00 00 00       	mov    $0x0,%eax
  80282e:	eb 49                	jmp    802879 <devpipe_read+0x8b>
				return 0;
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  802830:	e8 65 eb ff ff       	call   80139a <sys_yield>
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			env->env_id, vpt[VPN(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  802835:	8b 03                	mov    (%ebx),%eax
  802837:	3b 43 04             	cmp    0x4(%ebx),%eax
  80283a:	74 df                	je     80281b <devpipe_read+0x2d>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  80283c:	89 c2                	mov    %eax,%edx
  80283e:	c1 fa 1f             	sar    $0x1f,%edx
  802841:	c1 ea 1b             	shr    $0x1b,%edx
  802844:	01 d0                	add    %edx,%eax
  802846:	83 e0 1f             	and    $0x1f,%eax
  802849:	29 d0                	sub    %edx,%eax
  80284b:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  802850:	8b 55 0c             	mov    0xc(%ebp),%edx
  802853:	88 04 32             	mov    %al,(%edx,%esi,1)
		p->p_rpos++;
  802856:	83 03 01             	addl   $0x1,(%ebx)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			env->env_id, vpt[VPN(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  802859:	83 c6 01             	add    $0x1,%esi
  80285c:	39 75 10             	cmp    %esi,0x10(%ebp)
  80285f:	76 16                	jbe    802877 <devpipe_read+0x89>
		while (p->p_rpos == p->p_wpos) {
  802861:	8b 03                	mov    (%ebx),%eax
  802863:	3b 43 04             	cmp    0x4(%ebx),%eax
  802866:	75 d4                	jne    80283c <devpipe_read+0x4e>
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  802868:	85 f6                	test   %esi,%esi
  80286a:	75 ab                	jne    802817 <devpipe_read+0x29>
  80286c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802870:	eb a9                	jmp    80281b <devpipe_read+0x2d>
  802872:	be 00 00 00 00       	mov    $0x0,%esi
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  802877:	89 f0                	mov    %esi,%eax
}
  802879:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  80287c:	8b 75 f8             	mov    -0x8(%ebp),%esi
  80287f:	8b 7d fc             	mov    -0x4(%ebp),%edi
  802882:	89 ec                	mov    %ebp,%esp
  802884:	5d                   	pop    %ebp
  802885:	c3                   	ret    

00802886 <pipeisclosed>:
	}
}

int
pipeisclosed(int fdnum)
{
  802886:	55                   	push   %ebp
  802887:	89 e5                	mov    %esp,%ebp
  802889:	83 ec 28             	sub    $0x28,%esp
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80288c:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80288f:	89 44 24 04          	mov    %eax,0x4(%esp)
  802893:	8b 45 08             	mov    0x8(%ebp),%eax
  802896:	89 04 24             	mov    %eax,(%esp)
  802899:	e8 ef f0 ff ff       	call   80198d <fd_lookup>
  80289e:	85 c0                	test   %eax,%eax
  8028a0:	78 15                	js     8028b7 <pipeisclosed+0x31>
		return r;
	p = (struct Pipe*) fd2data(fd);
  8028a2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028a5:	89 04 24             	mov    %eax,(%esp)
  8028a8:	e8 53 f0 ff ff       	call   801900 <fd2data>
	return _pipeisclosed(fd, p);
  8028ad:	89 c2                	mov    %eax,%edx
  8028af:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028b2:	e8 3b fe ff ff       	call   8026f2 <_pipeisclosed>
}
  8028b7:	c9                   	leave  
  8028b8:	c3                   	ret    

008028b9 <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  8028b9:	55                   	push   %ebp
  8028ba:	89 e5                	mov    %esp,%ebp
  8028bc:	83 ec 48             	sub    $0x48,%esp
  8028bf:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  8028c2:	89 75 f8             	mov    %esi,-0x8(%ebp)
  8028c5:	89 7d fc             	mov    %edi,-0x4(%ebp)
  8028c8:	8b 7d 08             	mov    0x8(%ebp),%edi
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  8028cb:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  8028ce:	89 04 24             	mov    %eax,(%esp)
  8028d1:	e8 45 f0 ff ff       	call   80191b <fd_alloc>
  8028d6:	89 c3                	mov    %eax,%ebx
  8028d8:	85 c0                	test   %eax,%eax
  8028da:	0f 88 42 01 00 00    	js     802a22 <pipe+0x169>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8028e0:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  8028e7:	00 
  8028e8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8028eb:	89 44 24 04          	mov    %eax,0x4(%esp)
  8028ef:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8028f6:	e8 40 ea ff ff       	call   80133b <sys_page_alloc>
  8028fb:	89 c3                	mov    %eax,%ebx
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  8028fd:	85 c0                	test   %eax,%eax
  8028ff:	0f 88 1d 01 00 00    	js     802a22 <pipe+0x169>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  802905:	8d 45 e0             	lea    -0x20(%ebp),%eax
  802908:	89 04 24             	mov    %eax,(%esp)
  80290b:	e8 0b f0 ff ff       	call   80191b <fd_alloc>
  802910:	89 c3                	mov    %eax,%ebx
  802912:	85 c0                	test   %eax,%eax
  802914:	0f 88 f5 00 00 00    	js     802a0f <pipe+0x156>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80291a:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  802921:	00 
  802922:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802925:	89 44 24 04          	mov    %eax,0x4(%esp)
  802929:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802930:	e8 06 ea ff ff       	call   80133b <sys_page_alloc>
  802935:	89 c3                	mov    %eax,%ebx
	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  802937:	85 c0                	test   %eax,%eax
  802939:	0f 88 d0 00 00 00    	js     802a0f <pipe+0x156>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  80293f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802942:	89 04 24             	mov    %eax,(%esp)
  802945:	e8 b6 ef ff ff       	call   801900 <fd2data>
  80294a:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80294c:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  802953:	00 
  802954:	89 44 24 04          	mov    %eax,0x4(%esp)
  802958:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80295f:	e8 d7 e9 ff ff       	call   80133b <sys_page_alloc>
  802964:	89 c3                	mov    %eax,%ebx
  802966:	85 c0                	test   %eax,%eax
  802968:	0f 88 8e 00 00 00    	js     8029fc <pipe+0x143>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80296e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802971:	89 04 24             	mov    %eax,(%esp)
  802974:	e8 87 ef ff ff       	call   801900 <fd2data>
  802979:	c7 44 24 10 07 04 00 	movl   $0x407,0x10(%esp)
  802980:	00 
  802981:	89 44 24 0c          	mov    %eax,0xc(%esp)
  802985:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  80298c:	00 
  80298d:	89 74 24 04          	mov    %esi,0x4(%esp)
  802991:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802998:	e8 40 e9 ff ff       	call   8012dd <sys_page_map>
  80299d:	89 c3                	mov    %eax,%ebx
  80299f:	85 c0                	test   %eax,%eax
  8029a1:	78 49                	js     8029ec <pipe+0x133>
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  8029a3:	b8 3c 70 80 00       	mov    $0x80703c,%eax
  8029a8:	8b 08                	mov    (%eax),%ecx
  8029aa:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8029ad:	89 0a                	mov    %ecx,(%edx)
	fd0->fd_omode = O_RDONLY;
  8029af:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8029b2:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%edx)

	fd1->fd_dev_id = devpipe.dev_id;
  8029b9:	8b 10                	mov    (%eax),%edx
  8029bb:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8029be:	89 10                	mov    %edx,(%eax)
	fd1->fd_omode = O_WRONLY;
  8029c0:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8029c3:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", env->env_id, vpt[VPN(va)]);

	pfd[0] = fd2num(fd0);
  8029ca:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8029cd:	89 04 24             	mov    %eax,(%esp)
  8029d0:	e8 1b ef ff ff       	call   8018f0 <fd2num>
  8029d5:	89 07                	mov    %eax,(%edi)
	pfd[1] = fd2num(fd1);
  8029d7:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8029da:	89 04 24             	mov    %eax,(%esp)
  8029dd:	e8 0e ef ff ff       	call   8018f0 <fd2num>
  8029e2:	89 47 04             	mov    %eax,0x4(%edi)
  8029e5:	bb 00 00 00 00       	mov    $0x0,%ebx
	return 0;
  8029ea:	eb 36                	jmp    802a22 <pipe+0x169>

    err3:
	sys_page_unmap(0, va);
  8029ec:	89 74 24 04          	mov    %esi,0x4(%esp)
  8029f0:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8029f7:	e8 83 e8 ff ff       	call   80127f <sys_page_unmap>
    err2:
	sys_page_unmap(0, fd1);
  8029fc:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8029ff:	89 44 24 04          	mov    %eax,0x4(%esp)
  802a03:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802a0a:	e8 70 e8 ff ff       	call   80127f <sys_page_unmap>
    err1:
	sys_page_unmap(0, fd0);
  802a0f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802a12:	89 44 24 04          	mov    %eax,0x4(%esp)
  802a16:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802a1d:	e8 5d e8 ff ff       	call   80127f <sys_page_unmap>
    err:
	return r;
}
  802a22:	89 d8                	mov    %ebx,%eax
  802a24:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  802a27:	8b 75 f8             	mov    -0x8(%ebp),%esi
  802a2a:	8b 7d fc             	mov    -0x4(%ebp),%edi
  802a2d:	89 ec                	mov    %ebp,%esp
  802a2f:	5d                   	pop    %ebp
  802a30:	c3                   	ret    
	...

00802a40 <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  802a40:	55                   	push   %ebp
  802a41:	89 e5                	mov    %esp,%ebp
	USED(fd);

	return 0;
}
  802a43:	b8 00 00 00 00       	mov    $0x0,%eax
  802a48:	5d                   	pop    %ebp
  802a49:	c3                   	ret    

00802a4a <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  802a4a:	55                   	push   %ebp
  802a4b:	89 e5                	mov    %esp,%ebp
  802a4d:	83 ec 18             	sub    $0x18,%esp
	strcpy(stat->st_name, "<cons>");
  802a50:	c7 44 24 04 65 37 80 	movl   $0x803765,0x4(%esp)
  802a57:	00 
  802a58:	8b 45 0c             	mov    0xc(%ebp),%eax
  802a5b:	89 04 24             	mov    %eax,(%esp)
  802a5e:	e8 e7 e0 ff ff       	call   800b4a <strcpy>
	return 0;
}
  802a63:	b8 00 00 00 00       	mov    $0x0,%eax
  802a68:	c9                   	leave  
  802a69:	c3                   	ret    

00802a6a <devcons_write>:
	return 1;
}

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  802a6a:	55                   	push   %ebp
  802a6b:	89 e5                	mov    %esp,%ebp
  802a6d:	57                   	push   %edi
  802a6e:	56                   	push   %esi
  802a6f:	53                   	push   %ebx
  802a70:	81 ec 9c 00 00 00    	sub    $0x9c,%esp
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs, 
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  802a76:	b8 00 00 00 00       	mov    $0x0,%eax
  802a7b:	be 00 00 00 00       	mov    $0x0,%esi
  802a80:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  802a84:	74 3f                	je     802ac5 <devcons_write+0x5b>
		m = n - tot;
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  802a86:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs, 
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
		m = n - tot;
  802a8c:	8b 55 10             	mov    0x10(%ebp),%edx
  802a8f:	29 c2                	sub    %eax,%edx
  802a91:	89 d3                	mov    %edx,%ebx
		if (m > sizeof(buf) - 1)
  802a93:	83 fa 7f             	cmp    $0x7f,%edx
  802a96:	76 05                	jbe    802a9d <devcons_write+0x33>
  802a98:	bb 7f 00 00 00       	mov    $0x7f,%ebx
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  802a9d:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  802aa1:	03 45 0c             	add    0xc(%ebp),%eax
  802aa4:	89 44 24 04          	mov    %eax,0x4(%esp)
  802aa8:	89 3c 24             	mov    %edi,(%esp)
  802aab:	e8 55 e2 ff ff       	call   800d05 <memmove>
		sys_cputs(buf, m);
  802ab0:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  802ab4:	89 3c 24             	mov    %edi,(%esp)
  802ab7:	e8 84 e4 ff ff       	call   800f40 <sys_cputs>
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs, 
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  802abc:	01 de                	add    %ebx,%esi
  802abe:	89 f0                	mov    %esi,%eax
  802ac0:	3b 75 10             	cmp    0x10(%ebp),%esi
  802ac3:	72 c7                	jb     802a8c <devcons_write+0x22>
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
}
  802ac5:	89 f0                	mov    %esi,%eax
  802ac7:	81 c4 9c 00 00 00    	add    $0x9c,%esp
  802acd:	5b                   	pop    %ebx
  802ace:	5e                   	pop    %esi
  802acf:	5f                   	pop    %edi
  802ad0:	5d                   	pop    %ebp
  802ad1:	c3                   	ret    

00802ad2 <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  802ad2:	55                   	push   %ebp
  802ad3:	89 e5                	mov    %esp,%ebp
  802ad5:	83 ec 28             	sub    $0x28,%esp
	char c = ch;
  802ad8:	8b 45 08             	mov    0x8(%ebp),%eax
  802adb:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  802ade:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  802ae5:	00 
  802ae6:	8d 45 f7             	lea    -0x9(%ebp),%eax
  802ae9:	89 04 24             	mov    %eax,(%esp)
  802aec:	e8 4f e4 ff ff       	call   800f40 <sys_cputs>
}
  802af1:	c9                   	leave  
  802af2:	c3                   	ret    

00802af3 <devcons_read>:
	return fd2num(fd);
}

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  802af3:	55                   	push   %ebp
  802af4:	89 e5                	mov    %esp,%ebp
  802af6:	83 ec 08             	sub    $0x8,%esp
	int c;

	if (n == 0)
  802af9:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  802afd:	75 07                	jne    802b06 <devcons_read+0x13>
  802aff:	eb 28                	jmp    802b29 <devcons_read+0x36>
		return 0;

	while ((c = sys_cgetc()) == 0)
		sys_yield();
  802b01:	e8 94 e8 ff ff       	call   80139a <sys_yield>
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  802b06:	66 90                	xchg   %ax,%ax
  802b08:	e8 ff e3 ff ff       	call   800f0c <sys_cgetc>
  802b0d:	85 c0                	test   %eax,%eax
  802b0f:	90                   	nop
  802b10:	74 ef                	je     802b01 <devcons_read+0xe>
  802b12:	89 c2                	mov    %eax,%edx
		sys_yield();
	if (c < 0)
  802b14:	85 c0                	test   %eax,%eax
  802b16:	78 16                	js     802b2e <devcons_read+0x3b>
		return c;
	if (c == 0x04)	// ctl-d is eof
  802b18:	83 f8 04             	cmp    $0x4,%eax
  802b1b:	74 0c                	je     802b29 <devcons_read+0x36>
		return 0;
	*(char*)vbuf = c;
  802b1d:	8b 45 0c             	mov    0xc(%ebp),%eax
  802b20:	88 10                	mov    %dl,(%eax)
  802b22:	b8 01 00 00 00       	mov    $0x1,%eax
	return 1;
  802b27:	eb 05                	jmp    802b2e <devcons_read+0x3b>
  802b29:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802b2e:	c9                   	leave  
  802b2f:	c3                   	ret    

00802b30 <opencons>:
	return fd->fd_dev_id == devcons.dev_id;
}

int
opencons(void)
{
  802b30:	55                   	push   %ebp
  802b31:	89 e5                	mov    %esp,%ebp
  802b33:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  802b36:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802b39:	89 04 24             	mov    %eax,(%esp)
  802b3c:	e8 da ed ff ff       	call   80191b <fd_alloc>
  802b41:	85 c0                	test   %eax,%eax
  802b43:	78 3f                	js     802b84 <opencons+0x54>
		return r;
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  802b45:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  802b4c:	00 
  802b4d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b50:	89 44 24 04          	mov    %eax,0x4(%esp)
  802b54:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802b5b:	e8 db e7 ff ff       	call   80133b <sys_page_alloc>
  802b60:	85 c0                	test   %eax,%eax
  802b62:	78 20                	js     802b84 <opencons+0x54>
		return r;
	fd->fd_dev_id = devcons.dev_id;
  802b64:	8b 15 58 70 80 00    	mov    0x807058,%edx
  802b6a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b6d:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  802b6f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b72:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  802b79:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b7c:	89 04 24             	mov    %eax,(%esp)
  802b7f:	e8 6c ed ff ff       	call   8018f0 <fd2num>
}
  802b84:	c9                   	leave  
  802b85:	c3                   	ret    

00802b86 <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  802b86:	55                   	push   %ebp
  802b87:	89 e5                	mov    %esp,%ebp
  802b89:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802b8c:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802b8f:	89 44 24 04          	mov    %eax,0x4(%esp)
  802b93:	8b 45 08             	mov    0x8(%ebp),%eax
  802b96:	89 04 24             	mov    %eax,(%esp)
  802b99:	e8 ef ed ff ff       	call   80198d <fd_lookup>
  802b9e:	85 c0                	test   %eax,%eax
  802ba0:	78 11                	js     802bb3 <iscons+0x2d>
		return r;
	return fd->fd_dev_id == devcons.dev_id;
  802ba2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ba5:	8b 00                	mov    (%eax),%eax
  802ba7:	3b 05 58 70 80 00    	cmp    0x807058,%eax
  802bad:	0f 94 c0             	sete   %al
  802bb0:	0f b6 c0             	movzbl %al,%eax
}
  802bb3:	c9                   	leave  
  802bb4:	c3                   	ret    

00802bb5 <getchar>:
	sys_cputs(&c, 1);
}

int
getchar(void)
{
  802bb5:	55                   	push   %ebp
  802bb6:	89 e5                	mov    %esp,%ebp
  802bb8:	83 ec 28             	sub    $0x28,%esp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  802bbb:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  802bc2:	00 
  802bc3:	8d 45 f7             	lea    -0x9(%ebp),%eax
  802bc6:	89 44 24 04          	mov    %eax,0x4(%esp)
  802bca:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802bd1:	e8 18 f0 ff ff       	call   801bee <read>
	if (r < 0)
  802bd6:	85 c0                	test   %eax,%eax
  802bd8:	78 0f                	js     802be9 <getchar+0x34>
		return r;
	if (r < 1)
  802bda:	85 c0                	test   %eax,%eax
  802bdc:	7f 07                	jg     802be5 <getchar+0x30>
  802bde:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  802be3:	eb 04                	jmp    802be9 <getchar+0x34>
		return -E_EOF;
	return c;
  802be5:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  802be9:	c9                   	leave  
  802bea:	c3                   	ret    
	...

00802bec <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  802bec:	55                   	push   %ebp
  802bed:	89 e5                	mov    %esp,%ebp
  802bef:	83 ec 18             	sub    $0x18,%esp
	int r;

	if (_pgfault_handler == 0) {
  802bf2:	83 3d 80 70 80 00 00 	cmpl   $0x0,0x807080
  802bf9:	75 78                	jne    802c73 <set_pgfault_handler+0x87>
		// First time through!
		// LAB 4: Your code here.
		// panic("set_pgfault_handler not implemented");
		int ret;	
		if ((ret = sys_page_alloc(0, (void*)(UXSTACKTOP - PGSIZE), PTE_U | PTE_P | PTE_W)) < 0)
  802bfb:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  802c02:	00 
  802c03:	c7 44 24 04 00 f0 bf 	movl   $0xeebff000,0x4(%esp)
  802c0a:	ee 
  802c0b:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802c12:	e8 24 e7 ff ff       	call   80133b <sys_page_alloc>
  802c17:	85 c0                	test   %eax,%eax
  802c19:	79 20                	jns    802c3b <set_pgfault_handler+0x4f>
			panic (" error in sys_page_alloc: %e\n", ret);
  802c1b:	89 44 24 0c          	mov    %eax,0xc(%esp)
  802c1f:	c7 44 24 08 71 37 80 	movl   $0x803771,0x8(%esp)
  802c26:	00 
  802c27:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  802c2e:	00 
  802c2f:	c7 04 24 8f 37 80 00 	movl   $0x80378f,(%esp)
  802c36:	e8 89 d7 ff ff       	call   8003c4 <_panic>
		if ((ret = sys_env_set_pgfault_upcall(0, _pgfault_upcall)) < 0)
  802c3b:	c7 44 24 04 80 2c 80 	movl   $0x802c80,0x4(%esp)
  802c42:	00 
  802c43:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802c4a:	e8 16 e5 ff ff       	call   801165 <sys_env_set_pgfault_upcall>
  802c4f:	85 c0                	test   %eax,%eax
  802c51:	79 20                	jns    802c73 <set_pgfault_handler+0x87>
			panic (" error in sys_env_set_pgfault_upcall: %e\n", ret);
  802c53:	89 44 24 0c          	mov    %eax,0xc(%esp)
  802c57:	c7 44 24 08 a0 37 80 	movl   $0x8037a0,0x8(%esp)
  802c5e:	00 
  802c5f:	c7 44 24 04 25 00 00 	movl   $0x25,0x4(%esp)
  802c66:	00 
  802c67:	c7 04 24 8f 37 80 00 	movl   $0x80378f,(%esp)
  802c6e:	e8 51 d7 ff ff       	call   8003c4 <_panic>
	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  802c73:	8b 45 08             	mov    0x8(%ebp),%eax
  802c76:	a3 80 70 80 00       	mov    %eax,0x807080
	
}
  802c7b:	c9                   	leave  
  802c7c:	c3                   	ret    
  802c7d:	00 00                	add    %al,(%eax)
	...

00802c80 <_pgfault_upcall>:

.text
.globl _pgfault_upcall
_pgfault_upcall:
	// Call the C page fault handler.
	pushl %esp			// function argument: pointer to UTF
  802c80:	54                   	push   %esp
	movl _pgfault_handler, %eax
  802c81:	a1 80 70 80 00       	mov    0x807080,%eax
	call *%eax
  802c86:	ff d0                	call   *%eax
	addl $4, %esp			// pop function argument
  802c88:	83 c4 04             	add    $0x4,%esp
	// may find that you have to rearrange your code in non-obvious
	// ways as registers become unavailable as scratch space.
	//
	// LAB 4: Your code here.
	
	movl %esp, %ecx			// back up esp to ecx
  802c8b:	89 e1                	mov    %esp,%ecx
	movl 0x28(%esp), %ebx		// store trap-time eip into ebx
  802c8d:	8b 5c 24 28          	mov    0x28(%esp),%ebx
	movl 0x30(%esp), %edx		// store trap-time esp into edx
  802c91:	8b 54 24 30          	mov    0x30(%esp),%edx
	movl %edx, %esp			// switch to trap-time stack
  802c95:	89 d4                	mov    %edx,%esp
	pushl %ebx			// push trap-time eip here
  802c97:	53                   	push   %ebx
	movl %ecx, %esp			// come back to user exception stack
  802c98:	89 cc                	mov    %ecx,%esp
	
	// for the push made above, update the trap-time esp value in this user exception stack
	// this enables popl %esp to cause esp point to the adjusted trap-time stack 
	subl $0x4, %edx			
  802c9a:	83 ea 04             	sub    $0x4,%edx
	movl %edx, 0x30(%esp)
  802c9d:	89 54 24 30          	mov    %edx,0x30(%esp)
	

	// Restore the trap-time registers.  After you do this, you
	// can no longer modify any general-purpose registers.
	// LAB 4: Your code here.
	addl $0x8, %esp
  802ca1:	83 c4 08             	add    $0x8,%esp
	popal
  802ca4:	61                   	popa   
	// Restore eflags from the stack.  After you do this, you can
	// no longer use arithmetic operations or anything else that
	// modifies eflags.
	// LAB 4: Your code here.
	
	addl $0x4, %esp
  802ca5:	83 c4 04             	add    $0x4,%esp
	popfl
  802ca8:	9d                   	popf   

	// Switch back to the adjusted trap-time stack.
	// LAB 4: Your code here.

	popl %esp
  802ca9:	5c                   	pop    %esp

	// Return to re-execute the instruction that faulted.
	// LAB 4: Your code here.
	
	ret
  802caa:	c3                   	ret    
	...

00802cac <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  802cac:	55                   	push   %ebp
  802cad:	89 e5                	mov    %esp,%ebp
	pte_t pte;

	if (!(vpd[PDX(v)] & PTE_P))
  802caf:	8b 45 08             	mov    0x8(%ebp),%eax
  802cb2:	89 c2                	mov    %eax,%edx
  802cb4:	c1 ea 16             	shr    $0x16,%edx
  802cb7:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  802cbe:	f6 c2 01             	test   $0x1,%dl
  802cc1:	74 26                	je     802ce9 <pageref+0x3d>
		return 0;
	pte = vpt[VPN(v)];
  802cc3:	c1 e8 0c             	shr    $0xc,%eax
  802cc6:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
	if (!(pte & PTE_P))
  802ccd:	a8 01                	test   $0x1,%al
  802ccf:	74 18                	je     802ce9 <pageref+0x3d>
		return 0;
	return pages[PPN(pte)].pp_ref;
  802cd1:	c1 e8 0c             	shr    $0xc,%eax
  802cd4:	8d 14 40             	lea    (%eax,%eax,2),%edx
  802cd7:	c1 e2 02             	shl    $0x2,%edx
  802cda:	b8 00 00 00 ef       	mov    $0xef000000,%eax
  802cdf:	0f b7 44 02 08       	movzwl 0x8(%edx,%eax,1),%eax
  802ce4:	0f b7 c0             	movzwl %ax,%eax
  802ce7:	eb 05                	jmp    802cee <pageref+0x42>
  802ce9:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802cee:	5d                   	pop    %ebp
  802cef:	c3                   	ret    

00802cf0 <__udivdi3>:
  802cf0:	55                   	push   %ebp
  802cf1:	89 e5                	mov    %esp,%ebp
  802cf3:	57                   	push   %edi
  802cf4:	56                   	push   %esi
  802cf5:	83 ec 10             	sub    $0x10,%esp
  802cf8:	8b 45 14             	mov    0x14(%ebp),%eax
  802cfb:	8b 55 08             	mov    0x8(%ebp),%edx
  802cfe:	8b 75 10             	mov    0x10(%ebp),%esi
  802d01:	8b 7d 0c             	mov    0xc(%ebp),%edi
  802d04:	85 c0                	test   %eax,%eax
  802d06:	89 55 f0             	mov    %edx,-0x10(%ebp)
  802d09:	75 35                	jne    802d40 <__udivdi3+0x50>
  802d0b:	39 fe                	cmp    %edi,%esi
  802d0d:	77 61                	ja     802d70 <__udivdi3+0x80>
  802d0f:	85 f6                	test   %esi,%esi
  802d11:	75 0b                	jne    802d1e <__udivdi3+0x2e>
  802d13:	b8 01 00 00 00       	mov    $0x1,%eax
  802d18:	31 d2                	xor    %edx,%edx
  802d1a:	f7 f6                	div    %esi
  802d1c:	89 c6                	mov    %eax,%esi
  802d1e:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  802d21:	31 d2                	xor    %edx,%edx
  802d23:	89 f8                	mov    %edi,%eax
  802d25:	f7 f6                	div    %esi
  802d27:	89 c7                	mov    %eax,%edi
  802d29:	89 c8                	mov    %ecx,%eax
  802d2b:	f7 f6                	div    %esi
  802d2d:	89 c1                	mov    %eax,%ecx
  802d2f:	89 fa                	mov    %edi,%edx
  802d31:	89 c8                	mov    %ecx,%eax
  802d33:	83 c4 10             	add    $0x10,%esp
  802d36:	5e                   	pop    %esi
  802d37:	5f                   	pop    %edi
  802d38:	5d                   	pop    %ebp
  802d39:	c3                   	ret    
  802d3a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  802d40:	39 f8                	cmp    %edi,%eax
  802d42:	77 1c                	ja     802d60 <__udivdi3+0x70>
  802d44:	0f bd d0             	bsr    %eax,%edx
  802d47:	83 f2 1f             	xor    $0x1f,%edx
  802d4a:	89 55 f4             	mov    %edx,-0xc(%ebp)
  802d4d:	75 39                	jne    802d88 <__udivdi3+0x98>
  802d4f:	3b 75 f0             	cmp    -0x10(%ebp),%esi
  802d52:	0f 86 a0 00 00 00    	jbe    802df8 <__udivdi3+0x108>
  802d58:	39 f8                	cmp    %edi,%eax
  802d5a:	0f 82 98 00 00 00    	jb     802df8 <__udivdi3+0x108>
  802d60:	31 ff                	xor    %edi,%edi
  802d62:	31 c9                	xor    %ecx,%ecx
  802d64:	89 c8                	mov    %ecx,%eax
  802d66:	89 fa                	mov    %edi,%edx
  802d68:	83 c4 10             	add    $0x10,%esp
  802d6b:	5e                   	pop    %esi
  802d6c:	5f                   	pop    %edi
  802d6d:	5d                   	pop    %ebp
  802d6e:	c3                   	ret    
  802d6f:	90                   	nop
  802d70:	89 d1                	mov    %edx,%ecx
  802d72:	89 fa                	mov    %edi,%edx
  802d74:	89 c8                	mov    %ecx,%eax
  802d76:	31 ff                	xor    %edi,%edi
  802d78:	f7 f6                	div    %esi
  802d7a:	89 c1                	mov    %eax,%ecx
  802d7c:	89 fa                	mov    %edi,%edx
  802d7e:	89 c8                	mov    %ecx,%eax
  802d80:	83 c4 10             	add    $0x10,%esp
  802d83:	5e                   	pop    %esi
  802d84:	5f                   	pop    %edi
  802d85:	5d                   	pop    %ebp
  802d86:	c3                   	ret    
  802d87:	90                   	nop
  802d88:	0f b6 4d f4          	movzbl -0xc(%ebp),%ecx
  802d8c:	89 f2                	mov    %esi,%edx
  802d8e:	d3 e0                	shl    %cl,%eax
  802d90:	89 45 ec             	mov    %eax,-0x14(%ebp)
  802d93:	b8 20 00 00 00       	mov    $0x20,%eax
  802d98:	2b 45 f4             	sub    -0xc(%ebp),%eax
  802d9b:	89 c1                	mov    %eax,%ecx
  802d9d:	d3 ea                	shr    %cl,%edx
  802d9f:	0f b6 4d f4          	movzbl -0xc(%ebp),%ecx
  802da3:	0b 55 ec             	or     -0x14(%ebp),%edx
  802da6:	d3 e6                	shl    %cl,%esi
  802da8:	89 c1                	mov    %eax,%ecx
  802daa:	89 75 e8             	mov    %esi,-0x18(%ebp)
  802dad:	89 fe                	mov    %edi,%esi
  802daf:	d3 ee                	shr    %cl,%esi
  802db1:	0f b6 4d f4          	movzbl -0xc(%ebp),%ecx
  802db5:	89 55 ec             	mov    %edx,-0x14(%ebp)
  802db8:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802dbb:	d3 e7                	shl    %cl,%edi
  802dbd:	89 c1                	mov    %eax,%ecx
  802dbf:	d3 ea                	shr    %cl,%edx
  802dc1:	09 d7                	or     %edx,%edi
  802dc3:	89 f2                	mov    %esi,%edx
  802dc5:	89 f8                	mov    %edi,%eax
  802dc7:	f7 75 ec             	divl   -0x14(%ebp)
  802dca:	89 d6                	mov    %edx,%esi
  802dcc:	89 c7                	mov    %eax,%edi
  802dce:	f7 65 e8             	mull   -0x18(%ebp)
  802dd1:	39 d6                	cmp    %edx,%esi
  802dd3:	89 55 ec             	mov    %edx,-0x14(%ebp)
  802dd6:	72 30                	jb     802e08 <__udivdi3+0x118>
  802dd8:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802ddb:	0f b6 4d f4          	movzbl -0xc(%ebp),%ecx
  802ddf:	d3 e2                	shl    %cl,%edx
  802de1:	39 c2                	cmp    %eax,%edx
  802de3:	73 05                	jae    802dea <__udivdi3+0xfa>
  802de5:	3b 75 ec             	cmp    -0x14(%ebp),%esi
  802de8:	74 1e                	je     802e08 <__udivdi3+0x118>
  802dea:	89 f9                	mov    %edi,%ecx
  802dec:	31 ff                	xor    %edi,%edi
  802dee:	e9 71 ff ff ff       	jmp    802d64 <__udivdi3+0x74>
  802df3:	90                   	nop
  802df4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802df8:	31 ff                	xor    %edi,%edi
  802dfa:	b9 01 00 00 00       	mov    $0x1,%ecx
  802dff:	e9 60 ff ff ff       	jmp    802d64 <__udivdi3+0x74>
  802e04:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802e08:	8d 4f ff             	lea    -0x1(%edi),%ecx
  802e0b:	31 ff                	xor    %edi,%edi
  802e0d:	89 c8                	mov    %ecx,%eax
  802e0f:	89 fa                	mov    %edi,%edx
  802e11:	83 c4 10             	add    $0x10,%esp
  802e14:	5e                   	pop    %esi
  802e15:	5f                   	pop    %edi
  802e16:	5d                   	pop    %ebp
  802e17:	c3                   	ret    
	...

00802e20 <__umoddi3>:
  802e20:	55                   	push   %ebp
  802e21:	89 e5                	mov    %esp,%ebp
  802e23:	57                   	push   %edi
  802e24:	56                   	push   %esi
  802e25:	83 ec 20             	sub    $0x20,%esp
  802e28:	8b 55 14             	mov    0x14(%ebp),%edx
  802e2b:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802e2e:	8b 7d 10             	mov    0x10(%ebp),%edi
  802e31:	8b 75 0c             	mov    0xc(%ebp),%esi
  802e34:	85 d2                	test   %edx,%edx
  802e36:	89 c8                	mov    %ecx,%eax
  802e38:	89 4d f4             	mov    %ecx,-0xc(%ebp)
  802e3b:	75 13                	jne    802e50 <__umoddi3+0x30>
  802e3d:	39 f7                	cmp    %esi,%edi
  802e3f:	76 3f                	jbe    802e80 <__umoddi3+0x60>
  802e41:	89 f2                	mov    %esi,%edx
  802e43:	f7 f7                	div    %edi
  802e45:	89 d0                	mov    %edx,%eax
  802e47:	31 d2                	xor    %edx,%edx
  802e49:	83 c4 20             	add    $0x20,%esp
  802e4c:	5e                   	pop    %esi
  802e4d:	5f                   	pop    %edi
  802e4e:	5d                   	pop    %ebp
  802e4f:	c3                   	ret    
  802e50:	39 f2                	cmp    %esi,%edx
  802e52:	77 4c                	ja     802ea0 <__umoddi3+0x80>
  802e54:	0f bd ca             	bsr    %edx,%ecx
  802e57:	83 f1 1f             	xor    $0x1f,%ecx
  802e5a:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  802e5d:	75 51                	jne    802eb0 <__umoddi3+0x90>
  802e5f:	3b 7d f4             	cmp    -0xc(%ebp),%edi
  802e62:	0f 87 e0 00 00 00    	ja     802f48 <__umoddi3+0x128>
  802e68:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e6b:	29 f8                	sub    %edi,%eax
  802e6d:	19 d6                	sbb    %edx,%esi
  802e6f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802e72:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e75:	89 f2                	mov    %esi,%edx
  802e77:	83 c4 20             	add    $0x20,%esp
  802e7a:	5e                   	pop    %esi
  802e7b:	5f                   	pop    %edi
  802e7c:	5d                   	pop    %ebp
  802e7d:	c3                   	ret    
  802e7e:	66 90                	xchg   %ax,%ax
  802e80:	85 ff                	test   %edi,%edi
  802e82:	75 0b                	jne    802e8f <__umoddi3+0x6f>
  802e84:	b8 01 00 00 00       	mov    $0x1,%eax
  802e89:	31 d2                	xor    %edx,%edx
  802e8b:	f7 f7                	div    %edi
  802e8d:	89 c7                	mov    %eax,%edi
  802e8f:	89 f0                	mov    %esi,%eax
  802e91:	31 d2                	xor    %edx,%edx
  802e93:	f7 f7                	div    %edi
  802e95:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e98:	f7 f7                	div    %edi
  802e9a:	eb a9                	jmp    802e45 <__umoddi3+0x25>
  802e9c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802ea0:	89 c8                	mov    %ecx,%eax
  802ea2:	89 f2                	mov    %esi,%edx
  802ea4:	83 c4 20             	add    $0x20,%esp
  802ea7:	5e                   	pop    %esi
  802ea8:	5f                   	pop    %edi
  802ea9:	5d                   	pop    %ebp
  802eaa:	c3                   	ret    
  802eab:	90                   	nop
  802eac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802eb0:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
  802eb4:	d3 e2                	shl    %cl,%edx
  802eb6:	89 55 f4             	mov    %edx,-0xc(%ebp)
  802eb9:	ba 20 00 00 00       	mov    $0x20,%edx
  802ebe:	2b 55 f0             	sub    -0x10(%ebp),%edx
  802ec1:	89 55 ec             	mov    %edx,-0x14(%ebp)
  802ec4:	0f b6 4d ec          	movzbl -0x14(%ebp),%ecx
  802ec8:	89 fa                	mov    %edi,%edx
  802eca:	d3 ea                	shr    %cl,%edx
  802ecc:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
  802ed0:	0b 55 f4             	or     -0xc(%ebp),%edx
  802ed3:	d3 e7                	shl    %cl,%edi
  802ed5:	0f b6 4d ec          	movzbl -0x14(%ebp),%ecx
  802ed9:	89 55 f4             	mov    %edx,-0xc(%ebp)
  802edc:	89 f2                	mov    %esi,%edx
  802ede:	89 7d e8             	mov    %edi,-0x18(%ebp)
  802ee1:	89 c7                	mov    %eax,%edi
  802ee3:	d3 ea                	shr    %cl,%edx
  802ee5:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
  802ee9:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  802eec:	89 c2                	mov    %eax,%edx
  802eee:	d3 e6                	shl    %cl,%esi
  802ef0:	0f b6 4d ec          	movzbl -0x14(%ebp),%ecx
  802ef4:	d3 ea                	shr    %cl,%edx
  802ef6:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
  802efa:	09 d6                	or     %edx,%esi
  802efc:	89 f0                	mov    %esi,%eax
  802efe:	8b 75 e4             	mov    -0x1c(%ebp),%esi
  802f01:	d3 e7                	shl    %cl,%edi
  802f03:	89 f2                	mov    %esi,%edx
  802f05:	f7 75 f4             	divl   -0xc(%ebp)
  802f08:	89 d6                	mov    %edx,%esi
  802f0a:	f7 65 e8             	mull   -0x18(%ebp)
  802f0d:	39 d6                	cmp    %edx,%esi
  802f0f:	72 2b                	jb     802f3c <__umoddi3+0x11c>
  802f11:	39 c7                	cmp    %eax,%edi
  802f13:	72 23                	jb     802f38 <__umoddi3+0x118>
  802f15:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
  802f19:	29 c7                	sub    %eax,%edi
  802f1b:	19 d6                	sbb    %edx,%esi
  802f1d:	89 f0                	mov    %esi,%eax
  802f1f:	89 f2                	mov    %esi,%edx
  802f21:	d3 ef                	shr    %cl,%edi
  802f23:	0f b6 4d ec          	movzbl -0x14(%ebp),%ecx
  802f27:	d3 e0                	shl    %cl,%eax
  802f29:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
  802f2d:	09 f8                	or     %edi,%eax
  802f2f:	d3 ea                	shr    %cl,%edx
  802f31:	83 c4 20             	add    $0x20,%esp
  802f34:	5e                   	pop    %esi
  802f35:	5f                   	pop    %edi
  802f36:	5d                   	pop    %ebp
  802f37:	c3                   	ret    
  802f38:	39 d6                	cmp    %edx,%esi
  802f3a:	75 d9                	jne    802f15 <__umoddi3+0xf5>
  802f3c:	2b 45 e8             	sub    -0x18(%ebp),%eax
  802f3f:	1b 55 f4             	sbb    -0xc(%ebp),%edx
  802f42:	eb d1                	jmp    802f15 <__umoddi3+0xf5>
  802f44:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802f48:	39 f2                	cmp    %esi,%edx
  802f4a:	0f 82 18 ff ff ff    	jb     802e68 <__umoddi3+0x48>
  802f50:	e9 1d ff ff ff       	jmp    802e72 <__umoddi3+0x52>
