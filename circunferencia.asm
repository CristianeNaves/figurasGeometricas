.data
	bmpAdd: .word 0xFF000000	# endereco inicial do display
	largura: .word 320		# largura da tela em pixels
	altura: .word 240		# altura da tela em pixels
.text	
main:
	# Essas instrucoes apenas carregam os valores de X, Y, raio e a cor nos registradores de argumento
	ori $a0, $zero, 160	# X = 160
	ori $a1, $zero, 120	# Y = 120
	ori $a2, $zero, 60	# Raio = 60
	ori $a3, $zero, 0x07	# cor = 0x07
	jal circulo
	
	ori $a0, $zero, 160	# X = 160
	ori $a1, $zero, 120	# Y = 120
	ori $a2, $zero, 0x07	# cor = 0x07
	jal preenchimento2
	
	ori $a0, $zero, 160	# X = 160
	ori $a1, $zero, 120	# Y = 120
	ori $a2, $zero, 50	# Raio = 50
	ori $a3, $zero, 0x38	# cor = 0x38
	jal circulo
	
	ori $a0, $zero, 160	# X = 160
	ori $a1, $zero, 120	# Y = 120
	ori $a2, $zero, 0x38	# cor = 0x38
	jal preenchimento2
	
	ori $a0, $zero, 160	# X = 160
	ori $a1, $zero, 120	# Y = 120
	ori $a2, $zero, 40	# Raio = 40
	ori $a3, $zero, 0xc0	# cor = 0xC0
	jal circulo
	
	ori $a0, $zero, 160	# X = 160
	ori $a1, $zero, 120	# Y = 120
	ori $a2, $zero, 0xc0	# cor = 0xC0
	jal preenchimento2
	
	ori $a0, $zero, 160	# X = 160
	ori $a1, $zero, 120	# Y = 120
	ori $a2, $zero, 30	# Raio = 30
	ori $a3, $zero, 0xff	# cor = 0xFF
	jal circulo
	
	ori $a0, $zero, 160	# X = 160
	ori $a1, $zero, 120	# Y = 120
	ori $a2, $zero, 0xff	# cor = 0xFF
	jal preenchimento2
	
	ori $a0, $zero, 160	# X = 160
	ori $a1, $zero, 120	# Y = 120
	ori $a2, $zero, 20	# Raio = 20
	ori $a3, $zero, 0x00	# cor = 0x00
	jal circulo
	
	ori $a0, $zero, 160	# X = 160
	ori $a1, $zero, 120	# Y = 120
	ori $a2, $zero, 0x00	# cor = 0x00
	jal preenchimento2
	
	ori $a0, $zero, 160	# X = 160
	ori $a1, $zero, 120	# Y = 120
	ori $a2, $zero, 10	# Raio = 10
	ori $a3, $zero, 0xfa	# cor = 0xFA
	jal circulo
	
	ori $a0, $zero, 160	# X = 160
	ori $a1, $zero, 120	# Y = 120
	ori $a2, $zero, 0xfa	# cor = 0xFA
	jal preenchimento2
	
	ori $a0, $zero, 309
	ori $a1, $zero, 229
	ori $a2, $zero, 9
	ori $a3, $zero, 0x56
	jal circulo
	
	ori $a0, $zero, 311
	ori $a1, $zero, 231
	ori $a2, $zero, 0x56
	jal preenchimento2
	
	j exit

# Funcao que desenha um ponto dadas coordenadas (X, Y)	
ponto:
	addiu $t0, $zero, 0xff000000 #endereco inicial mmio
	mul $t1,$a1, 320  #y * 320
	addu $t1, $t1, $a0 # y * 320 + x
	addu $t0, $t0, $t1 #0xff000000 + 320 * y + x
	sb $a2, 0($t0) #desenha
	jr $ra
	
