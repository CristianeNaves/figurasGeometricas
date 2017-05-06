.data

pi:		.word 0x40490fdb
pi4:		.word 0x3f490fdb
pi2:		.word 0x3fc90fdb

.text

main:		li $a0, 2
		li $a1, 0
		jal exp_int
		move $s0, $v0
		
		li $a0, 3
		li $a1, 3
		jal exp_int
		move $s1, $v0
		
		li $a0, 4
		li $a1, 1
		jal exp_int
		move $s2, $v0
		
		li $t0, 0
		mtc1 $t0, $f0
		cvt.s.w $f0, $f0
		mfc1 $t0, $f0
		move $a0, $t0
		jal cos
		move $s3, $v0
		
		li $t0, 0
		mtc1 $t0, $f0
		cvt.s.w $f0, $f0
		mfc1 $t0, $f0
		move $a0, $t0
		jal sin
		move $s4, $v0
		
		la $t1, pi4
		lw $t0, 0($t1)
		move $a0, $t0
		jal cos
		move $s5, $v0
		
		la $t1, pi4
		lw $t0, 0($t1)
		move $a0, $t0
		jal sin
		move $s6, $v0
		
		li $a0, 150
		li $a1, 120
		li $a2, 150
		li $a3, 120
		li $t0, 50
		li $t1, 50
		li $t2, 0x38
		jal elipse
		
		li $a0, 100
		li $a1, 100
		li $a2, 100
		li $a3, 100
		li $t0, 10
		li $t1, 10
		li $t2, 0x07
		jal elipse
		
		li $a0, 150
		li $a1, 100
		li $a2, 150
		li $a3, 140
		li $t0, 30
		li $t1, 10
		li $t2, 0xc0
		jal elipse
		
		li $a0, 160
		li $a1, 170
		li $a2, 180
		li $a3, 170
		li $t0, 10
		li $t1, 30
		li $t2, 0x01
		jal elipse
		
		li $a0, 160
		li $a1, 160
		li $a2, 180
		li $a3, 180
		li $t0, 10
		li $t1, 30
		li $t2, 0x01
		jal elipse
		
		li $v0, 10
		syscall

#Funcao elipse;
#a0 x1
#a1 y1
#a2 x2
#a3 y2
#t0 r1
#t1 r2
#t2 cor

elipse:
		add $sp, $sp, -36
		sw $ra, 32($sp)
		sw $s0, 28($sp)
		sw $s1, 24($sp)
		sw $s2, 20($sp)
		sw $s3, 16($sp)
		sw $s4, 12($sp)
		sw $s5, 8($sp)
		sw $s6, 4($sp)
		sw $s7, 0($sp)
		
		# s0 = x_c
		# s1 = a
		# s2 = y_c
		# s3 = b
		# s4 = phase
		# s5 = cor
		#tal que o ponto P = (x_c + a * cos(phase + t), y_c + b * cos(phase + t)) esta na elipse
		
		add $s0, $a0, $a2
		sra $s0, $s0, 1 #s0 = (x1+x2)/2;
		
		add $s1, $t0, $t0 #s1 = 2 * r1
		
		add $s2, $a1, $a3
		sra $s2, $s2, 1 #s2 = (y1+y2)/2;
		
		add $s3, $t1, $t1 #s1 = 2 * r2
		
		move $s5, $t2 #s5 = cor

		bne $a0, $a2, div_nao_zero # Se x1 != x2, nao havera divisao por 0
		bne $a1, $a3, div_nao_zero # Se x1 != x2, nao havera divisao por 0
div_zero:	
		mtc1 $zero $f0
		cvt.s.w $f0, $f0
		mfc1 $s4, $f0 #s4 = 0
		j c_elipse
div_nao_zero:	
		sub $t0, $a3, $a1 #t0 = y2 - y1
		sub $t1, $a2, $a0 #t1 = x2 - x1
		
		mult $t0, $t0
		mflo $t2 #t2 = (y2 - y1)^2
		
		mult $t1, $t1
		mflo $t3 #t3 = (x2 - x1)^2
		
		add $t1, $t2, $t3 #t1 = (x2 - x1)^2 + (y2 - y1)^2
		#t0 = y2 - y1
		
		mtc1 $t0, $f0
		mtc1 $t1, $f1
		cvt.s.w $f0, $f0
		cvt.s.w $f1, $f1
		
		sqrt.s $f1, $f1 #f1 = sqrt((x2 - x1)^2 + (y2 - y1)^2)
		div.s $f0, $f0, $f1 # f0 = (y1 - y0) / sqrt((x2 - x1)^2 + (y2 - y1)^2)
		
		mfc1 $a0, $f0
		jal arccos
		
		move $s4, $v0 # s4 (phase) = arccos( (y1 - y0) / sqrt((x2 - x1)^2 + (y2 - y1)^2) )
		
