// LAB 6
// Code added by Swastika / Sandeep

#include <kern/pci.h>


#ifndef JOS_KERN_E100_H
#define JOS_KERN_E100_H

#define PACKET_MAX_SIZE 1518
#define TCB_BUFFERS 6
#define RFD_BUFFERS 6
#define E_NIC_TRANSMIT 16
#define E_NIC_RECEIVE 32

// Public function delarations
int e100_attach(struct pci_func*);
int transmit_packet (void*, uint32_t);
int receive_packet (void*);


// Define struct cb for control blocks
struct cb {
	// generic cb header
	volatile uint16_t status;	
	uint16_t cmd;
	uint32_t link;	
};

struct tcb {
	// transmit cb
	struct cb cb;				// for the header
	uint32_t tbd_array_addr;
	uint16_t size;				// TCB BYTE COUNT
	uint8_t thrs;				// THRS
	uint8_t tbd_count;
	uint8_t packet_data[PACKET_MAX_SIZE];
}__attribute__((packed));

struct rfd {
	struct cb cb;
	uint32_t reserved;
	uint16_t actual_count;
	uint16_t size;
	uint8_t packet_data[PACKET_MAX_SIZE];
}__attribute__((packed));

// Global variables
struct pci_func store;


// General action commands
#define CB_NOP 			0x0000			// Table 37, SDM
#define CB_IND_ADR_SETUP	0x0001
#define CB_CONFIGURE		0x0002
#define CB_MUL_ADR_SETUP	0x0003
#define CB_TRANSMIT		0x0004
#define CB_LD_MICROCODE		0x0005
#define CB_DUMP			0x0006
#define CB_DIAGNOSE		0x0007

// Other Bits
#define CB_EL			0x8000
#define CB_S			0x4000			// 30th S-bit figure 15, SDM
#define CB_I			0x2000
// For RFA
#define CB_SF			0x0008 


// Status bits
#define CB_STATUS_C		0x8000			// figure 15,19 SDM
#define CB_STATUS_OK		0x2000
#define CB_STATUS_U		0x1000


// SCB Command words CU
#define SCB_CU_NOP				0x00	// table 14, SDM
#define SCB_CU_START				0x10
#define SCB_CU_RESUME				0x20
#define SCB_CU_LOAD_DUMP_COUNTERS_ADDR		0x40
#define SCB_CU_DUMP_STAT_COUNTERS		0x50
#define SCB_CU_LOAD_CU_BASE			0x60
#define SCB_CU_DUMP_RESET_COUNTERS		0x70
#define SCB_CU_STATIC_RESUME			0xa0

// SCB Status Bits CU
#define SCBST_CU_IDLE				0x00			
#define SCBST_CU_SUSPENDED			0x40			
#define SCBST_CU_LPQA				0x80			
#define SCBST_CU_HQPA				0xc0		

#define SCBST_CU_MASK				0xc0	

// SCB Commands words RU
#define SCB_RU_NOP				0x0
#define SCB_RU_START				0x1
#define SCB_RU_RESUME				0x2
#define SCB_RU_RCV_DMA_REDIRECT			0x3
#define SCB_RU_ABORT				0x4
#define SCB_RU_LOAD_HEADER_SIZE			0x5
#define SCB_RU_LOAD_RU_BASE			0x6

// SCB Status Bits RU
#define SCBST_RU_IDLE				0x00
#define SCBST_RU_SUSPENDED			0x04
#define SCBST_RU_NO_RESOURCES			0x08
#define SCBST_RU_READY				0x10

#define SCBST_RU_MASK				0x3c


// Misc flags in RFA
#define RFD_F		0x4000
#define RFD_EOF		0x8000
#define RFD_COUNT_MASK	0xc000



#endif	// JOS_KERN_E100_H
