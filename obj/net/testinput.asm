
obj/net/testinput:     file format elf32-i386


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
  80002c:	e8 07 06 00 00       	call   800638 <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>
	...

00800040 <umain>:
	}
}

void
umain(void)
{
  800040:	55                   	push   %ebp
  800041:	89 e5                	mov    %esp,%ebp
  800043:	57                   	push   %edi
  800044:	56                   	push   %esi
  800045:	53                   	push   %ebx
  800046:	81 ec ac 00 00 00    	sub    $0xac,%esp
	envid_t ns_envid = sys_getenvid();
  80004c:	e8 5d 16 00 00       	call   8016ae <sys_getenvid>
  800051:	89 c3                	mov    %eax,%ebx
	int i, r;

	binaryname = "testinput";
  800053:	c7 05 00 70 80 00 60 	movl   $0x803560,0x807000
  80005a:	35 80 00 

	output_envid = fork();
  80005d:	e8 43 18 00 00       	call   8018a5 <fork>
  800062:	a3 74 70 80 00       	mov    %eax,0x807074
	if (output_envid < 0)
  800067:	85 c0                	test   %eax,%eax
  800069:	79 1c                	jns    800087 <umain+0x47>
		panic("error forking");
  80006b:	c7 44 24 08 6a 35 80 	movl   $0x80356a,0x8(%esp)
  800072:	00 
  800073:	c7 44 24 04 4d 00 00 	movl   $0x4d,0x4(%esp)
  80007a:	00 
  80007b:	c7 04 24 78 35 80 00 	movl   $0x803578,(%esp)
  800082:	e8 1d 06 00 00       	call   8006a4 <_panic>
	else if (output_envid == 0) {
  800087:	85 c0                	test   %eax,%eax
  800089:	75 0d                	jne    800098 <umain+0x58>
		output(ns_envid);
  80008b:	89 1c 24             	mov    %ebx,(%esp)
  80008e:	e8 1d 05 00 00       	call   8005b0 <output>
		return;
  800093:	e9 a6 03 00 00       	jmp    80043e <umain+0x3fe>
	}

	input_envid = fork();
  800098:	e8 08 18 00 00       	call   8018a5 <fork>
  80009d:	a3 78 70 80 00       	mov    %eax,0x807078
	if (input_envid < 0)
  8000a2:	85 c0                	test   %eax,%eax
  8000a4:	79 1c                	jns    8000c2 <umain+0x82>
		panic("error forking");
  8000a6:	c7 44 24 08 6a 35 80 	movl   $0x80356a,0x8(%esp)
  8000ad:	00 
  8000ae:	c7 44 24 04 55 00 00 	movl   $0x55,0x4(%esp)
  8000b5:	00 
  8000b6:	c7 04 24 78 35 80 00 	movl   $0x803578,(%esp)
  8000bd:	e8 e2 05 00 00       	call   8006a4 <_panic>
	else if (input_envid == 0) {
  8000c2:	85 c0                	test   %eax,%eax
  8000c4:	75 0f                	jne    8000d5 <umain+0x95>
		input(ns_envid);
  8000c6:	89 1c 24             	mov    %ebx,(%esp)
  8000c9:	e8 22 04 00 00       	call   8004f0 <input>
  8000ce:	66 90                	xchg   %ax,%ax
  8000d0:	e9 69 03 00 00       	jmp    80043e <umain+0x3fe>
		return;
	}

	cprintf("Sending ARP announcement...\n");
  8000d5:	c7 04 24 88 35 80 00 	movl   $0x803588,(%esp)
  8000dc:	e8 88 06 00 00       	call   800769 <cprintf>
	// with ARP requests.  Ideally, we would use gratuitous ARP
	// for this, but QEMU's ARP implementation is dumb and only
	// listens for very specific ARP requests, such as requests
	// for the gateway IP.

	uint8_t mac[6] = {0x52, 0x54, 0x00, 0x12, 0x34, 0x56};
  8000e1:	c6 45 90 52          	movb   $0x52,-0x70(%ebp)
  8000e5:	c6 45 91 54          	movb   $0x54,-0x6f(%ebp)
  8000e9:	c6 45 92 00          	movb   $0x0,-0x6e(%ebp)
  8000ed:	c6 45 93 12          	movb   $0x12,-0x6d(%ebp)
  8000f1:	c6 45 94 34          	movb   $0x34,-0x6c(%ebp)
  8000f5:	c6 45 95 56          	movb   $0x56,-0x6b(%ebp)
	uint32_t myip = inet_addr(IP);
  8000f9:	c7 04 24 a5 35 80 00 	movl   $0x8035a5,(%esp)
  800100:	e8 b3 31 00 00       	call   8032b8 <inet_addr>
  800105:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	uint32_t gwip = inet_addr(DEFAULT);
  800108:	c7 04 24 af 35 80 00 	movl   $0x8035af,(%esp)
  80010f:	e8 a4 31 00 00       	call   8032b8 <inet_addr>
  800114:	89 45 e0             	mov    %eax,-0x20(%ebp)
	int r;

	if ((r = sys_page_alloc(0, pkt, PTE_P|PTE_U|PTE_W)) < 0)
  800117:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  80011e:	00 
  80011f:	c7 44 24 04 00 b0 fe 	movl   $0xffeb000,0x4(%esp)
  800126:	0f 
  800127:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80012e:	e8 e8 14 00 00       	call   80161b <sys_page_alloc>
  800133:	85 c0                	test   %eax,%eax
  800135:	79 20                	jns    800157 <umain+0x117>
		panic("sys_page_map: %e", r);
  800137:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80013b:	c7 44 24 08 b8 35 80 	movl   $0x8035b8,0x8(%esp)
  800142:	00 
  800143:	c7 44 24 04 19 00 00 	movl   $0x19,0x4(%esp)
  80014a:	00 
  80014b:	c7 04 24 78 35 80 00 	movl   $0x803578,(%esp)
  800152:	e8 4d 05 00 00       	call   8006a4 <_panic>

	struct etharp_hdr *arp = (struct etharp_hdr*)pkt->jp_data;
  800157:	bb 04 b0 fe 0f       	mov    $0xffeb004,%ebx
	pkt->jp_len = sizeof(*arp);
  80015c:	c7 05 00 b0 fe 0f 2a 	movl   $0x2a,0xffeb000
  800163:	00 00 00 

	memset(arp->ethhdr.dest.addr, 0xff, ETHARP_HWADDR_LEN);
  800166:	c7 44 24 08 06 00 00 	movl   $0x6,0x8(%esp)
  80016d:	00 
  80016e:	c7 44 24 04 ff 00 00 	movl   $0xff,0x4(%esp)
  800175:	00 
  800176:	c7 04 24 04 b0 fe 0f 	movl   $0xffeb004,(%esp)
  80017d:	e8 04 0e 00 00       	call   800f86 <memset>
	memcpy(arp->ethhdr.src.addr,  mac,  ETHARP_HWADDR_LEN);
  800182:	c7 44 24 08 06 00 00 	movl   $0x6,0x8(%esp)
  800189:	00 
  80018a:	8d 75 90             	lea    -0x70(%ebp),%esi
  80018d:	89 74 24 04          	mov    %esi,0x4(%esp)
  800191:	c7 04 24 0a b0 fe 0f 	movl   $0xffeb00a,(%esp)
  800198:	e8 c4 0e 00 00       	call   801061 <memcpy>
	arp->ethhdr.type = htons(ETHTYPE_ARP);
  80019d:	c7 04 24 06 08 00 00 	movl   $0x806,(%esp)
  8001a4:	e8 eb 2e 00 00       	call   803094 <htons>
  8001a9:	66 89 43 0c          	mov    %ax,0xc(%ebx)
	arp->hwtype = htons(1); // Ethernet
  8001ad:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  8001b4:	e8 db 2e 00 00       	call   803094 <htons>
  8001b9:	66 89 43 0e          	mov    %ax,0xe(%ebx)
	arp->proto = htons(ETHTYPE_IP);
  8001bd:	c7 04 24 00 08 00 00 	movl   $0x800,(%esp)
  8001c4:	e8 cb 2e 00 00       	call   803094 <htons>
  8001c9:	66 89 43 10          	mov    %ax,0x10(%ebx)
	arp->_hwlen_protolen = htons((ETHARP_HWADDR_LEN << 8) | 4);
  8001cd:	c7 04 24 04 06 00 00 	movl   $0x604,(%esp)
  8001d4:	e8 bb 2e 00 00       	call   803094 <htons>
  8001d9:	66 89 43 12          	mov    %ax,0x12(%ebx)
	arp->opcode = htons(ARP_REQUEST);
  8001dd:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  8001e4:	e8 ab 2e 00 00       	call   803094 <htons>
  8001e9:	66 89 43 14          	mov    %ax,0x14(%ebx)
	memcpy(arp->shwaddr.addr,  mac,   ETHARP_HWADDR_LEN);
  8001ed:	c7 44 24 08 06 00 00 	movl   $0x6,0x8(%esp)
  8001f4:	00 
  8001f5:	89 74 24 04          	mov    %esi,0x4(%esp)
  8001f9:	c7 04 24 1a b0 fe 0f 	movl   $0xffeb01a,(%esp)
  800200:	e8 5c 0e 00 00       	call   801061 <memcpy>
	memcpy(arp->sipaddr.addrw, &myip, 4);
  800205:	c7 44 24 08 04 00 00 	movl   $0x4,0x8(%esp)
  80020c:	00 
  80020d:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  800210:	89 44 24 04          	mov    %eax,0x4(%esp)
  800214:	c7 04 24 20 b0 fe 0f 	movl   $0xffeb020,(%esp)
  80021b:	e8 41 0e 00 00       	call   801061 <memcpy>
	memset(arp->dhwaddr.addr,  0x00,  ETHARP_HWADDR_LEN);
  800220:	c7 44 24 08 06 00 00 	movl   $0x6,0x8(%esp)
  800227:	00 
  800228:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  80022f:	00 
  800230:	c7 04 24 24 b0 fe 0f 	movl   $0xffeb024,(%esp)
  800237:	e8 4a 0d 00 00       	call   800f86 <memset>
	memcpy(arp->dipaddr.addrw, &gwip, 4);
  80023c:	c7 44 24 08 04 00 00 	movl   $0x4,0x8(%esp)
  800243:	00 
  800244:	8d 45 e0             	lea    -0x20(%ebp),%eax
  800247:	89 44 24 04          	mov    %eax,0x4(%esp)
  80024b:	c7 04 24 2a b0 fe 0f 	movl   $0xffeb02a,(%esp)
  800252:	e8 0a 0e 00 00       	call   801061 <memcpy>

	ipc_send(output_envid, NSREQ_OUTPUT, pkt, PTE_P|PTE_W|PTE_U);
  800257:	c7 44 24 0c 07 00 00 	movl   $0x7,0xc(%esp)
  80025e:	00 
  80025f:	c7 44 24 08 00 b0 fe 	movl   $0xffeb000,0x8(%esp)
  800266:	0f 
  800267:	c7 44 24 04 0b 00 00 	movl   $0xb,0x4(%esp)
  80026e:	00 
  80026f:	a1 74 70 80 00       	mov    0x807074,%eax
  800274:	89 04 24             	mov    %eax,(%esp)
  800277:	e8 84 18 00 00       	call   801b00 <ipc_send>
	sys_page_unmap(0, pkt);
  80027c:	c7 44 24 04 00 b0 fe 	movl   $0xffeb000,0x4(%esp)
  800283:	0f 
  800284:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80028b:	e8 cf 12 00 00       	call   80155f <sys_page_unmap>
	}

	cprintf("Sending ARP announcement...\n");
	announce();

	cprintf("Waiting for packets...\n");
  800290:	c7 04 24 c9 35 80 00 	movl   $0x8035c9,(%esp)
  800297:	e8 cd 04 00 00       	call   800769 <cprintf>
	while (1) {
		envid_t whom;
		int perm;

		int32_t req = ipc_recv((int32_t *)&whom, pkt, &perm);
  80029c:	8d 45 e0             	lea    -0x20(%ebp),%eax
  80029f:	89 85 74 ff ff ff    	mov    %eax,-0x8c(%ebp)
	char buf[80];
	char *end = buf + sizeof(buf);
	char *out = NULL;
	for (i = 0; i < len; i++) {
		if (i % 16 == 0)
			out = buf + snprintf(buf, end - buf,
  8002a5:	89 b5 70 ff ff ff    	mov    %esi,-0x90(%ebp)
  8002ab:	8b 85 74 ff ff ff    	mov    -0x8c(%ebp),%eax
  8002b1:	29 f0                	sub    %esi,%eax
  8002b3:	89 85 7c ff ff ff    	mov    %eax,-0x84(%ebp)
	cprintf("Waiting for packets...\n");
	while (1) {
		envid_t whom;
		int perm;

		int32_t req = ipc_recv((int32_t *)&whom, pkt, &perm);
  8002b9:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  8002bc:	89 44 24 08          	mov    %eax,0x8(%esp)
  8002c0:	c7 44 24 04 00 b0 fe 	movl   $0xffeb000,0x4(%esp)
  8002c7:	0f 
  8002c8:	8d 45 e0             	lea    -0x20(%ebp),%eax
  8002cb:	89 04 24             	mov    %eax,(%esp)
  8002ce:	e8 93 18 00 00       	call   801b66 <ipc_recv>
		if (req < 0)
  8002d3:	85 c0                	test   %eax,%eax
  8002d5:	79 20                	jns    8002f7 <umain+0x2b7>
			panic("ipc_recv: %e", req);
  8002d7:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8002db:	c7 44 24 08 e1 35 80 	movl   $0x8035e1,0x8(%esp)
  8002e2:	00 
  8002e3:	c7 44 24 04 65 00 00 	movl   $0x65,0x4(%esp)
  8002ea:	00 
  8002eb:	c7 04 24 78 35 80 00 	movl   $0x803578,(%esp)
  8002f2:	e8 ad 03 00 00       	call   8006a4 <_panic>
		if (whom != input_envid)
  8002f7:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8002fa:	3b 15 78 70 80 00    	cmp    0x807078,%edx
  800300:	74 20                	je     800322 <umain+0x2e2>
			panic("IPC from unexpected environment %08x", whom);
  800302:	89 54 24 0c          	mov    %edx,0xc(%esp)
  800306:	c7 44 24 08 20 36 80 	movl   $0x803620,0x8(%esp)
  80030d:	00 
  80030e:	c7 44 24 04 67 00 00 	movl   $0x67,0x4(%esp)
  800315:	00 
  800316:	c7 04 24 78 35 80 00 	movl   $0x803578,(%esp)
  80031d:	e8 82 03 00 00       	call   8006a4 <_panic>
		if (req != NSREQ_INPUT)
  800322:	83 f8 0a             	cmp    $0xa,%eax
  800325:	74 20                	je     800347 <umain+0x307>
			panic("Unexpected IPC %d", req);
  800327:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80032b:	c7 44 24 08 ee 35 80 	movl   $0x8035ee,0x8(%esp)
  800332:	00 
  800333:	c7 44 24 04 69 00 00 	movl   $0x69,0x4(%esp)
  80033a:	00 
  80033b:	c7 04 24 78 35 80 00 	movl   $0x803578,(%esp)
  800342:	e8 5d 03 00 00       	call   8006a4 <_panic>

		hexdump("input: ", pkt->jp_data, pkt->jp_len);
  800347:	a1 00 b0 fe 0f       	mov    0xffeb000,%eax
  80034c:	89 45 84             	mov    %eax,-0x7c(%ebp)
{
	int i;
	char buf[80];
	char *end = buf + sizeof(buf);
	char *out = NULL;
	for (i = 0; i < len; i++) {
  80034f:	85 c0                	test   %eax,%eax
  800351:	0f 8e d6 00 00 00    	jle    80042d <umain+0x3ed>
  800357:	be 00 00 00 00       	mov    $0x0,%esi
  80035c:	bb 00 00 00 00       	mov    $0x0,%ebx
		if (i % 16 == 0)
			out = buf + snprintf(buf, end - buf,
					     "%s%04x   ", prefix, i);
		out += snprintf(out, end - out, "%02x", ((uint8_t*)data)[i]);
		if (i % 16 == 15 || i == len - 1)
  800361:	83 e8 01             	sub    $0x1,%eax
  800364:	89 45 80             	mov    %eax,-0x80(%ebp)
{
	int i;
	char buf[80];
	char *end = buf + sizeof(buf);
	char *out = NULL;
	for (i = 0; i < len; i++) {
  800367:	89 df                	mov    %ebx,%edi
		if (i % 16 == 0)
  800369:	f6 c3 0f             	test   $0xf,%bl
  80036c:	75 2e                	jne    80039c <umain+0x35c>
			out = buf + snprintf(buf, end - buf,
  80036e:	89 5c 24 10          	mov    %ebx,0x10(%esp)
  800372:	c7 44 24 0c 00 36 80 	movl   $0x803600,0xc(%esp)
  800379:	00 
  80037a:	c7 44 24 08 08 36 80 	movl   $0x803608,0x8(%esp)
  800381:	00 
  800382:	8b 85 7c ff ff ff    	mov    -0x84(%ebp),%eax
  800388:	89 44 24 04          	mov    %eax,0x4(%esp)
  80038c:	8d 45 90             	lea    -0x70(%ebp),%eax
  80038f:	89 04 24             	mov    %eax,(%esp)
  800392:	e8 f5 09 00 00       	call   800d8c <snprintf>
  800397:	8d 75 90             	lea    -0x70(%ebp),%esi
  80039a:	01 c6                	add    %eax,%esi
					     "%s%04x   ", prefix, i);
		out += snprintf(out, end - out, "%02x", ((uint8_t*)data)[i]);
  80039c:	0f b6 87 04 b0 fe 0f 	movzbl 0xffeb004(%edi),%eax
  8003a3:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8003a7:	c7 44 24 08 12 36 80 	movl   $0x803612,0x8(%esp)
  8003ae:	00 
  8003af:	8b 85 74 ff ff ff    	mov    -0x8c(%ebp),%eax
  8003b5:	29 f0                	sub    %esi,%eax
  8003b7:	89 44 24 04          	mov    %eax,0x4(%esp)
  8003bb:	89 34 24             	mov    %esi,(%esp)
  8003be:	e8 c9 09 00 00       	call   800d8c <snprintf>
  8003c3:	01 c6                	add    %eax,%esi
		if (i % 16 == 15 || i == len - 1)
  8003c5:	89 d8                	mov    %ebx,%eax
  8003c7:	c1 f8 1f             	sar    $0x1f,%eax
  8003ca:	c1 e8 1c             	shr    $0x1c,%eax
  8003cd:	8d 3c 03             	lea    (%ebx,%eax,1),%edi
  8003d0:	83 e7 0f             	and    $0xf,%edi
  8003d3:	29 c7                	sub    %eax,%edi
  8003d5:	83 ff 0f             	cmp    $0xf,%edi
  8003d8:	74 05                	je     8003df <umain+0x39f>
  8003da:	3b 5d 80             	cmp    -0x80(%ebp),%ebx
  8003dd:	75 1f                	jne    8003fe <umain+0x3be>
			cprintf("%.*s\n", out - buf, buf);
  8003df:	8d 45 90             	lea    -0x70(%ebp),%eax
  8003e2:	89 44 24 08          	mov    %eax,0x8(%esp)
  8003e6:	89 f0                	mov    %esi,%eax
  8003e8:	2b 85 70 ff ff ff    	sub    -0x90(%ebp),%eax
  8003ee:	89 44 24 04          	mov    %eax,0x4(%esp)
  8003f2:	c7 04 24 17 36 80 00 	movl   $0x803617,(%esp)
  8003f9:	e8 6b 03 00 00       	call   800769 <cprintf>
		if (i % 2 == 1)
  8003fe:	89 d8                	mov    %ebx,%eax
  800400:	c1 e8 1f             	shr    $0x1f,%eax
  800403:	8d 14 03             	lea    (%ebx,%eax,1),%edx
  800406:	83 e2 01             	and    $0x1,%edx
  800409:	29 c2                	sub    %eax,%edx
  80040b:	83 fa 01             	cmp    $0x1,%edx
  80040e:	75 06                	jne    800416 <umain+0x3d6>
			*(out++) = ' ';
  800410:	c6 06 20             	movb   $0x20,(%esi)
  800413:	83 c6 01             	add    $0x1,%esi
		if (i % 16 == 7)
  800416:	83 ff 07             	cmp    $0x7,%edi
  800419:	75 06                	jne    800421 <umain+0x3e1>
			*(out++) = ' ';
  80041b:	c6 06 20             	movb   $0x20,(%esi)
  80041e:	83 c6 01             	add    $0x1,%esi
{
	int i;
	char buf[80];
	char *end = buf + sizeof(buf);
	char *out = NULL;
	for (i = 0; i < len; i++) {
  800421:	83 c3 01             	add    $0x1,%ebx
  800424:	39 5d 84             	cmp    %ebx,-0x7c(%ebp)
  800427:	0f 8f 3a ff ff ff    	jg     800367 <umain+0x327>
			panic("IPC from unexpected environment %08x", whom);
		if (req != NSREQ_INPUT)
			panic("Unexpected IPC %d", req);

		hexdump("input: ", pkt->jp_data, pkt->jp_len);
		cprintf("\n");
  80042d:	c7 04 24 df 35 80 00 	movl   $0x8035df,(%esp)
  800434:	e8 30 03 00 00       	call   800769 <cprintf>
	}
  800439:	e9 7b fe ff ff       	jmp    8002b9 <umain+0x279>
}
  80043e:	81 c4 ac 00 00 00    	add    $0xac,%esp
  800444:	5b                   	pop    %ebx
  800445:	5e                   	pop    %esi
  800446:	5f                   	pop    %edi
  800447:	5d                   	pop    %ebp
  800448:	c3                   	ret    
  800449:	00 00                	add    %al,(%eax)
  80044b:	00 00                	add    %al,(%eax)
  80044d:	00 00                	add    %al,(%eax)
	...

00800450 <timer>:
#include "ns.h"

void
timer(envid_t ns_envid, uint32_t initial_to) {
  800450:	55                   	push   %ebp
  800451:	89 e5                	mov    %esp,%ebp
  800453:	57                   	push   %edi
  800454:	56                   	push   %esi
  800455:	53                   	push   %ebx
  800456:	83 ec 2c             	sub    $0x2c,%esp
  800459:	8b 75 08             	mov    0x8(%ebp),%esi
	uint32_t stop = sys_time_msec() + initial_to;
  80045c:	e8 1b 0f 00 00       	call   80137c <sys_time_msec>
  800461:	89 c3                	mov    %eax,%ebx
  800463:	03 5d 0c             	add    0xc(%ebp),%ebx

	binaryname = "ns_timer";
  800466:	c7 05 00 70 80 00 45 	movl   $0x803645,0x807000
  80046d:	36 80 00 

		ipc_send(ns_envid, NSREQ_TIMER, 0, 0);

		while (1) {
			uint32_t to, whom;
			to = ipc_recv((int32_t *) &whom, 0, 0);
  800470:	8d 7d e4             	lea    -0x1c(%ebp),%edi
  800473:	eb 05                	jmp    80047a <timer+0x2a>

	binaryname = "ns_timer";

	while (1) {
		while(sys_time_msec() < stop) {
			sys_yield();
  800475:	e8 00 12 00 00       	call   80167a <sys_yield>
	uint32_t stop = sys_time_msec() + initial_to;

	binaryname = "ns_timer";

	while (1) {
		while(sys_time_msec() < stop) {
  80047a:	e8 fd 0e 00 00       	call   80137c <sys_time_msec>
  80047f:	39 c3                	cmp    %eax,%ebx
  800481:	77 f2                	ja     800475 <timer+0x25>
			sys_yield();
		}

		ipc_send(ns_envid, NSREQ_TIMER, 0, 0);
  800483:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  80048a:	00 
  80048b:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  800492:	00 
  800493:	c7 44 24 04 0c 00 00 	movl   $0xc,0x4(%esp)
  80049a:	00 
  80049b:	89 34 24             	mov    %esi,(%esp)
  80049e:	e8 5d 16 00 00       	call   801b00 <ipc_send>

		while (1) {
			uint32_t to, whom;
			to = ipc_recv((int32_t *) &whom, 0, 0);
  8004a3:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  8004aa:	00 
  8004ab:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  8004b2:	00 
  8004b3:	89 3c 24             	mov    %edi,(%esp)
  8004b6:	e8 ab 16 00 00       	call   801b66 <ipc_recv>
  8004bb:	89 c3                	mov    %eax,%ebx

			if (whom != ns_envid) {
  8004bd:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8004c0:	39 c6                	cmp    %eax,%esi
  8004c2:	74 12                	je     8004d6 <timer+0x86>
				cprintf("NS TIMER: timer thread got IPC message from env %x not NS\n", whom);
  8004c4:	89 44 24 04          	mov    %eax,0x4(%esp)
  8004c8:	c7 04 24 50 36 80 00 	movl   $0x803650,(%esp)
  8004cf:	e8 95 02 00 00       	call   800769 <cprintf>
				continue;
			}

			stop = sys_time_msec() + to;
			break;
		}
  8004d4:	eb cd                	jmp    8004a3 <timer+0x53>
			if (whom != ns_envid) {
				cprintf("NS TIMER: timer thread got IPC message from env %x not NS\n", whom);
				continue;
			}

			stop = sys_time_msec() + to;
  8004d6:	e8 a1 0e 00 00       	call   80137c <sys_time_msec>
  8004db:	8d 1c 18             	lea    (%eax,%ebx,1),%ebx
  8004de:	66 90                	xchg   %ax,%ax
  8004e0:	eb 98                	jmp    80047a <timer+0x2a>
	...

008004f0 <input>:

extern union Nsipc nsipcbuf;

void
input(envid_t ns_envid)
{
  8004f0:	55                   	push   %ebp
  8004f1:	89 e5                	mov    %esp,%ebp
  8004f3:	53                   	push   %ebx
  8004f4:	83 ec 14             	sub    $0x14,%esp
  8004f7:	8b 5d 08             	mov    0x8(%ebp),%ebx
	binaryname = "ns_input";
  8004fa:	c7 05 00 70 80 00 8b 	movl   $0x80368b,0x807000
  800501:	36 80 00 
	int len;

	while (1)
	{

		if (sys_page_alloc(0, &nsipcbuf, PTE_U | PTE_P | PTE_W) < 0)
  800504:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  80050b:	00 
  80050c:	c7 44 24 04 00 60 80 	movl   $0x806000,0x4(%esp)
  800513:	00 
  800514:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80051b:	e8 fb 10 00 00       	call   80161b <sys_page_alloc>
  800520:	85 c0                	test   %eax,%eax
  800522:	79 0e                	jns    800532 <input+0x42>
		{
			cprintf("\n input.c: error in sys_page_alloc");
  800524:	c7 04 24 b0 36 80 00 	movl   $0x8036b0,(%esp)
  80052b:	e8 39 02 00 00       	call   800769 <cprintf>
			continue;
  800530:	eb d2                	jmp    800504 <input+0x14>
		}
		len = sys_receive_packet(nsipcbuf.pkt.jp_data);
  800532:	c7 04 24 04 60 80 00 	movl   $0x806004,(%esp)
  800539:	e8 ab 0d 00 00       	call   8012e9 <sys_receive_packet>
		if (len < 0)
  80053e:	85 c0                	test   %eax,%eax
  800540:	79 13                	jns    800555 <input+0x65>
		{
			// there was an error in sys_receive_packet, print the message and continue
			cprintf("\n input.c: error in receive");	
  800542:	c7 04 24 94 36 80 00 	movl   $0x803694,(%esp)
  800549:	e8 1b 02 00 00       	call   800769 <cprintf>
			sys_yield();
  80054e:	e8 27 11 00 00       	call   80167a <sys_yield>
			continue;
  800553:	eb af                	jmp    800504 <input+0x14>
		}
		else if (len == 0)
  800555:	85 c0                	test   %eax,%eax
  800557:	75 0e                	jne    800567 <input+0x77>
		{
			// nothing was received, continue
			sys_yield();
  800559:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  800560:	e8 15 11 00 00       	call   80167a <sys_yield>
			continue;
  800565:	eb 9d                	jmp    800504 <input+0x14>
		}
		else 
		{
			//cprintf("\n input.c: ipc_send");
			nsipcbuf.pkt.jp_len = len;	
  800567:	a3 00 60 80 00       	mov    %eax,0x806000
			ipc_send(ns_envid, NSREQ_INPUT, &nsipcbuf, PTE_P | PTE_U | PTE_W);
  80056c:	c7 44 24 0c 07 00 00 	movl   $0x7,0xc(%esp)
  800573:	00 
  800574:	c7 44 24 08 00 60 80 	movl   $0x806000,0x8(%esp)
  80057b:	00 
  80057c:	c7 44 24 04 0a 00 00 	movl   $0xa,0x4(%esp)
  800583:	00 
  800584:	89 1c 24             	mov    %ebx,(%esp)
  800587:	e8 74 15 00 00       	call   801b00 <ipc_send>
		}
		sys_page_unmap(0, &nsipcbuf);
  80058c:	c7 44 24 04 00 60 80 	movl   $0x806000,0x4(%esp)
  800593:	00 
  800594:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80059b:	e8 bf 0f 00 00       	call   80155f <sys_page_unmap>
  8005a0:	e9 5f ff ff ff       	jmp    800504 <input+0x14>
	...

008005b0 <output>:

extern union Nsipc nsipcbuf;

void
output(envid_t ns_envid)
{
  8005b0:	55                   	push   %ebp
  8005b1:	89 e5                	mov    %esp,%ebp
  8005b3:	57                   	push   %edi
  8005b4:	56                   	push   %esi
  8005b5:	53                   	push   %ebx
  8005b6:	83 ec 2c             	sub    $0x2c,%esp
  8005b9:	8b 7d 08             	mov    0x8(%ebp),%edi
	binaryname = "ns_output";
  8005bc:	c7 05 00 70 80 00 d3 	movl   $0x8036d3,0x807000
  8005c3:	36 80 00 
	uint32_t request;
	int perm;
	while(1)
	{
		perm = 0;
		request = ipc_recv(&from_env, (void*)&nsipcbuf, &perm);
  8005c6:	8d 5d e0             	lea    -0x20(%ebp),%ebx
  8005c9:	8d 75 e4             	lea    -0x1c(%ebp),%esi
	envid_t from_env;
	uint32_t request;
	int perm;
	while(1)
	{
		perm = 0;
  8005cc:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
		request = ipc_recv(&from_env, (void*)&nsipcbuf, &perm);
  8005d3:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8005d7:	c7 44 24 04 00 60 80 	movl   $0x806000,0x4(%esp)
  8005de:	00 
  8005df:	89 34 24             	mov    %esi,(%esp)
  8005e2:	e8 7f 15 00 00       	call   801b66 <ipc_recv>
		if (!(perm & PTE_P))
  8005e7:	f6 45 e0 01          	testb  $0x1,-0x20(%ebp)
  8005eb:	75 0e                	jne    8005fb <output+0x4b>
		{
			cprintf("\n output.c : Page not present! ");
  8005ed:	c7 04 24 e0 36 80 00 	movl   $0x8036e0,(%esp)
  8005f4:	e8 70 01 00 00       	call   800769 <cprintf>
			continue;
  8005f9:	eb d1                	jmp    8005cc <output+0x1c>
		}
		if (from_env != ns_envid)
  8005fb:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
  8005fe:	74 0e                	je     80060e <output+0x5e>
		{
			cprintf("\n output.c : Request received from bogus environment! ");
  800600:	c7 04 24 00 37 80 00 	movl   $0x803700,(%esp)
  800607:	e8 5d 01 00 00       	call   800769 <cprintf>
			continue;
  80060c:	eb be                	jmp    8005cc <output+0x1c>
		}
		if (request == NSREQ_OUTPUT)
  80060e:	83 f8 0b             	cmp    $0xb,%eax
  800611:	75 17                	jne    80062a <output+0x7a>
		{	
			sys_transmit_packet(nsipcbuf.pkt.jp_data, nsipcbuf.pkt.jp_len);
  800613:	a1 00 60 80 00       	mov    0x806000,%eax
  800618:	89 44 24 04          	mov    %eax,0x4(%esp)
  80061c:	c7 04 24 04 60 80 00 	movl   $0x806004,(%esp)
  800623:	e8 f6 0c 00 00       	call   80131e <sys_transmit_packet>
  800628:	eb a2                	jmp    8005cc <output+0x1c>
		}
		else
			cprintf("\n output.c : Invalid request received! ");
  80062a:	c7 04 24 38 37 80 00 	movl   $0x803738,(%esp)
  800631:	e8 33 01 00 00       	call   800769 <cprintf>
  800636:	eb 94                	jmp    8005cc <output+0x1c>

00800638 <libmain>:
volatile struct Env *env;
char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  800638:	55                   	push   %ebp
  800639:	89 e5                	mov    %esp,%ebp
  80063b:	83 ec 18             	sub    $0x18,%esp
  80063e:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  800641:	89 75 fc             	mov    %esi,-0x4(%ebp)
  800644:	8b 75 08             	mov    0x8(%ebp),%esi
  800647:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	// set env to point at our env structure in envs[].
	// LAB 3b: Your code here.
	// Code added by Swastika / Sandeep	
	envid_t envid = sys_getenvid();
  80064a:	e8 5f 10 00 00       	call   8016ae <sys_getenvid>
	env = &envs[ENVX(envid)];
  80064f:	25 ff 03 00 00       	and    $0x3ff,%eax
  800654:	6b c0 7c             	imul   $0x7c,%eax,%eax
  800657:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  80065c:	a3 8c 70 80 00       	mov    %eax,0x80708c

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800661:	85 f6                	test   %esi,%esi
  800663:	7e 07                	jle    80066c <libmain+0x34>
		binaryname = argv[0];
  800665:	8b 03                	mov    (%ebx),%eax
  800667:	a3 00 70 80 00       	mov    %eax,0x807000

	// call user main routine
	umain(argc, argv);
  80066c:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  800670:	89 34 24             	mov    %esi,(%esp)
  800673:	e8 c8 f9 ff ff       	call   800040 <umain>

	// exit gracefully
	exit();
  800678:	e8 0b 00 00 00       	call   800688 <exit>
}
  80067d:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  800680:	8b 75 fc             	mov    -0x4(%ebp),%esi
  800683:	89 ec                	mov    %ebp,%esp
  800685:	5d                   	pop    %ebp
  800686:	c3                   	ret    
	...

00800688 <exit>:
#include <inc/lib.h>

void
exit(void)
{
  800688:	55                   	push   %ebp
  800689:	89 e5                	mov    %esp,%ebp
  80068b:	83 ec 18             	sub    $0x18,%esp
	close_all();
  80068e:	e8 18 1a 00 00       	call   8020ab <close_all>
	sys_env_destroy(0);
  800693:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80069a:	e8 43 10 00 00       	call   8016e2 <sys_env_destroy>
}
  80069f:	c9                   	leave  
  8006a0:	c3                   	ret    
  8006a1:	00 00                	add    %al,(%eax)
	...

008006a4 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  8006a4:	55                   	push   %ebp
  8006a5:	89 e5                	mov    %esp,%ebp
  8006a7:	53                   	push   %ebx
  8006a8:	83 ec 14             	sub    $0x14,%esp
 * Panic is called on unresolvable fatal errors.
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
  8006ab:	8d 5d 14             	lea    0x14(%ebp),%ebx
	va_list ap;

	va_start(ap, fmt);

	// Print the panic message
	if (argv0)
  8006ae:	a1 90 70 80 00       	mov    0x807090,%eax
  8006b3:	85 c0                	test   %eax,%eax
  8006b5:	74 10                	je     8006c7 <_panic+0x23>
		cprintf("%s: ", argv0);
  8006b7:	89 44 24 04          	mov    %eax,0x4(%esp)
  8006bb:	c7 04 24 77 37 80 00 	movl   $0x803777,(%esp)
  8006c2:	e8 a2 00 00 00       	call   800769 <cprintf>
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  8006c7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8006ca:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8006ce:	8b 45 08             	mov    0x8(%ebp),%eax
  8006d1:	89 44 24 08          	mov    %eax,0x8(%esp)
  8006d5:	a1 00 70 80 00       	mov    0x807000,%eax
  8006da:	89 44 24 04          	mov    %eax,0x4(%esp)
  8006de:	c7 04 24 7c 37 80 00 	movl   $0x80377c,(%esp)
  8006e5:	e8 7f 00 00 00       	call   800769 <cprintf>
	vcprintf(fmt, ap);
  8006ea:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8006ee:	8b 45 10             	mov    0x10(%ebp),%eax
  8006f1:	89 04 24             	mov    %eax,(%esp)
  8006f4:	e8 0f 00 00 00       	call   800708 <vcprintf>
	cprintf("\n");
  8006f9:	c7 04 24 df 35 80 00 	movl   $0x8035df,(%esp)
  800700:	e8 64 00 00 00       	call   800769 <cprintf>

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  800705:	cc                   	int3   
  800706:	eb fd                	jmp    800705 <_panic+0x61>

00800708 <vcprintf>:
	b->cnt++;
}

int
vcprintf(const char *fmt, va_list ap)
{
  800708:	55                   	push   %ebp
  800709:	89 e5                	mov    %esp,%ebp
  80070b:	81 ec 28 01 00 00    	sub    $0x128,%esp
	struct printbuf b;

	b.idx = 0;
  800711:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800718:	00 00 00 
	b.cnt = 0;
  80071b:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800722:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  800725:	8b 45 0c             	mov    0xc(%ebp),%eax
  800728:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80072c:	8b 45 08             	mov    0x8(%ebp),%eax
  80072f:	89 44 24 08          	mov    %eax,0x8(%esp)
  800733:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800739:	89 44 24 04          	mov    %eax,0x4(%esp)
  80073d:	c7 04 24 83 07 80 00 	movl   $0x800783,(%esp)
  800744:	e8 d4 01 00 00       	call   80091d <vprintfmt>
	sys_cputs(b.buf, b.idx);
  800749:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
  80074f:	89 44 24 04          	mov    %eax,0x4(%esp)
  800753:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  800759:	89 04 24             	mov    %eax,(%esp)
  80075c:	e8 bf 0a 00 00       	call   801220 <sys_cputs>

	return b.cnt;
}
  800761:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  800767:	c9                   	leave  
  800768:	c3                   	ret    

00800769 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  800769:	55                   	push   %ebp
  80076a:	89 e5                	mov    %esp,%ebp
  80076c:	83 ec 18             	sub    $0x18,%esp

	return b.cnt;
}

int
cprintf(const char *fmt, ...)
  80076f:	8d 45 0c             	lea    0xc(%ebp),%eax
{
	va_list ap;
	int cnt;

	va_start(ap, fmt);
	cnt = vcprintf(fmt, ap);
  800772:	89 44 24 04          	mov    %eax,0x4(%esp)
  800776:	8b 45 08             	mov    0x8(%ebp),%eax
  800779:	89 04 24             	mov    %eax,(%esp)
  80077c:	e8 87 ff ff ff       	call   800708 <vcprintf>
	va_end(ap);

	return cnt;
}
  800781:	c9                   	leave  
  800782:	c3                   	ret    

00800783 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  800783:	55                   	push   %ebp
  800784:	89 e5                	mov    %esp,%ebp
  800786:	53                   	push   %ebx
  800787:	83 ec 14             	sub    $0x14,%esp
  80078a:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  80078d:	8b 03                	mov    (%ebx),%eax
  80078f:	8b 55 08             	mov    0x8(%ebp),%edx
  800792:	88 54 03 08          	mov    %dl,0x8(%ebx,%eax,1)
  800796:	83 c0 01             	add    $0x1,%eax
  800799:	89 03                	mov    %eax,(%ebx)
	if (b->idx == 256-1) {
  80079b:	3d ff 00 00 00       	cmp    $0xff,%eax
  8007a0:	75 19                	jne    8007bb <putch+0x38>
		sys_cputs(b->buf, b->idx);
  8007a2:	c7 44 24 04 ff 00 00 	movl   $0xff,0x4(%esp)
  8007a9:	00 
  8007aa:	8d 43 08             	lea    0x8(%ebx),%eax
  8007ad:	89 04 24             	mov    %eax,(%esp)
  8007b0:	e8 6b 0a 00 00       	call   801220 <sys_cputs>
		b->idx = 0;
  8007b5:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
	}
	b->cnt++;
  8007bb:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  8007bf:	83 c4 14             	add    $0x14,%esp
  8007c2:	5b                   	pop    %ebx
  8007c3:	5d                   	pop    %ebp
  8007c4:	c3                   	ret    
	...

008007d0 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8007d0:	55                   	push   %ebp
  8007d1:	89 e5                	mov    %esp,%ebp
  8007d3:	57                   	push   %edi
  8007d4:	56                   	push   %esi
  8007d5:	53                   	push   %ebx
  8007d6:	83 ec 4c             	sub    $0x4c,%esp
  8007d9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8007dc:	89 d6                	mov    %edx,%esi
  8007de:	8b 45 08             	mov    0x8(%ebp),%eax
  8007e1:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8007e4:	8b 55 0c             	mov    0xc(%ebp),%edx
  8007e7:	89 55 e0             	mov    %edx,-0x20(%ebp)
  8007ea:	8b 45 10             	mov    0x10(%ebp),%eax
  8007ed:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8007f0:	8b 7d 18             	mov    0x18(%ebp),%edi
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8007f3:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8007f6:	b9 00 00 00 00       	mov    $0x0,%ecx
  8007fb:	39 d1                	cmp    %edx,%ecx
  8007fd:	72 15                	jb     800814 <printnum+0x44>
  8007ff:	77 07                	ja     800808 <printnum+0x38>
  800801:	8b 55 d8             	mov    -0x28(%ebp),%edx
  800804:	39 d0                	cmp    %edx,%eax
  800806:	76 0c                	jbe    800814 <printnum+0x44>
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800808:	83 eb 01             	sub    $0x1,%ebx
  80080b:	85 db                	test   %ebx,%ebx
  80080d:	8d 76 00             	lea    0x0(%esi),%esi
  800810:	7f 61                	jg     800873 <printnum+0xa3>
  800812:	eb 70                	jmp    800884 <printnum+0xb4>
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800814:	89 7c 24 10          	mov    %edi,0x10(%esp)
  800818:	83 eb 01             	sub    $0x1,%ebx
  80081b:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  80081f:	89 44 24 08          	mov    %eax,0x8(%esp)
  800823:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  800827:	8b 5c 24 0c          	mov    0xc(%esp),%ebx
  80082b:	89 4d d0             	mov    %ecx,-0x30(%ebp)
  80082e:	89 5d d4             	mov    %ebx,-0x2c(%ebp)
  800831:	8b 5d dc             	mov    -0x24(%ebp),%ebx
  800834:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  800838:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  80083f:	00 
  800840:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800843:	89 04 24             	mov    %eax,(%esp)
  800846:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800849:	89 54 24 04          	mov    %edx,0x4(%esp)
  80084d:	e8 9e 2a 00 00       	call   8032f0 <__udivdi3>
  800852:	8b 4d d0             	mov    -0x30(%ebp),%ecx
  800855:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
  800858:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  80085c:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  800860:	89 04 24             	mov    %eax,(%esp)
  800863:	89 54 24 04          	mov    %edx,0x4(%esp)
  800867:	89 f2                	mov    %esi,%edx
  800869:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80086c:	e8 5f ff ff ff       	call   8007d0 <printnum>
  800871:	eb 11                	jmp    800884 <printnum+0xb4>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800873:	89 74 24 04          	mov    %esi,0x4(%esp)
  800877:	89 3c 24             	mov    %edi,(%esp)
  80087a:	ff 55 e4             	call   *-0x1c(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  80087d:	83 eb 01             	sub    $0x1,%ebx
  800880:	85 db                	test   %ebx,%ebx
  800882:	7f ef                	jg     800873 <printnum+0xa3>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800884:	89 74 24 04          	mov    %esi,0x4(%esp)
  800888:	8b 74 24 04          	mov    0x4(%esp),%esi
  80088c:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80088f:	89 44 24 08          	mov    %eax,0x8(%esp)
  800893:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  80089a:	00 
  80089b:	8b 55 d8             	mov    -0x28(%ebp),%edx
  80089e:	89 14 24             	mov    %edx,(%esp)
  8008a1:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  8008a4:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8008a8:	e8 73 2b 00 00       	call   803420 <__umoddi3>
  8008ad:	89 74 24 04          	mov    %esi,0x4(%esp)
  8008b1:	0f be 80 98 37 80 00 	movsbl 0x803798(%eax),%eax
  8008b8:	89 04 24             	mov    %eax,(%esp)
  8008bb:	ff 55 e4             	call   *-0x1c(%ebp)
}
  8008be:	83 c4 4c             	add    $0x4c,%esp
  8008c1:	5b                   	pop    %ebx
  8008c2:	5e                   	pop    %esi
  8008c3:	5f                   	pop    %edi
  8008c4:	5d                   	pop    %ebp
  8008c5:	c3                   	ret    

008008c6 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  8008c6:	55                   	push   %ebp
  8008c7:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8008c9:	83 fa 01             	cmp    $0x1,%edx
  8008cc:	7e 0e                	jle    8008dc <getuint+0x16>
		return va_arg(*ap, unsigned long long);
  8008ce:	8b 10                	mov    (%eax),%edx
  8008d0:	8d 4a 08             	lea    0x8(%edx),%ecx
  8008d3:	89 08                	mov    %ecx,(%eax)
  8008d5:	8b 02                	mov    (%edx),%eax
  8008d7:	8b 52 04             	mov    0x4(%edx),%edx
  8008da:	eb 22                	jmp    8008fe <getuint+0x38>
	else if (lflag)
  8008dc:	85 d2                	test   %edx,%edx
  8008de:	74 10                	je     8008f0 <getuint+0x2a>
		return va_arg(*ap, unsigned long);
  8008e0:	8b 10                	mov    (%eax),%edx
  8008e2:	8d 4a 04             	lea    0x4(%edx),%ecx
  8008e5:	89 08                	mov    %ecx,(%eax)
  8008e7:	8b 02                	mov    (%edx),%eax
  8008e9:	ba 00 00 00 00       	mov    $0x0,%edx
  8008ee:	eb 0e                	jmp    8008fe <getuint+0x38>
	else
		return va_arg(*ap, unsigned int);
  8008f0:	8b 10                	mov    (%eax),%edx
  8008f2:	8d 4a 04             	lea    0x4(%edx),%ecx
  8008f5:	89 08                	mov    %ecx,(%eax)
  8008f7:	8b 02                	mov    (%edx),%eax
  8008f9:	ba 00 00 00 00       	mov    $0x0,%edx
}
  8008fe:	5d                   	pop    %ebp
  8008ff:	c3                   	ret    

00800900 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800900:	55                   	push   %ebp
  800901:	89 e5                	mov    %esp,%ebp
  800903:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  800906:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  80090a:	8b 10                	mov    (%eax),%edx
  80090c:	3b 50 04             	cmp    0x4(%eax),%edx
  80090f:	73 0a                	jae    80091b <sprintputch+0x1b>
		*b->buf++ = ch;
  800911:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800914:	88 0a                	mov    %cl,(%edx)
  800916:	83 c2 01             	add    $0x1,%edx
  800919:	89 10                	mov    %edx,(%eax)
}
  80091b:	5d                   	pop    %ebp
  80091c:	c3                   	ret    

0080091d <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  80091d:	55                   	push   %ebp
  80091e:	89 e5                	mov    %esp,%ebp
  800920:	57                   	push   %edi
  800921:	56                   	push   %esi
  800922:	53                   	push   %ebx
  800923:	83 ec 5c             	sub    $0x5c,%esp
  800926:	8b 7d 08             	mov    0x8(%ebp),%edi
  800929:	8b 75 0c             	mov    0xc(%ebp),%esi
  80092c:	8b 5d 10             	mov    0x10(%ebp),%ebx
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  80092f:	c7 45 c8 ff ff ff ff 	movl   $0xffffffff,-0x38(%ebp)
  800936:	eb 11                	jmp    800949 <vprintfmt+0x2c>
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
  800938:	85 c0                	test   %eax,%eax
  80093a:	0f 84 ec 03 00 00    	je     800d2c <vprintfmt+0x40f>
				return;
			putch(ch, putdat);
  800940:	89 74 24 04          	mov    %esi,0x4(%esp)
  800944:	89 04 24             	mov    %eax,(%esp)
  800947:	ff d7                	call   *%edi
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800949:	0f b6 03             	movzbl (%ebx),%eax
  80094c:	83 c3 01             	add    $0x1,%ebx
  80094f:	83 f8 25             	cmp    $0x25,%eax
  800952:	75 e4                	jne    800938 <vprintfmt+0x1b>
  800954:	c6 45 d4 20          	movb   $0x20,-0x2c(%ebp)
  800958:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
  80095f:	c7 45 d0 ff ff ff ff 	movl   $0xffffffff,-0x30(%ebp)
  800966:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
  80096d:	b9 00 00 00 00       	mov    $0x0,%ecx
  800972:	eb 06                	jmp    80097a <vprintfmt+0x5d>
  800974:	c6 45 d4 2d          	movb   $0x2d,-0x2c(%ebp)
  800978:	89 c3                	mov    %eax,%ebx
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80097a:	0f b6 13             	movzbl (%ebx),%edx
  80097d:	0f b6 c2             	movzbl %dl,%eax
  800980:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800983:	8d 43 01             	lea    0x1(%ebx),%eax
  800986:	83 ea 23             	sub    $0x23,%edx
  800989:	80 fa 55             	cmp    $0x55,%dl
  80098c:	0f 87 7d 03 00 00    	ja     800d0f <vprintfmt+0x3f2>
  800992:	0f b6 d2             	movzbl %dl,%edx
  800995:	ff 24 95 e0 38 80 00 	jmp    *0x8038e0(,%edx,4)
  80099c:	c6 45 d4 30          	movb   $0x30,-0x2c(%ebp)
  8009a0:	eb d6                	jmp    800978 <vprintfmt+0x5b>
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
				precision = precision * 10 + ch - '0';
  8009a2:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8009a5:	83 ea 30             	sub    $0x30,%edx
  8009a8:	89 55 d0             	mov    %edx,-0x30(%ebp)
				ch = *fmt;
  8009ab:	0f be 10             	movsbl (%eax),%edx
				if (ch < '0' || ch > '9')
  8009ae:	8d 5a d0             	lea    -0x30(%edx),%ebx
  8009b1:	83 fb 09             	cmp    $0x9,%ebx
  8009b4:	77 4c                	ja     800a02 <vprintfmt+0xe5>
  8009b6:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  8009b9:	8b 4d d0             	mov    -0x30(%ebp),%ecx
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8009bc:	83 c0 01             	add    $0x1,%eax
				precision = precision * 10 + ch - '0';
  8009bf:	8d 0c 89             	lea    (%ecx,%ecx,4),%ecx
  8009c2:	8d 4c 4a d0          	lea    -0x30(%edx,%ecx,2),%ecx
				ch = *fmt;
  8009c6:	0f be 10             	movsbl (%eax),%edx
				if (ch < '0' || ch > '9')
  8009c9:	8d 5a d0             	lea    -0x30(%edx),%ebx
  8009cc:	83 fb 09             	cmp    $0x9,%ebx
  8009cf:	76 eb                	jbe    8009bc <vprintfmt+0x9f>
  8009d1:	89 4d d0             	mov    %ecx,-0x30(%ebp)
  8009d4:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  8009d7:	eb 29                	jmp    800a02 <vprintfmt+0xe5>
					break;
			}
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  8009d9:	8b 55 14             	mov    0x14(%ebp),%edx
  8009dc:	8d 5a 04             	lea    0x4(%edx),%ebx
  8009df:	89 5d 14             	mov    %ebx,0x14(%ebp)
  8009e2:	8b 12                	mov    (%edx),%edx
  8009e4:	89 55 d0             	mov    %edx,-0x30(%ebp)
			goto process_precision;
  8009e7:	eb 19                	jmp    800a02 <vprintfmt+0xe5>

		case '.':
			if (width < 0)
  8009e9:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8009ec:	c1 fa 1f             	sar    $0x1f,%edx
  8009ef:	f7 d2                	not    %edx
  8009f1:	21 55 e4             	and    %edx,-0x1c(%ebp)
  8009f4:	eb 82                	jmp    800978 <vprintfmt+0x5b>
  8009f6:	c7 45 d8 01 00 00 00 	movl   $0x1,-0x28(%ebp)
				width = 0;
			goto reswitch;

		case '#':
			altflag = 1;
			goto reswitch;
  8009fd:	e9 76 ff ff ff       	jmp    800978 <vprintfmt+0x5b>

		process_precision:
			if (width < 0)
  800a02:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800a06:	0f 89 6c ff ff ff    	jns    800978 <vprintfmt+0x5b>
  800a0c:	8b 55 d0             	mov    -0x30(%ebp),%edx
  800a0f:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  800a12:	8b 55 c8             	mov    -0x38(%ebp),%edx
  800a15:	89 55 d0             	mov    %edx,-0x30(%ebp)
  800a18:	e9 5b ff ff ff       	jmp    800978 <vprintfmt+0x5b>
				width = precision, precision = -1;
			goto reswitch;

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800a1d:	83 c1 01             	add    $0x1,%ecx
			goto reswitch;
  800a20:	e9 53 ff ff ff       	jmp    800978 <vprintfmt+0x5b>
  800a25:	89 45 cc             	mov    %eax,-0x34(%ebp)

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800a28:	8b 45 14             	mov    0x14(%ebp),%eax
  800a2b:	8d 50 04             	lea    0x4(%eax),%edx
  800a2e:	89 55 14             	mov    %edx,0x14(%ebp)
  800a31:	89 74 24 04          	mov    %esi,0x4(%esp)
  800a35:	8b 00                	mov    (%eax),%eax
  800a37:	89 04 24             	mov    %eax,(%esp)
  800a3a:	ff d7                	call   *%edi
  800a3c:	8b 5d cc             	mov    -0x34(%ebp),%ebx
			break;
  800a3f:	e9 05 ff ff ff       	jmp    800949 <vprintfmt+0x2c>
  800a44:	89 45 cc             	mov    %eax,-0x34(%ebp)

		// error message
		case 'e':
			err = va_arg(ap, int);
  800a47:	8b 45 14             	mov    0x14(%ebp),%eax
  800a4a:	8d 50 04             	lea    0x4(%eax),%edx
  800a4d:	89 55 14             	mov    %edx,0x14(%ebp)
  800a50:	8b 00                	mov    (%eax),%eax
  800a52:	89 c2                	mov    %eax,%edx
  800a54:	c1 fa 1f             	sar    $0x1f,%edx
  800a57:	31 d0                	xor    %edx,%eax
  800a59:	29 d0                	sub    %edx,%eax
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800a5b:	83 f8 0f             	cmp    $0xf,%eax
  800a5e:	7f 0b                	jg     800a6b <vprintfmt+0x14e>
  800a60:	8b 14 85 40 3a 80 00 	mov    0x803a40(,%eax,4),%edx
  800a67:	85 d2                	test   %edx,%edx
  800a69:	75 20                	jne    800a8b <vprintfmt+0x16e>
				printfmt(putch, putdat, "error %d", err);
  800a6b:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800a6f:	c7 44 24 08 a9 37 80 	movl   $0x8037a9,0x8(%esp)
  800a76:	00 
  800a77:	89 74 24 04          	mov    %esi,0x4(%esp)
  800a7b:	89 3c 24             	mov    %edi,(%esp)
  800a7e:	e8 31 03 00 00       	call   800db4 <printfmt>
  800a83:	8b 5d cc             	mov    -0x34(%ebp),%ebx
		// error message
		case 'e':
			err = va_arg(ap, int);
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800a86:	e9 be fe ff ff       	jmp    800949 <vprintfmt+0x2c>
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800a8b:	89 54 24 0c          	mov    %edx,0xc(%esp)
  800a8f:	c7 44 24 08 a2 3d 80 	movl   $0x803da2,0x8(%esp)
  800a96:	00 
  800a97:	89 74 24 04          	mov    %esi,0x4(%esp)
  800a9b:	89 3c 24             	mov    %edi,(%esp)
  800a9e:	e8 11 03 00 00       	call   800db4 <printfmt>
  800aa3:	8b 5d cc             	mov    -0x34(%ebp),%ebx
  800aa6:	e9 9e fe ff ff       	jmp    800949 <vprintfmt+0x2c>
  800aab:	89 45 cc             	mov    %eax,-0x34(%ebp)
  800aae:	89 c3                	mov    %eax,%ebx
  800ab0:	8b 4d d0             	mov    -0x30(%ebp),%ecx
  800ab3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800ab6:	89 45 c4             	mov    %eax,-0x3c(%ebp)
			break;

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800ab9:	8b 45 14             	mov    0x14(%ebp),%eax
  800abc:	8d 50 04             	lea    0x4(%eax),%edx
  800abf:	89 55 14             	mov    %edx,0x14(%ebp)
  800ac2:	8b 00                	mov    (%eax),%eax
  800ac4:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800ac7:	85 c0                	test   %eax,%eax
  800ac9:	75 07                	jne    800ad2 <vprintfmt+0x1b5>
  800acb:	c7 45 e0 b2 37 80 00 	movl   $0x8037b2,-0x20(%ebp)
				p = "(null)";
			if (width > 0 && padc != '-')
  800ad2:	83 7d c4 00          	cmpl   $0x0,-0x3c(%ebp)
  800ad6:	7e 06                	jle    800ade <vprintfmt+0x1c1>
  800ad8:	80 7d d4 2d          	cmpb   $0x2d,-0x2c(%ebp)
  800adc:	75 13                	jne    800af1 <vprintfmt+0x1d4>
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800ade:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800ae1:	0f be 02             	movsbl (%edx),%eax
  800ae4:	85 c0                	test   %eax,%eax
  800ae6:	0f 85 99 00 00 00    	jne    800b85 <vprintfmt+0x268>
  800aec:	e9 86 00 00 00       	jmp    800b77 <vprintfmt+0x25a>
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800af1:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  800af5:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  800af8:	89 0c 24             	mov    %ecx,(%esp)
  800afb:	e8 fb 02 00 00       	call   800dfb <strnlen>
  800b00:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  800b03:	29 c2                	sub    %eax,%edx
  800b05:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  800b08:	85 d2                	test   %edx,%edx
  800b0a:	7e d2                	jle    800ade <vprintfmt+0x1c1>
					putch(padc, putdat);
  800b0c:	0f be 4d d4          	movsbl -0x2c(%ebp),%ecx
  800b10:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  800b13:	89 5d c4             	mov    %ebx,-0x3c(%ebp)
  800b16:	89 d3                	mov    %edx,%ebx
  800b18:	89 74 24 04          	mov    %esi,0x4(%esp)
  800b1c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800b1f:	89 04 24             	mov    %eax,(%esp)
  800b22:	ff d7                	call   *%edi
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800b24:	83 eb 01             	sub    $0x1,%ebx
  800b27:	85 db                	test   %ebx,%ebx
  800b29:	7f ed                	jg     800b18 <vprintfmt+0x1fb>
  800b2b:	8b 5d c4             	mov    -0x3c(%ebp),%ebx
  800b2e:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  800b35:	eb a7                	jmp    800ade <vprintfmt+0x1c1>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
  800b37:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  800b3b:	74 18                	je     800b55 <vprintfmt+0x238>
  800b3d:	8d 50 e0             	lea    -0x20(%eax),%edx
  800b40:	83 fa 5e             	cmp    $0x5e,%edx
  800b43:	76 10                	jbe    800b55 <vprintfmt+0x238>
					putch('?', putdat);
  800b45:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800b49:	c7 04 24 3f 00 00 00 	movl   $0x3f,(%esp)
  800b50:	ff 55 e0             	call   *-0x20(%ebp)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
  800b53:	eb 0a                	jmp    800b5f <vprintfmt+0x242>
					putch('?', putdat);
				else
					putch(ch, putdat);
  800b55:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800b59:	89 04 24             	mov    %eax,(%esp)
  800b5c:	ff 55 e0             	call   *-0x20(%ebp)
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800b5f:	83 6d e4 01          	subl   $0x1,-0x1c(%ebp)
  800b63:	0f be 03             	movsbl (%ebx),%eax
  800b66:	85 c0                	test   %eax,%eax
  800b68:	74 05                	je     800b6f <vprintfmt+0x252>
  800b6a:	83 c3 01             	add    $0x1,%ebx
  800b6d:	eb 29                	jmp    800b98 <vprintfmt+0x27b>
  800b6f:	89 fe                	mov    %edi,%esi
  800b71:	8b 7d e0             	mov    -0x20(%ebp),%edi
  800b74:	8b 5d d0             	mov    -0x30(%ebp),%ebx
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800b77:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800b7b:	7f 2e                	jg     800bab <vprintfmt+0x28e>
  800b7d:	8b 5d cc             	mov    -0x34(%ebp),%ebx
  800b80:	e9 c4 fd ff ff       	jmp    800949 <vprintfmt+0x2c>
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800b85:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800b88:	83 c2 01             	add    $0x1,%edx
  800b8b:	89 7d e0             	mov    %edi,-0x20(%ebp)
  800b8e:	89 f7                	mov    %esi,%edi
  800b90:	8b 75 d0             	mov    -0x30(%ebp),%esi
  800b93:	89 5d d0             	mov    %ebx,-0x30(%ebp)
  800b96:	89 d3                	mov    %edx,%ebx
  800b98:	85 f6                	test   %esi,%esi
  800b9a:	78 9b                	js     800b37 <vprintfmt+0x21a>
  800b9c:	83 ee 01             	sub    $0x1,%esi
  800b9f:	79 96                	jns    800b37 <vprintfmt+0x21a>
  800ba1:	89 fe                	mov    %edi,%esi
  800ba3:	8b 7d e0             	mov    -0x20(%ebp),%edi
  800ba6:	8b 5d d0             	mov    -0x30(%ebp),%ebx
  800ba9:	eb cc                	jmp    800b77 <vprintfmt+0x25a>
  800bab:	89 5d d8             	mov    %ebx,-0x28(%ebp)
  800bae:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
				putch(' ', putdat);
  800bb1:	89 74 24 04          	mov    %esi,0x4(%esp)
  800bb5:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  800bbc:	ff d7                	call   *%edi
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800bbe:	83 eb 01             	sub    $0x1,%ebx
  800bc1:	85 db                	test   %ebx,%ebx
  800bc3:	7f ec                	jg     800bb1 <vprintfmt+0x294>
  800bc5:	8b 5d d8             	mov    -0x28(%ebp),%ebx
  800bc8:	e9 7c fd ff ff       	jmp    800949 <vprintfmt+0x2c>
  800bcd:	89 45 cc             	mov    %eax,-0x34(%ebp)
// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
	if (lflag >= 2)
  800bd0:	83 f9 01             	cmp    $0x1,%ecx
  800bd3:	7e 16                	jle    800beb <vprintfmt+0x2ce>
		return va_arg(*ap, long long);
  800bd5:	8b 45 14             	mov    0x14(%ebp),%eax
  800bd8:	8d 50 08             	lea    0x8(%eax),%edx
  800bdb:	89 55 14             	mov    %edx,0x14(%ebp)
  800bde:	8b 10                	mov    (%eax),%edx
  800be0:	8b 48 04             	mov    0x4(%eax),%ecx
  800be3:	89 55 d8             	mov    %edx,-0x28(%ebp)
  800be6:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  800be9:	eb 32                	jmp    800c1d <vprintfmt+0x300>
	else if (lflag)
  800beb:	85 c9                	test   %ecx,%ecx
  800bed:	74 18                	je     800c07 <vprintfmt+0x2ea>
		return va_arg(*ap, long);
  800bef:	8b 45 14             	mov    0x14(%ebp),%eax
  800bf2:	8d 50 04             	lea    0x4(%eax),%edx
  800bf5:	89 55 14             	mov    %edx,0x14(%ebp)
  800bf8:	8b 00                	mov    (%eax),%eax
  800bfa:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800bfd:	89 c1                	mov    %eax,%ecx
  800bff:	c1 f9 1f             	sar    $0x1f,%ecx
  800c02:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  800c05:	eb 16                	jmp    800c1d <vprintfmt+0x300>
	else
		return va_arg(*ap, int);
  800c07:	8b 45 14             	mov    0x14(%ebp),%eax
  800c0a:	8d 50 04             	lea    0x4(%eax),%edx
  800c0d:	89 55 14             	mov    %edx,0x14(%ebp)
  800c10:	8b 00                	mov    (%eax),%eax
  800c12:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800c15:	89 c2                	mov    %eax,%edx
  800c17:	c1 fa 1f             	sar    $0x1f,%edx
  800c1a:	89 55 dc             	mov    %edx,-0x24(%ebp)
				putch(' ', putdat);
			break;

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800c1d:	8b 4d d8             	mov    -0x28(%ebp),%ecx
  800c20:	8b 5d dc             	mov    -0x24(%ebp),%ebx
  800c23:	b8 0a 00 00 00       	mov    $0xa,%eax
			if ((long long) num < 0) {
  800c28:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800c2c:	0f 89 9b 00 00 00    	jns    800ccd <vprintfmt+0x3b0>
				putch('-', putdat);
  800c32:	89 74 24 04          	mov    %esi,0x4(%esp)
  800c36:	c7 04 24 2d 00 00 00 	movl   $0x2d,(%esp)
  800c3d:	ff d7                	call   *%edi
				num = -(long long) num;
  800c3f:	8b 4d d8             	mov    -0x28(%ebp),%ecx
  800c42:	8b 5d dc             	mov    -0x24(%ebp),%ebx
  800c45:	f7 d9                	neg    %ecx
  800c47:	83 d3 00             	adc    $0x0,%ebx
  800c4a:	f7 db                	neg    %ebx
  800c4c:	b8 0a 00 00 00       	mov    $0xa,%eax
  800c51:	eb 7a                	jmp    800ccd <vprintfmt+0x3b0>
  800c53:	89 45 cc             	mov    %eax,-0x34(%ebp)
			base = 10;
			goto number;

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800c56:	89 ca                	mov    %ecx,%edx
  800c58:	8d 45 14             	lea    0x14(%ebp),%eax
  800c5b:	e8 66 fc ff ff       	call   8008c6 <getuint>
  800c60:	89 c1                	mov    %eax,%ecx
  800c62:	89 d3                	mov    %edx,%ebx
  800c64:	b8 0a 00 00 00       	mov    $0xa,%eax
			base = 10;
			goto number;
  800c69:	eb 62                	jmp    800ccd <vprintfmt+0x3b0>
  800c6b:	89 45 cc             	mov    %eax,-0x34(%ebp)
		case 'o':
			// Replace this with your code.
			// putch('X', putdat);
			// putch('X', putdat);
			// putch('X', putdat);
			num = getuint(&ap, lflag);
  800c6e:	89 ca                	mov    %ecx,%edx
  800c70:	8d 45 14             	lea    0x14(%ebp),%eax
  800c73:	e8 4e fc ff ff       	call   8008c6 <getuint>
  800c78:	89 c1                	mov    %eax,%ecx
  800c7a:	89 d3                	mov    %edx,%ebx
  800c7c:	b8 08 00 00 00       	mov    $0x8,%eax
			base = 8;
			goto number;
  800c81:	eb 4a                	jmp    800ccd <vprintfmt+0x3b0>
  800c83:	89 45 cc             	mov    %eax,-0x34(%ebp)
			break;

		// pointer
		case 'p':
			putch('0', putdat);
  800c86:	89 74 24 04          	mov    %esi,0x4(%esp)
  800c8a:	c7 04 24 30 00 00 00 	movl   $0x30,(%esp)
  800c91:	ff d7                	call   *%edi
			putch('x', putdat);
  800c93:	89 74 24 04          	mov    %esi,0x4(%esp)
  800c97:	c7 04 24 78 00 00 00 	movl   $0x78,(%esp)
  800c9e:	ff d7                	call   *%edi
			num = (unsigned long long)
  800ca0:	8b 45 14             	mov    0x14(%ebp),%eax
  800ca3:	8d 50 04             	lea    0x4(%eax),%edx
  800ca6:	89 55 14             	mov    %edx,0x14(%ebp)
  800ca9:	8b 08                	mov    (%eax),%ecx
  800cab:	bb 00 00 00 00       	mov    $0x0,%ebx
  800cb0:	b8 10 00 00 00       	mov    $0x10,%eax
				(uintptr_t) va_arg(ap, void *);
			base = 16;
			goto number;
  800cb5:	eb 16                	jmp    800ccd <vprintfmt+0x3b0>
  800cb7:	89 45 cc             	mov    %eax,-0x34(%ebp)

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800cba:	89 ca                	mov    %ecx,%edx
  800cbc:	8d 45 14             	lea    0x14(%ebp),%eax
  800cbf:	e8 02 fc ff ff       	call   8008c6 <getuint>
  800cc4:	89 c1                	mov    %eax,%ecx
  800cc6:	89 d3                	mov    %edx,%ebx
  800cc8:	b8 10 00 00 00       	mov    $0x10,%eax
			base = 16;
		number:
			printnum(putch, putdat, num, base, width, padc);
  800ccd:	0f be 55 d4          	movsbl -0x2c(%ebp),%edx
  800cd1:	89 54 24 10          	mov    %edx,0x10(%esp)
  800cd5:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  800cd8:	89 54 24 0c          	mov    %edx,0xc(%esp)
  800cdc:	89 44 24 08          	mov    %eax,0x8(%esp)
  800ce0:	89 0c 24             	mov    %ecx,(%esp)
  800ce3:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  800ce7:	89 f2                	mov    %esi,%edx
  800ce9:	89 f8                	mov    %edi,%eax
  800ceb:	e8 e0 fa ff ff       	call   8007d0 <printnum>
  800cf0:	8b 5d cc             	mov    -0x34(%ebp),%ebx
			break;
  800cf3:	e9 51 fc ff ff       	jmp    800949 <vprintfmt+0x2c>
  800cf8:	89 45 cc             	mov    %eax,-0x34(%ebp)
  800cfb:	8b 55 e0             	mov    -0x20(%ebp),%edx

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800cfe:	89 74 24 04          	mov    %esi,0x4(%esp)
  800d02:	89 14 24             	mov    %edx,(%esp)
  800d05:	ff d7                	call   *%edi
  800d07:	8b 5d cc             	mov    -0x34(%ebp),%ebx
			break;
  800d0a:	e9 3a fc ff ff       	jmp    800949 <vprintfmt+0x2c>
			
		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800d0f:	89 74 24 04          	mov    %esi,0x4(%esp)
  800d13:	c7 04 24 25 00 00 00 	movl   $0x25,(%esp)
  800d1a:	ff d7                	call   *%edi
			for (fmt--; fmt[-1] != '%'; fmt--)
  800d1c:	8d 43 ff             	lea    -0x1(%ebx),%eax
  800d1f:	80 38 25             	cmpb   $0x25,(%eax)
  800d22:	0f 84 21 fc ff ff    	je     800949 <vprintfmt+0x2c>
  800d28:	89 c3                	mov    %eax,%ebx
  800d2a:	eb f0                	jmp    800d1c <vprintfmt+0x3ff>
				/* do nothing */;
			break;
		}
	}
}
  800d2c:	83 c4 5c             	add    $0x5c,%esp
  800d2f:	5b                   	pop    %ebx
  800d30:	5e                   	pop    %esi
  800d31:	5f                   	pop    %edi
  800d32:	5d                   	pop    %ebp
  800d33:	c3                   	ret    

00800d34 <vsnprintf>:
		*b->buf++ = ch;
}

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800d34:	55                   	push   %ebp
  800d35:	89 e5                	mov    %esp,%ebp
  800d37:	83 ec 28             	sub    $0x28,%esp
  800d3a:	8b 45 08             	mov    0x8(%ebp),%eax
  800d3d:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};

	if (buf == NULL || n < 1)
  800d40:	85 c0                	test   %eax,%eax
  800d42:	74 04                	je     800d48 <vsnprintf+0x14>
  800d44:	85 d2                	test   %edx,%edx
  800d46:	7f 07                	jg     800d4f <vsnprintf+0x1b>
  800d48:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800d4d:	eb 3b                	jmp    800d8a <vsnprintf+0x56>
}

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
	struct sprintbuf b = {buf, buf+n-1, 0};
  800d4f:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800d52:	8d 44 10 ff          	lea    -0x1(%eax,%edx,1),%eax
  800d56:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800d59:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800d60:	8b 45 14             	mov    0x14(%ebp),%eax
  800d63:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800d67:	8b 45 10             	mov    0x10(%ebp),%eax
  800d6a:	89 44 24 08          	mov    %eax,0x8(%esp)
  800d6e:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800d71:	89 44 24 04          	mov    %eax,0x4(%esp)
  800d75:	c7 04 24 00 09 80 00 	movl   $0x800900,(%esp)
  800d7c:	e8 9c fb ff ff       	call   80091d <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  800d81:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800d84:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800d87:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800d8a:	c9                   	leave  
  800d8b:	c3                   	ret    

00800d8c <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800d8c:	55                   	push   %ebp
  800d8d:	89 e5                	mov    %esp,%ebp
  800d8f:	83 ec 18             	sub    $0x18,%esp

	return b.cnt;
}

int
snprintf(char *buf, int n, const char *fmt, ...)
  800d92:	8d 45 14             	lea    0x14(%ebp),%eax
{
	va_list ap;
	int rc;

	va_start(ap, fmt);
	rc = vsnprintf(buf, n, fmt, ap);
  800d95:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800d99:	8b 45 10             	mov    0x10(%ebp),%eax
  800d9c:	89 44 24 08          	mov    %eax,0x8(%esp)
  800da0:	8b 45 0c             	mov    0xc(%ebp),%eax
  800da3:	89 44 24 04          	mov    %eax,0x4(%esp)
  800da7:	8b 45 08             	mov    0x8(%ebp),%eax
  800daa:	89 04 24             	mov    %eax,(%esp)
  800dad:	e8 82 ff ff ff       	call   800d34 <vsnprintf>
	va_end(ap);

	return rc;
}
  800db2:	c9                   	leave  
  800db3:	c3                   	ret    

00800db4 <printfmt>:
	}
}

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800db4:	55                   	push   %ebp
  800db5:	89 e5                	mov    %esp,%ebp
  800db7:	83 ec 18             	sub    $0x18,%esp
		}
	}
}

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
  800dba:	8d 45 14             	lea    0x14(%ebp),%eax
{
	va_list ap;

	va_start(ap, fmt);
	vprintfmt(putch, putdat, fmt, ap);
  800dbd:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800dc1:	8b 45 10             	mov    0x10(%ebp),%eax
  800dc4:	89 44 24 08          	mov    %eax,0x8(%esp)
  800dc8:	8b 45 0c             	mov    0xc(%ebp),%eax
  800dcb:	89 44 24 04          	mov    %eax,0x4(%esp)
  800dcf:	8b 45 08             	mov    0x8(%ebp),%eax
  800dd2:	89 04 24             	mov    %eax,(%esp)
  800dd5:	e8 43 fb ff ff       	call   80091d <vprintfmt>
	va_end(ap);
}
  800dda:	c9                   	leave  
  800ddb:	c3                   	ret    
  800ddc:	00 00                	add    %al,(%eax)
	...

00800de0 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800de0:	55                   	push   %ebp
  800de1:	89 e5                	mov    %esp,%ebp
  800de3:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  800de6:	b8 00 00 00 00       	mov    $0x0,%eax
  800deb:	80 3a 00             	cmpb   $0x0,(%edx)
  800dee:	74 09                	je     800df9 <strlen+0x19>
		n++;
  800df0:	83 c0 01             	add    $0x1,%eax
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800df3:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  800df7:	75 f7                	jne    800df0 <strlen+0x10>
		n++;
	return n;
}
  800df9:	5d                   	pop    %ebp
  800dfa:	c3                   	ret    

