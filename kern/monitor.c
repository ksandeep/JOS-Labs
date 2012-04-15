// Simple command-line kernel monitor useful for
// controlling the kernel and exploring the system interactively.

#include <inc/stdio.h>
#include <inc/string.h>
#include <inc/memlayout.h>
#include <inc/assert.h>
#include <inc/x86.h>

#include <kern/console.h>
#include <kern/monitor.h>
#include <kern/kdebug.h>
#include <kern/trap.h>
#include <kern/pmap.h>


#define CMDBUF_SIZE	80	// enough for one VGA text line

extern pde_t *boot_pgdir;
struct Command {
	const char *name;
	const char *desc;
	// return -1 to force monitor to exit
	int (*func)(int argc, char** argv, struct Trapframe* tf);
};

static struct Command commands[] = {
	{ "help", "Display this list of commands", mon_help },
	{ "kerninfo", "Display information about the kernel", mon_kerninfo },
	{ "backtrace", "Display backtrace information", mon_backtrace },
	{ "showmappings", "Show physical page mappings for a virtual address range", mon_showmappings },
	{ "changeperm", "Update the permissions for a particular page corresponding to a virtual address", mon_changeperm },
	{ "alloc_page", "Explicitly allocate a page and print the physical address", mon_allocpage },
	{ "free_page", "Explicitly free a page given its physical address", mon_freepage },
	{ "page_status", "Display the status of the page at a physical address", mon_statuspage },
	
};
#define NCOMMANDS (sizeof(commands)/sizeof(commands[0]))

unsigned read_eip();
uintptr_t string_to_hex(char *p);
char * show_perm (int p);

/***** Implementations of basic kernel monitor commands *****/
int 
mon_statuspage(int argc, char **argv, struct Trapframe *tf)
{
	if (argc != 2)
	{	
		cprintf("\n Invalid no. of arguments !! \n");
		return 0;
	}
	uintptr_t pa = string_to_hex(argv[1]);
	struct Page *p = pa2page(pa);
	if (p->pp_ref == 0)
		cprintf("\n free\n");
	else
		cprintf("\n allocated\n");
	return 0;
}
int 
mon_freepage(int argc, char **argv, struct Trapframe *tf)
{
	if (argc != 2)
	{	
		cprintf("\n Invalid no. of arguments !! \n");
		return 0;
	}
	uintptr_t pa = string_to_hex(argv[1]);
	struct Page *p = pa2page(pa);
	if (p->pp_ref == 0)
		return 0;
	page_free(p);
	p->pp_ref = 0;
	return 0;
}	
	
int 
mon_allocpage(int argc, char **argv, struct Trapframe *tf)
{
	if (argc != 1)
	{	
		cprintf("\n Invalid no. of arguments !! \n");
		return 0;
	}	
	struct Page *p;
	int ret = page_alloc(&p);
	if (ret == -4)
	{
		cprintf("\n No memory to allocate a page !! \n");
		return 0;
	}	
	else 
	{
		p->pp_ref++;
		cprintf("\n Page allocated: %x !! \n", PTE_ADDR(page2pa(p)));
		return 0;
	}	
}

int 
mon_changeperm(int argc, char **argv, struct Trapframe *tf)
{
	if (argc != 3)
	{	
		cprintf("\n Invalid no. of arguments !! \n");
		return 0;
	}	
	uintptr_t va = string_to_hex(argv[1]);
	int perm = (int)string_to_hex (argv[2]);
	if ((va < 0) | (perm < 0))
	{	
		cprintf("\n Invalid input !! \n");
		return 0;
	}
	pte_t *pte = pgdir_walk(boot_pgdir, (const void*)va, 0);
	if (pte == NULL)
	{
		cprintf("\n Error!! Page Table does not exist !!\n");
		return 0;
	}
	physaddr_t p = (physaddr_t)*pte;
	*pte = *pte & (~0xFFF); 		// clear the existing permissions
	*pte = *pte | perm;			// set the new permissions
	return 0;
}
int 
mon_showmappings(int argc, char **argv, struct Trapframe *tf)
{
	if (argc != 3)
	{	
		cprintf("\n Invalid no. of arguments !! \n");
		return 0;
	}	
	uintptr_t va_start = string_to_hex(argv[1]);
	uintptr_t va_end = string_to_hex(argv[2]);
	if ((va_start < 0) | (va_end < 0) | (va_start > va_end))
	{	
		cprintf("\n Invalid input !! \n");
		return 0;
	}
	uintptr_t i;
	physaddr_t p;
	pte_t *pte;
	for (i = va_start; i <= va_end ; i = i+PGSIZE)
	{
		pte = pgdir_walk(boot_pgdir, (const void *)i, 0);
		if (pte == NULL)
		{
			cprintf("\n Error!! Page Table does not exist !!\n");
			return 0;
		}
		p = (physaddr_t)*pte;
		cprintf("\n Virtual address = %x, Physical Address mapped = %x, Permission bits = %x", i, PTE_ADDR(p), p & 0xFFF);
	}
	cprintf("\n\n");
	return 0;
}

 
int
mon_help(int argc, char **argv, struct Trapframe *tf)
{
	int i;
	/*	
	// added for testing cprintf printing Octal numbers 
	cprintf("\n Octal no %o \n", 610 );
	unsigned int j=0x00646c72;
	cprintf("\n Address of j = %x \n", &j);
	cprintf("H%x Wo%s\n",57616,&j);
	cprintf("\n x=%d y=%d \n",4);
	*/



	for (i = 0; i < NCOMMANDS; i++)
		cprintf("%s - %s\n", commands[i].name, commands[i].desc);
	return 0;
}

