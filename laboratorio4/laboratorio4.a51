tb_ptr	equ	0x20
am_div	equ	0x21
fq_div	equ	0x22
tx_rst	equ	0x23
th_rst	equ	0x24
tl_rst	equ	0x25

	org	0x0000
	jmp	main

	org	0x000b
	jmp	it_timer0

	org	0x0023
	jmp	it_serial

	org	0x0100
main:
	mov	tb_ptr, #0x00
	mov	am_div, #0x00
	mov	fq_div, #0x00
	mov	th_rst, #0xd8
	mov	tl_rst, #0xf0
	mov	th0, th_rst
	mov	tl0, tl_rst
	mov	th1, #0xf3
	mov	tl1, #0xf3
	mov	scon, #0x50
	mov	tmod, #0x21
	mov	ie, #0x92
	mov	ip, #0x10
	setb	tr0
	setb	tr1
	jmp	$

it_timer0:
	djnz	fq_div, it_timer0_end
it_timer0_exe:
	mov	a, tb_ptr
	movc	a, @a+dptr
	mov	p0, a
	inc	tb_ptr		; o overflow e nosso amigo
	mov	fq_div, tx_rst
it_timer0_end:
	mov	th0, th_rst
	mov	tl0, tl_rst
	reti

it_serial:
	clr	tr0
	jnb	ri, $
	mov	a, #0x6d
	subb	a, sbuf
	dec	a
	jz	key_l
	dec	a
	jz	key_k
	dec	a
	jz	key_j
	dec	a
	jz	key_i
	dec	a
	jz	key_h
	jmp	it_serial_end
key_l:
	jb	fq_div.0, it_serial_end
	mov a, fq_div
	rr a
	mov fq_div, a
	jmp	it_serial_end
key_k:
	jb	am_div.0, it_serial_end
	mov a, am_div
	rr a
	mov am_div,a
	inc dph
	jmp	it_serial_end
key_j:
	jb	fq_div.2, it_serial_end
	mov a, fq_div
	rl a
	mov fq_div, a
	jmp	it_serial_end
key_i:
	jb	am_div.2, it_serial_end
	mov a, am_div
	rl a
	mov am_div,a
	jmp	it_serial_end
key_h:
	;jb	fq_div.2, it_serial_end
	;
	;
	jmp	it_serial_end
it_serial_end:
	clr	ti
	mov	sbuf, #0x00
	jnb	ti, $
	clr	ti
	clr	ri
	setb	tr0
	reti

	end