00800dfb <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800dfb:	55                   	push   %ebp
  800dfc:	89 e5                	mov    %esp,%ebp
  800dfe:	53                   	push   %ebx
  800dff:	8b 5d 08             	mov    0x8(%ebp),%ebx
  800e02:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800e05:	85 c9                	test   %ecx,%ecx
  800e07:	74 19                	je     800e22 <strnlen+0x27>
  800e09:	80 3b 00             	cmpb   $0x0,(%ebx)
  800e0c:	74 14                	je     800e22 <strnlen+0x27>
  800e0e:	b8 00 00 00 00       	mov    $0x0,%eax
		n++;
  800e13:	83 c0 01             	add    $0x1,%eax
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800e16:	39 c8                	cmp    %ecx,%eax
  800e18:	74 0d                	je     800e27 <strnlen+0x2c>
  800e1a:	80 3c 03 00          	cmpb   $0x0,(%ebx,%eax,1)
  800e1e:	75 f3                	jne    800e13 <strnlen+0x18>
  800e20:	eb 05                	jmp    800e27 <strnlen+0x2c>
  800e22:	b8 00 00 00 00       	mov    $0x0,%eax
		n++;
	return n;
}
  800e27:	5b                   	pop    %ebx
  800e28:	5d                   	pop    %ebp
  800e29:	c3                   	ret    

