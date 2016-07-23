	org	0x0000
input:	mov	r2, 0x00	; LIMPA O REGISTRADOR 'R2'.
	mov	r2, p1		; LE O DADO DE 'P1' PARA 'R2'.
	mov	a, r2		; COPIA O DADO PARA 'A'.
	jnz	delay		; SE 'A' NAO FOR NULO, COMECA O DELAY;
	jmp	input		; SE FOR, VOLTA A LER.
delay:	mov	r6, #0xfa	; --|
	mov	r7, #0xfa	;   |___ DELAYER
loop0:	djnz	r6, loop0	;   |
loop1:	djnz	r7, loop1	; --|
	jmp	input		; RETOMA LEITURA
	end