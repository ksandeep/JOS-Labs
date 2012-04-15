// LAB 6: Your driver code here
// Code added by Swastika / Sandeep
#include <kern/e100.h>
#include <kern/pci.h>
#include <kern/pmap.h>


#include <inc/x86.h>
#include <inc/stdio.h>
#include <inc/types.h>
#include <inc/string.h>


static struct tcb ring_tcb[TCB_BUFFERS];
static struct rfd ring_rfd[RFD_BUFFERS];

static int cu_ind = 0;
static int ru_ind = 0;
static int ru_ind_last = 0;

// forward function declarations
int alloc_tcb_ring (void);
int alloc_rfd_ring (void);
void clear_rfd (struct rfd*);

// function to attach the E100 device
int e100_attach(struct pci_func* f)
{
	int i;
	int base;
	
	// enable the E100 device
	pci_func_enable(f);
	for (i = 0; i < 6; i++)
	{
		store.reg_base[i] = f->reg_base[i];
		store.reg_size[i] = f->reg_size[i];
	}
	store.irq_line = f->irq_line;
	
	// do a software reset
	base = store.reg_base[1]; 		// for I/O Port Base
	outl(base + 0x8, 0x0);

	// initialize the TBC Ring for CU
	alloc_tcb_ring();
	
	// load the CU Base register with the base address of the ring_tcb
	outl(base + 0x4, PADDR(&ring_tcb[0])); 
	outw(base + 0x2, SCB_CU_LOAD_CU_BASE); //op code in SCB command word


	// initialize the RFD Ring for RU
	alloc_rfd_ring();
	
	// load the RU Base register with the base address of the ring_rfd
	// outl(base + 0x4, PADDR(&ring_rfd[0]));
	// outw(base + 0x2, SCB_RU_LOAD_RU_BASE);
	
	// Start the RU
	outl(base + 0x4, PADDR((uint32_t)&ring_rfd[ru_ind]));
	outw(base + 0x2, SCB_RU_START);	

        return 0;
}

// construct a DMA ring for RU to use	
int alloc_rfd_ring (void)
{
	int i,j;
	for (i=0; i < RFD_BUFFERS; i++)
	{
		j = ((i+1)%RFD_BUFFERS);
		ring_rfd[i].cb.status = 0x0;
		ring_rfd[i].cb.cmd = 0x0;
		ring_rfd[i].reserved = 0xffffffff;
		// ring_rfd[i].cb.link = j * sizeof (struct rfd);
		ring_rfd[i].cb.link = PADDR(&ring_rfd[j]);
		ring_rfd[i].actual_count = 0x0;
		ring_rfd[i].size = PACKET_MAX_SIZE;
	}

	// intially mark the EL flag for the last buffer
	ring_rfd[RFD_BUFFERS - 1].cb.cmd |= CB_EL;		
	
	ru_ind = 0;	
	ru_ind_last = RFD_BUFFERS - 1;
	return 0;
}

int check_rfd (struct rfd *ptr)
{
	if(ptr->cb.status & CB_STATUS_C)
	{
		return 1;
	}
	
	return 0;
} 

void clear_rfd (struct rfd* ptr)
{
	ptr->cb.status = 0x0;
	ptr->cb.cmd |= CB_EL;
	ptr->reserved = 0xffffffff;
	ptr->actual_count = 0x0;
	ptr->size = PACKET_MAX_SIZE;
}