00800e2a <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800e2a:	55                   	push   %ebp
  800e2b:	89 e5                	mov    %esp,%ebp
  800e2d:	53                   	push   %ebx
  800e2e:	8b 45 08             	mov    0x8(%ebp),%eax
  800e31:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800e34:	ba 00 00 00 00       	mov    $0x0,%edx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  800e39:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
  800e3d:	88 0c 10             	mov    %cl,(%eax,%edx,1)
  800e40:	83 c2 01             	add    $0x1,%edx
  800e43:	84 c9                	test   %cl,%cl
  800e45:	75 f2                	jne    800e39 <strcpy+0xf>
		/* do nothing */;
	return ret;
}
  800e47:	5b                   	pop    %ebx
  800e48:	5d                   	pop    %ebp
  800e49:	c3                   	ret    

00800e4a <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800e4a:	55                   	push   %ebp
  800e4b:	89 e5                	mov    %esp,%ebp
  800e4d:	56                   	push   %esi
  800e4e:	53                   	push   %ebx
  800e4f:	8b 45 08             	mov    0x8(%ebp),%eax
  800e52:	8b 55 0c             	mov    0xc(%ebp),%edx
  800e55:	8b 75 10             	mov    0x10(%ebp),%esi
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800e58:	85 f6                	test   %esi,%esi
  800e5a:	74 18                	je     800e74 <strncpy+0x2a>
  800e5c:	b9 00 00 00 00       	mov    $0x0,%ecx
		*dst++ = *src;
  800e61:	0f b6 1a             	movzbl (%edx),%ebx
  800e64:	88 1c 08             	mov    %bl,(%eax,%ecx,1)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  800e67:	80 3a 01             	cmpb   $0x1,(%edx)
  800e6a:	83 da ff             	sbb    $0xffffffff,%edx
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800e6d:	83 c1 01             	add    $0x1,%ecx
  800e70:	39 ce                	cmp    %ecx,%esi
  800e72:	77 ed                	ja     800e61 <strncpy+0x17>
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
}
  800e74:	5b                   	pop    %ebx
  800e75:	5e                   	pop    %esi
  800e76:	5d                   	pop    %ebp
  800e77:	c3                   	ret    

00800e78 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800e78:	55                   	push   %ebp
  800e79:	89 e5                	mov    %esp,%ebp
  800e7b:	56                   	push   %esi
  800e7c:	53                   	push   %ebx
  800e7d:	8b 75 08             	mov    0x8(%ebp),%esi
  800e80:	8b 55 0c             	mov    0xc(%ebp),%edx
  800e83:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  800e86:	89 f0                	mov    %esi,%eax
  800e88:	85 c9                	test   %ecx,%ecx
  800e8a:	74 27                	je     800eb3 <strlcpy+0x3b>
		while (--size > 0 && *src != '\0')
  800e8c:	83 e9 01             	sub    $0x1,%ecx
  800e8f:	74 1d                	je     800eae <strlcpy+0x36>
  800e91:	0f b6 1a             	movzbl (%edx),%ebx
  800e94:	84 db                	test   %bl,%bl
  800e96:	74 16                	je     800eae <strlcpy+0x36>
			*dst++ = *src++;
  800e98:	88 18                	mov    %bl,(%eax)
  800e9a:	83 c0 01             	add    $0x1,%eax
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800e9d:	83 e9 01             	sub    $0x1,%ecx
  800ea0:	74 0e                	je     800eb0 <strlcpy+0x38>
			*dst++ = *src++;
  800ea2:	83 c2 01             	add    $0x1,%edx
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800ea5:	0f b6 1a             	movzbl (%edx),%ebx
  800ea8:	84 db                	test   %bl,%bl
  800eaa:	75 ec                	jne    800e98 <strlcpy+0x20>
  800eac:	eb 02                	jmp    800eb0 <strlcpy+0x38>
  800eae:	89 f0                	mov    %esi,%eax
			*dst++ = *src++;
		*dst = '\0';
  800eb0:	c6 00 00             	movb   $0x0,(%eax)
  800eb3:	29 f0                	sub    %esi,%eax
	}
	return dst - dst_in;
}
  800eb5:	5b                   	pop    %ebx
  800eb6:	5e                   	pop    %esi
  800eb7:	5d                   	pop    %ebp
  800eb8:	c3                   	ret    

00800eb9 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800eb9:	55                   	push   %ebp
  800eba:	89 e5                	mov    %esp,%ebp
  800ebc:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800ebf:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  800ec2:	0f b6 01             	movzbl (%ecx),%eax
  800ec5:	84 c0                	test   %al,%al
  800ec7:	74 15                	je     800ede <strcmp+0x25>
  800ec9:	3a 02                	cmp    (%edx),%al
  800ecb:	75 11                	jne    800ede <strcmp+0x25>
		p++, q++;
  800ecd:	83 c1 01             	add    $0x1,%ecx
  800ed0:	83 c2 01             	add    $0x1,%edx
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800ed3:	0f b6 01             	movzbl (%ecx),%eax
  800ed6:	84 c0                	test   %al,%al
  800ed8:	74 04                	je     800ede <strcmp+0x25>
  800eda:	3a 02                	cmp    (%edx),%al
  800edc:	74 ef                	je     800ecd <strcmp+0x14>
  800ede:	0f b6 c0             	movzbl %al,%eax
  800ee1:	0f b6 12             	movzbl (%edx),%edx
  800ee4:	29 d0                	sub    %edx,%eax
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
}
  800ee6:	5d                   	pop    %ebp
  800ee7:	c3                   	ret    

00800ee8 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800ee8:	55                   	push   %ebp
  800ee9:	89 e5                	mov    %esp,%ebp
  800eeb:	53                   	push   %ebx
  800eec:	8b 55 08             	mov    0x8(%ebp),%edx
  800eef:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ef2:	8b 45 10             	mov    0x10(%ebp),%eax
	while (n > 0 && *p && *p == *q)
  800ef5:	85 c0                	test   %eax,%eax
  800ef7:	74 23                	je     800f1c <strncmp+0x34>
  800ef9:	0f b6 1a             	movzbl (%edx),%ebx
  800efc:	84 db                	test   %bl,%bl
  800efe:	74 24                	je     800f24 <strncmp+0x3c>
  800f00:	3a 19                	cmp    (%ecx),%bl
  800f02:	75 20                	jne    800f24 <strncmp+0x3c>
  800f04:	83 e8 01             	sub    $0x1,%eax
  800f07:	74 13                	je     800f1c <strncmp+0x34>
		n--, p++, q++;
  800f09:	83 c2 01             	add    $0x1,%edx
  800f0c:	83 c1 01             	add    $0x1,%ecx
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  800f0f:	0f b6 1a             	movzbl (%edx),%ebx
  800f12:	84 db                	test   %bl,%bl
  800f14:	74 0e                	je     800f24 <strncmp+0x3c>
  800f16:	3a 19                	cmp    (%ecx),%bl
  800f18:	74 ea                	je     800f04 <strncmp+0x1c>
  800f1a:	eb 08                	jmp    800f24 <strncmp+0x3c>
  800f1c:	b8 00 00 00 00       	mov    $0x0,%eax
		n--, p++, q++;
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
}
  800f21:	5b                   	pop    %ebx
  800f22:	5d                   	pop    %ebp
  800f23:	c3                   	ret    
	while (n > 0 && *p && *p == *q)
		n--, p++, q++;
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800f24:	0f b6 02             	movzbl (%edx),%eax
  800f27:	0f b6 11             	movzbl (%ecx),%edx
  800f2a:	29 d0                	sub    %edx,%eax
  800f2c:	eb f3                	jmp    800f21 <strncmp+0x39>

00800f2e <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800f2e:	55                   	push   %ebp
  800f2f:	89 e5                	mov    %esp,%ebp
  800f31:	8b 45 08             	mov    0x8(%ebp),%eax
  800f34:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800f38:	0f b6 10             	movzbl (%eax),%edx
  800f3b:	84 d2                	test   %dl,%dl
  800f3d:	74 15                	je     800f54 <strchr+0x26>
		if (*s == c)
  800f3f:	38 ca                	cmp    %cl,%dl
  800f41:	75 07                	jne    800f4a <strchr+0x1c>
  800f43:	eb 14                	jmp    800f59 <strchr+0x2b>
  800f45:	38 ca                	cmp    %cl,%dl
  800f47:	90                   	nop
  800f48:	74 0f                	je     800f59 <strchr+0x2b>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800f4a:	83 c0 01             	add    $0x1,%eax
  800f4d:	0f b6 10             	movzbl (%eax),%edx
  800f50:	84 d2                	test   %dl,%dl
  800f52:	75 f1                	jne    800f45 <strchr+0x17>
  800f54:	b8 00 00 00 00       	mov    $0x0,%eax
		if (*s == c)
			return (char *) s;
	return 0;
}
  800f59:	5d                   	pop    %ebp
  800f5a:	c3                   	ret    

00800f5b <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800f5b:	55                   	push   %ebp
  800f5c:	89 e5                	mov    %esp,%ebp
  800f5e:	8b 45 08             	mov    0x8(%ebp),%eax
  800f61:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800f65:	0f b6 10             	movzbl (%eax),%edx
  800f68:	84 d2                	test   %dl,%dl
  800f6a:	74 18                	je     800f84 <strfind+0x29>
		if (*s == c)
  800f6c:	38 ca                	cmp    %cl,%dl
  800f6e:	75 0a                	jne    800f7a <strfind+0x1f>
  800f70:	eb 12                	jmp    800f84 <strfind+0x29>
  800f72:	38 ca                	cmp    %cl,%dl
  800f74:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  800f78:	74 0a                	je     800f84 <strfind+0x29>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800f7a:	83 c0 01             	add    $0x1,%eax
  800f7d:	0f b6 10             	movzbl (%eax),%edx
  800f80:	84 d2                	test   %dl,%dl
  800f82:	75 ee                	jne    800f72 <strfind+0x17>
		if (*s == c)
			break;
	return (char *) s;
}
  800f84:	5d                   	pop    %ebp
  800f85:	c3                   	ret    

