	org	0x0000
	mov	a, #0xff
	clr	c
shift:	rlc	a
	mov	p1, a
	call	delay
	sjmp	shift
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