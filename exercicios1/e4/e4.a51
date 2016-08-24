	org	0x0000		;
input:	mov	a, 0x00		; limpa 'a'
	mov	a, p1		; move 'p1' para 'a'
	jnz	delay		; se 'a' nao for nulo, comeca delay
	jmp	input		; se for, le novamente
delay:	mov	r6, #0xfa	; carrega os registradores
	mov	r7, #0xfa	;
loop0:	djnz	r6, loop0	; decrementa os registradores
loop1:	djnz	r7, loop1	;
	djnz	a, delay	; faz delays ate que o 'a' zere
	jmp	input
	end