#include <inc/lib.h>

void umain()
{
	if (fork() == 0)
		cprintf("\n Hey, I'm the child process !!\n");
	else
		cprintf("\n Hey, I'm the parent process !!\n");
}
