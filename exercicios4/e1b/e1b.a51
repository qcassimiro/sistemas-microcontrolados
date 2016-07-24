th0_rld	equ	0xfc
tl0_rld	equ	0x18
	org	0x0000
	jmp	begin
	org	0x000b
	jmp	it_timer0
	org	0x007b
begin:
	mov	th0, #th0_rld
	mov	tl0, #tl0_rld
	mov	ip, #0x00
	mov	ie, #0x82
	mov	tmod, #0x01
	setb	tr0
	jmp	$
it_timer0:
	cpl	p1.1
it_timer0_end:
	mov	th0, #th0_rld
	mov	tl0, #tl0_rld
	reti
	end