int receive_packet (void* buffer)
{
	if (!buffer)
		return -E_NIC_RECEIVE;
	// Check if there is a valid packet in the buffer pointed by index ru_ind
	if (check_rfd(&ring_rfd[ru_ind]) == 0)
		return 0;
	// Set count variable as the actual count of bytes in the packet
	// Mask is needed to mask off EOF and F bits
	// Open SDM: Figure 25
	uint16_t count = ring_rfd[ru_ind].actual_count & (~RFD_COUNT_MASK);

	// Copy the "count" no of bytes from "packet_data" to the "buffer"	
	memmove(buffer, ring_rfd[ru_ind].packet_data, count);
	
	// This buffer can be reused now, clear it
	clear_rfd (&ring_rfd[ru_ind]);
	
	// Clear the EL bit in the last buffer, move the "last buffer" index
	ring_rfd[ru_ind_last].cb.cmd &= ~CB_EL;
	ru_ind_last = ru_ind;

	// Move the index ru_ind
	ru_ind = (ru_ind + 1) % RFD_BUFFERS;

	int base = store.reg_base[1]; 		// for I/O Port Base
	uint8_t status =  inb(base);
	status = status & SCBST_RU_MASK;		
	 
	if ((status == SCBST_RU_IDLE))
	{
		// Start the RU
		cprintf("\n Starting the RU");
		outl(base + 0x4, PADDR((uint32_t)&ring_rfd[ru_ind]));
		outw(base + 0x2, SCB_RU_START);	
	} 
	
	if (status ==  SCBST_RU_SUSPENDED)
	{
		// Resume the RU
		outw(base + 0x2, SCB_RU_RESUME);				
	}

	return count;
}	

// construct a control DMA ring for the CU to use
int alloc_tcb_ring (void)
{
	int i,j;
	for (i = 0; i < TCB_BUFFERS; i++)
	{
		j = ((i+1)%TCB_BUFFERS);
		ring_tcb[i].cb.status = 0x0;
		ring_tcb[i].cb.cmd = 0x0;
		ring_tcb[i].cb.link = j * sizeof (struct tcb);
		//ring_tcb[i].cb.link = PADDR(&ring_tcb[j]);
	}
	cu_ind = 0;
	return 0;
}

int check_tcb (struct tcb *ptr)
{
	// determines if the tcb buffer is available to  be used by the driver 
	if (ptr->cb.cmd)
		return 0;
	else 
		return 1;
}

void reclaim_buffers()
{
	// function to reclaim transmitted buffers
	int i;
	for (i=0; i < TCB_BUFFERS; i++)
	{
		if (ring_tcb[i].cb.status & CB_STATUS_C)
		{
			// check the OK bit for an error
			if (!(ring_tcb[i].cb.status & CB_STATUS_OK))
			{
				// there was an error
				// do something
			}
			// reclaim the buffer anyways
			ring_tcb[i].cb.status = 0x0;
			ring_tcb[i].cb.cmd = 0x0;
		}
	}
}

void fill_tcb_buffer (struct tcb* ptr, void* data, uint32_t len)
{
	ptr->cb.cmd = CB_TRANSMIT | CB_S;		// Set the Suspend bit
	ptr->cb.status = 0x0;
	ptr->tbd_array_addr = 0xffffffff;
	ptr->size = len;
	ptr->thrs = 0xe0;
	memmove(ptr->packet_data, data, len);
}

int transmit_packet (void * data, uint32_t len)
{
	reclaim_buffers();
	if (len > PACKET_MAX_SIZE)
		return -E_NIC_TRANSMIT;
	
	if (check_tcb(&ring_tcb[cu_ind]) == 0)
		return -E_NIC_TRANSMIT;
	
	fill_tcb_buffer(&ring_tcb[cu_ind], data, len);
			
	int base = store.reg_base[1]; 		// for I/O Port Base
	uint8_t status =  inb(base);
	status = status & SCBST_CU_MASK;
	
	 
	if (status == SCBST_CU_IDLE)
	{
		// Start the CU
		outl(base + 0x4, PADDR((uint32_t)&ring_tcb[cu_ind]));
		outw(base + 0x2, SCB_CU_START);	
	} 
	if (status ==  SCBST_CU_SUSPENDED)
	{
		// Resume the CU
		outw(base + 0x2, SCB_CU_RESUME);				
	}
	// move cu_ind
	cu_ind = (cu_ind + 1) % TCB_BUFFERS;
	return 0;
}
