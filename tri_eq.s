.text	
	li $a0, 0
	li $a1, 0
	li $a2, 0xff
		
	jal preenchimento2
	
	li $a0, 160
	li $a1, 120
	li $a2, 0x00
		
	jal preenchimento2

	li $a0, 100
	li $a1, 100
	li $a2, 80
	li $a3,0x38
	jal trieq
	
	li $a0, 100
	li $a1, 100
	li $a2, 0x38
		
	jal preenchimento2
	
	li $a0, 300
	li $a1, 200
	li $a2, 100
	li $a3,0x88
	jal trieq
	
	li $a0, 190
	li $a1, 120
	li $a2, 80
	li $a3,0x3f #0x3f
	jal trieq
	
	li $a0, 190
	li $a1, 96
	li $a2, 40
	li $a3,0x3f
	jal trieq
	
	li $a0, 190
	li $a1, 96
	li $a2, 0x3f
		
	jal preenchimento2
	
	li $a0, 170
	li $a1, 131
	li $a2, 40
	li $a3,0x3f
	jal trieq
	
	li $a0, 170
	li $a1, 131
	li $a2, 0x3f
		
	jal preenchimento2
	
	li $a0, 210
	li $a1, 131
	li $a2, 40
	li $a3,0x3f
	jal trieq
	
	li $a0, 210
	li $a1, 131
	li $a2, 0x3f
		
	jal preenchimento2
	
	
	li $v0, 10
	syscall
	
# Funcao Quadrado recebe:
# $a0 x1   word
# $a1 y1   word
# $a2 lado word
# $a3  cor  byte
trieq:
	addi $sp, $sp, -32
	li $t1, 866
	mult $a2, $t1
	mflo $t0
	li $t1, 1000
	div $t0, $t1
	sw   $s0, 0($sp)
	sw   $s1, 4($sp)
	sw   $s2, 8($sp)
	sw   $s3, 12($sp)
	sw   $ra, 16($sp)
	sw   $s4, 20($sp)
	sw   $s5, 24($sp)
	sw   $s6, 28($sp)
	mflo $s6 # s6 = h
	move $s2, $a2 # salva lado
	move $s3, $a3 # salva a cor
	li $t0, 3
	div $s6, $t0
	mflo $s4 # s4 = h/3
	li $t0, 2
	div $a2, $t0
	mflo $s5    #s5 = L/2
	sub $t1, $a1, $s4
	sub $t1, $t1, $s4 # t1 += 2/3h
	move $a1, $t1
	sub  $a2, $a0,$s5
	add  $a3, $s6, $a1
	move $s0, $a2
	move $s1, $a3
	move $t0, $s3
	jal reta2 # reta p1 -> p2
	move $a0 ,$s0
	move $a1, $s1
	add  $a2, $s2, $s0
	move $a3, $a1
	move $s0, $a2
	move $s1, $a3
	move $t0, $s3
	jal reta2 # reta p2 -> p3
	move $a0, $s0
	move $a1, $s1
	sub  $a2, $a0, $s5
	sub  $a3, $a1, $s6
	move $t0, $s3
	jal reta2 # reta p3 -> p1
	
	
	lw   $s0, 0($sp)
	lw   $s1, 4($sp)
	lw   $s2, 8($sp)
	lw   $s3, 12($sp)
	lw   $ra, 16($sp)
	lw   $s5, 24($sp)
	lw   $s6, 28($sp)
	addi $sp, $sp, 32
	jr $ra


# Função reta recebe:
# $a0 coordenada x do primeiro ponto (x0)
# $a1 coordenada y do primeiro ponto (y0)
# $a2 coordenada x do segundo ponto (x1)
# $a3 coordenada y do segundo ponto (y1)
# $t0 cor da reta

reta2:
	#inicializacao
	addi $sp, $sp, -40
	sw $ra, 36($sp)
	sw $s7, 32($sp)
	sw $s6, 28($sp)
	sw $s5, 24($sp)
	sw $s4, 20($sp)
	sw $s3, 16($sp)
	sw $s2, 8($sp)
	sw $s1, 4($sp)
	sw $s0, 0($sp)
	move $s7, $t0 #s7 cor da reta
	
	blt $a0, $a2, e_sw_p #x0 >= x1?
