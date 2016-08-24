	org	0x0000
	; mde -> mdiex
	mov	r0, #0x10	; move o endereco 10h para 'r0'
	mov	r1, #0x90	; move o endereco 90h para 'r1'
	mov	r2, #0x00	; move desvio de 00 bytes para 'r2'
copya:	movx	a, @r0		; copia o byte da memoria externa para 'a'
	mov	@r1, a		; copia o valor para a memoria interna extendida
	inc	r0		; incrementa o endereco da mde
	inc	r1		; incrementa o endereco da mdiex
	inc	r2		; incrementa desvio da mde
	mov	a, r2		; copia o desvio para 'a'
	cjne	a, #0x40, copya	; se nao for 64, continua
	; mdiex -> mde
	mov	r0, #0x90	; move o endereco 90h para 'r0'
	mov	r1, #0x10	; move o endereco 10h para 'r1'
	mov	r2, #0x00	; move desvio de 00 bytes para 'r2'
copyb:	mov	a, @r0		; copia o byte da memoria interna extendida para 'a'
	movx	@r1, a		; copia o valor para a memoria externa
	inc	r0		; incrementa o endereco da mdiex
	inc	r1		; incrementa o endereco da mde
	inc	r2		; incrementa desvio da mdiex
	mov	a, r2		; copia o desvio para 'a'
	cjne	a, #0x40, copyb	; se nao for 64, continua
empty:	mov	p1, #0x00	; indica termino
	end