c_elipse:	
		mtc1 $zero, $f0
		cvt.s.w $f0, $f0
		
		la $t0, pi2
		lwc1 $f31, 0($t0)
		
		sub.s $f31, $f0, $f31
		
		li $t0, 560
		mtc1, $t0, $f0
		cvt.s.w $f0 $f0
		
		la $t0, pi
		lwc1 $f30, 0($t0) #f30 = pi
		div.s $f30, $f30, $f0 #f30 = pi / 560, passo iterativo
		
		mtc1 $s4, $f29 #f29 = phase
		
		la $t0, pi2
		lwc1 $f28, 0($t0) #f30 = pi / 4
		
		li $t0, 1000
		mtc1 $t0, $f27
		cvt.s.w $f27, $f27 #constante para a multiplicacao
		
l_elipse:	### x
		add.s $f0, $f29, $f31 #phase + t
		
		mfc1 $a0, $f0
		jal cos
		
		
		mtc1 $v0, $f0 # -1 <= cos(phase + t) <= 1
		mul.s $f0, $f0, $f27 # multiplica por constante -1000 <= f0 <= 1000
		cvt.w.s $f0, $f0 #inteiroS
		mfc1 $t0, $f0
		
		mult $t0, $s1
		mflo $t0 # a * 1000 * cos(phase + t)
		li $t1, 1000
		div $t0, $t1
		mflo $t0 #a * cos(phase + t)
		
		add $s6, $s0, $t0 #s6 (x) = x_c + a * cos(phase + t)
		
		### y
		add.s $f0, $f29, $f31 #phase + t
		
		mfc1 $a0, $f0
		jal sin
		
		mtc1 $v0, $f0 #sin(phase + t)
		mul.s $f0, $f0, $f27 # multiplica por constante -1000 <= f0 <= 1000
		cvt.w.s $f0, $f0 #inteiro
		mfc1 $t0, $f0
		
		mult $t0, $s3
		mflo $t0 # b *1000 * sin(phase + t)
		li $t1, 1000
		div $t0, $t1
		mflo $t0 #a * sin(phase + t)
		
		add $s7, $s2, $t0 #s7 (y) = y_c + b * sin(phase + t)
		
		move $a0, $s6
		move $a1, $s7
		jal in_borders
		
		beq $v0, $zero f_elipse
		
		add $a0, $zero, $s6
		add $a1, $zero, $s7
		add $a2, $zero, $s5
		jal ponto #pinta
		sub $a0, $zero, $s6
		add $a0, $a0, $s0
		add $a0, $a0, $s0
		add $a1, $zero, $s7
		add $a2, $zero, $s5
		jal ponto #pinta
		add $a0, $zero, $s6
		sub $a1, $zero, $s7
		add $a1, $a1, $s2
		add $a1, $a1, $s2
		add $a2, $zero, $s5
		jal ponto #pinta
		sub $a0, $zero, $s6
		add $a0, $a0, $s0
		add $a0, $a0, $s0
		sub $a1, $zero, $s7
		add $a1, $a1, $s2
		add $a1, $a1, $s2
		add $a2, $zero, $s5
		jal ponto #pinta
		
		add.s $f31, $f31, $f30 #t = t + passo iterativo
		
		c.lt.s $f31, $f28 # t eh menor que o final (2*pi) ?
		
		bc1t l_elipse 
		
f_elipse:	
		lw $ra, 32($sp)
		lw $s0, 28($sp)
		lw $s1, 24($sp)
		lw $s2, 20($sp)
		lw $s3, 16($sp)
		lw $s4, 12($sp)
		lw $s5, 8($sp)
		lw $s6, 4($sp)
		lw $s7, 0($sp)
		add $sp, $sp, 36
		jr $ra