sw_p:	#troca os dois pontos
	move $t0, $a0
	move $a0, $a2
	move $a2, $t0 #troca os x
	move $t1, $a1
	move $a1, $a3
	move $a3, $t1 #troca os y
e_sw_p:	# x0 <= x1
	sub $s0, $a2, $a0 #dx ($s0) = x1 - x0
	sub $s1, $a3, $a1 #dy ($s1) = y1 - y0
	slt $t0, $s1, $zero
	add $t0, $t0, $t0 # 0, se dy >= 0; 2, se dy < 0
	li $s2, 1
	sub $s2, $s2, $t0 # slope ($s2) = {1, se dy >= 0; -1, se dy < 0}
	
	blt $zero, $s2, continua
	sub $s1, $zero, $s1 #dy = -dy
continua:
	bgt $s1, $s0, r45_90 #dy > dx
r0_45:	# $s0 = dx
	# $s1 = dy
	# $s2 = slope
	sub $s4, $s0, $s1 #goNE (northeast) ($s4) = dx - dy
	sub $s5, $zero, $s1 #goE ($s5) = -dy
	add $s3, $s4, $s5 #D ($s3) = dx - 2dy = goE + goNE
# s0 = dx, nao eh mais necessario
# s1 = dy, nao eh mais necessario
# s2 = slope
# s3 = D
# s4 = goNE
# s5 = goE
# s7 = cor
	move $s0, $a0
	move $s1, $a1
# s0 = x_atual
# s1 = y_atual
	move $s6, $a2
# s6 = x_final
lo0_45:	
	move $a0, $s0
	move $a1, $s1
	move $a2, $s7
	jal ponto
	beq $s0, $s6, fin #cheguei no ultimo pixel?
	blt $s3, $zero, ne0_45 #D < 0?
	j e0_45
ne0_45:	#x++; y+= slope;
	add $s3, $s3, $s4 #D = D + goNE
	addi $s0, $s0, 1
	add $s1, $s1, $s2
	j lo0_45
e0_45:	#x++;
	add $s3, $s3, $s5 #D = D + goE
	addi $s0, $s0, 1
	j lo0_45
r45_90:	# $s0 = dx
	# $s1 = dy
	# $s2 = slope
	sub $s4, $s0, $s1 #goNE (northeast) ($s4) = dx - dy
	add $s5, $zero, $s0 #goN ($s5) = dx
	add $s3, $s4, $s5 #D ($s3) = 2dx - dy = goN + goNE
# s0 = dx, nao eh mais necessario
# s1 = dy, nao eh mais necessario
# s2 = slope
# s3 = D
# s4 = goNE
# s5 = goN
# s7 = cor
	move $s0, $a0
	move $s1, $a1
# s0 = x_atual
# s1 = y_atual
	move $s6, $a3
# s6 = y_final
lo45_90:	
	move $a0, $s0
	move $a1, $s1
	move $a2, $s7
	jal ponto
	beq $s1, $s6, fin #cheguei no ultimo pixel?
	blt $s3, $zero, n45_90 #D < 0?
	j ne45_90
ne45_90:#x++; y+= slope;
	add $s3, $s3, $s4 #D = D + goNE
	addi $s0, $s0, 1
	add $s1, $s1, $s2
	j lo45_90
n45_90:	#y += slope;
	add $s3, $s3, $s5 #D = D + goN
	add $s1, $s1, $s2
	j lo45_90
fin:
	#finalizacao
	lw $ra, 36($sp)
	lw $s7, 32($sp)
	lw $s6, 28($sp)
	lw $s5, 24($sp)
	lw $s4, 20($sp)
	lw $s3, 16($sp)
	lw $s2, 8($sp)
	lw $s1, 4($sp)
	lw $s0, 0($sp)
	addi $sp, $sp, 40
	jr $ra


