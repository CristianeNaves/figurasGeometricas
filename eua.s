.data
	filename: .asciiz "usa.bin"
	buffer: .space 76800            # peso dos arquivos
	bitmap: .word 0xff000000
.text
	la $a0, filename
	li $a1, 0
	li $a2, 0
	li $v0, 13
	syscall
	bltz $v0, file_error
	move $a0, $v0
	la   $a1, buffer 
	li   $a2, 76800
read_file:
	li $v0, 14
	syscall
	beqz $v0, read_done # v0 = 0 significa que terminou, porque leu EOF
	bltz $v0, read_error# v0 = -1 significa que deu erro
	addu $a1, $a1, $v0  # v0 = 1 ocorreu tudo normalmente e o byte foi para o endereço apontado por $a1
	subu $a2, $a2  $v0  # a2 = a2 - 1,  ou seja, quantos bytes ainda faltam ler.		    # entao a1 = a1 + 1, ou seja, aponta pro proximo byte
	bnez $a2, read_file # se os bytes alocados no .data acabarem, a leitura tambem precisa acabar.
read_done:
	addi $sp, $sp, -4
	sw   $s0, 0($sp)
	la   $t0, buffer
	lw   $t8, bitmap
	move $s0, $t0
	addi $s0, $s0, 76800
desenha:
	beq $t0, $s0, fim
	lb   $t1, 0($t0)
	sb   $t1, 0($t8)  # coloca cor na memória
	addi $t8, $t8, 1 # aponta pro proximo pixel pra desenhar
	addi $t0, $t0, 1 # vai pro proximo rgb do arquivo
	j desenha
fim:
	lw $s0 0($sp)
	addi $sp, $sp, 4
	li $v0, 10
	syscall
	
	
read_error:
	li $v0, 10
	syscall
file_error:
	li $v0, 10
	syscall