00800f86 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800f86:	55                   	push   %ebp
  800f87:	89 e5                	mov    %esp,%ebp
  800f89:	83 ec 0c             	sub    $0xc,%esp
  800f8c:	89 1c 24             	mov    %ebx,(%esp)
  800f8f:	89 74 24 04          	mov    %esi,0x4(%esp)
  800f93:	89 7c 24 08          	mov    %edi,0x8(%esp)
  800f97:	8b 7d 08             	mov    0x8(%ebp),%edi
  800f9a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f9d:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800fa0:	85 c9                	test   %ecx,%ecx
  800fa2:	74 30                	je     800fd4 <memset+0x4e>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800fa4:	f7 c7 03 00 00 00    	test   $0x3,%edi
  800faa:	75 25                	jne    800fd1 <memset+0x4b>
  800fac:	f6 c1 03             	test   $0x3,%cl
  800faf:	75 20                	jne    800fd1 <memset+0x4b>
		c &= 0xFF;
  800fb1:	0f b6 d0             	movzbl %al,%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800fb4:	89 d3                	mov    %edx,%ebx
  800fb6:	c1 e3 08             	shl    $0x8,%ebx
  800fb9:	89 d6                	mov    %edx,%esi
  800fbb:	c1 e6 18             	shl    $0x18,%esi
  800fbe:	89 d0                	mov    %edx,%eax
  800fc0:	c1 e0 10             	shl    $0x10,%eax
  800fc3:	09 f0                	or     %esi,%eax
  800fc5:	09 d0                	or     %edx,%eax
		asm volatile("cld; rep stosl\n"
  800fc7:	09 d8                	or     %ebx,%eax
  800fc9:	c1 e9 02             	shr    $0x2,%ecx
  800fcc:	fc                   	cld    
  800fcd:	f3 ab                	rep stos %eax,%es:(%edi)
{
	char *p;

	if (n == 0)
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800fcf:	eb 03                	jmp    800fd4 <memset+0x4e>
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800fd1:	fc                   	cld    
  800fd2:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800fd4:	89 f8                	mov    %edi,%eax
  800fd6:	8b 1c 24             	mov    (%esp),%ebx
  800fd9:	8b 74 24 04          	mov    0x4(%esp),%esi
  800fdd:	8b 7c 24 08          	mov    0x8(%esp),%edi
  800fe1:	89 ec                	mov    %ebp,%esp
  800fe3:	5d                   	pop    %ebp
  800fe4:	c3                   	ret    

00800fe5 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800fe5:	55                   	push   %ebp
  800fe6:	89 e5                	mov    %esp,%ebp
  800fe8:	83 ec 08             	sub    $0x8,%esp
  800feb:	89 34 24             	mov    %esi,(%esp)
  800fee:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800ff2:	8b 45 08             	mov    0x8(%ebp),%eax
  800ff5:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;
	
	s = src;
  800ff8:	8b 75 0c             	mov    0xc(%ebp),%esi
	d = dst;
  800ffb:	89 c7                	mov    %eax,%edi
	if (s < d && s + n > d) {
  800ffd:	39 c6                	cmp    %eax,%esi
  800fff:	73 35                	jae    801036 <memmove+0x51>
  801001:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  801004:	39 d0                	cmp    %edx,%eax
  801006:	73 2e                	jae    801036 <memmove+0x51>
		s += n;
		d += n;
  801008:	01 cf                	add    %ecx,%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  80100a:	f6 c2 03             	test   $0x3,%dl
  80100d:	75 1b                	jne    80102a <memmove+0x45>
  80100f:	f7 c7 03 00 00 00    	test   $0x3,%edi
  801015:	75 13                	jne    80102a <memmove+0x45>
  801017:	f6 c1 03             	test   $0x3,%cl
  80101a:	75 0e                	jne    80102a <memmove+0x45>
			asm volatile("std; rep movsl\n"
  80101c:	83 ef 04             	sub    $0x4,%edi
  80101f:	8d 72 fc             	lea    -0x4(%edx),%esi
  801022:	c1 e9 02             	shr    $0x2,%ecx
  801025:	fd                   	std    
  801026:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  801028:	eb 09                	jmp    801033 <memmove+0x4e>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  80102a:	83 ef 01             	sub    $0x1,%edi
  80102d:	8d 72 ff             	lea    -0x1(%edx),%esi
  801030:	fd                   	std    
  801031:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  801033:	fc                   	cld    
	const char *s;
	char *d;
	
	s = src;
	d = dst;
	if (s < d && s + n > d) {
  801034:	eb 20                	jmp    801056 <memmove+0x71>
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  801036:	f7 c6 03 00 00 00    	test   $0x3,%esi
  80103c:	75 15                	jne    801053 <memmove+0x6e>
  80103e:	f7 c7 03 00 00 00    	test   $0x3,%edi
  801044:	75 0d                	jne    801053 <memmove+0x6e>
  801046:	f6 c1 03             	test   $0x3,%cl
  801049:	75 08                	jne    801053 <memmove+0x6e>
			asm volatile("cld; rep movsl\n"
  80104b:	c1 e9 02             	shr    $0x2,%ecx
  80104e:	fc                   	cld    
  80104f:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  801051:	eb 03                	jmp    801056 <memmove+0x71>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  801053:	fc                   	cld    
  801054:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  801056:	8b 34 24             	mov    (%esp),%esi
  801059:	8b 7c 24 04          	mov    0x4(%esp),%edi
  80105d:	89 ec                	mov    %ebp,%esp
  80105f:	5d                   	pop    %ebp
  801060:	c3                   	ret    

00801061 <memcpy>:

/* sigh - gcc emits references to this for structure assignments! */
/* it is *not* prototyped in inc/string.h - do not use directly. */
void *
memcpy(void *dst, void *src, size_t n)
{
  801061:	55                   	push   %ebp
  801062:	89 e5                	mov    %esp,%ebp
  801064:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  801067:	8b 45 10             	mov    0x10(%ebp),%eax
  80106a:	89 44 24 08          	mov    %eax,0x8(%esp)
  80106e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801071:	89 44 24 04          	mov    %eax,0x4(%esp)
  801075:	8b 45 08             	mov    0x8(%ebp),%eax
  801078:	89 04 24             	mov    %eax,(%esp)
  80107b:	e8 65 ff ff ff       	call   800fe5 <memmove>
}
  801080:	c9                   	leave  
  801081:	c3                   	ret    

00801082 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  801082:	55                   	push   %ebp
  801083:	89 e5                	mov    %esp,%ebp
  801085:	57                   	push   %edi
  801086:	56                   	push   %esi
  801087:	53                   	push   %ebx
  801088:	8b 75 08             	mov    0x8(%ebp),%esi
  80108b:	8b 7d 0c             	mov    0xc(%ebp),%edi
  80108e:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  801091:	85 c9                	test   %ecx,%ecx
  801093:	74 36                	je     8010cb <memcmp+0x49>
		if (*s1 != *s2)
  801095:	0f b6 06             	movzbl (%esi),%eax
  801098:	0f b6 1f             	movzbl (%edi),%ebx
  80109b:	38 d8                	cmp    %bl,%al
  80109d:	74 20                	je     8010bf <memcmp+0x3d>
  80109f:	eb 14                	jmp    8010b5 <memcmp+0x33>
  8010a1:	0f b6 44 16 01       	movzbl 0x1(%esi,%edx,1),%eax
  8010a6:	0f b6 5c 17 01       	movzbl 0x1(%edi,%edx,1),%ebx
  8010ab:	83 c2 01             	add    $0x1,%edx
  8010ae:	83 e9 01             	sub    $0x1,%ecx
  8010b1:	38 d8                	cmp    %bl,%al
  8010b3:	74 12                	je     8010c7 <memcmp+0x45>
			return (int) *s1 - (int) *s2;
  8010b5:	0f b6 c0             	movzbl %al,%eax
  8010b8:	0f b6 db             	movzbl %bl,%ebx
  8010bb:	29 d8                	sub    %ebx,%eax
  8010bd:	eb 11                	jmp    8010d0 <memcmp+0x4e>
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  8010bf:	83 e9 01             	sub    $0x1,%ecx
  8010c2:	ba 00 00 00 00       	mov    $0x0,%edx
  8010c7:	85 c9                	test   %ecx,%ecx
  8010c9:	75 d6                	jne    8010a1 <memcmp+0x1f>
  8010cb:	b8 00 00 00 00       	mov    $0x0,%eax
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
}
  8010d0:	5b                   	pop    %ebx
  8010d1:	5e                   	pop    %esi
  8010d2:	5f                   	pop    %edi
  8010d3:	5d                   	pop    %ebp
  8010d4:	c3                   	ret    

008010d5 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  8010d5:	55                   	push   %ebp
  8010d6:	89 e5                	mov    %esp,%ebp
  8010d8:	8b 45 08             	mov    0x8(%ebp),%eax
	const void *ends = (const char *) s + n;
  8010db:	89 c2                	mov    %eax,%edx
  8010dd:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  8010e0:	39 d0                	cmp    %edx,%eax
  8010e2:	73 15                	jae    8010f9 <memfind+0x24>
		if (*(const unsigned char *) s == (unsigned char) c)
  8010e4:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
  8010e8:	38 08                	cmp    %cl,(%eax)
  8010ea:	75 06                	jne    8010f2 <memfind+0x1d>
  8010ec:	eb 0b                	jmp    8010f9 <memfind+0x24>
  8010ee:	38 08                	cmp    %cl,(%eax)
  8010f0:	74 07                	je     8010f9 <memfind+0x24>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  8010f2:	83 c0 01             	add    $0x1,%eax
  8010f5:	39 c2                	cmp    %eax,%edx
  8010f7:	77 f5                	ja     8010ee <memfind+0x19>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
	return (void *) s;
}
  8010f9:	5d                   	pop    %ebp
  8010fa:	c3                   	ret    

008010fb <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  8010fb:	55                   	push   %ebp
  8010fc:	89 e5                	mov    %esp,%ebp
  8010fe:	57                   	push   %edi
  8010ff:	56                   	push   %esi
  801100:	53                   	push   %ebx
  801101:	83 ec 04             	sub    $0x4,%esp
  801104:	8b 55 08             	mov    0x8(%ebp),%edx
  801107:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  80110a:	0f b6 02             	movzbl (%edx),%eax
  80110d:	3c 20                	cmp    $0x20,%al
  80110f:	74 04                	je     801115 <strtol+0x1a>
  801111:	3c 09                	cmp    $0x9,%al
  801113:	75 0e                	jne    801123 <strtol+0x28>
		s++;
  801115:	83 c2 01             	add    $0x1,%edx
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801118:	0f b6 02             	movzbl (%edx),%eax
  80111b:	3c 20                	cmp    $0x20,%al
  80111d:	74 f6                	je     801115 <strtol+0x1a>
  80111f:	3c 09                	cmp    $0x9,%al
  801121:	74 f2                	je     801115 <strtol+0x1a>
		s++;

	// plus/minus sign
	if (*s == '+')
  801123:	3c 2b                	cmp    $0x2b,%al
  801125:	75 0c                	jne    801133 <strtol+0x38>
		s++;
  801127:	83 c2 01             	add    $0x1,%edx
  80112a:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  801131:	eb 15                	jmp    801148 <strtol+0x4d>
	else if (*s == '-')
  801133:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  80113a:	3c 2d                	cmp    $0x2d,%al
  80113c:	75 0a                	jne    801148 <strtol+0x4d>
		s++, neg = 1;
  80113e:	83 c2 01             	add    $0x1,%edx
  801141:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801148:	85 db                	test   %ebx,%ebx
  80114a:	0f 94 c0             	sete   %al
  80114d:	74 05                	je     801154 <strtol+0x59>
  80114f:	83 fb 10             	cmp    $0x10,%ebx
  801152:	75 18                	jne    80116c <strtol+0x71>
  801154:	80 3a 30             	cmpb   $0x30,(%edx)
  801157:	75 13                	jne    80116c <strtol+0x71>
  801159:	80 7a 01 78          	cmpb   $0x78,0x1(%edx)
  80115d:	8d 76 00             	lea    0x0(%esi),%esi
  801160:	75 0a                	jne    80116c <strtol+0x71>
		s += 2, base = 16;
  801162:	83 c2 02             	add    $0x2,%edx
  801165:	bb 10 00 00 00       	mov    $0x10,%ebx
		s++;
	else if (*s == '-')
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  80116a:	eb 15                	jmp    801181 <strtol+0x86>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  80116c:	84 c0                	test   %al,%al
  80116e:	66 90                	xchg   %ax,%ax
  801170:	74 0f                	je     801181 <strtol+0x86>
  801172:	bb 0a 00 00 00       	mov    $0xa,%ebx
  801177:	80 3a 30             	cmpb   $0x30,(%edx)
  80117a:	75 05                	jne    801181 <strtol+0x86>
		s++, base = 8;
  80117c:	83 c2 01             	add    $0x1,%edx
  80117f:	b3 08                	mov    $0x8,%bl
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  801181:	b8 00 00 00 00       	mov    $0x0,%eax
  801186:	89 de                	mov    %ebx,%esi

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  801188:	0f b6 0a             	movzbl (%edx),%ecx
  80118b:	89 cf                	mov    %ecx,%edi
  80118d:	8d 59 d0             	lea    -0x30(%ecx),%ebx
  801190:	80 fb 09             	cmp    $0x9,%bl
  801193:	77 08                	ja     80119d <strtol+0xa2>
			dig = *s - '0';
  801195:	0f be c9             	movsbl %cl,%ecx
  801198:	83 e9 30             	sub    $0x30,%ecx
  80119b:	eb 1e                	jmp    8011bb <strtol+0xc0>
		else if (*s >= 'a' && *s <= 'z')
  80119d:	8d 5f 9f             	lea    -0x61(%edi),%ebx
  8011a0:	80 fb 19             	cmp    $0x19,%bl
  8011a3:	77 08                	ja     8011ad <strtol+0xb2>
			dig = *s - 'a' + 10;
  8011a5:	0f be c9             	movsbl %cl,%ecx
  8011a8:	83 e9 57             	sub    $0x57,%ecx
  8011ab:	eb 0e                	jmp    8011bb <strtol+0xc0>
		else if (*s >= 'A' && *s <= 'Z')
  8011ad:	8d 5f bf             	lea    -0x41(%edi),%ebx
  8011b0:	80 fb 19             	cmp    $0x19,%bl
  8011b3:	77 15                	ja     8011ca <strtol+0xcf>
			dig = *s - 'A' + 10;
  8011b5:	0f be c9             	movsbl %cl,%ecx
  8011b8:	83 e9 37             	sub    $0x37,%ecx
		else
			break;
		if (dig >= base)
  8011bb:	39 f1                	cmp    %esi,%ecx
  8011bd:	7d 0b                	jge    8011ca <strtol+0xcf>
			break;
		s++, val = (val * base) + dig;
  8011bf:	83 c2 01             	add    $0x1,%edx
  8011c2:	0f af c6             	imul   %esi,%eax
  8011c5:	8d 04 01             	lea    (%ecx,%eax,1),%eax
		// we don't properly detect overflow!
	}
  8011c8:	eb be                	jmp    801188 <strtol+0x8d>
  8011ca:	89 c1                	mov    %eax,%ecx

	if (endptr)
  8011cc:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8011d0:	74 05                	je     8011d7 <strtol+0xdc>
		*endptr = (char *) s;
  8011d2:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  8011d5:	89 13                	mov    %edx,(%ebx)
	return (neg ? -val : val);
  8011d7:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8011db:	74 04                	je     8011e1 <strtol+0xe6>
  8011dd:	89 c8                	mov    %ecx,%eax
  8011df:	f7 d8                	neg    %eax
}
  8011e1:	83 c4 04             	add    $0x4,%esp
  8011e4:	5b                   	pop    %ebx
  8011e5:	5e                   	pop    %esi
  8011e6:	5f                   	pop    %edi
  8011e7:	5d                   	pop    %ebp
  8011e8:	c3                   	ret    
  8011e9:	00 00                	add    %al,(%eax)
	...

008011ec <sys_cgetc>:
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}

int
sys_cgetc(void)
{
  8011ec:	55                   	push   %ebp
  8011ed:	89 e5                	mov    %esp,%ebp
  8011ef:	83 ec 0c             	sub    $0xc,%esp
  8011f2:	89 1c 24             	mov    %ebx,(%esp)
  8011f5:	89 74 24 04          	mov    %esi,0x4(%esp)
  8011f9:	89 7c 24 08          	mov    %edi,0x8(%esp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8011fd:	ba 00 00 00 00       	mov    $0x0,%edx
  801202:	b8 01 00 00 00       	mov    $0x1,%eax
  801207:	89 d1                	mov    %edx,%ecx
  801209:	89 d3                	mov    %edx,%ebx
  80120b:	89 d7                	mov    %edx,%edi
  80120d:	89 d6                	mov    %edx,%esi
  80120f:	cd 30                	int    $0x30

int
sys_cgetc(void)
{
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  801211:	8b 1c 24             	mov    (%esp),%ebx
  801214:	8b 74 24 04          	mov    0x4(%esp),%esi
  801218:	8b 7c 24 08          	mov    0x8(%esp),%edi
  80121c:	89 ec                	mov    %ebp,%esp
  80121e:	5d                   	pop    %ebp
  80121f:	c3                   	ret    

00801220 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  801220:	55                   	push   %ebp
  801221:	89 e5                	mov    %esp,%ebp
  801223:	83 ec 0c             	sub    $0xc,%esp
  801226:	89 1c 24             	mov    %ebx,(%esp)
  801229:	89 74 24 04          	mov    %esi,0x4(%esp)
  80122d:	89 7c 24 08          	mov    %edi,0x8(%esp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801231:	b8 00 00 00 00       	mov    $0x0,%eax
  801236:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801239:	8b 55 08             	mov    0x8(%ebp),%edx
  80123c:	89 c3                	mov    %eax,%ebx
  80123e:	89 c7                	mov    %eax,%edi
  801240:	89 c6                	mov    %eax,%esi
  801242:	cd 30                	int    $0x30

void
sys_cputs(const char *s, size_t len)
{
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  801244:	8b 1c 24             	mov    (%esp),%ebx
  801247:	8b 74 24 04          	mov    0x4(%esp),%esi
  80124b:	8b 7c 24 08          	mov    0x8(%esp),%edi
  80124f:	89 ec                	mov    %ebp,%esp
  801251:	5d                   	pop    %ebp
  801252:	c3                   	ret    

00801253 <sys_page_insert>:
{
	return syscall(SYS_page_waste, 0, (uint32_t)p, (uint32_t)n, 0, 0,0);
}
int
sys_page_insert(envid_t envid, void *va, struct Page *p, int perm)
{
  801253:	55                   	push   %ebp
  801254:	89 e5                	mov    %esp,%ebp
  801256:	83 ec 38             	sub    $0x38,%esp
  801259:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  80125c:	89 75 f8             	mov    %esi,-0x8(%ebp)
  80125f:	89 7d fc             	mov    %edi,-0x4(%ebp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801262:	be 00 00 00 00       	mov    $0x0,%esi
  801267:	b8 12 00 00 00       	mov    $0x12,%eax
  80126c:	8b 7d 14             	mov    0x14(%ebp),%edi
  80126f:	8b 5d 10             	mov    0x10(%ebp),%ebx
  801272:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801275:	8b 55 08             	mov    0x8(%ebp),%edx
  801278:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
	
	if(check && ret > 0)
  80127a:	85 c0                	test   %eax,%eax
  80127c:	7e 28                	jle    8012a6 <sys_page_insert+0x53>
		panic("syscall %d returned %d (> 0)", num, ret);
  80127e:	89 44 24 10          	mov    %eax,0x10(%esp)
  801282:	c7 44 24 0c 12 00 00 	movl   $0x12,0xc(%esp)
  801289:	00 
  80128a:	c7 44 24 08 9f 3a 80 	movl   $0x803a9f,0x8(%esp)
  801291:	00 
  801292:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  801299:	00 
  80129a:	c7 04 24 bc 3a 80 00 	movl   $0x803abc,(%esp)
  8012a1:	e8 fe f3 ff ff       	call   8006a4 <_panic>
}
int
sys_page_insert(envid_t envid, void *va, struct Page *p, int perm)
{
	return syscall(SYS_page_insert, 1, envid, (uint32_t) va, (uint32_t)p, perm, 0);
}
  8012a6:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  8012a9:	8b 75 f8             	mov    -0x8(%ebp),%esi
  8012ac:	8b 7d fc             	mov    -0x4(%ebp),%edi
  8012af:	89 ec                	mov    %ebp,%esp
  8012b1:	5d                   	pop    %ebp
  8012b2:	c3                   	ret    

008012b3 <sys_page_waste>:
{
	return (int)syscall(SYS_receive_packet, 0, (uint32_t)buffer, 0,0,0,0);
}

int sys_page_waste(struct Page **p, int n)
{
  8012b3:	55                   	push   %ebp
  8012b4:	89 e5                	mov    %esp,%ebp
  8012b6:	83 ec 0c             	sub    $0xc,%esp
  8012b9:	89 1c 24             	mov    %ebx,(%esp)
  8012bc:	89 74 24 04          	mov    %esi,0x4(%esp)
  8012c0:	89 7c 24 08          	mov    %edi,0x8(%esp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8012c4:	bb 00 00 00 00       	mov    $0x0,%ebx
  8012c9:	b8 11 00 00 00       	mov    $0x11,%eax
  8012ce:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8012d1:	8b 55 08             	mov    0x8(%ebp),%edx
  8012d4:	89 df                	mov    %ebx,%edi
  8012d6:	89 de                	mov    %ebx,%esi
  8012d8:	cd 30                	int    $0x30
}

int sys_page_waste(struct Page **p, int n)
{
	return syscall(SYS_page_waste, 0, (uint32_t)p, (uint32_t)n, 0, 0,0);
}
  8012da:	8b 1c 24             	mov    (%esp),%ebx
  8012dd:	8b 74 24 04          	mov    0x4(%esp),%esi
  8012e1:	8b 7c 24 08          	mov    0x8(%esp),%edi
  8012e5:	89 ec                	mov    %ebp,%esp
  8012e7:	5d                   	pop    %ebp
  8012e8:	c3                   	ret    

008012e9 <sys_receive_packet>:
{
	return (int)syscall(SYS_transmit_packet, 1, (uint32_t)data, len, 0,0,0);
}

int sys_receive_packet(void* buffer)
{
  8012e9:	55                   	push   %ebp
  8012ea:	89 e5                	mov    %esp,%ebp
  8012ec:	83 ec 0c             	sub    $0xc,%esp
  8012ef:	89 1c 24             	mov    %ebx,(%esp)
  8012f2:	89 74 24 04          	mov    %esi,0x4(%esp)
  8012f6:	89 7c 24 08          	mov    %edi,0x8(%esp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8012fa:	b9 00 00 00 00       	mov    $0x0,%ecx
  8012ff:	b8 10 00 00 00       	mov    $0x10,%eax
  801304:	8b 55 08             	mov    0x8(%ebp),%edx
  801307:	89 cb                	mov    %ecx,%ebx
  801309:	89 cf                	mov    %ecx,%edi
  80130b:	89 ce                	mov    %ecx,%esi
  80130d:	cd 30                	int    $0x30
}

int sys_receive_packet(void* buffer)
{
	return (int)syscall(SYS_receive_packet, 0, (uint32_t)buffer, 0,0,0,0);
}
  80130f:	8b 1c 24             	mov    (%esp),%ebx
  801312:	8b 74 24 04          	mov    0x4(%esp),%esi
  801316:	8b 7c 24 08          	mov    0x8(%esp),%edi
  80131a:	89 ec                	mov    %ebp,%esp
  80131c:	5d                   	pop    %ebp
  80131d:	c3                   	ret    

0080131e <sys_transmit_packet>:
{
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0,0);
}

int sys_transmit_packet(void* data, uint32_t len)
{
  80131e:	55                   	push   %ebp
  80131f:	89 e5                	mov    %esp,%ebp
  801321:	83 ec 38             	sub    $0x38,%esp
  801324:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  801327:	89 75 f8             	mov    %esi,-0x8(%ebp)
  80132a:	89 7d fc             	mov    %edi,-0x4(%ebp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80132d:	bb 00 00 00 00       	mov    $0x0,%ebx
  801332:	b8 0f 00 00 00       	mov    $0xf,%eax
  801337:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80133a:	8b 55 08             	mov    0x8(%ebp),%edx
  80133d:	89 df                	mov    %ebx,%edi
  80133f:	89 de                	mov    %ebx,%esi
  801341:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
	
	if(check && ret > 0)
  801343:	85 c0                	test   %eax,%eax
  801345:	7e 28                	jle    80136f <sys_transmit_packet+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  801347:	89 44 24 10          	mov    %eax,0x10(%esp)
  80134b:	c7 44 24 0c 0f 00 00 	movl   $0xf,0xc(%esp)
  801352:	00 
  801353:	c7 44 24 08 9f 3a 80 	movl   $0x803a9f,0x8(%esp)
  80135a:	00 
  80135b:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  801362:	00 
  801363:	c7 04 24 bc 3a 80 00 	movl   $0x803abc,(%esp)
  80136a:	e8 35 f3 ff ff       	call   8006a4 <_panic>
}

int sys_transmit_packet(void* data, uint32_t len)
{
	return (int)syscall(SYS_transmit_packet, 1, (uint32_t)data, len, 0,0,0);
}
  80136f:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  801372:	8b 75 f8             	mov    -0x8(%ebp),%esi
  801375:	8b 7d fc             	mov    -0x4(%ebp),%edi
  801378:	89 ec                	mov    %ebp,%esp
  80137a:	5d                   	pop    %ebp
  80137b:	c3                   	ret    

0080137c <sys_time_msec>:
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}

unsigned int
sys_time_msec(void)
{
  80137c:	55                   	push   %ebp
  80137d:	89 e5                	mov    %esp,%ebp
  80137f:	83 ec 0c             	sub    $0xc,%esp
  801382:	89 1c 24             	mov    %ebx,(%esp)
  801385:	89 74 24 04          	mov    %esi,0x4(%esp)
  801389:	89 7c 24 08          	mov    %edi,0x8(%esp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80138d:	ba 00 00 00 00       	mov    $0x0,%edx
  801392:	b8 0e 00 00 00       	mov    $0xe,%eax
  801397:	89 d1                	mov    %edx,%ecx
  801399:	89 d3                	mov    %edx,%ebx
  80139b:	89 d7                	mov    %edx,%edi
  80139d:	89 d6                	mov    %edx,%esi
  80139f:	cd 30                	int    $0x30

unsigned int
sys_time_msec(void)
{
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0,0);
}
  8013a1:	8b 1c 24             	mov    (%esp),%ebx
  8013a4:	8b 74 24 04          	mov    0x4(%esp),%esi
  8013a8:	8b 7c 24 08          	mov    0x8(%esp),%edi
  8013ac:	89 ec                	mov    %ebp,%esp
  8013ae:	5d                   	pop    %ebp
  8013af:	c3                   	ret    

008013b0 <sys_ipc_recv>:
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}

int
sys_ipc_recv(void *dstva)
{
  8013b0:	55                   	push   %ebp
  8013b1:	89 e5                	mov    %esp,%ebp
  8013b3:	83 ec 38             	sub    $0x38,%esp
  8013b6:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  8013b9:	89 75 f8             	mov    %esi,-0x8(%ebp)
  8013bc:	89 7d fc             	mov    %edi,-0x4(%ebp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8013bf:	b9 00 00 00 00       	mov    $0x0,%ecx
  8013c4:	b8 0d 00 00 00       	mov    $0xd,%eax
  8013c9:	8b 55 08             	mov    0x8(%ebp),%edx
  8013cc:	89 cb                	mov    %ecx,%ebx
  8013ce:	89 cf                	mov    %ecx,%edi
  8013d0:	89 ce                	mov    %ecx,%esi
  8013d2:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
	
	if(check && ret > 0)
  8013d4:	85 c0                	test   %eax,%eax
  8013d6:	7e 28                	jle    801400 <sys_ipc_recv+0x50>
		panic("syscall %d returned %d (> 0)", num, ret);
  8013d8:	89 44 24 10          	mov    %eax,0x10(%esp)
  8013dc:	c7 44 24 0c 0d 00 00 	movl   $0xd,0xc(%esp)
  8013e3:	00 
  8013e4:	c7 44 24 08 9f 3a 80 	movl   $0x803a9f,0x8(%esp)
  8013eb:	00 
  8013ec:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  8013f3:	00 
  8013f4:	c7 04 24 bc 3a 80 00 	movl   $0x803abc,(%esp)
  8013fb:	e8 a4 f2 ff ff       	call   8006a4 <_panic>

int
sys_ipc_recv(void *dstva)
{
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  801400:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  801403:	8b 75 f8             	mov    -0x8(%ebp),%esi
  801406:	8b 7d fc             	mov    -0x4(%ebp),%edi
  801409:	89 ec                	mov    %ebp,%esp
  80140b:	5d                   	pop    %ebp
  80140c:	c3                   	ret    

0080140d <sys_ipc_try_send>:
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  80140d:	55                   	push   %ebp
  80140e:	89 e5                	mov    %esp,%ebp
  801410:	83 ec 0c             	sub    $0xc,%esp
  801413:	89 1c 24             	mov    %ebx,(%esp)
  801416:	89 74 24 04          	mov    %esi,0x4(%esp)
  80141a:	89 7c 24 08          	mov    %edi,0x8(%esp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80141e:	be 00 00 00 00       	mov    $0x0,%esi
  801423:	b8 0c 00 00 00       	mov    $0xc,%eax
  801428:	8b 7d 14             	mov    0x14(%ebp),%edi
  80142b:	8b 5d 10             	mov    0x10(%ebp),%ebx
  80142e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801431:	8b 55 08             	mov    0x8(%ebp),%edx
  801434:	cd 30                	int    $0x30

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  801436:	8b 1c 24             	mov    (%esp),%ebx
  801439:	8b 74 24 04          	mov    0x4(%esp),%esi
  80143d:	8b 7c 24 08          	mov    0x8(%esp),%edi
  801441:	89 ec                	mov    %ebp,%esp
  801443:	5d                   	pop    %ebp
  801444:	c3                   	ret    

00801445 <sys_env_set_pgfault_upcall>:
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  801445:	55                   	push   %ebp
  801446:	89 e5                	mov    %esp,%ebp
  801448:	83 ec 38             	sub    $0x38,%esp
  80144b:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  80144e:	89 75 f8             	mov    %esi,-0x8(%ebp)
  801451:	89 7d fc             	mov    %edi,-0x4(%ebp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801454:	bb 00 00 00 00       	mov    $0x0,%ebx
  801459:	b8 0a 00 00 00       	mov    $0xa,%eax
  80145e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801461:	8b 55 08             	mov    0x8(%ebp),%edx
  801464:	89 df                	mov    %ebx,%edi
  801466:	89 de                	mov    %ebx,%esi
  801468:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
	
	if(check && ret > 0)
  80146a:	85 c0                	test   %eax,%eax
  80146c:	7e 28                	jle    801496 <sys_env_set_pgfault_upcall+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  80146e:	89 44 24 10          	mov    %eax,0x10(%esp)
  801472:	c7 44 24 0c 0a 00 00 	movl   $0xa,0xc(%esp)
  801479:	00 
  80147a:	c7 44 24 08 9f 3a 80 	movl   $0x803a9f,0x8(%esp)
  801481:	00 
  801482:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  801489:	00 
  80148a:	c7 04 24 bc 3a 80 00 	movl   $0x803abc,(%esp)
  801491:	e8 0e f2 ff ff       	call   8006a4 <_panic>

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  801496:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  801499:	8b 75 f8             	mov    -0x8(%ebp),%esi
  80149c:	8b 7d fc             	mov    -0x4(%ebp),%edi
  80149f:	89 ec                	mov    %ebp,%esp
  8014a1:	5d                   	pop    %ebp
  8014a2:	c3                   	ret    

008014a3 <sys_env_set_trapframe>:
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  8014a3:	55                   	push   %ebp
  8014a4:	89 e5                	mov    %esp,%ebp
  8014a6:	83 ec 38             	sub    $0x38,%esp
  8014a9:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  8014ac:	89 75 f8             	mov    %esi,-0x8(%ebp)
  8014af:	89 7d fc             	mov    %edi,-0x4(%ebp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8014b2:	bb 00 00 00 00       	mov    $0x0,%ebx
  8014b7:	b8 09 00 00 00       	mov    $0x9,%eax
  8014bc:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8014bf:	8b 55 08             	mov    0x8(%ebp),%edx
  8014c2:	89 df                	mov    %ebx,%edi
  8014c4:	89 de                	mov    %ebx,%esi
  8014c6:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
	
	if(check && ret > 0)
  8014c8:	85 c0                	test   %eax,%eax
  8014ca:	7e 28                	jle    8014f4 <sys_env_set_trapframe+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  8014cc:	89 44 24 10          	mov    %eax,0x10(%esp)
  8014d0:	c7 44 24 0c 09 00 00 	movl   $0x9,0xc(%esp)
  8014d7:	00 
  8014d8:	c7 44 24 08 9f 3a 80 	movl   $0x803a9f,0x8(%esp)
  8014df:	00 
  8014e0:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  8014e7:	00 
  8014e8:	c7 04 24 bc 3a 80 00 	movl   $0x803abc,(%esp)
  8014ef:	e8 b0 f1 ff ff       	call   8006a4 <_panic>

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  8014f4:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  8014f7:	8b 75 f8             	mov    -0x8(%ebp),%esi
  8014fa:	8b 7d fc             	mov    -0x4(%ebp),%edi
  8014fd:	89 ec                	mov    %ebp,%esp
  8014ff:	5d                   	pop    %ebp
  801500:	c3                   	ret    

00801501 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  801501:	55                   	push   %ebp
  801502:	89 e5                	mov    %esp,%ebp
  801504:	83 ec 38             	sub    $0x38,%esp
  801507:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  80150a:	89 75 f8             	mov    %esi,-0x8(%ebp)
  80150d:	89 7d fc             	mov    %edi,-0x4(%ebp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801510:	bb 00 00 00 00       	mov    $0x0,%ebx
  801515:	b8 08 00 00 00       	mov    $0x8,%eax
  80151a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80151d:	8b 55 08             	mov    0x8(%ebp),%edx
  801520:	89 df                	mov    %ebx,%edi
  801522:	89 de                	mov    %ebx,%esi
  801524:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
	
	if(check && ret > 0)
  801526:	85 c0                	test   %eax,%eax
  801528:	7e 28                	jle    801552 <sys_env_set_status+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  80152a:	89 44 24 10          	mov    %eax,0x10(%esp)
  80152e:	c7 44 24 0c 08 00 00 	movl   $0x8,0xc(%esp)
  801535:	00 
  801536:	c7 44 24 08 9f 3a 80 	movl   $0x803a9f,0x8(%esp)
  80153d:	00 
  80153e:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  801545:	00 
  801546:	c7 04 24 bc 3a 80 00 	movl   $0x803abc,(%esp)
  80154d:	e8 52 f1 ff ff       	call   8006a4 <_panic>

int
sys_env_set_status(envid_t envid, int status)
{
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  801552:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  801555:	8b 75 f8             	mov    -0x8(%ebp),%esi
  801558:	8b 7d fc             	mov    -0x4(%ebp),%edi
  80155b:	89 ec                	mov    %ebp,%esp
  80155d:	5d                   	pop    %ebp
  80155e:	c3                   	ret    

0080155f <sys_page_unmap>:
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}

int
sys_page_unmap(envid_t envid, void *va)
{
  80155f:	55                   	push   %ebp
  801560:	89 e5                	mov    %esp,%ebp
  801562:	83 ec 38             	sub    $0x38,%esp
  801565:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  801568:	89 75 f8             	mov    %esi,-0x8(%ebp)
  80156b:	89 7d fc             	mov    %edi,-0x4(%ebp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80156e:	bb 00 00 00 00       	mov    $0x0,%ebx
  801573:	b8 06 00 00 00       	mov    $0x6,%eax
  801578:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80157b:	8b 55 08             	mov    0x8(%ebp),%edx
  80157e:	89 df                	mov    %ebx,%edi
  801580:	89 de                	mov    %ebx,%esi
  801582:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
	
	if(check && ret > 0)
  801584:	85 c0                	test   %eax,%eax
  801586:	7e 28                	jle    8015b0 <sys_page_unmap+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  801588:	89 44 24 10          	mov    %eax,0x10(%esp)
  80158c:	c7 44 24 0c 06 00 00 	movl   $0x6,0xc(%esp)
  801593:	00 
  801594:	c7 44 24 08 9f 3a 80 	movl   $0x803a9f,0x8(%esp)
  80159b:	00 
  80159c:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  8015a3:	00 
  8015a4:	c7 04 24 bc 3a 80 00 	movl   $0x803abc,(%esp)
  8015ab:	e8 f4 f0 ff ff       	call   8006a4 <_panic>

int
sys_page_unmap(envid_t envid, void *va)
{
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  8015b0:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  8015b3:	8b 75 f8             	mov    -0x8(%ebp),%esi
  8015b6:	8b 7d fc             	mov    -0x4(%ebp),%edi
  8015b9:	89 ec                	mov    %ebp,%esp
  8015bb:	5d                   	pop    %ebp
  8015bc:	c3                   	ret    

008015bd <sys_page_map>:
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  8015bd:	55                   	push   %ebp
  8015be:	89 e5                	mov    %esp,%ebp
  8015c0:	83 ec 38             	sub    $0x38,%esp
  8015c3:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  8015c6:	89 75 f8             	mov    %esi,-0x8(%ebp)
  8015c9:	89 7d fc             	mov    %edi,-0x4(%ebp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8015cc:	b8 05 00 00 00       	mov    $0x5,%eax
  8015d1:	8b 75 18             	mov    0x18(%ebp),%esi
  8015d4:	8b 7d 14             	mov    0x14(%ebp),%edi
  8015d7:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8015da:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8015dd:	8b 55 08             	mov    0x8(%ebp),%edx
  8015e0:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
	
	if(check && ret > 0)
  8015e2:	85 c0                	test   %eax,%eax
  8015e4:	7e 28                	jle    80160e <sys_page_map+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  8015e6:	89 44 24 10          	mov    %eax,0x10(%esp)
  8015ea:	c7 44 24 0c 05 00 00 	movl   $0x5,0xc(%esp)
  8015f1:	00 
  8015f2:	c7 44 24 08 9f 3a 80 	movl   $0x803a9f,0x8(%esp)
  8015f9:	00 
  8015fa:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  801601:	00 
  801602:	c7 04 24 bc 3a 80 00 	movl   $0x803abc,(%esp)
  801609:	e8 96 f0 ff ff       	call   8006a4 <_panic>

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  80160e:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  801611:	8b 75 f8             	mov    -0x8(%ebp),%esi
  801614:	8b 7d fc             	mov    -0x4(%ebp),%edi
  801617:	89 ec                	mov    %ebp,%esp
  801619:	5d                   	pop    %ebp
  80161a:	c3                   	ret    

0080161b <sys_page_alloc>:
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  80161b:	55                   	push   %ebp
  80161c:	89 e5                	mov    %esp,%ebp
  80161e:	83 ec 38             	sub    $0x38,%esp
  801621:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  801624:	89 75 f8             	mov    %esi,-0x8(%ebp)
  801627:	89 7d fc             	mov    %edi,-0x4(%ebp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80162a:	be 00 00 00 00       	mov    $0x0,%esi
  80162f:	b8 04 00 00 00       	mov    $0x4,%eax
  801634:	8b 5d 10             	mov    0x10(%ebp),%ebx
  801637:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80163a:	8b 55 08             	mov    0x8(%ebp),%edx
  80163d:	89 f7                	mov    %esi,%edi
  80163f:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
	
	if(check && ret > 0)
  801641:	85 c0                	test   %eax,%eax
  801643:	7e 28                	jle    80166d <sys_page_alloc+0x52>
		panic("syscall %d returned %d (> 0)", num, ret);
  801645:	89 44 24 10          	mov    %eax,0x10(%esp)
  801649:	c7 44 24 0c 04 00 00 	movl   $0x4,0xc(%esp)
  801650:	00 
  801651:	c7 44 24 08 9f 3a 80 	movl   $0x803a9f,0x8(%esp)
  801658:	00 
  801659:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  801660:	00 
  801661:	c7 04 24 bc 3a 80 00 	movl   $0x803abc,(%esp)
  801668:	e8 37 f0 ff ff       	call   8006a4 <_panic>

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  80166d:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  801670:	8b 75 f8             	mov    -0x8(%ebp),%esi
  801673:	8b 7d fc             	mov    -0x4(%ebp),%edi
  801676:	89 ec                	mov    %ebp,%esp
  801678:	5d                   	pop    %ebp
  801679:	c3                   	ret    

0080167a <sys_yield>:
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}

void
sys_yield(void)
{
  80167a:	55                   	push   %ebp
  80167b:	89 e5                	mov    %esp,%ebp
  80167d:	83 ec 0c             	sub    $0xc,%esp
  801680:	89 1c 24             	mov    %ebx,(%esp)
  801683:	89 74 24 04          	mov    %esi,0x4(%esp)
  801687:	89 7c 24 08          	mov    %edi,0x8(%esp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80168b:	ba 00 00 00 00       	mov    $0x0,%edx
  801690:	b8 0b 00 00 00       	mov    $0xb,%eax
  801695:	89 d1                	mov    %edx,%ecx
  801697:	89 d3                	mov    %edx,%ebx
  801699:	89 d7                	mov    %edx,%edi
  80169b:	89 d6                	mov    %edx,%esi
  80169d:	cd 30                	int    $0x30

void
sys_yield(void)
{
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  80169f:	8b 1c 24             	mov    (%esp),%ebx
  8016a2:	8b 74 24 04          	mov    0x4(%esp),%esi
  8016a6:	8b 7c 24 08          	mov    0x8(%esp),%edi
  8016aa:	89 ec                	mov    %ebp,%esp
  8016ac:	5d                   	pop    %ebp
  8016ad:	c3                   	ret    

008016ae <sys_getenvid>:
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}

envid_t
sys_getenvid(void)
{
  8016ae:	55                   	push   %ebp
  8016af:	89 e5                	mov    %esp,%ebp
  8016b1:	83 ec 0c             	sub    $0xc,%esp
  8016b4:	89 1c 24             	mov    %ebx,(%esp)
  8016b7:	89 74 24 04          	mov    %esi,0x4(%esp)
  8016bb:	89 7c 24 08          	mov    %edi,0x8(%esp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8016bf:	ba 00 00 00 00       	mov    $0x0,%edx
  8016c4:	b8 02 00 00 00       	mov    $0x2,%eax
  8016c9:	89 d1                	mov    %edx,%ecx
  8016cb:	89 d3                	mov    %edx,%ebx
  8016cd:	89 d7                	mov    %edx,%edi
  8016cf:	89 d6                	mov    %edx,%esi
  8016d1:	cd 30                	int    $0x30

envid_t
sys_getenvid(void)
{
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  8016d3:	8b 1c 24             	mov    (%esp),%ebx
  8016d6:	8b 74 24 04          	mov    0x4(%esp),%esi
  8016da:	8b 7c 24 08          	mov    0x8(%esp),%edi
  8016de:	89 ec                	mov    %ebp,%esp
  8016e0:	5d                   	pop    %ebp
  8016e1:	c3                   	ret    

008016e2 <sys_env_destroy>:
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}

int
sys_env_destroy(envid_t envid)
{
  8016e2:	55                   	push   %ebp
  8016e3:	89 e5                	mov    %esp,%ebp
  8016e5:	83 ec 38             	sub    $0x38,%esp
  8016e8:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  8016eb:	89 75 f8             	mov    %esi,-0x8(%ebp)
  8016ee:	89 7d fc             	mov    %edi,-0x4(%ebp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8016f1:	b9 00 00 00 00       	mov    $0x0,%ecx
  8016f6:	b8 03 00 00 00       	mov    $0x3,%eax
  8016fb:	8b 55 08             	mov    0x8(%ebp),%edx
  8016fe:	89 cb                	mov    %ecx,%ebx
  801700:	89 cf                	mov    %ecx,%edi
  801702:	89 ce                	mov    %ecx,%esi
  801704:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
	
	if(check && ret > 0)
  801706:	85 c0                	test   %eax,%eax
  801708:	7e 28                	jle    801732 <sys_env_destroy+0x50>
		panic("syscall %d returned %d (> 0)", num, ret);
  80170a:	89 44 24 10          	mov    %eax,0x10(%esp)
  80170e:	c7 44 24 0c 03 00 00 	movl   $0x3,0xc(%esp)
  801715:	00 
  801716:	c7 44 24 08 9f 3a 80 	movl   $0x803a9f,0x8(%esp)
  80171d:	00 
  80171e:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  801725:	00 
  801726:	c7 04 24 bc 3a 80 00 	movl   $0x803abc,(%esp)
  80172d:	e8 72 ef ff ff       	call   8006a4 <_panic>

int
sys_env_destroy(envid_t envid)
{
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  801732:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  801735:	8b 75 f8             	mov    -0x8(%ebp),%esi
  801738:	8b 7d fc             	mov    -0x4(%ebp),%edi
  80173b:	89 ec                	mov    %ebp,%esp
  80173d:	5d                   	pop    %ebp
  80173e:	c3                   	ret    
	...

00801740 <sfork>:
}

// Challenge!
int
sfork(void)
{
  801740:	55                   	push   %ebp
  801741:	89 e5                	mov    %esp,%ebp
  801743:	83 ec 18             	sub    $0x18,%esp
	panic("sfork not implemented");
  801746:	c7 44 24 08 ca 3a 80 	movl   $0x803aca,0x8(%esp)
  80174d:	00 
  80174e:	c7 44 24 04 f2 00 00 	movl   $0xf2,0x4(%esp)
  801755:	00 
  801756:	c7 04 24 e0 3a 80 00 	movl   $0x803ae0,(%esp)
  80175d:	e8 42 ef ff ff       	call   8006a4 <_panic>

00801762 <pgfault>:
// Custom page fault handler - if faulting page is copy-on-write,
// map in our own private writable copy.
//
static void
pgfault(struct UTrapframe *utf)
{
  801762:	55                   	push   %ebp
  801763:	89 e5                	mov    %esp,%ebp
  801765:	53                   	push   %ebx
  801766:	83 ec 24             	sub    $0x24,%esp
  801769:	8b 45 08             	mov    0x8(%ebp),%eax
	void *addr = (void *) utf->utf_fault_va;
  80176c:	8b 18                	mov    (%eax),%ebx
	uint32_t err = utf->utf_err;
  80176e:	f6 40 04 02          	testb  $0x2,0x4(%eax)
  801772:	75 1c                	jne    801790 <pgfault+0x2e>
	// LAB 4: Your code here.
	if ((err & FEC_WR) != FEC_WR)
	{
		if (debug)
			cprintf("Error caught = %x\n", err);
		panic ("user panic in lib/fork.c - pgfault(): faulting access is not write\n");
  801774:	c7 44 24 08 ec 3a 80 	movl   $0x803aec,0x8(%esp)
  80177b:	00 
  80177c:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  801783:	00 
  801784:	c7 04 24 e0 3a 80 00 	movl   $0x803ae0,(%esp)
  80178b:	e8 14 ef ff ff       	call   8006a4 <_panic>
	}
	pte = vpt[VPN(addr)];
  801790:	89 d8                	mov    %ebx,%eax
  801792:	c1 e8 0c             	shr    $0xc,%eax
  801795:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
	if ((pte & PTE_COW) != PTE_COW)
  80179c:	f6 c4 08             	test   $0x8,%ah
  80179f:	75 1c                	jne    8017bd <pgfault+0x5b>
		panic ("user panic in lib/fork.c - pgfault(): faulting access is not to a COW page\n");
  8017a1:	c7 44 24 08 30 3b 80 	movl   $0x803b30,0x8(%esp)
  8017a8:	00 
  8017a9:	c7 44 24 04 27 00 00 	movl   $0x27,0x4(%esp)
  8017b0:	00 
  8017b1:	c7 04 24 e0 3a 80 00 	movl   $0x803ae0,(%esp)
  8017b8:	e8 e7 ee ff ff       	call   8006a4 <_panic>
	// Hint:
	//   You should make three system calls.
	//   No need to explicitly delete the old page's mapping.

	// LAB 4: Your code here.
	if ((r = sys_page_alloc(0, (void*)PFTEMP, PTE_P | PTE_U | PTE_W)) < 0)
  8017bd:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  8017c4:	00 
  8017c5:	c7 44 24 04 00 f0 7f 	movl   $0x7ff000,0x4(%esp)
  8017cc:	00 
  8017cd:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8017d4:	e8 42 fe ff ff       	call   80161b <sys_page_alloc>
  8017d9:	85 c0                	test   %eax,%eax
  8017db:	79 20                	jns    8017fd <pgfault+0x9b>
		panic ("user panic in lib/fork.c - pgfault(): sys_page_alloc: %e", r);
  8017dd:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8017e1:	c7 44 24 08 7c 3b 80 	movl   $0x803b7c,0x8(%esp)
  8017e8:	00 
  8017e9:	c7 44 24 04 32 00 00 	movl   $0x32,0x4(%esp)
  8017f0:	00 
  8017f1:	c7 04 24 e0 3a 80 00 	movl   $0x803ae0,(%esp)
  8017f8:	e8 a7 ee ff ff       	call   8006a4 <_panic>
	
	memmove((void*)PFTEMP, (void*)ROUNDDOWN(addr,PGSIZE), PGSIZE);
  8017fd:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  801803:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
  80180a:	00 
  80180b:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  80180f:	c7 04 24 00 f0 7f 00 	movl   $0x7ff000,(%esp)
  801816:	e8 ca f7 ff ff       	call   800fe5 <memmove>
		
	if ((r = sys_page_map(0, (void*)PFTEMP, 0, (void*)ROUNDDOWN(addr,PGSIZE), PTE_P | PTE_U | PTE_W)) < 0)	
  80181b:	c7 44 24 10 07 00 00 	movl   $0x7,0x10(%esp)
  801822:	00 
  801823:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  801827:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  80182e:	00 
  80182f:	c7 44 24 04 00 f0 7f 	movl   $0x7ff000,0x4(%esp)
  801836:	00 
  801837:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80183e:	e8 7a fd ff ff       	call   8015bd <sys_page_map>
  801843:	85 c0                	test   %eax,%eax
  801845:	79 20                	jns    801867 <pgfault+0x105>
		panic ("user panic in lib/fork.c - pgfault(): sys_page_map: %e", r);
  801847:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80184b:	c7 44 24 08 b8 3b 80 	movl   $0x803bb8,0x8(%esp)
  801852:	00 
  801853:	c7 44 24 04 37 00 00 	movl   $0x37,0x4(%esp)
  80185a:	00 
  80185b:	c7 04 24 e0 3a 80 00 	movl   $0x803ae0,(%esp)
  801862:	e8 3d ee ff ff       	call   8006a4 <_panic>
	if ((r = sys_page_unmap(0, (void*)PFTEMP)) < 0)
  801867:	c7 44 24 04 00 f0 7f 	movl   $0x7ff000,0x4(%esp)
  80186e:	00 
  80186f:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801876:	e8 e4 fc ff ff       	call   80155f <sys_page_unmap>
  80187b:	85 c0                	test   %eax,%eax
  80187d:	79 20                	jns    80189f <pgfault+0x13d>
		panic ("user panic in lib/fork.c - pgfault(): sys_page_unmap: %e", r);
  80187f:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801883:	c7 44 24 08 f0 3b 80 	movl   $0x803bf0,0x8(%esp)
  80188a:	00 
  80188b:	c7 44 24 04 39 00 00 	movl   $0x39,0x4(%esp)
  801892:	00 
  801893:	c7 04 24 e0 3a 80 00 	movl   $0x803ae0,(%esp)
  80189a:	e8 05 ee ff ff       	call   8006a4 <_panic>
	// panic("pgfault not implemented");
}
  80189f:	83 c4 24             	add    $0x24,%esp
  8018a2:	5b                   	pop    %ebx
  8018a3:	5d                   	pop    %ebp
  8018a4:	c3                   	ret    

008018a5 <fork>:
//   Neither user exception stack should ever be marked copy-on-write,
//   so you must allocate a new page for the child's user exception stack.
//
envid_t
fork(void)
{
  8018a5:	55                   	push   %ebp
  8018a6:	89 e5                	mov    %esp,%ebp
  8018a8:	57                   	push   %edi
  8018a9:	56                   	push   %esi
  8018aa:	53                   	push   %ebx
  8018ab:	83 ec 3c             	sub    $0x3c,%esp
	int r;
	uint32_t pde_x, pte_x, vpn;	// page directory index, page table index and page number
	

	// Set up our page fault handler appropriately.
	set_pgfault_handler(pgfault);
  8018ae:	c7 04 24 62 17 80 00 	movl   $0x801762,(%esp)
  8018b5:	e8 12 16 00 00       	call   802ecc <set_pgfault_handler>
static __inline envid_t sys_exofork(void) __attribute__((always_inline));
static __inline envid_t
sys_exofork(void)
{
	envid_t ret;
	__asm __volatile("int %2"
  8018ba:	ba 07 00 00 00       	mov    $0x7,%edx
  8018bf:	89 d0                	mov    %edx,%eax
  8018c1:	cd 30                	int    $0x30
  8018c3:	89 45 e0             	mov    %eax,-0x20(%ebp)
		cprintf("\n After set_pgfaulthandler()\n");
	// Create a child.
	child_envid = sys_exofork();
	if (debug)
		cprintf("\n After exofork()\n");
	if (child_envid < 0)
  8018c6:	85 c0                	test   %eax,%eax
  8018c8:	0f 88 21 02 00 00    	js     801aef <fork+0x24a>
	if (child_envid == 0)
	{
		if (debug)
			cprintf("\n After child_envid == 0\n");
		env = &envs[ENVX(sys_getenvid())];
		return 0;
  8018ce:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
		return child_envid;
	if (debug)
		cprintf("\n After child_envid >= 0\n");
		// panic(" panic in lib/fork.c - fork():sys_exofork: %e", child_env);
	// fix "env" in the child process
	if (child_envid == 0)
  8018d5:	85 c0                	test   %eax,%eax
  8018d7:	75 1c                	jne    8018f5 <fork+0x50>
	{
		if (debug)
			cprintf("\n After child_envid == 0\n");
		env = &envs[ENVX(sys_getenvid())];
  8018d9:	e8 d0 fd ff ff       	call   8016ae <sys_getenvid>
  8018de:	25 ff 03 00 00       	and    $0x3ff,%eax
  8018e3:	6b c0 7c             	imul   $0x7c,%eax,%eax
  8018e6:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8018eb:	a3 8c 70 80 00       	mov    %eax,0x80708c
		return 0;
  8018f0:	e9 fa 01 00 00       	jmp    801aef <fork+0x24a>
	// Map the address space except the user exception stack
	if (debug)
		cprintf("\n After child_envid > 0\n");
	for (pde_x = VPD(0); pde_x < VPD(UTOP); pde_x++)
	{
		if ((vpd[pde_x] & PTE_P) == PTE_P)
  8018f5:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8018f8:	8b 04 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%eax
  8018ff:	a8 01                	test   $0x1,%al
  801901:	0f 84 16 01 00 00    	je     801a1d <fork+0x178>
		{
			for (pte_x = 0; pte_x < NPTENTRIES; pte_x++)
			{
				vpn = (pde_x << (PDXSHIFT - PTXSHIFT)) + pte_x;		//removed hardcoding
  801907:	89 d3                	mov    %edx,%ebx
  801909:	c1 e3 0a             	shl    $0xa,%ebx
  80190c:	89 d7                	mov    %edx,%edi
  80190e:	c1 e7 16             	shl    $0x16,%edi
  801911:	be 00 00 00 00       	mov    $0x0,%esi
				if(((vpt[vpn] & PTE_P) == PTE_P) && (vpn < VPN(UXSTACKTOP - PGSIZE)))
  801916:	8b 04 9d 00 00 40 ef 	mov    -0x10c00000(,%ebx,4),%eax
  80191d:	a8 01                	test   $0x1,%al
  80191f:	0f 84 e0 00 00 00    	je     801a05 <fork+0x160>
  801925:	81 fb fe eb 0e 00    	cmp    $0xeebfe,%ebx
  80192b:	0f 87 d4 00 00 00    	ja     801a05 <fork+0x160>
	
	// LAB 4: Your code here.
	if (debug)
		cprintf("\n duppage: 1\n");	

	pte_t pte = vpt[pn];
  801931:	8b 14 9d 00 00 40 ef 	mov    -0x10c00000(,%ebx,4),%edx
	int perm = pte & PTE_USER;
  801938:	89 d0                	mov    %edx,%eax
  80193a:	25 07 0e 00 00       	and    $0xe07,%eax
	void *va = (void*) (pn*PGSIZE);	
	if (debug)
		cprintf("\n duppage: 2\n");	
	
	if ((perm & PTE_P) != PTE_P)
  80193f:	f6 c2 01             	test   $0x1,%dl
  801942:	75 1c                	jne    801960 <fork+0xbb>
		panic ("user panic: lib\fork.c: duppage(): page to be duplicated is not PTE_P\n");
  801944:	c7 44 24 08 2c 3c 80 	movl   $0x803c2c,0x8(%esp)
  80194b:	00 
  80194c:	c7 44 24 04 58 00 00 	movl   $0x58,0x4(%esp)
  801953:	00 
  801954:	c7 04 24 e0 3a 80 00 	movl   $0x803ae0,(%esp)
  80195b:	e8 44 ed ff ff       	call   8006a4 <_panic>
	if ((perm & PTE_U) != PTE_U)
  801960:	a8 04                	test   $0x4,%al
  801962:	75 1c                	jne    801980 <fork+0xdb>
		panic ("user panic: lib\fork.c: duppage(): page to be duplicated is not PTE_U\n");
  801964:	c7 44 24 08 74 3c 80 	movl   $0x803c74,0x8(%esp)
  80196b:	00 
  80196c:	c7 44 24 04 5a 00 00 	movl   $0x5a,0x4(%esp)
  801973:	00 
  801974:	c7 04 24 e0 3a 80 00 	movl   $0x803ae0,(%esp)
  80197b:	e8 24 ed ff ff       	call   8006a4 <_panic>
  801980:	89 7d e4             	mov    %edi,-0x1c(%ebp)
	if (debug)
		cprintf("\n duppage: 3\n");	

	// LAB 7: Include PTE_SHARE convention
	if ( !(perm & PTE_SHARE) && (((perm & PTE_W) == PTE_W) || ((perm & PTE_COW) == PTE_COW)))
  801983:	f6 c4 04             	test   $0x4,%ah
  801986:	75 5b                	jne    8019e3 <fork+0x13e>
  801988:	a9 02 08 00 00       	test   $0x802,%eax
  80198d:	74 54                	je     8019e3 <fork+0x13e>
	{
		if (debug)
			cprintf("\n duppage: 4\n");	
		// perm = PTE_P | PTE_U | PTE_COW;	// buggy permissions, removed in LAB 7
		perm &= ~PTE_W;				// remove write from perm
  80198f:	83 e0 fd             	and    $0xfffffffd,%eax
		perm |= PTE_COW;			// add copy-on-write
  801992:	80 cc 08             	or     $0x8,%ah
  801995:	89 45 d8             	mov    %eax,-0x28(%ebp)
		if (debug)
			cprintf("\n duppage: 10\n");	
		if ((r = sys_page_map(0, va, envid, va, perm)) < 0)
  801998:	89 44 24 10          	mov    %eax,0x10(%esp)
  80199c:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8019a0:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8019a3:	89 54 24 08          	mov    %edx,0x8(%esp)
  8019a7:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8019ab:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8019b2:	e8 06 fc ff ff       	call   8015bd <sys_page_map>
  8019b7:	85 c0                	test   %eax,%eax
  8019b9:	78 4a                	js     801a05 <fork+0x160>
			return r;
		if (debug)
			cprintf("\n duppage: 11\n");	
		if ((r = sys_page_map(0, va, 0, va, perm)) < 0)
  8019bb:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8019be:	89 44 24 10          	mov    %eax,0x10(%esp)
  8019c2:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8019c5:	89 54 24 0c          	mov    %edx,0xc(%esp)
  8019c9:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  8019d0:	00 
  8019d1:	89 54 24 04          	mov    %edx,0x4(%esp)
  8019d5:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8019dc:	e8 dc fb ff ff       	call   8015bd <sys_page_map>
  8019e1:	eb 22                	jmp    801a05 <fork+0x160>
	// LAB 7: Include PTE_SHARE convention
	else
	{
		if (debug)
			cprintf("\n duppage: 6\n");	
		if ((r = sys_page_map(0, va, envid, va, perm)) < 0)
  8019e3:	89 44 24 10          	mov    %eax,0x10(%esp)
  8019e7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8019ea:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8019ee:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8019f1:	89 54 24 08          	mov    %edx,0x8(%esp)
  8019f5:	89 44 24 04          	mov    %eax,0x4(%esp)
  8019f9:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801a00:	e8 b8 fb ff ff       	call   8015bd <sys_page_map>
		cprintf("\n After child_envid > 0\n");
	for (pde_x = VPD(0); pde_x < VPD(UTOP); pde_x++)
	{
		if ((vpd[pde_x] & PTE_P) == PTE_P)
		{
			for (pte_x = 0; pte_x < NPTENTRIES; pte_x++)
  801a05:	83 c6 01             	add    $0x1,%esi
  801a08:	83 c3 01             	add    $0x1,%ebx
  801a0b:	81 c7 00 10 00 00    	add    $0x1000,%edi
  801a11:	81 fe 00 04 00 00    	cmp    $0x400,%esi
  801a17:	0f 85 f9 fe ff ff    	jne    801916 <fork+0x71>
	}
	// reached here... we're the parent process
	// Map the address space except the user exception stack
	if (debug)
		cprintf("\n After child_envid > 0\n");
	for (pde_x = VPD(0); pde_x < VPD(UTOP); pde_x++)
  801a1d:	83 45 dc 01          	addl   $0x1,-0x24(%ebp)
  801a21:	81 7d dc bb 03 00 00 	cmpl   $0x3bb,-0x24(%ebp)
  801a28:	0f 85 c7 fe ff ff    	jne    8018f5 <fork+0x50>
	}	
	if (debug)
		cprintf("\n After duppaging()\n");
	// Allocate and copy the use exception stack for the child environment
	// Allocate a page for the stack in the child
	if ((r = sys_page_alloc(child_envid, (void*)(UXSTACKTOP - PGSIZE), PTE_P | PTE_U | PTE_W)) < 0)
  801a2e:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  801a35:	00 
  801a36:	c7 44 24 04 00 f0 bf 	movl   $0xeebff000,0x4(%esp)
  801a3d:	ee 
  801a3e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801a41:	89 04 24             	mov    %eax,(%esp)
  801a44:	e8 d2 fb ff ff       	call   80161b <sys_page_alloc>
  801a49:	85 c0                	test   %eax,%eax
  801a4b:	79 08                	jns    801a55 <fork+0x1b0>
  801a4d:	89 45 e0             	mov    %eax,-0x20(%ebp)
  801a50:	e9 9a 00 00 00       	jmp    801aef <fork+0x24a>
		return r;
	if (debug)
		cprintf("\n After set_pgfaulthandler()\n");
	// Map this page to a free virtual address space in parent
	if ((r = sys_page_map(child_envid, (void*)(UXSTACKTOP - PGSIZE), 0, (void*)UTEMP, PTE_P | PTE_U | PTE_W)) < 0)
  801a55:	c7 44 24 10 07 00 00 	movl   $0x7,0x10(%esp)
  801a5c:	00 
  801a5d:	c7 44 24 0c 00 00 40 	movl   $0x400000,0xc(%esp)
  801a64:	00 
  801a65:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801a6c:	00 
  801a6d:	c7 44 24 04 00 f0 bf 	movl   $0xeebff000,0x4(%esp)
  801a74:	ee 
  801a75:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801a78:	89 14 24             	mov    %edx,(%esp)
  801a7b:	e8 3d fb ff ff       	call   8015bd <sys_page_map>
  801a80:	85 c0                	test   %eax,%eax
  801a82:	79 05                	jns    801a89 <fork+0x1e4>
  801a84:	89 45 e0             	mov    %eax,-0x20(%ebp)
  801a87:	eb 66                	jmp    801aef <fork+0x24a>
		return r;
	if (debug)
		cprintf("\n After sys_page_map()\n");
	// Copy the parent exception stack to the above, i.e. page from child mapped to parent's address space
	memmove((void*)UTEMP, (void*)(UXSTACKTOP - PGSIZE), PGSIZE);
  801a89:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
  801a90:	00 
  801a91:	c7 44 24 04 00 f0 bf 	movl   $0xeebff000,0x4(%esp)
  801a98:	ee 
  801a99:	c7 04 24 00 00 40 00 	movl   $0x400000,(%esp)
  801aa0:	e8 40 f5 ff ff       	call   800fe5 <memmove>
	if (debug)
		cprintf("\n After memmove()\n");
	// Unmap this page from the parent
	sys_page_unmap(0, (void*)UTEMP);
  801aa5:	c7 44 24 04 00 00 40 	movl   $0x400000,0x4(%esp)
  801aac:	00 
  801aad:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801ab4:	e8 a6 fa ff ff       	call   80155f <sys_page_unmap>
	if (debug)
		cprintf("\n After sys_page_unmap()\n");

	// Set up the page fault handler
	if ((r = sys_env_set_pgfault_upcall(child_envid, _pgfault_upcall)) < 0)
  801ab9:	c7 44 24 04 60 2f 80 	movl   $0x802f60,0x4(%esp)
  801ac0:	00 
  801ac1:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801ac4:	89 04 24             	mov    %eax,(%esp)
  801ac7:	e8 79 f9 ff ff       	call   801445 <sys_env_set_pgfault_upcall>
  801acc:	85 c0                	test   %eax,%eax
  801ace:	79 05                	jns    801ad5 <fork+0x230>
  801ad0:	89 45 e0             	mov    %eax,-0x20(%ebp)
  801ad3:	eb 1a                	jmp    801aef <fork+0x24a>
		// panic(" panic in lib/fork.c - fork():sys_env_set_pgfault_upcall: %e", child_env);
	if (debug)
		cprintf("\n After set_upcall()\n");

	// Mark the child runnable
	if ((r = sys_env_set_status(child_envid, ENV_RUNNABLE)) < 0)
  801ad5:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  801adc:	00 
  801add:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801ae0:	89 14 24             	mov    %edx,(%esp)
  801ae3:	e8 19 fa ff ff       	call   801501 <sys_env_set_status>
  801ae8:	85 c0                	test   %eax,%eax
  801aea:	79 03                	jns    801aef <fork+0x24a>
  801aec:	89 45 e0             	mov    %eax,-0x20(%ebp)
	if (debug)
		cprintf("\n After set_status()\n");
	
	return child_envid;
	
}
  801aef:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801af2:	83 c4 3c             	add    $0x3c,%esp
  801af5:	5b                   	pop    %ebx
  801af6:	5e                   	pop    %esi
  801af7:	5f                   	pop    %edi
  801af8:	5d                   	pop    %ebp
  801af9:	c3                   	ret    
  801afa:	00 00                	add    %al,(%eax)
  801afc:	00 00                	add    %al,(%eax)
	...

00801b00 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  801b00:	55                   	push   %ebp
  801b01:	89 e5                	mov    %esp,%ebp
  801b03:	57                   	push   %edi
  801b04:	56                   	push   %esi
  801b05:	53                   	push   %ebx
  801b06:	83 ec 1c             	sub    $0x1c,%esp
  801b09:	8b 7d 0c             	mov    0xc(%ebp),%edi
  801b0c:	8b 5d 10             	mov    0x10(%ebp),%ebx
  801b0f:	8b 75 14             	mov    0x14(%ebp),%esi
	// LAB 4: Your code here.
	int r;
	if (pg == NULL)
  801b12:	85 db                	test   %ebx,%ebx
  801b14:	75 2d                	jne    801b43 <ipc_send+0x43>
  801b16:	bb 00 00 c0 ee       	mov    $0xeec00000,%ebx
  801b1b:	eb 26                	jmp    801b43 <ipc_send+0x43>
		pg = (void*)UTOP;
	while ((r = sys_ipc_try_send(to_env, val, pg, perm)) < 0)
	{
		if(r != -E_IPC_NOT_RECV)
  801b1d:	83 f8 f9             	cmp    $0xfffffff9,%eax
  801b20:	74 1c                	je     801b3e <ipc_send+0x3e>
			panic("Panic in lib ipc.c : ipc_send() \n");
  801b22:	c7 44 24 08 bc 3c 80 	movl   $0x803cbc,0x8(%esp)
  801b29:	00 
  801b2a:	c7 44 24 04 44 00 00 	movl   $0x44,0x4(%esp)
  801b31:	00 
  801b32:	c7 04 24 de 3c 80 00 	movl   $0x803cde,(%esp)
  801b39:	e8 66 eb ff ff       	call   8006a4 <_panic>
		sys_yield();
  801b3e:	e8 37 fb ff ff       	call   80167a <sys_yield>
{
	// LAB 4: Your code here.
	int r;
	if (pg == NULL)
		pg = (void*)UTOP;
	while ((r = sys_ipc_try_send(to_env, val, pg, perm)) < 0)
  801b43:	89 74 24 0c          	mov    %esi,0xc(%esp)
  801b47:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801b4b:	89 7c 24 04          	mov    %edi,0x4(%esp)
  801b4f:	8b 45 08             	mov    0x8(%ebp),%eax
  801b52:	89 04 24             	mov    %eax,(%esp)
  801b55:	e8 b3 f8 ff ff       	call   80140d <sys_ipc_try_send>
  801b5a:	85 c0                	test   %eax,%eax
  801b5c:	78 bf                	js     801b1d <ipc_send+0x1d>
		if(r != -E_IPC_NOT_RECV)
			panic("Panic in lib ipc.c : ipc_send() \n");
		sys_yield();
	}
	//panic("ipc_send not implemented");
}
  801b5e:	83 c4 1c             	add    $0x1c,%esp
  801b61:	5b                   	pop    %ebx
  801b62:	5e                   	pop    %esi
  801b63:	5f                   	pop    %edi
  801b64:	5d                   	pop    %ebp
  801b65:	c3                   	ret    

00801b66 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  801b66:	55                   	push   %ebp
  801b67:	89 e5                	mov    %esp,%ebp
  801b69:	56                   	push   %esi
  801b6a:	53                   	push   %ebx
  801b6b:	83 ec 10             	sub    $0x10,%esp
  801b6e:	8b 5d 08             	mov    0x8(%ebp),%ebx
  801b71:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b74:	8b 75 10             	mov    0x10(%ebp),%esi
	// LAB 4: Your code here.
	int r;

	if (pg == NULL)
  801b77:	85 c0                	test   %eax,%eax
  801b79:	75 05                	jne    801b80 <ipc_recv+0x1a>
  801b7b:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
		pg = (void*)UTOP;
	if ((r = sys_ipc_recv(pg)) < 0)
  801b80:	89 04 24             	mov    %eax,(%esp)
  801b83:	e8 28 f8 ff ff       	call   8013b0 <sys_ipc_recv>
  801b88:	85 c0                	test   %eax,%eax
  801b8a:	79 16                	jns    801ba2 <ipc_recv+0x3c>
	{
		if (from_env_store != NULL)
  801b8c:	85 db                	test   %ebx,%ebx
  801b8e:	74 06                	je     801b96 <ipc_recv+0x30>
			*from_env_store = 0;
  801b90:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
		if(perm_store != NULL)
  801b96:	85 f6                	test   %esi,%esi
  801b98:	74 2c                	je     801bc6 <ipc_recv+0x60>
			*perm_store = 0;
  801b9a:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
  801ba0:	eb 24                	jmp    801bc6 <ipc_recv+0x60>
		return r;
	}
	else
	{	
		if (from_env_store != NULL)
  801ba2:	85 db                	test   %ebx,%ebx
  801ba4:	74 0a                	je     801bb0 <ipc_recv+0x4a>
			*from_env_store = env->env_ipc_from;
  801ba6:	a1 8c 70 80 00       	mov    0x80708c,%eax
  801bab:	8b 40 74             	mov    0x74(%eax),%eax
  801bae:	89 03                	mov    %eax,(%ebx)
		if(perm_store != NULL)
  801bb0:	85 f6                	test   %esi,%esi
  801bb2:	74 0a                	je     801bbe <ipc_recv+0x58>
			*perm_store = env->env_ipc_perm;
  801bb4:	a1 8c 70 80 00       	mov    0x80708c,%eax
  801bb9:	8b 40 78             	mov    0x78(%eax),%eax
  801bbc:	89 06                	mov    %eax,(%esi)
		return env->env_ipc_value;
  801bbe:	a1 8c 70 80 00       	mov    0x80708c,%eax
  801bc3:	8b 40 70             	mov    0x70(%eax),%eax
	}		
	//panic("ipc_recv not implemented");
	//return 0;
}
  801bc6:	83 c4 10             	add    $0x10,%esp
  801bc9:	5b                   	pop    %ebx
  801bca:	5e                   	pop    %esi
  801bcb:	5d                   	pop    %ebp
  801bcc:	c3                   	ret    
  801bcd:	00 00                	add    %al,(%eax)
	...

00801bd0 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  801bd0:	55                   	push   %ebp
  801bd1:	89 e5                	mov    %esp,%ebp
  801bd3:	8b 45 08             	mov    0x8(%ebp),%eax
  801bd6:	05 00 00 00 30       	add    $0x30000000,%eax
  801bdb:	c1 e8 0c             	shr    $0xc,%eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
}
  801bde:	5d                   	pop    %ebp
  801bdf:	c3                   	ret    

00801be0 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  801be0:	55                   	push   %ebp
  801be1:	89 e5                	mov    %esp,%ebp
  801be3:	83 ec 04             	sub    $0x4,%esp
	return INDEX2DATA(fd2num(fd));
  801be6:	8b 45 08             	mov    0x8(%ebp),%eax
  801be9:	89 04 24             	mov    %eax,(%esp)
  801bec:	e8 df ff ff ff       	call   801bd0 <fd2num>
  801bf1:	05 20 00 0d 00       	add    $0xd0020,%eax
  801bf6:	c1 e0 0c             	shl    $0xc,%eax
}
  801bf9:	c9                   	leave  
  801bfa:	c3                   	ret    

00801bfb <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  801bfb:	55                   	push   %ebp
  801bfc:	89 e5                	mov    %esp,%ebp
  801bfe:	57                   	push   %edi
  801bff:	56                   	push   %esi
  801c00:	53                   	push   %ebx
  801c01:	8b 7d 08             	mov    0x8(%ebp),%edi
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((vpd[PDX(fd)] & PTE_P) == 0 || (vpt[VPN(fd)] & PTE_P) == 0) {
  801c04:	a1 00 dd 7b ef       	mov    0xef7bdd00,%eax
  801c09:	a8 01                	test   $0x1,%al
  801c0b:	74 36                	je     801c43 <fd_alloc+0x48>
  801c0d:	a1 00 00 74 ef       	mov    0xef740000,%eax
  801c12:	a8 01                	test   $0x1,%al
  801c14:	74 2d                	je     801c43 <fd_alloc+0x48>
  801c16:	b8 00 10 00 d0       	mov    $0xd0001000,%eax
  801c1b:	b9 00 d0 7b ef       	mov    $0xef7bd000,%ecx
  801c20:	be 00 00 40 ef       	mov    $0xef400000,%esi
  801c25:	89 c3                	mov    %eax,%ebx
  801c27:	89 c2                	mov    %eax,%edx
  801c29:	c1 ea 16             	shr    $0x16,%edx
  801c2c:	8b 14 91             	mov    (%ecx,%edx,4),%edx
  801c2f:	f6 c2 01             	test   $0x1,%dl
  801c32:	74 14                	je     801c48 <fd_alloc+0x4d>
  801c34:	89 c2                	mov    %eax,%edx
  801c36:	c1 ea 0c             	shr    $0xc,%edx
  801c39:	8b 14 96             	mov    (%esi,%edx,4),%edx
  801c3c:	f6 c2 01             	test   $0x1,%dl
  801c3f:	75 10                	jne    801c51 <fd_alloc+0x56>
  801c41:	eb 05                	jmp    801c48 <fd_alloc+0x4d>
  801c43:	bb 00 00 00 d0       	mov    $0xd0000000,%ebx
			*fd_store = fd;
  801c48:	89 1f                	mov    %ebx,(%edi)
  801c4a:	b8 00 00 00 00       	mov    $0x0,%eax
			return 0;
  801c4f:	eb 17                	jmp    801c68 <fd_alloc+0x6d>
  801c51:	05 00 10 00 00       	add    $0x1000,%eax
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  801c56:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  801c5b:	75 c8                	jne    801c25 <fd_alloc+0x2a>
		if ((vpd[PDX(fd)] & PTE_P) == 0 || (vpt[VPN(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  801c5d:	c7 07 00 00 00 00    	movl   $0x0,(%edi)
  801c63:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
	return -E_MAX_OPEN;
}
  801c68:	5b                   	pop    %ebx
  801c69:	5e                   	pop    %esi
  801c6a:	5f                   	pop    %edi
  801c6b:	5d                   	pop    %ebp
  801c6c:	c3                   	ret    

00801c6d <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  801c6d:	55                   	push   %ebp
  801c6e:	89 e5                	mov    %esp,%ebp
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  801c70:	8b 45 08             	mov    0x8(%ebp),%eax
  801c73:	83 f8 1f             	cmp    $0x1f,%eax
  801c76:	77 36                	ja     801cae <fd_lookup+0x41>
		if (debug)
			cprintf("[%08x] bad fd %d\n", env->env_id, fd);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  801c78:	05 00 00 0d 00       	add    $0xd0000,%eax
  801c7d:	c1 e0 0c             	shl    $0xc,%eax
	if (!(vpd[PDX(fd)] & PTE_P) || !(vpt[VPN(fd)] & PTE_P)) {
  801c80:	89 c2                	mov    %eax,%edx
  801c82:	c1 ea 16             	shr    $0x16,%edx
  801c85:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  801c8c:	f6 c2 01             	test   $0x1,%dl
  801c8f:	74 1d                	je     801cae <fd_lookup+0x41>
  801c91:	89 c2                	mov    %eax,%edx
  801c93:	c1 ea 0c             	shr    $0xc,%edx
  801c96:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801c9d:	f6 c2 01             	test   $0x1,%dl
  801ca0:	74 0c                	je     801cae <fd_lookup+0x41>
		if (debug)
			cprintf("[%08x] closed fd %d\n", env->env_id, fd);
		return -E_INVAL;
	}
	*fd_store = fd;
  801ca2:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ca5:	89 02                	mov    %eax,(%edx)
  801ca7:	b8 00 00 00 00       	mov    $0x0,%eax
	return 0;
  801cac:	eb 05                	jmp    801cb3 <fd_lookup+0x46>
  801cae:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  801cb3:	5d                   	pop    %ebp
  801cb4:	c3                   	ret    

00801cb5 <seek>:
	return (*dev->dev_write)(fd, buf, n);
}

int
seek(int fdnum, off_t offset)
{
  801cb5:	55                   	push   %ebp
  801cb6:	89 e5                	mov    %esp,%ebp
  801cb8:	83 ec 18             	sub    $0x18,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801cbb:	8d 45 fc             	lea    -0x4(%ebp),%eax
  801cbe:	89 44 24 04          	mov    %eax,0x4(%esp)
  801cc2:	8b 45 08             	mov    0x8(%ebp),%eax
  801cc5:	89 04 24             	mov    %eax,(%esp)
  801cc8:	e8 a0 ff ff ff       	call   801c6d <fd_lookup>
  801ccd:	85 c0                	test   %eax,%eax
  801ccf:	78 0e                	js     801cdf <seek+0x2a>
		return r;
	fd->fd_offset = offset;
  801cd1:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801cd4:	8b 55 0c             	mov    0xc(%ebp),%edx
  801cd7:	89 50 04             	mov    %edx,0x4(%eax)
  801cda:	b8 00 00 00 00       	mov    $0x0,%eax
	return 0;
}
  801cdf:	c9                   	leave  
  801ce0:	c3                   	ret    

00801ce1 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  801ce1:	55                   	push   %ebp
  801ce2:	89 e5                	mov    %esp,%ebp
  801ce4:	56                   	push   %esi
  801ce5:	53                   	push   %ebx
  801ce6:	83 ec 10             	sub    $0x10,%esp
  801ce9:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801cec:	8b 5d 0c             	mov    0xc(%ebp),%ebx
// File functions
// --------------------------------------------------------------

static struct Dev *devtab[] =
{
	&devfile,
  801cef:	b8 04 70 80 00       	mov    $0x807004,%eax
{
	int i;
	for (i = 0; devtab[i]; i++)
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
  801cf4:	ba 00 00 00 00       	mov    $0x0,%edx

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  801cf9:	be 64 3d 80 00       	mov    $0x803d64,%esi
		if (devtab[i]->dev_id == dev_id) {
  801cfe:	39 08                	cmp    %ecx,(%eax)
  801d00:	75 10                	jne    801d12 <dev_lookup+0x31>
  801d02:	eb 04                	jmp    801d08 <dev_lookup+0x27>
  801d04:	39 08                	cmp    %ecx,(%eax)
  801d06:	75 0a                	jne    801d12 <dev_lookup+0x31>
			*dev = devtab[i];
  801d08:	89 03                	mov    %eax,(%ebx)
  801d0a:	b8 00 00 00 00       	mov    $0x0,%eax
			return 0;
  801d0f:	90                   	nop
  801d10:	eb 31                	jmp    801d43 <dev_lookup+0x62>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  801d12:	83 c2 01             	add    $0x1,%edx
  801d15:	8b 04 96             	mov    (%esi,%edx,4),%eax
  801d18:	85 c0                	test   %eax,%eax
  801d1a:	75 e8                	jne    801d04 <dev_lookup+0x23>
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", env->env_id, dev_id);
  801d1c:	a1 8c 70 80 00       	mov    0x80708c,%eax
  801d21:	8b 40 4c             	mov    0x4c(%eax),%eax
  801d24:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801d28:	89 44 24 04          	mov    %eax,0x4(%esp)
  801d2c:	c7 04 24 e8 3c 80 00 	movl   $0x803ce8,(%esp)
  801d33:	e8 31 ea ff ff       	call   800769 <cprintf>
	*dev = 0;
  801d38:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  801d3e:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
	return -E_INVAL;
}
  801d43:	83 c4 10             	add    $0x10,%esp
  801d46:	5b                   	pop    %ebx
  801d47:	5e                   	pop    %esi
  801d48:	5d                   	pop    %ebp
  801d49:	c3                   	ret    

00801d4a <fstat>:
	return (*dev->dev_trunc)(fd, newsize);
}

int
fstat(int fdnum, struct Stat *stat)
{
  801d4a:	55                   	push   %ebp
  801d4b:	89 e5                	mov    %esp,%ebp
  801d4d:	53                   	push   %ebx
  801d4e:	83 ec 24             	sub    $0x24,%esp
  801d51:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801d54:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801d57:	89 44 24 04          	mov    %eax,0x4(%esp)
  801d5b:	8b 45 08             	mov    0x8(%ebp),%eax
  801d5e:	89 04 24             	mov    %eax,(%esp)
  801d61:	e8 07 ff ff ff       	call   801c6d <fd_lookup>
  801d66:	85 c0                	test   %eax,%eax
  801d68:	78 53                	js     801dbd <fstat+0x73>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801d6a:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801d6d:	89 44 24 04          	mov    %eax,0x4(%esp)
  801d71:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801d74:	8b 00                	mov    (%eax),%eax
  801d76:	89 04 24             	mov    %eax,(%esp)
  801d79:	e8 63 ff ff ff       	call   801ce1 <dev_lookup>
{
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801d7e:	85 c0                	test   %eax,%eax
  801d80:	78 3b                	js     801dbd <fstat+0x73>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if (!dev->dev_stat)
  801d82:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801d87:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801d8a:	83 7a 14 00          	cmpl   $0x0,0x14(%edx)
  801d8e:	74 2d                	je     801dbd <fstat+0x73>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  801d90:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  801d93:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  801d9a:	00 00 00 
	stat->st_isdir = 0;
  801d9d:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801da4:	00 00 00 
	stat->st_dev = dev;
  801da7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801daa:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  801db0:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801db4:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801db7:	89 14 24             	mov    %edx,(%esp)
  801dba:	ff 50 14             	call   *0x14(%eax)
}
  801dbd:	83 c4 24             	add    $0x24,%esp
  801dc0:	5b                   	pop    %ebx
  801dc1:	5d                   	pop    %ebp
  801dc2:	c3                   	ret    

00801dc3 <ftruncate>:
	return 0;
}

int
ftruncate(int fdnum, off_t newsize)
{
  801dc3:	55                   	push   %ebp
  801dc4:	89 e5                	mov    %esp,%ebp
  801dc6:	53                   	push   %ebx
  801dc7:	83 ec 24             	sub    $0x24,%esp
  801dca:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  801dcd:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801dd0:	89 44 24 04          	mov    %eax,0x4(%esp)
  801dd4:	89 1c 24             	mov    %ebx,(%esp)
  801dd7:	e8 91 fe ff ff       	call   801c6d <fd_lookup>
  801ddc:	85 c0                	test   %eax,%eax
  801dde:	78 5f                	js     801e3f <ftruncate+0x7c>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801de0:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801de3:	89 44 24 04          	mov    %eax,0x4(%esp)
  801de7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801dea:	8b 00                	mov    (%eax),%eax
  801dec:	89 04 24             	mov    %eax,(%esp)
  801def:	e8 ed fe ff ff       	call   801ce1 <dev_lookup>
ftruncate(int fdnum, off_t newsize)
{
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  801df4:	85 c0                	test   %eax,%eax
  801df6:	78 47                	js     801e3f <ftruncate+0x7c>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801df8:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801dfb:	f6 42 08 03          	testb  $0x3,0x8(%edx)
  801dff:	75 23                	jne    801e24 <ftruncate+0x61>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			env->env_id, fdnum); 
  801e01:	a1 8c 70 80 00       	mov    0x80708c,%eax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  801e06:	8b 40 4c             	mov    0x4c(%eax),%eax
  801e09:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801e0d:	89 44 24 04          	mov    %eax,0x4(%esp)
  801e11:	c7 04 24 08 3d 80 00 	movl   $0x803d08,(%esp)
  801e18:	e8 4c e9 ff ff       	call   800769 <cprintf>
  801e1d:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
			env->env_id, fdnum); 
		return -E_INVAL;
  801e22:	eb 1b                	jmp    801e3f <ftruncate+0x7c>
	}
	if (!dev->dev_trunc)
  801e24:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e27:	8b 48 18             	mov    0x18(%eax),%ecx
  801e2a:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801e2f:	85 c9                	test   %ecx,%ecx
  801e31:	74 0c                	je     801e3f <ftruncate+0x7c>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  801e33:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e36:	89 44 24 04          	mov    %eax,0x4(%esp)
  801e3a:	89 14 24             	mov    %edx,(%esp)
  801e3d:	ff d1                	call   *%ecx
}
  801e3f:	83 c4 24             	add    $0x24,%esp
  801e42:	5b                   	pop    %ebx
  801e43:	5d                   	pop    %ebp
  801e44:	c3                   	ret    

00801e45 <write>:
	return tot;
}

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  801e45:	55                   	push   %ebp
  801e46:	89 e5                	mov    %esp,%ebp
  801e48:	53                   	push   %ebx
  801e49:	83 ec 24             	sub    $0x24,%esp
  801e4c:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801e4f:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801e52:	89 44 24 04          	mov    %eax,0x4(%esp)
  801e56:	89 1c 24             	mov    %ebx,(%esp)
  801e59:	e8 0f fe ff ff       	call   801c6d <fd_lookup>
  801e5e:	85 c0                	test   %eax,%eax
  801e60:	78 66                	js     801ec8 <write+0x83>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801e62:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801e65:	89 44 24 04          	mov    %eax,0x4(%esp)
  801e69:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801e6c:	8b 00                	mov    (%eax),%eax
  801e6e:	89 04 24             	mov    %eax,(%esp)
  801e71:	e8 6b fe ff ff       	call   801ce1 <dev_lookup>
{
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801e76:	85 c0                	test   %eax,%eax
  801e78:	78 4e                	js     801ec8 <write+0x83>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801e7a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801e7d:	f6 42 08 03          	testb  $0x3,0x8(%edx)
  801e81:	75 23                	jne    801ea6 <write+0x61>
		cprintf("[%08x] write %d -- bad mode\n", env->env_id, fdnum);
  801e83:	a1 8c 70 80 00       	mov    0x80708c,%eax
  801e88:	8b 40 4c             	mov    0x4c(%eax),%eax
  801e8b:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801e8f:	89 44 24 04          	mov    %eax,0x4(%esp)
  801e93:	c7 04 24 29 3d 80 00 	movl   $0x803d29,(%esp)
  801e9a:	e8 ca e8 ff ff       	call   800769 <cprintf>
  801e9f:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
		return -E_INVAL;
  801ea4:	eb 22                	jmp    801ec8 <write+0x83>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  801ea6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ea9:	8b 48 0c             	mov    0xc(%eax),%ecx
  801eac:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801eb1:	85 c9                	test   %ecx,%ecx
  801eb3:	74 13                	je     801ec8 <write+0x83>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  801eb5:	8b 45 10             	mov    0x10(%ebp),%eax
  801eb8:	89 44 24 08          	mov    %eax,0x8(%esp)
  801ebc:	8b 45 0c             	mov    0xc(%ebp),%eax
  801ebf:	89 44 24 04          	mov    %eax,0x4(%esp)
  801ec3:	89 14 24             	mov    %edx,(%esp)
  801ec6:	ff d1                	call   *%ecx
}
  801ec8:	83 c4 24             	add    $0x24,%esp
  801ecb:	5b                   	pop    %ebx
  801ecc:	5d                   	pop    %ebp
  801ecd:	c3                   	ret    

00801ece <read>:
	return r;
}

ssize_t
read(int fdnum, void *buf, size_t n)
{
  801ece:	55                   	push   %ebp
  801ecf:	89 e5                	mov    %esp,%ebp
  801ed1:	53                   	push   %ebx
  801ed2:	83 ec 24             	sub    $0x24,%esp
  801ed5:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801ed8:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801edb:	89 44 24 04          	mov    %eax,0x4(%esp)
  801edf:	89 1c 24             	mov    %ebx,(%esp)
  801ee2:	e8 86 fd ff ff       	call   801c6d <fd_lookup>
  801ee7:	85 c0                	test   %eax,%eax
  801ee9:	78 6b                	js     801f56 <read+0x88>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801eeb:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801eee:	89 44 24 04          	mov    %eax,0x4(%esp)
  801ef2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801ef5:	8b 00                	mov    (%eax),%eax
  801ef7:	89 04 24             	mov    %eax,(%esp)
  801efa:	e8 e2 fd ff ff       	call   801ce1 <dev_lookup>
{
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801eff:	85 c0                	test   %eax,%eax
  801f01:	78 53                	js     801f56 <read+0x88>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  801f03:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801f06:	8b 42 08             	mov    0x8(%edx),%eax
  801f09:	83 e0 03             	and    $0x3,%eax
  801f0c:	83 f8 01             	cmp    $0x1,%eax
  801f0f:	75 23                	jne    801f34 <read+0x66>
		cprintf("[%08x] read %d -- bad mode\n", env->env_id, fdnum); 
  801f11:	a1 8c 70 80 00       	mov    0x80708c,%eax
  801f16:	8b 40 4c             	mov    0x4c(%eax),%eax
  801f19:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801f1d:	89 44 24 04          	mov    %eax,0x4(%esp)
  801f21:	c7 04 24 46 3d 80 00 	movl   $0x803d46,(%esp)
  801f28:	e8 3c e8 ff ff       	call   800769 <cprintf>
  801f2d:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
		return -E_INVAL;
  801f32:	eb 22                	jmp    801f56 <read+0x88>
	}
	if (!dev->dev_read)
  801f34:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f37:	8b 48 08             	mov    0x8(%eax),%ecx
  801f3a:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801f3f:	85 c9                	test   %ecx,%ecx
  801f41:	74 13                	je     801f56 <read+0x88>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  801f43:	8b 45 10             	mov    0x10(%ebp),%eax
  801f46:	89 44 24 08          	mov    %eax,0x8(%esp)
  801f4a:	8b 45 0c             	mov    0xc(%ebp),%eax
  801f4d:	89 44 24 04          	mov    %eax,0x4(%esp)
  801f51:	89 14 24             	mov    %edx,(%esp)
  801f54:	ff d1                	call   *%ecx
}
  801f56:	83 c4 24             	add    $0x24,%esp
  801f59:	5b                   	pop    %ebx
  801f5a:	5d                   	pop    %ebp
  801f5b:	c3                   	ret    

00801f5c <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  801f5c:	55                   	push   %ebp
  801f5d:	89 e5                	mov    %esp,%ebp
  801f5f:	57                   	push   %edi
  801f60:	56                   	push   %esi
  801f61:	53                   	push   %ebx
  801f62:	83 ec 1c             	sub    $0x1c,%esp
  801f65:	8b 7d 08             	mov    0x8(%ebp),%edi
  801f68:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  801f6b:	ba 00 00 00 00       	mov    $0x0,%edx
  801f70:	bb 00 00 00 00       	mov    $0x0,%ebx
  801f75:	b8 00 00 00 00       	mov    $0x0,%eax
  801f7a:	85 f6                	test   %esi,%esi
  801f7c:	74 29                	je     801fa7 <readn+0x4b>
		m = read(fdnum, (char*)buf + tot, n - tot);
  801f7e:	89 f0                	mov    %esi,%eax
  801f80:	29 d0                	sub    %edx,%eax
  801f82:	89 44 24 08          	mov    %eax,0x8(%esp)
  801f86:	03 55 0c             	add    0xc(%ebp),%edx
  801f89:	89 54 24 04          	mov    %edx,0x4(%esp)
  801f8d:	89 3c 24             	mov    %edi,(%esp)
  801f90:	e8 39 ff ff ff       	call   801ece <read>
		if (m < 0)
  801f95:	85 c0                	test   %eax,%eax
  801f97:	78 0e                	js     801fa7 <readn+0x4b>
			return m;
		if (m == 0)
  801f99:	85 c0                	test   %eax,%eax
  801f9b:	74 08                	je     801fa5 <readn+0x49>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  801f9d:	01 c3                	add    %eax,%ebx
  801f9f:	89 da                	mov    %ebx,%edx
  801fa1:	39 f3                	cmp    %esi,%ebx
  801fa3:	72 d9                	jb     801f7e <readn+0x22>
  801fa5:	89 d8                	mov    %ebx,%eax
			return m;
		if (m == 0)
			break;
	}
	return tot;
}
  801fa7:	83 c4 1c             	add    $0x1c,%esp
  801faa:	5b                   	pop    %ebx
  801fab:	5e                   	pop    %esi
  801fac:	5f                   	pop    %edi
  801fad:	5d                   	pop    %ebp
  801fae:	c3                   	ret    

00801faf <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  801faf:	55                   	push   %ebp
  801fb0:	89 e5                	mov    %esp,%ebp
  801fb2:	56                   	push   %esi
  801fb3:	53                   	push   %ebx
  801fb4:	83 ec 20             	sub    $0x20,%esp
  801fb7:	8b 75 08             	mov    0x8(%ebp),%esi
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801fba:	89 34 24             	mov    %esi,(%esp)
  801fbd:	e8 0e fc ff ff       	call   801bd0 <fd2num>
  801fc2:	8d 55 f4             	lea    -0xc(%ebp),%edx
  801fc5:	89 54 24 04          	mov    %edx,0x4(%esp)
  801fc9:	89 04 24             	mov    %eax,(%esp)
  801fcc:	e8 9c fc ff ff       	call   801c6d <fd_lookup>
  801fd1:	89 c3                	mov    %eax,%ebx
  801fd3:	85 c0                	test   %eax,%eax
  801fd5:	78 05                	js     801fdc <fd_close+0x2d>
  801fd7:	3b 75 f4             	cmp    -0xc(%ebp),%esi
  801fda:	74 0c                	je     801fe8 <fd_close+0x39>
	    || fd != fd2)
		return (must_exist ? r : 0);
  801fdc:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  801fe0:	19 c0                	sbb    %eax,%eax
  801fe2:	f7 d0                	not    %eax
  801fe4:	21 c3                	and    %eax,%ebx
  801fe6:	eb 3d                	jmp    802025 <fd_close+0x76>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  801fe8:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801feb:	89 44 24 04          	mov    %eax,0x4(%esp)
  801fef:	8b 06                	mov    (%esi),%eax
  801ff1:	89 04 24             	mov    %eax,(%esp)
  801ff4:	e8 e8 fc ff ff       	call   801ce1 <dev_lookup>
  801ff9:	89 c3                	mov    %eax,%ebx
  801ffb:	85 c0                	test   %eax,%eax
  801ffd:	78 16                	js     802015 <fd_close+0x66>
		if (dev->dev_close)
  801fff:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802002:	8b 40 10             	mov    0x10(%eax),%eax
  802005:	bb 00 00 00 00       	mov    $0x0,%ebx
  80200a:	85 c0                	test   %eax,%eax
  80200c:	74 07                	je     802015 <fd_close+0x66>
			r = (*dev->dev_close)(fd);
  80200e:	89 34 24             	mov    %esi,(%esp)
  802011:	ff d0                	call   *%eax
  802013:	89 c3                	mov    %eax,%ebx
		else
			r = 0;
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  802015:	89 74 24 04          	mov    %esi,0x4(%esp)
  802019:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802020:	e8 3a f5 ff ff       	call   80155f <sys_page_unmap>
	return r;
}
  802025:	89 d8                	mov    %ebx,%eax
  802027:	83 c4 20             	add    $0x20,%esp
  80202a:	5b                   	pop    %ebx
  80202b:	5e                   	pop    %esi
  80202c:	5d                   	pop    %ebp
  80202d:	c3                   	ret    

0080202e <close>:
	return -E_INVAL;
}

int
close(int fdnum)
{
  80202e:	55                   	push   %ebp
  80202f:	89 e5                	mov    %esp,%ebp
  802031:	83 ec 28             	sub    $0x28,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802034:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802037:	89 44 24 04          	mov    %eax,0x4(%esp)
  80203b:	8b 45 08             	mov    0x8(%ebp),%eax
  80203e:	89 04 24             	mov    %eax,(%esp)
  802041:	e8 27 fc ff ff       	call   801c6d <fd_lookup>
  802046:	85 c0                	test   %eax,%eax
  802048:	78 13                	js     80205d <close+0x2f>
		return r;
	else
		return fd_close(fd, 1);
  80204a:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  802051:	00 
  802052:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802055:	89 04 24             	mov    %eax,(%esp)
  802058:	e8 52 ff ff ff       	call   801faf <fd_close>
}
  80205d:	c9                   	leave  
  80205e:	c3                   	ret    

0080205f <stat>:
	return (*dev->dev_stat)(fd, stat);
}

int
stat(const char *path, struct Stat *stat)
{
  80205f:	55                   	push   %ebp
  802060:	89 e5                	mov    %esp,%ebp
  802062:	83 ec 18             	sub    $0x18,%esp
  802065:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  802068:	89 75 fc             	mov    %esi,-0x4(%ebp)
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  80206b:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  802072:	00 
  802073:	8b 45 08             	mov    0x8(%ebp),%eax
  802076:	89 04 24             	mov    %eax,(%esp)
  802079:	e8 55 03 00 00       	call   8023d3 <open>
  80207e:	89 c3                	mov    %eax,%ebx
  802080:	85 c0                	test   %eax,%eax
  802082:	78 1b                	js     80209f <stat+0x40>
		return fd;
	r = fstat(fd, stat);
  802084:	8b 45 0c             	mov    0xc(%ebp),%eax
  802087:	89 44 24 04          	mov    %eax,0x4(%esp)
  80208b:	89 1c 24             	mov    %ebx,(%esp)
  80208e:	e8 b7 fc ff ff       	call   801d4a <fstat>
  802093:	89 c6                	mov    %eax,%esi
	close(fd);
  802095:	89 1c 24             	mov    %ebx,(%esp)
  802098:	e8 91 ff ff ff       	call   80202e <close>
  80209d:	89 f3                	mov    %esi,%ebx
	return r;
}
  80209f:	89 d8                	mov    %ebx,%eax
  8020a1:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  8020a4:	8b 75 fc             	mov    -0x4(%ebp),%esi
  8020a7:	89 ec                	mov    %ebp,%esp
  8020a9:	5d                   	pop    %ebp
  8020aa:	c3                   	ret    

008020ab <close_all>:
		return fd_close(fd, 1);
}

void
close_all(void)
{
  8020ab:	55                   	push   %ebp
  8020ac:	89 e5                	mov    %esp,%ebp
  8020ae:	53                   	push   %ebx
  8020af:	83 ec 14             	sub    $0x14,%esp
  8020b2:	bb 00 00 00 00       	mov    $0x0,%ebx
	int i;
	for (i = 0; i < MAXFD; i++)
		close(i);
  8020b7:	89 1c 24             	mov    %ebx,(%esp)
  8020ba:	e8 6f ff ff ff       	call   80202e <close>

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  8020bf:	83 c3 01             	add    $0x1,%ebx
  8020c2:	83 fb 20             	cmp    $0x20,%ebx
  8020c5:	75 f0                	jne    8020b7 <close_all+0xc>
		close(i);
}
  8020c7:	83 c4 14             	add    $0x14,%esp
  8020ca:	5b                   	pop    %ebx
  8020cb:	5d                   	pop    %ebp
  8020cc:	c3                   	ret    

008020cd <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  8020cd:	55                   	push   %ebp
  8020ce:	89 e5                	mov    %esp,%ebp
  8020d0:	83 ec 58             	sub    $0x58,%esp
  8020d3:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  8020d6:	89 75 f8             	mov    %esi,-0x8(%ebp)
  8020d9:	89 7d fc             	mov    %edi,-0x4(%ebp)
  8020dc:	8b 7d 0c             	mov    0xc(%ebp),%edi
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  8020df:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  8020e2:	89 44 24 04          	mov    %eax,0x4(%esp)
  8020e6:	8b 45 08             	mov    0x8(%ebp),%eax
  8020e9:	89 04 24             	mov    %eax,(%esp)
  8020ec:	e8 7c fb ff ff       	call   801c6d <fd_lookup>
  8020f1:	89 c3                	mov    %eax,%ebx
  8020f3:	85 c0                	test   %eax,%eax
  8020f5:	0f 88 e0 00 00 00    	js     8021db <dup+0x10e>
		return r;
	close(newfdnum);
  8020fb:	89 3c 24             	mov    %edi,(%esp)
  8020fe:	e8 2b ff ff ff       	call   80202e <close>

	newfd = INDEX2FD(newfdnum);
  802103:	8d b7 00 00 0d 00    	lea    0xd0000(%edi),%esi
  802109:	c1 e6 0c             	shl    $0xc,%esi
	ova = fd2data(oldfd);
  80210c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80210f:	89 04 24             	mov    %eax,(%esp)
  802112:	e8 c9 fa ff ff       	call   801be0 <fd2data>
  802117:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  802119:	89 34 24             	mov    %esi,(%esp)
  80211c:	e8 bf fa ff ff       	call   801be0 <fd2data>
  802121:	89 45 d4             	mov    %eax,-0x2c(%ebp)

	if ((vpd[PDX(ova)] & PTE_P) && (vpt[VPN(ova)] & PTE_P))
  802124:	89 da                	mov    %ebx,%edx
  802126:	89 d8                	mov    %ebx,%eax
  802128:	c1 e8 16             	shr    $0x16,%eax
  80212b:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  802132:	a8 01                	test   $0x1,%al
  802134:	74 43                	je     802179 <dup+0xac>
  802136:	c1 ea 0c             	shr    $0xc,%edx
  802139:	8b 04 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%eax
  802140:	a8 01                	test   $0x1,%al
  802142:	74 35                	je     802179 <dup+0xac>
		if ((r = sys_page_map(0, ova, 0, nva, vpt[VPN(ova)] & PTE_USER)) < 0)
  802144:	8b 04 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%eax
  80214b:	25 07 0e 00 00       	and    $0xe07,%eax
  802150:	89 44 24 10          	mov    %eax,0x10(%esp)
  802154:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802157:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80215b:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  802162:	00 
  802163:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  802167:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80216e:	e8 4a f4 ff ff       	call   8015bd <sys_page_map>
  802173:	89 c3                	mov    %eax,%ebx
  802175:	85 c0                	test   %eax,%eax
  802177:	78 3f                	js     8021b8 <dup+0xeb>
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, vpt[VPN(oldfd)] & PTE_USER)) < 0)
  802179:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80217c:	89 c2                	mov    %eax,%edx
  80217e:	c1 ea 0c             	shr    $0xc,%edx
  802181:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  802188:	81 e2 07 0e 00 00    	and    $0xe07,%edx
  80218e:	89 54 24 10          	mov    %edx,0x10(%esp)
  802192:	89 74 24 0c          	mov    %esi,0xc(%esp)
  802196:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  80219d:	00 
  80219e:	89 44 24 04          	mov    %eax,0x4(%esp)
  8021a2:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8021a9:	e8 0f f4 ff ff       	call   8015bd <sys_page_map>
  8021ae:	89 c3                	mov    %eax,%ebx
  8021b0:	85 c0                	test   %eax,%eax
  8021b2:	78 04                	js     8021b8 <dup+0xeb>
  8021b4:	89 fb                	mov    %edi,%ebx
  8021b6:	eb 23                	jmp    8021db <dup+0x10e>
		goto err;

	return newfdnum;

err:
	sys_page_unmap(0, newfd);
  8021b8:	89 74 24 04          	mov    %esi,0x4(%esp)
  8021bc:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8021c3:	e8 97 f3 ff ff       	call   80155f <sys_page_unmap>
	sys_page_unmap(0, nva);
  8021c8:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8021cb:	89 44 24 04          	mov    %eax,0x4(%esp)
  8021cf:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8021d6:	e8 84 f3 ff ff       	call   80155f <sys_page_unmap>
	return r;
}
  8021db:	89 d8                	mov    %ebx,%eax
  8021dd:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  8021e0:	8b 75 f8             	mov    -0x8(%ebp),%esi
  8021e3:	8b 7d fc             	mov    -0x4(%ebp),%edi
  8021e6:	89 ec                	mov    %ebp,%esp
  8021e8:	5d                   	pop    %ebp
  8021e9:	c3                   	ret    
	...

008021ec <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  8021ec:	55                   	push   %ebp
  8021ed:	89 e5                	mov    %esp,%ebp
  8021ef:	53                   	push   %ebx
  8021f0:	83 ec 14             	sub    $0x14,%esp
  8021f3:	89 d3                	mov    %edx,%ebx
	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", env->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(envs[1].env_id, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  8021f5:	8b 15 c8 00 c0 ee    	mov    0xeec000c8,%edx
  8021fb:	c7 44 24 0c 07 00 00 	movl   $0x7,0xc(%esp)
  802202:	00 
  802203:	c7 44 24 08 00 40 80 	movl   $0x804000,0x8(%esp)
  80220a:	00 
  80220b:	89 44 24 04          	mov    %eax,0x4(%esp)
  80220f:	89 14 24             	mov    %edx,(%esp)
  802212:	e8 e9 f8 ff ff       	call   801b00 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  802217:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  80221e:	00 
  80221f:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  802223:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80222a:	e8 37 f9 ff ff       	call   801b66 <ipc_recv>
}
  80222f:	83 c4 14             	add    $0x14,%esp
  802232:	5b                   	pop    %ebx
  802233:	5d                   	pop    %ebp
  802234:	c3                   	ret    

00802235 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  802235:	55                   	push   %ebp
  802236:	89 e5                	mov    %esp,%ebp
  802238:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  80223b:	8b 45 08             	mov    0x8(%ebp),%eax
  80223e:	8b 40 0c             	mov    0xc(%eax),%eax
  802241:	a3 00 40 80 00       	mov    %eax,0x804000
	fsipcbuf.set_size.req_size = newsize;
  802246:	8b 45 0c             	mov    0xc(%ebp),%eax
  802249:	a3 04 40 80 00       	mov    %eax,0x804004
	return fsipc(FSREQ_SET_SIZE, NULL);
  80224e:	ba 00 00 00 00       	mov    $0x0,%edx
  802253:	b8 02 00 00 00       	mov    $0x2,%eax
  802258:	e8 8f ff ff ff       	call   8021ec <fsipc>
}
  80225d:	c9                   	leave  
  80225e:	c3                   	ret    

0080225f <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  80225f:	55                   	push   %ebp
  802260:	89 e5                	mov    %esp,%ebp
  802262:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  802265:	8b 45 08             	mov    0x8(%ebp),%eax
  802268:	8b 40 0c             	mov    0xc(%eax),%eax
  80226b:	a3 00 40 80 00       	mov    %eax,0x804000
	return fsipc(FSREQ_FLUSH, NULL);
  802270:	ba 00 00 00 00       	mov    $0x0,%edx
  802275:	b8 06 00 00 00       	mov    $0x6,%eax
  80227a:	e8 6d ff ff ff       	call   8021ec <fsipc>
}
  80227f:	c9                   	leave  
  802280:	c3                   	ret    

00802281 <sync>:
}

// Synchronize disk with buffer cache
int
sync(void)
{
  802281:	55                   	push   %ebp
  802282:	89 e5                	mov    %esp,%ebp
  802284:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  802287:	ba 00 00 00 00       	mov    $0x0,%edx
  80228c:	b8 08 00 00 00       	mov    $0x8,%eax
  802291:	e8 56 ff ff ff       	call   8021ec <fsipc>
}
  802296:	c9                   	leave  
  802297:	c3                   	ret    

00802298 <devfile_stat>:
	return fsipc(FSREQ_WRITE, NULL);	
}

static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  802298:	55                   	push   %ebp
  802299:	89 e5                	mov    %esp,%ebp
  80229b:	53                   	push   %ebx
  80229c:	83 ec 14             	sub    $0x14,%esp
  80229f:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  8022a2:	8b 45 08             	mov    0x8(%ebp),%eax
  8022a5:	8b 40 0c             	mov    0xc(%eax),%eax
  8022a8:	a3 00 40 80 00       	mov    %eax,0x804000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  8022ad:	ba 00 00 00 00       	mov    $0x0,%edx
  8022b2:	b8 05 00 00 00       	mov    $0x5,%eax
  8022b7:	e8 30 ff ff ff       	call   8021ec <fsipc>
  8022bc:	85 c0                	test   %eax,%eax
  8022be:	78 2b                	js     8022eb <devfile_stat+0x53>
		return r;
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  8022c0:	c7 44 24 04 00 40 80 	movl   $0x804000,0x4(%esp)
  8022c7:	00 
  8022c8:	89 1c 24             	mov    %ebx,(%esp)
  8022cb:	e8 5a eb ff ff       	call   800e2a <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  8022d0:	a1 80 40 80 00       	mov    0x804080,%eax
  8022d5:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  8022db:	a1 84 40 80 00       	mov    0x804084,%eax
  8022e0:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
  8022e6:	b8 00 00 00 00       	mov    $0x0,%eax
	return 0;
}
  8022eb:	83 c4 14             	add    $0x14,%esp
  8022ee:	5b                   	pop    %ebx
  8022ef:	5d                   	pop    %ebp
  8022f0:	c3                   	ret    

008022f1 <devfile_write>:
// Returns:
//	 The number of bytes successfully written.
//	 < 0 on error.
static ssize_t
devfile_write(struct Fd *fd, const void *buf, size_t n)
{
  8022f1:	55                   	push   %ebp
  8022f2:	89 e5                	mov    %esp,%ebp
  8022f4:	83 ec 18             	sub    $0x18,%esp
  8022f7:	8b 45 10             	mov    0x10(%ebp),%eax
  8022fa:	3d f8 0f 00 00       	cmp    $0xff8,%eax
  8022ff:	76 05                	jbe    802306 <devfile_write+0x15>
  802301:	b8 f8 0f 00 00       	mov    $0xff8,%eax
	// LAB 5: Your code here
	//panic("devfile_write not implemented");
	
	if (n > (PGSIZE - (sizeof(int) + sizeof(size_t))))
		n = PGSIZE - (sizeof(int) + sizeof(size_t));
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  802306:	8b 55 08             	mov    0x8(%ebp),%edx
  802309:	8b 52 0c             	mov    0xc(%edx),%edx
  80230c:	89 15 00 40 80 00    	mov    %edx,0x804000
	fsipcbuf.write.req_n = n;
  802312:	a3 04 40 80 00       	mov    %eax,0x804004
	memmove (fsipcbuf.write.req_buf, (char*)buf, n);	
  802317:	89 44 24 08          	mov    %eax,0x8(%esp)
  80231b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80231e:	89 44 24 04          	mov    %eax,0x4(%esp)
  802322:	c7 04 24 08 40 80 00 	movl   $0x804008,(%esp)
  802329:	e8 b7 ec ff ff       	call   800fe5 <memmove>
	return fsipc(FSREQ_WRITE, NULL);	
  80232e:	ba 00 00 00 00       	mov    $0x0,%edx
  802333:	b8 04 00 00 00       	mov    $0x4,%eax
  802338:	e8 af fe ff ff       	call   8021ec <fsipc>
}
  80233d:	c9                   	leave  
  80233e:	c3                   	ret    

0080233f <devfile_read>:
// Returns:
// 	The number of bytes successfully read.
// 	< 0 on error.
static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  80233f:	55                   	push   %ebp
  802340:	89 e5                	mov    %esp,%ebp
  802342:	53                   	push   %ebx
  802343:	83 ec 14             	sub    $0x14,%esp
	// system server.
	// LAB 5: Your code here
	
	//panic("devfile_read not implemented");
	int r;
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  802346:	8b 45 08             	mov    0x8(%ebp),%eax
  802349:	8b 40 0c             	mov    0xc(%eax),%eax
  80234c:	a3 00 40 80 00       	mov    %eax,0x804000
	fsipcbuf.read.req_n = n;
  802351:	8b 45 10             	mov    0x10(%ebp),%eax
  802354:	a3 04 40 80 00       	mov    %eax,0x804004
	if ((r = fsipc(FSREQ_READ, (void*)&fsipcbuf)) < 0)
  802359:	ba 00 40 80 00       	mov    $0x804000,%edx
  80235e:	b8 03 00 00 00       	mov    $0x3,%eax
  802363:	e8 84 fe ff ff       	call   8021ec <fsipc>
  802368:	89 c3                	mov    %eax,%ebx
  80236a:	85 c0                	test   %eax,%eax
  80236c:	78 17                	js     802385 <devfile_read+0x46>
		return r;
	memmove((void*)buf, (void*)fsipcbuf.readRet.ret_buf, r);
  80236e:	89 44 24 08          	mov    %eax,0x8(%esp)
  802372:	c7 44 24 04 00 40 80 	movl   $0x804000,0x4(%esp)
  802379:	00 
  80237a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80237d:	89 04 24             	mov    %eax,(%esp)
  802380:	e8 60 ec ff ff       	call   800fe5 <memmove>
	return r;
}
  802385:	89 d8                	mov    %ebx,%eax
  802387:	83 c4 14             	add    $0x14,%esp
  80238a:	5b                   	pop    %ebx
  80238b:	5d                   	pop    %ebp
  80238c:	c3                   	ret    

0080238d <remove>:
}

// Delete a file
int
remove(const char *path)
{
  80238d:	55                   	push   %ebp
  80238e:	89 e5                	mov    %esp,%ebp
  802390:	53                   	push   %ebx
  802391:	83 ec 14             	sub    $0x14,%esp
  802394:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (strlen(path) >= MAXPATHLEN)
  802397:	89 1c 24             	mov    %ebx,(%esp)
  80239a:	e8 41 ea ff ff       	call   800de0 <strlen>
  80239f:	89 c2                	mov    %eax,%edx
  8023a1:	b8 f4 ff ff ff       	mov    $0xfffffff4,%eax
  8023a6:	81 fa ff 03 00 00    	cmp    $0x3ff,%edx
  8023ac:	7f 1f                	jg     8023cd <remove+0x40>
		return -E_BAD_PATH;
	strcpy(fsipcbuf.remove.req_path, path);
  8023ae:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8023b2:	c7 04 24 00 40 80 00 	movl   $0x804000,(%esp)
  8023b9:	e8 6c ea ff ff       	call   800e2a <strcpy>
	return fsipc(FSREQ_REMOVE, NULL);
  8023be:	ba 00 00 00 00       	mov    $0x0,%edx
  8023c3:	b8 07 00 00 00       	mov    $0x7,%eax
  8023c8:	e8 1f fe ff ff       	call   8021ec <fsipc>
}
  8023cd:	83 c4 14             	add    $0x14,%esp
  8023d0:	5b                   	pop    %ebx
  8023d1:	5d                   	pop    %ebp
  8023d2:	c3                   	ret    

008023d3 <open>:
// 	The file descriptor index on success
// 	-E_BAD_PATH if the path is too long (>= MAXPATHLEN)
// 	< 0 for other errors.
int
open(const char *path, int mode)
{
  8023d3:	55                   	push   %ebp
  8023d4:	89 e5                	mov    %esp,%ebp
  8023d6:	83 ec 28             	sub    $0x28,%esp
  8023d9:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  8023dc:	89 75 fc             	mov    %esi,-0x4(%ebp)
  8023df:	8b 75 08             	mov    0x8(%ebp),%esi
	// file descriptor.

	// LAB 5: Your code here.
	// Code added by Swastika / Sandeep
	
	if (strlen(path) >= MAXPATHLEN)
  8023e2:	89 34 24             	mov    %esi,(%esp)
  8023e5:	e8 f6 e9 ff ff       	call   800de0 <strlen>
  8023ea:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  8023ef:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  8023f4:	7f 5e                	jg     802454 <open+0x81>
		return -E_BAD_PATH;
	struct Fd * fd;
	int  r;
	if ((r = fd_alloc(&fd)) < 0)
  8023f6:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8023f9:	89 04 24             	mov    %eax,(%esp)
  8023fc:	e8 fa f7 ff ff       	call   801bfb <fd_alloc>
  802401:	89 c3                	mov    %eax,%ebx
  802403:	85 c0                	test   %eax,%eax
  802405:	78 4d                	js     802454 <open+0x81>
		return r;
	strcpy (fsipcbuf.open.req_path, path);
  802407:	89 74 24 04          	mov    %esi,0x4(%esp)
  80240b:	c7 04 24 00 40 80 00 	movl   $0x804000,(%esp)
  802412:	e8 13 ea ff ff       	call   800e2a <strcpy>
	fsipcbuf.open.req_omode = mode;	
  802417:	8b 45 0c             	mov    0xc(%ebp),%eax
  80241a:	a3 00 44 80 00       	mov    %eax,0x804400
	if ((r = fsipc(FSREQ_OPEN,(void*)fd)) < 0)
  80241f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802422:	b8 01 00 00 00       	mov    $0x1,%eax
  802427:	e8 c0 fd ff ff       	call   8021ec <fsipc>
  80242c:	89 c3                	mov    %eax,%ebx
  80242e:	85 c0                	test   %eax,%eax
  802430:	79 15                	jns    802447 <open+0x74>
	{
		fd_close(fd,0);
  802432:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  802439:	00 
  80243a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80243d:	89 04 24             	mov    %eax,(%esp)
  802440:	e8 6a fb ff ff       	call   801faf <fd_close>
		return r; 
  802445:	eb 0d                	jmp    802454 <open+0x81>
	}
	return fd2num(fd);
  802447:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80244a:	89 04 24             	mov    %eax,(%esp)
  80244d:	e8 7e f7 ff ff       	call   801bd0 <fd2num>
  802452:	89 c3                	mov    %eax,%ebx
	//panic("open not implemented");
}
  802454:	89 d8                	mov    %ebx,%eax
  802456:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  802459:	8b 75 fc             	mov    -0x4(%ebp),%esi
  80245c:	89 ec                	mov    %ebp,%esp
  80245e:	5d                   	pop    %ebp
  80245f:	c3                   	ret    

00802460 <devsock_stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  802460:	55                   	push   %ebp
  802461:	89 e5                	mov    %esp,%ebp
  802463:	83 ec 18             	sub    $0x18,%esp
	strcpy(stat->st_name, "<sock>");
  802466:	c7 44 24 04 78 3d 80 	movl   $0x803d78,0x4(%esp)
  80246d:	00 
  80246e:	8b 45 0c             	mov    0xc(%ebp),%eax
  802471:	89 04 24             	mov    %eax,(%esp)
  802474:	e8 b1 e9 ff ff       	call   800e2a <strcpy>
	return 0;
}
  802479:	b8 00 00 00 00       	mov    $0x0,%eax
  80247e:	c9                   	leave  
  80247f:	c3                   	ret    

00802480 <devsock_close>:
	return nsipc_shutdown(r, how);
}

static int
devsock_close(struct Fd *fd)
{
  802480:	55                   	push   %ebp
  802481:	89 e5                	mov    %esp,%ebp
  802483:	83 ec 18             	sub    $0x18,%esp
	return nsipc_close(fd->fd_sock.sockid);
  802486:	8b 45 08             	mov    0x8(%ebp),%eax
  802489:	8b 40 0c             	mov    0xc(%eax),%eax
  80248c:	89 04 24             	mov    %eax,(%esp)
  80248f:	e8 9e 02 00 00       	call   802732 <nsipc_close>
}
  802494:	c9                   	leave  
  802495:	c3                   	ret    

00802496 <devsock_write>:
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
}

static ssize_t
devsock_write(struct Fd *fd, const void *buf, size_t n)
{
  802496:	55                   	push   %ebp
  802497:	89 e5                	mov    %esp,%ebp
  802499:	83 ec 18             	sub    $0x18,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  80249c:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  8024a3:	00 
  8024a4:	8b 45 10             	mov    0x10(%ebp),%eax
  8024a7:	89 44 24 08          	mov    %eax,0x8(%esp)
  8024ab:	8b 45 0c             	mov    0xc(%ebp),%eax
  8024ae:	89 44 24 04          	mov    %eax,0x4(%esp)
  8024b2:	8b 45 08             	mov    0x8(%ebp),%eax
  8024b5:	8b 40 0c             	mov    0xc(%eax),%eax
  8024b8:	89 04 24             	mov    %eax,(%esp)
  8024bb:	e8 ae 02 00 00       	call   80276e <nsipc_send>
}
  8024c0:	c9                   	leave  
  8024c1:	c3                   	ret    

008024c2 <devsock_read>:
	return nsipc_listen(r, backlog);
}

static ssize_t
devsock_read(struct Fd *fd, void *buf, size_t n)
{
  8024c2:	55                   	push   %ebp
  8024c3:	89 e5                	mov    %esp,%ebp
  8024c5:	83 ec 18             	sub    $0x18,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  8024c8:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  8024cf:	00 
  8024d0:	8b 45 10             	mov    0x10(%ebp),%eax
  8024d3:	89 44 24 08          	mov    %eax,0x8(%esp)
  8024d7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8024da:	89 44 24 04          	mov    %eax,0x4(%esp)
  8024de:	8b 45 08             	mov    0x8(%ebp),%eax
  8024e1:	8b 40 0c             	mov    0xc(%eax),%eax
  8024e4:	89 04 24             	mov    %eax,(%esp)
  8024e7:	e8 f5 02 00 00       	call   8027e1 <nsipc_recv>
}
  8024ec:	c9                   	leave  
  8024ed:	c3                   	ret    

008024ee <alloc_sockfd>:
	return sfd->fd_sock.sockid;
}

static int
alloc_sockfd(int sockid)
{
  8024ee:	55                   	push   %ebp
  8024ef:	89 e5                	mov    %esp,%ebp
  8024f1:	56                   	push   %esi
  8024f2:	53                   	push   %ebx
  8024f3:	83 ec 20             	sub    $0x20,%esp
  8024f6:	89 c6                	mov    %eax,%esi
	struct Fd *sfd;
	int r;

	if ((r = fd_alloc(&sfd)) < 0
  8024f8:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8024fb:	89 04 24             	mov    %eax,(%esp)
  8024fe:	e8 f8 f6 ff ff       	call   801bfb <fd_alloc>
  802503:	89 c3                	mov    %eax,%ebx
  802505:	85 c0                	test   %eax,%eax
  802507:	78 21                	js     80252a <alloc_sockfd+0x3c>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U)) < 0) {
  802509:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  802510:	00 
  802511:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802514:	89 44 24 04          	mov    %eax,0x4(%esp)
  802518:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80251f:	e8 f7 f0 ff ff       	call   80161b <sys_page_alloc>
  802524:	89 c3                	mov    %eax,%ebx
alloc_sockfd(int sockid)
{
	struct Fd *sfd;
	int r;

	if ((r = fd_alloc(&sfd)) < 0
  802526:	85 c0                	test   %eax,%eax
  802528:	79 0a                	jns    802534 <alloc_sockfd+0x46>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U)) < 0) {
		nsipc_close(sockid);
  80252a:	89 34 24             	mov    %esi,(%esp)
  80252d:	e8 00 02 00 00       	call   802732 <nsipc_close>
		return r;
  802532:	eb 28                	jmp    80255c <alloc_sockfd+0x6e>
	}

	sfd->fd_dev_id = devsock.dev_id;
  802534:	8b 15 20 70 80 00    	mov    0x807020,%edx
  80253a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80253d:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  80253f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802542:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	sfd->fd_sock.sockid = sockid;
  802549:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80254c:	89 70 0c             	mov    %esi,0xc(%eax)
	return fd2num(sfd);
  80254f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802552:	89 04 24             	mov    %eax,(%esp)
  802555:	e8 76 f6 ff ff       	call   801bd0 <fd2num>
  80255a:	89 c3                	mov    %eax,%ebx
}
  80255c:	89 d8                	mov    %ebx,%eax
  80255e:	83 c4 20             	add    $0x20,%esp
  802561:	5b                   	pop    %ebx
  802562:	5e                   	pop    %esi
  802563:	5d                   	pop    %ebp
  802564:	c3                   	ret    

00802565 <socket>:
	return 0;
}

int
socket(int domain, int type, int protocol)
{
  802565:	55                   	push   %ebp
  802566:	89 e5                	mov    %esp,%ebp
  802568:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  80256b:	8b 45 10             	mov    0x10(%ebp),%eax
  80256e:	89 44 24 08          	mov    %eax,0x8(%esp)
  802572:	8b 45 0c             	mov    0xc(%ebp),%eax
  802575:	89 44 24 04          	mov    %eax,0x4(%esp)
  802579:	8b 45 08             	mov    0x8(%ebp),%eax
  80257c:	89 04 24             	mov    %eax,(%esp)
  80257f:	e8 62 01 00 00       	call   8026e6 <nsipc_socket>
  802584:	85 c0                	test   %eax,%eax
  802586:	78 05                	js     80258d <socket+0x28>
		return r;
	return alloc_sockfd(r);
  802588:	e8 61 ff ff ff       	call   8024ee <alloc_sockfd>
}
  80258d:	c9                   	leave  
  80258e:	66 90                	xchg   %ax,%ax
  802590:	c3                   	ret    

00802591 <fd2sockid>:
	.dev_stat =	devsock_stat,
};

static int
fd2sockid(int fd)
{
  802591:	55                   	push   %ebp
  802592:	89 e5                	mov    %esp,%ebp
  802594:	83 ec 28             	sub    $0x28,%esp
	struct Fd *sfd;
	int r;

	if ((r = fd_lookup(fd, &sfd)) < 0)
  802597:	8d 55 f4             	lea    -0xc(%ebp),%edx
  80259a:	89 54 24 04          	mov    %edx,0x4(%esp)
  80259e:	89 04 24             	mov    %eax,(%esp)
  8025a1:	e8 c7 f6 ff ff       	call   801c6d <fd_lookup>
  8025a6:	85 c0                	test   %eax,%eax
  8025a8:	78 15                	js     8025bf <fd2sockid+0x2e>
		return r;
	if (sfd->fd_dev_id != devsock.dev_id)
  8025aa:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8025ad:	8b 0a                	mov    (%edx),%ecx
  8025af:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8025b4:	3b 0d 20 70 80 00    	cmp    0x807020,%ecx
  8025ba:	75 03                	jne    8025bf <fd2sockid+0x2e>
		return -E_NOT_SUPP;
	return sfd->fd_sock.sockid;
  8025bc:	8b 42 0c             	mov    0xc(%edx),%eax
}
  8025bf:	c9                   	leave  
  8025c0:	c3                   	ret    

008025c1 <listen>:
	return nsipc_connect(r, name, namelen);
}

int
listen(int s, int backlog)
{
  8025c1:	55                   	push   %ebp
  8025c2:	89 e5                	mov    %esp,%ebp
  8025c4:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  8025c7:	8b 45 08             	mov    0x8(%ebp),%eax
  8025ca:	e8 c2 ff ff ff       	call   802591 <fd2sockid>
  8025cf:	85 c0                	test   %eax,%eax
  8025d1:	78 0f                	js     8025e2 <listen+0x21>
		return r;
	return nsipc_listen(r, backlog);
  8025d3:	8b 55 0c             	mov    0xc(%ebp),%edx
  8025d6:	89 54 24 04          	mov    %edx,0x4(%esp)
  8025da:	89 04 24             	mov    %eax,(%esp)
  8025dd:	e8 2e 01 00 00       	call   802710 <nsipc_listen>
}
  8025e2:	c9                   	leave  
  8025e3:	c3                   	ret    

008025e4 <connect>:
	return nsipc_close(fd->fd_sock.sockid);
}

int
connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  8025e4:	55                   	push   %ebp
  8025e5:	89 e5                	mov    %esp,%ebp
  8025e7:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  8025ea:	8b 45 08             	mov    0x8(%ebp),%eax
  8025ed:	e8 9f ff ff ff       	call   802591 <fd2sockid>
  8025f2:	85 c0                	test   %eax,%eax
  8025f4:	78 16                	js     80260c <connect+0x28>
		return r;
	return nsipc_connect(r, name, namelen);
  8025f6:	8b 55 10             	mov    0x10(%ebp),%edx
  8025f9:	89 54 24 08          	mov    %edx,0x8(%esp)
  8025fd:	8b 55 0c             	mov    0xc(%ebp),%edx
  802600:	89 54 24 04          	mov    %edx,0x4(%esp)
  802604:	89 04 24             	mov    %eax,(%esp)
  802607:	e8 55 02 00 00       	call   802861 <nsipc_connect>
}
  80260c:	c9                   	leave  
  80260d:	c3                   	ret    

0080260e <shutdown>:
	return nsipc_bind(r, name, namelen);
}