# Função ponto recebe:
# $s0 endereço de memória do bitmap
# $a0 coordenada x do pixel a ser colorido
# $a1 coordenada y do pixel a ser colorido
# $a2 cor do pixel a ser colorido
# Salvar os valores anteriores dos registradores na pilha?
# Seguindo a convencao utilizada os valores $t e $a nao sao
# permantentes, logo nao precisa usar a pilha

ponto:
	addiu $t0, $zero, 0xff000000 #endereco inicial mmio
	mul $t1,$a1, 320  #y * 320
	addu $t1, $t1, $a0 # y * 320 + x
	addu $t0, $t0, $t1 #0xff000000 + 320 * y + x
	sb $a2, 0($t0) #desenha
	jr $ra

#Funcao preenchimento2
# $a0 x0 (0, 319) => 16 bits (halfword)
# $a1 y0 (0, 239) => 16 bits (halfword)
# $a2 cor2

preenchimento2:
		addi $sp, $sp -4
		sw $ra, 0($sp)
		
		move $a3, $a2
		
		addiu $t0, $zero, 0xff000000 #endereco inicial mmio
		mul $t1,$a1, 320  #y * 320
		addu $t1, $t1, $a0 # y * 320 + x
		addu $t0, $t0, $t1 #0xff000000 + 320 * y + x
		lb $a2, 0($t0) #pega a cor do pixel
		
		jal preenchimento

		lw $ra, 0($sp)
		addi $sp, $sp 4
		jr $ra


#Funcao preenchimento
# $a0 x0 (0, 319) => 16 bits (halfword)
# $a1 y0 (0, 239) => 16 bits (halfword)
# $a2 cor1
# $a3 cor2

preenchimento:
		
		addi $sp, $sp, -24
		sw $fp, 20($sp) #Sera utilizada a pilha nao somente para a inicializacao e a finalizacao,
			       #mas tambem no meio do procedimento. Logo, se grava $fp, para poder
			       #acessar-se dados estaticos e verificar o fim do loop
		sw $ra, 16($sp)
		sw $s0, 12($sp)
		sw $s1, 8($sp)
		sw $s2, 4($sp)
		sw $s3, 0($sp)
		
		beq $a2, $a3, f_preenchiment #se as cores forem iguais nao faca nada
		
		move $fp, $sp #inicio dos dados dinamicos que serao usados nesse programa
		
		move $s0, $a2 #cor1
		move $s1, $a3 #cor2
		
		move $s2, $a0 #x
		move $s3, $a1 #y
		
		#ja estao setados os parametros
		#move $a0, $s2 #x
		#move $a1, $s3 #y
		#move $a2, $s0 #cor1
		
		jal is_color #verifica se a cor esta certa
		
		beq $v0, $zero, l_preenchiment #se a cor esta errada, nao coloque na pilha
		
		addi $sp, $sp, -4
		sh $a0, 2($sp)
		sh $a1, 0($sp)

l_preenchiment:
		
		beq $fp, $sp, f_preenchiment #se nao ha nenhum dado dinamico, termine
		
		lh $s2, 2($sp) #x
		lh $s3, 0($sp) #y
		addi $sp, $sp, 4
		
		move $a0, $s2 #x
		move $a1, $s3 #y
		move $a2, $s1 #cor2
		
		jal ponto #desenha
		
		addi $a0, $s2, -1 #x - 1
		addi $a1, $s3, 0 #y
		move $a2, $s0 #cor1
		
		jal is_color #verifica se a cor esta certa
		
		beq $v0, $zero, cont1 #se a cor esta errada, nao coloque na pilha
		
		addi $t0, $s2, -1 #x - 1
		addi $t1, $s3, 0 #y
		
		addi $sp, $sp, -4
		sh $t0, 2($sp) #x
		sh $t1, 0($sp) #y
