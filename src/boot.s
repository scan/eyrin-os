.section ".text.boot"
 
.globl start
 
// r15 -> should begin execution at 0x8000.
// r0 -> 0x00000000
// r1 -> 0x00000C42
// r2 -> 0x00000100 - start of ATAGS
start:
	mov	sp, #0x8000
 
	ldr	r4, =_bss_start
	ldr	r9, =_bss_end
	mov	r5, #0
	mov	r6, #0
	mov	r7, #0
	mov	r8, #0
    b       2f
1:
	stmia	r4!, {r5-r8}
2:
	cmp	r4, r9
	blo	1b

    blx _init
 
	ldr	r3, =main
	blx	r3

    blx _fini
halt:
	wfe
	b	halt
