dt	equ	0x0100
lo	equ	0x03		; reserva registrador para unidade
hi	equ	0x04		; e para dezena
	org	0x0000
	mov	lo, #0x00	; zera os digitos
	mov	hi, #0x00	;
	mov	0x10, #0xc0	; carrega registradores com sua codificacao
	mov	0x11, #0xf9	; decimal ja pronta. 0x15 -> 5 -> #0x92
	mov	0x12, #0xa4
	mov	0x13, #0xb0
	mov	0x14, #0x99
	mov	0x15, #0x92
	mov	0x16, #0x82
	mov	0x17, #0xf8
	mov	0x18, #0x80
	mov	0x19, #0x90
	mov	0x20, #0xbf
	mov	dptr, #dt	; carrega 'dptr' com endereco do byte
	mov	a, #0x00	; zera 'a'
	movc	a, @a+dptr	; le o byte
	setb	c		; seta 'c'
	cjne	a, #0x63, cerro	; 63h = 99d, se nao for igual vai para cerro
	jmp	cnvdt		; se for, converte para decimal
cerro:	jnc	error		; se for maior, executa rotina de erro
	mov	r2, a		; se for menor, converte para decimal
cnvdt:	call	incdt		; rotina de conversao, chama o incremento dos digitos
	djnz	r2, cnvdt	; enquanto o dado nao for nulo, continua incrementando
	jmp	write		; quando acaba a conversao, escreve os dados
incdt:	mov	a, lo		; move a unidade para 'a'
	cjne	a, #0x09, inclo	; se nao for 9, incrementa
	mov	lo, #0x00	; se for, volta pra zero
	mov	a, hi		; e incrementa a dezena
	cjne	a, #0x09, inchi	; mesma logica com a dezena
inclo:	inc	lo
	ret
inchi:	inc	hi
	ret
error:	mov	lo, #10h	; quando houver erro, carrega a dezena e a unidade com 10
	mov	hi, #10h	; que na logica de conversao e transformado em -
write:	mov	a, lo		; move unidade para 'a'
	add	a, #10h		; soma 10h para usar o endereco correto do registrador
	mov	r0, a		; move o endereco para 'r0'
	mov	a, hi		;
	add	a, #10h		; mesma logica para a dezena
	mov	r1, a		;
	mov	p1, @r0		; move os conteudos para os ports equivalentes
	mov	p3, @r1
	org	dt
	db	0x03
	end