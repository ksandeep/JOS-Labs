/* See COPYRIGHT for copyright information. */

#include <inc/mmu.h>
#include <inc/memlayout.h>
#include <inc/trap.h>

#include <kern/picirq.h>


###################################################################
# exceptions/interrupts
###################################################################

/* The TRAPHANDLER macro defines a globally-visible function for handling
 * a trap.  It pushes a trap number onto the stack, then jumps to _alltraps.
 * Use TRAPHANDLER for traps where the CPU automatically pushes an error code.
 */ 
#define TRAPHANDLER(name, num)						\
	.globl name;		/* define global symbol for 'name' */	\
	.type name, @function;	/* symbol type is function */		\
	.align 2;		/* align function definition */		\
	name:			/* function starts here */		\
	pushl $(num);							\
	jmp _alltraps

/* Use TRAPHANDLER_NOEC for traps where the CPU doesn't push an error code.
 * It pushes a 0 in place of the error code, so the trap frame has the same
 * format in either case.
 */
#define TRAPHANDLER_NOEC(name, num)					\
	.globl name;							\
	.type name, @function;						\
	.align 2;							\
	name:								\
	pushl $0;							\
	pushl $(num);							\
	jmp _alltraps

.text

/*
 * Lab 3a: Your code here for generating entry points for the different traps.
 */
	/* Code added by Swastika / Sandeep */
	TRAPHANDLER_NOEC (hndl_div_by_zero, T_DIVIDE);
	TRAPHANDLER (hndl_general_protection, T_GPFLT);
	TRAPHANDLER (hndl_page_fault, T_PGFLT);
	TRAPHANDLER_NOEC (hndl_breakpoint, T_BRKPT);
	TRAPHANDLER_NOEC (hndl_syscall, T_SYSCALL);
	TRAPHANDLER_NOEC (hndl_interrupt_timer, IRQ_OFFSET + IRQ_TIMER);
	TRAPHANDLER_NOEC (hndl_interrupt_kbd, IRQ_OFFSET + IRQ_KBD);
	TRAPHANDLER_NOEC (hndl_interrupt_serial, IRQ_OFFSET + IRQ_SERIAL);
	
	/*TRAPHANDLER_NOEC (hndl_debug_exceptions, T_DEBUG);
	TRAPHANDLER_NOEC (hndl_overflow, T_OFLOW);
	TRAPHANDLER_NOEC (hndl_bounds_check, T_BOUND);
	TRAPHANDLER_NOEC (hndl_illegal_opcode, T_ILLOP);
	TRAPHANDLER_NOEC (hndl_device, T_DEVICE);
	TRAPHANDLER (hndl_double_fault, T_DBLFLT);
	TRAPHANDLER (hndl_invalid_tss, T_TSS);
	TRAPHANDLER (hndl_segment_np, T_SEGNP);
	TRAPHANDLER (hndl_stack_exception, T_STACK);
	*/


/*
 * Lab 3a: Your code here for _alltraps
 */
_alltraps:
	pushl %ds;		/* Push ds*/				\
	pushl %es;		/* Push es*/				\
	pushal;			/* Push flags*/				\
	movl $GD_KD, %eax;
	movl %eax, %ds;		/*Load ds*/
	movl %eax, %es;		/* Load es*/
	pushl %esp;		/* Push esp value in the stack*/
	call trap		/* Call trap function */
