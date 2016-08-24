	org	0x0000
	mov	a, #0xff	; seta todos os bits de 'a'
	clr	c		; limpa 'c'
shift:	rlc	a		; rotaciona 'a' com 'c', ligando 'a.0'
	mov	p1, a		; move resultado para 'p1'
	call	delay		; chama delay
	sjmp	shift		; continua rotacionando
delay:	mov	r5, #0xfa
loop2:	call	dl1ms
	call	dl1ms
	call	dl1ms
	call	dl1ms
	djnz	r5, loop2
	ret
dl1ms:	mov	r6, #0xfa
	mov	r7, #0xfa
loop0:	djnz	r6, loop0
loop1:	djnz	r7, loop1
	ret
	end