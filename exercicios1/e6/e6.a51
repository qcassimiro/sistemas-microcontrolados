table	equ	0x1000
	org	0x0000
	mov	p1, #0x00
	mov	dptr, #table
readt:	mov	a, #0x00
	movc	a, @a+dptr
	jz	empty
	orl	a, #0x30
	mov	p1, a
	inc	dptr
	call	delay
	jmp	readt
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