int
shutdown(int s, int how)
{
  80260e:	55                   	push   %ebp
  80260f:	89 e5                	mov    %esp,%ebp
  802611:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  802614:	8b 45 08             	mov    0x8(%ebp),%eax
  802617:	e8 75 ff ff ff       	call   802591 <fd2sockid>
  80261c:	85 c0                	test   %eax,%eax
  80261e:	78 0f                	js     80262f <shutdown+0x21>
		return r;
	return nsipc_shutdown(r, how);
  802620:	8b 55 0c             	mov    0xc(%ebp),%edx
  802623:	89 54 24 04          	mov    %edx,0x4(%esp)
  802627:	89 04 24             	mov    %eax,(%esp)
  80262a:	e8 1d 01 00 00       	call   80274c <nsipc_shutdown>
}
  80262f:	c9                   	leave  
  802630:	c3                   	ret    

00802631 <bind>:
	return alloc_sockfd(r);
}

int
bind(int s, struct sockaddr *name, socklen_t namelen)
{
  802631:	55                   	push   %ebp
  802632:	89 e5                	mov    %esp,%ebp
  802634:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  802637:	8b 45 08             	mov    0x8(%ebp),%eax
  80263a:	e8 52 ff ff ff       	call   802591 <fd2sockid>
  80263f:	85 c0                	test   %eax,%eax
  802641:	78 16                	js     802659 <bind+0x28>
		return r;
	return nsipc_bind(r, name, namelen);
  802643:	8b 55 10             	mov    0x10(%ebp),%edx
  802646:	89 54 24 08          	mov    %edx,0x8(%esp)
  80264a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80264d:	89 54 24 04          	mov    %edx,0x4(%esp)
  802651:	89 04 24             	mov    %eax,(%esp)
  802654:	e8 47 02 00 00       	call   8028a0 <nsipc_bind>
}
  802659:	c9                   	leave  
  80265a:	c3                   	ret    

