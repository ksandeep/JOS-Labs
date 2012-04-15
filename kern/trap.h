/* See COPYRIGHT for copyright information. */

#ifndef JOS_KERN_TRAP_H
#define JOS_KERN_TRAP_H
#ifndef JOS_KERNEL
# error "This is a JOS kernel header; user programs should not #include it"
#endif

#include <inc/trap.h>
#include <inc/mmu.h>

/* The kernel's interrupt descriptor table */
extern struct Gatedesc idt[];

// Code added by Sandeep / Swastika (Lab 3)
// Handler functions
extern void hndl_div_by_zero();
extern void hndl_general_protection();
extern void hndl_page_fault();
extern void hndl_breakpoint();
extern void hndl_syscall();
extern void hndl_interrupt_timer();
extern void hndl_interrupt_kbd();
extern void hndl_interrupt_serial();

void idt_init(void);
void print_regs(struct PushRegs *regs);
void print_trapframe(struct Trapframe *tf);
void page_fault_handler(struct Trapframe *);
void backtrace(struct Trapframe *);

#endif /* JOS_KERN_TRAP_H */
