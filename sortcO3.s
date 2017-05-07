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
	.frame	$sp,32,$31		# vars= 0, regs= 4/0, args= 16, gp= 0
	.mask	0x80070000,-4
	.fmask	0x00000000,0
	.set	noreorder
	.set	nomacro
	
	addiu	$sp,$sp,-32
	sw	$18,24($sp)
	lui	$18,%hi(v)
	lw	$5,%lo(v)($18)
	sw	$16,16($sp)
	lui	$16,%hi(.LC0)
	sw	$17,20($sp)
	addiu	$4,$16,%lo(.LC0)
	sw	$31,28($sp)
	jal	printf
	addiu	$17,$18,%lo(v)

	lw	$5,4($17)
	jal	printf
	addiu	$4,$16,%lo(.LC0)

	lw	$5,8($17)
	jal	printf
	addiu	$4,$16,%lo(.LC0)

	lw	$5,12($17)
	jal	printf
	addiu	$4,$16,%lo(.LC0)

	lw	$5,16($17)
	jal	printf
	addiu	$4,$16,%lo(.LC0)

	lw	$5,20($17)
	jal	printf
	addiu	$4,$16,%lo(.LC0)

	lw	$5,24($17)
	jal	printf
	addiu	$4,$16,%lo(.LC0)

	lw	$5,28($17)
	jal	printf
	addiu	$4,$16,%lo(.LC0)

	lw	$5,32($17)
	jal	printf
	addiu	$4,$16,%lo(.LC0)

	lw	$5,36($17)
	jal	printf
	addiu	$4,$16,%lo(.LC0)

	jal	putchar
	li	$4,10			# 0xa

	move	$11,$0
	li	$13,9			# 0x9
	move	$7,$17
	li	$10,-1			# 0xffffffffffffffff
	beq	$11,$13,.L28
	move	$4,$11

.L24:
	beq	$11,$10,.L22
	addiu	$12,$7,4

	lw	$6,0($7)
	lw	$5,4($7)
	slt	$2,$5,$6
	beq	$2,$0,.L22
	move	$8,$12

	addiu	$3,$7,-4
	j	.L23
	move	$2,$7

.L29:
	lw	$6,0($3)
	lw	$5,0($2)
	move	$7,$3
	move	$8,$2
	slt	$9,$5,$6
	addiu	$3,$3,-4
	beq	$9,$0,.L22
	addiu	$2,$2,-4

.L23:
	addiu	$4,$4,-1
	sw	$5,0($7)
	bne	$4,$10,.L29
	sw	$6,0($8)

.L22:
	addiu	$11,$11,1
	move	$7,$12
	bne	$11,$13,.L24
	move	$4,$11

.L28:
	lw	$5,%lo(v)($18)
	jal	printf
	addiu	$4,$16,%lo(.LC0)

	lw	$5,4($17)
	jal	printf
	addiu	$4,$16,%lo(.LC0)

	lw	$5,8($17)
	jal	printf
	addiu	$4,$16,%lo(.LC0)

	lw	$5,12($17)
	jal	printf
	addiu	$4,$16,%lo(.LC0)

	lw	$5,16($17)
	jal	printf
	addiu	$4,$16,%lo(.LC0)

	lw	$5,20($17)
	jal	printf
	addiu	$4,$16,%lo(.LC0)

	lw	$5,24($17)
	jal	printf
	addiu	$4,$16,%lo(.LC0)

	lw	$5,28($17)
	jal	printf
	addiu	$4,$16,%lo(.LC0)

	lw	$5,32($17)
	jal	printf
	addiu	$4,$16,%lo(.LC0)

	lw	$5,36($17)
	jal	printf
	addiu	$4,$16,%lo(.LC0)

	lw	$31,28($sp)
	lw	$18,24($sp)
	lw	$17,20($sp)
	lw	$16,16($sp)
	li	$4,10			# 0xa
	j	putchar
	addiu	$sp,$sp,32

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