0080265b <accept>:
	return fd2num(sfd);
}

int
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  80265b:	55                   	push   %ebp
  80265c:	89 e5                	mov    %esp,%ebp
  80265e:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  802661:	8b 45 08             	mov    0x8(%ebp),%eax
  802664:	e8 28 ff ff ff       	call   802591 <fd2sockid>
  802669:	85 c0                	test   %eax,%eax
  80266b:	78 1f                	js     80268c <accept+0x31>
		return r;
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  80266d:	8b 55 10             	mov    0x10(%ebp),%edx
  802670:	89 54 24 08          	mov    %edx,0x8(%esp)
  802674:	8b 55 0c             	mov    0xc(%ebp),%edx
  802677:	89 54 24 04          	mov    %edx,0x4(%esp)
  80267b:	89 04 24             	mov    %eax,(%esp)
  80267e:	e8 5c 02 00 00       	call   8028df <nsipc_accept>
  802683:	85 c0                	test   %eax,%eax
  802685:	78 05                	js     80268c <accept+0x31>
		return r;
	return alloc_sockfd(r);
  802687:	e8 62 fe ff ff       	call   8024ee <alloc_sockfd>
}
  80268c:	c9                   	leave  
  80268d:	8d 76 00             	lea    0x0(%esi),%esi
  802690:	c3                   	ret    
	...

008026a0 <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  8026a0:	55                   	push   %ebp
  8026a1:	89 e5                	mov    %esp,%ebp
  8026a3:	83 ec 18             	sub    $0x18,%esp
	if (debug)
		cprintf("[%08x] nsipc %d\n", env->env_id, type);

	ipc_send(envs[2].env_id, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  8026a6:	8b 15 44 01 c0 ee    	mov    0xeec00144,%edx
  8026ac:	c7 44 24 0c 07 00 00 	movl   $0x7,0xc(%esp)
  8026b3:	00 
  8026b4:	c7 44 24 08 00 60 80 	movl   $0x806000,0x8(%esp)
  8026bb:	00 
  8026bc:	89 44 24 04          	mov    %eax,0x4(%esp)
  8026c0:	89 14 24             	mov    %edx,(%esp)
  8026c3:	e8 38 f4 ff ff       	call   801b00 <ipc_send>
	return ipc_recv(NULL, NULL, NULL);
  8026c8:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  8026cf:	00 
  8026d0:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  8026d7:	00 
  8026d8:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8026df:	e8 82 f4 ff ff       	call   801b66 <ipc_recv>
}
  8026e4:	c9                   	leave  
  8026e5:	c3                   	ret    

008026e6 <nsipc_socket>:
	return nsipc(NSREQ_SEND);
}

int
nsipc_socket(int domain, int type, int protocol)
{
  8026e6:	55                   	push   %ebp
  8026e7:	89 e5                	mov    %esp,%ebp
  8026e9:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  8026ec:	8b 45 08             	mov    0x8(%ebp),%eax
  8026ef:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.socket.req_type = type;
  8026f4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8026f7:	a3 04 60 80 00       	mov    %eax,0x806004
	nsipcbuf.socket.req_protocol = protocol;
  8026fc:	8b 45 10             	mov    0x10(%ebp),%eax
  8026ff:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SOCKET);
  802704:	b8 09 00 00 00       	mov    $0x9,%eax
  802709:	e8 92 ff ff ff       	call   8026a0 <nsipc>
}
  80270e:	c9                   	leave  
  80270f:	c3                   	ret    

00802710 <nsipc_listen>:
	return nsipc(NSREQ_CONNECT);
}

int
nsipc_listen(int s, int backlog)
{
  802710:	55                   	push   %ebp
  802711:	89 e5                	mov    %esp,%ebp
  802713:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  802716:	8b 45 08             	mov    0x8(%ebp),%eax
  802719:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.listen.req_backlog = backlog;
  80271e:	8b 45 0c             	mov    0xc(%ebp),%eax
  802721:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_LISTEN);
  802726:	b8 06 00 00 00       	mov    $0x6,%eax
  80272b:	e8 70 ff ff ff       	call   8026a0 <nsipc>
}
  802730:	c9                   	leave  
  802731:	c3                   	ret    

00802732 <nsipc_close>:
	return nsipc(NSREQ_SHUTDOWN);
}

int
nsipc_close(int s)
{
  802732:	55                   	push   %ebp
  802733:	89 e5                	mov    %esp,%ebp
  802735:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  802738:	8b 45 08             	mov    0x8(%ebp),%eax
  80273b:	a3 00 60 80 00       	mov    %eax,0x806000
	return nsipc(NSREQ_CLOSE);
  802740:	b8 04 00 00 00       	mov    $0x4,%eax
  802745:	e8 56 ff ff ff       	call   8026a0 <nsipc>
}
  80274a:	c9                   	leave  
  80274b:	c3                   	ret    

0080274c <nsipc_shutdown>:
	return nsipc(NSREQ_BIND);
}

int
nsipc_shutdown(int s, int how)
{
  80274c:	55                   	push   %ebp
  80274d:	89 e5                	mov    %esp,%ebp
  80274f:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  802752:	8b 45 08             	mov    0x8(%ebp),%eax
  802755:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.shutdown.req_how = how;
  80275a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80275d:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_SHUTDOWN);
  802762:	b8 03 00 00 00       	mov    $0x3,%eax
  802767:	e8 34 ff ff ff       	call   8026a0 <nsipc>
}
  80276c:	c9                   	leave  
  80276d:	c3                   	ret    

0080276e <nsipc_send>:
	return r;
}

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  80276e:	55                   	push   %ebp
  80276f:	89 e5                	mov    %esp,%ebp
  802771:	53                   	push   %ebx
  802772:	83 ec 14             	sub    $0x14,%esp
  802775:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  802778:	8b 45 08             	mov    0x8(%ebp),%eax
  80277b:	a3 00 60 80 00       	mov    %eax,0x806000
	assert(size < 1600);
  802780:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  802786:	7e 24                	jle    8027ac <nsipc_send+0x3e>
  802788:	c7 44 24 0c 84 3d 80 	movl   $0x803d84,0xc(%esp)
  80278f:	00 
  802790:	c7 44 24 08 90 3d 80 	movl   $0x803d90,0x8(%esp)
  802797:	00 
  802798:	c7 44 24 04 66 00 00 	movl   $0x66,0x4(%esp)
  80279f:	00 
  8027a0:	c7 04 24 a5 3d 80 00 	movl   $0x803da5,(%esp)
  8027a7:	e8 f8 de ff ff       	call   8006a4 <_panic>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  8027ac:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8027b0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8027b3:	89 44 24 04          	mov    %eax,0x4(%esp)
  8027b7:	c7 04 24 0c 60 80 00 	movl   $0x80600c,(%esp)
  8027be:	e8 22 e8 ff ff       	call   800fe5 <memmove>
	nsipcbuf.send.req_size = size;
  8027c3:	89 1d 04 60 80 00    	mov    %ebx,0x806004
	nsipcbuf.send.req_flags = flags;
  8027c9:	8b 45 14             	mov    0x14(%ebp),%eax
  8027cc:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SEND);
  8027d1:	b8 08 00 00 00       	mov    $0x8,%eax
  8027d6:	e8 c5 fe ff ff       	call   8026a0 <nsipc>
}
  8027db:	83 c4 14             	add    $0x14,%esp
  8027de:	5b                   	pop    %ebx
  8027df:	5d                   	pop    %ebp
  8027e0:	c3                   	ret    

008027e1 <nsipc_recv>:
	return nsipc(NSREQ_LISTEN);
}

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  8027e1:	55                   	push   %ebp
  8027e2:	89 e5                	mov    %esp,%ebp
  8027e4:	56                   	push   %esi
  8027e5:	53                   	push   %ebx
  8027e6:	83 ec 10             	sub    $0x10,%esp
  8027e9:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  8027ec:	8b 45 08             	mov    0x8(%ebp),%eax
  8027ef:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.recv.req_len = len;
  8027f4:	89 35 04 60 80 00    	mov    %esi,0x806004
	nsipcbuf.recv.req_flags = flags;
  8027fa:	8b 45 14             	mov    0x14(%ebp),%eax
  8027fd:	a3 08 60 80 00       	mov    %eax,0x806008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  802802:	b8 07 00 00 00       	mov    $0x7,%eax
  802807:	e8 94 fe ff ff       	call   8026a0 <nsipc>
  80280c:	89 c3                	mov    %eax,%ebx
  80280e:	85 c0                	test   %eax,%eax
  802810:	78 46                	js     802858 <nsipc_recv+0x77>
		assert(r < 1600 && r <= len);
  802812:	3d 3f 06 00 00       	cmp    $0x63f,%eax
  802817:	7f 04                	jg     80281d <nsipc_recv+0x3c>
  802819:	39 c6                	cmp    %eax,%esi
  80281b:	7d 24                	jge    802841 <nsipc_recv+0x60>
  80281d:	c7 44 24 0c b1 3d 80 	movl   $0x803db1,0xc(%esp)
  802824:	00 
  802825:	c7 44 24 08 90 3d 80 	movl   $0x803d90,0x8(%esp)
  80282c:	00 
  80282d:	c7 44 24 04 5b 00 00 	movl   $0x5b,0x4(%esp)
  802834:	00 
  802835:	c7 04 24 a5 3d 80 00 	movl   $0x803da5,(%esp)
  80283c:	e8 63 de ff ff       	call   8006a4 <_panic>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  802841:	89 44 24 08          	mov    %eax,0x8(%esp)
  802845:	c7 44 24 04 00 60 80 	movl   $0x806000,0x4(%esp)
  80284c:	00 
  80284d:	8b 45 0c             	mov    0xc(%ebp),%eax
  802850:	89 04 24             	mov    %eax,(%esp)
  802853:	e8 8d e7 ff ff       	call   800fe5 <memmove>
	}

	return r;
}
  802858:	89 d8                	mov    %ebx,%eax
  80285a:	83 c4 10             	add    $0x10,%esp
  80285d:	5b                   	pop    %ebx
  80285e:	5e                   	pop    %esi
  80285f:	5d                   	pop    %ebp
  802860:	c3                   	ret    

00802861 <nsipc_connect>:
	return nsipc(NSREQ_CLOSE);
}

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  802861:	55                   	push   %ebp
  802862:	89 e5                	mov    %esp,%ebp
  802864:	53                   	push   %ebx
  802865:	83 ec 14             	sub    $0x14,%esp
  802868:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  80286b:	8b 45 08             	mov    0x8(%ebp),%eax
  80286e:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  802873:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  802877:	8b 45 0c             	mov    0xc(%ebp),%eax
  80287a:	89 44 24 04          	mov    %eax,0x4(%esp)
  80287e:	c7 04 24 04 60 80 00 	movl   $0x806004,(%esp)
  802885:	e8 5b e7 ff ff       	call   800fe5 <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  80288a:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_CONNECT);
  802890:	b8 05 00 00 00       	mov    $0x5,%eax
  802895:	e8 06 fe ff ff       	call   8026a0 <nsipc>
}
  80289a:	83 c4 14             	add    $0x14,%esp
  80289d:	5b                   	pop    %ebx
  80289e:	5d                   	pop    %ebp
  80289f:	c3                   	ret    

008028a0 <nsipc_bind>:
	return r;
}

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  8028a0:	55                   	push   %ebp
  8028a1:	89 e5                	mov    %esp,%ebp
  8028a3:	53                   	push   %ebx
  8028a4:	83 ec 14             	sub    $0x14,%esp
  8028a7:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  8028aa:	8b 45 08             	mov    0x8(%ebp),%eax
  8028ad:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  8028b2:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8028b6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8028b9:	89 44 24 04          	mov    %eax,0x4(%esp)
  8028bd:	c7 04 24 04 60 80 00 	movl   $0x806004,(%esp)
  8028c4:	e8 1c e7 ff ff       	call   800fe5 <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  8028c9:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_BIND);
  8028cf:	b8 02 00 00 00       	mov    $0x2,%eax
  8028d4:	e8 c7 fd ff ff       	call   8026a0 <nsipc>
}
  8028d9:	83 c4 14             	add    $0x14,%esp
  8028dc:	5b                   	pop    %ebx
  8028dd:	5d                   	pop    %ebp
  8028de:	c3                   	ret    

