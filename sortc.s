	# .file		Indica o primeiro inteiro como o número de indice do arquivo na tabela e a string que segue como o nome do arquivo
	# .section		Monta o código que a segue sobre um certo nome
	# .previous		Troca a section atual com a anterior mais recente
	# .gnu_attribute	Atribui ao arquivo um valor de objeto gnu, sendo o primeiro argumento um indicador do tipo de hardware para operações de ponto flutuante a máquina possui
	# .globl	Torna o label v como visivel para todos os programas parciais ligados com este.
	# .data  	É usado para separar as declarações de variáveis
	# .align	Alinha o contador de endereços de forma que ele sempre seja um numero multiplo do argumento
	# .type 	Usado para atribuir um tipo a um simbolo
	# .size		Indica o tamanho em bytes do label v.
	# .word  	É usado para alocar e inicializar espaço para as variáveis
	# .rdata 	Indica dados para serem usados apenas para leitura
	# .ascii  	Monta cada string passada em endereços consecutivos, sem a quebra automatica de fim de linha.
	# .text   	Mostra para o montador que os 'textos' apos o .text são instruções de linguagem
	# .ent 		Marca o começo de uma função
	# .frame 	Descreve o tamanho da janela da pilha, geralmente o ponteiro da janela é guardado em $fp ou $sp
	# .mask 	Indica qual registrador de inteiros esta salvo na pilha
	# .fmask 	Indica quais registradores de ponto flutuante estão salvos na pilha
	# .set 		Habilita ou desabilitas caracteristicas do montador indicadas pelo argumento, colocando-se "caracteristica", para habilitar e "nocaracteristica" para desabilitar
	# .ident 	Coloca uma tag qualquer no arquivo montado
	
		.file	1 "sortc.c" 
		.section .mdebug.abi32
		.previous
		.gnu_attribute 4, 1
		.globl	v
		.data
		.align	2
		#.type	v, @object
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
		.rdata
		.align	2
	.LC0:
		.ascii	"%d\011\000"
		.text
		#.align	2
		.globl	show
		.set	nomips16
		.ent	show
		#.type	show, @function
		
	main:
		.frame	$fp,24,$31		# vars= 0, regs= 2/0, args= 16, gp= 0
		.mask	0xc0000000,-4
		.fmask	0x00000000,0
		.set	noreorder
		.set	nomacro
		
		addiu	$sp,$sp,-24
		sw	$31,20($sp)
		sw	$fp,16($sp)
		move	$fp,$sp
		la      $4, v
		li	$5,10			# 0xa
		jal	show
		nop

		la      $4, v
		li	$5,10			# 0xa
		jal	sort
		nop

		la	$4, v
		li	$5,10			# 0xa
		jal	show
		nop

		move	$sp,$fp
		lw	$31,20($sp)
		lw	$fp,16($sp)
		addiu	$sp,$sp,24
		li	$2,10
		syscall
		
	show:
		.frame	$fp,32,$31		# vars= 8, regs= 2/0, args= 16, gp= 0
		.mask	0xc0000000,-4
		.fmask	0x00000000,0
		.set	noreorder
		.set	nomacro
		
		addiu	$sp,$sp,-32
		sw	$31,28($sp)
		sw	$fp,24($sp)
		move	$fp,$sp
		sw	$4,32($fp)
		sw	$5,36($fp)
		sw	$0,16($fp)
		j	.L2
		nop

	.L3:
		lw	$2,16($fp)
		sll	$2,$2,2
		lw	$3,32($fp)
		addu	$2,$3,$2
#		lw	$2,0($2)
#		lui	$3,%hi(.LC0)
#		addiu	$4,$3,%lo(.LC0)
#		move	$5,$2		
#		jal	printf		
#		nop
		lw	$4,0($2)
		li	$2,1
		syscall

		lw	$2,16($fp)
		addiu	$2,$2,1
		sw	$2,16($fp)
	.L2:
		lw	$3,16($fp)
		lw	$2,36($fp)
		slt	$2,$3,$2
		bne	$2,$0,.L3
		nop
