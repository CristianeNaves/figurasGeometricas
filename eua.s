.data
	filename: .asciiz "usa.bmp"
	buffer: .space 230454            # peso dos arquivos
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
	li   $a2, 230454
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
	addi $t0, $t0, 54 #pula para o primeiro byte
	lw   $t8, bitmap
	li   $t7 ,0
	li   $s0, 230454
	li   $t2, 32 # t2 = 32
	li   $t6  64 # t6 = 64
desenha:
	beq $t7, $s0, fim
	lb   $t1, 0($t0)
	srl $t3, $t1, 5 # t3 = 00000RRR, dividindo por 32
	lb   $t1, 1($t0)
	srl $t4, $t1, 5 # divide por 32
	lb   $t1, 2($t0)
	srl $t5, $t1, 6  # divide por 64
	sll $t5, $t5, 6  # t5 = BB000000
	sll $t4, $t4, 3  # t4 = 00GGG000
	or $t3, $t3, $t4 # t3 = 00GGGRRR
	or $t3, $t3, $t5 # t3 = BBGGGRRR
	sb  $t3, 0($t8)  # coloca cor na memória
	addi $t8, $t8, 1 # aponta pro proximo pixel pra desenhar
	addi $t0, $t0, 3 # vai pro proximo rgb do arquivo
	addi $t7, $t7, 1 # contador += 1
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
