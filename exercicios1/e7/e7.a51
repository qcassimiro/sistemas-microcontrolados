dt	equ	0x0100
lo	equ	0x03
hi	equ	0x04
	org	0x0000
	mov	lo, #0x00
	mov	hi, #0x00
	mov	0x10, #0xc0
	mov	0x11, #0xf9
	mov	0x12, #0xa4
	mov	0x13, #0xb0
	mov	0x14, #0x99
	mov	0x15, #0x92
	mov	0x16, #0x82
	mov	0x17, #0xf8
	mov	0x18, #0x80
	mov	0x19, #0x90
	mov	0x20, #0xbf
	mov	dptr, #dt
	mov	a, #0x00
	movc	a, @a+dptr
	setb	c
	cjne	a, #0x63, cerro
	jmp	cnvdt
cerro:	jnc	error
	mov	r2, a
cnvdt:	call	incdt
	djnz	r2, cnvdt
	sjmp	write
incdt:	mov	a, lo
	cjne	a, #0x09, inclo
	mov	lo, #0x00
	mov	a, hi
	cjne	a, #0x09, inchi
inclo:	inc	lo
	ret
inchi:	inc	hi
	ret
error:	mov	lo, #10h
	mov	hi, #10h
write:	mov	a, lo
	add	a, #10h
	mov	r0, a
	mov	a, hi
	add	a, #10h
	mov	r1, a
	mov	p1, @r0
	mov	p3, @r1
	org	dt
	db	0x03
	end