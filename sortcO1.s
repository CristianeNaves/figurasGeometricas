	.file	1 "sortc.c"
	.section .mdebug.abi32
	.previous
	.gnu_attribute 4, 1
	.text
	.align	2
	.globl	swap
	.set	nomips16
	.ent	swap
	.type	swap, @function
swap:
	.frame	$sp,0,$31		# vars= 0, regs= 0/0, args= 0, gp= 0
	.mask	0x00000000,0
	.fmask	0x00000000,0
	.set	noreorder
	.set	nomacro
	
	sll	$2,$5,2
	addu	$2,$4,$2
	lw	$3,0($2)
	addiu	$5,$5,1
	sll	$5,$5,2
	addu	$4,$4,$5
	lw	$5,0($4)
	sw	$5,0($2)
	j	$31
	sw	$3,0($4)

	.set	macro
	.set	reorder
	.end	swap
	.size	swap, .-swap
	.align	2
	.globl	sort
	.set	nomips16
	.ent	sort
	.type	sort, @function
sort:
	.frame	$sp,48,$31		# vars= 0, regs= 8/0, args= 16, gp= 0
	.mask	0x807f0000,-4
	.fmask	0x00000000,0
	.set	noreorder
	.set	nomacro
	
	addiu	$sp,$sp,-48
	sw	$31,44($sp)
	sw	$22,40($sp)
	sw	$21,36($sp)
	sw	$20,32($sp)
	sw	$19,28($sp)
	sw	$18,24($sp)
	sw	$17,20($sp)
	sw	$16,16($sp)
	move	$19,$4
	blez	$5,.L9
	move	$22,$5

	move	$20,$4
	j	.L5
	move	$16,$0

.L8:
	bltz	$16,.L6
	nop

	lw	$3,0($20)
	lw	$2,4($20)
	slt	$2,$2,$3
	beq	$2,$0,.L6
	nop

	addiu	$17,$20,-4
	move	$18,$20
.L7:
	move	$4,$19
	jal	swap
	move	$5,$16

	addiu	$16,$16,-1
	bltz	$16,.L6
	nop

	lw	$3,0($17)
	lw	$2,0($18)
	addiu	$17,$17,-4
	slt	$2,$2,$3
	bne	$2,$0,.L7
	addiu	$18,$18,-4

.L6:
	addiu	$20,$20,4
	move	$16,$21
.L5:
	addiu	$21,$16,1
	slt	$2,$21,$22
	bne	$2,$0,.L8
	nop

.L9:
	lw	$31,44($sp)
	lw	$22,40($sp)
	lw	$21,36($sp)
	lw	$20,32($sp)
	lw	$19,28($sp)
	lw	$18,24($sp)
	lw	$17,20($sp)
	lw	$16,16($sp)
	j	$31
	addiu	$sp,$sp,48

	.set	macro
	.set	reorder
	.end	sort
	.size	sort, .-sort
	.section	.rodata.str1.4,"aMS",@progbits,1
	.align	2
.LC0:
	.ascii	"%d\011\000"
	.text
	.align	2
	.globl	show
	.set	nomips16
	.ent	show
	.type	show, @function
show:
	.frame	$sp,40,$31		# vars= 0, regs= 5/0, args= 16, gp= 0
	.mask	0x800f0000,-4
	.fmask	0x00000000,0
	.set	noreorder
	.set	nomacro
	
	addiu	$sp,$sp,-40
	sw	$31,36($sp)
	sw	$19,32($sp)
	sw	$18,28($sp)
	sw	$17,24($sp)
	sw	$16,20($sp)
	blez	$5,.L12
	move	$18,$5

	move	$16,$4
	move	$17,$0
	lui	$19,%hi(.LC0)
	addiu	$19,$19,%lo(.LC0)
.L13:
	move	$4,$19
	jal	printf
	lw	$5,0($16)

	addiu	$17,$17,1
	slt	$2,$17,$18
	bne	$2,$0,.L13
	addiu	$16,$16,4

.L12:
	jal	putchar
	li	$4,10			# 0xa

	lw	$31,36($sp)
	lw	$19,32($sp)
	lw	$18,28($sp)
	lw	$17,24($sp)
	lw	$16,20($sp)
	j	$31
	addiu	$sp,$sp,40

	.set	macro
	.set	reorder
	.end	show
	.size	show, .-show
	.align	2
	.globl	main
	.set	nomips16
	.ent	main
	.type	main, @function
main:
	.frame	$sp,24,$31		# vars= 0, regs= 2/0, args= 16, gp= 0
	.mask	0x80010000,-4
	.fmask	0x00000000,0
	.set	noreorder
	.set	nomacro
	
	addiu	$sp,$sp,-24
	sw	$31,20($sp)
	sw	$16,16($sp)
	lui	$16,%hi(v)
	addiu	$4,$16,%lo(v)
	jal	show
	li	$5,10			# 0xa

	addiu	$4,$16,%lo(v)
	jal	sort
	li	$5,10			# 0xa

	addiu	$4,$16,%lo(v)
	jal	show
	li	$5,10			# 0xa

	lw	$31,20($sp)
	lw	$16,16($sp)
	j	$31
	addiu	$sp,$sp,24

	.set	macro
	.set	reorder
	.end	main
	.size	main, .-main
	.globl	v
	.data
	.align	2
	.type	v, @object
	.size	v, 40
v:
	.word	5
	.word	8
	.word	3
	.word	4
	.word	7
	.word	6
	.word	8
	.word	0
	.word	1
	.word	9
	.ident	"GCC: (GNU) 4.4.6"