#Funcao arccos
#a0 x ponto flutuante
#v0 resultado ponto flutuante
arccos:		
		add $sp, $sp, -16
		sw $ra, 12($sp)
		sw $s0, 8($sp)
		sw $s1, 4($sp)
		sw $s2, 0($sp)
		
		move $s0, $a0 #valor que sera utilizado, x
		
		la $t0, pi2
		lw $s1, 0($t0) #resultado = pi/2
		
		mtc1 $s1, $f0
		mtc1 $s0, $f1 # x
		
		sub.s $f0, $f0, $f1
		mfc1 $s1, $f0 #resultado = pi/2 -x
		
		li $s2, 6 #fator da divisao s2 = 3!
		
		move $a0, $s0
		li $a1, 3
		jal exp #x^3
				
		move $a0, $v0
		move $a1, $s2
		jal div_f_i #x^3/3!
		
		mtc1 $s1, $f0
		mtc1 $v0, $f1
		
		sub.s $f0, $f0, $f1
		mfc1 $s1, $f0 #resultado = 1 -x -x^3/3!
		
		move $v0, $s1 #arccos($a0) = 1 -x -x^3/3!
		
		lw $ra, 12($sp)
		lw $s0, 8($sp)
		lw $s1, 4($sp)
		lw $s2, 0($sp)
		add $sp, $sp, 16
		jr $ra

#Funcao sin
#a0 x ponto flutuante
#v0 resultado ponto flutuante
sin:		
		add $sp, $sp, -16
		sw $ra, 12($sp)
		sw $s0, 8($sp)
		sw $s1, 4($sp)
		sw $s2, 0($sp)
		
		move $s0, $a0 #valor que sera utilizado
		
		move $s1, $s0 #resultado = x
		
		li $s2, 6 #fator da divisao = 6 = 3!
		
		move $a0, $s0
		li $a1, 3
		jal exp #x^3
		
		move $a0, $v0
		move $a1, $s2
		jal div_f_i #x^3/3!
		
		mtc1 $s1, $f0
		mtc1 $v0, $f1
		
		sub.s $f0, $f0, $f1
		mfc1 $s1, $f0 #resultado = x -x^3/3!
		
		ori $t0, $zero, 4
		mult $s2, $t0
		mflo $s2 #s2 = 4!
		ori $t0, $zero, 5
		mult $s2, $t0
		mflo $s2 #s2 = 5!
		
		move $a0, $s0
		li $a1, 5
		jal exp #x^5
				
		move $a0, $v0
		move $a1, $s2
		jal div_f_i #x^5/5!
		
		mtc1 $s1, $f0
		mtc1 $v0, $f1
		
		add.s $f0, $f0, $f1
		mfc1 $s1, $f0 #resultado = 1 -x^3/3! + x^5/5!
		
		ori $t0, $zero, 6
		mult $s2, $t0
		mflo $s2 #s2 = 6!
		ori $t0, $zero, 7
		mult $s2, $t0
		mflo $s2 #s2 = 7!
		
		move $a0, $s0
		li $a1, 7
		jal exp #x^7
				
		move $a0, $v0
		move $a1, $s2
		jal div_f_i #x^7/7!
		
		mtc1 $s1, $f0
		mtc1 $v0, $f1
		
		sub.s $f0, $f0, $f1
		mfc1 $s1, $f0 #resultado = 1 -x^3/3! + x^5/5! - x^7/7!
		
		ori $t0, $zero, 8
		mult $s2, $t0
		mflo $s2 #s2 = 8!
		ori $t0, $zero, 9
		mult $s2, $t0
		mflo $s2 #s2 = 9!
		
		move $a0, $s0
		li $a1, 9
		jal exp #x^9
				
		move $a0, $v0
		move $a1, $s2
		jal div_f_i #x^9/9!
		
		mtc1 $s1, $f0
		mtc1 $v0, $f1
		
		add.s $f0, $f0, $f1
		mfc1 $s1, $f0 #resultado = 1 -x^3/3! + x^5/5! - x^7/7! + x^9/9!
		
		move $v0, $s1 #sin($a0) = 1 -x^3/3! + x^5/5! - x^7/7! + x^9/9!
		
		lw $ra, 12($sp)
		lw $s0, 8($sp)
		lw $s1, 4($sp)
		lw $s2, 0($sp)
		add $sp, $sp, 16
		jr $ra

