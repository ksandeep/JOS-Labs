#include "ns.h"
#include <inc/lib.h>
#include <inc/syscall.h>

extern union Nsipc nsipcbuf;

void
output(envid_t ns_envid)
{
	binaryname = "ns_output";


	// LAB 6: Your code here:
	// 	- read a packet from the network server
	//	- send the packet to the device driver

	envid_t from_env;
	uint32_t request;
	int perm;
	while(1)
	{
		perm = 0;
		request = ipc_recv(&from_env, (void*)&nsipcbuf, &perm);
		if (!(perm & PTE_P))
		{
			cprintf("\n output.c : Page not present! ");
			continue;
		}
		if (from_env != ns_envid)
		{
			cprintf("\n output.c : Request received from bogus environment! ");
			continue;
		}
		if (request == NSREQ_OUTPUT)
		{	
			sys_transmit_packet(nsipcbuf.pkt.jp_data, nsipcbuf.pkt.jp_len);
		}
		else
			cprintf("\n output.c : Invalid request received! ");

	}
}