008028df <nsipc_accept>:
	return ipc_recv(NULL, NULL, NULL);
}

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  8028df:	55                   	push   %ebp
  8028e0:	89 e5                	mov    %esp,%ebp
  8028e2:	83 ec 18             	sub    $0x18,%esp
  8028e5:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  8028e8:	89 75 fc             	mov    %esi,-0x4(%ebp)
	int r;
	
	nsipcbuf.accept.req_s = s;
  8028eb:	8b 45 08             	mov    0x8(%ebp),%eax
  8028ee:	a3 00 60 80 00       	mov    %eax,0x806000
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  8028f3:	b8 01 00 00 00       	mov    $0x1,%eax
  8028f8:	e8 a3 fd ff ff       	call   8026a0 <nsipc>
  8028fd:	89 c3                	mov    %eax,%ebx
  8028ff:	85 c0                	test   %eax,%eax
  802901:	78 25                	js     802928 <nsipc_accept+0x49>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  802903:	be 10 60 80 00       	mov    $0x806010,%esi
  802908:	8b 06                	mov    (%esi),%eax
  80290a:	89 44 24 08          	mov    %eax,0x8(%esp)
  80290e:	c7 44 24 04 00 60 80 	movl   $0x806000,0x4(%esp)
  802915:	00 
  802916:	8b 45 0c             	mov    0xc(%ebp),%eax
  802919:	89 04 24             	mov    %eax,(%esp)
  80291c:	e8 c4 e6 ff ff       	call   800fe5 <memmove>
		*addrlen = ret->ret_addrlen;
  802921:	8b 16                	mov    (%esi),%edx
  802923:	8b 45 10             	mov    0x10(%ebp),%eax
  802926:	89 10                	mov    %edx,(%eax)
	}
	return r;
}
  802928:	89 d8                	mov    %ebx,%eax
  80292a:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  80292d:	8b 75 fc             	mov    -0x4(%ebp),%esi
  802930:	89 ec                	mov    %ebp,%esp
  802932:	5d                   	pop    %ebp
  802933:	c3                   	ret    
	...

00802940 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  802940:	55                   	push   %ebp
  802941:	89 e5                	mov    %esp,%ebp
  802943:	83 ec 18             	sub    $0x18,%esp
  802946:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  802949:	89 75 fc             	mov    %esi,-0x4(%ebp)
  80294c:	8b 75 0c             	mov    0xc(%ebp),%esi
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  80294f:	8b 45 08             	mov    0x8(%ebp),%eax
  802952:	89 04 24             	mov    %eax,(%esp)
  802955:	e8 86 f2 ff ff       	call   801be0 <fd2data>
  80295a:	89 c3                	mov    %eax,%ebx
	strcpy(stat->st_name, "<pipe>");
  80295c:	c7 44 24 04 c6 3d 80 	movl   $0x803dc6,0x4(%esp)
  802963:	00 
  802964:	89 34 24             	mov    %esi,(%esp)
  802967:	e8 be e4 ff ff       	call   800e2a <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  80296c:	8b 43 04             	mov    0x4(%ebx),%eax
  80296f:	2b 03                	sub    (%ebx),%eax
  802971:	89 86 80 00 00 00    	mov    %eax,0x80(%esi)
	stat->st_isdir = 0;
  802977:	c7 86 84 00 00 00 00 	movl   $0x0,0x84(%esi)
  80297e:	00 00 00 
	stat->st_dev = &devpipe;
  802981:	c7 86 88 00 00 00 3c 	movl   $0x80703c,0x88(%esi)
  802988:	70 80 00 
	return 0;
}
  80298b:	b8 00 00 00 00       	mov    $0x0,%eax
  802990:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  802993:	8b 75 fc             	mov    -0x4(%ebp),%esi
  802996:	89 ec                	mov    %ebp,%esp
  802998:	5d                   	pop    %ebp
  802999:	c3                   	ret    

0080299a <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  80299a:	55                   	push   %ebp
  80299b:	89 e5                	mov    %esp,%ebp
  80299d:	53                   	push   %ebx
  80299e:	83 ec 14             	sub    $0x14,%esp
  8029a1:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  8029a4:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8029a8:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8029af:	e8 ab eb ff ff       	call   80155f <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  8029b4:	89 1c 24             	mov    %ebx,(%esp)
  8029b7:	e8 24 f2 ff ff       	call   801be0 <fd2data>
  8029bc:	89 44 24 04          	mov    %eax,0x4(%esp)
  8029c0:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8029c7:	e8 93 eb ff ff       	call   80155f <sys_page_unmap>
}
  8029cc:	83 c4 14             	add    $0x14,%esp
  8029cf:	5b                   	pop    %ebx
  8029d0:	5d                   	pop    %ebp
  8029d1:	c3                   	ret    

008029d2 <_pipeisclosed>:
	return r;
}

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  8029d2:	55                   	push   %ebp
  8029d3:	89 e5                	mov    %esp,%ebp
  8029d5:	57                   	push   %edi
  8029d6:	56                   	push   %esi
  8029d7:	53                   	push   %ebx
  8029d8:	83 ec 2c             	sub    $0x2c,%esp
  8029db:	89 c7                	mov    %eax,%edi
  8029dd:	89 55 e4             	mov    %edx,-0x1c(%ebp)
	int n, nn, ret;

	while (1) {
		n = env->env_runs;
  8029e0:	a1 8c 70 80 00       	mov    0x80708c,%eax
  8029e5:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  8029e8:	89 3c 24             	mov    %edi,(%esp)
  8029eb:	e8 9c 05 00 00       	call   802f8c <pageref>
  8029f0:	89 c6                	mov    %eax,%esi
  8029f2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8029f5:	89 04 24             	mov    %eax,(%esp)
  8029f8:	e8 8f 05 00 00       	call   802f8c <pageref>
  8029fd:	39 c6                	cmp    %eax,%esi
  8029ff:	0f 94 c0             	sete   %al
  802a02:	0f b6 c0             	movzbl %al,%eax
		nn = env->env_runs;
  802a05:	8b 15 8c 70 80 00    	mov    0x80708c,%edx
  802a0b:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  802a0e:	39 cb                	cmp    %ecx,%ebx
  802a10:	75 08                	jne    802a1a <_pipeisclosed+0x48>
			return ret;
		if (n != nn && ret == 1)
			cprintf("pipe race avoided\n", n, env->env_runs, ret);
	}
}
  802a12:	83 c4 2c             	add    $0x2c,%esp
  802a15:	5b                   	pop    %ebx
  802a16:	5e                   	pop    %esi
  802a17:	5f                   	pop    %edi
  802a18:	5d                   	pop    %ebp
  802a19:	c3                   	ret    
		n = env->env_runs;
		ret = pageref(fd) == pageref(p);
		nn = env->env_runs;
		if (n == nn)
			return ret;
		if (n != nn && ret == 1)
  802a1a:	83 f8 01             	cmp    $0x1,%eax
  802a1d:	75 c1                	jne    8029e0 <_pipeisclosed+0xe>
			cprintf("pipe race avoided\n", n, env->env_runs, ret);
  802a1f:	8b 52 58             	mov    0x58(%edx),%edx
  802a22:	89 44 24 0c          	mov    %eax,0xc(%esp)
  802a26:	89 54 24 08          	mov    %edx,0x8(%esp)
  802a2a:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  802a2e:	c7 04 24 cd 3d 80 00 	movl   $0x803dcd,(%esp)
  802a35:	e8 2f dd ff ff       	call   800769 <cprintf>
  802a3a:	eb a4                	jmp    8029e0 <_pipeisclosed+0xe>

00802a3c <devpipe_write>:
	return i;
}

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  802a3c:	55                   	push   %ebp
  802a3d:	89 e5                	mov    %esp,%ebp
  802a3f:	57                   	push   %edi
  802a40:	56                   	push   %esi
  802a41:	53                   	push   %ebx
  802a42:	83 ec 1c             	sub    $0x1c,%esp
  802a45:	8b 75 08             	mov    0x8(%ebp),%esi
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  802a48:	89 34 24             	mov    %esi,(%esp)
  802a4b:	e8 90 f1 ff ff       	call   801be0 <fd2data>
  802a50:	89 c3                	mov    %eax,%ebx
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			env->env_id, vpt[VPN(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  802a52:	bf 00 00 00 00       	mov    $0x0,%edi
  802a57:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  802a5b:	75 54                	jne    802ab1 <devpipe_write+0x75>
  802a5d:	eb 60                	jmp    802abf <devpipe_write+0x83>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  802a5f:	89 da                	mov    %ebx,%edx
  802a61:	89 f0                	mov    %esi,%eax
  802a63:	e8 6a ff ff ff       	call   8029d2 <_pipeisclosed>
  802a68:	85 c0                	test   %eax,%eax
  802a6a:	74 07                	je     802a73 <devpipe_write+0x37>
  802a6c:	b8 00 00 00 00       	mov    $0x0,%eax
  802a71:	eb 53                	jmp    802ac6 <devpipe_write+0x8a>
				return 0;
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  802a73:	90                   	nop
  802a74:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802a78:	e8 fd eb ff ff       	call   80167a <sys_yield>
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			env->env_id, vpt[VPN(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  802a7d:	8b 43 04             	mov    0x4(%ebx),%eax
  802a80:	8b 13                	mov    (%ebx),%edx
  802a82:	83 c2 20             	add    $0x20,%edx
  802a85:	39 d0                	cmp    %edx,%eax
  802a87:	73 d6                	jae    802a5f <devpipe_write+0x23>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  802a89:	89 c2                	mov    %eax,%edx
  802a8b:	c1 fa 1f             	sar    $0x1f,%edx
  802a8e:	c1 ea 1b             	shr    $0x1b,%edx
  802a91:	01 d0                	add    %edx,%eax
  802a93:	83 e0 1f             	and    $0x1f,%eax
  802a96:	29 d0                	sub    %edx,%eax
  802a98:	89 c2                	mov    %eax,%edx
  802a9a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  802a9d:	0f b6 04 39          	movzbl (%ecx,%edi,1),%eax
  802aa1:	88 44 13 08          	mov    %al,0x8(%ebx,%edx,1)
		p->p_wpos++;
  802aa5:	83 43 04 01          	addl   $0x1,0x4(%ebx)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			env->env_id, vpt[VPN(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  802aa9:	83 c7 01             	add    $0x1,%edi
  802aac:	39 7d 10             	cmp    %edi,0x10(%ebp)
  802aaf:	76 13                	jbe    802ac4 <devpipe_write+0x88>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  802ab1:	8b 43 04             	mov    0x4(%ebx),%eax
  802ab4:	8b 13                	mov    (%ebx),%edx
  802ab6:	83 c2 20             	add    $0x20,%edx
  802ab9:	39 d0                	cmp    %edx,%eax
  802abb:	73 a2                	jae    802a5f <devpipe_write+0x23>
  802abd:	eb ca                	jmp    802a89 <devpipe_write+0x4d>
  802abf:	bf 00 00 00 00       	mov    $0x0,%edi
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}
	
	return i;
  802ac4:	89 f8                	mov    %edi,%eax
}
  802ac6:	83 c4 1c             	add    $0x1c,%esp
  802ac9:	5b                   	pop    %ebx
  802aca:	5e                   	pop    %esi
  802acb:	5f                   	pop    %edi
  802acc:	5d                   	pop    %ebp
  802acd:	c3                   	ret    

00802ace <devpipe_read>:
	return _pipeisclosed(fd, p);
}

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  802ace:	55                   	push   %ebp
  802acf:	89 e5                	mov    %esp,%ebp
  802ad1:	83 ec 28             	sub    $0x28,%esp
  802ad4:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  802ad7:	89 75 f8             	mov    %esi,-0x8(%ebp)
  802ada:	89 7d fc             	mov    %edi,-0x4(%ebp)
  802add:	8b 7d 08             	mov    0x8(%ebp),%edi
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  802ae0:	89 3c 24             	mov    %edi,(%esp)
  802ae3:	e8 f8 f0 ff ff       	call   801be0 <fd2data>
  802ae8:	89 c3                	mov    %eax,%ebx
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			env->env_id, vpt[VPN(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  802aea:	be 00 00 00 00       	mov    $0x0,%esi
  802aef:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  802af3:	75 4c                	jne    802b41 <devpipe_read+0x73>
  802af5:	eb 5b                	jmp    802b52 <devpipe_read+0x84>
		while (p->p_rpos == p->p_wpos) {
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
				return i;
  802af7:	89 f0                	mov    %esi,%eax
  802af9:	eb 5e                	jmp    802b59 <devpipe_read+0x8b>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  802afb:	89 da                	mov    %ebx,%edx
  802afd:	89 f8                	mov    %edi,%eax
  802aff:	90                   	nop
  802b00:	e8 cd fe ff ff       	call   8029d2 <_pipeisclosed>
  802b05:	85 c0                	test   %eax,%eax
  802b07:	74 07                	je     802b10 <devpipe_read+0x42>
  802b09:	b8 00 00 00 00       	mov    $0x0,%eax
  802b0e:	eb 49                	jmp    802b59 <devpipe_read+0x8b>
				return 0;
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  802b10:	e8 65 eb ff ff       	call   80167a <sys_yield>
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			env->env_id, vpt[VPN(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  802b15:	8b 03                	mov    (%ebx),%eax
  802b17:	3b 43 04             	cmp    0x4(%ebx),%eax
  802b1a:	74 df                	je     802afb <devpipe_read+0x2d>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  802b1c:	89 c2                	mov    %eax,%edx
  802b1e:	c1 fa 1f             	sar    $0x1f,%edx
  802b21:	c1 ea 1b             	shr    $0x1b,%edx
  802b24:	01 d0                	add    %edx,%eax
  802b26:	83 e0 1f             	and    $0x1f,%eax
  802b29:	29 d0                	sub    %edx,%eax
  802b2b:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  802b30:	8b 55 0c             	mov    0xc(%ebp),%edx
  802b33:	88 04 32             	mov    %al,(%edx,%esi,1)
		p->p_rpos++;
  802b36:	83 03 01             	addl   $0x1,(%ebx)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			env->env_id, vpt[VPN(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  802b39:	83 c6 01             	add    $0x1,%esi
  802b3c:	39 75 10             	cmp    %esi,0x10(%ebp)
  802b3f:	76 16                	jbe    802b57 <devpipe_read+0x89>
		while (p->p_rpos == p->p_wpos) {
  802b41:	8b 03                	mov    (%ebx),%eax
  802b43:	3b 43 04             	cmp    0x4(%ebx),%eax
  802b46:	75 d4                	jne    802b1c <devpipe_read+0x4e>
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  802b48:	85 f6                	test   %esi,%esi
  802b4a:	75 ab                	jne    802af7 <devpipe_read+0x29>
  802b4c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802b50:	eb a9                	jmp    802afb <devpipe_read+0x2d>
  802b52:	be 00 00 00 00       	mov    $0x0,%esi
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  802b57:	89 f0                	mov    %esi,%eax
}
  802b59:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  802b5c:	8b 75 f8             	mov    -0x8(%ebp),%esi
  802b5f:	8b 7d fc             	mov    -0x4(%ebp),%edi
  802b62:	89 ec                	mov    %ebp,%esp
  802b64:	5d                   	pop    %ebp
  802b65:	c3                   	ret    

00802b66 <pipeisclosed>:
	}
}

int
pipeisclosed(int fdnum)
{
  802b66:	55                   	push   %ebp
  802b67:	89 e5                	mov    %esp,%ebp
  802b69:	83 ec 28             	sub    $0x28,%esp
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802b6c:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802b6f:	89 44 24 04          	mov    %eax,0x4(%esp)
  802b73:	8b 45 08             	mov    0x8(%ebp),%eax
  802b76:	89 04 24             	mov    %eax,(%esp)
  802b79:	e8 ef f0 ff ff       	call   801c6d <fd_lookup>
  802b7e:	85 c0                	test   %eax,%eax
  802b80:	78 15                	js     802b97 <pipeisclosed+0x31>
		return r;
	p = (struct Pipe*) fd2data(fd);
  802b82:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b85:	89 04 24             	mov    %eax,(%esp)
  802b88:	e8 53 f0 ff ff       	call   801be0 <fd2data>
	return _pipeisclosed(fd, p);
  802b8d:	89 c2                	mov    %eax,%edx
  802b8f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b92:	e8 3b fe ff ff       	call   8029d2 <_pipeisclosed>
}
  802b97:	c9                   	leave  
  802b98:	c3                   	ret    

00802b99 <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  802b99:	55                   	push   %ebp
  802b9a:	89 e5                	mov    %esp,%ebp
  802b9c:	83 ec 48             	sub    $0x48,%esp
  802b9f:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  802ba2:	89 75 f8             	mov    %esi,-0x8(%ebp)
  802ba5:	89 7d fc             	mov    %edi,-0x4(%ebp)
  802ba8:	8b 7d 08             	mov    0x8(%ebp),%edi
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  802bab:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  802bae:	89 04 24             	mov    %eax,(%esp)
  802bb1:	e8 45 f0 ff ff       	call   801bfb <fd_alloc>
  802bb6:	89 c3                	mov    %eax,%ebx
  802bb8:	85 c0                	test   %eax,%eax
  802bba:	0f 88 42 01 00 00    	js     802d02 <pipe+0x169>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802bc0:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  802bc7:	00 
  802bc8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802bcb:	89 44 24 04          	mov    %eax,0x4(%esp)
  802bcf:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802bd6:	e8 40 ea ff ff       	call   80161b <sys_page_alloc>
  802bdb:	89 c3                	mov    %eax,%ebx
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  802bdd:	85 c0                	test   %eax,%eax
  802bdf:	0f 88 1d 01 00 00    	js     802d02 <pipe+0x169>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  802be5:	8d 45 e0             	lea    -0x20(%ebp),%eax
  802be8:	89 04 24             	mov    %eax,(%esp)
  802beb:	e8 0b f0 ff ff       	call   801bfb <fd_alloc>
  802bf0:	89 c3                	mov    %eax,%ebx
  802bf2:	85 c0                	test   %eax,%eax
  802bf4:	0f 88 f5 00 00 00    	js     802cef <pipe+0x156>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802bfa:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  802c01:	00 
  802c02:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802c05:	89 44 24 04          	mov    %eax,0x4(%esp)
  802c09:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802c10:	e8 06 ea ff ff       	call   80161b <sys_page_alloc>
  802c15:	89 c3                	mov    %eax,%ebx
	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  802c17:	85 c0                	test   %eax,%eax
  802c19:	0f 88 d0 00 00 00    	js     802cef <pipe+0x156>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  802c1f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802c22:	89 04 24             	mov    %eax,(%esp)
  802c25:	e8 b6 ef ff ff       	call   801be0 <fd2data>
  802c2a:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802c2c:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  802c33:	00 
  802c34:	89 44 24 04          	mov    %eax,0x4(%esp)
  802c38:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802c3f:	e8 d7 e9 ff ff       	call   80161b <sys_page_alloc>
  802c44:	89 c3                	mov    %eax,%ebx
  802c46:	85 c0                	test   %eax,%eax
  802c48:	0f 88 8e 00 00 00    	js     802cdc <pipe+0x143>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802c4e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802c51:	89 04 24             	mov    %eax,(%esp)
  802c54:	e8 87 ef ff ff       	call   801be0 <fd2data>
  802c59:	c7 44 24 10 07 04 00 	movl   $0x407,0x10(%esp)
  802c60:	00 
  802c61:	89 44 24 0c          	mov    %eax,0xc(%esp)
  802c65:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  802c6c:	00 
  802c6d:	89 74 24 04          	mov    %esi,0x4(%esp)
  802c71:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802c78:	e8 40 e9 ff ff       	call   8015bd <sys_page_map>
  802c7d:	89 c3                	mov    %eax,%ebx
  802c7f:	85 c0                	test   %eax,%eax
  802c81:	78 49                	js     802ccc <pipe+0x133>
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  802c83:	b8 3c 70 80 00       	mov    $0x80703c,%eax
  802c88:	8b 08                	mov    (%eax),%ecx
  802c8a:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802c8d:	89 0a                	mov    %ecx,(%edx)
	fd0->fd_omode = O_RDONLY;
  802c8f:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802c92:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%edx)

	fd1->fd_dev_id = devpipe.dev_id;
  802c99:	8b 10                	mov    (%eax),%edx
  802c9b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802c9e:	89 10                	mov    %edx,(%eax)
	fd1->fd_omode = O_WRONLY;
  802ca0:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802ca3:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", env->env_id, vpt[VPN(va)]);

	pfd[0] = fd2num(fd0);
  802caa:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802cad:	89 04 24             	mov    %eax,(%esp)
  802cb0:	e8 1b ef ff ff       	call   801bd0 <fd2num>
  802cb5:	89 07                	mov    %eax,(%edi)
	pfd[1] = fd2num(fd1);
  802cb7:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802cba:	89 04 24             	mov    %eax,(%esp)
  802cbd:	e8 0e ef ff ff       	call   801bd0 <fd2num>
  802cc2:	89 47 04             	mov    %eax,0x4(%edi)
  802cc5:	bb 00 00 00 00       	mov    $0x0,%ebx
	return 0;
  802cca:	eb 36                	jmp    802d02 <pipe+0x169>

    err3:
	sys_page_unmap(0, va);
  802ccc:	89 74 24 04          	mov    %esi,0x4(%esp)
  802cd0:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802cd7:	e8 83 e8 ff ff       	call   80155f <sys_page_unmap>
    err2:
	sys_page_unmap(0, fd1);
  802cdc:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802cdf:	89 44 24 04          	mov    %eax,0x4(%esp)
  802ce3:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802cea:	e8 70 e8 ff ff       	call   80155f <sys_page_unmap>
    err1:
	sys_page_unmap(0, fd0);
  802cef:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802cf2:	89 44 24 04          	mov    %eax,0x4(%esp)
  802cf6:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802cfd:	e8 5d e8 ff ff       	call   80155f <sys_page_unmap>
    err:
	return r;
}
  802d02:	89 d8                	mov    %ebx,%eax
  802d04:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  802d07:	8b 75 f8             	mov    -0x8(%ebp),%esi
  802d0a:	8b 7d fc             	mov    -0x4(%ebp),%edi
  802d0d:	89 ec                	mov    %ebp,%esp
  802d0f:	5d                   	pop    %ebp
  802d10:	c3                   	ret    
	...

00802d20 <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  802d20:	55                   	push   %ebp
  802d21:	89 e5                	mov    %esp,%ebp
	USED(fd);

	return 0;
}
  802d23:	b8 00 00 00 00       	mov    $0x0,%eax
  802d28:	5d                   	pop    %ebp
  802d29:	c3                   	ret    

00802d2a <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  802d2a:	55                   	push   %ebp
  802d2b:	89 e5                	mov    %esp,%ebp
  802d2d:	83 ec 18             	sub    $0x18,%esp
	strcpy(stat->st_name, "<cons>");
  802d30:	c7 44 24 04 e5 3d 80 	movl   $0x803de5,0x4(%esp)
  802d37:	00 
  802d38:	8b 45 0c             	mov    0xc(%ebp),%eax
  802d3b:	89 04 24             	mov    %eax,(%esp)
  802d3e:	e8 e7 e0 ff ff       	call   800e2a <strcpy>
	return 0;
}
  802d43:	b8 00 00 00 00       	mov    $0x0,%eax
  802d48:	c9                   	leave  
  802d49:	c3                   	ret    

00802d4a <devcons_write>:
	return 1;
}

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  802d4a:	55                   	push   %ebp
  802d4b:	89 e5                	mov    %esp,%ebp
  802d4d:	57                   	push   %edi
  802d4e:	56                   	push   %esi
  802d4f:	53                   	push   %ebx
  802d50:	81 ec 9c 00 00 00    	sub    $0x9c,%esp
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs, 
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  802d56:	b8 00 00 00 00       	mov    $0x0,%eax
  802d5b:	be 00 00 00 00       	mov    $0x0,%esi
  802d60:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  802d64:	74 3f                	je     802da5 <devcons_write+0x5b>
		m = n - tot;
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  802d66:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs, 
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
		m = n - tot;
  802d6c:	8b 55 10             	mov    0x10(%ebp),%edx
  802d6f:	29 c2                	sub    %eax,%edx
  802d71:	89 d3                	mov    %edx,%ebx
		if (m > sizeof(buf) - 1)
  802d73:	83 fa 7f             	cmp    $0x7f,%edx
  802d76:	76 05                	jbe    802d7d <devcons_write+0x33>
  802d78:	bb 7f 00 00 00       	mov    $0x7f,%ebx
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  802d7d:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  802d81:	03 45 0c             	add    0xc(%ebp),%eax
  802d84:	89 44 24 04          	mov    %eax,0x4(%esp)
  802d88:	89 3c 24             	mov    %edi,(%esp)
  802d8b:	e8 55 e2 ff ff       	call   800fe5 <memmove>
		sys_cputs(buf, m);
  802d90:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  802d94:	89 3c 24             	mov    %edi,(%esp)
  802d97:	e8 84 e4 ff ff       	call   801220 <sys_cputs>
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs, 
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  802d9c:	01 de                	add    %ebx,%esi
  802d9e:	89 f0                	mov    %esi,%eax
  802da0:	3b 75 10             	cmp    0x10(%ebp),%esi
  802da3:	72 c7                	jb     802d6c <devcons_write+0x22>
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
}
  802da5:	89 f0                	mov    %esi,%eax
  802da7:	81 c4 9c 00 00 00    	add    $0x9c,%esp
  802dad:	5b                   	pop    %ebx
  802dae:	5e                   	pop    %esi
  802daf:	5f                   	pop    %edi
  802db0:	5d                   	pop    %ebp
  802db1:	c3                   	ret    

00802db2 <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  802db2:	55                   	push   %ebp
  802db3:	89 e5                	mov    %esp,%ebp
  802db5:	83 ec 28             	sub    $0x28,%esp
	char c = ch;
  802db8:	8b 45 08             	mov    0x8(%ebp),%eax
  802dbb:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  802dbe:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  802dc5:	00 
  802dc6:	8d 45 f7             	lea    -0x9(%ebp),%eax
  802dc9:	89 04 24             	mov    %eax,(%esp)
  802dcc:	e8 4f e4 ff ff       	call   801220 <sys_cputs>
}
  802dd1:	c9                   	leave  
  802dd2:	c3                   	ret    

00802dd3 <devcons_read>:
	return fd2num(fd);
}

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  802dd3:	55                   	push   %ebp
  802dd4:	89 e5                	mov    %esp,%ebp
  802dd6:	83 ec 08             	sub    $0x8,%esp
	int c;

	if (n == 0)
  802dd9:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  802ddd:	75 07                	jne    802de6 <devcons_read+0x13>
  802ddf:	eb 28                	jmp    802e09 <devcons_read+0x36>
		return 0;

	while ((c = sys_cgetc()) == 0)
		sys_yield();
  802de1:	e8 94 e8 ff ff       	call   80167a <sys_yield>
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  802de6:	66 90                	xchg   %ax,%ax
  802de8:	e8 ff e3 ff ff       	call   8011ec <sys_cgetc>
  802ded:	85 c0                	test   %eax,%eax
  802def:	90                   	nop
  802df0:	74 ef                	je     802de1 <devcons_read+0xe>
  802df2:	89 c2                	mov    %eax,%edx
		sys_yield();
	if (c < 0)
  802df4:	85 c0                	test   %eax,%eax
  802df6:	78 16                	js     802e0e <devcons_read+0x3b>
		return c;
	if (c == 0x04)	// ctl-d is eof
  802df8:	83 f8 04             	cmp    $0x4,%eax
  802dfb:	74 0c                	je     802e09 <devcons_read+0x36>
		return 0;
	*(char*)vbuf = c;
  802dfd:	8b 45 0c             	mov    0xc(%ebp),%eax
  802e00:	88 10                	mov    %dl,(%eax)
  802e02:	b8 01 00 00 00       	mov    $0x1,%eax
	return 1;
  802e07:	eb 05                	jmp    802e0e <devcons_read+0x3b>
  802e09:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802e0e:	c9                   	leave  
  802e0f:	c3                   	ret    

00802e10 <opencons>:
	return fd->fd_dev_id == devcons.dev_id;
}

int
opencons(void)
{
  802e10:	55                   	push   %ebp
  802e11:	89 e5                	mov    %esp,%ebp
  802e13:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  802e16:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802e19:	89 04 24             	mov    %eax,(%esp)
  802e1c:	e8 da ed ff ff       	call   801bfb <fd_alloc>
  802e21:	85 c0                	test   %eax,%eax
  802e23:	78 3f                	js     802e64 <opencons+0x54>
		return r;
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  802e25:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  802e2c:	00 
  802e2d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e30:	89 44 24 04          	mov    %eax,0x4(%esp)
  802e34:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802e3b:	e8 db e7 ff ff       	call   80161b <sys_page_alloc>
  802e40:	85 c0                	test   %eax,%eax
  802e42:	78 20                	js     802e64 <opencons+0x54>
		return r;
	fd->fd_dev_id = devcons.dev_id;
  802e44:	8b 15 58 70 80 00    	mov    0x807058,%edx
  802e4a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e4d:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  802e4f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e52:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  802e59:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e5c:	89 04 24             	mov    %eax,(%esp)
  802e5f:	e8 6c ed ff ff       	call   801bd0 <fd2num>
}
  802e64:	c9                   	leave  
  802e65:	c3                   	ret    

00802e66 <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  802e66:	55                   	push   %ebp
  802e67:	89 e5                	mov    %esp,%ebp
  802e69:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802e6c:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802e6f:	89 44 24 04          	mov    %eax,0x4(%esp)
  802e73:	8b 45 08             	mov    0x8(%ebp),%eax
  802e76:	89 04 24             	mov    %eax,(%esp)
  802e79:	e8 ef ed ff ff       	call   801c6d <fd_lookup>
  802e7e:	85 c0                	test   %eax,%eax
  802e80:	78 11                	js     802e93 <iscons+0x2d>
		return r;
	return fd->fd_dev_id == devcons.dev_id;
  802e82:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e85:	8b 00                	mov    (%eax),%eax
  802e87:	3b 05 58 70 80 00    	cmp    0x807058,%eax
  802e8d:	0f 94 c0             	sete   %al
  802e90:	0f b6 c0             	movzbl %al,%eax
}
  802e93:	c9                   	leave  
  802e94:	c3                   	ret    

00802e95 <getchar>:
	sys_cputs(&c, 1);
}