#Funcao cos
#a0 x ponto flutuante
#v0 resultado ponto flutuante
cos:		
		add $sp, $sp, -16
		sw $ra, 12($sp)
		sw $s0, 8($sp)
		sw $s1, 4($sp)
		sw $s2, 0($sp)
		
		move $s0, $a0 #valor que sera utilizado
		
		li $s1, 1
		mtc1 $s1, $f0
		cvt.s.w $f0, $f0
		mfc1 $s1, $f0 #resultado = 1
		
		li $s2, 2 #fator da divisao = 2 = 2!
		
		move $a0, $s0
		li $a1, 2
		jal exp #x^2
		
		move $a0, $v0
		move $a1, $s2
		jal div_f_i #x^2/2!
		
		mtc1 $s1, $f0
		mtc1 $v0, $f1
		
		sub.s $f0, $f0, $f1
		mfc1 $s1, $f0 #resultado = 1 -x^2/2!
		
		ori $t0, $zero, 3
		mult $s2, $t0
		mflo $s2 #s2 = 3!
		ori $t0, $zero, 4
		mult $s2, $t0
		mflo $s2 #s2 = 4!
		
		move $a0, $s0
		li $a1, 4
		jal exp #x^4
				
		move $a0, $v0
		move $a1, $s2
		jal div_f_i #x^4/4!
		
		mtc1 $s1, $f0
		mtc1 $v0, $f1
		
		add.s $f0, $f0, $f1
		mfc1 $s1, $f0 #resultado = 1 -x^2/2! + x^4/4!
		
		ori $t0, $zero, 5
		mult $s2, $t0
		mflo $s2 #s2 = 5!
		ori $t0, $zero, 6
		mult $s2, $t0
		mflo $s2 #s2 = 6!
		
		move $a0, $s0
		li $a1, 6
		jal exp #x^6
				
		move $a0, $v0
		move $a1, $s2
		jal div_f_i #x^6/6!
		
		mtc1 $s1, $f0
		mtc1 $v0, $f1
		
		sub.s $f0, $f0, $f1
		mfc1 $s1, $f0 #resultado = 1 -x^2/2! + x^4/4! - x^6/6
		
		ori $t0, $zero, 7
		mult $s2, $t0
		mflo $s2 #s2 = 7!
		ori $t0, $zero, 8
		mult $s2, $t0
		mflo $s2 #s2 = 8!
		
		move $a0, $s0
		li $a1, 8
		jal exp #x^8
				
		move $a0, $v0
		move $a1, $s2
		jal div_f_i #x^8/8!
		
		mtc1 $s1, $f0
		mtc1 $v0, $f1
		
		add.s $f0, $f0, $f1
		mfc1 $s1, $f0 #resultado = 1 -x^2/2! + x^4/4! - x^6/6 + x^8/8!
		
		move $v0, $s1 #cos($a0) = 1 -x^2/2! + x^4/4! - x^6/6 + x^8/8!
		
		lw $ra, 12($sp)
		lw $s0, 8($sp)
		lw $s1, 4($sp)
		lw $s2, 0($sp)
		add $sp, $sp, 16
		jr $ra

#Funcao div_f_i
#a0 dividendo PONTO FLUTUANTE
#a1 divisor INTEIRO
#v0 resultado PONTO FLUTUANTE

div_f_i:	
		
		mtc1 $a0, $f0
		mtc1 $a1, $f1
		
		cvt.s.w $f1, $f1
		
		div.s $f0, $f0, $f1
		
		mfc1 $v0, $f0
		
		jr $ra

#Funcao exp_int:
#a0 base -> INTEIRO
#a1 expoente -> INTEIRO POSITIVO
#v0 resultado -> INTEIRO
#exponenciacao rapida

exp_int:		
		add $sp, $sp, -4
		sw $ra, 0($sp)

		mtc1 $a0, $f0
		cvt.s.w $f0, $f0
		mfc1 $a0, $f0 # a0 = a0 (inteiro) em ponto flutante
		
		jal exp
		
		mtc1 $v0, $f0
		cvt.w.s $f0, $f0
		mfc1 $v0, $f0 #v0 = v0 (ponto flutuante) em inteiro

		lw $ra, 0($sp)
		add $sp, $sp, 4
		jr $ra

#Funcao exp:
#a0 base -> PONTO FLUTUANTE
#a1 expoente -> INTEIRO POSITIVO
#v0 resultado -> PONTO FLUTUANTE
#exponenciacao rapida

exp:		
		add $sp, $sp, -4
		sw $s0, 0($sp)
		
		mtc1 $a0, $f0 #f0 = base
		move $s0, $a1 #s0 = expoente
		
		li $t0, 1
		mtc1 $t0, $f1
		cvt.s.w $f1, $f1 #f1 = 1
		
l_exp:		beq $s0, $zero, f_exp
		andi $t0, $s0, 1 #ultimo bit
		beq $t0, $zero, c_exp #se nao der resto por 2 continue
		mul.s $f1, $f1, $f0 # f1 = f1 * f0
c_exp:		
		mul.s $f0, $f0, $f0 #f0 = f0^2
		srl $s0, $s0, 1
		j l_exp
f_exp:		
		mfc1 $v0, $f1
		
		lw $s0, 0($sp)
		add $sp, $sp, 4
		jr $ra

#Copia de ponto.asm

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