cont1:		
		addi $a0, $s2, 1 #x + 1
		addi $a1, $s3, 0 #y
		move $a2, $s0 #cor1
		
		jal is_color #verifica se a cor esta certa
		
		beq $v0, $zero, cont2 #se a cor esta errada, nao coloque na pilha
		
		addi $t0, $s2, 1 #x + 1
		addi $t1, $s3, 0 #y
		
		addi $sp, $sp, -4
		sh $t0, 2($sp) #x
		sh $t1, 0($sp) #y
cont2:
		addi $a0, $s2, 0 #x
		addi $a1, $s3, -1 #y - 1
		move $a2, $s0 #cor1
		
		jal is_color #verifica se a cor esta certa
		
		beq $v0, $zero, cont3 #se a cor esta errada, nao coloque na pilha
		
		addi $t0, $s2, 0 #x
		addi $t1, $s3, -1 #y - 1
		
		addi $sp, $sp, -4
		sh $t0, 2($sp) #x
		sh $t1, 0($sp) #y
cont3:
		addi $a0, $s2, 0 #x
		addi $a1, $s3, 1 #y + 1
		move $a2, $s0 #cor1
		
		jal is_color #verifica se a cor esta certa
		
		beq $v0, $zero, l_preenchiment #se a cor esta errada, nao coloque na pilha
			
		addi $t0, $s2, 0 #x
		addi $t1, $s3, 1 #y + 1
		
		addi $sp, $sp, -4
		sh $t0, 2($sp) #x
		sh $t1, 0($sp) #y
		
		j l_preenchiment
		
f_preenchiment:		
		lw $fp, 20($sp)
		lw $ra, 16($sp)
		lw $s0, 12($sp)
		lw $s1, 8($sp)
		lw $s2, 4($sp)
		lw $s3, 0($sp)
		addi $sp, $sp, 24
		jr $ra

#funcao is_color
# $a0 x0
# $a1 y0
# $a2 cor
#Verifica se o ponto (x0, y0) tem a cor 'cor' (e esta na tela do display)
#Retorna 1 se estiver na tela, 0 se nao estiver

is_color:
		addi $sp, $sp, -16
		sw $ra, 12($sp)
		sw $s0, 8($sp)
		sw $s1, 4($sp)
		sw $s2, 0($sp)
		
		move $s0, $a0
		move $s1, $a1
		move $s2, $a2
		
		jal in_borders #verifica se (x0, y0) esta na tela
		
		move $t0, $v0 #esta na tela?
		move $v0, $zero #nao eh da cor certa
		
		beq $t0, $zero, f_is_color #se nao esta na tela, termina
		
		addiu $t0, $zero, 0xff000000 #endereco inicial mmio
		mul $t1,$s1, 320  #y * 320
		addu $t1, $t1, $s0 # y * 320 + x
		addu $t0, $t0, $t1 #0xff000000 + 320 * y + x
		lb $t0, 0($t0) #acha o cor do bit
		
		seq $v0, $t0, $s2 #se a cor for igual o retorno sera 1
		
f_is_color:	lw $ra, 12($sp)
		lw $s0, 8($sp)
		lw $s1, 4($sp)
		lw $s2, 0($sp)
		addi $sp, $sp, 16
		jr $ra


#funcao in_borders
# $a0 x0
# $a1 y0
#Verifica se o ponto (x0, y0) esta na tela do display
#Retorna 1 se estiver na tela, 0 se nao estiver

in_borders:
		li $t4, 319
		li $t5, 239
		
		slt $t0, $a0, $zero
		slt $t1, $t4, $a0
		
		or $t0, $t0, $t1
		
		slt $t2, $a1, $zero
		slt $t3, $t5, $a1
		
		or $t2, $t2, $t3
		
		or $t0, $t0, $t2 # $t0 = {1 se eh muito pequeno ou muito grande; 0 se esta na tela}
		sub $t0, $zero, $t0 # $t0 = {-1 se eh muito pequeno ou muito grande; 0 se esta na tela}
		addi $v0, $t0, 1  # $v0 = {0 se eh muito pequeno ou muito grande; 1 se esta na tela}
		jr $ra
