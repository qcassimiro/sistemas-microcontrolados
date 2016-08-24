table	equ	0x1000		; tabela armazenada apos o programa
	org	0x0000
	mov	p1, #0x00	; limpa 'p1'
	mov	dptr, #table	; move endereco da tabela para 'dptr'
readt:	mov	a, #0x00	; limpa 'a'
	movc	a, @a+dptr	; copia o primeiro byte da tabela para 'a'
	jz	empty		; se for zero, a tabela acabou
	orl	a, #0x30	; acrescenta #0x30 para converter em ascii
	mov	p1, a		; move para 'p1'
	inc	dptr		; incrementa endereco
	call	delay		; comeca delay
	jmp	readt		; apos o delay, continua lendo a tabela
delay:	mov	r5, #0x0a
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
empty:	mov	p1, #0x00
	org	table
	db	0x01, 0x02, 0x03, 0x04, 0x05, 0x06, 0x07, 0x08, 0x09, 0x00
	end