#		li	$4,10			# 0xa		
#		jal	putchar		
#		nop
		move	$sp,$fp
		lw	$31,28($sp)
		lw	$fp,24($sp)
		addiu	$sp,$sp,32
		jr	$31
		nop

		.set	macro
		.set	reorder
		.end	show
		.size	show, .-show
		#.align	2
		.globl	swap
		.set	nomips16
		.ent	swap
		#.type	swap, @function
	swap:
		.frame	$fp,16,$31		# vars= 8, regs= 1/0, args= 0, gp= 0
		.mask	0x40000000,-4
		.fmask	0x00000000,0
		.set	noreorder
		.set	nomacro
		
		addiu	$sp,$sp,-16
		sw	$fp,12($sp)
		move	$fp,$sp
		sw	$4,16($fp)
		sw	$5,20($fp)
		lw	$2,20($fp)
		sll	$2,$2,2
		lw	$3,16($fp)
		addu	$2,$3,$2
		lw	$2,0($2)
		sw	$2,0($fp)
		lw	$2,20($fp)
		sll	$2,$2,2
		lw	$3,16($fp)
		addu	$2,$3,$2
		lw	$3,20($fp)
		addiu	$3,$3,1
		sll	$3,$3,2
		lw	$4,16($fp)
		addu	$3,$4,$3
		lw	$3,0($3)
		sw	$3,0($2)
		lw	$2,20($fp)
		addiu	$2,$2,1
		sll	$2,$2,2
		lw	$3,16($fp)
		addu	$2,$3,$2
		lw	$3,0($fp)
		sw	$3,0($2)
		move	$sp,$fp
		lw	$fp,12($sp)
		addiu	$sp,$sp,16
		jr	$31
		nop

		.set	macro
		.set	reorder
		.end	swap
		.size	swap, .-swap
		#.align	2
		.globl	sort
		.set	nomips16
		.ent	sort
		#.type	sort, @function
	sort:
		.frame	$fp,32,$31		# vars= 8, regs= 2/0, args= 16, gp= 0
		.mask	0xc0000000,-4
		.fmask	0x00000000,0
		.set	noreorder
		.set	nomacro
		
		addiu	$sp,$sp,-32
		sw	$31,28($sp)
		sw	$fp,24($sp)
		move	$fp,$sp
		sw	$4,32($fp)
		sw	$5,36($fp)
		sw	$0,20($fp)
		j	.L8
		nop

	.L12:
		lw	$2,20($fp)
		addiu	$2,$2,-1
		sw	$2,16($fp)
		j	.L9
		nop

	.L11:
		lw	$4,32($fp)
		lw	$5,16($fp)
		jal	swap
		nop

		lw	$2,16($fp)
		addiu	$2,$2,-1
		sw	$2,16($fp)
	.L9:
		lw	$2,16($fp)
		bltz	$2,.L10
		nop

		lw	$2,16($fp)
		sll	$2,$2,2
		lw	$3,32($fp)
		addu	$2,$3,$2
		lw	$3,0($2)
		lw	$2,16($fp)
		addiu	$2,$2,1
		sll	$2,$2,2
		lw	$4,32($fp)
		addu	$2,$4,$2
		lw	$2,0($2)
		slt	$2,$2,$3
		bne	$2,$0,.L11
		nop

	.L10:
		lw	$2,20($fp)
		addiu	$2,$2,1
		sw	$2,20($fp)
	.L8:
		lw	$3,20($fp)
		lw	$2,36($fp)
		slt	$2,$3,$2
		bne	$2,$0,.L12
		nop

		move	$sp,$fp
		lw	$31,28($sp)
		lw	$fp,24($sp)
		addiu	$sp,$sp,32
		jr	$31
		nop

		.set	macro
		.set	reorder
		.end	sort
		.size	sort, .-sort
		#.align	2
		.globl	main
		.set	nomips16
		.ent	main
		#.type	main, @function
 #		main:		 +	
 #		.frame	$fp,24,$31		# vars= 0, regs= 2/0, args= 16, gp= 0
 #		.mask	0xc0000000,-4		
 #		.fmask	0x00000000,0		
 #		.set	noreorder		
 #		.set	nomacro		
 #				
 #		addiu	$sp,$sp,-24		
 #		sw	$31,20($sp)		
 #		sw	$fp,16($sp)		
 #		move	$fp,$sp		
 #		lui	$2,%hi(v)		
 #		addiu	$4,$2,%lo(v)		
 #		li	$5,10			# 0xa		
 #		jal	show		
 #		nop		
 #		
 #		lui	$2,%hi(v)		
 #		addiu	$4,$2,%lo(v)		
 #		li	$5,10			# 0xa		
 #		jal	sort		
 #		nop		
 #		
 #		lui	$2,%hi(v)		
 #		addiu	$4,$2,%lo(v)		
 #		li	$5,10			# 0xa		
 #		jal	show		
 #		nop		
 #		
 #		move	$sp,$fp		
 #		lw	$31,20($sp)		
 #		lw	$fp,16($sp)		
 #		addiu	$sp,$sp,24		
 #		j	$31		
 #		nop

		.set	macro
		.set	reorder
		.end	main
		.size	main, .-main
		.ident	"GCC: (GNU) 4.4.6"
