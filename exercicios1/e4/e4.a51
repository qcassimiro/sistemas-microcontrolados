	org	0x0000
input:	mov	a, 0x00
	mov	a, p1
	jnz	delay
	jmp	input
delay:	mov	r6, #0xfa
	mov	r7, #0xfa
loop0:	djnz	r6, loop0
loop1:	djnz	r7, loop1
	jmp	input
	end