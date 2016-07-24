tm0	equ	0x4c
tn0	equ	0x4a
tm0_rld	equ	0x0a
tn0_rld	equ	0x28
th0_rld	equ	0x3c
tl0_rld	equ	0xb0
	org	0x0000
	jmp	begin
	org	0x000b
	jmp	it_timer0
	org	0x007b
begin:
	mov	tm0, #tm0_rld
	mov	tn0, #tn0_rld
	mov	th0, #th0_rld
	mov	tl0, #tl0_rld
	mov	ip, #0x00
	mov	ie, #0x82
	mov	tmod, #0x01
	setb	tr0
	jmp	$
it_timer0:
	djnz	tm0, it_timer0_end
	inc	tm0
	djnz	tn0, it_timer0_end
	cpl	p1.1
	mov	tn0, tn0_rld
it_timer0_end:
	mov	th0, #th0_rld
	mov	tl0, #tl0_rld
	reti
	end