int
mon_kerninfo(int argc, char **argv, struct Trapframe *tf)
{
	extern char _start[], etext[], edata[], end[];

	cprintf("Special kernel symbols:\n");
	cprintf("  _start %08x (virt)  %08x (phys)\n", _start, _start - KERNBASE);
	cprintf("  etext  %08x (virt)  %08x (phys)\n", etext, etext - KERNBASE);
	cprintf("  edata  %08x (virt)  %08x (phys)\n", edata, edata - KERNBASE);
	cprintf("  end    %08x (virt)  %08x (phys)\n", end, end - KERNBASE);
	cprintf("Kernel executable memory footprint: %dKB\n",
		(end-_start+1023)/1024);
	return 0;
}

int
mon_backtrace(int argc, char **argv, struct Trapframe *tf)
{
	// Your code here.
	unsigned int  eip = read_eip();
	unsigned int  * ebp = (unsigned int *) read_ebp();
	char a[50];
	int ret;
	
	struct Eipdebuginfo *edi = NULL; 

	cprintf("Stack backtrace:\n");
	
	while (ebp != 0x0){
	
	memset(edi, 0, sizeof(struct Eipdebuginfo));
	ret = debuginfo_eip(eip , edi);
	if (ret == -1)
	{
		cprintf("\n Debuginfo_eip threw an error !!!\n");
		return -1;
	}
	
	strncpy (a, edi->eip_fn_name, edi->eip_fn_namelen);
	a[edi->eip_fn_namelen] = '\0';

	cprintf("ebp %08x eip %08x ", ebp, eip);
	cprintf("args %08x %08x %08x %08x %08x \n", *(ebp+2), *(ebp+3),*(ebp+4),*(ebp+5),*(ebp+6));
	cprintf("%s:%d: %s+%d \n",edi->eip_file, edi->eip_line, a,eip - edi->eip_fn_addr); 
	
	eip = (unsigned int) *(ebp+1);
	ebp = (unsigned int *) *ebp;
	}
	memset(edi, 0, sizeof(struct Eipdebuginfo));
	debuginfo_eip(eip , edi);
	
	strncpy (a, edi->eip_fn_name, edi->eip_fn_namelen);
	a[edi->eip_fn_namelen] = '\0';

	cprintf("ebp %08x eip %08x ", ebp, eip);
	cprintf("args %08x %08x %08x %08x %08x \n", *(ebp+2), *(ebp+3),*(ebp+4),*(ebp+5),*(ebp+6));
	cprintf("%s:%d: %s+%d \n",edi->eip_file, edi->eip_line, a,eip - edi->eip_fn_addr); 
	
	return 0;
}



/***** Kernel monitor command interpreter *****/

#define WHITESPACE "\t\r\n "
#define MAXARGS 16

static int
runcmd(char *buf, struct Trapframe *tf)
{
	int argc;
	char *argv[MAXARGS];
	int i;

	// Parse the command buffer into whitespace-separated arguments
	argc = 0;
	argv[argc] = 0;
	while (1) {
		// gobble whitespace
		while (*buf && strchr(WHITESPACE, *buf))
			*buf++ = 0;
		if (*buf == 0)
			break;

		// save and scan past next arg
		if (argc == MAXARGS-1) {
			cprintf("Too many arguments (max %d)\n", MAXARGS);
			return 0;
		}
		argv[argc++] = buf;
		while (*buf && !strchr(WHITESPACE, *buf))
			buf++;
	}
	argv[argc] = 0;

	// Lookup and invoke the command
	if (argc == 0)
		return 0;
	for (i = 0; i < NCOMMANDS; i++) {
		if (strcmp(argv[0], commands[i].name) == 0)
			return commands[i].func(argc, argv, tf);
	}
	cprintf("Unknown command '%s'\n", argv[0]);
	return 0;
}

void
monitor(struct Trapframe *tf)
{
	char *buf;

	cprintf("Welcome to the JOS kernel monitor!\n");
	cprintf("Type 'help' for a list of commands.\n");

	if (tf != NULL)
		print_trapframe(tf);

	while (1) {
		buf = readline("K> ");
		if (buf != NULL)
			if (runcmd(buf, tf) < 0)
				break;
	}
}

// return EIP of caller.
// does not work if inlined.
// putting at the end of the file seems to prevent inlining.
unsigned
read_eip()
{
	uint32_t callerpc;
	__asm __volatile("movl 4(%%ebp), %0" : "=r" (callerpc));
	return callerpc;
}

uintptr_t string_to_hex (char *p)
{
	uintptr_t res = 0;
	int i=2;
	int x;
	if ((p[0] != '0') | (p[1] != 'x'))
		return -1;
	while (p[i] != '\0')
	{
		switch(p[i])
		{
			case '0': x = 0; break;
			case '1': x = 1; break;
			case '2': x = 2; break;
			case '3': x = 3; break;
			case '4': x = 4; break;
			case '5': x = 5; break;
			case '6': x = 6; break;
			case '7': x = 7; break;
			case '8': x = 8; break;
			case '9': x = 9; break;
			case 'a': x = 10; break;
			case 'b': x = 11; break;	
			case 'c': x = 12; break;
			case 'd': x = 13; break;
			case 'e': x = 14; break;
			case 'f': x = 15; break;
			default: return -1;
		}
		res = 16*res + x;	
		i++;	
	}
	return res;
}

char * show_perm (int p)
{
	switch (p)
	{
		case 0: return "No permissions"; break;
		case 1: return "PTE_P"; break;
		case 2: return "PTE_W"; break;
		case 4: return "PTE_U"; break;
		case 3: return "PTE_P | PTE_W"; break;
		case 5: return "PTE_P | PTE_U"; break;
		case 6: return "PTE_U | PTE_W"; break;
		case 7: return "PTE_P | PTE_W | PTE_U"; break;
		default: return "Permissions unexplored !!"; break;
	}


}
	