# A funcao a seguir utiliza o "midpoint circle algorithm" para realizar o desenho do circulo.
# https://en.wikipedia.org/wiki/Midpoint_circle_algorithm
circulo:
	or $s0, $zero, $a0	# copia a0 em s0 = X0
	or $s1, $zero, $a1	# copia a1 em s1 = Y0
	sub $s2, $zero, $a2	# s2 = inverso do raio (-raio)
	or $s3, $zero, $a3	# copia a3 em s3 = cor
	or $s4, $zero, $a2	# copia a2 em s4 = raio
	ori $s5, $zero, 0	# s5 = Y = 0
	
# Loop para desenhar o circilo. A ideia e dividir o circulo em quadrantes e desenhar em cada um de forma simultanea	
loop_circulo:

	blt $s4, $s5 loop_circuloFIM	# condicao de saida valida apenas quando X for menor que Y		

	add $a0, $s0, $s4		# a0 = X0 + X
	add $a1, $s1, $s5		# a1 = Y0 + Y
	or $a2, $zero, $s3		# a2 = valor da cor
	addi $sp, $sp, -4		# cria espaco na pilha
	sw $ra, 0($sp)			# empilha o valor de $ra para retorna a funcao principal
	jal ponto			# chamada p/ a funcao ponto
	
	add $a0, $s0, $s5		# = a0 = X0 + Y
	add $a1, $s1, $s4		# = a1 = Y0 + X
	or $a2, $zero, $s3		# = cor
	jal ponto			# chamada p/ a funcao ponto
	
	sub $a0, $s0, $s5		# a0 = X0 - Y
	add $a1, $s1, $s4		# a1 = Y0 + X
	or $a2, $zero, $s3		# a2 = cor
	jal ponto			# chamada p/ a funcao ponto
	
	sub $a0, $s0, $s4		# a0 = X0 - X
	add $a1, $s1, $s5		# a1 = Y0 + Y
	or $a2, $zero, $s3		# a2 = cor
	jal ponto			# chamada p/ a funcao ponto
	
	sub $a0, $s0, $s4		# a0 = X0 - X
	sub $a1, $s1, $s5		# a1 = Y0 - Y
	or $a2, $zero, $s3		# = cor
	jal ponto			# chamada p/ a funcao ponto
	
	sub $a0, $s0, $s5		# a2 = X0 - Y
	sub $a1, $s1, $s4		# a1 = Y0 - X
	or $a2, $zero, $s3		# = cor
	jal ponto			# chamada p/ a funcao ponto
	
	add $a0, $s0, $s5		# a0 = X0 + Y
	sub $a1, $s1, $s4		# a1 = Y0 - X
	or $a2, $zero, $s3		# a2 = cor
	jal ponto			# chamada p/ a funcao ponto
	
	add $a0, $s0, $s4		# = X0 + X
	sub $a1, $s1, $s5		# = Y0 - Y
	or $a2, $zero, $s3		# a2 = cor
	jal ponto			# chamada p/ a funcao ponto
	
					
	addi $s5, $s5, 1		# Y = Y + 1
	add $s2, $s2, $s5		# err = err + Y
	add $s2, $s2, $s5		# err = err + Y

	bltz $s2, loop_circulo		# Se err for menor que 0, repete o loop
					
	addi $s4, $s4, -1		# X = X - 1
	sub $s2, $s2, $s4		# err = err - X
	sub $s2, $s2, $s4		# err = err - X
		
	j loop_circulo			# repete o loop	
	
loop_circuloFIM:
	lw $ra, 0($sp)			# recupera o valor de $ra
	addi $sp, $sp 4			# restaura a posicao de sp
	jr $ra				# retorna a funcao main
	
exit:
	li $v0, 10	# chamada p/ encerrar o programa
	syscall
	
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


# Função reta recebe:
# $a0 coordenada x do primeiro ponto (x0)
# $a1 coordenada y do primeiro ponto (y0)
# $a2 coordenada x do segundo ponto (x1)
# $a3 coordenada y do segundo ponto (y1)
# $t0 cor da reta