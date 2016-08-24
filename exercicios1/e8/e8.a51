	org	0x0000
	mov	r0, #0x12	; move o endereco 12h para 'r0'
	movx	a, @r0		; copia o conteudo de 12h na memoria externa
	mov	r3, a		; copia para 'r3'
	mov	r1, #0x11	; mesmo procedimento
	movx	a, @r1
	mov	r2, a
	mov	r0, #0x10	; mesmo procedimento
	movx	a, @r0
	cjne	r3, #0x7f, cmp	; compara o conteudo de 12h para determinar a operacao
sub:	subb	a, r2		; se for igual, opera subtracao
	jmp	nxt		; e continua
cmp:	jc	sub		; se for maior, subtrai
sum:	add	a, r2		; se for menor, soma
nxt:	movx	@r1, a		; move os resultados para a memoria externa novamente
	movx	@r0, a
	end