int
getchar(void)
{
  802e95:	55                   	push   %ebp
  802e96:	89 e5                	mov    %esp,%ebp
  802e98:	83 ec 28             	sub    $0x28,%esp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  802e9b:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  802ea2:	00 
  802ea3:	8d 45 f7             	lea    -0x9(%ebp),%eax
  802ea6:	89 44 24 04          	mov    %eax,0x4(%esp)
  802eaa:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802eb1:	e8 18 f0 ff ff       	call   801ece <read>
	if (r < 0)
  802eb6:	85 c0                	test   %eax,%eax
  802eb8:	78 0f                	js     802ec9 <getchar+0x34>
		return r;
	if (r < 1)
  802eba:	85 c0                	test   %eax,%eax
  802ebc:	7f 07                	jg     802ec5 <getchar+0x30>
  802ebe:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  802ec3:	eb 04                	jmp    802ec9 <getchar+0x34>
		return -E_EOF;
	return c;
  802ec5:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  802ec9:	c9                   	leave  
  802eca:	c3                   	ret    
	...

00802ecc <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  802ecc:	55                   	push   %ebp
  802ecd:	89 e5                	mov    %esp,%ebp
  802ecf:	83 ec 18             	sub    $0x18,%esp
	int r;

	if (_pgfault_handler == 0) {
  802ed2:	83 3d 94 70 80 00 00 	cmpl   $0x0,0x807094
  802ed9:	75 78                	jne    802f53 <set_pgfault_handler+0x87>
		// First time through!
		// LAB 4: Your code here.
		// panic("set_pgfault_handler not implemented");
		int ret;	
		if ((ret = sys_page_alloc(0, (void*)(UXSTACKTOP - PGSIZE), PTE_U | PTE_P | PTE_W)) < 0)
  802edb:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  802ee2:	00 
  802ee3:	c7 44 24 04 00 f0 bf 	movl   $0xeebff000,0x4(%esp)
  802eea:	ee 
  802eeb:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802ef2:	e8 24 e7 ff ff       	call   80161b <sys_page_alloc>
  802ef7:	85 c0                	test   %eax,%eax
  802ef9:	79 20                	jns    802f1b <set_pgfault_handler+0x4f>
			panic (" error in sys_page_alloc: %e\n", ret);
  802efb:	89 44 24 0c          	mov    %eax,0xc(%esp)
  802eff:	c7 44 24 08 f1 3d 80 	movl   $0x803df1,0x8(%esp)
  802f06:	00 
  802f07:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  802f0e:	00 
  802f0f:	c7 04 24 0f 3e 80 00 	movl   $0x803e0f,(%esp)
  802f16:	e8 89 d7 ff ff       	call   8006a4 <_panic>
		if ((ret = sys_env_set_pgfault_upcall(0, _pgfault_upcall)) < 0)
  802f1b:	c7 44 24 04 60 2f 80 	movl   $0x802f60,0x4(%esp)
  802f22:	00 
  802f23:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802f2a:	e8 16 e5 ff ff       	call   801445 <sys_env_set_pgfault_upcall>
  802f2f:	85 c0                	test   %eax,%eax
  802f31:	79 20                	jns    802f53 <set_pgfault_handler+0x87>
			panic (" error in sys_env_set_pgfault_upcall: %e\n", ret);
  802f33:	89 44 24 0c          	mov    %eax,0xc(%esp)
  802f37:	c7 44 24 08 20 3e 80 	movl   $0x803e20,0x8(%esp)
  802f3e:	00 
  802f3f:	c7 44 24 04 25 00 00 	movl   $0x25,0x4(%esp)
  802f46:	00 
  802f47:	c7 04 24 0f 3e 80 00 	movl   $0x803e0f,(%esp)
  802f4e:	e8 51 d7 ff ff       	call   8006a4 <_panic>
	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  802f53:	8b 45 08             	mov    0x8(%ebp),%eax
  802f56:	a3 94 70 80 00       	mov    %eax,0x807094
	
}
  802f5b:	c9                   	leave  
  802f5c:	c3                   	ret    
  802f5d:	00 00                	add    %al,(%eax)
	...

00802f60 <_pgfault_upcall>:

.text
.globl _pgfault_upcall
_pgfault_upcall:
	// Call the C page fault handler.
	pushl %esp			// function argument: pointer to UTF
  802f60:	54                   	push   %esp
	movl _pgfault_handler, %eax
  802f61:	a1 94 70 80 00       	mov    0x807094,%eax
	call *%eax
  802f66:	ff d0                	call   *%eax
	addl $4, %esp			// pop function argument
  802f68:	83 c4 04             	add    $0x4,%esp
	// may find that you have to rearrange your code in non-obvious
	// ways as registers become unavailable as scratch space.
	//
	// LAB 4: Your code here.
	
	movl %esp, %ecx			// back up esp to ecx
  802f6b:	89 e1                	mov    %esp,%ecx
	movl 0x28(%esp), %ebx		// store trap-time eip into ebx
  802f6d:	8b 5c 24 28          	mov    0x28(%esp),%ebx
	movl 0x30(%esp), %edx		// store trap-time esp into edx
  802f71:	8b 54 24 30          	mov    0x30(%esp),%edx
	movl %edx, %esp			// switch to trap-time stack
  802f75:	89 d4                	mov    %edx,%esp
	pushl %ebx			// push trap-time eip here
  802f77:	53                   	push   %ebx
	movl %ecx, %esp			// come back to user exception stack
  802f78:	89 cc                	mov    %ecx,%esp
	
	// for the push made above, update the trap-time esp value in this user exception stack
	// this enables popl %esp to cause esp point to the adjusted trap-time stack 
	subl $0x4, %edx			
  802f7a:	83 ea 04             	sub    $0x4,%edx
	movl %edx, 0x30(%esp)
  802f7d:	89 54 24 30          	mov    %edx,0x30(%esp)
	

	// Restore the trap-time registers.  After you do this, you
	// can no longer modify any general-purpose registers.
	// LAB 4: Your code here.
	addl $0x8, %esp
  802f81:	83 c4 08             	add    $0x8,%esp
	popal
  802f84:	61                   	popa   
	// Restore eflags from the stack.  After you do this, you can
	// no longer use arithmetic operations or anything else that
	// modifies eflags.
	// LAB 4: Your code here.
	
	addl $0x4, %esp
  802f85:	83 c4 04             	add    $0x4,%esp
	popfl
  802f88:	9d                   	popf   

	// Switch back to the adjusted trap-time stack.
	// LAB 4: Your code here.

	popl %esp
  802f89:	5c                   	pop    %esp

	// Return to re-execute the instruction that faulted.
	// LAB 4: Your code here.
	
	ret
  802f8a:	c3                   	ret    
	...

00802f8c <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  802f8c:	55                   	push   %ebp
  802f8d:	89 e5                	mov    %esp,%ebp
	pte_t pte;

	if (!(vpd[PDX(v)] & PTE_P))
  802f8f:	8b 45 08             	mov    0x8(%ebp),%eax
  802f92:	89 c2                	mov    %eax,%edx
  802f94:	c1 ea 16             	shr    $0x16,%edx
  802f97:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  802f9e:	f6 c2 01             	test   $0x1,%dl
  802fa1:	74 26                	je     802fc9 <pageref+0x3d>
		return 0;
	pte = vpt[VPN(v)];
  802fa3:	c1 e8 0c             	shr    $0xc,%eax
  802fa6:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
	if (!(pte & PTE_P))
  802fad:	a8 01                	test   $0x1,%al
  802faf:	74 18                	je     802fc9 <pageref+0x3d>
		return 0;
	return pages[PPN(pte)].pp_ref;
  802fb1:	c1 e8 0c             	shr    $0xc,%eax
  802fb4:	8d 14 40             	lea    (%eax,%eax,2),%edx
  802fb7:	c1 e2 02             	shl    $0x2,%edx
  802fba:	b8 00 00 00 ef       	mov    $0xef000000,%eax
  802fbf:	0f b7 44 02 08       	movzwl 0x8(%edx,%eax,1),%eax
  802fc4:	0f b7 c0             	movzwl %ax,%eax
  802fc7:	eb 05                	jmp    802fce <pageref+0x42>
  802fc9:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802fce:	5d                   	pop    %ebp
  802fcf:	c3                   	ret    

00802fd0 <inet_ntoa>:
 * @return pointer to a global static (!) buffer that holds the ASCII
 *         represenation of addr
 */
char *
inet_ntoa(struct in_addr addr)
{
  802fd0:	55                   	push   %ebp
  802fd1:	89 e5                	mov    %esp,%ebp
  802fd3:	57                   	push   %edi
  802fd4:	56                   	push   %esi
  802fd5:	53                   	push   %ebx
  802fd6:	83 ec 1c             	sub    $0x1c,%esp
  static char str[16];
  u32_t s_addr = addr.s_addr;
  802fd9:	8b 45 08             	mov    0x8(%ebp),%eax
  802fdc:	89 45 f0             	mov    %eax,-0x10(%ebp)
  u8_t rem;
  u8_t n;
  u8_t i;

  rp = str;
  ap = (u8_t *)&s_addr;
  802fdf:	8d 45 f0             	lea    -0x10(%ebp),%eax
  802fe2:	89 45 e0             	mov    %eax,-0x20(%ebp)
 * @param addr ip address in network order to convert
 * @return pointer to a global static (!) buffer that holds the ASCII
 *         represenation of addr
 */
char *
inet_ntoa(struct in_addr addr)
  802fe5:	8d 45 f3             	lea    -0xd(%ebp),%eax
  802fe8:	89 45 d8             	mov    %eax,-0x28(%ebp)
  802feb:	b9 7c 70 80 00       	mov    $0x80707c,%ecx
  rp = str;
  ap = (u8_t *)&s_addr;
  for(n = 0; n < 4; n++) {
    i = 0;
    do {
      rem = *ap % (u8_t)10;
  802ff0:	ba cd ff ff ff       	mov    $0xffffffcd,%edx
 * @param addr ip address in network order to convert
 * @return pointer to a global static (!) buffer that holds the ASCII
 *         represenation of addr
 */
char *
inet_ntoa(struct in_addr addr)
  802ff5:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802ff8:	0f b6 18             	movzbl (%eax),%ebx
  802ffb:	be 00 00 00 00       	mov    $0x0,%esi
  803000:	89 f0                	mov    %esi,%eax
  803002:	89 ce                	mov    %ecx,%esi
  803004:	89 c1                	mov    %eax,%ecx
  rp = str;
  ap = (u8_t *)&s_addr;
  for(n = 0; n < 4; n++) {
    i = 0;
    do {
      rem = *ap % (u8_t)10;
  803006:	89 d8                	mov    %ebx,%eax
  803008:	f6 e2                	mul    %dl
  80300a:	66 c1 e8 08          	shr    $0x8,%ax
  80300e:	c0 e8 03             	shr    $0x3,%al
  803011:	89 c7                	mov    %eax,%edi
  803013:	8d 04 80             	lea    (%eax,%eax,4),%eax
  803016:	01 c0                	add    %eax,%eax
  803018:	28 c3                	sub    %al,%bl
  80301a:	89 d8                	mov    %ebx,%eax
      *ap /= (u8_t)10;
  80301c:	89 fb                	mov    %edi,%ebx
      inv[i++] = '0' + rem;
  80301e:	0f b6 f9             	movzbl %cl,%edi
  803021:	83 c0 30             	add    $0x30,%eax
  803024:	88 44 3d ed          	mov    %al,-0x13(%ebp,%edi,1)
  803028:	83 c1 01             	add    $0x1,%ecx
    } while(*ap);
  80302b:	84 db                	test   %bl,%bl
  80302d:	75 d7                	jne    803006 <inet_ntoa+0x36>
  80302f:	89 c8                	mov    %ecx,%eax
  803031:	89 f1                	mov    %esi,%ecx
  803033:	89 c6                	mov    %eax,%esi
  803035:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803038:	88 18                	mov    %bl,(%eax)
    while(i--)
  80303a:	89 f0                	mov    %esi,%eax
  80303c:	84 c0                	test   %al,%al
  80303e:	74 2c                	je     80306c <inet_ntoa+0x9c>
  803040:	8d 5e ff             	lea    -0x1(%esi),%ebx
 * @param addr ip address in network order to convert
 * @return pointer to a global static (!) buffer that holds the ASCII
 *         represenation of addr
 */
char *
inet_ntoa(struct in_addr addr)
  803043:	0f b6 c3             	movzbl %bl,%eax
  803046:	89 45 dc             	mov    %eax,-0x24(%ebp)
  803049:	8d 7c 01 01          	lea    0x1(%ecx,%eax,1),%edi
  80304d:	89 c8                	mov    %ecx,%eax
  80304f:	89 ce                	mov    %ecx,%esi
      rem = *ap % (u8_t)10;
      *ap /= (u8_t)10;
      inv[i++] = '0' + rem;
    } while(*ap);
    while(i--)
      *rp++ = inv[i];
  803051:	0f b6 cb             	movzbl %bl,%ecx
  803054:	0f b6 4c 0d ed       	movzbl -0x13(%ebp,%ecx,1),%ecx
  803059:	88 08                	mov    %cl,(%eax)
  80305b:	83 c0 01             	add    $0x1,%eax
    do {
      rem = *ap % (u8_t)10;
      *ap /= (u8_t)10;
      inv[i++] = '0' + rem;
    } while(*ap);
    while(i--)
  80305e:	83 eb 01             	sub    $0x1,%ebx
  803061:	39 f8                	cmp    %edi,%eax
  803063:	75 ec                	jne    803051 <inet_ntoa+0x81>
  803065:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803068:	8d 4c 06 01          	lea    0x1(%esi,%eax,1),%ecx
      *rp++ = inv[i];
    *rp++ = '.';
  80306c:	c6 01 2e             	movb   $0x2e,(%ecx)
  80306f:	83 c1 01             	add    $0x1,%ecx
  u8_t n;
  u8_t i;

  rp = str;
  ap = (u8_t *)&s_addr;
  for(n = 0; n < 4; n++) {
  803072:	8b 45 d8             	mov    -0x28(%ebp),%eax
  803075:	39 45 e0             	cmp    %eax,-0x20(%ebp)
  803078:	74 09                	je     803083 <inet_ntoa+0xb3>
      inv[i++] = '0' + rem;
    } while(*ap);
    while(i--)
      *rp++ = inv[i];
    *rp++ = '.';
    ap++;
  80307a:	83 45 e0 01          	addl   $0x1,-0x20(%ebp)
  80307e:	e9 72 ff ff ff       	jmp    802ff5 <inet_ntoa+0x25>
  }
  *--rp = 0;
  803083:	c6 41 ff 00          	movb   $0x0,-0x1(%ecx)
  return str;
}
  803087:	b8 7c 70 80 00       	mov    $0x80707c,%eax
  80308c:	83 c4 1c             	add    $0x1c,%esp
  80308f:	5b                   	pop    %ebx
  803090:	5e                   	pop    %esi
  803091:	5f                   	pop    %edi
  803092:	5d                   	pop    %ebp
  803093:	c3                   	ret    

00803094 <htons>:
 * @param n u16_t in host byte order
 * @return n in network byte order
 */
u16_t
htons(u16_t n)
{
  803094:	55                   	push   %ebp
  803095:	89 e5                	mov    %esp,%ebp
  803097:	0f b7 45 08          	movzwl 0x8(%ebp),%eax
  80309b:	66 c1 c0 08          	rol    $0x8,%ax
  return ((n & 0xff) << 8) | ((n & 0xff00) >> 8);
}
  80309f:	5d                   	pop    %ebp
  8030a0:	c3                   	ret    

008030a1 <ntohs>:
 * @param n u16_t in network byte order
 * @return n in host byte order
 */
u16_t
ntohs(u16_t n)
{
  8030a1:	55                   	push   %ebp
  8030a2:	89 e5                	mov    %esp,%ebp
  8030a4:	83 ec 04             	sub    $0x4,%esp
  return htons(n);
  8030a7:	0f b7 45 08          	movzwl 0x8(%ebp),%eax
  8030ab:	89 04 24             	mov    %eax,(%esp)
  8030ae:	e8 e1 ff ff ff       	call   803094 <htons>
}
  8030b3:	c9                   	leave  
  8030b4:	c3                   	ret    

008030b5 <htonl>:
 * @param n u32_t in host byte order
 * @return n in network byte order
 */
u32_t
htonl(u32_t n)
{
  8030b5:	55                   	push   %ebp
  8030b6:	89 e5                	mov    %esp,%ebp
  8030b8:	8b 55 08             	mov    0x8(%ebp),%edx
  8030bb:	89 d1                	mov    %edx,%ecx
  8030bd:	c1 e9 18             	shr    $0x18,%ecx
  8030c0:	89 d0                	mov    %edx,%eax
  8030c2:	c1 e0 18             	shl    $0x18,%eax
  8030c5:	09 c8                	or     %ecx,%eax
  8030c7:	89 d1                	mov    %edx,%ecx
  8030c9:	81 e1 00 ff 00 00    	and    $0xff00,%ecx
  8030cf:	c1 e1 08             	shl    $0x8,%ecx
  8030d2:	09 c8                	or     %ecx,%eax
  8030d4:	81 e2 00 00 ff 00    	and    $0xff0000,%edx
  8030da:	c1 ea 08             	shr    $0x8,%edx
  8030dd:	09 d0                	or     %edx,%eax
  return ((n & 0xff) << 24) |
    ((n & 0xff00) << 8) |
    ((n & 0xff0000UL) >> 8) |
    ((n & 0xff000000UL) >> 24);
}
  8030df:	5d                   	pop    %ebp
  8030e0:	c3                   	ret    

008030e1 <inet_aton>:
 * @param addr pointer to which to save the ip address in network order
 * @return 1 if cp could be converted to addr, 0 on failure
 */
int
inet_aton(const char *cp, struct in_addr *addr)
{
  8030e1:	55                   	push   %ebp
  8030e2:	89 e5                	mov    %esp,%ebp
  8030e4:	57                   	push   %edi
  8030e5:	56                   	push   %esi
  8030e6:	53                   	push   %ebx
  8030e7:	83 ec 28             	sub    $0x28,%esp
  8030ea:	8b 45 08             	mov    0x8(%ebp),%eax
  u32_t val;
  int base, n, c;
  u32_t parts[4];
  u32_t *pp = parts;

  c = *cp;
  8030ed:	0f be 10             	movsbl (%eax),%edx
    /*
     * Collect number up to ``.''.
     * Values are specified as for C:
     * 0x=hex, 0=octal, 1-9=decimal.
     */
    if (!isdigit(c))
  8030f0:	8d 4a d0             	lea    -0x30(%edx),%ecx
  8030f3:	80 f9 09             	cmp    $0x9,%cl
  8030f6:	0f 87 af 01 00 00    	ja     8032ab <inet_aton+0x1ca>
  8030fc:	8d 4d e4             	lea    -0x1c(%ebp),%ecx
  8030ff:	89 4d d8             	mov    %ecx,-0x28(%ebp)
       * Internet format:
       *  a.b.c.d
       *  a.b.c   (with c treated as 16 bits)
       *  a.b (with b treated as 24 bits)
       */
      if (pp >= parts + 3)
  803102:	8d 5d f0             	lea    -0x10(%ebp),%ebx
  803105:	89 5d d4             	mov    %ebx,-0x2c(%ebp)
     */
    if (!isdigit(c))
      return (0);
    val = 0;
    base = 10;
    if (c == '0') {
  803108:	c7 45 e0 0a 00 00 00 	movl   $0xa,-0x20(%ebp)
  80310f:	83 fa 30             	cmp    $0x30,%edx
  803112:	75 24                	jne    803138 <inet_aton+0x57>
      c = *++cp;
  803114:	83 c0 01             	add    $0x1,%eax
  803117:	0f be 10             	movsbl (%eax),%edx
      if (c == 'x' || c == 'X') {
  80311a:	83 fa 78             	cmp    $0x78,%edx
  80311d:	74 0c                	je     80312b <inet_aton+0x4a>
  80311f:	c7 45 e0 08 00 00 00 	movl   $0x8,-0x20(%ebp)
  803126:	83 fa 58             	cmp    $0x58,%edx
  803129:	75 0d                	jne    803138 <inet_aton+0x57>
        base = 16;
        c = *++cp;
  80312b:	83 c0 01             	add    $0x1,%eax
  80312e:	0f be 10             	movsbl (%eax),%edx
  803131:	c7 45 e0 10 00 00 00 	movl   $0x10,-0x20(%ebp)
  803138:	83 c0 01             	add    $0x1,%eax
  80313b:	be 00 00 00 00       	mov    $0x0,%esi
  803140:	eb 03                	jmp    803145 <inet_aton+0x64>
  803142:	83 c0 01             	add    $0x1,%eax
  803145:	8d 78 ff             	lea    -0x1(%eax),%edi
      } else
        base = 8;
    }
    for (;;) {
      if (isdigit(c)) {
  803148:	89 d1                	mov    %edx,%ecx
  80314a:	8d 59 d0             	lea    -0x30(%ecx),%ebx
  80314d:	80 fb 09             	cmp    $0x9,%bl
  803150:	77 0d                	ja     80315f <inet_aton+0x7e>
        val = (val * base) + (int)(c - '0');
  803152:	0f af 75 e0          	imul   -0x20(%ebp),%esi
  803156:	8d 74 32 d0          	lea    -0x30(%edx,%esi,1),%esi
        c = *++cp;
  80315a:	0f be 10             	movsbl (%eax),%edx
  80315d:	eb e3                	jmp    803142 <inet_aton+0x61>
      } else if (base == 16 && isxdigit(c)) {
  80315f:	83 7d e0 10          	cmpl   $0x10,-0x20(%ebp)
  803163:	75 2b                	jne    803190 <inet_aton+0xaf>
  803165:	8d 59 9f             	lea    -0x61(%ecx),%ebx
  803168:	88 5d d3             	mov    %bl,-0x2d(%ebp)
  80316b:	80 fb 05             	cmp    $0x5,%bl
  80316e:	76 08                	jbe    803178 <inet_aton+0x97>
  803170:	8d 59 bf             	lea    -0x41(%ecx),%ebx
  803173:	80 fb 05             	cmp    $0x5,%bl
  803176:	77 18                	ja     803190 <inet_aton+0xaf>
        val = (val << 4) | (int)(c + 10 - (islower(c) ? 'a' : 'A'));
  803178:	80 7d d3 1a          	cmpb   $0x1a,-0x2d(%ebp)
  80317c:	19 c9                	sbb    %ecx,%ecx
  80317e:	83 e1 20             	and    $0x20,%ecx
  803181:	c1 e6 04             	shl    $0x4,%esi
  803184:	29 ca                	sub    %ecx,%edx
  803186:	8d 52 c9             	lea    -0x37(%edx),%edx
  803189:	09 d6                	or     %edx,%esi
        c = *++cp;
  80318b:	0f be 10             	movsbl (%eax),%edx
  80318e:	eb b2                	jmp    803142 <inet_aton+0x61>
      } else
        break;
    }
    if (c == '.') {
  803190:	83 fa 2e             	cmp    $0x2e,%edx
  803193:	75 2c                	jne    8031c1 <inet_aton+0xe0>
       * Internet format:
       *  a.b.c.d
       *  a.b.c   (with c treated as 16 bits)
       *  a.b (with b treated as 24 bits)
       */
      if (pp >= parts + 3)
  803195:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803198:	39 55 d8             	cmp    %edx,-0x28(%ebp)
  80319b:	0f 83 0a 01 00 00    	jae    8032ab <inet_aton+0x1ca>
        return (0);
      *pp++ = val;
  8031a1:	8b 4d d8             	mov    -0x28(%ebp),%ecx
  8031a4:	89 31                	mov    %esi,(%ecx)
      c = *++cp;
  8031a6:	8d 47 01             	lea    0x1(%edi),%eax
  8031a9:	0f be 10             	movsbl (%eax),%edx
    /*
     * Collect number up to ``.''.
     * Values are specified as for C:
     * 0x=hex, 0=octal, 1-9=decimal.
     */
    if (!isdigit(c))
  8031ac:	8d 4a d0             	lea    -0x30(%edx),%ecx
  8031af:	80 f9 09             	cmp    $0x9,%cl
  8031b2:	0f 87 f3 00 00 00    	ja     8032ab <inet_aton+0x1ca>
       *  a.b.c   (with c treated as 16 bits)
       *  a.b (with b treated as 24 bits)
       */
      if (pp >= parts + 3)
        return (0);
      *pp++ = val;
  8031b8:	83 45 d8 04          	addl   $0x4,-0x28(%ebp)
  8031bc:	e9 47 ff ff ff       	jmp    803108 <inet_aton+0x27>
  8031c1:	89 f3                	mov    %esi,%ebx
  8031c3:	89 f0                	mov    %esi,%eax
      break;
  }
  /*
   * Check for trailing characters.
   */
  if (c != '\0' && (!isprint(c) || !isspace(c)))
  8031c5:	85 d2                	test   %edx,%edx
  8031c7:	74 37                	je     803200 <inet_aton+0x11f>
  8031c9:	80 f9 1f             	cmp    $0x1f,%cl
  8031cc:	0f 86 d9 00 00 00    	jbe    8032ab <inet_aton+0x1ca>
  8031d2:	84 d2                	test   %dl,%dl
  8031d4:	0f 88 d1 00 00 00    	js     8032ab <inet_aton+0x1ca>
  8031da:	83 fa 20             	cmp    $0x20,%edx
  8031dd:	8d 76 00             	lea    0x0(%esi),%esi
  8031e0:	74 1e                	je     803200 <inet_aton+0x11f>
  8031e2:	83 fa 0c             	cmp    $0xc,%edx
  8031e5:	74 19                	je     803200 <inet_aton+0x11f>
  8031e7:	83 fa 0a             	cmp    $0xa,%edx
  8031ea:	74 14                	je     803200 <inet_aton+0x11f>
  8031ec:	83 fa 0d             	cmp    $0xd,%edx
  8031ef:	90                   	nop
  8031f0:	74 0e                	je     803200 <inet_aton+0x11f>
  8031f2:	83 fa 09             	cmp    $0x9,%edx
  8031f5:	74 09                	je     803200 <inet_aton+0x11f>
  8031f7:	83 fa 0b             	cmp    $0xb,%edx
  8031fa:	0f 85 ab 00 00 00    	jne    8032ab <inet_aton+0x1ca>
  /*
   * Concoct the address according to
   * the number of parts specified.
   */
  n = pp - parts + 1;
  switch (n) {
  803200:	8d 55 e4             	lea    -0x1c(%ebp),%edx
  803203:	8b 4d d8             	mov    -0x28(%ebp),%ecx
  803206:	29 d1                	sub    %edx,%ecx
  803208:	89 ca                	mov    %ecx,%edx
  80320a:	c1 fa 02             	sar    $0x2,%edx
  80320d:	83 c2 01             	add    $0x1,%edx
  803210:	83 fa 02             	cmp    $0x2,%edx
  803213:	74 2d                	je     803242 <inet_aton+0x161>
  803215:	83 fa 02             	cmp    $0x2,%edx
  803218:	7f 10                	jg     80322a <inet_aton+0x149>
  80321a:	85 d2                	test   %edx,%edx
  80321c:	0f 84 89 00 00 00    	je     8032ab <inet_aton+0x1ca>
  803222:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  803228:	eb 62                	jmp    80328c <inet_aton+0x1ab>
  80322a:	83 fa 03             	cmp    $0x3,%edx
  80322d:	8d 76 00             	lea    0x0(%esi),%esi
  803230:	74 22                	je     803254 <inet_aton+0x173>
  803232:	83 fa 04             	cmp    $0x4,%edx
  803235:	8d 76 00             	lea    0x0(%esi),%esi
  803238:	75 52                	jne    80328c <inet_aton+0x1ab>
  80323a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  803240:	eb 2b                	jmp    80326d <inet_aton+0x18c>

  case 1:             /* a -- 32 bits */
    break;

  case 2:             /* a.b -- 8.24 bits */
    if (val > 0xffffffUL)
  803242:	3d ff ff ff 00       	cmp    $0xffffff,%eax
  803247:	90                   	nop
  803248:	77 61                	ja     8032ab <inet_aton+0x1ca>
      return (0);
    val |= parts[0] << 24;
  80324a:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
  80324d:	c1 e3 18             	shl    $0x18,%ebx
  803250:	09 c3                	or     %eax,%ebx
    break;
  803252:	eb 38                	jmp    80328c <inet_aton+0x1ab>

  case 3:             /* a.b.c -- 8.8.16 bits */
    if (val > 0xffff)
  803254:	3d ff ff 00 00       	cmp    $0xffff,%eax
  803259:	77 50                	ja     8032ab <inet_aton+0x1ca>
      return (0);
    val |= (parts[0] << 24) | (parts[1] << 16);
  80325b:	8b 5d e8             	mov    -0x18(%ebp),%ebx
  80325e:	c1 e3 10             	shl    $0x10,%ebx
  803261:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803264:	c1 e2 18             	shl    $0x18,%edx
  803267:	09 d3                	or     %edx,%ebx
  803269:	09 c3                	or     %eax,%ebx
    break;
  80326b:	eb 1f                	jmp    80328c <inet_aton+0x1ab>

  case 4:             /* a.b.c.d -- 8.8.8.8 bits */
    if (val > 0xff)
  80326d:	3d ff 00 00 00       	cmp    $0xff,%eax
  803272:	77 37                	ja     8032ab <inet_aton+0x1ca>
      return (0);
    val |= (parts[0] << 24) | (parts[1] << 16) | (parts[2] << 8);
  803274:	8b 5d e8             	mov    -0x18(%ebp),%ebx
  803277:	c1 e3 10             	shl    $0x10,%ebx
  80327a:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80327d:	c1 e2 18             	shl    $0x18,%edx
  803280:	09 d3                	or     %edx,%ebx
  803282:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803285:	c1 e2 08             	shl    $0x8,%edx
  803288:	09 d3                	or     %edx,%ebx
  80328a:	09 c3                	or     %eax,%ebx
    break;
  }
  if (addr)
  80328c:	b8 01 00 00 00       	mov    $0x1,%eax
  803291:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  803295:	74 19                	je     8032b0 <inet_aton+0x1cf>
    addr->s_addr = htonl(val);
  803297:	89 1c 24             	mov    %ebx,(%esp)
  80329a:	e8 16 fe ff ff       	call   8030b5 <htonl>
  80329f:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  8032a2:	89 03                	mov    %eax,(%ebx)
  8032a4:	b8 01 00 00 00       	mov    $0x1,%eax
  8032a9:	eb 05                	jmp    8032b0 <inet_aton+0x1cf>
  8032ab:	b8 00 00 00 00       	mov    $0x0,%eax
  return (1);
}
  8032b0:	83 c4 28             	add    $0x28,%esp
  8032b3:	5b                   	pop    %ebx
  8032b4:	5e                   	pop    %esi
  8032b5:	5f                   	pop    %edi
  8032b6:	5d                   	pop    %ebp
  8032b7:	c3                   	ret    

008032b8 <inet_addr>:
 * @param cp IP address in ascii represenation (e.g. "127.0.0.1")
 * @return ip address in network order
 */
u32_t
inet_addr(const char *cp)
{
  8032b8:	55                   	push   %ebp
  8032b9:	89 e5                	mov    %esp,%ebp
  8032bb:	83 ec 18             	sub    $0x18,%esp
  struct in_addr val;

  if (inet_aton(cp, &val)) {
  8032be:	8d 45 fc             	lea    -0x4(%ebp),%eax
  8032c1:	89 44 24 04          	mov    %eax,0x4(%esp)
  8032c5:	8b 45 08             	mov    0x8(%ebp),%eax
  8032c8:	89 04 24             	mov    %eax,(%esp)
  8032cb:	e8 11 fe ff ff       	call   8030e1 <inet_aton>
  8032d0:	83 f8 01             	cmp    $0x1,%eax
  8032d3:	19 c0                	sbb    %eax,%eax
  8032d5:	0b 45 fc             	or     -0x4(%ebp),%eax
    return (val.s_addr);
  }
  return (INADDR_NONE);
}
  8032d8:	c9                   	leave  
  8032d9:	c3                   	ret    

008032da <ntohl>:
 * @param n u32_t in network byte order
 * @return n in host byte order
 */
u32_t
ntohl(u32_t n)
{
  8032da:	55                   	push   %ebp
  8032db:	89 e5                	mov    %esp,%ebp
  8032dd:	83 ec 04             	sub    $0x4,%esp
  return htonl(n);
  8032e0:	8b 45 08             	mov    0x8(%ebp),%eax
  8032e3:	89 04 24             	mov    %eax,(%esp)
  8032e6:	e8 ca fd ff ff       	call   8030b5 <htonl>
}
  8032eb:	c9                   	leave  
  8032ec:	c3                   	ret    
  8032ed:	00 00                	add    %al,(%eax)
	...

008032f0 <__udivdi3>:
  8032f0:	55                   	push   %ebp
  8032f1:	89 e5                	mov    %esp,%ebp
  8032f3:	57                   	push   %edi
  8032f4:	56                   	push   %esi
  8032f5:	83 ec 10             	sub    $0x10,%esp
  8032f8:	8b 45 14             	mov    0x14(%ebp),%eax
  8032fb:	8b 55 08             	mov    0x8(%ebp),%edx
  8032fe:	8b 75 10             	mov    0x10(%ebp),%esi
  803301:	8b 7d 0c             	mov    0xc(%ebp),%edi
  803304:	85 c0                	test   %eax,%eax
  803306:	89 55 f0             	mov    %edx,-0x10(%ebp)
  803309:	75 35                	jne    803340 <__udivdi3+0x50>
  80330b:	39 fe                	cmp    %edi,%esi
  80330d:	77 61                	ja     803370 <__udivdi3+0x80>
  80330f:	85 f6                	test   %esi,%esi
  803311:	75 0b                	jne    80331e <__udivdi3+0x2e>
  803313:	b8 01 00 00 00       	mov    $0x1,%eax
  803318:	31 d2                	xor    %edx,%edx
  80331a:	f7 f6                	div    %esi
  80331c:	89 c6                	mov    %eax,%esi
  80331e:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  803321:	31 d2                	xor    %edx,%edx
  803323:	89 f8                	mov    %edi,%eax
  803325:	f7 f6                	div    %esi
  803327:	89 c7                	mov    %eax,%edi
  803329:	89 c8                	mov    %ecx,%eax
  80332b:	f7 f6                	div    %esi
  80332d:	89 c1                	mov    %eax,%ecx
  80332f:	89 fa                	mov    %edi,%edx
  803331:	89 c8                	mov    %ecx,%eax
  803333:	83 c4 10             	add    $0x10,%esp
  803336:	5e                   	pop    %esi
  803337:	5f                   	pop    %edi
  803338:	5d                   	pop    %ebp
  803339:	c3                   	ret    
  80333a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  803340:	39 f8                	cmp    %edi,%eax
  803342:	77 1c                	ja     803360 <__udivdi3+0x70>
  803344:	0f bd d0             	bsr    %eax,%edx
  803347:	83 f2 1f             	xor    $0x1f,%edx
  80334a:	89 55 f4             	mov    %edx,-0xc(%ebp)
  80334d:	75 39                	jne    803388 <__udivdi3+0x98>
  80334f:	3b 75 f0             	cmp    -0x10(%ebp),%esi
  803352:	0f 86 a0 00 00 00    	jbe    8033f8 <__udivdi3+0x108>
  803358:	39 f8                	cmp    %edi,%eax
  80335a:	0f 82 98 00 00 00    	jb     8033f8 <__udivdi3+0x108>
  803360:	31 ff                	xor    %edi,%edi
  803362:	31 c9                	xor    %ecx,%ecx
  803364:	89 c8                	mov    %ecx,%eax
  803366:	89 fa                	mov    %edi,%edx
  803368:	83 c4 10             	add    $0x10,%esp
  80336b:	5e                   	pop    %esi
  80336c:	5f                   	pop    %edi
  80336d:	5d                   	pop    %ebp
  80336e:	c3                   	ret    
  80336f:	90                   	nop
  803370:	89 d1                	mov    %edx,%ecx
  803372:	89 fa                	mov    %edi,%edx
  803374:	89 c8                	mov    %ecx,%eax
  803376:	31 ff                	xor    %edi,%edi
  803378:	f7 f6                	div    %esi
  80337a:	89 c1                	mov    %eax,%ecx
  80337c:	89 fa                	mov    %edi,%edx
  80337e:	89 c8                	mov    %ecx,%eax
  803380:	83 c4 10             	add    $0x10,%esp
  803383:	5e                   	pop    %esi
  803384:	5f                   	pop    %edi
  803385:	5d                   	pop    %ebp
  803386:	c3                   	ret    
  803387:	90                   	nop
  803388:	0f b6 4d f4          	movzbl -0xc(%ebp),%ecx
  80338c:	89 f2                	mov    %esi,%edx
  80338e:	d3 e0                	shl    %cl,%eax
  803390:	89 45 ec             	mov    %eax,-0x14(%ebp)
  803393:	b8 20 00 00 00       	mov    $0x20,%eax
  803398:	2b 45 f4             	sub    -0xc(%ebp),%eax
  80339b:	89 c1                	mov    %eax,%ecx
  80339d:	d3 ea                	shr    %cl,%edx
  80339f:	0f b6 4d f4          	movzbl -0xc(%ebp),%ecx
  8033a3:	0b 55 ec             	or     -0x14(%ebp),%edx
  8033a6:	d3 e6                	shl    %cl,%esi
  8033a8:	89 c1                	mov    %eax,%ecx
  8033aa:	89 75 e8             	mov    %esi,-0x18(%ebp)
  8033ad:	89 fe                	mov    %edi,%esi
  8033af:	d3 ee                	shr    %cl,%esi
  8033b1:	0f b6 4d f4          	movzbl -0xc(%ebp),%ecx
  8033b5:	89 55 ec             	mov    %edx,-0x14(%ebp)
  8033b8:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8033bb:	d3 e7                	shl    %cl,%edi
  8033bd:	89 c1                	mov    %eax,%ecx
  8033bf:	d3 ea                	shr    %cl,%edx
  8033c1:	09 d7                	or     %edx,%edi
  8033c3:	89 f2                	mov    %esi,%edx
  8033c5:	89 f8                	mov    %edi,%eax
  8033c7:	f7 75 ec             	divl   -0x14(%ebp)
  8033ca:	89 d6                	mov    %edx,%esi
  8033cc:	89 c7                	mov    %eax,%edi
  8033ce:	f7 65 e8             	mull   -0x18(%ebp)
  8033d1:	39 d6                	cmp    %edx,%esi
  8033d3:	89 55 ec             	mov    %edx,-0x14(%ebp)
  8033d6:	72 30                	jb     803408 <__udivdi3+0x118>
  8033d8:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8033db:	0f b6 4d f4          	movzbl -0xc(%ebp),%ecx
  8033df:	d3 e2                	shl    %cl,%edx
  8033e1:	39 c2                	cmp    %eax,%edx
  8033e3:	73 05                	jae    8033ea <__udivdi3+0xfa>
  8033e5:	3b 75 ec             	cmp    -0x14(%ebp),%esi
  8033e8:	74 1e                	je     803408 <__udivdi3+0x118>
  8033ea:	89 f9                	mov    %edi,%ecx
  8033ec:	31 ff                	xor    %edi,%edi
  8033ee:	e9 71 ff ff ff       	jmp    803364 <__udivdi3+0x74>
  8033f3:	90                   	nop
  8033f4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  8033f8:	31 ff                	xor    %edi,%edi
  8033fa:	b9 01 00 00 00       	mov    $0x1,%ecx
  8033ff:	e9 60 ff ff ff       	jmp    803364 <__udivdi3+0x74>
  803404:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  803408:	8d 4f ff             	lea    -0x1(%edi),%ecx
  80340b:	31 ff                	xor    %edi,%edi
  80340d:	89 c8                	mov    %ecx,%eax
  80340f:	89 fa                	mov    %edi,%edx
  803411:	83 c4 10             	add    $0x10,%esp
  803414:	5e                   	pop    %esi
  803415:	5f                   	pop    %edi
  803416:	5d                   	pop    %ebp
  803417:	c3                   	ret    
	...

00803420 <__umoddi3>:
  803420:	55                   	push   %ebp
  803421:	89 e5                	mov    %esp,%ebp
  803423:	57                   	push   %edi
  803424:	56                   	push   %esi
  803425:	83 ec 20             	sub    $0x20,%esp
  803428:	8b 55 14             	mov    0x14(%ebp),%edx
  80342b:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80342e:	8b 7d 10             	mov    0x10(%ebp),%edi
  803431:	8b 75 0c             	mov    0xc(%ebp),%esi
  803434:	85 d2                	test   %edx,%edx
  803436:	89 c8                	mov    %ecx,%eax
  803438:	89 4d f4             	mov    %ecx,-0xc(%ebp)
  80343b:	75 13                	jne    803450 <__umoddi3+0x30>
  80343d:	39 f7                	cmp    %esi,%edi
  80343f:	76 3f                	jbe    803480 <__umoddi3+0x60>
  803441:	89 f2                	mov    %esi,%edx
  803443:	f7 f7                	div    %edi
  803445:	89 d0                	mov    %edx,%eax
  803447:	31 d2                	xor    %edx,%edx
  803449:	83 c4 20             	add    $0x20,%esp
  80344c:	5e                   	pop    %esi
  80344d:	5f                   	pop    %edi
  80344e:	5d                   	pop    %ebp
  80344f:	c3                   	ret    
  803450:	39 f2                	cmp    %esi,%edx
  803452:	77 4c                	ja     8034a0 <__umoddi3+0x80>
  803454:	0f bd ca             	bsr    %edx,%ecx
  803457:	83 f1 1f             	xor    $0x1f,%ecx
  80345a:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  80345d:	75 51                	jne    8034b0 <__umoddi3+0x90>
  80345f:	3b 7d f4             	cmp    -0xc(%ebp),%edi
  803462:	0f 87 e0 00 00 00    	ja     803548 <__umoddi3+0x128>
  803468:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80346b:	29 f8                	sub    %edi,%eax
  80346d:	19 d6                	sbb    %edx,%esi
  80346f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803472:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803475:	89 f2                	mov    %esi,%edx
  803477:	83 c4 20             	add    $0x20,%esp
  80347a:	5e                   	pop    %esi
  80347b:	5f                   	pop    %edi
  80347c:	5d                   	pop    %ebp
  80347d:	c3                   	ret    
  80347e:	66 90                	xchg   %ax,%ax
  803480:	85 ff                	test   %edi,%edi
  803482:	75 0b                	jne    80348f <__umoddi3+0x6f>
  803484:	b8 01 00 00 00       	mov    $0x1,%eax
  803489:	31 d2                	xor    %edx,%edx
  80348b:	f7 f7                	div    %edi
  80348d:	89 c7                	mov    %eax,%edi
  80348f:	89 f0                	mov    %esi,%eax
  803491:	31 d2                	xor    %edx,%edx
  803493:	f7 f7                	div    %edi
  803495:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803498:	f7 f7                	div    %edi
  80349a:	eb a9                	jmp    803445 <__umoddi3+0x25>
  80349c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  8034a0:	89 c8                	mov    %ecx,%eax
  8034a2:	89 f2                	mov    %esi,%edx
  8034a4:	83 c4 20             	add    $0x20,%esp
  8034a7:	5e                   	pop    %esi
  8034a8:	5f                   	pop    %edi
  8034a9:	5d                   	pop    %ebp
  8034aa:	c3                   	ret    
  8034ab:	90                   	nop
  8034ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  8034b0:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
  8034b4:	d3 e2                	shl    %cl,%edx
  8034b6:	89 55 f4             	mov    %edx,-0xc(%ebp)
  8034b9:	ba 20 00 00 00       	mov    $0x20,%edx
  8034be:	2b 55 f0             	sub    -0x10(%ebp),%edx
  8034c1:	89 55 ec             	mov    %edx,-0x14(%ebp)
  8034c4:	0f b6 4d ec          	movzbl -0x14(%ebp),%ecx
  8034c8:	89 fa                	mov    %edi,%edx
  8034ca:	d3 ea                	shr    %cl,%edx
  8034cc:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
  8034d0:	0b 55 f4             	or     -0xc(%ebp),%edx
  8034d3:	d3 e7                	shl    %cl,%edi
  8034d5:	0f b6 4d ec          	movzbl -0x14(%ebp),%ecx
  8034d9:	89 55 f4             	mov    %edx,-0xc(%ebp)
  8034dc:	89 f2                	mov    %esi,%edx
  8034de:	89 7d e8             	mov    %edi,-0x18(%ebp)
  8034e1:	89 c7                	mov    %eax,%edi
  8034e3:	d3 ea                	shr    %cl,%edx
  8034e5:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
  8034e9:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  8034ec:	89 c2                	mov    %eax,%edx
  8034ee:	d3 e6                	shl    %cl,%esi
  8034f0:	0f b6 4d ec          	movzbl -0x14(%ebp),%ecx
  8034f4:	d3 ea                	shr    %cl,%edx
  8034f6:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
  8034fa:	09 d6                	or     %edx,%esi
  8034fc:	89 f0                	mov    %esi,%eax
  8034fe:	8b 75 e4             	mov    -0x1c(%ebp),%esi
  803501:	d3 e7                	shl    %cl,%edi
  803503:	89 f2                	mov    %esi,%edx
  803505:	f7 75 f4             	divl   -0xc(%ebp)
  803508:	89 d6                	mov    %edx,%esi
  80350a:	f7 65 e8             	mull   -0x18(%ebp)
  80350d:	39 d6                	cmp    %edx,%esi
  80350f:	72 2b                	jb     80353c <__umoddi3+0x11c>
  803511:	39 c7                	cmp    %eax,%edi
  803513:	72 23                	jb     803538 <__umoddi3+0x118>
  803515:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
  803519:	29 c7                	sub    %eax,%edi
  80351b:	19 d6                	sbb    %edx,%esi
  80351d:	89 f0                	mov    %esi,%eax
  80351f:	89 f2                	mov    %esi,%edx
  803521:	d3 ef                	shr    %cl,%edi
  803523:	0f b6 4d ec          	movzbl -0x14(%ebp),%ecx
  803527:	d3 e0                	shl    %cl,%eax
  803529:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
  80352d:	09 f8                	or     %edi,%eax
  80352f:	d3 ea                	shr    %cl,%edx
  803531:	83 c4 20             	add    $0x20,%esp
  803534:	5e                   	pop    %esi
  803535:	5f                   	pop    %edi
  803536:	5d                   	pop    %ebp
  803537:	c3                   	ret    
  803538:	39 d6                	cmp    %edx,%esi
  80353a:	75 d9                	jne    803515 <__umoddi3+0xf5>
  80353c:	2b 45 e8             	sub    -0x18(%ebp),%eax
  80353f:	1b 55 f4             	sbb    -0xc(%ebp),%edx
  803542:	eb d1                	jmp    803515 <__umoddi3+0xf5>
  803544:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  803548:	39 f2                	cmp    %esi,%edx
  80354a:	0f 82 18 ff ff ff    	jb     803468 <__umoddi3+0x48>
  803550:	e9 1d ff ff ff       	jmp    803472 <__umoddi3+0x52>
