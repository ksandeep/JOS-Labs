#include <inc/lib.h>
#define N 65536
//#define N 131072

void umain()
{

	int i;
	struct Page *p = NULL;
	void *va = (void*)0xF000;
	
	// Leak the low memory pages
	i = sys_page_waste(&p, N);
	cprintf("\n Pages leaked / wasted: %d\n", i);
	
	// Allocate a new page
	i = sys_page_alloc(0, va, PTE_P | PTE_U | PTE_W );
	if (i < 0)
		cprintf("\n Page allocation failed!!\n");
	*(int*)va = 35;

	cprintf("\n Physical address of allocated page  = %x, value at va = %d\n", (p-pages)<<12, *(int*)va);
		

}
