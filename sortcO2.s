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
	
	addiu	$2,$5,1
	sll	$2,$2,2
	sll	$5,$5,2
	addu	$5,$4,$5
	addu	$2,$4,$2
	lw	$3,0($5)
	lw	$4,0($2)
	sw	$4,0($5)
	j	$31
	sw	$3,0($2)

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
	.frame	$sp,0,$31		# vars= 0, regs= 0/0, args= 0, gp= 0
	.mask	0x00000000,0
	.fmask	0x00000000,0
	.set	noreorder
	.set	nomacro
	
	blez	$5,.L14
	addiu	$5,$5,-1

	move	$12,$0
	beq	$12,$5,.L14
	li	$11,-1			# 0xffffffffffffffff

.L8:
	beq	$12,$11,.L6
	addiu	$13,$4,4

	lw	$7,0($4)
	lw	$6,4($4)
	slt	$2,$6,$7
	beq	$2,$0,.L6
	move	$9,$13

	addiu	$3,$4,-4
	move	$2,$4
	j	.L7
	move	$8,$12

.L13:
	lw	$7,0($3)
	lw	$6,0($2)
	move	$4,$3
	move	$9,$2
	slt	$10,$6,$7
	addiu	$3,$3,-4
	beq	$10,$0,.L6
	addiu	$2,$2,-4

.L7:
	addiu	$8,$8,-1
	sw	$6,0($4)
	bne	$8,$11,.L13
	sw	$7,0($9)

.L6:
	addiu	$12,$12,1
	bne	$12,$5,.L8
	move	$4,$13

.L14:
	j	$31
	nop

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
	sw	$18,28($sp)
	sw	$31,36($sp)
	sw	$19,32($sp)
	sw	$17,24($sp)
	sw	$16,20($sp)
	blez	$5,.L16
	move	$18,$5

	lui	$19,%hi(.LC0)
	move	$17,$4
	addiu	$19,$19,%lo(.LC0)
	move	$16,$0
.L17:
	lw	$5,0($17)
	addiu	$16,$16,1
	jal	printf
	move	$4,$19

	slt	$2,$16,$18
	bne	$2,$0,.L17
	addiu	$17,$17,4

.L16:
	lw	$31,36($sp)
	lw	$19,32($sp)
	lw	$18,28($sp)
	lw	$17,24($sp)
	lw	$16,20($sp)
	li	$4,10			# 0xa
	j	putchar
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
	sw	$16,16($sp)
	lui	$16,%hi(v)
	addiu	$4,$16,%lo(v)
	sw	$31,20($sp)
	jal	show
	li	$5,10			# 0xa

	addiu	$4,$16,%lo(v)
	jal	sort
	li	$5,10			# 0xa

	addiu	$4,$16,%lo(v)
	lw	$31,20($sp)
	lw	$16,16($sp)
	li	$5,10			# 0xa
	j	show
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
